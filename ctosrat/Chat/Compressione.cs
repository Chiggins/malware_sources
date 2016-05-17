namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.IO;
    using System.IO.Compression;
    using System.Runtime.InteropServices;
    using System.Security.Cryptography;
    using System.Text;

    public class Compressione
    {
        public static byte[] Compress(byte[] data)
        {
            MemoryStream stream2 = new MemoryStream();
            GZipStream stream = new GZipStream(stream2, CompressionMode.Compress, true);
            stream.Write(data, 0, data.Length);
            stream.Close();
            return stream2.ToArray();
        }

        public static byte[] Decompress(byte[] data)
        {
            MemoryStream stream2 = new MemoryStream();
            stream2.Write(data, 0, data.Length);
            stream2.Position = 0L;
            GZipStream stream = new GZipStream(stream2, CompressionMode.Decompress, true);
            MemoryStream stream3 = new MemoryStream();
            byte[] array = new byte[0x41];
            int count = -1;
            try
            {
                count = stream.Read(array, 0, array.Length);
            }
            catch (Exception exception1)
            {
                byte[] buffer2;
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
                return buffer2;
                ProjectData.ClearProjectError();
            }
            while (count > 0)
            {
                stream3.Write(array, 0, count);
                count = stream.Read(array, 0, array.Length);
            }
            stream.Close();
            return stream3.ToArray();
        }

        public static string TripleDES(string Text, string Password, [Optional, DefaultParameterValue(false)] bool Reverse)
        {
            string str2;
            int num2;
            try
            {
                int num3;
            Label_0001:
                num3 = 1;
                string str = null;
            Label_0006:
                num3 = 2;
                TripleDESCryptoServiceProvider provider = new TripleDESCryptoServiceProvider();
            Label_000F:
                num3 = 3;
                MD5CryptoServiceProvider provider2 = new MD5CryptoServiceProvider();
            Label_0018:
                num3 = 4;
                provider.Key = provider2.ComputeHash(Encoding.UTF8.GetBytes(Password));
            Label_0033:
                num3 = 5;
                provider.Mode = CipherMode.ECB;
            Label_003E:
                num3 = 6;
                switch (Reverse)
                {
                    case false:
                        goto Label_0098;

                    case true:
                        break;

                    default:
                        goto Label_00CE;
                }
            Label_0057:
                num3 = 10;
                ICryptoTransform transform = provider.CreateDecryptor();
            Label_0063:
                ProjectData.ClearProjectError();
                int num = -2;
            Label_006C:
                num3 = 12;
                byte[] inputBuffer = Convert.FromBase64String(Text);
            Label_0078:
                num3 = 13;
                str = Encoding.UTF8.GetString(transform.TransformFinalBlock(inputBuffer, 0, inputBuffer.Length));
                goto Label_00CE;
            Label_0098:
                num3 = 0x10;
                ICryptoTransform transform2 = provider.CreateEncryptor();
            Label_00A4:
                num3 = 0x11;
                byte[] bytes = Encoding.UTF8.GetBytes(Text);
            Label_00B5:
                num3 = 0x12;
                str = Convert.ToBase64String(transform2.TransformFinalBlock(bytes, 0, bytes.Length));
            Label_00CE:
                num3 = 20;
                str2 = str;
                goto Label_0193;
            Label_00E6:
                num2 = 0;
                switch ((num2 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_0006;

                    case 3:
                        goto Label_000F;

                    case 4:
                        goto Label_0018;

                    case 5:
                        goto Label_0033;

                    case 6:
                        goto Label_003E;

                    case 7:
                    case 0x13:
                    case 14:
                    case 20:
                        goto Label_00CE;

                    case 8:
                    case 10:
                        goto Label_0057;

                    case 11:
                        goto Label_0063;

                    case 12:
                        goto Label_006C;

                    case 13:
                        goto Label_0078;

                    case 15:
                    case 0x10:
                        goto Label_0098;

                    case 0x11:
                        goto Label_00A4;

                    case 0x12:
                        goto Label_00B5;

                    case 0x15:
                        goto Label_0193;

                    default:
                        goto Label_0188;
                }
            Label_0148:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_0188;

                    case 1:
                        goto Label_00E6;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_0148;
            }
        Label_0188:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_0193:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
            return str2;
        }
    }
}

