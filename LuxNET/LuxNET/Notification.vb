Imports LuxNET.My
Imports LuxNET.My.Resources
Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms
Public Class Notification
    Public Sub New()
        Me.Timer1 = New Timer
        Me.timer2 = New Timer
        Me.h = 5
        Me.InitializeComponent()
    End Sub

    Private Sub Notification_Load(sender As Object, e As EventArgs) Handles Me.Load
        Me.StartPosition = FormStartPosition.Manual
        Dim point2 As New Point((MyProject.Computer.Screen.Bounds.Width - 460), MyProject.Computer.Screen.Bounds.Height)
        Me.Location = point2
        Me.Timer1.Interval = 10
        Me.Timer1.Start()
        If My.Settings.sounds Then
            My.Computer.Audio.Play(My.Resources.notify, AudioPlayMode.Background)
        End If
    End Sub

    Private Sub Notification_Paint(sender As Object, e As PaintEventArgs) Handles Me.Paint
        Dim path As New GraphicsPath
        Dim rect As New Rectangle(0, 0, CInt(Math.Round(CDbl((CDbl(Me.Width) / 2)))), Me.Height)
        path.AddArc(rect, -180.0!, 90.0!)
        rect = New Rectangle(0, 0, CInt(Math.Round(CDbl((CDbl(Me.Width) / 2)))), Me.Height)
        path.AddArc(rect, 90.0!, 90.0!)
        rect = New Rectangle(CInt(Math.Round(CDbl((CDbl((Me.Width + 1)) / 4)))), 0, Me.Width, Me.Height)
        path.AddRectangle(rect)
        Me.BackColor = Color.White
        Me.Region = New Region(path)
    End Sub

    Private Sub Timer1_Tick(sender As Object, e As EventArgs) Handles Timer1.Tick
        Dim point2 As New Point((MyProject.Computer.Screen.Bounds.Width - 460), (MyProject.Computer.Screen.Bounds.Height - Me.h))
        Me.Location = point2
        Me.h = (Me.h + 5)
        If (Me.h = 240) Then
            Me.Timer2.Interval = &HBB8
            Me.Timer1.Stop()
            Me.Timer2.Start()
        End If
    End Sub

    Private Sub Timer2_Tick(sender As Object, e As EventArgs) Handles Timer2.Tick
        Me.Close()
    End Sub

    Private h As Integer
End Class