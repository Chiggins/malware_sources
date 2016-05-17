unit WideStringEdit;

interface

function WStrLComp(const Str1, Str2: PWideChar; MaxLen: Cardinal): Integer;
{* Compare two strings (fast). Terminating 0 is not considered, so if
   strings are equal, comparing is continued up to MaxLen bytes.
   Since this, pass minimum of lengths as MaxLen. }
function WS2Int( S: PWideChar ): Integer;
{* Converts null-terminated string to Integer. Scanning stopped when any
   non-digit character found. Even empty string or string not containing
   valid integer number silently converted to 0. }
function UTF8ToUCS2(Dest: PWideChar; MaxDestBytes: Cardinal;
  Source: PChar; SourceChars: Cardinal): Cardinal;
(* Decode string from UTF8 to UCS2 *)
function UCS2ToUTF8(Dest: PChar; MaxDestBytes: Cardinal;
  Source: PWideChar; SourceChars: Cardinal): Cardinal;
(* Decode string from UCS2 to UTF8 *)

implementation

function WStrLComp(const Str1, Str2: PWideChar; MaxLen: Cardinal): Integer; assembler;
asm
        OR      ECX,ECX
        JE      @@1
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     EDI,EDX
        MOV     ESI,EAX
        MOV     EBX,ECX
        XOR     EAX,EAX
        REPNE   SCASW
        SUB     EBX,ECX
        MOV     ECX,EBX
        MOV     EDI,EDX
        XOR     EDX,EDX
        REPE    CMPSW
        MOV     AX,[ESI-2]
        MOV     DX,[EDI-2]
        SUB     EAX,EDX
        POP     EBX
        POP     ESI
        POP     EDI
@@1:
end;



function WS2Int( S: PWideChar ): Integer;
//EAX: S
//Result: Integer -> EAX
asm
        XCHG     EDX, EAX
        XOR      EAX, EAX
        TEST     EDX, EDX
        JZ       @@exit

        XOR      ECX, ECX
        MOV      CX, [EDX]
        ADD      EDX, 2
        CMP      CX, '-'
        PUSHFD
        JE       @@0
@@1:    CMP      CX, '+'
        JNE      @@2
@@0:    MOV      CX, [EDX]
        ADD      EDX, 2
@@2:    SUB      CX, '0'
        CMP      CX, '9'-'0'
        JA       @@fin
        LEA      EAX, [EAX+EAX*4] //
        LEA      EAX, [ECX+EAX*2] //
        JMP      @@0
@@fin:  POPFD
        JNE      @@exit
        NEG      EAX
@@exit:
end;

function UTF8ToUCS2(Dest: PWideChar; MaxDestBytes: Cardinal;
  Source: PChar; SourceChars: Cardinal): Cardinal;
//EAX: @Dest
//EDX: MaxDestBytes
//ECX: @Source
//(ESP): SourceChars;
//Result: DestChars of @Dest -> EAX
asm
  //backup
  PUSHF
  CLD //set (ESI)+
  PUSH EBX
  PUSH ESI
  PUSH EDI

  PUSH Dest //backup @Dst
  MOV EDI, Dest
  TEST Source, Source //test NULL string
  JZ @Exit
  MOV ESI, Source
  MOV ECX, SourceChars

@NextChar:
  //test length of Dst
  SUB EDX, 2
  JLE @Exit
  //get next char to EAX
  XOR EAX, EAX
  LODSB //MOV AL, [ESI]+
  //test NULL char (end of string)
  TEST AL, AL
  JZ @Exit
//decode UTF8 to UCS2
@Utf8ToUcs2:
  //test first byte UTF8 = 0xxxxxxx
  TEST AL, $80
  JNZ @1xxxxxxx
//UTF8: 0xxxxxxx (AH = 0)
@SaveU16:
  STOSW //MOVW [EDI]+, EAX
@Loop:
  LOOP @NextChar
  JMP @Exit

@1xxxxxxx:
  //test first byte UTF8 = 10xxxxxx
  TEST AL, $40 //01000000
  JZ @Exit  //Error UTF8: 10xxxxxx
  //test first byte UTF8 = 1111xxxx
  CMP AL, $F0 //11110000
  JAE @Exit  //Error UTF8 to UCS2: 1111xxxx ( if AL >= $F0)
  //test exist second byte UTF8 
  JECXZ @Exit // DEC ECX; if ECX = 0
  //backup first byte UTF8
  MOV AH, AL //11xxxxxx
  //load second byte UTF8
  LODSB //MOV AL, [ESI]+
  //test second byte UTF8 = 10xxxxxx
  TEST AL, $40 //01000000
  JNE @Exit  //Error UTF8: 10xxxxxx
  //test second byte UTF8 = 110xxxxx
  TEST AH, $20 //00100000
  JNZ @1110xxxx //third byte UTF8
//UTF8: 110xxxxx 10xxxxxx
  //backup first byte UTF8
  MOV BL, AH //110xxxxx
  //get high byte UCS2
  SHR AH, 2  //00110xxx
  AND AX, $073F //AH: 00000xxx; AL: 00xxxxxx
  //get low byte USC2
  SHL BL, 6  //xx000000
  OR AL, BL   //xxxxxxxx
  //AX: 00000xxx:xxxxxxxx
  JMP @SaveU16

@1110xxxx:
  //test exist third byte UTF8
  JeCXZ @Exit // DEC ECX; if ECX = 0
  //backup second byte UTF8
  MOV BL, AL //10xxxxxx
  //load third byte UTF8
  LODSB //MOV AL, [ESI]+
  //test third byte UTF8 = 10xxxxxx
  CMP AL, $C0 //11000000
  JAE @Exit  //Error UTF8: 11xxxxxx ( if AL >= $C0)
//UTF8: 1110xxxx 10xxxxxx 10xxxxxx
  //get bytes UCS2 на: xx00000:0000xxxx
  AND BX, $003F //DX := 00000000:00xxxxxx
  ROR BX, 2 //BL := 0000xxxx; BH := xx000000
  //get low byte UTF8
  AND AL, $3F //00xxxxxx
  OR AL, BH   //xxxxxxxx
  //get high byte UCS2
  SHL AH, 4   //xxxx0000
  OR AH, BL   //xxxxxxxx
  JMP @SaveU16

@Exit:
  XOR EAX, EAX
  MOV [EDI],AX //set end-char of Dst
  POP EAX //restore @Dst
  XCHG EAX, EDI
  //get length of Dst to Result
  SUB EAX, EDI
  SHR EAX, 1
  //restore
  POP EDI
  POP ESI
  POP EBX
  POPF
end;

function UCS2ToUTF8(Dest: PChar; MaxDestBytes: Cardinal;
  Source: PWideChar; SourceChars: Cardinal): Cardinal;
//EAX: @Dest
//EDX: MaxDestBytes
//ECX: @Source
//(ESP): SourceChars;
//Result: DestChars of @Dest -> EAX
asm
  //backup
  PUSHF
  CLD //set (ESI)+
  PUSH EBX
  PUSH ESI
  PUSH EDI

  PUSH Dest //backup @Dst
  MOV EDI, Dest
  TEST Source, Source //test NULL string
  JZ @Exit
  MOV ESI, Source
  MOV ECX, SourceChars

@NextChar:
  //test length of Dst
  DEC EDX
  JLE @Exit
  //get next char to EAX
  XOR EAX, EAX
  LODSW //MOV AX, [ESI]+
  //test NULL char (end of string)
  TEST EAX, EAX
  JZ @Exit
//decode UCS2 to UTF8
@Ucs2ToUtf8:
  //test UCS2-char in $0000..$007F
  CMP AX, $007F
  JA @11xxxxxx //if AX > $7F
//UTF8-char: 0xxxxxxx
  //AH = 00000000; AL = 0xxxxxxx
@0xxxxxxx:
  //save UTF8-char
  STOSB //MOVB [EDI]+, AL
//end Loop
@Loop:
  LOOP @NextChar
  JMP @Exit

@11xxxxxx:
  //test length of Dst
  DEC EDX
  JLE @Exit
  //test UCS2-char in $0080..$07FF
  CMP AX, $07FF
  JA @1110xxxx //if AX > $07FF
//UTF8-char: 110xxxxx 10xxxxxx
  //AH = 00000xxx; AL = xxxxxxxx
  //get first byte UTF8-char to AL
  ROR AX, 6     //AH = xxxxxx00; AL = 000xxxxx
  //get second byte UTF8-char to AH
  SHR AH, 2     //AH = 00xxxxxx
  OR  AX, $80C0 //AH = 10xxxxxx; AL = 110xxxxx
  //save UTF8-char
  STOSW //MOVW [EDI]+, AX
  JMP @Loop

//UTF8-char: 1110xxxx 10xxxxxx 10xxxxxx
@1110xxxx:
  //test length of Dst
  DEC EDX
  JLE @Exit
  //save lobyte of UCS2-char
  MOV BL, AL
  //AH = xxxxxxxx; AL = xxxxxxxx
  //get first byte UTF8-char UTF8 to AL
  ROL AX, 4    //AL = ????xxxx; AH = xxxxxx??
  AND AL, $0F  //AL = 0000xxxx
  //get second byte UTF8-char to AH
  SHR AH, 2    //AH = 00xxxxxx
  OR AX, $80E0 //AH = 10xxxxxx; AL = 1110xxxx
  //save first bytes UTF8-char
  STOSW //MOVW [EDI]+, AX
  //get second byte UTF8-char to AL
  XCHG EAX, EBX //??xxxxxx
  AND AL, $3F   //00xxxxxx
  OR  AL, $80   //10xxxxxx
  //save third byte UTF8-char
  JMP @0xxxxxxx

@Exit:
  MOV BYTE PTR [EDI], $00 //set end-char of Dst
  POP EAX //restore @Dst
  XCHG EAX, EDI
  //get length of Dst to Result
  SUB EAX, EDI
  //restore
  POP EDI
  POP ESI
  POP EBX
  POPF
end;

END//Decode string from UTF8 to UCS2
function UTF8ToUCS2(Dest: PWideChar; MaxDestBytes: Cardinal;
  Source: PChar; SourceChars: Cardinal): Cardinal;
//EAX: @Dest
//EDX: MaxDestBytes
//ECX: @Source
//(ESP): SourceChars;
//Result: DestChars of @Dest -> EAX
asm
  //backup
  PUSHF
  CLD //set (ESI)+
  PUSH EBX
  PUSH ESI
  PUSH EDI

  PUSH Dest //backup @Dst
  MOV EDI, Dest
  TEST Source, Source //test NULL string
  JZ @Exit
  MOV ESI, Source
  MOV ECX, SourceChars

@NextChar:
  //test length of Dst
  SUB EDX, 2
  JLE @Exit
  //get next char to EAX
  XOR EAX, EAX
  LODSB //MOV AL, [ESI]+
  //test NULL char (end of string)
  TEST AL, AL
  JZ @Exit
//decode UTF8 to UCS2
@Utf8ToUcs2:
  //test first byte UTF8 = 0xxxxxxx
  TEST AL, $80
  JNZ @1xxxxxxx
//UTF8: 0xxxxxxx (AH = 0)
@SaveU16:
  STOSW //MOVW [EDI]+, EAX
@Loop:
  LOOP @NextChar
  JMP @Exit

@1xxxxxxx:
  //test first byte UTF8 = 10xxxxxx
  TEST AL, $40 //01000000
  JZ @Exit  //Error UTF8: 10xxxxxx
  //test first byte UTF8 = 1111xxxx
  CMP AL, $F0 //11110000
  JAE @Exit  //Error UTF8 to UCS2: 1111xxxx ( if AL >= $F0)
  //test exist second byte UTF8 
  JECXZ @Exit // DEC ECX; if ECX = 0
  //backup first byte UTF8
  MOV AH, AL //11xxxxxx
  //load second byte UTF8
  LODSB //MOV AL, [ESI]+
  //test second byte UTF8 = 10xxxxxx
  TEST AL, $40 //01000000
  JNE @Exit  //Error UTF8: 10xxxxxx
  //test second byte UTF8 = 110xxxxx
  TEST AH, $20 //00100000
  JNZ @1110xxxx //third byte UTF8
//UTF8: 110xxxxx 10xxxxxx
  //backup first byte UTF8
  MOV BL, AH //110xxxxx
  //get high byte UCS2
  SHR AH, 2  //00110xxx
  AND AX, $073F //AH: 00000xxx; AL: 00xxxxxx
  //get low byte USC2
  SHL BL, 6  //xx000000
  OR AL, BL   //xxxxxxxx
  //AX: 00000xxx:xxxxxxxx
  JMP @SaveU16

@1110xxxx:
  //test exist third byte UTF8
  JeCXZ @Exit // DEC ECX; if ECX = 0
  //backup second byte UTF8
  MOV BL, AL //10xxxxxx
  //load third byte UTF8
  LODSB //MOV AL, [ESI]+
  //test third byte UTF8 = 10xxxxxx
  CMP AL, $C0 //11000000
  JAE @Exit  //Error UTF8: 11xxxxxx ( if AL >= $C0)
//UTF8: 1110xxxx 10xxxxxx 10xxxxxx
  //get bytes UCS2 на: xx00000:0000xxxx
  AND BX, $003F //DX := 00000000:00xxxxxx
  ROR BX, 2 //BL := 0000xxxx; BH := xx000000
  //get low byte UTF8
  AND AL, $3F //00xxxxxx
  OR AL, BH   //xxxxxxxx
  //get high byte UCS2
  SHL AH, 4   //xxxx0000
  OR AH, BL   //xxxxxxxx
  JMP @SaveU16

@Exit:
  XOR EAX, EAX
  MOV [EDI],AX //set end-char of Dst
  POP EAX //restore @Dst
  XCHG EAX, EDI
  //get length of Dst to Result
  SUB EAX, EDI
  SHR EAX, 1
  //restore
  POP EDI
  POP ESI
  POP EBX
  POPF
end ; //asm

//Decode string from UCS2 to UTF8
function UCS2ToUTF8(Dest: PChar; MaxDestBytes: Cardinal;
  Source: PWideChar; SourceChars: Cardinal): Cardinal;
//EAX: @Dest
//EDX: MaxDestBytes
//ECX: @Source
//(ESP): SourceChars;
//Result: DestChars of @Dest -> EAX
asm
  //backup
  PUSHF
  CLD //set (ESI)+
  PUSH EBX
  PUSH ESI
  PUSH EDI

  PUSH Dest //backup @Dst
  MOV EDI, Dest
  TEST Source, Source //test NULL string
  JZ @Exit
  MOV ESI, Source
  MOV ECX, SourceChars

@NextChar:
  //test length of Dst
  DEC EDX
  JLE @Exit
  //get next char to EAX
  XOR EAX, EAX
  LODSW //MOV AX, [ESI]+
  //test NULL char (end of string)
  TEST EAX, EAX
  JZ @Exit
//decode UCS2 to UTF8
@Ucs2ToUtf8:
  //test UCS2-char in $0000..$007F
  CMP AX, $007F
  JA @11xxxxxx //if AX > $7F
//UTF8-char: 0xxxxxxx
  //AH = 00000000; AL = 0xxxxxxx
@0xxxxxxx:
  //save UTF8-char
  STOSB //MOVB [EDI]+, AL
//end Loop
@Loop:
  LOOP @NextChar
  JMP @Exit

@11xxxxxx:
  //test length of Dst
  DEC EDX
  JLE @Exit
  //test UCS2-char in $0080..$07FF
  CMP AX, $07FF
  JA @1110xxxx //if AX > $07FF
//UTF8-char: 110xxxxx 10xxxxxx
  //AH = 00000xxx; AL = xxxxxxxx
  //get first byte UTF8-char to AL
  ROR AX, 6     //AH = xxxxxx00; AL = 000xxxxx
  //get second byte UTF8-char to AH
  SHR AH, 2     //AH = 00xxxxxx
  OR  AX, $80C0 //AH = 10xxxxxx; AL = 110xxxxx
  //save UTF8-char
  STOSW //MOVW [EDI]+, AX
  JMP @Loop

//UTF8-char: 1110xxxx 10xxxxxx 10xxxxxx
@1110xxxx:
  //test length of Dst
  DEC EDX
  JLE @Exit
  //save lobyte of UCS2-char
  MOV BL, AL
  //AH = xxxxxxxx; AL = xxxxxxxx
  //get first byte UTF8-char UTF8 to AL
  ROL AX, 4    //AL = ????xxxx; AH = xxxxxx??
  AND AL, $0F  //AL = 0000xxxx
  //get second byte UTF8-char to AH
  SHR AH, 2    //AH = 00xxxxxx
  OR AX, $80E0 //AH = 10xxxxxx; AL = 1110xxxx
  //save first bytes UTF8-char
  STOSW //MOVW [EDI]+, AX
  //get second byte UTF8-char to AL
  XCHG EAX, EBX //??xxxxxx
  AND AL, $3F   //00xxxxxx
  OR  AL, $80   //10xxxxxx
  //save third byte UTF8-char
  JMP @0xxxxxxx

@Exit:
  MOV BYTE PTR [EDI], $00 //set end-char of Dst
  POP EAX //restore @Dst
  XCHG EAX, EDI
  //get length of Dst to Result
  SUB EAX, EDI
  //restore
  POP EDI
  POP ESI
  POP EBX
  POPF
end;

end.