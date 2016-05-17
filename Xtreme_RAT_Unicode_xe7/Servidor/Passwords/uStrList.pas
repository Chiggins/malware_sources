unit uStrList;

interface

type
  TStrList = class(TObject)
  private
    vList  : array of string;
  public
    Count : Integer;
    constructor Create;
    procedure   Add(Text:string);
    function    Strings(Index:Integer) : string;
  END;

implementation

constructor TStrList.Create;
begin
  Count:=0;
  SetLength(vList,Count+1);
end;

procedure TStrList.Add(Text:string);
begin
  SetLength(vList,Count+1);
  vList[Count]:=Text;
  Inc(Count);
end;

function TStrList.Strings(Index:Integer) : string;
begin
  Result:=vList[Index];
end;

END.
