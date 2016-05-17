/* Typedef a 32 bit type */
#ifndef UINT4
typedef unsigned long int UINT4;
#endif

/* Data structure for MD5 (Message Digest) computation */
typedef struct
{
	UINT4 i[2];                   /* Number of _bits_ handled mod 2^64 */
	UINT4 buf[4];                                    /* Scratch buffer */
	unsigned char in[64];                              /* Input buffer */
	unsigned char digest[16];     /* Actual digest after MD5Final call */
} MD5_CTX;

static void MD5_Transform (UINT4 *buf, UINT4 *in);

void MD5Final(MD5_CTX *mdContext);
void MD5Hash(char Input[128], int Size);
void MD5Init(MD5_CTX *mdContext, unsigned long pseudoRandomNumber = 0);
void MD5Update(MD5_CTX *mdContext, unsigned char *inBuf, unsigned int inLen);

char * GetMD5Hash( const char *szFilePath, char * lpHash, size_t size );
void StringToHash(const char *szInput, char *szHash, size_t size);
