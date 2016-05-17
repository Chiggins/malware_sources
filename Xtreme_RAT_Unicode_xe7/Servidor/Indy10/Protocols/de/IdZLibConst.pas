
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
  sTargetBufferTooSmall = 'Zlib-Fehler: Zielpuffer könnte zu klein sein';
  sInvalidStreamOp = 'Ungültige Stream-Operation';

  sZLibError = 'ZLib-Fehler (%d)';

  {$IFNDEF STATICLOAD_ZLIB}
  RSZLibCallError = 'Fehler beim Aufruf der ZLib-Bibliotheksfunktion %s';
  {$ENDIF}

implementation

end.
 
