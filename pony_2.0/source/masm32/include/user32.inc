  ; ===========================================
  ; user32.inc copyright MASM32 1998 - 2005
  ; ===========================================

IFNDEF USER32_INC
USER32_INC equ <1>

IFNDEF _wininc_
  wsprintfA PROTO C :VARARG
  wsprintf equ <wsprintfA>
  wsprintfW PROTO C :VARARG
ENDIF

ActivateKeyboardLayout PROTO :DWORD,:DWORD
AdjustWindowRect PROTO :DWORD,:DWORD,:DWORD
AdjustWindowRectEx PROTO :DWORD,:DWORD,:DWORD,:DWORD
AllowSetForegroundWindow PROTO :DWORD
AnimateWindow PROTO :DWORD,:DWORD,:DWORD
AnyPopup PROTO 
AppendMenuA PROTO :DWORD,:DWORD,:DWORD,:DWORD
AppendMenu equ <AppendMenuA>

AppendMenuW PROTO :DWORD,:DWORD,:DWORD,:DWORD
ArrangeIconicWindows PROTO :DWORD
AttachThreadInput PROTO :DWORD,:DWORD,:DWORD
BeginDeferWindowPos PROTO :DWORD
BeginPaint PROTO :DWORD,:DWORD
BlockInput PROTO :DWORD
BringWindowToTop PROTO :DWORD
BroadcastSystemMessageA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BroadcastSystemMessage equ <BroadcastSystemMessageA>

BroadcastSystemMessageExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BroadcastSystemMessageEx equ <BroadcastSystemMessageExA>

BroadcastSystemMessageExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
BroadcastSystemMessageW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CallMsgFilterA PROTO :DWORD,:DWORD
CallMsgFilter equ <CallMsgFilterA>

CallMsgFilterW PROTO :DWORD,:DWORD
CallNextHookEx PROTO :DWORD,:DWORD,:DWORD,:DWORD
CallWindowProcA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CallWindowProc equ <CallWindowProcA>

CallWindowProcW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CascadeChildWindows PROTO :DWORD,:DWORD
CascadeWindows PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ChangeClipboardChain PROTO :DWORD,:DWORD
ChangeDisplaySettingsA PROTO :DWORD,:DWORD
ChangeDisplaySettings equ <ChangeDisplaySettingsA>

ChangeDisplaySettingsExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ChangeDisplaySettingsEx equ <ChangeDisplaySettingsExA>

ChangeDisplaySettingsExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ChangeDisplaySettingsW PROTO :DWORD,:DWORD
ChangeMenuA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ChangeMenu equ <ChangeMenuA>

ChangeMenuW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CharLowerA PROTO :DWORD
CharLower equ <CharLowerA>

CharLowerBuffA PROTO :DWORD,:DWORD
CharLowerBuff equ <CharLowerBuffA>

CharLowerBuffW PROTO :DWORD,:DWORD
CharLowerW PROTO :DWORD
CharNextA PROTO :DWORD
CharNext equ <CharNextA>

CharNextExA PROTO :DWORD,:DWORD,:DWORD
CharNextEx equ <CharNextExA>

CharNextW PROTO :DWORD
CharPrevA PROTO :DWORD,:DWORD
CharPrev equ <CharPrevA>

CharPrevExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
CharPrevEx equ <CharPrevExA>

CharPrevW PROTO :DWORD,:DWORD
CharToOemA PROTO :DWORD,:DWORD
CharToOem equ <CharToOemA>

CharToOemBuffA PROTO :DWORD,:DWORD,:DWORD
CharToOemBuff equ <CharToOemBuffA>

CharToOemBuffW PROTO :DWORD,:DWORD,:DWORD
CharToOemW PROTO :DWORD,:DWORD
CharUpperA PROTO :DWORD
CharUpper equ <CharUpperA>

CharUpperBuffA PROTO :DWORD,:DWORD
CharUpperBuff equ <CharUpperBuffA>

CharUpperBuffW PROTO :DWORD,:DWORD
CharUpperW PROTO :DWORD
CheckDlgButton PROTO :DWORD,:DWORD,:DWORD
CheckMenuItem PROTO :DWORD,:DWORD,:DWORD
CheckMenuRadioItem PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CheckRadioButton PROTO :DWORD,:DWORD,:DWORD,:DWORD
ChildWindowFromPoint PROTO :DWORD,:DWORD,:DWORD
ChildWindowFromPointEx PROTO :DWORD,:DWORD,:DWORD,:DWORD
ClientToScreen PROTO :DWORD,:DWORD
ClipCursor PROTO :DWORD
CloseClipboard PROTO 
CloseDesktop PROTO :DWORD
CloseWindow PROTO :DWORD
CloseWindowStation PROTO :DWORD
CopyAcceleratorTableA PROTO :DWORD,:DWORD,:DWORD
CopyAcceleratorTable equ <CopyAcceleratorTableA>

CopyAcceleratorTableW PROTO :DWORD,:DWORD,:DWORD
CopyIcon PROTO :DWORD
CopyImage PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CopyRect PROTO :DWORD,:DWORD
CountClipboardFormats PROTO 
CreateAcceleratorTableA PROTO :DWORD,:DWORD
CreateAcceleratorTable equ <CreateAcceleratorTableA>

CreateAcceleratorTableW PROTO :DWORD,:DWORD
CreateCaret PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateCursor PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateDesktopA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateDesktop equ <CreateDesktopA>

CreateDesktopW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateDialogIndirectParamA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateDialogIndirectParam equ <CreateDialogIndirectParamA>

CreateDialogIndirectParamW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateDialogParamA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateDialogParam equ <CreateDialogParamA>

CreateDialogParamW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateIcon PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateIconFromResource PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateIconFromResourceEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateIconIndirect PROTO :DWORD
CreateMDIWindowA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateMDIWindow equ <CreateMDIWindowA>

CreateMDIWindowW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateMenu PROTO 
CreatePopupMenu PROTO 
CreateWindowExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateWindowEx equ <CreateWindowExA>

CreateWindowExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateWindowStationA PROTO :DWORD,:DWORD,:DWORD,:DWORD
CreateWindowStation equ <CreateWindowStationA>

CreateWindowStationW PROTO :DWORD,:DWORD,:DWORD,:DWORD
DbgWin32HeapFail PROTO :DWORD,:DWORD
DbgWin32HeapStat PROTO :DWORD,:DWORD,:DWORD
DdeAbandonTransaction PROTO :DWORD,:DWORD,:DWORD
DdeAccessData PROTO :DWORD,:DWORD
DdeAddData PROTO :DWORD,:DWORD,:DWORD,:DWORD
DdeClientTransaction PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DdeCmpStringHandles PROTO :DWORD,:DWORD
DdeConnect PROTO :DWORD,:DWORD,:DWORD,:DWORD
DdeConnectList PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DdeCreateDataHandle PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DdeCreateStringHandleA PROTO :DWORD,:DWORD,:DWORD
DdeCreateStringHandle equ <DdeCreateStringHandleA>

DdeCreateStringHandleW PROTO :DWORD,:DWORD,:DWORD
DdeDisconnect PROTO :DWORD
DdeDisconnectList PROTO :DWORD
DdeEnableCallback PROTO :DWORD,:DWORD,:DWORD
DdeFreeDataHandle PROTO :DWORD
DdeFreeStringHandle PROTO :DWORD,:DWORD
DdeGetData PROTO :DWORD,:DWORD,:DWORD,:DWORD
DdeGetLastError PROTO :DWORD
DdeImpersonateClient PROTO :DWORD
DdeInitializeA PROTO :DWORD,:DWORD,:DWORD,:DWORD
DdeInitialize equ <DdeInitializeA>

DdeInitializeW PROTO :DWORD,:DWORD,:DWORD,:DWORD
DdeKeepStringHandle PROTO :DWORD,:DWORD
DdeNameService PROTO :DWORD,:DWORD,:DWORD,:DWORD
DdePostAdvise PROTO :DWORD,:DWORD,:DWORD
DdeQueryConvInfo PROTO :DWORD,:DWORD,:DWORD
DdeQueryNextServer PROTO :DWORD,:DWORD
DdeQueryStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DdeQueryString equ <DdeQueryStringA>

DdeQueryStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DdeReconnect PROTO :DWORD
DdeSetQualityOfService PROTO :DWORD,:DWORD,:DWORD
DdeSetUserHandle PROTO :DWORD,:DWORD,:DWORD
DdeUnaccessData PROTO :DWORD
DdeUninitialize PROTO :DWORD
DefDlgProcA PROTO :DWORD,:DWORD,:DWORD,:DWORD
DefDlgProc equ <DefDlgProcA>

DefDlgProcW PROTO :DWORD,:DWORD,:DWORD,:DWORD
DefFrameProcA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DefFrameProc equ <DefFrameProcA>

DefFrameProcW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DefMDIChildProcA PROTO :DWORD,:DWORD,:DWORD,:DWORD
DefMDIChildProc equ <DefMDIChildProcA>

DefMDIChildProcW PROTO :DWORD,:DWORD,:DWORD,:DWORD
DefRawInputProc PROTO :DWORD,:DWORD,:DWORD
DefWindowProcA PROTO :DWORD,:DWORD,:DWORD,:DWORD
DefWindowProc equ <DefWindowProcA>

DefWindowProcW PROTO :DWORD,:DWORD,:DWORD,:DWORD
DeferWindowPos PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DeleteMenu PROTO :DWORD,:DWORD,:DWORD
DeregisterShellHookWindow PROTO :DWORD
DestroyAcceleratorTable PROTO :DWORD
DestroyCaret PROTO 
DestroyCursor PROTO :DWORD
DestroyIcon PROTO :DWORD
DestroyMenu PROTO :DWORD
DestroyWindow PROTO :DWORD
DialogBoxIndirectParamA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DialogBoxIndirectParam equ <DialogBoxIndirectParamA>

DialogBoxIndirectParamW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DialogBoxParamA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DialogBoxParam equ <DialogBoxParamA>

DialogBoxParamW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DisableProcessWindowsGhosting PROTO 
DispatchMessageA PROTO :DWORD
DispatchMessage equ <DispatchMessageA>

DispatchMessageW PROTO :DWORD
DlgDirListA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DlgDirList equ <DlgDirListA>

DlgDirListComboBoxA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DlgDirListComboBox equ <DlgDirListComboBoxA>

DlgDirListComboBoxW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DlgDirListW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DlgDirSelectComboBoxExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
DlgDirSelectComboBoxEx equ <DlgDirSelectComboBoxExA>

DlgDirSelectComboBoxExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
DlgDirSelectExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
DlgDirSelectEx equ <DlgDirSelectExA>

DlgDirSelectExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
DragDetect PROTO :DWORD,:DWORD,:DWORD
DragObject PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DrawAnimatedRects PROTO :DWORD,:DWORD,:DWORD,:DWORD
DrawCaption PROTO :DWORD,:DWORD,:DWORD,:DWORD
DrawEdge PROTO :DWORD,:DWORD,:DWORD,:DWORD
DrawFocusRect PROTO :DWORD,:DWORD
DrawFrame PROTO :DWORD,:DWORD,:DWORD,:DWORD
DrawFrameControl PROTO :DWORD,:DWORD,:DWORD,:DWORD
DrawIcon PROTO :DWORD,:DWORD,:DWORD,:DWORD
DrawIconEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DrawMenuBar PROTO :DWORD
DrawStateA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DrawState equ <DrawStateA>

DrawStateW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DrawTextA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DrawText equ <DrawTextA>

DrawTextExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DrawTextEx equ <DrawTextExA>

DrawTextExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
DrawTextW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EditWndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
EmptyClipboard PROTO 
EnableMenuItem PROTO :DWORD,:DWORD,:DWORD
EnableScrollBar PROTO :DWORD,:DWORD,:DWORD
EnableWindow PROTO :DWORD,:DWORD
EndDeferWindowPos PROTO :DWORD
EndDialog PROTO :DWORD,:DWORD
EndMenu PROTO 
EndPaint PROTO :DWORD,:DWORD
EndTask PROTO :DWORD,:DWORD,:DWORD
EnumChildWindows PROTO :DWORD,:DWORD,:DWORD
EnumClipboardFormats PROTO :DWORD
EnumDesktopWindows PROTO :DWORD,:DWORD,:DWORD
EnumDesktopsA PROTO :DWORD,:DWORD,:DWORD
EnumDesktops equ <EnumDesktopsA>

EnumDesktopsW PROTO :DWORD,:DWORD,:DWORD
EnumDisplayDevicesA PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumDisplayDevices equ <EnumDisplayDevicesA>

EnumDisplayDevicesW PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumDisplayMonitors PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumDisplaySettingsA PROTO :DWORD,:DWORD,:DWORD
EnumDisplaySettings equ <EnumDisplaySettingsA>

EnumDisplaySettingsExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumDisplaySettingsEx equ <EnumDisplaySettingsExA>

EnumDisplaySettingsExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
EnumDisplaySettingsW PROTO :DWORD,:DWORD,:DWORD
EnumPropsA PROTO :DWORD,:DWORD
EnumProps equ <EnumPropsA>

EnumPropsExA PROTO :DWORD,:DWORD,:DWORD
EnumPropsEx equ <EnumPropsExA>

EnumPropsExW PROTO :DWORD,:DWORD,:DWORD
EnumPropsW PROTO :DWORD,:DWORD
EnumThreadWindows PROTO :DWORD,:DWORD,:DWORD
EnumWindowStationsA PROTO :DWORD,:DWORD
EnumWindowStations equ <EnumWindowStationsA>

EnumWindowStationsW PROTO :DWORD,:DWORD
EnumWindows PROTO :DWORD,:DWORD
EqualRect PROTO :DWORD,:DWORD
ExcludeUpdateRgn PROTO :DWORD,:DWORD
ExitWindowsEx PROTO :DWORD,:DWORD
FillRect PROTO :DWORD,:DWORD,:DWORD
FindWindowA PROTO :DWORD,:DWORD
FindWindow equ <FindWindowA>

FindWindowExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
FindWindowEx equ <FindWindowExA>

FindWindowExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
FindWindowW PROTO :DWORD,:DWORD
FlashWindow PROTO :DWORD,:DWORD
FlashWindowEx PROTO :DWORD
FrameRect PROTO :DWORD,:DWORD,:DWORD
FreeDDElParam PROTO :DWORD,:DWORD
GetActiveWindow PROTO 
GetAltTabInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetAltTabInfo equ <GetAltTabInfoA>

GetAltTabInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetAncestor PROTO :DWORD,:DWORD
GetAsyncKeyState PROTO :DWORD
GetCapture PROTO 
GetCaretBlinkTime PROTO 
GetCaretPos PROTO :DWORD
GetClassInfoA PROTO :DWORD,:DWORD,:DWORD
GetClassInfo equ <GetClassInfoA>

GetClassInfoExA PROTO :DWORD,:DWORD,:DWORD
GetClassInfoEx equ <GetClassInfoExA>

GetClassInfoExW PROTO :DWORD,:DWORD,:DWORD
GetClassInfoW PROTO :DWORD,:DWORD,:DWORD
GetClassLongA PROTO :DWORD,:DWORD
GetClassLong equ <GetClassLongA>

GetClassLongW PROTO :DWORD,:DWORD
GetClassNameA PROTO :DWORD,:DWORD,:DWORD
GetClassName equ <GetClassNameA>

GetClassNameW PROTO :DWORD,:DWORD,:DWORD
GetClassWord PROTO :DWORD,:DWORD
GetClientRect PROTO :DWORD,:DWORD
GetClipCursor PROTO :DWORD
GetClipboardData PROTO :DWORD
GetClipboardFormatNameA PROTO :DWORD,:DWORD,:DWORD
GetClipboardFormatName equ <GetClipboardFormatNameA>

GetClipboardFormatNameW PROTO :DWORD,:DWORD,:DWORD
GetClipboardOwner PROTO 
GetClipboardSequenceNumber PROTO 
GetClipboardViewer PROTO 
GetComboBoxInfo PROTO :DWORD,:DWORD
GetCursor PROTO 
GetCursorInfo PROTO :DWORD
GetCursorPos PROTO :DWORD
GetDC PROTO :DWORD
GetDCEx PROTO :DWORD,:DWORD,:DWORD
GetDesktopWindow PROTO 
GetDialogBaseUnits PROTO 
GetDlgCtrlID PROTO :DWORD
GetDlgItem PROTO :DWORD,:DWORD
GetDlgItemInt PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetDlgItemTextA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetDlgItemText equ <GetDlgItemTextA>

GetDlgItemTextW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetDoubleClickTime PROTO 
GetFocus PROTO 
GetForegroundWindow PROTO 
GetGUIThreadInfo PROTO :DWORD,:DWORD
GetGuiResources PROTO :DWORD,:DWORD
GetIconInfo PROTO :DWORD,:DWORD
GetInputDesktop PROTO 
GetInputState PROTO 
GetKBCodePage PROTO 
GetKeyNameTextA PROTO :DWORD,:DWORD,:DWORD
GetKeyNameText equ <GetKeyNameTextA>

GetKeyNameTextW PROTO :DWORD,:DWORD,:DWORD
GetKeyState PROTO :DWORD
GetKeyboardLayout PROTO :DWORD
GetKeyboardLayoutList PROTO :DWORD,:DWORD
GetKeyboardLayoutNameA PROTO :DWORD
GetKeyboardLayoutName equ <GetKeyboardLayoutNameA>

GetKeyboardLayoutNameW PROTO :DWORD
GetKeyboardState PROTO :DWORD
GetKeyboardType PROTO :DWORD
GetLastActivePopup PROTO :DWORD
GetLastInputInfo PROTO :DWORD
GetLayeredWindowAttributes PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetListBoxInfo PROTO :DWORD
GetMenu PROTO :DWORD
GetMenuBarInfo PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetMenuCheckMarkDimensions PROTO 
GetMenuContextHelpId PROTO :DWORD
GetMenuDefaultItem PROTO :DWORD,:DWORD,:DWORD
GetMenuInfo PROTO :DWORD,:DWORD
GetMenuItemCount PROTO :DWORD
GetMenuItemID PROTO :DWORD,:DWORD
GetMenuItemInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetMenuItemInfo equ <GetMenuItemInfoA>

GetMenuItemInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetMenuItemRect PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetMenuState PROTO :DWORD,:DWORD,:DWORD
GetMenuStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetMenuString equ <GetMenuStringA>

GetMenuStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetMessageA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetMessage equ <GetMessageA>

GetMessageExtraInfo PROTO 
GetMessagePos PROTO 
GetMessageTime PROTO 
GetMessageW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetMonitorInfoA PROTO :DWORD,:DWORD
GetMonitorInfo equ <GetMonitorInfoA>

GetMonitorInfoW PROTO :DWORD,:DWORD
GetMouseMovePointsEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetNextDlgGroupItem PROTO :DWORD,:DWORD,:DWORD
GetNextDlgTabItem PROTO :DWORD,:DWORD,:DWORD
GetOpenClipboardWindow PROTO 
GetParent PROTO :DWORD
GetPriorityClipboardFormat PROTO :DWORD,:DWORD
GetProcessDefaultLayout PROTO :DWORD
GetProcessWindowStation PROTO 
GetPropA PROTO :DWORD,:DWORD
GetProp equ <GetPropA>

GetPropW PROTO :DWORD,:DWORD
GetQueueStatus PROTO :DWORD
GetRawInputBuffer PROTO :DWORD,:DWORD,:DWORD
GetRawInputData PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetRawInputDeviceInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetRawInputDeviceInfo equ <GetRawInputDeviceInfoA>

GetRawInputDeviceInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetRawInputDeviceList PROTO :DWORD,:DWORD,:DWORD
GetRegisteredRawInputDevices PROTO :DWORD,:DWORD,:DWORD
GetScrollBarInfo PROTO :DWORD,:DWORD,:DWORD
GetScrollInfo PROTO :DWORD,:DWORD,:DWORD
GetScrollPos PROTO :DWORD,:DWORD
GetScrollRange PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetShellWindow PROTO 
GetSubMenu PROTO :DWORD,:DWORD
GetSysColor PROTO :DWORD
GetSysColorBrush PROTO :DWORD
GetSystemMenu PROTO :DWORD,:DWORD
GetSystemMetrics PROTO :DWORD
GetTabbedTextExtentA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetTabbedTextExtent equ <GetTabbedTextExtentA>

GetTabbedTextExtentW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetThreadDesktop PROTO :DWORD
GetTitleBarInfo PROTO :DWORD,:DWORD
GetTopWindow PROTO :DWORD
GetUpdateRect PROTO :DWORD,:DWORD,:DWORD
GetUpdateRgn PROTO :DWORD,:DWORD,:DWORD
GetUserObjectInformationA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetUserObjectInformation equ <GetUserObjectInformationA>

GetUserObjectInformationW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetUserObjectSecurity PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetWindow PROTO :DWORD,:DWORD
GetWindowContextHelpId PROTO :DWORD
GetWindowDC PROTO :DWORD
GetWindowInfo PROTO :DWORD,:DWORD
GetWindowLongA PROTO :DWORD,:DWORD
GetWindowLong equ <GetWindowLongA>

GetWindowLongW PROTO :DWORD,:DWORD
GetWindowModuleFileNameA PROTO :DWORD,:DWORD,:DWORD
GetWindowModuleFileName equ <GetWindowModuleFileNameA>

GetWindowModuleFileNameW PROTO :DWORD,:DWORD,:DWORD
GetWindowPlacement PROTO :DWORD,:DWORD
GetWindowRect PROTO :DWORD,:DWORD
GetWindowRgn PROTO :DWORD,:DWORD
GetWindowRgnBox PROTO :DWORD,:DWORD
GetWindowTextA PROTO :DWORD,:DWORD,:DWORD
GetWindowText equ <GetWindowTextA>

GetWindowTextLengthA PROTO :DWORD
GetWindowTextLength equ <GetWindowTextLengthA>

GetWindowTextLengthW PROTO :DWORD
GetWindowTextW PROTO :DWORD,:DWORD,:DWORD
GetWindowThreadProcessId PROTO :DWORD,:DWORD
GetWindowWord PROTO :DWORD,:DWORD
GrayStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GrayString equ <GrayStringA>

GrayStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
HideCaret PROTO :DWORD
HiliteMenuItem PROTO :DWORD,:DWORD,:DWORD,:DWORD
IMPGetIMEA PROTO :DWORD,:DWORD
IMPGetIME equ <IMPGetIMEA>

IMPGetIMEW PROTO :DWORD,:DWORD
IMPQueryIMEA PROTO :DWORD
IMPQueryIME equ <IMPQueryIMEA>

IMPQueryIMEW PROTO :DWORD
IMPSetIMEA PROTO :DWORD,:DWORD
IMPSetIME equ <IMPSetIMEA>

IMPSetIMEW PROTO :DWORD,:DWORD
ImpersonateDdeClientWindow PROTO :DWORD,:DWORD
InSendMessage PROTO 
InSendMessageEx PROTO :DWORD
InflateRect PROTO :DWORD,:DWORD,:DWORD
InsertMenuA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InsertMenu equ <InsertMenuA>

InsertMenuItemA PROTO :DWORD,:DWORD,:DWORD,:DWORD
InsertMenuItem equ <InsertMenuItemA>

InsertMenuItemW PROTO :DWORD,:DWORD,:DWORD,:DWORD
InsertMenuW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
InternalGetWindowText PROTO :DWORD,:DWORD,:DWORD
IntersectRect PROTO :DWORD,:DWORD,:DWORD
InvalidateRect PROTO :DWORD,:DWORD,:DWORD
InvalidateRgn PROTO :DWORD,:DWORD,:DWORD
InvertRect PROTO :DWORD,:DWORD
IsCharAlphaA PROTO :DWORD
IsCharAlpha equ <IsCharAlphaA>

IsCharAlphaNumericA PROTO :DWORD
IsCharAlphaNumeric equ <IsCharAlphaNumericA>

IsCharAlphaNumericW PROTO :DWORD
IsCharAlphaW PROTO :DWORD
IsCharLowerA PROTO :DWORD
IsCharLower equ <IsCharLowerA>

IsCharLowerW PROTO :DWORD
IsCharUpperA PROTO :DWORD
IsCharUpper equ <IsCharUpperA>

IsCharUpperW PROTO :DWORD
IsChild PROTO :DWORD,:DWORD
IsClipboardFormatAvailable PROTO :DWORD
IsDialogMessageA PROTO :DWORD,:DWORD
IsDialogMessage equ <IsDialogMessageA>

IsDialogMessageW PROTO :DWORD,:DWORD
IsDlgButtonChecked PROTO :DWORD,:DWORD
IsGUIThread PROTO :DWORD
IsHungAppWindow PROTO :DWORD
IsIconic PROTO :DWORD
IsMenu PROTO :DWORD
IsRectEmpty PROTO :DWORD
IsWinEventHookInstalled PROTO :DWORD
IsWindow PROTO :DWORD
IsWindowEnabled PROTO :DWORD
IsWindowUnicode PROTO :DWORD
IsWindowVisible PROTO :DWORD
IsZoomed PROTO :DWORD
KillTimer PROTO :DWORD,:DWORD
LoadAcceleratorsA PROTO :DWORD,:DWORD
LoadAccelerators equ <LoadAcceleratorsA>

LoadAcceleratorsW PROTO :DWORD,:DWORD
LoadBitmapA PROTO :DWORD,:DWORD
LoadBitmap equ <LoadBitmapA>

LoadBitmapW PROTO :DWORD,:DWORD
LoadCursorA PROTO :DWORD,:DWORD
LoadCursor equ <LoadCursorA>

LoadCursorFromFileA PROTO :DWORD
LoadCursorFromFile equ <LoadCursorFromFileA>

LoadCursorFromFileW PROTO :DWORD
LoadCursorW PROTO :DWORD,:DWORD
LoadIconA PROTO :DWORD,:DWORD
LoadIcon equ <LoadIconA>

LoadIconW PROTO :DWORD,:DWORD
LoadImageA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LoadImage equ <LoadImageA>

LoadImageW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LoadKeyboardLayoutA PROTO :DWORD,:DWORD
LoadKeyboardLayout equ <LoadKeyboardLayoutA>

LoadKeyboardLayoutW PROTO :DWORD,:DWORD
LoadMenuA PROTO :DWORD,:DWORD
LoadMenu equ <LoadMenuA>

LoadMenuIndirectA PROTO :DWORD
LoadMenuIndirect equ <LoadMenuIndirectA>

LoadMenuIndirectW PROTO :DWORD
LoadMenuW PROTO :DWORD,:DWORD
LoadStringA PROTO :DWORD,:DWORD,:DWORD,:DWORD
LoadString equ <LoadStringA>

LoadStringW PROTO :DWORD,:DWORD,:DWORD,:DWORD
LockSetForegroundWindow PROTO :DWORD
LockWindowUpdate PROTO :DWORD
LockWorkStation PROTO 
LookupIconIdFromDirectory PROTO :DWORD,:DWORD
LookupIconIdFromDirectoryEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MapDialogRect PROTO :DWORD,:DWORD
MapVirtualKeyA PROTO :DWORD,:DWORD
MapVirtualKey equ <MapVirtualKeyA>

MapVirtualKeyExA PROTO :DWORD,:DWORD,:DWORD
MapVirtualKeyEx equ <MapVirtualKeyExA>

MapVirtualKeyExW PROTO :DWORD,:DWORD,:DWORD
MapVirtualKeyW PROTO :DWORD,:DWORD
MapWindowPoints PROTO :DWORD,:DWORD,:DWORD,:DWORD
MenuItemFromPoint PROTO :DWORD,:DWORD,:DWORD,:DWORD
MessageBeep PROTO :DWORD
MessageBoxA PROTO :DWORD,:DWORD,:DWORD,:DWORD
MessageBox equ <MessageBoxA>

MessageBoxExA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MessageBoxEx equ <MessageBoxExA>

MessageBoxExW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MessageBoxIndirectA PROTO :DWORD
MessageBoxIndirect equ <MessageBoxIndirectA>

MessageBoxIndirectW PROTO :DWORD
MessageBoxTimeoutA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MessageBoxTimeout equ <MessageBoxTimeoutA>

MessageBoxTimeoutW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MessageBoxW PROTO :DWORD,:DWORD,:DWORD,:DWORD
ModifyMenuA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ModifyMenu equ <ModifyMenuA>

ModifyMenuW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MonitorFromPoint PROTO :DWORD,:DWORD,:DWORD
MonitorFromRect PROTO :DWORD,:DWORD
MonitorFromWindow PROTO :DWORD,:DWORD
MoveWindow PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MsgWaitForMultipleObjects PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
MsgWaitForMultipleObjectsEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
NotifyWinEvent PROTO :DWORD,:DWORD,:DWORD,:DWORD
OemKeyScan PROTO :DWORD
OemToCharA PROTO :DWORD,:DWORD
OemToChar equ <OemToCharA>

OemToCharBuffA PROTO :DWORD,:DWORD,:DWORD
OemToCharBuff equ <OemToCharBuffA>

OemToCharBuffW PROTO :DWORD,:DWORD,:DWORD
OemToCharW PROTO :DWORD,:DWORD
OffsetRect PROTO :DWORD,:DWORD,:DWORD
OpenClipboard PROTO :DWORD
OpenDesktopA PROTO :DWORD,:DWORD,:DWORD,:DWORD
OpenDesktop equ <OpenDesktopA>

OpenDesktopW PROTO :DWORD,:DWORD,:DWORD,:DWORD
OpenIcon PROTO :DWORD
OpenInputDesktop PROTO :DWORD,:DWORD,:DWORD
OpenWindowStationA PROTO :DWORD,:DWORD,:DWORD
OpenWindowStation equ <OpenWindowStationA>

OpenWindowStationW PROTO :DWORD,:DWORD,:DWORD
PackDDElParam PROTO :DWORD,:DWORD,:DWORD
PaintDesktop PROTO :DWORD
PeekMessageA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
PeekMessage equ <PeekMessageA>

PeekMessageW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
PostMessageA PROTO :DWORD,:DWORD,:DWORD,:DWORD
PostMessage equ <PostMessageA>

PostMessageW PROTO :DWORD,:DWORD,:DWORD,:DWORD
PostQuitMessage PROTO :DWORD
PostThreadMessageA PROTO :DWORD,:DWORD,:DWORD,:DWORD
PostThreadMessage equ <PostThreadMessageA>

PostThreadMessageW PROTO :DWORD,:DWORD,:DWORD,:DWORD
PrintWindow PROTO :DWORD,:DWORD,:DWORD
PrivateExtractIconsA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
PrivateExtractIcons equ <PrivateExtractIconsA>

PrivateExtractIconsW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
PtInRect PROTO :DWORD,:DWORD,:DWORD
RealChildWindowFromPoint PROTO :DWORD,:DWORD,:DWORD
RealGetWindowClassA PROTO :DWORD,:DWORD,:DWORD
RealGetWindowClass equ <RealGetWindowClassA>

RealGetWindowClassW PROTO :DWORD,:DWORD,:DWORD
RedrawWindow PROTO :DWORD,:DWORD,:DWORD,:DWORD
RegisterClassA PROTO :DWORD
RegisterClass equ <RegisterClassA>

RegisterClassExA PROTO :DWORD
RegisterClassEx equ <RegisterClassExA>

RegisterClassExW PROTO :DWORD
RegisterClassW PROTO :DWORD
RegisterClipboardFormatA PROTO :DWORD
RegisterClipboardFormat equ <RegisterClipboardFormatA>

RegisterClipboardFormatW PROTO :DWORD
RegisterDeviceNotificationA PROTO :DWORD,:DWORD,:DWORD
RegisterDeviceNotification equ <RegisterDeviceNotificationA>

RegisterDeviceNotificationW PROTO :DWORD,:DWORD,:DWORD
RegisterHotKey PROTO :DWORD,:DWORD,:DWORD,:DWORD
RegisterRawInputDevices PROTO :DWORD,:DWORD,:DWORD
RegisterShellHookWindow PROTO :DWORD
RegisterWindowMessageA PROTO :DWORD
RegisterWindowMessage equ <RegisterWindowMessageA>

RegisterWindowMessageW PROTO :DWORD
ReleaseCapture PROTO 
ReleaseDC PROTO :DWORD,:DWORD
RemoveMenu PROTO :DWORD,:DWORD,:DWORD
RemovePropA PROTO :DWORD,:DWORD
RemoveProp equ <RemovePropA>

RemovePropW PROTO :DWORD,:DWORD
ReplyMessage PROTO :DWORD
ReuseDDElParam PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ScreenToClient PROTO :DWORD,:DWORD
ScrollDC PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ScrollWindow PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ScrollWindowEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SendDlgItemMessageA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SendDlgItemMessage equ <SendDlgItemMessageA>

SendDlgItemMessageW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SendIMEMessageExA PROTO :DWORD,:DWORD
SendIMEMessageEx equ <SendIMEMessageExA>

SendIMEMessageExW PROTO :DWORD,:DWORD
SendInput PROTO :DWORD,:DWORD,:DWORD
SendMessageA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SendMessage equ <SendMessageA>

SendMessageCallbackA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SendMessageCallback equ <SendMessageCallbackA>

SendMessageCallbackW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SendMessageTimeoutA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SendMessageTimeout equ <SendMessageTimeoutA>

SendMessageTimeoutW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SendMessageW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SendNotifyMessageA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SendNotifyMessage equ <SendNotifyMessageA>

SendNotifyMessageW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetActiveWindow PROTO :DWORD
SetCapture PROTO :DWORD
SetCaretBlinkTime PROTO :DWORD
SetCaretPos PROTO :DWORD,:DWORD
SetClassLongA PROTO :DWORD,:DWORD,:DWORD
SetClassLong equ <SetClassLongA>

SetClassLongW PROTO :DWORD,:DWORD,:DWORD
SetClassWord PROTO :DWORD,:DWORD,:DWORD
SetClipboardData PROTO :DWORD,:DWORD
SetClipboardViewer PROTO :DWORD
SetCursor PROTO :DWORD
SetCursorPos PROTO :DWORD,:DWORD
SetDebugErrorLevel PROTO :DWORD
SetDeskWallpaper PROTO :DWORD
SetDlgItemInt PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetDlgItemTextA PROTO :DWORD,:DWORD,:DWORD
SetDlgItemText equ <SetDlgItemTextA>

SetDlgItemTextW PROTO :DWORD,:DWORD,:DWORD
SetDoubleClickTime PROTO :DWORD
SetFocus PROTO :DWORD
SetForegroundWindow PROTO :DWORD
SetKeyboardState PROTO :DWORD
SetLastErrorEx PROTO :DWORD,:DWORD
SetLayeredWindowAttributes PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetMenu PROTO :DWORD,:DWORD
SetMenuContextHelpId PROTO :DWORD,:DWORD
SetMenuDefaultItem PROTO :DWORD,:DWORD,:DWORD
SetMenuInfo PROTO :DWORD,:DWORD
SetMenuItemBitmaps PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetMenuItemInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetMenuItemInfo equ <SetMenuItemInfoA>

SetMenuItemInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetMessageExtraInfo PROTO :DWORD
SetMessageQueue PROTO :DWORD
SetParent PROTO :DWORD,:DWORD
SetProcessDefaultLayout PROTO :DWORD
SetProcessWindowStation PROTO :DWORD
SetPropA PROTO :DWORD,:DWORD,:DWORD
SetProp equ <SetPropA>

SetPropW PROTO :DWORD,:DWORD,:DWORD
SetRect PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetRectEmpty PROTO :DWORD
SetScrollInfo PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetScrollPos PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetScrollRange PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetShellWindow PROTO :DWORD
SetSysColors PROTO :DWORD,:DWORD,:DWORD
SetSystemCursor PROTO :DWORD,:DWORD
SetThreadDesktop PROTO :DWORD
SetTimer PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetUserObjectInformationA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetUserObjectInformation equ <SetUserObjectInformationA>

SetUserObjectInformationW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetUserObjectSecurity PROTO :DWORD,:DWORD,:DWORD
SetWinEventHook PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetWindowContextHelpId PROTO :DWORD,:DWORD
SetWindowLongA PROTO :DWORD,:DWORD,:DWORD
SetWindowLong equ <SetWindowLongA>

SetWindowLongW PROTO :DWORD,:DWORD,:DWORD
SetWindowPlacement PROTO :DWORD,:DWORD
SetWindowPos PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetWindowRgn PROTO :DWORD,:DWORD,:DWORD
SetWindowTextA PROTO :DWORD,:DWORD
SetWindowText equ <SetWindowTextA>

SetWindowTextW PROTO :DWORD,:DWORD
SetWindowWord PROTO :DWORD,:DWORD,:DWORD
SetWindowsHookA PROTO :DWORD,:DWORD
SetWindowsHook equ <SetWindowsHookA>

SetWindowsHookExA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetWindowsHookEx equ <SetWindowsHookExA>

SetWindowsHookExW PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetWindowsHookW PROTO :DWORD,:DWORD
ShowCaret PROTO :DWORD
ShowCursor PROTO :DWORD
ShowOwnedPopups PROTO :DWORD,:DWORD
ShowScrollBar PROTO :DWORD,:DWORD,:DWORD
ShowWindow PROTO :DWORD,:DWORD
ShowWindowAsync PROTO :DWORD,:DWORD
SubtractRect PROTO :DWORD,:DWORD,:DWORD
SwapMouseButton PROTO :DWORD
SwitchDesktop PROTO :DWORD
SwitchToThisWindow PROTO :DWORD,:DWORD
SystemParametersInfoA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SystemParametersInfo equ <SystemParametersInfoA>

SystemParametersInfoW PROTO :DWORD,:DWORD,:DWORD,:DWORD
TabbedTextOutA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
TabbedTextOut equ <TabbedTextOutA>

TabbedTextOutW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
TileChildWindows PROTO :DWORD,:DWORD
TileWindows PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ToAscii PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ToAsciiEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ToUnicode PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ToUnicodeEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
TrackMouseEvent PROTO :DWORD
TrackPopupMenu PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
TrackPopupMenuEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
TranslateAcceleratorA PROTO :DWORD,:DWORD,:DWORD
TranslateAccelerator equ <TranslateAcceleratorA>

TranslateAcceleratorW PROTO :DWORD,:DWORD,:DWORD
TranslateMDISysAccel PROTO :DWORD,:DWORD
TranslateMessage PROTO :DWORD
UnhookWinEvent PROTO :DWORD
UnhookWindowsHook PROTO :DWORD,:DWORD
UnhookWindowsHookEx PROTO :DWORD
UnionRect PROTO :DWORD,:DWORD,:DWORD
UnloadKeyboardLayout PROTO :DWORD
UnpackDDElParam PROTO :DWORD,:DWORD,:DWORD,:DWORD
UnregisterClassA PROTO :DWORD,:DWORD
UnregisterClass equ <UnregisterClassA>

UnregisterClassW PROTO :DWORD,:DWORD
UnregisterDeviceNotification PROTO :DWORD
UnregisterHotKey PROTO :DWORD,:DWORD
UpdateLayeredWindow PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
UpdateWindow PROTO :DWORD
UserHandleGrantAccess PROTO :DWORD,:DWORD,:DWORD
ValidateRect PROTO :DWORD,:DWORD
ValidateRgn PROTO :DWORD,:DWORD
VkKeyScanA PROTO :DWORD
VkKeyScan equ <VkKeyScanA>

VkKeyScanExA PROTO :DWORD,:DWORD
VkKeyScanEx equ <VkKeyScanExA>

VkKeyScanExW PROTO :DWORD,:DWORD
VkKeyScanW PROTO :DWORD
WINNLSEnableIME PROTO :DWORD,:DWORD
WINNLSGetEnableStatus PROTO :DWORD
WINNLSGetIMEHotkey PROTO :DWORD
WaitForInputIdle PROTO :DWORD,:DWORD
WaitMessage PROTO 
WinHelpA PROTO :DWORD,:DWORD,:DWORD,:DWORD
WinHelp equ <WinHelpA>

WinHelpW PROTO :DWORD,:DWORD,:DWORD,:DWORD
WindowFromDC PROTO :DWORD
WindowFromPoint PROTO :DWORD,:DWORD
keybd_event PROTO :DWORD,:DWORD,:DWORD,:DWORD
mouse_event PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
wvsprintfA PROTO :DWORD,:DWORD,:DWORD
wvsprintf equ <wvsprintfA>

wvsprintfW PROTO :DWORD,:DWORD,:DWORD

ELSE
echo -----------------------------------------
echo WARNING Duplicate include file user32.inc
echo -----------------------------------------
ENDIF
