Public Class Clipboard

    Sub New(ByVal c As Connection)
        InitializeComponent() : Me.Tag = c
    End Sub

    Private Sub Clipboard_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub

    Private Sub RefreshToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RefreshToolStripMenuItem.Click
        DirectCast(Me.Tag, Connection).Send("GetClipboard|")
    End Sub

    Private Sub SaveToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveToolStripMenuItem.Click
        Dim sfd As New SaveFileDialog With {.Filter = "Text Files (*.txt)|*.txt"}
        If sfd.ShowDialog = DialogResult.OK Then
            IO.File.WriteAllText(sfd.FileName, TextBox1.Text)
        End If
    End Sub
End Class