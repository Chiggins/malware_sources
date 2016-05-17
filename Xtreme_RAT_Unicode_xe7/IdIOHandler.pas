

unit IdIOHandler;

interface

{$I IdCompilerDefines.inc}

uses
  Classes,
  IdException,
  IdAntiFreezeBase, IdBuffer, IdBaseComponent, IdComponent, IdGlobal, IdExceptionCore,
  IdIntercept, IdResourceStringsCore, IdStream;

const
  GRecvBufferSizeDefault = 32 * 1024;
  GSendBufferSizeDefault = 32 * 1024;
  IdMaxLineLengthDefault = 16 * 1024;
  // S.G. 6/4/2004: Maximum number of lines captured
  // S.G. 6/4/2004: Default to "unlimited"
  Id_IOHandler_MaxCapturedLines = -1;

type

  EIdIOHandler = class(EIdException);
  EIdIOHandlerRequiresLargeStream = class(EIdIOHandler);
  EIdIOHandlerStreamDataTooLarge = class(EIdIOHandler);

  TIdIOHandlerClass = class of TIdIOHandler;

  
  TIdIOHandler = class(TIdComponent)
  private
    FLargeStream: Boolean;
  protected
    FClosedGracefully: Boolean;
    FConnectTimeout: Integer;
    FDestination: string;
    FHost: string;
    // IOHandlers typically receive more data than they need to complete each
    // request. They store this extra data in InputBuffer for future methods to
    // use. InputBuffer is what collects the input and keeps it if the current
    // method does not need all of it.
    //
    FInputBuffer: TIdBuffer;
    {$IFDEF USE_OBJECT_ARC}[Weak]{$ENDIF} FIntercept: TIdConnectionIntercept;
    FMaxCapturedLines: Integer;
    FMaxLineAction: TIdMaxLineAction;
    FMaxLineLength: Integer;
    FOpened: Boolean;
    FPort: Integer;
    FReadLnSplit: Boolean;
    FReadLnTimedOut: Boolean;
    FReadTimeOut: Integer;
       
    FRecvBufferSize: Integer;
    FSendBufferSize: Integer;

    FWriteBuffer: TIdBuffer;
    FWriteBufferThreshold: Integer;
    FDefStringEncoding : IIdTextEncoding;
    {$IFDEF STRING_IS_ANSI}
    FDefAnsiEncoding : IIdTextEncoding;
    {$ENDIF}
    procedure SetDefStringEncoding(const AEncoding : IIdTextEncoding);
    {$IFDEF STRING_IS_ANSI}
    procedure SetDefAnsiEncoding(const AEncoding: IIdTextEncoding);
    {$ENDIF}
    //
    procedure BufferRemoveNotify(ASender: TObject; ABytes: Integer);
    function GetDestination: string; virtual;
    procedure InitComponent; override;
    procedure InterceptReceive(var VBuffer: TIdBytes);
    {$IFNDEF USE_OBJECT_ARC}
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    {$ENDIF}
    procedure PerformCapture(const ADest: TObject; out VLineCount: Integer;
     const ADelim: string; AUsesDotTransparency: Boolean; AByteEncoding: IIdTextEncoding = nil
     {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
     ); virtual;
    procedure RaiseConnClosedGracefully;
    procedure SetDestination(const AValue: string); virtual;
    procedure SetHost(const AValue: string); virtual;
    procedure SetPort(AValue: Integer); virtual;
    procedure SetIntercept(AValue: TIdConnectionIntercept); virtual;
    // This is the main Read function which all other default implementations
    // use.
    function ReadFromSource(ARaiseExceptionIfDisconnected: Boolean = True;
     ATimeout: Integer = IdTimeoutDefault;
     ARaiseExceptionOnTimeout: Boolean = True): Integer;
    function ReadDataFromSource(var VBuffer: TIdBytes): Integer; virtual; abstract;
    function WriteDataToTarget(const ABuffer: TIdBytes; const AOffset, ALength: Integer): Integer; virtual; abstract;
    function SourceIsAvailable: Boolean; virtual; abstract;
    function CheckForError(ALastResult: Integer): Integer; virtual; abstract;
    procedure RaiseError(AError: Integer); virtual; abstract;
  public
    procedure AfterAccept; virtual;
    function Connected: Boolean; virtual;
    destructor Destroy; override;
    // CheckForDisconnect allows the implementation to check the status of the
    // connection at the request of the user or this base class.
    procedure CheckForDisconnect(ARaiseExceptionIfDisconnected: Boolean = True;
     AIgnoreBuffer: Boolean = False); virtual; abstract;
    // Does not wait or raise any exceptions. Just reads whatever data is
    // available (if any) into the buffer. Must NOT raise closure exceptions.
    // It is used to get avialable data, and check connection status. That is
    // it can set status flags about the connection.
    function CheckForDataOnSource(ATimeout: Integer = 0): Boolean; virtual;
    procedure Close; virtual;
    procedure CloseGracefully; virtual;
    class function MakeDefaultIOHandler(AOwner: TComponent = nil)
     : TIdIOHandler;
    class function MakeIOHandler(ABaseType: TIdIOHandlerClass;
     AOwner: TComponent = nil): TIdIOHandler;
    class procedure RegisterIOHandler;
    class procedure SetDefaultClass;
    function WaitFor(const AString: string; ARemoveFromBuffer: Boolean = True;
      AInclusive: Boolean = False; AByteEncoding: IIdTextEncoding = nil;
      ATimeout: Integer = IdTimeoutDefault
      {$IFDEF STRING_IS_ANSI}; AAnsiEncoding: IIdTextEncoding = nil{$ENDIF}
      ): string;
    // This is different than WriteDirect. WriteDirect goes
    // directly to the network or next level. WriteBuffer allows for buffering
    // using WriteBuffers. This should be the only call to WriteDirect
    // unless the calls that bypass this are aware of WriteBuffering or are
    // intended to bypass it.
    procedure Write(const ABuffer: TIdBytes; const ALength: Integer = -1; const AOffset: Integer = 0); overload; virtual;
    // This is the main write function which all other default implementations
    // use. If default implementations are used, this must be implemented.
    procedure WriteDirect(const ABuffer: TIdBytes; const ALength: Integer = -1; const AOffset: Integer = 0);
    //
    procedure Open; virtual;
    function Readable(AMSec: Integer = IdTimeoutDefault): Boolean; virtual;
    //
    // Optimal Extra Methods
    //
    // These methods are based on the core methods. While they can be
    // overridden, they are so simple that it is rare a more optimal method can
    // be implemented. Because of this they are not overrideable.
    //
    //
    // Write Methods
    //
    // Only the ones that have a hope of being better optimized in descendants
    // have been marked virtual
    procedure Write(const AOut: string; AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ASrcEncoding: IIdTextEncoding = nil{$ENDIF}
      ); overload; virtual;
    procedure WriteLn(AEncoding: IIdTextEncoding = nil); overload;
    procedure WriteLn(const AOut: string; AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ASrcEncoding: IIdTextEncoding = nil{$ENDIF}
      ); overload; virtual;
    procedure WriteLnRFC(const AOut: string = ''; AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ASrcEncoding: IIdTextEncoding = nil{$ENDIF}
      ); virtual;
    procedure Write(AValue: TStrings; AWriteLinesCount: Boolean = False;
      AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ASrcEncoding: IIdTextEncoding = nil{$ENDIF}
      ); overload; virtual;
    procedure Write(AValue: Byte); overload;
    procedure Write(AValue: Char; AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ASrcEncoding: IIdTextEncoding = nil{$ENDIF}
      ); overload;
    procedure Write(AValue: LongWord; AConvert: Boolean = True); overload;
    procedure Write(AValue: LongInt; AConvert: Boolean = True); overload;
    procedure Write(AValue: Word; AConvert: Boolean = True); overload;
    procedure Write(AValue: SmallInt; AConvert: Boolean = True); overload;
    procedure Write(AValue: Int64; AConvert: Boolean = True); overload;
    procedure Write(AStream: TStream; ASize: TIdStreamSize = 0;
      AWriteByteCount: Boolean = False; TransferInfo: TObject = nil); overload; virtual;
    procedure WriteRFCStrings(AStrings: TStrings; AWriteTerminator: Boolean = True;
      AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ASrcEncoding: IIdTextEncoding = nil{$ENDIF}
      );
    // Not overloaded because it does not have a unique type for source
    // and could be easily unresolvable with future additions
    function WriteFile(const AFile: String; AEnableTransferFile: Boolean = False): Int64; virtual;
    //
    // Read methods
    //
    function AllData(AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ): string; virtual;
    function InputLn(const AMask: string = ''; AEcho: Boolean = True;
      ATabWidth: Integer = 8; AMaxLineLength: Integer = -1;
      AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; AAnsiEncoding: IIdTextEncoding = nil{$ENDIF}
      ): string; virtual;
    // Capture
    // Not virtual because each calls PerformCapture which is virtual
    procedure Capture(ADest: TStream; AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ); overload; // .Net overload
    procedure Capture(ADest: TStream; ADelim: string;
      AUsesDotTransparency: Boolean = True; AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ); overload;
    procedure Capture(ADest: TStream; out VLineCount: Integer;
      const ADelim: string = '.'; AUsesDotTransparency: Boolean = True;
      AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ); overload;
    procedure Capture(ADest: TStrings; AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ); overload; // .Net overload
    procedure Capture(ADest: TStrings; const ADelim: string;
      AUsesDotTransparency: Boolean = True; AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ); overload;
    procedure Capture(ADest: TStrings; out VLineCount: Integer;
      const ADelim: string = '.'; AUsesDotTransparency: Boolean = True;
      AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ); overload;
    //
    // Read___
    // Cannot overload, compiler cannot overload on return values
    //
    procedure ReadBytes(var VBuffer: TIdBytes; AByteCount: Integer; AAppend: Boolean = True ;TransferInfo: TObject = nil); virtual;
    // ReadLn
    function ReadLn(AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ): string; overload; // .Net overload
    function ReadLn(ATerminator: string; AByteEncoding: IIdTextEncoding
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ): string; overload;
    function ReadLn(ATerminator: string; ATimeout: Integer = IdTimeoutDefault;
      AMaxLineLength: Integer = -1; AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ): string; overload; virtual;
    //RLebeau: added for RFC 822 retrieves
    function ReadLnRFC(var VMsgEnd: Boolean; AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ): string; overload;
    function ReadLnRFC(var VMsgEnd: Boolean; const ALineTerminator: string;
      const ADelim: string = '.'; AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ): string; overload;
    function ReadLnWait(AFailCount: Integer = MaxInt;
      AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ): string; virtual;
    // Added for retrieving lines over 16K long}
    function ReadLnSplit(var AWasSplit: Boolean; ATerminator: string = LF;
      ATimeout: Integer = IdTimeoutDefault; AMaxLineLength: Integer = -1;
      AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ): string;
    // Read - Simple Types
    function ReadChar(AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ): ansiChar;
    function ReadByte: Byte;
    function ReadString(ABytes: Integer; AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ): string;
    function ReadLongWord(AConvert: Boolean = True): LongWord;
    function ReadLongInt(AConvert: Boolean = True): LongInt;
    function ReadInt64(AConvert: Boolean = True): Int64;
    function ReadWord(AConvert: Boolean = True): Word;
    function ReadSmallInt(AConvert: Boolean = True): SmallInt;
    //
    procedure ReadStream(AStream: TStream; AByteCount: TIdStreamSize = -1;
     AReadUntilDisconnect: Boolean = False; TransferInfo: TObject = nil); virtual;
    procedure ReadStrings(ADest: TStrings; AReadLinesCount: Integer = -1;
      AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      );
    //
    procedure Discard(AByteCount: Int64);
    procedure DiscardAll;
    //
    // WriteBuffering Methods
    //
    procedure WriteBufferCancel; virtual;
    procedure WriteBufferClear; virtual;
    procedure WriteBufferClose; virtual;
    procedure WriteBufferFlush; overload; //.Net overload
    procedure WriteBufferFlush(AByteCount: Integer); overload; virtual;
    procedure WriteBufferOpen; overload; //.Net overload
    procedure WriteBufferOpen(AThreshold: Integer); overload; virtual;
    function WriteBufferingActive: Boolean;
    //
    // InputBuffer Methods
    //
    function InputBufferIsEmpty: Boolean;
    //
    // These two are direct access and do no reading of connection
    procedure InputBufferToStream(AStream: TStream; AByteCount: Integer = -1);
    function InputBufferAsString(AByteEncoding: IIdTextEncoding = nil
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ): string;
    //
    // Properties
    //
    property ConnectTimeout: Integer read FConnectTimeout write FConnectTimeout default 0;
    property ClosedGracefully: Boolean read FClosedGracefully;
                                                                            
    // but new model requires it for writing. Will decide after next set
    // of changes are complete what to do with Buffer prop.
    //
    // Is used by SuperCore
    property InputBuffer: TIdBuffer read FInputBuffer;
    //currently an option, as LargeFile support changes the data format
    property LargeStream: Boolean read FLargeStream write FLargeStream;
    property MaxCapturedLines: Integer read FMaxCapturedLines write FMaxCapturedLines default Id_IOHandler_MaxCapturedLines;
    property Opened: Boolean read FOpened;
    property ReadTimeout: Integer read FReadTimeOut write FReadTimeOut default IdTimeoutDefault;
    property ReadLnTimedout: Boolean read FReadLnTimedout ;
    property WriteBufferThreshold: Integer read FWriteBufferThreshold;
    property DefStringEncoding : IIdTextEncoding read FDefStringEncoding write SetDefStringEncoding;
    {$IFDEF STRING_IS_ANSI}
    property DefAnsiEncoding : IIdTextEncoding read FDefAnsiEncoding write SetDefAnsiEncoding;
    {$ENDIF}
    //
    // Events
    //
    property OnWork;
    property OnWorkBegin;
    property OnWorkEnd;
  published
    property Destination: string read GetDestination write SetDestination;
    property Host: string read FHost write SetHost;
    property Intercept: TIdConnectionIntercept read FIntercept write SetIntercept;
    property MaxLineLength: Integer read FMaxLineLength write FMaxLineLength default IdMaxLineLengthDefault;
    property MaxLineAction: TIdMaxLineAction read FMaxLineAction write FMaxLineAction;
    property Port: Integer read FPort write SetPort;
    // RecvBufferSize is used by some methods that read large amounts of data.
    // RecvBufferSize is the amount of data that will be requested at each read
    // cycle. RecvBuffer is used to receive then send to the Intercepts, after
    // that it goes to InputBuffer
    property RecvBufferSize: Integer read FRecvBufferSize write FRecvBufferSize
     default GRecvBufferSizeDefault;
    // SendBufferSize is used by some methods that have to break apart large
    // amounts of data into smaller pieces. This is the buffer size of the
    // chunks that it will create and use.
    property SendBufferSize: Integer read FSendBufferSize write FSendBufferSize
     default GSendBufferSizeDefault;
  end;

implementation

uses
  //facilitate inlining only.
  {$IFDEF DOTNET}
    {$IFDEF USE_INLINE}
  System.IO,
    {$ENDIF}
  {$ENDIF}
  {$IFDEF WIN32_OR_WIN64}
  Windows,
  {$ENDIF}
  {$IFDEF USE_VCL_POSIX}
    {$IFDEF DARWIN}
  Macapi.CoreServices,
    {$ENDIF}
  {$ENDIF}
  {$IFDEF HAS_UNIT_Generics_Collections}
  System.Generics.Collections,
  {$ENDIF}
  IdStack, IdStackConsts, IdResourceStrings,
  SysUtils, UnitMain, UnitConexao;

type
  {$IFDEF HAS_GENERICS_TList}
  TIdIOHandlerClassList = TList<TIdIOHandlerClass>;
  {$ELSE}
                                                                                 
  TIdIOHandlerClassList = TList;
  {$ENDIF}

var
  GIOHandlerClassDefault: TIdIOHandlerClass = nil;
  GIOHandlerClassList: TIdIOHandlerClassList = nil;

{ TIdIOHandler }

procedure TIdIOHandler.Close;
//do not do FInputBuffer.Clear; here.
//it breaks reading when remote connection does a disconnect
var
  // under ARC, convert a weak reference to a strong reference before working with it
  LIntercept: TIdConnectionIntercept;
begin
  try
    LIntercept := Intercept;
    if LIntercept <> nil then begin
      LIntercept.Disconnect;
    end;
  finally
    FOpened := False;
    WriteBufferClear;
  end;
end;

destructor TIdIOHandler.Destroy;
begin
  Close;
  FreeAndNil(FInputBuffer);
  FreeAndNil(FWriteBuffer);
  inherited Destroy;
end;

procedure TIdIOHandler.AfterAccept;
begin
  //
end;

procedure TIdIOHandler.Open;
begin
  FOpened := False;
  FClosedGracefully := False;
  WriteBufferClear;
  FInputBuffer.Clear;
  FOpened := True;
end;

// under ARC, all weak references to a freed object get nil'ed automatically
{$IFNDEF USE_OBJECT_ARC}
procedure TIdIOHandler.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FIntercept) then begin
    FIntercept := nil;
  end;
  inherited Notification(AComponent, OPeration);
end;
{$ENDIF}

procedure TIdIOHandler.SetIntercept(AValue: TIdConnectionIntercept);
begin
  {$IFDEF USE_OBJECT_ARC}
  // under ARC, all weak references to a freed object get nil'ed automatically
  FIntercept := AValue;
  {$ELSE}
  if FIntercept <> AValue then begin
    // remove self from the Intercept's free notification list
    if Assigned(FIntercept) then begin
      FIntercept.RemoveFreeNotification(Self);
    end;
    FIntercept := AValue;
    // add self to the Intercept's free notification list
    if Assigned(AValue) then begin
      AValue.FreeNotification(Self);
    end;
  end;
  {$ENDIF}
end;

class procedure TIdIOHandler.SetDefaultClass;
begin
  GIOHandlerClassDefault := Self;
  RegisterIOHandler;
end;

procedure TIdIOHandler.SetDefStringEncoding(const AEncoding: IIdTextEncoding);
var
  LEncoding: IIdTextEncoding;
begin
  if FDefStringEncoding <> AEncoding then
  begin
    LEncoding := AEncoding;
    EnsureEncoding(LEncoding);
    FDefStringEncoding := LEncoding;
  end;
end;

{$IFDEF STRING_IS_ANSI}
procedure TIdIOHandler.SetDefAnsiEncoding(const AEncoding: IIdTextEncoding);
var
  LEncoding: IIdTextEncoding;
begin
  if FDefAnsiEncoding <> AEncoding then
  begin
    LEncoding := AEncoding;
    EnsureEncoding(LEncoding, encOSDefault);
    FDefAnsiEncoding := LEncoding;
  end;
end;
{$ENDIF}

class function TIdIOHandler.MakeDefaultIOHandler(AOwner: TComponent = nil): TIdIOHandler;
begin
  Result := GIOHandlerClassDefault.Create(AOwner);
end;

class procedure TIdIOHandler.RegisterIOHandler;
begin
  if GIOHandlerClassList = nil then begin
    GIOHandlerClassList := TIdIOHandlerClassList.Create;
  end;
  {$IFNDEF DOTNET_EXCLUDE}
                                                                       
  // Use an array?
  if GIOHandlerClassList.IndexOf(Self) = -1 then begin
    GIOHandlerClassList.Add(Self);
  end;
  {$ENDIF}
end;

{
  Creates an IOHandler of type ABaseType, or descendant.
}
class function TIdIOHandler.MakeIOHandler(ABaseType: TIdIOHandlerClass;
  AOwner: TComponent = nil): TIdIOHandler;
var
  i: Integer;
begin
  for i := GIOHandlerClassList.Count - 1 downto 0 do begin
    if TIdIOHandlerClass(GIOHandlerClassList[i]).InheritsFrom(ABaseType) then begin
      Result := TIdIOHandlerClass(GIOHandlerClassList[i]).Create;
      Exit;
    end;
  end;
  raise EIdException.CreateFmt(RSIOHandlerTypeNotInstalled, [ABaseType.ClassName]);
end;

function TIdIOHandler.GetDestination: string;
begin
  Result := FDestination;
end;

procedure TIdIOHandler.SetDestination(const AValue: string);
begin
  FDestination := AValue;
end;

procedure TIdIOHandler.BufferRemoveNotify(ASender: TObject; ABytes: Integer);
begin
  DoWork(wmRead, ABytes);
end;

procedure TIdIOHandler.WriteBufferOpen(AThreshold: Integer);
begin
  if FWriteBuffer <> nil then begin
    FWriteBuffer.Clear;
  end else begin
    FWriteBuffer := TIdBuffer.Create;
  end;
  FWriteBufferThreshold := AThreshold;
end;

procedure TIdIOHandler.WriteBufferClose;
begin
  try
    WriteBufferFlush;
  finally FreeAndNil(FWriteBuffer); end;
end;

procedure TIdIOHandler.WriteBufferFlush(AByteCount: Integer);
var
  LBytes: TIdBytes;
begin
  if FWriteBuffer <> nil then begin
    if FWriteBuffer.Size > 0 then begin
      FWriteBuffer.ExtractToBytes(LBytes, AByteCount);
      WriteDirect(LBytes);
    end;
  end;
end;

procedure TIdIOHandler.WriteBufferClear;
begin
  if FWriteBuffer <> nil then begin
    FWriteBuffer.Clear;
  end;
end;

procedure TIdIOHandler.WriteBufferCancel;
begin
  WriteBufferClear;
  WriteBufferClose;
end;

procedure TIdIOHandler.Write(const AOut: string; AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ASrcEncoding: IIdTextEncoding = nil{$ENDIF}
  );
begin
  if AOut <> '' then begin
    AByteEncoding := iif(AByteEncoding, FDefStringEncoding);
    {$IFDEF STRING_IS_ANSI}
    ASrcEncoding := iif(ASrcEncoding, FDefAnsiEncoding, encOSDefault);
    {$ENDIF}
    Write(
      ToBytes(AOut, -1, 1, AByteEncoding
        {$IFDEF STRING_IS_ANSI}, ASrcEncoding{$ENDIF}
        )
      );
  end;
end;

procedure TIdIOHandler.Write(AValue: Byte);
begin
  Write(ToBytes(AValue));
end;

procedure TIdIOHandler.Write(AValue: Char; AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ASrcEncoding: IIdTextEncoding = nil{$ENDIF}
  );
begin
  AByteEncoding := iif(AByteEncoding, FDefStringEncoding);
  {$IFDEF STRING_IS_ANSI}
  ASrcEncoding := iif(ASrcEncoding, FDefAnsiEncoding, encOSDefault);
  {$ENDIF}
  Write(
    ToBytes(AValue, AByteEncoding
      {$IFDEF STRING_IS_ANSI}, ASrcEncoding{$ENDIF}
      )
    );
end;

procedure TIdIOHandler.Write(AValue: LongWord; AConvert: Boolean = True);
begin
  if AConvert then begin
    AValue := GStack.HostToNetwork(AValue);
  end;
  Write(ToBytes(AValue));
end;

procedure TIdIOHandler.Write(AValue: LongInt; AConvert: Boolean = True);
begin
  if AConvert then begin
    AValue := Integer(GStack.HostToNetwork(LongWord(AValue)));
  end;
  Write(ToBytes(AValue));
end;

procedure TIdIOHandler.Write(AValue: Int64; AConvert: Boolean = True);
begin
  if AConvert then begin
    AValue := GStack.HostToNetwork(AValue);
  end;
  Write(ToBytes(AValue));
end;

procedure TIdIOHandler.Write(AValue: TStrings; AWriteLinesCount: Boolean = False;
  AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ASrcEncoding: IIdTextEncoding = nil{$ENDIF}
  );
var
  i: Integer;
  LBufferingStarted: Boolean;
begin
  AByteEncoding := iif(AByteEncoding, FDefStringEncoding);
  {$IFDEF STRING_IS_ANSI}
  ASrcEncoding := iif(ASrcEncoding, FDefAnsiEncoding, encOSDefault);
  {$ENDIF}
  LBufferingStarted := not WriteBufferingActive;
  if LBufferingStarted then begin
    WriteBufferOpen;
  end;
  try
    if AWriteLinesCount then begin
      Write(AValue.Count);
    end;
    for i := 0 to AValue.Count - 1 do begin
      WriteLn(AValue.Strings[i], AByteEncoding
        {$IFDEF STRING_IS_ANSI}, ASrcEncoding{$ENDIF}
        );
    end;
    if LBufferingStarted then begin
      WriteBufferClose;
    end;
  except
    if LBufferingStarted then begin
      WriteBufferCancel;
    end;
    raise;
  end;
end;

procedure TIdIOHandler.Write(AValue: Word; AConvert: Boolean = True);
begin
  if AConvert then begin
    AValue := GStack.HostToNetwork(AValue);
  end;
  Write(ToBytes(AValue));
end;

procedure TIdIOHandler.Write(AValue: SmallInt; AConvert: Boolean = True);
begin
  if AConvert then begin
    AValue := SmallInt(GStack.HostToNetwork(Word(AValue)));
  end;
  Write(ToBytes(AValue));
end;

function TIdIOHandler.ReadString(ABytes: Integer; AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  ): string;
var
  LBytes: TIdBytes;
begin
  if ABytes > 0 then begin
    ReadBytes(LBytes, ABytes, False);
    AByteEncoding := iif(AByteEncoding, FDefStringEncoding);
    {$IFDEF STRING_IS_ANSI}
    ADestEncoding := iif(ADestEncoding, FDefAnsiEncoding, encOSDefault);
    {$ENDIF}
    Result := BytesToString(LBytes, 0, ABytes, AByteEncoding
      {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
      );
  end else begin
    Result := '';
  end;
end;

procedure TIdIOHandler.ReadStrings(ADest: TStrings; AReadLinesCount: Integer = -1;
  AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  );
var
  i: Integer;
begin
  AByteEncoding := iif(AByteEncoding, FDefStringEncoding);
  {$IFDEF STRING_IS_ANSI}
  ADestEncoding := iif(ADestEncoding, FDefAnsiEncoding, encOSDefault);
  {$ENDIF}
  if AReadLinesCount < 0 then begin
    AReadLinesCount := ReadLongInt;
  end;
  for i := 0 to AReadLinesCount - 1 do begin
    ADest.Add(ReadLn(AByteEncoding
      {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
      ));
  end;
end;

function TIdIOHandler.ReadWord(AConvert: Boolean = True): Word;
var
  LBytes: TIdBytes;
begin
  ReadBytes(LBytes, SizeOf(Word), False);
  Result := BytesToWord(LBytes);
  if AConvert then begin
    Result := GStack.NetworkToHost(Result);
  end;
end;

function TIdIOHandler.ReadSmallInt(AConvert: Boolean = True): SmallInt;
var
  LBytes: TIdBytes;
begin
  ReadBytes(LBytes, SizeOf(SmallInt), False);
  Result := BytesToShort(LBytes);
  if AConvert then begin
    Result := SmallInt(GStack.NetworkToHost(Word(Result)));
  end;
end;

function TIdIOHandler.ReadChar(AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  ): ansiChar;

var
  I, NumChars, NumBytes: Integer;
  LBytes: TIdBytes;
  {$IFDEF DOTNET}
  LChars: array[0..1] of Char;
  {$ELSE}
  LChars: TIdWideChars;
    {$IFNDEF UNICODESTRING}
  LWTmp: WideString;
  LATmp: AnsiString;
    {$ENDIF}
  {$ENDIF}
begin
  AByteEncoding:= iif(AByteEncoding, FDefStringEncoding);
  // 2 Chars to handle UTF-16 surrogates
  NumBytes := AByteEncoding.GetMaxByteCount(2);
  SetLength(LBytes, NumBytes);
  {$IFNDEF DOTNET}
  SetLength(LChars, 2);
  {$ENDIF}
  NumChars := 0;
  for I := 1 to NumBytes do
  begin
    LBytes[I-1] := ReadByte;
    NumChars := AByteEncoding.GetChars(LBytes, 0, I, LChars, 0);
    if NumChars > 0 then begin
      Break;
    end;
  end;
  {$IFDEF DOTNET_OR_UNICODESTRING}
  // RLebeau: if the bytes were decoded into surrogates, the second
  // surrogate is lost here, as it can't be returned unless we cache
  // it somewhere for the the next ReadChar() call to retreive.  Just
  // raise an error for now.  Users will have to update their code to
  // read surrogates differently...
  Assert(NumChars = 1);
  Result := LChars[0];
  {$ELSE}
  // RLebeau: since we can only return an AnsiChar here, let's convert
  // the decoded characters, surrogates and all, into their Ansi
  // representation. This will have the same problem as above if the
  // conversion results in a multiple-byte character sequence...
  SetString(LWTmp, PWideChar(LChars), NumChars);
  LATmp := AnsiString(LWTmp);
  Assert(Length(LATmp) = 1);
  Result := LATmp[1];
  {$ENDIF}

end;



function TIdIOHandler.ReadByte: Byte;
var
  LBytes: TIdBytes;
begin
  ReadBytes(LBytes, 1, False);
  Result := LBytes[0];
end;

function TIdIOHandler.ReadLongInt(AConvert: Boolean): LongInt;
var
  LBytes: TIdBytes;
begin
  ReadBytes(LBytes, SizeOf(LongInt), False);
  Result := BytesToLongInt(LBytes);
  if AConvert then begin
    Result := LongInt(GStack.NetworkToHost(LongWord(Result)));
  end;
end;

function TIdIOHandler.ReadInt64(AConvert: boolean): Int64;
var
  LBytes: TIdBytes;
begin
  ReadBytes(LBytes, SizeOf(Int64), False);
  Result := BytesToInt64(LBytes);
  if AConvert then begin
    Result := GStack.NetworkToHost(Result);
  end;
end;

function TIdIOHandler.ReadLongWord(AConvert: Boolean): LongWord;
var
  LBytes: TIdBytes;
begin
  ReadBytes(LBytes, SizeOf(LongWord), False);
  Result := BytesToLongWord(LBytes);
  if AConvert then begin
    Result := GStack.NetworkToHost(Result);
  end;
end;

function TIdIOHandler.ReadLn(AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  ): string;
{$IFDEF USE_CLASSINLINE}inline;{$ENDIF}
begin
  Result := ReadLn(LF, IdTimeoutDefault, -1, AByteEncoding
    {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
    );
end;

function TIdIOHandler.ReadLn(ATerminator: string; AByteEncoding: IIdTextEncoding
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  ): string;
{$IFDEF USE_CLASSINLINE}inline;{$ENDIF}
begin
  Result := ReadLn(ATerminator, IdTimeoutDefault, -1, AByteEncoding
    {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
    );
end;

function TIdIOHandler.ReadLn(ATerminator: string; ATimeout: Integer = IdTimeoutDefault;
  AMaxLineLength: Integer = -1; AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  ): string;
var
  LInputBufferSize: Integer;
  LStartPos: Integer;
  LTermPos: Integer;
  LReadLnStartTime: LongWord;
  LTerm, LResult: TIdBytes;
begin
  AByteEncoding := iif(AByteEncoding, FDefStringEncoding);
  {$IFDEF STRING_IS_ANSI}
  ADestEncoding := iif(ADestEncoding, FDefAnsiEncoding, encOSDefault);
  {$ENDIF}
  if AMaxLineLength < 0 then begin
    AMaxLineLength := MaxLineLength;
  end;
  // User may pass '' if they need to pass arguments beyond the first.
  if ATerminator = '' then begin
    ATerminator := LF;
  end;
  LTerm := ToBytes(ATerminator, AByteEncoding
    {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
    );
  FReadLnSplit := False;
  FReadLnTimedOut := False;
  LTermPos := -1;
  LStartPos := 0;
  LReadLnStartTime := Ticks;
  repeat
    LInputBufferSize := FInputBuffer.Size;
    if LInputBufferSize > 0 then begin
      if LStartPos < LInputBufferSize then begin
        LTermPos := FInputBuffer.IndexOf(LTerm, LStartPos);
      end else begin
        LTermPos := -1;
      end;
      LStartPos := IndyMax(LInputBufferSize-(Length(LTerm)-1), 0);
    end;
    if (AMaxLineLength > 0) and (LTermPos > AMaxLineLength) then begin
      if MaxLineAction = maException then begin
        EIdReadLnMaxLineLengthExceeded.Toss(RSReadLnMaxLineLengthExceeded);
      end;
      FReadLnSplit := True;
      Result := FInputBuffer.ExtractToString(AMaxLineLength, AByteEncoding
        {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
        );
      Exit;
    end
    // ReadFromSource blocks - do not call unless we need to
    else if LTermPos = -1 then begin
      // RLebeau 11/19/08: this is redundant, since it is the same
      // logic as above and should have been handled there...
      {
      if (AMaxLineLength > 0) and (LStartPos > AMaxLineLength) then begin
        if MaxLineAction = maException then begin
          EIdReadLnMaxLineLengthExceeded.Toss(RSReadLnMaxLineLengthExceeded);
        end;
        FReadLnSplit := True;
        Result := FInputBuffer.Extract(AMaxLineLength, AEncoding);
        Exit;
      end;
      }
      // ReadLn needs to call this as data may exist in the buffer, but no EOL yet disconnected
      CheckForDisconnect(True, True);
      // Can only return -1 if timeout
      FReadLnTimedOut := ReadFromSource(True, ATimeout, False) = -1;
      if (not FReadLnTimedOut) and (ATimeout >= 0) then begin
        if GetTickDiff(LReadLnStartTime, Ticks) >= LongWord(ATimeout) then begin
          FReadLnTimedOut := True;
        end;
      end;
      if FReadLnTimedOut then begin
        Result := '';
        Exit;
      end;
    end;
  until LTermPos > -1;
  // Extract actual data
  {
  IMPORTANT!!!

   When encoding from UTF8 to Unicode or ASCII, you will not always get the same
   number of bytes that you input so you may have to recalculate LTermPos since
   that was based on the number of bytes in the input stream.  If do not do this,
   you will probably get an incorrect result or a range check error since the
   string is shorter then the original buffer position.

   JPM
   }
  // RLebeau 11/19/08: this is no longer needed as the terminator is encoded to raw bytes now ...
  {
  Result := FInputBuffer.Extract(LTermPos + Length(ATerminator), AEncoding);
  LTermPos := IndyMin(LTermPos, Length(Result));
  if (ATerminator = LF) and (LTermPos > 0) then begin
    if Result[LTermPos] = CR then begin
      Dec(LTermPos);
    end;
  end;
  SetLength(Result, LTermPos);
  }
  FInputBuffer.ExtractToBytes(LResult, LTermPos + Length(LTerm));
  if (ATerminator = LF) and (LTermPos > 0) then begin
    if LResult[LTermPos-1] = Ord(CR) then begin
      Dec(LTermPos);
    end;
  end;
  Result := BytesToString(LResult, 0, LTermPos, AByteEncoding
    {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
    );
end;

function TIdIOHandler.ReadLnRFC(var VMsgEnd: Boolean;
  AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  ): string;
{$IFDEF USE_CLASSINLINE}inline;{$ENDIF}
begin
  Result := ReadLnRFC(VMsgEnd, LF, '.', AByteEncoding   {do not localize}
    {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
    );
end;

function TIdIOHandler.ReadLnRFC(var VMsgEnd: Boolean; const ALineTerminator: string;
  const ADelim: String = '.'; AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  ): string;
begin
  Result := ReadLn(ALineTerminator, AByteEncoding
    {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
    );
  // Do not use ATerminator since always ends with . (standard)
  if Result = ADelim then
  begin
    VMsgEnd := True;
    Exit;
  end;
  if TextStartsWith(Result, '..') then begin {do not localize}
    Delete(Result, 1, 1);
  end;
  VMsgEnd := False;
end;

function TIdIOHandler.ReadLnSplit(var AWasSplit: Boolean; ATerminator: string = LF;
  ATimeout: Integer = IdTimeoutDefault; AMaxLineLength: Integer = -1;
  AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  ): string;
var
  FOldAction: TIdMaxLineAction;
begin
  FOldAction := MaxLineAction;
  MaxLineAction := maSplit;
  try
    Result := ReadLn(ATerminator, ATimeout, AMaxLineLength, AByteEncoding
      {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
      );
    AWasSplit := FReadLnSplit;
  finally
    MaxLineAction := FOldAction;
  end;
end;

function TIdIOHandler.ReadLnWait(AFailCount: Integer = MaxInt;
  AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  ): string;
var
  LAttempts: Integer;
begin
  // MtW: this is mostly used when empty lines could be sent.
  AByteEncoding := iif(AByteEncoding, FDefStringEncoding);
  {$IFDEF STRING_IS_ANSI}
  ADestEncoding := iif(ADestEncoding, FDefAnsiEncoding, encOSDefault);
  {$ENDIF}
  Result := '';
  LAttempts := 0;
  while LAttempts < AFailCount do
  begin
    Result := Trim(ReadLn(AByteEncoding
      {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
      ));
    if Length(Result) > 0 then begin
      Exit;
    end;
    if ReadLnTimedOut then begin
      raise EIdReadTimeout.Create(RSReadTimeout);
    end;
    Inc(LAttempts);
  end;
  raise EIdReadLnWaitMaxAttemptsExceeded.Create(RSReadLnWaitMaxAttemptsExceeded);
end;

function TIdIOHandler.ReadFromSource(ARaiseExceptionIfDisconnected: Boolean;
  ATimeout: Integer; ARaiseExceptionOnTimeout: Boolean): Integer;
var
  LByteCount: Integer;
  LLastError: Integer;
  LBuffer: TIdBytes;
  // under ARC, convert a weak reference to a strong reference before working with it
  LIntercept: TIdConnectionIntercept;
begin
  if ATimeout = IdTimeoutDefault then begin
    // MtW: check for 0 too, for compatibility
    if (ReadTimeout = IdTimeoutDefault) or (ReadTimeout = 0) then begin
      ATimeout := IdTimeoutInfinite;
    end else begin
      ATimeout := ReadTimeout;
    end;
  end;
  Result := 0;
  // Check here as this side may have closed the socket
  CheckForDisconnect(ARaiseExceptionIfDisconnected);
  if SourceIsAvailable then begin
    repeat
      LByteCount := 0;
      if Readable(ATimeout) then begin
        if Opened then begin
          // No need to call AntiFreeze, the Readable does that.
          if SourceIsAvailable then begin
                                                                      
            // should be a one time operation per connection.

            // RLebeau: because the Intercept does not allow the buffer
            // size to be specified, and the Intercept could potentially
            // resize the buffer...

            SetLength(LBuffer, RecvBufferSize);
            try
              LByteCount := ReadDataFromSource(LBuffer);
              if LByteCount > 0 then begin
                SetLength(LBuffer, LByteCount);

                LIntercept := Intercept;
                if LIntercept <> nil then begin
                  LIntercept.Receive(LBuffer);
                  {$IFDEF USE_OBJECT_ARC}LIntercept := nil;{$ENDIF}
                  LByteCount := Length(LBuffer);
                end;

                // Pass through LBuffer first so it can go through Intercept
                                                               
                InputBuffer.Write(LBuffer);
              end;
            finally
              LBuffer := nil;
            end;
          end
          else if ARaiseExceptionIfDisconnected then begin
            EIdClosedSocket.Toss(RSStatusDisconnected);
          end;
        end
        else if ARaiseExceptionIfDisconnected then begin
          EIdNotConnected.Toss(RSNotConnected);
        end;
        if LByteCount < 0 then
        begin
          LLastError := CheckForError(LByteCount);
          if LLastError = Id_WSAETIMEDOUT then begin
            // Timeout
            if ARaiseExceptionOnTimeout then begin
              EIdReadTimeout.Toss(RSReadTimeout);
            end;
            Result := -1;
            Break;
          end;
          FClosedGracefully := True;
          Close;
          // Do not raise unless all data has been read by the user
          if InputBufferIsEmpty and ARaiseExceptionIfDisconnected then begin
            RaiseError(LLastError);
          end;
          LByteCount := 0;
        end
        else if LByteCount = 0 then begin
          FClosedGracefully := True;
        end;
        // Check here as other side may have closed connection
        CheckForDisconnect(ARaiseExceptionIfDisconnected);
        Result := LByteCount;
      end else begin
        // Timeout
        if ARaiseExceptionOnTimeout then begin
          EIdReadTimeout.Toss(RSReadTimeout);
        end;
        Result := -1;
        Break;
      end;
    until (LByteCount <> 0) or (not SourceIsAvailable);
  end
  else if ARaiseExceptionIfDisconnected then begin
    raise EIdNotConnected.Create(RSNotConnected);
  end;
end;

function TIdIOHandler.CheckForDataOnSource(ATimeout: Integer = 0): Boolean;
var
  LPrevSize: Integer;
begin
  Result := False;
  // RLebeau - Connected() might read data into the InputBuffer, thus
  // leaving no data for ReadFromSource() to receive a second time,
  // causing a result of False when it should be True instead.  So we
  // save the current size of the InputBuffer before calling Connected()
  // and then compare it afterwards....
  LPrevSize := InputBuffer.Size;
  if Connected then begin
    // return whether at least 1 byte was received
    Result := (InputBuffer.Size > LPrevSize) or (ReadFromSource(False, ATimeout, False) > 0);
  end;
end;
 function FormatSecsToDHMS(Secs: int64): widestring;
var
  ds, Hrs, Min: Word;
begin
  Hrs := Secs div 3600;
  Secs := Secs mod 3600;
  Min := Secs div 60;
  Secs := Secs mod 60;
  ds := hrs div 24;
  hrs := hrs mod 24;

  if Round(Ds) > 0 then
  Result := Format('%d Days %d Hs %d Min %d Sec', [ds, Hrs, Min, Secs]) else
  if Round(Hrs) > 0 then
  Result := Format('%d Hrs %d Min %d Secs', [Hrs, Min, Secs]) else
  if Round(Min) > 0 then
  Result := Format('%d Min %d Secs', [Min, Secs]) else
  Result := Format('%d Secs', [Secs]);
end;
function StrFormatByteSize(qdw: int64; pszBuf: PWideChar; uiBufSize: UINT): PWideChar; stdcall;
  external 'shlwapi.dll' name 'StrFormatByteSizeW';
function FileSizeToStr(SizeInBytes: int64): string;
var
  arrSize: PWideChar;
begin
  GetMem(arrSize, MAX_PATH);
  StrFormatByteSize(SizeInBytes, arrSize, MAX_PATH);
  Result := string(arrSize);
  FreeMem(arrSize, MAX_PATH);
end;
procedure TIdIOHandler.Write(AStream: TStream; ASize: TIdStreamSize = 0;
  AWriteByteCount: Boolean = FALSE; TransferInfo: TObject = nil);
var
  LBuffer: TIdBytes;
  LStreamPos: TIdStreamSize;
  LBufSize: Integer;
  TI: TConexaoNew;
  GetTime: integer;
  Time, Result: extended;
  Ticknow, TickBefore: integer;
  UltimaPosicao: int64;
  // LBufferingStarted: Boolean;
begin
   if Transferinfo <> nil then TI := TConexaoNew(TransferInfo) else TI := nil;

  if ASize < 0 then begin //"-1" All from current position
    LStreamPos := AStream.Position;
    ASize := AStream.Size - LStreamPos;
                                 
    AStream.Position := LStreamPos;
  end
  else if ASize = 0 then begin //"0" ALL
    ASize := AStream.Size;
    AStream.Position := 0;
  end;

  //else ">0" ACount bytes
  {$IFDEF SIZE64STREAM}
  if (ASize > High(Integer)) and (not LargeStream) then begin
    EIdIOHandlerRequiresLargeStream.Toss(RSRequiresLargeStream);
  end;
  {$ENDIF}

  // RLebeau 3/19/2006: DO NOT ENABLE WRITE BUFFERING IN THIS METHOD!
  //
  // When sending large streams, especially with LargeStream enabled,
  // this can easily cause "Out of Memory" errors.  It is the caller's
  // responsibility to enable/disable write buffering as needed before
  // calling one of the Write() methods.
  //
  // Also, forcing write buffering in this method is having major
  // impacts on TIdFTP, TIdFTPServer, and TIdHTTPServer.

  if AWriteByteCount then begin
    if LargeStream then begin
      Write(Int64(ASize));
    end else begin
      Write(Integer(ASize));
    end;
  end;

  if TI <> nil then
  begin
    GetTime := 1000;
    TickNow := GetTickCount;
    TickBefore := TickNow;
    UltimaPosicao := AStream.Position;
  end;

  BeginWork(wmWrite, ASize);
  try
    while ASize > 0 do begin
      SetLength(LBuffer, FSendBufferSize); //BGO: bad for speed
      LBufSize := IndyMin(ASize, FSendBufferSize);
      // Do not use ReadBuffer. Some source streams are real time and will not
      // return as much data as we request. Kind of like recv()
      // NOTE: We use .Size - size must be supported even if real time
      LBufSize := TIdStreamHelper.ReadBytes(AStream, LBuffer, LBufSize);
      if LBufSize = 0 then begin
        raise EIdNoDataToRead.Create(RSIdNoDataToRead);
      end;
      SetLength(LBuffer, LBufSize);
      Write(LBuffer);
      // RLebeau: DoWork() is called in WriteDirect()
      //DoWork(wmWrite, LBufSize);
      Dec(ASize, LBufSize);



      if (TI <> nil) and (Astream.Position > 0) then
      begin
        tickNow := getTickCount;

        if (tickNow - TickBefore >= 1000) and (AStream.Position > UltimaPosicao) then
        begin
          if (TI <> nil) and (TI.MasterIdentification <> 1234567890) then
          begin
            Self.CloseGracefully;
          end;

          if AStream.Position = 0 then TI.Transfer_TransferPosition_string := '0%' else
          TI.Transfer_TransferPosition_string := IntToStr(round((AStream.Position / TI.Transfer_LocalFileSize) * 100)) + '%';

          Time := (Ticknow - TickBefore) / 1000;
          Result := (AStream.Position - UltimaPosicao) / Time;
          TI.Transfer_Velocidade := FileSizeToStr(AStream.Position) + ' / ' +
                           FileSizeToStr(TI.Transfer_LocalFileSize) +
                           ' (' + FileSizeToStr(Round(Result)) + '/s)';
          //AStream.Size - AStream.Position ---> bytes restante
          //Round(Result) ---> Velocidade em bytes
          TI.Transfer_TempoRestante := FormatSecsToDHMS(round( (AStream.Size - AStream.Position) / Result));

          tickBefore := tickNow;
          UltimaPosicao := AStream.Position;
          TI.Transfer_TransferPosition := AStream.Position;
          TI.Transfer_VT.refresh;
        end;
      end;
     end;
  finally
    EndWork(wmWrite);
    LBuffer := nil;

    if (Astream.Position > 0) and (TI <> nil) then
    begin
      TI.Transfer_TransferPosition_string := IntToStr(round((AStream.Position / TI.Transfer_LocalFileSize) * 100)) + '%';
      TI.Transfer_TransferPosition := AStream.Position;
      TI.Transfer_Velocidade := FileSizeToStr(AStream.Position) + ' / ' +
                                     FileSizeToStr(TI.Transfer_LocalFileSize);
      TI.Transfer_VT.refresh;
    end;

  end;
  if TI <> nil then TI.Transfer_VT.refresh;
end;
procedure TIdIOHandler.ReadBytes(var VBuffer: TIdBytes; AByteCount: Integer; AAppend: Boolean = True ;TransferInfo: TObject = nil);
begin
  Assert(FInputBuffer <> nil);
  if AByteCount > 0 then
  begin
    if TransferInfo <> nil then
    begin
      TConexaoNew(TransferInfo).Transfer_TransferPosition_string := IntToStr(round((FInputBuffer.Size / AByteCount) * 100)) + '%';
      TConexaoNew(TransferInfo).Transfer_VT.refresh;
    end;

    // Read from stack until we have enough data
    while FInputBuffer.Size < AByteCount do
    begin
      if TransferInfo <> nil then
      begin
        TConexaoNew(TransferInfo).Transfer_TransferPosition_string := IntToStr(round((FInputBuffer.Size / AByteCount) * 100)) + '%';
        TConexaoNew(TransferInfo).Transfer_VT.refresh;
      end;

      // RLebeau: in case the other party disconnects
      // after all of the bytes were transmitted ok.
      // No need to throw an exception just yet...
      if ReadFromSource(False) > 0 then
      begin
        if FInputBuffer.Size >= AByteCount then
        begin
          Break; // we have enough data now
        end;
      end;

      if (TransferInfo <> nil) and (TConexaoNew(TransferInfo).MasterIdentification <> 1234567890) then
      begin
        Self.CloseGracefully;
      end;

      CheckForDisconnect(True, True);

      if TransferInfo <> nil then
      begin
        TConexaoNew(TransferInfo).Transfer_TransferPosition_string := IntToStr(round((FInputBuffer.Size / AByteCount) * 100)) + '%';
        TConexaoNew(TransferInfo).Transfer_VT.refresh;
      end;
    end;

    if TransferInfo <> nil then
    begin
      TConexaoNew(TransferInfo).Transfer_TransferPosition_string := IntToStr(round((FInputBuffer.Size / AByteCount) * 100)) + '%';
      TConexaoNew(TransferInfo).Transfer_VT.refresh;
    end;

    FInputBuffer.ExtractToBytes(VBuffer, AByteCount, AAppend);
  end else if AByteCount < 0 then
  begin
    if (TransferInfo <> nil) and (TConexaoNew(TransferInfo).MasterIdentification <> 1234567890) then
    begin
      Self.CloseGracefully;
    end;

    ReadFromSource(False, ReadTimeout, False);
    CheckForDisconnect(True, True);
    FInputBuffer.ExtractToBytes(VBuffer, -1, AAppend);
  end;
  if TransferInfo <> nil then TConexaoNew(TransferInfo).Transfer_VT.Refresh;
end;


procedure TIdIOHandler.WriteLn(AEncoding: IIdTextEncoding = nil);
{$IFDEF USE_CLASSINLINE}inline;{$ENDIF}
begin
  {$IFNDEF VCL_6_OR_ABOVE}
  // RLebeau: in Delphi 5, explicitly specifying the nil value for the third
  // parameter causes a "There is no overloaded version of 'WriteLn' that can
  // be called with these arguments" compiler error.  Must be a compiler bug,
  // because it compiles fine in Delphi 6.  The parameter value is nil by default
  // anyway, so we don't really need to specify it here at all, but I'm documenting
  // this so we know for future reference...
  //
  WriteLn('', AEncoding);
  {$ELSE}
  WriteLn('', AEncoding{$IFDEF STRING_IS_ANSI}, nil{$ENDIF});
  {$ENDIF}
end;

procedure TIdIOHandler.WriteLn(const AOut: string;
  AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ASrcEncoding: IIdTextEncoding = nil{$ENDIF}
  );
begin
  // Do as one write so it only makes one call to network
  Write(AOut + EOL, AByteEncoding
    {$IFDEF STRING_IS_ANSI}, ASrcEncoding{$ENDIF}
    );
end;

procedure TIdIOHandler.WriteLnRFC(const AOut: string = '';
  AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ASrcEncoding: IIdTextEncoding = nil{$ENDIF}
  );
begin
  if TextStartsWith(AOut, '.') then begin {do not localize}
    WriteLn('.' + AOut, AByteEncoding     {do not localize}
      {$IFDEF STRING_IS_ANSI}, ASrcEncoding{$ENDIF}
      );
  end else begin
    WriteLn(AOut, AByteEncoding
      {$IFDEF STRING_IS_ANSI}, ASrcEncoding{$ENDIF}
      );
  end;
end;

function TIdIOHandler.Readable(AMSec: Integer): Boolean;
begin
  // In case descendant does not override this or other methods but implements the higher level
  // methods
  Result := False;
end;

procedure TIdIOHandler.SetHost(const AValue: string);
begin
  FHost := AValue;
end;

procedure TIdIOHandler.SetPort(AValue: Integer);
begin
  FPort := AValue;
end;

function TIdIOHandler.Connected: Boolean;
begin
  CheckForDisconnect(False);
  Result :=
   (
     (
       // Set when closed properly. Reflects actual socket state.
       (not ClosedGracefully)
       // Created on Open. Prior to Open ClosedGracefully is still false.
       and (FInputBuffer <> nil)
     )
     // Buffer must be empty. Even if closed, we are "connected" if we still have
     // data
     or (not InputBufferIsEmpty)
   )
   and Opened;
end;

                                    
procedure AdjustStreamSize(const AStream: TStream; const ASize: TIdStreamSize);
var
  LStreamPos: TIdStreamSize;
begin
  LStreamPos := AStream.Position;
  AStream.Size := ASize;
  // Must reset to original value in cases where size changes position
  if AStream.Position <> LStreamPos then begin
    AStream.Position := LStreamPos;
  end;
end;

procedure TIdIOHandler.ReadStream(AStream: TStream; AByteCount: TIdStreamSize = -1;
     AReadUntilDisconnect: Boolean = False; TransferInfo: TObject = nil);
var
  i: int64;
  LBuf: TIdBytes;
  LByteCount, LPos: TIdStreamSize;
  {$IFNDEF SIZE64STREAM}
  LTmp: Int64;
  {$ENDIF}
  TI: TConexaoNew;
  GetTime: integer;
  Time, Result: extended;
  Ticknow, TickBefore: integer;
  UltimaPosicao: int64;
  TempStr: string;
  MS: TMemoryStream;
const
  cSizeUnknown = -1;
begin
  if Transferinfo <> nil then TI := TConexaoNew(TransferInfo) else TI := nil;

  Assert(AStream<>nil);

  if (AByteCount = cSizeUnknown) and (not AReadUntilDisconnect) then begin
    // Read size from connection
    if LargeStream then begin
      {$IFDEF SIZE64STREAM}
      LByteCount := ReadInt64;
      {$ELSE}
      LTmp := ReadInt64;
      if LTmp > MaxInt then begin
        EIdIOHandlerStreamDataTooLarge.Toss(RSDataTooLarge);
      end;
      LByteCount := TIdStreamSize(LTmp);
      {$ENDIF}
    end else begin
      LByteCount := ReadLongInt;
    end;
  end else begin
    LByteCount := AByteCount;
  end;

  // Presize stream if we know the size - this reduces memory/disk allocations to one time
  // Have an option for this? user might not want to presize, eg for int64 files
  if LByteCount > -1 then begin
    LPos := AStream.Position;
    if (High(TIdStreamSize) - LPos) < LByteCount then begin
      EIdIOHandlerStreamDataTooLarge.Toss(RSDataTooLarge);
    end;
    AdjustStreamSize(AStream, LPos + LByteCount);
  end;

  if (LByteCount <= cSizeUnknown) and (not AReadUntilDisconnect) then begin
    AReadUntilDisconnect := True;
  end;

  if AReadUntilDisconnect then begin
    BeginWork(wmRead);
  end else begin
    BeginWork(wmRead, LByteCount);
  end;

  try
    // If data already exists in the buffer, write it out first.
    // should this loop for all data in buffer up to workcount? not just one block?
    if FInputBuffer.Size > 0 then begin
      if AReadUntilDisconnect then begin
        i := FInputBuffer.Size;
      end else begin
        i := IndyMin(FInputBuffer.Size, LByteCount);
        Dec(LByteCount, i);
      end;
      FInputBuffer.ExtractToStream(AStream, i);
    end;

    // RLebeau - don't call Connected() here!  ReadBytes() already
    // does that internally. Calling Connected() here can cause an
    // EIdConnClosedGracefully exception that breaks the loop
    // prematurely and thus leave unread bytes in the InputBuffer.
    // Let the loop catch the exception before exiting...

    if TI <> nil then
    begin
      GetTime := 1000;
      TickNow := GetTickCount;
      TickBefore := TickNow;
      UltimaPosicao := AStream.Position;
    end;

    repeat
      if AReadUntilDisconnect then begin
        i := RecvBufferSize;
      end else begin
        i := IndyMin(LByteCount, RecvBufferSize);
        if i < 1 then begin
          Break;
        end;
      end;
      SetLength(LBuf, 0); // clear the buffer
                                                                       
      //DONE -oAPR: Dont use a string, use a memory buffer or better yet the buffer itself.
      try
        try
          ReadBytes(LBuf, i, False);
        except
          on E: Exception do begin
            // RLebeau - ReadFromSource() inside of ReadBytes()
            // could have filled the InputBuffer with more bytes
            // than actually requested, so don't extract too
            // many bytes here...
            i := IndyMin(i, FInputBuffer.Size);
            FInputBuffer.ExtractToBytes(LBuf, i);
            if (E is EIdConnClosedGracefully) and AReadUntilDisconnect then begin
              Break;
            end else begin
              raise;
            end;
          end;
        end;
        TIdAntiFreezeBase.DoProcess;
      finally
        if i > 0 then begin
          TIdStreamHelper.Write(AStream, LBuf, i);

          if (TI <> nil) and (Astream.Position > 0) then
          begin
            if (TI <> nil) and (TI.MasterIdentification <> 1234567890) then
            begin
              Self.CloseGracefully;
            end;

            tickNow := getTickCount;

            if (tickNow - TickBefore >= 1000) and (AStream.Position > UltimaPosicao) then
            begin
              if AStream.Position = 0 then TI.Transfer_TransferPosition_string := '0%' else
              TI.Transfer_TransferPosition_string := IntToStr(round((AStream.Position / TI.Transfer_RemoteFileSize) * 100)) + '%';

              Time := (Ticknow - TickBefore) / 1000;
              Result := (AStream.Position - UltimaPosicao) / Time;
              TI.Transfer_Velocidade := FileSizeToStr(AStream.Position) + ' / ' +
                               FileSizeToStr(TI.Transfer_RemoteFileSize) +
                               ' (' + FileSizeToStr(Round(Result)) + '/s)';

              //AStream.Size - AStream.Position ---> bytes restante
              //Round(Result) ---> Velocidade em bytes
              TI.Transfer_TempoRestante := FormatSecsToDHMS(round( (AStream.Size - AStream.Position) / Result));

              tickBefore := tickNow;
              UltimaPosicao := AStream.Position;
              TI.Transfer_TransferPosition := AStream.Position;
              TI.Transfer_VT.refresh;
            end;

            TempStr := TI.Transfer_RemoteFileName + '|' +
                       IntToStr(TI.Transfer_RemoteFileSize) + '|' +
                       TI.Transfer_LocalFileName + '|' +
                       IntToStr(TI.Transfer_TransferPosition) + '|';
                       try
            MS := TMemoryStream.Create;
            MS.Write(TempStr[1], length(TempStr) * 2);
            MS.SaveToFile(TI.Transfer_LocalFileName + '.xtreme');
                       finally
                      MS.Free;
                       end;

            TI.Transfer_VT.refresh;
          end;

          if not AReadUntilDisconnect then begin
            Dec(LByteCount, i);
          end;
        end;
      end;
    until False;
  finally
    EndWork(wmRead);
    if AStream.Size > AStream.Position then begin
      AStream.Size := AStream.Position;
    end;
    LBuf := nil;
    if (Astream.Position > 0) and (TI <> nil) then
    begin
      TI.Transfer_TransferPosition_string := IntToStr(round((AStream.Position / TI.Transfer_RemoteFileSize) * 100)) + '%';
      TI.Transfer_TransferPosition := AStream.Position;
      TI.Transfer_Velocidade := FileSizeToStr(AStream.Position) + ' / ' +
                       FileSizeToStr(TI.Transfer_RemoteFileSize);

      TempStr := TI.Transfer_RemoteFileName + '|' +
                 IntToStr(TI.Transfer_RemoteFileSize) + '|' +
                 TI.Transfer_LocalFileName + '|' +
                 IntToStr(TI.Transfer_TransferPosition) + '|';
                 try
      MS := TMemoryStream.Create;
      MS.Write(TempStr[1], length(TempStr) * 2);
      MS.SaveToFile(TI.Transfer_LocalFileName + '.xtreme');
      finally
      MS.Free;
       end;
      TI.Transfer_VT.refresh;
    end;
  end;
  if TI <> nil then TI.Transfer_VT.Refresh;
end;

procedure TIdIOHandler.Discard(AByteCount: Int64);
var
  LSize: Integer;
begin
  Assert(AByteCount >= 0);
  if AByteCount > 0 then
  begin
    BeginWork(wmRead, AByteCount);
    try
      repeat
        LSize := iif(AByteCount < MaxInt, Integer(AByteCount), MaxInt);
        LSize := IndyMin(LSize, FInputBuffer.Size);
        if LSize > 0 then begin
          FInputBuffer.Remove(LSize);
          Dec(AByteCount, LSize);
          if AByteCount < 1 then begin
            Break;
          end;
        end;
        // RLebeau: in case the other party disconnects
        // after all of the bytes were transmitted ok.
        // No need to throw an exception just yet...
        if ReadFromSource(False) < 1 then begin
          CheckForDisconnect(True, True);
        end;
      until False;
    finally
      EndWork(wmRead);
    end;
  end;
end;

procedure TIdIOHandler.DiscardAll;
begin
  BeginWork(wmRead);
  try
    // If data already exists in the buffer, discard it first.
    FInputBuffer.Clear;
    // RLebeau - don't call Connected() here!  ReadBytes() already
    // does that internally. Calling Connected() here can cause an
    // EIdConnClosedGracefully exception that breaks the loop
    // prematurely and thus leave unread bytes in the InputBuffer.
    // Let the loop catch the exception before exiting...
    repeat
                                                                       
      try
        if ReadFromSource(False) > 0 then begin
          FInputBuffer.Clear;
        end else begin;
          CheckForDisconnect(True, True);
        end;
      except
        on E: Exception do begin
          // RLebeau - ReadFromSource() could have filled the
          // InputBuffer with more bytes...
          FInputBuffer.Clear;
          if E is EIdConnClosedGracefully then begin
            Break;
          end else begin
            raise;
          end;
        end;
      end;
      TIdAntiFreezeBase.DoProcess;
    until False;
  finally
    EndWork(wmRead);
  end;
end;

procedure TIdIOHandler.RaiseConnClosedGracefully;
begin
  (* ************************************************************* //
  ------ If you receive an exception here, please read. ----------

  If this is a SERVER
  -------------------
  The client has disconnected the socket normally and this exception is used to notify the
  server handling code. This exception is normal and will only happen from within the IDE, not
  while your program is running as an EXE. If you do not want to see this, add this exception
  or EIdSilentException to the IDE options as exceptions not to break on.

  From the IDE just hit F9 again and Indy will catch and handle the exception.

  Please see the FAQ and help file for possible further information.
  The FAQ is at http://www.nevrona.com/Indy/FAQ.html

  If this is a CLIENT
  -------------------
  The server side of this connection has disconnected normaly but your client has attempted
  to read or write to the connection. You should trap this error using a try..except.
  Please see the help file for possible further information.

  // ************************************************************* *)
  raise EIdConnClosedGracefully.Create(RSConnectionClosedGracefully);
end;

function TIdIOHandler.InputBufferAsString(AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  ): string;
begin
  AByteEncoding := iif(AByteEncoding, FDefStringEncoding);
  {$IFDEF STRING_IS_ANSI}
  ADestEncoding := iif(ADestEncoding, FDefAnsiEncoding, encOSDefault);
  {$ENDIF}
  Result := FInputBuffer.ExtractToString(FInputBuffer.Size, AByteEncoding
    {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
    );
end;

function TIdIOHandler.AllData(AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  ): string;
var
  LBytes: Integer;
begin
  Result := '';
  BeginWork(wmRead);
  try
    if Connected then
    begin
      try
        try
          repeat
            LBytes := ReadFromSource(False, 250, False);
          until LBytes = 0; // -1 on timeout
        finally
          if not InputBufferIsEmpty then begin
            Result := InputBufferAsString(AByteEncoding
              {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
              );
          end;
        end;
      except end;
    end;
  finally
    EndWork(wmRead);
  end;
end;

procedure TIdIOHandler.PerformCapture(const ADest: TObject;
  out VLineCount: Integer; const ADelim: string;
  AUsesDotTransparency: Boolean; AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  );
var
  s: string;
  LStream: TStream;
  LStrings: TStrings;
begin
  VLineCount := 0;

  AByteEncoding := iif(AByteEncoding, FDefStringEncoding);
  {$IFDEF STRING_IS_ANSI}
  ADestEncoding := iif(ADestEncoding, FDefAnsiEncoding, encOSDefault);
  {$ENDIF}

  LStream := nil;
  LStrings := nil;

  if ADest is TStrings then begin
    LStrings := TStrings(ADest);
  end
  else if ADest is TStream then begin
    LStream := TStream(ADest);
  end
  else begin
    EIdObjectTypeNotSupported.Toss(RSObjectTypeNotSupported);
  end;

  BeginWork(wmRead);
  try
    repeat
      s := ReadLn(AByteEncoding
        {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
        );
      if s = ADelim then begin
        Exit;
      end;
      // S.G. 6/4/2004: All the consumers to protect themselves against memory allocation attacks
      if FMaxCapturedLines > 0 then  begin
        if VLineCount > FMaxCapturedLines then begin
          raise EIdMaxCaptureLineExceeded.Create(RSMaximumNumberOfCaptureLineExceeded);
        end;
      end;
      // For RFC retrieves that use dot transparency
      // No length check necessary, if only one byte it will be byte x + #0.
      if AUsesDotTransparency then begin
        if TextStartsWith(s, '..') then begin
          Delete(s, 1, 1);
        end;
      end;
      // Write to output
      Inc(VLineCount);
      if LStrings <> nil then begin
        LStrings.Add(s);
      end
      else if LStream <> nil then begin
        WriteStringToStream(LStream, s+EOL, AByteEncoding
          {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
          );
      end;
    until False;
  finally
    EndWork(wmRead);
  end;
end;

function TIdIOHandler.InputLn(const AMask: String = ''; AEcho: Boolean = True;
  ATabWidth: Integer = 8; AMaxLineLength: Integer = -1;
  AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; AAnsiEncoding: IIdTextEncoding = nil{$ENDIF}
  ): String;
var
  i: Integer;
  LChar: ansiChar;
  LTmp: string;
begin
  Result := '';
  AByteEncoding := iif(AByteEncoding, FDefStringEncoding);
  {$IFDEF STRING_IS_ANSI}
  AAnsiEncoding := iif(AAnsiEncoding, FDefAnsiEncoding, encOSDefault);
  {$ENDIF}
  if AMaxLineLength < 0 then begin
    AMaxLineLength := MaxLineLength;
  end;
  repeat
    LChar := ReadChar(AByteEncoding
      {$IFDEF STRING_IS_ANSI}, AAnsiEncoding{$ENDIF}
      );
    i := Length(Result);
    if i <= AMaxLineLength then begin
      case LChar of
        BACKSPACE:
          begin
            if i > 0 then begin
              SetLength(Result, i - 1);
              if AEcho then begin
                Write(BACKSPACE + ' ' + BACKSPACE, AByteEncoding
                  {$IFDEF STRING_IS_ANSI}, AAnsiEncoding{$ENDIF}
                  );
              end;
            end;
          end;
        TAB:
          begin
            if ATabWidth > 0 then begin
              i := ATabWidth - (i mod ATabWidth);
              LTmp := StringOfChar(' ', i);
              Result := Result + LTmp;
              if AEcho then begin
                Write(LTmp, AByteEncoding
                  {$IFDEF STRING_IS_ANSI}, AAnsiEncoding{$ENDIF}
                  );
              end;
            end else begin
              Result := Result + LChar;
              if AEcho then begin
                Write(LChar, AByteEncoding
                  {$IFDEF STRING_IS_ANSI}, AAnsiEncoding{$ENDIF}
                  );
              end;
            end;
          end;
        LF: ;
        CR: ;
        #27: ; //ESC - currently not supported
      else
        Result := Result + LChar;
        if AEcho then begin
          if Length(AMask) = 0 then begin
            Write(LChar, AByteEncoding
              {$IFDEF STRING_IS_ANSI}, AAnsiEncoding{$ENDIF}
              );
          end else begin
            Write(AMask, AByteEncoding
              {$IFDEF STRING_IS_ANSI}, AAnsiEncoding{$ENDIF}
              );
          end;
        end;
      end;
    end;
  until LChar = LF;
  // Remove CR trail
  i := Length(Result);
  while (i > 0) and CharIsInSet(Result, i, EOL) do begin
    Dec(i);
  end;
  SetLength(Result, i);
  if AEcho then begin
    WriteLn(AByteEncoding);
  end;
end;

                                                                   
                                        
                                     
function TIdIOHandler.WaitFor(const AString: string; ARemoveFromBuffer: Boolean = True;
  AInclusive: Boolean = False; AByteEncoding: IIdTextEncoding = nil;
  ATimeout: Integer = IdTimeoutDefault
  {$IFDEF STRING_IS_ANSI}; AAnsiEncoding: IIdTextEncoding = nil{$ENDIF}
  ): string;
var
  LBytes: TIdBytes;
  LPos: Integer;
begin
  Result := '';
  AByteEncoding := iif(AByteEncoding, FDefStringEncoding);
  {$IFDEF STRING_IS_ANSI}
  AAnsiEncoding := iif(AAnsiEncoding, FDefAnsiEncoding, encOSDefault);
  {$ENDIF}
  LBytes := ToBytes(AString, AByteEncoding
    {$IFDEF STRING_IS_ANSI}, AAnsiEncoding{$ENDIF}
    );
  LPos := 0;
  repeat
    LPos := InputBuffer.IndexOf(LBytes, LPos);
    if LPos <> -1 then begin
      if ARemoveFromBuffer and AInclusive then begin
        Result := InputBuffer.ExtractToString(LPos+Length(LBytes), AByteEncoding
          {$IFDEF STRING_IS_ANSI}, AAnsiEncoding{$ENDIF}
          );
      end else begin
        Result := InputBuffer.ExtractToString(LPos, AByteEncoding
          {$IFDEF STRING_IS_ANSI}, AAnsiEncoding{$ENDIF}
          );
        if ARemoveFromBuffer then begin
          InputBuffer.Remove(Length(LBytes));
        end;
        if AInclusive then begin
          Result := Result + AString;
        end;
      end;
      Exit;
    end;
    LPos := IndyMax(0, InputBuffer.Size - (Length(LBytes)-1));
    ReadFromSource(True, ATimeout, True);
  until False;
end;

procedure TIdIOHandler.Capture(ADest: TStream; AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  );
{$IFDEF USE_CLASSINLINE}inline;{$ENDIF}
begin
  Capture(ADest, '.', True, AByteEncoding     {do not localize}
    {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
    );
end;

procedure TIdIOHandler.Capture(ADest: TStream; out VLineCount: Integer;
  const ADelim: string = '.'; AUsesDotTransparency: Boolean = True;
  AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  );
{$IFDEF USE_CLASSINLINE}inline;{$ENDIF}
begin
  PerformCapture(ADest, VLineCount, ADelim, AUsesDotTransparency, AByteEncoding
    {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
    );
end;

procedure TIdIOHandler.Capture(ADest: TStream; ADelim: string;
  AUsesDotTransparency: Boolean = True; AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  );
var
  LLineCount: Integer;
begin
  PerformCapture(ADest, LLineCount, '.', AUsesDotTransparency, AByteEncoding   {do not localize}
    {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
    );
end;

procedure TIdIOHandler.Capture(ADest: TStrings; out VLineCount: Integer;
  const ADelim: string = '.'; AUsesDotTransparency: Boolean = True;
  AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  );
{$IFDEF USE_CLASSINLINE}inline;{$ENDIF}
begin
  PerformCapture(ADest, VLineCount, ADelim, AUsesDotTransparency, AByteEncoding
    {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
    );
end;

procedure TIdIOHandler.Capture(ADest: TStrings; AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  );
var
  LLineCount: Integer;
begin
  PerformCapture(ADest, LLineCount, '.', True, AByteEncoding    {do not localize}
    {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
    );
end;

procedure TIdIOHandler.Capture(ADest: TStrings; const ADelim: string;
  AUsesDotTransparency: Boolean = True; AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  );
var
  LLineCount: Integer;
begin
  PerformCapture(ADest, LLineCount, ADelim, AUsesDotTransparency, AByteEncoding
    {$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF}
    );
end;

procedure TIdIOHandler.InputBufferToStream(AStream: TStream; AByteCount: Integer = -1);
{$IFDEF USE_CLASSINLINE}inline;{$ENDIF}
begin
  FInputBuffer.ExtractToStream(AStream, AByteCount);
end;

function TIdIOHandler.InputBufferIsEmpty: Boolean;
{$IFDEF USE_CLASSINLINE}inline;{$ENDIF}
begin
  Result := FInputBuffer.Size = 0;
end;

procedure TIdIOHandler.Write(const ABuffer: TIdBytes; const ALength: Integer = -1;
  const AOffset: Integer = 0);
var
  LLength: Integer;
begin
  LLength := IndyLength(ABuffer, ALength, AOffset);
  if LLength > 0 then begin
    if FWriteBuffer = nil then begin
      WriteDirect(ABuffer, LLength, AOffset);
    end else begin
      // Write Buffering is enabled
      FWriteBuffer.Write(ABuffer, LLength, AOffset);
      if (FWriteBuffer.Size >= WriteBufferThreshold) and (WriteBufferThreshold > 0) then begin
        repeat
          WriteBufferFlush(WriteBufferThreshold);
        until FWriteBuffer.Size < WriteBufferThreshold;
      end;
    end;
  end;
end;

procedure TIdIOHandler.WriteRFCStrings(AStrings: TStrings; AWriteTerminator: Boolean = True;
  AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ASrcEncoding: IIdTextEncoding = nil{$ENDIF}
  );
var
  i: Integer;
begin
  AByteEncoding := iif(AByteEncoding, FDefStringEncoding);
  {$IFDEF STRING_IS_ANSI}
  ASrcEncoding := iif(ASrcEncoding, FDefAnsiEncoding, encOSDefault);
  {$ENDIF}
  for i := 0 to AStrings.Count - 1 do begin
    WriteLnRFC(AStrings[i], AByteEncoding
      {$IFDEF STRING_IS_ANSI}, ASrcEncoding{$ENDIF}
      );
  end;
  if AWriteTerminator then begin
    WriteLn('.', AByteEncoding
      {$IFDEF STRING_IS_ANSI}, ASrcEncoding{$ENDIF}
      );
  end;
end;

function TIdIOHandler.WriteFile(const AFile: String; AEnableTransferFile: Boolean): Int64;
var
                                                                           
  LStream: TStream;
  {$IFDEF WIN32_OR_WIN64}
  LOldErrorMode : Integer;
  {$ENDIF}
begin
  Result := 0;
  {$IFDEF WIN32_OR_WIN64}
  LOldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
  {$ENDIF}
    if not FileExists(AFile) then begin
      raise EIdFileNotFound.CreateFmt(RSFileNotFound, [AFile]);
    end;
    LStream := TIdReadFileExclusiveStream.Create(AFile);
    try
      Write(LStream);
      Result := LStream.Size;
    finally
      FreeAndNil(LStream);
    end;
  {$IFDEF WIN32_OR_WIN64}
  finally
    SetErrorMode(LOldErrorMode)
  end;
  {$ENDIF}
end;

function TIdIOHandler.WriteBufferingActive: Boolean;
{$IFDEF USE_CLASSINLINE}inline;{$ENDIF}
begin
  Result := FWriteBuffer <> nil;
end;

procedure TIdIOHandler.CloseGracefully;
begin
  FClosedGracefully := True
end;

procedure TIdIOHandler.InterceptReceive(var VBuffer: TIdBytes);
var
  // under ARC, convert a weak reference to a strong reference before working with it
  LIntercept: TIdConnectionIntercept;
begin
  LIntercept := Intercept;
  if LIntercept <> nil then begin
    LIntercept.Receive(VBuffer);
  end;
end;

procedure TIdIOHandler.InitComponent;
begin
  inherited InitComponent;
  FRecvBufferSize := GRecvBufferSizeDefault;
  FSendBufferSize := GSendBufferSizeDefault;
  FMaxLineLength := IdMaxLineLengthDefault;
  FMaxCapturedLines := Id_IOHandler_MaxCapturedLines;
  FLargeStream := False;
  FReadTimeOut := IdTimeoutDefault;
  FInputBuffer := TIdBuffer.Create(BufferRemoveNotify);
  FDefStringEncoding := IndyTextEncoding_ASCII;
  {$IFDEF STRING_IS_ANSI}
  FDefAnsiEncoding := IndyTextEncoding_OSDefault;
  {$ENDIF}
end;

procedure TIdIOHandler.WriteBufferFlush;
begin
  WriteBufferFlush(-1);
end;

procedure TIdIOHandler.WriteBufferOpen;
begin
  WriteBufferOpen(-1);
end;

procedure TIdIOHandler.WriteDirect(const ABuffer: TIdBytes; const ALength: Integer = -1;
  const AOffset: Integer = 0);
var
  LTemp: TIdBytes;
  LPos: Integer;
  LSize: Integer;
  LByteCount: Integer;
  LLastError: Integer;
  // under ARC, convert a weak reference to a strong reference before working with it
  LIntercept: TIdConnectionIntercept;
begin
  // Check if disconnected
  CheckForDisconnect(True, True);

  LIntercept := Intercept;
  if LIntercept <> nil then begin
                                                         
    // so that a copy is no longer needed here
    LTemp := ToBytes(ABuffer, ALength, AOffset);
    LIntercept.Send(LTemp);
    {$IFDEF USE_OBJECT_ARC}LIntercept := nil;{$ENDIF}
    LSize := Length(LTemp);
    LPos := 0;
  end else begin
    LTemp := ABuffer;
    LSize := IndyLength(LTemp, ALength, AOffset);
    LPos := AOffset;
  end;
  while LSize > 0 do
  begin
    LByteCount := WriteDataToTarget(LTemp, LPos, LSize);
    if LByteCount < 0 then
    begin
      LLastError := CheckForError(LByteCount);
      if LLastError <> Id_WSAETIMEDOUT then begin
        FClosedGracefully := True;
        Close;
      end;
      RaiseError(LLastError);
    end;
                                                                                          
    // can be called more. Maybe a prop of the connection, MaxSendSize?
    TIdAntiFreezeBase.DoProcess(False);
    if LByteCount = 0 then begin
      FClosedGracefully := True;
    end;
    // Check if other side disconnected
    CheckForDisconnect;
    DoWork(wmWrite, LByteCount);
    Inc(LPos, LByteCount);
    Dec(LSize, LByteCount);
  end;
end;

initialization

finalization
  FreeAndNil(GIOHandlerClassList)
end.
