Public Class WebcamDevice
    Public index As String = "0"
    Public cancel As Boolean = True
    Sub New()
        InitializeComponent()
    End Sub

    Private Sub WebcamDevice_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        ListView1.Items.Clear() : DirectCast(Me.Tag, Connection).Send("GetWebcamList|")
    End Sub

    Private Sub WebcamDevice_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        If cancel Then Me.DialogResult = DialogResult.Cancel
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        If Not ListView1.SelectedItems.Count = 0 Then
            index = ListView1.FocusedItem.Index.ToString
            Me.DialogResult = Windows.Forms.DialogResult.OK : cancel = False : Me.Close()
        End If
    End Sub
End Class