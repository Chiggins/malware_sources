Public Class InfoContainer
    Public c As Connection
    Public d As Data
    Sub New(ByVal c As Connection, ByVal d As Data)
        Me.c = c : Me.d = d
    End Sub
End Class
