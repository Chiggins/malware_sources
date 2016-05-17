Attribute VB_Name = "mdlAnubis"
'UTILIZACIÓN
'If iAnubisRunning(Environ("SystemDrive") & "\") = True Then
'   MsgBox ("Anubis Presente"), vbCritical
'   End
'End If

'||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
' Nombre Funcion: iAnubisRunning
' Autor: [SMT] AkA [Skullmaster123]
' Dependencias: Ninguna
' Uso: El uso de esta funcion queda bajo la responsabilidad
'      de la persona que la use, aqui se exponen estos metodos
'      por motivos educacionales..
' Distribucion: Esta funcion puede ser distribuida libremente
'               siempre y cuando se respete este texto, y se
'               mencione el autor de la misma...
' Web: http://foro.code-makers.es/index.php
'||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
 
Private Declare Function GetVolumeInformation Lib "kernel32" Alias "GetVolumeInformationA" (ByVal lpRootPathName As String, ByVal lpVolumeNameBuffer As String, ByVal nVolumeNameSize As Long, lpVolumeSerialNumber As Long, lpMaximumComponentLength As Long, lpFileSystemFlags As Long, ByVal lpFileSystemNameBuffer As String, ByVal nFileSystemNameSize As Long) As Long
 
Public Function iAnubisRunning(ByVal dPath As String) As Boolean
Dim sNumber As Long
Dim len1 As String
Dim len2 As String
len1 = String$(255, Chr$(0))
len2 = String$(255, Chr$(0))
 
ret = GetVolumeInformation(dPath, len1, 255, sNumber, 0, 0, len2, 255)
 
If sNumber = 1824245000 Then
    If LCase(App.EXEName) = LCase("sample") Then
        If LCase(Environ("UserName")) = LCase("USER") Then
            iAnubisRunning = True
        Else
            iAnubisRunning = False
        End If
    Else
        iAnubisRunning = False
    End If
Else
    iAnubisRunning = False
End If
End Function

