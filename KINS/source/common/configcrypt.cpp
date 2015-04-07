#include <Windows.h>
#include <intrin.h>
#include "configcrypt.h"
#include "mem.h"
#include "crypt.h"
#include "LdrConfig.h"

#pragma intrinsic(_rotl8, _rotl16, _rotl)
#pragma intrinsic(_rotr8, _rotr16, _rotr)

typedef struct  
{
	LPBYTE eip;
	LPBYTE edi;
	DWORD  ecx;
	DWORD r[16];	// general purpose registers, 16 so index fits into 4 bits (can set src, dest registers in single byte)
					// destination register in such cases takes lower 4 bits
} DEC_CONTEXT;

/*
	IN/OUT ctx - VM's context.

	Return - true to continue execution,
			 false to indicate that this was end instruction.
*/
typedef bool (*LPVMHANDLER)(DEC_CONTEXT *ctx);

enum
{
	// MAGIC_CONSTS_BEGIN
	magic_nop_BYTE = 0x01,
	magic_nop_WORD = 0x2E,
	magic_nop_DWORD = 0xEF,
	magic_xor_BYTE = 0xDF,
	magic_xor_WORD = 0x38,
	magic_xor_DWORD = 0xE7,
	magic_add_BYTE = 0x3F,
	magic_add_WORD = 0x7B,
	magic_add_DWORD = 0xE5,
	magic_sub_BYTE = 0x3E,
	magic_sub_WORD = 0x23,
	magic_sub_DWORD = 0xF8,
	magic_rol_BYTE = 0xC4,
	magic_rol_WORD = 0xE9,
	magic_rol_DWORD = 0xA5,
	magic_ror_BYTE = 0x55,
	magic_ror_WORD = 0x1C,
	magic_ror_DWORD = 0x84,
	magic_not_BYTE = 0x1C,
	magic_not_WORD = 0x6D,
	magic_not_DWORD = 0xB4,
	magic_reorder = 0xA2,
	magic_setecx_BYTE = 0xD8,
	magic_setecx_WORD = 0x5B,
	magic_setecx_DWORD = 0xAE,
	magic_setedi = 0x17,
	magic_loop_BYTE = 0x87,
	magic_loop_WORD = 0xEA,
	magic_rc4 = 0xDA,
	magic_mov_r_const_BYTE = 0xA5,
	magic_mov_r_const_WORD = 0x10,
	magic_mov_r_const_DWORD = 0x83,
	magic_mov_r_r_BYTE = 0x15,
	magic_mov_r_r_WORD = 0x67,
	magic_mov_r_r_DWORD = 0xAE,
	magic_add_r_const_BYTE = 0x4C,
	magic_add_r_const_WORD = 0x55,
	magic_add_r_const_DWORD = 0x4B,
	magic_add_r_r_BYTE = 0x3F,
	magic_add_r_r_WORD = 0xE1,
	magic_add_r_r_DWORD = 0x9F,
	magic_sub_r_const_BYTE = 0x9C,
	magic_sub_r_const_WORD = 0x44,
	magic_sub_r_const_DWORD = 0xC5,
	magic_sub_r_r_BYTE = 0x69,
	magic_sub_r_r_WORD = 0x7D,
	magic_sub_r_r_DWORD = 0x72,
	magic_xor_r_const_BYTE = 0xAA,
	magic_xor_r_const_WORD = 0x14,
	magic_xor_r_const_DWORD = 0x06,
	magic_xor_r_r_BYTE = 0xF9,
	magic_xor_r_r_WORD = 0xBE,
	magic_xor_r_r_DWORD = 0x07,
	magic_lods_BYTE = 0x7B,
	magic_lods_WORD = 0x2E,
	magic_lods_DWORD = 0x5C,
	magic_stos_BYTE = 0x91,
	magic_stos_WORD = 0x0A,
	magic_stos_DWORD = 0x4F,
	magic_stos_add_BYTE = 0x8B,
	magic_stos_add_WORD = 0x8A,
	magic_stos_add_DWORD = 0x2E,
	magic_stos_sub_BYTE = 0x8D,
	magic_stos_sub_WORD = 0xDC,
	magic_stos_sub_DWORD = 0x2F,
	magic_stos_xor_BYTE = 0xE2,
	magic_stos_xor_WORD = 0x32,
	magic_stos_xor_DWORD = 0xCD,
	// MAGIC_CONSTS_END
};

//////////////////////////////////////////////////////////////////////////
//                           VM handlers                                //
//////////////////////////////////////////////////////////////////////////

char szDbgMsg[100] = "";
LPBYTE bEdiBase;
#ifdef BUILDER
#define DebugDump() wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx); OutputDebugStringA(szDbgMsg);
#else
#define DebugDump()
#endif

// NOP's, byte/word/dword sized
#ifdef BUILDER
#define instr_nop(size) \
	static bool instr_nop_##size(DEC_CONTEXT *ctx) { \
		DebugDump(); \
		ctx->eip += sizeof(size); \
		return true; \
	}
#else
#define CRYPT_OFFSET_NOP_BYTE  0
#define CRYPT_OFFSET_NOP_WORD  1
#define CRYPT_OFFSET_NOP_DWORD 1
#define instr_nop(size) \
	static bool instr_nop_##size(DEC_CONTEXT *ctx) { \
		BYTE bXorKey = ctx->eip[CRYPT_OFFSET_NOP_##size] ^ magic_nop_##size;	\
		ctx->eip += sizeof(size); \
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true; \
	}
#endif

instr_nop(BYTE);
instr_nop(WORD);
instr_nop(DWORD);

// terminates VM's execution
static bool instr_leave(DEC_CONTEXT *ctx)
{
	//ctx->eip++;
	DebugDump();
	return false;
}

// XOR's, byte/word/dword sized
#ifdef BUILDER
#define instr_xor(size) \
	static bool instr_xor_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; %X ^= %X (%X)\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, *(size*)ctx->edi, *(size*)(ctx->eip + 1), *(size*)(ctx->eip + 1) ^ *(size*)ctx->edi);		\
		OutputDebugStringA(szDbgMsg); \
		ctx->eip++;	\
		*(size*)ctx->edi ^= *(size*)ctx->eip;	\
		ctx->edi += sizeof(size);	\
		ctx->eip += sizeof(size);	\
		return true;	\
	}
#else
#define instr_xor(size) \
	static bool instr_xor_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[1] ^ magic_xor_##size;	\
		ctx->eip++;	\
		*(size*)ctx->edi ^= *(size*)ctx->eip;	\
		ctx->edi += sizeof(size);	\
		ctx->eip += sizeof(size);	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_xor(BYTE);
instr_xor(WORD);
instr_xor(DWORD);

// ADD's, byte/word/dword sized
#ifdef BUILDER
#define instr_add(size) \
	static bool instr_add_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; %X += %X (%X)\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, *(size*)ctx->edi, *(size*)(ctx->eip + 1), *(size*)(ctx->eip + 1) + *(size*)ctx->edi);		\
		OutputDebugStringA(szDbgMsg); \
		ctx->eip++;	\
		*(size*)ctx->edi += *(size*)ctx->eip;	\
		ctx->edi += sizeof(size);	\
		ctx->eip += sizeof(size);	\
		return true;	\
	}
#else
#define instr_add(size) \
	static bool instr_add_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[1] ^ magic_add_##size;	\
		ctx->eip++;	\
		*(size*)ctx->edi += *(size*)ctx->eip;	\
		ctx->edi += sizeof(size);	\
		ctx->eip += sizeof(size);	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_add(BYTE);
instr_add(WORD);
instr_add(DWORD);

// subtract, byte/word/dword sized
#ifdef BUILDER
#define instr_sub(size) \
	static bool instr_sub_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; %X -= %X (%X)\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, *(size*)ctx->edi, *(size*)(ctx->eip + 1), *(size*)ctx->edi - *(size*)(ctx->eip + 1));		\
		OutputDebugStringA(szDbgMsg); \
		ctx->eip++;	\
		*(size*)ctx->edi -= *(size*)ctx->eip;	\
		ctx->edi += sizeof(size);	\
		ctx->eip += sizeof(size);	\
		return true;	\
	}
#else
#define instr_sub(size) \
	static bool instr_sub_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[1] ^ magic_sub_##size;	\
		ctx->eip++;	\
		*(size*)ctx->edi -= *(size*)ctx->eip;	\
		ctx->edi += sizeof(size);	\
		ctx->eip += sizeof(size);	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_sub(BYTE);
instr_sub(WORD);
instr_sub(DWORD);

// ROL's byte/word/dword sized, argument adjusted accordingly
static bool instr_rol_BYTE(DEC_CONTEXT *ctx)
{
#ifndef BUILDER
	BYTE bXorKey = ctx->eip[1] ^ magic_rol_BYTE;
#endif
	BYTE bArg = ctx->eip[1] & 7;
#ifdef BUILDER
	wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; ROL(%X, %X) = %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, *ctx->edi, bArg, _rotl8(*ctx->edi, bArg));	
	OutputDebugStringA(szDbgMsg);
#endif
	ctx->eip += 2;
	*ctx->edi = _rotl8(*ctx->edi, bArg);
	ctx->edi++;
#ifndef BUILDER
	if(*ctx->eip & 0x80)
		*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;
#endif
	return true;
}

static bool instr_rol_WORD(DEC_CONTEXT *ctx)
{
#ifndef BUILDER
	BYTE bXorKey = ctx->eip[1] ^ magic_rol_WORD;
#endif
	BYTE bArg = ctx->eip[1] & 15;
#ifdef BUILDER
	wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; ROL(%X, %X) = %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, *(WORD*)ctx->edi, bArg, _rotl16(*(WORD*)ctx->edi, bArg));
	OutputDebugStringA(szDbgMsg);
#endif
	ctx->eip += 2;
	*(WORD*)ctx->edi = _rotl16(*(WORD*)ctx->edi, bArg);
	ctx->edi += 2;
#ifndef BUILDER
	if(*ctx->eip & 0x80)
		*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;
#endif
	return true;
}

static bool instr_rol_DWORD(DEC_CONTEXT *ctx)
{
#ifndef BUILDER
	BYTE bXorKey = ctx->eip[1] ^ magic_rol_DWORD;
#endif
	BYTE bArg = ctx->eip[1] & 31;
#ifdef BUILDER
	wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; ROL(%X, %X) = %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, *(DWORD*)ctx->edi, bArg, _rotl(*(DWORD*)ctx->edi, bArg));
	OutputDebugStringA(szDbgMsg);
#endif
	ctx->eip += 2;
	*(DWORD*)ctx->edi = _rotl(*(DWORD*)ctx->edi, bArg);
	ctx->edi += 4;
#ifndef BUILDER
	if(*ctx->eip & 0x80)
		*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;
#endif
	return true;
}

// ROR's byte/word/dword sized, argument adjusted accordingly
static bool instr_ror_BYTE(DEC_CONTEXT *ctx)
{
#ifndef BUILDER
	BYTE bXorKey = ctx->eip[1] ^ magic_ror_BYTE;
#endif
	BYTE bArg = ctx->eip[1] & 7;
#ifdef BUILDER
	wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; ROR(%X, %X) = %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, *ctx->edi, bArg, _rotr8(*ctx->edi, bArg));
	OutputDebugStringA(szDbgMsg);
#endif
	ctx->eip += 2;
	*ctx->edi = _rotr8(*ctx->edi, bArg);
	ctx->edi++;
#ifndef BUILDER
	if(*ctx->eip & 0x80)
		*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;
#endif
	return true;
}

static bool instr_ror_WORD(DEC_CONTEXT *ctx)
{
#ifndef BUILDER
	BYTE bXorKey = ctx->eip[1] ^ magic_ror_WORD;
#endif
	BYTE bArg = ctx->eip[1] & 15;
#ifdef BUILDER
	wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; ROR(%X, %X) = %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, *(WORD*)ctx->edi, bArg, _rotr16(*(WORD*)ctx->edi, bArg));
	OutputDebugStringA(szDbgMsg);
#endif
	ctx->eip += 2;
	*(WORD*)ctx->edi = _rotr16(*(WORD*)ctx->edi, bArg);
	ctx->edi += 2;
#ifndef BUILDER
	if(*ctx->eip & 0x80)
		*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;
#endif
	return true;
}

static bool instr_ror_DWORD(DEC_CONTEXT *ctx)
{
#ifndef BUILDER
	BYTE bXorKey = ctx->eip[1] ^ magic_ror_DWORD;
#endif
	BYTE bArg = ctx->eip[1] & 31;
#ifdef BUILDER
	wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; ROR(%X, %X) = %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, *(DWORD*)ctx->edi, bArg, _rotr(*(DWORD*)ctx->edi, bArg));
	OutputDebugStringA(szDbgMsg);
#endif
	ctx->eip += 2;
	*(DWORD*)ctx->edi = _rotr(*(DWORD*)ctx->edi, bArg);
	ctx->edi += 4;
#ifndef BUILDER
	if(*ctx->eip & 0x80)
		*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;
#endif
	return true;
}

// NOT's, byte/word/dword sized
#ifdef BUILDER
#define instr_not(size) \
	static bool instr_not_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; %X = ~%X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, *(size*)ctx->edi, ~(*(size*)ctx->edi));	\
		OutputDebugStringA(szDbgMsg);	\
		ctx->eip++;	\
		*(size*)ctx->edi = ~(*(size*)ctx->edi);	\
		ctx->edi += sizeof(size);	\
		return true;	\
	}
#else
#define instr_not(size) \
	static bool instr_not_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[0] ^ magic_not_##size;	\
		ctx->eip++;	\
		*(size*)ctx->edi = ~(*(size*)ctx->edi);	\
		ctx->edi += sizeof(size);	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_not(BYTE);
instr_not(WORD);
instr_not(DWORD);

// REORDER, shuffles 4 BYTEs pointed to by EDI,
//		    byte sized argument, each 2 bits represent new
//			position for byte corresponding to these 2 bits
//			to make sure argument is valid it should be generated by
//			generate_reorder_arg function

static bool instr_reorder(DEC_CONTEXT *ctx)
{
#ifndef BUILDER
	BYTE bXorKey = ctx->eip[1] ^ magic_reorder;
#endif
	BYTE bArg = ctx->eip[1];
	DWORD dwData = *(DWORD*)ctx->edi;
	DWORD dwOriginalData = dwData;
	for(int i = 0; i < 4; i++)
	{
		BYTE bPos   = bArg & 3;      bArg   >>= 2;
		BYTE bValue = dwData & 0xFF; dwData >>= 8;
		ctx->edi[bPos] = bValue;
	}

#ifdef BUILDER
	wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; REORDER(%X, %X) = %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, dwOriginalData, ctx->eip[1], *(DWORD*)ctx->edi);
	OutputDebugStringA(szDbgMsg);
#endif

	ctx->edi += 4;
	ctx->eip += 2;
#ifndef BUILDER
	if(*ctx->eip & 0x80)
		*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;
#endif
	return true;
}

#ifdef BUILDER

// DEREORDER, inverse of the above, should be used only by builder when generating bytecode
static bool instr_dereorder(DEC_CONTEXT *ctx)
{
	BYTE bArg = ctx->eip[1];
	DWORD dwData = *(DWORD*)ctx->edi;
	for(int i = 0; i < 4; i++)
	{
		BYTE bPos   = bArg & 3; bArg >>= 2;
		BYTE bValue = (dwData & (0xFF << (bPos * 8))) >> (bPos * 8);
		
		ctx->edi[i] = bValue;
	}

	wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; DEREORDER(%X, %X) = %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, dwData, ctx->eip[1], *(DWORD*)ctx->edi);
	OutputDebugStringA(szDbgMsg);

	ctx->edi += 4;
	ctx->eip += 2;
	return true;
}

BYTE generate_reorder_arg(BYTE seed)
{
	BYTE bResult = seed;
	bool bUsedPositions[4] = {false, false, false, false};
	for(int i = 0; i < 4; i++)
	{
		BYTE bPos = (bResult & (3 << (i * 2))) >> (i * 2);
		if(!bUsedPositions[bPos])
		{
			bUsedPositions[bPos] = true;
		}
		else	// need to adjust
		{
			bPos = 0; 
			while(bUsedPositions[bPos])
				bPos++;

			bUsedPositions[bPos] = true;
			bResult = (bResult & ~(3 << (i * 2))) | (bPos << (i * 2));
		}
	}

	return bResult;
}
#endif

// SET_ECX sets loop counter
#ifdef BUILDER
#define instr_setecx(size) \
	static bool instr_setecx_##size(DEC_CONTEXT *ctx) {	\
		DebugDump();	\
		ctx->eip++;	\
		ctx->ecx = *(size*)ctx->eip;	\
		ctx->eip += sizeof(size);	\
		return true;	\
	}
#else
#define instr_setecx(size) \
	static bool instr_setecx_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[1] ^ magic_setecx_##size;	\
		ctx->eip++;	\
		ctx->ecx = *(size*)ctx->eip;	\
		ctx->eip += sizeof(size);	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif
instr_setecx(BYTE);
instr_setecx(WORD);
instr_setecx(DWORD);

// SET_EDI sets edi relative to current position
static bool instr_setedi_SHORT(DEC_CONTEXT *ctx)
{
#ifndef BUILDER
	BYTE bXorKey = ctx->eip[1] ^ magic_setedi;
#endif
	DebugDump();
	ctx->eip++;
	ctx->edi += *(signed short*)ctx->eip;
	ctx->eip += 2;
#ifndef BUILDER
	if(*ctx->eip & 0x80)
		*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;
#endif
	return true;
}

// LOOP, moves eip back and decreases ecx if ecx != 0, does nothing otherwise
#ifdef BUILDER
#define instr_loop(size) \
	static bool instr_loop_##size(DEC_CONTEXT *ctx) { \
		DebugDump();	\
		ctx->eip++;		\
		if(ctx->ecx != 0) {	\
			ctx->ecx--;	\
			ctx->eip = ctx->eip + sizeof(size) - *(size*)ctx->eip;	\
		} else	\
			ctx->eip += sizeof(size);	\
		return true;	\
	}
#else
#define instr_loop(size) \
	static bool instr_loop_##size(DEC_CONTEXT *ctx) { \
		BYTE bXorKey = ctx->eip[1] ^ magic_loop_##size;	\
		if(ctx->eip[1 + sizeof(size)] & 0x80)	\
			ctx->eip[1 + sizeof(size)] = (ctx->eip[1 + sizeof(size)] ^ bXorKey) & 0x7F;	\
		ctx->eip++;		\
		if(ctx->ecx != 0) {	\
			ctx->ecx--;	\
			ctx->eip = ctx->eip + sizeof(size) - *(size*)ctx->eip;	\
		} else	\
			ctx->eip += sizeof(size);	\
		return true;	\
	}
#endif
instr_loop(BYTE);
instr_loop(WORD);

// RC4, encrypts/decrypts n bytes pointed by EDI by x bytes long key
static bool instr_rc4_crypt(DEC_CONTEXT *ctx)
{
#ifdef BUILDER
	wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; KEY=%X, DATA=%X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, ctx->eip[1], ctx->eip[2]);
	OutputDebugStringA(szDbgMsg);
#else
	BYTE bXorKey = ctx->eip[3] ^ magic_rc4;
#endif
	Crypt::RC4KEY key;
	BYTE bKeySize  = ctx->eip[1];
	BYTE bDataSize = ctx->eip[2];
	Crypt::_rc4Init(ctx->eip + 3, bKeySize, &key);
	Crypt::_rc4(ctx->edi, bDataSize, &key);
	ctx->edi += bDataSize;
	ctx->eip += 3 + bKeySize;
#ifndef BUILDER
	if(*ctx->eip & 0x80)
		*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;
#endif
	return true;
}

// instructions that use general purpose registers

// Rx = const;
#ifdef BUILDER
#define instr_mov_r_const(size) \
	static bool instr_mov_r_const_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; R%d=%X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, ctx->eip[1], *(size*)(ctx->eip + 2));	\
		OutputDebugStringA(szDbgMsg);	\
		ctx->r[ctx->eip[1] & 0xF] = *(size*)(ctx->eip + 2);	\
		ctx->eip += 2 + sizeof(size);	\
		return true;	\
	}
#else
#define instr_mov_r_const(size) \
	static bool instr_mov_r_const_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[2] ^ magic_mov_r_const_##size;	\
		ctx->r[ctx->eip[1] & 0xF] = *(size*)(ctx->eip + 2);	\
		ctx->eip += 2 + sizeof(size);	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif
instr_mov_r_const(BYTE);
instr_mov_r_const(WORD);
instr_mov_r_const(DWORD);

// Rx = Ry, lower than 32 bit size operations do not preserve destination's higher bits, they get set to 0
#ifdef BUILDER
#define instr_mov_r_r(size) \
	static bool instr_mov_r_r_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; R%d=R%d=%X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, ctx->eip[1] & 0xF, ctx->eip[1] >> 4, (size)ctx->r[ctx->eip[1] >> 4]);	\
		OutputDebugStringA(szDbgMsg);	\
		ctx->r[ctx->eip[1] & 0xF] = (size)ctx->r[ctx->eip[1] >> 4];	\
		ctx->eip += 2;	\
		return true;	\
	}
#else
#define instr_mov_r_r(size) \
	static bool instr_mov_r_r_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[1] ^ magic_mov_r_r_##size;	\
		ctx->r[ctx->eip[1] & 0xF] = (size)ctx->r[ctx->eip[1] >> 4];	\
		ctx->eip += 2;	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_mov_r_r(BYTE);
instr_mov_r_r(WORD);
instr_mov_r_r(DWORD);

// Rx += Ry
#ifdef BUILDER
#define instr_add_r_r(size) \
	static bool instr_add_r_r_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; R%d(%X)+=R%d(%X), %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, ctx->eip[1] & 0xF, ctx->r[ctx->eip[1] & 0xF], ctx->eip[1] >> 4, (size)ctx->r[ctx->eip[1] >> 4], ctx->r[ctx->eip[1] & 0xF] + (size)ctx->r[ctx->eip[1] >> 4]);	\
		OutputDebugStringA(szDbgMsg);	\
		ctx->r[ctx->eip[1] & 0xF] += (size)ctx->r[ctx->eip[1] >> 4];	\
		ctx->eip += 2;	\
		return true;	\
	}
#else
#define instr_add_r_r(size) \
	static bool instr_add_r_r_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[1] ^ magic_add_r_r_##size;	\
		ctx->r[ctx->eip[1] & 0xF] += (size)ctx->r[ctx->eip[1] >> 4];	\
		ctx->eip += 2;	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_add_r_r(BYTE);
instr_add_r_r(WORD);
instr_add_r_r(DWORD);

// Rx += const;
#ifdef BUILDER
#define instr_add_r_const(size) \
	static bool instr_add_r_const_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; R%d(%X)+=%X, %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, ctx->eip[1] & 0xF, ctx->r[ctx->eip[1] & 0xF], *(size*)(ctx->eip + 2), ctx->r[ctx->eip[1] & 0xF] + *(size*)(ctx->eip + 2));	\
		OutputDebugStringA(szDbgMsg);	\
		ctx->r[ctx->eip[1] & 0xF] += *(size*)(ctx->eip + 2);	\
		ctx->eip += 2 + sizeof(size);	\
		return true;	\
	}
#else
#define instr_add_r_const(size) \
	static bool instr_add_r_const_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[2] ^ magic_add_r_const_##size;	\
		ctx->r[ctx->eip[1] & 0xF] += *(size*)(ctx->eip + 2);	\
		ctx->eip += 2 + sizeof(size);	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_add_r_const(BYTE);
instr_add_r_const(WORD);
instr_add_r_const(DWORD);

// Rx -= Ry
#ifdef BUILDER
#define instr_sub_r_r(size) \
	static bool instr_sub_r_r_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; R%d(%X)-=R%d(%X), %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, ctx->eip[1] & 0xF, ctx->r[ctx->eip[1] & 0xF], ctx->eip[1] >> 4, (size)ctx->r[ctx->eip[1] >> 4], ctx->r[ctx->eip[1] & 0xF] - (size)ctx->r[ctx->eip[1] >> 4]);	\
		OutputDebugStringA(szDbgMsg);	\
		ctx->r[ctx->eip[1] & 0xF] -= (size)ctx->r[ctx->eip[1] >> 4];	\
		ctx->eip += 2;	\
		return true;	\
	}
#else
#define instr_sub_r_r(size) \
	static bool instr_sub_r_r_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[1] ^ magic_sub_r_r_##size;	\
		ctx->r[ctx->eip[1] & 0xF] -= (size)ctx->r[ctx->eip[1] >> 4];	\
		ctx->eip += 2;	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_sub_r_r(BYTE);
instr_sub_r_r(WORD);
instr_sub_r_r(DWORD);

// Rx -= const;
#ifdef BUILDER
#define instr_sub_r_const(size) \
	static bool instr_sub_r_const_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; R%d(%X)-=%X, %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, ctx->eip[1] & 0xF, ctx->r[ctx->eip[1] & 0xF], *(size*)(ctx->eip + 2), ctx->r[ctx->eip[1] & 0xF] - *(size*)(ctx->eip + 2));	\
		OutputDebugStringA(szDbgMsg);	\
		ctx->r[ctx->eip[1] & 0xF] -= *(size*)(ctx->eip + 2);	\
		ctx->eip += 2 + sizeof(size);	\
		return true;	\
	}
#else
#define instr_sub_r_const(size) \
	static bool instr_sub_r_const_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[2] ^ magic_sub_r_const_##size;	\
		ctx->r[ctx->eip[1] & 0xF] -= *(size*)(ctx->eip + 2);	\
		ctx->eip += 2 + sizeof(size);	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_sub_r_const(BYTE);
instr_sub_r_const(WORD);
instr_sub_r_const(DWORD);

// Rx ^= Ry
#ifdef BUILDER
#define instr_xor_r_r(size) \
	static bool instr_xor_r_r_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; R%d(%X)^=R%d(%X), %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, ctx->eip[1] & 0xF, ctx->r[ctx->eip[1] & 0xF], ctx->eip[1] >> 4, (size)ctx->r[ctx->eip[1] >> 4], ctx->r[ctx->eip[1] & 0xF] ^ (size)ctx->r[ctx->eip[1] >> 4]);	\
		OutputDebugStringA(szDbgMsg);	\
		ctx->r[ctx->eip[1] & 0xF] ^= (size)ctx->r[ctx->eip[1] >> 4];	\
		ctx->eip += 2;	\
		return true;	\
	}
#else
#define instr_xor_r_r(size) \
	static bool instr_xor_r_r_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[1] ^ magic_xor_r_r_##size;	\
		ctx->r[ctx->eip[1] & 0xF] ^= (size)ctx->r[ctx->eip[1] >> 4];	\
		ctx->eip += 2;	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_xor_r_r(BYTE);
instr_xor_r_r(WORD);
instr_xor_r_r(DWORD);

// Rx ^= const;
#ifdef BUILDER
#define instr_xor_r_const(size) \
	static bool instr_xor_r_const_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; R%d(%X)^=%X, %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, ctx->eip[1] & 0xF, ctx->r[ctx->eip[1] & 0xF], *(size*)(ctx->eip + 2), ctx->r[ctx->eip[1] & 0xF] ^ *(size*)(ctx->eip + 2));	\
		OutputDebugStringA(szDbgMsg);	\
		ctx->r[ctx->eip[1] & 0xF] ^= *(size*)(ctx->eip + 2);	\
		ctx->eip += 2 + sizeof(size);	\
		return true;	\
	}
#else
#define instr_xor_r_const(size) \
	static bool instr_xor_r_const_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[2] ^ magic_xor_r_const_##size;	\
		ctx->r[ctx->eip[1] & 0xF] ^= *(size*)(ctx->eip + 2);	\
		ctx->eip += 2 + sizeof(size);	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_xor_r_const(BYTE);
instr_xor_r_const(WORD);
instr_xor_r_const(DWORD);

// Rx = *edi
#ifdef BUILDER
#define instr_lods(size) \
	static bool instr_lods_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; R%d=*edi(%X)\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, ctx->eip[1] & 0xF, *(size*)ctx->edi);	\
		OutputDebugStringA(szDbgMsg);	\
		ctx->r[ctx->eip[1] & 0xF] = *(size*)ctx->edi;	\
		ctx->eip += 2;	\
		return true;	\
	}
#else
#define instr_lods(size) \
	static bool instr_lods_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[1] ^ magic_lods_##size;	\
		ctx->r[ctx->eip[1] & 0xF] = *(size*)ctx->edi;	\
		ctx->eip += 2;	\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_lods(BYTE);
instr_lods(WORD);
instr_lods(DWORD);

// *edi = Rx
#ifdef BUILDER
#define instr_stos(size) \
	static bool instr_stos_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; *edi=R%d(%X)\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, ctx->eip[1] & 0xF, (size)ctx->r[ctx->eip[1] & 0xF]);	\
		OutputDebugStringA(szDbgMsg);	\
		*(size*)ctx->edi = (size)ctx->r[ctx->eip[1] & 0xF];	\
		ctx->eip += 2;	\
		ctx->edi += sizeof(size);	\
		return true;	\
	}
#else
#define instr_stos(size) \
	static bool instr_stos_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[1] ^ magic_stos_##size;	\
		*(size*)ctx->edi = (size)ctx->r[ctx->eip[1] & 0xF];	\
		ctx->eip += 2;	\
		ctx->edi += sizeof(size);\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_stos(BYTE);
instr_stos(WORD);
instr_stos(DWORD);

// *edi += Rx
#ifdef BUILDER
#define instr_stos_add(size) \
	static bool instr_stos_add_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; *edi(%X) += R%d(%X); %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, *(size*)ctx->edi, ctx->eip[1] & 0xF, (size)ctx->r[ctx->eip[1] & 0xF], *(size*)ctx->edi + (size)ctx->r[ctx->eip[1] & 0xF]);	\
		OutputDebugStringA(szDbgMsg);	\
		*(size*)ctx->edi += (size)ctx->r[ctx->eip[1] & 0xF];	\
		ctx->eip += 2;	\
		ctx->edi += sizeof(size);	\
		return true;	\
	}
#else
#define instr_stos_add(size) \
	static bool instr_stos_add_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[1] ^ magic_stos_add_##size;	\
		*(size*)ctx->edi += (size)ctx->r[ctx->eip[1] & 0xF];	\
		ctx->eip += 2;	\
		ctx->edi += sizeof(size);\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_stos_add(BYTE);
instr_stos_add(WORD);
instr_stos_add(DWORD);

#ifdef BUILDER
#define instr_stos_sub(size) \
	static bool instr_stos_sub_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; *edi(%X) -= R%d(%X); %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, *(size*)ctx->edi, ctx->eip[1] & 0xF, (size)ctx->r[ctx->eip[1] & 0xF], *(size*)ctx->edi - (size)ctx->r[ctx->eip[1] & 0xF]);	\
		OutputDebugStringA(szDbgMsg);	\
		*(size*)ctx->edi -= (size)ctx->r[ctx->eip[1] & 0xF];	\
		ctx->eip += 2;	\
		ctx->edi += sizeof(size);	\
		return true;	\
	}
#else
#define instr_stos_sub(size) \
	static bool instr_stos_sub_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[1] ^ magic_stos_sub_##size;	\
		*(size*)ctx->edi -= (size)ctx->r[ctx->eip[1] & 0xF];	\
		ctx->eip += 2;	\
		ctx->edi += sizeof(size);\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_stos_sub(BYTE);
instr_stos_sub(WORD);
instr_stos_sub(DWORD);

#ifdef BUILDER
#define instr_stos_xor(size) \
	static bool instr_stos_xor_##size(DEC_CONTEXT *ctx) {	\
		wsprintfA(szDbgMsg, "%X:"__FUNCTION__" edi=%X, ecx=%X; *edi(%X) ^= R%d(%X); %X\n", ctx->eip, ctx->edi - bEdiBase, ctx->ecx, *(size*)ctx->edi, ctx->eip[1] & 0xF, (size)ctx->r[ctx->eip[1] & 0xF], *(size*)ctx->edi ^ (size)ctx->r[ctx->eip[1] & 0xF]);	\
		OutputDebugStringA(szDbgMsg);	\
		*(size*)ctx->edi ^= (size)ctx->r[ctx->eip[1] & 0xF];	\
		ctx->eip += 2;	\
		ctx->edi += sizeof(size);	\
		return true;	\
	}
#else
#define instr_stos_xor(size) \
	static bool instr_stos_xor_##size(DEC_CONTEXT *ctx) {	\
		BYTE bXorKey = ctx->eip[1] ^ magic_stos_xor_##size;	\
		*(size*)ctx->edi ^= (size)ctx->r[ctx->eip[1] & 0xF];	\
		ctx->eip += 2;	\
		ctx->edi += sizeof(size);\
		if(*ctx->eip & 0x80)	\
			*ctx->eip = (*ctx->eip ^ bXorKey) & 0x7F;	\
		return true;	\
	}
#endif

instr_stos_xor(BYTE);
instr_stos_xor(WORD);
instr_stos_xor(DWORD);

// builder should shuffle these addresses
LPVMHANDLER handlers[255] = {instr_nop_BYTE, instr_nop_WORD, instr_nop_DWORD,
	instr_xor_BYTE, instr_xor_WORD, instr_xor_DWORD,
	instr_add_BYTE, instr_add_WORD, instr_add_DWORD,
	instr_sub_BYTE, instr_sub_WORD, instr_sub_DWORD,
	instr_rol_BYTE, instr_rol_WORD, instr_rol_DWORD,
	instr_ror_BYTE, instr_ror_WORD, instr_ror_DWORD,
	instr_not_BYTE, instr_not_WORD, instr_not_DWORD,
	instr_reorder, 
	instr_rc4_crypt,
	instr_setecx_BYTE, instr_setecx_WORD, instr_setecx_DWORD,
	instr_setedi_SHORT,
	instr_loop_BYTE, instr_loop_WORD,

	// instructions using general purpose registers
	instr_mov_r_const_BYTE, instr_mov_r_const_WORD, instr_mov_r_const_DWORD,
	instr_mov_r_r_BYTE, instr_mov_r_r_WORD, instr_mov_r_r_DWORD,
	instr_add_r_r_BYTE, instr_add_r_r_WORD, instr_add_r_r_DWORD,
	instr_sub_r_r_BYTE, instr_sub_r_r_WORD, instr_sub_r_r_DWORD,
	instr_xor_r_r_BYTE, instr_xor_r_r_WORD, instr_xor_r_r_DWORD,
	instr_add_r_const_BYTE, instr_add_r_const_WORD, instr_add_r_const_DWORD,
	instr_sub_r_const_BYTE, instr_sub_r_const_WORD, instr_sub_r_const_DWORD,
	instr_xor_r_const_BYTE, instr_xor_r_const_WORD, instr_xor_r_const_DWORD,

	instr_stos_add_BYTE, instr_stos_add_WORD, instr_stos_add_DWORD,
	instr_stos_sub_BYTE, instr_stos_sub_WORD, instr_stos_sub_DWORD,
	instr_stos_xor_BYTE, instr_stos_xor_WORD, instr_stos_xor_DWORD,

	instr_lods_BYTE, instr_lods_WORD, instr_lods_DWORD,
	instr_stos_BYTE, instr_stos_WORD, instr_stos_DWORD,

	instr_leave
};

void ConfigCrypt::DecryptConfig(LPBYTE lpBytecode, LPBYTE lpBufferToDecrypt)
{
	DEC_CONTEXT ctx;
	ctx.ecx = 0;
	ctx.edi = lpBufferToDecrypt;
	ctx.eip = lpBytecode;
	bEdiBase = lpBufferToDecrypt;

	while(handlers[*ctx.eip](&ctx))
	{
		;
	}
}

#ifdef BUILDER

typedef struct 
{
	BYTE bSize;
	BYTE bOperandSize;
	BYTE bDestSize;
	LPVMHANDLER handler;
	LPVMHANDLER inv_handler;
	BYTE bInverse;
	BYTE bXorKey;
	BYTE bRandOffset;
	// DWORD dwReserved; ?
}INSTR_DESC;

enum
{
	_instr_nop_BYTE, 
	_instr_nop_WORD, 
	_instr_nop_DWORD,
	_instr_xor_BYTE, 
	_instr_xor_WORD, 
	_instr_xor_DWORD,
	_instr_add_BYTE, 
	_instr_add_WORD, 
	_instr_add_DWORD,
	_instr_sub_BYTE, 
	_instr_sub_WORD, 
	_instr_sub_DWORD,
	_instr_rol_BYTE, 
	_instr_rol_WORD, 
	_instr_rol_DWORD,
	_instr_ror_BYTE, 
	_instr_ror_WORD, 
	_instr_ror_DWORD,
	_instr_not_BYTE, 
	_instr_not_WORD, 
	_instr_not_DWORD,
	_instr_reorder, 
	_instr_rc4_crypt,

	_instr_setecx_BYTE, 
	_instr_setecx_WORD, 
	_instr_setecx_DWORD,
	_instr_setedi_SHORT,
	_instr_loop_BYTE, 
	_instr_loop_WORD,

	//
	_instr_mov_r_const_BYTE, 
	_instr_mov_r_const_WORD, 
	_instr_mov_r_const_DWORD,
	_instr_mov_r_r_BYTE, 
	_instr_mov_r_r_WORD, 
	_instr_mov_r_r_DWORD,
	_instr_add_r_r_BYTE, 
	_instr_add_r_r_WORD, 
	_instr_add_r_r_DWORD,
	_instr_sub_r_r_BYTE, 
	_instr_sub_r_r_WORD, 
	_instr_sub_r_r_DWORD,
	_instr_xor_r_r_BYTE, 
	_instr_xor_r_r_WORD, 
	_instr_xor_r_r_DWORD,
	_instr_add_r_const_BYTE, 
	_instr_add_r_const_WORD, 
	_instr_add_r_const_DWORD,
	_instr_sub_r_const_BYTE, 
	_instr_sub_r_const_WORD, 
	_instr_sub_r_const_DWORD,
	_instr_xor_r_const_BYTE, 
	_instr_xor_r_const_WORD, 
	_instr_xor_r_const_DWORD,
	_instr_stos_add_BYTE, 
	_instr_stos_add_WORD, 
	_instr_stos_add_DWORD,
	_instr_stos_sub_BYTE, 
	_instr_stos_sub_WORD, 
	_instr_stos_sub_DWORD,
	_instr_stos_xor_BYTE, 
	_instr_stos_xor_WORD, 
	_instr_stos_xor_DWORD,
	_instr_lods_BYTE, 
	_instr_lods_WORD, 
	_instr_lods_DWORD,
	_instr_stos_BYTE, 
	_instr_stos_WORD, 
	_instr_stos_DWORD,

	_instr_leave,
	NR_OF_INSTRUCTIONS
};

INSTR_DESC instructions[NR_OF_INSTRUCTIONS] = {
	{ 1, 0, 0, instr_nop_BYTE, instr_nop_BYTE, _instr_nop_BYTE, magic_nop_BYTE, 0 },
	{ 2, 1, 0, instr_nop_WORD, instr_nop_WORD, _instr_nop_WORD, magic_nop_WORD, 1 },
	{ 4, 3, 0, instr_nop_DWORD, instr_nop_DWORD, _instr_nop_DWORD, magic_nop_DWORD, 1 },
	{ 2, 1, 1, instr_xor_BYTE, instr_xor_BYTE, _instr_xor_BYTE, magic_xor_BYTE, 1 },
	{ 3, 2, 2, instr_xor_WORD, instr_xor_WORD, _instr_xor_WORD, magic_xor_WORD, 1 },
	{ 5, 4, 4, instr_xor_DWORD, instr_xor_DWORD, _instr_xor_DWORD, magic_xor_DWORD, 1 },
	{ 2, 1, 1, instr_add_BYTE, instr_sub_BYTE, _instr_sub_BYTE, magic_add_BYTE, 1 },
	{ 3, 2, 2, instr_add_WORD, instr_sub_WORD, _instr_sub_WORD, magic_add_WORD, 1 },
	{ 5, 4, 4, instr_add_DWORD, instr_sub_DWORD, _instr_sub_DWORD, magic_add_DWORD, 1 },
	{ 2, 1, 1, instr_sub_BYTE, instr_add_BYTE, _instr_add_BYTE, magic_sub_BYTE, 1 },
	{ 3, 2, 2, instr_sub_WORD, instr_add_WORD, _instr_add_WORD, magic_sub_WORD, 1 },
	{ 5, 4, 4, instr_sub_DWORD, instr_add_DWORD, _instr_add_DWORD, magic_sub_DWORD, 1 },
	{ 2, 1, 1, instr_rol_BYTE, instr_ror_BYTE, _instr_ror_BYTE, magic_rol_BYTE, 1 },
	{ 2, 1, 2, instr_rol_WORD, instr_ror_WORD, _instr_ror_WORD, magic_rol_WORD, 1 },
	{ 2, 1, 4, instr_rol_DWORD, instr_ror_DWORD, _instr_ror_DWORD, magic_rol_DWORD, 1 },
	{ 2, 1, 1, instr_ror_BYTE, instr_rol_BYTE, _instr_rol_BYTE, magic_ror_BYTE, 1 },
	{ 2, 1, 2, instr_ror_WORD, instr_rol_WORD, _instr_rol_WORD, magic_ror_WORD, 1 },
	{ 2, 1, 4, instr_ror_DWORD, instr_rol_DWORD, _instr_rol_DWORD, magic_ror_DWORD, 1 },
	{ 1, 0, 1, instr_not_BYTE, instr_not_BYTE, _instr_not_BYTE, magic_not_BYTE, 0 },
	{ 1, 0, 2, instr_not_WORD, instr_not_WORD, _instr_not_WORD, magic_not_WORD, 0 },
	{ 1, 0, 4, instr_not_DWORD, instr_not_DWORD, _instr_not_DWORD, magic_not_DWORD, 0 },
	{ 2, 1, 4, instr_reorder, instr_dereorder, _instr_reorder, magic_reorder, 1 },
	{ 0, 0, 0, instr_rc4_crypt, instr_rc4_crypt, _instr_rc4_crypt, magic_rc4, 3},	// special case for args/size

	// these do not have inverses, but anyways...
	{ 2, 1, 0, instr_setecx_BYTE, instr_setecx_BYTE, _instr_setecx_BYTE, magic_setecx_BYTE, 1 },
	{ 3, 2, 0, instr_setecx_WORD, instr_setecx_WORD, _instr_setecx_WORD, magic_setecx_WORD, 1 },
	{ 5, 4, 0, instr_setecx_DWORD, instr_setecx_DWORD, _instr_setecx_DWORD, magic_setecx_DWORD, 1 },
	{ 3, 2, 0, instr_setedi_SHORT, instr_setedi_SHORT, _instr_setedi_SHORT, magic_setedi, 1 },
	{ 2, 1, 0, instr_loop_BYTE, instr_loop_BYTE, _instr_loop_BYTE, magic_loop_BYTE, 1},
	{ 3, 2, 0, instr_loop_WORD, instr_loop_WORD, _instr_loop_WORD, magic_loop_WORD, 1},
	
	// instructions using general purpose registers
	{ 3, 2, 0, instr_mov_r_const_BYTE, instr_mov_r_const_BYTE, _instr_mov_r_const_BYTE, magic_mov_r_const_BYTE, 2 },
	{ 4, 3, 0, instr_mov_r_const_WORD, instr_mov_r_const_WORD, _instr_mov_r_const_WORD, magic_mov_r_const_WORD, 2 },
	{ 6, 5, 0, instr_mov_r_const_DWORD, instr_mov_r_const_DWORD, _instr_mov_r_const_DWORD, magic_mov_r_const_DWORD, 2 },
	{ 2, 1, 0, instr_mov_r_r_BYTE, instr_mov_r_r_BYTE, _instr_mov_r_r_BYTE, magic_mov_r_r_BYTE, 1 },
	{ 2, 1, 0, instr_mov_r_r_WORD, instr_mov_r_r_WORD, _instr_mov_r_r_WORD, magic_mov_r_r_WORD, 1 },
	{ 2, 1, 0, instr_mov_r_r_DWORD, instr_mov_r_r_DWORD, _instr_mov_r_r_DWORD, magic_mov_r_r_DWORD, 1 },

	{ 2, 1, 0, instr_add_r_r_BYTE, instr_sub_r_r_BYTE, _instr_sub_r_r_BYTE, magic_add_r_r_BYTE, 1 },
	{ 2, 1, 0, instr_add_r_r_WORD, instr_sub_r_r_WORD, _instr_sub_r_r_WORD, magic_add_r_r_WORD, 1 },
	{ 2, 1, 0, instr_add_r_r_DWORD, instr_sub_r_r_DWORD, _instr_sub_r_r_DWORD, magic_add_r_r_DWORD, 1 },
	{ 2, 1, 0, instr_sub_r_r_BYTE, instr_add_r_r_BYTE, _instr_add_r_r_BYTE, magic_sub_r_r_BYTE, 1 },
	{ 2, 1, 0, instr_sub_r_r_WORD, instr_add_r_r_WORD, _instr_add_r_r_WORD, magic_sub_r_r_WORD, 1 },
	{ 2, 1, 0, instr_sub_r_r_DWORD, instr_add_r_r_DWORD, _instr_add_r_r_DWORD, magic_sub_r_r_DWORD, 1 },
	{ 2, 1, 0, instr_xor_r_r_BYTE, instr_xor_r_r_BYTE, _instr_xor_r_r_BYTE, magic_xor_r_r_BYTE, 1 },
	{ 2, 1, 0, instr_xor_r_r_WORD, instr_xor_r_r_WORD, _instr_xor_r_r_WORD, magic_xor_r_r_WORD, 1 },
	{ 2, 1, 0, instr_xor_r_r_DWORD, instr_xor_r_r_DWORD, _instr_xor_r_r_DWORD, magic_xor_r_r_DWORD, 1 },
	
	{ 3, 2, 0, instr_add_r_const_BYTE, instr_sub_r_const_BYTE, _instr_sub_r_const_BYTE, magic_add_r_const_BYTE, 2 },
	{ 4, 3, 0, instr_add_r_const_WORD, instr_sub_r_const_WORD, _instr_sub_r_const_WORD, magic_add_r_const_WORD, 2 },
	{ 6, 5, 0, instr_add_r_const_DWORD, instr_sub_r_const_DWORD, _instr_sub_r_const_DWORD, magic_add_r_const_DWORD, 2 },
	{ 3, 2, 0, instr_sub_r_const_BYTE, instr_add_r_const_BYTE, _instr_add_r_const_BYTE, magic_sub_r_const_BYTE, 2 },
	{ 4, 3, 0, instr_sub_r_const_WORD, instr_add_r_const_WORD, _instr_add_r_const_WORD, magic_sub_r_const_WORD, 2 },
	{ 6, 5, 0, instr_sub_r_const_DWORD, instr_add_r_const_DWORD, _instr_add_r_const_DWORD, magic_sub_r_const_DWORD, 2 },
	{ 3, 2, 0, instr_xor_r_const_BYTE, instr_xor_r_const_BYTE, _instr_xor_r_const_BYTE, magic_xor_r_const_BYTE, 2 },
	{ 4, 3, 0, instr_xor_r_const_WORD, instr_xor_r_const_WORD, _instr_xor_r_const_WORD, magic_xor_r_const_WORD, 2 },
	{ 6, 5, 0, instr_xor_r_const_DWORD, instr_xor_r_const_DWORD, _instr_xor_r_const_DWORD, magic_xor_r_const_DWORD, 2 },

	{ 2, 1, 1, instr_stos_add_BYTE, instr_stos_sub_BYTE, _instr_stos_sub_BYTE, magic_stos_add_BYTE, 1 },
	{ 2, 1, 2, instr_stos_add_WORD, instr_stos_sub_WORD, _instr_stos_sub_WORD, magic_stos_add_WORD, 1 },
	{ 2, 1, 4, instr_stos_add_DWORD, instr_stos_sub_DWORD, _instr_stos_sub_DWORD, magic_stos_add_DWORD, 1 },
	{ 2, 1, 1, instr_stos_sub_BYTE, instr_stos_add_BYTE, _instr_stos_add_BYTE, magic_stos_sub_BYTE, 1 },
	{ 2, 1, 2, instr_stos_sub_WORD, instr_stos_add_WORD, _instr_stos_add_WORD, magic_stos_sub_WORD, 1 },
	{ 2, 1, 4, instr_stos_sub_DWORD, instr_stos_add_DWORD, _instr_stos_add_DWORD, magic_stos_sub_DWORD, 1 },
	{ 2, 1, 1, instr_stos_xor_BYTE, instr_stos_xor_BYTE, _instr_stos_xor_BYTE, magic_stos_xor_BYTE, 1 },
	{ 2, 1, 2, instr_stos_xor_WORD, instr_stos_xor_WORD, _instr_stos_xor_WORD, magic_stos_xor_WORD, 1 },
	{ 2, 1, 4, instr_stos_xor_DWORD, instr_stos_xor_DWORD, _instr_stos_xor_DWORD, magic_stos_xor_DWORD, 1 },

	{ 2, 1, 0, instr_lods_BYTE, instr_lods_BYTE, _instr_lods_BYTE, magic_lods_BYTE, 1},
	{ 2, 1, 0, instr_lods_WORD, instr_lods_WORD, _instr_lods_WORD, magic_lods_WORD, 1},
	{ 2, 1, 0, instr_lods_DWORD, instr_lods_DWORD, _instr_lods_DWORD, magic_lods_DWORD, 1},
	
	{ 2, 1, 1, instr_stos_BYTE, instr_stos_BYTE, _instr_stos_BYTE, magic_stos_BYTE, 1 },
	{ 2, 1, 2, instr_stos_WORD, instr_stos_WORD, _instr_stos_WORD, magic_stos_WORD, 1 },
	{ 2, 1, 4, instr_stos_DWORD, instr_stos_DWORD, _instr_stos_DWORD, magic_stos_DWORD, 1 },

	// leave
	{ 1, 0, 0, instr_leave, instr_leave, _instr_leave, 0, 0}					// shouldnt be here at all...
};

// bytecode builder helper functions
static bool ValidateBytecode(LPBYTE bBytecode, LPBYTE bCryptedData, LPBYTE bOriginalData, DWORD dwDataSize)
{
	// to check if all data was altered we just check if there are any sequential 2 bytes that match
	for(int i = 1; i < dwDataSize; i++)
		if(bCryptedData[i] == bOriginalData[i] &&
			bCryptedData[i - 1] == bOriginalData[i - 1])
			return false;

	// check if bytecode correctly decrypts data
	LPBYTE bCData = (LPBYTE)Mem::copyEx(bCryptedData, dwDataSize);
	if(NULL == bCData)
		return false;

	//ConfigCrypt::DecryptConfig(bBytecode, bCData);
	//bool bResult = Mem::_compare(bCData, bOriginalData, dwDataSize) == 0;

	//
	DEC_CONTEXT ctx;
	ctx.ecx = 0;
	ctx.edi = bCData;
	ctx.eip = bBytecode;
	bEdiBase = bCData;

	bool bResult = true;
	do{
		if((ctx.edi < bEdiBase) || (ctx.edi + instructions[*ctx.eip].bDestSize > bEdiBase + dwDataSize))
		{
			bResult = false;
			break;
		}
	}while(handlers[*ctx.eip](&ctx));

	bResult = bResult && (Mem::_compare(bCData, bOriginalData, dwDataSize) == 0);
	//

	Mem::free(bCData);
	return bResult;
}

struct FLOW_DESC
{
	LPBYTE lpInstructions;
	LPBYTE lpLastSetEcx;
	DWORD  dwSize;
	int    StartEdi;
	int    EndEdi;
	FLOW_DESC *previous;
};

#define INSERT_INSTR_BYTE(value) *p = value; p++; dwGenSize++;
#define INSERT_INSTR_WORD(value) *(WORD*)p = value; p += 2; dwGenSize += 2;
#define INSERT_INSTR_DWORD(value) *(DWORD*)p = value; p += 4; dwGenSize += 4;

LPBYTE MinEdi;
LPBYTE MaxEdi;
LPBYTE lpWorkingBuffer;

enum
{
	BlockTypeDirectConst,	// *edi op= const;
	BlockTypeIndirectConst,	// *edi = expr(const);
	BlockTypeAlter,			// *edi = expr(*edi);
	BlockTypeRC4,
	BlockTypes
};

static BYTE SelectRegisters(BYTE *bIndexes)
{
	// randomly picks between 2 and 8 registers, returns picked number,
	// indexes are returned through bIndexes buffer
	BYTE bNr = Crypt::mtRand() % (5 - 2) + 2;
	WORD wMask = 0;
	for(BYTE i = 0; i < bNr; i++)
	{
		bIndexes[i] = Crypt::mtRand() & 0xF;
		if(wMask & (1 << bIndexes[i]))	// already used...
		{
			i--;
			continue;
		}
		wMask |= 1 << bIndexes[i];
	}
	return bNr;
}

struct RefList
{
	LPBYTE lpAddress;
	RefList *previous;
};

// generates a piece of code that alters *EDI contents
// code cant be bigger than dwSize, and after code execution ctx->edi is in range [MinEdi; MaxEdi]
// on exit:
//		ctx is updated to reflect edi and eip changes
//		lpCode contains generated decryption code
//		lpInverse contains inverse (encryption) code equivalent to generated one
//		dwSize contains the amount of unused space (i.e. dwSize = dwSize - sizeof(generated_code);
// if code cant be generated because of not enough available size, return value = false, otherwise return value = true;
// Rx values are assumed to be unitialized, their values 'do not transfer' between blocks
static DWORD GenerateCodeBlock(DEC_CONTEXT *ctx, LPBYTE lpCode, LPBYTE lpInverse, int* pdwSize)
{
	int dwBufferAvailable = MaxEdi - ctx->edi;
	if(dwBufferAvailable <= 0)
		return 0;

	DWORD dwGenSize = 0;
	BYTE bUsedRegisters[4];	// dont use all to avoid some colossal stuff
	BYTE bNrOfUses[16];
	BYTE bNrOfRegisters = 0;
	BYTE bBlockType = Crypt::mtRand() % BlockTypes;
	LPBYTE p = lpWorkingBuffer;
	BYTE bTmp;
	int nReg1, nReg2;

	if(bBlockType == BlockTypeDirectConst)	// *edi op= const;
	{
		BYTE bInstruction;
		do 
		{
			bInstruction = Crypt::mtRand() % _instr_rc4_crypt;
			if(instructions[bInstruction].bDestSize > dwBufferAvailable)
				continue;
			
			INSERT_INSTR_BYTE(bInstruction);
			if(bInstruction == _instr_reorder)
			{
				INSERT_INSTR_BYTE(generate_reorder_arg(Crypt::mtRand() & 0xFF));
			}
			else
			{
				for(int i = 0; i < instructions[bInstruction].bOperandSize; i++)
				{
					INSERT_INSTR_BYTE(Crypt::mtRand() & 0xFF);
				}
			}
		} while (bInstruction < _instr_xor_BYTE && *pdwSize - dwGenSize >= 5);	// skip nops...
		if(dwGenSize > *pdwSize || bInstruction < _instr_xor_BYTE)
			dwGenSize = 0;
		else
		{
			Mem::_copy(lpInverse, lpWorkingBuffer, dwGenSize);
			Mem::_copy(lpCode,    lpWorkingBuffer, dwGenSize);
			p = lpCode;
			while(p < lpCode + dwGenSize)
			{
				ctx->eip += instructions[*p].bSize;
				ctx->edi += instructions[*p].bDestSize;
				p		 += instructions[*p].bSize;
			}
		}
	}
	else if(bBlockType == BlockTypeIndirectConst)
	{
		// select registers
		bNrOfRegisters = SelectRegisters(bUsedRegisters);
		// nNrOfInstructions = [bNrOfRegisters; 5*bNrOfRegisters - 1];
		int nNrOfInstructions = (Crypt::mtRand() % 5 + 1) * bNrOfRegisters + Crypt::mtRand() % bNrOfRegisters;
		Mem::_zero(bNrOfUses, sizeof(bNrOfUses));

		for(BYTE i = 0; i < nNrOfInstructions; i++)
		{
			// pick registers
			nReg1 = bUsedRegisters[Crypt::mtRand() % bNrOfRegisters];
			nReg2 = bUsedRegisters[Crypt::mtRand() % bNrOfRegisters];
			if(bNrOfUses[nReg1] == 0)	// register not initialized yet
			{
				bTmp = i == 0 ? 20 : Crypt::mtRand() % 100;
				if(bTmp < 20)	// 20% of time use another register for initialization
				{
					// pick already initialized register
					while(bNrOfUses[nReg2] == 0)
						nReg2 = bUsedRegisters[Crypt::mtRand() % bNrOfRegisters];

					bTmp = Crypt::mtRand() % 3 + _instr_mov_r_r_BYTE;
					INSERT_INSTR_BYTE(bTmp);
					INSERT_INSTR_BYTE((nReg1 & 0xF) | ((nReg2 & 0xF) << 4));
				}
				else
				{
					// initialize register with constant
					bTmp = Crypt::mtRand() % 3 + _instr_mov_r_const_BYTE;
					INSERT_INSTR_BYTE(bTmp);
					INSERT_INSTR_BYTE(nReg1 & 0xF);
					for(int j = 1; j < instructions[bTmp].bOperandSize; j++)	// starting from 1, coz first operand is dest. register
					{
						INSERT_INSTR_BYTE(Crypt::mtRand() & 0xFF);
					}
				}
			}
			else
			{
				bTmp = Crypt::mtRand();
				if(bTmp < 70)
					bTmp = Crypt::mtRand() % (_instr_add_r_const_BYTE - _instr_add_r_r_BYTE) + _instr_add_r_r_BYTE;
				else
					bTmp = Crypt::mtRand() % (_instr_stos_add_BYTE - _instr_add_r_const_BYTE) + _instr_add_r_const_BYTE;

				if(bTmp < _instr_add_r_const_BYTE)	// rx, ry
				{
					// pick already initialized register
					while(bNrOfUses[nReg2] == 0)
						nReg2 = bUsedRegisters[Crypt::mtRand() % bNrOfRegisters];

					// catch, if instruction is xor and reg1=reg2, then reg1=0, np in this case
					// but in alteration case should watch out for that
					INSERT_INSTR_BYTE(bTmp);
					INSERT_INSTR_BYTE((nReg1 & 0xF) | ((nReg2 & 0xF) << 4));
				}
				else	// rx, const
				{
					INSERT_INSTR_BYTE(bTmp);
					INSERT_INSTR_BYTE(nReg1 & 0xF);
					for(int j = 1; j < instructions[bTmp].bOperandSize; j++)
					{
						INSERT_INSTR_BYTE(Crypt::mtRand() & 0xFF);
					}
				}
			}
			bNrOfUses[nReg1]++;
		}

		// find the register that was destination the most times, so the code looks smarter
		nReg1 = 0;
		for(BYTE i = 1; i < 16; i++)
		{
			if(bNrOfUses[nReg1] < bNrOfUses[i])
				nReg1 = i;
		}

		do 
		{
			bTmp = Crypt::mtRand() % (_instr_lods_BYTE - _instr_stos_add_BYTE) + _instr_stos_add_BYTE;
		} while (instructions[bTmp].bDestSize > dwBufferAvailable);
		
		INSERT_INSTR_BYTE(bTmp);
		INSERT_INSTR_BYTE(nReg1 & 0xF);
		
		if(dwGenSize < *pdwSize)
		{
			ctx->edi += instructions[bTmp].bDestSize;
			ctx->eip += dwGenSize;
			Mem::_copy(lpCode,	  lpWorkingBuffer, dwGenSize);
			Mem::_copy(lpInverse, lpWorkingBuffer, dwGenSize);

			p = lpInverse;	// this is actually quite bs, we making inverse of inverse...
			while(p < lpInverse + dwGenSize)
			{
				if(*p >= _instr_add_r_r_BYTE && *p <= _instr_xor_r_const_DWORD)
					*p = instructions[*p].bInverse;
				p += instructions[*p].bSize;
			}
		}
		else
			dwGenSize = 0;
	}
	else if(bBlockType == BlockTypeAlter)
	{
		// actual alterations to real data allowed here are only of form
		// data op= const, using other registers would mean we need to reverse
		// whole thing to make sure VM state is same in each alteration, but backwards
		// too much work...

		// select registers
		bNrOfRegisters = SelectRegisters(bUsedRegisters);
		Mem::_zero(bNrOfUses, sizeof(bNrOfUses));
		// nNrOfInstructions = [bNrOfRegisters; 5*bNrOfRegisters - 1];
		int nNrOfInstructions = (Crypt::mtRand() % 5 + 1) * bNrOfRegisters + Crypt::mtRand() % bNrOfRegisters;
		int nRegWithData = bUsedRegisters[Crypt::mtRand() % bNrOfRegisters];
		do 
		{
			bTmp = Crypt::mtRand() % 3;
		} while (instructions[bTmp + _instr_stos_BYTE].bDestSize > dwBufferAvailable);
		
		BYTE bStosInstr = _instr_stos_BYTE + bTmp;
		bTmp +=  _instr_lods_BYTE;
		RefList *rl = NULL;
		RefList *tmp;

		// load data
		INSERT_INSTR_BYTE(bTmp);
		INSERT_INSTR_BYTE(nRegWithData & 0xF);
		bNrOfUses[nRegWithData]++;

		for(BYTE i = 0; i < nNrOfInstructions; i++)
		{
			// pick registers
			bTmp = Crypt::mtRand() % 100;
			if(bTmp < 50)
				nReg1 = bUsedRegisters[Crypt::mtRand() % bNrOfRegisters];
			else
				nReg1 = nRegWithData;
			if(i == 0 && nReg1 == nRegWithData)
			{
				do 
				{
					nReg1 = bUsedRegisters[Crypt::mtRand() % bNrOfRegisters];
				} while (nReg1 == nRegWithData);
			}
			nReg2 = bUsedRegisters[Crypt::mtRand() % bNrOfRegisters];
			if(bNrOfUses[nReg1] == 0)	// register not initialized yet
			{
				bTmp = i == 0 ? 20 : Crypt::mtRand() % 100;
				if(bTmp < 20)	// 20% of time use another register for initialization
				{
					// pick already initialized register
					while(bNrOfUses[nReg2] == 0)
						nReg2 = bUsedRegisters[Crypt::mtRand() % bNrOfRegisters];

					bTmp = Crypt::mtRand() % 3 + _instr_mov_r_r_BYTE;
					INSERT_INSTR_BYTE(bTmp);
					INSERT_INSTR_BYTE((nReg1 & 0xF) | ((nReg2 & 0xF) << 4));
				}
				else
				{
					// initialize register with constant
					bTmp = Crypt::mtRand() % 3 + _instr_mov_r_const_BYTE;
					INSERT_INSTR_BYTE(bTmp);
					INSERT_INSTR_BYTE(nReg1 & 0xF);
					for(int j = 1; j < instructions[bTmp].bOperandSize; j++)	// starting from 1, coz first operand is dest. register
					{
						INSERT_INSTR_BYTE(Crypt::mtRand() & 0xFF);
					}
				}
				bNrOfUses[nReg1]++;
			}
			else
			{
				bTmp = Crypt::mtRand() % (_instr_stos_add_BYTE - _instr_add_r_r_BYTE) + _instr_add_r_r_BYTE;		

				if(bTmp < _instr_add_r_const_BYTE)	// rx, ry
				{
					// dont alter data this way
					while(nReg1 == nRegWithData || bNrOfUses[nReg1] == 0)
						nReg1 = bUsedRegisters[Crypt::mtRand() % bNrOfRegisters];

					// pick already initialized register, dont pick the same if we're xoring register with data
					do 
					{
						while(bNrOfUses[nReg2] == 0)
							nReg2 = bUsedRegisters[Crypt::mtRand() % bNrOfRegisters];
					} while ((bTmp == _instr_xor_r_r_BYTE || bTmp == _instr_xor_r_r_WORD || bTmp == _instr_xor_r_r_DWORD) &&
						nReg1 == nReg2 && nReg1 == nRegWithData);

					INSERT_INSTR_BYTE(bTmp);
					INSERT_INSTR_BYTE((nReg1 & 0xF) | ((nReg2 & 0xF) << 4));
				}
				else	// rx, const
				{
					INSERT_INSTR_BYTE(bTmp);
					INSERT_INSTR_BYTE(nReg1 & 0xF);
					for(int j = 1; j < instructions[bTmp].bOperandSize; j++)
					{
						INSERT_INSTR_BYTE(Crypt::mtRand() & 0xFF);
					}
					if(nReg1 == nRegWithData)
					{
						tmp = (RefList*)Mem::alloc(sizeof(RefList));
						tmp->lpAddress = p - instructions[bTmp].bSize;
						tmp->previous  = rl;
						rl = tmp;
					}
				}
			}
		}

		INSERT_INSTR_BYTE(bStosInstr);
		INSERT_INSTR_BYTE(nRegWithData & 0xF);

		if(dwGenSize < *pdwSize)
		{
			ctx->edi += instructions[bStosInstr].bDestSize;
			ctx->eip += dwGenSize;
			Mem::_copy(lpCode,	  lpWorkingBuffer, dwGenSize);

			LPBYTE pi = lpInverse;
			p = lpCode;
			while(p < lpCode + dwGenSize)
			{
				if(*p >= _instr_add_r_const_BYTE && *p <= _instr_xor_r_const_DWORD &&
					p[1] == nRegWithData)
				{
					Mem::_copy(pi, rl->lpAddress, instructions[*rl->lpAddress].bSize);
					pi += instructions[*rl->lpAddress].bSize;
					p  += instructions[*p].bSize;
					tmp = rl;
					rl = rl->previous;
					Mem::free(tmp);
				}
				else
				{
					Mem::_copy(pi, p, instructions[*p].bSize);
					pi += instructions[*p].bSize;
					p  += instructions[*p].bSize;
				}
			}
		}
		else
			dwGenSize = 0;
	}
	else if(bBlockType == BlockTypeRC4)
	{
		int nRC4KeySize = *pdwSize - 3;	// 3 for instr/key/data sizes
		if(nRC4KeySize > 0xFF)
			nRC4KeySize = 0xFF;

		int nRC4DataSize = dwBufferAvailable;
		if(nRC4DataSize > 0xFF)
			nRC4DataSize = 0xFF;

		if(nRC4KeySize < 2 || nRC4DataSize < 2)	// no room for this
			goto End;

		nRC4KeySize--; nRC4DataSize--;

		nRC4KeySize = Crypt::mtRand() % nRC4KeySize + 1;
		nRC4DataSize = Crypt::mtRand() % nRC4DataSize + 1;

		INSERT_INSTR_BYTE(_instr_rc4_crypt);
		INSERT_INSTR_BYTE(nRC4KeySize);
		INSERT_INSTR_BYTE(nRC4DataSize);
		for(int i = 0; i < nRC4KeySize; i++)
		{
			INSERT_INSTR_BYTE(Crypt::mtRand() & 0xFF);
		}
		Mem::_copy(lpCode,    lpWorkingBuffer, dwGenSize);
		Mem::_copy(lpInverse, lpWorkingBuffer, dwGenSize);
		ctx->edi += nRC4DataSize;
		ctx->eip += dwGenSize;
	}

End:
	if(dwGenSize != 0)
	{
		*pdwSize -= dwGenSize;
		return dwGenSize;
	}
	else
		return 0;
}

static DWORD AdjustEDI(DEC_CONTEXT *ctx, LPBYTE lpCode, LPBYTE lpInverse, int* pdwSize, short sValue, bool bUseValue)
{
	if(*pdwSize <= instructions[_instr_setedi_SHORT].bSize)
		return 0;

	if(!bUseValue)
	{
		int nMin = MinEdi - ctx->edi;
		int nMax = MaxEdi - ctx->edi - 1;
		if(nMax == -1)
			nMax = 0;

		if(nMin < -32767)
			nMin = -32767;
		if(nMax > 32767)
			nMax = 32767;
		int nRange = nMax - nMin;
		sValue = Crypt::mtRand() % nRange + nMin;
	}
	LPBYTE p = lpCode;
	DWORD dwGenSize = 0;
	INSERT_INSTR_BYTE(_instr_setedi_SHORT);
	INSERT_INSTR_WORD(sValue);

	p = lpInverse;
	INSERT_INSTR_BYTE(_instr_setedi_SHORT);
	INSERT_INSTR_WORD(sValue);

	ctx->edi += sValue;
	ctx->eip += instructions[_instr_setedi_SHORT].bSize;
	*pdwSize -= instructions[_instr_setedi_SHORT].bSize;

	return instructions[_instr_setedi_SHORT].bSize;
}

static FLOW_DESC * MakeFlowDesc(DEC_CONTEXT *ctx, FLOW_DESC *previous)
{
	FLOW_DESC *r = (FLOW_DESC*)Mem::alloc(sizeof(FLOW_DESC));
	
	r->previous = previous;
	r->lpInstructions = ctx->eip;
	r->StartEdi = 0;
	r->dwSize = 0;
	
	if(previous)
	{
		previous->EndEdi = ctx->edi - MinEdi;
		previous->dwSize = r->lpInstructions - previous->lpInstructions;
	}
	return r;
}

#undef INSERT_INSTR_BYTE
#undef INSERT_INSTR_WORD
#undef INSERT_INSTR_DWORD
#define INSERT_INSTR_BYTE(value) *p = value; p++; *pi = value; pi++;
#define INSERT_INSTR_WORD(value) *(WORD*)p = value; p += 2; *(WORD*)pi = value; pi += 2; 
#define INSERT_INSTR_DWORD(value) *(DWORD*)p = value; p += 4; *(DWORD*)pi = value; pi += 4; 
static bool GenerateBytecode(LPBYTE bDecryptBytecode, DWORD dwBytecodeSize, LPBYTE bData, DWORD dwDataSize)
{
	DEC_CONTEXT ctx;
	MinEdi = bData;
	MaxEdi = bData + dwDataSize;
	ctx.ecx = 0;
	ctx.eip = bDecryptBytecode;
	ctx.edi = bData;
	
	LPBYTE bEncryptCode = (LPBYTE)Mem::alloc(dwBytecodeSize);
	if(bEncryptCode == NULL)
		return false;

	lpWorkingBuffer = (LPBYTE)Mem::alloc(dwBytecodeSize);
	if(lpWorkingBuffer == NULL)
	{
		Mem::free(bEncryptCode);
		return false;
	}

	LPBYTE bOriginalData = (LPBYTE)Mem::copyEx(bData, dwDataSize);
	if(bOriginalData == NULL)
	{
		Mem::free(bEncryptCode);
		Mem::free(lpWorkingBuffer);
		lpWorkingBuffer = NULL;
		return false;
	}

	int nRemainingSpace = dwBytecodeSize - 1;	// reserve 1 for leave
	DWORD dwGenSize = 0;
	LPBYTE p  = bDecryptBytecode;
	LPBYTE pi = bEncryptCode;
	FLOW_DESC *pf = NULL, *ftmp;

	// start with mov edi, 0
	pf = MakeFlowDesc(&ctx, pf);
	pf->StartEdi = 0;
	dwGenSize = AdjustEDI(&ctx, p, pi, &nRemainingSpace, 0, true);
	p  += dwGenSize;
	pi += dwGenSize;

	while(nRemainingSpace > 5)
	{
		BYTE bAction = 0;			// 1 change edi, 2 simple operation, 3 incremental loop
		if(ctx.edi == MaxEdi)
			bAction = 1;
		if(bAction == 0 && ((ctx.edi - MinEdi) - pf->StartEdi > dwDataSize / 4))
			bAction = (Crypt::mtRand() % 100) < 10 ? 1 : 0;

		if(bAction == 0)	// decide between loop and simple operation
			bAction = (Crypt::mtRand() % 100) < 20 ? 3 : 2;

		if(bAction == 3)	// if we have loop, check if we have enough room for loop
		{
			if(nRemainingSpace < 3 + 3 + 3 + 5)	// set ecx, loop, set edi, at least 5 bytes for something else
				bAction = 1;
			if((MaxEdi - ctx.edi) < dwDataSize / 5)	// less than 20% of data left
				bAction = 1;
		}

		if(bAction == 1)
		{
			pf = MakeFlowDesc(&ctx, pf);
			dwGenSize = AdjustEDI(&ctx, p, pi, &nRemainingSpace, 0, false);
			pf->StartEdi = ctx.edi - MinEdi;
		}
		else if(bAction == 2)
		{
			dwGenSize = GenerateCodeBlock(&ctx, p, pi, &nRemainingSpace);
		}
		else //if(bAction == 3)
		{
			// loop case
			LPBYTE pEcxSetter1 = p  + 1;
			LPBYTE pEcxSetter2 = pi + 1;
			INSERT_INSTR_BYTE(_instr_setecx_WORD);
			INSERT_INSTR_WORD(0);
			ctx.eip += instructions[_instr_setecx_WORD].bSize;
			nRemainingSpace -= instructions[_instr_setecx_WORD].bSize;
			int nTempRemainingSpace = nRemainingSpace - 3 - 3;
			if(nTempRemainingSpace > 0xFFFF)	// loop cant be bigger than that
				nTempRemainingSpace = 0xFFFF;
			WORD wIterations = 0;
			bool bEndCondition;
			LPBYTE pStartEdi = ctx.edi;
			int nDataRemaining = MaxEdi - ctx.edi;
			do 
			{
				dwGenSize = GenerateCodeBlock(&ctx, p, pi, &nTempRemainingSpace);
				p  += dwGenSize;
				pi += dwGenSize;
				nRemainingSpace -= dwGenSize;

				if(ctx.edi != pStartEdi)
					wIterations = nDataRemaining / (ctx.edi - pStartEdi);
				else
					wIterations = 9999;
				bEndCondition = Crypt::mtRand() % 100 < 5 ? true : false;
			} while (nTempRemainingSpace > 0 && wIterations > 10 && !bEndCondition);

			// update # of iterations
			*(WORD*)pEcxSetter1 = wIterations - 1;
			*(WORD*)pEcxSetter2 = wIterations - 1;

			WORD wLoopOffset = ctx.eip - (pEcxSetter1 + 2);
			if(wLoopOffset < 0xFD)
			{
				INSERT_INSTR_BYTE(_instr_loop_BYTE);
				INSERT_INSTR_BYTE((wLoopOffset + 2) & 0xFF);
				ctx.eip			+= instructions[_instr_loop_BYTE].bSize;
				nRemainingSpace -= instructions[_instr_loop_BYTE].bSize;
			}
			else
			{
				INSERT_INSTR_BYTE(_instr_loop_WORD);
				INSERT_INSTR_WORD(wLoopOffset + 3);
				ctx.eip			+= instructions[_instr_loop_WORD].bSize;
				nRemainingSpace -= instructions[_instr_loop_WORD].bSize;
			}

			ctx.edi += (ctx.edi - pStartEdi) * (wIterations - 1);
			dwGenSize = 0;
		}

		p  += dwGenSize;
		pi += dwGenSize;
	}

	pf->EndEdi = ctx.edi - MinEdi;
	pf->dwSize = ctx.eip - pf->lpInstructions;
	
	*p  = _instr_leave;
	*pi = _instr_leave;
	
	Mem::_copy(bData, bOriginalData, dwDataSize);

	ctx.ecx  = 0;
	ctx.edi  = bData;
	ctx.eip  = bEncryptCode;
	bEdiBase = bData;

	while(instructions[*ctx.eip].inv_handler(&ctx))
	{
		if(ctx.edi < bData || ctx.edi > bData + dwDataSize)
			MessageBoxA(NULL, "Have problem...", "", 0);
		if(ctx.eip < bEncryptCode || ctx.eip > bEncryptCode + (dwBytecodeSize - nRemainingSpace))
			MessageBoxA(NULL, "Have problem...", "", 0);
	}

	// reverse
	p = bEncryptCode;	// use this for temp buffer
	DWORD _edi = 0;
	while(pf)
	{
		// copy code block
		Mem::_copy(p, pf->lpInstructions, pf->dwSize);

		// adjust edi for this block
		*(short*)(p + 1) = pf->StartEdi - _edi;
		_edi = pf->EndEdi;

		p += pf->dwSize;

		ftmp = pf;
		pf = pf->previous;
		Mem::free(ftmp);
	}
	*p = _instr_leave;

	Mem::_copy(bDecryptBytecode, bEncryptCode, dwBytecodeSize);

	Mem::free(bOriginalData);
	Mem::free(bEncryptCode);
	Mem::free(lpWorkingBuffer);
	lpWorkingBuffer = NULL;

	return true;
}

void CryptBytecode(LPBYTE bBytecode)
{
	BYTE bNextInstr = *bBytecode;
	INSTR_DESC *id;
	LPBYTE lpNextInstr;
	do 
	{
		id = &instructions[bNextInstr];
		BYTE bKey = id->bXorKey;
		if(id->bRandOffset > 0)
			bKey ^= bBytecode[id->bRandOffset];
		else
			bKey ^= bNextInstr;
		if(bNextInstr != _instr_rc4_crypt)
			bBytecode += id->bSize;
		else
			bBytecode += 3 + bBytecode[1];
		bNextInstr = *bBytecode;
		*bBytecode = (bNextInstr ^ bKey) | 0x80;
	} while (bNextInstr != _instr_leave);
}

/*
	Builds bytecode for decrypting config data.

	IN/OUT bData          - Plaintext data, on exit this data is in encrypted form that can be
						   decrypted back to original state by executing produced bytecode.
	IN     dwDataSize     - Size of the data pointed by bOriginalData.
	OUT    bBytecode	  - Buffer that will hold produced bytecode.
	IN     dwBytecodeSize - Size of bBytecode buffer. Produced bytecode will be of size <=dwBytecodeSize.
*/
bool ConfigCrypt::BuildDecryptionBytecode(LPBYTE bData, DWORD dwDataSize, LPBYTE bBytecode, DWORD dwBytecodeSize)
{
	// requirements/restrains.
	// 1. All bOriginalData buffer has to be covered.
	// 2. Generated bytecode has to be <=dwBytecodeSize.
	// 3. Because we have only 1 loop counter, loops should not nest (makes it more complicated to correctly get reversed version).
	// 4. Cant access data out of bData bounds.
	
	// make copy of original data
	LPBYTE bOriginalData = (LPBYTE)Mem::copyEx(bData, dwDataSize);
	bool bResult = false;
	int nTries = 0;

	if(NULL == bOriginalData)
		return false;

	do 
	{
		Mem::_copy(bData, bOriginalData, dwDataSize);

		GenerateBytecode(bBytecode, dwBytecodeSize, bData, dwDataSize);

		nTries++;
		bResult = ValidateBytecode(bBytecode, bData, bOriginalData, dwDataSize);
	} while (!bResult && nTries < 100);

	Mem::free(bOriginalData);
	if(bResult)
		CryptBytecode(bBytecode);
	return bResult;
}

#endif
