Imports System
Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.Windows.Forms

Namespace LuxNET
    Friend MustInherit Class ThemeControl
        Inherits Control
        ' Methods
        Public Sub New()
            Me.SetStyle((ControlStyles.OptimizedDoubleBuffer Or (ControlStyles.AllPaintingInWmPaint Or (ControlStyles.Opaque Or ControlStyles.UserPaint))), True)
            Me.B = New Bitmap(1, 1)
            Me.G = Graphics.FromImage(Me.B)
        End Sub

        Public Sub AllowTransparent()
            Me.SetStyle(ControlStyles.Opaque, False)
            Me.SetStyle(ControlStyles.SupportsTransparentBackColor, True)
        End Sub

        Private Sub ChangeMouseState(ByVal e As State)
            Me.MouseState = e
            Me.Invalidate()
        End Sub

        Protected Sub DrawBorders(ByVal p1 As Pen, ByVal p2 As Pen, ByVal rect As Rectangle)
            Me.G.DrawRectangle(p1, rect.X, rect.Y, (rect.Width - 1), (rect.Height - 1))
            Me.G.DrawRectangle(p2, CInt((rect.X + 1)), CInt((rect.Y + 1)), CInt((rect.Width - 3)), CInt((rect.Height - 3)))
        End Sub

        Protected Sub DrawCorners(ByVal c As Color, ByVal rect As Rectangle)
            If Not Me._NoRounding Then
                Me.B.SetPixel(rect.X, rect.Y, c)
                Me.B.SetPixel((rect.X + (rect.Width - 1)), rect.Y, c)
                Me.B.SetPixel(rect.X, (rect.Y + (rect.Height - 1)), c)
                Me.B.SetPixel((rect.X + (rect.Width - 1)), (rect.Y + (rect.Height - 1)), c)
            End If
        End Sub

        Protected Sub DrawGradient(ByVal c1 As Color, ByVal c2 As Color, ByVal x As Integer, ByVal y As Integer, ByVal width As Integer, ByVal height As Integer, ByVal angle As Single)
            Me._Rectangle = New Rectangle(x, y, width, height)
            Me._Gradient = New LinearGradientBrush(Me._Rectangle, c1, c2, angle)
            Me.G.FillRectangle(Me._Gradient, Me._Rectangle)
        End Sub

        Protected Sub DrawIcon(ByVal a As HorizontalAlignment, ByVal x As Integer)
            Me.DrawIcon(a, x, 0)
        End Sub

        Protected Sub DrawIcon(ByVal a As HorizontalAlignment, ByVal x As Integer, ByVal y As Integer)
            If (Not Me._Image Is Nothing) Then
                Select Case CInt(a)
                    Case 0
                        '    Me.G.DrawImage(Me._Image, x, (((Me.Height / 2) - (Me._Image.Height / 2)) + y))
                        Exit Select
                    Case 1
                        Me.G.DrawImage(Me._Image, CInt(((Me.Width - Me._Image.Width) - x)), CInt((((Me.Height / 2) - (Me._Image.Height / 2)) + y)))
                        Exit Select
                    Case 2
                        Me.G.DrawImage(Me._Image, CInt(((Me.Width / 2) - (Me._Image.Width / 2))), CInt(((Me.Height / 2) - (Me._Image.Height / 2))))
                        Exit Select
                End Select
            End If
        End Sub

        Protected Sub DrawText(ByVal a As HorizontalAlignment, ByVal c As Color, ByVal x As Integer)
            Me.DrawText(a, c, x, 0)
        End Sub

        Protected Sub DrawText(ByVal a As HorizontalAlignment, ByVal c As Color, ByVal x As Integer, ByVal y As Integer)
            If Not String.IsNullOrEmpty(Me.Text) Then
                Me._Size = Me.G.MeasureString(Me.Text, Me.Font).ToSize
                Me._Brush = New SolidBrush(c)
                Select Case CInt(a)
                    Case 0
                        Me.G.DrawString(Me.Text, Me.Font, Me._Brush, CSng(x), CSng((((Me.Height / 2) - (Me._Size.Height / 2)) + y)))
                        Exit Select
                    Case 1
                        Me.G.DrawString(Me.Text, Me.Font, Me._Brush, CSng(((Me.Width - Me._Size.Width) - x)), CSng((((Me.Height / 2) - (Me._Size.Height / 2)) + y)))
                        Exit Select
                    Case 2
                        Me.G.DrawString(Me.Text, Me.Font, Me._Brush, CSng((((Me.Width / 2) - (Me._Size.Width / 2)) + x)), CSng((((Me.Height / 2) - (Me._Size.Height / 2)) + y)))
                        Exit Select
                End Select
            End If
        End Sub

        Protected Overrides Sub OnMouseDown(ByVal e As MouseEventArgs)
            If (e.Button = MouseButtons.Left) Then
                Me.ChangeMouseState(State.MouseDown)
            End If
            MyBase.OnMouseDown(e)
        End Sub

        Protected Overrides Sub OnMouseEnter(ByVal e As EventArgs)
            Me.ChangeMouseState(State.MouseOver)
            MyBase.OnMouseEnter(e)
        End Sub

        Protected Overrides Sub OnMouseLeave(ByVal e As EventArgs)
            Me.ChangeMouseState(State.MouseNone)
            MyBase.OnMouseLeave(e)
        End Sub

        Protected Overrides Sub OnMouseUp(ByVal e As MouseEventArgs)
            Me.ChangeMouseState(State.MouseOver)
            MyBase.OnMouseUp(e)
        End Sub

        Protected NotOverridable Overrides Sub OnPaint(ByVal e As PaintEventArgs)
            If ((Me.Width <> 0) AndAlso (Me.Height <> 0)) Then
                Me.PaintHook()
                e.Graphics.DrawImage(Me.B, 0, 0)
            End If
        End Sub

        Protected Overrides Sub OnSizeChanged(ByVal e As EventArgs)
            If ((Me.Width <> 0) AndAlso (Me.Height <> 0)) Then
                Me.B = New Bitmap(Me.Width, Me.Height)
                Me.G = Graphics.FromImage(Me.B)
                Me.Invalidate()
            End If
            MyBase.OnSizeChanged(e)
        End Sub

        Public MustOverride Sub PaintHook()


        ' Properties
        Public Property Image As Image
            Get
                Return Me._Image
            End Get
            Set(ByVal value As Image)
                Me._Image = value
                Me.Invalidate()
            End Set
        End Property

        Public ReadOnly Property ImageTop As Integer
            Get
                If (Me._Image Is Nothing) Then
                    Return 0
                End If
                Return ((Me.Height / 2) - (Me._Image.Height / 2))
            End Get
        End Property

        Public ReadOnly Property ImageWidth As Integer
            Get
                If (Me._Image Is Nothing) Then
                    Return 0
                End If
                Return Me._Image.Width
            End Get
        End Property

        Public Property NoRounding As Boolean
            Get
                Return Me._NoRounding
            End Get
            Set(ByVal v As Boolean)
                Me._NoRounding = v
                Me.Invalidate()
            End Set
        End Property

        Public Overrides Property [Text] As String
            Get
                Return MyBase.Text
            End Get
            Set(ByVal v As String)
                MyBase.Text = v
                Me.Invalidate()
            End Set
        End Property


        ' Fields
        Private _Brush As SolidBrush
        Private _Gradient As LinearGradientBrush
        Private _Image As Image
        Private _NoRounding As Boolean
        Private _Rectangle As Rectangle
        Private _Size As Size
        Protected B As Bitmap
        Protected G As Graphics
        Protected MouseState As State

        ' Nested Types
        Protected Enum State As Byte
            ' Fields
            MouseDown = 2
            MouseNone = 0
            MouseOver = 1
        End Enum
    End Class
End Namespace

