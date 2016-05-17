<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Keylogger
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(Keylogger))
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.CheckBox1 = New System.Windows.Forms.CheckBox()
        Me.btn_save = New System.Windows.Forms.Button()
        Me.btn_clear = New System.Windows.Forms.Button()
        Me.btn_stop = New System.Windows.Forms.Button()
        Me.btn_start = New System.Windows.Forms.Button()
        Me.rtb_log = New System.Windows.Forms.RichTextBox()
        Me.t = New System.Windows.Forms.Timer(Me.components)
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Controls.Add(Me.CheckBox1)
        Me.GroupBox1.Controls.Add(Me.btn_save)
        Me.GroupBox1.Controls.Add(Me.btn_clear)
        Me.GroupBox1.Controls.Add(Me.btn_stop)
        Me.GroupBox1.Controls.Add(Me.btn_start)
        Me.GroupBox1.Location = New System.Drawing.Point(11, 13)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(169, 231)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "KeyLogger's Options"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(25, 205)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(63, 13)
        Me.Label1.TabIndex = 7
        Me.Label1.Text = "Status: Idle"
        '
        'CheckBox1
        '
        Me.CheckBox1.AutoSize = True
        Me.CheckBox1.Location = New System.Drawing.Point(46, 172)
        Me.CheckBox1.Name = "CheckBox1"
        Me.CheckBox1.Size = New System.Drawing.Size(89, 17)
        Me.CheckBox1.TabIndex = 6
        Me.CheckBox1.Text = "Colorize Logs"
        Me.CheckBox1.UseVisualStyleBackColor = True
        '
        'btn_save
        '
        Me.btn_save.Image = CType(resources.GetObject("btn_save.Image"), System.Drawing.Image)
        Me.btn_save.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_save.Location = New System.Drawing.Point(6, 125)
        Me.btn_save.Name = "btn_save"
        Me.btn_save.Size = New System.Drawing.Size(157, 27)
        Me.btn_save.TabIndex = 5
        Me.btn_save.Text = "Save Logs"
        Me.btn_save.UseVisualStyleBackColor = True
        '
        'btn_clear
        '
        Me.btn_clear.Image = CType(resources.GetObject("btn_clear.Image"), System.Drawing.Image)
        Me.btn_clear.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_clear.Location = New System.Drawing.Point(6, 92)
        Me.btn_clear.Name = "btn_clear"
        Me.btn_clear.Size = New System.Drawing.Size(157, 27)
        Me.btn_clear.TabIndex = 4
        Me.btn_clear.Text = "Clear Logs"
        Me.btn_clear.UseVisualStyleBackColor = True
        '
        'btn_stop
        '
        Me.btn_stop.Enabled = False
        Me.btn_stop.Image = CType(resources.GetObject("btn_stop.Image"), System.Drawing.Image)
        Me.btn_stop.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_stop.Location = New System.Drawing.Point(6, 59)
        Me.btn_stop.Name = "btn_stop"
        Me.btn_stop.Size = New System.Drawing.Size(157, 27)
        Me.btn_stop.TabIndex = 3
        Me.btn_stop.Text = "Stop Live Logger"
        Me.btn_stop.UseVisualStyleBackColor = True
        '
        'btn_start
        '
        Me.btn_start.Image = CType(resources.GetObject("btn_start.Image"), System.Drawing.Image)
        Me.btn_start.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_start.Location = New System.Drawing.Point(6, 26)
        Me.btn_start.Name = "btn_start"
        Me.btn_start.Size = New System.Drawing.Size(157, 27)
        Me.btn_start.TabIndex = 2
        Me.btn_start.Text = "Start Live Logger"
        Me.btn_start.UseVisualStyleBackColor = True
        '
        'rtb_log
        '
        Me.rtb_log.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.rtb_log.Location = New System.Drawing.Point(186, 0)
        Me.rtb_log.Name = "rtb_log"
        Me.rtb_log.Size = New System.Drawing.Size(464, 270)
        Me.rtb_log.TabIndex = 1
        Me.rtb_log.Text = ""
        '
        't
        '
        '
        'Keylogger
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(650, 270)
        Me.Controls.Add(Me.rtb_log)
        Me.Controls.Add(Me.GroupBox1)
        Me.MinimumSize = New System.Drawing.Size(666, 288)
        Me.Name = "Keylogger"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Keylogger-"
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents CheckBox1 As System.Windows.Forms.CheckBox
    Friend WithEvents btn_save As System.Windows.Forms.Button
    Friend WithEvents btn_clear As System.Windows.Forms.Button
    Friend WithEvents btn_stop As System.Windows.Forms.Button
    Friend WithEvents btn_start As System.Windows.Forms.Button
    Friend WithEvents rtb_log As System.Windows.Forms.RichTextBox
    Friend WithEvents t As System.Windows.Forms.Timer
End Class
