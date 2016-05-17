namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.IO;
    using System.Runtime.CompilerServices;
    using System.Threading;

    internal class Persistance
    {
        private static List<WeakReference> __ENCList = new List<WeakReference>();
        private int _interval;
        private int exitcode;
        private string hash;
        private string name;
        private bool running;

        public event ErrorEventHandler Error;

        public event StopCallbackEventHandler StopCallback;

        public Persistance()
        {
            __ENCAddToList(this);
            this.name = string.Empty;
            this.hash = string.Empty;
            this.running = false;
            this.exitcode = 0;
            this._interval = 100;
            this.name = Process.GetCurrentProcess().ProcessName;
            this.hash = this.GetProcessHash(Process.GetCurrentProcess());
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

        [CompilerGenerated]
        private void _Lambda$__4()
        {
            try
            {
                while (this.running)
                {
                    if (this.CountProcesses() < 2)
                    {
                        if (!File.Exists(this.name + ".exe"))
                        {
                            throw new Exception("The process cannot be started because the file does not exist");
                        }
                        if (this.IsWatcher)
                        {
                            Process.Start(this.name);
                        }
                        else
                        {
                            Process.Start(this.name, this.hash);
                        }
                    }
                    Thread.Sleep(this._interval);
                }
                this.KillWatchers();
                StopCallbackEventHandler stopCallbackEvent = this.StopCallbackEvent;
                if (stopCallbackEvent != null)
                {
                    stopCallbackEvent(this, this.exitcode);
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception ex = exception1;
                ErrorEventHandler errorEvent = this.ErrorEvent;
                if (errorEvent != null)
                {
                    errorEvent(this, ex);
                }
                ProjectData.ClearProjectError();
            }
        }

        private int CountProcesses()
        {
            int num = 0;
            try
            {
                foreach (Process process in Process.GetProcessesByName(this.name))
                {
                    if (this.GetProcessHash(process) == this.hash)
                    {
                        num++;
                    }
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception ex = exception1;
                ErrorEventHandler errorEvent = this.ErrorEvent;
                if (errorEvent != null)
                {
                    errorEvent(this, ex);
                }
                ProjectData.ClearProjectError();
            }
            return num;
        }

        private string GetProcessHash(Process p)
        {
            try
            {
                if (p.HasExited)
                {
                    throw new Exception("The hash cannot be created because the process has exited");
                }
                string fileName = p.MainModule.FileName;
                if (File.Exists(fileName))
                {
                    FileInfo info = new FileInfo(fileName);
                    long num = info.Length + info.CreationTime.Second;
                    return num.ToString();
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception ex = exception1;
                ErrorEventHandler errorEvent = this.ErrorEvent;
                if (errorEvent != null)
                {
                    errorEvent(this, ex);
                }
                ProjectData.ClearProjectError();
            }
            return string.Empty;
        }

        public void KillWatchers()
        {
            try
            {
                if (!this.IsWatcher)
                {
                    foreach (Process process in Process.GetProcessesByName(this.name))
                    {
                        if ((process.Id != Process.GetCurrentProcess().Id) && (this.GetProcessHash(process) == this.hash))
                        {
                            process.Kill();
                        }
                    }
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception ex = exception1;
                ErrorEventHandler errorEvent = this.ErrorEvent;
                if (errorEvent != null)
                {
                    errorEvent(this, ex);
                }
                ProjectData.ClearProjectError();
            }
        }

        public void Start()
        {
            if (this.running)
            {
                throw new Exception("The persistance is already running");
            }
            this.running = true;
            new Thread(new ThreadStart(this._Lambda$__4)).Start();
        }

        public void Stop()
        {
            if (!this.IsWatcher)
            {
                this.running = false;
            }
        }

        public void Stop(int ExitCode)
        {
            this.exitcode = ExitCode;
            if (!this.IsWatcher)
            {
                this.running = false;
            }
        }

        public string CurrentHash
        {
            get
            {
                return this.hash;
            }
        }

        public int Interval
        {
            get
            {
                return this._interval;
            }
            set
            {
                this._interval = value;
            }
        }

        public bool IsRunning
        {
            get
            {
                return this.running;
            }
        }

        public bool IsWatcher
        {
            get
            {
                return ((Environment.GetCommandLineArgs().Length > 1) && (Environment.GetCommandLineArgs()[1] == this.hash));
            }
        }

        public delegate void ErrorEventHandler(object sender, Exception ex);

        public delegate void StopCallbackEventHandler(object sender, int ExitCode);
    }
}

