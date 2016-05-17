unit mckFileFilterEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids;

type
  TfmFileFilterEditor = class(TForm)
    StringGrid1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Filter: String;
    Constructor Create( AOwner: TComponent ); override;
  end;

var
  fmFileFilterEditor: TfmFileFilterEditor;

implementation

Constructor TfmFileFilterEditor.Create( AOwner: TComponent );
begin
  CreateNew(AOwner);
  Left := 228                            ;
  Top := 107                             ;
  Width := 452                           ;
  Height := 193                          ;
  Caption := 'fmFileFilterEditor'        ;
  Color := clBtnFace                     ;
  //Font.Charset := DEFAULT_CHARSET        ;
  Font.Color := clWindowText             ;
  Font.Height := -13                     ;
  Font.Name := 'MS Sans Serif'           ;
  Font.Style := []                       ;
  //OldCreateOrder := False                ;
  Scaled := False                        ;
  OnActivate := FormActivate             ;
  StringGrid1 := TStringGrid.Create( Self );
  StringGrid1.Parent := Self;
    StringGrid1.Left := 6              ;
    StringGrid1.Top := 8               ;
    StringGrid1.Width := 429           ;
    StringGrid1.Height := 120          ;
    StringGrid1.ColCount := 2          ;
    StringGrid1.DefaultColWidth := 204 ;
    StringGrid1.DefaultRowHeight := 18 ;
    StringGrid1.FixedCols := 0         ;
    StringGrid1.RowCount := 50         ;
    StringGrid1.Options := [ goFixedVertLine, goFixedHorzLine, goVertLine,
                goHorzLine, goDrawFocusSelected, goRowMoving, goEditing,
                goAlwaysShowEditor, goThumbTracking];
    StringGrid1.ScrollBars := ssVertical;
    StringGrid1.TabOrder := 0           ;
  Button1 := TButton.Create( Self );
  Button1.Parent := Self;
    Button1.Left := 272            ;
    Button1.Top := 136             ;
    Button1.Width := 75            ;
    Button1.Height := 25           ;
    Button1.Caption := 'OK'        ;
    Button1.OnClick := Button1Click;
  Button2 := TButton.Create( Self );
  Button2.Parent := Self;
    Button2.Left := 360            ;
    Button2.Top := 136             ;
    Button2.Width := 75            ;
    Button2.Height := 25           ;
    Button2.Caption := 'Cancel'    ;
    Button2.OnClick := Button2Click;

  StringGrid1.Cols[ 0 ].Text := 'Filter name';
  StringGrid1.Cols[ 1 ].Text := 'Mask list';
end;

procedure TfmFileFilterEditor.Button1Click(Sender: TObject);
var I: Integer;
    X, Y: String;
begin
  Filter := '';
  for I := 1 to StringGrid1.RowCount - 1 do
  begin
    X := StringGrid1.Cells[ 0, I ];
    Y := StringGrid1.Cells[ 1, I ];
    if (X = '') and (Y = '') then
      continue;
    if Filter <> '' then
      Filter := Filter + '|';
    Filter := Filter + X + '|' + Y;
  end;
  ModalResult := mrOK;
end;

procedure TfmFileFilterEditor.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmFileFilterEditor.FormActivate(Sender: TObject);
var I, J: Integer;
    X, Y: String;
begin
  J := 1;
  while Filter <> '' do
  begin
    I := pos( '|', Filter );
    if I > 0 then
    begin
      X := Copy( Filter, 1, I - 1 );
      Filter := Copy( Filter, I + 1, MaxInt );
      I := pos( '|', Filter );
      if I > 0 then
      begin
        Y := Copy( Filter, 1, I - 1 );
        Filter := Copy( Filter, I + 1, MaxInt );
      end
        else
      begin
        Y := Filter;
        Filter := '';
      end;
    end
      else break;
    StringGrid1.Cells[ 0, J ] := X;
    StringGrid1.Cells[ 1, J ] := Y;
    Inc( J );
    if StringGrid1.RowCount <= J then
      StringGrid1.RowCount := J + 1;
  end;
  StringGrid1.RowCount := J + 50;
end;

end.