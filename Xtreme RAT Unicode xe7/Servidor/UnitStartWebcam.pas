unit UnitStartWebcam;

interface

uses
  Windows,
  UnitObjeto,
  Classes,
  vcl.Forms,
  GlobalVars,
  uCamHelper;

implementation

type
  TWebcam = Class(TThread)
    private

    public
      constructor Create;
      destructor Destroy; override;
    protected
      procedure Execute; override;
    end;

var
  Webcam: TWebcam;

procedure TWebcam.Execute;
begin
  CamHelper := TCamHelper.Create(Application.Handle);
  inherited;
  //Free;
  Application.Terminate;
end;

constructor TWebcam.Create;
begin
  inherited Create(True);
  Resume;
end;

destructor TWebcam.Destroy;
begin
  CamHelper.StopCam;
  CamHelper.Free;
  Application.Terminate;
  inherited Destroy;
end;

procedure StartWebcam;
begin
  Application.Initialize;
  Webcam := TWebcam.Create;
  Application.Run;
end;

initialization
  if not assigned(webcam) then
  begin
    StartWebcam;
  end;
end.	
