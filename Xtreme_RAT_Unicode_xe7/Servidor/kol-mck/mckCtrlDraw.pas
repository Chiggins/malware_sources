{
by Roman Vorobets

    В mckCtrls y TKOLButton,TKOLLabel,TEditbox,TCheckBox и TRadioBox нyжно
добавить метод

TKOL#####=class(TKOLControl)
...
protected
  procedure Paint;override;
...
end;

...

procedure TKOL#####.Paint;
begin
  Draw#####(self,canvas);
end;
}
unit mckCtrlDraw;

interface

uses
  windows, graphics, mirror, mckctrls, extctrls, classes;

procedure DrawButton(_Button:TKOLButton; Canvas:TCanvas);
procedure DrawLabel(_Label:TKOLLabel; Canvas:TCanvas);
procedure DrawEditbox(_Editbox:TKOLEditbox; Canvas:TCanvas);
procedure DrawCheckbox(_Checkbox:TKOLCheckbox; Canvas:TCanvas);
procedure DrawRadiobox(_Radiobox:TKOLRadiobox; Canvas:TCanvas);
procedure DrawCombobox(_Combobox:TKOLCombobox; Canvas:TCanvas);

implementation

const
  TextHFlags:array[TTextAlign] of dword=(DT_LEFT,DT_RIGHT,DT_CENTER);
  TextVFlags:array[TVerticalAlign] of dword=(DT_TOP,DT_VCENTER,DT_BOTTOM);
  WordWrapFlags:array[Boolean] of dword=(DT_SINGLELINE,0);
  CheckFlags:array[Boolean] of dword=(0,DFCS_CHECKED);

procedure DrawButton(_Button:TKOLButton; Canvas:TCanvas);
var
  r:trect;
  s:string;
begin
  with _button,canvas do
  begin
    r:=clientrect;
    s:=caption;
    drawframecontrol(handle,r,DFC_BUTTON,DFCS_BUTTONPUSH);
    inflaterect(r,-1,-1);
    setbkmode(handle,windows.TRANSPARENT);
    drawtext(handle,pchar(s),length(s),r,texthflags[textalign] or
      textvflags[verticalalign] or DT_SINGLELINE);
  end;
end;

procedure DrawLabel(_Label:TKOLLabel; Canvas:TCanvas);
var
  r:trect;
  s:string;
begin
  with _label,canvas do
  begin
    r:=clientrect;
    s:=caption;
    brush.color:=clbtnshadow;
    framerect(r);
    setbkmode(handle,windows.TRANSPARENT);
    drawtext(handle,pchar(s),length(s),r,texthflags[textalign] or
      textvflags[verticalalign] or wordwrapflags[wordwrap]);
  end;
end;

procedure DrawEditbox(_Editbox:TKOLEditbox; Canvas:TCanvas);
var
  r:trect;
  s:string;
begin
  with _editbox,canvas do
  begin
    r:=clientrect;
    s:=caption;
    if hasborder then
    begin
      frame3d(canvas,r,clbtnshadow,clbtnhighlight,1);
      frame3d(canvas,r,clblack,cl3dlight,1);
    end;
    setbkmode(handle,windows.TRANSPARENT);
    drawtext(handle,pchar(s),length(s),r,
      texthflags[textalign] or DT_SINGLELINE);
  end;
end;

procedure DrawCheckbox(_Checkbox:TKOLCheckbox; Canvas:TCanvas);
var
  r,rr:trect;
  s:string;
begin
  with _checkbox,canvas do
  begin
    r:=clientrect;
    s:=caption;

    {brush.color:=clbtnshadow;
    framerect(r);}
    if _Checkbox.HasBorder then
      DrawEdge( Canvas.Handle, r, EDGE_RAISED, BF_RECT or BF_MIDDLE );

    rr:=bounds(r.left+2,(r.bottom+r.top-13) div 2,13,13);
    drawframecontrol(handle,rr,DFC_BUTTON,
      DFCS_BUTTONCHECK or checkflags[checked]);
    inc(r.left,17);
    setbkmode(handle,windows.TRANSPARENT);
    drawtext(handle,pchar(s),length(s),r,DT_VCENTER or DT_SINGLELINE);
  end;
end;

procedure DrawRadiobox(_Radiobox:TKOLRadiobox; Canvas:TCanvas);
var
  r,rr:trect;
  s:string;
begin
  with _radiobox,canvas do
  begin
    r:=clientrect;
    s:=caption;

    {brush.color:=clbtnshadow;
    framerect(r);}
    if _Radiobox.HasBorder then
      DrawEdge( Canvas.Handle, r, EDGE_RAISED, BF_RECT or BF_MIDDLE );
      
    rr:=bounds(r.left+2,(r.bottom+r.top-13) div 2,13,13);
    drawframecontrol(handle,rr,DFC_BUTTON,
      DFCS_BUTTONRADIO or checkflags[checked]);
    inc(r.left,17);
    setbkmode(handle,windows.TRANSPARENT);
    drawtext(handle,pchar(s),length(s),r,DT_VCENTER or DT_SINGLELINE);
  end;
end;

procedure DrawCombobox1(_Combobox:TKOLCombobox; Canvas:TCanvas;
                        r: TRect);
var
  w:integer;
  s:string;
begin
  with _Combobox,canvas do
  begin
    if (curindex>=0) and (curindex<items.count) then s:=items[curindex] else
s:='';
    if hasborder then
    begin
      frame3d(canvas,r,clbtnshadow,clbtnhighlight,1);
      frame3d(canvas,r,clblack,cl3dlight,1);
    end;
    if not( coSimple in _Combobox.Options) then
    begin
      w:=getsystemmetrics(SM_CXVSCROLL);
      drawframecontrol(handle,rect(r.right-w,r.top,r.right,r.bottom),DFC_SCROLL,
      DFCS_SCROLLCOMBOBOX);
      dec(r.right,w);
    end;
    setbkmode(handle,windows.TRANSPARENT);
    if s<>'' then drawtext(handle,pchar(s),length(s),r,DT_VCENTER or
DT_SINGLELINE);
  end;
end;

procedure DrawCombobox(_Combobox:TKOLCombobox; Canvas:TCanvas);
var R, R1: TRect;
    Bot: Integer;
    I: Integer;
    S: String;
begin
  if coSimple in _Combobox.Options then
  begin
    R := _Combobox.ClientRect;
    Bot := R.Bottom;
    R.Bottom := R.Top + Canvas.TextHeight( 'A' ) + 8;
    DrawCombobox1( _Combobox, Canvas, R );
    R.Top := R.Bottom;
    R.Bottom := Bot;
    frame3d(Canvas,R,clbtnshadow,clbtnhighlight,1);
    frame3d(Canvas,R,clblack,cl3dlight,1);
    Inc( R.Left, 2 );
    setbkmode(Canvas.Handle,windows.TRANSPARENT);
    R1 := R;
    for I := 0 to _Combobox.Items.Count-1 do
    begin
      S := _Combobox.Items[ I ];
      R1.Bottom := R1.Top + Canvas.TextHeight( 'A' ) + 4;
      if R1.Bottom > R.Bottom then
        R1.Bottom := R.Bottom;
      drawtext(Canvas.Handle,pchar(S),length(s),r1,
               {DT_VCENTER or} DT_SINGLELINE);
      R1.Top := R1.Bottom;
      if R1.Top >= R.Bottom then
      begin
        R.Left := R.Right - getsystemmetrics( SM_CXVSCROLL );
        //DrawScrollBar_Vertical( Canvas.Handle, R );
        break;
      end;
    end;
  end
    else
  begin
    DrawCombobox1( _Combobox, Canvas, _Combobox.ClientRect );
  end;
end;

end.

