  ; ===========================================
  ; userenv.inc copyright MASM32 1998 - 2005
  ; ===========================================

IFNDEF USERENV_INC
USERENV_INC equ <1>

AddDesktopItemA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AddDesktopItem equ <AddDesktopItemA>

AddDesktopItemW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AddItemA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
AddItem equ <AddItemA>

AddItemW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ApplyGroupPolicy PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ApplySystemPolicyA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ApplySystemPolicy equ <ApplySystemPolicyA>

ApplySystemPolicyW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CheckAccessForPolicyGeneration PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CheckXForestLogon PROTO :DWORD
CopyProfileDirectoryA PROTO :DWORD,:DWORD,:DWORD
CopyProfileDirectory equ <CopyProfileDirectoryA>

CopyProfileDirectoryExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CopyProfileDirectoryEx equ <CopyProfileDirectoryExA>

CopyProfileDirectoryExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CopyProfileDirectoryW PROTO :DWORD,:DWORD,:DWORD
CopySystemProfile PROTO :DWORD
CreateEnvironmentBlock PROTO :DWORD,:DWORD,:DWORD
CreateGroupA PROTO :DWORD,:DWORD
CreateGroup equ <CreateGroupA>

CreateGroupExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateGroupEx equ <CreateGroupExA>

CreateGroupExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateGroupW PROTO :DWORD,:DWORD
CreateLinkFileA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateLinkFile equ <CreateLinkFileA>

CreateLinkFileExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateLinkFileEx equ <CreateLinkFileExA>

CreateLinkFileExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateLinkFileW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateURLFile PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateUserProfileA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateUserProfile equ <CreateUserProfileA>

CreateUserProfileExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateUserProfileEx equ <CreateUserProfileExA>

CreateUserProfileExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateUserProfileW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DeleteDesktopItemA PROTO :DWORD,:DWORD
DeleteDesktopItem equ <DeleteDesktopItemA>

DeleteDesktopItemW PROTO :DWORD,:DWORD
DeleteGroupA PROTO :DWORD,:DWORD
DeleteGroup equ <DeleteGroupA>

DeleteGroupW PROTO :DWORD,:DWORD
DeleteItemA PROTO :DWORD,:DWORD,:DWORD,:DWORD
DeleteItem equ <DeleteItemA>

DeleteItemW PROTO :DWORD,:DWORD,:DWORD,:DWORD
DeleteLinkFileA PROTO :DWORD,:DWORD,:DWORD,:DWORD
DeleteLinkFile equ <DeleteLinkFileA>

DeleteLinkFileW PROTO :DWORD,:DWORD,:DWORD,:DWORD
DeleteProfileA PROTO :DWORD,:DWORD,:DWORD
DeleteProfile equ <DeleteProfileA>

DeleteProfileW PROTO :DWORD,:DWORD,:DWORD
DeleteURLFile PROTO :DWORD,:DWORD,:DWORD,:DWORD
DestroyEnvironmentBlock PROTO :DWORD
DetermineProfilesLocation PROTO :DWORD
EnterCriticalPolicySection PROTO :DWORD
EnterUserProfileLock PROTO :DWORD
ExpandEnvironmentStringsForUserA PROTO :DWORD,:DWORD,:DWORD,:DWORD
ExpandEnvironmentStringsForUser equ <ExpandEnvironmentStringsForUserA>

ExpandEnvironmentStringsForUserW PROTO :DWORD,:DWORD,:DWORD,:DWORD
ForceSyncFgPolicy PROTO :DWORD
FreeGPOListA PROTO :DWORD
FreeGPOList equ <FreeGPOListA>

FreeGPOListW PROTO :DWORD
GenerateRsopPolicy PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetAllUsersProfileDirectoryA PROTO :DWORD,:DWORD
GetAllUsersProfileDirectory equ <GetAllUsersProfileDirectoryA>

GetAllUsersProfileDirectoryW PROTO :DWORD,:DWORD
GetAppliedGPOListA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetAppliedGPOList equ <GetAppliedGPOListA>

GetAppliedGPOListW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetDefaultUserProfileDirectoryA PROTO :DWORD,:DWORD
GetDefaultUserProfileDirectory equ <GetDefaultUserProfileDirectoryA>

GetDefaultUserProfileDirectoryW PROTO :DWORD,:DWORD
GetGPOListA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetGPOList equ <GetGPOListA>

GetGPOListW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetGroupPolicyNetworkName PROTO :DWORD,:DWORD
GetNextFgPolicyRefreshInfo PROTO :DWORD,:DWORD
GetPreviousFgPolicyRefreshInfo PROTO :DWORD,:DWORD
GetProfileType PROTO :DWORD
GetProfilesDirectoryA PROTO :DWORD,:DWORD
GetProfilesDirectory equ <GetProfilesDirectoryA>

GetProfilesDirectoryW PROTO :DWORD,:DWORD
GetSystemTempDirectoryA PROTO :DWORD,:DWORD
GetSystemTempDirectory equ <GetSystemTempDirectoryA>

GetSystemTempDirectoryW PROTO :DWORD,:DWORD
GetUserAppDataPathA PROTO :DWORD,:DWORD
GetUserAppDataPath equ <GetUserAppDataPathA>

GetUserAppDataPathW PROTO :DWORD,:DWORD
GetUserProfileDirFromSidA PROTO :DWORD,:DWORD,:DWORD
GetUserProfileDirFromSid equ <GetUserProfileDirFromSidA>

GetUserProfileDirFromSidW PROTO :DWORD,:DWORD,:DWORD
GetUserProfileDirectoryA PROTO :DWORD,:DWORD,:DWORD
GetUserProfileDirectory equ <GetUserProfileDirectoryA>

GetUserProfileDirectoryW PROTO :DWORD,:DWORD,:DWORD
GetUserSid PROTO :DWORD
InitializeProfiles PROTO :DWORD
InitializeUserProfile PROTO 
IsSyncForegroundPolicyRefresh PROTO :DWORD,:DWORD
LeaveCriticalPolicySection PROTO :DWORD
LeaveUserProfileLock PROTO :DWORD
LoadUserProfileA PROTO :DWORD,:DWORD
LoadUserProfile equ <LoadUserProfileA>

LoadUserProfileW PROTO :DWORD,:DWORD
MigrateNT4ToNT5 PROTO 
PingComputer PROTO :DWORD,:DWORD
ProcessGroupPolicyCompleted PROTO :DWORD,:DWORD,:DWORD
ProcessGroupPolicyCompletedEx PROTO :DWORD,:DWORD,:DWORD,:DWORD
RefreshPolicy PROTO :DWORD
RefreshPolicyEx PROTO :DWORD,:DWORD
RegisterGPNotification PROTO :DWORD,:DWORD
ResetUserSpecialFolderPaths PROTO 
RsopAccessCheckByType PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RsopFileAccessCheck PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RsopLoggingEnabled PROTO 
RsopResetPolicySettingStatus PROTO :DWORD,:DWORD,:DWORD
RsopSetPolicySettingStatus PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SecureUserProfiles PROTO 
SetNextFgPolicyRefreshInfo PROTO :DWORD,:DWORD,:DWORD
ShutdownGPOProcessing PROTO :DWORD
SignalMachinePolicyForegroundProcessingDone PROTO 
SignalUserPolicyForegroundProcessingDone PROTO 
UnloadUserProfile PROTO :DWORD,:DWORD
UnregisterGPNotification PROTO :DWORD
WaitForMachinePolicyForegroundProcessing PROTO 
WaitForUserPolicyForegroundProcessing PROTO 

ELSE
echo -----------------------------------------
echo WARNING Duplicate include file userenv.inc
echo -----------------------------------------
ENDIF
