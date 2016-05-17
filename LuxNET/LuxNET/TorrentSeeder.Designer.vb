<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class TorrentSeeder
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
        Me.LV_Clients = New ComponentOwl.BetterListView.BetterListView()
        Me.BetterListViewColumnHeader1 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.BetterListViewColumnHeader2 = New ComponentOwl.BetterListView.BetterListViewColumnHeader()
        Me.ContextMenuStrip1 = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.StartSeedingFromLocalFileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.StartSeedingFileFromServerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        CType(Me.LV_Clients, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ContextMenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'LV_Clients
        '
        Me.LV_Clients.Columns.AddRange(New Object() {Me.BetterListViewColumnHeader1, Me.BetterListViewColumnHeader2})
        Me.LV_Clients.ContextMenuStrip = Me.ContextMenuStrip1
        Me.LV_Clients.Location = New System.Drawing.Point(6, 6)
        Me.LV_Clients.Name = "LV_Clients"
        Me.LV_Clients.Size = New System.Drawing.Size(654, 354)
        Me.LV_Clients.TabIndex = 0
        '
        'BetterListViewColumnHeader1
        '
        Me.BetterListViewColumnHeader1.Name = "BetterListViewColumnHeader1"
        Me.BetterListViewColumnHeader1.Text = "Client"
        Me.BetterListViewColumnHeader1.Width = 360
        '
        'BetterListViewColumnHeader2
        '
        Me.BetterListViewColumnHeader2.Name = "BetterListViewColumnHeader2"
        Me.BetterListViewColumnHeader2.Text = "Status"
        Me.BetterListViewColumnHeader2.Width = 245
        '
        'ContextMenuStrip1
        '
        Me.ContextMenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.StartSeedingFromLocalFileToolStripMenuItem, Me.StartSeedingFileFromServerToolStripMenuItem})
        Me.ContextMenuStrip1.Name = "ContextMenuStrip1"
        Me.ContextMenuStrip1.Size = New System.Drawing.Size(229, 70)
        '
        'StartSeedingFromLocalFileToolStripMenuItem
        '
        Me.StartSeedingFromLocalFileToolStripMenuItem.Name = "StartSeedingFromLocalFileToolStripMenuItem"
        Me.StartSeedingFromLocalFileToolStripMenuItem.Size = New System.Drawing.Size(228, 22)
        Me.StartSeedingFromLocalFileToolStripMenuItem.Text = "Start Seeding from local File"
        '
        'StartSeedingFileFromServerToolStripMenuItem
        '
        Me.StartSeedingFileFromServerToolStripMenuItem.Name = "StartSeedingFileFromServerToolStripMenuItem"
        Me.StartSeedingFileFromServerToolStripMenuItem.Size = New System.Drawing.Size(228, 22)
        Me.StartSeedingFileFromServerToolStripMenuItem.Text = "Start Seeding File from Server"
        '
        'TorrentSeeder
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(667, 366)
        Me.Controls.Add(Me.LV_Clients)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.MaximizeBox = False
        Me.Name = "TorrentSeeder"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "TorrentSeeder"
        CType(Me.LV_Clients, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ContextMenuStrip1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents LV_Clients As ComponentOwl.BetterListView.BetterListView
    Friend WithEvents BetterListViewColumnHeader1 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents BetterListViewColumnHeader2 As ComponentOwl.BetterListView.BetterListViewColumnHeader
    Friend WithEvents ContextMenuStrip1 As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents StartSeedingFromLocalFileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents StartSeedingFileFromServerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
End Class
