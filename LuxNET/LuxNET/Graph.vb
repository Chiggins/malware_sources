Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.Diagnostics
Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms

Namespace LuxNET
    Public Class Graph
        Inherits Control
        ' Events
        Public Custom Event ValueAdded As ValueAddedEventHandler
            AddHandler(value As ValueAddedEventHandler)
            End AddHandler
            RemoveHandler(value As ValueAddedEventHandler)
            End RemoveHandler
            RaiseEvent()
            End RaiseEvent
        End Event

        ' Methods
        Public Sub New()
            Me._SidePadding = True
            Me._DrawHoverData = True
            Me._DrawHoverLine = True
            Me._DrawDataColumn = True
            Me._DrawHorizontalLines = True
            Me._DataSmoothingLevel = 2
            Me._OverrideMin = False
            Me._OverrideMinValue = 0.0!
            Me._OverrideMax = False
            Me._OverrideMaxValue = 100.0!
            Me._MaximumValue = Single.MinValue
            Me._MinimumValue = Single.MaxValue
            Me.Index = -1
            Dim image As New Bitmap(1, 1)
            Me.SG = Graphics.FromImage(image)
            Me.GP = New GraphicsPath
            Me._Values = New List(Of Single)
            Me._SmoothValues = New List(Of Single)
            Me.FillColor = Color.White
            Me.BorderColor = Color.Gray
            Me.GraphFillColor = Color.FromArgb(50, Color.LightGreen)
            Me.GraphBorderColor = Color.ForestGreen
            Me.HorizontalLineColor = Color.FromArgb(&HEE, &HEE, &HEE)
            Me.VerticalLineColor = Color.FromArgb(&HF8, &HF8, &HF8)
            Me.DataColumnForeColor = Color.Gray
            Me.Font = New Font("Verdana", 8.25!)
            Me.HoverFillColor = Color.White
            Me.HoverBorderColor = Color.ForestGreen
            Me.HoverLineColor = Color.FromArgb(&H23, Color.ForestGreen)
            Me.HoverLabelForeColor = Color.Gray
            Me.HoverLabelFillColor = Color.White
            Me.HoverLabelBorderColor = Color.DarkGray
            Me.HoverLabelShadowColor = Color.FromArgb(&H23, Color.Black)
            Me.LineGraphColor = Color.FromArgb(130, 0, 200, &HFF)
            Me.SetStyle((ControlStyles.OptimizedDoubleBuffer Or (ControlStyles.AllPaintingInWmPaint Or (ControlStyles.ResizeRedraw Or (ControlStyles.Opaque Or ControlStyles.UserPaint)))), True)
        End Sub

        Public Sub AddValue(ByVal value As Single)
            Me.Index = -1
            Me._Values.Add(value)
            Me.CleanValues()
            Me.InvalidateSmoothValues()
            Me.FindMinMax()
            Me.Invalidate()
            Dim valueAddedEvent As ValueAddedEventHandler
            If (Not valueAddedEvent Is Nothing) Then
                valueAddedEvent.Invoke()
            End If
        End Sub

        Public Sub AddValues(ByVal values As Single())
            Me.Index = -1
            Me._Values.AddRange(values)
            Me.CleanValues()
            Me.InvalidateSmoothValues()
            Me.FindMinMax()
            Me.Invalidate()
        End Sub

        Private Sub CleanValues()
            If (Me._Values.Count > Me.Width) Then
                Me._Values.RemoveRange(0, (Me._Values.Count - Me.Width))
            End If
        End Sub

        Public Sub Clear()
            Me._Values.Clear()
            Me._SmoothValues.Clear()
            Me._MaximumValue = Single.MinValue
            Me._MinimumValue = Single.MaxValue
            Me.InvalidateMinMax()
        End Sub

        Private Sub FindMinMax()
            Me._MaximumValue = Single.MinValue
            Me._MinimumValue = Single.MaxValue
            Dim num2 As Integer = (Me._Values.Count - 1)
            Dim i As Integer = 0
            Do While (i <= num2)
                If Me._DataSmoothing Then
                    Me.CurrentValue = Me._SmoothValues.Item(i)
                Else
                    Me.CurrentValue = Me._Values.Item(i)
                End If
                If (Me.CurrentValue > Me._MaximumValue) Then
                    Me._MaximumValue = Me.CurrentValue
                End If
                If (Me.CurrentValue < Me._MinimumValue) Then
                    Me._MinimumValue = Me.CurrentValue
                End If
                i += 1
            Loop
            Me.InvalidateMinMax()
        End Sub

        Private Sub InvalidateMinMax()
            If Me._OverrideMin Then
                Me._MinimumValue = Me._OverrideMinValue
            End If
            If Me._OverrideMax Then
                Me._MaximumValue = Me._OverrideMaxValue
            End If
        End Sub

        Private Sub InvalidateSmoothValues()
            If Me._DataSmoothing Then
                Me._SmoothValues.Clear()
                Dim num6 As Integer = (Me._Values.Count - 1)
                Dim i As Integer = 0
                Do While (i <= num6)
                    Dim item As Single = 0.0!
                    Dim num3 As Integer = Math.Max((i - Me._DataSmoothingLevel), 0)
                    Dim num As Integer = Math.Min(CInt((i + Me._DataSmoothingLevel)), CInt((Me._Values.Count - 1)))
                    Dim num7 As Integer = num
                    Dim j As Integer = num3
                    Do While (j <= num7)
                        item = (item + Me._Values.Item(j))
                        j += 1
                    Loop
                    item = (item / CSng(((num - num3) + 1)))
                    Me._SmoothValues.Add(item)
                    i += 1
                Loop
            End If
        End Sub

        Protected Overrides Sub OnMouseLeave(ByVal e As EventArgs)
            If Me._DrawHoverData Then
                Me.Index = -1
                Me.Invalidate()
            End If
        End Sub

        Protected Overrides Sub OnMouseMove(ByVal e As MouseEventArgs)
            If Me._DrawHoverData Then
                Me.R1 = New Rectangle(Me.SW, 0, (Me.Width - Me.SW), (Me.Height - Me.SH))
                Me.R2 = New Rectangle((Me.R1.X + 8), (Me.R1.Y + 8), (Me.R1.Width - &H10), (Me.R1.Height - &H10))
                Me.FB1 = CSng((CDbl((Me.R2.Width - 1)) / CDbl((Me._Values.Count - 1))))
                If Me.R1.Contains(e.Location) Then
                    Me.Index = CInt(Math.Round(CDbl((CSng((e.X - Me.R2.X)) / Me.FB1))))
                    If (Me.Index >= Me._Values.Count) Then
                        Me.Index = -1
                    End If
                Else
                    Me.Index = -1
                End If
                If (DateTime.Compare(DateTime.Now, Me.LastMove.AddMilliseconds(33)) > 0) Then
                    Me.LastMove = DateTime.Now
                    Me.Invalidate()
                End If
            End If
        End Sub

        Protected Overrides Sub OnPaint(ByVal e As PaintEventArgs)
            Dim num5 As Integer
            Me.G = e.Graphics
            Me.G.Clear(Me.BackColor)
            Me.R1 = New Rectangle(Me.SW, 0, (Me.Width - Me.SW), Me.Height)
            If Not Me._DrawDataColumn Then
                Me.R1.X = 0
                Me.R1.Width = Me.Width
            End If
            Me.R2 = New Rectangle((Me.R1.X + 10), (Me.R1.Y + 10), (Me.R1.Width - 20), (Me.R1.Height - 20))
            If Not Me._SidePadding Then
                Me.R2.X = Me.R1.X
                Me.R2.Width = Me.R1.Width
            End If
            Me.G.FillRectangle(Me._FillColor, Me.R1)
            Dim num As Integer = 0
            Do
                Me.FB1 = (Me.R2.Y + CSng(((Me.R2.Height - 1) * (num * 0.1))))
                If Me._DrawHorizontalLines Then
                    Me.G.DrawLine(Me._HorizontalLineColor, CSng(Me.R1.X), Me.FB1, CSng((Me.R1.Right - 1)), Me.FB1)
                End If
                If ((Me._DrawDataColumn AndAlso (Me._Values.Count > 1)) AndAlso ((num Mod 2) = 0)) Then
                    Me.G.DrawLine(Me._BorderColor, CSng((Me.R1.X - 4)), Me.FB1, CSng(Me.R1.X), Me.FB1)
                    Me.CurrentValue = CInt(Math.Round(CDbl((((Me._MaximumValue - Me._MinimumValue) * (1 - (num * 0.1))) + Me._MinimumValue))))
                    Me.SB = Me.SmallValue(Me.CurrentValue)
                    Me.SS = Me.G.MeasureString(Me.SB, Me.Font).ToSize
                    Me.G.DrawString(Me.SB, Me.Font, Me._DataColumnForeColor, CSng(((Me.R1.X - 5) - Me.SS.Width)), (Me.FB1 - Me.SHH))
                End If
                num += 1
                num5 = 10
            Loop While (num <= num5)
            If (Me._Values.Count > 1) Then
                Me.PS = New PointF(((Me._Values.Count + 1) + 1) - 1) {}
                Me.FB1 = CSng((CDbl((Me.R2.Width - 1)) / CDbl((Me._Values.Count - 1))))
                Dim num3 As Integer = (Me._Values.Count - 1)
                Dim i As Integer = 0
                Do While (i <= num3)
                    Me.FB2 = (Me.R2.X + (i * Me.FB1))
                    If Me._DataSmoothing Then
                        Me.CurrentValue = ((Me._SmoothValues.Item(i) - Me._MinimumValue) / Math.Max(CSng((Me._MaximumValue - Me._MinimumValue)), CSng(1.0!)))
                    Else
                        Me.CurrentValue = ((Me._Values.Item(i) - Me._MinimumValue) / Math.Max(CSng((Me._MaximumValue - Me._MinimumValue)), CSng(1.0!)))
                    End If
                    If (Me.CurrentValue > 1.0!) Then
                        Me.CurrentValue = 1.0!
                    ElseIf (Me.CurrentValue < 0.0!) Then
                        Me.CurrentValue = 0.0!
                    End If
                    Me.PS(i) = New PointF(Me.FB2, CSng(CInt(Math.Round(CDbl(((Me.R2.Bottom - ((Me.R2.Height - 1) * Me.CurrentValue)) - 1.0!))))))
                    If Me._DrawVerticalLines Then
                        Me.G.DrawLine(Me._VerticalLineColor, Me.FB2, CSng(Me.R1.Y), Me.FB2, CSng(Me.R1.Bottom))
                    End If
                    i += 1
                Loop
                Me.PS((Me.PS.Length - 2)) = New PointF(CSng((Me.R2.Right - 1)), CSng((Me.R1.Bottom - 1)))
                Me.PS((Me.PS.Length - 1)) = New PointF(CSng(Me.R2.X), CSng((Me.R1.Bottom - 1)))
                Me.G.SmoothingMode = SmoothingMode.HighQuality
                If Me._DrawLineGraph Then
                    Array.Resize(Of PointF)(Me.PS, (Me.PS.Length - 2))
                    Me.G.DrawLines(Me._LineGraphColor, Me.PS)
                Else
                    Me.GP.AddPolygon(Me.PS)
                    Me.GP.CloseFigure()
                    Me.G.FillPath(Me._GraphFillColor, Me.GP)
                    Me.G.DrawPath(Me._GraphBorderColor, Me.GP)
                    Me.GP.Reset()
                End If
                If (Me._DrawHoverData AndAlso (Me.Index >= 0)) Then
                    Me.G.SetClip(Me.R1)
                    Me.P = New Point(CInt(Math.Round(CDbl(Me.PS(Me.Index).X))), CInt(Math.Round(CDbl(Me.PS(Me.Index).Y))))
                    Me.R3 = New Rectangle((Me.P.X - 4), (Me.P.Y - 4), 8, 8)
                    If Me._DrawHoverLine Then
                        Me.G.DrawLine(Me._HoverLineColor, Me.P.X, Me.R1.Y, Me.P.X, (Me.R1.Bottom - 1))
                    End If
                    Me.G.FillEllipse(Me._HoverFillColor, Me.R3)
                    Me.G.DrawEllipse(Me._HoverBorderColor, Me.R3)
                    If Me._DataSmoothing Then
                        Dim num4 As Single = Me._SmoothValues.Item(Me.Index)
                        Me.SB = num4.ToString("N0")
                    Else
                        Me.SB = Me._Values.Item(Me.Index).ToString("N0")
                    End If
                    Me.SS = Me.G.MeasureString(Me.SB, Me.Font).ToSize
                    Me.P = Me.PointToClient(Control.MousePosition)
                    Me.R3 = New Rectangle((Me.P.X + &H18), Me.P.Y, (Me.SS.Width + 20), (Me.SS.Height + 10))
                    If ((Me.R3.X + Me.R3.Width) > (Me.R1.Right - 1)) Then
                        Me.R3.X = ((Me.P.X - Me.R3.Width) - &H10)
                    End If
                    If ((Me.R3.Y + Me.R3.Height) > (Me.R1.Bottom - 1)) Then
                        Me.R3.Y = ((Me.R1.Bottom - Me.R3.Height) - 1)
                    End If
                    Me.G.DrawRectangle(Me._HoverLabelShadowColor, Me.R3)
                    Me.G.FillRectangle(Me._HoverLabelFillColor, Me.R3)
                    Me.G.DrawRectangle(Me._HoverLabelBorderColor, Me.R3)
                    Dim point As New Point((Me.R3.X + 10), (Me.R3.Y + 5))
                    '  Me.G.DrawString(Me.SB, Me.Font, Me._HoverLabelForeColor, DirectCast(point, PointF))
                End If
                Me.G.ResetClip()
                Me.G.SmoothingMode = SmoothingMode.None
            End If
            Me.G.DrawRectangle(Me._BorderColor, Me.R1.X, Me.R1.Y, (Me.R1.Width - 1), (Me.R1.Height - 1))
        End Sub

        Private Function SmallValue(ByVal value As Single) As String
            Dim num As Integer = CInt(Math.Round(CDbl(value)))
            Dim num2 As Integer = num
            If (num2 >= &H3B9ACA00) Then
                Return (Conversions.ToString(CInt((num / &H3B9ACA00))) & "B")
            End If
            If (num2 >= &HF4240) Then
                Return (Conversions.ToString(CInt((num / &HF4240))) & "M")
            End If
            If (num2 >= &H3E8) Then
                Return (Conversions.ToString(CInt((num / &H3E8))) & "K")
            End If
            Return Conversions.ToString(num)
        End Function


        ' Properties
        Public Property BorderColor As Color
            Get
                Return Me._BorderColor.Color
            End Get
            Set(ByVal value As Color)
                Me._BorderColor = New Pen(value)
                Me.Invalidate()
            End Set
        End Property

        Public Property DataColumnForeColor As Color
            Get
                Return Me._DataColumnForeColor.Color
            End Get
            Set(ByVal value As Color)
                Me._DataColumnForeColor = New SolidBrush(value)
                Me.Invalidate()
            End Set
        End Property

        Public Property DataSmoothing As Boolean
            Get
                Return Me._DataSmoothing
            End Get
            Set(ByVal value As Boolean)
                Me._DataSmoothing = value
                Me.InvalidateSmoothValues()
                Me.FindMinMax()
                Me.Invalidate()
            End Set
        End Property

        Public Property DataSmoothingLevel As Byte
            Get
                Return Me._DataSmoothingLevel
            End Get
            Set(ByVal value As Byte)
                If (value < 1) Then
                    value = 1
                End If
                Me._DataSmoothingLevel = value
                Me.InvalidateSmoothValues()
                Me.FindMinMax()
                Me.Invalidate()
            End Set
        End Property

        Public Property DrawDataColumn As Boolean
            Get
                Return Me._DrawDataColumn
            End Get
            Set(ByVal value As Boolean)
                Me._DrawDataColumn = value
                Me.Invalidate()
            End Set
        End Property

        Public Property DrawHorizontalLines As Boolean
            Get
                Return Me._DrawHorizontalLines
            End Get
            Set(ByVal value As Boolean)
                Me._DrawHorizontalLines = value
                Me.Invalidate()
            End Set
        End Property

        Public Property DrawHoverData As Boolean
            Get
                Return Me._DrawHoverData
            End Get
            Set(ByVal value As Boolean)
                Me.Index = -1
                Me._DrawHoverData = value
                Me.Invalidate()
            End Set
        End Property

        Public Property DrawHoverLine As Boolean
            Get
                Return Me._DrawHoverLine
            End Get
            Set(ByVal value As Boolean)
                Me._DrawHoverLine = value
                Me.Invalidate()
            End Set
        End Property

        Public Property DrawLineGraph As Boolean
            Get
                Return Me._DrawLineGraph
            End Get
            Set(ByVal value As Boolean)
                Me._DrawLineGraph = value
                Me.Invalidate()
            End Set
        End Property

        Public Property DrawVerticalLines As Boolean
            Get
                Return Me._DrawVerticalLines
            End Get
            Set(ByVal value As Boolean)
                Me._DrawVerticalLines = value
                Me.Invalidate()
            End Set
        End Property

        Public Property FillColor As Color
            Get
                Return Me._FillColor.Color
            End Get
            Set(ByVal value As Color)
                Me._FillColor = New SolidBrush(value)
                Me.Invalidate()
            End Set
        End Property

        Public Overrides Property Font As Font
            Get
                Return MyBase.Font
            End Get
            Set(ByVal value As Font)
                MyBase.Font = value
                Me.SS = Me.SG.MeasureString("999K", Me.Font).ToSize
                Me.SW = (Me.SS.Width + 5)
                Me.SH = (Me.SS.Height + 5)
                Me.SHH = CInt(Math.Round(CDbl((Math.Ceiling(CDbl(((CDbl(Me.SS.Height) / 2) / 2))) * 2))))
                Me.Invalidate()
            End Set
        End Property

        Public Property GraphBorderColor As Color
            Get
                Return Me._GraphBorderColor.Color
            End Get
            Set(ByVal value As Color)
                Me._GraphBorderColor = New Pen(value)
                Me.Invalidate()
            End Set
        End Property

        Public Property GraphFillColor As Color
            Get
                Return Me._GraphFillColor.Color
            End Get
            Set(ByVal value As Color)
                Me._GraphFillColor = New SolidBrush(value)
                Me.Invalidate()
            End Set
        End Property

        Public Property HorizontalLineColor As Color
            Get
                Return Me._HorizontalLineColor.Color
            End Get
            Set(ByVal value As Color)
                Me._HorizontalLineColor = New Pen(value)
                Me.Invalidate()
            End Set
        End Property

        Public Property HoverBorderColor As Color
            Get
                Return Me._HoverBorderColor.Color
            End Get
            Set(ByVal value As Color)
                Me._HoverBorderColor = New Pen(value)
                Me.Invalidate()
            End Set
        End Property

        Public Property HoverFillColor As Color
            Get
                Return Me._HoverFillColor.Color
            End Get
            Set(ByVal value As Color)
                Me._HoverFillColor = New SolidBrush(value)
                Me.Invalidate()
            End Set
        End Property

        Public Property HoverLabelBorderColor As Color
            Get
                Return Me._HoverLabelBorderColor.Color
            End Get
            Set(ByVal value As Color)
                Me._HoverLabelBorderColor = New Pen(value)
                Me.Invalidate()
            End Set
        End Property

        Public Property HoverLabelFillColor As Color
            Get
                Return Me._HoverLabelFillColor.Color
            End Get
            Set(ByVal value As Color)
                Me._HoverLabelFillColor = New SolidBrush(value)
                Me.Invalidate()
            End Set
        End Property

        Public Property HoverLabelForeColor As Color
            Get
                Return Me._HoverLabelForeColor.Color
            End Get
            Set(ByVal value As Color)
                Me._HoverLabelForeColor = New SolidBrush(value)
                Me.Invalidate()
            End Set
        End Property

        Public Property HoverLabelShadowColor As Color
            Get
                Return Me._HoverLabelShadowColor.Color
            End Get
            Set(ByVal value As Color)
                Me._HoverLabelShadowColor = New Pen(value, 2.0!)
                Me.Invalidate()
            End Set
        End Property

        Public Property HoverLineColor As Color
            Get
                Return Me._HoverLineColor.Color
            End Get
            Set(ByVal value As Color)
                Me._HoverLineColor = New Pen(value)
                Me.Invalidate()
            End Set
        End Property

        Public Property LineGraphColor As Color
            Get
                Return Me._LineGraphColor.Color
            End Get
            Set(ByVal value As Color)
                Me._LineGraphColor = New Pen(value, 6.0!)
                Me._LineGraphColor.MiterLimit = 0.0!
                Me.Invalidate()
            End Set
        End Property

        Public ReadOnly Property MaximumValue As Single
            Get
                Return Me._MaximumValue
            End Get
        End Property

        Public ReadOnly Property MinimumValue As Single
            Get
                Return Me._MinimumValue
            End Get
        End Property

        Public Property OverrideMax As Boolean
            Get
                Return Me._OverrideMax
            End Get
            Set(ByVal value As Boolean)
                Me._OverrideMax = value
                If value Then
                    Me.InvalidateMinMax()
                Else
                    Me.FindMinMax()
                End If
                Me.Invalidate()
            End Set
        End Property

        Public Property OverrideMaxValue As Single
            Get
                Return Me._OverrideMaxValue
            End Get
            Set(ByVal value As Single)
                Me._OverrideMaxValue = value
                Me.InvalidateMinMax()
                Me.Invalidate()
            End Set
        End Property

        Public Property OverrideMin As Boolean
            Get
                Return Me._OverrideMin
            End Get
            Set(ByVal value As Boolean)
                Me._OverrideMin = value
                If value Then
                    Me.InvalidateMinMax()
                Else
                    Me.FindMinMax()
                End If
                Me.Invalidate()
            End Set
        End Property

        Public Property OverrideMinValue As Single
            Get
                Return Me._OverrideMinValue
            End Get
            Set(ByVal value As Single)
                Me._OverrideMinValue = value
                Me.InvalidateMinMax()
                Me.Invalidate()
            End Set
        End Property

        Public Property SidePadding As Boolean
            Get
                Return Me._SidePadding
            End Get
            Set(ByVal value As Boolean)
                Me._SidePadding = value
                Me.Invalidate()
            End Set
        End Property

        Public Property Values As Single()
            Get
                Return Me._Values.ToArray
            End Get
            Set(ByVal value As Single())
                Me.Clear()
                Me.AddValues(value)
                Me.InvalidateSmoothValues()
                Me.FindMinMax()
            End Set
        End Property

        Public Property VerticalLineColor As Color
            Get
                Return Me._VerticalLineColor.Color
            End Get
            Set(ByVal value As Color)
                Me._VerticalLineColor = New Pen(value)
                Me.Invalidate()
            End Set
        End Property


        ' Fields
        Private _BorderColor As Pen
        Private _DataColumnForeColor As SolidBrush
        Private _DataSmoothing As Boolean
        Private _DataSmoothingLevel As Byte
        Private _DrawDataColumn As Boolean
        Private _DrawHorizontalLines As Boolean
        Private _DrawHoverData As Boolean
        Private _DrawHoverLine As Boolean
        Private _DrawLineGraph As Boolean
        Private _DrawVerticalLines As Boolean
        Private _FillColor As SolidBrush
        Private _GraphBorderColor As Pen
        Private _GraphFillColor As SolidBrush
        Private _HorizontalLineColor As Pen
        Private _HoverBorderColor As Pen
        Private _HoverFillColor As SolidBrush
        Private _HoverLabelBorderColor As Pen
        Private _HoverLabelFillColor As SolidBrush
        Private _HoverLabelForeColor As SolidBrush
        Private _HoverLabelShadowColor As Pen
        Private _HoverLineColor As Pen
        Private _LineGraphColor As Pen
        Private _MaximumValue As Single
        Private _MinimumValue As Single
        Private _OverrideMax As Boolean
        Private _OverrideMaxValue As Single
        Private _OverrideMin As Boolean
        Private _OverrideMinValue As Single
        Private _SidePadding As Boolean
        Private _SmoothValues As List(Of Single)
        Private _Values As List(Of Single)
        Private _VerticalLineColor As Pen
        Private CurrentValue As Single
        Private FB1 As Single
        Private FB2 As Single
        Private G As Graphics
        Private GP As GraphicsPath
        Private Index As Integer
        Private LastMove As DateTime
        Private P As Point
        Private PS As PointF()
        Private R1 As Rectangle
        Private R2 As Rectangle
        Private R3 As Rectangle
        Private SB As String
        Private SG As Graphics
        Private SH As Integer
        Private SHH As Integer
        Private SS As Size
        Private SW As Integer

        ' Nested Types
        Public Delegate Sub ValueAddedEventHandler()
    End Class
End Namespace


