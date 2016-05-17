unit GlobalVars;

interface

uses
  UnitConexao,
  UnitObjeto,
  UnitConfigs;

var
  ServerConfigFileName,
  FunctionsFileName,
  InstalledServer,
  ServerStarted,
  DiskSerialName,
  PassID,
  ConnectionID,
  RelacaoJanelas,
  MouseFolder: WideString;
  IniciarDesinstalacao: boolean = False;
  MainIdTCPClient: TIdTCPClientNew;
  DesconectarServidor: boolean = False;
  ReconectarServer: boolean = false;
  ReconectarServerHost: Widestring;
  ReconectarServerPort: integer;
  Lastping: integer;
  ServerObject: TMyObject;
  WebcamType: integer = 0;
  SelectedWebcam: integer = 0;
  WebcamQuality, WebcamInterval: integer;
  DesktopQuality: integer;
  DesktopInterval: integer;
  DesktopX: integer;
  DesktopY: integer;
  ShowMouseDesktop: boolean = True;
  ThumbStop: Boolean;
  ThumbSearchStop: Boolean;
  SearchFileStop: Boolean;
  SearchFileResult: WideString;

  SearchDownFolderStop: Boolean;
  SearchDownFolderResult: WideString;

  StopFileExistsComputer: boolean;
  StopDownloadAll: boolean;
  swapmouse: boolean = false;

implementation

end.