VERSION 5.00
Begin VB.UserControl wxpText 
   ClientHeight    =   750
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   1695
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LockControls    =   -1  'True
   ScaleHeight     =   750
   ScaleWidth      =   1695
   Begin VB.TextBox txtText 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      ForeColor       =   &H00000000&
      Height          =   660
      IMEMode         =   3  'DISABLE
      Left            =   45
      TabIndex        =   0
      Text            =   "wxpTextbox"
      Top             =   45
      Width           =   1605
   End
   Begin VB.Shape shpBorde 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00B99D7F&
      FillColor       =   &H00FFFFFF&
      Height          =   750
      Left            =   0
      Top             =   0
      Width           =   1695
   End
End
Attribute VB_Name = "wxpText"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Event Click() 'MappingInfo=UserControl,UserControl,-1,Click
Event DblClick() 'MappingInfo=UserControl,UserControl,-1,DblClick
Event Change()
Event KeyDown(KeyCode As Integer, Shift As Integer)
Event KeyPress(KeyAscii As Integer)
Event KeyUp(KeyCode As Integer, Shift As Integer)
Event MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single) 'MappingInfo=UserControl,UserControl,-1,MouseDown
Event MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single) 'MappingInfo=UserControl,UserControl,-1,MouseMove
Event MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single) 'MappingInfo=UserControl,UserControl,-1,MouseUp

Private antColor
Public Property Let SelStart(ByVal New_SelStart As Long)
   txtText.SelStart = New_SelStart
End Property

Public Property Let SelLength(ByVal New_SelLength As Long)
   txtText.SelLength = New_SelLength
End Property


' Tipo de la propiedad AlignmentConstants agregado manualmente.
'
'ADVERTENCIA: NO ELIMINE NI MODIFIQUE LAS LÍNEAS DE COMENTARIO SIGUIENTES
'MappingInfo=lblCaption,lblCaption,-1,Alignment
Public Property Get Alignment() As AlignmentConstants
Attribute Alignment.VB_Description = "Devuelve o establece el alineamiento del texto."
    Alignment = txtText.Alignment
End Property
Public Property Let Alignment(ByVal new_Alignment As AlignmentConstants)
    txtText.Alignment = new_Alignment
    PropertyChanged "Alignment"
    '   El cambio de la alineación puede
    '   afectar a las posiciones de los
    '   controles constituyentes.
    Call UserControl_Resize
End Property
' Código Generado Por Carlos A. Leguizamón
' ========================================
' Classic Software, Inc.
' ========================================
Public Property Get BorderColor() As OLE_COLOR
Attribute BorderColor.VB_Description = "Devuelve o establece el color del borde del control."
    BorderColor = shpBorde.BorderColor
End Property

Public Property Let BorderColor(ByVal New_BorderColor As OLE_COLOR)
    shpBorde.BorderColor() = New_BorderColor
    PropertyChanged "BorderColor"
End Property

'   ForeColor se asigna a la propiedad ForeColor
'   del control Label, ya que ForeColor de
'   ShapeLabel debe controlar el color de la
'   fuente. El fondo del control Label es
'   Transparent, de modo que BackColor no
'   importa.
'
'ADVERTENCIA: NO ELIMINE NI MODIFIQUE LAS LÍNEAS DE COMENTARIO SIGUIENTES
'MappingInfo=lblCaption,lblCaption,-1,ForeColor
Public Property Get ForeColor() As OLE_COLOR
Attribute ForeColor.VB_Description = "Devuelve o establece el color de la letra en el control."
    ForeColor = txtText.ForeColor
End Property
Public Property Let ForeColor(ByVal New_ForeColor As OLE_COLOR)
    txtText.ForeColor() = New_ForeColor
    PropertyChanged "ForeColor"
End Property
'   La propiedad BackColor se ha reasignado
'   manualmente a la propiedad FillColor del
'   control Shape, ya que es el relleno de la
'   forma lo que aparece como fondo de un
'   ShapeLabel.
'
Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_Description = "Devuelve o establece un valor que indica el color de fondo para el control."
    BackColor = txtText.BackColor
End Property
Public Property Let BackColor(ByVal new_BackColor As OLE_COLOR)
    txtText.BackColor() = new_BackColor
    shpBorde.BackColor() = new_BackColor
    PropertyChanged "BackColor"
End Property
'ADVERTENCIA: NO ELIMINE NI MODIFIQUE LAS LÍNEAS DE COMENTARIO SIGUIENTES
'MappingInfo=txtText,txtText,-1,Font
Public Property Get Font() As Font
Attribute Font.VB_Description = "Devuelve o establece el tipo de letra que se utiliza en el control."
    Set Font = txtText.Font
End Property
Public Property Set Font(ByVal new_font As Font)
    Set txtText.Font = new_font
    PropertyChanged "Font"
    '   Agregado manualmente: El cambio de fuente
    '   puede requerir un ajuste en la posición
    '   del control Label.
    Call UserControl_Resize
End Property
'ADVERTENCIA: NO ELIMINE NI MODIFIQUE LAS LÍNEAS DE COMENTARIO SIGUIENTES
'MappingInfo=UserControl,UserControl,-1,Refresh
Public Sub Refresh()
    UserControl.Refresh
End Sub
Public Property Get Enabled() As Boolean
Attribute Enabled.VB_Description = "Devuelve o establece el estado del control."
    Enabled = UserControl.Enabled
End Property
Public Property Get Locked() As Boolean
Attribute Locked.VB_Description = "Devuelve o establece si el texto del control se encuentra bloqueado para la edición."
    Locked = txtText.Locked
End Property

Public Property Let Enabled(ByVal New_Enabled As Boolean)
   UserControl.Enabled() = New_Enabled
   If (New_Enabled = False) And Ambient.UserMode Then
      antColor = txtText.ForeColor
      txtText.ForeColor = &H80000011
   Else
      txtText.ForeColor = antColor
   End If
   PropertyChanged "Enabled"
End Property
Public Property Let Locked(ByVal New_Lock As Boolean)
   txtText.Locked = New_Lock
   PropertyChanged "Locked"
End Property

Public Property Let Text(ByVal NuevoText As String)
Attribute Text.VB_Description = "Devuelve o establece el texto contenido en el control."
   txtText.Text = NuevoText
   PropertyChanged Text
End Property

Public Property Let PasswordChar(ByVal NuevoPasswordChar As String)
Attribute PasswordChar.VB_Description = "Establece el caracter que se mostrara como máscara si se desea usar como un campo de contraseña."
   If Len(NuevoPasswordChar) > 1 Then
      Err.Raise 31008, , "El valor de la propiedad no es válido"
      NuevoPasswordChar = Left(NuevoPasswordChar, 1)
   End If
   txtText.PasswordChar = NuevoPasswordChar
   PropertyChanged PasswordChar
End Property


Public Property Get Text() As String
   Text = txtText.Text
End Property

Public Property Get PasswordChar() As String
   PasswordChar = txtText.PasswordChar
End Property


Private Sub txtText_Change()
   RaiseEvent Change
End Sub

Private Sub txtText_Click()
   RaiseEvent Click
End Sub
Private Sub txtText_DblClick()
   RaiseEvent DblClick
End Sub

Private Sub txtText_KeyDown(KeyCode As Integer, Shift As Integer)
   RaiseEvent KeyDown(KeyCode, Shift)
End Sub

Private Sub txtText_KeyPress(KeyAscii As Integer)
   RaiseEvent KeyPress(KeyAscii)
End Sub


Private Sub txtText_KeyUp(KeyCode As Integer, Shift As Integer)
   RaiseEvent KeyUp(KeyCode, Shift)
End Sub


Private Sub txtText_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
   RaiseEvent MouseDown(Button, Shift, X, Y)
End Sub

Private Sub txtText_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
   RaiseEvent MouseMove(Button, Shift, X, Y)
End Sub


Private Sub txtText_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
   RaiseEvent MouseUp(Button, Shift, X, Y)
End Sub


Private Sub UserControl_Click()
   RaiseEvent Click
End Sub

Private Sub UserControl_DblClick()
   RaiseEvent DblClick
End Sub

Private Sub UserControl_InitProperties()
   txtText.Text = Ambient.DisplayName
   If (UserControl.Enabled = False) And Ambient.UserMode Then
      antColor = txtText.ForeColor
      txtText.ForeColor = &H80000011
   Else
      txtText.ForeColor = antColor
   End If
End Sub

Private Sub UserControl_KeyDown(KeyCode As Integer, Shift As Integer)
   RaiseEvent KeyDown(KeyCode, Shift)
End Sub

Private Sub UserControl_KeyPress(KeyAscii As Integer)
   RaiseEvent KeyPress(KeyAscii)
End Sub


Private Sub UserControl_KeyUp(KeyCode As Integer, Shift As Integer)
   RaiseEvent KeyUp(KeyCode, Shift)
End Sub


Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
   RaiseEvent MouseDown(Button, Shift, X, Y)
End Sub


Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
   RaiseEvent MouseMove(Button, Shift, X, Y)
End Sub

Private Sub UserControl_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
   RaiseEvent MouseUp(Button, Shift, X, Y)
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
   ' Usa siempre interceptación de errores en ReadProperties
   On Error Resume Next
   ' Recupera el valor dela propiedad Caption,
   ' que es de sólo lectura en tiempo de ejecución.
   shpBorde.BorderColor = PropBag.ReadProperty("BorderColor", &HB99D7F)
   shpBorde.BackColor = PropBag.ReadProperty("BackColor", &HFFFFFF)
   txtText.BackColor = PropBag.ReadProperty("BackColor", &HFFFFFF)
   txtText.ForeColor = PropBag.ReadProperty("ForeColor", &H0&)
   txtText.Alignment = PropBag.ReadProperty("Alignment", 0)
   PasswordChar = PropBag.ReadProperty("PasswordChar", "")
   Text = PropBag.ReadProperty("Text", UserControl.Name)
   UserControl.Enabled = PropBag.ReadProperty("Enabled", True)
   txtText.Locked = PropBag.ReadProperty("Locked", False)
   Set Font = PropBag.ReadProperty("Font", Ambient.Font)
   Set MouseIcon = PropBag.ReadProperty("MouseIcon", Nothing)
   UserControl.MousePointer = PropBag.ReadProperty("MousePointer", 0)
   
   Err.Number = 0
End Sub

Private Sub UserControl_Resize()
   On Error Resume Next
   If UserControl.Width < 500 Then
      UserControl.Width = 500
   ElseIf UserControl.Height < 285 Then
      UserControl.Height = 285
   End If
   shpBorde.Width = UserControl.Width
   shpBorde.Height = UserControl.Height
   txtText.Width = UserControl.Width - 90
   txtText.Height = UserControl.Height - 90
End Sub


Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
   Call PropBag.WriteProperty("Text", Text, UserControl.Name)
   Call PropBag.WriteProperty("PasswordChar", PasswordChar, "")
   Call PropBag.WriteProperty("BorderColor", shpBorde.BorderColor, &HB99D7F)
   Call PropBag.WriteProperty("BackColor", shpBorde.BackColor, &HFFFFFF)
   Call PropBag.WriteProperty("BackColor", txtText.BackColor, &HFFFFFF)
   Call PropBag.WriteProperty("ForeColor", txtText.ForeColor, &H0&)
   Call PropBag.WriteProperty("Font", Font, Ambient.Font)
   Call PropBag.WriteProperty("MouseIcon", MouseIcon, Nothing)
   Call PropBag.WriteProperty("MousePointer", UserControl.MousePointer, 0)
   Call PropBag.WriteProperty("Alignment", txtText.Alignment, 0)
   Call PropBag.WriteProperty("Locked", txtText.Locked, False)
End Sub


