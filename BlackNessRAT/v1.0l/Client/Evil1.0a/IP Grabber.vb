Imports System.Net

Public Class IP_Grabber

    Private Sub ButtonX1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonX1.Click
        Try
            If TextBox1.Text.Contains("http://") Then
                Dim iphe As IPHostEntry = Dns.GetHostEntry(TextBox1.Text.Replace("http://", String.Empty))
                TextBox2.Text = iphe.AddressList(0).ToString()
            Else
                Dim iphe As IPHostEntry = Dns.GetHostEntry(TextBox1.Text)
                TextBox2.Text = iphe.AddressList(0).ToString()
            End If
        Catch ex As Exception
            TextBox2.Text = "Error..."
        End Try
    End Sub

    Private Sub IP_Grabber_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub
End Class