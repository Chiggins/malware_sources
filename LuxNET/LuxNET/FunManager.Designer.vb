<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FunManager
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(FunManager))
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.Button11 = New System.Windows.Forms.Button()
        Me.cb_silent = New System.Windows.Forms.CheckBox()
        Me.NUD_websitetimes = New System.Windows.Forms.NumericUpDown()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.tb_weburl = New System.Windows.Forms.TextBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.GroupBox2 = New System.Windows.Forms.GroupBox()
        Me.btn_stopdiscomouse = New System.Windows.Forms.Button()
        Me.btn_discomouse = New System.Windows.Forms.Button()
        Me.btn_undomouse = New System.Windows.Forms.Button()
        Me.btn_mouseswap = New System.Windows.Forms.Button()
        Me.GroupBox3 = New System.Windows.Forms.GroupBox()
        Me.btn_speak = New System.Windows.Forms.Button()
        Me.btn_changewp = New System.Windows.Forms.Button()
        Me.btn_closecd = New System.Windows.Forms.Button()
        Me.btn_opencd = New System.Windows.Forms.Button()
        Me.btn_showdi = New System.Windows.Forms.Button()
        Me.btn_hidedi = New System.Windows.Forms.Button()
        Me.btn_showtb = New System.Windows.Forms.Button()
        Me.btn_hidetb = New System.Windows.Forms.Button()
        Me.btn_hibernate = New System.Windows.Forms.Button()
        Me.btn_restart = New System.Windows.Forms.Button()
        Me.btn_logoff = New System.Windows.Forms.Button()
        Me.btn_shutdown = New System.Windows.Forms.Button()
        Me.GroupBox4 = New System.Windows.Forms.GroupBox()
        Me.btn_capslock = New System.Windows.Forms.Button()
        Me.Button2 = New System.Windows.Forms.Button()
        Me.Button4 = New System.Windows.Forms.Button()
        Me.Button3 = New System.Windows.Forms.Button()
        Me.Button1 = New System.Windows.Forms.Button()
        Me.Button7 = New System.Windows.Forms.Button()
        Me.Button6 = New System.Windows.Forms.Button()
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip()
        Me.ToolStripStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.GroupBox1.SuspendLayout()
        CType(Me.NUD_websitetimes, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox2.SuspendLayout()
        Me.GroupBox3.SuspendLayout()
        Me.GroupBox4.SuspendLayout()
        Me.StatusStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.Button11)
        Me.GroupBox1.Controls.Add(Me.cb_silent)
        Me.GroupBox1.Controls.Add(Me.NUD_websitetimes)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.tb_weburl)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Location = New System.Drawing.Point(12, 6)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(272, 102)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Wensite Viewer"
        '
        'Button11
        '
        Me.Button11.Image = CType(resources.GetObject("Button11.Image"), System.Drawing.Image)
        Me.Button11.Location = New System.Drawing.Point(230, 72)
        Me.Button11.Name = "Button11"
        Me.Button11.Size = New System.Drawing.Size(36, 23)
        Me.Button11.TabIndex = 6
        Me.Button11.UseVisualStyleBackColor = True
        '
        'cb_silent
        '
        Me.cb_silent.AutoSize = True
        Me.cb_silent.Location = New System.Drawing.Point(167, 76)
        Me.cb_silent.Name = "cb_silent"
        Me.cb_silent.Size = New System.Drawing.Size(52, 17)
        Me.cb_silent.TabIndex = 5
        Me.cb_silent.Text = "Silent"
        Me.cb_silent.UseVisualStyleBackColor = True
        '
        'NUD_websitetimes
        '
        Me.NUD_websitetimes.Location = New System.Drawing.Point(55, 49)
        Me.NUD_websitetimes.Name = "NUD_websitetimes"
        Me.NUD_websitetimes.Size = New System.Drawing.Size(176, 20)
        Me.NUD_websitetimes.TabIndex = 4
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(237, 51)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(29, 13)
        Me.Label3.TabIndex = 3
        Me.Label3.Text = "Time"
        '
        'tb_weburl
        '
        Me.tb_weburl.Location = New System.Drawing.Point(55, 23)
        Me.tb_weburl.Name = "tb_weburl"
        Me.tb_weburl.Size = New System.Drawing.Size(211, 20)
        Me.tb_weburl.TabIndex = 2
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(16, 51)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(40, 13)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "Open :"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(16, 26)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(33, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "URL :"
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.btn_stopdiscomouse)
        Me.GroupBox2.Controls.Add(Me.btn_discomouse)
        Me.GroupBox2.Controls.Add(Me.btn_undomouse)
        Me.GroupBox2.Controls.Add(Me.btn_mouseswap)
        Me.GroupBox2.Location = New System.Drawing.Point(11, 116)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(272, 87)
        Me.GroupBox2.TabIndex = 1
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Mouse"
        '
        'btn_stopdiscomouse
        '
        Me.btn_stopdiscomouse.Image = CType(resources.GetObject("btn_stopdiscomouse.Image"), System.Drawing.Image)
        Me.btn_stopdiscomouse.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_stopdiscomouse.Location = New System.Drawing.Point(139, 48)
        Me.btn_stopdiscomouse.Name = "btn_stopdiscomouse"
        Me.btn_stopdiscomouse.Size = New System.Drawing.Size(127, 23)
        Me.btn_stopdiscomouse.TabIndex = 3
        Me.btn_stopdiscomouse.Text = "   Stop Disco Mouse"
        Me.btn_stopdiscomouse.UseVisualStyleBackColor = True
        '
        'btn_discomouse
        '
        Me.btn_discomouse.Image = CType(resources.GetObject("btn_discomouse.Image"), System.Drawing.Image)
        Me.btn_discomouse.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_discomouse.Location = New System.Drawing.Point(6, 48)
        Me.btn_discomouse.Name = "btn_discomouse"
        Me.btn_discomouse.Size = New System.Drawing.Size(127, 23)
        Me.btn_discomouse.TabIndex = 2
        Me.btn_discomouse.Text = "    Start Disco Mouse"
        Me.btn_discomouse.UseVisualStyleBackColor = True
        '
        'btn_undomouse
        '
        Me.btn_undomouse.Image = CType(resources.GetObject("btn_undomouse.Image"), System.Drawing.Image)
        Me.btn_undomouse.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_undomouse.Location = New System.Drawing.Point(139, 19)
        Me.btn_undomouse.Name = "btn_undomouse"
        Me.btn_undomouse.Size = New System.Drawing.Size(127, 23)
        Me.btn_undomouse.TabIndex = 1
        Me.btn_undomouse.Text = "  Undo Mouse Buttons"
        Me.btn_undomouse.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.btn_undomouse.UseVisualStyleBackColor = True
        '
        'btn_mouseswap
        '
        Me.btn_mouseswap.Image = CType(resources.GetObject("btn_mouseswap.Image"), System.Drawing.Image)
        Me.btn_mouseswap.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_mouseswap.Location = New System.Drawing.Point(6, 19)
        Me.btn_mouseswap.Name = "btn_mouseswap"
        Me.btn_mouseswap.Size = New System.Drawing.Size(127, 23)
        Me.btn_mouseswap.TabIndex = 0
        Me.btn_mouseswap.Text = "  Swap Mouse Buttons"
        Me.btn_mouseswap.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.btn_mouseswap.UseVisualStyleBackColor = True
        '
        'GroupBox3
        '
        Me.GroupBox3.Controls.Add(Me.btn_speak)
        Me.GroupBox3.Controls.Add(Me.btn_changewp)
        Me.GroupBox3.Controls.Add(Me.btn_closecd)
        Me.GroupBox3.Controls.Add(Me.btn_opencd)
        Me.GroupBox3.Controls.Add(Me.btn_showdi)
        Me.GroupBox3.Controls.Add(Me.btn_hidedi)
        Me.GroupBox3.Controls.Add(Me.btn_showtb)
        Me.GroupBox3.Controls.Add(Me.btn_hidetb)
        Me.GroupBox3.Controls.Add(Me.btn_hibernate)
        Me.GroupBox3.Controls.Add(Me.btn_restart)
        Me.GroupBox3.Controls.Add(Me.btn_logoff)
        Me.GroupBox3.Controls.Add(Me.btn_shutdown)
        Me.GroupBox3.Location = New System.Drawing.Point(290, 6)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(298, 197)
        Me.GroupBox3.TabIndex = 2
        Me.GroupBox3.TabStop = False
        Me.GroupBox3.Text = "Computer"
        '
        'btn_speak
        '
        Me.btn_speak.Image = CType(resources.GetObject("btn_speak.Image"), System.Drawing.Image)
        Me.btn_speak.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_speak.Location = New System.Drawing.Point(150, 163)
        Me.btn_speak.Name = "btn_speak"
        Me.btn_speak.Size = New System.Drawing.Size(127, 23)
        Me.btn_speak.TabIndex = 15
        Me.btn_speak.Text = "Speak Text"
        Me.btn_speak.UseVisualStyleBackColor = True
        '
        'btn_changewp
        '
        Me.btn_changewp.Image = CType(resources.GetObject("btn_changewp.Image"), System.Drawing.Image)
        Me.btn_changewp.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_changewp.Location = New System.Drawing.Point(17, 163)
        Me.btn_changewp.Name = "btn_changewp"
        Me.btn_changewp.Size = New System.Drawing.Size(127, 23)
        Me.btn_changewp.TabIndex = 14
        Me.btn_changewp.Text = "    Change Wallpaper"
        Me.btn_changewp.UseVisualStyleBackColor = True
        '
        'btn_closecd
        '
        Me.btn_closecd.Image = CType(resources.GetObject("btn_closecd.Image"), System.Drawing.Image)
        Me.btn_closecd.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_closecd.Location = New System.Drawing.Point(150, 134)
        Me.btn_closecd.Name = "btn_closecd"
        Me.btn_closecd.Size = New System.Drawing.Size(127, 23)
        Me.btn_closecd.TabIndex = 13
        Me.btn_closecd.Text = "Close CD Tray"
        Me.btn_closecd.UseVisualStyleBackColor = True
        '
        'btn_opencd
        '
        Me.btn_opencd.Image = CType(resources.GetObject("btn_opencd.Image"), System.Drawing.Image)
        Me.btn_opencd.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_opencd.Location = New System.Drawing.Point(17, 134)
        Me.btn_opencd.Name = "btn_opencd"
        Me.btn_opencd.Size = New System.Drawing.Size(127, 23)
        Me.btn_opencd.TabIndex = 12
        Me.btn_opencd.Text = "Open CD Tray"
        Me.btn_opencd.UseVisualStyleBackColor = True
        '
        'btn_showdi
        '
        Me.btn_showdi.Image = CType(resources.GetObject("btn_showdi.Image"), System.Drawing.Image)
        Me.btn_showdi.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_showdi.Location = New System.Drawing.Point(150, 108)
        Me.btn_showdi.Name = "btn_showdi"
        Me.btn_showdi.Size = New System.Drawing.Size(127, 23)
        Me.btn_showdi.TabIndex = 11
        Me.btn_showdi.Text = "    Show Desktop Icon"
        Me.btn_showdi.UseVisualStyleBackColor = True
        '
        'btn_hidedi
        '
        Me.btn_hidedi.Image = CType(resources.GetObject("btn_hidedi.Image"), System.Drawing.Image)
        Me.btn_hidedi.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_hidedi.Location = New System.Drawing.Point(17, 108)
        Me.btn_hidedi.Name = "btn_hidedi"
        Me.btn_hidedi.Size = New System.Drawing.Size(127, 23)
        Me.btn_hidedi.TabIndex = 10
        Me.btn_hidedi.Text = "    Hide Desktop Icon"
        Me.btn_hidedi.UseVisualStyleBackColor = True
        '
        'btn_showtb
        '
        Me.btn_showtb.Image = CType(resources.GetObject("btn_showtb.Image"), System.Drawing.Image)
        Me.btn_showtb.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_showtb.Location = New System.Drawing.Point(150, 79)
        Me.btn_showtb.Name = "btn_showtb"
        Me.btn_showtb.Size = New System.Drawing.Size(127, 23)
        Me.btn_showtb.TabIndex = 9
        Me.btn_showtb.Text = "Show TaskBar"
        Me.btn_showtb.UseVisualStyleBackColor = True
        '
        'btn_hidetb
        '
        Me.btn_hidetb.Image = CType(resources.GetObject("btn_hidetb.Image"), System.Drawing.Image)
        Me.btn_hidetb.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_hidetb.Location = New System.Drawing.Point(17, 79)
        Me.btn_hidetb.Name = "btn_hidetb"
        Me.btn_hidetb.Size = New System.Drawing.Size(127, 23)
        Me.btn_hidetb.TabIndex = 8
        Me.btn_hidetb.Text = "Hide TaskBar"
        Me.btn_hidetb.UseVisualStyleBackColor = True
        '
        'btn_hibernate
        '
        Me.btn_hibernate.Image = CType(resources.GetObject("btn_hibernate.Image"), System.Drawing.Image)
        Me.btn_hibernate.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_hibernate.Location = New System.Drawing.Point(150, 50)
        Me.btn_hibernate.Name = "btn_hibernate"
        Me.btn_hibernate.Size = New System.Drawing.Size(127, 23)
        Me.btn_hibernate.TabIndex = 7
        Me.btn_hibernate.Text = "Hibernat"
        Me.btn_hibernate.UseVisualStyleBackColor = True
        '
        'btn_restart
        '
        Me.btn_restart.Image = CType(resources.GetObject("btn_restart.Image"), System.Drawing.Image)
        Me.btn_restart.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_restart.Location = New System.Drawing.Point(17, 50)
        Me.btn_restart.Name = "btn_restart"
        Me.btn_restart.Size = New System.Drawing.Size(127, 23)
        Me.btn_restart.TabIndex = 6
        Me.btn_restart.Text = "    Restart Computer"
        Me.btn_restart.UseVisualStyleBackColor = True
        '
        'btn_logoff
        '
        Me.btn_logoff.Image = CType(resources.GetObject("btn_logoff.Image"), System.Drawing.Image)
        Me.btn_logoff.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_logoff.Location = New System.Drawing.Point(150, 21)
        Me.btn_logoff.Name = "btn_logoff"
        Me.btn_logoff.Size = New System.Drawing.Size(127, 23)
        Me.btn_logoff.TabIndex = 5
        Me.btn_logoff.Text = "    LogOut Computer"
        Me.btn_logoff.UseVisualStyleBackColor = True
        '
        'btn_shutdown
        '
        Me.btn_shutdown.Image = CType(resources.GetObject("btn_shutdown.Image"), System.Drawing.Image)
        Me.btn_shutdown.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_shutdown.Location = New System.Drawing.Point(17, 21)
        Me.btn_shutdown.Name = "btn_shutdown"
        Me.btn_shutdown.Size = New System.Drawing.Size(127, 23)
        Me.btn_shutdown.TabIndex = 4
        Me.btn_shutdown.Text = "Shutdown Computer"
        Me.btn_shutdown.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.btn_shutdown.UseVisualStyleBackColor = True
        '
        'GroupBox4
        '
        Me.GroupBox4.Controls.Add(Me.btn_capslock)
        Me.GroupBox4.Controls.Add(Me.Button2)
        Me.GroupBox4.Controls.Add(Me.Button4)
        Me.GroupBox4.Controls.Add(Me.Button3)
        Me.GroupBox4.Controls.Add(Me.Button1)
        Me.GroupBox4.Controls.Add(Me.Button7)
        Me.GroupBox4.Controls.Add(Me.Button6)
        Me.GroupBox4.Location = New System.Drawing.Point(13, 207)
        Me.GroupBox4.Name = "GroupBox4"
        Me.GroupBox4.Size = New System.Drawing.Size(574, 84)
        Me.GroupBox4.TabIndex = 3
        Me.GroupBox4.TabStop = False
        Me.GroupBox4.Text = "Prank / Trolls / Fun"
        '
        'btn_capslock
        '
        Me.btn_capslock.Image = CType(resources.GetObject("btn_capslock.Image"), System.Drawing.Image)
        Me.btn_capslock.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btn_capslock.Location = New System.Drawing.Point(407, 22)
        Me.btn_capslock.Name = "btn_capslock"
        Me.btn_capslock.Size = New System.Drawing.Size(127, 23)
        Me.btn_capslock.TabIndex = 11
        Me.btn_capslock.Text = "Caps Look"
        Me.btn_capslock.UseVisualStyleBackColor = True
        '
        'Button2
        '
        Me.Button2.Image = CType(resources.GetObject("Button2.Image"), System.Drawing.Image)
        Me.Button2.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.Button2.Location = New System.Drawing.Point(274, 51)
        Me.Button2.Name = "Button2"
        Me.Button2.Size = New System.Drawing.Size(127, 23)
        Me.Button2.TabIndex = 10
        Me.Button2.Text = "Mute Volume"
        Me.Button2.UseVisualStyleBackColor = True
        '
        'Button4
        '
        Me.Button4.Image = CType(resources.GetObject("Button4.Image"), System.Drawing.Image)
        Me.Button4.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.Button4.Location = New System.Drawing.Point(274, 22)
        Me.Button4.Name = "Button4"
        Me.Button4.Size = New System.Drawing.Size(127, 23)
        Me.Button4.TabIndex = 8
        Me.Button4.Text = "Run Hidden Sounds"
        Me.Button4.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.Button4.UseVisualStyleBackColor = True
        '
        'Button3
        '
        Me.Button3.Image = CType(resources.GetObject("Button3.Image"), System.Drawing.Image)
        Me.Button3.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.Button3.Location = New System.Drawing.Point(139, 51)
        Me.Button3.Name = "Button3"
        Me.Button3.Size = New System.Drawing.Size(127, 23)
        Me.Button3.TabIndex = 7
        Me.Button3.Text = "Min Volume"
        Me.Button3.UseVisualStyleBackColor = True
        '
        'Button1
        '
        Me.Button1.Image = CType(resources.GetObject("Button1.Image"), System.Drawing.Image)
        Me.Button1.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.Button1.Location = New System.Drawing.Point(6, 51)
        Me.Button1.Name = "Button1"
        Me.Button1.Size = New System.Drawing.Size(127, 23)
        Me.Button1.TabIndex = 6
        Me.Button1.Text = "Max Volume"
        Me.Button1.UseVisualStyleBackColor = True
        '
        'Button7
        '
        Me.Button7.Image = CType(resources.GetObject("Button7.Image"), System.Drawing.Image)
        Me.Button7.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.Button7.Location = New System.Drawing.Point(139, 22)
        Me.Button7.Name = "Button7"
        Me.Button7.Size = New System.Drawing.Size(127, 23)
        Me.Button7.TabIndex = 5
        Me.Button7.Text = "Dick Cursor"
        Me.Button7.UseVisualStyleBackColor = True
        '
        'Button6
        '
        Me.Button6.Image = CType(resources.GetObject("Button6.Image"), System.Drawing.Image)
        Me.Button6.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.Button6.Location = New System.Drawing.Point(6, 22)
        Me.Button6.Name = "Button6"
        Me.Button6.Size = New System.Drawing.Size(127, 23)
        Me.Button6.TabIndex = 4
        Me.Button6.Text = "Scary Scream"
        Me.Button6.UseVisualStyleBackColor = True
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripStatusLabel1})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 295)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(602, 22)
        Me.StatusStrip1.TabIndex = 4
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'ToolStripStatusLabel1
        '
        Me.ToolStripStatusLabel1.Name = "ToolStripStatusLabel1"
        Me.ToolStripStatusLabel1.Size = New System.Drawing.Size(0, 17)
        '
        'FunManager
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(602, 317)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Controls.Add(Me.GroupBox4)
        Me.Controls.Add(Me.GroupBox3)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.GroupBox1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.MaximizeBox = False
        Me.Name = "FunManager"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "FunManager"
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        CType(Me.NUD_websitetimes, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox3.ResumeLayout(False)
        Me.GroupBox4.ResumeLayout(False)
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents NUD_websitetimes As System.Windows.Forms.NumericUpDown
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents tb_weburl As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Button11 As System.Windows.Forms.Button
    Friend WithEvents cb_silent As System.Windows.Forms.CheckBox
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents btn_stopdiscomouse As System.Windows.Forms.Button
    Friend WithEvents btn_discomouse As System.Windows.Forms.Button
    Friend WithEvents btn_undomouse As System.Windows.Forms.Button
    Friend WithEvents btn_mouseswap As System.Windows.Forms.Button
    Friend WithEvents GroupBox3 As System.Windows.Forms.GroupBox
    Friend WithEvents GroupBox4 As System.Windows.Forms.GroupBox
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents Button2 As System.Windows.Forms.Button
    Friend WithEvents Button4 As System.Windows.Forms.Button
    Friend WithEvents Button3 As System.Windows.Forms.Button
    Friend WithEvents Button1 As System.Windows.Forms.Button
    Friend WithEvents Button7 As System.Windows.Forms.Button
    Friend WithEvents Button6 As System.Windows.Forms.Button
    Friend WithEvents btn_speak As System.Windows.Forms.Button
    Friend WithEvents btn_changewp As System.Windows.Forms.Button
    Friend WithEvents btn_closecd As System.Windows.Forms.Button
    Friend WithEvents btn_opencd As System.Windows.Forms.Button
    Friend WithEvents btn_showdi As System.Windows.Forms.Button
    Friend WithEvents btn_hidedi As System.Windows.Forms.Button
    Friend WithEvents btn_showtb As System.Windows.Forms.Button
    Friend WithEvents btn_hidetb As System.Windows.Forms.Button
    Friend WithEvents btn_hibernate As System.Windows.Forms.Button
    Friend WithEvents btn_restart As System.Windows.Forms.Button
    Friend WithEvents btn_logoff As System.Windows.Forms.Button
    Friend WithEvents btn_shutdown As System.Windows.Forms.Button
    Friend WithEvents btn_capslock As System.Windows.Forms.Button
    Friend WithEvents ToolStripStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel
End Class
