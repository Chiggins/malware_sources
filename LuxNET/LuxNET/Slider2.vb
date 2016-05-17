Imports LuxNET.My
Imports System
Imports System.Collections.Generic
Imports System.Diagnostics
Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms

Namespace LuxNET
    Public Class Slider2
        Inherits Control
        ' Methods
        Public Sub New()
            Me.DotSize = 15
            Me.intselected = 0
            Me.intHoveredDot = -1
        End Sub

        Public Shared Function AdjustRect(ByVal rctBounds As Rectangle, ByVal x As Integer, ByVal y As Integer) As Rectangle
            Return New Rectangle((rctBounds.X + x), (rctBounds.Y + y), (rctBounds.Width - (2 * x)), (rctBounds.Height - (2 * y)))
        End Function

        Private Function GetDotBounds(ByVal Index As Integer) As Rectangle
            Return New Rectangle(CInt(Math.Round(CDbl((Me.GetDotsBound.X + (((Index * Me.DotSize) * 2) + (CDbl(Me.DotSize) / 2)))))), (Me.GetImageBound.Bottom + 2), Me.DotSize, Me.DotSize)
        End Function

        Private Function GetDotsBound() As Rectangle
            Dim num2 As Integer = CInt(Math.Round(CDbl((CDbl(Me.Width) / 2))))
            Dim dotsWidth As Integer = Me.GetDotsWidth
            Return New Rectangle(CInt(Math.Round(CDbl((num2 - (CDbl(dotsWidth) / 2))))), ((Me.Height - 1) - (Me.DotSize * 2)), dotsWidth, (Me.DotSize * 2))
        End Function

        Private Function GetDotsWidth() As Integer
            Return ((2 * Me.DotSize) + (2 * Me.DotSize))
        End Function

        Private Function GetHoveredDot(ByVal MousePos As Point) As Integer
            Dim num4 As Integer
            Dim index As Integer = 0
            Do
                If Me.GetDotBounds(index).Contains(MousePos) Then
                    Return index
                End If
                index += 1
                num4 = 2
            Loop While (index <= num4)
            Return -1
        End Function

        Private Function GetImageBound() As Rectangle
            Return New Rectangle(0, 0, Me.Width, ((Me.Height - 1) - (Me.DotSize * 2)))
        End Function

        Protected Overrides Sub OnMouseDown(ByVal e As MouseEventArgs)
            Dim num2 As Integer
            Dim index As Integer = 0
            Do
                If Me.GetDotBounds(index).Contains(e.Location) Then
                    If (Me.intselected = 0) Then
                        Me.intselected = 1
                    Else
                        Me.intselected = 0
                    End If
                End If
                index += 1
                num2 = 2
            Loop While (index <= num2)
            MyBase.OnMouseDown(e)
            '   My.Forms.FormMain.TC_Other.SelectedIndex = Me.intselected
        End Sub

        Protected Overrides Sub OnMouseLeave(ByVal e As EventArgs)
            Me.intHoveredDot = -1
            MyBase.OnMouseLeave(e)
        End Sub

        Protected Overrides Sub OnMouseMove(ByVal e As MouseEventArgs)
            Dim hoveredDot As Integer = Me.GetHoveredDot(e.Location)
            If (hoveredDot <> Me.intHoveredDot) Then
                Me.intHoveredDot = hoveredDot
                Me.Invalidate()
                If (Me.intHoveredDot = -1) Then
                    Me.Cursor = Cursors.Default
                Else
                    Me.Cursor = Cursors.Hand
                End If
            End If
            MyBase.OnMouseMove(e)
        End Sub

        Protected Overrides Sub OnPaint(ByVal e As PaintEventArgs)
            Dim num2 As Integer
            Dim graphics As Graphics = e.Graphics
            graphics.SmoothingMode = SmoothingMode.AntiAlias
            graphics.Clear(Me.BackColor)
            Dim index As Integer = 0
            Do
                If (index = Me.intselected) Then
                    Dim brush As New LinearGradientBrush(Me.GetDotBounds(index), Color.FromArgb(&H6C, &HC0, &HEB), Color.FromArgb(15, &H92, 210), 90.0!)
                    graphics.FillEllipse(brush, Me.GetDotBounds(index))
                    graphics.DrawEllipse(New Pen(Color.FromArgb(&H47, &H94, &HBB)), Me.GetDotBounds(index))
                Else
                    Dim brush2 As New LinearGradientBrush(Me.GetDotBounds(index), Color.FromArgb(&HE3, &HE4, 230), Color.FromArgb(&HDD, &HDE, &HE0), 90.0!)
                    graphics.FillEllipse(brush2, Me.GetDotBounds(index))
                    graphics.DrawEllipse(New Pen(Color.FromArgb(&HDB, &HDB, 220)), Me.GetDotBounds(index))
                    graphics.DrawArc(New Pen(Color.FromArgb(&HCB, &HCC, &HCE)), Me.GetDotBounds(index), 150.0!, 30.0!)
                    graphics.DrawArc(New Pen(Color.FromArgb(&HC3, &HC3, &HC6)), Me.GetDotBounds(index), 180.0!, 20.0!)
                    graphics.DrawArc(New Pen(Color.FromArgb(&HB7, &HB8, &HBA)), Me.GetDotBounds(index), 200.0!, 40.0!)
                    graphics.DrawArc(New Pen(Color.FromArgb(&HB0, &HB1, &HB2)), Me.GetDotBounds(index), 240.0!, 60.0!)
                    graphics.DrawArc(New Pen(Color.FromArgb(&HB7, &HB8, &HBA)), Me.GetDotBounds(index), 300.0!, 40.0!)
                    graphics.DrawArc(New Pen(Color.FromArgb(&HC3, &HC3, &HC6)), Me.GetDotBounds(index), 340.0!, 20.0!)
                    graphics.DrawArc(New Pen(Color.FromArgb(&HCB, &HCC, &HCE)), Me.GetDotBounds(index), 0.0!, 30.0!)
                    graphics.DrawArc(New Pen(Color.FromArgb(&HD3, &HD4, &HD6)), Me.GetDotBounds(index), 30.0!, 150.0!)
                    If (Me.DotSize > 3) Then
                        Dim rect As Rectangle = Slider2.AdjustRect(Me.GetDotBounds(index), 0, 1)
                        graphics.DrawArc(New Pen(Color.FromArgb(&HC3, &HC3, &HC6)), rect, 200.0!, 40.0!)
                        graphics.DrawArc(New Pen(Color.FromArgb(&HB7, &HB8, &HBA)), rect, 240.0!, 60.0!)
                        graphics.DrawArc(New Pen(Color.FromArgb(&HC3, &HC3, &HC6)), rect, 300.0!, 40.0!)
                    End If
                    If (index = Me.intHoveredDot) Then
                        Dim brush3 As New LinearGradientBrush(Me.GetDotBounds(index), Color.FromArgb(&H4B, &H6C, &HC0, &HEB), Color.FromArgb(&H4B, 15, &H92, 210), 90.0!)
                        graphics.FillEllipse(brush3, Me.GetDotBounds(index))
                        graphics.DrawEllipse(New Pen(Color.FromArgb(&H4B, &H47, &H94, &HBB)), Me.GetDotBounds(index))
                    End If
                End If
                index += 1
                num2 = 1
            Loop While (index <= num2)
            GC.Collect()
        End Sub


        ' Fields
        Private DotSize As Integer
        Private intHoveredDot As Integer
        Private intselected As Integer
    End Class
End Namespace


