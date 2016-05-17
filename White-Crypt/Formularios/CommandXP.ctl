VERSION 5.00
Begin VB.UserControl CommandXP 
   AutoRedraw      =   -1  'True
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   DefaultCancel   =   -1  'True
   ScaleHeight     =   240
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   320
   Begin VB.Timer OverTimer 
      Enabled         =   0   'False
      Interval        =   3
      Left            =   0
      Top             =   0
   End
End
Attribute VB_Name = "CommandXP"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

#Const isOCX = False

Private Const cbVersion As String = "2.0.6 B"

Private Declare Function SetPixel Lib "gdi32" Alias "SetPixelV" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal crColor As Long) As Long
Private Declare Function GetNearestColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long

Private Declare Function GetSysColor Lib "user32" (ByVal nIndex As Long) As Long
Private Const COLOR_HIGHLIGHT = 13
Private Const COLOR_BTNFACE = 15
Private Const COLOR_BTNSHADOW = 16
Private Const COLOR_BTNTEXT = 18
Private Const COLOR_BTNHIGHLIGHT = 20
Private Const COLOR_BTNDKSHADOW = 21
Private Const COLOR_BTNLIGHT = 22

Private Declare Function OleTranslateColor Lib "oleaut32.dll" (ByVal lOleColor As Long, ByVal lHPalette As Long, lColorRef As Long) As Long
Private Declare Function GetBkColor Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function GetTextColor Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function SetTextColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
Private Declare Function DrawText Lib "user32" Alias "DrawTextA" (ByVal hdc As Long, ByVal lpStr As String, ByVal nCount As Long, lpRect As RECT, ByVal wFormat As Long) As Long
Private Const DT_CALCRECT = &H400
Private Const DT_WORDBREAK = &H10
Private Const DT_CENTER = &H1 Or DT_WORDBREAK Or &H4

Private Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
Private Declare Function FillRect Lib "user32" (ByVal hdc As Long, lpRect As RECT, ByVal hBrush As Long) As Long
Private Declare Function FrameRect Lib "user32" (ByVal hdc As Long, lpRect As RECT, ByVal hBrush As Long) As Long
Private Declare Function DrawFocusRect Lib "user32" (ByVal hdc As Long, lpRect As RECT) As Long
Private Declare Function Ellipse Lib "gdi32" (ByVal hdc As Long, ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long

Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long

Private Declare Function MoveToEx Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, lpPoint As POINTAPI) As Long
Private Declare Function LineTo Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long) As Long
Private Declare Function CreatePen Lib "gdi32" (ByVal nPenStyle As Long, ByVal nWidth As Long, ByVal crColor As Long) As Long
Private Const PS_SOLID = 0

Private Declare Function CreateRectRgn Lib "gdi32" (ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
Private Declare Function CreateEllipticRgn Lib "gdi32" (ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
Private Declare Function CombineRgn Lib "gdi32" (ByVal hDestRgn As Long, ByVal hSrcRgn1 As Long, ByVal hSrcRgn2 As Long, ByVal nCombineMode As Long) As Long
Private Declare Function SetWindowRgn Lib "user32" (ByVal hwnd As Long, ByVal hRgn As Long, ByVal bRedraw As Long) As Long
Private Const RGN_DIFF = 4

Private Declare Function GetWindowRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
Private Declare Function GetClientRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
Private Declare Function InflateRect Lib "user32" (lpRect As RECT, ByVal X As Long, ByVal Y As Long) As Long
Private Declare Function OffsetRect Lib "user32" (lpRect As RECT, ByVal X As Long, ByVal Y As Long) As Long
Private Declare Function CopyRect Lib "user32" (lpDestRect As RECT, lpSourceRect As RECT) As Long

Private Declare Function WindowFromPoint Lib "user32" (ByVal xPoint As Long, ByVal yPoint As Long) As Long
Private Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long

Private Declare Function SetCapture Lib "user32" (ByVal hwnd As Long) As Long

Private Declare Function ReleaseDC Lib "user32" (ByVal hwnd As Long, ByVal hdc As Long) As Long
Private Declare Function GetDC Lib "user32" (ByVal hwnd As Long) As Long
Private Declare Function GetParent Lib "user32" (ByVal hwnd As Long) As Long

Private Declare Function GetDIBits Lib "gdi32" (ByVal aHDC As Long, ByVal hBitmap As Long, ByVal nStartScan As Long, ByVal nNumScans As Long, lpBits As Any, lpBI As BITMAPINFO, ByVal wUsage As Long) As Long
Private Declare Function SetDIBitsToDevice Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal dx As Long, ByVal dy As Long, ByVal SrcX As Long, ByVal SrcY As Long, ByVal Scan As Long, ByVal NumScans As Long, Bits As Any, BitsInfo As BITMAPINFO, ByVal wUsage As Long) As Long

Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hdc As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Private Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function DrawIconEx Lib "user32" (ByVal hdc As Long, ByVal xLeft As Long, ByVal yTop As Long, ByVal hIcon As Long, ByVal cxWidth As Long, ByVal cyWidth As Long, ByVal istepIfAniCur As Long, ByVal hbrFlickerFreeDraw As Long, ByVal diFlags As Long) As Long
Private Declare Function CreateBitmap Lib "gdi32" (ByVal nWidth As Long, ByVal nHeight As Long, ByVal nPlanes As Long, ByVal nBitCount As Long, lpBits As Any) As Long
Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal nIndex As Long) As Long

Private Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

Private Type POINTAPI
    X As Long
    Y As Long
End Type

Private Type BITMAPINFOHEADER
    biSize As Long
    biWidth As Long
    biHeight As Long
    biPlanes As Integer
    biBitCount As Integer
    biCompression As Long
    biSizeImage As Long
    biXPelsPerMeter As Long
    biYPelsPerMeter As Long
    biClrUsed As Long
    biClrImportant As Long
End Type

Private Type RGBTRIPLE
    rgbBlue As Byte
    rgbGreen As Byte
    rgbRed As Byte
End Type

Private Type BITMAPINFO
    bmiHeader As BITMAPINFOHEADER
    bmiColors As RGBTRIPLE
End Type

Public Enum ButtonTypes
    [Windows 16-bit] = 1    'the old-fashioned Win16 button
    [Windows 32-bit] = 2    'the classic windows button
    [Windows XP] = 3        'the new brand XP button totally owner-drawn
    [Mac] = 4               'i suppose it looks exactly as a Mac button... i took the style from a GetRight skin!!!
    [Java metal] = 5        'there are also other styles but not so different from windows one
    [Netscape 6] = 6        'this is the button displayed in web-pages, it also appears in some java apps
    [Simple Flat] = 7       'the standard flat button seen on toolbars
    [Flat Highlight] = 8    'again the flat button but this one has no border until the mouse is over it
    [Office XP] = 9         'the new Office XP button
    '[MacOS-X] = 10         'this is a plan for the future...
    [Transparent] = 11      'suggested from a user...
    [3D Hover] = 12         'took this one from "Noteworthy Composer" toolbal
    [Oval Flat] = 13        'a simple Oval Button
    [KDE 2] = 14            'the great standard KDE2 button!
End Enum

Public Enum ColorTypes
    [Use Windows] = 1
    [Custom] = 2
    [Force Standard] = 3
    [Use Container] = 4
End Enum

Public Enum PicPositions
    cbLeft = 0
    cbRight = 1
    cbTop = 2
    cbBottom = 3
    cbBackground = 4
End Enum

Public Enum fx
    cbNone = 0
    cbEmbossed = 1
    cbEngraved = 2
    cbShadowed = 3
End Enum

Private Const FXDEPTH As Long = &H28

'events
Public Event Click()
Attribute Click.VB_UserMemId = -600
Attribute Click.VB_MemberFlags = "200"
Public Event MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event KeyPress(KeyAscii As Integer)
Public Event KeyDown(KeyCode As Integer, Shift As Integer)
Public Event KeyUp(KeyCode As Integer, Shift As Integer)
Public Event MouseOver()
Public Event MouseOut()

'variables
Private MyButtonType As ButtonTypes
Private MyColorType As ColorTypes
Private PicPosition As PicPositions
Private SFX As fx 'font and picture effects

Private He As Long  'the height of the button
Private Wi As Long  'the width of the button

Private BackC As Long 'back color
Private BackO As Long 'back color when mouse is over
Private ForeC As Long 'fore color
Private ForeO As Long 'fore color when mouse is over
Private MaskC As Long 'mask color
Private OXPb As Long, OXPf As Long
Private useMask As Boolean, useGrey As Boolean
Private useHand As Boolean

Private picNormal As StdPicture, picHover As StdPicture
Private pDC As Long, pBM As Long, oBM As Long 'used for the treansparent button

Private elTex As String     'current text

Private rc As RECT, rc2 As RECT, rc3 As RECT, fc As POINTAPI 'text and focus rect locations
Private picPT As POINTAPI, picSZ As POINTAPI  'picture Position & Size
Private rgnNorm As Long

Private LastButton As Byte, LastKeyDown As Byte
Private isEnabled As Boolean, isSoft As Boolean
Private HasFocus As Boolean, showFocusR As Boolean

Private cFace As Long, cLight As Long, cHighLight As Long, cShadow As Long, cDarkShadow As Long, cText As Long, cTextO As Long, cFaceO As Long, cMask As Long, XPFace As Long

Private lastStat As Byte, TE As String, isShown As Boolean  'used to avoid unnecessary repaints
Private isOver As Boolean, inLoop As Boolean

Private Locked As Boolean

Private captOpt As Long
Private isCheckbox As Boolean, cValue As Boolean

Private Sub OverTimer_Timer()

    If Not isMouseOver Then
        OverTimer.Enabled = False
        isOver = False
        Call Redraw(0, True)
        RaiseEvent MouseOut
    End If

End Sub

Private Sub UserControl_AccessKeyPress(KeyAscii As Integer)

    LastButton = 1
    Call UserControl_Click

End Sub

Private Sub UserControl_AmbientChanged(PropertyName As String)

    Call SetColors
    Call Redraw(lastStat, True)

End Sub

Private Sub UserControl_Click()

    If LastButton = 1 And isEnabled Then
        If isCheckbox Then cValue = Not cValue
        Call Redraw(0, True) 'be sure that the normal status is drawn
        UserControl.Refresh
        RaiseEvent Click
    End If

End Sub

Private Sub UserControl_DblClick()

    If LastButton = 1 Then
        Call UserControl_MouseDown(1, 0, 0, 0)
        SetCapture hwnd
    End If

End Sub

Private Sub UserControl_GotFocus()

    HasFocus = True
    Call Redraw(lastStat, True)

End Sub

Private Sub UserControl_Hide()

    isShown = False

End Sub

Private Sub UserControl_Initialize()

'this makes the control to be slow, remark this line if the "not redrawing" problem is not important for you: ie, you intercept the Load_Event (with breakpoint or messageBox) and the button does not repaint...

    isShown = True

End Sub

Private Sub UserControl_KeyDown(KeyCode As Integer, Shift As Integer)

    RaiseEvent KeyDown(KeyCode, Shift)

    LastKeyDown = KeyCode
    Select Case KeyCode
    Case 32 'spacebar pressed
        Call Redraw(2, False)
    Case 39, 40 'right and down arrows
        SendKeys "{Tab}"
    Case 37, 38 'left and up arrows
        SendKeys "+{Tab}"
    End Select

End Sub

Private Sub UserControl_KeyPress(KeyAscii As Integer)

    RaiseEvent KeyPress(KeyAscii)

End Sub

Private Sub UserControl_KeyUp(KeyCode As Integer, Shift As Integer)

    RaiseEvent KeyUp(KeyCode, Shift)

    If (KeyCode = 32) And (LastKeyDown = 32) Then 'spacebar pressed, and not cancelled by the user
        If isCheckbox Then cValue = Not cValue
        Call Redraw(0, False)
        UserControl.Refresh
        RaiseEvent Click
    End If

End Sub

Private Sub UserControl_LostFocus()

    HasFocus = False
    Call Redraw(lastStat, True)

End Sub

Private Sub UserControl_InitProperties()

    isEnabled = True: showFocusR = True: useMask = True
    elTex = Ambient.DisplayName
    Set UserControl.Font = Ambient.Font
    MyButtonType = [Windows 32-bit]
    MyColorType = [Use Windows]
    Call SetColors
    BackC = cFace: BackO = BackC
    ForeC = cText: ForeO = ForeC
    MaskC = &HC0C0C0
    Call CalcTextRects

End Sub

Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    RaiseEvent MouseDown(Button, Shift, X, Y)
    LastButton = Button
    If Button <> 2 Then Call Redraw(2, False)

End Sub

Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    RaiseEvent MouseMove(Button, Shift, X, Y)
    If Button < 2 Then
        If Not isMouseOver Then
            'we are outside the button
            Call Redraw(0, False)
        Else
            'we are inside the button
            If Button = 0 And Not isOver Then
                OverTimer.Enabled = True
                isOver = True
                Call Redraw(0, True)
                RaiseEvent MouseOver
            ElseIf Button = 1 Then
                isOver = True
                Call Redraw(2, False)
                isOver = False
            End If
        End If
    End If

End Sub

Private Sub UserControl_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    RaiseEvent MouseUp(Button, Shift, X, Y)
    If Button <> 2 Then Call Redraw(0, False)

End Sub

'########## BUTTON PROPERTIES ##########
Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_ProcData.VB_Invoke_Property = ";Appearance"
Attribute BackColor.VB_UserMemId = -501

    BackColor = BackC

End Property

Public Property Let BackColor(ByVal theCol As OLE_COLOR)

    BackC = theCol
    If Not Ambient.UserMode Then BackO = theCol
    Call SetColors
    Call Redraw(lastStat, True)
    PropertyChanged "BCOL"

End Property

Public Property Get BackOver() As OLE_COLOR
Attribute BackOver.VB_ProcData.VB_Invoke_Property = ";Appearance"

    BackOver = BackO

End Property

Public Property Let BackOver(ByVal theCol As OLE_COLOR)

    BackO = theCol
    Call SetColors
    Call Redraw(lastStat, True)
    PropertyChanged "BCOLO"

End Property

Public Property Get ForeColor() As OLE_COLOR
Attribute ForeColor.VB_ProcData.VB_Invoke_Property = ";Appearance"
Attribute ForeColor.VB_UserMemId = -513

    ForeColor = ForeC

End Property

Public Property Let ForeColor(ByVal theCol As OLE_COLOR)

    ForeC = theCol
    If Not Ambient.UserMode Then ForeO = theCol
    Call SetColors
    Call Redraw(lastStat, True)
    PropertyChanged "FCOL"

End Property

Public Property Get ForeOver() As OLE_COLOR
Attribute ForeOver.VB_ProcData.VB_Invoke_Property = ";Appearance"

    ForeOver = ForeO

End Property

Public Property Let ForeOver(ByVal theCol As OLE_COLOR)

    ForeO = theCol
    Call SetColors
    Call Redraw(lastStat, True)
    PropertyChanged "FCOLO"

End Property

Public Property Get MaskColor() As OLE_COLOR
Attribute MaskColor.VB_ProcData.VB_Invoke_Property = ";Appearance"

    MaskColor = MaskC

End Property

Public Property Let MaskColor(ByVal theCol As OLE_COLOR)

    MaskC = theCol
    Call SetColors
    Call Redraw(lastStat, True)
    PropertyChanged "MCOL"

End Property

Public Property Get ButtonType() As ButtonTypes
Attribute ButtonType.VB_ProcData.VB_Invoke_Property = ";Appearance"

    ButtonType = MyButtonType

End Property

Public Property Let ButtonType(ByVal newValue As ButtonTypes)

    MyButtonType = newValue
    If MyButtonType = [Java metal] And Not Ambient.UserMode Then
        UserControl.FontBold = True
    ElseIf MyButtonType = 11 And isShown Then
        Call GetParentPic
    End If
    Call UserControl_Resize
    PropertyChanged "BTYPE"

End Property

Public Property Get Caption() As String
Attribute Caption.VB_ProcData.VB_Invoke_Property = ";Text"
Attribute Caption.VB_UserMemId = -518

    Caption = elTex

End Property

Public Property Let Caption(ByVal newValue As String)

    elTex = newValue
    Call SetAccessKeys
    Call CalcTextRects
    Call Redraw(0, True)
    PropertyChanged "TX"

End Property

Public Property Get Enabled() As Boolean
Attribute Enabled.VB_ProcData.VB_Invoke_Property = ";Behavior"
Attribute Enabled.VB_UserMemId = -514

    Enabled = isEnabled

End Property

Public Property Let Enabled(ByVal newValue As Boolean)

    isEnabled = newValue
    Call Redraw(0, True)
    UserControl.Enabled = isEnabled
    PropertyChanged "ENAB"

End Property

Public Property Get Font() As Font
Attribute Font.VB_ProcData.VB_Invoke_Property = ";Font"
Attribute Font.VB_UserMemId = -512

    Set Font = UserControl.Font

End Property

Public Property Set Font(ByRef newFont As Font)

    Set UserControl.Font = newFont
    Call CalcTextRects
    Call Redraw(0, True)
    PropertyChanged "FONT"

End Property

Public Property Get FontBold() As Boolean
Attribute FontBold.VB_MemberFlags = "400"

    FontBold = UserControl.FontBold

End Property

Public Property Let FontBold(ByVal newValue As Boolean)

    UserControl.FontBold = newValue
    Call CalcTextRects
    Call Redraw(0, True)

End Property

Public Property Get FontItalic() As Boolean
Attribute FontItalic.VB_MemberFlags = "400"

    FontItalic = UserControl.FontItalic

End Property

Public Property Let FontItalic(ByVal newValue As Boolean)

    UserControl.FontItalic = newValue
    Call CalcTextRects
    Call Redraw(0, True)

End Property

Public Property Get FontUnderline() As Boolean
Attribute FontUnderline.VB_MemberFlags = "400"

    FontUnderline = UserControl.FontUnderline

End Property

Public Property Let FontUnderline(ByVal newValue As Boolean)

    UserControl.FontUnderline = newValue
    Call CalcTextRects
    Call Redraw(0, True)

End Property

Public Property Get FontSize() As Integer
Attribute FontSize.VB_MemberFlags = "400"

    FontSize = UserControl.FontSize

End Property

Public Property Let FontSize(ByVal newValue As Integer)

    UserControl.FontSize = newValue
    Call CalcTextRects
    Call Redraw(0, True)

End Property

Public Property Get FontName() As String
Attribute FontName.VB_MemberFlags = "400"

    FontName = UserControl.FontName

End Property

Public Property Let FontName(ByVal newValue As String)

    UserControl.FontName = newValue
    Call CalcTextRects
    Call Redraw(0, True)

End Property

'it is very common that a windows user uses custom color
'schemes to view his/her desktop, and is also very
'common that this color scheme has weird colors that
'would alter the nice look of my buttons.
'So if you want to force the button to use the windows
'standard colors you may change this property to "Force Standard"

Public Property Get ColorScheme() As ColorTypes
Attribute ColorScheme.VB_ProcData.VB_Invoke_Property = ";Appearance"

    ColorScheme = MyColorType

End Property

Public Property Let ColorScheme(ByVal newValue As ColorTypes)

    MyColorType = newValue
    Call SetColors
    Call Redraw(0, True)
    PropertyChanged "COLTYPE"

End Property

Public Property Get ShowFocusRect() As Boolean
Attribute ShowFocusRect.VB_ProcData.VB_Invoke_Property = ";Appearance"

    ShowFocusRect = showFocusR

End Property

Public Property Let ShowFocusRect(ByVal newValue As Boolean)

    showFocusR = newValue
    Call Redraw(lastStat, True)
    PropertyChanged "FOCUSR"

End Property

Public Property Get MousePointer() As MousePointerConstants
Attribute MousePointer.VB_ProcData.VB_Invoke_Property = ";Appearance"

    MousePointer = UserControl.MousePointer

End Property

Public Property Let MousePointer(ByVal newPointer As MousePointerConstants)

    UserControl.MousePointer = newPointer
    PropertyChanged "MPTR"

End Property

Public Property Get MouseIcon() As StdPicture
Attribute MouseIcon.VB_ProcData.VB_Invoke_Property = ";Appearance"

    Set MouseIcon = UserControl.MouseIcon

End Property

Public Property Set MouseIcon(ByVal newIcon As StdPicture)

    On Local Error Resume Next
        Set UserControl.MouseIcon = newIcon
        PropertyChanged "MICON"
    On Error GoTo 0

End Property

Public Property Get HandPointer() As Boolean

    HandPointer = useHand

End Property

Public Property Let HandPointer(ByVal newVal As Boolean)

    useHand = newVal
    If useHand Then
        Set UserControl.MouseIcon = LoadResPicture(101, 2)
        UserControl.MousePointer = 99
    Else
        Set UserControl.MouseIcon = Nothing
        UserControl.MousePointer = 1
    End If
    PropertyChanged "HAND"

End Property

Public Property Get hwnd() As Long
Attribute hwnd.VB_UserMemId = -515

    hwnd = UserControl.hwnd

End Property

Public Property Get SoftBevel() As Boolean
Attribute SoftBevel.VB_ProcData.VB_Invoke_Property = ";Appearance"

    SoftBevel = isSoft

End Property

Public Property Let SoftBevel(ByVal newValue As Boolean)

    isSoft = newValue
    Call SetColors
    Call Redraw(lastStat, True)
    PropertyChanged "SOFT"

End Property

Public Property Get PictureNormal() As StdPicture
Attribute PictureNormal.VB_ProcData.VB_Invoke_Property = ";Appearance"

    Set PictureNormal = picNormal

End Property

Public Property Set PictureNormal(ByVal newPic As StdPicture)

    Set picNormal = newPic
    Call CalcPicSize
    Call CalcTextRects
    Call Redraw(lastStat, True)
    PropertyChanged "PICN"

End Property

Public Property Get PictureOver() As StdPicture
Attribute PictureOver.VB_ProcData.VB_Invoke_Property = ";Appearance"

    Set PictureOver = picHover

End Property

Public Property Set PictureOver(ByVal newPic As StdPicture)

    Set picHover = newPic
    If isOver Then Call Redraw(lastStat, True) 'only redraw i we need to see this picture immediately
    PropertyChanged "PICO"

End Property

Public Property Get PicturePosition() As PicPositions
Attribute PicturePosition.VB_ProcData.VB_Invoke_Property = ";Position"

    PicturePosition = PicPosition

End Property

Public Property Let PicturePosition(ByVal newPicPos As PicPositions)

    PicPosition = newPicPos
    PropertyChanged "PICPOS"
    Call CalcTextRects
    Call Redraw(lastStat, True)

End Property

Public Property Get UseMaskColor() As Boolean
Attribute UseMaskColor.VB_ProcData.VB_Invoke_Property = ";Appearance"

    UseMaskColor = useMask

End Property

Public Property Let UseMaskColor(ByVal newValue As Boolean)

    useMask = newValue
    If Not picNormal Is Nothing Then Call Redraw(lastStat, True)
    PropertyChanged "UMCOL"

End Property

Public Property Get UseGreyscale() As Boolean
Attribute UseGreyscale.VB_ProcData.VB_Invoke_Property = ";Appearance"

    UseGreyscale = useGrey

End Property

Public Property Let UseGreyscale(ByVal newValue As Boolean)

    useGrey = newValue
    If Not picNormal Is Nothing Then Call Redraw(lastStat, True)
    PropertyChanged "NGREY"

End Property

Public Property Get SpecialEffect() As fx
Attribute SpecialEffect.VB_ProcData.VB_Invoke_Property = ";Appearance"

    SpecialEffect = SFX

End Property

Public Property Let SpecialEffect(ByVal newValue As fx)

    SFX = newValue
    Call Redraw(lastStat, True)
    PropertyChanged "FX"

End Property

Public Property Get CheckBoxBehaviour() As Boolean

    CheckBoxBehaviour = isCheckbox

End Property

Public Property Let CheckBoxBehaviour(ByVal newValue As Boolean)

    isCheckbox = newValue
    Call Redraw(lastStat, True)
    PropertyChanged "CHECK"

End Property

Public Property Get Value() As Boolean

    Value = cValue

End Property

Public Property Let Value(ByVal newValue As Boolean)

    cValue = newValue
    If isCheckbox Then Call Redraw(0, True)
    PropertyChanged "VALUE"

End Property

Public Property Get Version() As String
Attribute Version.VB_MemberFlags = "40"

    Version = cbVersion

End Property

'########## END OF PROPERTIES ##########

Private Sub UserControl_Resize()

    If inLoop Then Exit Sub
    'get button size
    GetClientRect UserControl.hwnd, rc3
    'assign these values to He and Wi
    He = rc3.Bottom: Wi = rc3.Right
    'build the FocusRect size and position depending on the button type
    If MyButtonType >= [Simple Flat] And MyButtonType <= [Oval Flat] Then
        InflateRect rc3, -3, -3
    ElseIf MyButtonType = [KDE 2] Then
        InflateRect rc3, -5, -5
        OffsetRect rc3, 1, 1
    Else
        InflateRect rc3, -4, -4
    End If
    Call CalcTextRects

    If rgnNorm Then DeleteObject rgnNorm
    Call MakeRegion
    SetWindowRgn UserControl.hwnd, rgnNorm, True

    If He Then Call Redraw(0, True)

End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)

    With PropBag
        MyButtonType = .ReadProperty("BTYPE", 2)
        elTex = .ReadProperty("TX", "")
        isEnabled = .ReadProperty("ENAB", True)
        Set UserControl.Font = .ReadProperty("FONT", UserControl.Font)
        MyColorType = .ReadProperty("COLTYPE", 1)
        showFocusR = .ReadProperty("FOCUSR", True)
        BackC = .ReadProperty("BCOL", GetSysColor(COLOR_BTNFACE))
        BackO = .ReadProperty("BCOLO", BackC)
        ForeC = .ReadProperty("FCOL", GetSysColor(COLOR_BTNTEXT))
        ForeO = .ReadProperty("FCOLO", ForeC)
        MaskC = .ReadProperty("MCOL", &HC0C0C0)
        UserControl.MousePointer = .ReadProperty("MPTR", 0)
        Set UserControl.MouseIcon = .ReadProperty("MICON", Nothing)
        Set picNormal = .ReadProperty("PICN", Nothing)
        Set picHover = .ReadProperty("PICH", Nothing)
        useMask = .ReadProperty("UMCOL", True)
        isSoft = .ReadProperty("SOFT", False)
        PicPosition = .ReadProperty("PICPOS", 0)
        useGrey = .ReadProperty("NGREY", False)
        SFX = .ReadProperty("FX", 0)
        Me.HandPointer = .ReadProperty("HAND", False)
        isCheckbox = .ReadProperty("CHECK", False)
        cValue = .ReadProperty("VALUE", False)
    End With

    UserControl.Enabled = isEnabled
    Call CalcPicSize
    Call CalcTextRects
    Call SetAccessKeys

End Sub

Private Sub UserControl_Show()

    If MyButtonType = 11 Then
        If pDC = 0 Then
            pDC = CreateCompatibleDC(UserControl.hdc): pBM = CreateBitmap(Wi, He, 1, GetDeviceCaps(hdc, 12), ByVal 0&)
            oBM = SelectObject(pDC, pBM)
        End If

        Call GetParentPic
    End If

    isShown = True
    Call SetColors
    Call Redraw(0, True)

End Sub

Private Sub UserControl_Terminate()

    isShown = False
    DeleteObject rgnNorm
    If pDC Then
        DeleteObject SelectObject(pDC, oBM)
        DeleteDC pDC
    End If

End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)

    With PropBag
        Call .WriteProperty("BTYPE", MyButtonType)
        Call .WriteProperty("TX", elTex)
        Call .WriteProperty("ENAB", isEnabled)
        Call .WriteProperty("FONT", UserControl.Font)
        Call .WriteProperty("COLTYPE", MyColorType)
        Call .WriteProperty("FOCUSR", showFocusR)
        Call .WriteProperty("BCOL", BackC)
        Call .WriteProperty("BCOLO", BackO)
        Call .WriteProperty("FCOL", ForeC)
        Call .WriteProperty("FCOLO", ForeO)
        Call .WriteProperty("MCOL", MaskC)
        Call .WriteProperty("MPTR", UserControl.MousePointer)
        Call .WriteProperty("MICON", UserControl.MouseIcon)
        Call .WriteProperty("PICN", picNormal)
        Call .WriteProperty("PICH", picHover)
        Call .WriteProperty("UMCOL", useMask)
        Call .WriteProperty("SOFT", isSoft)
        Call .WriteProperty("PICPOS", PicPosition)
        Call .WriteProperty("NGREY", useGrey)
        Call .WriteProperty("FX", SFX)
        Call .WriteProperty("HAND", useHand)
        Call .WriteProperty("CHECK", isCheckbox)
        Call .WriteProperty("VALUE", cValue)
    End With

End Sub

Private Sub Redraw(ByVal curStat As Byte, ByVal Force As Boolean)

'here is the CORE of the button, everything is drawn here
'it's not well commented but i think that everything is
'pretty self explanatory...

    If isCheckbox And cValue Then curStat = 2

    If Not Force Then  'check drawing redundancy
        If (curStat = lastStat) And (TE = elTex) Then Exit Sub
    End If

    If He = 0 Or Not isShown Then Exit Sub   'we don't want errors

    lastStat = curStat
    TE = elTex

Dim i As Long, stepXP1 As Single, XPFace2 As Long, tempCol As Long

    With UserControl
        .Cls
        If isOver And MyColorType = Custom Then tempCol = BackC: BackC = BackO: SetColors

        DrawRectangle 0, 0, Wi, He, cFace

        If isEnabled Then
            If curStat = 0 Then
                '#@#@#@#@#@# BUTTON NORMAL STATE #@#@#@#@#@#
                Select Case MyButtonType
                Case 1 'Windows 16-bit
                    Call DrawCaption(Abs(isOver))
                    DrawFrame cHighLight, cShadow, cHighLight, cShadow, True
                    DrawRectangle 0, 0, Wi, He, cDarkShadow, True
                    Call DrawFocusR
                Case 2 'Windows 32-bit
                    Call DrawCaption(Abs(isOver))
                    If Ambient.DisplayAsDefault And showFocusR Then
                        DrawFrame cHighLight, cDarkShadow, cLight, cShadow, True
                        Call DrawFocusR
                        DrawRectangle 0, 0, Wi, He, cDarkShadow, True
                    Else
                        DrawFrame cHighLight, cDarkShadow, cLight, cShadow, False
                    End If
                Case 3 'Windows XP
                    stepXP1 = 25 / He
                    For i = 1 To He
                        DrawLine 0, i, Wi, i, ShiftColor(XPFace, -stepXP1 * i, True)
                    Next i
                    Call DrawCaption(Abs(isOver))
                    DrawRectangle 0, 0, Wi, He, &H733C00, True
                    mSetPixel 1, 1, &H7B4D10
                    mSetPixel 1, He - 2, &H7B4D10
                    mSetPixel Wi - 2, 1, &H7B4D10
                    mSetPixel Wi - 2, He - 2, &H7B4D10

                    If isOver Then
                        DrawRectangle 1, 2, Wi - 2, He - 4, &H31B2FF, True
                        DrawLine 2, He - 2, Wi - 2, He - 2, &H96E7&
                        DrawLine 2, 1, Wi - 2, 1, &HCEF3FF
                        DrawLine 1, 2, Wi - 1, 2, &H8CDBFF
                        DrawLine 2, 3, 2, He - 3, &H6BCBFF
                        DrawLine Wi - 3, 3, Wi - 3, He - 3, &H6BCBFF
                    ElseIf ((HasFocus Or Ambient.DisplayAsDefault) And showFocusR) Then
                        DrawRectangle 1, 2, Wi - 2, He - 4, &HE7AE8C, True
                        DrawLine 2, He - 2, Wi - 2, He - 2, &HEF826B
                        DrawLine 2, 1, Wi - 2, 1, &HFFE7CE
                        DrawLine 1, 2, Wi - 1, 2, &HF7D7BD
                        DrawLine 2, 3, 2, He - 3, &HF0D1B5
                        DrawLine Wi - 3, 3, Wi - 3, He - 3, &HF0D1B5
                    Else 'we do not draw the bevel always because the above code would repaint over it
                        DrawLine 2, He - 2, Wi - 2, He - 2, ShiftColor(XPFace, -&H30, True)
                        DrawLine 1, He - 3, Wi - 2, He - 3, ShiftColor(XPFace, -&H20, True)
                        DrawLine Wi - 2, 2, Wi - 2, He - 2, ShiftColor(XPFace, -&H24, True)
                        DrawLine Wi - 3, 3, Wi - 3, He - 3, ShiftColor(XPFace, -&H18, True)
                        DrawLine 2, 1, Wi - 2, 1, ShiftColor(XPFace, &H10, True)
                        DrawLine 1, 2, Wi - 2, 2, ShiftColor(XPFace, &HA, True)
                        DrawLine 1, 2, 1, He - 2, ShiftColor(XPFace, -&H5, True)
                        DrawLine 2, 3, 2, He - 3, ShiftColor(XPFace, -&HA, True)
                    End If
                Case 4 'Mac
                    DrawRectangle 1, 1, Wi - 2, He - 2, cLight
                    Call DrawCaption(Abs(isOver))
                    DrawRectangle 0, 0, Wi, He, cDarkShadow, True
                    mSetPixel 1, 1, cDarkShadow
                    mSetPixel 1, He - 2, cDarkShadow
                    mSetPixel Wi - 2, 1, cDarkShadow
                    mSetPixel Wi - 2, He - 2, cDarkShadow
                    DrawLine 1, 2, 2, 0, cFace
                    DrawLine 3, 2, Wi - 3, 2, cHighLight
                    DrawLine 2, 2, 2, He - 3, cHighLight
                    mSetPixel 3, 3, cHighLight
                    DrawLine Wi - 3, 1, Wi - 3, He - 3, cFace
                    DrawLine 1, He - 3, Wi - 3, He - 3, cFace
                    mSetPixel Wi - 4, He - 4, cFace
                    DrawLine Wi - 2, 2, Wi - 2, He - 2, cShadow
                    DrawLine 2, He - 2, Wi - 2, He - 2, cShadow
                    mSetPixel Wi - 3, He - 3, cShadow
                Case 5 'Java
                    DrawRectangle 1, 1, Wi - 1, He - 1, ShiftColor(cFace, &HC)
                    Call DrawCaption(Abs(isOver))
                    DrawRectangle 1, 1, Wi - 1, He - 1, cHighLight, True
                    DrawRectangle 0, 0, Wi - 1, He - 1, ShiftColor(cShadow, -&H1A), True
                    mSetPixel 1, He - 2, ShiftColor(cShadow, &H1A)
                    mSetPixel Wi - 2, 1, ShiftColor(cShadow, &H1A)
                    If HasFocus And showFocusR Then DrawRectangle rc.Left - 2, rc.Top - 1, fc.X + 4, fc.Y + 2, &HCC9999, True
                Case 6 'Netscape
                    Call DrawCaption(Abs(isOver))
                    DrawFrame ShiftColor(cLight, &H8), cShadow, ShiftColor(cLight, &H8), cShadow, False
                    Call DrawFocusR
                Case 7, 8, 12 'Flat buttons
                    Call DrawCaption(Abs(isOver))
                    If (MyButtonType = [Simple Flat]) Then
                        DrawFrame cHighLight, cShadow, 0, 0, False, True
                    ElseIf isOver Then
                        If MyButtonType = [Flat Highlight] Then
                            DrawFrame cHighLight, cShadow, 0, 0, False, True
                        Else
                            DrawFrame cHighLight, cDarkShadow, cLight, cShadow, False, False
                        End If
                    End If
                    Call DrawFocusR
                Case 9 'Office XP
                    If isOver Then DrawRectangle 1, 1, Wi, He, OXPf
                    Call DrawCaption(Abs(isOver))
                    If isOver Then DrawRectangle 0, 0, Wi, He, OXPb, True
                    Call DrawFocusR
                Case 11 'transparent
                    BitBlt hdc, 0, 0, Wi, He, pDC, 0, 0, vbSrcCopy
                    Call DrawCaption(Abs(isOver))
                    Call DrawFocusR
                Case 13 'Oval
                    DrawEllipse 0, 0, Wi, He, Abs(isOver) * cShadow + Abs(Not isOver) * cFace, cFace
                    Call DrawCaption(Abs(isOver))
                Case 14 'KDE 2
                    Dim prevBold As Boolean
                    If Not isOver Then
                        stepXP1 = 58 / He
                        For i = 1 To He
                            DrawLine 0, i, Wi, i, ShiftColor(cHighLight, -stepXP1 * i)
                        Next i
                    Else
                        DrawRectangle 0, 0, Wi, He, cLight
                    End If
                    If Ambient.DisplayAsDefault Then isShown = False: prevBold = Me.FontBold: Me.FontBold = True
                    Call DrawCaption(Abs(isOver))
                    If Ambient.DisplayAsDefault Then Me.FontBold = prevBold: isShown = True
                    DrawRectangle 0, 0, Wi, He, ShiftColor(cShadow, -&H32), True
                    DrawRectangle 1, 1, Wi - 2, He - 2, ShiftColor(cFace, -&H9), True
                    DrawRectangle 2, 2, Wi - 4, 2, cHighLight
                    DrawRectangle 2, 4, 2, He - 6, cHighLight
                    Call DrawFocusR
                End Select
                Call DrawPictures(0)
            ElseIf curStat = 2 Then
                '#@#@#@#@#@# BUTTON IS DOWN #@#@#@#@#@#
                Select Case MyButtonType
                Case 1 'Windows 16-bit
                    Call DrawCaption(2)
                    DrawFrame cShadow, cHighLight, cShadow, cHighLight, True
                    DrawRectangle 0, 0, Wi, He, cDarkShadow, True
                    Call DrawFocusR
                Case 2 'Windows 32-bit
                    Call DrawCaption(2)
                    If showFocusR And Ambient.DisplayAsDefault Then
                        DrawRectangle 0, 0, Wi, He, cDarkShadow, True
                        DrawRectangle 1, 1, Wi - 2, He - 2, cShadow, True
                        Call DrawFocusR
                    Else
                        DrawFrame cDarkShadow, cHighLight, cShadow, cLight, False
                    End If
                Case 3 'Windows XP
                    stepXP1 = 25 / He
                    XPFace2 = ShiftColor(XPFace, -32, True)
                    For i = 1 To He
                        DrawLine 0, He - i, Wi, He - i, ShiftColor(XPFace2, -stepXP1 * i, True)
                    Next i
                    Call DrawCaption(2)
                    DrawRectangle 0, 0, Wi, He, &H733C00, True
                    mSetPixel 1, 1, &H7B4D10
                    mSetPixel 1, He - 2, &H7B4D10
                    mSetPixel Wi - 2, 1, &H7B4D10
                    mSetPixel Wi - 2, He - 2, &H7B4D10

                    DrawLine 2, He - 2, Wi - 2, He - 2, ShiftColor(XPFace2, &H10, True)
                    DrawLine 1, He - 3, Wi - 2, He - 3, ShiftColor(XPFace2, &HA, True)
                    DrawLine Wi - 2, 2, Wi - 2, He - 2, ShiftColor(XPFace2, &H5, True)
                    DrawLine Wi - 3, 3, Wi - 3, He - 3, XPFace
                    DrawLine 2, 1, Wi - 2, 1, ShiftColor(XPFace2, -&H20, True)
                    DrawLine 1, 2, Wi - 2, 2, ShiftColor(XPFace2, -&H18, True)
                    DrawLine 1, 2, 1, He - 2, ShiftColor(XPFace2, -&H20, True)
                    DrawLine 2, 2, 2, He - 2, ShiftColor(XPFace2, -&H16, True)
                Case 4 'Mac
                    DrawRectangle 1, 1, Wi - 2, He - 2, ShiftColor(cShadow, -&H10)
                    XPFace = ShiftColor(cShadow, -&H10)
                    Call DrawCaption(2)
                    XPFace = ShiftColor(cFace, &H30)
                    DrawRectangle 0, 0, Wi, He, cDarkShadow, True
                    DrawRectangle 1, 1, Wi - 2, He - 2, ShiftColor(cShadow, -&H40), True
                    DrawRectangle 2, 2, Wi - 4, He - 4, ShiftColor(cShadow, -&H20), True
                    mSetPixel 2, 2, ShiftColor(cShadow, -&H40)
                    mSetPixel 3, 3, ShiftColor(cShadow, -&H20)
                    mSetPixel 1, 1, cDarkShadow
                    mSetPixel 1, He - 2, cDarkShadow
                    mSetPixel Wi - 2, 1, cDarkShadow
                    mSetPixel Wi - 2, He - 2, cDarkShadow
                    DrawLine Wi - 3, 1, Wi - 3, He - 3, cShadow
                    DrawLine 1, He - 3, Wi - 2, He - 3, cShadow
                    mSetPixel Wi - 4, He - 4, cShadow
                    DrawLine Wi - 2, 3, Wi - 2, He - 2, ShiftColor(cShadow, -&H10)
                    DrawLine 3, He - 2, Wi - 2, He - 2, ShiftColor(cShadow, -&H10)
                    DrawLine Wi - 2, He - 3, Wi - 4, He - 1, ShiftColor(cShadow, -&H20)
                    mSetPixel 2, He - 2, ShiftColor(cShadow, -&H20)
                    mSetPixel Wi - 2, 2, ShiftColor(cShadow, -&H20)
                Case 5 'Java
                    DrawRectangle 1, 1, Wi - 2, He - 2, ShiftColor(cShadow, &H10), False
                    DrawRectangle 0, 0, Wi - 1, He - 1, ShiftColor(cShadow, -&H1A), True
                    DrawLine Wi - 1, 1, Wi - 1, He, cHighLight
                    DrawLine 1, He - 1, Wi - 1, He - 1, cHighLight
                    SetTextColor .hdc, cTextO
                    DrawText .hdc, elTex, Len(elTex), rc, DT_CENTER
                    If HasFocus And showFocusR Then DrawRectangle rc.Left - 2, rc.Top - 1, fc.X + 4, fc.Y + 2, &HCC9999, True
                Case 6 'Netscape
                    Call DrawCaption(2)
                    DrawFrame cShadow, ShiftColor(cLight, &H8), cShadow, ShiftColor(cLight, &H8), False
                    Call DrawFocusR
                Case 7, 8, 12 'Flat buttons
                    Call DrawCaption(2)
                    If MyButtonType = [3D Hover] Then
                        DrawFrame cDarkShadow, cHighLight, cShadow, cLight, False, False
                    Else
                        DrawFrame cShadow, cHighLight, 0, 0, False, True
                    End If
                    Call DrawFocusR
                Case 9 'Office XP
                    If isOver Then DrawRectangle 0, 0, Wi, He, Abs(MyColorType = 2) * ShiftColor(OXPf, -&H20) + Abs(MyColorType <> 2) * ShiftColorOXP(OXPb, &H80)
                    Call DrawCaption(2)
                    DrawRectangle 0, 0, Wi, He, OXPb, True
                    Call DrawFocusR
                Case 11 'transparent
                    BitBlt hdc, 0, 0, Wi, He, pDC, 0, 0, vbSrcCopy
                    Call DrawCaption(2)
                    Call DrawFocusR
                Case 13 'Oval
                    DrawEllipse 0, 0, Wi, He, cDarkShadow, ShiftColor(cFace, -&H20)
                    Call DrawCaption(2)
                Case 14 'KDE 2
                    DrawRectangle 1, 1, Wi, He, ShiftColor(cFace, -&H9)
                    DrawRectangle 0, 0, Wi, He, ShiftColor(cShadow, -&H30), True
                    DrawLine 2, He - 2, Wi - 2, He - 2, cHighLight
                    DrawLine Wi - 2, 2, Wi - 2, He - 1, cHighLight
                    Call DrawCaption(7)
                    Call DrawFocusR
                End Select
                Call DrawPictures(1)
            End If
        Else
            '#~#~#~#~#~# DISABLED STATUS #~#~#~#~#~#
            Select Case MyButtonType
            Case 1 'Windows 16-bit
                Call DrawCaption(3)
                DrawFrame cHighLight, cShadow, cHighLight, cShadow, True
                DrawRectangle 0, 0, Wi, He, cDarkShadow, True
            Case 2 'Windows 32-bit
                Call DrawCaption(3)
                DrawFrame cHighLight, cDarkShadow, cLight, cShadow, False
            Case 3 'Windows XP
                DrawRectangle 0, 0, Wi, He, ShiftColor(XPFace, -&H18, True)
                Call DrawCaption(5)
                DrawRectangle 0, 0, Wi, He, ShiftColor(XPFace, -&H54, True), True
                mSetPixel 1, 1, ShiftColor(XPFace, -&H48, True)
                mSetPixel 1, He - 2, ShiftColor(XPFace, -&H48, True)
                mSetPixel Wi - 2, 1, ShiftColor(XPFace, -&H48, True)
                mSetPixel Wi - 2, He - 2, ShiftColor(XPFace, -&H48, True)
            Case 4 'Mac
                DrawRectangle 1, 1, Wi - 2, He - 2, cLight
                Call DrawCaption(3)
                DrawRectangle 0, 0, Wi, He, cDarkShadow, True
                mSetPixel 1, 1, cDarkShadow
                mSetPixel 1, He - 2, cDarkShadow
                mSetPixel Wi - 2, 1, cDarkShadow
                mSetPixel Wi - 2, He - 2, cDarkShadow
                DrawLine 1, 2, 2, 0, cFace
                DrawLine 3, 2, Wi - 3, 2, cHighLight
                DrawLine 2, 2, 2, He - 3, cHighLight
                mSetPixel 3, 3, cHighLight
                DrawLine Wi - 3, 1, Wi - 3, He - 3, cFace
                DrawLine 1, He - 3, Wi - 3, He - 3, cFace
                mSetPixel Wi - 4, He - 4, cFace
                DrawLine Wi - 2, 2, Wi - 2, He - 2, cShadow
                DrawLine 2, He - 2, Wi - 2, He - 2, cShadow
                mSetPixel Wi - 3, He - 3, cShadow
            Case 5 'Java
                Call DrawCaption(4)
                DrawRectangle 0, 0, Wi, He, cShadow, True
            Case 6 'Netscape
                Call DrawCaption(4)
                DrawFrame ShiftColor(cLight, &H8), cShadow, ShiftColor(cLight, &H8), cShadow, False
            Case 7, 8, 12, 13 'Flat buttons
                Call DrawCaption(3)
                If MyButtonType = [Simple Flat] Then DrawFrame cHighLight, cShadow, 0, 0, False, True
            Case 9 'Office XP
                Call DrawCaption(4)
            Case 11 'transparent
                BitBlt hdc, 0, 0, Wi, He, pDC, 0, 0, vbSrcCopy
                Call DrawCaption(3)
            Case 14 'KDE 2
                stepXP1 = 58 / He
                For i = 1 To He
                    DrawLine 0, i, Wi, i, ShiftColor(cHighLight, -stepXP1 * i)
                Next i
                DrawRectangle 0, 0, Wi, He, ShiftColor(cShadow, -&H32), True
                DrawRectangle 1, 1, Wi - 2, He - 2, ShiftColor(cFace, -&H9), True
                DrawRectangle 2, 2, Wi - 4, 2, cHighLight
                DrawRectangle 2, 4, 2, He - 6, cHighLight
                Call DrawCaption(6)
            End Select
            Call DrawPictures(2)
        End If
    End With

    If isOver And MyColorType = Custom Then BackC = tempCol: SetColors

End Sub

Private Sub DrawRectangle(ByVal X As Long, ByVal Y As Long, ByVal Width As Long, ByVal Height As Long, ByVal Color As Long, Optional OnlyBorder As Boolean = False)

'this is my custom function to draw rectangles and frames
'it's faster and smoother than using the line method

Dim bRECT As RECT
Dim hBrush As Long

    bRECT.Left = X
    bRECT.Top = Y
    bRECT.Right = X + Width
    bRECT.Bottom = Y + Height

    hBrush = CreateSolidBrush(Color)

    If OnlyBorder Then
        FrameRect UserControl.hdc, bRECT, hBrush
    Else
        FillRect UserControl.hdc, bRECT, hBrush
    End If

    DeleteObject hBrush

End Sub

Private Sub DrawEllipse(ByVal X As Long, ByVal Y As Long, ByVal Width As Long, ByVal Height As Long, ByVal BorderColor As Long, ByVal FillColor As Long)

Dim pBrush As Long, pPen As Long

    pBrush = SelectObject(hdc, CreateSolidBrush(FillColor))
    pPen = SelectObject(hdc, CreatePen(PS_SOLID, 2, BorderColor))

    Call Ellipse(hdc, X, Y, X + Width, Y + Height)

    Call DeleteObject(SelectObject(hdc, pBrush))
    Call DeleteObject(SelectObject(hdc, pPen))

End Sub

Private Sub DrawLine(ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long, ByVal Color As Long)

'a fast way to draw lines

Dim pt As POINTAPI
Dim oldPen As Long, hPen As Long

    With UserControl
        hPen = CreatePen(PS_SOLID, 1, Color)
        oldPen = SelectObject(.hdc, hPen)

        MoveToEx .hdc, X1, Y1, pt
        LineTo .hdc, X2, Y2

        SelectObject .hdc, oldPen
        DeleteObject hPen
    End With

End Sub

Private Sub DrawFrame(ByVal ColHigh As Long, ByVal ColDark As Long, ByVal ColLight As Long, ByVal ColShadow As Long, ByVal ExtraOffset As Boolean, Optional ByVal Flat As Boolean = False)

'a very fast way to draw windows-like frames

Dim pt As POINTAPI
Dim frHe As Long, frWi As Long, frXtra As Long

    frHe = He - 1 + ExtraOffset: frWi = Wi - 1 + ExtraOffset: frXtra = Abs(ExtraOffset)

    With UserControl
        Call DeleteObject(SelectObject(.hdc, CreatePen(PS_SOLID, 1, ColHigh)))
        '=============================
        MoveToEx .hdc, frXtra, frHe, pt
        LineTo .hdc, frXtra, frXtra
        LineTo .hdc, frWi, frXtra
        '=============================
        Call DeleteObject(SelectObject(.hdc, CreatePen(PS_SOLID, 1, ColDark)))
        '=============================
        LineTo .hdc, frWi, frHe
        LineTo .hdc, frXtra - 1, frHe
        MoveToEx .hdc, frXtra + 1, frHe - 1, pt
        If Flat Then Exit Sub
        '=============================
        Call DeleteObject(SelectObject(.hdc, CreatePen(PS_SOLID, 1, ColLight)))
        '=============================
        LineTo .hdc, frXtra + 1, frXtra + 1
        LineTo .hdc, frWi - 1, frXtra + 1
        '=============================
        Call DeleteObject(SelectObject(.hdc, CreatePen(PS_SOLID, 1, ColShadow)))
        '=============================
        LineTo .hdc, frWi - 1, frHe - 1
        LineTo .hdc, frXtra, frHe - 1
    End With

End Sub

Private Sub mSetPixel(ByVal X As Long, ByVal Y As Long, ByVal Color As Long)

    Call SetPixel(UserControl.hdc, X, Y, Color)

End Sub

Private Sub DrawFocusR()

    If showFocusR And HasFocus Then
        SetTextColor UserControl.hdc, cText
        DrawFocusRect UserControl.hdc, rc3
    End If

End Sub

Private Sub SetColors()

'this function sets the colors taken as a base to build
'all the other colors and styles.

    If MyColorType = Custom Then
        cFace = ConvertFromSystemColor(BackC)
        cFaceO = ConvertFromSystemColor(BackO)
        cText = ConvertFromSystemColor(ForeC)
        cTextO = ConvertFromSystemColor(ForeO)
        cShadow = ShiftColor(cFace, -&H40)
        cLight = ShiftColor(cFace, &H1F)
        cHighLight = ShiftColor(cFace, &H2F) 'it should be 3F but it looks too lighter
        cDarkShadow = ShiftColor(cFace, -&HC0)
        OXPb = ShiftColor(cFace, -&H80)
        OXPf = cFace
    ElseIf MyColorType = [Force Standard] Then
        cFace = &HC0C0C0
        cFaceO = cFace
        cShadow = &H808080
        cLight = &HDFDFDF
        cDarkShadow = &H0
        cHighLight = &HFFFFFF
        cText = &H0
        cTextO = cText
        OXPb = &H800000
        OXPf = &HD1ADAD
    ElseIf MyColorType = [Use Container] Then
        cFace = GetBkColor(GetDC(GetParent(hwnd)))
        cFaceO = cFace
        cText = GetTextColor(GetDC(GetParent(hwnd)))
        cTextO = cText
        cShadow = ShiftColor(cFace, -&H40)
        cLight = ShiftColor(cFace, &H1F)
        cHighLight = ShiftColor(cFace, &H2F)
        cDarkShadow = ShiftColor(cFace, -&HC0)
        OXPb = GetSysColor(COLOR_HIGHLIGHT)
        OXPf = ShiftColorOXP(OXPb)
    Else
        'if MyColorType is 1 or has not been set then use windows colors
        cFace = GetSysColor(COLOR_BTNFACE)
        cFaceO = cFace
        cShadow = GetSysColor(COLOR_BTNSHADOW)
        cLight = GetSysColor(COLOR_BTNLIGHT)
        cDarkShadow = GetSysColor(COLOR_BTNDKSHADOW)
        cHighLight = GetSysColor(COLOR_BTNHIGHLIGHT)
        cText = GetSysColor(COLOR_BTNTEXT)
        cTextO = cText
        OXPb = GetSysColor(COLOR_HIGHLIGHT)
        OXPf = ShiftColorOXP(OXPb)
    End If
    cMask = ConvertFromSystemColor(MaskC)
    XPFace = ShiftColor(cFace, &H30, MyButtonType = [Windows XP])

End Sub

Private Sub MakeRegion()

'this function creates the regions to "cut" the UserControl
'so it will be transparent in certain areas

Dim rgn1 As Long, rgn2 As Long

    rgnNorm = CreateRectRgn(0, 0, Wi, He)
    rgn2 = CreateRectRgn(0, 0, 0, 0)

    Select Case MyButtonType
    Case 1, 5, 14 'Windows 16-bit, Java & KDE 2
        rgn1 = CreateRectRgn(0, He, 1, He - 1)
        CombineRgn rgn2, rgnNorm, rgn1, RGN_DIFF
        DeleteObject rgn1
        rgn1 = CreateRectRgn(Wi, 0, Wi - 1, 1)
        CombineRgn rgnNorm, rgn2, rgn1, RGN_DIFF
        DeleteObject rgn1
        If MyButtonType <> 5 Then  'the above was common code
            rgn1 = CreateRectRgn(0, 0, 1, 1)
            CombineRgn rgn2, rgnNorm, rgn1, RGN_DIFF
            DeleteObject rgn1
            rgn1 = CreateRectRgn(Wi, He, Wi - 1, He - 1)
            CombineRgn rgnNorm, rgn2, rgn1, RGN_DIFF
            DeleteObject rgn1
        End If
    Case 3, 4 'Windows XP and Mac
        rgn1 = CreateRectRgn(0, 0, 2, 1)
        CombineRgn rgn2, rgnNorm, rgn1, RGN_DIFF
        DeleteObject rgn1
        rgn1 = CreateRectRgn(0, He, 2, He - 1)
        CombineRgn rgnNorm, rgn2, rgn1, RGN_DIFF
        DeleteObject rgn1
        rgn1 = CreateRectRgn(Wi, 0, Wi - 2, 1)
        CombineRgn rgn2, rgnNorm, rgn1, RGN_DIFF
        DeleteObject rgn1
        rgn1 = CreateRectRgn(Wi, He, Wi - 2, He - 1)
        CombineRgn rgnNorm, rgn2, rgn1, RGN_DIFF
        DeleteObject rgn1
        rgn1 = CreateRectRgn(0, 1, 1, 2)
        CombineRgn rgn2, rgnNorm, rgn1, RGN_DIFF
        DeleteObject rgn1
        rgn1 = CreateRectRgn(0, He - 1, 1, He - 2)
        CombineRgn rgnNorm, rgn2, rgn1, RGN_DIFF
        DeleteObject rgn1
        rgn1 = CreateRectRgn(Wi, 1, Wi - 1, 2)
        CombineRgn rgn2, rgnNorm, rgn1, RGN_DIFF
        DeleteObject rgn1
        rgn1 = CreateRectRgn(Wi, He - 1, Wi - 1, He - 2)
        CombineRgn rgnNorm, rgn2, rgn1, RGN_DIFF
        DeleteObject rgn1
    Case 13
        DeleteObject rgnNorm
        rgnNorm = CreateEllipticRgn(0, 0, Wi, He)
    End Select

    DeleteObject rgn2

End Sub

Private Sub SetAccessKeys()

'this is a TRUE access keys parser
'the basic rule is that if an ampersand is followed by another,
'  a single ampersand is drawn and this is not the access key.
'  So we continue searching for another possible access key.

'   I only do a second pass because no one writes text like "Me & them & everyone"
'   so the caption prop should be "Me && them && &everyone", this is rubbish and a
'   search like this would only waste time

Dim ampersandPos As Long

    'we first clear the AccessKeys property, and will be filled if one is found
    UserControl.AccessKeys = ""

    If Len(elTex) > 1 Then
        ampersandPos = InStr(1, elTex, "&", vbTextCompare)
        If (ampersandPos < Len(elTex)) And (ampersandPos > 0) Then
            If Mid$(elTex, ampersandPos + 1, 1) <> "&" Then 'if text is sonething like && then no access key should be assigned, so continue searching
                UserControl.AccessKeys = LCase$(Mid$(elTex, ampersandPos + 1, 1))
            Else 'do only a second pass to find another ampersand character
                ampersandPos = InStr(ampersandPos + 2, elTex, "&", vbTextCompare)
                If Mid$(elTex, ampersandPos + 1, 1) <> "&" Then
                    UserControl.AccessKeys = LCase$(Mid$(elTex, ampersandPos + 1, 1))
                End If
            End If
        End If
    End If

End Sub

Private Function ShiftColor(ByVal Color As Long, ByVal Value As Long, Optional isXP As Boolean = False) As Long

'this function will add or remove a certain color
'quantity and return the result

Dim Red As Long, Blue As Long, Green As Long

    'this is just a tricky way to do it and will result in weird colors for WinXP and KDE2
    If isSoft Then Value = Value \ 2

    If Not isXP Then 'for XP button i use a work-aroud that works fine
        Blue = ((Color \ &H10000) Mod &H100) + Value
    Else
        Blue = ((Color \ &H10000) Mod &H100)
        Blue = Blue + ((Blue * Value) \ &HC0)
    End If
    Green = ((Color \ &H100) Mod &H100) + Value
    Red = (Color And &HFF) + Value

    'a bit of optimization done here, values will overflow a
    ' byte only in one direction... eg: if we added 32 to our
    ' color, then only a > 255 overflow can occurr.
    If Value > 0 Then
        If Red > 255 Then Red = 255
        If Green > 255 Then Green = 255
        If Blue > 255 Then Blue = 255
    ElseIf Value < 0 Then
        If Red < 0 Then Red = 0
        If Green < 0 Then Green = 0
        If Blue < 0 Then Blue = 0
    End If

    'more optimization by replacing the RGB function by its correspondent calculation
    ShiftColor = Red + 256& * Green + 65536 * Blue

End Function

Private Function ShiftColorOXP(ByVal theColor As Long, Optional ByVal Base As Long = &HB0) As Long

Dim Red As Long, Blue As Long, Green As Long
Dim Delta As Long

    Blue = ((theColor \ &H10000) Mod &H100)
    Green = ((theColor \ &H100) Mod &H100)
    Red = (theColor And &HFF)
    Delta = &HFF - Base

    Blue = Base + Blue * Delta \ &HFF
    Green = Base + Green * Delta \ &HFF
    Red = Base + Red * Delta \ &HFF

    If Red > 255 Then Red = 255
    If Green > 255 Then Green = 255
    If Blue > 255 Then Blue = 255

    ShiftColorOXP = Red + 256& * Green + 65536 * Blue

End Function

Private Sub CalcTextRects()

'this sub will calculate the rects required to draw the text

    Select Case PicPosition
    Case 0
        rc2.Left = 1 + picSZ.X: rc2.Right = Wi - 2: rc2.Top = 1: rc2.Bottom = He - 2
    Case 1
        rc2.Left = 1: rc2.Right = Wi - 2 - picSZ.X: rc2.Top = 1: rc2.Bottom = He - 2
    Case 2
        rc2.Left = 1: rc2.Right = Wi - 2: rc2.Top = 1 + picSZ.Y: rc2.Bottom = He - 2
    Case 3
        rc2.Left = 1: rc2.Right = Wi - 2: rc2.Top = 1: rc2.Bottom = He - 2 - picSZ.Y
    Case 4
        rc2.Left = 1: rc2.Right = Wi - 2: rc2.Top = 1: rc2.Bottom = He - 2
    End Select
    DrawText UserControl.hdc, elTex, Len(elTex), rc2, DT_CALCRECT Or DT_WORDBREAK
    CopyRect rc, rc2: fc.X = rc.Right - rc.Left: fc.Y = rc.Bottom - rc.Top
    Select Case PicPosition
    Case 0, 2
        OffsetRect rc, (Wi - rc.Right) \ 2, (He - rc.Bottom) \ 2
    Case 1
        OffsetRect rc, (Wi - rc.Right - picSZ.X - 4) \ 2, (He - rc.Bottom) \ 2
    Case 3
        OffsetRect rc, (Wi - rc.Right) \ 2, (He - rc.Bottom - picSZ.Y - 4) \ 2
    Case 4
        OffsetRect rc, (Wi - rc.Right) \ 2, (He - rc.Bottom) \ 2
    End Select
    CopyRect rc2, rc: OffsetRect rc2, 1, 1

    Call CalcPicPos 'once we have the text position we are able to calculate the pic position

End Sub

Public Sub DisableRefresh()

'this is for fast button editing, once you disable the refresh,
' you can change every prop without triggering the drawing methods.
' once you are done, you call Refresh.

    isShown = False

End Sub

Public Sub Refresh()

    If MyButtonType = 11 Then Call GetParentPic
    Call SetColors
    Call CalcTextRects
    isShown = True
    Call Redraw(lastStat, True)

End Sub

Private Function ConvertFromSystemColor(ByVal theColor As Long) As Long

    Call OleTranslateColor(theColor, 0, ConvertFromSystemColor)

End Function

Private Sub DrawCaption(ByVal State As Byte)

'this code is commonly shared through all the buttons so
' i took it and put it toghether here for easier readability
' of the code, and to cut-down disk size.

    captOpt = State

    With UserControl
        Select Case State 'in this select case, we only change the text color and draw only text that needs rc2, at the end, text that uses rc will be drawn
        Case 0 'normal caption
            txtFX rc
            SetTextColor .hdc, cText
        Case 1 'hover caption
            txtFX rc
            SetTextColor .hdc, cTextO
        Case 2 'down caption
            txtFX rc2
            If MyButtonType = Mac Then SetTextColor .hdc, cLight Else SetTextColor .hdc, cTextO
            DrawText .hdc, elTex, Len(elTex), rc2, DT_CENTER
        Case 3 'disabled embossed caption
            SetTextColor .hdc, cHighLight
            DrawText .hdc, elTex, Len(elTex), rc2, DT_CENTER
            SetTextColor .hdc, cShadow
        Case 4 'disabled grey caption
            SetTextColor .hdc, cShadow
        Case 5 'WinXP disabled caption
            SetTextColor .hdc, ShiftColor(XPFace, -&H68, True)
        Case 6 'KDE 2 disabled
            SetTextColor .hdc, cHighLight
            DrawText .hdc, elTex, Len(elTex), rc2, DT_CENTER
            SetTextColor .hdc, cFace
        Case 7 'KDE 2 down
            SetTextColor .hdc, ShiftColor(cShadow, -&H32)
            DrawText .hdc, elTex, Len(elTex), rc2, DT_CENTER
            SetTextColor .hdc, cHighLight
        End Select
        'we now draw the text that is common in all the captions
        If State <> 2 Then DrawText .hdc, elTex, Len(elTex), rc, DT_CENTER
    End With

End Sub

Private Sub DrawPictures(ByVal State As Byte)

    If picNormal Is Nothing Then Exit Sub 'check if there is a main picture, if not then exit

    With UserControl
        Select Case State
        Case 0 'normal & hover
            If Not isOver Then
                Call DoFX(0, picNormal)
                TransBlt .hdc, picPT.X, picPT.Y, picSZ.X, picSZ.Y, picNormal, cMask, , , useGrey, (MyButtonType = [Office XP])
            Else
                If MyButtonType = [Office XP] Then
                    Call DoFX(-1, picNormal)
                    TransBlt .hdc, picPT.X + 1, picPT.Y + 1, picSZ.X, picSZ.Y, picNormal, cMask, cShadow
                    TransBlt .hdc, picPT.X - 1, picPT.Y - 1, picSZ.X, picSZ.Y, picNormal, cMask
                Else
                    If Not picHover Is Nothing Then
                        Call DoFX(0, picHover)
                        TransBlt .hdc, picPT.X, picPT.Y, picSZ.X, picSZ.Y, picHover, cMask
                    Else
                        Call DoFX(0, picNormal)
                        TransBlt .hdc, picPT.X, picPT.Y, picSZ.X, picSZ.Y, picNormal, cMask
                    End If
                End If
            End If
        Case 1 'down
            If picHover Is Nothing Or MyButtonType = [Office XP] Then
                Select Case MyButtonType
                Case 5, 9
                    Call DoFX(0, picNormal)
                    TransBlt .hdc, picPT.X, picPT.Y, picSZ.X, picSZ.Y, picNormal, cMask
                Case Else
                    Call DoFX(1, picNormal)
                    TransBlt .hdc, picPT.X + 1, picPT.Y + 1, picSZ.X, picSZ.Y, picNormal, cMask
                End Select
            Else
                TransBlt .hdc, picPT.X + Abs(MyButtonType <> [Java metal]), picPT.Y + Abs(MyButtonType <> [Java metal]), picSZ.X, picSZ.Y, picHover, cMask
            End If
        Case 2 'disabled
            Select Case MyButtonType
            Case 5, 6, 9    'draw flat grey pictures
                TransBlt .hdc, picPT.X, picPT.Y, picSZ.X, picSZ.Y, picNormal, cMask, Abs(MyButtonType = [Office XP]) * ShiftColor(cShadow, &HD) + Abs(MyButtonType <> [Office XP]) * cShadow, True
            Case 3          'for WinXP draw a greyscaled image
                TransBlt .hdc, picPT.X + 1, picPT.Y + 1, picSZ.X, picSZ.Y, picNormal, cMask, , , True
            Case Else       'draw classic embossed pictures
                TransBlt .hdc, picPT.X + 1, picPT.Y + 1, picSZ.X, picSZ.Y, picNormal, cMask, cHighLight, True
                TransBlt .hdc, picPT.X, picPT.Y, picSZ.X, picSZ.Y, picNormal, cMask, cShadow, True
            End Select
        End Select
    End With
    If PicPosition = cbBackground Then Call DrawCaption(captOpt)

End Sub

Private Sub DoFX(ByVal offset As Long, ByVal thePic As StdPicture)

    If SFX > cbNone Then
        Dim curFace As Long
        If MyButtonType = [Windows XP] Then curFace = XPFace Else If offset = -1 And MyColorType <> Custom Then curFace = OXPf Else curFace = cFace
        TransBlt UserControl.hdc, picPT.X + 1 + offset, picPT.Y + 1 + offset, picSZ.X, picSZ.Y, thePic, cMask, ShiftColor(curFace, Abs(SFX = cbEngraved) * FXDEPTH + (SFX <> cbEngraved) * FXDEPTH)
        If SFX < cbShadowed Then TransBlt UserControl.hdc, picPT.X - 1 + offset, picPT.Y - 1 + offset, picSZ.X, picSZ.Y, thePic, cMask, ShiftColor(curFace, Abs(SFX <> cbEngraved) * FXDEPTH + (SFX = cbEngraved) * FXDEPTH)
    End If

End Sub

Private Sub txtFX(ByRef theRect As RECT)

    If SFX > cbNone Then
        With UserControl
            Dim curFace As Long
            Dim tempR As RECT: CopyRect tempR, theRect: OffsetRect tempR, 1, 1
            Select Case MyButtonType
                Case 3, 4, 14
                    curFace = XPFace
                Case Else
                    If lastStat = 0 And isOver And MyColorType <> Custom And MyButtonType = [Office XP] Then curFace = OXPf Else curFace = cFace
            End Select
            SetTextColor .hdc, ShiftColor(curFace, Abs(SFX = cbEngraved) * FXDEPTH + (SFX <> cbEngraved) * FXDEPTH)
            DrawText .hdc, elTex, Len(elTex), tempR, DT_CENTER
            If SFX < cbShadowed Then
                OffsetRect tempR, -2, -2
                SetTextColor .hdc, ShiftColor(curFace, Abs(SFX <> cbEngraved) * FXDEPTH + (SFX = cbEngraved) * FXDEPTH)
                DrawText .hdc, elTex, Len(elTex), tempR, DT_CENTER
            End If
        End With
    End If

End Sub

Private Sub CalcPicSize()

    If Not picNormal Is Nothing Then
        picSZ.X = UserControl.ScaleX(picNormal.Width, 8, UserControl.ScaleMode)
        picSZ.Y = UserControl.ScaleY(picNormal.Height, 8, UserControl.ScaleMode)
    Else
        picSZ.X = 0: picSZ.Y = 0
    End If

End Sub

Private Sub CalcPicPos()

'exit if there's no picture

    If picNormal Is Nothing And picHover Is Nothing Then Exit Sub

    If (Trim$(elTex) <> "") And (PicPosition <> 4) Then 'if there is no caption, or we have the picture as background, then we put the picture at the center of the button
        Select Case PicPosition
        Case 0 'left
            picPT.X = rc.Left - picSZ.X - 4
            picPT.Y = (He - picSZ.Y) \ 2
        Case 1 'right
            picPT.X = rc.Right + 4
            picPT.Y = (He - picSZ.Y) \ 2
        Case 2 'top
            picPT.X = (Wi - picSZ.X) \ 2
            picPT.Y = rc.Top - picSZ.Y - 2
        Case 3 'bottom
            picPT.X = (Wi - picSZ.X) \ 2
            picPT.Y = rc.Bottom + 2
        End Select
    Else 'center the picture
        picPT.X = (Wi - picSZ.X) \ 2
        picPT.Y = (He - picSZ.Y) \ 2
    End If

End Sub

Private Sub TransBlt(ByVal DstDC As Long, ByVal DstX As Long, ByVal DstY As Long, ByVal DstW As Long, ByVal DstH As Long, ByVal SrcPic As StdPicture, Optional ByVal TransColor As Long = -1, Optional ByVal BrushColor As Long = -1, Optional ByVal MonoMask As Boolean = False, Optional ByVal isGreyscale As Boolean = False, Optional ByVal XPBlend As Boolean = False)

    If DstW = 0 Or DstH = 0 Then Exit Sub

Dim B As Long, H As Long, F As Long, i As Long, newW As Long
Dim TmpDC As Long, TmpBmp As Long, TmpObj As Long
Dim Sr2DC As Long, Sr2Bmp As Long, Sr2Obj As Long
Dim Data1() As RGBTRIPLE, Data2() As RGBTRIPLE
Dim Info As BITMAPINFO, BrushRGB As RGBTRIPLE, gCol As Long

Dim SrcDC As Long, tObj As Long, ttt As Long

    SrcDC = CreateCompatibleDC(hdc)

    If DstW < 0 Then DstW = UserControl.ScaleX(SrcPic.Width, 8, UserControl.ScaleMode)
    If DstH < 0 Then DstH = UserControl.ScaleY(SrcPic.Height, 8, UserControl.ScaleMode)

    If SrcPic.Type = 1 Then 'check if it's an icon or a bitmap
        tObj = SelectObject(SrcDC, SrcPic)
    Else
        Dim hBrush As Long
        tObj = SelectObject(SrcDC, CreateCompatibleBitmap(DstDC, DstW, DstH))
        hBrush = CreateSolidBrush(MaskColor)
        DrawIconEx SrcDC, 0, 0, SrcPic.Handle, 0, 0, 0, hBrush, &H1 Or &H2
        DeleteObject hBrush
    End If

    TmpDC = CreateCompatibleDC(SrcDC)
    Sr2DC = CreateCompatibleDC(SrcDC)
    TmpBmp = CreateCompatibleBitmap(DstDC, DstW, DstH)
    Sr2Bmp = CreateCompatibleBitmap(DstDC, DstW, DstH)
    TmpObj = SelectObject(TmpDC, TmpBmp)
    Sr2Obj = SelectObject(Sr2DC, Sr2Bmp)
    ReDim Data1(DstW * DstH * 3 - 1)
    ReDim Data2(UBound(Data1))
    With Info.bmiHeader
        .biSize = Len(Info.bmiHeader)
        .biWidth = DstW
        .biHeight = DstH
        .biPlanes = 1
        .biBitCount = 24
    End With

    BitBlt TmpDC, 0, 0, DstW, DstH, DstDC, DstX, DstY, vbSrcCopy
    BitBlt Sr2DC, 0, 0, DstW, DstH, SrcDC, 0, 0, vbSrcCopy
    GetDIBits TmpDC, TmpBmp, 0, DstH, Data1(0), Info, 0
    GetDIBits Sr2DC, Sr2Bmp, 0, DstH, Data2(0), Info, 0

    If BrushColor > 0 Then
        BrushRGB.rgbBlue = (BrushColor \ &H10000) Mod &H100
        BrushRGB.rgbGreen = (BrushColor \ &H100) Mod &H100
        BrushRGB.rgbRed = BrushColor And &HFF
    End If

    If Not useMask Then TransColor = -1

    newW = DstW - 1

    For H = 0 To DstH - 1
        F = H * DstW
        For B = 0 To newW
            i = F + B
            If GetNearestColor(hdc, CLng(Data2(i).rgbRed) + 256& * Data2(i).rgbGreen + 65536 * Data2(i).rgbBlue) <> TransColor Then
                With Data1(i)
                    If BrushColor > -1 Then
                        If MonoMask Then
                            If (CLng(Data2(i).rgbRed) + Data2(i).rgbGreen + Data2(i).rgbBlue) <= 384 Then Data1(i) = BrushRGB
                        Else
                            Data1(i) = BrushRGB
                        End If
                    Else
                        If isGreyscale Then
                            gCol = CLng(Data2(i).rgbRed * 0.3) + Data2(i).rgbGreen * 0.59 + Data2(i).rgbBlue * 0.11
                            .rgbRed = gCol: .rgbGreen = gCol: .rgbBlue = gCol
                        Else
                            If XPBlend Then
                                .rgbRed = (CLng(.rgbRed) + Data2(i).rgbRed * 2) \ 3
                                .rgbGreen = (CLng(.rgbGreen) + Data2(i).rgbGreen * 2) \ 3
                                .rgbBlue = (CLng(.rgbBlue) + Data2(i).rgbBlue * 2) \ 3
                            Else
                                Data1(i) = Data2(i)
                            End If
                        End If
                    End If
                End With
            End If
        Next B
    Next H

    SetDIBitsToDevice DstDC, DstX, DstY, DstW, DstH, 0, 0, 0, DstH, Data1(0), Info, 0

    Erase Data1, Data2
    DeleteObject SelectObject(TmpDC, TmpObj)
    DeleteObject SelectObject(Sr2DC, Sr2Obj)
    If SrcPic.Type = 3 Then DeleteObject SelectObject(SrcDC, tObj)
    DeleteDC TmpDC: DeleteDC Sr2DC
    DeleteObject tObj: DeleteDC SrcDC

End Sub

Private Function isMouseOver() As Boolean

Dim pt As POINTAPI

    GetCursorPos pt
    isMouseOver = (WindowFromPoint(pt.X, pt.Y) = hwnd)

End Function

Private Sub GetParentPic()

    On Local Error Resume Next
    Dim parentDC As Long: parentDC = GetDC(GetParent(hwnd))
    Dim rcP As RECT, rcC As RECT, rcW As RECT, pbW As Long
        inLoop = True
        UserControl.Height = 0
        DoEvents
        GetWindowRect UserControl.hwnd, rcW
        GetWindowRect GetParent(hwnd), rcP
        GetClientRect GetParent(hwnd), rcC
        pbW = ((rcP.Right - rcP.Left) - rcC.Right) \ 2
        BitBlt pDC, 0, 0, Wi, He, parentDC, rcW.Left - rcP.Left - pbW, rcW.Top - rcP.Top - ((rcP.Bottom - rcP.Top) - rcC.Bottom - pbW), vbSrcCopy
        UserControl.Height = ScaleY(He, vbPixels, vbTwips)
        ReleaseDC GetParent(hwnd), parentDC
        inLoop = False
    On Error GoTo 0

End Sub

#If isOCX Then
Public Sub About()

    frmAbout.Show 1

End Sub
#End If

':) Ulli's VB Code Formatter V2.14.7 (08/06/03 11:00:56 p.m.) 479 + 1733 = 2212 Lines
