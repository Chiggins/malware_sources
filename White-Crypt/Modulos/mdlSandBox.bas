Attribute VB_Name = "mdlSandBox"
Private Const DFP_RECEIVE_DRIVE_DATA = &H7C088
Private Const FILE_SHARE_READ = &H1
Private Const FILE_SHARE_WRITE = &H2
Private Const GENERIC_READ = &H80000000
Private Const GENERIC_WRITE = &H40000000
Private Const OPEN_EXISTING = 3
Private Const TH32CS_SNAPPROCESS = &H2
Private Const MAX_PATH As Long = 260

Private Type IDEREGS
    bFeaturesReg As Byte
    bSectorCountReg As Byte
    bSectorNumberReg As Byte
    bCylLowReg As Byte
    bCylHighReg As Byte
    bDriveHeadReg As Byte
    bCommandReg As Byte
    bReserved As Byte
End Type
Private Type SENDCMDINPARAMS
    cBufferSize As Long
    irDriveRegs As IDEREGS
    bDriveNumber As Byte
    bReserved(1 To 3) As Byte
    dwReserved(1 To 4) As Long
End Type
Private Type DRIVERSTATUS
    bDriveError As Byte
    bIDEStatus As Byte
    bReserved(1 To 2) As Byte
    dwReserved(1 To 2) As Long
End Type
Private Type SENDCMDOUTPARAMS
    cBufferSize As Long
    DStatus As DRIVERSTATUS
    bBuffer(1 To 512) As Byte
End Type
Private Type PROCESSENTRY32
 dwSize                      As Long
 cntUsage                    As Long
 th32ProcessID               As Long
 th32DefaultHeapID           As Long
 th32ModuleID                As Long
 cntThreads                  As Long
 th32ParentProcessID         As Long
 pcPriClassBase              As Long
 dwFlags                     As Long
 szExeFile                   As String * MAX_PATH
End Type
Private Declare Function CreateFileA Lib "kernel32" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, ByVal lpSecurityAttributes As Long, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Private Declare Function DeviceIoControl Lib "kernel32" (ByVal hDevice As Long, ByVal dwIoControlCode As Long, lpInBuffer As Any, ByVal nInBufferSize As Long, lpOutBuffer As Any, ByVal nOutBufferSize As Long, lpBytesReturned As Long, ByVal lpOverlapped As Long) As Long
Private Declare Sub ZeroMemory Lib "kernel32" Alias "RtlZeroMemory" (dest As Any, ByVal numBytes As Long)
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)
Private Declare Function CreateToolhelpSnapshot Lib "kernel32" Alias "CreateToolhelp32Snapshot" (ByVal dwFlags As Long, ByVal th32ProcessID As Long) As Long
Private Declare Function ProcessFirst Lib "kernel32" Alias "Process32First" (ByVal hSnapshot As Long, uProcess As PROCESSENTRY32) As Long
Private Declare Function ProcessNext Lib "kernel32" Alias "Process32Next" (ByVal hSnapshot As Long, uProcess As PROCESSENTRY32) As Long
Private Declare Sub CloseHandle Lib "kernel32" (ByVal hObject As Long)
Private Declare Function GetCurrentProcessId Lib "kernel32" () As Long
 
Private mvarCurrentDrive As Byte
Private mvarPlatform As String
Public Function GetPhysicalDriveModelName() As String
    Dim bin As SENDCMDINPARAMS
    Dim bout As SENDCMDOUTPARAMS
    Dim hdh As Long
    Dim br As Long
    Dim ix As Long
    Dim sTemp As String
    hdh = CreateFileA("\\.\PhysicalDrive0", GENERIC_READ + GENERIC_WRITE, FILE_SHARE_READ + FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0)
   
    ZeroMemory bin, Len(bin)
    ZeroMemory bout, Len(bout)
   
    With bin
        .bDriveNumber = mvarCurrentDrive
        .cBufferSize = 512
        With .irDriveRegs
            If (mvarCurrentDrive And 1) Then
                .bDriveHeadReg = &HB0
            Else
                .bDriveHeadReg = &HA0
            End If
            .bCommandReg = &HEC
            .bSectorCountReg = 1
            .bSectorNumberReg = 1
        End With
    End With
   
    DeviceIoControl hdh, DFP_RECEIVE_DRIVE_DATA, bin, Len(bin), bout, Len(bout), br, 0
   
    For ix = 55 To 94 Step 2
        If bout.bBuffer(ix + 1) = 0 Then Exit For
        sTemp = sTemp & Chr(bout.bBuffer(ix + 1))
        If bout.bBuffer(ix) = 0 Then Exit For
        sTemp = sTemp & Chr(bout.bBuffer(ix))
    Next ix
    CloseHandle hdh
    GetPhysicalDriveModelName = Trim(sTemp)
End Function

Public Function Sandboxed() As Boolean
Dim nSnapshot As Long, nProcess As PROCESSENTRY32
Dim nResult As Long, ParentID As Long, IDCheck As Boolean
Dim nProcessID As Long
'Eigene ProcessID ermitteln
nProcessID = GetCurrentProcessId
If nProcessID <> 0 Then
 'Abbild der Prozesse machen
 nSnapshot = CreateToolhelpSnapshot(TH32CS_SNAPPROCESS, 0&)
 If nSnapshot <> 0 Then
  nProcess.dwSize = Len(nProcess)
 
  'Zeiger auf ersten Prozess bewegen
  nResult = ProcessFirst(nSnapshot, nProcess)
 
  Do Until nResult = 0
   'Nach der eigenen ProcessID suchen.
   If nProcess.th32ProcessID = nProcessID Then
   
    'Wir merken uns die ParentProcessID
    ParentID = nProcess.th32ParentProcessID
    MsgBox ParentID
   
    'Wir beginnen nochmal beim ersten Prozess
    nResult = ProcessFirst(nSnapshot, nProcess)
    Do Until nResult = 0
     'Wir suchen den Process mit der ParentID
     If nProcess.th32ProcessID = ParentID Then
     MsgBox ParentID
      'Falls so ein Prozess vorhanden ist, dann ist das Programm nicht sandboxed
      IDCheck = False
      Exit Do
     Else
      IDCheck = True
      nResult = ProcessNext(nSnapshot, nProcess)
     End If
    Loop
   
    'Falls chaeck True ist, dann ist das Programm Sandboxed
    Sandboxed = IDCheck
   
    Exit Do
   Else
    'Zum n‰chsten Prozess
    nResult = ProcessNext(nSnapshot, nProcess)
   End If
  Loop
  ' Handle wird geschloﬂen
  CloseHandle nSnapshot
 End If
End If
End Function

Public Function IsVirtualDrive() As Boolean
    Dim sModelNames(3) As String
    Dim sDriveModelName As String
    Dim i As Long
    sDriveModelName = GetPhysicalDriveModelName
    sModelNames(0) = "VBOX HARDDRIVE" 'virtualbox
    sModelNames(1) = "QEMU HARDDISK" 'anubis
    sModelNames(2) = "VMWARE VIRTUAL IDE HARD DRIVE" 'vmware
    sModelNames(3) = "VIRTUAL HD" 'virtual pc
    For i = 0 To 3
        If UCase(sDriveModelName) = sModelNames(i) Then IsVirtualDrive = True
    Next
   
    If IsVirtualDrive = False Then
        If Sandboxed = True Then IsVirtualDrive = True
    End If
   
End Function
