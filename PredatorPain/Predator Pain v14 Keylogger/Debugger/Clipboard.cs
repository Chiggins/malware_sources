namespace Debugger
{
    using System;
    using System.Runtime.CompilerServices;
    using System.Runtime.InteropServices;
    using System.Windows.Forms;

    internal class Clipboard : NativeWindow
    {
        private IntPtr ID;

        public event ChangedEventHandler Changed;

        public Clipboard()
        {
            this.CreateHandle(new CreateParams());
        }

        [DllImport("user32", CharSet=CharSet.Auto, SetLastError=true)]
        private static extern bool ChangeClipboardChain(IntPtr handle, IntPtr next);
        protected override void Finalize()
        {
            this.Uninstall();
        }

        public void Install()
        {
            this.ID = SetClipboardViewer(this.Handle);
        }

        [DllImport("user32", CharSet=CharSet.Auto, SetLastError=true)]
        private static extern long SendMessage(IntPtr handle, int code, IntPtr flags, IntPtr data);
        [DllImport("user32", CharSet=CharSet.Auto, SetLastError=true)]
        private static extern IntPtr SetClipboardViewer(IntPtr handle);
        public void Uninstall()
        {
            ChangeClipboardChain(this.Handle, this.ID);
        }

        protected override void WndProc(ref Message m)
        {
            switch (m.Msg)
            {
                case 0x308:
                {
                    ChangedEventHandler changedEvent = this.ChangedEvent;
                    if (changedEvent != null)
                    {
                        changedEvent(this);
                    }
                    SendMessage(this.ID, m.Msg, m.WParam, m.LParam);
                    break;
                }
                case 0x30d:
                    if (!(m.WParam == this.ID))
                    {
                        SendMessage(this.ID, m.Msg, m.WParam, m.LParam);
                        break;
                    }
                    this.ID = m.LParam;
                    break;
            }
            base.WndProc(ref m);
        }

        public delegate void ChangedEventHandler(Debugger.Clipboard sender);
    }
}

