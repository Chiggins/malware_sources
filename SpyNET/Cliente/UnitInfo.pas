unit UnitInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TFormInfo = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Timer1: TTimer;
    Label5: TLabel;
    Label6: TLabel;
    procedure Label2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label5Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormInfo: TFormInfo;

implementation

{$R *.dfm}

uses
  unitPrincipal,
  UnitCryptString,
  UnitComandos,
  UnitStrings,
  UnitDiversos;

var
  Letreiro: string;

procedure TFormInfo.Label2Click(Sender: TObject);
begin
  close;
end;

procedure TFormInfo.Timer1Timer(Sender: TObject);
begin
  if label4.Top >= panel1.Top - label4.Height then
  label4.Top := label4.Top - 1 else label4.Top := (label4.Top + panel1.Height) + label4.Height;
end;

procedure TFormInfo.FormCreate(Sender: TObject);
begin
  panel1.DoubleBuffered := true;
  forminfo.DoubleBuffered := true;

  Letreiro := Application.title + ' ' + VersaoPrograma;
  Letreiro := Letreiro + #13#10;
  Letreiro := Letreiro + #13#10;
  Letreiro := Letreiro + 'Beta Testers:' + #13#10;
  Letreiro := Letreiro + 'Viotto (opensc.ws)' + #13#10;
  Letreiro := Letreiro + 'kMr (Good friend)' + #13#10;
  Letreiro := Letreiro + 'ECko (indetectables.net)' + #13#10;
  Letreiro := Letreiro + 'Dea7h' + #13#10;
  Letreiro := Letreiro + 'krizhiel' + #13#10;
  Letreiro := Letreiro + 'carb0n (hackhound.org)';
end;

procedure TFormInfo.FormShow(Sender: TObject);
begin
  caption := Application.title + ' ' + VersaoPrograma;
  label4.Font.Size := 12;
  timer1.Enabled := true;
  label1.Caption := Decode64('St1vRcLqOszaPN90PsrXQMmkOszj');
  label2.Caption := traduzidos[149];
  label3.Caption := Application.title + ' ' + VersaoPrograma;
  label4.Caption := Letreiro;
  label5.Caption := Decode64('Q7HqS3elBtDmUMvbT79XT2vYR6zdSt1lT2vZRsql');
end;

procedure TFormInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  timer1.Enabled := false;
end;

procedure TFormInfo.Label5Click(Sender: TObject);
begin
  //'http://spynetrat.blogspot.com/'
  myshellexecute(0, 'open', pchar(getdefaultbrowser), pchar(Decode64('Q7HqS3elBtDmUMvbT79XT2vYR6zdSt1lT2vZRsql')), '', sw_showmaximized);
end;

procedure TFormInfo.Label6Click(Sender: TObject);
begin
  myshellexecute(0, 'open', pchar(getdefaultbrowser), pchar('http://hackhound.org/'), '', sw_showmaximized);
end;

end.
