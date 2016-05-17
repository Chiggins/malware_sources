VERSION 5.00
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Gio Crypter v1.0.0 by GioSoft"
   ClientHeight    =   6375
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   6000
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6375
   ScaleWidth      =   6000
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdAction 
      Caption         =   "Build"
      Height          =   375
      Index           =   3
      Left            =   4800
      TabIndex        =   7
      Top             =   5880
      Width           =   975
   End
   Begin VB.Frame Frame1 
      Caption         =   "File"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   162
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   855
      Left            =   120
      TabIndex        =   8
      Top             =   2400
      Width           =   5655
      Begin VB.TextBox txtFile 
         Enabled         =   0   'False
         Height          =   285
         Left            =   120
         TabIndex        =   0
         Text            =   "Please select file..."
         Top             =   360
         Width           =   4695
      End
      Begin VB.CommandButton cmdAction 
         Caption         =   "..."
         Height          =   285
         Index           =   0
         Left            =   4920
         TabIndex        =   1
         Top             =   360
         Width           =   615
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "Settings"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   162
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2175
      Left            =   120
      TabIndex        =   9
      Top             =   3480
      Width           =   5655
      Begin VB.CommandButton cmdAction 
         Caption         =   "Generate"
         Height          =   255
         Index           =   1
         Left            =   4560
         TabIndex        =   4
         Top             =   960
         Width           =   975
      End
      Begin VB.CheckBox ChkIcon 
         Caption         =   "Change Icon"
         Height          =   315
         Left            =   120
         TabIndex        =   11
         Top             =   1320
         Width           =   1335
      End
      Begin VB.TextBox txtEncKey 
         Height          =   285
         Left            =   120
         Locked          =   -1  'True
         TabIndex        =   3
         Top             =   960
         Width           =   4335
      End
      Begin VB.CheckBox ChkRealign 
         Caption         =   "Realign PE"
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   360
         Value           =   1  'Checked
         Width           =   1215
      End
      Begin VB.CommandButton cmdAction 
         Caption         =   "..."
         Enabled         =   0   'False
         Height          =   285
         Index           =   2
         Left            =   4920
         TabIndex        =   6
         Top             =   1680
         Width           =   615
      End
      Begin VB.TextBox txtIcon 
         Enabled         =   0   'False
         Height          =   285
         Left            =   120
         TabIndex        =   5
         Top             =   1680
         Width           =   4695
      End
      Begin VB.Label Label1 
         BackStyle       =   0  'Transparent
         Caption         =   "Encryption Key"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   162
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   10
         Top             =   720
         Width           =   1455
      End
   End
   Begin VB.Image Image1 
      Height          =   2250
      Left            =   0
      Picture         =   "frmMain.frx":628A
      Top             =   0
      Width           =   6000
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function GetFileNameFromBrowseW Lib "shell32" Alias "#63" (ByVal hwndOwner As Long, ByVal lpstrFile As Long, ByVal nMaxFile As Long, ByVal lpstrInitialDir As Long, ByVal lpstrDefExt As Long, ByVal lpstrFilter As Long, ByVal lpstrTitle As Long) As Long
Private Declare Function lstrlen Lib "kernel32" Alias "lstrlenA" (ByVal lpString As String) As Long
Private Declare Function PathFileExists Lib "shlwapi.dll" Alias "PathFileExistsA" (ByVal pszPath As String) As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Dst As Any, Src As Any, ByVal cLen As Long)
Private Declare Function InitCommonControls Lib "comctl32.dll" ()
Public LengteVanBestand As String
Public LengteOrig As String

Const DATA_START = "[DATA]"
Const DATA_ARRAY = "[#]"
Dim SERVER_RESOURCE() As Byte
Dim var1 As String
Dim Keyset As String

Private Function LoadFile(sPath As String) As String
    Dim lFileSize As Long
    Dim sData As String
    Dim FF As Integer
    
    FF = FreeFile
    
    On Error Resume Next
    
    Open sPath For Binary Access Read As #FF
    lFileSize = LOF(FF)
    sData = Input$(lFileSize, FF)
    Close #FF
    LoadFile = sData
End Function

Private Sub ChkIcon_Click()
If ChkIcon.Value = 1 Then
txtIcon.Enabled = True
cmdAction(2).Enabled = True
Else
txtIcon.Enabled = False
cmdAction(2).Enabled = False
End If
End Sub

Private Sub cmdAction_Click(Index As Integer)
    Select Case Index
    
        Case 0
            Dim sSave As String
            sSave = Space(255)
            GetFileNameFromBrowseW Me.hWnd, StrPtr(sSave), 255, StrPtr("c:\"), StrPtr("txt"), StrPtr("Apps (*.EXE)" + Chr$(0) + "*.EXE" + Chr$(0) + "All files (*.*)" + Chr$(0) + "*.*" + Chr$(0)), StrPtr("Select File")
            txtFile = Left$(sSave, lstrlen(sSave))
        
        Case 1
            GetRandomKey
            
        Case 2
            Dim sIcon As String
            sIcon = Space(255)
            GetFileNameFromBrowseW Me.hWnd, StrPtr(sIcon), 255, StrPtr("c:\"), StrPtr("txt"), StrPtr("Icons (*.ICO)" + Chr$(0) + "*.ICO" + Chr$(0)), StrPtr("Select File")
            txtIcon = Left$(sIcon, lstrlen(sIcon))
            
        Case 3
            Dim sBuff As String
            Dim sSize As String * 8
            Dim FF As Integer
            Dim EOFData() As Byte
       
            If Not txtFile = vbNullString Then
            
                If PathFileExists(App.Path & "\Test.exe") Then
                    Kill App.Path & "\Test.exe"
                End If
                
                FF = FreeFile

                Open txtFile For Binary Access Read As #FF
                EOFData = GetEOFData(FF)
                LengteVanBestand = LOF(FF) - GetEOF(txtFile)
                LengteOrig = LOF(FF)
                Close #FF
                
                
                FF = FreeFile
                Open App.Path & "\Crypted.exe" For Binary Access Write As #FF
                sBuff = LoadFile(App.Path & "\Stub.exe")
                Put #FF, , sBuff
                Put #FF, , DATA_START + LengteVanBestand + DATA_ARRAY + LengteOrig + DATA_ARRAY + txtEncKey + DATA_ARRAY
                sBuff = LoadFile(txtFile)
                sBuff = EncryptData(sBuff, txtEncKey, True)
                Put #FF, , sBuff
                sSize = Len(sBuff)
                Put #FF, , sSize
                Put #FF, , 27
                
                If Not Not EOFData Then
                Put #FF, LOF(FF) + 1, CStr(StrConv(EOFData, vbUnicode))
                End If
                Close #FF
                If ChkRealign.Value = 1 Then mPE_Realign.RealignPEFromFile App.Path & "\Crypted.exe"
                If ChkIcon.Value = 1 Then
                If txtIcon <> "" Then
                ReplaceIcons txtIcon, App.Path & "\Crypted.exe", Err
                End If
                End If
                MsgBox "Done"
            End If
    End Select
End Sub

Function GetEOF(Path As String) As Long

    Dim ByteArray() As Byte
    Dim PE As Long, NumberOfSections As Integer
    Dim BeginLastSection As Long
    Dim RawSize As Long, RawOffset As Long
       
    Open Path For Binary As #2
        ReDim ByteArray(LOF(2) - 1)
        Get #2, , ByteArray
    Close #2
   
    Call CopyMemory(PE, ByteArray(&H3C), 4)
    Call CopyMemory(NumberOfSections, ByteArray(PE + &H6), 2)
    BeginLastSection = PE + &HF8 + ((NumberOfSections - 1) * &H28)
    Call CopyMemory(RawSize, ByteArray(BeginLastSection + 16), 4)
    Call CopyMemory(RawOffset, ByteArray(BeginLastSection + 20), 4)
    GetEOF = RawSize + RawOffset
   
End Function

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

Private Function GetRandomKey()
Dim i As Long
    txtEncKey = ""
    For i = 1 To 20
        If i = 2 Or i = 4 Or i = 6 Then
            txtEncKey = txtEncKey & RandomNumber
        Else
            txtEncKey = txtEncKey & RandomLetter
        End If
    Next i
End Function

Private Sub Form_Initialize()
InitCommonControls
End Sub

Private Sub Form_Load()
GetRandomKey
End Sub
