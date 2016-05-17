<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class PasswordRecovery
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(PasswordRecovery))
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip()
        Me.ToolStripStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.LV_Passwords = New ComponentOwl.BetterListView.BetterListView()
        Me.BetterListViewColumnHeader1 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader2 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader3 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader4 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.CMS_Pass = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.RefreshToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripMenuItem1 = New System.Windows.Forms.ToolStripSeparator()
        Me.SaveToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem()
        Me.SaveAllToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.IL_Pass = New System.Windows.Forms.ImageList(Me.components)
        Me.StatusStrip1.SuspendLayout()
        CType(Me.LV_Passwords, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.CMS_Pass.SuspendLayout()
        Me.SuspendLayout()
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripStatusLabel1})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 327)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(730, 22)
        Me.StatusStrip1.TabIndex = 0
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'ToolStripStatusLabel1
        '
        Me.ToolStripStatusLabel1.Name = "ToolStripStatusLabel1"
        Me.ToolStripStatusLabel1.Size = New System.Drawing.Size(0, 17)
        '
        'LV_Passwords
        '
        Me.LV_Passwords.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LV_Passwords.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader1, Me.BetterListViewColumnHeader2, Me.BetterListViewColumnHeader3, Me.BetterListViewColumnHeader4})
        Me.LV_Passwords.ContextMenuStrip = Me.CMS_Pass
        Me.LV_Passwords.ImageList = Me.IL_Pass
        Me.LV_Passwords.Location = New System.Drawing.Point(4, 4)
        Me.LV_Passwords.Name = "LV_Passwords"
        Me.LV_Passwords.Size = New System.Drawing.Size(722, 318)
        Me.LV_Passwords.TabIndex = 1
        '
        'BetterListViewColumnHeader1
        '
        Me.BetterListViewColumnHeader1.Name = "BetterListViewColumnHeader1"
        Me.BetterListViewColumnHeader1.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader1.Text = "Website"
        Me.BetterListViewColumnHeader1.Width = 280
        '
        'BetterListViewColumnHeader2
        '
        Me.BetterListViewColumnHeader2.Name = "BetterListViewColumnHeader2"
        Me.BetterListViewColumnHeader2.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader2.Text = "Software"
        Me.BetterListViewColumnHeader2.Width = 104
        '
        'BetterListViewColumnHeader3
        '
        Me.BetterListViewColumnHeader3.Name = "BetterListViewColumnHeader3"
        Me.BetterListViewColumnHeader3.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader3.Text = "Username"
        Me.BetterListViewColumnHeader3.Width = 154
        '
        'BetterListViewColumnHeader4
        '
        Me.BetterListViewColumnHeader4.Name = "BetterListViewColumnHeader4"
        Me.BetterListViewColumnHeader4.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader4.Text = "Password"
        Me.BetterListViewColumnHeader4.Width = 138
        '
        'CMS_Pass
        '
        Me.CMS_Pass.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RefreshToolStripMenuItem, Me.ToolStripMenuItem1, Me.SaveToolStripMenuItem1, Me.SaveAllToolStripMenuItem})
        Me.CMS_Pass.Name = "CMS_Pass"
        Me.CMS_Pass.Size = New System.Drawing.Size(116, 76)
        '
        'RefreshToolStripMenuItem
        '
        Me.RefreshToolStripMenuItem.Image = CType(resources.GetObject("RefreshToolStripMenuItem.Image"), System.Drawing.Image)
        Me.RefreshToolStripMenuItem.Name = "RefreshToolStripMenuItem"
        Me.RefreshToolStripMenuItem.Size = New System.Drawing.Size(115, 22)
        Me.RefreshToolStripMenuItem.Text = "Refresh"
        '
        'ToolStripMenuItem1
        '
        Me.ToolStripMenuItem1.Name = "ToolStripMenuItem1"
        Me.ToolStripMenuItem1.Size = New System.Drawing.Size(112, 6)
        '
        'SaveToolStripMenuItem1
        '
        Me.SaveToolStripMenuItem1.Image = CType(resources.GetObject("SaveToolStripMenuItem1.Image"), System.Drawing.Image)
        Me.SaveToolStripMenuItem1.Name = "SaveToolStripMenuItem1"
        Me.SaveToolStripMenuItem1.Size = New System.Drawing.Size(115, 22)
        Me.SaveToolStripMenuItem1.Text = "Save"
        '
        'SaveAllToolStripMenuItem
        '
        Me.SaveAllToolStripMenuItem.Image = CType(resources.GetObject("SaveAllToolStripMenuItem.Image"), System.Drawing.Image)
        Me.SaveAllToolStripMenuItem.Name = "SaveAllToolStripMenuItem"
        Me.SaveAllToolStripMenuItem.Size = New System.Drawing.Size(115, 22)
        Me.SaveAllToolStripMenuItem.Text = "Save All"
        '
        'IL_Pass
        '
        Me.IL_Pass.ImageStream = CType(resources.GetObject("IL_Pass.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.IL_Pass.TransparentColor = System.Drawing.Color.Transparent
        Me.IL_Pass.Images.SetKeyName(0, "Google-Chrome-icon.png")
        Me.IL_Pass.Images.SetKeyName(1, "filezilla-icon.png")
        Me.IL_Pass.Images.SetKeyName(2, "Firefox-icon.png")
        Me.IL_Pass.Images.SetKeyName(3, "Opera-icon.png")
        '
        'PasswordRecovery
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(730, 349)
        Me.Controls.Add(Me.LV_Passwords)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Name = "PasswordRecovery"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Password Recovery - "
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        CType(Me.LV_Passwords, System.ComponentModel.ISupportInitialize).EndInit()
        Me.CMS_Pass.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents LV_Passwords As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents CMS_Pass As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents BetterListViewColumnHeader1 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader2 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader3 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader4 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents ToolStripMenuItem1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents SaveToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SaveAllToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RefreshToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents IL_Pass As System.Windows.Forms.ImageList
End Class
