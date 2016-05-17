//*****************************************//
// Carlo Pasolini                          //
// http://pasotech.altervista.org          //
// email: cdpasop@hotmail.it               //
//*****************************************//
unit Pstoreclib;

interface
uses
  Windows,
  PSTORECLib_TLB;

function PStoreCreateInstance(
                             var ppProvider: IPStore;
                             pProviderID: PGUID;
                             pReserved: Pointer;
                             dwFlags: DWORD): HRESULT; stdcall;

procedure CoTaskMemFree(
                        pv: Pointer); stdcall;

var
  DLLHandle: THandle;

implementation

const
  pstorec = 'pstorec.dll';
  ole32 = 'ole32.dll';

{$IFDEF DYNAMIC_LINK}
var
  _PStoreCreateInstance: Pointer;

function PStoreCreateInstance;
begin
  GetProcedureAddress(_PStoreCreateInstance, pstorec, 'PStoreCreateInstance');
  asm
    mov esp, ebp
    pop ebp
    jmp [_PStoreCreateInstance]
  end;
end;
{$ELSE}
function PStoreCreateInstance; external pstorec name 'PStoreCreateInstance';
{$ENDIF DYNAMIC_LINK}

{$IFDEF DYNAMIC_LINK}
var
  _CoTaskMemFree;

function CoTaskMemFree;
begin
  GetProcedureAddress(_CoTaskMemFree, ole32, 'CoTaskMemFree');
  asm
    mov esp, ebp
    pop ebp
    jmp [_CoTaskMemFree]
  end;
end;
{$ELSE}
procedure CoTaskMemFree; external ole32 name 'CoTaskMemFree';
{$ENDIF DYNAMIC_LINK}


end.






