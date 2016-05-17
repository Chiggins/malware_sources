Public Class ipport


    Private Sub ButtonX1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonX1.Click
        Static i As Integer = 0
        Dim newItem As New ListViewItem(TextBox1.Text) '// add text Item.
        newItem.SubItems.Add(TextBox2.Text) '// add SubItem.
        builder.Reverse.Items.Add(newItem) '// add Item to ListView.
        i += 1
        MsgBox(TextBox1.Text & ":" & TextBox2.Text & " succefully added !")
        Me.Hide()

    End Sub
End Class