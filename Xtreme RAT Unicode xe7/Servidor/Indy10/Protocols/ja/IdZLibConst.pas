
{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{  Copyright (c) 1997-1999 Borland Software Corporation }
{                                                       }
{*******************************************************}

unit IdZLibConst;

interface

{$I IdCompilerDefines.inc}

{$UNDEF STATICLOAD_ZLIB}
{$IFNDEF FPC}
  {$IFDEF WINDOWS}
    {$IFNDEF BCB5_DUMMY_BUILD}
      {$DEFINE STATICLOAD_ZLIB}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFNDEF STATICLOAD_ZLIB}
uses
  IdException;
{$ENDIF}

resourcestring
  sTargetBufferTooSmall = 'ZLib エラー : ターゲットバッファが足りません。';
  sInvalidStreamOp = 'ストリーム操作が無効です';

  sZLibError = 'ZLib エラー (%d)';

  {$IFNDEF STATICLOAD_ZLIB}
  RSZLibCallError = 'ZLib ライブラリ関数 %s の呼び出しでエラーが発生しました';
  {$ENDIF}

implementation

end.
 
