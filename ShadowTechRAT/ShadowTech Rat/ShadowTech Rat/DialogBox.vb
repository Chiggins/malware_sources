Public Class DialogBox

    Sub New()
        InitializeComponent()
    End Sub

    Private Sub DialogBox_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        TextBox1.Text = ""
        TextBox1.Focus()
    End Sub

    Private Sub DialogBox_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing

    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        If TextBox1.Text = "" Then
            Exit Sub
        End If
        Me.DialogResult = DialogResult.OK
        Me.Close()
    End Sub

    Private Sub DialogBox_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles Me.KeyDown
        If Me.ActiveControl.Name = TextBox1.Name Then
            If e.KeyCode = Keys.Enter Then
                Button1.PerformClick()
            End If
        End If
    End Sub

    Public ReadOnly Property inputText
        Get
            Return TextBox1.Text
        End Get
    End Property
End Class