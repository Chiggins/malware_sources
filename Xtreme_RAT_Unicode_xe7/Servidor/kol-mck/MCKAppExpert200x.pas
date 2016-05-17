unit MCKAppExpert200x;

interface

uses
  Windows, Classes, SysUtils, Controls, Dialogs, ToolsApi;

type
  TMCKWizard = class(TNotifierObject, IOTAWizard, IOTARepositoryWizard, IOTAProjectWizard)
    procedure Execute;
    function GetIDString: String;
    function GetName: String;
    function GetState: TWizardState;
    function GetAuthor: String;
    function GetComment: String;
    function GetPage: String;
    function GetGlyph: Cardinal;
  end;

procedure Register;

const
  prj_template =
'{ KOL MCK } // Do not remove this line!'#13#10 +
'{$DEFINE KOL_MCK}'#13#10 +
''#13#10 +
'program %prj_name%;'#13#10 +
''#13#10 +
'uses'#13#10 +
'KOL,'#13#10 +
'  %unt_name% in ''%unt_name%.pas'' {Form1};'#13#10 +
''#13#10 +
'{$R *.res}'#13#10 +
'//{$R %prj_name%.res}'#13#10 +
'//{$R WinXP.res}'#13#10 +
''#13#10 +
'begin // PROGRAM START HERE -- Please do not remove this comment'#13#10 +
#13#10 +
'{$IF Defined(KOL_MCK)} {$I %prj_name%_0.inc} {$ELSE}'#13#10 +
#13#10 +
'  Application.Initialize;'#13#10 +
'  Application.CreateForm(TForm1, Form1);'#13#10 +
'  Application.Run;'#13#10 +
#13#10 +
'{$IFEND}'#13#10 +
#13#10 +
'end.'#13#10;

  unt_template =
'{ KOL MCK } // Do not remove this line!' + #13#10 +
'{$DEFINE KOL_MCK}' + #13#10 + 
'unit %unt_name%;' + #13#10 + 
#13#10 +
'interface' + #13#10 + 
#13#10 + 
'{$IFDEF KOL_MCK}' + #13#10 + 
'uses Windows, Messages, KOL {$IF Defined(KOL_MCK)}{$ELSE}, mirror, Classes, Controls, mckCtrls,' + #13#10 + 
'  mckObjs, Graphics {$IFEND (place your units here->)};' + #13#10 +
'{$ELSE}' + #13#10 +
'{$I uses.inc}' + #13#10 +
'  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,' + #13#10 +
'  Dialogs, mirror;' + #13#10 +
'{$ENDIF}' + #13#10 +
#13#10 +
'type' + #13#10 +
'  {$IF Defined(KOL_MCK)}' + #13#10 +
'  {$I MCKfakeClasses.inc}' + #13#10 +
'  {$IFDEF KOLCLASSES} {$I TForm1class.inc} {$ELSE OBJECTS} PForm1 = ^TForm1; {$ENDIF CLASSES/OBJECTS}' + #13#10 +
'  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TForm1 = object(TObj) {$ENDIF}' + #13#10 +
'    Form: PControl;' + #13#10 +
'  {$ELSE not_KOL_MCK}' + #13#10 +
'  TForm1 = class(TForm)' + #13#10 +
'  {$IFEND KOL_MCK}' + #13#10 +
'    KOLProj: TKOLProject;' + #13#10 +
'    KOLForm: TKOLForm;' + #13#10 +
'  private' + #13#10 +
'    { Private declarations }' + #13#10 +
'  public' + #13#10 +
'    { Public declarations }' + #13#10 +
'  end;' + #13#10 +
#13#10 +
'var' + #13#10 +
'  Form1 {$IF Defined(KOL_MCK)} : PForm1 {$ELSE} : TForm1 {$IFEND} ;' + #13#10 +
#13#10 +
'{$IFDEF KOL_MCK}procedure NewForm1( var Result: PForm1; AParent: PControl );{$ENDIF}' + #13#10 +
'implementation' + #13#10 +
'{$IF Defined(KOL_MCK)}{$I Unit1_1.inc}{$ELSE}{$R *.DFM}{$IFEND}' + #13#10 +
#13#10 +
'end.';

  dfm_template =
'object Form1: TForm1' + #13#10 +
  'Left = 192' + #13#10 + 
  'Top = 105' + #13#10 + 
  'Width = 870' + #13#10 + 
  'Height = 640' + #13#10 + 
  'HorzScrollBar.Visible = False' + #13#10 + 
  'VertScrollBar.Visible = False' + #13#10 + 
  'Caption = ''Form1''' + #13#10 + 
  'Color = clBtnFace' + #13#10 + 
  'Font.Charset = DEFAULT_CHARSET' + #13#10 + 
  'Font.Color = clWindowText' + #13#10 + 
  'Font.Height = -11' + #13#10 + 
  'Font.Name = ''MS Sans Serif''' + #13#10 + 
  'Font.Style = []' + #13#10 + 
  'OldCreateOrder = False' + #13#10 + 
  'Scaled = False' + #13#10 + 
  'PixelsPerInch = 96' + #13#10 + 
  'TextHeight = 13' + #13#10 + 
  'object KOLProj: TKOLProject' + #13#10 + 
    'Locked = False' + #13#10 + 
    'Localizy = False' + #13#10 + 
    'projectName = ''prj''' + #13#10 + 
    'projectDest = ''prj''' + #13#10 + 
    'sourcePath = ''%path%''' + #13#10 + 
    'outdcuPath = ''%path%''' + #13#10 + 
    'dprResource = True' + #13#10 + 
    'protectFiles = True' + #13#10 + 
    'showReport = False' + #13#10 + 
    'isKOLProject = True' + #13#10 + 
    'autoBuild = True' + #13#10 + 
    'autoBuildDelay = 500' + #13#10 + 
    'BUILD = False' + #13#10 + 
    'consoleOut = False' + #13#10 + 
    'SupportAnsiMnemonics = 0' + #13#10 + 
    'PaintType = ptWYSIWIG' + #13#10 + 
    'ShowHint = False' + #13#10 + 
    'ReportDetailed = False' + #13#10 + 
    'GeneratePCode = False' + #13#10 + 
    'NewIF = True' + #13#10 + 
    'Left = 16' + #13#10 + 
    'Top = 16' + #13#10 + 
  'end' + #13#10 + 
  'object KOLForm: TKOLForm' + #13#10 + 
    'Tag = 0' + #13#10 + 
    'ForceIcon16x16 = False' + #13#10 + 
    'Caption = ''Form1''' + #13#10 + 
    'Visible = True' + #13#10 + 
    'AllBtnReturnClick = False' + #13#10 + 
    'Tabulate = False' + #13#10 + 
    'TabulateEx = False' + #13#10 + 
    'UnitSourcePath = ''%path%''' + #13#10 + 
    'Locked = False' + #13#10 + 
    'formUnit = ''Unit1''' + #13#10 + 
    'formMain = True' + #13#10 + 
    'Enabled = True' + #13#10 + 
    'defaultSize = False' + #13#10 + 
    'defaultPosition = False' + #13#10 + 
    'MinWidth = 0' + #13#10 + 
    'MinHeight = 0' + #13#10 + 
    'MaxWidth = 0' + #13#10 + 
    'MaxHeight = 0' + #13#10 + 
    'HasBorder = True' + #13#10 + 
    'HasCaption = True' + #13#10 + 
    'StayOnTop = False' + #13#10 + 
    'CanResize = True' + #13#10 + 
    'CenterOnScreen = False' + #13#10 + 
    'Ctl3D = True' + #13#10 + 
    'WindowState = wsNormal' + #13#10 + 
    'minimizeIcon = True' + #13#10 + 
    'maximizeIcon = True' + #13#10 + 
    'closeIcon = True' + #13#10 + 
    'helpContextIcon = False' + #13#10 + 
    'borderStyle = fbsSingle' + #13#10 + 
    'HelpContext = 0' + #13#10 + 
    'Color = clBtnFace' + #13#10 + 
    'Font.Color = clWindowText' + #13#10 + 
    'Font.FontStyle = []' + #13#10 + 
    'Font.FontHeight = -11' + #13#10 + 
    'Font.FontWidth = 0' + #13#10 + 
    'Font.FontWeight = 0' + #13#10 + 
    'Font.FontName = ''Tahoma''' + #13#10 + 
    'Font.FontOrientation = 0' + #13#10 + 
    'Font.FontCharset = 1' + #13#10 + 
    'Font.FontPitch = fpDefault' + #13#10 + 
    'Font.FontQuality = fqDefault' + #13#10 + 
    'Brush.Color = clBtnFace' + #13#10 + 
    'Brush.BrushStyle = bsSolid' + #13#10 + 
    'DoubleBuffered = False' + #13#10 + 
    'PreventResizeFlicks = False' + #13#10 + 
    'Transparent = False' + #13#10 + 
    'AlphaBlend = 255' + #13#10 + 
    'Border = 2' + #13#10 + 
    'MarginLeft = 0' + #13#10 + 
    'MarginRight = 0' + #13#10 + 
    'MarginTop = 0' + #13#10 + 
    'MarginBottom = 0' + #13#10 + 
    'MinimizeNormalAnimated = False' + #13#10 + 
    'RestoreNormalMaximized = False' + #13#10 + 
    'zOrderChildren = False' + #13#10 + 
    'statusSizeGrip = True' + #13#10 + 
    'Localizy = False' + #13#10 + 
    'ShowHint = False' + #13#10 + 
    'KeyPreview = False' + #13#10 + 
    'EraseBackground = False' + #13#10 + 
    'supportMnemonics = False' + #13#10 + 
    'Left = 64' + #13#10 + 
    'Top = 16' + #13#10 +
  'end' + #13#10 + 
'end';

implementation

procedure Register;
begin
  RegisterPackageWizard(TMCKWizard.Create as IOTAWizard);
end;

procedure TMCKWizard.Execute;
var
  prj: String;
  unt: String;
  dlg: TSaveDialog;
  lst: TStringList;
begin
  dlg            := TSaveDialog.Create(nil);
  dlg.Options    := [ofOverwritePrompt, ofExtensionDifferent, ofPathMustExist];
  dlg.Title      := 'Save Project';
  dlg.Filter     := 'DPR files|*.dpr';
  dlg.DefaultExt := 'dpr';
  if dlg.Execute then begin
    prj := dlg.FileName;
    if (Pos('.', prj) = Length(prj) - 3) then
      SetLength(prj, Length(prj) - 4);
    dlg.Title := 'Save Unit';
    dlg.Filter := 'PAS files|*.pas';
    dlg.DefaultExt := 'pas';
    dlg.FileName := 'unit1';
    if dlg.Execute then begin
      unt := dlg.FileName;
      if (Pos('.', unt) = Length(unt) - 3) then
        SetLength(unt, Length(unt) - 4);
      // gen project
      lst := TStringList.Create;
      lst.Text := StringReplace(prj_template, '%prj_name%', ExtractFileName(prj), [rfReplaceAll]);
      lst.Text := StringReplace(lst.Text, '%unt_name%', ExtractFileName(unt), [rfReplaceAll]);
      lst.SaveToFile(prj + '.dpr');
      // gen unit
      lst.Text := StringReplace(unt_template, '%unt_name%', ExtractFileName(unt), [rfReplaceAll]);
      lst.SaveToFile(unt + '.pas');
      // gen dfm
      lst.Text := StringReplace(dfm_template, '%path%', ExtractFilePath(unt), [rfReplaceAll]);
      lst.SaveToFile(unt + '.dfm');
      // close all
      if (MessageBox(0, 'Close all projects before opening new?', 'MCKAppExpert200x', MB_ICONQUESTION or MB_YESNO) = IDYES) then
        (BorlandIDEServices as IOTAModuleServices).CloseAll;
      // open new
      (BorlandIDEServices as IOTAActionServices).OpenProject(prj + '.dpr', False);
      // free
      lst.Free;
    end;
  end;
  dlg.Free;
end;

function TMCKWizard.GetAuthor: string;
begin
  Result := 'D[u]fa';
end;

function TMCKWizard.GetComment: string;
begin
  Result := 'No comments =)';
end;

function TMCKWizard.GetGlyph: Cardinal;
begin
  Result := 0;//LoadIcon(hInstance, 'MCKWizard');
end;

function TMCKWizard.GetIDString: string;
begin
  Result := 'KOLMCK.WIZARD.200x';
end;

function TMCKWizard.GetName: string;
begin
  Result := 'New KOL-MCK Project';
end;

function TMCKWizard.GetPage: String;
begin
  Result := '';
end;

function TMCKWizard.GetState: TWizardState;
begin
  Result := [];
end;

end.
