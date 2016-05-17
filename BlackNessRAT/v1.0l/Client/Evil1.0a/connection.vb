Imports System.Net, System.Net.Sockets, System.IO
Public Class connection
    Private client As TcpClient
    Private IP As String
    Private ID As String
    Private HostS As String
    Public Event GotInfo(ByVal client As Connection, ByVal Message As String)
    Public Event Disconnected(ByVal client As Connection)
    Sub New(ByVal client As TcpClient)
        Me.client = client
        client.GetStream().BeginRead(New Byte() {0}, 0, 0, AddressOf Read, Nothing)
        IP = client.Client.RemoteEndPoint.ToString().Remove(client.Client.RemoteEndPoint.ToString().LastIndexOf(":"))
        ID = settings.INIRead(Application.StartupPath & "/Settings.ini", "Settings", "ID")
        HostS = client.Connected.ToString
    End Sub
    Sub Read(ByVal ar As IAsyncResult)
        Dim Message As String
        Try
            Dim reader As New StreamReader(client.GetStream())
            Message = reader.ReadLine()
            RaiseEvent GotInfo(Me, Message)
            client.GetStream().BeginRead(New Byte() {0}, 0, 0, AddressOf Read, Nothing)
        Catch ex As Exception
            RaiseEvent Disconnected(Me)
        End Try
    End Sub
    Public Sub Send(ByVal Message As String)
        Try
            Dim writer As New StreamWriter(client.GetStream())
            writer.WriteLine(Message)
            writer.Flush()
        Catch ex As Exception
            Console.WriteLine(ex.Message)
        End Try
    End Sub
    Public ReadOnly Property IPAddress
        Get
            Return IP
        End Get
    End Property

    Public ReadOnly Property IDLog
        Get
            Return ID
        End Get
    End Property

    Public ReadOnly Property HostSv
        Get
            Return HostS
        End Get
    End Property
End Class
