namespace Chat
{
    using Chat.My;
    using System;

    public class DownloadAndProtectFiles
    {
        private ProtectionSettings Proc;
        private string SaveInt;
        private string URL;

        public DownloadAndProtectFiles(string URLs, string SaveIn, ProtectionSettings Protection)
        {
            this.URL = URLs;
            this.Proc = Protection;
            this.SaveInt = SaveIn;
        }

        public void Start()
        {
            MyProject.Computer.Network.DownloadFile(this.URL, this.SaveInt);
            new FileProtector(this.Proc).Start(this.SaveInt, false);
        }
    }
}

