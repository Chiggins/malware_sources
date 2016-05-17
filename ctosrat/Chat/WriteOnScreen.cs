namespace Chat
{
    using System;
    using System.Drawing;
    using System.Runtime.InteropServices;

    public class WriteOnScreen
    {
        private Graphics g;
        private IntPtr hdc = GetDC(IntPtr.Zero);
        private int ScreenX = MyProject.Computer.Screen.Bounds.Width;
        private int ScreenY = MyProject.Computer.Screen.Bounds.Height;

        public WriteOnScreen()
        {
            this.g = Graphics.FromHdc(this.hdc);
        }

        public object drawT(string Text, int x, int y, Font Font, string color)
        {
            switch (color)
            {
                case "Black":
                    this.g.DrawString(Text, Font, Brushes.Black, (float) x, (float) y);
                    break;

                case "Red":
                    this.g.DrawString(Text, Font, Brushes.Red, (float) x, (float) y);
                    break;

                case "Blu":
                    this.g.DrawString(Text, Font, Brushes.Blue, (float) x, (float) y);
                    break;

                case "Orange":
                    this.g.DrawString(Text, Font, Brushes.Orange, (float) x, (float) y);
                    break;

                case "Yellow":
                    this.g.DrawString(Text, Font, Brushes.Yellow, (float) x, (float) y);
                    break;

                case "Green":
                    this.g.DrawString(Text, Font, Brushes.Green, (float) x, (float) y);
                    break;

                case "Violet":
                    this.g.DrawString(Text, Font, Brushes.Violet, (float) x, (float) y);
                    break;
            }
            return null;
        }

        [DllImport("user32.dll")]
        private static extern IntPtr GetDC(IntPtr hwnd);
        [DllImport("user32.dll", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern IntPtr GetForegroundWindow();
        [DllImport("user32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern long GetWindowDC(long hwnd);
        [DllImport("user32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        public static extern long ReleaseDC(long hwnd, long hdc);
        [DllImport("user32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        private static extern bool SetWindowText(IntPtr hwnd, string lpString);
    }
}

