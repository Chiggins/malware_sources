namespace Chat
{
    using Microsoft.VisualBasic;
    using System;
    using System.IO;
    using System.Security.Cryptography;
    using System.Text;

    public class ProtonCrypt
    {
        private static readonly MD5CryptoServiceProvider MD5 = new MD5CryptoServiceProvider();

        public static byte[] Decrypt(byte[] Key, byte[] Data)
        {
            byte[] buffer2;
            string s = Convert.ToBase64String(Key);
            s = Strings.StrReverse(s.Remove(s.Length - 2, 2));
            Key = Encoding.UTF8.GetBytes(s);
            Key = MD5.ComputeHash(Key);
            Rfc2898DeriveBytes bytes = new Rfc2898DeriveBytes(Key, new byte[8], 1);
            using (RijndaelManaged managed = new RijndaelManaged())
            {
                managed.Key = bytes.GetBytes(0x10);
                managed.IV = bytes.GetBytes(0x10);
                buffer2 = managed.CreateDecryptor().TransformFinalBlock(Data, 0, Data.Length);
            }
            byte[] dst = new byte[(buffer2.Length - 0x11) + 1];
            Buffer.BlockCopy(buffer2, 0x10, dst, 0, buffer2.Length - 0x10);
            return dst;
        }

        public static byte[] Encrypt(byte[] Key, byte[] Data)
        {
            string s = Convert.ToBase64String(Key);
            s = Strings.StrReverse(s.Remove(s.Length - 2, 2));
            Key = Encoding.UTF8.GetBytes(s);
            Key = MD5.ComputeHash(Key);
            Rfc2898DeriveBytes bytes = new Rfc2898DeriveBytes(Key, new byte[8], 1);
            byte[] dst = new byte[(Data.Length + 15) + 1];
            using (RijndaelManaged managed = new RijndaelManaged())
            {
                managed.Key = bytes.GetBytes(0x10);
                managed.IV = bytes.GetBytes(0x10);
                Buffer.BlockCopy(Guid.NewGuid().ToByteArray(), 0, dst, 0, 0x10);
                Buffer.BlockCopy(Data, 0, dst, 0x10, Data.Length);
                return managed.CreateEncryptor().TransformFinalBlock(dst, 0, dst.Length);
            }
        }

        public static byte[] Encrypt(string Filename, byte[] Key)
        {
            byte[] buffer;
            using (FileStream stream = new FileStream(Filename, FileMode.Open, FileAccess.Read, FileShare.Read))
            {
                CryptoStream stream2;
                bool flag;
                string s = Convert.ToBase64String(Key);
                s = Strings.StrReverse(s.Remove(s.Length - 2, 2));
                Key = Encoding.UTF8.GetBytes(s);
                Key = MD5.ComputeHash(Key);
                Rfc2898DeriveBytes bytes = new Rfc2898DeriveBytes(Key, new byte[8], 1);
                stream.Write(Guid.NewGuid().ToByteArray(), 0, 0x10);
                using (RijndaelManaged managed = new RijndaelManaged())
                {
                    stream2 = new CryptoStream(stream, managed.CreateEncryptor(bytes.GetBytes(0x10), bytes.GetBytes(0x10)), CryptoStreamMode.Write);
                }
                byte[] array = new byte[0];
                while (!flag)
                {
                    int count = (int) Math.Min((long) (stream.Length - stream.Position), (long) 0xffffL);
                    stream.Read(array, 0, count);
                    stream2.Write(array, 0, count);
                    if (stream.Position == stream.Length)
                    {
                        flag = true;
                    }
                }
            }
            return buffer;
        }
    }
}

