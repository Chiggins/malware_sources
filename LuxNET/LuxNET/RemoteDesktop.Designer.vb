<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class RemoteDesktop
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(RemoteDesktop))
        Me.Panel2 = New System.Windows.Forms.Panel()
        Me.Panel1 = New System.Windows.Forms.Panel()
        Me.PanelItems = New System.Windows.Forms.Panel()
        Me.btn_block = New System.Windows.Forms.Button()
        Me.LabelFPS = New System.Windows.Forms.Label()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.Label_Mouse = New System.Windows.Forms.Label()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.ComboBox1 = New System.Windows.Forms.ComboBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.Label1444 = New System.Windows.Forms.Label()
        Me.btn_keyboard = New System.Windows.Forms.Button()
        Me.btn_control = New System.Windows.Forms.Button()
        Me.Seperator = New System.Windows.Forms.Label()
        Me.btn_start = New System.Windows.Forms.Button()
        Me.PictureBox1 = New System.Windows.Forms.PictureBox()
        Me.Panel2.SuspendLayout()
        Me.PanelItems.SuspendLayout()
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Panel2
        '
        Me.Panel2.Controls.Add(Me.PanelItems)
        Me.Panel2.Location = New System.Drawing.Point(109, 2)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(484, 47)
        Me.Panel2.TabIndex = 5
        Me.Panel2.Visible = False
        '
        'Panel1
        '
        Me.Panel1.BackgroundImage = CType(resources.GetObject("Panel1.BackgroundImage"), System.Drawing.Image)
        Me.Panel1.Location = New System.Drawing.Point(333, 2)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(25, 25)
        Me.Panel1.TabIndex = 13
        Me.Panel1.Visible = False
        '
        'PanelItems
        '
        Me.PanelItems.Controls.Add(Me.btn_block)
        Me.PanelItems.Controls.Add(Me.LabelFPS)
        Me.PanelItems.Controls.Add(Me.Label6)
        Me.PanelItems.Controls.Add(Me.Label_Mouse)
        Me.PanelItems.Controls.Add(Me.Label3)
        Me.PanelItems.Controls.Add(Me.ComboBox1)
        Me.PanelItems.Controls.Add(Me.Label1)
        Me.PanelItems.Controls.Add(Me.Label1444)
        Me.PanelItems.Controls.Add(Me.btn_keyboard)
        Me.PanelItems.Controls.Add(Me.btn_control)
        Me.PanelItems.Controls.Add(Me.Seperator)
        Me.PanelItems.Controls.Add(Me.btn_start)
        Me.PanelItems.Location = New System.Drawing.Point(3, 3)
        Me.PanelItems.Name = "PanelItems"
        Me.PanelItems.Size = New System.Drawing.Size(478, 41)
        Me.PanelItems.TabIndex = 2
        '
        'btn_block
        '
        Me.btn_block.BackColor = System.Drawing.Color.White
        Me.btn_block.BackgroundImage = CType(resources.GetObject("btn_block.BackgroundImage"), System.Drawing.Image)
        Me.btn_block.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch
        Me.btn_block.Location = New System.Drawing.Point(451, 7)
        Me.btn_block.Name = "btn_block"
        Me.btn_block.Size = New System.Drawing.Size(24, 24)
        Me.btn_block.TabIndex = 12
        Me.btn_block.UseVisualStyleBackColor = False
        '
        'LabelFPS
        '
        Me.LabelFPS.AutoSize = True
        Me.LabelFPS.Location = New System.Drawing.Point(401, 14)
        Me.LabelFPS.Name = "LabelFPS"
        Me.LabelFPS.Size = New System.Drawing.Size(38, 13)
        Me.LabelFPS.TabIndex = 11
        Me.LabelFPS.Text = "FPS: 0"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(383, 5)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(11, 26)
        Me.Label6.TabIndex = 10
        Me.Label6.Text = "|" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "|"
        '
        'Label_Mouse
        '
        Me.Label_Mouse.AutoSize = True
        Me.Label_Mouse.Location = New System.Drawing.Point(241, 14)
        Me.Label_Mouse.Name = "Label_Mouse"
        Me.Label_Mouse.Size = New System.Drawing.Size(127, 13)
        Me.Label_Mouse.TabIndex = 8
        Me.Label_Mouse.Text = "Mouse Position: X:0 | Y:0"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(218, 5)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(11, 26)
        Me.Label3.TabIndex = 7
        Me.Label3.Text = "|" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "|"
        '
        'ComboBox1
        '
        Me.ComboBox1.FormattingEnabled = True
        Me.ComboBox1.Location = New System.Drawing.Point(162, 10)
        Me.ComboBox1.Name = "ComboBox1"
        Me.ComboBox1.Size = New System.Drawing.Size(49, 21)
        Me.ComboBox1.TabIndex = 6
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(108, 14)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(50, 13)
        Me.Label1.TabIndex = 5
        Me.Label1.Text = "Monitor :"
        '
        'Label1444
        '
        Me.Label1444.AutoSize = True
        Me.Label1444.Location = New System.Drawing.Point(96, 5)
        Me.Label1444.Name = "Label1444"
        Me.Label1444.Size = New System.Drawing.Size(11, 26)
        Me.Label1444.TabIndex = 4
        Me.Label1444.Text = "|" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "|"
        '
        'btn_keyboard
        '
        Me.btn_keyboard.BackColor = System.Drawing.Color.White
        Me.btn_keyboard.BackgroundImage = CType(resources.GetObject("btn_keyboard.BackgroundImage"), System.Drawing.Image)
        Me.btn_keyboard.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch
        Me.btn_keyboard.Location = New System.Drawing.Point(70, 8)
        Me.btn_keyboard.Name = "btn_keyboard"
        Me.btn_keyboard.Size = New System.Drawing.Size(24, 24)
        Me.btn_keyboard.TabIndex = 3
        Me.btn_keyboard.UseVisualStyleBackColor = False
        '
        'btn_control
        '
        Me.btn_control.BackColor = System.Drawing.Color.White
        Me.btn_control.BackgroundImage = CType(resources.GetObject("btn_control.BackgroundImage"), System.Drawing.Image)
        Me.btn_control.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch
        Me.btn_control.Location = New System.Drawing.Point(40, 8)
        Me.btn_control.Name = "btn_control"
        Me.btn_control.Size = New System.Drawing.Size(24, 24)
        Me.btn_control.TabIndex = 2
        Me.btn_control.UseVisualStyleBackColor = False
        '
        'Seperator
        '
        Me.Seperator.AutoSize = True
        Me.Seperator.Location = New System.Drawing.Point(28, 5)
        Me.Seperator.Name = "Seperator"
        Me.Seperator.Size = New System.Drawing.Size(11, 26)
        Me.Seperator.TabIndex = 1
        Me.Seperator.Text = "|" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "|"
        '
        'btn_start
        '
        Me.btn_start.BackColor = System.Drawing.Color.White
        Me.btn_start.BackgroundImage = CType(resources.GetObject("btn_start.BackgroundImage"), System.Drawing.Image)
        Me.btn_start.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch
        Me.btn_start.Location = New System.Drawing.Point(3, 8)
        Me.btn_start.Name = "btn_start"
        Me.btn_start.Size = New System.Drawing.Size(24, 24)
        Me.btn_start.TabIndex = 0
        Me.btn_start.UseVisualStyleBackColor = False
        '
        'PictureBox1
        '
        Me.PictureBox1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.PictureBox1.Location = New System.Drawing.Point(0, 0)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(702, 388)
        Me.PictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
        Me.PictureBox1.TabIndex = 4
        Me.PictureBox1.TabStop = False
        '
        'RemoteDesktop
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(702, 388)
        Me.Controls.Add(Me.Panel1)
        Me.Controls.Add(Me.Panel2)
        Me.Controls.Add(Me.PictureBox1)
        Me.Name = "RemoteDesktop"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Remote Desktop - "
        Me.Panel2.ResumeLayout(False)
        Me.PanelItems.ResumeLayout(False)
        Me.PanelItems.PerformLayout()
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents Panel2 As System.Windows.Forms.Panel
    Friend WithEvents PanelItems As System.Windows.Forms.Panel
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents btn_block As System.Windows.Forms.Button
    Friend WithEvents LabelFPS As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents Label_Mouse As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents ComboBox1 As System.Windows.Forms.ComboBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label1444 As System.Windows.Forms.Label
    Friend WithEvents btn_keyboard As System.Windows.Forms.Button
    Friend WithEvents btn_control As System.Windows.Forms.Button
    Friend WithEvents Seperator As System.Windows.Forms.Label
    Friend WithEvents btn_start As System.Windows.Forms.Button
    Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
End Class
