unit mckToolbarEditor;

interface

{$I KOLDEF.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, {$IFDEF _D3orHigher} ExtDlgs, {$ENDIF}
//////////////////////////////////////////////////
     {$IFDEF _D6orHigher}                       //
     DesignIntf, DesignEditors, DesignConst,    //
     Variants                                   //
     {$ELSE}                                    //
//////////////////////////////////////////////////
     DsgnIntf
//////////////////////////////////////////////////
     {$ENDIF}                                   //
//////////////////////////////////////////////////
  {$IFNDEF _D2}{$IFNDEF _D3},ImgList{$ENDIF}{$ENDIF};

type
  TfmToolbarEditor = class(TForm)
  private
    lvButtons: TListView;
    btnAdd: TButton;
    btnDelete: TButton;
    btnUp: TButton;
    btnDown: TButton;
    btnPicture: TButton;
    chkSeparator: TCheckBox;
    btnOK: TButton;
    {$IFDEF VER90}
    opDialog1: TOpenDialog;
    {$ELSE}
    opDialog1: TOpenPictureDialog;
    {$ENDIF}
    ilImages: TImageList;
    chkStayOnTop: TCheckBox;
    chkDropDown: TCheckBox;
    {procedure lvButtonsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);}
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure chkSeparatorClick(Sender: TObject);
    procedure lvButtonsEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure btnPictureClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    //procedure btnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure chkStayOnTopClick(Sender: TObject);
    procedure chkDropDownClick(Sender: TObject);
  private
    { Private declarations }
    CanCancel: Boolean;
    FToolbar: TComponent;
    procedure AdjustButtons;
    procedure SetToolbar(const Value: TComponent);
    procedure lvButtonsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    //function SeparatorsCount: Integer;
    procedure AssembleBitmap;
    procedure AssembleButtons;
    procedure SelectTB;
  public
    { Public declarations }
    Bitmap: TBitmap;
    ButtonCaptions: String;
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    property ToolbarControl: TComponent read FToolbar write SetToolbar;
    procedure MakeActive( SelectAny: Boolean );
    procedure RefreshItems;
    procedure ApplyImages;
  end;

var
  fmToolbarEditor: TfmToolbarEditor;

implementation

uses
  mirror, mckCtrls, mckObjs;

procedure TfmToolbarEditor.AdjustButtons;
var LI: TListItem;
    Bt: TKOLToolbarButton;
begin
  LI := lvButtons.Selected;
  if LI = nil then
  begin
    btnAdd.Enabled := lvButtons.Items.Count = 0;
    btnDelete.Enabled := FALSE;
    btnUp.Enabled := FALSE;
    btnDown.Enabled := FALSE;
    btnPicture.Enabled := FALSE;
    if chkSeparator.Checked then
      chkSeparator.Checked := FALSE;
    chkSeparator.Enabled := FALSE;
    btnOK.Enabled := TRUE;
    chkDropDown.Enabled := FALSE;
    //btnCancel.Enabled := CanCancel;
  end
    else
  begin
    btnAdd.Enabled := TRUE;
    btnDelete.Enabled := TRUE;
    btnUp.Enabled := LI.Index > 0;
    btnDown.Enabled := LI.Index < lvButtons.Items.Count - 1;
    btnPicture.Enabled := TRUE;
    chkSeparator.Enabled := TRUE;
    if chkSeparator.Checked <> (LI.Caption = '-') then
      chkSeparator.Checked := LI.Caption = '-';
    btnOK.Enabled := TRUE;
    chkDropDown.Enabled := TRUE;
    Bt := LI.Data;
    chkDropDown.Checked := Bt.DropDown;
    //btnCancel.Enabled := CanCancel;
  end;
end;

constructor TfmToolbarEditor.Create(AOwner: TComponent);
begin
  CreateNew(AOwner);
  BorderIcons := [biSystemMenu];
  BorderStyle := bsDialog;
  Caption := 'fmToolbarEditor';
  ClientHeight := 281;
  ClientWidth := 277;
  Color := clBtnFace;
  //Font.Charset := DEFAULT_CHARSET;
  Font.Color := clWindowText;
  Font.Height := -11;
  Font.Name := 'MS Sans Serif';
  Font.Style := [];
  KeyPreview := True;
  //OldCreateOrder = False
  Scaled := False;
  OnShow := FormShow;
  OnClose := FormClose;
  OnDestroy := FormDestroy;
  OnKeyDown := FormKeyDown;
  //PixelsPerInch = 96
  //TextHeight = 13
  ilImages := TImageList.Create( Self );
  lvButtons := TListView.Create( Self );
  lvButtons.Parent := Self;
    lvButtons.Left := 6;
    lvButtons.Top := 8;
    lvButtons.Width := 163;
    lvButtons.Height := 265;
    lvButtons.MultiSelect := FALSE;
    lvButtons.Columns.Add;
    lvButtons.Columns[ 0 ].Caption := 'Buttons';
    lvButtons.Columns[ 0 ].Width := -2;
    lvButtons.HideSelection := False;
    {$IFNDEF VER90}
    lvButtons.RowSelect := TRUE;
    {$ENDIF}
    lvButtons.ShowColumnHeaders := False;
    lvButtons.SmallImages := ilImages;
    //lvButtons.TabOrder := 0;
    lvButtons.ViewStyle := vsReport;
    lvButtons.OnEdited := lvButtonsEdited;
    //lvButtons.OnSelectItem := lvButtonsSelectItem;
    lvButtons.OnChange := lvButtonsChange;
  btnOK := TButton.Create( Self );
  btnOK.Parent := Self;
    btnOK.Left := 180;
    btnOK.Top := 9;
    btnOK.Width := 89;
    btnOK.Height := 25;
    btnOK.Caption := 'Apply';
    //btnOK.TabOrder := 1;
    btnOK.OnClick := btnOKClick;
  chkStayOnTop := TCheckBox.Create( Self );
  chkStayOnTop.Parent := Self;
    chkStayOnTop.Left := 180;
    chkStayOnTop.Top := 40;
    chkStayOnTop.Width := 89;
    chkStayOnTop.Height := 17;
    chkStayOnTop.Caption := 'Stay on top';
    //chkStayOnTop.TabOrder := 2;
    chkStayOnTop.OnClick := chkStayOnTopClick;
  btnAdd := TButton.Create( Self );
  btnAdd.Parent := Self;
    btnAdd.Left := 180;
    btnAdd.Top := 80;
    btnAdd.Width := 89;
    btnAdd.Height := 25;
    btnAdd.Caption := 'Add';
    //btnAdd.TabOrder := 3;
    btnAdd.OnClick := btnAddClick;
  btnDelete := TButton.Create( Self );
  btnDelete.Parent := Self;
    btnDelete.Left := 180;
    btnDelete.Top := 112;
    btnDelete.Width := 89;
    btnDelete.Height := 25;
    btnDelete.Caption := 'Delete';
    //btnDelete.TabOrder := 4;
    btnDelete.OnClick := btnDeleteClick;
  btnUp := TButton.Create( Self );
  btnUp.Parent := Self;
    btnUp.Left := 180;
    btnUp.Top := 152;
    btnUp.Width := 41;
    btnUp.Height := 25;
    btnUp.Caption := 'Up';
    //btnUp.TabOrder := 5;
    btnUp.OnClick := btnUpClick;
  btnDown := TButton.Create( Self );
  btnDown.Parent := Self;
    btnDown.Left := 228;
    btnDown.Top := 152;
    btnDown.Width := 41;
    btnDown.Height := 25;
    btnDown.Caption := 'Down';
    //btnDown.TabOrder := 6;
    btnDown.OnClick := btnDownClick;
  btnPicture := TButton.Create( Self );
  btnPicture.Parent := Self;
    btnPicture.Left := 180;
    btnPicture.Top := 192;
    btnPicture.Width := 89;
    btnPicture.Height := 25;
    btnPicture.Caption := 'Picture';
    //btnPicture.TabOrder := 7;
    btnPicture.OnClick := btnPictureClick;
    btnPicture.Visible := FALSE;
  chkSeparator := TCheckBox.Create( Self );
  chkSeparator.Parent := Self;
    chkSeparator.Left := 180;
    chkSeparator.Top := 227;
    chkSeparator.Width := 89;
    chkSeparator.Height := 17;
    chkSeparator.Caption := 'Separator';
    //chkSeparator.TabOrder := 8;
    chkSeparator.OnClick := chkSeparatorClick;
  chkDropDown := TCheckBox.Create( Self );
  chkDropDown.Parent := Self;
    chkDropDown.Left := 180;
    chkDropDown.Top := 255;
    chkDropDown.Width := 89;
    chkDropDown.Height := 17;
    chkDropDown.Caption := 'DropDown';
    //chkDropDown.TabOrder := 9;
    chkDropDown.OnClick := chkDropDownClick;
  {$IFDEF VER90}
  opDialog1 := TOpenDialog.Create( Self );
  {$ELSE}
  opDialog1 := TOpenPictureDialog.Create( Self );
  {$ENDIF}
    opDialog1.DefaultExt := 'bmp';
    {$IFDEF VER90}
    opDialog1.Filter := 'All available image files|*.bmp;*.ico;*.wmf';
    {$ENDIF}
    opDialog1.Options := [ofHideReadOnly, ofPathMustExist, ofFileMustExist
    {$IFNDEF VER90}{$IFNDEF VER100}, ofEnableSizing{$ENDIF}{$ENDIF} ];
    opDialog1.Title := 'Open picture';

  CanCancel := TRUE;
  Bitmap := TBitmap.Create;
end;

procedure TfmToolbarEditor.lvButtonsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  MakeActive( FALSE );
  AdjustButtons;
end;

procedure TfmToolbarEditor.btnAddClick(Sender: TObject);
var LI: TListItem;
    Bt: TKOLToolbarButton;
    Toolbar: TKOLToolbar;
    I: Integer;
    S: String;
begin
  TRY
    LI := nil;
    Bt := nil;
    Toolbar := nil;
    TRY
      if ToolbarControl = nil then Exit;
      if not( ToolbarControl is TKOLToolbar ) then Exit;
      Toolbar := ToolbarControl as TKOLToolbar;
      LI := lvButtons.Selected;
      if LI = nil then
      begin
        Bt := TKOLToolbarButton.Create( Toolbar );
        LI := lvButtons.Items.Add;
        LI.Data := Bt;
      end
        else
      begin
        if LI.Index >= lvButtons.Items.Count then
          Bt := TKOLToolbarButton.Create( Toolbar )
        else
        begin
          Bt := TKOLToolbarButton.Create( Toolbar );
          Toolbar.Items.Move( lvButtons.Items.Count, LI.Index + 1 );
        end;
        LI := lvButtons.Items.Insert( LI.Index + 1 );
        LI.Data := Bt;
      end;
    EXCEPT on E: Exception do
      ShowMessage( 'Error(1.1): ' + E.Message );
    END;

    TRY
      if ToolbarControl <> nil then
      if ToolbarControl.Owner is TForm then
      for I := 1 to MaxInt do
      begin
        S := 'TB' + IntToStr( I );
        if (ToolbarControl.Owner as TForm).FindComponent( S ) = nil then
        if ToolbarControl.FindComponent( S ) = nil then
        begin
          Bt.Name := S;
          break;
        end;
      end;

      Bt.imgIndex := Toolbar.MaxImgIndex;

      LI.ImageIndex := -1;
      AssembleButtons;
      lvButtons.Selected := nil;
      lvButtons.Selected := LI;
      lvButtons.ItemFocused := LI;
      LI.MakeVisible( FALSE );
      LI.EditCaption;
    EXCEPT on E: Exception do
      ShowMessage( 'Error(1.2): ' + E.Message );
    END;
  EXCEPT on E: Exception do
    ShowMessage( 'error(1): ' + E.Message );
  END;
end;

procedure TfmToolbarEditor.btnDeleteClick(Sender: TObject);
var LI: TListItem;
    J: Integer;
    Bt: TKOLToolbarButton;
begin
  LI := lvButtons.Selected;
  if LI <> nil then
  begin
    J := LI.Index;
    Bt := LI.Data;
    Bt.Free;
    LI.Free;
    if J >= lvButtons.Items.Count then
      Dec( J );
    if J >= 0 then
    begin
      lvButtons.Selected := lvButtons.Items[ J ];
      lvButtons.ItemFocused := lvButtons.Selected;
    end;
    AssembleButtons;
  end;
  AdjustButtons;
  if lvButtons.Items.Count = 0 then
    SelectTB;
end;

procedure TfmToolbarEditor.btnUpClick(Sender: TObject);
var LI, LI1: TListItem;
    I: Integer;
    Toolbar: TKOLToolbar;
begin
  if ToolbarControl = nil then Exit;
  if not(ToolbarControl is TKOLToolbar) then Exit;
  Toolbar := ToolbarControl as TKOLToolbar;
  LI := lvButtons.Selected;
  if LI = nil then Exit;
  I := LI.Index - 1;
  LI1 := lvButtons.Items.Insert( I );
  LI1.Caption := LI.Caption;
  LI1.Data := LI.Data;
  Toolbar.Items.Move( I + 1, I );
  LI.Free;
  lvButtons.Selected := LI1;
  lvButtons.ItemFocused := LI1;
  AssembleButtons;
end;

procedure TfmToolbarEditor.btnDownClick(Sender: TObject);
var LI, LI1: TListItem;
    Toolbar: TKOLToolbar;
begin
  if ToolbarControl = nil then Exit;
  if not(ToolbarControl is TKOLToolbar) then Exit;
  Toolbar := ToolbarControl as TKOLToolbar;
  LI := lvButtons.Selected;
  if LI = nil then Exit;
  Toolbar.Items.Move( LI.Index, LI.Index + 1 );
  LI1 := lvButtons.Items.Insert( LI.Index + 2 );
  LI1.Caption := LI.Caption;
  LI1.Data := LI.Data;
  LI.Free;
  lvButtons.Selected := LI1;
  lvButtons.ItemFocused := LI1;
  AssembleButtons;
end;

procedure TfmToolbarEditor.chkSeparatorClick(Sender: TObject);
var LI: TListItem;
    Bmp: TBitmap;
    I: Integer;
    Bt: TKOLToolbarButton;
    Toolbar: TKOLToolbar;
begin
  LI := lvButtons.Selected;
  if LI = nil then Exit;
  Bt := LI.Data;
  if chkSeparator.Checked then
  begin
    if LI.Caption <> '-' then
    begin
      Bt.separator := TRUE;
      LI.Caption := '-';
      I := LI.ImageIndex;
      Bmp := TBitmap.Create;
      try

        Bmp.Width := Bitmap.Width - Bitmap.Height;
        Bmp.Height := Bitmap.Height;
        Bmp.Canvas.Brush.Color := Bitmap.Canvas.Pixels[ 0, Bmp.Height - 1 ];
        Bmp.Canvas.FillRect( Rect( 0, 0, Bmp.Width, Bmp.Height ) );
        Bmp.Canvas.CopyRect( Rect( 0, 0, I * Bmp.Height, Bmp.Height ),
                             Bitmap.Canvas,
                             Rect( 0, 0, I * Bmp.Height, Bmp.Height ) );
        Bmp.Canvas.CopyRect( Rect( I * Bmp.Height, 0, Bmp.Width, Bmp.Height ),
                             Bitmap.Canvas,
                             Rect( (I + 1) * Bmp.Height, 0, Bitmap.Width, Bmp.Height ) );
        Bitmap.Free;
        Bitmap := Bmp;
        Bmp := nil;

      finally
        Bmp.Free;
      end;
    end;
  end
    else
  begin
    if LI.Caption = '-' then
      LI.Caption := '';
    Bt.separator := FALSE;
    I := LI.ImageIndex;
    Bmp := TBitmap.Create;
    try

      Bmp.Width := Bitmap.Width + Bitmap.Height;
      Bmp.Height := Bitmap.Height;
      Bmp.Canvas.Brush.Color := Bitmap.Canvas.Pixels[ 0, Bmp.Height - 1 ];
      Bmp.Canvas.FillRect( Rect( 0, 0, Bmp.Width, Bmp.Height ) );
      Bmp.Canvas.CopyRect( Rect( 0, 0, I * Bmp.Height, Bmp.Height ),
                           Bitmap.Canvas,
                           Rect( 0, 0, I * Bmp.Height, Bmp.Height ) );
      Bmp.Canvas.CopyRect( Rect( (I + 1) * Bmp.Height, 0, Bmp.Width, Bmp.Height ),
                           Bitmap.Canvas,
                           Rect( I * Bmp.Height, 0, Bitmap.Width, Bmp.Height ) );
      Bitmap.Free;
      Bitmap := Bmp;
      Bmp := nil;

    finally
      Bmp.Free;
    end;
  end;
  if ToolbarControl = nil then Exit;
  Toolbar := ToolbarControl as TKOLToolbar;
  Toolbar.Items2buttons;
end;

procedure TfmToolbarEditor.lvButtonsEdited(Sender: TObject;
  Item: TListItem; var S: String);
var Bt: TKOLToolbarButton;
begin
  chkSeparator.Checked := S = '-';
  Bt := Item.Data;
  Bt.Caption := S;
end;

procedure TfmToolbarEditor.btnPictureClick(Sender: TObject);
begin

end;
(*var LI: TListItem;
    Pic: TPicture;
    Bmp, Bmp2: TBitmap;
    ImgIdx: Integer;
    Toolbar: TKOLToolbar;
begin
  LI := lvButtons.Selected;
  if LI = nil then Exit;
  ImgIdx := ButtonImgIdx( LI.Index );
  if opDialog1.Execute then
  begin
    Pic := TPicture.Create;
    Bmp := TBitmap.Create;
    Bmp2 := TBitmap.Create;
    try
      Pic.LoadFromFile( opDialog1.Filename );
      if not Pic.Graphic.Empty then
      begin
        if lvButtons.Items.Count = 1 then
        begin
          Bitmap.Width := 0;
          Bitmap.Height := 0;
        end;
        if (Bitmap.Height = 0) or (Bitmap.Width = 0) then
        begin
          Bitmap.Height := Pic.Graphic.Height;
        end;
        if Bitmap.Width < Bitmap.Height * (ImgIdx + 1) then
        begin
          Bmp2.Height := Bitmap.Height;
          Bmp2.Width := Bitmap.Height * (ImgIdx + 1);
          Bmp2.Canvas.Brush.Color := Bitmap.Canvas.Pixels[ 0, Bmp2.Height-1 ];
          Bmp2.Canvas.FillRect( Rect( 0, 0, Bmp2.Width, Bmp2.Height ) );
          Bmp2.Canvas.CopyRect( Rect( 0, 0, Bitmap.Width, Bitmap.Height ),
                                Bitmap.Canvas,
                                Rect( 0, 0, Bitmap.Width, Bitmap.Height ) );
          Bitmap.Free;
          Bitmap := Bmp2;
          Bmp2 := TBitmap.Create;
        end;
        Bmp2.Width := Bitmap.Height;
        Bmp2.Height := Bitmap.Height;
        Bmp2.Canvas.Brush.Color := Bitmap.Canvas.Pixels[ 0, Bitmap.Height - 1 ];
        Bmp2.Canvas.FillRect( Rect( 0, 0, Bmp2.Width, Bmp2.Height ) );

        Bmp.Width := Pic.Graphic.Width;
        Bmp.Height := Pic.Graphic.Height;
        Bmp.Canvas.Brush.Color := Bitmap.Canvas.Pixels[ 0, Bitmap.Height - 1 ];
        Bmp.Canvas.FillRect( Rect( 0, 0, Bmp.Width, Bmp.Height ) );

        Bmp.Canvas.Draw( 0, 0, Pic.Graphic );
        {$IFNDEF VER90}
        Bmp.TransparentColor := Bmp.Canvas.Pixels[ 0, Bmp.Height - 1 ];
        Bmp.Transparent := TRUE;
        {$ENDIF}
        Bmp2.Canvas.StretchDraw( Rect( 0, 0, Bmp2.Width, Bmp2.Height ), Bmp );
        Bitmap.Canvas.CopyRect( Rect( ImgIdx * Bitmap.Height, 0, (ImgIdx + 1) * Bitmap.Height, Bitmap.Height ),
                                Bmp2.Canvas,
                                Rect( 0, 0, Bmp2.Width, Bmp2.Height ) );
      end;
    finally
      Pic.Free;
      Bmp.Free;
      Bmp2.Free;
    end;
  end;
  ApplyImages;
  if ToolbarControl <> nil then
  if ToolbarControl is TKOLToolbar then
  begin
    Toolbar := ToolbarControl as TKOLToolbar;
    Toolbar.bitmap.Assign( Bitmap );
    Toolbar.bitmap2ItemPictures;
  end;
end;*)

destructor TfmToolbarEditor.Destroy;
begin
  Bitmap.Free;
  inherited;
end;

procedure TfmToolbarEditor.FormShow(Sender: TObject);
var I: Integer;
    LI: TListItem;
    Bt: TKOLToolbarButton;
    Toolbar: TKOLToolbar;
begin
  lvButtons.Items.BeginUpdate;
  TRY

    lvButtons.Items.Clear;
    if ToolbarControl <> nil then
    if ToolbarControl is TKOLToolbar then
    begin
      Toolbar := ToolbarControl as TKOLToolbar;
      for I := 0 to Toolbar.Items.Count-1 do
      begin
        LI := lvButtons.Items.Add;
        Bt := Toolbar.Items[ I ];
        LI.Data := Bt;
        LI.Caption := Bt.caption;
      end;
    end;
    ApplyImages;

  FINALLY
    lvButtons.Items.EndUpdate;
  END;
end;

procedure TfmToolbarEditor.ApplyImages;
var I, J: Integer;
    Bmp: TBitmap;
    W, H, H1: Integer;
    Bt: TKOLToolbarButton;
    TranColor: TColor;
begin
  ilImages.Clear;
  W := 0;
  H := 0;
  TranColor := clNone;
  for I := 0 to lvButtons.Items.Count-1 do
  begin
    Bt := lvButtons.Items[ I ].Data;
    if Bt = nil then continue;
    if Bt.HasPicture then
    begin
      if Bt.picture.Width > W then
        W := Bt.picture.Width;
      if Bt.picture.Height > H then
        H := Bt.picture.Height;
      if TranColor = clNone then
      begin
        Bmp := TBitmap.Create;
        TRY
          Bmp.Assign( Bt.picture.Graphic );
          TranColor := Bmp.Canvas.Pixels[ 0, Bmp.Height - 1 ];
        FINALLY
          Bmp.Free;
        END;
      end;
    end;
  end;
  if W * H > 0 then
  begin
    ilImages.Width := W;
    ilImages.Height := H;
    Bmp := TBitmap.Create;
    try
      Bmp.Width := W;
      Bmp.Height := H;
      for I := 0 to lvButtons.Items.Count - 1 do
      begin
        Bt := lvButtons.Items[ I ].Data;
        if TranColor <> clNone then
        begin
          Bmp.Canvas.Brush.Color := TranColor;
          Bmp.Canvas.FillRect( Rect( 0, 0, Bmp.Width, Bmp.Height ) );
        end;
        if (Bt <> nil) and Bt.HasPicture then
          Bmp.Canvas.Draw( 0, 0, Bt.picture.Graphic );
        if Bt.HasPicture and (Bt.picture.Height > 0) then
        begin
          H1 := Bt.picture.Height;
          J := ilImages.AddMasked( Bmp, Bmp.Canvas.Pixels[ 0, H1 - 1 ] );
          lvButtons.Items[ I ].ImageIndex := J;
        end
          else
          lvButtons.Items[ I ].ImageIndex := -1;
      end;
    finally
      Bmp.Free;
    end;
  end
    else
  begin
    ilImages.Width := 16;
    ilImages.Height := 16;
    for I := 0 to lvButtons.Items.Count - 1 do
      lvButtons.Items[ I ].ImageIndex := -1;
  end;
end;

procedure TfmToolbarEditor.btnOKClick(Sender: TObject);
var I: Integer;
    S: String;
    LI: TListItem;
    Tb: TKOLToolbar;
    Bt: TKOLToolbarButton;
begin
  S := '';
  for I := 0 to lvButtons.Items.Count - 1 do
  begin
    LI := lvButtons.Items[ I ];
    if S <> '' then
      S := S + #1;
    Bt := LI.Data;
    //if LI.Data <> nil then
    if Bt.checked then
      S := S + '^';
    S := S + LI.Caption;
  end;
  ButtonCaptions := S;
  if ToolbarControl <> nil then
  begin
    Tb := ToolbarControl as TKOLToolbar;
    Tb.Bitmap.Assign( Bitmap );
    if (Bitmap.Width > 0) and (Bitmap.Height > 0) then
    begin
      I := 22;
      if Bitmap.Height > I - 4 then
        I := Bitmap.Height + 4;
      Tb.Height := I;
    end;
    Tb.buttons := ButtonCaptions;
    Tb.Change;
  end;
  //Close;
end;

{procedure TfmToolbarEditor.btnCancelClick(Sender: TObject);
begin
  Close;
end;}

procedure TfmToolbarEditor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_INSERT: btnAdd.Click;
  VK_DELETE: if not lvButtons.IsEditing then btnDelete.Click;
  VK_RETURN: if (ActiveControl = lvButtons) and not lvButtons.IsEditing and
                (lvButtons.Selected <> nil) then
                lvButtons.Selected.EditCaption;
  VK_UP:     if (GetKeyState( VK_CONTROL ) < 0) then
                btnUp.Click
             else Exit;
  VK_DOWN:   if (GetKeyState( VK_CONTROL ) < 0) then
                btnDown.Click
             else Exit;
  else Exit;
  end;
  Key := 0;
end;

procedure TfmToolbarEditor.SetToolbar(const Value: TComponent);
var Tb: TKOLToolbar;
begin
  FToolbar := Value;
  Tb := Value as TKOLToolbar;
  Caption := Tb.Name + ' buttons';
  ButtonCaptions := Tb.buttons;
  Bitmap.Assign( Tb.Bitmap );
end;

procedure TfmToolbarEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Rpt( 'Closing KOLToolbar form', WHITE );
  SelectTB;
  modalResult := mrOK;
end;

procedure TfmToolbarEditor.MakeActive( SelectAny: Boolean );
var F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
    Bt: TKOLToolbarButton;
begin
  if lvButtons.Items.Count > 0 then
  if lvButtons.Selected = nil then
  if SelectAny then
    lvButtons.Selected := lvButtons.Items[ 0 ];
  if lvButtons.Selected <> nil then
  begin
    Bt := lvButtons.Selected.Data;
    F := (ToolbarControl as TKOLToolbar).Owner as TForm;
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
        FD.SelectComponent( Bt );
      end;
    end;
  end;
  AdjustButtons;
end;

procedure TfmToolbarEditor.FormDestroy(Sender: TObject);
var Tb: TKOLToolbar;
begin
  if ToolbarControl <> nil then
  begin
    Tb := ToolbarControl as TKOLToolbar;
    Tb.ActiveDesign := nil;
  end;
  //Bitmap.Free;
end;

procedure TfmToolbarEditor.chkStayOnTopClick(Sender: TObject);
begin
  if chkStayOnTop.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure TfmToolbarEditor.chkDropDownClick(Sender: TObject);
var LI: TListItem;
    Bt: TKOLToolbarButton;
begin
  LI := lvButtons.Selected;
  if LI = nil then Exit;
  Bt := LI.Data;
  Bt.DropDown := chkDropDown.Checked;
end;


{function TfmToolbarEditor.SeparatorsCount: Integer;
var I: Integer;
begin
  Result := 0;
  for I := 0 to lvButtons.Items.Count-1 do
  begin
    if lvButtons.Items[ I ].Caption = '-' then
      Inc( Result );
  end;
end;}

{function TfmToolbarEditor.ButtonImgIdx(BtnIdx: Integer): Integer;
var I: Integer;
begin
  Result := 0;
  for I := 0 to BtnIdx - 1 do
    if lvButtons.Items[ I ].Caption <> '-' then
      Inc( Result );
end;}

procedure TfmToolbarEditor.RefreshItems;
var I: Integer;
    LI: TListItem;
    Bt: TKOLToolbarButton;
begin
  for I := 0 to lvButtons.Items.Count-1 do
  begin
    LI := lvButtons.Items[ I ];
    Bt := LI.Data;
    if Bt <> nil then
    begin
      if LI.Caption <> Bt.Caption then
      begin
        lvButtons.OnChange := nil;
        LI.Caption := Bt.caption;
        lvButtons.OnChange := lvButtonsChange;
      end;
      if lvButtons.Selected = LI then
      begin
        {ShowMessage( 'Bt.caption=' + Bt.caption +
                     ' Bt.checked=' + IntToStr( Integer( Bt.checked ) ) +
                     ' Bt.dropdown=' + IntToStr( Integer( Bt.dropdown ) ) +
                     ' chkSeparator.Checked=' + IntToStr( Integer( chkSeparator.Checked ) ) +
                     ' chkDropDown.Checked=' + IntToStr( Integer( chkDropDown.Checked ) ) );}
        if chkSeparator.Checked <> Bt.separator then
        begin
          chkSeparator.OnClick := nil;
          chkSeparator.Checked := Bt.separator;
          chkSeparator.OnClick := chkSeparatorClick;
        end;
        if chkDropDown.Checked <> Bt.dropdown then
        begin
          chkDropDown.OnClick := nil;
          chkDropDown.Checked := Bt.dropdown;
          chkDropDown.OnClick := chkDropDownClick;
        end;
      end;
    end;
  end;
  //ApplyImages;
end;

procedure TfmToolbarEditor.AssembleBitmap;
var Toolbar: TKOLToolbar;
begin
  if ToolbarControl = nil then Exit;
  if not( ToolbarControl is TKOLToolbar ) then Exit;
  Toolbar := ToolbarControl as TKOLToolbar;
  Toolbar.AssembleBitmap;
end;

procedure TfmToolbarEditor.AssembleButtons;
var Toolbar: TKOLToolbar;
begin
  if ToolbarControl = nil then Exit;
  if not( ToolbarControl is TKOLToolbar ) then Exit;
  Toolbar := ToolbarControl as TKOLToolbar;
  Toolbar.Items2buttons;
  AssembleBitmap;
end;

procedure TfmToolbarEditor.SelectTB;
var F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
begin
  if ToolbarControl <> nil then
  begin
    F := (ToolbarControl as TKOLToolbar).Owner as TForm;
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
              FD.SelectComponent( ToolbarControl );
            except
              Rpt( 'EXCEPTION *** Could not clear selection!', WHITE )
            end;
          end;

        end;
    end;
  end;
end;

end.