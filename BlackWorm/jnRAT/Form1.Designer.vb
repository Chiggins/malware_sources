<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(Form1))
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip()
        Me.ToolStripStatusLabel4 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.ToolStripStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.ToolStripStatusLabel8 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.ToolStripStatusLabel2 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.ToolStripStatusLabel7 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.ToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator()
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.Timer2 = New System.Windows.Forms.Timer(Me.components)
        Me.ContextMenuStrip1 = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.VvvToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.FromDiskToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem()
        Me.FromURLToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem()
        Me.RunCmdToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.KeyloggerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.KeylogstartToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DumpToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.BlockWebSiteToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.OpenWebSiteToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DDOSAttackToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem()
        Me.ComputerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.LogoffToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripMenuItem3 = New System.Windows.Forms.ToolStripMenuItem()
        Me.ShutdownToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.WormSettingToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.UpdateToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.RestartToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem()
        Me.UninstallToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem()
        Me.CloseToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.IMG2 = New System.Windows.Forms.ImageList(Me.components)
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip()
        Me.StartToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.SendPugToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.L1 = New jnRAT.LV()
        Me.hname = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.hip = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.hpc = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.huser = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.hco = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.hos = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.hcam = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.hvr = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.hping = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.hac = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.hinstall = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.hcheck = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.GetDesktopToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.StatusStrip1.SuspendLayout()
        Me.ContextMenuStrip1.SuspendLayout()
        Me.MenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'StatusStrip1
        '
        Me.StatusStrip1.BackColor = System.Drawing.SystemColors.Control
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripStatusLabel4, Me.ToolStripStatusLabel1, Me.ToolStripStatusLabel8, Me.ToolStripStatusLabel2, Me.ToolStripStatusLabel7})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 403)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.RenderMode = System.Windows.Forms.ToolStripRenderMode.ManagerRenderMode
        Me.StatusStrip1.Size = New System.Drawing.Size(890, 22)
        Me.StatusStrip1.TabIndex = 1
        Me.StatusStrip1.Text = "|| "
        '
        'ToolStripStatusLabel4
        '
        Me.ToolStripStatusLabel4.Name = "ToolStripStatusLabel4"
        Me.ToolStripStatusLabel4.Size = New System.Drawing.Size(13, 17)
        Me.ToolStripStatusLabel4.Text = "||"
        '
        'ToolStripStatusLabel1
        '
        Me.ToolStripStatusLabel1.Image = CType(resources.GetObject("ToolStripStatusLabel1.Image"), System.Drawing.Image)
        Me.ToolStripStatusLabel1.Name = "ToolStripStatusLabel1"
        Me.ToolStripStatusLabel1.Size = New System.Drawing.Size(100, 17)
        Me.ToolStripStatusLabel1.Text = "[ Build WorM ]"
        '
        'ToolStripStatusLabel8
        '
        Me.ToolStripStatusLabel8.Name = "ToolStripStatusLabel8"
        Me.ToolStripStatusLabel8.Size = New System.Drawing.Size(13, 17)
        Me.ToolStripStatusLabel8.Text = "||"
        '
        'ToolStripStatusLabel2
        '
        Me.ToolStripStatusLabel2.Image = CType(resources.GetObject("ToolStripStatusLabel2.Image"), System.Drawing.Image)
        Me.ToolStripStatusLabel2.Name = "ToolStripStatusLabel2"
        Me.ToolStripStatusLabel2.Size = New System.Drawing.Size(105, 17)
        Me.ToolStripStatusLabel2.Text = "[ About Coder ]"
        '
        'ToolStripStatusLabel7
        '
        Me.ToolStripStatusLabel7.Name = "ToolStripStatusLabel7"
        Me.ToolStripStatusLabel7.Size = New System.Drawing.Size(13, 17)
        Me.ToolStripStatusLabel7.Text = "||"
        '
        'ToolStripMenuItem1
        '
        Me.ToolStripMenuItem1.Name = "ToolStripMenuItem1"
        Me.ToolStripMenuItem1.Size = New System.Drawing.Size(32, 19)
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 6)
        '
        'Timer1
        '
        Me.Timer1.Enabled = True
        '
        'Timer2
        '
        Me.Timer2.Enabled = True
        '
        'ContextMenuStrip1
        '
        Me.ContextMenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.VvvToolStripMenuItem, Me.RunCmdToolStripMenuItem, Me.GetDesktopToolStripMenuItem, Me.KeyloggerToolStripMenuItem, Me.BlockWebSiteToolStripMenuItem, Me.OpenWebSiteToolStripMenuItem, Me.DDOSAttackToolStripMenuItem1, Me.ComputerToolStripMenuItem, Me.WormSettingToolStripMenuItem})
        Me.ContextMenuStrip1.Name = "ContextMenuStrip1"
        Me.ContextMenuStrip1.Size = New System.Drawing.Size(153, 224)
        '
        'VvvToolStripMenuItem
        '
        Me.VvvToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FromDiskToolStripMenuItem1, Me.FromURLToolStripMenuItem1})
        Me.VvvToolStripMenuItem.Image = CType(resources.GetObject("VvvToolStripMenuItem.Image"), System.Drawing.Image)
        Me.VvvToolStripMenuItem.Name = "VvvToolStripMenuItem"
        Me.VvvToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.VvvToolStripMenuItem.Text = "Run File"
        '
        'FromDiskToolStripMenuItem1
        '
        Me.FromDiskToolStripMenuItem1.Image = CType(resources.GetObject("FromDiskToolStripMenuItem1.Image"), System.Drawing.Image)
        Me.FromDiskToolStripMenuItem1.Name = "FromDiskToolStripMenuItem1"
        Me.FromDiskToolStripMenuItem1.Size = New System.Drawing.Size(127, 22)
        Me.FromDiskToolStripMenuItem1.Text = "From Disk"
        '
        'FromURLToolStripMenuItem1
        '
        Me.FromURLToolStripMenuItem1.Image = CType(resources.GetObject("FromURLToolStripMenuItem1.Image"), System.Drawing.Image)
        Me.FromURLToolStripMenuItem1.Name = "FromURLToolStripMenuItem1"
        Me.FromURLToolStripMenuItem1.Size = New System.Drawing.Size(127, 22)
        Me.FromURLToolStripMenuItem1.Text = "From URL"
        '
        'RunCmdToolStripMenuItem
        '
        Me.RunCmdToolStripMenuItem.Image = CType(resources.GetObject("RunCmdToolStripMenuItem.Image"), System.Drawing.Image)
        Me.RunCmdToolStripMenuItem.Name = "RunCmdToolStripMenuItem"
        Me.RunCmdToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.RunCmdToolStripMenuItem.Text = "Get Password"
        '
        'KeyloggerToolStripMenuItem
        '
        Me.KeyloggerToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.KeylogstartToolStripMenuItem, Me.DumpToolStripMenuItem})
        Me.KeyloggerToolStripMenuItem.Image = CType(resources.GetObject("KeyloggerToolStripMenuItem.Image"), System.Drawing.Image)
        Me.KeyloggerToolStripMenuItem.Name = "KeyloggerToolStripMenuItem"
        Me.KeyloggerToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.KeyloggerToolStripMenuItem.Text = "Keylogger"
        '
        'KeylogstartToolStripMenuItem
        '
        Me.KeylogstartToolStripMenuItem.Image = CType(resources.GetObject("KeylogstartToolStripMenuItem.Image"), System.Drawing.Image)
        Me.KeylogstartToolStripMenuItem.Name = "KeylogstartToolStripMenuItem"
        Me.KeylogstartToolStripMenuItem.Size = New System.Drawing.Size(107, 22)
        Me.KeylogstartToolStripMenuItem.Text = "Start"
        '
        'DumpToolStripMenuItem
        '
        Me.DumpToolStripMenuItem.Image = CType(resources.GetObject("DumpToolStripMenuItem.Image"), System.Drawing.Image)
        Me.DumpToolStripMenuItem.Name = "DumpToolStripMenuItem"
        Me.DumpToolStripMenuItem.Size = New System.Drawing.Size(107, 22)
        Me.DumpToolStripMenuItem.Text = "Dump"
        '
        'BlockWebSiteToolStripMenuItem
        '
        Me.BlockWebSiteToolStripMenuItem.Image = CType(resources.GetObject("BlockWebSiteToolStripMenuItem.Image"), System.Drawing.Image)
        Me.BlockWebSiteToolStripMenuItem.Name = "BlockWebSiteToolStripMenuItem"
        Me.BlockWebSiteToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.BlockWebSiteToolStripMenuItem.Text = "Block WebSite"
        '
        'OpenWebSiteToolStripMenuItem
        '
        Me.OpenWebSiteToolStripMenuItem.Image = CType(resources.GetObject("OpenWebSiteToolStripMenuItem.Image"), System.Drawing.Image)
        Me.OpenWebSiteToolStripMenuItem.Name = "OpenWebSiteToolStripMenuItem"
        Me.OpenWebSiteToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.OpenWebSiteToolStripMenuItem.Text = "Open WebSite"
        '
        'DDOSAttackToolStripMenuItem1
        '
        Me.DDOSAttackToolStripMenuItem1.Image = CType(resources.GetObject("DDOSAttackToolStripMenuItem1.Image"), System.Drawing.Image)
        Me.DDOSAttackToolStripMenuItem1.Name = "DDOSAttackToolStripMenuItem1"
        Me.DDOSAttackToolStripMenuItem1.Size = New System.Drawing.Size(152, 22)
        Me.DDOSAttackToolStripMenuItem1.Text = "DDOS Attack"
        '
        'ComputerToolStripMenuItem
        '
        Me.ComputerToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.LogoffToolStripMenuItem, Me.ToolStripMenuItem3, Me.ShutdownToolStripMenuItem})
        Me.ComputerToolStripMenuItem.Image = CType(resources.GetObject("ComputerToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ComputerToolStripMenuItem.Name = "ComputerToolStripMenuItem"
        Me.ComputerToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.ComputerToolStripMenuItem.Text = "Computer"
        '
        'LogoffToolStripMenuItem
        '
        Me.LogoffToolStripMenuItem.Image = CType(resources.GetObject("LogoffToolStripMenuItem.Image"), System.Drawing.Image)
        Me.LogoffToolStripMenuItem.Name = "LogoffToolStripMenuItem"
        Me.LogoffToolStripMenuItem.Size = New System.Drawing.Size(128, 22)
        Me.LogoffToolStripMenuItem.Text = "Logoff"
        '
        'ToolStripMenuItem3
        '
        Me.ToolStripMenuItem3.Image = CType(resources.GetObject("ToolStripMenuItem3.Image"), System.Drawing.Image)
        Me.ToolStripMenuItem3.Name = "ToolStripMenuItem3"
        Me.ToolStripMenuItem3.Size = New System.Drawing.Size(128, 22)
        Me.ToolStripMenuItem3.Text = "Restart"
        '
        'ShutdownToolStripMenuItem
        '
        Me.ShutdownToolStripMenuItem.Image = CType(resources.GetObject("ShutdownToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ShutdownToolStripMenuItem.Name = "ShutdownToolStripMenuItem"
        Me.ShutdownToolStripMenuItem.Size = New System.Drawing.Size(128, 22)
        Me.ShutdownToolStripMenuItem.Text = "Shutdown"
        '
        'WormSettingToolStripMenuItem
        '
        Me.WormSettingToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.UpdateToolStripMenuItem, Me.RestartToolStripMenuItem1, Me.UninstallToolStripMenuItem1, Me.CloseToolStripMenuItem})
        Me.WormSettingToolStripMenuItem.Image = CType(resources.GetObject("WormSettingToolStripMenuItem.Image"), System.Drawing.Image)
        Me.WormSettingToolStripMenuItem.Name = "WormSettingToolStripMenuItem"
        Me.WormSettingToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.WormSettingToolStripMenuItem.Text = "Worm Setting"
        '
        'UpdateToolStripMenuItem
        '
        Me.UpdateToolStripMenuItem.Image = CType(resources.GetObject("UpdateToolStripMenuItem.Image"), System.Drawing.Image)
        Me.UpdateToolStripMenuItem.Name = "UpdateToolStripMenuItem"
        Me.UpdateToolStripMenuItem.Size = New System.Drawing.Size(120, 22)
        Me.UpdateToolStripMenuItem.Text = "Update"
        '
        'RestartToolStripMenuItem1
        '
        Me.RestartToolStripMenuItem1.Image = CType(resources.GetObject("RestartToolStripMenuItem1.Image"), System.Drawing.Image)
        Me.RestartToolStripMenuItem1.Name = "RestartToolStripMenuItem1"
        Me.RestartToolStripMenuItem1.Size = New System.Drawing.Size(120, 22)
        Me.RestartToolStripMenuItem1.Text = "Restart"
        '
        'UninstallToolStripMenuItem1
        '
        Me.UninstallToolStripMenuItem1.Image = CType(resources.GetObject("UninstallToolStripMenuItem1.Image"), System.Drawing.Image)
        Me.UninstallToolStripMenuItem1.Name = "UninstallToolStripMenuItem1"
        Me.UninstallToolStripMenuItem1.Size = New System.Drawing.Size(120, 22)
        Me.UninstallToolStripMenuItem1.Text = "Uninstall"
        '
        'CloseToolStripMenuItem
        '
        Me.CloseToolStripMenuItem.Image = CType(resources.GetObject("CloseToolStripMenuItem.Image"), System.Drawing.Image)
        Me.CloseToolStripMenuItem.Name = "CloseToolStripMenuItem"
        Me.CloseToolStripMenuItem.Size = New System.Drawing.Size(120, 22)
        Me.CloseToolStripMenuItem.Text = "Close"
        '
        'IMG2
        '
        Me.IMG2.ImageStream = CType(resources.GetObject("IMG2.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IMG2.TransparentColor = System.Drawing.Color.Transparent
        Me.IMG2.Images.SetKeyName(0, "X.png")
        Me.IMG2.Images.SetKeyName(1, "b.png")
        Me.IMG2.Images.SetKeyName(2, "ABW.png")
        Me.IMG2.Images.SetKeyName(3, "AFG.png")
        Me.IMG2.Images.SetKeyName(4, "AGO.png")
        Me.IMG2.Images.SetKeyName(5, "AIA.png")
        Me.IMG2.Images.SetKeyName(6, "ALA.png")
        Me.IMG2.Images.SetKeyName(7, "ALB.png")
        Me.IMG2.Images.SetKeyName(8, "AND.png")
        Me.IMG2.Images.SetKeyName(9, "ARE.png")
        Me.IMG2.Images.SetKeyName(10, "ARG.png")
        Me.IMG2.Images.SetKeyName(11, "ARM.png")
        Me.IMG2.Images.SetKeyName(12, "ASM.png")
        Me.IMG2.Images.SetKeyName(13, "ATF.png")
        Me.IMG2.Images.SetKeyName(14, "ATG.png")
        Me.IMG2.Images.SetKeyName(15, "AUS.png")
        Me.IMG2.Images.SetKeyName(16, "AUT.png")
        Me.IMG2.Images.SetKeyName(17, "AZE.png")
        Me.IMG2.Images.SetKeyName(18, "BDI.png")
        Me.IMG2.Images.SetKeyName(19, "BEL.png")
        Me.IMG2.Images.SetKeyName(20, "BEN.png")
        Me.IMG2.Images.SetKeyName(21, "BFA.png")
        Me.IMG2.Images.SetKeyName(22, "BGD.png")
        Me.IMG2.Images.SetKeyName(23, "BGR.png")
        Me.IMG2.Images.SetKeyName(24, "BHR.png")
        Me.IMG2.Images.SetKeyName(25, "BHS.png")
        Me.IMG2.Images.SetKeyName(26, "BIH.png")
        Me.IMG2.Images.SetKeyName(27, "BLR.png")
        Me.IMG2.Images.SetKeyName(28, "BLZ.png")
        Me.IMG2.Images.SetKeyName(29, "BMU.png")
        Me.IMG2.Images.SetKeyName(30, "BOL.png")
        Me.IMG2.Images.SetKeyName(31, "BRA.png")
        Me.IMG2.Images.SetKeyName(32, "BRB.png")
        Me.IMG2.Images.SetKeyName(33, "BRN.png")
        Me.IMG2.Images.SetKeyName(34, "BTN.png")
        Me.IMG2.Images.SetKeyName(35, "BVT.png")
        Me.IMG2.Images.SetKeyName(36, "BWA.png")
        Me.IMG2.Images.SetKeyName(37, "CAF.png")
        Me.IMG2.Images.SetKeyName(38, "CAN.png")
        Me.IMG2.Images.SetKeyName(39, "CCK.png")
        Me.IMG2.Images.SetKeyName(40, "CHE.png")
        Me.IMG2.Images.SetKeyName(41, "CHL.png")
        Me.IMG2.Images.SetKeyName(42, "CHN.png")
        Me.IMG2.Images.SetKeyName(43, "CIV.png")
        Me.IMG2.Images.SetKeyName(44, "CMR.png")
        Me.IMG2.Images.SetKeyName(45, "COD.png")
        Me.IMG2.Images.SetKeyName(46, "COG.png")
        Me.IMG2.Images.SetKeyName(47, "COK.png")
        Me.IMG2.Images.SetKeyName(48, "COL.png")
        Me.IMG2.Images.SetKeyName(49, "COM.png")
        Me.IMG2.Images.SetKeyName(50, "CPV.png")
        Me.IMG2.Images.SetKeyName(51, "CRI.png")
        Me.IMG2.Images.SetKeyName(52, "CUB.png")
        Me.IMG2.Images.SetKeyName(53, "CXR.png")
        Me.IMG2.Images.SetKeyName(54, "CYM.png")
        Me.IMG2.Images.SetKeyName(55, "CYP.png")
        Me.IMG2.Images.SetKeyName(56, "CZE.png")
        Me.IMG2.Images.SetKeyName(57, "DEU.png")
        Me.IMG2.Images.SetKeyName(58, "DJI.png")
        Me.IMG2.Images.SetKeyName(59, "DMA.png")
        Me.IMG2.Images.SetKeyName(60, "DNK.png")
        Me.IMG2.Images.SetKeyName(61, "DOM.png")
        Me.IMG2.Images.SetKeyName(62, "DZA.png")
        Me.IMG2.Images.SetKeyName(63, "ECU.png")
        Me.IMG2.Images.SetKeyName(64, "EGY.png")
        Me.IMG2.Images.SetKeyName(65, "ERI.png")
        Me.IMG2.Images.SetKeyName(66, "ESH.png")
        Me.IMG2.Images.SetKeyName(67, "ESP.png")
        Me.IMG2.Images.SetKeyName(68, "EST.png")
        Me.IMG2.Images.SetKeyName(69, "ETH.png")
        Me.IMG2.Images.SetKeyName(70, "FIN.png")
        Me.IMG2.Images.SetKeyName(71, "FJI.png")
        Me.IMG2.Images.SetKeyName(72, "FLK.png")
        Me.IMG2.Images.SetKeyName(73, "FRA.png")
        Me.IMG2.Images.SetKeyName(74, "FRO.png")
        Me.IMG2.Images.SetKeyName(75, "FSM.png")
        Me.IMG2.Images.SetKeyName(76, "GAB.png")
        Me.IMG2.Images.SetKeyName(77, "GBR.png")
        Me.IMG2.Images.SetKeyName(78, "GEO.png")
        Me.IMG2.Images.SetKeyName(79, "GHA.png")
        Me.IMG2.Images.SetKeyName(80, "GIB.png")
        Me.IMG2.Images.SetKeyName(81, "GIN.png")
        Me.IMG2.Images.SetKeyName(82, "GLP.png")
        Me.IMG2.Images.SetKeyName(83, "GMB.png")
        Me.IMG2.Images.SetKeyName(84, "GNB.png")
        Me.IMG2.Images.SetKeyName(85, "GNQ.png")
        Me.IMG2.Images.SetKeyName(86, "GRC.png")
        Me.IMG2.Images.SetKeyName(87, "GRD.png")
        Me.IMG2.Images.SetKeyName(88, "GRL.png")
        Me.IMG2.Images.SetKeyName(89, "GTM.png")
        Me.IMG2.Images.SetKeyName(90, "GUF.png")
        Me.IMG2.Images.SetKeyName(91, "GUM.png")
        Me.IMG2.Images.SetKeyName(92, "GUY.png")
        Me.IMG2.Images.SetKeyName(93, "HKG.png")
        Me.IMG2.Images.SetKeyName(94, "HMD.png")
        Me.IMG2.Images.SetKeyName(95, "HND.png")
        Me.IMG2.Images.SetKeyName(96, "HRV.png")
        Me.IMG2.Images.SetKeyName(97, "HTI.png")
        Me.IMG2.Images.SetKeyName(98, "HUN.png")
        Me.IMG2.Images.SetKeyName(99, "IDN.png")
        Me.IMG2.Images.SetKeyName(100, "IND.png")
        Me.IMG2.Images.SetKeyName(101, "IOT.png")
        Me.IMG2.Images.SetKeyName(102, "IRL.png")
        Me.IMG2.Images.SetKeyName(103, "IRN.png")
        Me.IMG2.Images.SetKeyName(104, "IRQ.png")
        Me.IMG2.Images.SetKeyName(105, "ISL.png")
        Me.IMG2.Images.SetKeyName(106, "ISR.png")
        Me.IMG2.Images.SetKeyName(107, "ITA.png")
        Me.IMG2.Images.SetKeyName(108, "JAM.png")
        Me.IMG2.Images.SetKeyName(109, "JOR.png")
        Me.IMG2.Images.SetKeyName(110, "JPN.png")
        Me.IMG2.Images.SetKeyName(111, "KAZ.png")
        Me.IMG2.Images.SetKeyName(112, "KEN.png")
        Me.IMG2.Images.SetKeyName(113, "KGZ.png")
        Me.IMG2.Images.SetKeyName(114, "KHM.png")
        Me.IMG2.Images.SetKeyName(115, "KIR.png")
        Me.IMG2.Images.SetKeyName(116, "KNA.png")
        Me.IMG2.Images.SetKeyName(117, "KOR.png")
        Me.IMG2.Images.SetKeyName(118, "KWT.png")
        Me.IMG2.Images.SetKeyName(119, "LAO.png")
        Me.IMG2.Images.SetKeyName(120, "LBN.png")
        Me.IMG2.Images.SetKeyName(121, "LBR.png")
        Me.IMG2.Images.SetKeyName(122, "LBY.png")
        Me.IMG2.Images.SetKeyName(123, "LCA.png")
        Me.IMG2.Images.SetKeyName(124, "LIE.png")
        Me.IMG2.Images.SetKeyName(125, "LKA.png")
        Me.IMG2.Images.SetKeyName(126, "LSO.png")
        Me.IMG2.Images.SetKeyName(127, "LTU.png")
        Me.IMG2.Images.SetKeyName(128, "LUX.png")
        Me.IMG2.Images.SetKeyName(129, "LVA.png")
        Me.IMG2.Images.SetKeyName(130, "MAC.png")
        Me.IMG2.Images.SetKeyName(131, "MAR.png")
        Me.IMG2.Images.SetKeyName(132, "MCO.png")
        Me.IMG2.Images.SetKeyName(133, "MDA.png")
        Me.IMG2.Images.SetKeyName(134, "MDG.png")
        Me.IMG2.Images.SetKeyName(135, "MDV.png")
        Me.IMG2.Images.SetKeyName(136, "MEX.png")
        Me.IMG2.Images.SetKeyName(137, "MHL.png")
        Me.IMG2.Images.SetKeyName(138, "MKD.png")
        Me.IMG2.Images.SetKeyName(139, "MLI.png")
        Me.IMG2.Images.SetKeyName(140, "MLT.png")
        Me.IMG2.Images.SetKeyName(141, "MMR.png")
        Me.IMG2.Images.SetKeyName(142, "MNE.png")
        Me.IMG2.Images.SetKeyName(143, "MNG.png")
        Me.IMG2.Images.SetKeyName(144, "MNP.png")
        Me.IMG2.Images.SetKeyName(145, "MOZ.png")
        Me.IMG2.Images.SetKeyName(146, "MRT.png")
        Me.IMG2.Images.SetKeyName(147, "MSR.png")
        Me.IMG2.Images.SetKeyName(148, "MTQ.png")
        Me.IMG2.Images.SetKeyName(149, "MUS.png")
        Me.IMG2.Images.SetKeyName(150, "MWI.png")
        Me.IMG2.Images.SetKeyName(151, "MYS.png")
        Me.IMG2.Images.SetKeyName(152, "MYT.png")
        Me.IMG2.Images.SetKeyName(153, "NAM.png")
        Me.IMG2.Images.SetKeyName(154, "NCL.png")
        Me.IMG2.Images.SetKeyName(155, "NER.png")
        Me.IMG2.Images.SetKeyName(156, "NFK.png")
        Me.IMG2.Images.SetKeyName(157, "NGA.png")
        Me.IMG2.Images.SetKeyName(158, "NIC.png")
        Me.IMG2.Images.SetKeyName(159, "NIU.png")
        Me.IMG2.Images.SetKeyName(160, "NLD.png")
        Me.IMG2.Images.SetKeyName(161, "NOR.png")
        Me.IMG2.Images.SetKeyName(162, "NPL.png")
        Me.IMG2.Images.SetKeyName(163, "NRU.png")
        Me.IMG2.Images.SetKeyName(164, "NZL.png")
        Me.IMG2.Images.SetKeyName(165, "OMN.png")
        Me.IMG2.Images.SetKeyName(166, "PAK.png")
        Me.IMG2.Images.SetKeyName(167, "PAN.png")
        Me.IMG2.Images.SetKeyName(168, "PCN.png")
        Me.IMG2.Images.SetKeyName(169, "PER.png")
        Me.IMG2.Images.SetKeyName(170, "PHL.png")
        Me.IMG2.Images.SetKeyName(171, "PLW.png")
        Me.IMG2.Images.SetKeyName(172, "PNG.png")
        Me.IMG2.Images.SetKeyName(173, "POL.png")
        Me.IMG2.Images.SetKeyName(174, "PRI.png")
        Me.IMG2.Images.SetKeyName(175, "PRK.png")
        Me.IMG2.Images.SetKeyName(176, "PRT.png")
        Me.IMG2.Images.SetKeyName(177, "PRY.png")
        Me.IMG2.Images.SetKeyName(178, "PSE.png")
        Me.IMG2.Images.SetKeyName(179, "PYF.png")
        Me.IMG2.Images.SetKeyName(180, "QAT.png")
        Me.IMG2.Images.SetKeyName(181, "REU.png")
        Me.IMG2.Images.SetKeyName(182, "ROM.png")
        Me.IMG2.Images.SetKeyName(183, "RUS.png")
        Me.IMG2.Images.SetKeyName(184, "RWA.png")
        Me.IMG2.Images.SetKeyName(185, "SAU.png")
        Me.IMG2.Images.SetKeyName(186, "SDN.png")
        Me.IMG2.Images.SetKeyName(187, "SEN.png")
        Me.IMG2.Images.SetKeyName(188, "SGP.png")
        Me.IMG2.Images.SetKeyName(189, "SGS.png")
        Me.IMG2.Images.SetKeyName(190, "SHN.png")
        Me.IMG2.Images.SetKeyName(191, "SJM.png")
        Me.IMG2.Images.SetKeyName(192, "SLB.png")
        Me.IMG2.Images.SetKeyName(193, "SLE.png")
        Me.IMG2.Images.SetKeyName(194, "SLV.png")
        Me.IMG2.Images.SetKeyName(195, "SMR.png")
        Me.IMG2.Images.SetKeyName(196, "SOM.png")
        Me.IMG2.Images.SetKeyName(197, "SPM.png")
        Me.IMG2.Images.SetKeyName(198, "SRB.png")
        Me.IMG2.Images.SetKeyName(199, "STP.png")
        Me.IMG2.Images.SetKeyName(200, "SUR.png")
        Me.IMG2.Images.SetKeyName(201, "SVK.png")
        Me.IMG2.Images.SetKeyName(202, "SVN.png")
        Me.IMG2.Images.SetKeyName(203, "SWE.png")
        Me.IMG2.Images.SetKeyName(204, "SWZ.png")
        Me.IMG2.Images.SetKeyName(205, "SYC.png")
        Me.IMG2.Images.SetKeyName(206, "SYR.png")
        Me.IMG2.Images.SetKeyName(207, "TCA.png")
        Me.IMG2.Images.SetKeyName(208, "TCD.png")
        Me.IMG2.Images.SetKeyName(209, "TGO.png")
        Me.IMG2.Images.SetKeyName(210, "THA.png")
        Me.IMG2.Images.SetKeyName(211, "TJK.png")
        Me.IMG2.Images.SetKeyName(212, "TKL.png")
        Me.IMG2.Images.SetKeyName(213, "TKM.png")
        Me.IMG2.Images.SetKeyName(214, "TLS.png")
        Me.IMG2.Images.SetKeyName(215, "TON.png")
        Me.IMG2.Images.SetKeyName(216, "TTO.png")
        Me.IMG2.Images.SetKeyName(217, "TUN.png")
        Me.IMG2.Images.SetKeyName(218, "TUR.png")
        Me.IMG2.Images.SetKeyName(219, "TUV.png")
        Me.IMG2.Images.SetKeyName(220, "TWN.png")
        Me.IMG2.Images.SetKeyName(221, "TZA.png")
        Me.IMG2.Images.SetKeyName(222, "UGA.png")
        Me.IMG2.Images.SetKeyName(223, "UKR.png")
        Me.IMG2.Images.SetKeyName(224, "UMI.png")
        Me.IMG2.Images.SetKeyName(225, "URY.png")
        Me.IMG2.Images.SetKeyName(226, "USA.png")
        Me.IMG2.Images.SetKeyName(227, "UZB.png")
        Me.IMG2.Images.SetKeyName(228, "VAT.png")
        Me.IMG2.Images.SetKeyName(229, "VCT.png")
        Me.IMG2.Images.SetKeyName(230, "VEN.png")
        Me.IMG2.Images.SetKeyName(231, "VGB.png")
        Me.IMG2.Images.SetKeyName(232, "VIR.png")
        Me.IMG2.Images.SetKeyName(233, "VNM.png")
        Me.IMG2.Images.SetKeyName(234, "VUT.png")
        Me.IMG2.Images.SetKeyName(235, "WLF.png")
        Me.IMG2.Images.SetKeyName(236, "WSM.png")
        Me.IMG2.Images.SetKeyName(237, "YEM.png")
        Me.IMG2.Images.SetKeyName(238, "ZAF.png")
        Me.IMG2.Images.SetKeyName(239, "ZMB.png")
        Me.IMG2.Images.SetKeyName(240, "ZWE.png")
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.StartToolStripMenuItem, Me.SendPugToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(890, 24)
        Me.MenuStrip1.TabIndex = 5
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'StartToolStripMenuItem
        '
        Me.StartToolStripMenuItem.Image = CType(resources.GetObject("StartToolStripMenuItem.Image"), System.Drawing.Image)
        Me.StartToolStripMenuItem.Name = "StartToolStripMenuItem"
        Me.StartToolStripMenuItem.Size = New System.Drawing.Size(107, 20)
        Me.StartToolStripMenuItem.Text = "[ Start Listen ]"
        '
        'SendPugToolStripMenuItem
        '
        Me.SendPugToolStripMenuItem.Image = CType(resources.GetObject("SendPugToolStripMenuItem.Image"), System.Drawing.Image)
        Me.SendPugToolStripMenuItem.Name = "SendPugToolStripMenuItem"
        Me.SendPugToolStripMenuItem.Size = New System.Drawing.Size(125, 20)
        Me.SendPugToolStripMenuItem.Text = "[ No-IP Updater ]"
        '
        'L1
        '
        Me.L1.BackColor = System.Drawing.Color.White
        Me.L1.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.hname, Me.hip, Me.hpc, Me.huser, Me.hco, Me.hos, Me.hcam, Me.hvr, Me.hping, Me.hac, Me.hinstall, Me.hcheck})
        Me.L1.ContextMenuStrip = Me.ContextMenuStrip1
        Me.L1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.L1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Bold)
        Me.L1.ForeColor = System.Drawing.Color.Black
        Me.L1.FullRowSelect = True
        Me.L1.GridLines = True
        Me.L1.LargeImageList = Me.IMG2
        Me.L1.Location = New System.Drawing.Point(0, 24)
        Me.L1.Name = "L1"
        Me.L1.Size = New System.Drawing.Size(890, 379)
        Me.L1.SmallImageList = Me.IMG2
        Me.L1.TabIndex = 2
        Me.L1.UseCompatibleStateImageBehavior = False
        Me.L1.View = System.Windows.Forms.View.Details
        '
        'hname
        '
        Me.hname.Text = " ][ Victim ID ]["
        Me.hname.Width = 108
        '
        'hip
        '
        Me.hip.Text = "][ Victim IP ]["
        Me.hip.Width = 105
        '
        'hpc
        '
        Me.hpc.Text = "][ PC ]["
        Me.hpc.Width = 100
        '
        'huser
        '
        Me.huser.Text = "][ USER ]["
        Me.huser.Width = 118
        '
        'hco
        '
        Me.hco.Text = "][ Country ]["
        Me.hco.Width = 107
        '
        'hos
        '
        Me.hos.Text = "][ Operating System ]["
        Me.hos.Width = 140
        '
        'hcam
        '
        Me.hcam.Text = "][ Cam ]["
        '
        'hvr
        '
        Me.hvr.Text = "][ WorM Version ]["
        Me.hvr.Width = 131
        '
        'hping
        '
        Me.hping.Text = "][ PING ]["
        '
        'hac
        '
        Me.hac.Text = "][ Active Window ]["
        Me.hac.Width = 164
        '
        'hinstall
        '
        Me.hinstall.Text = "][ Install Date ]["
        Me.hinstall.Width = 97
        '
        'hcheck
        '
        Me.hcheck.Text = "][ USB Spread ]["
        Me.hcheck.Width = 103
        '
        'GetDesktopToolStripMenuItem
        '
        Me.GetDesktopToolStripMenuItem.Image = CType(resources.GetObject("GetDesktopToolStripMenuItem.Image"), System.Drawing.Image)
        Me.GetDesktopToolStripMenuItem.Name = "GetDesktopToolStripMenuItem"
        Me.GetDesktopToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.GetDesktopToolStripMenuItem.Text = "Get Desktop"
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(890, 425)
        Me.Controls.Add(Me.L1)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Controls.Add(Me.MenuStrip1)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "Form1"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Window Name"
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.ContextMenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip

    Friend WithEvents ToolStripStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents ToolStripStatusLabel2 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents ContextMenuStrip2 As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents RunFileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents FromDiskToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents FromURLToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DDosAttacKToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ServerSettingToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RestartToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SEOToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripStatusLabel4 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents UninstallToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem

    Friend WithEvents OpenWebPageToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ChangeColorToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents USBVictimToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents Timer1 As System.Windows.Forms.Timer
    Friend WithEvents Timer2 As System.Windows.Forms.Timer
    Friend WithEvents ContextMenuStrip1 As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents VvvToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents FromDiskToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents FromURLToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OpenWebSiteToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DDOSAttackToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents WormSettingToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RestartToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents UninstallToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CloseToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents IMG2 As System.Windows.Forms.ImageList
    Friend WithEvents BlockWebSiteToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ComputerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents LogoffToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem3 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ShutdownToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents UpdateToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents StartToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SendPugToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripStatusLabel7 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents ToolStripStatusLabel8 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents hname As System.Windows.Forms.ColumnHeader
    Friend WithEvents hip As System.Windows.Forms.ColumnHeader
    Friend WithEvents hpc As System.Windows.Forms.ColumnHeader
    Friend WithEvents huser As System.Windows.Forms.ColumnHeader
    Friend WithEvents hco As System.Windows.Forms.ColumnHeader
    Friend WithEvents hos As System.Windows.Forms.ColumnHeader
    Friend WithEvents hcam As System.Windows.Forms.ColumnHeader
    Friend WithEvents hvr As System.Windows.Forms.ColumnHeader
    Friend WithEvents hping As System.Windows.Forms.ColumnHeader
    Friend WithEvents hac As System.Windows.Forms.ColumnHeader
    Friend WithEvents hinstall As System.Windows.Forms.ColumnHeader
    Friend WithEvents hcheck As System.Windows.Forms.ColumnHeader
    Friend WithEvents L1 As jnRAT.LV
    Friend WithEvents RunCmdToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents KeyloggerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents KeylogstartToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DumpToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents GetDesktopToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem

End Class
