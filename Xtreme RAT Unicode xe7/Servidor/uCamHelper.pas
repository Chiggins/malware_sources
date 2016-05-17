unit uCamHelper;

interface

uses
  Windows, SysUtils, Classes, vcl.Graphics,
  VFrames;

type
  TResolution = packed record
    W: Integer;
    H: Integer;
  end;

type
  TCamHelper = class
    constructor Create(Handle: THandle);
    destructor Destroy; override;
  private
    Vid : TVideoImage;
    FCamNumber, FCamCount: Integer;
    FStarted: Boolean;
  public
    function StartCam(CamNumber: Integer; Resolution: Integer = 0): Boolean;
    function SetResolution(Resolution: Integer): Boolean;
    procedure StopCam;
    function GetImage(BMP: TBitmap; Timeout: Cardinal = INFINITE): Boolean;
    function GetCams: String;
    function GetResolutions(CamNumber: Integer): String;
    function GetFullList: String;
    function CurrentSize: TResolution;
    property Started: Boolean read FStarted;
    property CamNumber: Integer read FCamCount;
    property CamCount: Integer read FCamCount;
  end;

var
  CamHelper: TCamHelper;

implementation

constructor TCamHelper.Create(Handle: THandle);
begin
  FCamNumber := 0;
  Vid := TVideoImage.Create(Handle);
end;

function TCamHelper.StartCam(CamNumber: Integer; Resolution: Integer = 0): Boolean;
begin
  Result := False;
  if Started and (FCamNumber = CamNumber) then Exit;
  StopCam;
  FStarted := Vid.VideoStart('#' + IntToStr(CamNumber), Resolution - 1);
  if Started then
  begin
    FCamNumber := CamNumber;
  end;
  Result := Started;
end;

function TCamHelper.GetImage(BMP: TBitmap; Timeout: Cardinal = INFINITE): Boolean;
begin
  Result := False;
  if not Started then Exit;
  if Vid.HasNewFrame(1000) and FStarted then
    Result := Vid.GetBitmap(BMP);
end;

function TCamHelper.SetResolution(Resolution: Integer): Boolean;
begin
  if Started and (FCamNumber > 0) then
    Result := Vid.SetResolutionByIndex(Resolution - 1)
  else Result := False;
end;

procedure TCamHelper.StopCam;
begin
  if Vid.VideoRunning then Vid.VideoStop;
  FStarted := False;
end;

function TCamHelper.GetCams: String;
var
  SL: TStringList;
begin
  Result := '';
  SL := TStringList.Create;
  try
    Vid.GetListOfDevices(SL);
    FCamCount := SL.Count;
    SL.Delimiter := '|';
    Result := SL.DelimitedText;
  finally
    SL.Free;
  end;
end;

function TCamHelper.GetResolutions(CamNumber: Integer): String;
var
  SL: TStringList;
begin
  Result := '';
  SL := TStringList.Create;
  try
    Vid.GetListOfSupportedVideoSizes('#' + IntToStr(CamNumber), SL);
    SL.Insert(0, '(Default)');
    SL.Delimiter := '|';
    Result := SL.DelimitedText;
  finally
    SL.Free;
  end;
end;

function TCamHelper.GetFullList: String;
var
  SL: TStringList;
  I: Integer;
begin
  Result := '';
  SL := TStringList.Create;
  try
    SL.Add(GetCams);
    for I := 0 to FCamCount - 1 do
      SL.Add(GetResolutions(I));
    SL.Delimiter := '|';
    Result := SL.DelimitedText;
  finally
    SL.Free;
  end;
end;

destructor TCamHelper.Destroy;
begin
  Vid.Free;
end;

function TCamHelper.CurrentSize: TResolution;
begin
  if not Started then
  begin
    Result.W := 0;
    Result.H := 0;
  end else
  begin
    Result.W := Vid.VideoWidth;
    Result.H := Vid.VideoHeight;
  end;
end;

end.
