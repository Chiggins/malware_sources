<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FileManager
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(FileManager))
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip()
        Me.ToolStripStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.ToolStripStatusLabel2 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.IL_Transfer = New System.Windows.Forms.ImageList(Me.components)
        Me.BetterListViewColumnHeader1 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader2 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader3 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader4 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader5 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.CustomTabcontrol1 = New LuxNET.CustomTabcontrol()
        Me.TP_FM = New System.Windows.Forms.TabPage()
        Me.btn_showthumbnails = New System.Windows.Forms.Button()
        Me.btn_forward = New System.Windows.Forms.Button()
        Me.btn_refresh = New System.Windows.Forms.Button()
        Me.btn_back = New System.Windows.Forms.Button()
        Me.cb_path = New System.Windows.Forms.ComboBox()
        Me.LV_Filemanager = New ComponentOwl.BetterListView.BetterListView()
        Me.CMS_Filemanager = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.SpecialDirectoriesToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.AppDataToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.CookiesToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DesktopToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.HistoryToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.InternetCacheToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.AppDataLocalToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DocumentsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MusicToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.PicturesToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ProgramsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.StartupToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.TempToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripMenuItem1 = New System.Windows.Forms.ToolStripSeparator()
        Me.FolderOptionsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.CreateNewFolderToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DeleteFolderToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.RenameFolderToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.CopyFolderToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MoveFolderToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.FileOptionsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.CreateNewFileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DeleteFileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.RenameFileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.CopyFileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MoveFileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DownloadFileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripMenuItem2 = New System.Windows.Forms.ToolStripSeparator()
        Me.UploadFileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.IL_FileManager = New System.Windows.Forms.ImageList(Me.components)
        Me.TB_FT = New System.Windows.Forms.TabPage()
        Me.LV_Transfers = New ComponentOwl.BetterListView.BetterListView()
        Me.StatusStrip1.SuspendLayout()
        Me.CustomTabcontrol1.SuspendLayout()
        Me.TP_FM.SuspendLayout()
        CType(Me.LV_Filemanager, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.CMS_Filemanager.SuspendLayout()
        Me.TB_FT.SuspendLayout()
        CType(Me.LV_Transfers, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripStatusLabel1, Me.ToolStripStatusLabel2})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 404)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(875, 22)
        Me.StatusStrip1.TabIndex = 2
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'ToolStripStatusLabel1
        '
        Me.ToolStripStatusLabel1.Name = "ToolStripStatusLabel1"
        Me.ToolStripStatusLabel1.Size = New System.Drawing.Size(0, 17)
        '
        'ToolStripStatusLabel2
        '
        Me.ToolStripStatusLabel2.Name = "ToolStripStatusLabel2"
        Me.ToolStripStatusLabel2.Size = New System.Drawing.Size(26, 17)
        Me.ToolStripStatusLabel2.Text = "Idle"
        '
        'IL_Transfer
        '
        Me.IL_Transfer.ImageStream = CType(resources.GetObject("IL_Transfer.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_Transfer.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_Transfer.Images.SetKeyName(0, "open_folder_blue.png")
        Me.IL_Transfer.Images.SetKeyName(1, "refresh_blue.png")
        '
        'BetterListViewColumnHeader1
        '
        Me.BetterListViewColumnHeader1.Name = "BetterListViewColumnHeader1"
        Me.BetterListViewColumnHeader1.Text = "FileName"
        Me.BetterListViewColumnHeader1.Width = 316
        '
        'BetterListViewColumnHeader2
        '
        Me.BetterListViewColumnHeader2.Name = "BetterListViewColumnHeader2"
        Me.BetterListViewColumnHeader2.Text = "Progress"
        Me.BetterListViewColumnHeader2.Width = 87
        '
        'BetterListViewColumnHeader3
        '
        Me.BetterListViewColumnHeader3.Name = "BetterListViewColumnHeader3"
        Me.BetterListViewColumnHeader3.Text = "File Size"
        Me.BetterListViewColumnHeader3.Width = 91
        '
        'BetterListViewColumnHeader4
        '
        Me.BetterListViewColumnHeader4.Name = "BetterListViewColumnHeader4"
        Me.BetterListViewColumnHeader4.Text = "Speed"
        Me.BetterListViewColumnHeader4.Width = 94
        '
        'BetterListViewColumnHeader5
        '
        Me.BetterListViewColumnHeader5.Name = "BetterListViewColumnHeader5"
        Me.BetterListViewColumnHeader5.Text = "Status"
        Me.BetterListViewColumnHeader5.Width = 95
        '
        'CustomTabcontrol1
        '
        Me.CustomTabcontrol1.Alignment = System.Windows.Forms.TabAlignment.Left
        Me.CustomTabcontrol1.Controls.Add(Me.TP_FM)
        Me.CustomTabcontrol1.Controls.Add(Me.TB_FT)
        Me.CustomTabcontrol1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.CustomTabcontrol1.DrawMode = System.Windows.Forms.TabDrawMode.OwnerDrawFixed
        Me.CustomTabcontrol1.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.CustomTabcontrol1.ImageList = Me.IL_Transfer
        Me.CustomTabcontrol1.ItemSize = New System.Drawing.Size(40, 150)
        Me.CustomTabcontrol1.Location = New System.Drawing.Point(0, 0)
        Me.CustomTabcontrol1.Multiline = True
        Me.CustomTabcontrol1.Name = "CustomTabcontrol1"
        Me.CustomTabcontrol1.SelectedIndex = 0
        Me.CustomTabcontrol1.SelectedItemColor = System.Drawing.Color.FromArgb(CType(CType(30, Byte), Integer), CType(CType(10, Byte), Integer), CType(CType(100, Byte), Integer), CType(CType(200, Byte), Integer))
        Me.CustomTabcontrol1.Size = New System.Drawing.Size(875, 404)
        Me.CustomTabcontrol1.SizeMode = System.Windows.Forms.TabSizeMode.Fixed
        Me.CustomTabcontrol1.TabIndex = 3
        '
        'TP_FM
        '
        Me.TP_FM.Controls.Add(Me.btn_showthumbnails)
        Me.TP_FM.Controls.Add(Me.btn_forward)
        Me.TP_FM.Controls.Add(Me.btn_refresh)
        Me.TP_FM.Controls.Add(Me.btn_back)
        Me.TP_FM.Controls.Add(Me.cb_path)
        Me.TP_FM.Controls.Add(Me.LV_Filemanager)
        Me.TP_FM.Location = New System.Drawing.Point(154, 4)
        Me.TP_FM.Name = "TP_FM"
        Me.TP_FM.Padding = New System.Windows.Forms.Padding(3)
        Me.TP_FM.Size = New System.Drawing.Size(717, 396)
        Me.TP_FM.TabIndex = 0
        Me.TP_FM.Text = "File Manager"
        Me.TP_FM.UseVisualStyleBackColor = True
        '
        'btn_showthumbnails
        '
        Me.btn_showthumbnails.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btn_showthumbnails.Image = CType(resources.GetObject("btn_showthumbnails.Image"), System.Drawing.Image)
        Me.btn_showthumbnails.Location = New System.Drawing.Point(677, 10)
        Me.btn_showthumbnails.Name = "btn_showthumbnails"
        Me.btn_showthumbnails.Size = New System.Drawing.Size(32, 27)
        Me.btn_showthumbnails.TabIndex = 5
        Me.btn_showthumbnails.UseVisualStyleBackColor = True
        '
        'btn_forward
        '
        Me.btn_forward.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btn_forward.Image = CType(resources.GetObject("btn_forward.Image"), System.Drawing.Image)
        Me.btn_forward.Location = New System.Drawing.Point(639, 10)
        Me.btn_forward.Name = "btn_forward"
        Me.btn_forward.Size = New System.Drawing.Size(32, 27)
        Me.btn_forward.TabIndex = 4
        Me.btn_forward.UseVisualStyleBackColor = True
        '
        'btn_refresh
        '
        Me.btn_refresh.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btn_refresh.Image = CType(resources.GetObject("btn_refresh.Image"), System.Drawing.Image)
        Me.btn_refresh.Location = New System.Drawing.Point(601, 10)
        Me.btn_refresh.Name = "btn_refresh"
        Me.btn_refresh.Size = New System.Drawing.Size(32, 27)
        Me.btn_refresh.TabIndex = 3
        Me.btn_refresh.UseVisualStyleBackColor = True
        '
        'btn_back
        '
        Me.btn_back.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btn_back.Image = CType(resources.GetObject("btn_back.Image"), System.Drawing.Image)
        Me.btn_back.Location = New System.Drawing.Point(563, 10)
        Me.btn_back.Name = "btn_back"
        Me.btn_back.Size = New System.Drawing.Size(32, 27)
        Me.btn_back.TabIndex = 2
        Me.btn_back.UseVisualStyleBackColor = True
        '
        'cb_path
        '
        Me.cb_path.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cb_path.FormattingEnabled = True
        Me.cb_path.Location = New System.Drawing.Point(10, 10)
        Me.cb_path.Name = "cb_path"
        Me.cb_path.Size = New System.Drawing.Size(547, 25)
        Me.cb_path.TabIndex = 1
        '
        'LV_Filemanager
        '
        Me.LV_Filemanager.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LV_Filemanager.ContextMenuStrip = Me.CMS_Filemanager
        Me.LV_Filemanager.ImageList = Me.IL_FileManager
        Me.LV_Filemanager.Location = New System.Drawing.Point(10, 41)
        Me.LV_Filemanager.Name = "LV_Filemanager"
        Me.LV_Filemanager.Size = New System.Drawing.Size(699, 349)
        Me.LV_Filemanager.TabIndex = 0
        '
        'CMS_Filemanager
        '
        Me.CMS_Filemanager.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.SpecialDirectoriesToolStripMenuItem, Me.ToolStripMenuItem1, Me.FolderOptionsToolStripMenuItem, Me.FileOptionsToolStripMenuItem, Me.ToolStripMenuItem2, Me.UploadFileToolStripMenuItem})
        Me.CMS_Filemanager.Name = "CMS_Folder"
        Me.CMS_Filemanager.Size = New System.Drawing.Size(171, 104)
        '
        'SpecialDirectoriesToolStripMenuItem
        '
        Me.SpecialDirectoriesToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AppDataToolStripMenuItem, Me.CookiesToolStripMenuItem, Me.DesktopToolStripMenuItem, Me.HistoryToolStripMenuItem, Me.InternetCacheToolStripMenuItem, Me.AppDataLocalToolStripMenuItem, Me.DocumentsToolStripMenuItem, Me.MusicToolStripMenuItem, Me.PicturesToolStripMenuItem, Me.ProgramsToolStripMenuItem, Me.StartupToolStripMenuItem, Me.TempToolStripMenuItem})
        Me.SpecialDirectoriesToolStripMenuItem.Image = CType(resources.GetObject("SpecialDirectoriesToolStripMenuItem.Image"), System.Drawing.Image)
        Me.SpecialDirectoriesToolStripMenuItem.Name = "SpecialDirectoriesToolStripMenuItem"
        Me.SpecialDirectoriesToolStripMenuItem.Size = New System.Drawing.Size(170, 22)
        Me.SpecialDirectoriesToolStripMenuItem.Text = "Special Directories"
        '
        'AppDataToolStripMenuItem
        '
        Me.AppDataToolStripMenuItem.Image = CType(resources.GetObject("AppDataToolStripMenuItem.Image"), System.Drawing.Image)
        Me.AppDataToolStripMenuItem.Name = "AppDataToolStripMenuItem"
        Me.AppDataToolStripMenuItem.Size = New System.Drawing.Size(151, 22)
        Me.AppDataToolStripMenuItem.Text = "AppData"
        '
        'CookiesToolStripMenuItem
        '
        Me.CookiesToolStripMenuItem.Image = CType(resources.GetObject("CookiesToolStripMenuItem.Image"), System.Drawing.Image)
        Me.CookiesToolStripMenuItem.Name = "CookiesToolStripMenuItem"
        Me.CookiesToolStripMenuItem.Size = New System.Drawing.Size(151, 22)
        Me.CookiesToolStripMenuItem.Text = "Cookies"
        '
        'DesktopToolStripMenuItem
        '
        Me.DesktopToolStripMenuItem.Image = CType(resources.GetObject("DesktopToolStripMenuItem.Image"), System.Drawing.Image)
        Me.DesktopToolStripMenuItem.Name = "DesktopToolStripMenuItem"
        Me.DesktopToolStripMenuItem.Size = New System.Drawing.Size(151, 22)
        Me.DesktopToolStripMenuItem.Text = "Desktop"
        '
        'HistoryToolStripMenuItem
        '
        Me.HistoryToolStripMenuItem.Image = CType(resources.GetObject("HistoryToolStripMenuItem.Image"), System.Drawing.Image)
        Me.HistoryToolStripMenuItem.Name = "HistoryToolStripMenuItem"
        Me.HistoryToolStripMenuItem.Size = New System.Drawing.Size(151, 22)
        Me.HistoryToolStripMenuItem.Text = "History"
        '
        'InternetCacheToolStripMenuItem
        '
        Me.InternetCacheToolStripMenuItem.Image = CType(resources.GetObject("InternetCacheToolStripMenuItem.Image"), System.Drawing.Image)
        Me.InternetCacheToolStripMenuItem.Name = "InternetCacheToolStripMenuItem"
        Me.InternetCacheToolStripMenuItem.Size = New System.Drawing.Size(151, 22)
        Me.InternetCacheToolStripMenuItem.Text = "Internet Cache"
        '
        'AppDataLocalToolStripMenuItem
        '
        Me.AppDataLocalToolStripMenuItem.Image = CType(resources.GetObject("AppDataLocalToolStripMenuItem.Image"), System.Drawing.Image)
        Me.AppDataLocalToolStripMenuItem.Name = "AppDataLocalToolStripMenuItem"
        Me.AppDataLocalToolStripMenuItem.Size = New System.Drawing.Size(151, 22)
        Me.AppDataLocalToolStripMenuItem.Text = "AppData Local"
        '
        'DocumentsToolStripMenuItem
        '
        Me.DocumentsToolStripMenuItem.Image = CType(resources.GetObject("DocumentsToolStripMenuItem.Image"), System.Drawing.Image)
        Me.DocumentsToolStripMenuItem.Name = "DocumentsToolStripMenuItem"
        Me.DocumentsToolStripMenuItem.Size = New System.Drawing.Size(151, 22)
        Me.DocumentsToolStripMenuItem.Text = "Documents"
        '
        'MusicToolStripMenuItem
        '
        Me.MusicToolStripMenuItem.Image = CType(resources.GetObject("MusicToolStripMenuItem.Image"), System.Drawing.Image)
        Me.MusicToolStripMenuItem.Name = "MusicToolStripMenuItem"
        Me.MusicToolStripMenuItem.Size = New System.Drawing.Size(151, 22)
        Me.MusicToolStripMenuItem.Text = "Music"
        '
        'PicturesToolStripMenuItem
        '
        Me.PicturesToolStripMenuItem.Image = CType(resources.GetObject("PicturesToolStripMenuItem.Image"), System.Drawing.Image)
        Me.PicturesToolStripMenuItem.Name = "PicturesToolStripMenuItem"
        Me.PicturesToolStripMenuItem.Size = New System.Drawing.Size(151, 22)
        Me.PicturesToolStripMenuItem.Text = "Pictures"
        '
        'ProgramsToolStripMenuItem
        '
        Me.ProgramsToolStripMenuItem.Image = CType(resources.GetObject("ProgramsToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ProgramsToolStripMenuItem.Name = "ProgramsToolStripMenuItem"
        Me.ProgramsToolStripMenuItem.Size = New System.Drawing.Size(151, 22)
        Me.ProgramsToolStripMenuItem.Text = "Programs"
        '
        'StartupToolStripMenuItem
        '
        Me.StartupToolStripMenuItem.Image = CType(resources.GetObject("StartupToolStripMenuItem.Image"), System.Drawing.Image)
        Me.StartupToolStripMenuItem.Name = "StartupToolStripMenuItem"
        Me.StartupToolStripMenuItem.Size = New System.Drawing.Size(151, 22)
        Me.StartupToolStripMenuItem.Text = "Startup"
        '
        'TempToolStripMenuItem
        '
        Me.TempToolStripMenuItem.Image = CType(resources.GetObject("TempToolStripMenuItem.Image"), System.Drawing.Image)
        Me.TempToolStripMenuItem.Name = "TempToolStripMenuItem"
        Me.TempToolStripMenuItem.Size = New System.Drawing.Size(151, 22)
        Me.TempToolStripMenuItem.Text = "Temp"
        '
        'ToolStripMenuItem1
        '
        Me.ToolStripMenuItem1.Name = "ToolStripMenuItem1"
        Me.ToolStripMenuItem1.Size = New System.Drawing.Size(167, 6)
        '
        'FolderOptionsToolStripMenuItem
        '
        Me.FolderOptionsToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.CreateNewFolderToolStripMenuItem, Me.DeleteFolderToolStripMenuItem, Me.RenameFolderToolStripMenuItem, Me.CopyFolderToolStripMenuItem, Me.MoveFolderToolStripMenuItem})
        Me.FolderOptionsToolStripMenuItem.Image = CType(resources.GetObject("FolderOptionsToolStripMenuItem.Image"), System.Drawing.Image)
        Me.FolderOptionsToolStripMenuItem.Name = "FolderOptionsToolStripMenuItem"
        Me.FolderOptionsToolStripMenuItem.Size = New System.Drawing.Size(170, 22)
        Me.FolderOptionsToolStripMenuItem.Text = "Folder Options"
        '
        'CreateNewFolderToolStripMenuItem
        '
        Me.CreateNewFolderToolStripMenuItem.Image = CType(resources.GetObject("CreateNewFolderToolStripMenuItem.Image"), System.Drawing.Image)
        Me.CreateNewFolderToolStripMenuItem.Name = "CreateNewFolderToolStripMenuItem"
        Me.CreateNewFolderToolStripMenuItem.Size = New System.Drawing.Size(171, 22)
        Me.CreateNewFolderToolStripMenuItem.Text = "Create New Folder"
        '
        'DeleteFolderToolStripMenuItem
        '
        Me.DeleteFolderToolStripMenuItem.Image = CType(resources.GetObject("DeleteFolderToolStripMenuItem.Image"), System.Drawing.Image)
        Me.DeleteFolderToolStripMenuItem.Name = "DeleteFolderToolStripMenuItem"
        Me.DeleteFolderToolStripMenuItem.Size = New System.Drawing.Size(171, 22)
        Me.DeleteFolderToolStripMenuItem.Text = "Delete Folder"
        '
        'RenameFolderToolStripMenuItem
        '
        Me.RenameFolderToolStripMenuItem.Image = CType(resources.GetObject("RenameFolderToolStripMenuItem.Image"), System.Drawing.Image)
        Me.RenameFolderToolStripMenuItem.Name = "RenameFolderToolStripMenuItem"
        Me.RenameFolderToolStripMenuItem.Size = New System.Drawing.Size(171, 22)
        Me.RenameFolderToolStripMenuItem.Text = "Rename Folder"
        '
        'CopyFolderToolStripMenuItem
        '
        Me.CopyFolderToolStripMenuItem.Image = CType(resources.GetObject("CopyFolderToolStripMenuItem.Image"), System.Drawing.Image)
        Me.CopyFolderToolStripMenuItem.Name = "CopyFolderToolStripMenuItem"
        Me.CopyFolderToolStripMenuItem.Size = New System.Drawing.Size(171, 22)
        Me.CopyFolderToolStripMenuItem.Text = "Copy Folder"
        '
        'MoveFolderToolStripMenuItem
        '
        Me.MoveFolderToolStripMenuItem.Image = CType(resources.GetObject("MoveFolderToolStripMenuItem.Image"), System.Drawing.Image)
        Me.MoveFolderToolStripMenuItem.Name = "MoveFolderToolStripMenuItem"
        Me.MoveFolderToolStripMenuItem.Size = New System.Drawing.Size(171, 22)
        Me.MoveFolderToolStripMenuItem.Text = "Move Folder"
        '
        'FileOptionsToolStripMenuItem
        '
        Me.FileOptionsToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.CreateNewFileToolStripMenuItem, Me.DeleteFileToolStripMenuItem, Me.RenameFileToolStripMenuItem, Me.CopyFileToolStripMenuItem, Me.MoveFileToolStripMenuItem, Me.DownloadFileToolStripMenuItem})
        Me.FileOptionsToolStripMenuItem.Image = CType(resources.GetObject("FileOptionsToolStripMenuItem.Image"), System.Drawing.Image)
        Me.FileOptionsToolStripMenuItem.Name = "FileOptionsToolStripMenuItem"
        Me.FileOptionsToolStripMenuItem.Size = New System.Drawing.Size(170, 22)
        Me.FileOptionsToolStripMenuItem.Text = "File Options"
        '
        'CreateNewFileToolStripMenuItem
        '
        Me.CreateNewFileToolStripMenuItem.Image = CType(resources.GetObject("CreateNewFileToolStripMenuItem.Image"), System.Drawing.Image)
        Me.CreateNewFileToolStripMenuItem.Name = "CreateNewFileToolStripMenuItem"
        Me.CreateNewFileToolStripMenuItem.Size = New System.Drawing.Size(156, 22)
        Me.CreateNewFileToolStripMenuItem.Text = "Create New File"
        '
        'DeleteFileToolStripMenuItem
        '
        Me.DeleteFileToolStripMenuItem.Image = CType(resources.GetObject("DeleteFileToolStripMenuItem.Image"), System.Drawing.Image)
        Me.DeleteFileToolStripMenuItem.Name = "DeleteFileToolStripMenuItem"
        Me.DeleteFileToolStripMenuItem.Size = New System.Drawing.Size(156, 22)
        Me.DeleteFileToolStripMenuItem.Text = "Delete File"
        '
        'RenameFileToolStripMenuItem
        '
        Me.RenameFileToolStripMenuItem.Image = CType(resources.GetObject("RenameFileToolStripMenuItem.Image"), System.Drawing.Image)
        Me.RenameFileToolStripMenuItem.Name = "RenameFileToolStripMenuItem"
        Me.RenameFileToolStripMenuItem.Size = New System.Drawing.Size(156, 22)
        Me.RenameFileToolStripMenuItem.Text = "Rename File"
        '
        'CopyFileToolStripMenuItem
        '
        Me.CopyFileToolStripMenuItem.Image = CType(resources.GetObject("CopyFileToolStripMenuItem.Image"), System.Drawing.Image)
        Me.CopyFileToolStripMenuItem.Name = "CopyFileToolStripMenuItem"
        Me.CopyFileToolStripMenuItem.Size = New System.Drawing.Size(156, 22)
        Me.CopyFileToolStripMenuItem.Text = "Copy File"
        '
        'MoveFileToolStripMenuItem
        '
        Me.MoveFileToolStripMenuItem.Image = CType(resources.GetObject("MoveFileToolStripMenuItem.Image"), System.Drawing.Image)
        Me.MoveFileToolStripMenuItem.Name = "MoveFileToolStripMenuItem"
        Me.MoveFileToolStripMenuItem.Size = New System.Drawing.Size(156, 22)
        Me.MoveFileToolStripMenuItem.Text = "Move File"
        '
        'DownloadFileToolStripMenuItem
        '
        Me.DownloadFileToolStripMenuItem.Image = CType(resources.GetObject("DownloadFileToolStripMenuItem.Image"), System.Drawing.Image)
        Me.DownloadFileToolStripMenuItem.Name = "DownloadFileToolStripMenuItem"
        Me.DownloadFileToolStripMenuItem.Size = New System.Drawing.Size(156, 22)
        Me.DownloadFileToolStripMenuItem.Text = "Download File"
        '
        'ToolStripMenuItem2
        '
        Me.ToolStripMenuItem2.Name = "ToolStripMenuItem2"
        Me.ToolStripMenuItem2.Size = New System.Drawing.Size(167, 6)
        '
        'UploadFileToolStripMenuItem
        '
        Me.UploadFileToolStripMenuItem.Image = CType(resources.GetObject("UploadFileToolStripMenuItem.Image"), System.Drawing.Image)
        Me.UploadFileToolStripMenuItem.Name = "UploadFileToolStripMenuItem"
        Me.UploadFileToolStripMenuItem.Size = New System.Drawing.Size(170, 22)
        Me.UploadFileToolStripMenuItem.Text = "Upload File"
        '
        'IL_FileManager
        '
        Me.IL_FileManager.ImageStream = CType(resources.GetObject("IL_FileManager.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_FileManager.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_FileManager.Images.SetKeyName(0, "folder-horizontal.png")
        Me.IL_FileManager.Images.SetKeyName(1, "application-blue.png")
        Me.IL_FileManager.Images.SetKeyName(2, "blue-document-code.png")
        Me.IL_FileManager.Images.SetKeyName(3, "blue-document-excel.png")
        Me.IL_FileManager.Images.SetKeyName(4, "blue-document-flash-movie.png")
        Me.IL_FileManager.Images.SetKeyName(5, "blue-document-globe.png")
        Me.IL_FileManager.Images.SetKeyName(6, "blue-document-illustrator.png")
        Me.IL_FileManager.Images.SetKeyName(7, "blue-document-music.png")
        Me.IL_FileManager.Images.SetKeyName(8, "blue-document-pdf.png")
        Me.IL_FileManager.Images.SetKeyName(9, "blue-document-photoshop.png")
        Me.IL_FileManager.Images.SetKeyName(10, "blue-document-php.png")
        Me.IL_FileManager.Images.SetKeyName(11, "blue-document-powerpoint.png")
        Me.IL_FileManager.Images.SetKeyName(12, "blue-document-visual-studio.png")
        Me.IL_FileManager.Images.SetKeyName(13, "blue-document-word.png")
        Me.IL_FileManager.Images.SetKeyName(14, "blue-document-xaml.png")
        Me.IL_FileManager.Images.SetKeyName(15, "Briefcase.png")
        Me.IL_FileManager.Images.SetKeyName(16, "database.png")
        Me.IL_FileManager.Images.SetKeyName(17, "document.png")
        Me.IL_FileManager.Images.SetKeyName(18, "blue-document-outlook.png")
        Me.IL_FileManager.Images.SetKeyName(19, "film.png")
        Me.IL_FileManager.Images.SetKeyName(20, "folder-zipper.png")
        Me.IL_FileManager.Images.SetKeyName(21, "image.png")
        Me.IL_FileManager.Images.SetKeyName(22, "script.png")
        Me.IL_FileManager.Images.SetKeyName(23, "blue-document-text.png")
        '
        'TB_FT
        '
        Me.TB_FT.Controls.Add(Me.LV_Transfers)
        Me.TB_FT.Location = New System.Drawing.Point(154, 4)
        Me.TB_FT.Name = "TB_FT"
        Me.TB_FT.Padding = New System.Windows.Forms.Padding(3)
        Me.TB_FT.Size = New System.Drawing.Size(717, 396)
        Me.TB_FT.TabIndex = 1
        Me.TB_FT.Text = "File Transfers"
        Me.TB_FT.UseVisualStyleBackColor = True
        '
        'LV_Transfers
        '
        Me.LV_Transfers.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader1, Me.BetterListViewColumnHeader2, Me.BetterListViewColumnHeader3, Me.BetterListViewColumnHeader4, Me.BetterListViewColumnHeader5})
        Me.LV_Transfers.Dock = System.Windows.Forms.DockStyle.Fill
        Me.LV_Transfers.ImageList = Me.IL_Transfer
        Me.LV_Transfers.Location = New System.Drawing.Point(3, 3)
        Me.LV_Transfers.Name = "LV_Transfers"
        Me.LV_Transfers.Size = New System.Drawing.Size(711, 390)
        Me.LV_Transfers.TabIndex = 0
        '
        'FileManager
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(875, 426)
        Me.Controls.Add(Me.CustomTabcontrol1)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Name = "FileManager"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "FileManager"
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.CustomTabcontrol1.ResumeLayout(False)
        Me.TP_FM.ResumeLayout(False)
        CType(Me.LV_Filemanager, System.ComponentModel.ISupportInitialize).EndInit()
        Me.CMS_Filemanager.ResumeLayout(False)
        Me.TB_FT.ResumeLayout(False)
        CType(Me.LV_Transfers, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents IL_Transfer As System.Windows.Forms.ImageList
    Friend WithEvents CustomTabcontrol1 As LuxNET.CustomTabcontrol
    Friend WithEvents TP_FM As System.Windows.Forms.TabPage
    Friend WithEvents TB_FT As System.Windows.Forms.TabPage
    Friend WithEvents ToolStripStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents ToolStripStatusLabel2 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents LV_Transfers As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents BetterListViewColumnHeader1 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader2 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader3 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader4 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader5 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents btn_showthumbnails As System.Windows.Forms.Button
    Friend WithEvents btn_forward As System.Windows.Forms.Button
    Friend WithEvents btn_refresh As System.Windows.Forms.Button
    Friend WithEvents btn_back As System.Windows.Forms.Button
    Friend WithEvents cb_path As System.Windows.Forms.ComboBox
    Friend WithEvents LV_Filemanager As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents IL_FileManager As System.Windows.Forms.ImageList
    Friend WithEvents CMS_Filemanager As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents SpecialDirectoriesToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents AppDataToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CookiesToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DesktopToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents HistoryToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents InternetCacheToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents AppDataLocalToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DocumentsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MusicToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents PicturesToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ProgramsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents StartupToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents TempToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents FolderOptionsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CreateNewFolderToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DeleteFolderToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RenameFolderToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CopyFolderToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MoveFolderToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents FileOptionsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CreateNewFileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DeleteFileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RenameFileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CopyFileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MoveFileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DownloadFileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents UploadFileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
End Class
