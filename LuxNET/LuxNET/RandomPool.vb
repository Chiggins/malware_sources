Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.Runtime.CompilerServices
Imports System.Threading
Imports System.Windows.Forms

Namespace LuxNET
    <DefaultEvent("CharacterSelection")>
    Friend Class RandomPool
        Inherits ThemeControl

        Public Delegate Sub CharacterSelectionEventHandler(s As Object, c As Char)

        Private GO As Graphics

        Private _Size As Size

        '    Private CharacterSelectionEvent As RandomPool.CharacterSelectionEventHandler

        Private _Range As String

        Private _RangePadding As Integer

        Private _Brush As Brush

        Private Count As Integer

        Private Index1 As Integer

        Private Index2 As Integer

        Private Items As Char()

        Private RN As Random

        Public Event CharacterSelection As RandomPool.CharacterSelectionEventHandler
           
        Public Property Range() As String
            Get
                Return Me._Range
            End Get
            Set(value As String)
                Me._Range = value
                Me.UpdateSize()
            End Set
        End Property

        Public Property RangePadding() As Integer
            Get
                Return Me._RangePadding
            End Get
            Set(value As Integer)
                Me._RangePadding = value
                Me.UpdateSize()
            End Set
        End Property

        Public Overrides Property Font() As Font
            Get
                Return MyBase.Font
            End Get
            Set(value As Font)
                MyBase.Font = value
                Me.UpdateSize()
            End Set
        End Property

        Public Overrides Property ForeColor() As Color
            Get
                Return MyBase.ForeColor
            End Get
            Set(value As Color)
                MyBase.ForeColor = value
                Me._Brush = New SolidBrush(value)
                Me.Invalidate()
            End Set
        End Property

        Public Sub New()
            Me._Range = "0123456789!§$%&/()=?*+~#'-_<>|^°ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            Me._RangePadding = 2
            Me._Brush = SystemBrushes.ControlText
            Me.GO = Graphics.FromHwndInternal(Me.Handle)
        End Sub

        Private Sub UpdateSize()
            Me._Size = New Size(0, 0)
            Dim arg_1E_0 As Integer = 0
            ' The following expression was wrapped in a checked-statement
            Dim num As Integer = Me._Range.Length - 1
            Dim num2 As Integer = arg_1E_0
            While True
                Dim arg_E0_0 As Integer = num2
                Dim num3 As Integer = num
                If arg_E0_0 > num3 Then
                    Exit While
                End If
                Dim size As Size = Me.GO.MeasureString(Conversions.ToString(Me._Range(num2)), Me.Font).ToSize()
                size.Width += Me._RangePadding
                size.Height += Me._RangePadding
                Dim flag As Boolean = size.Height > Me._Size.Height
                If flag Then
                    Me._Size.Height = size.Height
                End If
                flag = (size.Width > Me._Size.Width)
                If flag Then
                    Me._Size.Width = size.Width
                End If
                num2 += 1
            End While
            Me.Randomize()
        End Sub

        Protected Overrides Sub OnMouseMove(e As MouseEventArgs)
            Try
                Me.Index1 = Me.GetIndex(e.X, e.Y)
                Dim flag As Boolean = Me.Index1 = Me.Index2
                ' The following expression was wrapped in a checked-statement
                If Not flag Then
                    Dim characterSelectionEvent As RandomPool.CharacterSelectionEventHandler = Me.CharacterSelectionEvent
                    flag = (characterSelectionEvent IsNot Nothing)
                    If flag Then
                        characterSelectionEvent(Me, Me.Items(Me.Index1))
                    End If
                    Me.Randomize(Me.Index1 - Me.Count)
                    Me.Randomize(Me.Index1 - 1)
                    Me.Randomize(Me.Index1)
                    Me.Randomize(Me.Index1 + 1)
                    Me.Randomize(Me.Index1 + Me.Count)
                    Me.Index2 = Me.Index1
                    Me.Invalidate()
                End If
            Catch ex As Exception

            End Try

        End Sub

        Protected Overrides Sub OnSizeChanged(e As EventArgs)
            Dim flag As Boolean = Me._Size.Width = 0
            If flag Then
                Me.UpdateSize()
            Else
                Me.Randomize()
            End If
            MyBase.OnSizeChanged(e)
        End Sub

        Public Overrides Sub PaintHook()
            Me.G.Clear(Me.BackColor)
            Dim arg_29_0 As Integer = 0
            ' The following expression was wrapped in a checked-statement
            Dim num As Integer = Me.Width - 1
            Dim width As Integer = Me._Size.Width
            Dim num2 As Integer = arg_29_0
            While True
                Dim arg_A7_0 As Integer = width >> 31 Xor num2
                Dim num3 As Integer = width >> 31 Xor num
                If arg_A7_0 > num3 Then
                    Exit While
                End If
                Dim arg_44_0 As Integer = 0
                Dim num4 As Integer = Me.Height - 1
                Dim height As Integer = Me._Size.Height
                Dim num5 As Integer = arg_44_0
                While True
                    Dim arg_90_0 As Integer = height >> 31 Xor num5
                    num3 = (height >> 31 Xor num4)
                    If arg_90_0 > num3 Then
                        Exit While
                    End If
                    Me.G.DrawString(Conversions.ToString(Me.Items(Me.GetIndex(num2, num5))), Me.Font, Me._Brush, CSng(num2), CSng(num5))
                    num5 += height
                End While
                num2 += width
            End While
        End Sub

        Private Function GetIndex(x As Integer, y As Integer) As Integer
            ' The following expression was wrapped in a checked-expression
            Return y / Me._Size.Height * Me.Count + x / Me._Size.Width
        End Function

        Private Sub Randomize()
            ' The following expression was wrapped in a checked-statement
            Me.Count = CInt(Math.Round(Math.Ceiling(CDec(Me.Width) / CDec(Me._Size.Width))))
            Me.RN = New Random(Guid.NewGuid().GetHashCode())
            Me.Items = New Char(CInt(Math.Round(Math.Ceiling(CDec(Me.Width) / CDec(Me._Size.Width)) * Math.Ceiling(CDec(Me.Height) / CDec(Me._Size.Height)))) - 1 + 1 - 1) {}
            Dim arg_98_0 As Integer = 0
            Dim num As Integer = Me.Items.Length - 1
            Dim num2 As Integer = arg_98_0
            While True
                Dim arg_CD_0 As Integer = num2
                Dim num3 As Integer = num
                If arg_CD_0 > num3 Then
                    Exit While
                End If
                Me.Items(num2) = Me._Range(Me.RN.[Next](Me._Range.Length))
                num2 += 1
            End While
            Me.Invalidate()
        End Sub

        Private Sub Randomize(index As Integer)
            Dim flag As Boolean = index > -1 AndAlso index < Me.Items.Length
            If flag Then
                Me.Items(index) = Me._Range(Me.RN.[Next](Me._Range.Length))
            End If
        End Sub
    End Class
End Namespace
