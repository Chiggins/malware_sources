Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections
Imports System.Collections.Specialized
Imports System.IO
Imports System.Net
Imports System.Text

Namespace LuxNET
    Public Class AnonScanner
        ' Methods
        Public Sub New(ByVal _api As String, ByVal id As String)
            AnonScanner.apiKey = _api
            AnonScanner.uid = id
        End Sub

        Public Shared Function HttpUploadFile(ByVal url As String, ByVal file As String, ByVal paramName As String, ByVal contentType As String, ByVal nvc As NameValueCollection) As String
            Dim enumerator As IEnumerator
            Dim str As String = ("---------------------------" & DateTime.Now.Ticks.ToString("x"))
            Dim bytes As Byte() = Encoding.ASCII.GetBytes((ChrW(13) & ChrW(10) & "--" & str & ChrW(13) & ChrW(10)))
            Dim request As HttpWebRequest = DirectCast(WebRequest.Create(url), HttpWebRequest)
            request.ContentType = ("multipart/form-data; boundary=" & str)
            request.Method = "POST"
            request.KeepAlive = True
            request.Credentials = CredentialCache.DefaultCredentials
            Dim requestStream As Stream = request.GetRequestStream
            Dim format As String = "Content-Disposition: form-data; name=""{0}""" & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "{1}"
            Try
                enumerator = nvc.Keys.GetEnumerator
                Do While enumerator.MoveNext
                    Dim str8 As String = Conversions.ToString(enumerator.Current)
                    requestStream.Write(bytes, 0, bytes.Length)
                    Dim str7 As String = String.Format(format, str8, nvc.Item(str8))
                    Dim buffer5 As Byte() = Encoding.UTF8.GetBytes(str7)
                    requestStream.Write(buffer5, 0, buffer5.Length)
                Loop
            Finally
                If TypeOf enumerator Is IDisposable Then
                    TryCast(enumerator, IDisposable).Dispose()
                End If
            End Try
            requestStream.Write(bytes, 0, bytes.Length)
            Dim str4 As String = "Content-Disposition: form-data; name=""{0}""; filename=""{1}""" & ChrW(13) & ChrW(10) & "Content-Type: {2}" & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10)
            Dim s As String = String.Format(str4, paramName, file, contentType)
            Dim buffer As Byte() = Encoding.UTF8.GetBytes(s)
            requestStream.Write(buffer, 0, buffer.Length)
            Dim stream As New FileStream(file, FileMode.Open, FileAccess.Read)
            Dim array As Byte() = New Byte(&H1000 - 1) {}
            Dim target As Integer = 0
            Do While (Not AnonScanner.InlineAssignHelper(Of Integer)(target, stream.Read(array, 0, array.Length)) Or 0)
                requestStream.Write(array, 0, target)
            Loop
            stream.Close()
            Dim buffer4 As Byte() = Encoding.ASCII.GetBytes((ChrW(13) & ChrW(10) & "--" & str & "--" & ChrW(13) & ChrW(10)))
            requestStream.Write(buffer4, 0, buffer4.Length)
            requestStream.Close()
            Dim response As WebResponse = Nothing
            Dim str6 As String = ""
            Try
                response = request.GetResponse
                str6 = New StreamReader(response.GetResponseStream).ReadToEnd
            Catch exception1 As Exception
                ProjectData.SetProjectError(exception1)
                Dim exception As Exception = exception1
                If (Not response Is Nothing) Then
                    response.Close()
                    response = Nothing
                End If
                ProjectData.ClearProjectError()
            Finally
                request = Nothing
            End Try
            Return str6
        End Function

        Private Shared Function InlineAssignHelper(Of T)(ByRef target As T, ByVal value As T) As T
            target = value
            Return value
        End Function

        Public Function Scan(ByVal fileName As String, ByVal returnMethod As String) As String
            Dim url As String = "https://anonscanner.com/api.php"
            Dim nvc As New NameValueCollection
            nvc.Add("uid", AnonScanner.uid)
            nvc.Add("api_key", AnonScanner.apiKey)
            nvc.Add("return", returnMethod)
            Return AnonScanner.HttpUploadFile(url, fileName, "file", "file/exe", nvc)
        End Function


        ' Fields
        Private Shared apiKey As String
        Private Shared uid As String
    End Class
End Namespace


