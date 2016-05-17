VERSION 5.00
Begin VB.UserControl ucPickBox 
   ClientHeight    =   2055
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   2175
   ScaleHeight     =   2055
   ScaleWidth      =   2175
   ToolboxBitmap   =   "ucPickBox.ctx":0000
   Begin VB.CommandButton cmdDrop 
      Caption         =   "u"
      BeginProperty Font 
         Name            =   "Marlett"
         Size            =   9.75
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   275
      Left            =   720
      TabIndex        =   3
      TabStop         =   0   'False
      ToolTipText     =   "Click Here to View Selected Files."
      Top             =   720
      Visible         =   0   'False
      Width           =   275
   End
   Begin VB.CommandButton cmdPick 
      Caption         =   "..."
      Height          =   275
      Left            =   1155
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   30
      Width           =   275
   End
   Begin VB.ComboBox cmbMultiSel 
      Height          =   315
      Left            =   0
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   360
      Visible         =   0   'False
      Width           =   1455
   End
   Begin VB.PictureBox pbPick 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   285
      Left            =   0
      Picture         =   "ucPickBox.ctx":0312
      ScaleHeight     =   285
      ScaleWidth      =   255
      TabIndex        =   4
      Top             =   720
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.PictureBox pbDrop 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   285
      Left            =   360
      Picture         =   "ucPickBox.ctx":0717
      ScaleHeight     =   285
      ScaleWidth      =   255
      TabIndex        =   5
      Top             =   720
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.TextBox txtResult 
      Height          =   315
      Left            =   0
      MaxLength       =   65384
      ScrollBars      =   1  'Horizontal
      TabIndex        =   0
      TabStop         =   0   'False
      Text            =   "Locate Color..."
      Top             =   0
      Width           =   1455
   End
   Begin VB.Shape ShapeBorder 
      BorderColor     =   &H00B99D7F&
      Height          =   735
      Left            =   1560
      Top             =   0
      Width           =   495
   End
   Begin VB.Image imMetallicDrop 
      Height          =   285
      Index           =   3
      Left            =   1800
      Picture         =   "ucPickBox.ctx":0B19
      Top             =   1680
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imHomeSteadDrop 
      Height          =   285
      Index           =   3
      Left            =   1800
      Picture         =   "ucPickBox.ctx":0EDE
      Top             =   1380
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imBlueDrop 
      Height          =   285
      Index           =   3
      Left            =   1800
      Picture         =   "ucPickBox.ctx":12A3
      Top             =   1080
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imMetallicDrop 
      Height          =   285
      Index           =   2
      Left            =   1560
      Picture         =   "ucPickBox.ctx":1668
      Top             =   1680
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imHomeSteadDrop 
      Height          =   285
      Index           =   2
      Left            =   1560
      Picture         =   "ucPickBox.ctx":1A56
      Top             =   1380
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imBlueDrop 
      Height          =   285
      Index           =   2
      Left            =   1560
      Picture         =   "ucPickBox.ctx":1E49
      Top             =   1080
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imMetallicDrop 
      Height          =   285
      Index           =   1
      Left            =   1320
      Picture         =   "ucPickBox.ctx":2276
      Top             =   1680
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imHomeSteadDrop 
      Height          =   285
      Index           =   1
      Left            =   1320
      Picture         =   "ucPickBox.ctx":2656
      Top             =   1380
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imBlueDrop 
      Height          =   285
      Index           =   1
      Left            =   1320
      Picture         =   "ucPickBox.ctx":2A3D
      Top             =   1080
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imMetallicDrop 
      Height          =   285
      Index           =   0
      Left            =   1080
      Picture         =   "ucPickBox.ctx":2E5A
      Top             =   1680
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imHomeSteadDrop 
      Height          =   285
      Index           =   0
      Left            =   1080
      Picture         =   "ucPickBox.ctx":324B
      Top             =   1380
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imBlueDrop 
      Height          =   285
      Index           =   0
      Left            =   1080
      Picture         =   "ucPickBox.ctx":364F
      Top             =   1080
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imMetallic 
      Height          =   285
      Index           =   3
      Left            =   720
      Picture         =   "ucPickBox.ctx":3A51
      Top             =   1680
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imHomeStead 
      Height          =   285
      Index           =   3
      Left            =   720
      Picture         =   "ucPickBox.ctx":3E15
      Top             =   1380
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imBlue 
      Height          =   285
      Index           =   3
      Left            =   720
      Picture         =   "ucPickBox.ctx":41D6
      Top             =   1080
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imMetallic 
      Height          =   285
      Index           =   2
      Left            =   480
      Picture         =   "ucPickBox.ctx":4597
      Top             =   1680
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imHomeStead 
      Height          =   285
      Index           =   2
      Left            =   480
      Picture         =   "ucPickBox.ctx":4979
      Top             =   1380
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imBlue 
      Height          =   285
      Index           =   2
      Left            =   480
      Picture         =   "ucPickBox.ctx":4D74
      Top             =   1080
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imMetallic 
      Height          =   285
      Index           =   1
      Left            =   240
      Picture         =   "ucPickBox.ctx":51A4
      Top             =   1680
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imHomeStead 
      Height          =   285
      Index           =   1
      Left            =   240
      Picture         =   "ucPickBox.ctx":558D
      Top             =   1380
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imBlue 
      Height          =   285
      Index           =   1
      Left            =   240
      Picture         =   "ucPickBox.ctx":5977
      Top             =   1080
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imMetallic 
      Height          =   285
      Index           =   0
      Left            =   0
      Picture         =   "ucPickBox.ctx":5D9C
      Top             =   1680
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imHomeStead 
      Height          =   285
      Index           =   0
      Left            =   0
      Picture         =   "ucPickBox.ctx":6182
      Top             =   1380
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Image imBlue 
      Height          =   285
      Index           =   0
      Left            =   0
      Picture         =   "ucPickBox.ctx":6586
      Top             =   1080
      Visible         =   0   'False
      Width           =   255
   End
End
Attribute VB_Name = "ucPickBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'+  File Description:
'       ucPickBox - Enhanced File/Color/Font/Printer Picker Control
'
'   Product Name:
'       ucPickBox.ctl
'
'   Compatability:
'       Windows: 98, ME, NT, 2000, XP
'
'   Software Developed by:
'       Paul R. Territo, Ph.D
'
'   Based on the following On-Line Articles
'       (Common Dialog API Calls - Paul Mather)
'           URL: http://www.planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=3592&lngWId=1
'       (TrimPathLen Function - Wastingtape)
'           URL: http://www.planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=23456&lngWId=1
'       (FileExists - Eric Russell)
'           URL: http://www.planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=829&lngWId=1
'       (ComboBox Open/Visible - Francesco Balena)
'           URL: http://www.devx.com/vb2themax/Tip/18336
'       (Max Raskin - Flat Button)
'           http://www.planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=6517&lngWId=1
'       (BrowseForFolder - DaVBMan, MrBobo)
'           http://vbcity.com/forums/topic.asp?tid=82667
'           http://www.Planet-Source-Code.com/vb/scripts/ShowCode.asp?txtCodeId=22387&lngWId=1
'       (Randy Birch - IsWinXP)
'           http://vbnet.mvps.org/code/system/getversionex.htm
'       (Dieter Otter - GetCurrentThemeName)
'           http://www.vbarchiv.net/archiv/tipp_805.html
'
'   Legal Copyright & Trademarks:
'       Copyright © 2006, by Paul R. Territo, Ph.D, All Rights Reserved Worldwide
'       Trademark ô 2006, by Paul R. Territo, Ph.D, All Rights Reserved Worldwide
'
'   Comments:
'       No claims or warranties are expressed or implied as to accuracy or fitness
'       for use of this software. Paul R. Territo, Ph.D shall not be liable
'       for any incidental or consequential damages suffered by any use of
'       this  software. This software is owned by Paul R. Territo, Ph.D and is
'       sold for use as a license in accordance with the terms of the License
'       Agreement in the accompanying the documentation.
'
'       Many thanks to my friend Paul Turcksin for his careful review, suggestions,
'       and support of this UserControl and TestHarness prior to public release. In
'       addtion, I wish to thank the numerous open source authors who provide code
'       and inspiration to make such work possible.
'
'   Contact Information:
'       For Technical Assistance:
'       Email: pwterrito@insightbb.com
'
'-  Modification(s) History:
'       05Nov05 - Initial TestHarness and UserControl finished
'       06Nov05 - Cleaned up bugs in the ShowSave and ShowOpen routines.
'               - Consolidated calls for the Show Open/Save subs to make
'                 param and error handling cleaner.
'               - Added addtional API params to the ShowFont routine.
'               - Updated the ToolBox Image to a more professional image.
'               - Added addtional error handling to the TestHarness...
'       19Nov05 - Added Additional Author Credits to the Header
'               - Added UseDialogColor, UseDialogText, ForeColor, and
'                 BackColor properties to the Control and required code to
'                 allow these routines to work...
'               - Added PrintStatusMsg property to allow the user to specify
'                 what the message should say when the printer returns a value.
'               - Added PrintStaus property to provide the user feedback about
'                 if the Printer dialog "Ok"(1) or "Cancel"(0) button was pressed.
'               - Fixed bug in ShowSave routine which inconssistently computes the
'                 nFileOffset values for a file. We simply set this to "0" and then
'                 extract the values from outside of this of this routine.
'               - Changes Color from Long to OLE_COLOR property to allow for
'                 vb stanard palette.
'               - Added TranslateColor sub to wrap the OleTranslateColor method
'                 for mapping of colors to the current RGB palette.
'       20Nov05 - Added Color RollBack if the value entered is invalid.
'       04Dec05 - Changed the TestHarness layout to make it easier to follow the
'                 flow of the controls and how to use it....
'       06Dec05 - Added MultiFile selection for the ShowOpen routine and fixed several
'                 bugs with the single vs mutiple file selections.
'               - Added a ComboBox to serve at the conatiner and windowing mechanism for
'                 the list and its events....this is a hack, pure and simple. This
'                 approach was selected as it allowes a floating window and list functionality
'                 without the need for building this via API. The combobox is hidden
'                 behind the textbox at runtime and has Visiable = False. Since we
'                 call the droplist window via SendMessage this allows us to have a
'                 floating window like the ComboBox, but none of the overhead to manage ;-D
'               - Add the ability to programmatically Open the MultiFile ComboBox
'                 and check the state of the Droplist.
'               - Added cmdDrop button to simulate the drop button of the ComboBox. The
'                 key feature here being that the button is to the left of the ellipes
'                 button and is resizable with the dialog, unlike the VB ComboBox.
'       13Dec05 - Fixed minor TestHareness bug which displayed the wrong properties when
'                 selecting the lstProperties index.
'       14Dec05 - Fixed single/multiple file open bug in the ShowOpen routine which caused the
'                 the sub to enter into the wrong conditional section when a single file
'                 was selected and the MultiSelect = False.
'               - Fixed PropertyChanged calls for DialogMsg and ToolTipTexts which now supports
'                 individual item settings.
'       15Dec05 - More optimization on the ShowSave and ShowFont routines. These routines now
'                 handle missing extensions and provide a mechanism to enter them. In addtion,
'                 the FontColor property has been added to allow direct color picking of the
'                 font ForeColor, which is not appart of the StdFont structure.
'       16Dec05 - Added Appearance Property and associated API and VB routines to allow for true
'                 3D or Flat appearances of the textbox and buttons.
'       18Dec05 - Fixed Minor bugs in the ShowFont dialog routines which did not preserve the
'                 previous selections by the user. The new addtions resolve all but one known
'                 bug. At the current time, the iPointSize of the FontDialog type structure is
'                 not correctly set via code and the dialog does not respond the changes in this
'                 parameter despite accounting for the size and weight of the font. Verified the
'                 ShowFont code against www.allapi.net example and neither resulted in the pointsize
'                 being selected. For more details see http://mentalis.org/apilist/CHOOSEFONT.shtml
'       25Dec05 - Added Events: DropClick, KeyDown, KeyPress, KeyUp, MouseDown, MouseMove, MouseUp.
'               - Added GetCursorPosition function to allow reporting of the Cursor position via
'                 GetCursorPosition and ScreenToClient API's regardless of which part of the control
'                 the cursor is over. This effectively bypasses the native Event Handlers for each
'                 control, and provides a uniform reporting of the cursor position on the control surface.
'               - Added additional documentation at the Method and Property levels to provide added
'                 clarity of what the functionality is...
'       26Dec05 - Added Filter Property and associated routines to the ShowOpen, ShowSave routines,
'                 see Filter Let property for correct format of the filter string....
'               - Added ProcessFilter to replace string Pipes (|) with vbNullChar and fix the
'                 final size of the passed string to the dialogs.
'               - Added error handling for none initialized Filters to read All Files (*.*)
'       27Dec05 - Added Color, Font, File, and PrinterFlags as Public Enums along with properties
'                 to allow the developer set the styles more easily.
'               - Added SHOWCOLOR_DEFAULT, SHOWFONT_DEFAULT, SHOWOPEN_DEFAULT, SHOWSAVE_DEFAULT,
'                 and SHOWPRINTER_DEFAULT custom Non-Win32 flags to allow for rapid dialog setting
'                 which encompass the most common flags used with this control.
'               - Updated the TestHarness in the UpdatePropertiesDialog to reflect these changes.
'       28Dec05 - Added UseAutoForeColor and associated routines to allow the developer to choose
'                 if the ForeColor is to be selected automatically. The value for the new ForeColor
'                 is based on the XOr of the BackColor and should always produce high contrast text
'                 in the dialog regardless of the color selected.
'       03Jan06 - Added BrowseForFolder functionality and associated routines to round out the collection
'                 based on the request from Richard Mewett.
'       07Mar06 - Added Let Property for Path to pass data to txtResult and m_Path parameter. The displayed
'                 Path is trimmed using the TrimPathLen routine.
'               - Fixed bug which causes the txtResult to display the incorrect message when ucFolder was the
'                 dialog type.
'       16Mar06 - Add Paul Caton's SelfSubclass Thunk code to allow for BrowseForFolder CallBack without the
'                 need for an external bas module. The long point (address) of the z_SubclassProc is held in
'                 in the sc_aSubData(0).nAddrSub provided this is the only item we are subclassing....if we are
'                 subclassing multiple items (i.e. Usercontrol, Parent) then the address for each is stored in
'                 order in the sc_aSubData(n).nAddrSub, where n = 0, 1....n
'       06Jun06 - Added Theme capability and associated routines to allow for XP Themes
'               - Added Theme Properties
'               - Removed Parent subclassing for ThemeChange and SystemColor change messages, because this
'                 caused the IDE to crash on close.
'               - Fixed minor bug in BorderStyle when controls are Flat and change to Theme
'       10Jun06 - Fixed Minor bug in the Refresh routine which did not set the Classic style
'                 correctly if the previous Apearance = Flat
'               - Added LockWindowUpdate to prevent flicker on Picture changes
'       28Jun06 - Fixed TrimPathByLen to be Printer Object independent
'       15Jul06 - Fixed TrackMouse missing Subclaser Code
'       16Jul06 - Fixed Missing IsWinXP routine in GetThemeInfo Method
'       29Jun07 - Fixed bug in ShowSave and ShowOpen dialogs which did not process the default extensions
'               - Added DefaultExt property to allow the developer to set the default extension to
'                 use in the Open/Save Dailogs
'       08Aug07 - Fixed Bug in the BFF section which did not correctly Qualify Paths.
'
'   Force Declarations
Option Explicit
'
'   Build Date & Time: 8/8/2007 10:22:17 AM
Const Major As Long = 2
Const Minor As Long = 0
Const Revision As Long = 200

Private Type OSVERSIONINFO
  OSVSize         As Long         'size, in bytes, of this data structure
  dwVerMajor      As Long         'ie NT 3.51, dwVerMajor = 3; NT 4.0, dwVerMajor = 4.
  dwVerMinor      As Long         'ie NT 3.51, dwVerMinor = 51; NT 4.0, dwVerMinor= 0.
  dwBuildNumber   As Long         'NT: build number of the OS
                                  'Win9x: build number of the OS in low-order word.
                                  '       High-order word contains major & minor ver nos.
  PlatformID      As Long         'Identifies the operating system platform.
  szCSDVersion    As String * 128 'NT: string, such as "Service Pack 3"
                                  'Win9x: string providing arbitrary additional information
End Type


'   Private API Declarations
Private Declare Function CHOOSECOLOR Lib "comdlg32.dll" Alias "ChooseColorA" (pChoosecolor As CHOOSECOLORS) As Long
Private Declare Function CHOOSEFONT Lib "comdlg32.dll" Alias "ChooseFontA" (pChoosefont As CHOOSEFONTS) As Long
Private Declare Function CommDlgExtendedError Lib "comdlg32.dll" () As Long
Private Declare Function FindClose Lib "kernel32" (ByVal hFindFile As Long) As Long
Private Declare Function FindFirstFile Lib "kernel32" Alias "FindFirstFileA" (ByVal lpFileName As String, lpFindFileData As WIN32_FIND_DATA) As Long
Private Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
Private Declare Function GetOpenFileName Lib "comdlg32.dll" Alias "GetOpenFileNameA" (pOpenfilename As OPENFILENAME) As Long
Private Declare Function GetSaveFileName Lib "comdlg32.dll" Alias "GetSaveFileNameA" (pOpenfilename As OPENFILENAME) As Long
Private Declare Function GetShortPathName Lib "kernel32" Alias "GetShortPathNameA" (ByVal lpszLongPath As String, ByVal lpszShortPath As String, ByVal cchBuffer As Long) As Long
Private Declare Function LockWindowUpdate Lib "user32" (ByVal hwndLock As Long) As Long
Private Declare Function LocalAlloc Lib "kernel32" (ByVal uFlags As Long, ByVal uBytes As Long) As Long
Private Declare Function OleTranslateColor Lib "OLEPRO32.DLL" (ByVal OLE_COLOR As Long, ByVal HPALETTE As Long, pccolorref As Long) As Long
Private Declare Function PrintDlg Lib "comdlg32.dll" Alias "PrintDlgA" (pPrintdlg As PRINTDLGS) As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Declare Function SetFocus Lib "user32" (ByVal hWnd As Long) As Long
Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function ScreenToClient Lib "user32.dll" (ByVal hWnd As Long, lpPoint As POINTAPI) As Long
Private Declare Function GetCurrentThemeName Lib "uxtheme.dll" (ByVal pszThemeFileName As String, ByVal dwMaxNameChars As Integer, ByVal pszColorBuff As String, ByVal cchMaxColorChars As Integer, ByVal pszSizeBuff As String, ByVal cchMaxSizeChars As Integer) As Long
Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInformation As Any) As Long

Private Declare Function lStrCat Lib "kernel32" Alias "lstrcatA" (ByVal lpString1 As String, ByVal lpString2 As String) As Long
Private Declare Function SHGetPathFromIDList Lib "shell32.dll" Alias "SHGetPathFromIDListA" (ByVal pidl As Long, ByVal pszPath As String) As Long
Private Declare Function SHBrowseForFolder Lib "shell32.dll" Alias "SHBrowseForFolderA" (lpBrowseInfo As BROWSEINFO) As Long
Private Declare Sub CoTaskMemFree Lib "ole32.dll" (ByVal pv As Long)

Private Const VER_PLATFORM_WIN32_NT = 2
Private Const WM_USER As Long = &H400
Private Const BFFM_INITIALIZED = 1
Private Const BFFM_SETSELECTIONA As Long = (WM_USER + 102)
Private Const LMEM_FIXED = &H0
Private Const LMEM_ZEROINIT = &H40
Private Const LPTR = (LMEM_FIXED Or LMEM_ZEROINIT)
Private Const FILE_ATTRIBUTE_DIR = &H10

'   Appearance Costants
Public Enum pbAppearanceConstants
    [Flat] = &H0
    [3D] = &H1
End Enum

Public Enum pbThemeEnum
    [pbAuto] = &H0
    [pbClassic] = &H1
    [pbBlue] = &H2
    [pbHomeStead] = &H3
    [pbMetallic] = &H4
End Enum

Private Enum pbStateEnum
    [pbNormal] = &H0
    [pbHover] = &H1
    [pbDown] = &H2
    [pbDisabled] = &H3
End Enum

'   Flat Button API Constants
'   The button style BS_FLAT used to change a button to a Flat one
Private Const BS_FLAT = &H8000&
'   GWL_Style is the attribute we will use for changing the style of the button
Private Const GWL_STYLE = (-16)
'   To set the button as a child window and not as a self dependent window
Private Const WS_CHILD = &H40000000

'   Send Message Constants for ComboBoxes
Private Const CB_SHOWDROPDOWN = &H14F
Private Const CB_GETDROPPEDSTATE = &H157

Public Enum ColorDialogFlags
    '   ShowColor Flags
    RGBInit = &H1
    FullOpen = &H2
    PreventFullOpen = &H4
    ShowHelp = &H8
    EnableHook = &H10
    EnableTemplate = &H20
    EnableTemplateHandle = &H40
    SolidColor = &H80
    AnyColor = &H100
    '   Custom Non-Win32 Flags which are a Combinations of Flags
    ShowColor_Default = FullOpen Or AnyColor Or RGBInit
End Enum

Public Enum FolderDialogFlags
    ReturnOnlyFSDirs = &H1
    DontGoBelowDomain = &H2
    statusText = &H4
    ReturnFSAncestors = &H8
    EditBox = &H10
    Validate = &H20
    NewDialogStyle = &H40
    UseNewUI = (NewDialogStyle Or EditBox)
    BrowseIncludeURLs = &H80
    UAHInt = &H100
    NoneWFolderButton = &H200
    NoTranslateTargets = &H400
    BrowseForComputer = &H1000
    BrowseForPrinter = &H2000
    BrowseIncludeFiles = &H4000
    Shareable = &H8000
    ShowFolder_Default = NewDialogStyle Or BrowseForComputer
End Enum

Public Enum FontDialogFlags
    '   ShowFont Flags
    ScreenFonts = &H1
    PrinterFonts = &H2
    Both = (ScreenFonts Or PrinterFonts)
    ShowHelp = &H4
    EnableHook = &H8
    EnableTemplate = &H10
    EnableTemplateHandle = &H20
    InitToLogFontStruct = &H40
    UseStyle = &H80
    Effects = &H100
    Apply = &H200
    AnsiOnly = &H400
    ScriptsOnly = AnsiOnly
    NoVectorFonts = &H800
    NoOEMFonts = NoVectorFonts
    NoSimulations = &H1000
    LimitSize = &H2000
    FixedPitchOnly = &H4000
    WYSIWYG = &H8000 '  Must Also Have Screenfonts Printerfonts
    ForceFontExist = &H10000
    ScalableOnly = &H20000
    TTonly = &H40000
    NoFaceSel = &H80000
    NoStyleSel = &H100000
    NoSizeSel = &H200000
    SelectScript = &H400000
    NoScriptSel = &H800000
    NoVertFonts = &H1000000
    '   Custom Non-Win32 Flags which are a Combinations of Flags
    ShowFont_Default = Both Or Effects Or ForceFontExist Or InitToLogFontStruct Or LimitSize
End Enum

Public Enum OpenSaveDialogFlags
    '   ShowOpen / ShowSave Flags
    ReadOnly = &H1
    OverwritePrompt = &H2
    HideReadOnly = &H4
    NoChangeDir = &H8
    ShowHelp = &H10
    EnableHook = &H20
    EnableTemplate = &H40
    EnableTemplateHandle = &H80
    NoValidate = &H100
    AllowMultiselect = &H200
    ExtensionDifferent = &H400
    PathMustExist = &H800
    FileMustExist = &H1000
    Createprompt = &H2000
    ShareAware = &H4000
    NoReadOnlyReturn = &H8000
    NoTestFileCreate = &H10000
    NoNetworkButton = &H20000
    NoLongNames = &H40000
    Explorer = &H80000
    LongNames = &H200000
    NoDeReferenceLinks = &H100000
    '   Custom Non-Win32 Flags Which Are A Combinations Of Flags
    ShowOpen_Default = Explorer Or LongNames Or Createprompt Or NoDeReferenceLinks Or HideReadOnly
    ShowSave_Default = Explorer Or LongNames Or OverwritePrompt Or HideReadOnly
End Enum

Public Enum PrinterDialogFlags
    '   ShowPrinter Flags
    AllPages = &H0
    Selection = &H1
    PageNums = &H2
    NoSelection = &H4
    NoPageNums = &H8
    Collate = &H10
    PrintToFile = &H20
    PrintSetup = &H40
    NoWarning = &H80
    ReturnDC = &H100
    ReturnIC = &H200
    ReturnDefault = &H400
    ShowHelp = &H800
    EnablePrintHook = &H1000
    EnableSetupHook = &H2000
    EnablePrintTemplate = &H4000
    EnableSetupTemplate = &H8000
    EnablePrintTemplateHandle = &H10000
    EnableSetupTemplateHandle = &H20000
    UseDevModeCopies = &H40000
    UseDevModeCopiesAndCollate = &H40000
    DisablePrintToFile = &H80000
    HidePrintToFile = &H100000
    NoNetworkButton = &H200000
    '   Custom Non-Win32 Flags Which Are A Combinations Of Flags
    ShowPrinter_Default
End Enum

Public Enum ucDialogConstant
    [ucColor] = &H0
    [ucFolder] = &H1
    [ucFont] = &H2
    [ucOpen] = &H3
    [ucSave] = &H4
    [ucPrint] = &H5
End Enum

Private Const FW_NORMAL = 400
Private Const OUT_DEFAULT_PRECIS = 0
Private Const CLIP_DEFAULT_PRECIS = 0
Private Const DEFAULT_QUALITY = 0
Private Const DEFAULT_PITCH = 0
Private Const MAX_PATH As Long = 4096 '260

Private Const BIF_RETURNONLYFSDIRS = 1
Private Const BIF_DONTGOBELOWDOMAIN = 2

Private Type BROWSEINFO
    hwndOwner As Long
    pIDLRoot As Long
    pszDisplayName As Long
    lpszTitle As Long
    ulFlags As Long
    lpfnCallback As Long
    lParam As Long
    iImage As Long
End Type

Private Type FILETIME
    dwLowDateTime  As Long
    dwHighDateTime As Long
End Type

Private Type WIN32_FIND_DATA
    dwFileAttributes As Long
    ftCreationTime   As FILETIME
    ftLastAccessTime As FILETIME
    ftLastWriteTime  As FILETIME
    nFileSizeHigh    As Long
    nFileSizeLow     As Long
    dwReserved_      As Long
    dwReserved1      As Long
    cFileName        As String * MAX_PATH
    cAlternate       As String * 14
End Type

Private Type CHOOSECOLORS
    lStructSize As Long
    hwndOwner As Long
    hInstance As Long
    rgbResult As Long
    lpCustColors As String
    Flags As Long
    lCustData As Long
    lpfnHook As Long
    lpTemplateName As String
End Type

Private Type OPENFILENAME
    nStructSize As Long
    hwndOwner As Long
    hInstance As Long
    sFilter As String
    sCustomFilter As String
    nCustFilterSize As Long
    nFilterIndex As Long
    sFile As String
    nFileSize As Long
    sFileTitle As String
    nTitleSize As Long
    sInitDir As String
    sDlgTitle As String
    Flags As Long
    nFileOffset As Integer
    nFileExt As Integer
    sDefFileExt As String
    nCustDataSize As Long
    fnHook As Long
    sTemplateName As String
End Type

Private Type SelectedColor
    oSelectedColor As OLE_COLOR
    bCanceled As Boolean
End Type

Private Const LF_FACESIZE = 33
Private Type LOGFONT
    lfHeight As Long
    lfWidth As Long
    lfEscapement As Long
    lfOrientation As Long
    lfWeight As Long
    lfItalic As Byte
    lfUnderline As Byte
    lfStrikeOut As Byte
    lfCharSet As Byte
    lfOutPrecision As Byte
    lfClipPrecision As Byte
    lfQuality As Byte
    lfPitchAndFamily As Byte
    lfFacename(LF_FACESIZE) As Byte
End Type

Private Type CHOOSEFONTS
    lStructSize As Long
    hwndOwner As Long           '  caller's window handle
    hDC As Long                 '  printer DC/IC or NULL
    lpLogFont As Long           '  ptr. to a LOGFONT struct
    iPointSize As Long          '  10 * size in points of selected font
    Flags As Long               '  enum. type flags
    rgbColors As Long           '  returned text color
    lCustData As Long           '  data passed to hook fn.
    lpfnHook As Long            '  ptr. to hook function
    lpTemplateName As String    '  custom template name
    hInstance As Long           '  instance handle of.EXE that
    lpszStyle As String         '  return the style field here
    nFontType As Integer        '  same value reported to the EnumFonts
    MISSING_ALIGNMENT As Integer
    nSizeMin As Long            '  minimum pt size allowed &
    nSizeMax As Long            '  max pt size allowed if
End Type

Private Type PRINTDLGS
    lStructSize As Long
    hwndOwner As Long
    hDevMode As Long
    hDevNames As Long
    hDC As Long
    Flags As Long
    nFromPage As Integer
    nToPage As Integer
    nMinPage As Integer
    nMaxPage As Integer
    nCopies As Integer
    hInstance As Long
    lCustData As Long
    lpfnPrintHook As Long
    lpfnSetupHook As Long
    lpPrintTemplateName As String
    lpSetupTemplateName As String
    hPrintTemplate As Long
    hSetupTemplate As Long
End Type

Private Type DEVNAMES
    wDriverOffset As Integer
    wDeviceOffset As Integer
    wOutputOffset As Integer
    wDefault As Integer
End Type

Private Type SelectedFile
    nFilesSelected As Integer
    sFiles() As String
    sLastDirectory As String
    bCanceled As Boolean
End Type

Private Type SelectedFont
    sSelectedFont As String
    bCanceled As Boolean
    bBold As Boolean
    bItalic As Boolean
    nSize As Integer
    bUnderline As Boolean
    bStrikeOut As Boolean
    lColor As Long
    sFaceName As String
End Type

Private Type POINTAPI
    X As Long
    Y As Long
End Type

'   Private Dialog Structure Definitions
Private ColorDialog         As CHOOSECOLORS
Private FileDialog          As OPENFILENAME
Private FontDialog          As CHOOSEFONTS
Private PrintDialog         As PRINTDLGS

'   Private UserControl Properties
Private m_Appearance        As pbAppearanceConstants
Private m_UseAutoForeColor  As Boolean
Private m_BackColor         As OLE_COLOR
Private m_Color             As OLE_COLOR
Private m_ColorFlags        As ColorDialogFlags
Private m_CursorPt          As POINTAPI
Private m_DefaultExt        As String
Private m_DialogMsg(5)      As String
Private m_DialogType        As ucDialogConstant
Private m_Enabled           As Boolean
Private m_FileCount         As Long
Private m_FileFlags         As OpenSaveDialogFlags
Private m_Filename()        As String
Private m_Filters           As String
Private m_FolderFlags       As FolderDialogFlags
Private m_Font              As StdFont
Private m_FontColor         As OLE_COLOR
Private m_FontFlags         As FontDialogFlags
Private m_ForeColor         As OLE_COLOR
Private m_hWnd              As Long
Private m_MultiSelect       As Boolean
Private m_Path              As String
Private m_Pnt               As POINTAPI
Private m_PrevBackColor     As OLE_COLOR
Private m_PrevLoc           As POINTAPI
Private m_Printer           As String
Private m_PrinterFlags      As PrinterDialogFlags
Private m_PrintStatus       As Boolean
Private m_PrintStatusMsg(1) As String
Private m_State             As pbStateEnum
Private m_ToolTipText(5)    As String
Private m_Theme             As pbThemeEnum
Private m_UseDialogColor    As Boolean
Private m_UseDialogText     As Boolean
Private sPrevColor          As String
'   Custom Colors Dialog Array
Private CustomColors(0 To (16 * 4 - 1)) As Byte

'   Public UserControl Events
Public Event Click()
Public Event ColorChanged(NewColor As Long)
Public Event DblClick()
Public Event DropClick()
Public Event FontChanged(FontName As String)
Public Event KeyDown(KeyCode As Integer, Shift As Integer)
Public Event KeyPress(KeyAscii As Integer)
Public Event KeyUp(KeyCode As Integer, Shift As Integer)
Public Event MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event PathChanged()
Public Event PrintStatus(Status As String)

'==================================================================================================
' ucSubclass - A template UserControl for control authors that require self-subclassing without ANY
'              external dependencies. IDE safe.
'
' Paul_Caton@hotmail.com
' Copyright free, use and abuse as you see fit.
'
' v1.0.0000 20040525 First cut.....................................................................
' v1.1.0000 20040602 Multi-subclassing version.....................................................
' v1.1.0001 20040604 Optimized the subclass code...................................................
' v1.1.0002 20040607 Substituted byte arrays for strings for the code buffers......................
' v1.1.0003 20040618 Re-patch when adding extra hWnds..............................................
' v1.1.0004 20040619 Optimized to death version....................................................
' v1.1.0005 20040620 Use allocated memory for code buffers, no need to re-patch....................
' v1.1.0006 20040628 Better protection in zIdx, improved comments..................................
' v1.1.0007 20040629 Fixed InIDE patching oops.....................................................
' v1.1.0008 20040910 Fixed bug in UserControl_Terminate, zSubclass_Proc procedure hidden...........
'==================================================================================================
'Subclasser declarations

Public Event MouseEnter()
Public Event MouseLeave()
Public Event Status(ByVal sStatus As String)

Private Const WM_EXITSIZEMOVE           As Long = &H232
Private Const WM_LBUTTONDOWN            As Long = &H201
Private Const WM_LBUTTONUP              As Long = &H202
Private Const WM_MOUSELEAVE             As Long = &H2A3
Private Const WM_MOUSEMOVE              As Long = &H200
Private Const WM_MOVING                 As Long = &H216
Private Const WM_RBUTTONDBLCLK          As Long = &H206
Private Const WM_RBUTTONDOWN            As Long = &H204
Private Const WM_SIZING                 As Long = &H214
Private Const WM_SYSCOLORCHANGE         As Long = &H15
Private Const WM_THEMECHANGED           As Long = &H31A
'Private Const WM_USER                   As Long = &H400

Private Enum TRACKMOUSEEVENT_FLAGS
  TME_HOVER = &H1&
  TME_LEAVE = &H2&
  TME_QUERY = &H40000000
  TME_CANCEL = &H80000000
End Enum

Private Type TRACKMOUSEEVENT_STRUCT
  cbSize                             As Long
  dwFlags                            As TRACKMOUSEEVENT_FLAGS
  hwndTrack                          As Long
  dwHoverTime                        As Long
End Type

Private bTrack                       As Boolean
Private bTrackUser32                 As Boolean
Private bInCtrl                      As Boolean
Private bSubClass                    As Boolean

Private Declare Function FreeLibrary Lib "kernel32" (ByVal hLibModule As Long) As Long
Private Declare Function LoadLibraryA Lib "kernel32" (ByVal lpLibFileName As String) As Long
Private Declare Function TrackMouseEvent Lib "user32" (lpEventTrack As TRACKMOUSEEVENT_STRUCT) As Long
Private Declare Function TrackMouseEventComCtl Lib "Comctl32" Alias "_TrackMouseEvent" (lpEventTrack As TRACKMOUSEEVENT_STRUCT) As Long



Private Enum eMsgWhen
    MSG_AFTER = 1                                                                   'Message calls back after the original (previous) WndProc
    MSG_BEFORE = 2                                                                  'Message calls back before the original (previous) WndProc
    MSG_BEFORE_AND_AFTER = MSG_AFTER Or MSG_BEFORE                                  'Message calls back before and after the original (previous) WndProc
End Enum

Private Const ALL_MESSAGES           As Long = -1                                   'All messages added or deleted
Private Const GMEM_FIXED             As Long = 0                                    'Fixed memory GlobalAlloc flag
Private Const GWL_WNDPROC            As Long = -4                                   'Get/SetWindow offset to the WndProc procedure address
Private Const PATCH_04               As Long = 88                                   'Table B (before) address patch offset
Private Const PATCH_05               As Long = 93                                   'Table B (before) entry count patch offset
Private Const PATCH_08               As Long = 132                                  'Table A (after) address patch offset
Private Const PATCH_09               As Long = 137                                  'Table A (after) entry count patch offset

Private Type tSubData                                                               'Subclass data type
    hWnd                               As Long                                      'Handle of the window being subclassed
    nAddrSub                           As Long                                      'The address of our new WndProc (allocated memory).
    nAddrOrig                          As Long                                      'The address of the pre-existing WndProc
    nMsgCntA                           As Long                                      'Msg after table entry count
    nMsgCntB                           As Long                                      'Msg before table entry count
    aMsgTblA()                         As Long                                      'Msg after table array
    aMsgTblB()                         As Long                                      'Msg Before table array
End Type

Private sc_aSubData()                As tSubData                                    'Subclass data array

Private Declare Sub RtlMoveMemory Lib "kernel32" (Destination As Any, Source As Any, ByVal Length As Long)
Private Declare Function GetModuleHandleA Lib "kernel32" (ByVal lpModuleName As String) As Long
Private Declare Function GetProcAddress Lib "kernel32" (ByVal hModule As Long, ByVal lpProcName As String) As Long
Private Declare Function GlobalAlloc Lib "kernel32" (ByVal wFlags As Long, ByVal dwBytes As Long) As Long
Private Declare Function GlobalFree Lib "kernel32" (ByVal hMem As Long) As Long
Private Declare Function SetWindowLongA Lib "user32" (ByVal hWnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function VirtualProtect Lib "kernel32" (lpAddress As Any, ByVal dwSize As Long, ByVal flNewProtect As Long, lpflOldProtect As Long) As Long

'======================================================================================================
'Subclass handler - MUST be the first Public routine in this file. That includes public properties also
Public Sub zSubclass_Proc(ByVal bBefore As Boolean, ByRef bHandled As Boolean, ByRef lReturn As Long, ByRef lng_hWnd As Long, ByRef uMsg As Long, ByRef wParam As Long, ByRef lParam As Long)
    'Parameters:
        'bBefore  - Indicates whether the the message is being processed before or after the default handler - only really needed if a message is set to callback both before & after.
        'bHandled - Set this variable to True in a 'before' callback to prevent the message being subsequently processed by the default handler... and if set, an 'after' callback
        'lReturn  - Set this variable as per your intentions and requirements, see the MSDN documentation for each individual message value.
        'hWnd     - The window handle
        'uMsg     - The message number
        'wParam   - Message related data
        'lParam   - Message related data
    'Notes:
        'If you really know what you're doing, it's possible to change the values of the
        'hWnd, uMsg, wParam and lParam parameters in a 'before' callback so that different
        'values get passed to the default handler.. and optionaly, the 'after' callback
    Static bMoving As Boolean
   
    Select Case uMsg
        Case BFFM_INITIALIZED
            '   BrowseForFolder Module has Initialized, so set the Starting Path
            Call SendMessage(lng_hWnd, BFFM_SETSELECTIONA, True, ByVal m_Path)

        Case WM_MOUSEMOVE
            If (lng_hWnd = pbPick.hWnd) Then
                If m_State <> pbHover Then
                    m_State = pbHover
                    Call Refresh(0)
                End If
                Call TrackMouseLeave(lng_hWnd)
                RaiseEvent MouseEnter
            ElseIf (lng_hWnd = pbDrop.hWnd) Then
                If m_State <> pbHover Then
                    m_State = pbHover
                    Call Refresh(1)
                End If
                Call TrackMouseLeave(lng_hWnd)
                RaiseEvent MouseEnter
            Else
                If m_State <> pbNormal Then
                    m_State = pbNormal
                    Call Refresh(0)
                    Call Refresh(1)
                End If
                bInCtrl = False
            End If

        Case WM_MOUSELEAVE
            If (lng_hWnd = pbPick.hWnd) Then
                m_State = pbNormal
                Call Refresh(0)
                bInCtrl = False
                RaiseEvent MouseLeave
            ElseIf (lng_hWnd = pbDrop.hWnd) Then
                m_State = pbNormal
                Call Refresh(1)
                bInCtrl = False
                RaiseEvent MouseLeave
            Else
                If m_State <> pbNormal Then
                    m_State = pbNormal
                    Call Refresh(0)
                    Call Refresh(1)
                End If
                bInCtrl = False
                RaiseEvent MouseLeave
            End If

        Case WM_SYSCOLORCHANGE
            m_State = pbNormal
            Call Refresh(0)
            Call Refresh(1)
            
        Case WM_THEMECHANGED
            m_State = pbNormal
            Call Refresh(0)
            Call Refresh(1)
            
    End Select
    
End Sub

'   Determine if the passed function is supported
Private Function IsFunctionExported(ByVal sFunction As String, ByVal sModule As String) As Boolean
    Dim hmod        As Long
    Dim bLibLoaded  As Boolean

    hmod = GetModuleHandleA(sModule)

    If hmod = 0 Then
        hmod = LoadLibraryA(sModule)
        If hmod Then
            bLibLoaded = True
        End If
    End If

    If hmod Then
        If GetProcAddress(hmod, sFunction) Then
            IsFunctionExported = True
        End If
    End If
    If bLibLoaded Then
        Call FreeLibrary(hmod)
    End If
End Function

'======================================================================================================
'Subclass code - The programmer may call any of the following Subclass_??? routines

    'Add a message to the table of those that will invoke a callback. You should Subclass_Subclass first and then add the messages
Private Sub Subclass_AddMsg(ByVal lng_hWnd As Long, ByVal uMsg As Long, Optional ByVal When As eMsgWhen = MSG_AFTER)
    'Parameters:
        'lng_hWnd  - The handle of the window for which the uMsg is to be added to the callback table
        'uMsg      - The message number that will invoke a callback. NB Can also be ALL_MESSAGES, ie all messages will callback
        'When      - Whether the msg is to callback before, after or both with respect to the the default (previous) handler
    With sc_aSubData(zIdx(lng_hWnd))
        If When And eMsgWhen.MSG_BEFORE Then
            Call zAddMsg(uMsg, .aMsgTblB, .nMsgCntB, eMsgWhen.MSG_BEFORE, .nAddrSub)
        End If
        If When And eMsgWhen.MSG_AFTER Then
            Call zAddMsg(uMsg, .aMsgTblA, .nMsgCntA, eMsgWhen.MSG_AFTER, .nAddrSub)
        End If
    End With
End Sub

'Delete a message from the table of those that will invoke a callback.
Private Sub Subclass_DelMsg(ByVal lng_hWnd As Long, ByVal uMsg As Long, Optional ByVal When As eMsgWhen = MSG_AFTER)
    'Parameters:
    'lng_hWnd  - The handle of the window for which the uMsg is to be removed from the callback table
    'uMsg      - The message number that will be removed from the callback table. NB Can also be ALL_MESSAGES, ie all messages will callback
    'When      - Whether the msg is to be removed from the before, after or both callback tables
    With sc_aSubData(zIdx(lng_hWnd))
        If When And eMsgWhen.MSG_BEFORE Then
            Call zDelMsg(uMsg, .aMsgTblB, .nMsgCntB, eMsgWhen.MSG_BEFORE, .nAddrSub)
        End If
        If When And eMsgWhen.MSG_AFTER Then
            Call zDelMsg(uMsg, .aMsgTblA, .nMsgCntA, eMsgWhen.MSG_AFTER, .nAddrSub)
        End If
    End With
End Sub

'Return whether we're running in the IDE.
Private Function Subclass_InIDE() As Boolean
    Debug.Assert zSetTrue(Subclass_InIDE)
End Function

'Start subclassing the passed window handle
Private Function Subclass_Start(ByVal lng_hWnd As Long) As Long
    'Parameters:
    'lng_hWnd  - The handle of the window to be subclassed
    'Returns;
    'The sc_aSubData() index
    Const PAGE_EXECUTE_READWRITE As Long = &H40&                                    'Allow memory to execute without violating XP SP2 Data Execution Prevention
    Const CODE_LEN              As Long = 204                                       'Length of the machine code in bytes
    Const FUNC_CWP              As String = "CallWindowProcA"                       'We use CallWindowProc to call the original WndProc
    Const FUNC_EBM              As String = "EbMode"                                'VBA's EbMode function allows the machine code thunk to know if the IDE has stopped or is on a breakpoint
    Const FUNC_SWL              As String = "SetWindowLongA"                        'SetWindowLongA allows the cSubclasser machine code thunk to unsubclass the subclasser itself if it detects via the EbMode function that the IDE has stopped
    Const MOD_USER              As String = "user32"                                'Location of the SetWindowLongA & CallWindowProc functions
    Const MOD_VBA5              As String = "vba5"                                  'Location of the EbMode function if running VB5
    Const MOD_VBA6              As String = "vba6"                                  'Location of the EbMode function if running VB6
    Const PATCH_01              As Long = 18                                        'Code buffer offset to the location of the relative address to EbMode
    Const PATCH_02              As Long = 68                                        'Address of the previous WndProc
    Const PATCH_03              As Long = 78                                        'Relative address of SetWindowsLong
    Const PATCH_06              As Long = 116                                       'Address of the previous WndProc
    Const PATCH_07              As Long = 121                                       'Relative address of CallWindowProc
    Const PATCH_0A              As Long = 186                                       'Address of the owner object
    Static aBuf(1 To CODE_LEN)  As Byte                                             'Static code buffer byte array
    Static pCWP                 As Long                                             'Address of the CallWindowsProc
    Static pEbMode              As Long                                             'Address of the EbMode IDE break/stop/running function
    Static pSWL                 As Long                                             'Address of the SetWindowsLong function
    Dim i                       As Long                                             'Loop index
    Dim j                       As Long                                             'Loop index
    Dim nSubIdx                 As Long                                             'Subclass data index
    Dim sHex                    As String                                           'Hex code string
    
    'If it's the first time through here..
    If aBuf(1) = 0 Then
        
        'The hex pair machine code representation.
        sHex = "5589E583C4F85731C08945FC8945F8EB0EE80000000083F802742185C07424E830000000837DF800750AE838000000E84D00" & _
            "00005F8B45FCC9C21000E826000000EBF168000000006AFCFF7508E800000000EBE031D24ABF00000000B900000000E82D00" & _
            "0000C3FF7514FF7510FF750CFF75086800000000E8000000008945FCC331D2BF00000000B900000000E801000000C3E33209" & _
            "C978078B450CF2AF75278D4514508D4510508D450C508D4508508D45FC508D45F85052B800000000508B00FF90A4070000C3"
        
        'Convert the string from hex pairs to bytes and store in the static machine code buffer
        i = 1
        Do While j < CODE_LEN
            j = j + 1
            aBuf(j) = Val("&H" & Mid$(sHex, i, 2))                                  'Convert a pair of hex characters to an eight-bit value and store in the static code buffer array
            i = i + 2
        Loop                                                                        'Next pair of hex characters
        
        'Get API function addresses
        If Subclass_InIDE Then                                                      'If we're running in the VB IDE
            aBuf(16) = &H90                                                         'Patch the code buffer to enable the IDE state code
            aBuf(17) = &H90                                                         'Patch the code buffer to enable the IDE state code
            pEbMode = zAddrFunc(MOD_VBA6, FUNC_EBM)                                 'Get the address of EbMode in vba6.dll
            If pEbMode = 0 Then                                                     'Found?
                pEbMode = zAddrFunc(MOD_VBA5, FUNC_EBM)                             'VB5 perhaps
            End If
        End If

        pCWP = zAddrFunc(MOD_USER, FUNC_CWP)                                        'Get the address of the CallWindowsProc function
        pSWL = zAddrFunc(MOD_USER, FUNC_SWL)                                        'Get the address of the SetWindowLongA function
        ReDim sc_aSubData(0 To 0) As tSubData                                       'Create the first sc_aSubData element
    Else
        nSubIdx = zIdx(lng_hWnd, True)
        If nSubIdx = -1 Then                                                        'If an sc_aSubData element isn't being re-cycled
            nSubIdx = UBound(sc_aSubData()) + 1                                     'Calculate the next element
            ReDim Preserve sc_aSubData(0 To nSubIdx) As tSubData                    'Create a new sc_aSubData element
        End If
        Subclass_Start = nSubIdx
    End If

    With sc_aSubData(nSubIdx)
        .hWnd = lng_hWnd                                                            'Store the hWnd
        .nAddrSub = GlobalAlloc(GMEM_FIXED, CODE_LEN)                               'Allocate memory for the machine code WndProc
'        Call VirtualProtect(ByVal .nAddrSub, CODE_LEN, PAGE_EXECUTE_READWRITE, i)   'Mark memory as executable
        .nAddrOrig = SetWindowLongA(.hWnd, GWL_WNDPROC, .nAddrSub)                  'Set our WndProc in place
        Call RtlMoveMemory(ByVal .nAddrSub, aBuf(1), CODE_LEN)                      'Copy the machine code from the static byte array to the code array in sc_aSubData
        Call zPatchRel(.nAddrSub, PATCH_01, pEbMode)                                'Patch the relative address to the VBA EbMode api function, whether we need to not.. hardly worth testing
        Call zPatchVal(.nAddrSub, PATCH_02, .nAddrOrig)                             'Original WndProc address for CallWindowProc, call the original WndProc
        Call zPatchRel(.nAddrSub, PATCH_03, pSWL)                                   'Patch the relative address of the SetWindowLongA api function
        Call zPatchVal(.nAddrSub, PATCH_06, .nAddrOrig)                             'Original WndProc address for SetWindowLongA, unsubclass on IDE stop
        Call zPatchRel(.nAddrSub, PATCH_07, pCWP)                                   'Patch the relative address of the CallWindowProc api function
        Call zPatchVal(.nAddrSub, PATCH_0A, ObjPtr(Me))                             'Patch the address of this object instance into the static machine code buffer
    End With
End Function

'Stop all subclassing
Private Sub Subclass_StopAll()
    Dim i As Long
    
    i = UBound(sc_aSubData())                                                       'Get the upper bound of the subclass data array
    Do While i >= 0                                                                 'Iterate through each element
        With sc_aSubData(i)
            If .hWnd <> 0 Then                                                      'If not previously Subclass_Stop'd
                Call Subclass_Stop(.hWnd)                                           'Subclass_Stop
            End If
        End With
        i = i - 1                                                                   'Next element
    Loop
End Sub

'Stop subclassing the passed window handle
Private Sub Subclass_Stop(ByVal lng_hWnd As Long)
    'Parameters:
    'lng_hWnd  - The handle of the window to stop being subclassed
    With sc_aSubData(zIdx(lng_hWnd))
        Call SetWindowLongA(.hWnd, GWL_WNDPROC, .nAddrOrig)                         'Restore the original WndProc
        Call zPatchVal(.nAddrSub, PATCH_05, 0)                                      'Patch the Table B entry count to ensure no further 'before' callbacks
        Call zPatchVal(.nAddrSub, PATCH_09, 0)                                      'Patch the Table A entry count to ensure no further 'after' callbacks
        Call GlobalFree(.nAddrSub)                                                  'Release the machine code memory
        .hWnd = 0                                                                   'Mark the sc_aSubData element as available for re-use
        .nMsgCntB = 0                                                               'Clear the before table
        .nMsgCntA = 0                                                               'Clear the after table
        Erase .aMsgTblB                                                             'Erase the before table
        Erase .aMsgTblA                                                             'Erase the after table
    End With
End Sub

'Track the mouse leaving the indicated window
Private Sub TrackMouseLeave(ByVal lng_hWnd As Long)
  Dim tme As TRACKMOUSEEVENT_STRUCT
  
    If bTrack Then
        With tme
            .cbSize = Len(tme)
            .dwFlags = TME_LEAVE
            .hwndTrack = lng_hWnd
        End With
    
        If bTrackUser32 Then
            Call TrackMouseEvent(tme)
        Else
            Call TrackMouseEventComCtl(tme)
        End If
    End If
End Sub

'======================================================================================================
'These z??? routines are exclusively called by the Subclass_??? routines.

'Worker sub for sc_AddMsg
Private Sub zAddMsg(ByVal uMsg As Long, ByRef aMsgTbl() As Long, ByRef nMsgCnt As Long, ByVal When As eMsgWhen, ByVal nAddr As Long)
    Dim nEntry  As Long                                                             'Message table entry index
    Dim nOff1   As Long                                                             'Machine code buffer offset 1
    Dim nOff2   As Long                                                             'Machine code buffer offset 2
    
    If uMsg = ALL_MESSAGES Then                                                     'If all messages
        nMsgCnt = ALL_MESSAGES                                                      'Indicates that all messages will callback
    Else                                                                            'Else a specific message number
        Do While nEntry < nMsgCnt                                                   'For each existing entry. NB will skip if nMsgCnt = 0
            nEntry = nEntry + 1
            
            If aMsgTbl(nEntry) = 0 Then                                             'This msg table slot is a deleted entry
                aMsgTbl(nEntry) = uMsg                                              'Re-use this entry
                Exit Sub                                                            'Bail
            ElseIf aMsgTbl(nEntry) = uMsg Then                                      'The msg is already in the table!
                Exit Sub                                                            'Bail
            End If
        Loop                                                                        'Next entry
        nMsgCnt = nMsgCnt + 1                                                       'New slot required, bump the table entry count
        ReDim Preserve aMsgTbl(1 To nMsgCnt) As Long                                'Bump the size of the table.
        aMsgTbl(nMsgCnt) = uMsg                                                     'Store the message number in the table
    End If

    If When = eMsgWhen.MSG_BEFORE Then                                              'If before
        nOff1 = PATCH_04                                                            'Offset to the Before table
        nOff2 = PATCH_05                                                            'Offset to the Before table entry count
    Else                                                                            'Else after
        nOff1 = PATCH_08                                                            'Offset to the After table
        nOff2 = PATCH_09                                                            'Offset to the After table entry count
    End If

    If uMsg <> ALL_MESSAGES Then
        Call zPatchVal(nAddr, nOff1, VarPtr(aMsgTbl(1)))                            'Address of the msg table, has to be re-patched because Redim Preserve will move it in memory.
    End If
    Call zPatchVal(nAddr, nOff2, nMsgCnt)                                           'Patch the appropriate table entry count
End Sub

'Return the memory address of the passed function in the passed dll
Private Function zAddrFunc(ByVal sDLL As String, ByVal sProc As String) As Long
    zAddrFunc = GetProcAddress(GetModuleHandleA(sDLL), sProc)
    Debug.Assert zAddrFunc                                                          'You may wish to comment out this line if you're using vb5 else the EbMode GetProcAddress will stop here everytime because we look for vba6.dll first
End Function

'Worker sub for sc_DelMsg
Private Sub zDelMsg(ByVal uMsg As Long, ByRef aMsgTbl() As Long, ByRef nMsgCnt As Long, ByVal When As eMsgWhen, ByVal nAddr As Long)
    Dim nEntry As Long
    
    If uMsg = ALL_MESSAGES Then                                                     'If deleting all messages
        nMsgCnt = 0                                                                 'Message count is now zero
        If When = eMsgWhen.MSG_BEFORE Then                                          'If before
            nEntry = PATCH_05                                                       'Patch the before table message count location
        Else                                                                        'Else after
            nEntry = PATCH_09                                                       'Patch the after table message count location
        End If
        Call zPatchVal(nAddr, nEntry, 0)                                            'Patch the table message count to zero
    Else                                                                            'Else deleteting a specific message
        Do While nEntry < nMsgCnt                                                   'For each table entry
            nEntry = nEntry + 1
            If aMsgTbl(nEntry) = uMsg Then                                          'If this entry is the message we wish to delete
                aMsgTbl(nEntry) = 0                                                 'Mark the table slot as available
                Exit Do                                                             'Bail
            End If
        Loop                                                                        'Next entry
    End If
End Sub

'Get the sc_aSubData() array index of the passed hWnd
Private Function zIdx(ByVal lng_hWnd As Long, Optional ByVal bAdd As Boolean = False) As Long
    'Get the upper bound of sc_aSubData() - If you get an error here, you're probably sc_AddMsg-ing before Subclass_Start
    zIdx = UBound(sc_aSubData)
    Do While zIdx >= 0                                                              'Iterate through the existing sc_aSubData() elements
        With sc_aSubData(zIdx)
            If .hWnd = lng_hWnd Then                                                'If the hWnd of this element is the one we're looking for
                If Not bAdd Then                                                    'If we're searching not adding
                    Exit Function                                                   'Found
                End If
            ElseIf .hWnd = 0 Then                                                   'If this an element marked for reuse.
                If bAdd Then                                                        'If we're adding
                    Exit Function                                                   'Re-use it
                End If
            End If
        End With
    zIdx = zIdx - 1                                                                 'Decrement the index
    Loop
    
    If Not bAdd Then
        Debug.Assert False                                                          'hWnd not found, programmer error
    End If

'If we exit here, we're returning -1, no freed elements were found
End Function

'Patch the machine code buffer at the indicated offset with the relative address to the target address.
Private Sub zPatchRel(ByVal nAddr As Long, ByVal nOffset As Long, ByVal nTargetAddr As Long)
    Call RtlMoveMemory(ByVal nAddr + nOffset, nTargetAddr - nAddr - nOffset - 4, 4)
End Sub

'Patch the machine code buffer at the indicated offset with the passed value
Private Sub zPatchVal(ByVal nAddr As Long, ByVal nOffset As Long, ByVal nValue As Long)
    Call RtlMoveMemory(ByVal nAddr + nOffset, nValue, 4)
End Sub

'Worker function for Subclass_InIDE
Private Function zSetTrue(ByRef bValue As Boolean) As Boolean
    zSetTrue = True
    bValue = True
End Function
'======================================================================================================
'   End SubClass Sections
'======================================================================================================

Public Property Get Appearance() As pbAppearanceConstants
    Appearance = m_Appearance
End Property

Public Property Let Appearance(lNewValue As pbAppearanceConstants)
    '   Store the Value
    m_Appearance = lNewValue
    '   Set the TextBox Style
    txtResult.Appearance = lNewValue
    '   Set the new visual styles to the passed type (3D or Flat)
    Call ButtonAppearance(cmdPick, lNewValue)
    Call ButtonAppearance(cmdDrop, lNewValue)
    '   We need to set the Visible state to False, since the
    '   ButtonAppearance function sets it to True as part of
    '   the window refresh mechanism
    cmdDrop.Visible = False
    '   Now call the resize, as the button position and sizes
    '   are changed when the border style changes...
    Call UserControl_Resize
    PropertyChanged "Appearance"
End Property

Public Property Get BackColor() As OLE_COLOR
    BackColor = m_BackColor
End Property

Public Property Let BackColor(ByVal lNewColor As OLE_COLOR)
    m_BackColor = lNewColor
    m_PrevBackColor = lNewColor
    '   Set the BackColor
    UserControl.txtResult.BackColor = lNewColor
    PropertyChanged "BackColor"
End Property

Private Function ButtonAppearance(cmdButton As CommandButton, lButtonStyle As pbAppearanceConstants)
    If lButtonStyle = [3D] Then
        '   Here is a small function to change button to 3D (Note the Missing "BS_FLAT" flag)
        SetWindowLong cmdButton.hWnd, GWL_STYLE, WS_CHILD
        '   Make the button visible (its automaticly hidden when the SetWindowLong call is executed because we reset the button's Attributes)
        cmdButton.Visible = True
    Else
        '   Here is a small function to change button to flat:-
        SetWindowLong cmdButton.hWnd, GWL_STYLE, WS_CHILD Or BS_FLAT
        '   Make the button visible (its automaticly hidden when the SetWindowLong call is executed because we reset the button's Attributes)
        cmdButton.Visible = True
    End If
End Function

Private Sub cmbMultiSel_Click()
    With UserControl
        '   Display the selected results from the ComboBox List
        .txtResult.Text = .cmbMultiSel.List(.cmbMultiSel.ListIndex)
    End With
End Sub

Private Sub cmbMultiSel_KeyDown(KeyCode As Integer, Shift As Integer)
    With UserControl
        Select Case KeyCode
            Case vbKeyUp
                '   See if we are at the top, if so then change
                '   the focus back to the textbox....as if it were
                '   part of the control
                If .cmbMultiSel.ListIndex = 0 Then
                    .txtResult.SetFocus
                End If
        End Select
    End With
End Sub

Private Sub cmdDrop_Click()
    With UserControl
        If Not ComboBoxListVisible(.cmbMultiSel) Then
            '   It is closed, so open it via code....
            Call OpenComboBox(.cmbMultiSel, True)
        Else
            '   Set the focus to our TextBox
            .txtResult.SetFocus
        End If
        '   Drop List Clicked...
        RaiseEvent DropClick
    End With
End Sub

Private Sub cmdDrop_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    '   Get the Cursor Position
    m_Pnt = GetCursorPosition
    RaiseEvent MouseDown(Button, Shift, CSng(m_Pnt.X), CSng(m_Pnt.Y))
End Sub

Private Sub cmdDrop_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    '   Get the Cursor Position
    m_Pnt = GetCursorPosition
    If (m_PrevLoc.X <> m_Pnt.X) And (m_PrevLoc.Y <> m_Pnt.Y) Then
        RaiseEvent MouseMove(Button, Shift, CSng(m_Pnt.X), CSng(m_Pnt.Y))
        m_PrevLoc = m_Pnt
    End If
End Sub

Private Sub cmdDrop_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    With UserControl
        '   Make sure the focus is on the TextBox and not the drop button
        .txtResult.SetFocus
    End With
    '   Get the Cursor Position
    m_Pnt = GetCursorPosition
    RaiseEvent MouseUp(Button, Shift, CSng(m_Pnt.X), CSng(m_Pnt.Y))
End Sub

Private Sub cmdPick_Click()
    Dim psColor         As SelectedColor
    Dim psFile          As SelectedFile
    Dim psFont          As SelectedFont
    Dim psPrint         As Long
    Dim SelFont         As StdFont
    Dim i               As Long
    Dim sExt            As String
    Dim sFolder         As String
    Dim AutoTheme       As String
    
    On Error Resume Next
    With UserControl
        AutoTheme = GetThemeInfo
        '   Make sure the Combobox is hidden
        .cmdDrop.Visible = False
        .pbDrop.Visible = False
        '   Which dialog is active?
        Select Case m_DialogType
            Case [ucColor]
                '   Pick a color from the Color Dialog
                psColor = ShowColor()
                If psColor.bCanceled = False Then
                    '   Get the color from the dialog
                    m_Color = (CLng(psColor.oSelectedColor))
                    PropertyChanged "Color"
                    If m_UseDialogText Then
                        '   Convert the color to Hex
                        .txtResult.Text = pHexColorStr(m_Color)
                        sPrevColor = pHexColorStr(m_Color)
                    End If
                    If m_UseDialogColor Then
                        '   Convert the color to Hex
                        .txtResult.BackColor = pHexColorStr(m_Color)
                        If m_UseAutoForeColor Then
                            '   This is a "trick" to make the ForeColor Automatically
                            '   visable even if the background is black (&H0)
                            .txtResult.ForeColor = (pHexColorStr(m_Color) Xor &HFFFFFF)
                        End If
                    End If
                    '   Set the focus on the color
                    .txtResult.SetFocus
                End If
                RaiseEvent ColorChanged(m_Color)
            Case [ucFolder]
                sFolder = ShowFolderBrowse()
                If sFolder <> "" Then
                    m_Path = QualifyPath(sFolder)
                    PropertyChanged "Path"
                    If m_UseDialogText Then
                        '   Trim the display name
                        .txtResult.Text = TrimPathByLen(m_Path, .txtResult.Width - .cmdPick.Width - 40)
                    End If
                End If
            Case [ucFont]
                If m_Font Is Nothing Then
                    '   Create a Font if Missing
                    Set m_Font = New StdFont
                    With m_Font
                        .Bold = False
                        .Charset = 0
                        .Italic = False
                        .Name = "Arial"
                        .Size = 8
                        .Strikethrough = False
                        .Underline = False
                        .Weight = 400
                        m_FontColor = &H0         'Black
                    End With
                End If
                psFont = ShowFont(m_Font, m_FontColor)
                If (psFont.bCanceled = False) Then
                    '   Set the Font type
                    Set m_Font = New StdFont
                    With m_Font
                        .Bold = psFont.bBold
                        .Italic = psFont.bItalic
                        .Name = psFont.sSelectedFont
                        .Size = psFont.nSize
                        .Strikethrough = psFont.bStrikeOut
                        .Underline = psFont.bUnderline
                    End With
                    If m_UseDialogText Then
                        '   Pass the name to the textbox
                        .txtResult.Text = psFont.sSelectedFont
                    End If
                    '   Focuc on the parent object
                    .txtResult.SetFocus
                    '   Pass the focus back the Host
                    Call SetFocus(.Parent.hWnd)
                End If
                RaiseEvent FontChanged(.txtResult.Text)
            Case [ucOpen], [ucSave]
                '   Same basic routine, with different calls to start
                If m_DialogType = [ucOpen] Then
                    psFile = ShowOpen(m_Filters)
                Else
                    psFile = ShowSave(m_Filters)
                End If
                If (psFile.bCanceled = False) And (psFile.nFilesSelected > 0) Then
                    If m_DialogType = [ucOpen] Then
                        '   Set the Command Button visable
                        If (m_Theme = pbClassic) Or (AutoTheme = "None") Then
                            .cmdDrop.Visible = m_MultiSelect
                        Else
                            .pbDrop.Visible = m_MultiSelect
                        End If
                        '   Concatinate the filename and path
                        If m_MultiSelect Then
                            '   Store the qaulified path
                            m_Path = QualifyPath(psFile.sLastDirectory)
                            PropertyChanged "Path"
                            '   Count the Files
                            FileCount = UBound(psFile.sFiles) - LBound(psFile.sFiles) + 1
                            If m_FileCount = 1 Then
                                '   Erase the array...this is over kill
                                '   but better to be safe than sorry ;-)
                                Erase m_Filename
                                '   Redim to a vector...
                                ReDim m_Filename(1 To 1)
                                '   Clear the ComboBox
                                .cmbMultiSel.Clear
                                '   Store the Filename
                                m_Filename(1) = psFile.sFiles(1)
                                PropertyChanged "Filename"
                                '   Add the Trimmed Filename and Path
                                .cmbMultiSel.AddItem TrimPathByLen(m_Path & psFile.sFiles(1), .txtResult.Width - 40)
                            Else
                                '   Erase the array...this is over kill
                                '   but better to be safe than sorry ;-)
                                Erase m_Filename
                                '   Redim to a vector...
                                ReDim m_Filename(1 To m_FileCount)
                                '   Clear the ComboBox
                                .cmbMultiSel.Clear
                                '   Store the Filenames
                                For i = 1 To m_FileCount
                                    .cmbMultiSel.AddItem TrimPathByLen(QualifyPath(m_Path) & psFile.sFiles(i), .txtResult.Width - 40)
                                    m_Filename(i) = m_Path & psFile.sFiles(i)
                                Next i
                            End If
                        Else
                            ReDim m_Filename(1 To 1)
                            '   Store the qaulified path
                            m_Path = QualifyPath(ExtractPath(psFile.sFiles(1)))
                            PropertyChanged "Path"
                            m_Filename(1) = psFile.sFiles(1)
                            m_FileCount = 1
                        End If
                        PropertyChanged "Filename"
                        If m_UseDialogText Then
                            '   Trim the display name
                            If m_MultiSelect Then
                                '   Adjust the name len to account for our new button
                                .txtResult.Text = TrimPathByLen(m_Filename(1), .txtResult.Width - .cmdPick.Width - .cmdDrop.Width - 40)
                            Else
                                .txtResult.Text = TrimPathByLen(m_Filename(1), .txtResult.Width - .cmdPick.Width - 40)
                            End If
                        End If
                        '   Focus on the final name
                        .txtResult.SetFocus
                    Else
                        '   Concatinate the filename and path
                        ReDim m_Filename(1 To 1)
                        If Not (Right$(psFile.sFiles(1), 4) Like ".*") Then
Retry:
                            '   This section handles files which are returned without extnsions
                            sExt = InputBox("The File Extension is Missing!" & vbCrLf & "Please Enter a Valid Extension Below...", "ucPickBox", , (.Parent.ScaleWidth \ 2) + .Parent.Left - 2700, (.Parent.ScaleHeight \ 2) + .Parent.Top - 800)
                            If Len(sExt) = 0 Then
                                If MsgBox("     The File Extension is Invalid!" & vbCrLf & vbCrLf & "File will be saved with " & Chr$(34) & ".txt" & Chr$(34) & " extension.", vbExclamation + vbOKCancel, "ucPickBox") = vbOK Then
                                    '   Just use the default text file type
                                    sExt = ".txt"
                                Else
                                    '   Give them another try to get this right...
                                    GoTo Retry
                                End If
                            End If
                            '   Fix missing "." in the extension
                            If (InStr(1, sExt, ".", vbTextCompare) = 0) Or (Len(sExt) = 3) Then
                                psFile.sFiles(1) = psFile.sFiles(1) & "." & sExt
                            Else
                                psFile.sFiles(1) = psFile.sFiles(1) & sExt
                            End If
                        End If
                        '   Store the Filename
                        m_Filename(1) = psFile.sFiles(1)
                        PropertyChanged "Filename"
                        '   Store the qualified path
                        m_Path = QualifyPath(ExtractPath(m_Filename(1)))
                        PropertyChanged "Path"
                        If m_UseDialogText Then
                            '   Trim the display name
                            .txtResult.Text = TrimPathByLen(psFile.sFiles(1), .txtResult.Width - .cmdPick.Width - 40)
                        End If
                        FileCount = 1
                    End If
                    '   Focus on the final name
                    .txtResult.SetFocus
                End If
                RaiseEvent PathChanged
            Case [ucPrint]
                psPrint = ShowPrinter()
                If psPrint <> 0 Then
                    '   Success, so indicate so...
                    m_Printer = psPrint
                    PropertyChanged "Printer"
                    If m_UseDialogText Then
                        '   Display the message....
                        .txtResult.Text = m_PrintStatusMsg(1)
                    End If
                    .txtResult.SetFocus
                    Call SetFocus(.Parent.hWnd)
                    '   Store the Print Status
                    m_PrintStatus = True
                    RaiseEvent PrintStatus(m_PrintStatusMsg(1))
                Else
                    '   Printer Failure....
                    If m_UseDialogText Then
                        '   Display the message....
                        .txtResult.Text = m_PrintStatusMsg(0)
                    End If
                    .txtResult.SetFocus
                    Call SetFocus(.Parent.hWnd)
                    '   Store the Print Status
                    m_PrintStatus = False
                    RaiseEvent PrintStatus(m_PrintStatusMsg(0))
                End If
        End Select
        RaiseEvent Click
        m_Pnt = GetCursorPosition()
        RaiseEvent MouseDown(vbLeftButton, 0, CSng(m_Pnt.X), CSng(m_Pnt.Y))
    End With
End Sub

Private Sub cmdPick_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    '   Get the Cursor Position
    m_Pnt = GetCursorPosition
    RaiseEvent MouseDown(Button, Shift, CSng(m_Pnt.X), CSng(m_Pnt.Y))
End Sub

Private Sub cmdPick_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    '   Get the Cursor Position
    m_Pnt = GetCursorPosition
    If (m_PrevLoc.X <> m_Pnt.X) And (m_PrevLoc.Y <> m_Pnt.Y) Then
        RaiseEvent MouseMove(Button, Shift, CSng(m_Pnt.X), CSng(m_Pnt.Y))
        m_PrevLoc = m_Pnt
    End If
End Sub

Private Sub cmdPick_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    '   Get the Cursor Position
    m_Pnt = GetCursorPosition
    RaiseEvent MouseUp(Button, Shift, CSng(m_Pnt.X), CSng(m_Pnt.Y))
End Sub

Public Property Get ColorFlags() As ColorDialogFlags
    ColorFlags = m_ColorFlags
End Property

Public Property Let ColorFlags(sDialogFlags As ColorDialogFlags)
    m_ColorFlags = sDialogFlags
    PropertyChanged "ColorFlags"
End Property

Public Property Get Color() As OLE_COLOR
    '   Get the stored data...
    Color = pHexColorStr(m_Color)
End Property

Public Property Let Color(ByVal lNewColor As OLE_COLOR)
    With UserControl
        If m_UseDialogText Then
            '   Translate our color to System Pallete and convert
            '   to it to a Hex String Value
            .txtResult.Text = pHexColorStr(TranslateColor(lNewColor))
        End If
    End With
    txtResult_LostFocus
    RaiseEvent ColorChanged(pHexColorStr(lNewColor))
End Property

Private Function ComboBoxListVisible(cbo As ComboBox) As Boolean
    '   Wrapper funtion to allow us to get the drop
    '   state of the ComboBox.....
    ComboBoxListVisible = SendMessage(cbo.hWnd, CB_GETDROPPEDSTATE, 0, ByVal 0&)
End Function

Public Property Get DefaultExt() As String
    DefaultExt = m_DefaultExt
End Property

Public Property Let DefaultExt(ByVal NewValue As String)
    If Left$(NewValue, 1) <> "." Then
        NewValue = "." & NewValue
    End If
    m_DefaultExt = NewValue
    PropertyChanged "DefaultExt"
End Property

Public Property Get DialogMsg(ByVal lType As ucDialogConstant) As String
    '   Get the Dialg Textbox Message for the Type selected
    DialogMsg = m_DialogMsg(lType)
End Property

Public Property Let DialogMsg(ByVal lType As ucDialogConstant, ByVal sNewValue As String)
    '   Set the Dialog Textbox Message for the Type selected
    If lType < 0 Then lType = 0
    If lType > 4 Then lType = 4
    m_DialogMsg(lType) = sNewValue
    '   Store the chnages for later
    Select Case lType
        Case ucColor
            PropertyChanged "DialogMsg0"
        Case ucFolder
            PropertyChanged "DialogMsg1"
        Case ucFont
            PropertyChanged "DialogMsg2"
        Case ucOpen
            PropertyChanged "DialogMsg3"
        Case ucSave
            PropertyChanged "DialogMsg4"
        Case ucPrint
            PropertyChanged "DialogMsg5"
    End Select
    Call Refresh(0)
End Property

Public Property Get DialogType() As ucDialogConstant
    DialogType = m_DialogType
End Property

Public Property Let DialogType(ByVal lType As ucDialogConstant)
    '   Mkae sure the numbers are in range...
    If lType < 0 Then lType = 0
    If lType > 5 Then lType = 5
    '   Use our new dialog style...
    m_DialogType = lType
    With UserControl
        '   Reset the MutliSelect Drop Button and List
        .cmdDrop.Visible = False
        .pbDrop.Visible = False
        .cmbMultiSel.Clear
    End With
    PropertyChanged "DialogType"
    Call Refresh(0)
End Property

Public Property Get Enabled() As Boolean
    Enabled = m_Enabled
End Property

Public Property Let Enabled(bNewValue As Boolean)
    m_Enabled = bNewValue
    '   As it name implys....
    With UserControl
        .Enabled = bNewValue
        .txtResult.Enabled = bNewValue
        .cmdPick.Enabled = bNewValue
        .cmdDrop.Enabled = bNewValue
        If m_Enabled = True Then
            m_State = pbNormal
        Else
            m_State = pbDisabled
        End If
        Call Refresh(0)
        Call Refresh(1)
    End With
    PropertyChanged "Enabled"
End Property

Public Function ExtractFilename(ByVal sFilename) As String
    '   Extract the Path from the full filename...
    Dim lStrCnt As Long
    lStrCnt = InStrRev(sFilename, "\")
    If lStrCnt > 0 Then
        ExtractFilename = Mid(sFilename, lStrCnt + 1)
    End If
End Function

Public Function ExtractPath(ByVal sFilename) As String
    '   Extract the Path from the full filename...
    Dim lStrCnt As Long
    lStrCnt = InStrRev(sFilename, "\")
    If lStrCnt > 0 Then
        ExtractPath = Mid(sFilename, 1, lStrCnt - 1)
    End If
End Function

Public Property Get FileCount() As Long
    FileCount = m_FileCount
End Property

Private Property Let FileCount(lNewCount As Long)
    '   The number of files in the MultSelect Mode of the ShowOpen
    m_FileCount = lNewCount
    PropertyChanged "FileCount"
End Property

Public Function FileExists(ByVal sFilename As String) As Boolean
    Dim lpFindFileData As WIN32_FIND_DATA
    Dim hFindFirst     As Long
    
    '   An API version of FindFile....
    hFindFirst = FindFirstFile(sFilename, lpFindFileData)
    
    If (hFindFirst > 0) And (lpFindFileData.dwFileAttributes <> FILE_ATTRIBUTE_DIR) Then
        FindClose hFindFirst
        FileExists = True
    Else
        FileExists = False
    End If
End Function

Public Property Get FileFlags() As OpenSaveDialogFlags
    FileFlags = m_FileFlags
End Property

Public Property Let FileFlags(sDialogFlags As OpenSaveDialogFlags)
    m_FileFlags = sDialogFlags
    PropertyChanged "FileFlags"
End Property

Public Property Get Filename(Optional index As Long = 1) As String
    '   Get the stored data...(File + Path)
    Filename = m_Filename(index)
End Property

Public Property Get Filters() As String
    Filters = m_Filters
End Property

Public Property Let Filters(sFileFilters As String)
    '   Pass the File Filter string'
    '   i.e. sFileFilters = "Supported Files|*.bmp;*.doc;*.jpg;*.rtf;*.txt;*.tif|Bitmap Files (*.bmp)|*.bmp|Mircosoft Word Files (*.doc)|*.doc|JPEG Files (*.jpg)|*.jpg|Rich Text Format Files (*.rtf)|*.rtf|Text Files (*.txt)|*.txt"
    m_Filters = sFileFilters
    PropertyChanged "Filters"
End Property

Public Property Get FolderFlags() As FolderDialogFlags
    FolderFlags = m_FolderFlags
End Property

Public Property Let FolderFlags(sDialogFlags As FolderDialogFlags)
    m_FolderFlags = sDialogFlags
    PropertyChanged "FolderFlags"
End Property

Public Property Get FontColor() As OLE_COLOR
    FontColor = m_FontColor
End Property

Public Property Get FontFlags() As FontDialogFlags
    FontFlags = m_FontFlags
End Property

Public Property Let FontFlags(sDialogFlags As FontDialogFlags)
    m_FontFlags = sDialogFlags
    PropertyChanged "FontFlags"
End Property

Public Property Get Font() As StdFont
    '   Get the stored data...
    Set Font = m_Font
End Property

Public Property Get ForeColor() As OLE_COLOR
    ForeColor = m_ForeColor
End Property

Public Property Let ForeColor(ByVal lNewColor As OLE_COLOR)
    m_ForeColor = lNewColor
    UserControl.txtResult.ForeColor = lNewColor
    PropertyChanged "ForeColor"
End Property

Private Function GetCursorPosition() As POINTAPI
    Dim Pt As POINTAPI
    Dim lWidth As Long
    Dim lHeight As Long
    
    '   Get Our Position
    Call GetCursorPos(Pt)
    '   Convert coordinates
    Call ScreenToClient(m_hWnd, Pt)
    '   Correct for Offeset of the Borders
    If m_Appearance = [3D] Then
        Pt.X = Pt.X - 2
        Pt.Y = Pt.Y - 2
    Else
        Pt.X = Pt.X - 1
        Pt.Y = Pt.Y - 1
    End If
    '   Get the size of the TextBox
    lWidth = UserControl.ScaleX(txtResult.Width, vbTwips, vbPixels)
    lHeight = UserControl.ScaleY(txtResult.Height, vbTwips, vbPixels)
    '   Sanity Check...are these real numbers (i.e. outside out control)?
    If Pt.X < 0 Then Pt.X = 0
    If Pt.X > lWidth Then Pt.X = lWidth
    If Pt.Y < 0 Then Pt.Y = 0
    If Pt.Y > lHeight Then Pt.Y = lHeight
    '   Now convert from Pixels to Twips
    Pt.X = UserControl.ScaleX(Pt.X, vbPixels, vbTwips)
    Pt.Y = UserControl.ScaleY(Pt.Y, vbPixels, vbTwips)
    '   Pass back the Corrected Coordinates
    GetCursorPosition = Pt
End Function

Private Function GetThemeInfo() As String
    Dim lResult As Long
    Dim sFilename As String
    Dim sColor As String
    Dim lPos As Long
    
    If IsWinXP Then
        '   Allocate Space
        sFilename = Space(255)
        sColor = Space(255)
        '   Read the data
        If GetCurrentThemeName(sFilename, 255, sColor, 255, vbNullString, 0) <> &H0 Then
            GetThemeInfo = "UxTheme_Error"
            Exit Function
        End If
        '   Find our trailing null terminator
        lPos = InStrRev(sColor, vbNullChar)
        '   Parse it....
        sColor = Mid(sColor, 1, lPos)
        '   Now replace the nulls....
        sColor = Replace(sColor, vbNullChar, "")
        If Trim$(sColor) = vbNullString Then sColor = "None"
        GetThemeInfo = sColor
    Else
        sColor = "None"
    End If
End Function

Public Property Get hDC()
    hDC = UserControl.hDC
End Property

Public Property Get hWnd()
    hWnd = UserControl.hWnd
End Property

Private Sub InitCustomColors()
    Dim i As Long
    
    '   Init the Custom Colors Array to White
    For i = LBound(CustomColors) To UBound(CustomColors)
      ' Sets all custom colors to white
      CustomColors(i) = 254
    Next i
    '   Convert array to Unicode Strings
    ColorDialog.lpCustColors = StrConv(CustomColors, vbUnicode)
End Sub

Public Function IsWinXP() As Boolean
    'returns True if running Windows XP
    Dim OSV As OSVERSIONINFO

    OSV.OSVSize = Len(OSV)
    If GetVersionEx(OSV) = 1 Then
        IsWinXP = (OSV.PlatformID = VER_PLATFORM_WIN32_NT) And _
            (OSV.dwVerMajor = 5 And OSV.dwVerMinor = 1) And _
            (OSV.dwBuildNumber >= 2600)
    End If
End Function

Public Function LongToHexColor(ByVal lNewColor As Long) As String
    '   Translate the Color to RGB with Current Palette and pass
    '   back the Hex String Equiv...
    LongToHexColor = pHexColorStr(TranslateColor(lNewColor))
End Function

Public Property Get MultiSelect() As Boolean
    '   Get the MutliSelect Status....for ShowOpen
    MultiSelect = m_MultiSelect
End Property

Public Property Let MultiSelect(bNewValue As Boolean)
    '   Set the MutliSelect State of the Dialog...
    '   NOTE: This is only used for the ShowOpen dialog type.
    m_MultiSelect = bNewValue
    PropertyChanged "MultiSelect"
End Property

Private Sub OpenComboBox(CBox As ComboBox, Optional ShowIt As Boolean = True)
    '   A thin wrapper to open the a ComboBox via API
    SendMessage CBox.hWnd, CB_SHOWDROPDOWN, ShowIt, ByVal 0&
End Sub

Private Sub PaintControl(ByVal AutoTheme As String, ByVal index As Long)
    
    With UserControl
        LockWindowUpdate .hWnd
        ShapeBorder.Visible = True
        Select Case m_Theme
            Case [pbAuto]
                Select Case AutoTheme
                    Case "None"
                        GoTo Classic
                    Case "NormalColor"
                        GoTo NormalColor
                    Case "HomeStead"
                        GoTo HomeStead
                    Case "Metallic"
                        GoTo Metallic
                    Case Else
                        GoTo NormalColor
                End Select
            Case [pbClassic]
Classic:
                BackColor = m_PrevBackColor
                .ShapeBorder.Visible = False
                .pbDrop.Visible = False
                .pbPick.Visible = False
                '   Set the new visual styles to the passed type (3D or Flat)
                Call ButtonAppearance(cmdPick, m_Appearance)
                Call ButtonAppearance(cmdDrop, m_Appearance)
                .txtResult.Appearance = m_Appearance
                .txtResult.BorderStyle = 1
                .cmdPick.Visible = True
                .cmdDrop.Visible = False
            Case [pbBlue]
NormalColor:
                BackColor = &HFFFFFF
                .ShapeBorder.Visible = True
                .pbPick.Visible = True
                .txtResult.Appearance = 0
                .txtResult.BorderStyle = 0
                .cmdPick.Visible = False
                .cmdDrop.Visible = False
                .ShapeBorder.BorderColor = &HB99D7F
                Select Case m_State
                    Case [pbNormal]
                        If index = 0 Then
                            If .pbPick.Picture <> .imBlue(0).Picture Then
                                Set .pbPick.Picture = .imBlue(0).Picture
                            End If
                        Else
                            If .pbDrop.Picture <> .imBlueDrop(0).Picture Then
                                Set pbDrop.Picture = .imBlueDrop(0).Picture
                            End If
                        End If
                    Case [pbHover]
                        If index = 0 Then
                            If .pbPick.Picture <> .imBlue(1).Picture Then
                                Set .pbPick.Picture = .imBlue(1).Picture
                            End If
                        Else
                            If pbDrop.Picture <> .imBlueDrop(1).Picture Then
                                Set pbDrop.Picture = .imBlueDrop(1).Picture
                            End If
                        End If
                    Case [pbDown]
                        If index = 0 Then
                            If .pbPick.Picture <> .imBlue(2).Picture Then
                                Set .pbPick.Picture = .imBlue(2).Picture
                            End If
                        Else
                            If pbDrop.Picture <> .imBlueDrop(2).Picture Then
                                Set pbDrop.Picture = .imBlueDrop(2).Picture
                            End If
                        End If
                    Case [pbDisabled]
                        If index = 0 Then
                            If .pbPick.Picture <> .imBlue(3).Picture Then
                                Set .pbPick.Picture = .imBlue(3).Picture
                            End If
                        Else
                            If pbDrop.Picture <> .imBlueDrop(3).Picture Then
                                Set pbDrop.Picture = .imBlueDrop(3).Picture
                            End If
                        End If
                        ShapeBorder.BorderColor = &HC0C0C0
                End Select
            Case [pbHomeStead]
HomeStead:
                BackColor = &HFFFFFF
                .ShapeBorder.Visible = True
                .pbPick.Visible = True
                .txtResult.Appearance = 0
                .txtResult.BorderStyle = 0
                .cmdPick.Visible = False
                .cmdDrop.Visible = False
                .ShapeBorder.BorderColor = &H69A18B
                Select Case m_State
                    Case [pbNormal]
                        If index = 0 Then
                            If pbPick.Picture <> .imHomeStead(0).Picture Then
                                Set pbPick.Picture = .imHomeStead(0).Picture
                            End If
                        Else
                            If .pbDrop.Picture <> .imHomeSteadDrop(0).Picture Then
                                Set .pbDrop.Picture = .imHomeSteadDrop(0).Picture
                            End If
                        End If
                    Case [pbHover]
                        If index = 0 Then
                            If pbPick.Picture <> .imHomeStead(1).Picture Then
                                Set pbPick.Picture = .imHomeStead(1).Picture
                            End If
                        Else
                            If .pbDrop.Picture <> .imHomeSteadDrop(1).Picture Then
                                Set .pbDrop.Picture = .imHomeSteadDrop(1).Picture
                            End If
                        End If
                    Case [pbDown]
                        If index = 0 Then
                            If pbPick.Picture <> .imHomeStead(2).Picture Then
                                Set pbPick.Picture = .imHomeStead(2).Picture
                            End If
                        Else
                            If .pbDrop.Picture <> .imHomeSteadDrop(2).Picture Then
                                Set .pbDrop.Picture = .imHomeSteadDrop(2).Picture
                            End If
                        End If
                    Case [pbDisabled]
                        If index = 0 Then
                            If pbPick.Picture <> .imHomeStead(3).Picture Then
                                Set pbPick.Picture = .imHomeStead(3).Picture
                            End If
                        Else
                            If .pbDrop.Picture <> .imHomeSteadDrop(3).Picture Then
                                Set .pbDrop.Picture = .imHomeSteadDrop(3).Picture
                            End If
                        End If
                        ShapeBorder.BorderColor = &HC0C0C0
                End Select
            Case [pbMetallic]
Metallic:
                BackColor = &HFFFFFF
                .ShapeBorder.Visible = True
                .pbPick.Visible = True
                .txtResult.Appearance = 0
                .txtResult.BorderStyle = 0
                .cmdPick.Visible = False
                .cmdDrop.Visible = False
                .ShapeBorder.BorderColor = &HB99D7F
                Select Case m_State
                    Case [pbNormal]
                        If index = 0 Then
                            If pbPick.Picture <> .imMetallic(0).Picture Then
                                Set pbPick.Picture = .imMetallic(0).Picture
                            End If
                        Else
                            If .pbDrop.Picture <> .imMetallicDrop(0).Picture Then
                                Set .pbDrop.Picture = .imMetallicDrop(0).Picture
                            End If
                        End If
                    Case [pbHover]
                        If index = 0 Then
                            If pbPick.Picture <> .imMetallic(1).Picture Then
                                Set pbPick.Picture = .imMetallic(1).Picture
                            End If
                        Else
                            If .pbDrop.Picture <> .imMetallicDrop(1).Picture Then
                                Set .pbDrop.Picture = .imMetallicDrop(1).Picture
                            End If
                        End If
                    Case [pbDown]
                        If index = 0 Then
                            If pbPick.Picture <> .imMetallic(2).Picture Then
                                Set .pbPick.Picture = .imMetallic(2).Picture
                            End If
                        Else
                            If .pbDrop.Picture <> .imMetallicDrop(2).Picture Then
                                Set .pbDrop.Picture = .imMetallicDrop(2).Picture
                            End If
                        End If
                    Case [pbDisabled]
                        If index = 0 Then
                            If .pbPick.Picture <> .imMetallic(3).Picture Then
                                Set pbPick.Picture = .imMetallic(3).Picture
                            End If
                        Else
                            If .pbDrop.Picture <> .imMetallicDrop(3).Picture Then
                                Set .pbDrop.Picture = .imMetallicDrop(3).Picture
                            End If
                        End If
                        .ShapeBorder.BorderColor = &HC0C0C0
                End Select
        End Select
        .pbPick.Refresh
        .pbDrop.Refresh
        LockWindowUpdate 0&
    End With
End Sub

Public Property Get Path() As String
    Path = QualifyPath(m_Path)
End Property

Public Property Let Path(sNewPath As String)
    m_Path = QualifyPath(sNewPath)
    DialogMsg(m_DialogType) = (TrimPathByLen(m_Path, UserControl.txtResult.Width - UserControl.cmdPick.Width - 40))
    PropertyChanged "Path"
End Property

Private Function pHexColorStr(ByVal lColor As Long) As String
    '   Get the Hex version of the color...
    pHexColorStr = UCase("&H" & Hex(lColor))
End Function

Public Property Get PrinterFlags() As PrinterDialogFlags
    PrinterFlags = m_PrinterFlags
End Property

Public Property Let PrinterFlags(sDialogFlags As PrinterDialogFlags)
    m_PrinterFlags = sDialogFlags
    PropertyChanged "PrinterFlags"
End Property

Public Property Get PrintStatus() As Boolean
    PrintStatus = m_PrintStatus
End Property

Public Property Let PrintStatus(ByVal bNewValue As Boolean)
    m_PrintStatus = bNewValue
    PropertyChanged "PrintStatus"
End Property

Public Property Get PrintStatusMsg(ByVal index As Long) As String
    If index < 0 Then index = 0
    If index > 1 Then index = 1
    '   This is the Message one would get if the job was
    '   submitted completly to the Printer or not....
    PrintStatusMsg = m_PrintStatusMsg(index)
End Property

Public Property Let PrintStatusMsg(ByVal index As Long, ByVal sNewValue As String)
    If index < 0 Then index = 0
    If index > 1 Then index = 1
    '   This is the Message one would get if the job was
    '   submitted completly to the Printer or not....
    '   Note: This could be left as vbNullString if no message is required...
    m_PrintStatusMsg(index) = sNewValue
    PropertyChanged "PrintStatusMsg"
End Property

Private Function ProcessFilter(sFilter As String) As String
    Dim i As Long
    
    '   This routine replaces the Pipe (|) character for filter
    '   strings and pads the size to the required legnth.
    '
    '   Example:
    '   - Input (String)
    '       "Supported files|*.bmp;*.doc;*.jpg;*.rtf;*.txt;*.tif|Bitmap files (*.bmp)|*.bmp|Word files (*.doc)|*.doc|JPEG files (*.jpg)|*.jpg|RichText files (*.rtf)|*.rtf|Text files (*.txt)|*.txt"
    '   - Output (String)
    '       "Supported files *.bmp;*.doc;*.jpg;*.rtf;*.txt;*.tif Bitmap files (*.bmp) *.bmp Word files (*.doc) *.doc JPEG files (*.jpg) *.jpg RichText files (*.rtf) *.rtf Text files (*.txt) *.txt"
    '
    '   Check to see if the Filter is set....if not then use the "All Files (*.*)"
    If Len(sFilter) = 0 Then
        sFilter = "Supported Files|*.*|All Files (*.*)"
        '   Make sure to store this in the Control as well...
        m_Filters = sFilter
    End If
    '   Now Replace the Pipes in the Filter String
    For i = 1 To Len(sFilter)
        If (Mid$(sFilter, i, 1) = "|") Then
            Mid$(sFilter, i, 1) = vbNullChar
        End If
    Next i
    '   Pad the string to the correct length
    If (Len(sFilter) < MAX_PATH) Then
        sFilter = sFilter & String$(MAX_PATH - Len(sFilter), 0)
      Else
        sFilter = sFilter & Chr(0) & Chr(0)
    End If
    '   Pass the fixed filter back....
    ProcessFilter = sFilter
End Function

Private Sub pSelectText(ByVal TxtBox As TextBox)
    With TxtBox
        '   Select the text
        .SelStart = 0
        .SelLength = Len(TxtBox.Text)
    End With
End Sub

Public Function QualifyPath(ByVal sPath As String) As String
    Dim lStrCnt As Long
    
    If Not FileExists(sPath) Then
        '   Look for the PathSep
        lStrCnt = InStrRev(sPath, "\")
        If (lStrCnt <> Len(sPath)) Or Right$(sPath, 1) <> "\" Then
            '   None, so add it...
            QualifyPath = sPath & "\"
        Else
            '   We are good, so return the value unchanged
            QualifyPath = sPath
        End If
    Else
        QualifyPath = sPath
    End If
End Function

Public Sub Refresh(Optional ByVal index As Long)
    Dim AutoTheme As String
    
    With UserControl
        AutoTheme = GetThemeInfo
        .txtResult.Locked = False
        Call PaintControl(AutoTheme, index)
        Select Case m_DialogType
            Case [ucColor]
                '   Update the Color PickBox Values
                If m_UseDialogText Then
                    If Len(sPrevColor) = 0 Then
                        .txtResult.Text = m_DialogMsg([ucColor])
                    Else
                        .txtResult.Text = sPrevColor
                    End If
                Else
                    sPrevColor = .txtResult.Text
                    .txtResult.Text = ""
                End If
                '   Update the Color in the Dialog
                If m_UseDialogColor Then
                    .txtResult.BackColor = m_Color
                Else
                    .txtResult.BackColor = m_BackColor
                End If
                '   Update the ForeColor in the Dialog
                If m_UseAutoForeColor Then
                    '   This is a "trick" to make the ForeColor Automatically
                    '   visable even if the background is black (&H0)
                    .txtResult.ForeColor = (pHexColorStr(m_Color) Xor &HFFFFFF)
                Else
                    .txtResult.ForeColor = m_ForeColor
                End If
                .cmdPick.ToolTipText = m_ToolTipText([ucColor])
            Case [ucFolder]
                '   Update the Folder PickBox Values
                .txtResult.Locked = True
                If m_UseDialogText Then
                    .txtResult.Text = m_DialogMsg([ucFolder])
                Else
                    .txtResult.Text = ""
                End If
                .cmdPick.ToolTipText = m_ToolTipText([ucFolder])
            Case [ucFont]
                '   Update the Font PickBox Values
                .txtResult.Locked = True
                If m_UseDialogText Then
                    .txtResult.Text = m_DialogMsg([ucFont])
                Else
                    .txtResult.Text = ""
                End If
                .cmdPick.ToolTipText = m_ToolTipText([ucFont])
            Case [ucOpen]
                '   Update the Open PickBox Values
                If m_UseDialogText Then
                    If (m_Path = vbNullString) Or (Left$(m_Path, 3) <> Left$(.txtResult.Text, 3)) Then
                        .txtResult.Text = m_DialogMsg([ucOpen])
                    End If
                Else
                    .txtResult.Text = ""
                End If
                .cmdPick.ToolTipText = m_ToolTipText([ucOpen])
            Case [ucSave]
                '   Update the Save PickBox Values
                If m_UseDialogText Then
                    .txtResult.Text = m_DialogMsg([ucSave])
                Else
                    .txtResult.Text = ""
                End If
                .cmdPick.ToolTipText = m_ToolTipText([ucSave])
            Case [ucPrint]
                '   Update the Print PickBox Values
                .txtResult.Enabled = True
                If m_UseDialogText Then
                    .txtResult.Text = m_DialogMsg([ucPrint])
                Else
                    .txtResult.Text = ""
                End If
                .cmdPick.ToolTipText = m_ToolTipText([ucPrint])
        End Select
    End With
End Sub

Public Sub Reset()
    '   Reset everthing to defaults....
    On Error Resume Next
    Appearance = 1 '[3D]
    BackColor = &HFFFFFF
    m_ColorFlags = ShowColor_Default
    m_DialogMsg([ucColor]) = "Locate Color..."
    m_DialogMsg([ucFolder]) = "Locate Folder..."
    m_DialogMsg([ucFont]) = "Locate Font..."
    m_DialogMsg([ucOpen]) = "Locate File..."
    m_DialogMsg([ucSave]) = "Locate File..."
    m_DialogMsg([ucPrint]) = "Locate Printer..."
    m_DialogType = [ucColor]
    m_Filters = "Supported files|*.*|All Files (*.*)"
    m_FileFlags = IIf(m_DialogType = ucOpen, ShowOpen_Default, ShowSave_Default)
    If Not m_Font Is Nothing Then
        m_Font = Nothing
    End If
    m_FontFlags = ShowFont_Default
    ForeColor = &H0
    ReDim m_Filename(1 To 1)
    m_Filename(1) = ""
    m_Path = ""
    m_Printer = False
    m_PrinterFlags = ShowPrinter_Default
    m_PrintStatusMsg(0) = "Print Cancelled..."
    m_PrintStatusMsg(1) = "Print Completed..."
    m_ToolTipText([ucColor]) = "Click Here to Locate Color."
    m_ToolTipText([ucFolder]) = "Click Here to Locate Folder."
    m_ToolTipText([ucFont]) = "Click Here to Locate Font."
    If m_MultiSelect Then
        m_ToolTipText([ucOpen]) = "Click Here to Locate Files."
    Else
        m_ToolTipText([ucOpen]) = "Click Here to Locate File."
    End If
    m_ToolTipText([ucSave]) = "Click Here to Locate File"
    m_ToolTipText([ucPrint]) = "Click Here to Locate Printer"
    m_UseDialogColor = False
    m_UseDialogText = True
    sPrevColor = ""
End Sub

Private Function ShowColor(Optional ByVal CenterForm As Boolean = True) As SelectedColor
    Dim i As Integer
    Dim lRet As Long
    
    '   Color Common Dialog Controls
    With ColorDialog
        .hwndOwner = UserControl.Parent.hWnd
        .lStructSize = Len(ColorDialog)
        If m_ColorFlags <> 0 Then
            .Flags = m_ColorFlags
        Else
            .Flags = ShowColor_Default
        End If
    End With
    
    lRet = CHOOSECOLOR(ColorDialog)
    If lRet Then
        ShowColor.bCanceled = False
        ShowColor.oSelectedColor = ColorDialog.rgbResult
        Exit Function
    Else
        ShowColor.bCanceled = True
        ShowColor.oSelectedColor = &H0&
        Exit Function
    End If
End Function

Public Sub Show_FolderBrowse()
    DialogType = ucFolder
    cmdPick_Click
End Sub

Public Function ShowFolderBrowse(Optional Title As String = "Please Select a Folder:") As String

    Dim bInf As BROWSEINFO
    Dim RetVal As Long
    Dim PathID As Long
    Dim RetPath As String
    Dim Offset As Integer
    Dim lpSelPath As Long
    
    'Set the properties of the folder dialog
     With bInf
        .hwndOwner = UserControl.Parent.hWnd
        '   Set the Root Folder to be the DeskTop
        .pIDLRoot = 0
        '   Pass our Title
        .lpszTitle = lStrCat(Title, "")
        '   What style? Use the Flasgs set by the properties dialog
        If m_FolderFlags <> 0 Then
            .ulFlags = m_FolderFlags
        Else
            .ulFlags = ShowFolder_Default
        End If
        '   If the Path is not set then set it as the location of the App
        If m_Path = "" Then
            m_Path = App.Path & vbNullChar
        Else
            m_Path = m_Path & vbNullChar
        End If
        '   Note: This is under development.....
        '   Get address of function.
        .lpfnCallback = sc_aSubData(0).nAddrSub
        '   Now the fun part. Allocate some memory for the dialog's
        '   selected folder path (sSelPath), blast the string into
        '   the allocated memory, and set the value of the returned
        '   pointer to lParam. Note: VB's StrPtr function won't
        '   work here because a variable's memory address goes out
        '   of scope when passed to SHBrowseForFolder.
        lpSelPath = LocalAlloc(LPTR, Len(m_Path))
        '   Did our string accolation work?
        If lpSelPath Then
            '   Copy this to a pointer
            RtlMoveMemory ByVal lpSelPath, ByVal m_Path, Len(m_Path)
            '   Pass this to the structure
            .lParam = lpSelPath
        End If
    End With
    '   Show the Browse For Folder dialog
    PathID = SHBrowseForFolder(bInf)
    RetPath = Space$(512)
    RetVal = SHGetPathFromIDList(ByVal PathID, ByVal RetPath)
    If RetVal Then
         'Trim off the null chars ending the path
         'and display the returned folder
         Offset = InStr(RetPath, Chr$(0))
         ShowFolderBrowse = Left$(RetPath, Offset - 1)
         'Free memory allocated for PIDL
         CoTaskMemFree PathID
    Else
         ShowFolderBrowse = ""
    End If
End Function

Public Sub Show_Font()
    DialogType = ucFont
    cmdPick_Click
End Sub

Private Function ShowFont(ByVal oFont As StdFont, ByVal lFontColor As OLE_COLOR, Optional ByVal CenterForm As Boolean = True) As SelectedFont
    Dim lRet As Long
    Dim lfLogFont As LOGFONT
    Dim i As Integer
    Dim StartingFontName As String
    
    '   Font Common Dialog Controls
    '   Note: This has been modified to allow the caller to pass
    '         previous instance data to the Dialogs (i.e. FontName, PoitSize, Color...)
    
    With lfLogFont
        .lfHeight = 0                           ' determine default height
        .lfWidth = 0                            ' determine default width
        .lfEscapement = 0                       ' angle between baseline and escapement vector
        .lfOrientation = 0                      ' angle between baseline and orientation vector
        .lfCharSet = oFont.Charset              ' use default character set
        .lfOutPrecision = OUT_DEFAULT_PRECIS    ' default precision mapping
        .lfClipPrecision = CLIP_DEFAULT_PRECIS  ' default clipping precision
        .lfQuality = DEFAULT_QUALITY            ' default quality setting
        .lfPitchAndFamily = DEFAULT_PITCH       ' default pitch, proportional with serifs
        .lfItalic = oFont.Italic
        .lfStrikeOut = oFont.Strikethrough
        .lfUnderline = oFont.Underline
        .lfWeight = oFont.Weight
    End With
    With FontDialog
        If m_FontFlags <> 0 Then
            .Flags = m_FontFlags
        Else
            .Flags = ShowFont_Default
        End If
        .hDC = UserControl.Parent.hDC
        .hwndOwner = UserControl.Parent.hWnd
        .iPointSize = oFont.Size * 10 '   10pt
        .lCustData = 0
        .lpfnHook = 0
        .lpLogFont = VarPtr(lfLogFont)
        .lpTemplateName = Space$(2048)
        .lStructSize = Len(FontDialog)
        .nFontType = Screen.FontCount
        .nSizeMax = 72
        .nSizeMin = 8
        .rgbColors = lFontColor
    End With
    StartingFontName = oFont.Name
    For i = 0 To Len(StartingFontName) - 1
        lfLogFont.lfFacename(i) = Asc(Mid(StartingFontName, i + 1, 1))
    Next
    
    lRet = CHOOSEFONT(FontDialog)
        
    If lRet Then
        ShowFont.bCanceled = False
        ShowFont.bBold = IIf(lfLogFont.lfWeight > 400, 1, 0)
        ShowFont.bItalic = lfLogFont.lfItalic
        ShowFont.bStrikeOut = lfLogFont.lfStrikeOut
        ShowFont.bUnderline = lfLogFont.lfUnderline
        ShowFont.lColor = FontDialog.rgbColors
        m_FontColor = FontDialog.rgbColors
        ShowFont.nSize = FontDialog.iPointSize / 10
        For i = 0 To 31
            ShowFont.sSelectedFont = ShowFont.sSelectedFont + Chr(lfLogFont.lfFacename(i))
        Next
    
        ShowFont.sSelectedFont = Mid(ShowFont.sSelectedFont, 1, InStr(1, ShowFont.sSelectedFont, Chr(0)) - 1)
        Exit Function
    Else
        ShowFont.bCanceled = True
        Exit Function
    End If
End Function

Public Sub Show_Open()
    DialogType = ucOpen
    cmdPick_Click
End Sub

Private Function ShowOpen(sFilter As String, Optional ByVal CenterForm As Boolean = True) As SelectedFile
    Dim lRet As Long
    Dim Count As Integer
    Dim LastCharacter As Integer
    Dim NewCharacter As Integer
    Dim tempFiles(1 To 200) As String
    Dim lhWnd As Long
    
    '   Open Common Dialog Controls
    '   Note: This has been modified to allow the user to select either
    '         a Single or Mutliple Files...In either case the data is sent
    '         back to the caller as part of the SelectedFile data structure
    '         which has been modified to allow for Array of strings in the
    '         sFiles section.
    With FileDialog
        .nStructSize = Len(FileDialog)
        .hwndOwner = UserControl.Parent.hWnd
        .sFileTitle = Space$(2048)
        .nTitleSize = Len(FileDialog.sFileTitle)
        .sFile = FileDialog.sFile & Space$(2047) & Chr$(0)
        .nFileSize = Len(FileDialog.sFile)
        If m_FileFlags <> 0 Then
            .Flags = m_FileFlags
        Else
            .Flags = ShowOpen_Default
        End If
        If m_MultiSelect Then
            .Flags = .Flags Or AllowMultiselect
        End If
        '   Init the File Names
        .sFile = "" & Space$(2047) & Chr$(0)
        '   Process the Filter string to replace the
        '   pipes and fix the len to correct dims
        sFilter = ProcessFilter(sFilter)
        '   Set the Filter for Use...
        .sFilter = sFilter
        '   Set the Default Extension
        .sDefFileExt = m_DefaultExt
    End With
    '   Open the Common Dialog via API Calls
    lRet = GetOpenFileName(FileDialog)
    
    If lRet Then
        '   Retry Flag
GoAgain:
        If (FileDialog.nFileOffset = 0) Then
            '   This is a first time through, so the Offset will be zero. This is the
            '   case when MultiSelect = False and this is our first file selected.
            '   For cases where this is not our first time, then see "Else" notes below.
            '
            '   Extract the single Filename and pass it back....
            ReDim ShowOpen.sFiles(1 To 1)
            ShowOpen.sLastDirectory = Left$(FileDialog.sFile, FileDialog.nFileOffset)
            ShowOpen.nFilesSelected = 1
            ShowOpen.sFiles(1) = Mid(FileDialog.sFile, FileDialog.nFileOffset + 1, InStr(1, FileDialog.sFile, Chr$(0), vbTextCompare) - FileDialog.nFileOffset - 1)
        ElseIf (InStr(FileDialog.nFileOffset, FileDialog.sFile, Chr$(0)) = FileDialog.nFileOffset) Then
            '   See if we have an offset by the dialog and see if this matches the position of
            '   the (Chr$(0)) character. If this is the case, then we have Mulplitple files selected
            '   in the FileDialog.sFile array. The GetOpenFileName passes back (Chr$(0)) delimited filenames
            '   when we are in Multipile File selection mode, and the stripping of the names needs to be handled
            '   differently than when there is simply one....
            '
            '   Extract all of the files selected and pass them back in an array.
            LastCharacter = 0
            Count = 0
            While ShowOpen.nFilesSelected = 0
                NewCharacter = InStr(LastCharacter + 1, FileDialog.sFile, Chr$(0), vbTextCompare)
                If Count > 0 Then
                    tempFiles(Count) = Mid(FileDialog.sFile, LastCharacter + 1, NewCharacter - LastCharacter - 1)
                Else
                    ShowOpen.sLastDirectory = Mid(FileDialog.sFile, LastCharacter + 1, NewCharacter - LastCharacter - 1)
                End If
                Count = Count + 1
                If InStr(NewCharacter + 1, FileDialog.sFile, Chr$(0), vbTextCompare) = InStr(NewCharacter + 1, FileDialog.sFile, Chr$(0) & Chr$(0), vbTextCompare) Then
                    tempFiles(Count) = Mid(FileDialog.sFile, NewCharacter + 1, InStr(NewCharacter + 1, FileDialog.sFile, Chr$(0) & Chr$(0), vbTextCompare) - NewCharacter - 1)
                    ShowOpen.nFilesSelected = Count
                End If
                LastCharacter = NewCharacter
            Wend
            ReDim ShowOpen.sFiles(1 To ShowOpen.nFilesSelected)
            For Count = 1 To ShowOpen.nFilesSelected
                If (Right$(tempFiles(Count), 4) <> m_DefaultExt) And (Len(m_DefaultExt) > 1) Then
                    tempFiles(Count) = tempFiles(Count) & m_DefaultExt
                End If
                ShowOpen.sFiles(Count) = tempFiles(Count)
            Next
        Else
            '   This is the case where we have MutliSelect = False, but this is our
            '   Second through "n" times through...To fix this case we simlply set the
            '   FileOffset like it is our first time and then re-run the routine....
            '   The net effect is that the sub acts as if this were the first time and
            '   yeilds the name and path correctly.
            FileDialog.nFileOffset = 0
            GoTo GoAgain
        End If
        ShowOpen.bCanceled = False
        Exit Function
    Else
        '   The Cancel Button was pressed
        ShowOpen.sLastDirectory = ""
        ShowOpen.nFilesSelected = 0
        ShowOpen.bCanceled = True
        Erase ShowOpen.sFiles
        Exit Function
    End If
End Function

Public Sub Show_Printer()
    DialogType = ucPrint
    cmdPick_Click
End Sub

Private Function ShowPrinter(Optional ByVal CenterForm As Boolean = True) As Long
    '   Printer Common Dialog Controls
    With PrintDialog
        .hwndOwner = UserControl.Parent.hWnd
        .lStructSize = Len(PrintDialog)
        If m_PrinterFlags <> 0 Then
            .Flags = m_PrinterFlags
        Else
            .Flags = ShowPrinter_Default
        End If
    End With
    ShowPrinter = PrintDlg(PrintDialog)
End Function

Public Sub Show_Save()
    DialogType = ucSave
    cmdPick_Click
End Sub

Private Function ShowSave(ByVal sFilter As String, Optional ByVal CenterForm As Boolean = True) As SelectedFile
    Dim lRet As Long
    Dim lPathSep As Long
    Dim sFilename As String
    Dim sExt As String
    
    '   Save Common Dialog Controls
    With FileDialog
        .nStructSize = Len(FileDialog)
        .hwndOwner = UserControl.Parent.hWnd
        .sFileTitle = Space$(2048)
        .nTitleSize = Len(FileDialog.sFileTitle)
        .sFile = Space$(2047) & Chr$(0)
        .nFileSize = Len(FileDialog.sFile)
        If m_FileFlags <> 0 Then
            .Flags = m_FileFlags
        Else
            .Flags = ShowSave_Default
        End If
        '   Process the Filter string to replace the
        '   pipes and fix the len to correct dims
        sFilter = ProcessFilter(sFilter)
        '   Set the Filter for Use...
        .sFilter = sFilter
        '   Set the Default Extension
        .sDefFileExt = Mid(m_DefaultExt, 2)
    End With
    lRet = GetSaveFileName(FileDialog)
    ReDim ShowSave.sFiles(1)

    If lRet Then
        '   This is a work around to a bug in the FileDialog.nFileOffset routine
        '   We will trim the path and filenames outside of this routine
        '   to yeild a more consistent result....
        FileDialog.nFileOffset = 0
        ShowSave.sLastDirectory = Left$(FileDialog.sFile, FileDialog.nFileOffset)
        ShowSave.nFilesSelected = 1
        sFilename = Mid(FileDialog.sFile, FileDialog.nFileOffset + 1, InStr(1, FileDialog.sFile, Chr$(0), vbTextCompare) - FileDialog.nFileOffset - 1)
        If Right$(sFilename, 4) <> m_DefaultExt Then
            sFilename = sFilename & m_DefaultExt
        End If
        ShowSave.sFiles(1) = sFilename
        ShowSave.bCanceled = False
        Exit Function
    Else
        ShowSave.sLastDirectory = ""
        ShowSave.nFilesSelected = 0
        ShowSave.bCanceled = True
        Erase ShowSave.sFiles
        Exit Function
    End If
End Function

Public Property Get Theme() As pbThemeEnum
    Theme = m_Theme
End Property

Public Property Let Theme(ByVal New_Theme As pbThemeEnum)
    m_Theme = New_Theme
    UserControl_Resize
    PropertyChanged "Theme"
End Property

Public Property Get ToolTipTexts(ByVal lType As ucDialogConstant) As String
    '   Get the Dialg ToolTipText Message for the Type selected
    ToolTipTexts = m_ToolTipText(lType)
End Property

Public Property Let ToolTipTexts(ByVal lType As ucDialogConstant, ByVal sNewValue As String)
    '   Set the Dialg ToolTipText Message for the Type selected
    m_ToolTipText(lType) = sNewValue
    Select Case lType
        Case ucColor
            PropertyChanged "ToolTipText0"
        Case ucFolder
            PropertyChanged "ToolTipText1"
        Case ucFont
            PropertyChanged "ToolTipText2"
        Case ucOpen
            PropertyChanged "ToolTipText3"
        Case ucSave
            PropertyChanged "ToolTipText4"
        Case ucPrint
            PropertyChanged "ToolTipText5"
    End Select
    Call Refresh(0)
End Property

Public Function TranslateColor(ByVal lColor As Long) As Long
    On Error GoTo Func_ErrHandler
    
    '   System Color code to long RGB
    If OleTranslateColor(lColor, 0, TranslateColor) Then
        TranslateColor = -1
    End If
    Exit Function
Func_ErrHandler:
End Function

Public Function TrimPathByLen(ByVal sInput As String, ByVal iTextWidth As Integer, Optional ByVal sReplaceString As String = "...", Optional ByVal sFont As String = "MS Sans Serif", Optional ByVal iFontSize As Integer = 8) As String
'**************************************************************************
'Function TrimPathByLen
'
'Inputs:
'sInput As String :         the path to alter
'iTextWidth as Integer :    the desired length of the inputted path in twips
'sReplaceString as String : the string which is interted for missing text.  Default "..."
'sFont as String :          the font being used for display.  Default "MS Sans Serif"
'iFontSize as Integer :     the font size being used for display.  Default "8"

'Output:
'TrimPathByLen intellengently cuts the input (sInput) to a string that fits
'within the desired Width.
'
'**************************************************************************

    Dim iInputLen As Integer, sBeginning As String, sEnd As String
    Dim aBuffer() As String, bAddedTrailSlash As Boolean
    Dim iIndex As Integer, iArrayCount As Integer, sBuffer As String
    Dim OldFont As String, OldFontSize As Integer, OldScaleMode As ScaleModeConstants
    
    OldFont = UserControl.Font
    OldFontSize = UserControl.FontSize
    OldScaleMode = UserControl.ScaleMode
    'setup font attributes
    UserControl.Font = sFont
    UserControl.FontSize = iFontSize
    UserControl.ScaleMode = vbTwips
    
    'get length of input string in twips
    iInputLen% = UserControl.TextWidth(sInput$)
    
    'let's be reasonable here on the TextWidth
    If iTextWidth% < 200 Then Exit Function
    iTextWidth% = iTextWidth% - 400
    
    'make sure the desired text Width is smaller than
    'the length of the current string
    If iTextWidth < iInputLen% Then
            
        'now that we know how much to trim, we need to
        'determine the path type: local, network, or URL
        
        If InStr(1, sInput$, "\") > 0 Then 'LOCAL
            'add trailing slash if there is none
            If Right(sInput$, 1) <> "\" Then
                bAddedTrailSlash = True
                sInput$ = sInput$ & "\"
            End If
            
            'throw path into an array
            aBuffer() = Split(sInput$, "\")
            
            If UBound(aBuffer()) > LBound(aBuffer()) Then
                                        
                iArrayCount% = UBound(aBuffer()) - 1 'the last element is blank
                sBeginning$ = aBuffer(0) & "\" & aBuffer(1) & "\"
                sEnd$ = "\" & aBuffer(iArrayCount%)
                
                If (UserControl.TextWidth(sBeginning$) + UserControl.TextWidth(sReplaceString$) + UserControl.TextWidth(sEnd$)) > iTextWidth% Then
                'if the total outputed string is too big then stop
                    sBeginning$ = aBuffer(0) & "\"
                    If (UserControl.TextWidth(sBeginning$) + UserControl.TextWidth(sReplaceString$) + UserControl.TextWidth(sEnd$)) > iTextWidth% Then
                        TrimPathByLen$ = sReplaceString$ & sEnd$
                    Else
                        TrimPathByLen$ = sBeginning$ & sReplaceString$ & sEnd$
                    End If
                Else
                    For iIndex% = iArrayCount% - 1 To 1 Step -1 'go throug the remaing elements to get the best fit
                        sEnd$ = "\" & aBuffer(iIndex%) & sEnd$
                        If (UserControl.TextWidth(sBeginning$) + UserControl.TextWidth(sReplaceString$) + UserControl.TextWidth(sEnd$)) > iTextWidth% Then
                            'if the total outputed string is too big then stop
                            TrimPathByLen$ = sBeginning$ & sReplaceString$ & Mid$(sEnd$, Len(aBuffer(iIndex%)) + 2)
                            Exit For
                        End If
                        DoEvents
                    Next iIndex%
                End If
            Else
                'there is only one array element: bad.
                TrimPathByLen$ = sInput$
            End If
           
            Exit Function
            
        ElseIf InStr(1, sInput$, "/") > 0 Then
            If InStr(1, sInput$, ":") > 0 Then 'URL
                'start by triming off the extra params
                If InStr(1, sInput$, "?") > 0 Then sInput$ = Mid$(sInput$, 1, InStr(1, sInput$, "?") - 1)
                          
                'add trailing slash if there is none
                If Right(sInput$, 1) <> "/" Then
                    bAddedTrailSlash = True
                    sInput$ = sInput$ & "/"
                End If
                
                'throw path into an array
                aBuffer() = Split(sInput$, "/")
                
                If UBound(aBuffer()) > LBound(aBuffer()) Then
                                            
                    iArrayCount% = UBound(aBuffer()) - 1 'the last element is blank
                    sBeginning$ = aBuffer(0) & "/" & aBuffer(1) & "/"
                    sEnd$ = "/" & aBuffer(iArrayCount%)
                    
                    If (UserControl.TextWidth(sBeginning$) + UserControl.TextWidth(sReplaceString$) + UserControl.TextWidth(sEnd$)) > iTextWidth% Then
                    'if the total outputed string is too big then stop
                        sBeginning$ = aBuffer(0) & "/"
                        If (UserControl.TextWidth(sBeginning$) + UserControl.TextWidth(sReplaceString$) + UserControl.TextWidth(sEnd$)) > iTextWidth% Then
                            TrimPathByLen$ = sReplaceString$ & sEnd$
                        Else
                            TrimPathByLen$ = sBeginning$ & sReplaceString$ & sEnd$
                        End If
                    Else
                        For iIndex% = iArrayCount% - 1 To 1 Step -1 'go throug the remaing elements to get the best fit
                            sEnd$ = "/" & aBuffer(iIndex%) & sEnd$
                            If (UserControl.TextWidth(sBeginning$) + UserControl.TextWidth(sReplaceString$) + UserControl.TextWidth(sEnd$)) > iTextWidth% Then
                                'if the total outputed string is too big then stop
                                TrimPathByLen$ = sBeginning$ & sReplaceString$ & Mid$(sEnd$, Len(aBuffer(iIndex%)) + 2)
                                Exit For
                            End If
                            DoEvents
                        Next iIndex%
                    End If
                Else
                    'there is only one array element: bad.
                    TrimPathByLen$ = sInput$
                End If
                    
            Else ' NETWORK
            
                'add trailing slash if there is none
                If Right(sInput$, 1) <> "/" Then
                    bAddedTrailSlash = True
                    sInput$ = sInput$ & "/"
                End If
                
                'throw path into an array
                aBuffer() = Split(sInput$, "/")
                
                If UBound(aBuffer()) > LBound(aBuffer()) Then
                                            
                    iArrayCount% = UBound(aBuffer()) - 1 'the last element is blank
                    sBeginning$ = aBuffer(0) & "/" & aBuffer(1) & "/"
                    sEnd$ = "/" & aBuffer(iArrayCount%)
                    
                    If (UserControl.TextWidth(sBeginning$) + UserControl.TextWidth(sReplaceString$) + UserControl.TextWidth(sEnd$)) > iTextWidth% Then
                    'if the total outputed string is too big then stop
                        sBeginning$ = aBuffer(0) & "/"
                        If (UserControl.TextWidth(sBeginning$) + UserControl.TextWidth(sReplaceString$) + UserControl.TextWidth(sEnd$)) > iTextWidth% Then
                            TrimPathByLen$ = sReplaceString$ & sEnd$
                        Else
                            TrimPathByLen$ = sBeginning$ & sReplaceString$ & sEnd$
                        End If
                    Else
                        For iIndex% = iArrayCount% - 1 To 1 Step -1 'go throug the remaing elements to get the best fit
                            sEnd$ = "/" & aBuffer(iIndex%) & sEnd$
                            If (UserControl.TextWidth(sBeginning$) + UserControl.TextWidth(sReplaceString$) + UserControl.TextWidth(sEnd$)) > iTextWidth% Then
                                'if the total outputed string is too big then stop
                                TrimPathByLen$ = sBeginning$ & sReplaceString$ & Mid$(sEnd$, Len(aBuffer(iIndex%)) + 2)
                                Exit For
                            End If
                            DoEvents
                        Next iIndex%
                    End If
                Else
                    'there is only one array element: bad.
                    TrimPathByLen$ = sInput$
                End If
                            
            End If
        Else
            'um, yeah.
        End If
    Else
        'we can return the value since it's already small enough
        TrimPathByLen$ = sInput$
    End If
    '   set them back
    UserControl.Font = OldFont
    UserControl.FontSize = OldFontSize
    UserControl.ScaleMode = OldScaleMode
End Function

Private Sub pbDrop_Click()
    Call cmdDrop_Click
End Sub

Private Sub pbDrop_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = vbLeftButton Then
        m_State = pbDown
        Call Refresh(1)
    End If
    Call cmdDrop_MouseDown(Button, Shift, X, Y)
End Sub

Private Sub pbDrop_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call cmdDrop_MouseMove(Button, Shift, X, Y)
End Sub

Private Sub pbDrop_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call cmdDrop_MouseUp(Button, Shift, X, Y)
End Sub

Private Sub pbPick_Click()
    Call cmdPick_Click
End Sub

Private Sub pbPick_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = vbLeftButton Then
        m_State = pbDown
        Call Refresh(0)
    End If
    Call cmdPick_MouseDown(Button, Shift, X, Y)
End Sub

Private Sub pbPick_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call cmdPick_MouseMove(Button, Shift, X, Y)
End Sub

Private Sub pbPick_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call cmdPick_MouseUp(Button, Shift, X, Y)
End Sub

Private Sub txtResult_GotFocus()
    With UserControl
        '   Select the text for changing...
        Call pSelectText(.txtResult)
    End With
End Sub

Private Sub txtResult_KeyDown(KeyCode As Integer, Shift As Integer)
    With UserControl
        Select Case KeyCode
            Case vbKeyReturn
                '   Call the LostFocus Event Handler
                Call txtResult_LostFocus
            Case vbKeyDown
                '   This routine allow the user to arrow down to the combobox
                '   droplist. The uparrow function is in the combobox keydown
                '   event handler...
                If (m_DialogType = ucOpen) And (m_MultiSelect) And (.cmbMultiSel.ListCount > 0) Then
                    '   Set the ListIndex to 0
                    .cmbMultiSel.ListIndex = 0
                    '   Now drop the box
                    Call OpenComboBox(.cmbMultiSel, True)
                    '   Now set the focus there
                    .cmbMultiSel.SetFocus
                End If
        End Select
    End With
    RaiseEvent KeyDown(KeyCode, Shift)
End Sub

Private Sub txtResult_KeyPress(KeyAscii As Integer)
    RaiseEvent KeyPress(KeyAscii)
End Sub

Private Sub txtResult_KeyUp(KeyCode As Integer, Shift As Integer)
    RaiseEvent KeyUp(KeyCode, Shift)
End Sub

Private Sub txtResult_LostFocus()
    Dim TmpName     As String
    Dim i           As Long
    
    On Error Resume Next
    With UserControl
        Select Case m_DialogType
            Case [ucColor]
                If (Len(.txtResult.Text) = 0) Or (.txtResult.Text = m_DialogMsg(0)) Then Exit Sub
                If (IsNumeric(.txtResult.Text)) Then
                    '   Pass the value to the textbox
                    If m_UseDialogText Then
                        .txtResult.Text = pHexColorStr(TranslateColor(CLng(.txtResult.Text)))
                    End If
                    If m_UseDialogColor Then
                        .txtResult.BackColor = pHexColorStr(TranslateColor(CLng(.txtResult.Text)))
                    End If
                    '   Store this for later..
                    m_Color = .txtResult.Text
                Else
                    MsgBox "The Value Entered is Invalid!", vbExclamation + vbOKOnly, "ucPickBox"
                    '   Rollback the color...there was an error
                    .txtResult.Text = pHexColorStr(TranslateColor(m_Color))
                End If
            Case [ucFolder]
                '   Nothing...this is locked
            Case [ucFont]
                '   Nothing...this is locked
            Case [ucOpen], [ucSave]
                If (Len(.txtResult.Text) = 0) Then Exit Sub
                '   See if we have a compacted path...
                '   Note: This happens when we pick a file and
                '         compact the Path Name using the cmdPick Button.
                '         The TextBox gets focus on completion of the
                '         file selection, then when the TextBox looses focus
                '         for the next selection the path does not make sense
                '         due to ellipses (...), and therefore should be ignored.
                If InStr(1, .txtResult.Text, "...") > 0 Then
                    TmpName = m_Filename(1)
                Else
                    TmpName = .txtResult.Text
                End If
                '   Handle cases where the file name is not set (i.e. Cancel)
                If .txtResult.Text = "" Then Exit Sub
                If (m_DialogType = ucOpen) Then i = 2 Else i = 3
                If .txtResult.Text = m_DialogMsg(m_DialogType) Then Exit Sub
                '   We have a valid name, so process it...
                If FileExists(TmpName) Then
                    '   Store this for later..
                    m_Filename(1) = TmpName
                Else
                    If .txtResult.Text <> m_DialogMsg(m_DialogType) Then
                        '   Pass the value to the textbox
                        MsgBox "The Name Entered is Invalid!", vbExclamation + vbOKOnly, "ucPickBox"
                    End If
                End If
            Case [ucPrint]
                '   Nothing...this is locked
        End Select
    End With
End Sub

Private Sub txtResult_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    '   Get the Cursor Position
    m_Pnt = GetCursorPosition
    RaiseEvent MouseDown(Button, Shift, CSng(m_Pnt.X), CSng(m_Pnt.Y))
End Sub

Private Sub txtResult_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    '   Get the Cursor Position
    m_Pnt = GetCursorPosition
    If (m_PrevLoc.X <> m_Pnt.X) And (m_PrevLoc.Y <> m_Pnt.Y) Then
        RaiseEvent MouseMove(Button, Shift, CSng(m_Pnt.X), CSng(m_Pnt.Y))
        m_PrevLoc = m_Pnt
    End If
End Sub

Private Sub txtResult_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    '   Get the Cursor Position
    m_Pnt = GetCursorPosition
    RaiseEvent MouseUp(Button, Shift, CSng(m_Pnt.X), CSng(m_Pnt.Y))
End Sub

Public Property Get UseAutoForeColor() As Boolean
    '   Get if we want the forecolor to be set automatically
    '   via XOR in the textbox backcolor
    UseAutoForeColor = m_UseAutoForeColor
End Property

Public Property Let UseAutoForeColor(ByVal bNewValue As Boolean)
    '   Set if we want the forecolor to be set automatically
    '   via XOR in the textbox backcolor
    m_UseAutoForeColor = bNewValue
    PropertyChanged "UseAutoForeColor"
    Call Refresh(0)
End Property

Public Property Get UseDialogColor() As Boolean
    '   Get if we want the color as textbox backcolor
    UseDialogColor = m_UseDialogColor
End Property

Public Property Let UseDialogColor(ByVal bNewValue As Boolean)
    '   Set if we want to use color as the backcolor
    m_UseDialogColor = bNewValue
    PropertyChanged "UseDialogColor"
    Call Refresh(0)
End Property

Public Property Get UseDialogText() As Boolean
    '   Dispaly the dialog text?
    UseDialogText = m_UseDialogText
End Property

Public Property Let UseDialogText(ByVal bNewValue As Boolean)
    '   Set if the dialog is to be diaplayed
    '
    '   One might want to turn off the text if using color in the display
    m_UseDialogText = bNewValue
    PropertyChanged "UseDialogText"
    Call Refresh(0)
End Property

Private Sub UserControl_GotFocus()
    With UserControl.txtResult
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub UserControl_Initialize()
    '   Get Our Handle
    m_hWnd = UserControl.hWnd
    '   Init the Custom Colors for the Color CommonDialog
    Call InitCustomColors
    '   Rest the Control to its defaults...
    Call Reset
End Sub

Private Sub UserControl_InitProperties()
    m_Appearance = [3D]
    m_BackColor = IIf(m_BackColor = &H0, &HFFFFFF, m_BackColor)
    m_ColorFlags = ShowColor_Default
    m_Filters = "Supported files|*.*|All Files (*.*)"
    m_FileFlags = IIf(m_DialogType = ucOpen, ShowOpen_Default, ShowSave_Default)
    m_ForeColor = &H0
    m_FontFlags = ShowFont_Default
    m_PrinterFlags = ShowPrinter_Default
    m_Theme = pbAuto
    m_UseAutoForeColor = False
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    With PropBag
        m_Appearance = .ReadProperty("Appearance", [3D])
        m_UseAutoForeColor = .ReadProperty("UseAutoForeColor", True)
        m_BackColor = .ReadProperty("BackColor", &HFFFFFF)
        m_Color = .ReadProperty("Color", &HFFFFFF)
        m_ColorFlags = .ReadProperty("ColorFlags", ShowColor_Default)
        m_DefaultExt = .ReadProperty("DefaultExt", ".txt")
        m_DialogMsg([ucColor]) = .ReadProperty("DialogMsg0", "Locate Color...")
        m_DialogMsg([ucFolder]) = .ReadProperty("DialogMsg1", "Locate Folder...")
        m_DialogMsg([ucFont]) = .ReadProperty("DialogMsg2", "Locate Font...")
        m_DialogMsg([ucOpen]) = .ReadProperty("DialogMsg3", "Locate File...")
        m_DialogMsg([ucSave]) = .ReadProperty("DialogMsg4", "Locate File...")
        m_DialogMsg([ucPrint]) = .ReadProperty("DialogMsg5", "Locate Printer...")
        m_DialogType = .ReadProperty("DialogType", [ucColor])
        m_Enabled = .ReadProperty("Enabled", True)
        m_FileFlags = .ReadProperty("FileFlags", IIf(m_DialogType = ucOpen, ShowOpen_Default, ShowSave_Default))
        m_Filters = .ReadProperty("Filters", vbNullString)
        Set m_Font = .ReadProperty("Font", Nothing)
        m_FolderFlags = .ReadProperty("FolderFlags", ShowFolder_Default)
        m_FontFlags = .ReadProperty("FontFlags", ShowFont_Default)
        m_ForeColor = .ReadProperty("ForeColor", &H0)
        m_MultiSelect = .ReadProperty("MultiSelect", False)
        m_Path = .ReadProperty("Path", "")
        m_Printer = .ReadProperty("Printer", 0)
        m_PrinterFlags = .ReadProperty("PrinterFlags", ShowPrinter_Default)
        m_PrintStatusMsg(0) = .ReadProperty("PrintStatusMsg", "Print Cancelled...")
        m_PrintStatusMsg(1) = .ReadProperty("PrintStatusMsg", "Print Completed...")
        m_Theme = .ReadProperty("Theme", [pbAuto])
        m_ToolTipText([ucColor]) = .ReadProperty("ToolTipText0", "Click Here to Locate Color.")
        m_ToolTipText([ucFolder]) = .ReadProperty("ToolTipText1", "Click Here to Locate Folder.")
        m_ToolTipText([ucFont]) = .ReadProperty("ToolTipText1", "Click Here to Locate Font.")
        m_ToolTipText([ucOpen]) = .ReadProperty("ToolTipText2", "Click Here to Locate File.")
        m_ToolTipText([ucSave]) = .ReadProperty("ToolTipText3", "Click Here to Locate File.")
        m_ToolTipText([ucPrint]) = .ReadProperty("ToolTipText4", "Click Here to Locate Printer.")
        m_UseDialogColor = .ReadProperty("UseDialogColor", False)
        m_UseDialogText = .ReadProperty("UseDialogText", True)
    End With
    If (Ambient.UserMode) Then
        'If we're not in design mode
        bTrack = True
        bTrackUser32 = IsFunctionExported("TrackMouseEvent", "User32")
        If Not bTrackUser32 Then
            If Not IsFunctionExported("_TrackMouseEvent", "Comctl32") Then
                bTrack = False
            End If
        End If
        If bTrack Then
            'Add the messages that we're interested in
            With UserControl
                '   Start Subclassing using our Handle
                Call Subclass_Start(.hWnd)
                '   Subclass the BrowseForFolder Message
                Call Subclass_AddMsg(.hWnd, BFFM_INITIALIZED, MSG_BEFORE)
                '   Subclas the Move and Leave Events of the Control
                Call Subclass_AddMsg(.hWnd, WM_MOUSEMOVE, MSG_AFTER)
                Call Subclass_AddMsg(.hWnd, WM_MOUSELEAVE, MSG_AFTER)
                Call Subclass_AddMsg(.hWnd, WM_SYSCOLORCHANGE, MSG_AFTER)
                Call Subclass_AddMsg(.hWnd, WM_THEMECHANGED, MSG_AFTER)
                '   Subclass the Ellipse (Pick) Picturebox
                With .pbPick
                    Call Subclass_Start(.hWnd)
                    Call Subclass_AddMsg(.hWnd, WM_MOUSEMOVE, MSG_AFTER)
                    Call Subclass_AddMsg(.hWnd, WM_MOUSELEAVE, MSG_AFTER)
                End With
                '   Subclass the Dropdown (Drop) Picturebox
                With .pbDrop
                    Call Subclass_Start(.hWnd)
                    Call Subclass_AddMsg(.hWnd, WM_MOUSEMOVE, MSG_AFTER)
                    Call Subclass_AddMsg(.hWnd, WM_MOUSELEAVE, MSG_AFTER)
                End With
                '   Subclass the Textbox (txtResult) Picturebox
                With .txtResult
                    Call Subclass_Start(.hWnd)
                    Call Subclass_AddMsg(.hWnd, WM_MOUSEMOVE, MSG_AFTER)
                    Call Subclass_AddMsg(.hWnd, WM_MOUSELEAVE, MSG_AFTER)
                End With
                '   Store our Flag that we are Now Subclassing
                bSubClass = True
            End With
        End If
    End If
    UserControl_Resize
    '   Set the focus on the caller
    Call SetFocus(UserControl.Parent.hWnd)
End Sub

Private Sub UserControl_Resize()
    Dim AutoTheme As String
    Dim lTextHeight As Long
    
    'On Error Resume Next
    With UserControl
        '   Get the TextHeight for the textbox
        lTextHeight = .TextHeight("gé")
        '   Lock the window
        LockWindowUpdate .hWnd
        If .Width <= 1455 Then .Width = 1455
        AutoTheme = GetThemeInfo
        With .txtResult
            If (m_Theme = pbClassic) Or (AutoTheme = "None") Then
                '   Set the Min Height in Twips
                If Height <= 315 Then Height = 315
                .Top = 0
                .Left = 0
                .Width = ScaleWidth
                .Height = ScaleHeight
                UserControl.BackColor = vbButtonFace
            Else
                '   Set the Min Height in Twips
                If Height <> imBlue(0).Height + 30 Then Height = imBlue(0).Height + 30
                .Height = lTextHeight
                .Top = Height \ 2 - .Height \ 2
                .Left = ShapeBorder.BorderWidth * 2 * Screen.TwipsPerPixelX
                .Width = Width - (ShapeBorder.BorderWidth * 3 * Screen.TwipsPerPixelX)
                UserControl.BackColor = vbWhite
            End If
        End With
        With .ShapeBorder
            .Left = 0
            .Top = 0
            .Width = ScaleWidth
            .Height = ScaleHeight
        End With
        With .cmdPick
            '   Adjust the position if this is 3D or Flat
            If m_Appearance = [3D] Then
                .Left = UserControl.Width - .Width - 30
                .Top = txtResult.Top + 30
                .Height = Height - 30
            Else
                .Left = Width - .Width
                .Top = txtResult.Top
                .Height = txtResult.Height
            End If
        End With
        With .pbPick
            .Left = Width - .Width - 15
            .Top = Height \ 2 - imBlue(0).Height \ 2
            .Height = imBlue(0).Height
        End With
        With .cmbMultiSel
            '   Adjust the position if this is 3D or Flat
            If m_Appearance = [3D] Then
                .Left = 0
                .Top = 0
                .Width = txtResult.Width
            Else
                .Left = 0
                .Top = 10
                .Width = txtResult.Width
            End If
        End With
        With .cmdDrop
            '   Adjust the position if this is 3D or Flat
            If m_Appearance = [3D] Then
                .Left = cmdPick.Left - .Width + 10
            Else
                .Left = cmdPick.Left - .Width + 20
            End If
            .Top = cmdPick.Top
            .Width = cmdPick.Width
            .Height = cmdPick.Height
        End With
        '   Adjust the Dropbutton Image
        With .pbDrop
            .Left = pbPick.Left - .Width + 20
            .Top = pbPick.Top
            .Width = pbPick.Width
            .Height = pbPick.Height
        End With
    End With
    Call Refresh(0)
    Call Refresh(1)
    LockWindowUpdate 0&
End Sub

Private Sub UserControl_Show()
    Call Refresh(0)
    Call Refresh(1)
End Sub

Private Sub UserControl_Terminate()
    On Error GoTo Catch
    If bSubClass Then
        'Stop all subclassing
        Call Subclass_StopAll
        '   Set our Flag that were done....
        bSubClass = False
    End If
Catch:
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    With PropBag
        Call .WriteProperty("Appearance", m_Appearance, [3D])
        Call .WriteProperty("UseAutoForeColor", m_UseAutoForeColor, True)
        Call .WriteProperty("BackColor", m_BackColor, &HFFFFFF)
        Call .WriteProperty("Color", m_Color, &HFFFFFF)
        Call .WriteProperty("ColorFlags", m_ColorFlags, ShowColor_Default)
        Call .WriteProperty("DefaultExt", m_DefaultExt, ".txt")
        Call .WriteProperty("DialogMsg0", m_DialogMsg([ucColor]), "Locate Color...")
        Call .WriteProperty("DialogMsg1", m_DialogMsg([ucFolder]), "Locate Folder...")
        Call .WriteProperty("DialogMsg2", m_DialogMsg([ucFont]), "Locate Font...")
        Call .WriteProperty("DialogMsg3", m_DialogMsg([ucOpen]), "Locate File...")
        Call .WriteProperty("DialogMsg4", m_DialogMsg([ucSave]), "Locate File...")
        Call .WriteProperty("DialogMsg5", m_DialogMsg([ucPrint]), "Locate Printer...")
        Call .WriteProperty("DialogType", m_DialogType, [ucColor])
        Call .WriteProperty("Enabled", m_Enabled, True)
        Call .WriteProperty("FileFlags", m_FileFlags, IIf(m_DialogType = ucOpen, ShowOpen_Default, ShowSave_Default))
        Call .WriteProperty("Filters", m_Filters, vbNullString)
        Call .WriteProperty("FolderFlags", m_FolderFlags, ShowFolder_Default)
        Call .WriteProperty("Font", m_Font, Nothing)
        Call .WriteProperty("FontFlags", m_FontFlags, ShowFont_Default)
        Call .WriteProperty("ForeColor", m_ForeColor, &H0)
        Call .WriteProperty("MultiSelect", m_MultiSelect, False)
        Call .WriteProperty("Path", m_Path, "")
        Call .WriteProperty("Printer", m_Printer, 0)
        Call .WriteProperty("PrinterFlags", m_PrinterFlags, ShowPrinter_Default)
        Call .WriteProperty("PrintStatusMsg", m_PrintStatusMsg(0), "Print Cancelled...")
        Call .WriteProperty("PrintStatusMsg", m_PrintStatusMsg(1), "Print Completed...")
        Call .WriteProperty("Theme", m_Theme, [pbAuto])
        Call .WriteProperty("ToolTipText0", m_ToolTipText([ucColor]), "Click Here to Locate Color.")
        Call .WriteProperty("ToolTipText1", m_ToolTipText([ucFolder]), "Click Here to Locate Folder.")
        Call .WriteProperty("ToolTipText1", m_ToolTipText([ucFont]), "Click Here to Locate Font.")
        Call .WriteProperty("ToolTipText2", m_ToolTipText([ucOpen]), "Click Here to Locate File.")
        Call .WriteProperty("ToolTipText3", m_ToolTipText([ucSave]), "Click Here to Locate File.")
        Call .WriteProperty("ToolTipText4", m_ToolTipText([ucPrint]), "Click Here to Locate Printer.")
        Call .WriteProperty("UseDialogColor", m_UseDialogColor, False)
        Call .WriteProperty("UseDialogText", m_UseDialogText, True)
    End With
End Sub

Property Get Version() As String
    Version = Major & "." & Minor & "." & Revision
End Property






