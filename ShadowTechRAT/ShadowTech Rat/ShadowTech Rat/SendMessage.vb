Public Class SendMessage

    Private Sub SendMessage_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        TextBox1.Text = ""
        TextBox2.Text = ""
        RadioButton1.Checked = True
        RadioButton2.Checked = False
        RadioButton3.Checked = False
        RadioButton4.Checked = False
        RadioButton5.Checked = True
        RadioButton6.Checked = False
        RadioButton7.Checked = False
        RadioButton8.Checked = False
        RadioButton9.Checked = False
        RadioButton10.Checked = False
        TextBox1.Focus()
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        Me.DialogResult = DialogResult.OK
        Me.Close()
    End Sub

    Public ReadOnly Property messageicon
        Get
            If RadioButton1.Checked Then
                Return "1"
            ElseIf RadioButton2.Checked Then
                Return "2"
            ElseIf RadioButton3.Checked Then
                Return "3"
            ElseIf RadioButton4.Checked Then
                Return "4"
            Else
                Return "1"
            End If
        End Get
    End Property

    Public ReadOnly Property messagebutton
        Get
            If RadioButton5.Checked Then
                Return "1"
            ElseIf RadioButton6.Checked Then
                Return "2"
            ElseIf RadioButton7.Checked Then
                Return "3"
            ElseIf RadioButton8.Checked Then
                Return "4"
            ElseIf RadioButton9.Checked Then
                Return "5"
            ElseIf RadioButton10.Checked Then
                Return "6"
            Else
                Return "1"
            End If
        End Get
    End Property

    Public ReadOnly Property title
        Get
            Return TextBox1.Text
        End Get
    End Property

    Public ReadOnly Property message
        Get
            Return TextBox2.Text
        End Get
    End Property
End Class