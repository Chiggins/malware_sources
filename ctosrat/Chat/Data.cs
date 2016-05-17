namespace Chat
{
    using System;
    using System.Drawing;
    using System.Runtime.Serialization;

    [Serializable]
    public class Data
    {
        private byte[] bytes;
        private string data;
        private Image[] pic;

        public Data(SerializationInfo info, StreamingContext ctxt)
        {
            this.data = (string) info.GetValue("data", typeof(string));
            this.pic = (Image[]) info.GetValue("image", typeof(Image[]));
            this.bytes = (byte[]) info.GetValue("bytes", typeof(byte[]));
        }

        public Data(string s, Image[] p, byte[] b)
        {
            this.data = s;
            this.pic = p;
            this.bytes = b;
        }

        public byte[] GetBytes()
        {
            return this.bytes;
        }

        public string GetData()
        {
            return this.data;
        }

        public Image[] GetImage()
        {
            return this.pic;
        }
    }
}

