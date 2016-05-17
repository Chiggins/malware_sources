<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class RemoteAdminTools
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(RemoteAdminTools))
        Me.CustomTabcontrol1 = New LuxNET.CustomTabcontrol()
        Me.TabPage1 = New System.Windows.Forms.TabPage()
        Me.btn_blockwebsite = New System.Windows.Forms.Button()
        Me.tb_website = New System.Windows.Forms.TextBox()
        Me.LV_BlockWebsites = New ComponentOwl.BetterListView.BetterListView()
        Me.BetterListViewColumnHeader1 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.ContextMenuStrip1 = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.UnBlockAllToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.IL_Website = New System.Windows.Forms.ImageList(Me.components)
        Me.TabPage2 = New System.Windows.Forms.TabPage()
        Me.btn_disabletaskmgr = New System.Windows.Forms.Button()
        Me.btn_disablecmd = New System.Windows.Forms.Button()
        Me.btn_disableuac = New System.Windows.Forms.Button()
        Me.btn_disablecontrolpanel = New System.Windows.Forms.Button()
        Me.ButtonNuke = New System.Windows.Forms.Button()
        Me.ImageList1 = New System.Windows.Forms.ImageList(Me.components)
        Me.CustomTabcontrol1.SuspendLayout()
        Me.TabPage1.SuspendLayout()
        CType(Me.LV_BlockWebsites, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ContextMenuStrip1.SuspendLayout()
        Me.TabPage2.SuspendLayout()
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
        Me.CustomTabcontrol1.ImageList = Me.ImageList1
        Me.CustomTabcontrol1.ItemSize = New System.Drawing.Size(40, 150)
        Me.CustomTabcontrol1.Location = New System.Drawing.Point(0, 0)
        Me.CustomTabcontrol1.Multiline = True
        Me.CustomTabcontrol1.Name = "CustomTabcontrol1"
        Me.CustomTabcontrol1.SelectedIndex = 0
        Me.CustomTabcontrol1.SelectedItemColor = System.Drawing.Color.FromArgb(CType(CType(30, Byte), Integer), CType(CType(10, Byte), Integer), CType(CType(100, Byte), Integer), CType(CType(200, Byte), Integer))
        Me.CustomTabcontrol1.Size = New System.Drawing.Size(752, 359)
        Me.CustomTabcontrol1.SizeMode = System.Windows.Forms.TabSizeMode.Fixed
        Me.CustomTabcontrol1.TabIndex = 0
        '
        'TabPage1
        '
        Me.TabPage1.Controls.Add(Me.btn_blockwebsite)
        Me.TabPage1.Controls.Add(Me.tb_website)
        Me.TabPage1.Controls.Add(Me.LV_BlockWebsites)
        Me.TabPage1.Location = New System.Drawing.Point(154, 4)
        Me.TabPage1.Name = "TabPage1"
        Me.TabPage1.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage1.Size = New System.Drawing.Size(594, 351)
        Me.TabPage1.TabIndex = 0
        Me.TabPage1.Text = "Block Website"
        Me.TabPage1.UseVisualStyleBackColor = True
        '
        'btn_blockwebsite
        '
        Me.btn_blockwebsite.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btn_blockwebsite.Image = CType(resources.GetObject("btn_blockwebsite.Image"), System.Drawing.Image)
        Me.btn_blockwebsite.Location = New System.Drawing.Point(554, 317)
        Me.btn_blockwebsite.Name = "btn_blockwebsite"
        Me.btn_blockwebsite.Size = New System.Drawing.Size(34, 27)
        Me.btn_blockwebsite.TabIndex = 2
        Me.btn_blockwebsite.UseVisualStyleBackColor = True
        '
        'tb_website
        '
        Me.tb_website.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tb_website.Location = New System.Drawing.Point(6, 318)
        Me.tb_website.Name = "tb_website"
        Me.tb_website.Size = New System.Drawing.Size(543, 25)
        Me.tb_website.TabIndex = 1
        '
        'LV_BlockWebsites
        '
        Me.LV_BlockWebsites.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LV_BlockWebsites.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader1})
        Me.LV_BlockWebsites.ContextMenuStrip = Me.ContextMenuStrip1
        Me.LV_BlockWebsites.ImageList = Me.IL_Website
        Me.LV_BlockWebsites.Location = New System.Drawing.Point(6, 6)
        Me.LV_BlockWebsites.Name = "LV_BlockWebsites"
        Me.LV_BlockWebsites.Size = New System.Drawing.Size(582, 308)
        Me.LV_BlockWebsites.TabIndex = 0
        '
        'BetterListViewColumnHeader1
        '
        Me.BetterListViewColumnHeader1.Name = "BetterListViewColumnHeader1"
        Me.BetterListViewColumnHeader1.Text = "Website URL"
        Me.BetterListViewColumnHeader1.Width = 551
        '
        'ContextMenuStrip1
        '
        Me.ContextMenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.UnBlockAllToolStripMenuItem})
        Me.ContextMenuStrip1.Name = "ContextMenuStrip1"
        Me.ContextMenuStrip1.Size = New System.Drawing.Size(136, 26)
        '
        'UnBlockAllToolStripMenuItem
        '
        Me.UnBlockAllToolStripMenuItem.Image = CType(resources.GetObject("UnBlockAllToolStripMenuItem.Image"), System.Drawing.Image)
        Me.UnBlockAllToolStripMenuItem.Name = "UnBlockAllToolStripMenuItem"
        Me.UnBlockAllToolStripMenuItem.Size = New System.Drawing.Size(135, 22)
        Me.UnBlockAllToolStripMenuItem.Text = "Unblock All"
        '
        'IL_Website
        '
        Me.IL_Website.ImageStream = CType(resources.GetObject("IL_Website.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_Website.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_Website.Images.SetKeyName(0, "chain-icon.png")
        '
        'TabPage2
        '
        Me.TabPage2.Controls.Add(Me.btn_disabletaskmgr)
        Me.TabPage2.Controls.Add(Me.btn_disablecmd)
        Me.TabPage2.Controls.Add(Me.btn_disableuac)
        Me.TabPage2.Controls.Add(Me.btn_disablecontrolpanel)
        Me.TabPage2.Controls.Add(Me.ButtonNuke)
        Me.TabPage2.Location = New System.Drawing.Point(154, 4)
        Me.TabPage2.Name = "TabPage2"
        Me.TabPage2.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage2.Size = New System.Drawing.Size(594, 351)
        Me.TabPage2.TabIndex = 1
        Me.TabPage2.Text = "Others"
        Me.TabPage2.UseVisualStyleBackColor = True
        '
        'btn_disabletaskmgr
        '
        Me.btn_disabletaskmgr.Image = CType(resources.GetObject("btn_disabletaskmgr.Image"), System.Drawing.Image)
        Me.btn_disabletaskmgr.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_disabletaskmgr.Location = New System.Drawing.Point(25, 195)
        Me.btn_disabletaskmgr.Name = "btn_disabletaskmgr"
        Me.btn_disabletaskmgr.Size = New System.Drawing.Size(224, 27)
        Me.btn_disabletaskmgr.TabIndex = 4
        Me.btn_disabletaskmgr.Text = "Disable TaskManager"
        Me.btn_disabletaskmgr.UseVisualStyleBackColor = True
        '
        'btn_disablecmd
        '
        Me.btn_disablecmd.Image = CType(resources.GetObject("btn_disablecmd.Image"), System.Drawing.Image)
        Me.btn_disablecmd.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_disablecmd.Location = New System.Drawing.Point(25, 150)
        Me.btn_disablecmd.Name = "btn_disablecmd"
        Me.btn_disablecmd.Size = New System.Drawing.Size(224, 27)
        Me.btn_disablecmd.TabIndex = 3
        Me.btn_disablecmd.Text = "Disable Command Prompt"
        Me.btn_disablecmd.UseVisualStyleBackColor = True
        '
        'btn_disableuac
        '
        Me.btn_disableuac.Image = CType(resources.GetObject("btn_disableuac.Image"), System.Drawing.Image)
        Me.btn_disableuac.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_disableuac.Location = New System.Drawing.Point(25, 107)
        Me.btn_disableuac.Name = "btn_disableuac"
        Me.btn_disableuac.Size = New System.Drawing.Size(224, 27)
        Me.btn_disableuac.TabIndex = 2
        Me.btn_disableuac.Text = "Disable UAC"
        Me.btn_disableuac.UseVisualStyleBackColor = True
        '
        'btn_disablecontrolpanel
        '
        Me.btn_disablecontrolpanel.Image = CType(resources.GetObject("btn_disablecontrolpanel.Image"), System.Drawing.Image)
        Me.btn_disablecontrolpanel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_disablecontrolpanel.Location = New System.Drawing.Point(25, 65)
        Me.btn_disablecontrolpanel.Name = "btn_disablecontrolpanel"
        Me.btn_disablecontrolpanel.Size = New System.Drawing.Size(224, 27)
        Me.btn_disablecontrolpanel.TabIndex = 1
        Me.btn_disablecontrolpanel.Text = "Disable Control Panel"
        Me.btn_disablecontrolpanel.UseVisualStyleBackColor = True
        '
        'ButtonNuke
        '
        Me.ButtonNuke.Image = CType(resources.GetObject("ButtonNuke.Image"), System.Drawing.Image)
        Me.ButtonNuke.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.ButtonNuke.Location = New System.Drawing.Point(25, 23)
        Me.ButtonNuke.Name = "ButtonNuke"
        Me.ButtonNuke.Size = New System.Drawing.Size(224, 27)
        Me.ButtonNuke.TabIndex = 0
        Me.ButtonNuke.Text = "NUKE COMPUTER"
        Me.ButtonNuke.UseVisualStyleBackColor = True
        '
        'ImageList1
        '
        Me.ImageList1.ImageStream = CType(resources.GetObject("ImageList1.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ImageList1.TransparentColor = System.Drawing.Color.Transparent
        Me.ImageList1.Images.SetKeyName(0, "firefox_pre1_blue.png")
        Me.ImageList1.Images.SetKeyName(1, "flag_blue.png")
        '
        'RemoteAdminTools
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(752, 359)
        Me.Controls.Add(Me.CustomTabcontrol1)
        Me.MinimumSize = New System.Drawing.Size(768, 398)
        Me.Name = "RemoteAdminTools"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Administrative Tools - "
        Me.CustomTabcontrol1.ResumeLayout(False)
        Me.TabPage1.ResumeLayout(False)
        Me.TabPage1.PerformLayout()
        CType(Me.LV_BlockWebsites, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ContextMenuStrip1.ResumeLayout(False)
        Me.TabPage2.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents TabPage1 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage2 As System.Windows.Forms.TabPage
    Friend WithEvents LV_BlockWebsites As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents btn_blockwebsite As System.Windows.Forms.Button
    Friend WithEvents tb_website As System.Windows.Forms.TextBox
    Friend WithEvents BetterListViewColumnHeader1 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents ContextMenuStrip1 As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents UnBlockAllToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents btn_disabletaskmgr As System.Windows.Forms.Button
    Friend WithEvents btn_disablecmd As System.Windows.Forms.Button
    Friend WithEvents btn_disableuac As System.Windows.Forms.Button
    Friend WithEvents btn_disablecontrolpanel As System.Windows.Forms.Button
    Friend WithEvents ButtonNuke As System.Windows.Forms.Button
    Friend WithEvents CustomTabcontrol1 As LuxNET.CustomTabcontrol
    Friend WithEvents IL_Website As System.Windows.Forms.ImageList
    Friend WithEvents ImageList1 As System.Windows.Forms.ImageList
End Class
