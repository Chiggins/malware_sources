Public Class fakemessage

    Dim optionch As String = "0"
    Public ReadOnly Property Title
        Get
            Return TextBox1.Text
        End Get
    End Property

    Public ReadOnly Property Message
        Get
            Return TextBox2.Text
        End Get
    End Property

    Public ReadOnly Property OptionChecked
        Get
            Return optionch
        End Get
    End Property

    Private Sub TextBox2_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TextBox2.TextChanged

    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        If CheckBox1.Checked = True Then
            MsgBox(TextBox2.Text, MsgBoxStyle.Information, TextBox1.Text)
        End If
        If CheckBox2.Checked = True Then
            MsgBox(TextBox2.Text, MsgBoxStyle.Question, TextBox1.Text)
        End If
        If CheckBox3.Checked = True Then
            MsgBox(TextBox2.Text, MsgBoxStyle.Exclamation, TextBox1.Text)
        End If

        If CheckBox4.Checked = True Then
            MsgBox(TextBox2.Text, MsgBoxStyle.Critical, TextBox1.Text)
        End If
    End Sub

    Private Sub CheckBox1_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckBox1.CheckedChanged
        If CheckBox1.Checked = True Then
            CheckBox2.Enabled = False
            CheckBox3.Enabled = False
            CheckBox4.Enabled = False
        End If
        If CheckBox1.Checked = False Then
            CheckBox2.Enabled = True
            CheckBox3.Enabled = True
            CheckBox4.Enabled = True
        End If
    End Sub

    Private Sub CheckBox2_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckBox2.CheckedChanged
        If CheckBox2.Checked = True Then
            CheckBox1.Enabled = False
            CheckBox3.Enabled = False
            CheckBox4.Enabled = False
        End If
        If CheckBox2.Checked = False Then
            CheckBox1.Enabled = True
            CheckBox3.Enabled = True
            CheckBox4.Enabled = True
        End If
    End Sub

    Private Sub CheckBox3_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckBox3.CheckedChanged
        If CheckBox3.Checked = True Then
            CheckBox2.Enabled = False
            CheckBox1.Enabled = False
            CheckBox4.Enabled = False
        End If
        If CheckBox3.Checked = False Then
            CheckBox2.Enabled = True
            CheckBox1.Enabled = True
            CheckBox4.Enabled = True
        End If
    End Sub

    Private Sub CheckBox4_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckBox4.CheckedChanged
        If CheckBox4.Checked = True Then
            CheckBox2.Enabled = False
            CheckBox3.Enabled = False
            CheckBox1.Enabled = False
        End If
        If CheckBox4.Checked = False Then
            CheckBox2.Enabled = True
            CheckBox3.Enabled = True
            CheckBox1.Enabled = True
        End If
    End Sub

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        If CheckBox1.Checked = True Then
            optionch = "1"
        End If
        If CheckBox2.Checked = True Then
            optionch = "2"
        End If
        If CheckBox3.Checked = True Then
            optionch = "3"
        End If
        If CheckBox4.Checked = True Then
            optionch = "4"
        End If
        Me.DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub fakemessage_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub

    Private Sub ButtonX1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonX1.Click
        If CheckBox1.Checked = True Then
            optionch = "1"
        End If
        If CheckBox2.Checked = True Then
            optionch = "2"
        End If
        If CheckBox3.Checked = True Then
            optionch = "3"
        End If
        If CheckBox4.Checked = True Then
            optionch = "4"
        End If
        Me.DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub ButtonX2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonX2.Click
        If CheckBox1.Checked = True Then
            MsgBox(TextBox2.Text, MsgBoxStyle.Information, TextBox1.Text)
        End If
        If CheckBox2.Checked = True Then
            MsgBox(TextBox2.Text, MsgBoxStyle.Question, TextBox1.Text)
        End If
        If CheckBox3.Checked = True Then
            MsgBox(TextBox2.Text, MsgBoxStyle.Exclamation, TextBox1.Text)
        End If

        If CheckBox4.Checked = True Then
            MsgBox(TextBox2.Text, MsgBoxStyle.Critical, TextBox1.Text)
        End If
    End Sub
End Class