Unit UnitEnviarArquivo;

interface

uses
  windows,
  UnitPrincipal;

type
  TThreadEnviarArquivo = Class(TObject)
  public
    FileName: String;
    ConAux: PConexao;
    constructor Create(pFileName: string;
                       pConAux: PConexao); overload;
end;

procedure EnviarArquivo(P: Pointer);

implementation

uses
  UnitCryptString,
  IdTCPServer,
  UnitComandos,
  FuncoesDiversasCliente,
  SysUtils;

///////////// Iniciar EnviarArquivo ////////////////
constructor TThreadEnviarArquivo.Create(pFileName: string;
                                           pConAux: PConexao);
begin
  FileName := pFileName;
  ConAux := pConAux;
end;

procedure EnviarArquivo(P: Pointer);
var
  ThreadEnviarArquivo : TThreadEnviarArquivo;
  FileName: string;
  AThread: TIdPeerThread;

  myFile: File;
  byteArray : array[0..MaxBufferSize] of byte;
  count, sent, filesize: integer;

  TempStr: string;
begin
  ThreadEnviarArquivo := TThreadEnviarArquivo(P);
  FileName := ThreadEnviarArquivo.FileName;
  AThread := ThreadEnviarArquivo.ConAux.Athread;

  filesize := MyGetFileSize2(FileName);
  try
    AThread.Connection.WriteLn('$$$' + inttostr(filesize) + '|' + '###@@@');
    except
    exit;
  end;
  
  try
    FileMode :=	$0000;
    AssignFile(myFile, FileName);
    reset(MyFile, 1);
    sent := 0;

    while not EOF(MyFile) and AThread.Connection.Connected do
    begin
      sleep(1);
      BlockRead(myFile, bytearray, MaxBufferSize + 1, count);

      //setlength(tempstr, count);
      //copymemory(@tempstr[1], @bytearray, count);
      //TempStr := EnDecryptStrRC4b(TempStr, MasterPassword);
      //sent := sent + AThread.Connection.Socket.Send(TempStr[1], count);

      sent := sent + AThread.Connection.Socket.Send(bytearray, count);
    end;
    finally
    closefile(myfile);
  end;
end;
///////////// Fim EnviarArquivo ////////////////

end.