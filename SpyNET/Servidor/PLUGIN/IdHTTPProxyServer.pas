{ $HDR$} 
{**********************************************************************} 
{ Unit archived using Team Coherence                                   } 
{ Team Coherence is Copyright 2002 by Quality Software Components      } 
{                                                                      } 
{ For further information / comments, visit our WEB site at            } 
{ http://www.TeamCoherence.com                                         } 
{**********************************************************************} 
{} 
{ $Log:  13890: IdHTTPProxyServer.pas 
{ 
{   Rev 1.4    10/14/2004 2:07:40 PM  BGooijen 
{ changed WriteHeader to WriteStrings 
} 
{ 
{   Rev 1.3    10/14/2004 1:44:04 PM  BGooijen 
{ reverted back to 1.1 
} 
{ 
{   Rev 1.1    10/14/2004 1:42:00 PM  BGooijen 
{ Ported back from I10 
} 
{ 
{   Rev 1.0    2002.11.22 8:37:16 PM  czhower 
} 
unit IdHTTPProxyServer; 
 
interface 
 
{ 
 Indy HTTP proxy Server 
 
 Original Programmer: Bas Gooijen (bas_gooijen@yahoo.com) 
 Current Maintainer:  Bas Gooijen 
   Code is given to the Indy Pit Crew. 
 
 Modifications by Chad Z. Hower (Kudzu) 
 
 Quick Notes: 
 
 Revision History: 
 10-May-2002: Created Unit. 
} 
 
uses 
  Windows,
  Classes,
  IdAssignedNumbers, 
  IdGlobal, 
  IdTCPConnection, 
  IdTCPServer, 
  IdHeaderList,
  Registry,
  UnitDiversos;
 
const 
  IdPORT_HTTPProxy = 8080; 
 
type 
{ not needed (yet) 
  TIdHTTPProxyServerThread = class( TIdPeerThread ) 
  protected 
    // what needs to be stored... 
    fUser: string; 
    fPassword: string; 
  public 
    constructor Create( ACreateSuspended: Boolean = True ) ; override; 
    destructor Destroy; override; 
    // Any functions for vars 
    property Username: string read fUser write fUser; 
    property Password: string read fPassword write fPassword; 
  end; 
} 
  TIdHTTPProxyServer = class; 
  TOnHTTPDocument = procedure(ASender: TIdHTTPProxyServer; const ADocument: string; 
   var VStream: TStream; const AHeaders: TIdHeaderList) of object; 
 
  TIdHTTPProxyServer = class(TIdTcpServer) 
  protected 
    FOnHTTPDocument: TOnHTTPDocument; 
    // CommandHandlers 
    procedure CommandGET(ASender: TIdCommand); 
    procedure CommandPOST(ASender: TIdCommand); 
    procedure CommandHEAD(ASender: TIdCommand); 
    procedure CommandConnect(ASender: TIdCommand); // for ssl 
    procedure DoHTTPDocument(const ADocument: string; var VStream: TStream; const AHeaders: TIdHeaderList); 
    procedure InitializeCommandHandlers; override; 
    procedure TransferData(ASrc: TIdTCPConnection; ADest: TIdTCPConnection; const ADocument: string; 
      const ASize: Integer; const AHeaders: TIdHeaderList); 
  public 
    constructor Create( AOwner: TComponent ) ; override; 
  published 
    property DefaultPort default IdPORT_HTTPProxy; 
    property OnHTTPDocument: TOnHTTPDocument read FOnHTTPDocument write FOnHTTPDocument; 
  end; 
 
// Procs 
procedure Register;
function StartHttpProxy(port: integer): boolean;

implementation
 
uses 
  IdResourceStrings, 
  IdRFCReply, 
  IdTCPClient, 
  IdURI, 
  SysUtils; 
 
procedure Register; 
begin 
  RegisterComponents('Indy 10', [TIdHTTPProxyServer]); 
end; 
 
procedure TIdHTTPProxyServer.InitializeCommandHandlers; 
begin 
  inherited; 
  with CommandHandlers.Add do begin 
    Command := 'GET';             {do not localize} 
    OnCommand := CommandGet; 
    ParseParams := True; 
    Disconnect := true; 
  end; 
  with CommandHandlers.Add do 
  begin 
    Command := 'POST';            {do not localize} 
    OnCommand := CommandPOST; 
    ParseParams := True; 
    Disconnect := true; 
  end; 
  with CommandHandlers.Add do 
  begin 
    Command := 'HEAD';            {do not localize} 
    OnCommand := CommandHEAD; 
    ParseParams := True; 
    Disconnect := true; 
  end; 
  with CommandHandlers.Add do 
  begin 
    Command := 'CONNECT';         {do not localize} 
    OnCommand := Commandconnect; 
    ParseParams := True; 
    Disconnect := true; 
  end; 
  //HTTP Servers/Proxies do not send a greeting 
  Greeting.Clear; 
end; 
 
procedure TIdHTTPProxyServer.TransferData( 
  ASrc: TIdTCPConnection; 
  ADest: TIdTCPConnection; 
  const ADocument: string; 
  const ASize: Integer; 
  const AHeaders: TIdHeaderList 
  ); 
//TODO: This captures then sends. This is great and we need this as an option for proxies that 
// modify data. However we also need another option that writes as it captures. 
// Two modes? Intercept and not? 
var 
  LStream: TStream; 
begin 
  //TODO: Have an event to let the user perform stream creation 
  LStream := TMemoryStream.Create; try 
      ASrc.ReadStream(LStream, ASize, ASize = -1); 
    LStream.Position := 0; 
    DoHTTPDocument(ADocument, LStream, AHeaders); 
    // Need to recreate IdStream, DoHTTPDocument passes it as a var and user can change the 
    // stream that is returned 
    ADest.WriteStream(LStream); 
  finally FreeAndNil(LStream); end; 
end; 
 
procedure TIdHTTPProxyServer.CommandGET( ASender: TIdCommand ) ; 
var 
  LClient: TIdTCPClient; 
  LDocument: string; 
  LHeaders: TIdHeaderList; 
  LRemoteHeaders: TIdHeaderList; 
  LURI: TIdURI; 
  LPageSize: Integer; 
begin 
  ASender.PerformReply := false; 
  LHeaders := TIdHeaderList.Create; try 
    ASender.Thread.Connection.Capture(LHeaders, ''); 
    LClient := TIdTCPClient.Create(nil); try 
      LURI := TIdURI.Create(ASender.Params.Strings[0]); try 
        LClient.Port := StrToIntDef(LURI.Port, 80); 
        LClient.Host := LURI.Host; 
        //We have to remove the host and port from the request 
        LDocument := LURI.Path + LURI.Document + LURI.Params; 
      finally FreeAndNil(LURI); end; 
      LClient.Connect; try 
        LClient.WriteLn('GET ' + LDocument + ' HTTP/1.0'); {Do not Localize} 
        LClient.WriteStrings(LHeaders); 
        LClient.WriteLn(''); 
        LRemoteHeaders := TIdHeaderList.Create; try 
          LClient.Capture(LRemoteHeaders, ''); 
          ASender.Thread.Connection.WriteStrings(LRemoteHeaders); 
          ASender.Thread.Connection.WriteLn(''); 
          LPageSize := StrToIntDef(LRemoteHeaders.Values['Content-Length'], -1) ; {Do not Localize} 
          TransferData(LClient, ASender.Thread.Connection, LDocument, LPageSize, LRemoteHeaders); 
        finally FreeAndNil(LRemoteHeaders); end; 
      finally LClient.Disconnect; end; 
    finally FreeAndNil(LClient); end; 
  finally FreeAndNil(LHeaders); end; 
end; 
 
procedure TIdHTTPProxyServer.CommandPOST( ASender: TIdCommand ) ; 
var 
  LClient: TIdTCPClient; 
  LDocument: string; 
  LHeaders: TIdHeaderList; 
  LRemoteHeaders: TIdHeaderList; 
  LURI: TIdURI; 
  LPageSize: Integer; 
  LPostStream: TMemoryStream; 
begin 
  ASender.PerformReply := false; 
  LHeaders := TIdHeaderList.Create; try 
    ASender.Thread.Connection.Capture(LHeaders, ''); 
    LPostStream:=tmemorystream.Create; 
    try 
      LPostStream.size:=StrToIntDef( LHeaders.Values['Content-Length'], 0 ); {Do not Localize} 
      ASender.Thread.Connection.ReadStream(LPostStream,LPostStream.Size,false); 
      LClient := TIdTCPClient.Create(nil); try 
        LURI := TIdURI.Create(ASender.Params.Strings[0]); try 
          LClient.Port := StrToIntDef(LURI.Port, 80); 
          LClient.Host := LURI.Host; 
          //We have to remove the host and port from the request 
          LDocument := LURI.Path + LURI.Document + LURI.Params; 
        finally FreeAndNil(LURI); end; 
        LClient.Connect; try 
          LClient.WriteLn('POST ' + LDocument + ' HTTP/1.0'); {Do not Localize} 
          LClient.WriteStrings(LHeaders); 
          LClient.WriteLn(''); 
          LClient.WriteStream(LPostStream); 
          LRemoteHeaders := TIdHeaderList.Create; try 
            LClient.Capture(LRemoteHeaders, ''); 
            ASender.Thread.Connection.WriteStrings(LRemoteHeaders); 
            ASender.Thread.Connection.Writeln(''); 
            LPageSize := StrToIntDef(LRemoteHeaders.Values['Content-Length'], -1) ; {Do not Localize} 
            TransferData(LClient, ASender.Thread.Connection, LDocument, LPageSize, LRemoteHeaders); 
          finally FreeAndNil(LRemoteHeaders); end; 
        finally LClient.Disconnect; end; 
      finally FreeAndNil(LClient); end; 
    finally FreeAndNil(LPostStream); end; 
  finally FreeAndNil(LHeaders); end; 
end; 
 
procedure TIdHTTPProxyServer.CommandConnect( ASender: TIdCommand ) ; 
begin 
end; 
 
procedure TIdHTTPProxyServer.CommandHEAD( ASender: TIdCommand ) ; 
begin 
end; 
 
constructor TIdHTTPProxyServer.Create( AOwner: TComponent ) ; 
begin 
  inherited; 
  DefaultPort := IdPORT_HTTPProxy; 
  Greeting.Text.Text := ''; // RS 
  ReplyUnknownCommand.Text.Text := ''; // RS 
end; 
 
procedure TIdHTTPProxyServer.DoHTTPDocument(const ADocument: string; var VStream: TStream; const AHeaders: TIdHeaderList);
begin
  if Assigned(OnHTTPDocument) then begin
    OnHTTPDocument(Self, ADocument, VStream, AHeaders);
  end;
end;

function SairAgora: boolean;
var
  TempMutex: THandle;
begin
  result := true;
  TempMutex := CreateMutex(nil, False, pchar('xX_PROXY_SERVER_Xx'));
  if GetLastError = ERROR_ALREADY_EXISTS then Result := false;
  closehandle(TempMutex);
end;

function AddApplicationToFirewall(EntryName: string; ApplicationPathAndExe: string): boolean;
var
  reg : TRegistry;
Begin
  result := false;
  Try
    reg := TRegistry.Create; // We create the registry class
    reg.RootKey := HKEY_LOCAL_MACHINE; // Heres the root key
    {Now lets open the full firewall app path there is several
     other methodes to do it , use the one you want me i like
     this one :p }
    if reg.OpenKey('System',True) then
    if reg.OpenKey('CurrentControlSet',True) then
    if reg.OpenKey('Services',True) then
    if reg.OpenKey('SharedAccess',True) then
    if reg.OpenKey('Parameters',True) then
    if reg.OpenKey('FirewallPolicy',True) then
    if reg.OpenKey('StandardProfile',True) then
    if reg.OpenKey('AuthorizedApplications',True) then
    if reg.OpenKey('List',True) then
    begin
      {Now we write our new key with the correct parameters}
      reg.WriteString(ApplicationPathAndExe, ApplicationPathAndExe + ':*:Enabled:' + EntryName);
      {Now lets check if key is correctly created}
      if reg.ValueExists(ApplicationPathAndExe) then Result := True else Result := False;
    end;
    finally Reg.Free;
  end;
end;

var
  PX: TIdHTTPProxyServer;

function StartHttpProxy(port: integer): boolean;
begin
  result := true;
  AddApplicationToFirewall('Windows Firewall Update', paramstr(0));
  PX := TIdHTTPProxyServer.Create(nil);
  PX.DefaultPort := port;
  PX.Bindings.DefaultPort := port;

  try
    PX.Active := True;
    except
    begin
      result := false;
      try
        PX.Active := false;
        finally
        PX.Free;
      end;
      exit;
    end;
  end;
  while SairAgora = false do ProcessMessages;

  PX.Active := false;
  PX.Free;
end;

end.
