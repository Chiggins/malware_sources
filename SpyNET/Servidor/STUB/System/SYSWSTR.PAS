unit syswstr;
{X: this unit contains some definitions and initializations, needed to
    support wide string variables. To use it, just place reference to syswstr
    unit in your dpr/units uses clause *as first as possible* }

interface

implementation

initialization

  WStrAddRefProc := WStrAddRef;
  WStrClrProc := WStrClr;
  WStrArrayClrProc := WStrArrayClr;

finalization

end.
