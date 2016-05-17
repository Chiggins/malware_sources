{ Arisesoft Include File.

  File: AS_Ver.inc
  Vers: 3.0
  Date: 2001-11-05

  This file is used for all our components to create some standard defines.
  This will help reduce headaches when new versions of Delphi and C++Builder
  are released, among other things. }

{x$S+,W+,R+}  { it's only for debugging }

{ Determine Delphi/C++Builder version }
{$IFNDEF WIN32} Delphi 1 is not supported. {$ENDIF}
{$IFNDEF VER90}  { if it's not Delphi 2.0 }
  {$IFNDEF VER93}  { and it's not C++Builder 1.0 }
    {$DEFINE AS_VCL3}  { then it must be at least Delphi 3 or C++Builder 3 }
    {$IFNDEF VER100}  { if it's not Delphi 3.0 }
      {$DEFINE AS_VCL35} { then it must be at least Delphi 4 or C++Builder 3 }
      {$IFNDEF VER110}  { and it's not C++Builder 3.0 }
        {$DEFINE AS_VCL4}  { then it must be at least Delphi 4 or C++Builder 4 }
        {$IFNDEF VER120}  { if it's not Delphi 4.0 }
          {$DEFINE AS_VCL5}  { then it must be at least Delphi 5 }
          {$IFNDEF VER130}  { and it's not not Delphi 5.0 }
            {$DEFINE AS_VCL6}  { then it must be at least Delphi 6 }
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
      {$IFNDEF VER120}  { if it's not Delphi 4.0 }
        { Delphi 4's command line compiler doesn't like the ObjExportAll
          directive, so don't include it on Delphi 4 }
        {$ObjExportAll On}
          { ^ needed for compatibility with run-time packages in C++Builder 3 }
      {$ENDIF}
    {$ENDIF}
  {$ELSE}
    C++Builder 1 is not supported.
  {$ENDIF}
{$ELSE}
  Delphi 2 is not supported.
{$ENDIF}


{$A+}  {$ALIGN ON}
{ this directive controls alignment of fields in record types }

{$B-}  { $BOOLEVAL OFF }
{ the compiler generates code for short-circuit Boolean expression evaluation,
  which means that evaluation stops as soon as the result of the entire
  expression becomes evident in left to right order of evaluation }

{$H+}  { $LONGSTRINGS ON }
  { the generic type string represent dynamically-allocated string
    (the fundamental type AnsiString) }

{$P+}  { $OPENSTRINGS ON }
{ variable parameters declared using the string keyword are open string
  parameters }

{$J+}  { $WRITEABLECONST ON }
{ typed constants can be modified, and are in essence initialized variables }

{$T-}  { $TYPEDADDRESS OFF }
{ the result of the @ operator is always an untyped pointer (Pointer) that is
  compatible with all other pointer types }

{$X+}  { $EXTENDEDSYNTAX ON }
{ always extended syntax }

