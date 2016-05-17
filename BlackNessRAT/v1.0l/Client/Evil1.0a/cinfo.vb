Imports System.Net, System.Net.Sockets, System.IO
Public Class cinfo
    Private client As TcpClient
    Private IP As String

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)



        For Each item As ListViewItem In Form1.lstClients.Items
            ListView1.Items(0).SubItems(1).Text = ""
            ListView1.Items(1).SubItems(1).Text = ""
            ListView1.Items(2).SubItems(1).Text = item.SubItems(3).Text
            ListView1.Items(3).SubItems(1).Text = item.SubItems(1).Text
            ListView1.Items(4).SubItems(1).Text = item.SubItems(2).Text
            ListView1.Items(5).SubItems(1).Text = item.SubItems(5).Text
            Exit For
        Next
    End Sub

    Private Sub cinfo_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

        ListView1.Items(0).SubItems(1).Text = ""
        ListView1.Items(1).SubItems(1).Text = ""
        ListView1.Items(2).SubItems(1).Text = ""
        ListView1.Items(3).SubItems(1).Text = ""
        ListView1.Items(4).SubItems(1).Text = ""
        ListView1.Items(5).SubItems(1).Text = ""
    End Sub

    Private Sub ButtonX2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonX2.Click
        ListView1.Items(0).SubItems(1).Text = ""
        ListView1.Items(1).SubItems(1).Text = ""
        ListView1.Items(2).SubItems(1).Text = ""
        ListView1.Items(3).SubItems(1).Text = ""
        ListView1.Items(4).SubItems(1).Text = ""
        ListView1.Items(5).SubItems(1).Text = ""
    End Sub

    Private Sub ButtonX1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonX1.Click

        For Each item As ListViewItem In Form1.lstClients.Items
            ListView1.Items(0).SubItems(1).Text = ""
            ListView1.Items(1).SubItems(1).Text = ""
            ListView1.Items(2).SubItems(1).Text = item.SubItems(3).Text
            ListView1.Items(3).SubItems(1).Text = item.SubItems(1).Text
            ListView1.Items(4).SubItems(1).Text = item.SubItems(2).Text
            ListView1.Items(5).SubItems(1).Text = item.SubItems(5).Text
            Exit For
        Next
    End Sub
End Class