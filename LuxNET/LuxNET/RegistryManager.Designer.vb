<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class RegistryManager
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(RegistryManager))
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip()
        Me.Label_Information = New System.Windows.Forms.ToolStripStatusLabel()
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer()
        Me.TreeView1 = New System.Windows.Forms.TreeView()
        Me.CMS_TreeView = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.CreateNewSubKeyToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DeleteKeyToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ListView1 = New ComponentOwl.BetterListView.BetterListView()
        Me.BetterListViewColumnHeader1 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader2 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader3 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.CMS_LV = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.NewToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ModifyToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DeleteToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.CopyToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.NameToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ValueToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ImageList_ListView = New System.Windows.Forms.ImageList(Me.components)
        Me.ImageList_TreeView = New System.Windows.Forms.ImageList(Me.components)
        Me.StatusStrip1.SuspendLayout()
        CType(Me.SplitContainer1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        Me.CMS_TreeView.SuspendLayout()
        CType(Me.ListView1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.CMS_LV.SuspendLayout()
        Me.SuspendLayout()
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.Label_Information})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 394)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(790, 22)
        Me.StatusStrip1.TabIndex = 0
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'Label_Information
        '
        Me.Label_Information.Name = "Label_Information"
        Me.Label_Information.Size = New System.Drawing.Size(0, 17)
        '
        'SplitContainer1
        '
        Me.SplitContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer1.Location = New System.Drawing.Point(0, 0)
        Me.SplitContainer1.Name = "SplitContainer1"
        '
        'SplitContainer1.Panel1
        '
        Me.SplitContainer1.Panel1.Controls.Add(Me.TreeView1)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.ListView1)
        Me.SplitContainer1.Size = New System.Drawing.Size(790, 394)
        Me.SplitContainer1.SplitterDistance = 263
        Me.SplitContainer1.TabIndex = 1
        '
        'TreeView1
        '
        Me.TreeView1.ContextMenuStrip = Me.CMS_TreeView
        Me.TreeView1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TreeView1.ImageIndex = 0
        Me.TreeView1.ImageList = Me.ImageList_TreeView
        Me.TreeView1.Location = New System.Drawing.Point(0, 0)
        Me.TreeView1.Name = "TreeView1"
        Me.TreeView1.SelectedImageIndex = 0
        Me.TreeView1.Size = New System.Drawing.Size(263, 394)
        Me.TreeView1.TabIndex = 0
        '
        'CMS_TreeView
        '
        Me.CMS_TreeView.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.CreateNewSubKeyToolStripMenuItem, Me.DeleteKeyToolStripMenuItem})
        Me.CMS_TreeView.Name = "CMS_TreeView"
        Me.CMS_TreeView.Size = New System.Drawing.Size(178, 48)
        '
        'CreateNewSubKeyToolStripMenuItem
        '
        Me.CreateNewSubKeyToolStripMenuItem.Image = CType(resources.GetObject("CreateNewSubKeyToolStripMenuItem.Image"), System.Drawing.Image)
        Me.CreateNewSubKeyToolStripMenuItem.Name = "CreateNewSubKeyToolStripMenuItem"
        Me.CreateNewSubKeyToolStripMenuItem.Size = New System.Drawing.Size(177, 22)
        Me.CreateNewSubKeyToolStripMenuItem.Text = "Create New SubKey"
        '
        'DeleteKeyToolStripMenuItem
        '
        Me.DeleteKeyToolStripMenuItem.Image = CType(resources.GetObject("DeleteKeyToolStripMenuItem.Image"), System.Drawing.Image)
        Me.DeleteKeyToolStripMenuItem.Name = "DeleteKeyToolStripMenuItem"
        Me.DeleteKeyToolStripMenuItem.Size = New System.Drawing.Size(177, 22)
        Me.DeleteKeyToolStripMenuItem.Text = "Delete Key"
        '
        'ListView1
        '
        Me.ListView1.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader1, Me.BetterListViewColumnHeader2, Me.BetterListViewColumnHeader3})
        Me.ListView1.ContextMenuStrip = Me.CMS_LV
        Me.ListView1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ListView1.ImageList = Me.ImageList_ListView
        Me.ListView1.Location = New System.Drawing.Point(0, 0)
        Me.ListView1.Name = "ListView1"
        Me.ListView1.Size = New System.Drawing.Size(523, 394)
        Me.ListView1.TabIndex = 0
        '
        'BetterListViewColumnHeader1
        '
        Me.BetterListViewColumnHeader1.Name = "BetterListViewColumnHeader1"
        Me.BetterListViewColumnHeader1.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader1.Text = "Name"
        Me.BetterListViewColumnHeader1.Width = 196
        '
        'BetterListViewColumnHeader2
        '
        Me.BetterListViewColumnHeader2.Name = "BetterListViewColumnHeader2"
        Me.BetterListViewColumnHeader2.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader2.Text = "Type"
        Me.BetterListViewColumnHeader2.Width = 114
        '
        'BetterListViewColumnHeader3
        '
        Me.BetterListViewColumnHeader3.Name = "BetterListViewColumnHeader3"
        Me.BetterListViewColumnHeader3.Style = ComponentOwl.BetterListView.BetterListViewColumnHeaderStyle.Sortable
        Me.BetterListViewColumnHeader3.Text = "Value"
        Me.BetterListViewColumnHeader3.Width = 185
        '
        'CMS_LV
        '
        Me.CMS_LV.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.NewToolStripMenuItem, Me.ModifyToolStripMenuItem, Me.DeleteToolStripMenuItem, Me.CopyToolStripMenuItem})
        Me.CMS_LV.Name = "CMS_LV"
        Me.CMS_LV.Size = New System.Drawing.Size(113, 92)
        '
        'NewToolStripMenuItem
        '
        Me.NewToolStripMenuItem.Image = CType(resources.GetObject("NewToolStripMenuItem.Image"), System.Drawing.Image)
        Me.NewToolStripMenuItem.Name = "NewToolStripMenuItem"
        Me.NewToolStripMenuItem.Size = New System.Drawing.Size(112, 22)
        Me.NewToolStripMenuItem.Text = "New"
        '
        'ModifyToolStripMenuItem
        '
        Me.ModifyToolStripMenuItem.Image = CType(resources.GetObject("ModifyToolStripMenuItem.Image"), System.Drawing.Image)
        Me.ModifyToolStripMenuItem.Name = "ModifyToolStripMenuItem"
        Me.ModifyToolStripMenuItem.Size = New System.Drawing.Size(112, 22)
        Me.ModifyToolStripMenuItem.Text = "Modify"
        '
        'DeleteToolStripMenuItem
        '
        Me.DeleteToolStripMenuItem.Image = CType(resources.GetObject("DeleteToolStripMenuItem.Image"), System.Drawing.Image)
        Me.DeleteToolStripMenuItem.Name = "DeleteToolStripMenuItem"
        Me.DeleteToolStripMenuItem.Size = New System.Drawing.Size(112, 22)
        Me.DeleteToolStripMenuItem.Text = "Delete"
        '
        'CopyToolStripMenuItem
        '
        Me.CopyToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.NameToolStripMenuItem, Me.ValueToolStripMenuItem})
        Me.CopyToolStripMenuItem.Image = CType(resources.GetObject("CopyToolStripMenuItem.Image"), System.Drawing.Image)
        Me.CopyToolStripMenuItem.Name = "CopyToolStripMenuItem"
        Me.CopyToolStripMenuItem.Size = New System.Drawing.Size(112, 22)
        Me.CopyToolStripMenuItem.Text = "Copy"
        '
        'NameToolStripMenuItem
        '
        Me.NameToolStripMenuItem.Name = "NameToolStripMenuItem"
        Me.NameToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.NameToolStripMenuItem.Text = "Name"
        '
        'ValueToolStripMenuItem
        '
        Me.ValueToolStripMenuItem.Name = "ValueToolStripMenuItem"
        Me.ValueToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.ValueToolStripMenuItem.Text = "Value"
        '
        'ImageList_ListView
        '
        Me.ImageList_ListView.ImageStream = CType(resources.GetObject("ImageList_ListView.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ImageList_ListView.TransparentColor = System.Drawing.Color.Transparent
        Me.ImageList_ListView.Images.SetKeyName(0, "blue-document-attribute.png")
        Me.ImageList_ListView.Images.SetKeyName(1, "document-binary.png")
        '
        'ImageList_TreeView
        '
        Me.ImageList_TreeView.ImageStream = CType(resources.GetObject("ImageList_TreeView.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ImageList_TreeView.TransparentColor = System.Drawing.Color.Transparent
        Me.ImageList_TreeView.Images.SetKeyName(0, "folder-horizontal.png")
        '
        'RegistryManager
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(790, 416)
        Me.Controls.Add(Me.SplitContainer1)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Name = "RegistryManager"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Registry Manager -"
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        CType(Me.SplitContainer1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SplitContainer1.ResumeLayout(False)
        Me.CMS_TreeView.ResumeLayout(False)
        CType(Me.ListView1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.CMS_LV.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents Label_Information As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents SplitContainer1 As System.Windows.Forms.SplitContainer
    Friend WithEvents TreeView1 As System.Windows.Forms.TreeView
    Friend WithEvents CMS_TreeView As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents CreateNewSubKeyToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DeleteKeyToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CMS_LV As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents NewToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ModifyToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DeleteToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CopyToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents NameToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ValueToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ListView1 As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents BetterListViewColumnHeader1 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader2 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader3 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents ImageList_ListView As System.Windows.Forms.ImageList
    Friend WithEvents ImageList_TreeView As System.Windows.Forms.ImageList
End Class
