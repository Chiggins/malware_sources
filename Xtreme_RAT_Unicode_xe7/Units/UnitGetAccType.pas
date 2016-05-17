unit UnitGetAccType;

interface

uses
  windows,
  sysutils;
  
function Is64BitOS: Boolean;
function IsAdministrator: Boolean;

implementation

function IsWinNT: boolean;
var
  OSVersionInfo : TOSVersionInfo;
begin
  result := False;
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
    result := (OSVersionInfo.dwPlatformId =
      VER_PLATFORM_WIN32_NT);
end;

const
  SECURITY_NT_AUTHORITY: TSidIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
  {$EXTERNALSYM SECURITY_NT_AUTHORITY}

  SECURITY_DIALUP_RID                 = ($00000001);
  {$EXTERNALSYM SECURITY_DIALUP_RID}
  SECURITY_NETWORK_RID                = ($00000002);
  {$EXTERNALSYM SECURITY_NETWORK_RID}
  SECURITY_BATCH_RID                  = ($00000003);
  {$EXTERNALSYM SECURITY_BATCH_RID}
  SECURITY_INTERACTIVE_RID            = ($00000004);
  {$EXTERNALSYM SECURITY_INTERACTIVE_RID}
  SECURITY_LOGON_IDS_RID              = ($00000005);
  {$EXTERNALSYM SECURITY_LOGON_IDS_RID}
  SECURITY_LOGON_IDS_RID_COUNT        = (3);
  {$EXTERNALSYM SECURITY_LOGON_IDS_RID_COUNT}
  SECURITY_SERVICE_RID                = ($00000006);
  {$EXTERNALSYM SECURITY_SERVICE_RID}
  SECURITY_ANONYMOUS_LOGON_RID        = ($00000007);
  {$EXTERNALSYM SECURITY_ANONYMOUS_LOGON_RID}
  SECURITY_PROXY_RID                  = ($00000008);
  {$EXTERNALSYM SECURITY_PROXY_RID}
  SECURITY_ENTERPRISE_CONTROLLERS_RID = ($00000009);
  {$EXTERNALSYM SECURITY_ENTERPRISE_CONTROLLERS_RID}
  SECURITY_SERVER_LOGON_RID           = SECURITY_ENTERPRISE_CONTROLLERS_RID;
  {$EXTERNALSYM SECURITY_SERVER_LOGON_RID}
  SECURITY_PRINCIPAL_SELF_RID         = ($0000000A);
  {$EXTERNALSYM SECURITY_PRINCIPAL_SELF_RID}
  SECURITY_AUTHENTICATED_USER_RID     = ($0000000B);
  {$EXTERNALSYM SECURITY_AUTHENTICATED_USER_RID}
  SECURITY_RESTRICTED_CODE_RID        = ($0000000C);
  {$EXTERNALSYM SECURITY_RESTRICTED_CODE_RID}
  SECURITY_TERMINAL_SERVER_RID        = ($0000000D);
  {$EXTERNALSYM SECURITY_TERMINAL_SERVER_RID}
  SECURITY_REMOTE_LOGON_RID           = ($0000000E);
  {$EXTERNALSYM SECURITY_REMOTE_LOGON_RID}
  SECURITY_THIS_ORGANIZATION_RID      = ($0000000F);
  {$EXTERNALSYM SECURITY_THIS_ORGANIZATION_RID}

  SECURITY_LOCAL_SYSTEM_RID    = ($00000012);
  {$EXTERNALSYM SECURITY_LOCAL_SYSTEM_RID}
  SECURITY_LOCAL_SERVICE_RID   = ($00000013);
  {$EXTERNALSYM SECURITY_LOCAL_SERVICE_RID}
  SECURITY_NETWORK_SERVICE_RID = ($00000014);
  {$EXTERNALSYM SECURITY_NETWORK_SERVICE_RID}

  SECURITY_NT_NON_UNIQUE       = ($00000015);
  {$EXTERNALSYM SECURITY_NT_NON_UNIQUE}
  SECURITY_NT_NON_UNIQUE_SUB_AUTH_COUNT = (3);
  {$EXTERNALSYM SECURITY_NT_NON_UNIQUE_SUB_AUTH_COUNT}

  SECURITY_BUILTIN_DOMAIN_RID  = ($00000020);
  {$EXTERNALSYM SECURITY_BUILTIN_DOMAIN_RID}

  SECURITY_PACKAGE_BASE_RID       = ($00000040);
  {$EXTERNALSYM SECURITY_PACKAGE_BASE_RID}
  SECURITY_PACKAGE_RID_COUNT      = (2);
  {$EXTERNALSYM SECURITY_PACKAGE_RID_COUNT}
  SECURITY_PACKAGE_NTLM_RID       = ($0000000A);
  {$EXTERNALSYM SECURITY_PACKAGE_NTLM_RID}
  SECURITY_PACKAGE_SCHANNEL_RID   = ($0000000E);
  {$EXTERNALSYM SECURITY_PACKAGE_SCHANNEL_RID}
  SECURITY_PACKAGE_DIGEST_RID     = ($00000015);
  {$EXTERNALSYM SECURITY_PACKAGE_DIGEST_RID}

  SECURITY_MAX_ALWAYS_FILTERED    = ($000003E7);
  {$EXTERNALSYM SECURITY_MAX_ALWAYS_FILTERED}
  SECURITY_MIN_NEVER_FILTERED     = ($000003E8);
  {$EXTERNALSYM SECURITY_MIN_NEVER_FILTERED}

  SECURITY_OTHER_ORGANIZATION_RID = ($000003E8);
  {$EXTERNALSYM SECURITY_OTHER_ORGANIZATION_RID}

/////////////////////////////////////////////////////////////////////////////
//                                                                         //
// well-known domain relative sub-authority values (RIDs)...               //
//                                                                         //
/////////////////////////////////////////////////////////////////////////////

// Well-known users ...

  FOREST_USER_RID_MAX    = ($000001F3);
  {$EXTERNALSYM FOREST_USER_RID_MAX}

  DOMAIN_USER_RID_ADMIN  = ($000001F4);
  {$EXTERNALSYM DOMAIN_USER_RID_ADMIN}
  DOMAIN_USER_RID_GUEST  = ($000001F5);
  {$EXTERNALSYM DOMAIN_USER_RID_GUEST}
  DOMAIN_USER_RID_KRBTGT = ($000001F6);
  {$EXTERNALSYM DOMAIN_USER_RID_KRBTGT}

  DOMAIN_USER_RID_MAX    = ($000003E7);
  {$EXTERNALSYM DOMAIN_USER_RID_MAX}

// well-known groups ...

  DOMAIN_GROUP_RID_ADMINS            = ($00000200);
  {$EXTERNALSYM DOMAIN_GROUP_RID_ADMINS}
  DOMAIN_GROUP_RID_USERS             = ($00000201);
  {$EXTERNALSYM DOMAIN_GROUP_RID_USERS}
  DOMAIN_GROUP_RID_GUESTS            = ($00000202);
  {$EXTERNALSYM DOMAIN_GROUP_RID_GUESTS}
  DOMAIN_GROUP_RID_COMPUTERS         = ($00000203);
  {$EXTERNALSYM DOMAIN_GROUP_RID_COMPUTERS}
  DOMAIN_GROUP_RID_CONTROLLERS       = ($00000204);
  {$EXTERNALSYM DOMAIN_GROUP_RID_CONTROLLERS}
  DOMAIN_GROUP_RID_CERT_ADMINS       = ($00000205);
  {$EXTERNALSYM DOMAIN_GROUP_RID_CERT_ADMINS}
  DOMAIN_GROUP_RID_SCHEMA_ADMINS     = ($00000206);
  {$EXTERNALSYM DOMAIN_GROUP_RID_SCHEMA_ADMINS}
  DOMAIN_GROUP_RID_ENTERPRISE_ADMINS = ($00000207);
  {$EXTERNALSYM DOMAIN_GROUP_RID_ENTERPRISE_ADMINS}
  DOMAIN_GROUP_RID_POLICY_ADMINS     = ($00000208);
  {$EXTERNALSYM DOMAIN_GROUP_RID_POLICY_ADMINS}

// well-known aliases ...

  DOMAIN_ALIAS_RID_ADMINS           = ($00000220);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_ADMINS}
  DOMAIN_ALIAS_RID_USERS            = ($00000221);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_USERS}
  DOMAIN_ALIAS_RID_GUESTS           = ($00000222);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_GUESTS}
  DOMAIN_ALIAS_RID_POWER_USERS      = ($00000223);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_POWER_USERS}

  DOMAIN_ALIAS_RID_ACCOUNT_OPS      = ($00000224);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_ACCOUNT_OPS}
  DOMAIN_ALIAS_RID_SYSTEM_OPS       = ($00000225);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_SYSTEM_OPS}
  DOMAIN_ALIAS_RID_PRINT_OPS        = ($00000226);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_PRINT_OPS}
  DOMAIN_ALIAS_RID_BACKUP_OPS       = ($00000227);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_BACKUP_OPS}

  DOMAIN_ALIAS_RID_REPLICATOR       = ($00000228);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_REPLICATOR}
  DOMAIN_ALIAS_RID_RAS_SERVERS      = ($00000229);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_RAS_SERVERS}
  DOMAIN_ALIAS_RID_PREW2KCOMPACCESS = ($0000022A);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_PREW2KCOMPACCESS}
  DOMAIN_ALIAS_RID_REMOTE_DESKTOP_USERS = ($0000022B);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_REMOTE_DESKTOP_USERS}
  DOMAIN_ALIAS_RID_NETWORK_CONFIGURATION_OPS = ($0000022C);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_NETWORK_CONFIGURATION_OPS}
  DOMAIN_ALIAS_RID_INCOMING_FOREST_TRUST_BUILDERS = ($0000022D);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_INCOMING_FOREST_TRUST_BUILDERS}

  DOMAIN_ALIAS_RID_MONITORING_USERS      = ($0000022E);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_MONITORING_USERS}
  DOMAIN_ALIAS_RID_LOGGING_USERS         = ($0000022F);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_LOGGING_USERS}

  DOMAIN_ALIAS_RID_AUTHORIZATIONACCESS   = ($00000230);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_AUTHORIZATIONACCESS}
  DOMAIN_ALIAS_RID_TS_LICENSE_SERVERS    = ($00000231);
  {$EXTERNALSYM DOMAIN_ALIAS_RID_TS_LICENSE_SERVERS}

function IsGroupMember(RelativeGroupID: DWORD): Boolean;
var
  psidAdmin: Pointer;
  Token: THandle;
  Count: DWORD;
  TokenInfo: PTokenGroups;
  HaveToken: Boolean;
  I: Integer;
const
  SE_GROUP_USE_FOR_DENY_ONLY = $00000010;
begin
  Result := not IsWinNT;
  if Result then // Win9x and ME don't have user groups
    Exit;
  psidAdmin := nil;
  TokenInfo := nil;
  HaveToken := False;
  try
    Token := 0;
    HaveToken := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True, Token);
    if (not HaveToken) and (GetLastError = ERROR_NO_TOKEN) then
      HaveToken := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, Token);
    if HaveToken then
    begin
      {$IFDEF FPC}
      Win32Check(AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
        SECURITY_BUILTIN_DOMAIN_RID, RelativeGroupID, 0, 0, 0, 0, 0, 0,
        psidAdmin));
      if GetTokenInformation(Token, TokenGroups, nil, 0, @Count) or
       (GetLastError <> ERROR_INSUFFICIENT_BUFFER) then
         RaiseLastOSError;
      TokenInfo := PTokenGroups(AllocMem(Count));
      Win32Check(GetTokenInformation(Token, TokenGroups, TokenInfo, Count, @Count));
      {$ELSE FPC}
      Win32Check(AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
        SECURITY_BUILTIN_DOMAIN_RID, RelativeGroupID, 0, 0, 0, 0, 0, 0,
        psidAdmin));
      if GetTokenInformation(Token, TokenGroups, nil, 0, Count) or
       (GetLastError <> ERROR_INSUFFICIENT_BUFFER) then
         RaiseLastOSError;
      TokenInfo := PTokenGroups(AllocMem(Count));
      Win32Check(GetTokenInformation(Token, TokenGroups, TokenInfo, Count, Count));
      {$ENDIF FPC}
      for I := 0 to TokenInfo^.GroupCount - 1 do
      begin
        {$RANGECHECKS OFF} // Groups is an array [0..0] of TSIDAndAttributes, ignore ERangeError
        Result := EqualSid(psidAdmin, TokenInfo^.Groups[I].Sid);
        if Result then
        begin
          //consider denied ACE with Administrator SID
          Result := TokenInfo^.Groups[I].Attributes and SE_GROUP_USE_FOR_DENY_ONLY
              <> SE_GROUP_USE_FOR_DENY_ONLY;
          Break;
        end;
        {$IFDEF RANGECHECKS_ON}
        {$RANGECHECKS ON}
        {$ENDIF RANGECHECKS_ON}
      end;
    end;
  finally
    if TokenInfo <> nil then
      FreeMem(TokenInfo);
    if HaveToken then
      CloseHandle(Token);
    if psidAdmin <> nil then
      FreeSid(psidAdmin);
  end;
end;

function IsAdministrator: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_ADMINS);
end;

function IsUser: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_USERS);
end;

function IsGuest: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_GUESTS);
end;

function IsPowerUser: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_POWER_USERS);
end;

function IsAccountOperator: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_ACCOUNT_OPS);
end;

function IsSystemOperator: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_SYSTEM_OPS);
end;

function IsPrintOperator: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_PRINT_OPS);
end;

function IsBackupOperator: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_BACKUP_OPS);
end;

function IsReplicator: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_REPLICATOR);
end;

function IsRASServer: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_RAS_SERVERS);
end;

function IsPreWin2000CompAccess: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_PREW2KCOMPACCESS);
end;

function IsRemoteDesktopUser: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_REMOTE_DESKTOP_USERS);
end;

function IsNetworkConfigurationOperator: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_NETWORK_CONFIGURATION_OPS);
end;

function IsIncomingForestTrustBuilder: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_INCOMING_FOREST_TRUST_BUILDERS);
end;

function IsMonitoringUser: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_MONITORING_USERS);
end;

function IsLoggingUser: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_LOGGING_USERS);
end;

function IsAuthorizationAccess: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_AUTHORIZATIONACCESS);
end;

function IsTSLicenseServer: Boolean;
begin
  Result := IsGroupMember(DOMAIN_ALIAS_RID_TS_LICENSE_SERVERS);
end;

function Is64BitOS: Boolean;
type
  TIsWow64Process = function(Handle:THandle; var IsWow64 : BOOL) : BOOL; stdcall;
var
  hKernel32 : Integer;
  IsWow64Process : TIsWow64Process;
  IsWow64 : BOOL;
begin
  // we can check if the operating system is 64-bit by checking whether
  // we are running under Wow64 (we are 32-bit code). We must check if this
  // function is implemented before we call it, because some older versions
  // of kernel32.dll (eg. Windows 2000) don't know about it.
  // see http://msdn.microsoft.com/en-us/library/ms684139%28VS.85%29.aspx
  Result := False;
  hKernel32 := LoadLibrary('kernel32.dll');
  if (hKernel32 = 0) then Exit;
  @IsWow64Process := GetProcAddress(hkernel32, 'IsWow64Process');
  if Assigned(IsWow64Process) then begin
    IsWow64 := False;
    if (IsWow64Process(GetCurrentProcess, IsWow64)) then begin
      Result := IsWow64;
    end
    else Exit;
  end;
  FreeLibrary(hKernel32);
end;

end.
