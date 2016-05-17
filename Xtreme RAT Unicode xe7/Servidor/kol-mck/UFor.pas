unit UFor;

interface

function points(d : boolean; t : string; m : integer): string;
function toreal(r : string): real;
function rtostr(r : real): string;
function plslop(o, c: string; back, buys: boolean): string;
function plslom(o, c: string; back, buys: boolean; size, amnt, intr: string): string;
function chkprc(o, c, q, b: string): boolean;

implementation
uses SysUtils;

function points;
var s : string;
    p,
    i,
    e : integer;
begin
   s := t;
   if pos('.', s) = 0 then s := s + '.';
   while length(s) < 6  do s := s + '0';
   p := pos('.', s);
   s := copy(s, 1, p - 1) + copy(s, p + 1, 6 - p);
   val(s, i, e);
   if d then inc(i, m) else dec(i, m);
   s := inttostr(i);
   while length(s) < 5 do s := '0' + s;
   s := copy(s, 1, p - 1) + '.' + copy(s, p, 6 - p);
   points := s;
end;

function toreal(r: string): real;
var f : real;
    i : integer;
    s : string;
begin
   S := R;
   val(trim(S), F, I);
   if (i > 0) and (I < length(S)) then begin
      if S[I] = '.' then S[I] := ',' else
      if S[I] = ',' then S[i] := '.';
      val(trim(S), F, I);
   end;
   result := F;
end;

function rtostr;
var s : string;
begin
    str(r:5:2, s);
    rtostr := s;
end;

function plslop;
var op,
    cl : real;
     j : integer;
begin
   op := toreal(o);
   cl := toreal(c);
   repeat
      op := op * 10;
      cl := cl * 10;
   until op > 3000;
   j := round(cl - op);
   if back xor buys then j := -j;
   plslop := inttostr(j);
end;

function plslom;
var op, cl: real;
        dd: real;
begin
   plslom := '0';
   op := toreal(o);
   cl := toreal(c);
   if (op = 0) or (cl = 0) then exit;
   if back then dd :=   cl -   op
           else dd := 1/op - 1/cl;
   dd := dd * toreal(size);
   if back xor buys then dd := -dd;
   dd := dd * strtoint(amnt) - toreal(intr);
   plslom := rtostr(dd);
end;

function chkprc;
var op, cl: real;
    bk, sb: boolean;
begin
   op := toreal(o);
   cl := toreal(c);
   bk := (q = 'EUR') or (q = 'GBP');
   sb := (b = 'Buy');
   chkprc := (op >= cl) xor (bk xor sb);
end;

end.