#!/usr/bin/env python3
import webbrowser
import time
import sys

delay = float(sys.argv[2]) if len(sys.argv) > 2 else 2.0
with open(sys.argv[1]) as f:
    for line in f:
        host = line.strip()
        if not host or host.startswith('#'):
            continue
        url = f"https://{host}" if not host.startswith('http') else host
        print(f"Opening {url}")
        webbrowser.open_new_tab(url)
        time.sleep(delay)
