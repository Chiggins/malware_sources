unit Resources;
////////////////////////////////////////////////////////////////////////////////
//
//   Unit        :  Resources
//   Author      :  rllibby
//   Date        :  02.07.2008
//   Description :  Source code for PE resource enumeration and misc handling
//
////////////////////////////////////////////////////////////////////////////////
interface

{ Example usage:

var  lpResources:   TPEResources;
     dwIndex:       Integer;
begin

  // Testing code
  if (CopyFile('c:\windows\system32\calc.exe', 'c:\calc.exe', False)) then
  begin
     // Create resource object list
     lpResources:=TPEResources.Create('c:\calc.exe');
     try
        // Remove the resource
        lpResources.Remove(RT_MANIFEST, MakeIntResource(1));
        lpResources.Remove(RT_VERSION, MakeIntResource(1));
        lpResources.Remove(RT_GROUP_ICON, 'SC');
        for dwIndex:=1 to 6 do
        begin
           lpResources.Remove(RT_STRING, MakeIntResource(dwIndex));
        end;
     finally
        // Free object
        lpResources.Free;
     end;
  end;

end;

}

////////////////////////////////////////////////////////////////////////////////
//   Include units
////////////////////////////////////////////////////////////////////////////////
uses
  Windows, SysUtils, Classes;

////////////////////////////////////////////////////////////////////////////////
//   Data types
////////////////////////////////////////////////////////////////////////////////
type
  TResNameID        =  packed record
     Name:          PChar;
     ID:            PChar;
  end;

////////////////////////////////////////////////////////////////////////////////
//   Updated list of predefined resource types
////////////////////////////////////////////////////////////////////////////////
const

  // Missing predefined types
  RT_HTML           =  MakeIntResource(23);
  RT_MANIFEST       =  MakeIntResource(24);

  // Maximum predefined value
  RT_MAX_PREDEFINE  =  24;

  // List of predefined types with associated name
  RT_PREDEFINED:    Array [0..RT_MAX_PREDEFINE] of TResNameID  =
                    (
                       (Name: '#0';               ID: MakeIntResource(0)),
                       (Name: 'Cursor';           ID: RT_CURSOR),
                       (Name: 'Bitmap';           ID: RT_BITMAP),
                       (Name: 'Icon';             ID: RT_ICON),
                       (Name: 'Menu';             ID: RT_MENU),
                       (Name: 'Dialog';           ID: RT_DIALOG),
                       (Name: 'String';           ID: RT_STRING),
                       (Name: 'Fonts';            ID: RT_FONTDIR),
                       (Name: 'Font';             ID: RT_FONT),
                       (Name: 'Accelerator';      ID: RT_ACCELERATOR),
                       (Name: 'Data';             ID: RT_RCDATA),
                       (Name: 'Message Table';    ID: RT_MESSAGETABLE),
                       (Name: 'Group Cursor';     ID: RT_GROUP_CURSOR),
                       (Name: '#13';              ID: MakeIntResource(13)),
                       (Name: 'Group Icon';       ID: RT_GROUP_ICON),
                       (Name: '#15';              ID: MakeIntResource(15)),
                       (Name: 'Version';          ID: RT_VERSION),
                       (Name: 'Dialog';           ID: RT_DLGINCLUDE),
                       (Name: '#18';              ID: MakeIntResource(18)),
                       (Name: 'Plug And Play';    ID: RT_PLUGPLAY),
                       (Name: 'VXD';              ID: RT_VXD),
                       (Name: 'Animated Cursor';  ID: RT_ANICURSOR),
                       (Name: 'Animated Icon';    ID: RT_ANIICON),
                       (Name: 'Html';             ID: RT_HTML),
                       (Name: 'Manifest';         ID: RT_MANIFEST)
                    );

////////////////////////////////////////////////////////////////////////////////
//   PE Resource objects
////////////////////////////////////////////////////////////////////////////////
type

  // Resource object
  TPEResource       =  class(TObject)
  private
     // Private declarations
     FName:         PChar;
     FType:         PChar;
     FLanguages:    TList;
  protected
     // Protected declarations
     procedure      Load(Module: HMODULE);
     function       GetLanguages(Index: Integer): Word;
     function       GetLanguageCount: Integer;
  public
     // Public declarations
     constructor    Create(AModule: HMODULE; AName, AType: PChar);
     destructor     Destroy; override;
     property       Languages[Index: Integer]: Word read GetLanguages;
     property       LanguageCount: Integer read GetLanguageCount;
     property       ResName: PChar read FName;
     property       ResType: PChar read FType;
  end;

  // Resource group object
  TPEResourceGroup  =  class(TObject)
  private
     // Private declarations
     FType:         PChar;
     FResources:    TList;
  protected
     // Protected declarations
     procedure      Clear;
     procedure      Load(Module: HMODULE);
     procedure      Remove(Obj: TObject);
     function       GetResources(Index: Integer): TPEResource;
     function       GetResourceCount: Integer;
     function       GetResTypeName: String;
  public
     // Public declarations
     constructor    Create(AModule: HMODULE; AType: PChar);
     destructor     Destroy; override;
     function       Find(ResourceName: PChar): TPEResource;
     property       ResType: PChar read FType;
     property       ResTypeName: String read GetResTypeName;
     property       Resources[Index: Integer]: TPEResource read GetResources;
     property       ResourceCount: Integer read GetResourceCount;
  end;

  // Resource container
  TPEResources      =  class(TObject)
  private
     // Private declarations
     FLibFileName:  String;
     FGroups:       TList;
  protected
     // Protected declarations
     procedure      Clear;
     procedure      Load(LibFileName: String);
     function       GetGroupCount: Integer;
     function       GetGroups(Index: Integer): TPEResourceGroup;
  public
     // Public declarations
     constructor    Create(LibFileName: String);
     destructor     Destroy; override;
     function       Find(ResourceType, ResourceName: PChar): TPEResource;
     function       GroupByType(ResourceType: PChar): TPEResourceGroup;
     procedure      Remove(ResourceType, ResourceName: PChar);
     property       Groups[Index: Integer]: TPEResourceGroup read GetGroups;
     property       GroupCount: Integer read GetGroupCount;
  end;

////////////////////////////////////////////////////////////////////////////////
//   Utility functions
////////////////////////////////////////////////////////////////////////////////
function   GetResourceTypeName(ResourceType: PChar): String;
function   GetResourceName(ResourceName: PChar): String;
function   IsIntResource(ResourceTypeOrName: PChar): Boolean;
procedure  KillResource(ExeFile: String; ResType, ResName: PChar; LangID: Word = 0);
function   ResAlloc(ResourceTypeOrName: PChar): PChar;
procedure  ResFree(ResourceTypeOrName: PChar);
function   ResCompare(ResourceTypeOrName1, ResourceTypeOrName2: PChar): Boolean;

implementation

//// Callback functions ////////////////////////////////////////////////////////
function EnumResLangProc(Module: HMODULE; lpszType, lpszName: PChar; wIDLanguage: Word; lParam: Pointer): BOOL; stdcall;
begin

  // Resource protection
  try
     // Cast lParam as resource object and add language
     TPEResource(lParam).FLanguages.Add(Pointer(wIDLanguage));
  finally
     // Keep enumerating
     result:=True;
  end;

end;

function EnumResNameProc(Module: HMODULE; lpszType, lpszName: PChar; lParam: Pointer): BOOL; stdcall;
begin

  // Resource protection
  try
     // Create new resource and add to list
     TPEResourceGroup(lParam).FResources.Add(TPEResource.Create(Module, lpszName, lpszType));
  finally
     // Keep enumerating
     result:=True;
  end;

end;

function EnumResTypeProc(Module: HMODULE; lpszType: PChar; lParam: Pointer): BOOL; stdcall;
begin

  // Resource protection
  try
     // Create new resource group and add to list
     TPEResources(lParam).FGroups.Add(TPEResourceGroup.Create(Module, lpszType));
  finally
     // Keep enumerating
     result:=True;
  end;

end;

//// TPEResource ///////////////////////////////////////////////////////////////
procedure TPEResource.Load(Module: HMODULE);
begin

  // Enumerate the languages
  EnumResourceLanguages(Module, FType, FName, @EnumResLangProc, Integer(Self));

end;

function TPEResource.GetLanguageCount: Integer;
begin

  // Return count of languages
  result:=FLanguages.Count;

end;

function TPEResource.GetLanguages(Index: Integer): Word;
begin

  // Return the langauge at the specified index
  result:=Word(FLanguages[Index]);

end;

constructor TPEResource.Create(AModule: HMODULE; AName, AType: PChar);
begin

  // Perform inherited
  inherited Create;

  // Set defaults
  FLanguages:=TList.Create;
  FName:=ResAlloc(AName);
  FType:=ResAlloc(AType);

  // Load
  Load(AModule);

end;

destructor TPEResource.Destroy;
begin

  // Resource protection
  try
     // Free the list
     FLanguages.Free;
     // Free allocated memory
     ResFree(FName);
     ResFree(FType);
  finally
     // Perform inherited
     inherited Destroy;
  end;

end;

//// TPEResourceGroup //////////////////////////////////////////////////////////
function TPEResourceGroup.Find(ResourceName: PChar): TPEResource;
var  lpResource:    TPEResource;
     dwIndex:       Integer;
begin

  // Set default result
  result:=nil;

  // Find the desired resource
  for dwIndex:=0 to Pred(FResources.Count) do
  begin
     // Access the resource
     lpResource:=GetResources(dwIndex);
     // Check the resource  name
     if ResCompare(ResourceName, lpResource.ResName) then
     begin
        // Match was found, return resource
        result:=lpResource;
        // Done processing
        break;
     end;
  end;

end;

procedure TPEResourceGroup.Remove(Obj: TObject);
begin

  // Check assignment
  if Assigned(Obj) and (FResources.IndexOf(Obj) >= 0) then
  begin
     // Resource protection
     try
        // Remove from list
        FResources.Remove(Obj);
     finally
        // Free the object
        Obj.Free;
     end;
  end;

end;

procedure TPEResourceGroup.Load(Module: HMODULE);
begin

  // Enumerate the resources for this type
  EnumResourceNames(Module, FType, @EnumResNameProc, LongInt(Self));

end;

procedure TPEResourceGroup.Clear;
var  dwIndex:       Integer;
begin

  // Resource protection
  try
     // Walk the resource list
     for dwIndex:=0 to Pred(FResources.Count) do
     begin
        // Free the resource
        TPEResource(FResources[dwIndex]).Free;
     end;
  finally
     // Clear the list
     FResources.Clear;
  end;

end;

function TPEResourceGroup.GetResources(Index: Integer): TPEResource;
begin

  // Return the resource at the specified index
  result:=TPEResource(FResources[Index]);

end;

function TPEResourceGroup.GetResourceCount: Integer;
begin

  // Return the count of resources
  result:=FResources.Count;

end;

function TPEResourceGroup.GetResTypeName: String;
begin

  // Return the stringifed name
  result:=GetResourceTypeName(FType);

end;

constructor TPEResourceGroup.Create(AModule: HMODULE; AType: PChar);
begin

  // Perform inherited
  inherited Create;

  // Set defaults
  FResources:=TList.Create;
  FType:=ResAlloc(AType);

  // Load
  Load(AModule);

end;

destructor TPEResourceGroup.Destroy;
begin

  // Resource protection
  try
     // Clear
     Clear;
     // Free the list
     FResources.Free;
     // Free allocated memory
     ResFree(FType);
  finally
     // Perform inherited
     inherited Destroy;
  end;

end;

//// TPEResources //////////////////////////////////////////////////////////////
procedure TPEResources.Remove(ResourceType, ResourceName: PChar);
var  lpGroup:       TPEResourceGroup;
     lpResource:    TPEResource;
     dwIndex:       Integer;
begin

  // Try to get the group
  lpGroup:=GroupByType(ResourceType);

  // Check result
  if Assigned(lpGroup) then
  begin
     // Have the group lookup the resource name
     lpResource:=lpGroup.Find(ResourceName);
     // Check result
     if Assigned(lpResource) then
     begin
        // Resource protection
        try
           // Remove all resources using the language values
           if (lpResource.LanguageCount = 0) then
              // No language, kill resource
              KillResource(FLibFileName, lpResource.ResType, lpResource.ResName, 0)
           else
           begin
              // Walk the languages
              for dwIndex:=0 to Pred(lpResource.LanguageCount) do
              begin
                 // Kill the resource based on language id
                 KillResource(FLibFileName, lpResource.ResType, lpResource.ResName, lpResource.Languages[dwIndex]);
              end;
           end;
        finally
           // Have the group free the resource object
           lpGroup.Remove(lpResource);
        end;
     end;
  end;

end;

function TPEResources.GroupByType(ResourceType: PChar): TPEResourceGroup;
var  lpGroup:       TPEResourceGroup;
     dwIndex:       Integer;
begin

  // Set default result
  result:=nil;

  // Find the desired group
  for dwIndex:=0 to Pred(FGroups.Count) do
  begin
     // Access the group
     lpGroup:=GetGroups(dwIndex);
     // Check the group
     if ResCompare(lpGroup.ResType, ResourceType) then
     begin
        // Set group result
        result:=lpGroup;
        // Done processing
        break;
     end;
  end;

end;

function TPEResources.Find(ResourceType, ResourceName: PChar): TPEResource;
var  lpGroup:       TPEResourceGroup;
     dwIndex:       Integer;
begin

  // Try to get the group
  lpGroup:=GroupByType(ResourceType);

  // Check result
  if Assigned(lpGroup) then
     // Have the group lookup the resource name
     result:=lpGroup.Find(ResourceName)
  else
     // Set default result
     result:=nil;

end;

procedure TPEResources.Clear;
var  dwIndex:       Integer;
begin

  // Resource protection
  try
     // Walk the groups list
     for dwIndex:=0 to Pred(FGroups.Count) do
     begin
        // Free the group
        TPEResourceGroup(FGroups[dwIndex]).Free;
     end;
  finally
     // Clear the list
     FGroups.Clear;
  end;

end;

procedure TPEResources.Load(LibFileName: String);
var  hMod:          HMODULE;
begin

  // Attempt to load the library
  hMod:=LoadLibraryEx(PChar(LibFileName), 0, LOAD_LIBRARY_AS_DATAFILE);

  // Check module handle
  if (hMod = 0) then
     // Failed to load
     RaiseLastWin32Error
  else
  begin
     // Resource protection
     try
        // Enumerate the resource types
        EnumResourceTypes(hMod, @EnumResTypeProc, LongInt(Self));
     finally
        // Free the library
        FreeLibrary(hMod);
     end;
  end;

end;

function TPEResources.GetGroupCount: Integer;
begin

  // Return the count of groups
  result:=FGroups.Count;

end;

function TPEResources.GetGroups(Index: Integer): TPEResourceGroup;
begin

  // Return the group at the specified index
  result:=TPEResourceGroup(FGroups[Index]);

end;

constructor TPEResources.Create(LibFileName: String);
begin

  // Perform inherited
  inherited Create;

  // Set defaults
  FGroups:=TList.Create;
  FLibFileName:=LibFileName;

  // Load the library / exe file
  Load(LibFileName);

end;

destructor TPEResources.Destroy;
begin

  // Resource protection
  try
     // Clear
     Clear;
     // Free the list
     FGroups.Free;
  finally
     // Perform inherited
     inherited Destroy;
  end;

end;

//// Utility functions /////////////////////////////////////////////////////////
function ResCompare(ResourceTypeOrName1, ResourceTypeOrName2: PChar): Boolean;
begin

  // Check the name for integer value
  if IsIntResource(ResourceTypeOrName1) then
     // Can only match if the second value is an integer as well
     result:=(IsIntResource(ResourceTypeOrName2) and (ResourceTypeOrName1 = ResourceTypeOrName2))
  // Check second value
  else if IsIntResource(ResourceTypeOrName2) then
     // Can only match if the first value is an integer as well
     result:=(IsIntResource(ResourceTypeOrName1) and (ResourceTypeOrName1 = ResourceTypeOrName2))
  else
     // Case insensitive compare
     result:=(StrIComp(ResourceTypeOrName1, ResourceTypeOrName2) = 0);

end;

function GetResourceName(ResourceName: PChar): String;
begin

  // Check the resource type
  if IsIntResource(ResourceName) then
     // Format as #NUMBER
     result:=Format('#%d', [Word(Pointer(ResourceName))])
  else
     // Return type name
     result:=ResourceName;

end;

function ResAlloc(ResourceTypeOrName: PChar): PChar;
begin

  // Check for int resource name
  if IsIntResource(ResourceTypeOrName) then
     // Return as is
     result:=ResourceTypeOrName
  else
     // Allocate and copy
     result:=StrCopy(AllocMem(Succ(StrLen(ResourceTypeOrName))), ResourceTypeOrName);

end;

procedure ResFree(ResourceTypeOrName: PChar);
begin

  // Check for int resource name
  if not(IsIntResource(ResourceTypeOrName)) then
  begin
     // Free allocated memory
     FreeMem(ResourceTypeOrName);
  end;

end;

function GetResourceTypeName(ResourceType: PChar): String;
var  wType:         Word;
begin

  // Check the resource type
  if IsIntResource(ResourceType) then
  begin
     // Get actual word value
     wType:=Word(Pointer(ResourceType));
     // Determine if predefined
     if (wType <= RT_MAX_PREDEFINE) then
        // Get name from static table
        result:=RT_PREDEFINED[wType].Name
     else
        // Format as #NUMBER
        result:=Format('#%d', [wType]);
  end
  else
     // Return type name
     result:=ResourceType;

end;

function IsIntResource(ResourceTypeOrName: PChar): Boolean;
begin

  // Determine if the resource type / name is actually a word value
  result:=((LongWord(Pointer(ResourceTypeOrName)) shr 16) = 0);

end;

procedure KillResource(ExeFile: String; ResType, ResName: PChar; LangID: Word = 0);
var  hUpdate:       THandle;
begin

  // Open file for resource updating
  hUpdate:=BeginUpdateResource(PChar(ExeFile), False);

  // Check handle
  if (hUpdate = 0) then
     // Raise error
     RaiseLastWin32Error
  // Remove resource
  else if UpdateResource(hUpdate, ResType, ResName, LangID, nil, 0) then
  begin
     // End the update
     if not(EndUpdateResource(hUpdate, False)) then RaiseLastWin32Error;
  end
  else
     // Raise error
     RaiseLastWin32Error

end;

end.
