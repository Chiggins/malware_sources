unit UnitUnZip;

interface 

uses
  Comobj,
  Windows,
  Variants,
  ActiveX;

function UnZipFile(FullSourceFile, FullDestDir: WideString): boolean;

implementation

type
  TShellZip = class(TObject)
  private
    FFilter: string;
    FZipfile: WideString;
    shellobj: Olevariant;
    function GetNameSpaceObj(x: OleVariant): OleVariant;
    function GetNameSpaceObj_zipfile: OleVariant;
  public
     function Unzip(const targetfolder: WideString): boolean;
     property Zipfile: WideString read FZipfile write FZipfile;
     property Filter: string read FFilter write FFilter;
  end;

const
  SHCONTCH_NOPROGRESSBOX = 4;
  SHCONTCH_AUTORENAME = 8;
  SHCONTCH_RESPONDYESTOALL = 16;
  SHCONTF_INCLUDEHIDDEN = 128;
  SHCONTF_FOLDERS = 32;
  SHCONTF_NONFOLDERS = 64;

function IsValidDispatch(const v: OleVariant):Boolean;
begin
  result := (VarType(v) = varDispatch) and Assigned(TVarData(v).VDispatch);
end;

function TShellZip.GetNameSpaceObj(x: OleVariant): OleVariant;
begin
  Result := shellobj.NameSpace(x);
end;

function TShellZip.GetNameSpaceObj_zipfile: OleVariant;
begin
  Result := GetNameSpaceObj(Zipfile);
  if not IsValidDispatch(Result) then Exit;
end;

function TShellZip.Unzip(const targetfolder: WideString): boolean;
var
  srcfldr, destfldr: Olevariant;
  shellfldritems: Olevariant;
begin
  Result := False;
  shellobj := CreateOleObject('Shell.Application');

  srcfldr := GetNameSpaceObj_zipfile;

  destfldr := GetNameSpaceObj(targetfolder);
  if not IsValidDispatch(destfldr) then Exit;

  shellfldritems := srcfldr.Items;
  if (filter <> '') then shellfldritems.Filter(SHCONTF_INCLUDEHIDDEN or SHCONTF_NONFOLDERS or SHCONTF_FOLDERS,filter);

  destfldr.CopyHere(shellfldritems, SHCONTCH_NOPROGRESSBOX or SHCONTCH_RESPONDYESTOALL);
  Result := True;
end;

function DirectoryExists(Directory: PWideChar): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributesW(Directory);
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function ForceDirectories(path: PWideChar): boolean;
var
  Base, Resultado: array [0..MAX_PATH * 2] of WideChar;
  i, j, k: cardinal;
begin
  result := true;
  if DirectoryExists(path) then exit;

  if path <> nil then
  begin
    i := lstrlenw(Path) * 2;
    move(path^, Base, i);

    for k := i to (MAX_PATH * 2) - 1 do Base[k] := #0;
    for k := 0 to (MAX_PATH * 2) - 1 do Resultado[k] := #0;

    j := 0;
    Resultado[j] := Base[j];

    while Base[j] <> #0 do
    begin
      while (Base[j] <> '\') and (Base[j] <> #0) do
      begin
        Resultado[j] := Base[j];
        inc(j);
      end;
      Resultado[j] := Base[j];
      inc(j);

      if DirectoryExists(Resultado) then continue else
      begin
        CreateDirectoryW(Resultado, nil);
        if DirectoryExists(path) then break;
      end;
    end;
  end;
  Result := DirectoryExists(path);
end;

function UnZipFile(FullSourceFile, FullDestDir: WideString): boolean;
var
  ShellZip: TShellZip;
begin
  Result := False;
  if DirectoryExists(pwChar(FullDestDir)) = False then ForceDirectories(pwChar(FullDestDir));
  CoInitialize(nil);
  ShellZip := TShellZip.Create;
  ShellZip.FZipfile := FullSourceFile;
  result := ShellZip.Unzip(FullDestDir);
  ShellZip.Free;
  CoUnInitialize;
end;

end.

