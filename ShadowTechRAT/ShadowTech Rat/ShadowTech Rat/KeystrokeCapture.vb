Public Class KeystrokeCapture

    Sub New(ByVal c As Connection)
        InitializeComponent() : Me.Tag = c
    End Sub

    Private Sub KeystrokeCapture_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub

    Private Sub KeystrokeCapture_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        DirectCast(Me.Tag, Connection).Send("StopKeystrokeCapture|")
    End Sub

    Private Sub TextBox1_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TextBox1.TextChanged
        TextBox1.SelectionStart = TextBox1.TextLength : TextBox1.ScrollToCaret()
    End Sub

    Private Sub ClearToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ClearToolStripMenuItem.Click
        DirectCast(Me.Tag, Connection).Send("ClearKeystrokeCapture|") : TextBox1.Text = ""
    End Sub

    Private Sub SaveToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveToolStripMenuItem.Click
        Try
            Dim sfd As New SaveFileDialog With {.Filter = "Text Files (*.txt)|*.txt"}
            If sfd.ShowDialog = DialogResult.OK Then
                IO.File.WriteAllText(sfd.FileName, TextBox1.Text)
            End If
        Catch
        End Try
    End Sub
End Class