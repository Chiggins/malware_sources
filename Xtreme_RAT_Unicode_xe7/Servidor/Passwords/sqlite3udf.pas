{
UDF Sqlite3 support v1.0.0
  translation to Pascal by Lukas Gebauer

This is experimental translation. Be patient!
}
unit sqlite3udf;

interface

uses
  sqlite3;

type
  Psqlite3_context = pointer;
  Psqlite3_value = ppchar;

  TxFunc = procedure(sqlite3_context: Psqlite3_context; cArg: integer; ArgV: Psqlite3_value);
  TxStep = procedure(sqlite3_context: Psqlite3_context; cArg: integer; ArgV: Psqlite3_value);
  TxFinal = procedure(sqlite3_context: Psqlite3_context);
{
  void (*xFunc)(sqlite3_context*,int,sqlite3_value**),
  void (*xStep)(sqlite3_context*,int,sqlite3_value**),
  void (*xFinal)(sqlite3_context*)
}

//UDF SQLITE3 support
function sqlite3_create_function(db: TSQLiteDB; functionName: PChar; nArg: integer;
  eTextRep: integer; pUserdata: pointer; xFunc: TxFunc; xStep: TxStep; xFinal: TxFinal
  ): integer; cdecl; external SQLiteDLL name 'sqlite3_create_function';

procedure sqlite3_result_blob(sqlite3_context: Psqlite3_context; value: Pointer;
  n: integer; destroy: pointer); cdecl; external SQLiteDLL name 'sqlite3_result_blob';
procedure sqlite3_result_double(sqlite3_context: Psqlite3_context; value: Double);
  cdecl; external SQLiteDLL name 'sqlite3_result_double';
procedure sqlite3_result_error(sqlite3_context: Psqlite3_context; value: Pchar;
  n: integer); cdecl; external SQLiteDLL name 'sqlite3_result_error';
procedure sqlite3_result_error16(sqlite3_context: Psqlite3_context; value: PWidechar;
  n: integer); cdecl; external SQLiteDLL name 'sqlite3_result_error16';
procedure sqlite3_result_int(sqlite3_context: Psqlite3_context; value: integer);
  cdecl; external SQLiteDLL name 'sqlite3_result_int';
procedure sqlite3_result_int64(sqlite3_context: Psqlite3_context; value: int64);
  cdecl; external SQLiteDLL name 'sqlite3_result_int64';
procedure sqlite3_result_null(sqlite3_context: Psqlite3_context);
  cdecl; external SQLiteDLL name 'sqlite3_result_null';
procedure sqlite3_result_text(sqlite3_context: Psqlite3_context; value: PChar;
  n: integer; destroy: pointer); cdecl; external SQLiteDLL name 'sqlite3_result_text';
procedure sqlite3_result_text16(sqlite3_context: Psqlite3_context; value: PWideChar;
  n: integer; destroy: pointer); cdecl; external SQLiteDLL name 'sqlite3_result_text16';
procedure sqlite3_result_text16be(sqlite3_context: Psqlite3_context; value: PWideChar;
  n: integer; destroy: pointer); cdecl; external SQLiteDLL name 'sqlite3_result_text16be';
procedure sqlite3_result_text16le(sqlite3_context: Psqlite3_context; value: PWideChar;
  n: integer; destroy: pointer); cdecl; external SQLiteDLL name 'sqlite3_result_text16le';
procedure sqlite3_result_value(sqlite3_context: Psqlite3_context; value: Psqlite3_value);
  cdecl; external SQLiteDLL name 'sqlite3_result_value';

{
    void sqlite3_result_blob(sqlite3_context*, const void*, int n, void(*)(void*));
    void sqlite3_result_double(sqlite3_context*, double);
    void sqlite3_result_error(sqlite3_context*, const char*, int);
    void sqlite3_result_error16(sqlite3_context*, const void*, int);
    void sqlite3_result_int(sqlite3_context*, int);
    void sqlite3_result_int64(sqlite3_context*, long long int);
    void sqlite3_result_null(sqlite3_context*);
    void sqlite3_result_text(sqlite3_context*, const char*, int n, void(*)(void*));
    void sqlite3_result_text16(sqlite3_context*, const void*, int n, void(*)(void*));
    void sqlite3_result_text16be(sqlite3_context*, const void*, int n, void(*)(void*));
    void sqlite3_result_text16le(sqlite3_context*, const void*, int n, void(*)(void*));
    void sqlite3_result_value(sqlite3_context*, sqlite3_value*);
}

function sqlite3_value_blob(value: pointer): Pointer;
  cdecl; external SQLiteDLL name 'sqlite3_value_blob';
function sqlite3_value_bytes(value: pointer): integer;
  cdecl; external SQLiteDLL name 'sqlite3_value_bytes';
function sqlite3_value_bytes16(value: pointer): integer;
  cdecl; external SQLiteDLL name 'sqlite3_value_bytes16';
function sqlite3_value_double(value: pointer): double;
  cdecl; external SQLiteDLL name 'sqlite3_value_double';
function sqlite3_value_int(value: pointer): integer;
  cdecl; external SQLiteDLL name 'sqlite3_value_int';
function sqlite3_value_int64(value: pointer): int64;
  cdecl; external SQLiteDLL name 'sqlite3_value_int64';
function sqlite3_value_text(value: pointer): PChar;
  cdecl; external SQLiteDLL name 'sqlite3_value_text';
function sqlite3_value_text16(value: pointer): PWideChar;
  cdecl; external SQLiteDLL name 'sqlite3_value_text16';
function sqlite3_value_text16be(value: pointer): PWideChar;
  cdecl; external SQLiteDLL name 'sqlite3_value_text16be';
function sqlite3_value_text16le(value: pointer): PWideChar;
  cdecl; external SQLiteDLL name 'sqlite3_value_text16le';
function sqlite3_value_type(value: pointer): integer;
  cdecl; external SQLiteDLL name 'sqlite3_value_type';

{    const void *sqlite3_value_blob(sqlite3_value*);
    int sqlite3_value_bytes(sqlite3_value*);
    int sqlite3_value_bytes16(sqlite3_value*);
    double sqlite3_value_double(sqlite3_value*);
    int sqlite3_value_int(sqlite3_value*);
    long long int sqlite3_value_int64(sqlite3_value*);
    const unsigned char *sqlite3_value_text(sqlite3_value*);
    const void *sqlite3_value_text16(sqlite3_value*);
    const void *sqlite3_value_text16be(sqlite3_value*);
    const void *sqlite3_value_text16le(sqlite3_value*);
    int sqlite3_value_type(sqlite3_value*);
}

{
//Sample of usage:
PROCEDURE fn(ctx:pointer;n:integer;args:ppchar);cdecl;
VAR     p : ppchar; theString : string; res:integer;
BEGIN
p         := args;
theString := trim(sqlite3_value_text(p^));

...do something with theString...

sqlite3_result_int(ctx,res);  // < return a number based on string
END;
...
var i:integer;
begin
i := sqlite3_create_function(db3,'myfn',1,SQLITE_UTF8,nil,@fn,nil,nil);
s := 'select myfn(thestring) from theTable;'
...execute statement...
end;
}

implementation

end.
