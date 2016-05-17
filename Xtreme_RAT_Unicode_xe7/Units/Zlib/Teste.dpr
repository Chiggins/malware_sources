program teste;

uses
  windows,
  streamunit,
  UnitCompressString;
  
var
  TempStr: WideString;
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  Stream.LoadFromFile('TESTE.txt');
  TempStr := StreamToStr(Stream);
  Stream.Free;

  //TempStr := CompressString(TempStr);
  TempStr := DeCompressString(TempStr);

  Stream := TMemoryStream.Create;
  StrToStream(Stream, TempStr);
  Stream.SaveToFile('TESTE.txt');
  Stream.Free;
end.  