namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Net;
    using System.Net.Sockets;
    using System.Runtime.CompilerServices;
    using System.Runtime.Serialization.Formatters.Binary;
    using System.Threading;

    public class HTTPSocket
    {
        private static List<WeakReference> __ENCList = new List<WeakReference>();
        private BinaryFormatter bf;
        private TcpClient client;
        private string IPAddress;
        private string Ping;

        public event DisconnectedEventHandler Disconnected;

        public event GotInfoEventHandler GotInfo;

        public HTTPSocket(TcpClient c)
        {
            __ENCAddToList(this);
            this.bf = new BinaryFormatter();
            this.GetClient = c;
            this.IPAddress = ((IPEndPoint) this.client.Client.RemoteEndPoint).Address.ToString();
            this.client.GetStream().BeginRead(new byte[] { 0 }, 0, 0, new AsyncCallback(this.Read), null);
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

        public void Read(IAsyncResult ar)
        {
            if (this.client.GetStream().DataAvailable & this.client.GetStream().CanRead)
            {
                try
                {
                    Thread.Sleep(15);
                    byte[] info = (byte[]) this.bf.Deserialize(this.client.GetStream());
                    GotInfoEventHandler gotInfoEvent = this.GotInfoEvent;
                    if (gotInfoEvent != null)
                    {
                        gotInfoEvent(this, info);
                    }
                }
                catch (Exception exception1)
                {
                    ProjectData.SetProjectError(exception1);
                    ProjectData.ClearProjectError();
                }
            }
            try
            {
                this.client.GetStream().Flush();
                this.client.GetStream().BeginRead(new byte[] { 0 }, 0, 0, new AsyncCallback(this.Read), null);
            }
            catch (Exception exception2)
            {
                ProjectData.SetProjectError(exception2);
                DisconnectedEventHandler disconnectedEvent = this.DisconnectedEvent;
                if (disconnectedEvent != null)
                {
                    disconnectedEvent(this);
                }
                ProjectData.ClearProjectError();
            }
        }

        public void Send(byte[] Bytes)
        {
            try
            {
                this.bf.Serialize(this.client.GetStream(), Bytes);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public TcpClient GetClient
        {
            get
            {
                return this.client;
            }
            set
            {
                this.client = value;
            }
        }

        public string GetIPAddress
        {
            get
            {
                return this.IPAddress;
            }
            set
            {
                this.IPAddress = value;
            }
        }

        public int GetPing
        {
            get
            {
                return Conversions.ToInteger(this.Ping);
            }
            set
            {
                this.Ping = Conversions.ToString(value);
            }
        }

        public delegate void DisconnectedEventHandler(HTTPSocket c);

        public delegate void GotInfoEventHandler(HTTPSocket c, byte[] info);
    }
}

