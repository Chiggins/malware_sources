unit PerfUtils;

interface

uses
  Windows, SysUtils, WinPerf;

type
  PPerfLibHeader = ^TPerfLibHeader;
  TPerfLibHeader = packed record
    Signature: array[0..7] of Char;
    DataSize: Cardinal;
    ObjectCount: Cardinal;
  end;

type
  PPerfDataBlock = ^TPerfDataBlock;
  TPerfDataBlock = record
    Signature: array[0..3] of WCHAR;
    LittleEndian: DWORD;
    Version: DWORD;
    Revision: DWORD;
    TotalByteLength: DWORD;
    HeaderLength: DWORD;
    NumObjectTypes: DWORD;
    DefaultObject: Longint;
    SystemTime: TSystemTime;
    PerfTime: TLargeInteger;
    PerfFreq: TLargeInteger;
    PerfTime100nSec: TLargeInteger;
    SystemNameLength: DWORD;
    SystemNameOffset: DWORD;
  end;

  PPerfObjectType = ^TPerfObjectType;
  TPerfObjectType = record
    TotalByteLength: DWORD;
    DefinitionLength: DWORD;
    HeaderLength: DWORD;
    ObjectNameTitleIndex: DWORD;
    ObjectNameTitle: LPWSTR;
    ObjectHelpTitleIndex: DWORD;
    ObjectHelpTitle: LPWSTR;
    DetailLevel: DWORD;
    NumCounters: DWORD;
    DefaultCounter: Longint;
    NumInstances: Longint;
    CodePage: DWORD;
    PerfTime: TLargeInteger;
    PerfFreq: TLargeInteger;
  end;

  PPerfCounterDefinition = ^TPerfCounterDefinition;
  TPerfCounterDefinition = record
    ByteLength: DWORD;
    CounterNameTitleIndex: DWORD;
    CounterNameTitle: LPWSTR;
    CounterHelpTitleIndex: DWORD;
    CounterHelpTitle: LPWSTR;
    DefaultScale: Longint;
    DetailLevel: DWORD;
    CounterType: DWORD;
    CounterSize: DWORD;
    CounterOffset: DWORD;
  end;

  PPerfInstanceDefinition = ^TPerfInstanceDefinition;
  TPerfInstanceDefinition = record
    ByteLength: DWORD;
    ParentObjectTitleIndex: DWORD;
    ParentObjectInstance: DWORD;
    UniqueID: Longint;
    NameOffset: DWORD;
    NameLength: DWORD;
  end;

  PPerfCounterBlock = ^TPerfCounterBlock;
  TPerfCounterBlock = record
    ByteLength: DWORD;
  end;

function GetCounterBlock(Obj: PPerfObjectType): PPerfCounterBlock; overload;
function GetCounterBlock(Instance: PPerfInstanceDefinition): PPerfCounterBlock; overload;
function GetCounterDataAddress(Obj: PPerfObjectType; Counter: PPerfCounterDefinition;
  Instance: PPerfInstanceDefinition = nil): Pointer; overload;
function GetCounterDataAddress(Obj: PPerfObjectType; Counter, Instance: Integer): Pointer; overload;
function GetCounter(Obj: PPerfObjectType; Index: Integer): PPerfCounterDefinition;
function GetCounterByNameIndex(Obj: PPerfObjectType; NameIndex: Cardinal): PPerfCounterDefinition;
function GetCounterValue32(Obj: PPerfObjectType; Counter: PPerfCounterDefinition;
  Instance: PPerfInstanceDefinition = nil): Cardinal;
function GetCounterValue64(Obj: PPerfObjectType; Counter: PPerfCounterDefinition;
  Instance: PPerfInstanceDefinition = nil): UInt64;
function GetCounterValueText(Obj: PPerfObjectType; Counter: PPerfCounterDefinition;
  Instance: PPerfInstanceDefinition = nil): PChar;
function GetCounterValueWideText(Obj: PPerfObjectType; Counter: PPerfCounterDefinition;
  Instance: PPerfInstanceDefinition = nil): PWideChar;
function GetFirstCounter(Obj: PPerfObjectType): PPerfCounterDefinition;
function GetFirstInstance(Obj: PPerfObjectType): PPerfInstanceDefinition;
function GetFirstObject(Data: PPerfDataBlock): PPerfObjectType; overload;
function GetFirstObject(Header: PPerfLibHeader): PPerfObjectType; overload;
function GetInstance(Obj: PPerfObjectType; Index: Integer): PPerfInstanceDefinition;
function GetInstanceName(Instance: PPerfInstanceDefinition): PWideChar;
function GetNextCounter(Counter: PPerfCounterDefinition): PPerfCounterDefinition;
function GetNextInstance(Instance: PPerfInstanceDefinition): PPerfInstanceDefinition;
function GetNextObject(Obj: PPerfObjectType): PPerfObjectType;
function GetObjectSize(Obj: PPerfObjectType): Cardinal;
function GetObject(Data: PPerfDataBlock; Index: Integer): PPerfObjectType; overload;
function GetObject(Header: PPerfLibHeader; Index: Integer): PPerfObjectType; overload;
function GetObjectByNameIndex(Data: PPerfDataBlock; NameIndex: Cardinal): PPerfObjectType; overload;
function GetObjectByNameIndex(Header: PPerfLibHeader; NameIndex: Cardinal): PPerfObjectType; overload;
function GetPerformanceData(const RegValue: string): PPerfDataBlock;
function GetProcessInstance(Obj: PPerfObjectType; ProcessID: Cardinal): PPerfInstanceDefinition;
function GetSimpleCounterValue32(ObjIndex, CtrIndex: Integer): Cardinal;
function GetSimpleCounterValue64(ObjIndex, CtrIndex: Integer): UInt64;

function GetProcessName(ProcessID: Cardinal): WideString;
function GetProcessPercentProcessorTime(ProcessID: Cardinal; Data1, Data2: PPerfDataBlock;
  ProcessorCount: Integer = -1): Double;
function GetProcessPrivateBytes(ProcessID: Cardinal): UInt64;
function GetProcessThreadCount(ProcessID: Cardinal): Cardinal;
function GetProcessVirtualBytes(ProcessID: Cardinal): UInt64;
function GetProcessorCount: Integer;
function GetSystemProcessCount: Cardinal;
function GetSystemUpTime: TDateTime;

function GetCpuUsage(PID: cardinal): Double;

var
  PerfFrequency: Int64 = 0;

const
  // perfdisk.dll
  ObjPhysicalDisk = 234;
  ObjLogicalDisk = 236;
  // perfnet.dll
  ObjBrowser = 52;
  ObjRedirector = 262;
  ObjServer = 330;
  ObjServerWorkQueues = 1300;
  // perfos.dll
  ObjSystem = 2;
    CtrProcesses = 248;
    CtrSystemUpTime = 674;
  ObjMemory = 4;
  ObjCache = 86;
  ObjProcessor = 238;
  ObjObjects = 260;
  ObjPagingFile = 700;
  // perfproc.dll
  ObjProcess = 230;
    CtrPercentProcessorTime = 6;
    CtrVirtualBytes = 174;
    CtrPrivateBytes = 186;
    CtrThreadCount = 680;
    CtrIDProcess = 784;
  ObjThread = 232;
  ObjProcessAddressSpace = 786;
  ObjImage = 740;
  ObjThreadDetails = 816;
  ObjFullImage = 1408;
  ObjJobObject = 1500;
  ObjJobObjectDetails = 1548;
  ObjHeap = 1760;
  // winspool.drv
  ObjPrintQueue = 1450;
  // tapiperf.dll
  ObjTelephony = 1150;
  // perfctrs.dll
  ObjNBTConnection = 502;
  ObjNetworkInterface = 510;
  ObjIP = 546;
  ObjICMP = 582;
  ObjTCP = 638;
  ObjUDP = 658;

implementation

function GetCounterBlock(Obj: PPerfObjectType): PPerfCounterBlock;
begin
  if Assigned(Obj) and (Obj^.NumInstances = PERF_NO_INSTANCES) then
    Cardinal(Result) := Cardinal(Obj) + SizeOf(TPerfObjectType) + (Obj^.NumCounters * SizeOf(TPerfCounterDefinition))
  else
    Result := nil;
end;

function GetCounterBlock(Instance: PPerfInstanceDefinition): PPerfCounterBlock;
begin
  if Assigned(Instance) then
    Cardinal(Result) := Cardinal(Instance) + Instance^.ByteLength
  else
    Result := nil;
end;

function GetCounterDataAddress(Obj: PPerfObjectType; Counter: PPerfCounterDefinition;
  Instance: PPerfInstanceDefinition = nil): Pointer;
var
  Block: PPerfCounterBlock;
begin
  Result := nil;
  if not Assigned(Obj) or not Assigned(Counter) then
    Exit;

  if Obj^.NumInstances = PERF_NO_INSTANCES then
    Block := GetCounterBlock(Obj)
  else
  begin
    if not Assigned(Instance) then
      Exit;

    Block := GetCounterBlock(Instance);
  end;

  if not Assigned(Block) then
    Exit;

  Cardinal(Result) := Cardinal(Block) + Counter^.CounterOffset;
end;

function GetCounterDataAddress(Obj: PPerfObjectType; Counter, Instance: Integer): Pointer;
begin
  Result := nil;
  if not Assigned(Obj) or (Counter < 0) or (Cardinal(Counter) > Obj^.NumCounters - 1) then
    Exit;

  if Obj^.NumInstances = PERF_NO_INSTANCES then
  begin
    if Instance <> -1 then
      Exit;
  end
  else
  begin
    if (Instance < 0) or (Instance > Obj^.NumInstances - 1) then
      Exit;
  end;

  Result := GetCounterDataAddress(Obj, GetCounter(Obj, Counter), GetInstance(Obj, Instance));
end;

function GetCounter(Obj: PPerfObjectType; Index: Integer): PPerfCounterDefinition;
var
  I: Integer;
begin
  if Assigned(Obj) and (Index >= 0) and (Cardinal(Index) <= Obj^.NumCounters - 1) then
  begin
    Result := GetFirstCounter(Obj);
    if not Assigned(Result) then
      Exit;

    for I := 0 to Index - 1 do
    begin
      Result := GetNextCounter(Result);
      if not Assigned(Result) then
        Exit;
    end;
  end
  else
    Result := nil;
end;

function GetCounterByNameIndex(Obj: PPerfObjectType; NameIndex: Cardinal): PPerfCounterDefinition;
var
  Counter: PPerfCounterDefinition;
  I: Integer;
begin
  Result := nil;

  Counter := GetFirstCounter(Obj);
  for I := 0 to Obj^.NumCounters - 1 do
  begin
    if not Assigned(Counter) then
      Exit;

    if Counter^.CounterNameTitleIndex = NameIndex then
    begin
      Result := Counter;
      Break;
    end;

    Counter := GetNextCounter(Counter);
  end;
end;

function GetCounterValue32(Obj: PPerfObjectType; Counter: PPerfCounterDefinition;
  Instance: PPerfInstanceDefinition = nil): Cardinal;
var
  DataAddr: Pointer;
begin
  Result := 0;

  DataAddr := GetCounterDataAddress(Obj, Counter, Instance);
  if not Assigned(DataAddr) then
    Exit;

  if Counter^.CounterType and $00000300 = PERF_SIZE_DWORD then // 32-bit value
    case Counter^.CounterType and $00000C00 of // counter type
      PERF_TYPE_NUMBER, PERF_TYPE_COUNTER:
        Result := PCardinal(DataAddr)^;
    end;
end;

function GetCounterValue64(Obj: PPerfObjectType; Counter: PPerfCounterDefinition;
  Instance: PPerfInstanceDefinition = nil): UInt64;
var
  DataAddr: Pointer;
begin
  Result := 0;

  DataAddr := GetCounterDataAddress(Obj, Counter, Instance);
  if not Assigned(DataAddr) then
    Exit;

  if Counter^.CounterType and $00000300 = PERF_SIZE_LARGE then // 64-bit value
    case Counter^.CounterType and $00000C00 of // counter type
      PERF_TYPE_NUMBER, PERF_TYPE_COUNTER:
        Result := Uint64(PInt64(DataAddr)^);
    end;
end;

function GetCounterValueText(Obj: PPerfObjectType; Counter: PPerfCounterDefinition;
  Instance: PPerfInstanceDefinition = nil): PChar;
var
  DataAddr: Pointer;
begin
  Result := nil;

  DataAddr := GetCounterDataAddress(Obj, Counter, Instance);
  if not Assigned(DataAddr) then
    Exit;

  if Counter^.CounterType and $00000300 = PERF_SIZE_VARIABLE_LEN then // variable-length value
    if (Counter^.CounterType and $00000C00 = PERF_TYPE_TEXT) and
      (Counter^.CounterType and $00010000 = PERF_TEXT_ASCII) then
      Result := PChar(DataAddr);
end;

function GetCounterValueWideText(Obj: PPerfObjectType; Counter: PPerfCounterDefinition;
  Instance: PPerfInstanceDefinition = nil): PWideChar;
var
  DataAddr: Pointer;
begin
  Result := nil;

  DataAddr := GetCounterDataAddress(Obj, Counter, Instance);
  if not Assigned(DataAddr) then
    Exit;

  if Counter^.CounterType and $00000300 = PERF_SIZE_VARIABLE_LEN then // variable-length value
    if (Counter^.CounterType and $00000C00 = PERF_TYPE_TEXT) and
      (Counter^.CounterType and $00010000 = PERF_TEXT_UNICODE) then
      Result := PWideChar(DataAddr);
end;

function GetFirstCounter(Obj: PPerfObjectType): PPerfCounterDefinition;
begin
  if Assigned(Obj) then
    Cardinal(Result) := Cardinal(Obj) + Obj^.HeaderLength
  else
    Result := nil;
end;

function GetFirstInstance(Obj: PPerfObjectType): PPerfInstanceDefinition;
begin
  if not Assigned(Obj) or (Obj^.NumInstances = PERF_NO_INSTANCES) then
    Result := nil
  else
    Cardinal(Result) := Cardinal(Obj) + SizeOf(TPerfObjectType) + (Obj^.NumCounters * SizeOf(TPerfCounterDefinition));
end;

function GetFirstObject(Data: PPerfDataBlock): PPerfObjectType; overload;
begin
  if Assigned(Data) then
    Cardinal(Result) := Cardinal(Data) + Data^.HeaderLength
  else
    Result := nil;
end;

function GetFirstObject(Header: PPerfLibHeader): PPerfObjectType; overload;
begin
  if Assigned(Header) then
    Cardinal(Result) := Cardinal(Header) + SizeOf(TPerfLibHeader)
  else
    Result := nil;
end;

function GetInstance(Obj: PPerfObjectType; Index: Integer): PPerfInstanceDefinition;
var
  I: Integer;
begin
  if Assigned(Obj) and (Index >= 0) and (Index <= Obj^.NumInstances - 1) then
  begin
    Result := GetFirstInstance(Obj);
    if not Assigned(Result) then
      Exit;

    for I := 0 to Index - 1 do
    begin
      Result := GetNextInstance(Result);
      if not Assigned(Result) then
        Exit;
    end;
  end
  else
    Result := nil;
end;

function GetInstanceName(Instance: PPerfInstanceDefinition): PWideChar;
begin
  if Assigned(Instance) then
    Cardinal(Result) := Cardinal(Instance) + Instance^.NameOffset
  else
    Result := nil;
end;

function GetNextCounter(Counter: PPerfCounterDefinition): PPerfCounterDefinition;
begin
  if Assigned(Counter) then
    Cardinal(Result) := Cardinal(Counter) + Counter^.ByteLength
  else
    Result := nil;
end;

function GetNextInstance(Instance: PPerfInstanceDefinition): PPerfInstanceDefinition;
var
  Block: PPerfCounterBlock;
begin
  Block := GetCounterBlock(Instance);
  if Assigned(Block) then
    Cardinal(Result) := Cardinal(Block) + Block^.ByteLength
  else
    Result := nil;
end;

function GetNextObject(Obj: PPerfObjectType): PPerfObjectType;
begin
  if Assigned(Obj) then
    Cardinal(Result) := Cardinal(Obj) + Obj^.TotalByteLength
  else
    Result := nil;
end;

function GetObjectSize(Obj: PPerfObjectType): Cardinal;
var
  I: Integer;
  Instance: PPerfInstanceDefinition;
begin
  Result := 0;

  if Assigned(Obj) then
  begin
    if Obj^.NumInstances = PERF_NO_INSTANCES then
      Result := Obj^.TotalByteLength
    else
    begin
      Instance := GetFirstInstance(Obj);
      if not Assigned(Instance) then
        Exit;

      for I := 0 to Obj^.NumInstances - 1 do
      begin
        Instance := GetNextInstance(Instance);
        if not Assigned(Instance) then
          Exit;
      end;

      Result := Cardinal(Instance) - Cardinal(Obj);
    end;
  end;
end;

function GetObject(Data: PPerfDataBlock; Index: Integer): PPerfObjectType;
var
  I: Integer;
begin
  if Assigned(Data) and (Index >= 0) and (Cardinal(Index) <= Data^.NumObjectTypes - 1) then
  begin
    Result := GetFirstObject(Data);
    if not Assigned(Result) then
      Exit;

    for I := 0 to Index - 1 do
    begin
      Result := GetNextObject(Result);
      if not Assigned(Result) then
        Exit;
    end;
  end
  else
    Result := nil;
end;

function GetObject(Header: PPerfLibHeader; Index: Integer): PPerfObjectType;
var
  I: Integer;
begin
  if Assigned(Header) and (Index >= 0) then
  begin
    Result := GetFirstObject(Header);
    if not Assigned(Result) then
      Exit;

    for I := 0 to Index - 1 do
    begin
      Result := GetNextObject(Result);
      if not Assigned(Result) then
        Exit;
    end;
  end
  else
    Result := nil;
end;

function GetObjectByNameIndex(Data: PPerfDataBlock; NameIndex: Cardinal): PPerfObjectType;
var
  Obj: PPerfObjectType;
  I: Integer;
begin
  Result := nil;

  Obj := GetFirstObject(Data);
  for I := 0 to Data^.NumObjectTypes - 1 do
  begin
    if not Assigned(Obj) then
      Exit;

    if Obj^.ObjectNameTitleIndex = NameIndex then
    begin
      Result := Obj;
      Break;
    end;

    Obj := GetNextObject(Obj);
  end;
end;

function GetObjectByNameIndex(Header: PPerfLibHeader; NameIndex: Cardinal): PPerfObjectType; overload;
var
  Obj: PPerfObjectType;
  I: Integer;
begin
  Result := nil;

  Obj := GetFirstObject(Header);
  for I := 0 to Header^.ObjectCount - 1 do
  begin
    if not Assigned(Obj) then
      Exit;

    if Obj^.ObjectNameTitleIndex = NameIndex then
    begin
      Result := Obj;
      Break;
    end;

    Obj := GetNextObject(Obj);
  end;
end;

function GetPerformanceData(const RegValue: string): PPerfDataBlock;
const
  BufSizeInc = 4096;
var
  BufSize, RetVal: Cardinal;
begin
  BufSize := BufSizeInc;
  Result := AllocMem(BufSize);
  try
    RetVal := RegQueryValueEx(HKEY_PERFORMANCE_DATA, PChar(RegValue), nil, nil, PByte(Result), @BufSize);
    try
      repeat
        case RetVal of
          ERROR_SUCCESS:
            Break;
          ERROR_MORE_DATA:
            begin
              Inc(BufSize, BufSizeInc);
              ReallocMem(Result, BufSize);
              RetVal := RegQueryValueEx(HKEY_PERFORMANCE_DATA, PChar(RegValue), nil, nil, PByte(Result), @BufSize);
            end;
          else
            RaiseLastOSError;
        end;
      until False;
    finally
      RegCloseKey(HKEY_PERFORMANCE_DATA);
    end;
  except
    FreeMem(Result);
    raise;
  end;
end;

function GetProcessInstance(Obj: PPerfObjectType; ProcessID: Cardinal): PPerfInstanceDefinition;
var
  Counter: PPerfCounterDefinition;
  Instance: PPerfInstanceDefinition;
  Block: PPerfCounterBlock;
  I: Integer;
begin
  Result := nil;

  Counter := GetCounterByNameIndex(Obj, CtrIDProcess);
  if not Assigned(Counter) then
    Exit;

  Instance := GetFirstInstance(Obj);
  for I := 0 to Obj^.NumInstances - 1 do
  begin
    Block := GetCounterBlock(Instance);
    if not Assigned(Block) then
      Exit;

    if PCardinal(Cardinal(Block) + Counter^.CounterOffset)^ = ProcessID then
    begin
      Result := Instance;
      Break;
    end;

    Instance := GetNextInstance(Instance);
  end;
end;

function GetSimpleCounterValue32(ObjIndex, CtrIndex: Integer): Cardinal;
var
  Data: PPerfDataBlock;
  Obj: PPerfObjectType;
  Counter: PPerfCounterDefinition;
begin
  Result := 0;

  Data := GetPerformanceData(IntToStr(ObjIndex));
  try
    Obj := GetObjectByNameIndex(Data, ObjIndex);
    if not Assigned(Obj) then
      Exit;

    Counter := GetCounterByNameIndex(Obj, CtrIndex);
    if not Assigned(Counter) then
      Exit;

    Result := GetCounterValue32(Obj, Counter);
  finally
    FreeMem(Data);
  end;
end;

function GetSimpleCounterValue64(ObjIndex, CtrIndex: Integer): UInt64;
var
  Data: PPerfDataBlock;
  Obj: PPerfObjectType;
  Counter: PPerfCounterDefinition;
begin
  Result := 0;

  Data := GetPerformanceData(IntToStr(ObjIndex));
  try
    Obj := GetObjectByNameIndex(Data, ObjIndex);
    if not Assigned(Obj) then
      Exit;

    Counter := GetCounterByNameIndex(Obj, CtrIndex);
    if not Assigned(Counter) then
      Exit;

    Result := GetCounterValue64(Obj, Counter);
  finally
    FreeMem(Data);
  end;
end;

function GetProcessName(ProcessID: Cardinal): WideString;
var
  Data: PPerfDataBlock;
  Obj: PPerfObjectType;
  Instance: PPerfInstanceDefinition;
begin
  Result := '';

  Data := GetPerformanceData(IntToStr(ObjProcess));
  try
    Obj := GetObjectByNameIndex(Data, ObjProcess);
    if not Assigned(Obj) then
      Exit;

    Instance := GetProcessInstance(Obj, ProcessID);
    if not Assigned(Instance) then
      Exit;

    Result := GetInstanceName(Instance);
  finally
    FreeMem(Data);
  end;
end;

function GetProcessPercentProcessorTime(ProcessID: Cardinal; Data1, Data2: PPerfDataBlock;
  ProcessorCount: Integer): Double;
var
  Value1, Value2: UInt64;

  function GetValue(Data: PPerfDataBlock): UInt64;
  var
    Obj: PPerfObjectType;
    Instance: PPerfInstanceDefinition;
    Counter: PPerfCounterDefinition;
  begin
    Result := 0;

    Obj := GetObjectByNameIndex(Data, ObjProcess);
    if not Assigned(Obj) then
      Exit;
    Counter := GetCounterByNameIndex(Obj, CtrPercentProcessorTime);
    if not Assigned(Counter) then
      Exit;
    Instance := GetProcessInstance(Obj, ProcessID);
    if not Assigned(Instance) then
      Exit;

    Result := GetCounterValue64(Obj, Counter, Instance);
  end;
begin
  if ProcessorCount = -1 then
    ProcessorCount := GetProcessorCount;

  Value1 := GetValue(Data1);
  Value2 := GetValue(Data2);

  Result := 100 * (Value2 - Value1) / (Data2^.PerfTime100nSec{.QuadPart} - Data1^.PerfTime100nSec{.QuadPart})
    / ProcessorCount;
end;

function GetProcessPrivateBytes(ProcessID: Cardinal): UInt64;
var
  Data: PPerfDataBlock;
  Obj: PPerfObjectType;
  Instance: PPerfInstanceDefinition;
  Counter: PPerfCounterDefinition;
begin
  Result := 0;

  Data := GetPerformanceData(IntToStr(ObjProcess));
  try
    Obj := GetObjectByNameIndex(Data, ObjProcess);
    if not Assigned(Obj) then
      Exit;

    Counter := GetCounterByNameIndex(Obj, CtrPrivateBytes);
    if not Assigned(Counter) then
      Exit;

    Instance := GetProcessInstance(Obj, ProcessID);
    if not Assigned(Instance) then
      Exit;

    Result := GetCounterValue64(Obj, Counter, Instance);
  finally
    FreeMem(Data);
  end;
end;

function GetProcessThreadCount(ProcessID: Cardinal): Cardinal;
var
  Data: PPerfDataBlock;
  Obj: PPerfObjectType;
  Instance: PPerfInstanceDefinition;
  Counter: PPerfCounterDefinition;
begin
  Result := 0;

  Data := GetPerformanceData(IntToStr(ObjProcess));
  try
    Obj := GetObjectByNameIndex(Data, ObjProcess);
    if not Assigned(Obj) then
      Exit;

    Counter := GetCounterByNameIndex(Obj, CtrThreadCount);
    if not Assigned(Counter) then
      Exit;

    Instance := GetProcessInstance(Obj, ProcessID);
    if not Assigned(Instance) then
      Exit;

    Result := GetCounterValue32(Obj, Counter, Instance);
  finally
    FreeMem(Data);
  end;
end;

function GetProcessVirtualBytes(ProcessID: Cardinal): UInt64;
var
  Data: PPerfDataBlock;
  Obj: PPerfObjectType;
  Instance: PPerfInstanceDefinition;
  Counter: PPerfCounterDefinition;
begin
  Result := 0;

  Data := GetPerformanceData(IntToStr(ObjProcess));
  try
    Obj := GetObjectByNameIndex(Data, ObjProcess);
    if not Assigned(Obj) then
      Exit;

    Counter := GetCounterByNameIndex(Obj, CtrVirtualBytes);
    if not Assigned(Counter) then
      Exit;

    Instance := GetProcessInstance(Obj, ProcessID);
    if not Assigned(Instance) then
      Exit;

    Result := GetCounterValue64(Obj, Counter, Instance);
  finally
    FreeMem(Data);
  end;
end;

function GetProcessorCount: Integer;
var
  Data: PPerfDataBlock;
  Obj: PPerfObjectType;
begin
  Result := -1;

  Data := GetPerformanceData(IntToStr(ObjProcessor));
  try
    Obj := GetFirstObject(Data);
    if not Assigned(Obj) then
      Exit;

    Result := Obj^.NumInstances;
    if Result > 1 then // disregard the additional '_Total' instance
      Dec(Result);
  finally
    FreeMem(Data);
  end;
end;

function GetSystemProcessCount: Cardinal;
begin
  Result := GetSimpleCounterValue32(ObjSystem, CtrProcesses);
end;

function GetSystemUpTime: TDateTime;
const
  SecsPerDay = 60 * 60 * 24;
var
  Data: PPerfDataBlock;
  Obj: PPerfObjectType;
  Counter: PPerfCounterDefinition;
  SecsStartup: UInt64;
begin
  Result := 0;

  Data := GetPerformanceData(IntToStr(ObjSystem));
  try
    Obj := GetObjectByNameIndex(Data, ObjSystem);
    if not Assigned(Obj) then
      Exit;

    Counter := GetCounterByNameIndex(Obj, CtrSystemUpTime);
    if not Assigned(Counter) then
      Exit;

    SecsStartup := GetCounterValue64(Obj, Counter);
    // subtract from snapshot time and divide by base frequency and number of seconds per day
    // to get a TDateTime representation
    Result := (Obj^.PerfTime{.QuadPart} - SecsStartup) / Obj^.PerfFreq{.QuadPart} / SecsPerDay;
  finally
    FreeMem(Data);
  end;
end;

function GetCpuUsage(PID: cardinal): Double;
var
  Data1, Data2: PPerfDataBlock;
  ProcessorCount: Integer;
  PercentProcessorTime: Double;
begin
try
  ProcessorCount := GetProcessorCount;
  Data1 := GetPerformanceData(IntToStr(ObjProcess));
  Sleep(250);
  Data2 := GetPerformanceData(IntToStr(ObjProcess));
  Result := GetProcessPercentProcessorTime(PID, Data1, Data2, ProcessorCount);
finally
  freemem(data1);
  freemem(data2);
  releasedc(pid, ProcessorCount);
end;
end;

initialization
  QueryPerformanceFrequency(PerfFrequency);

finalization

end.
