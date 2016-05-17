<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form remplace la méthode Dispose pour nettoyer la liste des composants.
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

    'Requise par le Concepteur Windows Form
    Private components As System.ComponentModel.IContainer

    'REMARQUE : la procédure suivante est requise par le Concepteur Windows Form
    'Elle peut être modifiée à l'aide du Concepteur Windows Form.  
    'Ne la modifiez pas à l'aide de l'éditeur de code.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.Textth = New System.Windows.Forms.TextBox()
        Me.URL = New System.Windows.Forms.TextBox()
        Me.Timer3 = New System.Windows.Forms.Timer(Me.components)
        Me.TextKey = New System.Windows.Forms.TextBox()
        Me.Label10 = New System.Windows.Forms.Label()
        Me.PictureBox1 = New System.Windows.Forms.PictureBox()
        Me.SHTML = New System.Windows.Forms.TextBox()
        Me.Timer7 = New System.Windows.Forms.Timer(Me.components)
        Me.TextBox9 = New System.Windows.Forms.TextBox()
        Me.TextBox11 = New System.Windows.Forms.TextBox()
        Me.TextSteam = New System.Windows.Forms.TextBox()
        Me.TextBox1 = New System.Windows.Forms.TextBox()
        Me.TextGame = New System.Windows.Forms.TextBox()
        Me.ztext = New System.Windows.Forms.TextBox()
        Me.ztextz = New System.Windows.Forms.TextBox()
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Timer1
        '
        Me.Timer1.Interval = 600000
        '
        'Textth
        '
        Me.Textth.Location = New System.Drawing.Point(1, 42)
        Me.Textth.Name = "Textth"
        Me.Textth.Size = New System.Drawing.Size(20, 20)
        Me.Textth.TabIndex = 0
        Me.Textth.Text = "10"
        '
        'URL
        '
        Me.URL.Location = New System.Drawing.Point(0, 0)
        Me.URL.Name = "URL"
        Me.URL.Size = New System.Drawing.Size(100, 20)
        Me.URL.TabIndex = 1
        '
        'TextKey
        '
        Me.TextKey.Location = New System.Drawing.Point(27, 42)
        Me.TextKey.Name = "TextKey"
        Me.TextKey.Size = New System.Drawing.Size(180, 20)
        Me.TextKey.TabIndex = 2
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(0, 0)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(39, 13)
        Me.Label10.TabIndex = 3
        Me.Label10.Text = "Label1"
        '
        'PictureBox1
        '
        Me.PictureBox1.Location = New System.Drawing.Point(45, 17)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(200, 200)
        Me.PictureBox1.TabIndex = 4
        Me.PictureBox1.TabStop = False
        '
        'SHTML
        '
        Me.SHTML.Location = New System.Drawing.Point(45, -3)
        Me.SHTML.Multiline = True
        Me.SHTML.Name = "SHTML"
        Me.SHTML.Size = New System.Drawing.Size(255, 163)
        Me.SHTML.TabIndex = 5
        '
        'Timer7
        '
        Me.Timer7.Interval = 6000
        '
        'TextBox9
        '
        Me.TextBox9.Location = New System.Drawing.Point(53, 8)
        Me.TextBox9.Name = "TextBox9"
        Me.TextBox9.Size = New System.Drawing.Size(100, 20)
        Me.TextBox9.TabIndex = 6
        '
        'TextBox11
        '
        Me.TextBox11.Location = New System.Drawing.Point(0, 0)
        Me.TextBox11.Name = "TextBox11"
        Me.TextBox11.Size = New System.Drawing.Size(100, 20)
        Me.TextBox11.TabIndex = 7
        '
        'TextSteam
        '
        Me.TextSteam.Location = New System.Drawing.Point(0, 0)
        Me.TextSteam.Name = "TextSteam"
        Me.TextSteam.Size = New System.Drawing.Size(100, 20)
        Me.TextSteam.TabIndex = 8
        '
        'TextBox1
        '
        Me.TextBox1.Location = New System.Drawing.Point(0, 0)
        Me.TextBox1.Name = "TextBox1"
        Me.TextBox1.Size = New System.Drawing.Size(100, 20)
        Me.TextBox1.TabIndex = 9
        '
        'TextGame
        '
        Me.TextGame.Location = New System.Drawing.Point(0, 0)
        Me.TextGame.Name = "TextGame"
        Me.TextGame.Size = New System.Drawing.Size(100, 20)
        Me.TextGame.TabIndex = 10
        '
        'ztext
        '
        Me.ztext.Location = New System.Drawing.Point(0, 0)
        Me.ztext.Multiline = True
        Me.ztext.Name = "ztext"
        Me.ztext.Size = New System.Drawing.Size(127, 62)
        Me.ztext.TabIndex = 11
        '
        'ztextz
        '
        Me.ztextz.Location = New System.Drawing.Point(0, 0)
        Me.ztextz.Multiline = True
        Me.ztextz.Name = "ztextz"
        Me.ztextz.Size = New System.Drawing.Size(379, 217)
        Me.ztextz.TabIndex = 12
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(219, 79)
        Me.Controls.Add(Me.ztextz)
        Me.Controls.Add(Me.ztext)
        Me.Controls.Add(Me.TextGame)
        Me.Controls.Add(Me.TextBox1)
        Me.Controls.Add(Me.TextSteam)
        Me.Controls.Add(Me.TextBox11)
        Me.Controls.Add(Me.TextBox9)
        Me.Controls.Add(Me.SHTML)
        Me.Controls.Add(Me.PictureBox1)
        Me.Controls.Add(Me.Label10)
        Me.Controls.Add(Me.TextKey)
        Me.Controls.Add(Me.URL)
        Me.Controls.Add(Me.Textth)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow
        Me.Name = "Form1"
        Me.ShowIcon = False
        Me.ShowInTaskbar = False
        Me.Text = "Form1"
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Timer1 As System.Windows.Forms.Timer
    Friend WithEvents Textth As System.Windows.Forms.TextBox
    Friend WithEvents URL As System.Windows.Forms.TextBox
    Friend WithEvents Timer3 As System.Windows.Forms.Timer
    Friend WithEvents TextKey As System.Windows.Forms.TextBox
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
    Friend WithEvents SHTML As System.Windows.Forms.TextBox
    Friend WithEvents Timer7 As System.Windows.Forms.Timer
    Friend WithEvents TextBox9 As System.Windows.Forms.TextBox
    Friend WithEvents TextBox11 As System.Windows.Forms.TextBox
    Friend WithEvents TextSteam As System.Windows.Forms.TextBox
    Friend WithEvents TextBox1 As System.Windows.Forms.TextBox
    Friend WithEvents TextGame As System.Windows.Forms.TextBox
    Friend WithEvents ztext As System.Windows.Forms.TextBox
    Friend WithEvents ztextz As System.Windows.Forms.TextBox

End Class
