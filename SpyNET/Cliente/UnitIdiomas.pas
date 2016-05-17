unit UnitIdiomas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormIdiomas = class(TForm)
    ListBox1: TListBox;
    procedure FormShow(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormIdiomas: TFormIdiomas;

implementation

{$R *.dfm}

Uses
  UnitPrincipal,
  UnitStrings,
  UnitConexao;

function FileSearch(const PathName, FileName : string; const InDir : boolean): string;
var
  Rec: TSearchRec;
  Path, Tempdir: string;
  tamanho: int64;
  Tipo, FileDate: string;
begin
  path := PathName;

  if copy(path, 1, pos('?', path) - 1) = 'ALL' then
  begin
    Tempdir := path;
    delete(tempdir, 1, pos('?', Tempdir));
    while pos('?', Tempdir) > 0 do
    begin
      sleep(50);
      try
        FileSearch(copy(Tempdir, 1, pos('?', Tempdir) - 1), FileName, TRUE);
        except
      end;
      delete(tempdir, 1, pos('?', Tempdir));
    end;
    exit;
  end;

  if path[length(path)] <> '\' then path := path + '\';

  if FindFirst(Path + FileName, faAnyFile - faDirectory, Rec) = 0 then
  try
    repeat
    if length(Path + Rec.Name) > 3 then // porque c:\ tem tamanho 3 hehe
      Result := Result + Path + Rec.Name + '|';

    until FindNext(Rec) <> 0;
    finally
      SysUtils.FindClose(Rec);
  end;

  If not InDir then Exit;

  if FindFirst(Path + '*.*', faDirectory, Rec) = 0 then
  try
    repeat
    if ((Rec.Attr and faDirectory) <> 0)  and (Rec.Name <> '.') and (Rec.Name <> '..') then
    result := result + FileSearch(Path + Rec.Name, FileName, True);
    until FindNext(Rec) <> 0;
    finally
    SysUtils.FindClose(Rec);
  end;
end;

procedure TFormIdiomas.FormShow(Sender: TObject);
var
  TempStr: string;
begin
  ListBox1.Clear;
  Caption := traduzidos[398];
  TempStr := FileSearch(extractfilepath(paramstr(0)) + 'language', '*.ini', false);
  if TempStr = '' then exit;
  while TempStr <> '' do
  begin
    ListBox1.Items.Add(extractfilename(copy(Tempstr, 1, pos('|', tempstr) - 1)));
    delete(tempstr, 1, pos('|', tempstr));
  end;
end;

procedure TFormIdiomas.ListBox1DblClick(Sender: TObject);
var
  TempStr, TempPorts: string;
  i: integer;
begin
  if listbox1.ItemIndex < 0 then exit;
  TempStr := extractfilepath(paramstr(0)) + 'language\' + listbox1.Items.Strings[listbox1.ItemIndex];
  if fileexists(TempStr) = true then
  begin
    languagefile := TempStr;
    LerStrings(languagefile);

    FormPrincipal.AtualizarStringsTraduzidas;

    for i := 1 to 65535 do
    if PortasAtivas[i] <> 0 then TempPorts := TempPorts + '(' + inttostr(i) + ')' + ' ';
    FormPrincipal.Statusbar1.Panels.Items[1].Text := traduzidos[19] + ': ' + TempPorts;

    close;
  end;
end;

end.
 