///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Copyright © NetworkDLS 2002, All rights reserved
//
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF 
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A 
// PARTICULAR PURPOSE.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifndef _CCRC32_CPP
#define _CCRC32_CPP
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#include <Windows.H>

#include "Globals.h"
#include "CRC32.h"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
	This function initializes "CRC Lookup Table". You only need to call it once to
		initalize the table before using any of the other CRC32 calculation functions.
*/

void InitializeCRC32(void) {

	int iPos,iCodes;
	//0x04C11DB7 is the official polynomial used by PKZip, WinZip and Ethernet.
	unsigned int iPolynomial = 0x04C11DB7;

	_memset(&iTable, 0, sizeof(iTable));

	// 256 values representing ASCII character codes.
	for(iCodes = 0; iCodes <= 0xFF; iCodes++)
	{
		iTable[iCodes] = Reflect(iCodes, 8) << 24;

		for(iPos = 0; iPos < 8; iPos++)
		{
			iTable[iCodes] = (iTable[iCodes] << 1)
				^ ((iTable[iCodes] & (1 << 31)) ? iPolynomial : 0);
		}

		iTable[iCodes] = Reflect(iTable[iCodes], 32);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
	Reflection is a requirement for the official CRC-32 standard.
	You can create CRCs without it, but they won't conform to the standard.
*/

unsigned int Reflect(unsigned int iReflect, const char cChar) {

	int iPos;
	unsigned int iValue = 0;

	// Swap bit 0 for bit 7, bit 1 For bit 6, etc....
	for(iPos = 1; iPos < (cChar + 1); iPos++)
	{
		if(iReflect & 1)
		{
			iValue |= (1 << (cChar - iPos));
		}
		iReflect >>= 1;
	}

	return iValue;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
	Calculates the CRC32 by looping through each of the bytes in sData.
	
	Note: For Example usage example, see FileCRC().
*/

void PartialCRC(unsigned int *iCRC, const unsigned char *sData, size_t iDataLength) {

	while(iDataLength--)
	{
		//If your compiler complains about the following line, try changing
		//	each occurrence of *iCRC with ((unsigned int)*iCRC).

		*iCRC = (*iCRC >> 8) ^ iTable[(*iCRC & 0xFF) ^ *sData++];
	}
}

unsigned long FullCRC(const unsigned char *sData, unsigned long ulDataLength) {

        unsigned long ulCRC = 0xffffffff;
        PartialCRC((unsigned int *)&ulCRC, sData, ulDataLength);
        return(ulCRC ^ 0xffffffff);
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#endif
