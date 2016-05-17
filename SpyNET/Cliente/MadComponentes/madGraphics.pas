// ***************************************************************
//  madGraphics.pas           version:  1.0   ·  date: 2001-03-04
//  -------------------------------------------------------------
//  gray scaling, smooth stretching, alpha blending, ...
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2001 www.madshi.net, All Rights Reserved
// ***************************************************************

unit madGraphics;

{$I mad.inc}
{$R-}{$Q-}

interface

uses Windows, Graphics;

// ***************************************************************

type TGrayPercent = (gp100, gp75, gp50, gp0);
procedure GrayScale (bmp: TBitmap; percent: TGrayPercent = gp100);

// ***************************************************************

type TStretchQuality = (sqLow, sqHigh, sqVeryHigh);
procedure StretchBitmap (srcBmp, dstBmp : TBitmap;
                         srcMsk, dstMsk : TBitmap;
                         quality        : TStretchQuality = sqHigh); overload;
procedure StretchBitmap (bmp, msk       : TBitmap;
                         newWidth       : integer;
                         newHeight      : integer;
                         quality        : TStretchQuality = sqHigh); overload;

// ***************************************************************

procedure AlphaBlend (src1, src2, dst : TBitmap;
                      alpha           : cardinal = 128); overload;
procedure AlphaBlend (src, dst        : TBitmap;
                      alpha           : cardinal = 128;
                      msk             : TBitmap  = nil;
                      x               : integer  = 0;
                      y               : integer  = 0  ); overload;

// ***************************************************************

procedure Draw (imageList, index : cardinal;
                dst              : TBitmap;
                x                : integer         = 0;
                y                : integer         = 0;
                width            : integer         = 0;
                height           : integer         = 0;
                grayPercent      : TGrayPercent    = gp0;
                alpha            : cardinal        = 256;
                stretchQuality   : TStretchQuality = sqHigh); overload;

procedure Draw (bmp, msk         : TBitmap;
                dst              : TBitmap;
                x                : integer         = 0;
                y                : integer         = 0;
                width            : integer         = 0;
                height           : integer         = 0;
                grayPercent      : TGrayPercent    = gp0;
                alpha            : cardinal        = 256;
                stretchQuality   : TStretchQuality = sqHigh); overload;

// ***************************************************************

implementation

uses SysUtils, Classes, Math, CommCtrl;

// ***************************************************************

function GetPixelFormat(bmp: TBitmap) : integer;
var ds : TDibSection;
begin
  result := 0;
  if GetObject(bmp.handle, sizeOf(TDibSection), @ds) <> 0 then begin
    result := ds.dsBmih.biBitCount;
    if result = 16 then
      if ds.dsBitFields[2] = $1F then begin
        if (ds.dsBitFields[1] = $3E0) and (ds.dsBitFields[0] = $7C00) then
          result := 15
        else if (ds.dsBitFields[1] <> $7E0) or (ds.dsBitFields[0] <> $F800) then
          result := 0;
      end else
        result := 0;
  end;
end;

function ForcePixelFormat(const bmps: array of TBitmap; pixelFormat: TPixelFormat) : boolean;
var i1 : integer;
begin
  result := true;
  for i1 := 0 to high(bmps) do
    if (bmps[i1].PixelFormat <> pixelFormat) and
       ((pixelFormat <> pf15bit) or (GetPixelFormat(bmps[i1]) <> 15)) then begin
      bmps[i1].PixelFormat := pixelFormat;
      if (bmps[i1].PixelFormat <> pixelFormat) and
         ((pixelFormat <> pf15bit) or (GetPixelFormat(bmps[i1]) <> 15)) then begin
        result := false;
        exit;
      end;
    end;
end;

// ***************************************************************

type
  TXtab32 = array [0..2*255 + 4*255 + 1*255] of integer;
  TXtab16 = array [0..2*031 + 2*063 + 1*031] of word;
  TXtab15 = array [0..2*031 + 4*031 + 1*031] of word;

var
  xtab32      : array [TGrayPercent] of TXtab32;
  xtab16      : array [TGrayPercent] of TXtab16;
  xtab15      : array [TGrayPercent] of TXtab15;
  xtab32Ready : array [TGrayPercent] of boolean = (false, false, false, false);
  xtab16Ready : array [TGrayPercent] of boolean = (false, false, false, false);
  xtab15Ready : array [TGrayPercent] of boolean = (false, false, false, false);

//32bit: 160ms                                     -> 100ms 130 125
//24bit: 140ms                                     -> 120ms 165 155
//16bit: 245ms  (355ms for the non-asm variant)    -> 100ms 130 140
//15bit: not supported by my graphics card         -> 100ms 130 170

procedure GrayScale(bmp: TBitmap; percent: TGrayPercent = gp100);

  procedure GrayScaleLine15_100(line: pointer; width: integer; var xtab);
  asm
    push  edi
    push  ebx

    mov   edi,   eax
    mov   ebx,   edx
    shl   ebx,   1
    add   ebx,   eax
   @0:
    movzx eax,   word[edi]
    mov   edx,   eax
    and   eax,   $000003E0
    shr   eax,   3
    and   edx,   $0000001F
    add   eax,   edx
    movzx edx,   word[edi]
    shr   edx,   9
    and   edx,   $FE
    add   eax,   edx
    mov   ax,    [eax*2+ecx]
    mov   [edi], ax
    add   edi,   2
    cmp   ebx,   edi
    jnz   @0

    pop   ebx
    pop   edi
  end;

  procedure GrayScaleLine15_75(line: pointer; width: integer; var xtab);
  asm
    push  edi
    push  esi
    push  ebx

    mov   edi,   eax
    mov   esi,   edx
    shl   esi,   1
    add   esi,   eax
   @0:
    movzx eax,   word[edi]
    mov   edx,   eax
    mov   ebx,   eax
    shr   ebx,   2
    and   ebx,   $1CE7
    and   edx,   $0000001F
    and   eax,   $000003E0
    shr   eax,   3
    add   edx,   eax
    movzx eax,   word[edi]
    shr   eax,   9
    and   edx,   $FE
    add   edx,   eax
    add   bx,    [edx*2+ecx]
    mov   [edi], bx
    add   edi,   2
    cmp   esi,   edi
    jnz   @0

    pop   ebx
    pop   esi
    pop   edi
  end;

  procedure GrayScaleLine15_50(line: pointer; width: integer; var xtab);
  asm
    push  edi
    push  esi
    push  ebx

    mov   edi,   eax
    mov   esi,   edx
    shl   esi,   1
    add   esi,   eax
   @0:
    movzx eax,   word[edi]
    mov   edx,   eax
    mov   ebx,   eax
    shr   ebx,   1
    and   ebx,   $3DEF
    and   edx,   $0000001F
    and   eax,   $000003E0
    shr   eax,   3
    add   edx,   eax
    movzx eax,   word[edi]
    shr   eax,   9
    and   edx,   $FE
    add   edx,   eax
    add   bx,    [edx*2+ecx]
    mov   [edi], bx
    add   edi,   2
    cmp   esi,   edi
    jnz   @0

    pop   ebx
    pop   esi
    pop   edi
  end;

  procedure GrayScaleLine16_100(line: pointer; width: integer; var xtab);
  asm
    push  edi
    push  ebx

    mov   edi,   eax
    mov   ebx,   edx
    shl   ebx,   1
    add   ebx,   eax
   @0:
    movzx eax,   word[edi]
    mov   edx,   eax
    and   eax,   $000007E0
    shr   eax,   4
    and   edx,   $0000001F
    add   eax,   edx
    movzx edx,   word[edi]
    shr   edx,   10
    and   edx,   $FE
    add   eax,   edx
    mov   ax,    [eax*2+ecx]
    mov   [edi], ax
    add   edi,   2
    cmp   ebx,   edi
    jnz   @0

    pop   ebx
    pop   edi
  end;

  procedure GrayScaleLine16_75(line: pointer; width: integer; var xtab);
  asm
    push  edi
    push  esi
    push  ebx

    mov   edi,   eax
    mov   esi,   edx
    shl   esi,   1
    add   esi,   eax
   @0:
    movzx eax,   word[edi]
    mov   edx,   eax
    mov   ebx,   eax
    shr   ebx,   2
    and   ebx,   $39E7
    and   edx,   $0000001F
    and   eax,   $000007E0
    shr   eax,   4
    add   edx,   eax
    movzx eax,   word[edi]
    shr   eax,   10
    and   edx,   $FE
    add   edx,   eax
    add   bx,    [edx*2+ecx]
    mov   [edi], bx
    add   edi,   2
    cmp   esi,   edi
    jnz   @0

    pop   ebx
    pop   esi
    pop   edi
  end;

  procedure GrayScaleLine16_50(line: pointer; width: integer; var xtab);
  asm
    push  edi
    push  esi
    push  ebx

    mov   edi,   eax
    mov   esi,   edx
    shl   esi,   1
    add   esi,   eax
   @0:
    movzx eax,   word[edi]
    mov   edx,   eax
    mov   ebx,   eax
    shr   ebx,   1
    and   ebx,   $7BEF
    and   edx,   $0000001F
    and   eax,   $000007E0
    shr   eax,   4
    add   edx,   eax
    movzx eax,   word[edi]
    shr   eax,   10
    and   edx,   $FE
    add   edx,   eax
    add   bx,    [edx*2+ecx]
    mov   [edi], bx
    add   edi,   2
    cmp   esi,   edi
    jnz   @0

    pop   ebx
    pop   esi
    pop   edi
  end;

  procedure GrayScaleLine24_100(line: pointer; width: integer; var xtab);
  asm
    push  edi
    push  ebx

    mov   edi,     eax
    mov   ebx,     edx
    add   ebx,     edx
    add   ebx,     edx
    add   ebx,     eax
   @0:
    movzx edx,     byte[edi+2]
    movzx eax,     byte[edi+1]
    shl   eax,     2
    add   edx,     eax
    movzx eax,     byte[edi]
    add   edx,     eax
    add   edx,     eax
    mov   edx,     [edx*4+ecx]
    mov   [edi],   dl
    mov   [edi+1], dl
    mov   [edi+2], dl
    add   edi,     3
    cmp   ebx,     edi
    jnz   @0

    pop   ebx
    pop   edi
  end;

  procedure GrayScaleLine24_75(line: pointer; width: integer; var xtab);
  asm
    push  edi
    push  esi
    push  ebx

    mov   edi,     eax
    mov   esi,     edx
    add   esi,     edx
    add   esi,     edx
    add   esi,     eax
   @0:
    movzx eax,     byte[edi+2]
    mov   ebx,     [edi]
    shr   ebx,     2
    and   ebx,     $003F3F3F
    movzx edx,     byte[edi+1]
    shl   edx,     2
    add   eax,     edx
    movzx edx,     byte[edi]
    add   eax,     edx
    add   eax,     edx
    add   ebx,     [eax*4+ecx]
    mov   [edi],   bl
    shr   ebx,     8
    mov   [edi+1], bl
    mov   [edi+2], bh
    add   edi,     3
    cmp   esi,     edi
    jnz   @0

    pop   ebx
    pop   esi
    pop   edi
  end;

  procedure GrayScaleLine24_50(line: pointer; width: integer; var xtab);
  asm
    push  edi
    push  esi
    push  ebx

    mov   edi,     eax
    mov   esi,     edx
    add   esi,     edx
    add   esi,     edx
    add   esi,     eax
   @0:
    movzx eax,     byte[edi+2]
    mov   ebx,     [edi]
    shr   ebx,     1
    and   ebx,     $007F7F7F
    movzx edx,     byte[edi+1]
    shl   edx,     2
    add   eax,     edx
    movzx edx,     byte[edi]
    add   eax,     edx
    add   eax,     edx
    add   ebx,     [eax*4+ecx]
    mov   [edi],   bl
    shr   ebx,     8
    mov   [edi+1], bl
    mov   [edi+2], bh
    add   edi,     3
    cmp   esi,     edi
    jnz   @0

    pop   ebx
    pop   esi
    pop   edi
  end;

  procedure GrayScaleLine32_100(line: pointer; width: integer; var xtab);
  asm
    push  edi
    push  ebx

    mov   edi,   eax
    mov   ebx,   edx
    shl   ebx,   2
    add   ebx,   eax
   @0:
    movzx eax,   byte[edi+2]
    movzx edx,   byte[edi+1]
    shl   edx,   2
    add   eax,   edx
    movzx edx,   byte[edi]
    add   eax,   edx
    add   eax,   edx
    mov   eax,   [eax*4+ecx]
    mov   [edi], eax
    add   edi,   4
    cmp   ebx,   edi
    jnz   @0

    pop   ebx
    pop   edi
  end;

  procedure GrayScaleLine32_75(line: pointer; width: integer; var xtab);
  asm
    push  edi
    push  esi
    push  ebx

    mov   edi,   eax
    mov   esi,   edx
    shl   esi,   2
    add   esi,   eax
   @0:
    movzx eax,   byte[edi+2]
    mov   ebx,   [edi]
    shr   ebx,   2
    and   ebx,   $003F3F3F
    movzx edx,   byte[edi+1]
    shl   edx,   2
    add   eax,   edx
    movzx edx,   byte[edi]
    add   eax,   edx
    add   eax,   edx
    add   ebx,   [eax*4+ecx]
    mov   [edi], ebx
    add   edi,   4
    cmp   esi,   edi
    jnz   @0

    pop   ebx
    pop   esi
    pop   edi
  end;

  procedure GrayScaleLine32_50(line: pointer; width: integer; var xtab);
  asm
    push  edi
    push  esi
    push  ebx

    mov   edi,   eax
    mov   esi,   edx
    shl   esi,   2
    add   esi,   eax
   @0:
    movzx eax,   byte[edi+2]
    mov   ebx,   [edi]
    shr   ebx,   1
    and   ebx,   $007F7F7F
    movzx edx,   byte[edi+1]
    shl   edx,   2
    add   eax,   edx
    movzx edx,   byte[edi]
    add   eax,   edx
    add   eax,   edx
    add   ebx,   [eax*4+ecx]
    mov   [edi], ebx
    add   edi,   4
    cmp   esi,   edi
    jnz   @0

    pop   ebx
    pop   esi
    pop   edi
  end;

  procedure CheckXTab32(gp: TGrayPercent);
  var i1   : integer;
      gray : integer;
  begin
    if not xtab32Ready[gp] then begin
      for i1 := 0 to high(xtab32[gp]) do begin
        gray := round(i1 / 7);
        case gp of
          gp50 : gray := gray div 2;
          gp75 : gray := gray - gray div 4;
        end;
        xtab32[gp][i1] := gray shl 16 + gray shl 8 + gray;
      end;
      xtab32Ready[gp] := true;
    end;
  end;

  procedure CheckXTab16(gp: TGrayPercent);
  var i1   : integer;
      gray : integer;
  begin
    if not xtab16Ready[gp] then begin
      for i1 := 0 to high(xtab16[gp]) do begin
        gray := round(i1 * 31 / high(xtab16[gp]));
        case gp of
          gp50 : gray := gray div 2;
          gp75 : gray := gray - gray div 4;
        end;
        xtab16[gp][i1] := gray shl 11 + gray shl 6 + gray;
      end;
      xtab16Ready[gp] := true;
    end;
  end;

  procedure CheckXTab15(gp: TGrayPercent);
  var i1   : integer;
      gray : integer;
  begin
    if not xtab15Ready[gp] then begin
      for i1 := 0 to high(xtab15[gp]) do begin
        gray := round(i1 * 31 / high(xtab15[gp]));
        case gp of
          gp50 : gray := gray div 2;
          gp75 : gray := gray - gray div 4;
        end;
        xtab15[gp][i1] := gray shl 10 + gray shl 5 + gray;
      end;
      xtab15Ready[gp] := true;
    end;
  end;

var iy, iw, ih : integer;
    line       : PByteArray;
    lineDif    : integer;
    casei      : integer;
begin
  if percent <> gp0 then
    with bmp do begin
      iw := Width;
      ih := Height;
      if (iw > 0) and (ih > 0) then begin
        if GetPixelFormat(bmp) < 15 then PixelFormat := pf32bit;
        case GetPixelFormat(bmp) of
          15 : begin casei := $150; CheckXTab15(percent) end;
          16 : begin casei := $160; CheckXTab16(percent) end;
          24 : begin casei := $240; CheckXTab32(percent) end;
          32 : begin casei := $320; CheckXtab32(percent) end;
          else exit;
        end;
        inc(casei, ord(percent));
        line := ScanLine[0];
        if ih > 1 then lineDif := integer(ScanLine[1]) - integer(line)
        else           lineDif := 0;
        for iy := 0 to Height - 1 do begin
          case casei of
            $150 : GrayScaleLine15_100(line, iw, xtab15[gp100]);
            $151 : GrayScaleLine15_75 (line, iw, xtab15[gp75 ]);
            $152 : GrayScaleLine15_50 (line, iw, xtab15[gp50 ]);
            $160 : GrayScaleLine16_100(line, iw, xtab16[gp100]);
            $161 : GrayScaleLine16_75 (line, iw, xtab16[gp75 ]);
            $162 : GrayScaleLine16_50 (line, iw, xtab16[gp50 ]);
            $240 : GrayScaleLine24_100(line, iw, xtab32[gp100]);
            $241 : GrayScaleLine24_75 (line, iw, xtab32[gp75 ]);
            $242 : GrayScaleLine24_50 (line, iw, xtab32[gp50 ]);
            $320 : GrayScaleLine32_100(line, iw, xtab32[gp100]);
            $321 : GrayScaleLine32_75 (line, iw, xtab32[gp75 ]);
            $322 : GrayScaleLine32_50 (line, iw, xtab32[gp50 ]);
          end;
          inc(integer(line), lineDif);
        end;
      end;
    end;
end;

// ***************************************************************

var MitchellScaleListCache   : TList = nil;
    MitchellScaleListSection : TRTLCriticalSection;

procedure StretchBitmap(srcBmp, dstBmp : TBitmap;
                        srcMsk, dstMsk : TBitmap;
                        quality        : TStretchQuality = sqHigh);
type
  TContributorPixel = record
    pixel  : integer;  // source pixel
    weight : integer;  // weight of this source pixel
  end;
  TPContributorPixel = ^TContributorPixel;

  // list of source pixels contributing to the destination pixel
  TContributorPixels = record
    itemCount : integer;
    items     : TPContributorPixel;
  end;

  // list for the full width/height of a bitmap
  TContributorList  = array [0..0] of TContributorPixels;
  TPContributorList = ^TContributorList;

  // full list structure including src and dst information
  TMitchellScaleList = record
    src, dst        : integer;
    contributorList : TPContributorList;
  end;

  procedure GetContributorList(var result: TPContributorList; src_, dst_: integer);
  var scale, center, weight : single;
      capacity              : integer;
      i1, i2                : integer;
      pcp                   : TPContributorPixel;
      msl                   : ^TMitchellScaleList;
  begin
    if MitchellScaleListCache = nil then
      InitializeCriticalSection(MitchellScaleListSection);
    EnterCriticalSection(MitchellScaleListSection);
    try
      if MitchellScaleListCache = nil then
        MitchellScaleListCache := TList.Create;
      for i1 := 0 to MitchellScaleListCache.Count - 1 do
        with TMitchellScaleList(pointer(MitchellScaleListCache[i1])^) do
          if (src = src_) and (dst = dst_) then begin
            result := contributorList;
            exit;
          end;
      GetMem(result, dst_ * sizeof(TContributorPixels));
      if dst_ < src_ then begin
        scale := dst_ / src_;
        capacity := (4 * src_ div dst_ + 1) * sizeOf(TContributorPixel);
        for i1 := 0 to dst_ - 1 do
          with result^[i1] do begin
            GetMem(items, capacity);
            pcp := items;
            for i2 := ((i1 - 2) * src_ - dst_ + 1) div dst_ to ((i1 + 2) * src_ + dst_ - 1) div dst_ do begin
              weight := abs(i1 - i2 * scale);
              if weight < 2 then begin
                if weight < 1 then
                     pcp^.weight := round((((  7 /  6 * weight - 2) * weight         ) * weight +  8 / 9) * scale * $10000)
                else pcp^.weight := round((((- 7 / 18 * weight + 2) * weight - 10 / 3) * weight + 16 / 9) * scale * $10000);
                if      i2 <  0    then pcp^.pixel := - i2
                else if i2 >= src_ then pcp^.pixel := src_ * 2 - i2 - 1
                else                    pcp^.pixel := i2;
                inc(pcp);
              end;
            end;
            itemCount := (integer(pcp) - integer(items)) div sizeOf(TContributorPixel) - 1;
          end;
      end else begin
        scale := src_ / dst_;
        for i1 := 0 to dst_ - 1 do
          with result^[i1] do begin
            GetMem(items, 5 * sizeOf(TContributorPixel));
            pcp := items;
            center := i1 * scale;
            for i2 := (i1 * src_ - 3 * dst_ + 1) div dst_ to (i1 * src_ + 3 * dst_ - 1) div dst_ do begin
              weight := abs(center - i2);
              if weight < 2 then begin
                if weight < 1 then
                     pcp^.weight := round((((  7 /  6 * weight - 2) * weight         ) * weight +  8 / 9) * $10000)
                else pcp^.weight := round((((- 7 / 18 * weight + 2) * weight - 10 / 3) * weight + 16 / 9) * $10000);
                if      i2 <  0    then pcp^.pixel := - i2
                else if i2 >= src_ then pcp^.pixel := src_ * 2 - i2 - 1
                else                    pcp^.pixel := i2;
                inc(pcp);
              end;
            end;
            itemCount := (integer(pcp) - integer(items)) div sizeOf(TContributorPixel) - 1;
          end;
      end;
      New(msl);
      msl^.src             := src_;
      msl^.dst             := dst_;
      msl^.contributorList := result;
      MitchellScaleListCache.Add(msl);
    finally LeaveCriticalSection(MitchellScaleListSection) end;
  end;

  procedure MitchellResampling15;  // 370 / 195
  var ix, iy, ic     : integer;
      weight         : integer;
      clx, cly       : TPContributorList;
      fr, fg, fb, fm : integer;
      sbBits, dbBits : integer;
      smBits, dmBits : integer;
      sbDif,  dbDif  : integer;
      smDif,  dmDif  : integer;
      sbLine, tbBuf  : PWordArray;
      smLine, tmBuf  : PByteArray;
      dbPix          : ^word;
      dmPix          : ^byte;
      pcp            : TPContributorPixel;
      dw1            : integer;
  begin
    GetContributorList(clx, srcBmp.Width,  dstBmp.Width );
    GetContributorList(cly, srcBmp.Height, dstBmp.Height);
    tbBuf  := AllocMem(srcBmp.Height * 2 + srcBmp.Height * 1);
    sbBits := integer(srcBmp.ScanLine[0]);
    dbBits := integer(dstBmp.ScanLine[0]);
    if srcBmp.Height > 1 then
         sbDif := integer(srcBmp.ScanLine[1]) - sbBits
    else sbDif := 0;
    if dstBmp.Height > 1 then
         dbDif := integer(dstBmp.ScanLine[1]) - dbBits
    else dbDif := 0;
    if srcMsk <> nil then begin
      tmBuf  := pointer(integer(tbBuf) + srcBmp.Height * 2);
      smBits := integer(srcMsk.ScanLine[0]);
      dmBits := integer(dstMsk.ScanLine[0]);
      if srcMsk.Height > 1 then
           smDif := integer(srcMsk.ScanLine[1]) - smBits
      else smDif := 0;
      if dstMsk.Height > 1 then
           dmDif := integer(dstMsk.ScanLine[1]) - dmBits
      else dmDif := 0;
      for ix := 0 to dstBmp.Width - 1 do begin
        dbPix  := pointer(tbBuf );
        dmPix  := pointer(tmBuf );
        sbLine := pointer(sbBits);
        smLine := pointer(smBits);
        for iy := 0 to srcBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          fm  := 0;
          pcp := clx^[ix].items;
          for ic := 0 to clx^[ix].itemCount do begin
            weight := (pcp^.weight * (256 - smLine^[pcp^.pixel])) div 256;
            inc(fm, weight);
            dw1 := sbLine^[pcp^.pixel];
            inc(fr, (dw1 shr 10   ) * weight);
            inc(fg, (dw1 and $03E0) * weight);
            inc(fb, (dw1 and $001F) * weight);
            inc(pcp);
          end;
          if      fr <         0 then fr := 0
          else if fr > $001F0000 then fr := $7C00
          else                        fr := (fr shr 6) and $7C00;
          if      fg <         0 then
          else if fg > $03E00000 then inc(fr, $03E0)
          else                        inc(fr, (fg shr 16) and $03E0);
          if      fb <         0 then
          else if fb > $001F0000 then inc(fr, $001F)
          else                        inc(fr, fb shr 16);
          dbPix^ := word(fr);
          inc(dbPix);
          if      fm <         0 then dmPix^ := 255
          else if fm > $0000FF00 then dmPix^ := 0
          else                        dmPix^ := 255 - fm shr 8;
          inc(dmPix);
          inc(integer(sbLine), sbDif);
          inc(integer(smLine), smDif);
        end;
        dbPix := pointer(dbBits + ix * 2);
        dmPix := pointer(dmBits + ix    );
        for iy := 0 to dstBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          fm  := 0;
          pcp := cly^[iy].items;
          for ic := 0 to cly^[iy].itemCount do begin
            weight := (pcp^.weight * (256 - tmBuf^[pcp^.pixel])) div 256;
            inc(fm, weight);
            dw1 := tbBuf^[pcp^.pixel];
            inc(fr, (dw1 shr 10   ) * weight);
            inc(fg, (dw1 and $03E0) * weight);
            inc(fb, (dw1 and $001F) * weight);
            inc(pcp);
          end;
          if      fr <         0 then fr := 0
          else if fr > $001F0000 then fr := $7C00
          else                        fr := (fr shr 6) and $7C00;
          if      fg <         0 then
          else if fg > $03E00000 then inc(fr, $03E0)
          else                        inc(fr, (fg shr 16) and $03E0);
          if      fb <         0 then
          else if fb > $001F0000 then inc(fr, $001F)
          else                        inc(fr, fb shr 16);
          dbPix^ := word(fr);
          inc(integer(dbPix), dbDif);
          if      fm <         0 then dmPix^ := 255
          else if fm > $0000FF00 then dmPix^ := 0
          else                        dmPix^ := 255 - fm shr 8;
          inc(dmPix, dmDif);
        end;
      end;
    end else
      for ix := 0 to dstBmp.Width - 1 do begin
        dbPix  := pointer(tbBuf );
        sbLine := pointer(sbBits);
        for iy := 0 to srcBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          pcp := clx^[ix].items;
          for ic := 0 to clx^[ix].itemCount do begin
            weight := pcp^.weight;
            dw1 := sbLine^[pcp^.pixel];
            inc(fr, (dw1 shr 10   ) * weight);
            inc(fg, (dw1 and $03E0) * weight);
            inc(fb, (dw1 and $001F) * weight);
            inc(pcp);
          end;
          if      fr <         0 then fr := 0
          else if fr > $001F0000 then fr := $7C00
          else                        fr := (fr shr 6) and $7C00;
          if      fg <         0 then
          else if fg > $03E00000 then inc(fr, $03E0)
          else                        inc(fr, (fg shr 16) and $03E0);
          if      fb <         0 then
          else if fb > $001F0000 then inc(fr, $001F)
          else                        inc(fr, fb shr 16);
          dbPix^ := word(fr);
          inc(dbPix);
          inc(integer(sbLine), sbDif);
        end;
        dbPix := pointer(dbBits + ix * 2);
        for iy := 0 to dstBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          pcp := cly^[iy].items;
          for ic := 0 to cly^[iy].itemCount do begin
            weight := pcp^.weight;
            dw1 := tbBuf^[pcp^.pixel];
            inc(fr, (dw1 shr 10   ) * weight);
            inc(fg, (dw1 and $03E0) * weight);
            inc(fb, (dw1 and $001F) * weight);
            inc(pcp);
          end;
          if      fr <         0 then fr := 0
          else if fr > $001F0000 then fr := $7C00
          else                        fr := (fr shr 6) and $7C00;
          if      fg <         0 then
          else if fg > $03E00000 then inc(fr, $03E0)
          else                        inc(fr, (fg shr 16) and $03E0);
          if      fb <         0 then
          else if fb > $001F0000 then inc(fr, $001F)
          else                        inc(fr, fb shr 16);
          dbPix^ := word(fr);
          inc(integer(dbPix), dbDif);
        end;
      end;
    FreeMem(tbBuf);
  end;

  procedure MitchellResampling16;  // 370 / 195
  var ix, iy, ic     : integer;
      weight         : integer;
      clx, cly       : TPContributorList;
      fr, fg, fb, fm : integer;
      sbBits, dbBits : integer;
      smBits, dmBits : integer;
      sbDif,  dbDif  : integer;
      smDif,  dmDif  : integer;
      sbLine, tbBuf  : PWordArray;
      smLine, tmBuf  : PByteArray;
      dbPix          : ^word;
      dmPix          : ^byte;
      pcp            : TPContributorPixel;
      dw1            : integer;
  begin
    GetContributorList(clx, srcBmp.Width,  dstBmp.Width );
    GetContributorList(cly, srcBmp.Height, dstBmp.Height);
    tbBuf  := AllocMem(srcBmp.Height * 2 + srcBmp.Height * 1);
    sbBits := integer(srcBmp.ScanLine[0]);
    dbBits := integer(dstBmp.ScanLine[0]);
    if srcBmp.Height > 1 then
         sbDif := integer(srcBmp.ScanLine[1]) - sbBits
    else sbDif := 0;
    if dstBmp.Height > 1 then
         dbDif := integer(dstBmp.ScanLine[1]) - dbBits
    else dbDif := 0;
    if srcMsk <> nil then begin
      tmBuf  := pointer(integer(tbBuf) + srcBmp.Height * 2);
      smBits := integer(srcMsk.ScanLine[0]);
      dmBits := integer(dstMsk.ScanLine[0]);
      if srcMsk.Height > 1 then
           smDif := integer(srcMsk.ScanLine[1]) - smBits
      else smDif := 0;
      if dstMsk.Height > 1 then
           dmDif := integer(dstMsk.ScanLine[1]) - dmBits
      else dmDif := 0;
      for ix := 0 to dstBmp.Width - 1 do begin
        dbPix  := pointer(tbBuf );
        dmPix  := pointer(tmBuf );
        sbLine := pointer(sbBits);
        smLine := pointer(smBits);
        for iy := 0 to srcBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          fm  := 0;
          pcp := clx^[ix].items;
          for ic := 0 to clx^[ix].itemCount do begin
            weight := (pcp^.weight * (256 - smLine^[pcp^.pixel])) div 256;
            inc(fm, weight);
            dw1 := sbLine^[pcp^.pixel];
            inc(fr, (dw1 shr 11   ) * weight);
            inc(fg, (dw1 and $07E0) * weight);
            inc(fb, (dw1 and $001F) * weight);
            inc(pcp);
          end;
          if      fr <         0 then fr := 0
          else if fr > $001F0000 then fr := $F800
          else                        fr := (fr shr 5) and $F800;
          if      fg <         0 then
          else if fg > $07E00000 then inc(fr, $07E0)
          else                        inc(fr, (fg shr 16) and $07E0);
          if      fb <         0 then
          else if fb > $001F0000 then inc(fr, $001F)
          else                        inc(fr, fb shr 16);
          dbPix^ := word(fr);
          inc(dbPix);
          if      fm <         0 then dmPix^ := 255
          else if fm > $0000FF00 then dmPix^ := 0
          else                        dmPix^ := 255 - fm shr 8;
          inc(dmPix);
          inc(integer(sbLine), sbDif);
          inc(integer(smLine), smDif);
        end;
        dbPix := pointer(dbBits + ix * 2);
        dmPix := pointer(dmBits + ix    );
        for iy := 0 to dstBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          fm  := 0;
          pcp := cly^[iy].items;
          for ic := 0 to cly^[iy].itemCount do begin
            weight := (pcp^.weight * (256 - tmBuf^[pcp^.pixel])) div 256;
            inc(fm, weight);
            dw1 := tbBuf^[pcp^.pixel];
            inc(fr, (dw1 shr 11   ) * weight);
            inc(fg, (dw1 and $07E0) * weight);
            inc(fb, (dw1 and $001F) * weight);
            inc(pcp);
          end;
          if      fr <         0 then fr := 0
          else if fr > $001F0000 then fr := $F800
          else                        fr := (fr shr 5) and $F800;
          if      fg <         0 then
          else if fg > $07E00000 then inc(fr, $07E0)
          else                        inc(fr, (fg shr 16) and $07E0);
          if      fb <         0 then
          else if fb > $001F0000 then inc(fr, $001F)
          else                        inc(fr, fb shr 16);
          dbPix^ := word(fr);
          inc(integer(dbPix), dbDif);
          if      fm <         0 then dmPix^ := 255
          else if fm > $0000FF00 then dmPix^ := 0
          else                        dmPix^ := 255 - fm shr 8;
          inc(dmPix, dmDif);
        end;
      end;
    end else
      for ix := 0 to dstBmp.Width - 1 do begin
        dbPix  := pointer(tbBuf );
        sbLine := pointer(sbBits);
        for iy := 0 to srcBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          pcp := clx^[ix].items;
          for ic := 0 to clx^[ix].itemCount do begin
            weight := pcp^.weight;
            dw1 := sbLine^[pcp^.pixel];
            inc(fr, (dw1 shr 11   ) * weight);
            inc(fg, (dw1 and $07E0) * weight);
            inc(fb, (dw1 and $001F) * weight);
            inc(pcp);
          end;
          if      fr <         0 then fr := 0
          else if fr > $001F0000 then fr := $F800
          else                        fr := (fr shr 5) and $F800;
          if      fg <         0 then
          else if fg > $07E00000 then inc(fr, $07E0)
          else                        inc(fr, (fg shr 16) and $07E0);
          if      fb <         0 then
          else if fb > $001F0000 then inc(fr, $001F)
          else                        inc(fr, fb shr 16);
          dbPix^ := word(fr);
          inc(dbPix);
          inc(integer(sbLine), sbDif);
        end;
        dbPix := pointer(dbBits + ix * 2);
        for iy := 0 to dstBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          pcp := cly^[iy].items;
          for ic := 0 to cly^[iy].itemCount do begin
            weight := pcp^.weight;
            dw1 := tbBuf^[pcp^.pixel];
            inc(fr, (dw1 shr 11   ) * weight);
            inc(fg, (dw1 and $07E0) * weight);
            inc(fb, (dw1 and $001F) * weight);
            inc(pcp);
          end;
          if      fr <         0 then fr := 0
          else if fr > $001F0000 then fr := $F800
          else                        fr := (fr shr 5) and $F800;
          if      fg <         0 then
          else if fg > $07E00000 then inc(fr, $07E0)
          else                        inc(fr, (fg shr 16) and $07E0);
          if      fb <         0 then
          else if fb > $001F0000 then inc(fr, $001F)
          else                        inc(fr, fb shr 16);
          dbPix^ := word(fr);
          inc(integer(dbPix), dbDif);
        end;
      end;
    FreeMem(tbBuf);
  end;

  procedure MitchellResampling24;  // 385 / 200
  type TRGB = packed record r, g, b: byte; end;
  var ix, iy, ic     : integer;
      weight         : integer;
      clx, cly       : TPContributorList;
      fr, fg, fb, fm : integer;
      sbBits, dbBits : integer;
      smBits, dmBits : integer;
      sbDif,  dbDif  : integer;
      smDif,  dmDif  : integer;
      sbLine, tbBuf  : PByteArray;
      smLine, tmBuf  : PByteArray;
      dbPix          : ^byte;
      dmPix          : ^byte;
      pcp            : TPContributorPixel;
  begin
    GetContributorList(clx, srcBmp.Width,  dstBmp.Width );
    GetContributorList(cly, srcBmp.Height, dstBmp.Height);
    tbBuf  := AllocMem(srcBmp.Height * 4 + srcBmp.Height * 1);
    sbBits := integer(srcBmp.ScanLine[0]);
    dbBits := integer(dstBmp.ScanLine[0]);
    if srcBmp.Height > 1 then
         sbDif := integer(srcBmp.ScanLine[1]) - sbBits
    else sbDif := 0;
    if dstBmp.Height > 1 then
         dbDif := integer(dstBmp.ScanLine[1]) - dbBits - 2
    else dbDif := 0;
    if srcMsk <> nil then begin
      tmBuf  := pointer(integer(tbBuf) + srcBmp.Height * 4);
      smBits := integer(srcMsk.ScanLine[0]);
      dmBits := integer(dstMsk.ScanLine[0]);
      if srcMsk.Height > 1 then
           smDif := integer(srcMsk.ScanLine[1]) - smBits
      else smDif := 0;
      if dstMsk.Height > 1 then
           dmDif := integer(dstMsk.ScanLine[1]) - dmBits
      else dmDif := 0;
      for ix := 0 to dstBmp.Width - 1 do begin
        dbPix  := pointer(tbBuf );
        sbLine := pointer(sbBits);
        dmPix  := pointer(tmBuf );
        smLine := pointer(smBits);
        for iy := 0 to srcBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          fm  := 0;
          pcp := clx^[ix].items;
          for ic := 0 to clx^[ix].itemCount do begin
            weight := (pcp^.weight * (256 - smLine^[pcp^.pixel])) div 256;
            inc(fm, weight);
            with TRGB(pointer(@sbLine^[pcp^.pixel * 3])^) do begin
              inc(fr, r * weight);
              inc(fg, g * weight);
              inc(fb, b * weight);
            end;
            inc(pcp);
          end;
          if      fr <       0 then dbPix^ := 0
          else if fr > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fr shr 16;
          inc(dbPix);
          if      fg <       0 then dbPix^ := 0
          else if fg > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fg shr 16;
          inc(dbPix);
          if      fb <       0 then dbPix^ := 0
          else if fb > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fb shr 16;
          inc(dbPix, 2);
          if      fm <       0 then dmPix^ := 255
          else if fm > $00FF00 then dmPix^ := 0
          else                      dmPix^ := 255 - fm shr 8;
          inc(dmPix);
          inc(integer(sbLine), sbDif);
          inc(integer(smLine), smDif);
        end;
        dbPix := pointer(dbBits + ix * 3);
        dmPix := pointer(dmBits + ix    );
        for iy := 0 to dstBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          fm  := 0;
          pcp := cly^[iy].items;
          for ic := 0 to cly^[iy].itemCount do begin
            weight := (pcp^.weight * (256 - tmBuf^[pcp^.pixel])) div 256;
            inc(fm, weight);
            with TRGB(pointer(@tbBuf^[pcp^.pixel * 4])^) do begin
              inc(fr, r * weight);
              inc(fg, g * weight);
              inc(fb, b * weight);
            end;
            inc(pcp);
          end;
          if      fr <       0 then dbPix^ := 0
          else if fr > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fr shr 16;
          inc(dbPix);
          if      fg <       0 then dbPix^ := 0
          else if fg > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fg shr 16;
          inc(dbPix);
          if      fb <       0 then dbPix^ := 0
          else if fb > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fb shr 16;
          inc(dbPix, dbDif);
          if      fm <       0 then dmPix^ := 255
          else if fm > $00FF00 then dmPix^ := 0
          else                      dmPix^ := 255 - fm shr 8;
          inc(dmPix, dmDif);
        end;
      end;
    end else
      for ix := 0 to dstBmp.Width - 1 do begin
        dbPix  := pointer(tbBuf );
        sbLine := pointer(sbBits);
        for iy := 0 to srcBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          pcp := clx^[ix].items;
          for ic := 0 to clx^[ix].itemCount do begin
            weight := pcp^.weight;
            with TRGB(pointer(@sbLine^[pcp^.pixel * 3])^) do begin
              inc(fr, r * weight);
              inc(fg, g * weight);
              inc(fb, b * weight);
            end;
            inc(pcp);
          end;
          if      fr <       0 then dbPix^ := 0
          else if fr > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fr shr 16;
          inc(dbPix);
          if      fg <       0 then dbPix^ := 0
          else if fg > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fg shr 16;
          inc(dbPix);
          if      fb <       0 then dbPix^ := 0
          else if fb > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fb shr 16;
          inc(dbPix, 2);
          inc(integer(sbLine), sbDif);
        end;
        dbPix := pointer(dbBits + ix * 3);
        for iy := 0 to dstBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          pcp := cly^[iy].items;
          for ic := 0 to cly^[iy].itemCount do begin
            weight := pcp^.weight;
            with TRGB(pointer(@tbBuf^[pcp^.pixel * 4])^) do begin
              inc(fr, r * weight);
              inc(fg, g * weight);
              inc(fb, b * weight);
            end;
            inc(pcp);
          end;
          if      fr <       0 then dbPix^ := 0
          else if fr > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fr shr 16;
          inc(dbPix);
          if      fg <       0 then dbPix^ := 0
          else if fg > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fg shr 16;
          inc(dbPix);
          if      fb <       0 then dbPix^ := 0
          else if fb > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fb shr 16;
          inc(dbPix, dbDif);
        end;
      end;
    FreeMem(tbBuf);
  end;

  procedure MitchellResampling32;  // 375 / 200
  type TRGB = packed record r, g, b: byte; end;
  var ix, iy, ic     : integer;
      weight         : integer;
      clx, cly       : TPContributorList;
      fr, fg, fb, fm : integer;
      sbBits, dbBits : integer;
      smBits, dmBits : integer;
      sbDif,  dbDif  : integer;
      smDif,  dmDif  : integer;
      sbLine, tbBuf  : PByteArray;
      smLine, tmBuf  : PByteArray;
      dbPix          : ^byte;
      dmPix          : ^byte;
      pcp            : TPContributorPixel;
  begin
    GetContributorList(clx, srcBmp.Width,  dstBmp.Width );
    GetContributorList(cly, srcBmp.Height, dstBmp.Height);
    tbBuf  := AllocMem(srcBmp.Height * 4 + srcBmp.Height * 1);
    sbBits := integer(srcBmp.ScanLine[0]);
    dbBits := integer(dstBmp.ScanLine[0]);
    if srcBmp.Height > 1 then
         sbDif := integer(srcBmp.ScanLine[1]) - sbBits
    else sbDif := 0;
    if dstBmp.Height > 1 then
         dbDif := integer(dstBmp.ScanLine[1]) - dbBits - 2
    else dbDif := 0;
    if srcMsk <> nil then begin
      tmBuf  := pointer(integer(tbBuf) + srcBmp.Height * 4);
      smBits := integer(srcMsk.ScanLine[0]);
      dmBits := integer(dstMsk.ScanLine[0]);
      if srcMsk.Height > 1 then
           smDif := integer(srcMsk.ScanLine[1]) - smBits
      else smDif := 0;
      if dstMsk.Height > 1 then
           dmDif := integer(dstMsk.ScanLine[1]) - dmBits
      else dmDif := 0;
      for ix := 0 to dstBmp.Width - 1 do begin
        dbPix  := pointer(tbBuf );
        sbLine := pointer(sbBits);
        dmPix  := pointer(tmBuf );
        smLine := pointer(smBits);
        for iy := 0 to srcBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          fm  := 0;
          pcp := clx^[ix].items;
          for ic := 0 to clx^[ix].itemCount do begin
            weight := (pcp^.weight * (256 - smLine^[pcp^.pixel])) div 256;
            inc(fm, weight);
            with TRGB(pointer(@sbLine^[pcp^.pixel * 4])^) do begin
              inc(fr, r * weight);
              inc(fg, g * weight);
              inc(fb, b * weight);
            end;
            inc(pcp);
          end;
          if      fr <       0 then dbPix^ := 0
          else if fr > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fr shr 16;
          inc(dbPix);
          if      fg <       0 then dbPix^ := 0
          else if fg > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fg shr 16;
          inc(dbPix);
          if      fb <       0 then dbPix^ := 0
          else if fb > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fb shr 16;
          inc(dbPix, 2);
          if      fm <       0 then dmPix^ := 255
          else if fm > $00FF00 then dmPix^ := 0
          else                      dmPix^ := 255 - fm shr 8;
          inc(dmPix);
          inc(integer(sbLine), sbDif);
          inc(integer(smLine), smDif);
        end;
        dbPix := pointer(dbBits + ix * 4);
        dmPix := pointer(dmBits + ix    );
        for iy := 0 to dstBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          fm  := 0;
          pcp := cly^[iy].items;
          for ic := 0 to cly^[iy].itemCount do begin
            weight := (pcp^.weight * (256 - tmBuf^[pcp^.pixel])) div 256;
            inc(fm, weight);
            with TRGB(pointer(@tbBuf^[pcp^.pixel * 4])^) do begin
              inc(fr, r * weight);
              inc(fg, g * weight);
              inc(fb, b * weight);
            end;
            inc(pcp);
          end;
          if      fr <       0 then dbPix^ := 0
          else if fr > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fr shr 16;
          inc(dbPix);
          if      fg <       0 then dbPix^ := 0
          else if fg > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fg shr 16;
          inc(dbPix);
          if      fb <       0 then dbPix^ := 0
          else if fb > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fb shr 16;
          inc(dbPix, dbDif);
          if      fm <       0 then dmPix^ := 255
          else if fm > $00FF00 then dmPix^ := 0
          else                      dmPix^ := 255 - fm shr 8;
          inc(dmPix, dmDif);
        end;
      end;
    end else
      for ix := 0 to dstBmp.Width - 1 do begin
        dbPix  := pointer(tbBuf );
        sbLine := pointer(sbBits);
        for iy := 0 to srcBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          pcp := clx^[ix].items;
          for ic := 0 to clx^[ix].itemCount do begin
            weight := pcp^.weight;
            with TRGB(pointer(@sbLine^[pcp^.pixel * 4])^) do begin
              inc(fr, r * weight);
              inc(fg, g * weight);
              inc(fb, b * weight);
            end;
            inc(pcp);
          end;
          if      fr <       0 then dbPix^ := 0
          else if fr > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fr shr 16;
          inc(dbPix);
          if      fg <       0 then dbPix^ := 0
          else if fg > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fg shr 16;
          inc(dbPix);
          if      fb <       0 then dbPix^ := 0
          else if fb > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fb shr 16;
          inc(dbPix, 2);
          inc(integer(sbLine), sbDif);
        end;
        dbPix := pointer(dbBits + ix * 4);
        for iy := 0 to dstBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          pcp := cly^[iy].items;
          for ic := 0 to cly^[iy].itemCount do begin
            weight := pcp^.weight;
            with TRGB(pointer(@tbBuf^[pcp^.pixel * 4])^) do begin
              inc(fr, r * weight);
              inc(fg, g * weight);
              inc(fb, b * weight);
            end;
            inc(pcp);
          end;
          if      fr <       0 then dbPix^ := 0
          else if fr > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fr shr 16;
          inc(dbPix);
          if      fg <       0 then dbPix^ := 0
          else if fg > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fg shr 16;
          inc(dbPix);
          if      fb <       0 then dbPix^ := 0
          else if fb > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fb shr 16;
          inc(dbPix, dbDif);
        end;
      end;
    FreeMem(tbBuf);
  end;

  procedure Bilinear15;  // 2820 -> 540
  var ix, iy                   : integer;
      x, y, xdif, ydif         : integer;
      xp1, xp2, yp             : integer;
      wy, wyi, wx              : integer;
      w11, w21, w12, w22       : integer;
      sbBits, sbLine1, sbLine2 : integer;
      smBits, smLine1, smLine2 : PByteArray;
      dbLine                   : integer;
      dmLine                   : ^byte;
      sbLineDif, dbLineDif     : integer;
      smLineDif, dmLineDif     : integer;
      w                        : integer;
  begin
    y := 0;
    xdif := (srcBmp.Width  shl 16) div dstBmp.Width;
    ydif := (srcBmp.Height shl 16) div dstBmp.Height;
    sbBits := integer(srcBmp.ScanLine[0]);
    if srcBmp.Height > 1 then
         sbLineDif := integer(srcBmp.ScanLine[1]) - sbBits
    else sbLineDif := 0;
    dbLine := integer(dstBmp.ScanLine[0]);
    if dstBmp.Height > 1 then
         dbLineDif := integer(dstBmp.ScanLine[1]) - dbLine - 2 * dstBmp.Width
    else dbLineDif := 0;
    if srcMsk <> nil then begin
      smBits := srcMsk.ScanLine[0];
      if srcMsk.Height > 1 then
           smLineDif := integer(srcMsk.ScanLine[1]) - integer(smBits)
      else smLineDif := 0;
      dmLine := dstMsk.ScanLine[0];
      if dstMsk.Height > 1 then
           dmLineDif := integer(dstMsk.ScanLine[1]) - integer(dmLine) - 1 * dstBmp.Width
      else dmLineDif := 0;
    end else begin
      smBits    := nil;
      smLineDif := 0;
      dmLine    := nil;
      dmLineDif := 0;
    end;
    w := srcBmp.Width - 1;
    for iy := 0 to dstBmp.Height - 1 do begin
      yp := y shr 16;
      integer(sbLine1) := integer(sbBits) + sbLineDif * yp;
      integer(smLine1) := integer(smBits) + smLineDif * yp;
      if yp < srcBmp.Height - 1 then begin
        integer(sbLine2) := integer(sbLine1) + sbLineDif;
        integer(smLine2) := integer(smLine1) + smLineDif;
      end else begin
        sbLine2 := sbLine1;
        smLine2 := smLine1;
      end;
      x   := 0;
      wy  :=      y  and $FFFF;
      wyi := (not y) and $FFFF;
      for ix := 0 to dstBmp.Width - 1 do begin
        xp1 := x shr 16;
        if xp1 < w then xp2 := xp1 + 1
        else            xp2 := xp1;
        wx  := x and $FFFF;
        w21 := (wyi * wx) shr 16; w11 := wyi - w21;
        w22 := (wy  * wx) shr 16; w12 := wy  - w22;
        if smLine1 <> nil then begin
          w11 := (w11 * (256 - smLine1^[xp1])) shr 8;
          w21 := (w21 * (256 - smLine1^[xp2])) shr 8;
          w12 := (w12 * (256 - smLine2^[xp1])) shr 8;
          w22 := (w22 * (256 - smLine2^[xp2])) shr 8;
          dmLine^ := 255 - byte((w11 + w21 + w12 + w22) shr 8);
        end;
        xp1 := xp1 * 2;
        xp2 := xp2 * 2;
        PWord(dbLine)^ := ( ( ( (PWord(sbLine1 + xp1)^ and $001F) * w11 + (PWord(sbLine1 + xp2)^ and $001F) * w21 +
                                (PWord(sbLine2 + xp1)^ and $001F) * w12 + (PWord(sbLine2 + xp2)^ and $001F) * w22   ) shr 16) and $001F) or
                          ( ( ( (PWord(sbLine1 + xp1)^ and $03E0) * w11 + (PWord(sbLine1 + xp2)^ and $03E0) * w21 +
                                (PWord(sbLine2 + xp1)^ and $03E0) * w12 + (PWord(sbLine2 + xp2)^ and $03E0) * w22   ) shr 16) and $03E0) or
                          ( ( ( (PWord(sbLine1 + xp1)^ and $7C00) * w11 + (PWord(sbLine1 + xp2)^ and $7C00) * w21 +
                                (PWord(sbLine2 + xp1)^ and $7C00) * w12 + (PWord(sbLine2 + xp2)^ and $7C00) * w22   ) shr 16) and $7C00);
        inc(dbLine, 2);
        inc(dmLine);
        inc(x, xdif);
      end;
      inc(integer(dbLine), dbLineDif);
      inc(integer(dmLine), dmLineDif);
      inc(y, ydif);
    end;
  end;

  procedure Bilinear16;  // 2440 -> 540
  var ix, iy                   : integer;
      x, y, xdif, ydif         : integer;
      xp1, xp2, yp             : integer;
      wy, wyi, wx              : integer;
      w11, w21, w12, w22       : integer;
      sbBits, sbLine1, sbLine2 : integer;
      smBits, smLine1, smLine2 : PByteArray;
      dbLine                   : integer;
      dmLine                   : ^byte;
      sbLineDif, dbLineDif     : integer;
      smLineDif, dmLineDif     : integer;
      w                        : integer;
  begin
    y := 0;
    xdif := (srcBmp.Width  shl 16) div dstBmp.Width;
    ydif := (srcBmp.Height shl 16) div dstBmp.Height;
    sbBits := integer(srcBmp.ScanLine[0]);
    if srcBmp.Height > 1 then
         sbLineDif := integer(srcBmp.ScanLine[1]) - sbBits
    else sbLineDif := 0;
    dbLine := integer(dstBmp.ScanLine[0]);
    if dstBmp.Height > 1 then
         dbLineDif := integer(dstBmp.ScanLine[1]) - dbLine - 2 * dstBmp.Width
    else dbLineDif := 0;
    if srcMsk <> nil then begin
      smBits := srcMsk.ScanLine[0];
      if srcMsk.Height > 1 then
           smLineDif := integer(srcMsk.ScanLine[1]) - integer(smBits)
      else smLineDif := 0;
      dmLine := dstMsk.ScanLine[0];
      if dstMsk.Height > 1 then
           dmLineDif := integer(dstMsk.ScanLine[1]) - integer(dmLine) - 1 * dstBmp.Width
      else dmLineDif := 0;
    end else begin
      smBits    := nil;
      smLineDif := 0;
      dmLine    := nil;
      dmLineDif := 0;
    end;
    w := srcBmp.Width - 1;
    for iy := 0 to dstBmp.Height - 1 do begin
      yp := y shr 16;
      integer(sbLine1) := integer(sbBits) + sbLineDif * yp;
      integer(smLine1) := integer(smBits) + smLineDif * yp;
      if yp < srcBmp.Height - 1 then begin
        integer(sbLine2) := integer(sbLine1) + sbLineDif;
        integer(smLine2) := integer(smLine1) + smLineDif;
      end else begin
        sbLine2 := sbLine1;
        smLine2 := smLine1;
      end;
      x   := 0;
      wy  :=      y  and $FFFF;
      wyi := (not y) and $FFFF;
      for ix := 0 to dstBmp.Width - 1 do begin
        xp1 := x shr 16;
        if xp1 < w then xp2 := xp1 + 1
        else            xp2 := xp1;
        wx  := x and $FFFF;
        w21 := (wyi * wx) shr 16; w11 := wyi - w21;
        w22 := (wy  * wx) shr 16; w12 := wy  - w22;
        if smLine1 <> nil then begin
          w11 := (w11 * (256 - smLine1^[xp1])) shr 8;
          w21 := (w21 * (256 - smLine1^[xp2])) shr 8;
          w12 := (w12 * (256 - smLine2^[xp1])) shr 8;
          w22 := (w22 * (256 - smLine2^[xp2])) shr 8;
          dmLine^ := 255 - byte((w11 + w21 + w12 + w22) shr 8);
        end;
        xp1 := xp1 * 2;
        xp2 := xp2 * 2;
        PWord(dbLine)^ := ( ( ( (PWord(sbLine1 + xp1)^ and $001F) * w11 + (PWord(sbLine1 + xp2)^ and $001F) * w21 +
                                (PWord(sbLine2 + xp1)^ and $001F) * w12 + (PWord(sbLine2 + xp2)^ and $001F) * w22   ) shr 16) and $001F) or
                          ( ( ( (PWord(sbLine1 + xp1)^ and $07E0) * w11 + (PWord(sbLine1 + xp2)^ and $07E0) * w21 +
                                (PWord(sbLine2 + xp1)^ and $07E0) * w12 + (PWord(sbLine2 + xp2)^ and $07E0) * w22   ) shr 16) and $07E0) or
                          ( ( ( (PWord(sbLine1 + xp1)^ and $F800) * w11 + (PWord(sbLine1 + xp2)^ and $F800) * w21 +
                                (PWord(sbLine2 + xp1)^ and $F800) * w12 + (PWord(sbLine2 + xp2)^ and $F800) * w22   ) shr 16) and $F800);
        inc(dbLine, 2);
        inc(dmLine);
        inc(x, xdif);
      end;
      inc(integer(dbLine), dbLineDif);
      inc(integer(dmLine), dmLineDif);
      inc(y, ydif);
    end;
  end;

  procedure Bilinear24;  // 550 -> 310
  var ix, iy                   : integer;
      x, y, xdif, ydif         : integer;
      xp1, xp2, yp             : integer;
      wy, wyi, wx              : integer;
      w11, w21, w12, w22       : integer;
      sbBits, sbLine1, sbLine2 : PByteArray;
      smBits, smLine1, smLine2 : PByteArray;
      dbLine                   : PByteArray;
      dmLine                   : ^byte;
      sbLineDif, dbLineDif     : integer;
      smLineDif, dmLineDif     : integer;
      w                        : integer;
  begin
    y := 0;
    xdif := (srcBmp.Width  shl 16) div dstBmp.Width;
    ydif := (srcBmp.Height shl 16) div dstBmp.Height;
    sbBits := srcBmp.ScanLine[0];
    if srcBmp.Height > 1 then
         sbLineDif := integer(srcBmp.ScanLine[1]) - integer(sbBits)
    else sbLineDif := 0;
    dbLine := dstBmp.ScanLine[0];
    if dstBmp.Height > 1 then
         dbLineDif := integer(dstBmp.ScanLine[1]) - integer(dbLine) - 3 * dstBmp.Width
    else dbLineDif := 0;
    if srcMsk <> nil then begin
      smBits := srcMsk.ScanLine[0];
      if srcMsk.Height > 1 then
           smLineDif := integer(srcMsk.ScanLine[1]) - integer(smBits)
      else smLineDif := 0;
      dmLine := dstMsk.ScanLine[0];
      if dstMsk.Height > 1 then
           dmLineDif := integer(dstMsk.ScanLine[1]) - integer(dmLine) - 1 * dstBmp.Width
      else dmLineDif := 0;
    end else begin
      smBits    := nil;
      smLineDif := 0;
      dmLine    := nil;
      dmLineDif := 0;
    end;
    w := srcBmp.Width - 1;
    for iy := 0 to dstBmp.Height - 1 do begin
      yp := y shr 16;
      integer(sbLine1) := integer(sbBits) + sbLineDif * yp;
      integer(smLine1) := integer(smBits) + smLineDif * yp;
      if yp < srcBmp.Height - 1 then begin
        integer(sbLine2) := integer(sbLine1) + sbLineDif;
        integer(smLine2) := integer(smLine1) + smLineDif;
      end else begin
        sbLine2 := sbLine1;
        smLine2 := smLine1;
      end;
      x   := 0;
      wy  :=      y  and $FFFF;
      wyi := (not y) and $FFFF;
      for ix := 0 to dstBmp.Width - 1 do begin
        xp1 := x shr 16;
        if xp1 < w then xp2 := xp1 + 1
        else            xp2 := xp1;
        wx  := x and $FFFF;
        w21 := (wyi * wx) shr 16; w11 := wyi - w21;
        w22 := (wy  * wx) shr 16; w12 := wy  - w22;
        if smLine1 <> nil then begin
          w11 := (w11 * (256 - smLine1^[xp1])) shr 8;
          w21 := (w21 * (256 - smLine1^[xp2])) shr 8;
          w12 := (w12 * (256 - smLine2^[xp1])) shr 8;
          w22 := (w22 * (256 - smLine2^[xp2])) shr 8;
          dmLine^ := 255 - byte((w11 + w21 + w12 + w22) shr 8);
        end;
        xp1 := xp1 * 3;
        xp2 := xp2 * 3;
        dbLine^[0] := (sbLine1[xp1    ] * w11 + sbLine1[xp2    ] * w21 + sbLine2[xp1    ] * w12 + sbLine2[xp2    ] * w22) shr 16;
        dbLine^[1] := (sbLine1[xp1 + 1] * w11 + sbLine1[xp2 + 1] * w21 + sbLine2[xp1 + 1] * w12 + sbLine2[xp2 + 1] * w22) shr 16;
        dbLine^[2] := (sbLine1[xp1 + 2] * w11 + sbLine1[xp2 + 2] * w21 + sbLine2[xp1 + 2] * w12 + sbLine2[xp2 + 2] * w22) shr 16;
        inc(integer(dbLine), 3);
        inc(dmLine);
        inc(x, xdif);
      end;
      inc(integer(dbLine), dbLineDif);
      inc(integer(dmLine), dmLineDif);
      inc(y, ydif);
    end;
  end;

  procedure Bilinear32;  // 525 -> 305
  var ix, iy                   : integer;
      x, y, xdif, ydif         : integer;
      xp1, xp2, yp             : integer;
      wy, wyi, wx              : integer;
      w11, w21, w12, w22       : integer;
      sbBits, sbLine1, sbLine2 : PByteArray;
      smBits, smLine1, smLine2 : PByteArray;
      dbLine                   : PByteArray;
      dmLine                   : ^byte;
      sbLineDif, dbLineDif     : integer;
      smLineDif, dmLineDif     : integer;
      w                        : integer;
  begin
    y := 0;
    xdif := (srcBmp.Width  shl 16) div dstBmp.Width;
    ydif := (srcBmp.Height shl 16) div dstBmp.Height;
    sbBits := srcBmp.ScanLine[0];
    if srcBmp.Height > 1 then
         sbLineDif := integer(srcBmp.ScanLine[1]) - integer(sbBits)
    else sbLineDif := 0;
    dbLine := dstBmp.ScanLine[0];
    if dstBmp.Height > 1 then
         dbLineDif := integer(dstBmp.ScanLine[1]) - integer(dbLine) - 4 * dstBmp.Width
    else dbLineDif := 0;
    if srcMsk <> nil then begin
      smBits := srcMsk.ScanLine[0];
      if srcMsk.Height > 1 then
           smLineDif := integer(srcMsk.ScanLine[1]) - integer(smBits)
      else smLineDif := 0;
      dmLine := dstMsk.ScanLine[0];
      if dstMsk.Height > 1 then
           dmLineDif := integer(dstMsk.ScanLine[1]) - integer(dmLine) - 1 * dstBmp.Width
      else dmLineDif := 0;
    end else begin
      smBits    := nil;
      smLineDif := 0;
      dmLine    := nil;
      dmLineDif := 0;
    end;
    w := srcBmp.Width - 1;
    for iy := 0 to dstBmp.Height - 1 do begin
      yp := y shr 16;
      integer(sbLine1) := integer(sbBits) + sbLineDif * yp;
      integer(smLine1) := integer(smBits) + smLineDif * yp;
      if yp < srcBmp.Height - 1 then begin
        integer(sbLine2) := integer(sbLine1) + sbLineDif;
        integer(smLine2) := integer(smLine1) + smLineDif;
      end else begin
        sbLine2 := sbLine1;
        smLine2 := smLine1;
      end;
      x   := 0;
      wy  :=      y  and $FFFF;
      wyi := (not y) and $FFFF;
      for ix := 0 to dstBmp.Width - 1 do begin
        xp1 := x shr 16;
        if xp1 < w then xp2 := xp1 + 1
        else            xp2 := xp1;
        wx  := x and $FFFF;
        w21 := (wyi * wx) shr 16; w11 := wyi - w21;
        w22 := (wy  * wx) shr 16; w12 := wy  - w22;
        if smLine1 <> nil then begin
          w11 := (w11 * (256 - smLine1^[xp1])) shr 8;
          w21 := (w21 * (256 - smLine1^[xp2])) shr 8;
          w12 := (w12 * (256 - smLine2^[xp1])) shr 8;
          w22 := (w22 * (256 - smLine2^[xp2])) shr 8;
          dmLine^ := 255 - byte((w11 + w21 + w12 + w22) shr 8);
        end;
        xp1 := xp1 * 4;
        xp2 := xp2 * 4;
        dbLine^[0] := (sbLine1[xp1    ] * w11 + sbLine1[xp2    ] * w21 + sbLine2[xp1    ] * w12 + sbLine2[xp2    ] * w22) shr 16;
        dbLine^[1] := (sbLine1[xp1 + 1] * w11 + sbLine1[xp2 + 1] * w21 + sbLine2[xp1 + 1] * w12 + sbLine2[xp2 + 1] * w22) shr 16;
        dbLine^[2] := (sbLine1[xp1 + 2] * w11 + sbLine1[xp2 + 2] * w21 + sbLine2[xp1 + 2] * w12 + sbLine2[xp2 + 2] * w22) shr 16;
        inc(integer(dbLine), 4);
        inc(dmLine);
        inc(x, xdif);
      end;
      inc(integer(dbLine), dbLineDif);
      inc(integer(dmLine), dmLineDif);
      inc(y, ydif);
    end;
  end;

begin
  if (srcMsk <> nil) and
     ((dstMsk = nil) or
      (srcMsk.PixelFormat <> pf8Bit) or (srcMsk.Width <> srcBmp.Width) or (srcMsk.Height <> srcBmp.Height) ) then
    srcMsk := nil;
  if srcMsk <> nil then begin
    dstMsk.PixelFormat := pf8bit;
    dstMsk.Width       := dstBmp.Width;
    dstMsk.Height      := dstBmp.Height;
  end else
    dstMsk := nil;
  case quality of
    sqLow      : dstBmp.Canvas.StretchDraw(Rect(0, 0, dstBmp.Width, dstBmp.Height), srcBmp);
    sqHigh     : case GetPixelFormat(dstBmp) of
                   15 : if ForcePixelFormat([srcBmp], pf15bit) then Bilinear15;
                   16 : if ForcePixelFormat([srcBmp], pf16bit) then Bilinear16;
                   24 : if ForcePixelFormat([srcBmp], pf24bit) then Bilinear24;
                   32 : if ForcePixelFormat([srcBmp], pf32bit) then Bilinear32;
                 end;
    sqVeryHigh : case GetPixelFormat(dstBmp) of
                   15 : if ForcePixelFormat([srcBmp], pf15bit) then MitchellResampling15;
                   16 : if ForcePixelFormat([srcBmp], pf16bit) then MitchellResampling16;
                   24 : if ForcePixelFormat([srcBmp], pf24bit) then MitchellResampling24;
                   32 : if ForcePixelFormat([srcBmp], pf32bit) then MitchellResampling32;
                 end;
  end;
end;

procedure StretchBitmap(bmp, msk  : TBitmap;
                        newWidth  : integer;
                        newHeight : integer;
                        quality   : TStretchQuality = sqHigh);
var newBmp, newMsk : TBitmap;
begin
  newBmp := TBitmap.Create;
  try
    if GetPixelFormat(bmp) = 15 then
         newBmp.PixelFormat := pf15Bit
    else newBmp.PixelFormat := bmp.PixelFormat;
    newBmp.Width  := newWidth;
    newBmp.Height := newHeight;
    newMsk := nil;
    try
      if (msk <> nil) and ((msk.PixelFormat <> pf8Bit) or (msk.Width <> bmp.Width) or (msk.Height <> bmp.Height)) then
        msk := nil;
      if msk <> nil then newMsk := TBitmap.Create;
      StretchBitmap(bmp, newBmp, msk, newMsk, quality);
      bmp.Assign(newBmp);
      if msk <> nil then msk.Assign(newMsk);
    finally newMsk.Free end;
  finally newBmp.Free end;
end;

// ***************************************************************

procedure AlphaBlend_(src1, src2, msk, dst : TBitmap;
                      alpha                : cardinal = 128;
                      x                    : integer  = 0;
                      y                    : integer  = 0  );
var w, h, s1x, s1y, s1ld, s2x, s2y, s2ld, dx, dy, dld, mld : integer;

  procedure AlphaBlend15(src1, src2, dst: TBitmap; alpha: cardinal);  // 395
  var src1Line, src2Line, dstLine : ^cardinal;
      mskLine                     : ^byte;
      ix, iy, iw                  : integer;
      i1, i2                      : cardinal;
  begin
    src1Line := src1.ScanLine[s1y];
    src2Line := src2.ScanLine[s2y];
     dstLine := dst .ScanLine[ dy];
    if msk <> nil then begin
      mskLine := msk.ScanLine[s1y];
      if h > 1 then begin
        s1ld := integer(src1.ScanLine[s1y + 1]) - integer(src1Line) - w * 2;
        s2ld := integer(src2.ScanLine[s2y + 1]) - integer(src2Line) - w * 2;
        dld  := integer(dst .ScanLine[ dy + 1]) - integer( dstLine) - w * 2;
        mld  := integer(msk .ScanLine[s1y + 1]) - integer( mskLine) - w;
      end else begin
        s1ld := 0;
        s2ld := 0;
        dld  := 0;
        mld  := 0;
      end;
      inc(integer(src1Line), s1x * 2);
      inc(integer(src2Line), s2x * 2);
      inc(integer( dstLine),  dx * 2);
      inc(integer( mskLine), s1x    );
      for iy := 0 to h - 1 do begin
        for ix := 0 to w - 1 do begin
          if mskLine^ < 255 then begin
            i1 := 256 - (((cardinal(256) - mskLine^) * alpha) shr 8);
            i2 :=      ((alpha * (PWord(src1Line)^ and $001F) + i1 * (PWord(src2Line)^ and $001F)) shr 8) and $001F;
            i2 := i2 + ((alpha * (PWord(src1Line)^ and $03E0) + i1 * (PWord(src2Line)^ and $03E0)) shr 8) and $03E0;
            i2 := i2 + ((alpha * (PWord(src1Line)^ and $7C00) + i1 * (PWord(src2Line)^ and $7C00)) shr 8) and $7C00;
            PWord(dstLine)^ := i2;
          end;
          inc(integer(src1Line), 2);
          inc(integer(src2Line), 2);
          inc(integer( dstLine), 2);
          inc(mskLine);
        end;
        inc(integer(src1Line), s1ld);
        inc(integer(src2Line), s2ld);
        inc(integer( dstLine),  dld);
        inc(integer( mskLine),  mld);
      end;
    end else begin
      iw := w div 2;
      if h > 1 then begin
        s1ld := integer(src1.ScanLine[s1y + 1]) - integer(src1Line) - iw * 4;
        s2ld := integer(src2.ScanLine[s2y + 1]) - integer(src2Line) - iw * 4;
        dld  := integer(dst .ScanLine[ dy + 1]) - integer( dstLine) - iw * 4;
      end else begin
        s1ld := 0;
        s2ld := 0;
        dld  := 0;
      end;
      inc(integer(src1Line), s1x * 2);
      inc(integer(src2Line), s2x * 2);
      inc(integer( dstLine),  dx * 2);
      for iy := 0 to h - 1 do begin
        for ix := 0 to iw - 1 do begin
          i1 := (src2Line^ and $001F001F);
          i2 :=      (((((src1Line^ and $001F001F)       - i1) * alpha) shr 8 + i1)      ) and $001F001F;
          i1 := (src2Line^ and $03E003E0) shr 4;
          i2 := i2 + (((((src1Line^ and $03E003E0) shr 4 - i1) * alpha) shr 8 + i1) shl 4) and $03E003E0;
          i1 := (src2Line^ and $7C007C00) shr 8;
          i2 := i2 + (((((src1Line^ and $7C007C00) shr 8 - i1) * alpha) shr 8 + i1) shl 8) and $7C007C00;
          dstLine^ := i2;
          inc(src1Line);
          inc(src2Line);
          inc( dstLine);
        end;
        inc(integer(src1Line), s1ld);
        inc(integer(src2Line), s2ld);
        inc(integer( dstLine),  dld);
      end;
      if odd(w) then begin
        integer(src1Line) := integer(src1.ScanLine[s1y]) + iw * 4 + s1x * 2;
        integer(src2Line) := integer(src2.ScanLine[s2y]) + iw * 4 + s2x * 2;
        integer( dstLine) := integer(dst .ScanLine[ dy]) + iw * 4 +  dx * 2;
        inc(s1ld, iw * 4);
        inc(s2ld, iw * 4);
        inc( dld, iw * 4);
        for iy := 0 to h - 1 do begin
          i1 := PWord(src2Line)^ and $001F;
          i2 :=      ((((PWord(src1Line)^ and $001F) - i1) * alpha) shr 8 + i1) and $001F;
          i1 := PWord(src2Line)^ and $03E0;
          i2 := i2 + ((((PWord(src1Line)^ and $03E0) - i1) * alpha) shr 8 + i1) and $03E0;
          i1 := PWord(src2Line)^ and $7C00;
          i2 := i2 + ((((PWord(src1Line)^ and $7C00) - i1) * alpha) shr 8 + i1) and $7C00;
          PWord(dstLine)^ := i2;
          inc(integer(src1Line), s1ld);
          inc(integer(src2Line), s2ld);
          inc(integer( dstLine),  dld);
        end;
      end;
    end;
  end;

  procedure AlphaBlend16(src1, src2, dst: TBitmap; alpha: cardinal);  // 395
  var src1Line, src2Line, dstLine : ^cardinal;
      mskLine                     : ^byte;
      ix, iy, iw                  : integer;
      i1, i2                      : cardinal;
  begin
    src1Line := src1.ScanLine[s1y];
    src2Line := src2.ScanLine[s2y];
     dstLine := dst .ScanLine[ dy];
    if msk <> nil then begin
      mskLine := msk.ScanLine[s1y];
      if h > 1 then begin
        s1ld := integer(src1.ScanLine[s1y + 1]) - integer(src1Line) - w * 2;
        s2ld := integer(src2.ScanLine[s2y + 1]) - integer(src2Line) - w * 2;
        dld  := integer(dst .ScanLine[ dy + 1]) - integer( dstLine) - w * 2;
        mld  := integer(msk .ScanLine[s1y + 1]) - integer( mskLine) - w;
      end else begin
        s1ld := 0;
        s2ld := 0;
        dld  := 0;
        mld  := 0;
      end;
      inc(integer(src1Line), s1x * 2);
      inc(integer(src2Line), s2x * 2);
      inc(integer( dstLine),  dx * 2);
      inc(integer( mskLine), s1x    );
      for iy := 0 to h - 1 do begin
        for ix := 0 to w - 1 do begin
          if mskLine^ < 255 then begin
            i1 := 256 - (((cardinal(256) - mskLine^) * alpha) shr 8);
            i2 :=      ((alpha * (PWord(src1Line)^ and $001F) + i1 * (PWord(src2Line)^ and $001F)) shr 8) and $001F;
            i2 := i2 + ((alpha * (PWord(src1Line)^ and $07E0) + i1 * (PWord(src2Line)^ and $07E0)) shr 8) and $07E0;
            i2 := i2 + ((alpha * (PWord(src1Line)^ and $F800) + i1 * (PWord(src2Line)^ and $F800)) shr 8) and $F800;
            PWord(dstLine)^ := i2;
          end;
          inc(integer(src1Line), 2);
          inc(integer(src2Line), 2);
          inc(integer( dstLine), 2);
          inc(mskLine);
        end;
        inc(integer(src1Line), s1ld);
        inc(integer(src2Line), s2ld);
        inc(integer( dstLine),  dld);
        inc(integer( mskLine),  mld);
      end;
    end else begin
      iw := w div 2;
      if h > 1 then begin
        s1ld := integer(src1.ScanLine[s1y + 1]) - integer(src1Line) - iw * 4;
        s2ld := integer(src2.ScanLine[s2y + 1]) - integer(src2Line) - iw * 4;
        dld  := integer(dst .ScanLine[ dy + 1]) - integer( dstLine) - iw * 4;
      end else begin
        s1ld := 0;
        s2ld := 0;
        dld  := 0;
      end;
      inc(integer(src1Line), s1x * 2);
      inc(integer(src2Line), s2x * 2);
      inc(integer( dstLine),  dx * 2);
      for iy := 0 to h - 1 do begin
        for ix := 0 to iw - 1 do begin
          i1 := (src2Line^ and $001F001F);
          i2 :=      (((((src1Line^ and $001F001F)       - i1) * alpha) shr 8 + i1)      ) and $001F001F;
          i1 := (src2Line^ and $07E007E0) shr 4;
          i2 := i2 + (((((src1Line^ and $07E007E0) shr 4 - i1) * alpha) shr 8 + i1) shl 4) and $07E007E0;
          i1 := (src2Line^ and $F800F800) shr 8;
          i2 := i2 + (((((src1Line^ and $F800F800) shr 8 - i1) * alpha) shr 8 + i1) shl 8) and $F800F800;
          dstLine^ := i2;
          inc(src1Line);
          inc(src2Line);
          inc( dstLine);
        end;
        inc(integer(src1Line), s1ld);
        inc(integer(src2Line), s2ld);
        inc(integer( dstLine),  dld);
      end;
      if odd(w) then begin
        integer(src1Line) := integer(src1.ScanLine[s1y]) + iw * 4 + s1x * 2;
        integer(src2Line) := integer(src2.ScanLine[s2y]) + iw * 4 + s2x * 2;
        integer( dstLine) := integer(dst .ScanLine[ dy]) + iw * 4 +  dx * 2;
        inc(s1ld, iw * 4);
        inc(s2ld, iw * 4);
        inc( dld, iw * 4);
        for iy := 0 to h - 1 do begin
          i1 := PWord(src2Line)^ and $001F;
          i2 :=      ((((PWord(src1Line)^ and $001F) - i1) * alpha) shr 8 + i1) and $001F;
          i1 := PWord(src2Line)^ and $07E0;
          i2 := i2 + ((((PWord(src1Line)^ and $07E0) - i1) * alpha) shr 8 + i1) and $07E0;
          i1 := PWord(src2Line)^ and $F800;
          i2 := i2 + ((((PWord(src1Line)^ and $F800) - i1) * alpha) shr 8 + i1) and $F800;
          PWord(dstLine)^ := i2;
          inc(integer(src1Line), s1ld);
          inc(integer(src2Line), s2ld);
          inc(integer( dstLine),  dld);
        end;
      end;
    end;
  end;

  procedure AlphaBlend24(src1, src2, dst: TBitmap; alpha: cardinal);  // 770
  var src1Line, src2Line, dstLine : PByte;
      mskLine                     : ^byte;
      ix, iy, iw                  : integer;
      i1                          : cardinal;
  begin
    src1Line := src1.ScanLine[s1y];
    src2Line := src2.ScanLine[s2y];
     dstLine := dst .ScanLine[ dy];
    iw       := w - 1;
    if h > 1 then begin
      s1ld := integer(src1.ScanLine[s1y + 1]) - integer(src1Line) - w * 3;
      s2ld := integer(src2.ScanLine[s2y + 1]) - integer(src2Line) - w * 3;
      dld  := integer(dst .ScanLine[ dy + 1]) - integer( dstLine) - w * 3;
    end else begin
      s1ld := 0;
      s2ld := 0;
      dld  := 0;
    end;
    inc(integer(src1Line), s1x * 3);
    inc(integer(src2Line), s2x * 3);
    inc(integer( dstLine),  dx * 3);
    if msk <> nil then begin
      mskLine := msk.ScanLine[s1y];
      if h > 1 then
           mld := integer(msk.ScanLine[s1y + 1]) - integer( mskLine) - w
      else mld := 0;
      inc(integer(mskLine), s1x);
    end else begin
      mskLine := nil;
      mld     := 0;
    end;
    for iy := 0 to h - 1 do begin
      if mskLine <> nil then begin
        for ix := 0 to iw do begin
          if mskLine^ < 255 then begin
            i1 := 256 - (((cardinal(256) - mskLine^) * alpha) shr 8);
            dstLine^ := byte((alpha * src1Line^ + i1 * src2Line^) shr 8);
            inc(src1Line);
            inc(src2Line);
            inc( dstLine);
            dstLine^ := byte((alpha * src1Line^ + i1 * src2Line^) shr 8);
            inc(src1Line);
            inc(src2Line);
            inc( dstLine);
            dstLine^ := byte((alpha * src1Line^ + i1 * src2Line^) shr 8);
            inc(src1Line);
            inc(src2Line);
            inc( dstLine);
          end else begin
            inc(src1Line, 3);
            inc(src2Line, 3);
            inc( dstLine, 3);
          end;
          inc(mskLine);
        end;
      end else
        for ix := 0 to iw do begin
          i1 := src2Line^;
          dstLine^ := byte(((src1Line^ - i1) * alpha) shr 8 + i1);
          inc(src1Line);
          inc(src2Line);
          inc( dstLine);
          i1 := src2Line^;
          dstLine^ := byte(((src1Line^ - i1) * alpha) shr 8 + i1);
          inc(src1Line);
          inc(src2Line);
          inc( dstLine);
          i1 := src2Line^;
          dstLine^ := byte(((src1Line^ - i1) * alpha) shr 8 + i1);
          inc(src1Line);
          inc(src2Line);
          inc( dstLine);
        end;
      inc(integer(src1Line), s1ld);
      inc(integer(src2Line), s2ld);
      inc(integer( dstLine),  dld);
      inc(integer( mskLine),  mld);
    end;
  end;

  procedure AlphaBlend32(src1, src2, dst: TBitmap; alpha: cardinal);  // 630
  var src1Line, src2Line, dstLine : ^cardinal;
      mskLine                     : ^byte;
      ix, iy, iw                  : integer;
      i1, i2                      : cardinal;
  begin
    src1Line := src1.ScanLine[s1y];
    src2Line := src2.ScanLine[s2y];
     dstLine := dst .ScanLine[ dy];
    iw       := w - 1;
    if h > 1 then begin
      s1ld := integer(src1.ScanLine[s1y + 1]) - integer(src1Line) - w * 4;
      s2ld := integer(src2.ScanLine[s2y + 1]) - integer(src2Line) - w * 4;
      dld  := integer(dst .ScanLine[ dy + 1]) - integer( dstLine) - w * 4;
    end else begin
      s1ld := 0;
      s2ld := 0;
      dld  := 0;
    end;
    inc(integer(src1Line), s1x * 4);
    inc(integer(src2Line), s2x * 4);
    inc(integer( dstLine),  dx * 4);
    if msk <> nil then begin
      mskLine := msk.ScanLine[s1y];
      if h > 1 then
           mld := integer(msk.ScanLine[s1y + 1]) - integer( mskLine) - w
      else mld := 0;
      inc(integer(mskLine), s1x);
    end else begin
      mskLine := nil;
      mld     := 0;
    end;
    for iy := 0 to h - 1 do begin
      if mskLine <> nil then begin
        for ix := 0 to iw do begin
          if mskLine^ < 255 then begin
            i1 := 256 - (((cardinal(256) - mskLine^) * alpha) shr 8);
            i2 :=      ((alpha * (src1Line^ and $00FF00FF) + i1 * (src2Line^ and $00FF00FF)) shr 8) and $00FF00FF;
            i2 := i2 + ((alpha * (src1Line^ and $0000FF00) + i1 * (src2Line^ and $0000FF00)) shr 8) and $0000FF00;
            dstLine^ := i2;
          end;
          inc(src1Line);
          inc(src2Line);
          inc( dstLine);
          inc( mskLine);
        end;
      end else
        for ix := 0 to iw do begin
          i1 := src2Line^ and $00FF00FF;
          i2 :=      ((((src1Line^ and $00FF00FF) - i1) * alpha) shr 8 + i1) and $00FF00FF;
          i1 := src2Line^ and $0000FF00;
          i2 := i2 + ((((src1Line^ and $0000FF00) - i1) * alpha) shr 8 + i1) and $0000FF00;
          dstLine^ := i2;
          inc(src1Line);
          inc(src2Line);
          inc( dstLine);
        end;
      inc(integer(src1Line), s1ld);
      inc(integer(src2Line), s2ld);
      inc(integer( dstLine),  dld);
      inc(integer( mskLine),  mld);
    end;
  end;

begin
  if dst = src2 then begin
    if x < 0 then begin
      w   := Min(src1.Width + x, dst.Width);
      s1x := -x;
      dx  := 0;
    end else  begin
      w   := Min(src1.Width, dst.Width - x);
      s1x := 0;
      dx  := x;
    end;
    if y < 0 then begin
      h   := Min(src1.Height + y, dst.Height);
      s1y := -y;
      dy  := 0;
    end else  begin
      h   := Min(src1.Height, dst.Height - y);
      s1y := 0;
      dy  := y;
    end;
    s2x := dx;
    s2y := dy;
    if (msk <> nil) and ((msk.PixelFormat <> pf8Bit) or (msk.Width <> src1.Width) or (msk.Height <> src1.Height)) then
      msk := nil;  
  end else begin
    w := Min(src1.Width,  Min(src2.Width,  dst.Width ));
    h := Min(src1.Height, Min(src2.Height, dst.Height));
    s1x := 0; s2x := 0; dx := 0;
    s1y := 0; s2y := 0; dy := 0;
  end;
  case GetPixelFormat(dst) of
    15 : if ForcePixelFormat([src1, src2], pf15bit) then AlphaBlend15(src1, src2, dst, alpha);
    16 : if ForcePixelFormat([src1, src2], pf16bit) then AlphaBlend16(src1, src2, dst, alpha);
    24 : if ForcePixelFormat([src1, src2], pf24bit) then AlphaBlend24(src1, src2, dst, alpha);
    32 : if ForcePixelFormat([src1, src2], pf32bit) then AlphaBlend32(src1, src2, dst, alpha);
  end;
end;

procedure AlphaBlend(src1, src2, dst : TBitmap;
                     alpha           : cardinal = 128);
begin
  AlphaBlend_(src1, src2, nil, dst, alpha);
end;

procedure AlphaBlend(src, dst : TBitmap;
                     alpha    : cardinal = 128;
                     msk      : TBitmap  = nil;
                     x        : integer  = 0;
                     y        : integer  = 0  );
begin
  AlphaBlend_(src, dst, msk, dst, alpha, x, y);
end;

// ***************************************************************

procedure Draw(imageList, index : cardinal;
               dst              : TBitmap;
               x                : integer         = 0;
               y                : integer         = 0;
               width            : integer         = 0;
               height           : integer         = 0;
               grayPercent      : TGrayPercent    = gp0;
               alpha            : cardinal        = 256;
               stretchQuality   : TStretchQuality = sqHigh);
var bmp, msk : TBitmap;
    ii       : TImageInfo;
begin
  if ImageList_GetImageInfo(imageList, index, ii) then begin
    bmp := TBitmap.Create;
    try
      case GetPixelFormat(dst) of
        15 : bmp.PixelFormat := pf15bit;
        16 : bmp.PixelFormat := pf16bit;
        24 : bmp.PixelFormat := pf24bit;
        else bmp.PixelFormat := pf32bit;
      end;
      bmp.Width  := ii.rcImage.Right  - ii.rcImage.Left;
      bmp.Height := ii.rcImage.Bottom - ii.rcImage.Top;
      ImageList_Draw(imageList, index, bmp.Canvas.Handle, 0, 0, ILD_NORMAL);
      msk := nil;
      try
        if ii.hbmMask <> 0 then begin
          msk := TBitmap.Create;
          msk.PixelFormat := pf8bit;
          msk.Width       := ii.rcImage.Right  - ii.rcImage.Left;
          msk.Height      := ii.rcImage.Bottom - ii.rcImage.Top;
          ImageList_Draw(imageList, index, msk.Canvas.Handle, 0, 0, ILD_MASK);
        end;
        if ((width <> 0) and (width <> bmp.Width)) or ((height <> 0) and (height <> bmp.Height)) then begin
          if width  = 0 then width  := bmp.Width;
          if height = 0 then height := bmp.Height;
          StretchBitmap(bmp, msk, width, height, stretchQuality);
        end;
        GrayScale(bmp, grayPercent);
        AlphaBlend(bmp, dst, alpha, msk, x, y);
      finally msk.Free end;
    finally bmp.Free end;
  end;
end;

procedure Draw(bmp, msk       : TBitmap;
               dst            : TBitmap;
               x              : integer         = 0;
               y              : integer         = 0;
               width          : integer         = 0;
               height         : integer         = 0;
               grayPercent    : TGrayPercent    = gp0;
               alpha          : cardinal        = 256;
               stretchQuality : TStretchQuality = sqHigh);
begin
  if width  = 0 then width  := bmp.Width;
  if height = 0 then height := bmp.Height;
  if (width <> bmp.Width) or (height <> bmp.Height) then
    StretchBitmap(bmp, msk, width, height, stretchQuality);
  GrayScale(bmp, grayPercent);
  AlphaBlend(bmp, dst, alpha, msk, x, y);
end;

// ***************************************************************

{var bmp1, bmp2 : TBitmap;
begin
  bmp1 := TBitmap.Create;
  bmp1.LoadFromFile('c:\windows\desktop\cddrive.bmp');
  bmp2 := TBitmap.Create;
  bmp2.PixelFormat := pf24bit;
  bmp2.Canvas.Brush.Color := clBtnFace;
  bmp2.Width  := 16;
  bmp2.Height := 16;
  Draw(bmp1, nil, bmp2, 0, 0, 0, 0, gp100, 128);
  bmp2.SaveToFile('c:\windows\desktop\cddrive2.bmp');
  ExitProcess(0); }
end.
