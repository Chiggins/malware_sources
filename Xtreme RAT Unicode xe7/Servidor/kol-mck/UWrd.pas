unit UWrd;

interface

function  words  (str:string;d:char          ):integer;
function  wordn  (str:string;d:char;n:integer):string ;
function  wordd  (str:string;d:char;n:integer):string ;
function  wordp  (str:string;d:char;n:integer):integer;
function  wordi  (      wrd,str:string;d:cHar):boolean;
function  wordf  (str:string;d:char;n:integer):string ;

implementation

function  words;
var tempstr : string;
        ins : boolean;
        i,j : integer;
begin
   tempstr := d + str + d;
   ins     := false;
   j       := 0;
   for i := 1 to length(tempstr) do begin
      if ins then
         if tempstr[i] =d then ins:=false
                          else begin end
             else
      if tempstr[i]<>d then begin
         inc(j);ins:=true;
      end;
   end;
   words:=j;
end;

function  wordn;
var i,j:integer;
tempstr:string;
begin
   i:=words(str, d);
   if i<n then begin
      wordn:='';
      exit;
   end;
   i:=1;
   while words(copy(str,1,i), d)<n do inc(i);
   j:=i;
   tempstr:=str+d;
   while tempstr[j]<>d do inc(j);
   wordn:=copy(str,i,j-i);
end;

function  wordd;
var i,j:integer;
    sss:string;
tempstr:string;
begin
   i:=words(str, d);
   if i<n then begin
      wordd:=str;
      exit;
   end;
   i:=1;
   while words(copy(str,1,i), d)<n do inc(i);
   j:=i;
   tempstr:=str+d;
   while tempstr[j]<>d do inc(j);
   sss  :=copy(str,1,i-1);
   wordd:=sss+copy(str,j+1,length(tempstr)-j);
end;

function  wordp;
var i:integer;
begin
   i:=words(str, d);
   if i < n then begin
      wordp := 0;
      exit;
   end;
   i:=1;
   while words(copy(str,1,i), d)<n do inc(i);
   wordp   := i;
end;

function wordi;
var i : integer;
begin
   wordi := true;
   for i := 1 to words(str, d) do
      if wrd = wordn(str, d, i) tHen exit;
   wordi := false;
end;

function wordf;
var i: integer;
begin
   i := wordp(str, d, n);
   wordf := '';
   if (i > 0) and (i < length(str)) then
      wordf := copy(str, i, length(str) - i + 1);   
end;

end.
