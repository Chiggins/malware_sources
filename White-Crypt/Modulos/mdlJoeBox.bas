Attribute VB_Name = "mdlJoeBox"
'UTILIZACIÓN
'If iJoeBoxRunning(Environ("SystemDrive") & "\") = True Then
'   MsgBox ("SI")
'Else
'  MsgBox ("NO")
'End If
'||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
' Nombre Modulo: mSandboxieRunning
' Autor: [SMT] aKa [Skullmaster123]
' Dependencias: Ninguna
' Web: http://foro.code-makers.es/
' Distribucion: Este modulo es de distribucion libre
'               y puede ser posteado donde sea, siempre
'               y cuando no se borre este texto, y se
'               mencione el autor del mismo...
'||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
 
Private Declare Function GetVolumeInformation Lib "kernel32" Alias "GetVolumeInformationA" (ByVal lpRootPathName As String, ByVal lpVolumeNameBuffer As String, ByVal nVolumeNameSize As Long, lpVolumeSerialNumber As Long, lpMaximumComponentLength As Long, lpFileSystemFlags As Long, ByVal lpFileSystemNameBuffer As String, ByVal nFileSystemNameSize As Long) As Long
 
Public Function iJoeBoxRunning(ByVal dPath As String) As Boolean
On Error GoTo Error
 
Dim Snumber As Long
Dim First As String
Dim Second As String
    First = String$(255, Chr$(0))
    Second = String$(255, Chr$(0))
ret = GetVolumeInformation(dPath, First, Len(First), Snumber, 0, 0, Second, Len(Second))
 
If Snumber = Val("-1340953750") Then
    If Environ("SystemDrive") & "\" = "C:\" Then
        If Environ("Username") = "Administrator" Then
            iJoeBoxRunning = True
        Else
            iJoeBoxRunning = False
        End If
    Else
        iJoeBoxRunning = False
    End If
Else
    iJoeBoxRunning = False
End If
Exit Function
 
Error:
iJoeBoxRunning = False
End Function
 

