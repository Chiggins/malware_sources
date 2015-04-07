#ifndef _OS_STRUCTS_H_
#define _OS_STRUCTS_H_

namespace WOW64
{
	#pragma pack (1)
	typedef struct _PROCESS_BASIC_INFORMATION64 { 
		PVOID64 Reserved1;
		PVOID64 PebBaseAddress;
		PVOID64 Reserved2[2];
		PVOID64 UniqueProcessId;
		PVOID64 Reserved3;
	} PROCESS_BASIC_INFORMATION64,*PPROCESS_BASIC_INFORMATION64; 

	typedef struct _LIST_ENTRY64
	{
		union
		{
			DWORD64 _Flink;
			LIST_ENTRY64* Flink;
		};
		union
		{
			DWORD64 _Blink;
			LIST_ENTRY64* Blink;
		};
	} LIST_ENTRY64;

	typedef struct UNICODE_STRING64
	{
		WORD Length;
		WORD MaximumLength;
		DWORD alignment;
		union
		{
			DWORD64 _Buffer;
			WORD* Buffer;
		};
	} UNICODE_STRING64;

	typedef struct _ANSI_STRING64
	{
		WORD Length;
		WORD MaximumLength;
		DWORD alignment;
		union
		{
			DWORD64 _Buffer;
			CHAR* Buffer;
		};
	} ANSI_STRING64;

	typedef struct _LDR_DATA_TABLE_ENTRY64
	{
		LIST_ENTRY64 InLoadOrderLinks;
		LIST_ENTRY64 InMemoryOrderLinks;
		LIST_ENTRY64 InInitializationOrderLinks;
		DWORD64 DllBase;
		DWORD64 EntryPoint;
		DWORD64 SizeOfImage;
		UNICODE_STRING64 FullDllName;
		UNICODE_STRING64 BaseDllName;
		/*
		+0x000 InLoadOrderLinks : _LIST_ENTRY
		+0x010 InMemoryOrderLinks : _LIST_ENTRY
		+0x020 InInitializationOrderLinks : _LIST_ENTRY
		+0x030 DllBase          : Ptr64 Void
		+0x038 EntryPoint       : Ptr64 Void
		+0x040 SizeOfImage      : Uint4B
		+0x048 FullDllName      : _UNICODE_STRING
		+0x058 BaseDllName      : _UNICODE_STRING
		+0x068 Flags            : Uint4B
		+0x06c LoadCount        : Uint2B
		+0x06e TlsIndex         : Uint2B
		+0x070 HashLinks        : _LIST_ENTRY
		+0x070 SectionPointer   : Ptr64 Void
		+0x078 CheckSum         : Uint4B
		+0x080 TimeDateStamp    : Uint4B
		+0x080 LoadedImports    : Ptr64 Void
		+0x088 EntryPointActivationContext : Ptr64 _ACTIVATION_CONTEXT
		+0x090 PatchInformation : Ptr64 Void
		+0x098 ForwarderLinks   : _LIST_ENTRY
		+0x0a8 ServiceTagLinks  : _LIST_ENTRY
		+0x0b8 StaticLinks      : _LIST_ENTRY
		+0x0c8 ContextInformation : Ptr64 Void
		+0x0d0 OriginalBase     : Uint8B
		*/
	} LDR_DATA_TABLE_ENTRY64;

	typedef struct _PEB_LDR_DATA64
	{
		DWORD Length;
		DWORD Initialized;
		DWORD64 SsHandle;
		LIST_ENTRY64 InLoadOrderModuleList;
		LIST_ENTRY64 InMemoryOrderModuleList;
		LIST_ENTRY64 InInitializationOrderModuleList;
		DWORD64 EntryInProgress;
		DWORD64 ShutdownInProgress;
		DWORD64 ShutdownThreadId;
		/*
		+0x000 Length           : Uint4B
		+0x004 Initialized      : UChar
		+0x008 SsHandle         : Ptr64 Void
		+0x010 InLoadOrderModuleList : _LIST_ENTRY
		+0x020 InMemoryOrderModuleList : _LIST_ENTRY
		+0x030 InInitializationOrderModuleList : _LIST_ENTRY
		+0x040 EntryInProgress  : Ptr64 Void
		+0x048 ShutdownInProgress : UChar
		+0x050 ShutdownThreadId : Ptr64 Void
		*/
	} PEB_LDR_DATA64;

	typedef struct _PEB64 
	{
		BYTE InheritedAddressSpace;
		BYTE ReadImageFileExecOptions;
		BYTE BeingDebugged;
		BYTE BitField;
		DWORD Reserved1;
		DWORD64 Mutant;
		DWORD64 ImageBaseAddress;
		union
		{
			DWORD64 _Ldr;
			PEB_LDR_DATA64* Ldr;
		};
		DWORD64 ProcessParameters;
		DWORD64 SubSystemData;
		DWORD64 ProcessHeap;
		DWORD64 FastPebLock;
		DWORD64 AtlThunkSListPtr;
		DWORD64 IFEOKey;
		DWORD CrossProcessFlags;
		DWORD Reserved2;
		DWORD64 UserSharedInfoPtr;	//KernelCallbackTable
		DWORD SystemReserved;
		DWORD AtlThunkSListPtr32;
		DWORD64 ApiSetMap;
		DWORD TlsExpansionCounter;
		DWORD Reserved3;
		DWORD64 TlsBitmap;
		DWORD TlsBitmapBits;
		DWORD Reserved4;
		DWORD64 ReadOnlySharedMemoryBase;
		DWORD64 HotpatchInformation;
		DWORD64 ReadOnlyStaticServerData;
		DWORD64 AnsiCodePageData;
		DWORD64 OemCodePageData;
		DWORD64 UnicodeCaseTableData;
		DWORD NumberOfProcessors;
		DWORD NtGlobalFlag;
		LARGE_INTEGER CriticalSectionTimeout;
		DWORD64 HeapSegmentReserve;
		DWORD64 HeapSegmentCommit;
		DWORD64 HeapDeCommitTotalFreeThreshold;
		DWORD64 HeapDeCommitFreeBlockThreshold;
		DWORD NumberOfHeaps;
		DWORD MaximumNumberOfHeaps;
		DWORD64 ProcessHeaps;
		DWORD64 GdiSharedHandleTable;
		DWORD64 ProcessStarterHelper;
		DWORD GdiDCAttributeList;
		DWORD Reserved5;
		DWORD64 LoaderLock;
		DWORD OSMajorVersion;
		DWORD OSMinorVersion;
		WORD OSBuildNumber;
		WORD OSCSDVersion;
		DWORD OSPlatformId;
		DWORD ImageSubsystem;
		DWORD ImageSubsystemMajorVersion;
		DWORD ImageSubsystemMinorVersion;
		DWORD Reserved6;
		DWORD64 ActiveProcessAffinityMask;
		DWORD GdiHandleBuffer;
		DWORD Reserved7[59];
		DWORD64 PostProcessInitRoutine; 
		DWORD64 TlsExpansionBitmap; 
		DWORD TlsExpansionBitmapBits;
		DWORD Reserved8[31];
		DWORD SessionId;
		DWORD Reserved9;
		ULARGE_INTEGER AppCompatFlags;
		ULARGE_INTEGER AppCompatFlagsUser;
		DWORD64 pShimData;
		DWORD64 AppCompatInfo;
		UNICODE_STRING CSDVersion;
		//DWORD Reserved10;
		DWORD64 ActivationContextData;
		DWORD64 ProcessAssemblyStorageMap;
		DWORD64 SystemDefaultActivationContextData;
		DWORD64 SystemAssemblyStorageMap; 
		DWORD64 MinimumStackCommit;
		DWORD64 FlsCallback;
		LIST_ENTRY FlsListHead;
		DWORD64 FlsBitmap;
		DWORD FlsBitmapBits;
		DWORD Reserved11[3];
		DWORD FlsHighIndex;
		DWORD Reserved12;
		DWORD64 WerRegistrationData;
		DWORD64 WerShipAssertPtr;
		DWORD64 pContextData;
		DWORD64 pImageHeaderHash;
		DWORD TracingFlags;
	} PEB64;

	typedef struct _EXCEPTION_REGISTRATION_RECORD64
	{
		DWORD64 Next;
		DWORD64 Handler;
	} EXCEPTION_REGISTRATION_RECORD64;

	/*
	//defined in winternl.h
	typedef struct _NT_TIB64
	{
		DWORD64 ExceptionList;
		DWORD64 StackBase;
		DWORD64 StackLimit;
		DWORD64 SubSystemTib;
		DWORD64 FiberData;
		DWORD64 ArbitraryUserPointer;
		DWORD64 Self;
	} NT_TIB64;
	*/

	typedef struct _CLIENT_ID64
	{
		DWORD64 UniqueProcess;
		DWORD64 UniqueThread;
	} CLIENT_ID64;

	typedef struct _TEB64
	{
		_NT_TIB64 NtTib;
		DWORD64 EnvironmentPointer;
		_CLIENT_ID64 ClientId;
		DWORD64 ActiveRpcHandle;
		DWORD64 ThreadLocalStoragePointer;
		union
		{
			DWORD64 _ProcessEnvironmentBlock;
			PEB64* ProcessEnvironmentBlock;
		};
		/*
		+0x000 NtTib            : _NT_TIB
		+0x038 EnvironmentPointer : Ptr64 Void
		+0x040 ClientId         : _CLIENT_ID
		+0x050 ActiveRpcHandle  : Ptr64 Void
		+0x058 ThreadLocalStoragePointer : Ptr64 Void
		+0x060 ProcessEnvironmentBlock : Ptr64 _PEB
		+0x068 LastErrorValue   : Uint4B
		+0x06c CountOfOwnedCriticalSections : Uint4B
		+0x070 CsrClientThread  : Ptr64 Void
		+0x078 Win32ThreadInfo  : Ptr64 Void
		+0x080 User32Reserved   : [26] Uint4B
		+0x0e8 UserReserved     : [5] Uint4B
		+0x100 WOW32Reserved    : Ptr64 Void
		+0x108 CurrentLocale    : Uint4B
		+0x10c FpSoftwareStatusRegister : Uint4B
		+0x110 SystemReserved1  : [54] Ptr64 Void
		+0x2c0 ExceptionCode    : Int4B
		+0x2c8 ActivationContextStackPointer : Ptr64 _ACTIVATION_CONTEXT_STACK
		+0x2d0 SpareBytes       : [24] UChar
		+0x2e8 TxFsContext      : Uint4B
		+0x2f0 GdiTebBatch      : _GDI_TEB_BATCH
		+0x7d8 RealClientId     : _CLIENT_ID
		+0x7e8 GdiCachedProcessHandle : Ptr64 Void
		+0x7f0 GdiClientPID     : Uint4B
		+0x7f4 GdiClientTID     : Uint4B
		+0x7f8 GdiThreadLocalInfo : Ptr64 Void
		+0x800 Win32ClientInfo  : [62] Uint8B
		+0x9f0 glDispatchTable  : [233] Ptr64 Void
		+0x1138 glReserved1      : [29] Uint8B
		+0x1220 glReserved2      : Ptr64 Void
		+0x1228 glSectionInfo    : Ptr64 Void
		+0x1230 glSection        : Ptr64 Void
		+0x1238 glTable          : Ptr64 Void
		+0x1240 glCurrentRC      : Ptr64 Void
		+0x1248 glContext        : Ptr64 Void
		+0x1250 LastStatusValue  : Uint4B
		+0x1258 StaticUnicodeString : _UNICODE_STRING
		+0x1268 StaticUnicodeBuffer : [261] Wchar
		+0x1478 DeallocationStack : Ptr64 Void
		+0x1480 TlsSlots         : [64] Ptr64 Void
		+0x1680 TlsLinks         : _LIST_ENTRY
		+0x1690 Vdm              : Ptr64 Void
		+0x1698 ReservedForNtRpc : Ptr64 Void
		+0x16a0 DbgSsReserved    : [2] Ptr64 Void
		+0x16b0 HardErrorMode    : Uint4B
		+0x16b8 Instrumentation  : [11] Ptr64 Void
		+0x1710 ActivityId       : _GUID
		+0x1720 SubProcessTag    : Ptr64 Void
		+0x1728 EtwLocalData     : Ptr64 Void
		+0x1730 EtwTraceData     : Ptr64 Void
		+0x1738 WinSockData      : Ptr64 Void
		+0x1740 GdiBatchCount    : Uint4B
		+0x1744 CurrentIdealProcessor : _PROCESSOR_NUMBER
		+0x1744 IdealProcessorValue : Uint4B
		+0x1744 ReservedPad0     : UChar
		+0x1745 ReservedPad1     : UChar
		+0x1746 ReservedPad2     : UChar
		+0x1747 IdealProcessor   : UChar
		+0x1748 GuaranteedStackBytes : Uint4B
		+0x1750 ReservedForPerf  : Ptr64 Void
		+0x1758 ReservedForOle   : Ptr64 Void
		+0x1760 WaitingOnLoaderLock : Uint4B
		+0x1768 SavedPriorityState : Ptr64 Void
		+0x1770 SoftPatchPtr1    : Uint8B
		+0x1778 ThreadPoolData   : Ptr64 Void
		+0x1780 TlsExpansionSlots : Ptr64 Ptr64 Void
		+0x1788 DeallocationBStore : Ptr64 Void
		+0x1790 BStoreLimit      : Ptr64 Void
		+0x1798 MuiGeneration    : Uint4B
		+0x179c IsImpersonating  : Uint4B
		+0x17a0 NlsCache         : Ptr64 Void
		+0x17a8 pShimData        : Ptr64 Void
		+0x17b0 HeapVirtualAffinity : Uint4B
		+0x17b8 CurrentTransactionHandle : Ptr64 Void
		+0x17c0 ActiveFrame      : Ptr64 _TEB_ACTIVE_FRAME
		+0x17c8 FlsData          : Ptr64 Void
		+0x17d0 PreferredLanguages : Ptr64 Void
		+0x17d8 UserPrefLanguages : Ptr64 Void
		+0x17e0 MergedPrefLanguages : Ptr64 Void
		+0x17e8 MuiImpersonation : Uint4B
		+0x17ec CrossTebFlags    : Uint2B
		+0x17ec SpareCrossTebBits : Pos 0, 16 Bits
		+0x17ee SameTebFlags     : Uint2B
		+0x17ee SafeThunkCall    : Pos 0, 1 Bit
		+0x17ee InDebugPrint     : Pos 1, 1 Bit
		+0x17ee HasFiberData     : Pos 2, 1 Bit
		+0x17ee SkipThreadAttach : Pos 3, 1 Bit
		+0x17ee WerInShipAssertCode : Pos 4, 1 Bit
		+0x17ee RanProcessInit   : Pos 5, 1 Bit
		+0x17ee ClonedThread     : Pos 6, 1 Bit
		+0x17ee SuppressDebugMsg : Pos 7, 1 Bit
		+0x17ee DisableUserStackWalk : Pos 8, 1 Bit
		+0x17ee RtlExceptionAttached : Pos 9, 1 Bit
		+0x17ee InitialThread    : Pos 10, 1 Bit
		+0x17ee SpareSameTebBits : Pos 11, 5 Bits
		+0x17f0 TxnScopeEnterCallback : Ptr64 Void
		+0x17f8 TxnScopeExitCallback : Ptr64 Void
		+0x1800 TxnScopeContext  : Ptr64 Void
		+0x1808 LockCount        : Uint4B
		+0x180c SpareUlong0      : Uint4B
		+0x1810 ResourceRetValue : Ptr64 Void
		*/
	} TEB64;
	#pragma pack()

};

#endif //_OS_STRUCTS_H_
