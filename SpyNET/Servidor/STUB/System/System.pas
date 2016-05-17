{ *********************************************************************** }
{                                                                         }
{ Delphi / Kylix Cross-Platform Runtime Library                           }
{ System Unit                                                             }
{                                                                         }
{ Copyright (c) 1988-2002 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

//Avenger SysDcu for Delphi 7

unit System; { Predefined constants, types, procedures, }
             { and functions (such as True, Integer, or }
             { Writeln) do not have actual declarations.}
             { Instead they are built into the compiler }
             { and are treated as if they were declared }
             { at the beginning of the System unit.     }

{$H+,I-,R-,O+,W-}
{$WARN SYMBOL_PLATFORM OFF}

{ L- should never be specified.

  The IDE needs to find DebugHook (through the C++
  compiler sometimes) for integrated debugging to
  function properly.

  ILINK will generate debug info for DebugHook if
  the object module has not been compiled with debug info.

  ILINK will not generate debug info for DebugHook if
  the object module has been compiled with debug info.

  Thus, the Pascal compiler must be responsible for
  generating the debug information for that symbol
  when a debug-enabled object file is produced.
}

interface

(* You can use RTLVersion in $IF expressions to test the runtime library
  version level independently of the compiler version level.
  Example:  {$IF RTLVersion >= 16.2} ... {$IFEND}                  *)

const
  RTLVersion = 14.1;

{$EXTERNALSYM CompilerVersion}

(*
const
  CompilerVersion = 0.0;

  CompilerVersion is assigned a value by the compiler when
  the system unit is compiled.  It indicates the revision level of the
  compiler features / language syntax, which may advance independently of
  the RTLVersion.  CompilerVersion can be tested in $IF expressions and
  should be used instead of testing for the VERxxx conditional define.
  Always test for greater than or less than a known revision level.
  It's a bad idea to test for a specific revision level.
*)


{$IFDEF DECLARE_GPL}
(* The existence of the GPL symbol indicates that the System unit
  and the rest of the Delphi runtime library were compiled for use
  and distribution under the terms of the GNU General Public License (GPL).
  Under the terms of the GPL, all applications compiled with the
  GPL version of the Delphi runtime library must also be distributed
  under the terms of the GPL.
  For more information about the GNU GPL, see
  http://www.gnu.org/copyleft/gpl.html

  The GPL symbol does not exist in the Delphi runtime library
  purchased for commercial/proprietary software development.

  If your source code needs to know which licensing model it is being
  compiled into, you can use {$IF DECLARED(GPL)}...{$IFEND} to
  test for the existence of the GPL symbol.  The value of the
  symbol itself is not significant.   *)

const
  GPL = True;
{$ENDIF}

{ Variant type codes (wtypes.h) }

  varEmpty    = $0000; { vt_empty       }
  varNull     = $0001; { vt_null        }
  varSmallint = $0002; { vt_i2          }
  varInteger  = $0003; { vt_i4          }
  varSingle   = $0004; { vt_r4          }
  varDouble   = $0005; { vt_r8          }
  varCurrency = $0006; { vt_cy          }
  varDate     = $0007; { vt_date        }
  varOleStr   = $0008; { vt_bstr        }
  varDispatch = $0009; { vt_dispatch    }
  varError    = $000A; { vt_error       }
  varBoolean  = $000B; { vt_bool        }
  varVariant  = $000C; { vt_variant     }
  varUnknown  = $000D; { vt_unknown     }
//varDecimal  = $000E; { vt_decimal     } {UNSUPPORTED}
                       { undefined  $0f } {UNSUPPORTED}
  varShortInt = $0010; { vt_i1          }
  varByte     = $0011; { vt_ui1         }
  varWord     = $0012; { vt_ui2         }
  varLongWord = $0013; { vt_ui4         }
  varInt64    = $0014; { vt_i8          }
//varWord64   = $0015; { vt_ui8         } {UNSUPPORTED}

  { if adding new items, update Variants' varLast, BaseTypeMap and OpTypeMap }
  varStrArg   = $0048; { vt_clsid    }
  varString   = $0100; { Pascal string; not OLE compatible }
  varAny      = $0101; { Corba any }
  varTypeMask = $0FFF;
  varArray    = $2000;
  varByRef    = $4000;

{ TVarRec.VType values }

  vtInteger    = 0;
  vtBoolean    = 1;
  vtChar       = 2;
  vtExtended   = 3;
  vtString     = 4;
  vtPointer    = 5;
  vtPChar      = 6;
  vtObject     = 7;
  vtClass      = 8;
  vtWideChar   = 9;
  vtPWideChar  = 10;
  vtAnsiString = 11;
  vtCurrency   = 12;
  vtVariant    = 13;
  vtInterface  = 14;
  vtWideString = 15;
  vtInt64      = 16;

{ Virtual method table entries }

  vmtSelfPtr           = -76;
  vmtIntfTable         = -72;
  vmtAutoTable         = -68;
  vmtInitTable         = -64;
  vmtTypeInfo          = -60;
  vmtFieldTable        = -56;
  vmtMethodTable       = -52;
  vmtDynamicTable      = -48;
  vmtClassName         = -44;
  vmtInstanceSize      = -40;
  vmtParent            = -36;
  vmtSafeCallException = -32;
  vmtAfterConstruction = -28;
  vmtBeforeDestruction = -24;
  vmtDispatch          = -20;
  vmtDefaultHandler    = -16;
  vmtNewInstance       = -12;
  vmtFreeInstance      = -8;
  vmtDestroy           = -4;

  vmtQueryInterface    = 0;
  vmtAddRef            = 4;
  vmtRelease           = 8;
  vmtCreateObject      = 12;

type

  TObject = class;

  TClass = class of TObject;

  HRESULT = type Longint;  { from WTYPES.H }
  {$EXTERNALSYM HRESULT}

  PGUID = ^TGUID;
  TGUID = packed record
    D1: LongWord;
    D2: Word;
    D3: Word;
    D4: array[0..7] of Byte;
  end;

  PInterfaceEntry = ^TInterfaceEntry;
  TInterfaceEntry = packed record
    IID: TGUID;
    VTable: Pointer;
    IOffset: Integer;
    ImplGetter: Integer;
  end;

  PInterfaceTable = ^TInterfaceTable;
  TInterfaceTable = packed record
    EntryCount: Integer;
    Entries: array[0..9999] of TInterfaceEntry;
  end;

  TMethod = record
    Code, Data: Pointer;
  end;

{ TObject.Dispatch accepts any data type as its Message parameter.  The
  first 2 bytes of the data are taken as the message id to search for
  in the object's message methods.  TDispatchMessage is an example of
  such a structure with a word field for the message id.
}
  TDispatchMessage = record
    MsgID: Word;
  end;

  TObject = class
    constructor Create;
    procedure Free;
    class function InitInstance(Instance: Pointer): TObject;
    procedure CleanupInstance;
    function ClassType: TClass;
    class function ClassName: ShortString;
    class function ClassNameIs(const Name: string): Boolean;
    class function ClassParent: TClass;
    class function ClassInfo: Pointer;
    class function InstanceSize: Longint;
    class function InheritsFrom(AClass: TClass): Boolean;
    class function MethodAddress(const Name: ShortString): Pointer;
    class function MethodName(Address: Pointer): ShortString;
    function FieldAddress(const Name: ShortString): Pointer;
    function GetInterface(const IID: TGUID; out Obj): Boolean;
    class function GetInterfaceEntry(const IID: TGUID): PInterfaceEntry;
    class function GetInterfaceTable: PInterfaceTable;
    function SafeCallException(ExceptObject: TObject;
      ExceptAddr: Pointer): HResult; virtual;
    procedure AfterConstruction; virtual;
    procedure BeforeDestruction; virtual;
    procedure Dispatch(var Message); virtual;
    procedure DefaultHandler(var Message); virtual;
    class function NewInstance: TObject; virtual;
    procedure FreeInstance; virtual;
    destructor Destroy; virtual;
  end;

const
  S_OK = 0;                             {$EXTERNALSYM S_OK}
  S_FALSE = $00000001;                  {$EXTERNALSYM S_FALSE}
  E_NOINTERFACE = HRESULT($80004002);   {$EXTERNALSYM E_NOINTERFACE}
  E_UNEXPECTED = HRESULT($8000FFFF);    {$EXTERNALSYM E_UNEXPECTED}
  E_NOTIMPL = HRESULT($80004001);       {$EXTERNALSYM E_NOTIMPL}

type
  IInterface = interface
    ['{00000000-0000-0000-C000-000000000046}']
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

  (*$HPPEMIT '#define IInterface IUnknown' *)

  IUnknown = IInterface;
{$M+}
  IInvokable = interface(IInterface)
  end;
{$M-}

  IDispatch = interface(IUnknown)
    ['{00020400-0000-0000-C000-000000000046}']
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  end;

{$EXTERNALSYM IUnknown}
{$EXTERNALSYM IDispatch}

{ TInterfacedObject provides a threadsafe default implementation
  of IInterface.  You should use TInterfaceObject as the base class
  of objects implementing interfaces.  }

  TInterfacedObject = class(TObject, IInterface)
  protected
    FRefCount: Integer;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class function NewInstance: TObject; override;
    property RefCount: Integer read FRefCount;
  end;

  TInterfacedClass = class of TInterfacedObject;

{ TAggregatedObject and TContainedObject are suitable base
  classes for interfaced objects intended to be aggregated
  or contained in an outer controlling object.  When using
  the "implements" syntax on an interface property in
  an outer object class declaration, use these types
  to implement the inner object.

  Interfaces implemented by aggregated objects on behalf of
  the controller should not be distinguishable from other
  interfaces provided by the controller.  Aggregated objects
  must not maintain their own reference count - they must
  have the same lifetime as their controller.  To achieve this,
  aggregated objects reflect the reference count methods
  to the controller.

  TAggregatedObject simply reflects QueryInterface calls to
  its controller.  From such an aggregated object, one can
  obtain any interface that the controller supports, and
  only interfaces that the controller supports.  This is
  useful for implementing a controller class that uses one
  or more internal objects to implement the interfaces declared
  on the controller class.  Aggregation promotes implementation
  sharing across the object hierarchy.

  TAggregatedObject is what most aggregate objects should
  inherit from, especially when used in conjunction with
  the "implements" syntax.  }

  TAggregatedObject = class(TObject)
  private
    FController: Pointer;  // weak reference to controller
    function GetController: IInterface;
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    constructor Create(const Controller: IInterface);
    property Controller: IInterface read GetController;
  end;

  { TContainedObject is an aggregated object that isolates
    QueryInterface on the aggregate from the controller.
    TContainedObject will return only interfaces that the
    contained object itself implements, not interfaces
    that the controller implements.  This is useful for
    implementing nodes that are attached to a controller and
    have the same lifetime as the controller, but whose
    interface identity is separate from the controller.
    You might do this if you don't want the consumers of
    an aggregated interface to have access to other interfaces
    implemented by the controller - forced encapsulation.
    This is a less common case than TAggregatedObject.  }

  TContainedObject = class(TAggregatedObject, IInterface)
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
  end;

  PShortString = ^ShortString;
  PAnsiString = ^AnsiString;
  PWideString = ^WideString;
  PString = PAnsiString;

  UCS2Char = WideChar;
  PUCS2Char = PWideChar;
  UCS4Char = type LongWord;
  {$NODEFINE UCS4CHAR}
  PUCS4Char = ^UCS4Char;
  {$NODEFINE PUCS4CHAR}
  TUCS4CharArray = array [0..$effffff] of UCS4Char;
  PUCS4CharArray = ^TUCS4CharArray;
  UCS4String = array of UCS4Char;
  {$NODEFINE UCS4String}

  UTF8String = type string;
  PUTF8String = ^UTF8String;
  {$NODEFINE UTF8String}
  {$NODEFINE PUTF8String}

  IntegerArray  = array[0..$effffff] of Integer;
  PIntegerArray = ^IntegerArray;
  PointerArray = array [0..512*1024*1024 - 2] of Pointer;
  PPointerArray = ^PointerArray;
  TBoundArray = array of Integer;
  TPCharArray = packed array[0..(MaxLongint div SizeOf(PChar))-1] of PChar;
  PPCharArray = ^TPCharArray;

  (*$HPPEMIT 'namespace System' *)
  (*$HPPEMIT '{' *)
  (*$HPPEMIT '  typedef int *PLongint;' *)
  (*$HPPEMIT '  typedef bool *PBoolean;' *)
  (*$HPPEMIT '  typedef PChar *PPChar;' *)
  (*$HPPEMIT '  typedef double *PDouble;' *)
  (*$HPPEMIT '  typedef wchar_t UCS4Char;' *)
  (*$HPPEMIT '  typedef wchar_t *PUCS4Char;' *)
  (*$HPPEMIT '  typedef DynamicArray<UCS4Char>  UCS4String;' *)
  (*$HPPEMIT '}' *)
  PLongint      = ^Longint;
  {$EXTERNALSYM PLongint}
  PInteger      = ^Integer;
  PCardinal     = ^Cardinal;
  PWord         = ^Word;
  PSmallInt     = ^SmallInt;
  PByte         = ^Byte;
  PShortInt     = ^ShortInt;
  PInt64        = ^Int64;
  PLongWord     = ^LongWord;
  PSingle       = ^Single;
  PDouble       = ^Double;
  PDate         = ^Double;
  PDispatch     = ^IDispatch;
  PPDispatch    = ^PDispatch;
  PError        = ^LongWord;
  PWordBool     = ^WordBool;
  PUnknown      = ^IUnknown;
  PPUnknown     = ^PUnknown;
  {$NODEFINE PByte}
  PPWideChar    = ^PWideChar;
  PPChar        = ^PChar;
  PPAnsiChar    = PPChar;
  PExtended     = ^Extended;
  PComp         = ^Comp;
  PCurrency     = ^Currency;
  PVariant      = ^Variant;
  POleVariant   = ^OleVariant;
  PPointer      = ^Pointer;
  PBoolean      = ^Boolean;

  TDateTime = type Double;
  PDateTime = ^TDateTime;

  THandle = LongWord;

  TVarArrayBound = packed record
    ElementCount: Integer;
    LowBound: Integer;
  end;
  TVarArrayBoundArray = array [0..0] of TVarArrayBound;
  PVarArrayBoundArray = ^TVarArrayBoundArray;
  TVarArrayCoorArray = array [0..0] of Integer;
  PVarArrayCoorArray = ^TVarArrayCoorArray;

  PVarArray = ^TVarArray;
  TVarArray = packed record
    DimCount: Word;
    Flags: Word;
    ElementSize: Integer;
    LockCount: Integer;
    Data: Pointer;
    Bounds: TVarArrayBoundArray;
  end;

  TVarType = Word;
  PVarData = ^TVarData;
  {$EXTERNALSYM PVarData}
  TVarData = packed record
    VType: TVarType;
    case Integer of
      0: (Reserved1: Word;
          case Integer of
            0: (Reserved2, Reserved3: Word;
                case Integer of
                  varSmallInt: (VSmallInt: SmallInt);
                  varInteger:  (VInteger: Integer);
                  varSingle:   (VSingle: Single);
                  varDouble:   (VDouble: Double);
                  varCurrency: (VCurrency: Currency);
                  varDate:     (VDate: TDateTime);
                  varOleStr:   (VOleStr: PWideChar);
                  varDispatch: (VDispatch: Pointer);
                  varError:    (VError: LongWord);
                  varBoolean:  (VBoolean: WordBool);
                  varUnknown:  (VUnknown: Pointer);
                  varShortInt: (VShortInt: ShortInt);
                  varByte:     (VByte: Byte);
                  varWord:     (VWord: Word);
                  varLongWord: (VLongWord: LongWord);
                  varInt64:    (VInt64: Int64);
                  varString:   (VString: Pointer);
                  varAny:      (VAny: Pointer);
                  varArray:    (VArray: PVarArray);
                  varByRef:    (VPointer: Pointer);
               );
            1: (VLongs: array[0..2] of LongInt);
         );
      2: (VWords: array [0..6] of Word);
      3: (VBytes: array [0..13] of Byte);
  end;
  {$EXTERNALSYM TVarData}

type
  TVarOp = Integer;

const
  opAdd =        0;
  opSubtract =   1;
  opMultiply =   2;
  opDivide =     3;
  opIntDivide =  4;
  opModulus =    5;
  opShiftLeft =  6;
  opShiftRight = 7;
  opAnd =        8;
  opOr =         9;
  opXor =        10;
  opCompare =    11;
  opNegate =     12;
  opNot =        13;

  opCmpEQ =      14;
  opCmpNE =      15;
  opCmpLT =      16;
  opCmpLE =      17;
  opCmpGT =      18;
  opCmpGE =      19;

type
  { Dispatch call descriptor }
  PCallDesc = ^TCallDesc;
  TCallDesc = packed record
    CallType: Byte;
    ArgCount: Byte;
    NamedArgCount: Byte;
    ArgTypes: array[0..255] of Byte;
  end;

  PDispDesc = ^TDispDesc;
  TDispDesc = packed record
    DispID: Integer;
    ResType: Byte;
    CallDesc: TCallDesc;
  end;

  PVariantManager = ^TVariantManager;
  {$EXTERNALSYM PVariantManager}
  TVariantManager = record
    VarClear: procedure(var V : Variant);
    VarCopy: procedure(var Dest: Variant; const Source: Variant);
    VarCopyNoInd: procedure; // ARGS PLEASE!
    VarCast: procedure(var Dest: Variant; const Source: Variant; VarType: Integer);
    VarCastOle: procedure(var Dest: Variant; const Source: Variant; VarType: Integer);

    VarToInt: function(const V: Variant): Integer;
    VarToInt64: function(const V: Variant): Int64;
    VarToBool: function(const V: Variant): Boolean;
    VarToReal: function(const V: Variant): Extended;
    VarToCurr: function(const V: Variant): Currency;
    VarToPStr: procedure(var S; const V: Variant);
    VarToLStr: procedure(var S: string; const V: Variant);
    VarToWStr: procedure(var S: WideString; const V: Variant);
    VarToIntf: procedure(var Unknown: IInterface; const V: Variant);
    VarToDisp: procedure(var Dispatch: IDispatch; const V: Variant);
    VarToDynArray: procedure(var DynArray: Pointer; const V: Variant; TypeInfo: Pointer);

    VarFromInt: procedure(var V: Variant; const Value, Range: Integer);
    VarFromInt64: procedure(var V: Variant; const Value: Int64);
    VarFromBool: procedure(var V: Variant; const Value: Boolean);
    VarFromReal: procedure; // var V: Variant; const Value: Real
    VarFromTDateTime: procedure; // var V: Variant; const Value: TDateTime
    VarFromCurr: procedure; // var V: Variant; const Value: Currency
    VarFromPStr: procedure(var V: Variant; const Value: ShortString);
    VarFromLStr: procedure(var V: Variant; const Value: string);
    VarFromWStr: procedure(var V: Variant; const Value: WideString);
    VarFromIntf: procedure(var V: Variant; const Value: IInterface);
    VarFromDisp: procedure(var V: Variant; const Value: IDispatch);
    VarFromDynArray: procedure(var V: Variant; const DynArray: Pointer; TypeInfo: Pointer);
    OleVarFromPStr: procedure(var V: OleVariant; const Value: ShortString);
    OleVarFromLStr: procedure(var V: OleVariant; const Value: string);
    OleVarFromVar: procedure(var V: OleVariant; const Value: Variant);
    OleVarFromInt: procedure(var V: OleVariant; const Value, Range: Integer);

    VarOp: procedure(var Left: Variant; const Right: Variant; OpCode: TVarOp);
    VarCmp: procedure(const Left, Right: TVarData; const OpCode: TVarOp); { result is set in the flags }
    VarNeg: procedure(var V: Variant);
    VarNot: procedure(var V: Variant);

    DispInvoke: procedure(Dest: PVarData; const Source: TVarData;
      CallDesc: PCallDesc; Params: Pointer); cdecl;
    VarAddRef: procedure(var V: Variant);

    VarArrayRedim: procedure(var A : Variant; HighBound: Integer);
    VarArrayGet: function(var A: Variant; IndexCount: Integer;
      Indices: Integer): Variant; cdecl;
    VarArrayPut: procedure(var A: Variant; const Value: Variant;
      IndexCount: Integer; Indices: Integer); cdecl;

    WriteVariant: function(var T: Text; const V: Variant; Width: Integer): Pointer;
    Write0Variant: function(var T: Text; const V: Variant): Pointer;
  end;
  {$EXTERNALSYM TVariantManager}

  { Dynamic array support }
  PDynArrayTypeInfo = ^TDynArrayTypeInfo;
  {$EXTERNALSYM PDynArrayTypeInfo}
  TDynArrayTypeInfo = packed record
    kind: Byte;
    name: string[0];
    elSize: Longint;
    elType: ^PDynArrayTypeInfo;
    varType: Integer;
  end;
  {$EXTERNALSYM TDynArrayTypeInfo}

  PVarRec = ^TVarRec;
  TVarRec = record { do not pack this record; it is compiler-generated }
    case Byte of
      vtInteger:    (VInteger: Integer; VType: Byte);
      vtBoolean:    (VBoolean: Boolean);
      vtChar:       (VChar: Char);
      vtExtended:   (VExtended: PExtended);
      vtString:     (VString: PShortString);
      vtPointer:    (VPointer: Pointer);
      vtPChar:      (VPChar: PChar);
      vtObject:     (VObject: TObject);
      vtClass:      (VClass: TClass);
      vtWideChar:   (VWideChar: WideChar);
      vtPWideChar:  (VPWideChar: PWideChar);
      vtAnsiString: (VAnsiString: Pointer);
      vtCurrency:   (VCurrency: PCurrency);
      vtVariant:    (VVariant: PVariant);
      vtInterface:  (VInterface: Pointer);
      vtWideString: (VWideString: Pointer);
      vtInt64:      (VInt64: PInt64);
  end;

  PMemoryManager = ^TMemoryManager;
  TMemoryManager = record
    GetMem: function(Size: Integer): Pointer;
    FreeMem: function(P: Pointer): Integer;
    ReallocMem: function(P: Pointer; Size: Integer): Pointer;
  end;

  THeapStatus = record
    TotalAddrSpace: Cardinal;
    TotalUncommitted: Cardinal;
    TotalCommitted: Cardinal;
    TotalAllocated: Cardinal;
    TotalFree: Cardinal;
    FreeSmall: Cardinal;
    FreeBig: Cardinal;
    Unused: Cardinal;
    Overhead: Cardinal;
    HeapErrorCode: Cardinal;
  end;

{$IFDEF PC_MAPPED_EXCEPTIONS}
  PUnwinder = ^TUnwinder;
  TUnwinder = record
    RaiseException: function(Exc: Pointer): LongBool; cdecl;
    RegisterIPLookup: function(fn: Pointer; StartAddr, EndAddr: LongInt; Context: Pointer; GOT: LongInt): LongBool; cdecl;
    UnregisterIPLookup: procedure(StartAddr: LongInt) cdecl;
    DelphiLookup: function(Addr: LongInt; Context: Pointer): Pointer; cdecl;
    ClosestHandler: function(Context: Pointer): LongWord; cdecl;
  end;
{$ENDIF PC_MAPPED_EXCEPTIONS}

  PackageUnitEntry = packed record
    Init, FInit : Pointer;
  end;

  { Compiler generated table to be processed sequentially to init & finit all package units }
  { Init: 0..Max-1; Final: Last Initialized..0                                              }
  UnitEntryTable = array [0..9999999] of PackageUnitEntry;
  PUnitEntryTable = ^UnitEntryTable;

  PackageInfoTable = packed record
    UnitCount : Integer;      { number of entries in UnitInfo array; always > 0 }
    UnitInfo : PUnitEntryTable;
  end;

  PackageInfo = ^PackageInfoTable;

  { Each package exports a '@GetPackageInfoTable' which can be used to retrieve }
  { the table which contains compiler generated information about the package DLL }
  GetPackageInfoTable = function : PackageInfo;

{$IFDEF DEBUG_FUNCTIONS}
{ Inspector Query; implementation in GETMEM.INC; no need to conditionalize that }
  THeapBlock = record
    Start: Pointer;
    Size: Cardinal;
  end;

  THeapBlockArray = array of THeapBlock;
  TObjectArray = array of TObject;

function GetHeapBlocks: THeapBlockArray;
function FindObjects(AClass: TClass; FindDerived: Boolean): TObjectArray;
{ Inspector Query }
{$ENDIF}

{
  When an exception is thrown, the exception object that is thrown is destroyed
  automatically when the except clause which handles the exception is exited.
  There are some cases in which an application may wish to acquire the thrown
  object and keep it alive after the except clause is exited.  For this purpose,
  we have added the AcquireExceptionObject and ReleaseExceptionObject functions.
  These functions maintain a reference count on the most current exception object,
  allowing applications to legitimately obtain references.  If the reference count
  for an exception that is being thrown is positive when the except clause is exited,
  then the thrown object is not destroyed by the RTL, but assumed to be in control
  of the application.  It is then the application's responsibility to destroy the
  thrown object.  If the reference count is zero, then the RTL will destroy the
  thrown object when the except clause is exited.
}
function AcquireExceptionObject: Pointer;
procedure ReleaseExceptionObject;

{$IFDEF PC_MAPPED_EXCEPTIONS}
procedure GetUnwinder(var Dest: TUnwinder);
procedure SetUnwinder(const NewUnwinder: TUnwinder);
function IsUnwinderSet: Boolean;

//function SysRegisterIPLookup(ModuleHandle, StartAddr, EndAddr: LongInt; Context: Pointer; GOT: LongInt): LongBool;
{
  Do NOT call these functions.  They are for internal use only:
    SysRegisterIPLookup
    SysUnregisterIPLookup
    BlockOSExceptions
    UnblockOSExceptions
    AreOSExceptionsBlocked
}
function SysRegisterIPLookup(StartAddr, EndAddr: LongInt; Context: Pointer; GOT: LongInt): LongBool;
procedure SysUnregisterIPLookup(StartAddr: LongInt);
//function SysAddressIsInPCMap(Addr: LongInt): Boolean;
function SysClosestDelphiHandler(Context: Pointer): LongWord;
procedure BlockOSExceptions;
procedure UnblockOSExceptions;
function AreOSExceptionsBlocked: Boolean;

{$ELSE}
// These functions are not portable.  Use AcquireExceptionObject above instead
function RaiseList: Pointer; deprecated;  { Stack of current exception objects }
function SetRaiseList(NewPtr: Pointer): Pointer; deprecated;  { returns previous value }
{$ENDIF}

function ExceptObject: TObject;
function ExceptAddr: Pointer;


procedure SetInOutRes(NewValue: Integer);

type
  TAssertErrorProc = procedure (const Message, Filename: string;
    LineNumber: Integer; ErrorAddr: Pointer);
  TSafeCallErrorProc = procedure (ErrorCode: HResult; ErrorAddr: Pointer);

{$IFDEF DEBUG}
{
  This variable is just for debugging the exception handling system.  See
  _DbgExcNotify for the usage.
}
var
  ExcNotificationProc : procedure (  NotificationKind: Integer;
  ExceptionObject: Pointer;
  ExceptionName: PShortString;
  ExceptionLocation: Pointer;
  HandlerAddr: Pointer) = nil;
{$ENDIF}

var
  DispCallByIDProc: Pointer;
  ExceptProc: Pointer;    { Unhandled exception handler }
  ErrorProc: procedure (ErrorCode: Byte; ErrorAddr: Pointer);     { Error handler procedure }
{$IFDEF MSWINDOWS}
  ExceptClsProc: Pointer; { Map an OS Exception to a Delphi class reference }
  ExceptObjProc: Pointer; { Map an OS Exception to a Delphi class instance }
  RaiseExceptionProc: Pointer;
  RTLUnwindProc: Pointer;
{$ENDIF}
  ExceptionClass: TClass; { Exception base class (must be Exception) }
  SafeCallErrorProc: TSafeCallErrorProc; { Safecall error handler }
  AssertErrorProc: TAssertErrorProc; { Assertion error handler }
  ExitProcessProc: procedure; { Hook to be called just before the process actually exits }
  AbstractErrorProc: procedure; { Abstract method error handler }
  HPrevInst: LongWord deprecated;    { Handle of previous instance - HPrevInst cannot be tested for multiple instances in Win32}
  MainInstance: LongWord;   { Handle of the main(.EXE) HInstance }
  MainThreadID: LongWord;   { ThreadID of thread that module was initialized in }
  IsLibrary: Boolean;       { True if module is a DLL }
{$IFDEF MSWINDOWS}
{X} // following variables are converted to functions
{X} function CmdShow : Integer;
{X} function CmdLine : PChar;
{$ELSE}
  CmdShow: Integer platform;       { CmdShow parameter for CreateWindow }
  CmdLine: PChar platform;         { Command line pointer }
{$ENDIF}
var
  InitProc: Pointer;        { Last installed initialization procedure }
  ExitCode: Integer = 0;    { Program result }
  ExitProc: Pointer;        { Last installed exit procedure }
  ErrorAddr: Pointer = nil; { Address of run-time error }
  RandSeed: Longint = 0;    { Base for random number generator }
  IsConsole: Boolean;       { True if compiled as console app }
  IsMultiThread: Boolean;   { True if more than one thread }
  FileMode: Byte = 2;       { Standard mode for opening files }
{$IFDEF LINUX}
  FileAccessRights: Integer platform; { Default access rights for opening files }
  ArgCount: Integer platform;
  ArgValues: PPChar platform;
{$ENDIF}
  Test8086: Byte;         { CPU family (minus one) See consts below }
  Test8087: Byte = 3;     { assume 80387 FPU or OS supplied FPU emulation }
  TestFDIV: Shortint;     { -1: Flawed Pentium, 0: Not determined, 1: Ok }
  Input: Text;            { Standard input }
  Output: Text;           { Standard output }
  ErrOutput: Text;        { Standard error output }
  envp: PPChar platform;

const
  CPUi386     = 2;
  CPUi486     = 3;
  CPUPentium  = 4;

var
  Default8087CW: Word = $1332;{ Default 8087 control word.  FPU control
                                register is set to this value.
                                CAUTION:  Setting this to an invalid value
                                could cause unpredictable behavior. }

  HeapAllocFlags: Word platform = 2;   { Heap allocation flags, gmem_Moveable }
  DebugHook: Byte platform = 0;        { 1 to notify debugger of non-Delphi exceptions
                                >1 to notify debugger of exception unwinding }
  JITEnable: Byte platform = 0;        { 1 to call UnhandledExceptionFilter if the exception
                                is not a Pascal exception.
                                >1 to call UnhandledExceptionFilter for all exceptions }
  NoErrMsg: Boolean platform = False;  { True causes the base RTL to not display the message box
                                when a run-time error occurs }
{$IFDEF LINUX}
                              { CoreDumpEnabled = True will cause unhandled
                                exceptions and runtime errors to raise a
                                SIGABRT signal, which will cause the OS to
                                coredump the process address space.  This can
                                be useful for postmortem debugging. }
  CoreDumpEnabled: Boolean platform = False;
{$ENDIF}

type
(*$NODEFINE TTextLineBreakStyle*)
  TTextLineBreakStyle = (tlbsLF, tlbsCRLF);

var   { Text output line break handling.  Default value for all text files }
  DefaultTextLineBreakStyle: TTextLineBreakStyle = {$IFDEF LINUX} tlbsLF {$ENDIF}
                                                 {$IFDEF MSWINDOWS} tlbsCRLF {$ENDIF};
const
  sLineBreak = {$IFDEF LINUX} #10 {$ENDIF} {$IFDEF MSWINDOWS} #13#10 {$ENDIF};

type
  HRSRC = THandle;
  TResourceHandle = HRSRC;   // make an opaque handle type
  HINST = THandle;
  HMODULE = HINST;
  HGLOBAL = THandle;

{$IFDEF ELF}
{ ELF resources }
function FindResource(ModuleHandle: HMODULE; ResourceName, ResourceType: PChar): TResourceHandle;
function LoadResource(ModuleHandle: HMODULE; ResHandle: TResourceHandle): HGLOBAL;
function SizeofResource(ModuleHandle: HMODULE; ResHandle: TResourceHandle): Integer;
function LockResource(ResData: HGLOBAL): Pointer;
function UnlockResource(ResData: HGLOBAL): LongBool;
function FreeResource(ResData: HGLOBAL): LongBool;
{$ENDIF}

{ Memory manager support }

{X} // By default, now system memory management routines are used
{X} // to allocate memory. This can be slow sometimes, so if You
{X} // want to use custom Borland Delphi memory manager, call follow:
{X} procedure UseDelphiMemoryManager;
{X} function IsDelphiMemoryManagerSet : Boolean;
{X} function MemoryManagerNotUsed : Boolean;

procedure GetMemoryManager(var MemMgr: TMemoryManager);
procedure SetMemoryManager(const MemMgr: TMemoryManager);
{X} // following function is replaced with pointer to one
{X} // (initialized by another)
{X} //function IsMemoryManagerSet: Boolean;
var IsMemoryManagerSet : function : Boolean = MemoryManagerNotUsed;


function SysGetMem(Size: Integer): Pointer;
function SysFreeMem(P: Pointer): Integer;
function SysReallocMem(P: Pointer; Size: Integer): Pointer;

var
  AllocMemCount: Integer; { Number of allocated memory blocks }
  AllocMemSize: Integer;  { Total size of allocated memory blocks }

{$IFDEF MSWINDOWS}
function GetHeapStatus: THeapStatus; platform;
{$ENDIF}

{ Thread support }
type
  TThreadFunc = function(Parameter: Pointer): Integer;
{$IFDEF LINUX}
  TSize_T = Cardinal;

  TSchedParam = record
    sched_priority: Integer;
  end;

  pthread_attr_t = record
    __detachstate,
    __schedpolicy: Integer;
    __schedparam: TSchedParam;
    __inheritsched,
    __scope: Integer;
    __guardsize: TSize_T;
    __stackaddr_set: Integer;
    __stackaddr: Pointer;
    __stacksize: TSize_T;
  end;
  {$EXTERNALSYM pthread_attr_t}
  TThreadAttr = pthread_attr_t;
  PThreadAttr = ^TThreadAttr;

  TBeginThreadProc = function (Attribute: PThreadAttr;
    ThreadFunc: TThreadFunc; Parameter: Pointer;
    var ThreadId: Cardinal): Integer;
  TEndThreadProc = procedure(ExitCode: Integer);

var
  BeginThreadProc: TBeginThreadProc = nil;
  EndThreadProc: TEndThreadProc = nil;
{$ENDIF}

{$IFDEF MSWINDOWS}
function BeginThread(SecurityAttributes: Pointer; StackSize: LongWord;
  ThreadFunc: TThreadFunc; Parameter: Pointer; CreationFlags: LongWord;
  var ThreadId: LongWord): Integer;
{$ENDIF}
{$IFDEF LINUX}
function BeginThread(Attribute: PThreadAttr; ThreadFunc: TThreadFunc;
                     Parameter: Pointer; var ThreadId: Cardinal): Integer;

{$ENDIF}
procedure EndThread(ExitCode: Integer);

{ Standard procedures and functions }

const
{ File mode magic numbers }

  fmClosed = $D7B0;
  fmInput  = $D7B1;
  fmOutput = $D7B2;
  fmInOut  = $D7B3;

{ Text file flags         }
  tfCRLF   = $1;    // Dos compatibility flag, for CR+LF line breaks and EOF checks

type
{ Typed-file and untyped-file record }

  TFileRec = packed record (* must match the size the compiler generates: 332 bytes *)
    Handle: Integer;
    Mode: Word;
    Flags: Word;
    case Byte of
      0: (RecSize: Cardinal);   //  files of record
      1: (BufSize: Cardinal;    //  text files
          BufPos: Cardinal;
          BufEnd: Cardinal;
          BufPtr: PChar;
          OpenFunc: Pointer;
          InOutFunc: Pointer;
          FlushFunc: Pointer;
          CloseFunc: Pointer;
          UserData: array[1..32] of Byte;
          Name: array[0..259] of Char; );
  end;

{ Text file record structure used for Text files }
  PTextBuf = ^TTextBuf;
  TTextBuf = array[0..127] of Char;
  TTextRec = packed record (* must match the size the compiler generates: 460 bytes *)
    Handle: Integer;       (* must overlay with TFileRec *)
    Mode: Word;
    Flags: Word;
    BufSize: Cardinal;
    BufPos: Cardinal;
    BufEnd: Cardinal;
    BufPtr: PChar;
    OpenFunc: Pointer;
    InOutFunc: Pointer;
    FlushFunc: Pointer;
    CloseFunc: Pointer;
    UserData: array[1..32] of Byte;
    Name: array[0..259] of Char;
    Buffer: TTextBuf;
  end;

  TTextIOFunc = function (var F: TTextRec): Integer;
  TFileIOFunc = function (var F: TFileRec): Integer;

procedure SetLineBreakStyle(var T: Text; Style: TTextLineBreakStyle);

procedure ChDir(const S: string); overload;
procedure ChDir(P: PChar); overload;
function Flush(var t: Text): Integer;
procedure _LGetDir(D: Byte; var S: string);
procedure _SGetDir(D: Byte; var S: ShortString);
function IOResult: Integer;
procedure MkDir(const S: string); overload;
procedure MkDir(P: PChar); overload;
procedure Move(const Source; var Dest; Count: Integer);
function ParamCount: Integer;
function ParamStr(Index: Integer): string;
procedure Randomize;
procedure RmDir(const S: string); overload;
procedure RmDir(P: PChar); overload;
function UpCase(Ch: Char): Char;

{ Control 8087 control word }

procedure Set8087CW(NewCW: Word);
function Get8087CW: Word;

{ Wide character support procedures and functions for C++ }
{ These functions should not be used in Delphi code!
 (conversion is implicit in Delphi code)      }

function WideCharToString(Source: PWideChar): string;
function WideCharLenToString(Source: PWideChar; SourceLen: Integer): string;
procedure WideCharToStrVar(Source: PWideChar; var Dest: string);
procedure WideCharLenToStrVar(Source: PWideChar; SourceLen: Integer;
  var Dest: string);
function StringToWideChar(const Source: string; Dest: PWideChar;
  DestSize: Integer): PWideChar;

{ PUCS4Chars returns a pointer to the UCS4 char data in the
  UCS4String array, or a pointer to a null char if UCS4String is empty }

function PUCS4Chars(const S: UCS4String): PUCS4Char;

{ Widestring <-> UCS4 conversion }

function WideStringToUCS4String(const S: WideString): UCS4String;
function UCS4StringToWideString(const S: UCS4String): WideString;

{ PChar/PWideChar Unicode <-> UTF8 conversion }

// UnicodeToUTF8(3):
// UTF8ToUnicode(3):
// Scans the source data to find the null terminator, up to MaxBytes
// Dest must have MaxBytes available in Dest.
// MaxDestBytes includes the null terminator (last char in the buffer will be set to null)
// Function result includes the null terminator.

function UnicodeToUtf8(Dest: PChar; Source: PWideChar; MaxBytes: Integer): Integer; overload; deprecated;
function Utf8ToUnicode(Dest: PWideChar; Source: PChar; MaxChars: Integer): Integer; overload; deprecated;

// UnicodeToUtf8(4):
// UTF8ToUnicode(4):
// MaxDestBytes includes the null terminator (last char in the buffer will be set to null)
// Function result includes the null terminator.
// Nulls in the source data are not considered terminators - SourceChars must be accurate

function UnicodeToUtf8(Dest: PChar; MaxDestBytes: Cardinal; Source: PWideChar; SourceChars: Cardinal): Cardinal; overload;
function Utf8ToUnicode(Dest: PWideChar; MaxDestChars: Cardinal; Source: PChar; SourceBytes: Cardinal): Cardinal; overload;

{ WideString <-> UTF8 conversion }

function UTF8Encode(const WS: WideString): UTF8String;
function UTF8Decode(const S: UTF8String): WideString;

{ Ansi <-> UTF8 conversion }

function AnsiToUtf8(const S: string): UTF8String;
function Utf8ToAnsi(const S: UTF8String): string;

{ OLE string support procedures and functions }

function OleStrToString(Source: PWideChar): string;
procedure OleStrToStrVar(Source: PWideChar; var Dest: string);
function StringToOleStr(const Source: string): PWideChar;

{ Variant manager support procedures and functions }

procedure GetVariantManager(var VarMgr: TVariantManager);
procedure SetVariantManager(const VarMgr: TVariantManager);
function IsVariantManagerSet: Boolean;

{ Variant support procedures and functions }

procedure _VarClear(var V: Variant);
procedure _VarCopy(var Dest: Variant; const Source: Variant);
procedure _VarCopyNoInd;
procedure _VarCast(var Dest: Variant; const Source: Variant; VarType: Integer);
procedure _VarCastOle(var Dest: Variant; const Source: Variant; VarType: Integer);
procedure _VarClr(var V: Variant);

{ Variant text streaming support }

function _WriteVariant(var T: Text; const V: Variant; Width: Integer): Pointer;
function _Write0Variant(var T: Text; const V: Variant): Pointer;

{ Variant math and conversion support }

function _VarToInt(const V: Variant): Integer;
function _VarToInt64(const V: Variant): Int64;
function _VarToBool(const V: Variant): Boolean;
function _VarToReal(const V: Variant): Extended;
function _VarToCurr(const V: Variant): Currency;
procedure _VarToPStr(var S; const V: Variant);
procedure _VarToLStr(var S: string; const V: Variant);
procedure _VarToWStr(var S: WideString; const V: Variant);
procedure _VarToIntf(var Unknown: IInterface; const V: Variant);
procedure _VarToDisp(var Dispatch: IDispatch; const V: Variant);
procedure _VarToDynArray(var DynArray: Pointer; const V: Variant; TypeInfo: Pointer);

procedure _VarFromInt(var V: Variant; const Value, Range: Integer);
procedure _VarFromInt64(var V: Variant; const Value: Int64);
procedure _VarFromBool(var V: Variant; const Value: Boolean);
procedure _VarFromReal; // var V: Variant; const Value: Real
procedure _VarFromTDateTime; // var V: Variant; const Value: TDateTime
procedure _VarFromCurr; // var V: Variant; const Value: Currency
procedure _VarFromPStr(var V: Variant; const Value: ShortString);
procedure _VarFromLStr(var V: Variant; const Value: string);
procedure _VarFromWStr(var V: Variant; const Value: WideString);
procedure _VarFromIntf(var V: Variant; const Value: IInterface);
procedure _VarFromDisp(var V: Variant; const Value: IDispatch);
procedure _VarFromDynArray(var V: Variant; const DynArray: Pointer; TypeInfo: Pointer);
procedure _OleVarFromPStr(var V: OleVariant; const Value: ShortString);
procedure _OleVarFromLStr(var V: OleVariant; const Value: string);
procedure _OleVarFromVar(var V: OleVariant; const Value: Variant);
procedure _OleVarFromInt(var V: OleVariant; const Value, Range: Integer);

procedure _VarAdd(var Left: Variant; const Right: Variant);
procedure _VarSub(var Left: Variant; const Right: Variant);
procedure _VarMul(var Left: Variant; const Right: Variant);
procedure _VarDiv(var Left: Variant; const Right: Variant);
procedure _VarMod(var Left: Variant; const Right: Variant);
procedure _VarAnd(var Left: Variant; const Right: Variant);
procedure _VarOr(var Left: Variant; const Right: Variant);
procedure _VarXor(var Left: Variant; const Right: Variant);
procedure _VarShl(var Left: Variant; const Right: Variant);
procedure _VarShr(var Left: Variant; const Right: Variant);
procedure _VarRDiv(var Left: Variant; const Right: Variant);

procedure _VarCmpEQ(const Left, Right: Variant); // result is set in the flags
procedure _VarCmpNE(const Left, Right: Variant); // result is set in the flags
procedure _VarCmpLT(const Left, Right: Variant); // result is set in the flags
procedure _VarCmpLE(const Left, Right: Variant); // result is set in the flags
procedure _VarCmpGT(const Left, Right: Variant); // result is set in the flags
procedure _VarCmpGE(const Left, Right: Variant); // result is set in the flags

procedure _VarNeg(var V: Variant);
procedure _VarNot(var V: Variant);

{ Variant dispatch and reference support }

procedure _DispInvoke; cdecl; // Dest: PVarData; const Source: TVarData;
                              // CallDesc: PCallDesc; Params: Pointer
procedure _IntfDispCall; cdecl; // ARGS PLEASE!
procedure _IntfVarCall; cdecl; // ARGS PLEASE!
procedure _VarAddRef(var V: Variant);

{ Variant array support procedures and functions }

procedure _VarArrayRedim(var A : Variant; HighBound: Integer);
function _VarArrayGet(var A: Variant; IndexCount: Integer;
  Indices: Integer): Variant; cdecl;
procedure _VarArrayPut(var A: Variant; const Value: Variant;
  IndexCount: Integer; Indices: Integer); cdecl;

{ Package/Module registration and unregistration }

type
  PLibModule = ^TLibModule;
  TLibModule = record
    Next: PLibModule;
    Instance: LongWord;
    CodeInstance: LongWord;
    DataInstance: LongWord;
    ResInstance: LongWord;
    Reserved: Integer;
{$IFDEF LINUX}
    InstanceVar: Pointer platform;
    GOT: LongWord platform;
    CodeSegStart: LongWord platform;
    CodeSegEnd: LongWord platform;
    InitTable: Pointer platform;
{$ENDIF}
  end;

  TEnumModuleFunc = function (HInstance: Integer; Data: Pointer): Boolean;
  {$EXTERNALSYM TEnumModuleFunc}
  TEnumModuleFuncLW = function (HInstance: LongWord; Data: Pointer): Boolean;
  {$EXTERNALSYM TEnumModuleFuncLW}
  TModuleUnloadProc = procedure (HInstance: Integer);
  {$EXTERNALSYM TModuleUnloadProc}
  TModuleUnloadProcLW = procedure (HInstance: LongWord);
  {$EXTERNALSYM TModuleUnloadProcLW}

  PModuleUnloadRec = ^TModuleUnloadRec;
  TModuleUnloadRec = record
    Next: PModuleUnloadRec;
    Proc: TModuleUnloadProcLW;
  end;

var
  LibModuleList: PLibModule = nil;
  ModuleUnloadList: PModuleUnloadRec = nil;

procedure RegisterModule(LibModule: PLibModule);
{X procedure UnregisterModule(LibModule: PLibModule); -replaced with pointer to procedure }
{X} procedure UnregisterModuleLight(LibModule: PLibModule);
{X} procedure UnregisterModuleSafely(LibModule: PLibModule);
var UnregisterModule : procedure(LibModule: PLibModule) = UnregisterModuleLight;
function FindHInstance(Address: Pointer): LongWord;
function FindClassHInstance(ClassType: TClass): LongWord;
function FindResourceHInstance(Instance: LongWord): LongWord;
function LoadResourceModule(ModuleName: PChar; CheckOwner: Boolean = True): LongWord;
procedure EnumModules(Func: TEnumModuleFunc; Data: Pointer); overload;
procedure EnumResourceModules(Func: TEnumModuleFunc; Data: Pointer); overload;
procedure EnumModules(Func: TEnumModuleFuncLW; Data: Pointer); overload;
procedure EnumResourceModules(Func: TEnumModuleFuncLW; Data: Pointer); overload;
procedure AddModuleUnloadProc(Proc: TModuleUnloadProc); overload;
procedure RemoveModuleUnloadProc(Proc: TModuleUnloadProc); overload;
procedure AddModuleUnloadProc(Proc: TModuleUnloadProcLW); overload;
procedure RemoveModuleUnloadProc(Proc: TModuleUnloadProcLW); overload;
{$IFDEF LINUX}
{ Given an HMODULE, this function will return its fully qualified name.  There is
  no direct equivalent in Linux so this function provides that capability. }
function GetModuleFileName(Module: HMODULE; Buffer: PChar; BufLen: Integer): Integer;
{$ENDIF}

{ ResString support function/record }

type
  PResStringRec = ^TResStringRec;
  TResStringRec = packed record
    Module: ^Cardinal;
    Identifier: Integer;
  end;

function LoadResString(ResStringRec: PResStringRec): string;

{ Procedures and functions that need compiler magic }

procedure _COS;
procedure _EXP;
procedure _INT;
procedure _SIN;
procedure _FRAC;
procedure _ROUND;
procedure _TRUNC;

procedure _AbstractError;
procedure _Assert(const Message, Filename: AnsiString; LineNumber: Integer);
function _Append(var t: TTextRec): Integer;
function _Assign(var t: TTextRec; const S: String): Integer;
function _BlockRead(var f: TFileRec; buffer: Pointer; recCnt: Longint; var recsRead: Longint): Longint;
function  _BlockWrite(var f: TFileRec; buffer: Pointer; recCnt: Longint; var recsWritten: Longint): Longint;
function _Close(var t: TTextRec): Integer;
procedure _PStrCat;
procedure _PStrNCat;
procedure _PStrCpy(Dest: PShortString; Source: PShortString);
procedure _PStrNCpy(Dest: PShortString; Source: PShortString; MaxLen: Byte);
function _EofFile(var f: TFileRec): Boolean;
function _EofText(var t: TTextRec): Boolean;
function _Eoln(var t: TTextRec): Boolean;
procedure _Erase(var f: TFileRec);
function _FilePos(var f: TFileRec): Longint;
function _FileSize(var f: TFileRec): Longint;
procedure _FillChar(var Dest; count: Integer; Value: Char);
function _FreeMem(P: Pointer): Integer;
function _GetMem(Size: Integer): Pointer;
function _ReallocMem(var P: Pointer; NewSize: Integer): Pointer;
procedure _Halt(Code: Integer);
procedure _Halt0;
procedure Mark; deprecated;
procedure _PStrCmp;
procedure _AStrCmp;
procedure _RandInt;
procedure _RandExt;
function _ReadRec(var f: TFileRec; Buffer: Pointer): Integer;
function _ReadChar(var t: TTextRec): Char;
function _ReadLong(var t: TTextRec): Longint;
procedure _ReadString(var t: TTextRec; s: PShortString; maxLen: Longint);
procedure _ReadCString(var t: TTextRec; s: PChar; maxLen: Longint);
procedure _ReadLString(var t: TTextRec; var s: AnsiString);
procedure _ReadWString(var t: TTextRec; var s: WideString);
procedure _ReadWCString(var t: TTextRec; s: PWideChar; maxBytes: Longint);
function _ReadWChar(var t: TTextRec): WideChar;
function _ReadExt(var t: TTextRec): Extended;
procedure _ReadLn(var t: TTextRec);
procedure _Rename(var f: TFileRec; newName: PChar);
procedure Release; deprecated;
function _ResetText(var t: TTextRec): Integer;
function _ResetFile(var f: TFileRec; recSize: Longint): Integer;
function _RewritText(var t: TTextRec): Integer;
function _RewritFile(var f: TFileRec; recSize: Longint): Integer;
procedure _RunError(errorCode: Byte);
procedure _Run0Error;
procedure _Seek(var f: TFileRec; recNum: Cardinal);
function _SeekEof(var t: TTextRec): Boolean;
function _SeekEoln(var t: TTextRec): Boolean;
procedure _SetTextBuf(var t: TTextRec; p: Pointer; size: Longint);
procedure _StrLong(val, width: Longint; s: PShortString);
procedure _Str0Long(val: Longint; s: PShortString);
procedure _Truncate(var f: TFileRec);
function _ValLong(const s: String; var code: Integer): Longint;
{$IFDEF LINUX}
procedure _UnhandledException;
{$ENDIF}
function _WriteRec(var f: TFileRec; buffer: Pointer): Pointer;
function _WriteChar(var t: TTextRec; c: Char; width: Integer): Pointer;
function _Write0Char(var t: TTextRec; c: Char): Pointer;
function _WriteBool(var t: TTextRec; val: Boolean; width: Longint): Pointer;
function _Write0Bool(var t: TTextRec; val: Boolean): Pointer;
function _WriteLong(var t: TTextRec; val, width: Longint): Pointer;
function _Write0Long(var t: TTextRec; val: Longint): Pointer;
function _WriteString(var t: TTextRec; const s: ShortString; width: Longint): Pointer;
function _Write0String(var t: TTextRec; const s: ShortString): Pointer;
function _WriteCString(var t: TTextRec; s: PChar; width: Longint): Pointer;
function _Write0CString(var t: TTextRec; s: PChar): Pointer;
function _Write0LString(var t: TTextRec; const s: AnsiString): Pointer;
function _WriteLString(var t: TTextRec; const s: AnsiString; width: Longint): Pointer;
function _Write0WString(var t: TTextRec; const s: WideString): Pointer;
function _WriteWString(var t: TTextRec; const s: WideString; width: Longint): Pointer;
function _WriteWCString(var t: TTextRec; s: PWideChar; width: Longint): Pointer;
function _Write0WCString(var t: TTextRec; s: PWideChar): Pointer;
function _WriteWChar(var t: TTextRec; c: WideChar; width: Integer): Pointer;
function _Write0WChar(var t: TTextRec; c: WideChar): Pointer;
procedure _Write2Ext;
procedure _Write1Ext;
procedure _Write0Ext;
function _WriteLn(var t: TTextRec): Pointer;

procedure __CToPasStr(Dest: PShortString; const Source: PChar);
procedure __CLenToPasStr(Dest: PShortString; const Source: PChar; MaxLen: Integer);
procedure __ArrayToPasStr(Dest: PShortString; const Source: PChar; Len: Integer);
procedure __PasToCStr(const Source: PShortString; const Dest: PChar);

procedure __IOTest;
function _Flush(var t: TTextRec): Integer;

procedure _SetElem;
procedure _SetRange;
procedure _SetEq;
procedure _SetLe;
procedure _SetIntersect;
procedure _SetIntersect3; { BEG only }
procedure _SetUnion;
procedure _SetUnion3; { BEG only }
procedure _SetSub;
procedure _SetSub3; { BEG only }
procedure _SetExpand;

procedure _Str2Ext;
procedure _Str0Ext;
procedure _Str1Ext;
procedure _ValExt;
procedure _Pow10;
procedure _Real2Ext;
procedure _Ext2Real;

procedure _ObjSetup;
procedure _ObjCopy;
procedure _Fail;
procedure _BoundErr;
procedure _IntOver;

{ Module initialization context.  For internal use only. }

type
  PInitContext = ^TInitContext;
  TInitContext = record
    OuterContext:   PInitContext;     { saved InitContext   }
{$IFNDEF PC_MAPPED_EXCEPTIONS}
    ExcFrame:       Pointer;          { bottom exc handler  }
{$ENDIF}
    InitTable:      PackageInfo;      { unit init info      }
    InitCount:      Integer;          { how far we got      }
    Module:         PLibModule;       { ptr to module desc  }
    DLLSaveEBP:     Pointer;          { saved regs for DLLs }
    DLLSaveEBX:     Pointer;          { saved regs for DLLs }
    DLLSaveESI:     Pointer;          { saved regs for DLLs }
    DLLSaveEDI:     Pointer;          { saved regs for DLLs }
{$IFDEF MSWINDOWS}
    ExitProcessTLS: procedure;        { Shutdown for TLS    }
{$ENDIF}
    DLLInitState:   Byte;             { 0 = package, 1 = DLL shutdown, 2 = DLL startup }
  end platform;

type
  TDLLProc = procedure (Reason: Integer);
  // TDLLProcEx provides the reserved param returned by WinNT
  TDLLProcEx = procedure (Reason: Integer; Reserved: Integer);

{$IFDEF LINUX}
procedure _StartExe(InitTable: PackageInfo; Module: PLibModule; Argc: Integer; Argv: Pointer);
procedure _StartLib(Context: PInitContext; Module: PLibModule; DLLProc: TDLLProcEx);
{$ENDIF}
{$IFDEF MSWINDOWS}
procedure _StartExe(InitTable: PackageInfo; Module: PLibModule);
procedure _StartLib;
{$ENDIF}
procedure _PackageLoad(const Table : PackageInfo; Module: PLibModule);
procedure _PackageUnload(const Table : PackageInfo; Module: PLibModule);
procedure _InitResStrings;
procedure _InitResStringImports;
procedure _InitImports;
{$IFDEF MSWINDOWS}
procedure _InitWideStrings;
{$ENDIF}

function _ClassCreate(AClass: TClass; Alloc: Boolean): TObject;
procedure _ClassDestroy(Instance: TObject);
function _AfterConstruction(Instance: TObject): TObject;
function _BeforeDestruction(Instance: TObject; OuterMost: ShortInt): TObject;
function _IsClass(Child: TObject; Parent: TClass): Boolean;
function _AsClass(Child: TObject; Parent: TClass): TObject;

{$IFDEF PC_MAPPED_EXCEPTIONS}
procedure _RaiseAtExcept;
//procedure _DestroyException(Exc: PRaisedException);
procedure _DestroyException;
{$ENDIF}
procedure _RaiseExcept;
procedure _RaiseAgain;
procedure _DoneExcept;
{$IFNDEF PC_MAPPED_EXCEPTIONS}
procedure _TryFinallyExit;
{$ENDIF}
procedure _HandleAnyException;
procedure _HandleFinally;
procedure _HandleOnException;
{$IFDEF PC_MAPPED_EXCEPTIONS}
procedure _HandleOnExceptionPIC;
{$ENDIF}
procedure _HandleAutoException;
{$IFDEF PC_MAPPED_EXCEPTIONS}
procedure _ClassHandleException;
{$ENDIF}

procedure _CallDynaInst;
procedure _CallDynaClass;
procedure _FindDynaInst;
procedure _FindDynaClass;

procedure _LStrClr(var S);
procedure _LStrArrayClr(var StrArray; cnt: longint);
procedure _LStrAsg(var dest; const source);
procedure _LStrLAsg(var dest; const source);
procedure _LStrFromPCharLen(var Dest: AnsiString; Source: PAnsiChar; Length: Integer);
procedure _LStrFromPWCharLen(var Dest: AnsiString; Source: PWideChar; Length: Integer);
procedure _LStrFromChar(var Dest: AnsiString; Source: AnsiChar);
procedure _LStrFromWChar(var Dest: AnsiString; Source: WideChar);
procedure _LStrFromPChar(var Dest: AnsiString; Source: PAnsiChar);
procedure _LStrFromPWChar(var Dest: AnsiString; Source: PWideChar);
procedure _LStrFromString(var Dest: AnsiString; const Source: ShortString);
procedure _LStrFromArray(var Dest: AnsiString; Source: PAnsiChar; Length: Integer);
procedure _LStrFromWArray(var Dest: AnsiString; Source: PWideChar; Length: Integer);
procedure _LStrFromWStr(var Dest: AnsiString; const Source: WideString);
procedure _LStrToString{(var Dest: ShortString; const Source: AnsiString; MaxLen: Integer)};
function _LStrLen(const s: AnsiString): Longint;
procedure _LStrCat{var dest: AnsiString; source: AnsiString};
procedure _LStrCat3{var dest:AnsiString; source1: AnsiString; source2: AnsiString};
procedure _LStrCatN{var dest:AnsiString; argCnt: Integer; ...};
procedure _LStrCmp{left: AnsiString; right: AnsiString};
function _LStrAddRef(var str): Pointer;
function _LStrToPChar(const s: AnsiString): PChar;
procedure _Copy{ s : ShortString; index, count : Integer ) : ShortString};
procedure _Delete{ var s : openstring; index, count : Integer };
procedure _Insert{ source : ShortString; var s : openstring; index : Integer };
procedure _Pos{ substr : ShortString; s : ShortString ) : Integer};
procedure _SetLength(s: PShortString; newLength: Byte);
procedure _SetString(s: PShortString; buffer: PChar; len: Byte);

procedure UniqueString(var str: AnsiString); overload;
procedure UniqueString(var str: WideString); overload;
procedure _UniqueStringA(var str: AnsiString);
procedure _UniqueStringW(var str: WideString);


procedure _LStrCopy  { const s : AnsiString; index, count : Integer) : AnsiString};
procedure _LStrDelete{ var s : AnsiString; index, count : Integer };
procedure _LStrInsert{ const source : AnsiString; var s : AnsiString; index : Integer };
procedure _LStrPos{ const substr : AnsiString; const s : AnsiString ) : Integer};
procedure _LStrSetLength{ var str: AnsiString; newLength: Integer};
procedure _LStrOfChar{ c: Char; count: Integer): AnsiString };
function _NewAnsiString(length: Longint): Pointer;      { for debugger purposes only }
function _NewWideString(CharLength: Longint): Pointer;

procedure _WStrClr(var S);
procedure _WStrArrayClr(var StrArray; Count: Integer);
procedure _WStrAsg(var Dest: WideString; const Source: WideString);
procedure _WStrLAsg(var Dest: WideString; const Source: WideString);
function _WStrToPWChar(const S: WideString): PWideChar;
function _WStrLen(const S: WideString): Integer;
procedure _WStrFromPCharLen(var Dest: WideString; Source: PAnsiChar; Length: Integer);
procedure _WStrFromPWCharLen(var Dest: WideString; Source: PWideChar; CharLength: Integer);
procedure _WStrFromChar(var Dest: WideString; Source: AnsiChar);
procedure _WStrFromWChar(var Dest: WideString; Source: WideChar);
procedure _WStrFromPChar(var Dest: WideString; Source: PAnsiChar);
procedure _WStrFromPWChar(var Dest: WideString; Source: PWideChar);
procedure _WStrFromString(var Dest: WideString; const Source: ShortString);
procedure _WStrFromArray(var Dest: WideString; Source: PAnsiChar; Length: Integer);
procedure _WStrFromWArray(var Dest: WideString; Source: PWideChar; Length: Integer);
procedure _WStrFromLStr(var Dest: WideString; const Source: AnsiString);
procedure _WStrToString(Dest: PShortString; const Source: WideString; MaxLen: Integer);
procedure _WStrCat(var Dest: WideString; const Source: WideString);
procedure _WStrCat3(var Dest: WideString; const Source1, Source2: WideString);
procedure _WStrCatN{var dest:WideString; argCnt: Integer; ...};
procedure _WStrCmp{left: WideString; right: WideString};
function _WStrCopy(const S: WideString; Index, Count: Integer): WideString;
procedure _WStrDelete(var S: WideString; Index, Count: Integer);
procedure _WStrInsert(const Source: WideString; var Dest: WideString; Index: Integer);
procedure _WStrPos{ const substr : WideString; const s : WideString ) : Integer};
procedure _WStrSetLength(var S: WideString; NewLength: Integer);
function _WStrOfWChar(Ch: WideChar; Count: Integer): WideString;
function _WStrAddRef(var str: WideString): Pointer;

procedure _Initialize(p: Pointer; typeInfo: Pointer);
procedure _InitializeArray(p: Pointer; typeInfo: Pointer; elemCount: Cardinal);
procedure _InitializeRecord(p: Pointer; typeInfo: Pointer);
procedure _Finalize(p: Pointer; typeInfo: Pointer);
procedure _FinalizeArray(p: Pointer; typeInfo: Pointer; elemCount: Cardinal);
procedure _FinalizeRecord(P: Pointer; typeInfo: Pointer);
procedure _AddRef;
procedure _AddRefArray;
procedure _AddRefRecord;
procedure _CopyArray;
procedure _CopyRecord;
procedure _CopyObject;

function _New(size: Longint; typeInfo: Pointer): Pointer;
procedure _Dispose(p: Pointer; typeInfo: Pointer);

{ 64-bit Integer helper routines }
procedure __llmul;
procedure __lldiv;
procedure __lludiv;
procedure __llmod;
procedure __llmulo;
procedure __lldivo;
procedure __llmodo;
procedure __llumod;
procedure __llshl;
procedure __llushr;
procedure _WriteInt64;
procedure _Write0Int64;
procedure _ReadInt64;
function _StrInt64(val: Int64; width: Integer): ShortString;
function _Str0Int64(val: Int64): ShortString;
function _ValInt64(const s: AnsiString; var code: Integer): Int64;

{ Dynamic array helper functions }

procedure _DynArrayHigh;
procedure _DynArrayClear(var a: Pointer; typeInfo: Pointer);
procedure _DynArrayLength;
procedure _DynArraySetLength;
procedure _DynArrayCopy(a: Pointer; typeInfo: Pointer; var Result: Pointer);
procedure _DynArrayCopyRange(a: Pointer; typeInfo: Pointer; index, count : Integer; var Result: Pointer);
procedure _DynArrayAsg;
procedure _DynArrayAddRef;

procedure DynArrayClear(var a: Pointer; typeInfo: Pointer);
procedure DynArraySetLength(var a: Pointer; typeInfo: Pointer; dimCnt: Longint; lengthVec: PLongint);
function DynArrayDim(typeInfo: PDynArrayTypeInfo): Integer;
{$NODEFINE DynArrayDim}

function _IntfClear(var Dest: IInterface): Pointer;
procedure _IntfCopy(var Dest: IInterface; const Source: IInterface);
procedure _IntfCast(var Dest: IInterface; const Source: IInterface; const IID: TGUID);
procedure _IntfAddRef(const Dest: IInterface);

{$IFDEF MSWINDOWS}
procedure _FSafeDivide;
procedure _FSafeDivideR;
{$ENDIF}

function _CheckAutoResult(ResultCode: HResult): HResult;

procedure FPower10;

procedure TextStart; deprecated;

// Conversion utility routines for C++ convenience.  Not for Delphi code.
function  CompToDouble(Value: Comp): Double; cdecl;
procedure DoubleToComp(Value: Double; var Result: Comp); cdecl;
function  CompToCurrency(Value: Comp): Currency; cdecl;
procedure CurrencyToComp(Value: Currency; var Result: Comp); cdecl;

function GetMemory(Size: Integer): Pointer; cdecl;
function FreeMemory(P: Pointer): Integer; cdecl;
function ReallocMemory(P: Pointer; Size: Integer): Pointer; cdecl;

{ Internal runtime error codes }

type
  TRuntimeError = (reNone, reOutOfMemory, reInvalidPtr, reDivByZero,
  reRangeError, reIntOverflow, reInvalidOp, reZeroDivide, reOverflow,
  reUnderflow, reInvalidCast, reAccessViolation, rePrivInstruction,
  reControlBreak, reStackOverflow,
  { reVar* used in Variants.pas }
  reVarTypeCast, reVarInvalidOp,
  reVarDispatch, reVarArrayCreate, reVarNotArray, reVarArrayBounds,
  reAssertionFailed,
  reExternalException, { not used here; in SysUtils }
  reIntfCastError, reSafeCallError);
{$NODEFINE TRuntimeError}

procedure Error(errorCode: TRuntimeError);
{$NODEFINE Error}

{ GetLastError returns the last error reported by an OS API call.  Calling
  this function usually resets the OS error state.
}

function GetLastError: Integer; {$IFDEF MSWINDOWS} stdcall; {$ENDIF}
{$EXTERNALSYM GetLastError}

{ SetLastError writes to the thread local storage area read by GetLastError. }

procedure SetLastError(ErrorCode: Integer); {$IFDEF MSWINDOWS} stdcall; {$ENDIF}

{$IFDEF LINUX}
{  To improve performance, some RTL routines cache module handles and data
   derived from modules.  If an application dynamically loads and unloads
   shared object libraries, packages, or resource packages, it is possible for
   the handle of the newly loaded module to match the handle of a recently
   unloaded module.  The resource caches have no way to detect when this happens.

   To address this issue, the RTL maintains an internal counter that is
   incremented every time a module is loaded or unloaded using RTL functions
   (like LoadPackage).  This provides a cache version level signature that
   can detect when modules have been cycled but have the same handle.

   If you load or unload modules "by hand" using dlopen or dlclose, you must call
   InvalidateModuleCache after each load or unload so that the RTL module handle
   caches will refresh themselves properly the next time they are used.  This is
   especially important if you manually tinker with the LibModuleList list of
   loaded modules, or manually add or remove resource modules in the nodes
   of that list.

   ModuleCacheID returns the "current generation" or version number kept by
   the RTL.  You can use this to implement your own refresh-on-next-use
   (passive) module handle caches as the RTL does.  The value changes each
   time InvalidateModuleCache is called.
}

function ModuleCacheID: Cardinal;
procedure InvalidateModuleCache;
{$ENDIF}

{$IFDEF LINUX}
{  When a process that is being debugged is stopped while it has the mouse
   pointer grabbed, there is no way for the debugger to release the grab on
   behalf of the process. The process needs to do it itself. To accomplish this,
   the debugger causes DbgUnlockX to execute whenever it detects the process
   might have the mouse grabbed. This method will call through DbgUnlockXProc
   which should be assigned by any library using X and locks the X pointer. This
   method should be chained, by storing of the previous instance and calling it
   when you are called, since there might be more than one display that needs
   to be unlocked. This method should call XUngrabPointer on the display that
   has the pointer grabbed.
}
var
  DbgUnlockXProc: procedure;

procedure DbgUnlockX;
{$ENDIF}

{X+ moved here from SysInit.pas - by advise of Alexey Torgashin - to avoid
               creating of separate import block from kernel32.dll : }
//////////////////////////////////////////////////////////////////////////

function FreeLibrary(ModuleHandle: Longint): LongBool; stdcall;
function GetModuleFileName(Module: Integer; Filename: PChar; Size: Integer): Integer; stdcall;
function GetModuleHandle(ModuleName: PChar): Integer; stdcall;
function LocalAlloc(flags, size: Integer): Pointer; stdcall;
function LocalFree(addr: Pointer): Pointer; stdcall;
function TlsAlloc: Integer; stdcall;
function TlsFree(TlsIndex: Integer): Boolean; stdcall;
function TlsGetValue(TlsIndex: Integer): Pointer; stdcall;
function TlsSetValue(TlsIndex: Integer; TlsValue: Pointer): Boolean; stdcall;
function GetCommandLine: PChar; stdcall;
{X-}//////////////////////////////////////////////////////////////////////

{X+}
{X}function GetProcessHeap: THandle; stdcall;
{X}function HeapAlloc(hHeap: THandle; dwFlags, dwBytes: Cardinal): Pointer; stdcall;
{X}function HeapReAlloc(hHeap: THandle; dwFlags: Cardinal; lpMem: Pointer; dwBytes: Cardinal): Pointer; stdcall;
{X}function HeapFree(hHeap: THandle; dwFlags: Cardinal; lpMem: Pointer): LongBool; stdcall;
{X}function DfltGetMem(size: Integer): Pointer;
{X}function DfltFreeMem(p: Pointer): Integer;
{X}function DfltReallocMem(p: Pointer; size: Integer): Pointer;
{X} procedure InitUnitsLight( Table : PUnitEntryTable; Idx, Count : Integer );
{X} procedure FInitUnitsLight;
{X} // following two procedures are optional and exclusive.
{X} // call it to provide error message: first - for GUI app,
{X} // second - for console app.
{X} procedure UseErrorMessageBox;
{X} procedure UseErrorMessageWrite;

{X} // call following procedure to initialize Input and Output
{X} // - for console app only:
{X} procedure UseInputOutput;

{X} // if your app uses FPU, call one of following procedures:
{X} procedure FpuInit;
{X} procedure FpuInitConsiderNECWindows;
{X} // the second additionally takes into consideration NEC
{X} // Windows keyboard (Japaneeze keyboard ???).

{X} procedure DummyProc; // empty procedure

(*
{X} procedure VariantClr;
{X} // procedure to refer to _VarClr if SysVarnt.pas is in use
{X} var VarClrProc : procedure = DummyProc;

{X} procedure VarCastError;
{X} procedure VarInvalidOp;

{X} procedure VariantAddRef;
{X} // procedure to refer to _VarAddRef if SysVarnt.pas is in use
{X} var VarAddRefProc : procedure = DummyProc;
*)

{X} procedure WStrAddRef;
{X} // procedure to refer to _WStrAddRef if SysWStr.pas is in use
{X} var WStrAddRefProc : procedure = DummyProc;

{X} procedure WStrClr;
{X} // procedure to refer to _WStrClr if SysWStr.pas is in use
{X} var WStrClrProc : procedure = DummyProc;

{X} procedure WStrArrayClr;
{X} // procedure to refer to _WStrArrayClr if SysWStr.pas is in use
{X} var WStrArrayClrProc : procedure = DummyProc;

{X} // Standard Delphi units initialization/finalization uses
{X} // try-except and raise constructions, which leads to permanent
{X} // usage of all exception handling routines. In this XCL-aware
{X} // implementation, "light" version of initialization/finalization
{X} // is used by default. To use standard Delphi initialization and
{X} // finalization method, allowing to flow execution control even
{X} // in initalization sections, include reference to SysSfIni.pas
{X} // into uses clause *as first as possible*.
{X} procedure InitUnitsHard( Table : PUnitEntryTable; Idx, Count : Integer );
{X} var InitUnitsProc : procedure( Table : PUnitEntryTable; Idx, Count : Integer )
{X}        = InitUnitsLight;
{X} procedure FInitUnitsHard;
{X} var FInitUnitsProc : procedure = FInitUnitsLight;
{X} procedure SetExceptionHandler;
{X} procedure UnsetExceptionHandler;
{X} var UnsetExceptionHandlerProc : procedure = DummyProc;

{X} var UnloadResProc: procedure = DummyProc;
{X-}

(* =================================================================== *)

implementation

uses
  SysInit;

{ This procedure should be at the very beginning of the }
{ text segment. It used to be used by _RunError to find    }
{ start address of the text segment, but is not used anymore.  }

procedure TextStart;
begin
end;

{X+}
const
  advapi32 = 'advapi32.dll';
  kernel = 'kernel32.dll';
  user = 'user32.dll';
  oleaut = 'oleaut32.dll';
  
function GetProcessHeap; external kernel name 'GetProcessHeap';
function HeapAlloc; stdcall; external kernel name 'HeapAlloc';
function HeapReAlloc; stdcall; external kernel name 'HeapReAlloc';
function HeapFree; stdcall; external kernel name 'HeapFree';
{X-}

{$IFDEF PIC}
function GetGOT: LongWord; export;
begin
  asm
  MOV Result,EBX
  end;
end;
{$ENDIF}

{$IFDEF PC_MAPPED_EXCEPTIONS}
const
  UNWINDFI_TOPOFSTACK =   $BE00EF00;

{$IFDEF MSWINDOWS}
const
  unwind = 'unwind.dll';

type
  UNWINDPROC  = Pointer;
function UnwindRegisterIPLookup(fn: UNWINDPROC; StartAddr, EndAddr: LongInt; Context: Pointer; GOT: LongInt): LongBool; cdecl;
  external unwind name '__BorUnwind_RegisterIPLookup';

function UnwindDelphiLookup(Addr: LongInt; Context: Pointer): UNWINDPROC; cdecl;
  external unwind name '__BorUnwind_DelphiLookup';

function UnwindRaiseException(Exc: Pointer): LongBool; cdecl;
  external unwind name '__BorUnwind_RaiseException';

function UnwindClosestHandler(Context: Pointer): LongWord; cdecl;
  external unwind name '__BorUnwind_ClosestDelphiHandler';
{$ENDIF}
{$IFDEF LINUX}
const
  unwind = 'libborunwind.so.6';
type
  UNWINDPROC  = Pointer;

{$DEFINE STATIC_UNWIND}

{$IFDEF STATIC_UNWIND}
function _BorUnwind_RegisterIPLookup(fn: UNWINDPROC; StartAddr, EndAddr: LongInt; Context: Pointer; GOT: LongInt): LongBool; cdecl;
  external;

procedure _BorUnwind_UnregisterIPLookup(StartAddr: LongInt); cdecl;  external;

function _BorUnwind_DelphiLookup(Addr: LongInt; Context: Pointer): UNWINDPROC; cdecl;  external;

function _BorUnwind_RaiseException(Exc: Pointer): LongBool; cdecl;  external;

//function _BorUnwind_AddressIsInPCMap(Addr: LongInt): LongBool; cdecl; external;
function _BorUnwind_ClosestDelphiHandler(Context: Pointer): LongWord; cdecl; external;
{$ELSE}

function _BorUnwind_RegisterIPLookup(fn: UNWINDPROC; StartAddr, EndAddr: LongInt; Context: Pointer; GOT: LongInt): LongBool; cdecl;
  external unwind name '_BorUnwind_RegisterIPLookup';

procedure _BorUnwind_UnregisterIPLookup(StartAddr: LongInt); cdecl;
  external unwind name '_BorUnwind_UnregisterIPLookup';

function _BorUnwind_DelphiLookup(Addr: LongInt; Context: Pointer): UNWINDPROC; cdecl;
  external unwind name '_BorUnwind_DelphiLookup';

function _BorUnwind_RaiseException(Exc: Pointer): LongBool; cdecl;
  external unwind name '_BorUnwind_RaiseException';

function _BorUnwind_ClosestDelphiHandler(Context: Pointer): LongWord; cdecl;
  external unwind name '_BorUnwind_ClosestDelphiHandler';
{$ENDIF}
{$ENDIF}
{$ENDIF}

const { copied from xx.h }
  cContinuable        = 0;
  cNonContinuable     = 1;
  cUnwinding          = 2;
  cUnwindingForExit   = 4;
  cUnwindInProgress   = cUnwinding or cUnwindingForExit;
  cDelphiException    = $0EEDFADE;
  cDelphiReRaise      = $0EEDFADF;
  cDelphiExcept       = $0EEDFAE0;
  cDelphiFinally      = $0EEDFAE1;
  cDelphiTerminate    = $0EEDFAE2;
  cDelphiUnhandled    = $0EEDFAE3;
  cNonDelphiException = $0EEDFAE4;
  cDelphiExitFinally  = $0EEDFAE5;
  cCppException       = $0EEFFACE; { used by BCB }
  EXCEPTION_CONTINUE_SEARCH    = 0;
  EXCEPTION_EXECUTE_HANDLER    = 1;
  EXCEPTION_CONTINUE_EXECUTION = -1;

{$IFDEF PC_MAPPED_EXCEPTIONS}
const
  excIsBeingHandled     = $00000001;
  excIsBeingReRaised    = $00000002;
{$ENDIF}

type
  JmpInstruction =
  packed record
    opCode:   Byte;
    distance: Longint;
  end;
  TExcDescEntry =
  record
    vTable:  Pointer;
    handler: Pointer;
  end;
  PExcDesc = ^TExcDesc;
  TExcDesc =
  packed record
{$IFNDEF PC_MAPPED_EXCEPTIONS}
    jmp: JmpInstruction;
{$ENDIF}
    case Integer of
    0:      (instructions: array [0..0] of Byte);
    1{...}: (cnt: Integer; excTab: array [0..0{cnt-1}] of TExcDescEntry);
  end;

{$IFNDEF PC_MAPPED_EXCEPTIONS}
  PExcFrame = ^TExcFrame;
  TExcFrame = record
    next: PExcFrame;
    desc: PExcDesc;
    hEBP: Pointer;
    case Integer of
    0:  ( );
    1:  ( ConstructedObject: Pointer );
    2:  ( SelfOfMethod: Pointer );
  end;

  PExceptionRecord = ^TExceptionRecord;
  TExceptionRecord =
  record
    ExceptionCode        : LongWord;
    ExceptionFlags       : LongWord;
    OuterException       : PExceptionRecord;
    ExceptionAddress     : Pointer;
    NumberParameters     : Longint;
    case {IsOsException:} Boolean of
    True:  (ExceptionInformation : array [0..14] of Longint);
    False: (ExceptAddr: Pointer; ExceptObject: Pointer);
  end;
{$ENDIF}

{$IFDEF PC_MAPPED_EXCEPTIONS}
  PRaisedException = ^TRaisedException;
  TRaisedException = packed record
    RefCount: Integer;
    ExceptObject: TObject;
    ExceptionAddr: Pointer;
    HandlerEBP: LongWord;
    Flags: LongWord;
  end;
{$ELSE}
  PRaiseFrame = ^TRaiseFrame;
  TRaiseFrame = packed record
    NextRaise: PRaiseFrame;
    ExceptAddr: Pointer;
    ExceptObject: TObject;
    ExceptionRecord: PExceptionRecord;
  end;
{$ENDIF}

const
  cCR = $0D;
  cLF = $0A;
  cEOF = $1A;

{$IFDEF LINUX}
const
  libc = 'libc.so.6';
  libdl = 'libdl.so.2';
  libpthread = 'libpthread.so.0';

  O_RDONLY     = $0000;
  O_WRONLY     = $0001;
  O_RDWR       = $0002;
  O_CREAT      = $0040;
  O_EXCL       = $0080;
  O_NOCTTY     = $0100;
  O_TRUNC      = $0200;
  O_APPEND     = $0400;

  // protection flags
  S_IREAD       = $0100;    // Read by owner.
  S_IWRITE      = $0080;    // Write by owner.
  S_IEXEC       = $0040;    // Execute by owner.
  S_IRUSR       = S_IREAD;
  S_IWUSR       = S_IWRITE;
  S_IXUSR       = S_IEXEC;
  S_IRWXU       = S_IRUSR or S_IWUSR or S_IXUSR;

  S_IRGRP       = S_IRUSR shr 3; // Read by group.
  S_IWGRP       = S_IWUSR shr 3; // Write by group.
  S_IXGRP       = S_IXUSR shr 3; // Execute by group.
  S_IRWXG       = S_IRWXU shr 3; // Read, write, and execute by group.

  S_IROTH       = S_IRGRP shr 3; // Read by others.
  S_IWOTH       = S_IWGRP shr 3; // Write by others.
  S_IXOTH       = S_IXGRP shr 3; // Execute by others.
  S_IRWXO       = S_IRWXG shr 3; // Read, write, and execute by others.

  STDIN_FILENO         = 0;
  STDOUT_FILENO        = 1;
  STDERR_FILENO        = 2;

  SEEK_SET      = 0;
  SEEK_CUR      = 1;
  SEEK_END      = 2;

  LC_CTYPE    = 0;
  _NL_CTYPE_CODESET_NAME = LC_CTYPE shl 16 + 14;

  MAX_PATH      = 4095;


function __open(PathName: PChar; Flags: Integer; Mode: Integer): Integer; cdecl;
  external libc name 'open';

function __close(Handle: Integer): Integer; cdecl;
  external libc name 'close';

function __read(Handle: Integer; Buffer: Pointer; Count: Cardinal): Cardinal; cdecl;
  external libc name 'read';

function __write(Handle: Integer; Buffer: Pointer; Count: Cardinal): Cardinal; cdecl;
  external libc name 'write';

function __mkdir(PathName: PChar; Mode: Integer): Integer; cdecl;
  external libc name 'mkdir';

function __getcwd(Buffer: PChar; BufSize: Integer): PChar; cdecl;
  external libc name 'getcwd';

function __getenv(Name: PChar): PChar; cdecl;
  external libc name 'getenv';

function __chdir(PathName: PChar): Integer; cdecl;
  external libc name 'chdir';

function __rmdir(PathName: PChar): Integer; cdecl;
  external libc name 'rmdir';

function __remove(PathName: PChar): Integer; cdecl;
  external libc name 'remove';

function __rename(OldPath, NewPath: PChar): Integer; cdecl;
  external libc name 'rename';

{$IFDEF EFENCE}
function __malloc(Size: Integer): Pointer; cdecl;
  external 'libefence.so' name 'malloc';

procedure __free(P: Pointer); cdecl;
  external 'libefence.so' name 'free';

function __realloc(P: Pointer; Size: Integer): Pointer; cdecl;
  external 'libefence.so' name 'realloc';
{$ELSE}
function __malloc(Size: Integer): Pointer; cdecl;
  external libc name 'malloc';

procedure __free(P: Pointer); cdecl;
  external libc name 'free';

function __realloc(P: Pointer; Size: Integer): Pointer; cdecl;
  external libc name 'realloc';
{$ENDIF}

procedure ExitProcess(status: Integer); cdecl;
  external libc name 'exit';

function _time(P: Pointer): Integer; cdecl;
  external libc name 'time';

function _lseek(Handle, Offset, Direction: Integer): Integer; cdecl;
  external libc name 'lseek';

function _ftruncate(Handle: Integer; Filesize: Integer): Integer; cdecl;
  external libc name 'ftruncate';

function strcasecmp(s1, s2: PChar): Integer; cdecl;
  external libc name 'strcasecmp';

function __errno_location: PInteger; cdecl;
  external libc name '__errno_location';

function nl_langinfo(item: integer): pchar; cdecl;
  external libc name 'nl_langinfo';

function iconv_open(ToCode: PChar; FromCode: PChar): Integer; cdecl;
  external libc name 'iconv_open';

function iconv(cd: Integer; var InBuf; var InBytesLeft: Integer; var OutBuf; var OutBytesLeft: Integer): Integer; cdecl;
  external libc name 'iconv';

function iconv_close(cd: Integer): Integer; cdecl;
  external libc name 'iconv_close';

function mblen(const S: PChar; N: LongWord): Integer; cdecl;
  external libc name 'mblen';

function mmap(start: Pointer; length: Cardinal; prot, flags, fd, offset: Integer): Pointer; cdecl;
  external libc name 'mmap';

function munmap(start: Pointer; length: Cardinal): Integer; cdecl;
  external libc name 'munmap';

const
  SIGABRT = 6;

function __raise(SigNum: Integer): Integer; cdecl;
  external libc name 'raise';

type
  TStatStruct = record
    st_dev: Int64;          // device
    __pad1: Word;
    st_ino: Cardinal;       // inode
    st_mode: Cardinal;      // protection
    st_nlink: Cardinal;     //  number of hard links
    st_uid: Cardinal;       // user ID of owner
    st_gid: Cardinal;       // group ID of owner
    st_rdev: Int64;         // device type (if inode device)
    __pad2: Word;
    st_size: Cardinal;      // total size, in bytes
    st_blksize: Cardinal;   // blocksize for filesystem I/O
    st_blocks: Cardinal;    // number of blocks allocated
    st_atime: Integer;      // time of last access
    __unused1: Cardinal;
    st_mtime: Integer;      // time of last modification
    __unused2: Cardinal;
    st_ctime: Integer;      // time of last change
    __unused3: Cardinal;
    __unused4: Cardinal;
    __unused5: Cardinal;
  end;

const
  STAT_VER_LINUX = 3;

function _fxstat(Version: Integer; Handle: Integer; var Stat: TStatStruct): Integer; cdecl;
  external libc name '__fxstat';

function __xstat(Ver: Integer; FileName: PChar; var StatBuffer: TStatStruct): Integer; cdecl;
  external libc name '__xstat';
  
function _strlen(P: PChar): Integer; cdecl;
  external libc name 'strlen';

function _readlink(PathName: PChar; Buf: PChar; Len: Integer): Integer; cdecl;
  external libc name 'readlink';

type
  TDLInfo = record
    FileName: PChar;
    BaseAddress: Pointer;
    NearestSymbolName: PChar;
    SymbolAddress: Pointer;
  end;

const
  RTLD_LAZY = 1;
  RTLD_NOW  = 2;

function dladdr(Address: Pointer; var Info: TDLInfo): Integer; cdecl;
  external libdl name 'dladdr';
function dlopen(Filename: PChar; Flag: Integer): LongWord; cdecl;
  external libdl name 'dlopen';
function dlclose(Handle: LongWord): Integer; cdecl;
  external libdl name 'dlclose';
function FreeLibrary(Handle: LongWord): Integer; cdecl;
  external libdl name 'dlclose';
function dlsym(Handle: LongWord; Symbol: PChar): Pointer; cdecl;
  external libdl name 'dlsym';
function dlerror: PChar; cdecl;
  external libdl name 'dlerror';

type
  TPthread_fastlock = record
    __status: LongInt;
    __spinlock: Integer;
  end;

  TRTLCriticalSection = record
    __m_reserved,
    __m_count:  Integer;
    __m_owner:  Pointer;
    __m_kind: Integer; // __m_kind := 0 fastlock, __m_kind := 1 recursive lock
    __m_lock: TPthread_fastlock;
  end;

function _pthread_mutex_lock(var Mutex: TRTLCriticalSection): Integer; cdecl;
  external libpthread name 'pthread_mutex_lock';
function _pthread_mutex_unlock(var Mutex: TRTLCriticalSection): Integer; cdecl;
  external libpthread name 'pthread_mutex_unlock';
function _pthread_create(var ThreadID: Cardinal; Attr: PThreadAttr;
  TFunc: TThreadFunc; Arg: Pointer): Integer; cdecl;
  external libpthread name 'pthread_create';
function _pthread_exit(var RetVal: Integer): Integer; cdecl;
  external libpthread name 'pthread_exit';
function GetCurrentThreadID: LongWord; cdecl;
  external libpthread name 'pthread_self';
function _pthread_detach(ThreadID: Cardinal): Integer; cdecl;
  external libpthread name 'pthread_detach'

function GetLastError: Integer;
begin
  Result := __errno_location^;
end;

procedure SetLastError(ErrorCode: Integer);
begin
  __errno_location^ := ErrorCode;
end;

function InterlockedIncrement(var I: Integer): Integer;
asm
      MOV   EDX,1
      XCHG  EAX,EDX
 LOCK XADD  [EDX],EAX
      INC   EAX
end;

function InterlockedDecrement(var I: Integer): Integer;
asm
      MOV   EDX,-1
      XCHG  EAX,EDX
 LOCK XADD  [EDX],EAX
      DEC   EAX
end;

var
  ModuleCacheVersion: Cardinal = 0;

function ModuleCacheID: Cardinal;
begin
  Result := ModuleCacheVersion;
end;

procedure InvalidateModuleCache;
begin
  InterlockedIncrement(Integer(ModuleCacheVersion));
end;

{$ENDIF}

{$IFDEF MSWINDOWS}
type
  PMemInfo = ^TMemInfo;
  TMemInfo = packed record
  BaseAddress: Pointer;
  AllocationBase: Pointer;
  AllocationProtect: Longint;
    RegionSize: Longint;
    State: Longint;
    Protect: Longint;
    Type_9 : Longint;
  end;

  PStartupInfo = ^TStartupInfo;
  TStartupInfo = record
    cb: Longint;
    lpReserved: Pointer;
    lpDesktop: Pointer;
    lpTitle: Pointer;
    dwX: Longint;
    dwY: Longint;
    dwXSize: Longint;
    dwYSize: Longint;
    dwXCountChars: Longint;
    dwYCountChars: Longint;
    dwFillAttribute: Longint;
    dwFlags: Longint;
    wShowWindow: Word;
    cbReserved2: Word;
    lpReserved2: ^Byte;
    hStdInput: Integer;
    hStdOutput: Integer;
    hStdError: Integer;
  end;

  TWin32FindData = packed record
    dwFileAttributes: Integer;
    ftCreationTime: Int64;
    ftLastAccessTime: Int64;
    ftLastWriteTime: Int64;
    nFileSizeHigh: Integer;
    nFileSizeLow: Integer;
    dwReserved0: Integer;
    dwReserved1: Integer;
    cFileName: array[0..259] of Char;
    cAlternateFileName: array[0..13] of Char;
  end;

const
  GENERIC_READ             = Integer($80000000);
  GENERIC_WRITE            = $40000000;
  FILE_SHARE_READ          = $00000001;
  FILE_SHARE_WRITE         = $00000002;
  FILE_ATTRIBUTE_NORMAL    = $00000080;

  CREATE_NEW               = 1;
  CREATE_ALWAYS            = 2;
  OPEN_EXISTING            = 3;

  FILE_BEGIN               = 0;
  FILE_CURRENT             = 1;
  FILE_END                 = 2;

  STD_INPUT_HANDLE         = Integer(-10);
  STD_OUTPUT_HANDLE        = Integer(-11);
  STD_ERROR_HANDLE         = Integer(-12);
  MAX_PATH                 = 260;

{X+ moved here from SysInit.pas - by advise of Alexey Torgashin - to avoid
               creating of separate import block from kernel32.dll : }
//////////////////////////////////////////////////////////////////////////

function FreeLibrary(ModuleHandle: Longint): LongBool; stdcall;
  external kernel name 'FreeLibrary';

function GetModuleFileName(Module: Integer; Filename: PChar; Size: Integer): Integer; stdcall;
  external kernel name 'GetModuleFileNameA';

function GetModuleHandle(ModuleName: PChar): Integer; stdcall;
  external kernel name 'GetModuleHandleA';

function LocalAlloc(flags, size: Integer): Pointer; stdcall;
  external kernel name 'LocalAlloc';

function LocalFree(addr: Pointer): Pointer; stdcall;
  external kernel name 'LocalFree';

function TlsAlloc: Integer; stdcall;
  external kernel name 'TlsAlloc';

function TlsFree(TlsIndex: Integer): Boolean; stdcall;
  external kernel name 'TlsFree';

function TlsGetValue(TlsIndex: Integer): Pointer; stdcall;
  external kernel name 'TlsGetValue';

function TlsSetValue(TlsIndex: Integer; TlsValue: Pointer): Boolean; stdcall;
  external kernel name 'TlsSetValue';

function GetCommandLine: PChar; stdcall;
  external kernel name 'GetCommandLineA';
{X-}//////////////////////////////////////////////////////////////////////


function CloseHandle(Handle: Integer): Integer; stdcall;
  external kernel name 'CloseHandle';
function CreateFileA(lpFileName: PChar; dwDesiredAccess, dwShareMode: Integer;
  lpSecurityAttributes: Pointer; dwCreationDisposition, dwFlagsAndAttributes: Integer;
  hTemplateFile: Integer): Integer; stdcall;
  external kernel name 'CreateFileA';
function DeleteFileA(Filename: PChar): LongBool;  stdcall;
  external kernel name 'DeleteFileA';
function GetFileType(hFile: Integer): Integer; stdcall;
  external kernel name 'GetFileType';
procedure GetSystemTime; stdcall;
  external kernel name 'GetSystemTime';
function GetFileSize(Handle: Integer; x: Integer): Integer; stdcall;
  external kernel name 'GetFileSize';
function GetStdHandle(nStdHandle: Integer): Integer; stdcall;
  external kernel name 'GetStdHandle';
function MoveFileA(OldName, NewName: PChar): LongBool; stdcall;
  external kernel name 'MoveFileA';
procedure RaiseException; stdcall;
  external kernel name 'RaiseException';
function ReadFile(hFile: Integer; var Buffer; nNumberOfBytesToRead: Cardinal;
  var lpNumberOfBytesRead: Cardinal; lpOverlapped: Pointer): Integer; stdcall;
  external kernel name 'ReadFile';
procedure RtlUnwind; stdcall;
  external kernel name 'RtlUnwind';
function SetEndOfFile(Handle: Integer): LongBool; stdcall;
  external kernel name 'SetEndOfFile';
function SetFilePointer(Handle, Distance: Integer; DistanceHigh: Pointer;
  MoveMethod: Integer): Integer; stdcall;
  external kernel name 'SetFilePointer';
procedure UnhandledExceptionFilter; stdcall;
  external kernel name 'UnhandledExceptionFilter';
function WriteFile(hFile: Integer; const Buffer; nNumberOfBytesToWrite: Cardinal;
  var lpNumberOfBytesWritten: Cardinal; lpOverlapped: Pointer): Integer; stdcall;
  external kernel name 'WriteFile';

function CharNext(lpsz: PChar): PChar; stdcall;
  external user name 'CharNextA';

function CreateThread(SecurityAttributes: Pointer; StackSize: LongWord;
                     ThreadFunc: TThreadFunc; Parameter: Pointer;
                     CreationFlags: LongWord; var ThreadId: LongWord): Integer; stdcall;
  external kernel name 'CreateThread';

procedure ExitThread(ExitCode: Integer); stdcall;
  external kernel name 'ExitThread';

procedure ExitProcess(ExitCode: Integer); stdcall;
  external kernel name 'ExitProcess';

procedure MessageBox(Wnd: Integer; Text: PChar; Caption: PChar; Typ: Integer); stdcall;
  external user   name 'MessageBoxA';

function CreateDirectory(PathName: PChar; Attr: Integer): WordBool; stdcall;
  external kernel name 'CreateDirectoryA';

function FindClose(FindFile: Integer): LongBool; stdcall;
  external kernel name 'FindClose';

function FindFirstFile(FileName: PChar; var FindFileData: TWIN32FindData): Integer; stdcall;
  external kernel name 'FindFirstFileA';

{X} //function FreeLibrary(ModuleHandle: Longint): LongBool; stdcall;
{X} //  external kernel name 'FreeLibrary';

{X} //function GetCommandLine: PChar; stdcall;
{X} //  external kernel name 'GetCommandLineA';

function GetCurrentDirectory(BufSize: Integer; Buffer: PChar): Integer; stdcall;
  external kernel name 'GetCurrentDirectoryA';

function GetLastError: Integer; stdcall;
  external kernel name 'GetLastError';

procedure SetLastError(ErrorCode: Integer); stdcall;
  external kernel name 'SetLastError';

function GetLocaleInfo(Locale: Longint; LCType: Longint; lpLCData: PChar; cchData: Integer): Integer; stdcall;
  external kernel name 'GetLocaleInfoA';

{X} //function GetModuleFileName(Module: Integer; Filename: PChar;
{X} //  Size: Integer): Integer; stdcall;
{X} //  external kernel name 'GetModuleFileNameA';

{X} //function GetModuleHandle(ModuleName: PChar): Integer; stdcall;
{X} //  external kernel name 'GetModuleHandleA';

function GetProcAddress(Module: Integer; ProcName: PChar): Pointer; stdcall;
  external kernel name 'GetProcAddress';

procedure GetStartupInfo(var lpStartupInfo: TStartupInfo); stdcall;
  external kernel name 'GetStartupInfoA';

function GetThreadLocale: Longint; stdcall;
  external kernel name 'GetThreadLocale';

function LoadLibraryEx(LibName: PChar; hFile: Longint; Flags: Longint): Longint; stdcall;
  external kernel name 'LoadLibraryExA';

function LoadString(Instance: Longint; IDent: Integer; Buffer: PChar;
  Size: Integer): Integer; stdcall;
  external user name 'LoadStringA';

{function lstrcat(lpString1, lpString2: PChar): PChar; stdcall;
  external kernel name 'lstrcatA';}

function lstrcpy(lpString1, lpString2: PChar): PChar; stdcall;
  external kernel name 'lstrcpyA';

function lstrcpyn(lpString1, lpString2: PChar;
  iMaxLength: Integer): PChar; stdcall;
  external kernel name 'lstrcpynA';

function _strlen(lpString: PChar): Integer; stdcall;
  external kernel name 'lstrlenA';

function MultiByteToWideChar(CodePage, Flags: Integer; MBStr: PChar;
  MBCount: Integer; WCStr: PWideChar; WCCount: Integer): Integer; stdcall;
  external kernel name 'MultiByteToWideChar';

function RegCloseKey(hKey: Integer): Longint; stdcall;
  external advapi32 name 'RegCloseKey';

function RegOpenKeyEx(hKey: LongWord; lpSubKey: PChar; ulOptions,
  samDesired: LongWord; var phkResult: LongWord): Longint; stdcall;
  external advapi32 name 'RegOpenKeyExA';

function RegQueryValueEx(hKey: LongWord; lpValueName: PChar;
  lpReserved: Pointer; lpType: Pointer; lpData: PChar; lpcbData: Pointer): Integer; stdcall;
  external advapi32 name 'RegQueryValueExA';

function RemoveDirectory(PathName: PChar): WordBool; stdcall;
  external kernel name 'RemoveDirectoryA';

function SetCurrentDirectory(PathName: PChar): WordBool; stdcall;
  external kernel name 'SetCurrentDirectoryA';

function WideCharToMultiByte(CodePage, Flags: Integer; WCStr: PWideChar;
  WCCount: Integer; MBStr: PChar; MBCount: Integer; DefaultChar: PChar;
  UsedDefaultChar: Pointer): Integer; stdcall;
  external kernel name 'WideCharToMultiByte';

function VirtualQuery(lpAddress: Pointer;
  var lpBuffer: TMemInfo; dwLength: Longint): Longint; stdcall;
  external kernel name 'VirtualQuery';

//function SysAllocString(P: PWideChar): PWideChar; stdcall;
//  external oleaut name 'SysAllocString';

function SysAllocStringLen(P: PWideChar; Len: Integer): PWideChar; stdcall;
  external oleaut name 'SysAllocStringLen';

function SysReAllocStringLen(var S: WideString; P: PWideChar;
  Len: Integer): LongBool; stdcall;
  external oleaut name 'SysReAllocStringLen';

procedure SysFreeString(const S: WideString); stdcall;
  external oleaut name 'SysFreeString';

function SysStringLen(const S: WideString): Integer; stdcall;
  external oleaut name 'SysStringLen';

function InterlockedIncrement(var Addend: Integer): Integer; stdcall;
  external kernel name 'InterlockedIncrement';

function InterlockedDecrement(var Addend: Integer): Integer; stdcall;
  external kernel name 'InterlockedDecrement';

function GetCurrentThreadId: LongWord; stdcall;
  external kernel name 'GetCurrentThreadId';


function GetCmdShow: Integer;
var
  SI: TStartupInfo;
begin
  Result := 10;                  { SW_SHOWDEFAULT }
  GetStartupInfo(SI);
  if SI.dwFlags and 1 <> 0 then  { STARTF_USESHOWWINDOW }
    Result := SI.wShowWindow;
end;

{$ENDIF} // MSWindows

function WCharFromChar(WCharDest: PWideChar; DestChars: Integer; const CharSource: PChar; SrcBytes: Integer): Integer; forward;
function CharFromWChar(CharDest: PChar; DestBytes: Integer; const WCharSource: PWideChar; SrcChars: Integer): Integer; forward;

{ ----------------------------------------------------- }
{       Memory manager                                  }
{ ----------------------------------------------------- }

{$IFDEF MSWINDOWS}
{$I GETMEM.INC }
{$ENDIF}


//////////////////// This code is from HeapMM.pas, (C) by Vladimir Kladov, 2001
const
  HEAP_NO_SERIALIZE              = $00001;
  HEAP_GROWABLE                  = $00002;
  HEAP_GENERATE_EXCEPTIONS       = $00004;
  HEAP_ZERO_MEMORY               = $00008;
  HEAP_REALLOC_IN_PLACE_ONLY     = $00010;
  HEAP_TAIL_CHECKING_ENABLED     = $00020;
  HEAP_FREE_CHECKING_ENABLED     = $00040;
  HEAP_DISABLE_COALESCE_ON_FREE  = $00080;
  HEAP_CREATE_ALIGN_16           = $10000;
  HEAP_CREATE_ENABLE_TRACING     = $20000;
  HEAP_MAXIMUM_TAG               = $00FFF;
  HEAP_PSEUDO_TAG_FLAG           = $08000;
  HEAP_TAG_SHIFT                 =  16   ;

{$DEFINE USE_PROCESS_HEAP}

var
  HeapHandle: THandle;
  {* Global handle to the heap. Do not change it! }

  HeapFlags: DWORD = 0;
  {* Possible flags are:
     HEAP_GENERATE_EXCEPTIONS - system will raise an exception to indicate a
                              function failure, such as an out-of-memory
                              condition, instead of returning NULL.
     HEAP_NO_SERIALIZE - mutual exclusion will not be used while the HeapAlloc
                       function is accessing the heap. Be careful!
                       Not recommended for multi-thread applications.
                       But faster.
     HEAP_ZERO_MEMORY - obviously. (Slower!)
  }

  { Note from MSDN:
    The granularity of heap allocations in Win32 is 16 bytes. So if you
    request a global memory allocation of 1 byte, the heap returns a pointer
    to a chunk of memory, guaranteeing that the 1 byte is available. Chances
    are, 16 bytes will actually be available because the heap cannot allocate
    less than 16 bytes at a time.
  }

function DfltGetMem(size: Integer): Pointer;
// Allocate memory block.
begin
  Result := HeapAlloc( HeapHandle, HeapFlags, size );
end;

function DfltFreeMem(p: Pointer): Integer;
// Deallocate memory block.
begin
  Result := Integer( not HeapFree( HeapHandle, HeapFlags and HEAP_NO_SERIALIZE,
            p ) );
end;

function DfltReallocMem(p: Pointer; size: Integer): Pointer;
// Resize memory block.
begin
  Result := HeapRealloc( HeapHandle, HeapFlags and (HEAP_NO_SERIALIZE and
         HEAP_GENERATE_EXCEPTIONS and HEAP_ZERO_MEMORY),
         // (Prevent using flag HEAP_REALLOC_IN_PLACE_ONLY here - to allow
         // system to move the block if necessary).
         p, size );
end;

//////////////////////////////////////////// end of HeapMM


{$IFDEF LINUX}
function SysGetMem(Size: Integer): Pointer;
begin
  Result := __malloc(size);
end;

function SysFreeMem(P: Pointer): Integer;
begin
  __free(P);
  Result := 0;
end;

function SysReallocMem(P: Pointer; Size: Integer): Pointer;
begin
  Result := __realloc(P, Size);
end;

{$ENDIF}

{X- by default, system memory allocation routines (API calls)
    are used. To use Inprise's memory manager (Delphi standard)
    call UseDelphiMemoryManager procedure. }
var
  MemoryManager: TMemoryManager = (
    GetMem: DfltGetMem;
    FreeMem: DfltFreeMem;
    ReallocMem: DfltReallocMem);

const
  DelphiMemoryManager: TMemoryManager = (
    GetMem: SysGetMem;
    FreeMem: SysFreeMem;
    ReallocMem: SysReallocMem);

procedure UseDelphiMemoryManager;
begin
  IsMemoryManagerSet := IsDelphiMemoryManagerSet;
  SetMemoryManager( DelphiMemoryManager );
end;
{X+}


{$IFDEF PC_MAPPED_EXCEPTIONS}
var
//  Unwinder: TUnwinder = (
//    RaiseException: UnwindRaiseException;
//    RegisterIPLookup: UnwindRegisterIPLookup;
//    UnregisterIPLookup: UnwindUnregisterIPLookup;
//    DelphiLookup: UnwindDelphiLookup);
  Unwinder: TUnwinder;

{$IFDEF STATIC_UNWIND}
{$IFDEF PIC}
{$L 'objs/arith.pic.o'}
{$L 'objs/diag.pic.o'}
{$L 'objs/delphiuw.pic.o'}
{$L 'objs/unwind.pic.o'}
{$ELSE}
{$L 'objs/arith.o'}
{$L 'objs/diag.o'}
{$L 'objs/delphiuw.o'}
{$L 'objs/unwind.o'}
{$ENDIF}
procedure Arith_RdUnsigned; external;
procedure Arith_RdSigned; external;
procedure __assert_fail; cdecl; external libc name '__assert_fail';
procedure malloc; cdecl; external libc name 'malloc';
procedure memset; cdecl; external libc name 'memset';
procedure strchr; cdecl; external libc name 'strchr';
procedure strncpy; cdecl; external libc name 'strncpy';
procedure strcpy; cdecl; external libc name 'strcpy';
procedure strcmp; cdecl; external libc name 'strcmp';
procedure printf; cdecl; external libc name 'printf';
procedure free; cdecl; external libc name 'free';
procedure getenv; cdecl; external libc name 'getenv';
procedure strtok; cdecl; external libc name 'strtok';
procedure strdup; cdecl; external libc name 'strdup';
procedure __strdup; cdecl; external libc name '__strdup';
procedure fopen; cdecl; external libc name 'fopen';
procedure fdopen; cdecl; external libc name 'fdopen';
procedure time; cdecl; external libc name 'time';
procedure ctime; cdecl; external libc name 'ctime';
procedure fclose; cdecl; external libc name 'fclose';
procedure fprintf; cdecl; external libc name 'fprintf';
procedure vfprintf; cdecl; external libc name 'vfprintf';
procedure fflush; cdecl; external libc name 'fflush';
procedure debug_init; external;
procedure debug_print; external;
procedure debug_class_enabled; external;
procedure debug_continue; external;
{$ENDIF}
{$ENDIF}

{X}{$IFDEF MSWINDOWS}
{X}function _GetMem(Size: Integer): Pointer;
{X}asm
{X}        TEST    EAX,EAX
{X}        JE      @@1
{X}        CALL    MemoryManager.GetMem
{X}        OR      EAX,EAX
{X}        JE      @@2
{X}@@1:    RET
{X}@@2:    MOV     AL,reOutOfMemory
{X}        JMP     Error
{X}end;
{X}{$ELSE}
function _GetMem(Size: Integer): Pointer;
{$IF Defined(DEBUG) and Defined(LINUX)}
var
  Signature: PLongInt;
{$IFEND}
begin
  if Size > 0 then
  begin
{$IF Defined(DEBUG) and Defined(LINUX)}
    Signature := PLongInt(MemoryManager.GetMem(Size + 4));
    if Signature = nil then
      Error(reOutOfMemory);
    Signature^ := 0;
    Result := Pointer(LongInt(Signature) + 4);
{$ELSE}
    Result := MemoryManager.GetMem(Size);
    if Result = nil then
      Error(reOutOfMemory);
{$IFEND}
  end
  else
    Result := nil;
end;
{X}{$ENDIF MSWINDOWS}


const
  FreeMemorySignature = Longint($FBEEFBEE);

{X}{$IFDEF MSWINDOWS}
{X}function _FreeMem(P: Pointer): Integer;
{X}asm
{X}        TEST    EAX,EAX
{X}        JE      @@1
{X}        CALL    MemoryManager.FreeMem
{X}        OR      EAX,EAX
{X}        JNE     @@2
{X}@@1:    RET
{X}@@2:    MOV     AL,reInvalidPtr
{X}        JMP     Error
{X}end;
{X}{$ELSE}
function _FreeMem(P: Pointer): Integer;
{$IF Defined(DEBUG) and Defined(LINUX)}
var
  Signature: PLongInt;
{$IFEND}
begin
  if P <> nil then
  begin
{$IF Defined(DEBUG) and Defined(LINUX)}
    Signature := PLongInt(LongInt(P) - 4);
    if Signature^ <> 0 then
      Error(reInvalidPtr);
    Signature^ := FreeMemorySignature;
    Result := MemoryManager.Freemem(Pointer(Signature));
{$ELSE}
    Result := MemoryManager.FreeMem(P);
{$IFEND}
    if Result <> 0 then
      Error(reInvalidPtr);
  end
  else
    Result := 0;
end;
{X}{$ENDIF MSWINDOWS}

{$IFDEF LINUX}
function _ReallocMem(var P: Pointer; NewSize: Integer): Pointer;
{$IFDEF DEBUG}
var
  Temp: Pointer;
{$ENDIF}
begin
  if P <> nil then
  begin
{$IFDEF DEBUG}
    Temp := Pointer(LongInt(P) - 4);
    if NewSize > 0 then
    begin
      Temp := MemoryManager.ReallocMem(Temp, NewSize + 4);
      Result := Pointer(LongInt(Temp) + 4);
    end
    else
    begin
      MemoryManager.FreeMem(Temp);
      Result := nil;
    end;
{$ELSE}
    if NewSize > 0 then
    begin
      Result := MemoryManager.ReallocMem(P, NewSize);
    end
    else
    begin
      MemoryManager.FreeMem(P);
      Result := nil;
    end;
{$ENDIF}
    P := Result;
  end else
  begin
    Result := _GetMem(NewSize);
    P := Result;
  end;
end;
{$ELSEIF Defined(MSWINDOWS)}
function _ReallocMem(var P: Pointer; NewSize: Integer): Pointer;
asm
        MOV     ECX,[EAX]
        TEST    ECX,ECX
        JE      @@alloc
        TEST    EDX,EDX
        JE      @@free
@@resize:
        PUSH    EAX
        MOV     EAX,ECX
        CALL    MemoryManager.ReallocMem
        POP     ECX
        OR      EAX,EAX
        JE      @@allocError
        MOV     [ECX],EAX
        RET
@@freeError:
        MOV     AL,reInvalidPtr
        JMP     Error
@@free:
        MOV     [EAX],EDX
        MOV     EAX,ECX
        CALL    MemoryManager.FreeMem
        OR      EAX,EAX
        JNE     @@freeError
        RET
@@allocError:
        MOV     AL,reOutOfMemory
        JMP     Error
@@alloc:
        TEST    EDX,EDX
        JE      @@exit
        PUSH    EAX
        MOV     EAX,EDX
        CALL    MemoryManager.GetMem
        POP     ECX
        OR      EAX,EAX
        JE      @@allocError
        MOV     [ECX],EAX
@@exit:
end;
{$IFEND}

procedure GetMemoryManager(var MemMgr: TMemoryManager);
begin
  MemMgr := MemoryManager;
end;

procedure SetMemoryManager(const MemMgr: TMemoryManager);
begin
  MemoryManager := MemMgr;
end;

//{X} - function is replaced with pointer to one.
//  function IsMemoryManagerSet: Boolean;
function IsDelphiMemoryManagerSet: Boolean;
begin
  with MemoryManager do
    Result := (@GetMem <> @SysGetMem) or (@FreeMem <> @SysFreeMem) or
      (@ReallocMem <> @SysReallocMem);
end;

{X+ always returns False. Initial handler for IsMemoryManagerSet }
function MemoryManagerNotUsed : Boolean;
begin
  Result := False;
end;
{X-}

{$IFDEF PC_MAPPED_EXCEPTIONS}
procedure GetUnwinder(var Dest: TUnwinder);
begin
  Dest := Unwinder;
end;

procedure SetUnwinder(const NewUnwinder: TUnwinder);
begin
  Unwinder := NewUnwinder;
end;

function IsUnwinderSet: Boolean;
begin
  with Unwinder do
    Result := (@RaiseException <> @_BorUnwind_RaiseException) or
      (@RegisterIPLookup <> @_BorUnwind_RegisterIPLookup) or
      (@UnregisterIPLookup <> @_BorUnwind_UnregisterIPLookup) or
      (@DelphiLookup <> @_BorUnwind_DelphiLookup);
end;

procedure InitUnwinder;
var
  Addr: Pointer;
begin
  {
    We look to see if we can find a dynamic version of the unwinder.  This will
    be the case if the application used Unwind.pas.  If it is present, then we
    fire it up.  Otherwise, we use our static copy.
  }
  Addr := dlsym(0, '_BorUnwind_RegisterIPLookup');
  if Addr <> nil then
  begin
    Unwinder.RegisterIPLookup := Addr;
    Addr := dlsym(0, '_BorUnwind_UnregisterIPLookup');
    Unwinder.UnregisterIPLookup := Addr;
    Addr := dlsym(0, '_BorUnwind_RaiseException');
    Unwinder.RaiseException := Addr;
    Addr := dlsym(0, '_BorUnwind_DelphiLookup');
    Unwinder.DelphiLookup := Addr;
    Addr := dlsym(0, '_BorUnwind_ClosestHandler');
    Unwinder.ClosestHandler := Addr;
  end
  else
  begin
    dlerror;   // clear error state;  dlsym doesn't
    Unwinder.RegisterIPLookup := _BorUnwind_RegisterIPLookup;
    Unwinder.DelphiLookup := _BorUnwind_DelphiLookup;
    Unwinder.UnregisterIPLookup := _BorUnwind_UnregisterIPLookup;
    Unwinder.RaiseException := _BorUnwind_RaiseException;
    Unwinder.ClosestHandler := _BorUnwind_ClosestDelphiHandler;
  end;
end;

function SysClosestDelphiHandler(Context: Pointer): LongWord;
begin
  if not Assigned(Unwinder.ClosestHandler) then
    InitUnwinder;
  Result := Unwinder.ClosestHandler(Context);
end;

function SysRegisterIPLookup(StartAddr, EndAddr: LongInt; Context: Pointer; GOT: LongInt): LongBool;
begin
//  xxx
  if not Assigned(Unwinder.RegisterIPLookup) then
  begin
    InitUnwinder;
//    Unwinder.RegisterIPLookup := UnwindRegisterIPLookup;
//    Unwinder.DelphiLookup := UnwindDelphiLookup;
  end;
  Result := Unwinder.RegisterIPLookup(@Unwinder.DelphiLookup, StartAddr, EndAddr, Context, GOT);
end;

procedure SysUnregisterIPLookup(StartAddr: LongInt);
begin
//  if not Assigned(Unwinder.UnregisterIPLookup) then
//    Unwinder.UnregisterIPLookup := UnwindUnregisterIPLookup;
  Unwinder.UnregisterIPLookup(StartAddr);
end;

function SysRaiseException(Exc: Pointer): LongBool; export;
begin
//  if not Assigned(Unwinder.RaiseException) then
//    Unwinder.RaiseException := UnwindRaiseException;
  Result := Unwinder.RaiseException(Exc);
end;

const
  MAX_NESTED_EXCEPTIONS = 16;
{$ENDIF}

threadvar
{$IFDEF PC_MAPPED_EXCEPTIONS}
  ExceptionObjects: array[0..MAX_NESTED_EXCEPTIONS-1] of TRaisedException;
  ExceptionObjectCount: Integer;
  OSExceptionsBlocked: Integer;
{$ELSE}
  RaiseListPtr: pointer;
{$ENDIF}
  InOutRes: Integer;

{$IFDEF PUREPASCAL}
var
  notimpl: array [0..15] of Char = 'not implemented'#10;

procedure NotImplemented;
begin
  __write (2, @notimpl, 16);
  Halt;
end;
{$ENDIF}

{$IFDEF PC_MAPPED_EXCEPTIONS}
procedure BlockOSExceptions;
asm
        PUSH    EAX
        PUSH    EDX
        CALL    SysInit.@GetTLS
        MOV     [EAX].OSExceptionsBlocked, 1
        POP     EDX
        POP     EAX
end;

procedure UnblockOSExceptions;
asm
        PUSH    EAX
        CALL    SysInit.@GetTLS
        MOV     [EAX].OSExceptionsBlocked, 0
        POP     EAX
end;

function AreOSExceptionsBlocked: Boolean;
asm
        CALL    SysInit.@GetTLS
        MOV     EAX, [EAX].OSExceptionsBlocked
end;

const
  TRAISEDEXCEPTION_SIZE = SizeOf(TRaisedException);

function CurrentException: PRaisedException;
asm
        CALL    SysInit.@GetTLS
        LEA     EDX, [EAX].ExceptionObjects
        MOV     EAX, [EAX].ExceptionObjectCount
        OR      EAX, EAX
        JE      @@Done
        DEC     EAX
        IMUL    EAX, TRAISEDEXCEPTION_SIZE
        ADD     EAX, EDX
@@Done:
end;

function AllocateException(Exception: Pointer; ExceptionAddr: Pointer): PRaisedException;
asm
        PUSH    EAX
        PUSH    EDX
        CALL    SysInit.@GetTLS
        CMP     [EAX].ExceptionObjectCount, MAX_NESTED_EXCEPTIONS-1
        JE      @@TooManyNestedExceptions
        INC     [EAX].ExceptionObjectCount
        CALL    CurrentException
        POP     EDX
        POP     ECX
        MOV     [EAX].TRaisedException.ExceptObject, ECX
        MOV     [EAX].TRaisedException.ExceptionAddr, EDX
        MOV     [EAX].TRaisedException.RefCount, 0
        MOV     [EAX].TRaisedException.HandlerEBP, $FFFFFFFF
        MOV     [EAX].TRaisedException.Flags, 0
        RET
@@TooManyNestedExceptions:
        MOV     EAX, 231
        JMP     _RunError
end;

{
  In the interests of code size here, this function is slightly overloaded.
  It is responsible for freeing up the current exception record on the
  exception stack, and it conditionally returns the thrown object to the
  caller.  If the object has been acquired through AcquireExceptionObject,
  we don't return the thrown object.
}
function FreeException: Pointer;
asm
        CALL    CurrentException
        OR      EAX, EAX
        JE      @@Error
        { EAX -> the TRaisedException }
        XOR     ECX, ECX
        { If the exception object has been referenced, we don't return it. }
        CMP     [EAX].TRaisedException.RefCount, 0
        JA      @@GotObject
        MOV     ECX, [EAX].TRaisedException.ExceptObject
@@GotObject:
        PUSH    ECX
        CALL    SysInit.@GetTLS
        POP     ECX
        DEC     [EAX].ExceptionObjectCount
        MOV     EAX, ECX
        RET
@@Error:
        { Some kind of internal error }
        JMP     _Run0Error
end;

function AcquireExceptionObject: Pointer;
asm
        CALL    CurrentException
        OR      EAX, EAX
        JE      @@Error
        INC     [EAX].TRaisedException.RefCount
        MOV     EAX, [EAX].TRaisedException.ExceptObject
        RET
@@Error:
        { This happens if there is no exception pending }
        JMP     _Run0Error
end;

procedure ReleaseExceptionObject;
asm
        CALL    CurrentException
        OR      EAX, EAX
        JE      @@Error
        CMP     [EAX].TRaisedException.RefCount, 0
        JE      @@Error
        DEC     [EAX].TRaisedException.RefCount
        RET
@@Error:

{
  This happens if there is no exception pending, or
  if the reference count on a pending exception is
  zero.
}
        JMP   _Run0Error
end;

function ExceptObject: TObject;
var
  Exc: PRaisedException;
begin
  Exc := CurrentException;
  if Exc <> nil then
    Result := TObject(Exc^.ExceptObject)
  else
    Result := nil;
end;

{ Return current exception address }

function ExceptAddr: Pointer;
var
  Exc: PRaisedException;
begin
  Exc := CurrentException;
  if Exc <> nil then
    Result := Exc^.ExceptionAddr
  else
    Result := nil;
end;
{$ELSE}  {not PC_MAPPED_EXCEPTIONS}

function ExceptObject: TObject;
begin
  if RaiseListPtr <> nil then
    Result := PRaiseFrame(RaiseListPtr)^.ExceptObject
  else
    Result := nil;
end;

{ Return current exception address }

function ExceptAddr: Pointer;
begin
  if RaiseListPtr <> nil then
    Result := PRaiseFrame(RaiseListPtr)^.ExceptAddr
  else
    Result := nil;
end;


function AcquireExceptionObject: Pointer;
begin
  if RaiseListPtr <> nil then
  begin
    Result := PRaiseFrame(RaiseListPtr)^.ExceptObject;
    PRaiseFrame(RaiseListPtr)^.ExceptObject := nil;
  end
  else
    Result := nil;
end;

procedure ReleaseExceptionObject;
begin
end;

function RaiseList: Pointer;
begin
  Result := RaiseListPtr;
end;

function SetRaiseList(NewPtr: Pointer): Pointer;
asm
        PUSH    EAX
        CALL    SysInit.@GetTLS
        MOV     EDX, [EAX].RaiseListPtr
        POP     [EAX].RaiseListPtr
        MOV     EAX, EDX
end;
{$ENDIF}

{ ----------------------------------------------------- }
{    local functions & procedures of the system unit    }
{ ----------------------------------------------------- }

procedure RunErrorAt(ErrCode: Integer; ErrorAtAddr: Pointer);
begin
  ErrorAddr := ErrorAtAddr;
  _Halt(ErrCode);
end;

procedure ErrorAt(ErrorCode: Byte; ErrorAddr: Pointer);

const
  reMap: array [TRunTimeError] of Byte = (
    0,
    203, { reOutOfMemory }
    204, { reInvalidPtr }
    200, { reDivByZero }
    201, { reRangeError }
{   210    abstract error }
    215, { reIntOverflow }
    207, { reInvalidOp }
    200, { reZeroDivide }
    205, { reOverflow }
    206, { reUnderflow }
    219, { reInvalidCast }
    216, { Access violation }
    202, { Stack overflow }
    217, { Control-C }
    218, { Privileged instruction }
    220, { Invalid variant type cast }
    221, { Invalid variant operation }
    222, { No variant method call dispatcher }
    223, { Cannot create variant array }
    224, { Variant does not contain an array }
    225, { Variant array bounds error }
{   226       thread init failure }
    227, { reAssertionFailed }
    0,   { reExternalException not used here; in SysUtils }
    228, { reIntfCastError }
    229 { reSafeCallError }
{   230   Reserved by the compiler for unhandled exceptions }
{   231   Too many nested exceptions }
{   232   Fatal signal raised on a non-Delphi thread });

begin
  errorCode := errorCode and 127;
  if Assigned(ErrorProc) then
    ErrorProc(errorCode, ErrorAddr);
  if errorCode = 0 then
    errorCode := InOutRes
  else if errorCode <= Byte(High(TRuntimeError)) then
    errorCode := reMap[TRunTimeError(errorCode)];
  RunErrorAt(errorCode, ErrorAddr);
end;

procedure Error(errorCode: TRuntimeError);
asm
        AND     EAX,127
        MOV     EDX,[ESP]
        JMP     ErrorAt
end;

procedure       __IOTest;
asm
        PUSH    EAX
        PUSH    EDX
        PUSH    ECX
        CALL    SysInit.@GetTLS
        CMP     [EAX].InOutRes,0
        POP     ECX
        POP     EDX
        POP     EAX
        JNE     @error
        RET
@error:
        XOR     EAX,EAX
        JMP     Error
end;

procedure SetInOutRes(NewValue: Integer);
begin
  InOutRes := NewValue;
end;

procedure InOutError;
begin
  SetInOutRes(GetLastError);
end;

procedure ChDir(const S: string);
begin
  ChDir(PChar(S));
end;

procedure ChDir(P: PChar);
begin
{$IFDEF MSWINDOWS}
  if not SetCurrentDirectory(P) then
{$ENDIF}
{$IFDEF LINUX}
  if __chdir(P) <> 0 then
{$ENDIF}
    InOutError;
end;

procedure       _Copy{ s : ShortString; index, count : Integer ) : ShortString};
asm
{     ->EAX     Source string                   }
{       EDX     index                           }
{       ECX     count                           }
{       [ESP+4] Pointer to result string        }

        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,[ESP+8+4]

        XOR     EAX,EAX
        OR      AL,[ESI]
        JZ      @@srcEmpty

{       limit index to satisfy 1 <= index <= Length(src) }

        TEST    EDX,EDX
        JLE     @@smallInx
        CMP     EDX,EAX
        JG      @@bigInx
@@cont1:

{       limit count to satisfy 0 <= count <= Length(src) - index + 1    }

        SUB     EAX,EDX { calculate Length(src) - index + 1     }
        INC     EAX
        TEST    ECX,ECX
        JL      @@smallCount
        CMP     ECX,EAX
        JG      @@bigCount
@@cont2:

        ADD     ESI,EDX

        MOV     [EDI],CL
        INC     EDI
        REP     MOVSB
        JMP     @@exit

@@smallInx:
        MOV     EDX,1
        JMP     @@cont1
@@bigInx:
{       MOV     EDX,EAX
        JMP     @@cont1 }
@@smallCount:
        XOR     ECX,ECX
        JMP     @@cont2
@@bigCount:
        MOV     ECX,EAX
        JMP     @@cont2
@@srcEmpty:
        MOV     [EDI],AL
@@exit:
        POP     EDI
        POP     ESI
    RET 4
end;

procedure       _Delete{ var s : openstring; index, count : Integer };
asm
{     ->EAX     Pointer to s    }
{       EDX     index           }
{       ECX     count           }

        PUSH    ESI
        PUSH    EDI

        MOV     EDI,EAX

        XOR     EAX,EAX
        MOV     AL,[EDI]

{       if index not in [1 .. Length(s)] do nothing     }

        TEST    EDX,EDX
        JLE     @@exit
        CMP     EDX,EAX
        JG      @@exit

{       limit count to [0 .. Length(s) - index + 1]     }

        TEST    ECX,ECX
        JLE     @@exit
        SUB     EAX,EDX         { calculate Length(s) - index + 1       }
        INC     EAX
        CMP     ECX,EAX
        JLE     @@1
        MOV     ECX,EAX
@@1:
        SUB     [EDI],CL        { reduce Length(s) by count                     }
        ADD     EDI,EDX         { point EDI to first char to be deleted }
        LEA     ESI,[EDI+ECX]   { point ESI to first char to be preserved       }
        SUB     EAX,ECX         { #chars = Length(s) - index + 1 - count        }
        MOV     ECX,EAX

        REP     MOVSB

@@exit:
        POP     EDI
        POP     ESI
end;

procedure _LGetDir(D: Byte; var S: string);
{$IFDEF MSWINDOWS}
var
  Drive: array[0..3] of Char;
  DirBuf, SaveBuf: array[0..MAX_PATH] of Char;
begin
  if D <> 0 then
  begin
    Drive[0] := Chr(D + Ord('A') - 1);
    Drive[1] := ':';
    Drive[2] := #0;
    GetCurrentDirectory(SizeOf(SaveBuf), SaveBuf);
    SetCurrentDirectory(Drive);
  end;
  GetCurrentDirectory(SizeOf(DirBuf), DirBuf);
  if D <> 0 then SetCurrentDirectory(SaveBuf);
  S := DirBuf;
{$ENDIF}
{$IFDEF LINUX}
var
  DirBuf: array[0..MAX_PATH] of Char;
begin
  __getcwd(DirBuf, sizeof(DirBuf));
  S := string(DirBuf);
{$ENDIF}
end;

procedure _SGetDir(D: Byte; var S: ShortString);
var
  L: string;
begin
  _LGetDir(D, L);
  S := L;
end;

procedure       _Insert{ source : ShortString; var s : openstring; index : Integer };
asm
{     ->EAX     Pointer to source string        }
{       EDX     Pointer to destination string   }
{       ECX     Length of destination string    }
{       [ESP+4] Index                   }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    ECX
        MOV     ECX,[ESP+16+4]
        SUB     ESP,512         { VAR buf: ARRAY [0..511] of Char       }

        MOV     EBX,EDX         { save pointer to s for later   }
        MOV     ESI,EDX

        XOR     EDX,EDX
        MOV     DL,[ESI]
        INC     ESI

{       limit index to [1 .. Length(s)+1]       }

        INC     EDX
        TEST    ECX,ECX
        JLE     @@smallInx
        CMP     ECX,EDX
        JG      @@bigInx
@@cont1:
        DEC     EDX     { EDX = Length(s)               }
                        { EAX = Pointer to src  }
                        { ESI = EBX = Pointer to s      }
                        { ECX = Index           }

{       copy index-1 chars from s to buf        }

        MOV     EDI,ESP
        DEC     ECX
        SUB     EDX,ECX { EDX = remaining length of s   }
        REP     MOVSB

{       copy Length(src) chars from src to buf  }

        XCHG    EAX,ESI { save pointer into s, point ESI to src         }
        MOV     CL,[ESI]        { ECX = Length(src) (ECX was zero after rep)    }
        INC     ESI
        REP     MOVSB

{       copy remaining chars of s to buf        }

        MOV     ESI,EAX { restore pointer into s                }
        MOV     ECX,EDX { copy remaining bytes of s             }
        REP     MOVSB

{       calculate total chars in buf    }

        SUB     EDI,ESP         { length = bufPtr - buf         }
        MOV     ECX,[ESP+512]   { ECX = Min(length, destLength) }
{       MOV     ECX,[EBP-16]   }{ ECX = Min(length, destLength) }
        CMP     ECX,EDI
        JB      @@1
        MOV     ECX,EDI
@@1:
        MOV     EDI,EBX         { Point EDI to s                }
        MOV     ESI,ESP         { Point ESI to buf              }
        MOV     [EDI],CL        { Store length in s             }
        INC     EDI
        REP     MOVSB           { Copy length chars to s        }
        JMP     @@exit

@@smallInx:
        MOV     ECX,1
        JMP     @@cont1
@@bigInx:
        MOV     ECX,EDX
        JMP     @@cont1

@@exit:
        ADD     ESP,512+4
        POP     EDI
        POP     ESI
        POP     EBX
        RET 4
end;

function IOResult: Integer;
begin
  Result := InOutRes;
  InOutRes := 0;
end;

procedure MkDir(const S: string);
begin
  MkDir(PChar(s));
end;

procedure MkDir(P: PChar);
begin
{$IFDEF MSWINDOWS}
  if not CreateDirectory(P, 0) then
{$ENDIF}
{$IFDEF LINUX}
  if __mkdir(P, -1) <> 0 then
{$ENDIF}
    InOutError;
end;

procedure       Move( const Source; var Dest; count : Integer );
{$IFDEF PUREPASCAL}
var
  S, D: PChar;
  I: Integer;
begin
  S := PChar(@Source);
  D := PChar(@Dest);
  if S = D then Exit;
  if Cardinal(D) > Cardinal(S) then
    for I := count-1 downto 0 do
      D[I] := S[I]
  else
    for I := 0 to count-1 do
      D[I] := S[I];
end;
{$ELSE}
asm
{     ->EAX     Pointer to source       }
{       EDX     Pointer to destination  }
{       ECX     Count                   }

(*{X-} // original code.

        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        MOV     EAX,ECX

        CMP     EDI,ESI
        JA      @@down
        JE      @@exit

        SAR     ECX,2           { copy count DIV 4 dwords       }
        JS      @@exit

        REP     MOVSD

        MOV     ECX,EAX
        AND     ECX,03H
        REP     MOVSB           { copy count MOD 4 bytes        }
        JMP     @@exit

@@down:
        LEA     ESI,[ESI+ECX-4] { point ESI to last dword of source     }
        LEA     EDI,[EDI+ECX-4] { point EDI to last dword of dest       }

        SAR     ECX,2           { copy count DIV 4 dwords       }
        JS      @@exit
        STD
        REP     MOVSD

        MOV     ECX,EAX
        AND     ECX,03H         { copy count MOD 4 bytes        }
        ADD     ESI,4-1         { point to last byte of rest    }
        ADD     EDI,4-1
        REP     MOVSB
        CLD
@@exit:
        POP     EDI
        POP     ESI
*){X+}
//---------------------------------------
(* {X+} // Let us write smaller:
        JCXZ    @@fin

        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        MOV     EAX,ECX

        AND     ECX,3           { copy count mod 4 dwords       }

        CMP     EDI,ESI
        JE      @@exit
        JA      @@up

//down:
        LEA     ESI,[ESI+EAX-1] { point ESI to last byte of source     }
        LEA     EDI,[EDI+EAX-1] { point EDI to last byte of dest       }
        STD

        CMP     EAX, 4
        JL      @@up
        ADD     ECX, 3          { move 3 bytes more to correct pos }

@@up:
        REP     MOVSB

        SAR     EAX, 2
        JS      @@exit

        MOV     ECX, EAX
        REP     MOVSD

@@exit:
        CLD
        POP     EDI
        POP     ESI

@@fin:
*) {X-}
//---------------------------------------
{X+} // And now, let us write speedy:
        CMP      ECX, 4
        JGE      @@long
        JCXZ     @@fin

        CMP      EAX, EDX
        JE       @@fin

        PUSH     ESI
        PUSH     EDI
        MOV      ESI, EAX
        MOV      EDI, EDX
        JA       @@short_up

        LEA     ESI,[ESI+ECX-1] { point ESI to last byte of source     }
        LEA     EDI,[EDI+ECX-1] { point EDI to last byte of dest       }
        STD

@@short_up:
        REP     MOVSB
        JMP     @@exit_up

@@long:
        CMP     EAX, EDX
        JE      @@fin

        PUSH    ESI
        PUSH    EDI
        MOV     ESI, EAX
        MOV     EDI, EDX
        MOV     EAX, ECX

        JA      @@long_up

        {
        SAR     ECX, 2
        JS      @@exit

        LEA     ESI,[ESI+EAX-4]
        LEA     EDI,[EDI+EAX-4]
        STD
        REP     MOVSD

        MOV     ECX, EAX
        MOV     EAX, 3
        AND     ECX, EAX
        ADD     ESI, EAX
        ADD     EDI, EAX
        REP     MOVSB
        } // let's do it in other order - faster if data are aligned...

        AND     ECX, 3
        LEA     ESI,[ESI+EAX-1]
        LEA     EDI,[EDI+EAX-1]
        STD
        REP     MOVSB

        SAR     EAX, 2
        //JS    @@exit         // why to test this? but what does PC do?
        MOV     ECX, EAX
        MOV     EAX, 3
        SUB     ESI, EAX
        SUB     EDI, EAX
        REP     MOVSD

@@exit_up:
        CLD
        //JMP     @@exit
        DEC     ECX     // the same - loosing 2 tacts... but conveyer!

@@long_up:
        SAR     ECX, 2
        JS      @@exit

        REP     MOVSD

        AND     EAX, 3
        MOV     ECX, EAX
        REP     MOVSB

@@exit:
        POP     EDI
        POP     ESI

@@fin:
{X-}
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetParamStr(P: PChar; var Param: string): PChar;
var
  i, Len: Integer;
  Start, S, Q: PChar;
begin
  while True do
  begin
    while (P[0] <> #0) and (P[0] <= ' ') do
      P := CharNext(P);
    if (P[0] = '"') and (P[1] = '"') then Inc(P, 2) else Break;
  end;
  Len := 0;
  Start := P;
  while P[0] > ' ' do
  begin
    if P[0] = '"' then
    begin
      P := CharNext(P);
      while (P[0] <> #0) and (P[0] <> '"') do
      begin
        Q := CharNext(P);
        Inc(Len, Q - P);
        P := Q;
      end;
      if P[0] <> #0 then
        P := CharNext(P);
    end
    else
    begin
      Q := CharNext(P);
      Inc(Len, Q - P);
      P := Q;
    end;
  end;

  SetLength(Param, Len);

  P := Start;
  S := Pointer(Param);
  i := 0;
  while P[0] > ' ' do
  begin
    if P[0] = '"' then
    begin
      P := CharNext(P);
      while (P[0] <> #0) and (P[0] <> '"') do
      begin
        Q := CharNext(P);
        while P < Q do
        begin
          S[i] := P^;
          Inc(P);
          Inc(i);
        end;
      end;
      if P[0] <> #0 then P := CharNext(P);
    end
    else
    begin
      Q := CharNext(P);
      while P < Q do
      begin
        S[i] := P^;
        Inc(P);
        Inc(i);
      end;
    end;
  end;

  Result := P;
end;
{$ENDIF}

function ParamCount: Integer;
{$IFDEF MSWINDOWS}
var
  P: PChar;
  S: string;
begin
  Result := 0;
  P := GetParamStr(GetCommandLine, S);
  while True do
  begin
    P := GetParamStr(P, S);
    if S = '' then Break;
    Inc(Result);
  end;
{$ENDIF}
{$IFDEF LINUX}
begin
  if ArgCount > 1 then
    Result := ArgCount - 1
  else Result := 0;
{$ENDIF}
end;

type
  PCharArray = array[0..0] of PChar;

function ParamStr(Index: Integer): string;
{$IFDEF MSWINDOWS}
var
  P: PChar;
  Buffer: array[0..260] of Char;
begin
  Result := '';
  if Index = 0 then
    SetString(Result, Buffer, GetModuleFileName(0, Buffer, SizeOf(Buffer)))
  else
  begin
    P := GetCommandLine;
    while True do
    begin
      P := GetParamStr(P, Result);
      if (Index = 0) or (Result = '') then Break;
      Dec(Index);
    end;
  end;
{$ENDIF}
{$IFDEF LINUX}
begin
  if Index < ArgCount then
    Result := PCharArray(ArgValues^)[Index]
  else
    Result := '';
{$ENDIF}
end;

procedure       _Pos{ substr : ShortString; s : ShortString ) : Integer};
asm
{     ->EAX     Pointer to substr               }
{       EDX     Pointer to string               }
{     <-EAX     Position of substr in s or 0    }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX { Point ESI to substr           }
        MOV     EDI,EDX { Point EDI to s                }

        XOR     ECX,ECX { ECX = Length(s)               }
        MOV     CL,[EDI]
        INC     EDI             { Point EDI to first char of s  }

        PUSH    EDI             { remember s position to calculate index        }

        XOR     EDX,EDX { EDX = Length(substr)          }
        MOV     DL,[ESI]
        INC     ESI             { Point ESI to first char of substr     }

        DEC     EDX             { EDX = Length(substr) - 1              }
        JS      @@fail  { < 0 ? return 0                        }
        MOV     AL,[ESI]        { AL = first char of substr             }
        INC     ESI             { Point ESI to 2'nd char of substr      }

        SUB     ECX,EDX { #positions in s to look at    }
                        { = Length(s) - Length(substr) + 1      }
        JLE     @@fail
@@loop:
        REPNE   SCASB
        JNE     @@fail
        MOV     EBX,ECX { save outer loop counter               }
        PUSH    ESI             { save outer loop substr pointer        }
        PUSH    EDI             { save outer loop s pointer             }

        MOV     ECX,EDX
        REPE    CMPSB
        POP     EDI             { restore outer loop s pointer  }
        POP     ESI             { restore outer loop substr pointer     }
        JE      @@found
        MOV     ECX,EBX { restore outer loop counter    }
        JMP     @@loop

@@fail:
        POP     EDX             { get rid of saved s pointer    }
        XOR     EAX,EAX
        JMP     @@exit

@@found:
        POP     EDX             { restore pointer to first char of s    }
        MOV     EAX,EDI { EDI points of char after match        }
        SUB     EAX,EDX { the difference is the correct index   }
@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;

// Don't use var param here - var ShortString is an open string param, which passes
// the ptr in EAX and the string's declared buffer length in EDX.  Compiler codegen
// expects only two params for this call - ptr and newlength

procedure       _SetLength(s: PShortString; newLength: Byte);
begin
  Byte(s^[0]) := newLength;   // should also fill new space
end;

procedure       _SetString(s: PShortString; buffer: PChar; len: Byte);
begin
  Byte(s^[0]) := len;
  if buffer <> nil then
    Move(buffer^, s^[1], len);
end;

procedure       Randomize;
{$IFDEF LINUX}
begin
  RandSeed := _time(nil);
{$ENDIF}
{$IFDEF MSWINDOWS}
var
        systemTime :
        record
                wYear   : Word;
                wMonth  : Word;
                wDayOfWeek      : Word;
                wDay    : Word;
                wHour   : Word;
                wMinute : Word;
                wSecond : Word;
                wMilliSeconds: Word;
                reserved        : array [0..7] of char;
        end;
asm
        LEA     EAX,systemTime
        PUSH    EAX
        CALL    GetSystemTime
        MOVZX   EAX,systemTime.wHour
        IMUL    EAX,60
        ADD     AX,systemTime.wMinute   { sum = hours * 60 + minutes    }
        IMUL    EAX,60
        XOR     EDX,EDX
        MOV     DX,systemTime.wSecond
        ADD     EAX,EDX                 { sum = sum * 60 + seconds              }
        IMUL    EAX,1000
        MOV     DX,systemTime.wMilliSeconds
        ADD     EAX,EDX                 { sum = sum * 1000 + milliseconds       }
        MOV     RandSeed,EAX
{$ENDIF}
end;

procedure RmDir(const S: string);
begin
  RmDir(PChar(s));
end;

procedure RmDir(P: PChar);
begin
{$IFDEF MSWINDOWS}
  if not RemoveDirectory(P) then
{$ENDIF}
{$IFDEF LINUX}
  if __rmdir(P) <> 0 then
{$ENDIF}
    InOutError;
end;

function        UpCase( ch : Char ) : Char;
{$IFDEF PUREPASCAL}
begin
  Result := ch;
  case Result of
    'a'..'z':  Dec(Result, Ord('a') - Ord('A'));
  end;
end;
{$ELSE}
asm
{ ->    AL      Character       }
{ <-    AL      Result          }

        CMP     AL,'a'
        JB      @@exit
        CMP     AL,'z'
        JA      @@exit
        SUB     AL,'a' - 'A'
@@exit:
end;
{$ENDIF}

procedure Set8087CW(NewCW: Word);
begin
  Default8087CW := NewCW;
  asm
        FNCLEX  // don't raise pending exceptions enabled by the new flags
{$IFDEF PIC}
        MOV     EAX,[EBX].OFFSET Default8087CW
        FLDCW   [EAX]
{$ELSE}
        FLDCW   Default8087CW
{$ENDIF}
  end;
end;

function Get8087CW: Word;
asm
        PUSH    0
        FNSTCW  [ESP].Word
        POP     EAX
end;


{ ----------------------------------------------------- }
{       functions & procedures that need compiler magic }
{ ----------------------------------------------------- }

procedure       _COS;
asm
        FCOS
        FNSTSW  AX
        SAHF
        JP      @@outOfRange
        RET
@@outOfRange:
        FSTP    st(0)   { for now, return 0. result would }
        FLDZ            { have little significance anyway }
end;

procedure       _EXP;
asm
        {       e**x = 2**(x*log2(e))   }

        FLDL2E              { y := x*log2e;      }
        FMUL
        FLD     ST(0)       { i := round(y);     }
        FRNDINT
        FSUB    ST(1), ST   { f := y - i;        }
        FXCH    ST(1)       { z := 2**f          }
        F2XM1
        FLD1
        FADD
        FSCALE              { result := z * 2**i }
        FSTP    ST(1)
end;

procedure       _INT;
asm
        SUB     ESP,4
        FNSTCW  [ESP].Word     // save
        FNSTCW  [ESP+2].Word   // scratch
        FWAIT
        OR      [ESP+2].Word, $0F00  // trunc toward zero, full precision
        FLDCW   [ESP+2].Word
        FRNDINT
        FWAIT
        FLDCW   [ESP].Word
        ADD     ESP,4
end;

procedure       _SIN;
asm
        FSIN
        FNSTSW  AX
        SAHF
        JP      @@outOfRange
        RET
@@outOfRange:
        FSTP    st(0)   { for now, return 0. result would       }
        FLDZ            { have little significance anyway       }
end;

procedure       _FRAC;
asm
        FLD     ST(0)
        SUB     ESP,4
        FNSTCW  [ESP].Word     // save
        FNSTCW  [ESP+2].Word   // scratch
        FWAIT
        OR      [ESP+2].Word, $0F00  // trunc toward zero, full precision
        FLDCW   [ESP+2].Word
        FRNDINT
        FWAIT
        FLDCW   [ESP].Word
        ADD     ESP,4
        FSUB
end;

procedure       _ROUND;
asm
        { ->    FST(0)  Extended argument       }
        { <-    EDX:EAX Result                  }

        SUB     ESP,8
        FISTP   qword ptr [ESP]
        FWAIT
        POP     EAX
        POP     EDX
end;

procedure       _TRUNC;
asm
       { ->    FST(0)   Extended argument       }
       { <-    EDX:EAX  Result                  }

        SUB     ESP,12
        FNSTCW  [ESP].Word          // save
        FNSTCW  [ESP+2].Word        // scratch
        FWAIT
        OR      [ESP+2].Word, $0F00  // trunc toward zero, full precision
        FLDCW   [ESP+2].Word
        FISTP   qword ptr [ESP+4]
        FWAIT
        FLDCW   [ESP].Word
        POP     ECX
        POP     EAX
        POP     EDX
end;

procedure       _AbstractError;
{$IFDEF PC_MAPPED_EXCEPTIONS}
asm
        MOV     EAX,210
        JMP     _RunError
end;
{$ELSE}
{$IFDEF PIC}
begin
  if Assigned(AbstractErrorProc) then
    AbstractErrorProc;
  _RunError(210);  // loses return address
end;
{$ELSE}
asm
        CMP     AbstractErrorProc, 0
        JE      @@NoAbstErrProc
        CALL    AbstractErrorProc

@@NoAbstErrProc:
        MOV     EAX,210
        JMP     _RunError
end;
{$ENDIF}
{$ENDIF}

function TextOpen(var t: TTextRec): Integer; forward;

function OpenText(var t: TTextRec; Mode: Word): Integer;
begin
  if (t.Mode < fmClosed) or (t.Mode > fmInOut) then
    Result := 102
  else
  begin
    if t.Mode <> fmClosed then _Close(t);
    t.Mode := Mode;
    if (t.Name[0] = #0) and (t.OpenFunc = nil) then  // stdio
      t.OpenFunc := @TextOpen;
    Result := TTextIOFunc(t.OpenFunc)(t);
  end;
  if Result <> 0 then SetInOutRes(Result);
end;

function _ResetText(var t: TTextRec): Integer;
begin
  Result := OpenText(t, fmInput);
end;

function _RewritText(var t: TTextRec): Integer;
begin
  Result := OpenText(t, fmOutput);
end;

function _Append(var t: TTextRec): Integer;
begin
  Result := OpenText(t, fmInOut);
end;

function TextIn(var t: TTextRec): Integer;
begin
  t.BufEnd := 0;
  t.BufPos := 0;
{$IFDEF LINUX}
  t.BufEnd := __read(t.Handle, t.BufPtr, t.BufSize);
  if Integer(t.BufEnd) = -1 then
  begin
    t.BufEnd := 0;
    Result := GetLastError;
  end
  else
    Result := 0;
{$ENDIF}
{$IFDEF MSWINDOWS}
  if ReadFile(t.Handle, t.BufPtr^, t.BufSize, t.BufEnd, nil) = 0 then
  begin
    Result := GetLastError;
    if Result = 109 then
      Result := 0; // NT quirk: got "broken pipe"? it's really eof
  end
  else
    Result := 0;
{$ENDIF}
end;

function FileNOPProc(var t): Integer;
begin
  Result := 0;
end;

function TextOut(var t: TTextRec): Integer;
{$IFDEF MSWINDOWS}
var
  Dummy: Cardinal;
{$ENDIF}
begin
  if t.BufPos = 0 then
    Result := 0
  else
  begin
{$IFDEF LINUX}
    if __write(t.Handle, t.BufPtr, t.BufPos) = Cardinal(-1) then
{$ENDIF}
{$IFDEF MSWINDOWS}
    if WriteFile(t.Handle, t.BufPtr^, t.BufPos, Dummy, nil) = 0 then
{$ENDIF}
      Result := GetLastError
    else
      Result := 0;
    t.BufPos := 0;
  end;
end;

function InternalClose(Handle: Integer): Boolean;
begin
{$IFDEF LINUX}
  Result := __close(Handle) = 0;
{$ENDIF}
{$IFDEF MSWINDOWS}
  Result := CloseHandle(Handle) = 1;
{$ENDIF}
end;

function TextClose(var t: TTextRec): Integer;
begin
  t.Mode := fmClosed;
  if not InternalClose(t.Handle) then
    Result := GetLastError
  else
    Result := 0;
end;

function TextOpenCleanup(var t: TTextRec): Integer;
begin
  InternalClose(t.Handle);
  t.Mode := fmClosed;
  Result := GetLastError;
end;

function TextOpen(var t: TTextRec): Integer;
{$IFDEF LINUX}
var
  Flags: Integer;
  Temp, I: Integer;
  BytesRead: Integer;
begin
  Result := 0;
  t.BufPos := 0;
  t.BufEnd := 0;
  case t.Mode of
    fmInput: // called by Reset
      begin
        Flags := O_RDONLY;
        t.InOutFunc := @TextIn;
      end;
    fmOutput: // called by Rewrite
      begin
        Flags := O_CREAT or O_TRUNC or O_WRONLY;
        t.InOutFunc := @TextOut;
      end;
    fmInOut:  // called by Append
      begin
        Flags := O_APPEND or O_RDWR;
        t.InOutFunc := @TextOut;
      end;
  else
    Exit;
    Flags := 0;
  end;

  t.FlushFunc := @FileNOPProc;

  if t.Name[0] = #0 then  // stdin or stdout
  begin
    t.BufPtr := @t.Buffer;
    t.BufSize := sizeof(t.Buffer);
    t.CloseFunc := @FileNOPProc;
    if t.Mode = fmOutput then
    begin
      if @t = @ErrOutput then
        t.Handle := STDERR_FILENO
      else
        t.Handle := STDOUT_FILENO;
      t.FlushFunc := @TextOut;
    end
    else
      t.Handle := STDIN_FILENO;
  end
  else
  begin
    t.CloseFunc := @TextClose;

    Temp := __open(t.Name, Flags, FileAccessRights);
    if Temp = -1 then
    begin
      Result := TextOpenCleanup(t);
      Exit;
    end;

    t.Handle := Temp;

    if t.Mode = fmInOut then      // Append mode
    begin
      t.Mode := fmOutput;

      if (t.flags and tfCRLF) <> 0 then  // DOS mode, EOF significant
      begin  // scan for EOF char in last 128 byte sector.
        Temp := _lseek(t.Handle, 0, SEEK_END);
        if Temp = -1 then
        begin
          Result := TextOpenCleanup(t);
          Exit;
        end;

        Dec(Temp, 128);
        if Temp < 0 then Temp := 0;

        if _lseek(t.Handle, Temp, SEEK_SET) = -1 then
        begin
          Result := TextOpenCleanup(t);
          Exit;
        end;

        BytesRead := __read(t.Handle, t.BufPtr, 128);
        if BytesRead = -1 then
        begin
          Result := TextOpenCleanup(t);
          Exit;
        end;

        for I := 0 to BytesRead - 1 do
        begin
          if t.Buffer[I] = Char(cEOF) then
          begin  // truncate the file here
            if _ftruncate(t.Handle, _lseek(t.Handle, I - BytesRead, SEEK_END)) = -1 then
            begin
              Result := TextOpenCleanup(t);
              Exit;
            end;
            Break;
          end;
        end;
      end;
    end;
  end;
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
(*
var
  OpenMode: Integer;
  Flags, Std: ShortInt;
  Temp: Integer;
  I, BytesRead: Cardinal;
  Mode: Byte;
begin
  Result := 0;
  if (t.Mode - fmInput) > (fmInOut - fmInput) then Exit;
  Mode := t.Mode and 3;
  t.BufPos := 0;
  t.BufEnd := 0;
  t.FlushFunc := @FileNOPProc;

  if t.Name[0] = #0 then  // stdin or stdout
  begin
    t.BufPtr := @t.Buffer;
    t.BufSize := sizeof(t.Buffer);
    t.CloseFunc := @FileNOPProc;
    if Mode = (fmOutput and 3) then
    begin
      t.InOutFunc := @TextOut;
      if @t = @ErrOutput then
        Std := STD_ERROR_HANDLE
      else
        Std := STD_OUTPUT_HANDLE;
    end
    else
    begin
      t.InOutFunc := @TextIn;
      Std := STD_INPUT_HANDLE;
    end;
    t.Handle := GetStdHandle(Std);
  end
  else
  begin
    t.CloseFunc := @TextClose;

    Flags := OPEN_EXISTING;
    if Mode = (fmInput and 3) then
    begin // called by Reset
      t.InOutFunc := @TextIn;
      OpenMode := GENERIC_READ; // open for read
    end
    else
    begin
      t.InOutFunc := @TextOut;
      if Mode = (fmInOut and 3) then  // called by Append
        OpenMode := GENERIC_READ OR GENERIC_WRITE  // open for read/write
      else
      begin  // called by Rewrite
        OpenMode := GENERIC_WRITE;      // open for write
        Flags := CREATE_ALWAYS;
      end;
    end;

    Temp := CreateFileA(t.Name, OpenMode, FILE_SHARE_READ, nil, Flags, FILE_ATTRIBUTE_NORMAL, 0);
    if Temp = -1 then
    begin
      Result := TextOpenCleanup(t);
      Exit;
    end;

    t.Handle := Temp;

    if Mode = (fmInOut and 3) then
    begin
      Dec(t.Mode);  // fmInOut -> fmOutput

{;  ???  we really have to look for the first eof byte in the
; ???  last record and truncate the file there.
; Not very nice and clean...
;
; lastRecPos = Max( GetFileSize(...) - 128, 0);
}
      Temp := GetFileSize(t.Handle, 0);
      if Temp = -1 then
      begin
        Result := TextOpenCleanup(t);
        Exit;
      end;

      Dec(Temp, 128);
      if Temp < 0 then Temp := 0;

      if (SetFilePointer(t.Handle, Temp, nil, FILE_BEGIN) = -1) or
         (ReadFile(t.Handle, t.Buffer, 128, BytesRead, nil) = 0) then
      begin
        Result := TextOpenCleanup(t);
        Exit;
      end;

      for I := 0 to BytesRead do
      begin
        if t.Buffer[I] = Char(cEOF) then
        begin  // truncate the file here
          if (SetFilePointer(t.Handle, I - BytesRead, nil, FILE_END) = -1) or
            (not SetEndOfFile(t.Handle)) then
          begin
            Result := TextOpenCleanup(t);
            Exit;
          end;
          Break;
        end;
      end;
    end;
    if Mode <> (fmInput and 3) then
    begin
      case GetFileType(t.Handle) of
        0: begin  // bad file type
             TextOpenCleanup(t);
             Result := 105;
             Exit;
           end;
        2: t.FlushFunc := @TextOut;
      end;
    end;
  end;
end;
*)

asm
// -> EAX Pointer to text record

        PUSH    ESI

        MOV     ESI,EAX

        XOR     EAX,EAX
        MOV     [ESI].TTextRec.BufPos,EAX
        MOV     [ESI].TTextRec.BufEnd,EAX
        MOV     AX,[ESI].TTextRec.Mode

        SUB     EAX,fmInput
        JE      @@calledByReset

        DEC     EAX
        JE      @@calledByRewrite

        DEC     EAX
        JE      @@calledByAppend

        JMP     @@exit

@@calledByReset:

        MOV     EAX,GENERIC_READ      // open for read
        MOV     EDX,FILE_SHARE_READ
        MOV     ECX,OPEN_EXISTING

        MOV     [ESI].TTextRec.InOutFunc,offset TextIn

        JMP     @@common

@@calledByRewrite:

        MOV     EAX,GENERIC_WRITE     // open for write
        MOV     EDX,FILE_SHARE_READ
        MOV     ECX,CREATE_ALWAYS
        JMP     @@commonOut

@@calledByAppend:

        MOV     EAX,GENERIC_READ OR GENERIC_WRITE // open for read/write
        MOV     EDX,FILE_SHARE_READ
  MOV     ECX,OPEN_EXISTING

@@commonOut:

        MOV     [ESI].TTextRec.InOutFunc,offset TextOut

@@common:

        MOV     [ESI].TTextRec.CloseFunc,offset TextClose
        MOV     [ESI].TTextRec.FlushFunc,offset FileNOPProc
        CMP     byte ptr [ESI].TTextRec.Name,0
        JE      @@isCon

//  CreateFile(t.Name, EAX, EDX, Nil, ECX, FILE_ATTRIBUTE_NORMAL, 0);

        PUSH    0
        PUSH    FILE_ATTRIBUTE_NORMAL
        PUSH    ECX
        PUSH    0
        PUSH    EDX
        PUSH    EAX
        LEA     EAX,[ESI].TTextRec.Name
        PUSH    EAX
        CALL    CreateFileA

        CMP     EAX,-1
        JZ      @@error

        MOV     [ESI].TTextRec.Handle,EAX
        CMP     [ESI].TTextRec.Mode,fmInOut
        JNE     @@success

        DEC     [ESI].TTextRec.Mode     // fmInOut -> fmOutput

{;  ???  we really have to look for the first eof byte in the
; ???  last record and truncate the file there.
; Not very nice and clean...
;
; lastRecPos = Max( GetFileSize(...) - 128, 0);
}
        PUSH    0
        PUSH    [ESI].TTextRec.Handle
        CALL    GetFileSize

        INC     EAX
        JZ      @@error
        SUB     EAX,129
        JNC     @@3
        XOR     EAX,EAX
@@3:
//  lseek(f.Handle, SEEK_SET, lastRecPos);

        PUSH    FILE_BEGIN
        PUSH    0
        PUSH    EAX
        PUSH    [ESI].TTextRec.Handle
        CALL    SetFilePointer

        INC     EAX
        JE      @@error

//  bytesRead = read(f.Handle, f.Buffer, 128);

        PUSH    0
        MOV     EDX,ESP
  PUSH    0
        PUSH    EDX
        PUSH    128
        LEA     EDX,[ESI].TTextRec.Buffer
        PUSH    EDX
        PUSH    [ESI].TTextRec.Handle
        CALL    ReadFile
        POP     EDX
        DEC     EAX
        JNZ     @@error

//  for (i = 0; i < bytesRead; i++)

        XOR     EAX,EAX
@@loop:
        CMP     EAX,EDX
        JAE     @@success

//    if  (f.Buffer[i] == eof)

        CMP     byte ptr [ESI].TTextRec.Buffer[EAX],eof
        JE      @@truncate
        INC     EAX
        JMP     @@loop

@@truncate:

//  lseek( f.Handle, SEEK_END, i - bytesRead );

        PUSH    FILE_END
        PUSH    0
        SUB     EAX,EDX
        PUSH    EAX
        PUSH    [ESI].TTextRec.Handle
        CALL    SetFilePointer
        INC     EAX
        JE      @@error

//  SetEndOfFile( f.Handle );

        PUSH    [ESI].TTextRec.Handle
        CALL    SetEndOfFile
        DEC     EAX
        JNE     @@error

        JMP     @@success

@@isCon:
        LEA     EAX,[ESI].TTextRec.Buffer
        MOV     [ESI].TTextRec.BufSize, TYPE TTextRec.Buffer
        MOV     [ESI].TTextRec.CloseFunc,offset FileNOPProc
        MOV     [ESI].TTextRec.BufPtr,EAX
        CMP     [ESI].TTextRec.Mode,fmOutput
        JE      @@output
        PUSH    STD_INPUT_HANDLE
        JMP     @@1
@@output:
        CMP     ESI,offset ErrOutput
        JNE     @@stdout
        PUSH    STD_ERROR_HANDLE
        JMP     @@1
@@stdout:
        PUSH    STD_OUTPUT_HANDLE
@@1:
        CALL    GetStdHandle
        CMP     EAX,-1
        JE      @@error
        MOV     [ESI].TTextRec.Handle,EAX

@@success:
  CMP     [ESI].TTextRec.Mode,fmInput
  JE      @@2
  PUSH    [ESI].TTextRec.Handle
  CALL    GetFileType
  TEST    EAX,EAX
  JE      @@badFileType
  CMP     EAX,2
  JNE     @@2
  MOV     [ESI].TTextRec.FlushFunc,offset TextOut
@@2:
  XOR     EAX,EAX
@@exit:
  POP     ESI
  RET

@@badFileType:
  PUSH    [ESI].TTextRec.Handle
  CALL    CloseHandle
  MOV     [ESI].TTextRec.Mode,fmClosed
  MOV     EAX,105
  JMP     @@exit

@@error:
  MOV     [ESI].TTextRec.Mode,fmClosed
        CALL    GetLastError
        JMP     @@exit
end;
{$ENDIF}

const
  fNameLen = 260;

function _Assign(var t: TTextRec; const s: String): Integer;
begin
  FillChar(t, sizeof(TFileRec), 0);
  t.BufPtr := @t.Buffer;
  t.Mode := fmClosed;
  t.Flags := tfCRLF * Byte(DefaultTextLineBreakStyle);
  t.BufSize := sizeof(t.Buffer);
  t.OpenFunc := @TextOpen;
  Move(S[1], t.Name, Length(s));
  t.Name[Length(s)] := #0;
  Result := 0;
end;

function InternalFlush(var t: TTextRec; Func: TTextIOFunc): Integer;
begin
  case t.Mode of
    fmOutput,
    fmInOut  : Result := Func(t);
    fmInput  : Result := 0;
  else
    if (@t = @Output) or (@t = @ErrOutput) then
      Result := 0
    else
      Result := 103;
  end;
  if Result <> 0 then SetInOutRes(Result);
end;

function Flush(var t: Text): Integer;
begin
  Result := InternalFlush(TTextRec(t), TTextRec(t).InOutFunc);
end;

function _Flush(var t: TTextRec): Integer;
begin
  Result := InternalFlush(t, t.FlushFunc);
end;

type
{$IFDEF MSWINDOWS}
  TIOProc = function (hFile: Integer; Buffer: Pointer; nNumberOfBytesToWrite: Cardinal;
  var lpNumberOfBytesWritten: Cardinal; lpOverlapped: Pointer): Integer; stdcall;

function ReadFileX(hFile: Integer; Buffer: Pointer; nNumberOfBytesToRead: Cardinal;
  var lpNumberOfBytesRead: Cardinal; lpOverlapped: Pointer): Integer; stdcall;
  external kernel name 'ReadFile';
function WriteFileX(hFile: Integer; Buffer: Pointer; nNumberOfBytesToWrite: Cardinal;
  var lpNumberOfBytesWritten: Cardinal; lpOverlapped: Pointer): Integer; stdcall;
  external kernel name 'WriteFile';

{$ENDIF}
{$IFDEF LINUX}
  TIOProc = function (Handle: Integer; Buffer: Pointer; Count: Cardinal): Cardinal; cdecl;
{$ENDIF}

function BlockIO(var f: TFileRec; buffer: Pointer; recCnt: Cardinal; var recsDone: Longint;
  ModeMask: Integer; IOProc: TIOProc; ErrorNo: Integer): Cardinal;
// Note:  RecsDone ptr can be nil!
begin
  if (f.Mode and ModeMask) = ModeMask then  // fmOutput or fmInOut / fmInput or fmInOut
  begin
{$IFDEF LINUX}
    Result := IOProc(f.Handle, buffer, recCnt * f.RecSize);
    if Integer(Result) = -1 then
{$ENDIF}
{$IFDEF MSWINDOWS}
    if IOProc(f.Handle, buffer, recCnt * f.RecSize, Result, nil) = 0 then
{$ENDIF}
    begin
      SetInOutRes(GetLastError);
      Result := 0;
    end
    else
    begin
      Result := Result div f.RecSize;
      if @RecsDone <> nil then
        RecsDone := Result
      else if Result <> recCnt then
      begin
        SetInOutRes(ErrorNo);
        Result := 0;
      end
    end;
  end
  else
  begin
    SetInOutRes(103);  // file not open
    Result := 0;
  end;
end;

function _BlockRead(var f: TFileRec; buffer: Pointer; recCnt: Longint; var recsRead: Longint): Longint;
begin
  Result := BlockIO(f, buffer, recCnt, recsRead, fmInput,
    {$IFDEF MSWINDOWS} ReadFileX, {$ENDIF}
    {$IFDEF LINUX} __read, {$ENDIF}
    100);
end;

function  _BlockWrite(var f: TFileRec; buffer: Pointer; recCnt: Longint; var recsWritten: Longint): Longint;
begin
  Result := BlockIO(f, buffer, recCnt, recsWritten, fmOutput,
  {$IFDEF MSWINDOWS} WriteFileX, {$ENDIF}
  {$IFDEF LINUX} __write, {$ENDIF}
  101);
end;

function _Close(var t: TTextRec): Integer;
begin
  Result := 0;
  if (t.Mode >= fmInput) and (t.Mode <= fmInOut) then
  begin
    if (t.Mode and fmOutput) = fmOutput then  // fmOutput or fmInOut
      Result := TTextIOFunc(t.InOutFunc)(t);
    if Result = 0 then
      Result := TTextIOFunc(t.CloseFunc)(t);
    if Result <> 0 then
      SetInOutRes(Result);
  end
  else
  if @t <> @Input then
    SetInOutRes(103);
end;

procedure       _PStrCat;
asm
{     ->EAX = Pointer to destination string     }
{       EDX = Pointer to source string  }

        PUSH    ESI
        PUSH    EDI

{       load dest len into EAX  }

        MOV     EDI,EAX
        XOR     EAX,EAX
        MOV     AL,[EDI]

{       load source address in ESI, source len in ECX   }

        MOV     ESI,EDX
        XOR     ECX,ECX
        MOV     CL,[ESI]
        INC     ESI

{       calculate final length in DL and store it in the destination    }

        MOV     DL,AL
        ADD     DL,CL
        JC      @@trunc

@@cont:
        MOV     [EDI],DL

{       calculate final dest address    }

        INC     EDI
        ADD     EDI,EAX

{       do the copy     }

        REP     MOVSB

{       done    }

        POP     EDI
        POP     ESI
        RET

@@trunc:
        INC     DL      {       DL = #chars to truncate                 }
        SUB     CL,DL   {       CL = source len - #chars to truncate    }
        MOV     DL,255  {       DL = maximum length                     }
        JMP     @@cont
end;

procedure       _PStrNCat;
asm
{     ->EAX = Pointer to destination string                     }
{       EDX = Pointer to source string                          }
{       CL  = max length of result (allocated size of dest - 1) }

        PUSH    ESI
        PUSH    EDI

{       load dest len into EAX  }

        MOV     EDI,EAX
        XOR     EAX,EAX
        MOV     AL,[EDI]

{       load source address in ESI, source len in EDX   }

        MOV     ESI,EDX
        XOR     EDX,EDX
        MOV     DL,[ESI]
        INC     ESI

{       calculate final length in AL and store it in the destination    }

        ADD     AL,DL
        JC      @@trunc
        CMP     AL,CL
        JA      @@trunc

@@cont:
        MOV     ECX,EDX
        MOV     DL,[EDI]
        MOV     [EDI],AL

{       calculate final dest address    }

        INC     EDI
        ADD     EDI,EDX

{       do the copy     }

        REP     MOVSB

@@done:
        POP     EDI
        POP     ESI
        RET

@@trunc:
{       CL = maxlen     }

        MOV     AL,CL   { AL = final length = maxlen            }
        SUB     CL,[EDI]        { CL = length to copy = maxlen - destlen        }
        JBE     @@done
        MOV     DL,CL
        JMP     @@cont
end;

procedure       _PStrCpy(Dest: PShortString; Source: PShortString);
begin
  Move(Source^, Dest^, Byte(Source^[0])+1);
end;

procedure       _PStrNCpy(Dest: PShortString; Source: PShortString; MaxLen: Byte);
begin
  if MaxLen > Byte(Source^[0]) then
    MaxLen := Byte(Source^[0]);
  Byte(Dest^[0]) := MaxLen;
  Move(Source^[1], Dest^[1], MaxLen);
end;

procedure       _PStrCmp;
asm
{     ->EAX = Pointer to left string    }
{       EDX = Pointer to right string   }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        XOR     EAX,EAX
        XOR     EDX,EDX
        MOV     AL,[ESI]
        MOV     DL,[EDI]
        INC     ESI
        INC     EDI

        SUB     EAX,EDX { eax = len1 - len2 }
        JA      @@skip1
        ADD     EDX,EAX { edx = len2 + (len1 - len2) = len1     }

@@skip1:
        PUSH    EDX
        SHR     EDX,2
        JE      @@cmpRest
@@longLoop:
        MOV     ECX,[ESI]
        MOV     EBX,[EDI]
        CMP     ECX,EBX
        JNE     @@misMatch
        DEC     EDX
        JE      @@cmpRestP4
        MOV     ECX,[ESI+4]
        MOV     EBX,[EDI+4]
        CMP     ECX,EBX
        JNE     @@misMatch
        ADD     ESI,8
        ADD     EDI,8
        DEC     EDX
        JNE     @@longLoop
        JMP     @@cmpRest
@@cmpRestP4:
        ADD     ESI,4
        ADD     EDI,4
@@cmpRest:
        POP     EDX
        AND     EDX,3
        JE      @@equal

        MOV     CL,[ESI]
        CMP     CL,[EDI]
        JNE     @@exit
        DEC     EDX
        JE      @@equal
        MOV     CL,[ESI+1]
        CMP     CL,[EDI+1]
        JNE     @@exit
        DEC     EDX
        JE      @@equal
        MOV     CL,[ESI+2]
        CMP     CL,[EDI+2]
        JNE     @@exit

@@equal:
        ADD     EAX,EAX
        JMP     @@exit

@@misMatch:
        POP     EDX
        CMP     CL,BL
        JNE     @@exit
        CMP     CH,BH
        JNE     @@exit
        SHR     ECX,16
        SHR     EBX,16
        CMP     CL,BL
        JNE     @@exit
        CMP     CH,BH

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure       _AStrCmp;
asm
{     ->EAX = Pointer to left string    }
{       EDX = Pointer to right string   }
{       ECX = Number of chars to compare}

        PUSH    EBX
        PUSH    ESI
        PUSH    ECX
        MOV     ESI,ECX
        SHR     ESI,2
        JE      @@cmpRest

@@longLoop:
        MOV     ECX,[EAX]
        MOV     EBX,[EDX]
        CMP     ECX,EBX
        JNE     @@misMatch
        DEC     ESI
        JE      @@cmpRestP4
        MOV     ECX,[EAX+4]
        MOV     EBX,[EDX+4]
        CMP     ECX,EBX
        JNE     @@misMatch
        ADD     EAX,8
        ADD     EDX,8
        DEC     ESI
        JNE     @@longLoop
        JMP     @@cmpRest
@@cmpRestp4:
        ADD     EAX,4
        ADD     EDX,4
@@cmpRest:
        POP     ESI
        AND     ESI,3
        JE      @@exit

        MOV     CL,[EAX]
        CMP     CL,[EDX]
        JNE     @@exit
        DEC     ESI
        JE      @@equal
        MOV     CL,[EAX+1]
        CMP     CL,[EDX+1]
        JNE     @@exit
        DEC     ESI
        JE      @@equal
        MOV     CL,[EAX+2]
        CMP     CL,[EDX+2]
        JNE     @@exit

@@equal:
        XOR     EAX,EAX
        JMP     @@exit

@@misMatch:
        POP     ESI
        CMP     CL,BL
        JNE     @@exit
        CMP     CH,BH
        JNE     @@exit
        SHR     ECX,16
        SHR     EBX,16
        CMP     CL,BL
        JNE     @@exit
        CMP     CH,BH

@@exit:
        POP     ESI
        POP     EBX
end;

function _EofFile(var f: TFileRec): Boolean;
begin
  Result := _FilePos(f) >= _FileSize(f);
end;

function _EofText(var t: TTextRec): Boolean;
asm
// -> EAX Pointer to text record
// <- AL  Boolean result
        CMP     [EAX].TTextRec.Mode,fmInput
        JNE     @@readChar
        MOV     EDX,[EAX].TTextRec.BufPos
        CMP     EDX,[EAX].TTextRec.BufEnd
        JAE     @@readChar
        ADD     EDX,[EAX].TTextRec.BufPtr
        TEST    [EAX].TTextRec.Flags,tfCRLF
        JZ      @@FalseExit
        MOV     CL,[EDX]
        CMP     CL,cEof
        JNZ     @@FalseExit

@@eof:
        MOV     AL,1
        JMP     @@exit

@@readChar:
        PUSH    EAX
        CALL    _ReadChar
        POP     EDX
        CMP     AH,cEof
        JE      @@eof
        DEC     [EDX].TTextRec.BufPos
@@FalseExit:
        XOR     EAX,EAX
@@exit:
end;

function _Eoln(var t: TTextRec): Boolean;
asm
// -> EAX Pointer to text record
// <- AL  Boolean result

        CMP     [EAX].TTextRec.Mode,fmInput
        JNE     @@readChar
        MOV     EDX,[EAX].TTextRec.BufPos
        CMP     EDX,[EAX].TTextRec.BufEnd
        JAE     @@readChar
        ADD     EDX,[EAX].TTextRec.BufPtr
        TEST    [EAX].TTextRec.Flags,tfCRLF
        MOV     AL,0
        MOV     CL,[EDX]
        JZ      @@testLF
        CMP     CL,cCR
        JE      @@eol
        CMP     CL,cEOF
        JE      @@eof
        JMP     @@exit

@@testLF:
        CMP     CL,cLF
        JE      @@eol
        CMP     CL,cEOF
        JE      @@eof
        JMP     @@exit

@@readChar:
        PUSH    EAX
        CALL    _ReadChar
        POP     EDX
        CMP     AH,cEOF
        JE      @@eof
        DEC     [EDX].TTextRec.BufPos
        XOR     ECX,ECX
        XCHG    ECX,EAX
        TEST    [EDX].TTextRec.Mode,tfCRLF
        JNE     @@testLF
        CMP     CL,cCR
        JE      @@eol
        JMP     @@exit

@@eol:
@@eof:
        MOV     AL,1
@@exit:
end;

procedure _Erase(var f: TFileRec);
begin
  if (f.Mode < fmClosed) or (f.Mode > fmInOut) then
    SetInOutRes(102)  // file not assigned
  else
{$IFDEF LINUX}
    if __remove(f.Name) < 0 then
      SetInOutRes(GetLastError);
{$ENDIF}
{$IFDEF MSWINDOWS}
    if not DeleteFileA(f.Name) then
      SetInOutRes(GetLastError);
{$ENDIF}
end;

{$IFDEF MSWINDOWS}
// Floating-point divide reverse routine
// ST(1) = ST(0) / ST(1), pop ST

procedure _FSafeDivideR;
asm
  FXCH
  JMP _FSafeDivide
end;

// Floating-point divide routine
// ST(1) = ST(1) / ST(0), pop ST

procedure _FSafeDivide;
type
  Z = packed record  // helper type to make parameter references more readable
    Dividend: Extended;   // (TBYTE PTR [ESP])
    Pad: Word;
    Divisor: Extended;    // (TBYTE PTR [ESP+12])
  end;
asm
  CMP TestFDIV,0    //Check FDIV indicator
  JLE @@FDivideChecked  //Jump if flawed or don't know
  FDIV        //Known to be ok, so just do FDIV
  RET

// FDIV constants
@@FDIVRiscTable: DB 0,1,0,0,4,0,0,7,0,0,10,0,0,13,0,0;

@@FDIVScale1:    DD $3F700000            // 0.9375
@@FDIVScale2:    DD $3F880000            // 1.0625
@@FDIV1SHL63:    DD $5F000000            // 1 SHL 63

@@TestDividend:  DD $C0000000,$4150017E  // 4195835.0
@@TestDivisor:   DD $80000000,$4147FFFF  // 3145727.0
@@TestOne:       DD $00000000,$3FF00000  // 1.0

// Flawed FDIV detection
@@FDivideDetect:
  MOV TestFDIV,1      //Indicate correct FDIV
  PUSH  EAX
  SUB ESP,12
  FSTP  TBYTE PTR [ESP]           //Save off ST
  FLD QWORD PTR @@TestDividend  //Ok if x - (x / y) * y < 1.0
  FDIV  QWORD PTR @@TestDivisor
  FMUL  QWORD PTR @@TestDivisor
  FSUBR QWORD PTR @@TestDividend
  FCOMP QWORD PTR @@TestOne
  FSTSW AX
  SHR EAX,7
  AND EAX,002H    //Zero if FDIV is flawed
  DEC EAX
  MOV TestFDIV,AL   //1 means Ok, -1 means flawed
  FLD TBYTE PTR [ESP]   //Restore ST
  ADD ESP,12
  POP EAX
  JMP _FSafeDivide

@@FDivideChecked:
  JE  @@FDivideDetect   //Do detection if TestFDIV = 0

@@1:  PUSH  EAX
  SUB ESP,24
  FSTP  [ESP].Z.Divisor     //Store Divisor and Dividend
  FSTP  [ESP].Z.Dividend
  FLD [ESP].Z.Dividend
  FLD [ESP].Z.Divisor
@@2:  MOV EAX,DWORD PTR [ESP+4].Z.Divisor   //Is Divisor a denormal?
  ADD EAX,EAX
  JNC @@20      //Yes, @@20
  XOR EAX,0E000000H   //If these three bits are not all
  TEST  EAX,0E000000H   //ones, FDIV will work
  JZ  @@10      //Jump if all ones
@@3:  FDIV        //Do FDIV and exit
  ADD ESP,24
  POP EAX
  RET

@@10: SHR EAX,28      //If the four bits following the MSB
          //of the mantissa have a decimal
          //of 1, 4, 7, 10, or 13, FDIV may
  CMP byte ptr @@FDIVRiscTable[EAX],0 //not work correctly
  JZ  @@3     //Do FDIV if not 1, 4, 7, 10, or 13
  MOV EAX,DWORD PTR [ESP+8].Z.Divisor //Get Divisor exponent
  AND EAX,7FFFH
  JZ  @@3     //Ok to FDIV if denormal
  CMP EAX,7FFFH
  JE  @@3     //Ok to FDIV if NAN or INF
  MOV EAX,DWORD PTR [ESP+8].Z.Dividend //Get Dividend exponent
  AND EAX,7FFFH
  CMP EAX,1     //Small number?
  JE  @@11      //Yes, @@11
  FMUL  DWORD PTR @@FDIVScale1  //Scale by 15/16
  FXCH
  FMUL  DWORD PTR @@FDIVScale1
  FXCH
  JMP @@3     //FDIV is now safe

@@11: FMUL  DWORD PTR @@FDIVScale2    //Scale by 17/16
  FXCH
  FMUL  DWORD PTR @@FDIVScale2
  FXCH
  JMP @@3     //FDIV is now safe

@@20: MOV EAX,DWORD PTR [ESP].Z.Divisor     //Is entire Divisor zero?
  OR  EAX,DWORD PTR [ESP+4].Z.Divisor
  JZ  @@3               //Yes, ok to FDIV
  MOV EAX,DWORD PTR [ESP+8].Z.Divisor   //Get Divisor exponent
  AND EAX,7FFFH             //Non-zero exponent is invalid
  JNZ @@3               //Ok to FDIV if invalid
  MOV EAX,DWORD PTR [ESP+8].Z.Dividend  //Get Dividend exponent
  AND EAX,7FFFH             //Denormal?
  JZ  @@21                //Yes, @@21
  CMP EAX,7FFFH             //NAN or INF?
  JE  @@3               //Yes, ok to FDIV
  MOV EAX,DWORD PTR [ESP+4].Z.Dividend  //If MSB of mantissa is zero,
  ADD EAX,EAX               //the number is invalid
  JNC @@3               //Ok to FDIV if invalid
  JMP @@22
@@21: MOV EAX,DWORD PTR [ESP+4].Z.Dividend  //If MSB of mantissa is zero,
  ADD EAX,EAX               //the number is invalid
  JC  @@3               //Ok to FDIV if invalid
@@22: FXCH                  //Scale stored Divisor image by
  FSTP  ST(0)               //1 SHL 63 and restart
  FLD ST(0)
  FMUL  DWORD PTR @@FDIV1SHL63
  FSTP  [ESP].Z.Divisor
  FLD [ESP].Z.Dividend
  FXCH
  JMP @@2
end;
{$ENDIF}

function _FilePos(var f: TFileRec): Longint;
begin
  if (f.Mode > fmClosed) and (f.Mode <= fmInOut) then
  begin
{$IFDEF LINUX}
    Result := _lseek(f.Handle, 0, SEEK_CUR);
{$ENDIF}
{$IFDEF MSWINDOWS}
    Result := SetFilePointer(f.Handle, 0, nil, FILE_CURRENT);
{$ENDIF}
    if Result = -1 then
      InOutError
    else
      Result := Cardinal(Result) div f.RecSize;
  end
  else
  begin
    SetInOutRes(103);
    Result := -1;
  end;
end;

function _FileSize(var f: TFileRec): Longint;
{$IFDEF MSWINDOWS}
begin
  Result := -1;
  if (f.Mode > fmClosed) and (f.Mode <= fmInOut) then
  begin
    Result := GetFileSize(f.Handle, 0);
    if Result = -1 then
      InOutError
    else
      Result := Cardinal(Result) div f.RecSize;
  end
  else
    SetInOutRes(103);
{$ENDIF}
{$IFDEF LINUX}
var
  stat: TStatStruct;
begin
  Result := -1;
  if (f.Mode > fmClosed) and (f.Mode <= fmInOut) then
  begin
    if _fxstat(STAT_VER_LINUX, f.Handle, stat) <> 0 then
      InOutError
    else
      Result := stat.st_size div f.RecSize;
  end
  else
    SetInOutRes(103);
{$ENDIF}
end;

procedure       _FillChar(var Dest; count: Integer; Value: Char);
{$IFDEF PUREPASCAL}
var
  I: Integer;
  P: PChar;
begin
  P := PChar(@Dest);
  for I := count-1 downto 0 do
    P[I] := Value;
end;
{$ELSE}
asm
{     ->EAX     Pointer to destination  }
{       EDX     count   }
{       CL      value   }

        PUSH    EDI

        MOV     EDI,EAX { Point EDI to destination              }

        MOV     CH,CL   { Fill EAX with value repeated 4 times  }
        MOV     EAX,ECX
        SHL     EAX,16
        MOV     AX,CX

        MOV     ECX,EDX
        SAR     ECX,2
        JS      @@exit

        REP     STOSD   { Fill count DIV 4 dwords       }

        MOV     ECX,EDX
        AND     ECX,3
        REP     STOSB   { Fill count MOD 4 bytes        }

@@exit:
        POP     EDI
end;
{$ENDIF}

procedure       Mark;
begin
  Error(reInvalidPtr);
end;

procedure       _RandInt;
asm
{     ->EAX     Range   }
{     <-EAX     Result  }
        PUSH    EBX
{$IFDEF PIC}
        PUSH    EAX
        CALL    GetGOT
        MOV     EBX,EAX
        POP     EAX
        MOV     ECX,[EBX].OFFSET RandSeed
        IMUL    EDX,[ECX],08088405H
        INC     EDX
        MOV     [ECX],EDX
{$ELSE}
        XOR     EBX, EBX
        IMUL    EDX,[EBX].RandSeed,08088405H
        INC     EDX
        MOV     [EBX].RandSeed,EDX
{$ENDIF}
        MUL     EDX
        MOV     EAX,EDX
        POP     EBX
end;

procedure       _RandExt;
const two2neg32: double = ((1.0/$10000) / $10000);  // 2^-32
asm
{       FUNCTION _RandExt: Extended;    }

        PUSH    EBX
{$IFDEF PIC}
        CALL    GetGOT
        MOV     EBX,EAX
        MOV     ECX,[EBX].OFFSET RandSeed
        IMUL    EDX,[ECX],08088405H
        INC     EDX
        MOV     [ECX],EDX
{$ELSE}
        XOR     EBX, EBX
        IMUL    EDX,[EBX].RandSeed,08088405H
        INC     EDX
        MOV     [EBX].RandSeed,EDX
{$ENDIF}

        FLD     [EBX].two2neg32
        PUSH    0
        PUSH    EDX
        FILD    qword ptr [ESP]
        ADD     ESP,8
        FMULP   ST(1), ST(0)
        POP     EBX
end;

function _ReadRec(var f: TFileRec; Buffer: Pointer): Integer;
{$IFDEF LINUX}
begin
  if (f.Mode and fmInput) = fmInput then  // fmInput or fmInOut
  begin
  Result := __read(f.Handle, Buffer, f.RecSize);
  if Result = -1 then
    InOutError
  else if Cardinal(Result) <> f.RecSize then
    SetInOutRes(100);
  end
  else
  begin
  SetInOutRes(103);  // file not open for input
  Result := 0;
  end;
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
asm
// -> EAX Pointer to file variable
//  EDX Pointer to buffer

        PUSH    EBX
        XOR     ECX,ECX
        MOV     EBX,EAX
        MOV     CX,[EAX].TFileRec.Mode   // File must be open
        SUB     ECX,fmInput
        JE      @@skip
        SUB     ECX,fmInOut-fmInput
        JNE     @@fileNotOpen
@@skip:

//  ReadFile(f.Handle, buffer, f.RecSize, @result, Nil);

        PUSH    0     // space for OS result
        MOV     EAX,ESP

        PUSH    0     // pass lpOverlapped
        PUSH    EAX     // pass @result

        PUSH    [EBX].TFileRec.RecSize    // pass nNumberOfBytesToRead

        PUSH    EDX     // pass lpBuffer
        PUSH    [EBX].TFileRec.Handle   // pass hFile
        CALL    ReadFile
        POP     EDX     // pop result
        DEC     EAX     // check EAX = TRUE
        JNZ     @@error

        CMP     EDX,[EBX].TFileRec.RecSize  // result = f.RecSize ?
        JE      @@exit

@@readError:
        MOV EAX,100
        JMP @@errExit

@@fileNotOpen:
        MOV EAX,103
        JMP @@errExit

@@error:
        CALL  GetLastError
@@errExit:
        CALL  SetInOutRes
@@exit:
        POP EBX
end;
{$ENDIF}


// If the file is Input std variable, try to open it
// Otherwise, runtime error.
function TryOpenForInput(var t: TTextRec): Boolean;
begin
  if @t = @Input then
  begin
    t.Flags := tfCRLF * Byte(DefaultTextLineBreakStyle);
    _ResetText(t);
  end;

  Result := t.Mode = fmInput;
  if not Result then
    SetInOutRes(104);
end;

function _ReadChar(var t: TTextRec): Char;
asm
// -> EAX Pointer to text record
// <- AL  Character read. (may be a pseudo cEOF in DOS mode)
// <- AH  cEOF = End of File, else 0
//    For eof, #$1A is returned in AL and in AH.
//    For errors, InOutRes is set and #$1A is returned.

        CMP     [EAX].TTextRec.Mode, fmInput
        JE      @@checkBuf
        PUSH    EAX
        CALL    TryOpenForInput
        TEST    AL,AL
        POP     EAX
        JZ      @@eofexit

@@checkBuf:
        MOV     EDX,[EAX].TTextRec.BufPos
        CMP     EDX,[EAX].TTextRec.BufEnd
        JAE     @@fillBuf
@@cont:
        TEST    [EAX].TTextRec.Flags,tfCRLF
        MOV     ECX,[EAX].TTextRec.BufPtr
        MOV     CL,[ECX+EDX]
        JZ      @@cont2
        CMP     CL,cEof                       // Check for EOF char in DOS mode
        JE      @@eofexit
@@cont2:
        INC     EDX
        MOV     [EAX].TTextRec.BufPos,EDX
        XOR     EAX,EAX
        JMP     @@exit

@@fillBuf:
        PUSH    EAX
        CALL    [EAX].TTextRec.InOutFunc
        TEST    EAX,EAX
        JNE     @@error
        POP     EAX
        MOV     EDX,[EAX].TTextRec.BufPos
        CMP     EDX,[EAX].TTextRec.BufEnd
        JB      @@cont

//  We didn't get characters. Must be eof then.

@@eof:
        TEST    [EAX].TTextRec.Flags,tfCRLF
        JZ      @@eofexit
//  In DOS CRLF compatibility mode, synthesize an EOF char
//  Store one eof in the buffer and increment BufEnd
        MOV     ECX,[EAX].TTextRec.BufPtr
        MOV     byte ptr [ECX+EDX],cEof
        INC     [EAX].TTextRec.BufEnd
        JMP     @@eofexit

@@error:
        CALL    SetInOutRes
        POP     EAX
@@eofexit:
        MOV     CL,cEof
        MOV     AH,CL
@@exit:
        MOV     AL,CL
end;

function _ReadLong(var t: TTextRec): Longint;
asm
// -> EAX Pointer to text record
// <- EAX Result

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        SUB     ESP,36      // var numbuf: String[32];

        MOV     ESI,EAX
        CALL    _SeekEof
        DEC     AL
        JZ      @@eof

        MOV     EDI,ESP     // EDI -> numBuf[0]
        MOV     BL,32
@@loop:
        MOV     EAX,ESI
        CALL    _ReadChar
        CMP     AL,' '
        JBE     @@endNum
        STOSB
        DEC     BL
        JNZ     @@loop
@@convert:
        MOV     byte ptr [EDI],0
        MOV     EAX,ESP     // EAX -> numBuf
        PUSH    EDX     // allocate code result
        MOV     EDX,ESP     // pass pointer to code
        CALL    _ValLong    // convert
        POP     EDX     // pop code result into EDX
        TEST    EDX,EDX
        JZ      @@exit
        MOV     EAX,106
        CALL    SetInOutRes
        JMP     @@exit

@@endNum:
        CMP     AH,cEof
        JE      @@convert
        DEC     [ESI].TTextRec.BufPos
        JMP     @@convert

@@eof:
        XOR     EAX,EAX
@@exit:
        ADD     ESP,36
        POP     EDI
        POP     ESI
        POP     EBX
end;

function ReadLine(var t: TTextRec; buf: Pointer; maxLen: Longint): Pointer;
asm
// -> EAX Pointer to text record
//  EDX Pointer to buffer
//  ECX Maximum count of chars to read
// <- ECX Actual count of chars in buffer
// <- EAX Pointer to text record

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    ECX
        MOV     ESI,ECX
        MOV     EDI,EDX

        CMP     [EAX].TTextRec.Mode,fmInput
        JE      @@start
        PUSH    EAX
        CALL    TryOpenForInput
        TEST    AL,AL
        POP     EAX
        JZ      @@exit

@@start:
        MOV     EBX,EAX

        TEST    ESI,ESI
        JLE     @@exit

        MOV     EDX,[EBX].TTextRec.BufPos
        MOV     ECX,[EBX].TTextRec.BufEnd
        SUB     ECX,EDX
        ADD     EDX,[EBX].TTextRec.BufPtr

@@loop:
        DEC     ECX
        JL      @@readChar
        MOV     AL,[EDX]
        INC     EDX
@@cont:
        CMP     AL,cLF
        JE      @@lf

        CMP     AL,cCR
        JE      @@cr

        STOSB
        DEC     ESI
        JG      @@loop
        JMP     @@finish

@@cr:
        MOV     AL,[EDX]
        CMP     AL,cLF
        JNE     @@loop
@@lf:
        DEC     EDX
@@finish:
        SUB     EDX,[EBX].TTextRec.BufPtr
        MOV     [EBX].TTextRec.BufPos,EDX
        JMP     @@exit

@@readChar:
        MOV     [EBX].TTextRec.BufPos,EDX
        MOV     EAX,EBX
        CALL    _ReadChar
        MOV     EDX,[EBX].TTextRec.BufPos
        MOV     ECX,[EBX].TTextRec.BufEnd
        SUB     ECX,EDX
        ADD     EDX,[EBX].TTextRec.BufPtr
        TEST    AH,AH    //eof
        JZ      @@cont

@@exit:
        MOV     EAX,EBX
        POP     ECX
        SUB     ECX,ESI
        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure _ReadString(var t: TTextRec; s: PShortString; maxLen: Longint);
asm
// -> EAX Pointer to text record
//  EDX Pointer to string
//  ECX Maximum length of string

        PUSH     EDX
        INC      EDX
        CALL     ReadLine
        POP      EDX
        MOV      [EDX],CL
end;

procedure _ReadCString(var t: TTextRec; s: PChar; maxLen: Longint);
asm
// -> EAX Pointer to text record
//  EDX Pointer to string
//  ECX Maximum length of string

        PUSH    EDX
        CALL    ReadLine
        POP     EDX
        MOV     byte ptr [EDX+ECX],0
end;

procedure _ReadLString(var t: TTextRec; var s: AnsiString);
asm
        { ->    EAX     pointer to Text         }
        {       EDX     pointer to AnsiString   }

        PUSH    EBX
        PUSH    ESI
        MOV     EBX,EAX
        MOV     ESI,EDX

        MOV     EAX,EDX
        CALL    _LStrClr

        SUB     ESP,256

        MOV     EAX,EBX
        MOV     EDX,ESP
        MOV     ECX,255
        CALL    _ReadString

        MOV     EAX,ESI
        MOV     EDX,ESP
        CALL    _LStrFromString

        CMP     byte ptr [ESP],255
        JNE     @@exit
@@loop:

        MOV     EAX,EBX
        MOV     EDX,ESP
        MOV     ECX,255
        CALL    _ReadString

        MOV     EDX,ESP
        PUSH    0
        MOV     EAX,ESP
        CALL    _LStrFromString

        MOV     EAX,ESI
        MOV     EDX,[ESP]
        CALL    _LStrCat

        MOV     EAX,ESP
        CALL    _LStrClr
        POP     EAX

        CMP     byte ptr [ESP],255
        JE      @@loop

@@exit:
        ADD     ESP,256
        POP     ESI
        POP     EBX
end;


function IsValidMultibyteChar(const Src: PChar; SrcBytes: Integer): Boolean;
{$IFDEF MSWINDOWS}
const
  ERROR_NO_UNICODE_TRANSLATION = 1113;   // Win32 GetLastError when result = 0
  MB_ERR_INVALID_CHARS         = 8;
var
  Dest: WideChar;
begin
  Result := MultiByteToWideChar(0, MB_ERR_INVALID_CHARS, Src, SrcBytes, @Dest, 1) <> 0;
{$ENDIF}
{$IFDEF LINUX}
begin
  Result := mblen(Src, SrcBytes) <> -1;
{$ENDIF}
end;


function _ReadWChar(var t: TTextRec): WideChar;
var
  scratch: array [0..7] of AnsiChar;
  wc: WideChar;
  i: Integer;
begin
  i := 0;
  while i < High(scratch) do
  begin
    scratch[i] := _ReadChar(t);
    Inc(i);
    scratch[i] := #0;
    if IsValidMultibyteChar(scratch, i) then
    begin
      WCharFromChar(@wc, 1, scratch, i);
      Result := wc;
      Exit;
    end;
  end;
  SetInOutRes(106);  // Invalid Input
  Result := #0;
end;


procedure _ReadWCString(var t: TTextRec; s: PWideChar; maxBytes: Longint);
var
  i, maxLen: Integer;
  wc: WideChar;
begin
  if s = nil then Exit;
  i := 0;
  maxLen := maxBytes div sizeof(WideChar);
  while i < maxLen do
  begin
    wc := _ReadWChar(t);
    case Integer(wc) of
      cEOF: if _EOFText(t) then Break;
      cLF : begin
              Dec(t.BufPos);
              Break;
            end;
      cCR : if Byte(t.BufPtr[t.BufPos]) = cLF then
            begin
              Dec(t.BufPos);
              Break;
            end;
    end;
    s[i] := wc;
    Inc(i);
  end;
  s[i] := #0;
end;

procedure _ReadWString(var t: TTextRec; var s: WideString);
var
  Temp: AnsiString;
begin
  _ReadLString(t, Temp);
  s := Temp;
end;

function _ReadExt(var t: TTextRec): Extended;
asm
// -> EAX Pointer to text record
// <- FST(0)  Result

        PUSH     EBX
        PUSH     ESI
        PUSH     EDI
        SUB      ESP,68      // var numbuf: array[0..64] of char;

        MOV      ESI,EAX
        CALL     _SeekEof
        DEC      AL
        JZ       @@eof

        MOV      EDI,ESP     // EDI -> numBuf[0]
        MOV      BL,64
@@loop:
        MOV      EAX,ESI
        CALL     _ReadChar
        CMP      AL,' '
        JBE      @@endNum
        STOSB
        DEC      BL
        JNZ      @@loop
@@convert:
        MOV      byte ptr [EDI],0
        MOV      EAX,ESP     // EAX -> numBuf
        PUSH     EDX     // allocate code result
        MOV      EDX,ESP     // pass pointer to code
        CALL     _ValExt     // convert
        POP      EDX     // pop code result into EDX
        TEST     EDX,EDX
        JZ       @@exit
        MOV      EAX,106
        CALL     SetInOutRes
        JMP      @@exit

@@endNum:
        CMP      AH,cEOF
        JE       @@convert
        DEC      [ESI].TTextRec.BufPos
        JMP      @@convert

@@eof:
        FLDZ
@@exit:
        ADD      ESP,68
        POP      EDI
        POP      ESI
        POP      EBX
end;

procedure _ReadLn(var t: TTextRec);
asm
// -> EAX Pointer to text record

        PUSH     EBX
        MOV      EBX,EAX
@@loop:
        MOV      EAX,EBX
        CALL     _ReadChar

        CMP      AL,cLF            // accept LF as end of line
        JE       @@exit
        CMP      AH,cEOF
        JE       @@eof
        CMP      AL,cCR
        JNE      @@loop

        MOV      EAX,EBX
        CALL     _ReadChar

        CMP      AL,cLF            // accept CR+LF as end of line
        JE       @@exit
        CMP      AH,cEOF           // accept CR+EOF as end of line
        JE       @@eof
        DEC      [EBX].TTextRec.BufPos
        JMP      @@loop            // else CR+ anything else is not a line break.

@@exit:
@@eof:
        POP      EBX
end;

procedure _Rename(var f: TFileRec; newName: PChar);
var
  I: Integer;
begin
  if f.Mode = fmClosed then
  begin
    if newName = nil then newName := '';
{$IFDEF LINUX}
    if __rename(f.Name, newName) = 0 then
{$ENDIF}
{$IFDEF MSWINDOWS}
    if MoveFileA(f.Name, newName) then
{$ENDIF}
    begin
      I := 0;
      while (newName[I] <> #0) and (I < High(f.Name)) do
      begin
        f.Name[I] := newName[I];
        Inc(I);
      end
    end
    else
      SetInOutRes(GetLastError);
  end
  else
    SetInOutRes(102);
end;

procedure       Release;
begin
  Error(reInvalidPtr);
end;

function _CloseFile(var f: TFileRec): Integer;
begin
  f.Mode := fmClosed;
  Result := 0;
  if not InternalClose(f.Handle) then
  begin
    InOutError;
    Result := 1;
  end;
end;

function OpenFile(var f: TFileRec; recSiz: Longint; mode: Longint): Integer;
{$IFDEF LINUX}
var
  Flags: Integer;
begin
  Result := 0;
  if (f.Mode >= fmClosed) and (f.Mode <= fmInOut) then
  begin
    if f.Mode <> fmClosed then // not yet closed: close it
    begin
      Result := TFileIOFunc(f.CloseFunc)(f);
      if Result <> 0 then
        SetInOutRes(Result);
    end;

    if recSiz <= 0 then
      SetInOutRes(106);

    f.RecSize := recSiz;
    f.InOutFunc := @FileNopProc;

    if f.Name[0] <> #0 then
    begin
      f.CloseFunc := @_CloseFile;
      case mode of
        1: begin
             Flags := O_APPEND or O_WRONLY;
             f.Mode := fmOutput;
           end;
        2: begin
             Flags := O_RDWR;
             f.Mode := fmInOut;
           end;
        3: begin
             Flags := O_CREAT or O_TRUNC or O_RDWR;
             f.Mode := fmInOut;
           end;
      else
        Flags := O_RDONLY;
        f.Mode := fmInput;
      end;

      f.Handle := __open(f.Name, Flags, FileAccessRights);
    end
    else  // stdin or stdout
    begin
      f.CloseFunc := @FileNopProc;
      if mode = 3 then
        f.Handle := STDOUT_FILENO
      else
        f.Handle := STDIN_FILENO;
    end;

    if f.Handle = -1 then
    begin
      f.Mode := fmClosed;
      InOutError;
    end;
  end
  else
    SetInOutRes(102);
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
const
  ShareTab: array [0..7] of Integer =
    (FILE_SHARE_READ OR FILE_SHARE_WRITE,  // OF_SHARE_COMPAT     0x00000000
     0,                                    // OF_SHARE_EXCLUSIVE  0x00000010
     FILE_SHARE_READ,                      // OF_SHARE_DENY_WRITE 0x00000020
     FILE_SHARE_WRITE,                     // OF_SHARE_DENY_READ  0x00000030
     FILE_SHARE_READ OR FILE_SHARE_WRITE,  // OF_SHARE_DENY_NONE  0x00000040
     0,0,0);
asm
//->  EAX Pointer to file record
//  EDX Record size
//  ECX File mode

        PUSH     EBX
        PUSH     ESI
        PUSH     EDI

        MOV      ESI,EDX
        MOV      EDI,ECX
        XOR      EDX,EDX
        MOV      EBX,EAX

  MOV      DX,[EAX].TFileRec.Mode
        SUB      EDX,fmClosed
        JE       @@alreadyClosed
        CMP      EDX,fmInOut-fmClosed
        JA       @@notAssignedError

//  not yet closed: close it. File parameter is still in EAX

        CALL     [EBX].TFileRec.CloseFunc
        TEST     EAX,EAX
        JE       @@alreadyClosed
        CALL     SetInOutRes

@@alreadyClosed:

        MOV     [EBX].TFileRec.Mode,fmInOut
        MOV     [EBX].TFileRec.RecSize,ESI
        MOV     [EBX].TFileRec.CloseFunc,offset _CloseFile
        MOV     [EBX].TFileRec.InOutFunc,offset FileNopProc

        CMP     byte ptr [EBX].TFileRec.Name,0
        JE      @@isCon

        MOV     EAX,GENERIC_READ OR GENERIC_WRITE
        MOV     DL,FileMode
        AND     EDX,070H
        SHR     EDX,4-2
        MOV     EDX,dword ptr [shareTab+EDX]
        MOV     ECX,CREATE_ALWAYS

        SUB     EDI,3
        JE      @@calledByRewrite

        MOV     ECX,OPEN_EXISTING
        INC     EDI
        JE      @@skip

        MOV     EAX,GENERIC_WRITE
        INC     EDI
        MOV     [EBX].TFileRec.Mode,fmOutput
        JE      @@skip

        MOV     EAX,GENERIC_READ
        MOV     [EBX].TFileRec.Mode,fmInput

@@skip:
@@calledByRewrite:

//  CreateFile(t.FileName, EAX, EDX, Nil, ECX, FILE_ATTRIBUTE_NORMAL, 0);

        PUSH     0
        PUSH     FILE_ATTRIBUTE_NORMAL
        PUSH     ECX
        PUSH     0
        PUSH     EDX
        PUSH     EAX
        LEA      EAX,[EBX].TFileRec.Name
        PUSH     EAX
        CALL     CreateFileA
@@checkHandle:
        CMP      EAX,-1
        JZ       @@error

        MOV      [EBX].TFileRec.Handle,EAX
        JMP      @@exit

@@isCon:
        MOV      [EBX].TFileRec.CloseFunc,offset FileNopProc
        CMP      EDI,3
        JE       @@output
        PUSH     STD_INPUT_HANDLE
        JMP      @@1
@@output:
        PUSH     STD_OUTPUT_HANDLE
@@1:
        CALL     GetStdHandle
        JMP      @@checkHandle

@@notAssignedError:
        MOV      EAX,102
        JMP      @@errExit

@@error:
        MOV      [EBX].TFileRec.Mode,fmClosed
        CALL     GetLastError
@@errExit:
        CALL     SetInOutRes

@@exit:
        POP      EDI
        POP      ESI
        POP      EBX
end;
{$ENDIF}

function _ResetFile(var f: TFileRec; recSize: Longint): Integer;
var
  m: Byte;
begin
  m := FileMode and 3;
  if m > 2 then m := 2;
  Result := OpenFile(f, recSize, m);
end;

function _RewritFile(var f: TFileRec; recSize: Longint): Integer;
begin
  Result := OpenFile(f, recSize, 3);
end;

procedure _Seek(var f: TFileRec; recNum: Cardinal);
{$IFDEF LINUX}
begin
  if (f.Mode >= fmInput) and (f.Mode <= fmInOut) then
  begin
    if _lseek(f.Handle, f.RecSize * recNum, SEEK_SET) = -1 then
      InOutError;
  end
  else
    SetInOutRes(103);
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
asm
// -> EAX Pointer to file variable
//  EDX Record number

        MOV      ECX,EAX
        MOVZX    EAX,[EAX].TFileRec.Mode // check whether file is open
        SUB      EAX,fmInput
        CMP      EAX,fmInOut-fmInput
        JA       @@fileNotOpen

//  SetFilePointer(f.Handle, recNum*f.RecSize, FILE_BEGIN
        PUSH     FILE_BEGIN    // pass dwMoveMethod
        MOV      EAX,[ECX].TFileRec.RecSize
        MUL      EDX
        PUSH     0           // pass lpDistanceToMoveHigh
        PUSH     EAX           // pass lDistanceToMove
        PUSH     [ECX].TFileRec.Handle   // pass hFile
        CALL     SetFilePointer          // get current position
        INC      EAX
        JZ       InOutError
        JMP      @@exit

@@fileNotOpen:
        MOV      EAX,103
        JMP      SetInOutRes

@@exit:
end;
{$ENDIF}

function _SeekEof(var t: TTextRec): Boolean;
asm
// -> EAX Pointer to text record
// <- AL  Boolean result

        PUSH     EBX
        MOV      EBX,EAX
@@loop:
        MOV      EAX,EBX
        CALL     _ReadChar
        CMP      AL,' '
        JA       @@endloop
        CMP      AH,cEOF
        JE       @@eof
        JMP      @@loop
@@eof:
        MOV      AL,1
        JMP      @@exit

@@endloop:
        DEC      [EBX].TTextRec.BufPos
        XOR      AL,AL
@@exit:
        POP      EBX
end;

function _SeekEoln(var t: TTextRec): Boolean;
asm
// -> EAX Pointer to text record
// <- AL  Boolean result

        PUSH     EBX
        MOV      EBX,EAX
@@loop:
        MOV      EAX,EBX
        CALL     _ReadChar
        CMP      AL,' '
        JA       @@falseExit
        CMP      AH,cEOF
        JE       @@eof
        CMP      AL,cLF
        JE       @@trueExit
        CMP      AL,cCR
        JNE      @@loop

@@trueExit:
        MOV      AL,1
        JMP      @@exitloop

@@falseExit:
        XOR      AL,AL
@@exitloop:
        DEC      [EBX].TTextRec.BufPos
        JMP      @@exit

@@eof:
        MOV      AL,1
@@exit:
        POP EBX
end;

procedure _SetTextBuf(var t: TTextRec; p: Pointer; size: Longint);
begin
  t.BufPtr := P;
  t.BufSize := size;
  t.BufPos := 0;
  t.BufEnd := 0;
end;

procedure _StrLong(val, width: Longint; s: PShortString);
{$IFDEF PUREPASCAL}
var
  I: Integer;
  sign: Longint;
  a: array [0..19] of char;
  P: PChar;
begin
  sign := val;
  val := Abs(val);
  I := 0;
  repeat
    a[I] := Chr((val mod 10) + Ord('0'));
    Inc(I);
    val := val div 10;
  until val = 0;

  if sign < 0 then
  begin
    a[I] := '-';
    Inc(I);
  end;

  if width < I then
    width := I;
  if width > 255 then
    width := 255;
  s^[0] := Chr(width);
  P := @S^[1];
  while width > I do
  begin
    P^ := ' ';
    Inc(P);
    Dec(width);
  end;
  repeat
    Dec(I);
    P^ := a[I];
    Inc(P);
  until I <= 0;
end;
{$ELSE}
asm
{       PROCEDURE _StrLong( val: Longint; width: Longint; VAR s: ShortString );
      ->EAX     Value
        EDX     Width
        ECX     Pointer to string       }

        PUSH    EBX             { VAR i: Longint;               }
        PUSH    ESI             { VAR sign : Longint;           }
        PUSH    EDI
        PUSH    EDX             { store width on the stack      }
        SUB     ESP,20          { VAR a: array [0..19] of Char; }

        MOV     EDI,ECX

        MOV     ESI,EAX         { sign := val                   }

        CDQ                     { val := Abs(val);  canned sequence }
        XOR     EAX,EDX
        SUB     EAX,EDX

        MOV     ECX,10
        XOR     EBX,EBX         { i := 0;                       }

@@repeat1:                      { repeat                        }
        XOR     EDX,EDX         {   a[i] := Chr( val MOD 10 + Ord('0') );}

        DIV     ECX             {   val := val DIV 10;          }

        ADD     EDX,'0'
        MOV     [ESP+EBX],DL
        INC     EBX             {   i := i + 1;                 }
        TEST    EAX,EAX         { until val = 0;                }
        JNZ     @@repeat1

        TEST    ESI,ESI
        JGE     @@2
        MOV     byte ptr [ESP+EBX],'-'
        INC     EBX
@@2:
        MOV     [EDI],BL        { s^++ := Chr(i);               }
        INC     EDI

        MOV     ECX,[ESP+20]    { spaceCnt := width - i;        }
        CMP     ECX,255
        JLE     @@3
        MOV     ECX,255
@@3:
        SUB     ECX,EBX
        JLE     @@repeat2       { for k := 1 to spaceCnt do s^++ := ' ';        }
        ADD     [EDI-1],CL
        MOV     AL,' '
        REP     STOSB

@@repeat2:                      { repeat                        }
        MOV     AL,[ESP+EBX-1]  {   s^ := a[i-1];               }
        MOV     [EDI],AL
        INC     EDI             {   s := s + 1                  }
        DEC     EBX             {   i := i - 1;                 }
        JNZ     @@repeat2       { until i = 0;                  }

        ADD     ESP,20+4
        POP     EDI
        POP     ESI
        POP     EBX
end;
{$ENDIF}

procedure  _Str0Long(val: Longint; s: PShortString);
begin
  _StrLong(val, 0, s);
end;

procedure _Truncate(var f: TFileRec);
{$IFDEF LINUX}
begin
  if (f.Mode and fmOutput) = fmOutput then  // fmOutput or fmInOut
  begin
    if _ftruncate(f.Handle, _lseek(f.Handle, 0, SEEK_CUR)) = -1 then
      InOutError;
  end
  else
    SetInOutRes(103);
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
asm
// -> EAX Pointer to text or file variable

       MOVZX   EDX,[EAX].TFileRec.Mode   // check whether file is open
       SUB     EDX,fmInput
       CMP     EDX,fmInOut-fmInput
       JA      @@fileNotOpen

       PUSH    [EAX].TFileRec.Handle
       CALL    SetEndOfFile
       DEC     EAX
       JZ      @@exit
       JMP     InOutError

@@fileNotOpen:
       MOV     EAX,103
       JMP     SetInOutRes

@@exit:
end;
{$ENDIF}

function _ValLong(const s: String; var code: Integer): Longint;
{$IFDEF PUREPASCAL}
var
  I: Integer;
  Negative, Hex: Boolean;
begin
  I := 1;
  code := -1;
  Result := 0;
  Negative := False;
  Hex := False;
  while (I <= Length(s)) and (s[I] = ' ') do Inc(I);
  if I > Length(s) then Exit;
  case s[I] of
    '$',
    'x',
    'X': begin
           Hex := True;
           Inc(I);
         end;
    '0': begin
          Hex := (Length(s) > I) and (UpCase(s[I+1]) = 'X');
    if Hex then Inc(I,2);
         end;
    '-': begin
          Negative := True;
          Inc(I);
         end;
    '+': Inc(I);
  end;
  if Hex then
    while I <= Length(s) do
    begin
      if Result > (High(Result) div 16) then
      begin
        code := I;
        Exit;
      end;
      case s[I] of
        '0'..'9': Result := Result * 16 + Ord(s[I]) - Ord('0');
        'a'..'f': Result := Result * 16 + Ord(s[I]) - Ord('a') + 10;
        'A'..'F': Result := Result * 16 + Ord(s[I]) - Ord('A') + 10;
      else
        code := I;
        Exit;
      end;
    end
  else
    while I <= Length(s) do
    begin
      if Result > (High(Result) div 10) then
      begin
        code := I;
        Exit;
      end;
      Result := Result * 10 + Ord(s[I]) - Ord('0');
      Inc(I);
    end;
  if Negative then
    Result := -Result;
  code := 0;
end;
{$ELSE}
asm
{       FUNCTION _ValLong( s: AnsiString; VAR code: Integer ) : Longint;        }
{     ->EAX     Pointer to string       }
{       EDX     Pointer to code result  }
{     <-EAX     Result                  }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        PUSH    EAX             { save for the error case       }

        TEST    EAX,EAX
        JE      @@empty

        XOR     EAX,EAX
        XOR     EBX,EBX
        MOV     EDI,07FFFFFFFH / 10     { limit }

@@blankLoop:
        MOV     BL,[ESI]
        INC     ESI
        CMP     BL,' '
        JE      @@blankLoop

@@endBlanks:
        MOV     CH,0
        CMP     BL,'-'
        JE      @@minus
        CMP     BL,'+'
        JE      @@plus
        CMP     BL,'$'
        JE      @@dollar

        CMP     BL, 'x'
        JE      @@dollar
        CMP     BL, 'X'
        JE      @@dollar
        CMP     BL, '0'
        JNE     @@firstDigit
        MOV     BL, [ESI]
        INC     ESI
        CMP     BL, 'x'
        JE      @@dollar
        CMP     BL, 'X'
        JE      @@dollar
        TEST    BL, BL
        JE      @@endDigits
        JMP     @@digLoop

@@firstDigit:
        TEST    BL,BL
        JE      @@error

@@digLoop:
        SUB     BL,'0'
        CMP     BL,9
        JA      @@error
        CMP     EAX,EDI         { value > limit ?       }
        JA      @@overFlow
        LEA     EAX,[EAX+EAX*4]
        ADD     EAX,EAX
        ADD     EAX,EBX         { fortunately, we can't have a carry    }

        MOV     BL,[ESI]
        INC     ESI

        TEST    BL,BL
        JNE     @@digLoop

@@endDigits:
        DEC     CH
        JE      @@negate
        TEST    EAX,EAX
        JGE     @@successExit
        JMP     @@overFlow

@@empty:
        INC     ESI
        JMP     @@error

@@negate:
        NEG     EAX
        JLE     @@successExit
        JS      @@successExit           { to handle 2**31 correctly, where the negate overflows }

@@error:
@@overFlow:
        POP     EBX
        SUB     ESI,EBX
        JMP     @@exit

@@minus:
        INC     CH
@@plus:
        MOV     BL,[ESI]
        INC     ESI
        JMP     @@firstDigit

@@dollar:
        MOV     EDI,0FFFFFFFH

        MOV     BL,[ESI]
        INC     ESI
        TEST    BL,BL
        JZ      @@empty

@@hDigLoop:
        CMP     BL,'a'
        JB      @@upper
        SUB     BL,'a' - 'A'
@@upper:
        SUB     BL,'0'
        CMP     BL,9
        JBE     @@digOk
        SUB     BL,'A' - '0'
        CMP     BL,5
        JA      @@error
        ADD     BL,10
@@digOk:
        CMP     EAX,EDI
        JA      @@overFlow
        SHL     EAX,4
        ADD     EAX,EBX

        MOV     BL,[ESI]
        INC     ESI

        TEST    BL,BL
        JNE     @@hDigLoop

@@successExit:
        POP     ECX                     { saved copy of string pointer  }
        XOR     ESI,ESI         { signal no error to caller     }

@@exit:
        MOV     [EDX],ESI
        POP     EDI
        POP     ESI
        POP     EBX
end;
{$ENDIF}

function _WriteRec(var f: TFileRec; buffer: Pointer): Pointer;
{$IFDEF LINUX}
var
  Dummy: Integer;
begin
  _BlockWrite(f, Buffer, 1, Dummy);
  Result := @F;
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
asm
// -> EAX Pointer to file variable
//  EDX Pointer to buffer
// <- EAX Pointer to file variable
        PUSH    EBX

        MOV     EBX,EAX

        MOVZX   EAX,[EAX].TFileRec.Mode
        SUB     EAX,fmOutput
        CMP     EAX,fmInOut-fmOutput  // File must be fmInOut or fmOutput
        JA      @@fileNotOpen

//  WriteFile(f.Handle, buffer, f.RecSize, @result, Nil);

        PUSH    0                       // space for OS result
        MOV     EAX,ESP

        PUSH    0                       // pass lpOverlapped
        PUSH    EAX                     // pass @result
        PUSH    [EBX].TFileRec.RecSize  // pass nNumberOfBytesToRead
        PUSH    EDX                     // pass lpBuffer
        PUSH    [EBX].TFileRec.Handle   // pass hFile
        CALL    WriteFile
        POP     EDX                     // pop result
        DEC     EAX                     // check EAX = TRUE
        JNZ     @@error

        CMP     EDX,[EBX].TFileRec.RecSize  // result = f.RecSize ?
        JE      @@exit

@@writeError:
        MOV     EAX,101
        JMP     @@errExit

@@fileNotOpen:
        MOV     EAX,5
        JMP     @@errExit

@@error:
        CALL    GetLastError
@@errExit:
        CALL    SetInOutRes
@@exit:
        MOV     EAX,EBX
        POP     EBX
end;
{$ENDIF}

// If the file is Output or ErrOutput std variable, try to open it
// Otherwise, runtime error.
function TryOpenForOutput(var t: TTextRec): Boolean;
begin
  if (@t = @Output) or (@t = @ErrOutput) then
  begin
    t.Flags := tfCRLF * Byte(DefaultTextLineBreakStyle);
    _RewritText(t);
  end;

  Result := t.Mode = fmOutput;
  if not Result then
    SetInOutRes(105);
end;

function _WriteBytes(var t: TTextRec; const b; cnt : Longint): Pointer;
{$IFDEF PUREPASCAL}
var
  P: PChar;
  RemainingBytes: Longint;
  Temp: Integer;
begin
  Result := @t;
  if t.Mode <> fmOutput and not TryOpenForOutput(t) then Exit;

  P := t.BufPtr + t.BufPos;
  RemainingBytes := t.BufSize - t.BufPos;
  while RemainingBytes <= cnt do
  begin
    Inc(t.BufPos, RemainingBytes);
    Dec(cnt, RemainingBytes);
    Move(B, P^, RemainingBytes);
    Temp := TTextIOFunc(t.InOutFunc)(t);
    if Temp <> 0 then
    begin
      SetInOutRes(Temp);
      Exit;
    end;
    P := t.BufPtr + t.BufPos;
    RemainingBytes := t.BufSize - t.BufPos;
  end;
  Inc(t.BufPos, cnt);
  Move(B, P^, cnt);
end;
{$ELSE}
asm
// -> EAX Pointer to file record
//  EDX Pointer to buffer
//  ECX Number of bytes to write
// <- EAX Pointer to file record

        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EDX

        CMP     [EAX].TTextRec.Mode,fmOutput
        JE      @@loop
        PUSH    EAX
        PUSH    EDX
        PUSH    ECX
        CALL    TryOpenForOutput
        TEST    AL,AL
        POP     ECX
        POP     EDX
        POP     EAX
        JE      @@exit

@@loop:
        MOV     EDI,[EAX].TTextRec.BufPtr
        ADD     EDI,[EAX].TTextRec.BufPos

//  remainingBytes = t.bufSize - t.bufPos

        MOV     EDX,[EAX].TTextRec.BufSize
        SUB     EDX,[EAX].TTextRec.BufPos

//  if (remainingBytes <= cnt)

        CMP     EDX,ECX
        JG      @@1

//  t.BufPos += remainingBytes, cnt -= remainingBytes

        ADD     [EAX].TTextRec.BufPos,EDX
        SUB     ECX,EDX

//  copy remainingBytes, advancing ESI

        PUSH    EAX
        PUSH    ECX
        MOV     ECX,EDX
        REP     MOVSB

        CALL    [EAX].TTextRec.InOutFunc
        TEST    EAX,EAX
        JNZ     @@error

        POP     ECX
        POP     EAX
        JMP     @@loop

@@error:
        CALL    SetInOutRes
        POP     ECX
        POP     EAX
        JMP     @@exit
@@1:
        ADD     [EAX].TTextRec.BufPos,ECX
        REP     MOVSB

@@exit:
        POP     EDI
        POP     ESI
end;
{$ENDIF}

function _WriteSpaces(var t: TTextRec; cnt: Longint): Pointer;
{$IFDEF PUREPASCAL}
const
  s64Spaces = '                                                                ';
begin
  Result := @t;
  while cnt > 64 do
  begin
    _WriteBytes(t, s64Spaces, 64);
    if InOutRes <> 0 then Exit;
    Dec(cnt, 64);
  end;
  if cnt > 0 then
    _WriteBytes(t, s64Spaces, cnt);
end;
{$ELSE}
const
  spCnt = 64;
asm
// -> EAX Pointer to text record
//  EDX Number of spaces (<= 0: None)

        MOV     ECX,EDX
@@loop:
{$IFDEF PIC}
        LEA     EDX, [EBX] + offset @@spBuf
{$ELSE}
        MOV     EDX,offset @@spBuf
{$ENDIF}

        CMP     ECX,spCnt
        JLE     @@1

        SUB     ECX,spCnt
        PUSH    EAX
        PUSH    ECX
        MOV     ECX,spCnt
        CALL    _WriteBytes
        CALL    SysInit.@GetTLS
        CMP     [EAX].InOutRes,0
        JNE     @@error
        POP     ECX
        POP     EAX
        JMP     @@loop

@@error:
        POP ECX
        POP EAX
        JMP     @@exit

@@spBuf:  // 64 spaces
        DB '                                                                ';
@@1:
        TEST  ECX,ECX
        JG  _WriteBytes
@@exit:
end;
{$ENDIF}

function _Write0Char(var t: TTextRec; c: Char): Pointer;
{$IFDEF PUREPASCAL}
var
  Temp: Integer;
begin
  Result := @t;
  if not TryOpenForOutput(t) then Exit;

  if t.BufPos >= t.BufSize then
  begin
    Temp := TTextIOFunc(t.InOutFunc)(t);
    if Temp <> 0 then
    begin
      SetInOutRes(Temp);
      Exit;
    end;
  end;

  t.BufPtr[t.BufPos] := c;
  Inc(t.BufPos);
end;
{$ELSE}
asm
// -> EAX Pointer to text record
//  DL  Character

        CMP     [EAX].TTextRec.Mode,fmOutput
        JE      @@loop
        PUSH    EAX
        PUSH    EDX
        CALL    TryOpenForOutput
        TEST    AL,AL
        POP     EDX
        POP     EAX
        JNE     @@loop
        JMP     @@exit

@@flush:
        PUSH    EAX
        PUSH    EDX
        CALL    [EAX].TTextRec.InOutFunc
        TEST    EAX,EAX
        JNZ     @@error
        POP     EDX
        POP     EAX
        JMP     @@loop

@@error:
        CALL    SetInOutRes
        POP     EDX
        POP     EAX
        JMP     @@exit

@@loop:
        MOV     ECX,[EAX].TTextRec.BufPos
        CMP     ECX,[EAX].TTextRec.BufSize
        JGE     @@flush

        ADD     ECX,[EAX].TTextRec.BufPtr
        MOV     [ECX],DL

        INC     [EAX].TTextRec.BufPos
@@exit:
end;
{$ENDIF}

function _WriteChar(var t: TTextRec; c: Char; width: Integer): Pointer;
begin
  _WriteSpaces(t, width-1);
  Result := _WriteBytes(t, c, 1);
end;

function _WriteBool(var t: TTextRec; val: Boolean; width: Longint): Pointer;
const
  BoolStrs: array [Boolean] of ShortString = ('FALSE', 'TRUE');
begin
  Result := _WriteString(t, BoolStrs[val], width);
end;

function _Write0Bool(var t: TTextRec; val: Boolean): Pointer;
begin
  Result := _WriteBool(t, val, 0);
end;

function _WriteLong(var t: TTextRec; val, width: Longint): Pointer;
var
  S: string[31];
begin
  Str(val:0, S);
  Result := _WriteString(t, S, width);
end;

function _Write0Long(var t: TTextRec; val: Longint): Pointer;
begin
  Result := _WriteLong(t, val, 0);
end;

function _Write0String(var t: TTextRec; const s: ShortString): Pointer;
begin
  Result := _WriteBytes(t, S[1], Byte(S[0]));
end;

function _WriteString(var t: TTextRec; const s: ShortString; width: Longint): Pointer;
begin
  _WriteSpaces(t, Width - Byte(S[0]));
  Result := _WriteBytes(t, S[1], Byte(S[0]));
end;

function _Write0CString(var t: TTextRec; s: PChar): Pointer;
begin
  Result := _WriteCString(t, s, 0);
end;

function _WriteCString(var t: TTextRec; s: PChar; width: Longint): Pointer;
var
  len: Longint;
begin
  len := _strlen(s);
  _WriteSpaces(t, width - len);
  Result := _WriteBytes(t, s^, len);
end;

procedure       _Write2Ext;
asm
{       PROCEDURE _Write2Ext( VAR t: Text; val: Extended; width, prec: Longint);
      ->EAX     Pointer to file record
        [ESP+4] Extended value
        EDX     Field width
        ECX     precision (<0: scientific, >= 0: fixed point)   }

        FLD     tbyte ptr [ESP+4]       { load value    }
        SUB     ESP,256         { VAR s: String;        }

        PUSH    EAX
        PUSH    EDX

{       Str( val, width, prec, s );     }

        SUB     ESP,12
        FSTP    tbyte ptr [ESP] { pass value            }
        MOV     EAX,EDX         { pass field width              }
        MOV     EDX,ECX         { pass precision                }
        LEA     ECX,[ESP+8+12]  { pass destination string       }
        CALL    _Str2Ext

{       Write( t, s, width );   }

        POP     ECX                     { pass width    }
        POP     EAX                     { pass text     }
        MOV     EDX,ESP         { pass string   }
        CALL    _WriteString

        ADD     ESP,256
        RET     12
end;

procedure       _Write1Ext;
asm
{       PROCEDURE _Write1Ext( VAR t: Text; val: Extended; width: Longint);
  ->    EAX     Pointer to file record
        [ESP+4] Extended value
        EDX     Field width             }

        OR      ECX,-1
        JMP     _Write2Ext
end;

procedure       _Write0Ext;
asm
{       PROCEDURE _Write0Ext( VAR t: Text; val: Extended);
      ->EAX     Pointer to file record
        [ESP+4] Extended value  }

        MOV     EDX,23  { field width   }
        OR      ECX,-1
        JMP     _Write2Ext
end;

function _WriteLn(var t: TTextRec): Pointer;
var
  Buf: array [0..1] of Char;
begin
  if (t.flags and tfCRLF) <> 0 then
  begin
    Buf[0] := #13;
    Buf[1] := #10;
    Result := _WriteBytes(t, Buf, 2);
  end
  else
  begin
    Buf[0] := #10;
    Result := _WriteBytes(t, Buf, 1);
  end;
  _Flush(t);
end;

procedure       __CToPasStr(Dest: PShortString; const Source: PChar);
begin
  __CLenToPasStr(Dest, Source, 255);
end;

procedure       __CLenToPasStr(Dest: PShortString; const Source: PChar; MaxLen: Integer);
{$IFDEF PUREPASCAL}
var
  I: Integer;
begin
  I := 0;
  if MaxLen > 255 then MaxLen := 255;
  while (Source[I] <> #0) and (I <= MaxLen) do
  begin
    Dest^[I+1] := Source[I];
    Inc(I);
  end;
  if I > 0 then Dec(I);
  Byte(Dest^[0]) := I;
end;
{$ELSE}
asm
{     ->EAX     Pointer to destination  }
{       EDX     Pointer to source       }
{       ECX     cnt                     }

        PUSH    EBX
        PUSH    EAX             { save destination      }

        CMP     ECX,255
        JBE     @@loop
        MOV     ECX,255
@@loop:
        MOV     BL,[EDX]        { ch = *src++;          }
        INC     EDX
        TEST    BL,BL   { if (ch == 0) break    }
        JE      @@endLoop
        INC     EAX             { *++dest = ch;         }
        MOV     [EAX],BL
        DEC     ECX             { while (--cnt != 0)    }
        JNZ     @@loop

@@endLoop:
        POP     EDX
        SUB     EAX,EDX
        MOV     [EDX],AL
        POP     EBX
end;
{$ENDIF}

procedure       __ArrayToPasStr(Dest: PShortString; const Source: PChar; Len: Integer);
begin
  if Len > 255 then Len := 255;
  Byte(Dest^[0]) := Len;
  Move(Source^, Dest^[1], Len);
end;

procedure       __PasToCStr(const Source: PShortString; const Dest: PChar);
begin
  Move(Source^[1], Dest^, Byte(Source^[0]));
  Dest[Byte(Source^[0])] := #0;
end;

procedure       _SetElem;
asm
        {       PROCEDURE _SetElem( VAR d: SET; elem, size: Byte);      }
        {       EAX     =       dest address                            }
        {       DL      =       element number                          }
        {       CL      =       size of set                                     }

        PUSH    EBX
        PUSH    EDI

        MOV     EDI,EAX

        XOR     EBX,EBX { zero extend set size into ebx }
        MOV     BL,CL
        MOV     ECX,EBX { and use it for the fill       }

        XOR     EAX,EAX { for zero fill                 }
        REP     STOSB

        SUB     EDI,EBX { point edi at beginning of set again   }

        INC     EAX             { eax is still zero - make it 1 }
        MOV     CL,DL
        ROL     AL,CL   { generate a mask               }
        SHR     ECX,3   { generate the index            }
        CMP     ECX,EBX { if index >= siz then exit     }
        JAE     @@exit
        OR      [EDI+ECX],AL{ set bit                   }

@@exit:
        POP     EDI
        POP     EBX
end;

procedure       _SetRange;
asm
{       PROCEDURE _SetRange( lo, hi, size: Byte; VAR d: SET );  }
{ ->AL  low limit of range      }
{       DL      high limit of range     }
{       ECX     Pointer to set          }
{       AH      size of set             }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        XOR     EBX,EBX { EBX = set size                }
        MOV     BL,AH
        MOVZX   ESI,AL  { ESI = low zero extended       }
        MOVZX   EDX,DL  { EDX = high zero extended      }
        MOV     EDI,ECX

{       clear the set                                   }

        MOV     ECX,EBX
        XOR     EAX,EAX
        REP     STOSB

{       prepare for setting the bits                    }

        SUB     EDI,EBX { point EDI at start of set     }
        SHL     EBX,3   { EBX = highest bit in set + 1  }
        CMP     EDX,EBX
        JB      @@inrange
        LEA     EDX,[EBX-1]     { ECX = highest bit in set      }

@@inrange:
        CMP     ESI,EDX { if lo > hi then exit;         }
        JA      @@exit

        DEC     EAX     { loMask = 0xff << (lo & 7)             }
        MOV     ECX,ESI
        AND     CL,07H
        SHL     AL,CL

        SHR     ESI,3   { loIndex = lo >> 3;            }

        MOV     CL,DL   { hiMask = 0xff >> (7 - (hi & 7));      }
        NOT     CL
        AND     CL,07
        SHR     AH,CL

        SHR     EDX,3   { hiIndex = hi >> 3;            }

        ADD     EDI,ESI { point EDI to set[loIndex]     }
        MOV     ECX,EDX
        SUB     ECX,ESI { if ((inxDiff = (hiIndex - loIndex)) == 0)     }
        JNE     @@else

        AND     AL,AH   { set[loIndex] = hiMask & loMask;       }
        MOV     [EDI],AL
        JMP     @@exit

@@else:
        STOSB           { set[loIndex++] = loMask;      }
        DEC     ECX
        MOV     AL,0FFH { while (loIndex < hiIndex)     }
        REP     STOSB   {   set[loIndex++] = 0xff;      }
        MOV     [EDI],AH        { set[hiIndex] = hiMask;        }

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure       _SetEq;
asm
{       FUNCTION _SetEq( CONST l, r: Set; size: Byte): ConditionCode;   }
{       EAX     =       left operand    }
{       EDX     =       right operand   }
{       CL      =       size of set     }

        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        AND     ECX,0FFH
        REP     CMPSB

        POP     EDI
        POP     ESI
end;

procedure       _SetLe;
asm
{       FUNCTION _SetLe( CONST l, r: Set; size: Byte): ConditionCode;   }
{       EAX     =       left operand            }
{       EDX     =       right operand           }
{       CL      =       size of set (>0 && <= 32)       }

@@loop:
        MOV     CH,[EDX]
        NOT     CH
        AND     CH,[EAX]
        JNE     @@exit
        INC     EDX
        INC     EAX
        DEC     CL
        JNZ     @@loop
@@exit:
end;

procedure       _SetIntersect;
asm
{       PROCEDURE _SetIntersect( VAR dest: Set; CONST src: Set; size: Byte);}
{       EAX     =       destination operand             }
{       EDX     =       source operand                  }
{       CL      =       size of set (0 < size <= 32)    }

@@loop:
        MOV     CH,[EDX]
        INC     EDX
        AND     [EAX],CH
        INC     EAX
        DEC     CL
        JNZ     @@loop
end;

procedure       _SetIntersect3;
asm
{       PROCEDURE _SetIntersect3( VAR dest: Set; CONST src: Set; size: Longint; src2: Set);}
{       EAX     =       destination operand             }
{       EDX     =       source operand                  }
{       ECX     =       size of set (0 < size <= 32)    }
{ [ESP+4] = 2nd source operand    }

        PUSH    EBX
        PUSH    ESI
        MOV     ESI,[ESP+8+4]
@@loop:
        MOV     BL,[EDX+ECX-1]
        AND     BL,[ESI+ECX-1]
        MOV     [EAX+ECX-1],BL
        DEC     ECX
        JNZ     @@loop

        POP     ESI
        POP     EBX
end;

procedure       _SetUnion;
asm
{       PROCEDURE _SetUnion( VAR dest: Set; CONST src: Set; size: Byte);        }
{       EAX     =       destination operand             }
{       EDX     =       source operand                  }
{       CL      =       size of set (0 < size <= 32)    }

@@loop:
        MOV     CH,[EDX]
        INC     EDX
        OR      [EAX],CH
        INC     EAX
        DEC     CL
        JNZ     @@loop
end;

procedure       _SetUnion3;
asm
{       PROCEDURE _SetUnion3( VAR dest: Set; CONST src: Set; size: Longint; src2: Set);}
{       EAX     =       destination operand             }
{       EDX     =       source operand                  }
{       ECX     =       size of set (0 < size <= 32)    }
{ [ESP+4] = 2nd source operand    }

      PUSH  EBX
      PUSH  ESI
      MOV   ESI,[ESP+8+4]
@@loop:
      MOV   BL,[EDX+ECX-1]
      OR    BL,[ESI+ECX-1]
      MOV   [EAX+ECX-1],BL
      DEC   ECX
      JNZ   @@loop

      POP   ESI
      POP   EBX
end;

procedure       _SetSub;
asm
{       PROCEDURE _SetSub( VAR dest: Set; CONST src: Set; size: Byte);  }
{       EAX     =       destination operand             }
{       EDX     =       source operand                  }
{       CL      =       size of set (0 < size <= 32)    }

@@loop:
        MOV     CH,[EDX]
        NOT     CH
        INC     EDX
        AND     [EAX],CH
        INC     EAX
        DEC     CL
        JNZ     @@loop
end;

procedure       _SetSub3;
asm
{       PROCEDURE _SetSub3( VAR dest: Set; CONST src: Set; size: Longint; src2: Set);}
{       EAX     =       destination operand             }
{       EDX     =       source operand                  }
{       ECX     =       size of set (0 < size <= 32)    }
{ [ESP+4] = 2nd source operand    }

        PUSH    EBX
        PUSH    ESI
        MOV     ESI,[ESP+8+4]
@@loop:
        MOV     BL,[ESI+ECX-1]
        NOT     BL
        AND     BL,[EDX+ECX-1]
        MOV     [EAX+ECX-1],BL
        DEC     ECX
        JNZ     @@loop

        POP     ESI
        POP     EBX
end;

procedure       _SetExpand;
asm
{       PROCEDURE _SetExpand( CONST src: Set; VAR dest: Set; lo, hi: Byte);     }
{     ->EAX     Pointer to source (packed set)          }
{       EDX     Pointer to destination (expanded set)   }
{       CH      high byte of source                     }
{       CL      low byte of source                      }

{       algorithm:              }
{       clear low bytes         }
{       copy high-low+1 bytes   }
{       clear 31-high bytes     }

        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        MOV     EDX,ECX { save low, high in dl, dh      }
        XOR     ECX,ECX
        XOR     EAX,EAX

        MOV     CL,DL   { clear low bytes               }
        REP     STOSB

        MOV     CL,DH   { copy high - low bytes }
        SUB     CL,DL
        REP     MOVSB

        MOV     CL,32   { copy 32 - high bytes  }
        SUB     CL,DH
        REP     STOSB

        POP     EDI
        POP     ESI
end;

procedure _EmitDigits;
const
  tenE17: Double = 1e17;
  tenE18: Double = 1e18;
asm
// -> FST(0)  Value, 0 <= value < 10.0
//  EAX Count of digits to generate
//  EDX Pointer to digit buffer

        PUSH    EBX
{$IFDEF PIC}
        PUSH    EAX
        CALL    GetGOT
        MOV     EBX,EAX
        POP     EAX
{$ELSE}
        XOR     EBX,EBX
{$ENDIF}
        PUSH    EDI
        MOV     EDI,EDX
        MOV     ECX,EAX

        SUB     ESP,10      // VAR bcdBuf: array [0..9] of Byte
        MOV     byte ptr [EDI],'0'  // digBuf[0] := '0'//
        FMUL    qword ptr [EBX] + offset tenE17        // val := Round(val*1e17);
        FRNDINT

        FCOM    qword ptr [EBX] + offset tenE18        // if val >= 1e18 then
        FSTSW   AX
        SAHF
        JB      @@1

        FSUB    qword ptr [EBX] + offset tenE18  //   val := val - 1e18;
        MOV     byte ptr [EDI],'1'  //   digBuf[0] := '1';
@@1:
        FBSTP   tbyte ptr [ESP]   // store packed bcd digits in bcdBuf

        MOV     EDX,8
        INC     EDI

@@2:
        WAIT
        MOV     AL,[ESP+EDX]    // unpack 18 bcd digits in 9 bytes
        MOV     AH,AL     // into 9 words = 18 bytes
        SHR     AL,4
        AND     AH,0FH
        ADD     AX,'00'
        STOSW
        DEC     EDX
        JNS     @@2

        SUB     ECX,18      // we need at least digCnt digits
        JL      @@3     // we have generated 18

        MOV     AL,'0'      // if this is not enough, append zeroes
        REP     STOSB
        JMP     @@4     // in this case, we don't need to round

@@3:
        ADD     EDI,ECX     // point EDI to the round digit
        CMP     byte ptr [EDI],'5'
        JL      @@4
@@5:
        DEC     EDI
        INC     byte ptr [EDI]
        CMP     byte ptr [EDI],'9'
        JLE     @@4
        MOV     byte ptr [EDI],'0'
        JMP     @@5

@@4:
        ADD     ESP,10
        POP     EDI
        POP     EBX
end;

procedure _ScaleExt;
asm
// -> FST(0)  Value
// <- EAX exponent (base 10)
//  FST(0)  Value / 10**eax
// PIC safe - uses EBX, but only call is to _POW10, which fixes up EBX itself

        PUSH    EBX
        SUB     ESP,12

        XOR     EBX,EBX

@@normLoop:       // loop necessary for denormals

        FLD     ST(0)
        FSTP    tbyte ptr [ESP]
        MOV     AX,[ESP+8]
        TEST    AX,AX
        JE      @@testZero
@@cont:
        SUB     AX,3FFFH
        MOV     DX,4D10H  // log10(2) * 2**16
        IMUL    DX
        MOVSX   EAX,DX    // exp10 = exp2 * log10(2)
        NEG     EAX
        JE      @@exit
        SUB     EBX,EAX
        CALL    _Pow10
        JMP     @@normLoop

@@testZero:
        CMP     dword ptr [ESP+4],0
        JNE     @@cont
        CMP     dword ptr [ESP+0],0
        JNE     @@cont

@@exit:
        ADD     ESP,12
        MOV     EAX,EBX
        POP     EBX
end;

const
  Ten: Double = 10.0;
  NanStr: String[3] = 'Nan';
  PlusInfStr: String[4] = '+Inf';
  MinInfStr: String[4] = '-Inf';

procedure _Str2Ext;//( val: Extended; width, precision: Longint; var s: String );
const
  MAXDIGS = 256;
asm
// -> [ESP+4] Extended value
//  EAX Width
//  EDX Precision
//  ECX Pointer to string

      FLD     tbyte ptr [ESP+4]

      PUSH    EBX
      PUSH    ESI
      PUSH    EDI
      MOV     EBX,EAX
      MOV     ESI,EDX
      PUSH    ECX     // save string pointer
      SUB     ESP,MAXDIGS             // VAR digBuf: array [0..MAXDIGS-1] of Char

//  limit width to 255

      CMP     EBX,255     // if width > 255 then width := 255;
      JLE     @@1
      MOV     EBX,255
@@1:

//  save sign bit in bit 0 of EDI, take absolute value of val, check for
//  Nan and infinity.

      FLD     ST(0)
      FSTP    tbyte ptr [ESP]
      XOR     EAX,EAX
      MOV     AX,word ptr [ESP+8]
      MOV     EDI,EAX
      SHR     EDI,15
      AND     AX,7FFFH
      CMP     AX,7FFFH
      JE      @@nanInf
      FABS

//  if precision < 0 then do scientific else do fixed;

      TEST    ESI,ESI
      JGE     @@fixed

//  the following call finds a decimal exponent and a reduced
//  mantissa such that val = mant * 10**exp

      CALL    _ScaleExt   // val is FST(0), exp is EAX

//  for scientific notation, we have width - 8 significant digits
//  however, we can not have less than 2 or more than 18 digits.

@@scientific:

      MOV     ESI,EBX     // digCnt := width - 8;
      SUB     ESI,8
      CMP     ESI,2     // if digCnt < 2 then digCnt := 2
      JGE     @@2
      MOV     ESI,2
      JMP     @@3
@@2:
      CMP     ESI,18      // else if digCnt > 18 then digCnt := 18;
      JLE     @@3
      MOV     ESI,18
@@3:

//  _EmitDigits( val, digCnt, digBuf )

      MOV     EDX,ESP     // pass digBuf
      PUSH    EAX     // save exponent
      MOV     EAX,ESI     // pass digCnt
      CALL    _EmitDigits   // convert val to ASCII

      MOV     EDX,EDI     // save sign in EDX
      MOV     EDI,[ESP+MAXDIGS+4] // load result string pointer

      MOV     [EDI],BL    // length of result string := width
      INC     EDI

      MOV     AL,' '      // prepare for leading blanks and sign

      MOV     ECX,EBX     // blankCnt := width - digCnt - 8
      SUB     ECX,ESI
      SUB     ECX,8
      JLE     @@4

      REP     STOSB     // emit blankCnt blanks
@@4:
      SUB     [EDI-1],CL    // if blankCnt < 0, adjust length

      TEST    DL,DL     // emit the sign (' ' or '-')
      JE      @@5
      MOV     AL,'-'
@@5:
      STOSB

      POP     EAX
      MOV     ECX,ESI     // emit digCnt digits
      MOV     ESI,ESP     // point ESI to digBuf

      CMP     byte ptr [ESI],'0'
      JE      @@5a      // if rounding overflowed, adjust exponent and ESI
      INC     EAX
      DEC     ESI
@@5a:
      INC     ESI

      MOVSB   // emit one digit
      MOV     byte ptr [EDI],'.'  // emit dot
      INC     EDI     // adjust dest pointer
      DEC     ECX     // adjust count

      REP     MOVSB

      MOV     byte ptr [EDI],'E'

      MOV     CL,'+'      // emit sign of exponent ('+' or '-')
      TEST    EAX,EAX
      JGE     @@6
      MOV     CL,'-'
      NEG     EAX
@@6:
      MOV     [EDI+1],CL

      XOR     EDX,EDX     // emit exponent
      MOV     CX,10
      DIV     CX
      ADD     DL,'0'
      MOV     [EDI+5],DL

      XOR     EDX,EDX
      DIV     CX
      ADD     DL,'0'
      MOV     [EDI+4],DL

      XOR     EDX,EDX
      DIV     CX
      ADD     DL,'0'
      MOV     [EDI+3],DL

      ADD     AL,'0'
      MOV     [EDI+2],AL

      JMP     @@exit

@@fixed:

//  FST(0)  = value >= 0.0
//  EBX = width
//  ESI = precision
//  EDI = sign

      CMP     ESI,MAXDIGS-40    // else if precision > MAXDIGS-40 then precision := MAXDIGS-40;
      JLE     @@6a
      MOV     ESI,MAXDIGS-40
@@6a:
{$IFDEF PIC}
      PUSH    EAX
      CALL    GetGOT
      FCOM    qword ptr [EAX] + offset Ten
      POP     EAX
{$ELSE}
      FCOM    qword ptr ten
{$ENDIF}
      FSTSW   AX
      SAHF
      MOV     EAX,0
      JB      @@7

      CALL    _ScaleExt   // val is FST(0), exp is EAX

      CMP     EAX,35      // if val is too large, use scientific
      JG      @@scientific

@@7:
//  FST(0)  = scaled value, 0.0 <= value < 10.0
//  EAX = exponent, 0 <= exponent

//  intDigCnt := exponent + 1;

      INC     EAX

//  _EmitDigits( value, intDigCnt + precision, digBuf );

      MOV     EDX,ESP
      PUSH    EAX
      ADD     EAX,ESI
      CALL    _EmitDigits
      POP     EAX

//  Now we need to check whether rounding to the right number of
//  digits overflowed, and if so, adjust things accordingly

      MOV     EDX,ESI     // put precision in EDX
      MOV     ESI,ESP     // point EDI to digBuf
      CMP     byte ptr [ESI],'0'
      JE      @@8
      INC     EAX
      DEC     ESI
@@8:
      INC     ESI

      MOV     ECX,EAX     // numWidth := sign + intDigCnt;
      ADD     ECX,EDI

      TEST    EDX,EDX     // if precision > 0 then
      JE      @@9
      INC     ECX     //   numWidth := numWidth + 1 + precision
      ADD     ECX,EDX

      CMP     EBX,ECX     // if width <= numWidth
      JG      @@9
      MOV     EBX,ECX     //   width := numWidth
@@9:
      PUSH    EAX
      PUSH    EDI

      MOV     EDI,[ESP+MAXDIGS+2*4] // point EDI to dest string

      MOV     [EDI],BL    // store final length in dest string
      INC     EDI

      SUB     EBX,ECX     // width := width - numWidth
      MOV     ECX,EBX
      JLE     @@10

      MOV     AL,' '      // emit width blanks
      REP     STOSB
@@10:
      SUB     [EDI-1],CL    // if blankCnt < 0, adjust length
      POP     EAX
      POP     ECX

      TEST    EAX,EAX
      JE      @@11

      MOV     byte ptr [EDI],'-'
      INC     EDI

@@11:
      REP     MOVSB     // copy intDigCnt digits

      TEST    EDX,EDX     // if precision > 0 then
      JE      @@12

      MOV     byte ptr [EDI],'.'  //   emit '.'
      INC     EDI
      MOV     ECX,EDX     //   emit precision digits
      REP     MOVSB

@@12:

@@exit:
      ADD     ESP,MAXDIGS
      POP     ECX
      POP     EDI
      POP     ESI
      POP     EBX
      RET     12

@@nanInf:
//  here: EBX = width, ECX = string pointer, EDI = sign, [ESP] = value

{$IFDEF PIC}
      CALL    GetGOT
{$ELSE}
      XOR     EAX,EAX
{$ENDIF}
      FSTP    ST(0)
      CMP     dword ptr [ESP+4],80000000H
      LEA     ESI,[EAX] + offset nanStr
      JNE     @@13
      DEC     EDI
      LEA     ESI,[EAX] + offset plusInfStr
      JNZ     @@13
      LEA     ESI,[EAX] + offset minInfStr
@@13:
      MOV     EDI,ECX
      MOV     ECX,EBX
      MOV     [EDI],CL
      INC     EDI
      SUB     CL,[ESI]
      JBE     @@14
      MOV     AL,' '
      REP     STOSB
@@14:
      SUB     [EDI-1],CL
      MOV     CL,[ESI]
      INC     ESI
      REP     MOVSB

      JMP     @@exit
end;

procedure _Str0Ext;
asm
// -> [ESP+4] Extended value
//  EAX Pointer to string

      MOV     ECX,EAX     // pass string
      MOV     EAX,23      // pass default field width
      OR      EDX,-1      // pass precision -1
      JMP     _Str2Ext
end;

procedure _Str1Ext;//( val: Extended; width: Longint; var s: String );
asm
// -> [ESP+4] Extended value
//  EAX Field width
//  EDX Pointer to string

      MOV     ECX,EDX
      OR      EDX,-1      // pass precision -1
      JMP     _Str2Ext
end;

//function _ValExt( s: AnsiString; VAR code: Integer ) : Extended;
procedure _ValExt;
asm
// -> EAX Pointer to string
//  EDX Pointer to code result
// <- FST(0)  Result

      PUSH    EBX
{$IFDEF PIC}
      PUSH    EAX
      CALL    GetGOT
      MOV     EBX,EAX
      POP     EAX
{$ELSE}
      XOR     EBX,EBX
{$ENDIF}
      PUSH    ESI
      PUSH    EDI

      PUSH    EBX     // SaveGOT = ESP+8
      MOV     ESI,EAX
      PUSH    EAX     // save for the error case

      FLDZ
      XOR     EAX,EAX
      XOR     EBX,EBX
      XOR     EDI,EDI

      PUSH    EBX     // temp to get digs to fpu

      TEST    ESI,ESI
      JE      @@empty

@@blankLoop:
      MOV     BL,[ESI]
      INC     ESI
      CMP     BL,' '
      JE      @@blankLoop

@@endBlanks:
      MOV     CH,0
      CMP     BL,'-'
      JE      @@minus
      CMP     BL,'+'
      JE      @@plus
      JMP     @@firstDigit

@@minus:
      INC     CH
@@plus:
      MOV     BL,[ESI]
      INC     ESI

@@firstDigit:
      TEST    BL,BL
      JE      @@error

      MOV     EDI,[ESP+8]     // SaveGOT

@@digLoop:
      SUB     BL,'0'
      CMP     BL,9
      JA      @@dotExp
      FMUL    qword ptr [EDI] + offset Ten
      MOV     dword ptr [ESP],EBX
      FIADD   dword ptr [ESP]

      MOV     BL,[ESI]
      INC     ESI

      TEST    BL,BL
      JNE     @@digLoop
      JMP     @@prefinish

@@dotExp:
      CMP     BL,'.' - '0'
      JNE     @@exp

      MOV     BL,[ESI]
      INC     ESI

      TEST    BL,BL
      JE      @@prefinish

//  EDI = SaveGot
@@fracDigLoop:
      SUB     BL,'0'
      CMP     BL,9
      JA      @@exp
      FMUL    qword ptr [EDI] + offset Ten
      MOV     dword ptr [ESP],EBX
      FIADD   dword ptr [ESP]
      DEC     EAX

      MOV     BL,[ESI]
      INC     ESI

      TEST    BL,BL
      JNE     @@fracDigLoop

@@prefinish:
      XOR     EDI,EDI
      JMP     @@finish

@@exp:
      CMP     BL,'E' - '0'
      JE      @@foundExp
      CMP     BL,'e' - '0'
      JNE     @@error
@@foundExp:
      MOV     BL,[ESI]
      INC     ESI
      MOV     AH,0
      CMP     BL,'-'
      JE      @@minusExp
      CMP     BL,'+'
      JE      @@plusExp
      JMP     @@firstExpDigit
@@minusExp:
      INC     AH
@@plusExp:
      MOV     BL,[ESI]
      INC     ESI
@@firstExpDigit:
      SUB     BL,'0'
      CMP     BL,9
      JA      @@error
      MOV     EDI,EBX
      MOV     BL,[ESI]
      INC     ESI
      TEST    BL,BL
      JZ      @@endExp
@@expDigLoop:
      SUB    BL,'0'
      CMP    BL,9
      JA     @@error
      LEA    EDI,[EDI+EDI*4]
      ADD    EDI,EDI
      ADD    EDI,EBX
      MOV    BL,[ESI]
      INC    ESI
      TEST   BL,BL
      JNZ    @@expDigLoop
@@endExp:
      DEC    AH
      JNZ    @@expPositive
      NEG    EDI
@@expPositive:
      MOVSX  EAX,AL

@@finish:
      ADD    EAX,EDI
      PUSH   EDX
      PUSH   ECX
      CALL   _Pow10
      POP    ECX
      POP    EDX

      DEC    CH
      JE     @@negate

@@successExit:

      ADD    ESP,12   // pop temp and saved copy of string pointer

      XOR    ESI,ESI   // signal no error to caller

@@exit:
      MOV    [EDX],ESI

      POP    EDI
      POP    ESI
      POP    EBX
      RET

@@negate:
      FCHS
      JMP    @@successExit

@@empty:
      INC    ESI

@@error:
      POP    EAX
      POP    EBX
      SUB    ESI,EBX
      ADD    ESP,4
      JMP    @@exit
end;

procedure FPower10;
asm
  JMP  _Pow10
end;

//function _Pow10(val: Extended; Power: Integer): Extended;
procedure _Pow10;
asm
// -> FST(0)  val
// -> EAX Power
// <- FST(0)  val * 10**Power

//  This routine generates 10**power with no more than two
//  floating point multiplications. Up to 10**31, no multiplications
//  are needed.

  PUSH  EBX
{$IFDEF PIC}
  PUSH  EAX
  CALL  GetGOT
  MOV   EBX,EAX
  POP   EAX
{$ELSE}
  XOR   EBX,EBX
{$ENDIF}
  TEST  EAX,EAX
  JL  @@neg
  JE  @@exit
  CMP EAX,5120
  JGE @@inf
  MOV EDX,EAX
  AND EDX,01FH
  LEA EDX,[EDX+EDX*4]
  FLD tbyte ptr @@tab0[EBX+EDX*2]

  FMULP

  SHR EAX,5
  JE  @@exit

  MOV EDX,EAX
  AND EDX,0FH
  JE  @@skip2ndMul
  LEA EDX,[EDX+EDX*4]
  FLD tbyte ptr @@tab1-10[EBX+EDX*2]
  FMULP

@@skip2ndMul:

  SHR EAX,4
  JE  @@exit
  LEA EAX,[EAX+EAX*4]
  FLD tbyte ptr @@tab2-10[EBX+EAX*2]
  FMULP
  JMP   @@exit

@@neg:
  NEG EAX
  CMP EAX,5120
  JGE @@zero
  MOV EDX,EAX
  AND EDX,01FH
  LEA EDX,[EDX+EDX*4]
  FLD tbyte ptr @@tab0[EBX+EDX*2]
  FDIVP

  SHR EAX,5
  JE  @@exit

  MOV EDX,EAX
  AND EDX,0FH
  JE  @@skip2ndDiv
  LEA EDX,[EDX+EDX*4]
  FLD tbyte ptr @@tab1-10[EBX+EDX*2]
  FDIVP

@@skip2ndDiv:

  SHR EAX,4
  JE  @@exit
  LEA EAX,[EAX+EAX*4]
  FLD tbyte ptr @@tab2-10[EBX+EAX*2]
  FDIVP

  JMP   @@exit

@@inf:
  FLD tbyte ptr @@infval[EBX]
  JMP   @@exit

@@zero:
  FLDZ

@@exit:
  POP EBX
  RET

@@infval:  DW  $0000,$0000,$0000,$8000,$7FFF
@@tab0:    DW  $0000,$0000,$0000,$8000,$3FFF  // 10**0
           DW  $0000,$0000,$0000,$A000,$4002    // 10**1
           DW  $0000,$0000,$0000,$C800,$4005    // 10**2
           DW  $0000,$0000,$0000,$FA00,$4008        // 10**3
           DW  $0000,$0000,$0000,$9C40,$400C        // 10**4
           DW  $0000,$0000,$0000,$C350,$400F        // 10**5
           DW  $0000,$0000,$0000,$F424,$4012        // 10**6
           DW  $0000,$0000,$8000,$9896,$4016        // 10**7
           DW  $0000,$0000,$2000,$BEBC,$4019        // 10**8
           DW  $0000,$0000,$2800,$EE6B,$401C        // 10**9
           DW  $0000,$0000,$F900,$9502,$4020        // 10**10
           DW  $0000,$0000,$B740,$BA43,$4023        // 10**11
           DW  $0000,$0000,$A510,$E8D4,$4026        // 10**12
           DW  $0000,$0000,$E72A,$9184,$402A        // 10**13
           DW  $0000,$8000,$20F4,$B5E6,$402D        // 10**14
           DW  $0000,$A000,$A931,$E35F,$4030        // 10**15
           DW  $0000,$0400,$C9BF,$8E1B,$4034        // 10**16
           DW  $0000,$C500,$BC2E,$B1A2,$4037        // 10**17
           DW  $0000,$7640,$6B3A,$DE0B,$403A        // 10**18
           DW  $0000,$89E8,$2304,$8AC7,$403E        // 10**19
           DW  $0000,$AC62,$EBC5,$AD78,$4041        // 10**20
           DW  $8000,$177A,$26B7,$D8D7,$4044        // 10**21
           DW  $9000,$6EAC,$7832,$8786,$4048        // 10**22
           DW  $B400,$0A57,$163F,$A968,$404B        // 10**23
           DW  $A100,$CCED,$1BCE,$D3C2,$404E        // 10**24
           DW  $84A0,$4014,$5161,$8459,$4052        // 10**25
           DW  $A5C8,$9019,$A5B9,$A56F,$4055        // 10**26
           DW  $0F3A,$F420,$8F27,$CECB,$4058        // 10**27
           DW  $0984,$F894,$3978,$813F,$405C        // 10**28
           DW  $0BE5,$36B9,$07D7,$A18F,$405F        // 10**29
           DW  $4EDF,$0467,$C9CD,$C9F2,$4062        // 10**30
           DW  $2296,$4581,$7C40,$FC6F,$4065        // 10**31

@@tab1:    DW  $B59E,$2B70,$ADA8,$9DC5,$4069        // 10**32
           DW  $A6D5,$FFCF,$1F49,$C278,$40D3        // 10**64
           DW  $14A3,$C59B,$AB16,$EFB3,$413D        // 10**96
           DW  $8CE0,$80E9,$47C9,$93BA,$41A8        // 10**128
           DW  $17AA,$7FE6,$A12B,$B616,$4212        // 10**160
           DW  $556B,$3927,$F78D,$E070,$427C        // 10**192
           DW  $C930,$E33C,$96FF,$8A52,$42E7        // 10**224
           DW  $DE8E,$9DF9,$EBFB,$AA7E,$4351        // 10**256
           DW  $2F8C,$5C6A,$FC19,$D226,$43BB        // 10**288
           DW  $E376,$F2CC,$2F29,$8184,$4426        // 10**320
           DW  $0AD2,$DB90,$2700,$9FA4,$4490        // 10**352
           DW  $AA17,$AEF8,$E310,$C4C5,$44FA        // 10**384
           DW  $9C59,$E9B0,$9C07,$F28A,$4564        // 10**416
           DW  $F3D4,$EBF7,$4AE1,$957A,$45CF        // 10**448
           DW  $A262,$0795,$D8DC,$B83E,$4639        // 10**480

@@tab2:    DW  $91C7,$A60E,$A0AE,$E319,$46A3        // 10**512
           DW  $0C17,$8175,$7586,$C976,$4D48        // 10**1024
           DW  $A7E4,$3993,$353B,$B2B8,$53ED        // 10**1536
           DW  $5DE5,$C53D,$3B5D,$9E8B,$5A92        // 10**2048
           DW  $F0A6,$20A1,$54C0,$8CA5,$6137        // 10**2560
           DW  $5A8B,$D88B,$5D25,$F989,$67DB        // 10**3072
           DW  $F3F8,$BF27,$C8A2,$DD5D,$6E80        // 10**3584
           DW  $979B,$8A20,$5202,$C460,$7525        // 10**4096
           DW  $59F0,$6ED5,$1162,$AE35,$7BCA        // 10**4608
end;

const
  RealBias = 129;
  ExtBias  = $3FFF;

procedure _Real2Ext;//( val : Real ) : Extended;
asm
// -> EAX Pointer to value
// <- FST(0)  Result

//  the REAL data type has the following format:
//  8 bit exponent (bias 129), 39 bit fraction, 1 bit sign

  MOV DH,[EAX+5]  // isolate the sign bit
  AND DH,80H
  MOV DL,[EAX]  // fetch exponent
  TEST  DL,DL   // exponent zero means number is zero
  JE  @@zero

  ADD DX,ExtBias-RealBias // adjust exponent bias

  PUSH    EDX   // the exponent is at the highest address

  MOV EDX,[EAX+2] // load high fraction part, set hidden bit
  OR  EDX,80000000H
  PUSH  EDX   // push high fraction part

  MOV DL,[EAX+1]  // load remaining low byte of fraction
  SHL EDX,24    // clear low 24 bits
  PUSH  EDX

  FLD tbyte ptr [ESP] // pop result onto chip
  ADD ESP,12

  RET

@@zero:
  FLDZ
  RET
end;

procedure _Ext2Real;//( val : Extended ) : Real;
asm
// -> FST(0)  Value
//  EAX Pointer to result

  PUSH  EBX

  SUB ESP,12
  FSTP  tbyte ptr [ESP]

  POP EBX     // EBX is low half of fraction
  POP EDX     // EDX is high half of fraction
  POP ECX     // CX is exponent and sign

  SHR EBX,24      // set carry to last bit shifted out
  ADC BL,0      // if bit was 1, round up
  ADC EDX,0
  ADC CX,0
  JO  @@overflow

  ADD EDX,EDX     // shift fraction 1 bit left
  ADD CX,CX     // shift sign bit into carry
  RCR EDX,1     // attach sign bit to fraction
  SHR CX,1      // restore exponent, deleting sign

  SUB CX,ExtBias-RealBias // adjust exponent
  JLE @@underflow
  TEST  CH,CH     // CX must be in 1..255
  JG  @@overflow

  MOV [EAX],CL
  MOV [EAX+1],BL
  MOV [EAX+2],EDX

  POP EBX
  RET

@@underflow:
  XOR ECX,ECX
  MOV [EAX],ECX
  MOV [EAX+4],CX
  POP EBX
  RET

@@overflow:
  POP EBX
  MOV AL,8
  JMP Error
end;

const
    ovtInstanceSize = -8;   { Offset of instance size in OBJECTs    }
    ovtVmtPtrOffs   = -4;

procedure       _ObjSetup;
asm
{       FUNCTION _ObjSetup( self: ^OBJECT; vmt: ^VMT): ^OBJECT; }
{     ->EAX     Pointer to self (possibly nil)  }
{       EDX     Pointer to vmt  (possibly nil)  }
{     <-EAX     Pointer to self                 }
{       EDX     <> 0: an object was allocated   }
{       Z-Flag  Set: failure, Cleared: Success  }

        CMP     EDX,1   { is vmt = 0, indicating a call         }
        JAE     @@skip1 { from a constructor?                   }
        RET                     { return immediately with Z-flag cleared        }

@@skip1:
        PUSH    ECX
        TEST    EAX,EAX { is self already allocated?            }
        JNE     @@noAlloc
        MOV     EAX,[EDX].ovtInstanceSize
        TEST    EAX,EAX
        JE      @@zeroSize
        PUSH    EDX
        CALL    _GetMem
        POP     EDX
        TEST    EAX,EAX
        JZ      @@fail

        {       Zero fill the memory }
        PUSH    EDI
        MOV     ECX,[EDX].ovtInstanceSize
        MOV     EDI,EAX
        PUSH    EAX
        XOR     EAX,EAX
        SHR     ECX,2
        REP     STOSD
        MOV     ECX,[EDX].ovtInstanceSize
        AND     ECX,3
        REP     STOSB
        POP     EAX
        POP     EDI

        MOV     ECX,[EDX].ovtVmtPtrOffs
        TEST    ECX,ECX
        JL      @@skip
        MOV     [EAX+ECX],EDX   { store vmt in object at this offset    }
@@skip:
        TEST    EAX,EAX { clear zero flag                               }
        POP     ECX
        RET

@@fail:
        XOR     EDX,EDX
        POP     ECX
        RET

@@zeroSize:
        XOR     EDX,EDX
        CMP     EAX,1   { clear zero flag - we were successful (kind of) }
        POP     ECX
        RET

@@noAlloc:
        MOV     ECX,[EDX].ovtVmtPtrOffs
        TEST    ECX,ECX
        JL      @@exit
        MOV     [EAX+ECX],EDX   { store vmt in object at this offset    }
@@exit:
        XOR     EDX,EDX { clear allocated flag                  }
        TEST    EAX,EAX { clear zero flag                               }
        POP     ECX
end;

procedure       _ObjCopy;
asm
{       PROCEDURE _ObjCopy( dest, src: ^OBJECT; vmtPtrOff: Longint);    }
{     ->EAX     Pointer to destination          }
{       EDX     Pointer to source               }
{       ECX     Offset of vmt in those objects. }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EDX
        MOV     EDI,EAX

        LEA     EAX,[EDI+ECX]   { remember pointer to dest vmt pointer  }
        MOV     EDX,[EAX]       { fetch dest vmt pointer        }

        MOV     EBX,[EDX].ovtInstanceSize

        MOV     ECX,EBX { copy size DIV 4 dwords        }
        SHR     ECX,2
        REP     MOVSD

        MOV     ECX,EBX { copy size MOD 4 bytes }
        AND     ECX,3
        REP     MOVSB

        MOV     [EAX],EDX       { restore dest vmt              }

        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure       _Fail;
asm
{       FUNCTION _Fail( self: ^OBJECT; allocFlag:Longint): ^OBJECT;     }
{     ->EAX     Pointer to self (possibly nil)  }
{       EDX     <> 0: Object must be deallocated        }
{     <-EAX     Nil                                     }

        TEST    EDX,EDX
        JE      @@exit  { if no object was allocated, return    }
        CALL    _FreeMem
@@exit:
        XOR     EAX,EAX
end;

{$IFDEF MSWINDOWS}
function GetKeyboardType(nTypeFlag: Integer): Integer; stdcall;
  external user name 'GetKeyboardType';

function _isNECWindows: Boolean;
var
  KbSubType: Integer;
begin
  Result := False;
  if GetKeyboardType(0) = $7 then
  begin
    KbSubType := GetKeyboardType(1) and $FF00;
    if (KbSubType = $0D00) or (KbSubType = $0400) then
      Result := True;
  end;
end;

const
  HKEY_LOCAL_MACHINE = $80000002;

// workaround a Japanese Win95 bug
procedure _FpuMaskInit;
const
  KEY_QUERY_VALUE    = $00000001;
  REG_DWORD          = 4;
  FPUMASKKEY  = 'SOFTWARE\Borland\Delphi\RTL';
  FPUMASKNAME = 'FPUMaskValue';
var
  phkResult: LongWord;
  lpData, DataSize: Longint;
begin
  lpData := Default8087CW;

  if RegOpenKeyEx(HKEY_LOCAL_MACHINE, FPUMASKKEY, 0, KEY_QUERY_VALUE, phkResult) = 0 then
  try
    DataSize := Sizeof(lpData);
    RegQueryValueEx(phkResult, FPUMASKNAME, nil,  nil, @lpData, @DataSize);
  finally
    RegCloseKey(phkResult);
  end;
  Default8087CW := (Default8087CW and $ffc0) or (lpData and $3f);
end;
{$ENDIF}

procedure       _FpuInit;
asm
        FNINIT
        FWAIT
{$IFDEF PIC}
        CALL    GetGOT
        MOV     EAX,[EAX].OFFSET Default8087CW
        FLDCW   [EAX]
{$ELSE}
        FLDCW   Default8087CW
{$ENDIF}
end;

procedure       FpuInit;
//const cwDefault: Word = $1332 { $133F};
asm
        JMP     _FpuInit
end;

procedure FpuInitConsiderNECWindows;
begin
  if _isNECWindows then _FpuMaskInit;
  FpuInit();
end;

procedure       _BoundErr;
asm
        MOV     AL,reRangeError
        JMP     Error
end;

procedure       _IntOver;
asm
        MOV     AL,reIntOverflow
        JMP     Error
end;

function TObject.ClassType: TClass;
begin
  Pointer(Result) := PPointer(Self)^;
end;

class function TObject.ClassName: ShortString;
{$IFDEF PUREPASCAL}
begin
  Result := PShortString(PPointer(Integer(Self) + vmtClassName)^)^;
end;
{$ELSE}
asm
        { ->    EAX VMT                         }
        {       EDX Pointer to result string    }
        PUSH    ESI
        PUSH    EDI
        MOV     EDI,EDX
        MOV     ESI,[EAX].vmtClassName
        XOR     ECX,ECX
        MOV     CL,[ESI]
        INC     ECX
        REP     MOVSB
        POP     EDI
        POP     ESI
end;
{$ENDIF}

class function TObject.ClassNameIs(const Name: string): Boolean;
{$IFDEF PUREPASCAL}
var
  Temp: ShortString;
  I: Byte;
begin
  Result := False;
  Temp := ClassName;
  for I := 0 to Byte(Temp[0]) do
    if Temp[I] <> Name[I] then Exit;
  Result := True;
end;
{$ELSE}
asm
        PUSH    EBX
        XOR     EBX,EBX
        OR      EDX,EDX
        JE      @@exit
        MOV     EAX,[EAX].vmtClassName
        XOR     ECX,ECX
        MOV     CL,[EAX]
        CMP     ECX,[EDX-4]
        JNE     @@exit
        DEC     EDX
@@loop:
        MOV     BH,[EAX+ECX]
        XOR     BH,[EDX+ECX]
        AND     BH,0DFH
        JNE     @@exit
        DEC     ECX
        JNE     @@loop
        INC     EBX
@@exit:
        MOV     AL,BL
        POP     EBX
end;
{$ENDIF}

class function TObject.ClassParent: TClass;
{$IFDEF PUREPASCAL}
begin
  Pointer(Result) := PPointer(Integer(Self) + vmtParent)^;
  if Result <> nil then
    Pointer(Result) := PPointer(Result)^;
end;
{$ELSE}
asm
        MOV     EAX,[EAX].vmtParent
        TEST    EAX,EAX
        JE      @@exit
        MOV     EAX,[EAX]
@@exit:
end;
{$ENDIF}

class function TObject.NewInstance: TObject;
begin
  Result := InitInstance(_GetMem(InstanceSize));
end;

procedure TObject.FreeInstance;
begin
  CleanupInstance;
  _FreeMem(Self);
end;

class function TObject.InstanceSize: Longint;
begin
  Result := PInteger(Integer(Self) + vmtInstanceSize)^;
end;

constructor TObject.Create;
begin
end;

destructor TObject.Destroy;
begin
end;

procedure TObject.Free;
begin
  if Self <> nil then
    Destroy;
end;

class function TObject.InitInstance(Instance: Pointer): TObject;
{$IFDEF PUREPASCAL}
var
  IntfTable: PInterfaceTable;
  ClassPtr: TClass;
  I: Integer;
begin
  FillChar(Instance^, InstanceSize, 0);
  PInteger(Instance)^ := Integer(Self);
  ClassPtr := Self;
  while ClassPtr <> nil do
  begin
    IntfTable := ClassPtr.GetInterfaceTable;
    if IntfTable <> nil then
      for I := 0 to IntfTable.EntryCount-1 do
  with IntfTable.Entries[I] do
  begin
    if VTable <> nil then
      PInteger(@PChar(Instance)[IOffset])^ := Integer(VTable);
  end;
    ClassPtr := ClassPtr.ClassParent;
  end;
  Result := Instance;
end;
{$ELSE}
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     EDI,EDX
        STOSD
        MOV     ECX,[EBX].vmtInstanceSize
        XOR     EAX,EAX
        PUSH    ECX
        SHR     ECX,2
        DEC     ECX
        REP     STOSD
        POP     ECX
        AND     ECX,3
        REP     STOSB
        MOV     EAX,EDX
        MOV     EDX,ESP
@@0:    MOV     ECX,[EBX].vmtIntfTable
        TEST    ECX,ECX
        JE      @@1
        PUSH    ECX
@@1:    MOV     EBX,[EBX].vmtParent
        TEST    EBX,EBX
        JE      @@2
        MOV     EBX,[EBX]
        JMP     @@0
@@2:    CMP     ESP,EDX
        JE      @@5
@@3:    POP     EBX
        MOV     ECX,[EBX].TInterfaceTable.EntryCount
        ADD     EBX,4
@@4:    MOV     ESI,[EBX].TInterfaceEntry.VTable
        TEST    ESI,ESI
        JE      @@4a
        MOV     EDI,[EBX].TInterfaceEntry.IOffset
        MOV     [EAX+EDI],ESI
@@4a:   ADD     EBX,TYPE TInterfaceEntry
        DEC     ECX
        JNE     @@4
        CMP     ESP,EDX
        JNE     @@3
@@5:    POP     EDI
        POP     ESI
        POP     EBX
end;
{$ENDIF}

procedure TObject.CleanupInstance;
{$IFDEF PUREPASCAL}
var
  ClassPtr: TClass;
  InitTable: Pointer;
begin
  ClassPtr := ClassType;
  InitTable := PPointer(Integer(ClassPtr) + vmtInitTable)^;
  while (ClassPtr <> nil) and (InitTable <> nil) do
  begin
    _FinalizeRecord(Self, InitTable);
    ClassPtr := ClassPtr.ClassParent;
    if ClassPtr <> nil then
      InitTable := PPointer(Integer(ClassPtr) + vmtInitTable)^;
  end;
end;
{$ELSE}
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,EAX
        MOV     ESI,EAX
@@loop:
        MOV     ESI,[ESI]
        MOV     EDX,[ESI].vmtInitTable
        MOV     ESI,[ESI].vmtParent
        TEST    EDX,EDX
        JE      @@skip
        CALL    _FinalizeRecord
        MOV     EAX,EBX
@@skip:
        TEST    ESI,ESI
        JNE     @@loop

        POP     ESI
        POP     EBX
end;
{$ENDIF}

function InvokeImplGetter(Self: TObject; ImplGetter: Cardinal): IInterface;
{$IFDEF PUREPASCAL}
var
  M: function: IInterface of object;
begin
  TMethod(M).Data := Self;
  case ImplGetter of
    $FF000000..$FFFFFFFF:  // Field
        Result := IInterface(Pointer(Cardinal(Self) + (ImplGetter and $00FFFFFF)));
    $FE000000..$FEFFFFFF:  // virtual method
      begin
        // sign extend vmt slot offset = smallint cast
  TMethod(M).Code := PPointer(Integer(Self) + SmallInt(ImplGetter))^;
        Result := M;
      end;
  else // static method
    TMethod(M).Code := Pointer(ImplGetter);
    Result := M;
  end;
end;
{$ELSE}
asm
        XCHG    EDX,ECX
        CMP     ECX,$FF000000
        JAE     @@isField
        CMP     ECX,$FE000000
        JB      @@isStaticMethod

        {       the GetProc is a virtual method }
        MOVSX   ECX,CX                  { sign extend slot offs }
        ADD     ECX,[EAX]               { vmt   + slotoffs      }
        JMP     dword ptr [ECX]         { call vmt[slot]        }

@@isStaticMethod:
        JMP     ECX

@@isField:
        AND     ECX,$00FFFFFF
        ADD     ECX,EAX
        MOV     EAX,EDX
        MOV     EDX,[ECX]
        JMP     _IntfCopy
end;
{$ENDIF}

function TObject.GetInterface(const IID: TGUID; out Obj): Boolean;
var
  InterfaceEntry: PInterfaceEntry;
begin
  Pointer(Obj) := nil;
  InterfaceEntry := GetInterfaceEntry(IID);
  if InterfaceEntry <> nil then
  begin
    if InterfaceEntry^.IOffset <> 0 then
    begin
      Pointer(Obj) := Pointer(Integer(Self) + InterfaceEntry^.IOffset);
      if Pointer(Obj) <> nil then IInterface(Obj)._AddRef;
    end
    else
      IInterface(Obj) := InvokeImplGetter(Self, InterfaceEntry^.ImplGetter);
  end;
  Result := Pointer(Obj) <> nil;
end;

class function TObject.GetInterfaceEntry(const IID: TGUID): PInterfaceEntry;
{$IFDEF PUREPASCAL}
var
  ClassPtr: TClass;
  IntfTable: PInterfaceTable;
  I: Integer;
begin
  ClassPtr := Self;
  while ClassPtr <> nil do
  begin
    IntfTable := ClassPtr.GetInterfaceTable;
    if IntfTable <> nil then
      for I := 0 to IntfTable.EntryCount-1 do
      begin
        Result := @IntfTable.Entries[I];
//        if Result^.IID = IID then Exit;
        if (Int64(Result^.IID.D1) = Int64(IID.D1)) and
           (Int64(Result^.IID.D4) = Int64(IID.D4)) then Exit;
      end;
    ClassPtr := ClassPtr.ClassParent;
  end;
  Result := nil;
end;
{$ELSE}
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,EAX
@@1:    MOV     EAX,[EBX].vmtIntfTable
        TEST    EAX,EAX
        JE      @@4
        MOV     ECX,[EAX].TInterfaceTable.EntryCount
        ADD     EAX,4
@@2:    MOV     ESI,[EDX].Integer[0]
        CMP     ESI,[EAX].TInterfaceEntry.IID.Integer[0]
        JNE     @@3
        MOV     ESI,[EDX].Integer[4]
        CMP     ESI,[EAX].TInterfaceEntry.IID.Integer[4]
        JNE     @@3
        MOV     ESI,[EDX].Integer[8]
        CMP     ESI,[EAX].TInterfaceEntry.IID.Integer[8]
        JNE     @@3
        MOV     ESI,[EDX].Integer[12]
        CMP     ESI,[EAX].TInterfaceEntry.IID.Integer[12]
        JE      @@5
@@3:    ADD     EAX,type TInterfaceEntry
        DEC     ECX
        JNE     @@2
@@4:    MOV     EBX,[EBX].vmtParent
        TEST    EBX,EBX
        JE      @@4a
        MOV     EBX,[EBX]
        JMP     @@1
@@4a:   XOR     EAX,EAX
@@5:    POP     ESI
        POP     EBX
end;
{$ENDIF}

class function TObject.GetInterfaceTable: PInterfaceTable;
begin
  Result := PPointer(Integer(Self) + vmtIntfTable)^;
end;

function _IsClass(Child: TObject; Parent: TClass): Boolean;
begin
  Result := (Child <> nil) and Child.InheritsFrom(Parent);
end;

function _AsClass(Child: TObject; Parent: TClass): TObject;
{$IFDEF PUREPASCAL}
begin
  Result := Child;
  if not (Child is Parent) then
    Error(reInvalidCast);   // loses return address
end;
{$ELSE}
asm
        { ->    EAX     left operand (class)    }
        {       EDX VMT of right operand        }
        { <-    EAX      if left is derived from right, else runtime error      }
        TEST    EAX,EAX
        JE      @@exit
        MOV     ECX,EAX
@@loop:
        MOV     ECX,[ECX]
        CMP     ECX,EDX
        JE      @@exit
        MOV     ECX,[ECX].vmtParent
        TEST    ECX,ECX
        JNE     @@loop

        {       do runtime error        }
        MOV     AL,reInvalidCast
        JMP     Error

@@exit:
end;
{$ENDIF}


procedure       GetDynaMethod;
{       function        GetDynaMethod(vmt: TClass; selector: Smallint) : Pointer;       }
asm
        { ->    EAX     vmt of class            }
        {       SI      dynamic method index    }
        { <-    ESI pointer to routine  }
        {       ZF = 0 if found         }
        {       trashes: EAX, ECX               }

        PUSH    EDI
        XCHG    EAX,ESI
        JMP     @@haveVMT
@@outerLoop:
        MOV     ESI,[ESI]
@@haveVMT:
        MOV     EDI,[ESI].vmtDynamicTable
        TEST    EDI,EDI
        JE      @@parent
        MOVZX   ECX,word ptr [EDI]
        PUSH    ECX
        ADD     EDI,2
        REPNE   SCASW
        JE      @@found
        POP     ECX
@@parent:
        MOV     ESI,[ESI].vmtParent
        TEST    ESI,ESI
        JNE     @@outerLoop
        JMP     @@exit

@@found:
        POP     EAX
        ADD     EAX,EAX
        SUB     EAX,ECX         { this will always clear the Z-flag ! }
        MOV     ESI,[EDI+EAX*2-4]

@@exit:
        POP     EDI
end;

procedure       _CallDynaInst;
asm
        PUSH    EAX
        PUSH    ECX
        MOV     EAX,[EAX]
        CALL    GetDynaMethod
        POP     ECX
        POP     EAX
        JE      @@Abstract
        JMP     ESI
@@Abstract:
        POP     ECX
        JMP     _AbstractError
end;


procedure       _CallDynaClass;
asm
        PUSH    EAX
        PUSH    ECX
        CALL    GetDynaMethod
        POP     ECX
        POP     EAX
        JE      @@Abstract
        JMP     ESI
@@Abstract:
        POP     ECX
        JMP     _AbstractError
end;


procedure       _FindDynaInst;
asm
        PUSH    ESI
        MOV     ESI,EDX
        MOV     EAX,[EAX]
        CALL    GetDynaMethod
        MOV     EAX,ESI
        POP     ESI
        JNE     @@exit
        POP     ECX
        JMP     _AbstractError
@@exit:
end;


procedure       _FindDynaClass;
asm
        PUSH    ESI
        MOV     ESI,EDX
        CALL    GetDynaMethod
        MOV     EAX,ESI
        POP     ESI
        JNE     @@exit
        POP     ECX
        JMP     _AbstractError
@@exit:
end;

class function TObject.InheritsFrom(AClass: TClass): Boolean;
{$IFDEF PUREPASCAL}
var
  ClassPtr: TClass;
begin
  ClassPtr := Self;
  while (ClassPtr <> nil) and (ClassPtr <> AClass) do
    ClassPtr := PPointer(Integer(ClassPtr) + vmtParent)^;
  Result := ClassPtr = AClass;
end;
{$ELSE}
asm
        { ->    EAX     Pointer to our class    }
        {       EDX     Pointer to AClass               }
        { <-    AL      Boolean result          }
        JMP     @@haveVMT
@@loop:
        MOV     EAX,[EAX]
@@haveVMT:
        CMP     EAX,EDX
        JE      @@success
        MOV     EAX,[EAX].vmtParent
        TEST    EAX,EAX
        JNE     @@loop
        JMP     @@exit
@@success:
        MOV     AL,1
@@exit:
end;
{$ENDIF}


class function TObject.ClassInfo: Pointer;
begin
  Result := PPointer(Integer(Self) + vmtTypeInfo)^;
end;


function TObject.SafeCallException(ExceptObject: TObject;
  ExceptAddr: Pointer): HResult;
begin
  Result := HResult($8000FFFF); { E_UNEXPECTED }
end;


procedure TObject.DefaultHandler(var Message);
begin
end;


procedure TObject.AfterConstruction;
begin
end;

procedure TObject.BeforeDestruction;
begin
end;

procedure TObject.Dispatch(var Message);
asm
    PUSH    ESI
    MOV     SI,[EDX]
    OR      SI,SI
    JE      @@default
    CMP     SI,0C000H
    JAE     @@default
    PUSH    EAX
    MOV     EAX,[EAX]
    CALL    GetDynaMethod
    POP     EAX
    JE      @@default
    MOV     ECX,ESI
    POP     ESI
    JMP     ECX

@@default:
    POP     ESI
    MOV     ECX,[EAX]
    JMP     dword ptr [ECX].vmtDefaultHandler
end;


class function TObject.MethodAddress(const Name: ShortString): Pointer;
asm
        { ->    EAX     Pointer to class        }
        {       EDX     Pointer to name }
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        XOR     ECX,ECX
        XOR     EDI,EDI
        MOV     BL,[EDX]
        JMP     @@haveVMT
@@outer:                                { upper 16 bits of ECX are 0 !  }
        MOV     EAX,[EAX]
@@haveVMT:
        MOV     ESI,[EAX].vmtMethodTable
        TEST    ESI,ESI
        JE      @@parent
        MOV     DI,[ESI]                { EDI := method count           }
        ADD     ESI,2
@@inner:                                { upper 16 bits of ECX are 0 !  }
        MOV     CL,[ESI+6]              { compare length of strings     }
        CMP     CL,BL
        JE      @@cmpChar
@@cont:                                 { upper 16 bits of ECX are 0 !  }
        MOV     CX,[ESI]                { fetch length of method desc   }
        ADD     ESI,ECX                 { point ESI to next method      }
        DEC     EDI
        JNZ     @@inner
@@parent:
        MOV     EAX,[EAX].vmtParent     { fetch parent vmt              }
        TEST    EAX,EAX
        JNE     @@outer
        JMP     @@exit                  { return NIL                    }

@@notEqual:
        MOV     BL,[EDX]                { restore BL to length of name  }
        JMP     @@cont

@@cmpChar:                              { upper 16 bits of ECX are 0 !  }
        MOV     CH,0                    { upper 24 bits of ECX are 0 !  }
@@cmpCharLoop:
        MOV     BL,[ESI+ECX+6]          { case insensitive string cmp   }
        XOR     BL,[EDX+ECX+0]          { last char is compared first   }
        AND     BL,$DF
        JNE     @@notEqual
        DEC     ECX                     { ECX serves as counter         }
        JNZ     @@cmpCharLoop

        { found it }
        MOV     EAX,[ESI+2]

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;


class function TObject.MethodName(Address: Pointer): ShortString;
asm
        { ->    EAX     Pointer to class        }
        {       EDX     Address         }
        {       ECX Pointer to result   }
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EDI,ECX
        XOR     EBX,EBX
        XOR     ECX,ECX
        JMP     @@haveVMT
@@outer:
        MOV     EAX,[EAX]
@@haveVMT:
        MOV     ESI,[EAX].vmtMethodTable { fetch pointer to method table }
        TEST    ESI,ESI
        JE      @@parent
        MOV     CX,[ESI]
        ADD     ESI,2
@@inner:
        CMP     EDX,[ESI+2]
        JE      @@found
        MOV     BX,[ESI]
        ADD     ESI,EBX
        DEC     ECX
        JNZ     @@inner
@@parent:
        MOV     EAX,[EAX].vmtParent
        TEST    EAX,EAX
        JNE     @@outer
        MOV     [EDI],AL
        JMP     @@exit

@@found:
        ADD     ESI,6
        XOR     ECX,ECX
        MOV     CL,[ESI]
        INC     ECX
        REP     MOVSB

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;


function TObject.FieldAddress(const Name: ShortString): Pointer;
asm
  { ->    EAX     Pointer to instance     }
        {       EDX     Pointer to name }
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        XOR     ECX,ECX
        XOR     EDI,EDI
        MOV     BL,[EDX]

        PUSH    EAX                     { save instance pointer         }

@@outer:
        MOV     EAX,[EAX]               { fetch class pointer           }
        MOV     ESI,[EAX].vmtFieldTable
        TEST    ESI,ESI
        JE      @@parent
        MOV     DI,[ESI]                { fetch count of fields         }
        ADD     ESI,6
@@inner:
        MOV     CL,[ESI+6]              { compare string lengths        }
        CMP     CL,BL
        JE      @@cmpChar
@@cont:
        LEA     ESI,[ESI+ECX+7] { point ESI to next field       }
        DEC     EDI
        JNZ     @@inner
@@parent:
        MOV     EAX,[EAX].vmtParent     { fetch parent VMT              }
        TEST    EAX,EAX
        JNE     @@outer
        POP     EDX                     { forget instance, return Nil   }
        JMP     @@exit

@@notEqual:
        MOV     BL,[EDX]                { restore BL to length of name  }
        MOV     CL,[ESI+6]              { ECX := length of field name   }
        JMP     @@cont

@@cmpChar:
        MOV     BL,[ESI+ECX+6]  { case insensitive string cmp   }
        XOR     BL,[EDX+ECX+0]  { starting with last char       }
        AND     BL,$DF
        JNE     @@notEqual
        DEC     ECX                     { ECX serves as counter         }
        JNZ     @@cmpChar

        { found it }
        MOV     EAX,[ESI]           { result is field offset plus ...   }
        POP     EDX
        ADD     EAX,EDX         { instance pointer              }

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;

function _ClassCreate(AClass: TClass; Alloc: Boolean): TObject;
asm
        { ->    EAX = pointer to VMT      }
        { <-    EAX = pointer to instance }
        PUSH    EDX
        PUSH    ECX
        PUSH    EBX
        TEST    DL,DL
        JL      @@noAlloc
        CALL    dword ptr [EAX].vmtNewInstance
@@noAlloc:
{$IFNDEF PC_MAPPED_EXCEPTIONS}
        XOR     EDX,EDX
        LEA     ECX,[ESP+16]
        MOV     EBX,FS:[EDX]
        MOV     [ECX].TExcFrame.next,EBX
        MOV     [ECX].TExcFrame.hEBP,EBP
        MOV     [ECX].TExcFrame.desc,offset @desc
        MOV     [ECX].TexcFrame.ConstructedObject,EAX   { trick: remember copy to instance }
        MOV     FS:[EDX],ECX
{$ENDIF}
        POP     EBX
        POP     ECX
        POP     EDX
        RET

{$IFNDEF PC_MAPPED_EXCEPTIONS}
@desc:
        JMP     _HandleAnyException

  {       destroy the object                                                      }

        MOV     EAX,[ESP+8+9*4]
        MOV     EAX,[EAX].TExcFrame.ConstructedObject
        TEST    EAX,EAX
        JE      @@skip
        MOV     ECX,[EAX]
        MOV     DL,$81
        PUSH    EAX
        CALL    dword ptr [ECX].vmtDestroy
        POP     EAX
        CALL    _ClassDestroy
@@skip:
  {       reraise the exception   }
        CALL    _RaiseAgain
{$ENDIF}
end;

procedure _ClassDestroy(Instance: TObject);
begin
  Instance.FreeInstance;
end;


function _AfterConstruction(Instance: TObject): TObject;
begin
  Instance.AfterConstruction;
  Result := Instance;
end;

function _BeforeDestruction(Instance: TObject; OuterMost: ShortInt): TObject;
// Must preserve DL on return!
{$IFDEF PUREPASCAL}
begin
  Result := Instance;
  if OuterMost > 0 then Exit;
  Instance.BeforeDestruction;
end;
{$ELSE}
asm
       { ->  EAX  = pointer to instance }
       {      DL  = dealloc flag        }

        TEST    DL,DL
        JG      @@outerMost
        RET
@@outerMost:
        PUSH    EAX
        PUSH    EDX
        MOV     EDX,[EAX]
        CALL    dword ptr [EDX].vmtBeforeDestruction
        POP     EDX
        POP     EAX
end;
{$ENDIF}

{
  The following NotifyXXXX routines are used to "raise" special exceptions
  as a signaling mechanism to an interested debugger.  If the debugger sets
  the DebugHook flag to 1 or 2, then all exception processing is tracked by
  raising these special exceptions.  The debugger *MUST* respond to the
  debug event with DBG_CONTINE so that normal processing will occur.
}

{$IFDEF LINUX}
const
  excRaise      = 0; { an exception is being raised by the user (could be a reraise) }
  excCatch      = 1; { an exception is about to be caught }
  excFinally    = 2; { a finally block is about to be executed because of an exception }
  excUnhandled  = 3; { no user exception handler was found (the app will die) }

procedure _DbgExcNotify(
  NotificationKind: Integer;
  ExceptionObject: Pointer;
  ExceptionName: PShortString;
  ExceptionLocation: Pointer;
  HandlerAddr: Pointer); cdecl; export;
begin
{$IFDEF DEBUG}
  {
    This code is just for debugging the exception handling system.  The debugger
    needs _DbgExcNotify, however to place breakpoints in, so the function itself
    cannot be removed.
  }
  asm
    PUSH EAX
    PUSH EDX
  end;
  if Assigned(ExcNotificationProc) then
    ExcNotificationProc(NotificationKind, ExceptionObject, ExceptionName, ExceptionLocation, HandlerAddr);
  asm
    POP EDX
    POP EAX
  end;
{$ENDIF}
end;

{
  The following functions are used by the debugger for the evaluator.  If you
  change them IN ANY WAY, the debugger will cease to function correctly.
}
procedure _DbgEvalMarker;
begin
end;

procedure _DbgEvalExcept(E: TObject);
begin
end;

procedure _DbgEvalEnd;
begin
end;

{
  This function is used by the debugger to provide a soft landing spot
  when evaluating a function call that may raise an unhandled exception.
  The return address of _DbgEvalMarker is pushed onto the stack so that
  the unwinder will transfer control to the except block.
}
procedure _DbgEvalFrame;
begin
  try
    _DbgEvalMarker;
  except on E: TObject do
    _DbgEvalExcept(E);
  end;
  _DbgEvalEnd;
end;

{
  These export names need to match the names that will be generated into
  the .symtab section, so that the debugger can find them if stabs
  debug information is being generated.
}
exports
  _DbgExcNotify   name  '@DbgExcNotify',
  _DbgEvalFrame   name  '@DbgEvalFrame',
  _DbgEvalMarker  name  '@DbgEvalMarker',
  _DbgEvalExcept  name  '@DbgEvalExcept',
  _DbgEvalEnd     name  '@DbgEvalEnd';
{$ENDIF}

{ tell the debugger that the next raise is a re-raise of the current non-Delphi
  exception }
procedure       NotifyReRaise;
asm
{$IFDEF LINUX}
{     ->EAX     Pointer to exception object }
{       EDX     location of exception       }
        PUSH    0                   { handler addr }
        PUSH    EDX                 { location of exception }
        MOV     ECX, [EAX]
        PUSH    [ECX].vmtClassName  { exception name }
        PUSH    EAX                 { exception object }
        PUSH    excRaise            { notification kind }
        CALL    _DbgExcNotify
        ADD     ESP, 20
{$ELSE}
        CMP     BYTE PTR DebugHook,1
        JBE     @@1
        PUSH    0
        PUSH    0
        PUSH    cContinuable
        PUSH    cDelphiReRaise
        CALL    RaiseExceptionProc
@@1:
{$ENDIF}
end;

{ tell the debugger about the raise of a non-Delphi exception }
{$IFNDEF LINUX}
procedure       NotifyNonDelphiException;
asm
        CMP     BYTE PTR DebugHook,0
        JE      @@1
        PUSH    EAX
        PUSH    EAX
        PUSH    EDX
        PUSH    ESP
        PUSH    2
        PUSH    cContinuable
        PUSH    cNonDelphiException
        CALL    RaiseExceptionProc
        ADD     ESP,8
        POP     EAX
@@1:
end;
{$ENDIF}

{ Tell the debugger where the handler for the current exception is located }
procedure       NotifyExcept;
asm
{$IFDEF LINUX}
{     ->EAX     Pointer to exception object }
{       EDX     handler addr                }
        PUSH    EAX
        MOV     EAX, [EAX].TRaisedException.ExceptObject

        PUSH    EDX                 { handler addr }
        PUSH    0                   { location of exception }
        MOV     ECX, [EAX]
        PUSH    [ECX].vmtClassName  { exception name }
        PUSH    EAX                 { exception object }
        PUSH    excCatch            { notification kind }
        CALL    _DbgExcNotify
        ADD     ESP, 20

        POP     EAX
{$ELSE}
        PUSH    ESP
        PUSH    1
        PUSH    cContinuable
        PUSH    cDelphiExcept           { our magic exception code }
        CALL    RaiseExceptionProc
        ADD     ESP,4
        POP     EAX
{$ENDIF}
end;

procedure       NotifyOnExcept;
asm
{$IFDEF LINUX}
{     ->EAX     Pointer to exception object }
{       EDX     handler addr                }
        PUSH    EDX                 { handler addr }
        PUSH    0                   { location of exception }
        MOV     ECX, [EAX]
        PUSH    [ECX].vmtClassName  { exception name }
        PUSH    EAX                 { exception object }
        PUSH    excCatch            { notification kind }
        CALL    _DbgExcNotify
        ADD     ESP, 20
{$ELSE}
        CMP     BYTE PTR DebugHook,1
        JBE     @@1
        PUSH    EAX
        PUSH    [EBX].TExcDescEntry.handler
        JMP     NotifyExcept
@@1:
{$ENDIF}
end;

{$IFNDEF LINUX}
procedure       NotifyAnyExcept;
asm
        CMP     BYTE PTR DebugHook,1
        JBE     @@1
        PUSH    EAX
        PUSH    EBX
        JMP     NotifyExcept
@@1:
end;

procedure       CheckJmp;
asm
        TEST    ECX,ECX
        JE      @@3
        MOV     EAX,[ECX + 1]
        CMP     BYTE PTR [ECX],0E9H { near jmp }
        JE      @@1
        CMP     BYTE PTR [ECX],0EBH { short jmp }
        JNE     @@3
        MOVSX   EAX,AL
        INC     ECX
        INC     ECX
        JMP     @@2
@@1:
        ADD     ECX,5
@@2:
        ADD     ECX,EAX
@@3:
end;
{$ENDIF} { not LINUX }

{ Notify debugger of a finally during an exception unwind }
procedure       NotifyExceptFinally;
asm
{$IFDEF LINUX}
{     ->EAX     Pointer to exception object }
{       EDX     handler addr                }
        PUSH    EDX                 { handler addr }
        PUSH    0                   { location of exception }
        PUSH    0                   { exception name }
        PUSH    0                   { exception object }
        PUSH    excFinally          { notification kind }
        CALL    _DbgExcNotify
        ADD     ESP, 20
{$ELSE}
        CMP     BYTE PTR DebugHook,1
        JBE     @@1
        PUSH    EAX
        PUSH    EDX
        PUSH    ECX
        CALL    CheckJmp
        PUSH    ECX
        PUSH    ESP                     { pass pointer to arguments }
        PUSH    1                       { there is 1 argument }
        PUSH    cContinuable            { continuable execution }
        PUSH    cDelphiFinally          { our magic exception code }
        CALL    RaiseExceptionProc
        POP     ECX
        POP     ECX
        POP     EDX
        POP     EAX
@@1:
{$ENDIF}
end;


{ Tell the debugger that the current exception is handled and cleaned up.
  Also indicate where execution is about to resume. }
{$IFNDEF LINUX}
procedure       NotifyTerminate;
asm
        CMP     BYTE PTR DebugHook,1
        JBE     @@1
        PUSH    EDX
        PUSH    ESP
        PUSH    1
        PUSH    cContinuable
        PUSH    cDelphiTerminate        { our magic exception code }
        CALL    RaiseExceptionProc
        POP     EDX
@@1:
end;
{$ENDIF}

{ Tell the debugger that there was no handler found for the current exception
  and we are about to go to the default handler }
procedure       NotifyUnhandled;
asm
{$IFDEF LINUX}
{     ->EAX     Pointer to exception object }
{       EDX     location of exception       }
        PUSH    EAX
        MOV     EAX, [EAX].TRaisedException.ExceptObject

        PUSH    0                   { handler addr }
        PUSH    EDX                 { location of exception }
        MOV     ECX, [EAX]
        PUSH    [ECX].vmtClassName  { exception name }
        PUSH    EAX                 { exception object }
        PUSH    excUnhandled        { notification kind }
        CALL    _DbgExcNotify
        ADD     ESP, 20

        POP     EAX
{$ELSE}
        PUSH    EAX
        PUSH    EDX
        CMP     BYTE PTR DebugHook,1
        JBE     @@1
        PUSH    ESP
        PUSH    2
        PUSH    cContinuable
        PUSH    cDelphiUnhandled
        CALL    RaiseExceptionProc
@@1:
        POP     EDX
        POP     EAX
{$ENDIF}
end;

procedure       _HandleAnyException;
asm
{$IFDEF PC_MAPPED_EXCEPTIONS}
        CALL    UnblockOSExceptions
        OR      [EAX].TRaisedException.Flags, excIsBeingHandled
        MOV     ESI, EBX
        MOV     EDX, [ESP]
        CALL    NotifyExcept
        MOV     EBX, ESI
{$ENDIF}
{$IFNDEF  PC_MAPPED_EXCEPTIONS}
        { ->    [ESP+ 4] excPtr: PExceptionRecord       }
        {       [ESP+ 8] errPtr: PExcFrame              }
        {       [ESP+12] ctxPtr: Pointer                }
        {       [ESP+16] dspPtr: Pointer                }
        { <-    EAX return value - always one   }

        MOV     EAX,[ESP+4]
        TEST    [EAX].TExceptionRecord.ExceptionFlags,cUnwindInProgress
        JNE     @@exit

        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        MOV     EDX,[EAX].TExceptionRecord.ExceptObject
        MOV     ECX,[EAX].TExceptionRecord.ExceptAddr
        JE      @@DelphiException
        CLD
        CALL    _FpuInit
        MOV     EDX,ExceptObjProc
        TEST    EDX,EDX
        JE      @@exit
        CALL    EDX
        TEST    EAX,EAX
        JE      @@exit
        MOV     EDX,[ESP+12]
        MOV     ECX,[ESP+4]
        CMP     [ECX].TExceptionRecord.ExceptionCode,cCppException
        JE      @@CppException
        CALL    NotifyNonDelphiException
{$IFDEF MSWINDOWS}
        CMP     BYTE PTR JITEnable,0
        JBE     @@CppException
        CMP     BYTE PTR DebugHook,0
        JA      @@CppException                     // Do not JIT if debugging
        LEA     ECX,[ESP+4]
        PUSH    EAX
        PUSH    ECX
        CALL    UnhandledExceptionFilter
        CMP     EAX,EXCEPTION_CONTINUE_SEARCH
        POP     EAX
        JE      @@exit
        MOV     EDX,EAX
        MOV     EAX,[ESP+4]
        MOV     ECX,[EAX].TExceptionRecord.ExceptionAddress
        JMP     @@GoUnwind
{$ENDIF}
@@CppException:
        MOV     EDX,EAX
        MOV     EAX,[ESP+4]
        MOV     ECX,[EAX].TExceptionRecord.ExceptionAddress

@@DelphiException:
{$IFDEF MSWINDOWS}
        CMP     BYTE PTR JITEnable,1
        JBE     @@GoUnwind
        CMP     BYTE PTR DebugHook,0                { Do not JIT if debugging }
        JA      @@GoUnwind
        PUSH    EAX
        LEA     EAX,[ESP+8]
        PUSH    EDX
        PUSH    ECX
        PUSH    EAX
        CALL    UnhandledExceptionFilter
        CMP     EAX,EXCEPTION_CONTINUE_SEARCH
        POP     ECX
        POP     EDX
        POP     EAX
        JE      @@exit
{$ENDIF}

@@GoUnwind:
        OR      [EAX].TExceptionRecord.ExceptionFlags,cUnwinding

        PUSH    EBX
        XOR     EBX,EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     EBX,FS:[EBX]
        PUSH    EBX                     { Save pointer to topmost frame }
        PUSH    EAX                     { Save OS exception pointer     }
        PUSH    EDX                     { Save exception object         }
        PUSH    ECX                     { Save exception address        }

        MOV     EDX,[ESP+8+8*4]

        PUSH    0
        PUSH    EAX
        PUSH    offset @@returnAddress
        PUSH    EDX
        CALL    RtlUnwindProc
@@returnAddress:

        MOV     EDI,[ESP+8+8*4]

  {       Make the RaiseList entry on the stack }

        CALL    SysInit.@GetTLS
        PUSH    [EAX].RaiseListPtr
        MOV     [EAX].RaiseListPtr,ESP

        MOV     EBP,[EDI].TExcFrame.hEBP
        MOV     EBX,[EDI].TExcFrame.desc
        MOV     [EDI].TExcFrame.desc,offset @@exceptFinally

        ADD     EBX,TExcDesc.instructions
        CALL    NotifyAnyExcept
        JMP     EBX

@@exceptFinally:
        JMP     _HandleFinally

@@destroyExcept:
        {       we come here if an exception handler has thrown yet another exception }
        {       we need to destroy the exception object and pop the raise list. }

        CALL    SysInit.@GetTLS
        MOV     ECX,[EAX].RaiseListPtr
        MOV     EDX,[ECX].TRaiseFrame.NextRaise
        MOV     [EAX].RaiseListPtr,EDX

        MOV     EAX,[ECX].TRaiseFrame.ExceptObject
        JMP     TObject.Free

@@exit:
        MOV     EAX,1
{$ENDIF}  { not PC_MAPPED_EXCEPTIONS }
end;

{$IFDEF PC_MAPPED_EXCEPTIONS}
{
  Common code between the Win32 and PC mapped exception handling
  scheme.  This function takes a pointer to an object, and an exception
  'on' descriptor table and finds the matching handler descriptor.

  For support of Linux, we assume that EBX has been loaded with the GOT
  that pertains to the code which is handling the exception currently.
  If this function is being called from code which is not PIC, then
  EBX should be zero on entry.
}
procedure FindOnExceptionDescEntry;
asm
        { ->    EAX raised object: Pointer                }
        {       EDX descriptor table: ^TExcDesc           }
        {       EBX GOT of user code, or 0 if not an SO   }
        { <-    EAX matching descriptor: ^TExcDescEntry   }
        PUSH    EBP
        MOV     EBP, ESP
        SUB     ESP, 8                          { Room for vtable temp, and adjustor }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV [EBP - 8], EBX      { Store the potential GOT }
        MOV EAX, [EAX]          { load vtable of exception object }
        MOV     EBX,[EDX].TExcDesc.cnt
        LEA     ESI,[EDX].TExcDesc.excTab       { point ECX to exc descriptor table }
        MOV     [EBP - 4], EAX                  { temp for vtable of exception object }

@@innerLoop:
        MOV     EAX,[ESI].TExcDescEntry.vTable
        TEST    EAX,EAX                         { catch all clause?                     }
        JE      @@found                         { yes: This is the handler              }
        ADD     EAX, [EBP - 8]                  { add in the adjustor (could be 0) }
        MOV     EDI,[EBP - 4]                   { load vtable of exception object       }
        JMP     @@haveVMT

@@vtLoop:
        MOV     EDI,[EDI]
@@haveVMT:
        MOV     EAX,[EAX]
        CMP     EAX,EDI
        JE      @@found

        MOV     ECX,[EAX].vmtInstanceSize
        CMP     ECX,[EDI].vmtInstanceSize
        JNE     @@parent

        MOV     EAX,[EAX].vmtClassName
        MOV     EDX,[EDI].vmtClassName

        XOR     ECX,ECX
        MOV     CL,[EAX]
        CMP     CL,[EDX]
        JNE     @@parent

        INC     EAX
        INC     EDX
        CALL    _AStrCmp
        JE      @@found

@@parent:
        MOV     EDI,[EDI].vmtParent             { load vtable of parent         }
        MOV     EAX,[ESI].TExcDescEntry.vTable
        ADD     EAX, [EBP - 8]                  { add in the adjustor (could be 0) }
        TEST    EDI,EDI
        JNE     @@vtLoop

        ADD     ESI,8
        DEC     EBX
        JNZ     @@innerLoop

        { Didn't find a handler. }
        XOR     ESI, ESI

@@found:
        MOV     EAX, ESI
@@done:
        POP     EDI
        POP     ESI
        POP     EBX
        MOV     ESP, EBP
        POP     EBP
end;
{$ENDIF}

{$IFDEF PC_MAPPED_EXCEPTIONS}
procedure       _HandleOnExceptionPIC;
asm
        { ->    EAX obj : Exception object }
        {       [RA]  desc: ^TExcDesc }
        { <-    Doesn't return }

        // Mark the exception as being handled
        OR      [EAX].TRaisedException.Flags, excIsBeingHandled

        MOV     ESI, EBX                      // Save the GOT
        MOV     EDX, [ESP]                    // Get the addr of the TExcDesc
        PUSH    EAX                           // Save the object
        MOV     EAX, [EAX].TRaisedException.ExceptObject
        CALL    FindOnExceptionDescEntry
        OR      EAX, EAX
        JE      @@NotForMe

        MOV     EBX, ESI                      // Set back to user's GOT
        MOV     EDX, EAX
        POP     EAX                           // Get the object back
        POP     ECX                           // Ditch the return addr

        // Get the Pascal object itself.
        MOV     EAX, [EAX].TRaisedException.ExceptObject

        MOV     EDX, [EDX].TExcDescEntry.handler
        ADD     EDX, EBX                      // adjust for GOT
        CALL    NotifyOnExcept

        MOV     EBX, ESI                      // Make sure of user's GOT
        JMP     EDX                           // Back to the user code
        // never returns
@@NotForMe:
        POP     EAX                           // Get the exception object

        // Mark that we're reraising this exception, so that the
        // compiler generated exception handler for the 'except on' clause
        // will not get confused
        OR      [EAX].TRaisedException.Flags, excIsBeingReRaised

        JMP     SysRaiseException             // Should be using resume here
end;
{$ENDIF}

procedure       _HandleOnException;
{$IFDEF PC_MAPPED_EXCEPTIONS}
asm
        { ->    EAX obj : Exception object }
        {       [RA]  desc: ^TExcDesc }
        { <-    Doesn't return }
       
        // Mark the exception as being handled
        OR      [EAX].TRaisedException.Flags, excIsBeingHandled

        MOV     EDX, [ESP]                    // Get the addr of the TExcDesc
        PUSH    EAX                           // Save the object
        PUSH    EBX                           // Save EBX
        XOR     EBX, EBX                      // No GOT
        MOV     EAX, [EAX].TRaisedException.ExceptObject
        CALL    FindOnExceptionDescEntry
        POP     EBX                           // Restore EBX
        OR      EAX, EAX                      // Is the exception for me?
        JE      @@NotForMe

        MOV     EDX, EAX
        POP     EAX                           // Get the object back
        POP     ECX                           // Ditch the return addr

        // Get the Pascal object itself.
        MOV     EAX, [EAX].TRaisedException.ExceptObject

        MOV     EDX, [EDX].TExcDescEntry.handler
        CALL    NotifyOnExcept                // Tell the debugger about it

        JMP     EDX                           // Back to the user code
        // never returns
@@NotForMe:
        POP     EAX                           // Get the exception object

        // Mark that we're reraising this exception, so that the
        // compiler generated exception handler for the 'except on' clause
        // will not get confused
        OR      [EAX].TRaisedException.Flags, excIsBeingReRaised
        JMP     SysRaiseException             // Should be using resume here
end;
{$ENDIF}
{$IFNDEF  PC_MAPPED_EXCEPTIONS}
asm
        { ->    [ESP+ 4] excPtr: PExceptionRecord       }
  {       [ESP+ 8] errPtr: PExcFrame              }
        {       [ESP+12] ctxPtr: Pointer                }
        {       [ESP+16] dspPtr: Pointer                }
        { <-    EAX return value - always one   }

        MOV     EAX,[ESP+4]
        TEST    [EAX].TExceptionRecord.ExceptionFlags,cUnwindInProgress
        JNE     @@exit

        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        JE      @@DelphiException
        CLD
        CALL    _FpuInit
        MOV     EDX,ExceptClsProc
        TEST    EDX,EDX
        JE      @@exit
        CALL    EDX
        TEST    EAX,EAX
        JNE     @@common
        JMP     @@exit

@@DelphiException:
        MOV     EAX,[EAX].TExceptionRecord.ExceptObject
        MOV     EAX,[EAX]                       { load vtable of exception object       }

@@common:

        MOV     EDX,[ESP+8]

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     ECX,[EDX].TExcFrame.desc
        MOV     EBX,[ECX].TExcDesc.cnt
        LEA     ESI,[ECX].TExcDesc.excTab       { point ECX to exc descriptor table }
        MOV     EBP,EAX                         { load vtable of exception object }

@@innerLoop:
        MOV     EAX,[ESI].TExcDescEntry.vTable
        TEST    EAX,EAX                         { catch all clause?                     }
        JE      @@doHandler                     { yes: go execute handler               }
        MOV     EDI,EBP                         { load vtable of exception object       }
        JMP     @@haveVMT

@@vtLoop:
        MOV     EDI,[EDI]
@@haveVMT:
        MOV     EAX,[EAX]
        CMP     EAX,EDI
        JE      @@doHandler

        MOV     ECX,[EAX].vmtInstanceSize
        CMP     ECX,[EDI].vmtInstanceSize
        JNE     @@parent

        MOV     EAX,[EAX].vmtClassName
        MOV     EDX,[EDI].vmtClassName

        XOR     ECX,ECX
        MOV     CL,[EAX]
        CMP     CL,[EDX]
        JNE     @@parent

        INC     EAX
        INC     EDX
        CALL    _AStrCmp
        JE      @@doHandler

@@parent:
        MOV     EDI,[EDI].vmtParent             { load vtable of parent         }
        MOV     EAX,[ESI].TExcDescEntry.vTable
        TEST    EDI,EDI
        JNE     @@vtLoop

        ADD     ESI,8
        DEC     EBX
        JNZ     @@innerLoop

        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
        JMP     @@exit

@@doHandler:
        MOV     EAX,[ESP+4+4*4]
        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        MOV     EDX,[EAX].TExceptionRecord.ExceptObject
        MOV     ECX,[EAX].TExceptionRecord.ExceptAddr
        JE      @@haveObject
        CALL    ExceptObjProc
        MOV     EDX,[ESP+12+4*4]
        CALL    NotifyNonDelphiException
{$IFDEF MSWINDOWS}
        CMP     BYTE PTR JITEnable,0
        JBE     @@NoJIT
        CMP     BYTE PTR DebugHook,0
        JA      @@noJIT                 { Do not JIT if debugging }
        LEA     ECX,[ESP+4]
        PUSH    EAX
        PUSH    ECX
        CALL    UnhandledExceptionFilter
        CMP     EAX,EXCEPTION_CONTINUE_SEARCH
        POP     EAX
        JE      @@exit
{$ENDIF}
@@noJIT:
        MOV     EDX,EAX
        MOV     EAX,[ESP+4+4*4]
        MOV     ECX,[EAX].TExceptionRecord.ExceptionAddress
        JMP     @@GoUnwind

@@haveObject:
{$IFDEF MSWINDOWS}
        CMP     BYTE PTR JITEnable,1
        JBE     @@GoUnwind
        CMP     BYTE PTR DebugHook,0
        JA      @@GoUnwind
        PUSH    EAX
        LEA     EAX,[ESP+8]
        PUSH    EDX
        PUSH    ECX
        PUSH    EAX
        CALL    UnhandledExceptionFilter
        CMP     EAX,EXCEPTION_CONTINUE_SEARCH
        POP     ECX
        POP     EDX
        POP     EAX
        JE      @@exit
{$ENDIF}

@@GoUnwind:
        XOR     EBX,EBX
        MOV     EBX,FS:[EBX]
        PUSH    EBX                     { Save topmost frame     }
        PUSH    EAX                     { Save exception record  }
        PUSH    EDX                     { Save exception object  }
        PUSH    ECX                     { Save exception address }

        MOV     EDX,[ESP+8+8*4]
        OR      [EAX].TExceptionRecord.ExceptionFlags,cUnwinding

        PUSH    ESI                     { Save handler entry     }

        PUSH    0
        PUSH    EAX
        PUSH    offset @@returnAddress
        PUSH    EDX
        CALL    RtlUnwindProc
@@returnAddress:

        POP     EBX                     { Restore handler entry  }

        MOV     EDI,[ESP+8+8*4]

        {       Make the RaiseList entry on the stack }

        CALL    SysInit.@GetTLS
        PUSH    [EAX].RaiseListPtr
        MOV     [EAX].RaiseListPtr,ESP

        MOV     EBP,[EDI].TExcFrame.hEBP
        MOV     [EDI].TExcFrame.desc,offset @@exceptFinally
        MOV     EAX,[ESP].TRaiseFrame.ExceptObject
        CALL    NotifyOnExcept
        JMP     [EBX].TExcDescEntry.handler

@@exceptFinally:
        JMP     _HandleFinally

@@destroyExcept:
        {       we come here if an exception handler has thrown yet another exception }
        {       we need to destroy the exception object and pop the raise list. }

        CALL    SysInit.@GetTLS
        MOV     ECX,[EAX].RaiseListPtr
        MOV     EDX,[ECX].TRaiseFrame.NextRaise
        MOV     [EAX].RaiseListPtr,EDX

        MOV     EAX,[ECX].TRaiseFrame.ExceptObject
        JMP     TObject.Free
@@exit:
        MOV     EAX,1
end;
{$ENDIF}

procedure       _HandleFinally;
asm
{$IFDEF PC_MAPPED_EXCEPTIONS}
{$IFDEF PIC}
        MOV     ESI, EBX
{$ENDIF}
        CALL    UnblockOSExceptions
        MOV     EDX, [ESP]
        CALL    NotifyExceptFinally
        PUSH    EAX
{$IFDEF PIC}
        MOV     EBX, ESI
{$ENDIF}
        {
          Mark the current exception with the EBP of the handler.  If
          an exception is raised from the finally block, then this
          exception will be orphaned.  We will catch this later, when
          we clean up the next except block to complete execution.
          See DoneExcept.
        }
        MOV [EAX].TRaisedException.HandlerEBP, EBP
        CALL    EDX
        POP     EAX
        {
          We executed the finally handler without adverse reactions.
          It's safe to clear the marker now.
        }
        MOV [EAX].TRaisedException.HandlerEBP, $FFFFFFFF
        PUSH    EBP
        MOV     EBP, ESP
        CALL    SysRaiseException             // Should be using resume here
{$ENDIF}
{$IFDEF MSWINDOWS}
        { ->    [ESP+ 4] excPtr: PExceptionRecord       }
        {       [ESP+ 8] errPtr: PExcFrame              }
        {       [ESP+12] ctxPtr: Pointer                }
        {       [ESP+16] dspPtr: Pointer                }
        { <-    EAX return value - always one   }

        MOV     EAX,[ESP+4]
        MOV     EDX,[ESP+8]
        TEST    [EAX].TExceptionRecord.ExceptionFlags,cUnwindInProgress
        JE      @@exit
        MOV     ECX,[EDX].TExcFrame.desc
        MOV     [EDX].TExcFrame.desc,offset @@exit

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     EBP,[EDX].TExcFrame.hEBP
        ADD     ECX,TExcDesc.instructions
        CALL    NotifyExceptFinally
        CALL    ECX

        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX

@@exit:
        MOV     EAX,1
{$ENDIF}
end;


procedure       _HandleAutoException;
{$IFDEF LINUX}
{$IFDEF PC_MAPPED_EXCEPTIONS}
asm
        // EAX = TObject reference, or nil
        // [ESP] = ret addr

        CALL    UnblockOSExceptions
//
//  The compiler wants the stack to look like this:
//  ESP+4->  HRESULT
//  ESP+0->  ret addr
//
//  Make it so.
//
        POP     EDX
        PUSH    8000FFFFH
        PUSH    EDX

        OR      EAX, EAX    // Was this a method call?
        JE      @@Done

        PUSH    EAX
        CALL    CurrentException
        MOV     EDX, [EAX].TRaisedException.ExceptObject
        MOV     ECX, [EAX].TRaisedException.ExceptionAddr;
        POP     EAX
        MOV     EAX, [EAX]
        CALL    [EAX].vmtSafeCallException.Pointer;
        MOV     [ESP+4], EAX
@@Done:
        CALL    _DoneExcept
end;
{$ELSE}
begin
  Error(reSafeCallError);  //!!
end;
{$ENDIF}
{$ENDIF}
{$IFDEF MSWINDOWS}
asm
  { ->    [ESP+ 4] excPtr: PExceptionRecord       }
  {       [ESP+ 8] errPtr: PExcFrame              }
  {       [ESP+12] ctxPtr: Pointer                }
  {       [ESP+16] dspPtr: Pointer                }
  { <-    EAX return value - always one           }

        MOV     EAX,[ESP+4]
        TEST    [EAX].TExceptionRecord.ExceptionFlags,cUnwindInProgress
        JNE     @@exit

        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        CLD
        CALL    _FpuInit
        JE      @@DelphiException
        CMP     BYTE PTR JITEnable,0
        JBE     @@DelphiException
        CMP     BYTE PTR DebugHook,0
        JA      @@DelphiException

@@DoUnhandled:
        LEA     EAX,[ESP+4]
        PUSH    EAX
        CALL    UnhandledExceptionFilter
        CMP     EAX,EXCEPTION_CONTINUE_SEARCH
        JE      @@exit
        MOV     EAX,[ESP+4]
        JMP     @@GoUnwind

@@DelphiException:
        CMP     BYTE PTR JITEnable,1
        JBE     @@GoUnwind
        CMP     BYTE PTR DebugHook,0
        JA      @@GoUnwind
        JMP     @@DoUnhandled

@@GoUnwind:
        OR      [EAX].TExceptionRecord.ExceptionFlags,cUnwinding

        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     EDX,[ESP+8+3*4]

        PUSH    0
        PUSH    EAX
        PUSH    offset @@returnAddress
        PUSH    EDX
        CALL    RtlUnwindProc

@@returnAddress:
        POP     EBP
        POP     EDI
        POP     ESI
        MOV     EAX,[ESP+4]
        MOV     EBX,8000FFFFH
        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        JNE     @@done

        MOV     EDX,[EAX].TExceptionRecord.ExceptObject
        MOV     ECX,[EAX].TExceptionRecord.ExceptAddr
        MOV     EAX,[ESP+8]
        MOV     EAX,[EAX].TExcFrame.SelfOfMethod
        TEST    EAX,EAX
        JZ      @@freeException
        MOV     EBX,[EAX]
        CALL    [EBX].vmtSafeCallException.Pointer
        MOV     EBX,EAX
@@freeException:
        MOV     EAX,[ESP+4]
        MOV     EAX,[EAX].TExceptionRecord.ExceptObject
        CALL    TObject.Free
@@done:
        XOR     EAX,EAX
        MOV     ESP,[ESP+8]
        POP     ECX
        MOV     FS:[EAX],ECX
        POP     EDX
        POP     EBP
        LEA     EDX,[EDX].TExcDesc.instructions
        POP     ECX
        JMP     EDX
@@exit:
        MOV     EAX,1
end;
{$ENDIF}


{$IFDEF PC_MAPPED_EXCEPTIONS}
procedure       _RaiseAtExcept;
asm
        { ->    EAX     Pointer to exception object     }
        { ->    EDX     Purported addr of exception     }
        { Be careful: EBX is not set up in PIC mode. }
        { Outward bound calls must go through an exported fn, like SysRaiseException }
        OR      EAX, EAX
        JNE     @@GoAhead
        MOV     EAX, 216
        CALL    _RunError

@@GoAhead:
        CALL    BlockOSExceptions
        PUSH    EBP
        MOV     EBP, ESP
        CALL    NotifyReRaise
        CALL    AllocateException
        CALL    SysRaiseException
        {
          This can only return if there was a terrible error.  In this event,
          we have to bail out.
        }
        JMP     _Run0Error
end;
{$ENDIF}

procedure       _RaiseExcept;
asm
{$IFDEF PC_MAPPED_EXCEPTIONS}
        { ->    EAX     Pointer to exception object     }
        MOV     EDX, [ESP]
        JMP     _RaiseAtExcept
{$ENDIF}
{$IFDEF MSWINDOWS}
  { When making changes to the way Delphi Exceptions are raised, }
  { please realize that the C++ Exception handling code reraises }
  { some exceptions as Delphi Exceptions.  Of course we want to  }
  { keep exception raising compatible between Delphi and C++, so }
  { when you make changes here, consult with the relevant C++    }
  { exception handling engineer. The C++ code is in xx.cpp, in   }
  { the RTL sources, in function tossAnException.                }

  { ->    EAX     Pointer to exception object     }
  {       [ESP]   Error address           }

        OR      EAX, EAX
        JNE     @@GoAhead
        MOV     EAX, 216
        CALL    _RunError
@@GoAhead:
        POP     EDX

        PUSH    ESP
        PUSH    EBP
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        PUSH    EAX                             { pass class argument           }
        PUSH    EDX                             { pass address argument         }

        PUSH    ESP                             { pass pointer to arguments             }
        PUSH    7                               { there are seven arguments               }
        PUSH    cNonContinuable                 { we can't continue execution   }
        PUSH    cDelphiException                { our magic exception code              }
        PUSH    EDX                             { pass the user's return address        }
        JMP     RaiseExceptionProc
{$ENDIF}
end;


{$IFDEF PC_MAPPED_EXCEPTIONS}
{
  Used in the PC mapping exception implementation to handle exceptions in constructors.
}
procedure       _ClassHandleException;
asm
  {
  EAX = self
  EDX = top flag
  }
        TEST     DL, DL
        JE       _RaiseAgain
        MOV      ECX,[EAX]
        MOV      DL,$81
        PUSH     EAX
        CALL     dword ptr [ECX].vmtDestroy
        POP      EAX
        CALL     _ClassDestroy
        JMP      _RaiseAgain
end;
{$ENDIF}

procedure       _RaiseAgain;
asm
{$IFDEF PC_MAPPED_EXCEPTIONS}
        CALL    CurrentException
// The following notifies the debugger of a reraise of exceptions.  This will
// be supported in a later release, but is disabled for now.
//        PUSH    EAX
//        MOV     EDX, [EAX].TRaisedException.ExceptionAddr
//        MOV     EAX, [EAX].TRaisedException.ExceptObject
//        CALL    NotifyReRaise                   { Tell the debugger }
//        POP     EAX
        TEST    [EAX].TRaisedException.Flags, excIsBeingHandled
        JZ      @@DoIt
        OR      [EAX].TRaisedException.Flags, excIsBeingReRaised
@@DoIt:
        MOV     EDX, [ESP]                      { Get the user's addr }
        JMP     SysRaiseException
{$ENDIF}
{$IFDEF MSWINDOWS}
        { ->    [ESP        ] return address to user program }
        {       [ESP+ 4     ] raise list entry (4 dwords)    }
        {       [ESP+ 4+ 4*4] saved topmost frame            }
        {       [ESP+ 4+ 5*4] saved registers (4 dwords)     }
        {       [ESP+ 4+ 9*4] return address to OS           }
        { ->    [ESP+ 4+10*4] excPtr: PExceptionRecord       }
        {       [ESP+ 8+10*4] errPtr: PExcFrame              }

        { Point the error handler of the exception frame to something harmless }

        MOV     EAX,[ESP+8+10*4]
        MOV     [EAX].TExcFrame.desc,offset @@exit

        { Pop the RaiseList }

        CALL    SysInit.@GetTLS
        MOV     EDX,[EAX].RaiseListPtr
        MOV     ECX,[EDX].TRaiseFrame.NextRaise
        MOV     [EAX].RaiseListPtr,ECX

        { Destroy any objects created for non-delphi exceptions }

        MOV     EAX,[EDX].TRaiseFrame.ExceptionRecord
        AND     [EAX].TExceptionRecord.ExceptionFlags,NOT cUnwinding
        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        JE      @@delphiException
        MOV     EAX,[EDX].TRaiseFrame.ExceptObject
        CALL    TObject.Free
        CALL    NotifyReRaise

@@delphiException:

        XOR     EAX,EAX
        ADD     ESP,5*4
        MOV     EDX,FS:[EAX]
        POP     ECX
        MOV     EDX,[EDX].TExcFrame.next
        MOV     [ECX].TExcFrame.next,EDX

        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
@@exit:
        MOV     EAX,1
{$ENDIF}
end;

{$IFDEF DEBUG_EXCEPTIONS}
procedure NoteDE;
begin
  Writeln('DoneExcept: Skipped the destructor');
end;

procedure NoteDE2;
begin
  Writeln('DoneExcept: Destroyed the object');
end;
{$ENDIF}

{$IFDEF PC_MAPPED_EXCEPTIONS}
{
  This is implemented slow and dumb.  The theory is that it is rare
  to throw an exception past an except handler, and that the penalty
  can be particularly high here.  Partly it's done the dumb way for
  the sake of maintainability.  It could be inlined.
}
procedure       _DestroyException;
var
  Exc: PRaisedException;
  RefCount: Integer;
  ExcObj: Pointer;
  ExcAddr: Pointer;
begin
  asm
    MOV   Exc, EAX
  end;

  if (Exc^.Flags and excIsBeingReRaised) = 0 then
  begin
    RefCount := Exc^.RefCount;
    ExcObj := Exc^.ExceptObject;
    ExcAddr := Exc^.ExceptionAddr;
    Exc^.RefCount := 1;
    FreeException;
    _DoneExcept;
    Exc := AllocateException(ExcObj, ExcAddr);
    Exc^.RefCount := RefCount;
  end;

  Exc^.Flags := Exc^.Flags and not (excIsBeingReRaised or excIsBeingHandled);

  SysRaiseException(Exc);
end;
{$ENDIF}

procedure       _DoneExcept;
asm
{$IFDEF PC_MAPPED_EXCEPTIONS}
        CALL    FreeException
        OR      EAX, EAX
        JE      @@Done
        CALL    TObject.Free
@@Done:
        {
          Take a peek at the next exception object on the stack.
          If its EBP marker is at an address lower than our current
          EBP, then we know that it was orphaned when an exception was
          thrown from within the execution of a finally block.  We clean
          it up now, so that we won't leak exception records/objects.
        }
        CALL    CurrentException
        OR      EAX, EAX
        JE      @@Done2
        CMP     [EAX].TRaisedException.HandlerEBP, EBP
        JA      @@Done2
        CALL    FreeException
        OR      EAX, EAX
        JE      @@Done2
        CALL    TObject.Free
@@Done2:
{$ENDIF}
{$IFDEF MSWINDOWS}
        { ->    [ESP+ 4+10*4] excPtr: PExceptionRecord       }
        {       [ESP+ 8+10*4] errPtr: PExcFrame              }

        { Pop the RaiseList }

        CALL    SysInit.@GetTLS
        MOV     EDX,[EAX].RaiseListPtr
        MOV     ECX,[EDX].TRaiseFrame.NextRaise
        MOV     [EAX].RaiseListPtr,ECX

        { Destroy exception object }

        MOV     EAX,[EDX].TRaiseFrame.ExceptObject
        CALL    TObject.Free

        POP     EDX
        MOV     ESP,[ESP+8+9*4]
        XOR     EAX,EAX
        POP     ECX
        MOV     FS:[EAX],ECX
        POP     EAX
        POP     EBP
        CALL    NotifyTerminate
        JMP     EDX
{$ENDIF}
end;

{$IFNDEF PC_MAPPED_EXCEPTIONS}
procedure   _TryFinallyExit;
asm
{$IFDEF MSWINDOWS}
        XOR     EDX,EDX
        MOV     ECX,[ESP+4].TExcFrame.desc
        MOV     EAX,[ESP+4].TExcFrame.next
        ADD     ECX,TExcDesc.instructions
        MOV     FS:[EDX],EAX
        CALL    ECX
@@1:    RET     12
{$ENDIF}
end;
{$ENDIF}


var
  InitContext: TInitContext;

{$IFNDEF PC_MAPPED_EXCEPTIONS}
procedure       MapToRunError(P: PExceptionRecord); stdcall;
const
  STATUS_ACCESS_VIOLATION         = $C0000005;
  STATUS_ARRAY_BOUNDS_EXCEEDED    = $C000008C;
  STATUS_FLOAT_DENORMAL_OPERAND   = $C000008D;
  STATUS_FLOAT_DIVIDE_BY_ZERO     = $C000008E;
  STATUS_FLOAT_INEXACT_RESULT     = $C000008F;
  STATUS_FLOAT_INVALID_OPERATION  = $C0000090;
  STATUS_FLOAT_OVERFLOW           = $C0000091;
  STATUS_FLOAT_STACK_CHECK        = $C0000092;
  STATUS_FLOAT_UNDERFLOW          = $C0000093;
  STATUS_INTEGER_DIVIDE_BY_ZERO   = $C0000094;
  STATUS_INTEGER_OVERFLOW         = $C0000095;
  STATUS_PRIVILEGED_INSTRUCTION   = $C0000096;
  STATUS_STACK_OVERFLOW           = $C00000FD;
  STATUS_CONTROL_C_EXIT           = $C000013A;
var
  ErrCode: Byte;
begin
  case P.ExceptionCode of
    STATUS_INTEGER_DIVIDE_BY_ZERO:  ErrCode := 200;
    STATUS_ARRAY_BOUNDS_EXCEEDED:   ErrCode := 201;
    STATUS_FLOAT_OVERFLOW:          ErrCode := 205;
    STATUS_FLOAT_INEXACT_RESULT,
    STATUS_FLOAT_INVALID_OPERATION,
    STATUS_FLOAT_STACK_CHECK:       ErrCode := 207;
    STATUS_FLOAT_DIVIDE_BY_ZERO:    ErrCode := 200;
    STATUS_INTEGER_OVERFLOW:        ErrCode := 215;
    STATUS_FLOAT_UNDERFLOW,
    STATUS_FLOAT_DENORMAL_OPERAND:  ErrCode := 206;
    STATUS_ACCESS_VIOLATION:        ErrCode := 216;
    STATUS_PRIVILEGED_INSTRUCTION:  ErrCode := 218;
    STATUS_CONTROL_C_EXIT:          ErrCode := 217;
    STATUS_STACK_OVERFLOW:          ErrCode := 202;
  else                              ErrCode := 255;
  end;
  RunErrorAt(ErrCode, P.ExceptionAddress);
end;


procedure       _ExceptionHandler;
asm
        MOV     EAX,[ESP+4]

        TEST    [EAX].TExceptionRecord.ExceptionFlags,cUnwindInProgress
        JNE     @@exit
{$IFDEF MSWINDOWS}
        CMP     BYTE PTR DebugHook,0
        JA      @@ExecuteHandler
        LEA     EAX,[ESP+4]
        PUSH    EAX
        CALL    UnhandledExceptionFilter
        CMP     EAX,EXCEPTION_CONTINUE_SEARCH
        JNE     @@ExecuteHandler
        JMP     @@exit
{$ENDIF}

@@ExecuteHandler:
        MOV     EAX,[ESP+4]
        CLD
        CALL    _FpuInit
        MOV     EDX,[ESP+8]

        PUSH    0
        PUSH    EAX
        PUSH    offset @@returnAddress
        PUSH    EDX
        CALL    RtlUnwindProc

@@returnAddress:
        MOV     EBX,[ESP+4]
        CMP     [EBX].TExceptionRecord.ExceptionCode,cDelphiException
        MOV     EDX,[EBX].TExceptionRecord.ExceptAddr
        MOV     EAX,[EBX].TExceptionRecord.ExceptObject
        JE      @@DelphiException2

        MOV     EDX,ExceptObjProc
        TEST    EDX,EDX
        JE      MapToRunError
        MOV     EAX,EBX
        CALL    EDX
        TEST    EAX,EAX
        JE      MapToRunError
        MOV     EDX,[EBX].TExceptionRecord.ExceptionAddress

@@DelphiException2:

        CALL    NotifyUnhandled
        MOV     ECX,ExceptProc
        TEST    ECX,ECX
        JE      @@noExceptProc
        CALL    ECX             { call ExceptProc(ExceptObject, ExceptAddr) }

@@noExceptProc:
        MOV     ECX,[ESP+4]
        MOV     EAX,217
        MOV     EDX,[ECX].TExceptionRecord.ExceptAddr
        MOV     [ESP],EDX
        JMP     _RunError

@@exit:
        XOR     EAX,EAX
end;

procedure       SetExceptionHandler;
asm
  XOR     EDX,EDX                 { using [EDX] saves some space over [0] }
{X}     // now we come here from another place, and EBP is used above for loop counter
{X}     // let us restore it...
{X}     PUSH    EBP
{X}     LEA     EBP, [ESP + $50]
  LEA     EAX,[EBP-12]
  MOV     ECX,FS:[EDX]            { ECX := head of chain                  }
  MOV     FS:[EDX],EAX            { head of chain := @exRegRec            }

  MOV     [EAX].TExcFrame.next,ECX
{$IFDEF PIC}
  LEA     EDX, [EBX]._ExceptionHandler
  MOV     [EAX].TExcFrame.desc, EDX
{$ELSE}
  MOV     [EAX].TExcFrame.desc,offset _ExceptionHandler
{$ENDIF}
  MOV     [EAX].TExcFrame.hEBP,EBP
{$IFDEF PIC}
  MOV     [EBX].InitContext.ExcFrame,EAX
{$ELSE}
  MOV     InitContext.ExcFrame,EAX
{$ENDIF}

{X}     POP     EBP
end;


procedure       UnsetExceptionHandler;
asm
        XOR     EDX,EDX
{$IFDEF PIC}
        MOV     EAX,[EBX].InitContext.ExcFrame
{$ELSE}
        MOV     EAX,InitContext.ExcFrame
{$ENDIF}
        TEST    EAX,EAX
        JZ      @@exit
        MOV     ECX,FS:[EDX]    { ECX := head of chain          }
        CMP     EAX,ECX         { simple case: our record is first      }
        JNE     @@search
        MOV     EAX,[EAX]       { head of chain := exRegRec.next        }
        MOV     FS:[EDX],EAX
        JMP     @@exit

@@loop:
        MOV     ECX,[ECX]
@@search:
        CMP     ECX,-1          { at end of list?                       }
        JE      @@exit          { yes - didn't find it          }
        CMP     [ECX],EAX       { is it the next one on the list?       }
        JNE     @@loop          { no - look at next one on list }
@@unlink:                       { yes - unlink our record               }
        MOV     EAX,[EAX]       { get next record on list               }
        MOV     [ECX],EAX       { unlink our record                     }
@@exit:
end;
{$ENDIF} // not PC_MAPPED_EXCEPTIONS

type
  TProc = procedure;

{$IFDEF LINUX}
procedure CallProc(Proc: Pointer; GOT: Cardinal);
asm
        PUSH    EBX
        MOV     EBX,EDX
        ADD     EAX,EBX
        CALL    EAX
        POP     EBX
end;
{$ENDIF}

(*X- Original version... discarded
procedure FinalizeUnits;
var
  Count: Integer;
  Table: PUnitEntryTable;
  P: Pointer;
begin
  if InitContext.InitTable = nil then
    exit;
  Count := InitContext.InitCount;
  Table := InitContext.InitTable^.UnitInfo;
{$IFDEF LINUX}
  Inc(Cardinal(Table), InitContext.Module^.GOT);
{$ENDIF}
  try
    while Count > 0 do
    begin
      Dec(Count);
      InitContext.InitCount := Count;
      P := Table^[Count].FInit;
      if Assigned(P) then
      begin
{$IFDEF LINUX}
        CallProc(P, InitContext.Module^.GOT);
{$ENDIF}
{$IFDEF MSWINDOWS}
        TProc(P)();
{$ENDIF}
      end;
    end;
  except
    FinalizeUnits;  { try to finalize the others }
    raise;
  end;
end;
X+*)

{X+ see comments in InitUnits below }
//procedure FInitUnits; {X} - renamed to FInitUnitsHard
{X} procedure FInitUnitsHard;
var
  Count: Integer;
  Table: PUnitEntryTable;
  P: procedure;
begin
  if InitContext.InitTable = nil then
        exit;
  Count := InitContext.InitCount;
  Table := InitContext.InitTable^.UnitInfo;
{$IFDEF LINUX}
  Inc(Cardinal(Table), InitContext.Module^.GOT);
{$ENDIF}
  try
    while Count > 0 do
    begin
      Dec(Count);
      InitContext.InitCount := Count;
      P := Table^[Count].FInit;
      if Assigned(P) then
{$IFDEF LINUX}
        CallProc(P, InitContext.Module^.GOT);
{$ENDIF}
{$IFDEF MSWINDOWS}
        TProc(P)();
{$ENDIF}
    end;
  except
    {X- rename: FInitUnits;  { try to finalize the others }
    FInitUnitsHard;
    raise;
  end;
end;

// This handler can be set in initialization section of
// unit SysSfIni.pas only.
procedure InitUnitsHard( Table : PUnitEntryTable; Idx, Count : Integer );
begin
  try
    InitUnitsLight( Table, Idx, Count );
  except
    FInitUnitsHard;
    raise;
  end;
end;

{X+ see comments in InitUnits below }
procedure FInitUnitsLight;
var
  Count: Integer;
  Table: PUnitEntryTable;
  P: procedure;
begin
  if InitContext.InitTable = nil then
        exit;
  Count := InitContext.InitCount;
  Table := InitContext.InitTable^.UnitInfo;
{$IFDEF LINUX}
  Inc(Cardinal(Table), InitContext.Module^.GOT);
{$ENDIF}
  while Count > 0 do
  begin
    Dec(Count);
    InitContext.InitCount := Count;
    P := Table^[Count].FInit;
    if Assigned(P) then
{$IFDEF LINUX}
        CallProc(P, InitContext.Module^.GOT);
{$ENDIF}
{$IFDEF MSWINDOWS}
        TProc(P)();
{$ENDIF}
  end;
end;

{X+ see comments in InitUnits below }
procedure InitUnitsLight( Table : PUnitEntryTable; Idx, Count : Integer );
var P : procedure;
    Light : Boolean;
begin
  Light := @InitUnitsProc = @InitUnitsLight;
  while Idx < Count do
  begin
    P := Table^[ Idx ].Init;
    Inc( Idx );
    InitContext.InitCount := Idx;
    if Assigned( P ) then
      P;
    if Light and (@InitUnitsProc <> @InitUnitsLight) then
    begin
      InitUnitsProc( Table, Idx, Count );
      break;
    end;
  end;
end;

{X+ see comments in body of InitUnits below }
procedure InitUnits;
var
  Count, I: Integer;
  Table: PUnitEntryTable;
  {X- P: Pointer; }
begin
  if InitContext.InitTable = nil then
    exit;
  Count := InitContext.InitTable^.UnitCount;
  I := 0;
  Table := InitContext.InitTable^.UnitInfo;
{$IFDEF LINUX}
  Inc(Cardinal(Table), InitContext.Module^.GOT);
{$ENDIF}
  (*X- by default, Delphi InitUnits uses try-except & raise constructions,
      which leads to permanent use of all exception handler routines.
      Let us make this by another way.
  try
    while I < Count do
    begin
      P := Table^[I].Init;
      Inc(I);
      InitContext.InitCount := I;
      if Assigned(P) then
      begin
{$IFDEF LINUX}
        CallProc(P, InitContext.Module^.GOT);
{$ENDIF}
{$IFDEF MSWINDOWS}
        TProc(P)();
{$ENDIF}
      end;
    end;
  except
    FinalizeUnits;
    raise;
  end;
  X+*)
  InitUnitsProc( Table, I, Count ); //{X}
end;

procedure _PackageLoad(const Table : PackageInfo; Module: PLibModule);
var
  SavedContext: TInitContext;
begin
  SavedContext := InitContext;
  InitContext.DLLInitState := 0;
  InitContext.InitTable := Table;
  InitContext.InitCount := 0;
  InitContext.Module := Module;
  InitContext.OuterContext := @SavedContext;
  try
    InitUnits;
  finally
    InitContext := SavedContext;
  end;
end;


procedure _PackageUnload(const Table : PackageInfo; Module: PLibModule);
var
  SavedContext: TInitContext;
begin
  SavedContext := InitContext;
  InitContext.DLLInitState := 0;
  InitContext.InitTable := Table;
  InitContext.InitCount := Table^.UnitCount;
  InitContext.Module := Module;
  InitContext.OuterContext := @SavedContext;
  try
    {X} //FinalizeUnits;
    FInitUnitsProc;
  finally
    InitContext := SavedContext;
  end;
end;

{$IFDEF LINUX}
procedure       _StartExe(InitTable: PackageInfo; Module: PLibModule; Argc: Integer; Argv: Pointer);
begin
  ArgCount := Argc;
  ArgValues := Argv;
{$ENDIF}
{$IFDEF MSWINDOWS}
procedure       _StartExe(InitTable: PackageInfo; Module: PLibModule);
begin
  RaiseExceptionProc := @RaiseException;
  RTLUnwindProc := @RTLUnwind;
{$ENDIF}
  InitContext.InitTable := InitTable;
  InitContext.InitCount := 0;
  InitContext.Module := Module;
  MainInstance := Module.Instance;
{$IFNDEF PC_MAPPED_EXCEPTIONS}

  {X SetExceptionHandler; - moved to SysSfIni.pas }

{$ENDIF}
  IsLibrary := False;
  InitUnits;
end;

{$IFDEF MSWINDOWS}
procedure       _StartLib;
asm
        { ->    EAX InitTable   }
        {       EDX Module      }
        {       ECX InitTLS     }
        {       [ESP+4] DllProc }
        {       [EBP+8] HInst   }
        {       [EBP+12] Reason }

        { Push some desperately needed registers }

        PUSH    ECX
        PUSH    ESI
        PUSH    EDI

        { Save the current init context into the stackframe of our caller }

        MOV     ESI,offset InitContext
        LEA     EDI,[EBP- (type TExcFrame) - (type TInitContext)]
        MOV     ECX,(type TInitContext)/4
        REP     MOVSD

        { Setup the current InitContext }

        POP     InitContext.DLLSaveEDI
        POP     InitContext.DLLSaveESI
        MOV     InitContext.DLLSaveEBP,EBP
        MOV     InitContext.DLLSaveEBX,EBX
        MOV     InitContext.InitTable,EAX
        MOV     InitContext.Module,EDX
        LEA     ECX,[EBP- (type TExcFrame) - (type TInitContext)]
        MOV     InitContext.OuterContext,ECX
        XOR     ECX,ECX
        CMP     dword ptr [EBP+12],0
        JNE     @@notShutDown
        MOV     ECX,[EAX].PackageInfoTable.UnitCount
@@notShutDown:
        MOV     InitContext.InitCount,ECX

        MOV     EAX, offset RaiseException
        MOV     RaiseExceptionProc, EAX
        MOV     EAX, offset RTLUnwind
        MOV     RTLUnwindProc, EAX

        CALL    SetExceptionHandler

        MOV     EAX,[EBP+12]
        INC     EAX
        MOV     InitContext.DLLInitState,AL
        DEC     EAX

        { Init any needed TLS }

        POP     ECX
        MOV     EDX,[ECX]
        MOV     InitContext.ExitProcessTLS,EDX
        JE      @@skipTLSproc
        CMP     AL,3              // DLL_THREAD_DETACH
        JGE     @@skipTLSproc     // call ExitThreadTLS proc after DLLProc
        CALL    dword ptr [ECX+EAX*4]
@@skipTLSproc:

        { Call any DllProc }

        PUSH    ECX
        MOV     ECX,[ESP+4]
        TEST    ECX,ECX
        JE      @@noDllProc
        MOV     EAX,[EBP+12]
        MOV     EDX,[EBP+16]
        CALL    ECX
@@noDllProc:

        POP     ECX
        MOV     EAX, [EBP+12]
        CMP     AL,3                  // DLL_THREAD_DETACH
        JL      @@afterDLLproc        // don't free TLS on process shutdown
        CALL    dword ptr [ECX+EAX*4]

@@afterDLLProc:

        { Set IsLibrary if there was no exe yet }

        CMP     MainInstance,0
        JNE     @@haveExe
        MOV     IsLibrary,1
        FNSTCW  Default8087CW   // save host exe's FPU preferences

@@haveExe:

        MOV     EAX,[EBP+12]
        DEC     EAX
        JNE     _Halt0
        CALL    InitUnits
        RET     4
end;
{$ENDIF  MSWINDOWS}
{$IFDEF LINUX}
procedure       _StartLib(Context: PInitContext; Module: PLibModule; DLLProc: TDLLProcEx);
var
  TempSwap: TInitContext;
begin
  // Context's register save fields are already initialized.
  // Save the current InitContext and activate the new Context by swapping them
  TempSwap := InitContext;
  InitContext := PInitContext(Context)^;
  PInitContext(Context)^ := TempSwap;

  InitContext.Module := Module;
  InitContext.OuterContext := Context;

  // DLLInitState is initialized by SysInit to 0 for shutdown, 1 for startup
  // Inc DLLInitState to distinguish from package init:
  // 0 for package, 1 for DLL shutdown, 2 for DLL startup

  Inc(InitContext.DLLInitState);

  if InitContext.DLLInitState = 1 then
  begin
    InitContext.InitTable := Module.InitTable;
    if Assigned(InitContext.InitTable) then
      InitContext.InitCount := InitContext.InitTable.UnitCount  // shutdown
  end
  else
  begin
    Module.InitTable := InitContext.InitTable;  // save for shutdown
    InitContext.InitCount := 0;  // startup
  end;

  if Assigned(DLLProc) then
    DLLProc(InitContext.DLLInitState-1,0);

  if MainInstance = 0 then        { Set IsLibrary if there was no exe yet }
  begin
    IsLibrary := True;
    Default8087CW := Get8087CW;
  end;

  if InitContext.DLLInitState = 1 then
    _Halt0
  else
    InitUnits;
end;
{$ENDIF}

procedure _InitResStrings;
asm
        { ->    EAX     Pointer to init table               }
        {                 record                            }
        {                   cnt: Integer;                   }
        {                   tab: array [1..cnt] record      }
        {                      variableAddress: Pointer;    }
        {                      resStringAddress: Pointer;   }
        {                   end;                            }
        {                 end;                              }
        { EBX = caller's GOT for PIC callers, 0 for non-PIC }

{$IFDEF MSWINDOWS}
        PUSH    EBX
        XOR     EBX,EBX
{$ENDIF}
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,[EBX+EAX]
        LEA     ESI,[EBX+EAX+4]
@@loop:
        MOV     EAX,[ESI+4]       { load resStringAddress   }
        MOV     EDX,[ESI]         { load variableAddress    }
        ADD     EAX,EBX
        ADD     EDX,EBX
        CALL    LoadResString
        ADD     ESI,8
        DEC     EDI
        JNZ     @@loop

        POP     ESI
        POP     EDI
{$IFDEF MSWINDOWS}
        POP     EBX
{$ENDIF}
end;

procedure _InitResStringImports;
asm
        { ->    EAX     Pointer to init table               }
        {                 record                            }
        {                   cnt: Integer;                   }
        {                   tab: array [1..cnt] record      }
        {                      variableAddress: Pointer;    }
        {                      resStringAddress: ^Pointer;  }
        {                   end;                            }
        {                 end;                              }
        { EBX = caller's GOT for PIC callers, 0 for non-PIC }

{$IFDEF MSWINDOWS}
        PUSH    EBX
        XOR     EBX,EBX
{$ENDIF}
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,[EBX+EAX]
        LEA     ESI,[EBX+EAX+4]
@@loop:
        MOV     EAX,[ESI+4]         { load address of import    }
        MOV     EDX,[ESI]           { load address of variable  }
        MOV     EAX,[EBX+EAX]       { load contents of import   }
        ADD     EDX,EBX
        CALL    LoadResString
        ADD     ESI,8
        DEC     EDI
        JNZ     @@loop

        POP     ESI
        POP     EDI
{$IFDEF MSWINDOWS}
        POP     EBX
{$ENDIF}
end;

procedure _InitImports;
asm
        { ->    EAX     Pointer to init table               }
        {                 record                            }
        {                   cnt: Integer;                   }
        {                   tab: array [1..cnt] record      }
        {                      variableAddress: Pointer;    }
        {                      sourceAddress: ^Pointer;     }
        {                      sourceOffset: Longint;       }
        {                   end;                            }
        {                 end;                              }
        { EBX = caller's GOT for PIC callers, 0 for non-PIC }

{$IFDEF MSWINDOWS}
        PUSH    EBX
        XOR     EBX,EBX
{$ENDIF}
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,[EBX+EAX]
        LEA     ESI,[EBX+EAX+4]
@@loop:
        MOV     EAX,[ESI+4]     { load address of import    }
        MOV     EDX,[ESI]       { load address of variable  }
        MOV     EAX,[EBX+EAX]   { load contents of import   }
        ADD     EAX,[ESI+8]     { calc address of variable  }
        MOV     [EBX+EDX],EAX   { store result              }
        ADD     ESI,12
        DEC     EDI
        JNZ     @@loop

        POP     ESI
        POP     EDI
{$IFDEF MSWINDOWS}
        POP     EBX
{$ENDIF}
end;

{$IFDEF MSWINDOWS}
procedure _InitWideStrings;
asm
     { ->    EAX     Pointer to init table               }
     {                 record                            }
     {                   cnt: Integer;                   }
     {                   tab: array [1..cnt] record      }
     {                      variableAddress: Pointer;    }
     {                      stringAddress: ^Pointer;     }
     {                   end;                            }
     {                 end;                              }

    PUSH    EBX
    PUSH    ESI
    MOV     EBX,[EAX]
    LEA     ESI,[EAX+4]
@@loop:
    MOV     EDX,[ESI+4]     { load address of string    }
    MOV     EAX,[ESI]       { load address of variable  }
    CALL    _WStrAsg
    ADD     ESI,8
    DEC     EBX
    JNZ     @@loop

    POP     ESI
    POP     EBX
end;
{$ENDIF}

var
  runErrMsg: array[0..29] of Char = 'Runtime error     at 00000000'#0;
                        // columns:  0123456789012345678901234567890
  errCaption: array[0..5] of Char = 'Error'#0;


procedure MakeErrorMessage;
const
  dig : array [0..15] of Char = '0123456789ABCDEF';
var
  digit: Byte;
  Temp: Integer;
  Addr: Cardinal;
begin
  digit := 16;
  Temp := ExitCode;
  repeat
    runErrMsg[digit] := Char(Ord('0') + (Temp mod 10));
    Temp := Temp div 10;
    Dec(digit);
  until Temp = 0;
  digit := 28;
  Addr := Cardinal(ErrorAddr);
  repeat
    runErrMsg[digit] := dig[Addr and $F];
    Addr := Addr div 16;
    Dec(digit);
  until Addr = 0;
end;


procedure       ExitDll;
asm
        { Return False if ExitCode <> 0, and set ExitCode to 0 }

        XOR     EAX,EAX
{$IFDEF PIC}
        MOV     ECX,[EBX].ExitCode
        XCHG    EAX,[ECX]
{$ELSE}
        XCHG    EAX, ExitCode
{$ENDIF}
        NEG     EAX
        SBB     EAX,EAX
        INC     EAX

        { Restore the InitContext }
{$IFDEF PIC}
        LEA     EDI, [EBX].InitContext
{$ELSE}
        MOV EDI, offset InitContext
{$ENDIF}

        MOV     EBX,[EDI].TInitContext.DLLSaveEBX
        MOV     EBP,[EDI].TInitContext.DLLSaveEBP
        PUSH    [EDI].TInitContext.DLLSaveESI
        PUSH    [EDI].TInitContext.DLLSaveEDI

        MOV     ESI,[EDI].TInitContext.OuterContext
        MOV     ECX,(type TInitContext)/4
        REP     MOVSD
        POP     EDI
        POP     ESI

        LEAVE
{$IFDEF MSWINDOWS}
        RET     12
{$ENDIF}
{$IFDEF LINUX}
        RET
{$ENDIF}
end;

// {X} Procedure Halt0 refers to WriteLn and MessageBox
//     but actually such code can be not used really.
//     So, implementation changed to avoid such references.
//
//     Either call UseErrorMessageBox or UseErrorMessageWrite
//     to provide error message output in GUI or console app.
// {X}+

var ErrorMessageOutProc : procedure = DummyProc;

procedure ErrorMessageBox;
begin
  MakeErrorMessage;
  if not NoErrMsg then
     MessageBox(0, runErrMsg, errCaption, 0);
end;

procedure UseErrorMessageBox;
begin
  ErrorMessageOutProc := ErrorMessageBox;
end;

procedure ErrorMessageWrite;
begin
  MakeErrorMessage;
  WriteLn(PChar(@runErrMsg));
end;

procedure UseErrorMessageWrite;
begin
  ErrorMessageOutProc := ErrorMessageWrite;
end;

procedure DoCloseInputOutput;
begin
  Close( Input );
  Close( Output );
  Close(ErrOutput);
end;

var CloseInputOutput : procedure = DummyProc;

procedure UseInputOutput;
begin
  if not assigned( CloseInputOutput ) then
  begin
    CloseInputOutput := DoCloseInputOutput;
    //_Assign( Input, '' );  was for D5 so - changed
    //_Assign( Output, '' ); was for D5 so - changed
    TTextRec(Input).Mode := fmClosed;
    TTextRec(Output).Mode := fmClosed;
    TTextRec(ErrOutput).Mode := fmClosed;
  end;
end;

// {X}-
(*X-
procedure WriteErrorMessage;
{$IFDEF MSWINDOWS}
var
  Dummy: Cardinal;
begin
  if IsConsole then
  begin
    with TTextRec(Output) do
    begin
      if (Mode = fmOutput) and (BufPos > 0) then
        TTextIOFunc(InOutFunc)(TTextRec(Output));  // flush out text buffer
    end;
    WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), runErrMsg, Sizeof(runErrMsg), Dummy, nil);
    WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), sLineBreak, 2, Dummy, nil);
  end
  else if not NoErrMsg then
    MessageBox(0, runErrMsg, errCaption, 0);
{$ENDIF}
{$IFDEF LINUX}
var
  c: Char;
begin
  with TTextRec(Output) do
  begin
    if (Mode = fmOutput) and (BufPos > 0) then
      TTextIOFunc(InOutFunc)(TTextRec(Output));  // flush out text buffer
  end;
   __write(STDERR_FILENO, @runErrMsg, Sizeof(runErrMsg)-1);
   c := sLineBreak;
   __write(STDERR_FILENO, @c, 1);
{$ENDIF}
end;
X+*)

procedure _Halt0;
var
  P: procedure;
begin
{$IFDEF LINUX}
  if (ExitCode <> 0) and CoreDumpEnabled then
    __raise(SIGABRT);
{$ENDIF}

  if InitContext.DLLInitState = 0 then
    while ExitProc <> nil do
    begin
      @P := ExitProc;
      ExitProc := nil;
      P;
    end;

  { If there was some kind of runtime error, alert the user }

  if ErrorAddr <> nil then
  begin
    {X+}
    ErrorMessageOutProc;
    {
    MakeErrorMessage;
    if IsConsole then
      WriteLn(PChar(@runErrMsg))
    else if not NoErrMsg then
      MessageBox(0, runErrMsg, errCaption, 0);
    } {X-}

    {X- As it is said by Alexey Torgashin, it is better not to clear ErrorAddr
        to make possible check ErrorAddr <> nil in finalization of rest units.
        If you want, you can uncomment it again: }
    //ErrorAddr := nil;
    {X+}
  end;

  { This loop exists because we might be nested in PackageLoad calls when }
  { Halt got called. We need to unwind these contexts.                    }

  while True do
  begin

    { If we are a library, and we are starting up fine, there are no units to finalize }

    if (InitContext.DLLInitState = 2) and (ExitCode = 0) then
      InitContext.InitCount := 0;

    { Undo any unit initializations accomplished so far }

    // {X} FinalizeUnits; -- renamed
    FInitUnitsProc;

    if (InitContext.DLLInitState <= 1) or (ExitCode <> 0) then
    begin
      if InitContext.Module <> nil then
        with InitContext do
        begin
          UnregisterModule(Module);
{$IFDEF PC_MAPPED_EXCEPTIONS}
          SysUnregisterIPLookup(Module.CodeSegStart);
{$ENDIF}
          if (Module.ResInstance <> Module.Instance) and (Module.ResInstance <> 0) then
            FreeLibrary(Module.ResInstance);
        end;
    end;

{$IFNDEF PC_MAPPED_EXCEPTIONS}
    {X UnsetExceptionHandler; - changed to call of handler }
    UnsetExceptionHandlerProc;
{$ENDIF}

{$IFDEF MSWINDOWS}
    if InitContext.DllInitState = 1 then
      InitContext.ExitProcessTLS;
{$ENDIF}

    if InitContext.DllInitState <> 0 then
      ExitDll;

    if InitContext.OuterContext = nil then
    begin
      {
        If an ExitProcessProc is set, we call it.  Note that at this
        point the RTL is completely shutdown.  The only thing this is used
        for right now is the proper semantic handling of signals under Linux.
      }
      if Assigned(ExitProcessProc) then
        ExitProcessProc;
      ExitProcess(ExitCode);
    end;

    InitContext := InitContext.OuterContext^
  end;
end;

procedure _Halt;
begin
  ExitCode := Code;
  _Halt0;
end;


procedure _Run0Error;
{$IFDEF PUREPASCAL}
begin
  _RunError(0);   // loses return address
end;
{$ELSE}
asm
        XOR     EAX,EAX
        JMP     _RunError
end;
{$ENDIF}


procedure _RunError(errorCode: Byte);
{$IFDEF PUREPASCAL}
begin
  ErrorAddr := Pointer(-1);  // no return address available
  Halt(errorCode);
end;
{$ELSE}
asm
{$IFDEF PIC}
        PUSH    EAX
        CALL    GetGOT
        MOV     EBX, EAX
        POP     EAX
        MOV     ECX, [EBX].ErrorAddr
        POP     [ECX]
{$ELSE}
        POP     ErrorAddr
{$ENDIF}
        JMP     _Halt
end;
{$ENDIF}

procedure _UnhandledException;
type TExceptProc = procedure (Obj: TObject; Addr: Pointer);
begin
  if Assigned(ExceptProc) then
    TExceptProc(ExceptProc)(ExceptObject, ExceptAddr)
  else
    RunError(230);
end;

procedure _Assert(const Message, Filename: AnsiString; LineNumber: Integer);
{$IFDEF PUREPASCAL}
begin
  if Assigned(AssertErrorProc) then
    AssertErrorProc(Message, Filename, LineNumber, Pointer(-1))
  else
    Error(reAssertionFailed);  // loses return address
end;
{$ELSE}
asm
        PUSH    EBX
{$IFDEF PIC}
        PUSH    EAX
        PUSH    ECX
        CALL    GetGOT
        MOV     EBX, EAX
        MOV     EAX, [EBX].AssertErrorProc
        CMP     [EAX], 0
        POP     ECX
        POP     EAX
{$ELSE}
        CMP     AssertErrorProc,0
{$ENDIF}
        JNZ     @@1
        MOV     AL,reAssertionFailed
        CALL    Error
        JMP     @@exit

@@1:    PUSH    [ESP+4].Pointer
{$IFDEF PIC}
        MOV     EBX, [EBX].AssertErrorProc
        CALL    [EBX]
{$ELSE}
        CALL    AssertErrorProc
{$ENDIF}
@@exit:
        POP     EBX
end;
{$ENDIF}

type
  PThreadRec = ^TThreadRec;
  TThreadRec = record
    Func: TThreadFunc;
    Parameter: Pointer;
  end;

{$IFDEF MSWINDOWS}
function ThreadWrapper(Parameter: Pointer): Integer; stdcall;
{$ELSE}
function ThreadWrapper(Parameter: Pointer): Pointer; cdecl;
{$ENDIF}
asm
{$IFDEF PC_MAPPED_EXCEPTIONS}
        { Mark the top of the stack with a signature }
        PUSH    UNWINDFI_TOPOFSTACK
{$ENDIF}
        CALL    _FpuInit
        PUSH    EBP
{$IFNDEF PC_MAPPED_EXCEPTIONS}
        XOR     ECX,ECX
        PUSH    offset _ExceptionHandler
        MOV     EDX,FS:[ECX]
        PUSH    EDX
        MOV     FS:[ECX],ESP
{$ENDIF}
        MOV     EAX,Parameter

        MOV     ECX,[EAX].TThreadRec.Parameter
        MOV     EDX,[EAX].TThreadRec.Func
        PUSH    ECX
        PUSH    EDX
        CALL    _FreeMem
        POP     EDX
        POP     EAX
        CALL    EDX

{$IFNDEF PC_MAPPED_EXCEPTIONS}
        XOR     EDX,EDX
        POP     ECX
        MOV     FS:[EDX],ECX
        POP     ECX
{$ENDIF}
        POP     EBP
{$IFDEF PC_MAPPED_EXCEPTIONS}
        { Ditch our TOS marker }
        ADD     ESP, 4
{$ENDIF}
end;


{$IFDEF MSWINDOWS}
function BeginThread(SecurityAttributes: Pointer; StackSize: LongWord;
  ThreadFunc: TThreadFunc; Parameter: Pointer; CreationFlags: LongWord;
  var ThreadId: LongWord): Integer;
var
  P: PThreadRec;
begin
  New(P);
  P.Func := ThreadFunc;
  P.Parameter := Parameter;
  IsMultiThread := TRUE;
  Result := CreateThread(SecurityAttributes, StackSize, @ThreadWrapper, P,
    CreationFlags, ThreadID);
end;


procedure EndThread(ExitCode: Integer);
begin
  ExitThread(ExitCode);
end;
{$ENDIF}

{$IFDEF LINUX}
function BeginThread(Attribute: PThreadAttr;
                     ThreadFunc: TThreadFunc;
                     Parameter: Pointer;
                     var ThreadId: Cardinal): Integer;
var
  P: PThreadRec;
begin
  if Assigned(BeginThreadProc) then
    Result := BeginThreadProc(Attribute, ThreadFunc, Parameter, ThreadId)
  else
  begin
    New(P);
    P.Func := ThreadFunc;
    P.Parameter := Parameter;
    IsMultiThread := True;
    Result := _pthread_create(ThreadID, Attribute, @ThreadWrapper, P);
  end;
end;

procedure EndThread(ExitCode: Integer);
begin
  if Assigned(EndThreadProc) then
    EndThreadProc(ExitCode);
  // No "else" required since EndThreadProc does not (!!should not!!) return.
  _pthread_detach(GetCurrentThreadID);
  _pthread_exit(ExitCode);
end;
{$ENDIF}

type
  PStrRec = ^StrRec;
  StrRec = packed record
    refCnt: Longint;
    length: Longint;
  end;

const
        skew = sizeof(StrRec);
        rOff = sizeof(StrRec); { refCnt offset }
        overHead = sizeof(StrRec) + 1;

procedure _LStrClr(var S);
{$IFDEF PUREPASCAL}
var
  P: PStrRec;
begin
  if Pointer(S) <> nil then
  begin
    P := Pointer(Integer(S) - Sizeof(StrRec));
    Pointer(S) := nil;
    if P.refCnt > 0 then
      if InterlockedDecrement(P.refCnt) = 0 then
        FreeMem(P);
  end;
end;
{$ELSE}
asm
        { ->    EAX pointer to str      }

        MOV     EDX,[EAX]                       { fetch str                     }
        TEST    EDX,EDX                         { if nil, nothing to do         }
        JE      @@done
        MOV     dword ptr [EAX],0               { clear str                     }
        MOV     ECX,[EDX-skew].StrRec.refCnt    { fetch refCnt                  }
        DEC     ECX                             { if < 0: literal str           }
        JL      @@done
{X LOCK} DEC     [EDX-skew].StrRec.refCnt        { NONthreadsafe dec refCount       }
        JNE     @@done
        PUSH    EAX
        LEA     EAX,[EDX-skew].StrRec.refCnt    { if refCnt now zero, deallocate}
        CALL    _FreeMem
        POP     EAX
@@done:
end;
{$ENDIF}

procedure       _LStrArrayClr(var StrArray; cnt: longint);
{$IFDEF PUREPASCAL}
var
  P: Pointer;
begin
  P := @StrArray;
  while cnt > 0 do
  begin
    _LStrClr(P^);
    Dec(cnt);
    Inc(Integer(P), sizeof(Pointer));
  end;
end;
{$ELSE}
asm
        { ->    EAX pointer to str      }
        {       EDX cnt         }

        PUSH    EBX
        PUSH    ESI
        MOV     EBX,EAX
        MOV     ESI,EDX

@@loop:
        MOV     EDX,[EBX]                       { fetch str                     }
        TEST    EDX,EDX                         { if nil, nothing to do         }
        JE      @@doneEntry
        MOV     dword ptr [EBX],0               { clear str                     }
        MOV     ECX,[EDX-skew].StrRec.refCnt    { fetch refCnt                  }
        DEC     ECX                             { if < 0: literal str           }
        JL      @@doneEntry
{X LOCK} DEC     [EDX-skew].StrRec.refCnt        { NONthreadsafe dec refCount       }
        JNE     @@doneEntry
        LEA     EAX,[EDX-skew].StrRec.refCnt    { if refCnt now zero, deallocate}
        CALL    _FreeMem
@@doneEntry:
        ADD     EBX,4
        DEC     ESI
        JNE     @@loop

        POP     ESI
        POP     EBX
end;
{$ENDIF}

{ 99.03.11
  This function is used when assigning to global variables.

  Literals are copied to prevent a situation where a dynamically
  allocated DLL or package assigns a literal to a variable and then
  is unloaded -- thereby causing the string memory (in the code
  segment of the DLL) to be removed -- and therefore leaving the
  global variable pointing to invalid memory.
}
procedure _LStrAsg(var dest; const source);
{$IFDEF PUREPASCAL}
var
  S, D: Pointer;
  P: PStrRec;
  Temp: Longint;
begin
  S := Pointer(source);
  if S <> nil then
  begin
    P := PStrRec(Integer(S) - sizeof(StrRec));
    if P.refCnt < 0 then   // make copy of string literal
    begin
      Temp := P.length;
      S := _NewAnsiString(Temp);
      Move(Pointer(source)^, S^, Temp);
      P := PStrRec(Integer(S) - sizeof(StrRec));
    end;
    InterlockedIncrement(P.refCnt);
  end;

  D := Pointer(dest);
  Pointer(dest) := S;
  if D <> nil then
  begin
    P := PStrRec(Integer(D) - sizeof(StrRec));
    if P.refCnt > 0 then
      if InterlockedDecrement(P.refCnt) = 0 then
        FreeMem(P);
  end;
end;
{$ELSE}
asm
        { ->    EAX pointer to dest   str      }
        { ->    EDX pointer to source str      }

                TEST    EDX,EDX                           { have a source? }
                JE      @@2                               { no -> jump     }

                MOV     ECX,[EDX-skew].StrRec.refCnt
                INC     ECX
                JG      @@1                               { literal string -> jump not taken }

                PUSH    EAX
                PUSH    EDX
                MOV     EAX,[EDX-skew].StrRec.length
                CALL    _NewAnsiString
                MOV     EDX,EAX
                POP     EAX
                PUSH    EDX
                MOV     ECX,[EAX-skew].StrRec.length
                CALL    Move
                POP     EDX
                POP     EAX
                JMP     @@2

@@1:
        {X LOCK} INC     [EDX-skew].StrRec.refCnt

@@2:            XCHG    EDX,[EAX]
                TEST    EDX,EDX
                JE      @@3
                MOV     ECX,[EDX-skew].StrRec.refCnt
                DEC     ECX
                JL      @@3
        {X LOCK} DEC     [EDX-skew].StrRec.refCnt
                JNE     @@3
                LEA     EAX,[EDX-skew].StrRec.refCnt
                CALL    _FreeMem
@@3:
end;
{$ENDIF}

procedure _LStrLAsg(var dest; const source);
{$IFDEF PUREPASCAL}
var
  P: Pointer;
begin
  P := Pointer(source);
  _LStrAddRef(P);
  P := Pointer(dest);
  Pointer(dest) := Pointer(source);
  _LStrClr(P);
end;
{$ELSE}
asm
{ ->    EAX     pointer to dest }
{       EDX     source          }

                TEST    EDX,EDX
                JE      @@sourceDone

                { bump up the ref count of the source }

                MOV     ECX,[EDX-skew].StrRec.refCnt
                INC     ECX
                JLE     @@sourceDone                    { literal assignment -> jump taken }
       {X LOCK} INC     [EDX-skew].StrRec.refCnt
@@sourceDone:

                { we need to release whatever the dest is pointing to   }

                XCHG    EDX,[EAX]                       { fetch str                    }
                TEST    EDX,EDX                         { if nil, nothing to do        }
                JE      @@done
                MOV     ECX,[EDX-skew].StrRec.refCnt    { fetch refCnt                 }
                DEC     ECX                             { if < 0: literal str          }
                JL      @@done
       {X LOCK} DEC     [EDX-skew].StrRec.refCnt        { NONthreadsafe dec refCount      }
                JNE     @@done
                LEA     EAX,[EDX-skew].StrRec.refCnt    { if refCnt now zero, deallocate}
                CALL    _FreeMem
@@done:
end;
{$ENDIF}

function _NewAnsiString(length: Longint): Pointer;
{$IFDEF PUREPASCAL}
var
  P: PStrRec;
begin
  Result := nil;
  if length <= 0 then Exit;
  // Alloc an extra null for strings with even length.  This has no actual cost
  // since the allocator will round up the request to an even size anyway.
  // All widestring allocations have even length, and need a double null terminator.
  GetMem(P, length + sizeof(StrRec) + 1 + ((length + 1) and 1));
  Result := Pointer(Integer(P) + sizeof(StrRec));
  P.length := length;
  P.refcnt := 1;
  PWideChar(Result)[length div 2] := #0;  // length guaranteed >= 2
end;
{$ELSE}
asm
  { ->    EAX     length                  }
  { <-    EAX pointer to new string       }

          TEST    EAX,EAX
          JLE     @@null
          PUSH    EAX
          ADD     EAX,rOff+2                       // one or two nulls (Ansi/Wide)
          AND     EAX, not 1                   // round up to even length
          PUSH    EAX
          CALL    _GetMem
          POP     EDX                              // actual allocated length (>= 2)
          MOV     word ptr [EAX+EDX-2],0           // double null terminator
          ADD     EAX,rOff
          POP     EDX                              // requested string length
          MOV     [EAX-skew].StrRec.length,EDX
          MOV     [EAX-skew].StrRec.refCnt,1
          RET
@@null:
          XOR     EAX,EAX
end;
{$ENDIF}

procedure _LStrFromPCharLen(var Dest: AnsiString; Source: PAnsiChar; Length: Integer);
asm
  { ->    EAX     pointer to dest }
  {       EDX source              }
  {       ECX length              }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

        { allocate new string }

        MOV     EAX,EDI

        CALL    _NewAnsiString
        MOV     ECX,EDI
        MOV     EDI,EAX

        TEST    ESI,ESI
        JE      @@noMove

        MOV     EDX,EAX
        MOV     EAX,ESI
        CALL    Move

        { assign the result to dest }

@@noMove:
        MOV     EAX,EBX
        CALL    _LStrClr
        MOV     [EBX],EDI

        POP     EDI
        POP     ESI
        POP     EBX
end;


{$IFDEF LINUX}
function BufConvert(var Dest;   DestBytes: Integer;
                    const Source; SrcBytes: Integer;
                    context: Integer): Integer;
var
  SrcBytesLeft, DestBytesLeft: Integer;
  s, d: Pointer;
begin
  if context = -1 then
  begin
    Result := -1;
    Exit;
  end;
  // make copies of params...  iconv modifies param ptrs
  DestBytesLeft := DestBytes;
  SrcBytesLeft := SrcBytes;
  s := Pointer(Source);
  d := Pointer(Dest);
  if (SrcBytes = 0) or (DestBytes = 0) then
    Result := 0
  else
  begin
    Result := iconv(context, s, SrcBytesLeft, d, DestBytesLeft);
    while (SrcBytesLeft > 0) and (DestBytesLeft > 0)
      and (Result = -1) and (GetLastError = 7) do
    begin
      Result := iconv(context, s, SrcBytesLeft, d, DestBytesLeft);
    end;

    if Result <> -1 then
      Result := DestBytes - DestBytesLeft;
  end;

  iconv_close(context);
end;
{$ENDIF}


function CharFromWChar(CharDest: PChar; DestBytes: Integer; const WCharSource: PWideChar; SrcChars: Integer): Integer;
begin
{$IFDEF LINUX}
  Result := BufConvert(CharDest, DestBytes, WCharSource, SrcChars * sizeof(WideChar),
     iconv_open(nl_langinfo(_NL_CTYPE_CODESET_NAME), 'UNICODELITTLE'));
{$ENDIF}
{$IFDEF MSWINDOWS}
  Result := WideCharToMultiByte(0, 0, WCharSource, SrcChars,
      CharDest, DestBytes, nil, nil);
{$ENDIF}
end;


function WCharFromChar(WCharDest: PWideChar; DestChars: Integer; const CharSource: PChar; SrcBytes: Integer): Integer;
begin
{$IFDEF LINUX}
  Result := BufConvert(WCharDest, DestChars * sizeof(WideChar), CharSource, SrcBytes,
     iconv_open('UNICODELITTLE', nl_langinfo(_NL_CTYPE_CODESET_NAME))) div sizeof(WideChar);
{$ENDIF}
{$IFDEF MSWINDOWS}
  Result := MultiByteToWideChar(0, 0, CharSource, SrcBytes,
      WCharDest, DestChars);
{$ENDIF}
end;


procedure _LStrFromPWCharLen(var Dest: AnsiString; Source: PWideChar; Length: Integer);
var
  DestLen: Integer;
  Buffer: array[0..4095] of Char;
begin
  if Length <= 0 then
  begin
    _LStrClr(Dest);
    Exit;
  end;
  if Length+1 < (High(Buffer) div sizeof(WideChar)) then
  begin
    DestLen := CharFromWChar(Buffer, High(Buffer), Source, Length);
    if DestLen >= 0 then
    begin
      _LStrFromPCharLen(Dest, Buffer, DestLen);
      Exit;
    end;
  end;

  DestLen := (Length + 1) * sizeof(WideChar);
  SetLength(Dest, DestLen);  // overallocate, trim later
  DestLen := CharFromWChar(Pointer(Dest), DestLen, Source, Length);
  if DestLen < 0 then DestLen := 0;
  SetLength(Dest, DestLen);
end;


procedure _LStrFromChar(var Dest: AnsiString; Source: AnsiChar);
asm
    PUSH    EDX
    MOV     EDX,ESP
    MOV     ECX,1
    CALL    _LStrFromPCharLen
    POP     EDX
end;


procedure _LStrFromWChar(var Dest: AnsiString; Source: WideChar);
asm
    PUSH    EDX
    MOV     EDX,ESP
    MOV     ECX,1
    CALL    _LStrFromPWCharLen
    POP     EDX
end;


procedure _LStrFromPChar(var Dest: AnsiString; Source: PAnsiChar);
asm
        XOR     ECX,ECX
        TEST    EDX,EDX
        JE      @@5
        PUSH    EDX
@@0:    CMP     CL,[EDX+0]
        JE      @@4
        CMP     CL,[EDX+1]
        JE      @@3
        CMP     CL,[EDX+2]
        JE      @@2
        CMP     CL,[EDX+3]
        JE      @@1
        ADD     EDX,4
        JMP     @@0
@@1:    INC     EDX
@@2:    INC     EDX
@@3:    INC     EDX
@@4:    MOV     ECX,EDX
        POP     EDX
        SUB     ECX,EDX
@@5:    JMP     _LStrFromPCharLen
end;


procedure _LStrFromPWChar(var Dest: AnsiString; Source: PWideChar);
asm
        XOR     ECX,ECX
        TEST    EDX,EDX
        JE      @@5
        PUSH    EDX
@@0:    CMP     CX,[EDX+0]
        JE      @@4
        CMP     CX,[EDX+2]
        JE      @@3
        CMP     CX,[EDX+4]
        JE      @@2
        CMP     CX,[EDX+6]
        JE      @@1
        ADD     EDX,8
        JMP     @@0
@@1:    ADD     EDX,2
@@2:    ADD     EDX,2
@@3:    ADD     EDX,2
@@4:    MOV     ECX,EDX
        POP     EDX
        SUB     ECX,EDX
        SHR     ECX,1
@@5:    JMP     _LStrFromPWCharLen
end;


procedure _LStrFromString(var Dest: AnsiString; const Source: ShortString);
asm
        XOR     ECX,ECX
        MOV     CL,[EDX]
        INC     EDX
        JMP     _LStrFromPCharLen
end;


procedure _LStrFromArray(var Dest: AnsiString; Source: PAnsiChar; Length: Integer);
asm
        PUSH    EDI
        PUSH    EAX
        PUSH    ECX
        MOV     EDI,EDX
        XOR     EAX,EAX
        REPNE   SCASB
        JNE     @@1
        NOT     ECX
@@1:    POP     EAX
        ADD     ECX,EAX
        POP     EAX
        POP     EDI
        JMP     _LStrFromPCharLen
end;


procedure _LStrFromWArray(var Dest: AnsiString; Source: PWideChar; Length: Integer);
asm
        PUSH    EDI
        PUSH    EAX
        PUSH    ECX
        MOV     EDI,EDX
        XOR     EAX,EAX
        REPNE   SCASW
        JNE     @@1
        NOT     ECX
@@1:    POP     EAX
        ADD     ECX,EAX
        POP     EAX
        POP     EDI
        JMP     _LStrFromPWCharLen
end;


procedure _LStrFromWStr(var Dest: AnsiString; const Source: WideString);
asm
        { ->    EAX pointer to dest              }
        {       EDX pointer to WideString data   }

        XOR     ECX,ECX
        TEST    EDX,EDX
        JE      @@1
        MOV     ECX,[EDX-4]
        SHR     ECX,1
@@1:    JMP     _LStrFromPWCharLen
end;


procedure _LStrToString{(var Dest: ShortString; const Source: AnsiString; MaxLen: Integer)};
asm
        { ->    EAX pointer to result   }
        {       EDX AnsiString s        }
        {       ECX length of result    }

        PUSH    EBX
        TEST    EDX,EDX
        JE      @@empty
        MOV     EBX,[EDX-skew].StrRec.length
        TEST    EBX,EBX
        JE      @@empty

        CMP     ECX,EBX
        JL      @@truncate
        MOV     ECX,EBX
@@truncate:
        MOV     [EAX],CL
        INC     EAX

        XCHG    EAX,EDX
        CALL    Move

        JMP     @@exit

@@empty:
        MOV     byte ptr [EAX],0

@@exit:
        POP     EBX
end;

function _LStrLen(const s: AnsiString): Longint;
{$IFDEF PUREPASCAL}
begin
  Result := 0;
  if Pointer(s) <> nil then
    Result := PStrRec(Integer(s) - sizeof(StrRec)).length;
end;
{$ELSE}
asm
        { ->    EAX str }

        TEST    EAX,EAX
        JE      @@done
        MOV     EAX,[EAX-skew].StrRec.length;
@@done:
end;
{$ENDIF}


procedure       _LStrCat{var dest: AnsiString; source: AnsiString};
asm
        { ->    EAX     pointer to dest }
        {       EDX source              }

        TEST    EDX,EDX
        JE      @@exit

        MOV     ECX,[EAX]
        TEST    ECX,ECX
        JE      _LStrAsg

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,[ECX-skew].StrRec.length

        MOV     EDX,[ESI-skew].StrRec.length
        ADD     EDX,EDI
        CMP     ESI,ECX
        JE      @@appendSelf

        CALL    _LStrSetLength
        MOV     EAX,ESI
        MOV     ECX,[ESI-skew].StrRec.length

@@appendStr:
        MOV     EDX,[EBX]
        ADD     EDX,EDI
        CALL    Move
        POP     EDI
        POP     ESI
        POP     EBX
        RET

@@appendSelf:
        CALL    _LStrSetLength
        MOV     EAX,[EBX]
        MOV     ECX,EDI
        JMP     @@appendStr

@@exit:
end;


procedure       _LStrCat3{var dest:AnsiString; source1: AnsiString; source2: AnsiString};
asm
        {     ->EAX = Pointer to dest   }
        {       EDX = source1           }
        {       ECX = source2           }

        TEST    EDX,EDX
        JE      @@assignSource2

        TEST    ECX,ECX
        JE      _LStrAsg

        CMP     EDX,[EAX]
        JE      @@appendToDest

        CMP     ECX,[EAX]
        JE      @@theHardWay

        PUSH    EAX
        PUSH    ECX
        CALL    _LStrAsg

        POP     EDX
        POP     EAX
        JMP     _LStrCat

@@theHardWay:

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EDX
        MOV     ESI,ECX
        PUSH    EAX

        MOV     EAX,[EBX-skew].StrRec.length
        ADD     EAX,[ESI-skew].StrRec.length
        CALL    _NewAnsiString

        MOV     EDI,EAX
        MOV     EDX,EAX
        MOV     EAX,EBX
        MOV     ECX,[EBX-skew].StrRec.length
        CALL    Move

        MOV     EDX,EDI
        MOV     EAX,ESI
        MOV     ECX,[ESI-skew].StrRec.length
        ADD     EDX,[EBX-skew].StrRec.length
        CALL    Move

        POP     EAX
        MOV     EDX,EDI
        TEST    EDI,EDI
        JE      @@skip
        DEC     [EDI-skew].StrRec.refCnt    // EDI = local temp str
@@skip:
        CALL    _LStrAsg

        POP     EDI
        POP     ESI
        POP     EBX

        JMP     @@exit

@@assignSource2:
        MOV     EDX,ECX
        JMP     _LStrAsg

@@appendToDest:
        MOV     EDX,ECX
        JMP     _LStrCat

@@exit:
end;


procedure       _LStrCatN{var dest:AnsiString; argCnt: Integer; ...};
asm
        {     ->EAX = Pointer to dest   }
        {       EDX = number of args (>= 3)     }
        {       [ESP+4], [ESP+8], ... crgCnt AnsiString arguments, reverse order }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EDX
        PUSH    EAX
        MOV     EBX,EDX

        XOR     EDI,EDI
        MOV     ECX,[ESP+EDX*4+5*4] // first arg is furthest out
        TEST    ECX,ECX
        JZ      @@0
        CMP     [EAX],ECX          // is dest = first arg?
        JNE     @@0
        MOV     EDI,EAX            // EDI nonzero -> potential appendstr case
@@0:
        XOR     EAX,EAX
@@loop1:
        MOV     ECX,[ESP+EDX*4+5*4]
        TEST    ECX,ECX
        JE      @@1
        ADD     EAX,[ECX-skew].StrRec.length
        CMP     EDI,ECX          // is dest an arg besides arg1?
        JNE     @@1
        XOR     EDI,EDI          // can't appendstr - dest is multiple args
@@1:
        DEC     EDX
        JNE     @@loop1

@@append:
        TEST    EDI,EDI          // dest is 1st and only 1st arg?
        JZ      @@copy
        MOV     EDX,EAX          // length into EDX
        MOV     EAX,EDI          // ptr to str into EAX
        MOV     ESI,[EDI]
        MOV     ESI,[ESI-skew].StrRec.Length  // save old size before realloc
        CALL    _LStrSetLength
        PUSH    EDI              // append other strs to dest
        ADD     ESI,[EDI]        // end of old string
        DEC     EBX
        JMP     @@loop2

@@copy:
        CALL    _NewAnsiString
        PUSH    EAX
        MOV     ESI,EAX

@@loop2:
        MOV     EAX,[ESP+EBX*4+6*4]
        MOV     EDX,ESI
        TEST    EAX,EAX
        JE      @@2
        MOV     ECX,[EAX-skew].StrRec.length
        ADD     ESI,ECX
        CALL    Move
@@2:
        DEC     EBX
        JNE     @@loop2

        POP     EDX
        POP     EAX
        TEST    EDI,EDI
        JNZ      @@exit

        TEST    EDX,EDX
        JE      @@skip
        DEC     [EDX-skew].StrRec.refCnt   // EDX = local temp str
@@skip:
        CALL    _LStrAsg

@@exit:
        POP     EDX
        POP     EDI
        POP     ESI
        POP     EBX
        POP     EAX
        LEA     ESP,[ESP+EDX*4]
        JMP     EAX
end;


procedure       _LStrCmp{left: AnsiString; right: AnsiString};
asm
{     ->EAX = Pointer to left string    }
{       EDX = Pointer to right string   }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        CMP     EAX,EDX
        JE      @@exit

        TEST    ESI,ESI
        JE      @@str1null

        TEST    EDI,EDI
        JE      @@str2null

        MOV     EAX,[ESI-skew].StrRec.length
        MOV     EDX,[EDI-skew].StrRec.length

        SUB     EAX,EDX { eax = len1 - len2 }
        JA      @@skip1
        ADD     EDX,EAX { edx = len2 + (len1 - len2) = len1     }

@@skip1:
        PUSH    EDX
        SHR     EDX,2
        JE      @@cmpRest
@@longLoop:
        MOV     ECX,[ESI]
        MOV     EBX,[EDI]
        CMP     ECX,EBX
        JNE     @@misMatch
        DEC     EDX
        JE      @@cmpRestP4
        MOV     ECX,[ESI+4]
        MOV     EBX,[EDI+4]
        CMP     ECX,EBX
        JNE     @@misMatch
        ADD     ESI,8
        ADD     EDI,8
        DEC     EDX
        JNE     @@longLoop
        JMP     @@cmpRest
@@cmpRestP4:
        ADD     ESI,4
        ADD     EDI,4
@@cmpRest:
        POP     EDX
        AND     EDX,3
        JE      @@equal

        MOV     ECX,[ESI]
        MOV     EBX,[EDI]
        CMP     CL,BL
        JNE     @@exit
        DEC     EDX
        JE      @@equal
        CMP     CH,BH
        JNE     @@exit
        DEC     EDX
        JE      @@equal
        AND     EBX,$00FF0000
        AND     ECX,$00FF0000
        CMP     ECX,EBX
        JNE     @@exit

@@equal:
        ADD     EAX,EAX
        JMP     @@exit

@@str1null:
        MOV     EDX,[EDI-skew].StrRec.length
        SUB     EAX,EDX
        JMP     @@exit

@@str2null:
        MOV     EAX,[ESI-skew].StrRec.length
        SUB     EAX,EDX
        JMP     @@exit

@@misMatch:
        POP     EDX
        CMP     CL,BL
        JNE     @@exit
        CMP     CH,BH
        JNE     @@exit
        SHR     ECX,16
        SHR     EBX,16
        CMP     CL,BL
        JNE     @@exit
        CMP     CH,BH

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX

end;

function _LStrAddRef(var str): Pointer;
{$IFDEF PUREPASCAL}
var
  P: PStrRec;
begin
  P := Pointer(Integer(str) - sizeof(StrRec));
  if P <> nil then
    if P.refcnt >= 0 then
      InterlockedIncrement(P.refcnt);
  Result := Pointer(str);
end;
{$ELSE}
asm
        { ->    EAX     str     }
        TEST    EAX,EAX
        JE      @@exit
        MOV     EDX,[EAX-skew].StrRec.refCnt
        INC     EDX
        JLE     @@exit
{X LOCK} INC     [EAX-skew].StrRec.refCnt
@@exit:
end;
{$ENDIF}

function PICEmptyString: PWideChar;
begin
  Result := '';
end;

function _LStrToPChar(const s: AnsiString): PChar;
{$IFDEF PUREPASCAL}
const
  EmptyString = '';
begin
  if Pointer(s) = nil then
    Result := EmptyString
  else
    Result := Pointer(s);
end;
{$ELSE}
asm
        { ->    EAX pointer to str              }
        { <-    EAX pointer to PChar    }

        TEST    EAX,EAX
        JE      @@handle0
        RET
{$IFDEF PIC}
@@handle0:
        JMP     PICEmptyString
{$ELSE}
@@zeroByte:
        DB      0
@@handle0:
        MOV     EAX,offset @@zeroByte
{$ENDIF}             
end;
{$ENDIF}

function InternalUniqueString(var str): Pointer;
asm
        { ->    EAX pointer to str              }
        { <-    EAX pointer to unique copy      }
        MOV     EDX,[EAX]
        TEST    EDX,EDX
        JE      @@exit
        MOV     ECX,[EDX-skew].StrRec.refCnt
        DEC     ECX
        JE      @@exit

        PUSH    EBX
        MOV     EBX,EAX
        MOV     EAX,[EDX-skew].StrRec.length
        CALL    _NewAnsiString
        MOV     EDX,EAX
        MOV     EAX,[EBX]
        MOV     [EBX],EDX
        PUSH    EAX
        MOV     ECX,[EAX-skew].StrRec.length
        CALL    Move
        POP     EAX
        MOV     ECX,[EAX-skew].StrRec.refCnt
        DEC     ECX
        JL      @@skip
{X LOCK} DEC     [EAX-skew].StrRec.refCnt
        JNZ     @@skip
        LEA     EAX,[EAX-skew].StrRec.refCnt    { if refCnt now zero, deallocate}
        CALL    _FreeMem
@@skip:
        MOV     EDX,[EBX]
        POP     EBX
@@exit:
        MOV     EAX,EDX
end;


procedure UniqueString(var str: AnsiString);
asm
        JMP     InternalUniqueString
end;

procedure _UniqueStringA(var str: AnsiString);
asm
        JMP     InternalUniqueString
end;

procedure UniqueString(var str: WideString);
asm
{$IFDEF LINUX}
        JMP     InternalUniqueString
{$ENDIF}
{$IFDEF MSWINDOWS}
    // nothing to do - Windows WideStrings are always single reference
{$ENDIF}
end;

procedure _UniqueStringW(var str: WideString);
asm
{$IFDEF LINUX}
        JMP     InternalUniqueString
{$ENDIF}
{$IFDEF MSWINDOWS}
    // nothing to do - Windows WideStrings are always single reference
{$ENDIF}
end;

procedure       _LStrCopy{ const s : AnsiString; index, count : Integer) : AnsiString};
asm
        {     ->EAX     Source string                   }
        {       EDX     index                           }
        {       ECX     count                           }
        {       [ESP+4] Pointer to result string        }

        PUSH    EBX

        TEST    EAX,EAX
        JE      @@srcEmpty

        MOV     EBX,[EAX-skew].StrRec.length
        TEST    EBX,EBX
        JE      @@srcEmpty

{       make index 0-based and limit to 0 <= index < Length(src) }

        DEC     EDX
        JL      @@smallInx
        CMP     EDX,EBX
        JGE     @@bigInx

@@cont1:

{       limit count to satisfy 0 <= count <= Length(src) - index        }

        SUB     EBX,EDX { calculate Length(src) - index }
        TEST    ECX,ECX
        JL      @@smallCount
        CMP     ECX,EBX
        JG      @@bigCount

@@cont2:

        ADD     EDX,EAX
        MOV     EAX,[ESP+4+4]
        CALL    _LStrFromPCharLen
        JMP     @@exit

@@smallInx:
        XOR     EDX,EDX
        JMP     @@cont1
@@bigCount:
        MOV     ECX,EBX
        JMP     @@cont2
@@bigInx:
@@smallCount:
@@srcEmpty:
        MOV     EAX,[ESP+4+4]
        CALL    _LStrClr
@@exit:
        POP     EBX
        RET     4
end;


procedure       _LStrDelete{ var s : AnsiString; index, count : Integer };
asm
        {     ->EAX     Pointer to s    }
        {       EDX     index           }
        {       ECX     count           }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

        CALL    UniqueString

        MOV     EDX,[EBX]
        TEST    EDX,EDX         { source already empty: nothing to do   }
        JE      @@exit

        MOV     ECX,[EDX-skew].StrRec.length

{       make index 0-based, if not in [0 .. Length(s)-1] do nothing     }

        DEC     ESI
        JL      @@exit
        CMP     ESI,ECX
        JGE     @@exit

{       limit count to [0 .. Length(s) - index] }

        TEST    EDI,EDI
        JLE     @@exit
        SUB     ECX,ESI         { ECX = Length(s) - index       }
        CMP     EDI,ECX
        JLE     @@1
        MOV     EDI,ECX
@@1:

{       move length - index - count characters from s+index+count to s+index }

        SUB     ECX,EDI         { ECX = Length(s) - index - count       }
        ADD     EDX,ESI         { EDX = s+index                 }
        LEA     EAX,[EDX+EDI]   { EAX = s+index+count           }
        CALL    Move

{       set length(s) to length(s) - count      }

        MOV     EDX,[EBX]
        MOV     EAX,EBX
        MOV     EDX,[EDX-skew].StrRec.length
        SUB     EDX,EDI
        CALL    _LStrSetLength

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;


procedure       _LStrInsert{ const source : AnsiString; var s : AnsiString; index : Integer };
asm
        { ->    EAX source string                       }
        {       EDX     pointer to destination string   }
        {       ECX index                               }

        TEST    EAX,EAX
        JE      @@nothingToDo

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

{       make index 0-based and limit to 0 <= index <= Length(s) }

        MOV     EDX,[EDX]
        PUSH    EDX
        TEST    EDX,EDX
        JE      @@sIsNull
        MOV     EDX,[EDX-skew].StrRec.length
@@sIsNull:
        DEC     EDI
        JGE     @@indexNotLow
        XOR     EDI,EDI
@@indexNotLow:
        CMP     EDI,EDX
        JLE     @@indexNotHigh
        MOV     EDI,EDX
@@indexNotHigh:

        MOV     EBP,[EBX-skew].StrRec.length

{       set length of result to length(source) + length(s)      }

        MOV     EAX,ESI
        ADD     EDX,EBP
        CALL    _LStrSetLength
        POP     EAX

        CMP     EAX,EBX
        JNE     @@notInsertSelf
        MOV     EBX,[ESI]

@@notInsertSelf:

{       move length(s) - length(source) - index chars from s+index to s+index+length(source) }

        MOV     EAX,[ESI]                       { EAX = s       }
        LEA     EDX,[EDI+EBP]                   { EDX = index + length(source)  }
        MOV     ECX,[EAX-skew].StrRec.length
        SUB     ECX,EDX                         { ECX = length(s) - length(source) - index }
        ADD     EDX,EAX                         { EDX = s + index + length(source)      }
        ADD     EAX,EDI                         { EAX = s + index       }
        CALL    Move

{       copy length(source) chars from source to s+index        }

        MOV     EAX,EBX
        MOV     EDX,[ESI]
        MOV     ECX,EBP
        ADD     EDX,EDI
        CALL    Move

@@exit:
        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
@@nothingToDo:
end;


procedure       _LStrPos{ const substr : AnsiString; const s : AnsiString ) : Integer};
asm
{     ->EAX     Pointer to substr               }
{       EDX     Pointer to string               }
{     <-EAX     Position of substr in s or 0    }

        TEST    EAX,EAX
        JE      @@noWork

        TEST    EDX,EDX
        JE      @@stringEmpty

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX                         { Point ESI to substr           }
        MOV     EDI,EDX                         { Point EDI to s                }

        MOV     ECX,[EDI-skew].StrRec.length    { ECX = Length(s)               }

        PUSH    EDI                             { remember s position to calculate index        }

        MOV     EDX,[ESI-skew].StrRec.length    { EDX = Length(substr)          }

        DEC     EDX                             { EDX = Length(substr) - 1              }
        JS      @@fail                          { < 0 ? return 0                        }
        MOV     AL,[ESI]                        { AL = first char of substr             }
        INC     ESI                             { Point ESI to 2'nd char of substr      }

        SUB     ECX,EDX                         { #positions in s to look at    }
                                                { = Length(s) - Length(substr) + 1      }
        JLE     @@fail
@@loop:
        REPNE   SCASB
        JNE     @@fail
        MOV     EBX,ECX                         { save outer loop counter               }
        PUSH    ESI                             { save outer loop substr pointer        }
        PUSH    EDI                             { save outer loop s pointer             }

        MOV     ECX,EDX
        REPE    CMPSB
        POP     EDI                             { restore outer loop s pointer  }
        POP     ESI                             { restore outer loop substr pointer     }
        JE      @@found
        MOV     ECX,EBX                         { restore outer loop counter    }
        JMP     @@loop

@@fail:
        POP     EDX                             { get rid of saved s pointer    }
        XOR     EAX,EAX
        JMP     @@exit

@@stringEmpty:
        XOR     EAX,EAX
        JMP     @@noWork

@@found:
        POP     EDX                             { restore pointer to first char of s    }
        MOV     EAX,EDI                         { EDI points of char after match        }
        SUB     EAX,EDX                         { the difference is the correct index   }
@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
@@noWork:
end;


procedure       _LStrSetLength{ var str: AnsiString; newLength: Integer};
asm
        { ->    EAX     Pointer to str  }
        {       EDX new length  }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,EDX
        XOR     EDI,EDI

        TEST    EDX,EDX
        JLE     @@setString

        MOV     EAX,[EBX]
        TEST    EAX,EAX
        JE      @@copyString

        CMP     [EAX-skew].StrRec.refCnt,1
        JNE     @@copyString

        SUB     EAX,rOff
        ADD     EDX,rOff+1
        PUSH    EAX
        MOV     EAX,ESP
        CALL    _ReallocMem
        POP     EAX
        ADD     EAX,rOff
        MOV     [EBX],EAX
        MOV     [EAX-skew].StrRec.length,ESI
        MOV     BYTE PTR [EAX+ESI],0
        JMP     @@exit

@@copyString:
        MOV     EAX,EDX
        CALL    _NewAnsiString
        MOV     EDI,EAX

        MOV     EAX,[EBX]
        TEST    EAX,EAX
        JE      @@setString

        MOV     EDX,EDI
        MOV     ECX,[EAX-skew].StrRec.length
        CMP     ECX,ESI
        JL      @@moveString
        MOV     ECX,ESI

@@moveString:
        CALL    Move

@@setString:
        MOV     EAX,EBX
        CALL    _LStrClr
        MOV     [EBX],EDI

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;


procedure       _LStrOfChar{ c: Char; count: Integer): AnsiString };
asm
        { ->    AL      c               }
        {       EDX     count           }
        {       ECX     result  }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

        MOV     EAX,ECX
        CALL    _LStrClr

        TEST    ESI,ESI
        JLE @@exit

        MOV     EAX,ESI
        CALL    _NewAnsiString

        MOV     [EDI],EAX

        MOV     EDX,ESI
        MOV     CL,BL

        CALL    _FillChar

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX

end;


function _Write0LString(var t: TTextRec; const s: AnsiString): Pointer;
begin
  Result := _WriteLString(t, s, 0);
end;


function _WriteLString(var t: TTextRec; const s: AnsiString; width: Longint): Pointer;
{$IFDEF PUREPASCAL}
var
  i: Integer;
begin
  i := Length(s);
  _WriteSpaces(t, width - i);
  Result := _WriteBytes(t, s[1], i);
end;
{$ELSE}
asm
        { ->    EAX     Pointer to text record  }
        {       EDX     Pointer to AnsiString   }
        {       ECX     Field width             }

        PUSH    EBX

        MOV     EBX,EDX

        MOV     EDX,ECX
        XOR     ECX,ECX
        TEST    EBX,EBX
        JE      @@skip
        MOV     ECX,[EBX-skew].StrRec.length
        SUB     EDX,ECX
@@skip:
        PUSH    ECX
        CALL    _WriteSpaces
        POP     ECX

        MOV     EDX,EBX
        POP     EBX
        JMP     _WriteBytes
end;
{$ENDIF}


function _Write0WString(var t: TTextRec; const s: WideString): Pointer;
begin
  Result := _WriteWString(t, s, 0);
end;


function _WriteWString(var t: TTextRec; const s: WideString; width: Longint): Pointer;
var
  i: Integer;
begin
  i := Length(s);
  _WriteSpaces(t, width - i);
  Result := _WriteLString(t, AnsiString(s), 0);
end;


function _Write0WCString(var t: TTextRec; s: PWideChar): Pointer;
begin
  Result := _WriteWCString(t, s, 0);
end;


function _WriteWCString(var t: TTextRec; s: PWideChar; width: Longint): Pointer;
var
  i: Integer;
begin
  i := 0;
  if (s <> nil) then
    while s[i] <> #0 do
      Inc(i);

  _WriteSpaces(t, width - i);
  Result := _WriteLString(t, AnsiString(s), 0);
end;


function _Write0WChar(var t: TTextRec; c: WideChar): Pointer;
begin
  Result := _WriteWChar(t, c, 0);
end;


function _WriteWChar(var t: TTextRec; c: WideChar; width: Integer): Pointer;
begin
  _WriteSpaces(t, width - 1);
  Result := _WriteLString(t, AnsiString(c), 0);
end;


{$IFDEF MSWINDOWS}
procedure WStrError;
asm
        MOV     AL,reOutOfMemory
        JMP     Error
end;
{$ENDIF}

function _NewWideString(CharLength: Longint): Pointer;
{$IFDEF LINUX}
begin
  Result := _NewAnsiString(CharLength*2);
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
asm
        TEST    EAX,EAX
        JE      @@1
        PUSH    EAX
        PUSH    0
        CALL    SysAllocStringLen
        TEST    EAX,EAX
        JE      WStrError
@@1:
end;
{$ENDIF}

procedure WStrSet(var S: WideString; P: PWideChar);
{$IFDEF PUREPASCAL}
var
  Temp: Pointer;
begin
  Temp := Pointer(InterlockedExchange(Pointer(S), Pointer(P)));
  if Temp <> nil then
    _WStrClr(Temp);
end;
{$ELSE}
asm
{$IFDEF LINUX}
        XCHG    [EAX],EDX
        TEST    EDX,EDX
        JZ      @@1
        PUSH    EDX
        MOV     EAX, ESP
        CALL    _WStrClr
        POP     EAX
{$ENDIF}
{$IFDEF MSWINDOWS}
        XCHG    [EAX],EDX
        TEST    EDX,EDX
        JZ      @@1
        PUSH    EDX
        CALL    SysFreeString
{$ENDIF}
@@1:
end;
{$ENDIF}


procedure WStrClr;
asm
       JMP _WStrClr
end;

procedure _WStrClr(var S);
{$IFDEF LINUX}
asm
        JMP     _LStrClr;
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
asm
        { ->    EAX     Pointer to WideString  }

        MOV     EDX,[EAX]
        TEST    EDX,EDX
        JE      @@1
        MOV     DWORD PTR [EAX],0
        PUSH    EAX
        PUSH    EDX
        CALL    SysFreeString
        POP     EAX
@@1:
end;
{$ENDIF}


procedure WStrArrayClr;
asm
        JMP     _WStrArrayClr;
end;

procedure _WStrArrayClr(var StrArray; Count: Integer);
{$IFDEF LINUX}
asm
        JMP     _LStrArrayClr
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,EAX
        MOV     ESI,EDX
@@1:    MOV     EAX,[EBX]
        TEST    EAX,EAX
        JE      @@2
        MOV     DWORD PTR [EBX],0
        PUSH    EAX
        CALL    SysFreeString
@@2:    ADD     EBX,4
        DEC     ESI
        JNE     @@1
        POP     ESI
        POP     EBX
end;
{$ENDIF}


procedure _WStrAsg(var Dest: WideString; const Source: WideString);
{$IFDEF LINUX}
asm
        JMP     _LStrAsg
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
asm
        { ->    EAX     Pointer to WideString }
        {       EDX     Pointer to data       }
        TEST    EDX,EDX
        JE      _WStrClr
        MOV     ECX,[EDX-4]
        SHR     ECX,1
        JE      _WStrClr
        PUSH    ECX
        PUSH    EDX
        PUSH    EAX
        CALL    SysReAllocStringLen
        TEST    EAX,EAX
        JE      WStrError
end;
{$ENDIF}

procedure _WStrLAsg(var Dest: WideString; const Source: WideString);
{$IFDEF LINUX}
asm
        JMP   _LStrLAsg
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
asm
        JMP   _WStrAsg
end;
{$ENDIF}

procedure _WStrFromPCharLen(var Dest: WideString; Source: PAnsiChar; Length: Integer);
var
  DestLen: Integer;
  Buffer: array[0..2047] of WideChar;
begin
  if Length <= 0 then
  begin
    _WStrClr(Dest);
    Exit;
  end;
  if Length+1 < High(Buffer) then
  begin
    DestLen := WCharFromChar(Buffer, High(Buffer), Source, Length);
    if DestLen > 0 then
    begin
      _WStrFromPWCharLen(Dest, @Buffer, DestLen);
      Exit;
    end;
  end;

  DestLen := (Length + 1);
  _WStrSetLength(Dest, DestLen);  // overallocate, trim later
  DestLen := WCharFromChar(Pointer(Dest), DestLen, Source, Length);
  if DestLen < 0 then DestLen := 0;
  _WStrSetLength(Dest, DestLen);
end;

procedure _WStrFromPWCharLen(var Dest: WideString; Source: PWideChar; CharLength: Integer);
{$IFDEF LINUX}
var
  Temp: Pointer;
begin
  Temp := Pointer(Dest);
  if CharLength > 0 then
  begin
    Pointer(Dest) := _NewWideString(CharLength);
    if Source <> nil then
      Move(Source^, Pointer(Dest)^, CharLength * sizeof(WideChar));
  end
  else
    Pointer(Dest) := nil;
  _WStrClr(Temp);
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
asm
        { ->    EAX     Pointer to WideString (dest)      }
        {       EDX     Pointer to characters (source)    }
        {       ECX     number of characters  (not bytes) }
        TEST    ECX,ECX
        JE      _WStrClr

        PUSH    EAX

        PUSH    ECX
        PUSH    EDX
        CALL    SysAllocStringLen
        TEST    EAX,EAX
        JE      WStrError

        POP     EDX
        PUSH    [EDX].PWideChar
        MOV     [EDX],EAX

        CALL    SysFreeString
end;
{$ENDIF}


procedure _WStrFromChar(var Dest: WideString; Source: AnsiChar);
asm
        PUSH    EDX
        MOV     EDX,ESP
        MOV     ECX,1
        CALL    _WStrFromPCharLen
        POP     EDX
end;


procedure _WStrFromWChar(var Dest: WideString; Source: WideChar);
asm
        { ->    EAX     Pointer to WideString (dest)   }
        {       EDX     character             (source) }
        PUSH    EDX
        MOV     EDX,ESP
        MOV     ECX,1
        CALL    _WStrFromPWCharLen
        POP     EDX
end;


procedure _WStrFromPChar(var Dest: WideString; Source: PAnsiChar);
asm
  { ->    EAX     Pointer to WideString (dest)   }
        {       EDX     Pointer to character  (source) }
        XOR     ECX,ECX
        TEST    EDX,EDX
        JE      @@5
        PUSH    EDX
@@0:    CMP     CL,[EDX+0]
        JE      @@4
        CMP     CL,[EDX+1]
        JE      @@3
        CMP     CL,[EDX+2]
        JE      @@2
        CMP     CL,[EDX+3]
        JE      @@1
        ADD     EDX,4
        JMP     @@0
@@1:    INC     EDX
@@2:    INC     EDX
@@3:    INC     EDX
@@4:    MOV     ECX,EDX
        POP     EDX
        SUB     ECX,EDX
@@5:    JMP     _WStrFromPCharLen
end;


procedure _WStrFromPWChar(var Dest: WideString; Source: PWideChar);
asm
        { ->    EAX     Pointer to WideString (dest)   }
        {       EDX     Pointer to character  (source) }
        XOR     ECX,ECX
        TEST    EDX,EDX
        JE      @@5
        PUSH    EDX
@@0:    CMP     CX,[EDX+0]
        JE      @@4
        CMP     CX,[EDX+2]
        JE      @@3
        CMP     CX,[EDX+4]
        JE      @@2
        CMP     CX,[EDX+6]
        JE      @@1
        ADD     EDX,8
        JMP     @@0
@@1:    ADD     EDX,2
@@2:    ADD     EDX,2
@@3:    ADD     EDX,2
@@4:    MOV     ECX,EDX
        POP     EDX
        SUB     ECX,EDX
        SHR     ECX,1
@@5:    JMP     _WStrFromPWCharLen
end;


procedure _WStrFromString(var Dest: WideString; const Source: ShortString);
asm
        XOR     ECX,ECX
        MOV     CL,[EDX]
        INC     EDX
        JMP     _WStrFromPCharLen
end;


procedure _WStrFromArray(var Dest: WideString; Source: PAnsiChar; Length: Integer);
asm
        PUSH    EDI
        PUSH    EAX
        PUSH    ECX
        MOV     EDI,EDX
        XOR     EAX,EAX
        REPNE   SCASB
        JNE     @@1
        NOT     ECX
@@1:    POP     EAX
        ADD     ECX,EAX
        POP     EAX
        POP     EDI
        JMP     _WStrFromPCharLen
end;


procedure _WStrFromWArray(var Dest: WideString; Source: PWideChar; Length: Integer);
asm
        PUSH    EDI
        PUSH    EAX
        PUSH    ECX
        MOV     EDI,EDX
        XOR     EAX,EAX
        REPNE   SCASW
        JNE     @@1
        NOT     ECX
@@1:    POP     EAX
        ADD     ECX,EAX
        POP     EAX
        POP     EDI
        JMP     _WStrFromPWCharLen
end;


procedure _WStrFromLStr(var Dest: WideString; const Source: AnsiString);
asm
        XOR     ECX,ECX
        TEST    EDX,EDX
        JE      @@1
        MOV     ECX,[EDX-4]
@@1:    JMP     _WStrFromPCharLen
end;


procedure _WStrToString(Dest: PShortString; const Source: WideString; MaxLen: Integer);
var
  SourceLen, DestLen: Integer;
  Buffer: array[0..511] of Char;
begin
  if MaxLen > 255 then MaxLen := 255;
  SourceLen := Length(Source);
  if SourceLen >= MaxLen then SourceLen := MaxLen;
  if SourceLen = 0 then
    DestLen := 0
  else
  begin
    DestLen := CharFromWChar(Buffer, High(Buffer), PWideChar(Pointer(Source)), SourceLen);
    if DestLen < 0 then
      DestLen := 0
    else if DestLen > MaxLen then
      DestLen := MaxLen;
  end;
  Dest^[0] := Chr(DestLen);
  if DestLen > 0 then Move(Buffer, Dest^[1], DestLen);
end;

function _WStrToPWChar(const S: WideString): PWideChar;
{$IFDEF PUREPASCAL}
const
  EmptyString = '';
begin
  if Pointer(S) = nil then
    Result := EmptyString
  else
    Result := Pointer(S);
end;
{$ELSE}
asm
        TEST    EAX,EAX
        JE      @@1
        RET
{$IFDEF PIC}
@@1:    JMP     PICEmptyString
{$ELSE}
        NOP
@@0:    DW      0
@@1:    MOV     EAX,OFFSET @@0
{$ENDIF}
end;
{$ENDIF}


function _WStrLen(const S: WideString): Integer;
{$IFDEF PUREPASCAL}
begin
  if Pointer(S) = nil then
    Result := 0
  else
    Result := PInteger(Integer(S) - 4)^ div sizeof(WideChar);
end;
{$ELSE}
asm
    { ->    EAX     Pointer to WideString data }
    TEST    EAX,EAX
    JE      @@1
    MOV     EAX,[EAX-4]
    SHR     EAX,1
@@1:
end;
{$ENDIF}

procedure _WStrCat(var Dest: WideString; const Source: WideString);
var
  DestLen, SourceLen: Integer;
  NewStr: PWideChar;
begin
  SourceLen := Length(Source);
  if SourceLen <> 0 then
  begin
    DestLen := Length(Dest);
    NewStr := _NewWideString(DestLen + SourceLen);
    if DestLen > 0 then
      Move(Pointer(Dest)^, NewStr^, DestLen * sizeof(WideChar));
    Move(Pointer(Source)^, NewStr[DestLen], SourceLen * sizeof(WideChar));
    WStrSet(Dest, NewStr);
  end;
end;


procedure _WStrCat3(var Dest: WideString; const Source1, Source2: WideString);
var
  Source1Len, Source2Len: Integer;
  NewStr: PWideChar;
begin
  Source1Len := Length(Source1);
  Source2Len := Length(Source2);
  if (Source1Len <> 0) or (Source2Len <> 0) then
  begin
    NewStr := _NewWideString(Source1Len + Source2Len);
    Move(Pointer(Source1)^, Pointer(NewStr)^, Source1Len * sizeof(WideChar));
    Move(Pointer(Source2)^, NewStr[Source1Len], Source2Len * sizeof(WideChar));
    WStrSet(Dest, NewStr);
  end;
end;


procedure _WStrCatN{var Dest: WideString; ArgCnt: Integer; ...};
asm
        {     ->EAX = Pointer to dest }
        {       EDX = number of args (>= 3) }
        {       [ESP+4], [ESP+8], ... crgCnt WideString arguments }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDX
        PUSH    EAX
        MOV     EBX,EDX

        XOR     EAX,EAX
@@loop1:
        MOV     ECX,[ESP+EDX*4+4*4]
        TEST    ECX,ECX
        JE      @@1
        ADD     EAX,[ECX-4]
@@1:
        DEC     EDX
        JNE     @@loop1

        SHR     EAX,1
        CALL    _NewWideString
        PUSH    EAX
        MOV     ESI,EAX

@@loop2:
        MOV     EAX,[ESP+EBX*4+5*4]
        MOV     EDX,ESI
        TEST    EAX,EAX
        JE      @@2
        MOV     ECX,[EAX-4]
        ADD     ESI,ECX
        CALL    Move
@@2:
        DEC     EBX
        JNE     @@loop2

        POP     EDX
        POP     EAX
        CALL    WStrSet

        POP     EDX
        POP     ESI
        POP     EBX
        POP     EAX
        LEA     ESP,[ESP+EDX*4]
        JMP     EAX
end;


procedure _WStrCmp{left: WideString; right: WideString};
asm
{     ->EAX = Pointer to left string    }
{       EDX = Pointer to right string   }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        CMP     EAX,EDX
        JE      @@exit

        TEST    ESI,ESI
        JE      @@str1null

        TEST    EDI,EDI
        JE      @@str2null

        MOV     EAX,[ESI-4]
        MOV     EDX,[EDI-4]

        SUB     EAX,EDX { eax = len1 - len2 }
        JA      @@skip1
        ADD     EDX,EAX { edx = len2 + (len1 - len2) = len1     }

@@skip1:
        PUSH    EDX
        SHR     EDX,2
        JE      @@cmpRest
@@longLoop:
        MOV     ECX,[ESI]
        MOV     EBX,[EDI]
        CMP     ECX,EBX
        JNE     @@misMatch
        DEC     EDX
        JE      @@cmpRestP4
        MOV     ECX,[ESI+4]
        MOV     EBX,[EDI+4]
        CMP     ECX,EBX
        JNE     @@misMatch
        ADD     ESI,8
        ADD     EDI,8
        DEC     EDX
        JNE     @@longLoop
        JMP     @@cmpRest
@@cmpRestP4:
        ADD     ESI,4
        ADD     EDI,4
@@cmpRest:
        POP     EDX
        AND     EDX,2
        JE      @@equal

        MOV     CX,[ESI]
        MOV     BX,[EDI]
        CMP     CX,BX
        JNE     @@exit

@@equal:
        ADD     EAX,EAX
        JMP     @@exit

@@str1null:
        MOV     EDX,[EDI-4]
        SUB     EAX,EDX
        JMP     @@exit

@@str2null:
        MOV     EAX,[ESI-4]
        SUB     EAX,EDX
        JMP     @@exit

@@misMatch:
        POP     EDX
        CMP     CX,BX
        JNE     @@exit
        SHR     ECX,16
        SHR     EBX,16
        CMP     CX,BX

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;


function _WStrCopy(const S: WideString; Index, Count: Integer): WideString;
var
  L, N: Integer;
begin
  L := Length(S);
  if Index < 1 then Index := 0 else
  begin
    Dec(Index);
    if Index > L then Index := L;
  end;
  if Count < 0 then N := 0 else
  begin
    N := L - Index;
    if N > Count then N := Count;
  end;
  _WStrFromPWCharLen(Result, PWideChar(Pointer(S)) + Index, N);
end;


procedure _WStrDelete(var S: WideString; Index, Count: Integer);
var
  L, N: Integer;
  NewStr: PWideChar;
begin
  L := Length(S);
  if (L > 0) and (Index >= 1) and (Index <= L) and (Count > 0) then
  begin
    Dec(Index);
    N := L - Index - Count;
    if N < 0 then N := 0;
    if (Index = 0) and (N = 0) then NewStr := nil else
    begin
      NewStr := _NewWideString(Index + N);
      if Index > 0 then
        Move(Pointer(S)^, NewStr^, Index * 2);
      if N > 0 then
        Move(PWideChar(Pointer(S))[L - N], NewStr[Index], N * 2);
    end;
    WStrSet(S, NewStr);
  end;
end;


procedure _WStrInsert(const Source: WideString; var Dest: WideString; Index: Integer);
var
  SourceLen, DestLen: Integer;
  NewStr: PWideChar;
begin
  SourceLen := Length(Source);
  if SourceLen > 0 then
  begin
    DestLen := Length(Dest);
    if Index < 1 then Index := 0 else
    begin
      Dec(Index);
      if Index > DestLen then Index := DestLen;
    end;
    NewStr := _NewWideString(DestLen + SourceLen);
    if Index > 0 then
      Move(Pointer(Dest)^, NewStr^, Index * 2);
    Move(Pointer(Source)^, NewStr[Index], SourceLen * 2);
    if Index < DestLen then
      Move(PWideChar(Pointer(Dest))[Index], NewStr[Index + SourceLen],
        (DestLen - Index) * 2);
    WStrSet(Dest, NewStr);
  end;
end;


procedure _WStrPos{ const substr : WideString; const s : WideString ) : Integer};
asm
{     ->EAX     Pointer to substr               }
{       EDX     Pointer to string               }
{     <-EAX     Position of substr in s or 0    }

        TEST    EAX,EAX
        JE      @@noWork

        TEST    EDX,EDX
        JE      @@stringEmpty

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX                         { Point ESI to substr           }
        MOV     EDI,EDX                         { Point EDI to s                }

        MOV     ECX,[EDI-4]                     { ECX = Length(s)               }
        SHR     ECX,1

        PUSH    EDI                             { remember s position to calculate index        }

        MOV     EDX,[ESI-4]                     { EDX = Length(substr)          }
        SHR     EDX,1

        DEC     EDX                             { EDX = Length(substr) - 1              }
        JS      @@fail                          { < 0 ? return 0                        }
        MOV     AX,[ESI]                        { AL = first char of substr             }
        ADD     ESI,2                           { Point ESI to 2'nd char of substr      }

        SUB     ECX,EDX                         { #positions in s to look at    }
                                                { = Length(s) - Length(substr) + 1      }
        JLE     @@fail
@@loop:
        REPNE   SCASW
        JNE     @@fail
        MOV     EBX,ECX                         { save outer loop counter               }
        PUSH    ESI                             { save outer loop substr pointer        }
        PUSH    EDI                             { save outer loop s pointer             }

        MOV     ECX,EDX
        REPE    CMPSW
        POP     EDI                             { restore outer loop s pointer  }
        POP     ESI                             { restore outer loop substr pointer     }
        JE      @@found
        MOV     ECX,EBX                         { restore outer loop counter    }
        JMP     @@loop

@@fail:
        POP     EDX                             { get rid of saved s pointer    }
        XOR     EAX,EAX
        JMP     @@exit

@@stringEmpty:
        XOR     EAX,EAX
        JMP     @@noWork

@@found:
        POP     EDX                             { restore pointer to first char of s    }
        MOV     EAX,EDI                         { EDI points of char after match        }
        SUB     EAX,EDX                         { the difference is the correct index   }
        SHR     EAX,1
@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
@@noWork:
end;


procedure _WStrSetLength(var S: WideString; NewLength: Integer);
var
  NewStr: PWideChar;
  Count: Integer;
begin
  NewStr := nil;
  if NewLength > 0 then
  begin
    NewStr := _NewWideString(NewLength);
    Count := Length(S);
    if Count > 0 then
    begin
      if Count > NewLength then Count := NewLength;
      Move(Pointer(S)^, NewStr^, Count * 2);
    end;
  end;
  WStrSet(S, NewStr);
end;


function _WStrOfWChar(Ch: WideChar; Count: Integer): WideString;
var
  P: PWideChar;
begin
  _WStrFromPWCharLen(Result, nil, Count);
  P := Pointer(Result);
  while Count > 0 do
  begin
    Dec(Count);
    P[Count] := Ch;
  end;
end;

procedure WStrAddRef;
asm
        JMP _WStrAddRef
end;

function _WStrAddRef(var str: WideString): Pointer;
{$IFDEF LINUX}
asm
        JMP     _LStrAddRef
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
asm
        MOV     EDX,[EAX]
        TEST    EDX,EDX
        JE      @@1
        PUSH    EAX
        MOV     ECX,[EDX-4]
        SHR     ECX,1
        PUSH    ECX
        PUSH    EDX
        CALL    SysAllocStringLen
        POP     EDX
        TEST    EAX,EAX
        JE      WStrError
        MOV     [EDX],EAX
@@1:
end;
{$ENDIF}

type
  PPTypeInfo = ^PTypeInfo;
  PTypeInfo = ^TTypeInfo;
  TTypeInfo = packed record
    Kind: Byte;
    Name: ShortString;
   {TypeData: TTypeData}
  end;

  TFieldInfo = packed record
    TypeInfo: PPTypeInfo;
    Offset: Cardinal;
  end;

  PFieldTable = ^TFieldTable;
  TFieldTable = packed record
    X: Word;
    Size: Cardinal;
    Count: Cardinal;
    Fields: array [0..0] of TFieldInfo;
  end;

{ ===========================================================================
  InitializeRecord, InitializeArray, and Initialize are PIC safe even though
  they alter EBX because they only call each other.  They never call out to
  other functions and they don't access global data.

  FinalizeRecord, Finalize, and FinalizeArray are PIC safe because they call
  Pascal routines which will have EBX fixup prologs.
  ===========================================================================}

procedure   _InitializeRecord(p: Pointer; typeInfo: Pointer);
{$IFDEF PUREPASCAL}
var
  FT: PFieldTable;
  I: Cardinal;
begin
  FT := PFieldTable(Integer(typeInfo) + Byte(PTypeInfo(typeInfo).Name[0]));
  for I := FT.Count-1 downto 0 do
    _InitializeArray(Pointer(Cardinal(P) + FT.Fields[I].Offset), FT.Fields[I].TypeInfo^, 1);
end;
{$ELSE}
asm
        { ->    EAX pointer to record to be initialized }
        {       EDX pointer to type info                }

        XOR     ECX,ECX

        PUSH    EBX
        MOV     CL,[EDX+1]                  { type name length }

        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EAX                     // PIC safe. See comment above
        LEA     ESI,[EDX+ECX+2+8]           { address of destructable fields }
        MOV     EDI,[EDX+ECX+2+4]           { number of destructable fields }

@@loop:

        MOV     EDX,[ESI]
        MOV     EAX,[ESI+4]
        ADD     EAX,EBX
        MOV     EDX,[EDX]
        MOV     ECX,1
        CALL    _InitializeArray
        ADD     ESI,8
        DEC     EDI
        JG      @@loop

        POP     EDI
        POP     ESI
        POP     EBX
end;
{$ENDIF}


const
  tkLString   = 10;
  tkWString   = 11;
  tkVariant   = 12;
  tkArray     = 13;
  tkRecord    = 14;
  tkInterface = 15;
  tkDynArray  = 17;

procedure       _InitializeArray(p: Pointer; typeInfo: Pointer; elemCount: Cardinal);
{$IFDEF PUREPASCAL}
var
  FT: PFieldTable;
begin
  if elemCount = 0 then Exit;
  case PTypeInfo(typeInfo).Kind of
    tkLString, tkWString, tkInterface, tkDynArray:
      while elemCount > 0 do
      begin
        PInteger(P)^ := 0;
        Inc(Integer(P), 4);
        Dec(elemCount);
      end;
    tkVariant:
      while elemCount > 0 do
      begin
        PInteger(P)^ := 0;
        PInteger(Integer(P)+4)^ := 0;
        PInteger(Integer(P)+8)^ := 0;
        PInteger(Integer(P)+12)^ := 0;
        Inc(Integer(P), sizeof(Variant));
        Dec(elemCount);
      end;
    tkArray:
      begin
        FT := PFieldTable(Integer(typeInfo) + Byte(PTypeInfo(typeInfo).Name[0]));
        while elemCount > 0 do
        begin
          _InitializeArray(P, FT.Fields[0].TypeInfo^, FT.Count);
          Inc(Integer(P), FT.Size);
          Dec(elemCount);
        end;
      end;
    tkRecord:
      begin
        FT := PFieldTable(Integer(typeInfo) + Byte(PTypeInfo(typeInfo).Name[0]));
        while elemCount > 0 do
        begin
          _InitializeRecord(P, typeInfo);
          Inc(Integer(P), FT.Size);
          Dec(elemCount);
        end;
      end;
  else
    Error(reInvalidPtr);
  end;
end;
{$ELSE}
asm
        { ->    EAX     pointer to data to be initialized       }
        {       EDX     pointer to type info describing data    }
        {       ECX number of elements of that type             }

        TEST    ECX, ECX
        JZ      @@zerolength

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX             // PIC safe.  See comment above
        MOV     ESI,EDX
        MOV     EDI,ECX

        XOR     EDX,EDX
        MOV     AL,[ESI]
        MOV     DL,[ESI+1]
        XOR     ECX,ECX

        CMP     AL,tkLString
        JE      @@LString
        CMP     AL,tkWString
        JE      @@WString
        CMP     AL,tkVariant
        JE      @@Variant
        CMP     AL,tkArray
        JE      @@Array
        CMP     AL,tkRecord
        JE      @@Record
        CMP     AL,tkInterface
        JE      @@Interface
        CMP     AL,tkDynArray
        JE      @@DynArray
        MOV     AL,reInvalidPtr
        POP     EDI
        POP     ESI
        POP     EBX
        JMP     Error

@@LString:
@@WString:
@@Interface:
@@DynArray:
        MOV     [EBX],ECX
        ADD     EBX,4
        DEC     EDI
        JG      @@LString
        JMP     @@exit

@@Variant:
        MOV     [EBX   ],ECX
        MOV     [EBX+ 4],ECX
        MOV     [EBX+ 8],ECX
        MOV     [EBX+12],ECX
        ADD     EBX,16
        DEC     EDI
        JG      @@Variant
        JMP     @@exit

@@Array:
        PUSH    EBP
        MOV     EBP,EDX
@@ArrayLoop:
        MOV     EDX,[ESI+EBP+2+8]    // address of destructable fields typeinfo
        MOV     EAX,EBX
        ADD     EBX,[ESI+EBP+2]      // size in bytes of the array data
        MOV     ECX,[ESI+EBP+2+4]    // number of destructable fields
        MOV     EDX,[EDX]
        CALL    _InitializeArray
        DEC     EDI
        JG      @@ArrayLoop
        POP     EBP
        JMP     @@exit

@@Record:
        PUSH    EBP
        MOV     EBP,EDX
@@RecordLoop:
        MOV     EAX,EBX
        ADD     EBX,[ESI+EBP+2]
        MOV     EDX,ESI
        CALL    _InitializeRecord
        DEC     EDI
        JG      @@RecordLoop
        POP     EBP

@@exit:

        POP     EDI
        POP     ESI
        POP     EBX
@@zerolength:
end;
{$ENDIF}

procedure       _Initialize(p: Pointer; typeInfo: Pointer);
{$IFDEF PUREPASCAL}
begin
  _InitializeArray(p, typeInfo, 1);
end;
{$ELSE}
asm
        MOV     ECX,1
        JMP     _InitializeArray
end;
{$ENDIF}

procedure _FinalizeRecord(p: Pointer; typeInfo: Pointer);
{$IFDEF PUREPASCAL}
var
  FT: PFieldTable;
  I: Cardinal;
begin
  FT := PFieldTable(Integer(typeInfo) + Byte(PTypeInfo(typeInfo).Name[0]));
  for I := 0 to FT.Count-1 do
    _FinalizeArray(Pointer(Cardinal(P) + FT.Fields[I].Offset), FT.Fields[I].TypeInfo^, 1);
end;
{$ELSE}
asm
        { ->    EAX pointer to record to be finalized   }
        {       EDX pointer to type info                }

        XOR     ECX,ECX

        PUSH    EBX
        MOV     CL,[EDX+1]

        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EAX
        LEA     ESI,[EDX+ECX+2+8]
        MOV     EDI,[EDX+ECX+2+4]

@@loop:

        MOV     EDX,[ESI]
        MOV     EAX,[ESI+4]
        ADD     EAX,EBX
        MOV     EDX,[EDX]
        MOV     ECX,1
        CALL    _FinalizeArray
        ADD     ESI,8
        DEC     EDI
        JG      @@loop

        MOV     EAX,EBX

        POP     EDI
        POP     ESI
        POP     EBX
end;
{$ENDIF}

procedure _FinalizeArray(p: Pointer; typeInfo: Pointer; elemCount: Cardinal);
{$IFDEF PUREPASCAL}
var
  FT: PFieldTable;
begin
  if elemCount = 0 then Exit;
  case PTypeInfo(typeInfo).Kind of
    tkLString: _LStrArrayClr(P^, elemCount);
    tkWString: {X-_WStrArrayClr X+}WStrArrayClrProc(P^, elemCount);
    tkVariant:
      while elemCount > 0 do
      begin
        VarClrProc(P);
        Inc(Integer(P), sizeof(Variant));
        Dec(elemCount);
      end;
    tkArray:
      begin
        FT := PFieldTable(Integer(typeInfo) + Byte(PTypeInfo(typeInfo).Name[0]));
        while elemCount > 0 do
        begin
          _FinalizeArray(P, FT.Fields[0].TypeInfo^, FT.Count);
          Inc(Integer(P), FT.Size);
          Dec(elemCount);
        end;
      end;
    tkRecord:
      begin
        FT := PFieldTable(Integer(typeInfo) + Byte(PTypeInfo(typeInfo).Name[0]));
        while elemCount > 0 do
        begin
          _FinalizeRecord(P, typeInfo);
          Inc(Integer(P), FT.Size);
          Dec(elemCount);
        end;
      end;
    tkInterface:
      while elemCount > 0 do
      begin
        _IntfClear(IInterface(P^));
        Inc(Integer(P), 4);
        Dec(elemCount);
      end;
    tkDynArray:
      while elemCount > 0 do
      begin
        _DynArrayClr(P);
        Inc(Integer(P), 4);
        Dec(elemCount);
      end;
  else
    Error(reInvalidPtr);
  end;
end;
{$ELSE}
asm
        { ->    EAX     pointer to data to be finalized         }
        {       EDX     pointer to type info describing data    }
        {       ECX number of elements of that type             }

        { This code appears to be PIC safe.  The functions called from
          here either don't make external calls or call Pascal
          routines that will fix up EBX in their prolog code
          (FreeMem, VarClr, IntfClr).  }

        CMP     ECX, 0                        { no array -> nop }
        JE      @@zerolength

        PUSH    EAX
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

        XOR     EDX,EDX
        MOV     AL,[ESI]
        MOV     DL,[ESI+1]

        CMP     AL,tkLString
        JE      @@LString

        CMP     AL,tkWString
        JE      @@WString

        CMP     AL,tkVariant
        JE      @@Variant

        CMP     AL,tkArray
        JE      @@Array

        CMP     AL,tkRecord
        JE      @@Record

        CMP     AL,tkInterface
        JE      @@Interface

        CMP     AL,tkDynArray
        JE      @@DynArray

        JMP     @@error

@@LString:
        CMP     ECX,1
        MOV     EAX,EBX
        JG      @@LStringArray
        CALL    _LStrClr
        JMP     @@exit
@@LStringArray:
        MOV     EDX,ECX
        CALL    _LStrArrayClr
        JMP     @@exit

@@WString:
        CMP     ECX,1
        MOV     EAX,EBX
        JG      @@WStringArray
        //CALL    _WStrClr     {X}
        CALL    [WStrClrProc]  {X}
        JMP     @@exit
@@WStringArray:
        MOV     EDX,ECX
        //CALL    _WStrArrayClr       {X}
        CALL    [WStrArrayClrProc]    {X}
        JMP     @@exit
@@Variant:
        MOV     EAX,EBX
        ADD     EBX,16
        CALL    _VarClr
        DEC     EDI
        JG      @@Variant
        JMP     @@exit
@@Array:
        PUSH    EBP
        MOV     EBP,EDX
@@ArrayLoop:
        MOV     EDX,[ESI+EBP+2+8]
        MOV     EAX,EBX
        ADD     EBX,[ESI+EBP+2]
        MOV     ECX,[ESI+EBP+2+4]
        MOV     EDX,[EDX]
        CALL    _FinalizeArray
        DEC     EDI
        JG      @@ArrayLoop
        POP     EBP
        JMP     @@exit

@@Record:
        PUSH    EBP
        MOV     EBP,EDX
@@RecordLoop:
        { inv: EDI = number of array elements to finalize }

        MOV     EAX,EBX
        ADD     EBX,[ESI+EBP+2]
        MOV     EDX,ESI
        CALL    _FinalizeRecord
        DEC     EDI
        JG      @@RecordLoop
        POP     EBP
        JMP     @@exit

@@Interface:
        MOV     EAX,EBX
        ADD     EBX,4
        CALL    _IntfClear
        DEC     EDI
        JG      @@Interface
        JMP     @@exit

@@DynArray:
        MOV     EAX,EBX
        MOV     EDX,ESI
        ADD     EBX,4
        CALL    _DynArrayClear
        DEC     EDI
        JG      @@DynArray
        JMP     @@exit

@@error:
        POP     EDI
        POP     ESI
        POP     EBX
        POP     EAX
        MOV     AL,reInvalidPtr
        JMP     Error

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
        POP     EAX
@@zerolength:
end;
{$ENDIF}

procedure _Finalize(p: Pointer; typeInfo: Pointer);
{$IFDEF PUREPASCAL}
begin
  _FinalizeArray(p, typeInfo, 1);
end;
{$ELSE}
asm
        MOV     ECX,1
        JMP     _FinalizeArray
end;
{$ENDIF}

procedure       _AddRefRecord{ p: Pointer; typeInfo: Pointer };
asm
        { ->    EAX pointer to record to be referenced  }
        {       EDX pointer to type info        }

        XOR     ECX,ECX

        PUSH    EBX
        MOV     CL,[EDX+1]

        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EAX
        LEA     ESI,[EDX+ECX+2+8]
        MOV     EDI,[EDX+ECX+2+4]

@@loop:

        MOV     EDX,[ESI]
        MOV     EAX,[ESI+4]
        ADD     EAX,EBX
        MOV     EDX,[EDX]
        MOV     ECX, 1
        CALL    _AddRefArray
        ADD     ESI,8
        DEC     EDI
        JG      @@loop

        POP     EDI
        POP     ESI
        POP     EBX
end;


{X}procedure DummyProc;
{X}begin
{X}end;

procedure       _AddRefArray{ p: Pointer; typeInfo: Pointer; elemCount: Longint};
asm
        { ->    EAX     pointer to data to be referenced        }
        {       EDX     pointer to type info describing data    }
        {       ECX number of elements of that type             }

        { This code appears to be PIC safe.  The functions called from
          here either don't make external calls (LStrAddRef, WStrAddRef) or
          are Pascal routines that will fix up EBX in their prolog code
          (VarAddRef, IntfAddRef).  }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        TEST  ECX,ECX
        JZ    @@exit

        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

        XOR     EDX,EDX
        MOV     AL,[ESI]
        MOV     DL,[ESI+1]

        CMP     AL,tkLString
        JE      @@LString
        CMP     AL,tkWString
        JE      @@WString
        CMP     AL,tkVariant
        JE      @@Variant
        CMP     AL,tkArray
        JE      @@Array
        CMP     AL,tkRecord
        JE      @@Record
        CMP     AL,tkInterface
        JE      @@Interface
        CMP     AL,tkDynArray
        JE      @@DynArray
        MOV     AL,reInvalidPtr
        POP     EDI
        POP     ESI
        POP     EBX
        JMP     Error

@@LString:
        MOV     EAX,[EBX]
        ADD     EBX,4
        CALL    _LStrAddRef
        DEC     EDI
        JG      @@LString
        JMP     @@exit

@@WString:
        MOV     EAX,EBX
        ADD     EBX,4
        //CALL    _WStrAddRef
        CALL    [WStrAddRefProc]
        DEC     EDI
        JG      @@WString
        JMP     @@exit
@@Variant:
        MOV     EAX,EBX
        ADD     EBX,16
        CALL    _VarAddRef
        DEC     EDI
        JG      @@Variant
        JMP     @@exit

@@Array:
        PUSH    EBP
        MOV     EBP,EDX
@@ArrayLoop:
        MOV     EDX,[ESI+EBP+2+8]
        MOV     EAX,EBX
        ADD     EBX,[ESI+EBP+2]
        MOV     ECX,[ESI+EBP+2+4]
        MOV     EDX,[EDX]
        CALL    _AddRefArray
        DEC     EDI
        JG      @@ArrayLoop
        POP     EBP
        JMP     @@exit

@@Record:
        PUSH    EBP
        MOV     EBP,EDX
@@RecordLoop:
        MOV     EAX,EBX
        ADD     EBX,[ESI+EBP+2]
        MOV     EDX,ESI
        CALL    _AddRefRecord
        DEC     EDI
        JG      @@RecordLoop
        POP     EBP
        JMP     @@exit

@@Interface:
        MOV     EAX,[EBX]
        ADD     EBX,4
        CALL    _IntfAddRef
        DEC     EDI
        JG      @@Interface
        JMP     @@exit

@@DynArray:
        MOV     EAX,[EBX]
        ADD     EBX,4
        CALL    _DynArrayAddRef
        DEC     EDI
        JG      @@DynArray
@@exit:

        POP     EDI
        POP     ESI
        POP     EBX
end;


procedure       _AddRef{ p: Pointer; typeInfo: Pointer};
asm
        MOV     ECX,1
        JMP     _AddRefArray
end;


procedure       _CopyRecord{ dest, source, typeInfo: Pointer };
asm
        { ->    EAX pointer to dest             }
        {       EDX pointer to source           }
        {       ECX pointer to typeInfo         }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     EBX,EAX
        MOV     ESI,EDX

        XOR     EAX,EAX
        MOV     AL,[ECX+1]

        LEA     EDI,[ECX+EAX+2+8]
        MOV     EBP,[EDI-4]
        XOR     EAX,EAX
        MOV     ECX,[EDI-8]
        PUSH    ECX
@@loop:
        MOV     ECX,[EDI+4]
        SUB     ECX,EAX
        JLE     @@nomove1
        MOV     EDX,EAX
        ADD     EAX,ESI
        ADD     EDX,EBX
        CALL    Move
@@noMove1:
        MOV     EAX,[EDI+4]

        MOV     EDX,[EDI]
        MOV     EDX,[EDX]
        MOV     CL,[EDX]

        CMP     CL,tkLString
        JE      @@LString
        CMP     CL,tkWString
        JE      @@WString
        CMP     CL,tkVariant
        JE      @@Variant
        CMP     CL,tkArray
        JE      @@Array
        CMP     CL,tkRecord
        JE      @@Record
        CMP     CL,tkInterface
        JE      @@Interface
        CMP     CL,tkDynArray
        JE      @@DynArray
        MOV     AL,reInvalidPtr
        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
        JMP     Error

@@LString:
        MOV     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _LStrAsg
        MOV     EAX,4
        JMP     @@common

@@WString:
        MOV     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _WStrAsg
        MOV     EAX,4
        JMP     @@common

@@Variant:
        LEA     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _VarCopy
        MOV     EAX,16
        JMP     @@common

@@Array:
        XOR     ECX,ECX
        MOV     CL,[EDX+1]
        PUSH    dword ptr [EDX+ECX+2]
        PUSH    dword ptr [EDX+ECX+2+4]
        MOV     ECX,[EDX+ECX+2+8]
        MOV     ECX,[ECX]
        LEA     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _CopyArray
        POP     EAX
        JMP     @@common

@@Record:
        XOR     ECX,ECX
        MOV     CL,[EDX+1]
        MOV     ECX,[EDX+ECX+2]
        PUSH    ECX
        MOV     ECX,EDX
        LEA     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _CopyRecord
        POP     EAX
        JMP     @@common

@@Interface:
        MOV     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _IntfCopy
        MOV     EAX,4
        JMP     @@common

@@DynArray:
        MOV     ECX,EDX
        MOV     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _DynArrayAsg
        MOV     EAX,4

@@common:
        ADD     EAX,[EDI+4]
        ADD     EDI,8
        DEC     EBP
        JNZ     @@loop

        POP     ECX
        SUB     ECX,EAX
        JLE     @@noMove2
        LEA     EDX,[EBX+EAX]
        ADD     EAX,ESI
        CALL    Move
@@noMove2:

        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
end;


procedure       _CopyObject{ dest, source: Pointer; vmtPtrOffs: Longint; typeInfo: Pointer };
asm
        { ->    EAX pointer to dest             }
        {       EDX pointer to source           }
        {       ECX offset of vmt in object     }
        {       [ESP+4] pointer to typeInfo     }

        ADD     ECX,EAX                         { pointer to dest vmt }
        PUSH    dword ptr [ECX]                 { save dest vmt }
        PUSH    ECX
        MOV     ECX,[ESP+4+4+4]
        CALL    _CopyRecord
        POP     ECX
        POP     dword ptr [ECX]                 { restore dest vmt }
        RET     4

end;

procedure       _CopyArray{ dest, source, typeInfo: Pointer; cnt: Integer };
asm
        { ->    EAX pointer to dest             }
        {       EDX pointer to source           }
        {       ECX pointer to typeInfo         }
        {       [ESP+4] count                   }
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX
        MOV     EBP,[ESP+4+4*4]

        MOV     CL,[EDI]

        CMP     CL,tkLString
        JE      @@LString
        CMP     CL,tkWString
        JE      @@WString
        CMP     CL,tkVariant
        JE      @@Variant
        CMP     CL,tkArray
        JE      @@Array
        CMP     CL,tkRecord
        JE      @@Record
        CMP     CL,tkInterface
        JE      @@Interface
        CMP     CL,tkDynArray
        JE      @@DynArray
        MOV     AL,reInvalidPtr
        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
        JMP     Error

@@LString:
        MOV     EAX,EBX
        MOV     EDX,[ESI]
        CALL    _LStrAsg
        ADD     EBX,4
        ADD     ESI,4
        DEC     EBP
        JNE     @@LString
        JMP     @@exit

@@WString:
        MOV     EAX,EBX
        MOV     EDX,[ESI]
        CALL    _WStrAsg
        ADD     EBX,4
        ADD     ESI,4
        DEC     EBP
        JNE     @@WString
        JMP     @@exit

@@Variant:
        MOV     EAX,EBX
        MOV     EDX,ESI
        CALL    _VarCopy
        ADD     EBX,16
        ADD     ESI,16
        DEC     EBP
        JNE     @@Variant
        JMP     @@exit

@@Array:
        XOR     ECX,ECX
        MOV     CL,[EDI+1]
        LEA     EDI,[EDI+ECX+2]
@@ArrayLoop:
        MOV     EAX,EBX
        MOV     EDX,ESI
        MOV     ECX,[EDI+8]
        PUSH    dword ptr [EDI+4]
        CALL    _CopyArray
        ADD     EBX,[EDI]
        ADD     ESI,[EDI]
        DEC     EBP
        JNE     @@ArrayLoop
        JMP     @@exit

@@Record:
        MOV     EAX,EBX
        MOV     EDX,ESI
        MOV     ECX,EDI
        CALL    _CopyRecord
        XOR     EAX,EAX
        MOV     AL,[EDI+1]
        ADD     EBX,[EDI+EAX+2]
        ADD     ESI,[EDI+EAX+2]
        DEC     EBP
        JNE     @@Record
        JMP     @@exit

@@Interface:
        MOV     EAX,EBX
        MOV     EDX,[ESI]
        CALL    _IntfCopy
        ADD     EBX,4
        ADD     ESI,4
        DEC     EBP
        JNE     @@Interface
        JMP     @@exit

@@DynArray:
        MOV     EAX,EBX
        MOV     EDX,[ESI]
        MOV     ECX,EDI
        CALL    _DynArrayAsg
        ADD     EBX,4
        ADD     ESI,4
        DEC     EBP
        JNE     @@DynArray

@@exit:
        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
        RET     4
end;


function _New(size: Longint; typeInfo: Pointer): Pointer;
{$IFDEF PUREPASCAL}
begin
  GetMem(Result, size);
  if Result <> nil then
    _Initialize(Result, typeInfo);
end;
{$ELSE}
asm
        { ->    EAX size of object to allocate  }
        {       EDX pointer to typeInfo         }

        PUSH    EDX
        CALL    _GetMem
        POP     EDX
        TEST    EAX,EAX
        JE      @@exit
        PUSH    EAX
        CALL    _Initialize
        POP     EAX
@@exit:
end;
{$ENDIF}

procedure _Dispose(p: Pointer; typeInfo: Pointer);
{$IFDEF PUREPASCAL}
begin
  _Finalize(p, typeinfo);
  FreeMem(p);
end;
{$ELSE}
asm
        { ->    EAX     Pointer to object to be disposed        }
        {       EDX     Pointer to type info            }

        PUSH    EAX
        CALL    _Finalize
        POP     EAX
        CALL    _FreeMem
end;
{$ENDIF}

{ ----------------------------------------------------- }
{       Wide character support                          }
{ ----------------------------------------------------- }

function WideCharToString(Source: PWideChar): string;
begin
  WideCharToStrVar(Source, Result);
end;

function WideCharLenToString(Source: PWideChar; SourceLen: Integer): string;
begin
  WideCharLenToStrVar(Source, SourceLen, Result);
end;

procedure WideCharToStrVar(Source: PWideChar; var Dest: string);
begin
  _LStrFromPWChar(Dest, Source);
end;

procedure WideCharLenToStrVar(Source: PWideChar; SourceLen: Integer;
  var Dest: string);
begin
  _LStrFromPWCharLen(Dest, Source, SourceLen);
end;

function StringToWideChar(const Source: string; Dest: PWideChar;
  DestSize: Integer): PWideChar;
begin
  Dest[WCharFromChar(Dest, DestSize - 1, PChar(Source), Length(Source))] := #0;
  Result := Dest;
end;

{ ----------------------------------------------------- }
{       OLE string support                              }
{ ----------------------------------------------------- }

function OleStrToString(Source: PWideChar): string;
begin
  OleStrToStrVar(Source, Result);
end;

procedure OleStrToStrVar(Source: PWideChar; var Dest: string);
begin
  WideCharLenToStrVar(Source, Length(WideString(Pointer(Source))), Dest);
end;

function StringToOleStr(const Source: string): PWideChar;
begin
  Result := nil;
  _WStrFromPCharLen(WideString(Pointer(Result)), PChar(Pointer(Source)), Length(Source));
end;

{ ----------------------------------------------------- }
{       Variant manager support                         }
{ ----------------------------------------------------- }

var
  VariantManager: TVariantManager;

procedure VariantSystemUndefinedError;
asm
        MOV     AL,reVarInvalidOp
        JMP     Error;
end;

procedure VariantSystemDefaultVarClear(var V: TVarData);
begin
  case V.VType of
    varEmpty, varNull, varError:;
  else
    VariantSystemUndefinedError;
  end;
end;

procedure InitVariantManager;
type
  TPtrArray = array [Word] of Pointer;
var
  P: ^TPtrArray;
  I: Integer;
begin
  P := @VariantManager;
  for I := 0 to (SizeOf(VariantManager) div SizeOf(Pointer))-1 do
    P[I] := @VariantSystemUndefinedError;
  VariantManager.VarClear := @VariantSystemDefaultVarClear;
end;

procedure GetVariantManager(var VarMgr: TVariantManager);
begin
  VarMgr := VariantManager;
end;

procedure SetVariantManager(const VarMgr: TVariantManager);
begin
  VariantManager := VarMgr;
end;

function IsVariantManagerSet: Boolean;
type
  TPtrArray = array [Word] of Pointer;
var
  P: ^TPtrArray;
  I: Integer;
begin
  Result := True;
  P := @VariantManager;
  for I := 0 to (SizeOf(VariantManager) div SizeOf(Pointer))-1 do
    if P[I] <> @VariantSystemUndefinedError then
    begin
      Result := False;
      Break;
    end;
end;

{ ----------------------------------------------------- }
{       Variant support                                 }
{ ----------------------------------------------------- }

procedure _DispInvoke;//(var Dest: Variant; const Source: Variant;
                     //CallDesc: PCallDesc; Params: Pointer); cdecl;
asm
{$IFDEF PIC}
        CALL    GetGOT
        LEA     EAX,[EAX].OFFSET VariantManager
        JMP     [EAX].TVariantManager.DispInvoke
{$ELSE}
        JMP     VariantManager.DispInvoke
{$ENDIF}
end;

procedure _VarClear(var V : Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarClear(V);
{$ELSE}
asm
        JMP     VariantManager.VarClear
{$IFEND}
end;

procedure _VarCopy(var Dest: Variant; const Source: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarCopy(Dest, Source);
{$ELSE}
asm
        JMP     VariantManager.VarCopy
{$IFEND}
end;

procedure _VarCast(var Dest: Variant; const Source: Variant; VarType: Integer);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarCast(Dest, Source, VarType);
{$ELSE}
asm
        JMP     VariantManager.VarCast
{$IFEND}
end;

procedure _VarCastOle(var Dest: Variant; const Source: Variant; VarType: Integer);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarCastOle(Dest, Source, VarType);
{$ELSE}
asm
        JMP     VariantManager.VarCastOle
{$IFEND}
end;

function _VarToInt(const V: Variant): Integer;
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  Result := VariantManager.VarToInt(V);
{$ELSE}
asm
        JMP     VariantManager.VarToInt
{$IFEND}
end;

function _VarToInt64(const V: Variant): Int64;
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  Result := VariantManager.VarToInt64(V);
{$ELSE}
asm
        JMP     VariantManager.VarToInt64
{$IFEND}
end;

function _VarToBool(const V: Variant): Boolean;
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  Result := VariantManager.VarToBool(V);
{$ELSE}
asm
        JMP     VariantManager.VarToBool
{$IFEND}
end;

function _VarToReal(const V: Variant): Extended;
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  Result := VariantManager.VarToReal(V);
{$ELSE}
asm
        JMP     VariantManager.VarToReal
{$IFEND}
end;

function _VarToCurr(const V: Variant): Currency;
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  Result := VariantManager.VarToCurr(V);
{$ELSE}
asm
        JMP     VariantManager.VarToCurr
{$IFEND}
end;

procedure _VarToPStr(var S; const V: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarToPStr(S, V);
{$ELSE}
asm
        JMP     VariantManager.VarToPStr
{$IFEND}
end;

procedure _VarToLStr(var S: string; const V: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarToLStr(S, V);
{$ELSE}
asm
        JMP     VariantManager.VarToLStr
{$IFEND}
end;

procedure _VarToWStr(var S: WideString; const V: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarToWStr(S, V);
{$ELSE}
asm
        JMP     VariantManager.VarToWStr
{$IFEND}
end;

procedure _VarToIntf(var Unknown: IInterface; const V: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarToIntf(Unknown, V);
{$ELSE}
asm
        JMP     VariantManager.VarToIntf
{$IFEND}
end;

procedure _VarToDisp(var Dispatch: IDispatch; const V: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarToDisp(Dispatch, V);
{$ELSE}
asm
        JMP     VariantManager.VarToDisp
{$IFEND}
end;

procedure _VarToDynArray(var DynArray: Pointer; const V: Variant; TypeInfo: Pointer);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarToDynArray(DynArray, V, TypeInfo);
{$ELSE}
asm
        JMP     VariantManager.VarToDynArray
{$IFEND}
end;

procedure _VarFromInt(var V: Variant; const Value, Range: Integer);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarFromInt(V, Value, Range);
{$ELSE}
asm
        JMP     VariantManager.VarFromInt
{$IFEND}
end;

procedure _VarFromInt64(var V: Variant; const Value: Int64);
begin
  VariantManager.VarFromInt64(V, Value);
end;

procedure _VarFromBool(var V: Variant; const Value: Boolean);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarFromBool(V, Value);
{$ELSE}
asm
        JMP     VariantManager.VarFromBool
{$IFEND}
end;

procedure _VarFromReal; // var V: Variant; const Value: Real
asm
{$IFDEF PIC}
        PUSH    EAX
        PUSH    ECX
        CALL    GetGOT
        POP     ECX
        LEA     EAX,[EAX].OFFSET VariantManager
        MOV     EAX,[EAX].TVariantManager.VarFromReal
        XCHG    EAX,[ESP]
        RET
{$ELSE}
        JMP     VariantManager.VarFromReal
{$ENDIF}
end;

procedure _VarFromTDateTime; // var V: Variant; const Value: TDateTime
asm
{$IFDEF PIC}
        PUSH    EAX
        PUSH    ECX
        CALL    GetGOT
        POP     ECX
        LEA     EAX,[EAX].OFFSET VariantManager
        MOV     EAX,[EAX].TVariantManager.VarFromTDateTime
        XCHG    EAX,[ESP]
        RET
{$ELSE}
        JMP     VariantManager.VarFromTDateTime
{$ENDIF}
end;

procedure _VarFromCurr; // var V: Variant; const Value: Currency
asm
{$IFDEF PIC}
        PUSH    EAX
        PUSH    ECX
        CALL    GetGOT
        POP     ECX
        LEA     EAX,[EAX].OFFSET VariantManager
        MOV     EAX,[EAX].TVariantManager.VarFromCurr
        XCHG    EAX,[ESP]
        RET
{$ELSE}
        JMP     VariantManager.VarFromCurr
{$ENDIF}
end;

procedure _VarFromPStr(var V: Variant; const Value: ShortString);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarFromPStr(V, Value);
{$ELSE}
asm
        JMP     VariantManager.VarFromPStr
{$IFEND}
end;

procedure _VarFromLStr(var V: Variant; const Value: string);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarFromLStr(V, Value);
{$ELSE}
asm
        JMP     VariantManager.VarFromLStr
{$IFEND}
end;

procedure _VarFromWStr(var V: Variant; const Value: WideString);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarFromWStr(V, Value);
{$ELSE}
asm
        JMP     VariantManager.VarFromWStr
{$IFEND}
end;

procedure _VarFromIntf(var V: Variant; const Value: IInterface);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarFromIntf(V, Value);
{$ELSE}
asm
        JMP     VariantManager.VarFromIntf
{$IFEND}
end;

procedure _VarFromDisp(var V: Variant; const Value: IDispatch);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarFromDisp(V, Value);
{$ELSE}
asm
        JMP     VariantManager.VarFromDisp
{$IFEND}
end;

procedure _VarFromDynArray(var V: Variant; const DynArray: Pointer; TypeInfo: Pointer);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarFromDynArray(V, DynArray, TypeInfo);
{$ELSE}
asm
        JMP     VariantManager.VarFromDynArray
{$IFEND}
end;

procedure _OleVarFromPStr(var V: OleVariant; const Value: ShortString);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.OleVarFromPStr(V, Value);
{$ELSE}
asm
        JMP     VariantManager.OleVarFromPStr
{$IFEND}
end;

procedure _OleVarFromLStr(var V: OleVariant; const Value: string);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.OleVarFromLStr(V, Value);
{$ELSE}
asm
        JMP     VariantManager.OleVarFromLStr
{$IFEND}
end;

procedure _OleVarFromVar(var V: OleVariant; const Value: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.OleVarFromVar(V, Value);
{$ELSE}
asm
        JMP     VariantManager.OleVarFromVar
{$IFEND}
end;

procedure _OleVarFromInt(var V: OleVariant; const Value, Range: Integer);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.OleVarFromInt(V, Value, Range);
{$ELSE}
asm
        JMP     VariantManager.OleVarFromInt
{$IFEND}
end;

procedure _VarAdd(var Left: Variant; const Right: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarOp(Left, Right, opAdd);
{$ELSE}
asm
        MOV     ECX,opAdd
        JMP     VariantManager.VarOp
{$IFEND}
end;

procedure _VarSub(var Left: Variant; const Right: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarOp(Left, Right, opSubtract);
{$ELSE}
asm
        MOV     ECX,opSubtract
        JMP     VariantManager.VarOp
{$IFEND}
end;

procedure _VarMul(var Left: Variant; const Right: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarOp(Left, Right, opMultiply);
{$ELSE}
asm
        MOV     ECX,opMultiply
        JMP     VariantManager.VarOp
{$IFEND}
end;

procedure _VarDiv(var Left: Variant; const Right: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarOp(Left, Right, opIntDivide);
{$ELSE}
asm
        MOV     ECX,opIntDivide
        JMP     VariantManager.VarOp
{$IFEND}
end;

procedure _VarMod(var Left: Variant; const Right: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarOp(Left, Right, opModulus);
{$ELSE}
asm
        MOV     ECX,opModulus
        JMP     VariantManager.VarOp
{$IFEND}
end;

procedure _VarAnd(var Left: Variant; const Right: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarOp(Left, Right, opAnd);
{$ELSE}
asm
        MOV     ECX,opAnd
        JMP     VariantManager.VarOp
{$IFEND}
end;

procedure _VarOr(var Left: Variant; const Right: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarOp(Left, Right, opOr);
{$ELSE}
asm
        MOV     ECX,opOr
        JMP     VariantManager.VarOp
{$IFEND}
end;

procedure _VarXor(var Left: Variant; const Right: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarOp(Left, Right, opXor);
{$ELSE}
asm
        MOV     ECX,opXor
        JMP     VariantManager.VarOp
{$IFEND}
end;

procedure _VarShl(var Left: Variant; const Right: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarOp(Left, Right, opShiftLeft);
{$ELSE}
asm
        MOV     ECX,opShiftLeft
        JMP     VariantManager.VarOp
{$IFEND}
end;

procedure _VarShr(var Left: Variant; const Right: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarOp(Left, Right, opShiftRight);
{$ELSE}
asm
        MOV     ECX,opShiftRight
        JMP     VariantManager.VarOp
{$IFEND}
end;

procedure _VarRDiv(var Left: Variant; const Right: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarOp(Left, Right, opDivide);
{$ELSE}
asm
        MOV     ECX,opDivide
        JMP     VariantManager.VarOp
{$IFEND}
end;

{$IF Defined(PIC) or Defined(PUREPASCAL)}
// result is set in the flags
procedure DoVarCmp(const Left, Right: Variant; OpCode: Integer);
begin
  VariantManager.VarCmp(TVarData(Left), TVarData(Right), OpCode);
end;
{$IFEND}

procedure _VarCmpEQ(const Left, Right: Variant); // result is set in the flags
asm
        MOV     ECX, opCmpEQ
{$IFDEF PIC}
        JMP     DoVarCmp
{$ELSE}
        JMP     VariantManager.VarCmp
{$ENDIF}
end;

procedure _VarCmpNE(const Left, Right: Variant); // result is set in the flags
asm
        MOV     ECX, opCmpNE
{$IFDEF PIC}
        JMP     DoVarCmp
{$ELSE}
        JMP     VariantManager.VarCmp
{$ENDIF}
end;

procedure _VarCmpLT(const Left, Right: Variant); // result is set in the flags
asm
        MOV     ECX, opCmpLT
{$IFDEF PIC}
        JMP     DoVarCmp
{$ELSE}
        JMP     VariantManager.VarCmp
{$ENDIF}
end;

procedure _VarCmpLE(const Left, Right: Variant); // result is set in the flags
asm
        MOV     ECX, opCmpLE
{$IFDEF PIC}
        JMP     DoVarCmp
{$ELSE}
        JMP     VariantManager.VarCmp
{$ENDIF}
end;

procedure _VarCmpGT(const Left, Right: Variant); // result is set in the flags
asm
        MOV     ECX, opCmpGT
{$IFDEF PIC}
        JMP     DoVarCmp
{$ELSE}
        JMP     VariantManager.VarCmp
{$ENDIF}
end;

procedure _VarCmpGE(const Left, Right: Variant); // result is set in the flags
asm
        MOV     ECX, opCmpGE
{$IFDEF PIC}
        JMP     DoVarCmp
{$ELSE}
        JMP     VariantManager.VarCmp
{$ENDIF}
end;


procedure _VarNeg(var V: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarNeg(V);
{$ELSE}
asm
        JMP     VariantManager.VarNeg
{$IFEND}
end;

procedure _VarNot(var V: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarNot(V);
{$ELSE}
asm
        JMP     VariantManager.VarNot
{$IFEND}
end;

procedure _VarCopyNoInd;
asm
{$IFDEF PIC}
        PUSH    EAX
        PUSH    ECX
        CALL    GetGOT
        POP     ECX
        LEA     EAX,[EAX].OFFSET VariantManager
        MOV     EAX,[EAX].TVariantManager.VarCopyNoInd
        XCHG    EAX,[ESP]
        RET
{$ELSE}
        JMP     VariantManager.VarCopyNoInd
{$ENDIF}
end;

procedure _VarClr(var V: Variant);
asm
        PUSH    EAX
        CALL    _VarClear
        POP     EAX
end;

procedure _VarAddRef(var V: Variant);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarAddRef(V);
{$ELSE}
asm
        JMP     VariantManager.VarAddRef
{$IFEND}
end;

procedure _IntfDispCall;
asm
{$IFDEF PIC}
        PUSH    EAX
        PUSH    ECX
        CALL    GetGOT
        POP     ECX
        LEA     EAX,[EAX].OFFSET DispCallByIDProc
        MOV     EAX,[EAX]
        XCHG    EAX,[ESP]
        RET
{$ELSE}
        JMP     DispCallByIDProc
{$ENDIF}
end;

procedure _DispCallByIDError;
asm
        MOV     AL,reVarDispatch
        JMP     Error
end;

procedure _IntfVarCall;
asm
end;

function _WriteVariant(var T: Text; const V: Variant; Width: Integer): Pointer;
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  Result := VariantManager.WriteVariant(T, V, Width);
{$ELSE}
asm
        JMP     VariantManager.WriteVariant
{$IFEND}
end;

function _Write0Variant(var T: Text; const V: Variant): Pointer;
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  Result := VariantManager.Write0Variant(T, V);
{$ELSE}
asm
        JMP     VariantManager.Write0Variant
{$IFEND}
end;

{ ----------------------------------------------------- }
{       Variant array support                           }
{ ----------------------------------------------------- }

procedure _VarArrayRedim(var A : Variant; HighBound: Integer);
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  VariantManager.VarArrayRedim(A, HighBound);
{$ELSE}
asm
        JMP     VariantManager.VarArrayRedim
{$IFEND}
end;

function _VarArrayGet(var A: Variant; IndexCount: Integer;
  Indices: Integer): Variant; cdecl;
asm
        POP     EBP
{$IFDEF PIC}
        CALL    GetGOT
        LEA     EAX,[EAX].OFFSET VariantManager
        MOV     EAX,[EAX].TVariantManager.VarArrayGet
        PUSH    EAX
        RET
{$ELSE}
        JMP     VariantManager.VarArrayGet
{$ENDIF}
end;

procedure _VarArrayPut(var A: Variant; const Value: Variant;
  IndexCount: Integer; Indices: Integer); cdecl;
asm
        POP     EBP
{$IFDEF PIC}
        CALL    GetGOT
        LEA     EAX,[EAX].OFFSET VariantManager
        MOV     EAX,[EAX].TVariantManager.VarArrayPut
        PUSH    EAX
        RET
{$ELSE}
        JMP     VariantManager.VarArrayPut
{$ENDIF}
end;

// 64 bit integer helper routines
//
// These functions always return the 64-bit result in EAX:EDX

// ------------------------------------------------------------------------------
//  64-bit signed multiply
// ------------------------------------------------------------------------------
//
//  Param 1(EAX:EDX), Param 2([ESP+8]:[ESP+4])  ; before reg pushing
//

procedure __llmul;
asm
        push  edx
        push  eax

  // Param2 : [ESP+16]:[ESP+12]  (hi:lo)
  // Param1 : [ESP+4]:[ESP]      (hi:lo)

        mov   eax, [esp+16]
        mul   dword ptr [esp]
        mov   ecx, eax

        mov   eax, [esp+4]
        mul   dword ptr [esp+12]
        add   ecx, eax

        mov   eax, [esp]
        mul   dword ptr [esp+12]
        add   edx, ecx

        pop   ecx
        pop   ecx

        ret     8
end;

// ------------------------------------------------------------------------------
//  64-bit signed multiply, with overflow check (98.05.15: overflow not supported yet)
// ------------------------------------------------------------------------------
//
//  Param1 ~= U   (Uh, Ul)
//  Param2 ~= V   (Vh, Vl)
//
//  Param 1(EAX:EDX), Param 2([ESP+8]:[ESP+4])  ; before reg pushing
//
//  compiler-helper function
//  O-flag set on exit   => result is invalid
//  O-flag clear on exit => result is valid

procedure __llmulo;
asm
        push   edx
        push   eax

        // Param2 : [ESP+16]:[ESP+12]  (hi:lo)
        // Param1 : [ESP+4]:[ESP]      (hi:lo)

        mov    eax, [esp+16]
        mul    dword ptr [esp]
        mov    ecx, eax

        mov    eax, [esp+4]
        mul    dword ptr [esp+12]
        add    ecx, eax

        mov    eax, [esp]
        mul    dword ptr [esp+12]
        add    edx, ecx

        pop    ecx
        pop    ecx

        ret    8
end;

// ------------------------------------------------------------------------------
//  64-bit signed division
// ------------------------------------------------------------------------------

//
//  Dividend = Numerator, Divisor = Denominator
//
//  Dividend(EAX:EDX), Divisor([ESP+8]:[ESP+4])  ; before reg pushing
//
//

procedure __lldiv;
asm
        push    ebp
        push    ebx
        push    esi
        push    edi
        xor     edi,edi

        mov     ebx,20[esp]             // get the divisor low dword
        mov     ecx,24[esp]             // get the divisor high dword

        or      ecx,ecx
        jnz     @__lldiv@slow_ldiv      // both high words are zero

        or      edx,edx
        jz      @__lldiv@quick_ldiv

        or      ebx,ebx
        jz      @__lldiv@quick_ldiv     // if ecx:ebx == 0 force a zero divide
          // we don't expect this to actually
          // work

@__lldiv@slow_ldiv:

//
//               Signed division should be done.  Convert negative
//               values to positive and do an unsigned division.
//               Store the sign value in the next higher bit of
//               di (test mask of 4).  Thus when we are done, testing
//               that bit will determine the sign of the result.
//
        or      edx,edx                 // test sign of dividend
        jns     @__lldiv@onepos
        neg     edx
        neg     eax
        sbb     edx,0                   // negate dividend
        or      edi,1

@__lldiv@onepos:
        or      ecx,ecx                 // test sign of divisor
        jns     @__lldiv@positive
        neg     ecx
        neg     ebx
        sbb     ecx,0                   // negate divisor
        xor edi,1

@__lldiv@positive:
        mov     ebp,ecx
        mov     ecx,64                  // shift counter
        push    edi                     // save the flags
//
//       Now the stack looks something like this:
//
//               24[esp]: divisor (high dword)
//               20[esp]: divisor (low dword)
//               16[esp]: return EIP
//               12[esp]: previous EBP
//                8[esp]: previous EBX
//                4[esp]: previous ESI
//                 [esp]: previous EDI
//
        xor     edi,edi                 // fake a 64 bit dividend
        xor     esi,esi

@__lldiv@xloop:
        shl     eax,1                   // shift dividend left one bit
        rcl     edx,1
        rcl     esi,1
        rcl     edi,1
        cmp     edi,ebp                 // dividend larger?
        jb      @__lldiv@nosub
        ja      @__lldiv@subtract
        cmp     esi,ebx                 // maybe
        jb      @__lldiv@nosub

@__lldiv@subtract:
        sub     esi,ebx
        sbb     edi,ebp                 // subtract the divisor
        inc     eax                     // build quotient

@__lldiv@nosub:
        loop    @__lldiv@xloop
//
//       When done with the loop the four registers values' look like:
//
//       |     edi    |    esi     |    edx     |    eax     |
//       |        remainder        |         quotient        |
//
        pop     ebx                     // get control bits
        test    ebx,1                   // needs negative
        jz      @__lldiv@finish
        neg     edx
        neg     eax
        sbb     edx,0                   // negate

@__lldiv@finish:
        pop     edi
        pop     esi
        pop     ebx
        pop     ebp
        ret     8

@__lldiv@quick_ldiv:
        div     ebx                     // unsigned divide
        xor     edx,edx
        jmp     @__lldiv@finish
end;

// ------------------------------------------------------------------------------
//  64-bit signed division with overflow check (98.05.15: not implementated yet)
// ------------------------------------------------------------------------------

//
//  Dividend = Numerator, Divisor = Denominator
//
//  Dividend(EAX:EDX), Divisor([ESP+8]:[ESP+4])
//  Param 1 (EAX:EDX), Param 2([ESP+8]:[ESP+4])
//
//  Param1 ~= U   (Uh, Ul)
//  Param2 ~= V   (Vh, Vl)
//
//  compiler-helper function
//  O-flag set on exit   => result is invalid
//  O-flag clear on exit => result is valid
//

procedure __lldivo;
asm
  // check for overflow condition: min(int64) DIV -1
        push  esi
        mov esi, [esp+12]   // Vh
        and esi, [esp+8]    // Vl
        cmp esi, 0ffffffffh   // V = -1?
        jne @@divok

        mov esi, eax
        or  esi, edx
        cmp esi, 80000000H    // U = min(int64)?
        jne @@divok

@@divOvl:
        mov eax, esi
        pop esi
        dec eax                     // turn on O-flag
        ret

@@divok:
        pop esi
        push  dword ptr [esp+8]   // Vh
        push  dword ptr [esp+8]   // Vl (offset is changed from push)
        call  __lldiv
        and eax, eax    // turn off O-flag
        ret 8
end;

// ------------------------------------------------------------------------------
//  64-bit unsigned division
// ------------------------------------------------------------------------------

//  Dividend(EAX(hi):EDX(lo)), Divisor([ESP+8](hi):[ESP+4](lo))  // before reg pushing
procedure __lludiv;
asm
        push    ebp
        push    ebx
        push    esi
        push    edi
//
//       Now the stack looks something like this:
//
//               24[esp]: divisor (high dword)
//               20[esp]: divisor (low dword)
//               16[esp]: return EIP
//               12[esp]: previous EBP
//                8[esp]: previous EBX
//                4[esp]: previous ESI
//                 [esp]: previous EDI
//

//       dividend is pushed last, therefore the first in the args
//       divisor next.
//
        mov     ebx,20[esp]             // get the first low word
        mov     ecx,24[esp]             // get the first high word

        or      ecx,ecx
        jnz     @__lludiv@slow_ldiv     // both high words are zero

        or      edx,edx
        jz      @__lludiv@quick_ldiv

        or      ebx,ebx
        jz      @__lludiv@quick_ldiv    // if ecx:ebx == 0 force a zero divide
          // we don't expect this to actually
          // work

@__lludiv@slow_ldiv:
        mov     ebp,ecx
        mov     ecx,64                  // shift counter
        xor     edi,edi                 // fake a 64 bit dividend
        xor     esi,esi

@__lludiv@xloop:
        shl     eax,1                   // shift dividend left one bit
        rcl     edx,1
        rcl     esi,1
        rcl     edi,1
        cmp     edi,ebp                 // dividend larger?
        jb      @__lludiv@nosub
        ja      @__lludiv@subtract
        cmp     esi,ebx                 // maybe
        jb      @__lludiv@nosub

@__lludiv@subtract:
        sub     esi,ebx
        sbb     edi,ebp                 // subtract the divisor
        inc     eax                     // build quotient

@__lludiv@nosub:
        loop    @__lludiv@xloop
//
//       When done with the loop the four registers values' look like:
//
//       |     edi    |    esi     |    edx     |    eax     |
//       |        remainder        |         quotient        |
//

@__lludiv@finish:
        pop     edi
        pop     esi
        pop     ebx
        pop     ebp
        ret     8

@__lludiv@quick_ldiv:
        div     ebx                     // unsigned divide
        xor     edx,edx
        jmp     @__lludiv@finish
end;

// ------------------------------------------------------------------------------
//  64-bit modulo
// ------------------------------------------------------------------------------

//  Dividend(EAX:EDX), Divisor([ESP+8]:[ESP+4])  // before reg pushing
procedure __llmod;
asm
        push    ebp
        push    ebx
        push    esi
        push    edi
        xor   edi,edi
//
//       dividend is pushed last, therefore the first in the args
//       divisor next.
//
        mov     ebx,20[esp]             // get the first low word
        mov     ecx,24[esp]             // get the first high word
        or      ecx,ecx
        jnz     @__llmod@slow_ldiv      // both high words are zero

        or      edx,edx
        jz      @__llmod@quick_ldiv

        or      ebx,ebx
        jz      @__llmod@quick_ldiv     // if ecx:ebx == 0 force a zero divide
          // we don't expect this to actually
          // work
@__llmod@slow_ldiv:
//
//               Signed division should be done.  Convert negative
//               values to positive and do an unsigned division.
//               Store the sign value in the next higher bit of
//               di (test mask of 4).  Thus when we are done, testing
//               that bit will determine the sign of the result.
//
        or      edx,edx                 // test sign of dividend
        jns     @__llmod@onepos
        neg     edx
        neg     eax
        sbb     edx,0                   // negate dividend
        or      edi,1

@__llmod@onepos:
        or      ecx,ecx                 // test sign of divisor
        jns     @__llmod@positive
        neg     ecx
        neg     ebx
        sbb     ecx,0                   // negate divisor

@__llmod@positive:
        mov     ebp,ecx
        mov     ecx,64                  // shift counter
        push    edi                     // save the flags
//
//       Now the stack looks something like this:
//
//               24[esp]: divisor (high dword)
//               20[esp]: divisor (low dword)
//               16[esp]: return EIP
//               12[esp]: previous EBP
//                8[esp]: previous EBX
//                4[esp]: previous ESI
//                 [esp]: previous EDI
//
        xor     edi,edi                 // fake a 64 bit dividend
        xor     esi,esi

@__llmod@xloop:
        shl     eax,1                   // shift dividend left one bit
        rcl     edx,1
        rcl     esi,1
        rcl     edi,1
        cmp     edi,ebp                 // dividend larger?
        jb      @__llmod@nosub
        ja      @__llmod@subtract
        cmp     esi,ebx                 // maybe
        jb      @__llmod@nosub

@__llmod@subtract:
        sub     esi,ebx
        sbb     edi,ebp                 // subtract the divisor
        inc     eax                     // build quotient

@__llmod@nosub:
        loop    @__llmod@xloop
//
//       When done with the loop the four registers values' look like:
//
//       |     edi    |    esi     |    edx     |    eax     |
//       |        remainder        |         quotient        |
//
        mov     eax,esi
        mov     edx,edi                 // use remainder

        pop     ebx                     // get control bits
        test    ebx,1                   // needs negative
        jz      @__llmod@finish
        neg     edx
        neg     eax
        sbb     edx,0                    // negate

@__llmod@finish:
        pop     edi
        pop     esi
        pop     ebx
        pop     ebp
        ret     8

@__llmod@quick_ldiv:
        div     ebx                     // unsigned divide
        xchg  eax,edx
        xor     edx,edx
        jmp     @__llmod@finish
end;

// ------------------------------------------------------------------------------
//  64-bit signed modulo with overflow (98.05.15: overflow not yet supported)
// ------------------------------------------------------------------------------

//  Dividend(EAX:EDX), Divisor([ESP+8]:[ESP+4])
//  Param 1 (EAX:EDX), Param 2([ESP+8]:[ESP+4])
//
//  Param1 ~= U   (Uh, Ul)
//  Param2 ~= V   (Vh, Vl)
//
//  compiler-helper function
//  O-flag set on exit   => result is invalid
//  O-flag clear on exit => result is valid
//

procedure __llmodo;
asm
  // check for overflow condition: min(int64) MOD -1
        push  esi
        mov esi, [esp+12]   // Vh
        and esi, [esp+8]    // Vl
        cmp esi, 0ffffffffh   // V = -1?
        jne @@modok

        mov esi, eax
        or  esi, edx
        cmp esi, 80000000H    // U = min(int64)?
        jne @@modok

@@modOvl:
        mov eax, esi
        pop esi
        dec eax                     // turn on O-flag
        ret

@@modok:
        pop esi
        push  dword ptr [esp+8]       // Vh
        push  dword ptr [esp+8] // Vl (offset is changed from push)
        call  __llmod
        and eax, eax    // turn off O-flag
        ret 8
end;

// ------------------------------------------------------------------------------
//  64-bit unsigned modulo
// ------------------------------------------------------------------------------
//  Dividend(EAX(hi):EDX(lo)), Divisor([ESP+8](hi):[ESP+4](lo))  // before reg pushing

procedure __llumod;
asm
        push    ebp
        push    ebx
        push    esi
        push    edi
//
//       Now the stack looks something like this:
//
//               24[esp]: divisor (high dword)
//               20[esp]: divisor (low dword)
//               16[esp]: return EIP
//               12[esp]: previous EBP
//                8[esp]: previous EBX
//                4[esp]: previous ESI
//                 [esp]: previous EDI
//

//       dividend is pushed last, therefore the first in the args
//       divisor next.
//
        mov     ebx,20[esp]             // get the first low word
        mov     ecx,24[esp]             // get the first high word
        or      ecx,ecx
        jnz     @__llumod@slow_ldiv     // both high words are zero

        or      edx,edx
        jz      @__llumod@quick_ldiv

        or      ebx,ebx
        jz      @__llumod@quick_ldiv    // if ecx:ebx == 0 force a zero divide
          // we don't expect this to actually
          // work
@__llumod@slow_ldiv:
        mov     ebp,ecx
        mov     ecx,64                  // shift counter
        xor     edi,edi                 // fake a 64 bit dividend
        xor     esi,esi                 //

@__llumod@xloop:
        shl     eax,1                   // shift dividend left one bit
        rcl     edx,1
        rcl     esi,1
        rcl     edi,1
        cmp     edi,ebp                 // dividend larger?
        jb      @__llumod@nosub
        ja      @__llumod@subtract
        cmp     esi,ebx                 // maybe
        jb      @__llumod@nosub

@__llumod@subtract:
        sub     esi,ebx
        sbb     edi,ebp                 // subtract the divisor
        inc     eax                     // build quotient

@__llumod@nosub:
        loop    @__llumod@xloop
//
//       When done with the loop the four registers values' look like:
//
//       |     edi    |    esi     |    edx     |    eax     |
//       |        remainder        |         quotient        |
//
        mov     eax,esi
        mov     edx,edi                 // use remainder

@__llumod@finish:
        pop     edi
        pop     esi
        pop     ebx
        pop     ebp
        ret     8

@__llumod@quick_ldiv:
        div     ebx                     // unsigned divide
        xchg  eax,edx
        xor     edx,edx
        jmp     @__llumod@finish
end;

// ------------------------------------------------------------------------------
//  64-bit shift left
// ------------------------------------------------------------------------------

//
// target (EAX:EDX) count (ECX)
//
procedure __llshl;
asm
        cmp cl, 32
        jl  @__llshl@below32
        cmp cl, 64
        jl  @__llshl@below64
        xor edx, edx
        xor eax, eax
        ret

@__llshl@below64:
        mov edx, eax
        shl edx, cl
        xor eax, eax
        ret

@__llshl@below32:
        shld  edx, eax, cl
        shl eax, cl
        ret
end;

// ------------------------------------------------------------------------------
//  64-bit signed shift right
// ------------------------------------------------------------------------------
// target (EAX:EDX) count (ECX)

procedure __llshr;
asm
        cmp cl, 32
        jl  @__llshr@below32
        cmp cl, 64
        jl  @__llshr@below64
        sar edx, 1fh
        mov eax,edx
        ret

@__llshr@below64:
        mov eax, edx
        cdq
        sar eax,cl
        ret

@__llshr@below32:
        shrd  eax, edx, cl
        sar edx, cl
        ret
end;

// ------------------------------------------------------------------------------
//  64-bit unsigned shift right
// ------------------------------------------------------------------------------

// target (EAX:EDX) count (ECX)
procedure __llushr;
asm
        cmp cl, 32
        jl  @__llushr@below32
        cmp cl, 64
        jl  @__llushr@below64
        xor edx, edx
        xor eax, eax
        ret

@__llushr@below64:
        mov eax, edx
        xor edx, edx
        shr eax, cl
        ret

@__llushr@below32:
        shrd  eax, edx, cl
        shr edx, cl
        ret
end;

function _StrInt64(val: Int64; width: Integer): ShortString;
var
  d: array[0..31] of Char;  { need 19 digits and a sign }
  i, k: Integer;
  sign: Boolean;
  spaces: Integer;
begin
  { Produce an ASCII representation of the number in reverse order }
  i := 0;
  sign := val < 0;
  repeat
    d[i] := Chr( Abs(val mod 10) + Ord('0') );
    Inc(i);
    val := val div 10;
  until val = 0;
  if sign then
  begin
    d[i] := '-';
    Inc(i);
  end;

  { Fill the Result with the appropriate number of blanks }
  if width > 255 then
    width := 255;
  k := 1;
  spaces := width - i;
  while k <= spaces do
  begin
    Result[k] := ' ';
    Inc(k);
  end;

  { Fill the Result with the number }
  while i > 0 do
  begin
    Dec(i);
    Result[k] := d[i];
    Inc(k);
  end;

  { Result is k-1 characters long }
  SetLength(Result, k-1);

end;

function _Str0Int64(val: Int64): ShortString;
begin
  Result := _StrInt64(val, 0);
end;

procedure       _WriteInt64;
asm
{       PROCEDURE _WriteInt64( VAR t: Text; val: Int64; with: Longint);        }
{     ->EAX     Pointer to file record  }
{       [ESP+4] Value                   }
{       EDX     Field width             }

        SUB     ESP,32          { VAR s: String[31];    }

        PUSH    EAX
        PUSH    EDX

        PUSH    dword ptr [ESP+8+32+8]    { Str( val : 0, s );    }
        PUSH    dword ptr [ESP+8+32+8]
        XOR     EAX,EAX
        LEA     EDX,[ESP+8+8]
        CALL    _StrInt64

        POP     ECX
        POP     EAX

        MOV     EDX,ESP         { Write( t, s : width );}
        CALL    _WriteString

        ADD     ESP,32
        RET     8
end;

procedure       _Write0Int64;
asm
{       PROCEDURE _Write0Long( VAR t: Text; val: Longint);      }
{     ->EAX     Pointer to file record  }
{       EDX     Value                   }
        XOR     EDX,EDX
        JMP     _WriteInt64
end;

procedure _ReadInt64;
asm
      // -> EAX Pointer to text record
      // <- EAX:EDX Result

        PUSH  EBX
        PUSH  ESI
        PUSH  EDI
        SUB ESP,36      // var numbuf: String[32];

        MOV ESI,EAX
        CALL  _SeekEof
        DEC AL
        JZ  @@eof

        MOV EDI,ESP     // EDI -> numBuf[0]
        MOV BL,32
@@loop:
        MOV EAX,ESI
        CALL  _ReadChar
        CMP AL,' '
        JBE @@endNum
        STOSB
        DEC BL
        JNZ @@loop
@@convert:
        MOV byte ptr [EDI],0
        MOV EAX,ESP     // EAX -> numBuf
        PUSH  EDX     // allocate code result
        MOV EDX,ESP     // pass pointer to code
        CALL  _ValInt64   // convert
        POP ECX     // pop code result into EDX
        TEST  ECX,ECX
        JZ  @@exit
        MOV     EAX,106
        CALL    SetInOutRes

@@exit:
        ADD ESP,36
        POP EDI
        POP ESI
        POP EBX
        RET

@@endNum:
        CMP AH,cEof
        JE  @@convert
        DEC [ESI].TTextRec.BufPos
        JMP @@convert

@@eof:
        XOR EAX,EAX
        JMP @@exit
end;

function _ValInt64(const s: AnsiString; var code: Integer): Int64;
var
  i: Integer;
  dig: Integer;
  sign: Boolean;
  empty: Boolean;
begin
  i := 1;
  dig := 0;
  Result := 0;
  if s = '' then
  begin
    code := i;
    exit;
  end;
  while s[i] = ' ' do
    Inc(i);
  sign := False;
  if s[i] = '-' then
  begin
    sign := True;
    Inc(i);
  end
  else if s[i] = '+' then
    Inc(i);
  empty := True;
  if (s[i] = '$') or (s[i] = '0') and (Upcase(s[i+1]) = 'X') then
  begin
    if s[i] = '0' then
      Inc(i);
    Inc(i);
    while True do
    begin
      case s[i] of
      '0'..'9': dig := Ord(s[i]) -  Ord('0');
      'A'..'F': dig := Ord(s[i]) - (Ord('A') - 10);
      'a'..'f': dig := Ord(s[i]) - (Ord('a') - 10);
      else
        break;
      end;
      if (Result < 0) or (Result > (High(Int64) div 16)) then
        break;
      Result := Result shl 4 + dig;
      Inc(i);
      empty := False;
    end;
    if sign then
      Result := - Result;
  end
  else
  begin
    while True do
    begin
      case s[i] of
      '0'..'9': dig := Ord(s[i]) - Ord('0');
      else
        break;
      end;
      if (Result < 0) or (Result > (High(Int64) div 10)) then
        break;
      Result := Result*10 + dig;
      Inc(i);
      empty := False;
    end;
    if sign then
      Result := - Result;
    if (Result <> 0) and (sign <> (Result < 0)) then
      Dec(i);
  end;
  if (s[i] <> #0) or empty then
    code := i
  else
    code := 0;
end;

procedure _DynArrayLength;
asm
{       FUNCTION _DynArrayLength(const a: array of ...): Longint; }
{     ->EAX     Pointer to array or nil                           }
{     <-EAX     High bound of array + 1 or 0                      }
        TEST    EAX,EAX
        JZ      @@skip
        MOV     EAX,[EAX-4]
@@skip:
end;

procedure _DynArrayHigh;
asm
{       FUNCTION _DynArrayHigh(const a: array of ...): Longint; }
{     ->EAX     Pointer to array or nil                         }
{     <-EAX     High bound of array or -1                       }
        CALL  _DynArrayLength
        DEC     EAX
end;

procedure CopyArray(dest, source, typeInfo: Pointer; cnt: Integer);
asm
        PUSH    dword ptr [EBP+8]
        CALL    _CopyArray
end;

procedure FinalizeArray(p, typeInfo: Pointer; cnt: Integer);
asm
        JMP     _FinalizeArray
end;

procedure DynArrayClear(var a: Pointer; typeInfo: Pointer);
asm
  CALL    _DynArrayClear
end;

procedure DynArraySetLength(var a: Pointer; typeInfo: Pointer; dimCnt: Longint; lengthVec: PLongint);
var
  i: Integer;
  newLength, oldLength, minLength: Longint;
  elSize: Longint;
  neededSize: Longint;
  p, pp: Pointer;
begin
  p := a;

  // Fetch the new length of the array in this dimension, and the old length
  newLength := PLongint(lengthVec)^;
  if newLength <= 0 then
  begin
    if newLength < 0 then
      Error(reRangeError);
    DynArrayClear(a, typeInfo);
    exit;
  end;

  oldLength := 0;
  if p <> nil then
  begin
    Dec(PLongint(p));
    oldLength := PLongint(p)^;
    Dec(PLongint(p));
  end;

  // Calculate the needed size of the heap object
  Inc(PChar(typeInfo), Length(PDynArrayTypeInfo(typeInfo).name));
  elSize := PDynArrayTypeInfo(typeInfo).elSize;
  if PDynArrayTypeInfo(typeInfo).elType <> nil then
    typeInfo := PDynArrayTypeInfo(typeInfo).elType^
  else
    typeInfo := nil;
  neededSize := newLength*elSize;
  if neededSize div newLength <> elSize then
    Error(reRangeError);
  Inc(neededSize, Sizeof(Longint)*2);

  // If the heap object isn't shared (ref count = 1), just resize it. Otherwise, we make a copy
  if (p = nil) or (PLongint(p)^ = 1) then
  begin
    pp := p;
    if (newLength < oldLength) and (typeInfo <> nil) then
      FinalizeArray(PChar(p) + Sizeof(Longint)*2 + newLength*elSize, typeInfo, oldLength - newLength);
    ReallocMem(pp, neededSize);
    p := pp;
  end
  else
  begin
    Dec(PLongint(p)^);
    GetMem(p, neededSize);
    minLength := oldLength;
    if minLength > newLength then
      minLength := newLength;
    if typeInfo <> nil then
    begin
      FillChar((PChar(p) + Sizeof(Longint)*2)^, minLength*elSize, 0);
      CopyArray(PChar(p) + Sizeof(Longint)*2, a, typeInfo, minLength)
    end
    else
      Move(PChar(a)^, (PChar(p) + Sizeof(Longint)*2)^, minLength*elSize);
  end;

  // The heap object will now have a ref count of 1 and the new length
  PLongint(p)^ := 1;
  Inc(PLongint(p));
  PLongint(p)^ := newLength;
  Inc(PLongint(p));

  // Set the new memory to all zero bits
  FillChar((PChar(p) + elSize * oldLength)^, elSize * (newLength - oldLength), 0);

  // Take care of the inner dimensions, if any
  if dimCnt > 1 then
  begin
    Inc(lengthVec);
    Dec(dimCnt);
    for i := 0 to newLength-1 do
      DynArraySetLength(PPointerArray(p)[i], typeInfo, dimCnt, lengthVec);
  end;
  a := p;
end;

procedure _DynArraySetLength;
asm
{       PROCEDURE _DynArraySetLength(var a: dynarray; typeInfo: PDynArrayTypeInfo; dimCnt: Longint; lengthVec: ^Longint) }
{     ->EAX     Pointer to dynamic array (= pointer to pointer to heap object) }
{       EDX     Pointer to type info for the dynamic array                     }
{       ECX     number of dimensions                                           }
{       [ESP+4] dimensions                                                     }
        PUSH    ESP
        ADD     dword ptr [ESP],4
        CALL    DynArraySetLength
end;

procedure _DynArrayCopy(a: Pointer; typeInfo: Pointer; var Result: Pointer);
begin
  if a <> nil then
    _DynArrayCopyRange(a, typeInfo, 0, PLongint(PChar(a)-4)^, Result)
  else
    _DynArrayClear(Result, typeInfo);
end;

procedure _DynArrayCopyRange(a: Pointer; typeInfo: Pointer; index, count : Integer; var Result: Pointer);
var
  arrayLength: Integer;
  elSize: Integer;
  typeInf: PDynArrayTypeInfo;
  p: Pointer;
begin
  p := nil;
  if a <> nil then
  begin
    typeInf := typeInfo;

    // Limit index and count to values within the array
    if index < 0 then
    begin
      Inc(count, index);
      index := 0;
    end;
    arrayLength := PLongint(PChar(a)-4)^;
    if index > arrayLength then
      index := arrayLength;
    if count > arrayLength - index then
      count := arrayLength - index;
    if count < 0 then
      count := 0;

    if count > 0 then
    begin
      // Figure out the size and type descriptor of the element type
      Inc(PChar(typeInf), Length(typeInf.name));
      elSize := typeInf.elSize;
      if typeInf.elType <> nil then
        typeInf := typeInf.elType^
      else
        typeInf := nil;

      // Allocate the amount of memory needed
      GetMem(p, count*elSize + Sizeof(Longint)*2);

      // The reference count of the new array is 1, the length is count
      PLongint(p)^ := 1;
      Inc(PLongint(p));
      PLongint(p)^ := count;
      Inc(PLongint(p));
      Inc(PChar(a), index*elSize);

      // If the element type needs destruction, we must copy each element,
      // otherwise we can just copy the bits
      if count > 0 then
      begin
        if typeInf <> nil then
        begin
          FillChar(p^, count*elSize, 0);
          CopyArray(p, a, typeInf, count)
        end
        else
          Move(a^, p^, count*elSize);
      end;
    end;
  end;
  DynArrayClear(Result, typeInfo);
  Result := p;
end;

procedure _DynArrayClear;
asm
{     ->EAX     Pointer to dynamic array (Pointer to pointer to heap object }
{       EDX     Pointer to type info                                        }

        {       Nothing to do if Pointer to heap object is nil }
        MOV     ECX,[EAX]
        TEST    ECX,ECX
        JE      @@exit

        {       Set the variable to be finalized to nil }
        MOV     dword ptr [EAX],0

        {       Decrement ref count. Nothing to do if not zero now. }
{X LOCK} DEC     dword ptr [ECX-8]
        JNE     @@exit

  {       Save the source - we're supposed to return it }
        PUSH    EAX
        MOV     EAX,ECX

        {       Fetch the type descriptor of the elements }
        XOR     ECX,ECX
        MOV     CL,[EDX].TDynArrayTypeInfo.name;
        MOV     EDX,[EDX+ECX].TDynArrayTypeInfo.elType;

        {       If it's non-nil, finalize the elements }
        TEST    EDX,EDX
        JE      @@noFinalize
        MOV     ECX,[EAX-4]
        TEST    ECX,ECX
        JE      @@noFinalize
        MOV     EDX,[EDX]
        CALL    _FinalizeArray
@@noFinalize:
        {       Now deallocate the array }
        SUB     EAX,8
        CALL    _FreeMem
        POP     EAX
@@exit:
end;


procedure _DynArrayAsg;
asm
{     ->EAX     Pointer to destination (pointer to pointer to heap object }
{       EDX     source (pointer to heap object }
{       ECX     Pointer to rtti describing dynamic array }

        PUSH    EBX
        MOV     EBX,[EAX]

        {       Increment ref count of source if non-nil }

        TEST    EDX,EDX
        JE      @@skipInc
{X LOCK} INC     dword ptr [EDX-8]
@@skipInc:
        {       Dec ref count of destination - if it becomes 0, clear dest }
        TEST    EBX,EBX
        JE  @@skipClear
{X LOCK} DEC     dword ptr[EBX-8]
        JNZ     @@skipClear
        PUSH    EAX
        PUSH    EDX
        MOV     EDX,ECX
        INC     dword ptr[EBX-8]
        CALL    _DynArrayClear
        POP     EDX
        POP     EAX
@@skipClear:
        {       Finally store source into destination }
        MOV     [EAX],EDX

        POP     EBX
end;

procedure _DynArrayAddRef;
asm
{     ->EAX     Pointer to heap object }
        TEST    EAX,EAX
        JE      @@exit
{X LOCK} INC     dword ptr [EAX-8]
@@exit:
end;


function DynArrayIndex(const P: Pointer; const Indices: array of Integer; const TypInfo: Pointer): Pointer;
asm
        {     ->EAX     P                       }
  {       EDX     Pointer to Indices      }
        {       ECX     High bound of Indices   }
        {       [EBP+8] TypInfo                 }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     ESI,EDX
        MOV     EDI,[EBP+8]
        MOV     EBP,EAX

        XOR     EBX,EBX                 {  for i := 0 to High(Indices) do       }
        TEST    ECX,ECX
        JGE     @@start
@@loop:
        MOV     EBP,[EBP]
@@start:
        XOR     EAX,EAX
        MOV     AL,[EDI].TDynArrayTypeInfo.name
        ADD     EDI,EAX
        MOV     EAX,[ESI+EBX*4]         {    P := P + Indices[i]*TypInfo.elSize }
        MUL     [EDI].TDynArrayTypeInfo.elSize
        MOV     EDI,[EDI].TDynArrayTypeInfo.elType
        TEST    EDI,EDI
        JE      @@skip
        MOV     EDI,[EDI]
@@skip:
        ADD     EBP,EAX
        INC     EBX
        CMP     EBX,ECX
        JLE     @@loop

@@loopEnd:

        MOV     EAX,EBP

        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
end;


{ Returns the DynArrayTypeInfo of the Element Type of the specified DynArrayTypeInfo }
function DynArrayElTypeInfo(typeInfo: PDynArrayTypeInfo): PDynArrayTypeInfo;
begin
  Result := nil;
  if typeInfo <> nil then
  begin
    Inc(PChar(typeInfo), Length(typeInfo.name));
    if typeInfo.elType <> nil then
      Result := typeInfo.elType^;
  end;
end;

{ Returns # of dimemsions of the DynArray described by the specified DynArrayTypeInfo}
function DynArrayDim(typeInfo: PDynArrayTypeInfo): Integer;
begin
  Result := 0;
  while (typeInfo <> nil) and (typeInfo.kind = tkDynArray) do
  begin
    Inc(Result);
    typeInfo := DynArrayElTypeInfo(typeInfo);
  end;
end;

{ Returns size of the Dynamic Array}
function DynArraySize(a: Pointer): Integer;
asm
        TEST EAX, EAX
        JZ   @@exit
        MOV  EAX, [EAX-4]
@@exit:
end;

// Returns whether array is rectangular
function IsDynArrayRectangular(const DynArray: Pointer; typeInfo: PDynArrayTypeInfo): Boolean;
var
  Dim, I, J, Size, SubSize: Integer;
  P: Pointer;
begin
  // Assume we have a rectangular array
  Result := True;

  P := DynArray;
  Dim := DynArrayDim(typeInfo);

  {NOTE: Start at 1. Don't need to test the first dimension - it's rectangular by definition}
  for I := 1 to dim-1 do
  begin
    if P <> nil then
    begin
      { Get size of this dimension }
      Size := DynArraySize(P);

      { Get Size of first sub. dimension }
      SubSize := DynArraySize(PPointerArray(P)[0]);

      { Walk through every dimension making sure they all have the same size}
      for J := 1  to Size-1 do
        if DynArraySize(PPointerArray(P)[J]) <> SubSize then
        begin
          Result := False;
          Exit;
        end;

      { Point to next dimension}
      P := PPointerArray(P)[0];
    end;
  end;
end;

// Returns Bounds of Dynamic array as an array of integer containing the 'high' of each dimension
function DynArrayBounds(const DynArray: Pointer; typeInfo: PDynArrayTypeInfo): TBoundArray;
var
  Dim, I: Integer;
  P: Pointer;
begin
  P := DynArray;

  Dim := DynArrayDim(typeInfo);
  SetLength(Result, Dim);

  for I := 0 to dim-1 do
    if P <> nil then
    begin
      Result[I] := DynArraySize(P)-1;
      P := PPointerArray(P)[0]; // Assume rectangular arrays
    end;
end;

{ Decrements to next lower index - Returns True if successful }
{ Indices: Indices to be decremented }
{ Bounds : High bounds of each dimension }
function DecIndices(var Indices: TBoundArray; const Bounds: TBoundArray): Boolean;
var
  I, J: Integer;
begin
  { Find out if we're done: all at zeroes }
  Result := False;
  for I := Low(Indices)  to High(Indices) do
    if Indices[I] <> 0  then
    begin
      Result := True;
      break;
    end;
  if not Result then
    Exit;

  { Two arrays must be of same length }
  Assert(Length(Indices) = Length(Bounds));

  { Find index of item to tweak }
  for I := High(Indices) downto Low(Bounds) do
  begin
    // If not reach zero, dec and bail out
    if Indices[I] <> 0 then
    begin
      Dec(Indices[I]);
      Exit;
    end
    else
    begin
      J := I;
      while Indices[J] = 0 do
      begin
        // Restore high bound when we've reached zero on a particular dimension
        Indices[J] := Bounds[J];
        // Move to higher dimension
        Dec(J);
        Assert(J >= 0);
      end;
      Dec(Indices[J]);
      Exit;
    end;
  end;
end;

{ Package/Module registration/unregistration }

{$IFDEF MSWINDOWS}
const
  LOCALE_SABBREVLANGNAME = $00000003;   { abbreviated language name }
  LOAD_LIBRARY_AS_DATAFILE = 2;
  HKEY_CURRENT_USER = $80000001;
  KEY_ALL_ACCESS = $000F003F;
  KEY_READ = $000F0019;

  OldLocaleOverrideKey = 'Software\Borland\Delphi\Locales'; // do not localize
  NewLocaleOverrideKey = 'Software\Borland\Locales'; // do not localize
{$ENDIF}

function FindModule(Instance: LongWord): PLibModule;
begin
  Result := LibModuleList;
  while Result <> nil do
  begin
    if (Instance = Result.Instance) or
       (Instance = Result.CodeInstance) or
       (Instance = Result.DataInstance) or
       (Instance = Result.ResInstance) then
      Exit;
    Result := Result.Next;
  end;
end;

function FindHInstance(Address: Pointer): LongWord;
{$IFDEF MSWINDOWS}
var
  MemInfo: TMemInfo;
begin
  VirtualQuery(Address, MemInfo, SizeOf(MemInfo));
  if MemInfo.State = $1000{MEM_COMMIT} then
    Result := LongWord(MemInfo.AllocationBase)
  else
    Result := 0;
end;
{$ENDIF}
{$IFDEF LINUX}
var
  Info: TDLInfo;
begin
  if (dladdr(Address, Info) = 0) or (Info.BaseAddress = ExeBaseAddress) then
    Info.Filename := nil;   // if it's not in a library, assume the exe
  Result := LongWord(dlopen(Info.Filename, RTLD_LAZY));
  if Result <> 0 then
    dlclose(Result);
end;
{$ENDIF}

function FindClassHInstance(ClassType: TClass): LongWord;
begin
  Result := FindHInstance(Pointer(ClassType));
end;

{$IFDEF LINUX}
function GetModuleFileName(Module: HMODULE; Buffer: PChar; BufLen: Integer): Integer;
var
  Addr: Pointer;
  Info: TDLInfo;
  FoundInModule: HMODULE;
begin
  Result := 0;
  if (Module = MainInstance) or (Module = 0) then
  begin
    // First, try the dlsym approach.
    // dladdr fails to return the name of the main executable
    // in glibc prior to 2.1.91

{   Look for a dynamic symbol exported from this program.
    _DYNAMIC is not required in a main program file.
    If the main program is compiled with Delphi, it will always
    have a resource section, named @Sysinit@ResSym.
    If the main program is not compiled with Delphi, dlsym
    will search the global name space, potentially returning
    the address of a symbol in some other shared object library
    loaded by the program.  To guard against that, we check
    that the address of the symbol found is within the
    main program address range.  }

    dlerror;   // clear error state;  dlsym doesn't
    Addr := dlsym(Module, '@Sysinit@ResSym');
    if (Addr <> nil) and (dlerror = nil)
      and (dladdr(Addr, Info) <> 0)
      and (Info.FileName <> nil)
      and (Info.BaseAddress = ExeBaseAddress) then
    begin
      Result := _strlen(Info.FileName);
      if Result >= BufLen then Result := BufLen-1;
      Move(Info.FileName^, Buffer^, Result);
      Buffer[Result] := #0;
      Exit;
    end;

    // Try inspecting the /proc/ virtual file system
    // to find the program filename in the process info
    Result := _readlink('/proc/self/exe', Buffer, BufLen);
    if Result <> -1 then
    begin
      if Result >= BufLen then Result := BufLen-1;
      Buffer[Result] := #0;
    end;
{$IFDEF AllowParamStrModuleName}
{   Using ParamStr(0) to obtain a module name presents a potential
    security hole.  Resource modules are loaded based upon the filename
    of a given module.  We use dlopen() to load resource modules, which
    means the .init code of the resource module will be executed.
    Normally, resource modules contain no code at all - they're just
    carriers of resource data.
    An unpriviledged user program could launch our trusted,
    priviledged program with a bogus parameter list, tricking us
    into loading a module that contains malicious code in its
    .init section.
    Without this ParamStr(0) section, GetModuleFilename cannot be
    misdirected by unpriviledged code (unless the system program loader
    or the /proc file system or system root directory has been compromised).
    Resource modules are always loaded from the same directory as the
    given module.  Trusted code (programs, packages, and libraries)
    should reside in directories that unpriviledged code cannot alter.

    If you need GetModuleFilename to have a chance of working on systems
    where glibc < 2.1.91 and /proc is not available, and your
    program will not run as a priviledged user (or you don't care),
    you can define AllowParamStrModuleNames and rebuild the System unit
    and baseCLX package.  Note that even with ParamStr(0) support
    enabled, GetModuleFilename can still fail to find the name of
    a module.  C'est la Unix.  }

    if Result = -1 then // couldn't access the /proc filesystem
    begin               // return less accurate ParamStr(0)

{     ParamStr(0) returns the name of the link used
      to launch the app, not the name of the app itself.
      Also, if this app was launched by some other program,
      there is no guarantee that the launching program has set
      up our environment at all.  (example: Apache CGI) }

      if (ArgValues = nil) or (ArgValues^ = nil) or
        (PCharArray(ArgValues^)[0] = nil) then
      begin
        Result := 0;
        Exit;
      end;
      Result := _strlen(PCharArray(ArgValues^)[0]);
      if Result >= BufLen then Result := BufLen-1;
      Move(PCharArray(ArgValues^)[0]^, Buffer^, Result);
      Buffer[Result] := #0;
    end;
{$ENDIF}
  end
  else
  begin
{   For shared object libraries, we can rely on the dlsym technique.
    Look for a dynamic symbol in the requested module.
    Don't assume the module was compiled with Delphi.
    We look for a dynamic symbol with the name _DYNAMIC.  This
    exists in all ELF shared object libraries that export
    or import symbols;  If someone has a shared object library that
    contains no imports or exports of any kind, this will probably fail.
    If dlsym can't find the requested symbol in the given module, it
    will search the global namespace and could return the address
    of a symbol from some other module that happens to be loaded
    into this process.  That would be bad, so we double check
    that the module handle of the symbol found matches the
    module handle we asked about.}

    dlerror;   // clear error state;  dlsym doesn't
    Addr := dlsym(Module, '_DYNAMIC');
    if (Addr <> nil) and (dlerror = nil)
      and (dladdr(Addr, Info) <> 0) then
    begin
      if Info.BaseAddress = ExeBaseAddress then
        Info.FileName := nil;
      FoundInModule := HMODULE(dlopen(Info.FileName, RTLD_LAZY));
      if FoundInModule <> 0 then
        dlclose(FoundInModule);
      if Module = FoundInModule then
      begin
        Result := _strlen(Info.FileName);
        if Result >= BufLen then Result := BufLen-1;
        Move(Info.FileName^, Buffer^, Result);
        Buffer[Result] := #0;
      end;
    end;
  end;
  if Result < 0 then Result := 0;
end;
{$ENDIF}

function DelayLoadResourceModule(Module: PLibModule): LongWord;
var
  FileName: array[0..MAX_PATH] of Char;
begin
  if Module.ResInstance = 0 then
  begin
    GetModuleFileName(Module.Instance, FileName, SizeOf(FileName));
    Module.ResInstance := LoadResourceModule(FileName);
    if Module.ResInstance = 0 then
      Module.ResInstance := Module.Instance;
  end;
  Result := Module.ResInstance;
end;

function FindResourceHInstance(Instance: LongWord): LongWord;
var
  CurModule: PLibModule;
begin
  CurModule := LibModuleList;
  while CurModule <> nil do
  begin
    if (Instance = CurModule.Instance) or
       (Instance = CurModule.CodeInstance) or
       (Instance = CurModule.DataInstance) then
    begin
      Result := DelayLoadResourceModule(CurModule);
      Exit;
    end;
    CurModule := CurModule.Next;
  end;
  Result := Instance;
end;

function LoadResourceModule(ModuleName: PChar; CheckOwner: Boolean): LongWord;
{$IFDEF LINUX}
var
  FileName: array [0..MAX_PATH] of Char;
  LangCode: PChar;  // Language and country code.  Example: en_US
  P: PChar;
  ModuleNameLen, FileNameLen, i: Integer;
  st1, st2: TStatStruct;
begin
  LangCode := __getenv('LANG');
  Result := 0;
  if (LangCode = nil) or (LangCode^ = #0) then Exit;

  // look for modulename.en_US  (ignoring codeset and modifier suffixes)
  P := LangCode;
  while P^ in ['a'..'z', 'A'..'Z', '_'] do
    Inc(P);
  if P = LangCode then Exit;

  if CheckOwner and (__xstat(STAT_VER_LINUX, ModuleName, st1) = -1) then
    Exit;

  ModuleNameLen := _strlen(ModuleName);
  if (ModuleNameLen + P - LangCode) >= MAX_PATH then Exit;
  Move(ModuleName[0], Filename[0], ModuleNameLen);
  Filename[ModuleNameLen] := '.';
  Move(LangCode[0], Filename[ModuleNameLen + 1], P - LangCode);
  FileNameLen := ModuleNameLen + 1 + (P - LangCode);
  Filename[FileNameLen] := #0;

{ Security check:  make sure the user id (owner) and group id of
  the base module matches the user id and group id of the resource
  module we're considering loading.  This is to prevent loading
  of malicious code dropped into the base module's directory by
  a hostile user.  The app and all its resource modules must
  have the same owner and group.  To disable this security check,
  call this function with CheckOwner set to False. }

  if (not CheckOwner) or
    ((__xstat(STAT_VER_LINUX, FileName, st2) <> -1)
    and (st1.st_uid = st2.st_uid)
    and (st1.st_gid = st2.st_gid)) then
  begin
    Result := dlopen(Filename, RTLD_LAZY);
    if Result <> 0 then Exit;
  end;

  // look for modulename.en    (ignoring country code and suffixes)
  i := ModuleNameLen + 1;
  while (i <= FileNameLen) and (Filename[i] in ['a'..'z', 'A'..'Z']) do
    Inc(i);
  if (i = ModuleNameLen + 1) or (i > FileNameLen) then Exit;
  FileName[i] := #0;

  { Security check.  See notes above.  }
  if (not CheckOwner) or
    ((__xstat(STAT_VER_LINUX, FileName, st2) <> -1)
    and (st1.st_uid = st2.st_uid)
    and (st1.st_gid = st2.st_gid)) then
  begin
    Result := dlopen(FileName, RTLD_LAZY);
  end;
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
var
  FileName: array[0..MAX_PATH] of Char;
  Key: LongWord;
  LocaleName, LocaleOverride: array[0..4] of Char;
  Size: Integer;
  P: PChar;

  function FindBS(Current: PChar): PChar;
  begin
    Result := Current;
    while (Result^ <> #0) and (Result^ <> '\') do
      Result := CharNext(Result);
  end;

  function ToLongPath(AFileName: PChar; BufSize: Integer): PChar;
  var
    CurrBS, NextBS: PChar;
    Handle, L: Integer;
    FindData: TWin32FindData;
    Buffer: array[0..MAX_PATH] of Char;
    GetLongPathName: function (ShortPathName: PChar; LongPathName: PChar;
      cchBuffer: Integer): Integer stdcall;
  begin
    Result := AFileName;
    Handle := GetModuleHandle(kernel);
    if Handle <> 0 then
    begin
      @GetLongPathName := GetProcAddress(Handle, 'GetLongPathNameA');
      if Assigned(GetLongPathName) and
        (GetLongPathName(AFileName, Buffer, SizeOf(Buffer)) <> 0) then
      begin
        lstrcpyn(AFileName, Buffer, BufSize);
        Exit;
      end;
    end;

    if AFileName[0] = '\' then
    begin
      if AFileName[1] <> '\' then Exit;
      CurrBS := FindBS(AFileName + 2);  // skip server name
      if CurrBS^ = #0 then Exit;
      CurrBS := FindBS(CurrBS + 1);     // skip share name
      if CurrBS^ = #0 then Exit;
    end else
      CurrBS := AFileName + 2;          // skip drive name

    L := CurrBS - AFileName;
    lstrcpyn(Buffer, AFileName, L + 1);
    while CurrBS^ <> #0 do
    begin
      NextBS := FindBS(CurrBS + 1);
      if L + (NextBS - CurrBS) + 1 > SizeOf(Buffer) then Exit;
      lstrcpyn(Buffer + L, CurrBS, (NextBS - CurrBS) + 1);

      Handle := FindFirstFile(Buffer, FindData);
      if (Handle = -1) then Exit;
      FindClose(Handle);

      if L + 1 + _strlen(FindData.cFileName) + 1 > SizeOf(Buffer) then Exit;
      Buffer[L] := '\';
      lstrcpyn(Buffer + L + 1, FindData.cFileName, Sizeof(Buffer) - L - 1);
      Inc(L, _strlen(FindData.cFileName) + 1);
      CurrBS := NextBS;
    end;
    lstrcpyn(AFileName, Buffer, BufSize);
  end;
begin
  GetModuleFileName(0, FileName, SizeOf(FileName)); // Get host application name
  LocaleOverride[0] := #0;
  if (RegOpenKeyEx(HKEY_CURRENT_USER, NewLocaleOverrideKey, 0, KEY_READ, Key) = 0) or
   (RegOpenKeyEx(HKEY_LOCAL_MACHINE, NewLocaleOverrideKey, 0, KEY_READ, Key) = 0) or
   (RegOpenKeyEx(HKEY_CURRENT_USER, OldLocaleOverrideKey, 0, KEY_READ, Key) = 0) then
  try
    Size := sizeof(LocaleOverride);
    ToLongPath(FileName, sizeof(FileName));
    if RegQueryValueEx(Key, FileName, nil, nil, LocaleOverride, @Size) <> 0 then
      if RegQueryValueEx(Key, '', nil, nil, LocaleOverride, @Size) <> 0 then
        LocaleOverride[0] := #0;
    LocaleOverride[sizeof(LocaleOverride)-1] := #0;
  finally
    RegCloseKey(Key);
  end;
  lstrcpyn(FileName, ModuleName, sizeof(FileName));
  GetLocaleInfo(GetThreadLocale, LOCALE_SABBREVLANGNAME, LocaleName, sizeof(LocaleName));
  Result := 0;
  if (FileName[0] <> #0) and ((LocaleName[0] <> #0) or (LocaleOverride[0] <> #0)) then
  begin
    P := PChar(@FileName) + _strlen(FileName);
    while (P^ <> '.') and (P <> @FileName) do Dec(P);
    if P <> @FileName then
    begin
      Inc(P);
      // First look for a locale registry override
      if LocaleOverride[0] <> #0 then
      begin
        lstrcpyn(P, LocaleOverride, sizeof(FileName) - (P - FileName));
        Result := LoadLibraryEx(FileName, 0, LOAD_LIBRARY_AS_DATAFILE);
      end;
      if (Result = 0) and (LocaleName[0] <> #0) then
      begin
        // Then look for a potential language/country translation
        lstrcpyn(P, LocaleName, sizeof(FileName) - (P - FileName));
        Result := LoadLibraryEx(FileName, 0, LOAD_LIBRARY_AS_DATAFILE);
        if Result = 0 then
        begin
          // Finally look for a language only translation
          LocaleName[2] := #0;
          lstrcpyn(P, LocaleName, sizeof(FileName) - (P - FileName));
          Result := LoadLibraryEx(FileName, 0, LOAD_LIBRARY_AS_DATAFILE);
        end;
      end;
    end;
  end;
end;
{$ENDIF}

procedure EnumModules(Func: TEnumModuleFunc; Data: Pointer); assembler;
begin
  EnumModules(TEnumModuleFuncLW(Func), Data);
end;

procedure EnumResourceModules(Func: TEnumModuleFunc; Data: Pointer);
begin
  EnumResourceModules(TEnumModuleFuncLW(Func), Data);
end;

procedure EnumModules(Func: TEnumModuleFuncLW; Data: Pointer);
var
  CurModule: PLibModule;
begin
  CurModule := LibModuleList;
  while CurModule <> nil do
  begin
    if not Func(CurModule.Instance, Data) then Exit;
    CurModule := CurModule.Next;
  end;
end;

procedure EnumResourceModules(Func: TEnumModuleFuncLW; Data: Pointer);
var
  CurModule: PLibModule;
begin
  CurModule := LibModuleList;
  while CurModule <> nil do
  begin
    if not Func(DelayLoadResourceModule(CurModule), Data) then Exit;
    CurModule := CurModule.Next;
  end;
end;

procedure AddModuleUnloadProc(Proc: TModuleUnloadProc);
begin
  AddModuleUnloadProc(TModuleUnloadProcLW(Proc));
end;

procedure RemoveModuleUnloadProc(Proc: TModuleUnloadProc);
begin
  RemoveModuleUnloadProc(TModuleUnloadProcLW(Proc));
end;

procedure AddModuleUnloadProc(Proc: TModuleUnloadProcLW);
var
  P: PModuleUnloadRec;
begin
  New(P);
  P.Next := ModuleUnloadList;
  @P.Proc := @Proc;
  ModuleUnloadList := P;
end;

procedure RemoveModuleUnloadProc(Proc: TModuleUnloadProcLW);
var
  P, C: PModuleUnloadRec;
begin
  P := ModuleUnloadList;
  if (P <> nil) and (@P.Proc = @Proc) then
  begin
    ModuleUnloadList := ModuleUnloadList.Next;
    Dispose(P);
  end else
  begin
    C := P;
    while C <> nil do
    begin
      if (C.Next <> nil) and (@C.Next.Proc = @Proc) then
      begin
        P := C.Next;
        C.Next := C.Next.Next;
        Dispose(P);
        Break;
      end;
      C := C.Next;
    end;
  end;
end;

procedure NotifyModuleUnload(HInstance: LongWord);
var
  P: PModuleUnloadRec;
begin
  P := ModuleUnloadList;
  while P <> nil do
  begin
    try
      P.Proc(HInstance);
    except
      // Make sure it doesn't stop notifications
    end;
    P := P.Next;
  end;
{$IFDEF LINUX}
  InvalidateModuleCache;
{$ENDIF}
end;

procedure RegisterModule(LibModule: PLibModule);
begin
  LibModule.Next := LibModuleList;
  LibModuleList := LibModule;
end;

{X- procedure UnregisterModule(LibModule: PLibModule); -renamed }
procedure UnRegisterModuleSafely( LibModule: PLibModule );
var
  CurModule: PLibModule;
begin
  try
    NotifyModuleUnload(LibModule.Instance);
  finally
    if LibModule = LibModuleList then
      LibModuleList := LibModule.Next
    else
    begin
      CurModule := LibModuleList;
      while CurModule <> nil do
      begin
        if CurModule.Next = LibModule then
        begin
          CurModule.Next := LibModule.Next;
          Break;
        end;
        CurModule := CurModule.Next;
      end;
    end;
  end;
end;

{X+} // "Light" version of UnRegisterModule - without using of try-except
procedure UnRegisterModuleLight( LibModule: PLibModule );
var
  P: PModuleUnloadRec;
begin
  P := ModuleUnloadList;
  while P <> nil do
  begin
    P.Proc(LibModule.Instance);
    P := P.Next;
  end;
end;
{X-}

function _IntfClear(var Dest: IInterface): Pointer;
{$IFDEF PUREPASCAL}
var
  P: Pointer;
begin
  Result := @Dest;
  if Dest <> nil then
  begin
    P := Pointer(Dest);
    Pointer(Dest) := nil;
    IInterface(P)._Release;
  end;
end;
{$ELSE}
asm
        MOV     EDX,[EAX]
        TEST    EDX,EDX
        JE      @@1
        MOV     DWORD PTR [EAX],0
        PUSH    EAX
        PUSH    EDX
        MOV     EAX,[EDX]
        CALL    DWORD PTR [EAX] + VMTOFFSET IInterface._Release
        POP     EAX
@@1:
end;
{$ENDIF}

procedure _IntfCopy(var Dest: IInterface; const Source: IInterface);
{$IFDEF PUREPASCAL}
var
  P: Pointer;
begin
  P := Pointer(Dest);
  if Source <> nil then
    Source._AddRef;
  Pointer(Dest) := Pointer(Source);
  if P <> nil then
    IInterface(P)._Release;
end;
{$ELSE}
asm
{
  The most common case is the single assignment of a non-nil interface
  to a nil interface.  So we streamline that case here.  After this,
  we give essentially equal weight to other outcomes.

    The semantics are:  The source intf must be addrefed *before* it
    is assigned to the destination.  The old intf must be released
    after the new intf is addrefed to support self assignment (I := I).
    Either intf can be nil.  The first requirement is really to make an
    error case function a little better, and to improve the behaviour
    of multithreaded applications - if the addref throws an exception,
    you don't want the interface to have been assigned here, and if the
    assignment is made to a global and another thread references it,
    again you don't want the intf to be available until the reference
    count is bumped.
}
        TEST    EDX,EDX         // is source nil?
        JE      @@NilSource
        PUSH    EDX             // save source
        PUSH    EAX             // save dest
        MOV     EAX,[EDX]       // get source vmt
        PUSH    EDX             // source as arg
        CALL    DWORD PTR [EAX] + VMTOFFSET IInterface._AddRef
        POP     EAX             // retrieve dest
        MOV     ECX, [EAX]      // get current value
        POP     [EAX]         // set dest in place
        TEST    ECX, ECX        // is current value nil?
        JNE     @@ReleaseDest   // no, release it
        RET                     // most common case, we return here
@@ReleaseDest:
        MOV     EAX,[ECX]       // get current value vmt
        PUSH    ECX             // current value as arg
        CALL    DWORD PTR [EAX] + VMTOFFSET IInterface._Release
        RET

{   Now we're into the less common cases.  }
@@NilSource:
        MOV     ECX, [EAX]      // get current value
        TEST    ECX, ECX        // is it nil?
        MOV     [EAX], EDX      // store in dest (which is nil)
        JE  @@Done
        MOV     EAX, [ECX]      // get current vmt
        PUSH    ECX             // current value as arg
        CALL    [EAX].vmtRelease.Pointer
@@Done:
end;
{$ENDIF}

procedure _IntfCast(var Dest: IInterface; const Source: IInterface; const IID: TGUID);
{$IFDEF PUREPASCAL}
// PIC:  EBX must be correct before calling QueryInterface
begin
  if Source = nil then
    Dest := nil
  else if Source.QueryInterface(IID, Dest) <> 0 then
    Error(reIntfCastError);
end;
{$ELSE}
asm
        TEST    EDX,EDX
        JE      _IntfClear
        PUSH    EAX
        PUSH    ECX
        PUSH    EDX
        MOV     ECX,[EAX]
        TEST    ECX,ECX
        JE      @@1
        PUSH    ECX
        MOV     EAX,[ECX]
        CALL    DWORD PTR [EAX] + VMTOFFSET IInterface._Release
        MOV     EDX,[ESP]
@@1:    MOV     EAX,[EDX]
        CALL    DWORD PTR [EAX] + VMTOFFSET IInterface.QueryInterface
        TEST    EAX,EAX
        JE      @@2
        MOV     AL,reIntfCastError
        JMP     Error
@@2:
end;
{$ENDIF}

procedure _IntfAddRef(const Dest: IInterface);
begin
  if Dest <> nil then Dest._AddRef;
end;

procedure TInterfacedObject.AfterConstruction;
begin
// Release the constructor's implicit refcount
  InterlockedDecrement(FRefCount);
end;

procedure TInterfacedObject.BeforeDestruction;
begin
  if RefCount <> 0 then
    Error(reInvalidPtr);
end;

// Set an implicit refcount so that refcounting
// during construction won't destroy the object.
class function TInterfacedObject.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  TInterfacedObject(Result).FRefCount := 1;
end;

function TInterfacedObject.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TInterfacedObject._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TInterfacedObject._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then
    Destroy;
end;

{ TAggregatedObject }

constructor TAggregatedObject.Create(const Controller: IInterface);
begin
  // weak reference to controller - don't keep it alive
  FController := Pointer(Controller);
end;

function TAggregatedObject.GetController: IInterface;
begin
  Result := IInterface(FController);
end;

function TAggregatedObject.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  Result := IInterface(FController).QueryInterface(IID, Obj);
end;

function TAggregatedObject._AddRef: Integer;
begin
  Result := IInterface(FController)._AddRef;
end;

function TAggregatedObject._Release: Integer; stdcall;
begin
  Result := IInterface(FController)._Release;
end;

{ TContainedObject }

function TContainedObject.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;


function _CheckAutoResult(ResultCode: HResult): HResult;
{$IF Defined(PIC) or Defined(PUREPASCAL)}
begin
  if ResultCode < 0 then
  begin
    if Assigned(SafeCallErrorProc) then
      SafeCallErrorProc(ResultCode, Pointer(-1));  // loses error address
    Error(reSafeCallError);
  end;
  Result := ResultCode;
end;
{$ELSE}
asm
        TEST    EAX,EAX
        JNS     @@2
        MOV     ECX,SafeCallErrorProc
        TEST    ECX,ECX
        JE      @@1
        MOV     EDX,[ESP]
        CALL    ECX
@@1:    MOV     AL,reSafeCallError
        JMP     Error
@@2:
end;
{$IFEND}

function  CompToDouble(Value: Comp): Double; cdecl;
begin
  Result := Value;
end;

procedure  DoubleToComp(Value: Double; var Result: Comp); cdecl;
begin
  Result := Value;
end;

function  CompToCurrency(Value: Comp): Currency; cdecl;
begin
  Result := Value;
end;

procedure  CurrencyToComp(Value: Currency; var Result: Comp); cdecl;
begin
  Result := Value;
end;

function GetMemory(Size: Integer): Pointer; cdecl;
begin
  Result := MemoryManager.GetMem(Size);
end;

function FreeMemory(P: Pointer): Integer; cdecl;
begin
  if P = nil then
    Result := 0
  else
    Result := MemoryManager.FreeMem(P);
end;

function ReallocMemory(P: Pointer; Size: Integer): Pointer; cdecl;
begin
  Result := MemoryManager.ReallocMem(P, Size);
end;

procedure SetLineBreakStyle(var T: Text; Style: TTextLineBreakStyle);
begin
  if TTextRec(T).Mode = fmClosed then
    TTextRec(T).Flags := TTextRec(T).Flags or (tfCRLF * Byte(Style))
  else
    SetInOutRes(107);  // can't change mode of open file
end;

// UnicodeToUTF8(3):
// Scans the source data to find the null terminator, up to MaxBytes
// Dest must have MaxBytes available in Dest.

function UnicodeToUtf8(Dest: PChar; Source: PWideChar; MaxBytes: Integer): Integer;
var
  len: Cardinal;
begin
  len := 0;
  if Source <> nil then
    while Source[len] <> #0 do
      Inc(len);
  Result := UnicodeToUtf8(Dest, MaxBytes, Source, len);
end;

// UnicodeToUtf8(4):
// MaxDestBytes includes the null terminator (last char in the buffer will be set to null)
// Function result includes the null terminator.
// Nulls in the source data are not considered terminators - SourceChars must be accurate

function UnicodeToUtf8(Dest: PChar; MaxDestBytes: Cardinal; Source: PWideChar; SourceChars: Cardinal): Cardinal;
var
  i, count: Cardinal;
  c: Cardinal;
begin
  Result := 0;
  if Source = nil then Exit;
  count := 0;
  i := 0;
  if Dest <> nil then
  begin
    while (i < SourceChars) and (count < MaxDestBytes) do
    begin
      c := Cardinal(Source[i]);
      Inc(i);
      if c <= $7F then
      begin
        Dest[count] := Char(c);
        Inc(count);
      end
      else if c > $7FF then
      begin
        if count + 3 > MaxDestBytes then
          break;
        Dest[count] := Char($E0 or (c shr 12));
        Dest[count+1] := Char($80 or ((c shr 6) and $3F));
        Dest[count+2] := Char($80 or (c and $3F));
        Inc(count,3);
      end
      else //  $7F < Source[i] <= $7FF
      begin
        if count + 2 > MaxDestBytes then
          break;
        Dest[count] := Char($C0 or (c shr 6));
        Dest[count+1] := Char($80 or (c and $3F));
        Inc(count,2);
      end;
    end;
    if count >= MaxDestBytes then count := MaxDestBytes-1;
    Dest[count] := #0;
  end
  else
  begin
    while i < SourceChars do
    begin
      c := Integer(Source[i]);
      Inc(i);
      if c > $7F then
      begin
        if c > $7FF then
          Inc(count);
        Inc(count);
      end;
      Inc(count);
    end;
  end;
  Result := count+1;  // convert zero based index to byte count
end;

function Utf8ToUnicode(Dest: PWideChar; Source: PChar; MaxChars: Integer): Integer;
var
  len: Cardinal;
begin
  len := 0;
  if Source <> nil then
    while Source[len] <> #0 do
      Inc(len);
  Result := Utf8ToUnicode(Dest, MaxChars, Source, len);
end;

function Utf8ToUnicode(Dest: PWideChar; MaxDestChars: Cardinal; Source: PChar; SourceBytes: Cardinal): Cardinal;
var
  i, count: Cardinal;
  c: Byte;
  wc: Cardinal;
begin
  if Source = nil then
  begin
    Result := 0;
    Exit;
  end;
  Result := Cardinal(-1);
  count := 0;
  i := 0;
  if Dest <> nil then
  begin
    while (i < SourceBytes) and (count < MaxDestChars) do
    begin
      wc := Cardinal(Source[i]);
      Inc(i);
      if (wc and $80) <> 0 then
      begin
        wc := wc and $3F;
        if i > SourceBytes then Exit;           // incomplete multibyte char
        if (wc and $20) <> 0 then
        begin
          c := Byte(Source[i]);
          Inc(i);
          if (c and $C0) <> $80 then  Exit;     // malformed trail byte or out of range char
          if i > SourceBytes then Exit;         // incomplete multibyte char
          wc := (wc shl 6) or (c and $3F);
        end;
        c := Byte(Source[i]);
        Inc(i);
        if (c and $C0) <> $80 then Exit;       // malformed trail byte

        Dest[count] := WideChar((wc shl 6) or (c and $3F));
      end
      else
        Dest[count] := WideChar(wc);
      Inc(count);
    end;
	if count >= MaxDestChars then count := MaxDestChars-1;
	Dest[count] := #0;
  end
  else
  begin
	while (i <= SourceBytes) do
	begin
	  c := Byte(Source[i]);
	  Inc(i);
	  if (c and $80) <> 0 then
	  begin
		if (c and $F0) = $F0 then Exit;  // too many bytes for UCS2
		if (c and $40) = 0 then Exit;    // malformed lead byte
		if i > SourceBytes then Exit;         // incomplete multibyte char

		if (Byte(Source[i]) and $C0) <> $80 then Exit;  // malformed trail byte
		Inc(i);
		if i > SourceBytes then Exit;         // incomplete multibyte char
		if ((c and $20) <> 0) and ((Byte(Source[i]) and $C0) <> $80) then Exit; // malformed trail byte
		Inc(i);
	  end;
	  Inc(count);
	end;
  end;
  Result := count+1;
end;

function Utf8Encode(const WS: WideString): UTF8String;
var
  L: Integer;
  Temp: UTF8String;
begin
  Result := '';
  if WS = '' then Exit;
  SetLength(Temp, Length(WS) * 3); // SetLength includes space for null terminator

  L := UnicodeToUtf8(PChar(Temp), Length(Temp)+1, PWideChar(WS), Length(WS));
  if L > 0 then
    SetLength(Temp, L-1)
  else
    Temp := '';
  Result := Temp;
end;

function Utf8Decode(const S: UTF8String): WideString;
var
  L: Integer;
  Temp: WideString;
begin
  Result := '';
  if S = '' then Exit;
  SetLength(Temp, Length(S));

  L := Utf8ToUnicode(PWideChar(Temp), Length(Temp)+1, PChar(S), Length(S));
  if L > 0 then
    SetLength(Temp, L-1)
  else
    Temp := '';
  Result := Temp;
end;

function AnsiToUtf8(const S: string): UTF8String;
begin
  Result := Utf8Encode(S);
end;

function Utf8ToAnsi(const S: UTF8String): string;
begin
  Result := Utf8Decode(S);
end;

{$IFDEF LINUX}

function GetCPUType: Integer;
asm
      PUSH      EBX
    // this code assumes ESP is 4 byte aligned
    // test for 80386:  see if bit #18 of EFLAGS (Alignment fault) can be toggled
      PUSHF
      POP       EAX
      MOV       ECX, EAX
      XOR       EAX, $40000   // flip AC bit in EFLAGS
      PUSH      EAX
      POPF
      PUSHF
      POP       EAX
      XOR       EAX, ECX      // zero = 80386 CPU (can't toggle AC bit)
      MOV       EAX, CPUi386
      JZ        @@Exit
      PUSH      ECX
      POPF                    // restore original flags before next test

      // test for 80486:  see if bit #21 of EFLAGS (CPUID supported) can be toggled
      MOV       EAX, ECX        // get original EFLAGS
      XOR       EAX, $200000    // flip CPUID bit in EFLAGS
      PUSH      EAX
      POPF
      PUSHF
      POP       EAX
      XOR       EAX, ECX    // zero = 80486 (can't toggle EFLAGS bit #21)
      MOV       EAX, CPUi486
      JZ        @@Exit

      // Use CPUID instruction to get CPU family
      XOR       EAX, EAX
      CPUID
      CMP       EAX, 1
      JL        @@Exit          // unknown processor response: report as 486
      XOR       EAX, EAX
      INC       EAX       // we only care about info level 1
      CPUID
      AND       EAX, $F00
      SHR       EAX, 8
      // Test8086 values are one less than the CPU model number, for historical reasons
      DEC       EAX

@@Exit:
      POP       EBX
end;


const
  sResSymExport = '@Sysinit@ResSym';
  sResStrExport = '@Sysinit@ResStr';
  sResHashExport = '@Sysinit@ResHash';

type
  TElf32Sym = record
    Name: Cardinal;
    Value: Pointer;
    Size: Cardinal;
    Info: Byte;
    Other: Byte;
    Section: Word;
  end;
  PElf32Sym = ^TElf32Sym;

  TElfSymTab = array [0..0] of TElf32Sym;
  PElfSymTab = ^TElfSymTab;

  TElfWordTab = array [0..2] of Cardinal;
  PElfWordTab = ^TElfWordTab;


{ If Name encodes a numeric identifier, return it, else return -1.  }
function NameToId(Name: PChar): Longint;
var digit: Longint;
begin
  if Longint(Name) and $ffff0000 = 0 then
  begin
    Result := Longint(Name) and $ffff;
  end
  else if Name^ = '#' then
  begin
    Result := 0;
    inc (Name);
    while (Ord(Name^) <> 0) do
    begin
      digit := Ord(Name^) - Ord('0');
      if (LongWord(digit) > 9) then
      begin
        Result := -1;
        exit;
      end;
      Result := Result * 10 + digit;
      inc (Name);
    end;
  end
  else
    Result := -1;
end;


// Return ELF hash value for NAME converted to lower case.
function ElfHashLowercase(Name: PChar): Cardinal;
var
  g: Cardinal;
  c: Char;
begin
  Result := 0;
  while name^ <> #0 do
  begin
    c := name^;
    case c of
      'A'..'Z': Inc(c, Ord('a') - Ord('A'));
    end;
    Result := (Result shl 4) + Ord(c);
    g := Result and $f0000000;
    Result := (Result xor (g shr 24)) and not g;
    Inc(name);
  end;
end;

type
  PFindResourceCache = ^TFindResourceCache;
  TFindResourceCache = record
    ModuleHandle: HMODULE;
    Version: Cardinal;
    SymbolTable: PElfSymTab;
    StringTable: PChar;
    HashTable: PElfWordTab;
    BaseAddress: Cardinal;
  end;

threadvar
  FindResourceCache: TFindResourceCache;

function GetResourceCache(ModuleHandle: HMODULE): PFindResourceCache;
var
  info: TDLInfo;
begin
  Result := @FindResourceCache;
  if (ModuleHandle <> Result^.ModuleHandle) or (ModuleCacheVersion <> Result^.Version) then
  begin
    Result^.SymbolTable := dlsym(ModuleHandle, sResSymExport);
    Result^.StringTable := dlsym(ModuleHandle, sResStrExport);
    Result^.HashTable := dlsym(ModuleHandle, sResHashExport);
    Result^.ModuleHandle := ModuleHandle;
    if (dladdr(Result^.HashTable, Info) = 0) or (Info.BaseAddress = ExeBaseAddress) then
      Result^.BaseAddress := 0   // if it's not in a library, assume the exe
    else
      Result^.BaseAddress := Cardinal(Info.BaseAddress);
    Result^.Version := ModuleCacheVersion;
  end;
end;

function FindResource(ModuleHandle: HMODULE; ResourceName: PChar; ResourceType: PChar): TResourceHandle;
var
  P: PFindResourceCache;
  nid, tid: Longint;
  ucs2_key: array [0..2] of WideChar;
  key: array [0..127] of Char;
  len: Integer;
  pc: PChar;
  ch: Char;
  nbucket: Cardinal;
  bucket, chain: PElfWordTab;
  syndx: Cardinal;
begin
  Result := 0;
  if ResourceName = nil then Exit;
  P := GetResourceCache(ModuleHandle);

  tid := NameToId (ResourceType);
  if tid = -1 then Exit;  { not supported (yet?) }

  { This code must match util-common/elfres.c }
  nid := NameToId (ResourceName);
  if nid = -1 then
  begin
    ucs2_key[0] := WideChar(2*tid+2);
    ucs2_key[1] := WideChar(0);
    len := UnicodeToUtf8 (key, ucs2_key, SizeOf (key));
    pc := key+len;
    while Ord(ResourceName^) <> 0 do
    begin
      ch := ResourceName^;
      if Ord(ch) > 127 then exit; { insist on 7bit ASCII for now }
      if ('A' <= ch) and (ch <= 'Z') then Inc(ch, Ord('a') - Ord('A'));
      pc^ := ch;
      inc (pc);
      if pc = key + SizeOf(key) then exit;
      inc (ResourceName);
    end;
    pc^ := Char(0);
  end
  else
  begin
    ucs2_key[0] := WideChar(2*tid+1);
    ucs2_key[1] := WideChar(nid);
    ucs2_key[2] := WideChar(0);
    UnicodeToUtf8 (key, ucs2_key, SizeOf (key));
  end;

  with P^ do
  begin
    nbucket := HashTable[0];
  //  nsym := HashTable[1];
    bucket := @HashTable[2];
    chain := @HashTable[2+nbucket];

    syndx := bucket[ElfHashLowercase(key) mod nbucket];
    while (syndx <> 0)
      and (strcasecmp(key, @StringTable[SymbolTable[syndx].Name]) <> 0) do
      syndx := chain[syndx];

    if syndx = 0 then
      Result := 0
    else
      Result := TResourceHandle(@SymbolTable[syndx]);
  end;
end;

function LoadResource(ModuleHandle: HMODULE; ResHandle: TResourceHandle): HGLOBAL;
var
  P: PFindResourceCache;
begin
  if ResHandle <> 0 then
  begin
    P := GetResourceCache(ModuleHandle);
    Result := HGLOBAL(PElf32Sym(ResHandle)^.Value);
    Inc (Cardinal(Result), P^.BaseAddress);
  end
  else
    Result := 0;
end;

function SizeofResource(ModuleHandle: HMODULE; ResHandle: TResourceHandle): Integer;
begin
  if ResHandle <> 0 then
    Result := PElf32Sym(ResHandle)^.Size
  else
    Result := 0;
end;

function LockResource(ResData: HGLOBAL): Pointer;
begin
  Result := Pointer(ResData);
end;

function UnlockResource(ResData: HGLOBAL): LongBool;
begin
  Result := False;
end;

function FreeResource(ResData: HGLOBAL): LongBool;
begin
  Result := True;
end;
{$ENDIF}

{ ResString support function }

{$IFDEF MSWINDOWS}
function LoadResString(ResStringRec: PResStringRec): string;
var
  Buffer: array [0..1023] of char;
begin
  if ResStringRec = nil then Exit;
  if ResStringRec.Identifier < 64*1024 then
    SetString(Result, Buffer,
      LoadString(FindResourceHInstance(ResStringRec.Module^),
        ResStringRec.Identifier, Buffer, SizeOf(Buffer)))
  else
    Result := PChar(ResStringRec.Identifier);
end;
{$ENDIF}
{$IFDEF LINUX}

const
  ResStringTableLen = 16;

type
  ResStringTable = array [0..ResStringTableLen-1] of LongWord;

function LoadResString(ResStringRec: PResStringRec): string;
var
  Handle: TResourceHandle;
  Tab: ^ResStringTable;
  ResMod: HMODULE;
begin
  if ResStringRec = nil then Exit;
  ResMod := FindResourceHInstance(ResStringRec^.Module^);
  Handle := FindResource(ResMod,
       PChar(ResStringRec^.Identifier div ResStringTableLen),
       PChar(6));   // RT_STRING
  Tab := Pointer(LoadResource(ResMod, Handle));
  if Tab = nil then
    Result := ''
  else
    Result := PChar (Tab) + Tab[ResStringRec^.Identifier mod ResStringTableLen];
end;

procedure DbgUnlockX;
begin
  if Assigned(DbgUnlockXProc) then
    DbgUnlockXProc;
end;

{ The Win32 program loader sets up the first 64k of process address space
  with no read or write access, to help detect use of invalid pointers
  (whose integer value is 0..64k).  Linux doesn't do this.

  Parts of the Delphi RTL and IDE design environment
  rely on the notion that pointer values in the [0..64k] range are
  invalid pointers.  To accomodate this in Linux, we reserve the range
  at startup.  If the range is already allocated, we keep going anyway. }

var
  ZeroPageReserved: Boolean = False;

procedure ReserveZeroPage;
const
  PROT_NONE = 0;
  MAP_PRIVATE   = $02;
  MAP_FIXED     = $10;
  MAP_ANONYMOUS = $20;
var
  P: Pointer;
begin
  if IsLibrary then Exit;  // page reserve is app's job, not .so's

  if not ZeroPageReserved then
  begin
    P := mmap(nil, High(Word), PROT_NONE,
      MAP_ANONYMOUS or MAP_PRIVATE or MAP_FIXED, 0, 0);
    ZeroPageReserved := P = nil;
    if (Integer(P) <> -1) and (P <> nil) then  // we didn't get it
      munmap(P, High(Word));
  end;
end;

procedure ReleaseZeroPage;
begin
  if ZeroPageReserved then
  begin
    munmap(nil, High(Word) - 4096);
    ZeroPageReserved := False;
  end;
end;
{$ENDIF}

function PUCS4Chars(const S: UCS4String): PUCS4Char;
const
  Null: UCS4Char = 0;
  PNull: PUCS4Char = @Null;
begin
  if Length(S) > 0 then
    Result := @S[0]
  else
    Result := PNull;
end;

function WideStringToUCS4String(const S: WideString): UCS4String;
var
  I: Integer;
begin
  SetLength(Result, Length(S) + 1);
  for I := 0 to Length(S) - 1 do
    Result[I] := UCS4Char(S[I + 1]);
  Result[Length(S)] := 0;
end;

function UCS4StringToWidestring(const S: UCS4String): WideString;
var
  I: Integer;
begin
  SetLength(Result, Length(S));
  for I := 0 to Length(S)-1 do
    Result[I+1] := WideChar(S[I]);
  Result[Length(S)] := #0;
end;

var SaveCmdShow : Integer = -1;
function CmdShow: Integer;
var
  SI: TStartupInfo;
begin
  if SaveCmdShow < 0 then
  begin
    SaveCmdShow := 10;                  { SW_SHOWDEFAULT }
    GetStartupInfo(SI);
    if SI.dwFlags and 1 <> 0 then  { STARTF_USESHOWWINDOW }
      SaveCmdShow := SI.wShowWindow;
  end;
  Result := SaveCmdShow;
end;

{X} // convert var CmdLine : PChar to a function:
{X} function CmdLine : PChar;
{X} begin
{X}   Result := GetCommandLine;
{X} end;

initialization

  {$IFDEF MSWINDOWS}
      {$IFDEF USE_PROCESS_HEAP}
        HeapHandle := GetProcessHeap;
      {$ELSE}
        HeapHandle := HeapCreate( 0, 0, 0 );
      {$ENDIF}
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  //{X (initialized statically} FileMode := 2;
  {$ELSE}
  FileMode := 2;
  {$ENDIF}

{$IFDEF LINUX}
  FileAccessRights := S_IRUSR or S_IWUSR or S_IRGRP or S_IWGRP or S_IROTH or S_IWOTH;
  Test8086 := GetCPUType;
  IsConsole := True;
  FindResourceCache.ModuleHandle := LongWord(-1);
  ReserveZeroPage;
{$ELSE}
  //{X (initialized statically} Test8086 := 2;
{$ENDIF}

  DispCallByIDProc := @_DispCallByIDError;

{$IFDEF MSWINDOWS}
  //{X} if _isNECWindows then _FpuMaskInit;
{$ENDIF}
  //{X} _FpuInit();

  TTextRec(Input).Mode := fmClosed;
  TTextRec(Output).Mode := fmClosed;
  TTextRec(ErrOutput).Mode := fmClosed;
  InitVariantManager;

{$IFDEF MSWINDOWS}
{X-  CmdLine := GetCommandLine; converted to a function }
{X-  CmdShow := GetCmdShow;     converted to a function }
{$ENDIF}
  MainThreadID := GetCurrentThreadID;

{$IFDEF LINUX}
  // Ensure DbgUnlockX is linked in, calling it now does nothing
  DbgUnlockX;
{$ENDIF}

finalization
  {X+}
  {X}   CloseInputOutput;
  {X-
  Close(Input);
  Close(Output);
  Close(ErrOutput);
  X+}
{$IFDEF LINUX}
  ReleaseZeroPage;
{$ENDIF}
{$IFDEF MSWINDOWS}
{X  UninitAllocator; - replaced with call to UninitMemoryManager handler. }
  UninitMemoryManager;
{$ENDIF}
end.

