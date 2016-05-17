Imports System
Imports System.Runtime.InteropServices

Namespace LuxNET
    <StructLayout(LayoutKind.Sequential)> _
    Friend Structure NewsPost
        Private ReadOnly _ID As Integer
        Private ReadOnly _Name As String
        Private ReadOnly _Time As DateTime
        Public ReadOnly Property ID As Integer
            Get
                Return Me._ID
            End Get
        End Property

        Public ReadOnly Property Name As String
            Get
                Return Me._Name
            End Get
        End Property

        Public ReadOnly Property Time As DateTime
            Get
                Return Me._Time
            End Get
        End Property

        Public Sub New(ByVal id As Object, ByVal name As Object, ByVal time As Object)
            '   Me = New NewsPost
            Me._ID = CInt(id)
            Me._Name = CStr(name)
            Me._Time = CDate(time)
        End Sub
    End Structure
End Namespace

