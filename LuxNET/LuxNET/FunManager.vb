Imports LuxNET.My
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

Public Class FunManager
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.InitializeComponent()
    End Sub

    Private Sub btn_capslock_Click(sender As Object, e As EventArgs) Handles btn_capslock.Click
        Me.SendPacket(New Object() {CByte(&H5C)})
    End Sub

    Private Sub btn_changewp_Click(sender As Object, e As EventArgs) Handles btn_changewp.Click
        My.Forms.ChangeWallpaper.Text = ("Change Wallpaper - " & Me.client.EndPoint.Address.ToString)
        My.Forms.ChangeWallpaper.client = Me.client
        My.Forms.ChangeWallpaper.Show()
    End Sub

    Private Sub btn_closecd_Click(sender As Object, e As EventArgs) Handles btn_closecd.Click
        Me.SendPacket(New Object() {CByte(&H59)})
    End Sub

    Private Sub btn_discomouse_Click(sender As Object, e As EventArgs) Handles btn_discomouse.Click
        Me.SendPacket(New Object() {CByte(&H4E)})
    End Sub

    Private Sub btn_hibernate_Click(sender As Object, e As EventArgs) Handles btn_hibernate.Click
        Me.SendPacket(New Object() {CByte(&H53)})
    End Sub

    Private Sub btn_hidedi_Click(sender As Object, e As EventArgs) Handles btn_hidedi.Click
        Me.SendPacket(New Object() {CByte(&H56)})
    End Sub

    Private Sub btn_hidetb_Click(sender As Object, e As EventArgs) Handles btn_hidetb.Click
        Me.SendPacket(New Object() {CByte(&H54)})
    End Sub

    Private Sub btn_logoff_Click(sender As Object, e As EventArgs) Handles btn_logoff.Click
        Me.SendPacket(New Object() {CByte(&H51)})
    End Sub

    Private Sub btn_mouseswap_Click(sender As Object, e As EventArgs) Handles btn_mouseswap.Click
        Me.SendPacket(New Object() {CByte(&H4C)})
    End Sub

    Private Sub btn_opencd_Click(sender As Object, e As EventArgs) Handles btn_opencd.Click
        Me.SendPacket(New Object() {CByte(&H58)})
    End Sub

    Private Sub btn_restart_Click(sender As Object, e As EventArgs) Handles btn_restart.Click
        Me.SendPacket(New Object() {CByte(&H52)})
    End Sub

    Private Sub btn_showdi_Click(sender As Object, e As EventArgs) Handles btn_showdi.Click
        Me.SendPacket(New Object() {CByte(&H57)})
    End Sub

    Private Sub btn_showtb_Click(sender As Object, e As EventArgs) Handles btn_showtb.Click
        Me.SendPacket(New Object() {CByte(&H55)})
    End Sub

    Private Sub btn_shutdown_Click(sender As Object, e As EventArgs) Handles btn_shutdown.Click
        Me.SendPacket(New Object() {CByte(80)})
    End Sub

    Private Sub btn_speak_Click(sender As Object, e As EventArgs) Handles btn_speak.Click
        Dim str As String = Interaction.InputBox("Please enter a text!", "Speak Text", "", -1, -1)
        If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
            Me.SendPacket(New Object() {CByte(&H5B), str})
        End If
    End Sub

    Private Sub btn_stopdiscomouse_Click(sender As Object, e As EventArgs) Handles btn_stopdiscomouse.Click
        Me.SendPacket(New Object() {CByte(&H4F)})
    End Sub

    Private Sub btn_undomouse_Click(sender As Object, e As EventArgs) Handles btn_undomouse.Click
        Me.SendPacket(New Object() {CByte(&H4D)})
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Me.SendPacket(New Object() {CByte(&H61)})
    End Sub

    Private Sub Button11_Click(sender As Object, e As EventArgs) Handles Button11.Click
        If Me.cb_silent.Checked Then
            Me.SendPacket(New Object() {CByte(&H4B), Me.tb_weburl.Text, Convert.ToInt32(Me.NUD_websitetimes.Value)})
        Else
            Me.SendPacket(New Object() {CByte(&H4A), Me.tb_weburl.Text, Convert.ToInt32(Me.NUD_websitetimes.Value)})
        End If
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Me.SendPacket(New Object() {CByte(100)})
    End Sub

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        Me.SendPacket(New Object() {CByte(&H62)})
    End Sub

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        My.Forms.RunSound.Text = ("Run Sound - " & Me.client.EndPoint.Address.ToString)
        My.Forms.RunSound.client = Me.client
        My.Forms.RunSound.Show()
    End Sub

    Private Sub Button6_Click(sender As Object, e As EventArgs) Handles Button6.Click
        My.Forms.ScarePrank.client = Me.client
        My.Forms.ScarePrank.Text = ("Scare - " & Me.client.EndPoint.Address.ToString)
        My.Forms.ScarePrank.Show()
    End Sub

    Private Sub Button7_Click(sender As Object, e As EventArgs) Handles Button7.Click
        Me.SendPacket(New Object() {CByte(&H60)})
    End Sub

    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.client.Send(data)
        GC.Collect()
    End Sub

    Public client As ServerClient
    Private packer As LuxNET.Pack

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        CapsLockPrank = &H5C
        ChangeCursor = &H60
        ChangeWallpaper = 90
        CloseCD = &H59
        DisableTaskMGR = &H65
        FakeBSOD = &H66
        FakeScarfs = &H67
        Hibernate = &H53
        HideDesktopItems = &H56
        HideTaskbar = &H54
        Logout = &H51
        MaxVolume = &H61
        MinVolume = &H62
        MuteVolume = 100
        Nuke = &H68
        OpenCD = &H58
        RestartPC = &H52
        ScreamPrank = &H5D
        ShowDesktopItems = &H57
        ShowTaskBar = &H55
        Shutdown = 80
        SpeakText = &H5B
        StartDiscoMouse = &H4E
        StopDiscoMouse = &H4F
        SwapMouse = &H4C
        UndoMouse = &H4D
        ViewWebsite = &H4A
        ViewWebsiteSilent = &H4B
    End Enum
End Class