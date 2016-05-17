unit KOLDirDlgEx;

interface

uses Windows, Messages, KOL {$IFDEF USE_GRUSH}, ToGrush, KOLGRushControls {$ENDIF};

{$I KOLDEF.INC}
{$I DELPHIDEF.INC}

{$IFDEF EXTERNAL_DEFINES}
        {$INCLUDE EXTERNAL_DEFINES.INC}
{$ENDIF EXTERNAL_DEFINES}

//{$DEFINE NO_DEFAULT_FASTSCAN}
           { if you add such option, all icons for removable and remote drives
             are obtained by default accessing these drives, slow. }
//{$DEFINE DIRDLGEX_NO_DBLCLK_ON_NODE_OK}
           { if this option is on, double clicks in the directories tree
             is used only to expand/collapse children nodes. By default,
             double click on a node w/o children selects it and
             finishes the dialog as in case when OK is clicked. }

//{$DEFINE DIRDLGEX_LINKSPANEL}
           { if this option is on, links panel is available (on the left side).
             Also USE_MENU_CURCTL symbol must be added! }
//{$DEFINE DIRDLGEX_STDFONT}
           { add this option to use standard font size in a links panel
             (otherwise Arial, 14 is used) }
{$DEFINE DIRDLGEX_BIGGERPANEL}
           { a bit bigger links panel with bigger buttons on it }

{ ----------------------------------------------------------------------

                TOpenDirDialogEx

----------------------------------------------------------------------- }
{ TOpenDirDialogEx - альтернатива стандартному диалогу выбора папки.
  (c) by Vladimir Kladov, 2005, 14 Dec.
  Необходимость: стандартный диалог работает медленно, для каждой операции
                 выбора папки пользователем открывается заново, строя заново
                 дерево папок, при этом глючит: регулярно возникает ситуация,
                 когда родительский узел для первоначальной папки может показать
                 только текущую вложенную папку, хотя там есть еще папки.
                 Не говоря уже о мелких глупостях, вроде той, что текущий узел
                 в момент открытия может просто оказаться вне поля зрения, или
                 той, что в стандартном диалоге активным оказывается не дерево
                 выбора папок, а кнопка ОК (или кто-то думает, что пользователь
                 открыл диалог для того, чтобы нажать ОК, не выбирая папку?).
  Особенности TOpenDirDialogEx: работает быстро. При повторном выполнении
  Execute пересканируется только та часть дерева, которая выше текущей папки
  (т.е. повторное открытие выполняется практически мгновенно). Первоначально
  открывается только часть дерева папок, которая необходима, чтобы полность
  открыть все папки на пути от корня диска до текущей папки. Прочие папки
  открываются и пересканируются при их открытии (распахивании). Повторное
  распахивание папки пересканирует ее (как альтернатива автоматическому
  обновлению, которое не реализовано - хотя и особой необходимости в автоматике
  на практике нет, и кроме дополнительной нагрузки на систему толку от такого
  автомата тоже не видно).
           Особенно быстро диалог открытия работает в новых версиях OS Windows,
           т.к. использует в этом случае API-функции версии Unicode. 

  Дополнительные вкусности:
  Есть возможность поменять надписи на кнопках, заголовок диалога.
  Есть возможность отфильтровать директории по атрибутам (FilterAttrs), например,
  если присвоить FILE_ATTRIBUTE_HIDDEN, то скрытые папки в дереве показаны не будут.
}
const
  WM_USER_RESCANTREE = WM_USER;

type
  TFindFirstFileEx = function(lpFileName: PKOLChar; fInfoLevelId: TFindexInfoLevels;
    lpFindFileData: Pointer; fSearchOp: TFindexSearchOps; lpSearchFilter: Pointer;
    dwAdditionalFlags: DWORD): THandle; stdcall;
  TFindFirstFileExW = function(lpFileName: PWideChar; fInfoLevelId: TFindexInfoLevels;
    lpFindFileData: Pointer; fSearchOp: TFindexSearchOps; lpSearchFilter: Pointer;
    dwAdditionalFlags: DWORD): THandle; stdcall;
  TFindNextFileW = function( hFindFile: THandle; lpFindFileData: Pointer ):
    BOOL; stdcall;

  POpenDirDialogEx = ^TOpenDirDialogEx;
  TOpenDirDialogEx = object( TObj )
  protected
    FFastScan: Boolean;
    DlgClient: PControl;
    DirTree: PControl;
    BtnPanel: PControl;
    RescanningNode, RescanningTree: Boolean;
    FPath, FRecycledName: KOLString;
    FRemoteIconSysIdx: Integer;
    FFindFirstFileEx: TFindFirstFileEx;
    FFindFirstFileExW: TFindFirstFileExW;
    FFindNextFileW: TFindNextFileW;
    k32: THandle;
    DialogForm, MsgPanel: PControl;
    function GetFindFirstFileEx: TFindFirstFileEx;
    function GetFindFirstFileExW: TFindFirstFileExW;
    procedure SetPath(const Value: KOLString);
    function GetDialogForm: PControl;
    procedure DoOK( Sender: PObj );
    procedure DoCancel( Sender: PObj );
    procedure DoNotClose( Sender: PObj; var Accept: Boolean );
    procedure DoShow( Sender: PObj );
    function DoMsg( var Msg: TMsg; var Rslt: Integer ): Boolean;
    function DoExpanding( Sender: PControl; Item: THandle; Expand: Boolean )
                 : Boolean;
    function DoFilterAttrs( Attrs: DWORD; const APath: KOLString ): Boolean;
    procedure Rescantree;
    procedure RescanNode( node: Integer );
    procedure RescanDisks;
    function RemoteIconSysIdx: Integer;
    procedure CheckNodeHasChildren( node: Integer );
    procedure CreateDialogForm;
    property _FindFirstFileEx: TFindFirstFileEx read GetFindFirstFileEx;
    function _FindFirstFileExW: Boolean;
    procedure SelChanged( Sender: PObj );
    procedure DeleteNode( node: Integer );
    procedure DestroyingForm( Sender: PObj );
  public
    OKCaption, CancelCaption: KOLString;
    FilterAttrs: DWORD;
    FilterRecycled: Boolean;
    Title: String;
    property Form: PControl read GetDialogForm;
    {* DialogForm object. Though it is possible to do anything since it is
       in public section, do this only if you understand possible consequences.
       E.g., use it to change DialogForm bounding rectangle on screen or to
       add your own controls, event handlers and so on. }
    destructor Destroy; virtual;
    function Execute: Boolean;
    property InitialPath: KOLString read FPath write SetPath;
    property Path: KOLString read FPath write SetPath;
    property FastScan: Boolean read FFastScan write FFastScan;
    procedure DoubleClick( Sender: PControl; var M: TMouseEventData );
  {$IFDEF DIRDLGEX_LINKSPANEL}
  protected
    LinksPanel, LinksBox, LinksTape: PControl;
    LinksUp, LinksDn, LinksAdd: PControl;
    LinksList: PStrListEx;
    LinksImgList: PImageList;
    LinksRollTimer: PTimer;
    LinksPopupMenu: PMenu;
    procedure CreateLinksPanel;
    function GetLinksPanelOn: Boolean;
    procedure SetLinksPanelOn( const Value: Boolean );
    function GetLinksCount: Integer;
    function GetLinks(idx: Integer): KOLString;
    procedure SetLinks(idx: Integer; const Value: KOLString);
    procedure SetupLinksTapeHeight;
    procedure SetUpTaborders;
    procedure LinksUpClick( Sender: PControl; var Mouse: TMouseEventData );
    procedure LinksDnClick( Sender: PControl; var Mouse: TMouseEventData );
    procedure LinksUpDnStop( Sender: PControl; var Mouse: TMouseEventData );
    procedure LinksAddClick( Sender: PObj );
    procedure LinkClick( Sender: PObj );
    procedure LinksRollTimerTimer( Sender: PObj );
    procedure LinksBtnDnEvt( Sender: PControl; var Mouse: TMouseEventData );
    //procedure LinksPanelShowEvent( Sender: PObj );
    procedure RemoveLinkClick( Sender: PMenu; Item: Integer );
  public
    property LinksPanelOn: Boolean read GetLinksPanelOn write SetLinksPanelOn;
    property LinksCount: Integer read GetLinksCount;
    property Links[ idx: Integer ]: KOLString read GetLinks write SetLinks;
    procedure AddLinks( SL: PStrList );
    function CollectLinks: PStrList;
    function LinkPresent( const s: KOLString ): Boolean;
    procedure RemoveLink( const s: KOLString );
    procedure ClearLinks;
  {$ENDIF DIRDLGEX_LINKSPANEL}
    function GetBetterPixelFormat: TPixelFormat;
  end;

function NewOpenDirDialogEx: POpenDirDialogEx;

{$IFDEF KOL_MCK}
{$IFNDEF DIRDLGEX_OPTIONAL} { add this symbol if you want use
         both types of the open directory dialog in your application
         (and in such case, call a constructor of the TOpenDirDialogEx
         object manually). }
type TKOLOpenDirDialog = POpenDirDialogEx;
{$ENDIF}
{$ENDIF}

implementation

function NewOpenDirDialogEx: POpenDirDialogEx;
begin
  new( Result, Create );
  {$IFNDEF NO_DEFAULT_FASTSCAN}
  Result.FastScan := TRUE;
  {$ENDIF}
end;

procedure NewPanelWithSingleButtonToolbar( AParent: PControl; W, H: Integer;
  A: TControlAlign; Bmp: PBitmap; const C, T: KOLString; var Pn, Bar: PControl;
  const ClickEvent: TOnEvent; DownEvent, ReleaseEvent, BarMouseDnEvent: TOnMouse;
  P: PMenu );
var i: Integer;
    Buffer: PKOLChar;
    Wbmp, Hbmp: Integer;
begin
  Pn := NewPanel( AParent, esNone ).SetSize( 0, H ).SetAlign( A );
  Pn.Border := 0;
  Wbmp := Bmp.Width;
  Hbmp := Bmp.Height;
  Bar := NewToolbar( Pn, caClient, [
      tboNoDivider, tboTextBottom {, tboFlat} ],
    Bmp.ReleaseHandle,
    [ PKOLChar( {$IFDEF TOOLBAR_DOT_NOAUTOSIZE_BUTTON} '.' + {$ENDIF} C ) ], [ 0 ] );
  Buffer := AllocMem( Length( T ) + 1 );
  if T <> '' then
    {$IFDEF UNICODE_CTRLS} WStrCopy
    {$ELSE}                StrCopy
    {$ENDIF} ( Buffer, PKOLChar( T ) );
  {$IFDEF USE_GRUSH}
  i := 0;
  {$IFDEF TOGRUSH_OPTIONAL}
  if NoGrush then
  begin
    i := Bar.TBIndex2Item(0);
    Bar.Perform( TB_SETBITMAPSIZE, 0, MakeLong( Wbmp, Hbmp ) );
  end;
  if not NoGrush then
  {$ENDIF}
  begin
    PGRushControl( Bar.Children[0] ).All_GlyphVAlign := vaTop;
    if C = '' then
    begin
      PGRushControl( Bar.Children[0] ).All_GlyphVAlign := vaCenter;
      PGRushControl( Bar.Children[0] ).All_ContentOffsets := MakeRect( -4, -4, 4, 4 );
    end;
    PGRushControl( Bar.Children[0] ).All_GlyphHAlign := haCenter;
    PGRushControl( Bar.Children[0] ).All_GlyphWidth := Bmp.Width;
    PGRushControl( Bar.Children[0] ).All_Spacing := 2;
    PGRushControl( Bar.Children[0] ).Width := W;
    if not Assigned( DownEvent ) then
      PGRushControl( Bar.Children[0] ).OnClick := ClickEvent
    else
    begin
      PGRushControl( Bar.Children[0] ).OnMouseDown := DownEvent;
      PGRushControl( Bar.Children[0] ).OnMouseUp := ReleaseEvent;
    end;
    PGRushControl( Bar.Children[0] ).CustomData := Buffer;
    if P <> nil then
      Pn.SetAutoPopupMenu( P );
  end
  {$IFDEF TOGRUSH_OPTIONAL}
    else
  begin
    i := Bar.TBIndex2Item(0);
    Bar.TBButtonWidth[ i ] := W;
    Bar.Perform( TB_SETBITMAPSIZE, 0, MakeLong( Wbmp, Hbmp ) );
    if not Assigned( ReleaseEvent ) then
      Bar.OnClick := ClickEvent
    else
    begin
      Bar.OnMouseDown := DownEvent;
      Bar.OnMouseUp := ReleaseEvent;
    end;
    Bar.CustomData := Buffer;
    if P <> nil then
      Bar.OnMouseDown := BarMouseDnEvent;
  end
  {$ENDIF TOGRUSH_OPTIONAL}
  ;
  {$ELSE}
  i := Bar.TBIndex2Item(0);
  Bar.TBButtonWidth[ i ] := W;
  Bar.Perform( TB_SETBITMAPSIZE, 0, MakeLong( Wbmp, Hbmp ) );
  if not Assigned( ReleaseEvent ) then
    Bar.OnClick := ClickEvent
  else
  begin
    Bar.OnMouseDown := DownEvent;
    Bar.OnMouseUp := ReleaseEvent;
  end;
  Bar.CustomData := Buffer;
  {$ENDIF USE_GRUSH}
  ToolbarSetTooltips( Bar, i, [ PKOLChar( T ) ] );
  Bmp.Free;
end;

{ TOpenDirDialogEx }

{$IFDEF DIRDLGEX_LINKSPANEL}
procedure TOpenDirDialogEx.AddLinks(SL: PStrList);
var i: Integer;
begin
  for i := 0 to SL.Count-1 do
      if  not LinkPresent( SL.Items[ i ] ) then
          Links[ LinksCount ] := SL.Items[ i ];
end;

{$ENDIF DIRDLGEX_LINKSPANEL}

procedure TOpenDirDialogEx.CheckNodeHasChildren(node: Integer);
var HasSubDirs: Boolean;
    txt: KOLString;
    F: THandle;
    Find32: TWin32FindData;
    {$IFnDEF DONTTRY_FINDFILEEXW}
    Find32W: TWin32FindDataW;
    {$ENDIF}
    ii, n: Integer;
begin
  HasSubDirs := FALSE;
  txt := DirTree.TVItemText[ node ];
  if (Length( txt ) = 2) then
    if (txt[ 2 ] = ':') then
    begin
      ii := GetDriveType( PKOLChar( txt + '\' ) );
      if IntIn( ii, [ DRIVE_REMOVABLE, DRIVE_REMOTE, DRIVE_CDROM ] ) then
        HasSubDirs := TRUE;
    end;
  if not HasSubDirs then
  begin
    {$IFnDEF DONTTRY_FINDFILEEXW}
    if  (WinVer >= wvNT) and _FindFirstFileExW then
    begin
        F := FFindFirstFileExW( PWideChar(
             WideString( DirTree.TVItemPath( node, '\' ) + '\*.*' ) ),
             FindExInfoStandard, @ Find32W, FindExSearchLimitToDirectories, nil, 0 );
        if  F <> INVALID_HANDLE_VALUE then
        begin
            while TRUE do
            begin
                if Find32W.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0 then
                if (Find32W.cFileName <> WideString( '.' )) and (Find32W.cFileName <> WideString('..')) then
                if DoFilterAttrs( Find32W.dwFileAttributes, Find32W.cAlternateFileName ) then
                begin
                  HasSubDirs := TRUE;
                  break;
                end;
                if not FindNextFileW( F, Find32W ) then break;
            end;
            if not FindClose( F ) then
            {begin
              asm
                nop
              end;
            end};
        end;
    end
      else
    {$ENDIF}
    begin
        F := FindFirstFile( PKOLChar( DirTree.TVItemPath( node, '\' ) + '\*.*' ), Find32 );
        if F <> INVALID_HANDLE_VALUE then
        begin
            while TRUE do
            begin
                if  Find32.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0 then
                if  (Find32.cFileName <> String( '.' )) and (Find32.cFileName <> '..') then
                begin
                    HasSubDirs := TRUE;
                    break;
                end;
                if not FindNextFile( F, Find32 ) then break;
            end;
            FindClose( F );
        end;
    end;
  end;
  if not HasSubDirs then
  begin
    DirTree.TVExpand( node, TVE_COLLAPSE );
    n := DirTree.TVItemChild[ node ];
    while n <> 0 do
    begin
      ii := n;
      n := DirTree.TVItemNext[ n ];
      //DirTree.TVDelete( ii );
      DeleteNode( ii );
    end;
  end;
  if DirTree.TVItemParent[ node ] = 0 then HasSubDirs := TRUE;
  DirTree.TVItemHasChildren[ node ] := HasSubDirs;
end;

{$IFDEF DIRDLGEX_LINKSPANEL}
procedure TOpenDirDialogEx.ClearLinks;
var i: Integer;
begin
  if LinksList = nil then Exit;
  LinksList.Clear;
  for i := LinksTape.ChildCount-1 downto 0 do
      LinksTape.Children[ i ].Free;
  LinksTape.Height := 8;
  LinksTape.Top := 0;
end;

function TOpenDirDialogEx.CollectLinks: PStrList;
var i: Integer;
begin
  Result := NewStrList;
  for i := 0 to LinksCount-1 do
    Result.Add( Links[ i ] );
end;
{$ENDIF DIRDLGEX_LINKSPANEL}

procedure TOpenDirDialogEx.CreateDialogForm;
var Sysimages: PImageList;
    BtOk, BtCancel: PControl;
    DTSubPanel: PControl;
    s: String;
begin
   if not Assigned( DialogForm ) then
   begin
     OleInit;
     DialogForm := NewForm( Applet, '' ).SetSize( 324, 330 ).CenterOnParent;
     DialogForm.OnDestroy := DestroyingForm;
     DialogForm.Border := 6;
     DialogForm.OnClose := DoNotClose;
     DialogForm.Tabulate;
     DialogForm.MinWidth := 324;
     DialogForm.MinHeight := 330;
     DialogForm.ExStyle := DialogForm.ExStyle or
       WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
     DialogForm.Style := DialogForm.Style and
       not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
     Sysimages := NewImageList( DialogForm );
     Sysimages.LoadSystemIcons( TRUE );
     //DlgClient := NewPanel( DialogForm, esNone ).SetAlign(caClient);
     {$IFDEF USE_GRUSH}
     {$IFDEF TOGRUSH_OPTIONAL}
     if not NoGrush then
     {$ENDIF TOGRUSH_OPTIONAL}
     begin
       DialogForm.Color := clGRushLight;
       DlgClient := NewPanel( DialogForm, esNone ).SetAlign(caClient);
       //DlgClient.Border := 2;
     end
     {$IFDEF TOGRUSH_OPTIONAL}
       else DlgClient := DialogForm;
     {$ENDIF TOGRUSH_OPTIONAL}
     ;
     {$ELSE}
     DlgClient := DialogForm;
     {$ENDIF}

     {$IFDEF USE_GRUSH}
     {$IFDEF TOGRUSH_OPTIONAL}
     if not NoGrush then
     {$ENDIF TOGRUSH_OPTIONAL}
     begin
       DTSubPanel := KOL.NewPanel( DlgClient, esNone );
       DTSubPanel.Color := clWindow;
       DTSubPanel.Border := 2;
       BtnPanel := NewPanel( DlgClient, esTransparent )
         .SetSize( 0, 26 ).SetAlign(caBottom );
       //BtnPanel.Color := clGRushMedium;
       BtnPanel.Border := 2;
       DTSubPanel.SetAlign( caClient );
       DirTree := NewTreeView( DTSubPanel, [ tvoLinesRoot ], Sysimages, nil );
       DirTree.Color := clWindow;
       DirTree.OnTVExpanding := DoExpanding;
       DirTree.SetAlign( caClient );
       MsgPanel := DTSubPanel;
     end
     {$IFDEF TOGRUSH_OPTIONAL}
       else
     begin
       DTSubPanel := DlgClient;
       DirTree := NewTreeView( DTSubPanel, [ tvoLinesRoot ], Sysimages, nil );
       DirTree.Color := clWindow;
       DirTree.OnTVExpanding := DoExpanding;
       BtnPanel := NewPanel( DlgClient, esTransparent )
         .SetSize( 0, 26 ).SetAlign(caBottom );
       BtnPanel.Border := 2;
       DirTree.SetAlign( caClient );
       MsgPanel := DlgClient;
     end
     {$ENDIF TOGRUSH_OPTIONAL}
     ;
     {$ELSE}
     DTSubPanel := DlgClient;
     DirTree := NewTreeView( DTSubPanel, [ tvoLinesRoot ], Sysimages, nil );
     DirTree.Color := clWindow;
     DirTree.OnTVExpanding := DoExpanding;
     BtnPanel := NewPanel( DlgClient, esTransparent )
       .SetSize( 0, 26 ).SetAlign(caBottom );
     BtnPanel.Border := 2;
     DirTree.SetAlign( caClient );
     MsgPanel := DlgClient;
     {$ENDIF}
     {$IFNDEF DIRDLGEX_NO_DBLCLK_ON_NODE_OK}
     DirTree.OnMouseDblClk := DoubleClick;
     {$ENDIF}
     MsgPanel.OnMessage := DoMsg;
     DirTree.OnSelChange := SelChanged;
     DlgClient := DTSubPanel; // !!!
     s := CancelCaption; if s = '' then s := 'Cancel';
     BtCancel := NewButton( BtnPanel, s );
     BtCancel.MinWidth := 75; BtCancel.OnClick := DoCancel;
     BtCancel.AutoSize( TRUE ).SetAlign( caRight );
     s := OKCaption; if s = '' then s := 'OK';
     BtOK := NewButton( BtnPanel, s );
     BtOK.MinWidth := 75; BtOK.OnClick := DoOK;
     BtOK.AutoSize( TRUE ).SetAlign( caRight );
     BtOK.TabOrder := 0;
     BtOK.DefaultBtn := TRUE;
     BtCancel.CancelBtn := TRUE;
     DialogForm.OnShow := DoShow;
     {$IFDEF USE_GRUSH}
     {$IFDEF TOGRUSH_OPTIONAL}
     if not NoGrush then
     {$ENDIF TOGRUSH_OPTIONAL}
     begin
       BtOK.Transparent := TRUE;
       BtCancel.Transparent := TRUE;
     end;
     {$ENDIF USE_GRUSH}
   end;
end;

{$IFDEF DIRDLGEX_LINKSPANEL}
procedure TOpenDirDialogEx.CreateLinksPanel;
var BUp, BDn, BLt: PBitmap;
    {$IFDEF USE_GRUSH}
    cFrom: TColor;
    {$ENDIF USE_GRUSH}

    function NewArrowBitmap( const Pts: array of Integer ): PBitmap;
    var pf: TPixelFormat;
    begin
      pf := GetBetterPixelFormat;
      Result := NewDibBitmap( 16, 8, pf );
      Result.Canvas.Brush.Color := clBtnFace;
      Result.Canvas.FillRect( Result.BoundsRect );
      Result.Canvas.Brush.Color := clBlack;
      Result.Canvas.Polygon( [ MakePoint( Pts[ 0 ], Pts[ 1 ] ),
                               MakePoint( Pts[ 2 ], Pts[ 3 ] ),
                               MakePoint( Pts[ 4 ], Pts[ 5 ] ),
                               MakePoint( Pts[ 6 ], Pts[ 7 ] ) ] );
      //Result.SaveToFile( GetStartDir + 'arrow_bitmap' + Int2Hex( Integer( Result ), 8 ) + '.bmp' );
    end;

var PnUp, LUp, PnDn, LDn, PnLt, LLt: PControl;
    d: Integer;
begin
  if LinksPanel <> nil then Exit;
  GetDialogForm;

  BUp := NewArrowBitmap( [ 2, 6, 7, 1, 8, 1, 13, 6 ] );
  BDn := NewArrowBitmap( [ 2, 1, 7, 6, 8, 6, 13, 1 ] );
  BLt := NewArrowBitmap( [ 11, 0, 4, 3, 4, 4, 11, 7 ] );

  LinksPanel := NewPanel( DlgClient, esLowered )
    .SetSize( {$IFDEF DIRDLGEX_BIGGERPANEL} 14 + {$ENDIF} 64, 0 )
    .SetAlign( caLeft );
  //LinksPanel.OnShow := LinksPanelShowEvent;
  LinksPanel.Border := 2;
  {$IFNDEF DIRDLGEX_STDFONT}
  LinksPanel.Font.FontName := 'Arial';
  LinksPanel.Font.FontHeight := 14;
  {$ENDIF DIRDLGEX_STDFONT}

  d := 0;
  {$IFDEF USE_GRUSH}
    {$IFDEF TOGRUSH_OPTIONAL}
    if not NoGrush then
    {$ENDIF TOGRUSH_OPTIONAL}
      d := 2;
  {$ENDIF USE_GRUSH}
  NewPanelWithSingleButtonToolbar( LinksPanel, LinksPanel.Width-6+d, 15, caTop,
    BUp, '', '', PnUp, LUp, nil, LinksUpClick, LinksUpDnStop, nil, nil );
  NewPanelWithSingleButtonToolbar( LinksPanel, LinksPanel.Width-6+d, 15, caBottom,
    BDn, '', '', PnDn, LDn, nil, LinksDnClick, LinksUpDnStop, nil, nil );
  NewPanelWithSingleButtonToolbar( BtnPanel, 20, 16, caNone,
    BLt, '', '', PnLt, LLt, LinksAddClick, nil, nil, nil, nil ); PnLt.Width := 20;
  PnLt.SetPosition( 68, 0 );
  PnLt.Transparent := TRUE;
  LLt.Transparent := TRUE;
  LinksBox := NewPaintBox( LinksPanel ).SetAlign(caClient);
  LinksBox.Border := 0;
  LinksTape := NewPaintBox( LinksBox ).SetSize( LinksBox.Width, 0 );
  //LinksTape.DoubleBuffered := TRUE;
  {$IFDEF USE_GRUSH}
    {$IFDEF TOGRUSH_OPTIONAL}
    if not NoGrush then
    {$ENDIF TOGRUSH_OPTIONAL}
    begin
      LinksTape.Border := 2;
      LinksTape.MarginLeft := -2;
      LinksTape.MarginRight := -2;
      LinksTape.MarginTop := 2;
      LinksTape.MarginBottom := 2;
      //LinksPanel.Transparent := TRUE;
      PGRushControl( LinksPanel ).All_GradientStyle := gsHorizontal;
      cFrom := PGRushControl( LinksPanel ).Def_ColorFrom;
      PGRushControl( LinksPanel ).All_ColorTo := {
        PGRushControl( LinksPanel ).Def_ColorFrom;
      PGRushControl( LinksPanel ).All_ColorFrom :=} cFrom;
      LinksBox.Color := cFrom;
      //LinksAdd.Left := LinksAdd.Left + 6;
    end
    {$IFDEF TOGRUSH_OPTIONAL}
      else
    begin
      //LinksTape.Border := 0;
    end
    {$ENDIF TOGRUSH_OPTIONAL}
    ;
  {$ELSE not USE_GRUSH}
  LinksTape.Border := 0;
      //LinksTape.MarginLeft := -2;
      LinksTape.MarginRight := -4;
  {$ENDIF USE_GRUSH}
  LinksPanel.Visible := FALSE;
  LinksRollTimer := NewTimer( 50 );
  //LinksRollTimer.Enabled := FALSE;
  LinksRollTimer.OnTimer := LinksRollTimerTimer;
  LinksPanel.Add2AutoFree( LinksRollTimer );
end;
{$ENDIF DIRDLGEX_LINKSPANEL}

procedure TOpenDirDialogEx.DeleteNode(node: Integer);
  function NodeIsParentOf( node, parent: Integer ): Boolean;
  begin
    Result := TRUE;
    while node <> 0 do
    begin
      if node = parent then Exit;
      node := DirTree.TVItemParent[ node ];
    end;
    Result := FALSE;
  end;
var sel, n: Integer;
begin
  sel := DirTree.TVSelected;
  if (sel <> 0) and NodeIsParentOf( sel, node ) then
  begin
    n := DirTree.TVItemPrevious[ node ];
    if n = 0 then
      n := DirTree.TVItemNext[ node ];
    DirTree.TVSelected := n;
  end;
  DirTree.TVDelete( node );
end;

destructor TOpenDirDialogEx.Destroy;
begin
  Free_And_Nil( DialogForm );
  FPath := '';
  FRecycledName := '';
  OKCaption := '';
  CancelCaption := '';
  Title := '';
  {$IFDEF DIRDLGEX_LINKSPANEL}
  LinksList.Free;
  {$ENDIF DIRDLGEX_LINKSPANEL}
  inherited;
  OleUnInit;
end;

procedure TOpenDirDialogEx.DestroyingForm(Sender: PObj);
begin
  DialogForm := nil;
end;

procedure TOpenDirDialogEx.DoCancel(Sender: PObj);
begin
  DialogForm.ModalResult := -1;
end;

function TOpenDirDialogEx.DoExpanding(Sender: PControl; Item: THandle;
  Expand: Boolean): Boolean;
begin
  Result := FALSE;
  if RescanningNode or RescanningTree then Exit;
  if Expand then
    RescanNode( Item );
end;

function TOpenDirDialogEx.DoFilterAttrs(Attrs: DWORD; const APath: KOLString): Boolean;
begin
  Result := (Attrs and FilterAttrs = 0);
  if not Result then Exit;
  if FilterRecycled then
  begin
    if (Attrs and (FILE_ATTRIBUTE_SYSTEM or FILE_ATTRIBUTE_HIDDEN) =
                  (FILE_ATTRIBUTE_SYSTEM or FILE_ATTRIBUTE_HIDDEN))
    then
    //if StrEq( APath, 'RECYCLED' ) then
      Result := FALSE;
  end;
end;

function TOpenDirDialogEx.DoMsg(var Msg: TMsg; var Rslt: Integer): Boolean;
var NMHdr: PNMHdr;
    NMCustomDraw: PNMCustomDraw;
    i: Integer;
begin
  Result := FALSE;
  if DialogForm = nil then Exit;
  if Msg.message = WM_USER_RESCANTREE then
  begin
    Rescantree;
    DirTree.Focused := TRUE;
    Result := TRUE;
  end
    else
  if Msg.message = WM_NOTIFY then
  begin // отлавливается момент отрисовки каждого узла, чтобы проверить наличие
        // в нем дочерних папок, и "показать" кнопку [+], если есть
    NMHdr := Pointer( Msg.lParam );
    if DirTree = nil then Exit;
    if NMHdr.hwndFrom = DirTree.Handle then
    CASE NMHdr.code OF
    NM_CUSTOMDRAW:
      begin
        NMCustomDraw := Pointer( NMHdr );
        if NMCustomDraw.dwDrawStage = CDDS_ITEMPOSTPAINT then
        begin
          i := NMCustomDraw.dwItemSpec;
          if DirTree.TVItemData[ i ] = nil then // узел еще не проверялся
          begin
            CheckNodeHasChildren( i );          // проверить узел
            DirTree.TVItemData[ i ] := Pointer( 1 ); // флаг = "проверен"
          end;
          Rslt := CDRF_DODEFAULT; // пусть рисует себя сам как обычно
        end
        else
        if NMCustomDraw.dwDrawStage = CDDS_PREPAINT then
          Rslt := CDRF_NOTIFYITEMDRAW // сообщить для каждого узла на стадии CDDS_ITEMPREPAINT
        else
          Rslt := CDRF_NOTIFYPOSTPAINT; // при CDDS_ITEMPREPAINT: сообщить о CDDS_ITEMPOSTPAINT
        Result := TRUE;
      end;
    END;
  end;
end;

procedure TOpenDirDialogEx.DoNotClose(Sender: PObj;
  var Accept: Boolean);
begin
  Accept := FALSE;
  DialogForm.Hide;
end;

procedure TOpenDirDialogEx.DoOK(Sender: PObj);
begin
  DialogForm.ModalResult := 1;
end;

procedure TOpenDirDialogEx.DoShow(Sender: PObj);
begin
  MsgPanel.PostMsg( WM_USER_RESCANTREE, 0, 0 );
  {$IFDEF DIRDLGEX_LINKSPANEL}
  if LinksPanelOn and Assigned( LinksTape ) then
  begin
    Global_Align( LinksTape );
    SetupLinksTapeHeight;
  end;
  {$ENDIF DIRDLGEX_LINKSPANEL}
end;

type
  PControl_ = ^TControl_;
  TControl_ = object( TControl )
  end;

procedure TOpenDirDialogEx.DoubleClick(Sender: PControl;
  var M: TMouseEventData);
var N: DWORD;
    Where: DWORD;
begin
  N := DirTree.TVItemAtPos( M.X, M.Y, Where );
  if (N = DirTree.TVSelected) and
     not DirTree.TVItemHasChildren[ N ] then
     Form.ModalResult := 1;
end;

function TOpenDirDialogEx.Execute: Boolean;
var s: String;
    ParentForm: PControl_;
begin
  CreateDialogForm;
  DlgClient.ActiveControl := DirTree;
  s := Title; if s = '' then s := 'Select directory';
  DialogForm.Caption := s;
  ParentForm := PControl_( Applet.ActiveControl );
  if ParentForm <> nil then
  begin
    if  {$IFDEF USE_FLAGS} not(G3_IsForm in ParentForm.fFlagsG3)
        {$ELSE} not ParentForm.fIsForm {$ENDIF} then
        ParentForm := PControl_( Applet );
  end;
  if  ParentForm <> nil then
      DialogForm.StayOnTop := ParentForm.StayOnTop;
  DialogForm.ShowModal;
  DialogForm.Hide;
  if  ParentForm <> nil then
      SetForegroundWindow( ParentForm.Handle );
  Result := DialogForm.ModalResult >= 0;
  if  Result then
  begin
      Path := IncludeTrailingPathDelimiter(
          DirTree.TVItemPath( DirTree.TVSelected, '\' ) );
  end;
end;

function TOpenDirDialogEx.GetBetterPixelFormat: TPixelFormat;
var DC: HDC;
    i: Integer;
    PF: TPixelFormat;
begin
    DC := GetDC( 0 );
    i := GetDeviceCaps( DC, BITSPIXEL );
    ReleaseDC( 0, DC );
    CASE i OF
    16:  PF := pf16bit;
    else PF := pf32bit;
    END;
    Result := PF;
end;

function TOpenDirDialogEx.GetDialogForm: PControl;
begin
  CreateDialogForm;
  Result := DialogForm;
end;

function TOpenDirDialogEx.GetFindFirstFileEx: TFindFirstFileEx;
begin
  if not Assigned( FFindFirstFileEx ) then
  begin
    k32 := GetModuleHandle( 'kernel32.dll' );
    FFindFirstFileEx := GetProcAddress( k32, 'FindFirstFileExA' );
  end;
  Result := FFindFirstFileEx;
end;

function TOpenDirDialogEx.GetFindFirstFileExW: TFindFirstFileExW;
begin
  if not Assigned( FFindFirstFileExW ) then
  begin
    k32 := GetModuleHandle( 'kernel32.dll' );
    FFindFirstFileExW := GetProcAddress( k32, 'FindFirstFileExW' );
    FFindNextFileW := GetProcAddress( k32, 'FindNextFileW' );
  end;
  Result := FFindFirstFileExW;
end;

{$IFDEF DIRDLGEX_LINKSPANEL}
function TOpenDirDialogEx.GetLinks(idx: Integer): KOLString;
begin
  Result := '';
  if (LinksList <> nil) and (LinksList.Count > idx) then
    Result := LinksList.Items[ idx ];
end;

function TOpenDirDialogEx.GetLinksCount: Integer;
begin
  Result := 0;
  if LinksList <> nil then Result := LinksList.Count;
end;

function TOpenDirDialogEx.GetLinksPanelOn: Boolean;
begin
  Result := (LinksPanel <> nil) and (LinksPanel.Visible);
end;

procedure TOpenDirDialogEx.LinkClick(Sender: PObj);
var s, CurPath: String;
begin
  s := IncludeTrailingPathDelimiter(
    PChar( PControl( Sender ).CustomData ) );
  if  PControl( Sender ).RightClick then
  begin
      RemoveLink( s );
  end else
  begin
      if DirectoryExists( s ) then
      begin
        CurPath := IncludeTrailingPathDelimiter(
          DirTree.TVItemPath( DirTree.TVSelected, '\' ) );
        if StrEq( CurPath, s ) then
          Form.ModalResult := 1
        else Path := s;
      end;
  end;
end;

function TOpenDirDialogEx.LinkPresent(const s: KOLString): Boolean;
begin
  Result := (LinksList <> nil) and
            (LinksList.IndexOf_NoCase(
              IncludeTrailingPathDelimiter( s ) ) >= 0);
end;

procedure TOpenDirDialogEx.LinksAddClick(Sender: PObj);
var SL: PStrList;
    CurPath: String;
begin
  CurPath := IncludeTrailingPathDelimiter(
    DirTree.TVItemPath( DirTree.TVSelected, '\' ) );
  SL := NewStrList;
  if DirectoryExists( CurPath ) then
  begin
    SL.Add( CurPath );
    AddLinks( SL );
  end;
  SL.Free;
end;

procedure TOpenDirDialogEx.LinksBtnDnEvt(Sender: PControl;
  var Mouse: TMouseEventData);
var P: TPoint;
begin
  if Mouse.Button = mbRight then
  begin
    P.X := Mouse.X;
    P.Y := Mouse.Y;
    P := Sender.Client2Screen( P );
    LinksPopupMenu.CurCtl := Sender.Parent;
    LinksPopupMenu.Popup( P.X, P.Y );
    Mouse.StopHandling := TRUE;
  end;
end;

procedure TOpenDirDialogEx.LinksDnClick(Sender: PControl; var Mouse: TMouseEventData);
begin
  LinksRollTimer.Tag := 1;
  LinksRollTimer.Enabled := TRUE;
end;

{procedure TOpenDirDialogEx.LinksPanelShowEvent(Sender: PObj);
begin
end;}

procedure TOpenDirDialogEx.LinksRollTimerTimer(Sender: PObj);
var NewTop, d: Integer;
begin
  d := Integer( LinksRollTimer.Tag );
  LinksRollTimer.Tag := Integer( LinksRollTimer.Tag ) + Sgn( d );
  NewTop := LinksTape.Top - (Sgn( d ) + d div 4) * 2;
  if (d > 0) and
     (NewTop + LinksTape.Height < LinksBox.Height) and
     (LinksTape.Top <= 0) then
  begin
    NewTop := LinksBox.Height - LinksTape.Height;
    if NewTop > 0 then
      NewTop := 0;
  end;
  if (d < 0) and (NewTop > 0) then NewTop := 0;
  if (NewTop = LinksTape.Top) or not Form.Visible then
    LinksRollTimer.Enabled := FALSE;
  LinksTape.Top := NewTop;
  LinksTape.Update;
end;

procedure TOpenDirDialogEx.LinksUpClick(Sender: PControl; var Mouse: TMouseEventData);
begin
  LinksRollTimer.Tag := DWORD( -1 );
  LinksRollTimer.Enabled := TRUE;
end;

procedure TOpenDirDialogEx.LinksUpDnStop(Sender: PControl; var Mouse: TMouseEventData);
begin
  LinksRollTimer.Enabled := FALSE;
end;
{$ENDIF DIRDLGEX_LINKSPANEL}

function TOpenDirDialogEx.RemoteIconSysIdx: Integer;
begin
  if FRemoteIconSysIdx = 0 then
  begin
    if DirectoryExists( '\\localhost\' ) then
      FRemoteIconSysIdx := DirIconSysIdxOffline( '\\localhost\' )
    else
      FRemoteIconSysIdx := DirIconSysIdxOffline( 'C:\' );
  end;
  Result := FRemoteIconSysIdx;
end;

{$IFDEF DIRDLGEX_LINKSPANEL}
procedure TOpenDirDialogEx.RemoveLink(const s: KOLString);
var i: Integer;
    Pn: PControl;
begin
  i := LinksList.IndexOf( IncludeTrailingPathDelimiter( s ) );
  if i >= 0 then
  begin
    Pn := Pointer( LinksList.Objects[ i ] );
    Pn.Free;
    LinksList.Delete( i );
  end;
  //LinksTape.Height := LinksTape.Height + 1;
  //LinksTape.Height := LinksTape.Height - 1;
  SetupLinksTapeHeight;
end;

procedure TOpenDirDialogEx.RemoveLinkClick(Sender: PMenu; Item: Integer);
var Pn: PControl;
    i: Integer;
begin
  Form.ModalResult := 0; //????
  Pn := Sender.CurCtl;
  if Pn <> nil then
  begin
    i := LinksList.IndexOfObj( Pn );
    if i >= 0 then
    begin
      RemoveLink( LinksList.Items[ i ] );
    end;
  end;
end;
{$ENDIF DIRDLGEX_LINKSPANEL}

procedure TOpenDirDialogEx.RescanDisks;
begin
  RescanNode( 0 );
end;

procedure TOpenDirDialogEx.RescanNode(node: Integer);
{ (Пере)сканирование поддиректорий в заданной узлом node родительской папке.
  Если node = 0, то сканируется список дисков на уровне корня дерева.
}
var p, s: KOLString;
    DL: PDirList;
    i, j, n, d, m, ii: Integer;
    {$IFnDEF DONTTRY_FINDFILEEXW}
    Find32W: TWin32FindDataW;
    F: THandle;
    {$ENDIF}
    SL: PStrListEx;
    disk: Char;
    //test: String;
begin
  if AppletTerminated or not AppletRunning then Exit;
  RescanningNode := TRUE;
  //Applet.ProcessMessages;
  TRY
    // вычисляется путь к родительской папке или диску (пусто, если верхний уровень)
    p := '';
    if node <> 0 then
      p := IncludeTrailingPathDelimiter( DirTree.TVItemPath( node, '\' ) );
    // в SL накапливается список дочерних директорий (или дисков)
    SL := NewStrListEx;
    TRY
      if node = 0 then
      begin
        for disk := 'A' to 'Z' do
        begin
          case GetDriveTypeA( PChar( disk + ':\' ) ) of
          DRIVE_FIXED, DRIVE_RAMDISK:   ii := 0;
          DRIVE_REMOVABLE, DRIVE_CDROM: ii := 1;
          DRIVE_REMOTE:                 ii := 2;
          else ii := -1;
          end;
          if ii >= 0 then SL.AddObject( disk + ':', ii );
        end;
      end else
      {$IFnDEF DONTTRY_FINDFILEEXW}
      if  (WinVer >= wvNT) and _FindFirstFileExW then // используется более быстрый вариант - для NT/2K/XP
      begin
          F := FFindFirstFileExW( PWideChar( WideString( p + '*.*' ) ),
            FindExInfoStandard, @ Find32W,
            FindExSearchLimitToDirectories, nil, 0 );
          if  F <> INVALID_HANDLE_VALUE then
          begin
              TRY
                while TRUE do
                begin
                    if  Find32W.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0 then
                    if  (Find32W.cFileName <> WideString( '.' ))
                    and (Find32W.cFileName <> '..') then
                    if  DoFilterAttrs( Find32W.dwFileAttributes,
                                       Find32W.cAlternateFileName ) then
                        SL.Add( Find32W.cFileName );
                    if  not FFindNextFileW( F, @Find32W ) then break;
                end;
                SL.Sort( FALSE );
                //LogFileOutput( 'C:\sort_test.txt', '--------------------------'#13#10#13#10 +
                //               SL.Text );
              FINALLY
                FindClose( F );
              END;
          end;
      end else
      {$ENDIF}
      begin
        DL := NewDirListEx( p, '*.*;*', FILE_ATTRIBUTE_DIRECTORY );
        TRY
          DL.Sort( [ ] );
          for i := 0 to DL.Count-1 do
            if DoFilterAttrs( DL.Items[ i ].dwFileAttributes,
                              DL.Items[ i ].cAlternateFileName ) then
              SL.Add( DL.Names[ i ] );
        FINALLY
          DL.Free;
        END;
      end;
      // теперь просматриваются все дочерние узлы родителя node (или диски
      // на корневом уровне)
      if node = 0 then
        n := DirTree.TVRoot
      else
        n := DirTree.TVItemChild[ node ];
      for i := 0 to SL.Count do
      begin
        //test := DirTree.TVItemText[ n ];
        //test := SL.Items[ i ];
        // пока очередное имя в списке больше чем то что в очередном узле
        while (n <> 0) and
              ( (i >= SL.Count) or
                (AnsiCompareStrNoCase( SL.Items[ i ], DirTree.TVItemText[ n ] ) > 0)
              ) do
        begin
        //test := DirTree.TVItemText[ n ];
        //test := SL.Items[ i ];
          // если директория в текущем узле отсутствует в списке, то она удалена
          // и ее следует удалить из дерева после перехода к следующему узлу
          d := n;
          s := DirTree.TVItemText[ n ];
          for j := 0 to SL.Count-1 do
            if AnsiCompareStrNoCase( SL.Items[ j ], s ) = 0 then
            begin
              d := 0; break; // есть такая в списке, не удалять
            end;
          if d = 0 then
            DirTree.TVItemData[ n ] := nil; // сброс флажка "дочерние проверены"
          n := DirTree.TVItemNext[ n ];     // переход к следующему узлу дерева
          if d <> 0 then  // удаляется узел несуществуюшей директории
            //DirTree.TVDelete( d );
            DeleteNode( d );
        end;
        if i >= SL.Count then break;
        if  (n <> 0) and
            (AnsiCompareStrNoCase( SL.Items[ i ], DirTree.TVItemText[ n ] ) = 0) then
        begin
            DirTree.TVItemData[ n ] := nil; // сброс флажка "дочерние проверены"
            n := DirTree.TVItemNext[ n ];   // переход к следующему узлу дерева
            continue;
        end;
        // остается случай, когда (новое) имя директории меньше чем имя в
        // очередном узле (или узлы исчерпаны): надо добавить его перед этим узлом
        // (в конец списка узлов):
        if n = 0 then
          m := DirTree.TVInsert( node, TVI_LAST, SL.Items[ i ] )
        else
        begin
          m := DirTree.TVItemPrevious[ n ];
          if   m = 0 then
               m := DirTree.TVInsert( node, TVI_FIRST, SL.Items[ i ] )
          else m := DirTree.TVInsert( node, m, SL.Items[ i ] );
        end;
        if  (SL.Objects[ i ] = 1) and FastScan then
            SL.Objects[ i ] := 2;
        CASE SL.Objects[ i ] OF
        0{,1}: ii := FileIconSystemIdx( p + SL.Items[ i ] + '\' );
        1: ii := DirIconSysIdxOffline( p + SL.Items[ i ] + '\' );
        {2:}else ii := RemoteIconSysIdx;
        END;
        DirTree.TVItemImage[ m ] := ii;
        DirTree.TVItemSelImg[ m ] := ii;
      end;
      if SL.Count = 0 then
        if node <> 0 then
          DirTree.TVItemHasChildren[ node ] := FALSE;
    FINALLY
      SL.Free;
    END;
  FINALLY
    RescanningNode := FALSE;
  END;
end;

procedure TOpenDirDialogEx.Rescantree;
var s, n, d, e: KOLString;
    node, parent, ii: Integer;
begin
  RescanningTree := TRUE;
  //DirTree.BeginUpdate;
  TRY
    RescanDisks;
    if (Path = '') or not DirectoryExists( Path ) then Path := GetWorkDir;
    node := DirTree.TVSelected;
    if (node = 0)
       // дерево пусто: первоначальное заполнение - от текущего узла к корню (диску)
       // и добавление списка всех дисков на верхнем уровне
       OR
       (AnsiCompareStrNoCase( IncludeTrailingPathDelimiter(
                              DirTree.TVItemPath( node, '\' ) ),
                              IncludeTrailingPathDelimiter( Path ) ) <> 0 )
       // или текущий узел в дереве отличатся от того, что указано в Path
    then
    begin
      node := 0;
      s := Path;
      e := '';
      // парсируем путь, по очереди опусаясь все ниже к указанной папке
      while s <> '' do
      begin
        if AppletTerminated or not AppletRunning then Exit;
        n := Parse( KOLString(s), '\/' );
        if n = '' then continue;
        if (n[ Length( n ) ] <> ':') and (pos( ':', n ) > 0) then
        begin
          d := Parse( n, ':' ) + ':';
          s := n + '\' + s;
          n := d;
        end;
        // n = очередной узел, который надо либо найти среди деток node,
        // либо построить в этом списке, если его там нет
        parent := node;
        if parent = 0 then
          node := DirTree.TVRoot
        else
          node := DirTree.TVItemChild[ parent ];
        while node <> 0 do
        begin
          if AnsiCompareStrNoCase( DirTree.TVItemText[ node ], n ) = 0 then
            break;
          node := DirTree.TVItemNext[ node ];
        end;
        if node = 0 then
          node := DirTree.TVInsert( parent, TVI_LAST, n );
        if parent <> 0 then
          DirTree.TVExpand( parent, TVE_EXPAND );
        e := e + n + '\'; // по дороге в e строим полный путь
        ii := FileIconSystemIdx( e );
        DirTree.TVItemImage[ node ] := ii;
        DirTree.TVItemSelImg[ node ] := ii;
        if (Length( n ) = 2) and (n[ 2 ] = ':') then
        begin
          if not IntIn( GetDriveType( PKOLChar( n + '\' ) ),
                  [ DRIVE_REMOVABLE, DRIVE_REMOTE, DRIVE_CDROM ] ) then
            RescanNode( node );
        end
          else
          RescanNode( node );
      end;
      DirTree.TVSelected := node;
    end;
    if node <> 0 then
      DirTree.Perform( TVM_ENSUREVISIBLE, 0, node );
  FINALLY
    RescanningTree := FALSE;
    //DirTree.EndUpdate;
  END;
end;

{$IFDEF DIRDLGEX_LINKSPANEL}
procedure TOpenDirDialogEx.SelChanged(Sender: PObj);
var n: Integer;
begin
    n := PControl(Sender).TVSelected;
    RescanNode( n );
end;

procedure TOpenDirDialogEx.SetLinks(idx: Integer; const Value: KOLString);
var Bar, Pn: PControl;
    Bmp: PBitmap;
    Ico: PIcon;
    s: String;
    H: Integer;
begin
  CreateLinksPanel;

  s := ExcludeTrailingPathDelimiter( Value );
  if  LinksList = nil then
      LinksList := NewStrListEx;
  while LinksList.Count <= idx do
      LinksList.AddObject( '', 0 );
  if  LinksList.Objects[ idx ] <> 0 then
      PObj( Pointer( LinksList.Objects[ idx ] ) ).Free;
  Bmp := NewDibBitmap( 32, 32, GetBetterPixelFormat );
  Bmp.Canvas.Brush.Color := clBtnFace;
  Bmp.Canvas.FillRect( Bmp.BoundsRect );
  if  LinksImgList = nil then
  begin
      LinksImgList := NewImageList( LinksPanel );
      LinksImgList.LoadSystemIcons( FALSE );
  end;
  Ico := NewIcon;
  Ico.Handle := LinksImgList.ExtractIcon( FileIconSystemIdx( s ) );
  Ico.Draw( Bmp.Canvas.Handle, 0, 0 );
  Ico.Free;

  if  LinksPopupMenu = nil then
  begin
      NewMenu( Form, 0, [ '' ], nil );
      LinksPopupMenu := NewMenu( Form, 0, [ '&Remove link' ], nil );
      LinksPopupMenu.AssignEvents( 0, [ RemoveLinkClick ] );
  end;

  H := 60;
  {$IFDEF DIRDLGEX_BIGGERPANEL}
  {$IFDEF USE_GRUSH}
    {$IFDEF TOGRUSH_OPTIONAL}
    if not NoGrush then
    {$ENDIF TOGRUSH_OPTIONAL}
      inc( H, 14 );
  {$ENDIF USE_GRUSH}
  {$ENDIF DIRDLGEX_BIGGERPANEL}
  NewPanelWithSingleButtonToolbar( LinksTape, LinksBox.Width-8,
    H, caNone, Bmp,
    ExtractFileName( s ), s, Pn, Bar, LinkClick, nil, nil, LinksBtnDnEvt, LinksPopupMenu );
  Pn.CreateWindow;

  LinksList.Items[ idx ] := IncludeTrailingPathDelimiter( Value );
  LinksList.Objects[ idx ] := DWORD( Pn );

  SetUpTaborders;
  SetupLinksTapeHeight;
end;

procedure TOpenDirDialogEx.SetLinksPanelOn(const Value: Boolean);
begin
  if LinksPanelOn = Value then Exit;
  GetDialogForm;
  if Assigned( LinksPanel ) then
    LinksPanel.Visible := Value;
  if not Value then LinksAdd.Visible := FALSE
  else
  begin
    CreateLinksPanel;
    LinksPanel.Visible := TRUE;
  end;
end;
{$ENDIF DIRDLGEX_LINKSPANEL}

procedure TOpenDirDialogEx.SetPath(const Value: KOLString);
begin
  FPath := Value;
  if FPath <> '' then
    FPath := IncludeTrailingPathDelimiter( FPath );
  if Assigned( DialogForm ) and (DialogForm.Visible) then
    Rescantree;
end;

{$IFDEF DIRDLGEX_LINKSPANEL}
procedure TOpenDirDialogEx.SetupLinksTapeHeight;
var H: Integer;
    Pn: PControl;
    i: Integer;
begin
  H := 0;
  if (LinksList <> nil) and (LinksList.Count > 0) then
  begin
    for i := 0 to LinksList.Count-1 do
    begin
        Pn := Pointer( LinksList.Objects[ i ] );
        Pn.Top := H;
        H := Pn.Top + Pn.Height;
    end;
  end;
  LinksTape.Height := H + 4;
end;

procedure TOpenDirDialogEx.SetUpTaborders;
var i: Integer;
    Pn: PControl;
begin
  for i := 0 to LinksCount-1 do
  begin
    Pn := Pointer( LinksList.Objects[ i ] );
    Pn.TabOrder := i;
  end;
end;
{$ENDIF DIRDLGEX_LINKSPANEL}

function TOpenDirDialogEx._FindFirstFileExW: Boolean;
begin
    Result := Assigned( GetFindFirstFileExW(  ) );
end;

end.
