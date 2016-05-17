unit UnitConnectionsLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, sPanel, sMonthCalendar, ComCtrls, Buttons, UnitMain;

type
  TFormConnectionsLog = class(TForm)
    Panel1: TPanel;
    sMonthCalendar1: TsMonthCalendar;
    RadioGroup1: TRadioGroup;
    SpeedButton1: TSpeedButton;
    ListView1: TListView;
    SpeedButton2: TSpeedButton;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    { Private declarations }
  	procedure IncluirItem(var Message: TMessage); message 5556;
  	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
    procedure AtualizarIdioma;
  public
    { Public declarations }
  end;

var
  FormConnectionsLog: TFormConnectionsLog;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConstantes,
  MD5,
  DateUtils,
  StrUtils,
  UnitCommonProcedures;

var
  LastSortedColumn: TListColumn;
  Ascending: boolean;

function SortByColumn(Item1, Item2: TListItem; Data: integer): integer; stdcall;
var
  n1,n2: int64;
  s1,s2: string;
  ex1,ex2: extended;
  num: integer;
  Date1,Date2: TDateTime;
begin
  Result := 0;
  if Data = 0 then Result := AnsiCompareText(Item1.Caption, Item2.Caption)
  else Result := AnsiCompareText(Item1.SubItems[Data-1],Item2.SubItems[Data-1]);
  if not Ascending then Result := -Result;
end;

procedure TFormConnectionsLog.AtualizarIdioma;
var
  i: integer;
begin
  ListView1.Column[0].Caption := Traduzidos[0];
  ListView1.Column[1].Caption := Traduzidos[639];
  ListView1.Column[2].Caption := Traduzidos[640];
  RadioGroup1.Caption := Traduzidos[641];
  RadioGroup1.Items.Strings[0] := Traduzidos[642];
  RadioGroup1.Items.Strings[1] := Traduzidos[643];
  SpeedButton1.Caption := Traduzidos[644];
  SpeedButton2.Caption := Traduzidos[387];
  Caption := Traduzidos[646];
  for I := 0 to ListView1.Items.Count - 1 do
  if ListView1.Items.Item[i].SubItems.Strings[1] = 'CLOSED' then
  ListView1.Items.Item[i].SubItems.Strings[1] := Traduzidos[645];

  Label1.Caption := '  ' + Traduzidos[648] + ': ' + inttostr(ListView1.Items.Count);
end;

procedure TFormConnectionsLog.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;

procedure TFormConnectionsLog.IncluirItem(var Message: TMessage);
var
  Item, Item2: TListItem;
begin
  Item := TListItem(message.WParam);
  if (Item.ImageIndex < 0) or (Item.SubItems.Strings[0] = '') then Exit;

  Item2 := ListView1.Items.Add;
  Item2.Caption := Item.Caption;
  Item2.SubItems.Add(Item.SubItems.Strings[0]);
  Item2.SubItems.Add(Item.SubItems.Strings[1]);
  Item2.ImageIndex := Item.ImageIndex;
end;

procedure TFormConnectionsLog.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  Label1.Caption := '  ' + Traduzidos[648] + ': ' + inttostr(ListView1.Items.Count);
end;

procedure TFormConnectionsLog.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  Ascending := not Ascending;
  if Column <> LastSortedColumn then Ascending := not Ascending;
  for i := 0 to Listview1.Columns.Count -1 do Listview1.Column[i].ImageIndex := -1;
  LastSortedColumn := Column;
  Listview1.CustomSort(@SortByColumn, LastSortedColumn.Index);
end;

procedure TFormConnectionsLog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  RadioGroup1.ItemIndex := 1;
  sMonthCalendar1.CalendarDate := now;
  sMonthCalendar1.Visible := True;
end;

procedure TFormConnectionsLog.FormCreate(Sender: TObject);
begin
  FormMain.ImageListDiversos.GetBitmap(53, SpeedButton1.Glyph);
  FormMain.ImageListDiversos.GetBitmap(18, SpeedButton2.Glyph);
  RadioGroup1.ItemIndex := 1;
  sMonthCalendar1.CalendarDate := now;
  sMonthCalendar1.Visible := True;
end;

procedure TFormConnectionsLog.FormShow(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  AtualizarIdioma;
end;

procedure TFormConnectionsLog.RadioGroup1Click(Sender: TObject);
begin
  sMonthCalendar1.Visible := RadioGroup1.ItemIndex = 1;
end;

procedure TFormConnectionsLog.SpeedButton1Click(Sender: TObject);
var
  d: TDateTime;
  s: string;
  p: TPanel;
  l: TListView;
  Stream: TMemoryStream;
  i: integer;
  item: TListItem;
  FileName: string;
begin
  ListView1.Items.Clear;
  ListView1.Items.BeginUpdate;

  if RadioGroup1.ItemIndex = 0 then
  begin
    p := TPanel.Create(nil);
    p.Height := 0;
    p.Width := 0;
    p.Top := 5000;
    p.Parent := FormConnectionsLog;
    l := TListView.Create(nil);
    l.Parent := p;

    d := FormMain.MinDate;
    repeat
      s := Copy(DateTimeToStr(d), 1, posex(' ', DateTimeToStr(d) + ' ') - 1);
      FileName := FormMain.ConnLogsDir + MD5Print(MD5string(s));
      if FileExists(FileName) then
      begin
        l.Items.Clear;
        Stream := TMemoryStream.Create;
        Stream.LoadFromFile(FileName);
        Stream.Position := 0;
        LoadComponentFromStream(Stream, l);
        Stream.Free;

        for I := 0 to l.Items.Count - 1 do
        begin
          Item := ListView1.Items.Add;
          Item.Caption := l.Items.Item[i].Caption;
          Item.SubItems.Add(l.Items.Item[i].SubItems.Strings[0]);
          Item.SubItems.Add(l.Items.Item[i].SubItems.Strings[1]);
          Item.ImageIndex := l.Items.Item[i].ImageIndex;
          if Item.SubItems.Strings[1] = 'CLOSED' then Item.SubItems.Strings[1] := Traduzidos[645];
        end;
      end;
      d := d + 1;
    until d > now;

    l.Free;
    p.Free;
  end else
  begin
    d := sMonthCalendar1.CalendarDate;
    s := Copy(DateTimeToStr(d), 1, posex(' ', DateTimeToStr(d) + ' ') - 1);
    FileName := FormMain.ConnLogsDir + MD5Print(MD5string(s));
    if FileExists(FileName) then
    begin
      Stream := TMemoryStream.Create;
      Stream.LoadFromFile(FileName);
      Stream.Position := 0;
      LoadComponentFromStream(Stream, ListView1);
      Stream.Free;
    end;
  end;

  AtualizarIdioma;
  ListView1.Items.EndUpdate;
end;


function justr(s : string; tamanho : integer) : string;
var i : integer;
begin
   i := tamanho-length(s);
   if i>0 then
     s := DupeString(' ', i)+s;
   justr := s;
end;

function justl(s : string; tamanho : integer) : string;
var i : integer;
begin
   i := tamanho-length(s);
   if i>0 then
     s := s+DupeString(' ', i);
   justl := s;
end;

procedure TFormConnectionsLog.SpeedButton2Click(Sender: TObject);
var
  Filename: string;
  I: Integer;
  buffer: string;
  c: cardinal;
  newFile: THandle;
  Header: array [0..1] of byte;
begin
  if savedialog1 <> nil then savedialog1.Free;
  savedialog1 := TSaveDialog.Create(nil);

  savedialog1.Filter := 'Text Files (*.txt)' + '|*.txt';
  savedialog1.InitialDir := extractfilepath(paramstr(0));
  savedialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  SaveDialog1.FileName := 'Logs_' + ShowTime('-', ' ', '-') + '.txt';

  if savedialog1.Execute = false then exit;

  Filename := savedialog1.FileName;
  if Filename = '' then exit;

  buffer := '';
  buffer := buffer +
            justl(ListView1.Column[0].Caption, 50) +
            justl(ListView1.Column[1].Caption, 25) +
            justl(ListView1.Column[2].Caption, 25) + #13#10#13#10;

  for I := 0 to ListView1.Items.Count - 1 do
  begin
    buffer := buffer +
              justl(ListView1.Items.Item[i].Caption, 50) +
              justl(ListView1.Items.Item[i].SubItems[0], 25) +
              justl(ListView1.Items.Item[i].SubItems[1], 25) + #13#10;
  end;
  newFile := CreateFileW(pWideChar(FileName), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, 0, 0);
  if newFile <> INVALID_HANDLE_VALUE then
  begin
    header[0] := $FF;
    header[1] := $FE;
    WriteFile(newFile, Header, SizeOf(Header), c, nil);
    WriteFile(newFile, buffer[1], Length(buffer) * 2, c, nil);
  end;
  CloseHandle(newFile);
end;

end.
