<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Scripting
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(Scripting))
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip()
        Me.ToolStripStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.CustomTabcontrol1 = New LuxNET.CustomTabcontrol()
        Me.TabPage1 = New System.Windows.Forms.TabPage()
        Me.Button3 = New System.Windows.Forms.Button()
        Me.Button4 = New System.Windows.Forms.Button()
        Me.rtb_html = New System.Windows.Forms.RichTextBox()
        Me.TabPage2 = New System.Windows.Forms.TabPage()
        Me.Button1 = New System.Windows.Forms.Button()
        Me.Button2 = New System.Windows.Forms.Button()
        Me.rtb_batch = New System.Windows.Forms.RichTextBox()
        Me.TabPage3 = New System.Windows.Forms.TabPage()
        Me.Button5 = New System.Windows.Forms.Button()
        Me.btn_test = New System.Windows.Forms.Button()
        Me.rtb_vbs = New System.Windows.Forms.RichTextBox()
        Me.ImageList1 = New System.Windows.Forms.ImageList(Me.components)
        Me.StatusStrip1.SuspendLayout()
        Me.CustomTabcontrol1.SuspendLayout()
        Me.TabPage1.SuspendLayout()
        Me.TabPage2.SuspendLayout()
        Me.TabPage3.SuspendLayout()
        Me.SuspendLayout()
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripStatusLabel1})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 277)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(586, 22)
        Me.StatusStrip1.TabIndex = 0
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'ToolStripStatusLabel1
        '
        Me.ToolStripStatusLabel1.Name = "ToolStripStatusLabel1"
        Me.ToolStripStatusLabel1.Size = New System.Drawing.Size(0, 17)
        '
        'CustomTabcontrol1
        '
        Me.CustomTabcontrol1.Alignment = System.Windows.Forms.TabAlignment.Left
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage1)
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage2)
        Me.CustomTabcontrol1.Controls.Add(Me.TabPage3)
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
        Me.CustomTabcontrol1.Size = New System.Drawing.Size(586, 277)
        Me.CustomTabcontrol1.SizeMode = System.Windows.Forms.TabSizeMode.Fixed
        Me.CustomTabcontrol1.TabIndex = 1
        '
        'TabPage1
        '
        Me.TabPage1.Controls.Add(Me.Button3)
        Me.TabPage1.Controls.Add(Me.Button4)
        Me.TabPage1.Controls.Add(Me.rtb_html)
        Me.TabPage1.Location = New System.Drawing.Point(154, 4)
        Me.TabPage1.Name = "TabPage1"
        Me.TabPage1.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage1.Size = New System.Drawing.Size(428, 269)
        Me.TabPage1.TabIndex = 0
        Me.TabPage1.Text = "HTML"
        Me.TabPage1.UseVisualStyleBackColor = True
        '
        'Button3
        '
        Me.Button3.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Button3.Location = New System.Drawing.Point(322, 234)
        Me.Button3.Name = "Button3"
        Me.Button3.Size = New System.Drawing.Size(100, 27)
        Me.Button3.TabIndex = 2
        Me.Button3.Text = "Run Script"
        Me.Button3.UseVisualStyleBackColor = True
        '
        'Button4
        '
        Me.Button4.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Button4.Location = New System.Drawing.Point(213, 234)
        Me.Button4.Name = "Button4"
        Me.Button4.Size = New System.Drawing.Size(103, 27)
        Me.Button4.TabIndex = 1
        Me.Button4.Text = "Test Script"
        Me.Button4.UseVisualStyleBackColor = True
        '
        'rtb_html
        '
        Me.rtb_html.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.rtb_html.Location = New System.Drawing.Point(3, 2)
        Me.rtb_html.Name = "rtb_html"
        Me.rtb_html.Size = New System.Drawing.Size(420, 229)
        Me.rtb_html.TabIndex = 0
        Me.rtb_html.Text = ""
        '
        'TabPage2
        '
        Me.TabPage2.Controls.Add(Me.Button1)
        Me.TabPage2.Controls.Add(Me.Button2)
        Me.TabPage2.Controls.Add(Me.rtb_batch)
        Me.TabPage2.Location = New System.Drawing.Point(154, 4)
        Me.TabPage2.Name = "TabPage2"
        Me.TabPage2.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage2.Size = New System.Drawing.Size(428, 269)
        Me.TabPage2.TabIndex = 1
        Me.TabPage2.Text = "Batch"
        Me.TabPage2.UseVisualStyleBackColor = True
        '
        'Button1
        '
        Me.Button1.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Button1.Location = New System.Drawing.Point(322, 234)
        Me.Button1.Name = "Button1"
        Me.Button1.Size = New System.Drawing.Size(100, 27)
        Me.Button1.TabIndex = 5
        Me.Button1.Text = "Run Script"
        Me.Button1.UseVisualStyleBackColor = True
        '
        'Button2
        '
        Me.Button2.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Button2.Location = New System.Drawing.Point(213, 234)
        Me.Button2.Name = "Button2"
        Me.Button2.Size = New System.Drawing.Size(103, 27)
        Me.Button2.TabIndex = 4
        Me.Button2.Text = "Test Script"
        Me.Button2.UseVisualStyleBackColor = True
        '
        'rtb_batch
        '
        Me.rtb_batch.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.rtb_batch.Location = New System.Drawing.Point(3, 2)
        Me.rtb_batch.Name = "rtb_batch"
        Me.rtb_batch.Size = New System.Drawing.Size(420, 229)
        Me.rtb_batch.TabIndex = 3
        Me.rtb_batch.Text = ""
        '
        'TabPage3
        '
        Me.TabPage3.Controls.Add(Me.Button5)
        Me.TabPage3.Controls.Add(Me.btn_test)
        Me.TabPage3.Controls.Add(Me.rtb_vbs)
        Me.TabPage3.Location = New System.Drawing.Point(154, 4)
        Me.TabPage3.Name = "TabPage3"
        Me.TabPage3.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage3.Size = New System.Drawing.Size(428, 269)
        Me.TabPage3.TabIndex = 2
        Me.TabPage3.Text = "VBS"
        Me.TabPage3.UseVisualStyleBackColor = True
        '
        'Button5
        '
        Me.Button5.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Button5.Location = New System.Drawing.Point(322, 234)
        Me.Button5.Name = "Button5"
        Me.Button5.Size = New System.Drawing.Size(100, 27)
        Me.Button5.TabIndex = 5
        Me.Button5.Text = "Run Script"
        Me.Button5.UseVisualStyleBackColor = True
        '
        'btn_test
        '
        Me.btn_test.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btn_test.Location = New System.Drawing.Point(213, 234)
        Me.btn_test.Name = "btn_test"
        Me.btn_test.Size = New System.Drawing.Size(103, 27)
        Me.btn_test.TabIndex = 4
        Me.btn_test.Text = "Test Script"
        Me.btn_test.UseVisualStyleBackColor = True
        '
        'rtb_vbs
        '
        Me.rtb_vbs.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.rtb_vbs.Location = New System.Drawing.Point(3, 2)
        Me.rtb_vbs.Name = "rtb_vbs"
        Me.rtb_vbs.Size = New System.Drawing.Size(420, 229)
        Me.rtb_vbs.TabIndex = 3
        Me.rtb_vbs.Text = ""
        '
        'ImageList1
        '
        Me.ImageList1.ImageStream = CType(resources.GetObject("ImageList1.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ImageList1.TransparentColor = System.Drawing.Color.Transparent
        Me.ImageList1.Images.SetKeyName(0, "html.png")
        Me.ImageList1.Images.SetKeyName(1, "ms_dos_batch_file.png")
        Me.ImageList1.Images.SetKeyName(2, "vbs.png")
        '
        'Scripting
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(586, 299)
        Me.Controls.Add(Me.CustomTabcontrol1)
        Me.Controls.Add(Me.StatusStrip1)
        Me.MinimumSize = New System.Drawing.Size(602, 338)
        Me.Name = "Scripting"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Scripting -"
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.CustomTabcontrol1.ResumeLayout(False)
        Me.TabPage1.ResumeLayout(False)
        Me.TabPage2.ResumeLayout(False)
        Me.TabPage3.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents TabPage1 As System.Windows.Forms.TabPage
    Friend WithEvents Button3 As System.Windows.Forms.Button
    Friend WithEvents Button4 As System.Windows.Forms.Button
    Friend WithEvents rtb_html As System.Windows.Forms.RichTextBox
    Friend WithEvents TabPage2 As System.Windows.Forms.TabPage
    Friend WithEvents Button1 As System.Windows.Forms.Button
    Friend WithEvents Button2 As System.Windows.Forms.Button
    Friend WithEvents rtb_batch As System.Windows.Forms.RichTextBox
    Friend WithEvents TabPage3 As System.Windows.Forms.TabPage
    Friend WithEvents Button5 As System.Windows.Forms.Button
    Friend WithEvents btn_test As System.Windows.Forms.Button
    Friend WithEvents rtb_vbs As System.Windows.Forms.RichTextBox
    Friend WithEvents ToolStripStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents CustomTabcontrol1 As LuxNET.CustomTabcontrol
    Friend WithEvents ImageList1 As System.Windows.Forms.ImageList
End Class
