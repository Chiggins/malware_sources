Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.Net
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms
Public Class Updater
    Public Sub New()
        Me.myclient = New WebClient
        Me.InitializeComponent()
    End Sub

    Public Sub delete(ByVal timeout As Integer)
        Try
            Dim startInfo As New ProcessStartInfo("cmd.exe")
            startInfo.Arguments = String.Concat(New String() {"/C ping 1.1.1.1 -n 1 -w ", Conversions.ToString(timeout), " > Nul & Del """, Application.ExecutablePath, """"})
            startInfo.CreateNoWindow = True
            startInfo.ErrorDialog = False
            startInfo.WindowStyle = ProcessWindowStyle.Hidden
            Process.Start(startInfo)
            Application.ExitThread()
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub
    Private Function FormatSize(ByVal size As Long) As Object
        Dim num As Long = size
        If ((num >= 0) AndAlso (num <= &H3FF)) Then
            Return Strings.Format((Conversions.ToString(size) & " Bytes"), "")
        End If
        If ((num >= &H400) AndAlso (num <= &HFFFFF)) Then
            Return (Strings.Format((CDbl(size) / 1024), "###0.00") & " KB")
        End If
        If ((num >= &H100000) AndAlso (num <= &H3E363C80)) Then
            Return (Strings.Format((CDbl(size) / 1048576), "###0.00") & " MB")
        End If
        If (num > &H3E363C80) Then
            Return (Strings.Format((CDbl(size) / 1073741824), "###0.00") & " GB")
        End If
        Return "N/A"
    End Function

    Private Sub myclient_DownloadFileCompleted(ByVal sender As Object, ByVal e As AsyncCompletedEventArgs)
        Me.delete(3)
    End Sub

    Private Sub myclient_DownloadProgressChanged(ByVal sender As Object, ByVal e As DownloadProgressChangedEventArgs)
        Try
            Me.ProgressBar1.Value = e.ProgressPercentage
            Dim num As Double = (CDbl(e.BytesReceived) / CDbl(e.TotalBytesToReceive))
            Me.Label1.Text = Conversions.ToString(Operators.ConcatenateObject(Operators.ConcatenateObject(Operators.ConcatenateObject(Operators.ConcatenateObject(Operators.ConcatenateObject(Operators.ConcatenateObject("Downloading ", Me.FormatSize(Conversions.ToLong(e.BytesReceived.ToString))), " from "), Me.FormatSize(Conversions.ToLong(e.TotalBytesToReceive.ToString))), ". - ("), num.ToString("P")), ")"))
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Dim exception As Exception = exception1
            Interaction.MsgBox(exception.Message, MsgBoxStyle.Critical, Nothing)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub Updater_FormClosing(sender As Object, e As FormClosingEventArgs) Handles Me.FormClosing
        e.Cancel = True
    End Sub

    Private Sub Updater_Load(sender As Object, e As EventArgs) Handles Me.Load
        Try
            Me.myclient.DownloadFileAsync(New Uri("http://luxnet.comli.com/luxnet.zip"), (Application.StartupPath & "\LuxNet_New.zip"))
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Dim exception As Exception = exception1
            Interaction.MsgBox(exception.Message, MsgBoxStyle.Critical, Nothing)
            ProjectData.ClearProjectError()
        End Try
    End Sub
    Private myclient As WebClient
End Class