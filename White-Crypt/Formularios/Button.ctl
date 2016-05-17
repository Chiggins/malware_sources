VERSION 5.00
Begin VB.UserControl Button 
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   ScaleHeight     =   3600
   ScaleWidth      =   4800
End
Attribute VB_Name = "Button"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'''''''''''''''''''''''''''''''''''''''''''''''''''''
' ************************************************* '
' *                                               * '
' *  Control Name:   ShapeButton                  * '
' *                                               * '
' *  Created:        10/September/2007            * '
' *                                               * '
' *  Created by:       Ahmed Alotiabe             * '
' *                                               * '
' *  You Have A Royalty Free Right To Use         * '
' *  Modify And Reproduce And Distribute.         * '
' *                                               * '
' *  But I Assume No Warranty, Obligations        * '
' *  Or Liability For The Use Of This Code.       * '
' *                                               * '
' *   For Any Damage This Control                 * '
' *           Can Cause To Your Products.         * '
' ************************************************* '
'''''''''''''''''''''''''''''''''''''''''''''''''''''

'>> Needed For The API Call >> GradientFill >> Backgraound
Private Type GRADIENT_RECT
    UpperLeft            As Long
    LowerRight           As Long
End Type

Private Type TRIVERTEX
    x                    As Long
    y                    As Long
    Red                  As Integer
    Green                As Integer
    Blue                 As Integer
    Alpha                As Integer
End Type
'............................................................
'>>Needed For The API Call >> CreatePolygonRgn >> Polygon
'>>Postion For Picture And Caption ...etc.
Private Type POINTAPI
    x                    As Long
    y                    As Long
End Type
'............................................................
'>> Constant Types Used With CreatePolygonRgn
Private Const WINDING    As Long = 2

'............................................................
'>> Constant Types Used With GradientFill
Private Const GRADIENT_FILL_RECT_H As Long = &H0
Private Const GRADIENT_FILL_RECT_V As Long = &H1

'............................................................
'>> Constant Types For LinsStyle
Private Const BDR_VISUAL As Long = vb3DDKShadow
Private Const BDR_VISUAL1 As Long = vbButtonShadow
Private Const BDR_VISUAL2 As Long = vb3DHighlight

'............................................................
'>> Constant Types For LinsStyle
Private Const BDR_FLAT1  As Long = vb3DDKShadow
Private Const BDR_FLAT2  As Long = vb3DHighlight

'............................................................
'>> Constant Types For LinsStyle
Private Const BDR_JAVA1  As Long = vbButtonShadow
Private Const BDR_JAVA2  As Long = vb3DHighlight

'............................................................
'>> Constant Values For White Border >> IF Mouse Down Button
Private Const BDR_PRESSED As Long = vb3DHighlight

'............................................................
'>> Constant Values For Gold Border >> IF Mouse Over Button
Private Const BDR_GOLDXP_DARK As Long = &H109ADC
Private Const BDR_GOLDXP_NORMAL1 As Long = &H31B2F0
Private Const BDR_GOLDXP_NORMAL2 As Long = &H90D6F7
Private Const BDR_GOLDXP_LIGHT1 As Long = &HCEF3FF
Private Const BDR_GOLDXP_LIGHT2 As Long = &H8CDBFF

'............................................................
'>> Constant Types For LinsStyle
Private Const BDR_VISTA1 As Long = vbWhite
Private Const BDR_VISTA2 As Long = &HCFB073

'............................................................
'>> Constant Types For FocusRect
'>> If Display Properties Colors IS Hight Color(16Bit)Use
'Private Const BDR_FOCUSRECT As Long = &HC0C0C0    '>> Color Gray

'>> If Display Properties Colors IS TrueColor(32Bit)Use
Private Const BDR_FOCUSRECT As Long = &HD1D1D1             '>> Color LightGray
'>> Constant Types For FocusRect Java
Private Const BDR_FOCUSRECT_JAVA As Long = &HCC9999        '>> ColorMauve
'>> Constant Values For FocusRect Vista
Private Const BDR_FOCUSRECT_VISTA As Long = 16698372
'>> Constant Values For FocusRect Xp
Private Const BDR_BLUEXP_DARK As Long = &HD98D59
Private Const BDR_BLUEXP_NORMAL1 As Long = &HE2A981
Private Const BDR_BLUEXP_NORMAL2 As Long = &HF0D1B5
Private Const BDR_BLUEXP_LIGHT1 As Long = &HF7D7BD
Private Const BDR_BLUEXP_LIGHT2 As Long = &HFFE7CE

'............................................................
'>> Constant Types For HandPointer
Private Const CURSOR_HAND = 32649&

'............................................................
'>> API Declare Function's
Private Declare Function LoadCursor Lib "user32" Alias "LoadCursorA" (ByVal hInstance As Long, ByVal lpCursorName As Long) As Long
Private Declare Function SetCursor Lib "user32" (ByVal hCursor As Long) As Long
Private Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
Private Declare Function ScreenToClient Lib "user32" (ByVal hwnd As Long, lpPoint As POINTAPI) As Long
Private Declare Function GetCapture& Lib "user32" ()
Private Declare Function SetCapture& Lib "user32" (ByVal hwnd&)
Private Declare Function ReleaseCapture& Lib "user32" ()
Private Declare Function GetPixel Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long
Private Declare Function SetPixel Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long
Private Declare Function GetTextExtentPoint32 Lib "gdi32" Alias "GetTextExtentPoint32A" (ByVal hdc As Long, ByVal lpsz As String, ByVal cbString As Long, lpSize As POINTAPI) As Long
Private Declare Function TextOutW Lib "gdi32" Alias "TextOutA" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal lpString As String, ByVal nCount As Long) As Long
Private Declare Function TextOutA Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal lpString As String, ByVal nCount As Long) As Long
Private Declare Function MoveToEx Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, lpPoint As POINTAPI) As Long
Private Declare Function LineTo Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long
Private Declare Function Arc Lib "gdi32" (ByVal hdc As Long, ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long, ByVal X3 As Long, ByVal Y3 As Long, ByVal X4 As Long, ByVal Y4 As Long) As Long
Private Declare Function GradientFill Lib "msimg32" (ByVal hdc As Long, ByRef pVertex As TRIVERTEX, ByVal dwNumVertex As Long, pMesh As Any, ByVal dwNumMesh As Long, ByVal dwMode As Long) As Integer
Private Declare Function TranslateColor Lib "olepro32.dll" Alias "OleTranslateColor" (ByVal clr As OLE_COLOR, ByVal palet As Long, Col As Long) As Long
Private Declare Function CreatePolygonRgn Lib "gdi32" (lpPoint As POINTAPI, ByVal nCount As Long, ByVal nPolyFillMode As Long) As Long
Private Declare Function Polygon Lib "gdi32" (ByVal hdc As Long, lpPoint As POINTAPI, ByVal nCount As Long) As Long
Private Declare Function CreateRoundRectRgn Lib "gdi32" (ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long, ByVal X3 As Long, ByVal Y3 As Long) As Long
Private Declare Function CreateEllipticRgn Lib "gdi32" (ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
Private Declare Function RoundRect Lib "gdi32" (ByVal hdc As Long, ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long, ByVal X3 As Long, ByVal Y3 As Long) As Long
Private Declare Function SetWindowRgn Lib "user32" (ByVal hwnd As Long, ByVal hRgn As Long, ByVal bRedraw As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long

'............................................................
'>> Button Declarations
'............................................................
Public Enum EnumButtonShape
    Rectangle
    RoundedRectangle
    Round
    Diamond
    Top_Triangle
    Left_Triangle
    Right_Triangle
    Down_Triangle
    top_Arrow
    Left_Arrow
    Right_Arrow
    Down_Arrow
End Enum
Public Enum EnumButtonStyle
    Custom
    Visual
    Flat
    OverFlat
    Java
    XPOffice
    WinXp
    Vista
    Glass
End Enum
Public Enum EnumButtonStyleColors
    TRANSPARENT
    SingleColor
    Gradient_H
    Gradient_V
    TubeCenter_H
    TubeTopBottom_H
    TubeCenter_V
    TubeTopBottom_V
End Enum
Public Enum EnumButtonTheme
    NoTheme
    XpBlue
    XpOlive
    XPSilver
    Visual2005
    Norton2005
    RedColor
    GreenColor
    BlueColor
End Enum
Public Enum EnumButtonType
    Button
    CheckBox
End Enum
Public Enum EnumCaptionAlignment
    TopCaption
    LeftCaption
    CenterCaption
    RightCaption
    BottomCaption
End Enum
Public Enum EnumCaptionEffect
    Default
    Raised
    Sunken
    Outline
End Enum
Public Enum EnumCaptionStyle
    Normal
    HorizontalFill
    VerticalFill
End Enum
Public Enum EnumDropDown
    None
    LeftDropDown
    RightDropDown
End Enum
Public Enum EnumPictureAlignment
    TopPicture
    LeftPicture
    CenterPicture
    RightPicture
    BottomPicture
End Enum
'............................................................
'>> Property Member Variables
'............................................................
Private mButtonShape     As EnumButtonShape
Private mButtonStyle     As EnumButtonStyle
Private mButtonStyleColors As EnumButtonStyleColors
Private mButtonTheme     As EnumButtonTheme
Private mButtonType      As EnumButtonType
Private mCaptionAlignment As EnumCaptionAlignment
Private mCaptionEffect   As EnumCaptionEffect
Private mCaptionStyle    As EnumCaptionStyle
Private mDropDown        As EnumDropDown
Private mPictureAlignment As EnumPictureAlignment

'............................................................
'>> Property Color Variables
Dim mBackColor           As OLE_COLOR
Dim mBackColorPressed    As OLE_COLOR
Dim mBackColorHover      As OLE_COLOR
'............................................................
Dim mBorderColor         As OLE_COLOR
Dim mBorderColorPressed  As OLE_COLOR
Dim mBorderColorHover    As OLE_COLOR
'............................................................
Dim mForeColor           As OLE_COLOR
Dim mForeColorPressed    As OLE_COLOR
Dim mForeColorHover      As OLE_COLOR
'............................................................
Dim mEffectColor         As OLE_COLOR

Dim mCaption             As String
Dim mFocusRect           As Boolean
Dim mFocused             As Boolean
Dim mValue               As Boolean
Dim mHandPointer         As Boolean
Dim mPicture             As Picture
Dim mPictureGray         As Boolean
'............................................................
Dim CaptionPos(1)        As POINTAPI                          '>> Postion Text
Dim PicturePos(1)        As POINTAPI                          '>> Postion Picture
Dim Fo                   As POINTAPI               '>> Region Of FocusRect
'............................................................
'>> Mouse Button >> Hovered Or Pressed
Private MouseMove, MouseDown As Boolean
Attribute MouseDown.VB_VarUserMemId = 1073938462

Dim P(0 To 7)            As POINTAPI
Attribute P.VB_VarUserMemId = 1073938464
Dim PL(0 To 7)           As POINTAPI
Attribute PL.VB_VarUserMemId = 1073938465
Dim Lines                As POINTAPI
Attribute Lines.VB_VarUserMemId = 1073938466
Dim hRgn                 As Long
Attribute hRgn.VB_VarUserMemId = 1073938467
'............................................................
'>> Button Event Declaration's
'............................................................
Public Event Click()
Public Event DblClick()
Public Event KeyDown(KeyCode As Integer, Shift As Integer)
Public Event KeyPress(KeyAscii As Integer)
Public Event KeyUp(KeyCode As Integer, Shift As Integer)
Public Event MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
Public Event MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
Public Event MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
Public Event OLECompleteDrag(Effect As Long)
Public Event OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, y As Single)
Public Event OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, y As Single, State As Integer)
Public Event OLEGiveFeedback(Effect As Long, DefaultCursors As Boolean)
Public Event OLESetData(Data As DataObject, DataFormat As Integer)
Public Event OLEStartDrag(Data As DataObject, AllowedEffects As Long)
'............................................................
'>> Start Properties Button
'............................................................
Public Property Get hdc() As Long
    hdc = UserControl.hdc
End Property
Public Property Get hwnd() As Long
    hwnd = UserControl.hwnd
End Property
Public Sub Refresh()
    UserControl.Refresh
End Sub

Public Property Get ButtonShape() As EnumButtonShape
    ButtonShape = mButtonShape
End Property
Public Property Let ButtonShape(ByVal EBS As EnumButtonShape)
    mButtonShape = EBS
    PropertyChanged "ButtonShape"
    UserControl_Paint
End Property
Public Property Get ButtonStyle() As EnumButtonStyle
    ButtonStyle = mButtonStyle
End Property
Public Property Let ButtonStyle(ByVal EBS As EnumButtonStyle)
    mButtonStyle = EBS
    PropertyChanged "ButtonStyle"
    '.............................................................
    '>> ButtonStyle,Visual, Flat,OverFlat,Java,XpOffice,WinXp
    '>> Vista,Glass
    '>> Default BackColors To ButtonStyle At Hover,Press,Off
    '>> 'Default ForeColors To ButtonStyle At Hover,Press,Off
    '.............................................................
    Select Case mButtonStyle
        Case Is = Visual
            mBackColor = vbButtonFace
            mBackColorHover = vbButtonFace
            mBackColorPressed = vbButtonFace
            'mForeColor = vbBlack
            'mForeColorHover = vbBlack
            'mForeColorPressed = vbBlack
        Case Is = Flat
            mBackColor = vbButtonFace
            mBackColorHover = vbButtonFace
            mBackColorPressed = vbButtonFace
            'mForeColor = vbBlack
            ' mForeColorHover = vbBlack
            'mForeColorPressed = vbBlack
        Case Is = OverFlat
            mBackColor = vbButtonFace
            mBackColorHover = vbButtonFace
            mBackColorPressed = vbButtonFace
            'mForeColor = vbBlack
            'mForeColorHover = vbBlack
            'mForeColorPressed = vbBlack
        Case Is = Java
            If Not mButtonStyleColors = TRANSPARENT Then mButtonStyleColors = SingleColor
            mBackColor = vbButtonFace
            mBackColorHover = vbButtonFace
            mBackColorPressed = &H999999
            'mForeColor = vbBlack
            'mForeColorHover = vbBlack
            'mForeColorPressed = vbBlack
        Case Is = XPOffice
            mBackColor = vbButtonFace
            mBackColorHover = &HB6A59F
            mBackColorPressed = &HAF8C80
            'mForeColor = vbBlack
            'mForeColorHover = vbBlack
            'mForeColorPressed = vbBlack
        Case Is = WinXp
            If Not mButtonStyleColors = TRANSPARENT Then mButtonStyleColors = Gradient_V
            mBackColor = &HD2DEDD
            mBackColorHover = vbWhite
            mBackColorPressed = vbWhite
            'mForeColor = vbBlack
            'mForeColorHover = vbBlack
            'mForeColorPressed = vbBlack
        Case Is = Vista
            mBackColor = &HD8D8D8
            mBackColorHover = &HF7DBA5
            mBackColorPressed = &HEFCE92
            'mForeColor = &H8000000D    'vbhightlight
            'mForeColorHover = &H8000000D
            'mForeColorPressed = &H8000000D
        Case Is = Glass
            mBackColor = vbDesktop
            mBackColorHover = vbDesktop
            mBackColorPressed = vbDesktop
            'mForeColor = vbWhite
            'mForeColorHover = vbWhite
            'mForeColorPressed = vbWhite
    End Select
    UserControl_Paint
End Property
Public Property Get ButtonStyleColors() As EnumButtonStyleColors
    ButtonStyleColors = mButtonStyleColors
End Property
Public Property Let ButtonStyleColors(ByVal EBSC As EnumButtonStyleColors)
    mButtonStyleColors = EBSC
    PropertyChanged "ButtonStyleColors"
    UserControl_Paint
End Property
Public Property Get ButtonTheme() As EnumButtonTheme
    ButtonTheme = mButtonTheme
End Property
Public Property Let ButtonTheme(ByVal EBT As EnumButtonTheme)
    mButtonTheme = EBT
    PropertyChanged "ButtonTheme"
    '.............................................................
    '>> ButtonTheme,XpBlue,XpOlive,XPSilver,Visual2005,Norton2005
    '>> RedColor,GreenColor,BlueColor.
    '.............................................................
    Select Case mButtonTheme
        Case Is = XpBlue
            mBackColor = &HF1B39A
            mBackColorHover = &HFDF7F4
            mBackColorPressed = &HFAE6DD
            mBorderColor = &HF1B39A
            mBorderColorHover = &HF1B39A
            mBorderColorPressed = &HF1B39A
        Case Is = XpOlive
            mBackColor = &H3DB4A2
            mBackColorHover = &HDFF4F2
            mBackColorPressed = &HB8E7E0
            mBorderColor = &H3DB4A2
            mBorderColorHover = &H3DB4A2
            mBorderColorPressed = &H3DB4A2
        Case Is = XPSilver
            mBackColor = &HB5A09D
            mBackColorHover = &HF7F5F4
            mBackColorPressed = &HECE7E6
            mBorderColor = &HB5A09D
            mBorderColorHover = mBorderColor
            mBorderColorPressed = mBorderColor
        Case Is = Visual2005
            mBackColor = &HABC2C2
            mBackColorHover = &HF2F8F8
            mBackColorPressed = &HE6EDEE
            mBorderColor = &HABC2C2
            mBorderColorHover = mBorderColor
            mBorderColorPressed = mBorderColor
        Case Is = Norton2005
            mBackColor = &H2C5F5
            mBackColorHover = &HE2F9FF
            mBackColorPressed = &HAFEFFE
            mBorderColor = &H2C5F5
            mBorderColorHover = mBorderColor
            mBorderColorPressed = mBorderColor
        Case Is = RedColor
            mBackColor = &H26368B
            mBackColorHover = &H4763FF
            mBackColorPressed = &H425CEE
            mBorderColor = vbRed
            mBorderColorHover = mBorderColor
            mBorderColorPressed = mBorderColor
        Case Is = GreenColor
            mBackColor = &H578B2E
            mBackColorHover = &H9FFF54
            mBackColorPressed = &H80CD43
            mBorderColor = vbGreen
            mBorderColorHover = mBorderColor
            mBorderColorPressed = mBorderColor
        Case Is = BlueColor
            mBackColor = &H8B4027
            mBackColorHover = &HFF7648
            mBackColorPressed = &HCD5F3A
            mBorderColor = vbBlue
            mBorderColorHover = mBorderColor
            mBorderColorPressed = mBorderColor
    End Select
    UserControl_Paint
End Property
Public Property Get ButtonType() As EnumButtonType
    ButtonType = mButtonType
End Property
Public Property Let ButtonType(ByVal EBT As EnumButtonType)
    mButtonType = EBT
    PropertyChanged "ButtonType"
    UserControl_Paint
End Property
Public Property Get CaptionAlignment() As EnumCaptionAlignment
    CaptionAlignment = mCaptionAlignment
End Property
Public Property Let CaptionAlignment(ByVal ECA As EnumCaptionAlignment)
    mCaptionAlignment = ECA
    PropertyChanged "CaptionAlignment"
    UserControl_Paint
End Property
Public Property Get CaptionEffect() As EnumCaptionEffect
    CaptionEffect = mCaptionEffect
End Property
Public Property Let CaptionEffect(ByVal ECE As EnumCaptionEffect)
    mCaptionEffect = ECE
    PropertyChanged "CaptionEffect"
    UserControl_Paint
End Property
Public Property Get CaptionStyle() As EnumCaptionStyle
    CaptionStyle = mCaptionStyle
End Property
Public Property Let CaptionStyle(ByVal ECS As EnumCaptionStyle)
    mCaptionStyle = ECS
    PropertyChanged "CaptionStyle"
    UserControl_Paint
End Property
Public Property Get DropDown() As EnumDropDown
    DropDown = mDropDown
End Property
Public Property Let DropDown(ByVal EDD As EnumDropDown)
    mDropDown = EDD
    PropertyChanged "DropDown"
    UserControl_Paint
End Property
Public Property Get PictureAlignment() As EnumPictureAlignment
    PictureAlignment = mPictureAlignment
End Property
Public Property Let PictureAlignment(ByVal EPA As EnumPictureAlignment)
    mPictureAlignment = EPA
    PropertyChanged "PictureAlignment"
    UserControl_Paint
End Property
Public Property Get BackColor() As OLE_COLOR
    BackColor = mBackColor
End Property
Public Property Let BackColor(ByVal New_Color As OLE_COLOR)
    mBackColor = New_Color
    PropertyChanged "BackColor"
    UserControl_Paint
End Property
Public Property Get BackColorPressed() As OLE_COLOR
    BackColorPressed = mBackColorPressed
End Property
Public Property Let BackColorPressed(ByVal New_Color As OLE_COLOR)
    mBackColorPressed = New_Color
    PropertyChanged "BackColorPressed"
    UserControl_Paint
End Property
Public Property Get BackColorHover() As OLE_COLOR
    BackColorHover = mBackColorHover
End Property
Public Property Let BackColorHover(ByVal New_Color As OLE_COLOR)
    mBackColorHover = New_Color
    PropertyChanged "BackColorHover"
    UserControl_Paint
End Property
Public Property Get BorderColor() As OLE_COLOR
    BorderColor = mBorderColor
End Property
Public Property Let BorderColor(ByVal New_Color As OLE_COLOR)
    mBorderColor = New_Color
    PropertyChanged "BorderColor"
    UserControl_Paint
End Property
Public Property Get BorderColorPressed() As OLE_COLOR
    BorderColorPressed = mBorderColorPressed
End Property
Public Property Let BorderColorPressed(ByVal New_Color As OLE_COLOR)
    mBorderColorPressed = New_Color
    PropertyChanged "BorderColorPressed"
    UserControl_Paint
End Property
Public Property Get BorderColorHover() As OLE_COLOR
    BorderColorHover = mBorderColorHover
End Property
Public Property Let BorderColorHover(ByVal New_Color As OLE_COLOR)
    mBorderColorHover = New_Color
    PropertyChanged "BorderColorHover"
    UserControl_Paint
End Property
Public Property Get ForeColor() As OLE_COLOR
    ForeColor = mForeColor
End Property
Public Property Let ForeColor(ByVal New_Color As OLE_COLOR)
    mForeColor = New_Color
    PropertyChanged "ForeColor"
    UserControl_Paint
End Property
Public Property Get ForeColorPressed() As OLE_COLOR
    ForeColorPressed = mForeColorPressed
End Property
Public Property Let ForeColorPressed(ByVal New_Color As OLE_COLOR)
    mForeColorPressed = New_Color
    PropertyChanged "ForeColorPressed"
    UserControl_Paint
End Property
Public Property Get ForeColorHover() As OLE_COLOR
    ForeColorHover = mForeColorHover
End Property
Public Property Let ForeColorHover(ByVal New_Color As OLE_COLOR)
    mForeColorHover = New_Color
    PropertyChanged "ForeColorHover"
    UserControl_Paint
End Property
Public Property Get EffectColor() As OLE_COLOR
    EffectColor = mEffectColor
End Property
Public Property Let EffectColor(ByVal New_Color As OLE_COLOR)
    mEffectColor = New_Color
    PropertyChanged "EffectColor"
    UserControl_Paint
End Property
Public Property Get Caption() As String
    Caption = mCaption
End Property
Public Property Let Caption(ByVal NewCaption As String)
    mCaption = NewCaption
    PropertyChanged "Caption"
    UserControl_Paint
End Property
Public Property Get FocusRect() As Boolean
    FocusRect = mFocusRect
End Property
Public Property Let FocusRect(ByVal New_FocusRect As Boolean)
    mFocusRect = New_FocusRect
    PropertyChanged "FocusRect"
    UserControl_Paint
End Property
Public Property Get Value() As Boolean
    Value = mValue
End Property
Public Property Let Value(ByVal New_Value As Boolean)
    mValue = New_Value
    PropertyChanged "Value"
    UserControl_Paint
End Property
Public Property Get HandPointer() As Boolean
    HandPointer = mHandPointer
End Property
Public Property Let HandPointer(ByVal New_HandPointer As Boolean)
    mHandPointer = New_HandPointer
    PropertyChanged "HandPointer"
    UserControl_Paint
End Property
Public Property Get Picture() As Picture
    Set Picture = mPicture
End Property
Public Property Set Picture(ByVal New_Picture As Picture)
    Set mPicture = New_Picture
    PropertyChanged "Picture"
    UserControl_Paint
End Property
Public Property Get PictureGray() As Boolean
    PictureGray = mPictureGray
End Property
Public Property Let PictureGray(ByVal New_PictureGray As Boolean)
    mPictureGray = New_PictureGray
    PropertyChanged "PictureGray"
    UserControl_Paint
End Property
'............................................................
'............................................................
Public Property Get Enabled() As Boolean
    Enabled = UserControl.Enabled
End Property
Public Property Let Enabled(ByVal New_Enabled As Boolean)
    UserControl.Enabled = New_Enabled
    PropertyChanged "Enabled"
    UserControl_Paint
End Property
Public Property Get Font() As Font
    Set Font = UserControl.Font
End Property
Public Property Set Font(ByVal New_Font As Font)
    Set UserControl.Font = New_Font
    PropertyChanged "Font"
    UserControl_Paint
End Property
Public Property Get MousePointer() As MousePointerConstants
    MousePointer = UserControl.MousePointer
End Property
Public Property Let MousePointer(ByVal New_MousePointer As MousePointerConstants)
    UserControl.MousePointer() = New_MousePointer
    PropertyChanged "MousePointer"
    UserControl_Paint
End Property
Public Property Get MouseIcon() As Picture
    Set MouseIcon = UserControl.MouseIcon
End Property
Public Property Set MouseIcon(ByVal New_MouseIcon As Picture)
    Set UserControl.MouseIcon() = New_MouseIcon
    PropertyChanged "MouseIcon"
    UserControl_Paint
End Property
'............................................................
'>> End Properties
'............................................................

'............................................................
'>> Convert Color's >> Red,Green,Blue To VB Color's
'............................................................
Private Sub ConvertRGB(ByVal color As Long, R, G, B As Long)
    TranslateColor color, 0, color
    R = color And vbRed
    G = (color And vbGreen) / 256
    B = (color And vbBlue) / 65536
End Sub
'............................................................
'>> Start UserControl
'............................................................
Private Sub UserControl_Click()
    '>> Start The Button Pressed
    If Me.ButtonType = CheckBox Then mValue = MouseDown = False
    UserControl_Paint
    RaiseEvent Click
End Sub
Private Sub UserControl_DblClick()
    '>> Start The Button Pressed Too
    MouseDown = True
    UserControl_Paint
    RaiseEvent DblClick
End Sub
Private Sub UserControl_GotFocus()
    '>> Show FocusRect If Click Button
    mFocused = True
    UserControl_Paint
End Sub
Private Sub UserControl_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 32 Or KeyCode = 13 Then                   '>> Space Or '>> Enter
        MouseDown = True
        UserControl_Paint
    End If
    RaiseEvent KeyDown(KeyCode, Shift)
End Sub
Private Sub UserControl_KeyPress(KeyAscii As Integer)
    RaiseEvent KeyPress(KeyAscii)
End Sub
Private Sub UserControl_KeyUp(KeyCode As Integer, Shift As Integer)
    If MouseDown = True Then
        MouseDown = False
        UserControl_Paint
        '>> Return Button To Original Shape If ButtonType >> CheckBox
        If KeyCode = vbKeyReturn Then UserControl_MouseDown 0, 0, 0, 0
    End If
    RaiseEvent KeyUp(KeyCode, Shift)
End Sub
Private Sub UserControl_LostFocus()
    '>> Visible FocusRect If Clicked Another Button
    mFocused = False
    UserControl_Paint
End Sub
Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    '>> Start The Button Pressed
    MouseDown = True
    UserControl_Paint
    RaiseEvent MouseDown(Button, Shift, x, y)
End Sub
Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    Dim PT               As POINTAPI
    Dim Hovered          As Boolean                         '>> False Or Ture
    With UserControl
        GetCursorPos PT
        ScreenToClient .hwnd, PT
        '>> We Don't Need To Check Postion Mouse
        If Not UserControl.Ambient.UserMode Then Exit Sub
        ' See If The Mouse Is Over The Control
        If (PT.x < 0) Or (PT.y < 0) Or (PT.x > .ScaleWidth) Or (PT.y > .ScaleHeight) Then
            Hovered = False                                '>> Mouse Is Leave Of Button
            ReleaseCapture
        Else
            Hovered = True                                 '>> Mouse Over Button
            SetCapture .hwnd
        End If
        ' Redraw The Control If Necessary
        If MouseMove <> Hovered Then
            MouseMove = Hovered
            MouseDown = False
            UserControl_Paint
        End If
    End With
    RaiseEvent MouseMove(Button, Shift, x, y)
End Sub
Private Sub UserControl_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    If GetCapture() <> UserControl.hwnd Then SetCapture UserControl.hwnd
    Dim Pressed          As Boolean
    ' Raise The Click Event If The Button Is Currently Pressed
    If Pressed Then RaiseEvent Click
    Pressed = MouseDown
    ' Stop The Button Pressed
    MouseDown = False
    UserControl_Paint
    RaiseEvent MouseUp(Button, Shift, x, y)
End Sub
Private Sub UserControl_InitProperties()
    'On Local Error Resume Next
    UserControl.Width = 1200
    UserControl.Height = 500

    mButtonShape = Rectangle
    mButtonStyle = Visual
    mButtonStyleColors = SingleColor
    mButtonTheme = NoTheme
    mButtonType = Button
    mCaptionAlignment = CenterCaption
    mCaptionStyle = Normal
    mCaptionEffect = Default
    mDropDown = None
    mPictureAlignment = CenterPicture

    mBackColor = vbButtonFace
    mBackColorPressed = vbButtonFace
    mBackColorHover = vbButtonFace

    'mBorderColor = vbBlack
    'mBorderColorHover = vbBlack
    'mBorderColorPressed = vbBlack

    mForeColor = vbBlack
    mForeColorPressed = vbRed
    mForeColorHover = vbBlue
    mEffectColor = vbWhite

    mCaption = Ambient.DisplayName
    mFocusRect = True
    mValue = False
    mHandPointer = False
    Set mPicture = Nothing
    mPictureGray = False
    UserControl.Enabled = True
    UserControl.Font = "Tahoma"
    UserControl_Paint
End Sub
Private Sub UserControl_OLECompleteDrag(Effect As Long)
    RaiseEvent OLECompleteDrag(Effect)
End Sub
Private Sub UserControl_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, y As Single)
    RaiseEvent OLEDragDrop(Data, Effect, Button, Shift, x, y)
End Sub
Private Sub UserControl_OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, y As Single, State As Integer)
    RaiseEvent OLEDragOver(Data, Effect, Button, Shift, x, y, State)
End Sub
Private Sub UserControl_OLEGiveFeedback(Effect As Long, DefaultCursors As Boolean)
    RaiseEvent OLEGiveFeedback(Effect, DefaultCursors)
End Sub
Private Sub UserControl_OLESetData(Data As DataObject, DataFormat As Integer)
    RaiseEvent OLESetData(Data, DataFormat)
End Sub
Private Sub UserControl_OLEStartDrag(Data As DataObject, AllowedEffects As Long)
    RaiseEvent OLEStartDrag(Data, AllowedEffects)
End Sub
Private Sub UserControl_Paint()
    'On Local Error Resume Next
    With UserControl
        .AutoRedraw = True
        .ScaleMode = 3
        .Cls
        '............................................................
        '>> Width = Height To Nice Show Border's.
        '............................................................
        If .Width < 375 Then .Width = 375
        If .Height < 250 Then .Height = 250
        If Not mButtonShape = Rectangle Then
            If Not mButtonShape = RoundedRectangle Then
                If .Width > .Height Then .Height = .Width Else .Height = .Width
            End If
        End If
        '............................................................
        '>> Change MousePointer To HandCursor
        '............................................................
        If MouseDown Then
            If mFocused And mHandPointer Then SetCursor LoadCursor(0, CURSOR_HAND)
        ElseIf MouseMove Then
            If mHandPointer Then SetCursor LoadCursor(0, CURSOR_HAND)
        Else
            If mFocused And mHandPointer Then SetCursor LoadCursor(0, CURSOR_HAND)
        End If
        '............................................................
        '>> Use Value For Viwe CheckBox(ButtonPressed) At TimeShow
        '............................................................
        Select Case mButtonType
            Case Is = CheckBox
                If mValue Then MouseDown = True
        End Select
        '............................................................
        '>> Change BackColor When Mouse Hovered Or Pressed Or Off
        '............................................................
        Dim BkRed(0 To 1), BkGreen(0 To 1), BkBlue(0 To 1) As Long
        Dim vert(1) As TRIVERTEX, GRect As GRADIENT_RECT
        If MouseDown Then
            ConvertRGB mBackColor, BkRed(0), BkGreen(0), BkBlue(0)
            ConvertRGB mBackColorPressed, BkRed(1), BkGreen(1), BkBlue(1)
        ElseIf MouseMove Then
            ConvertRGB mBackColor, BkRed(0), BkGreen(0), BkBlue(0)
            ConvertRGB mBackColorHover, BkRed(1), BkGreen(1), BkBlue(1)
        Else
            ConvertRGB mBackColor, BkRed(0), BkGreen(0), BkBlue(0)
            ConvertRGB mBackColorPressed, BkRed(1), BkGreen(1), BkBlue(1)
        End If
        vert(0).Red = Val("&H" & Hex(BkRed(0)) & "00"): vert(0).Green = Val("&H" & Hex(BkGreen(0)) & "00"): vert(0).Blue = Val("&H" & Hex(BkBlue(0)) & "00"): vert(0).Alpha = 0&
        vert(1).Red = Val("&H" & Hex(BkRed(1)) & "00"): vert(1).Green = Val("&H" & Hex(BkGreen(1)) & "00"): vert(1).Blue = Val("&H" & Hex(BkBlue(1)) & "00"): vert(1).Alpha = 0&
        GRect.UpperLeft = 1: GRect.LowerRight = 0
        '............................................................
        '>> ButtonStyleColors,Transparent,SingleColour
        '>> GradientHorizontalFill,VerticalGradientFill
        '>> SwapHorizontalFill,SwapVerticalFill,GradientTubeCenter_H
        '>> ,GradientTubeTopBottom_H,GradientTubeCenter_V
        '>> GradientTubeTopBottom_V
        '............................................................
        Select Case mButtonStyleColors
            Case Is = TRANSPARENT
                .BackStyle = 0
            Case Is = SingleColor
                .BackStyle = 1
                If MouseDown Then
                    .BackColor = mBackColorPressed
                Else
                    If MouseMove Then
                        .BackColor = mBackColorHover
                    Else
                        .BackColor = mBackColor
                    End If
                End If
            Case Is = Gradient_H
                .BackStyle = 1
                vert(0).x = 0: vert(0).y = .ScaleHeight
                vert(1).x = .ScaleWidth: vert(1).y = 0
                GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_H
            Case Is = Gradient_V
                .BackStyle = 1
                vert(0).x = 0: vert(0).y = .ScaleHeight
                vert(1).x = .ScaleWidth: vert(1).y = 0
                GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_V
            Case Is = TubeCenter_H
                .BackStyle = 1
                vert(0).x = .ScaleWidth: vert(0).y = 0
                vert(1).x = 0: vert(1).y = .ScaleHeight / 2
                GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_V
                vert(0).x = 0: vert(0).y = .ScaleHeight
                vert(1).x = .ScaleWidth: vert(1).y = .ScaleHeight / 2
                GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_V
            Case Is = TubeTopBottom_H
                .BackStyle = 1
                vert(0).x = 0: vert(0).y = .ScaleHeight / 2
                vert(1).x = .ScaleWidth: vert(1).y = 0
                GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_V
                vert(0).x = 0: vert(0).y = .ScaleHeight / 2
                vert(1).x = .ScaleWidth: vert(1).y = .ScaleHeight
                GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_V
            Case Is = TubeCenter_V
                .BackStyle = 1
                vert(0).x = 0: vert(0).y = 0
                vert(1).x = .ScaleWidth / 2: vert(1).y = .ScaleHeight
                GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_H
                vert(0).x = .ScaleWidth: vert(0).y = .ScaleHeight
                vert(1).x = .ScaleWidth / 2: vert(1).y = 0
                GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_H
            Case Is = TubeTopBottom_V
                .BackStyle = 1
                vert(0).x = .ScaleWidth / 2: vert(0).y = 0
                vert(1).x = 0: vert(1).y = .ScaleHeight
                GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_H
                vert(0).x = .ScaleWidth / 2: vert(0).y = .ScaleHeight
                vert(1).x = .ScaleWidth: vert(1).y = 0
                GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_H
        End Select
        '.............................................................
        '>> ButtonStyle,Visual, Flat,OverFlat,Java,XpOffice,WinXp
        '>> Vista,Glass
        '>> Set BorderColors To ButtonStyle At Hover,Press,Off
        '.............................................................
        Select Case mButtonStyle
            Case Is = Visual
                mBorderColor = vb3DDKShadow
                mBorderColorHover = vb3DDKShadow
                mBorderColorPressed = vb3DHighlight
            Case Is = Flat
                mBorderColor = vb3DDKShadow
                mBorderColorHover = vb3DDKShadow
                mBorderColorPressed = vb3DHighlight
            Case Is = OverFlat
                mBorderColor = mBackColor    '>> Visible BorderColor At RunTime
                mBorderColorHover = vb3DDKShadow
                mBorderColorPressed = vb3DHighlight
            Case Is = Java
                mBorderColor = vbButtonShadow
                mBorderColorHover = vbButtonShadow
                mBorderColorPressed = vbButtonShadow
            Case Is = XPOffice
                mBorderColor = vbButtonFace
                mBorderColorHover = vbBlack
                mBorderColorPressed = vbBlack
                '............................................................
                '>> Change BackColor XpOffice When Mouse Hovered,Pressed,Off
                '............................................................
                If Not mButtonStyleColors = TRANSPARENT Then
                    If MouseDown Then
                        ConvertRGB &HA57F71, BkRed(0), BkGreen(0), BkBlue(0)
                        ConvertRGB mBackColorPressed, BkRed(1), BkGreen(1), BkBlue(1)
                    ElseIf MouseMove Then
                        ConvertRGB &HAC9891, BkRed(0), BkGreen(0), BkBlue(0)
                        ConvertRGB mBackColorHover, BkRed(1), BkGreen(1), BkBlue(1)
                    Else
                        ConvertRGB mBackColor, BkRed(0), BkGreen(0), BkBlue(0)
                        ConvertRGB mBackColor, BkRed(1), BkGreen(1), BkBlue(1)
                    End If
                    vert(0).Red = Val("&H" & Hex(BkRed(0)) & "00"): vert(0).Green = Val("&H" & Hex(BkGreen(0)) & "00"): vert(0).Blue = Val("&H" & Hex(BkBlue(0)) & "00"): vert(0).Alpha = 0&
                    vert(1).Red = Val("&H" & Hex(BkRed(1)) & "00"): vert(1).Green = Val("&H" & Hex(BkGreen(1)) & "00"): vert(1).Blue = Val("&H" & Hex(BkBlue(1)) & "00"): vert(1).Alpha = 0&
                    GRect.UpperLeft = 1: GRect.LowerRight = 0
                    vert(0).x = 0: vert(0).y = .ScaleHeight
                    vert(1).x = .ScaleWidth: vert(1).y = 0
                    GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_V
                End If
            Case Is = WinXp
                mBorderColor = vbBlack
                mBorderColorHover = vbBlack
                mBorderColorPressed = vbBlack
                '............................................................
                '>> Change BackColor WinXp When Mouse Hovered,Pressed,Off
                '............................................................
                If Not mButtonStyleColors = TRANSPARENT Then
                    If MouseDown Then
                        ConvertRGB mBackColor, BkRed(0), BkGreen(0), BkBlue(0)
                        ConvertRGB &HE0E6E6, BkRed(1), BkGreen(1), BkBlue(1)
                    ElseIf .Enabled Then
                        ConvertRGB mBackColor, BkRed(0), BkGreen(0), BkBlue(0)
                        ConvertRGB Me.BackColorPressed, BkRed(1), BkGreen(1), BkBlue(1)
                    Else
                        ConvertRGB &HDBE7E7, BkRed(0), BkGreen(0), BkBlue(0)
                        ConvertRGB &HDBE7E7, BkRed(1), BkGreen(1), BkBlue(1)
                        mBorderColor = &H8DABAB
                    End If
                    vert(0).Red = Val("&H" & Hex(BkRed(0)) & "00"): vert(0).Green = Val("&H" & Hex(BkGreen(0)) & "00"): vert(0).Blue = Val("&H" & Hex(BkBlue(0)) & "00"): vert(0).Alpha = 0&
                    vert(1).Red = Val("&H" & Hex(BkRed(1)) & "00"): vert(1).Green = Val("&H" & Hex(BkGreen(1)) & "00"): vert(1).Blue = Val("&H" & Hex(BkBlue(1)) & "00"): vert(1).Alpha = 0&
                    GRect.UpperLeft = 1: GRect.LowerRight = 0
                    vert(0).x = 0: vert(0).y = .ScaleHeight
                    vert(1).x = .ScaleWidth: vert(1).y = 0
                    GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_V
                End If
            Case Is = Vista
                mBorderColor = &H8F8F8E
                mBorderColorHover = &HB17F3C
                mBorderColorPressed = &H5C411D
                '............................................................
                '>> Change BackColor Vista When Mouse Hovered,Pressed,Off
                '............................................................
                If Me.ButtonStyle = Vista And Not Me.ButtonStyleColors = TRANSPARENT Then
                    If MouseDown Then
                        ConvertRGB &HF8ECD5, BkRed(1), BkGreen(1), BkBlue(1)
                        ConvertRGB mBackColorPressed, BkRed(0), BkGreen(0), BkBlue(0)
                    ElseIf MouseMove Then
                        ConvertRGB &HFEFCF7, BkRed(1), BkGreen(1), BkBlue(1)
                        ConvertRGB mBackColorHover, BkRed(0), BkGreen(0), BkBlue(0)
                    ElseIf .Enabled Then
                        ConvertRGB &HEFEFEF, BkRed(1), BkGreen(1), BkBlue(1)
                        ConvertRGB mBackColor, BkRed(0), BkGreen(0), BkBlue(0)
                    Else
                        ConvertRGB &HF4F4F4, BkRed(1), BkGreen(1), BkBlue(1)
                        ConvertRGB &HF0F0F0, BkRed(0), BkGreen(0), BkBlue(0)
                        mBorderColor = &HB5B2AD
                    End If
                    vert(0).Red = Val("&H" & Hex(BkRed(0)) & "00"): vert(0).Green = Val("&H" & Hex(BkGreen(0)) & "00"): vert(0).Blue = Val("&H" & Hex(BkBlue(0)) & "00"): vert(0).Alpha = 0&
                    vert(1).Red = Val("&H" & Hex(BkRed(1)) & "00"): vert(1).Green = Val("&H" & Hex(BkGreen(1)) & "00"): vert(1).Blue = Val("&H" & Hex(BkBlue(1)) & "00"): vert(1).Alpha = 0&
                    GRect.UpperLeft = 1: GRect.LowerRight = 0
                    If mButtonShape = Top_Triangle Or mButtonShape = Down_Triangle _
                            Or mButtonShape = top_Arrow Or mButtonShape = Down_Arrow Then
                        vert(0).x = .ScaleWidth / 1.5: vert(0).y = 0
                        vert(1).x = 0: vert(1).y = .ScaleHeight
                        GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_H
                        vert(0).x = .ScaleWidth / 2: vert(0).y = .ScaleHeight
                        vert(1).x = .ScaleWidth + 25: vert(1).y = 0
                        GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_H
                    Else
                        vert(0).x = 0: vert(0).y = .ScaleHeight / 1.5
                        vert(1).x = .ScaleWidth: vert(1).y = 0
                        GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_V
                        vert(0).x = 0: vert(0).y = .ScaleHeight / 2
                        vert(1).x = .ScaleWidth: vert(1).y = .ScaleHeight + 25
                        GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_V
                    End If
                End If
            Case Is = Glass
                mBorderColor = mBackColor
                mBorderColorHover = mBackColorHover
                mBorderColorPressed = mBackColorPressed
                '............................................................
                '>> Change BackColor Glass When Mouse Hovered,Pressed,Off
                '............................................................
                If Not mButtonStyleColors = TRANSPARENT Then
                    If MouseDown Then
                        ConvertRGB vbWhite, BkRed(1), BkGreen(1), BkBlue(1)
                        ConvertRGB mBackColorPressed, BkRed(0), BkGreen(0), BkBlue(0)
                    ElseIf MouseMove Then
                        ConvertRGB vbWhite, BkRed(1), BkGreen(1), BkBlue(1)
                        ConvertRGB mBackColorHover, BkRed(0), BkGreen(0), BkBlue(0)
                    ElseIf .Enabled Then
                        ConvertRGB vbWhite, BkRed(1), BkGreen(1), BkBlue(1)
                        ConvertRGB mBackColor, BkRed(0), BkGreen(0), BkBlue(0)
                    Else
                        ConvertRGB vbWhite, BkRed(1), BkGreen(1), BkBlue(1)
                        ConvertRGB &HA4B6B7, BkRed(0), BkGreen(0), BkBlue(0)
                        mBorderColor = &HA4B6B7
                    End If
                    vert(0).Red = Val("&H" & Hex(BkRed(0)) & "00"): vert(0).Green = Val("&H" & Hex(BkGreen(0)) & "00"): vert(0).Blue = Val("&H" & Hex(BkBlue(0)) & "00"): vert(0).Alpha = 0&
                    vert(1).Red = Val("&H" & Hex(BkRed(1)) & "00"): vert(1).Green = Val("&H" & Hex(BkGreen(1)) & "00"): vert(1).Blue = Val("&H" & Hex(BkBlue(1)) & "00"): vert(1).Alpha = 0&
                    GRect.UpperLeft = 1: GRect.LowerRight = 0
                    If mButtonShape = Top_Triangle Or mButtonShape = Down_Triangle _
                            Or mButtonShape = top_Arrow Or mButtonShape = Down_Arrow Then
                        vert(0).x = .ScaleWidth: vert(0).y = 0
                        vert(1).x = -.ScaleWidth / 6: vert(1).y = .ScaleHeight
                        GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_H
                        vert(0).x = .ScaleWidth / 2: vert(0).y = .ScaleHeight
                        vert(1).x = .ScaleWidth + .ScaleWidth / 3: vert(1).y = 0
                        GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_H
                    Else
                        vert(0).x = 0: vert(0).y = .ScaleHeight
                        vert(1).x = .ScaleWidth: vert(1).y = -.ScaleHeight / 6
                        GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_V
                        vert(0).x = 0: vert(0).y = .ScaleHeight / 2
                        vert(1).x = .ScaleWidth: vert(1).y = .ScaleHeight + .ScaleHeight / 3
                        GradientFill .hdc, vert(0), 2, GRect, 1, GRADIENT_FILL_RECT_V
                    End If
                End If
        End Select
        '............................................................
        '>> Get Postion Picture
        '............................................................
        If mPicture Is Nothing Then
            PicturePos(1).x = 0
            PicturePos(1).y = 0
        Else
            PicturePos(1).x = ScaleX(mPicture.Width, vbHimetric, vbPixels)
            PicturePos(1).y = ScaleY(mPicture.Height, vbHimetric, vbPixels)
            '............................................................
            '>> PictureAlignment,Top PictureLeft Picture,Center Picture
            '>> Right Picture,Bottom Picture
            '............................................................
            Select Case mPictureAlignment
                Case Is = TopPicture
                    PicturePos(0).x = (.ScaleWidth - PicturePos(1).x) / 2
                    PicturePos(0).y = (.ScaleHeight - PicturePos(1).y) / .ScaleHeight + 4
                Case Is = LeftPicture
                    PicturePos(0).x = (.ScaleWidth - PicturePos(1).x) / .ScaleWidth + 4
                    PicturePos(0).y = (.ScaleHeight - PicturePos(1).y) / 2
                Case Is = CenterPicture
                    PicturePos(0).x = (.ScaleWidth - PicturePos(1).x) / 2
                    PicturePos(0).y = (.ScaleHeight - PicturePos(1).y) / 2
                Case Is = RightPicture
                    PicturePos(0).x = (.ScaleWidth - PicturePos(1).x) - 5
                    PicturePos(0).y = (.ScaleHeight - PicturePos(1).y) / 2
                Case Is = BottomPicture
                    PicturePos(0).x = (.ScaleWidth - PicturePos(1).x) / 2
                    PicturePos(0).y = (.ScaleHeight - PicturePos(1).y) - 5
            End Select
            '............................................................
            '>> Moving The Picture When Mouse Hovered Or Pressed
            '............................................................
            If Enabled = True Then
                Dim GrPic As POINTAPI
                Dim Gray As Long
                If MouseDown Then
                    .PaintPicture mPicture, PicturePos(0).x + 1, PicturePos(0).y + 1    '>> +1 Pixel To Top And Right
                ElseIf MouseMove Then
                    .PaintPicture mPicture, PicturePos(0).x, PicturePos(0).y
                    '>> If mButtonStyle = XPOffice Then -1 Pixel About Postion Picture When Mouse Hovered
                    If mButtonStyle = XPOffice Then .PaintPicture mPicture, PicturePos(0).x - 1, PicturePos(0).y - 1
                Else
                    .PaintPicture mPicture, PicturePos(0).x, PicturePos(0).y
                    '>> Add Little Of Code's To Draw GrayScale Picture.
                    If mPictureGray = True Then
                        For GrPic.x = PicturePos(0).x To PicturePos(0).x + PicturePos(1).x
                            For GrPic.y = PicturePos(0).y To PicturePos(0).y + PicturePos(1).y
                                Gray = 255 And (GetPixel(.hdc, GrPic.x, GrPic.y))
                                'Gray = vbRed And (GetPixel(.hDC, GrPic.X, GrPic.Y))
                                If GetPixel(.hdc, GrPic.x, GrPic.y) <> mBackColor Then
                                    SetPixel hdc, GrPic.x, GrPic.y, RGB(Gray, Gray, Gray)
                                End If
                            Next GrPic.y
                        Next GrPic.x
                    End If
                End If
            Else                                               '>> If Enabled = False Then
                '............................................................
                '>> Converting Picture Colour's To Black Color If Button
                '>> Disabled
                '............................................................
                .PaintPicture mPicture, PicturePos(0).x, PicturePos(0).y
                For GrPic.x = PicturePos(0).x To PicturePos(0).x + PicturePos(1).x
                    For GrPic.y = PicturePos(0).y To PicturePos(0).y + PicturePos(1).y
                        Gray = 255 And (GetPixel(.hdc, GrPic.x, GrPic.y)) / 65536
                        If GetPixel(.hdc, GrPic.x, GrPic.y) <> mBackColor Then
                            SetPixel hdc, GrPic.x, GrPic.y, RGB(Gray, Gray, Gray)
                        End If
                    Next GrPic.y
                Next GrPic.x
            End If
        End If
        '............................................................
        '>> CaptionAlignment,Get Size And Postion Text,Top Text
        '>>Left Text,Center Text,Right Text,Bottom Text
        '............................................................
        If Len(mCaption) < 0 Then Exit Sub
        Select Case mCaptionAlignment
            Case Is = TopCaption
                GetTextExtentPoint32 .hdc, mCaption, Len(mCaption), CaptionPos(1)
                CaptionPos(0).x = (.ScaleWidth - CaptionPos(1).x) / 2
                CaptionPos(0).y = (.ScaleHeight - CaptionPos(1).y) / .ScaleHeight + 5
            Case Is = LeftCaption
                GetTextExtentPoint32 .hdc, mCaption, Len(mCaption), CaptionPos(1)
                CaptionPos(0).x = (.ScaleWidth - CaptionPos(1).x) / .ScaleWidth + 5
                CaptionPos(0).y = (.ScaleHeight - CaptionPos(1).y) / 2
            Case Is = CenterCaption
                GetTextExtentPoint32 .hdc, mCaption, Len(mCaption), CaptionPos(1)
                CaptionPos(0).x = (.ScaleWidth - CaptionPos(1).x) / 2
                CaptionPos(0).y = (.ScaleHeight - CaptionPos(1).y) / 2
            Case Is = RightCaption
                GetTextExtentPoint32 .hdc, mCaption, Len(mCaption), CaptionPos(1)
                CaptionPos(0).x = (.ScaleWidth - CaptionPos(1).x) - 5
                CaptionPos(0).y = (.ScaleHeight - CaptionPos(1).y) / 2
            Case Is = BottomCaption
                GetTextExtentPoint32 .hdc, mCaption, Len(mCaption), CaptionPos(1)
                CaptionPos(0).x = (.ScaleWidth - CaptionPos(1).x) / 2
                CaptionPos(0).y = (.ScaleHeight - CaptionPos(1).y) - 5
        End Select
        '............................................................
        '>> CaptionEffect,Default,Raised,Sunken,Outline
        '............................................................
        Dim EFF          As POINTAPI
        If Enabled = True Then
            Select Case mCaptionEffect
                Case Is = Default
                    If MouseDown Then
                        .ForeColor = mForeColorPressed
                        TextOutA .hdc, CaptionPos(0).x + 1, CaptionPos(0).y + 1, mCaption, Len(mCaption)
                    ElseIf MouseMove Then
                        .ForeColor = mForeColorHover
                        TextOutA .hdc, CaptionPos(0).x, CaptionPos(0).y, mCaption, Len(mCaption)
                    Else
                        .ForeColor = mForeColor
                        TextOutA .hdc, CaptionPos(0).x, CaptionPos(0).y, mCaption, Len(mCaption)
                    End If
                Case Is = Raised
                    EFF.x = -1                             '>> -1 Pixel From Down To Top
                    EFF.y = -1                             '>> -1 Pixel From Right To Left
                    If MouseDown Then
                        .ForeColor = mEffectColor          '>> Vbwhite
                        TextOutW .hdc, CaptionPos(0).x + EFF.x + 1, CaptionPos(0).y + EFF.y + 1, mCaption, Len(mCaption)
                        .ForeColor = mForeColorPressed       '>> mForeColorPressed If You Like.
                        TextOutA .hdc, CaptionPos(0).x + 1, CaptionPos(0).y + 1, mCaption, Len(mCaption)
                    ElseIf MouseMove Then
                        .ForeColor = mEffectColor          '>> Vbwhite
                        TextOutW .hdc, CaptionPos(0).x + EFF.x, CaptionPos(0).y + EFF.y, mCaption, Len(mCaption)
                        .ForeColor = mForeColorHover
                        TextOutA .hdc, CaptionPos(0).x, CaptionPos(0).y, mCaption, Len(mCaption)
                    Else
                        .ForeColor = mEffectColor
                        TextOutW .hdc, CaptionPos(0).x + EFF.x, CaptionPos(0).y + EFF.y, mCaption, Len(mCaption)
                        .ForeColor = mForeColor
                        TextOutA .hdc, CaptionPos(0).x, CaptionPos(0).y, mCaption, Len(mCaption)
                    End If
                Case Is = Sunken
                    EFF.x = 1                              '>> +1 Pixel From Top To Down
                    EFF.y = 1                              '>> +1 Pixel From Left To Right
                    If MouseDown Then
                        .ForeColor = mEffectColor          '>> Vbwhite
                        TextOutW .hdc, CaptionPos(0).x + EFF.x + 1, CaptionPos(0).y + EFF.y + 1, mCaption, Len(mCaption)
                        .ForeColor = mForeColorPressed       '>> mForeColorPressed
                        TextOutA .hdc, CaptionPos(0).x + 1, CaptionPos(0).y + 1, mCaption, Len(mCaption)
                    ElseIf MouseMove Then
                        .ForeColor = mEffectColor          '>> Vbwhite
                        TextOutW .hdc, CaptionPos(0).x + EFF.x, CaptionPos(0).y + EFF.y, mCaption, Len(mCaption)
                        .ForeColor = mForeColorHover
                        TextOutA .hdc, CaptionPos(0).x, CaptionPos(0).y, mCaption, Len(mCaption)
                    Else
                        .ForeColor = mEffectColor
                        TextOutW .hdc, CaptionPos(0).x + EFF.x, CaptionPos(0).y + EFF.y, mCaption, Len(mCaption)
                        .ForeColor = mForeColor
                        TextOutA .hdc, CaptionPos(0).x, CaptionPos(0).y, mCaption, Len(mCaption)
                    End If
                Case Is = Outline
                    Dim Out As POINTAPI
                    For Out.x = -1 To 1                    '>> -1 Pixel And +1 Pixel From Top To Down
                        For Out.y = -1 To 1                '>> -1 Pixel And +1 Pixel From Left To Right
                            If MouseDown Then
                                .ForeColor = mEffectColor
                                TextOutW .hdc, CaptionPos(0).x + Out.x + 1, CaptionPos(0).y + Out.y + 1, mCaption, Len(mCaption)
                                .ForeColor = mForeColorPressed
                                TextOutA .hdc, CaptionPos(0).x + 1, CaptionPos(0).y + 1, mCaption, Len(mCaption)
                            ElseIf MouseMove Then
                                .ForeColor = mEffectColor
                                TextOutW .hdc, CaptionPos(0).x + Out.x, CaptionPos(0).y + Out.y, mCaption, Len(mCaption)
                                .ForeColor = mForeColorHover
                                TextOutA .hdc, CaptionPos(0).x, CaptionPos(0).y, mCaption, Len(mCaption)
                            Else
                                .ForeColor = mEffectColor
                                TextOutW .hdc, CaptionPos(0).x + Out.x, CaptionPos(0).y + Out.y, mCaption, Len(mCaption)
                                .ForeColor = mForeColor
                                TextOutA .hdc, CaptionPos(0).x, CaptionPos(0).y, mCaption, Len(mCaption)
                            End If
                        Next Out.y
                    Next Out.x
            End Select
        Else    '>> If Enabled = False Then >> Draw Disabled Text Sunken Look
            If mButtonStyle = Java Or mButtonStyle = WinXp Or _
                    mButtonStyle = Vista Or mButtonStyle = Glass Then
                .ForeColor = vb3DShadow
                TextOutA .hdc, CaptionPos(0).x, CaptionPos(0).y, mCaption, Len(mCaption)
            Else    '>> If Enabled = False Then >> Draw Disabled Text Sunken Look
                .ForeColor = vb3DHighlight
                TextOutW .hdc, CaptionPos(0).x + 1, CaptionPos(0).y + 1, mCaption, Len(mCaption)
                .ForeColor = vb3DShadow
                TextOutA .hdc, CaptionPos(0).x, CaptionPos(0).y, mCaption, Len(mCaption)
            End If
        End If
        '............................................................
        '>> Change ForeColor When Mouse Hovered Or Pressed Or Off
        '............................................................
        Dim TotalRed(1), TotalGreen(1), TotalBlue(1) As Long
        Dim R(1), G(1), B(1) As Long
        Dim FrRed, FrGreen, FrBlue As Integer
        Dim Pos(1)       As POINTAPI
        Dim Fore         As POINTAPI
        '............................................................
        '>> CaptionStyle,SingleColour,GradientHorizontalFill
        '>> GradientVerticalFill
        '............................................................
        Select Case mCaptionStyle
            Case Is = Normal                      '>> SingleColour >> MouseOff,MouseMove,MouseDown
                'We Don't Need To Any More Event's Here
                '>> Look To Event's '>> mCaptionEffect = Default
            Case Is = HorizontalFill                       '>> GradientFill Len(Caption)
                If MouseDown Then
                    ConvertRGB mForeColor, R(1), G(1), B(1)
                    ConvertRGB mForeColorPressed, R(0), G(0), B(0)
                ElseIf MouseMove Then
                    ConvertRGB mForeColor, R(1), G(1), B(1)
                    ConvertRGB mForeColorHover, R(0), G(0), B(0)
                Else
                    ConvertRGB mForeColor, R(1), G(1), B(1)
                    ConvertRGB mForeColorPressed, R(0), G(0), B(0)
                End If
                For Fore.x = CaptionPos(0).x To CaptionPos(0).x + CaptionPos(1).x
                    For Fore.y = CaptionPos(0).y To CaptionPos(0).y + CaptionPos(1).y
                        TotalRed(0) = (R(0) - R(1)) / .ScaleWidth * Fore.x
                        TotalGreen(0) = (G(0) - G(1)) / .ScaleWidth * Fore.x
                        TotalBlue(0) = (B(0) - B(1)) / .ScaleWidth * Fore.x
                        FrRed = R(1) + TotalRed(0)
                        FrGreen = G(1) + TotalGreen(0)
                        FrBlue = B(1) + TotalBlue(0)
                        If GetPixel(hdc, Fore.x, Fore.y) = .ForeColor Then
                            'If GetPixel(hdc, Fore.X, Fore.Y) <> .ForeColor Then'>> For Show Len(Caption) Fill
                            SetPixel .hdc, Fore.x, Fore.y, RGB(FrRed, FrGreen, FrBlue)
                            R(1) = R(1) + TotalRed(1)
                            G(1) = G(1) + TotalGreen(1)
                            B(1) = B(1) + TotalBlue(1)
                        End If
                    Next Fore.y
                Next Fore.x
            Case Is = VerticalFill
                If MouseDown Then
                    ConvertRGB mForeColor, R(0), G(0), B(0)
                    ConvertRGB mForeColorPressed, R(1), G(1), B(1)
                ElseIf MouseMove Then
                    ConvertRGB mForeColor, R(0), G(0), B(0)
                    ConvertRGB mForeColorHover, R(1), G(1), B(1)
                Else
                    ConvertRGB mForeColor, R(0), G(0), B(0)
                    ConvertRGB mForeColorPressed, R(1), G(1), B(1)
                End If
                For Fore.x = CaptionPos(0).x To CaptionPos(0).x + CaptionPos(1).x
                    For Fore.y = CaptionPos(0).y To CaptionPos(0).y + CaptionPos(1).y
                        TotalRed(0) = (R(0) - R(1)) / .ScaleHeight * Fore.y
                        TotalGreen(0) = (G(0) - G(1)) / .ScaleHeight * Fore.y
                        TotalBlue(0) = (B(0) - B(1)) / .ScaleHeight * Fore.y
                        FrRed = R(1) + TotalRed(0)
                        FrGreen = G(1) + TotalGreen(0)
                        FrBlue = B(1) + TotalBlue(0)
                        If GetPixel(hdc, Fore.x, Fore.y) = .ForeColor Then
                            SetPixel .hdc, Fore.x, Fore.y, RGB(FrRed, FrGreen, FrBlue)
                            R(1) = R(1) + TotalRed(1)
                            G(1) = G(1) + TotalGreen(1)
                            B(1) = B(1) + TotalBlue(1)
                        End If
                    Next Fore.y
                Next Fore.x
        End Select
        .MaskColor = .BackColor                            '>> Change ButtonStyleColor From Opaque To Transparent
        '............................................................
        '>> Change BorderColor When Mouse Hovered Or Pressed Or Off
        '............................................................
        If MouseDown Then
            .ForeColor = mBorderColorPressed
        ElseIf MouseMove Then
            .ForeColor = mBorderColorHover
        Else
            .ForeColor = mBorderColor
        End If
        '............................................................
        '>> Calling ButtonShape's
        '............................................................
        Select Case mButtonShape
            Case Is = Rectangle: Redraw_Rectangle
            Case Is = RoundedRectangle: Redraw_RoundedRectangle
            Case Is = Round: Redraw_Round
            Case Is = Diamond: Redraw_Diamond
            Case Is = Top_Triangle: Redraw_Top_Triangle
            Case Is = Left_Triangle: Redraw_Left_Triangle
            Case Is = Right_Triangle: Redraw_Right_Triangle
            Case Is = Down_Triangle: Redraw_Down_Triangle
            Case Is = top_Arrow: Redraw_Top_Arrow
            Case Is = Left_Arrow: Redraw_Left_Arrow
            Case Is = Right_Arrow: Redraw_Right_Arrow
            Case Is = Down_Arrow: Redraw_Down_Arrow
        End Select
        '............................................................
        '>> Use GetPixel And SetPixel For Make Point's On FocusRect.
        '............................................................
        If Not mButtonStyle = Java And mFocusRect And mFocused Then
            If Not mButtonStyle = WinXp And mFocusRect And mFocused Then
                If Not mButtonStyle = Vista And mFocusRect And mFocused Then
                    For Fo.x = 3 To .ScaleWidth - 3 Step 2
                        For Fo.y = 3 To .ScaleHeight - 3 Step 2
                            If GetPixel(.hdc, Fo.x, Fo.y) = .ForeColor Then SetPixel .hdc, Fo.x, Fo.y, vbBlack
                        Next Fo.y: Next Fo.x
                    For Fo.x = 2 To .ScaleWidth - 2 Step 2
                        For Fo.y = 2 To .ScaleHeight - 2 Step 2
                            If GetPixel(.hdc, Fo.x, Fo.y) = .ForeColor Then SetPixel .hdc, Fo.x, Fo.y, vbBlack
                        Next Fo.y: Next Fo.x
                End If
            End If
        End If
        '............................................................
        '>> Draw FocusRect Java About The Text.
        '............................................................
        If Len(mCaption) > 0 Then
            If mButtonStyle = Java And mFocusRect And mFocused Then
                .ForeColor = BDR_FOCUSRECT_JAVA
                RoundRect hdc, CaptionPos(1).x + CaptionPos(0).x + 2, CaptionPos(1).y + CaptionPos(0).y + 2, CaptionPos(0).x - 3, CaptionPos(0).y - 2, 0, 0
            End If
        End If
        '............................................................
        '>> DropDown,Left DropDown,Right DropDown
        '............................................................
        Dim flags(1)     As POINTAPI
        Select Case mDropDown
            Case Is = LeftDropDown
                flags(0).x = 2
                flags(0).y = .ScaleHeight / 2 + flags(0).y / .ScaleHeight - 8
            Case Is = RightDropDown
                flags(0).x = .ScaleWidth - 21
                flags(0).y = .ScaleHeight / 2 + flags(0).y / .ScaleHeight - 8
        End Select
        '............................................................
        '>> DropDown >> Left DropDown,Right DropDown
        '............................................................
        If Not mDropDown = None Then                       '>> So If mDropDown=LeftDropDown Or RightDropDown then
            .ForeColor = vbBlack                           '>> mForeColor If You Like.
            'Drwa Chevron
            MoveToEx .hdc, flags(0).x + 6, flags(0).y + 5, flags(1)
            LineTo .hdc, flags(0).x + 9, flags(0).y + 8
            LineTo .hdc, flags(0).x + 13, flags(0).y + 4
            MoveToEx .hdc, flags(0).x + 7, flags(0).y + 5, flags(1)
            LineTo .hdc, flags(0).x + 9, flags(0).y + 7
            LineTo .hdc, flags(0).x + 12, flags(0).y + 4
            MoveToEx .hdc, flags(0).x + 6, flags(0).y + 9, flags(1)
            LineTo .hdc, flags(0).x + 9, flags(0).y + 12
            LineTo .hdc, flags(0).x + 13, flags(0).y + 8
            MoveToEx .hdc, flags(0).x + 7, flags(0).y + 9, flags(1)
            LineTo .hdc, flags(0).x + 9, flags(0).y + 11
            LineTo .hdc, flags(0).x + 12, flags(0).y + 8
        End If
        .MaskPicture = .Image                              '>> Change ButtonStyleColor From Transparent To Opaque When Add Picture.
        .Refresh                                           '>> AutoRedraw=True
    End With
End Sub
Private Sub Redraw_Rectangle()
    Dim hRgn             As Long
    With UserControl
        '>> Rectangle >> Make Rectangle Shape.
        LineTo .hdc, 0, .ScaleHeight - 1
        LineTo .hdc, .ScaleWidth - 1, .ScaleHeight - 1
        LineTo .hdc, .ScaleWidth - 1, 0
        LineTo .hdc, 0, 0
        SetWindowRgn .hwnd, hRgn, False                    '>>Retune Original Shape To Button Without Cutting
        Select Case mButtonStyle
            Case Is = Visual                               '>> Rectangle >> Draw Visual Style.
                If MouseDown Then
                    .ForeColor = BDR_VISUAL
                    MoveToEx .hdc, .ScaleWidth - 1, 0, Lines
                    LineTo .hdc, 0, 0
                    LineTo .hdc, 0, .ScaleHeight - 1
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth - 1, 1, Lines
                    LineTo .hdc, 1, 1
                    LineTo .hdc, 1, .ScaleHeight - 1
                Else
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth - 2, 0, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 2
                    LineTo .hdc, 0, .ScaleHeight - 2
                    .ForeColor = BDR_VISUAL2
                    MoveToEx .hdc, .ScaleWidth - 1, 0, Lines
                    LineTo .hdc, 0, 0
                    LineTo .hdc, 0, .ScaleHeight - 1
                End If
            Case Is = Flat                                 '>> Rectangle >> Draw Flat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth - 1, 0, Lines
                    LineTo .hdc, 0, 0
                    LineTo .hdc, 0, .ScaleHeight - 1
                Else
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth - 1, 0, Lines
                    LineTo .hdc, 0, 0
                    LineTo .hdc, 0, .ScaleHeight - 1
                End If
            Case Is = OverFlat                             '>> Rectangle >> Draw OverFlat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth - 1, 0, Lines
                    LineTo .hdc, 0, 0
                    LineTo .hdc, 0, .ScaleHeight - 1
                ElseIf MouseMove Then
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth - 1, 0, Lines
                    LineTo .hdc, 0, 0
                    LineTo .hdc, 0, .ScaleHeight - 1
                End If
            Case Is = Java                                 '>> Rectangle >> Draw Java Style.
                If .Enabled Then
                    .ForeColor = BDR_JAVA1
                    MoveToEx .hdc, .ScaleWidth - 2, 1, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 2
                    LineTo .hdc, 2, .ScaleHeight - 2
                    .ForeColor = BDR_JAVA2
                    MoveToEx .hdc, .ScaleWidth - 1, 1, Lines
                    LineTo .hdc, 1, 1
                    LineTo .hdc, 1, .ScaleHeight - 1
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight - 1
                    LineTo .hdc, .ScaleWidth - 1, 1
                End If
            Case Is = WinXp                                '>> Rectangle >> Draw WindowsXp Style
                If MouseDown Then
                    .ForeColor = BDR_PRESSED
                    MoveToEx .hdc, 2, .ScaleHeight - 3, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth - 3, 2
                ElseIf MouseMove Then
                    .ForeColor = BDR_GOLDXP_DARK
                    MoveToEx .hdc, .ScaleWidth - 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, 0, .ScaleHeight - 2
                    .ForeColor = BDR_GOLDXP_NORMAL1
                    MoveToEx .hdc, 1, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth - 2, 1
                    .ForeColor = BDR_GOLDXP_NORMAL2
                    MoveToEx .hdc, 2, 2, Lines
                    LineTo .hdc, 2, .ScaleHeight - 3
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight - 4, Lines
                    LineTo .hdc, .ScaleWidth - 3, 2
                    .ForeColor = BDR_GOLDXP_LIGHT1
                    MoveToEx .hdc, 1, 1, Lines
                    LineTo .hdc, .ScaleWidth - 1, 1
                    .ForeColor = BDR_GOLDXP_LIGHT2
                    MoveToEx .hdc, 2, 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, 2
                    '>> Rectangle >> Draw Xp FocusRect.
                ElseIf mButtonStyle = WinXp And mFocusRect And mFocused Then
                    .ForeColor = BDR_BLUEXP_DARK
                    MoveToEx .hdc, .ScaleWidth - 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, 0, .ScaleHeight - 2
                    .ForeColor = BDR_BLUEXP_NORMAL1
                    MoveToEx .hdc, 1, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth - 2, 1
                    .ForeColor = BDR_BLUEXP_NORMAL2
                    MoveToEx .hdc, 2, 2, Lines
                    LineTo .hdc, 2, .ScaleHeight - 3
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight - 4, Lines
                    LineTo .hdc, .ScaleWidth - 3, 2
                    .ForeColor = BDR_BLUEXP_LIGHT1
                    MoveToEx .hdc, 1, 1, Lines
                    LineTo .hdc, .ScaleWidth - 1, 1
                    .ForeColor = BDR_BLUEXP_LIGHT2
                    MoveToEx .hdc, 2, 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, 2
                End If
            Case Is = Vista    '>> Rectangle >> Draw Vista Style.
                If MouseDown Then
                    .ForeColor = BDR_VISTA2
                    MoveToEx .hdc, 1, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth - 2, 1
                    LineTo .hdc, 1, 1
                Else
                    .ForeColor = BDR_VISTA1
                    MoveToEx .hdc, 1, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth - 2, 1
                    LineTo .hdc, 1, 1
                    '>> Rectangle >> Draw Vista FocusRect.
                    If mButtonStyle = Vista And mFocusRect And mFocused Then
                        .ForeColor = BDR_FOCUSRECT_VISTA
                        MoveToEx .hdc, 1, 1, Lines
                        LineTo .hdc, 1, .ScaleHeight - 2
                        LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 2
                        LineTo .hdc, .ScaleWidth - 2, 1
                        LineTo .hdc, 1, 1
                    End If
                End If
        End Select
        '>> Rectangle >> Draw FocusRect.
        If Not mButtonStyle = Java And mFocusRect And mFocused Then
            If Not mButtonStyle = WinXp And mFocusRect And mFocused Then
                If Not mButtonStyle = Vista And mFocusRect And mFocused Then
                    .ForeColor = BDR_FOCUSRECT
                    MoveToEx .hdc, 4, 4, Lines
                    LineTo .hdc, 4, .ScaleHeight - 5
                    LineTo .hdc, .ScaleWidth - 5, .ScaleHeight - 5
                    LineTo .hdc, .ScaleWidth - 5, 4
                    LineTo .hdc, 4, 4
                End If
            End If
        End If
    End With
End Sub
Private Sub Redraw_RoundedRectangle()
    With UserControl
        '>> RoundedRectangle >> Make RoundedRectangle Shape.
        hRgn = CreateRoundRectRgn(0, 0, .ScaleWidth, .ScaleHeight, 15, 15)
        SetWindowRgn .hwnd, hRgn, True
        DeleteObject hRgn

        '>> RoundedRectangle >> Draw RoundedRectangle Shape.
        RoundRect hdc, 0, 0, .ScaleWidth - 1, .ScaleHeight - 1, 16, 16

        Select Case mButtonStyle
            Case Is = Visual                               '>> RoundedRectangle >> Draw Visual Style.
                If MouseDown Then
                    .ForeColor = BDR_VISUAL
                    MoveToEx .hdc, 10, 0, Lines
                    LineTo .hdc, .ScaleWidth - 8, 0
                    Arc .hdc, 17, 17, 0, 0, 10, 0, 0, 10
                    MoveToEx .hdc, 0, 10, Lines
                    LineTo .hdc, 0, .ScaleHeight - 10
                    Arc .hdc, 17, .ScaleHeight - 17, 0, .ScaleHeight - 1, -16, .ScaleHeight - 16, 9, .ScaleHeight
                    Arc .hdc, 16, .ScaleHeight - 16, 0, .ScaleHeight - 2, -16, .ScaleHeight - 16, 8, .ScaleHeight
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, 10, 1, Lines
                    LineTo .hdc, .ScaleWidth - 8, 1
                    Arc .hdc, 17, 17, 1, 1, 10, 1, 1, 10
                    MoveToEx .hdc, 1, 10, Lines
                    LineTo .hdc, 1, .ScaleHeight - 10
                    Arc .hdc, 17, .ScaleHeight - 16, 1, .ScaleHeight - 2, -16, .ScaleHeight - 16, 9, .ScaleHeight - 1
                Else
                    .ForeColor = BDR_VISUAL1
                    RoundRect hdc, 0, 0, .ScaleWidth - 2, .ScaleHeight - 2, 15, 15
                    .ForeColor = BDR_VISUAL2
                    MoveToEx .hdc, 10, 0, Lines
                    LineTo .hdc, .ScaleWidth - 8, 0
                    Arc .hdc, 17, 17, 0, 0, 10, 0, 0, 10
                    MoveToEx .hdc, 0, 10, Lines
                    LineTo .hdc, 0, .ScaleHeight - 10
                    Arc .hdc, 17, .ScaleHeight - 17, 0, .ScaleHeight - 2, -16, .ScaleHeight - 16, 9, .ScaleHeight - 1
                    Arc .hdc, 17, .ScaleHeight - 17, 0, .ScaleHeight - 1, -16, .ScaleHeight - 16, 9, .ScaleHeight - 1
                End If
            Case Is = Flat                                 '>> RoundedRectangle >> Draw Flat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, 10, 0, Lines
                    LineTo .hdc, .ScaleWidth - 8, 0
                    Arc .hdc, 17, 17, 0, 0, 10, 0, 0, 10
                    MoveToEx .hdc, 0, 10, Lines
                    LineTo .hdc, 0, .ScaleHeight - 10
                    Arc .hdc, 17, .ScaleHeight - 17, 0, .ScaleHeight - 1, -16, .ScaleHeight - 16, 9, .ScaleHeight - 1
                Else
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, 10, 0, Lines
                    LineTo .hdc, .ScaleWidth - 8, 0
                    Arc .hdc, 17, 17, 0, 0, 10, 0, 0, 10
                    MoveToEx .hdc, 0, 10, Lines
                    LineTo .hdc, 0, .ScaleHeight - 10
                    Arc .hdc, 17, .ScaleHeight - 17, 0, .ScaleHeight - 1, -16, .ScaleHeight - 16, 9, .ScaleHeight - 1
                End If
            Case Is = OverFlat                             '>> RoundedRectangle >> Draw OverFlat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, 10, 0, Lines
                    LineTo .hdc, .ScaleWidth - 8, 0
                    Arc .hdc, 17, 17, 0, 0, 10, 0, 0, 10
                    MoveToEx .hdc, 0, 10, Lines
                    LineTo .hdc, 0, .ScaleHeight - 10
                    Arc .hdc, 17, .ScaleHeight - 17, 0, .ScaleHeight - 1, -16, .ScaleHeight - 16, 9, .ScaleHeight - 1
                ElseIf MouseMove Then
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, 10, 0, Lines
                    LineTo .hdc, .ScaleWidth - 8, 0
                    Arc .hdc, 17, 17, 0, 0, 10, 0, 0, 10
                    MoveToEx .hdc, 0, 10, Lines
                    LineTo .hdc, 0, .ScaleHeight - 10
                    Arc .hdc, 17, .ScaleHeight - 17, 0, .ScaleHeight - 1, -16, .ScaleHeight - 16, 9, .ScaleHeight - 1
                End If
            Case Is = Java                                 '>> RoundedRectangle >> Draw Java Style.
                If .Enabled Then
                    .ForeColor = BDR_JAVA1
                    RoundRect hdc, 0, 0, .ScaleWidth - 2, .ScaleHeight - 2, 16, 16
                    .ForeColor = BDR_JAVA2
                    RoundRect hdc, 1, 1, .ScaleWidth - 1, .ScaleHeight - 1, 16, 16
                End If
            Case Is = WinXp                                '>> RoundedRectangle >> Draw WindowsXp Style.
                If MouseDown Then
                    .ForeColor = BDR_PRESSED
                    Arc .hdc, .ScaleWidth - 17, .ScaleHeight - 17, .ScaleWidth - 3, .ScaleHeight - 3, .ScaleWidth - 10, .ScaleHeight - 3, .ScaleWidth - 2, .ScaleHeight - 10
                    MoveToEx .hdc, .ScaleWidth - 9, .ScaleHeight - 4, Lines
                    LineTo .hdc, 8, .ScaleHeight - 4
                    MoveToEx .hdc, .ScaleWidth - 4, 4, Lines
                    LineTo .hdc, .ScaleWidth - 4, .ScaleHeight - 9
                ElseIf MouseMove Then
                    .ForeColor = BDR_GOLDXP_DARK
                    Arc .hdc, 16, .ScaleHeight - 17, 1, .ScaleHeight - 2, -17, .ScaleHeight, 8, .ScaleHeight - 1
                    MoveToEx .hdc, .ScaleWidth - 8, .ScaleHeight - 3, Lines
                    LineTo .hdc, 8, .ScaleHeight - 3
                    Arc .hdc, .ScaleWidth - 17, .ScaleHeight - 17, .ScaleWidth - 2, .ScaleHeight - 2, .ScaleWidth - 10, .ScaleHeight - 2, .ScaleWidth - 1, .ScaleHeight - 10
                    .ForeColor = BDR_GOLDXP_NORMAL1
                    Arc .hdc, 17, .ScaleHeight - 18, 1, .ScaleHeight - 3, -18, .ScaleHeight, 10, .ScaleHeight - 1
                    MoveToEx .hdc, 1, 6, Lines
                    LineTo .hdc, 1, .ScaleHeight - 8
                    MoveToEx .hdc, .ScaleWidth - 8, .ScaleHeight - 4, Lines
                    LineTo .hdc, 8, .ScaleHeight - 4
                    Arc .hdc, .ScaleWidth - 17, .ScaleHeight - 17, .ScaleWidth - 3, .ScaleHeight - 3, .ScaleWidth - 10, .ScaleHeight - 2, .ScaleWidth - 1, .ScaleHeight - 10
                    MoveToEx .hdc, .ScaleWidth - 3, 6, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight - 8
                    .ForeColor = BDR_GOLDXP_NORMAL2
                    MoveToEx .hdc, 2, 7, Lines
                    LineTo .hdc, 2, .ScaleHeight - 7
                    MoveToEx .hdc, .ScaleWidth - 4, 7, Lines
                    LineTo .hdc, .ScaleWidth - 4, .ScaleHeight - 7
                    Arc .hdc, 17, 17, 1, 1, 8, 0, 0, 8
                    Arc .hdc, .ScaleWidth - 17, 17, .ScaleWidth - 2, 1, .ScaleWidth - 1, 8, .ScaleWidth - 12, 1
                    Arc .hdc, .ScaleWidth - 17, 17, .ScaleWidth - 3, 2, .ScaleWidth - 1, 8, .ScaleWidth - 12, 1
                    Arc .hdc, 17, 17, 2, 2, 8, 0, 0, 8
                    .ForeColor = BDR_GOLDXP_LIGHT1
                    MoveToEx .hdc, 10, 1, Lines
                    LineTo .hdc, .ScaleWidth - 7, 1
                    .ForeColor = BDR_GOLDXP_LIGHT2
                    MoveToEx .hdc, 10, 2, Lines
                    LineTo .hdc, .ScaleWidth - 8, 2
                    '>> RoundedRectangle >> Draw Xp FocusRect.
                ElseIf mButtonStyle = WinXp And mFocusRect And mFocused Then
                    .ForeColor = BDR_BLUEXP_DARK
                    Arc .hdc, 16, .ScaleHeight - 17, 1, .ScaleHeight - 2, -17, .ScaleHeight, 8, .ScaleHeight - 1
                    MoveToEx .hdc, .ScaleWidth - 8, .ScaleHeight - 3, Lines
                    LineTo .hdc, 8, .ScaleHeight - 3
                    Arc .hdc, .ScaleWidth - 17, .ScaleHeight - 17, .ScaleWidth - 2, .ScaleHeight - 2, .ScaleWidth - 10, .ScaleHeight - 2, .ScaleWidth - 1, .ScaleHeight - 10
                    .ForeColor = BDR_BLUEXP_NORMAL1
                    Arc .hdc, 17, .ScaleHeight - 18, 1, .ScaleHeight - 3, -18, .ScaleHeight, 10, .ScaleHeight
                    MoveToEx .hdc, 1, 6, Lines
                    LineTo .hdc, 1, .ScaleHeight - 8
                    MoveToEx .hdc, .ScaleWidth - 8, .ScaleHeight - 4, Lines
                    LineTo .hdc, 8, .ScaleHeight - 4
                    Arc .hdc, .ScaleWidth - 17, .ScaleHeight - 17, .ScaleWidth - 3, .ScaleHeight - 3, .ScaleWidth - 10, .ScaleHeight - 2, .ScaleWidth - 1, .ScaleHeight - 10
                    MoveToEx .hdc, .ScaleWidth - 3, 6, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight - 8
                    .ForeColor = BDR_BLUEXP_NORMAL2
                    MoveToEx .hdc, 2, 7, Lines
                    LineTo .hdc, 2, .ScaleHeight - 7
                    MoveToEx .hdc, .ScaleWidth - 4, 7, Lines
                    LineTo .hdc, .ScaleWidth - 4, .ScaleHeight - 7
                    Arc .hdc, 17, 17, 1, 1, 8, 0, 0, 8
                    Arc .hdc, .ScaleWidth - 17, 17, .ScaleWidth - 2, 1, .ScaleWidth - 1, 8, .ScaleWidth - 12, 1
                    Arc .hdc, .ScaleWidth - 17, 17, .ScaleWidth - 3, 2, .ScaleWidth - 1, 8, .ScaleWidth - 12, 1
                    Arc .hdc, 17, 17, 2, 2, 8, 0, 0, 8
                    .ForeColor = BDR_BLUEXP_LIGHT1
                    MoveToEx .hdc, 10, 1, Lines
                    LineTo .hdc, .ScaleWidth - 7, 1
                    .ForeColor = BDR_BLUEXP_LIGHT2
                    MoveToEx .hdc, 10, 2, Lines
                    LineTo .hdc, .ScaleWidth - 8, 2
                End If
            Case Is = Vista    '>> RoundedRectangle >> Draw Vista Style.
                If MouseDown Then
                    .ForeColor = BDR_VISTA2
                    RoundRect hdc, 1, 1, .ScaleWidth - 2, .ScaleHeight - 2, 14, 14
                Else
                    .ForeColor = BDR_VISTA1
                    RoundRect hdc, 1, 1, .ScaleWidth - 2, .ScaleHeight - 2, 14, 14
                    '>> RoundedRectangle >> Draw Vista FocusRect.
                    If mButtonStyle = Vista And mFocusRect And mFocused Then
                        .ForeColor = BDR_FOCUSRECT_VISTA
                        RoundRect hdc, 1, 1, .ScaleWidth - 2, .ScaleHeight - 2, 14, 14
                    End If
                End If
        End Select
        '>> RoundedRectangle >> Draw FocusRect.
        If Not mButtonStyle = Java And mFocusRect And mFocused Then
            If Not mButtonStyle = WinXp And mFocusRect And mFocused Then
                If Not mButtonStyle = Vista And mFocusRect And mFocused Then
                    .ForeColor = BDR_FOCUSRECT
                    RoundRect .hdc, 4, 4, .ScaleWidth - 5, .ScaleHeight - 5, 15, 15
                End If
            End If
        End If
    End With
End Sub
Private Sub Redraw_Round()
    With UserControl
        '>> Round >> Make Round Shape.
        'hRgn = CreateRoundRectRgn(0, 0, .ScaleWidth, .ScaleHeight, .ScaleWidth , .ScaleHeight )
        hRgn = CreateEllipticRgn(0, 0, .ScaleWidth, .ScaleHeight)
        SetWindowRgn .hwnd, hRgn, True
        DeleteObject hRgn

        '>> Round >> Draw Round Shape.
        RoundRect hdc, 1, 1, .ScaleWidth - 2, .ScaleHeight - 2, .ScaleWidth - 2, .ScaleHeight - 2

        Select Case mButtonStyle
            Case Is = Visual                               '>> Round >> Draw Visual Style.
                If MouseDown Then
                    .ForeColor = BDR_VISUAL
                    Arc .hdc, .ScaleWidth - 2, .ScaleHeight - 2, 1, 1, .ScaleWidth - 2, 1, 1, .ScaleHeight - 2
                    .ForeColor = BDR_VISUAL1
                    Arc .hdc, .ScaleWidth - 3, .ScaleHeight - 3, 2, 2, .ScaleWidth - 3, 2, 2, .ScaleHeight - 3
                Else
                    .ForeColor = BDR_VISUAL1
                    Arc .hdc, 1, 1, .ScaleWidth - 3, .ScaleHeight - 3, .ScaleWidth / 3, .ScaleHeight / 2, .ScaleWidth - 3, 1
                    .ForeColor = BDR_VISUAL2
                    Arc .hdc, .ScaleWidth - 2, .ScaleHeight - 2, 1, 1, .ScaleWidth - 2, 1, 1, .ScaleHeight - 2
                End If
            Case Is = Flat                                 '>> Round >> Draw Flat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    Arc .hdc, .ScaleWidth - 2, .ScaleHeight - 2, 1, 1, .ScaleWidth - 2, 1, 1, .ScaleHeight - 2
                Else
                    .ForeColor = BDR_FLAT2
                    Arc .hdc, .ScaleWidth - 2, .ScaleHeight - 2, 1, 1, .ScaleWidth - 2, 1, 1, .ScaleHeight - 2
                End If
            Case Is = OverFlat                             '>> Round >> Draw OverFlat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    Arc .hdc, .ScaleWidth - 2, .ScaleHeight - 2, 1, 1, .ScaleWidth - 2, 1, 1, .ScaleHeight - 2
                ElseIf MouseMove Then
                    .ForeColor = BDR_FLAT2
                    Arc .hdc, .ScaleWidth - 2, .ScaleHeight - 2, 1, 1, .ScaleWidth - 2, 1, 1, .ScaleHeight - 2
                End If
            Case Is = Java                                 '>> Round >> Draw Java Style.
                If .Enabled Then
                    .ForeColor = BDR_JAVA1
                    Arc .hdc, .ScaleWidth - 3, .ScaleHeight - 3, 2, 2, .ScaleWidth / 2, .ScaleHeight - 3, .ScaleWidth / 2, 3
                    .ForeColor = BDR_JAVA2
                    Arc .hdc, .ScaleWidth - 3, .ScaleHeight - 3, 2, 2, .ScaleWidth / 2, 2, .ScaleWidth / 2, .ScaleHeight - 2
                    Arc .hdc, .ScaleWidth - 2, .ScaleHeight - 2, 1, 1, .ScaleWidth / 2, .ScaleHeight - 2, .ScaleWidth / 2, 2
                End If
            Case Is = WinXp                                '>> Round >> Draw WindowsXp Style.
                If MouseDown Then
                    .ForeColor = BDR_PRESSED
                    Arc .hdc, .ScaleWidth - 4, .ScaleHeight - 4, 3, 3, .ScaleWidth / 2, .ScaleHeight - 2, .ScaleWidth / 2, 3
                ElseIf MouseMove Then
                    .ForeColor = BDR_GOLDXP_DARK
                    Arc .hdc, 2, 2, .ScaleWidth - 3, .ScaleHeight - 3, 2, .ScaleHeight - 3, .ScaleWidth - 3, .ScaleHeight - 3
                    .ForeColor = BDR_GOLDXP_NORMAL1
                    Arc .hdc, 2, 2, .ScaleWidth - 3, .ScaleHeight - 4, 3, 3, .ScaleWidth - 2, 4
                    .ForeColor = BDR_GOLDXP_NORMAL2
                    Arc .hdc, 3, 3, .ScaleWidth - 4, .ScaleHeight - 3, 2, 3, .ScaleWidth - 2, 3
                    .ForeColor = BDR_GOLDXP_LIGHT1
                    Arc .hdc, .ScaleWidth - 3, .ScaleHeight - 2, 2, 2, .ScaleWidth - 3, 3, 3, 3
                    .ForeColor = BDR_GOLDXP_LIGHT2
                    Arc .hdc, .ScaleWidth - 3, .ScaleHeight - 3, 3, 3, .ScaleWidth - 3, 4, 4, 4
                    '>> Round >> Draw Xp FocusRect.
                ElseIf mButtonStyle = WinXp And mFocusRect And mFocused Then
                    .ForeColor = BDR_BLUEXP_DARK
                    Arc .hdc, 2, 2, .ScaleWidth - 3, .ScaleHeight - 3, 2, .ScaleHeight - 3, .ScaleWidth - 3, .ScaleHeight - 3
                    .ForeColor = BDR_BLUEXP_NORMAL1
                    Arc .hdc, 2, 2, .ScaleWidth - 3, .ScaleHeight - 4, 3, 3, .ScaleWidth - 2, 4
                    .ForeColor = BDR_BLUEXP_NORMAL2
                    Arc .hdc, 3, 3, .ScaleWidth - 4, .ScaleHeight - 3, 2, 3, .ScaleWidth - 2, 3
                    .ForeColor = BDR_BLUEXP_LIGHT1
                    Arc .hdc, .ScaleWidth - 3, .ScaleHeight - 2, 2, 2, .ScaleWidth - 3, 3, 3, 3
                    .ForeColor = BDR_BLUEXP_LIGHT2
                    Arc .hdc, .ScaleWidth - 3, .ScaleHeight - 3, 3, 3, .ScaleWidth - 3, 4, 4, 4
                End If
            Case Is = Vista    '>> Round >> Draw Vista Style.
                If MouseDown Then
                    .ForeColor = BDR_VISTA2
                    RoundRect hdc, 2, 2, .ScaleWidth - 3, .ScaleHeight - 3, .ScaleWidth - 3, .ScaleHeight - 3
                Else
                    .ForeColor = BDR_VISTA1
                    RoundRect hdc, 2, 2, .ScaleWidth - 3, .ScaleHeight - 3, .ScaleWidth - 3, .ScaleHeight - 3
                    '>> Round >> Draw Vista FocusRect.
                    If mButtonStyle = Vista And mFocusRect And mFocused Then
                        .ForeColor = BDR_FOCUSRECT_VISTA
                        RoundRect hdc, 2, 2, .ScaleWidth - 3, .ScaleHeight - 3, .ScaleWidth - 3, .ScaleHeight - 3
                    End If
                End If
        End Select
        '>> Round >> Draw FocusRect.
        If Not mButtonStyle = Java And mFocusRect And mFocused Then
            If Not mButtonStyle = WinXp And mFocusRect And mFocused Then
                If Not mButtonStyle = Vista And mFocusRect And mFocused Then
                    .ForeColor = BDR_FOCUSRECT
                    RoundRect hdc, 4, 4, .ScaleWidth - 5, .ScaleHeight - 5, .ScaleWidth - 5, .ScaleHeight - 5
                End If
            End If
        End If
    End With
End Sub
Private Sub Redraw_Diamond()
    With UserControl
        '>> Diamond >> Make Diamond Shape.
        P(0).x = .ScaleWidth: P(0).y = .ScaleHeight / 2
        P(1).x = .ScaleWidth / 2: P(1).y = 0
        P(2).x = 0: P(2).y = .ScaleHeight / 2
        P(3).x = .ScaleWidth / 2: P(3).y = .ScaleHeight
        hRgn = CreatePolygonRgn(P(0), &H4, WINDING)
        SetWindowRgn .hwnd, hRgn, True
        DeleteObject hRgn

        '>> Diamond >> Draw Diamond Shape.
        MoveToEx .hdc, 0, .ScaleHeight / 2, Lines
        LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
        LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 2
        LineTo .hdc, .ScaleWidth / 2, 0
        LineTo .hdc, 0, .ScaleHeight / 2
        If Not mButtonStyleColors = TRANSPARENT Then
            MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
            LineTo .hdc, .ScaleWidth / 2, 0
        End If
        Select Case mButtonStyle
            Case Is = Visual                               '>> Diamond >> Draw Visual Style.
                If MouseDown Then
                    .ForeColor = BDR_VISUAL
                    MoveToEx .hdc, .ScaleWidth / 2, 0, Lines
                    LineTo .hdc, 0, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                Else
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, 1
                    .ForeColor = BDR_VISUAL2
                    MoveToEx .hdc, .ScaleWidth / 2, 0, Lines
                    LineTo .hdc, 0, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                End If
            Case Is = Flat                                 '>> Diamond >> Draw Flat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth / 2, 0, Lines
                    LineTo .hdc, 0, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                Else
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth / 2, 0, Lines
                    LineTo .hdc, 0, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                End If
            Case Is = OverFlat                             '>> Diamond >> Draw OverFlat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth / 2, 0, Lines
                    LineTo .hdc, 0, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                ElseIf MouseMove Then
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth / 2, 0, Lines
                    LineTo .hdc, 0, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                End If
            Case Is = Java                                 '>> Diamond >> Draw Java Style.
                If .Enabled Then
                    .ForeColor = BDR_JAVA1
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                    .ForeColor = BDR_JAVA2
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                    MoveToEx .hdc, .ScaleWidth / 2, 0, Lines
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                End If
            Case Is = WinXp                                '>> Diamond >> Draw WindowsXp Style.
                If MouseDown Then
                    .ForeColor = BDR_PRESSED
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 4, Lines
                    LineTo .hdc, .ScaleWidth - 4, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, 3
                    SetPixel .hdc, .ScaleWidth / 2, 1, vbBlack
                ElseIf MouseMove Then
                    .ForeColor = BDR_GOLDXP_DARK
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2
                    .ForeColor = BDR_GOLDXP_NORMAL1
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 3, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 2
                    MoveToEx .hdc, 1, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                    MoveToEx .hdc, .ScaleWidth - 2, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 2, 1
                    .ForeColor = BDR_GOLDXP_NORMAL2
                    MoveToEx .hdc, 2, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 3
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 2, 2
                    .ForeColor = BDR_GOLDXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 2
                    .ForeColor = BDR_GOLDXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth / 2, 2, Lines
                    LineTo .hdc, 2, .ScaleHeight / 2
                    SetPixel .hdc, .ScaleWidth / 2, 1, vbBlack
                    '>> Diamond >> Draw Xp FocusRect.
                ElseIf mButtonStyle = WinXp And mFocusRect And mFocused Then
                    .ForeColor = BDR_BLUEXP_DARK
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2
                    .ForeColor = BDR_BLUEXP_NORMAL1
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 3, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 2
                    MoveToEx .hdc, 1, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                    MoveToEx .hdc, .ScaleWidth - 2, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 2, 1
                    .ForeColor = BDR_BLUEXP_NORMAL2
                    MoveToEx .hdc, 2, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 3
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 2, 2
                    .ForeColor = BDR_BLUEXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 2
                    .ForeColor = BDR_BLUEXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth / 2, 2, Lines
                    LineTo .hdc, 2, .ScaleHeight / 2
                    SetPixel .hdc, .ScaleWidth / 2, 1, vbBlack
                End If
            Case Is = Vista    '>> Diamond >> Draw Vista Style.
                If MouseDown Then
                    .ForeColor = BDR_VISTA2
                    MoveToEx .hdc, 1, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, 1
                    LineTo .hdc, 1, .ScaleHeight / 2
                Else
                    .ForeColor = BDR_VISTA1
                    MoveToEx .hdc, 1, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 2, 1
                    LineTo .hdc, 1, .ScaleHeight / 2
                    '>> Diamond >> Draw Vista FocusRect.
                    If mButtonStyle = Vista And mFocusRect And mFocused Then
                        .ForeColor = BDR_FOCUSRECT_VISTA
                        MoveToEx .hdc, 1, .ScaleHeight / 2, Lines
                        LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                        LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2
                        LineTo .hdc, .ScaleWidth / 2, 1
                        LineTo .hdc, 1, .ScaleHeight / 2
                    End If
                End If
        End Select
        '>> Diamond >> Draw FocusRect.
        If Not mButtonStyle = Java And mFocusRect And mFocused Then
            If Not mButtonStyle = WinXp And mFocusRect And mFocused Then
                If Not mButtonStyle = Vista And mFocusRect And mFocused Then
                    .ForeColor = BDR_FOCUSRECT
                    PL(0).x = .ScaleWidth - 6: PL(0).y = .ScaleHeight / 2
                    PL(1).x = .ScaleWidth / 2: PL(1).y = 5
                    PL(2).x = 5: PL(2).y = .ScaleHeight / 2
                    PL(3).x = .ScaleWidth / 2: PL(3).y = .ScaleHeight - 6
                    Polygon .hdc, PL(0), &H4
                    '>> Return FocusRect For Good Show.
                    For Fo.x = 2 To .ScaleWidth - 2 Step 1
                        For Fo.y = 1 To .ScaleHeight - 1 Step 2
                            If GetPixel(.hdc, Fo.x, Fo.y) = .ForeColor Then SetPixel .hdc, Fo.x, Fo.y, vbBlack
                        Next Fo.y
                    Next Fo.x
                End If
            End If
        End If
    End With
End Sub
Private Sub Redraw_Top_Triangle()
    With UserControl
        '>> Top_Triangle >> Make Top_Triangle Shape.
        P(0).x = 0: P(0).y = .ScaleHeight
        P(1).x = .ScaleWidth / 2: P(1).y = 0
        P(2).x = .ScaleWidth: P(2).y = .ScaleHeight
        hRgn = CreatePolygonRgn(P(0), &H3, WINDING)
        SetWindowRgn .hwnd, hRgn, True
        DeleteObject hRgn

        '>> Top_Triangle >> Draw Top_Triangle Shape.
        MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
        LineTo .hdc, 1, .ScaleHeight - 1
        LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 1
        LineTo .hdc, .ScaleWidth / 2, 1

        Select Case mButtonStyle
            Case Is = Visual                               '>> Top_Triangle >> Draw Visual Style.
                If MouseDown Then
                    .ForeColor = BDR_VISUAL
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight - 1
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth / 2, 3, Lines
                    LineTo .hdc, 3, .ScaleHeight - 3
                Else
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, 1, .ScaleHeight - 2, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth / 2, 3
                    .ForeColor = BDR_VISUAL2
                    MoveToEx .hdc, .ScaleWidth / 2, 2, Lines
                    LineTo .hdc, 1, .ScaleHeight - 1
                End If
            Case Is = Flat                                 '>> Top_Triangle >> Draw Flat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight - 1
                Else
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth / 2, 2, Lines
                    LineTo .hdc, 1, .ScaleHeight - 1
                End If
            Case Is = OverFlat                             '>> Top_Triangle >> Draw OverFlat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight - 1
                ElseIf MouseMove Then
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth / 2, 2, Lines
                    LineTo .hdc, 1, .ScaleHeight - 1
                End If
            Case Is = Java                                 '>> Top_Triangle >> Draw Java Style.
                If .Enabled Then
                    .ForeColor = BDR_JAVA1
                    MoveToEx .hdc, 1, .ScaleHeight - 2, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth / 2, 3
                    .ForeColor = BDR_JAVA2
                    MoveToEx .hdc, .ScaleWidth / 2, 3, Lines
                    LineTo .hdc, 2, .ScaleHeight - 1
                    MoveToEx .hdc, 2, .ScaleHeight - 1, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 1
                    LineTo .hdc, .ScaleWidth / 2, 1
                End If
            Case Is = WinXp                                '>> Top_Triangle >> Draw WindowsXp Style.
                If MouseDown Then
                    .ForeColor = BDR_PRESSED
                    MoveToEx .hdc, 4, .ScaleHeight - 3, Lines
                    LineTo .hdc, .ScaleWidth - 5, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth / 2, 5
                ElseIf MouseMove Then
                    .ForeColor = BDR_GOLDXP_DARK
                    MoveToEx .hdc, 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight - 2
                    .ForeColor = BDR_GOLDXP_NORMAL1
                    MoveToEx .hdc, 3, .ScaleHeight - 3, Lines
                    LineTo .hdc, .ScaleWidth - 4, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth / 2, 3
                    .ForeColor = BDR_GOLDXP_NORMAL2
                    MoveToEx .hdc, .ScaleWidth - 5, .ScaleHeight - 4, Lines
                    LineTo .hdc, .ScaleWidth / 2, 5
                    .ForeColor = BDR_GOLDXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth / 2, 3, Lines
                    LineTo .hdc, 3, .ScaleHeight - 3
                    .ForeColor = BDR_GOLDXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth / 2, 4, Lines
                    LineTo .hdc, 3, .ScaleHeight - 3
                    '>> Top_Triangle >> Draw Xp FocusRect.
                ElseIf mButtonStyle = WinXp And mFocusRect And mFocused Then
                    .ForeColor = BDR_BLUEXP_DARK
                    MoveToEx .hdc, 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight - 2
                    .ForeColor = BDR_BLUEXP_NORMAL1
                    MoveToEx .hdc, 3, .ScaleHeight - 3, Lines
                    LineTo .hdc, .ScaleWidth - 4, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth / 2, 3
                    .ForeColor = BDR_BLUEXP_NORMAL2
                    MoveToEx .hdc, .ScaleWidth - 5, .ScaleHeight - 4, Lines
                    LineTo .hdc, .ScaleWidth / 2, 5
                    .ForeColor = BDR_BLUEXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth / 2, 3, Lines
                    LineTo .hdc, 3, .ScaleHeight - 3
                    .ForeColor = BDR_BLUEXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth / 2, 4, Lines
                    LineTo .hdc, 3, .ScaleHeight - 3
                End If
            Case Is = Vista    '>> Top_Triangle >> Draw Vista Style.
                If MouseDown Then
                    .ForeColor = BDR_VISTA2
                    MoveToEx .hdc, .ScaleWidth / 2, 2, Lines
                    LineTo .hdc, 2, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth / 2, 2
                Else
                    .ForeColor = BDR_VISTA1
                    MoveToEx .hdc, .ScaleWidth / 2, 2, Lines
                    LineTo .hdc, 2, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth / 2, 2
                    '>> Top_Triangle >> Draw Vista FocusRect.
                    If mButtonStyle = Vista And mFocusRect And mFocused Then
                        .ForeColor = BDR_FOCUSRECT_VISTA
                        MoveToEx .hdc, .ScaleWidth / 2, 2, Lines
                        LineTo .hdc, 2, .ScaleHeight - 2
                        LineTo .hdc, .ScaleWidth - 3, .ScaleHeight - 2
                        LineTo .hdc, .ScaleWidth / 2, 2
                    End If
                End If
        End Select
        '>> Top_Triangle >> Draw FocusRect.
        If Not mButtonStyle = Java And mFocusRect And mFocused Then
            If Not mButtonStyle = WinXp And mFocusRect And mFocused Then
                If Not mButtonStyle = Vista And mFocusRect And mFocused Then
                    .ForeColor = BDR_FOCUSRECT
                    PL(0).x = 7: PL(0).y = .ScaleHeight - 5
                    PL(1).x = .ScaleWidth / 2: PL(1).y = 9
                    PL(2).x = .ScaleWidth - 8: PL(2).y = .ScaleHeight - 5
                    Polygon .hdc, PL(0), &H3
                End If
            End If
        End If
    End With
End Sub
Private Sub Redraw_Left_Triangle()
    With UserControl
        '>> Left_Triangle >> Make Left_Triangle Shape.
        P(0).x = 0: P(0).y = .ScaleHeight / 2
        P(1).x = .ScaleWidth: P(1).y = 0
        P(2).x = .ScaleWidth: P(2).y = .ScaleHeight
        hRgn = CreatePolygonRgn(P(0), &H3, WINDING)
        SetWindowRgn .hwnd, hRgn, True
        DeleteObject hRgn

        '>> Left_Triangle >> Draw Left_Triangle Shape.
        MoveToEx .hdc, 1, .ScaleHeight / 2, Lines
        LineTo .hdc, .ScaleWidth - 1, 1
        LineTo .hdc, .ScaleWidth - 1, .ScaleHeight - 1
        LineTo .hdc, 1, .ScaleHeight / 2

        Select Case mButtonStyle
            Case Is = Visual                               '>> Left_Triangle >> Draw Visual Style.
                If MouseDown Then
                    .ForeColor = BDR_VISUAL
                    MoveToEx .hdc, .ScaleWidth - 1, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 2
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth - 3, 3, Lines
                    LineTo .hdc, 3, .ScaleHeight / 2
                Else
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, 2, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth - 2, 1
                    .ForeColor = BDR_VISUAL2
                    MoveToEx .hdc, .ScaleWidth - 1, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 2
                End If
            Case Is = Flat                                 '>> Left_Triangle >> Draw Flat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth - 1, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 2
                Else
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth - 1, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 2

                End If
            Case Is = OverFlat                             '>> Left_Triangle >> Draw OverFlat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth - 1, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 2
                ElseIf MouseMove Then
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth - 1, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 2
                End If
            Case Is = Java                                 '>> Left_Triangle >> Draw Java Style.
                If .Enabled Then
                    .ForeColor = BDR_JAVA1
                    MoveToEx .hdc, .ScaleWidth - 2, 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 3
                    LineTo .hdc, 3, .ScaleHeight / 2
                    .ForeColor = BDR_JAVA2
                    MoveToEx .hdc, 3, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth - 1, 2
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight - 1
                    LineTo .hdc, 1, .ScaleHeight / 2
                End If
            Case Is = WinXp                                '>> Left_Triangle >> Draw WindowsXp Style.
                If MouseDown Then
                    .ForeColor = BDR_PRESSED
                    MoveToEx .hdc, .ScaleWidth - 3, 5, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight - 5
                    LineTo .hdc, 5, .ScaleHeight / 2
                ElseIf MouseMove Then
                    .ForeColor = BDR_GOLDXP_DARK
                    MoveToEx .hdc, .ScaleWidth - 2, 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 1
                    .ForeColor = BDR_GOLDXP_NORMAL1
                    MoveToEx .hdc, .ScaleWidth - 3, 2, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight - 3
                    LineTo .hdc, 3, .ScaleHeight / 2
                    .ForeColor = BDR_GOLDXP_NORMAL2
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight - 4, Lines
                    LineTo .hdc, 5, .ScaleHeight / 2
                    .ForeColor = BDR_GOLDXP_LIGHT1
                    MoveToEx .hdc, 3, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth - 3, 3
                    .ForeColor = BDR_GOLDXP_LIGHT2
                    MoveToEx .hdc, 4, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth - 4, 4
                    '>> Left_Triangle >> Draw Xp FocusRect.
                ElseIf mButtonStyle = WinXp And mFocusRect And mFocused Then
                    .ForeColor = BDR_BLUEXP_DARK
                    MoveToEx .hdc, .ScaleWidth - 2, 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 1
                    .ForeColor = BDR_BLUEXP_NORMAL1
                    MoveToEx .hdc, .ScaleWidth - 3, 2, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight - 3
                    LineTo .hdc, 3, .ScaleHeight / 2
                    .ForeColor = BDR_BLUEXP_NORMAL2
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight - 4, Lines
                    LineTo .hdc, 5, .ScaleHeight / 2
                    .ForeColor = BDR_BLUEXP_LIGHT1
                    MoveToEx .hdc, 3, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth - 3, 3
                    .ForeColor = BDR_BLUEXP_LIGHT2
                    MoveToEx .hdc, 4, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth - 4, 4
                End If
            Case Is = Vista    '>> Left_Triangle >> Draw Vista Style.
                If MouseDown Then
                    .ForeColor = BDR_VISTA2
                    MoveToEx .hdc, 2, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, 2
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 2
                    LineTo .hdc, 2, .ScaleHeight / 2
                Else
                    .ForeColor = BDR_VISTA1
                    MoveToEx .hdc, 2, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, 2
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 2
                    LineTo .hdc, 2, .ScaleHeight / 2
                    '>> Left_Triangle >> Draw Vista FocusRect.
                    If mButtonStyle = Vista And mFocusRect And mFocused Then
                        .ForeColor = BDR_FOCUSRECT_VISTA
                        MoveToEx .hdc, 2, .ScaleHeight / 2, Lines
                        LineTo .hdc, .ScaleWidth - 2, 2
                        LineTo .hdc, .ScaleWidth - 2, .ScaleHeight - 2
                        LineTo .hdc, 2, .ScaleHeight / 2
                    End If
                End If
        End Select
        '>> Left_Triangle >> Draw FocusRect.
        If Not mButtonStyle = Java And mFocusRect And mFocused Then
            If Not mButtonStyle = WinXp And mFocusRect And mFocused Then
                If Not mButtonStyle = Vista And mFocusRect And mFocused Then
                    .ForeColor = BDR_FOCUSRECT
                    PL(0).x = 9: PL(0).y = .ScaleHeight / 2
                    PL(1).x = .ScaleWidth - 5: PL(1).y = 7
                    PL(2).x = .ScaleWidth - 5: PL(2).y = .ScaleHeight - 8
                    Polygon .hdc, PL(0), &H3
                End If
            End If
        End If
    End With
End Sub
Private Sub Redraw_Right_Triangle()
    With UserControl
        '>> Right_Triangle >> Make Right_Triangle Shape.
        P(0).x = .ScaleWidth: P(0).y = .ScaleHeight / 2
        P(1).x = 0: P(1).y = 0
        P(2).x = 0: P(2).y = .ScaleHeight
        hRgn = CreatePolygonRgn(P(0), &H3, WINDING)
        SetWindowRgn .hwnd, hRgn, True
        DeleteObject hRgn

        '>> Right_Triangle >> Draw Right_Triangle Shape.
        MoveToEx .hdc, .ScaleWidth - 2, .ScaleHeight / 2, Lines
        LineTo .hdc, 0, 1
        LineTo .hdc, 0, .ScaleHeight - 1
        LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 2

        Select Case mButtonStyle
            Case Is = Visual                               '>> Right_Triangle >> Draw Visual Style.
                If MouseDown Then
                    .ForeColor = BDR_VISUAL
                    MoveToEx .hdc, .ScaleWidth - 2, .ScaleHeight / 2, Lines
                    LineTo .hdc, 0, 1
                    LineTo .hdc, 0, .ScaleHeight - 1
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth - 5, .ScaleHeight / 2, Lines
                    LineTo .hdc, 1, 2
                    LineTo .hdc, 1, .ScaleHeight - 2
                Else
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, 1, .ScaleHeight - 3, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 2
                    .ForeColor = BDR_VISUAL2
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 2, Lines
                    LineTo .hdc, 0, 1
                    LineTo .hdc, 0, .ScaleHeight - 1
                End If
            Case Is = Flat                                 '>> Right_Triangle >> Draw Flat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth - 2, .ScaleHeight / 2, Lines
                    LineTo .hdc, 0, 1
                    LineTo .hdc, 0, .ScaleHeight - 1
                Else
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 2, Lines
                    LineTo .hdc, 0, 1
                    LineTo .hdc, 0, .ScaleHeight - 1
                End If
            Case Is = OverFlat                             '>> Right_Triangle >> Draw OverFlat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth - 2, .ScaleHeight / 2, Lines
                    LineTo .hdc, 0, 1
                    LineTo .hdc, 0, .ScaleHeight - 1
                ElseIf MouseMove Then
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 2, Lines
                    LineTo .hdc, 0, 1
                    LineTo .hdc, 0, .ScaleHeight - 1
                End If
            Case Is = Java                                 '>> Right_Triangle >> Draw Java Style.
                If .Enabled Then
                    .ForeColor = BDR_JAVA1
                    MoveToEx .hdc, 1, .ScaleHeight - 3, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 2
                    .ForeColor = BDR_JAVA2
                    MoveToEx .hdc, .ScaleWidth - 5, .ScaleHeight / 2, Lines
                    LineTo .hdc, 1, 3
                    LineTo .hdc, 1, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 2
                End If
            Case Is = WinXp                                '>> Right_Triangle >> Draw WindowsXp Style.
                If MouseDown Then
                    .ForeColor = BDR_PRESSED
                    MoveToEx .hdc, 2, 4, Lines
                    LineTo .hdc, 2, .ScaleHeight - 5
                    LineTo .hdc, .ScaleWidth - 6, .ScaleHeight / 2
                ElseIf MouseMove Then
                    .ForeColor = BDR_GOLDXP_DARK
                    MoveToEx .hdc, 1, 2, Lines
                    LineTo .hdc, 1, .ScaleHeight - 1
                    .ForeColor = BDR_GOLDXP_NORMAL1
                    MoveToEx .hdc, 2, 2, Lines
                    LineTo .hdc, 2, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth - 4, .ScaleHeight / 2
                    .ForeColor = BDR_GOLDXP_NORMAL2
                    MoveToEx .hdc, 3, .ScaleHeight - 5, Lines
                    LineTo .hdc, .ScaleWidth - 5, .ScaleHeight / 2
                    .ForeColor = BDR_GOLDXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth - 4, .ScaleHeight / 2, Lines
                    LineTo .hdc, 4, 4
                    .ForeColor = BDR_GOLDXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth - 5, .ScaleHeight / 2, Lines
                    LineTo .hdc, 5, 5
                    '>> Right_Triangle >> Draw Xp FocusRect.
                ElseIf mButtonStyle = WinXp And mFocusRect And mFocused Then
                    .ForeColor = BDR_BLUEXP_DARK
                    MoveToEx .hdc, 1, 2, Lines
                    LineTo .hdc, 1, .ScaleHeight - 1
                    .ForeColor = BDR_BLUEXP_NORMAL1
                    MoveToEx .hdc, 2, 2, Lines
                    LineTo .hdc, 2, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth - 4, .ScaleHeight / 2
                    .ForeColor = BDR_BLUEXP_NORMAL2
                    MoveToEx .hdc, 3, .ScaleHeight - 5, Lines
                    LineTo .hdc, .ScaleWidth - 5, .ScaleHeight / 2
                    .ForeColor = BDR_BLUEXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth - 4, .ScaleHeight / 2, Lines
                    LineTo .hdc, 4, 4
                    .ForeColor = BDR_BLUEXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth - 5, .ScaleHeight / 2, Lines
                    LineTo .hdc, 5, 5
                End If
            Case Is = Vista    '>> Right_Triangle >> Draw Vista Style.
                If MouseDown Then
                    .ForeColor = BDR_VISTA2
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 2, Lines
                    LineTo .hdc, 1, 2
                    LineTo .hdc, 1, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2
                Else
                    .ForeColor = BDR_VISTA1
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 2, Lines
                    LineTo .hdc, 1, 2
                    LineTo .hdc, 1, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2
                    '>> Right_Triangle >> Draw Vista FocusRect.
                    If mButtonStyle = Vista And mFocusRect And mFocused Then
                        .ForeColor = BDR_FOCUSRECT_VISTA
                        MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 2, Lines
                        LineTo .hdc, 1, 2
                        LineTo .hdc, 1, .ScaleHeight - 2
                        LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2
                    End If
                End If
        End Select
        '>> Right_Triangle >> Draw FocusRect.
        If Not mButtonStyle = Java And mFocusRect And mFocused Then
            If Not mButtonStyle = WinXp And mFocusRect And mFocused Then
                If Not mButtonStyle = Vista And mFocusRect And mFocused Then
                    .ForeColor = BDR_FOCUSRECT
                    PL(0).x = .ScaleWidth - 10: PL(0).y = .ScaleHeight / 2
                    PL(1).x = 4: PL(1).y = 7
                    PL(2).x = 4: PL(2).y = .ScaleHeight - 8
                    Polygon .hdc, PL(0), &H3
                End If
            End If
        End If
    End With
End Sub
Private Sub Redraw_Down_Triangle()
    With UserControl
        '>> Down_Triangle >> Make Down_Triangle Shape.
        P(0).x = 0: P(0).y = 1
        P(1).x = .ScaleWidth / 2: P(1).y = .ScaleHeight
        P(2).x = .ScaleWidth: P(2).y = 1
        hRgn = CreatePolygonRgn(P(0), &H3, WINDING)
        SetWindowRgn .hwnd, hRgn, True
        DeleteObject hRgn

        '>> Down_Triangle >> Draw Down_Triangle Shape.
        MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 1, Lines
        LineTo .hdc, .ScaleWidth - 1, 1
        LineTo .hdc, 1, 1
        LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1

        Select Case mButtonStyle
            Case Is = Visual                               '>> Down_Triangle >> Draw Visual Style.
                If MouseDown Then
                    .ForeColor = BDR_VISUAL
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 1, Lines
                    LineTo .hdc, 1, 1
                    LineTo .hdc, .ScaleWidth - 1, 1
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 4, Lines
                    LineTo .hdc, 2, 2
                    LineTo .hdc, .ScaleWidth - 3, 2
                Else
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth - 2, 1, Lines
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 3
                    .ForeColor = BDR_VISUAL2
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, 1, 1
                    LineTo .hdc, .ScaleWidth - 1, 1
                End If
            Case Is = Flat                                 '>> Down_Triangle >> Draw Flat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 1, Lines
                    LineTo .hdc, 1, 1
                    LineTo .hdc, .ScaleWidth - 1, 1
                Else
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, 1, 1
                    LineTo .hdc, .ScaleWidth - 1, 1
                End If
            Case Is = OverFlat                             '>> Down_Triangle >> Draw OverFlat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 1, Lines
                    LineTo .hdc, 1, 1
                    LineTo .hdc, .ScaleWidth - 1, 1
                ElseIf MouseMove Then
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, 1, 1
                    LineTo .hdc, .ScaleWidth - 1, 1
                End If
            Case Is = Java                                 '>> Down_Triangle >> Draw Java Style.
                If .Enabled Then
                    .ForeColor = BDR_JAVA1
                    MoveToEx .hdc, .ScaleWidth - 3, 2, Lines
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 3
                    .ForeColor = BDR_JAVA2
                    MoveToEx .hdc, .ScaleWidth - 2, 2, Lines
                    LineTo .hdc, 2, 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 4
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 1, Lines
                    LineTo .hdc, .ScaleWidth - 1, 1
                End If
            Case Is = WinXp                                '>> Down_Triangle >> Draw WindowsXp Style.
                If MouseDown Then
                    .ForeColor = BDR_PRESSED
                    MoveToEx .hdc, 4, 3, Lines
                    LineTo .hdc, .ScaleWidth - 5, 3
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 5
                ElseIf MouseMove Then
                    .ForeColor = BDR_GOLDXP_DARK
                    MoveToEx .hdc, 2, 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, 2
                    .ForeColor = BDR_GOLDXP_NORMAL1
                    MoveToEx .hdc, 3, 3, Lines
                    LineTo .hdc, .ScaleWidth - 3, 3
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 3
                    .ForeColor = BDR_GOLDXP_NORMAL2
                    MoveToEx .hdc, .ScaleWidth - 5, 4, Lines
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 4
                    .ForeColor = BDR_GOLDXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 4, Lines
                    LineTo .hdc, 3, 3
                    .ForeColor = BDR_GOLDXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 5, Lines
                    LineTo .hdc, 4, 4
                    '>> Down_Triangle >> Draw Xp FocusRect.
                ElseIf mButtonStyle = WinXp And mFocusRect And mFocused Then
                    .ForeColor = BDR_BLUEXP_DARK
                    MoveToEx .hdc, 2, 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, 2
                    .ForeColor = BDR_BLUEXP_NORMAL1
                    MoveToEx .hdc, 3, 3, Lines
                    LineTo .hdc, .ScaleWidth - 3, 3
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 3
                    .ForeColor = BDR_BLUEXP_NORMAL2
                    MoveToEx .hdc, .ScaleWidth - 5, 4, Lines
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 4
                    .ForeColor = BDR_BLUEXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 4, Lines
                    LineTo .hdc, 3, 3
                    .ForeColor = BDR_BLUEXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 5, Lines
                    LineTo .hdc, 4, 4
                End If
            Case Is = Vista    '>> Down_Triangle >> Draw Vista Style.
                If MouseDown Then
                    .ForeColor = BDR_VISTA2
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, 2
                    LineTo .hdc, 2, 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                Else
                    .ForeColor = BDR_VISTA1
                    MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, 2
                    LineTo .hdc, 2, 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                    '>> Down_Triangle >> Draw Vista FocusRect.
                    If mButtonStyle = Vista And mFocusRect And mFocused Then
                        .ForeColor = BDR_FOCUSRECT_VISTA
                        MoveToEx .hdc, .ScaleWidth / 2, .ScaleHeight - 2, Lines
                        LineTo .hdc, .ScaleWidth - 2, 2
                        LineTo .hdc, 2, 2
                        LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                    End If
                End If
        End Select
        '>> Down_Triangle >> Draw FocusRect.
        If Not mButtonStyle = Java And mFocusRect And mFocused Then
            If Not mButtonStyle = WinXp And mFocusRect And mFocused Then
                If Not mButtonStyle = Vista And mFocusRect And mFocused Then
                    .ForeColor = BDR_FOCUSRECT
                    PL(0).x = 6: PL(0).y = 4
                    PL(1).x = .ScaleWidth / 2: PL(1).y = .ScaleHeight - 10
                    PL(2).x = .ScaleWidth - 8: PL(2).y = 4
                    Polygon .hdc, PL(0), &H3
                End If
            End If
        End If
    End With
End Sub
Private Sub Redraw_Top_Arrow()
    With UserControl
        '>> Top_Arrow >> Make Top_Arrow Shape.
        P(0).x = .ScaleWidth / 2: P(0).y = 0
        P(1).x = 0: P(1).y = .ScaleHeight / 1.5
        P(2).x = .ScaleWidth / 3: P(2).y = .ScaleHeight / 1.5
        P(3).x = .ScaleWidth / 3: P(3).y = .ScaleHeight
        P(4).x = .ScaleWidth / 1.5: P(4).y = .ScaleHeight
        P(5).x = .ScaleWidth / 1.5: P(5).y = .ScaleHeight / 1.5
        P(6).x = .ScaleWidth: P(6).y = .ScaleHeight / 1.5
        hRgn = CreatePolygonRgn(P(0), &H7, WINDING)
        SetWindowRgn .hwnd, hRgn, True
        DeleteObject hRgn

        '>> Top_Arrow >> Draw Top_Arrow Shape.
        MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
        LineTo .hdc, 1, .ScaleHeight / 1.5 - 1
        LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 1.5 - 1
        LineTo .hdc, .ScaleWidth / 3, .ScaleHeight - 1
        LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight - 1.5
        LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight / 1.5 - 1
        LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 1.5 - 1
        LineTo .hdc, .ScaleWidth / 2, 1

        Select Case mButtonStyle
            Case Is = Visual                               '>> Top_Arrow >> Draw Visual Style.
                If MouseDown Then
                    .ForeColor = BDR_VISUAL
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight - 1
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth / 2, 2, Lines
                    LineTo .hdc, 2, .ScaleHeight / 1.5 - 1
                    MoveToEx .hdc, 2, .ScaleHeight / 1.5 - 2, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 1
                Else
                    .ForeColor = BDR_VISUAL2
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight - 1
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth / 3, .ScaleHeight - 2, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 2, 2
                End If
            Case Is = Flat                                 '>> Top_Arrow >> Draw Flat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight - 1
                Else
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight - 1
                End If
            Case Is = OverFlat                             '>> Top_Arrow >> Draw OverFlat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight - 1
                ElseIf MouseMove Then
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth / 2, 1, Lines
                    LineTo .hdc, 1, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight - 1
                End If
            Case Is = Java                                 '>> Top_Arrow >> Draw Java Style.
                If .Enabled Then
                    .ForeColor = BDR_JAVA1
                    MoveToEx .hdc, .ScaleWidth / 3, .ScaleHeight - 2, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 2, 3
                    .ForeColor = BDR_JAVA2
                    MoveToEx .hdc, .ScaleWidth / 2, 3, Lines
                    LineTo .hdc, 3, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight - 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 2, 1
                End If
            Case Is = WinXp                                '>> Top_Arrow >> Draw WindowsXp Style.
                If MouseDown Then
                    .ForeColor = BDR_PRESSED
                    MoveToEx .hdc, .ScaleWidth / 3 + 3, .ScaleHeight - 3, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight - 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth - 5, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 2, 4
                ElseIf MouseMove Then
                    .ForeColor = BDR_GOLDXP_DARK
                    MoveToEx .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight - 2
                    .ForeColor = BDR_GOLDXP_NORMAL1
                    MoveToEx .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 3, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 2, 3
                    .ForeColor = BDR_GOLDXP_NORMAL2
                    MoveToEx .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight - 1.5 - 3, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth - 5, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 2, 5
                    .ForeColor = BDR_GOLDXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth / 2, 3, Lines
                    LineTo .hdc, 3, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 2
                    .ForeColor = BDR_GOLDXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth / 2, 5, Lines
                    LineTo .hdc, 5, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight - 3
                    '>> Top_Arrow >> Draw Xp FocusRec.
                ElseIf mButtonStyle = WinXp And mFocusRect And mFocused Then
                    .ForeColor = BDR_BLUEXP_DARK
                    MoveToEx .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 2, Lines
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight - 2
                    .ForeColor = BDR_BLUEXP_NORMAL1
                    MoveToEx .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 3, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 2, 3
                    .ForeColor = BDR_BLUEXP_NORMAL2
                    MoveToEx .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight - 1.5 - 3, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth - 5, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 2, 5
                    .ForeColor = BDR_BLUEXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth / 2, 3, Lines
                    LineTo .hdc, 3, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 2
                    .ForeColor = BDR_BLUEXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth / 2, 5, Lines
                    LineTo .hdc, 5, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight - 3
                End If
            Case Is = Vista    '>> Top_Arrow >> Draw Vista Style.
                If MouseDown Then
                    .ForeColor = BDR_VISTA2
                    MoveToEx .hdc, .ScaleWidth / 2, 2, Lines
                    LineTo .hdc, 3, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 2, 2
                Else
                    .ForeColor = BDR_VISTA1
                    MoveToEx .hdc, .ScaleWidth / 2, 2, Lines
                    LineTo .hdc, 3, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 2, 2
                    '>> Top_Arrow >> Draw Vista FocusRect.
                    If mButtonStyle = Vista And mFocusRect And mFocused Then
                        .ForeColor = BDR_FOCUSRECT_VISTA
                        MoveToEx .hdc, .ScaleWidth / 2, 2, Lines
                        LineTo .hdc, 3, .ScaleHeight / 1.5 - 2
                        LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                        LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 2
                        LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 2
                        LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                        LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 1.5 - 2
                        LineTo .hdc, .ScaleWidth / 2, 2
                    End If
                End If
        End Select
        '>> Top_Arrow >> Draw FocusRec.
        If Not mButtonStyle = Java And mFocusRect And mFocused Then
            If Not mButtonStyle = WinXp And mFocusRect And mFocused Then
                If Not mButtonStyle = Vista And mFocusRect And mFocused Then
                    .ForeColor = BDR_FOCUSRECT
                    PL(0).x = .ScaleWidth / 2: PL(0).y = 6
                    PL(1).x = 9: PL(1).y = .ScaleHeight / 1.5 - 5
                    PL(2).x = .ScaleWidth / 3 + 4: PL(2).y = .ScaleHeight / 1.5 - 5
                    PL(3).x = .ScaleWidth / 3 + 4: PL(3).y = .ScaleHeight - 5
                    PL(4).x = .ScaleWidth / 1.5 - 5: PL(4).y = .ScaleHeight - 5
                    PL(5).x = .ScaleWidth / 1.5 - 5: PL(5).y = .ScaleHeight / 1.5 - 5
                    PL(6).x = .ScaleWidth - 10: PL(6).y = .ScaleHeight / 1.5 - 5
                    Polygon .hdc, PL(0), &H7
                End If
            End If
        End If
    End With
End Sub
Private Sub Redraw_Left_Arrow()
    With UserControl
        '>> Left_Arrow >> Make Left_Arrow Shape.
        P(0).x = 0: P(0).y = .ScaleHeight / 2
        P(1).x = .ScaleWidth / 1.5: P(1).y = 0
        P(2).x = .ScaleWidth / 1.5: P(2).y = .ScaleHeight / 3
        P(3).x = .ScaleWidth: P(3).y = .ScaleHeight / 3
        P(4).x = .ScaleWidth: P(4).y = .ScaleHeight / 1.5
        P(5).x = .ScaleWidth / 1.5: P(5).y = .ScaleHeight / 1.5
        P(6).x = .ScaleWidth / 1.5: P(6).y = .ScaleHeight
        hRgn = CreatePolygonRgn(P(0), &H7, WINDING)
        SetWindowRgn .hwnd, hRgn, True
        DeleteObject hRgn

        '>> Left_Arrow >> Draw Left_Arrow Shape.
        MoveToEx .hdc, .ScaleWidth - 1, .ScaleHeight / 3, Lines
        LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight / 3
        LineTo .hdc, .ScaleWidth / 1.5 - 1, 1
        LineTo .hdc, 1, .ScaleHeight / 2
        LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight - 1
        LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight / 1.5 - 1
        LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 1.5 - 1
        LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 3

        Select Case mButtonStyle
            Case Is = Visual                               '>> Left_Arrow >> Draw Visual Style.
                If MouseDown Then
                    .ForeColor = BDR_VISUAL
                    MoveToEx .hdc, .ScaleWidth - 1, .ScaleHeight / 3, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, 1
                    LineTo .hdc, 1, .ScaleHeight / 2
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth - 1, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, 3
                    LineTo .hdc, 2, .ScaleHeight / 2
                Else
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth - 2, .ScaleHeight / 3 + 2, Lines    'LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight - 1
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 3
                    LineTo .hdc, 2, .ScaleHeight / 2
                    .ForeColor = BDR_VISUAL2
                    MoveToEx .hdc, .ScaleWidth - 1, .ScaleHeight / 3, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, 1
                    LineTo .hdc, 1, .ScaleHeight / 2
                End If
            Case Is = Flat                                 '>> Left_Arrow >> Draw Flat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth - 1, .ScaleHeight / 3, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, 1
                    LineTo .hdc, 1, .ScaleHeight / 2
                Else
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth - 1, .ScaleHeight / 3, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, 1
                    LineTo .hdc, 1, .ScaleHeight / 2
                End If
            Case Is = OverFlat                             '>> Left_Arrow >> Draw OverFlat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth - 1, .ScaleHeight / 3, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, 1
                    LineTo .hdc, 1, .ScaleHeight / 2
                ElseIf MouseMove Then
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth - 1, .ScaleHeight / 3, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, 1
                    LineTo .hdc, 1, .ScaleHeight / 2
                End If
            Case Is = Java                                 '>> Left_Arrow >> Draw Java Style.
                If .Enabled Then
                    .ForeColor = BDR_JAVA1
                    MoveToEx .hdc, .ScaleWidth - 2, .ScaleHeight / 3 + 2, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 3
                    LineTo .hdc, 3, .ScaleHeight / 2
                    .ForeColor = BDR_JAVA2
                    MoveToEx .hdc, .ScaleWidth - 1, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, 3
                    LineTo .hdc, 2, .ScaleHeight / 2
                    MoveToEx .hdc, .ScaleWidth - 1, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight - 1
                    LineTo .hdc, 1, .ScaleHeight / 2
                End If
            Case Is = WinXp                                '>> Left_Arrow >> Draw WindowsXp Style.
                If MouseDown Then
                    .ForeColor = BDR_PRESSED
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 2, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight - 5
                    LineTo .hdc, 5, .ScaleHeight / 2
                ElseIf MouseMove Then
                    .ForeColor = BDR_GOLDXP_DARK
                    MoveToEx .hdc, .ScaleWidth - 2, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 1.5 - 1
                    .ForeColor = BDR_GOLDXP_NORMAL1
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 3
                    LineTo .hdc, 2, .ScaleHeight / 2
                    .ForeColor = BDR_GOLDXP_NORMAL2
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 1.5 - 3, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight - 5
                    LineTo .hdc, 4, .ScaleHeight / 2
                    .ForeColor = BDR_GOLDXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, 3
                    LineTo .hdc, 2, .ScaleHeight / 2
                    .ForeColor = BDR_GOLDXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth - 4, .ScaleHeight / 3 + 2, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight / 3 + 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, 5
                    LineTo .hdc, 3, .ScaleHeight / 2
                    '>> Left_Arrow >> Draw Xp FocusRect.
                ElseIf mButtonStyle = WinXp And mFocusRect And mFocused Then
                    .ForeColor = BDR_BLUEXP_DARK
                    MoveToEx .hdc, .ScaleWidth - 2, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 1.5 - 1
                    .ForeColor = BDR_BLUEXP_NORMAL1
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 3
                    LineTo .hdc, 2, .ScaleHeight / 2
                    .ForeColor = BDR_BLUEXP_NORMAL2
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 1.5 - 3, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight - 5
                    LineTo .hdc, 4, .ScaleHeight / 2
                    .ForeColor = BDR_BLUEXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, 3
                    LineTo .hdc, 2, .ScaleHeight / 2
                    .ForeColor = BDR_BLUEXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth - 4, .ScaleHeight / 3 + 2, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight / 3 + 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, 5
                    LineTo .hdc, 3, .ScaleHeight / 2
                End If
            Case Is = Vista    '>> Left_Arrow >> Draw Vista Style.
                If MouseDown Then
                    .ForeColor = BDR_VISTA2
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, 3
                    LineTo .hdc, 2, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 3
                Else
                    .ForeColor = BDR_VISTA1
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, 3
                    LineTo .hdc, 2, .ScaleHeight / 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 3
                    '>> Left_Arrow >> Draw Vista FocusRect.
                    If mButtonStyle = Vista And mFocusRect And mFocused Then
                        .ForeColor = BDR_FOCUSRECT_VISTA
                        MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1, Lines
                        LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                        LineTo .hdc, .ScaleWidth / 1.5 - 2, 3
                        LineTo .hdc, 2, .ScaleHeight / 2
                        LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight - 3
                        LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 1.5 - 2
                        LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 1.5 - 2
                        LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 3
                    End If
                End If
        End Select
        '>> Left_Arrow >> Draw FocusRect.
        If Not mButtonStyle = Java And mFocusRect And mFocused Then
            If Not mButtonStyle = WinXp And mFocusRect And mFocused Then
                If Not mButtonStyle = Vista And mFocusRect And mFocused Then
                    .ForeColor = BDR_FOCUSRECT
                    PL(0).x = 6: PL(0).y = .ScaleHeight / 2
                    PL(1).x = .ScaleWidth / 1.5 - 5: PL(1).y = 9
                    PL(2).x = .ScaleWidth / 1.5 - 5: PL(2).y = .ScaleHeight / 3 + 4
                    PL(3).x = .ScaleWidth - 5: PL(3).y = .ScaleHeight / 3 + 4
                    PL(4).x = .ScaleWidth - 5: PL(4).y = .ScaleHeight / 1.5 - 5
                    PL(5).x = .ScaleWidth / 1.5 - 5: PL(5).y = .ScaleHeight / 1.5 - 5
                    PL(6).x = .ScaleWidth / 1.5 - 5: PL(6).y = .ScaleHeight - 10
                    Polygon .hdc, PL(0), &H7
                End If
            End If
        End If
    End With
End Sub
Private Sub Redraw_Right_Arrow()
    With UserControl
        '>> Right_Arrow >> Make Right_Arrow Shape.
        P(0).x = .ScaleWidth: P(0).y = .ScaleHeight / 2
        P(1).x = .ScaleWidth / 3: P(1).y = 0
        P(2).x = .ScaleWidth / 3: P(2).y = .ScaleHeight / 3
        P(3).x = 0: P(3).y = .ScaleHeight / 3
        P(4).x = 0: P(4).y = .ScaleHeight / 1.5
        P(5).x = .ScaleWidth / 3: P(5).y = .ScaleHeight / 1.5
        P(6).x = .ScaleWidth / 3: P(6).y = .ScaleHeight
        hRgn = CreatePolygonRgn(P(0), &H7, WINDING)
        SetWindowRgn .hwnd, hRgn, True
        DeleteObject hRgn

        '>> Right_Arrow >> Draw Right_Arrow Shape.
        MoveToEx .hdc, 0, .ScaleHeight / 1.5 - 1, Lines
        LineTo .hdc, 0, .ScaleHeight / 3
        LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
        LineTo .hdc, .ScaleWidth / 3, 1
        LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 2
        LineTo .hdc, .ScaleWidth / 3, .ScaleHeight - 1
        LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 1.5 - 1
        LineTo .hdc, 0, .ScaleHeight / 1.5 - 1

        Select Case mButtonStyle
            Case Is = Visual                               '>> Right_Arrow >> Draw Visual Style.
                If MouseDown Then
                    .ForeColor = BDR_VISUAL
                    MoveToEx .hdc, 0, .ScaleHeight / 1.5 - 1, Lines
                    LineTo .hdc, 0, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 3, 1
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 2
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, 1, .ScaleHeight / 1.5 - 2, Lines
                    LineTo .hdc, 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, 3
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2
                Else
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth - 2, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 3
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, 1, .ScaleHeight / 1.5 - 2
                    .ForeColor = BDR_VISUAL2
                    MoveToEx .hdc, 0, .ScaleHeight / 1.5 - 1, Lines
                    LineTo .hdc, 0, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 3, 1
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 2
                End If
            Case Is = Flat                                 '>> Right_Arrow >> Draw Flat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, 0, .ScaleHeight / 1.5 - 1, Lines
                    LineTo .hdc, 0, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 3, 1
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 2
                Else
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, 0, .ScaleHeight / 1.5 - 1, Lines
                    LineTo .hdc, 0, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 3, 1
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 2
                End If
            Case Is = OverFlat                             '>> Right_Arrow >> Draw OverFlat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, 0, .ScaleHeight / 1.5 - 1, Lines
                    LineTo .hdc, 0, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 3, 1
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 2
                ElseIf MouseMove Then
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, 0, .ScaleHeight / 1.5 - 1, Lines
                    LineTo .hdc, 0, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 3, 1
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 2
                End If
            Case Is = Java                                 '>> Right_Arrow >> Draw Java Style.
                If .Enabled Then
                    .ForeColor = BDR_JAVA1
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, 0, .ScaleHeight / 1.5 - 2
                    .ForeColor = BDR_JAVA2
                    MoveToEx .hdc, 1, .ScaleHeight / 1.5 - 2, Lines
                    LineTo .hdc, 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, 3
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 2
                    MoveToEx .hdc, .ScaleWidth - 1, .ScaleHeight / 2, Lines
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight - 1
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 1.5 - 1
                    LineTo .hdc, 0, .ScaleHeight / 1.5 - 1
                End If
            Case Is = WinXp                                '>> Right_Arrow >> Draw WindowsXp Style.
                If MouseDown Then
                    .ForeColor = BDR_PRESSED
                    MoveToEx .hdc, 2, .ScaleHeight / 3 + 2, Lines
                    LineTo .hdc, 2, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight - 5
                    LineTo .hdc, .ScaleWidth - 5, .ScaleHeight / 2
                ElseIf MouseMove Then
                    .ForeColor = BDR_GOLDXP_DARK
                    MoveToEx .hdc, 1, .ScaleHeight / 1.5 - 2, Lines
                    LineTo .hdc, 1, .ScaleHeight / 3
                    .ForeColor = BDR_GOLDXP_NORMAL1
                    MoveToEx .hdc, 2, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2
                    .ForeColor = BDR_GOLDXP_NORMAL2
                    MoveToEx .hdc, 3, .ScaleHeight / 1.5 - 3, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight - 5
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 2
                    .ForeColor = BDR_GOLDXP_LIGHT1
                    MoveToEx .hdc, 3, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, 3
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 2
                    .ForeColor = BDR_GOLDXP_LIGHT2
                    MoveToEx .hdc, 4, .ScaleHeight / 3 + 2, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight / 3 + 2
                    LineTo .hdc, .ScaleWidth / 3 + 2, 5
                    LineTo .hdc, .ScaleWidth - 4, .ScaleHeight / 2
                    '>> Right_Arrow >> Draw Xp FocusRect.
                ElseIf mButtonStyle = WinXp And mFocusRect And mFocused Then
                    .ForeColor = BDR_BLUEXP_DARK
                    MoveToEx .hdc, 1, .ScaleHeight / 1.5 - 2, Lines
                    LineTo .hdc, 1, .ScaleHeight / 3
                    .ForeColor = BDR_BLUEXP_NORMAL1
                    MoveToEx .hdc, 2, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, 2, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2
                    .ForeColor = BDR_BLUEXP_NORMAL2
                    MoveToEx .hdc, 3, .ScaleHeight / 1.5 - 3, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight / 1.5 - 3
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight - 5
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 2
                    .ForeColor = BDR_BLUEXP_LIGHT1
                    MoveToEx .hdc, 3, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, 3
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 2
                    .ForeColor = BDR_BLUEXP_LIGHT2
                    MoveToEx .hdc, 4, .ScaleHeight / 3 + 2, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight / 3 + 2
                    LineTo .hdc, .ScaleWidth / 3 + 2, 5
                    LineTo .hdc, .ScaleWidth - 4, .ScaleHeight / 2
                End If
            Case Is = Vista    '>> Right_Arrow >> Draw Vista Style.
                If MouseDown Then
                    .ForeColor = BDR_VISTA2
                    MoveToEx .hdc, 1, .ScaleHeight / 1.5 - 2, Lines
                    LineTo .hdc, 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, 3
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2 - 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, 1, .ScaleHeight / 1.5 - 2
                Else
                    .ForeColor = BDR_VISTA1
                    MoveToEx .hdc, 1, .ScaleHeight / 1.5 - 2, Lines
                    LineTo .hdc, 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, 3
                    LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2 - 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 3
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                    LineTo .hdc, 1, .ScaleHeight / 1.5 - 2
                    '>> Right_Arrow >> Draw Vista FocusRect.
                    If mButtonStyle = Vista And mFocusRect And mFocused Then
                        .ForeColor = BDR_FOCUSRECT_VISTA
                        MoveToEx .hdc, 1, .ScaleHeight / 1.5 - 2, Lines
                        LineTo .hdc, 1, .ScaleHeight / 3 + 1
                        LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                        LineTo .hdc, .ScaleWidth / 3 + 1, 3
                        LineTo .hdc, .ScaleWidth - 2, .ScaleHeight / 2 - 1
                        LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight - 3
                        LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 1.5 - 2
                        LineTo .hdc, 1, .ScaleHeight / 1.5 - 2
                    End If
                End If
        End Select
        '>> Right_Arrow >> Draw FocusRect.
        If Not mButtonStyle = Java And mFocusRect And mFocused Then
            If Not mButtonStyle = WinXp And mFocusRect And mFocused Then
                If Not mButtonStyle = Vista And mFocusRect And mFocused Then
                    .ForeColor = BDR_FOCUSRECT
                    PL(0).x = .ScaleWidth - 7: PL(0).y = .ScaleHeight / 2
                    PL(1).x = .ScaleWidth / 3 + 4: PL(1).y = 9
                    PL(2).x = .ScaleWidth / 3 + 4: PL(2).y = .ScaleHeight / 3 + 4
                    PL(3).x = 4: PL(3).y = .ScaleHeight / 3 + 4
                    PL(4).x = 4: PL(4).y = .ScaleHeight / 1.5 - 5
                    PL(5).x = .ScaleWidth / 3 + 4: PL(5).y = .ScaleHeight / 1.5 - 5
                    PL(6).x = .ScaleWidth / 3 + 4: PL(6).y = .ScaleHeight - 10
                    Polygon .hdc, PL(0), &H7
                End If
            End If
        End If
    End With
End Sub
Private Sub Redraw_Down_Arrow()
    With UserControl
        '>> Down_Arrow >> Make Down_Arrow Shape.
        P(0).x = .ScaleWidth / 2: P(0).y = .ScaleHeight
        P(1).x = 0: P(1).y = .ScaleHeight / 3
        P(2).x = .ScaleWidth / 3: P(2).y = .ScaleHeight / 3
        P(3).x = .ScaleWidth / 3: P(3).y = 0
        P(4).x = .ScaleWidth / 1.5: P(4).y = 0
        P(5).x = .ScaleWidth / 1.5: P(5).y = .ScaleHeight / 3
        P(6).x = .ScaleWidth: P(6).y = .ScaleHeight / 3
        hRgn = CreatePolygonRgn(P(0), &H7, WINDING)
        SetWindowRgn .hwnd, hRgn, True
        DeleteObject hRgn

        '>> Down_Arrow >> Draw Down_Arrow Shape.
        MoveToEx .hdc, .ScaleWidth / 1.5, 0, Lines
        LineTo .hdc, .ScaleWidth / 3, 0
        LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
        LineTo .hdc, 1, .ScaleHeight / 3
        LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
        LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 3
        LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight / 3
        LineTo .hdc, .ScaleWidth / 1.5 - 1, 0

        Select Case mButtonStyle
            Case Is = Visual                               '>> Down_Arrow >> Draw Visual Style.
                If MouseDown Then
                    .ForeColor = BDR_VISUAL
                    MoveToEx .hdc, .ScaleWidth / 1.5, 0, Lines
                    LineTo .hdc, .ScaleWidth / 3, 0
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
                    LineTo .hdc, 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth / 1.5 - 1, 1, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 1, 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, 3, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                Else
                    .ForeColor = BDR_VISUAL1
                    MoveToEx .hdc, .ScaleWidth / 1.5 - 2, 1, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                    MoveToEx .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1, Lines
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 3
                    .ForeColor = BDR_VISUAL2
                    MoveToEx .hdc, .ScaleWidth / 1.5, 0, Lines
                    LineTo .hdc, .ScaleWidth / 3, 0
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
                    LineTo .hdc, 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                End If
            Case Is = Flat                                 '>> Down_Arrow >> Draw Flat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth / 1.5, 0, Lines
                    LineTo .hdc, .ScaleWidth / 3, 0
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
                    LineTo .hdc, 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                Else
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth / 1.5, 0, Lines
                    LineTo .hdc, .ScaleWidth / 3, 0
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
                    LineTo .hdc, 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                End If
            Case Is = OverFlat                             '>> Down_Arrow >> Draw OverFlat Style.
                If MouseDown Then
                    .ForeColor = BDR_FLAT1
                    MoveToEx .hdc, .ScaleWidth / 1.5, 0, Lines
                    LineTo .hdc, .ScaleWidth / 3, 0
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
                    LineTo .hdc, 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                ElseIf MouseMove Then
                    .ForeColor = BDR_FLAT2
                    MoveToEx .hdc, .ScaleWidth / 1.5, 0, Lines
                    LineTo .hdc, .ScaleWidth / 3, 0
                    LineTo .hdc, .ScaleWidth / 3, .ScaleHeight / 3
                    LineTo .hdc, 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                End If
            Case Is = Java                                 '>> Down_Arrow >> Draw Java Style.
                If .Enabled Then
                    .ForeColor = BDR_JAVA1
                    MoveToEx .hdc, .ScaleWidth / 1.5 - 2, 2, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 3
                    .ForeColor = BDR_JAVA2
                    MoveToEx .hdc, .ScaleWidth / 3 + 1, 1, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 + 1, 1
                    MoveToEx .hdc, .ScaleWidth / 3 + 1, 2, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, 3, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 3
                    MoveToEx .hdc, .ScaleWidth / 1.5 - 1, 2, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth - 1, .ScaleHeight / 3
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 1
                End If
            Case Is = WinXp                                '>> Down_Arrow >> Draw WindowsXp Style.
                If MouseDown Then
                    .ForeColor = BDR_PRESSED
                    MoveToEx .hdc, .ScaleWidth / 3 + 3, 2, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, 2
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight / 3 + 2
                    LineTo .hdc, .ScaleWidth - 5, .ScaleHeight / 3 + 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 4
                ElseIf MouseMove Then
                    .ForeColor = BDR_GOLDXP_DARK
                    MoveToEx .hdc, .ScaleWidth / 3 + 1, 1, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, 1
                    .ForeColor = BDR_GOLDXP_NORMAL1
                    MoveToEx .hdc, .ScaleWidth / 3 + 1, 1, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                    .ForeColor = BDR_GOLDXP_NORMAL2
                    MoveToEx .hdc, .ScaleWidth / 1.5 - 3, 2, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight / 3 + 2
                    LineTo .hdc, .ScaleWidth - 5, .ScaleHeight / 3 + 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 4
                    .ForeColor = BDR_GOLDXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth / 3 + 1, 2, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, 3, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 3
                    .ForeColor = BDR_GOLDXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth / 3 + 2, 3, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight / 3 + 2
                    LineTo .hdc, 4, .ScaleHeight / 3 + 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 4
                    '>> Down_Arrow >> Draw Xp FocusRect.
                ElseIf mButtonStyle = WinXp And mFocusRect And mFocused Then
                    .ForeColor = BDR_BLUEXP_DARK
                    MoveToEx .hdc, .ScaleWidth / 3 + 1, 1, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 1, 1
                    .ForeColor = BDR_BLUEXP_NORMAL1
                    MoveToEx .hdc, .ScaleWidth / 3 + 1, 1, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 2
                    .ForeColor = BDR_BLUEXP_NORMAL2
                    MoveToEx .hdc, .ScaleWidth / 1.5 - 3, 2, Lines
                    LineTo .hdc, .ScaleWidth / 1.5 - 3, .ScaleHeight / 3 + 2
                    LineTo .hdc, .ScaleWidth - 5, .ScaleHeight / 3 + 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 4
                    .ForeColor = BDR_BLUEXP_LIGHT1
                    MoveToEx .hdc, .ScaleWidth / 3 + 1, 2, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, 3, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 3
                    .ForeColor = BDR_BLUEXP_LIGHT2
                    MoveToEx .hdc, .ScaleWidth / 3 + 2, 3, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 2, .ScaleHeight / 3 + 2
                    LineTo .hdc, 4, .ScaleHeight / 3 + 2
                    LineTo .hdc, .ScaleWidth / 2, .ScaleHeight - 4
                End If
            Case Is = Vista    '>> Down_Arrow >> Draw Vista Style.
                If MouseDown Then
                    .ForeColor = BDR_VISTA2
                    MoveToEx .hdc, .ScaleWidth / 1.5, 1, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 1, 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, 3, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 2 - 1, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, 1
                Else
                    .ForeColor = BDR_VISTA1
                    MoveToEx .hdc, .ScaleWidth / 1.5, 1, Lines
                    LineTo .hdc, .ScaleWidth / 3 + 1, 1
                    LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                    LineTo .hdc, 3, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 2 - 1, .ScaleHeight - 2
                    LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                    LineTo .hdc, .ScaleWidth / 1.5 - 2, 1
                    '>> Down_Arrow >> Draw Vista FocusRect.
                    If mButtonStyle = Vista And mFocusRect And mFocused Then
                        .ForeColor = BDR_FOCUSRECT_VISTA
                        MoveToEx .hdc, .ScaleWidth / 1.5, 1, Lines
                        LineTo .hdc, .ScaleWidth / 3 + 1, 1
                        LineTo .hdc, .ScaleWidth / 3 + 1, .ScaleHeight / 3 + 1
                        LineTo .hdc, 3, .ScaleHeight / 3 + 1
                        LineTo .hdc, .ScaleWidth / 2 - 1, .ScaleHeight - 2
                        LineTo .hdc, .ScaleWidth - 3, .ScaleHeight / 3 + 1
                        LineTo .hdc, .ScaleWidth / 1.5 - 2, .ScaleHeight / 3 + 1
                        LineTo .hdc, .ScaleWidth / 1.5 - 2, 1
                    End If
                End If
        End Select
        '>> Down_Arrow >> Draw FocusRect.
        If Not mButtonStyle = Java And mFocusRect And mFocused Then
            If Not mButtonStyle = WinXp And mFocusRect And mFocused Then
                If Not mButtonStyle = Vista And mFocusRect And mFocused Then
                    .ForeColor = BDR_FOCUSRECT
                    PL(0).x = .ScaleWidth / 2: PL(0).y = .ScaleHeight - 7
                    PL(1).x = 9: PL(1).y = .ScaleHeight / 3 + 4
                    PL(2).x = .ScaleWidth / 3 + 4: PL(2).y = .ScaleHeight / 3 + 4
                    PL(3).x = .ScaleWidth / 3 + 4: PL(3).y = 4
                    PL(4).x = .ScaleWidth / 1.5 - 5: PL(4).y = 4
                    PL(5).x = .ScaleWidth / 1.5 - 5: PL(5).y = .ScaleHeight / 3 + 4
                    PL(6).x = .ScaleWidth - 10: PL(6).y = .ScaleHeight / 3 + 4
                    Polygon .hdc, PL(0), &H7
                End If
            End If
        End If
    End With
End Sub
Private Sub UserControl_Resize()
    Call UserControl_Paint
End Sub
Private Sub UserControl_Show()
    Call UserControl_Paint
End Sub
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    '>> Load Saved Property Values
    'On Local Error Resume Next
    With PropBag
        mButtonShape = .ReadProperty("ButtonShape", Rectangle)
        mButtonStyle = .ReadProperty("ButtonStyle", Visual)
        mButtonStyleColors = .ReadProperty("ButtonStyleColors", SingleColor)
        mButtonTheme = .ReadProperty("ButtonTheme", NoTheme)
        mButtonType = .ReadProperty("ButtonType", Button)
        mCaptionAlignment = .ReadProperty("CaptionAlignment", CenterCaption)
        mCaptionEffect = .ReadProperty("CaptionEffect", Default)
        mCaptionStyle = .ReadProperty("CaptionStyle", Normal)
        mDropDown = .ReadProperty("DropDown", None)
        mPictureAlignment = .ReadProperty("PictureAlignment", CenterPicture)

        mBackColor = .ReadProperty("BackColor", vbButtonFace)
        mBackColorPressed = .ReadProperty("BackColorPressed", vbButtonFace)
        mBackColorHover = .ReadProperty("BackColorHover", vbButtonFace)

        mBorderColor = .ReadProperty("BorderColor", vbBlack)
        mBorderColorPressed = .ReadProperty("BorderColorPressed", vbBlack)
        mBorderColorHover = .ReadProperty("BorderColorHover", vbBlack)

        mForeColor = .ReadProperty("ForeColor", vbBlack)
        mForeColorPressed = .ReadProperty("ForeColorPressed", vbRed)
        mForeColorHover = .ReadProperty("ForeColorHover", vbBlue)

        mEffectColor = .ReadProperty("EffectColor", vbWhite)

        mCaption = .ReadProperty("Caption", UserControl.name)
        mFocusRect = .ReadProperty("FocusRect", True)
        mValue = .ReadProperty("Value", False)
        mHandPointer = .ReadProperty("HandPointer", False)
        Set mPicture = .ReadProperty("Picture", Nothing)
        mPictureGray = .ReadProperty("PictureGray", False)

        UserControl.Enabled = .ReadProperty("Enabled", True)
        Set Font = .ReadProperty("Font", Ambient.Font)
        Set MouseIcon = .ReadProperty("MouseIcon", Nothing)
        UserControl.MousePointer = .ReadProperty("MousePointer", 0)
    End With
End Sub
Private Sub UserControl_Terminate()
    DeleteObject hRgn                                      '>> Remove The Region From Memory
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    '>> Save Property Values
    'On Local Error Resume Next
    With PropBag
        .WriteProperty "ButtonShape", mButtonShape, Rectangle
        .WriteProperty "ButtonStyle", mButtonStyle, Visual
        .WriteProperty "ButtonStyleColors", mButtonStyleColors, SingleColor
        .WriteProperty "ButtonTheme", mButtonTheme, NoTheme
        .WriteProperty "ButtonType", mButtonType, Button
        .WriteProperty "CaptionAlignment", mCaptionAlignment, CenterCaption
        .WriteProperty "CaptionEffect", mCaptionEffect, Default
        .WriteProperty "CaptionStyle", mCaptionStyle, Normal
        .WriteProperty "DropDown", mDropDown, None
        .WriteProperty "PictureAlignment", mPictureAlignment, CenterPicture

        .WriteProperty "BackColor", mBackColor, vbButtonFace
        .WriteProperty "BackColorPressed", mBackColorPressed, vbButtonFace
        .WriteProperty "BackColorHover", mBackColorHover, vbButtonFace

        .WriteProperty "BorderColor", mBorderColor, vbBlack
        .WriteProperty "BorderColorPressed", mBorderColorPressed, vbBlack
        .WriteProperty "BorderColorHover", mBorderColorHover, vbBlack

        .WriteProperty "ForeColor", mForeColor, vbBlack
        .WriteProperty "ForeColorPressed", mForeColorPressed, vbRed
        .WriteProperty "ForeColorHover", mForeColorHover, vbBlue

        .WriteProperty "EffectColor", mEffectColor, vbWhite

        .WriteProperty "Caption", mCaption, UserControl.name
        .WriteProperty "FocusRect", mFocusRect, True
        .WriteProperty "Value", mValue, False
        .WriteProperty "HandPointer", mHandPointer, False
        .WriteProperty "Picture", mPicture, Nothing
        .WriteProperty "PictureGray", mPictureGray, False

        .WriteProperty "Enabled", UserControl.Enabled, True
        .WriteProperty "Font", UserControl.Font, Ambient.Font
        .WriteProperty "MouseIcon", UserControl.MouseIcon, Nothing
        .WriteProperty "MousePointer", UserControl.MousePointer, 0
    End With
End Sub



