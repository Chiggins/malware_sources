Attribute VB_Name = "Module2"
'RC4 Module
'Author Not Known

Option Explicit
Private i As Integer
Private j As Integer
Private k As Integer
Private a As Byte
Private b As Byte
Dim M As Integer
Private L As Long
Private RC4KEY(255) As Byte
Private ADDTABLE(255, 255) As Byte
Dim STATE(0 To 255) As Byte

Private Sub FILL_LINEAR()
Dim bCONST(0 To 255) As Byte
For M = 0 To 255
bCONST(M) = M
STATE(M) = bCONST(M)
Next M
End Sub

Public Sub RC4(BYTEARRAY() As Byte, Optional PASSWORD As String)
If PASSWORD <> "" Then PREPARE_KEY PASSWORD
For L = 0 To UBound(BYTEARRAY)
i = ADDTABLE(i, 1)
j = ADDTABLE(j, STATE(i))
a = STATE(i): STATE(i) = STATE(j): STATE(j) = a
b = STATE(ADDTABLE(STATE(i), STATE(j)))
BYTEARRAY(L) = BYTEARRAY(L) Xor b
Next L
End Sub

Private Sub PREPARE_KEY(sKEY As String)
INITIALIZE_ADDTABLE
FILL_LINEAR
k = Len(sKEY)
For i = 0 To k - 1
b = Asc(Mid$(sKEY, i + 1, 1))
For j = i To 255 Step k
RC4KEY(j) = b
Next j
Next i
j = 0
For i = 0 To 255
k = ADDTABLE(STATE(i), RC4KEY(i))
j = ADDTABLE(j, k)
b = STATE(i): STATE(i) = STATE(j): STATE(j) = b
Next i
i = 0
j = 0
End Sub

Private Sub INITIALIZE_ADDTABLE()
Static BeenHereDoneThat As Boolean
If BeenHereDoneThat Then Exit Sub
For j = 0 To 255
For i = 0 To 255
ADDTABLE(i, j) = CByte((i + j) And 255)
Next i
Next j
BeenHereDoneThat = True
End Sub

Public Function STRING_TO_BYTES(sString As String) As Byte()
STRING_TO_BYTES = StrConv(sString, vbFromUnicode)
End Function

Public Function BYTES_TO_STRING(bBytes() As Byte) As String
BYTES_TO_STRING = bBytes
BYTES_TO_STRING = StrConv(BYTES_TO_STRING, vbUnicode)
End Function

Public Function RC4_String(InputStr As String, PasswordStr As String) As String
Dim tmpByte() As Byte
tmpByte = STRING_TO_BYTES(InputStr)
RC4 tmpByte, PasswordStr
RC4_String = BYTES_TO_STRING(tmpByte)
End Function



