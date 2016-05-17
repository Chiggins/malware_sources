#include "../Includes/includes.h"

int rc4(const char *szData, int nDataLength, const char *szKey, char *cOutput)
{
    int nEncryption[256];
    int nKey[256];

    int nKeyLength = strlen(szKey);
    for(int i = 0; i < 256; i++)
    {
        nKey[i] = szKey[i % nKeyLength];
        nEncryption[i] = i;
    }

    for(int i = 0, iB = 0, iC = 0; i < 256; i++)
    {
        iB = (iB + nEncryption[i] + nKey[i]) % 256;

        iC = nEncryption[i];
        nEncryption[i] = nEncryption[iB];
        nEncryption[iB] = iC;
    }

    char cDataEncrypted[nDataLength];
    memset(cDataEncrypted, 0, sizeof(cDataEncrypted));

    for(int i = 0, iB = 0, iC = 0, iD = 0, iE; i < nDataLength; i++)
    {
        iB = (iB + 1) % 256;
        iC = (iC + nEncryption[iB]) % 256;

        iE = nEncryption[iB];
        nEncryption[iB] = nEncryption[iC];
        nEncryption[iC] = iE;

        iD = nEncryption[(nEncryption[iB] + nEncryption[iC]) % 256];
        cDataEncrypted[i] = szData[i] ^ iD;
    }

    memcpy(cOutput, cDataEncrypted, nDataLength);

    return nDataLength;
}
