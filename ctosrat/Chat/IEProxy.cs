namespace Chat
{
    using System;
    using System.Diagnostics;
    using System.Runtime.InteropServices;

    public class IEProxy
    {
        private const int ERROR_INSUFFICIENT_BUFFER = 0x7a;
        private const int INTERNET_OPEN_TYPE_DIRECT = 1;
        private const int INTERNET_OPTION_PROXY = 0x26;

        public bool DisableProxy()
        {
            INTERNET_PER_CONN_OPTION_LIST structure = new INTERNET_PER_CONN_OPTION_LIST();
            int dwBufferLength = Marshal.SizeOf(structure);
            INTERNET_PER_CONN_OPTION[] internet_per_conn_optionArray = new INTERNET_PER_CONN_OPTION[1];
            int cb = Marshal.SizeOf(internet_per_conn_optionArray[0]);
            structure.dwSize = dwBufferLength;
            structure.pszConnection = "\0";
            structure.dwOptionCount = 1;
            internet_per_conn_optionArray[0].dwOption = 1;
            internet_per_conn_optionArray[0].dwValue = 1;
            byte[] array = new byte[cb + 1];
            internet_per_conn_optionArray[0].GetBytes().CopyTo(array, 0);
            IntPtr destination = Marshal.AllocCoTaskMem(cb);
            Marshal.Copy(array, 0, destination, cb);
            structure.pOptions = destination;
            if (!InternetSetOption(IntPtr.Zero, 0x4b, structure, dwBufferLength))
            {
                Debug.WriteLine(GetLastError());
            }
            if (!InternetSetOption(IntPtr.Zero, 0x27, null, 0))
            {
                Debug.WriteLine(GetLastError());
            }
            bool flag = InternetSetOption(IntPtr.Zero, 0x25, null, 0);
            if (!flag)
            {
                Debug.WriteLine(GetLastError());
            }
            Marshal.FreeCoTaskMem(destination);
            return flag;
        }

        [DllImport("kernel32.dll")]
        private static extern int GetLastError();
        [DllImport("wininet.dll")]
        private static extern bool InternetSetOption(IntPtr hInternet, int dwOption, INTERNET_PER_CONN_OPTION_LIST lpBuffer, int dwBufferLength);
        public bool SetProxy(string proxy_full_addr)
        {
            INTERNET_PER_CONN_OPTION_LIST structure = new INTERNET_PER_CONN_OPTION_LIST();
            int dwBufferLength = Marshal.SizeOf(structure);
            INTERNET_PER_CONN_OPTION[] internet_per_conn_optionArray = new INTERNET_PER_CONN_OPTION[4];
            int index = Marshal.SizeOf(internet_per_conn_optionArray[0]);
            structure.dwSize = dwBufferLength;
            structure.pszConnection = "\0";
            structure.dwOptionCount = 3;
            internet_per_conn_optionArray[0].dwOption = 1;
            internet_per_conn_optionArray[0].dwValue = 3;
            internet_per_conn_optionArray[1].dwOption = 2;
            internet_per_conn_optionArray[1].pszValue = Marshal.StringToHGlobalAnsi(proxy_full_addr);
            internet_per_conn_optionArray[2].dwOption = 3;
            internet_per_conn_optionArray[2].pszValue = Marshal.StringToHGlobalAnsi("local");
            byte[] array = new byte[(3 * index) + 1];
            internet_per_conn_optionArray[0].GetBytes().CopyTo(array, 0);
            internet_per_conn_optionArray[1].GetBytes().CopyTo(array, index);
            internet_per_conn_optionArray[2].GetBytes().CopyTo(array, (int) (2 * index));
            IntPtr destination = Marshal.AllocCoTaskMem(3 * index);
            Marshal.Copy(array, 0, destination, 3 * index);
            structure.pOptions = destination;
            if (!InternetSetOption(IntPtr.Zero, 0x4b, structure, dwBufferLength))
            {
                Debug.WriteLine(GetLastError());
            }
            if (!InternetSetOption(IntPtr.Zero, 0x27, null, 0))
            {
                Debug.WriteLine(GetLastError());
            }
            bool flag = InternetSetOption(IntPtr.Zero, 0x25, null, 0);
            if (!flag)
            {
                Debug.WriteLine(GetLastError());
            }
            Marshal.FreeHGlobal(internet_per_conn_optionArray[1].pszValue);
            Marshal.FreeHGlobal(internet_per_conn_optionArray[2].pszValue);
            Marshal.FreeCoTaskMem(destination);
            return flag;
        }

        [StructLayout(LayoutKind.Sequential)]
        private class FILETIME
        {
            public int dwLowDateTime;
            public int dwHighDateTime;
        }

        [StructLayout(LayoutKind.Explicit, Size=12)]
        private struct INTERNET_PER_CONN_OPTION
        {
            [FieldOffset(0)]
            public int dwOption;
            [FieldOffset(4)]
            public int dwValue;
            [FieldOffset(4)]
            public IntPtr ftValue;
            [FieldOffset(4)]
            public IntPtr pszValue;

            public byte[] GetBytes()
            {
                byte[] array = new byte[13];
                BitConverter.GetBytes(this.dwOption).CopyTo(array, 0);
                switch (this.dwOption)
                {
                    case 1:
                        BitConverter.GetBytes(this.dwValue).CopyTo(array, 4);
                        return array;

                    case 2:
                        BitConverter.GetBytes(this.pszValue.ToInt32()).CopyTo(array, 4);
                        return array;

                    case 3:
                        BitConverter.GetBytes(this.pszValue.ToInt32()).CopyTo(array, 4);
                        return array;
                }
                return array;
            }
        }

        [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Auto)]
        private class INTERNET_PER_CONN_OPTION_LIST
        {
            public int dwSize;
            public string pszConnection;
            public int dwOptionCount;
            public int dwOptionError;
            public IntPtr pOptions;
        }

        [StructLayout(LayoutKind.Sequential)]
        private class INTERNET_PROXY_INFO
        {
            public int dwAccessType;
            public IntPtr lpszProxy;
            public IntPtr lpszProxyBypass;
        }

        public enum Options
        {
            INTERNET_OPTION_PER_CONNECTION_OPTION = 0x4b,
            INTERNET_OPTION_REFRESH = 0x25,
            INTERNET_OPTION_SETTINGS_CHANGED = 0x27,
            INTERNET_PER_CONN_AUTOCONFIG_URL = 4,
            INTERNET_PER_CONN_AUTODISCOVERY_FLAGS = 5,
            INTERNET_PER_CONN_FLAGS = 1,
            INTERNET_PER_CONN_PROXY_BYPASS = 3,
            INTERNET_PER_CONN_PROXY_SERVER = 2,
            PROXY_TYPE_DIRECT = 1,
            PROXY_TYPE_PROXY = 2
        }
    }
}

