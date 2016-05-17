Imports LuxNET.My
Imports Microsoft.VisualBasic.CompilerServices
Imports System.Collections.Generic
Imports System.Diagnostics
Imports System.Net
Imports System.Net.Sockets
Imports System.Runtime.CompilerServices
Imports System.Threading
Imports System.Windows.Forms

Namespace LuxNET
    Public Class ServerClient
        Implements IDisposable
        Private _BufferSize As UShort
        Private _MaxPacketSize As Integer
        Private _UserState As Object
        Private _EndPoint As IPEndPoint
        Private _Connected As Boolean
        Private Handle As Socket
        Private SendIndex As Integer
        Private SendBuffer As Byte()
        Private ReadIndex As Integer
        Private ReadBuffer As Byte()
        Private SendQueue As Queue(Of Byte())
        Private Processing As Boolean()
        Private Items As SocketAsyncEventArgs()
        Private DisposedValue As Boolean

        Public ReadOnly Property BufferSize() As UShort
            Get
                Return Me._BufferSize
            End Get
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

        Public Property UserState() As Object
            Get
                Return Me._UserState
            End Get
            Set(value As Object)
                Me._UserState = RuntimeHelpers.GetObjectValue(value)
            End Set
        End Property

        Public ReadOnly Property EndPoint() As IPEndPoint
            Get
                If Me._EndPoint IsNot Nothing Then
                    Return Me._EndPoint
                Else
                    Return New IPEndPoint(IPAddress.None, 0)
                End If
            End Get
        End Property

        Public ReadOnly Property Connected() As Boolean
            Get
                Return Me._Connected
            End Get
        End Property

        Public Event ExceptionThrown As ServerClient.ExceptionThrownEventHandler

        Public Event StateChanged As ServerClient.StateChangedEventHandler

        Public Event ReadPacket As ServerClient.ReadPacketEventHandler

        Public Event ReadProgressChanged As ServerClient.ReadProgressChangedEventHandler

        Public Event WritePacket As ServerClient.WritePacketEventHandler

        Public Event WriteProgressChanged As ServerClient.WriteProgressChangedEventHandler

        <DebuggerNonUserCode> _
        Shared Sub New()
        End Sub

        Public Sub New(sock As Socket, bufferSize As UShort, maxPacketSize As Integer)
            ServerClient.__ENCAddToList(DirectCast(Me, Object))
            Me._BufferSize = CUShort(8192)
            Me._MaxPacketSize = 10485760
            Me.Processing = New Boolean(1) {}
            Me.Items = New SocketAsyncEventArgs(1) {}
            Try
                Me.Initialize()
                Me.Items(0).SetBuffer(New Byte(CInt(bufferSize) - 1 + 1 - 1) {}, 0, CInt(bufferSize))
                Me.Handle = sock
                Me._BufferSize = bufferSize
                Me._MaxPacketSize = maxPacketSize
                Me._EndPoint = DirectCast(Me.Handle.RemoteEndPoint, IPEndPoint)
                Me._Connected = True
                If Me.Handle.ReceiveAsync(Me.Items(0)) Then
                    Return
                End If
                Me.Process(DirectCast(Nothing, Object), Me.Items(0))
            Catch ex As Exception
                ProjectData.SetProjectError(ex)
                Me.OnExceptionThrown(ex)
                Me.Disconnect()
                ProjectData.ClearProjectError()
            End Try
        End Sub


        Private Sub OnExceptionThrown(ex As Exception)
            Dim thrownEventHandler As ServerClient.ExceptionThrownEventHandler = Me.ExceptionThrownEvent
            If thrownEventHandler Is Nothing Then
                Return
            End If
            thrownEventHandler(Me, ex)
        End Sub

        Private Sub OnStateChanged(connected As Boolean)
            Dim changedEventHandler As ServerClient.StateChangedEventHandler = Me.StateChangedEvent
            If changedEventHandler Is Nothing Then
                Return
            End If
            changedEventHandler(Me, connected)
        End Sub

        Private Sub OnReadPacket(data As Byte())
            Dim packetEventHandler As ServerClient.ReadPacketEventHandler = Me.ReadPacketEvent
            If packetEventHandler Is Nothing Then
                Return
            End If
            packetEventHandler(Me, data)
        End Sub

        Private Sub OnReadProgressChanged(progress As Double, bytesRead As Integer, bytesToRead As Integer)
            Dim changedEventHandler As ServerClient.ReadProgressChangedEventHandler = Me.ReadProgressChangedEvent
            If changedEventHandler Is Nothing Then
                Return
            End If
            changedEventHandler(Me, progress, bytesRead, bytesToRead)
        End Sub

        Private Sub OnWritePacket(size As Integer)
            Dim packetEventHandler As ServerClient.WritePacketEventHandler = Me.WritePacketEvent
            If packetEventHandler Is Nothing Then
                Return
            End If
            packetEventHandler(Me, size)
        End Sub

        Private Sub OnWriteProgressChanged(progress As Double, bytesWritten As Integer, bytesToWrite As Integer)
            Dim changedEventHandler As ServerClient.WriteProgressChangedEventHandler = Me.WriteProgressChangedEvent
            If changedEventHandler Is Nothing Then
                Return
            End If
            changedEventHandler(Me, progress, bytesWritten, bytesToWrite)
        End Sub

        Private Sub Initialize()
            Try
                Me.Processing = New Boolean(1) {}
                Me.SendIndex = 0
                Me.ReadIndex = 0
                Me.SendBuffer = New Byte(-1) {}
                Me.ReadBuffer = New Byte(-1) {}
                Me.SendQueue = New Queue(Of Byte())()
                Me.Items = New SocketAsyncEventArgs(1) {}
                Me.Items(0) = New SocketAsyncEventArgs()
                Me.Items(1) = New SocketAsyncEventArgs()
                AddHandler Me.Items(0).Completed, New EventHandler(Of SocketAsyncEventArgs)(AddressOf Me.Process)
                AddHandler Me.Items(1).Completed, New EventHandler(Of SocketAsyncEventArgs)(AddressOf Me.Process)
            Catch ex As Exception
                ProjectData.SetProjectError(ex)
                ProjectData.ClearProjectError()
            End Try
        End Sub

        Private Sub AddSentBytes(value As Integer)
            MyProject.Forms.FormMain.Graph_Sent.AddValue(CSng(value))
        End Sub

        Private Sub AddReceivedBytes(value As Integer)
            MyProject.Forms.FormMain.Graph_Receive.AddValue(CSng(value))
        End Sub

        Private Sub Process(s As Object, e As SocketAsyncEventArgs)
            Try
                If e.SocketError = SocketError.Success Then
                    Select Case e.LastOperation
                        Case SocketAsyncOperation.Receive
                            If Not Me._Connected Then
                                Exit Select
                            End If
                            If e.BytesTransferred <> 0 Then
                                Me.HandleRead(e.Buffer, 0, e.BytesTransferred)
                                Application.OpenForms(0).Invoke(DirectCast(New ServerClient.DelegateAddReceivedBytes(AddressOf Me.AddReceivedBytes), [Delegate]), DirectCast(e.BytesTransferred, Object))
                                If Not Me.Handle.ReceiveAsync(e) Then
                                    Me.Process(DirectCast(Nothing, Object), e)
                                    Exit Select
                                Else
                                    Exit Select
                                End If
                            Else
                                Me.Disconnect()
                                Exit Select
                            End If
                        Case SocketAsyncOperation.Send
                            If Not Me._Connected Then
                                Exit Select
                            End If
                            Me.SendIndex = Me.SendIndex + e.BytesTransferred
                            Application.OpenForms(0).Invoke(DirectCast(New ServerClient.DelegateAddSentBytes(AddressOf Me.AddSentBytes), [Delegate]), DirectCast(e.BytesTransferred, Object))
                            Me.OnWriteProgressChanged(CDbl(Me.SendIndex) / CDbl(Me.SendBuffer.Length) * 100.0, Me.SendIndex, Me.SendBuffer.Length)
                            Dim flag As Boolean
                            If Me.SendIndex >= Me.SendBuffer.Length Then
                                flag = True
                                Me.OnWritePacket(Me.SendBuffer.Length - 4)
                            End If
                            If Me.SendQueue.Count = 0 AndAlso flag Then
                                Me.Processing(1) = False
                            Else
                                Me.HandleSendQueue()
                            End If
                            Exit Select
                    End Select
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
            Try
                If Me.Processing(0) Then
                    Return
                End If
                Me.Processing(0) = True
                Dim flag As Boolean = Me._Connected
                Me._Connected = False
                If Me.Handle IsNot Nothing Then
                    Me.Handle.Close()
                End If
                If Me.SendQueue IsNot Nothing Then
                    Me.SendQueue.Clear()
                End If
                Me.SendBuffer = New Byte(-1) {}
                Me.ReadBuffer = New Byte(-1) {}
                If flag Then
                    Me.OnStateChanged(False)
                End If
                If Me.Items IsNot Nothing Then
                    Me.Items(0).Dispose()
                    Me.Items(1).Dispose()
                End If
                Me._UserState = DirectCast(Nothing, Object)
                Me._EndPoint = DirectCast(Nothing, IPEndPoint)
            Catch ex As Exception
                ProjectData.SetProjectError(ex)
                ProjectData.ClearProjectError()
            End Try
        End Sub

        Public Sub Send(data As Byte())
            Try
                If Not Me._Connected Then
                    Return
                End If
                Me.SendQueue.Enqueue(data)
                If Not Me.Processing(1) Then
                    Me.Processing(1) = True
                    Me.HandleSendQueue()
                End If
            Catch ex As Exception
                ProjectData.SetProjectError(ex)
                ProjectData.ClearProjectError()
            End Try
        End Sub

        Private Sub HandleSendQueue()
            Try
                If Me.SendIndex >= Me.SendBuffer.Length Then
                    Me.SendIndex = 0
                    Me.SendBuffer = ServerClient.Header(Me.SendQueue.Dequeue())
                End If
                Me.Items(1).SetBuffer(Me.SendBuffer, Me.SendIndex, Math.Min(Me.SendBuffer.Length - Me.SendIndex, CInt(Me._BufferSize)))
                If Me.Handle.SendAsync(Me.Items(1)) Then
                    Return
                End If
                Me.Process(DirectCast(Nothing, Object), Me.Items(1))
            Catch ex As Exception
                ProjectData.SetProjectError(ex)
                Me.OnExceptionThrown(ex)
                Me.Disconnect()
                ProjectData.ClearProjectError()
            End Try
        End Sub

        Private Shared Function Header(data As Byte()) As Byte()
            Dim numArray1 As Byte()
            Try
                Dim numArray2 As Byte() = New Byte(data.Length + 3 + 1 - 1) {}
                Buffer.BlockCopy(DirectCast(BitConverter.GetBytes(data.Length), Array), 0, DirectCast(numArray2, Array), 0, 4)
                Buffer.BlockCopy(DirectCast(data, Array), 0, DirectCast(numArray2, Array), 4, data.Length)
                numArray1 = numArray2
            Catch ex As Exception
                ProjectData.SetProjectError(ex)
                ProjectData.ClearProjectError()
            End Try
            Return numArray1
        End Function

        Private Sub HandleRead(data As Byte(), index As Integer, length As Integer)
            Try
                If Me.ReadIndex >= Me.ReadBuffer.Length Then
                    Me.ReadIndex = 0
                    If data.Length < 4 Then
                        Me.OnExceptionThrown(New Exception("Missing or corrupt packet header."))
                        Me.Disconnect()
                        Return
                    Else
                        Dim newSize As Integer = BitConverter.ToInt32(data, index)
                        If newSize > Me._MaxPacketSize Then
                            Me.OnExceptionThrown(New Exception("Packet size exceeds MaxPacketSize."))
                            Me.Disconnect()
                            Return
                        Else
                            Array.Resize(Of Byte)(Me.ReadBuffer, newSize)
                            index += 4

                        End If
                    End If
                End If
                Dim count As Integer = Math.Min(Me.ReadBuffer.Length - Me.ReadIndex, length - index)
                Buffer.BlockCopy(DirectCast(data, Array), index, DirectCast(Me.ReadBuffer, Array), Me.ReadIndex, count)
                Me.ReadIndex = Me.ReadIndex + count
                Me.OnReadProgressChanged(CDbl(Me.ReadIndex) / CDbl(Me.ReadBuffer.Length) * 100.0, Me.ReadIndex, Me.ReadBuffer.Length)
                If Me.ReadIndex >= Me.ReadBuffer.Length Then
                    Me.OnReadPacket(Me.ReadBuffer)
                End If
                If count < length - index Then
                    Me.HandleRead(data, index + count, length)
                End If
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

        Public Delegate Sub ExceptionThrownEventHandler(sender As ServerClient, ex As Exception)

        Public Delegate Sub StateChangedEventHandler(sender As ServerClient, connected As Boolean)

        Public Delegate Sub ReadPacketEventHandler(sender As ServerClient, data As Byte())

        Public Delegate Sub ReadProgressChangedEventHandler(sender As ServerClient, progress As Double, bytesRead As Integer, bytesToRead As Integer)

        Public Delegate Sub WritePacketEventHandler(sender As ServerClient, size As Integer)

        Public Delegate Sub WriteProgressChangedEventHandler(sender As ServerClient, progress As Double, bytesWritten As Integer, bytesToWrite As Integer)

        Public Delegate Sub DelegateAddSentBytes(value As Integer)

        Public Delegate Sub DelegateAddReceivedBytes(value As Integer)
    End Class
End Namespace
