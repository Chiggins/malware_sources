namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.IO;
    using System.Runtime.CompilerServices;
    using System.Runtime.InteropServices;

    public class ResourceManager
    {
        [DllImport("kernel32.dll")]
        private static extern IntPtr BeginUpdateResource(string pFileName, [MarshalAs(UnmanagedType.Bool)] bool bDeleteExistingResource);
        [DllImport("kernel32.dll")]
        private static extern bool EndUpdateResource(IntPtr hUpdate, bool fDiscard);
        [DllImport("kernel32.dll")]
        private static extern IntPtr FindResource(IntPtr hModule, string lpName, string lpType);
        [DllImport("kernel32.dll")]
        private static extern IntPtr GetModuleHandle(string lpModuleName);
        private static IntPtr GetPointer(object Data)
        {
            IntPtr ptr2;
            GCHandle handle = GCHandle.Alloc(RuntimeHelpers.GetObjectValue(Data), GCHandleType.Pinned);
            try
            {
                ptr2 = handle.AddrOfPinnedObject();
            }
            finally
            {
                handle.Free();
            }
            return ptr2;
        }

        [DllImport("kernel32.dll")]
        private static extern IntPtr LoadLibrary(string lpFileName);
        [DllImport("kernel32.dll")]
        private static extern IntPtr LoadResource(IntPtr hModule, IntPtr hResInfo);
        public static byte[] ReadResource(string FileName, string ResourceName)
        {
            byte[] buffer;
            try
            {
                IntPtr moduleHandle;
                if (File.Exists(FileName))
                {
                    moduleHandle = LoadLibrary(FileName);
                }
                else
                {
                    moduleHandle = GetModuleHandle(null);
                }
                IntPtr hResInfo = FindResource(moduleHandle, "0", ResourceName);
                IntPtr source = LoadResource(moduleHandle, hResInfo);
                int length = SizeofResource(moduleHandle, hResInfo);
                byte[] destination = new byte[(length - 1) + 1];
                Marshal.Copy(source, destination, 0, length);
                buffer = destination;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                buffer = null;
                ProjectData.ClearProjectError();
                return buffer;
                ProjectData.ClearProjectError();
            }
            return buffer;
        }

        [DllImport("kernel32.dll")]
        private static extern int SizeofResource(IntPtr hModule, IntPtr hResInfo);
        [DllImport("kernel32.dll")]
        private static extern bool UpdateResource(IntPtr hUpdate, string lpType, string lpName, ushort wLanguage, IntPtr lpData, uint cbData);
        public static bool WriteResource(string Filename, string ResourceName, byte[] Data)
        {
            bool flag;
            try
            {
                IntPtr hUpdate = BeginUpdateResource(Filename, false);
                IntPtr pointer = GetPointer(Data);
                bool flag2 = UpdateResource(hUpdate, ResourceName, "0", 0, pointer, Convert.ToUInt32(Data.Length));
                EndUpdateResource(hUpdate, false);
                flag = true;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                Exception exception = exception1;
                flag = false;
                ProjectData.ClearProjectError();
                return flag;
                ProjectData.ClearProjectError();
            }
            return flag;
        }
    }
}

