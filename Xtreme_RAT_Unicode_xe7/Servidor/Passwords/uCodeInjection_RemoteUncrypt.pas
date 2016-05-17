//*****************************************//
// Carlo Pasolini                          //
// http://pasotech.altervista.org          //
// email: cdpasop@hotmail.it               //
//*****************************************//
//http://pasotech.altervista.org/delphi/articolo95.htm
unit uCodeInjection_RemoteUncrypt;

interface

uses
  Windows;

function RemoteUncrypt(PID: Cardinal; Data: Pointer; DataSize: Cardinal; NamedPipeName: PAnsiChar; var outValue: Cardinal; var codError: Cardinal; synch: Boolean): Boolean;

implementation

uses
  uCodeInjection, uDecls;
  //, uUtils;

type
  PDATA_BLOB = ^DATA_BLOB;
  DATA_BLOB = record
    cbData: Cardinal;
    pbData: PByte;
  end;

  PCRYPTPROTECT_PROMPTSTRUCT = ^CRYPTPROTECT_PROMPTSTRUCT;
  CRYPTPROTECT_PROMPTSTRUCT = packed record
    cbSize: Cardinal;             // Size of this structure (bytes).
    dwPromptFlags: Cardinal;      // Prompt flags.
    hwndApp: Cardinal;            // Handle to parent window.
    szPrompt: PWideChar           // Prompt to display to user.
  end;

function RemoteUncrypt(PID: Cardinal; //PID del processo remoto
                           //...; //dichiarazione di tutti i parametri che vogliamo
                           Data: Pointer;
                           DataSize: Cardinal;
                           NamedPipeName: PAnsiChar;
                           var outValue: Cardinal; //valore importante ottenuto dalla funzione remota
                           var codError: Cardinal; //errore riscontrato dalla funzione remota
                           synch: Boolean): Boolean; //esecuzione sincrona del thread remoto
type
  TRemoteUncryptData = record
    errorcod: Cardinal; //codice di errore rilevato nella funzione remota
    output: Cardinal; //risultato significativo nella funzione remota

    //Indirizzi delle API usate: elenco puntatori a funzioni; N.B. rigorosamente stdcall
    //Es. pLoadLibraryA: function(pLibFileName: PAnsiChar): Cardinal; stdcall;
    pExitThread: procedure (dwExitCode: Cardinal); stdcall; //API obbligatoria
    pGetLastError: function(): Cardinal; stdcall;
    pCreateFileA: function(
                      lpFileName: PAnsiChar;
                      dwDesiredAccess,
                      dwShareMode: Cardinal;
                      lpSecurityAttributes: Pointer;
                      dwCreationDisposition,
                      dwFlagsAndAttributes: Cardinal;
                      hTemplateFile: Cardinal
                      ): Cardinal; stdcall;

    pWriteFile: function(
                     hFile: Cardinal;
                     const Buffer;
                     //Buffer: Pointer;
                     nNumberOfBytesToWrite: Cardinal;
                     var lpNumberOfBytesWritten: Cardinal;
                     lpOverlapped: Pointer
                     ): Boolean; stdcall;

    pCloseHandle: function(
                      hnd: Cardinal
                      ): Boolean; stdcall;

    pCryptUnprotectData: function(
              pDataIn: PDATA_BLOB;
              var ppszDataDescr: PWideChar;
              pOptionalEntropy: PDATA_BLOB;
              pvReserved: Pointer;
              pPromptStruct: PCRYPTPROTECT_PROMPTSTRUCT;
              dwFlags: Cardinal;
              var pDataOut: DATA_BLOB
              ): Boolean; stdcall;

    pLocalFree: function(
        hMem: Pointer
        ): Cardinal;

    //Puntatori a dati; Es. tutte le stringhe vanno messe qui dentro
    //Es. pNomeDll: Pointer;
    pData: Pointer;
    pNamedPipeName: Pointer;
    fDataSize: Cardinal;

  end;
var

  hProcess: Cardinal; //handle al processo remoto
  RemoteUncryptData: TRemoteUncryptData;
  pRemoteUncryptData: Pointer; //indirizzo del record nello spazio di memoria del processo remoto
  pRemoteUncryptThread: Pointer; //indirizzo della funzione del thread nello spazio di memoria del processo remoto
  output_value: Cardinal;
  error_code: Cardinal;

  //indirizzi di base delle dll che ci interessano, nello spazio di memoria del processo remoto
  hKernel32, hCrypt32: Cardinal;

  FuncAddr: Cardinal;

  functionSize, parameterSize: Cardinal;

  procedure RemoteUncryptThread(lpParameter: pointer); stdcall;
  //qui posso definire delle variabili locali
  var
    i: Cardinal;

    //interazione col named pipe
    PipeKeys: Cardinal;
    BytesWritten: Cardinal;
    sMessage: String;
    Data_in, Data_out: DATA_BLOB;
    szDescription: PWideChar;
    //
  begin
    with TRemoteUncryptData(lpParameter^) do
      begin
        //implementazione: tutte le API vengono chiamate tramite i puntatori nel record
        //apriamo il named pipe creato dal processo chiamante
        PipeKeys := pCreateFileA(pNamedPipeName,
                                 GENERIC_WRITE,
                                 0,
                                 nil,
                                 //CREATE_NEW
                                 OPEN_EXISTING,
                                 FILE_ATTRIBUTE_NORMAL,
                                 0);

        if (PipeKeys = INVALID_HANDLE_VALUE) then
          begin
            errorcod := pGetLastError;
            pExitThread(0);
          end;

        //verifico se i dati sono stati copiati correttamente nello spazio di memoria del processo remoto
        //BytesWritten := 0;
        //pWriteFile(PipeKeys, pData^, fDataSize, BytesWritten, nil);
        //pWriteFile(PipeKeys, pNamedPipeName^, 18, BytesWritten, nil);

        Data_in.cbData := fDataSize;
        Data_in.pbData := pData;

        Data_out.cbData := 0;
        Data_out.pbData := nil;

        if not pCryptUnprotectData(@Data_in, szDescription, nil, nil, nil, 0, Data_out) then
          begin
            pCloseHandle(PipeKeys);
            pExitThread(0);
          end;

        //scrivo il buffer decodificato sul named pipe
        //pWriteFile(PipeKeys, Data_in.pbData, Data_in.cbData, BytesWritten, nil);
        //pWriteFile(PipeKeys, pData, fDataSize, BytesWritten, nil);
        pWriteFile(PipeKeys, (Data_out.pbData)^, Data_out.cbData, BytesWritten, nil);

        pLocalFree(@Data_out);

        pCloseHandle(PipeKeys);

        pExitThread(1);
        //N.B. chiamare sempre pExitCodeThread per definire il codice di uscita del thread
        //Es. pExitCodeThread(1) significa successo
        //    pExitCodeThread(0) significa fallimento
      end;
  end;

  //dealloco la memoria in remoto
  function RemoteUncryptUnloadData(): Boolean;
  begin
    Result := False;

    with RemoteUncryptData do
      begin
        //chiamo UnloadData su tutti i puntatori a dati inclusi nel record
        UnloadData(hProcess, pData);
        UnloadData(hProcess, pNamedPipeName);
      end;
    //deallocazione spazio per il parametro
    UnloadData(hProcess, pRemoteUncryptData);
    //deallocazione spazio per la funzione
    UnloadData(hProcess, pRemoteUncryptThread);

    Result := True;
  end;

  //definisco i valori dei campi del record e copio i dati in remoto
  function RemoteUncryptInjectData(): Boolean;
  begin

    Result := False;

    try

      //inizializzazione valori campi del record:
      with RemoteUncryptData do
        begin
          errorcod := 0;
          output := 0;

          fDataSize := DataSize;

          //determino l'indirizzo di base di caricamento di kernel32.dll e advapi32.dll nello spazio
          //di memoria del processo remoto
          if not RemoteGetModuleHandle(
                          hProcess,
                          'kernel32.dll',
                          hKernel32
                          ) then
            begin
              Exit;
            end;
          if not RemoteGetModuleHandle(
                          hProcess,
                          'crypt32.dll',
                          hCrypt32
                          ) then
            begin
              Exit;
            end;

          //assegno i valori ai puntatori a funzione (tramite RemoteGetProcAddress)
          if not RemoteGetProcAddress(
                          hProcess,
                          hKernel32,
                          'ExitThread',
                          FuncAddr
                          ) then
            begin
              Exit;
            end;
          pExitThread := Pointer(FuncAddr);  

          if not RemoteGetProcAddress(
                          hProcess,
                          hKernel32,
                          'GetLastError',
                          FuncAddr
                          ) then
            begin
              Exit;
            end;
          pGetLastError := Pointer(FuncAddr);

          if not RemoteGetProcAddress(
                          hProcess,
                          hKernel32,
                          'CreateFileA',
                          FuncAddr
                          ) then
            begin
              Exit;
            end;
          pCreateFileA := Pointer(FuncAddr);

          if not RemoteGetProcAddress(
                          hProcess,
                          hKernel32,
                          'WriteFile',
                          FuncAddr
                          ) then
            begin
              Exit;
            end;
          pWriteFile := Pointer(FuncAddr);

          if not RemoteGetProcAddress(
                          hProcess,
                          hKernel32,
                          'CloseHandle',
                          FuncAddr
                          ) then
            begin
              Exit;
            end;
          pCloseHandle := Pointer(FuncAddr);

          if not RemoteGetProcAddress(
                          hProcess,
                          hKernel32,
                          'LocalFree',
                          FuncAddr
                          ) then
            begin
              Exit;
            end;
          pLocalFree := Pointer(FuncAddr);

          if not RemoteGetProcAddress(
                          hProcess,
                          hCrypt32,
                          'CryptUnprotectData',
                          FuncAddr
                          ) then
            begin
              Exit;
            end;
          pCryptUnprotectData := Pointer(FuncAddr);

          //assegno i valori ai puntatori ai dati (tramite InjectData);
          //N.B. se una InjectData ritorna False allora bisogna chiamare Exit
          //ScriviLog(DumpData(Data, DataSize));
          if not InjectData(hProcess,
                            Data,
                            DataSize,
                            False,
                            pData) then
            begin
              Exit;
            end;
          if not InjectData(hProcess,
                            NamedPipeName,
                            Length(NamedPipeName),
                            False,
                            pNamedPipeName) then
            begin
              Exit;
            end;
        end;

      //copio il parametro
      parameterSize := SizeOf(RemoteUncryptData);
      if not InjectData(hProcess,
                        @RemoteUncryptData,
                        parameterSize,
                        False,
                        pRemoteUncryptData) then
        begin
          Exit;
        end;
      //copio la funzione
      functionSize := SizeOfProc(@RemoteUncryptThread);
      if not InjectData(hProcess,
                        @RemoteUncryptThread,
                        functionSize,
                        True,
                        pRemoteUncryptThread) then
        begin
          Exit;
        end;

      Result := True;

    finally

      if not Result then
        begin
          RemoteUncryptUnloadData;
        end;

    end;

  end;

begin

  //inizializzo a zero le variabili locali
  hProcess := 0;
  pRemoteUncryptData := nil;
  pRemoteUncryptThread := nil;
  output_value := 0;
  error_code := 0;

  try

    //ScriviLog(DumpData(Data, DataSize));

    hProcess := OpenProcessEx(PROCESS_CREATE_THREAD +
                            PROCESS_QUERY_INFORMATION +
                            PROCESS_VM_OPERATION +
                            PROCESS_VM_WRITE +
                            PROCESS_VM_READ,
                            False,
                            PID
                            );

    if hProcess = 0 then
      begin
        //ErrStr('OpenProcess');
        Exit;
      end;

    if not RemoteUncryptInjectData() then
      Exit;

    if not InjectThread(hProcess,
                        pRemoteUncryptThread,
                        pRemoteUncryptData,
                        output_value,
                        error_code,
                        synch) then
      Exit;

    //output_value e error_code sono stati inizializzati a 0.
    //sono stati modificati dalla InjectThread solo se synch = true;
    //se synch=false sono rimasti uguali a zero
    outvalue := output_value;
    codError := error_code;

    Result := True;

  finally
    if synch or (not Result) then
      begin
        RemoteUncryptUnloadData;
      end;

    if hProcess <> 0 then
      begin
        if not CloseHandle(hProcess) then
          begin
            //ErrStr('CloseHandle');
          end;
      end;

  end;
end;

end.
