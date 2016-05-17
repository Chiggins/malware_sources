VERSION 5.00
Begin VB.UserControl SCommandButton 
   AutoRedraw      =   -1  'True
   ClientHeight    =   4155
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4350
   DefaultCancel   =   -1  'True
   ForeColor       =   &H000000FF&
   ScaleHeight     =   277
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   290
   ToolboxBitmap   =   "SCommandButton.ctx":0000
   Begin VB.Timer OverTimer 
      Enabled         =   0   'False
      Interval        =   10
      Left            =   210
      Top             =   195
   End
End
Attribute VB_Name = "SCommandButton"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'*******************************************************'
'*        All rights Reserved © HACKPRO TM 2002        *'
'*******************************************************'
'*                   Version 1.4.0                     *'
'*******************************************************'
'* Control:       SCommandButton                       *'
'*******************************************************'
'* Author:        Heriberto Mantilla Santamaría        *'
'*******************************************************'
'* Description:   This usercontrol simulates a         *'
'*                CommandButton with 2 styles.         *'
'*******************************************************'
'* Started on:    Friday, 03-mar-2002.                 *'
'*******************************************************'
'*                   Version 1.0.0                     *'
'*                                                     *'
'* Enhancements:  - Style XP Button.       (03/06/02)  *'
'*                - Add Comments.          (05/06/02)  *'
'*                                                     *'
'* Fixed Error's: - Default Property.      (12/06/02)  *'
'*                - State Normal.          (18/08/02)  *'
'*                - State Hot.             (21/09/02)  *'
'*                - AccessKey.             (14/10/02)  *'
'*                - Caption.               (08/01/03)  *'
'*******************************************************'
'*                   Version 1.1.0                     *'
'*                                                     *'
'* Enhancements:  - New Properties.        (23/02/03)  *'
'*                - New Subs & Functions.  (15/03/03)  *'
'*                                                     *'
'* Fixed Error's: - Default Property.      (26/03/03)  *'
'*******************************************************'
'*                   Version 1.2.0                     *'
'*                                                     *'
'* Enhancements:  - Name of Control.       (02/04/03)  *'
'*                - Changed Comments.      (07/04/03)  *'
'*                - ReConfig. Subs.        (11/04/03)  *'
'*                                                     *'
'* Fixed Error's: - Font property.         (23/08/03)  *'
'*******************************************************'
'*                   Version 1.3.0                     *'
'*                                                     *'
'* Enhancements:  - Style Reflect Button   (10/12/04)  *'
'*******************************************************'
'* Release date:  Sunday, 10-dec-2004.                 *'
'*******************************************************'
'*                                                     *'
'* Note:     Comments, suggestions, doubts or bug      *'
'*           reports are wellcome to these e-mail      *'
'*           addresses:                                *'
'*                                                     *'
'*                  heri_05-hms@mixmail.com or         *'
'*                  hcammus@hotmail.com                *'
'*                                                     *'
'*        Please rate my work on this control.         *'
'*             Of Colombia for the world.              *'
'*******************************************************'
'*        All rights Reserved © HACKPRO TM 2005        *'
'*******************************************************'
Option Explicit

 '* For Drawing the Caption.
 Private Declare Function DrawText Lib "user32" Alias "DrawTextA" (ByVal hDc As Long, ByVal lpStr As String, ByVal nCount As Long, lpRect As RECT, ByVal wFormat As Long) As Long
 Private Declare Function SetTextColor Lib "gdi32" (ByVal hDc As Long, ByVal crColor As Long) As Long
  
 '* Rect Drawing.
 Private Declare Function FillRect Lib "user32" (ByVal hDc As Long, lpRect As RECT, ByVal hBrush As Long) As Long
 Private Declare Function FrameRect Lib "user32" (ByVal hDc As Long, lpRect As RECT, ByVal hBrush As Long) As Long
 
 '* Create/Delete Brush.
 Private Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
 Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
 
 '* For Drawing Lines.
 Private Declare Function LineTo Lib "gdi32" (ByVal hDc As Long, ByVal X As Long, ByVal Y As Long) As Long
 Private Declare Function MoveToEx Lib "gdi32" (ByVal hDc As Long, ByVal X As Long, ByVal Y As Long, lpPoint As POINTAPI) As Long
 
 '* Misc.
 Private Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
 Private Declare Function GetSysColor Lib "user32" (ByVal nIndex As Long) As Long
 Private Declare Function OleTranslateColor Lib "oleaut32.dll" (ByVal lOleColor As Long, ByVal lHPalette As Long, lColorRef As Long) As Long
 Private Declare Function SetPixel Lib "gdi32" Alias "SetPixelV" (ByVal hDc As Long, ByVal X As Long, ByVal Y As Long, ByVal crColor As Long) As Long
 Private Declare Function WindowFromPoint Lib "user32" (ByVal xPoint As Long, ByVal yPoint As Long) As Long
  
 '* Enum.
 Public Enum SStyle
  [XP Button] = &H0
  [Reflect Button] = &H1
 End Enum
 
 '* Center.
 Private Const DT_CENTERABS = &H65
 
 '* Default System Colours.
 Private Const COLOR_BTNFACE = 15
 Private Const COLOR_BTNDKSHADOW = 21
 Private Const COLOR_BTNHIGHLIGHT = 20
 Private Const COLOR_BTNLIGHT = 22
 Private Const COLOR_BTNSHADOW = 16
 Private Const COLOR_BTNTEXT = 18
 'Private Const COLOR_HIGHLIGHT = 13
 
 '* Rectangle.
 Private Type RECT
  Left   As Long
  Top    As Long
  Right  As Long
  Bottom As Long
 End Type

 '* Point.
 Private Type POINTAPI
  X      As Long
  Y      As Long
 End Type

 '* Events.
 Public Event Click()
 Public Event DblClick()
 Public Event KeyDown(KeyCode As Integer, Shift As Integer)
 Public Event KeyPress(KeyAscii As Integer)
 Public Event KeyUp(KeyCode As Integer, Shift As Integer)
 Public Event MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
 Public Event MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
 Public Event MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

 Private f_Focus             As Boolean
 Private g_Focus             As Boolean
 Private isDefault           As Boolean  '* Default or not.
 Private isEnabled           As Boolean  '* Enabled or not.
 Private sTrue               As Boolean
 Private CurStyle            As SStyle   '* Style Button.
 Private CurrText            As String   '* Current Caption.
 Private Height              As Long     '* Width.
 Private Width               As Long     '* Height.
 Private WithEvents CurrFont As StdFont  '* Current font.
Attribute CurrFont.VB_VarHelpID = -1
 Private LastButton          As Integer  '* Last button pressed.
 Private LastState           As Integer  '* Last property.
 Private RC                  As RECT     '* Rects Structures.
 
 '* Default System Colors.
 Private cColor              As OLE_COLOR
 Private cDarkShadow         As OLE_COLOR
 Private cFace               As OLE_COLOR
 Private cHighLight          As OLE_COLOR
 Private cLight              As OLE_COLOR
 Private cShadow             As OLE_COLOR
 Private cText               As OLE_COLOR
 
 Private myObject            As Object
 
 Private m_AccessKey         As String * 1

Private Sub OverTimer_Timer()
 If (IsMouseOver = False) Then
  OverTimer.Enabled = False
  If (UserControl.Extender.Default = True) Then g_Focus = False
  Call ReDraw(CurStyle, 1, isDefault) '* ReDraw Button.
  UserControl.Refresh
 End If
End Sub

Private Sub UserControl_AccessKeyPress(KeyAscii As Integer)
 RaiseEvent Click
End Sub

Private Sub UserControl_AmbientChanged(PropertyName As String)
 Dim Found As Boolean
 
 sTrue = False
 If (UserControl.Extender.Default = True) And (sTrue = False) Then
  sTrue = True
  Call ReDraw(CurStyle, 1, sTrue) '* ReDraw Button.
  UserControl.Tag = "oK"
 Else
  Call ReDraw(CurStyle, 1, False) '* ReDraw Button.
  UserControl.Tag = ""
 End If
On Error Resume Next
 For Each myObject In UserControl.Parent
  If (TypeOf myObject Is SCommandButton) Then
   If (myObject.Tag = "oK") Then Found = True: Exit For
  End If
 Next
 If (Found = False) Then sTrue = False
 UserControl.Refresh
End Sub

'* Double click.
Private Sub UserControl_DblClick()
 If (LastButton = 1) Then
  '* Call the MouseDown Sub.
  Call UserControl_MouseDown(1, 1, 1, 1)
  UserControl.Refresh
 End If
End Sub

Private Sub UserControl_EnterFocus()
 f_Focus = True
 UserControl.Refresh
End Sub

Private Sub UserControl_ExitFocus()
 f_Focus = False
 OverTimer.Enabled = False
 UserControl.Refresh
End Sub

Private Sub UserControl_GotFocus()
 f_Focus = True
 UserControl.Refresh
 Call ReDraw(CurStyle, LastState, isDefault) '* ReDraw Button.
End Sub

'* Initialize.
Private Sub UserControl_Initialize()
 LastButton = 2 '* Lastbutton = Left Mouse Button.
On Error Resume Next
 Set CurrFont = New StdFont
 Call SetColors '* Get Default Colors.
End Sub

'* InitProperties.
Private Sub UserControl_InitProperties()
On Error Resume Next
 cColor = GetSysColor(COLOR_BTNTEXT)
 CurStyle = &H0
 CurrText = "Caption"        '* Caption.
 isEnabled = True            '* Enabled.
 isDefault = False           '* Default.
 Set CurrFont = Ambient.Font '* Font.
 Call ReDraw(CurStyle, LastState, isDefault) '* ReDraw Button.
End Sub

Private Sub UserControl_KeyDown(KeyCode As Integer, Shift As Integer)
 Select Case KeyCode
  Case vbKeyRight, vbKeyDown
   Call SendKeys("{TAB}")
  Case vbKeyLeft, vbKeyUp
   Call SendKeys("+{TAB}")
 End Select
 RaiseEvent KeyDown(KeyCode, Shift)
End Sub

Private Sub UserControl_KeyPress(KeyAscii As Integer)
 RaiseEvent KeyPress(KeyAscii)
End Sub

Private Sub UserControl_KeyUp(KeyCode As Integer, Shift As Integer)
 RaiseEvent KeyUp(KeyCode, Shift)
 UserControl.Refresh
End Sub

Private Sub UserControl_LostFocus()
 Call ReDraw(CurStyle, LastState, isDefault) '* ReDraw Button.
 UserControl.Refresh
End Sub

'* MouseDown.
Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
 LastButton = Button    '* Set LastButton.
 If (Button <> 2) And (isEnabled = True) Then
  If (UserControl.Extender.Default = True) Then
   Call ReDraw(CurStyle, 4, True)  '* ReDraw Button.
  Else
   OverTimer.Enabled = False
   Call ReDraw(CurStyle, 2, False) '* ReDraw Button.
  End If
 End If
 '* Raise MouseDown Event.
 RaiseEvent MouseDown(Button, Shift, X, Y)
 RaiseEvent Click
End Sub

'* MouseMove.
Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
 Dim tmpState As Integer
 
 '* Not inside button.
 If Not (IsMouseOver = True) Then
  tmpState = LastState
  Call ReDraw(CurStyle, 1, isDefault)  '* ReDraw Button.
  LastState = tmpState
 Else
  If (Button <> 1) Then
   OverTimer.Enabled = True
   Call ReDraw(CurStyle, 3, isDefault) '* ReDraw Button.
  Else
   Call ReDraw(CurStyle, LastState, UserControl.Extender.Default) '* ReDraw Button.
  End If
 End If
 '* Raise MouseMove Event.
 RaiseEvent MouseMove(Button, Shift, X, Y)
 UserControl.Refresh
End Sub

'* Mouseup.
Private Sub UserControl_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
 If (Button <> 2) And (isEnabled = True) Then
  If Not (IsMouseOver = True) Then
   Call ReDraw(CurStyle, 1, UserControl.Extender.Default) '* ReDraw Button.
  Else
   Call ReDraw(CurStyle, 3, UserControl.Extender.Default) '* ReDraw Button.
  End If
 End If
 '* Raise MouseUp Event.
 UserControl.Refresh
 RaiseEvent MouseUp(Button, Shift, X, Y)
End Sub

'* Property Get: Caption.
Public Property Get Caption() As String
Attribute Caption.VB_Description = "Devuelve o establece el texto mostrado en la barra de título de un Objeto o bajo el icono de un Objeto."
Attribute Caption.VB_ProcData.VB_Invoke_Property = ";Texto"
Attribute Caption.VB_UserMemId = -518
 Caption = CurrText '* Return Caption.
End Property

'* Property Let: Caption.
Public Property Let Caption(ByVal NewValue As String)
 If (CurrText = NewValue) Then Exit Property
 CurrText = NewValue             '* Set Caption.
 Call PropertyChanged("Caption") '* Last Property Changed is Text.
 Call ReDraw(CurStyle)           '* ReDraw Button.
 Call SetAccessKey
End Property

'* Property Get: Enabled.
Public Property Get Enabled() As Boolean
Attribute Enabled.VB_Description = "Devuelve o establece un valor que determina si un Objeto puede responder a eventos generados por el usuario."
 Enabled = isEnabled '* Set Enabled/Disabled.
End Property

'* Property Let: Enabled.
Public Property Let Enabled(ByVal NewValue As Boolean)
 isEnabled = NewValue            '* Set enabled/disabled.
 Call ReDraw(CurStyle)           '* ReDraw Button.
 UserControl.Enabled = isEnabled '* Set enabled/disabled.
 Call PropertyChanged("Enabled") '* Last Property Changed is Enabled.
End Property

'* Property Get: Default.
Public Property Get Default() As Boolean
 Default = isDefault '* Set Default.
End Property

'* Property Let: Default.
Public Property Let Default(ByVal NewValue As Boolean)
 isDefault = NewValue            '* Set Default.
 Call ReDraw(CurStyle)           '* ReDraw Button.
 Call PropertyChanged("Default") '* Last Property Changed is Default.
End Property

'* Property Get: Font.
Public Property Get Font() As StdFont
Attribute Font.VB_Description = "Devuelve un objeto Font."
 Set Font = CurrFont '* Return font.
End Property

'* Property Set: Font.
Public Property Set Font(ByRef newFont As StdFont)
On Error Resume Next
 Set CurrFont = newFont          '* Set Font.
 Set UserControl.Font = CurrFont '* Set Font.
 Call ReDraw(CurStyle)           '* ReDraw Button.
 Call PropertyChanged("Font")    '* Last Property Changed is Font.
End Property

'* Property Get: ForeColor.
Public Property Get ForeColor() As OLE_COLOR
 ForeColor = cColor
End Property

'* Property Let: ForeColor.
Public Property Let ForeColor(ByVal New_ForeColor As OLE_COLOR)
 cColor = New_ForeColor
 Call ReDraw(CurStyle) '* ReDraw Button.
 Call PropertyChanged("ForeColor")
End Property

'* Property Get: MouseIcon.
Public Property Get MouseIcon() As StdPicture
Attribute MouseIcon.VB_Description = "Establece un icono personalizado para el mouse."
 Set MouseIcon = UserControl.MouseIcon
End Property

'* Property Set: MouseIcon.
Public Property Set MouseIcon(ByVal New_MouseIcon As StdPicture)
 Set UserControl.MouseIcon = New_MouseIcon
 Call PropertyChanged("MouseIcon")
End Property

'* Property Get: hWnd.
Public Property Get hWnd() As Long
 hWnd = UserControl.hWnd '* Return hWnd.
End Property

'* Property Get: MousePointer.
Public Property Get MousePointer() As MousePointerConstants
Attribute MousePointer.VB_Description = "Devuelve o establece el tipo de puntero del mouse mostrado al pasar por encima de un Objeto."
 MousePointer = UserControl.MousePointer
End Property

'* Property Let: MousePointer.
Public Property Let MousePointer(ByVal New_MousePointer As MousePointerConstants)
 UserControl.MousePointer() = New_MousePointer
 Call PropertyChanged("MousePointer")
End Property

Public Property Let StyleButton(ByVal NewStyle As SStyle)
 CurStyle = NewStyle
 Call PropertyChanged("StyleButton")
 Call ReDraw(CurStyle)
End Property

Public Property Get StyleButton() As SStyle
 StyleButton = CurStyle
End Property

'* Resize.
Private Sub UserControl_Resize()
 '* ReNew Dimension Variables.
 Height = UserControl.ScaleHeight
 Width = UserControl.ScaleWidth
 '* Set Rect.
 RC.Bottom = Height
 RC.Right = Width
 Call ReDraw(CurStyle) '* ReDraw Button.
 UserControl.Refresh
End Sub

'* Read Properties.
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
On Error Resume Next
 ForeColor = PropBag.ReadProperty("ForeColor", GetSysColor(COLOR_BTNTEXT))
 Caption = PropBag.ReadProperty("Caption", "Caption")                      '* Caption.
 Enabled = PropBag.ReadProperty("Enabled", True)                            '* Enabled.
 Default = PropBag.ReadProperty("Default", isDefault)                       '* Default.
 Set CurrFont = PropBag.ReadProperty("Font", Ambient.Font)                  '* Font.
 Set MouseIcon = PropBag.ReadProperty("MouseIcon", Nothing)                 '* MouseIcon.
 StyleButton = PropBag.ReadProperty("StyleButton", &H0)
 UserControl.MousePointer = PropBag.ReadProperty("MousePointer", vbDefault) '* MousePointer.
 UserControl.Enabled = isEnabled                                            '* Set Enabled State.
 Set UserControl.Font = CurrFont                                            '* Set Font.
 Call SetColors                                                             '* Set Colours.
 Call SetAccessKey
 sTrue = False
 UserControl.Tag = ""
 Call ReDraw(CurStyle) '* ReDraw Button.
 UserControl.Refresh
End Sub

Private Sub UserControl_Show()
 isDefault = Default
 OverTimer.Enabled = UserControl.Ambient.UserMode
End Sub

'* Write properties.
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
On Error Resume Next
 Call PropBag.WriteProperty("ForeColor", cColor, GetSysColor(COLOR_BTNTEXT))
 Call PropBag.WriteProperty("Caption", CurrText, "Caption")                      '* Caption.
 Call PropBag.WriteProperty("Enabled", isEnabled, True)                          '* Enabled State.
 Call PropBag.WriteProperty("Default", Default, False)                           '* Default State.
 Call PropBag.WriteProperty("Font", CurrFont, Ambient.Font)                      '* Font.
 Call PropBag.WriteProperty("MouseIcon", MouseIcon, Nothing)                     '* MouseIcon.
 Call PropBag.WriteProperty("MousePointer", UserControl.MousePointer, vbDefault) '* MousePointer.
 Call PropBag.WriteProperty("StyleButton", CurStyle, &H0)
End Sub

Private Function ConvertSystemColor(ByVal theColor As Long) As Long
 Call OleTranslateColor(theColor, 0, ConvertSystemColor)
End Function

Private Sub DrawCaption(ByVal lColor As Long)
 Call SetTextColor(UserControl.hDc, IIf(isEnabled = True, cColor, ShiftColor(lColor, -&H68)))
 Call DrawText(UserControl.hDc, CurrText, Len(CurrText), RC, DT_CENTERABS)
End Sub

Private Sub DrawCorners(ByVal iColor1 As Long)
 '* Draw Corners.
 Call SetPixel(UserControl.hDc, 1, 1, iColor1)
 Call SetPixel(UserControl.hDc, 1, Height - 2, iColor1)
 Call SetPixel(UserControl.hDc, Width - 2, 1, iColor1)
 Call SetPixel(UserControl.hDc, Width - 2, Height - 2, iColor1)
End Sub

Private Sub DrawHighLights(ByVal XPFace As Long, ByVal iColor1 As Long, ByVal iColor2 As Long, ByVal iColor3 As Long, ByVal iColor4 As Long)
 '* Draw HighLights.
 Call DrawLine(2, 1, Width - 2, 1, ShiftColor(XPFace, iColor1))
 Call DrawLine(1, 2, Width - 2, 2, ShiftColor(XPFace, iColor2))
 Call DrawLine(1, 2, 1, Height - 2, ShiftColor(XPFace, iColor3))
 Call DrawLine(2, 3, 2, Height - 3, ShiftColor(XPFace, iColor4))
End Sub

Private Sub DrawLine(ByVal X1 As Long, ByVal Y1 As Long, ByVal x2 As Long, ByVal y2 As Long, ByVal lColor As Long)
 Dim PT As POINTAPI

 '* Draw line.
 UserControl.ForeColor = lColor              '* Set Forecolor.
 Call MoveToEx(UserControl.hDc, X1, Y1, PT)  '* Move To X1/Y1.
 Call LineTo(UserControl.hDc, x2, y2)        '* Draw Line To X2/Y2.
End Sub

Private Sub DrawOutLine(ByVal iColor1 As Long)
 '* Draw OutLine.
 Call DrawLine(2, 0, Width - 2, 0, iColor1)
 Call DrawLine(2, Height - 1, Width - 2, Height - 1, iColor1)
 Call DrawLine(0, 2, 0, Height - 2, iColor1)
 Call DrawLine(Width - 1, 2, Width - 1, Height - 2, iColor1)
End Sub

Private Sub DrawReflectButton(ByVal Mode As Integer, Optional ByVal Token As Boolean = False)
 Dim tmpColor     As Long, isColor1  As Long, SetColor1 As Long
 Dim isColor2     As Long, SetColor2 As Long, isHotC1   As Long
   
 '* Reflect Style was designed by HACKPRO TM (Heriberto Mantilla Santamaría).
On Error Resume Next
 tmpColor = cFace
 If (isEnabled = True) Then
  Select Case Mode
   Case 1
    isColor1 = OffSetColor(cHighLight, -6)
    isColor2 = OffSetColor(cShadow, -6)
   Case 2
    isColor1 = OffSetColor(cFace, &H25)
    isColor2 = OffSetColor(cShadow, -&H35)
   Case 3
    isColor1 = msSoftColor(cHighLight)
    isColor2 = OffSetColor(cFace, -87)
   Case 4
    If (Token = True) Then
     isColor1 = OffSetColor(cFace, &H25)
     isColor2 = OffSetColor(cShadow, -&H35)
    Else
     isColor1 = OffSetColor(cFace, -&H35)
     isColor2 = OffSetColor(cFace, -&H15)
    End If
  End Select
 Else
  isColor1 = OffSetColor(cFace, -&H5)
  isColor2 = OffSetColor(cFace, -&H15)
 End If
 SetColor1 = &H35
 SetColor2 = &H32
 isHotC1 = isColor1
 Call DrawVGradient(SoftColor(isColor2), SoftColor(isColor1), 1, 1, Width - 1, Height - 3)
 Call DrawVGradient(OffSetColor(isColor1, 45), OffSetColor(isColor2, 15), 4, 5, Width - 3, Height - 11)
 '* Top Lines.
 Call DrawLine(2, 1, Width - 2, 1, OffSetColor(tmpColor, &H5))
 Call DrawLine(1, 2, Width - 1, 2, OffSetColor(tmpColor, &H2))
 Call DrawLine(5, 4, Width - 4, 4, OffSetColor(isHotC1, SetColor1))
 Call DrawLine(4, 5, Width - 4, 5, OffSetColor(isHotC1, SetColor2))
 SetColor1 = &H15
 SetColor2 = &H12
 isHotC1 = isColor2
 '* Bottom Lines.
 Call DrawLine(1, Height - 3, Width - 1, Height - 3, OffSetColor(tmpColor, -&H10))
 Call DrawLine(1, Height - 2, Width - 1, Height - 2, OffSetColor(tmpColor, -&H18))
 Call DrawLine(4, Height - 6, Width - 4, Height - 6, OffSetColor(isHotC1, SetColor1))
 Call DrawLine(5, Height - 5, Width - 4, Height - 5, OffSetColor(isHotC1, SetColor2))
 '* Border.
 tmpColor = OffSetColor(tmpColor, -256)
 If (isEnabled = True) Then
  If (f_Focus = True) And (Ambient.DisplayAsDefault = True) Then
   Call DrawRBorder(OffSetColor(cDarkShadow, -&H20))
  Else
   Call DrawRBorder(OffSetColor(cDarkShadow, &H15))
  End If
 Else
  Call DrawRBorder(ShiftColor(cFace, -&H34))
 End If
 Call DrawPBorder '* Border Pixels.
 Call DrawCaption(ShiftColor(cFace, &H30)) '* Draw Caption.
 LastState = Mode                          '* Set property.
 UserControl.Refresh
End Sub

Private Sub DrawPBorder()
 Dim tmpColor As Long
 
 '* Border Pixels.
On Error Resume Next
 tmpColor = ConvertSystemColor(Parent.BackColor)
 Call SetPixel(UserControl.hDc, 0, 0, tmpColor)
 Call SetPixel(UserControl.hDc, Width - 1, 0, tmpColor)
 Call SetPixel(UserControl.hDc, 0, Height - 1, tmpColor)
 Call SetPixel(UserControl.hDc, Width - 1, Height - 1, tmpColor)
 Call SetPixel(UserControl.hDc, 1, 0, tmpColor)
 Call SetPixel(UserControl.hDc, Width - 2, 0, tmpColor)
 Call SetPixel(UserControl.hDc, 0, 1, tmpColor)
 Call SetPixel(UserControl.hDc, 0, Height - 2, tmpColor)
 Call SetPixel(UserControl.hDc, 1, Height - 1, tmpColor)
 Call SetPixel(UserControl.hDc, Width - 2, Height - 1, tmpColor)
 Call SetPixel(UserControl.hDc, Width - 1, 1, tmpColor)
 Call SetPixel(UserControl.hDc, Width - 1, Height - 2, tmpColor)
End Sub

Private Sub DrawRBorder(ByVal lColor As Long)
 Call DrawLine(2, 0, Width - 2, 0, lColor)
 Call DrawLine(2, Height - 1, Width - 2, Height - 1, lColor)
 Call DrawLine(0, 2, 0, Height - 2, lColor)
 Call DrawLine(Width - 1, 2, Width - 1, Height - 2, lColor)
 Call DrawLine(5, 3, Width - 5, 3, lColor)
 Call DrawLine(5, Height - 4, Width - 5, Height - 4, lColor)
 Call DrawLine(3, 5, 3, Height - 5, lColor)
 Call DrawLine(Width - 4, 5, Width - 4, Height - 5, lColor)
 Call SetPixel(UserControl.hDc, 1, 1, lColor)
 Call SetPixel(UserControl.hDc, 1, Height - 2, lColor)
 Call SetPixel(UserControl.hDc, Width - 2, 1, lColor)
 Call SetPixel(UserControl.hDc, Width - 2, Height - 2, lColor)
 Call SetPixel(UserControl.hDc, 4, 4, lColor)
 Call SetPixel(UserControl.hDc, 4, Height - 5, lColor)
 Call SetPixel(UserControl.hDc, Width - 5, 4, lColor)
 Call SetPixel(UserControl.hDc, Width - 5, Height - 5, lColor)
End Sub

'* Draw Rectangle.
Private Sub DrawRectangle(ByVal X As Long, ByVal Y As Long, ByVal Width As Long, ByVal Height As Long, ByVal Color As Long, Optional OnlyBorder As Boolean = False)
 Dim bRECT  As RECT, hBrush As Long

 '* Fill out Rect.
 bRECT.Left = X
 bRECT.Top = Y
 bRECT.Right = X + Width
 bRECT.Bottom = Y + Height
 '* Create brush.
 hBrush = CreateSolidBrush(Color)
 If (OnlyBorder = False) Then  '* Just border.
  Call FillRect(UserControl.hDc, bRECT, hBrush)
 Else '* Fill whole Rect.
  Call FrameRect(UserControl.hDc, bRECT, hBrush)
 End If
 '* Delete brush.
 Call DeleteObject(hBrush)
End Sub

Private Sub DrawShadow(ByVal XPFace As Long, ByVal iColor1 As Long, ByVal iColor2 As Long, ByVal iColor3 As Long, ByVal iColor4 As Long)
 '* Draw Shadows.
 Call DrawLine(2, Height - 2, Width - 2, Height - 2, ShiftColor(XPFace, iColor1))
 Call DrawLine(1, Height - 3, Width - 2, Height - 3, ShiftColor(XPFace, iColor2))
 Call DrawLine(Width - 2, 2, Width - 2, Height - 2, ShiftColor(XPFace, iColor3))
 Call DrawLine(Width - 3, 3, Width - 3, Height - 3, ShiftColor(XPFace, iColor4))
End Sub

Private Sub DrawVGradient(lEndColor As Long, lStartColor As Long, ByVal X As Long, ByVal Y As Long, ByVal x2 As Long, ByVal y2 As Long)
 '* Draw a Vertical Gradient in the current hDC.
 Dim dR As Single, dG As Single, dB As Single
 Dim sR As Single, sG As Single, Sb As Single
 Dim eR As Single, eG As Single, eB As Single
 Dim ni As Long
 
 sR = (lStartColor And &HFF)
 sG = (lStartColor \ &H100) And &HFF
 Sb = (lStartColor And &HFF0000) / &H10000
 eR = (lEndColor And &HFF)
 eG = (lEndColor \ &H100) And &HFF
 eB = (lEndColor And &HFF0000) / &H10000
 dR = (sR - eR) / y2
 dG = (sG - eG) / y2
 dB = (Sb - eB) / y2
 For ni = 0 To y2
  Call DrawLine(X, Y + ni, x2, Y + ni, RGB(eR + (ni * dR), eG + (ni * dG), eB + (ni * dB)))
 Next
End Sub

Private Function IsMouseOver() As Boolean
 Dim PT As POINTAPI
 
 '* Mouse inside the button.
 Call GetCursorPos(PT)
 IsMouseOver = (WindowFromPoint(PT.X, PT.Y) = hWnd)
End Function

Private Function msSoftColor(ByVal lColor As Long) As Long
 Dim lRed  As Long, lGreen As Long, lB As Long
 Dim lBlue As Long, lR     As Long, lG As Long
 
 lR = (lColor And &HFF)
 lG = ((lColor And 65280) \ 256)
 lB = ((lColor) And 16711680) \ 65536
 lRed = (76 - Int(((lColor And &HFF) + 32) \ 64) * 19)
 lGreen = (76 - Int((((lColor And 65280) \ 256) + 32) \ 64) * 19)
 lBlue = (76 - Int((((lColor And &HFF0000) \ &H10000) + 32) / 64) * 19)
 msSoftColor = RGB(lR + lRed, lG + lGreen, lB + lBlue)
End Function

Private Function MSOXPShiftColor(ByVal theColor As Long, Optional ByVal Base As Long = &HB0) As Long
 Dim Red   As Long, Blue  As Long
 Dim Delta As Long, Green As Long
   
 Blue = ((theColor \ &H10000) Mod &H100)
 Green = ((theColor \ &H100) Mod &H100)
 Red = (theColor And &HFF)
 Delta = &HFF - Base
 Blue = Base + Blue * Delta \ &HFF
 Green = Base + Green * Delta \ &HFF
 Red = Base + Red * Delta \ &HFF
 If (Red > 255) Then Red = 255
 If (Green > 255) Then Green = 255
 If (Blue > 255) Then Blue = 255
 MSOXPShiftColor = Red + 256& * Green + 65536 * Blue
End Function

'* Offset a color.
Private Function OffSetColor(ByVal lColor As OLE_COLOR, ByVal lOffset As Long) As OLE_COLOR
 Dim lRed  As OLE_COLOR, lGreen As OLE_COLOR
 Dim lBlue As OLE_COLOR, lR     As OLE_COLOR
 Dim lG    As OLE_COLOR, lB     As OLE_COLOR
   
 lR = (lColor And &HFF)
 lG = ((lColor And 65280) \ 256)
 lB = ((lColor) And 16711680) \ 65536
 lRed = (lOffset + lR)
 lGreen = (lOffset + lG)
 lBlue = (lOffset + lB)
 If (lRed > 255) Then lRed = 255
 If (lRed < 0) Then lRed = 0
 If (lGreen > 255) Then lGreen = 255
 If (lGreen < 0) Then lGreen = 0
 If (lBlue > 255) Then lBlue = 255
 If (lBlue < 0) Then lBlue = 0
 OffSetColor = RGB(lRed, lGreen, lBlue)
End Function

'* ReDraw Button.
Private Sub ReDraw(Optional ByVal StyleBtt As SStyle = &H0, Optional ByVal State As Integer = 1, Optional ByVal Token As Boolean = False)
 Dim StepXP1 As Single, XPFace As Long, i As Long
  
On Error GoTo myErr
 If (State = 1) And (UserControl.Extender.Default = True) And (g_Focus = False) Then
  State = 4
  Token = False
 End If
 GoTo noErr
myErr:
 State = 1
 Token = False
 isEnabled = True
noErr:
 With UserControl
  If (Height <= 0) Then Height = 255
  If (Width <= 0) Then Width = 255
  .Cls
  .AutoRedraw = True
  If (StyleBtt = &H1) Then Call DrawReflectButton(State, Token): Exit Sub
  '* Draw button face.
 On Error Resume Next
  .BackColor = Parent.BackColor
  If (isEnabled = True) Then         '* If enabled.
   Call DrawRectangle(0, 0, Width, Height, cFace)
   If (State = 1) Then               '* If button is up.
    StepXP1 = 25 / Height            '* Gradient Step.
    XPFace = ShiftColor(cFace, &H30) '* Shift Color.
    For i = 1 To Height
     Call DrawLine(0, i, Width, i, ShiftColor(XPFace, -StepXP1 * i))
    Next
    '* Draw Shadows.
    Call DrawShadow(XPFace, -&H30, -&H20, -&H24, -&H18)
    '* Draw HighLights.
    Call DrawHighLights(XPFace, &H10, &HA, -&H5, -&HA)
   ElseIf (State = 2) Then           '* Button is Down.
    StepXP1 = 15 / Height            '* Set Gradient Step.
    '&H30
    XPFace = ShiftColor(cDarkShadow, &H50) '* Shift Color.
    'XPFace = ShiftColor(XPFace, -&H20)
    '* Draw Gradient BackGround.
    For i = 1 To Height
     Call DrawLine(0, Height - i, Width, Height - i, ShiftColor(XPFace, -StepXP1 * i))
    Next i
    '* Draw Shadows.
    Call DrawShadow(XPFace, &H10, &HA, &H5, &H0)
    '* Draw HighLights.
    Call DrawHighLights(XPFace, -&H20, -&H18, -&H20, -&H16)
   ElseIf (State = 3) Then           '* Highlight Button.
    StepXP1 = 25 / Height            '* Gradient Step.
    '&H30
    XPFace = ShiftColor(cShadow, &H40) '* Shift Color.
    'XPFace = ShiftColor(XPFace, -&H25)
    '* Draw Gradient BackGround.
    For i = 1 To Height
     Call DrawLine(0, i, Width, i, ShiftColor(XPFace, -StepXP1 * i))
    Next
    '* Draw Shadows.
    Call DrawShadow(XPFace, -&H30, -&H20, -&H24, -&H18)
    '* Draw HighLights.
    Call DrawHighLights(XPFace, &H10, &HA, -&H5, -&HA)
   ElseIf (State = 4) Then            '* Default State.
    OverTimer.Enabled = False
    If (Token = True) Then            '* Button is down.
     StepXP1 = &H19 / Height          '* Gradient Step.
     XPFace = ShiftColor(cFace, &H76) '* Shift Color.
     '* Draw Gradient BackGround.
     For i = 1 To Height
      Call DrawLine(0, Height - i, Width, Height - i, ShiftColor(XPFace, -StepXP1 * i))
     Next i
     '* Draw Shadows.
     Call DrawShadow(XPFace, &H10, &HA, &H5, &H0)
     '* Draw HighLights.
     Call DrawHighLights(XPFace, -&H20, -&H18, -&H20, -&H16)
    Else
     StepXP1 = -&H8 / Height          '* Gradient Step.
     XPFace = ShiftColor(cFace, &H90) '* Shift Color.
     '* Draw Gradient BackGround.
     For i = 1 To Height
      Call DrawLine(0, i, Width, i, ShiftColor(XPFace, -StepXP1 * i))
     Next
     '* Draw HighLights.
     Call DrawHighLights(XPFace, &H10, &HA, -&H5, -&HA)
     '* Draw Shadows.
     Call DrawShadow(XPFace, -&H30, -&H20, -&H24, -&H18)
    End If
   End If
   If (f_Focus = True) And (Ambient.DisplayAsDefault = True) Then
    Call DrawOutLine(OffSetColor(cDarkShadow, -&H20)) '* Draw OutLine.
    Call DrawCorners(OffSetColor(cDarkShadow, -&H20)) '* Draw Corners.
   Else
    Call DrawOutLine(OffSetColor(cDarkShadow, &H15))  '* Draw OutLine.
    Call DrawCorners(OffSetColor(cDarkShadow, &H15))  '* Draw Corners.
   End If
  Else                              '* Disabled State.
   XPFace = ShiftColor(cFace, &H30) '* Shift Color.
   '* Draw button face.
   Call DrawRectangle(0, 0, Width, Height, ShiftColor(XPFace, -&H18))
   Call DrawOutLine(ShiftColor(XPFace, -&H54)) '* Draw OutLine.
   Call DrawCorners(ShiftColor(XPFace, -&H48)) '* Draw Corners.
  End If
  Call DrawPBorder         '* Border Pixels.
  Call DrawCaption(XPFace) '* Draw Caption.
 End With
 LastState = State  '* Set property.
 UserControl.Refresh
End Sub

Private Sub SetAccessKey()
On Error GoTo NoAccessKeys
 Dim i As Integer
    
 m_AccessKey = vbNullString
 i = Len(CurrText)
 Do
  i = InStrRev(CurrText, "&", i)
  If (i = 1) Then
   GoTo SkipCheck
  ElseIf (i = Len(CurrText)) Then
   GoTo NoAccessKeys
  End If
  If (Mid$(CurrText, Abs(i - 1), 1) = "&") Then
   i = i - 2
  Else
SkipCheck:
   m_AccessKey = Mid$(CurrText, i + 1, 1)
  End If
 Loop Until ((m_AccessKey <> vbNullString) Or (i = 0))
 UserControl.AccessKeys = m_AccessKey
Exit Sub
NoAccessKeys:
 m_AccessKey = vbNullString
 UserControl.AccessKeys = vbNullString
End Sub

'* Set Colours.
Private Sub SetColors()
 '* Get System Colours and save into variables.
 'cFace = RGB(200, 200, 255)
 cFace = GetSysColor(COLOR_BTNFACE)
 cShadow = GetSysColor(COLOR_BTNSHADOW)
 cLight = GetSysColor(COLOR_BTNLIGHT)
 cDarkShadow = GetSysColor(COLOR_BTNDKSHADOW)
 cHighLight = GetSysColor(COLOR_BTNHIGHLIGHT)
 cText = GetSysColor(COLOR_BTNTEXT)
End Sub

'* Shift Colors.
Private Function ShiftColor(ByVal Color As Long, ByVal Value As Long) As Long
 Dim Red As Long, Blue As Long, Green As Long

 '* Shift Blue.
On Error Resume Next
 Blue = ((Color \ &H10000) Mod &H100)
 Blue = Blue + ((Blue * Value) \ &HC0)
 '* Shift Green.
 Green = ((Color \ &H100) Mod &H100) + Value
 '* Shift Red.
 Red = (Color And &HFF) + Value
 '* Check Red bounds.
 If (Red < 0) Then
  Red = 0
 ElseIf (Red > 255) Then
  Red = 255
 End If
 '* Check Green bounds.
 If (Green < 0) Then
  Green = 0
 ElseIf (Green > 255) Then
  Green = 255
 End If
 '* Check Blue bounds.
 If (Blue < 0) Then
  Blue = 0
 ElseIf (Blue > 255) Then
  Blue = 255
 End If
 '* Return Color.
 ShiftColor = RGB(Red, Green, Blue)
End Function

Private Function SoftColor(ByVal lColor As OLE_COLOR) As OLE_COLOR
 Dim lRed  As OLE_COLOR, lGreen As OLE_COLOR
 Dim lBlue As OLE_COLOR, lR     As OLE_COLOR
 Dim lG    As OLE_COLOR, lB     As OLE_COLOR
   
 lR = (lColor And &HFF)
 lG = ((lColor And 65280) \ 256)
 lB = ((lColor) And 16711680) \ 65536
 lRed = (76 - Int(((lColor And &HFF) + 32) \ 64) * 19)
 lGreen = (76 - Int((((lColor And 65280) \ 256) + 32) \ 64) * 19)
 lBlue = (76 - Int((((lColor And &HFF0000) \ &H10000) + 32) / 64) * 19)
 SoftColor = RGB(lR + lRed, lG + lGreen, lB + lBlue)
End Function
