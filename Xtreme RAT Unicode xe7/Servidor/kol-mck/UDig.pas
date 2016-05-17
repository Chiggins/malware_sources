unit UDig;

interface

function  stri (n,n1:integer;zero,trim:boolean):string;
function  strL (n: longint; n1 :integer):string;

{function  strr(n:real;n1,n2:word):string;
function  strH (w : longint; c : word) : string;}
function  strhl(w : longint; c : word) : string;
function  hexi(s:string):word;
function  hexl(s:string):longint;
function  inti(s:string):word;
{function  intl(s:string):longint; }

implementation

uses UWrd, UStr;

function atrim(s : string) : string;
var t : string;
begin
   t := s;
   while (t[1]         = ' ') and (length(t) > 0) do t := copy(t, 2, 255);
   while (t[length(t)] = ' ') and (length(t) > 0) do t := copy(t, 1, length(t) - 1);
   atrim := t;
end;

{
function strh;
const a:array[0..15] of cHar =
            ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var   r:string;
begin
   if c>0 then r:=strh(w div 16,c-1)+a[w mod 16]
          else r:='';
   strH := r;
end;
}
function strhl;
const a:array[0..15] of cHar =
            ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var   r:string;
begin
   if c > 0 then
      if w mod 16 >= 0 tHen r := strhl(w sHr 4, c - 1) + a[     w mod 16] else
                            r := strHl(w sHr 4, c - 1) + a[16 + w mod 16]
          else r := '';
   strHl := r;
end;

function hexi;
const a : string[15] ='123456789ABCDEF';
  var i : integer;
      h :word;
begin
   h:=0;
   for i:=1 to length(s) do begin
      if S[i]<>' ' then begin
         h:=h shl 4;
         h:=h+pos(UpCase(S[i]),a);
      end;
   end;
   hexi:=h;
end;

function hexl;
const a : string[15] ='123456789ABCDEF';
  var i : integer;
      h :longint;
begin
   h:=0;
   for i:=1 to length(s) do begin
      if S[i]<>' ' then begin
         h:=h shl 4;
         h:=h+pos(UpCase(S[i]),a);
      end;
   end;
   hexl:=h;
end;

function inti;
var
    rc : integer;
    ww : longint;
begin
   val(s, ww, rc);
   inti := ww;
end;
{
function intl;
var
    rc : integer;
    ww : integer;
begin
   val(s, ww, rc);
   intl := ww;
end;
}

function stri;
var s : string;
    i : integer;
begin
   str(n: n1, s);
   if zero THen begin
      for i := 1 to lengtH(s) do
         if s[i] = ' ' THen s[i] := '0';
   end;
   if trim then s := atrim(s);
   stri := s;
end;

function strl;
var s:string;
begin
   str(n:n1,s);
   strl:=s;
end;

{
function strr;
var s:string;
begin
   str(n:n1:n2,s);
   strr:=s;
end;
}

end.
