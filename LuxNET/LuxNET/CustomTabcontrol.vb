Imports System
Imports System.Collections
Imports System.Collections.Generic
Imports System.Diagnostics
Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms

Namespace LuxNET
    Public Class CustomTabcontrol
        Inherits TabControl
        ' Methods
        Public Sub New()
            Dim timer As New Timer
            timer.Interval = 5
            timer.Enabled = False
            Me.tmrAnimation = timer
            Me.animationValue = 0
            Me._SelectedItemColor = Color.FromArgb(30, 10, 100, 200)
            Me.SetStyle((ControlStyles.OptimizedDoubleBuffer Or (ControlStyles.AllPaintingInWmPaint Or (ControlStyles.ResizeRedraw Or ControlStyles.UserPaint))), True)
            Me.DoubleBuffered = True
            Me.DrawMode = TabDrawMode.OwnerDrawFixed
            Me.Alignment = TabAlignment.Left
            Me.SizeMode = TabSizeMode.Fixed
            Dim size2 As New Size(40, 150)
            Me.ItemSize = size2
            Me.Dock = DockStyle.Fill
            Me.Font = New Font("Segoe UI", 10.0!)
        End Sub

        Protected Overrides Sub OnPaint(ByVal e As PaintEventArgs)
            Dim enumerator As IEnumerator
            e.Graphics.Clear(SystemColors.Control)
            Dim index As Integer = 0
            Try
                enumerator = Me.TabPages.GetEnumerator
                Do While enumerator.MoveNext
                    Dim rectangle3 As Rectangle
                    Dim current As TabPage = DirectCast(enumerator.Current, TabPage)
                    Dim tabRect As Rectangle = Me.GetTabRect(index)
                    Dim layoutRectangle As New Rectangle((tabRect.X + &H34), (tabRect.Y + 5), (tabRect.Width - &H37), (tabRect.Height - 10))
                    If Not Me.DesignMode Then
                        current.BackColor = SystemColors.Control
                        current.ForeColor = Color.Black
                    End If
                    If (index <> (Me.TabPages.Count - 1)) Then
                        Dim point As New Point(12, (tabRect.Bottom - 1))
                        Dim point2 As New Point((tabRect.Width - &H18), (tabRect.Bottom - 1))
                        e.Graphics.DrawLine(New Pen(Color.FromArgb(210, 210, 210)), point, point2)
                    End If
                    If (index = Me.SelectedIndex) Then
                        rectangle3 = New Rectangle(5, tabRect.Y, (tabRect.Width - 13), tabRect.Height)
                        e.Graphics.FillRectangle(New SolidBrush(Me._SelectedItemColor), rectangle3)
                        rectangle3 = New Rectangle(5, (tabRect.Y - 1), (tabRect.Width - 13), tabRect.Height)
                        e.Graphics.DrawRectangle(New Pen(Color.FromArgb(&H41, &HBA, &HFF)), rectangle3)
                        rectangle3 = New Rectangle(CInt(Math.Round(CDbl((Me.animationValue * (Me.ItemSize.Height * 2))))), tabRect.Y, tabRect.Width, tabRect.Height)
                        Dim brush As New LinearGradientBrush(rectangle3, Color.Gray, Color.Transparent, 0.0!)
                        rectangle3 = New Rectangle(5, (tabRect.Y - 1), (tabRect.Width - 13), tabRect.Height)
                        e.Graphics.DrawRectangle(New Pen(brush), rectangle3)
                    End If
                    If ((Not Me.ImageList Is Nothing) AndAlso (index < Me.ImageList.Images.Count)) Then
                        e.Graphics.InterpolationMode = InterpolationMode.Bicubic
                        rectangle3 = New Rectangle((tabRect.X + 10), (tabRect.Y + 4), &H20, &H20)
                        e.Graphics.DrawImage(Me.ImageList.Images.Item(index), rectangle3)
                    End If
                    Dim format As New StringFormat
                    format.LineAlignment = StringAlignment.Center
                    e.Graphics.DrawString(current.Text, Me.Font, Brushes.Black, layoutRectangle, format)
                    e.Graphics.DrawLine(New Pen(Color.FromArgb(200, 200, 200)), (Me.ItemSize.Height - 2), 5, (Me.ItemSize.Height - 2), (Me.Height - 5))
                    index += 1
                Loop
            Finally
                If TypeOf enumerator Is IDisposable Then
                    TryCast(enumerator, IDisposable).Dispose()
                End If
            End Try
        End Sub

        Protected Overrides Sub OnSelectedIndexChanged(ByVal e As EventArgs)
            MyBase.OnSelectedIndexChanged(e)
            Me.animationValue = 0
            Me.tmrAnimation.Start()
        End Sub

        Private Sub tmrAnimation_Tick(ByVal sender As Object, ByVal e As EventArgs)
            Me.animationValue = (Me.animationValue + 0.02)
            If (Me.animationValue > 1) Then
                Me.tmrAnimation.Stop()
                Me.animationValue = 1
            End If
            Me.Invalidate()
        End Sub


        ' Properties
        Public Property SelectedItemColor As Color
            Get
                Return Me._SelectedItemColor
            End Get
            Set(ByVal value As Color)
                Me._SelectedItemColor = value
                Me.Invalidate()
            End Set
        End Property

        ' Fields
        Private _SelectedItemColor As Color
        <AccessedThroughProperty("tmrAnimation")> _
        Private tmrAnimation As Timer
        Private animationValue As Double
    End Class
End Namespace

