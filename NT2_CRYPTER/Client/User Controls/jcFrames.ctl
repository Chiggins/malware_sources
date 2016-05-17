VERSION 5.00
Begin VB.UserControl jcFrames 
   AutoRedraw      =   -1  'True
   CanGetFocus     =   0   'False
   ClientHeight    =   3000
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4770
   ControlContainer=   -1  'True
   FillStyle       =   0  'Solid
   HitBehavior     =   0  'None
   ScaleHeight     =   200
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   318
End
Attribute VB_Name = "jcFrames"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'=========================================================================
'   jcFrames v 1.0 Copyright © 2005.All rights reserved.
'   Juan Carlos San Román Arias (sanroman2004@yahoo.com)
'
'   You may use this control in your applications free of charge,
'   provided that you do not redistribute this source code without
'   giving me credit for my work.  Of course, credit in your
'   applications is always welcome.
'
'   Thanks to Jim K for doing the initial idea of the usercontrol using
'   my job posted in PSC
'
'   Thanks to ElectroZ for his frame style used here as TextBox style
'=========================================================================
'
'   Modifications: Paul R. Territo, Ph.D
'
'   The following code is based on the above authors submission which
'   can be found at the follow URL:
'   http://www.Planet-Source-Code.com/vb/scripts/ShowCode.asp?txtCodeId=63827&lngWId=1
'
'   29Dec05 - Moved all external API drawing and Type structures into UserControl
'       eliminate the need for external dependancies (i.e. OCX). This provides
'       a single drop in place UserControl which follows the general rules of
'       encapsulation (i.e. self-contained).
'
'=========================================================================================
'  --------------------------
'  Version 1.1 - 29 Dec. 2005
'  --------------------------
'   Thanks to Paul R. Territo, Ph.D for your advices and usercontrol modification.
'   - usercontrol includes now API drawing and type declaration (no more mods in usercontrol)
'   - Added icon alignment (left and right)
'   - caption alignment takes into consideration if icon picture exists and its alignment
'=========================================================================================

Option Explicit

'*************************************************************
'   Required Type Definitions
'*************************************************************

Private Type POINT
    X As Long
    Y As Long
End Type

Private Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

Public Enum jcStyleConst
    XPDefault = 0
    GradientFrame = 1
    TextBox = 2
    Windows = 3
    Messenger = 4
End Enum

'xp theme
Public Enum jcThemeConst
    Blue = 0
    Silver = 1
    Olive = 2
    Visual2005 = 3
    Norton2004 = 4
    Custom = 5
End Enum

'icon aligment
Public Enum IconAlignConst
    vbLeftAligment = 0
    vbRightAligment = 1
End Enum

Private Const ALTERNATE = 1      ' ALTERNATE and WINDING are
Private Const WINDING = 2        ' constants for FillMode.
Private Const BLACKBRUSH = 4     ' Constant for brush type.
Private Const WHITE_BRUSH = 0    ' Constant for brush type.

'*************************************************************
'   Required API Declarations
'*************************************************************
Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function MoveToEx Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, lpPoint As POINT) As Long
Private Declare Function LineTo Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long) As Long
Private Declare Function CreatePen Lib "gdi32" (ByVal nPenStyle As Long, ByVal nWidth As Long, ByVal crColor As Long) As Long
Private Declare Function DrawIconEx Lib "user32.dll" (ByVal hdc As Long, ByVal xLeft As Long, ByVal yTop As Long, ByVal hIcon As Long, ByVal cxWidth As Long, ByVal cyWidth As Long, ByVal istepIfAniCur As Long, ByVal hbrFlickerFreeDraw As Long, ByVal diFlags As Long) As Long
Private Declare Function SetRect Lib "user32" (lpRect As RECT, ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
Private Declare Function DrawTextEx Lib "user32" Alias "DrawTextExA" (ByVal hdc As Long, ByVal lpsz As String, ByVal n As Long, lpRect As RECT, ByVal un As Long, lpDrawTextParams As Any) As Long
Private Declare Function OleTranslateColor Lib "OLEPRO32.DLL" (ByVal OLE_COLOR As Long, ByVal HPALETTE As Long, pccolorref As Long) As Long
Private Declare Function RoundRect Lib "gdi32" (ByVal hdc As Long, ByVal Left As Long, ByVal Top As Long, ByVal Right As Long, ByVal Bottom As Long, ByVal EllipseWidth As Long, ByVal EllipseHeight As Long) As Long

'members
Private m_FrameColor            As OLE_COLOR
Private m_TextBoxColor          As OLE_COLOR
Private m_BackColor             As OLE_COLOR
Private m_FillColor             As OLE_COLOR
Private m_Caption               As String
Private m_TextBoxHeight         As Long
Private m_TextHeight            As Long
Private m_TextWidth             As Long
Private m_Height                As Long
Private m_TextColor             As Long
Private m_Alignment             As Long
Private m_Font                  As StdFont
Private m_RoundedCorner         As Boolean
Private m_RoundedCornerTxtBox   As Boolean
Private m_Style                 As jcStyleConst
Private m_Icon                  As StdPicture
Private m_IconSize              As Integer
Private m_IconAlignment         As IconAlignConst
Private m_ThemeColor            As jcThemeConst
Private m_ColorTo               As OLE_COLOR
Private m_ColorFrom             As OLE_COLOR
Private m_Indentation           As Integer
Private m_Space                 As Integer

Private Const DT_CENTER = &H1
Private Const DT_BOTTOM = &H8
Private Const DT_RIGHT = &H2
Private Const DT_TOP = &H0
Private Const DT_VCENTER = &H4
Private Const DT_SINGLELINE = &H20
Private Const DT_NOCLIP = &H100
Private Const DT_LEFT = &H0

Private jcTextBoxCenter As Long
Private jcTextDrawParams As Long
Private jcColorTo As OLE_COLOR
Private jcColorFrom As OLE_COLOR
Private jcColorBorderPic As OLE_COLOR

Private jcLpp As POINT


'==========================================================================
' Init, Read & Write UserControl
'==========================================================================
Private Sub UserControl_InitProperties()
    'Set default properties
    m_Caption = Ambient.DisplayName
    m_BackColor = Ambient.BackColor
    m_FillColor = Ambient.BackColor
    m_RoundedCorner = True
    m_RoundedCornerTxtBox = False
    m_Style = GradientFrame
    m_ThemeColor = Blue
    m_TextColor = vbBlack
    m_FrameColor = vbBlack
    m_TextBoxColor = vbWhite
    m_TextBoxHeight = 22
    SetjcTextDrawParams
End Sub

Private Sub UserControl_Initialize()
    Set m_Font = New StdFont
    Set UserControl.Font = m_Font
    m_IconSize = 16
    m_ThemeColor = Blue
    Call SetDefaultThemeColor(m_ThemeColor)
    m_TextBoxHeight = 22
    m_Alignment = vbCenter
    m_IconAlignment = vbLeftAligment
End Sub

Private Sub UserControl_Resize()
    PaintFrame
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    With PropBag
        m_FrameColor = .ReadProperty("FrameColor", vbBlack)
        m_BackColor = .ReadProperty("BackColor", Ambient.BackColor)
        m_FillColor = .ReadProperty("FillColor", Ambient.BackColor)
        m_TextBoxColor = .ReadProperty("TextBoxColor", vbWhite)
        m_Style = .ReadProperty("Style", GradientFrame)
        m_RoundedCorner = .ReadProperty("RoundedCorner", True)
        m_RoundedCornerTxtBox = .ReadProperty("RoundedCornerTxtBox", False)
        m_Caption = .ReadProperty("Caption", Ambient.DisplayName)
        m_TextBoxHeight = .ReadProperty("TextBoxHeight", 22)
        m_TextColor = .ReadProperty("TextColor", vbBlack)
        m_Alignment = .ReadProperty("Alignment", vbCenter)
        m_IconAlignment = .ReadProperty("IconAlignment", vbLeftAligment)
        Set m_Font = .ReadProperty("Font", Ambient.Font)
        Set m_Icon = .ReadProperty("Picture", Nothing)
        m_IconSize = .ReadProperty("IconSize", 16)
        m_ThemeColor = .ReadProperty("ThemeColor", Blue)
        m_ColorFrom = .ReadProperty("ColorFrom", 10395391)
        m_ColorTo = .ReadProperty("ColorTo", 15790335)
    End With
    'Add properties
    UserControl.BackColor = m_BackColor
    'SetTextBoxRect
    SetjcTextDrawParams
    SetFont m_Font
    Call SetDefaultThemeColor(m_ThemeColor)
    'Paint control
    PaintFrame
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    With PropBag
        .WriteProperty "FrameColor", m_FrameColor, vbBlack
        .WriteProperty "BackColor", m_BackColor, Ambient.BackColor
        .WriteProperty "FillColor", m_FillColor, Ambient.BackColor
        .WriteProperty "TextBoxColor", m_TextBoxColor, vbWhite
        .WriteProperty "Style", m_Style, GradientFrame
        .WriteProperty "RoundedCorner", m_RoundedCorner, True
        .WriteProperty "RoundedCornerTxtBox", m_RoundedCornerTxtBox, False
        .WriteProperty "Caption", m_Caption, Ambient.DisplayName
        .WriteProperty "TextBoxHeight", m_TextBoxHeight, 22
        .WriteProperty "TextColor", m_TextColor, vbBlack
        .WriteProperty "Alignment", m_Alignment, vbCenter
        .WriteProperty "IconAlignment", m_IconAlignment, vbLeftAligment
        .WriteProperty "Font", m_Font, Ambient.Font
        .WriteProperty "Picture", m_Icon, Nothing
        .WriteProperty "IconSize", m_IconSize, 16
        .WriteProperty "ThemeColor", m_ThemeColor, Blue
        .WriteProperty "ColorFrom", m_ColorFrom, 10395391
        .WriteProperty "ColorTo", m_ColorTo, 15790335
    End With
End Sub

'==========================================================================
' Properties
'==========================================================================
Public Property Let FrameColor(ByRef new_FrameColor As OLE_COLOR)
    m_FrameColor = new_FrameColor
    If m_ThemeColor = Custom Then jcColorBorderPic = m_FrameColor
    PropertyChanged "FrameColor"
    PaintFrame
End Property

Public Property Get FrameColor() As OLE_COLOR
    FrameColor = m_FrameColor
End Property

Public Property Let FillColor(ByRef new_FillColor As OLE_COLOR)
    m_FillColor = new_FillColor
    PropertyChanged "FillColor"
    PaintFrame
End Property

Public Property Get FillColor() As OLE_COLOR
    FillColor = m_FillColor
End Property

Public Property Let RoundedCornerTxtBox(ByRef new_RoundedCornerTxtBox As Boolean)
    m_RoundedCornerTxtBox = new_RoundedCornerTxtBox
    PropertyChanged "RoundedCornerTxtBox"
    PaintFrame
End Property

Public Property Get RoundedCornerTxtBox() As Boolean
    RoundedCornerTxtBox = m_RoundedCornerTxtBox
End Property

Public Property Let RoundedCorner(ByRef new_RoundedCorner As Boolean)
    m_RoundedCorner = new_RoundedCorner
    PropertyChanged "RoundedCorner"
    PaintFrame
End Property

Public Property Get RoundedCorner() As Boolean
    RoundedCorner = m_RoundedCorner
End Property

Public Property Let Caption(ByRef new_caption As String)
    m_Caption = new_caption
    PaintFrame
End Property

Public Property Get Caption() As String
    Caption = m_Caption
End Property

Public Property Let Alignment(ByRef new_Alignment As AlignmentConstants)
    m_Alignment = new_Alignment
    SetjcTextDrawParams
    PropertyChanged "Alignment"
    PaintFrame
End Property

Public Property Get Alignment() As AlignmentConstants
    Alignment = m_Alignment
End Property

Public Property Let Style(ByRef new_Style As jcStyleConst)
    m_Style = new_Style
    PropertyChanged "Style"
    SetDefault
    PaintFrame
End Property

Public Property Get Style() As jcStyleConst
    Style = m_Style
End Property

Public Property Let TextBoxHeight(ByRef new_TextBoxHeight As Long)
    m_TextBoxHeight = new_TextBoxHeight
    PropertyChanged "TextBoxHeight"
    PaintFrame
End Property

Public Property Get TextBoxHeight() As Long
    TextBoxHeight = m_TextBoxHeight
End Property

Public Property Let TextColor(ByRef new_TextColor As OLE_COLOR)
    m_TextColor = new_TextColor
    PropertyChanged "TextColor"
    PaintFrame
End Property

Public Property Get TextColor() As OLE_COLOR
    TextColor = m_TextColor
End Property

Public Property Let TextBoxColor(ByRef new_TextBoxColor As OLE_COLOR)
    m_TextBoxColor = new_TextBoxColor
    PropertyChanged "TextBoxColor"
    PaintFrame
End Property

Public Property Get TextBoxColor() As OLE_COLOR
    TextBoxColor = m_TextBoxColor
End Property

Public Property Let BackColor(ByRef new_BackColor As OLE_COLOR)
    m_BackColor = new_BackColor
    UserControl.BackColor = m_BackColor
    PropertyChanged "BackColor"
    PaintFrame
End Property

Public Property Get BackColor() As OLE_COLOR
    BackColor = m_BackColor
End Property

Public Property Set Font(ByRef new_font As StdFont)
    SetFont new_font
    PropertyChanged "Font"
    PaintFrame
End Property

Public Property Let Font(ByRef new_font As StdFont)
    SetFont new_font
    PropertyChanged "Font"
    PaintFrame
End Property
Public Property Get Font() As StdFont
    Set Font = m_Font
End Property

Public Property Get Picture() As StdPicture
    Set Picture = m_Icon
End Property

Public Property Set Picture(ByVal New_Picture As StdPicture)
    Set m_Icon = New_Picture
    PropertyChanged "Picture"
    PaintFrame
End Property

Public Property Get IconSize() As Integer
    IconSize = m_IconSize
End Property

Public Property Let IconSize(ByVal New_Value As Integer)
    m_IconSize = New_Value
    PropertyChanged "IconSize"
    PaintFrame
End Property

Public Property Let IconAlignment(ByRef new_IconAlignment As IconAlignConst)
    m_IconAlignment = new_IconAlignment
    PropertyChanged "IconAlignment"
    PaintFrame
End Property

Public Property Get IconAlignment() As IconAlignConst
    IconAlignment = m_IconAlignment
End Property

Public Property Get ThemeColor() As jcThemeConst
    ThemeColor = m_ThemeColor
End Property

Public Property Let ThemeColor(ByVal vData As jcThemeConst)
    If m_ThemeColor <> vData Then
        m_ThemeColor = vData
        Call SetDefaultThemeColor(m_ThemeColor)
        PaintFrame
        PropertyChanged "ThemeColor"
    End If
End Property

Public Property Get ColorFrom() As OLE_COLOR
    ColorFrom = m_ColorFrom
End Property

Public Property Let ColorFrom(ByRef new_ColorFrom As OLE_COLOR)
    m_ColorFrom = new_ColorFrom
    PropertyChanged "ColorFrom"
    jcColorFrom = m_ColorFrom
    PaintFrame
End Property

Public Property Get ColorTo() As OLE_COLOR
    ColorTo = m_ColorTo
End Property

Public Property Let ColorTo(ByRef new_ColorTo As OLE_COLOR)
    m_ColorTo = new_ColorTo
    PropertyChanged "ColorTo"
    jcColorTo = m_ColorTo
    PaintFrame
End Property

Private Sub SetjcTextDrawParams()
    'Set text draw params using m_Alignment
    If m_Alignment = vbLeftJustify Then
        jcTextDrawParams = DT_LEFT Or DT_SINGLELINE Or DT_VCENTER
    ElseIf m_Alignment = vbRightJustify Then
        jcTextDrawParams = DT_RIGHT Or DT_SINGLELINE Or DT_VCENTER
    Else
        jcTextDrawParams = DT_CENTER Or DT_SINGLELINE Or DT_VCENTER
    End If
End Sub

Private Sub SetFont(ByRef new_font As StdFont)
    With m_Font
        .Bold = new_font.Bold
        .Italic = new_font.Italic
        .Name = new_font.Name
        .SIZE = new_font.SIZE
    End With
    Set UserControl.Font = m_Font
End Sub

'==========================================================================
' Functions and subroutines
'==========================================================================

Private Sub SetDefaultThemeColor(ThemeType As Long)
    Select Case ThemeType
        Case 0 '"NormalColor"
            jcColorFrom = RGB(129, 169, 226)
            jcColorTo = RGB(221, 236, 254)
            jcColorBorderPic = RGB(0, 0, 128)
        Case 1 '"Metallic"
            jcColorFrom = RGB(153, 151, 180)
            jcColorTo = RGB(244, 244, 251)
            jcColorBorderPic = RGB(75, 75, 111)
        Case 2 '"HomeStead"
            jcColorFrom = RGB(181, 197, 143)
            jcColorTo = RGB(247, 249, 225)
            jcColorBorderPic = RGB(63, 93, 56)
        Case 3 '"Visual2005"
            jcColorFrom = RGB(194, 194, 171)
            jcColorTo = RGB(248, 248, 242)
            jcColorBorderPic = RGB(145, 145, 115)
        Case 4 '"Norton2004"
            jcColorFrom = RGB(217, 172, 1)
            jcColorTo = RGB(255, 239, 165)
            jcColorBorderPic = RGB(117, 91, 30)
        Case 5  'Custom
            jcColorFrom = m_ColorFrom
            jcColorTo = m_ColorTo
            jcColorBorderPic = m_FrameColor
        Case Else
            jcColorFrom = RGB(153, 151, 180)
            jcColorTo = RGB(244, 244, 251)
            jcColorBorderPic = RGB(75, 75, 111)
    End Select
End Sub

Private Sub PaintFrame()
    Dim R As RECT, R_Caption As RECT
    Dim p_left As Long, Ix As Integer, Iy As Integer
    
    m_Height = 3
    m_Indentation = 15
    m_Space = 6
    Ix = 0
    Iy = 0
    
    'Clear user control
    UserControl.Cls
    
    'Set caption height and width
    '----------------------------
    If Len(m_Caption) <> 0 Then
        m_TextWidth = UserControl.TextWidth(m_Caption)
        m_TextHeight = UserControl.TextHeight(m_Caption)
        jcTextBoxCenter = m_TextHeight / 2
    Else
        jcTextBoxCenter = 0
    End If

    Select Case m_Style
        Case Is = XPDefault
            
            'Draw border rectangle
            UserControl.FillColor = m_FillColor
            UserControl.ForeColor = m_FrameColor
            
            If m_RoundedCorner = False Then
                RoundRect UserControl.hdc, 0&, jcTextBoxCenter, UserControl.ScaleWidth, UserControl.ScaleHeight, 0&, 0&
            Else
                RoundRect UserControl.hdc, 0&, jcTextBoxCenter, UserControl.ScaleWidth, UserControl.ScaleHeight, 10&, 10&
            End If
            
            If Len(m_Caption) <> 0 Then
                
                If m_Alignment = vbLeftJustify Then
                    p_left = m_Indentation
                ElseIf m_Alignment = vbRightJustify Then
                    p_left = UserControl.ScaleWidth - m_TextWidth - m_Indentation - m_Space
                Else
                    p_left = (UserControl.ScaleWidth - m_TextWidth) / 2
                End If
                
                'Draw a line
                UserControl.ForeColor = UserControl.FillColor
                MoveToEx UserControl.hdc, p_left, jcTextBoxCenter, jcLpp
                LineTo UserControl.hdc, p_left + m_TextWidth + m_Space, jcTextBoxCenter
                
                'set caption rect
                SetRect R_Caption, p_left + m_Space / 2, 0, m_TextWidth + p_left + m_Space / 2, m_TextHeight
            End If
           
        Case Is = GradientFrame
            'Draw border rectangle
            UserControl.FillColor = BlendColors(jcColorFrom, vbWhite)
            UserControl.ForeColor = jcColorBorderPic
            jcTextBoxCenter = m_TextBoxHeight / 2

            If m_RoundedCorner = False Then
                RoundRect UserControl.hdc, 0&, jcTextBoxCenter, UserControl.ScaleWidth, UserControl.ScaleHeight, 0&, 0&
            Else
                RoundRect UserControl.hdc, 0&, jcTextBoxCenter, UserControl.ScaleWidth, UserControl.ScaleHeight, 10&, 10&
            End If

            UserControl.ForeColor = jcColorBorderPic
            SetRect R, 0, 0, UserControl.ScaleWidth - 1, m_Height
            DrawGradBorderRect UserControl.hdc, jcColorTo, jcColorFrom, R, jcColorBorderPic

            SetRect R, 0, m_Height, UserControl.ScaleWidth - 1, m_TextBoxHeight
            DrawGradBorderRect UserControl.hdc, jcColorTo, jcColorFrom, R, jcColorBorderPic

            SetRect R, 0, m_Height + m_TextBoxHeight, UserControl.ScaleWidth - 1, m_Height
            DrawGradBorderRect UserControl.hdc, jcColorTo, jcColorFrom, R, jcColorBorderPic

            UserControl.FillColor = m_TextBoxColor
            SetRect R, 1, 1 + m_Height * 2 + m_TextBoxHeight, UserControl.ScaleWidth - 1, UserControl.ScaleHeight - (1 + m_Height * 2 + m_TextBoxHeight) - UserControl.ScaleHeight * 0.2
            DrawVGradientEx UserControl.hdc, BlendColors(jcColorTo, vbWhite), BlendColors(jcColorFrom, vbWhite), R.Left, R.Top, R.Right, R.Bottom

            'set caption rect
            SetRect R_Caption, m_Space, m_Height + 1, UserControl.ScaleWidth - m_Space, m_TextBoxHeight + 2

            'set icon coordinates
            Iy = (m_Height * 2 + m_TextBoxHeight - m_IconSize) / 2

        Case Is = TextBox
            'Draw border rectangle
            UserControl.FillColor = m_FillColor
            UserControl.ForeColor = m_FrameColor
            jcTextBoxCenter = m_TextBoxHeight / 2
            
            If m_RoundedCorner = False Then
                RoundRect UserControl.hdc, 0&, jcTextBoxCenter, UserControl.ScaleWidth, UserControl.ScaleHeight, 0&, 0&
            Else
                RoundRect UserControl.hdc, 0&, jcTextBoxCenter, UserControl.ScaleWidth, UserControl.ScaleHeight, 10&, 10&
            End If
           
            'Draw text box borders
            UserControl.FillColor = m_TextBoxColor
            If m_RoundedCornerTxtBox = False Then
                RoundRect UserControl.hdc, m_Indentation, 0, UserControl.ScaleWidth - m_Indentation, m_TextBoxHeight, 0&, 0&
            Else
                RoundRect UserControl.hdc, m_Indentation, 0, UserControl.ScaleWidth - m_Indentation, m_TextBoxHeight, m_TextBoxHeight, m_TextBoxHeight
            End If
            
            'set caption rect
            SetRect R_Caption, m_Indentation + m_Space * 1.5, 0, UserControl.ScaleWidth - m_Indentation - m_Space * 1.5, m_TextBoxHeight - 1
            
            'set icon coordinates
            Ix = m_Indentation + m_Space * 2
            Iy = (m_TextBoxHeight - m_IconSize) / 2
    
        Case Is = Windows
            'Draw border rectangle
            UserControl.FillColor = m_FillColor
            UserControl.ForeColor = m_FrameColor
            jcTextBoxCenter = m_TextBoxHeight / 2
            
            If m_RoundedCorner = False Then
                RoundRect UserControl.hdc, 0&, jcTextBoxCenter, UserControl.ScaleWidth, UserControl.ScaleHeight, 0&, 0&
            Else
                RoundRect UserControl.hdc, 0&, jcTextBoxCenter, UserControl.ScaleWidth, UserControl.ScaleHeight, 10&, 10&
            End If
           
            'Draw text box borders
            UserControl.FillColor = m_TextBoxColor
            If m_RoundedCornerTxtBox = False Then
                RoundRect UserControl.hdc, 0&, 0, UserControl.ScaleWidth, m_TextBoxHeight, 0&, 0&
            Else
                RoundRect UserControl.hdc, 0&, 0, UserControl.ScaleWidth, m_TextBoxHeight, 10&, 10&
            End If
            
            'set caption rect
            SetRect R_Caption, m_Space, 0, UserControl.ScaleWidth - m_Space, m_TextBoxHeight - 1
            
            'set icon coordinates
            Iy = (m_TextBoxHeight - m_IconSize) / 2
         
        Case Is = Messenger
            'Draw border rectangle
            UserControl.FillColor = BlendColors(jcColorFrom, vbWhite)
            UserControl.ForeColor = vbBlack
            jcTextBoxCenter = 0
            
            If m_RoundedCorner = False Then
                RoundRect UserControl.hdc, 0&, jcTextBoxCenter, UserControl.ScaleWidth, UserControl.ScaleHeight, 0&, 0&
            Else
                RoundRect UserControl.hdc, 0&, jcTextBoxCenter, UserControl.ScaleWidth, UserControl.ScaleHeight, 10&, 10&
            End If
            
            UserControl.ForeColor = jcColorBorderPic
            SetRect R, 0, 0, UserControl.ScaleWidth - 1, m_Height * 2
            DrawGradBorderRect UserControl.hdc, vbWhite, jcColorFrom, R, vbBlack
            
            PaintShpInBar vbWhite, BlendColors(vbBlack, jcColorFrom), m_Height * 2
            
            SetRect R, 0, m_Height * 2 + m_TextBoxHeight, UserControl.ScaleWidth - 1, m_Height * 2 + m_TextBoxHeight
            APILineEx UserControl.hdc, R.Left, R.Top, R.Right, R.Bottom, vbBlack

            UserControl.FillColor = m_TextBoxColor
            SetRect R, 1, 1 + m_Height * 2 + m_TextBoxHeight, UserControl.ScaleWidth - 1, UserControl.ScaleHeight - (1 + m_Height * 2 + m_TextBoxHeight) - UserControl.ScaleHeight * 0.2
            DrawVGradientEx UserControl.hdc, BlendColors(jcColorTo, vbWhite), BlendColors(jcColorFrom, vbWhite), R.Left, R.Top, R.Right, R.Bottom
            
            'set caption rect
            SetRect R_Caption, m_Space, m_Height * 2 + 2, UserControl.ScaleWidth - m_Space, m_TextBoxHeight + 6
        
            'set icon coordinates
            Iy = m_Height * 2 + (m_TextBoxHeight - m_IconSize) / 2
        
    End Select
    
    'caption and icon alignments
    If Not (m_Icon Is Nothing Or m_Style = XPDefault) Then
        If m_IconAlignment = vbLeftAligment Then
            If m_Alignment = vbLeftJustify Then
                R_Caption.Left = R_Caption.Left + m_Space + m_IconSize
            ElseIf m_Alignment = vbRightJustify Then
                R_Caption.Left = R_Caption.Left + m_Space + m_IconSize
            Else
                R_Caption.Left = R_Caption.Left + m_Space + m_IconSize
                R_Caption.Right = R_Caption.Right - (m_Space + m_IconSize)
            End If
            If m_Style = TextBox Then
                Ix = m_Indentation + m_Space * 2
            Else
                Ix = m_Space
            End If
        ElseIf m_IconAlignment = vbRightAligment Then
            If m_Alignment = vbLeftJustify Then
                R_Caption.Right = R_Caption.Right - (m_Space + m_IconSize)
            ElseIf m_Alignment = vbRightJustify Then
                R_Caption.Right = R_Caption.Right - (m_Space + m_IconSize)
            Else
                R_Caption.Left = R_Caption.Left + m_Space + m_IconSize
                R_Caption.Right = R_Caption.Right - (m_Space + m_IconSize)
            End If
            If m_Style = TextBox Then
                Ix = UserControl.ScaleWidth - m_Space * 2 - m_IconSize - m_Indentation
            Else
                Ix = UserControl.ScaleWidth - m_Space - m_IconSize
            End If
        End If
    End If

    'Draw caption
    '------------
    If Len(m_Caption) <> 0 Then
        'Set text color
        UserControl.ForeColor = m_TextColor
        
        'Draw text
        DrawTextEx UserControl.hdc, m_Caption, Len(m_Caption), R_Caption, jcTextDrawParams, ByVal 0&
    End If
    
    'draw picture
    '------------
    If Not (m_Icon Is Nothing Or m_Style = XPDefault) Then
        If m_Style = Messenger Then
            If Iy < m_Height * 2 + 2 Then Iy = m_Height * 2 + 2
        ElseIf m_Style = GradientFrame Then
            If Iy < m_Height + 2 Then Iy = m_Height + 2
        Else
            If Iy < 0 Then Iy = m_Space / 2
        End If
        UserControl.PaintPicture m_Icon, Ix, Iy, m_IconSize, m_IconSize
    End If
End Sub

Private Sub SetDefault()
    Select Case m_Style
        Case Is = XPDefault
            m_TextColor = &HCF3603
            m_FrameColor = RGB(195, 195, 195)
            m_TextBoxColor = vbWhite
            m_TextBoxHeight = 22
            m_Alignment = vbLeftJustify
            m_FillColor = Ambient.BackColor
            SetjcTextDrawParams
        Case Is = GradientFrame
            m_TextColor = vbBlack
            m_FrameColor = vbBlack
            m_TextBoxColor = vbWhite
            m_TextBoxHeight = 22
            m_Alignment = vbCenter
            m_ThemeColor = Blue
            SetjcTextDrawParams
        Case Is = TextBox
            m_TextColor = vbBlack
            m_FrameColor = &H6A6A6A
            m_TextBoxColor = &HB0EFF0
            m_TextBoxHeight = 22
            m_Alignment = vbCenter
            m_RoundedCornerTxtBox = True
            SetjcTextDrawParams
        Case Is = Windows
            m_TextColor = vbBlack
            m_FrameColor = vbBlack
            m_TextBoxColor = &HB0EFF0
            m_TextBoxHeight = 22
            m_Alignment = vbCenter
            m_RoundedCorner = True
            m_FillColor = &HE0FFFF
            SetjcTextDrawParams
        Case Is = Messenger
            m_TextColor = vbBlack
            m_FrameColor = vbBlack
            m_TextBoxColor = vbWhite
            m_TextBoxHeight = 22
            m_Alignment = vbCenter
            m_ThemeColor = Blue
            SetjcTextDrawParams
    End Select
End Sub

Private Sub PaintShpInBar(iColorA As Long, iColorB As Long, m_Height As Long)
    Dim i As Integer, x_left As Integer, y_top As Integer, SpaceBtwnShp As Integer, NumShp As Integer
    Dim RectHeight As Long, RectWidth As Long, R As RECT

    SpaceBtwnShp = 2    'space between shapes
    NumShp = 9          'number of points
    RectHeight = 2      'shape height
    RectWidth = 2       'shape width
    
    'x and y shape  coordinates
    x_left = (UserControl.ScaleWidth - NumShp * RectWidth - (NumShp - 1) * SpaceBtwnShp) / 2
    y_top = (m_Height - RectHeight) / 2
    
    For i = 0 To NumShp - 1
        SetRect R, x_left + i * SpaceBtwnShp + i * RectWidth + 1, y_top + 1, 1, 1
        APIRectangle UserControl.hdc, R.Left, R.Top, R.Right, R.Bottom, iColorA
        SetRect R, x_left + i * SpaceBtwnShp + i * RectWidth, y_top, 1, 1
        APIRectangle UserControl.hdc, R.Left, R.Top, R.Right, R.Bottom, iColorB
    Next i
End Sub

'==========================================================================
' API Functions and subroutines
'==========================================================================

' full version of APILine
Private Sub APILineEx(lhdcEx As Long, X1 As Long, Y1 As Long, X2 As Long, Y2 As Long, lcolor As Long)

    'Use the API LineTo for Fast Drawing
    Dim pt As POINT
    Dim hPen As Long, hPenOld As Long
    hPen = CreatePen(0, 1, lcolor)
    hPenOld = SelectObject(lhdcEx, hPen)
    MoveToEx lhdcEx, X1, Y1, pt
    LineTo lhdcEx, X2, Y2
    SelectObject lhdcEx, hPenOld
    DeleteObject hPen
End Sub

Private Function APIRectangle(ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal w As Long, ByVal h As Long, Optional lcolor As OLE_COLOR = -1) As Long
    
    Dim hPen As Long, hPenOld As Long
    Dim R
    Dim pt As POINT
    hPen = CreatePen(0, 1, lcolor)
    hPenOld = SelectObject(hdc, hPen)
    MoveToEx hdc, X, Y, pt
    LineTo hdc, X + w, Y
    LineTo hdc, X + w, Y + h
    LineTo hdc, X, Y + h
    LineTo hdc, X, Y
    SelectObject hdc, hPenOld
    DeleteObject hPen
End Function

Private Sub DrawVGradientEx(lhdcEx As Long, lEndColor As Long, lStartcolor As Long, ByVal X As Long, ByVal Y As Long, ByVal X2 As Long, ByVal Y2 As Long)
    
    ''Draw a Vertical Gradient in the current HDC
    Dim dR As Single, dG As Single, dB As Single
    Dim sR As Single, sG As Single, sB As Single
    Dim eR As Single, eG As Single, eB As Single
    Dim ni As Long
    sR = (lStartcolor And &HFF)
    sG = (lStartcolor \ &H100) And &HFF
    sB = (lStartcolor And &HFF0000) / &H10000
    eR = (lEndColor And &HFF)
    eG = (lEndColor \ &H100) And &HFF
    eB = (lEndColor And &HFF0000) / &H10000
    dR = (sR - eR) / Y2
    dG = (sG - eG) / Y2
    dB = (sB - eB) / Y2
    For ni = 0 To Y2
        APILineEx lhdcEx, X, Y + ni, X2, Y + ni, RGB(eR + (ni * dR), eG + (ni * dG), eB + (ni * dB))
    Next ni
End Sub

Private Sub DrawGradBorderRect(lhdcEx As Long, lEndColor As Long, lStartcolor As Long, R As RECT, Optional lcolor As OLE_COLOR = -1)
    'draw gradient rectangle with border
    DrawVGradientEx lhdcEx, lEndColor, lStartcolor, R.Left, R.Top, R.Right, R.Bottom
    APIRectangle lhdcEx, R.Left, R.Top, R.Right, R.Bottom, lcolor
End Sub

'Blend two colors
Private Function BlendColors(ByVal lcolor1 As Long, ByVal lcolor2 As Long)
    BlendColors = RGB(((lcolor1 And &HFF) + (lcolor2 And &HFF)) / 2, (((lcolor1 \ &H100) And &HFF) + ((lcolor2 \ &H100) And &HFF)) / 2, (((lcolor1 \ &H10000) And &HFF) + ((lcolor2 \ &H10000) And &HFF)) / 2)
End Function

'System color code to long rgb
Private Function TranslateColor(ByVal lcolor As Long) As Long

    If OleTranslateColor(lcolor, 0, TranslateColor) Then
          TranslateColor = -1
    End If
End Function

