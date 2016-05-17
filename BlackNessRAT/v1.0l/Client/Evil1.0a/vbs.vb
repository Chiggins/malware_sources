Public Class vbs

    Public ReadOnly Property vbs
        Get
            Return TextBox1.Text
        End Get
    End Property

    Private Sub ButtonX1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonX1.Click
        Me.DialogResult = Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub
End Class