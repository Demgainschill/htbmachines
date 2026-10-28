#!/usr/bin/env python3
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import hashlib, os, base64, json

KEY = b"bLs6z8iv3gWpsvyeabFosDjb4YQe7jdU13rI"
key = hashlib.sha256(KEY).digest()

def encrypt(payload_dict, compact=False):
    aesgcm = AESGCM(key)
    iv = os.urandom(12)
    if compact:
        data = json.dumps(payload_dict, separators=(',', ':')).encode()
    else:
        data = json.dumps(payload_dict).encode()
    ciphertext = aesgcm.encrypt(iv, data, None)
    combined = iv + ciphertext
    return base64.b64encode(combined).decode()

payload = {"transcription": "hello", "summary": "world"}

print("SPACED:", encrypt(payload, compact=False))
print("COMPACT:", encrypt(payload, compact=True))
