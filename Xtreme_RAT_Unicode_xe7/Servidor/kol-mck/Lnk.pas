unit Lnk;
{* Additional unit. Has two procedures to get system folder by its CSIDL and
   to create shortcut to the specified file object. Sources are from public place.
   Actually, made on base of sample from MSDN.
   Adapted to use with KOL.

   Last update: 17-May-2007 (with KOL v 2.61)
}

interface

{$I KOLDEF.INC}

uses windows, shlobj, ShellAPI, ActiveX, {OLE2,} KOL;

function GetSystemFolder(Const Folder:integer):string;
{* Returns specified system folder location. Following constant can be passed
   as a parameter:
|<pre>
  CSIDL_DESKTOP            <desktop> (root of namespace)
  CSIDL_PROGRAMS           Start Menu\Programs
  CSIDL_STARTMENU          Settings\username\Start Menu
  CSIDL_PERSONAL           Settings\username\My Documents
  CSIDL_FAVORITES
  CSIDL_STARTUP
  CSIDL_INTERNET
  CSIDL_CONTROLS
  CSIDL_PRINTERS
  CSIDL_RECENT
  CSIDL_SENDTO
  CSIDL_BITBUCKET
|</pre> see other in documentation on API "CSIDL Values" }
function CreateLinkDesc(const FileName,Arguments,WorkDir,IconFile:String;
                    IconNumber:integer; LinkName:String;
                    Description:String
                    ): Boolean;
{* Creates a shortcut with description. }

function CreateLink(const FileName,Arguments,WorkDir,IconFile:String;
                    IconNumber:integer; LinkName:String
                    ): Boolean;
{* Creates a shortcut to specified file object. An example:
!
!  CreateLink( ParamStr( 0 ), '', '', '', 1, GetSystemFolder(CSIDL_DESKTOP)+
!               '\MyProg.lnk' );
}

function ResolveLink( const LinkName: KOLString; var FileName, Arguments, WorkDir,
         Description: KOLString; var IconSmall, IconLarge: HIcon; need_icons: Boolean;
         DialogParentWnd: HWND ): Boolean;
{* Attempts to resolve given link (given by a path to link file). If a link is
   resolved, TRUE returned and FileName, Arguments, WorkDir, Description, Icon(s)
   fields are containing resolved parameters of the link. Set ParentDialogWnd to
   a handle of your window (or 0), if a dialog is allowed to appear if linked
   file is absent (moved or renamed). If DialogParentWnd = THandle(-1) and linked
   file is not found, FALSE is returned silently, without showing dialog box.
   |<br>
   Note: if IconSmall and / or IconLarge are returned <> 0, your code is responsible
   for releasing it calling DestroyIcon function(s). }

function IsLink2RecycleBin( const LinkName: String ): Boolean;
{* Returns TRUE, if the link is a link to Recycle Bin. }

//shlobj.h
//some CSIDL_XXX like CSIDL_PROGRAM_FILES need version 5.00
//(Shlwapi.dll, Microsoft® Internet Explorer 5)
const
 CSIDL_DESKTOP                   =$0000;        // <desktop>
 CSIDL_INTERNET                  =$0001;        // Internet Explorer (icon on desktop)
 CSIDL_PROGRAMS                  =$0002;        // Start Menu\Programs
 CSIDL_CONTROLS                  =$0003;        // My Computer\Control Panel
 CSIDL_PRINTERS                  =$0004;        // My Computer\Printers
 CSIDL_PERSONAL                  =$0005;        // My Documents
 CSIDL_FAVORITES                 =$0006;        // <user name>\Favorites
 CSIDL_STARTUP                   =$0007;        // Start Menu\Programs\Startup
 CSIDL_RECENT                    =$0008;        // <user name>\Recent
 CSIDL_SENDTO                    =$0009;        // <user name>\SendTo
 CSIDL_BITBUCKET                 =$000a;        // <desktop>\Recycle Bin
 CSIDL_STARTMENU                 =$000b;        // <user name>\Start Menu
 CSIDL_MYDOCUMENTS               =$000c;        // logical "My Documents" desktop icon
 CSIDL_MYMUSIC                   =$000d;        // "My Music" folder
 CSIDL_MYVIDEO                   =$000e;        // "My Videos" folder
 CSIDL_DESKTOPDIRECTORY          =$0010;        // <user name>\Desktop
 CSIDL_DRIVES                    =$0011;        // My Computer
 CSIDL_NETWORK                   =$0012;        // Network Neighborhood
 CSIDL_NETHOOD                   =$0013;        // <user name>\nethood
 CSIDL_FONTS                     =$0014;        // windows\fonts
 CSIDL_TEMPLATES                 =$0015;
 CSIDL_COMMON_STARTMENU          =$0016;        // All Users\Start Menu
 CSIDL_COMMON_PROGRAMS           =$0017;        // All Users\Programs
 CSIDL_COMMON_STARTUP            =$0018;        // All Users\Startup
 CSIDL_COMMON_DESKTOPDIRECTORY   =$0019;        // All Users\Desktop
 CSIDL_APPDATA                   =$001a;        // <user name>\Application Data
 CSIDL_PRINTHOOD                 =$001b;        // <user name>\PrintHood
 CSIDL_LOCAL_APPDATA             =$001c;        // <user name>\Local Settings\Applicaiton Data (non roaming)
 CSIDL_ALTSTARTUP                =$001d;        // non localized startup
 CSIDL_COMMON_ALTSTARTUP         =$001e;        // non localized common startup
 CSIDL_COMMON_FAVORITES          =$001f;
 CSIDL_INTERNET_CACHE            =$0020;
 CSIDL_COOKIES                   =$0021;
 CSIDL_HISTORY                   =$0022;
 CSIDL_COMMON_APPDATA            =$0023;        // All Users\Application Data
 CSIDL_WINDOWS                   =$0024;        // GetWindowsDirectory()
 CSIDL_SYSTEM                    =$0025;        // GetSystemDirectory()
 CSIDL_PROGRAM_FILES             =$0026;        // C:\Program Files
 CSIDL_MYPICTURES                =$0027;        // C:\Program Files\My Pictures
 CSIDL_PROFILE                   =$0028;        // USERPROFILE
 CSIDL_SYSTEMX86                 =$0029;        // x86 system directory on RISC
 CSIDL_PROGRAM_FILESX86          =$002a;        // x86 C:\Program Files on RISC
 CSIDL_PROGRAM_FILES_COMMON      =$002b;        // C:\Program Files\Common
 CSIDL_PROGRAM_FILES_COMMONX86   =$002c;        // x86 Program Files\Common on RISC
 CSIDL_COMMON_TEMPLATES          =$002d;        // All Users\Templates
 CSIDL_COMMON_DOCUMENTS          =$002e;        // All Users\Documents
 CSIDL_COMMON_ADMINTOOLS         =$002f;        // All Users\Start Menu\Programs\Administrative Tools
 CSIDL_ADMINTOOLS                =$0030;        // <user name>\Start Menu\Programs\Administrative Tools
 CSIDL_CONNECTIONS               =$0031;        // Network and Dial-up Connections

 CSIDL_FLAG_CREATE               =$8000;        // combine with CSIDL_ value to force folder creation in SHGetFolderPath()
 CSIDL_FLAG_DONT_VERIFY          =$4000;        // combine with CSIDL_ value to return an unverified folder path
 CSIDL_FLAG_NO_ALIAS             =$1000;        // combine with CSIDL_ value to insure non-alias versions of the pidl
 CSIDL_FLAG_MASK                 =$FF00;        // mask for all possible flag values

procedure FileTypeReg(FExt,Desc,Cmd,Exe: string; IconIndex: integer; Default,Run: boolean);
{* By Dimaxx. Registers file type association.
   |<pre>
   FExt - file extension                  расширение файла
   Desc - file type description           описание типа файла
   Cmd  - context menu command            команда для контекстного меню
   Exe  - path to executable              путь к исполняемому файлу
   Default - if command is default        назначается действием по умолчанию
   Run  - if reaction needed when clicked нужны ли действия при щелчке на файле с таким расширением
   |</pre>
   Example:
   ! FileTypeReg('.abc','ABC Data File','Open','d:\abc_edit.exe',True);
}
function FileTypeGetReg(const FExt,Cmd: KOLString; var Desc, OldIcoExe: KOLString;
         var OldIcoIdx: Integer; var OldId: KOLString ): KOLString;
{* Get registered file type association, if any (by command).
   |<pre>
   in:
   FExt - file extension                  расширение файла
   Cmd  - context menu command            команда для контекстного меню
   out:
   Desc - file type description           описание типа файла
   Result - path to executable            путь к исполняемому файлу
   |</pre>
   Shell is always notified about file association changes. See also FileTypeRegEx.
}
procedure FileTypeRegEx(FExt,Desc,Cmd,Exe: string; IconIndex: integer; Default,Run: boolean;
          const IcoExe: String; NotifyShell: Boolean );
{* The same as FileTypeReg, but additional parameters are available:
   IcoExe - file where the icon is stored;
   NotifyShell - TRUE if to notify shell about changes. }

procedure FileTypeReg2(FExt,Desc,Cmd,Exe,Id: string;
          IconIndex: integer; Default,Run: boolean;
          const IcoExe: String; DfltIcoExe: String; NotifyShell: Boolean );
{* The same as above (FileTypeRegEx), but should also work in XP.
   Provide ID string in form 'Vendor.Appname.Version', e.g. 'Litcorp Inc.My App.5'.
   DfltIcoExe and DfltIcoIndex are used to set default application icon,
   this does affect associations of other files with the application,
   not having its own DefaultIcon settings in the registry. }

function FileTypeReg2Ex(FExt,Desc,Cmd,Exe,Id: string;
          IconIndex: integer; Default,Run: boolean;
          const IcoExe: String; DfltIcoExe: String; NotifyShell: Boolean ): String;
{* The same as above (FileTypeReg2), but also returs a string which can be
   passed later to FileTypeUnreg as a parameter to undo registration to a
   previous state. }

procedure FileTypeUnreg( const UndoStr: String; NotifyShell: Boolean );
{* Pass as UndoStr a string returned by FileTypeReg2Ex to undo the association
   made with it. }


function RegKeyDeleteAll( Key: HKey; const Subkey: KOLString ): Boolean;
{* In addition to RegKeyXXXXX functions in KOL.pas, allows to delete entire
   key with all nested keys and values (careful, please!) }

implementation

function GetSystemFolder(Const Folder:integer):string;
var
 PIDL: PItemIDList;
 Path: array[ 0..MAX_PATH ] of Char;
begin
  Result := '';
  if SHGetSpecialFolderLocation(0, Folder, PIDL) = NOERROR then
  begin
    if SHGetPathFromIDList(PIDL, Path) then Result := IncludeTrailingPathDelimiter( Path );
    CoTaskMemFree( PIDL );
  end;
end;

const
  IID_IPersistFile: TGUID = (
    D1:$0000010B;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

function CreateLink(const FileName,Arguments,WorkDir,IconFile:String;
                    IconNumber:integer; LinkName:String ): Boolean;
begin
  Result := CreateLinkDesc( FileName, Arguments, WorkDir, IconFile, IconNumber,
         LinkName, '' );
end;

function CreateLinkDesc(const FileName,Arguments,WorkDir,IconFile:String;
                    IconNumber:integer; LinkName:String;
                    Description:String): Boolean;
var
  SLink   : IShellLink;
  PFile   : IPersistFile;
  WFileName : WideString;
begin
  Result := FALSE;
  CoInitialize( nil );
  if CoCreateInstance( TGUID( CLSID_ShellLink ), nil, CLSCTX_INPROC_SERVER,
                       TGUID( IID_IShellLinkA ), SLink ) <> S_OK then Exit;
  if SLink.QueryInterface( System.TGUID( IID_IPersistFile ), PFile ) <> S_OK then Exit;
  SLink.SetArguments(PChar(Arguments));
  SLink.SetPath(PChar(FileName));
  SLink.SetWorkingDirectory(PChar(WorkDir));
  SLink.SetDescription(PChar(Description));
  SLink.SetIconLocation(PChar(IconFile),IconNumber);
  if not DirectoryExists(ExtractFilePath(LinkName)) then
    CreateDir( ExtractFilePath(LinkName) );
  WFileName := LinkName;
  PFile.Save(PWChar(WFileName),False);
  Result := TRUE;
end;

{$IFDEF UNICODE_CTRLS}
type IShellLink_ = IShellLinkW;
{$ELSE}
type IShellLink_ = IShellLinkA;
{$ENDIF}
function ResolveLink( const LinkName: KOLString; var FileName, Arguments, WorkDir,
         Description: KOLString; var IconSmall, IconLarge: HIcon; need_icons: Boolean;
         DialogParentWnd: HWND ): Boolean;
var
  SLink   : IShellLink_;
  PFile   : IPersistFile;
  WFileName : WideString;
  Wnd: HWnd;
  Flg: DWORD;
  Buf: array[ 0..4095 ] of KOLChar;
  FD: TWin32FindData;
  I: Integer;
begin
  Result := FALSE;
  CoInitialize( nil );
  if  CoCreateInstance( TGUID( CLSID_ShellLink ), nil, CLSCTX_INPROC_SERVER,
                        TGUID( IID_IShellLinkA ), SLink ) <> S_OK then Exit;
  if  SLink.QueryInterface( System.TGUID( IID_IPersistFile ), PFile )
      <> S_OK then Exit;
  WFileName := LinkName;
  PFile.Load(PWChar(WFileName),STGM_READ);
  Wnd := DialogParentWnd;
  if  Wnd = THandle( -1 ) then
      Wnd := 0;
  Flg := SLR_UPDATE;
  if  DialogParentWnd = THandle(-1) then
      Flg := SLR_NO_UI;
  if  SLink.Resolve( Wnd, Flg ) = NOERROR then
  begin
    if   SLink.GetPath( Buf, Sizeof( Buf ) div Sizeof( KOLChar ),
         PWin32FindDataA(@ FD)^ {error in ShlObj.pas !}
         , 0 ) <> NOERROR then
         FileName := ''
    else FileName := Buf;
    if SLink.GetArguments( Buf, Sizeof( Buf ) ) <> NOERROR then Exit;
    Arguments := Buf;
    if  SLink.GetWorkingDirectory( Buf, Sizeof( Buf ) div Sizeof( KOLChar ) )
        <> NOERROR then Exit;
    WorkDir := Buf;
    if  SLink.GetDescription( Buf, Sizeof( Buf ) div Sizeof( KOLChar ) )
        <> NOERROR then Exit;
    Description := Buf;
    IconSmall := 0;
    IconLarge := 0;
    if  need_icons
    and (SLink.GetIconLocation( Buf, Sizeof( Buf ) div Sizeof( KOLChar ), I )
        = NOERROR) then
        {$IFDEF UNICODE_CTRLS}
        ExtractIconExW( Buf, I, IconLarge, IconSmall, 1 );
        {$ELSE}
        ExtractIconExA( Buf, I, IconLarge, IconSmall, 1 );
        {$ENDIF}
    Result := TRUE;
  end;
end;

function IsLink2RecycleBin( const LinkName: String ): Boolean;
var
  SLink   : IShellLink;
  PFile   : IPersistFile;
  WFileName : WideString;
  Flg: DWORD;
  ppidl, ppidl1, p, p1: PItemIDList;
begin
  Result := FALSE;
  CoInitialize( nil );
  if CoCreateInstance( TGUID( CLSID_ShellLink ), nil, CLSCTX_INPROC_SERVER,
                       TGUID( IID_IShellLinkA ), SLink ) <> S_OK then Exit;
  if SLink.QueryInterface( System.TGUID( IID_IPersistFile ), PFile ) <> S_OK then Exit;
  WFileName := LinkName;
  PFile.Load(PWChar(WFileName),STGM_READ);
  Flg := SLR_NO_UI;
  if SLink.Resolve( 0, Flg ) = NOERROR then
  begin
    if SLink.GetIDList( ppidl ) = NOERROR then
    begin
      if SHGetSpecialFolderLocation( 0, CSIDL_BITBUCKET, ppidl1 ) = NOERROR then
      begin
        Result := TRUE;
        p := ppidl;
        p1 := ppidl1;
        while TRUE do
        begin
          if (p1.mkid.cb = p.mkid.cb) and (p1.mkid.cb = 0) then
            break;
          if (p1.mkid.cb <> p.mkid.cb) or
             not CompareMem( @ p.mkid.abID[ 0 ], @ p1.mkid.abID[ 0 ],
                         p.mkid.cb ) then
          begin
            Result := FALSE;
            break;
          end;
          p := Pointer( Integer( p ) + p.mkid.cb );
          p1 := Pointer( Integer( p1 ) + p1.mkid.cb );
        end;
        CoTaskMemFree( ppidl1 );
      end;
      CoTaskMemFree( ppidl );
    end;
  end;
end;

function RegKeyDeleteAll( Key: HKey; const Subkey: KOLString ): Boolean;
type TSHDeleteKey = function( Key: HKey; Subkey: PKOLChar ): DWORD; stdcall;
var SHDeleteKey: TSHDeleteKey;
    M: THandle;
begin
  Result := FALSE;
  M := LoadLibrary( 'shlwapi.dll' );
  if M <> 0 then
  TRY
    SHDeleteKey := GetProcAddress( M,
      {$IFDEF UNICODE_CTRLS} 'SHDeleteKeyW' {$ELSE} 'SHDeleteKeyA' {$ENDIF} );
    if Assigned( SHDeleteKey ) then
      Result := SHDeleteKey( Key, PKOLChar( SubKey ) ) = 0;
  FINALLY
    FreeLibrary( M );
  END;
end;

procedure FileTypeRegEx(FExt,Desc,Cmd,Exe: string; IconIndex: integer; Default,Run: boolean;
          const IcoExe: String; NotifyShell: Boolean );
begin
  FileTypeRegEx( FExt, Desc, Cmd, Exe, IconIndex,
                  Default, Run, IcoExe, NotifyShell );
end;

//[procedure FileTypeReg]
procedure FileTypeReg(FExt,Desc,Cmd,Exe: string; IconIndex: integer; Default,Run: boolean);
begin
  FileTypeRegEx( Fext,Desc,Cmd,Exe, IconIndex, Default, Run, Exe, TRUE );
end;

procedure FileTypeReg2(FExt,Desc,Cmd,Exe,Id: string;
          IconIndex: integer;
          Default,Run: boolean;
          const IcoExe: String; DfltIcoExe: String; NotifyShell: Boolean );
var Reg: HKey;
    Key: string;
begin
  Reg:=RegKeyOpenWrite(HKEY_CLASSES_ROOT,'Applications');
  //if not RegKeyExists(Reg,ExtractFileName(Exe)) then
    begin
      RegKeyClose(Reg);
      Reg := RegKeyOpenCreate(HKEY_CLASSES_ROOT,
          'Applications\'+ExtractFileName(Exe)+'\Shell\Open\Command');
      RegKeySetStr(Reg,'',Exe+' "%1"');
      RegKeyClose(Reg);
    end;
  //else RegKeyClose( Reg ); // {VK}

  if Id <> '' then
  begin
    Reg := RegKeyOpenCreate(HKEY_CURRENT_USER,
      'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' + FExt);
    RegKeySetStr( Reg, 'Progid', Id );
    RegKeyClose( Reg );
  end;

  // HKCR\.ext  Default=extfile
  Reg:=RegKeyOpenCreate(HKEY_CLASSES_ROOT,FExt);
  Key:=LowerCase(FExt)+'file';
  Delete(Key,1,1);
  RegKeySetStr(Reg,'',Key);
  RegKeyClose(Reg);

  // HKCR\extfile  Default=id
  if Id <> '' then
  begin
    Reg:=RegKeyOpenCreate(HKEY_CLASSES_ROOT,Key);
    RegKeySetStr(Reg,'',Id);
    RegKeyClose(Reg);
  end;

  // HKCR\id Default=pathto.exe
  if Id <> '' then
  begin
    Reg:=RegKeyOpenCreate(HKEY_CLASSES_ROOT,Id);
    RegKeySetStr(Reg,'',Exe);
    RegKeyClose(Reg);
  end;

  if DfltIcoExe <> '' then
  begin
    // HKCR\id\DefaultIcon   Default=DfltIcoExe
    Reg := RegKeyOpenCreate(HKEY_CLASSES_ROOT,Id + '\DefaultIcon');
    RegKeySetStr(Reg,'',DfltIcoExe);
    RegKeyClose( Reg );
  end;

  if (IcoExe <> '') {or (IconIndex<>-1)} then
    begin
      Reg:=RegKeyOpenCreate(HKEY_CLASSES_ROOT,Key+'\DefaultIcon');
      if IconIndex = -1 then
           RegKeySetStr(Reg,'',IcoExe + ',0' )
      else RegKeySetStr(Reg,'',IcoExe + ',' + Int2Str(IconIndex) );
      RegKeyClose(Reg);
    end;
  if Run then
    begin
      {Reg:=RegKeyOpenCreate(HKEY_CLASSES_ROOT,Key+'\Shell');
      if Default then RegKeySetStr(Reg,'',Cmd)
                 else RegKeySetStr(Reg,'','');
      RegKeyClose(Reg);
      Reg:=RegKeyOpenCreate(HKEY_CLASSES_ROOT,Key+'\Shell\'+Cmd);
      RegKeyClose(Reg);}
      {$IFNDEF LNK_NODELETE_OLDCMD}
      Reg := RegKeyOpenCreate(HKEY_CLASSES_ROOT,Key+'\Shell\');
      RegKeyDeleteAll( Reg, Cmd );
      if Default then
        RegKeySetStr(Reg,'',Cmd);
      RegKeyClose( Reg );
      {$ENDIF}

      Reg:=RegKeyOpenCreate(HKEY_CLASSES_ROOT,Key+'\Shell\'+Cmd+'\Command');
      RegKeySetStr(Reg,'',Exe+' "%1"');
      RegKeyClose(Reg);
    end;
  //+ {VK}
  if NotifyShell then
  begin
    SHChangeNotify( SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil );
    //SHChangeNotify( SHCNE_ALLEVENTS, SHCNF_IDLIST, nil, nil );
  end;
end;

function FileTypeReg2Ex(FExt,Desc,Cmd,Exe,Id: string;
          IconIndex: integer; Default,Run: boolean;
          const IcoExe: String; DfltIcoExe: String; NotifyShell: Boolean ): String;
var Reg: HKey;
    Key: string;
    Strm: PStream;

  procedure add4Undo( const RegClass, RegKey, Cmd, Value: String );
  var s: String;
  begin
    s := RegClass+',';
    if RegKey <> '' then
      s := s +Int2Str(Length(RegKey))+'('+RegKey+'),';
    s := s+Cmd;
    if Value <> '' then
      s := s + ',' + Int2Str(Length(Value))+'('+Value+')';
    Strm.WriteStr( s+#13 );
  end;

  procedure DeleteAllSubKeys( const RegClass, RegKey: String; Reg: THandle; const SubKey: String );
  var SL: PKOLStrList;
      i: Integer;
      Reg1: THandle;
      procedure not_supported;
      asm
        nop
      end;
  begin
    SL := NewKOLStrList;
    Reg1 := RegKeyOpenWrite( Reg, SubKey );
    TRY
      RegKeyGetSubKeys(Reg1, SL);
      for i := 0 to SL.Count-1 do
      begin
        DeleteAllSubKeys( RegClass, RegKey + '\' + SL.Items[ i ], Reg1, SL.Items[ i ] );
      end;
      SL.Clear;
      RegKeyGetValueNames( Reg1, SL );
      for i := 0 to SL.Count-1 do
      begin //todo: support more types of values
        CASE RegKeyGetValueTyp(Reg1, SL.Items[ i ]) OF
        REG_BINARY: not_supported;
        REG_DWORD : // = REG_DWORD_LITTLE_ENDIAN
          add4Undo( RegClass, RegKey, 'd=' + SL.Items[i], Int2Str( RegKeyGetDw(Reg1,SL.Items[i]) ) );
        REG_DWORD_BIG_ENDIAN:
          add4Undo( RegClass, RegKey, 'D=' + SL.Items[i], Int2Str( RegKeyGetDw(Reg1,SL.Items[i]) ) );
        REG_EXPAND_SZ:
          add4Undo( RegClass, RegKey, 'X=' + SL.Items[i], RegKeyGetStr(Reg1,SL.Items[i]) );
        REG_LINK: not_supported;
        REG_MULTI_SZ: not_supported;
        REG_NONE: not_supported;
        REG_RESOURCE_LIST: not_supported;
        REG_SZ:
          add4Undo( RegClass, RegKey, 'S=' + SL.Items[i], RegKeyGetStr(Reg1,SL.Items[i]) );
        END;
      end;
    FINALLY
      SL.Free;
      RegKeyClose( Reg1 );
      add4Undo( RegClass, RegKey, 'K-', SubKey );
      RegKeyDelete( Reg, SubKey );
    END;
  end;

  function q( const s: String ): String;
  begin
    if pos( ' ', s ) > 0 then Result := '"' + s + '"'
    else Result := s;
  end;

begin
  Result := '';
  Strm := NewMemoryStream;
  TRY

    Reg:=RegKeyOpenWrite(HKEY_CLASSES_ROOT,'Applications');
    if not RegKeyExists( Reg, ExtractFileName(Exe) ) then
      add4Undo( 'HKCR', 'Applications', 'K+',
                ExtractFileName(Exe)+'\Shell\Open\Command' );
    //if not RegKeyExists(Reg,ExtractFileName(Exe)) then
      begin
        RegKeyClose(Reg);
        Reg := RegKeyOpenCreate(HKEY_CLASSES_ROOT,
            'Applications\'+ExtractFileName(Exe)+'\Shell\Open\Command');
        add4Undo( 'HKCR',
                    'Applications\'+ExtractFileName(Exe)+'\Shell\Open\Command',
                    'S=', RegKeyGetStr(Reg,'') );
        RegKeySetStr(Reg,'',q(Exe)+' "%1"');
        RegKeyClose(Reg);
      end;
    //else RegKeyClose( Reg ); // {VK}

    if Id <> '' then
    begin
      if not RegKeyExists( HKEY_CURRENT_USER,
         'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' + FExt ) then
         add4Undo( 'HKCU', '', 'K+',
           'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' + FExt );
      Reg := RegKeyOpenCreate(HKEY_CURRENT_USER,
        'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' + FExt);
      if not RegKeyValExists( Reg, 'ProgId' ) then
        add4Undo( 'HKCU',
          'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' + FExt,
          'V+', 'ProgId' )
      else
        add4Undo( 'HKCU',
          'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' + FExt,
          'S=ProgId', RegKeyGetStr(Reg,'ProgId') );
      RegKeySetStr( Reg, 'Progid', Id );
      RegKeyClose( Reg );
    end;

    // HKCR\.ext  Default=extfile
    if not RegKeyExists( HKEY_CLASSES_ROOT, FExt ) then
      add4Undo( 'HKCR', '', 'K+', FExt );
    Reg:=RegKeyOpenCreate(HKEY_CLASSES_ROOT,FExt);
    Key:=LowerCase(FExt)+'file';
    Delete(Key,1,1);
    add4Undo( 'HKCR', FExt, 'S=', RegKeyGetStr( Reg, '' ) );
    RegKeySetStr(Reg,'',Key);
    RegKeyClose(Reg);

    // HKCR\extfile  Default=id
    if Id <> '' then
    begin
      if not RegKeyExists( HKEY_CLASSES_ROOT, Key ) then
        add4Undo( 'HKCR', '', 'K+', Key );
      Reg:=RegKeyOpenCreate(HKEY_CLASSES_ROOT,Key);
      add4Undo( 'HKCR', Key, 'S=', RegKeyGetStr( Reg, '' ) );
      RegKeySetStr(Reg,'',Id);
      RegKeyClose(Reg);
    end;

    // HKCR\id Default=pathto.exe
    if Id <> '' then
    begin
      if not RegKeyExists( HKEY_CLASSES_ROOT, Id ) then
        add4Undo( 'HKCR', '', 'K+', Id );
      Reg:=RegKeyOpenCreate(HKEY_CLASSES_ROOT,Id);
      add4Undo( 'HKCR', Id, 'S=', RegKeyGetStr( Reg, '' ) );
      RegKeySetStr(Reg,'',Exe);
      RegKeyClose(Reg);
    end;

    if DfltIcoExe <> '' then
    begin
      // HKCR\id\DefaultIcon   Default=DfltIcoExe
      if not RegKeyExists( HKEY_CLASSES_ROOT, Id + '\DefaultIcon' ) then
        add4Undo( 'HKCR', '', 'K+', Id + '\DefaultIcon' );
      Reg := RegKeyOpenCreate(HKEY_CLASSES_ROOT,Id + '\DefaultIcon');
      add4Undo( 'HKCR', Id+'\DefaultIcon', 'S=', RegKeyGetStr( Reg, '' ) );
      RegKeySetStr(Reg,'',DfltIcoExe);
      RegKeyClose( Reg );
    end;

    if (IcoExe <> '') then
      begin
        if not RegKeyExists( HKEY_CLASSES_ROOT, Key + '\DefaultIcon' ) then
          add4Undo( 'HKCR', '', 'K+', Key + '\DefaultIcon' );
        Reg:=RegKeyOpenCreate(HKEY_CLASSES_ROOT,Key+'\DefaultIcon');
        add4Undo( 'HKCR', Key+'\DefaultIcon', 'S=', RegKeyGetStr( Reg, '' ) );
        if IconIndex = -1 then
             RegKeySetStr(Reg,'',IcoExe + ',0' )
        else
             RegKeySetStr(Reg,'',IcoExe + ',' + Int2Str(IconIndex) );
        RegKeyClose(Reg);
      end;
    if Run then
      begin
        {$IFNDEF LNK_NODELETE_OLDCMD}
        if not RegKeyExists( HKEY_CLASSES_ROOT, Key + '\Shell' ) then
          add4Undo( 'HKCR', '', 'K+', Key + '\Shell' );
        Reg := RegKeyOpenCreate(HKEY_CLASSES_ROOT,Key+'\Shell\');
        DeleteAllSubKeys( 'HKCR', Key + '\Shell', Reg, Cmd );
        if Default then
        begin
          add4Undo( 'HKCR', Key+'\Shell', 'S=', RegKeyGetStr( Reg, '' ) );
          RegKeySetStr(Reg,'',Cmd);
        end;
        RegKeyClose( Reg );
        {$ENDIF}

        if not RegKeyExists( HKEY_CLASSES_ROOT, Key+'\Shell\'+Cmd+'\Command' ) then
          add4Undo( 'HKCR', '', 'K+', Key+'\Shell\'+Cmd+'\Command' );
        Reg:=RegKeyOpenCreate(HKEY_CLASSES_ROOT,Key+'\Shell\'+Cmd+'\Command');
        add4Undo( 'HKCR', Key+'\Shell\'+Cmd+'\Command', 'S=', RegKeyGetStr( Reg, '' ) );
        RegKeySetStr(Reg,'',Exe+' "%1"');
        RegKeyClose(Reg);
      end;
    if NotifyShell then
      SHChangeNotify( SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil );
    SetString( Result, PChar( Strm.Memory ), Strm.Size );
  FINALLY
    Strm.Free;
  END;
end;

procedure FileTypeUnreg( const UndoStr: String; NotifyShell: Boolean );
var SL: PStrList;
    i: Integer;
    s: KOLString;
    RegClass, RegKey, Cmd, Value, ValName: KOLString;
    R: THandle;
    Cls: DWORD;
    procedure ExtractStr( var s: KOLString );
    var i: Integer;
    begin
      if s = '' then Exit;
      i := Str2Int( s );
      if i = 0 then Exit;
      Parse( s, '(' );
      s := Copy( s, 1, i );
    end;
begin
  SL := NewStrList;
  TRY
    SL.Text := UndoStr;
    for i := SL.Count-1 downto 0 do
    begin
      s := SL.Items[ i ];
      RegClass := Parse( S, ',' );
      RegKey := Parse( S, ',' );
      ExtractStr( RegKey );
      Cmd := Parse( s, ',' );
      Value := s; ExtractStr( Value );
      if RegClass = 'HKCU' then Cls := HKEY_CURRENT_USER
      else if RegClass = 'HKLM' then Cls := HKEY_LOCAL_MACHINE
      else if RegClass = 'HKCR' then Cls := HKEY_CLASSES_ROOT
      else Cls := HKEY_CURRENT_USER;
      if Cmd = 'K+' then // удалить ключ
        RegKeyDelete( Cls, RegKey )
      else
      if Cmd = 'K-' then // восстановить ключ
      begin
        R := RegKeyOpenCreate( Cls, RegKey + '\' + Value );
        RegKeyClose( R );
      end
        else
      begin
        R := RegKeyOpenWrite( Cls, RegKey );
        ValName := CopyEnd( Cmd, 3 );
        TRY
          if Cmd = 'V+' then // удалить значение
            RegKeyDeleteValue( R, Value )
          else if Cmd[1] = 'S' then // восстановить строковое значение
            RegKeySetStr( R, ValName, Value )
          else if Cmd[1] = 'd' then // восстановить значение типа DWORD:
            RegKeySetDw( R, ValName, Str2Int( Value ) )
          else if Cmd[1] = 'X' then
            RegKeySetStrEx( R, ValName, Value, TRUE );
        FINALLY
          RegKeyClose( R );
        END;
      end;
    end;
    if NotifyShell then
      SHChangeNotify( SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil );
  FINALLY
    SL.Free;
  END;
end;

function FileTypeGetReg(const FExt,Cmd: KOLString; var Desc, OldIcoExe: KOLString;
         var OldIcoIdx: Integer; var OldId: KOLString ): KOLString;
var Reg: HKey;
    Key: KOLString;
    S: KOLString;
begin
  Result := '';
  Desc := '';
  Reg := RegKeyOpenRead(HKEY_CLASSES_ROOT,FExt);
  if Reg = 0 then Exit;
  OldId := RegKeyGetStr( Reg, '' );
  Key:=LowerCase(FExt)+'file';
  Delete(Key,1,1);
  Key := RegKeyGetStr(Reg,'');
  RegKeyClose(Reg);

  Reg:=RegKeyOpenRead(HKEY_CLASSES_ROOT,Key);
  Desc := RegKeyGetStr(Reg,'');
  RegKeyClose(Reg);

  Reg:=RegKeyOpenRead(HKEY_CLASSES_ROOT,Key+'\Shell\'+Cmd+'\Command');
  Result := Trim( RegKeyGetStr(Reg,'') );
  RegKeyClose(Reg);

  if CopyTail( Result, 4 ) = '"%1"' then
    Result := Trim( Copy( Result, 1, Length( Result )-4 ) );

  Reg:=RegKeyOpenRead(HKEY_CLASSES_ROOT,Key+'\DefaultIcon');
  S := RegKeyGetStr(Reg,'' );
  OldIcoExe := Parse( S, ',' );
  OldIcoIdx := Str2Int( S );
  RegKeyClose(Reg);
end;


end.
