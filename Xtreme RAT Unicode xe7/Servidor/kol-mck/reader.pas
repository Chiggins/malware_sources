unit reader;

interface

function  compare(_ts, _ms : string) : boolean;
procedure setvar (  vn, vv : string);
function  getvar (      vn : string) : string;
function  parstr                     : string;
procedure setglo (  vn, vv : string);
function  getglo (      vn : string) : string;
function  parse  (      vn : string; al : boolean) : string;
procedure freeglob;

implementation

uses UStr, Serv, UWrd;

type
    trec = record
              name : string[12];
              valu : string[255];
              next : pointer;
           end;

var
    fvar,
    fglo : pointer;
    vrec,
    vglo,
    rrec : ^trec;
    v,
    z    : string;

function compare;
label fail, succ;
var i,
    j,
    n : integer;
   ts,
   ms : string;

procedure freelist;
begin
   vrec := fvar;
   while vrec <> nil do begin
      rrec := vrec;
      vrec := vrec^.next;
      freemem(rrec, sizeof(trec));
   end;
   fvar := nil;
end;

begin
   ts := _ts;
   ms := _ms;
   i := 1;
   j := 1;
   compare := true;
   freelist;
   repeat
      if (i > length(ts)) and (j > length(ms)) then goto succ;
      if (i > length(ts)) or  (j > length(ms)) then goto fail;
      if ts[i] = ms[j] then begin
         inc(i);
         inc(j);
         if j > length(ms) then goto succ;
      end else
      if ts[i] = '?' then begin
         inc(i);
         inc(j);
      end else
      if ts[i] = '*' then begin
         inc(i);
         if i > length(ts) then goto succ;
         z := copy(ts, i, 255);
         if pos('*', z) > 0 then z := copy(z, 1, pos('*', z) - 1);
         if pos('?', z) > 0 then z := copy(z, 1, pos('?', z) - 1);
         if pos('%', z) > 0 then z := copy(z, 1, pos('%', z) - 1);
         while (j <= length(ms)) and (copy(ms, j, length(z)) <> z) do begin
            while (j < length(ms)) and (ms[j] <> ts[i]) do inc(j);
            if j > length(ms) then goto fail;
            if copy(ms, j, length(z)) <> z then inc(j);
         end;
      end else
      if ts[i] = '%' then begin
         inc(i);
         n := i;
         while (i <= length(ts)) and (ts[i] <> '%') do inc(i);
         if i > length(ts) then goto fail;
         v := copy(ts, n, i - n);
         v := upst(v);
         inc(i);
         n := j;
         if i <= length(ts) then begin
            while (j <= length(ms)) and (ms[j] <> ts[i]) do inc(j);
            if j > length(ms) then goto fail;
         end else begin
            j := length(ms) + 1;
         end;
         z := copy(ms, n, j - n);
         if fvar = nil then begin
            getmem(fvar, sizeof(trec));
            vrec := fvar;
         end else begin
            getmem(vrec^.next, sizeof(trec));
            vrec := vrec^.next;
         end;
         fillchar(vrec^, sizeof(trec), #0);
         vrec^.name := v;
         vrec^.valu := z;
         if fglo = nil then begin
            getmem(fglo, sizeof(trec));
            vglo := fglo;
            rrec := fglo;
            fillchar(vglo^, sizeof(trec), #0);
         end else begin
            rrec := fglo;
            while (rrec <> nil) and (rrec^.name <> v) do begin
               vglo := rrec;
               rrec := rrec^.next;
            end;
            if rrec = nil then begin
               getmem(vglo^.next, sizeof(trec));
               vglo := vglo^.next;
               rrec := vglo;
               fillchar(vglo^, sizeof(trec), #0);
            end;
         end;
         rrec^.name := v;
         rrec^.valu := z;
      end else begin
         if (i > 1) and (j > i) then
         if compare(ts, copy(ms, j, length(ms) - j + 1)) then goto succ
                                                         else goto fail
                                else goto fail;
      end;
   until false;
fail:
   compare := false;
   freelist;
   exit;
succ:
   exit;
end;

procedure setvar;
begin
   vglo := fvar;
   while vglo <> Nil do begin
      if vglo^.name = UpSt(vn) then break;
      vglo := vglo^.next;
   end;
   if vglo = Nil then vglo := NewEList(fvar, sizeof(trec), false);
   vglo^.name := UpSt(vn);
   vglo^.valu := vv;
end;

function  getvar;
var
   tv : string;
begin
   getvar := '';
   vrec := fvar;
   tv := vn;
   tv := upst(tv);
   while vrec <> nil do begin
      if vrec^.name = tv then begin
         getvar := vrec^.valu;
         exit;
      end;
      vrec := vrec^.next;
   end;
end;

procedure setglo;
begin
   vglo := fglo;
   while vglo <> Nil do begin
      if vglo^.name = UpSt(vn) then break;
      vglo := vglo^.next;
   end;
   if vglo = Nil then vglo := NewEList(fglo, sizeof(trec), false);
   vglo^.name := UpSt(vn);
   vglo^.valu := vv;
end;

function  getglo;
var
   tv : string;
begin
   getglo := '';
   vglo := fglo;
   tv := vn;
   tv := upst(tv);
   while vglo <> nil do begin
      if vglo^.name = tv then begin
         getglo := vglo^.valu;
         exit;
      end;
      vglo := vglo^.next;
   end;
end;

procedure freeglob;
begin
   vglo := fglo;
   while vglo <> nil do begin
      rrec := vglo;
      vglo := vglo^.next;
      freemem(rrec, sizeof(trec));
   end;
   fglo := nil;
end;

function parstr;
var
   tv : string;
begin
   tv := '';
   vrec := fvar;
   while vrec <> nil do begin
      tv := tv + ' ' + vrec^.valu;
      vrec := vrec^.next;
   end;
   parstr := tv;
end;

function parse;
var i,
    p : integer;
    s : string;
   rs : string;
begin
   s := '';
   i := 0;
   repeat
      inc(i);
      rs := wordn(vn, '%', i + 1);
      rs := getglo(rs);
      s  := s + wordn(vn, '%', i);
      p  := wordp(vn, '%', i + 1);
      if p > 0 then begin
         if al then s  := copy(s, 1, p - 2);
         if al then s  := s + space(p - 2 - length(s));
      end;
      s  := s + rs;
      if rs <> '' then inc(i);
   until i > words(vn, '%');
   parse := s;
end;

begin
   fvar := nil;
   fglo := nil;
end.
