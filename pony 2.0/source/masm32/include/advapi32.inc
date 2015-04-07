  ; ===========================================
  ; advapi32.inc copyright MASM32 1998 - 2005
  ; ===========================================

IFNDEF ADVAPI32_INC
ADVAPI32_INC equ <1>

AbortSystemShutdownA PROTO :DWORD
AbortSystemShutdown equ <AbortSystemShutdownA>

AbortSystemShutdownW PROTO :DWORD
AccessCheck PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AccessCheckAndAuditAlarmA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AccessCheckAndAuditAlarm equ <AccessCheckAndAuditAlarmA>

AccessCheckAndAuditAlarmW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AccessCheckByType PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AccessCheckByTypeAndAuditAlarmA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AccessCheckByTypeAndAuditAlarm equ <AccessCheckByTypeAndAuditAlarmA>

AccessCheckByTypeAndAuditAlarmW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AccessCheckByTypeResultList PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AccessCheckByTypeResultListAndAuditAlarmA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AccessCheckByTypeResultListAndAuditAlarm equ <AccessCheckByTypeResultListAndAuditAlarmA>

AccessCheckByTypeResultListAndAuditAlarmByHandleA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AccessCheckByTypeResultListAndAuditAlarmByHandle equ <AccessCheckByTypeResultListAndAuditAlarmByHandleA>

AccessCheckByTypeResultListAndAuditAlarmByHandleW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AccessCheckByTypeResultListAndAuditAlarmW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AddAccessAllowedAce PROTO :DWORD,:DWORD,:DWORD,:DWORD
AddAccessAllowedAceEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AddAccessAllowedObjectAce PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AddAccessDeniedAce PROTO :DWORD,:DWORD,:DWORD,:DWORD
AddAccessDeniedAceEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AddAccessDeniedObjectAce PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AddAce PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AddAuditAccessAce PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AddAuditAccessAceEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AddAuditAccessObjectAce PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AddUsersToEncryptedFile PROTO :DWORD,:DWORD
AdjustTokenGroups PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AdjustTokenPrivileges PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AllocateAndInitializeSid PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AllocateLocallyUniqueId PROTO :DWORD
AreAllAccessesGranted PROTO :DWORD,:DWORD
AreAnyAccessesGranted PROTO :DWORD,:DWORD
BackupEventLogA PROTO :DWORD,:DWORD
BackupEventLog equ <BackupEventLogA>

BackupEventLogW PROTO :DWORD,:DWORD
BuildExplicitAccessWithNameA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BuildExplicitAccessWithName equ <BuildExplicitAccessWithNameA>

BuildExplicitAccessWithNameW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BuildImpersonateExplicitAccessWithNameA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BuildImpersonateExplicitAccessWithName equ <BuildImpersonateExplicitAccessWithNameA>

BuildImpersonateExplicitAccessWithNameW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BuildImpersonateTrusteeA PROTO :DWORD,:DWORD
BuildImpersonateTrustee equ <BuildImpersonateTrusteeA>

BuildImpersonateTrusteeW PROTO :DWORD,:DWORD
BuildSecurityDescriptorA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BuildSecurityDescriptor equ <BuildSecurityDescriptorA>

BuildSecurityDescriptorW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BuildTrusteeWithNameA PROTO :DWORD,:DWORD
BuildTrusteeWithName equ <BuildTrusteeWithNameA>

BuildTrusteeWithNameW PROTO :DWORD,:DWORD
BuildTrusteeWithObjectsAndNameA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BuildTrusteeWithObjectsAndName equ <BuildTrusteeWithObjectsAndNameA>

BuildTrusteeWithObjectsAndNameW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BuildTrusteeWithObjectsAndSidA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BuildTrusteeWithObjectsAndSid equ <BuildTrusteeWithObjectsAndSidA>

BuildTrusteeWithObjectsAndSidW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BuildTrusteeWithSidA PROTO :DWORD,:DWORD
BuildTrusteeWithSid equ <BuildTrusteeWithSidA>

BuildTrusteeWithSidW PROTO :DWORD,:DWORD
CancelOverlappedAccess PROTO :DWORD
ChangeServiceConfig2A PROTO :DWORD,:DWORD,:DWORD
ChangeServiceConfig2 equ <ChangeServiceConfig2A>

ChangeServiceConfig2W PROTO :DWORD,:DWORD,:DWORD
ChangeServiceConfigA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ChangeServiceConfig equ <ChangeServiceConfigA>

ChangeServiceConfigW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CheckTokenMembership PROTO :DWORD,:DWORD,:DWORD
ClearEventLogA PROTO :DWORD,:DWORD
ClearEventLog equ <ClearEventLogA>

ClearEventLogW PROTO :DWORD,:DWORD
CloseCodeAuthzLevel PROTO :DWORD
CloseEncryptedFileRaw PROTO :DWORD
CloseEventLog PROTO :DWORD
CloseServiceHandle PROTO :DWORD
CloseTrace PROTO :DWORD,:DWORD
CommandLineFromMsiDescriptor PROTO :DWORD,:DWORD,:DWORD
ComputeAccessTokenFromCodeAuthzLevel PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ControlService PROTO :DWORD,:DWORD,:DWORD
ControlTraceA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ControlTrace equ <ControlTraceA>

ControlTraceW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertAccessToSecurityDescriptorA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertAccessToSecurityDescriptor equ <ConvertAccessToSecurityDescriptorA>

ConvertAccessToSecurityDescriptorW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertSDToStringSDRootDomainA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertSDToStringSDRootDomain equ <ConvertSDToStringSDRootDomainA>

ConvertSDToStringSDRootDomainW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertSecurityDescriptorToAccessA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertSecurityDescriptorToAccess equ <ConvertSecurityDescriptorToAccessA>

ConvertSecurityDescriptorToAccessNamedA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertSecurityDescriptorToAccessNamed equ <ConvertSecurityDescriptorToAccessNamedA>

ConvertSecurityDescriptorToAccessNamedW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertSecurityDescriptorToAccessW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertSecurityDescriptorToStringSecurityDescriptorA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertSecurityDescriptorToStringSecurityDescriptor equ <ConvertSecurityDescriptorToStringSecurityDescriptorA>

ConvertSecurityDescriptorToStringSecurityDescriptorW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertSidToStringSidA PROTO :DWORD,:DWORD
ConvertSidToStringSid equ <ConvertSidToStringSidA>

ConvertSidToStringSidW PROTO :DWORD,:DWORD
ConvertStringSDToSDDomainA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertStringSDToSDDomain equ <ConvertStringSDToSDDomainA>

ConvertStringSDToSDDomainW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertStringSDToSDRootDomainA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertStringSDToSDRootDomain equ <ConvertStringSDToSDRootDomainA>

ConvertStringSDToSDRootDomainW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConvertStringSecurityDescriptorToSecurityDescriptorA PROTO :DWORD,:DWORD,:DWORD,:DWORD
ConvertStringSecurityDescriptorToSecurityDescriptor equ <ConvertStringSecurityDescriptorToSecurityDescriptorA>

ConvertStringSecurityDescriptorToSecurityDescriptorW PROTO :DWORD,:DWORD,:DWORD,:DWORD
ConvertStringSidToSidA PROTO :DWORD,:DWORD
ConvertStringSidToSid equ <ConvertStringSidToSidA>

ConvertStringSidToSidW PROTO :DWORD,:DWORD
ConvertToAutoInheritPrivateObjectSecurity PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CopySid PROTO :DWORD,:DWORD,:DWORD
CreateCodeAuthzLevel PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreatePrivateObjectSecurity PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreatePrivateObjectSecurityEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreatePrivateObjectSecurityWithMultipleInheritance PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateProcessAsUserA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateProcessAsUser equ <CreateProcessAsUserA>

CreateProcessAsUserSecure PROTO 
CreateProcessAsUserW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateProcessWithLogonW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateRestrictedToken PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateServiceA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateService equ <CreateServiceA>

CreateServiceW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateTraceInstanceId PROTO :DWORD,:DWORD
CreateWellKnownSid PROTO :DWORD,:DWORD,:DWORD,:DWORD
CredDeleteA PROTO :DWORD,:DWORD,:DWORD
CredDelete equ <CredDeleteA>

CredDeleteW PROTO :DWORD,:DWORD,:DWORD
CredEnumerateA PROTO :DWORD,:DWORD,:DWORD,:DWORD
CredEnumerate equ <CredEnumerateA>

CredEnumerateW PROTO :DWORD,:DWORD,:DWORD,:DWORD
CredFree PROTO :DWORD
CredGetSessionTypes PROTO :DWORD,:DWORD
CredGetTargetInfoA PROTO :DWORD,:DWORD,:DWORD
CredGetTargetInfo equ <CredGetTargetInfoA>

CredGetTargetInfoW PROTO :DWORD,:DWORD,:DWORD
CredIsMarshaledCredentialA PROTO :DWORD
CredIsMarshaledCredential equ <CredIsMarshaledCredentialA>

CredIsMarshaledCredentialW PROTO :DWORD
CredMarshalCredentialA PROTO :DWORD,:DWORD,:DWORD
CredMarshalCredential equ <CredMarshalCredentialA>

CredMarshalCredentialW PROTO :DWORD,:DWORD,:DWORD
CredReadA PROTO :DWORD,:DWORD,:DWORD,:DWORD
CredRead equ <CredReadA>

CredReadDomainCredentialsA PROTO :DWORD,:DWORD,:DWORD,:DWORD
CredReadDomainCredentials equ <CredReadDomainCredentialsA>

CredReadDomainCredentialsW PROTO :DWORD,:DWORD,:DWORD,:DWORD
CredReadW PROTO :DWORD,:DWORD,:DWORD,:DWORD
CredRenameA PROTO :DWORD,:DWORD,:DWORD,:DWORD
CredRename equ <CredRenameA>

CredRenameW PROTO :DWORD,:DWORD,:DWORD,:DWORD
CredUnmarshalCredentialA PROTO :DWORD,:DWORD,:DWORD
CredUnmarshalCredential equ <CredUnmarshalCredentialA>

CredUnmarshalCredentialW PROTO :DWORD,:DWORD,:DWORD
CredWriteA PROTO :DWORD,:DWORD
CredWrite equ <CredWriteA>

CredWriteDomainCredentialsA PROTO :DWORD,:DWORD,:DWORD
CredWriteDomainCredentials equ <CredWriteDomainCredentialsA>

CredWriteDomainCredentialsW PROTO :DWORD,:DWORD,:DWORD
CredWriteW PROTO :DWORD,:DWORD
CryptAcquireContextA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptAcquireContext equ <CryptAcquireContextA>

CryptAcquireContextW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptContextAddRef PROTO :DWORD,:DWORD,:DWORD
CryptCreateHash PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptDecrypt PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptDeriveKey PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptDestroyHash PROTO :DWORD
CryptDestroyKey PROTO :DWORD
CryptDuplicateHash PROTO :DWORD,:DWORD,:DWORD,:DWORD
CryptDuplicateKey PROTO :DWORD,:DWORD,:DWORD,:DWORD
CryptEncrypt PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptEnumProviderTypesA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptEnumProviderTypes equ <CryptEnumProviderTypesA>

CryptEnumProviderTypesW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptEnumProvidersA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptEnumProviders equ <CryptEnumProvidersA>

CryptEnumProvidersW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptExportKey PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptGenKey PROTO :DWORD,:DWORD,:DWORD,:DWORD
CryptGenRandom PROTO :DWORD,:DWORD,:DWORD
CryptGetDefaultProviderA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptGetDefaultProvider equ <CryptGetDefaultProviderA>

CryptGetDefaultProviderW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptGetHashParam PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptGetKeyParam PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptGetProvParam PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptGetUserKey PROTO :DWORD,:DWORD,:DWORD
CryptHashData PROTO :DWORD,:DWORD,:DWORD,:DWORD
CryptHashSessionKey PROTO :DWORD,:DWORD,:DWORD
CryptImportKey PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptReleaseContext PROTO :DWORD,:DWORD
CryptSetHashParam PROTO :DWORD,:DWORD,:DWORD,:DWORD
CryptSetKeyParam PROTO :DWORD,:DWORD,:DWORD,:DWORD
CryptSetProvParam PROTO :DWORD,:DWORD,:DWORD,:DWORD
CryptSetProviderA PROTO :DWORD,:DWORD
CryptSetProvider equ <CryptSetProviderA>

CryptSetProviderExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
CryptSetProviderEx equ <CryptSetProviderExA>

CryptSetProviderExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
CryptSetProviderW PROTO :DWORD,:DWORD
CryptSignHashA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptSignHash equ <CryptSignHashA>

CryptSignHashW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptVerifySignatureA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CryptVerifySignature equ <CryptVerifySignatureA>

CryptVerifySignatureW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DecryptFileA PROTO :DWORD,:DWORD
DecryptFile equ <DecryptFileA>

DecryptFileW PROTO :DWORD,:DWORD
DeleteAce PROTO :DWORD,:DWORD
DeleteService PROTO :DWORD
DeregisterEventSource PROTO :DWORD
DestroyPrivateObjectSecurity PROTO :DWORD
DuplicateEncryptionInfoFile PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DuplicateToken PROTO :DWORD,:DWORD,:DWORD
DuplicateTokenEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ElfBackupEventLogFileA PROTO :DWORD,:DWORD
ElfBackupEventLogFile equ <ElfBackupEventLogFileA>

ElfBackupEventLogFileW PROTO :DWORD,:DWORD
ElfChangeNotify PROTO :DWORD,:DWORD
ElfClearEventLogFileA PROTO :DWORD,:DWORD
ElfClearEventLogFile equ <ElfClearEventLogFileA>

ElfClearEventLogFileW PROTO :DWORD,:DWORD
ElfCloseEventLog PROTO :DWORD
ElfDeregisterEventSource PROTO :DWORD
ElfFlushEventLog PROTO :DWORD
ElfNumberOfRecords PROTO :DWORD,:DWORD
ElfOldestRecord PROTO :DWORD,:DWORD
ElfOpenBackupEventLogA PROTO :DWORD,:DWORD,:DWORD
ElfOpenBackupEventLog equ <ElfOpenBackupEventLogA>

ElfOpenBackupEventLogW PROTO :DWORD,:DWORD,:DWORD
ElfOpenEventLogA PROTO :DWORD,:DWORD,:DWORD
ElfOpenEventLog equ <ElfOpenEventLogA>

ElfOpenEventLogW PROTO :DWORD,:DWORD,:DWORD
ElfReadEventLogA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ElfReadEventLog equ <ElfReadEventLogA>

ElfReadEventLogW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ElfRegisterEventSourceA PROTO :DWORD,:DWORD,:DWORD
ElfRegisterEventSource equ <ElfRegisterEventSourceA>

ElfRegisterEventSourceW PROTO :DWORD,:DWORD,:DWORD
ElfReportEventA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ElfReportEvent equ <ElfReportEventA>

ElfReportEventW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EnableTrace PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EncryptFileA PROTO :DWORD
EncryptFile equ <EncryptFileA>

EncryptFileW PROTO :DWORD
EncryptedFileKeyInfo PROTO :DWORD,:DWORD,:DWORD
EncryptionDisable PROTO :DWORD,:DWORD
EnumDependentServicesA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EnumDependentServices equ <EnumDependentServicesA>

EnumDependentServicesW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EnumServiceGroupW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EnumServicesStatusA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EnumServicesStatus equ <EnumServicesStatusA>

EnumServicesStatusExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EnumServicesStatusEx equ <EnumServicesStatusExA>

EnumServicesStatusExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EnumServicesStatusW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EnumerateTraceGuids PROTO :DWORD,:DWORD,:DWORD
EqualDomainSid PROTO :DWORD,:DWORD,:DWORD
EqualPrefixSid PROTO :DWORD,:DWORD
EqualSid PROTO :DWORD,:DWORD
FileEncryptionStatusA PROTO :DWORD,:DWORD
FileEncryptionStatus equ <FileEncryptionStatusA>

FileEncryptionStatusW PROTO :DWORD,:DWORD
FindFirstFreeAce PROTO :DWORD,:DWORD
FlushTraceA PROTO :DWORD,:DWORD,:DWORD,:DWORD
FlushTrace equ <FlushTraceA>

FlushTraceW PROTO :DWORD,:DWORD,:DWORD,:DWORD
FreeEncryptedFileKeyInfo PROTO :DWORD
FreeEncryptionCertificateHashList PROTO :DWORD
FreeInheritedFromArray PROTO :DWORD,:DWORD,:DWORD
FreeSid PROTO :DWORD
GetAccessPermissionsForObjectA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetAccessPermissionsForObject equ <GetAccessPermissionsForObjectA>

GetAccessPermissionsForObjectW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetAce PROTO :DWORD,:DWORD,:DWORD
GetAclInformation PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetAuditedPermissionsFromAclA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetAuditedPermissionsFromAcl equ <GetAuditedPermissionsFromAclA>

GetAuditedPermissionsFromAclW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetCurrentHwProfileA PROTO :DWORD
GetCurrentHwProfile equ <GetCurrentHwProfileA>

GetCurrentHwProfileW PROTO :DWORD
GetEffectiveRightsFromAclA PROTO :DWORD,:DWORD,:DWORD
GetEffectiveRightsFromAcl equ <GetEffectiveRightsFromAclA>

GetEffectiveRightsFromAclW PROTO :DWORD,:DWORD,:DWORD
GetEventLogInformation PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetExplicitEntriesFromAclA PROTO :DWORD,:DWORD,:DWORD
GetExplicitEntriesFromAcl equ <GetExplicitEntriesFromAclA>

GetExplicitEntriesFromAclW PROTO :DWORD,:DWORD,:DWORD
GetFileSecurityA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetFileSecurity equ <GetFileSecurityA>

GetFileSecurityW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetInformationCodeAuthzLevelW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetInformationCodeAuthzPolicyW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetInheritanceSourceA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetInheritanceSource equ <GetInheritanceSourceA>

GetInheritanceSourceW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetKernelObjectSecurity PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetLengthSid PROTO :DWORD
GetLocalManagedApplicationData PROTO :DWORD,:DWORD,:DWORD
GetLocalManagedApplications PROTO :DWORD,:DWORD,:DWORD
GetManagedApplicationCategories PROTO :DWORD,:DWORD
GetManagedApplications PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetMultipleTrusteeA PROTO :DWORD
GetMultipleTrustee equ <GetMultipleTrusteeA>

GetMultipleTrusteeOperationA PROTO :DWORD
GetMultipleTrusteeOperation equ <GetMultipleTrusteeOperationA>

GetMultipleTrusteeOperationW PROTO :DWORD
GetMultipleTrusteeW PROTO :DWORD
GetNamedSecurityInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetNamedSecurityInfo equ <GetNamedSecurityInfoA>

GetNamedSecurityInfoExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetNamedSecurityInfoEx equ <GetNamedSecurityInfoExA>

GetNamedSecurityInfoExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetNamedSecurityInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetNumberOfEventLogRecords PROTO :DWORD,:DWORD
GetOldestEventLogRecord PROTO :DWORD,:DWORD
GetOverlappedAccessResults PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetPrivateObjectSecurity PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetSecurityDescriptorControl PROTO :DWORD,:DWORD,:DWORD
GetSecurityDescriptorDacl PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetSecurityDescriptorGroup PROTO :DWORD,:DWORD,:DWORD
GetSecurityDescriptorLength PROTO :DWORD
GetSecurityDescriptorOwner PROTO :DWORD,:DWORD,:DWORD
GetSecurityDescriptorRMControl PROTO :DWORD,:DWORD
GetSecurityDescriptorSacl PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetSecurityInfo PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetSecurityInfoExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetSecurityInfoEx equ <GetSecurityInfoExA>

GetSecurityInfoExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetServiceDisplayNameA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetServiceDisplayName equ <GetServiceDisplayNameA>

GetServiceDisplayNameW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetServiceKeyNameA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetServiceKeyName equ <GetServiceKeyNameA>

GetServiceKeyNameW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetSidIdentifierAuthority PROTO :DWORD
GetSidLengthRequired PROTO :DWORD
GetSidSubAuthority PROTO :DWORD,:DWORD
GetSidSubAuthorityCount PROTO :DWORD
GetTokenInformation PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetTraceEnableFlags PROTO :DWORD,:DWORD
GetTraceEnableLevel PROTO :DWORD,:DWORD
GetTraceLoggerHandle PROTO :DWORD
GetTrusteeFormA PROTO :DWORD
GetTrusteeForm equ <GetTrusteeFormA>

GetTrusteeFormW PROTO :DWORD
GetTrusteeNameA PROTO :DWORD
GetTrusteeName equ <GetTrusteeNameA>

GetTrusteeNameW PROTO :DWORD
GetTrusteeTypeA PROTO :DWORD
GetTrusteeType equ <GetTrusteeTypeA>

GetTrusteeTypeW PROTO :DWORD
GetUserNameA PROTO :DWORD,:DWORD
GetUserName equ <GetUserNameA>

GetUserNameW PROTO :DWORD,:DWORD
GetWindowsAccountDomainSid PROTO :DWORD,:DWORD,:DWORD
I_ScSetServiceBitsA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
I_ScSetServiceBits equ <I_ScSetServiceBitsA>

I_ScSetServiceBitsW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
IdentifyCodeAuthzLevelW PROTO :DWORD,:DWORD,:DWORD,:DWORD
ImpersonateAnonymousToken PROTO :DWORD
ImpersonateLoggedOnUser PROTO :DWORD
ImpersonateNamedPipeClient PROTO :DWORD
ImpersonateSelf PROTO :DWORD
InitializeAcl PROTO :DWORD,:DWORD,:DWORD
InitializeSecurityDescriptor PROTO :DWORD,:DWORD
InitializeSid PROTO :DWORD,:DWORD,:DWORD
InitiateSystemShutdownA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InitiateSystemShutdown equ <InitiateSystemShutdownA>

InitiateSystemShutdownExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InitiateSystemShutdownEx equ <InitiateSystemShutdownExA>

InitiateSystemShutdownExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InitiateSystemShutdownW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InstallApplication PROTO :DWORD
IsTextUnicode PROTO :DWORD,:DWORD,:DWORD
IsTokenRestricted PROTO :DWORD
IsTokenUntrusted PROTO :DWORD
IsValidAcl PROTO :DWORD
IsValidSecurityDescriptor PROTO :DWORD
IsValidSid PROTO :DWORD
IsWellKnownSid PROTO :DWORD,:DWORD
LockServiceDatabase PROTO :DWORD
LogonUserA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LogonUser equ <LogonUserA>

LogonUserExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LogonUserEx equ <LogonUserExA>

LogonUserExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LogonUserW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LookupAccountNameA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LookupAccountName equ <LookupAccountNameA>

LookupAccountNameW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LookupAccountSidA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LookupAccountSid equ <LookupAccountSidA>

LookupAccountSidW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LookupPrivilegeDisplayNameA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LookupPrivilegeDisplayName equ <LookupPrivilegeDisplayNameA>

LookupPrivilegeDisplayNameW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LookupPrivilegeNameA PROTO :DWORD,:DWORD,:DWORD,:DWORD
LookupPrivilegeName equ <LookupPrivilegeNameA>

LookupPrivilegeNameW PROTO :DWORD,:DWORD,:DWORD,:DWORD
LookupPrivilegeValueA PROTO :DWORD,:DWORD,:DWORD
LookupPrivilegeValue equ <LookupPrivilegeValueA>

LookupPrivilegeValueW PROTO :DWORD,:DWORD,:DWORD
LookupSecurityDescriptorPartsA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LookupSecurityDescriptorParts equ <LookupSecurityDescriptorPartsA>

LookupSecurityDescriptorPartsW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaAddAccountRights PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaAddPrivilegesToAccount PROTO :DWORD,:DWORD
LsaClearAuditLog PROTO :DWORD
LsaClose PROTO :DWORD
LsaCreateAccount PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaCreateSecret PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaCreateTrustedDomain PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaCreateTrustedDomainEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaDelete PROTO :DWORD
LsaDeleteTrustedDomain PROTO :DWORD,:DWORD
LsaEnumerateAccountRights PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaEnumerateAccounts PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaEnumerateAccountsWithUserRight PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaEnumeratePrivileges PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaEnumeratePrivilegesOfAccount PROTO :DWORD,:DWORD
LsaEnumerateTrustedDomains PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaEnumerateTrustedDomainsEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaFreeMemory PROTO :DWORD
LsaGetQuotasForAccount PROTO :DWORD,:DWORD
LsaGetRemoteUserName PROTO :DWORD,:DWORD,:DWORD
LsaGetSystemAccessAccount PROTO :DWORD,:DWORD
LsaGetUserName PROTO :DWORD,:DWORD
LsaICLookupNames PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaICLookupNamesWithCreds PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaICLookupSids PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaICLookupSidsWithCreds PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaLookupNames2 PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaLookupNames PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaLookupPrivilegeDisplayName PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaLookupPrivilegeName PROTO :DWORD,:DWORD,:DWORD
LsaLookupPrivilegeValue PROTO :DWORD,:DWORD,:DWORD
LsaLookupSids PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaNtStatusToWinError PROTO :DWORD
LsaOpenAccount PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaOpenPolicy PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaOpenPolicySce PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaOpenSecret PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaOpenTrustedDomain PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaOpenTrustedDomainByName PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaQueryDomainInformationPolicy PROTO :DWORD,:DWORD,:DWORD
LsaQueryForestTrustInformation PROTO :DWORD,:DWORD,:DWORD
LsaQueryInfoTrustedDomain PROTO :DWORD,:DWORD,:DWORD
LsaQueryInformationPolicy PROTO :DWORD,:DWORD,:DWORD
LsaQuerySecret PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaQuerySecurityObject PROTO :DWORD,:DWORD,:DWORD
LsaQueryTrustedDomainInfo PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaQueryTrustedDomainInfoByName PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaRemoveAccountRights PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaRemovePrivilegesFromAccount PROTO :DWORD,:DWORD,:DWORD
LsaRetrievePrivateData PROTO :DWORD,:DWORD,:DWORD
LsaSetDomainInformationPolicy PROTO :DWORD,:DWORD,:DWORD
LsaSetForestTrustInformation PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LsaSetInformationPolicy PROTO :DWORD,:DWORD,:DWORD
LsaSetInformationTrustedDomain PROTO :DWORD,:DWORD,:DWORD
LsaSetQuotasForAccount PROTO :DWORD,:DWORD
LsaSetSecret PROTO :DWORD,:DWORD,:DWORD
LsaSetSecurityObject PROTO :DWORD,:DWORD,:DWORD
LsaSetSystemAccessAccount PROTO :DWORD,:DWORD
LsaSetTrustedDomainInfoByName PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaSetTrustedDomainInformation PROTO :DWORD,:DWORD,:DWORD,:DWORD
LsaStorePrivateData PROTO :DWORD,:DWORD,:DWORD
MSChapSrvChangePassword2 PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MSChapSrvChangePassword PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MakeAbsoluteSD2 PROTO :DWORD,:DWORD
MakeAbsoluteSD PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MakeSelfRelativeSD PROTO :DWORD,:DWORD,:DWORD
MapGenericMask PROTO :DWORD,:DWORD
NotifyBootConfigStatus PROTO :DWORD
NotifyChangeEventLog PROTO :DWORD,:DWORD
ObjectCloseAuditAlarmA PROTO :DWORD,:DWORD,:DWORD
ObjectCloseAuditAlarm equ <ObjectCloseAuditAlarmA>

ObjectCloseAuditAlarmW PROTO :DWORD,:DWORD,:DWORD
ObjectDeleteAuditAlarmA PROTO :DWORD,:DWORD,:DWORD
ObjectDeleteAuditAlarm equ <ObjectDeleteAuditAlarmA>

ObjectDeleteAuditAlarmW PROTO :DWORD,:DWORD,:DWORD
ObjectOpenAuditAlarmA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ObjectOpenAuditAlarm equ <ObjectOpenAuditAlarmA>

ObjectOpenAuditAlarmW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ObjectPrivilegeAuditAlarmA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ObjectPrivilegeAuditAlarm equ <ObjectPrivilegeAuditAlarmA>

ObjectPrivilegeAuditAlarmW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
OpenBackupEventLogA PROTO :DWORD,:DWORD
OpenBackupEventLog equ <OpenBackupEventLogA>

OpenBackupEventLogW PROTO :DWORD,:DWORD
OpenEncryptedFileRawA PROTO :DWORD,:DWORD,:DWORD
OpenEncryptedFileRaw equ <OpenEncryptedFileRawA>

OpenEncryptedFileRawW PROTO :DWORD,:DWORD,:DWORD
OpenEventLogA PROTO :DWORD,:DWORD
OpenEventLog equ <OpenEventLogA>

OpenEventLogW PROTO :DWORD,:DWORD
OpenProcessToken PROTO :DWORD,:DWORD,:DWORD
OpenSCManagerA PROTO :DWORD,:DWORD,:DWORD
OpenSCManager equ <OpenSCManagerA>

OpenSCManagerW PROTO :DWORD,:DWORD,:DWORD
OpenServiceA PROTO :DWORD,:DWORD,:DWORD
OpenService equ <OpenServiceA>

OpenServiceW PROTO :DWORD,:DWORD,:DWORD
OpenThreadToken PROTO :DWORD,:DWORD,:DWORD,:DWORD
OpenTraceA PROTO :DWORD
OpenTrace equ <OpenTraceA>

OpenTraceW PROTO :DWORD
PrivilegeCheck PROTO :DWORD,:DWORD,:DWORD
PrivilegedServiceAuditAlarmA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
PrivilegedServiceAuditAlarm equ <PrivilegedServiceAuditAlarmA>

PrivilegedServiceAuditAlarmW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ProcessTrace PROTO :DWORD,:DWORD,:DWORD,:DWORD
QueryAllTracesA PROTO :DWORD,:DWORD,:DWORD
QueryAllTraces equ <QueryAllTracesA>

QueryAllTracesW PROTO :DWORD,:DWORD,:DWORD
QueryRecoveryAgentsOnEncryptedFile PROTO :DWORD,:DWORD
QueryServiceConfig2A PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
QueryServiceConfig2 equ <QueryServiceConfig2A>

QueryServiceConfig2W PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
QueryServiceConfigA PROTO :DWORD,:DWORD,:DWORD,:DWORD
QueryServiceConfig equ <QueryServiceConfigA>

QueryServiceConfigW PROTO :DWORD,:DWORD,:DWORD,:DWORD
QueryServiceLockStatusA PROTO :DWORD,:DWORD,:DWORD,:DWORD
QueryServiceLockStatus equ <QueryServiceLockStatusA>

QueryServiceLockStatusW PROTO :DWORD,:DWORD,:DWORD,:DWORD
QueryServiceObjectSecurity PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
QueryServiceStatus PROTO :DWORD,:DWORD
QueryServiceStatusEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
QueryTraceA PROTO :DWORD,:DWORD,:DWORD,:DWORD
QueryTrace equ <QueryTraceA>

QueryTraceW PROTO :DWORD,:DWORD,:DWORD,:DWORD
QueryUsersOnEncryptedFile PROTO :DWORD,:DWORD
QueryWindows31FilesMigration PROTO :DWORD
ReadEncryptedFileRaw PROTO :DWORD,:DWORD,:DWORD
ReadEventLogA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadEventLog equ <ReadEventLogA>

ReadEventLogW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegCloseKey PROTO :DWORD
RegConnectRegistryA PROTO :DWORD,:DWORD,:DWORD
RegConnectRegistry equ <RegConnectRegistryA>

RegConnectRegistryW PROTO :DWORD,:DWORD,:DWORD
RegCreateKeyA PROTO :DWORD,:DWORD,:DWORD
RegCreateKey equ <RegCreateKeyA>

RegCreateKeyExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegCreateKeyEx equ <RegCreateKeyExA>

RegCreateKeyExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegCreateKeyW PROTO :DWORD,:DWORD,:DWORD
RegDeleteKeyA PROTO :DWORD,:DWORD
RegDeleteKey equ <RegDeleteKeyA>

RegDeleteKeyW PROTO :DWORD,:DWORD
RegDeleteValueA PROTO :DWORD,:DWORD
RegDeleteValue equ <RegDeleteValueA>

RegDeleteValueW PROTO :DWORD,:DWORD
RegDisablePredefinedCache PROTO 
RegEnumKeyA PROTO :DWORD,:DWORD,:DWORD,:DWORD
RegEnumKey equ <RegEnumKeyA>

RegEnumKeyExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegEnumKeyEx equ <RegEnumKeyExA>

RegEnumKeyExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegEnumKeyW PROTO :DWORD,:DWORD,:DWORD,:DWORD
RegEnumValueA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegEnumValue equ <RegEnumValueA>

RegEnumValueW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegFlushKey PROTO :DWORD
RegGetKeySecurity PROTO :DWORD,:DWORD,:DWORD,:DWORD
RegLoadKeyA PROTO :DWORD,:DWORD,:DWORD
RegLoadKey equ <RegLoadKeyA>

RegLoadKeyW PROTO :DWORD,:DWORD,:DWORD
RegNotifyChangeKeyValue PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegOpenCurrentUser PROTO :DWORD,:DWORD
RegOpenKeyA PROTO :DWORD,:DWORD,:DWORD
RegOpenKey equ <RegOpenKeyA>

RegOpenKeyExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegOpenKeyEx equ <RegOpenKeyExA>

RegOpenKeyExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegOpenKeyW PROTO :DWORD,:DWORD,:DWORD
RegOpenUserClassesRoot PROTO :DWORD,:DWORD,:DWORD,:DWORD
RegOverridePredefKey PROTO :DWORD,:DWORD
RegQueryInfoKeyA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegQueryInfoKey equ <RegQueryInfoKeyA>

RegQueryInfoKeyW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegQueryMultipleValuesA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegQueryMultipleValues equ <RegQueryMultipleValuesA>

RegQueryMultipleValuesW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegQueryValueA PROTO :DWORD,:DWORD,:DWORD,:DWORD
RegQueryValue equ <RegQueryValueA>

RegQueryValueExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegQueryValueEx equ <RegQueryValueExA>

RegQueryValueExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegQueryValueW PROTO :DWORD,:DWORD,:DWORD,:DWORD
RegReplaceKeyA PROTO :DWORD,:DWORD,:DWORD,:DWORD
RegReplaceKey equ <RegReplaceKeyA>

RegReplaceKeyW PROTO :DWORD,:DWORD,:DWORD,:DWORD
RegRestoreKeyA PROTO :DWORD,:DWORD,:DWORD
RegRestoreKey equ <RegRestoreKeyA>

RegRestoreKeyW PROTO :DWORD,:DWORD,:DWORD
RegSaveKeyA PROTO :DWORD,:DWORD,:DWORD
RegSaveKey equ <RegSaveKeyA>

RegSaveKeyExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
RegSaveKeyEx equ <RegSaveKeyExA>

RegSaveKeyExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
RegSaveKeyW PROTO :DWORD,:DWORD,:DWORD
RegSetKeySecurity PROTO :DWORD,:DWORD,:DWORD
RegSetValueA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegSetValue equ <RegSetValueA>

RegSetValueExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegSetValueEx equ <RegSetValueExA>

RegSetValueExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegSetValueW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegUnLoadKeyA PROTO :DWORD,:DWORD
RegUnLoadKey equ <RegUnLoadKeyA>

RegUnLoadKeyW PROTO :DWORD,:DWORD
RegisterEventSourceA PROTO :DWORD,:DWORD
RegisterEventSource equ <RegisterEventSourceA>

RegisterEventSourceW PROTO :DWORD,:DWORD
RegisterServiceCtrlHandlerA PROTO :DWORD,:DWORD
RegisterServiceCtrlHandler equ <RegisterServiceCtrlHandlerA>

RegisterServiceCtrlHandlerExA PROTO :DWORD,:DWORD,:DWORD
RegisterServiceCtrlHandlerEx equ <RegisterServiceCtrlHandlerExA>

RegisterServiceCtrlHandlerExW PROTO :DWORD,:DWORD,:DWORD
RegisterServiceCtrlHandlerW PROTO :DWORD,:DWORD
RegisterTraceGuidsA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegisterTraceGuids equ <RegisterTraceGuidsA>

RegisterTraceGuidsW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RemoveTraceCallback PROTO :DWORD
RemoveUsersFromEncryptedFile PROTO :DWORD,:DWORD
ReportEventA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReportEvent equ <ReportEventA>

ReportEventW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RevertToSelf PROTO 
SaferCloseLevel PROTO :DWORD
SaferComputeTokenFromLevel PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SaferCreateLevel PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SaferGetLevelInformation PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SaferGetPolicyInformation PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SaferIdentifyLevel PROTO :DWORD,:DWORD,:DWORD,:DWORD
SaferRecordEventLogEntry PROTO :DWORD,:DWORD,:DWORD
SaferSetLevelInformation PROTO :DWORD,:DWORD,:DWORD,:DWORD
SaferSetPolicyInformation PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetAclInformation PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetEntriesInAccessListA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetEntriesInAccessList equ <SetEntriesInAccessListA>

SetEntriesInAccessListW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetEntriesInAclA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetEntriesInAcl equ <SetEntriesInAclA>

SetEntriesInAclW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetEntriesInAuditListA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetEntriesInAuditList equ <SetEntriesInAuditListA>

SetEntriesInAuditListW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetFileSecurityA PROTO :DWORD,:DWORD,:DWORD
SetFileSecurity equ <SetFileSecurityA>

SetFileSecurityW PROTO :DWORD,:DWORD,:DWORD
SetInformationCodeAuthzLevelW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetInformationCodeAuthzPolicyW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetKernelObjectSecurity PROTO :DWORD,:DWORD,:DWORD
SetNamedSecurityInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetNamedSecurityInfo equ <SetNamedSecurityInfoA>

SetNamedSecurityInfoExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetNamedSecurityInfoEx equ <SetNamedSecurityInfoExA>

SetNamedSecurityInfoExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetNamedSecurityInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetPrivateObjectSecurity PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetPrivateObjectSecurityEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetSecurityDescriptorControl PROTO :DWORD,:DWORD,:DWORD
SetSecurityDescriptorDacl PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetSecurityDescriptorGroup PROTO :DWORD,:DWORD,:DWORD
SetSecurityDescriptorOwner PROTO :DWORD,:DWORD,:DWORD
SetSecurityDescriptorRMControl PROTO :DWORD,:DWORD
SetSecurityDescriptorSacl PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetSecurityInfo PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetSecurityInfoExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetSecurityInfoEx equ <SetSecurityInfoExA>

SetSecurityInfoExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetServiceBits PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetServiceObjectSecurity PROTO :DWORD,:DWORD,:DWORD
SetServiceStatus PROTO :DWORD,:DWORD
SetThreadToken PROTO :DWORD,:DWORD
SetTokenInformation PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetTraceCallback PROTO :DWORD,:DWORD
SetUserFileEncryptionKey PROTO :DWORD
StartServiceA PROTO :DWORD,:DWORD,:DWORD
StartService equ <StartServiceA>

StartServiceCtrlDispatcherA PROTO :DWORD
StartServiceCtrlDispatcher equ <StartServiceCtrlDispatcherA>

StartServiceCtrlDispatcherW PROTO :DWORD
StartServiceW PROTO :DWORD,:DWORD,:DWORD
StartTraceA PROTO :DWORD,:DWORD,:DWORD
StartTrace equ <StartTraceA>

StartTraceW PROTO :DWORD,:DWORD,:DWORD
StopTraceA PROTO :DWORD,:DWORD,:DWORD,:DWORD
StopTrace equ <StopTraceA>

StopTraceW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SynchronizeWindows31FilesAndWindowsNTRegistry PROTO :DWORD,:DWORD,:DWORD,:DWORD
SystemFunction001 PROTO :DWORD,:DWORD,:DWORD
SystemFunction002 PROTO :DWORD,:DWORD,:DWORD
SystemFunction003 PROTO :DWORD,:DWORD
SystemFunction004 PROTO :DWORD,:DWORD,:DWORD
SystemFunction005 PROTO :DWORD,:DWORD,:DWORD
SystemFunction006 PROTO :DWORD,:DWORD
SystemFunction007 PROTO :DWORD,:DWORD
SystemFunction008 PROTO :DWORD,:DWORD,:DWORD
SystemFunction009 PROTO :DWORD,:DWORD,:DWORD
SystemFunction010 PROTO :DWORD,:DWORD,:DWORD
SystemFunction011 PROTO :DWORD,:DWORD,:DWORD
SystemFunction012 PROTO :DWORD,:DWORD,:DWORD
SystemFunction013 PROTO :DWORD,:DWORD,:DWORD
SystemFunction014 PROTO :DWORD,:DWORD,:DWORD
SystemFunction015 PROTO :DWORD,:DWORD,:DWORD
SystemFunction016 PROTO :DWORD,:DWORD,:DWORD
SystemFunction017 PROTO :DWORD,:DWORD,:DWORD
SystemFunction018 PROTO :DWORD,:DWORD,:DWORD
SystemFunction019 PROTO :DWORD,:DWORD,:DWORD
SystemFunction020 PROTO :DWORD,:DWORD,:DWORD
SystemFunction021 PROTO :DWORD,:DWORD,:DWORD
SystemFunction022 PROTO :DWORD,:DWORD,:DWORD
SystemFunction023 PROTO :DWORD,:DWORD,:DWORD
SystemFunction024 PROTO :DWORD,:DWORD,:DWORD
SystemFunction025 PROTO :DWORD,:DWORD,:DWORD
SystemFunction026 PROTO :DWORD,:DWORD,:DWORD
SystemFunction027 PROTO :DWORD,:DWORD,:DWORD
SystemFunction028 PROTO :DWORD,:DWORD
SystemFunction029 PROTO :DWORD,:DWORD
SystemFunction030 PROTO :DWORD,:DWORD
SystemFunction031 PROTO :DWORD,:DWORD
SystemFunction032 PROTO :DWORD,:DWORD
SystemFunction033 PROTO :DWORD,:DWORD
SystemFunction034 PROTO :DWORD,:DWORD,:DWORD
SystemFunction036 PROTO :DWORD,:DWORD
SystemFunction040 PROTO :DWORD,:DWORD,:DWORD
SystemFunction041 PROTO :DWORD,:DWORD,:DWORD
TraceEvent PROTO :DWORD,:DWORD,:DWORD
TraceEventInstance PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
TraceMessageVa PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
TreeResetNamedSecurityInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
TreeResetNamedSecurityInfo equ <TreeResetNamedSecurityInfoA>

TreeResetNamedSecurityInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
TrusteeAccessToObjectA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
TrusteeAccessToObject equ <TrusteeAccessToObjectA>

TrusteeAccessToObjectW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UninstallApplication PROTO :DWORD,:DWORD
UnlockServiceDatabase PROTO :DWORD
UnregisterTraceGuids PROTO :DWORD,:DWORD
UpdateTraceA PROTO :DWORD,:DWORD,:DWORD,:DWORD
UpdateTrace equ <UpdateTraceA>

UpdateTraceW PROTO :DWORD,:DWORD,:DWORD,:DWORD
Wow64Win32ApiEntry PROTO :DWORD,:DWORD,:DWORD
WriteEncryptedFileRaw PROTO :DWORD,:DWORD,:DWORD

ELSE
echo -----------------------------------------
echo WARNING Duplicate include file advapi32.inc
echo -----------------------------------------
ENDIF
