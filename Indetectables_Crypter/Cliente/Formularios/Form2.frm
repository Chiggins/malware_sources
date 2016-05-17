VERSION 5.00
Begin VB.Form Form2 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "About..."
   ClientHeight    =   3720
   ClientLeft      =   4950
   ClientTop       =   2355
   ClientWidth     =   4875
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3720
   ScaleWidth      =   4875
   ShowInTaskbar   =   0   'False
   Begin VB.PictureBox Picture2 
      AutoSize        =   -1  'True
      BorderStyle     =   0  'None
      Height          =   1395
      Left            =   2520
      Picture         =   "Form2.frx":0000
      ScaleHeight     =   1395
      ScaleWidth      =   2100
      TabIndex        =   7
      Top             =   2160
      Width           =   2100
   End
   Begin VB.PictureBox Picture1 
      AutoSize        =   -1  'True
      BorderStyle     =   0  'None
      Height          =   1395
      Left            =   240
      Picture         =   "Form2.frx":CBB4
      ScaleHeight     =   1395
      ScaleWidth      =   2100
      TabIndex        =   6
      Top             =   2160
      Width           =   2100
   End
   Begin VB.Label Label6 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      Caption         =   "Países:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1860
      TabIndex        =   5
      Top             =   1680
      Width           =   885
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      Caption         =   "Visual Basic 6.0"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   285
      Left            =   2460
      TabIndex        =   4
      Top             =   1320
      Width           =   1905
   End
   Begin VB.Label Label4 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      Caption         =   "Lenguaje:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   480
      TabIndex        =   3
      Top             =   1320
      Width           =   1245
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      Caption         =   "SkuLLByte && Sanlegas"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   285
      Left            =   2040
      TabIndex        =   2
      Top             =   840
      Width           =   2745
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      Caption         =   "Codeado por:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   120
      TabIndex        =   1
      Top             =   840
      Width           =   1665
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      Caption         =   "Acerca de..."
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1680
      TabIndex        =   0
      Top             =   240
      Width           =   1275
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
