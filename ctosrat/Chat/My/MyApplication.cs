namespace Chat.My
{
    using Microsoft.VisualBasic.ApplicationServices;
    using System;
    using System.CodeDom.Compiler;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Diagnostics;
    using System.IO;
    using System.Reflection;
    using System.Runtime.CompilerServices;
    using System.Windows.Forms;

    [EditorBrowsable(EditorBrowsableState.Never), GeneratedCode("MyTemplate", "8.0.0.0")]
    internal class MyApplication : WindowsFormsApplicationBase
    {
        private static List<WeakReference> __ENCList = new List<WeakReference>();

        [DebuggerStepThrough]
        public MyApplication() : base(AuthenticationMode.Windows)
        {
            base.Startup += new StartupEventHandler(this.Form1_Startup);
            __ENCAddToList(this);
            this.IsSingleInstance = false;
            this.EnableVisualStyles = true;
            this.SaveMySettingsOnExit = true;
            this.ShutdownStyle = ShutdownMode.AfterMainFormCloses;
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

        private void Form1_Startup(object sender, StartupEventArgs e)
        {
            AppDomain.CurrentDomain.AssemblyResolve += new ResolveEventHandler(this.LoadDLLFromStream);
        }

        private Assembly LoadDLLFromStream(object sender, ResolveEventArgs args)
        {
            string name = "Chat." + new AssemblyName(args.Name).Name + ".dll";
            string[] manifestResourceNames = Assembly.GetExecutingAssembly().GetManifestResourceNames();
            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(name))
            {
                byte[] buffer = new byte[((int) (stream.Length - 1L)) + 1];
                stream.Read(buffer, 0, buffer.Length);
                return Assembly.Load(buffer);
            }
        }

        [MethodImpl(MethodImplOptions.NoOptimization | MethodImplOptions.NoInlining), EditorBrowsable(EditorBrowsableState.Advanced), DebuggerHidden, STAThread]
        internal static void Main(string[] Args)
        {
            try
            {
                Application.SetCompatibleTextRenderingDefault(WindowsFormsApplicationBase.UseCompatibleTextRendering);
            }
            finally
            {
            }
            MyProject.Application.Run(Args);
        }

        [DebuggerStepThrough]
        protected override void OnCreateMainForm()
        {
            this.MainForm = MyProject.Forms.Form1;
        }
    }
}

