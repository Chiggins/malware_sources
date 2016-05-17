Public Class Download

    Private Sub Download_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        TextBox1.Text = ""
        TextBox2.Text = ""
        TextBox1.Focus()
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        If TextBox1.Text = "" Or TextBox2.Text = "" Then
            Exit Sub
        End If
        Me.DialogResult = DialogResult.OK
        Me.Close()
    End Sub

    Private Sub Download_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles Me.KeyDown
        If Me.ActiveControl.Name = TextBox1.Name Or Me.ActiveControl.Name = TextBox2.Name Then
            If e.KeyCode = Keys.Enter Then
                Button1.PerformClick()
            End If
        End If
    End Sub

    Public ReadOnly Property downloadLink
        Get
            Return TextBox1.Text
        End Get
    End Property

    Public ReadOnly Property filename
        Get
            Return TextBox2.Text
        End Get
    End Property
End Class