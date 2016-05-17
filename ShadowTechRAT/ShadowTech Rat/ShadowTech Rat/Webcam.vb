Public Class Webcam
    Public camList As WebcamDevice

    Sub New(ByVal c As Connection)
        InitializeComponent() : Me.Tag = c
        camList = New WebcamDevice With {.Tag = c}
    End Sub

    Private Sub Webcam_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        PictureBox1.Image = Nothing
    End Sub

    Private Sub Webcam_Shown(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Shown
        Dim result As DialogResult = camList.ShowDialog
        If result = DialogResult.OK Then
            DirectCast(Me.Tag, Connection).Send("StartWebcam|" & camList.index)
        ElseIf result = DialogResult.Cancel Then
            Me.Close()
        End If
    End Sub

    Private Sub Webcam_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        DirectCast(Me.Tag, Connection).Send("StopWebcam|")
    End Sub
End Class