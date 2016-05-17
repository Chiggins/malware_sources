namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Diagnostics;
    using System.Drawing;
    using System.Runtime.CompilerServices;
    using System.Windows.Forms;

    [DesignerGenerated]
    public class Chat : Form
    {
        private static List<WeakReference> __ENCList = new List<WeakReference>();
        [AccessedThroughProperty("RichTextBox1")]
        private RichTextBox _RichTextBox1;
        [AccessedThroughProperty("TextBox1")]
        private TextBox _TextBox1;
        private IContainer components;

        [DebuggerNonUserCode]
        public Chat()
        {
            __ENCAddToList(this);
            this.InitializeComponent();
        }

        [DebuggerNonUserCode]
        private static void __ENCAddToList(object value)
        {
            List<WeakReference> list = __ENCList;
            lock (list)
            {
                if (__ENCList.Count == __ENCList.Capacity)
                {
                    int index = 0;
                    int num3 = __ENCList.Count - 1;
                    for (int i = 0; i <= num3; i++)
                    {
                        WeakReference reference = __ENCList[i];
                        if (reference.IsAlive)
                        {
                            if (i != index)
                            {
                                __ENCList[index] = __ENCList[i];
                            }
                            index++;
                        }
                    }
                    __ENCList.RemoveRange(index, __ENCList.Count - index);
                    __ENCList.Capacity = __ENCList.Count;
                }
                __ENCList.Add(new WeakReference(RuntimeHelpers.GetObjectValue(value)));
            }
        }

        [DebuggerNonUserCode]
        protected override void Dispose(bool disposing)
        {
            try
            {
                if (disposing && (this.components != null))
                {
                    this.components.Dispose();
                }
            }
            finally
            {
                base.Dispose(disposing);
            }
        }

        [DebuggerStepThrough]
        private void InitializeComponent()
        {
            this.RichTextBox1 = new RichTextBox();
            this.TextBox1 = new TextBox();
            this.SuspendLayout();
            Point point2 = new Point(3, 2);
            this.RichTextBox1.Location = point2;
            this.RichTextBox1.Name = "RichTextBox1";
            this.RichTextBox1.ReadOnly = true;
            Size size2 = new Size(0x161, 0x146);
            this.RichTextBox1.Size = size2;
            this.RichTextBox1.TabIndex = 0;
            this.RichTextBox1.Text = "";
            point2 = new Point(3, 0x14e);
            this.TextBox1.Location = point2;
            this.TextBox1.Name = "TextBox1";
            size2 = new Size(0x161, 20);
            this.TextBox1.Size = size2;
            this.TextBox1.TabIndex = 1;
            SizeF ef2 = new SizeF(6f, 13f);
            this.AutoScaleDimensions = ef2;
            this.AutoScaleMode = AutoScaleMode.Font;
            size2 = new Size(0x165, 0x169);
            this.ClientSize = size2;
            this.Controls.Add(this.TextBox1);
            this.Controls.Add(this.RichTextBox1);
            this.FormBorderStyle = FormBorderStyle.FixedToolWindow;
            this.Name = "Chat";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Text = "Chat";
            this.TopMost = true;
            this.ResumeLayout(false);
            this.PerformLayout();
        }

        internal virtual RichTextBox RichTextBox1
        {
            [DebuggerNonUserCode]
            get
            {
                return this._RichTextBox1;
            }
            [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
            set
            {
                this._RichTextBox1 = value;
            }
        }

        internal virtual TextBox TextBox1
        {
            [DebuggerNonUserCode]
            get
            {
                return this._TextBox1;
            }
            [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
            set
            {
                this._TextBox1 = value;
            }
        }
    }
}

