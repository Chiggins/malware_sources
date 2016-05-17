VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsRijndael"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' Visual Basic AES (Rijndael) Implementation
' P. Fresle and David Midkiff (mdj2023@hotmail.com)
'
' AES (Rijndael) implementation with file support, hex conversion,
' speed string concatenation and overall optimisations for Visual Basic.
'
' Originally written in VB by P. Fresle and later optimized/overhauled
' for efficiency by David Midkiff.
'
' Information on the algorithm can be found at:
' http://csrc.nist.gov/encryption/aes/

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByVal Destination As Any, ByVal Source As Any, ByVal Length As Long)
Private Declare Sub CopyMem Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)

Private byteArray() As Byte
Private hiByte As Long
Private hiBound As Long
Private m_lOnBits(30) As Long
Private m_l2Power(30) As Long
Private m_bytOnBits(7) As Byte
Private m_byt2Power(7) As Byte
Private m_InCo(3) As Byte
Private m_fbsub(255) As Byte
Private m_rbsub(255) As Byte
Private m_ptab(255)  As Byte
Private m_ltab(255)  As Byte
Private m_ftable(255) As Long
Private m_rtable(255) As Long
Private m_rco(29) As Long
Private m_Nk As Long
Private m_Nb As Long
Private m_Nr As Long
Private m_fi(23) As Byte
Private m_ri(23) As Byte
Private m_fkey(119) As Long
Private m_rkey(119) As Long
Public Function EncryptString(Text As String, Optional Key As String, Optional OutputInHex As Boolean) As String
    Dim bytIn() As Byte, Out As String, bytKey() As Byte, lCount As Long
    bytIn = Text
    bytKey = Key
    Out = StrConv(EncryptData(bytIn, bytKey), vbUnicode)
    If OutputInHex = True Then EncryptString = EnHex(Out) Else EncryptString = Out
End Function
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
    Dim Buffer As String, FileO As Integer
    FileO = FreeFile
    Open InFile For Binary As #FileO
        Buffer = Space$(LOF(1))
        Get #FileO, , Buffer
    Close #FileO
    Buffer = EncryptString(Buffer, Key, False)
    If FileExist(OutFile) = True Then Kill OutFile
    FileO = FreeFile
    Open OutFile For Binary As #FileO
        Put #FileO, , Buffer
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
    If FileExist(OutFile) = True And Overwrite = False Then
        DecryptFile = False
        Exit Function
    End If
    Dim Buffer As String, FileO As Integer
    FileO = FreeFile
    Open InFile For Binary As #FileO
        Buffer = Space$(LOF(1))
        Get #FileO, , Buffer
    Close #FileO
    Buffer = DecryptString(Buffer, Key, False)
    If FileExist(OutFile) = True Then Kill OutFile
    FileO = FreeFile
    Open OutFile For Binary As #FileO
        Put #FileO, , Buffer
    Close #FileO
    DecryptFile = True
    Exit Function

errorhandler:
    DecryptFile = False
End Function
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
Private Sub Reset()
    hiByte = 0
    hiBound = 1024
    ReDim byteArray(hiBound)
End Sub
Public Function DecryptString(Text As String, Optional Key As String, Optional IsTextInHex As Boolean) As String
    Dim bytOut() As Byte, bytKey() As Byte, lCount As Long, lLength As Long
    bytKey = Key
    If IsTextInHex = False Then Text = EnHex(Text)
    lLength = Len(Text)
    ReDim bytOut((lLength \ 2) - 1)
    For lCount = 1 To lLength Step 2
        bytOut(lCount \ 2) = CByte("&H" & Mid$(Text, lCount, 2))
    Next
    DecryptString = DecryptData(bytOut, bytKey)
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
Private Sub Class_Initialize()
    m_InCo(0) = &HB
    m_InCo(1) = &HD
    m_InCo(2) = &H9
    m_InCo(3) = &HE
    
    m_bytOnBits(0) = 1
    m_bytOnBits(1) = 3
    m_bytOnBits(2) = 7
    m_bytOnBits(3) = 15
    m_bytOnBits(4) = 31
    m_bytOnBits(5) = 63
    m_bytOnBits(6) = 127
    m_bytOnBits(7) = 255
    
    m_byt2Power(0) = 1
    m_byt2Power(1) = 2
    m_byt2Power(2) = 4
    m_byt2Power(3) = 8
    m_byt2Power(4) = 16
    m_byt2Power(5) = 32
    m_byt2Power(6) = 64
    m_byt2Power(7) = 128
    m_lOnBits(0) = 1
    m_lOnBits(1) = 3
    m_lOnBits(2) = 7
    m_lOnBits(3) = 15
    m_lOnBits(4) = 31
    m_lOnBits(5) = 63
    m_lOnBits(6) = 127
    m_lOnBits(7) = 255
    m_lOnBits(8) = 511
    m_lOnBits(9) = 1023
    m_lOnBits(10) = 2047
    m_lOnBits(11) = 4095
    m_lOnBits(12) = 8191
    m_lOnBits(13) = 16383
    m_lOnBits(14) = 32767
    m_lOnBits(15) = 65535
    m_lOnBits(16) = 131071
    m_lOnBits(17) = 262143
    m_lOnBits(18) = 524287
    m_lOnBits(19) = 1048575
    m_lOnBits(20) = 2097151
    m_lOnBits(21) = 4194303
    m_lOnBits(22) = 8388607
    m_lOnBits(23) = 16777215
    m_lOnBits(24) = 33554431
    m_lOnBits(25) = 67108863
    m_lOnBits(26) = 134217727
    m_lOnBits(27) = 268435455
    m_lOnBits(28) = 536870911
    m_lOnBits(29) = 1073741823
    m_lOnBits(30) = 2147483647
    m_l2Power(0) = 1
    m_l2Power(1) = 2
    m_l2Power(2) = 4
    m_l2Power(3) = 8
    m_l2Power(4) = 16
    m_l2Power(5) = 32
    m_l2Power(6) = 64
    m_l2Power(7) = 128
    m_l2Power(8) = 256
    m_l2Power(9) = 512
    m_l2Power(10) = 1024
    m_l2Power(11) = 2048
    m_l2Power(12) = 4096
    m_l2Power(13) = 8192
    m_l2Power(14) = 16384
    m_l2Power(15) = 32768
    m_l2Power(16) = 65536
    m_l2Power(17) = 131072
    m_l2Power(18) = 262144
    m_l2Power(19) = 524288
    m_l2Power(20) = 1048576
    m_l2Power(21) = 2097152
    m_l2Power(22) = 4194304
    m_l2Power(23) = 8388608
    m_l2Power(24) = 16777216
    m_l2Power(25) = 33554432
    m_l2Power(26) = 67108864
    m_l2Power(27) = 134217728
    m_l2Power(28) = 268435456
    m_l2Power(29) = 536870912
    m_l2Power(30) = 1073741824
End Sub

Private Function Lshift(ByVal lValue As Long, ByVal iShiftBits As Integer) As Long
    If iShiftBits = 0 Then
        Lshift = lValue
        Exit Function
    ElseIf iShiftBits = 31 Then
        If lValue And 1 Then Lshift = &H80000000 Else Lshift = 0
        Exit Function
    ElseIf iShiftBits < 0 Or iShiftBits > 31 Then
        Err.Raise 6
    End If
    
    If (lValue And m_l2Power(31 - iShiftBits)) Then Lshift = ((lValue And m_lOnBits(31 - (iShiftBits + 1))) * m_l2Power(iShiftBits)) Or &H80000000 Else Lshift = ((lValue And m_lOnBits(31 - iShiftBits)) * m_l2Power(iShiftBits))
End Function

Private Function Rshift(ByVal lValue As Long, ByVal iShiftBits As Integer) As Long
    If iShiftBits = 0 Then
        Rshift = lValue
        Exit Function
    ElseIf iShiftBits = 31 Then
        If lValue And &H80000000 Then Rshift = 1 Else Rshift = 0
        Exit Function
    ElseIf iShiftBits < 0 Or iShiftBits > 31 Then
        Err.Raise 6
    End If
    
    Rshift = (lValue And &H7FFFFFFE) \ m_l2Power(iShiftBits)
    
    If (lValue And &H80000000) Then Rshift = (Rshift Or (&H40000000 \ m_l2Power(iShiftBits - 1)))
End Function

Private Function LShiftByte(ByVal bytValue As Byte, ByVal bytShiftBits As Byte) As Byte
    If bytShiftBits = 0 Then
        LShiftByte = bytValue
        Exit Function
    ElseIf bytShiftBits = 7 Then
        If bytValue And 1 Then LShiftByte = &H80 Else LShiftByte = 0
        Exit Function
    ElseIf bytShiftBits < 0 Or bytShiftBits > 7 Then
        Err.Raise 6
    End If
    
    LShiftByte = ((bytValue And m_bytOnBits(7 - bytShiftBits)) * m_byt2Power(bytShiftBits))
End Function
Private Function RShiftByte(ByVal bytValue As Byte, ByVal bytShiftBits As Byte) As Byte
    If bytShiftBits = 0 Then
        RShiftByte = bytValue
        Exit Function
    ElseIf bytShiftBits = 7 Then
        If bytValue And &H80 Then RShiftByte = 1 Else RShiftByte = 0
        Exit Function
    ElseIf bytShiftBits < 0 Or bytShiftBits > 7 Then
        Err.Raise 6
    End If
    
    RShiftByte = bytValue \ m_byt2Power(bytShiftBits)
End Function
Private Function RotateLeft(ByVal lValue As Long, ByVal iShiftBits As Integer) As Long
    RotateLeft = Lshift(lValue, iShiftBits) Or Rshift(lValue, (32 - iShiftBits))
End Function

Private Function RotateLeftByte(ByVal bytValue As Byte, ByVal bytShiftBits As Byte) As Byte
    RotateLeftByte = LShiftByte(bytValue, bytShiftBits) Or RShiftByte(bytValue, (8 - bytShiftBits))
End Function
Private Function Pack(b() As Byte) As Long
    Dim lCount As Long
    Dim lTemp  As Long
    
    For lCount = 0 To 3
        lTemp = b(lCount)
        Pack = Pack Or Lshift(lTemp, (lCount * 8))
    Next
End Function

Private Function PackFrom(b() As Byte, ByVal K As Long) As Long
    Dim lCount As Long, lTemp  As Long
    
    For lCount = 0 To 3
        lTemp = b(lCount + K)
        PackFrom = PackFrom Or Lshift(lTemp, (lCount * 8))
    Next
End Function
Private Sub Unpack(ByVal a As Long, b() As Byte)
    b(0) = a And m_lOnBits(7)
    b(1) = Rshift(a, 8) And m_lOnBits(7)
    b(2) = Rshift(a, 16) And m_lOnBits(7)
    b(3) = Rshift(a, 24) And m_lOnBits(7)
End Sub
Private Sub UnpackFrom(ByVal a As Long, b() As Byte, ByVal K As Long)
    b(0 + K) = a And m_lOnBits(7)
    b(1 + K) = Rshift(a, 8) And m_lOnBits(7)
    b(2 + K) = Rshift(a, 16) And m_lOnBits(7)
    b(3 + K) = Rshift(a, 24) And m_lOnBits(7)
End Sub
Private Function xtime(ByVal a As Byte) As Byte
    Dim b As Byte
    If (a And &H80) Then b = &H1B Else b = 0
    a = LShiftByte(a, 1)
    a = a Xor b
    xtime = a
End Function
Private Function bmul(ByVal x As Byte, y As Byte) As Byte
    If x <> 0 And y <> 0 Then bmul = m_ptab((CLng(m_ltab(x)) + CLng(m_ltab(y))) Mod 255) Else bmul = 0
End Function
Private Function SubByte(ByVal a As Long) As Long
    Dim b(3) As Byte
    Unpack a, b
    b(0) = m_fbsub(b(0)): b(1) = m_fbsub(b(1))
    b(2) = m_fbsub(b(2)): b(3) = m_fbsub(b(3))
    SubByte = Pack(b)
End Function
Private Function product(ByVal x As Long, ByVal y As Long) As Long
    Dim xb(3) As Byte, yb(3) As Byte
    Unpack x, xb
    Unpack y, yb
    product = bmul(xb(0), yb(0)) Xor bmul(xb(1), yb(1)) Xor bmul(xb(2), yb(2)) Xor bmul(xb(3), yb(3))
End Function
Private Function InvMixCol(ByVal x As Long) As Long
    Dim y As Long, m As Long, b(3) As Byte

    m = Pack(m_InCo): b(3) = product(m, x)
    m = RotateLeft(m, 24): b(2) = product(m, x)
    m = RotateLeft(m, 24): b(1) = product(m, x)
    m = RotateLeft(m, 24): b(0) = product(m, x)
    y = Pack(b): InvMixCol = y
End Function

Private Function ByteSub(ByVal x As Byte) As Byte
    Dim y As Byte
    y = m_ptab(255 - m_ltab(x)): x = y
    x = RotateLeftByte(x, 1): y = y Xor x
    x = RotateLeftByte(x, 1): y = y Xor x
    x = RotateLeftByte(x, 1): y = y Xor x
    x = RotateLeftByte(x, 1): y = y Xor x
    y = y Xor &H63: ByteSub = y
End Function
Private Sub gentables()
    Dim i As Long, y As Byte, b(3) As Byte, ib As Byte
    
    m_ltab(0) = 0: m_ptab(0) = 1: m_ltab(1) = 0: m_ptab(1) = 3: m_ltab(3) = 1
    For i = 2 To 255
        m_ptab(i) = m_ptab(i - 1) Xor xtime(m_ptab(i - 1)): m_ltab(m_ptab(i)) = i
    Next
    m_fbsub(0) = &H63: m_rbsub(&H63) = 0
    For i = 1 To 255
        ib = i: y = ByteSub(ib): m_fbsub(i) = y: m_rbsub(y) = i
    Next
    y = 1
    For i = 0 To 29
        m_rco(i) = y: y = xtime(y)
    Next
    For i = 0 To 255
        y = m_fbsub(i): b(3) = y Xor xtime(y)
        b(2) = y: b(1) = y: b(0) = xtime(y)
        m_ftable(i) = Pack(b): y = m_rbsub(i)
        b(3) = bmul(m_InCo(0), y): b(2) = bmul(m_InCo(1), y)
        b(1) = bmul(m_InCo(2), y): b(0) = bmul(m_InCo(3), y)
        m_rtable(i) = Pack(b)
    Next
End Sub

Private Sub gkey(ByVal nb As Long, ByVal nk As Long, Key() As Byte)
    Dim i As Long, j As Long, K As Long, m As Long, N As Long, C1 As Long, C2 As Long, C3 As Long, CipherKey(7) As Long
    
    m_Nb = nb: m_Nk = nk
    If m_Nb >= m_Nk Then m_Nr = 6 + m_Nb Else m_Nr = 6 + m_Nk
    C1 = 1
    If m_Nb < 8 Then
        C2 = 2: C3 = 3
    Else
        C2 = 3: C3 = 4
    End If
    For j = 0 To nb - 1
        m = j * 3
        m_fi(m) = (j + C1) Mod nb: m_fi(m + 1) = (j + C2) Mod nb
        m_fi(m + 2) = (j + C3) Mod nb: m_ri(m) = (nb + j - C1) Mod nb
        m_ri(m + 1) = (nb + j - C2) Mod nb: m_ri(m + 2) = (nb + j - C3) Mod nb
    Next
    N = m_Nb * (m_Nr + 1)
    For i = 0 To m_Nk - 1
        j = i * 4: CipherKey(i) = PackFrom(Key, j)
    Next
    For i = 0 To m_Nk - 1
        m_fkey(i) = CipherKey(i)
    Next
    j = m_Nk: K = 0
    Do While j < N
        m_fkey(j) = m_fkey(j - m_Nk) Xor SubByte(RotateLeft(m_fkey(j - 1), 24)) Xor m_rco(K)
        If m_Nk <= 6 Then
            i = 1
            Do While i < m_Nk And (i + j) < N
                m_fkey(i + j) = m_fkey(i + j - m_Nk) Xor m_fkey(i + j - 1)
                i = i + 1
            Loop
        Else
            i = 1
            Do While i < 4 And (i + j) < N
                m_fkey(i + j) = m_fkey(i + j - m_Nk) Xor m_fkey(i + j - 1)
                i = i + 1
            Loop
            If j + 4 < N Then m_fkey(j + 4) = m_fkey(j + 4 - m_Nk) Xor SubByte(m_fkey(j + 3))
            i = 5
            Do While i < m_Nk And (i + j) < N
                m_fkey(i + j) = m_fkey(i + j - m_Nk) Xor m_fkey(i + j - 1)
                i = i + 1
            Loop
        End If
        j = j + m_Nk
        K = K + 1
    Loop
    For j = 0 To m_Nb - 1
        m_rkey(j + N - nb) = m_fkey(j)
    Next
    i = m_Nb
    Do While i < N - m_Nb
        K = N - m_Nb - i
        For j = 0 To m_Nb - 1
            m_rkey(K + j) = InvMixCol(m_fkey(i + j))
        Next
        i = i + m_Nb
    Loop
    j = N - m_Nb
    Do While j < N
        m_rkey(j - N + m_Nb) = m_fkey(j)
        j = j + 1
    Loop
End Sub

Private Sub Encrypt(buff() As Byte)
    Dim i As Long, j As Long, K As Long, m As Long, a(7) As Long, b(7) As Long, x() As Long, y() As Long, t() As Long
    For i = 0 To m_Nb - 1
        j = i * 4: a(i) = PackFrom(buff, j): a(i) = a(i) Xor m_fkey(i)
    Next
    K = m_Nb: x = a: y = b
    For i = 1 To m_Nr - 1
        For j = 0 To m_Nb - 1
            m = j * 3: y(j) = m_fkey(K) Xor m_ftable(x(j) And m_lOnBits(7)) Xor RotateLeft(m_ftable(Rshift(x(m_fi(m)), 8) And m_lOnBits(7)), 8) Xor RotateLeft(m_ftable(Rshift(x(m_fi(m + 1)), 16) And m_lOnBits(7)), 16) Xor RotateLeft(m_ftable(Rshift(x(m_fi(m + 2)), 24) And m_lOnBits(7)), 24): K = K + 1
        Next
        t = x: x = y: y = t
    Next
    For j = 0 To m_Nb - 1
        m = j * 3: y(j) = m_fkey(K) Xor m_fbsub(x(j) And m_lOnBits(7)) Xor RotateLeft(m_fbsub(Rshift(x(m_fi(m)), 8) And m_lOnBits(7)), 8) Xor RotateLeft(m_fbsub(Rshift(x(m_fi(m + 1)), 16) And m_lOnBits(7)), 16) Xor RotateLeft(m_fbsub(Rshift(x(m_fi(m + 2)), 24) And m_lOnBits(7)), 24): K = K + 1
    Next
    For i = 0 To m_Nb - 1
        j = i * 4: UnpackFrom y(i), buff, j: x(i) = 0: y(i) = 0
    Next
End Sub

Private Sub Decrypt(buff() As Byte)
    Dim i As Long, j As Long, K As Long, m As Long, a(7) As Long, b(7) As Long, x() As Long, y() As Long, t() As Long
    For i = 0 To m_Nb - 1
        j = i * 4: a(i) = PackFrom(buff, j): a(i) = a(i) Xor m_rkey(i)
    Next
    K = m_Nb: x = a: y = b
    For i = 1 To m_Nr - 1
        For j = 0 To m_Nb - 1
            m = j * 3: y(j) = m_rkey(K) Xor m_rtable(x(j) And m_lOnBits(7)) Xor RotateLeft(m_rtable(Rshift(x(m_ri(m)), 8) And m_lOnBits(7)), 8) Xor RotateLeft(m_rtable(Rshift(x(m_ri(m + 1)), 16) And m_lOnBits(7)), 16) Xor RotateLeft(m_rtable(Rshift(x(m_ri(m + 2)), 24) And m_lOnBits(7)), 24): K = K + 1
        Next
        t = x: x = y: y = t
    Next
    For j = 0 To m_Nb - 1
        m = j * 3: y(j) = m_rkey(K) Xor m_rbsub(x(j) And m_lOnBits(7)) Xor RotateLeft(m_rbsub(Rshift(x(m_ri(m)), 8) And m_lOnBits(7)), 8) Xor RotateLeft(m_rbsub(Rshift(x(m_ri(m + 1)), 16) And m_lOnBits(7)), 16) Xor RotateLeft(m_rbsub(Rshift(x(m_ri(m + 2)), 24) And m_lOnBits(7)), 24): K = K + 1
    Next
    For i = 0 To m_Nb - 1
        j = i * 4: UnpackFrom y(i), buff, j: x(i) = 0: y(i) = 0
    Next
End Sub


Private Function IsInitialized(ByRef vArray As Variant) As Boolean
    On Error Resume Next
    IsInitialized = IsNumeric(UBound(vArray))
End Function
Private Function EncryptData(bytMessage() As Byte, bytPassword() As Byte) As Byte()
    Dim bytKey(31) As Byte, bytIn()  As Byte, bytOut() As Byte, bytTemp(31) As Byte
    Dim lCount As Long, lLength As Long, lEncodedLength As Long, bytLen(3) As Byte, lPosition As Long
    
    If Not IsInitialized(bytMessage) Then Exit Function
    If Not IsInitialized(bytPassword) Then Exit Function
    For lCount = 0 To UBound(bytPassword)
        bytKey(lCount) = bytPassword(lCount)
        If lCount = 31 Then Exit For
    Next
    gentables
    gkey 8, 8, bytKey
    lLength = UBound(bytMessage) + 1
    lEncodedLength = lLength + 4
    If lEncodedLength Mod 32 <> 0 Then lEncodedLength = lEncodedLength + 32 - (lEncodedLength Mod 32)
    ReDim bytIn(lEncodedLength - 1)
    ReDim bytOut(lEncodedLength - 1)
    CopyMemory VarPtr(bytIn(0)), VarPtr(lLength), 4
    CopyMemory VarPtr(bytIn(4)), VarPtr(bytMessage(0)), lLength
    For lCount = 0 To lEncodedLength - 1 Step 32
        CopyMemory VarPtr(bytTemp(0)), VarPtr(bytIn(lCount)), 32
        Encrypt bytTemp
        CopyMemory VarPtr(bytOut(lCount)), VarPtr(bytTemp(0)), 32
    Next
    EncryptData = bytOut
End Function
Private Function DecryptData(bytIn() As Byte, bytPassword() As Byte) As Byte()
On Error Resume Next
    Dim bytMessage() As Byte, bytKey(31) As Byte, bytOut() As Byte
    Dim bytTemp(31) As Byte, lCount As Long, lLength As Long
    Dim lEncodedLength As Long, bytLen(3) As Byte, lPosition As Long
    If Not IsInitialized(bytIn) Then Exit Function
    If Not IsInitialized(bytPassword) Then Exit Function
    lEncodedLength = UBound(bytIn) + 1
    If lEncodedLength Mod 32 <> 0 Then Exit Function
    For lCount = 0 To UBound(bytPassword)
        bytKey(lCount) = bytPassword(lCount)
        If lCount = 31 Then Exit For
    Next
    gentables
    gkey 8, 8, bytKey
    ReDim bytOut(lEncodedLength - 1)
    For lCount = 0 To lEncodedLength - 1 Step 32
        CopyMemory VarPtr(bytTemp(0)), VarPtr(bytIn(lCount)), 32
        Decrypt bytTemp
        CopyMemory VarPtr(bytOut(lCount)), VarPtr(bytTemp(0)), 32
    Next
    CopyMemory VarPtr(lLength), VarPtr(bytOut(0)), 4
    If lLength > lEncodedLength - 4 Then Exit Function
    ReDim bytMessage(lLength - 1)
    CopyMemory VarPtr(bytMessage(0)), VarPtr(bytOut(4)), lLength
    DecryptData = bytMessage
End Function
