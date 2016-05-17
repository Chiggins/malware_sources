unit mckMenuEditor;

interface

{$I KOLDEF.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ComCtrls,
//*///////////////////////////////////////
     {$IFDEF _D6orHigher}               //
     DesignIntf, DesignEditors,         //
     {$ELSE}                            //
//////////////////////////////////////////
  DsgnIntf,
//*///////////////////////////////////////
     {$ENDIF}                           //
//*///////////////////////////////////////
  ToolIntf, EditIntf, ExptIntf;

type
  TKOLMenuDesign = class(TForm)
  public
    tvMenu: TTreeView;
    btAdd: TButton;
    btDelete: TButton;
    btSubmenu: TButton;
    btUp: TBitBtn;
    btDown: TBitBtn;
    btOK: TButton;
    btInsert: TButton;
    chbStayOnTop: TCheckBox;
    procedure btInsertClick(Sender: TObject);
    procedure tvMenuChange(Sender: TObject; Node: TTreeNode);
    procedure btAddClick(Sender: TObject);
    procedure btSubmenuClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure chbStayOnTopClick(Sender: TObject);
    procedure btUpClick(Sender: TObject);
    procedure btDownClick(Sender: TObject);
  private
    FMenuComponent: TComponent;
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Set_Menu(const Value: TComponent);
    { Private declarations }
    procedure NewItem( Insert, SubItem: Boolean );
    procedure CheckButtons;
    function MenuItemTitle( MI: TComponent ): String;
  public
    { Public declarations }
    Constructor Create( AOwner: TComponent ); override;
    property MenuComponent: TComponent read FMenuComponent write Set_Menu;
    procedure MakeActive;
    procedure RefreshItems;
  end;

var
  KOLMenuDesign: TKOLMenuDesign;

implementation

uses
  mckObjs, mirror;

//{$R *.DFM}
{$R MckMenuEdArrows.res}

{ TMenuDesign }

procedure TKOLMenuDesign.MakeActive;
var MI: TKOLMenuItem;
    F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
begin
  if tvMenu.Items.Count > 0 then
  if tvMenu.Selected = nil then
    tvMenu.Selected := tvMenu.Items[ 0 ];
  if tvMenu.Selected <> nil then
  begin
    MI := tvMenu.Selected.Data;
    if MI = nil then Exit;
    // set here MI as a current component in Object Inspector
    F := (MenuComponent as TKOLMenu).ParentForm;
    if F <> nil then
    begin
//*///////////////////////////////////////////////////////
  {$IFDEF _D6orHigher}                                  //
        F.Designer.QueryInterface(IFormDesigner,D);     //
  {$ELSE}                                               //
//*///////////////////////////////////////////////////////
      D := F.Designer;
//*///////////////////////////////////////////////////////
  {$ENDIF}                                              //
//*///////////////////////////////////////////////////////
      if D <> nil then
      if QueryFormDesigner( D, FD ) then
      begin
        RemoveSelection( FD );
        FD.SelectComponent( MI );
      end;
    end;
  end;
  CheckButtons;
end;

procedure TKOLMenuDesign.Set_Menu(const Value: TComponent);
var M: TKOLMenu;
    I: Integer;
    MI: TKOLMenuItem;

    procedure AddItem( Node: TTreeNode; MI: TKOLMenuItem );
    var NewNode: TTreeNode;
        I: Integer;
    begin
      NewNode := tvMenu.Items.AddChild( Node, MenuItemTitle( MI ) );
      NewNode.Data := MI;
      for I := 0 to MI.Count - 1 do
        AddItem( NewNode, MI.SubItems[ I ] );
    end;

begin
  FMenuComponent := Value;
  M := Value as TKOLMenu;
  tvMenu.HandleNeeded;
  tvMenu.Items.BeginUpdate;
  try

    tvMenu.Items.Clear;
    for I := 0 to M.Count - 1 do
    begin
      MI := M.Items[ I ];
      AddItem( nil, MI );
    end;

    if tvMenu.Items.Count > 0 then
      tvMenu.FullExpand;
  finally
    tvMenu.Items.EndUpdate;
  end;
  {$IFNDEF _D5orD6} // Bug in earlier Delphi2..Delphi4
  tvMenu.Items.EndUpdate;
  {$ENDIF}

  CheckButtons;
  MakeActive;
end;

procedure TKOLMenuDesign.btInsertClick(Sender: TObject);
begin
  NewItem( True, False );
end;

procedure TKOLMenuDesign.FormDestroy(Sender: TObject);
var M: TKOLMenu;
begin
  if MenuComponent <> nil then
  try
    M := MenuComponent as TKOLMenu;
    M.ActiveDesign := nil;
  except
  end;
end;

procedure TKOLMenuDesign.tvMenuChange(Sender: TObject; Node: TTreeNode);
begin
  MakeActive;
  CheckButtons;
end;

procedure TKOLMenuDesign.CheckButtons;
begin
  btDelete.Enabled := (tvMenu.Selected <> nil) and (tvMenu.Selected.Count = 0);
  btSubmenu.Enabled := (tvMenu.Selected <> nil) and (tvMenu.Selected.Count = 0);
  btUp.Enabled := (tvMenu.Selected <> nil) and (tvMenu.Selected.GetPrevSibling <> nil);
  btDown.Enabled := (tvMenu.Selected <> nil) and (tvMenu.Selected.GetNextSibling <> nil);
end;

procedure TKOLMenuDesign.NewItem(Insert, Subitem: Boolean);
var N, NN: TTreeNode;
    MI: TKOLMenuItem;
    C: TComponent;
    I: Integer;
    AParent: TKOLMenuItem;
begin
  N := tvMenu.Selected;
  if (N = nil) and (tvMenu.Items.Count > 0) then Exit;

  if (N = nil) or (N.Parent = nil) and not SubItem then
    C := MenuComponent
  else
  if (N <> nil) and SubItem then
    C := N.Data
  else
    C := N.Parent.Data;

  if (N <> nil) and not Subitem and not Insert then
  if N.GetNextSibling <> nil then
  begin
    Insert := True;
    N := N.GetNextSibling;
  end;

  AParent := nil;
  if C is TKOLMenuItem then
    AParent := C as TKOLMenuItem;
  if Subitem or (N = nil) then
    MI := TKOLMenuItem.Create( MenuComponent, AParent, nil )
  else
  if not Insert and (N.GetNextSibling = nil) then
    MI := TKOLMenuItem.Create( MenuComponent, AParent, nil )
  else
    MI := TKOLMenuItem.Create( MenuComponent, AParent, N.Data );

  for I := 1 to MaxInt do
  begin
    if MenuComponent <> nil then
    if (MenuComponent as TKOLMenu).NameAlreadyUsed( 'N' + IntToStr( I ) ) then
      continue;
    MI.Name := 'N' + IntToStr( I );
    break;
  end;

  if (N = nil) or (not Insert and not SubItem) then
    NN := tvMenu.Items.Add( N, '[ ' + MI.Name + ' ]' )
  else
  if not Subitem then
    NN := tvMenu.Items.Insert( N, '[ ' + MI.Name + ' ]' )
  else
  begin
    NN := tvMenu.Items.AddChild( N, '[ ' + MI.Name + ' ]' );
  end;

  NN.Data := MI;
  NN.MakeVisible;
  tvMenu.Selected := NN;
  CheckButtons;
  MakeActive;
end;

procedure TKOLMenuDesign.RefreshItems;
var I: Integer;
    N: TTreeNode;
    MI: TKOLMenuItem;
begin
  for I := 0 to tvMenu.Items.Count - 1 do
  begin
    N := tvMenu.Items[ I ];
    MI := N.Data;
    if MI <> nil then
      N.Text := MenuItemTitle( MI );
  end;
end;

procedure TKOLMenuDesign.btAddClick(Sender: TObject);
begin
  NewItem( False, False );
end;

procedure TKOLMenuDesign.btSubmenuClick(Sender: TObject);
begin
  NewItem( False, True );
end;

procedure TKOLMenuDesign.btDeleteClick(Sender: TObject);
var N, NN: TTreeNode;
    MI: TKOLMenuItem;
    S: String;
    F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
begin
  N := tvMenu.Selected;
  if N = nil then Exit;
  S := N.Text;
  Rpt( 'Deleting: ' + S, WHITE );
  MI := N.Data;
  if MI = nil then Exit;
  NN := N.GetNextSibling;
  if NN = nil then
    NN := N.GetPrevSibling;
  if NN = nil then
    NN := N.Parent;
  if NN = nil then
  begin
    if MenuComponent <> nil then
    begin
      F := (MenuComponent as TKOLMenu).ParentForm;
      if F <> nil then
      begin
//*///////////////////////////////////////////////////////
  {$IFDEF _D6orHigher}                                  //
        F.Designer.QueryInterface(IFormDesigner,D);     //
  {$ELSE}                                               //
//*///////////////////////////////////////////////////////
        D := F.Designer;
//*///////////////////////////////////////////////////////
  {$ENDIF}                                              //
//*///////////////////////////////////////////////////////
        if D <> nil then
        if QueryFormDesigner( D, FD ) then
        begin
          RemoveSelection( FD );
          FD.SelectComponent( MenuComponent );
        end;
      end;
    end;
  end;
  N.Free;
  Rpt( 'Deleted: ' + S, WHITE );
  S := MI.Name;
  MI.Free;
  Rpt( 'ITEM Destroyed: ' + S, WHITE );
  if NN <> nil then
  begin
    tvMenu.Selected := NN;
    Rpt( 'Selected: ' + IntToStr( Integer( NN ) ), WHITE );
  end;
  if MenuComponent <> nil then
  begin
    (MenuComponent as TKOLMenu).Change;
    Rpt( 'Changed: ' + MenuComponent.Name, WHITE );
  end;
  CheckButtons;
  Rpt( 'Buttons checked. Deleting of ' + S + ' finished.', WHITE );
end;

procedure TKOLMenuDesign.btOKClick(Sender: TObject);
begin
  Close;
end;

function TKOLMenuDesign.MenuItemTitle(MI: TComponent): String;
begin
  Result := (MI as TKOLMenuITem).Caption;
  if Result = '' then
    Result := '[ ' + MI.Name + ' ]';
end;

procedure TKOLMenuDesign.FormClose(Sender: TObject;
  var Action: TCloseAction);
var F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
begin
  if MenuComponent <> nil then
  begin
    Rpt( 'Closing KOLMenuEditor form', WHITE );
    F := (MenuComponent as TKOLMenu).ParentForm;
    if F <> nil then
    begin
      Rpt( 'Form found: ' + F.Name, WHITE );
//*///////////////////////////////////////////////////////
  {$IFDEF _D6orHigher}                                  //
        F.Designer.QueryInterface(IFormDesigner,D);     //
  {$ELSE}                                               //
//*///////////////////////////////////////////////////////
      D := F.Designer;
//*///////////////////////////////////////////////////////
  {$ENDIF}                                              //
//*///////////////////////////////////////////////////////
      if D <> nil then
      begin
        Rpt( 'IDesigner interface returned', WHITE );
        if QueryFormDesigner( D, FD ) then
        begin
          Rpt( 'IFormDesigner interface quered', WHITE );
          try
            RemoveSelection( FD );
            FD.SelectComponent( MenuComponent );
          except
            Rpt( 'EXCEPTION *** Could not clear selection!', WHITE )
          end;
        end;
      end;
    end;
  end;
end;

procedure TKOLMenuDesign.chbStayOnTopClick(Sender: TObject);
begin
  if chbStayOnTop.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure TKOLMenuDesign.btUpClick(Sender: TObject);
var CurNode: TTreeNode;
    CurMI: TKOLMenuItem;
    AC: TControl;
begin
  CurNode := tvMenu.Selected;
  if CurNode = nil then Exit;
  if CurNode.GetPrevSibling = nil then Exit;
  CurMI := CurNode.Data;
  if CurMI = nil then Exit;
  if MenuComponent = nil then Exit;
  if not(MenuComponent is TKOLMenu) then Exit;
  CurMI.MoveUp;
  CurNode.MoveTo( CurNode.GetPrevSibling, naInsert );
  AC := ActiveControl;
  CheckButtons;
  if AC = btUp then
  if not btUp.Enabled then
    PostMessage( Handle, WM_NEXTDLGCTL, 0, 0 );
end;

procedure TKOLMenuDesign.btDownClick(Sender: TObject);
var CurNode: TTreeNode;
    CurMI: TKOLMenuItem;
    AC: TControl;
begin
  CurNode := tvMenu.Selected;
  if CurNode = nil then Exit;
  if CurNode.GetNextSibling = nil then Exit;
  CurMI := CurNode.Data;
  if CurMI = nil then Exit;
  if MenuComponent = nil then Exit;
  if not(MenuComponent is TKOLMenu) then Exit;
  CurMI.MoveDown;
  if CurNode.GetNextSibling.GetNextSibling = nil then
    CurNode.MoveTo( CurNode.GetNExtSibling, naAdd )
  else
    CurNode.MoveTo( CurNode.GetNextSibling.GetNextSibling, naInsert );
  AC := ActiveControl;
  CheckButtons;
  if AC = btDown then
  if not btDown.Enabled then
    PostMessage( Handle, WM_NEXTDLGCTL, 0, 0 );
end;

procedure TKOLMenuDesign.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_DELETE:
    if btDelete.Enabled then
      btDelete.Click;
  VK_INSERT:
    if btInsert.Enabled then
      btInsert.Click;
  VK_UP:
    if GetKeyState( VK_CONTROL ) < 0 then
    if btUp.Enabled then
      btUp.Click;
  VK_DOWN:
    if GetKeyState( VK_CONTROL ) < 0 then
    if btDown.Enabled then
      btDown.Click;
  VK_RIGHT:
    begin
      if (tvMenu.Selected <> nil) and (tvMenu.Selected.Count = 0) then
      begin
        if btSubmenu.Enabled then
          btSubmenu.Click;
        Key := 0;
      end
        {else
      if ActiveControl <> tvMenu then
        Key := 0};
    end;
  VK_LEFT:
    begin
      {if ActiveControl <> tvMenu then
        Key := 0};
    end;
  end;
end;

constructor TKOLMenuDesign.Create(AOwner: TComponent);
begin
  CreateNew(AOwner);
  Left := 299;
  Top := 81;
  BorderIcons := [biSystemMenu, biMinimize];
  BorderStyle := bsToolWindow              ;
  ClientHeight := 299                      ;
  ClientWidth := 343                       ;
  //Color := clBtnFace                       ;
  //Font.Charset := DEFAULT_CHARSET          ;
  //Font.Color := clWindowText               ;
  //Font.Height := -11                       ;
  //Font.Name := 'MS Sans Serif'             ;
  //Font.Style := []                         ;
  KeyPreview := True                       ;
  //OldCreateOrder := False                  ;
  {$IFDEF _D4orD5}
  Position := poDesktopCenter              ;
  {$ENDIF}
  {$IFDEF _D2orD3}
  Position := poScreenCenter              ;
  {$ENDIF}
  Scaled := False                          ;
  Visible := True                          ;
  OnClose := FormClose                     ;
  OnDestroy := FormDestroy                 ;
  OnKeyDown := FormKeyDown                 ;
  //PixelsPerInch := 96                      ;
  //TextHeight := 13                         ;

  tvMenu := TTreeView.Create( Self )       ;
  tvMenu.Parent := Self                    ;
  tvMenu.Left := 6                         ;
  tvMenu.Top := 6                          ;
  tvMenu.Width := 227                      ;
  tvMenu.Height := 285                     ;
  tvMenu.HideSelection := False            ;
  //tvMenu.Indent := 19                      ;
  tvMenu.ReadOnly := True                  ;
  //tvMenu.TabOrder := 0                     ;
  tvMenu.OnChange := tvMenuChange          ;

  btOK := TButton.Create( Self )           ;
  btOK.Parent := Self;
  btOK.Left := 244                         ;
  btOK.Top := 6                            ;
  btOK.Width := 91                         ;
  btOK.Height := 25                        ;
  btOK.Caption := 'Close'                  ;
  //btOK.TabOrder := 1                       ;
  btOK.OnClick := btOKClick                ;

  btUp := TBitBtn.Create( Self )           ;
  btUp.Parent := Self;
  btUp.Left := 244                         ;
  btUp.Top := 90                           ;
  btUp.Width := 40                         ;
  btUp.Height := 27                        ;
  btUp.Enabled := False                    ;
  //btUp.TabOrder := 2                       ;
  btUp.OnClick := btUpClick                ;
  btUp.Glyph.Handle := LoadBitmap( hInstance, 'MCKARROWUP' );

  btDown := TBitBtn.Create( Self )         ;
  btDown.Parent := Self;
  btDown.Left := 295                       ;
  btDown.Top := 90                         ;
  btDown.Width := 40                       ;
  btDown.Height := 27                      ;
  btDown.Enabled := False                  ;
  //btDown.TabOrder := 3                     ;
  btDown.OnClick := btDownClick            ;
  btDown.Glyph.Handle := LoadBitmap( hInstance, 'MCKARROWDN' );

  btInsert := TButton.Create( Self )       ;
  btInsert.Parent := Self;
  btInsert.Left := 244                     ;
  btInsert.Top := 170                      ;
  btInsert.Width := 91                     ;
  btInsert.Height := 25                    ;
  btInsert.Caption := 'Insert'             ;
  //btInsert.TabOrder := 4                   ;
  btInsert.OnClick := btInsertClick        ;

  btAdd := TButton.Create( Self )          ;
  btAdd.Parent := Self;
  btAdd.Left := 244                        ;
  btAdd.Top := 202                         ;
  btAdd.Width := 91                        ;
  btAdd.Height := 25                       ;
  btAdd.Caption := 'Add'                   ;
  //btAdd.TabOrder := 5                      ;
  btAdd.OnClick := btAddClick              ;

  btDelete := TButton.Create( Self )       ;
  btDelete.Parent := Self;
  btDelete.Left := 244                     ;
  btDelete.Top := 234                      ;
  btDelete.Width := 91                     ;
  btDelete.Height := 25                    ;
  btDelete.Caption := 'Delete'             ;
  btDelete.Enabled := False                ;
  //btDelete.TabOrder := 6                   ;
  btDelete.OnClick := btDeleteClick        ;

  btSubmenu := TButton.Create( Self )      ;
  btSubMenu.Parent := Self;
  btSubmenu.Left := 244                    ;
  btSubmenu.Top := 266                     ;
  btSubmenu.Width := 91                    ;
  btSubmenu.Height := 25                   ;
  btSubmenu.Caption := 'New submenu'       ;
  btSubmenu.Enabled := False               ;
  //btSubmenu.TabOrder := 7                  ;
  btSubmenu.OnClick := btSubmenuClick      ;

  chbStayOnTop := TCheckBox.Create( Self ) ;
  chbStayOnTop.Parent := Self;
  chbStayOnTop.Left := 244                 ;
  chbStayOnTop.Top := 40                   ;
  chbStayOnTop.Width := 91                 ;
  chbStayOnTop.Height := 17                ;
  chbStayOnTop.Caption := 'Stay On Top'    ;
  //chbStayOnTop.TabOrder := 8               ;
  chbStayOnTop.OnClick := chbStayOnTopClick;
end;

end.