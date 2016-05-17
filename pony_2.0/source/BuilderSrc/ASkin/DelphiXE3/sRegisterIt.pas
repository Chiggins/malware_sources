unit sRegisterIt;
{$I sDefs.inc}

interface

uses
  Classes, sScrollBar, sLabel, sButton, sBitBtn, sSpeedButton, sPanel,
  sListBox, acTitleBar,
{$IFNDEF ALITE}
  sHintManager, sToolBar, sColorSelect, sDialogs, sCurrencyEdit, sSpinEdit, sRadioButton,
  sComboEdit, sPageControl, sCurrEdit, sToolEdit, sMonthCalendar, sBevel, sGroupBox, sStatusBar,
  sTrackBar, sCalculator, sMaskEdit, sComboBoxes, sSplitter, sTabControl, sFontCtrls,
  sScrollBox, sRichEdit, sFileCtrl, sTreeView, sFrameAdapter, sUpDown, acSlider, acImage,
  sFrameBar, acShellCtrls, acCoolBar, acProgressBar, acNotebook, acAlphaHints, acHeaderControl, acMagn,
{$ENDIF}
  sListView, sGauge, sEdit, sSkinManager, sSkinProvider, sComboBox, sCheckBox, acAlphaImageList, sMemo, sCheckListBox;

procedure Register;

implementation

uses Registry, Windows, Graphics, acntUtils, acPng, 
  SysUtils{$IFNDEF ALITE}, acPathDialog, sColorDialog, sStoreUtils{$ENDIF}{$IFDEF SPLASH}, ToolsAPI{$ENDIF};

const
  s_AlphaLite = 'AlphaLite';

{$IFDEF SPLASH}
{$R ACLOGO.RES}
procedure RegisterWithSplashScreen;
var
  Bmp : TBitmap;
begin
  Bmp := TBitmap.Create;
  Bmp.LoadFromResourceName(hInstance, 'ACLOGO');
  try
    SplashScreenServices.AddPluginBitmap('AlphaControls 2013', Bmp.Handle, False,
{$IFNDEF ALITE}
      {$IFDEF RUNIDEONLY}'Trial edition'{$ELSE}'Registered'{$ENDIF},
{$ELSE}
      'Lite Edition',
{$ENDIF}
      '(version ' + sSkinManager.CurrentVersion + ')');
  except on E : Exception do
  end;
  Bmp.Free;
end;
{$ENDIF}

procedure Register;
begin
{$IFDEF SPLASH}
  RegisterWithSplashScreen;
{$ENDIF}

{$IFNDEF ALITE}
  RegisterComponents('AlphaStandard', [
    TsLabel, TsEdit, TsMemo, TsButton, TsCheckBox, TsRadioButton,
    TsListBox, TsComboBox, TsScrollBar, TsGroupBox, TsRadioGroup, TsPanel, TsBitBtn,
    TsSpeedButton, TsMaskEdit, TsBevel, TsScrollBox, TsCheckListBox, TsSplitter,
    TsTabControl, TsPageControl, TsRichEdit, TsTrackBar, TsProgressBar, TsUpDown, TsTreeView,
    TsListView, TsHeaderControl, TsStatusBar, TsToolBar, TsGauge, TsSpinEdit, TsCoolBar, 
    TsNotebook, TsImage]);

  RegisterComponents('AlphaAdditional', [
    TsWebLabel, TsDecimalSpinEdit, TsColorSelect, TsDragBar, TsComboBoxEx, TsColorBox,
    TsMonthCalendar, TsComboEdit, TsCurrencyEdit, TsDateEdit, TsCalcEdit, TsDirectoryEdit,
    TsFileNameEdit, TsFilterComboBox, TsFontComboBox, TsFontListBox, TsLabelFX,
    TsFrameBar, TsColorsPanel, TsStickyLabel, TsShellTreeView, TsShellComboBox,
    TsShellListView, TsTimePicker, TsSlider]);

  RegisterComponents('AlphaTools', [
    TsSkinManager, TsSkinProvider, TsFrameAdapter, TsCalculator, TsOpenDialog, 
    TsSaveDialog, TsOpenPictureDialog, TsSavePictureDialog, TsMagnifier, 
    TsColordialog, TsPathDialog, TsAlphaImageList, TsVirtualImageList, 
    TsAlphaHints, TsTitleBar, TsHintManager]);

  RegisterNoIcon([TsTabSheet]);
  RegisterClasses([TsTabSheet, TsEditLabel, TsStdColorsPanel, TsDlgShellListView, TsPage]);
{$ELSE}
  RegisterComponents(s_AlphaLite, [
    TsSkinManager, TsSkinProvider, TsEdit, TsCheckBox, TsPanel, TsButton, TsBitBtn, TsScrollBar, 
    TsLabel, TsWebLabel, TsLabelFX, TsComboBox, TsListBox, TsCheckListBox, TsGauge, TsAlphaImageList, TsTitleBar]);

  RegisterClasses([TsSpeedButton, TsListView, TsMemo]);
  RegisterNoIcon([TsSpeedButton, TsListView, TsMemo]);
{$ENDIF}

end;

end.
