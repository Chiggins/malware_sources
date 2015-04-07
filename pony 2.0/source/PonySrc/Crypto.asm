; Common cryptography functions

MD5Data PROTO :DWORD, :DWORD, :DWORD
MD5Transform PROTO :DWORD, :DWORD, :DWORD
SHA1Data PROTO :DWORD, :DWORD, :DWORD
MoveMem PROTO :DWORD, :DWORD, :DWORD

.code

MD5Data PROC USES EAX EBX ECX EDX EDI ESI input_data, file_size, out_hash
	LOCAL md5_context[4]:	DWORD
	LOCAL num_of_blocks:	DWORD
               
	mov   eax, file_size            
	lea  ecx, [eax + 128]		    	; extra padding bytes
	
	lea   edx, [eax * 8]               	; calculate number of bits. (only 32-bit)
	
	mov   ebx, eax                     	; save size in ebx
	mov   ecx, eax                      	; save size in ecx
	
	shr   eax, 6                        	; get number of 64 byte blocks
	mov   num_of_blocks, eax
	
	mov   edi, input_data
	
	add   edi, ecx                      	; get end of data
	mov   byte ptr [edi], 80h      		; append end bit
	
	and   ebx, 63                      	; get remainder (if any)
	sub   edi, ebx                      	; edi holds offset of last block
	
	.IF	(ebx >= 56)                   	; can we append bits here?
		add   edi, ebx                	; no..
		mov   eax, 64
		sub   eax, ebx
		add   edi, eax
		
		inc   dword ptr [num_of_blocks]
	.ENDIF
	
	mov   [edi + 14*4], edx	            	; store bits
	
	lea  esi, [md5_context]             	; initialize md5 context
	
	mov  dword ptr[esi + (00*04)], 067452301h
	mov  dword ptr[esi + (01*04)], 0efcdab89h
	mov  dword ptr[esi + (02*04)], 098badcfeh
	mov  dword ptr[esi + (03*04)], 010325476h
	
	invoke MD5Transform, addr md5_context, input_data, num_of_blocks
	
	cld
	mov	ecx, 4
	mov	edi, out_hash
	rep movsd
	
	ret
MD5Data ENDP

FF    MACRO dwA, dwB, dwC, dwD, dwX, rS, dwT

	mov   edi, dwC
	
	xor   edi, dwD
	and   edi, dwB
	xor   edi, dwD
	
	lea   dwA, [dwA + dwT + edi]
	add   dwA, [dwX]
	rol   dwA, rS
	add   dwA, dwB

ENDM

GG    MACRO dwA, dwB, dwC, dwD, dwX, rS, dwT

	mov   edi, dwC
	
	xor   edi, dwB
	and   edi, dwD
	xor   edi, dwC
	
	lea   dwA, [dwA + dwT + edi]
	add   dwA, [dwX]
	rol   dwA, rS
	add   dwA, dwB
ENDM

HH    MACRO dwA, dwB, dwC, dwD, dwX, rS, dwT

	mov   edi, dwC
	
	xor   edi, dwD
	xor   edi, dwB
	
	lea   dwA, [dwA + dwT + edi]
	add   dwA, [dwX]
	rol   dwA, rS
	add   dwA, dwB

ENDM

II    MACRO dwA, dwB, dwC, dwD, dwX, rS, dwT

	mov   edi, -1
	
	xor   edi, dwD
	or    edi, dwB
	xor   edi, dwC
	
	lea   dwA, [dwA + dwT + edi]
	add   dwA, [dwX]
	rol   dwA, rS
	add   dwA, dwB

ENDM

MD5Transform PROC USES ESI EDI EAX EBX ECX EDX state:DWORD, block:DWORD, num_blocks:DWORD
	LOCAL loop_counter    :DWORD
	
	mov   esi, [block]
	mov   edi, [state]
	mov   eax, [num_blocks]
	
	mov   loop_counter, eax

transform_block:
	mov   eax, dword ptr[edi + (00*04)]
	mov   ebx, dword ptr[edi + (01*04)]
	mov   ecx, dword ptr[edi + (02*04)]
	mov   edx, dword ptr[edi + (03*04)]
	
	;==================================================
	
	FF    eax, ebx, ecx, edx, esi+(00*4), 07, 0d76aa478h
	FF    edx, eax, ebx, ecx, esi+(01*4), 12, 0e8c7b756h
	FF    ecx, edx, eax, ebx, esi+(02*4), 17, 0242070dbh
	FF    ebx, ecx, edx, eax, esi+(03*4), 22, 0c1bdceeeh
	
	FF    eax, ebx, ecx, edx, esi+(04*4), 07, 0f57c0fafh 
	FF    edx, eax, ebx, ecx, esi+(05*4), 12, 04787c62ah 
	FF    ecx, edx, eax, ebx, esi+(06*4), 17, 0a8304613h 
	FF    ebx, ecx, edx, eax, esi+(07*4), 22, 0fd469501h 
	
	FF    eax, ebx, ecx, edx, esi+(08*4), 07, 0698098d8h 
	FF    edx, eax, ebx, ecx, esi+(09*4), 12, 08b44f7afh 
	FF    ecx, edx, eax, ebx, esi+(10*4), 17, 0ffff5bb1h 
	FF    ebx, ecx, edx, eax, esi+(11*4), 22, 0895cd7beh 
	
	FF    eax, ebx, ecx, edx, esi+(12*4), 07, 06b901122h 
	FF    edx, eax, ebx, ecx, esi+(13*4), 12, 0fd987193h 
	FF    ecx, edx, eax, ebx, esi+(14*4), 17, 0a679438eh 
	FF    ebx, ecx, edx, eax, esi+(15*4), 22, 049b40821h 
	
	;==================================================
	
	GG    eax, ebx, ecx, edx, esi+(01*4), 05, 0f61e2562h 
	GG    edx, eax, ebx, ecx, esi+(06*4), 09, 0c040b340h 
	GG    ecx, edx, eax, ebx, esi+(11*4), 14, 0265e5a51h 
	GG    ebx, ecx, edx, eax, esi+(00*4), 20, 0e9b6c7aah 
	
	GG    eax, ebx, ecx, edx, esi+(05*4), 05, 0d62f105dh
	GG    edx, eax, ebx, ecx, esi+(10*4), 09, 002441453h
	GG    ecx, edx, eax, ebx, esi+(15*4), 14, 0d8a1e681h
	GG    ebx, ecx, edx, eax, esi+(04*4), 20, 0e7d3fbc8h
	
	GG    eax, ebx, ecx, edx, esi+(09*4), 05, 021e1cde6h
	GG    edx, eax, ebx, ecx, esi+(14*4), 09, 0c33707d6h
	GG    ecx, edx, eax, ebx, esi+(03*4), 14, 0f4d50d87h
	GG    ebx, ecx, edx, eax, esi+(08*4), 20, 0455a14edh
	
	GG    eax, ebx, ecx, edx, esi+(13*4), 05, 0a9e3e905h
	GG    edx, eax, ebx, ecx, esi+(02*4), 09, 0fcefa3f8h
	GG    ecx, edx, eax, ebx, esi+(07*4), 14, 0676f02d9h
	GG    ebx, ecx, edx, eax, esi+(12*4), 20, 08d2a4c8ah
	
	;==================================================
	
	HH    eax, ebx, ecx, edx, esi+(05*4), 04, 0fffa3942h
	HH    edx, eax, ebx, ecx, esi+(08*4), 11, 08771f681h
	HH    ecx, edx, eax, ebx, esi+(11*4), 16, 06d9d6122h
	HH    ebx, ecx, edx, eax, esi+(14*4), 23, 0fde5380ch
	
	HH    eax, ebx, ecx, edx, esi+(01*4), 04, 0a4beea44h
	HH    edx, eax, ebx, ecx, esi+(04*4), 11, 04bdecfa9h
	HH    ecx, edx, eax, ebx, esi+(07*4), 16, 0f6bb4b60h
	HH    ebx, ecx, edx, eax, esi+(10*4), 23, 0bebfbc70h
	
	HH    eax, ebx, ecx, edx, esi+(13*4), 04, 0289b7ec6h
	HH    edx, eax, ebx, ecx, esi+(00*4), 11, 0eaa127fah
	HH    ecx, edx, eax, ebx, esi+(03*4), 16, 0d4ef3085h
	HH    ebx, ecx, edx, eax, esi+(06*4), 23, 004881d05h
	
	HH    eax, ebx, ecx, edx, esi+(09*4), 04, 0d9d4d039h
	HH    edx, eax, ebx, ecx, esi+(12*4), 11, 0e6db99e5h
	HH    ecx, edx, eax, ebx, esi+(15*4), 16, 01fa27cf8h
	HH    ebx, ecx, edx, eax, esi+(02*4), 23, 0c4ac5665h
	
	;==================================================
	
	II    eax, ebx, ecx, edx, esi+(00*4), 06, 0f4292244h 
	II    edx, eax, ebx, ecx, esi+(07*4), 10, 0432aff97h
	II    ecx, edx, eax, ebx, esi+(14*4), 15, 0ab9423a7h
	II    ebx, ecx, edx, eax, esi+(05*4), 21, 0fc93a039h
	
	II    eax, ebx, ecx, edx, esi+(12*4), 06, 0655b59c3h 
	II    edx, eax, ebx, ecx, esi+(03*4), 10, 08f0ccc92h
	II    ecx, edx, eax, ebx, esi+(10*4), 15, 0ffeff47dh
	II    ebx, ecx, edx, eax, esi+(01*4), 21, 085845dd1h
	
	II    eax, ebx, ecx, edx, esi+(08*4), 06, 06fa87e4fh
	II    edx, eax, ebx, ecx, esi+(15*4), 10, 0fe2ce6e0h
	II    ecx, edx, eax, ebx, esi+(06*4), 15, 0a3014314h
	II    ebx, ecx, edx, eax, esi+(13*4), 21, 04e0811a1h
	
	II    eax, ebx, ecx, edx, esi+(04*4), 06, 0f7537e82h
	II    edx, eax, ebx, ecx, esi+(11*4), 10, 0bd3af235h
	II    ecx, edx, eax, ebx, esi+(02*4), 15, 02ad7d2bbh
	II    ebx, ecx, edx, eax, esi+(09*4), 21, 0eb86d391h
	
	;==================================================
	
	mov  edi, [state]
	
	add   [edi + (00*04)], eax
	add   [edi + (01*04)], ebx
	add   [edi + (02*04)], ecx
	add   [edi + (03*04)], edx
	
	dec   dword ptr [loop_counter]
	
	lea  esi, [esi + 64]
	
	jns   transform_block
	
	ret
MD5Transform ENDP

IFDEF COMPILE_MODULE_IE

IFDEF GRAB_HTTP

.data?
	SHA1_HASH_BUF dd 5 dup (?)
	SHA1_WORK_BUF dd 80 dup (?)

.code

SHA1Data proc uses edi esi ebx input_data, file_size, out_hash
	LOCAL	input_data_pos: DWORD
	LOCAL	fSzeL: DWORD
	
	mov	input_data_pos, 0
	m2m	fSzeL, file_size
	
	mov SHA1_HASH_BUF[ 0],067452301h
	mov SHA1_HASH_BUF[ 4],0EFCDAB89h
	mov SHA1_HASH_BUF[ 8],098BADCFEh
	mov SHA1_HASH_BUF[12],010325476h
	mov SHA1_HASH_BUF[16],0C3D2E1F0h
	
	jmp mNx
mLp:
	mov	eax, input_data
	add	eax, input_data_pos
	invoke	MoveMem, eax, offset SHA1_WORK_BUF, 64
	add	input_data_pos, 64 
	
	call SHA1HashMessage

mNx:
	sub fSzeL,64
	jnb mLp
	
	mov ebx,fSzeL
	add ebx,64
	
	mov	eax, input_data
	add	eax, input_data_pos
	invoke	MoveMem, eax, offset SHA1_WORK_BUF, ebx
	add	input_data_pos, ebx
	
	mov byte ptr SHA1_WORK_BUF[ebx],80h
	
	sub ebx,64-(8+1)
	jbe mZo
	
	sub ebx,8
	jz  mHm
	
mFz:
	and byte ptr SHA1_WORK_BUF[64][ebx],0	
	inc ebx
	js  mFz
	
mHm:
	call SHA1HashMessage
	mov ebx,-56	
	jmp mFl
	
mZo:
	jz  mSz
	
mFl:
	and byte ptr SHA1_WORK_BUF[64-8][ebx],0
	inc ebx
	js  mFl

mSz:
	mov eax, file_size
	mov ecx,8
	xor edx,edx
	mul ecx
	
	bswap eax
	bswap edx
	mov SHA1_WORK_BUF[15*4],eax
	mov SHA1_WORK_BUF[14*4],edx
	call SHA1HashMessage
	
	mov eax,SHA1_HASH_BUF[0]
	mov edx,SHA1_HASH_BUF[4]
	mov ecx,SHA1_HASH_BUF[8]
	bswap eax
	bswap edx
	bswap ecx
	mov SHA1_HASH_BUF[0],eax
	mov SHA1_HASH_BUF[4],edx
	mov SHA1_HASH_BUF[8],ecx
	
	mov eax,SHA1_HASH_BUF[12]
	mov edx,SHA1_HASH_BUF[16]
	bswap eax
	bswap edx
	mov SHA1_HASH_BUF[12],eax
	mov SHA1_HASH_BUF[16],edx
	
	invoke MoveMem, offset SHA1_HASH_BUF, out_hash, 20
	
	ret
SHA1Data endp

SHA1HashMessage proc
	LOCAL	D: DWORD
	LOCAL	E: DWORD
	
	mov ecx,-8
	sLp:mov eax,SHA1_WORK_BUF[16*4][ecx*8]
		mov edx,SHA1_WORK_BUF[16*4][ecx*8][4]
		bswap eax
		bswap edx
		mov SHA1_WORK_BUF[16*4][ecx*8],eax
		mov SHA1_WORK_BUF[16*4][ecx*8][4],edx
	inc ecx
	jnz sLp

	mov ecx,16-80
	tLp:mov eax,SHA1_WORK_BUF[(80-3)*4][ecx*4]
		mov edx,SHA1_WORK_BUF[(80-8)*4][ecx*4]
		xor eax,SHA1_WORK_BUF[(80-14)*4][ecx*4]
		xor edx,SHA1_WORK_BUF[(80-16)*4][ecx*4]
		xor eax,edx
		rol eax,1
		mov SHA1_WORK_BUF[80*4][ecx*4],eax
	inc ecx
	jnz tLp
	
	mov ebx,SHA1_HASH_BUF[0]	;A
	mov esi,SHA1_HASH_BUF[4]	;B
	mov edi,SHA1_HASH_BUF[8]	;C
	m2m D,SHA1_HASH_BUF[12]	;D
	m2m E,SHA1_HASH_BUF[16]     ;E

	mov ecx,-20
	aLp:mov edx,esi
		mov eax,edi
		not edx
		and eax,esi
		and edx,D
		or  eax,edx
		add eax,SHA1_WORK_BUF[20*4][ecx*4]
		add eax,E
		add eax,05A827999h
		m2m E,D
		mov D,edi
		rol esi,30
		mov edi,esi
		mov esi,ebx	
		rol ebx,5
		add ebx,eax
	inc ecx
	jnz aLp		

	mov ecx,-20
	bLp:mov eax,esi
		mov edx,edi
		xor eax,D
		xor eax,edx
		add eax,SHA1_WORK_BUF[40*4][ecx*4]
		add eax,E
		add eax,06ED9EBA1h
		m2m E,D
		mov D,edi
		rol esi,30
		mov edi,esi
		mov esi,ebx	
		rol ebx,5
		add ebx,eax
	inc ecx
	jnz bLp		

	mov ecx,-20
	cLp:mov eax,edi
		mov edx,D
		or  eax,D
		and edx,edi
		and eax,esi
		or  eax,edx
		add eax,SHA1_WORK_BUF[60*4][ecx*4]
		add eax,E
		add eax,08F1BBCDCh
		m2m E,D
		mov D,edi
		rol esi,30
		mov edi,esi
		mov esi,ebx	
		rol ebx,5
		add ebx,eax
	inc ecx
	jnz cLp		

	mov ecx,-20
	dLp:mov eax,esi
		mov edx,edi
		xor eax,D
		xor eax,edx
		add eax,SHA1_WORK_BUF[80*4][ecx*4]
		add eax,E
		add eax,0CA62C1D6h
		m2m E,D
		mov D,edi
		rol esi,30
		mov edi,esi
		mov esi,ebx	
		rol ebx,5
		add ebx,eax
	inc ecx
	jnz dLp	

	add SHA1_HASH_BUF[0],ebx
	add SHA1_HASH_BUF[4],esi
	add SHA1_HASH_BUF[8],edi
	mov eax, D
	add SHA1_HASH_BUF[12],eax
	mov eax, E
	add SHA1_HASH_BUF[16], eax
	
	ret
SHA1HashMessage endp

ENDIF 
ENDIF