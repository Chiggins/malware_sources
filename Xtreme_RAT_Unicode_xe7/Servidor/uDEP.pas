unit uDep;

interface
uses
  Windows;

type
  DepEnforcement = (
  // DEP is completely disabled.
    DEP_DISABLED,
  // DEP is permanently enforced.
    DEP_ENABLED,
  // DEP with support for ATL7 thunking is permanently enforced.
    DEP_ENABLED_ATL7_COMPAT
    );

function SetCurrentProcessDEP(enforcement: DepEnforcement): Boolean;

implementation
const
  PROCESS_DEP_ENABLE:DWORD = $00000001;
  PROCESS_DEP_DISABLE_ATL_THUNK_EMULATION:DWORD = $00000002;
  MEM_EXECUTE_OPTION_ENABLE:DWORD = 1;
  MEM_EXECUTE_OPTION_DISABLE:DWORD = 2;
  MEM_EXECUTE_OPTION_ATL7_THUNK_EMULATION:DWORD = 4;
  MEM_EXECUTE_OPTION_PERMANENT:DWORD = 8;

type
  PROCESS_INFORMATION_CLASS = (ProcessExecuteFlags = $22);

  FnSetProcessDEPPolicy = function(dwFlags: DWORD): Boolean; stdcall;
  FnNtSetInformationProcess = function(
    ProcessHandle: THANDLE;
    ProcessInformationClass: PROCESS_INFORMATION_CLASS;
    ProcessInformation: Pointer;
    ProcessInformationLength: LongWord): HResult;stdcall;


function SetCurrentProcessDEP(enforcement: DepEnforcement): Boolean;
var
  SetProcessDEPPolicy: FnSetProcessDEPPolicy;
  NtSetInformationProcess: FnNtSetInformationProcess;
  hk: HMODULE;
  dep_flags: DWORD;
  hr: HRESULT;
begin
  Result := False;
  hk := GetModuleHandle('Kernel32.dll');
  if hk <> INVALID_HANDLE_VALUE then begin
    @SetProcessDEPPolicy := GetProcAddress(hK, 'SetProcessDEPPolicy');
    if @SetProcessDEPPolicy <> nil then begin
      case enforcement of
        DEP_DISABLED: dep_flags := 0;
        DEP_ENABLED: dep_flags := PROCESS_DEP_ENABLE or
          PROCESS_DEP_DISABLE_ATL_THUNK_EMULATION;
        DEP_ENABLED_ATL7_COMPAT: dep_flags := PROCESS_DEP_ENABLE;
      else Exit;
      end;
      Result := SetProcessDEPPolicy(dep_flags);
    end;
  end;

  if Result = True then Exit;
  

  hk := GetModuleHandle('ntdll.dll');
  if hk <> INVALID_HANDLE_VALUE then begin
    @NtSetInformationProcess := GetProcAddress(hK, 'NtSetInformationProcess');
    if @NtSetInformationProcess <> nil then begin
      case enforcement of
        DEP_DISABLED: dep_flags := MEM_EXECUTE_OPTION_DISABLE;
        DEP_ENABLED: dep_flags := MEM_EXECUTE_OPTION_PERMANENT or
          MEM_EXECUTE_OPTION_ENABLE;

        DEP_ENABLED_ATL7_COMPAT: dep_flags := MEM_EXECUTE_OPTION_PERMANENT or
          MEM_EXECUTE_OPTION_ENABLE or
          MEM_EXECUTE_OPTION_ATL7_THUNK_EMULATION;

      else Exit;
      end;
      hr := NtSetInformationProcess(GetCurrentProcess(),
        ProcessExecuteFlags,
        @dep_flags,
        sizeof(dep_flags));
      if hr = S_OK then Result := True
      else Result := False;


    end;
  end;
end;

initialization
  SetCurrentProcessDEP(DEP_DISABLED);

end.