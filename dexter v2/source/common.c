#include <windows.h>

#include "Globals.h"

void *_memset(void *s, int c, size_t n) {

	size_t i;
	char * ptr = s;

	for (i = 0; i < n; i++, ptr++)
	{
		*ptr = c;
	}
	return s; 
}

void *_memcpy(void* dest, const void* src, size_t count) {
	char* dst8 = (char*)dest;
	char* src8 = (char*)src;

	while (count--) {
		*dst8++ = *src8++;
	}
	return dest;
}

int base64_decode(const BYTE* pSrc, int nLenSrc, char* pDst, int nLenDst) {

	BYTE s1,s2,s3,s4;
	BYTE d1,d2,d3;

	int j,nLenOut= 0;
	for(j=0; j<nLenSrc; j+=4 ) {
		if ( nLenOut > nLenDst ) {
			return( 0 ); // error, buffer too small
		}

		s1= LookupDigits[ *pSrc++ ];
		s2= LookupDigits[ *pSrc++ ];
		s3= LookupDigits[ *pSrc++ ];
		s4= LookupDigits[ *pSrc++ ];

		d1= ((s1 & 0x3f) << 2) | ((s2 & 0x30) >> 4);
		d2= ((s2 & 0x0f) << 4) | ((s3 & 0x3c) >> 2);
		d3= ((s3 & 0x03) << 6) | ((s4 & 0x3f) >> 0);

		*pDst++ = d1;  nLenOut++;
		if (s3==99) break;      // end padding found
		*pDst++ = d2;  nLenOut++;
		if (s4==99) break;      // end padding found
		*pDst++ = d3;  nLenOut++;
	}

	return(nLenOut);
}

void _xor(char *src,char *key,int srclen,int keylen) {
	int i;

	i = 0;
	while(srclen>0) {
		while(i<keylen) {
			*src = *src ^ *key;
			key++;
			i++;
		}
		key = key - i;
		i = 0;
		src++;	
		srclen--;
	}
}

void base64_encode(unsigned char *input_buffer, size_t input_len,char *output_buffer, size_t output_len) {


	while (input_len && output_len)
	{
		*output_buffer++ = b64str[((unsigned char)(input_buffer[0]) >> 2) & 0x3f];
		if (!--output_len)
		break;
		*output_buffer++ = b64str[(((unsigned char)(input_buffer[0]) << 4)
		+ (--input_len ? (unsigned char)(input_buffer[1]) >> 4 : 0))
		& 0x3f
		];
		if (!--output_len)
		break;
		*output_buffer++ =
		(input_len ? 
		b64str[
		(
		((unsigned char)(input_buffer[1]) << 2) + 
		(--input_len ? (unsigned char)(input_buffer[2]) >> 6 : 0)
		)	& 0x3f
		]
		: '=');

		if (!--output_len)
		break;
		*output_buffer++ = input_len ? b64str[(unsigned char)(input_buffer[2]) & 0x3f] : '=';
		if (!--output_len)
		break;
		if (input_len)
		input_len--;
		if (input_len)
		input_buffer += 3;
	}

	*output_buffer = '\0';
}

char ny_toLower(char c){ 
	
	//if(c == 0x00) return c;
	if(c >= 'A' && c <= 'Z') c -= (char)('A' - 'a');
	return c;
}


int check_digit (char c) {
	return (c>='0') && (c<='9');
}

char from_hex(char ch) {
	return check_digit(ch) ? ch - '0' : ny_toLower(ch) - 'a' + 10;
}

void url_decode(char *str, char *buf) {

	char *pstr = str, *pbuf = buf;

	while (*pstr) {
		if (*pstr == '%') {
			if (pstr[1] && pstr[2]) {
				*pbuf++ = from_hex(pstr[1]) << 4 | from_hex(pstr[2]);
				pstr += 2;
			}
		} else if (*pstr == '+') { 
			*pbuf++ = ' ';
		} else {
			*pbuf++ = *pstr;
		}
		pstr++;
	}
	*pbuf = '\0';
}

int _atoi(const char *string) {

   int i;


   i=0;
   while(*string)
   {
   i=(i<<3) + (i<<1) + (*string - '0');
   string++;
   }

   return(i);
}

int CopyTill(char *dest,char *src,char c) {

	int i;

	i = 0;
	while(*src!=c) {
		*dest = *src;
		dest++;
		src++;
		i++;
	}
	*dest = 0x00;

	return i;
}

void RandStrA(char *ptr,int len) {

	int i;
	char c;

	i = 0;
	_srand(GetTickCount());

	while(i<len) {
		c =  97 + (_rand() % (122 - 97));
		*ptr = c;
		ptr++;
		i++;
	}
	*ptr = 0x00;

}

void RandStrW(WCHAR *ptr,int len) {

	int i;
	WCHAR c;

	i = 0;
	_srand(GetTickCount());
	while(i<len) {
		c =  97 + (_rand() % (122 - 97));
		*ptr = c;
		ptr++;
		i++;
	}
	*ptr = 0x00;

}


DWORD RandInt;

void __cdecl _srand(unsigned int seed)
{
	RandInt = seed;
}

int do_rand(unsigned long *ctx)
{
	long hi, lo, x;

	x = *ctx;
	/* Can't be initialized with 0, so use another value. */
	if (x == 0)
	x = 123459876L;
	hi = x / 127773L;
	lo = x % 127773L;
	x = 16807L * lo - 2836L * hi;
	if (x < 0)
	x += 0x7fffffffL;
	return ((*ctx = x) % ((unsigned long)RAND_MAX + 1));
}

int __cdecl _rand()
{
	return do_rand(&RandInt);
}


void GenUnique(char *ptr) {

	GUID UIDObj;
	char *UID;

    CoCreateGuid(&UIDObj);  
    UuidToString(&UIDObj,(unsigned char **)&UID);
	lstrcpy(ptr,UID);
}

void GetDebugPrivs() {

HANDLE hToken;
LUID sedebugnameValue;
TOKEN_PRIVILEGES tp;


OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES|TOKEN_QUERY,&hToken);

LookupPrivilegeValue( NULL, SE_DEBUG_NAME, &sedebugnameValue);

tp.PrivilegeCount = 1;
tp.Privileges[0].Luid = sedebugnameValue;
tp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
AdjustTokenPrivileges( hToken,FALSE,&tp,sizeof(tp),NULL,NULL);

CloseHandle(hToken);

}


BOOL IsPCx64() { //return TRUE if its running on x64

	BOOL f64 = FALSE;

	if(IsWoW64ProcessX!=NULL) {

		IsWoW64ProcessX(GetCurrentProcess(),&f64);
		if(f64 == TRUE) { return TRUE; } //running on x64
       
	}

	return FALSE; //not running on x64
}

ULONG_PTR GetParentProcessId() // By Napalm @ NetCore2K 
{ 
 ULONG_PTR pbi[6]; 
 ULONG ulSize = 0; 
 LONG (WINAPI *NtQueryInformationProcess)(HANDLE ProcessHandle, ULONG ProcessInformationClass, 
  PVOID ProcessInformation, ULONG ProcessInformationLength, PULONG ReturnLength);  
 *(FARPROC *)&NtQueryInformationProcess =  
  GetProcAddress(LoadLibraryA("NTDLL.DLL"), "NtQueryInformationProcess"); 
 if(NtQueryInformationProcess){ 
  if(NtQueryInformationProcess(GetCurrentProcess(), 0, 
    &pbi, sizeof(pbi), &ulSize) >= 0 && ulSize == sizeof(pbi)) 
     return pbi[5]; 
 } 
 return (ULONG_PTR)-1; 
} 

void MonitorShutdown() {

	MSG msg;
	WNDCLASSEX wcex;


	wcex.cbSize = sizeof(WNDCLASSEX); 
	wcex.style = CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc = (WNDPROC)DetectShutdown;
	wcex.cbClsExtra	= 0;
	wcex.cbWndExtra	= 0;
	wcex.hInstance = NULL;
	wcex.hIcon = NULL;
	wcex.hCursor = NULL;
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
	wcex.lpszMenuName = NULL;
	wcex.lpszClassName = ClassName;
	wcex.hIconSm = NULL;
	RegisterClassEx(&wcex);

	CreateWindowEx(WS_EX_TOPMOST|WS_EX_TOOLWINDOW,ClassName,NULL,WS_POPUP,0,0,0,0,NULL,NULL,NULL,NULL);

    while(GetMessage(&msg,0,0,0) > 0) {

        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

}