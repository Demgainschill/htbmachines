import cryptocode, sys

blob = "e9laWoKiJ0OdwK05b3hG7xMD+uIBBwl/v01lBRD+pntORa6Z/Xu/TdN3aG/ksAA0Sz55/kLggw==*xHnWpIqBWc25rrHFGPzyTg==*4Nt/05WUbySGyvDgSlpoUw==*u65Jfe0ml9BFaKEviDCHBQ=="

wl = sys.argv[1] if len(sys.argv) > 1 else "/usr/share/wordlists/rockyou.txt"
with open(wl, "r", errors="ignore") as f:
    for i, line in enumerate(f, 1):
        pw = line.strip()
        if not pw:
            continue
        out = cryptocode.decrypt(blob, pw)
        if out:
            print("[+] master:", pw)
            print(out)
            break
        if i % 50000 == 0:
            print("...", i, file=sys.stderr)
