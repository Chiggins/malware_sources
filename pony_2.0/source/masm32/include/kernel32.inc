  ; ===========================================
  ; kernel32.inc copyright MASM32 1998 - 2005
  ; ===========================================

IFNDEF KERNEL32_INC
KERNEL32_INC equ <1>

ActivateActCtx PROTO :DWORD,:DWORD
AddAtomA PROTO :DWORD
AddAtom equ <AddAtomA>

AddAtomW PROTO :DWORD
AddLocalAlternateComputerNameA PROTO :DWORD,:DWORD
AddLocalAlternateComputerName equ <AddLocalAlternateComputerNameA>

AddLocalAlternateComputerNameW PROTO :DWORD,:DWORD
AddRefActCtx PROTO :DWORD
AddVectoredExceptionHandler PROTO :DWORD,:DWORD
AllocConsole PROTO 
AllocateUserPhysicalPages PROTO :DWORD,:DWORD,:DWORD
AreFileApisANSI PROTO 
AssignProcessToJobObject PROTO :DWORD,:DWORD
AttachConsole PROTO :DWORD
BackupRead PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BackupSeek PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BackupWrite PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
Beep PROTO :DWORD,:DWORD
BeginUpdateResourceA PROTO :DWORD,:DWORD
BeginUpdateResource equ <BeginUpdateResourceA>

BeginUpdateResourceW PROTO :DWORD,:DWORD
BindIoCompletionCallback PROTO :DWORD,:DWORD,:DWORD
BuildCommDCBA PROTO :DWORD,:DWORD
BuildCommDCB equ <BuildCommDCBA>

BuildCommDCBAndTimeoutsA PROTO :DWORD,:DWORD,:DWORD
BuildCommDCBAndTimeouts equ <BuildCommDCBAndTimeoutsA>

BuildCommDCBAndTimeoutsW PROTO :DWORD,:DWORD,:DWORD
BuildCommDCBW PROTO :DWORD,:DWORD
CallNamedPipeA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CallNamedPipe equ <CallNamedPipeA>

CallNamedPipeW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CancelDeviceWakeupRequest PROTO :DWORD
CancelIo PROTO :DWORD
CancelTimerQueueTimer PROTO :DWORD,:DWORD
CancelWaitableTimer PROTO :DWORD
ChangeTimerQueueTimer PROTO :DWORD,:DWORD,:DWORD,:DWORD
CheckNameLegalDOS8Dot3A PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CheckNameLegalDOS8Dot3 equ <CheckNameLegalDOS8Dot3A>

CheckNameLegalDOS8Dot3W PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CheckRemoteDebuggerPresent PROTO :DWORD,:DWORD
ClearCommBreak PROTO :DWORD
ClearCommError PROTO :DWORD,:DWORD,:DWORD
CloseHandle PROTO :DWORD
CommConfigDialogA PROTO :DWORD,:DWORD,:DWORD
CommConfigDialog equ <CommConfigDialogA>

CommConfigDialogW PROTO :DWORD,:DWORD,:DWORD
CompareFileTime PROTO :DWORD,:DWORD
CompareStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CompareString equ <CompareStringA>

CompareStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ConnectNamedPipe PROTO :DWORD,:DWORD
ContinueDebugEvent PROTO :DWORD,:DWORD,:DWORD
ConvertDefaultLocale PROTO :DWORD
ConvertFiberToThread PROTO 
ConvertThreadToFiber PROTO :DWORD
CopyFileA PROTO :DWORD,:DWORD,:DWORD
CopyFile equ <CopyFileA>

CopyFileExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CopyFileEx equ <CopyFileExA>

CopyFileExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CopyFileW PROTO :DWORD,:DWORD,:DWORD
CreateActCtxA PROTO :DWORD
CreateActCtx equ <CreateActCtxA>

CreateActCtxW PROTO :DWORD
CreateConsoleScreenBuffer PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateDirectoryA PROTO :DWORD,:DWORD
CreateDirectory equ <CreateDirectoryA>

CreateDirectoryExA PROTO :DWORD,:DWORD,:DWORD
CreateDirectoryEx equ <CreateDirectoryExA>

CreateDirectoryExW PROTO :DWORD,:DWORD,:DWORD
CreateDirectoryW PROTO :DWORD,:DWORD
CreateEventA PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateEvent equ <CreateEventA>

CreateEventW PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateFiber PROTO :DWORD,:DWORD,:DWORD
CreateFiberEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateFileA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateFile equ <CreateFileA>

CreateFileMappingA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateFileMapping equ <CreateFileMappingA>

CreateFileMappingW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateFileW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateHardLinkA PROTO :DWORD,:DWORD,:DWORD
CreateHardLink equ <CreateHardLinkA>

CreateHardLinkW PROTO :DWORD,:DWORD,:DWORD
CreateIoCompletionPort PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateJobObjectA PROTO :DWORD,:DWORD
CreateJobObject equ <CreateJobObjectA>

CreateJobObjectW PROTO :DWORD,:DWORD
CreateJobSet PROTO :DWORD,:DWORD,:DWORD
CreateMailslotA PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateMailslot equ <CreateMailslotA>

CreateMailslotW PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateMemoryResourceNotification PROTO :DWORD
CreateMutexA PROTO :DWORD,:DWORD,:DWORD
CreateMutex equ <CreateMutexA>

CreateMutexW PROTO :DWORD,:DWORD,:DWORD
CreateNamedPipeA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateNamedPipe equ <CreateNamedPipeA>

CreateNamedPipeW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreatePipe PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateProcessA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateProcess equ <CreateProcessA>

CreateProcessInternalWSecure PROTO 
CreateProcessW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateRemoteThread PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateSemaphoreA PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateSemaphore equ <CreateSemaphoreA>

CreateSemaphoreW PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateTapePartition PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateThread PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateTimerQueue PROTO 
CreateTimerQueueTimer PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateToolhelp32Snapshot PROTO :DWORD,:DWORD
CreateWaitableTimerA PROTO :DWORD,:DWORD,:DWORD
CreateWaitableTimer equ <CreateWaitableTimerA>

CreateWaitableTimerW PROTO :DWORD,:DWORD,:DWORD
DeactivateActCtx PROTO :DWORD,:DWORD
DebugActiveProcess PROTO :DWORD
DebugActiveProcessStop PROTO :DWORD
DebugBreak PROTO 
DebugBreakProcess PROTO :DWORD
DebugSetProcessKillOnExit PROTO :DWORD
DecodePointer PROTO :DWORD
DecodeSystemPointer PROTO :DWORD
DefineDosDeviceA PROTO :DWORD,:DWORD,:DWORD
DefineDosDevice equ <DefineDosDeviceA>

DefineDosDeviceW PROTO :DWORD,:DWORD,:DWORD
DeleteAtom PROTO :DWORD
DeleteCriticalSection PROTO :DWORD
DeleteFiber PROTO :DWORD
DeleteFileA PROTO :DWORD
DeleteFile equ <DeleteFileA>

DeleteFileW PROTO :DWORD
DeleteTimerQueue PROTO :DWORD
DeleteTimerQueueEx PROTO :DWORD,:DWORD
DeleteTimerQueueTimer PROTO :DWORD,:DWORD,:DWORD
DeleteVolumeMountPointA PROTO :DWORD
DeleteVolumeMountPoint equ <DeleteVolumeMountPointA>

DeleteVolumeMountPointW PROTO :DWORD
DeviceIoControl PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DisableThreadLibraryCalls PROTO :DWORD
DisconnectNamedPipe PROTO :DWORD
DnsHostnameToComputerNameA PROTO :DWORD,:DWORD,:DWORD
DnsHostnameToComputerName equ <DnsHostnameToComputerNameA>

DnsHostnameToComputerNameW PROTO :DWORD,:DWORD,:DWORD
DosDateTimeToFileTime PROTO :DWORD,:DWORD,:DWORD
DuplicateHandle PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EncodePointer PROTO :DWORD
EncodeSystemPointer PROTO :DWORD
EndUpdateResourceA PROTO :DWORD,:DWORD
EndUpdateResource equ <EndUpdateResourceA>

EndUpdateResourceW PROTO :DWORD,:DWORD
EnterCriticalSection PROTO :DWORD
EnumCalendarInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumCalendarInfo equ <EnumCalendarInfoA>

EnumCalendarInfoExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumCalendarInfoEx equ <EnumCalendarInfoExA>

EnumCalendarInfoExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumCalendarInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumDateFormatsA PROTO :DWORD,:DWORD,:DWORD
EnumDateFormats equ <EnumDateFormatsA>

EnumDateFormatsExA PROTO :DWORD,:DWORD,:DWORD
EnumDateFormatsEx equ <EnumDateFormatsExA>

EnumDateFormatsExW PROTO :DWORD,:DWORD,:DWORD
EnumDateFormatsW PROTO :DWORD,:DWORD,:DWORD
EnumLanguageGroupLocalesA PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumLanguageGroupLocales equ <EnumLanguageGroupLocalesA>

EnumLanguageGroupLocalesW PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumResourceLanguagesA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EnumResourceLanguages equ <EnumResourceLanguagesA>

EnumResourceLanguagesW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EnumResourceNamesA PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumResourceNames equ <EnumResourceNamesA>

EnumResourceNamesW PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumResourceTypesA PROTO :DWORD,:DWORD,:DWORD
EnumResourceTypes equ <EnumResourceTypesA>

EnumResourceTypesW PROTO :DWORD,:DWORD,:DWORD
EnumSystemCodePagesA PROTO :DWORD,:DWORD
EnumSystemCodePages equ <EnumSystemCodePagesA>

EnumSystemCodePagesW PROTO :DWORD,:DWORD
EnumSystemGeoID PROTO :DWORD,:DWORD,:DWORD
EnumSystemLanguageGroupsA PROTO :DWORD,:DWORD,:DWORD
EnumSystemLanguageGroups equ <EnumSystemLanguageGroupsA>

EnumSystemLanguageGroupsW PROTO :DWORD,:DWORD,:DWORD
EnumSystemLocalesA PROTO :DWORD,:DWORD
EnumSystemLocales equ <EnumSystemLocalesA>

EnumSystemLocalesW PROTO :DWORD,:DWORD
EnumTimeFormatsA PROTO :DWORD,:DWORD,:DWORD
EnumTimeFormats equ <EnumTimeFormatsA>

EnumTimeFormatsW PROTO :DWORD,:DWORD,:DWORD
EnumUILanguagesA PROTO :DWORD,:DWORD,:DWORD
EnumUILanguages equ <EnumUILanguagesA>

EnumUILanguagesW PROTO :DWORD,:DWORD,:DWORD
EnumerateLocalComputerNamesA PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumerateLocalComputerNames equ <EnumerateLocalComputerNamesA>

EnumerateLocalComputerNamesW PROTO :DWORD,:DWORD,:DWORD,:DWORD
EraseTape PROTO :DWORD,:DWORD,:DWORD
EscapeCommFunction PROTO :DWORD,:DWORD
ExitProcess PROTO :DWORD
ExitThread PROTO :DWORD
ExpandEnvironmentStringsA PROTO :DWORD,:DWORD,:DWORD
ExpandEnvironmentStrings equ <ExpandEnvironmentStringsA>

ExpandEnvironmentStringsW PROTO :DWORD,:DWORD,:DWORD
FatalAppExitA PROTO :DWORD,:DWORD
FatalAppExit equ <FatalAppExitA>

FatalAppExitW PROTO :DWORD,:DWORD
FatalExit PROTO :DWORD
FileTimeToDosDateTime PROTO :DWORD,:DWORD,:DWORD
FileTimeToLocalFileTime PROTO :DWORD,:DWORD
FileTimeToSystemTime PROTO :DWORD,:DWORD
FillConsoleOutputAttribute PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FillConsoleOutputCharacterA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FillConsoleOutputCharacter equ <FillConsoleOutputCharacterA>

FillConsoleOutputCharacterW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FindActCtxSectionGuid PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FindActCtxSectionStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FindActCtxSectionString equ <FindActCtxSectionStringA>

FindActCtxSectionStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FindAtomA PROTO :DWORD
FindAtom equ <FindAtomA>

FindAtomW PROTO :DWORD
FindClose PROTO :DWORD
FindCloseChangeNotification PROTO :DWORD
FindFirstChangeNotificationA PROTO :DWORD,:DWORD,:DWORD
FindFirstChangeNotification equ <FindFirstChangeNotificationA>

FindFirstChangeNotificationW PROTO :DWORD,:DWORD,:DWORD
FindFirstFileA PROTO :DWORD,:DWORD
FindFirstFile equ <FindFirstFileA>

FindFirstFileExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FindFirstFileEx equ <FindFirstFileExA>

FindFirstFileExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FindFirstFileW PROTO :DWORD,:DWORD
FindFirstVolumeA PROTO :DWORD,:DWORD
FindFirstVolume equ <FindFirstVolumeA>

FindFirstVolumeMountPointA PROTO :DWORD,:DWORD,:DWORD
FindFirstVolumeMountPoint equ <FindFirstVolumeMountPointA>

FindFirstVolumeMountPointW PROTO :DWORD,:DWORD,:DWORD
FindFirstVolumeW PROTO :DWORD,:DWORD
FindNextChangeNotification PROTO :DWORD
FindNextFileA PROTO :DWORD,:DWORD
FindNextFile equ <FindNextFileA>

FindNextFileW PROTO :DWORD,:DWORD
FindNextVolumeA PROTO :DWORD,:DWORD,:DWORD
FindNextVolume equ <FindNextVolumeA>

FindNextVolumeMountPointA PROTO :DWORD,:DWORD,:DWORD
FindNextVolumeMountPoint equ <FindNextVolumeMountPointA>

FindNextVolumeMountPointW PROTO :DWORD,:DWORD,:DWORD
FindNextVolumeW PROTO :DWORD,:DWORD,:DWORD
FindResourceA PROTO :DWORD,:DWORD,:DWORD
FindResource equ <FindResourceA>

FindResourceExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
FindResourceEx equ <FindResourceExA>

FindResourceExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
FindResourceW PROTO :DWORD,:DWORD,:DWORD
FindVolumeClose PROTO :DWORD
FindVolumeMountPointClose PROTO :DWORD
FlushConsoleInputBuffer PROTO :DWORD
FlushFileBuffers PROTO :DWORD
FlushInstructionCache PROTO :DWORD,:DWORD,:DWORD
FlushViewOfFile PROTO :DWORD,:DWORD
FoldStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FoldString equ <FoldStringA>

FoldStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FormatMessageA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FormatMessage equ <FormatMessageA>

FormatMessageW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FreeConsole PROTO 
FreeEnvironmentStringsA PROTO :DWORD
FreeEnvironmentStrings equ <FreeEnvironmentStringsA>

FreeEnvironmentStringsW PROTO :DWORD
FreeLibrary PROTO :DWORD
FreeLibraryAndExitThread PROTO :DWORD,:DWORD
FreeResource PROTO :DWORD
FreeUserPhysicalPages PROTO :DWORD,:DWORD,:DWORD
GenerateConsoleCtrlEvent PROTO :DWORD,:DWORD
GetACP PROTO 
GetAtomNameA PROTO :DWORD,:DWORD,:DWORD
GetAtomName equ <GetAtomNameA>

GetAtomNameW PROTO :DWORD,:DWORD,:DWORD
GetBinaryTypeA PROTO :DWORD,:DWORD
GetBinaryType equ <GetBinaryTypeA>

GetBinaryTypeW PROTO :DWORD,:DWORD
GetCPInfo PROTO :DWORD,:DWORD
GetCPInfoExA PROTO :DWORD,:DWORD,:DWORD
GetCPInfoEx equ <GetCPInfoExA>

GetCPInfoExW PROTO :DWORD,:DWORD,:DWORD
GetCalendarInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetCalendarInfo equ <GetCalendarInfoA>

GetCalendarInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetCommConfig PROTO :DWORD,:DWORD,:DWORD
GetCommMask PROTO :DWORD,:DWORD
GetCommModemStatus PROTO :DWORD,:DWORD
GetCommProperties PROTO :DWORD,:DWORD
GetCommState PROTO :DWORD,:DWORD
GetCommTimeouts PROTO :DWORD,:DWORD
GetCommandLineA PROTO 
GetCommandLine equ <GetCommandLineA>

GetCommandLineW PROTO 
GetCompressedFileSizeA PROTO :DWORD,:DWORD
GetCompressedFileSize equ <GetCompressedFileSizeA>

GetCompressedFileSizeW PROTO :DWORD,:DWORD
GetComputerNameA PROTO :DWORD,:DWORD
GetComputerName equ <GetComputerNameA>

GetComputerNameExA PROTO :DWORD,:DWORD,:DWORD
GetComputerNameEx equ <GetComputerNameExA>

GetComputerNameExW PROTO :DWORD,:DWORD,:DWORD
GetComputerNameW PROTO :DWORD,:DWORD
GetConsoleCP PROTO 
GetConsoleCursorInfo PROTO :DWORD,:DWORD
GetConsoleDisplayMode PROTO :DWORD
GetConsoleFontSize PROTO :DWORD,:DWORD
GetConsoleMode PROTO :DWORD,:DWORD
GetConsoleOutputCP PROTO 
GetConsoleProcessList PROTO :DWORD,:DWORD
GetConsoleScreenBufferInfo PROTO :DWORD,:DWORD
GetConsoleSelectionInfo PROTO :DWORD
GetConsoleTitleA PROTO :DWORD,:DWORD
GetConsoleTitle equ <GetConsoleTitleA>

GetConsoleTitleW PROTO :DWORD,:DWORD
GetConsoleWindow PROTO 
GetCurrencyFormatA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetCurrencyFormat equ <GetCurrencyFormatA>

GetCurrencyFormatW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetCurrentActCtx PROTO :DWORD
GetCurrentConsoleFont PROTO :DWORD,:DWORD,:DWORD
GetCurrentDirectoryA PROTO :DWORD,:DWORD
GetCurrentDirectory equ <GetCurrentDirectoryA>

GetCurrentDirectoryW PROTO :DWORD,:DWORD
GetCurrentProcess PROTO 
GetCurrentProcessId PROTO 
GetCurrentThread PROTO 
GetCurrentThreadId PROTO 
GetDateFormatA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetDateFormat equ <GetDateFormatA>

GetDateFormatW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetDefaultCommConfigA PROTO :DWORD,:DWORD,:DWORD
GetDefaultCommConfig equ <GetDefaultCommConfigA>

GetDefaultCommConfigW PROTO :DWORD,:DWORD,:DWORD
GetDevicePowerState PROTO :DWORD,:DWORD
GetDiskFreeSpaceA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetDiskFreeSpace equ <GetDiskFreeSpaceA>

GetDiskFreeSpaceExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetDiskFreeSpaceEx equ <GetDiskFreeSpaceExA>

GetDiskFreeSpaceExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetDiskFreeSpaceW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetDllDirectoryA PROTO :DWORD,:DWORD
GetDllDirectory equ <GetDllDirectoryA>

GetDllDirectoryW PROTO :DWORD,:DWORD
GetDriveTypeA PROTO :DWORD
GetDriveType equ <GetDriveTypeA>

GetDriveTypeW PROTO :DWORD
GetEnvironmentStringsA PROTO 
GetEnvironmentStrings equ <GetEnvironmentStringsA>

GetEnvironmentStringsW PROTO 
GetEnvironmentVariableA PROTO :DWORD,:DWORD,:DWORD
GetEnvironmentVariable equ <GetEnvironmentVariableA>

GetEnvironmentVariableW PROTO :DWORD,:DWORD,:DWORD
GetExitCodeProcess PROTO :DWORD,:DWORD
GetExitCodeThread PROTO :DWORD,:DWORD
GetFileAttributesA PROTO :DWORD
GetFileAttributes equ <GetFileAttributesA>

GetFileAttributesExA PROTO :DWORD,:DWORD,:DWORD
GetFileAttributesEx equ <GetFileAttributesExA>

GetFileAttributesExW PROTO :DWORD,:DWORD,:DWORD
GetFileAttributesW PROTO :DWORD
GetFileInformationByHandle PROTO :DWORD,:DWORD
GetFileSize PROTO :DWORD,:DWORD
GetFileSizeEx PROTO :DWORD,:DWORD
GetFileTime PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetFileType PROTO :DWORD
GetFirmwareEnvironmentVariableA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetFirmwareEnvironmentVariable equ <GetFirmwareEnvironmentVariableA>

GetFirmwareEnvironmentVariableW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetFullPathNameA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetFullPathName equ <GetFullPathNameA>

GetFullPathNameW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetGeoInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetGeoInfo equ <GetGeoInfoA>

GetGeoInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetHandleInformation PROTO :DWORD,:DWORD
GetLargestConsoleWindowSize PROTO :DWORD
GetLastError PROTO 
GetLocalTime PROTO :DWORD
GetLocaleInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetLocaleInfo equ <GetLocaleInfoA>

GetLocaleInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetLogicalDriveStringsA PROTO :DWORD,:DWORD
GetLogicalDriveStrings equ <GetLogicalDriveStringsA>

GetLogicalDriveStringsW PROTO :DWORD,:DWORD
GetLogicalDrives PROTO 
GetLongPathNameA PROTO :DWORD,:DWORD,:DWORD
GetLongPathName equ <GetLongPathNameA>

GetLongPathNameW PROTO :DWORD,:DWORD,:DWORD
GetMailslotInfo PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetModuleFileNameA PROTO :DWORD,:DWORD,:DWORD
GetModuleFileName equ <GetModuleFileNameA>

GetModuleFileNameW PROTO :DWORD,:DWORD,:DWORD
GetModuleHandleA PROTO :DWORD
GetModuleHandle equ <GetModuleHandleA>

GetModuleHandleExA PROTO :DWORD,:DWORD,:DWORD
GetModuleHandleEx equ <GetModuleHandleExA>

GetModuleHandleExW PROTO :DWORD,:DWORD,:DWORD
GetModuleHandleW PROTO :DWORD
GetNamedPipeHandleStateA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetNamedPipeHandleState equ <GetNamedPipeHandleStateA>

GetNamedPipeHandleStateW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetNamedPipeInfo PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetNativeSystemInfo PROTO :DWORD
GetNumaAvailableMemory PROTO :DWORD,:DWORD,:DWORD
GetNumaAvailableMemoryNode PROTO :DWORD,:DWORD
GetNumaHighestNodeNumber PROTO :DWORD
GetNumaNodeProcessorMask PROTO :DWORD,:DWORD
GetNumaProcessorMap PROTO :DWORD,:DWORD,:DWORD
GetNumaProcessorNode PROTO :DWORD,:DWORD
GetNumberFormatA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetNumberFormat equ <GetNumberFormatA>

GetNumberFormatW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetNumberOfConsoleInputEvents PROTO :DWORD,:DWORD
GetNumberOfConsoleMouseButtons PROTO :DWORD
GetOEMCP PROTO 
GetOverlappedResult PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetPriorityClass PROTO :DWORD
GetPrivateProfileIntA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetPrivateProfileInt equ <GetPrivateProfileIntA>

GetPrivateProfileIntW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetPrivateProfileSectionA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetPrivateProfileSection equ <GetPrivateProfileSectionA>

GetPrivateProfileSectionNamesA PROTO :DWORD,:DWORD,:DWORD
GetPrivateProfileSectionNames equ <GetPrivateProfileSectionNamesA>

GetPrivateProfileSectionNamesW PROTO :DWORD,:DWORD,:DWORD
GetPrivateProfileSectionW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetPrivateProfileStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetPrivateProfileString equ <GetPrivateProfileStringA>

GetPrivateProfileStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetPrivateProfileStructA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetPrivateProfileStruct equ <GetPrivateProfileStructA>

GetPrivateProfileStructW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetProcAddress PROTO :DWORD,:DWORD
GetProcessAffinityMask PROTO :DWORD,:DWORD,:DWORD
GetProcessHandleCount PROTO :DWORD,:DWORD
GetProcessHeap PROTO 
GetProcessHeaps PROTO :DWORD,:DWORD
GetProcessId PROTO :DWORD
GetProcessIoCounters PROTO :DWORD,:DWORD
GetProcessPriorityBoost PROTO :DWORD,:DWORD
GetProcessShutdownParameters PROTO :DWORD,:DWORD
GetProcessTimes PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetProcessVersion PROTO :DWORD
GetProcessWorkingSetSize PROTO :DWORD,:DWORD,:DWORD
GetProfileIntA PROTO :DWORD,:DWORD,:DWORD
GetProfileInt equ <GetProfileIntA>

GetProfileIntW PROTO :DWORD,:DWORD,:DWORD
GetProfileSectionA PROTO :DWORD,:DWORD,:DWORD
GetProfileSection equ <GetProfileSectionA>

GetProfileSectionW PROTO :DWORD,:DWORD,:DWORD
GetProfileStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetProfileString equ <GetProfileStringA>

GetProfileStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetQueuedCompletionStatus PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetShortPathNameA PROTO :DWORD,:DWORD,:DWORD
GetShortPathName equ <GetShortPathNameA>

GetShortPathNameW PROTO :DWORD,:DWORD,:DWORD
GetStartupInfoA PROTO :DWORD
GetStartupInfo equ <GetStartupInfoA>

GetStartupInfoW PROTO :DWORD
GetStdHandle PROTO :DWORD
GetStringTypeA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetStringType equ <GetStringTypeA>

GetStringTypeExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetStringTypeEx equ <GetStringTypeExA>

GetStringTypeExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetStringTypeW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetSystemDefaultLCID PROTO 
GetSystemDefaultLangID PROTO 
GetSystemDefaultUILanguage PROTO 
GetSystemDirectoryA PROTO :DWORD,:DWORD
GetSystemDirectory equ <GetSystemDirectoryA>

GetSystemDirectoryW PROTO :DWORD,:DWORD
GetSystemInfo PROTO :DWORD
GetSystemPowerStatus PROTO :DWORD
GetSystemRegistryQuota PROTO :DWORD,:DWORD
GetSystemTime PROTO :DWORD
GetSystemTimeAdjustment PROTO :DWORD,:DWORD,:DWORD
GetSystemTimeAsFileTime PROTO :DWORD
GetSystemTimes PROTO :DWORD,:DWORD,:DWORD
GetSystemWindowsDirectoryA PROTO :DWORD,:DWORD
GetSystemWindowsDirectory equ <GetSystemWindowsDirectoryA>

GetSystemWindowsDirectoryW PROTO :DWORD,:DWORD
GetSystemWow64DirectoryA PROTO :DWORD,:DWORD
GetSystemWow64Directory equ <GetSystemWow64DirectoryA>

GetSystemWow64DirectoryW PROTO :DWORD,:DWORD
GetTapeParameters PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetTapePosition PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetTapeStatus PROTO :DWORD
GetTempFileNameA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetTempFileName equ <GetTempFileNameA>

GetTempFileNameW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetTempPathA PROTO :DWORD,:DWORD
GetTempPath equ <GetTempPathA>

GetTempPathW PROTO :DWORD,:DWORD
GetThreadContext PROTO :DWORD,:DWORD
GetThreadIOPendingFlag PROTO :DWORD,:DWORD
GetThreadLocale PROTO 
GetThreadPriority PROTO :DWORD
GetThreadPriorityBoost PROTO :DWORD,:DWORD
GetThreadSelectorEntry PROTO :DWORD,:DWORD,:DWORD
GetThreadTimes PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetTickCount PROTO 
GetTimeFormatA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetTimeFormat equ <GetTimeFormatA>

GetTimeFormatW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetTimeZoneInformation PROTO :DWORD
GetUserDefaultLCID PROTO 
GetUserDefaultLangID PROTO 
GetUserDefaultUILanguage PROTO 
GetUserGeoID PROTO :DWORD
GetVersion PROTO 
GetVersionExA PROTO :DWORD
GetVersionEx equ <GetVersionExA>

GetVersionExW PROTO :DWORD
GetVolumeInformationA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetVolumeInformation equ <GetVolumeInformationA>

GetVolumeInformationW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetVolumeNameForVolumeMountPointA PROTO :DWORD,:DWORD,:DWORD
GetVolumeNameForVolumeMountPoint equ <GetVolumeNameForVolumeMountPointA>

GetVolumeNameForVolumeMountPointW PROTO :DWORD,:DWORD,:DWORD
GetVolumePathNameA PROTO :DWORD,:DWORD,:DWORD
GetVolumePathName equ <GetVolumePathNameA>

GetVolumePathNameW PROTO :DWORD,:DWORD,:DWORD
GetVolumePathNamesForVolumeNameA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetVolumePathNamesForVolumeName equ <GetVolumePathNamesForVolumeNameA>

GetVolumePathNamesForVolumeNameW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetWindowsDirectoryA PROTO :DWORD,:DWORD
GetWindowsDirectory equ <GetWindowsDirectoryA>

GetWindowsDirectoryW PROTO :DWORD,:DWORD
GetWriteWatch PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GlobalAddAtomA PROTO :DWORD
GlobalAddAtom equ <GlobalAddAtomA>

GlobalAddAtomW PROTO :DWORD
GlobalAlloc PROTO :DWORD,:DWORD
GlobalCompact PROTO :DWORD
GlobalDeleteAtom PROTO :DWORD
GlobalFindAtomA PROTO :DWORD
GlobalFindAtom equ <GlobalFindAtomA>

GlobalFindAtomW PROTO :DWORD
GlobalFix PROTO :DWORD
GlobalFlags PROTO :DWORD
GlobalFree PROTO :DWORD
GlobalGetAtomNameA PROTO :DWORD,:DWORD,:DWORD
GlobalGetAtomName equ <GlobalGetAtomNameA>

GlobalGetAtomNameW PROTO :DWORD,:DWORD,:DWORD
GlobalHandle PROTO :DWORD
GlobalLock PROTO :DWORD
GlobalMemoryStatus PROTO :DWORD
GlobalMemoryStatusEx PROTO :DWORD
GlobalReAlloc PROTO :DWORD,:DWORD,:DWORD
GlobalSize PROTO :DWORD
GlobalUnWire PROTO :DWORD
GlobalUnfix PROTO :DWORD
GlobalUnlock PROTO :DWORD
GlobalWire PROTO :DWORD
Heap32First PROTO :DWORD,:DWORD,:DWORD
Heap32ListFirst PROTO :DWORD,:DWORD
Heap32ListNext PROTO :DWORD,:DWORD
Heap32Next PROTO :DWORD
HeapAlloc PROTO :DWORD,:DWORD,:DWORD
HeapCompact PROTO :DWORD,:DWORD
HeapCreate PROTO :DWORD,:DWORD,:DWORD
HeapDestroy PROTO :DWORD
HeapFree PROTO :DWORD,:DWORD,:DWORD
HeapLock PROTO :DWORD
HeapQueryInformation PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
HeapReAlloc PROTO :DWORD,:DWORD,:DWORD,:DWORD
HeapSetInformation PROTO :DWORD,:DWORD,:DWORD,:DWORD
HeapSize PROTO :DWORD,:DWORD,:DWORD
HeapUnlock PROTO :DWORD
HeapValidate PROTO :DWORD,:DWORD,:DWORD
HeapWalk PROTO :DWORD,:DWORD
InitAtomTable PROTO :DWORD
InitializeCriticalSection PROTO :DWORD
InitializeCriticalSectionAndSpinCount PROTO :DWORD,:DWORD
InitializeSListHead PROTO :DWORD
InterlockedCompareExchange PROTO :DWORD,:DWORD,:DWORD
InterlockedDecrement PROTO :DWORD
InterlockedExchange PROTO :DWORD,:DWORD
InterlockedExchangeAdd PROTO :DWORD,:DWORD
InterlockedFlushSList PROTO :DWORD
InterlockedIncrement PROTO :DWORD
InterlockedPopEntrySList PROTO :DWORD
InterlockedPushEntrySList PROTO :DWORD,:DWORD
IsBadCodePtr PROTO :DWORD
IsBadHugeReadPtr PROTO :DWORD,:DWORD
IsBadHugeWritePtr PROTO :DWORD,:DWORD
IsBadReadPtr PROTO :DWORD,:DWORD
IsBadStringPtrA PROTO :DWORD,:DWORD
IsBadStringPtr equ <IsBadStringPtrA>

IsBadStringPtrW PROTO :DWORD,:DWORD
IsBadWritePtr PROTO :DWORD,:DWORD
IsDBCSLeadByte PROTO :DWORD
IsDBCSLeadByteEx PROTO :DWORD,:DWORD
IsDebuggerPresent PROTO 
IsProcessInJob PROTO :DWORD,:DWORD,:DWORD
IsProcessorFeaturePresent PROTO :DWORD
IsSystemResumeAutomatic PROTO 
IsValidCodePage PROTO :DWORD
IsValidLanguageGroup PROTO :DWORD,:DWORD
IsValidLocale PROTO :DWORD,:DWORD
IsWow64Process PROTO :DWORD,:DWORD
LCMapStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LCMapString equ <LCMapStringA>

LCMapStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LeaveCriticalSection PROTO :DWORD
LoadLibraryA PROTO :DWORD
LoadLibrary equ <LoadLibraryA>

LoadLibraryExA PROTO :DWORD,:DWORD,:DWORD
LoadLibraryEx equ <LoadLibraryExA>

LoadLibraryExW PROTO :DWORD,:DWORD,:DWORD
LoadLibraryW PROTO :DWORD
LoadModule PROTO :DWORD,:DWORD
LoadResource PROTO :DWORD,:DWORD
LocalAlloc PROTO :DWORD,:DWORD
LocalCompact PROTO :DWORD
LocalFileTimeToFileTime PROTO :DWORD,:DWORD
LocalFlags PROTO :DWORD
LocalFree PROTO :DWORD
LocalHandle PROTO :DWORD
LocalLock PROTO :DWORD
LocalReAlloc PROTO :DWORD,:DWORD,:DWORD
LocalShrink PROTO :DWORD,:DWORD
LocalSize PROTO :DWORD
LocalUnlock PROTO :DWORD
LockFile PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LockFileEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LockResource PROTO :DWORD
MapUserPhysicalPages PROTO :DWORD,:DWORD,:DWORD
MapUserPhysicalPagesScatter PROTO :DWORD,:DWORD,:DWORD
MapViewOfFile PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MapViewOfFileEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
Module32First PROTO :DWORD,:DWORD
Module32FirstW PROTO :DWORD,:DWORD
Module32Next PROTO :DWORD,:DWORD
Module32NextW PROTO :DWORD,:DWORD
MoveFileA PROTO :DWORD,:DWORD
MoveFile equ <MoveFileA>

MoveFileExA PROTO :DWORD,:DWORD,:DWORD
MoveFileEx equ <MoveFileExA>

MoveFileExW PROTO :DWORD,:DWORD,:DWORD
MoveFileW PROTO :DWORD,:DWORD
MoveFileWithProgressA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MoveFileWithProgress equ <MoveFileWithProgressA>

MoveFileWithProgressW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MulDiv PROTO :DWORD,:DWORD,:DWORD
MultiByteToWideChar PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
NumaVirtualQueryNode PROTO :DWORD,:DWORD,:DWORD,:DWORD
OpenEventA PROTO :DWORD,:DWORD,:DWORD
OpenEvent equ <OpenEventA>

OpenEventW PROTO :DWORD,:DWORD,:DWORD
OpenFile PROTO :DWORD,:DWORD,:DWORD
OpenFileMappingA PROTO :DWORD,:DWORD,:DWORD
OpenFileMapping equ <OpenFileMappingA>

OpenFileMappingW PROTO :DWORD,:DWORD,:DWORD
OpenJobObjectA PROTO :DWORD,:DWORD,:DWORD
OpenJobObject equ <OpenJobObjectA>

OpenJobObjectW PROTO :DWORD,:DWORD,:DWORD
OpenMutexA PROTO :DWORD,:DWORD,:DWORD
OpenMutex equ <OpenMutexA>

OpenMutexW PROTO :DWORD,:DWORD,:DWORD
OpenProcess PROTO :DWORD,:DWORD,:DWORD
OpenSemaphoreA PROTO :DWORD,:DWORD,:DWORD
OpenSemaphore equ <OpenSemaphoreA>

OpenSemaphoreW PROTO :DWORD,:DWORD,:DWORD
OpenThread PROTO :DWORD,:DWORD,:DWORD
OpenWaitableTimerA PROTO :DWORD,:DWORD,:DWORD
OpenWaitableTimer equ <OpenWaitableTimerA>

OpenWaitableTimerW PROTO :DWORD,:DWORD,:DWORD
OutputDebugStringA PROTO :DWORD
OutputDebugString equ <OutputDebugStringA>

OutputDebugStringW PROTO :DWORD
PeekConsoleInputA PROTO :DWORD,:DWORD,:DWORD,:DWORD
PeekConsoleInput equ <PeekConsoleInputA>

PeekConsoleInputW PROTO :DWORD,:DWORD,:DWORD,:DWORD
PeekNamedPipe PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
PostQueuedCompletionStatus PROTO :DWORD,:DWORD,:DWORD,:DWORD
PrepareTape PROTO :DWORD,:DWORD,:DWORD
Process32First PROTO :DWORD,:DWORD
Process32FirstW PROTO :DWORD,:DWORD
Process32Next PROTO :DWORD,:DWORD
Process32NextW PROTO :DWORD,:DWORD
ProcessIdToSessionId PROTO :DWORD,:DWORD
PulseEvent PROTO :DWORD
PurgeComm PROTO :DWORD,:DWORD
QueryActCtxW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
QueryDepthSList PROTO :DWORD
QueryDosDeviceA PROTO :DWORD,:DWORD,:DWORD
QueryDosDevice equ <QueryDosDeviceA>

QueryDosDeviceW PROTO :DWORD,:DWORD,:DWORD
QueryInformationJobObject PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
QueryMemoryResourceNotification PROTO :DWORD,:DWORD
QueryPerformanceCounter PROTO :DWORD
QueryPerformanceFrequency PROTO :DWORD
QueueUserAPC PROTO :DWORD,:DWORD,:DWORD
QueueUserWorkItem PROTO :DWORD,:DWORD,:DWORD
RaiseException PROTO :DWORD,:DWORD,:DWORD,:DWORD
ReadConsoleA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadConsole equ <ReadConsoleA>

ReadConsoleInputA PROTO :DWORD,:DWORD,:DWORD,:DWORD
ReadConsoleInput equ <ReadConsoleInputA>

ReadConsoleInputW PROTO :DWORD,:DWORD,:DWORD,:DWORD
ReadConsoleOutputA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadConsoleOutput equ <ReadConsoleOutputA>

ReadConsoleOutputAttribute PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadConsoleOutputCharacterA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadConsoleOutputCharacter equ <ReadConsoleOutputCharacterA>

ReadConsoleOutputCharacterW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadConsoleOutputW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadConsoleW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadDirectoryChangesW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadFile PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadFileEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadFileScatter PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadProcessMemory PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegisterWaitForSingleObject PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RegisterWaitForSingleObjectEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReleaseActCtx PROTO :DWORD
ReleaseMutex PROTO :DWORD
ReleaseSemaphore PROTO :DWORD,:DWORD,:DWORD
RemoveDirectoryA PROTO :DWORD
RemoveDirectory equ <RemoveDirectoryA>

RemoveDirectoryW PROTO :DWORD
RemoveLocalAlternateComputerNameA PROTO :DWORD,:DWORD
RemoveLocalAlternateComputerName equ <RemoveLocalAlternateComputerNameA>

RemoveLocalAlternateComputerNameW PROTO :DWORD,:DWORD
RemoveVectoredExceptionHandler PROTO :DWORD
ReplaceFileA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReplaceFile equ <ReplaceFileA>

ReplaceFileW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
RequestDeviceWakeup PROTO :DWORD
RequestWakeupLatency PROTO :DWORD
ResetEvent PROTO :DWORD
ResetWriteWatch PROTO :DWORD,:DWORD
RestoreLastError PROTO :DWORD
ResumeThread PROTO :DWORD
RtlCaptureContext PROTO :DWORD
RtlCaptureStackBackTrace PROTO :DWORD,:DWORD,:DWORD,:DWORD
RtlFillMemory PROTO :DWORD,:DWORD,:DWORD
RtlMoveMemory PROTO :DWORD,:DWORD,:DWORD
RtlUnwind PROTO :DWORD,:DWORD,:DWORD,:DWORD
RtlZeroMemory PROTO :DWORD,:DWORD
ScrollConsoleScreenBufferA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ScrollConsoleScreenBuffer equ <ScrollConsoleScreenBufferA>

ScrollConsoleScreenBufferW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SearchPathA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SearchPath equ <SearchPathA>

SearchPathW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetCalendarInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetCalendarInfo equ <SetCalendarInfoA>

SetCalendarInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetCommBreak PROTO :DWORD
SetCommConfig PROTO :DWORD,:DWORD,:DWORD
SetCommMask PROTO :DWORD,:DWORD
SetCommState PROTO :DWORD,:DWORD
SetCommTimeouts PROTO :DWORD,:DWORD
SetComputerNameA PROTO :DWORD
SetComputerName equ <SetComputerNameA>

SetComputerNameExA PROTO :DWORD,:DWORD
SetComputerNameEx equ <SetComputerNameExA>

SetComputerNameExW PROTO :DWORD,:DWORD
SetComputerNameW PROTO :DWORD
SetConsoleActiveScreenBuffer PROTO :DWORD
SetConsoleCP PROTO :DWORD
SetConsoleCtrlHandler PROTO :DWORD,:DWORD
SetConsoleCursor PROTO :DWORD,:DWORD
SetConsoleCursorInfo PROTO :DWORD,:DWORD
SetConsoleCursorPosition PROTO :DWORD,:DWORD
SetConsoleMode PROTO :DWORD,:DWORD
SetConsoleOutputCP PROTO :DWORD
SetConsoleScreenBufferSize PROTO :DWORD,:DWORD
SetConsoleTextAttribute PROTO :DWORD,:DWORD
SetConsoleTitleA PROTO :DWORD
SetConsoleTitle equ <SetConsoleTitleA>

SetConsoleTitleW PROTO :DWORD
SetConsoleWindowInfo PROTO :DWORD,:DWORD,:DWORD
SetCriticalSectionSpinCount PROTO :DWORD,:DWORD
SetCurrentDirectoryA PROTO :DWORD
SetCurrentDirectory equ <SetCurrentDirectoryA>

SetCurrentDirectoryW PROTO :DWORD
SetDefaultCommConfigA PROTO :DWORD,:DWORD,:DWORD
SetDefaultCommConfig equ <SetDefaultCommConfigA>

SetDefaultCommConfigW PROTO :DWORD,:DWORD,:DWORD
SetDllDirectoryA PROTO :DWORD
SetDllDirectory equ <SetDllDirectoryA>

SetDllDirectoryW PROTO :DWORD
SetEndOfFile PROTO :DWORD
SetEnvironmentVariableA PROTO :DWORD,:DWORD
SetEnvironmentVariable equ <SetEnvironmentVariableA>

SetEnvironmentVariableW PROTO :DWORD,:DWORD
SetErrorMode PROTO :DWORD
SetEvent PROTO :DWORD
SetFileApisToANSI PROTO 
SetFileApisToOEM PROTO 
SetFileAttributesA PROTO :DWORD,:DWORD
SetFileAttributes equ <SetFileAttributesA>

SetFileAttributesW PROTO :DWORD,:DWORD
SetFilePointer PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetFilePointerEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetFileShortNameA PROTO :DWORD,:DWORD
SetFileShortName equ <SetFileShortNameA>

SetFileShortNameW PROTO :DWORD,:DWORD
SetFileTime PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetFileValidData PROTO :DWORD,:DWORD,:DWORD
SetFirmwareEnvironmentVariableA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetFirmwareEnvironmentVariable equ <SetFirmwareEnvironmentVariableA>

SetFirmwareEnvironmentVariableW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetHandleCount PROTO :DWORD
SetHandleInformation PROTO :DWORD,:DWORD,:DWORD
SetInformationJobObject PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetLastError PROTO :DWORD
SetLocalPrimaryComputerNameA PROTO :DWORD,:DWORD
SetLocalPrimaryComputerName equ <SetLocalPrimaryComputerNameA>

SetLocalPrimaryComputerNameW PROTO :DWORD,:DWORD
SetLocalTime PROTO :DWORD
SetLocaleInfoA PROTO :DWORD,:DWORD,:DWORD
SetLocaleInfo equ <SetLocaleInfoA>

SetLocaleInfoW PROTO :DWORD,:DWORD,:DWORD
SetMailslotInfo PROTO :DWORD,:DWORD
SetMessageWaitingIndicator PROTO :DWORD,:DWORD
SetNamedPipeHandleState PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetPriorityClass PROTO :DWORD,:DWORD
SetProcessAffinityMask PROTO :DWORD,:DWORD
SetProcessPriorityBoost PROTO :DWORD,:DWORD
SetProcessShutdownParameters PROTO :DWORD,:DWORD
SetProcessWorkingSetSize PROTO :DWORD,:DWORD,:DWORD
SetStdHandle PROTO :DWORD,:DWORD
SetSystemPowerState PROTO :DWORD,:DWORD
SetSystemTime PROTO :DWORD
SetSystemTimeAdjustment PROTO :DWORD,:DWORD
SetTapeParameters PROTO :DWORD,:DWORD,:DWORD
SetTapePosition PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetThreadAffinityMask PROTO :DWORD,:DWORD
SetThreadContext PROTO :DWORD,:DWORD
SetThreadExecutionState PROTO :DWORD
SetThreadIdealProcessor PROTO :DWORD,:DWORD
SetThreadLocale PROTO :DWORD
SetThreadPriority PROTO :DWORD,:DWORD
SetThreadPriorityBoost PROTO :DWORD,:DWORD
SetTimeZoneInformation PROTO :DWORD
SetTimerQueueTimer PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetUnhandledExceptionFilter PROTO :DWORD
SetUserGeoID PROTO :DWORD
SetVolumeLabelA PROTO :DWORD,:DWORD
SetVolumeLabel equ <SetVolumeLabelA>

SetVolumeLabelW PROTO :DWORD,:DWORD
SetVolumeMountPointA PROTO :DWORD,:DWORD
SetVolumeMountPoint equ <SetVolumeMountPointA>

SetVolumeMountPointW PROTO :DWORD,:DWORD
SetWaitableTimer PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetupComm PROTO :DWORD,:DWORD,:DWORD
SignalObjectAndWait PROTO :DWORD,:DWORD,:DWORD,:DWORD
SizeofResource PROTO :DWORD,:DWORD
Sleep PROTO :DWORD
SleepEx PROTO :DWORD,:DWORD
SuspendThread PROTO :DWORD
SwitchToFiber PROTO :DWORD
SwitchToThread PROTO 
SystemTimeToFileTime PROTO :DWORD,:DWORD
SystemTimeToTzSpecificLocalTime PROTO :DWORD,:DWORD,:DWORD
TerminateJobObject PROTO :DWORD,:DWORD
TerminateProcess PROTO :DWORD,:DWORD
TerminateThread PROTO :DWORD,:DWORD
Thread32First PROTO :DWORD,:DWORD
Thread32Next PROTO :DWORD,:DWORD
TlsAlloc PROTO 
TlsFree PROTO :DWORD
TlsGetValue PROTO :DWORD
TlsSetValue PROTO :DWORD,:DWORD
Toolhelp32ReadProcessMemory PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
TransactNamedPipe PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
TransmitCommChar PROTO :DWORD,:DWORD
TryEnterCriticalSection PROTO :DWORD
TzSpecificLocalTimeToSystemTime PROTO :DWORD,:DWORD,:DWORD
UnhandledExceptionFilter PROTO :DWORD
UnlockFile PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UnlockFileEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UnmapViewOfFile PROTO :DWORD
UnregisterWait PROTO :DWORD
UnregisterWaitEx PROTO :DWORD,:DWORD
UpdateResourceA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UpdateResource equ <UpdateResourceA>

UpdateResourceW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VerLanguageNameA PROTO :DWORD,:DWORD,:DWORD
VerLanguageName equ <VerLanguageNameA>

VerLanguageNameW PROTO :DWORD,:DWORD,:DWORD
VerSetConditionMask PROTO :DWORD,:DWORD,:DWORD,:DWORD
VerifyVersionInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD
VerifyVersionInfo equ <VerifyVersionInfoA>

VerifyVersionInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD
VirtualAlloc PROTO :DWORD,:DWORD,:DWORD,:DWORD
VirtualAllocEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VirtualFree PROTO :DWORD,:DWORD,:DWORD
VirtualFreeEx PROTO :DWORD,:DWORD,:DWORD,:DWORD
VirtualLock PROTO :DWORD,:DWORD
VirtualProtect PROTO :DWORD,:DWORD,:DWORD,:DWORD
VirtualProtectEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
VirtualQuery PROTO :DWORD,:DWORD,:DWORD
VirtualQueryEx PROTO :DWORD,:DWORD,:DWORD,:DWORD
VirtualUnlock PROTO :DWORD,:DWORD
WTSGetActiveConsoleSessionId PROTO 
WaitCommEvent PROTO :DWORD,:DWORD,:DWORD
WaitForDebugEvent PROTO :DWORD,:DWORD
WaitForMultipleObjects PROTO :DWORD,:DWORD,:DWORD,:DWORD
WaitForMultipleObjectsEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WaitForSingleObject PROTO :DWORD,:DWORD
WaitForSingleObjectEx PROTO :DWORD,:DWORD,:DWORD
WaitNamedPipeA PROTO :DWORD,:DWORD
WaitNamedPipe equ <WaitNamedPipeA>

WaitNamedPipeW PROTO :DWORD,:DWORD
WideCharToMultiByte PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WinExec PROTO :DWORD,:DWORD
WriteConsoleA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteConsole equ <WriteConsoleA>

WriteConsoleInputA PROTO :DWORD,:DWORD,:DWORD,:DWORD
WriteConsoleInput equ <WriteConsoleInputA>

WriteConsoleInputW PROTO :DWORD,:DWORD,:DWORD,:DWORD
WriteConsoleOutputA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteConsoleOutput equ <WriteConsoleOutputA>

WriteConsoleOutputAttribute PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteConsoleOutputCharacterA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteConsoleOutputCharacter equ <WriteConsoleOutputCharacterA>

WriteConsoleOutputCharacterW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteConsoleOutputW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteConsoleW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteFile PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteFileEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteFileGather PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WritePrivateProfileSectionA PROTO :DWORD,:DWORD,:DWORD
WritePrivateProfileSection equ <WritePrivateProfileSectionA>

WritePrivateProfileSectionW PROTO :DWORD,:DWORD,:DWORD
WritePrivateProfileStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD
WritePrivateProfileString equ <WritePrivateProfileStringA>

WritePrivateProfileStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD
WritePrivateProfileStructA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WritePrivateProfileStruct equ <WritePrivateProfileStructA>

WritePrivateProfileStructW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteProcessMemory PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteProfileSectionA PROTO :DWORD,:DWORD
WriteProfileSection equ <WriteProfileSectionA>

WriteProfileSectionW PROTO :DWORD,:DWORD
WriteProfileStringA PROTO :DWORD,:DWORD,:DWORD
WriteProfileString equ <WriteProfileStringA>

WriteProfileStringW PROTO :DWORD,:DWORD,:DWORD
WriteTapemark PROTO :DWORD,:DWORD,:DWORD,:DWORD
ZombifyActCtx PROTO :DWORD
_hread PROTO :DWORD,:DWORD,:DWORD
_hwrite PROTO :DWORD,:DWORD,:DWORD
_lclose PROTO :DWORD
_lcreat PROTO :DWORD,:DWORD
_llseek PROTO :DWORD,:DWORD,:DWORD
_lopen PROTO :DWORD,:DWORD
_lread PROTO :DWORD,:DWORD,:DWORD
_lwrite PROTO :DWORD,:DWORD,:DWORD
lstrcatA PROTO :DWORD,:DWORD
lstrcat equ <lstrcatA>

lstrcatW PROTO :DWORD,:DWORD
lstrcmpA PROTO :DWORD,:DWORD
lstrcmp equ <lstrcmpA>

lstrcmpW PROTO :DWORD,:DWORD
lstrcmpiA PROTO :DWORD,:DWORD
lstrcmpi equ <lstrcmpiA>

lstrcmpiW PROTO :DWORD,:DWORD
lstrcpyA PROTO :DWORD,:DWORD
lstrcpy equ <lstrcpyA>

lstrcpyW PROTO :DWORD,:DWORD
lstrcpynA PROTO :DWORD,:DWORD,:DWORD
lstrcpyn equ <lstrcpynA>

lstrcpynW PROTO :DWORD,:DWORD,:DWORD
lstrlenA PROTO :DWORD
lstrlen equ <lstrlenA>

lstrlenW PROTO :DWORD

ELSE
echo -----------------------------------------
echo WARNING Duplicate include file kernel32.inc
echo -----------------------------------------
ENDIF
