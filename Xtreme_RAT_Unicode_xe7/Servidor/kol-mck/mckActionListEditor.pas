unit mckActionListEditor;

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
  TfmActionListEditor = class(TForm)
  private
    pnButtons: TPanel;
    pnView: TPanel;
    btAdd: TButton;
    btDel: TButton;
    btUp: TButton;
    btDown: TButton;
    chkStayOnTop: TCheckBox;
    lvActions: TListView;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkStayOnTopClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure btDelClick(Sender: TObject);
    procedure btUpClick(Sender: TObject);
    procedure btDownClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvActionsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    {$IFDEF VER90} {$DEFINE OLDDELPHI} {$ENDIF}
    {$IFDEF VER100} {$DEFINE OLDDELPHI} {$ENDIF}
    {$IFDEF OLDDELPHI}
    procedure lvActionsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    {$ENDIF}
    procedure lvActionsEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FActionList: TComponent;
    procedure SetActionList(const Value: TComponent);
    procedure AdjustButtons;
    procedure SelectLV;
  public
    { Public declarations }
    property ActionList: TComponent read FActionList write SetActionList;
    procedure MakeActive( SelectAny: Boolean );
    constructor Create( AOwner: TComponent ); override;
    procedure NameChanged(Sender: TComponent);
  end;

var
  fmlvActionsEditor: TfmActionListEditor;

implementation

uses mirror, mckCtrls, mckObjs;

//{$R *.DFM}

procedure TfmActionListEditor.AdjustButtons;
var LI: TListItem;
begin
  LI := lvActions.Selected;
  if LI = nil then
  begin
    btAdd.Enabled := lvActions.Items.Count = 0;
    btDel.Enabled := FALSE;
    btUp.Enabled := FALSE;
    btDown.Enabled := FALSE;
  end
    else
  begin
    btAdd.Enabled := TRUE;
    btDel.Enabled := TRUE;
    btUp.Enabled := LI.Index > 0;
    btDown.Enabled := LI.Index < lvActions.Items.Count - 1;
  end;
end;

procedure TfmActionListEditor.FormResize(Sender: TObject);
begin
  lvActions.Columns[ 0 ].Width := lvActions.ClientWidth;
end;

procedure TfmActionListEditor.MakeActive(SelectAny: Boolean);
var F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
    Act: TKOLAction;
begin
  if lvActions.Items.Count > 0 then
  if lvActions.Selected = nil then
  if SelectAny then
    lvActions.Selected := lvActions.Items[ 0 ];
  if lvActions.Selected <> nil then
  begin
    Act := lvActions.Selected.Data;
    F := (FActionList as TKOLActionList).Owner as TForm;
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
        FD.SelectComponent( Act );
      end;
    end;
  end;
  AdjustButtons;
end;

procedure TfmActionListEditor.SetActionList(const Value: TComponent);
var LV: TKOLActionList;
begin
  FActionList := Value;
  LV := FActionList as TKOLActionList;
  Caption := LV.Name + ' actions';
end;

procedure TfmActionListEditor.FormShow(Sender: TObject);
var I: Integer;
    LI: TListItem;
    Act: TKOLAction;
    AL: TKOLActionList;
begin
  lvActions.Items.BeginUpdate;
  TRY

    lvActions.Items.Clear;
    if FActionList <> nil then
    if FActionList is TKOLActionList then
    begin
      AL := FActionList as TKOLActionList;
      for I := 0 to AL.Count-1 do
      begin
        LI := lvActions.Items.Add;
        Act := AL[ I ];
        LI.Data := Act;
        LI.Caption := Act.Name;
      end;
    end;

  FINALLY
    lvActions.Items.EndUpdate;
  END;
end;

procedure TfmActionListEditor.chkStayOnTopClick(Sender: TObject);
begin
  if chkStayOnTop.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure TfmActionListEditor.btAddClick(Sender: TObject);
var LI: TListItem;
    Act: TKOLAction;
    AL: TKOLActionList;
    I: Integer;
    S: String;
begin
  if FActionList = nil then Exit;
  if not( FActionList is TKOLActionList ) then Exit;
  AL := FActionList as TKOLActionList;
  LI := lvActions.Selected;
  if LI = nil then
  begin
    Act := TKOLAction.Create( AL.Owner );
    LI := lvActions.Items.Add;
    LI.Data := Act;
  end
    else
  begin
    if LI.Index >= lvActions.Items.Count then
      Act := TKOLAction.Create( AL.Owner )
    else
    begin
      Act := TKOLAction.Create( AL.Owner );
      Act.ActionList:=AL;
      AL.List.Move( lvActions.Items.Count, LI.Index + 1 );
    end;
    LI := lvActions.Items.Insert( LI.Index + 1 );
    LI.Data := Act;
  end;
  if AL <> nil then begin
    Act.ActionList:=AL;
    if AL.Owner is TForm then
      for I := 1 to MaxInt do
      begin
        S := 'Action' + IntToStr( I );
        if (AL.Owner as TForm).FindComponent( S ) = nil then
        if AL.FindComponent( S ) = nil then
        begin
          Act.Name := S;
          break;
        end;
      end;
  end;
  lvActions.Selected := nil;
  lvActions.Selected := LI;
  lvActions.ItemFocused := LI;
  LI.MakeVisible( FALSE );
end;

procedure TfmActionListEditor.btDelClick(Sender: TObject);
var LI: TListItem;
    J: Integer;
    Act: TKOLAction;
begin
  LI := lvActions.Selected;
  if LI <> nil then
  begin
    J := LI.Index;
    Act := LI.Data;
    Act.Free;
    LI.Free;
    if J >= lvActions.Items.Count then
      Dec( J );
    if J >= 0 then
    begin
      lvActions.Selected := lvActions.Items[ J ];
      lvActions.ItemFocused := lvActions.Selected;
    end;
  end;
  AdjustButtons;
  if lvActions.Items.Count = 0 then
    SelectLV;
end;

procedure TfmActionListEditor.btUpClick(Sender: TObject);
var LI, LI1: TListItem;
    I: Integer;
    AL: TKOLActionList;
begin
  if FActionList = nil then Exit;
  if not(FActionList is TKOLActionList) then Exit;
  AL := FActionList as TKOLActionList;
  LI := lvActions.Selected;
  if LI = nil then Exit;
  I := LI.Index - 1;
  LI1 := lvActions.Items.Insert( I );
  LI1.Caption := LI.Caption;
  LI1.Data := LI.Data;
  AL.List.Move( I + 1, I );
  LI.Free;
  lvActions.Selected := LI1;
  lvActions.ItemFocused := LI1;
  AdjustButtons;
end;

procedure TfmActionListEditor.btDownClick(Sender: TObject);
var LI, LI1: TListItem;
    AL: TKOLActionList;
begin
  if FActionList = nil then Exit;
  if not(FActionList is TKOLActionList) then Exit;
  AL := FActionList as TKOLActionList;
  LI := lvActions.Selected;
  if LI = nil then Exit;
  AL.List.Move( LI.Index, LI.Index + 1 );
  LI1 := lvActions.Items.Insert( LI.Index + 2 );
  LI1.Caption := LI.Caption;
  LI1.Data := LI.Data;
  LI.Free;
  lvActions.Selected := LI1;
  lvActions.ItemFocused := LI1;
  AdjustButtons;
end;

procedure TfmActionListEditor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_F2:     if (lvActions.Selected <> nil) then
               lvActions.Selected.EditCaption
             else exit;
  VK_INSERT: btAdd.Click;
  VK_DELETE: if not lvActions.IsEditing then btDel.Click else exit;
  VK_RETURN: if (ActiveControl = lvActions) and not lvActions.IsEditing and
                (lvActions.Selected <> nil) then
                lvActions.Selected.EditCaption
             else exit;   
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

procedure TfmActionListEditor.lvActionsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Selected then
    MakeActive( FALSE );
end;

{$IFDEF OLDDELPHI}
procedure TfmActionListEditor.lvActionsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if lvActions.Selected <> nil then
    MakeActive( FALSE );
end;
{$ENDIF}

procedure TfmActionListEditor.lvActionsEdited(Sender: TObject;
  Item: TListItem; var S: String);
var Act: TKOLAction;
begin
  if Item = nil then Exit;
  if S = '' then begin
    S:=Item.Caption;
    exit;
  end;
  Act := Item.Data;
  Act.Name := S;
  MakeActive( FALSE );
end;

procedure TfmActionListEditor.FormDestroy(Sender: TObject);
var LV: TKOLActionList;
begin
  Rpt( 'Destroying ActionList columns editor', WHITE );
  if FActionList = nil then Exit;
  LV := FActionList as TKOLActionList;
  LV.ActiveDesign := nil;
end;

procedure TfmActionListEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Rpt( 'Closing ActionList columns editor', WHITE );
  SelectLV;
  modalResult := mrOK;
end;

procedure TfmActionListEditor.NameChanged(Sender: TComponent);
var
  i: integer;
begin
  for i:=0 to lvActions.Items.Count - 1 do
    if lvActions.Items[i].Data = Sender then begin
      lvActions.Items[i].Caption:=Sender.Name;
    end;
end;

procedure TfmActionListEditor.SelectLV;
var F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
begin
  if FActionList <> nil then
  begin
    F := (FActionList as TKOLActionList).Owner as TForm;
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
              FD.SelectComponent( FActionList );
            except
              Rpt( 'EXCEPTION *** Could not clear selection!', WHITE )
            end;
          end;

        end;
    end;
  end;
end;

constructor TfmActionListEditor.Create(AOwner: TComponent);
begin
  CreateNew(AOwner);

  Left := 246;
  Top := 107;
  Width := 268;
  Height := 314;
  HorzScrollBar.Visible := False;
  VertScrollBar.Visible := False;
  BorderIcons := [biSystemMenu];
  Caption := 'Actions';
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
    lvActions := TListView.Create( pnView );
    with lvActions do
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
      OnEdited := lvActionsEdited;
      {$IFDEF OLDDELPHI}
      OnChange := lvActionsChange;
      {$ELSE}
      OnSelectItem := lvActionsSelectItem;
      {$ENDIF}
    end;
  end;
end;

end.