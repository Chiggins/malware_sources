unit serv;

interface

procedure FreeList(var p : pchar;   s : word);
function  NewEList(var p : pointer; s : word; c : boolean) : pointer;

implementation

procedure FreeList;
var r,
    d : pchar;
begin
   while p <> nil do begin
      r := p;
      d := p + s - 4;
      move(d^, p, 4);
      freeMem(r, s);
   end;
end;

function NextList(p : pchar; s : word) : pointer;
var r,
    d : pchar;
begin
   d := p + s - 4;
   move(d^, r, 4);
   NextList := r;
end;

function NewEList;
var r,
    d : pchar;
    n : pchar;
begin
      if p = Nil then begin
         getmem(p, s);
         NewEList := p;
         r        := p;
         FillChar(r^, s, #0);
      end        else begin
         n := p;
         while NextList(n, s) <> nil do begin
            n := NextList(n, s);
         end;
         getmem(r, s);
         FillChar(r^, s, #0);
         d := n + s - 4;
         move(r, d^, 4);
         if c then begin
            d := r + s - 8;
            move(n, d^, 4);
         end;
         NewEList := r;
      end;
end;

end.
