unit acSelectSkin;
{$I sDefs.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, sListBox, StdCtrls, Buttons, sBitBtn, sSkinProvider,
  ExtCtrls, sPanel, ComCtrls, Mask, sMaskEdit, sSkinManager, sCustomComboEdit, sTooledit,
  sTrackBar, sLabel;

{$IFNDEF NOTFORHELP}
type
  TFormSkinSelect = class(TForm)
    sListBox1: TsListBox;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sPanel1: TsPanel;
    sSkinProvider1: TsSkinProvider;
    sDirectoryEdit1: TsDirectoryEdit;
    sStickyLabel1: TsStickyLabel;
    sTrackBar1: TsTrackBar;
    sTrackBar2: TsTrackBar;
    sStickyLabel2: TsStickyLabel;
    procedure sListBox1Click(Sender: TObject);
    procedure sDirectoryEdit1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sListBox1DblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sTrackBar1Change(Sender: TObject);
    procedure sTrackBar2Change(Sender: TObject);
  public
    sName : string;
    SkinTypes : TacSkinTypes;
    SkinPlaces : TacSkinPlaces;
    SkinManager : TsSkinManager;
    sSkinSaturation, sSkinHUE: integer;
  private

  end;

var
  FormSkinSelect: TFormSkinSelect;
{$ENDIF}

function SelectSkin(var SkinName : string;
                    var SkinDir : string;
                    var SkinSaturation: integer;
                    var SkinHUE: integer;
                    SkinTypes : TacSkinTypes = stAllSkins) : boolean; overload;
function SelectSkin(NameList : TStringList; var SkinDir : string; SkinTypes : TacSkinTypes = stAllSkins) : boolean; overload;
function SelectSkin(SkinManager : TsSkinManager; SkinPlaces : TacSkinPlaces = spAllPlaces) : boolean; overload;

implementation

uses UnitStrings, acntUtils, acSkinPreview{$IFDEF TNTUNICODE}{$IFNDEF D2006}, TntWideStrings{$ELSE}, WideStrings{$ENDIF}{$ENDIF};

{$R *.dfm}

function SelectSkin(SkinManager : TsSkinManager; SkinPlaces : TacSkinPlaces = spAllPlaces) : boolean;
begin
  Result := False;
  FormSkinSelect := TFormSkinSelect.Create(Application);
  FormSkinSelect.SkinTypes := stAllSkins;
  FormSkinSelect.SkinPlaces := SkinPlaces;//spAllPlaces;
  FormSkinSelect.sDirectoryEdit1.Text := SkinManager.SkinDirectory;
  FormSkinSelect.sName := SkinManager.SkinName;
  FormSkinSelect.SkinManager := SkinManager;   
  if FormSkinSelect.ShowModal = mrOk then begin
    SkinManager.SkinDirectory := FormSkinSelect.sDirectoryEdit1.Text;
    SkinManager.SkinName := FormSkinSelect.sListBox1.Items[FormSkinSelect.sListBox1.ItemIndex];
    Result := True;
  end;
  FreeAndNil(FormSkinSelect);
end;

function SelectSkin(var SkinName : string;
                    var SkinDir : string;
                    var SkinSaturation: integer;
                    var SkinHUE: integer;
                    SkinTypes : TacSkinTypes = stAllSkins) : boolean;
begin
  Result := False;
  FormSkinSelect := TFormSkinSelect.Create(Application);
  FormSkinSelect.SkinTypes := SkinTypes;
  FormSkinSelect.SkinPlaces := spExternal;
  FormSkinSelect.sDirectoryEdit1.Text := SkinDir;
  FormSkinSelect.sName := SkinName;
  FormSkinSelect.sSkinSaturation := SkinSaturation;
  FormSkinSelect.sSkinHUE := SkinHUE;
  FormSkinSelect.SkinManager := nil;

  if FormSkinSelect.ShowModal = mrOk then begin
    SkinName := FormSkinSelect.sListBox1.Items[FormSkinSelect.sListBox1.ItemIndex];
    SkinDir := FormSkinSelect.sDirectoryEdit1.Text;
    SkinSaturation := FormSkinSelect.sTrackBar1.Position;
    SkinHUE := FormSkinSelect.sTrackBar2.Position;
    Result := True;
  end;
  FreeAndNil(FormSkinSelect);
end;

function SelectSkin(NameList : TStringList; var SkinDir : string; SkinTypes : TacSkinTypes = stAllSkins) : boolean; overload;
var
  i : integer;
begin
  Result := False;
  if NameList = nil then Exit;

  FormSkinSelect := TFormSkinSelect.Create(Application);
  FormSkinSelect.SkinTypes := SkinTypes;
  FormSkinSelect.SkinPlaces := spExternal;
  FormSkinSelect.sDirectoryEdit1.Text := SkinDir;

  if NameList.Count > 0 then FormSkinSelect.sName := NameList[0] else FormSkinSelect.sName := '';
  FormSkinSelect.SkinManager := nil;
  if FormSkinSelect.ShowModal = mrOk then begin
    NameList.Clear;
    for I := 0 to FormSkinSelect.sListBox1.Items.Count - 1 do if FormSkinSelect.sListBox1.Selected[I] then NameList.Add(FormSkinSelect.sListBox1.Items[i]);
    SkinDir := FormSkinSelect.sDirectoryEdit1.Text;
    Result := True;
  end;
  FreeAndNil(FormSkinSelect);
end;

procedure TFormSkinSelect.sListBox1Click(Sender: TObject);
begin
  if (FormSkinSelect.sListBox1.ItemIndex > -1) and (FormSkinSelect.sListBox1.ItemIndex < FormSkinSelect.sListBox1.Items.Count) then begin
    FormSkinPreview.PreviewManager.SkinName := FormSkinSelect.sListBox1.Items[FormSkinSelect.sListBox1.ItemIndex];
    FormSkinPreview.PreviewManager.Active := True;
    sBitBtn1.Enabled := True;
  end
  else sBitBtn1.Enabled := False;
  FormSkinPreview.Visible := sBitBtn1.Enabled;
end;

procedure TFormSkinSelect.sDirectoryEdit1Change(Sender: TObject);
var
  i : integer;
begin
  if Assigned(FormSkinPreview) and Assigned(FormSkinPreview.PreviewManager) then begin
    FormSkinPreview.PreviewManager.SkinDirectory := sDirectoryEdit1.Text;
    if SkinManager <> nil then begin
      FormSkinPreview.PreviewManager.InternalSkins.Clear;
      for i := 0 to SkinManager.InternalSkins.Count - 1 do
        with FormSkinPreview.PreviewManager.InternalSkins.Add do Assign(SkinManager.InternalSkins[i]);
    end;
    sListBox1.Items.BeginUpdate;
    sListBox1.Items.Clear;
    case SkinPlaces of
      spAllPlaces : begin
{$IFDEF TNTUNICODE}
        FormSkinPreview.PreviewManager.GetSkinNames(TWideStrings(sListBox1.Items), SkinTypes);
{$ELSE}
        FormSkinPreview.PreviewManager.GetSkinNames(sListBox1.Items, SkinTypes);
{$ENDIF}
      end;
      spExternal : begin
{$IFDEF TNTUNICODE}
        FormSkinPreview.PreviewManager.GetExternalSkinNames(TWideStrings(sListBox1.Items), SkinTypes);
{$ELSE}
        FormSkinPreview.PreviewManager.GetExternalSkinNames(sListBox1.Items, SkinTypes);
{$ENDIF}
      end;
      spInternal : if FormSkinPreview.PreviewManager.InternalSkins.Count > 0 then for i := 0 to FormSkinPreview.PreviewManager.InternalSkins.Count - 1
        do sListBox1.Items.Add(FormSkinPreview.PreviewManager.InternalSkins[i].Name);
    end;
    sListBox1.Items.EndUpdate;

    if not sBitBtn1.Enabled and (sName <> '') then begin
      i := sListBox1.Items.IndexOf(sName);
      if i > -1 then sListBox1.ItemIndex := i;
    end;

    sBitBtn1.Enabled := sListBox1.ItemIndex > -1;
    if not sBitBtn1.Enabled then begin
      FormSkinPreview.Visible := False;
      FormSkinPreview.PreviewManager.Active := False;
    end
    else sListBox1.OnClick(sListBox1);
  end;
end;

procedure TFormSkinSelect.FormDestroy(Sender: TObject);
begin
  if FormSkinPreview <> nil then FreeAndNil(FormSkinPreview);
end;

procedure TFormSkinSelect.FormShow(Sender: TObject);
begin
  Caption := Traduzidos[148];
  sPanel1.Caption := Traduzidos[147];
  sBitBtn2.Caption := Traduzidos[120];
  sDirectoryEdit1.BoundLabel.Caption := Traduzidos[149] + ':';

  if FormSkinPreview = nil then
  begin
    FormSkinPreview := TFormSkinPreview.Create(Application);
    FormSkinPreview.Visible := False;
    FormSkinPreview.Align := alClient;
    sTrackBar1.Position := sSkinSaturation;
    sTrackBar2.Position := sSkinHUE;
    if FormSkinSelect.SkinPlaces = spInternal then sDirectoryEdit1.Visible := False
  end;

  sStickyLabel1.Caption := '  ' + Traduzidos[150] + ': ' + IntToStr(sTrackBar1.Position);
  sStickyLabel2.Caption := '  HUE: ' + IntToStr(sTrackBar2.Position);
  FormSkinPreview.Parent := sPanel1;
  sDirectoryEdit1.OnChange(sDirectoryEdit1);
end;

procedure TFormSkinSelect.sListBox1DblClick(Sender: TObject);
begin
  sBitBtn1.Click
end;

procedure TFormSkinSelect.sTrackBar1Change(Sender: TObject);
begin
  FormSkinPreview.PreviewManager.BeginUpdate;
  FormSkinPreview.PreviewManager.Saturation := sTrackBar1.Position;
  sStickyLabel1.Caption := '  ' + Traduzidos[150] + ': ' + IntToStr(sTrackBar1.Position);
  FormSkinPreview.PreviewManager.EndUpdate(True, False);
end;

procedure TFormSkinSelect.sTrackBar2Change(Sender: TObject);
begin
  FormSkinPreview.PreviewManager.BeginUpdate;
  FormSkinPreview.PreviewManager.HueOffset := sTrackBar2.Position;
  sStickyLabel2.Caption := '  HUE: ' + IntToStr(sTrackBar2.Position);
  FormSkinPreview.PreviewManager.EndUpdate(True, False);
end;

end.
