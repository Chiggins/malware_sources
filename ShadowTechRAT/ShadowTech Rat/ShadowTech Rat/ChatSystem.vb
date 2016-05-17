Public Class ChatSystem

    Sub New(ByVal c As Connection)
        InitializeComponent() : Me.Tag = c
    End Sub

    Private Sub ChatSystem_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub

    Private Sub ChatSystem_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles Me.KeyDown
        If e.KeyCode = Keys.Enter Then
            If Me.ActiveControl.Name = TextBox2.Name Then Button1.PerformClick()
        End If
    End Sub

    Private Sub ChatSystem_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        DirectCast(Me.Tag, Connection).Send("StopChatSystem")
    End Sub

    Private Sub TextBox1_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TextBox1.TextChanged
        TextBox1.SelectionStart = TextBox1.TextLength : TextBox1.ScrollToCaret()
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        If TextBox2.Text.Replace(" ", "") = "" Then
            Exit Sub
        End If
        DirectCast(Me.Tag, Connection).Send("Chat|" & TextBox2.Text)
        TextBox1.Text += "[" & TimeOfDay & "] You: " & vbNewLine & TextBox2.Text & vbNewLine & vbNewLine
        TextBox2.Clear()
    End Sub
End Class