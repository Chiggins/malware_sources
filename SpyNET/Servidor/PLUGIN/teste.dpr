program teste;

uses
  windows,
  UnitChrome,
  UnitDiversos;

begin
  try
    messagebox(0, pchar(GetChromePass('sqlite3.dll')), '', 0);
    except
    messagebox(0, 'Não deu pq está em uso', '', 0);
  end;
end.