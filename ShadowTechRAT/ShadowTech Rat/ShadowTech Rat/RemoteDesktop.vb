Public Class RemoteDesktop

    Sub New(ByVal c As Connection)
        InitializeComponent() : Me.Tag = c
    End Sub

    Private Sub RemoteDesktop_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub

    Private Sub RemoteDesktop_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        DirectCast(Me.Tag, Connection).Send("StopDesktop|")
    End Sub

    Private Sub PictureBox1_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles PictureBox1.MouseDown
        Dim coordinates As String = PictureBox1.Size.ToString
        Dim x As Double = e.X / Convert.ToInt32(coordinates.Substring(7, coordinates.IndexOf(",") - 7))
        Dim y As Double = e.Y / Convert.ToInt32(coordinates.Substring(coordinates.IndexOf(",") + 9).Trim("}"))
        If e.Button = MouseButtons.Left Then
            DirectCast(Me.Tag, Connection).Send("LClickDown|" & x.ToString & "|" & y.ToString)
        ElseIf e.Button = MouseButtons.Right Then
            DirectCast(Me.Tag, Connection).Send("RClickDown|" & x.ToString & "|" & y.ToString)
        End If
    End Sub

    Private Sub PictureBox1_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles PictureBox1.MouseMove
        Dim coordinates As String = PictureBox1.Size.ToString
        Dim x As Double = e.X / Convert.ToInt32(coordinates.Substring(7, coordinates.IndexOf(",") - 7))
        Dim y As Double = e.Y / Convert.ToInt32(coordinates.Substring(coordinates.IndexOf(",") + 9).Trim("}"))
        DirectCast(Me.Tag, Connection).Send("MoveMouse|" & x.ToString & "|" & y.ToString)
    End Sub

    Private Sub PictureBox1_MouseUp(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles PictureBox1.MouseUp
        Dim coordinates As String = PictureBox1.Size.ToString
        Dim x As Double = e.X / Convert.ToInt32(coordinates.Substring(7, coordinates.IndexOf(",") - 7))
        Dim y As Double = e.Y / Convert.ToInt32(coordinates.Substring(coordinates.IndexOf(",") + 9).Trim("}"))
        If e.Button = MouseButtons.Left Then
            DirectCast(Me.Tag, Connection).Send("LClickUp|" & x.ToString & "|" & y.ToString)
        ElseIf e.Button = MouseButtons.Right Then
            DirectCast(Me.Tag, Connection).Send("RClickUp|" & x.ToString & "|" & y.ToString)
        End If
    End Sub
End Class