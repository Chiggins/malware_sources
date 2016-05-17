Public Class background

    Public ReadOnly Property backgroundl
        Get
            Return TextBox1.Text
        End Get
    End Property

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        Me.DialogResult = Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub background_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
   
    End Sub
End Class