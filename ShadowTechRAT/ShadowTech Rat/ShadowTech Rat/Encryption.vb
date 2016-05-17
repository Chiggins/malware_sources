Public Class Encryption
    Public Shared Function TripleDES(ByVal Text As String, ByVal Password As String, Optional ByVal Reverse As Boolean = False) As String
        Dim Crypt As String = Nothing
        Dim DES As New System.Security.Cryptography.TripleDESCryptoServiceProvider
        Dim Hash As New System.Security.Cryptography.MD5CryptoServiceProvider
        DES.Key = Hash.ComputeHash(System.Text.ASCIIEncoding.ASCII.GetBytes(Password))
        DES.Mode = System.Security.Cryptography.CipherMode.ECB
        Select Case Reverse
            Case True
                Dim DESDecrypter As System.Security.Cryptography.ICryptoTransform = DES.CreateDecryptor
                On Error Resume Next
                Dim Buffer As Byte() = Convert.FromBase64String(Text)
                Crypt = System.Text.ASCIIEncoding.ASCII.GetString(DESDecrypter.TransformFinalBlock(Buffer, 0, Buffer.Length))
            Case False
                Dim DESEncrypter As System.Security.Cryptography.ICryptoTransform = DES.CreateEncryptor
                Dim Buffer As Byte() = System.Text.ASCIIEncoding.ASCII.GetBytes(Text)
                Crypt = Convert.ToBase64String(DESEncrypter.TransformFinalBlock(Buffer, 0, Buffer.Length))
        End Select
        Return Crypt
    End Function
    Public Shared Function XORDecryption(ByVal CodeKey As String, ByVal DataIn As String) As String
        Dim lonDataPtr As Long
        Dim strDataOut As String = ""
        Dim intXOrValue1 As Integer
        Dim intXOrValue2 As Integer
        For lonDataPtr = 1 To (Len(DataIn) / 2)
            intXOrValue1 = Val("&H" & (Mid$(DataIn, (2 * lonDataPtr) - 1, 2)))
            intXOrValue2 = Asc(Mid$(CodeKey, ((lonDataPtr Mod Len(CodeKey)) + 1), 1))
            strDataOut = strDataOut + Chr(intXOrValue1 Xor intXOrValue2)
        Next lonDataPtr
        XORDecryption = strDataOut
    End Function
    Public Shared Function XOREncryption(ByVal CodeKey As String, ByVal DataIn As String) As String
        Dim lonDataPtr As Long
        Dim strDataOut As String = ""
        Dim temp As Integer
        Dim tempstring As String
        Dim intXOrValue1 As Integer
        Dim intXOrValue2 As Integer
        For lonDataPtr = 1 To Len(DataIn)
            intXOrValue1 = Asc(Mid$(DataIn, lonDataPtr, 1))
            'The second value comes from the code key
            intXOrValue2 = Asc(Mid$(CodeKey, ((lonDataPtr Mod Len(CodeKey)) + 1), 1))
            temp = (intXOrValue1 Xor intXOrValue2)
            tempstring = Hex(temp)
            If Len(tempstring) = 1 Then tempstring = "0" & tempstring
            strDataOut = strDataOut + tempstring
        Next lonDataPtr
        XOREncryption = strDataOut
    End Function
End Class
