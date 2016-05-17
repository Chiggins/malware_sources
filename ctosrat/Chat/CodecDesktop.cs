namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Drawing;
    using System.Drawing.Drawing2D;
    using System.Drawing.Imaging;
    using System.IO;
    using System.Runtime.InteropServices;
    using System.Threading;

    [StandardModule]
    internal sealed class CodecDesktop
    {
        public static byte[] ComprimiImmagineAndColor(Image imagex, Size size, [Optional, DefaultParameterValue(40)] int QualityCompress)
        {
            MemoryStream stream = new MemoryStream();
            ImageCodecInfo encoderInfo = GetEncoderInfo("image/jpeg");
            Encoder quality = Encoder.Quality;
            EncoderParameters encoderParams = new EncoderParameters(1);
            Thread.Sleep(1);
            encoderParams.Param[0] = new EncoderParameter(quality, (long) QualityCompress);
            ResizeImage((Bitmap) imagex, size, true).Save(stream, encoderInfo, encoderParams);
            Thread.Sleep(2);
            byte[] buffer = stream.ToArray();
            stream = new MemoryStream();
            return buffer;
        }

        private static ImageCodecInfo GetEncoderInfo(string mimeType)
        {
            Thread.Sleep(2);
            ImageCodecInfo[] imageEncoders = ImageCodecInfo.GetImageEncoders();
            int index = 0;
            while (index < imageEncoders.Length)
            {
                if (imageEncoders[index].MimeType == mimeType)
                {
                    Thread.Sleep(1);
                    return imageEncoders[index];
                }
                index++;
                Thread.Sleep(3);
            }
            return null;
        }

        public static Image ResizeImage(Bitmap bitmap_0, Size size_0, bool bool_0)
        {
            int num;
            int num2;
            if (bool_0)
            {
                Thread.Sleep(2);
                int width = bitmap_0.Width;
                int height = bitmap_0.Height;
                Thread.Sleep(1);
                float num4 = ((float) size_0.Width) / ((float) width);
                float num5 = ((float) size_0.Height) / ((float) height);
                Thread.Sleep(1);
                float num6 = (num5 < num4) ? num5 : num4;
                num = (int) Math.Round(Math.Round((double) (width * num6)));
                num2 = (int) Math.Round(Math.Round((double) (height * num6)));
                Thread.Sleep(1);
            }
            else
            {
                num = size_0.Width;
                num2 = size_0.Height;
                Thread.Sleep(1);
            }
            Image image = new Bitmap(num, num2);
            using (Graphics graphics = Graphics.FromImage(image))
            {
                graphics.InterpolationMode = InterpolationMode.Low;
                graphics.DrawImage(bitmap_0, 0, 0, num, num2);
                graphics.Dispose();
                Thread.Sleep(2);
                Thread.Sleep(1);
            }
            return image;
        }

        public static Image VaryQualityLevel(Image Foto, Size size, [Optional, DefaultParameterValue(40)] int QualityCompress)
        {
            ImageCodecInfo encoderInfo = GetEncoderInfo("image/jpeg");
            Encoder compression = Encoder.Compression;
            EncoderParameters encoderParams = new EncoderParameters(1);
            EncoderParameter parameter = new EncoderParameter(compression, (long) QualityCompress);
            encoderParams.Param[0] = parameter;
            Thread.Sleep(1);
            MemoryStream stream = new MemoryStream();
            Foto = ResizeImage((Bitmap) Foto, size, true);
            Thread.Sleep(2);
            Foto.Save(stream, encoderInfo, encoderParams);
            return Image.FromStream(stream);
        }
    }
}

