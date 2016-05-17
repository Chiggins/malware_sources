{*******************************************************************************
    KOL_deprecated.inc
    -- declarations and code deprecated in KOL.pas
********************************************************************************}

{$IFDEF interface_1} ///////////////////////////////////////////////////////////
  {$IFNDEF _D2}
  {$IFNDEF _FPC}
  TOnLVDataW = procedure( Sender: PControl; Idx, SubItem: Integer;
              var Txt: WideString; var ImgIdx: Integer; var State: DWORD;
              var Store: Boolean ) of object;
  {* Event type for OnLVDataW event (the same as OnLVData, but for unicode verion
     of the control OnLVDataW allows to return WideString text in the event
     handler). Used to provide virtual list view control
     (i.e. having lvoOwnerData style) with actual data on request. Use parameter
     Store as a flag if control should store obtained data by itself or not. }
  {$ENDIF _FPC}
  {$ENDIF _D2}
{$ENDIF interface_1} ///////////////////////////////////////////////////////////

{$IFDEF interface_2} ///////////////////////////////////////////////////////////
    {$IFNDEF _FPC}
    {$IFNDEF _D2}
  protected
    fOnLVDataW: TOnLVDataW;
    function GetLVColTextW(Idx: Integer): WideString;
    procedure SetLVColTextW(Idx: Integer; const Value: WideString);
    function LVGetItemTextW(Idx, Col: Integer): WideString;
    procedure LVSetItemTextW(Idx, Col: Integer; const Value: WideString);
    function TVGetItemTextW(Item: THandle): WideString;
    procedure TVSetItemTextW(Item: THandle; const Value: WideString);
    procedure SetOnLVDataW(const Value: TOnLVDataW);
  public
    procedure LVColAddW( const aText: WideString; aalign: TTextAlign; aWidth: Integer );
    {* |<#listview>
       Adds new column (unicode version). }
    procedure LVColInsertW( ColIdx: Integer; const aText: WideString; aAlign: TTextAlign; aWidth: Integer );
    {* |<#listview>
       Inserts new column at the Idx position (1-based column index). }
    property LVColTextW[ Idx: Integer ]: WideString read GetLVColTextW write SetLVColTextW;
    {* |<#listview>
       Allows to get/change column header text at run time. }
    function LVItemAddW( const aText: WideString ): Integer;
    {* |<#listview>
       Adds an item to the end of list view. Returns an index of the item added. }
    function LVItemInsertW( Idx: Integer; const aText: WideString ): Integer;
    {* |<#listview>
       Inserts an item to Idx position. This method is deprecated, use
       TVItemInsert (adding symbol UNICODE_CTRLS to options) }
    property LVItemsW[ Idx, Col: Integer ]: WideString read LVGetItemTextW write LVSetItemTextW;
    {* |<#listview>
       Access to List View item text. }
    function LVIndexOfW( const S: WideString ): Integer;
    {* Returns first list view item index with caption matching S.
       The same as LVSearchForW( S, -1, FALSE ). }
    function LVSearchForW( const S: WideString; StartAfter: Integer; Partial: Boolean ): Integer;
    {* Searches an item with Caption equal to S (or starting from S, if Partial = TRUE).
       Searching is started after an item specified by StartAfter parameter. }
    property OnLVDataW: TOnLVDataW read fOnLVDataW write SetOnLVDataW;
    {* |<#listview>
       The same as OnLVData, but for unicode version of the list view allows
       to return WideString text in the event handler. Though for unicode list
       view it is still possible to use ordinary event OnLVData, it is
       very recommended to use this event istead. }
    function TVInsertW( nParent, nAfter: THandle; const Txt: WideString ): THandle;
    {* |<#treeview>
       Inserts item to a tree view. If nParent is 0 or TVI_ROOT, the item is
       inserted at the root of tree view. It is possible to pass following special
       values as nAfter parameter:
       |<pre>
       TVI_FIRST        Inserts the item at the beginning of the list.
       TVI_LAST	        Inserts the item at the end of the list.
       TVI_SORT	        Inserts the item into the list in alphabetical order.
       |</pre><br>
       This version of the method is Unicode. The tree view control should be
       set up as unicode control calling Perform( TVM_SETUNICODEFORMAT, 1, 0 ),
       and conditional symbol UNICODE_CTRLS must be defined to provide event
       handling for such kind of tree view (and other Unicode) controls. }
    property TVItemTextW[ Item: THandle ]: WideString read TVGetItemTextW write TVSetItemTextW;
    {* |<#treeview>
       Text of tree view item. }
    function TVItemPathW( Item: THandle; Delimiter: WideChar ): WideString;
    {* |<#treeview>
       Returns full path from the root item to given item. Path is calculated
       as a concatenation of all parent nodes text strings, separated by
       given delimiter character. If Item is not specified ( =0 ), path is returned
       for Selected item. }
    {$ENDIF _D2}
    {$ENDIF _FPC}
{$ENDIF interface_2} ///////////////////////////////////////////////////////////

{$IFDEF implementation} ////////////////////////////////////////////////////////
{$IFNDEF _FPC}
{$IFNDEF _D2}
//[procedure LVGetItemW]
procedure LVGetItemW( Sender: PControl; Idx, Col: Integer; var LVI: TLVItemW;
          TextBuf: PWideChar; TextBufSize: Integer );
begin
  LVI.mask := LVIF_STATE or LVIF_PARAM or LVIF_IMAGE;
  if Col > 0 then
  if not (lvoSubItemImages in Sender.fLVOptions) then
    LVI.mask := LVIF_STATE or LVIF_PARAM;
  LVI.iItem := Idx;
  LVI.iSubItem := Col;
  LVI.pszText := TextBuf;
  LVI.cchTextMax := TextBufSize;
  if TextBufSize <> 0 then
    LVI.mask := LVI.mask or LVIF_TEXT;
  Sender.Perform( LVM_GETITEMW, 0, Integer( @LVI ) );
end;

//[procedure TControl.LVColAddW]
procedure TControl.LVColAddW(const aText: WideString; aalign: TTextAlign;
  aWidth: Integer);
begin
  LVColInsertW( fLVColCount, aText, aalign, aWidth );
end;

//[procedure TControl.LVColInsertW]
procedure TControl.LVColInsertW(ColIdx: Integer; const aText: WideString;
  aAlign: TTextAlign; aWidth: Integer);
var LVColData: TLVColumnW;
begin
  LVColData.mask := LVCF_FMT or LVCF_TEXT;
  if ImageListSmall <> nil then
    LVColData.mask := LVColData.mask; // or LVCF_IMAGE ;
  LVColData.iImage := -1;
  LVColData.fmt := Ord( aAlign );
  if aWidth < 0 then
  begin
    aWidth := -aWidth;
    LVColData.fmt := LVColData.fmt or LVCFMT_BITMAP_ON_RIGHT;
  end;
  LVColData.cx := aWidth;
  if aWidth > 0 then
    LVColData.mask := LVColData.mask or LVCF_WIDTH;
  LVColData.pszText := PWideChar( aText );
  if Perform( LVM_INSERTCOLUMNW, ColIdx, Integer( @LVColData ) ) >= 0 then
    Inc( fLVColCount );
end;

//[function TControl.GetLVColTextW]
function TControl.GetLVColTextW(Idx: Integer): WideString;
var Buf: array[ 0..4095 ] of WideChar;
    LC: TLVColumnW;
begin
  LC.mask := LVCF_TEXT;
  LC.pszText := @ Buf[ 0 ];
  LC.cchTextMax := High( Buf ) + 1;
  Buf[ 0 ] := #0;
  Perform( LVM_GETCOLUMNW, Idx, Integer( @ LC ) );
  Result := Buf;
end;

//[procedure TControl.SetLVColTextW]
procedure TControl.SetLVColTextW(Idx: Integer; const Value: WideString);
var LC: TLVColumnW;
begin
  FillChar( LC, Sizeof( LC ), 0 );
  LC.mask := LVCF_TEXT;
  LC.pszText := '';
  if Value <> '' then
    LC.pszText := @ Value[ 1 ];
  Perform( LVM_SETCOLUMNW, Idx, Integer( @ LC ) );
end;

//[function TControl.LVGetItemTextW]
function TControl.LVGetItemTextW(Idx, Col: Integer): WideString;
var LVI: TLVItemW;
    TextBuf: PWideChar;
    BufSize: DWORD;
begin
  BufSize := 0;
  TextBuf := nil;
  repeat
    if TextBuf <> nil then
       FreeMem( TextBuf );
    BufSize := BufSize * 2 + 100; // to vary in asm version
    GetMem( TextBuf, BufSize * 2 );
    TextBuf[ 0 ] := #0;
    LVGetItemW( @Self, Idx, Col, LVI, TextBuf, BufSize );
  until DWORD( WStrLen( TextBuf ) ) < BufSize - 1;
  Result := TextBuf;
  FreeMem( TextBuf );
end;

//[procedure TControl.LVSetItemTextW]
procedure TControl.LVSetItemTextW(Idx, Col: Integer;
  const Value: WideString);
var LVI: TLVItemW;
begin
  LVI.iSubItem := Col;
  LVI.pszText := PWideChar( Value );
  Perform( LVM_SETITEMTEXTW, Idx, Integer( @LVI ) );
end;

//[function TControl.TVGetItemTextW]
function TControl.TVGetItemTextW(Item: THandle): WideString;
var TVI: TTVItemW;
    Buffer: array[ 0..4095 ] of WideChar;
begin
  TVI.mask := TVIF_HANDLE or TVIF_TEXT;
  TVI.hItem := Item;
  TVI.pszText := @Buffer[ 0 ];
  Buffer[ 0 ] := #0;
  TVI.cchTextMax := High( Buffer ) + 1;
  Perform( TVM_GETITEMW, 0, Integer( @TVI ) );
  Result := Buffer;
end;

//[procedure TControl.TVSetItemTextW]
procedure TControl.TVSetItemTextW(Item: THandle; const Value: WideString);
var TVI: TTVItemW;
begin
  TVI.mask := TVIF_HANDLE or TVIF_TEXT;
  TVI.hItem := Item;
  TVI.pszText := PWideChar( Value );
  Perform( TVM_SETITEMW, 0, Integer( @TVI ) );
end;

//[function TControl.TVItemPathW]
function TControl.TVItemPathW(Item: THandle;
  Delimiter: WideChar): WideString;
begin
  if Item = 0 then
    Item := TVSelected;
  Result := '';
  while Item <> 0 do
  begin
    if Result <> '' then
      Result := {$IFDEF _D3} '' + {$ENDIF} Delimiter + Result;
    Result := TVItemTextW[ Item ] + Result;
    Item := TVItemParent[ Item ];
  end;
end;

type
  TTVInsertStructW = packed Record
    hParent: THandle;
    hAfter : THandle;
    item: TTVItemW;
  end;
  TTVInsertStructExW = packed Record
    hParent: THandle;
    hAfter : THandle;
    item: TTVItemExW;
  end;

//[function TControl.TVInsertW]
function TControl.TVInsertW(nParent, nAfter: THandle;
  const Txt: WideString): THandle;
var TVIns: TTVInsertStructW;
begin
  TVIns.hParent := nParent;
  TVIns.hAfter := nAfter;
  TVIns.item.mask := TVIF_TEXT;
  if Txt = '' then TVIns.item.pszText := nil
              else TVIns.item.pszText := PWideChar( @ Txt[ 1 ] );
  Result := Perform( TVM_INSERTITEMW, 0, Integer( @ TVIns ) );
  Invalidate;
end;

//[function TControl.LVItemInsertW]
function TControl.LVItemInsertW(Idx: Integer;
  const aText: WideString): Integer;
var LVI: TLVItemW;
begin
  LVI.mask := LVIF_TEXT or LVIF_DI_SETITEM;
  LVI.iItem := Idx;
  LVI.iSubItem := 0;
  LVI.pszText := PWideChar( aText );
  Result := Perform( LVM_INSERTITEMW, 0, Integer( @LVI ) );
end;

//[function TControl.LVItemAddW]
function TControl.LVItemAddW(const aText: WideString): Integer;
begin
  Result := LVItemInsertW( Count, aText );
end;

procedure TControl.SetOnLVDataW(const Value: TOnLVDataW);
begin
  fOnLVDataW := Value;
  AttachProc( @WndProc_LVData );
  Perform( LVM_SETCALLBACKMASK, LVIS_OVERLAYMASK or LVIS_STATEIMAGEMASK, 0 );
end;

function TControl.LVIndexOfW(const S: WideString): Integer;
begin
  Result := LVSearchForW( S, -1, FALSE );
end;

//[function TControl.LVSearchForW]
function TControl.LVSearchForW(const S: WideString; StartAfter: Integer;
  Partial: Boolean): Integer;
var f: TLVFindInfoW;
begin
    f.lParam := 0;
    f.flags  := LVFI_STRING;
    if Partial then
      f.flags := LVFI_STRING or LVFI_PARTIAL;
    f.psz    := @s[1];
    result := Perform(LVM_FINDITEMW,StartAfter,integer(@f));
end;
{$ENDIF _D2}
{$ENDIF _FPC}
{$ENDIF implementation} ////////////////////////////////////////////////////////
