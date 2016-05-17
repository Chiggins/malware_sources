Imports System.Management
Public Class Form1

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        Dim HWID As String = String.Empty
        Dim mc As New ManagementClass("win32_processor")
        Dim moc As ManagementObjectCollection = mc.GetInstances()
        For Each mo As ManagementObject In moc
            If HWID = "" Then
                HWID = mo.Properties("processorID").Value.ToString()
                Exit For
            End If
        Next
        TextBox1.Text = HWID
    End Sub

End Class
