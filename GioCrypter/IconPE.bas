Attribute VB_Name = "IconPE"
Option Explicit
Private Type IMAGE_DOS_HEADER
   Magic    As Integer
   cblp     As Integer
   cp       As Integer
   crlc     As Integer
   cparhdr  As Integer
   minalloc As Integer
   maxalloc As Integer
   ss       As Integer
   sp       As Integer
   csum     As Integer
   ip       As Integer
   cs       As Integer
   lfarlc   As Integer
   ovno     As Integer
   res(3)   As Integer
   oemid    As Integer
   oeminfo  As Integer
   res2(9)  As Integer
   lfanew      As Long
End Type

Private Type IMAGE_FILE_HEADER
   Machine              As Integer
   NumberOfSections     As Integer
   TimeDateStamp        As Long
   PointerToSymbolTable As Long
   NumberOfSymbols      As Long
   SizeOfOtionalHeader  As Integer
   Characteristics      As Integer
End Type

Private Type IMAGE_DATA_DIRECTORY
   DataRVA     As Long
   DataSize    As Long
End Type

Private Type IMAGE_OPTIONAL_HEADER
   Magic             As Integer
   MajorLinkVer      As Byte
   MinorLinkVer      As Byte
   CodeSize          As Long
   InitDataSize      As Long
   unInitDataSize    As Long
   EntryPoint        As Long
   CodeBase          As Long
   DataBase          As Long
   ImageBase         As Long
   SectionAlignment  As Long
   FileAlignment     As Long
   MajorOSVer        As Integer
   MinorOSVer        As Integer
   MajorImageVer     As Integer
   MinorImageVer     As Integer
   MajorSSVer        As Integer
   MinorSSVer        As Integer
   Win32Ver          As Long
   ImageSize         As Long
   HeaderSize        As Long
   Checksum          As Long
   Subsystem         As Integer
   DLLChars          As Integer
   StackRes          As Long
   StackCommit       As Long
   HeapReserve       As Long
   HeapCommit        As Long
   LoaderFlags       As Long
   RVAsAndSizes      As Long
   DataEntries(15)   As IMAGE_DATA_DIRECTORY
End Type

Private Type IMAGE_SECTION_HEADER
   SectionName(7)    As Byte
   Address           As Long
   VirtualAddress    As Long
   SizeOfData        As Long
   PData             As Long
   PReloc            As Long
   PLineNums         As Long
   RelocCount        As Integer
   LineCount         As Integer
   Characteristics   As Long
End Type

Type IMAGE_RESOURCE_DIR
   Characteristics   As Long
   TimeStamp         As Long
   MajorVersion      As Integer
   MinorVersion      As Integer
   NamedEntries      As Integer
   IDEntries         As Integer
End Type

Type RESOURCE_DIR_ENTRY
   Name              As Long
   Offset            As Long
End Type

Type RESOURCE_DATA_ENTRY
   Offset            As Long
   Size              As Long
   CodePage          As Long
   Reserved          As Long
End Type

Public Type IconDescriptor
   ID       As Long
   Offset   As Long
   Size     As Long
End Type

Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)
Public Declare Function CreateFile Lib "kernel32" Alias "CreateFileA" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, lpSecurityAttributes As Any, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Public Declare Function ReadFile Lib "kernel32" (ByVal hFile As Long, lpBuffer As Any, ByVal nNumberOfBytesToRead As Long, lpNumberOfBytesRead As Long, lpOverlapped As Any) As Long
Public Declare Function WriteFile Lib "kernel32" (ByVal hFile As Long, lpBuffer As Any, ByVal nNumberOfBytesToWrite As Long, lpNumberOfBytesWritten As Long, lpOverlapped As Any) As Long
Public Declare Function SetFilePointer Lib "kernel32" (ByVal hFile As Long, ByVal lDistanceToMove As Long, lpDistanceToMoveHigh As Long, ByVal dwMoveMethod As Long) As Long
Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long

Private SectionAlignment   As Long
Private FileAlignment      As Long
Private ResSectionRVA      As Long
Private ResSectionOffset   As Long
Public Function Valid_PE(hFile As Long) As Boolean

   Dim Buffer(12)      As Byte
   Dim lngBytesRead    As Long
   Dim tDosHeader      As IMAGE_DOS_HEADER

   If (hFile > 0) Then
      ReadFile hFile, tDosHeader, ByVal Len(tDosHeader), lngBytesRead, ByVal 0&
      CopyMemory Buffer(0), tDosHeader.Magic, 2
      If (Chr(Buffer(0)) & Chr(Buffer(1)) = "MZ") Then
         SetFilePointer hFile, tDosHeader.lfanew, 0, 0
         ReadFile hFile, Buffer(0), 4, lngBytesRead, ByVal 0&
         If (Chr(Buffer(0)) = "P") And (Chr(Buffer(1)) = "E") And (Buffer(2) = 0) And (Buffer(3) = 0) Then
            Valid_PE = True
            Exit Function
         End If
      End If
   End If

   Valid_PE = False

End Function
Public Function GetResTreeOffset(hFile As Long) As Long
On Error GoTo ErrHandler:

   Dim tDos          As IMAGE_DOS_HEADER
   Dim tFile         As IMAGE_FILE_HEADER
   Dim tOptional     As IMAGE_OPTIONAL_HEADER
   Dim tSections()   As IMAGE_SECTION_HEADER
   Dim BytesRead     As Long
   Dim intC          As Integer
   Dim TreeFound     As Boolean

   TreeFound = False
   If (hFile > 0) Then
      SetFilePointer hFile, 0, 0, 0
      ' Get the offset of the Image File Header
      ReadFile hFile, tDos, Len(tDos), BytesRead, ByVal 0&
      SetFilePointer hFile, ByVal tDos.lfanew + 4, 0, 0
      ' Get the Image File Header and the Image Optional Header
      ReadFile hFile, tFile, Len(tFile), BytesRead, ByVal 0&
      ReadFile hFile, tOptional, Len(tOptional), BytesRead, ByVal 0&
      ' Get section headers
      ReDim tSections(tFile.NumberOfSections - 1) As IMAGE_SECTION_HEADER
      ReadFile hFile, tSections(0), Len(tSections(0)) * tFile.NumberOfSections, BytesRead, ByVal 0&
      ' Make sure there is a resource tree in this file
      If (tOptional.DataEntries(2).DataSize) Then
         ' Save section alignment and file alignment of image
         SectionAlignment = tOptional.SectionAlignment
         FileAlignment = tOptional.FileAlignment
         ' Determine which section contains the resource tree
         For intC = 0 To UBound(tSections)
            If (tSections(intC).VirtualAddress <= tOptional.DataEntries(2).DataRVA) _
             And ((tSections(intC).VirtualAddress + tSections(intC).SizeOfData) > tOptional.DataEntries(2).DataRVA) Then
               TreeFound = True
               ' Save RVA and offset of resource section for future calculations
               ResSectionRVA = tSections(intC).VirtualAddress
               ResSectionOffset = tSections(intC).PData
               ' Calculate the physical file offset of the resouce tree
               GetResTreeOffset = tSections(intC).PData + (tOptional.DataEntries(2).DataRVA - tSections(intC).VirtualAddress)
               Exit For
            End If
         Next intC
         If Not TreeFound Then
            GetResTreeOffset = -1
         End If
      Else
         GetResTreeOffset = -1
      End If
   Else
      GetResTreeOffset = -1
   End If
   Exit Function

ErrHandler:
   MsgBox "An error occurred while locating the resource tree. " _
    & " Please make sure neither of the specified files are in use.", vbOKOnly + vbExclamation, _
    App.EXEName & " - " & eRR.Description

End Function
Public Function GetIconOffsets(hFile As Long, TreeOffset As Long, Icons() As IconDescriptor) As Long
On Error GoTo ErrHandler:

   Dim Root          As IMAGE_RESOURCE_DIR      ' Root node of resource tree
   Dim L1Entries()   As RESOURCE_DIR_ENTRY      ' 1st level of directory entries
   Dim L2Root()      As IMAGE_RESOURCE_DIR      ' Level 2 resource directories
   Dim L2Entries()   As RESOURCE_DIR_ENTRY      ' 2nd level of directory entries
   Dim L3Root()      As IMAGE_RESOURCE_DIR      ' Level 3 resource directories
   Dim L3Entries()   As RESOURCE_DIR_ENTRY      ' 3rd level of directory entries
   Dim DataEntries() As RESOURCE_DATA_ENTRY     ' Resource data entries
   Dim DIB           As DIB_HEADER              ' Descriptor for icon images
   Dim iLvl1         As Integer                 ' Loop Counter (first level)
   Dim iLvl2         As Integer                 ' Loop Counter (second level)
   Dim iLvl3         As Integer                 ' Loop Counter (third level)
   Dim Cursor        As Long                    ' Temp val for setting file pointer
   Dim BytesRead     As Long                    ' For ReadFile()
   Dim Count         As Integer                 ' Number of icons found

   If (hFile > 0) Then
      Count = 0
      SetFilePointer hFile, ByVal TreeOffset, 0, 0
      ' Get the root node and begin navigating the resource tree
      ReadFile hFile, Root, Len(Root), BytesRead, ByVal 0
      ReDim L2Root(Root.NamedEntries + Root.IDEntries) As IMAGE_RESOURCE_DIR
      ReDim L1Entries(Root.NamedEntries + Root.IDEntries) As RESOURCE_DIR_ENTRY
      ' Get first level child nodes
      For iLvl1 = 1 To (Root.NamedEntries + Root.IDEntries)
         SetFilePointer hFile, TreeOffset + 8 + (iLvl1 * 8), 0, 0
         ReadFile hFile, L1Entries(iLvl1), 8, BytesRead, ByVal 0&
         If L1Entries(iLvl1).Name = 3 Then
            ' Jump to level 2 and get directory
            '     Strip high-order byte from offset
            CopyMemory Cursor, L1Entries(iLvl1).Offset, 3
            Cursor = Cursor + TreeOffset
            SetFilePointer hFile, ByVal Cursor, 0, 0
            ReadFile hFile, L2Root(iLvl1), 16, BytesRead, ByVal 0&
            ReDim L3Root(L2Root(iLvl1).NamedEntries + L2Root(iLvl1).IDEntries) As IMAGE_RESOURCE_DIR
            ReDim L2Entries(L2Root(iLvl1).IDEntries + L2Root(iLvl1).NamedEntries) As RESOURCE_DIR_ENTRY
            For iLvl2 = 1 To (L2Root(iLvl1).IDEntries + L2Root(iLvl1).NamedEntries)
               ' Read second level child nodes
               CopyMemory Cursor, L1Entries(iLvl1).Offset, 3
               Cursor = Cursor + TreeOffset
               SetFilePointer hFile, Cursor + 8 + (iLvl2 * 8), 0, 0
               ReadFile hFile, L2Entries(iLvl2), 8, BytesRead, ByVal 0&
               ' Jump to level 3 and get directory
               CopyMemory Cursor, L2Entries(iLvl2).Offset, 3
               Cursor = Cursor + TreeOffset
               SetFilePointer hFile, ByVal Cursor, 0, 0
               ReadFile hFile, L3Root(iLvl2), 16, BytesRead, ByVal 0&
               ReDim L3Entries(L3Root(iLvl2).NamedEntries + L3Root(iLvl2).IDEntries) As RESOURCE_DIR_ENTRY
               ReDim DataEntries(L3Root(iLvl2).NamedEntries + L3Root(iLvl2).IDEntries) As RESOURCE_DATA_ENTRY
               For iLvl3 = 1 To (L3Root(iLvl2).NamedEntries + L3Root(iLvl2).IDEntries)
                  ' Read third level child nodes
                  CopyMemory Cursor, L2Entries(iLvl2).Offset, 3
                  Cursor = Cursor + TreeOffset
                  SetFilePointer hFile, (Cursor + 8 + (iLvl3 * 8)), 0, 0
                  ReadFile hFile, L3Entries(iLvl3), 8, BytesRead, ByVal 0&
                  ' Jump to IMAGE_DATA_ENTRY and get RVA of IconDir structure
                  SetFilePointer hFile, TreeOffset + (L3Entries(iLvl3).Offset), 0, 0
                  ReadFile hFile, DataEntries(iLvl3), 16, BytesRead, ByVal 0&
                  ' Convert RVA of IconDir structure to file offset and store
                  Count = Count + 1
                  ReDim Preserve Icons(Count) As IconDescriptor
                  Icons(Count).Offset = RVA_to_Offset(DataEntries(iLvl3).Offset)
                  ' Store ID of icon resource
                  Icons(Count).ID = L2Entries(iLvl2).Name
                  ' Store Size of icon resource
                  SetFilePointer hFile, Icons(Count).Offset, 0, 0
                  ReadFile hFile, DIB, ByVal Len(DIB), BytesRead, ByVal 0&
                  Icons(Count).Size = DIB.ImageSize + 40
               Next iLvl3
            Next iLvl2
         End If
      Next iLvl1
   Else
      Count = 0
   End If

   ' Return the number of icons found
   GetIconOffsets = Count
   Exit Function

ErrHandler:
   MsgBox "An error occurred while locating the icon resources. " _
    & " Please make sure neither of the specified files are in use.", vbOKOnly + vbExclamation, _
    App.EXEName & " - " & eRR.Description

End Function
Public Function HackDirectories(hFile As Long, ResTree As Long, DIBOffset As Long, _
                                DIBAttrib As ICON_DIR_ENTRY) As Boolean
On Error GoTo ErrHandler:

   Dim Cursor        As Long                 ' File pointer position
   Dim Root          As IMAGE_RESOURCE_DIR   ' Root node of res tree
   Dim L1Entries()   As RESOURCE_DIR_ENTRY   ' First-level child nodes
   Dim L2Root()      As IMAGE_RESOURCE_DIR   ' Second-level root nodes
   Dim L2Entries()   As RESOURCE_DIR_ENTRY   ' Second-level child nodes
   Dim L3Root()      As IMAGE_RESOURCE_DIR   ' Third-level root nodes
   Dim L3Entries()   As RESOURCE_DIR_ENTRY   ' Third-level child nodes
   Dim DataEntries() As RESOURCE_DATA_ENTRY  ' IMAGE_RESOURCE_DATA_ENTRY structs
   Dim IcoDir        As ICON_DIR             ' IconDirectory in EXE
   Dim iLvl1         As Integer              ' Loop Counter (first level)
   Dim iLvl2         As Integer              ' Loop Counter (second level)
   Dim iLvl3         As Integer              ' Loop Counter (third level)
   Dim intC          As Integer              ' Loop Counter (general)
   Dim BytesRead     As Long                 ' Returned by Read/WriteFile API's

   If (hFile >= 0) Then
      ' Convert DIBOffset to an RVA (needed for RESOURCE_DATA_ENTRY structures)
      DIBOffset = Offset_to_RVA(DIBOffset)
      SetFilePointer hFile, ByVal ResTree, 0, 0
      ReadFile hFile, Root, Len(Root), BytesRead, ByVal 0&
      ReDim L1Entries(Root.NamedEntries + Root.IDEntries) As RESOURCE_DIR_ENTRY
      ReDim L2Root(Root.NamedEntries + Root.IDEntries) As IMAGE_RESOURCE_DIR
      ' Loop through first-level child nodes and find RT_GROUP_ICON branch
      For iLvl1 = 1 To (Root.NamedEntries + Root.IDEntries)
         SetFilePointer hFile, ResTree + 8 + (iLvl1 * 8), 0, 0
         ReadFile hFile, L1Entries(iLvl1), 8, BytesRead, ByVal 0&
         If L1Entries(iLvl1).Name = &HE Then
            ' RT_GROUP_ICON branch found
            CopyMemory Cursor, L1Entries(iLvl1).Offset, 3
            Cursor = Cursor + ResTree
            SetFilePointer hFile, Cursor, 0, 0
            ' Read second-level directory
            ReadFile hFile, L2Root(iLvl1), 16, BytesRead, ByVal 0&
            ReDim L2Entries(L2Root(iLvl1).NamedEntries + L2Root(iLvl1).IDEntries) As RESOURCE_DIR_ENTRY
            ReDim L3Root(L2Root(iLvl1).NamedEntries + L2Root(iLvl1).IDEntries) As IMAGE_RESOURCE_DIR
            For iLvl2 = 1 To (L2Root(iLvl1).NamedEntries + L2Root(iLvl1).IDEntries)
               CopyMemory Cursor, L1Entries(iLvl1).Offset, 3
               Cursor = Cursor + ResTree
               SetFilePointer hFile, Cursor + 8 + (iLvl2 * 8), 0, 0
               ReadFile hFile, L2Entries(iLvl2), 8, BytesRead, ByVal 0&
               CopyMemory Cursor, L2Entries(iLvl2).Offset, 3
               Cursor = Cursor + ResTree
               SetFilePointer hFile, Cursor, 0, 0
               ' Read thrid-level directory
               ReadFile hFile, L3Root(iLvl2), 16, BytesRead, ByVal 0&
               ReDim L3Entries(L3Root(iLvl2).NamedEntries + L3Root(iLvl2).IDEntries) As RESOURCE_DIR_ENTRY
               For iLvl3 = 1 To (L3Root(iLvl2).NamedEntries + L3Root(iLvl2).IDEntries)
                  ' Read third-level child nodes
                  CopyMemory Cursor, L2Entries(iLvl2).Offset, 3
                  Cursor = Cursor + ResTree + 8 + (iLvl3 * 8)
                  SetFilePointer hFile, Cursor, 0, 0
                  ReadFile hFile, L3Entries(iLvl3), 8, BytesRead, ByVal 0&
                  ' Jump to RESOURCE_DATA_ENTRY
                  CopyMemory Cursor, L3Entries(iLvl3).Offset, 3
                  Cursor = Cursor + ResTree
                  SetFilePointer hFile, Cursor, 0, 0
                  ReDim Preserve DataEntries(iLvl3) As RESOURCE_DATA_ENTRY
                  ReadFile hFile, DataEntries(iLvl3), 16, BytesRead, ByVal 0&
                  ' Jump to and read ICON_DIR structure
                  Cursor = RVA_to_Offset(DataEntries(iLvl3).Offset)
                  SetFilePointer hFile, Cursor, 0, 0
                  ReadFile hFile, IcoDir, 6, BytesRead, ByVal 0&
                  For intC = 1 To IcoDir.Count
                     WriteFile hFile, DIBAttrib, Len(DIBAttrib) - 4, BytesRead, ByVal 0&
                     SetFilePointer hFile, 2, 0, 1
                  Next intC
               Next iLvl3
            Next iLvl2
         ElseIf L1Entries(iLvl1).Name = 3 Then
            CopyMemory Cursor, L1Entries(iLvl1).Offset, 3
            Cursor = Cursor + ResTree
            SetFilePointer hFile, ByVal Cursor, 0, 0
            ' Read second-level directory
            ReadFile hFile, L2Root(iLvl1), 16, BytesRead, ByVal 0&
            ReDim L2Entries(L2Root(iLvl1).NamedEntries + L2Root(iLvl1).IDEntries) As RESOURCE_DIR_ENTRY
            ReDim L3Root(L2Root(iLvl1).NamedEntries + L2Root(iLvl1).IDEntries) As IMAGE_RESOURCE_DIR
            For iLvl2 = 1 To (L2Root(iLvl1).NamedEntries + L2Root(iLvl1).IDEntries)
               CopyMemory Cursor, L1Entries(iLvl1).Offset, 3
               Cursor = Cursor + ResTree
               SetFilePointer hFile, Cursor + 8 + (iLvl2 * 8), 0, 0
               ReadFile hFile, L2Entries(iLvl2), 8, BytesRead, ByVal 0&
               CopyMemory Cursor, L2Entries(iLvl2).Offset, 3
               Cursor = Cursor + ResTree
               SetFilePointer hFile, Cursor, 0, 0
               ' Read thrid-level directory
               ReadFile hFile, L3Root(iLvl2), 16, BytesRead, ByVal 0&
               ReDim L3Entries(L3Root(iLvl2).NamedEntries + L3Root(iLvl2).IDEntries) As RESOURCE_DIR_ENTRY
               For iLvl3 = 1 To (L3Root(iLvl2).NamedEntries + L3Root(iLvl2).IDEntries)
                  ' Read third-level child nodes
                  CopyMemory Cursor, L2Entries(iLvl2).Offset, 3
                  Cursor = Cursor + ResTree + 8 + (iLvl3 * 8)
                  SetFilePointer hFile, Cursor, 0, 0
                  ReadFile hFile, L3Entries(iLvl3), 8, BytesRead, ByVal 0&
                  ' Jump to and hack the RESOURCE_DATA_ENTRY
                  Cursor = L3Entries(iLvl3).Offset + ResTree
                  SetFilePointer hFile, Cursor, 0, 0
                  WriteFile hFile, DIBOffset, 4, BytesRead, ByVal 0&
                  WriteFile hFile, CLng(DIBAttrib.dwBytesInRes + 40), 4, BytesRead, ByVal 0&
               Next iLvl3
            Next iLvl2
         End If
      Next iLvl1
   Else
      HackDirectories = False
      Exit Function
   End If

   HackDirectories = True
   Exit Function

ErrHandler:
   MsgBox "An error occurred while modifying the resource directories. " _
    & " Please make sure neither of the specified files are in use.", vbOKOnly + vbExclamation, _
    App.EXEName & " - " & eRR.Description

End Function
Private Function RVA_to_Offset(RVA As Long) As Long
On Error GoTo ErrHandler:
   Dim TempOffset    As Long           ' Difference of RVA and start of section
   TempOffset = RVA - ResSectionRVA
   If (TempOffset >= 0) Then
      ' Calculate the file offset of the RVA
      RVA_to_Offset = ResSectionOffset + TempOffset
   Else
      RVA_to_Offset = -1
   End If
   Exit Function

ErrHandler:
   MsgBox "Error in RVA_to_Offset function: " & eRR.Number & ": " & eRR.Description, _
    vbOKOnly + vbExclamation, App.EXEName & " - Error"
End Function

Private Function Offset_to_RVA(Offset As Long) As Long
On Error GoTo ErrHandler:

   Dim TempOffset    As Long          ' Difference of Offset and start of section

   ' Get distance between offset and start of resource section
   TempOffset = Offset - ResSectionOffset
   If TempOffset >= 0 Then
      ' Calculate RVA of the file offset
      Offset_to_RVA = ResSectionRVA + TempOffset
   Else
      Offset_to_RVA = -1
   End If
   Exit Function

ErrHandler:
  MsgBox "Error in Offset_to_RVA function: " & eRR.Number & ": " & eRR.Description, _
    vbOKOnly + vbExclamation, App.EXEName & " - Error"

End Function




