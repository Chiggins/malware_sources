#include <stdio.h>
#include <Windows.h>
#include <time.h>

//Base64 stuff
size_t          base64_decode(const char *source, char *target, size_t targetlen);
int             base64_encode(unsigned char *source, size_t sourcelen, char *target, size_t targetlen);

//RC4
int             rc4(const char *szData, const char *szKey, char *cOutput);

//Utilites
char            *EncryptConfig(char *cConfig);
char            *DecryptConfig(char *cConfig);
unsigned long   GetHash(unsigned char *str);
char            *SimpleDynamicXor(char *pcString, DWORD dwKey);
char            *SwapAllBackSlashesWithForwardSlashes(char *pcString);
char            *SwapAllForwardSlashesWithBackSlashes(char *pcString);
//DWORD           StartProcessFromPath(char *cPath, bool bHidden);
//bool            KillProcess(DWORD dwPID);
char            *GenRandLCText();
bool            CopyToClipboard(const char *cData);
void             SwapBase64ToNonBase64(char *cSource);
void            SwapNonBase64ToBase64(char *cSource);

//Globally used arrays
extern char cPoolOfCharacters[77];
extern char cMixedPoolOfCharacters[77];
