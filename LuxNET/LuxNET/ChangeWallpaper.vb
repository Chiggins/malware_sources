Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.IO
Imports System.Runtime.CompilerServices
Imports System.Text
Imports System.Windows.Forms
Imports System.Environment
Imports LuxNET.LuxNET

Public Class ChangeWallpaper
    Inherits Form
    ' Methods
    Public Sub New()
        Me.packer = New Pack
        Me.l = New Label
        Me.t = New TextBox
        Me.b = New Button
        Me.InitializeComponent()
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        If Not Me.t.Text.Contains(".jpg") Then
            MessageBox.Show("Please enter / select a valid JPEG Picture!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Hand)
        End If
        If Me.url Then
            Me.SendPacket(New Object() {CByte(90), Me.url, Encoding.UTF8.GetBytes(Me.t.Text)})
        Else
            Me.SendPacket(New Object() {CByte(90), Me.url, File.ReadAllBytes(Me.t.Text)})
        End If
        Me.Close()
    End Sub
    Private Sub ButtonClick(ByVal sender As Object, ByVal e As EventArgs) Handles Button1.Click
        Using dialog As OpenFileDialog = New OpenFileDialog
            Dim dialog2 As OpenFileDialog = dialog
            dialog2.Filter = "JPEG | *.jpg"
            dialog2.InitialDirectory = Environment.GetFolderPath(SpecialFolder.MyPictures)
            dialog2.Multiselect = False
            dialog2.Title = "Please select a new Wallpaper!"
            If (dialog2.ShowDialog = DialogResult.OK) Then
                Me.t.Text = dialog.FileName
                dialog2 = Nothing
            End If
        End Using
    End Sub

    Private Sub RadioButton1_CheckedChanged(sender As Object, e As EventArgs) Handles RadioButton1.CheckedChanged
        Try
            If Me.RadioButton1.Checked Then
                Me.url = True
                Me.t.Clear()
                Me.Controls.Remove(Me.l)
                Me.Controls.Remove(Me.t)
                Me.Controls.Remove(Me.b)
                Me.l.Text = "Please enter a direct link to a .jpg!"
                Dim point2 As New Point(12, &H24)
                Me.l.Location = point2
                Me.l.AutoSize = True
                Dim size2 As New Size(420, 20)
                Me.t.Size = size2
                point2 = New Point(12, &H38)
                Me.t.Location = point2
                Me.Controls.Add(Me.t)
                Me.Controls.Add(Me.l)
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub RadioButton2_CheckedChanged(sender As Object, e As EventArgs) Handles RadioButton2.CheckedChanged
        Try
            If Me.RadioButton2.Checked Then
                Me.url = False
                Me.t.Clear()
                Me.Controls.Remove(Me.l)
                Me.Controls.Remove(Me.t)
                Me.Controls.Remove(Me.b)
                Me.l.Text = "Please select a .jpg picture!"
                Dim point2 As New Point(12, &H24)
                Me.l.Location = point2
                Me.l.AutoSize = True
                Dim size2 As New Size(&H179, 20)
                Me.t.Size = size2
                point2 = New Point(12, &H38)
                Me.t.Location = point2
                size2 = New Size(&H24, 20)
                Me.b.Size = size2
                point2 = New Point(&H18C, &H38)
                Me.b.Location = point2
                Me.b.Text = "[. . .]"
                AddHandler Me.b.Click, New EventHandler(AddressOf Me.ButtonClick)
                Me.Controls.Add(Me.t)
                Me.Controls.Add(Me.l)
                Me.Controls.Add(Me.b)
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.client.Send(data)
        GC.Collect()
    End Sub

    Private b As Button
    Public client As ServerClient
    Private l As Label
    Private packer As Pack
    Private t As TextBox
    Private url As Boolean

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        ChangeWallpaper = 90
    End Enum
End Class