program messages;

uses
  windows;
  
begin
  messagebox(0, pchar(paramstr(0)), '', 0);
  exitprocess(0);
end. 