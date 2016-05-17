//*****************************************//
// Carlo Pasolini                          //
// http://pasotech.altervista.org          //
// email: cdpasop@hotmail.it               //
//*****************************************//
//this is the CodeInjection Unit: it supplies the kernel of Code Injection
//implementation
unit uCodeInjection;

interface

uses
  Windows;//, KOL;//, SysUtils, Classes;

function SizeOfProc(pAddr: pointer): Cardinal;
function OpenProcessEx(dwDesiredAccess: Cardinal; bInheritableHandle: LongBool; dwProcessId: Cardinal): Cardinal;
function RemoteGetModuleHandle(hProcess: Cardinal; nomeModulo: PAnsiChar; var BaseAddr: Cardinal): Boolean;
function RemoteGetProcAddress(hProcess: Cardinal; hModule: Cardinal; ProcName: PAnsiChar; var FuncAddress: Cardinal): Boolean;
function InjectData(hProcess: Cardinal; localData: Pointer; DataSize: Cardinal; Esecuzione: Boolean; var remoteData: Pointer): Boolean;
function UnloadData(hProcess: Cardinal; remoteData: Pointer): Boolean;
function InjectThread(hProcess: Cardinal; remoteFunction: Pointer; remoteParameter: Pointer; var outputValue: Cardinal; var errorCode: Cardinal; Synch: Boolean): Boolean;


implementation

uses
  uDecls;//, uUtils;

function Int2Str(I: integer): string;
begin
  Str(I, Result);
end;

function Str2Int(S: string): integer;
begin
  Val(S, Result, Result);
end;

//SizeOfProc: this function returns the Size in bytes of a function
//whose implementation begins at address "pAddr"
function SizeOfProc(pAddr: pointer): Cardinal;
var
  dwSize: Cardinal;
begin
  dwSize := 0;
  repeat
    inc(dwSize);
  until PByte(Cardinal(pAddr)+dwSize-1)^ = $C3;
  Result := dwSize;
end;

//ModifyPrivilege: this function enables (fEnable = true) or disable (fEnable = false)
//a Privilege
//http://pasotech.altervista.org/delphi/articolo23.htm
//(nell'articolo l'implementazione è più elementare; quella che viene presentata
//di seguito invece è completa di tutto
function ModificaPrivilegio(szPrivilege: pChar; fEnable: Boolean): Boolean;
var
  NewState: TTokenPrivileges;
  luid: TLargeInteger;
  hToken: Cardinal;
  ReturnLength: Cardinal;
begin

  Result := False;
  hToken := 0;

  try

    if not OpenThreadToken(
                           GetCurrentThread(),
                           TOKEN_ADJUST_PRIVILEGES,
                           False,
                           hToken) then
      begin
        if GetLastError = ERROR_NO_TOKEN then
          begin
            if not OpenProcessToken(
                                    GetCurrentProcess(),
                                    TOKEN_ADJUST_PRIVILEGES,
                                    hToken) then
              begin
                //ErrStr('OpenProcessExToken');
                Exit;
              end;
          end
        else
          begin
            //ErrStr('OpenThreadToken');
            Exit;
          end;
      end;

    //ricavo il LUID (Locally Unique Identifier) corrispondente al privilegio
    //specificato: si tratta in sostanza di un identificativo univoco del privilegio;
    //varia da sessione a sessione ed anche tra un riavvio e l' altro del sistema
    if not LookupPrivilegeValue(nil, szPrivilege, luid) then
      begin
        //ErrStr('LookupPrivilegeValue');
        Exit;
      end;

    //lavoro su NewState (di tipo TTokenPrivileges). Rappresenta un elenco di privilegi;
    //nel caso specifico conterrà un solo privilegio (ProvilegeCount = 1). L' arrary
    //Privileges contiene oggetti con 2 campi: il luid del privilegio (Luid) ed
    //il livello di abilitazione del medesimo (Attributes)
    NewState.PrivilegeCount := 1;
    NewState.Privileges[0].Luid := luid;
    if fEnable then    //abilitiamo il privilegio
      NewState.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
    else //disabilitiamo il privilegio
      NewState.Privileges[0].Attributes := 0;

    //eseguiamo la modifica sullo stato di abilitazione del privilegio
    //nel contesto del token di accesso aperto
    if not AdjustTokenPrivileges(
                                hToken,
                                FALSE,
                                NewState,
                                sizeof(NewState),
                                nil,
                                ReturnLength) then
      begin
        //ErrStr('AdjustTokenPrivileges');
        Exit;
      end;

    Result := True;

  finally

    //chiudo l' handle al token di accesso aperto
    if hToken <> 0 then
     begin
       if not CloseHandle(hToken) then
         begin
           //ErrStr('CloseHandle');
         end;
     end;

  end;

end;

//Variante dell' api win32 OpenProcess: se la OpenProcess fallisce, allora tenta
//di abilitare il privilegio di debug ed in caso di successo richiama la OpenProcess
function OpenProcessEx(dwDesiredAccess: Cardinal; bInheritableHandle: LongBool; dwProcessId: Cardinal): Cardinal;
var
  hProcess: Cardinal;
begin
  hProcess := OpenProcess(dwDesiredAccess, bInheritableHandle, dwProcessId); //provo ad ottenere un handle al processo
  if hProcess = 0 then //se non ci riesco provo ad assegnare il privilegio di debug
    begin
      if ModificaPrivilegio('SeDebugPrivilege', True) then
        begin
          hProcess := OpenProcess(dwDesiredAccess, bInheritableHandle, dwProcessId);
        end;
    end;
  result := hProcess;
end;

//Restituisce l'indirizzo del Process Environment Block
//N.B. il PEB si trova sempre all'indirizzo 7ffdf000 (Vista escluso)
//http://pasotech.altervista.org/delphi/articolo81.htm
function GetPEBptr(
                   hProcess: Cardinal; //handle del processo
                   var addr: Cardinal //indirizzo del PEB
                   ): Boolean;
type
  TProcessBasicInformation = record
    ExitStatus: Integer;
    PebBaseAddress: Cardinal;
    AffinityMask: Integer;
    BasePriority: Integer;
    UniqueProcessID: Integer;
    InheritedFromUniqueProcessID: Integer;
  end;
var
  ProcInfo: TProcessBasicInformation;
  status: Integer;
begin
  result := False;
  //prelevo le informazioni di base relative al processo
  status := NtQueryInformationProcess(hProcess,
                                      0,
                                      @ProcInfo,
                                      SizeOf(TProcessBasicInformation),
                                      nil);
  if status <> 0 then
    begin
      //ErrStrNative('NtQueryInformationProcess', status);
      Exit;
    end;
  addr := ProcInfo.PebBaseAddress;
  Result := True;
end;

//restituisce l'indirizzo dell' LDR
//http://pasotech.altervista.org/delphi/articolo81.htm
function GetPebLdrData(
                       hProcess: Cardinal; //handle del processo
                       var addr: Cardinal //indirizzo del Loader Data
                       ): Boolean;
var
  PEBptr: Cardinal;
  BytesRead: dword;
begin
  Result := False;
  if not GetPEBptr(hProcess, PEBptr) then
    begin
      Exit;
    end;
  if not ReadProcessMemory(
                           hProcess,
                           pointer(PEBptr + 12),
                           @addr,
                           4,
                           BytesRead
                           ) then
    begin
      //ErrStr('ReadProcessMemory');
      Exit;
    end;
  result := True;
end;

//GetModuleHandle eseguita su un processo remoto
//http://pasotech.altervista.org/delphi/articolo81.htm
function RemoteGetModuleHandle(
               hProcess: Cardinal; //in: handle al processo
               nomeModulo: PAnsiChar; //in: nome del modulo
               var BaseAddr: Cardinal //out: indirizzo di base
               ): Boolean;
var
  pPeb_ldr_data: Cardinal;
  LdrData: PEB_LDR_DATA;
  LdrModule: LDR_MODULE;
  dwSize: Cardinal;
  readAddr, readAddrHead: Pointer;
  BaseDllName: PWideChar;

begin

  result := False;

  //verifica sui valori dei parametri
  if (hProcess = 0) or
     (PAnsiChar(NomeModulo) = nil) then
    begin
      Exit;
    end;

  if not GetPebLdrData(
              hProcess,
              pPeb_ldr_data
              ) then
    begin
      Exit;
    end;

	//prelevo PEB_LDR_DATA
	if not ReadProcessMemory(
             hProcess,
             Pointer(pPeb_ldr_data),
             @LdrData,
             sizeof(LdrData),
             dwSize
             ) then
    begin
      //ErrStr('ReadProcessMemory');
      Exit;
    end;

  readAddrHead := Pointer(pPeb_ldr_data + 12);
  readAddr := Pointer(LdrData.InLoadOrderModuleList.Flink);

  repeat

    //
    readAddr := Pointer(Cardinal(readAddr));

    //estraggo il modulo
    if not ReadProcessMemory(
                       hProcess,
                       readAddr,
                       @LdrModule,
                       sizeof(LdrModule),
                       dwSize
                       ) then
      begin
        //ErrStr('ReadProcessMemory');
        Exit;
      end;

    //leggo il nome della DLL
    GetMem(BaseDllName, LdrModule.BaseDllName.MaximumLength);
		if ReadProcessMemory(
            hProcess,
            LdrModule.BaseDllName.Buffer,
            BaseDllName,
            LdrModule.BaseDllName.MaximumLength,
            dwSize
            ) then
      begin
        if lstrcmpiA(
                  nomeModulo,
                  PAnsiChar(WideCharToString(BaseDllName))
                  ) = 0 then
          begin
            BaseAddr := LdrModule.DllBase;
            Result := True;
            Break;
          end;
      end;

    FreeMem(BaseDllName);

		//* passo al successivo LDR_MODULE */
    readAddr := Pointer(LdrModule.InLoadOrderLinks.Flink);
    //
	until readAddr = readAddrHead;

end;

//GetProcAddress eseguita su un processo remoto; il primo parametro
//è l'handle al processo remoto, il secondo ed il terzo corrispondono ai 2
//parametri di GetProcAddress mentre il quarto è il risultato.
//http://pasotech.altervista.org/delphi/articolo82.htm
function RemoteGetProcAddress(
             //in: handle al processo
             hProcess: Cardinal;
             //in: Indirizzo di base del modulo (ottenuto con RemoteGetModuleHandle)
             hModule: Cardinal;
             //in: puntatore ad una stringa che definisce il nome della funzione o un
             //valore intero positivo minore di FFFF nel caso si voglia specificare
             //l'Ordinal della funzione (è lo stesso significato del secondo parametro
             //dell' api win32 GetProcAddress)
             ProcName: PAnsiChar;
             //out: risultato
             var FuncAddress: Cardinal): Boolean;
var
  DosHeader          : TImageDosHeader;  //Dos Header
  NtHeaders           : TImageNtHeaders; //PE Header
  ExportDirectory    : TImageExportDirectory; //Export Directory
  BytesRead: Cardinal; //var per ReadProcessMemory

  //estremo inferiore e superiore della Export Directory
  ExportDataDirectoryLow, ExportDataDirectoryHigh: cardinal;

  //valore Base di IMAGE_EXPORT_DIRECTORY: valore base degli Ordinal
  BaseOrdinal: Cardinal;

  //
  NumberOfFunctions: Cardinal;
  NumberOfNames: Cardinal;

  //puntatori ai 3 array
  First_AddressOfFunctions: Cardinal;
  First_AddressOfNames: Cardinal;
  First_AddressOfNameOrdinals: Cardinal;

  Actual_AddressOfFunctions: Cardinal;
  Actual_AddressOfNames: Cardinal;
  Actual_AddressOfNameOrdinals: Cardinal;
  //

  //indice della funzione nell'array puntato da
  //IMAGE_EXPORT_DIRECTORY.AddressOfFunctions:
  //l'elemento dell'array che si trova in questa
  //posizione contiene l'RVA della funzione
  FunctionIndex: Cardinal;

  //RVA presente in un elemento dell'array puntato
  //da IMAGE_EXPORT_DIRECTORY.AddressOfNames
  FunctionNameRVA: Cardinal;

  //nome puntato dall'RVA presente in un
  //elemento dell'array puntato da
  //IMAGE_EXPORT_DIRECTORY.AddressOfNames
  FunctionName: PAnsiChar;

  FunctionNameFound: Boolean;

  //RVA della funzione che cerchiamo: è presente
  //in un elemento dell'array puntato da
  //IMAGE_EXPORT_DIRECTORY.AddressOfFunctions
  FunctionRVA: Cardinal;

  //Forwarding
  FunctionForwardName: PAnsiChar;

  ForwardPuntoPos: Cardinal;

  FunctionForward_ModuleName: string;
  FunctionForward_FunctionName: string;
  FunctionForward_FunctionOrdinal: Word;
  FunctionForwardByOrdinal: Boolean;
  FunctionForward: Pointer;

  FunctionForward_ModuleBaseAddr: Cardinal;
  FunctionForward_FunctionAddr: Cardinal;
  //

  i: Cardinal;

begin

  Result := False;

  //verifica sui valori dei parametri
  if (hProcess = 0) or
     (ProcName = nil) then
    begin
      Exit;
    end;

  try

    //inizializzo le variabili che prenderò poi
    //in esame nel blocco finally
    FunctionName := nil;
    FunctionForwardName := nil;

    //prelevo il Dos Header
    if not ReadProcessMemory(
               hProcess,
               Pointer(hModule),
               @DosHeader,
               sizeof(DosHeader),
               BytesRead
               ) then
      begin
        //ErrStr('ReadProcessMemory');
        Exit;
      end;
    //verifica della validità
    if (DosHeader.e_magic <> IMAGE_DOS_SIGNATURE) then
      Exit;

    //prelevo il PE Header
    if not ReadProcessMemory(
               hProcess,
               Pointer(hModule + DosHeader._lfanew),
               @NtHeaders,
               sizeof(NtHeaders),
               BytesRead
               ) then
      begin
        //ErrStr('ReadProcessMemory');
        Exit;
      end;
    //verifica della validità
    if (NtHeaders.Signature <> IMAGE_NT_SIGNATURE) then
      Exit;

    //se il modulo non ha la directory di Export allora esco
    //valuto l' RVA della directory di export
    if NTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress = 0 then
      Exit;

    //calcolo il range di definizione della Export Directory
    //mi servirà per valutare se l'RVA di una funzione punta alla definizione
    //della funzione (valore esterno all'intervallo) oppure punta ad una stringa
    //del tipo <nome_dll>.<nome_funzione> (valore interno all'intervallo)
    with NTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT] do
      begin
        ExportDataDirectoryLow := VirtualAddress;
        ExportDataDirectoryHigh := VirtualAddress + Size;
      end;

    //prelevo la Export Directory
    if not ReadProcessMemory(
               hProcess,
               Pointer(hModule + ExportDataDirectoryLow),
               @ExportDirectory,
               sizeof(ExportDirectory),
               BytesRead
               ) then
      begin
        //ErrStr('ReadProcessMemory');
        Exit;
      end;

    //Determino il valore base degli Ordinal
    BaseOrdinal := ExportDirectory.Base;

    //
    NumberOfFunctions := ExportDirectory.NumberOfFunctions;
    NumberOfNames := ExportDirectory.NumberOfNames;

    First_AddressOfFunctions := hModule +
                 Cardinal(ExportDirectory.AddressOfFunctions);
    First_AddressOfNames := hModule +
                 Cardinal(ExportDirectory.AddressOfNames);
    First_AddressOfNameOrdinals := hModule +
                 Cardinal(ExportDirectory.AddressOfNameOrdinals);

    //allocazione di memoria per puntatori
    //che riceveranno stringhe di caratteri
    GetMem(FunctionName, 100);
    GetMem(FunctionForwardName, 100);

    FunctionIndex := 0;
    if Cardinal(ProcName) <= $FFFF then
    //ho passato l'Ordinal della funzione
      begin
        FunctionIndex := Cardinal(ProcName) - BaseOrdinal;
        //verifico di aver passato un Ordinal valido
        if (FunctionIndex < 0) or
           (FunctionIndex > NumberOfFunctions) then
          Exit;
      end
    else
      //ho passato il puntatore ad una stringa
      //che rappresenta il nome della funzione
      begin
        //scanno l'array puntato da IMAGE_EXPORT_DIRECTORY.AddressOfNames
        //che contiene i nomi delle funzioni esportate con associato un nome;
        //ogni elemento dell'array è 4 byte (è infatti l'RVA del nome della funzione)
        FunctionNameFound := False;
        for i := 0 to NumberOfNames - 1 do {for each export do}
          begin
            Actual_AddressOfNames := First_AddressOfNames + SizeOf(Cardinal) * i;

            //prelevo l'RVA del nome: FunctionNameRVA
            ReadProcessMemory(
                hProcess,
                Pointer(Actual_AddressOfNames) ,
                @FunctionNameRVA,
                4,
                BytesRead);

            //prelevo il nome: FunctionName
            ReadProcessMemory(
                hProcess,
                Pointer(hModule + FunctionNameRVA) ,
                FunctionName,
                100,
                BytesRead
                );

            //vado a vedere se il nome che ho
            //trovato equivale a quello che cerco
            if lstrcmpiA(FunctionName, ProcName) = 0 then
              begin
                //vado nell'array puntato da IMAGE_EXPORT_DIRECTORY.AddressOfNameOrdinals:
                //l'elemento di posizione i contiene l'indice della funzione nell'array
                //puntato da IMAGE_EXPORT_DIRECTORY.AddressOfFunctions
                Actual_AddressOfNameOrdinals := First_AddressOfNameOrdinals + SizeOf(Word) * i;

                //prelevo l'indice: FunctionIndex
                ReadProcessMemory(
                    hProcess,
                    Pointer(Actual_AddressOfNameOrdinals) ,
                    @FunctionIndex,
                    2,
                    BytesRead
                    );
                FunctionNameFound := True;
                Break;
              end;
          end;
        //verifico di aver trovato il nome specificato tra i nomi di funzione
        //in caso contrario esco
        if not FunctionNameFound then
          Exit;
      end;

    //Perfetto, ho ottenuto l'indice nell'array puntato
    //da IMAGE_EXPORT_DIRECTORY.AddressOfFunctions; a questo
    //punto posso prelevare l'RVA della funzione

    Actual_AddressOfFunctions := First_AddressOfFunctions + SizeOf(Cardinal) * FunctionIndex;

    //prelevo l'RVA
    ReadProcessMemory(
        hProcess,
        Pointer(Actual_AddressOfFunctions) ,
        @FunctionRVA,
        4,
        BytesRead
        );

    //Bene: ho l'RVA della funzione; devo ora vedere se
    //rientra nella Export Directory: in tal caso punta
    //ad una stringa del tipo <nome_dll>.<nome_funzione> o
    //<nome_dll>.#Ordinal ossia si è di fronte ad un
    //Forwarding e dovremo chiamare RemoteGetProcAddress
    //su questi nuovi valori

    if (FunctionRVA > ExportDataDirectoryLow) and
       (FunctionRVA <= ExportDataDirectoryHigh) then
      //questo è un forwarding
      begin
        //prelevo la stringa modello <nome_dll>.<nome_funzione> o
        //<nome_dll>.#Ordinal
        ReadProcessMemory(
            hProcess,
            Pointer(hModule + FunctionRVA) ,
            FunctionForwardName,
            100,
            BytesRead
            );

        //estraggo nome del modulo e della funzione
        ForwardPuntoPos := Posex('.', FunctionForwardName);

        if (ForwardPuntoPos > 0) then
          begin
            FunctionForward_ModuleName := Copy(
                                            FunctionForwardName,
                                            1,
                                            ForwardPuntoPos - 1
                                            ) + '.dll';
            FunctionForward_FunctionName := Copy(
                                              FunctionForwardName,
                                              ForwardPuntoPos + 1,
                                              Length(FunctionForwardName)
                                              );
            //Vado a vedere se FunctionForward_FunctionName è del tipo #Ordinal
            //in tal caso significa che la funzione a cui si punta è definita
            //tramite il suo Ordinal
            FunctionForwardByOrdinal := False;
            if string(FunctionForward_FunctionName)[1] = '#' then
              begin
                FunctionForwardByOrdinal := True;
                FunctionForward_FunctionOrdinal := Str2Int(Copy(
                                         FunctionForward_FunctionName,
                                         2,
                                         Length(FunctionForward_FunctionName)
                                         ));
              end;

            //vado a rieseguire GetRemoteProcAddress sui valori di Forwarding

            //prima di tutto calcolo il base address del nuovo modulo:
            //deve esistere per forza, però non si sa mai, sempre meglio
            //gestire il caso in cui la funzione RemoteGetModuleHandle
            //per qualche motivo fallisce
            if not RemoteGetModuleHandle(
                         hProcess,
                         PAnsiChar(FunctionForward_ModuleName),
                         FunctionForward_ModuleBaseAddr) then
              Exit;

            //una volta trovato il base address del modulo, chiamo
            //RemoteGetProcAddress
            if FunctionForwardByOrdinal then
              //<nome_dll>.#Ordinal
              FunctionForward := Pointer(FunctionForward_FunctionOrdinal)
            else
              //<nome_dll>.<nome_funzione>
              FunctionForward := PAnsiChar(FunctionForward_FunctionName);

            if not RemoteGetProcAddress(
                         hProcess,
                         FunctionForward_ModuleBaseAddr,
                         FunctionForward,
                         FunctionForward_FunctionAddr
                         ) then
              Exit;

            //se tutto è andato OK
            FuncAddress := FunctionForward_FunctionAddr;

          end;
      end
    else  //non si tratta di un Forwarding
      begin
        //sommo all'RVA della funzione il Base Address del modulo:
        //in questo modo ottengo il Virtual Address della funzione
        //ossia il risultato finale
        FuncAddress := hModule + FunctionRVA;

      end;

    Result := True;

  finally
    if FunctionName <> nil then
      FreeMem(Pointer(FunctionName));
    if FunctionForwardName <> nil then
      FreeMem(Pointer(FunctionForwardName));
  end;
end;

//mappa la sequenza di byte che inizia all'indirizzo localData e di dimensione
//pari a DataSize, nello spazio di memoria del processo specificato dall'handle
//hProcess
function InjectData(
             hProcess: Cardinal; //in: handle al processo remoto
             localData: Pointer; //in: indirizzo della sequenza di byte
             DataSize: Cardinal; //in: dimensione della sequenza di byte
             Esecuzione: Boolean;//in: specifica se il dato copiato verrà eseguito;
             //ad esempio se si tratta di una funzione allora andrà settato a True,
             //se si tratta invece dei parametri della funzione andrà settato a
             //False
             var remoteData: Pointer //out: puntatore al dato nel processo remoto
             ): Boolean;
var
  BytesWritten: Cardinal;
  protezione: Cardinal;

begin

  Result := False;

  //controllo la validità dei valori dei parametri
  if ((hProcess = 0) or (localData = nil) or (DataSize = 0))  then
    Exit;

  try

    if Esecuzione then
      protezione := PAGE_EXECUTE_READWRITE
    else
      protezione := PAGE_READWRITE;

    remoteData := VirtualAllocEx(
                                 hProcess,
                                 nil,
                                 DataSize,
                                 MEM_COMMIT,
                                 protezione);

    if remoteData = nil then
      begin
        //ErrStr('VirtualAllocEx');
        Exit;
      end;

    if not WriteProcessMemory(hProcess,
                              remoteData,
                              localData,
                              DataSize,
                              BytesWritten) then
      begin
        //ErrStr('WriteProcessMemory');
        Exit;
      end;

    Result := True;

  finally
    if not result then
      begin
        if remoteData <> nil then
          begin
            if VirtualFreeEx(hProcess, remoteData, 0, MEM_RELEASE) = nil then
              begin
                //ErrStr('VirtualFreeEx');
              end;
          end;
      end;
  end;
end;

//annulla l'operato della InjectData
function UnloadData(
               hProcess: Cardinal; //handle al processo remoto
               remoteData: Pointer //valore del parametro RemoteData della InjectData
               ): Boolean;
begin

  Result := False;

  //controllo la validità dei valori dei parametri
  if (hProcess = 0) or (remoteData = nil) then
    Exit;

  try

    if VirtualFreeEx(hProcess, remoteData, 0, MEM_RELEASE) = nil then
      begin
        //ErrStr('VirtualFreeEx');
        Exit;
      end;

    Result := True;

  finally

  end;

end;

//Il succo del CodeInjection è il seguente:
//1) copiamo la funzione che vogliamo eseguire, nello spazio di memoria
//del processo remoto
//2) copiamo i parametri della funzione che vogliamo eseguire, nello spazio di memoria
//del processo remoto
//3) eseguiamo la funzione copiata, utilizzando l'api win32 CreateRemoteThread
//La funzione InjectThread si occupa appunto del punto 3)
function InjectThread(hProcess: Cardinal;
                      remoteFunction: Pointer;
                      remoteParameter: Pointer;
                      var outputValue: Cardinal;
                      var errorCode: Cardinal;
                      Synch: Boolean): Boolean;
var
  hThread: Cardinal;
  TID: Cardinal;
  lpExitCode: Cardinal;
  bytesRead: Cardinal;
begin

  //N.B. i parametri outputValue e errorCode hanno senso solo se Synch=True

  Result := False;

  //controllo la valdità dei valori dei parametri
  if ((hProcess = 0) or (remoteFunction = nil) or (remoteParameter = nil)) then
    Exit;

  try

    hThread := CreateRemoteThread(hProcess,
                                  nil,
                                  0,
                                  remoteFunction,
                                  remoteParameter,
                                  0,
                                  TID);

    if hThread = 0 then
      begin
        //ErrStr('CreateRemoteThread');
        Exit;
      end;

    //mi metto in attesa della terminazione del thread
    if Synch then
      begin
        case WaitForSingleObject(hThread, INFINITE) of
          WAIT_FAILED:
            begin
              //ErrStr('WaitForSingleObject');
              Exit;
            end;
        end;
        if not GetExitCodeThread(hThread, lpExitCode) then
          begin
            //ErrStr('GetExitCodeThread');
            Exit;
          end;
        //c'è stato un errore (lpExitCode è l'output della funzione eseguita dal
        //thread remoto che nel nostro caso è RemoteLoadLibraryThread; più precisamente è l'argomento
        //della ExitThread)
        if lpExitCode = 0 then //ExitThread(0)
          begin
            //leggo il codice dell' errore che si è verificato nel thread remoto
            //nel nostro caso TRemoteLoadLibraryData.errorcod
            if not ReadProcessMemory(hProcess, remoteParameter, @errorcode, 4, bytesRead) then
              begin
                //ErrStr('ReadProcessMemory');
                Exit;
              end;
          end
        else
          begin
            //leggo il valore significativo generato nel thread remoto
            //nel nostro caso TRemoteLoadLibraryData.output
            if not ReadProcessMemory(hProcess, Pointer(Cardinal(remoteParameter)+4), @outputvalue, 4, bytesRead) then
              begin
                //ErrStr('ReadProcessMemory');
                Exit;
              end;
          end;

      end;

    Result := True;

  finally

    if hThread <> 0 then
      begin
        if not CloseHandle(hThread) then
          begin
            //ErrStr('CloseHandle');
          end;
      end;

  end;

end;


end.
 