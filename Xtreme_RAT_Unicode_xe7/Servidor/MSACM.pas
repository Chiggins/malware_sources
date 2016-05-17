{******************************************************************}
{                                                       	   }
{       Borland Delphi Runtime Library                  	   }
{       Microsoft Audio Compression Manager interface unit         }
{ 								   }
{ Portions created by Microsoft are 				   }
{ Copyright (C) 1995-1999 Microsoft Corporation. 		   }
{ All Rights Reserved. 						   }
{ 								   }
{ The original file is: msacm.h, released 9 March 1999.            }
{ The original Pascal code is: MSAcm.pas, released 21 July 1999.   }
{ The initial developer of the Pascal code is Francois Piette      }
{ francois.piette@swing.be, http://www.rtfm.be/fpiette/indexuk.htm }
{ rue de Grady 24, 4053 Embourg, Belgium                           }
{ 								   }
{ Portions created by Francois Piette are			   }
{ Copyright (C) 1999 Francois Piette.    		           }
{ 								   }
{ Contributor(s): Marcel van Brakel (brakelm@bart.nl)              }
{ 								   }
{ Obtained through:                               	           }
{ Joint Endeavour of Delphi Innovators (Project JEDI)              }
{								   }
{ You may retrieve the latest version of this file at the Project  }
{ JEDI home page, located at http://delphi-jedi.org                }
{								   }
{ The contents of this file are used with permission, subject to   }
{ the Mozilla Public License Version 1.1 (the "License"); you may  }
{ not use this file except in compliance with the License. You may }
{ obtain a copy of the License at                                  }
{ http://www.mozilla.org/NPL/NPL-1_1Final.html 	                   }
{                                                                  }
{ Software distributed under the License is distributed on an 	   }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   }
{ implied. See the License for the specific language governing     }
{ rights and limitations under the License. 			   }
{ 								   }
{******************************************************************}

unit MSAcm;

interface

{$HPPEMIT ''}
{$HPPEMIT '#include "MSAcm.h"'}
{$HPPEMIT ''}

uses
  Windows, MMSystem;

type
  PWaveFilter = ^TWaveFilter;
  // Defined in mmreg.h
  WAVEFILTER = packed record
    cbStruct: DWORD;                    // Size of the filter in bytes
    dwFilterTag: DWORD;                 // filter type
    fdwFilter: DWORD;                   // Flags for the filter (Universal Dfns)
    dwReserved: array [0..4] of DWORD;  // Reserved for system use
  end;
  TWaveFilter = WAVEFILTER;

const
  DRV_MAPPER_PREFERRED_INPUT_GET  = DRV_USER + 0;
  {$EXTERNALSYM DRV_MAPPER_PREFERRED_INPUT_GET}
  DRV_MAPPER_PREFERRED_OUTPUT_GET = DRV_USER + 2;
  {$EXTERNALSYM DRV_MAPPER_PREFERRED_OUTPUT_GET}
  DRVM_MAPPER_STATUS              = $2000;
  {$EXTERNALSYM DRVM_MAPPER_STATUS}
  WIDM_MAPPER_STATUS              = DRVM_MAPPER_STATUS + 0;
  {$EXTERNALSYM WIDM_MAPPER_STATUS}
  WAVEIN_MAPPER_STATUS_DEVICE     = 0;
  {$EXTERNALSYM WAVEIN_MAPPER_STATUS_DEVICE}
  WAVEIN_MAPPER_STATUS_MAPPED     = 1;
  {$EXTERNALSYM WAVEIN_MAPPER_STATUS_MAPPED}
  WAVEIN_MAPPER_STATUS_FORMAT     = 2;
  {$EXTERNALSYM WAVEIN_MAPPER_STATUS_FORMAT}
  WODM_MAPPER_STATUS              = DRVM_MAPPER_STATUS + 0;
  {$EXTERNALSYM WODM_MAPPER_STATUS}
  WAVEOUT_MAPPER_STATUS_DEVICE    = 0;
  {$EXTERNALSYM WAVEOUT_MAPPER_STATUS_DEVICE}
  WAVEOUT_MAPPER_STATUS_MAPPED    = 1;
  {$EXTERNALSYM WAVEOUT_MAPPER_STATUS_MAPPED}
  WAVEOUT_MAPPER_STATUS_FORMAT    = 2;
  {$EXTERNALSYM WAVEOUT_MAPPER_STATUS_FORMAT}

//--------------------------------------------------------------------------
//
//  ACM General API's and Defines
//
//--------------------------------------------------------------------------

//  there are four types of 'handles' used by the ACM. the first three
//  are unique types that define specific objects:
//
//  HACMDRIVERID: used to _identify_ an ACM driver. this identifier can be
//  used to _open_ the driver for querying details, etc about the driver.
//
//  HACMDRIVER: used to manage a driver (codec, filter, etc). this handle
//  is much like a handle to other media drivers--you use it to send
//  messages to the converter, query for capabilities, etc.
//
//  HACMSTREAM: used to manage a 'stream' (conversion channel) with the
//  ACM. you use a stream handle to convert data from one format/type
//  to another--much like dealing with a file handle.
//
//
//  the fourth handle type is a generic type used on ACM functions that
//  can accept two or more of the above handle types (for example the
//  acmMetrics and acmDriverID functions).
//
//  HACMOBJ: used to identify ACM objects. this handle is used on functions
//  that can accept two or more ACM handle types.

type
  HACMDRIVERID__ = record
    Unused: Integer;
  end;
  {$EXTERNALSYM HACMDRIVERID__}
  HACMDRIVERID = ^HACMDRIVERID__;
  {$EXTERNALSYM HACMDRIVERID}
  PHACMDRIVERID = ^HACMDRIVERID;
  {$EXTERNALSYM PHACMDRIVERID}
  LPHACMDRIVERID = ^HACMDRIVERID;
  {$EXTERNALSYM LPHACMDRIVERID}

  HACMDRIVER__ = record
    Unused: Integer;
  end;
  {$EXTERNALSYM HACMDRIVER__}
  HACMDRIVER = ^HACMDRIVER__;
  {$EXTERNALSYM HACMDRIVER}
  PHACMDRIVER = ^HACMDRIVER;
  {$EXTERNALSYM PHACMDRIVER}
  LPHACMDRIVER = ^HACMDRIVER;
  {$EXTERNALSYM LPHACMDRIVER}

  HACMSTREAM__ = record
    Unused: Integer;
  end;
  {$EXTERNALSYM HACMSTREAM__}
  HACMSTREAM = ^HACMSTREAM__;
  {$EXTERNALSYM HACMSTREAM}
  PHACMSTREAM = ^HACMSTREAM;
  {$EXTERNALSYM PHACMSTREAM}
  LPHACMSTREAM = ^HACMSTREAM;
  {$EXTERNALSYM LPHACMSTREAM}

  HACMOBJ__ = record
    Unused: Integer;
  end;
  {$EXTERNALSYM HACMOBJ__}
  HACMOBJ = ^HACMOBJ__;
  {$EXTERNALSYM HACMOBJ}
  PHACMOBJ = ^HACMOBJ;
  {$EXTERNALSYM PHACMOBJ}
  LPHACMOBJ = ^HACMOBJ;
  {$EXTERNALSYM LPHACMOBJ}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//  ACM Error Codes
//
//  Note that these error codes are specific errors that apply to the ACM
//  directly--general errors are defined as MMSYSERR_*.
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

type
  MMRESULT = UINT;
  {$EXTERNALSYM MMRESULT}

const
  ACMERR_BASE        = 512;
  {$EXTERNALSYM ACMERR_BASE}
  ACMERR_NOTPOSSIBLE = (ACMERR_BASE + 0);
  {$EXTERNALSYM ACMERR_NOTPOSSIBLE}
  ACMERR_BUSY        = (ACMERR_BASE + 1);
  {$EXTERNALSYM ACMERR_BUSY}
  ACMERR_UNPREPARED  = (ACMERR_BASE + 2);
  {$EXTERNALSYM ACMERR_UNPREPARED}
  ACMERR_CANCELED    = (ACMERR_BASE + 3);
  {$EXTERNALSYM ACMERR_CANCELED}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//  ACM Window Messages
//
//  These window messages are sent by the ACM or ACM drivers to notify
//  applications of events.
//
//  Note that these window message numbers will also be defined in
//  mmsystem.
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const
  MM_ACM_OPEN  = MM_STREAM_OPEN;     // conversion callback messages
  {$EXTERNALSYM MM_ACM_OPEN}
  MM_ACM_CLOSE = MM_STREAM_CLOSE;
  {$EXTERNALSYM MM_ACM_CLOSE}
  MM_ACM_DONE  = MM_STREAM_DONE;
  {$EXTERNALSYM MM_ACM_DONE}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//  acmGetVersion()
//
//  the ACM version is a 32 bit number that is broken into three parts as
//  follows:
//
//      bits 24 - 31:   8 bit _major_ version number
//      bits 16 - 23:   8 bit _minor_ version number
//      bits  0 - 15:   16 bit build number
//
//  this is then displayed as follows:
//
//      bMajor = (BYTE)(dwVersion >> 24)
//      bMinor = (BYTE)(dwVersion >> 16) &
//      wBuild = LOWORD(dwVersion)
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function acmGetVersion: DWORD; stdcall;
{$EXTERNALSYM acmGetVersion}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmMetrics()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmMetrics(hao: HACMOBJ; uMetric: UINT; var pMetric): MMRESULT; stdcall;
{$EXTERNALSYM acmMetrics}

const
  ACM_METRIC_COUNT_DRIVERS          = 1;
  {$EXTERNALSYM ACM_METRIC_COUNT_DRIVERS}
  ACM_METRIC_COUNT_CODECS           = 2;
  {$EXTERNALSYM ACM_METRIC_COUNT_CODECS}
  ACM_METRIC_COUNT_CONVERTERS       = 3;
  {$EXTERNALSYM ACM_METRIC_COUNT_CONVERTERS}
  ACM_METRIC_COUNT_FILTERS          = 4;
  {$EXTERNALSYM ACM_METRIC_COUNT_FILTERS}
  ACM_METRIC_COUNT_DISABLED         = 5;
  {$EXTERNALSYM ACM_METRIC_COUNT_DISABLED}
  ACM_METRIC_COUNT_HARDWARE         = 6;
  {$EXTERNALSYM ACM_METRIC_COUNT_HARDWARE}
  ACM_METRIC_COUNT_LOCAL_DRIVERS    = 20;
  {$EXTERNALSYM ACM_METRIC_COUNT_LOCAL_DRIVERS}
  ACM_METRIC_COUNT_LOCAL_CODECS     = 21;
  {$EXTERNALSYM ACM_METRIC_COUNT_LOCAL_CODECS}
  ACM_METRIC_COUNT_LOCAL_CONVERTERS = 22;
  {$EXTERNALSYM ACM_METRIC_COUNT_LOCAL_CONVERTERS}
  ACM_METRIC_COUNT_LOCAL_FILTERS    = 23;
  {$EXTERNALSYM ACM_METRIC_COUNT_LOCAL_FILTERS}
  ACM_METRIC_COUNT_LOCAL_DISABLED   = 24;
  {$EXTERNALSYM ACM_METRIC_COUNT_LOCAL_DISABLED}
  ACM_METRIC_HARDWARE_WAVE_INPUT    = 30;
  {$EXTERNALSYM ACM_METRIC_HARDWARE_WAVE_INPUT}
  ACM_METRIC_HARDWARE_WAVE_OUTPUT   = 31;
  {$EXTERNALSYM ACM_METRIC_HARDWARE_WAVE_OUTPUT}
  ACM_METRIC_MAX_SIZE_FORMAT        = 50;
  {$EXTERNALSYM ACM_METRIC_MAX_SIZE_FORMAT}
  ACM_METRIC_MAX_SIZE_FILTER        = 51;
  {$EXTERNALSYM ACM_METRIC_MAX_SIZE_FILTER}
  ACM_METRIC_DRIVER_SUPPORT         = 100;
  {$EXTERNALSYM ACM_METRIC_DRIVER_SUPPORT}
  ACM_METRIC_DRIVER_PRIORITY        = 101;
  {$EXTERNALSYM ACM_METRIC_DRIVER_PRIORITY}

//--------------------------------------------------------------------------;
//
//  ACM Drivers
//
//--------------------------------------------------------------------------;

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmDriverEnum()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

type
  ACMDRIVERENUMCB = function (hadif: HACMDRIVERID; dwInstance, fdwSupport: DWORD): BOOL; stdcall;
  {$EXTERNALSYM ACMDRIVERENUMCB}

function acmDriverEnum(fnCallback: ACMDRIVERENUMCB; dwInstance: DWORD;
  fdwEnum: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmDriverEnum}

const
  ACM_DRIVERENUMF_NOLOCAL  = $40000000;
  {$EXTERNALSYM ACM_DRIVERENUMF_NOLOCAL}
  ACM_DRIVERENUMF_DISABLED = $80000000;
  {$EXTERNALSYM ACM_DRIVERENUMF_DISABLED}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmDriverID()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmDriverID(hao: HACMOBJ; var phadid: HACMDRIVERID; fdwDriverID: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmDriverID}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmDriverAdd()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmDriverAddA(var phadid: HACMDRIVERID; hinstModule: HINST; Param: LPARAM;
  dwPriority: DWORD; fdwAdd: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmDriverAddA}
function acmDriverAddW(var phadid: HACMDRIVERID; hinstModule: HINST; Param: LPARAM;
  dwPriority: DWORD; fdwAdd: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmDriverAddW}
function acmDriverAdd(var phadid: HACMDRIVERID; hinstModule: HINST; Param: LPARAM;
  dwPriority: DWORD; fdwAdd: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmDriverAdd}

const
  ACM_DRIVERADDF_FUNCTION   = $00000003; // lParam is a procedure
  {$EXTERNALSYM ACM_DRIVERADDF_FUNCTION}
  ACM_DRIVERADDF_NOTIFYHWND = $00000004; // lParam is notify hwnd
  {$EXTERNALSYM ACM_DRIVERADDF_NOTIFYHWND}
  ACM_DRIVERADDF_TYPEMASK   = $00000007; // driver type mask
  {$EXTERNALSYM ACM_DRIVERADDF_TYPEMASK}
  ACM_DRIVERADDF_LOCAL      = $00000000; // is local to current task
  {$EXTERNALSYM ACM_DRIVERADDF_LOCAL}
  ACM_DRIVERADDF_GLOBAL     = $00000008; // is global
  {$EXTERNALSYM ACM_DRIVERADDF_GLOBAL}

//
//  prototype for ACM driver procedures that are installed as _functions_
//  or _notifations_ instead of as a standalone installable driver.
//
type
  ACMDRIVERPROC = function (dwID: DWORD; hdrvr: HACMDRIVERID; uMsg: UINT;
    lParam1: LPARAM; lParam2: LPARAM) : LRESULT; stdcall;
  {$EXTERNALSYM ACMDRIVERPROC}
  LPACMDRIVERPROC = ^ACMDRIVERPROC;
  {$EXTERNALSYM LPACMDRIVERPROC}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmDriverRemove()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmDriverRemove(hadid: HACMDRIVERID; fdwRemove: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmDriverRemove}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmDriverOpen()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmDriverOpen(var phad: HACMDRIVER; hadid: HACMDRIVERID; fdwOpen: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmDriverOpen}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmDriverClose()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmDriverClose(had: HACMDRIVER; fdwClose: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmDriverClose}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmDriverMessage()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmDriverMessage(had: HACMDRIVER; uMsg: UINT; Param1, Param2: LPARAM): LRESULT; stdcall;
{$EXTERNALSYM acmDriverMessage}

const
  ACMDM_USER          = DRV_USER + $0000;
  {$EXTERNALSYM ACMDM_USER}
  ACMDM_RESERVED_LOW  = DRV_USER + $2000;
  {$EXTERNALSYM ACMDM_RESERVED_LOW}
  ACMDM_RESERVED_HIGH = DRV_USER + $2FFF;
  {$EXTERNALSYM ACMDM_RESERVED_HIGH}

  ACMDM_BASE          = ACMDM_RESERVED_LOW;
  {$EXTERNALSYM ACMDM_BASE}

  ACMDM_DRIVER_ABOUT  = ACMDM_BASE + 11;
  {$EXTERNALSYM ACMDM_DRIVER_ABOUT}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmDriverPriority
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmDriverPriority(hadid: HACMDRIVERID; dwPriority, fdwPriority: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmDriverPriority}

const
  ACM_DRIVERPRIORITYF_ENABLE    = $00000001;
  {$EXTERNALSYM ACM_DRIVERPRIORITYF_ENABLE}
  ACM_DRIVERPRIORITYF_DISABLE   = $00000002;
  {$EXTERNALSYM ACM_DRIVERPRIORITYF_DISABLE}
  ACM_DRIVERPRIORITYF_ABLEMASK  = $00000003;
  {$EXTERNALSYM ACM_DRIVERPRIORITYF_ABLEMASK}
  ACM_DRIVERPRIORITYF_BEGIN     = $00010000;
  {$EXTERNALSYM ACM_DRIVERPRIORITYF_BEGIN}
  ACM_DRIVERPRIORITYF_END       = $00020000;
  {$EXTERNALSYM ACM_DRIVERPRIORITYF_END}
  ACM_DRIVERPRIORITYF_DEFERMASK = $00030000;
  {$EXTERNALSYM ACM_DRIVERPRIORITYF_DEFERMASK}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmDriverDetails()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

//
//  ACMDRIVERDETAILS
//
//  the ACMDRIVERDETAILS structure is used to get various capabilities from
//  an ACM driver (codec, converter, filter).
//

const
  ACMDRIVERDETAILS_SHORTNAME_CHARS = 32;
  {$EXTERNALSYM ACMDRIVERDETAILS_SHORTNAME_CHARS}
  ACMDRIVERDETAILS_LONGNAME_CHARS  = 128;
  {$EXTERNALSYM ACMDRIVERDETAILS_LONGNAME_CHARS}
  ACMDRIVERDETAILS_COPYRIGHT_CHARS = 80;
  {$EXTERNALSYM ACMDRIVERDETAILS_COPYRIGHT_CHARS}
  ACMDRIVERDETAILS_LICENSING_CHARS = 128;
  {$EXTERNALSYM ACMDRIVERDETAILS_LICENSING_CHARS}
  ACMDRIVERDETAILS_FEATURES_CHARS  = 512;
  {$EXTERNALSYM ACMDRIVERDETAILS_FEATURES_CHARS}

type
  PAcmDriverDetailsA = ^TAcmDriverDetailsA;
  PAcmDriverDetailsW = ^TAcmDriverDetailsW;
  PAcmDriverDetails = PAcmDriverDetailsA;
  _ACMDRIVERDETAILSA = packed record
    cbStruct: DWORD;
    fccType: FOURCC;
    fccComp: FOURCC;
    wMid: Word;
    wPid: Word;
    vdwACM: DWORD;
    vdwDriver: DWORD;
    fdwSupport: DWORD;
    cFormatTags: DWORD;
    cFilterTags: DWORD;
    hicon: HICON;
    szShortName: array [0..ACMDRIVERDETAILS_SHORTNAME_CHARS - 1] of AnsiChar;
    szLongName: array [0..ACMDRIVERDETAILS_LONGNAME_CHARS - 1]  of AnsiChar;
    szCopyright: array [0..ACMDRIVERDETAILS_COPYRIGHT_CHARS - 1] of AnsiChar;
    szLicensing: array [0..ACMDRIVERDETAILS_LICENSING_CHARS - 1] of AnsiChar;
    szFeatures: array [0..ACMDRIVERDETAILS_FEATURES_CHARS - 1]  of AnsiChar;
  end;
  {$EXTERNALSYM _ACMDRIVERDETAILSA}
  _ACMDRIVERDETAILSW = packed record
    cbStruct: DWORD;
    fccType: FOURCC;
    fccComp: FOURCC;
    wMid: Word;
    wPid: Word;
    vdwACM: DWORD;
    vdwDriver: DWORD;
    fdwSupport: DWORD;
    cFormatTags: DWORD;
    cFilterTags: DWORD;
    hicon: HICON;
    szShortName: array [0..ACMDRIVERDETAILS_SHORTNAME_CHARS - 1] of WideChar;
    szLongName: array [0..ACMDRIVERDETAILS_LONGNAME_CHARS - 1]  of WideChar;
    szCopyright: array [0..ACMDRIVERDETAILS_COPYRIGHT_CHARS - 1] of WideChar;
    szLicensing: array [0..ACMDRIVERDETAILS_LICENSING_CHARS - 1] of WideChar;
    szFeatures: array [0..ACMDRIVERDETAILS_FEATURES_CHARS - 1]  of WideChar;
  end;
  {$EXTERNALSYM _ACMDRIVERDETAILSW}
  _ACMDRIVERDETAILS = _ACMDRIVERDETAILSA;
  TAcmDriverDetailsA = _ACMDRIVERDETAILSA;
  TAcmDriverDetailsW = _ACMDRIVERDETAILSW;
  TAcmDriverDetails = TAcmDriverDetailsA;

//
//  ACMDRIVERDETAILS.fccType
//
//  ACMDRIVERDETAILS_FCCTYPE_AUDIOCODEC: the FOURCC used in the fccType
//  field of the ACMDRIVERDETAILS structure to specify that this is an ACM
//  codec designed for audio.
//
//
//  ACMDRIVERDETAILS.fccComp
//
//  ACMDRIVERDETAILS_FCCCOMP_UNDEFINED: the FOURCC used in the fccComp
//  field of the ACMDRIVERDETAILS structure. this is currently an unused
//  field.
//

const
  ACMDRIVERDETAILS_FCCTYPE_AUDIOCODEC = $63647561;   // 'audc';
  {$EXTERNALSYM ACMDRIVERDETAILS_FCCTYPE_AUDIOCODEC}
  ACMDRIVERDETAILS_FCCCOMP_UNDEFINED  = 0;           // '0000';
  {$EXTERNALSYM ACMDRIVERDETAILS_FCCCOMP_UNDEFINED}

//
//  the following flags are used to specify the type of conversion(s) that
//  the converter/codec/filter supports. these are placed in the fdwSupport
//  field of the ACMDRIVERDETAILS structure. note that a converter can
//  support one or more of these flags in any combination.
//
//  ACMDRIVERDETAILS_SUPPORTF_CODEC: this flag is set if the driver supports
//  conversions from one format tag to another format tag. for example, if a
//  converter compresses WAVE_FORMAT_PCM to WAVE_FORMAT_ADPCM, then this bit
//  should be set.
//
//  ACMDRIVERDETAILS_SUPPORTF_CONVERTER: this flags is set if the driver
//  supports conversions on the same format tag. as an example, the PCM
//  converter that is built into the ACM sets this bit (and only this bit)
//  because it converts only PCM formats (bits, sample rate).
//
//  ACMDRIVERDETAILS_SUPPORTF_FILTER: this flag is set if the driver supports
//  transformations on a single format. for example, a converter that changed
//  the 'volume' of PCM data would set this bit. 'echo' and 'reverb' are
//  also filter types.
//
//  ACMDRIVERDETAILS_SUPPORTF_HARDWARE: this flag is set if the driver supports
//  hardware input and/or output through a waveform device.
//
//  ACMDRIVERDETAILS_SUPPORTF_ASYNC: this flag is set if the driver supports
//  async conversions.
//
//
//  ACMDRIVERDETAILS_SUPPORTF_LOCAL: this flag is set _by the ACM_ if a
//  driver has been installed local to the current task. this flag is also
//  set in the fdwSupport argument to the enumeration callback function
//  for drivers.
//
//  ACMDRIVERDETAILS_SUPPORTF_DISABLED: this flag is set _by the ACM_ if a
//  driver has been disabled. this flag is also passed set in the fdwSupport
//  argument to the enumeration callback function for drivers.
//

const
  ACMDRIVERDETAILS_SUPPORTF_CODEC     = $00000001;
  {$EXTERNALSYM ACMDRIVERDETAILS_SUPPORTF_CODEC}
  ACMDRIVERDETAILS_SUPPORTF_CONVERTER = $00000002;
  {$EXTERNALSYM ACMDRIVERDETAILS_SUPPORTF_CONVERTER}
  ACMDRIVERDETAILS_SUPPORTF_FILTER    = $00000004;
  {$EXTERNALSYM ACMDRIVERDETAILS_SUPPORTF_FILTER}
  ACMDRIVERDETAILS_SUPPORTF_HARDWARE  = $00000008;
  {$EXTERNALSYM ACMDRIVERDETAILS_SUPPORTF_HARDWARE}
  ACMDRIVERDETAILS_SUPPORTF_ASYNC     = $00000010;
  {$EXTERNALSYM ACMDRIVERDETAILS_SUPPORTF_ASYNC}
  ACMDRIVERDETAILS_SUPPORTF_LOCAL     = $40000000;
  {$EXTERNALSYM ACMDRIVERDETAILS_SUPPORTF_LOCAL}
  ACMDRIVERDETAILS_SUPPORTF_DISABLED  = $80000000;
  {$EXTERNALSYM ACMDRIVERDETAILS_SUPPORTF_DISABLED}

function acmDriverDetailsA(hadid: HACMDRIVERID; var padd: TAcmDriverDetailsA;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmDriverDetailsA}
function acmDriverDetailsW(hadid: HACMDRIVERID; var padd: TAcmDriverDetailsW;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmDriverDetailsW}
function acmDriverDetails(hadid: HACMDRIVERID; var padd: TAcmDriverDetails;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmDriverDetails}

//--------------------------------------------------------------------------;
//
//  ACM Format Tags
//
//--------------------------------------------------------------------------;

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmFormatTagDetails()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

const
  ACMFORMATTAGDETAILS_FORMATTAG_CHARS = 48;
  {$EXTERNALSYM ACMFORMATTAGDETAILS_FORMATTAG_CHARS}

type
  PAcmFormatTagDetailsA = ^TAcmFormatTagDetailsA;
  PAcmFormatTagDetailsW = ^TAcmFormatTagDetailsW;
  PAcmFormatTagDetails = PAcmFormatTagDetailsA;
  _ACMFORMATTAGDETAILSA = packed record
    cbStruct: DWORD;
    dwFormatTagIndex: DWORD;
    dwFormatTag: DWORD;
    cbFormatSize: DWORD;
    fdwSupport: DWORD;
    cStandardFormats: DWORD;
    szFormatTag: array [0..ACMFORMATTAGDETAILS_FORMATTAG_CHARS - 1] of AnsiChar;
  end;
  {$EXTERNALSYM _ACMFORMATTAGDETAILSA}
  _ACMFORMATTAGDETAILSW = packed record
    cbStruct: DWORD;
    dwFormatTagIndex: DWORD;
    dwFormatTag: DWORD;
    cbFormatSize: DWORD;
    fdwSupport: DWORD;
    cStandardFormats: DWORD;
    szFormatTag: array [0..ACMFORMATTAGDETAILS_FORMATTAG_CHARS - 1] of WideChar;
  end;
  {$EXTERNALSYM _ACMFORMATTAGDETAILSW}
  _ACMFORMATTAGDETAILS = _ACMFORMATTAGDETAILSA;
  TAcmFormatTagDetailsA = _ACMFORMATTAGDETAILSA;
  TAcmFormatTagDetailsW = _ACMFORMATTAGDETAILSW;
  TAcmFormatTagDetails = TAcmFormatTagDetailsA;

function acmFormatTagDetailsA(had: HACMDRIVER; var paftd: TAcmFormatTagDetailsA;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatTagDetailsA}
function acmFormatTagDetailsW(had: HACMDRIVER; var paftd: TAcmFormatTagDetailsW;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatTagDetailsW}
function acmFormatTagDetails(had: HACMDRIVER; var paftd: TAcmFormatTagDetails;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatTagDetails}

const
  ACM_FORMATTAGDETAILSF_INDEX       = $00000000;
  {$EXTERNALSYM ACM_FORMATTAGDETAILSF_INDEX}
  ACM_FORMATTAGDETAILSF_FORMATTAG   = $00000001;
  {$EXTERNALSYM ACM_FORMATTAGDETAILSF_FORMATTAG}
  ACM_FORMATTAGDETAILSF_LARGESTSIZE = $00000002;
  {$EXTERNALSYM ACM_FORMATTAGDETAILSF_LARGESTSIZE}
  ACM_FORMATTAGDETAILSF_QUERYMASK   = $0000000F;
  {$EXTERNALSYM ACM_FORMATTAGDETAILSF_QUERYMASK}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmFormatTagEnum()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

type
  ACMFORMATTAGENUMCBA = function (hadid: HACMDRIVERID; paftd: PAcmFormatTagDetailsA;
    dwInstance: DWORD; fdwSupport: DWORD): BOOL; stdcall;
  {$EXTERNALSYM ACMFORMATTAGENUMCBA}
  ACMFORMATTAGENUMCBW = function (hadid: HACMDRIVERID; paftd: PAcmFormatTagDetailsW;
    dwInstance: DWORD; fdwSupport: DWORD): BOOL; stdcall;
  {$EXTERNALSYM ACMFORMATTAGENUMCBW}
  ACMFORMATTAGENUMCB = ACMFORMATTAGENUMCBA;

function acmFormatTagEnumA(had: HACMDRIVER; var paftd: TAcmFormatTagDetailsA;
  fnCallback: ACMFORMATTAGENUMCBA; dwInstance: DWORD; fdwEnum: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatTagEnumA}
function acmFormatTagEnumW(had: HACMDRIVER; var paftd: TAcmFormatTagDetailsW;
  fnCallback: ACMFORMATTAGENUMCBW; dwInstance: DWORD; fdwEnum: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatTagEnumW}
function acmFormatTagEnum(had: HACMDRIVER; var paftd: TAcmFormatTagDetails;
  fnCallback: ACMFORMATTAGENUMCB; dwInstance: DWORD; fdwEnum: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatTagEnum}

//--------------------------------------------------------------------------;
//
//  ACM Formats
//
//--------------------------------------------------------------------------;

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmFormatDetails()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

const
  ACMFORMATDETAILS_FORMAT_CHARS = 128;
  {$EXTERNALSYM ACMFORMATDETAILS_FORMAT_CHARS}

type
  PAcmFormatDetailsA = ^TAcmFormatDetailsA;
  PAcmFormatDetailsW = ^TAcmFormatDetailsW;
  PAcmFormatDetails = PAcmFormatDetailsA;
  _ACMFORMATDETAILSA = packed record
    cbStruct: DWORD;
    dwFormatIndex: DWORD;
    dwFormatTag: DWORD;
    fdwSupport: DWORD;
    pwfx: PWAVEFORMATEX;
    cbwfx: DWORD;
    szFormat: array [0..ACMFORMATDETAILS_FORMAT_CHARS - 1] of AnsiChar;
  end;
  {$EXTERNALSYM _ACMFORMATDETAILSA}
  _ACMFORMATDETAILSW = packed record
    cbStruct: DWORD;
    dwFormatIndex: DWORD;
    dwFormatTag: DWORD;
    fdwSupport: DWORD;
    pwfx: PWAVEFORMATEX;
    cbwfx: DWORD;
    szFormat: array [0..ACMFORMATDETAILS_FORMAT_CHARS - 1] of WideChar;
  end;
  {$EXTERNALSYM _ACMFORMATDETAILSW}
  _ACMFORMATDETAILS = _ACMFORMATDETAILSA;
  TAcmFormatDetailsA = _ACMFORMATDETAILSA;
  TAcmFormatDetailsW = _ACMFORMATDETAILSW;
  TAcmFormatDetails = TAcmFormatDetailsA;

function acmFormatDetailsA(had: HACMDRIVER; var pafd: TAcmFormatDetailsA;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatDetailsA}
function acmFormatDetailsW(had: HACMDRIVER; var pafd: TAcmFormatDetailsW;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatDetailsW}
function acmFormatDetails(had: HACMDRIVER; var pafd: TAcmFormatDetails;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatDetails}

const
  ACM_FORMATDETAILSF_INDEX     = $00000000;
  {$EXTERNALSYM ACM_FORMATDETAILSF_INDEX}
  ACM_FORMATDETAILSF_FORMAT    = $00000001;
  {$EXTERNALSYM ACM_FORMATDETAILSF_FORMAT}
  ACM_FORMATDETAILSF_QUERYMASK = $0000000F;
  {$EXTERNALSYM ACM_FORMATDETAILSF_QUERYMASK}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmFormatEnum()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

type
  ACMFORMATENUMCBA = function (hadid:HACMDRIVERID; pafd: PAcmFormatDetailsA;
    dwInstance: DWORD; fdwSupport: DWORD): BOOL; stdcall;
  {$EXTERNALSYM ACMFORMATENUMCBA}
  ACMFORMATENUMCBW = function (hadid:HACMDRIVERID; pafd: PAcmFormatDetailsW;
    dwInstance: DWORD; fdwSupport: DWORD): BOOL; stdcall;
  {$EXTERNALSYM ACMFORMATENUMCBW}
  ACMFORMATENUMCB = ACMFORMATENUMCBA;

function acmFormatEnumA(had: HACMDRIVER; var pafd: TAcmFormatDetailsA;
  fnCallback: ACMFORMATENUMCBA; dwInstance, fdwEnum: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatEnumA}
function acmFormatEnumW(had: HACMDRIVER; var pafd: TAcmFormatDetailsW;
  fnCallback: ACMFORMATENUMCBW; dwInstance, fdwEnum: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatEnumW}
function acmFormatEnum(had: HACMDRIVER; var pafd: TAcmFormatDetails;
  fnCallback: ACMFORMATENUMCB; dwInstance, fdwEnum: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatEnum}

const
  ACM_FORMATENUMF_WFORMATTAG     = $00010000;
  {$EXTERNALSYM ACM_FORMATENUMF_WFORMATTAG}
  ACM_FORMATENUMF_NCHANNELS      = $00020000;
  {$EXTERNALSYM ACM_FORMATENUMF_NCHANNELS}
  ACM_FORMATENUMF_NSAMPLESPERSEC = $00040000;
  {$EXTERNALSYM ACM_FORMATENUMF_NSAMPLESPERSEC}
  ACM_FORMATENUMF_WBITSPERSAMPLE = $00080000;
  {$EXTERNALSYM ACM_FORMATENUMF_WBITSPERSAMPLE}
  ACM_FORMATENUMF_CONVERT        = $00100000;
  {$EXTERNALSYM ACM_FORMATENUMF_CONVERT}
  ACM_FORMATENUMF_SUGGEST        = $00200000;
  {$EXTERNALSYM ACM_FORMATENUMF_SUGGEST}
  ACM_FORMATENUMF_HARDWARE       = $00400000;
  {$EXTERNALSYM ACM_FORMATENUMF_HARDWARE}
  ACM_FORMATENUMF_INPUT          = $00800000;
  {$EXTERNALSYM ACM_FORMATENUMF_INPUT}
  ACM_FORMATENUMF_OUTPUT         = $01000000;
  {$EXTERNALSYM ACM_FORMATENUMF_OUTPUT}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmFormatSuggest()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmFormatSuggest(had: HACMDRIVER; var pwfxSrc: TWAVEFORMATEX;
  var pwfxDst: TWAVEFORMATEX; cbwfxDst: DWORD; fdwSuggest: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatSuggest}

const
  ACM_FORMATSUGGESTF_WFORMATTAG     = $00010000;
  {$EXTERNALSYM ACM_FORMATSUGGESTF_WFORMATTAG}
  ACM_FORMATSUGGESTF_NCHANNELS      = $00020000;
  {$EXTERNALSYM ACM_FORMATSUGGESTF_NCHANNELS}
  ACM_FORMATSUGGESTF_NSAMPLESPERSEC = $00040000;
  {$EXTERNALSYM ACM_FORMATSUGGESTF_NSAMPLESPERSEC}
  ACM_FORMATSUGGESTF_WBITSPERSAMPLE = $00080000;
  {$EXTERNALSYM ACM_FORMATSUGGESTF_WBITSPERSAMPLE}

  ACM_FORMATSUGGESTF_TYPEMASK       = $00FF0000;
  {$EXTERNALSYM ACM_FORMATSUGGESTF_TYPEMASK}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmFormatChoose()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

const
  ACMHELPMSGSTRINGA      = 'acmchoose_help';
  {$EXTERNALSYM ACMHELPMSGSTRINGA}
  ACMHELPMSGSTRINGW      = 'acmchoose_help';
  {$EXTERNALSYM ACMHELPMSGSTRINGW}
  ACMHELPMSGSTRING = ACMHELPMSGSTRINGA;
  ACMHELPMSGCONTEXTMENUA = 'acmchoose_contextmenu';
  {$EXTERNALSYM ACMHELPMSGCONTEXTMENUA}
  ACMHELPMSGCONTEXTMENUW = 'acmchoose_contextmenu';
  {$EXTERNALSYM ACMHELPMSGCONTEXTMENUW}
  ACMHELPMSGCONTEXTMENU = ACMHELPMSGCONTEXTMENUA;
  ACMHELPMSGCONTEXTHELPA = 'acmchoose_contexthelp';
  {$EXTERNALSYM ACMHELPMSGCONTEXTHELPA}
  ACMHELPMSGCONTEXTHELPW = 'acmchoose_contexthelp';
  {$EXTERNALSYM ACMHELPMSGCONTEXTHELPW}
  ACMHELPMSGCONTEXTHELP = ACMHELPMSGCONTEXTHELPA;

//
//  MM_ACM_FORMATCHOOSE is sent to hook callbacks by the Format Chooser
//  Dialog...
//

const
  MM_ACM_FORMATCHOOSE           = $8000;
  {$EXTERNALSYM MM_ACM_FORMATCHOOSE}

  FORMATCHOOSE_MESSAGE          = 0;
  {$EXTERNALSYM FORMATCHOOSE_MESSAGE}
  FORMATCHOOSE_FORMATTAG_VERIFY = FORMATCHOOSE_MESSAGE + 0;
  {$EXTERNALSYM FORMATCHOOSE_FORMATTAG_VERIFY}
  FORMATCHOOSE_FORMAT_VERIFY    = FORMATCHOOSE_MESSAGE + 1;
  {$EXTERNALSYM FORMATCHOOSE_FORMAT_VERIFY}
  FORMATCHOOSE_CUSTOM_VERIFY    = FORMATCHOOSE_MESSAGE + 2;
  {$EXTERNALSYM FORMATCHOOSE_CUSTOM_VERIFY}

type
  ACMFORMATCHOOSEHOOKPROCA = function (hwnd: HWND; uMsg: UINT; wParam: WPARAM;
    lParam: LPARAM): UINT; stdcall;
  {$EXTERNALSYM ACMFORMATCHOOSEHOOKPROCA}
  ACMFORMATCHOOSEHOOKPROCW = function (hwnd: HWND; uMsg: UINT; wParam: WPARAM;
    lParam: LPARAM): UINT; stdcall;
  {$EXTERNALSYM ACMFORMATCHOOSEHOOKPROCW}
  ACMFORMATCHOOSEHOOKPROC = ACMFORMATCHOOSEHOOKPROCA;

  PAcmFormatChooseA = ^TAcmFormatChooseA;
  PAcmFormatChooseW = ^TAcmFormatChooseW;
  PAcmFormatChoose = PAcmFormatChooseA;
  _ACMFORMATCHOOSEA = packed record
    cbStruct: DWORD;
    fdwStyle: DWORD;
    hwndOwner: HWND;
    pwfx: PWAVEFORMATEX;
    cbwfx: DWORD;
    pszTitle: PAnsiChar;
    szFormatTag: array [0..ACMFORMATTAGDETAILS_FORMATTAG_CHARS-1] of AnsiChar;
    szFormat: array [0..ACMFORMATDETAILS_FORMAT_CHARS-1] of AnsiChar;
    pszName: PAnsiChar;
    cchName: DWORD;
    fdwEnum: DWORD;
    pwfxEnum: PWAVEFORMATEX;
    hInstance: HINST;
    pszTemplateName: PAnsiChar;
    lCustData: LPARAM;
    pfnHook: ACMFORMATCHOOSEHOOKPROCA;
  end;
  {$EXTERNALSYM _ACMFORMATCHOOSEA}
  _ACMFORMATCHOOSEW = packed record
    cbStruct: DWORD;
    fdwStyle: DWORD;
    hwndOwner: HWND;
    pwfx: PWAVEFORMATEX;
    cbwfx: DWORD;
    pszTitle: PWideChar;
    szFormatTag: array [0..ACMFORMATTAGDETAILS_FORMATTAG_CHARS-1] of WideChar;
    szFormat: array [0..ACMFORMATDETAILS_FORMAT_CHARS-1] of WideChar;
    pszName: PWideChar;
    cchName: DWORD;
    fdwEnum: DWORD;
    pwfxEnum: PWAVEFORMATEX;
    hInstance: HINST;
    pszTemplateName: PWideChar;
    lCustData: LPARAM;
    pfnHook: ACMFORMATCHOOSEHOOKPROCW;
  end;
  {$EXTERNALSYM _ACMFORMATCHOOSEW}
  _ACMFORMATCHOOSE = _ACMFORMATCHOOSEA;
  TAcmFormatChooseA = _ACMFORMATCHOOSEA;
  TAcmFormatChooseW = _ACMFORMATCHOOSEW;
  TAcmFormatChoose = TAcmFormatChooseA;

//
//  ACMFORMATCHOOSE.fdwStyle
//

const
  ACMFORMATCHOOSE_STYLEF_SHOWHELP             = $00000004;
  {$EXTERNALSYM ACMFORMATCHOOSE_STYLEF_SHOWHELP}
  ACMFORMATCHOOSE_STYLEF_ENABLEHOOK           = $00000008;
  {$EXTERNALSYM ACMFORMATCHOOSE_STYLEF_ENABLEHOOK}
  ACMFORMATCHOOSE_STYLEF_ENABLETEMPLATE       = $00000010;
  {$EXTERNALSYM ACMFORMATCHOOSE_STYLEF_ENABLETEMPLATE}
  ACMFORMATCHOOSE_STYLEF_ENABLETEMPLATEHANDLE = $00000020;
  {$EXTERNALSYM ACMFORMATCHOOSE_STYLEF_ENABLETEMPLATEHANDLE}
  ACMFORMATCHOOSE_STYLEF_INITTOWFXSTRUCT      = $00000040;
  {$EXTERNALSYM ACMFORMATCHOOSE_STYLEF_INITTOWFXSTRUCT}
  ACMFORMATCHOOSE_STYLEF_CONTEXTHELP          = $00000080;
  {$EXTERNALSYM ACMFORMATCHOOSE_STYLEF_CONTEXTHELP}

function acmFormatChooseA(var pafmtc: TAcmFormatChooseA): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatChooseA}
function acmFormatChooseW(var pafmtc: TAcmFormatChooseW): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatChooseW}
function acmFormatChoose(var pafmtc: TAcmFormatChoose): MMRESULT; stdcall;
{$EXTERNALSYM acmFormatChoose}

//--------------------------------------------------------------------------;
//
//  ACM Filter Tags
//
//--------------------------------------------------------------------------;

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmFilterTagDetails()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

const
  ACMFILTERTAGDETAILS_FILTERTAG_CHARS = 48;
  {$EXTERNALSYM ACMFILTERTAGDETAILS_FILTERTAG_CHARS}

type
  PAcmFilterTagDetailsA = ^TAcmFilterTagDetailsA;
  PAcmFilterTagDetailsW = ^TAcmFilterTagDetailsW;
  PAcmFilterTagDetails = PAcmFilterTagDetailsA;
  _ACMFILTERTAGDETAILSA = packed record
    cbStruct: DWORD;
    dwFilterTagIndex: DWORD;
    dwFilterTag: DWORD;
    cbFilterSize: DWORD;
    fdwSupport: DWORD;
    cStandardFilters: DWORD;
    szFilterTag: array [0..ACMFILTERTAGDETAILS_FILTERTAG_CHARS-1] of AnsiChar;
  end;
  {$EXTERNALSYM _ACMFILTERTAGDETAILSA}
  _ACMFILTERTAGDETAILSW = packed record
    cbStruct: DWORD;
    dwFilterTagIndex: DWORD;
    dwFilterTag: DWORD;
    cbFilterSize: DWORD;
    fdwSupport: DWORD;
    cStandardFilters: DWORD;
    szFilterTag: array [0..ACMFILTERTAGDETAILS_FILTERTAG_CHARS-1] of WideChar;
  end;
  {$EXTERNALSYM _ACMFILTERTAGDETAILSW}
  _ACMFILTERTAGDETAILS = _ACMFILTERTAGDETAILSA;
  TAcmFilterTagDetailsA = _ACMFILTERTAGDETAILSA;
  TAcmFilterTagDetailsW = _ACMFILTERTAGDETAILSW;
  TAcmFilterTagDetails = TAcmFilterTagDetailsA;

function acmFilterTagDetailsA(had: HACMDRIVER; var paftd: TAcmFilterTagDetailsA;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterTagDetailsA}
function acmFilterTagDetailsW(had: HACMDRIVER; var paftd: TAcmFilterTagDetailsW;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterTagDetailsW}
function acmFilterTagDetails(had: HACMDRIVER; var paftd: TAcmFilterTagDetails;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterTagDetails}

const
  ACM_FILTERTAGDETAILSF_INDEX       = $00000000;
  {$EXTERNALSYM ACM_FILTERTAGDETAILSF_INDEX}
  ACM_FILTERTAGDETAILSF_FILTERTAG   = $00000001;
  {$EXTERNALSYM ACM_FILTERTAGDETAILSF_FILTERTAG}
  ACM_FILTERTAGDETAILSF_LARGESTSIZE = $00000002;
  {$EXTERNALSYM ACM_FILTERTAGDETAILSF_LARGESTSIZE}
  ACM_FILTERTAGDETAILSF_QUERYMASK   = $0000000F;
  {$EXTERNALSYM ACM_FILTERTAGDETAILSF_QUERYMASK}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmFilterTagEnum()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

type
  ACMFILTERTAGENUMCBA = function (hadid: HACMDRIVERID; paftd: PAcmFilterTagDetailsA;
    dwInstance: DWORD; fdwSupport: DWORD) : BOOL; stdcall;
  {$EXTERNALSYM ACMFILTERTAGENUMCBA}
  ACMFILTERTAGENUMCBW = function (hadid: HACMDRIVERID; paftd: PAcmFilterTagDetailsW;
    dwInstance: DWORD; fdwSupport: DWORD) : BOOL; stdcall;
  {$EXTERNALSYM ACMFILTERTAGENUMCBW}
  ACMFILTERTAGENUMCB = ACMFILTERTAGENUMCBA;

function acmFilterTagEnumA(had: HACMDRIVER; var paftd: TAcmFilterTagDetailsA;
  fnCallback: ACMFILTERTAGENUMCBA; dwInstance: DWORD; fdwEnum: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterTagEnumA}
function acmFilterTagEnumW(had: HACMDRIVER; var paftd: TAcmFilterTagDetailsW;
  fnCallback: ACMFILTERTAGENUMCBW; dwInstance: DWORD; fdwEnum: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterTagEnumW}
function acmFilterTagEnum(had: HACMDRIVER; var paftd: TAcmFilterTagDetails;
  fnCallback: ACMFILTERTAGENUMCB; dwInstance: DWORD; fdwEnum: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterTagEnum}

//--------------------------------------------------------------------------;
//
//  ACM Filters
//
//--------------------------------------------------------------------------;

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmFilterDetails()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

const
  ACMFILTERDETAILS_FILTER_CHARS = 128;
  {$EXTERNALSYM ACMFILTERDETAILS_FILTER_CHARS}

type
  PAcmFilterDetailsA = ^TAcmFilterDetailsA;
  PAcmFilterDetailsW = ^TAcmFilterDetailsW;
  PAcmFilterDetails = PAcmFilterDetailsA;
  _ACMFILTERDETAILSA = packed record
    cbStruct: DWORD;
    dwFilterIndex: DWORD;
    dwFilterTag: DWORD;
    fdwSupport: DWORD;
    pwfltr: PWAVEFILTER;
    cbwfltr: DWORD;
    szFilter: array [0..ACMFILTERDETAILS_FILTER_CHARS - 1] of AnsiChar;
  end;
  {$EXTERNALSYM _ACMFILTERDETAILSA}
  _ACMFILTERDETAILSW = packed record
    cbStruct: DWORD;
    dwFilterIndex: DWORD;
    dwFilterTag: DWORD;
    fdwSupport: DWORD;
    pwfltr: PWAVEFILTER;
    cbwfltr: DWORD;
    szFilter: array [0..ACMFILTERDETAILS_FILTER_CHARS - 1] of WideChar;
  end;
  {$EXTERNALSYM _ACMFILTERDETAILSW}
  _ACMFILTERDETAILS = _ACMFILTERDETAILSA;
  TAcmFilterDetailsA = _ACMFILTERDETAILSA;
  TAcmFilterDetailsW = _ACMFILTERDETAILSW;
  TAcmFilterDetails = TAcmFilterDetailsA;

function acmFilterDetailsA(had: HACMDRIVER; var pafd: TAcmFilterDetailsA;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterDetailsA}
function acmFilterDetailsW(had: HACMDRIVER; var pafd: TAcmFilterDetailsW;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterDetailsW}
function acmFilterDetails(had: HACMDRIVER; var pafd: TAcmFilterDetails;
  fdwDetails: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterDetails}

const
  ACM_FILTERDETAILSF_INDEX     = $00000000;
  {$EXTERNALSYM ACM_FILTERDETAILSF_INDEX}
  ACM_FILTERDETAILSF_FILTER    = $00000001;
  {$EXTERNALSYM ACM_FILTERDETAILSF_FILTER}
  ACM_FILTERDETAILSF_QUERYMASK = $0000000F;
  {$EXTERNALSYM ACM_FILTERDETAILSF_QUERYMASK}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmFilterEnum()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

type
  ACMFILTERENUMCBA = function (hadid: HACMDRIVERID; pafd: PAcmFilterDetailsA;
    dwInstance: DWORD; fdwSupport: DWORD) : BOOL; stdcall;
  ACMFILTERENUMCBW = function (hadid: HACMDRIVERID; pafd: PAcmFilterDetailsW;
    dwInstance: DWORD; fdwSupport: DWORD) : BOOL; stdcall;
  ACMFILTERENUMCB = ACMFILTERENUMCBA;

function acmFilterEnumA(had: HACMDRIVER; var pafd: TAcmFilterDetailsA;
  fnCallback: ACMFILTERENUMCBA; dwInstance: DWORD; fdwEnum: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterEnumA}
function acmFilterEnumW(had: HACMDRIVER; var pafd: TAcmFilterDetailsW;
  fnCallback: ACMFILTERENUMCBW; dwInstance: DWORD; fdwEnum: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterEnumW}
function acmFilterEnum(had: HACMDRIVER; var pafd: TAcmFilterDetails;
  fnCallback: ACMFILTERENUMCB; dwInstance: DWORD; fdwEnum: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterEnum}

const
  ACM_FILTERENUMF_DWFILTERTAG = $00010000;
  {$EXTERNALSYM ACM_FILTERENUMF_DWFILTERTAG}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmFilterChoose()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

//
//  MM_ACM_FILTERCHOOSE is sent to hook callbacks by the Filter Chooser
//  Dialog...
//

const
  MM_ACM_FILTERCHOOSE           = $8000;
  {$EXTERNALSYM MM_ACM_FILTERCHOOSE}

  FILTERCHOOSE_MESSAGE          = 0;
  {$EXTERNALSYM FILTERCHOOSE_MESSAGE}
  FILTERCHOOSE_FILTERTAG_VERIFY = FILTERCHOOSE_MESSAGE + 0;
  {$EXTERNALSYM FILTERCHOOSE_FILTERTAG_VERIFY}
  FILTERCHOOSE_FILTER_VERIFY    = FILTERCHOOSE_MESSAGE + 1;
  {$EXTERNALSYM FILTERCHOOSE_FILTER_VERIFY}
  FILTERCHOOSE_CUSTOM_VERIFY    = FILTERCHOOSE_MESSAGE + 2;
  {$EXTERNALSYM FILTERCHOOSE_CUSTOM_VERIFY}

type
  ACMFILTERCHOOSEHOOKPROCA = function (hwd: HWND; uMsg: UINT; wParam: WPARAM;
    lParam: LPARAM): UINT; stdcall;
  {$EXTERNALSYM ACMFILTERCHOOSEHOOKPROCA}
  ACMFILTERCHOOSEHOOKPROCW = function (hwd: HWND; uMsg: UINT; wParam: WPARAM;
    lParam: LPARAM): UINT; stdcall;
  {$EXTERNALSYM ACMFILTERCHOOSEHOOKPROCW}
  ACMFILTERCHOOSEHOOKPROC = ACMFILTERCHOOSEHOOKPROCA;

//
//  ACMFILTERCHOOSE
//
//

type
  PAcmFilterChooseA = ^TAcmFilterChooseA;
  PAcmFilterChooseW = ^TAcmFilterChooseW;
  PAcmFilterChoose = PAcmFilterChooseA;
  _ACMFILTERCHOOSEA = packed record
    cbStruct: DWORD;
    fdwStyle: DWORD;
    hwndOwner: HWND;
    pwfltr: PWAVEFILTER;
    cbwfltr: DWORD;
    pszTitle: PAnsiChar;
    szFilterTag: array [0..ACMFILTERTAGDETAILS_FILTERTAG_CHARS - 1] of AnsiChar;
    szFilter: array [0..ACMFILTERDETAILS_FILTER_CHARS - 1] of AnsiChar;
    pszName: PAnsiChar;
    cchName: DWORD;
    fdwEnum: DWORD;
    pwfltrEnum: PWAVEFILTER;
    hInstance: HINST;
    pszTemplateName: PAnsiChar;
    lCustData: LPARAM;
    pfnHook: ACMFILTERCHOOSEHOOKPROCA;
  end;
  {$EXTERNALSYM _ACMFILTERCHOOSEA}
  _ACMFILTERCHOOSEW = packed record
    cbStruct: DWORD;
    fdwStyle: DWORD;
    hwndOwner: HWND;
    pwfltr: PWAVEFILTER;
    cbwfltr: DWORD;
    pszTitle: PWideChar;
    szFilterTag: array [0..ACMFILTERTAGDETAILS_FILTERTAG_CHARS - 1] of WideChar;
    szFilter: array [0..ACMFILTERDETAILS_FILTER_CHARS - 1] of WideChar;
    pszName: PWideChar;
    cchName: DWORD;
    fdwEnum: DWORD;
    pwfltrEnum: PWAVEFILTER;
    hInstance: HINST;
    pszTemplateName: PWideChar;
    lCustData: LPARAM;
    pfnHook: ACMFILTERCHOOSEHOOKPROCW;
  end;
  {$EXTERNALSYM _ACMFILTERCHOOSEW}
  _ACMFILTERCHOOSE = _ACMFILTERCHOOSEA;
  TAcmFilterChooseA = _ACMFILTERCHOOSEA;
  TAcmFilterChooseW = _ACMFILTERCHOOSEW;
  TAcmFilterChoose = TAcmFilterChooseA;

//
//  ACMFILTERCHOOSE.fdwStyle
//

const
  ACMFILTERCHOOSE_STYLEF_SHOWHELP             = $00000004;
  {$EXTERNALSYM ACMFILTERCHOOSE_STYLEF_SHOWHELP}
  ACMFILTERCHOOSE_STYLEF_ENABLEHOOK           = $00000008;
  {$EXTERNALSYM ACMFILTERCHOOSE_STYLEF_ENABLEHOOK}
  ACMFILTERCHOOSE_STYLEF_ENABLETEMPLATE       = $00000010;
  {$EXTERNALSYM ACMFILTERCHOOSE_STYLEF_ENABLETEMPLATE}
  ACMFILTERCHOOSE_STYLEF_ENABLETEMPLATEHANDLE = $00000020;
  {$EXTERNALSYM ACMFILTERCHOOSE_STYLEF_ENABLETEMPLATEHANDLE}
  ACMFILTERCHOOSE_STYLEF_INITTOFILTERSTRUCT   = $00000040;
  {$EXTERNALSYM ACMFILTERCHOOSE_STYLEF_INITTOFILTERSTRUCT}
  ACMFILTERCHOOSE_STYLEF_CONTEXTHELP          = $00000080;
  {$EXTERNALSYM ACMFILTERCHOOSE_STYLEF_CONTEXTHELP}

function acmFilterChooseA(var pafltrc: TAcmFilterChooseA): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterChooseA}
function acmFilterChooseW(var pafltrc: TAcmFilterChooseW): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterChooseW}
function acmFilterChoose(var pafltrc: TAcmFilterChoose): MMRESULT; stdcall;
{$EXTERNALSYM acmFilterChoose}

//--------------------------------------------------------------------------;
//
//  ACM Stream API's
//
//--------------------------------------------------------------------------;

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmStreamOpen()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

type
  PAcmStreamHeader = ^TAcmStreamHeader;
  ACMSTREAMHEADER = packed record
    cbStruct: DWORD;
    fdwStatus: DWORD;
    dwUser: DWORD;
    pbSrc: PBYTE;
    cbSrcLength: DWORD;
    cbSrcLengthUsed: DWORD;
    dwSrcUser: DWORD;
    pbDst: PBYTE;
    cbDstLength: DWORD;
    cbDstLengthUsed: DWORD;
    dwDstUser: DWORD;
    dwReservedDriver: array [0..10 - 1] of DWORD;
  end;
  {$EXTERNALSYM tACMSTREAMHEADER}
  TAcmStreamHeader = ACMSTREAMHEADER;

//
//  ACMSTREAMHEADER.fdwStatus
//
//  ACMSTREAMHEADER_STATUSF_DONE: done bit for async conversions.
//

const
  ACMSTREAMHEADER_STATUSF_DONE     = $00010000;
  {$EXTERNALSYM ACMSTREAMHEADER_STATUSF_DONE}
  ACMSTREAMHEADER_STATUSF_PREPARED = $00020000;
  {$EXTERNALSYM ACMSTREAMHEADER_STATUSF_PREPARED}
  ACMSTREAMHEADER_STATUSF_INQUEUE  = $00100000;
  {$EXTERNALSYM ACMSTREAMHEADER_STATUSF_INQUEUE}

function acmStreamOpen(var phas: HACMSTREAM; had: HACMDRIVER; var pwfxSrc: TWAVEFORMATEX;
  var pwfxDst: TWAVEFORMATEX; pwfltr: PWAVEFILTER; dwCallback: DWORD; dwInstance: DWORD;
  fdwOpen: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmStreamOpen}

const
  ACM_STREAMOPENF_QUERY       = $00000001;
  {$EXTERNALSYM ACM_STREAMOPENF_QUERY}
  ACM_STREAMOPENF_ASYNC       = $00000002;
  {$EXTERNALSYM ACM_STREAMOPENF_ASYNC}
  ACM_STREAMOPENF_NONREALTIME = $00000004;
  {$EXTERNALSYM ACM_STREAMOPENF_NONREALTIME}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmStreamClose()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmStreamClose(has: HACMSTREAM; fdwClose: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmStreamClose}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmStreamSize()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmStreamSize(has: HACMSTREAM; cbInput: DWORD; var pdwOutputBytes: DWORD;
  fdwSize: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmStreamSize}

const
  ACM_STREAMSIZEF_SOURCE      = $00000000;
  {$EXTERNALSYM ACM_STREAMSIZEF_SOURCE}
  ACM_STREAMSIZEF_DESTINATION = $00000001;
  {$EXTERNALSYM ACM_STREAMSIZEF_DESTINATION}
  ACM_STREAMSIZEF_QUERYMASK   = $0000000F;
  {$EXTERNALSYM ACM_STREAMSIZEF_QUERYMASK}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmStreamReset()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmStreamReset(has: HACMSTREAM; fdwReset: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmStreamReset}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmStreamMessage()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmStreamMessage(has: HACMSTREAM; uMsg: UINT; var lParam1: LPARAM;
  var lParam2: LPARAM): MMRESULT; stdcall;
{$EXTERNALSYM acmStreamMessage}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmStreamConvert()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmStreamConvert(has: HACMSTREAM; var pash: TAcmStreamHeader;
  fdwConvert: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmStreamConvert}

const
  ACM_STREAMCONVERTF_BLOCKALIGN = $00000004;
  {$EXTERNALSYM ACM_STREAMCONVERTF_BLOCKALIGN}
  ACM_STREAMCONVERTF_START      = $00000010;
  {$EXTERNALSYM ACM_STREAMCONVERTF_START}
  ACM_STREAMCONVERTF_END        = $00000020;
  {$EXTERNALSYM ACM_STREAMCONVERTF_END}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmStreamPrepareHeader()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmStreamPrepareHeader(has: HACMSTREAM; var pash: TAcmStreamHeader;
  fdwPrepare: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmStreamPrepareHeader}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
//
//  acmStreamUnprepareHeader()
//
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

function acmStreamUnprepareHeader(has: HACMSTREAM; var pash: TAcmStreamHeader;
  fdwUnprepare: DWORD): MMRESULT; stdcall;
{$EXTERNALSYM acmStreamUnprepareHeader}

implementation

const
  msacm32 = 'msacm32.dll';

function acmGetVersion;            external msacm32 name 'acmGetVersion';
function acmMetrics;               external msacm32 name 'acmMetrics';
function acmDriverEnum;            external msacm32 name 'acmDriverEnum';
function acmDriverID;              external msacm32 name 'acmDriverID';
function acmDriverAddA;          external msacm32 name 'acmDriverAddA';
function acmDriverAddW;          external msacm32 name 'acmDriverAddW';
function acmDriverAdd;          external msacm32 name 'acmDriverAddA';
function acmDriverRemove;          external msacm32 name 'acmDriverRemove';
function acmDriverOpen;            external msacm32 name 'acmDriverOpen';
function acmDriverClose;           external msacm32 name 'acmDriverClose';
function acmDriverMessage;         external msacm32 name 'acmDriverMessage';
function acmDriverPriority;        external msacm32 name 'acmDriverPriority';
function acmDriverDetailsA;      external msacm32 name 'acmDriverDetailsA';
function acmDriverDetailsW;      external msacm32 name 'acmDriverDetailsW';
function acmDriverDetails;      external msacm32 name 'acmDriverDetailsA';
function acmFormatTagDetailsA;   external msacm32 name 'acmFormatTagDetailsA';
function acmFormatTagDetailsW;   external msacm32 name 'acmFormatTagDetailsW';
function acmFormatTagDetails;   external msacm32 name 'acmFormatTagDetailsA';
function acmFormatDetailsA;      external msacm32 name 'acmFormatDetailsA';
function acmFormatDetailsW;      external msacm32 name 'acmFormatDetailsW';
function acmFormatDetails;      external msacm32 name 'acmFormatDetailsA';
function acmFormatChooseA;       external msacm32 name 'acmFormatChooseA';
function acmFormatChooseW;       external msacm32 name 'acmFormatChooseW';
function acmFormatChoose;       external msacm32 name 'acmFormatChooseA';
function acmFormatEnumA;         external msacm32 name 'acmFormatEnumA';
function acmFormatEnumW;         external msacm32 name 'acmFormatEnumW';
function acmFormatEnum;         external msacm32 name 'acmFormatEnumA';
function acmFormatTagEnumA;      external msacm32 name 'acmFormatTagEnumA';
function acmFormatTagEnumW;      external msacm32 name 'acmFormatTagEnumW';
function acmFormatTagEnum;      external msacm32 name 'acmFormatTagEnumA';
function acmFormatSuggest;         external msacm32 name 'acmFormatSuggest';
function acmFilterTagDetailsA;   external msacm32 name 'acmFilterTagDetailsA';
function acmFilterTagDetailsW;   external msacm32 name 'acmFilterTagDetailsW';
function acmFilterTagDetails;   external msacm32 name 'acmFilterTagDetailsA';
function acmFilterTagEnumA;      external msacm32 name 'acmFilterTagEnumA';
function acmFilterTagEnumW;      external msacm32 name 'acmFilterTagEnumW';
function acmFilterTagEnum;      external msacm32 name 'acmFilterTagEnumA';
function acmFilterDetailsA;      external msacm32 name 'acmFilterDetailsA';
function acmFilterDetailsW;      external msacm32 name 'acmFilterDetailsW';
function acmFilterDetails;      external msacm32 name 'acmFilterDetailsA';
function acmFilterEnumA;         external msacm32 name 'acmFilterEnumA';
function acmFilterEnumW;         external msacm32 name 'acmFilterEnumW';
function acmFilterEnum;         external msacm32 name 'acmFilterEnumA';
function acmFilterChooseA;       external msacm32 name 'acmFilterChooseA';
function acmFilterChooseW;       external msacm32 name 'acmFilterChooseW';
function acmFilterChoose;       external msacm32 name 'acmFilterChooseA';
function acmStreamOpen;            external msacm32 name 'acmStreamOpen';
function acmStreamClose;           external msacm32 name 'acmStreamClose';
function acmStreamSize;            external msacm32 name 'acmStreamSize';
function acmStreamReset;           external msacm32 name 'acmStreamReset';
function acmStreamMessage;         external msacm32 name 'acmStreamMessage';
function acmStreamConvert;         external msacm32 name 'acmStreamConvert';
function acmStreamPrepareHeader;   external msacm32 name 'acmStreamPrepareHeader';
function acmStreamUnprepareHeader; external msacm32 name 'acmStreamUnprepareHeader';

end.
