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

{ $define newantiringing}
{ $define oldantiringing}

interface

uses Windows, Graphics, madTypes;

// ***************************************************************

type TGrayPercent = (gp100, gp75, gp50, gp0);
procedure GrayScale (bmp: TBitmap; percent: TGrayPercent = gp100);

// ***************************************************************

type
  TStretchQuality = (sqLow, sqHigh, sqVeryHigh);

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

type
  TContributorPixel = record
    pixel  : integer;  // source pixel
    weight : integer;  // weight of this source pixel
  end;

  // list of source pixels contributing to the destination pixel
  TContributorPixels = record
    itemCount : integer;
    items     : array of TContributorPixel;
  end;

  // list for the full width/height of a bitmap
  TContributorList  = array of TContributorPixels;

  // which resampling filter shall be used?
  TResamplingFilter = (
    // 1 tap
    rfNearest,       // Nearest Neighbor, aka. Point Sampling
                     // - additional ringing = 0
                     // - hide source ringing = 0
                     // - aliasing = 10
                     // - sharpness = 10

    // 2 tap
    rfBilinear,      // Bilinear
                     // - additional ringing = 0
                     // - hide source ringing = 3
                     // - aliasing = 5
                     // - sharpness = 5

    rfBicubic50, rfBicubic60, rfBicubic75,
                     // Bicubic, aka. Catmull-Rom (rfBicubic50)
                     // - additional ringing = 1, 2, 3.5
                     // - hide source ringing = 0
                     // - aliasing = 4.5, 3.5, 3
                     // - sharpness = 7.25, 7.50, 7.75

    rfMitchell,      // Mitchell-Netravali
                     // - additional ringing = 1
                     // - hide source ringing = 1
                     // - aliasing = 4
                     // - sharpness = 5

    rfSoftCubic100, rfSoftCubic80, rfSoftCubic70, rfSoftCubic60, rfSoftCubic50,
                     // Cubic B-Spline
                     // - additional ringing = 0, 0, 0.25, 0.5, 0.75
                     // - hide source ringing = 9, 7, 6, 3, 1
                     // - aliasing = 0, 0.25, 1, 2, 2.5 
                     // - sharpness = 0.5, 2, 3, 3.5, 4

    // 3-4 tap
    rfLanczos3, rfLanczos4,
                     // Lanczos
                     // - additional ringing = 6, 8
                     // - hide source ringing = 0
                     // - aliasing = 2, 1
                     // - sharpness = 8.5, 9
    rfSpline36, rfSpline64
                     // Spline
                     // - additional ringing = 4.5, 5
                     // - hide source ringing = 0
                     // - aliasing = 2.5, 2.3
                     // - sharpness = 8, 8.1

    // spline16  -> bicubic50
    // blackman3 -> bicubic60
    // blackman4 -> spline36
    // gaussian  -> softCubic
  );

  // full list structure including src and dst information
  TScaleList = record
    filter          : TResamplingFilter;
    src, dst        : integer;
    contributorList : TContributorList;
  end;

const
  CResamplingFilterNames : array [TResamplingFilter] of string =
    ('Nearest',
     'Bilinear',
     'Bicubic50', 'Bicubic60', 'Bicubic75',
     'Mitchell',
     'SoftCubic100', 'SoftCubic80', 'SoftCubic70', 'SoftCubic60', 'SoftCubic50', 
     'Lanczos3', 'Lanczos4',
     'Spline36', 'Spline64');

var
  ScaleListCache   : array of TScaleList;
  ScaleListSection : TRTLCriticalSection;

procedure StretchBitmap_(srcBmp, dstBmp : TBitmap;
                         srcMsk, dstMsk : TBitmap;
                         quality        : TStretchQuality = sqHigh;
                         filter         : TResamplingFilter = rfLanczos4); overload;

  procedure GetContributorList(var result: TContributorList; src_, dst_: integer; filter: TResamplingFilter);

    function Cubic(weight, param1, param2: double) : double;
    var P0, P1, P2, P3 : double;
    begin
      result := 0;
      if weight <= 2 then begin
        if weight < 1 then begin
          P0 := (+ 1 - 1/3 * param1 - 0 * param2);
          P1 := 0;
          P2 := (- 3 + 2   * param1 + 1 * param2);
          P3 := (+ 2 - 3/2 * param1 - 1 * param2);
        end else begin
          P0 := (- 0 + 4/3 * param1 + 4 * param2);
          P1 := (+ 0 - 2   * param1 - 8 * param2);
          P2 := (- 0 + 1   * param1 + 5 * param2);
          P3 := (+ 0 - 1/6 * param1 - 1 * param2);
        end;
        result := P0 + P1 * weight + P2 * weight * weight + P3 * weight * weight * weight;
      end;
    end;

    function GetFilterCoeffs(weight: double; filter: TResamplingFilter) : double;
    begin
      result := 0;
      case filter of
        rfNearest        : if weight < 1 then
                             result := 1 - weight;
        rfBilinear       : if weight < 1 then
                             result := 1 - weight;
        rfBicubic50      : result := Cubic(weight, 0.00, 0.50);
        rfBicubic60      : result := Cubic(weight, 0.00, 0.60);
        rfBicubic75      : result := Cubic(weight, 0.00, 0.75);
        rfSoftCubic100   : result := Cubic(weight, 1.00, 0.00);
        rfSoftCubic80    : result := Cubic(weight, 0.80, 0.20);
        rfSoftCubic70    : result := Cubic(weight, 0.70, 0.30);
        rfSoftCubic60    : result := Cubic(weight, 0.60, 0.40);
        rfSoftCubic50    : result := Cubic(weight, 0.50, 0.50);
        rfMitchell       : result := Cubic(weight, 1/3, 1/3);
        rfLanczos3       : if weight = 0 then
                             result := 1
                           else
                             if weight < 3 then begin
                               weight := weight * Pi;
                               result := (sin(weight) / weight) * (sin(weight / 3) / (weight / 3));
                             end;
        rfLanczos4       : if weight = 0 then
                             result := 1
                           else
                             if weight < 4 then begin
                               weight := weight * Pi;
                               result := (sin(weight) / weight) * (sin(weight / 4) / (weight / 4));
                             end;
        rfSpline36       : if weight < 3 then
                             if weight < 1 then
                               result := ((13 / 11 * weight - 453 / 209) * weight - 3 / 209) * weight + 1
                             else
                               if weight < 2 then
                                 result := ((-6 / 11  * (weight - 1) + 270 / 209) * (weight - 1) - 156 / 209) * (weight - 1)
                               else
                                 result := ((1 / 11  * (weight - 2) - 45 / 209) * (weight - 2) + 26 / 209) * (weight - 2);
        rfSpline64       : if weight < 4 then
                             if weight < 1 then
                               result := ((49 / 41 * weight - 6387 / 2911) * weight - 3 / 2911) * weight + 1
                             else
                               if weight < 2 then
                                 result := ((-24 / 41 * (weight - 1) + 4032 / 2911) * (weight - 1) - 2328 / 2911) * (weight - 1)
                               else
                                 if weight < 3 then
                                   result := ((6 / 41 * (weight - 2) - 1008 / 2911) * (weight - 2) + 582 / 2911) * (weight - 2)
                                 else
                                   result := ((-1 / 41 * (weight - 3) +  168 / 2911) * (weight - 3) - 97 / 2911) * (weight - 3);
//        rfGaussian25     : if weight < 4 then
//                             result := Power(2, - 2.5 * weight * weight);
      end;
    end;

    type TDADouble = array of double;

    procedure OptimizeItems(var result: TContributorList; index: integer; const floatWeights: TDADouble);
    var totalI  : integer;
        totalF  : double;
        highest : integer;
        i1, i2  : integer;
    begin
      with result[index] do begin
        totalF := 0;
        for i2 := 0 to itemCount - 1 do
          totalF := totalF + floatWeights[i2];
        totalI := 0;
        highest := -1;
        i1 := 0;
        for i2 := 0 to itemCount - 1 do begin
          items[i1].weight := round(floatWeights[i2] / totalF * $10000);
          if abs(items[i1].weight) > 1 then begin
            items[i1].pixel := items[i2].pixel;
            inc(totalI, items[i1].weight);
            if (highest = -1) or (items[i1].weight > items[highest].weight) then
              highest := i1;
            inc(i1);
          end;
        end;
        itemCount := i1;
        if totalI <> $10000 then
          dec(items[highest].weight, totalI - $10000);
      end;
    end;

    procedure AddItem(var result: TContributorList; index: integer; pixel, maxPixel: integer; var floatWeights, offsets: TDADouble; offset: double; filter: TResamplingFilter);
    var i1, i2 : integer;
        weight : double;
    begin
      with result[index] do begin
        weight := GetFilterCoeffs(offset, filter);
        if weight <> 0 then begin
          if pixel < 0 then
            pixel := 0
          else
            if pixel >= maxPixel then
              pixel := maxPixel - 1;
          floatWeights[itemCount] := weight;
          offsets[itemCount] := offset;
          items[itemCount].pixel := pixel;
          for i1 := 0 to itemCount - 1 do
            if abs(offsets[i1]) > abs(offset) then begin
              for i2 := itemCount downto i1 + 1 do begin
                floatWeights[i2] := floatWeights[i2 - 1];
                offsets[i2] := offsets[i2 - 1];
                items[i2].pixel := items[i2 - 1].pixel;
              end;
              floatWeights[i1] := weight;
              offsets[i1] := offset;
              items[i1].pixel := pixel;
              break;
            end;
          inc(itemCount);
        end;
      end;
    end;

  var scale        : double;
      capacity     : integer;
      i1, i2       : integer;
      floatWeights : TDADouble;
      offsets      : TDADouble;
  begin
    if ScaleListCache = nil then
      InitializeCriticalSection(ScaleListSection);
    EnterCriticalSection(ScaleListSection);
    try
      for i1 := 0 to high(ScaleListCache) do
        if (ScaleListCache[i1].filter = filter) and (ScaleListCache[i1].src = src_) and (ScaleListCache[i1].dst = dst_) then begin
          result := ScaleListCache[i1].contributorList;
          exit;
        end;
      if dst_ < src_ then begin
        SetLength(result, dst_);
        capacity := 8 * src_ div dst_ + 1;
        SetLength(floatWeights, capacity);
        SetLength(offsets, capacity);
        scale := dst_ / src_;
        for i1 := 0 to dst_ - 1 do
          with result[i1] do begin
            SetLength(items, capacity);
            itemCount := 0;
            for i2 := ((i1 - 4) * src_ - dst_ + 1) div dst_ to ((i1 + 4) * src_ + dst_ - 1) div dst_ do
              AddItem(result, i1, i2, src_, floatWeights, offsets, abs(i1 + 0.5 - (i2 + 0.5) * scale), filter);
            if filter = rfNearest then
              itemCount := 1;
            OptimizeItems(result, i1, floatWeights);
          end;
      end else begin
        SetLength(result, dst_);
        SetLength(floatWeights, 9);
        SetLength(offsets, 9);
        scale := src_ / dst_;
        for i1 := 0 to dst_ - 1 do
          with result[i1] do begin
            SetLength(items, 17);
            itemCount := 0;
            for i2 := (i1 * src_ - 5 * dst_ + 1) div dst_ to (i1 * src_ + 5 * dst_ - 1) div dst_ do
              AddItem(result, i1, i2, src_, floatWeights, offsets, abs((i1 + 0.5) * scale - (i2 + 0.5)), filter);
            if filter = rfNearest then
              itemCount := 1;
            OptimizeItems(result, i1, floatWeights);
          end;
      end;
      i1 := Length(ScaleListCache);
      SetLength(ScaleListCache, i1 + 1);
      ScaleListCache[i1].filter := filter;
      ScaleListCache[i1].src := src_;
      ScaleListCache[i1].dst := dst_;
      ScaleListCache[i1].contributorList := result;
    finally LeaveCriticalSection(ScaleListSection) end;
  end;

  procedure Resampling15;  // 370 / 195
  var ix, iy, ic     : integer;
      weight         : integer;
      clx, cly       : TContributorList;
      fr, fg, fb, fm : integer;
      sbBits, dbBits : integer;
      smBits, dmBits : integer;
      sbDif,  dbDif  : integer;
      smDif,  dmDif  : integer;
      sbLine, tbBuf  : PWordArray;
      smLine, tmBuf  : PByteArray;
      dbPix          : ^word;
      dmPix          : ^byte;
      pcp            : ^TContributorPixel;
      dw1            : integer;
  begin
    GetContributorList(clx, srcBmp.Width,  dstBmp.Width,  rfMitchell);
    GetContributorList(cly, srcBmp.Height, dstBmp.Height, rfMitchell);
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
          pcp := @clx[ix].items[0];
          for ic := 0 to clx[ix].itemCount - 1 do begin
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
          pcp := @cly[iy].items[0];
          for ic := 0 to cly[iy].itemCount - 1 do begin
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
          pcp := @clx[ix].items[0];
          for ic := 0 to clx[ix].itemCount - 1 do begin
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
          pcp := @cly[iy].items[0];
          for ic := 0 to cly[iy].itemCount - 1 do begin
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

  procedure Resampling16;  // 370 / 195
  var ix, iy, ic     : integer;
      weight         : integer;
      clx, cly       : TContributorList;
      fr, fg, fb, fm : integer;
      sbBits, dbBits : integer;
      smBits, dmBits : integer;
      sbDif,  dbDif  : integer;
      smDif,  dmDif  : integer;
      sbLine, tbBuf  : PWordArray;
      smLine, tmBuf  : PByteArray;
      dbPix          : ^word;
      dmPix          : ^byte;
      pcp            : ^TContributorPixel;
      dw1            : integer;
  begin
    GetContributorList(clx, srcBmp.Width,  dstBmp.Width,  rfMitchell);
    GetContributorList(cly, srcBmp.Height, dstBmp.Height, rfMitchell);
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
          pcp := @clx[ix].items[0];
          for ic := 0 to clx[ix].itemCount - 1 do begin
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
          pcp := @cly[iy].items[0];
          for ic := 0 to cly[iy].itemCount - 1 do begin
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
          pcp := @clx[ix].items[0];
          for ic := 0 to clx[ix].itemCount - 1 do begin
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
          pcp := @cly[iy].items[0];
          for ic := 0 to cly[iy].itemCount - 1 do begin
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

  procedure Resampling24;  // 385 / 200
  type TRGB = packed record b, g, r: byte; end;
  var ix, iy, ic, id : integer;
      weight         : integer;
      clx, cly       : TContributorList;
      artx, arty     : integer;  // anti ringing threshold x/y
      fr, fg, fb, fm : integer;
      rl, gl, bl     : integer;
      rh, gh, bh     : integer;
      sbBits, dbBits : integer;
      smBits, dmBits : integer;
      sbDif,  dbDif  : integer;
      smDif,  dmDif  : integer;
      sbLine, tbBuf  : PByteArray;
      hBuf, lBuf     : PByteArray;
      smLine, tmBuf  : PByteArray;
      dbPix          : ^byte;
      hPix, lPix     : ^byte;
      dmPix          : ^byte;
      pcp            : ^TContributorPixel;
      rgb            : TRGB;
  begin
    tbBuf := AllocMem(srcBmp.Height * 4 + srcBmp.Height * 1);
    sbBits := integer(srcBmp.ScanLine[0]);
    dbBits := integer(dstBmp.ScanLine[0]);
    if srcBmp.Height > 1 then
         sbDif := integer(srcBmp.ScanLine[1]) - sbBits
    else sbDif := 0;
    if dstBmp.Height > 1 then
         dbDif := integer(dstBmp.ScanLine[1]) - dbBits - 2
    else dbDif := 0;
    if srcMsk <> nil then begin
      GetContributorList(clx, srcBmp.Width,  dstBmp.Width,  rfMitchell);
      GetContributorList(cly, srcBmp.Height, dstBmp.Height, rfMitchell);
      tmBuf := pointer(integer(tbBuf) + srcBmp.Height * 4);
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
          fr := 0;
          fg := 0;
          fb := 0;
          fm := 0;
          pcp := @clx[ix].items[0];
          for ic := 0 to clx[ix].itemCount - 1 do begin
            weight := (pcp^.weight * (256 - smLine^[pcp^.pixel])) div 256;
            inc(fm, weight);
            rgb := TRGB(pointer(@sbLine^[pcp^.pixel * 3])^);
            inc(fr, rgb.r * weight);
            inc(fg, rgb.g * weight);
            inc(fb, rgb.b * weight);
            inc(pcp);
          end;
          if      fb <       0 then dbPix^ := 0
          else if fb > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fb shr 16;
          inc(dbPix);
          if      fg <       0 then dbPix^ := 0
          else if fg > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fg shr 16;
          inc(dbPix);
          if      fr <       0 then dbPix^ := 0
          else if fr > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fr shr 16;
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
          fr := 0;
          fg := 0;
          fb := 0;
          fm := 0;
          pcp := @cly[iy].items[0];
          for ic := 0 to cly[iy].itemCount - 1 do begin
            weight := (pcp^.weight * (256 - tmBuf^[pcp^.pixel])) div 256;
            inc(fm, weight);
            rgb := TRGB(pointer(@tbBuf^[pcp^.pixel * 4])^);
            inc(fr, rgb.r * weight);
            inc(fg, rgb.g * weight);
            inc(fb, rgb.b * weight);
            inc(pcp);
          end;
          if      fb <       0 then dbPix^ := 0
          else if fb > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fb shr 16;
          inc(dbPix);
          if      fg <       0 then dbPix^ := 0
          else if fg > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fg shr 16;
          inc(dbPix);
          if      fr <       0 then dbPix^ := 0
          else if fr > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fr shr 16;
          inc(dbPix, dbDif);
          if      fm <       0 then dmPix^ := 255
          else if fm > $00FF00 then dmPix^ := 0
          else                      dmPix^ := 255 - fm shr 8;
          inc(dmPix, dmDif);
        end;
      end;
    end else begin
      hBuf := AllocMem(srcBmp.Height * 4 + srcBmp.Height * 1);
      lBuf := AllocMem(srcBmp.Height * 4 + srcBmp.Height * 1);
      if srcBmp.Width = dstBmp.Width then
        GetContributorList(clx, srcBmp.Width, dstBmp.Width, rfNearest)
      else
        GetContributorList(clx, srcBmp.Width, dstBmp.Width, filter);
      if srcBmp.Height = dstBmp.Height then
        GetContributorList(cly, srcBmp.Height, dstBmp.Height, rfNearest)
      else
        GetContributorList(cly, srcBmp.Height, dstBmp.Height, filter);
      if srcBmp.Width < dstBmp.Width then
        artx := 2
      else
        artx := Ceil(srcBmp.Width / dstBmp.Width);
      if srcBmp.Height < dstBmp.Height then
        arty := 2
      else
        arty := Ceil(srcBmp.Height / dstBmp.Height);
      for ix := 0 to dstBmp.Width - 1 do begin
        dbPix  := pointer(tbBuf );
        hPix   := pointer(hBuf  );
        lPix   := pointer(lBuf  );
        sbLine := pointer(sbBits);
        for iy := 0 to srcBmp.Height - 1 do begin
          fr := 0;
          fg := 0;
          fb := 0;
          rl := 255;
          gl := 255;
          bl := 255;
          rh := 0;
          gh := 0;
          bh := 0;
          pcp := @clx[ix].items[0];
          for ic := 0 to clx[ix].itemCount - 1 do begin
            weight := pcp^.weight;
            rgb := TRGB(pointer(@sbLine^[pcp^.pixel * 3])^);
            if ic < artx then begin
              if rgb.r > rh then
                rh := rgb.r;
              if rgb.r < rl then
                rl := rgb.r;
              if rgb.g > gh then
                gh := rgb.g;
              if rgb.g < gl then
                gl := rgb.g;
              if rgb.b > bh then
                bh := rgb.b;
              if rgb.b < bl then
                bl := rgb.b;
              inc(fr, rgb.r * weight);
              inc(fg, rgb.g * weight);
              inc(fb, rgb.b * weight);
            end else begin
              {$ifndef newantiringing}
                inc(fr, rgb.r * weight);
                inc(fg, rgb.g * weight);
                inc(fb, rgb.b * weight);
              {$else}
                if rh - rl > 32 then
                  inc(fr, rgb.r * weight)
                else
                  if rgb.r > rh then
                    inc(fr, (rh + (rgb.r - rh) * (rh - rl) div 32) * weight)
                  else
                    if rgb.r < rl then
                      inc(fr, (rl - (rl - rgb.r) * (rh - rl) div 32) * weight)
                    else
                      inc(fr, rgb.r * weight);
                if gh - gl > 32 then
                  inc(fg, rgb.g * weight)
                else
                  if rgb.g > gh then
                    inc(fg, (gh + (rgb.g - gh) * (gh - gl) div 32) * weight)
                  else
                    if rgb.g < gl then
                      inc(fg, (gl - (gl - rgb.g) * (gh - gl) div 32) * weight)
                    else
                      inc(fg, rgb.g * weight);
                if bh - bl > 32 then
                  inc(fb, rgb.b * weight)
                else
                  if rgb.b > bh then
                    inc(fb, (bh + (rgb.b - bh) * (bh - bl) div 32) * weight)
                  else
                    if rgb.b < bl then
                      inc(fb, (bl - (bl - rgb.b) * (bh - bl) div 32) * weight)
                    else
                      inc(fb, rgb.b * weight);
              {$endif}
            end;
            inc(pcp);
          end;
          if      fb <       0 then fb := 0
          else if fb > $FF0000 then fb := 255
          else                      fb := (fb + $8000) shr 16;
          dbPix^ := fb;
          inc(dbPix);
          hPix^ := bh;
          lPix^ := bl;
          inc(hPix);
          inc(lPix);
          if      fg <       0 then fg := 0
          else if fg > $FF0000 then fg := 255
          else                      fg := (fg + $8000) shr 16;
          dbPix^ := fg;
          inc(dbPix);
          hPix^ := gh;
          lPix^ := gl;
          inc(hPix);
          inc(lPix);
          if      fr <       0 then fr := 0
          else if fr > $FF0000 then fr := 255
          else                      fr := (fr + $8000) shr 16;
          dbPix^ := fr;
          inc(dbPix, 2);
          hPix^ := rh;
          lPix^ := rl;
          inc(hPix, 2);
          inc(lPix, 2);
          inc(integer(sbLine), sbDif);
        end;
        dbPix := pointer(dbBits + ix * 3);
        for iy := 0 to dstBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          rl := 255;
          gl := 255;
          bl := 255;
          rh := 0;
          gh := 0;
          bh := 0;
          pcp := @cly[iy].items[0];
          for ic := 0 to cly[iy].itemCount - 1 do begin
            weight := pcp^.weight;
            rgb := TRGB(pointer(@tbBuf^[pcp^.pixel * 4])^);
            if ic < arty then begin
              inc(fr, rgb.r * weight);
              inc(fg, rgb.g * weight);
              inc(fb, rgb.b * weight);
              rgb := TRGB(pointer(@hBuf^[pcp^.pixel * 4])^);
              if rgb.r > rh then
                rh := rgb.r;
              if rgb.g > gh then
                gh := rgb.g;
              if rgb.b > bh then
                bh := rgb.b;
              rgb := TRGB(pointer(@lBuf^[pcp^.pixel * 4])^);
              if rgb.r < rl then
                rl := rgb.r;
              if rgb.g < gl then
                gl := rgb.g;
              if rgb.b < bl then
                bl := rgb.b;
            end else begin
              {$ifndef newantiringing}
                inc(fr, rgb.r * weight);
                inc(fg, rgb.g * weight);
                inc(fb, rgb.b * weight);
              {$else}
                if rh - rl > 32 then
                  inc(fr, rgb.r * weight)
                else
                  if rgb.r > rh then
                    inc(fr, (rh + (rgb.r - rh) * (rh - rl) div 32) * weight)
                  else
                    if rgb.r < rl then
                      inc(fr, (rl - (rl - rgb.r) * (rh - rl) div 32) * weight)
                    else
                      inc(fr, rgb.r * weight);
                if gh - gl > 32 then
                  inc(fg, rgb.g * weight)
                else
                  if rgb.g > gh then
                    inc(fg, (gh + (rgb.g - gh) * (gh - gl) div 32) * weight)
                  else
                    if rgb.g < gl then
                      inc(fg, (gl - (gl - rgb.g) * (gh - gl) div 32) * weight)
                    else
                      inc(fg, rgb.g * weight);
                if bh - bl > 32 then
                  inc(fb, rgb.b * weight)
                else
                  if rgb.b > bh then
                    inc(fb, (bh + (rgb.b - bh) * (bh - bl) div 32) * weight)
                  else
                    if rgb.b < bl then
                      inc(fb, (bl - (bl - rgb.b) * (bh - bl) div 32) * weight)
                    else
                      inc(fb, rgb.b * weight);
              {$endif}
            end;
            inc(pcp);
          end;
          if      fb <       0 then fb := 0
          else if fb > $FF0000 then fb := 255
          else                      fb := (fb + $8000) shr 16;
          {$ifdef oldantiringing}
            if fb > bh then
              fb := bh
            else
              if fb < bl then
                fb := bl;
          {$endif}
          dbPix^ := fb;
          inc(dbPix);
          if      fg <       0 then fg := 0
          else if fg > $FF0000 then fg := 255
          else                      fg := (fg + $8000) shr 16;
          {$ifdef oldantiringing}
            if fg > gh then
              fg := gh
            else
              if fg < gl then
                fg := gl;
          {$endif}
          dbPix^ := fg;
          inc(dbPix);
          if      fr <       0 then fr := 0
          else if fr > $FF0000 then fr := 255
          else                      fr := (fr + $8000) shr 16;
          {$ifdef oldantiringing}
            if fr > rh then
              fr := rh
            else
              if fr < rl then
                fr := rl;
          {$endif}
          dbPix^ := fr;
          inc(dbPix, dbDif);
        end;
      end;
      FreeMem(lBuf);
      FreeMem(hBuf);
    end;
    FreeMem(tbBuf);
  end;

  procedure Resampling32;  // 375 / 200
  type TRGB = packed record b, g, r, a: byte; end;
  var ix, iy, ic, id : integer;
      weight         : integer;
      clx, cly       : TContributorList;
      artx, arty     : integer;  // anti ringing threshold x/y
      fr, fg, fb, fm : integer;
      rl, gl, bl     : integer;
      rh, gh, bh     : integer;
      sbBits, dbBits : integer;
      smBits, dmBits : integer;
      sbDif,  dbDif  : integer;
      smDif,  dmDif  : integer;
      sbLine, tbBuf  : PByteArray;
      hBuf, lBuf     : PByteArray;
      smLine, tmBuf  : PByteArray;
      dbPix          : ^byte;
      hPix, lPix     : ^byte;
      dmPix          : ^byte;
      pcp            : ^TContributorPixel;
      rgb            : TRGB;
  begin
    tbBuf := AllocMem(srcBmp.Height * 4 + srcBmp.Height * 1);
    sbBits := integer(srcBmp.ScanLine[0]);
    dbBits := integer(dstBmp.ScanLine[0]);
    if srcBmp.Height > 1 then
         sbDif := integer(srcBmp.ScanLine[1]) - sbBits
    else sbDif := 0;
    if dstBmp.Height > 1 then
         dbDif := integer(dstBmp.ScanLine[1]) - dbBits - 2
    else dbDif := 0;
    if srcMsk <> nil then begin
      GetContributorList(clx, srcBmp.Width,  dstBmp.Width,  rfMitchell);
      GetContributorList(cly, srcBmp.Height, dstBmp.Height, rfMitchell);
      tmBuf := pointer(integer(tbBuf) + srcBmp.Height * 4);
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
          fr := 0;
          fg := 0;
          fb := 0;
          fm := 0;
          pcp := @clx[ix].items[0];
          for ic := 0 to clx[ix].itemCount - 1 do begin
            weight := (pcp^.weight * (256 - smLine^[pcp^.pixel])) div 256;
            inc(fm, weight);
            rgb := TRGB(pointer(@sbLine^[pcp^.pixel * 4])^);
            inc(fr, rgb.r * weight);
            inc(fg, rgb.g * weight);
            inc(fb, rgb.b * weight);
            inc(pcp);
          end;
          if      fb <       0 then dbPix^ := 0
          else if fb > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fb shr 16;
          inc(dbPix);
          if      fg <       0 then dbPix^ := 0
          else if fg > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fg shr 16;
          inc(dbPix);
          if      fr <       0 then dbPix^ := 0
          else if fr > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fr shr 16;
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
          fr := 0;
          fg := 0;
          fb := 0;
          fm := 0;
          pcp := @cly[iy].items[0];
          for ic := 0 to cly[iy].itemCount - 1 do begin
            weight := (pcp^.weight * (256 - tmBuf^[pcp^.pixel])) div 256;
            inc(fm, weight);
            rgb := TRGB(pointer(@tbBuf^[pcp^.pixel * 4])^);
            inc(fr, rgb.r * weight);
            inc(fg, rgb.g * weight);
            inc(fb, rgb.b * weight);
            inc(pcp);
          end;
          if      fb <       0 then dbPix^ := 0
          else if fb > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fb shr 16;
          inc(dbPix);
          if      fg <       0 then dbPix^ := 0
          else if fg > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fg shr 16;
          inc(dbPix);
          if      fr <       0 then dbPix^ := 0
          else if fr > $FF0000 then dbPix^ := 255
          else                      dbPix^ := fr shr 16;
          inc(dbPix, dbDif);
          if      fm <       0 then dmPix^ := 255
          else if fm > $00FF00 then dmPix^ := 0
          else                      dmPix^ := 255 - fm shr 8;
          inc(dmPix, dmDif);
        end;
      end;
    end else begin
      hBuf := AllocMem(srcBmp.Height * 4 + srcBmp.Height * 1);
      lBuf := AllocMem(srcBmp.Height * 4 + srcBmp.Height * 1);
      if srcBmp.Width = dstBmp.Width then
        GetContributorList(clx, srcBmp.Width, dstBmp.Width, rfNearest)
      else
        GetContributorList(clx, srcBmp.Width, dstBmp.Width, rfLanczos4);
      if srcBmp.Height = dstBmp.Height then
        GetContributorList(cly, srcBmp.Height, dstBmp.Height, rfNearest)
      else
        GetContributorList(cly, srcBmp.Height, dstBmp.Height, rfLanczos4);
      if srcBmp.Width < dstBmp.Width then
        artx := 2
      else
        artx := srcBmp.Width div dstBmp.Width + 1;
      if srcBmp.Height < dstBmp.Height then
        arty := 2
      else
        arty := srcBmp.Height div dstBmp.Height + 1;
      for ix := 0 to dstBmp.Width - 1 do begin
        dbPix  := pointer(tbBuf );
        hPix   := pointer(hBuf  );
        lPix   := pointer(lBuf  );
        sbLine := pointer(sbBits);
        for iy := 0 to srcBmp.Height - 1 do begin
          fr := 0;
          fg := 0;
          fb := 0;
          rl := 255;
          gl := 255;
          bl := 255;
          rh := 0;
          gh := 0;
          bh := 0;
          pcp := @clx[ix].items[0];
          for ic := 0 to clx[ix].itemCount - 1 do begin
            weight := pcp^.weight;
            rgb := TRGB(pointer(@sbLine^[pcp^.pixel * 4])^);
            if ic < artx then begin
              if rgb.r > rh then
                rh := rgb.r;
              if rgb.r < rl then
                rl := rgb.r;
              if rgb.g > gh then
                gh := rgb.g;
              if rgb.g < gl then
                gl := rgb.g;
              if rgb.b > bh then
                bh := rgb.b;
              if rgb.b < bl then
                bl := rgb.b;
            end;
            inc(fr, rgb.r * weight);
            inc(fg, rgb.g * weight);
            inc(fb, rgb.b * weight);
            inc(pcp);
          end;
          if      fb <       0 then fb := 0
          else if fb > $FF0000 then fb := 255
          else                      fb := (fb + $8000) shr 16;
          dbPix^ := fb;
          inc(dbPix);
          hPix^ := bh;
          lPix^ := bl;
          inc(hPix);
          inc(lPix);
          if      fg <       0 then fg := 0
          else if fg > $FF0000 then fg := 255
          else                      fg := (fg + $8000) shr 16;
          dbPix^ := fg;
          inc(dbPix);
          hPix^ := gh;
          lPix^ := gl;
          inc(hPix);
          inc(lPix);
          if      fr <       0 then fr := 0
          else if fr > $FF0000 then fr := 255
          else                      fr := (fr + $8000) shr 16;
          dbPix^ := fr;
          inc(dbPix, 2);
          hPix^ := rh;
          lPix^ := rl;
          inc(hPix, 2);
          inc(lPix, 2);
          inc(integer(sbLine), sbDif);
        end;
        dbPix := pointer(dbBits + ix * 4);
        for iy := 0 to dstBmp.Height - 1 do begin
          fr  := 0;
          fg  := 0;
          fb  := 0;
          rl := 255;
          gl := 255;
          bl := 255;
          rh := 0;
          gh := 0;
          bh := 0;
          pcp := @cly[iy].items[0];
          for ic := 0 to cly[iy].itemCount - 1 do begin
            weight := pcp^.weight;
            rgb := TRGB(pointer(@tbBuf^[pcp^.pixel * 4])^);
            inc(fr, rgb.r * weight);
            inc(fg, rgb.g * weight);
            inc(fb, rgb.b * weight);
            if ic < arty then begin
              rgb := TRGB(pointer(@hBuf^[pcp^.pixel * 4])^);
              if rgb.r > rh then
                rh := rgb.r;
              if rgb.g > gh then
                gh := rgb.g;
              if rgb.b > bh then
                bh := rgb.b;
              rgb := TRGB(pointer(@lBuf^[pcp^.pixel * 4])^);
              if rgb.r < rl then
                rl := rgb.r;
              if rgb.g < gl then
                gl := rgb.g;
              if rgb.b < bl then
                bl := rgb.b;
            end;
            inc(pcp);
          end;
          if      fb <       0 then fb := 0
          else if fb > $FF0000 then fb := 255
          else                      fb := (fb + $8000) shr 16;
          {$ifdef antiringing}
          if fb > bh then
            fb := bh
          else
            if fb < bl then
              fb := bl;
          {$endif}
          dbPix^ := fb;
          inc(dbPix);
          if      fg <       0 then fg := 0
          else if fg > $FF0000 then fg := 255
          else                      fg := (fg + $8000) shr 16;
          {$ifdef antiringing}
          if fg > gh then
            fg := gh
          else
            if fg < gl then
              fg := gl;
          {$endif}
          dbPix^ := fg;
          inc(dbPix);
          if      fr <       0 then fr := 0
          else if fr > $FF0000 then fr := 255
          else                      fr := (fr + $8000) shr 16;
          {$ifdef antiringing}
          if fr > rh then
            fr := rh
          else
            if fr < rl then
              fr := rl;
          {$endif}
          dbPix^ := fr;
          inc(dbPix, dbDif);
        end;
      end;
      FreeMem(lBuf);
      FreeMem(hBuf);
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
                   15 : if ForcePixelFormat([srcBmp], pf15bit) then Resampling15;
                   16 : if ForcePixelFormat([srcBmp], pf16bit) then Resampling16;
                   24 : if ForcePixelFormat([srcBmp], pf24bit) then Resampling24;
                   32 : if ForcePixelFormat([srcBmp], pf32bit) then Resampling32;
                 end;
  end;
end;

procedure StretchBitmap(srcBmp, dstBmp : TBitmap;
                        srcMsk, dstMsk : TBitmap;
                        quality        : TStretchQuality = sqHigh);
begin
  StretchBitmap_(srcBmp, dstBmp, srcMsk, dstMsk, quality);
end;

procedure StretchBitmap_(bmp, msk  : TBitmap;
                         newWidth  : integer;
                         newHeight : integer;
                         quality   : TStretchQuality = sqHigh;
                         filter    : TResamplingFilter = rfLanczos4); overload;
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
      StretchBitmap_(bmp, newBmp, msk, newMsk, quality, filter);
      bmp.Assign(newBmp);
      if msk <> nil then msk.Assign(newMsk);
    finally newMsk.Free end;
  finally newBmp.Free end;
end;

procedure StretchBitmap(bmp, msk  : TBitmap;
                        newWidth  : integer;
                        newHeight : integer;
                        quality   : TStretchQuality = sqHigh);
begin
  StretchBitmap_(bmp, msk, newWidth, newHeight, quality);
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

type
  TYCbCr = packed record y, cb, cr : single end;
  TAYCbCr = array [0..maxInt shr 4 - 1] of TYCbCr;
  TPAYCbCr = ^TAYCbCr;

function Sign(const value: double) : integer;
begin
  if ((PInt64(@value)^ and $7FFFFFFFFFFFFFFF) = $0000000000000000) then
    result := 0
  else
    if ((PInt64(@value)^ and $8000000000000000) = $8000000000000000) then
      result := -1
    else
      result := +1;
end;

procedure ICBI1Plane(src, dst: TPAYCbCr; width, height: integer; const stepSizes: array of integer; coef1, coef2: double);
const
  GM = 5.0;   // Weight for Isophote smoothing energy (default = 5.0 -> 19.0)
  BT = -1.0;  // Weight for Curvature enhancement energy (default = -1.0 -> -3.0)
  AL = 1.0;   // Weight for Curvature Continuity energy (default = 1.0 -> 0.7)
  TS = 100;   // Threshold on image change for stopping iterations (default = 100)

var D1, D2, D3, C1, C2 : array of array of single;
    pixels : array of array of TYCbCr;
    i1, i2, i3 : integer;
    p1, p2 : single;
    step : integer;
    g : integer;
    diff : integer;
    EN1, EN2, EN3, EN4, EN5, EN6 : single;
    EA1, EA2, EA3, EA4, EA5, EA6 : single;
    ES1, ES2, ES3, ES4, ES5, ES6 : single;
    EN, EA, ES : single;
    EISO : double;
    newWidth, newHeight : integer;
    ix, iy : integer;
    maxValue, testValue : single;
begin
  newWidth  := width  * 2 - 1;
  newHeight := height * 2 - 1;

  SetLength(D1, newWidth, newHeight);
  SetLength(D2, newWidth, newHeight);
  SetLength(D3, newWidth, newHeight);
  SetLength(C1, newWidth, newHeight);
  SetLength(C2, newWidth, newHeight);

  SetLength(pixels, newWidth, newHeight);
  for ix := 0 to width - 1 do
    for iy := 0 to height - 1 do
      pixels[ix * 2, iy * 2] := src[iy * width + ix];

  ix := 1;
  iy := newHeight - 1;
  for i1 := 1 to width - 1 do begin
    pixels[ix, 0 ].y  := (pixels[ix + 1, 0 ].y  + pixels[ix - 1, 0 ].y ) / 2;
    pixels[ix, 0 ].cb := (pixels[ix + 1, 0 ].cb + pixels[ix - 1, 0 ].cb) / 2;
    pixels[ix, 0 ].cr := (pixels[ix + 1, 0 ].cr + pixels[ix - 1, 0 ].cr) / 2;
    pixels[ix, iy].y  := (pixels[ix + 1, iy].y  + pixels[ix - 1, iy].y ) / 2;
    pixels[ix, iy].cb := (pixels[ix + 1, iy].cb + pixels[ix - 1, iy].cb) / 2;
    pixels[ix, iy].cr := (pixels[ix + 1, iy].cr + pixels[ix - 1, iy].cr) / 2;
    inc(ix, 2);
  end;
  ix := newWidth - 1;
  iy := 1;
  for i1 := 1 to height - 1 do begin
    pixels[0,  iy].y  := (pixels[0,  iy + 1].y  + pixels[0,  iy - 1].y ) / 2;
    pixels[0,  iy].cb := (pixels[0,  iy + 1].cb + pixels[0,  iy - 1].cb) / 2;
    pixels[0,  iy].cr := (pixels[0,  iy + 1].cr + pixels[0,  iy - 1].cr) / 2;
    pixels[ix, iy].y  := (pixels[ix, iy + 1].y  + pixels[ix, iy - 1].y ) / 2;
    pixels[ix, iy].cb := (pixels[ix, iy + 1].cb + pixels[ix, iy - 1].cb) / 2;
    pixels[ix, iy].cr := (pixels[ix, iy + 1].cr + pixels[ix, iy - 1].cr) / 2;
    inc(iy, 2);
  end;

  ix := 1;
  for i1 := 1 to width - 1 do begin
    iy := 1;
    for i2 := 1 to height - 1 do begin
      p1 := (pixels[ix - 1, iy - 1].y + pixels[ix + 1, iy + 1].y) / 2;
      p2 := (pixels[ix + 1, iy - 1].y + pixels[ix - 1, iy + 1].y) / 2;
      if (i1 > 1) and (i1 < width - 1) and (i2 > 1) and (i2 < height - 1) then begin
        if abs(pixels[ix - 1, iy - 3].y + pixels[ix - 3, iy - 1].y + pixels[ix + 1, iy + 3].y + pixels[ix + 3, iy + 1].y + (2 * p2) - (6 * p1)) >
           abs(pixels[ix - 3, iy + 1].y + pixels[ix - 1, iy + 3].y + pixels[ix + 3, iy - 1].y + pixels[ix + 1, iy - 3].y + (2 * p1) - (6 * p2)) then begin
          if (ix > 2) and (iy > 2) and (ix < newWidth - 3) and (iy < newHeight - 3) then
            p1 := (pixels[ix - 1, iy - 1].y + pixels[ix + 1, iy + 1].y) * coef1 +
                  (pixels[ix - 3, iy - 3].y + pixels[ix + 3, iy + 3].y) * coef2;
          pixels[ix, iy].y := p1;
          pixels[ix, iy].cb := (pixels[ix - 1, iy - 1].cb + pixels[ix + 1, iy + 1].cb) / 2;
          pixels[ix, iy].cr := (pixels[ix - 1, iy - 1].cr + pixels[ix + 1, iy + 1].cr) / 2;
        end else begin
          if (ix > 2) and (iy > 2) and (ix < newWidth - 3) and (iy < newHeight - 3) then
            p2 := (pixels[ix + 1, iy - 1].y + pixels[ix - 1, iy + 1].y) * coef1 +
                  (pixels[ix + 3, iy - 3].y + pixels[ix - 3, iy + 3].y) * coef2;
          pixels[ix, iy].y := p2;
          pixels[ix, iy].cb := (pixels[ix + 1, iy - 1].cb + pixels[ix - 1, iy + 1].cb) / 2;
          pixels[ix, iy].cr := (pixels[ix + 1, iy - 1].cr + pixels[ix - 1, iy + 1].cr) / 2;
        end;
      end else
        if abs(pixels[ix - 1, iy - 1].y - pixels[ix + 1, iy + 1].y) < abs(pixels[ix + 1, iy - 1].y - pixels[ix - 1, iy + 1].y) then begin
          pixels[ix, iy].y := p1;
          pixels[ix, iy].cb := (pixels[ix - 1, iy - 1].cb + pixels[ix + 1, iy + 1].cb) / 2;
          pixels[ix, iy].cr := (pixels[ix - 1, iy - 1].cr + pixels[ix + 1, iy + 1].cr) / 2;
        end else begin
          pixels[ix, iy].y := p2;
          pixels[ix, iy].cb := (pixels[ix + 1, iy - 1].cb + pixels[ix - 1, iy + 1].cb) / 2;
          pixels[ix, iy].cr := (pixels[ix + 1, iy - 1].cr + pixels[ix - 1, iy + 1].cr) / 2;
        end;
      inc(iy, 2);
    end;
    inc(ix, 2);
  end;

  // iterative refinement
  for g := 0 to high(stepSizes) do begin
    diff := 0;
    step := stepSizes[g];

    // computation of derivatives
    for ix := 3 to newWidth - 4 do begin
      iy := 4 - (ix and 1);
      for i2 := 2 to height - 2 do begin
        C1[ix, iy] := (pixels[ix - 1, iy - 1].y - pixels[ix + 1, iy + 1].y) / 2;
        C2[ix, iy] := (pixels[ix + 1, iy - 1].y - pixels[ix - 1, iy + 1].y) / 2;
        D1[ix, iy] := pixels[ix - 1, iy - 1].y + pixels[ix + 1, iy + 1].y - 2 * pixels[ix, iy].y;
        D2[ix, iy] := pixels[ix + 1, iy - 1].y + pixels[ix - 1, iy + 1].y - 2 * pixels[ix, iy].y;
        D3[ix, iy] := (pixels[ix, iy - 2].y - pixels[ix - 2, iy].y + pixels[ix, iy + 2].y - pixels[ix + 2, iy].y) / 2;
        inc(iy, 2);
      end;
    end;

    ix := 5;
    for i1 := 3 to width - 3 do begin
      iy := 5;
      for i2 := 3 to height - 3 do begin
        EN1 := abs(D1[ix, iy] - D1[ix + 1, iy + 1]) + abs(D1[ix, iy] - D1[ix - 1, iy - 1]);
        EN2 := abs(D1[ix, iy] - D1[ix + 1, iy - 1]) + abs(D1[ix, iy] - D1[ix - 1, iy + 1]);
        EN3 := abs(D2[ix, iy] - D2[ix + 1, iy + 1]) + abs(D2[ix, iy] - D2[ix - 1, iy - 1]);
        EN4 := abs(D2[ix, iy] - D2[ix + 1, iy - 1]) + abs(D2[ix, iy] - D2[ix - 1, iy + 1]);
        EN5 := abs(pixels[ix - 2, iy - 2].y + pixels[ix + 2, iy + 2].y - 2 * pixels[ix, iy].y);
        EN6 := abs(pixels[ix + 2, iy - 2].y + pixels[ix - 2, iy + 2].y - 2 * pixels[ix, iy].y);

        EA1 := abs(D1[ix, iy] - D1[ix + 1, iy + 1] - 3 * step) + abs(D1[ix, iy] - D1[ix - 1, iy - 1] - 3 * step);
        EA2 := abs(D1[ix, iy] - D1[ix + 1, iy - 1] - 3 * step) + abs(D1[ix, iy] - D1[ix - 1, iy + 1] - 3 * step);
        EA3 := abs(D2[ix, iy] - D2[ix + 1, iy + 1] - 3 * step) + abs(D2[ix, iy] - D2[ix - 1, iy - 1] - 3 * step);
        EA4 := abs(D2[ix, iy] - D2[ix + 1, iy - 1] - 3 * step) + abs(D2[ix, iy] - D2[ix - 1, iy + 1] - 3 * step);
        EA5 := abs(pixels[ix - 2, iy - 2].y + pixels[ix + 2, iy + 2].y - 2 * pixels[ix, iy].y - 2 * step);
        EA6 := abs(pixels[ix + 2, iy - 2].y + pixels[ix - 2, iy + 2].y - 2 * pixels[ix, iy].y - 2 * step);

        ES1 := abs(D1[ix, iy] - D1[ix + 1, iy + 1] + 3 * step) + abs(D1[ix, iy] - D1[ix - 1, iy - 1] + 3 * step);
        ES2 := abs(D1[ix, iy] - D1[ix + 1, iy - 1] + 3 * step) + abs(D1[ix, iy] - D1[ix - 1, iy + 1] + 3 * step);
        ES3 := abs(D2[ix, iy] - D2[ix + 1, iy + 1] + 3 * step) + abs(D2[ix, iy] - D2[ix - 1, iy - 1] + 3 * step);
        ES4 := abs(D2[ix, iy] - D2[ix + 1, iy - 1] + 3 * step) + abs(D2[ix, iy] - D2[ix - 1, iy + 1] + 3 * step);
        ES5 := abs(pixels[ix - 2, iy - 2].y + pixels[ix + 2, iy + 2].y - 2 * pixels[ix, iy].y + 2 * step);
        ES6 := abs(pixels[ix + 2, iy - 2].y + pixels[ix - 2, iy + 2].y - 2 * pixels[ix, iy].y + 2 * step);

        if (C1[ix, iy] <> 0) or (C2[ix, iy] <> 0) then begin
          EISO := (C1[ix, iy] * C1[ix, iy] * D2[ix, iy] - 2 * C1[ix, iy] * C2[ix, iy] * D3[ix, iy] + C2[ix, iy] * C2[ix, iy] * D1[ix, iy]) / (C1[ix, iy] * C1[ix, iy] + C2[ix, iy] * C2[ix, iy]);
          if abs(EISO) < 0.2 then
            EISO := 0;
        end else
          EISO := 0;

        EN := (AL * (EN1 + EN2 + EN3 + EN4)) + (BT * (EN5 + EN6));
        EA := (AL * (EA1 + EA2 + EA3 + EA4)) + (BT * (EA5 + EA6)) - (GM * sign(EISO));
        ES := (AL * (ES1 + ES2 + ES3 + ES4)) + (BT * (ES5 + ES6)) + (GM * sign(EISO));

        if (EN > EA) and (ES > EA) then begin
          if pixels[ix, iy].y + step > 255 then
            pixels[ix, iy].y := 255
          else
            pixels[ix, iy].y := pixels[ix, iy].y + step;

          maxValue := pixels[ix - 1, iy - 1].y;
          testValue := pixels[ix - 1, iy + 1].y;
          if testValue > maxValue then maxValue := testValue;
          testValue := pixels[ix + 1, iy + 1].y;
          if testValue > maxValue then maxValue := testValue;
          testValue := pixels[ix + 1, iy - 1].y;
          if testValue > maxValue then maxValue := testValue;
          if pixels[ix, iy].y > maxValue then
            pixels[ix, iy].y := maxValue;

          diff := diff + step;
        end else
          if (EN > ES) and (EA > ES) then begin
            if pixels[ix, iy].y <= step then
              pixels[ix, iy].y := 0
            else
              pixels[ix, iy].y := pixels[ix, iy].y - step;

            maxValue := pixels[ix - 1, iy - 1].y;
            testValue := pixels[ix - 1, iy + 1].y;
            if testValue < maxValue then maxValue := testValue;
            testValue := pixels[ix + 1, iy + 1].y;
            if testValue < maxValue then maxValue := testValue;
            testValue := pixels[ix + 1, iy - 1].y;
            if testValue < maxValue then maxValue := testValue;
            if pixels[ix, iy].y < maxValue then
              pixels[ix, iy].y := maxValue;

            diff := diff + step;
          end;

        inc(iy, 2);
      end;
      inc(ix, 2);
    end;

    if diff < TS then
      break;
  end;

  for ix := 1 to newWidth - 2 do begin
    iy := 1 + (ix and 1);
    for i2 := 1 to height - 1 do begin
      p1 := (pixels[ix - 1, iy].y + pixels[ix + 1, iy].y) / 2;
      p2 := (pixels[ix, iy - 1].y + pixels[ix, iy + 1].y) / 2;
      if (ix > 1) and (ix < newWidth - 3) and (iy > 1) and (iy < height - 3) then begin
        if abs(pixels[ix - 2, iy - 1].y + pixels[ix - 2, iy + 1].y + pixels[ix + 2, iy + 1].y + pixels[ix + 2, iy - 1].y + (2 * p2) - (6 * p1)) >
           abs(pixels[ix - 1, iy + 2].y + pixels[ix + 1, iy + 2].y + pixels[ix + 1, iy - 2].y + pixels[ix - 1, iy - 2].y + (2 * p1) - (6 * p2)) then begin
          if (ix > 2) and (iy > 2) and (ix < newWidth - 3) and (iy < newHeight - 3) then
            p1 := (pixels[ix - 1, iy].y + pixels[ix + 1, iy].y) * coef1 +
                  (pixels[ix - 3, iy].y + pixels[ix + 3, iy].y) * coef2;
          pixels[ix, iy].y := p1;
          pixels[ix, iy].cb := (pixels[ix - 1, iy].cb + pixels[ix + 1, iy].cb) / 2;
          pixels[ix, iy].cr := (pixels[ix - 1, iy].cr + pixels[ix + 1, iy].cr) / 2;
        end else begin
          if (ix > 2) and (iy > 2) and (ix < newWidth - 3) and (iy < newHeight - 3) then
            p2 := (pixels[ix, iy - 1].y + pixels[ix, iy + 1].y) * coef1 +
                  (pixels[ix, iy - 3].y + pixels[ix, iy + 3].y) * coef2;
          pixels[ix, iy].y := p2;
          pixels[ix, iy].cb := (pixels[ix, iy - 1].cb + pixels[ix, iy + 1].cb) / 2;
          pixels[ix, iy].cr := (pixels[ix, iy - 1].cr + pixels[ix, iy + 1].cr) / 2;
        end;
      end else
        if abs(pixels[ix - 1, iy].y - pixels[ix + 1, iy].y) < abs(pixels[ix, iy - 1].y - pixels[ix, iy + 1].y) then begin
          pixels[ix, iy].y := p1;
          pixels[ix, iy].cb := (pixels[ix - 1, iy].cb + pixels[ix + 1, iy].cb) / 2;
          pixels[ix, iy].cr := (pixels[ix - 1, iy].cr + pixels[ix + 1, iy].cr) / 2;
        end else begin
          pixels[ix, iy].y := p2;
          pixels[ix, iy].cb := (pixels[ix, iy - 1].cb + pixels[ix, iy + 1].cb) / 2;
          pixels[ix, iy].cr := (pixels[ix, iy - 1].cr + pixels[ix, iy + 1].cr) / 2;
        end;
      inc(iy, 2);
    end;
  end;

  // iterative refinement
  for g := 0 to high(stepSizes) do begin
    diff := 0;
    step := stepSizes[g];

    // computation of derivatives
    for ix := 1 to newWidth - 3 do
      for iy := 1 to newHeight - 3 do begin
        C1[ix, iy] := (pixels[ix, iy - 1].y - pixels[ix, iy + 1].y) / 2;
        C2[ix, iy] := (pixels[ix - 1, iy].y - pixels[ix + 1, iy].y) / 2;
        D1[ix, iy] := pixels[ix, iy - 1].y + pixels[ix, iy + 1].y - 2 * pixels[ix, iy].y;
        D2[ix, iy] := pixels[ix + 1, iy].y + pixels[ix - 1, iy].y - 2 * pixels[ix, iy].y;
        D3[ix, iy] := (pixels[ix - 1, iy - 1].y - pixels[ix - 1, iy + 1].y + pixels[ix + 1, iy + 1].y - pixels[ix + 1, iy - 1].y) / 2;
      end;

    for ix := 2 to newWidth - 3 do begin
      iy := 3 - (ix and 1);
      for i2 := 1 to height - 2 do begin
        EN1 := abs(D1[ix, iy] - D1[ix, iy + 1]) + abs(D1[ix, iy] - D1[ix, iy - 1]);
        EN2 := abs(D1[ix, iy] - D1[ix + 1, iy]) + abs(D1[ix, iy] - D1[ix - 1, iy]);
        EN3 := abs(D2[ix, iy] - D2[ix, iy + 1]) + abs(D2[ix, iy] - D2[ix, iy - 1]);
        EN4 := abs(D2[ix, iy] - D2[ix + 1, iy]) + abs(D2[ix, iy] - D2[ix - 1, iy]);
        EN5 := abs(pixels[ix, iy - 2].y + pixels[ix, iy + 2].y - 2 * pixels[ix, iy].y);
        EN6 := abs(pixels[ix + 2, iy].y + pixels[ix - 2, iy].y - 2 * pixels[ix, iy].y);

        EA1 := abs(D1[ix, iy] - D1[ix, iy + 1] - 3 * step) + abs(D1[ix, iy] - D1[ix, iy - 1] - 3 * step);
        EA2 := abs(D1[ix, iy] - D1[ix + 1, iy] - 3 * step) + abs(D1[ix, iy] - D1[ix - 1, iy] - 3 * step);
        EA3 := abs(D2[ix, iy] - D2[ix, iy + 1] - 3 * step) + abs(D2[ix, iy] - D2[ix, iy - 1] - 3 * step);
        EA4 := abs(D2[ix, iy] - D2[ix + 1, iy] - 3 * step) + abs(D2[ix, iy] - D2[ix - 1, iy] - 3 * step);
        EA5 := abs(pixels[ix, iy - 2].y + pixels[ix, iy + 2].y - 2 * pixels[ix, iy].y - 2 * step);
        EA6 := abs(pixels[ix + 2, iy].y + pixels[ix - 2, iy].y - 2 * pixels[ix, iy].y - 2 * step);

        ES1 := abs(D1[ix, iy] - D1[ix, iy + 1] + 3 * step) + abs(D1[ix, iy] - D1[ix, iy - 1] + 3 * step);
        ES2 := abs(D1[ix, iy] - D1[ix + 1, iy] + 3 * step) + abs(D1[ix, iy] - D1[ix - 1, iy] + 3 * step);
        ES3 := abs(D2[ix, iy] - D2[ix, iy + 1] + 3 * step) + abs(D2[ix, iy] - D2[ix, iy - 1] + 3 * step);
        ES4 := abs(D2[ix, iy] - D2[ix + 1, iy] + 3 * step) + abs(D2[ix, iy] - D2[ix - 1, iy] + 3 * step);
        ES5 := abs(pixels[ix, iy - 2].y + pixels[ix, iy + 2].y - 2 * pixels[ix, iy].y + 2 * step);
        ES6 := abs(pixels[ix + 2, iy].y + pixels[ix - 2, iy].y - 2 * pixels[ix, iy].y + 2 * step);

        if (C1[ix, iy] <> 0) or (C2[ix, iy] <> 0) then begin
          EISO := (C1[ix, iy] * C1[ix, iy] * D2[ix, iy] - 2 * C1[ix, iy] * C2[ix, iy] * D3[ix, iy] + C2[ix, iy] * C2[ix, iy] * D1[ix, iy]) / (C1[ix, iy] * C1[ix, iy] + C2[ix, iy] * C2[ix, iy]);
          if abs(EISO) < 0.2 then
            EISO := 0;
        end else
          EISO := 0;

        EN := (AL * (EN1 + EN2 + EN3 + EN4)) + (BT * (EN5 + EN6));
        EA := (AL * (EA1 + EA2 + EA3 + EA4)) + (BT * (EA5 + EA6)) - (GM * sign(EISO));
        ES := (AL * (ES1 + ES2 + ES3 + ES4)) + (BT * (ES5 + ES6)) + (GM * sign(EISO));

        if (EN > EA) and (ES > EA) then begin
          if pixels[ix, iy].y + step > 255 then
            pixels[ix, iy].y := 255
          else
            pixels[ix, iy].y := pixels[ix, iy].y + step;

          maxValue := pixels[ix, iy - 1].y;
          testValue := pixels[ix - 1, iy].y;
          if testValue > maxValue then maxValue := testValue;
          testValue := pixels[ix, iy + 1].y;
          if testValue > maxValue then maxValue := testValue;
          testValue := pixels[ix + 1, iy].y;
          if testValue > maxValue then maxValue := testValue;
          if pixels[ix, iy].y > maxValue then
            pixels[ix, iy].y := maxValue;

          diff := diff + step;
        end else
          if (EN > ES) and (EA > ES) then begin
            if pixels[ix, iy].y <= step then
              pixels[ix, iy].y := 0
            else
              pixels[ix, iy].y := pixels[ix, iy].y - step;

            maxValue := pixels[ix, iy - 1].y;
            testValue := pixels[ix - 1, iy].y;
            if testValue < maxValue then maxValue := testValue;
            testValue := pixels[ix, iy + 1].y;
            if testValue < maxValue then maxValue := testValue;
            testValue := pixels[ix + 1, iy].y;
            if testValue < maxValue then maxValue := testValue;
            if pixels[ix, iy].y < maxValue then
              pixels[ix, iy].y := maxValue;

            diff := diff + step;
          end;

        inc(iy, 2);
      end;
    end;

    if diff < TS then
      break;
  end;

  for ix := 0 to newWidth - 1 do
    for iy := 0 to newHeight - 1 do
      dst[iy * newWidth + ix] := pixels[ix, iy];
end;

procedure GeometricPlane(src, dst: TPAYCbCr; width, height: integer);

  function CalcMedian(var median: array of single; count: integer) : single;

    procedure InternalQuickSort(l, r: integer);
    var i1, i2, i3 : integer;
        swap       : single;
    begin
      repeat
        i1 := l;
        i2 := r;
        i3 := (l + r) shr 1;
        repeat
          while true do begin
            if median[i1] >= median[i3] then
              break;
            inc(i1);
          end;
          while true do begin
            if median[i2] <= median[i3] then
              break;
            dec(i2);
          end;
          if i1 <= i2 then begin
            swap       := median[i1];
            median[i1] := median[i2];
            median[i2] := swap;
            if      i3 = i1 then i3 := i2
            else if i3 = i2 then i3 := i1;
            inc(i1);
            dec(i2);
          end;
        until i1 > i2;
        if l < i2 then InternalQuickSort(l, i2);
        l := i1;
      until i1 >= r;
    end;

  begin
    InternalQuickSort(0, count - 1);
    if odd(count) then
      result := median[count div 2]
    else
      result := (median[count div 2 - 1] + median[count div 2]) / 2;
  end;

const threshold = 7.5;
var pixels : array of array of TYCbCr;
    i1, i2 : integer;
    p00, p01, p10, p11 : single;
    mean1, mean2, dev1 : single;
    newWidth, newHeight : integer;
    ix, iy : integer;
    b1, b2 : boolean;
    median : array [0..7] of single;
begin
  newWidth  := width  * 2 - 1;
  newHeight := height * 2 - 1;

  // step 1: spread source pixels to destination raster
  SetLength(pixels, newWidth, newHeight);
  for ix := 0 to newWidth - 1 do
    for iy := 0 to newHeight - 1 do
      pixels[ix, iy].y := -1;
  for ix := 0 to width - 1 do
    for iy := 0 to height - 1 do
      pixels[ix * 2, iy * 2] := src[iy * width + ix];

  // step 2: first interpolation based on geometrical shapes
  ix := 1;
  for i1 := 1 to width - 1 do begin
    iy := 1;
    for i2 := 1 to height - 1 do begin
      p00 := pixels[ix - 1, iy - 1].y;
      p01 := pixels[ix - 1, iy + 1].y;
      p10 := pixels[ix + 1, iy - 1].y;
      p11 := pixels[ix + 1, iy + 1].y;
      mean1 := (p00 + p01 + p10 + p11) / 4;
      dev1 := Power(((p00 - mean1) * (p00 - mean1) + (p01 - mean1) * (p01 - mean1) + (p10 - mean1) * (p10 - mean1) + (p11 - mean1) * (p11 - mean1)) / 4, 0.5);
      pixels[ix, iy].y := mean1;
      if 2 * dev1 < threshold then begin
        // constant region
        pixels[ix,     iy].y := mean1;
        pixels[ix - 1, iy].y := mean1;
        pixels[ix + 1, iy].y := mean1;
        pixels[ix, iy - 1].y := mean1;
        pixels[ix, iy + 1].y := mean1;
      end else begin
        mean1 := (p01 + p10 + p11) / 3;
        dev1 := Power(((p01 - mean1) * (p01 - mean1) + (p10 - mean1) * (p10 - mean1) + (p11 - mean1) * (p11 - mean1)) / 3, 0.5);
        if 2 * dev1 < threshold then begin
          // top left corner
          pixels[ix,     iy].y := mean1;
          pixels[ix + 1, iy].y := mean1;
          pixels[ix, iy + 1].y := mean1;
        end else begin
          mean1 := (p00 + p01 + p11) / 3;
          dev1 := Power(((p00 - mean1) * (p00 - mean1) + (p01 - mean1) * (p01 - mean1) + (p11 - mean1) * (p11 - mean1)) / 3, 0.5);
          if 2 * dev1 < threshold then begin
            // top right corner
            pixels[ix,     iy].y := mean1;
            pixels[ix - 1, iy].y := mean1;
            pixels[ix, iy + 1].y := mean1;
          end else begin
            mean1 := (p00 + p01 + p10) / 3;
            dev1 := Power(((p00 - mean1) * (p00 - mean1) + (p01 - mean1) * (p01 - mean1) + (p10 - mean1) * (p10 - mean1)) / 3, 0.5);
            if 2 * dev1 < threshold then begin
              // bottom right corner
              pixels[ix,     iy].y := mean1;
              pixels[ix - 1, iy].y := mean1;
              pixels[ix, iy - 1].y := mean1;
            end else begin
              mean1 := (p00 + p10 + p11) / 3;
              dev1 := Power(((p00 - mean1) * (p00 - mean1) + (p10 - mean1) * (p10 - mean1) + (p11 - mean1) * (p11 - mean1)) / 3, 0.5);
              if 2 * dev1 < threshold then begin
                // bottom left corner
                pixels[ix,     iy].y := mean1;
                pixels[ix + 1, iy].y := mean1;
                pixels[ix, iy - 1].y := mean1;
              end else begin
                b1 := abs(p00 - p10) < threshold;
                b2 := abs(p01 - p11) < threshold;
                if b1 or b2 then begin
                  // horizontal edge
                  mean1 := (p00 + p10) / 2;
                  mean2 := (p01 + p11) / 2;
                  if b1 then
                    pixels[ix, iy - 1].y := mean1;
                  if b2 then
                    pixels[ix, iy + 1].y := mean2;
                  if b1 and b2 then begin
                    pixels[ix,     iy].y := (mean1 + mean2) / 2;
                    pixels[ix - 1, iy].y := (mean1 + mean2) / 2;
                    pixels[ix + 1, iy].y := (mean1 + mean2) / 2;
                  end;
                end else begin
                  b1 := abs(p00 - p01) < threshold;
                  b2 := abs(p10 - p11) < threshold;
                  if b1 or b2 then begin
                    // vertical edge
                    mean1 := (p00 + p01) / 2;
                    mean2 := (p10 + p11) / 2;
                    if b1 then
                      pixels[ix - 1, iy].y := mean1;
                    if b2 then
                      pixels[ix + 1, iy].y := mean2;
                    if b1 and b2 then begin
                      pixels[ix, iy    ].y := (mean1 + mean2) / 2;
                      pixels[ix, iy - 1].y := (mean1 + mean2) / 2;
                      pixels[ix, iy + 1].y := (mean1 + mean2) / 2;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
      inc(iy, 2);
    end;
    inc(ix, 2);
  end;

  // step 3: fill holes which have at least 3 surrouning pixels
  for ix := 1 to newWidth - 2 do
    for iy := 1 to newHeight - 2 do
      if (odd(ix) <> odd(iy)) and (pixels[ix, iy].y < 0) then begin
        p00 := pixels[ix, iy - 1].y;
        p01 := pixels[ix - 1, iy].y;
        p10 := pixels[ix + 1, iy].y;
        p11 := pixels[ix, iy + 1].y;
        i1 := 0;
        if p00 >= 0 then inc(i1);
        if p01 >= 0 then inc(i1);
        if p10 >= 0 then inc(i1);
        if p11 >= 0 then inc(i1);
        if i1 = 4 then begin
          // all surrounding pixels are set
          mean1 := (p00 + p01 + p10 + p11) / 4;
          dev1 := Power(((p00 - mean1) * (p00 - mean1) + (p01 - mean1) * (p01 - mean1) + (p10 - mean1) * (p10 - mean1) + (p11 - mean1) * (p11 - mean1)) / 4, 0.5);
          pixels[ix, iy].y := mean1;
          if 2 * dev1 < threshold then begin
            // constant region
            pixels[ix, iy].y := mean1;
          end else begin
            mean1 := (p01 + p10 + p11) / 3;
            dev1 := Power(((p01 - mean1) * (p01 - mean1) + (p10 - mean1) * (p10 - mean1) + (p11 - mean1) * (p11 - mean1)) / 3, 0.5);
            if 2 * dev1 < threshold then begin
              // top left corner
              pixels[ix, iy].y := mean1;
            end else begin
              mean1 := (p00 + p01 + p11) / 3;
              dev1 := Power(((p00 - mean1) * (p00 - mean1) + (p01 - mean1) * (p01 - mean1) + (p11 - mean1) * (p11 - mean1)) / 3, 0.5);
              if 2 * dev1 < threshold then begin
                // top right corner
                pixels[ix, iy].y := mean1;
              end else begin
                mean1 := (p00 + p01 + p10) / 3;
                dev1 := Power(((p00 - mean1) * (p00 - mean1) + (p01 - mean1) * (p01 - mean1) + (p10 - mean1) * (p10 - mean1)) / 3, 0.5);
                if 2 * dev1 < threshold then begin
                  // bottom right corner
                  pixels[ix, iy].y := mean1;
                end else begin
                  mean1 := (p00 + p10 + p11) / 3;
                  dev1 := Power(((p00 - mean1) * (p00 - mean1) + (p10 - mean1) * (p10 - mean1) + (p11 - mean1) * (p11 - mean1)) / 3, 0.5);
                  if 2 * dev1 < threshold then begin
                    // bottom left corner
                    pixels[ix, iy].y := mean1;
                  end;
                end;
              end;
            end;
          end;
        end else
          if i1 = 3 then begin
            if p00 < 0 then begin
              mean1 := (p01 + p10 + p11) / 3;
              dev1 := Power(((p01 - mean1) * (p01 - mean1) + (p10 - mean1) * (p10 - mean1) + (p11 - mean1) * (p11 - mean1)) / 3, 0.5);
              if 2 * dev1 < threshold then
                // top left corner
                pixels[ix, iy].y := mean1;
            end else
              if p10 < 0 then begin
                mean1 := (p00 + p01 + p11) / 3;
                dev1 := Power(((p00 - mean1) * (p00 - mean1) + (p01 - mean1) * (p01 - mean1) + (p11 - mean1) * (p11 - mean1)) / 3, 0.5);
                if 2 * dev1 < threshold then
                  // top right corner
                  pixels[ix, iy].y := mean1;
              end else
                if p11 < 0 then begin
                  mean1 := (p00 + p01 + p10) / 3;
                  dev1 := Power(((p00 - mean1) * (p00 - mean1) + (p01 - mean1) * (p01 - mean1) + (p10 - mean1) * (p10 - mean1)) / 3, 0.5);
                  if 2 * dev1 < threshold then
                    // bottom right corner
                    pixels[ix, iy].y := mean1;
                end else begin
                  mean1 := (p00 + p10 + p11) / 3;
                  dev1 := Power(((p00 - mean1) * (p00 - mean1) + (p10 - mean1) * (p10 - mean1) + (p11 - mean1) * (p11 - mean1)) / 3, 0.5);
                  if 2 * dev1 < threshold then
                    // bottom left corner
                    pixels[ix, iy].y := mean1;
                end; 
         end else
           if i1 = 2 then
             if (p00 >= 0) and (p11 >= 0) then begin
               if abs(p00 - p11) < threshold then
                 pixels[ix, iy].y := (p00 + p11) / 2;
             end else
               if (p01 >= 0) and (p10 >= 0) then begin
                 if abs(p01 - p10) < threshold then
                   pixels[ix, iy].y := (p01 + p10) / 2;
               end;
      end;

  // step 4: fill remaining pixels with median of surrounding pixels
  for ix := 0 to newWidth - 1 do begin
    for iy := 0 to newHeight - 1 do begin
      if pixels[ix, iy].y < 0 then begin
        i1 := 0;
        if ix > 0 then begin
          median[i1] := pixels[ix - 1, iy].y;
          if median[i1] >= 0 then inc(i1);
        end;
        if ix < newWidth - 1 then begin
          median[i1] := pixels[ix + 1, iy].y;
          if median[i1] >= 0 then inc(i1);
        end;
        if iy > 0 then begin
          median[i1] := pixels[ix, iy - 1].y;
          if median[i1] >= 0 then inc(i1);
        end;
        if iy < newHeight - 1 then begin
          median[i1] := pixels[ix, iy + 1].y;
          if median[i1] >= 0 then inc(i1);
        end;
        if i1 < 3 then begin
          if (ix > 0) and (iy > 0) then begin
            median[i1] := pixels[ix - 1, iy - 1].y;
            if median[i1] >= 0 then inc(i1);
          end;
          if (ix > 0) and (iy < newHeight - 1) then begin
            median[i1] := pixels[ix - 1, iy + 1].y;
            if median[i1] >= 0 then inc(i1);
          end;
          if (ix < newWidth - 1) and (iy > 0) then begin
            median[i1] := pixels[ix + 1, iy - 1].y;
            if median[i1] >= 0 then inc(i1);
          end;
          if (ix < newWidth - 1) and (iy < newHeight - 1) then begin
            median[i1] := pixels[ix + 1, iy + 1].y;
            if median[i1] >= 0 then inc(i1);
          end;
        end;
        if i1 > 0 then
          pixels[ix, iy].y := CalcMedian(median, i1);
      end;
    end;
  end;

  for ix := 0 to newWidth - 1 do
    for iy := 0 to newHeight - 1 do
      dst[iy * newWidth + ix] := pixels[ix, iy];
end;

procedure PRPlane(src, dst: TPAYCbCr; width, height: integer; const stepSizes: array of integer);
var pixels : array of array of TYCbCr;
    i1, i2 : integer;
    p00, p02, p20, p22 : double;
    p10, p01, p12, p21 : double;
    w0022, w0220 : double;
    w1012, w0121 : double;
    newWidth, newHeight : integer;
    ix, iy : integer;

const
  GM = 5.0;  // Weight for Isophote smoothing energy (default = 5.0 -> 19.0)
  BT = -1.0;  // Weight for Curvature enhancement energy (default = -1.0 -> -3.0)
  AL = 1.0;   // Weight for Curvature Continuity energy (default = 1.0 -> 0.7)
  TS = 100;   // Threshold on image change for stopping iterations (default = 100)

var D1, D2, D3, C1, C2 : array of array of single;
    i3 : integer;
    p1, p2 : single;
    step : integer;
    g : integer;
    diff : integer;
    EN1, EN2, EN3, EN4, EN5, EN6 : single;
    EA1, EA2, EA3, EA4, EA5, EA6 : single;
    ES1, ES2, ES3, ES4, ES5, ES6 : single;
    EN, EA, ES : single;
    EISO : double;
    maxValue, testValue : single;
    
begin
  newWidth  := width  * 2 - 1;
  newHeight := height * 2 - 1;

  // step 1: spread source pixels to destination raster
  SetLength(pixels, newWidth, newHeight);
  for ix := 0 to width - 1 do
    for iy := 0 to height - 1 do
      pixels[ix * 2, iy * 2] := src[iy * width + ix];

  ix := 1;
  iy := newHeight - 1;
  for i1 := 1 to width - 1 do begin
    pixels[ix, 0 ].y  := (pixels[ix + 1, 0 ].y  + pixels[ix - 1, 0 ].y ) / 2;
    pixels[ix, 0 ].cb := (pixels[ix + 1, 0 ].cb + pixels[ix - 1, 0 ].cb) / 2;
    pixels[ix, 0 ].cr := (pixels[ix + 1, 0 ].cr + pixels[ix - 1, 0 ].cr) / 2;
    pixels[ix, iy].y  := (pixels[ix + 1, iy].y  + pixels[ix - 1, iy].y ) / 2;
    pixels[ix, iy].cb := (pixels[ix + 1, iy].cb + pixels[ix - 1, iy].cb) / 2;
    pixels[ix, iy].cr := (pixels[ix + 1, iy].cr + pixels[ix - 1, iy].cr) / 2;
    inc(ix, 2);
  end;
  ix := newWidth - 1;
  iy := 1;
  for i1 := 1 to height - 1 do begin
    pixels[0,  iy].y  := (pixels[0,  iy + 1].y  + pixels[0,  iy - 1].y ) / 2;
    pixels[0,  iy].cb := (pixels[0,  iy + 1].cb + pixels[0,  iy - 1].cb) / 2;
    pixels[0,  iy].cr := (pixels[0,  iy + 1].cr + pixels[0,  iy - 1].cr) / 2;
    pixels[ix, iy].y  := (pixels[ix, iy + 1].y  + pixels[ix, iy - 1].y ) / 2;
    pixels[ix, iy].cb := (pixels[ix, iy + 1].cb + pixels[ix, iy - 1].cb) / 2;
    pixels[ix, iy].cr := (pixels[ix, iy + 1].cr + pixels[ix, iy - 1].cr) / 2;
    inc(iy, 2);
  end;

  // step 2: interpolate +1+1 pixels
  ix := 1;
  for i1 := 1 to width - 1 do begin
    iy := 1;
    for i2 := 1 to height - 1 do begin
      p00 := pixels[ix - 1, iy - 1].y;
      p02 := pixels[ix - 1, iy + 1].y;
      p20 := pixels[ix + 1, iy - 1].y;
      p22 := pixels[ix + 1, iy + 1].y;
      w0022 := (p00 - p22) / 255;
      w0022 := exp(- w0022 * w0022);
      w0220 := (p02 - p20) / 255;
      w0220 := exp(- w0220 * w0220);
      if (w0022 <> 0) or (w0220 <> 0) then
        pixels[ix, iy].y := (w0022 * p00 + w0022 * p22 + w0220 * p02 + w0220 * p20) / (w0022 * 2 + w0220 * 2)
      else
        pixels[ix, iy].y := p00;
      inc(iy, 2);
    end;
    inc(ix, 2);
  end;

  // step 3: interpolate +1+0 and +0+1 pixels
  for ix := 1 to newWidth - 2 do begin
    iy := 1 + (ix and 1);
    for i2 := 1 to height - 1 do begin
      p10 := pixels[ix, iy - 1].y;
      p01 := pixels[ix - 1, iy].y;
      p21 := pixels[ix + 1, iy].y;
      p12 := pixels[ix, iy + 1].y;
      w1012 := (p10 - p12) / 255;
      w1012 := exp(- w1012 * w1012);
      w0121 := (p01 - p21) / 255;
      w0121 := exp(- w0121 * w0121);
      if (w1012 <> 0) or (w0121 <> 0) then
        pixels[ix, iy].y := (w1012 * p10 + w1012 * p12 + w0121 * p01 + w0121 * p21) / (w1012 * 2 + w0121 * 2)
      else
        pixels[ix, iy].y := p10;
      inc(iy, 2);
    end;
  end;

  // step 4: reinterpolate +0+0 pixels
  ix := 2;
  for i1 := 2 to width - 2 do begin
    iy := 2;
    for i2 := 2 to height - 2 do begin
      p00 := pixels[ix - 1, iy - 1].y;
      p02 := pixels[ix - 1, iy + 1].y;
      p20 := pixels[ix + 1, iy - 1].y;
      p22 := pixels[ix + 1, iy + 1].y;
      w0022 := (p00 - p22) / 255;
      w0022 := exp(- w0022 * w0022);
      w0220 := (p02 - p20) / 255;
      w0220 := exp(- w0220 * w0220);
      p10 := pixels[ix, iy - 1].y;
      p01 := pixels[ix - 1, iy].y;
      p21 := pixels[ix + 1, iy].y;
      p12 := pixels[ix, iy + 1].y;
      w1012 := (p10 - p12) / 255;
      w1012 := exp(- w1012 * w1012);
      w0121 := (p01 - p21) / 255;
      w0121 := exp(- w0121 * w0121);
      if (w0022 <> 0) or (w0220 <> 0) or (w1012 <> 0) or (w0121 <> 0) then
        pixels[ix, iy].y := (w0022 * p00 + w0022 * p22 + w0220 * p02 + w0220 * p20 + w1012 * p10 + w1012 * p12 + w0121 * p01 + w0121 * p21) / (w0022 * 2 + w0220 * 2 + w1012 * 2 + w0121 * 2)
      else
        pixels[ix, iy].y := p00;
      inc(iy, 2);
    end;
    inc(ix, 2);
  end;

  SetLength(D1, newWidth, newHeight);
  SetLength(D2, newWidth, newHeight);
  SetLength(D3, newWidth, newHeight);
  SetLength(C1, newWidth, newHeight);
  SetLength(C2, newWidth, newHeight);

  // iterative refinement
  for g := 0 to high(stepSizes) do begin
    diff := 0;
    step := stepSizes[g];

    // computation of derivatives
    for ix := 3 to newWidth - 4 do begin
      iy := 4 - (ix and 1);
      for i2 := 2 to height - 2 do begin
        C1[ix, iy] := (pixels[ix - 1, iy - 1].y - pixels[ix + 1, iy + 1].y) / 2;
        C2[ix, iy] := (pixels[ix + 1, iy - 1].y - pixels[ix - 1, iy + 1].y) / 2;
        D1[ix, iy] := pixels[ix - 1, iy - 1].y + pixels[ix + 1, iy + 1].y - 2 * pixels[ix, iy].y;
        D2[ix, iy] := pixels[ix + 1, iy - 1].y + pixels[ix - 1, iy + 1].y - 2 * pixels[ix, iy].y;
        D3[ix, iy] := (pixels[ix, iy - 2].y - pixels[ix - 2, iy].y + pixels[ix, iy + 2].y - pixels[ix + 2, iy].y) / 2;
        inc(iy, 2);
      end;
    end;

    ix := 5;
    for i1 := 3 to width - 3 do begin
      iy := 5;
      for i2 := 3 to height - 3 do begin
        EN1 := abs(D1[ix, iy] - D1[ix + 1, iy + 1]) + abs(D1[ix, iy] - D1[ix - 1, iy - 1]);
        EN2 := abs(D1[ix, iy] - D1[ix + 1, iy - 1]) + abs(D1[ix, iy] - D1[ix - 1, iy + 1]);
        EN3 := abs(D2[ix, iy] - D2[ix + 1, iy + 1]) + abs(D2[ix, iy] - D2[ix - 1, iy - 1]);
        EN4 := abs(D2[ix, iy] - D2[ix + 1, iy - 1]) + abs(D2[ix, iy] - D2[ix - 1, iy + 1]);
        EN5 := abs(pixels[ix - 2, iy - 2].y + pixels[ix + 2, iy + 2].y - 2 * pixels[ix, iy].y);
        EN6 := abs(pixels[ix + 2, iy - 2].y + pixels[ix - 2, iy + 2].y - 2 * pixels[ix, iy].y);

        EA1 := abs(D1[ix, iy] - D1[ix + 1, iy + 1] - 3 * step) + abs(D1[ix, iy] - D1[ix - 1, iy - 1] - 3 * step);
        EA2 := abs(D1[ix, iy] - D1[ix + 1, iy - 1] - 3 * step) + abs(D1[ix, iy] - D1[ix - 1, iy + 1] - 3 * step);
        EA3 := abs(D2[ix, iy] - D2[ix + 1, iy + 1] - 3 * step) + abs(D2[ix, iy] - D2[ix - 1, iy - 1] - 3 * step);
        EA4 := abs(D2[ix, iy] - D2[ix + 1, iy - 1] - 3 * step) + abs(D2[ix, iy] - D2[ix - 1, iy + 1] - 3 * step);
        EA5 := abs(pixels[ix - 2, iy - 2].y + pixels[ix + 2, iy + 2].y - 2 * pixels[ix, iy].y - 2 * step);
        EA6 := abs(pixels[ix + 2, iy - 2].y + pixels[ix - 2, iy + 2].y - 2 * pixels[ix, iy].y - 2 * step);

        ES1 := abs(D1[ix, iy] - D1[ix + 1, iy + 1] + 3 * step) + abs(D1[ix, iy] - D1[ix - 1, iy - 1] + 3 * step);
        ES2 := abs(D1[ix, iy] - D1[ix + 1, iy - 1] + 3 * step) + abs(D1[ix, iy] - D1[ix - 1, iy + 1] + 3 * step);
        ES3 := abs(D2[ix, iy] - D2[ix + 1, iy + 1] + 3 * step) + abs(D2[ix, iy] - D2[ix - 1, iy - 1] + 3 * step);
        ES4 := abs(D2[ix, iy] - D2[ix + 1, iy - 1] + 3 * step) + abs(D2[ix, iy] - D2[ix - 1, iy + 1] + 3 * step);
        ES5 := abs(pixels[ix - 2, iy - 2].y + pixels[ix + 2, iy + 2].y - 2 * pixels[ix, iy].y + 2 * step);
        ES6 := abs(pixels[ix + 2, iy - 2].y + pixels[ix - 2, iy + 2].y - 2 * pixels[ix, iy].y + 2 * step);

        if (C1[ix, iy] <> 0) or (C2[ix, iy] <> 0) then begin
          EISO := (C1[ix, iy] * C1[ix, iy] * D2[ix, iy] - 2 * C1[ix, iy] * C2[ix, iy] * D3[ix, iy] + C2[ix, iy] * C2[ix, iy] * D1[ix, iy]) / (C1[ix, iy] * C1[ix, iy] + C2[ix, iy] * C2[ix, iy]);
          if abs(EISO) < 0.2 then
            EISO := 0;
        end else
          EISO := 0;

        EN := (AL * (EN1 + EN2 + EN3 + EN4)) + (BT * (EN5 + EN6));
        EA := (AL * (EA1 + EA2 + EA3 + EA4)) + (BT * (EA5 + EA6)) - (GM * sign(EISO));
        ES := (AL * (ES1 + ES2 + ES3 + ES4)) + (BT * (ES5 + ES6)) + (GM * sign(EISO));

        if (EN > EA) and (ES > EA) then begin
          if pixels[ix, iy].y + step > 255 then
            pixels[ix, iy].y := 255
          else
            pixels[ix, iy].y := pixels[ix, iy].y + step;

          maxValue := pixels[ix - 1, iy - 1].y;
          testValue := pixels[ix - 1, iy + 1].y;
          if testValue > maxValue then maxValue := testValue;
          testValue := pixels[ix + 1, iy + 1].y;
          if testValue > maxValue then maxValue := testValue;
          testValue := pixels[ix + 1, iy - 1].y;
          if testValue > maxValue then maxValue := testValue;
          if pixels[ix, iy].y > maxValue then
            pixels[ix, iy].y := maxValue;

          diff := diff + step;
        end else
          if (EN > ES) and (EA > ES) then begin
            if pixels[ix, iy].y <= step then
              pixels[ix, iy].y := 0
            else
              pixels[ix, iy].y := pixels[ix, iy].y - step;

            maxValue := pixels[ix - 1, iy - 1].y;
            testValue := pixels[ix - 1, iy + 1].y;
            if testValue < maxValue then maxValue := testValue;
            testValue := pixels[ix + 1, iy + 1].y;
            if testValue < maxValue then maxValue := testValue;
            testValue := pixels[ix + 1, iy - 1].y;
            if testValue < maxValue then maxValue := testValue;
            if pixels[ix, iy].y < maxValue then
              pixels[ix, iy].y := maxValue;

            diff := diff + step;
          end;

        inc(iy, 2);
      end;
      inc(ix, 2);
    end;

    if diff < TS then
      break;
  end;

  // iterative refinement
  for g := 0 to high(stepSizes) do begin
    diff := 0;
    step := stepSizes[g];

    // computation of derivatives
    for ix := 1 to newWidth - 3 do
      for iy := 1 to newHeight - 3 do begin
        C1[ix, iy] := (pixels[ix, iy - 1].y - pixels[ix, iy + 1].y) / 2;
        C2[ix, iy] := (pixels[ix - 1, iy].y - pixels[ix + 1, iy].y) / 2;
        D1[ix, iy] := pixels[ix, iy - 1].y + pixels[ix, iy + 1].y - 2 * pixels[ix, iy].y;
        D2[ix, iy] := pixels[ix + 1, iy].y + pixels[ix - 1, iy].y - 2 * pixels[ix, iy].y;
        D3[ix, iy] := (pixels[ix - 1, iy - 1].y - pixels[ix - 1, iy + 1].y + pixels[ix + 1, iy + 1].y - pixels[ix + 1, iy - 1].y) / 2;
      end;

    for ix := 2 to newWidth - 3 do begin
      iy := 3 - (ix and 1);
      for i2 := 1 to height - 2 do begin
        EN1 := abs(D1[ix, iy] - D1[ix, iy + 1]) + abs(D1[ix, iy] - D1[ix, iy - 1]);
        EN2 := abs(D1[ix, iy] - D1[ix + 1, iy]) + abs(D1[ix, iy] - D1[ix - 1, iy]);
        EN3 := abs(D2[ix, iy] - D2[ix, iy + 1]) + abs(D2[ix, iy] - D2[ix, iy - 1]);
        EN4 := abs(D2[ix, iy] - D2[ix + 1, iy]) + abs(D2[ix, iy] - D2[ix - 1, iy]);
        EN5 := abs(pixels[ix, iy - 2].y + pixels[ix, iy + 2].y - 2 * pixels[ix, iy].y);
        EN6 := abs(pixels[ix + 2, iy].y + pixels[ix - 2, iy].y - 2 * pixels[ix, iy].y);

        EA1 := abs(D1[ix, iy] - D1[ix, iy + 1] - 3 * step) + abs(D1[ix, iy] - D1[ix, iy - 1] - 3 * step);
        EA2 := abs(D1[ix, iy] - D1[ix + 1, iy] - 3 * step) + abs(D1[ix, iy] - D1[ix - 1, iy] - 3 * step);
        EA3 := abs(D2[ix, iy] - D2[ix, iy + 1] - 3 * step) + abs(D2[ix, iy] - D2[ix, iy - 1] - 3 * step);
        EA4 := abs(D2[ix, iy] - D2[ix + 1, iy] - 3 * step) + abs(D2[ix, iy] - D2[ix - 1, iy] - 3 * step);
        EA5 := abs(pixels[ix, iy - 2].y + pixels[ix, iy + 2].y - 2 * pixels[ix, iy].y - 2 * step);
        EA6 := abs(pixels[ix + 2, iy].y + pixels[ix - 2, iy].y - 2 * pixels[ix, iy].y - 2 * step);

        ES1 := abs(D1[ix, iy] - D1[ix, iy + 1] + 3 * step) + abs(D1[ix, iy] - D1[ix, iy - 1] + 3 * step);
        ES2 := abs(D1[ix, iy] - D1[ix + 1, iy] + 3 * step) + abs(D1[ix, iy] - D1[ix - 1, iy] + 3 * step);
        ES3 := abs(D2[ix, iy] - D2[ix, iy + 1] + 3 * step) + abs(D2[ix, iy] - D2[ix, iy - 1] + 3 * step);
        ES4 := abs(D2[ix, iy] - D2[ix + 1, iy] + 3 * step) + abs(D2[ix, iy] - D2[ix - 1, iy] + 3 * step);
        ES5 := abs(pixels[ix, iy - 2].y + pixels[ix, iy + 2].y - 2 * pixels[ix, iy].y + 2 * step);
        ES6 := abs(pixels[ix + 2, iy].y + pixels[ix - 2, iy].y - 2 * pixels[ix, iy].y + 2 * step);

        if (C1[ix, iy] <> 0) or (C2[ix, iy] <> 0) then begin
          EISO := (C1[ix, iy] * C1[ix, iy] * D2[ix, iy] - 2 * C1[ix, iy] * C2[ix, iy] * D3[ix, iy] + C2[ix, iy] * C2[ix, iy] * D1[ix, iy]) / (C1[ix, iy] * C1[ix, iy] + C2[ix, iy] * C2[ix, iy]);
          if abs(EISO) < 0.2 then
            EISO := 0;
        end else
          EISO := 0;

        EN := (AL * (EN1 + EN2 + EN3 + EN4)) + (BT * (EN5 + EN6));
        EA := (AL * (EA1 + EA2 + EA3 + EA4)) + (BT * (EA5 + EA6)) - (GM * sign(EISO));
        ES := (AL * (ES1 + ES2 + ES3 + ES4)) + (BT * (ES5 + ES6)) + (GM * sign(EISO));

        if (EN > EA) and (ES > EA) then begin
          if pixels[ix, iy].y + step > 255 then
            pixels[ix, iy].y := 255
          else
            pixels[ix, iy].y := pixels[ix, iy].y + step;

          maxValue := pixels[ix, iy - 1].y;
          testValue := pixels[ix - 1, iy].y;
          if testValue > maxValue then maxValue := testValue;
          testValue := pixels[ix, iy + 1].y;
          if testValue > maxValue then maxValue := testValue;
          testValue := pixels[ix + 1, iy].y;
          if testValue > maxValue then maxValue := testValue;
          if pixels[ix, iy].y > maxValue then
            pixels[ix, iy].y := maxValue;

          diff := diff + step;
        end else
          if (EN > ES) and (EA > ES) then begin
            if pixels[ix, iy].y <= step then
              pixels[ix, iy].y := 0
            else
              pixels[ix, iy].y := pixels[ix, iy].y - step;

            maxValue := pixels[ix, iy - 1].y;
            testValue := pixels[ix - 1, iy].y;
            if testValue < maxValue then maxValue := testValue;
            testValue := pixels[ix, iy + 1].y;
            if testValue < maxValue then maxValue := testValue;
            testValue := pixels[ix + 1, iy].y;
            if testValue < maxValue then maxValue := testValue;
            if pixels[ix, iy].y < maxValue then
              pixels[ix, iy].y := maxValue;

            diff := diff + step;
          end;

        inc(iy, 2);
      end;
    end;

    if diff < TS then
      break;
  end;

  for ix := 0 to newWidth - 1 do
    for iy := 0 to newHeight - 1 do
      dst[iy * newWidth + ix] := pixels[ix, iy];
end;

procedure ICBI(bmp: TBitmap; steps: integer);
// 8
// 6, 10
// 3, 6, 10
var src : array of TYCbCr;
    dst : array of TYCbCr;
    i1, i2 : integer;
    pixel : integer;
    red, green, blue : integer;
    y, cb, cr : single;
begin
  SetLength(src, bmp.Width * bmp.Height);
  SetLength(dst, bmp.Width * 2 * bmp.Height * 2);
  for i1 := 0 to bmp.Width - 1 do
    for i2 := 0 to bmp.Height - 1 do begin
      pixel := bmp.Canvas.Pixels[i1, i2];
      red := pixel and $ff;
      green := (pixel shr 8) and $ff;
      blue := (pixel shr 16) and $ff;
      y := red * 0.299 + green * 0.587 + blue * 0.114;
      cb := $80 + red * -0.1687358916478555 + green * -0.3312641083521445 + blue * 0.5;
      cr := $80 + red * 0.5 + green * -0.4186875891583452 + blue * -0.0813124108416548;
      if y < 0 then
        y := 0
      else
        if y > 255 then
          y := 255;
      if cb < 0 then
        cb := 0
      else
        if cb > 255 then
          cb := 255;
      if cr < 0 then
        cr := 0
      else
        if cr >= 255 then
          cr := 255;
      src[i2 * bmp.Width + i1].y := y;
      src[i2 * bmp.Width + i1].cb := cb;
      src[i2 * bmp.Width + i1].cr := cr;
    end;
  case steps of
    0 :  ICBI1Plane(@src[0], @dst[0], bmp.Width, bmp.Height, [],         0.5625, -0.0625);
    1 :  ICBI1Plane(@src[0], @dst[0], bmp.Width, bmp.Height, [8],        0.5625, -0.0625);
    2 :  ICBI1Plane(@src[0], @dst[0], bmp.Width, bmp.Height, [6, 10],    0.5625, -0.0625);
    3 :  ICBI1Plane(@src[0], @dst[0], bmp.Width, bmp.Height, [3, 6, 10], 0.5625, -0.0625);
    else ICBI1Plane(@src[0], @dst[0], bmp.Width, bmp.Height, [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 6, 6, 6, 6, 10, 10, 10, 10], 0.5625, -0.0625);
  end;
  bmp.Width := bmp.Width * 2 - 1;
  bmp.Height := bmp.Height * 2 - 1;
  for i1 := 0 to bmp.Width - 1 do
    for i2 := 0 to bmp.Height - 1 do begin
      y := dst[i2 * bmp.Width + i1].y;
      cb := dst[i2 * bmp.Width + i1].cb - $80;
      cr := dst[i2 * bmp.Width + i1].cr - $80;
      red := round(y + cr * 1.402);
      green := round(y + cb * -0.3441362862010221 + cr * -0.7141362862010221);
      blue := round(y + cb * 1.772);
      if red < 0 then
        red := 0
      else
        if red > 255 then
          red := 255;
      if green < 0 then
        green := 0
      else
        if green > 255 then
          green := 255;
      if blue < 0 then
        blue := 0
      else
        if blue > 255 then
          blue := 255;
      bmp.Canvas.Pixels[i1, i2] := blue shl 16 + green shl 8 + red;
    end;
end;

procedure NewOne(bmp: TBitmap; const stepSizes: array of integer);
var src, dst : array of TYCbCr;
    srcY, dstY : array of byte;
    i1, i2 : integer;
    pixel : integer;
    red, green, blue : integer;
    y, cb, cr : single;
begin
  SetLength(src, bmp.Width * bmp.Height);
  SetLength(dst, bmp.Width * 2 * bmp.Height * 2);
  SetLength(srcY, bmp.Width * bmp.Height);
  SetLength(dstY, bmp.Width * 2 * bmp.Height * 2);
  for i1 := 0 to bmp.Width - 1 do
    for i2 := 0 to bmp.Height - 1 do begin
      pixel := bmp.Canvas.Pixels[i1, i2];
      red := pixel and $ff;
      green := (pixel shr 8) and $ff;
      blue := (pixel shr 16) and $ff;
      y := red * 0.299 + green * 0.587 + blue * 0.114;
      cb := $80 + red * -0.1687358916478555 + green * -0.3312641083521445 + blue * 0.5;
      cr := $80 + red * 0.5 + green * -0.4186875891583452 + blue * -0.0813124108416548;
      if y < 0 then
        y := 0
      else
        if y > 255 then
          y := 255;
      if cb < 0 then
        cb := 0
      else
        if cb > 255 then
          cb := 255;
      if cr < 0 then
        cr := 0
      else
        if cr >= 255 then
          cr := 255;
      src[i2 * bmp.Width + i1].y := y;
      src[i2 * bmp.Width + i1].cb := cb;
      src[i2 * bmp.Width + i1].cr := cr;
      srcY[i2 * bmp.Width + i1] := round(y);
    end;

  PRPlane(@src[0], @dst[0], bmp.Width, bmp.Height, stepSizes);

  bmp.Width := bmp.Width * 2 - 1;
  bmp.Height := bmp.Height * 2 - 1;
  for i1 := 0 to bmp.Width - 1 do
    for i2 := 0 to bmp.Height - 1 do begin
      y := dst[i2 * bmp.Width + i1].y;
      if y < 0 then
        y := 0;
      cb := src[i2 div 2 * ((bmp.Width + 1) div 2) + i1 div 2].cb - $80;
      cr := src[i2 div 2 * ((bmp.Width + 1) div 2) + i1 div 2].cr - $80;
      red := round(y + cr * 1.402);
      green := round(y + cb * -0.3441362862010221 + cr * -0.7141362862010221);
      blue := round(y + cb * 1.772);
      if red < 0 then
        red := 0
      else
        if red > 255 then
          red := 255;
      if green < 0 then
        green := 0
      else
        if green > 255 then
          green := 255;
      if blue < 0 then
        blue := 0
      else
        if blue > 255 then
          blue := 255;
      bmp.Canvas.Pixels[i1, i2] := blue shl 16 + green shl 8 + red;
    end;
end;

(*                                            
//var rf : TResamplingFilter;
var bmp1 : TBitmap;
    i1   : integer;
initialization
  bmp1 := TBitmap.Create;
  bmp1.LoadFromFile('c:\desktop\resampling\org.bmp');

  for i1 := 1 to 1 do
    ICBI(bmp1, 3);
//    NewOne(bmp1, [8]);

  bmp1.SaveToFile('c:\desktop\resampling\zzz.bmp');
  ExitProcess(0);  

(*  bmp1 := TBitmap.Create;
  for rf := low(TResamplingFilter) to high(TResamplingFilter) do begin
    bmp1.LoadFromFile('c:\desktop\resampling\org.bmp');
    StretchBitmap_(bmp1, nil, bmp1.Width + 1, bmp1.Height + 1, sqVeryHigh, rf);
    StretchBitmap_(bmp1, nil, bmp1.Width - 1, bmp1.Height - 1, sqVeryHigh, rf);
    bmp1.SaveToFile('c:\desktop\resampling\' + CResamplingFilterNames[rf] + '.bmp');
  end;

  ExitProcess(0); *)
end.
