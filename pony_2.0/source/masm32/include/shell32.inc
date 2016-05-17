  ; ===========================================
  ; shell32.inc copyright MASM32 1998 - 2005
  ; ===========================================

IFNDEF SHELL32_INC
SHELL32_INC equ <1>

CDefFolderMenu_Create2 PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CDefFolderMenu_Create PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CallCPLEntry16 PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CheckEscapesA PROTO :DWORD,:DWORD
CheckEscapes equ <CheckEscapesA>

CheckEscapesW PROTO :DWORD,:DWORD
CommandLineToArgvW PROTO :DWORD,:DWORD
DAD_AutoScroll PROTO :DWORD,:DWORD,:DWORD
DAD_DragEnterEx2 PROTO :DWORD,:DWORD,:DWORD,:DWORD
DAD_DragEnterEx PROTO :DWORD,:DWORD,:DWORD
DAD_DragLeave PROTO 
DAD_DragMove PROTO :DWORD,:DWORD
DAD_SetDragImage PROTO :DWORD,:DWORD
DAD_ShowDragImage PROTO :DWORD
DoEnvironmentSubstA PROTO :DWORD,:DWORD
DoEnvironmentSubst equ <DoEnvironmentSubstA>

DoEnvironmentSubstW PROTO :DWORD,:DWORD
DragAcceptFiles PROTO :DWORD,:DWORD
DragFinish PROTO :DWORD
DragQueryFileA PROTO :DWORD,:DWORD,:DWORD,:DWORD
DragQueryFile equ <DragQueryFileA>

DragQueryFileAorW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DragQueryFileW PROTO :DWORD,:DWORD,:DWORD,:DWORD
DragQueryPoint PROTO :DWORD,:DWORD
DriveType PROTO :DWORD
DuplicateIcon PROTO :DWORD,:DWORD
ExtractAssociatedIconA PROTO :DWORD,:DWORD,:DWORD
ExtractAssociatedIcon equ <ExtractAssociatedIconA>

ExtractAssociatedIconExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
ExtractAssociatedIconEx equ <ExtractAssociatedIconExA>

ExtractAssociatedIconExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
ExtractAssociatedIconW PROTO :DWORD,:DWORD,:DWORD
ExtractIconA PROTO :DWORD,:DWORD,:DWORD
ExtractIcon equ <ExtractIconA>

ExtractIconExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ExtractIconEx equ <ExtractIconExA>

ExtractIconExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ExtractIconResInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ExtractIconResInfo equ <ExtractIconResInfoA>

ExtractIconResInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ExtractIconW PROTO :DWORD,:DWORD,:DWORD
ExtractVersionResource16W PROTO :DWORD,:DWORD
FindExeDlgProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
FindExecutableA PROTO :DWORD,:DWORD,:DWORD
FindExecutable equ <FindExecutableA>

FindExecutableW PROTO :DWORD,:DWORD,:DWORD
FreeIconList PROTO :DWORD,:DWORD
GetFileNameFromBrowse PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ILAppendID PROTO :DWORD,:DWORD,:DWORD
ILClone PROTO :DWORD
ILCloneFirst PROTO :DWORD
ILCombine PROTO :DWORD,:DWORD
ILCreateFromPathA PROTO :DWORD
ILCreateFromPath equ <ILCreateFromPathA>

ILCreateFromPathW PROTO :DWORD
ILFindChild PROTO :DWORD,:DWORD
ILFindLastID PROTO :DWORD
ILFree PROTO :DWORD
ILGetNext PROTO :DWORD
ILGetSize PROTO :DWORD
ILIsEqual PROTO :DWORD,:DWORD
ILIsParent PROTO :DWORD,:DWORD,:DWORD
ILLoadFromStream PROTO :DWORD,:DWORD
ILRemoveLastID PROTO :DWORD
ILSaveToStream PROTO :DWORD,:DWORD
InternalExtractIconListA PROTO :DWORD,:DWORD,:DWORD
InternalExtractIconList equ <InternalExtractIconListA>

InternalExtractIconListW PROTO :DWORD,:DWORD,:DWORD
IsLFNDriveA PROTO :DWORD
IsLFNDrive equ <IsLFNDriveA>

IsLFNDriveW PROTO :DWORD
IsNetDrive PROTO :DWORD
IsUserAnAdmin PROTO 
OpenRegStream PROTO :DWORD,:DWORD,:DWORD,:DWORD
PathCleanupSpec PROTO :DWORD,:DWORD
PathGetShortPath PROTO :DWORD
PathIsExe PROTO :DWORD
PathIsSlowA PROTO :DWORD,:DWORD
PathIsSlow equ <PathIsSlowA>

PathIsSlowW PROTO :DWORD,:DWORD
PathMakeUniqueName PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
PathProcessCommand PROTO :DWORD,:DWORD,:DWORD,:DWORD
PathQualify PROTO :DWORD
PathResolve PROTO :DWORD,:DWORD,:DWORD
PathYetAnotherMakeUniqueName PROTO :DWORD,:DWORD,:DWORD,:DWORD
PickIconDlg PROTO :DWORD,:DWORD,:DWORD,:DWORD
PifMgr_CloseProperties PROTO :DWORD,:DWORD
PifMgr_GetProperties PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
PifMgr_OpenProperties PROTO :DWORD,:DWORD,:DWORD,:DWORD
PifMgr_SetProperties PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadCabinetState PROTO :DWORD,:DWORD
RealDriveType PROTO :DWORD,:DWORD
RealShellExecuteA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RealShellExecute equ <RealShellExecuteA>

RealShellExecuteExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RealShellExecuteEx equ <RealShellExecuteExA>

RealShellExecuteExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RealShellExecuteW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegenerateUserEnvironment PROTO :DWORD,:DWORD
RestartDialog PROTO :DWORD,:DWORD,:DWORD
RestartDialogEx PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHAddFromPropSheetExtArray PROTO :DWORD,:DWORD,:DWORD
SHAddToRecentDocs PROTO :DWORD,:DWORD
SHAlloc PROTO :DWORD
SHAppBarMessage PROTO :DWORD,:DWORD
SHBindToParent PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHBrowseForFolderA PROTO :DWORD
SHBrowseForFolder equ <SHBrowseForFolderA>

SHBrowseForFolderW PROTO :DWORD
SHCLSIDFromString PROTO :DWORD,:DWORD
SHChangeNotification_Lock PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHChangeNotification_Unlock PROTO :DWORD
SHChangeNotify PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHChangeNotifyDeregister PROTO :DWORD
SHChangeNotifyRegister PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHCloneSpecialIDList PROTO :DWORD,:DWORD,:DWORD
SHCoCreateInstance PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHCreateDirectory PROTO :DWORD,:DWORD
SHCreateDirectoryExA PROTO :DWORD,:DWORD,:DWORD
SHCreateDirectoryEx equ <SHCreateDirectoryExA>

SHCreateDirectoryExW PROTO :DWORD,:DWORD,:DWORD
SHCreateFileExtractIconW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHCreateProcessAsUserW PROTO :DWORD
SHCreatePropSheetExtArray PROTO :DWORD,:DWORD,:DWORD
SHCreateQueryCancelAutoPlayMoniker PROTO :DWORD
SHCreateShellFolderView PROTO :DWORD,:DWORD
SHCreateShellFolderViewEx PROTO :DWORD,:DWORD
SHCreateShellItem PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHCreateStdEnumFmtEtc PROTO :DWORD,:DWORD,:DWORD
SHDefExtractIconA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHDefExtractIcon equ <SHDefExtractIconA>

SHDefExtractIconW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHDestroyPropSheetExtArray PROTO :DWORD
SHDoDragDrop PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHEmptyRecycleBinA PROTO :DWORD,:DWORD,:DWORD
SHEmptyRecycleBin equ <SHEmptyRecycleBinA>

SHEmptyRecycleBinW PROTO :DWORD,:DWORD,:DWORD
SHEnumerateUnreadMailAccountsW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHExtractIconsW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHFileOperationA PROTO :DWORD
SHFileOperation equ <SHFileOperationA>

SHFileOperationW PROTO :DWORD
SHFindFiles PROTO :DWORD,:DWORD
SHFind_InitMenuPopup PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHFlushClipboard PROTO 
SHFlushSFCache PROTO 
SHFormatDrive PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHFree PROTO :DWORD
SHFreeNameMappings PROTO :DWORD
SHGetAttributesFromDataObject PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHGetDataFromIDListA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHGetDataFromIDList equ <SHGetDataFromIDListA>

SHGetDataFromIDListW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHGetDesktopFolder PROTO :DWORD
SHGetDiskFreeSpaceA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHGetDiskFreeSpace equ <SHGetDiskFreeSpaceA>

SHGetDiskFreeSpaceExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHGetDiskFreeSpaceEx equ <SHGetDiskFreeSpaceExA>

SHGetDiskFreeSpaceExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHGetFileInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHGetFileInfo equ <SHGetFileInfoA>

SHGetFileInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHGetFolderLocation PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHGetFolderPathA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHGetFolderPath equ <SHGetFolderPathA>

SHGetFolderPathAndSubDirA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHGetFolderPathAndSubDir equ <SHGetFolderPathAndSubDirA>

SHGetFolderPathAndSubDirW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHGetFolderPathW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHGetIconOverlayIndexA PROTO :DWORD,:DWORD
SHGetIconOverlayIndex equ <SHGetIconOverlayIndexA>

SHGetIconOverlayIndexW PROTO :DWORD,:DWORD
SHGetImageList PROTO :DWORD,:DWORD,:DWORD
SHGetInstanceExplorer PROTO :DWORD
SHGetMalloc PROTO :DWORD
SHGetNewLinkInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHGetNewLinkInfo equ <SHGetNewLinkInfoA>

SHGetNewLinkInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHGetPathFromIDListA PROTO :DWORD,:DWORD
SHGetPathFromIDList equ <SHGetPathFromIDListA>

SHGetPathFromIDListW PROTO :DWORD,:DWORD
SHGetRealIDL PROTO :DWORD,:DWORD,:DWORD
SHGetSetFolderCustomSettingsW PROTO :DWORD,:DWORD,:DWORD
SHGetSetSettings PROTO :DWORD,:DWORD,:DWORD
SHGetSettings PROTO :DWORD,:DWORD
SHGetShellStyleHInstance PROTO 
SHGetSpecialFolderLocation PROTO :DWORD,:DWORD,:DWORD
SHGetSpecialFolderPathA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHGetSpecialFolderPath equ <SHGetSpecialFolderPathA>

SHGetSpecialFolderPathW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHGetUnreadMailCountW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHHandleUpdateImage PROTO :DWORD
SHILCreateFromPath PROTO :DWORD,:DWORD,:DWORD
SHInvokePrinterCommandA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHInvokePrinterCommand equ <SHInvokePrinterCommandA>

SHInvokePrinterCommandW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHIsFileAvailableOffline PROTO :DWORD,:DWORD
SHLimitInputEdit PROTO :DWORD,:DWORD
SHLoadInProc PROTO :DWORD
SHLoadNonloadedIconOverlayIdentifiers PROTO 
SHLoadOLE PROTO :DWORD
SHMapIDListToImageListIndexAsync PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHMapPIDLToSystemImageListIndex PROTO :DWORD,:DWORD,:DWORD
SHMultiFileProperties PROTO :DWORD,:DWORD
SHObjectProperties PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHOpenFolderAndSelectItems PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHOpenPropSheetW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHParseDisplayName PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHPathPrepareForWriteA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHPathPrepareForWrite equ <SHPathPrepareForWriteA>

SHPathPrepareForWriteW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHPropStgCreate PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHPropStgReadMultiple PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHPropStgWriteMultiple PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SHQueryRecycleBinA PROTO :DWORD,:DWORD
SHQueryRecycleBin equ <SHQueryRecycleBinA>

SHQueryRecycleBinW PROTO :DWORD,:DWORD
SHReplaceFromPropSheetExtArray PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHRestricted PROTO :DWORD
SHRunControlPanel PROTO :DWORD,:DWORD
SHSetInstanceExplorer PROTO :DWORD
SHSetLocalizedName PROTO :DWORD,:DWORD,:DWORD
SHSetUnreadMailCountW PROTO :DWORD,:DWORD,:DWORD
SHShellFolderView_Message PROTO :DWORD,:DWORD,:DWORD
SHSimpleIDListFromPath PROTO :DWORD
SHStartNetConnectionDialogW PROTO :DWORD,:DWORD,:DWORD
SHTestTokenMembership PROTO :DWORD,:DWORD
SHUpdateImageA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHUpdateImage equ <SHUpdateImageA>

SHUpdateImageW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SHUpdateRecycleBinIcon PROTO 
SHValidateUNC PROTO :DWORD,:DWORD,:DWORD
SheChangeDirA PROTO :DWORD
SheChangeDir equ <SheChangeDirA>

SheChangeDirExA PROTO :DWORD
SheChangeDirEx equ <SheChangeDirExA>

SheChangeDirExW PROTO :DWORD
SheChangeDirW PROTO :DWORD
SheConvertPathW PROTO :DWORD,:DWORD,:DWORD
SheFullPathA PROTO :DWORD,:DWORD,:DWORD
SheFullPath equ <SheFullPathA>

SheFullPathW PROTO :DWORD,:DWORD,:DWORD
SheGetCurDrive PROTO 
SheGetDirA PROTO :DWORD,:DWORD
SheGetDir equ <SheGetDirA>

SheGetDirExW PROTO :DWORD,:DWORD,:DWORD
SheGetDirW PROTO :DWORD,:DWORD
SheGetPathOffsetW PROTO :DWORD
SheRemoveQuotesA PROTO :DWORD
SheRemoveQuotes equ <SheRemoveQuotesA>

SheRemoveQuotesW PROTO :DWORD
SheSetCurDrive PROTO :DWORD
SheShortenPathA PROTO :DWORD,:DWORD
SheShortenPath equ <SheShortenPathA>

SheShortenPathW PROTO :DWORD,:DWORD
ShellAboutA PROTO :DWORD,:DWORD,:DWORD,:DWORD
ShellAbout equ <ShellAboutA>

ShellAboutW PROTO :DWORD,:DWORD,:DWORD,:DWORD
ShellExecuteA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ShellExecute equ <ShellExecuteA>

ShellExecuteExA PROTO :DWORD
ShellExecuteEx equ <ShellExecuteExA>

ShellExecuteExW PROTO :DWORD
ShellExecuteW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ShellHookProc PROTO :DWORD,:DWORD,:DWORD
Shell_GetCachedImageIndex PROTO :DWORD,:DWORD,:DWORD
Shell_GetImageLists PROTO :DWORD,:DWORD
Shell_MergeMenus PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
Shell_NotifyIconA PROTO :DWORD,:DWORD
Shell_NotifyIcon equ <Shell_NotifyIconA>

Shell_NotifyIconW PROTO :DWORD,:DWORD
SignalFileOpen PROTO :DWORD
WOWShellExecute PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
Win32DeleteFile PROTO :DWORD
WriteCabinetState PROTO :DWORD
_WriteCabinetState PROTO :DWORD

ELSE
echo -----------------------------------------
echo WARNING Duplicate include file shell32.inc
echo -----------------------------------------
ENDIF
