namespace Pin
{
    using System;
    using System.Diagnostics;
    using System.Runtime.CompilerServices;
    using System.Runtime.InteropServices;

    public class InterMouse
    {
        private MouseHookHandler hookHandler;
        private IntPtr hookID = IntPtr.Zero;
        private const int WH_MOUSE_LL = 14;

        public event MouseHookCallback DoubleClick;

        public event MouseHookCallback LeftButtonDown;

        public event MouseHookCallback LeftButtonUp;

        public event MouseHookCallback MiddleButtonDown;

        public event MouseHookCallback MiddleButtonUp;

        public event MouseHookCallback MouseMove;

        public event MouseHookCallback MouseWheel;

        public event MouseHookCallback RightButtonDown;

        public event MouseHookCallback RightButtonUp;

        [DllImport("user32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);
        ~InterMouse()
        {
            this.Uninstall();
        }

        [DllImport("kernel32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        private static extern IntPtr GetModuleHandle(string lpModuleName);
        private IntPtr HookFunc(int nCode, IntPtr wParam, IntPtr lParam)
        {
            if (nCode >= 0)
            {
                MouseHookCallback leftButtonDownEvent;
                if (0x201 == ((int) wParam))
                {
                    leftButtonDownEvent = this.LeftButtonDownEvent;
                    if (leftButtonDownEvent != null)
                    {
                        leftButtonDownEvent((MSLLHOOKSTRUCT) Marshal.PtrToStructure(lParam, typeof(MSLLHOOKSTRUCT)));
                    }
                }
                if (0x202 == ((int) wParam))
                {
                    leftButtonDownEvent = this.LeftButtonUpEvent;
                    if (leftButtonDownEvent != null)
                    {
                        leftButtonDownEvent((MSLLHOOKSTRUCT) Marshal.PtrToStructure(lParam, typeof(MSLLHOOKSTRUCT)));
                    }
                }
                if (0x204 == ((int) wParam))
                {
                    leftButtonDownEvent = this.RightButtonDownEvent;
                    if (leftButtonDownEvent != null)
                    {
                        leftButtonDownEvent((MSLLHOOKSTRUCT) Marshal.PtrToStructure(lParam, typeof(MSLLHOOKSTRUCT)));
                    }
                }
                if (0x205 == ((int) wParam))
                {
                    leftButtonDownEvent = this.RightButtonUpEvent;
                    if (leftButtonDownEvent != null)
                    {
                        leftButtonDownEvent((MSLLHOOKSTRUCT) Marshal.PtrToStructure(lParam, typeof(MSLLHOOKSTRUCT)));
                    }
                }
                if (0x200 == ((int) wParam))
                {
                    leftButtonDownEvent = this.MouseMoveEvent;
                    if (leftButtonDownEvent != null)
                    {
                        leftButtonDownEvent((MSLLHOOKSTRUCT) Marshal.PtrToStructure(lParam, typeof(MSLLHOOKSTRUCT)));
                    }
                }
                if (0x20a == ((int) wParam))
                {
                    leftButtonDownEvent = this.MouseWheelEvent;
                    if (leftButtonDownEvent != null)
                    {
                        leftButtonDownEvent((MSLLHOOKSTRUCT) Marshal.PtrToStructure(lParam, typeof(MSLLHOOKSTRUCT)));
                    }
                }
                if (0x203 == ((int) wParam))
                {
                    leftButtonDownEvent = this.DoubleClickEvent;
                    if (leftButtonDownEvent != null)
                    {
                        leftButtonDownEvent((MSLLHOOKSTRUCT) Marshal.PtrToStructure(lParam, typeof(MSLLHOOKSTRUCT)));
                    }
                }
                if (0x207 == ((int) wParam))
                {
                    leftButtonDownEvent = this.MiddleButtonDownEvent;
                    if (leftButtonDownEvent != null)
                    {
                        leftButtonDownEvent((MSLLHOOKSTRUCT) Marshal.PtrToStructure(lParam, typeof(MSLLHOOKSTRUCT)));
                    }
                }
                if (520 == ((int) wParam))
                {
                    leftButtonDownEvent = this.MiddleButtonUpEvent;
                    if (leftButtonDownEvent != null)
                    {
                        leftButtonDownEvent((MSLLHOOKSTRUCT) Marshal.PtrToStructure(lParam, typeof(MSLLHOOKSTRUCT)));
                    }
                }
            }
            return CallNextHookEx(this.hookID, nCode, wParam, lParam);
        }

        public void Install()
        {
            this.hookHandler = new MouseHookHandler(this.HookFunc);
            this.hookID = this.SetHook(this.hookHandler);
        }

        private IntPtr SetHook(MouseHookHandler proc)
        {
            using (ProcessModule module = Process.GetCurrentProcess().MainModule)
            {
                return SetWindowsHookEx(14, proc, GetModuleHandle(module.ModuleName), 0);
            }
        }

        [DllImport("user32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        private static extern IntPtr SetWindowsHookEx(int idHook, MouseHookHandler lpfn, IntPtr hMod, uint dwThreadId);
        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("user32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        public static extern bool UnhookWindowsHookEx(IntPtr hhk);
        public void Uninstall()
        {
            if (this.hookID != IntPtr.Zero)
            {
                UnhookWindowsHookEx(this.hookID);
                this.hookID = IntPtr.Zero;
            }
        }

        public delegate void MouseHookCallback(InterMouse.MSLLHOOKSTRUCT mouseStruct);

        private delegate IntPtr MouseHookHandler(int nCode, IntPtr wParam, IntPtr lParam);

        public enum MouseMessages
        {
            WM_LBUTTONDBLCLK = 0x203,
            WM_LBUTTONDOWN = 0x201,
            WM_LBUTTONUP = 0x202,
            WM_MBUTTONDOWN = 0x207,
            WM_MBUTTONUP = 520,
            WM_MOUSEMOVE = 0x200,
            WM_MOUSEWHEEL = 0x20a,
            WM_RBUTTONDOWN = 0x204,
            WM_RBUTTONUP = 0x205
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct MSLLHOOKSTRUCT
        {
            public InterMouse.POINT pt;
            public uint mouseData;
            public uint flags;
            public uint time;
            public IntPtr dwExtraInfo;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct POINT
        {
            public int x;
            public int y;
        }
    }
}

