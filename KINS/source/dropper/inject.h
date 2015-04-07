#ifndef _INJECT_H_
#define _INJECT_H_

namespace Inject
{
	BOOLEAN InjectProcess(DWORD ProcessId, HANDLE ThreadHandle);
	BOOLEAN InjectImageToProcess(HANDLE ProcessHandle, PVOID ImageBase, DWORD ImageSize, HANDLE ThreadHandle);

	VOID InjectRoutine(PVOID ImageBase, BOOLEAN bAPC);

	BOOLEAN CopyImageToProcess(HANDLE ProcessHandle, PVOID ImageBase, DWORD ImageSize, DWORD64 *RemoteImage);

	BOOLEAN CheckProcessName(HANDLE ProcessHandle);

	BOOLEAN InjectProcessByName(LPSTR ProcessName);
	VOID SetCreateProcessHooks();
};

#endif
