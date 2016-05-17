unit SysSfIni;
{X: this unit must be referenced in uses clause of dpr as earlier as possible,
    if You want to use try-execpt/raise protected initialization and finalization
    for your units. }

{$O+,H+,I-,S-}

interface

implementation

initialization

  InitUnitsProc := InitUnitsHard;
  FInitUnitsProc := FInitUnitsHard;
  UnregisterModule := UnregisterModuleSafely;
  UnsetExceptionHandlerProc := UnsetExceptionHandler;
  SetExceptionHandler;

finalization

end.
