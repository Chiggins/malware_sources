<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SysManager
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(SysManager))
        Dim TreeNode1 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Location :")
        Dim TreeNode2 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Attributes: ")
        Dim TreeNode3 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Server Information", New System.Windows.Forms.TreeNode() {TreeNode1, TreeNode2})
        Dim TreeNode4 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Lan IP :")
        Dim TreeNode5 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Wan IP :")
        Dim TreeNode6 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("MAC Address :")
        Dim TreeNode7 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Network Information", New System.Windows.Forms.TreeNode() {TreeNode4, TreeNode5, TreeNode6})
        Dim TreeNode8 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Computer Name :")
        Dim TreeNode9 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("User Domain Name :")
        Dim TreeNode10 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("User Name :")
        Dim TreeNode11 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Monitor Count :")
        Dim TreeNode12 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Main Screen Bounds :")
        Dim TreeNode13 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Operating System :")
        Dim TreeNode14 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("OS Platform :")
        Dim TreeNode15 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("OS Version :")
        Dim TreeNode16 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("RAM :")
        Dim TreeNode17 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Battery :")
        Dim TreeNode18 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("CPU Information :")
        Dim TreeNode19 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("GPU Information :")
        Dim TreeNode20 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("UpTime :")
        Dim TreeNode21 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Computer Information", New System.Windows.Forms.TreeNode() {TreeNode8, TreeNode9, TreeNode10, TreeNode11, TreeNode12, TreeNode13, TreeNode14, TreeNode15, TreeNode16, TreeNode17, TreeNode18, TreeNode19, TreeNode20})
        Dim TreeNode22 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Registered Owner : ")
        Dim TreeNode23 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Registered Organisation")
        Dim TreeNode24 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Product Key : ")
        Dim TreeNode25 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Installed Antivirus Engine : ")
        Dim TreeNode26 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Firewall :")
        Dim TreeNode27 As System.Windows.Forms.TreeNode = New System.Windows.Forms.TreeNode("Other Information", New System.Windows.Forms.TreeNode() {TreeNode22, TreeNode23, TreeNode24, TreeNode25, TreeNode26})
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip()
        Me.ToolStripStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.IL_Information = New System.Windows.Forms.ImageList(Me.components)
        Me.BetterListViewColumnHeader1 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader2 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader3 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader4 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.CMS_Process = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.RefreshToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.KillProcessToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.CreateNewProcessToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.IL_Window = New System.Windows.Forms.ImageList(Me.components)
        Me.BetterListViewColumnHeader5 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.CMS_Software = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.RefreshToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem()
        Me.UninstallNotSilentToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.IL_Software = New System.Windows.Forms.ImageList(Me.components)
        Me.BetterListViewColumnHeader6 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader7 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader8 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader9 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.CMS_Connection = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.RefreshToolStripMenuItem2 = New System.Windows.Forms.ToolStripMenuItem()
        Me.BetterListViewColumnHeader10 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader11 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.CMS_Startup = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.RefreshToolStripMenuItem3 = New System.Windows.Forms.ToolStripMenuItem()
        Me.RemoveToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.BetterListViewColumnHeader16 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader17 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader18 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.CMS_Window = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.RefreshToolStripMenuItem6 = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripMenuItem2 = New System.Windows.Forms.ToolStripSeparator()
        Me.ChangeWindowCaptionToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripMenuItem3 = New System.Windows.Forms.ToolStripSeparator()
        Me.HideToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ShowToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripMenuItem4 = New System.Windows.Forms.ToolStripSeparator()
        Me.MinimizeToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MaximizeToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.RestoreToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.BetterListViewColumnHeader12 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader13 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader14 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader15 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.CMS_Service = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.RefreshToolStripMenuItem4 = New System.Windows.Forms.ToolStripMenuItem()
        Me.ExecuteCommandToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripMenuItem1 = New System.Windows.Forms.ToolStripSeparator()
        Me.CloseToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ContinueToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.PauseToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.RefreshToolStripMenuItem5 = New System.Windows.Forms.ToolStripMenuItem()
        Me.StartToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.StopToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.IL_Service = New System.Windows.Forms.ImageList(Me.components)
        Me.IL_SysManager = New System.Windows.Forms.ImageList(Me.components)
        Me.IL_Process = New System.Windows.Forms.ImageList(Me.components)
        Me.IL_Connection = New System.Windows.Forms.ImageList(Me.components)
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.CustomTabcontrol1 = New LuxNET.CustomTabcontrol()
        Me.TabPage1 = New System.Windows.Forms.TabPage()
        Me.TV_Information = New System.Windows.Forms.TreeView()
        Me.TabPage2 = New System.Windows.Forms.TabPage()
        Me.LV_Process = New ComponentOwl.BetterListView.BetterListView()
        Me.TabPage3 = New System.Windows.Forms.TabPage()
        Me.LV_Software = New ComponentOwl.BetterListView.BetterListView()
        Me.TabPage4 = New System.Windows.Forms.TabPage()
        Me.LV_Connection = New ComponentOwl.BetterListView.BetterListView()
        Me.TabPage5 = New System.Windows.Forms.TabPage()
        Me.LV_Startup = New ComponentOwl.BetterListView.BetterListView()
        Me.TabPage6 = New System.Windows.Forms.TabPage()
        Me.LV_Window = New ComponentOwl.BetterListView.BetterListView()
        Me.TabPage7 = New System.Windows.Forms.TabPage()
        Me.LV_Service = New ComponentOwl.BetterListView.BetterListView()
        Me.TabPage8 = New System.Windows.Forms.TabPage()
        Me.tb_cmd = New System.Windows.Forms.TextBox()
        Me.btn_stopcmd = New System.Windows.Forms.Button()
        Me.btn_startcmd = New System.Windows.Forms.Button()
        Me.rtb_cmd = New System.Windows.Forms.RichTextBox()
        Me.TabPage9 = New System.Windows.Forms.TabPage()
        Me.btn_setclipboard = New System.Windows.Forms.Button()
        Me.btn_getclipboard = New System.Windows.Forms.Button()
        Me.rtb_clipboard = New System.Windows.Forms.RichTextBox()
        Me.TabPage10 = New System.Windows.Forms.TabPage()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.btn_savehosts = New System.Windows.Forms.Button()
        Me.btn_loadhosts = New System.Windows.Forms.Button()
        Me.rtb_hostsfile = New System.Windows.Forms.RichTextBox()
        Me.StatusStrip1.SuspendLayout()
        Me.CMS_Process.SuspendLayout()
        Me.CMS_Software.SuspendLayout()
        Me.CMS_Connection.SuspendLayout()
        Me.CMS_Startup.SuspendLayout()
        Me.CMS_Window.SuspendLayout()
        Me.CMS_Service.SuspendLayout()
        Me.CustomTabcontrol1.SuspendLayout()
        Me.TabPage1.SuspendLayout()
        Me.TabPage2.SuspendLayout()
        CType(Me.LV_Process, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage3.SuspendLayout()
        CType(Me.LV_Software, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage4.SuspendLayout()
        CType(Me.LV_Connection, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage5.SuspendLayout()
        CType(Me.LV_Startup, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage6.SuspendLayout()
        CType(Me.LV_Window, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage7.SuspendLayout()
        CType(Me.LV_Service, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage8.SuspendLayout()
        Me.TabPage9.SuspendLayout()
        Me.TabPage10.SuspendLayout()
        Me.SuspendLayout()
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripStatusLabel1})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 436)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(878, 22)
        Me.StatusStrip1.TabIndex = 0
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'ToolStripStatusLabel1
        '
        Me.ToolStripStatusLabel1.Name = "ToolStripStatusLabel1"
        Me.ToolStripStatusLabel1.Size = New System.Drawing.Size(0, 17)
        '
        'IL_Information
        '
        Me.IL_Information.ImageStream = CType(resources.GetObject("IL_Information.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_Information.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_Information.Images.SetKeyName(0, "application-blue.png")
        Me.IL_Information.Images.SetKeyName(1, "btn_forward.jpg")
        Me.IL_Information.Images.SetKeyName(2, "btn_stop2.Image88.jpg")
        Me.IL_Information.Images.SetKeyName(3, "blue-document-attribute.png")
        Me.IL_Information.Images.SetKeyName(4, "address_book.png")
        Me.IL_Information.Images.SetKeyName(5, "Computer.png")
        Me.IL_Information.Images.SetKeyName(6, "user1.png")
        Me.IL_Information.Images.SetKeyName(7, "btn_start.BackgroundImage1.jpg")
        Me.IL_Information.Images.SetKeyName(8, "ManagersToolStripMenuItem.jpg")
        Me.IL_Information.Images.SetKeyName(9, "memory.png")
        Me.IL_Information.Images.SetKeyName(10, "battery_discharging_080.png")
        Me.IL_Information.Images.SetKeyName(11, "1282042718_hardware.png")
        Me.IL_Information.Images.SetKeyName(12, "cpu.png")
        Me.IL_Information.Images.SetKeyName(13, "information.png")
        Me.IL_Information.Images.SetKeyName(14, "information_shield.png")
        Me.IL_Information.Images.SetKeyName(15, "preferences_desktop_user.png")
        Me.IL_Information.Images.SetKeyName(16, "StressTesterToolStripMenuItem.jpg")
        Me.IL_Information.Images.SetKeyName(17, "key.png")
        Me.IL_Information.Images.SetKeyName(18, "folder_home.png")
        Me.IL_Information.Images.SetKeyName(19, "chart_organisation.png")
        '
        'BetterListViewColumnHeader1
        '
        Me.BetterListViewColumnHeader1.Name = "BetterListViewColumnHeader1"
        Me.BetterListViewColumnHeader1.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader1.Text = "Name"
        Me.BetterListViewColumnHeader1.Width = 333
        '
        'BetterListViewColumnHeader2
        '
        Me.BetterListViewColumnHeader2.Name = "BetterListViewColumnHeader2"
        Me.BetterListViewColumnHeader2.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader2.Text = "Memory"
        Me.BetterListViewColumnHeader2.Width = 150
        '
        'BetterListViewColumnHeader3
        '
        Me.BetterListViewColumnHeader3.Name = "BetterListViewColumnHeader3"
        Me.BetterListViewColumnHeader3.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader3.Text = "Priority"
        Me.BetterListViewColumnHeader3.Width = 134
        '
        'BetterListViewColumnHeader4
        '
        Me.BetterListViewColumnHeader4.Name = "BetterListViewColumnHeader4"
        Me.BetterListViewColumnHeader4.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader4.Text = "PID"
        Me.BetterListViewColumnHeader4.Width = 69
        '
        'CMS_Process
        '
        Me.CMS_Process.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RefreshToolStripMenuItem, Me.KillProcessToolStripMenuItem, Me.CreateNewProcessToolStripMenuItem})
        Me.CMS_Process.Name = "CMS_Process"
        Me.CMS_Process.Size = New System.Drawing.Size(179, 70)
        '
        'RefreshToolStripMenuItem
        '
        Me.RefreshToolStripMenuItem.Image = CType(resources.GetObject("RefreshToolStripMenuItem.Image"), System.Drawing.Image)
        Me.RefreshToolStripMenuItem.Name = "RefreshToolStripMenuItem"
        Me.RefreshToolStripMenuItem.Size = New System.Drawing.Size(178, 22)
        Me.RefreshToolStripMenuItem.Text = "Refresh"
        '
        'KillProcessToolStripMenuItem
        '
        Me.KillProcessToolStripMenuItem.Image = CType(resources.GetObject("KillProcessToolStripMenuItem.Image"), System.Drawing.Image)
        Me.KillProcessToolStripMenuItem.Name = "KillProcessToolStripMenuItem"
        Me.KillProcessToolStripMenuItem.Size = New System.Drawing.Size(178, 22)
        Me.KillProcessToolStripMenuItem.Text = "Kill Process"
        '
        'CreateNewProcessToolStripMenuItem
        '
        Me.CreateNewProcessToolStripMenuItem.Image = CType(resources.GetObject("CreateNewProcessToolStripMenuItem.Image"), System.Drawing.Image)
        Me.CreateNewProcessToolStripMenuItem.Name = "CreateNewProcessToolStripMenuItem"
        Me.CreateNewProcessToolStripMenuItem.Size = New System.Drawing.Size(178, 22)
        Me.CreateNewProcessToolStripMenuItem.Text = "Create New Process"
        '
        'IL_Window
        '
        Me.IL_Window.ImageStream = CType(resources.GetObject("IL_Window.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_Window.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_Window.Images.SetKeyName(0, "application-blue.png")
        Me.IL_Window.Images.SetKeyName(1, "window_list.png")
        '
        'BetterListViewColumnHeader5
        '
        Me.BetterListViewColumnHeader5.Name = "BetterListViewColumnHeader5"
        Me.BetterListViewColumnHeader5.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader5.Text = "Software Name"
        Me.BetterListViewColumnHeader5.Width = 682
        '
        'CMS_Software
        '
        Me.CMS_Software.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RefreshToolStripMenuItem1, Me.UninstallNotSilentToolStripMenuItem})
        Me.CMS_Software.Name = "CMS_Software"
        Me.CMS_Software.Size = New System.Drawing.Size(184, 48)
        '
        'RefreshToolStripMenuItem1
        '
        Me.RefreshToolStripMenuItem1.Image = CType(resources.GetObject("RefreshToolStripMenuItem1.Image"), System.Drawing.Image)
        Me.RefreshToolStripMenuItem1.Name = "RefreshToolStripMenuItem1"
        Me.RefreshToolStripMenuItem1.Size = New System.Drawing.Size(183, 22)
        Me.RefreshToolStripMenuItem1.Text = "Refresh"
        '
        'UninstallNotSilentToolStripMenuItem
        '
        Me.UninstallNotSilentToolStripMenuItem.Image = CType(resources.GetObject("UninstallNotSilentToolStripMenuItem.Image"), System.Drawing.Image)
        Me.UninstallNotSilentToolStripMenuItem.Name = "UninstallNotSilentToolStripMenuItem"
        Me.UninstallNotSilentToolStripMenuItem.Size = New System.Drawing.Size(183, 22)
        Me.UninstallNotSilentToolStripMenuItem.Text = "Uninstall (Not Silent)"
        '
        'IL_Software
        '
        Me.IL_Software.ImageStream = CType(resources.GetObject("IL_Software.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_Software.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_Software.Images.SetKeyName(0, "disc_cd_rw.png")
        '
        'BetterListViewColumnHeader6
        '
        Me.BetterListViewColumnHeader6.Name = "BetterListViewColumnHeader6"
        Me.BetterListViewColumnHeader6.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader6.Text = "Protocol"
        Me.BetterListViewColumnHeader6.Width = 69
        '
        'BetterListViewColumnHeader7
        '
        Me.BetterListViewColumnHeader7.Name = "BetterListViewColumnHeader7"
        Me.BetterListViewColumnHeader7.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader7.Text = "Local EndPoint"
        Me.BetterListViewColumnHeader7.Width = 267
        '
        'BetterListViewColumnHeader8
        '
        Me.BetterListViewColumnHeader8.Name = "BetterListViewColumnHeader8"
        Me.BetterListViewColumnHeader8.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader8.Text = "Remote EndPoint"
        Me.BetterListViewColumnHeader8.Width = 254
        '
        'BetterListViewColumnHeader9
        '
        Me.BetterListViewColumnHeader9.Name = "BetterListViewColumnHeader9"
        Me.BetterListViewColumnHeader9.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader9.Text = "State"
        Me.BetterListViewColumnHeader9.Width = 104
        '
        'CMS_Connection
        '
        Me.CMS_Connection.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RefreshToolStripMenuItem2})
        Me.CMS_Connection.Name = "CMS_Connection"
        Me.CMS_Connection.Size = New System.Drawing.Size(114, 26)
        '
        'RefreshToolStripMenuItem2
        '
        Me.RefreshToolStripMenuItem2.Image = CType(resources.GetObject("RefreshToolStripMenuItem2.Image"), System.Drawing.Image)
        Me.RefreshToolStripMenuItem2.Name = "RefreshToolStripMenuItem2"
        Me.RefreshToolStripMenuItem2.Size = New System.Drawing.Size(113, 22)
        Me.RefreshToolStripMenuItem2.Text = "Refresh"
        '
        'BetterListViewColumnHeader10
        '
        Me.BetterListViewColumnHeader10.Name = "BetterListViewColumnHeader10"
        Me.BetterListViewColumnHeader10.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader10.Text = "Name"
        Me.BetterListViewColumnHeader10.Width = 170
        '
        'BetterListViewColumnHeader11
        '
        Me.BetterListViewColumnHeader11.Name = "BetterListViewColumnHeader11"
        Me.BetterListViewColumnHeader11.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader11.Text = "Path"
        Me.BetterListViewColumnHeader11.Width = 527
        '
        'CMS_Startup
        '
        Me.CMS_Startup.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RefreshToolStripMenuItem3, Me.RemoveToolStripMenuItem})
        Me.CMS_Startup.Name = "CMS_Startup"
        Me.CMS_Startup.Size = New System.Drawing.Size(118, 48)
        '
        'RefreshToolStripMenuItem3
        '
        Me.RefreshToolStripMenuItem3.Image = CType(resources.GetObject("RefreshToolStripMenuItem3.Image"), System.Drawing.Image)
        Me.RefreshToolStripMenuItem3.Name = "RefreshToolStripMenuItem3"
        Me.RefreshToolStripMenuItem3.Size = New System.Drawing.Size(117, 22)
        Me.RefreshToolStripMenuItem3.Text = "Refresh"
        '
        'RemoveToolStripMenuItem
        '
        Me.RemoveToolStripMenuItem.Image = CType(resources.GetObject("RemoveToolStripMenuItem.Image"), System.Drawing.Image)
        Me.RemoveToolStripMenuItem.Name = "RemoveToolStripMenuItem"
        Me.RemoveToolStripMenuItem.Size = New System.Drawing.Size(117, 22)
        Me.RemoveToolStripMenuItem.Text = "Remove"
        '
        'BetterListViewColumnHeader16
        '
        Me.BetterListViewColumnHeader16.Name = "BetterListViewColumnHeader16"
        Me.BetterListViewColumnHeader16.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader16.Text = "Window Caption"
        Me.BetterListViewColumnHeader16.Width = 445
        '
        'BetterListViewColumnHeader17
        '
        Me.BetterListViewColumnHeader17.Name = "BetterListViewColumnHeader17"
        Me.BetterListViewColumnHeader17.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader17.Text = "Handle (hWnd)"
        Me.BetterListViewColumnHeader17.Width = 144
        '
        'BetterListViewColumnHeader18
        '
        Me.BetterListViewColumnHeader18.Name = "BetterListViewColumnHeader18"
        Me.BetterListViewColumnHeader18.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader18.Text = "Visible"
        Me.BetterListViewColumnHeader18.Width = 98
        '
        'CMS_Window
        '
        Me.CMS_Window.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RefreshToolStripMenuItem6, Me.ToolStripMenuItem2, Me.ChangeWindowCaptionToolStripMenuItem, Me.ToolStripMenuItem3, Me.HideToolStripMenuItem, Me.ShowToolStripMenuItem, Me.ToolStripMenuItem4, Me.MinimizeToolStripMenuItem, Me.MaximizeToolStripMenuItem, Me.RestoreToolStripMenuItem})
        Me.CMS_Window.Name = "CMS_Window"
        Me.CMS_Window.Size = New System.Drawing.Size(208, 176)
        '
        'RefreshToolStripMenuItem6
        '
        Me.RefreshToolStripMenuItem6.Image = CType(resources.GetObject("RefreshToolStripMenuItem6.Image"), System.Drawing.Image)
        Me.RefreshToolStripMenuItem6.Name = "RefreshToolStripMenuItem6"
        Me.RefreshToolStripMenuItem6.Size = New System.Drawing.Size(207, 22)
        Me.RefreshToolStripMenuItem6.Text = "Refresh"
        '
        'ToolStripMenuItem2
        '
        Me.ToolStripMenuItem2.Name = "ToolStripMenuItem2"
        Me.ToolStripMenuItem2.Size = New System.Drawing.Size(204, 6)
        '
        'ChangeWindowCaptionToolStripMenuItem
        '
        Me.ChangeWindowCaptionToolStripMenuItem.Image = CType(resources.GetObject("ChangeWindowCaptionToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ChangeWindowCaptionToolStripMenuItem.Name = "ChangeWindowCaptionToolStripMenuItem"
        Me.ChangeWindowCaptionToolStripMenuItem.Size = New System.Drawing.Size(207, 22)
        Me.ChangeWindowCaptionToolStripMenuItem.Text = "Change Window Caption"
        '
        'ToolStripMenuItem3
        '
        Me.ToolStripMenuItem3.Name = "ToolStripMenuItem3"
        Me.ToolStripMenuItem3.Size = New System.Drawing.Size(204, 6)
        '
        'HideToolStripMenuItem
        '
        Me.HideToolStripMenuItem.Image = CType(resources.GetObject("HideToolStripMenuItem.Image"), System.Drawing.Image)
        Me.HideToolStripMenuItem.Name = "HideToolStripMenuItem"
        Me.HideToolStripMenuItem.Size = New System.Drawing.Size(207, 22)
        Me.HideToolStripMenuItem.Text = "Hide"
        '
        'ShowToolStripMenuItem
        '
        Me.ShowToolStripMenuItem.Image = CType(resources.GetObject("ShowToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ShowToolStripMenuItem.Name = "ShowToolStripMenuItem"
        Me.ShowToolStripMenuItem.Size = New System.Drawing.Size(207, 22)
        Me.ShowToolStripMenuItem.Text = "Show"
        '
        'ToolStripMenuItem4
        '
        Me.ToolStripMenuItem4.Name = "ToolStripMenuItem4"
        Me.ToolStripMenuItem4.Size = New System.Drawing.Size(204, 6)
        '
        'MinimizeToolStripMenuItem
        '
        Me.MinimizeToolStripMenuItem.Image = CType(resources.GetObject("MinimizeToolStripMenuItem.Image"), System.Drawing.Image)
        Me.MinimizeToolStripMenuItem.Name = "MinimizeToolStripMenuItem"
        Me.MinimizeToolStripMenuItem.Size = New System.Drawing.Size(207, 22)
        Me.MinimizeToolStripMenuItem.Text = "Minimize"
        '
        'MaximizeToolStripMenuItem
        '
        Me.MaximizeToolStripMenuItem.Image = CType(resources.GetObject("MaximizeToolStripMenuItem.Image"), System.Drawing.Image)
        Me.MaximizeToolStripMenuItem.Name = "MaximizeToolStripMenuItem"
        Me.MaximizeToolStripMenuItem.Size = New System.Drawing.Size(207, 22)
        Me.MaximizeToolStripMenuItem.Text = "Maximize"
        '
        'RestoreToolStripMenuItem
        '
        Me.RestoreToolStripMenuItem.Image = CType(resources.GetObject("RestoreToolStripMenuItem.Image"), System.Drawing.Image)
        Me.RestoreToolStripMenuItem.Name = "RestoreToolStripMenuItem"
        Me.RestoreToolStripMenuItem.Size = New System.Drawing.Size(207, 22)
        Me.RestoreToolStripMenuItem.Text = "Restore"
        '
        'BetterListViewColumnHeader12
        '
        Me.BetterListViewColumnHeader12.Name = "BetterListViewColumnHeader12"
        Me.BetterListViewColumnHeader12.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader12.Text = "ServiceName"
        Me.BetterListViewColumnHeader12.Width = 215
        '
        'BetterListViewColumnHeader13
        '
        Me.BetterListViewColumnHeader13.Name = "BetterListViewColumnHeader13"
        Me.BetterListViewColumnHeader13.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader13.Text = "DisplayName"
        Me.BetterListViewColumnHeader13.Width = 247
        '
        'BetterListViewColumnHeader14
        '
        Me.BetterListViewColumnHeader14.Name = "BetterListViewColumnHeader14"
        Me.BetterListViewColumnHeader14.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader14.Text = "ServiceType"
        Me.BetterListViewColumnHeader14.Width = 142
        '
        'BetterListViewColumnHeader15
        '
        Me.BetterListViewColumnHeader15.Name = "BetterListViewColumnHeader15"
        Me.BetterListViewColumnHeader15.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader15.Text = "Status"
        Me.BetterListViewColumnHeader15.Width = 89
        '
        'CMS_Service
        '
        Me.CMS_Service.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RefreshToolStripMenuItem4, Me.ExecuteCommandToolStripMenuItem, Me.ToolStripMenuItem1, Me.CloseToolStripMenuItem, Me.ContinueToolStripMenuItem, Me.PauseToolStripMenuItem, Me.RefreshToolStripMenuItem5, Me.StartToolStripMenuItem, Me.StopToolStripMenuItem})
        Me.CMS_Service.Name = "CMS_Service"
        Me.CMS_Service.Size = New System.Drawing.Size(175, 186)
        '
        'RefreshToolStripMenuItem4
        '
        Me.RefreshToolStripMenuItem4.Image = CType(resources.GetObject("RefreshToolStripMenuItem4.Image"), System.Drawing.Image)
        Me.RefreshToolStripMenuItem4.Name = "RefreshToolStripMenuItem4"
        Me.RefreshToolStripMenuItem4.Size = New System.Drawing.Size(174, 22)
        Me.RefreshToolStripMenuItem4.Text = "Refresh"
        '
        'ExecuteCommandToolStripMenuItem
        '
        Me.ExecuteCommandToolStripMenuItem.Image = CType(resources.GetObject("ExecuteCommandToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ExecuteCommandToolStripMenuItem.Name = "ExecuteCommandToolStripMenuItem"
        Me.ExecuteCommandToolStripMenuItem.Size = New System.Drawing.Size(174, 22)
        Me.ExecuteCommandToolStripMenuItem.Text = "Execute Command"
        '
        'ToolStripMenuItem1
        '
        Me.ToolStripMenuItem1.Name = "ToolStripMenuItem1"
        Me.ToolStripMenuItem1.Size = New System.Drawing.Size(171, 6)
        '
        'CloseToolStripMenuItem
        '
        Me.CloseToolStripMenuItem.Image = CType(resources.GetObject("CloseToolStripMenuItem.Image"), System.Drawing.Image)
        Me.CloseToolStripMenuItem.Name = "CloseToolStripMenuItem"
        Me.CloseToolStripMenuItem.Size = New System.Drawing.Size(174, 22)
        Me.CloseToolStripMenuItem.Text = "Close"
        '
        'ContinueToolStripMenuItem
        '
        Me.ContinueToolStripMenuItem.Image = CType(resources.GetObject("ContinueToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ContinueToolStripMenuItem.Name = "ContinueToolStripMenuItem"
        Me.ContinueToolStripMenuItem.Size = New System.Drawing.Size(174, 22)
        Me.ContinueToolStripMenuItem.Text = "Continue"
        '
        'PauseToolStripMenuItem
        '
        Me.PauseToolStripMenuItem.Image = CType(resources.GetObject("PauseToolStripMenuItem.Image"), System.Drawing.Image)
        Me.PauseToolStripMenuItem.Name = "PauseToolStripMenuItem"
        Me.PauseToolStripMenuItem.Size = New System.Drawing.Size(174, 22)
        Me.PauseToolStripMenuItem.Text = "Pause"
        '
        'RefreshToolStripMenuItem5
        '
        Me.RefreshToolStripMenuItem5.Image = CType(resources.GetObject("RefreshToolStripMenuItem5.Image"), System.Drawing.Image)
        Me.RefreshToolStripMenuItem5.Name = "RefreshToolStripMenuItem5"
        Me.RefreshToolStripMenuItem5.Size = New System.Drawing.Size(174, 22)
        Me.RefreshToolStripMenuItem5.Text = "Refresh"
        '
        'StartToolStripMenuItem
        '
        Me.StartToolStripMenuItem.Image = CType(resources.GetObject("StartToolStripMenuItem.Image"), System.Drawing.Image)
        Me.StartToolStripMenuItem.Name = "StartToolStripMenuItem"
        Me.StartToolStripMenuItem.Size = New System.Drawing.Size(174, 22)
        Me.StartToolStripMenuItem.Text = "Start"
        '
        'StopToolStripMenuItem
        '
        Me.StopToolStripMenuItem.Image = CType(resources.GetObject("StopToolStripMenuItem.Image"), System.Drawing.Image)
        Me.StopToolStripMenuItem.Name = "StopToolStripMenuItem"
        Me.StopToolStripMenuItem.Size = New System.Drawing.Size(174, 22)
        Me.StopToolStripMenuItem.Text = "Stop"
        '
        'IL_Service
        '
        Me.IL_Service.ImageStream = CType(resources.GetObject("IL_Service.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_Service.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_Service.Images.SetKeyName(0, "application_x_desktop.png")
        '
        'IL_SysManager
        '
        Me.IL_SysManager.ImageStream = CType(resources.GetObject("IL_SysManager.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_SysManager.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_SysManager.Images.SetKeyName(0, "information.png")
        Me.IL_SysManager.Images.SetKeyName(1, "blue.png")
        Me.IL_SysManager.Images.SetKeyName(2, "system_software_update.png")
        Me.IL_SysManager.Images.SetKeyName(3, "network_connections.png")
        Me.IL_SysManager.Images.SetKeyName(4, "startup_wizard.png")
        Me.IL_SysManager.Images.SetKeyName(5, "icone_windows.png")
        Me.IL_SysManager.Images.SetKeyName(6, "network_service.png")
        Me.IL_SysManager.Images.SetKeyName(7, "cmd.png")
        Me.IL_SysManager.Images.SetKeyName(8, "clipboard.png")
        Me.IL_SysManager.Images.SetKeyName(9, "document_edit.png")
        '
        'IL_Process
        '
        Me.IL_Process.ImageStream = CType(resources.GetObject("IL_Process.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_Process.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_Process.Images.SetKeyName(0, "ManagersToolStripMenuItem.jpg")
        '
        'IL_Connection
        '
        Me.IL_Connection.ImageStream = CType(resources.GetObject("IL_Connection.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_Connection.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_Connection.Images.SetKeyName(0, "btn_startsl.Image1.jpg")
        '
        'Timer1
        '
        Me.Timer1.Interval = 47
        '
        'CustomTabcontrol1
        '
        Me.CustomTabcontrol1.Alignment = System.Windows.Forms.TabAlignment.Left
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage1)
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage2)
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage3)
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage4)
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage5)
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage6)
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage7)
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage8)
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage9)
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage10)
        Me.CustomTabcontrol1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.CustomTabcontrol1.DrawMode = System.Windows.Forms.TabDrawMode.OwnerDrawFixed
        Me.CustomTabcontrol1.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.CustomTabcontrol1.ImageList = Me.IL_SysManager
        Me.CustomTabcontrol1.ItemSize = New System.Drawing.Size(40, 150)
        Me.CustomTabcontrol1.Location = New System.Drawing.Point(0, 0)
        Me.CustomTabcontrol1.Multiline = True
        Me.CustomTabcontrol1.Name = "CustomTabcontrol1"
        Me.CustomTabcontrol1.SelectedIndex = 0
        Me.CustomTabcontrol1.SelectedItemColor = System.Drawing.Color.FromArgb(CType(CType(30, Byte), Integer), CType(CType(10, Byte), Integer), CType(CType(100, Byte), Integer), CType(CType(200, Byte), Integer))
        Me.CustomTabcontrol1.Size = New System.Drawing.Size(878, 436)
        Me.CustomTabcontrol1.SizeMode = System.Windows.Forms.TabSizeMode.Fixed
        Me.CustomTabcontrol1.TabIndex = 1
        '
        'TabPage1
        '
        Me.TabPage1.Controls.Add(Me.TV_Information)
        Me.TabPage1.Location = New System.Drawing.Point(154, 4)
        Me.TabPage1.Name = "TabPage1"
        Me.TabPage1.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage1.Size = New System.Drawing.Size(720, 428)
        Me.TabPage1.TabIndex = 0
        Me.TabPage1.Text = "Information"
        Me.TabPage1.UseVisualStyleBackColor = True
        '
        'TV_Information
        '
        Me.TV_Information.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TV_Information.ImageKey = "application-blue.png"
        Me.TV_Information.ImageList = Me.IL_Information
        Me.TV_Information.Location = New System.Drawing.Point(3, 3)
        Me.TV_Information.Name = "TV_Information"
        TreeNode1.ImageKey = "btn_forward.jpg"
        TreeNode1.Name = "Knoten1"
        TreeNode1.Text = "Location :"
        TreeNode2.ImageKey = "blue-document-attribute.png"
        TreeNode2.Name = "Knoten2"
        TreeNode2.Text = "Attributes: "
        TreeNode3.ImageKey = "application-blue.png"
        TreeNode3.Name = "nodpr"
        TreeNode3.Text = "Server Information"
        TreeNode4.ImageKey = "btn_stop2.Image88.jpg"
        TreeNode4.Name = "Knoten4"
        TreeNode4.Text = "Lan IP :"
        TreeNode5.ImageKey = "btn_stop2.Image88.jpg"
        TreeNode5.Name = "Knoten5"
        TreeNode5.Text = "Wan IP :"
        TreeNode6.ImageKey = "address_book.png"
        TreeNode6.Name = "Knoten6"
        TreeNode6.Text = "MAC Address :"
        TreeNode7.ImageKey = "btn_stop2.Image88.jpg"
        TreeNode7.Name = "Node8"
        TreeNode7.Text = "Network Information"
        TreeNode8.ImageKey = "Computer.png"
        TreeNode8.Name = "Knoten8"
        TreeNode8.Text = "Computer Name :"
        TreeNode9.ImageKey = "Computer.png"
        TreeNode9.Name = "Knoten10"
        TreeNode9.Text = "User Domain Name :"
        TreeNode10.ImageKey = "user1.png"
        TreeNode10.Name = "Knoten11"
        TreeNode10.Text = "User Name :"
        TreeNode11.ImageKey = "btn_start.BackgroundImage1.jpg"
        TreeNode11.Name = "Knoten12"
        TreeNode11.Text = "Monitor Count :"
        TreeNode12.ImageKey = "btn_start.BackgroundImage1.jpg"
        TreeNode12.Name = "Knoten13"
        TreeNode12.Text = "Main Screen Bounds :"
        TreeNode13.ImageKey = "ManagersToolStripMenuItem.jpg"
        TreeNode13.Name = "Knoten15"
        TreeNode13.Text = "Operating System :"
        TreeNode14.ImageKey = "ManagersToolStripMenuItem.jpg"
        TreeNode14.Name = "Knoten16"
        TreeNode14.Text = "OS Platform :"
        TreeNode15.ImageKey = "ManagersToolStripMenuItem.jpg"
        TreeNode15.Name = "Knoten17"
        TreeNode15.Text = "OS Version :"
        TreeNode16.ImageKey = "memory.png"
        TreeNode16.Name = "Knoten18"
        TreeNode16.Text = "RAM :"
        TreeNode17.ImageKey = "battery_discharging_080.png"
        TreeNode17.Name = "Knoten19"
        TreeNode17.Text = "Battery :"
        TreeNode18.ImageKey = "cpu.png"
        TreeNode18.Name = "Knoten21"
        TreeNode18.Text = "CPU Information :"
        TreeNode19.ImageKey = "1282042718_hardware.png"
        TreeNode19.Name = "Knoten22"
        TreeNode19.Text = "GPU Information :"
        TreeNode20.ImageKey = "information.png"
        TreeNode20.Name = "Knoten23"
        TreeNode20.Text = "UpTime :"
        TreeNode21.ImageKey = "Computer.png"
        TreeNode21.Name = "Node12"
        TreeNode21.Text = "Computer Information"
        TreeNode22.ImageKey = "preferences_desktop_user.png"
        TreeNode22.Name = "Knoten25"
        TreeNode22.Text = "Registered Owner : "
        TreeNode23.ImageKey = "chart_organisation.png"
        TreeNode23.Name = "Node2"
        TreeNode23.Text = "Registered Organisation"
        TreeNode24.ImageKey = "key.png"
        TreeNode24.Name = "Knoten27"
        TreeNode24.Text = "Product Key : "
        TreeNode25.ImageKey = "folder_home.png"
        TreeNode25.Name = "Knoten28"
        TreeNode25.Text = "Installed Antivirus Engine : "
        TreeNode26.ImageKey = "StressTesterToolStripMenuItem.jpg"
        TreeNode26.Name = "Knoten0"
        TreeNode26.Text = "Firewall :"
        TreeNode27.ImageKey = "information_shield.png"
        TreeNode27.Name = "Node26"
        TreeNode27.Text = "Other Information"
        Me.TV_Information.Nodes.AddRange(New System.Windows.Forms.TreeNode() {TreeNode3, TreeNode7, TreeNode21, TreeNode27})
        Me.TV_Information.SelectedImageIndex = 0
        Me.TV_Information.Size = New System.Drawing.Size(714, 422)
        Me.TV_Information.TabIndex = 0
        '
        'TabPage2
        '
        Me.TabPage2.Controls.Add(Me.LV_Process)
        Me.TabPage2.Location = New System.Drawing.Point(154, 4)
        Me.TabPage2.Name = "TabPage2"
        Me.TabPage2.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage2.Size = New System.Drawing.Size(720, 428)
        Me.TabPage2.TabIndex = 1
        Me.TabPage2.Text = "Process"
        Me.TabPage2.UseVisualStyleBackColor = True
        '
        'LV_Process
        '
        Me.LV_Process.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader1, Me.BetterListViewColumnHeader2, Me.BetterListViewColumnHeader3, Me.BetterListViewColumnHeader4})
        Me.LV_Process.ContextMenuStrip = Me.CMS_Process
        Me.LV_Process.Dock = System.Windows.Forms.DockStyle.Fill
        Me.LV_Process.ImageList = Me.IL_Process
        Me.LV_Process.Location = New System.Drawing.Point(3, 3)
        Me.LV_Process.Name = "LV_Process"
        Me.LV_Process.Size = New System.Drawing.Size(714, 422)
        Me.LV_Process.TabIndex = 0
        '
        'TabPage3
        '
        Me.TabPage3.Controls.Add(Me.LV_Software)
        Me.TabPage3.Location = New System.Drawing.Point(154, 4)
        Me.TabPage3.Name = "TabPage3"
        Me.TabPage3.Size = New System.Drawing.Size(720, 428)
        Me.TabPage3.TabIndex = 2
        Me.TabPage3.Text = "Software"
        Me.TabPage3.UseVisualStyleBackColor = True
        '
        'LV_Software
        '
        Me.LV_Software.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader5})
        Me.LV_Software.ContextMenuStrip = Me.CMS_Software
        Me.LV_Software.Dock = System.Windows.Forms.DockStyle.Fill
        Me.LV_Software.ImageList = Me.IL_Software
        Me.LV_Software.Location = New System.Drawing.Point(0, 0)
        Me.LV_Software.Name = "LV_Software"
        Me.LV_Software.Size = New System.Drawing.Size(720, 428)
        Me.LV_Software.TabIndex = 0
        '
        'TabPage4
        '
        Me.TabPage4.Controls.Add(Me.LV_Connection)
        Me.TabPage4.Location = New System.Drawing.Point(154, 4)
        Me.TabPage4.Name = "TabPage4"
        Me.TabPage4.Size = New System.Drawing.Size(720, 428)
        Me.TabPage4.TabIndex = 3
        Me.TabPage4.Text = "Connection"
        Me.TabPage4.UseVisualStyleBackColor = True
        '
        'LV_Connection
        '
        Me.LV_Connection.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader6, Me.BetterListViewColumnHeader7, Me.BetterListViewColumnHeader8, Me.BetterListViewColumnHeader9})
        Me.LV_Connection.ContextMenuStrip = Me.CMS_Connection
        Me.LV_Connection.Dock = System.Windows.Forms.DockStyle.Fill
        Me.LV_Connection.ImageList = Me.IL_Connection
        Me.LV_Connection.Location = New System.Drawing.Point(0, 0)
        Me.LV_Connection.Name = "LV_Connection"
        Me.LV_Connection.Size = New System.Drawing.Size(720, 428)
        Me.LV_Connection.TabIndex = 0
        '
        'TabPage5
        '
        Me.TabPage5.Controls.Add(Me.LV_Startup)
        Me.TabPage5.Location = New System.Drawing.Point(154, 4)
        Me.TabPage5.Name = "TabPage5"
        Me.TabPage5.Size = New System.Drawing.Size(720, 428)
        Me.TabPage5.TabIndex = 4
        Me.TabPage5.Text = "Starup"
        Me.TabPage5.UseVisualStyleBackColor = True
        '
        'LV_Startup
        '
        Me.LV_Startup.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader10, Me.BetterListViewColumnHeader11})
        Me.LV_Startup.ContextMenuStrip = Me.CMS_Startup
        Me.LV_Startup.Dock = System.Windows.Forms.DockStyle.Fill
        Me.LV_Startup.Location = New System.Drawing.Point(0, 0)
        Me.LV_Startup.Name = "LV_Startup"
        Me.LV_Startup.Size = New System.Drawing.Size(720, 428)
        Me.LV_Startup.TabIndex = 0
        '
        'TabPage6
        '
        Me.TabPage6.Controls.Add(Me.LV_Window)
        Me.TabPage6.Location = New System.Drawing.Point(154, 4)
        Me.TabPage6.Name = "TabPage6"
        Me.TabPage6.Size = New System.Drawing.Size(720, 428)
        Me.TabPage6.TabIndex = 5
        Me.TabPage6.Text = "Window"
        Me.TabPage6.UseVisualStyleBackColor = True
        '
        'LV_Window
        '
        Me.LV_Window.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader16, Me.BetterListViewColumnHeader17, Me.BetterListViewColumnHeader18})
        Me.LV_Window.ContextMenuStrip = Me.CMS_Window
        Me.LV_Window.Dock = System.Windows.Forms.DockStyle.Fill
        Me.LV_Window.ImageList = Me.IL_Window
        Me.LV_Window.Location = New System.Drawing.Point(0, 0)
        Me.LV_Window.Name = "LV_Window"
        Me.LV_Window.Size = New System.Drawing.Size(720, 428)
        Me.LV_Window.TabIndex = 0
        '
        'TabPage7
        '
        Me.TabPage7.Controls.Add(Me.LV_Service)
        Me.TabPage7.Location = New System.Drawing.Point(154, 4)
        Me.TabPage7.Name = "TabPage7"
        Me.TabPage7.Size = New System.Drawing.Size(720, 428)
        Me.TabPage7.TabIndex = 6
        Me.TabPage7.Text = "Service"
        Me.TabPage7.UseVisualStyleBackColor = True
        '
        'LV_Service
        '
        Me.LV_Service.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader12, Me.BetterListViewColumnHeader13, Me.BetterListViewColumnHeader14, Me.BetterListViewColumnHeader15})
        Me.LV_Service.ContextMenuStrip = Me.CMS_Service
        Me.LV_Service.Dock = System.Windows.Forms.DockStyle.Fill
        Me.LV_Service.ImageList = Me.IL_Service
        Me.LV_Service.Location = New System.Drawing.Point(0, 0)
        Me.LV_Service.Name = "LV_Service"
        Me.LV_Service.Size = New System.Drawing.Size(720, 428)
        Me.LV_Service.TabIndex = 0
        '
        'TabPage8
        '
        Me.TabPage8.Controls.Add(Me.tb_cmd)
        Me.TabPage8.Controls.Add(Me.btn_stopcmd)
        Me.TabPage8.Controls.Add(Me.btn_startcmd)
        Me.TabPage8.Controls.Add(Me.rtb_cmd)
        Me.TabPage8.Location = New System.Drawing.Point(154, 4)
        Me.TabPage8.Name = "TabPage8"
        Me.TabPage8.Size = New System.Drawing.Size(720, 428)
        Me.TabPage8.TabIndex = 7
        Me.TabPage8.Text = "Command"
        Me.TabPage8.UseVisualStyleBackColor = True
        '
        'tb_cmd
        '
        Me.tb_cmd.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tb_cmd.Location = New System.Drawing.Point(92, 395)
        Me.tb_cmd.Name = "tb_cmd"
        Me.tb_cmd.Size = New System.Drawing.Size(620, 25)
        Me.tb_cmd.TabIndex = 3
        '
        'btn_stopcmd
        '
        Me.btn_stopcmd.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btn_stopcmd.Image = CType(resources.GetObject("btn_stopcmd.Image"), System.Drawing.Image)
        Me.btn_stopcmd.Location = New System.Drawing.Point(50, 394)
        Me.btn_stopcmd.Name = "btn_stopcmd"
        Me.btn_stopcmd.Size = New System.Drawing.Size(36, 26)
        Me.btn_stopcmd.TabIndex = 2
        Me.btn_stopcmd.UseVisualStyleBackColor = True
        '
        'btn_startcmd
        '
        Me.btn_startcmd.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btn_startcmd.Image = CType(resources.GetObject("btn_startcmd.Image"), System.Drawing.Image)
        Me.btn_startcmd.Location = New System.Drawing.Point(8, 394)
        Me.btn_startcmd.Name = "btn_startcmd"
        Me.btn_startcmd.Size = New System.Drawing.Size(36, 26)
        Me.btn_startcmd.TabIndex = 1
        Me.btn_startcmd.UseVisualStyleBackColor = True
        '
        'rtb_cmd
        '
        Me.rtb_cmd.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.rtb_cmd.BackColor = System.Drawing.SystemColors.InfoText
        Me.rtb_cmd.ForeColor = System.Drawing.SystemColors.Info
        Me.rtb_cmd.Location = New System.Drawing.Point(8, 3)
        Me.rtb_cmd.Name = "rtb_cmd"
        Me.rtb_cmd.Size = New System.Drawing.Size(704, 389)
        Me.rtb_cmd.TabIndex = 0
        Me.rtb_cmd.Text = ""
        '
        'TabPage9
        '
        Me.TabPage9.Controls.Add(Me.btn_setclipboard)
        Me.TabPage9.Controls.Add(Me.btn_getclipboard)
        Me.TabPage9.Controls.Add(Me.rtb_clipboard)
        Me.TabPage9.Location = New System.Drawing.Point(154, 4)
        Me.TabPage9.Name = "TabPage9"
        Me.TabPage9.Size = New System.Drawing.Size(720, 428)
        Me.TabPage9.TabIndex = 8
        Me.TabPage9.Text = "ClipBoard"
        Me.TabPage9.UseVisualStyleBackColor = True
        '
        'btn_setclipboard
        '
        Me.btn_setclipboard.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btn_setclipboard.Image = CType(resources.GetObject("btn_setclipboard.Image"), System.Drawing.Image)
        Me.btn_setclipboard.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_setclipboard.Location = New System.Drawing.Point(181, 388)
        Me.btn_setclipboard.Name = "btn_setclipboard"
        Me.btn_setclipboard.Size = New System.Drawing.Size(170, 32)
        Me.btn_setclipboard.TabIndex = 2
        Me.btn_setclipboard.Text = "Set Clipboard Text"
        Me.btn_setclipboard.UseVisualStyleBackColor = True
        '
        'btn_getclipboard
        '
        Me.btn_getclipboard.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btn_getclipboard.Image = CType(resources.GetObject("btn_getclipboard.Image"), System.Drawing.Image)
        Me.btn_getclipboard.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_getclipboard.Location = New System.Drawing.Point(5, 388)
        Me.btn_getclipboard.Name = "btn_getclipboard"
        Me.btn_getclipboard.Size = New System.Drawing.Size(170, 32)
        Me.btn_getclipboard.TabIndex = 1
        Me.btn_getclipboard.Text = "Get Clipboard Text"
        Me.btn_getclipboard.UseVisualStyleBackColor = True
        '
        'rtb_clipboard
        '
        Me.rtb_clipboard.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.rtb_clipboard.Location = New System.Drawing.Point(5, 4)
        Me.rtb_clipboard.Name = "rtb_clipboard"
        Me.rtb_clipboard.Size = New System.Drawing.Size(708, 381)
        Me.rtb_clipboard.TabIndex = 0
        Me.rtb_clipboard.Text = ""
        '
        'TabPage10
        '
        Me.TabPage10.Controls.Add(Me.Label1)
        Me.TabPage10.Controls.Add(Me.btn_savehosts)
        Me.TabPage10.Controls.Add(Me.btn_loadhosts)
        Me.TabPage10.Controls.Add(Me.rtb_hostsfile)
        Me.TabPage10.Location = New System.Drawing.Point(154, 4)
        Me.TabPage10.Name = "TabPage10"
        Me.TabPage10.Size = New System.Drawing.Size(720, 428)
        Me.TabPage10.TabIndex = 9
        Me.TabPage10.Text = "Host Editor"
        Me.TabPage10.UseVisualStyleBackColor = True
        '
        'Label1
        '
        Me.Label1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(5, 397)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(281, 19)
        Me.Label1.TabIndex = 3
        Me.Label1.Text = "This works only with administrative privilegs!"
        '
        'btn_savehosts
        '
        Me.btn_savehosts.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btn_savehosts.Image = CType(resources.GetObject("btn_savehosts.Image"), System.Drawing.Image)
        Me.btn_savehosts.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_savehosts.Location = New System.Drawing.Point(622, 394)
        Me.btn_savehosts.Name = "btn_savehosts"
        Me.btn_savehosts.Size = New System.Drawing.Size(90, 27)
        Me.btn_savehosts.TabIndex = 2
        Me.btn_savehosts.Text = "Save File"
        Me.btn_savehosts.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.btn_savehosts.UseVisualStyleBackColor = True
        '
        'btn_loadhosts
        '
        Me.btn_loadhosts.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btn_loadhosts.Image = CType(resources.GetObject("btn_loadhosts.Image"), System.Drawing.Image)
        Me.btn_loadhosts.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_loadhosts.Location = New System.Drawing.Point(528, 394)
        Me.btn_loadhosts.Name = "btn_loadhosts"
        Me.btn_loadhosts.Size = New System.Drawing.Size(90, 27)
        Me.btn_loadhosts.TabIndex = 1
        Me.btn_loadhosts.Text = "Load File"
        Me.btn_loadhosts.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.btn_loadhosts.UseVisualStyleBackColor = True
        '
        'rtb_hostsfile
        '
        Me.rtb_hostsfile.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.rtb_hostsfile.Location = New System.Drawing.Point(6, 8)
        Me.rtb_hostsfile.Name = "rtb_hostsfile"
        Me.rtb_hostsfile.Size = New System.Drawing.Size(706, 382)
        Me.rtb_hostsfile.TabIndex = 0
        Me.rtb_hostsfile.Text = ""
        '
        'SysManager
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(878, 458)
        Me.Controls.Add(Me.CustomTabcontrol1)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MinimumSize = New System.Drawing.Size(878, 497)
        Me.Name = "SysManager"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "SysManager"
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.CMS_Process.ResumeLayout(False)
        Me.CMS_Software.ResumeLayout(False)
        Me.CMS_Connection.ResumeLayout(False)
        Me.CMS_Startup.ResumeLayout(False)
        Me.CMS_Window.ResumeLayout(False)
        Me.CMS_Service.ResumeLayout(False)
        Me.CustomTabcontrol1.ResumeLayout(False)
        Me.TabPage1.ResumeLayout(False)
        Me.TabPage2.ResumeLayout(False)
        CType(Me.LV_Process, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage3.ResumeLayout(False)
        CType(Me.LV_Software, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage4.ResumeLayout(False)
        CType(Me.LV_Connection, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage5.ResumeLayout(False)
        CType(Me.LV_Startup, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage6.ResumeLayout(False)
        CType(Me.LV_Window, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage7.ResumeLayout(False)
        CType(Me.LV_Service, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage8.ResumeLayout(False)
        Me.TabPage8.PerformLayout()
        Me.TabPage9.ResumeLayout(False)
        Me.TabPage10.ResumeLayout(False)
        Me.TabPage10.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents TabPage1 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage2 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage3 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage4 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage5 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage6 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage7 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage8 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage9 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage10 As System.Windows.Forms.TabPage
    Friend WithEvents ToolStripStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents LV_Process As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents BetterListViewColumnHeader1 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader2 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader3 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader4 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents IL_SysManager As System.Windows.Forms.ImageList
    Friend WithEvents IL_Information As System.Windows.Forms.ImageList
    Friend WithEvents IL_Process As System.Windows.Forms.ImageList
    Friend WithEvents CMS_Process As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents RefreshToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents KillProcessToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CreateNewProcessToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents LV_Software As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents BetterListViewColumnHeader5 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents CMS_Software As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents RefreshToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents UninstallNotSilentToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents IL_Software As System.Windows.Forms.ImageList
    Friend WithEvents LV_Connection As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents BetterListViewColumnHeader6 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader7 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader8 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader9 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents CMS_Connection As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents RefreshToolStripMenuItem2 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents LV_Startup As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents BetterListViewColumnHeader10 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader11 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents CMS_Startup As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents RefreshToolStripMenuItem3 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RemoveToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents LV_Service As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents BetterListViewColumnHeader12 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader13 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader14 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader15 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents CMS_Service As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents RefreshToolStripMenuItem4 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExecuteCommandToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents CloseToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ContinueToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents PauseToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RefreshToolStripMenuItem5 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents StartToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents StopToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents LV_Window As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents BetterListViewColumnHeader16 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader17 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader18 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents IL_Service As System.Windows.Forms.ImageList
    Friend WithEvents IL_Window As System.Windows.Forms.ImageList
    Friend WithEvents CMS_Window As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents RefreshToolStripMenuItem6 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ChangeWindowCaptionToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem3 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents HideToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ShowToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem4 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents MinimizeToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MaximizeToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RestoreToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents TV_Information As System.Windows.Forms.TreeView
    Friend WithEvents rtb_cmd As System.Windows.Forms.RichTextBox
    Friend WithEvents tb_cmd As System.Windows.Forms.TextBox
    Friend WithEvents btn_stopcmd As System.Windows.Forms.Button
    Friend WithEvents btn_startcmd As System.Windows.Forms.Button
    Friend WithEvents rtb_clipboard As System.Windows.Forms.RichTextBox
    Friend WithEvents btn_setclipboard As System.Windows.Forms.Button
    Friend WithEvents btn_getclipboard As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents btn_savehosts As System.Windows.Forms.Button
    Friend WithEvents btn_loadhosts As System.Windows.Forms.Button
    Friend WithEvents rtb_hostsfile As System.Windows.Forms.RichTextBox
    Friend WithEvents CustomTabcontrol1 As LuxNET.CustomTabcontrol
    Friend WithEvents IL_Connection As System.Windows.Forms.ImageList
    Friend WithEvents Timer1 As System.Windows.Forms.Timer
End Class
