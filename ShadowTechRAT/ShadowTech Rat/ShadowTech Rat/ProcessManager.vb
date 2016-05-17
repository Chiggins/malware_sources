Public Class ProcessManager
    Public suspendedList As New ArrayList
    Sub New(ByVal c As Connection)
        InitializeComponent() : Me.Tag = c
    End Sub

    Private Sub ProcessManager_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub

    Private Sub ProcessManager_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        ListView1.Items.Clear()
    End Sub

    Private Sub RefreshToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RefreshToolStripMenuItem.Click
        DirectCast(Me.Tag, Connection).Send("GetProcesses|")
    End Sub

    Private Sub ResumeToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ResumeToolStripMenuItem.Click
        Dim allprocess As String = ""
        For Each item As ListViewItem In ListView1.SelectedItems
            If item.BackColor = Color.Red Then
                allprocess += (item.Text & "ProcessSplit")
                suspendedList.Remove(item.SubItems(1).Text)
                item.BackColor = Color.White
            End If
        Next
        DirectCast(Me.Tag, Connection).Send("ResumeProcess|" & allprocess)
    End Sub

    Private Sub SuspendToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SuspendToolStripMenuItem.Click
        Dim allprocess As String = ""
        For Each item As ListViewItem In ListView1.SelectedItems
            If Not item.BackColor = Color.Red Then
                item.BackColor = Color.Red
                suspendedList.Add(item.SubItems(1).Text)
                allprocess += (item.Text & "ProcessSplit")
            End If
        Next
        DirectCast(Me.Tag, Connection).Send("SuspendProcess|" & allprocess)
    End Sub

    Private Sub KillToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles KillToolStripMenuItem.Click
        Dim allprocess As String = ""
        For Each item As ListViewItem In ListView1.SelectedItems
            allprocess += (item.Text & "ProcessSplit")
        Next
        DirectCast(Me.Tag, Connection).Send("KillProcess|" & allprocess)
        RefreshToolStripMenuItem.PerformClick()
    End Sub
End Class