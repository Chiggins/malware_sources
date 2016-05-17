<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MapView
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
        Me.pb_map = New System.Windows.Forms.PictureBox()
        Me.lbl_Info = New System.Windows.Forms.Label()
        CType(Me.pb_map, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'pb_map
        '
        Me.pb_map.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pb_map.Location = New System.Drawing.Point(0, 0)
        Me.pb_map.Name = "pb_map"
        Me.pb_map.Size = New System.Drawing.Size(648, 363)
        Me.pb_map.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
        Me.pb_map.TabIndex = 0
        Me.pb_map.TabStop = False
        '
        'lbl_Info
        '
        Me.lbl_Info.AutoSize = True
        Me.lbl_Info.Location = New System.Drawing.Point(12, 12)
        Me.lbl_Info.Name = "lbl_Info"
        Me.lbl_Info.Size = New System.Drawing.Size(0, 13)
        Me.lbl_Info.TabIndex = 1
        '
        'MapView
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(648, 363)
        Me.Controls.Add(Me.lbl_Info)
        Me.Controls.Add(Me.pb_map)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "MapView"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "MapView"
        CType(Me.pb_map, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents pb_map As System.Windows.Forms.PictureBox
    Friend WithEvents lbl_Info As System.Windows.Forms.Label
End Class
