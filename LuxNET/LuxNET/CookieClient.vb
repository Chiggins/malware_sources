Imports System
Imports System.Collections.Generic
Imports System.Diagnostics
Imports System.Net
Imports System.Runtime.CompilerServices

Namespace LuxNET
    Friend NotInheritable Class CookieClient
        Inherits WebClient
        ' Methods
        Public Sub New()
            Me.Cookies = New CookieContainer
        End Sub

        Public Sub ClearCookies()
            Me.Cookies = New CookieContainer
        End Sub

        Protected Overrides Function GetWebRequest(ByVal address As Uri) As WebRequest
            Me.Request = DirectCast(MyBase.GetWebRequest(address), HttpWebRequest)
            Me.Request.Timeout = &H1F40
            Me.Request.ReadWriteTimeout = &H7530
            Me.Request.KeepAlive = False
            Me.Request.CookieContainer = Me.Cookies
            Me.Request.Proxy = Nothing
            Return Me.Request
        End Function


        ' Fields
        Public Cookies As CookieContainer
        Private Request As HttpWebRequest
    End Class
End Namespace


