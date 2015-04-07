#pragma once

// number of bytes to allocate for config decryption bytecode
#define MAX_CFG_DECRYPTION_CODE_SIZE 4096

namespace ConfigCrypt
{
	/*
		Executes bytecode.

		IN	   lpBytecode		 - buffer with bytecode to execute.
		IN/OUT lpBufferToDecrypt - buffer on which bytecode operates.
	*/
	void DecryptConfig(LPBYTE lpBytecode, LPBYTE lpBufferToDecrypt);

#ifdef BUILDER
	/*
		Builds bytecode for decrypting config data.

		IN/OUT bData          - Plaintext data, on exit this data is in encrypted form that can be
							   decrypted back to original state by executing produced bytecode.
		IN     dwDataSize     - Size of the data pointed by bOriginalData.
		OUT    bBytecode	  - Buffer that will hold produced bytecode.
		IN     dwBytecodeSize - Size of bBytecode buffer. Produced bytecode will be of size <=dwBytecodeSize.
	*/
	bool BuildDecryptionBytecode(LPBYTE bData, DWORD dwDataSize, LPBYTE bBytecode, DWORD dwBytecodeSize);
#endif
}

