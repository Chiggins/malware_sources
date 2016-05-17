VERSION 5.00
Begin VB.UserControl Check 
   ClientHeight    =   1485
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   1695
   ScaleHeight     =   1485
   ScaleWidth      =   1695
   ToolboxBitmap   =   "Check.ctx":0000
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Height          =   195
      Left            =   0
      ScaleHeight     =   195
      ScaleWidth      =   195
      TabIndex        =   0
      Top             =   0
      Width           =   195
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   10
      Left            =   1110
      Top             =   720
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   195
      Left            =   -30
      TabIndex        =   1
      Top             =   0
      Width           =   855
   End
   Begin VB.Image CheckedDisabled 
      Height          =   195
      Left            =   720
      Picture         =   "Check.ctx":0312
      Top             =   930
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Image DisabledNoValue 
      Height          =   195
      Left            =   720
      Picture         =   "Check.ctx":0D3F
      Top             =   720
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Image DisabledGrey 
      Height          =   195
      Left            =   720
      Picture         =   "Check.ctx":1747
      Top             =   1140
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Image PushedNoValue 
      Height          =   195
      Left            =   510
      Picture         =   "Check.ctx":217B
      Top             =   720
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Image PushedGreyed 
      Height          =   195
      Left            =   510
      Picture         =   "Check.ctx":2CD3
      Top             =   1140
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Image PushedChecked 
      Height          =   195
      Left            =   510
      Picture         =   "Check.ctx":3867
      Top             =   930
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Image MouseoverGreyed 
      Height          =   195
      Left            =   300
      Picture         =   "Check.ctx":440D
      Top             =   1140
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Image MouseoverChecked 
      Height          =   195
      Left            =   300
      Picture         =   "Check.ctx":4FE5
      Top             =   930
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Image IdleGreyed 
      Height          =   195
      Left            =   90
      Picture         =   "Check.ctx":5BDF
      Top             =   1140
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Image MouseoverNoValue 
      Height          =   195
      Left            =   300
      Picture         =   "Check.ctx":6753
      Top             =   720
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Image IdleChecked 
      Height          =   195
      Left            =   90
      Picture         =   "Check.ctx":7307
      Top             =   930
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.Image IdleNoValue 
      Height          =   195
      Left            =   90
      Picture         =   "Check.ctx":7EBE
      Top             =   720
      Visible         =   0   'False
      Width           =   195
   End
End
Attribute VB_Name = "Check"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private Declare Function GetCursorPos Lib "user32.dll" (lpPoint As POINT_TYPE) As Long
Private Declare Function WindowFromPoint Lib "user32.dll" (ByVal xPoint As Long, ByVal yPoint As Long) As Long
Private Declare Function IsChild Lib "user32.dll" (ByVal hWndParent As Long, ByVal hWnd As Long) As Long

Private Type POINT_TYPE
  X As Long
  Y As Long
End Type

Enum CheckTypes
    Unchecked = 0
    Checked = 1
    Greyed = 2
End Enum

Dim Respond As Boolean
Dim OValue As CheckTypes
Dim isEnabled As Boolean

Event Click()
Event DblClick()
Event MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
Event MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
'Default Property Values:
Const m_def_DisabledColor = &HC0C0C0
'Property Variables:
Dim m_ForeColor As OLE_COLOR
Dim m_DisabledColor As OLE_COLOR

Private Sub picture1_DblClick()
If Respond = False Then Exit Sub
RaiseEvent DblClick
End Sub

Private Sub picture1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
On Error Resume Next
If Respond = False Then Exit Sub

RaiseEvent MouseDown(Button, Shift, X, Y)
If Button = 2 Then Exit Sub

Timer1.Enabled = False
Select Case OValue
Case Checked
    Picture1.Picture = PushedChecked.Picture: OValue = 0
Case Unchecked
    Picture1.Picture = PushedNoValue.Picture: OValue = 1
Case Greyed
    Picture1.Picture = PushedGreyed.Picture: OValue = 0
End Select
End Sub

Private Sub picture1_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
On Error Resume Next
If Respond = False Or Button = 2 Then Exit Sub
RaiseEvent Click
Timer1.Enabled = True
End Sub

Private Sub Label1_DblClick()
RaiseEvent DblClick
End Sub

Private Sub check1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
picture1_MouseDown Button, Shift, X, Y
End Sub

Private Sub check1_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
picture1_MouseUp Button, Shift, X, Y
End Sub

Private Sub Timer1_Timer()
On Error Resume Next
Dim CursorPos As POINT_TYPE

GetCursorPos CursorPos

If Enabled = False Then Exit Sub

po = WindowFromPoint(CursorPos.X, CursorPos.Y)
If WindowFromPoint(CursorPos.X, CursorPos.Y) = Check1.hWnd Or WindowFromPoint(CursorPos.X, CursorPos.Y) = Picture1.hWnd Then
    Select Case OValue
    Case Checked
        Picture1.Picture = MouseoverChecked.Picture
    Case Unchecked
        Picture1.Picture = MouseoverNoValue.Picture
    Case Greyed
        Picture1.Picture = MouseoverGreyed.Picture
    End Select
        Else
            Select Case OValue
            Case Checked
                Picture1.Picture = IdleChecked.Picture
            Case Unchecked
                Picture1.Picture = IdleNoValue.Picture
            Case Greyed
                Picture1.Picture = IdleGreyed.Picture
            End Select
End If


End Sub

Property Let Value(Yes As CheckTypes)
On Error Resume Next
OValue = Yes

Select Case Yes
Case Checked
    If isEnabled = True Then Picture1.Picture = IdleChecked.Picture Else Picture1.Picture = CheckedDisabled.Picture
Case Unchecked
    If isEnabled = True Then Picture1.Picture = IdleNoValue.Picture Else Picture1.Picture = DisabledNoValue.Picture
Case Greyed
    If isEnabled = True Then Picture1.Picture = IdleGreyed.Picture Else Picture1.Picture = DisabledGrey.Picture
End Select
End Property

Property Get Value() As CheckTypes
On Error Resume Next
Select Case OValue
Case Checked
    If isEnabled = True Then Picture1.Picture = IdleChecked.Picture Else Picture1.Picture = CheckedDisabled.Picture
Case Unchecked
    If isEnabled = True Then Picture1.Picture = IdleNoValue.Picture Else Picture1.Picture = DisabledNoValue.Picture
Case Greyed
    If isEnabled = True Then Picture1.Picture = IdleGreyed.Picture Else Picture1.Picture = DisabledGrey.Picture
End Select
'************************
Value = OValue
End Property

Private Sub UserControl_InitProperties()
Value = False
Caption = Name
Enabled = True
Set Font = Parent.Font
m_ForeColor = m_def_ForeColor
m_DisabledColor = m_def_DisabledColor
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
Value = PropBag.ReadProperty("Value", Unchecked)
Caption = PropBag.ReadProperty("Caption", Name)
Enabled = PropBag.ReadProperty("Enabled", True)
Set Font = PropBag.ReadProperty("Font", Parent.Font)
With Check1
    .ForeColor = PropBag.ReadProperty("ForeColor", &H800000)
    .Caption = PropBag.ReadProperty("Caption", UserControl.Name)
    .BackColor = PropBag.ReadProperty("BackColor", &HFFFFFF)
End With
m_ForeColor = PropBag.ReadProperty("ForeColor", m_def_ForeColor)
m_DisabledColor = PropBag.ReadProperty("DisabledColor", m_def_DisabledColor)
End Sub

Private Sub UserControl_Resize()
On Error Resume Next
Picture1.Top = (UserControl.Height / 2) - Picture1.Height / 2
    With Check1
        UserControl.BackColor = .BackColor
        If Enabled = True Then .ForeColor = ForeColor Else .ForeColor = DisabledColor
        .Width = UserControl.Width - .Left
        .Height = UserControl.Height
        .Top = ((UserControl.Height / 2) - .Height / 2)
    End With
End Sub

Private Sub UserControl_Show()
Timer1.Enabled = UserControl.Ambient.UserMode
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
PropBag.WriteProperty "Value", OValue, Unchecked
PropBag.WriteProperty "Caption", Check1.Caption, Name
PropBag.WriteProperty "Enabled", isEnabled, True
PropBag.WriteProperty "Font", Check1.Font, Parent.Font
    Call PropBag.WriteProperty("ForeColor", Check1.ForeColor, &H800000)
    Call PropBag.WriteProperty("Caption", Check1.Caption, "Check1")
    Call PropBag.WriteProperty("BackColor", Check1.BackColor, &HFFFFFF)
    Call PropBag.WriteProperty("ForeColor", m_ForeColor, m_def_ForeColor)
    Call PropBag.WriteProperty("DisabledColor", m_DisabledColor, m_def_DisabledColor)
End Sub

Public Property Set Font(newFont As IFontDisp)
Set Check1.Font = newFont
End Property

Public Property Get Font() As IFontDisp
Set Font = Check1.Font
End Property

Property Let Enabled(Yes As Boolean)
On Error Resume Next
isEnabled = Yes

If Yes = True Then
    Select Case OValue
    Case Checked
        Picture1.Picture = IdleChecked.Picture
    Case Unchecked
        Picture1.Picture = IdleNoValue.Picture
    Case Greyed
        Picture1.Picture = IdleGreyed.Picture
    End Select
    Respond = True
    Check1.ForeColor = ForeColor
    Timer1.Enabled = UserControl.Ambient.UserMode
        Else
            Select Case OValue
            Case Checked
                Picture1.Picture = DisabledChecked.Picture
            Case Unchecked
                Picture1.Picture = DisabledNoValue.Picture
            Case Greyed
                Picture1.Picture = DisabledGrey.Picture
            End Select
            Timer1.Enabled = False
            Respond = False
            Check1.ForeColor = DisabledColor
End If
End Property

Property Get Enabled() As Boolean
Enabled = isEnabled
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Check1,Check1,-1,Caption
Public Property Get Caption() As String
    Caption = Check1.Caption
End Property

Public Property Let Caption(ByVal new_caption As String)
    Check1.Caption() = new_caption
    PropertyChanged "Caption"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Check1,Check1,-1,BackColor
Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_Description = "Returns/sets the background color used to display text and graphics in an object."
    BackColor = Check1.BackColor
End Property

Public Property Let BackColor(ByVal new_BackColor As OLE_COLOR)
    Check1.BackColor() = new_BackColor
    UserControl.BackColor = new_BackColor
    PropertyChanged "BackColor"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=10,0,0,
Public Property Get ForeColor() As OLE_COLOR
Attribute ForeColor.VB_Description = "Returns/sets the foreground color used to display text and graphics in an object."
    ForeColor = m_ForeColor
End Property

Public Property Let ForeColor(ByVal New_ForeColor As OLE_COLOR)
    m_ForeColor = New_ForeColor
    PropertyChanged "ForeColor"
    Check1.ForeColor = m_ForeColor
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=10,0,0,&H00C0C0C0&
Public Property Get DisabledColor() As OLE_COLOR
    DisabledColor = m_DisabledColor
End Property

Public Property Let DisabledColor(ByVal New_DisabledColor As OLE_COLOR)
    m_DisabledColor = New_DisabledColor
    PropertyChanged "DisabledColor"
End Property

