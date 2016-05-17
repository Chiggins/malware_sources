Imports System
Imports System.Collections.Generic
Imports System.IO
Imports System.Text

Namespace LuxNET
    Friend NotInheritable Class Pack
        ' Methods
        Public Sub New()
            Me.Table.Add(GetType(Boolean), 0)
            Me.Table.Add(GetType(Byte), 1)
            Me.Table.Add(GetType(Byte()), 2)
            Me.Table.Add(GetType(Char), 3)
            Me.Table.Add(GetType(Char()), 4)
            Me.Table.Add(GetType(Decimal), 5)
            Me.Table.Add(GetType(Double), 6)
            Me.Table.Add(GetType(Integer), 7)
            Me.Table.Add(GetType(Long), 8)
            Me.Table.Add(GetType(SByte), 9)
            Me.Table.Add(GetType(Short), 10)
            Me.Table.Add(GetType(Single), 11)
            Me.Table.Add(GetType(String), 12)
            Me.Table.Add(GetType(UInt32), 13)
            Me.Table.Add(GetType(UInt64), 14)
            Me.Table.Add(GetType(UInt16), 15)
            Me.Table.Add(GetType(DateTime), &H10)
        End Sub

        Public Function Deserialize(ByVal data As Byte()) As Object()
            Dim input As New MemoryStream(data)
            Dim reader As New BinaryReader(input, Encoding.UTF8)
            Dim list As New List(Of Object)
            Dim num As Byte = reader.ReadByte
            Dim num4 As Integer = (num - 1)
            Dim i As Integer = 0
            Do While (i <= num4)
                Select Case reader.ReadByte
                    Case 0
                        list.Add(reader.ReadBoolean)
                        Exit Select
                    Case 1
                        list.Add(reader.ReadByte)
                        Exit Select
                    Case 2
                        list.Add(reader.ReadBytes(reader.ReadInt32))
                        Exit Select
                    Case 3
                        list.Add(reader.ReadChar)
                        Exit Select
                    Case 4
                        list.Add(reader.ReadString.ToCharArray)
                        Exit Select
                    Case 5
                        list.Add(reader.ReadDecimal)
                        Exit Select
                    Case 6
                        list.Add(reader.ReadDouble)
                        Exit Select
                    Case 7
                        list.Add(reader.ReadInt32)
                        Exit Select
                    Case 8
                        list.Add(reader.ReadInt64)
                        Exit Select
                    Case 9
                        list.Add(reader.ReadSByte)
                        Exit Select
                    Case 10
                        list.Add(reader.ReadInt16)
                        Exit Select
                    Case 11
                        list.Add(reader.ReadSingle)
                        Exit Select
                    Case 12
                        list.Add(reader.ReadString)
                        Exit Select
                    Case 13
                        list.Add(reader.ReadUInt32)
                        Exit Select
                    Case 14
                        list.Add(reader.ReadUInt64)
                        Exit Select
                    Case 15
                        list.Add(reader.ReadUInt16)
                        Exit Select
                    Case &H10
                        list.Add(DateTime.FromBinary(reader.ReadInt64))
                        Exit Select
                End Select
                i += 1
            Loop
            reader.Close()
            Return list.ToArray
        End Function

        Public Function Serialize(ByVal ParamArray data As Object()) As Byte()
            Dim output As New MemoryStream
            Dim writer As New BinaryWriter(output, Encoding.UTF8)
            Dim num As Byte = 0
            writer.Write(Convert.ToByte(data.Length))
            Dim num3 As Integer = (data.Length - 1)
            Dim i As Integer = 0
            Do While (i <= num3)
                num = Me.Table.Item(data(i).GetType)
                writer.Write(num)
                Select Case num
                    Case 0
                        writer.Write(CBool(data(i)))
                        Exit Select
                    Case 1
                        writer.Write(CByte(data(i)))
                        Exit Select
                    Case 2
                        writer.Write(DirectCast(data(i), Byte()).Length)
                        writer.Write(DirectCast(data(i), Byte()))
                        Exit Select
                    Case 3
                        writer.Write(DirectCast(data(i), Char))
                        Exit Select
                    Case 4
                        writer.Write(DirectCast(data(i), Char()).ToString)
                        Exit Select
                    Case 5
                        writer.Write(CDec(data(i)))
                        Exit Select
                    Case 6
                        writer.Write(CDbl(data(i)))
                        Exit Select
                    Case 7
                        writer.Write(CInt(data(i)))
                        Exit Select
                    Case 8
                        writer.Write(CLng(data(i)))
                        Exit Select
                    Case 9
                        writer.Write(CSByte(data(i)))
                        Exit Select
                    Case 10
                        writer.Write(CShort(data(i)))
                        Exit Select
                    Case 11
                        writer.Write(CSng(data(i)))
                        Exit Select
                    Case 12
                        writer.Write(CStr(data(i)))
                        Exit Select
                    Case 13
                        writer.Write(DirectCast(data(i), UInt32))
                        Exit Select
                    Case 14
                        writer.Write(CULng(data(i)))
                        Exit Select
                    Case 15
                        writer.Write(CUShort(data(i)))
                        Exit Select
                    Case &H10
                        writer.Write(CDate(data(i)).ToBinary)
                        Exit Select
                End Select
                i += 1
            Loop
            writer.Close()
            Return output.ToArray
        End Function


        ' Fields
        Private Table As Dictionary(Of Type, Byte) = New Dictionary(Of Type, Byte)
    End Class
End Namespace


