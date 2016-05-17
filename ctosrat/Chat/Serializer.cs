namespace Chat
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.IO;
    using System.Text;

    public class Serializer
    {
        private Dictionary<Type, byte> Table = new Dictionary<Type, byte>();

        public Serializer()
        {
            this.Table.Add(typeof(bool), 0);
            this.Table.Add(typeof(byte), 1);
            this.Table.Add(typeof(byte[]), 2);
            this.Table.Add(typeof(char), 3);
            this.Table.Add(typeof(char[]), 4);
            this.Table.Add(typeof(decimal), 5);
            this.Table.Add(typeof(double), 6);
            this.Table.Add(typeof(int), 7);
            this.Table.Add(typeof(long), 8);
            this.Table.Add(typeof(sbyte), 9);
            this.Table.Add(typeof(short), 10);
            this.Table.Add(typeof(float), 11);
            this.Table.Add(typeof(string), 12);
            this.Table.Add(typeof(uint), 13);
            this.Table.Add(typeof(ulong), 14);
            this.Table.Add(typeof(ushort), 15);
            this.Table.Add(typeof(DateTime), 0x10);
            this.Table.Add(typeof(string[]), 0x11);
            this.Table.Add(typeof(int[]), 0x12);
            this.Table.Add(typeof(long[]), 0x13);
            this.Table.Add(typeof(ushort[]), 20);
            this.Table.Add(typeof(Enum), 0x15);
            this.Table.Add(typeof(Enum[]), 0x16);
            this.Table.Add(typeof(bool[]), 0x17);
            this.Table.Add(typeof(byte[][]), 0x18);
        }

        public object[] Deserialize(byte[] Data)
        {
            List<object> list = new List<object>();
            using (MemoryStream stream = new MemoryStream(Data))
            {
                using (BinaryReader reader = new BinaryReader(stream, Encoding.UTF8))
                {
                    byte num = reader.ReadByte();
                    int num11 = num - 1;
                    for (int i = 0; i <= num11; i++)
                    {
                        List<string> list2;
                        int num4;
                        List<int> list3;
                        int num5;
                        List<long> list4;
                        int num6;
                        List<ushort> list5;
                        int num7;
                        List<byte> list6;
                        int num8;
                        List<bool> list7;
                        int num9;
                        List<byte[]> list8;
                        int num10;
                        int num13;
                        int num14;
                        int num15;
                        int num16;
                        int num17;
                        int num18;
                        int num19;
                        switch (reader.ReadByte())
                        {
                            case 0:
                            {
                                list.Add(reader.ReadBoolean());
                                continue;
                            }
                            case 1:
                            {
                                list.Add(reader.ReadByte());
                                continue;
                            }
                            case 2:
                            {
                                list.Add(reader.ReadBytes(reader.ReadInt32()));
                                continue;
                            }
                            case 3:
                            {
                                list.Add(reader.ReadChar());
                                continue;
                            }
                            case 4:
                            {
                                list.Add(reader.ReadString().ToCharArray());
                                continue;
                            }
                            case 5:
                            {
                                list.Add(reader.ReadDecimal());
                                continue;
                            }
                            case 6:
                            {
                                list.Add(reader.ReadDouble());
                                continue;
                            }
                            case 7:
                            {
                                list.Add(reader.ReadInt32());
                                continue;
                            }
                            case 8:
                            {
                                list.Add(reader.ReadInt64());
                                continue;
                            }
                            case 9:
                            {
                                list.Add(reader.ReadSByte());
                                continue;
                            }
                            case 10:
                            {
                                list.Add(reader.ReadInt16());
                                continue;
                            }
                            case 11:
                            {
                                list.Add(reader.ReadSingle());
                                continue;
                            }
                            case 12:
                            {
                                list.Add(reader.ReadString());
                                continue;
                            }
                            case 13:
                            {
                                list.Add(reader.ReadUInt32());
                                continue;
                            }
                            case 14:
                            {
                                list.Add(reader.ReadUInt64());
                                continue;
                            }
                            case 15:
                            {
                                list.Add(reader.ReadUInt16());
                                continue;
                            }
                            case 0x10:
                            {
                                list.Add(DateTime.FromBinary(reader.ReadInt64()));
                                continue;
                            }
                            case 0x11:
                                list2 = new List<string>();
                                num13 = reader.ReadInt32() - 1;
                                num4 = 0;
                                goto Label_0279;

                            case 0x12:
                                list3 = new List<int>();
                                num14 = reader.ReadInt32() - 1;
                                num5 = 0;
                                goto Label_02CA;

                            case 0x13:
                                list4 = new List<long>();
                                num15 = reader.ReadInt32() - 1;
                                num6 = 0;
                                goto Label_031B;

                            case 20:
                                list5 = new List<ushort>();
                                num16 = reader.ReadInt32() - 1;
                                num7 = 0;
                                goto Label_036D;

                            case 0x15:
                            {
                                list.Add(reader.ReadByte());
                                continue;
                            }
                            case 0x16:
                                list6 = new List<byte>();
                                num17 = reader.ReadInt32() - 1;
                                num8 = 0;
                                goto Label_03D6;

                            case 0x17:
                                list7 = new List<bool>();
                                num18 = reader.ReadInt32() - 1;
                                num9 = 0;
                                goto Label_0427;

                            case 0x18:
                                list8 = new List<byte[]>();
                                num19 = reader.ReadInt32() - 1;
                                num10 = 0;
                                goto Label_047B;

                            default:
                            {
                                continue;
                            }
                        }
                    Label_0264:
                        list2.Add(reader.ReadString());
                        num4++;
                    Label_0279:
                        if (num4 <= num13)
                        {
                            goto Label_0264;
                        }
                        list.Add(list2.ToArray());
                        list2.Clear();
                        continue;
                    Label_02B5:
                        list3.Add(reader.ReadInt32());
                        num5++;
                    Label_02CA:
                        if (num5 <= num14)
                        {
                            goto Label_02B5;
                        }
                        list.Add(list3.ToArray());
                        list3.Clear();
                        continue;
                    Label_0306:
                        list4.Add(reader.ReadInt64());
                        num6++;
                    Label_031B:
                        if (num6 <= num15)
                        {
                            goto Label_0306;
                        }
                        list.Add(list4.ToArray());
                        list4.Clear();
                        continue;
                    Label_0357:
                        list5.Add((ushort) reader.ReadInt16());
                        num7++;
                    Label_036D:
                        if (num7 <= num16)
                        {
                            goto Label_0357;
                        }
                        list.Add(list5.ToArray());
                        list5.Clear();
                        continue;
                    Label_03C1:
                        list6.Add(reader.ReadByte());
                        num8++;
                    Label_03D6:
                        if (num8 <= num17)
                        {
                            goto Label_03C1;
                        }
                        list.Add(list6.ToArray());
                        list6.Clear();
                        continue;
                    Label_0412:
                        list7.Add(reader.ReadBoolean());
                        num9++;
                    Label_0427:
                        if (num9 <= num18)
                        {
                            goto Label_0412;
                        }
                        list.Add(list7.ToArray());
                        list7.Clear();
                        continue;
                    Label_0460:
                        list8.Add(reader.ReadBytes(reader.ReadInt32()));
                        num10++;
                    Label_047B:
                        if (num10 <= num19)
                        {
                            goto Label_0460;
                        }
                        list.Add(list8.ToArray());
                    }
                    reader.Close();
                }
            }
            return list.ToArray();
        }

        public byte[] Serialize(params object[] Data)
        {
            using (MemoryStream stream = new MemoryStream())
            {
                using (BinaryWriter writer = new BinaryWriter(stream, Encoding.UTF8))
                {
                    byte num = 0;
                    writer.Write(Convert.ToByte(Data.Length));
                    int num10 = Data.Length - 1;
                    for (int i = 0; i <= num10; i++)
                    {
                        int num3;
                        int num4;
                        int num5;
                        int num6;
                        int num7;
                        int num8;
                        int num9;
                        int num12;
                        int num13;
                        int num14;
                        int num15;
                        int length;
                        int num17;
                        int num18;
                        if (Data[i] is Enum)
                        {
                            num = 0x15;
                        }
                        else if (Data[i] is Enum[])
                        {
                            num = 0x16;
                        }
                        else
                        {
                            num = this.Table[Data[i].GetType()];
                        }
                        writer.Write(num);
                        switch (num)
                        {
                            case 0:
                            {
                                writer.Write((bool) Data[i]);
                                continue;
                            }
                            case 1:
                            {
                                writer.Write((byte) Data[i]);
                                continue;
                            }
                            case 2:
                            {
                                writer.Write(((byte[]) Data[i]).Length);
                                writer.Write((byte[]) Data[i]);
                                continue;
                            }
                            case 3:
                            {
                                writer.Write((char) Data[i]);
                                continue;
                            }
                            case 4:
                            {
                                writer.Write(((char[]) Data[i]).ToString());
                                continue;
                            }
                            case 5:
                            {
                                writer.Write((decimal) Data[i]);
                                continue;
                            }
                            case 6:
                            {
                                writer.Write((double) Data[i]);
                                continue;
                            }
                            case 7:
                            {
                                writer.Write((int) Data[i]);
                                continue;
                            }
                            case 8:
                            {
                                writer.Write((long) Data[i]);
                                continue;
                            }
                            case 9:
                            {
                                writer.Write((sbyte) Data[i]);
                                continue;
                            }
                            case 10:
                            {
                                writer.Write((short) Data[i]);
                                continue;
                            }
                            case 11:
                            {
                                writer.Write((float) Data[i]);
                                continue;
                            }
                            case 12:
                            {
                                writer.Write((string) Data[i]);
                                continue;
                            }
                            case 13:
                            {
                                writer.Write((uint) Data[i]);
                                continue;
                            }
                            case 14:
                            {
                                writer.Write((ulong) Data[i]);
                                continue;
                            }
                            case 15:
                            {
                                writer.Write((ushort) Data[i]);
                                continue;
                            }
                            case 0x10:
                            {
                                writer.Write(((DateTime) Data[i]).ToBinary());
                                continue;
                            }
                            case 0x11:
                                writer.Write(((string[]) Data[i]).Length);
                                num12 = ((string[]) Data[i]).Length - 1;
                                num3 = 0;
                                goto Label_031B;

                            case 0x12:
                                writer.Write(((int[]) Data[i]).Length);
                                num13 = ((int[]) Data[i]).Length - 1;
                                num4 = 0;
                                goto Label_036B;

                            case 0x13:
                                writer.Write(((long[]) Data[i]).Length);
                                num14 = ((long[]) Data[i]).Length - 1;
                                num5 = 0;
                                goto Label_03BB;

                            case 20:
                                writer.Write(((ushort[]) Data[i]).Length);
                                num15 = ((ushort[]) Data[i]).Length - 1;
                                num6 = 0;
                                goto Label_040B;

                            case 0x15:
                            {
                                writer.Write((byte) Data[i]);
                                continue;
                            }
                            case 0x16:
                                writer.Write(((IEnumerable[]) Data[i]).Length);
                                length = ((IEnumerable[]) Data[i]).Length;
                                num7 = 0;
                                goto Label_0474;

                            case 0x17:
                                writer.Write(((bool[]) Data[i]).Length);
                                num17 = ((bool[]) Data[i]).Length - 1;
                                num8 = 0;
                                goto Label_04C4;

                            case 0x18:
                                writer.Write(((byte[][]) Data[i]).Length);
                                num18 = ((byte[][]) Data[i]).Length - 1;
                                num9 = 0;
                                goto Label_0526;

                            default:
                            {
                                continue;
                            }
                        }
                    Label_0301:
                        writer.Write(((string[]) Data[i])[num3]);
                        num3++;
                    Label_031B:
                        if (num3 <= num12)
                        {
                            goto Label_0301;
                        }
                        continue;
                    Label_0351:
                        writer.Write(((int[]) Data[i])[num4]);
                        num4++;
                    Label_036B:
                        if (num4 <= num13)
                        {
                            goto Label_0351;
                        }
                        continue;
                    Label_03A1:
                        writer.Write(((long[]) Data[i])[num5]);
                        num5++;
                    Label_03BB:
                        if (num5 <= num14)
                        {
                            goto Label_03A1;
                        }
                        continue;
                    Label_03F1:
                        writer.Write(((ushort[]) Data[i])[num6]);
                        num6++;
                    Label_040B:
                        if (num6 <= num15)
                        {
                            goto Label_03F1;
                        }
                        continue;
                    Label_045A:
                        writer.Write(((byte[]) Data[i])[num7]);
                        num7++;
                    Label_0474:
                        if (num7 <= length)
                        {
                            goto Label_045A;
                        }
                        continue;
                    Label_04AA:
                        writer.Write(((bool[]) Data[i])[num8]);
                        num8++;
                    Label_04C4:
                        if (num8 <= num17)
                        {
                            goto Label_04AA;
                        }
                        continue;
                    Label_04F7:
                        writer.Write(((byte[][]) Data[i])[num9].Length);
                        writer.Write(((byte[][]) Data[i])[num9]);
                        num9++;
                    Label_0526:
                        if (num9 <= num18)
                        {
                            goto Label_04F7;
                        }
                    }
                }
                return stream.ToArray();
            }
        }
    }
}

