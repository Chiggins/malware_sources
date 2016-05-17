unit mckLVColumnsEditor;

interface

{$I KOLDEF.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls,
  {$IFDEF _D6orHigher}
  DesignIntf, DesignEditors, DesignConst, Variants
  {$ELSE}
  DsgnIntf
  {$ENDIF}
  ;

type
  TfmLVColumnsEditor = class(TForm)
  private
    pnButtons: TPanel;
    pnView: TPanel;
    btAdd: TButton;
    btDel: TButton;
    btUp: TButton;
    btDown: TButton;
    chkStayOnTop: TCheckBox;
    lvColumns: TListView;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkStayOnTopClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure btDelClick(Sender: TObject);
    procedure btUpClick(Sender: TObject);
    procedure btDownClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvColumnsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    {$IFDEF VER90} {$DEFINE OLDDELPHI} {$ENDIF}
    {$IFDEF VER100} {$DEFINE OLDDELPHI} {$ENDIF}
    {$IFDEF OLDDELPHI}
    procedure lvColumnsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    {$ENDIF}
    procedure lvColumnsEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FListView: TComponent;
    procedure SetListView(const Value: TComponent);
    procedure AdjustButtons;
    procedure SelectLV;
  public
    { Public declarations }
    property ListView: TComponent read FListView write SetListView;
    procedure MakeActive( SelectAny: Boolean );
    constructor Create( AOwner: TComponent ); override;
  end;

var
  fmLVColumnsEditor: TfmLVColumnsEditor;

implementation

uses mirror, mckCtrls, mckObjs;

procedure TfmLVColumnsEditor.AdjustButtons;
var LI: TListItem;
begin
  LI := lvColumns.Selected;
  if LI = nil then
  begin
    btAdd.Enabled := lvColumns.Items.Count = 0;
    btDel.Enabled := FALSE;
    btUp.Enabled := FALSE;
    btDown.Enabled := FALSE;
  end
    else
  begin
    btAdd.Enabled := TRUE;
    btDel.Enabled := TRUE;
    btUp.Enabled := LI.Index > 0;
    btDown.Enabled := LI.Index < lvColumns.Items.Count - 1;
  end;
end;

procedure TfmLVColumnsEditor.FormResize(Sender: TObject);
begin
  lvColumns.Columns[ 0 ].Width := lvColumns.ClientWidth;
end;

procedure TfmLVColumnsEditor.MakeActive(SelectAny: Boolean);
var F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
    Col: TKOLListViewColumn;
begin
  if lvColumns.Items.Count > 0 then
  if lvColumns.Selected = nil then
  if SelectAny then
    lvColumns.Selected := lvColumns.Items[ 0 ];
  if lvColumns.Selected <> nil then
  begin
    Col := lvColumns.Selected.Data;
    F := (FListView as TKOLListView).Owner as TForm;
    if F <> nil then
    begin
  {$IFDEF _D6orHigher}
        F.Designer.QueryInterface(IFormDesigner,D);
  {$ELSE}
        D := F.Designer;
  {$ENDIF}
      if D <> nil then
      if QueryFormDesigner( D, FD ) then
      begin
        RemoveSelection( FD );
        FD.SelectComponent( Col );
      end;
    end;
  end;
  AdjustButtons;
end;

procedure TfmLVColumnsEditor.SetListView(const Value: TComponent);
var LV: TKOLListView;
begin
  FListView := Value;
  LV := FListView as TKOLListView;
  Caption := LV.Name + ' columns';
end;

procedure TfmLVColumnsEditor.FormShow(Sender: TObject);
var I: Integer;
    LI: TListItem;
    Col: TKOLListViewColumn;
    LV: TKOLListView;
begin
  lvColumns.Items.BeginUpdate;
  TRY

    lvColumns.Items.Clear;
    if FListView <> nil then
    if FListView is TKOLListView then
    begin
      LV := FListView as TKOLListView;
      for I := 0 to LV.Cols.Count-1 do
      begin
        LI := lvColumns.Items.Add;
        Col := LV.Cols[ I ];
        LI.Data := Col;
        LI.Caption := Col.Caption;
      end;
    end;

  FINALLY
    lvColumns.Items.EndUpdate;
  END;
end;

procedure TfmLVColumnsEditor.chkStayOnTopClick(Sender: TObject);
begin
  if chkStayOnTop.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure TfmLVColumnsEditor.btAddClick(Sender: TObject);
var LI: TListItem;
    Col: TKOLListViewColumn;
    LV: TKOLListView;
    I: Integer;
    S: String;
begin
  if FListView = nil then Exit;
  if not( FListView is TKOLListView ) then Exit;
  LV := FListView as TKOLListView;
  LI := lvColumns.Selected;
  if LI = nil then
  begin
    Col := TKOLListViewColumn.Create( LV );
    LI := lvColumns.Items.Add;
    LI.Data := Col;
  end
    else
  begin
    if LI.Index >= lvColumns.Items.Count then
      Col := TKOLListViewColumn.Create( LV )
    else
    begin
      Col := TKOLListViewColumn.Create( LV );
      LV.Cols.Move( lvColumns.Items.Count, LI.Index + 1 );
    end;
    LI := lvColumns.Items.Insert( LI.Index + 1 );
    LI.Data := Col;
  end;
  if LV <> nil then
  if LV.Owner is TForm then
  for I := 1 to MaxInt do
  begin
    S := 'Col' + IntToStr( I );
    if (LV.Owner as TForm).FindComponent( S ) = nil then
    if LV.FindComponent( S ) = nil then
    begin
      Col.Name := S;
      break;
    end;
  end;
  if LV.HasOrderedColumns then
    Col.LVColOrder := LI.Index;
  lvColumns.Selected := nil;
  lvColumns.Selected := LI;
  lvColumns.ItemFocused := LI;
  LI.MakeVisible( FALSE );
  LI.EditCaption;
end;

procedure TfmLVColumnsEditor.btDelClick(Sender: TObject);
var LI: TListItem;
    J: Integer;
    Col: TKOLListViewColumn;
begin
  LI := lvColumns.Selected;
  if LI <> nil then
  begin
    J := LI.Index;
    Col := LI.Data;
    Col.Free;
    LI.Free;
    if J >= lvColumns.Items.Count then
      Dec( J );
    if J >= 0 then
    begin
      lvColumns.Selected := lvColumns.Items[ J ];
      lvColumns.ItemFocused := lvColumns.Selected;
    end;
  end;
  AdjustButtons;
  if lvColumns.Items.Count = 0 then
    SelectLV;
end;

procedure TfmLVColumnsEditor.btUpClick(Sender: TObject);
var LI, LI1: TListItem;
    I: Integer;
    LV: TKOLListView;
    Col: TKOLListViewColumn;
begin
  if FListView = nil then Exit;
  if not(FListView is TKOLListView) then Exit;
  LV := FListView as TKOLListView;
  LI := lvColumns.Selected;
  if LI = nil then Exit;
  I := LI.Index - 1;
  LI1 := lvColumns.Items.Insert( I );
  LI1.Caption := LI.Caption;
  LI1.Data := LI.Data;
  LV.Cols.Move( I + 1, I );
  LI.Free;
  lvColumns.Selected := LI1;
  lvColumns.ItemFocused := LI1;
  Col := LI1.Data;
  if Col.LVColOrder = LI1.Index + 1 then
    Col.LVColOrder := LI1.Index;
  AdjustButtons;
end;

procedure TfmLVColumnsEditor.btDownClick(Sender: TObject);
var LI, LI1: TListItem;
    LV: TKOLListView;
    Col: TKOLListViewColumn;
begin
  if FListView = nil then Exit;
  if not(FListView is TKOLListView) then Exit;
  LV := FListView as TKOLListView;
  LI := lvColumns.Selected;
  if LI = nil then Exit;
  LV.Cols.Move( LI.Index, LI.Index + 1 );
  LI1 := lvColumns.Items.Insert( LI.Index + 2 );
  LI1.Caption := LI.Caption;
  LI1.Data := LI.Data;
  LI.Free;
  lvColumns.Selected := LI1;
  lvColumns.ItemFocused := LI1;
  Col := LI1.Data;
  if Col.LVColOrder = LI1.Index - 1 then
    Col.LVColOrder := LI1.Index;
  AdjustButtons;
end;

procedure TfmLVColumnsEditor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_INSERT: btAdd.Click;
  VK_DELETE: if not lvColumns.IsEditing then btDel.Click;
  VK_RETURN: if (ActiveControl = lvColumns) and not lvColumns.IsEditing and
                (lvColumns.Selected <> nil) then
                lvColumns.Selected.EditCaption;
  VK_UP:     if (GetKeyState( VK_CONTROL ) < 0) then
                btUp.Click
             else Exit;
  VK_DOWN:   if (GetKeyState( VK_CONTROL ) < 0) then
                btDown.Click
             else Exit;
  else Exit;
  end;
  Key := 0;
end;

procedure TfmLVColumnsEditor.lvColumnsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Selected then
    MakeActive( FALSE );
end;

{$IFDEF OLDDELPHI}
procedure TfmLVColumnsEditor.lvColumnsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if lvColumns.Selected <> nil then
    MakeActive( FALSE );
end;
{$ENDIF}

procedure TfmLVColumnsEditor.lvColumnsEdited(Sender: TObject;
  Item: TListItem; var S: String);
var Col: TKOLListViewColumn;
begin
  if Item = nil then Exit;
  Col := Item.Data;
  Col.Caption := S;
  MakeActive( FALSE );
end;

procedure TfmLVColumnsEditor.FormDestroy(Sender: TObject);
var LV: TKOLListView;
begin
  if FListView = nil then Exit;
  LV := FListView as TKOLListView;
  LV.ActiveDesign := nil;
end;

procedure TfmLVColumnsEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Rpt( 'Closing Listview columns editor', WHITE );
  SelectLV;
  modalResult := mrOK;
end;

procedure TfmLVColumnsEditor.SelectLV;
var F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
begin
  if FListView <> nil then
  begin
    F := (FListView as TKOLListView).Owner as TForm;
    if F <> nil then
    begin
        Rpt( 'Form found: ' + F.Name, WHITE );

  {$IFDEF _D6orHigher}                                  //
        F.Designer.QueryInterface(IFormDesigner,D);     //
  {$ELSE}                                               //
        D := F.Designer;
  {$ENDIF}                                              //
        if D <> nil then
        begin

          Rpt( 'IDesigner interface returned', WHITE );
          if QueryFormDesigner( D, FD ) then
          begin
            Rpt( 'IFormDesigner interface quered', WHITE );
            try
              RemoveSelection( FD );
              FD.SelectComponent( FListView );
            except
              Rpt( 'EXCEPTION *** Could not clear selection!', WHITE )
            end;
          end;

        end;
    end;
  end;
end;

constructor TfmLVColumnsEditor.Create(AOwner: TComponent);
begin
  CreateNew(AOwner);
  Left := 246;
  Top := 107;
  Width := 268;
  Height := 314;
  HorzScrollBar.Visible := False;
  VertScrollBar.Visible := False;
  BorderIcons := [biSystemMenu];
  Caption := 'Columns';
  //Color := clBtnFace;
  //Font.Charset := DEFAULT_CHARSET;
  //Font.Color := clWindowText;
  //Font.Height := -11;
  Font.Name := 'MS Sans Serif';
  //Font.Style := [];
  KeyPreview := True;
  //OldCreateOrder := False;
  Scaled := False;
  OnClose := FormClose;
  OnDestroy := FormDestroy;
  OnKeyDown := FormKeyDown;
  OnResize := FormResize;
  OnShow := FormShow;
  PixelsPerInch := 96;
  //TextHeight := 13;
  pnButtons := TPanel.Create( Self );
  with pnButtons do
  begin
    Parent := Self;
    Left := 150;
    Top := 0;
    Width := 110;
    Height := 287;
    Align := alRight;
    BevelOuter := bvNone;
    TabOrder := 0;
    btAdd := TButton.Create( pnButtons );
    with btAdd do
    begin
      Parent := pnButtons;
      Left := 4;
      Top := 4;
      Width := 101;
      Height := 25;
      Caption := '&Add';
      TabOrder := 0;
      OnClick := btAddClick;
    end;
    btDel := TButton.Create( pnButtons );
    with btDel do
    begin
      Parent := pnButtons;
      Left := 4;
      Top := 36;
      Width := 101;
      Height := 25;
      Caption := '&Delete';
      TabOrder := 1;
      OnClick := btDelClick;
    end;
    btUp := TButton.Create( pnButtons );
    with btUp do
    begin
      Parent := pnButtons;
      Left := 4;
      Top := 68;
      Width := 49;
      Height := 25;
      Caption := '&Up';
      TabOrder := 2;
      OnClick := btUpClick;
    end;
    btDown := TButton.Create( pnButtons );
    with btDown do
    begin
      Parent := pnButtons;
      Left := 56;
      Top := 68;
      Width := 49;
      Height := 25;
      Caption := '&Down';
      TabOrder := 3;
      OnClick := btDownClick;
    end;
    chkStayOnTop := TCheckBox.Create( pnButtons );
    with chkStayOnTop do
    begin
      Parent := pnButtons;
      Left := 4;
      Top := 100;
      Width := 101;
      Height := 17;
      Caption := 'Stay On &Top';
      TabOrder := 4;
      OnClick := chkStayOnTopClick;
    end;
  end;
  pnView := TPanel.Create( Self );
  with pnView do
  begin
    Parent := Self;
    Left := 0;
    Top := 0;
    Width := 150;
    Height := 287;
    Align := alClient;
    BevelOuter := bvNone;
    BorderWidth := 4;
    TabOrder := 1;
    lvColumns := TListView.Create( pnView );
    with lvColumns do
    begin
      Parent := pnView;
      Left := 4;
      Top := 4;
      Width := 142;
      Height := 279;
      Align := alClient;
      Columns.Add;
      HideSelection := False;
      {$IFNDEF VER90}
      RowSelect := True;
      {$ENDIF}
      ShowColumnHeaders := False;
      TabOrder := 0;
      ViewStyle := vsReport;
      OnEdited := lvColumnsEdited;
      {$IFDEF OLDDELPHI}
      OnChange := lvColumnsChange;
      {$ELSE}
      OnSelectItem := lvColumnsSelectItem;
      {$ENDIF}
    end;
  end;
end;

end.