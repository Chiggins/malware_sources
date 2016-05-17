Imports Microsoft.VisualBasic.CompilerServices
Imports System.Collections.Generic
Imports System.Diagnostics
Imports System.Net
Imports System.Net.Sockets
Imports System.Runtime.CompilerServices
Imports System.Threading

Namespace LuxNET
    Friend NotInheritable Class ServerListener
        Implements IDisposable
        Private _BufferSize As UShort
        Private _MaxPacketSize As Integer
        Private _KeepAlive As Boolean
        Private _MaxConnections As UShort
        Private _Listening As Boolean
        Private _Clients As List(Of ServerClient)
        Private Handle As Socket
        Private Processing As Boolean
        Private Item As SocketAsyncEventArgs
        Private DisposedValue As Boolean

        Public Property BufferSize() As UShort
            Get
                Return Me._BufferSize
            End Get
            Set(value As UShort)
                If CInt(value) < 1 Then
                    Throw New Exception("Value must be greater than 0.")
                End If
                Me._BufferSize = value
            End Set
        End Property

        Public Property MaxPacketSize() As Integer
            Get
                Return Me._MaxPacketSize
            End Get
            Set(value As Integer)
                If value < 1 Then
                    Throw New Exception("Value must be greater than 0.")
                End If
                Me._MaxPacketSize = value
            End Set
        End Property

        Public Property KeepAlive() As Boolean
            Get
                Return Me._KeepAlive
            End Get
            Set(value As Boolean)
                If Me._Listening Then
                    Throw New Exception("Unable to change this option while listening.")
                End If
                Me._KeepAlive = value
            End Set
        End Property

        Public Property MaxConnections() As UShort
            Get
                Return Me._MaxConnections
            End Get
            Set(value As UShort)
                Me._MaxConnections = value
            End Set
        End Property

        Public ReadOnly Property Listening() As Boolean
            Get
                Return Me._Listening
            End Get
        End Property

        Public ReadOnly Property Clients() As ServerClient()
            Get
                If Me._Listening Then
                    Return Me._Clients.ToArray()
                Else
                    Return New ServerClient(-1) {}
                End If
            End Get
        End Property

        Public Event StateChanged As ServerListener.StateChangedEventHandler

        Public Event ExceptionThrown As ServerListener.ExceptionThrownEventHandler

        Public Event ClientExceptionThrown As ServerListener.ClientExceptionThrownEventHandler

        Public Event ClientStateChanged As ServerListener.ClientStateChangedEventHandler

        Public Event ClientReadPacket As ServerListener.ClientReadPacketEventHandler

        Public Event ClientReadProgressChanged As ServerListener.ClientReadProgressChangedEventHandler

        Public Event ClientWritePacket As ServerListener.ClientWritePacketEventHandler

        Public Event ClientWriteProgressChanged As ServerListener.ClientWriteProgressChangedEventHandler

        Public Sub New()
            Me._BufferSize = CUShort(8192)
            Me._MaxPacketSize = 10485760
            Me._KeepAlive = True
            Me._MaxConnections = CUShort(20)
        End Sub

        Private Sub OnStateChanged(listening As Boolean)
            Dim changedEventHandler As ServerListener.StateChangedEventHandler = Me.StateChangedEvent
            If changedEventHandler Is Nothing Then
                Return
            End If
            changedEventHandler(Me, listening)
        End Sub

        Private Sub OnExceptionThrown(ex As Exception)
            Dim thrownEventHandler As ServerListener.ExceptionThrownEventHandler = Me.ExceptionThrownEvent
            If thrownEventHandler Is Nothing Then
                Return
            End If
            thrownEventHandler(Me, ex)
        End Sub

        Private Sub OnClientExceptionThrown(client As ServerClient, ex As Exception)
            Dim thrownEventHandler As ServerListener.ClientExceptionThrownEventHandler = Me.ClientExceptionThrownEvent
            If thrownEventHandler Is Nothing Then
                Return
            End If
            thrownEventHandler(Me, client, ex)
        End Sub

        Private Sub OnClientStateChanged(client As ServerClient, connected As Boolean)
            Dim changedEventHandler As ServerListener.ClientStateChangedEventHandler = Me.ClientStateChangedEvent
            If changedEventHandler Is Nothing Then
                Return
            End If
            changedEventHandler(Me, client, connected)
        End Sub

        Private Sub OnClientReadPacket(client As ServerClient, data As Byte())
            Dim packetEventHandler As ServerListener.ClientReadPacketEventHandler = Me.ClientReadPacketEvent
            If packetEventHandler Is Nothing Then
                Return
            End If
            packetEventHandler(Me, client, data)
        End Sub

        Private Sub OnClientReadProgressChanged(client As ServerClient, progress As Double, bytesRead As Integer, bytesToRead As Integer)
            Dim changedEventHandler As ServerListener.ClientReadProgressChangedEventHandler = Me.ClientReadProgressChangedEvent
            If changedEventHandler Is Nothing Then
                Return
            End If
            changedEventHandler(Me, client, progress, bytesRead, bytesToRead)
        End Sub

        Private Sub OnClientWritePacket(client As ServerClient, size As Integer)
            Dim packetEventHandler As ServerListener.ClientWritePacketEventHandler = Me.ClientWritePacketEvent
            If packetEventHandler Is Nothing Then
                Return
            End If
            packetEventHandler(Me, client, size)
        End Sub

        Private Sub OnClientWriteProgressChanged(client As ServerClient, progress As Double, bytesWritten As Integer, bytesToWrite As Integer)
            Dim changedEventHandler As ServerListener.ClientWriteProgressChangedEventHandler = Me.ClientWriteProgressChangedEvent
            If changedEventHandler Is Nothing Then
                Return
            End If
            changedEventHandler(Me, client, progress, bytesWritten, bytesToWrite)
        End Sub

        Public Sub Listen(port As UShort)
            Try
                If Me._Listening Then
                    Return
                End If
                Me._Clients = New List(Of ServerClient)()
                Me.Item = New SocketAsyncEventArgs()
                AddHandler Me.Item.Completed, New EventHandler(Of SocketAsyncEventArgs)(AddressOf Me.Process)
                Me.Item.AcceptSocket = New Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp)
                Me.Item.AcceptSocket.NoDelay = True
                If Me._KeepAlive Then
                    Me.Item.AcceptSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.KeepAlive, 20000)
                End If
                Me.Handle = New Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp)
                Me.Handle.Bind(DirectCast(New IPEndPoint(IPAddress.Any, CInt(port)), EndPoint))
                Me.Handle.Listen(10)
                Me.Processing = False
                Me._Listening = True
                Me.OnStateChanged(True)
                If Not Me.Handle.AcceptAsync(Me.Item) Then
                    Me.Process(DirectCast(Nothing, Object), Me.Item)
                End If
            Catch ex As Exception
                ProjectData.SetProjectError(ex)
                Me.OnExceptionThrown(ex)
                Me.Disconnect()
                ProjectData.ClearProjectError()
            End Try
        End Sub

        Private Sub Process(s As Object, e As SocketAsyncEventArgs)
            Try
                If e.SocketError = SocketError.Success Then
                    Dim client As New ServerClient(e.AcceptSocket, Me._BufferSize, Me._MaxPacketSize)
                    Dim list As List(Of ServerClient) = Me._Clients
                    Monitor.Enter(DirectCast(list, Object))
                    Try
                        If Me._Clients.Count < CInt(Me._MaxConnections) Then
                            Me._Clients.Add(client)
                            AddHandler client.StateChanged, New ServerClient.StateChangedEventHandler(AddressOf Me.HandleStateChanged)
                            AddHandler client.ExceptionThrown, New ServerClient.ExceptionThrownEventHandler(AddressOf Me.OnClientExceptionThrown)
                            AddHandler client.ReadPacket, New ServerClient.ReadPacketEventHandler(AddressOf Me.OnClientReadPacket)
                            AddHandler client.ReadProgressChanged, New ServerClient.ReadProgressChangedEventHandler(AddressOf Me.OnClientReadProgressChanged)
                            AddHandler client.WritePacket, New ServerClient.WritePacketEventHandler(AddressOf Me.OnClientWritePacket)
                            AddHandler client.WriteProgressChanged, New ServerClient.WriteProgressChangedEventHandler(AddressOf Me.OnClientWriteProgressChanged)
                            Me.OnClientStateChanged(client, True)
                        Else
                            client.Disconnect()
                        End If
                    Finally
                        Monitor.[Exit](DirectCast(list, Object))
                    End Try
                    e.AcceptSocket = New Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp)
                    e.AcceptSocket.NoDelay = True
                    If Me._KeepAlive Then
                        e.AcceptSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.KeepAlive, 20000)
                    End If
                    If Me.Handle.AcceptAsync(e) Then
                        Return
                    End If
                    Me.Process(DirectCast(Nothing, Object), e)
                Else
                    Me.OnExceptionThrown(DirectCast(New SocketException(CInt(e.SocketError)), Exception))
                    Me.Disconnect()
                End If
            Catch ex As Exception
                ProjectData.SetProjectError(ex)
                Me.OnExceptionThrown(ex)
                Me.Disconnect()
                ProjectData.ClearProjectError()
            End Try
        End Sub

        Public Sub Disconnect()
            ' ISSUE: unable to decompile the method.
        End Sub

        Private Sub HandleStateChanged(client As ServerClient, connected As Boolean)
            Try
                Dim list As List(Of ServerClient) = Me._Clients
                Monitor.Enter(DirectCast(list, Object))
                Try
                    Me._Clients.Remove(client)
                    Me.OnClientStateChanged(client, False)
                Finally
                    Monitor.[Exit](DirectCast(list, Object))
                End Try
            Catch ex As Exception
                ProjectData.SetProjectError(ex)
                ProjectData.ClearProjectError()
            End Try
        End Sub

        Private Sub Dispose(disposing As Boolean)
            If Not Me.DisposedValue AndAlso disposing Then
                Me.Disconnect()
            End If
            Me.DisposedValue = True
        End Sub

        Public Sub Dispose() Implements IDisposable.Dispose
            Me.Dispose(True)
            GC.SuppressFinalize(DirectCast(Me, Object))
        End Sub

        Public Delegate Sub StateChangedEventHandler(sender As ServerListener, listening As Boolean)

        Public Delegate Sub ExceptionThrownEventHandler(sender As ServerListener, ex As Exception)

        Public Delegate Sub ClientExceptionThrownEventHandler(sender As ServerListener, client As ServerClient, ex As Exception)

        Public Delegate Sub ClientStateChangedEventHandler(sender As ServerListener, client As ServerClient, connected As Boolean)

        Public Delegate Sub ClientReadPacketEventHandler(sender As ServerListener, client As ServerClient, data As Byte())

        Public Delegate Sub ClientReadProgressChangedEventHandler(sender As ServerListener, client As ServerClient, progress As Double, bytesRead As Integer, bytesToRead As Integer)

        Public Delegate Sub ClientWritePacketEventHandler(sender As ServerListener, client As ServerClient, size As Integer)

        Public Delegate Sub ClientWriteProgressChangedEventHandler(sender As ServerListener, client As ServerClient, progress As Double, bytesWritten As Integer, bytesToWrite As Integer)
    End Class
End Namespace
