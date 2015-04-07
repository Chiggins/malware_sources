#pragma once

#define RtlOffsetToPointer(B,O) ((PCHAR)(((PCHAR)(B))+((ULONG_PTR)(O))))

#define InitializeObjectAttributes( p,n,a,r,s ){ \
	(p)->Length=sizeof( OBJECT_ATTRIBUTES );          \
	(p)->RootDirectory=r;                             \
	(p)->Attributes=a;                                \
	(p)->ObjectName=n;                                \
	(p)->SecurityDescriptor=s;                        \
	(p)->SecurityQualityOfService=NULL;               \
}

#define NT_SUCCESS(STATUS) (((NTSTATUS)(STATUS))>=0)

typedef short CSHORT;

typedef struct _UNICODE_STRING{
	USHORT Length;
	USHORT MaximumLength;
	PWSTR Buffer;
}UNICODE_STRING,*PUNICODE_STRING;

typedef struct _STRING{
	USHORT Length;
	USHORT MaximumLength;
	PCHAR Buffer;
}STRING;
typedef STRING *PSTRING;

typedef struct _CSTRING{
	USHORT Length;
	USHORT MaximumLength;
	CONST char *Buffer;
}CSTRING;

typedef CSTRING *PCSTRING;
typedef STRING CANSI_STRING;
typedef STRING ANSI_STRING;
typedef PSTRING PCANSI_STRING;
typedef PSTRING PANSI_STRING;

#define RTL_CONSTANT_STRING(s){sizeof(s)-sizeof((s)[0]),sizeof(s),s}

typedef struct _OBJECT_ATTRIBUTES{
	ULONG Length;
	HANDLE RootDirectory;
	PUNICODE_STRING ObjectName;
	ULONG Attributes;
	PVOID SecurityDescriptor;
	PVOID SecurityQualityOfService;
}OBJECT_ATTRIBUTES,*POBJECT_ATTRIBUTES;

typedef struct _CLIENT_ID
{
	HANDLE UniqueProcess;
	HANDLE UniqueThread;
}CLIENT_ID,*PCLIENT_ID;

typedef struct _CLIENT_ID64
{
	DWORD64 UniqueProcess;
	DWORD64 UniqueThread;
}CLIENT_ID64,*PCLIENT_ID64;

typedef struct{
	ULONG Length; 
	ULONG Unknown1; 
	ULONG Unknown2; 
	PCLIENT_ID pcidClient;
	ULONG Unknown4; 
	ULONG Unknown5; 
	ULONG Unknown6; 
	PULONG InitialTeb; 
	ULONG Unknown8; 
}THREAD_UNKNOWN,*PTHREAD_UNKNOWN;

typedef struct{
	ULONG Length; 
	ULONG Unknown1; 
	ULONG Unknown2; 
	PWSTR pwsImageFileName;
	ULONG Unknown4;
	ULONG Unknown5; 
	ULONG Unknown6; 
	PCLIENT_ID pcidClient;
	ULONG Unknown8; 
	ULONG Unknown9; 
	ULONG Unknown10; 
	ULONG Unknown11; 
	ULONG Unknown12; 
	ULONG Unknown13;
	ULONG Unknown14; 
	ULONG Unknown15; 
	ULONG Unknown16;
}PROCESS_UNKNOWN,*PPROCESS_UNKNOWN;

#define INITIAL_ALLOCATION 0x100
typedef BOOL (__stdcall *PFNISWOW64PROCESS)(HANDLE,PBOOL);

typedef LONG KPRIORITY;

typedef struct _VM_COUNTERS
{
	SIZE_T PeakVirtualSize;
	SIZE_T VirtualSize;
	ULONG PageFaultCount;
	SIZE_T PeakWorkingSetSize;
	SIZE_T WorkingSetSize;
	SIZE_T QuotaPeakPagedPoolUsage;
	SIZE_T QuotaPagedPoolUsage;
	SIZE_T QuotaPeakNonPagedPoolUsage;
	SIZE_T QuotaNonPagedPoolUsage;
	SIZE_T PagefileUsage;
	SIZE_T PeakPagefileUsage;
}VM_COUNTERS;

typedef enum _KWAIT_REASON
{
	Executive,
	FreePage,
	PageIn,
	PoolAllocation,
	DelayExecution,
	Suspended,
	UserRequest,
	WrExecutive,
	WrFreePage,
	WrPageIn,
	WrPoolAllocation,
	WrDelayExecution,
	WrSuspended,
	WrUserRequest,
	WrEventPair,
	WrQueue,
	WrLpcReceive,
	WrLpcReply,
	WrVirtualMemory,
	WrPageOut,
	WrRendezvous,
	Spare2,
	Spare3,
	Spare4,
	Spare5,
	Spare6,
	WrKernel,
	WrResource,
	WrPushLock,
	WrMutex,
	WrQuantumEnd,
	WrDispatchInt,
	WrPreempted,
	WrYieldExecution,
	MaximumWaitReason
}KWAIT_REASON;

enum SYSTEMINFOCLASS{
	SystemBasicInformation=0,
	SystemProcessesAndThreadsInformation=5,
	SystemConfigurationInformation=7,
	SystemGlobalFlagInformation=9,
	SystemModuleInformation=11,
	SystemHandleInformation=16,
	SystemObjectInformation=17,
	SystemLoadImage=26,
	SystemUnloadImage=27,
	SystemLoadAndCallImage=38
};

enum THREAD_STATE
{
	StateInitialized,
	StateReady,
	StateRunning,
	StateStandby,
	StateTerminated,
	StateWait,
	StateTransition
};

struct SYSTEM_THREADS
{
	LARGE_INTEGER KernelTime;
	LARGE_INTEGER UserTime;
	LARGE_INTEGER CreateTime;
	ULONG WaitTime;
	LPVOID StartAddress;
	CLIENT_ID ClientId;
	KPRIORITY Prioryty;
	KPRIORITY BasePrioryty;
	ULONG ContextSwitchCount;
	THREAD_STATE State;
	KWAIT_REASON WaitReason;
	ULONG Aligment;
};

#pragma warning(disable:4200)
#ifdef _WIN64
struct SYSTEM_PROCESSES
{
	ULONG			NextEntryDelta;
	ULONG			ThreadCount;
	ULONG			Inknown0[6];
	LARGE_INTEGER	CreateTime;
	LARGE_INTEGER	UserTime;
	LARGE_INTEGER	KernelTime;
	UNICODE_STRING	ProcessName;
	KPRIORITY		BasePrioryty;
	HANDLE			ProcessId;
	HANDLE			InheritedFromProcessId;
	ULONG			HandleCount;
	ULONG			Unknown1[4];
	ULONG			PrivatePageCount;
	VM_COUNTERS		VmCounters;
	IO_COUNTERS		IoCounters;
	SYSTEM_THREADS	Threads[];
};
#else
struct SYSTEM_PROCESSES
{
	ULONG			NextEntryDelta;
	ULONG			ThreadCount;
	ULONG			Inknown0[6];
	LARGE_INTEGER	CreateTime;
	LARGE_INTEGER	UserTime;
	LARGE_INTEGER	KernelTime;
	UNICODE_STRING	ProcessName;
	KPRIORITY		BasePrioryty;
	HANDLE			ProcessId;
	HANDLE			InheritedFromProcessId;
	ULONG			HandleCount;
	ULONG			Unknown1[2];
	ULONG			PrivatePageCount;
	VM_COUNTERS		VmCounters;
	IO_COUNTERS		IoCounters;
	SYSTEM_THREADS	Threads[];
};
#endif

typedef struct _SYSTEM_MODULE_INFORMATION 
{
	LPVOID R[2];
	LPVOID Base;
	ULONG Size;
	ULONG Flags;
	USHORT Index;
	USHORT U;
	USHORT LoadCount;
	USHORT ModuleNameOffset;
	char ImageName[256];
}SYSTEM_MODULE_INFORMATION,*PSYSTEM_MODULE_INFORMATION;

typedef struct _SMI
{
	ULONG Num;
	SYSTEM_MODULE_INFORMATION smi[];
}SMI,*PSMI;

#pragma warning(default:4200)

typedef struct _QUERY_SYSTEM_INFORMATION
{
	ULONG ProcessId;
	UCHAR ObjectTypeNumber;
	UCHAR Flags;
	USHORT Handle;
	LPVOID Object;
	ACCESS_MASK GrantedAccess;
}QUERY_SYSTEM_INFORMATION,*PQUERY_SYSTEM_INFORMATION;

typedef enum _THREADINFOCLASS
{
	ThreadBasicInformation,
	ThreadTimes,
	ThreadPriority,
	ThreadBasePriority,
	ThreadAffinityMask,
	ThreadImpersonationToken,
	ThreadDescriptorTableEntry,
	ThreadEnableAlignmentFaultFixup,
	ThreadEventPair_Reusable,
	ThreadQuerySetWin32StartAddress,
	ThreadZeroTlsCell,
	ThreadPerformanceCount,
	ThreadAmILastThread,
	ThreadIdealProcessor,
	ThreadPriorityBoost,
	ThreadSetTlsArrayAddress,
	ThreadIsIoPending,
	ThreadHideFromDebugger,
	ThreadBreakOnTermination,
	MaxThreadInfoClass
}THREADINFOCLASS;

typedef struct _THREAD_BASIC_INFORMATION
{
	DWORD ExitStatus;
	PVOID TebBaseAddress;
	CLIENT_ID ClientId;
	PVOID AffinityMask;
	PVOID Priority;
	PVOID BasePriority;
}THREAD_BASIC_INFORMATION,*PTHREAD_BASIC_INFORMATION;

typedef enum _PROCESSINFOCLASS{
	ProcessBasicInformation,
	ProcessQuotaLimits,
	ProcessIoCounters,
	ProcessVmCounters,
	ProcessTimes,
	ProcessBasePriority,
	ProcessRaisePriority,
	ProcessDebugPort,
	ProcessExceptionPort,
	ProcessAccessToken,
	ProcessLdtInformation,
	ProcessLdtSize,
	ProcessDefaultHardErrorMode,
	ProcessIoPortHandlers,
	ProcessPooledUsageAndLimits,
	ProcessWorkingSetWatch,
	ProcessUserModeIOPL,
	ProcessEnableAlignmentFaultFixup,
	ProcessPriorityClass,
	ProcessWx86Information,
	ProcessHandleCount,
	ProcessAffinityMask,
	ProcessPriorityBoost,
	ProcessDeviceMap,
	ProcessSessionInformation,
	ProcessForegroundInformation,
	ProcessWow64Information,
	ProcessImageFileName,
	ProcessLUIDDeviceMapsEnabled,
	ProcessBreakOnTermination,
	ProcessDebugObjectHandle,
	ProcessDebugFlags,
	ProcessHandleTracing,
	MaxProcessInfoClass
}PROCESSINFOCLASS;

#ifdef BUILD_WIN64
#define USE_LPC6432
#else
#undef USE_LPC6432
#endif

#if defined(USE_LPC6432)
#define LPC_CLIENT_ID CLIENT_ID64
#define LPC_SIZE_T DWORD64
#define LPC_PVOID DWORD64
#define LPC_HANDLE DWORD64
#else
#define LPC_CLIENT_ID CLIENT_ID
#define LPC_SIZE_T SIZE_T
#define LPC_PVOID PVOID
#define LPC_HANDLE HANDLE
#endif

typedef struct _PORT_MESSAGE{
	union{
		struct{
			CSHORT DataLength;
			CSHORT TotalLength;
		}s1;
		ULONG Length;
	}u1;
	union{
		struct{
			CSHORT Type;
			CSHORT DataInfoOffset;
		}s2;
		ULONG ZeroInit;
	}u2;
	union{
		LPC_CLIENT_ID ClientId;
		double DoNotUseThisField;
	};
	ULONG MessageId;
	union{
		LPC_SIZE_T ClientViewSize;
		ULONG CallbackId;
	};
}PORT_MESSAGE,*PPORT_MESSAGE;

typedef struct _PORT_VIEW{
	ULONG Length;
	LPC_HANDLE SectionHandle;
	ULONG SectionOffset;
	LPC_SIZE_T ViewSize;
	LPC_PVOID ViewBase;
	LPC_PVOID ViewRemoteBase;
}PORT_VIEW,*PPORT_VIEW;

typedef struct _REMOTE_PORT_VIEW{
	ULONG Length;
	LPC_SIZE_T ViewSize;
	LPC_PVOID ViewBase;
}REMOTE_PORT_VIEW,*PREMOTE_PORT_VIEW;

enum LPC_TYPE
{
	LPC_NEW_MESSAGE,
	LPC_REQUEST,
	LPC_REPLY,
	LPC_DATAGRAM,
	LPC_LOST_REPLAY,
	LPC_PORT_CLOSED,
	LPC_CLIENT_DIED,
	LPC_EXCEPTION,
	LPC_DEBUG_EVENT,
	LPC_ERROR_EVENT,
	LPC_CONNECTION_REQUEST
};

#define SE_MIN_WELL_KNOWN_PRIVILEGE (2L)
#define SE_CREATE_TOKEN_PRIVILEGE (2L)
#define SE_ASSIGNPRIMARYTOKEN_PRIVILEGE (3L)
#define SE_LOCK_MEMORY_PRIVILEGE (4L)
#define SE_INCREASE_QUOTA_PRIVILEGE (5L)
#define SE_MACHINE_ACCOUNT_PRIVILEGE (6L)
#define SE_TCB_PRIVILEGE (7L)
#define SE_SECURITY_PRIVILEGE (8L)
#define SE_TAKE_OWNERSHIP_PRIVILEGE (9L)
#define SE_LOAD_DRIVER_PRIVILEGE (10L)
#define SE_SYSTEM_PROFILE_PRIVILEGE (11L)
#define SE_SYSTEMTIME_PRIVILEGE (12L)
#define SE_PROF_SINGLE_PROCESS_PRIVILEGE (13L)
#define SE_INC_BASE_PRIORITY_PRIVILEGE (14L)
#define SE_CREATE_PAGEFILE_PRIVILEGE (15L)
#define SE_CREATE_PERMANENT_PRIVILEGE (16L)
#define SE_BACKUP_PRIVILEGE (17L)
#define SE_RESTORE_PRIVILEGE (18L)
#define SE_SHUTDOWN_PRIVILEGE (19L)
#define SE_DEBUG_PRIVILEGE (20L)
#define SE_AUDIT_PRIVILEGE (21L)
#define SE_SYSTEM_ENVIRONMENT_PRIVILEGE (22L)
#define SE_CHANGE_NOTIFY_PRIVILEGE (23L)
#define SE_REMOTE_SHUTDOWN_PRIVILEGE (24L)
#define SE_UNDOCK_PRIVILEGE (25L)
#define SE_SYNC_AGENT_PRIVILEGE (26L)
#define SE_ENABLE_DELEGATION_PRIVILEGE (27L)
#define SE_MANAGE_VOLUME_PRIVILEGE (28L)
#define SE_IMPERSONATE_PRIVILEGE (29L)
#define SE_CREATE_GLOBAL_PRIVILEGE (30L)
#define SE_TRUSTED_CREDMAN_ACCESS_PRIVILEGE (31L)
#define SE_RELABEL_PRIVILEGE (32L)
#define SE_INC_WORKING_SET_PRIVILEGE (33L)
#define SE_TIME_ZONE_PRIVILEGE (34L)
#define SE_CREATE_SYMBOLIC_LINK_PRIVILEGE (35L)
#define SE_MAX_WELL_KNOWN_PRIVILEGE (SE_CREATE_SYMBOLIC_LINK_PRIVILEGE)

#define FILE_SYNCHRONOUS_IO_ALERT 0x00000010
#define OBJ_INHERIT 0x00000002L

#define FILE_PIPE_BYTE_STREAM_TYPE 0x00000000
#define FILE_PIPE_MESSAGE_MODE 0x00000001
#define FILE_PIPE_BYTE_STREAM_MODE 0x00000000
#define FILE_PIPE_MESSAGE_TYPE 0x00000001
#define FILE_PIPE_QUEUE_OPERATION 0x00000000

#define FILE_OPEN_IF 0x00000003

typedef struct _IO_STATUS_BLOCK
{
	union{
		NTSTATUS Status;
		PVOID Pointer;
	}DUMMYUNIONNAME;
	ULONG_PTR Information;
}IO_STATUS_BLOCK,*PIO_STATUS_BLOCK;

typedef VOID (NTAPI *PIO_APC_ROUTINE)(PVOID ApcContext,PIO_STATUS_BLOCK IoStatusBlock,ULONG Reserved);

#define OBJ_CASE_INSENSITIVE 0x00000040L
#define OBJ_KERNEL_HANDLE 0x00000200L

#define SectionNameInformation (2L)

typedef struct _RTLFRAME
{
	LPCVOID UserData;
	_RTLFRAME* PreviousFrame;
}RTLFRAME,*PRTLFRAME;

typedef struct _OBJECT_NAME_INFORMATION
{
	UNICODE_STRING Name;
}OBJECT_NAME_INFORMATION,*POBJECT_NAME_INFORMATION;

typedef enum _FILE_INFORMATION_CLASS
{
	FileDirectoryInformation=1,
	FileFullDirectoryInformation,
	FileBothDirectoryInformation,
	FileBasicInformation,
	FileStandardInformation,
	FileInternalInformation,
	FileEaInformation,
	FileAccessInformation,
	FileNameInformation,
	FileRenameInformation,
	FileLinkInformation,
	FileNamesInformation,
	FileDispositionInformation,
	FilePositionInformation,
	FileFullEaInformation,
	FileModeInformation,
	FileAlignmentInformation,
	FileAllInformation,
	FileAllocationInformation,
	FileEndOfFileInformation,
	FileAlternateNameInformation,
	FileStreamInformation,
	FilePipeInformation,
	FilePipeLocalInformation,
	FilePipeRemoteInformation,
	FileMailslotQueryInformation,
	FileMailslotSetInformation,
	FileCompressionInformation,
	FileObjectIdInformation,
	FileCompletionInformation,
	FileMoveClusterInformation,
	FileQuotaInformation,
	FileReparsePointInformation,
	FileNetworkOpenInformation,
	FileAttributeTagInformation,
	FileTrackingInformation,
	FileIdBothDirectoryInformation,
	FileIdFullDirectoryInformation,
	FileValidDataLengthInformation,
	FileShortNameInformation,
	FileIoCompletionNotificationInformation,
	FileIoStatusBlockRangeInformation,
	FileIoPriorityHintInformation,
	FileSfioReserveInformation,
	FileSfioVolumeInformation,
	FileHardLinkInformation,
	FileProcessIdsUsingFileInformation,
	FileNormalizedNameInformation,
	FileNetworkPhysicalNameInformation,
	FileIdGlobalTxDirectoryInformation,
	FileMaximumInformation
}FILE_INFORMATION_CLASS,*PFILE_INFORMATION_CLASS;

typedef struct _FILE_DISPOSITION_INFORMATION{
	BOOLEAN DeleteFile;
}FILE_DISPOSITION_INFORMATION,*PFILE_DISPOSITION_INFORMATION;

typedef struct _FILE_RENAME_INFORMATION
{
	BOOLEAN ReplaceIfExists;
	HANDLE RootDirectory;
	ULONG FileNameLength;
	WCHAR FileName[1];
}FILE_RENAME_INFORMATION,*PFILE_RENAME_INFORMATION;

typedef struct _FILE_NAME_INFORMATION
{
	ULONG FileNameLength;
	WCHAR FileName[1];
}FILE_NAME_INFORMATION,*PFILE_NAME_INFORMATION;

typedef enum _KEY_VALUE_INFORMATION_CLASS
{
	KeyValueBasicInformation,
	KeyValueFullInformation,
	KeyValuePartialInformation,
	KeyValueFullInformationAlign64,
	KeyValuePartialInformationAlign64,
	MaxKeyValueInfoClass
}KEY_VALUE_INFORMATION_CLASS;

#define RTL_REGISTRY_ABSOLUTE 0
#define RTL_REGISTRY_SERVICES 1
#define RTL_REGISTRY_CONTROL 2
#define RTL_REGISTRY_WINDOWS_NT 3
#define RTL_REGISTRY_DEVICEMAP 4
#define RTL_REGISTRY_USER 5
#define RTL_REGISTRY_MAXIMUM 6
#define RTL_REGISTRY_HANDLE 0x40000000
#define RTL_REGISTRY_OPTIONAL 0x80000000

typedef struct _KEY_VALUE_PARTIAL_INFORMATION
{
	ULONG TitleIndex;
	ULONG Type;
	ULONG DataLength;
	UCHAR Data[1];
}KEY_VALUE_PARTIAL_INFORMATION,*PKEY_VALUE_PARTIAL_INFORMATION;

typedef struct _KEY_VALUE_BASIC_INFORMATION
{
	ULONG TitleIndex;
	ULONG Type;
	ULONG NameLength;
	WCHAR Name[1];
}KEY_VALUE_BASIC_INFORMATION,*PKEY_VALUE_BASIC_INFORMATION;

typedef struct _KEY_BASIC_INFORMATION
{
	LARGE_INTEGER LastWriteTime;
	ULONG TitleIndex;
	ULONG NameLength;
	WCHAR Name[1];
}KEY_BASIC_INFORMATION,*PKEY_BASIC_INFORMATION;

typedef enum _KEY_INFORMATION_CLASS
{
	KeyBasicInformation,
	KeyNodeInformation,
	KeyFullInformation,
	KeyNameInformation,
	KeyCachedInformation,
	KeyFlagsInformation,
	KeyVirtualizationInformation,
	MaxKeyInfoClass
}KEY_INFORMATION_CLASS;

typedef struct EXCEPTION_REGISTRATION_RECORD *PEXCEPTION_REGISTRATION_RECORD;
typedef EXCEPTION_DISPOSITION (__stdcall *_except_handler_)(PEXCEPTION_RECORD,PEXCEPTION_REGISTRATION_RECORD,PCONTEXT,PULONG);

struct EXCEPTION_REGISTRATION_RECORD
{
	PEXCEPTION_REGISTRATION_RECORD	prev_structure;
	_except_handler_				ExceptionHandler;
};

extern "C"
{
	__declspec(dllimport) NTSTATUS __stdcall RtlInitUnicodeString(PUNICODE_STRING DestinationString,PCWSTR SourceString);
	__declspec(dllimport) NTSTATUS __stdcall RtlCreateUserThread(HANDLE hProcess,PVOID SecurityDescriptor,BOOLEAN CreateSuspended,ULONG ZeroBits,ULONG StackReserve,ULONG StackCommit,PVOID EntryPoint,PVOID Argument,PHANDLE phThread,PCLIENT_ID pCid);
	__declspec(dllimport) NTSTATUS __stdcall ZwQueueApcThread(HANDLE hThread,PVOID ApcRoutine,PVOID ApcContext,PVOID Argument1,PVOID Argument2);
	__declspec(dllimport) NTSTATUS __stdcall RtlQueueApcWow64Tread(HANDLE ThreadHandle,PVOID ApcRoutine,PVOID ApcRoutineContext,ULONG ApcStatusBlock,ULONG ApcReserved);
	__declspec(dllimport) NTSTATUS __stdcall ZwQuerySystemInformation(ULONG SystemInformationClass,PVOID SystemInformation,ULONG SystemInformationLength,PULONG ReturnLength);
	__declspec(dllimport) NTSTATUS __stdcall ZwQueryInformationThread(HANDLE hThread,THREADINFOCLASS InformationClass,PVOID Information,ULONG InformationLength,PULONG ReturnLength);
	__declspec(dllimport) NTSTATUS __stdcall ZwQueryInformationProcess(HANDLE ProcessHandle,PROCESSINFOCLASS ProcessInformationClass,PVOID ProcessInformation,ULONG ProcessInformationLength,PULONG ReturnLength);
	__declspec(dllimport) NTSTATUS __stdcall DbgPrint(LPCSTR Format,...);
	__declspec(dllimport) NTSTATUS __stdcall ZwCreatePort(PHANDLE PortHandle,POBJECT_ATTRIBUTES ObjectAttributes,ULONG MaxDataSize,ULONG MaxMessageSize,ULONG Reserved);
	__declspec(dllimport) NTSTATUS __stdcall ZwCreateWaitablePort(PHANDLE PortHandle,POBJECT_ATTRIBUTES ObjectAttributes,ULONG MaxDataSize,ULONG MaxMessageSize,ULONG Reserved);
	__declspec(dllimport) NTSTATUS __stdcall ZwAcceptConnectPort(PHANDLE hPort,LPVOID PortId,PPORT_MESSAGE Message,BOOLEAN Accept,PPORT_VIEW ServerView,PREMOTE_PORT_VIEW ClientView);
	__declspec(dllimport) NTSTATUS __stdcall ZwCompleteConnectPort(HANDLE hPort);
	__declspec(dllimport) NTSTATUS __stdcall ZwRequestWaitReplyPort(HANDLE PortHandle,PPORT_MESSAGE RequestMessage,PPORT_MESSAGE ReplyMessage);
	__declspec(dllimport) NTSTATUS __stdcall ZwConnectPort(PHANDLE PortHandle,PUNICODE_STRING PortName,PSECURITY_QUALITY_OF_SERVICE SecurityQos,PPORT_VIEW ClientView,PREMOTE_PORT_VIEW ServerView,PULONG MaxMessageLength,PVOID ConnectionInformation,PULONG ConnectionInformationLength);
	__declspec(dllimport) NTSTATUS __stdcall LpcRequestWaitReplyPort(PVOID Port,PPORT_MESSAGE RequestMessage,PPORT_MESSAGE ReplyMessage);
	__declspec(dllimport) NTSTATUS __stdcall ZwRequestPort(HANDLE PortHandle,PPORT_MESSAGE RequestMessage);
	__declspec(dllimport) NTSTATUS __stdcall LpcRequestPort(PVOID Port,PPORT_MESSAGE RequestMessage);
	__declspec(dllimport) NTSTATUS __stdcall ZwReplyPort(HANDLE PortHandle,PPORT_MESSAGE ReplyMessage);
	__declspec(dllimport) NTSTATUS __stdcall ZwReplyWaitReplyPort(HANDLE PortHandle,PPORT_MESSAGE ReplyMessage);
	__declspec(dllimport) NTSTATUS __stdcall ZwReplyWaitReceivePort(HANDLE PortHandle,LPVOID* pPortId,PPORT_MESSAGE ReplyMessage,PPORT_MESSAGE Message);
	__declspec(dllimport) NTSTATUS __stdcall ZwReplyWaitReceivePortEx(HANDLE PortHandle,LPVOID* pPortId,PPORT_MESSAGE ReplyMessage,PPORT_MESSAGE Message,PLARGE_INTEGER Timeout);
	__declspec(dllimport) NTSTATUS __stdcall ZwReadRequestData(HANDLE PortHandle,PORT_MESSAGE* Message,ULONG Index,PVOID Buffer,ULONG BufferLength,PULONG ReturnLength=0);
	__declspec(dllimport) NTSTATUS __stdcall ZwWriteRequestData(HANDLE PortHandle,PORT_MESSAGE* Message,ULONG Index,PVOID Buffer,ULONG BufferLength,PULONG ReturnLength=0);
	__declspec(dllimport) NTSTATUS __stdcall RtlAdjustPrivilege(ULONG	PrivilegeValue,BOOLEAN Enable,BOOLEAN ToThreadOnly,PBOOLEAN PreviousEnable);
	__declspec(dllimport) NTSTATUS __stdcall LdrLoadDll(LPCWSTR SearchPaths,PULONG pFlags,PUNICODE_STRING DllName,HMODULE* pDllBase);
	__declspec(dllimport) NTSTATUS __stdcall RtlAnsiStringToUnicodeString(PUNICODE_STRING DestinationString,PCANSI_STRING SourceString,BOOLEAN AllocateDestinationString);
	__declspec(dllimport) VOID __stdcall RtlInitAnsiString(PCANSI_STRING DestinationString,PCHAR SourceString);
	__declspec(dllimport) NTSTATUS __stdcall ZwTerminateThread(HANDLE ThreadHandle,NTSTATUS ExitStatus);
	__declspec(dllimport) NTSTATUS __stdcall ZwSetSecurityObject(HANDLE ObjectHandle,SECURITY_INFORMATION SecurityInformationClass,PSECURITY_DESCRIPTOR DescriptorBuffer);
	__declspec(dllimport) PIMAGE_NT_HEADERS __stdcall RtlImageNtHeader(PVOID ModuleAddress);
	__declspec(dllimport) PVOID __stdcall RtlImageDirectoryEntryToData(PVOID Base,BOOLEAN MappedAsImage,USHORT DirectoryEntry,PULONG Size);
	__declspec(dllimport) NTSTATUS __stdcall ZwRegisterThreadTerminatePort(HANDLE PortHandle);
	__declspec(dllimport) NTSTATUS __stdcall ZwClose(HANDLE ObjectHandle);
	__declspec(dllimport) NTSTATUS __stdcall ZwTestAlert();
	__declspec(dllimport) NTSTATUS __stdcall LdrGetProcedureAddress(HMODULE ModuleHandle,PANSI_STRING FunctionName,WORD Oridinal,PVOID *FunctionAddress);
	__declspec(dllimport) NTSTATUS __stdcall LdrUnloadDll(HANDLE ModuleHandle);
	__declspec(dllimport) BOOLEAN __stdcall RtlEqualUnicodeString(UNICODE_STRING *String1,UNICODE_STRING *String2,BOOLEAN CaseInSensitive);
	__declspec(dllimport) int __cdecl sprintf(LPTSTR lpOut,LPCTSTR lpFmt,...);
	__declspec(dllimport) int __cdecl _snprintf(char *buffer,size_t count,const char *format,...);
	__declspec(dllimport) int __cdecl _snwprintf( wchar_t *buffer,size_t count,const wchar_t *format,...);
	__declspec(dllimport) int __cdecl sscanf(const char * _Src,const char * _Format,...);
	__declspec(dllimport) int __cdecl swprintf(wchar_t * _String,const wchar_t * _Format,...);
	__declspec(dllimport) int __cdecl _vsnprintf(char * _DstBuf,size_t _MaxCount,const char * _Format,va_list _ArgList);
	__declspec(dllimport) NTSTATUS __stdcall ZwLoadDriver(PUNICODE_STRING DriverServiceName);
	__declspec(dllimport) NTSTATUS __stdcall ZwUnloadDriver(PUNICODE_STRING DriverServiceName);
	__declspec(dllimport) NTSTATUS __stdcall ZwSetInformationThread(HANDLE ThreadHandle,THREADINFOCLASS ThreadInformationClass,PVOID ThreadInformation,ULONG ThreadInformationLength);
	__declspec(dllimport) NTSTATUS __stdcall ZwFlushInstructionCache(HANDLE ProcessHandle,PVOID BaseAddress,ULONG NumberOfBytesToFlush);
	__declspec(dllimport) NTSTATUS __stdcall ZwSetSystemInformation(SYSTEMINFOCLASS SystemInformationClass,PVOID SystemInformation,ULONG SystemInformationLength);
	__declspec(dllimport) NTSTATUS __stdcall LdrQueryProcessModuleInformation(PSMI psmi,ULONG BufferSize,PULONG RealSize);
	__declspec(dllimport) NTSTATUS __stdcall ZwQueryVirtualMemory(HANDLE ProcessHandle,PVOID BaseAddres,ULONG MemoryInformationClass,PVOID MemoryInformation,SIZE_T MemoryInformationLength,PSIZE_T ReturnLength);
	__declspec(dllimport) NTSTATUS __stdcall ZwOpenFile(PHANDLE FileHandle,ACCESS_MASK DesiredAccess,POBJECT_ATTRIBUTES ObjectAttributes,PIO_STATUS_BLOCK IoStatusBlock,ULONG ShareAccess,ULONG OpenOptions);
	__declspec(dllimport) NTSTATUS __stdcall ZwOpenKey(PHANDLE KeyHandle,ACCESS_MASK DesiredAccess,POBJECT_ATTRIBUTES ObjectAttributes);
	__declspec(dllimport) NTSTATUS __stdcall ZwCreateKey(PHANDLE KeyHandle,ACCESS_MASK DesiredAccess,POBJECT_ATTRIBUTES ObjectAttributes,ULONG TitleIndex,PUNICODE_STRING Class,ULONG CreateOptions,PULONG Disposition);
	__declspec(dllimport) NTSTATUS __stdcall ZwDeleteKey(HANDLE KeyHandle);
	__declspec(dllimport) NTSTATUS __stdcall ZwSetValueKey(HANDLE KeyHandle,PUNICODE_STRING ValueName,ULONG TitleIndex,ULONG Type,PVOID Data,ULONG DataSize);
	__declspec(dllimport) NTSTATUS __stdcall ZwDeleteValueKey(HANDLE KeyHandle,PUNICODE_STRING ValueName);
	__declspec(dllimport) NTSTATUS __stdcall ZwQueryValueKey(HANDLE KeyHandle,PUNICODE_STRING ValueName,KEY_VALUE_INFORMATION_CLASS KeyValueInformationClass,PVOID KeyValueInformation,ULONG Length,PULONG ResultLength);
	__declspec(dllimport) NTSTATUS __stdcall ZwEnumerateKey(HANDLE KeyHandle,ULONG Index,KEY_INFORMATION_CLASS KeyInformationClass,PVOID KeyInformation,ULONG Length,PULONG ResultLength);
	__declspec(dllimport) NTSTATUS __stdcall ZwEnumerateValueKey(HANDLE KeyHandle,ULONG Index,KEY_VALUE_INFORMATION_CLASS KeyValueInformationClass,PVOID KeyValueInformation,ULONG Length,PULONG ResultLength);
	__declspec(dllimport) PRTLFRAME __stdcall RtlGetFrame();
	__declspec(dllimport) VOID __stdcall RtlPushFrame(PRTLFRAME Frame);
	__declspec(dllimport) VOID __stdcall RtlPopFrame(PRTLFRAME Frame);
	__declspec(dllimport) NTSTATUS __stdcall NtQueryInformationFile(HANDLE FileHandle,PIO_STATUS_BLOCK IoStatusBlock,PVOID FileInformation,ULONG Length,FILE_INFORMATION_CLASS FileInformationClass);
	__declspec(dllimport) ULONG __stdcall RtlRandom(PULONG Seed);
	__declspec(dllimport) NTSTATUS __stdcall ZwReadFile(HANDLE FileHandle,HANDLE Event,PIO_APC_ROUTINE ApcRoutine,PVOID ApcContext,PIO_STATUS_BLOCK IoStatusBlock,PVOID Buffer,ULONG Length,PLARGE_INTEGER ByteOffset,PULONG Key);
	__declspec(dllimport) LPSTR __stdcall RtlIpv4AddressToStringA(IN_ADDR* Addr,LPSTR S);
	__declspec(dllimport) NTSTATUS __stdcall RtlIpv4StringToAddressA(PCSTR S,BOOLEAN Strict,LPSTR* Terminator,IN_ADDR* Addr);
	__declspec(dllimport) NTSTATUS __stdcall RtlWriteRegistryValue(ULONG RelativeTo,PCWSTR Path,PCWSTR ValueName,ULONG ValueType,PVOID ValueData,ULONG ValueLength);
	__declspec(dllimport) NTSTATUS __stdcall RtlDeleteRegistryValue(ULONG RelativeTo,PCWSTR Path,PCWSTR ValueName);
	__declspec(dllimport) NTSTATUS __stdcall RtlCreateRegistryKey(ULONG RelativeTo,PWSTR Path);
	__declspec(dllimport) NTSTATUS __stdcall ZwCreateNamedPipeFile(PHANDLE FileHandle,ACCESS_MASK DesiredAccess,POBJECT_ATTRIBUTES ObjectAttributes,PIO_STATUS_BLOCK IoStatusBlock,ULONG ShareAccess,ULONG CreateDisposition,ULONG CreateOptions,ULONG NamedPipeType,ULONG ReadMode,ULONG CompletionMode,ULONG MaxInstances,ULONG InBufferSize,ULONG OutBufferSize,PLARGE_INTEGER DefaultTimeout);
}