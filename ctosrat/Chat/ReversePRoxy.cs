namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Diagnostics;
    using System.Net;
    using System.Net.Sockets;
    using System.Runtime.CompilerServices;
    using System.Threading;

    public class ReversePRoxy
    {
        private bool BlockAll = false;
        private HTTPSocket c;
        private short connet = 0;
        private TcpListener listener;

        [DebuggerStepThrough, CompilerGenerated]
        private void _Lambda$__5(object a0)
        {
            this.ParseInfo((object[]) a0);
        }

        public void Disconnec()
        {
            this.BlockAll = true;
        }

        public void Disconnected(HTTPSocket xc)
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
                this.connet = (short) (this.connet - 1);
            Label_001A:
                num3 = 3;
                GLobalProxyVar.ClientConnect = this.connet;
                goto Label_0091;
            Label_002C:;
                num2 = 0;
                switch ((num2 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_0009;

                    case 3:
                        goto Label_001A;

                    case 4:
                        goto Label_0091;

                    default:
                        goto Label_0086;
                }
            Label_004C:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_0086;

                    case 1:
                        goto Label_002C;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_004C;
            }
        Label_0086:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_0091:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
        }

        public void GotInfo(HTTPSocket x, byte[] info)
        {
            if (!this.BlockAll)
            {
                if ((this.c == null) && (((info[0] == 240) & (info[1] == 130)) & (info[2] == 210)))
                {
                    this.c = x;
                }
                else
                {
                    Thread thread = new Thread(new ParameterizedThreadStart(this._Lambda$__5));
                    thread.IsBackground = true;
                    thread.Start(new object[] { info, x });
                }
            }
        }

        public void Initialize(ushort Port)
        {
            this.BlockAll = false;
            this.listener = new TcpListener(new IPEndPoint(IPAddress.Any, Port));
            this.listener.Start();
            while (!this.BlockAll)
            {
                HTTPSocket socket = new HTTPSocket(this.listener.AcceptTcpClient());
                socket.GotInfo += new HTTPSocket.GotInfoEventHandler(this.GotInfo);
                socket.Disconnected += new HTTPSocket.DisconnectedEventHandler(this.Disconnected);
                this.connet = (short) (this.connet + 1);
                GLobalProxyVar.ClientConnect = this.connet;
            }
            this.listener.Stop();
            this.listener = null;
        }

        public void ParseInfo(object[] ob)
        {
            if (!this.BlockAll)
            {
                byte[] bytes = (byte[]) ob[0];
                HTTPSocket socket = (HTTPSocket) ob[1];
                this.c.Send(bytes);
            }
        }
    }
}

