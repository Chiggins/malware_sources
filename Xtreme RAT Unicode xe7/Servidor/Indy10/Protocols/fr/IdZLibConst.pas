
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
  sTargetBufferTooSmall = 'Erreur ZLib : le tampon de destination est peut-être trop petit';
  sInvalidStreamOp = 'Opération flux incorrecte';

  sZLibError = 'Erreur ZLib (%d)';

  {$IFNDEF STATICLOAD_ZLIB}
  RSZLibCallError = 'Erreur d'#39'appel de la fonction %s de la bibliothèque ZLib';
  {$ENDIF}

implementation

end.
 
