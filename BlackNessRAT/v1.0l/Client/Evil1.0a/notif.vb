Public Class notif

    Friend Sub hbwait(ByVal ms_to_wait As Long)
        Dim endwait As Double
        endwait = Environment.TickCount + ms_to_wait
        While (Environment.TickCount < endwait)
            System.Threading.Thread.Sleep(1)
            Application.DoEvents()
        End While
    End Sub


    Private Sub notif_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        For Each item As ListViewItem In Form1.lstClients.Items
            Label6.Text = item.SubItems(1).Text
            Label5.Text = item.SubItems(3).Text
            Label7.Text = item.SubItems(5).Text
            Exit For
        Next

        Me.SetDesktopLocation(My.Computer.Screen.WorkingArea.Width - 285, _
                              My.Computer.Screen.WorkingArea.Height - 140)
        Me.Show()
        closetime()
    End Sub

    Private Sub closetime()
        hbwait(10000)
        Me.Close()
    End Sub

    Private Sub notif_click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Click
        Me.Close()
    End Sub

    Private Sub notif_FormClosing() Handles MyBase.FormClosing
        For FadeOut = 90 To 10 Step -10
            Me.Opacity = FadeOut / 100
            Me.Refresh()
            Threading.Thread.Sleep(40)
        Next
    End Sub
End Class