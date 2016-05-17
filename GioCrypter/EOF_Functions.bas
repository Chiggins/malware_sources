Attribute VB_Name = "EOF_Functions"
'module for reading eof data from a pe file
'also contains ReAlignHeaders function for extending the last pe section to disguise eof data.
'
'
'example usage:
'
'''''''''''''''''''''''''''''''''''''''''''''
'Dim 1 As Integer
'Dim EOFData() As Byte
'Dim file1 As String, file2 As String
'
'file1 = "C:\file with eof.exe"
'file2 = "C:\crypted.exe"
'
'1 = FreeFile
'
''get eof data from a file
'Open file1 For Binary Access Read As #1
'    EOFData = GetEOFData(1)
'Close #1
'
'1 = FreeFile
''write eof data to another file (if there was any eofdata)
'Open file2 For Binary As #1
'    'write your stub and settings first...
'
'    If Not Not EOFData Then
'        Put #1, LOF(1) + 1, CStr(StrConv(EOFData, vbUnicode))
'        ReAlignHeaders 1
'    End If
'Close #1
'''''''''''''''''''''''''''''''''''''''''''''

Option Explicit

Private Type IMAGE_DOS_HEADER
    e_magic                 As Integer
    e_cblp                  As Integer
    e_cp                    As Integer
    e_crlc                  As Integer
    e_cparhdr               As Integer
    e_minalloc              As Integer
    e_maxalloc              As Integer
    e_ss                    As Integer
    e_sp                    As Integer
    e_csum                  As Integer
    e_ip                    As Integer
    e_cs                    As Integer
    e_lfarlc                As Integer
    e_onvo                  As Integer
    e_res(3)                As Integer
    e_oemid                 As Integer
    e_oeminfo               As Integer
    e_res2(9)               As Integer
    e_lfanew                As Long
End Type


Private Type IMAGE_FILE_HEADER
    Machine                 As Integer
    NumberOfSections        As Integer
    TimeDataStamp           As Long
    PointerToSymbolTable    As Long
    NumberOfSymbols         As Long
    SizeOfOptionalHeader    As Integer
    Characteristics         As Integer
End Type

Private Type IMAGE_DATA_DIRECTORY
  VirtualAddress As Long
  isize As Long
End Type

Private Type IMAGE_OPTIONAL_HEADER32
    Magic                   As Integer
    MajorLinkerVersion      As Byte
    MinorLinkerVersion      As Byte
    SizeOfCode              As Long
    SizeOfInitalizedData    As Long
    SizeOfUninitalizedData  As Long
    AddressOfEntryPoint     As Long
    BaseOfCode              As Long
    BaseOfData              As Long
    ImageBase               As Long
    SectionAlignment        As Long
    FileAlignment           As Long
    MajorOperatingSystemVer As Integer
    MinorOperatingSystemVer As Integer
    MajorImageVersion       As Integer
    MinorImageVersion       As Integer
    MajorSubsystemVersion   As Integer
    MinorSubsystemVersion   As Integer
    Reserved1               As Long
    SizeOfImage             As Long
    SizeOfHeaders           As Long
    Checksum                As Long
    Subsystem               As Integer
    DllCharacteristics      As Integer
    SizeOfStackReserve      As Long
    SizeOfStackCommit       As Long
    SizeOfHeapReserve       As Long
    SizeOfHeapCommit        As Long
    LoaerFlags              As Long
    NumberOfRvaAndSizes     As Long
    DataDirectory(1 To 16) As IMAGE_DATA_DIRECTORY
End Type

Private Type IMAGE_SECTION_HEADER
    Name As String * 8
    VirtualSize As Long
    VirtualAddress As Long
    SizeOfRawData As Long
    PointerToRawData As Long
    PointerToRelocations As Long
    PointerToLinenumbers As Long
    NumberOfRelocations As Integer
    NumberOfLinenumbers As Integer
    Characteristics As Long
End Type


Private Type IMAGE_NT_HEADERS
    Signature As Long
    FileHeader As IMAGE_FILE_HEADER
    OptionalHeader As IMAGE_OPTIONAL_HEADER32
End Type

Private Function Align(ByVal dwValue As Long, ByVal dwAlign As Long) As Long

If dwAlign <> 0 Then

    If dwValue Mod dwAlign <> 0 Then
    
        Align = (dwValue + dwAlign) - (dwValue Mod dwAlign)
        
        Exit Function
        
    End If
    
End If

Align = dwValue

End Function

Public Function ReAlignHeaders(FF As Integer) As Boolean
Dim OriginalEOF As Long
Dim i As Integer, eof As Integer
Dim NewEOFdata As String

Dim dos As IMAGE_DOS_HEADER
Dim NT As IMAGE_NT_HEADERS
Dim section() As IMAGE_SECTION_HEADER

Dim EOFData() As Byte

EOFData = GetEOFData(FF)

If Not Not EOFData Then

    Get #1, 1, dos

    Get #1, 1 + dos.e_lfanew, NT

    ReDim section(0 To NT.FileHeader.NumberOfSections - 1) As IMAGE_SECTION_HEADER

    Get #1, 1 + dos.e_lfanew + 24 + NT.FileHeader.SizeOfOptionalHeader, section()

    eof = LBound(section)

    For i = LBound(section) To UBound(section)

        If section(i).PointerToRawData + section(i).SizeOfRawData > section(eof).PointerToRawData + section(eof).SizeOfRawData Then eof = i

    Next i
    
    OriginalEOF = section(eof).PointerToRawData + section(eof).SizeOfRawData + 1

    section(eof).SizeOfRawData = Align(section(eof).SizeOfRawData + UBound(EOFData) + 1, NT.OptionalHeader.FileAlignment)

    NewEOFdata = String(Align(UBound(EOFData) + 1, NT.OptionalHeader.FileAlignment) - (UBound(EOFData) + 1), Chr$(0))

    NewEOFdata = NewEOFdata + CStr(StrConv(EOFData, vbUnicode))

    Put #1, 1 + dos.e_lfanew + 24 + NT.FileHeader.SizeOfOptionalHeader + (40 * (eof - LBound(section))), section(eof)

    Put #1, OriginalEOF, NewEOFdata
    
    ReAlignHeaders = True

End If

End Function

Public Function GetEOFData(FF As Integer) As Byte()
Dim dos As IMAGE_DOS_HEADER
Dim NT As IMAGE_NT_HEADERS
Dim section() As IMAGE_SECTION_HEADER
Dim i As Integer, eof As Integer
Dim ret() As Byte

Get #1, 1, dos

Get #1, 1 + dos.e_lfanew, NT

ReDim section(0 To NT.FileHeader.NumberOfSections - 1) As IMAGE_SECTION_HEADER

Get #1, 1 + dos.e_lfanew + 24 + NT.FileHeader.SizeOfOptionalHeader, section()

eof = LBound(section)

For i = LBound(section) To UBound(section)

    If section(i).PointerToRawData + section(i).SizeOfRawData > section(eof).PointerToRawData + section(eof).SizeOfRawData Then eof = i
    
Next i

If (LOF(1) > section(eof).PointerToRawData + section(eof).SizeOfRawData) Then

    ReDim ret(0 To (LOF(1) - (section(eof).PointerToRawData + section(eof).SizeOfRawData)) - 1) As Byte
    
    Get #1, 1 + section(eof).PointerToRawData + section(eof).SizeOfRawData, ret()
    
End If

GetEOFData = ret

End Function


