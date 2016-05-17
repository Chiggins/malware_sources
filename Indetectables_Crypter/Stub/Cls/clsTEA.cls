VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsTEA"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' Visual Basic TEA Implementation
' David Midkiff (mdj2023@hotmail.com)
'
' Standard TEA implementation with file support, hex conversion,
' speed string concatenation and overall optimisations for Visual Basic.
' TEA is an excellent new cipher which appears to be farely strong
' but is still being reviewed and could show weaknesses in the near
' future. I would recommend TEA for use in medium risk solutions.
'
' Information on the algorithm can be found at:
' http://www.cl.cam.ac.uk/Research/Papers/djw-rmn/djw-rmn-tea.html

Private Declare Sub CopyMem Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)

Event Progress(Percent As Long)

Private m_RunningCompiled As Boolean
Private Tk(3) As Long
Private Const ROUNDS = 32
Private Const Delta = &H9E3779B9
Private Const DecryptSum = &HC6EF3720
Private byteArray() As Byte
Private hiByte As Long
Private hiBound As Long
Private Sub Append(ByRef StringData As String, Optional Length As Long)
    Dim DataLength As Long
    If Length > 0 Then DataLength = Length Else DataLength = Len(StringData)
    If DataLength + hiByte > hiBound Then
        hiBound = hiBound + 1024
        ReDim Preserve byteArray(hiBound)
    End If
    CopyMem ByVal VarPtr(byteArray(hiByte)), ByVal StringData, DataLength
    hiByte = hiByte + DataLength
End Sub
Private Function DeHex(Data As String) As String
    Dim iCount As Double
    Reset
    For iCount = 1 To Len(Data) Step 2
        Append Chr$(Val("&H" & Mid$(Data, iCount, 2)))
    Next
    DeHex = GData
    Reset
End Function
Private Function EnHex(Data As String) As String
    Dim iCount As Double, sTemp As String
    Reset
    For iCount = 1 To Len(Data)
        sTemp = Hex$(Asc(Mid$(Data, iCount, 1)))
        If Len(sTemp) < 2 Then sTemp = "0" & sTemp
        Append sTemp
    Next
    EnHex = GData
    Reset
End Function
Private Function FileExist(Filename As String) As Boolean
    On Error GoTo errorhandler
    Call FileLen(Filename)
    FileExist = True
    Exit Function
    
errorhandler:
    FileExist = False
End Function
Private Property Get GData() As String
    Dim StringData As String
    StringData = Space(hiByte)
    CopyMem ByVal StringData, ByVal VarPtr(byteArray(0)), hiByte
    GData = StringData
End Property
Private Static Function UnsignedAdd(ByVal Data1 As Long, Data2 As Long) As Long
    Dim x1(0 To 3) As Byte, x2(0 To 3) As Byte, xx(0 To 3) As Byte, Rest As Long, Value As Long, a As Long
    Call CopyMem(x1(0), Data1, 4)
    Call CopyMem(x2(0), Data2, 4)
    Rest = 0
    For a = 0 To 3
        Value = CLng(x1(a)) + CLng(x2(a)) + Rest
        xx(a) = Value And 255
        Rest = Value \ 256
    Next
    Call CopyMem(UnsignedAdd, xx(0), 4)
End Function
Private Function UnsignedDel(Data1 As Long, Data2 As Long) As Long
    Dim x1(0 To 3) As Byte, x2(0 To 3) As Byte, xx(0 To 3) As Byte, Rest As Long, Value As Long, a As Long
    Call CopyMem(x1(0), Data1, 4)
    Call CopyMem(x2(0), Data2, 4)
    Call CopyMem(xx(0), UnsignedDel, 4)
    For a = 0 To 3
        Value = CLng(x1(a)) - CLng(x2(a)) - Rest
        If (Value < 0) Then
            Value = Value + 256
            Rest = 1
        Else
            Rest = 0
        End If
        xx(a) = Value
    Next
    Call CopyMem(UnsignedDel, xx(0), 4)
End Function
Private Sub Reset()
    hiByte = 0
    hiBound = 1024
    ReDim byteArray(hiBound)
End Sub
Private Static Sub PutWord(LongValue As Long, CryptBuffer() As Byte, Offset As Long)
    Dim bb(0 To 3) As Byte
    Call CopyMem(bb(0), LongValue, 4)
    CryptBuffer(Offset) = bb(3)
    CryptBuffer(Offset + 1) = bb(2)
    CryptBuffer(Offset + 2) = bb(1)
    CryptBuffer(Offset + 3) = bb(0)
End Sub
Private Static Sub GetWord(LongValue As Long, CryptBuffer() As Byte, Offset As Long)
    Dim bb(0 To 3) As Byte
    bb(3) = CryptBuffer(Offset)
    bb(2) = CryptBuffer(Offset + 1)
    bb(1) = CryptBuffer(Offset + 2)
    bb(0) = CryptBuffer(Offset + 3)
    Call CopyMem(LongValue, bb(0), 4)
End Sub
Public Function EncryptFile(InFile As String, OutFile As String, Overwrite As Boolean, Optional Key As String) As Boolean
    On Error GoTo errorhandler
    If FileExist(InFile) = False Then
        EncryptFile = False
        Exit Function
    End If
    If FileExist(OutFile) = True And Overwrite = False Then
        EncryptFile = False
        Exit Function
    End If
    Dim FileO As Integer, Buffer() As Byte
    FileO = FreeFile
    Open InFile For Binary As #FileO
        ReDim Buffer(0 To LOF(FileO) - 1)
        Get #FileO, , Buffer()
    Close #FileO
    Call EncryptByte(Buffer(), Key)
    If FileExist(OutFile) = True Then Kill OutFile
    FileO = FreeFile
    Open OutFile For Binary As #FileO
        Put #FileO, , Buffer()
    Close #FileO
    EncryptFile = True
    Exit Function

errorhandler:
    EncryptFile = False
End Function
Public Function DecryptFile(InFile As String, OutFile As String, Overwrite As Boolean, Optional Key As String) As Boolean
    On Error GoTo errorhandler
    If FileExist(InFile) = False Then
        DecryptFile = False
        Exit Function
    End If
    If FileExist(OutFile) = True Then
        DecryptFile = False
        Exit Function
    End If
    Dim FileO As Integer, Buffer() As Byte
    FileO = FreeFile
    Open InFile For Binary As #FileO
        ReDim Buffer(0 To LOF(FileO) - 1)
        Get #FileO, , Buffer()
    Close #FileO
    Call DecryptByte(Buffer(), Key)
    If FileExist(OutFile) = True Then Kill OutFile
    FileO = FreeFile
    Open OutFile For Binary As #FileO
        Put #FileO, , Buffer()
    Close #FileO
    DecryptFile = True
    Exit Function
    
errorhandler:
    DecryptFile = False
End Function

Public Function EncryptString(Text As String, Optional Key As String, Optional OutputInHex As Boolean) As String
    Dim byteArray() As Byte
    byteArray() = StrConv(Text, vbFromUnicode)
    Call EncryptByte(byteArray(), Key)
    EncryptString = StrConv(byteArray(), vbUnicode)
    If OutputInHex = True Then EncryptString = EnHex(EncryptString)
End Function
Public Function DecryptString(Text As String, Optional Key As String, Optional IsTextInHex As Boolean) As String
    Dim byteArray() As Byte
    If IsTextInHex = True Then Text = DeHex(Text)
    byteArray() = StrConv(Text, vbFromUnicode)
    Call DecryptByte(byteArray(), Key)
    DecryptString = StrConv(byteArray(), vbUnicode)
End Function
Public Sub EncryptByte(byteArray() As Byte, Optional Key As String)
    Dim x As Long, Sum As Long, Offset As Long, OrigLen As Long, LeftWord As Long, RightWord As Long, CipherLen As Long, CipherLeft As Long, CipherRight As Long, CurrPercent As Long, NextPercent As Long, Sl As Long, Sr As Long
    
    If (Len(Key) > 0) Then Me.Key = Key
    OrigLen = UBound(byteArray) + 1
    CipherLen = OrigLen + 12
    If (CipherLen Mod 8 <> 0) Then CipherLen = CipherLen + 8 - (CipherLen Mod 8)
    ReDim Preserve byteArray(CipherLen - 1)
    Call CopyMem(byteArray(12), byteArray(0), OrigLen)
    Call CopyMem(byteArray(8), OrigLen, 4)
    Call Randomize
    Call CopyMem(byteArray(0), CLng(2147483647 * Rnd), 4)
    Call CopyMem(byteArray(4), CLng(2147483647 * Rnd), 4)
    For Offset = 0 To (CipherLen - 1) Step 8
        Call GetWord(LeftWord, byteArray(), Offset)
        Call GetWord(RightWord, byteArray(), Offset + 4)
        LeftWord = LeftWord Xor CipherLeft
        RightWord = RightWord Xor CipherRight
        Sum = 0
        For x = 1 To ROUNDS
            If (m_RunningCompiled) Then
                Sum = (Sum + Delta)
                Sr = ((RightWord And &HFFFFFFE0) \ 32) And &H7FFFFFF
                LeftWord = LeftWord + (((RightWord * 16) + Tk(0)) Xor (RightWord + Sum) Xor (Sr + Tk(1)))
                Sl = ((LeftWord And &HFFFFFFE0) \ 32) And &H7FFFFFF
                RightWord = RightWord + (((LeftWord * 16) + Tk(2)) Xor (LeftWord + Sum) Xor (Sl + Tk(3)))
            Else
                Sum = UnsignedAdd(Sum, Delta)
                LeftWord = UnsignedAdd(LeftWord, (UnsignedAdd(LShift4(RightWord), Tk(0)) Xor UnsignedAdd(RightWord, Sum) Xor UnsignedAdd(RShift5(RightWord), Tk(1))))
                RightWord = UnsignedAdd(RightWord, (UnsignedAdd(LShift4(LeftWord), Tk(2)) Xor UnsignedAdd(LeftWord, Sum) Xor UnsignedAdd(RShift5(LeftWord), Tk(3))))
            End If
        Next
        Call PutWord(LeftWord, byteArray(), Offset)
        Call PutWord(RightWord, byteArray(), Offset + 4)
        CipherLeft = LeftWord
        CipherRight = RightWord
        If (Offset >= NextPercent) Then
            CurrPercent = Int((Offset / CipherLen) * 100)
            NextPercent = (CipherLen * ((CurrPercent + 1) / 100)) + 1
            RaiseEvent Progress(CurrPercent)
        End If
    Next
    If (CurrPercent <> 100) Then RaiseEvent Progress(100)
End Sub
Private Static Function LShift4(Data1 As Long) As Long
    Dim x1(0 To 3) As Byte, xx(0 To 3) As Byte
    Call CopyMem(x1(0), Data1, 4)
    xx(0) = ((x1(0) And 15) * 16)
    xx(1) = ((x1(1) And 15) * 16) Or ((x1(0) And 240) \ 16)
    xx(2) = ((x1(2) And 15) * 16) Or ((x1(1) And 240) \ 16)
    xx(3) = ((x1(3) And 15) * 16) Or ((x1(2) And 240) \ 16)
    Call CopyMem(LShift4, xx(0), 4)
End Function
Private Static Function RShift5(Data1 As Long) As Long
    Dim x1(0 To 3) As Byte, xx(0 To 3) As Byte
    Call CopyMem(x1(0), Data1, 4)
    xx(0) = ((x1(0) And 224) \ 32) Or ((x1(1) And 31) * 8)
    xx(1) = ((x1(1) And 224) \ 32) Or ((x1(2) And 31) * 8)
    xx(2) = ((x1(2) And 224) \ 32) Or ((x1(3) And 31) * 8)
    xx(3) = ((x1(3) And 224) \ 32)
    Call CopyMem(RShift5, xx(0), 4)
End Function
Public Sub DecryptByte(byteArray() As Byte, Optional Key As String)
    On Error GoTo errorhandler
    Dim x As Long, Sum As Long, Offset As Long, OrigLen As Long, LeftWord As Long, RightWord As Long, CipherLen As Long, CipherLeft As Long, CipherRight As Long, CurrPercent As Long, NextPercent As Long, Sr As Long, Sl As Long
    
    If (Len(Key) > 0) Then Me.Key = Key
    CipherLen = UBound(byteArray) + 1
    For Offset = 0 To (CipherLen - 1) Step 8
        Call GetWord(LeftWord, byteArray(), Offset)
        Call GetWord(RightWord, byteArray(), Offset + 4)
        Sum = DecryptSum
        For x = 1 To ROUNDS
            If (m_RunningCompiled) Then
                Sl = ((LeftWord And &HFFFFFFE0) \ 32) And &H7FFFFFF
                RightWord = RightWord - (((LeftWord * 16) + Tk(2)) Xor (LeftWord + Sum) Xor (Sl + Tk(3)))
                Sr = ((RightWord And &HFFFFFFE0) \ 32) And &H7FFFFFF
                LeftWord = LeftWord - (((RightWord * 16) + Tk(0)) Xor (RightWord + Sum) Xor (Sr + Tk(1)))
                Sum = (Sum - Delta)
            Else
                RightWord = UnsignedDel(RightWord, (UnsignedAdd(LShift4(LeftWord), Tk(2)) Xor UnsignedAdd(LeftWord, Sum) Xor UnsignedAdd(RShift5(LeftWord), Tk(3))))
                LeftWord = UnsignedDel(LeftWord, (UnsignedAdd(LShift4(RightWord), Tk(0)) Xor UnsignedAdd(RightWord, Sum) Xor UnsignedAdd(RShift5(RightWord), Tk(1))))
                Sum = UnsignedDel(Sum, Delta)
          End If
        Next
        LeftWord = LeftWord Xor CipherLeft
        RightWord = RightWord Xor CipherRight
        Call GetWord(CipherLeft, byteArray(), Offset)
        Call GetWord(CipherRight, byteArray(), Offset + 4)
        Call PutWord(LeftWord, byteArray(), Offset)
        Call PutWord(RightWord, byteArray(), Offset + 4)
        If (Offset >= NextPercent) Then
            CurrPercent = Int((Offset / CipherLen) * 100)
            NextPercent = (CipherLen * ((CurrPercent + 1) / 100)) + 1
            RaiseEvent Progress(CurrPercent)
        End If
    Next
    Call CopyMem(OrigLen, byteArray(8), 4)
    If (CipherLen - OrigLen > 19) Or (CipherLen - OrigLen < 12) Then Call Err.Raise(vbObjectError, , "Incorrect size descriptor in TEA decryption")
    Call CopyMem(byteArray(0), byteArray(12), OrigLen)
    ReDim Preserve byteArray(OrigLen - 1)
    If (CurrPercent <> 100) Then RaiseEvent Progress(100)
    
errorhandler:
End Sub
Public Property Let Key(New_Value As String)
    Dim K() As Byte, w(0 To 3) As Byte
    K() = StrConv(New_Value, vbFromUnicode)
    If (Len(New_Value) < 16) Then ReDim Preserve K(15)
    w(0) = K(3)
    w(1) = K(2)
    w(2) = K(1)
    w(3) = K(0)
    Call CopyMem(Tk(0), w(0), 4)
    w(0) = K(7)
    w(1) = K(6)
    w(2) = K(5)
    w(3) = K(4)
    Call CopyMem(Tk(1), w(0), 4)
    w(0) = K(11)
    w(1) = K(10)
    w(2) = K(9)
    w(3) = K(8)
    Call CopyMem(Tk(2), w(0), 4)
    w(0) = K(15)
    w(1) = K(14)
    w(2) = K(13)
    w(3) = K(12)
    Call CopyMem(Tk(3), w(0), 4)
End Property
Private Sub Class_Initialize()
On Local Error Resume Next
m_RunningCompiled = ((2147483647 + 1) < 0)
End Sub
