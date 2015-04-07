unit Error;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sMemo, Clipbrd, sButton, sGroupBox;

type
  TErrorForm = class(TForm)
    CloseButton: TButton;
    sGroupBox1: TsGroupBox;
    ErrorMemo: TsMemo;
    CopyButton: TsButton;
    procedure CloseButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure WMGetMinMaxInfo( var Message :TWMGetMinMaxInfo ); message WM_GETMINMAXINFO;
  private
  public
  end;

implementation

{$R *.dfm}

procedure TErrorForm.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  with Message.MinMaxInfo^ do
  begin
    ptMinTrackSize.X := 200;           {Minimum width}
    ptMinTrackSize.Y := 200;           {Minimum height}
  end;
  Message.Result := 0;                 {Tell windows you have changed minmaxinfo}
  inherited;
end;

procedure TErrorForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TErrorForm.CopyButtonClick(Sender: TObject);
begin
  Clipboard.asText := ErrorMemo.Text;
end;

end.
