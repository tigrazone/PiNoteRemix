{ <PiNote - free source code editor>

Copyright (C) <2023> <Enzo Antonio Calogiuri> <ecalogiuri(at)gmail.com>

This source is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option)
any later version.

This code is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

A copy of the GNU General Public License is available on the World Wide Web
at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
to the Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
Boston, MA 02110-1335, USA.
}

unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, uTabForm, HistoryFiles, LConvEncoding, SynEdit, SynEditTypes,
  PrintersDlgs, LCLIntf, LCLType, ExtDlgs, ExtCtrls, StdCtrls, BlowFish, Base64,
  uPiNoteOptions, Variants, SynEditKeyCmds, SynMacroRecorder, SynExportHTML,
  Types;

Const
     PiNoteVersionNumber     = '1.4';
     PiNoteVersionName       = 'Touchy cat';

     //Per la nuova versione
     //-Adesso il pannello della clipboard tronca le linee lunghe
     //-PiNote rileva se il contenuto della clipboard è cambiato (se visibile
     // il pannello della cliboard) con dati provenienti da applicazioni esterne
     //-Aggiunto supporto al linguaggio AutoIt
     //-Aggiunto supporto al linguaggio Erlang
     //-Aggiunto supporto al linguaggio ProtoBuf
     //-Aggiunto supporto al linguaggio Kotlin
     //-Le intestazioni delle licenze software vengono ora insertite con i
     // caratteri di commento relativi a ciascun linguaggio selezionato
     //-Aggiunta la licenza Apache 2.0
     //-Aggiunta la licenza MPL 2.0
     //-Aggiunto il tema "Into The Blue"
     //-Aggiunto il tema "Show Walker"

     OptionsPathName         = '.pinote';
     OptionsFile             = 'PiNoteOptions.ini';
     CR                      = #13;
     LF                      = #10;
     CRLF                    = #13#10;

type

    TLineBreak            = (lbNoChange, lbWindows, lbUnix, lbMac);

    SearchRec                 = Record
     Found                   : Boolean;
     FileName                : String;
     LineFound               : String;
     Row                     : Integer;
     Col                     : Integer;
     EdFormIdx               : Integer;
    end;

  { TMain }

  TMain = class(TForm)
    ColorDialog: TColorDialog;
    FindDialog: TFindDialog;
    gbClipboardPanel: TGroupBox;
    ImageList1: TImageList;
    lbClipboard: TListBox;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem100: TMenuItem;
    MenuItem101: TMenuItem;
    MenuItem102: TMenuItem;
    MenuItem103: TMenuItem;
    MenuItem104: TMenuItem;
    MenuItem105: TMenuItem;
    MenuItem106: TMenuItem;
    MenuItem107: TMenuItem;
    MenuItem108: TMenuItem;
    MenuItem109: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem110: TMenuItem;
    MenuItem111: TMenuItem;
    MenuItem112: TMenuItem;
    MenuItem113: TMenuItem;
    MenuItem114: TMenuItem;
    MenuItem115: TMenuItem;
    MenuItem116: TMenuItem;
    MenuItem117: TMenuItem;
    MenuItem118: TMenuItem;
    MenuItem119: TMenuItem;
    MenuItem120: TMenuItem;
    MenuItem121: TMenuItem;
    MenuItem122: TMenuItem;
    MenuItem123: TMenuItem;
    MenuItem124: TMenuItem;
    MenuItem125: TMenuItem;
    MenuItem126: TMenuItem;
    MenuItem127: TMenuItem;
    MenuItem128: TMenuItem;
    MenuItem129: TMenuItem;
    MenuItem130: TMenuItem;
    MenuItem131: TMenuItem;
    MenuItem132: TMenuItem;
    MenuItem133: TMenuItem;
    MenuItem134: TMenuItem;
    MenuItem135: TMenuItem;
    MenuItem136: TMenuItem;
    MenuItem137: TMenuItem;
    MenuItem138: TMenuItem;
    MenuItem139: TMenuItem;
    MenuItem140: TMenuItem;
    MenuItem141: TMenuItem;
    MenuItem142: TMenuItem;
    MenuItem143: TMenuItem;
    MenuItem144: TMenuItem;
    MenuItem145: TMenuItem;
    MenuItem146: TMenuItem;
    MenuItem147: TMenuItem;
    MenuItem148: TMenuItem;
    MenuItem149: TMenuItem;
    MenuItem150: TMenuItem;
    MenuItem151: TMenuItem;
    MenuItem152: TMenuItem;
    MenuItem153: TMenuItem;
    MenuItem154: TMenuItem;
    MenuItem155: TMenuItem;
    MenuItem156: TMenuItem;
    MenuItem157: TMenuItem;
    MenuItem158: TMenuItem;
    MenuItem159: TMenuItem;
    MenuItem160: TMenuItem;
    MenuItem161: TMenuItem;
    MenuItem162: TMenuItem;
    MenuItem165: TMenuItem;
    MenuItem166: TMenuItem;
    MenuItem167: TMenuItem;
    MenuItem168: TMenuItem;
    MenuItem169: TMenuItem;
    MenuItem170: TMenuItem;
    MenuItem171: TMenuItem;
    MenuItem172: TMenuItem;
    MenuItem173: TMenuItem;
    MenuItem174: TMenuItem;
    MenuItem175: TMenuItem;
    MenuItem176: TMenuItem;
    MenuItem177: TMenuItem;
    MenuItem178: TMenuItem;
    MenuItem179: TMenuItem;
    MenuItem180: TMenuItem;
    MenuItem181: TMenuItem;
    MenuItem182: TMenuItem;
    mBookm0: TMenuItem;
    mBookm1: TMenuItem;
    mBookm2: TMenuItem;
    mBookm3: TMenuItem;
    mBookm4: TMenuItem;
    mBookm5: TMenuItem;
    mBookm6: TMenuItem;
    mBookm7: TMenuItem;
    mBookm8: TMenuItem;
    mBookm9: TMenuItem;
    MenuItem183: TMenuItem;
    MenuItem184: TMenuItem;
    MenuItem185: TMenuItem;
    MenuItem186: TMenuItem;
    MenuItem187: TMenuItem;
    MenuItem188: TMenuItem;
    MenuItem189: TMenuItem;
    MenuItem190: TMenuItem;
    MenuItem191: TMenuItem;
    MenuItem192: TMenuItem;
    MenuItem193: TMenuItem;
    MenuItem194: TMenuItem;
    MenuItem195: TMenuItem;
    MenuItem196: TMenuItem;
    MenuItem197: TMenuItem;
    MenuItem198: TMenuItem;
    MenuItem199: TMenuItem;
    MenuItem200: TMenuItem;
    MenuItem201: TMenuItem;
    MenuItem202: TMenuItem;
    MenuItem203: TMenuItem;
    MenuItem204: TMenuItem;
    MenuItem205: TMenuItem;
    MenuItem206: TMenuItem;
    MenuItem207: TMenuItem;
    MenuItem208: TMenuItem;
    MenuItem209: TMenuItem;
    MenuItem210: TMenuItem;
    MenuItem211: TMenuItem;
    MenuItem212: TMenuItem;
    MenuItem213: TMenuItem;
    MenuItem214: TMenuItem;
    MenuItem215: TMenuItem;
    MenuItem216: TMenuItem;
    MenuItem217: TMenuItem;
    MenuItem218: TMenuItem;
    MenuItem219: TMenuItem;
    MenuItem220: TMenuItem;
    MenuItem221: TMenuItem;
    miViewRuler: TMenuItem;
    miViewMinimapPanel: TMenuItem;
    miMicroMode: TMenuItem;
    miTabs: TMenuItem;
    miDocSelNormal: TMenuItem;
    miDocSelLine: TMenuItem;
    miDocSelColumn: TMenuItem;
    miViewClipboardPanel: TMenuItem;
    mrBookm9: TMenuItem;
    mrBookm8: TMenuItem;
    mrBookm7: TMenuItem;
    mrBookm6: TMenuItem;
    mrBookm5: TMenuItem;
    mrBookm4: TMenuItem;
    mrBookm3: TMenuItem;
    mrBookm2: TMenuItem;
    mrBookm1: TMenuItem;
    mrBookm0: TMenuItem;
    N4: TMenuItem;
    N3: TMenuItem;
    miViewLineHighlight: TMenuItem;
    miOpenWith: TMenuItem;
    MenuItem163: TMenuItem;
    MenuItem164: TMenuItem;
    N2: TMenuItem;
    miReadOnly: TMenuItem;
    N1: TMenuItem;
    miLoadRM: TMenuItem;
    miSaveRM: TMenuItem;
    miResumeRM: TMenuItem;
    miPauseRM: TMenuItem;
    miClearRM: TMenuItem;
    miPlayRM: TMenuItem;
    miStopRM: TMenuItem;
    miStartRM: TMenuItem;
    miAutoCBrackets: TMenuItem;
    miLBWin: TMenuItem;
    miLBUnix: TMenuItem;
    miLBMac: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuItem49: TMenuItem;
    MenuItem50: TMenuItem;
    MenuItem51: TMenuItem;
    MenuItem52: TMenuItem;
    MenuItem53: TMenuItem;
    MenuItem54: TMenuItem;
    MenuItem55: TMenuItem;
    MenuItem56: TMenuItem;
    MenuItem57: TMenuItem;
    MenuItem58: TMenuItem;
    MenuItem59: TMenuItem;
    MenuItem60: TMenuItem;
    MenuItem61: TMenuItem;
    MenuItem62: TMenuItem;
    MenuItem63: TMenuItem;
    MenuItem64: TMenuItem;
    MenuItem65: TMenuItem;
    MenuItem66: TMenuItem;
    MenuItem67: TMenuItem;
    MenuItem68: TMenuItem;
    MenuItem69: TMenuItem;
    MenuItem70: TMenuItem;
    MenuItem71: TMenuItem;
    MenuItem72: TMenuItem;
    MenuItem73: TMenuItem;
    MenuItem74: TMenuItem;
    MenuItem75: TMenuItem;
    MenuItem76: TMenuItem;
    MenuItem77: TMenuItem;
    MenuItem78: TMenuItem;
    MenuItem79: TMenuItem;
    MenuItem80: TMenuItem;
    MenuItem81: TMenuItem;
    MenuItem82: TMenuItem;
    MenuItem83: TMenuItem;
    MenuItem84: TMenuItem;
    MenuItem85: TMenuItem;
    MenuItem86: TMenuItem;
    MenuItem87: TMenuItem;
    MenuItem88: TMenuItem;
    MenuItem89: TMenuItem;
    MenuItem90: TMenuItem;
    MenuItem91: TMenuItem;
    MenuItem92: TMenuItem;
    MenuItem93: TMenuItem;
    MenuItem94: TMenuItem;
    MenuItem95: TMenuItem;
    MenuItem96: TMenuItem;
    MenuItem97: TMenuItem;
    MenuItem98: TMenuItem;
    MenuItem99: TMenuItem;
    miSyntaxScheme: TMenuItem;
    miTansparentMode: TMenuItem;
    miStayOnTop: TMenuItem;
    miViewRightEdge: TMenuItem;
    miViewLineNumbers: TMenuItem;
    miFullScreen: TMenuItem;
    miStatusBar: TMenuItem;
    miToolBar: TMenuItem;
    miMenuBar: TMenuItem;
    mInsSS: TMenuItem;
    mRecentFiles: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenFile: TOpenDialog;
    PageDock: TPageControl;
    PageSetupDialog: TPageSetupDialog;
    pmClipPanel: TPopupMenu;
    pmMicro: TPopupMenu;
    PrintDialog: TPrintDialog;
    PrinterSetupDialog: TPrinterSetupDialog;
    ReplaceDialog: TReplaceDialog;
    SaveFile: TSaveDialog;
    SavePic: TSavePictureDialog;
    Splitter1: TSplitter;
    StatusBar: TStatusBar;
    HTMLExp: TSynExporterHTML;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure FindDialogFind(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure gbClipboardPanelResize(Sender: TObject);
    procedure lbClipboardDblClick(Sender: TObject);
    procedure lbClipboardShowHint(Sender: TObject; HintInfo: PHintInfo);
    procedure MenuItem100Click(Sender: TObject);
    procedure MenuItem102Click(Sender: TObject);
    procedure MenuItem103Click(Sender: TObject);
    procedure MenuItem105Click(Sender: TObject);
    procedure MenuItem106Click(Sender: TObject);
    procedure MenuItem108Click(Sender: TObject);
    procedure MenuItem110Click(Sender: TObject);
    procedure MenuItem113Click(Sender: TObject);
    procedure MenuItem114Click(Sender: TObject);
    procedure MenuItem116Click(Sender: TObject);
    procedure MenuItem117Click(Sender: TObject);
    procedure MenuItem119Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem120Click(Sender: TObject);
    procedure MenuItem123Click(Sender: TObject);
    procedure MenuItem125Click(Sender: TObject);
    procedure MenuItem126Click(Sender: TObject);
    procedure MenuItem127Click(Sender: TObject);
    procedure MenuItem128Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem130Click(Sender: TObject);
    procedure MenuItem132Click(Sender: TObject);
    procedure MenuItem133Click(Sender: TObject);
    procedure MenuItem134Click(Sender: TObject);
    procedure MenuItem138Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem141Click(Sender: TObject);
    procedure MenuItem142Click(Sender: TObject);
    procedure MenuItem144Click(Sender: TObject);
    procedure MenuItem145Click(Sender: TObject);
    procedure MenuItem146Click(Sender: TObject);
    procedure MenuItem147Click(Sender: TObject);
    procedure MenuItem148Click(Sender: TObject);
    procedure MenuItem150Click(Sender: TObject);
    procedure MenuItem151Click(Sender: TObject);
    procedure MenuItem152Click(Sender: TObject);
    procedure MenuItem154Click(Sender: TObject);
    procedure MenuItem155Click(Sender: TObject);
    procedure MenuItem156Click(Sender: TObject);
    procedure MenuItem157Click(Sender: TObject);
    procedure MenuItem158Click(Sender: TObject);
    procedure MenuItem159Click(Sender: TObject);
    procedure MenuItem161Click(Sender: TObject);
    procedure MenuItem162Click(Sender: TObject);
    procedure MenuItem166Click(Sender: TObject);
    procedure MenuItem167Click(Sender: TObject);
    procedure MenuItem168Click(Sender: TObject);
    procedure MenuItem169Click(Sender: TObject);
    procedure MenuItem170Click(Sender: TObject);
    procedure MenuItem171Click(Sender: TObject);
    procedure MenuItem173Click(Sender: TObject);
    procedure MenuItem174Click(Sender: TObject);
    procedure MenuItem175Click(Sender: TObject);
    procedure MenuItem176Click(Sender: TObject);
    procedure MenuItem177Click(Sender: TObject);
    procedure MenuItem178Click(Sender: TObject);
    procedure MenuItem180Click(Sender: TObject);
    procedure MenuItem184Click(Sender: TObject);
    procedure MenuItem186Click(Sender: TObject);
    procedure MenuItem187Click(Sender: TObject);
    procedure MenuItem189Click(Sender: TObject);
    procedure MenuItem190Click(Sender: TObject);
    procedure MenuItem192Click(Sender: TObject);
    procedure MenuItem197Click(Sender: TObject);
    procedure MenuItem199Click(Sender: TObject);
    procedure MenuItem200Click(Sender: TObject);
    procedure MenuItem201Click(Sender: TObject);
    procedure MenuItem203Click(Sender: TObject);
    procedure MenuItem204Click(Sender: TObject);
    procedure MenuItem205Click(Sender: TObject);
    procedure MenuItem206Click(Sender: TObject);
    procedure MenuItem207Click(Sender: TObject);
    procedure MenuItem208Click(Sender: TObject);
    procedure MenuItem209Click(Sender: TObject);
    procedure MenuItem211Click(Sender: TObject);
    procedure MenuItem212Click(Sender: TObject);
    procedure MenuItem213Click(Sender: TObject);
    procedure MenuItem214Click(Sender: TObject);
    procedure MenuItem215Click(Sender: TObject);
    procedure MenuItem216Click(Sender: TObject);
    procedure MenuItem217Click(Sender: TObject);
    procedure MenuItem218Click(Sender: TObject);
    procedure MenuItem219Click(Sender: TObject);
    procedure MenuItem220Click(Sender: TObject);
    procedure MenuItem221Click(Sender: TObject);
    procedure miDocSelColumnClick(Sender: TObject);
    procedure miDocSelLineClick(Sender: TObject);
    procedure miDocSelNormalClick(Sender: TObject);
    procedure miMicroModeClick(Sender: TObject);
    procedure miOpenWithClick(Sender: TObject);
    procedure MenuItem163Click(Sender: TObject);
    procedure MenuItem164Click(Sender: TObject);
    procedure miReadOnlyClick(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem28Click(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure MenuItem34Click(Sender: TObject);
    procedure MenuItem35Click(Sender: TObject);
    procedure MenuItem36Click(Sender: TObject);
    procedure MenuItem38Click(Sender: TObject);
    procedure MenuItem39Click(Sender: TObject);
    procedure MenuItem40Click(Sender: TObject);
    procedure MenuItem41Click(Sender: TObject);
    procedure MenuItem43Click(Sender: TObject);
    procedure MenuItem45Click(Sender: TObject);
    procedure MenuItem46Click(Sender: TObject);
    procedure MenuItem48Click(Sender: TObject);
    procedure MenuItem70Click(Sender: TObject);
    procedure MenuItem71Click(Sender: TObject);
    procedure MenuItem72Click(Sender: TObject);
    procedure MenuItem74Click(Sender: TObject);
    procedure MenuItem76Click(Sender: TObject);
    procedure MenuItem77Click(Sender: TObject);
    procedure MenuItem78Click(Sender: TObject);
    procedure MenuItem79Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem81Click(Sender: TObject);
    procedure MenuItem84Click(Sender: TObject);
    procedure MenuItem85Click(Sender: TObject);
    procedure MenuItem86Click(Sender: TObject);
    procedure MenuItem87Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem90Click(Sender: TObject);
    procedure MenuItem91Click(Sender: TObject);
    procedure MenuItem92Click(Sender: TObject);
    procedure MenuItem93Click(Sender: TObject);
    procedure MenuItem95Click(Sender: TObject);
    procedure MenuItem96Click(Sender: TObject);
    procedure MenuItem97Click(Sender: TObject);
    procedure MenuItem98Click(Sender: TObject);
    procedure miAutoCBracketsClick(Sender: TObject);
    procedure miClearRMClick(Sender: TObject);
    procedure miFullScreenClick(Sender: TObject);
    procedure miLBMacClick(Sender: TObject);
    procedure miLBUnixClick(Sender: TObject);
    procedure miLBWinClick(Sender: TObject);
    procedure miLoadRMClick(Sender: TObject);
    procedure miMenuBarClick(Sender: TObject);
    procedure mInsSSClick(Sender: TObject);
    procedure miPauseRMClick(Sender: TObject);
    procedure miPlayRMClick(Sender: TObject);
    procedure miResumeRMClick(Sender: TObject);
    procedure miSaveRMClick(Sender: TObject);
    procedure miStartRMClick(Sender: TObject);
    procedure miStatusBarClick(Sender: TObject);
    procedure miStayOnTopClick(Sender: TObject);
    procedure miStopRMClick(Sender: TObject);
    procedure miTansparentModeClick(Sender: TObject);
    procedure miToolBarClick(Sender: TObject);
    procedure miViewClipboardPanelClick(Sender: TObject);
    procedure miViewLineHighlightClick(Sender: TObject);
    procedure miViewLineNumbersClick(Sender: TObject);
    procedure miViewMinimapPanelClick(Sender: TObject);
    procedure miViewRightEdgeClick(Sender: TObject);
    procedure miViewRulerClick(Sender: TObject);
    procedure PageDockChange(Sender: TObject);
    procedure PageDockCloseTabClicked(Sender: TObject);
    procedure PageDockDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PageDockDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PageDockMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ReplaceDialogFind(Sender: TObject);
    procedure ReplaceDialogReplace(Sender: TObject);
    procedure smConvertEncoding(Sender: TObject);
    Procedure OnSubMenuSyntaxSchemeClick(Sender: TObject);

    Procedure smBookmClick(Sender: TObject);
    Procedure smBookrmClick(Sender: TObject);

    Procedure DocumentTabsMenuClick(Sender: TObject);
  private
    { private declarations }
    MyEditorSpace : TTabForm;
    NewFileIdx : Integer;
    CurrEnCoding : String;
    OldConvMI : TMenuItem;
    FirstShow : Boolean;
    OldmiStatusBar : Boolean;
    OldmiToolBar : Boolean;
    OldmiMenuBar : Boolean;
    OldmiViewClipboardPanel : Boolean;
    MouseIsDown : Boolean;
    mPx, mPy : Integer;
    CplBItems : TStringList;

    Function CryptString(Const Key : String; Line : String) : String;
    Function DeCryptString(Const Key : String; Line : String) : String;

    Procedure SaveScreenShot(SE: TSynEdit; FileName: String; OrigCanvas: TCanvas);

    Procedure ClickOnHistoryItem(Sender : TObject; Item : TMenuItem; Const FileName : String);

    Function GetSyntaxSchemeIDFromFileName(Const FileName : String) : Integer;

    Procedure ApplyStartUpOptions;

    Procedure SaveWindowPos;
    Procedure RestoreWindowPos;

    Function IsFileInUse(Const TheFile : String) : Boolean;
    Function ListOfModifiedDocuments(FromIdx : Integer = -1;
                                     ToIdx : Integer = -1; IdxToJump : Integer = -1) : TStringList;

    Function IsSpaceChar(Const C : AnsiChar) : Boolean;
    Function SIndentOf(Const S : Widestring) : Widestring;
    Function ReturnLineBreak(SystemLineBreak: TLineBreak): String;

    Procedure UpdateLineBreakMenu;

    Procedure OpenWithDefaultBrowser(Const myUrl : String);

    Procedure BuildFileDialogFilter;

    Procedure Load_Bookmark_In_Menu(SE: TSynEdit; TB : TTabSheet);

    Procedure SetClipboardPanelState(cpState : Boolean);

    Procedure CopyMenu(mSrc, mDst : TMenu);

    Function CountWords(const S: String): LongInt;

    Procedure PopulateClipBoardPanel;
  public
    { public declarations }
    PiNoteOptions : TPiNoteOptions;
    PiNoteFontInUse : String;
    PiNoteFontSize : Integer;
    PiNoteFontStyle : TFontStyles;
    PiNoteDefaultSyntaxScheme : Integer;
    PiNoteEditorTabWidth : Integer;
    PiNoteEditorMaxUndo : Integer;
    PiNoteRightEdgePos : Integer;
    PiNoteFontQuality : TFontQuality;
    UsefulOpt : Array Of Boolean;
    bOptions : Array Of Boolean;
    FileHistory : THistoryFiles;
    UserLineBreak : TLineBreak;
    PiNoteOptionsPath : String;

    Procedure NewEditorTab(Const FileName : String; OpenAsHex : Boolean = False);

    Procedure UpdateSyntaxSchemeMenu(IDLanguage : Integer; ssMenu : TMenuItem);

    Procedure ApplySyntaxOptions;

    Procedure ApplyDocumentOptions;

    Procedure MovePage(bToRight : Boolean);
    Procedure MovePageBeginOrEnd(ToBegin : Boolean);

    Procedure SavePiNoteFile(uEditor : TForm);

    Procedure ClearDocumentTabsMenu;
    Procedure BuildDocumentTabsMenu;

    Procedure InsertIntoClipboardPanel(Const Val : String);
    Function GetSelectedFromClipboardPanel : String;
  end;

var
  Main: TMain;

implementation

Uses uEditor, uQueryReload, uSymbForm, uGotoL, U_Pass, U_Messages, uHXTag,
     ClipBrd, uSyntaxList, uSynSchOpt, uThemesDefault, uGeneralOpt,
     uSyntaxDefault, uUniqeInstance, uQueryEditedFiles, MySEPrint,
     uPrintPreview, uBaseConverter, uSetExtTools, uExtTools, StrUtils,
     uInsNumbering, uSearchIntoFile, uRTFSynExport, MD5, uMD5Sign, uMD5SignFile,
     uCRC32Sign, uCRC32SignFile, uMyCRC, uRun, LCLProc, LazHelpHTML,
     UTF8Process, Process, uInfo, LazFileUtils, uManageTabs, uSummary,
     uSHA256Sign, uSHA256SignFile, uSHA256, uCreateBanner, uMultiPaste,
     MySEHighlighterEmpty;

{$R *.lfm}

{ TMain }

procedure TMain.FormCreate(Sender: TObject);
 Var sE : TSynEdit;
begin
 PiNoteOptionsPath := AppendPathDelim(GetUserDir) + OptionsPathName;

 If Not DirectoryExists(PiNoteOptionsPath) Then
  If Not CreateDir(PiNoteOptionsPath) Then
   PiNoteOptionsPath := ExtractFilePath(Application.ExeName);

 miDocSelNormal.Checked := True;
 miDocSelLine.Checked := False;
 miDocSelColumn.Checked := False;

 ClearCommentDataList;

 //ClearListASMWordFinder;

 //BuildListASMWordFinder;

 FirstShow := True;
 MouseIsDown := False;

 Screen.Cursor := crHourGlass;

 sE := TSynEdit.Create(Nil);

 //Ottiene il font di default del sistema
 PiNoteFontInUse := sE.Font.Name;

 sE.Free;

 MyEditorSpace := TTabForm.Create(PageDock);

 FileHistory := THistoryFiles.Create(Self);
 FileHistory.ParentMenu := mRecentFiles;
 //FileHistory.LocalPath := ExtractFilePath(Application.ExeName);
 FileHistory.LocalPath := PiNoteOptionsPath;
 //FileHistory.IniFile := ExtractFilePath(Application.ExeName) + 'recentf.ini';
 FileHistory.IniFile := AppendPathDelim(PiNoteOptionsPath) + 'recentf.ini';
 FileHistory.OnClickHistoryItem := @ClickOnHistoryItem;

 NewFileIdx := 0;
 PiNoteFontSize := 10;
 PiNoteFontStyle := [];
 PiNoteDefaultSyntaxScheme := -1;
 PiNoteEditorTabWidth := 4;
 PiNoteEditorMaxUndo := 1024;
 PiNoteRightEdgePos := 80;
 PiNoteFontQuality := fqDefault;

 CreateSyntaxSchemeList;
 CreateDefaultThemes;

 CreateSyntaxSubMenu(miSyntaxScheme);

 PiNoteOptions := TPiNoteOptions.Create(AppendPathDelim(PiNoteOptionsPath) + OptionsFile);

 ApplySyntaxOptions;

 ApplyStartUpOptions;

 Load_ExtToolsArray;

 Screen.Cursor := crDefault;

 If UsefulOpt[1] Then
  If InstanceRunning Then
   Application.Terminate;

 UserLineBreak := lbNoChange;

 {$IfDef Windows}
 UserLineBreak := lbWindows;
 miOpenWith.Caption := 'Open with default browser';
 {$Endif}

 {$IfDef Unix}
 UserLineBreak := lbUnix;
 {$Endif}

 {$IfDef Darwin}
 UserLineBreak := lbMac;
 {$Endif}

 UpdateLineBreakMenu;

 fMD5Sign := TfMD5Sign.Create(Self);
 fMD5SignFile := TfMD5SignFile.Create(Self);
 fCRC32Sign := TfCRC32Sign.Create(Self);
 fCRC32SignFile := TfCRC32SignFile.Create(Self);
 fSHA256Sign := TfSHA256Sign.Create(Application);
 fSHA256SignFile := TfSHA256SignFile.Create(Application);

 SetClipboardPanelState(False);

 ClearDocumentTabsMenu;

 CplBItems := TStringList.Create;

 Application.OnActivate := @FormActivate;
end;

procedure TMain.FindDialogFind(Sender: TObject);
 Var SRec : TSynSearchOptions;
     Tmp : TForm;
begin
 SRec := [];

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor).sEdit Do
     Begin
      FindDialog.CloseDialog;

      If frWholeWord In FindDialog.Options Then
       SRec := SRec + [ssoWholeWord];

      If Not (frDown In FindDialog.Options) Then
       SRec := SRec + [ssoBackwards];

      If frEntireScope In FindDialog.Options Then
       SRec := SRec + [ssoEntireScope]
      Else
       SRec := [ssoPrompt];

      If frMatchCase In FindDialog.Options Then
       SRec := SRec + [ssoMatchCase];

      SearchReplace(FindDialog.FindText, '', SRec);
     end;
   end;
end;

procedure TMain.FormActivate(Sender: TObject);
 Var ClbVal : String;
begin
 If gbClipboardPanel.Visible Then
  Begin
   ClbVal := ClipBoard.AsText;

   If ClbVal = '' Then
    Exit;

   If CplBItems.IndexOf(ClbVal) < 0 Then
    InsertIntoClipboardPanel(ClbVal);
  end;
end;

procedure TMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 If UsefulOpt[0] Then
  SaveWindowPos;
end;

procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
 Var UnSaved : TStringList;
     QueryResult : Word;
begin
 UnSaved := ListOfModifiedDocuments;
 QueryResult := 0;

 If UnSaved.Count > 0 Then
  Begin
   fQueryEditedFiles := TfQueryEditedFiles.Create(Self);
   fQueryEditedFiles.lbEditedDoc.Items.Assign(UnSaved);

   fQueryEditedFiles.ShowModal;

   QueryResult := fQueryEditedFiles.ResultType;

   fQueryEditedFiles.Free;
  end;

 If QueryResult = 2 Then
  Begin
   CanClose := False;

   Exit;
  end;

 If QueryResult = 1 Then
  MenuItem13Click(Sender);

 If UsefulOpt[5] Then
  If MessageDlg('Do you really want to close PiNote?', mtConfirmation, [mbOk, mbCancel], 0) = mrCancel Then
   CanClose := False;
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
 MyEditorSpace.Free;
 FileHistory.Free;

 DestroySyntaxSchemeList;
 DestroyDefaultThemes;

 PiNoteOptions.Free;

 If UsefulOpt[4] Then
  Clipboard.Clear;

 SetLength(UsefulOpt, 0);
 SetLength(bOptions, 0);

 fMD5Sign.Free;
 fMD5SignFile.Free;
 fCRC32Sign.Free;
 fCRC32SignFile.Free;
 //fSHA256Sign.Free;

 //ClearListASMWordFinder;
 ClearCommentDataList;

 CplBItems.Clear;
 CplBItems.Free;
end;

procedure TMain.FormDropFiles(Sender: TObject; const FileNames: array of String);
 Var Ind : Integer;
begin
 For Ind := 0 To Length(FileNames) - 1 Do
  NewEditorTab(FileNames[Ind]);
end;

procedure TMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
 Var RelIndex : Integer;
     Tmp : TForm;
begin
 If Shift = [] Then
  If Key = VK_F12 Then
   If Self.Menu = Nil Then
    Begin
     miMicroModeClick(Sender);

     Key := 0;
    end;

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If Shift = [ssShift, ssAlt] Then
     If Key In [VK_F1..VK_F12] Then
      Begin
       RelIndex := Key - VK_F1;

       If ExtToolsArray[RelIndex] <> -1 Then
        Execute_External_Tool(RelIndex, (Tmp As TEditor).FileInEditing, '')
       Else
        ShowMessage('Shortcut to external tool not defined!');
      end;

    If Shift = [ssCtrl, ssShift] Then
     If Key In [VK_F1..VK_F12] Then
      Begin
       RelIndex := (Key - VK_F1) + 12;

       If ExtToolsArray[RelIndex] <> -1 Then
        Execute_External_Tool(RelIndex, (Tmp As TEditor).FileInEditing, '')
       Else
        ShowMessage('Shortcut to external tool not defined!');
      end;
   end;
end;

procedure TMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 If Shift = [ssAlt, ssShift] Then
  Begin
   If Button = mbLeft Then
    Begin
     MouseIsDown := True;

     mPx := X;
     mPy := Y;
    end;
  end;
end;

procedure TMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
 If MouseIsDown Then
  SetBounds(Left + (X - mPx), Top + (Y - mPy), Width, Height);
end;

procedure TMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 MouseIsDown := False;
end;

procedure TMain.FormShow(Sender: TObject);
 Var I : Integer;
begin
 If FirstShow Then
  Begin
   FirstShow := False;

   If UsefulOpt[0] Then
    RestoreWindowPos;

   FileHistory.UpdateParentMenu;

   BuildFileDialogFilter;

   If Not UsefulOpt[3] Then
    NewEditorTab('')
   Else
    For I := 0 To FileHistory.Count - 1 Do
     NewEditorTab(FileHistory.GetItemValue(I));

   If ParamCount > 0 Then
    Begin
     For I := 1 To ParamCount Do
      If FileExists(ParamStr(I)) Then
       NewEditorTab(ParamStr(I));
    end;

   //Enable clipboard panel
   If Length(bOptions) > 9 Then
    If bOptions[9] Then
     miViewClipboardPanelClick(Nil);

   //Enable micro editor mode
   If Length(bOptions) > 11 Then
    If bOptions[11] Then
     miMicroModeClick(Nil);

   //lbClipboard.Clear;
   //lbClipboard.Items.Append(Clipboard.AsText);
   InsertIntoClipboardPanel(Clipboard.AsText);

   BuildDocumentTabsMenu;
  end;
end;

procedure TMain.gbClipboardPanelResize(Sender: TObject);
begin
 PopulateClipBoardPanel;
end;

procedure TMain.lbClipboardDblClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If lbClipboard.Items.Count = 0 Then
  Exit;

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    //(Tmp As TEditor).sEdit.InsertTextAtCaret(lbClipboard.GetSelectedText);
    (Tmp As TEditor).sEdit.InsertTextAtCaret(GetSelectedFromClipboardPanel);

    Self.ActiveControl := Nil;

    PageDock.SetFocus;
    ActiveControl := (Tmp As TEditor).sEdit;
    ActiveControl.SetFocus;
   end;
end;

procedure TMain.lbClipboardShowHint(Sender: TObject; HintInfo: PHintInfo);
begin
 If lbClipboard.ItemIndex > -1 Then
  Begin
   HintInfo^.HintMaxWidth := 400;
   HintInfo^.HintStr := CplBItems.Strings[lbClipboard.ItemIndex];
  end;
end;

procedure TMain.MenuItem100Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    fBaseConverter := TfBaseConverter.Create(Self);
    fBaseConverter.WorkSyn := (Tmp As TEditor).sEdit;

    fBaseConverter.ShowModal;

    fBaseConverter.Free;
   end;
end;

procedure TMain.MenuItem102Click(Sender: TObject);
begin
 fSetExtTools := TfSetExtTools.Create(Self);
 fSetExtTools.ShowModal;
 fSetExtTools.Free;
end;

procedure TMain.MenuItem103Click(Sender: TObject);
 Var L : TStringList;
begin
 If ClipBoard.AsText <> '' Then
  Begin
   L := TStringList.Create;
   L.Text := ClipBoard.AsText;

   SaveFile.DefaultExt := '.txt';
   SaveFile.Filter := 'Text File|*.txt|All Files|*.*';

   If SaveFile.Execute Then
    L.SaveToFile(SaveFile.FileName);

   L.Free;
  end;
end;

procedure TMain.MenuItem105Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.Text <> '' Then
     Begin
      (Tmp As TEditor).sEdit.BeginUpdate(True);

      If (Tmp As TEditor).sEdit.SelText = '' Then
       (Tmp As TEditor).sEdit.SelectAll;

      (Tmp As TEditor).sEdit.CommandProcessor(TSynEditorCommand(ecBlockIndent), ' ', Nil);

      (Tmp As TEditor).sEdit.EndUpdate;
     end;
   end;
end;

procedure TMain.MenuItem106Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.Text <> '' Then
     Begin
      (Tmp As TEditor).sEdit.BeginUpdate(True);

      If (Tmp As TEditor).sEdit.SelText = '' Then
       (Tmp As TEditor).sEdit.SelectAll;

      (Tmp As TEditor).sEdit.CommandProcessor(TSynEditorCommand(ecBlockUnindent), ' ', Nil);

      (Tmp As TEditor).sEdit.EndUpdate;
     end;
   end;
end;

procedure TMain.MenuItem108Click(Sender: TObject);
 Var Tmp : TForm;
     OldI, S, NewI : String;
     Ln1, Ln2, Ind : Integer;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.Lines.Count = 0 Then
     Exit;

    If (Tmp As TEditor).sEdit.SelText = '' Then
     Begin
      ShowMessage('You must select a part of document!');

      Exit;
     end;

    (Tmp As TEditor).EditorGetSelLines(Ln1, Ln2);

    If Ln2 > (Tmp As TEditor).sEdit.Lines.Count Then
     Ln2 := (Tmp As TEditor).sEdit.Lines.Count;

    Dec(Ln1);

    OldI := SIndentOf((Tmp As TEditor).sEdit.Lines[Ln1]);

    (Tmp As TEditor).sEdit.BeginUpdate(False);

    For Ind := Ln1 To Ln2 - 1 Do
     Begin
      NewI := SIndentOf((Tmp As TEditor).sEdit.Lines[Ind]);

      If NewI <> OldI Then
       Begin
        S := OldI + Copy((Tmp As TEditor).sEdit.Lines[Ind], Length(NewI) + 1, MaxInt);

        (Tmp As TEditor).EditorReplaceLine(Ind + 1, S, True);
       end;
     end;

    (Tmp As TEditor).sEdit.EndUpdate;
   end;
end;

procedure TMain.MenuItem110Click(Sender: TObject);
 Var Tmp : TForm;
     N, NN : Integer;
     S : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.SelText <> '' Then
       Begin
        N := sEdit.SelStart;
        NN := Length(sEdit.SelText);
        S := sEdit.SelText;

        SetSelection(N, 0);

        sEdit.InsertTextAtCaret(S);

        SetSelection(N, NN);
       end
      Else
       Begin
        sEdit.BeginUpdate(False);

        S := sEdit.Lines.Strings[sEdit.CaretY - 1];

        sEdit.CaretX := 0;
        sEdit.InsertTextAtCaret(ReturnLineBreak(UserLineBreak));

        sEdit.CaretX := 0;
        sEdit.CaretY := sEdit.CaretY - 1;

        sEdit.InsertTextAtCaret(S);
        sEdit.Modified := True;

        sEdit.EndUpdate;
       end;
     end;
   end;
end;

procedure TMain.MenuItem113Click(Sender: TObject);
 Var Tmp : TForm;
     Ln1, Ln2, Ind : Integer;
     S : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      If sEdit.SelText <> '' Then
       Begin
        EditorGetSelLines(Ln1, Ln2);

        If Ln2 = Ln1 Then
         Exit;

        S := '';

        For Ind := Ln1 To Ln2 Do
         S := S + sEdit.Lines[Ind - 1] + IfThen(Ind < Ln2, ' ', '');

        sEdit.BeginUpdate(False);

        sEdit.CutToClipboard;

        sEdit.InsertTextAtCaret(S);

        sEdit.EndUpdate;
       end;
     end;
   end;
end;

procedure TMain.MenuItem114Click(Sender: TObject);
 Var Tmp : TForm;
     Ln1, Ln2, Ind : Integer;
     sCR, S : String;
begin
  If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      GotoL := TGotoL.Create(Application);
      GotoL.Caption := 'Split lines';
      GotoL.LineNumber.EditLabel.Caption := 'Right margin';
      GotoL.LineNumber.Caption := IntToStr(sEdit.RightEdge);

      GotoL.ShowModal;

      If GotoL.Ret Then
       Begin
        EditorGetSelLines(Ln1, Ln2);

        If Ln2 < Ln1 Then
         Ln2 := ln1;

        sCR := ReturnLineBreak(GetLineBreak(sEdit.Text));

        sEdit.BeginUpdate(True);

        For Ind := Ln2 Downto Ln1 Do
         Begin
          S := WrapText(sEdit.Lines[Ind - 1], sCR, [' ','+','-',#9], StrToInt(GotoL.LineNumber.Text));

          EditorReplaceLine(Ind, S, True);
         end;

        sEdit.EndUpdate;
       end;

      GotoL.Free;
     end;
   end;
end;

procedure TMain.MenuItem116Click(Sender: TObject);
 Var Tmp : TForm;
     Ln1, Ln2, Ind : Integer;
     S1, S2 : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      EditorGetSelLines(Ln1, Ln2);

      If Ln2 < Ln1 Then
       Ln2 := Ln1;

      If Ln1 > 1 Then
       For Ind := Ln1 To Ln2 Do
        Begin
         S1 := sEdit.Lines.Strings[Ind - 1];
         S2 := sEdit.Lines.Strings[Ind - 2];

         sEdit.BeginUpdate(True);

         EditorReplaceLine(Ind - 1 , S1, True);
         EditorReplaceLine(Ind , S2, True);

         sEdit.EndUpdate;
        end;
     end;
   end;
end;

procedure TMain.MenuItem117Click(Sender: TObject);
 Var Tmp : TForm;
     Ln1, Ln2, Ind : Integer;
     S1, S2 : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      EditorGetSelLines(Ln1, Ln2);

      If Ln2 < Ln1 Then
       Ln2 := Ln1;

      If Ln2 < sEdit.Lines.Count Then
       For Ind := Ln2 DownTo Ln1 Do
        Begin
         S1 := sEdit.Lines.Strings[Ind - 1];
         S2 := sEdit.Lines.Strings[Ind];

         sEdit.BeginUpdate(True);

         EditorReplaceLine(Ind, S2, True);
         EditorReplaceLine(Ind + 1, S1, True);

         sEdit.EndUpdate;
        end;
     end;
   end;
end;

procedure TMain.MenuItem119Click(Sender: TObject);
 Var Tmp : TForm;
     Ln1, Ln2, Ind : Integer;
     lTmp : TStringList;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      If sEdit.SelText <> '' Then
       EditorGetSelLines(Ln1, Ln2)
      Else
       Begin
        Ln1 := 1;
        Ln2 := sEdit.Lines.Count;
       end;

      If Ln2 < Ln1 Then
       Ln2 := Ln1;

      lTmp := TStringList.Create;

      For Ind := Ln1 To Ln2 Do
       lTmp.Add(sEdit.Lines.Strings[Ind - 1]);

      sEdit.BeginUpdate(True);

      For Ind := lTmp.Count - 1 Downto 0 Do
       Begin
        EditorReplaceLine(Ln1, lTmp.Strings[Ind], True);

        Inc(Ln1);
       end;

      sEdit.EndUpdate;

      lTmp.Free;
     end;
   end;
end;

procedure TMain.MenuItem11Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    SavePiNoteFile(Tmp);
   end;
end;

procedure TMain.MenuItem120Click(Sender: TObject);
 Var Tmp : TForm;
     Ln1, Ln2, Ind : Integer;
     lTmp : TStringList;

 Function ShuffleStringList(L: TStringList): Boolean;
  Var Ind, N : Integer;
      LRes : TStringList;
  Begin
   Result := L.Count > 1;
   LRes := TStringList.Create;

   Try
     Randomize;

     For Ind := L.Count - 1 Downto 0 Do
      Begin
       N := Random(L.Count);

       LRes.Add(L.Strings[N]);

       L.Delete(N);
      end;

     L.Assign(LRes);
   finally
     lRes.Free;
   end;
  end;

begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      If sEdit.SelText <> '' Then
       EditorGetSelLines(Ln1, Ln2)
      Else
       Begin
        Ln1 := 1;
        Ln2 := sEdit.Lines.Count;
       end;

      If Ln2 < Ln1 Then
       Ln2 := Ln1;

      lTmp := TStringList.Create;

      For Ind := Ln1 To Ln2 Do
       lTmp.Add(sEdit.Lines.Strings[Ind - 1]);

      ShuffleStringList(lTmp);

      sEdit.BeginUpdate(True);

      For Ind := 0 To lTmp.Count - 1 Do
       Begin
        EditorReplaceLine(Ln1, lTmp.Strings[Ind], True);

        Inc(Ln1);
       End;

      sEdit.EndUpdate;

      lTmp.Free;
     end;
   end;
end;

procedure TMain.MenuItem123Click(Sender: TObject);
 Var Tmp : TForm;
     Ln1, Ln2, Ind : Integer;
     lTmp : TStringList;
     sCR : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      If sEdit.SelText <> '' Then
       EditorGetSelLines(Ln1, Ln2)
      Else
       Begin
        Ln1 := 1;
        Ln2 := sEdit.Lines.Count;
        sEdit.SelectAll;
       end;

      If Ln2 < Ln1 Then
       Ln2 := Ln1;

      sCR := ReturnLineBreak(GetLineBreak(sEdit.Text));

      lTmp := TStringList.Create;

      For Ind := Ln1 To Ln2 Do
       lTmp.Add(sEdit.Lines.Strings[Ind - 1]);

      For Ind := lTmp.Count - 1 DownTo 1 Do
       If (Trim(lTmp.Strings[Ind]) = '') And (Trim(lTmp.Strings[Ind - 1]) = '') Then
        lTmp.Delete(Ind);

      sEdit.BeginUpdate(True);

      sEdit.CutToClipboard;

      For Ind := 0 To lTmp.Count - 1 Do
       Begin
        sEdit.CaretXY := Point(0, Ln1);

        If Ind <> lTmp.Count - 1 Then
         sEdit.InsertTextAtCaret(lTmp.Strings[Ind] + sCR)
        Else
         sEdit.InsertTextAtCaret(lTmp.Strings[Ind]);

        Inc(Ln1);
       End;

      sEdit.EndUpdate;

      lTmp.Free;
     end;
   end;
end;

procedure TMain.MenuItem125Click(Sender: TObject);
 Var Tmp : TForm;
     Ln1, Ln2, Ind : Integer;
     lTmp : TStringList;
     sCR : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      If sEdit.SelText <> '' Then
       EditorGetSelLines(Ln1, Ln2)
      Else
       Begin
        Ln1 := 1;
        Ln2 := sEdit.Lines.Count;
        sEdit.SelectAll;
       end;

      If Ln2 < Ln1 Then
       Ln2 := Ln1;

      sCR := ReturnLineBreak(GetLineBreak(sEdit.Text));

      lTmp := TStringList.Create;

      For Ind := Ln1 To Ln2 Do
       lTmp.Add(sEdit.Lines.Strings[Ind - 1]);

      For Ind := 0 To lTmp.Count - 1 Do
       lTmp.Strings[Ind] := TrimLeft(lTmp.Strings[Ind]);

      sEdit.BeginUpdate(True);

      sEdit.CutToClipboard;

      For Ind := 0 To lTmp.Count - 1 Do
       Begin
        sEdit.CaretXY := Point(0, Ln1);

        If Ind <> lTmp.Count - 1 Then
         sEdit.InsertTextAtCaret(lTmp.Strings[Ind] + sCR)
        Else
         sEdit.InsertTextAtCaret(lTmp.Strings[Ind]);

        Inc(Ln1);
       end;

      sEdit.EndUpdate;

      lTmp.Free;
     end;
   end;
end;

procedure TMain.MenuItem126Click(Sender: TObject);
 Var Tmp : TForm;
     Ln1, Ln2, Ind : Integer;
     lTmp : TStringList;
     sCR : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      If sEdit.SelText <> '' Then
       EditorGetSelLines(Ln1, Ln2)
      Else
       Begin
        Ln1 := 1;
        Ln2 := sEdit.Lines.Count;
        sEdit.SelectAll;
       end;

      If Ln2 < Ln1 Then
       Ln2 := Ln1;

      sCR := ReturnLineBreak(GetLineBreak(sEdit.Text));

      lTmp := TStringList.Create;

      For Ind := Ln1 To Ln2 Do
       lTmp.Add(sEdit.Lines.Strings[Ind - 1]);

      For Ind := 0 To lTmp.Count - 1 Do
       lTmp.Strings[Ind] := TrimRight(lTmp.Strings[Ind]);

      sEdit.BeginUpdate(True);

      sEdit.CutToClipboard;

      For Ind := 0 To lTmp.Count - 1 Do
       Begin
        sEdit.CaretXY := Point(0, Ln1);

        If Ind <> lTmp.Count - 1 Then
         sEdit.InsertTextAtCaret(lTmp.Strings[Ind] + sCR)
        Else
         sEdit.InsertTextAtCaret(lTmp.Strings[Ind]);

        Inc(Ln1);
       end;

      sEdit.EndUpdate;

      lTmp.Free;
     end;
   end;
end;

procedure TMain.MenuItem127Click(Sender: TObject);
 Var Tmp : TForm;
     Ln1, Ln2, Ind : Integer;
     lTmp : TStringList;
     sCR : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      If sEdit.SelText <> '' Then
       EditorGetSelLines(Ln1, Ln2)
      Else
       Begin
        Ln1 := 1;
        Ln2 := sEdit.Lines.Count;
        sEdit.SelectAll;
       end;

      sCR := ReturnLineBreak(GetLineBreak(sEdit.Text));

      lTmp := TStringList.Create;

      For Ind := Ln1 To Ln2 Do
       lTmp.Add(sEdit.Lines.Strings[Ind - 1]);

      For Ind := 0 To lTmp.Count - 1 Do
       lTmp.Strings[Ind] := TrimLeft(TrimRight(lTmp.Strings[Ind]));

      sEdit.BeginUpdate(True);

      sEdit.CutToClipboard;

      For Ind := 0 To lTmp.Count - 1 Do
       Begin
        sEdit.CaretXY := Point(0, Ln1);

        If Ind <> lTmp.Count - 1 Then
         sEdit.InsertTextAtCaret(lTmp.Strings[Ind] + sCR)
        Else
         sEdit.InsertTextAtCaret(lTmp.Strings[Ind]);

        Inc(Ln1);
       end;

      sEdit.EndUpdate;

      lTmp.Free;
     end;
   end;
end;

procedure TMain.MenuItem128Click(Sender: TObject);
 Var Tmp : TForm;
     Ln1, Ln2, Ind : Integer;
     lTmp : TStringList;
     sCR, sTmp : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      If sEdit.SelText <> '' Then
       EditorGetSelLines(Ln1, Ln2)
      Else
       Begin
        Ln1 := 1;
        Ln2 := sEdit.Lines.Count;
        sEdit.SelectAll;
       end;

      sCR := ReturnLineBreak(GetLineBreak(sEdit.Text));

      lTmp := TStringList.Create;

      For Ind := Ln1 To Ln2 Do
       lTmp.Add(sEdit.Lines.Strings[Ind - 1]);

      For Ind := 0 To lTmp.Count - 1 Do
       Begin
        sTmp := lTmp.Strings[Ind];

        sTmp := StringReplace(sTmp, '  ', ' ', [rfReplaceAll]);
        sTmp := StringReplace(sTmp, #9#9, #9, [rfReplaceAll]);
        sTmp := StringReplace(sTmp, #9' ', #9, [rfReplaceAll]);
        sTmp := StringReplace(sTmp, ' '#9, ' ', [rfReplaceAll]);

        lTmp.Strings[Ind] := sTmp;
       end;

      sEdit.BeginUpdate(True);

      sEdit.CutToClipboard;

      For Ind := 0 To lTmp.Count - 1 Do
       Begin
        sEdit.CaretXY := Point(0, Ln1);

        If Ind <> lTmp.Count - 1 Then
         sEdit.InsertTextAtCaret(lTmp.Strings[Ind] + sCR)
        Else
         sEdit.InsertTextAtCaret(lTmp.Strings[Ind]);

        Inc(Ln1);
       end;

      sEdit.EndUpdate;

      lTmp.Free;
     end;
   end;
end;

procedure TMain.MenuItem12Click(Sender: TObject);
 Var Tmp : TForm;
     sDefFil : String;
     DotPos, CommaPos : Integer;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.Highlighter = Nil Then
     Begin
      SaveFile.DefaultExt := '.txt';
      SaveFile.Filter := 'Text File|*.txt|All Files|*.*';
     end
    Else
     SaveFile.Filter := (Tmp As TEditor).sEdit.Highlighter.DefaultFilter + '|All Files|*.*';

    SaveFile.InitialDir := ExtractFilePath((Tmp As TEditor).FileInEditing);
    SaveFile.FileName := ExtractFileName((Tmp As TEditor).FileInEditing);
    SaveFile.DefaultExt := ExtractFileExt((Tmp As TEditor).FileInEditing);

    If SaveFile.DefaultExt = '' Then
     Begin
      sDefFil := SaveFile.Filter;
      DotPos := Pos('.', sDefFil);
      CommaPos := Pos(',', sDefFil);

      SaveFile.DefaultExt := Copy(sDefFil, DotPos, CommaPos - DotPos);
     end;

    If SaveFile.Execute Then
     Begin
      (Tmp As TEditor).FileInEditing := SaveFile.FileName;

      (Tmp As TEditor).SaveText;

      FileHistory.UpdateList(SaveFile.FileName);
     end;
   end;
end;

procedure TMain.MenuItem130Click(Sender: TObject);
 Var Tmp : TForm;
     Ln1, Ln2, Ind, DimRG : Integer;
     S : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      If sEdit.SelText <> '' Then
       EditorGetSelLines(Ln1, Ln2)
      Else
       Begin
        Ln1 := 1;
        Ln2 := sEdit.Lines.Count;
        sEdit.SelectAll;
       end;

      If Ln2 < Ln1 Then
       Ln2 := Ln1;

      sEdit.BeginUpdate(True);

      DimRG := sEdit.RightEdge;

      If DimRG < 0 Then
       DimRG := 80;

      For Ind := Ln1 To Ln2 Do
       Begin
        S := Trim(sEdit.Lines.Strings[Ind - 1]);

        If Length(S) < DimRG Then
         Begin
          S := StringOfChar(' ', (DimRG - Length(S)) Div 2) + S;

          EditorReplaceLine(Ind, S, True);
         end;
       end;

      sEdit.EndUpdate;
     end;
   end;
end;

procedure TMain.MenuItem132Click(Sender: TObject);
 Var Tmp : TForm;
     Ln1, Ln2 : Integer;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      If sEdit.SelText = '' Then
       sEdit.SelectAll;

      EditorGetSelLines(Ln1, Ln2);

      fInsNumbering := TfInsNumbering.Create(Application);
      fInsNumbering.Editor := sEdit;
      fInsNumbering.StartLine := Ln1;
      fInsNumbering.EndLine := Ln2;

      fInsNumbering.ShowModal;

      fInsNumbering.Free;
     end;
   end;
end;

procedure TMain.MenuItem133Click(Sender: TObject);
begin
 If FindDialog.FindText <> '' Then
  Begin
   FindDialog.Options := FindDialog.Options + [frEntireScope] - [frDown] - [frFindNext];

   FindDialogFind(Sender);
  End;
end;

procedure TMain.MenuItem134Click(Sender: TObject);
begin
 fSearchIntoFile := TfSearchIntoFile.Create(Self);
 fSearchIntoFile.ShowModal;
 fSearchIntoFile.Free;
end;

procedure TMain.MenuItem138Click(Sender: TObject);
 Var Tmp : TForm;
     Ind : Integer;
     lTmp : TStringList;
     sCR, Buf : String;

 Function InvertCase(S : String) : String;
  Var I : Integer;
 Begin
  Result := S;

  For I := 1 To Length(S) Do
   Begin
    If Result[I] In ['a'..'z'] Then
     Result[I] := UpperCase(Result[I])[1]
    Else
     If Result[I] In ['A'..'Z'] Then
      Result[I] := LowerCase(Result[I]);
   end;
 end;

begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If sEdit.Lines.Count = 0 Then
       Exit;

      If sEdit.SelText = '' Then
       sEdit.SelectAll;

      lTmp := TStringList.Create;

      lTmp.Text := sEdit.SelText;

      For Ind := 0 To lTmp.Count - 1 Do
       lTmp[Ind] := InvertCase(lTmp[Ind]);

      sEdit.BeginUpdate(True);

      sEdit.CutToClipboard;

      sCR := ReturnLineBreak(GetLineBreak(lTmp.Text));

      Buf := Copy(lTmp.Text, 0, (Length(lTmp.Text) - Length(sCR)));

      sEdit.InsertTextAtCaret(Buf);

      sEdit.EndUpdate;

      lTmp.Free;
     end;
   end;
end;

procedure TMain.MenuItem13Click(Sender: TObject);
 Var Ind, OldpIdx : Integer;
begin
 If PageDock.PageCount > 0 Then
  Begin
   OldpIdx := PageDock.ActivePageIndex;

   For Ind := 0 To PageDock.PageCount - 1 Do
    If (PageDock.Pages[Ind] Is TTabForm) Then
     If (PageDock.Pages[Ind] As TTabForm).ParentForm Is TEditor Then
      Begin
       PageDock.ActivePageIndex := Ind;

       MenuItem11Click(Sender);
      end;

   PageDock.ActivePageIndex := OldpIdx;
  end;
end;

procedure TMain.MenuItem141Click(Sender: TObject);
 Var Tmp : TForm;
     T : TStringList;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    SaveFile.Filter := HTMLExp.DefaultFilter;
    SaveFile.DefaultExt := '.HTML';

    If SaveFile.Execute Then
     Begin
      If (Tmp As TEditor).sEdit.Highlighter <> Nil Then
       HTMLExp.Highlighter := (Tmp As TEditor).sEdit.Highlighter;

      HTMLExp.Color := (Tmp As TEditor).sEdit.Color;
      HTMLExp.Title := 'Source file exported to file by PiNote';
      HTMLExp.ExportAsText := True;

      If (Tmp As TEditor).sEdit.SelText = '' Then
       HTMLExp.ExportAll((Tmp As TEditor).sEdit.Lines)
      Else
       Begin
        T := TStringList.Create;
        T.Add((Tmp As TEditor).sEdit.SelText);

        HTMLExp.ExportAll(T);

        T.Free;
       end;

      HTMLExp.SaveToFile(SaveFile.FileName);
     end;
   end;
end;

procedure TMain.MenuItem142Click(Sender: TObject);
 Var Tmp : TForm;
     RTFExp : TRtfSynExport;
     T : TStringList;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    RTFExp := TRtfSynExport.Create(Self);

    SaveFile.Filter := RTFExp.DefaultFilter;
    SaveFile.DefaultExt := '.rtf';

    If SaveFile.Execute Then
     Begin
      If (Tmp As TEditor).sEdit.Highlighter <> Nil Then
       RTFExp.Highlighter := (Tmp As TEditor).sEdit.Highlighter
      Else
       RTFExp.Highlighter := TMySEHighlighterEmpty.Create(Nil);

      RTFExp.Color := (Tmp As TEditor).sEdit.Color;
      RTFExp.Title := 'Source file exported to file by PiNote';
      RTFExp.ExportAsText := True;
      RTFExp.UseBackground := True;

      If (Tmp As TEditor).sEdit.SelText = '' Then
       RTFExp.ExportAll((Tmp As TEditor).sEdit.Lines)
      Else
       Begin
        T := TStringList.Create;
        T.Add((Tmp As TEditor).sEdit.SelText);

        RTFExp.ExportAll(T);

        T.Free;
       end;

      RTFExp.SaveToFile(SaveFile.FileName);
     end;

    RTFExp.Free;
   end;
end;

procedure TMain.MenuItem144Click(Sender: TObject);
 Var Tmp : TForm;
     OldSelText : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.SelText <> '' Then
     Begin
      OldSelText := (Tmp As TEditor).sEdit.SelText;

      NewEditorTab('');

      Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

      (Tmp As TEditor).sEdit.Text := OldSelText;
     end;
   end;
end;

procedure TMain.MenuItem145Click(Sender: TObject);
 Var Tmp : TForm;
     OldSelText : TStringList;
     Ind : Integer;
     S, Sc : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.SelText <> '' Then
     Begin
      OldSelText := TStringList.Create;
      OldSelText.Text := (Tmp As TEditor).sEdit.SelText;

      Pass := TPass.Create(Self);
      Pass.PassEdit.EditLabel.Caption := LabelPassEncrypt;

      Pass.ShowModal;

      If Pass.ModalResult = mrOk Then
       Begin
        NewEditorTab('');

        Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

        (Tmp As TEditor).sEdit.Clear;

        For Ind := 0 To OldSelText.Count - 1 Do
         Begin
          S := IntToStr(Ind) + '@' + OldSelText.Strings[Ind];

          Sc := CryptString(Pass.PassEdit.Text, S);

          (Tmp As TEditor).sEdit.Lines.Add(Sc);
         end;
       end;

      OldSelText.Free;
      Pass.Free;
     end;
   end;
end;

procedure TMain.MenuItem146Click(Sender: TObject);
 Var Tmp : TForm;
     OldSelText : TStringList;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.SelText <> '' Then
     Begin
      If (Tmp As TEditor).sEdit.Highlighter = Nil Then
       Begin
        SaveFile.DefaultExt := '.txt';
        SaveFile.Filter := 'Text File|*.txt|All Files|*.*';
       end
      Else
       SaveFile.Filter := (Tmp As TEditor).sEdit.Highlighter.DefaultFilter + '|All Files|*.*';

      If SaveFile.Execute Then
       Begin
        OldSelText := TStringList.Create;

        OldSelText.Text := (Tmp As TEditor).sEdit.SelText;

        OldSelText.SaveToFile(SaveFile.FileName);

        OldSelText.Free;

        NewEditorTab(SaveFile.FileName);
       end;
     end;
   end;
end;

procedure TMain.MenuItem147Click(Sender: TObject);
 Var Tmp : TForm;
     Cry : TStringList;
     Ind : Integer;
     S, Sc : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.Highlighter = Nil Then
     Begin
      SaveFile.DefaultExt := '.txt';
      SaveFile.Filter := 'Text File|*.txt|All Files|*.*';
     end
    Else
     SaveFile.Filter := (Tmp As TEditor).sEdit.Highlighter.DefaultFilter + '|All Files|*.*';

    SaveFile.InitialDir := ExtractFilePath((Tmp As TEditor).FileInEditing);
    SaveFile.FileName := ExtractFileName((Tmp As TEditor).FileInEditing);
    SaveFile.DefaultExt := ExtractFileExt((Tmp As TEditor).FileInEditing);

    If SaveFile.Execute Then
     Begin
      With (Tmp As TEditor).sEdit Do
       Begin
        If Lines.Count > 0 Then
         Begin
          Pass := TPass.Create(Self);
          Pass.PassEdit.EditLabel.Caption := LabelPassEncrypt;

          Pass.ShowModal;

          If Pass.ModalResult = mrOk Then
           Begin
            Cry := TStringList.Create;

            For Ind := 0 To Lines.Count - 1 Do
             Begin
              S := IntToStr(Ind) + '@' + Lines.Strings[Ind];

              Sc := CryptString(Pass.PassEdit.Text, S);

              Cry.Add(Sc);
             end;

            Cry.SaveToFile(SaveFile.FileName);

            Cry.Free;
           end;
         end;

        Pass.Free;
     end;
   end;
 end;
end;

procedure TMain.MenuItem148Click(Sender: TObject);
 Var Cry : TStringList;
     TmpD : TForm;
     Ind : Integer;
     S, Sc : String;
begin
 OpenFile.Options := OpenFile.Options - [ofAllowMultiSelect];

 OpenFile.Title := 'Open encrypted file';

 Try
   If OpenFile.Execute Then
    Begin
     Pass := TPass.Create(Self);
     Pass.PassEdit.EditLabel.Caption := LabelPassDecrypt;

     Pass.ShowModal;

     If Pass.ModalResult = mrOk Then
      Begin
       Cry := TStringList.Create;

       Cry.LoadFromFile(OpenFile.FileName);

       NewEditorTab(OpenFile.FileName);

       TmpD := (PageDock.ActivePage As TTabForm).ParentForm;

       (TmpD As TEditor).sEdit.Clear;

       For Ind := 0 To Cry.Count - 1 Do
        Begin
         S := Cry.Strings[Ind];

         Sc := DeCryptString(Pass.PassEdit.Text, S);

         If Pos('@', Sc) > 0 Then
          Sc := Copy(Sc, Pos('@', Sc) + 1, Length(Sc));

         (TmpD As TEditor).sEdit.Lines.Add(Sc);
        end;

       Cry.Free;

       BuildDocumentTabsMenu;
      end;

     Pass.Free;
    end;
 finally
   OpenFile.Options := OpenFile.Options + [ofAllowMultiSelect];
 end;
end;

procedure TMain.MenuItem150Click(Sender: TObject);
begin
 fMD5Sign.ActiveEditor := Nil;

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   fMD5Sign.ActiveEditor := TEditor((PageDock.ActivePage As TTabForm).ParentForm);

 fMD5Sign.ShowModal;
end;

procedure TMain.MenuItem151Click(Sender: TObject);
begin
 fMD5SignFile.ActiveEditor := Nil;

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   fMD5SignFile.ActiveEditor := TEditor((PageDock.ActivePage As TTabForm).ParentForm);

 fMD5SignFile.ShowModal;
end;

procedure TMain.MenuItem152Click(Sender: TObject);
 Var sClip : String;
     Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.SelText <> '' Then
     Begin
      sClip := MD5Print(MD5String((Tmp As TEditor).sEdit.SelText));

      Clipboard.AsText := sClip;

      If gbClipboardPanel.Visible Then
       InsertIntoClipboardPanel(sClip);
     end;
   end;
end;

procedure TMain.MenuItem154Click(Sender: TObject);
begin
 fCRC32Sign.ActiveEditor := Nil;

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   fCRC32Sign.ActiveEditor := TEditor((PageDock.ActivePage As TTabForm).ParentForm);

 fCRC32Sign.ShowModal;
end;

procedure TMain.MenuItem155Click(Sender: TObject);
begin
 fCRC32SignFile.ActiveEditor := Nil;

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   fCRC32SignFile.ActiveEditor := TEditor((PageDock.ActivePage As TTabForm).ParentForm);

 fCRC32SignFile.ShowModal;
end;

procedure TMain.MenuItem156Click(Sender: TObject);
 Var sClip : String;
     Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.SelText <> '' Then
     Begin
      sClip := IntToHex(CrcString((Tmp As TEditor).sEdit.SelText), 8);

      Clipboard.AsText := sClip;

      If gbClipboardPanel.Visible Then
       InsertIntoClipboardPanel(sClip);
     end;
   end;
end;

procedure TMain.MenuItem157Click(Sender: TObject);
begin
 OpenUrl('https://pinote.sourceforge.io/');
end;

procedure TMain.MenuItem158Click(Sender: TObject);
begin
 fInfo := TfInfo.Create(Self);
 fInfo.ShowModal;
 fInfo.Release;
end;

procedure TMain.MenuItem159Click(Sender: TObject);
begin
 OpenUrl('https://pinote.sourceforge.io/page2.html');
end;

procedure TMain.MenuItem161Click(Sender: TObject);
begin
 fRun := TfRun.Create(Self);
 fRun.ShowModal;
 fRun.Free;
end;

procedure TMain.MenuItem162Click(Sender: TObject);
 Var Tmp : TForm;
     gOut : TGuid;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If CreateGUID(gOut) = 0 Then
     (Tmp As TEditor).sEdit.InsertTextAtCaret(GUIDToString(gOut));
   end;
end;

procedure TMain.MenuItem166Click(Sender: TObject);
 Const lText = '<description>' + LineEnding +
               '' + LineEnding +
               'Copyright (C) <year> <name of author> <contact>' + LineEnding +
               '' + LineEnding +
               'This source is free software; you can redistribute it and/or modify it under' + LineEnding +
               'the terms of the GNU General Public License as published by the Free' + LineEnding +
               'Software Foundation; either version 2 of the License, or (at your option)' + LineEnding +
               'any later version.' + LineEnding +
               '' + LineEnding +
               'This code is distributed in the hope that it will be useful, but WITHOUT ANY' + LineEnding +
               'WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS' + LineEnding +
               'FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more' + LineEnding +
               'details.' + LineEnding +
               '' + LineEnding +
               'A copy of the GNU General Public License is available on the World Wide Web' + LineEnding +
               'at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing' + LineEnding +
               'to the Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,' + LineEnding +
               'Boston, MA 02110-1335, USA.' + LineEnding +
               '';

 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).InsertComment(lText, True);
   end;
end;

procedure TMain.MenuItem167Click(Sender: TObject);
 Const lText = '<description>' + LineEnding +
               '' + LineEnding +
               'Copyright (C) <year> <name of author> <contact>' + LineEnding +
               '' + LineEnding +
               'This library is free software; you can redistribute it and/or modify it' + LineEnding +
               'under the terms of the GNU Library General Public License as published by' + LineEnding +
               'the Free Software Foundation; either version 2 of the License, or (at your' + LineEnding +
               'option) any later version.' + LineEnding +
               '' + LineEnding +
               'This program is distributed in the hope that it will be useful, but WITHOUT' + LineEnding +
               'ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or' + LineEnding +
               'FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License' + LineEnding +
               'for more details.' + LineEnding +
               '' + LineEnding +
               'You should have received a copy of the GNU Library General Public License' + LineEnding +
               'along with this library; if not, write to the Free Software Foundation,' + LineEnding +
               'Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.' + LineEnding +
               '';

 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).InsertComment(lText, True);
   end;
end;

procedure TMain.MenuItem168Click(Sender: TObject);
 Const lText = '<description>' + LineEnding +
               '' + LineEnding +
               'Copyright (C) <year> <name of author> <contact>' + LineEnding +
               '' + LineEnding +
               'This library is free software; you can redistribute it and/or modify it' + LineEnding +
               'under the terms of the GNU Library General Public License as published by' + LineEnding +
               'the Free Software Foundation; either version 2 of the License, or (at your' + LineEnding +
               'option) any later version with the following modification:' + LineEnding +
               '' + LineEnding +
               'As a special exception, the copyright holders of this library give you' + LineEnding +
               'permission to link this library with independent modules to produce an' + LineEnding +
               'executable, regardless of the license terms of these independent modules,and' + LineEnding +
               'to copy and distribute the resulting executable under terms of your choice,' + LineEnding +
               'provided that you also meet, for each linked independent module, the terms' + LineEnding +
               'and conditions of the license of that module. An independent module is a' + LineEnding +
               'module which is not derived from or based on this library. If you modify' + LineEnding +
               'this library, you may extend this exception to your version of the library,' + LineEnding +
               'but you are not obligated to do so. If you do not wish to do so, delete this' + LineEnding +
               'exception statement from your version.' + LineEnding +
               '' + LineEnding +
               'This program is distributed in the hope that it will be useful, but WITHOUT' + LineEnding +
               'ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or' + LineEnding +
               'FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License' + LineEnding +
               'for more details.' + LineEnding +
               '' + LineEnding +
               'You should have received a copy of the GNU Library General Public License' + LineEnding +
               'along with this library; if not, write to the Free Software Foundation,' + LineEnding +
               'Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.' + LineEnding +
               '';

 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).InsertComment(lText, True);
   end;
end;

procedure TMain.MenuItem169Click(Sender: TObject);
 Const lText = '<description>' + LineEnding +
               '' + LineEnding +
               'Copyright (c) <year> <copyright holders>' + LineEnding +
               '' + LineEnding +
               'Permission is hereby granted, free of charge, to any person obtaining a copy' + LineEnding +
               'of this software and associated documentation files (the "Software"), to' + LineEnding +
               'deal in the Software without restriction, including without limitation the' + LineEnding +
               'rights to use, copy, modify, merge, publish, distribute, sublicense, and/or' + LineEnding +
               'sell copies of the Software, and to permit persons to whom the Software is' + LineEnding +
               'furnished to do so, subject to the following conditions:' + LineEnding +
               '' + LineEnding +
               'The above copyright notice and this permission notice shall be included in' + LineEnding +
               'all copies or substantial portions of the Software.' + LineEnding +
               '' + LineEnding +
               'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR' + LineEnding +
               'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,' + LineEnding +
               'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE' + LineEnding +
               'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER' + LineEnding +
               'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING' + LineEnding +
               'FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS' + LineEnding +
               'IN THE SOFTWARE.' + LineEnding +
               '';

 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).InsertComment(lText, True);
   end;
end;

procedure TMain.MenuItem170Click(Sender: TObject);
 Var Tmp : TForm;
     Print : TMySEPrint;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If PrintDialog.Execute Then
     Begin
      Print := TMySEPrint.Create(Self);

      Print.SynEdit := (Tmp As TEditor).sEdit;
      Print.Highlighter := (Tmp As TEditor).sEdit.Highlighter;
      Print.Colors := False;
      Print.Title := ExtractFileName((Tmp As TEditor).FileInEditing);
      Print.Font := (Tmp As TEditor).sEdit.Font;
      Print.Font.Color := clBlack;

      Print.LineNumbers := miViewLineNumbers.Checked;

      If Assigned(Print.Highlighter) Then
       Print.Highlight := True;

      Print.Print;

      Print.Free;
     end;
   end;
end;

procedure TMain.MenuItem171Click(Sender: TObject);
 Var Print : TMySEPrint;
     Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    Print := TMySEPrint.Create(Self);

    Print.SynEdit := (Tmp As TEditor).sEdit;
    Print.Highlighter := (Tmp As TEditor).sEdit.Highlighter;
    Print.Colors := False;
    Print.Title := ExtractFileName((Tmp As TEditor).FileInEditing);
    Print.Font := (Tmp As TEditor).sEdit.Font;
    Print.Font.Color := clBlack;

    If Assigned(Print.Highlighter) Then
     Print.Highlight := True;

    fPrintPreview := TfPrintPreview.Create(Self);
    fPrintPreview.Preview.SynEditPrint := Print;
    fPrintPreview.Preview.SynEditPrint.Font := Print.Font;

    fPrintPreview.Preview.SynEditPrint.LineNumbers := miViewLineNumbers.Checked;

    fPrintPreview.ShowModal;

    fPrintPreview.Free;
    Print.Free;
   end;
end;

procedure TMain.MenuItem173Click(Sender: TObject);
 Var Ind, ActivePageIdx : Integer;
     UnSaved : TStringList;
     SaveBeforeClose : Boolean;
     QueryResult : Word;
begin
 ActivePageIdx := -1;

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   ActivePageIdx := PageDock.ActivePage.PageIndex;

 If ActivePageIdx < 0 Then
  Exit;

 UnSaved := ListOfModifiedDocuments(-1, -1, ActivePageIdx);
 SaveBeforeClose := False;
 QueryResult := 0;

 If UnSaved.Count > 0 Then
  Begin
   fQueryEditedFiles := TfQueryEditedFiles.Create(Self);
   fQueryEditedFiles.lbEditedDoc.Items.Assign(UnSaved);

   fQueryEditedFiles.ShowModal;

   QueryResult := fQueryEditedFiles.ResultType;

   fQueryEditedFiles.Free;
  end;

 If QueryResult = 2 Then
  Begin
   UnSaved.Free;

   Exit;
  end;

 SaveBeforeClose := QueryResult = 1;

 For Ind := PageDock.PageCount - 1 DownTo 0 Do
  If (PageDock.Pages[Ind] Is TTabForm) Then
   If (PageDock.Pages[Ind] As TTabForm).ParentForm Is TEditor Then
    Begin
     If Ind = ActivePageIdx Then
      Continue;

     If SaveBeforeClose Then
      Begin
       PageDock.ActivePageIndex := Ind;

       MenuItem11Click(Sender);
      end;

     (PageDock.Pages[Ind] As TTabForm).Free;
    end;


 UnSaved.Free;

 BuildDocumentTabsMenu;
end;

procedure TMain.MenuItem174Click(Sender: TObject);
 Var Ind, ActivePageIdx : Integer;
     UnSaved : TStringList;
     SaveBeforeClose : Boolean;
     QueryResult : Word;
begin
 ActivePageIdx := -1;

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   ActivePageIdx := PageDock.ActivePage.PageIndex;

 If ActivePageIdx < 0 Then
  Exit;

 UnSaved := ListOfModifiedDocuments(0, ActivePageIdx - 1);
 SaveBeforeClose := False;
 QueryResult := 0;

 If UnSaved.Count > 0 Then
  Begin
   fQueryEditedFiles := TfQueryEditedFiles.Create(Self);
   fQueryEditedFiles.lbEditedDoc.Items.Assign(UnSaved);

   fQueryEditedFiles.ShowModal;

   QueryResult := fQueryEditedFiles.ResultType;

   fQueryEditedFiles.Free;
  end;

 If QueryResult = 2 Then
  Begin
   UnSaved.Free;

   Exit;
  end;

 SaveBeforeClose := QueryResult = 1;

 For Ind := ActivePageIdx - 1 DownTo 0 Do
  If (PageDock.Pages[Ind] Is TTabForm) Then
   If (PageDock.Pages[Ind] As TTabForm).ParentForm Is TEditor Then
    Begin
     If SaveBeforeClose Then
      Begin
       PageDock.ActivePageIndex := Ind;

       MenuItem11Click(Sender);
      end;

     (PageDock.Pages[Ind] As TTabForm).Free;
    end;


 UnSaved.Free;

 BuildDocumentTabsMenu;
end;

procedure TMain.MenuItem175Click(Sender: TObject);
 Var Ind, ActivePageIdx : Integer;
     UnSaved : TStringList;
     SaveBeforeClose : Boolean;
     QueryResult : Word;
begin
 ActivePageIdx := -1;

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   ActivePageIdx := PageDock.ActivePage.PageIndex;

 If ActivePageIdx < 0 Then
  Exit;

 UnSaved := ListOfModifiedDocuments(ActivePageIdx + 1, PageDock.PageCount - 1);
 SaveBeforeClose := False;
 QueryResult := 0;

 If UnSaved.Count > 0 Then
  Begin
   fQueryEditedFiles := TfQueryEditedFiles.Create(Self);
   fQueryEditedFiles.lbEditedDoc.Items.Assign(UnSaved);

   fQueryEditedFiles.ShowModal;

   QueryResult := fQueryEditedFiles.ResultType;

   fQueryEditedFiles.Free;
  end;

 If QueryResult = 2 Then
  Begin
   UnSaved.Free;

   Exit;
  end;

 SaveBeforeClose := QueryResult = 1;

 For Ind := PageDock.PageCount - 1 DownTo ActivePageIdx + 1 Do
  If (PageDock.Pages[Ind] Is TTabForm) Then
   If (PageDock.Pages[Ind] As TTabForm).ParentForm Is TEditor Then
    Begin
     If SaveBeforeClose Then
      Begin
       PageDock.ActivePageIndex := Ind;

       MenuItem11Click(Sender);
      end;

     (PageDock.Pages[Ind] As TTabForm).Free;
    end;


 UnSaved.Free;

 BuildDocumentTabsMenu;
end;

procedure TMain.MenuItem176Click(Sender: TObject);
 Var Ind : Integer;
     Tmp : TForm;
begin
 For Ind := PageDock.PageCount - 1 DownTo 0 Do
  If (PageDock.Pages[Ind] Is TTabForm) Then
   If (PageDock.Pages[Ind] As TTabForm).ParentForm Is TEditor Then
    Begin
     Tmp := (PageDock.Pages[Ind] As TTabForm).ParentForm;

     If Not (Tmp As TEditor).sEdit.Modified Then
      (PageDock.Pages[Ind] As TTabForm).Free;
    end;

 BuildDocumentTabsMenu;
end;

procedure TMain.MenuItem177Click(Sender: TObject);
 Var I : Integer;
begin
 If FileHistory = Nil Then
  Exit;

 If FileHistory.Count < 1 Then
  Exit;

 For I := 0 To FileHistory.Count - 1 Do
  NewEditorTab(FileHistory.GetItemValue(I));

 BuildDocumentTabsMenu;
end;

procedure TMain.MenuItem178Click(Sender: TObject);
 Var I : Integer;
begin
 If FileHistory = Nil Then
  Exit;

 If FileHistory.Count < 1 Then
  Exit;

 For I := FileHistory.Count - 1 DownTo 0 Do
  FileHistory.DeleteItem(I);

 FileHistory.UpdateParentMenu;
end;

procedure TMain.MenuItem180Click(Sender: TObject);
 Var Tmp : TForm;
     Ind : Word;
     Find : Boolean;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    Find := False;

    For Ind := 0 To 9 Do
     If (Tmp As TEditor).sEdit.IsBookmark(Ind) = False Then
      Begin
       Find := True;

       Break;
      end;

    If Find Then
     Begin
      (Tmp As TEditor).sEdit.SetBookMark(Ind, (Tmp As TEditor).sEdit.CaretX, (Tmp As TEditor).sEdit.CaretY);

      Load_Bookmark_In_Menu((Tmp As TEditor).sEdit, PageDock.ActivePage);
     end;
   end;
end;

procedure TMain.MenuItem184Click(Sender: TObject);
 Var Ind : Word;
     Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    For Ind := 0 To 9 Do
     (Tmp As TEditor).sEdit.ClearBookMark(Ind);

    Load_Bookmark_In_Menu((Tmp As TEditor).sEdit, PageDock.ActivePage);
   end;
end;

procedure TMain.MenuItem186Click(Sender: TObject);
begin
 lbClipboardDblClick(Sender);
end;

procedure TMain.MenuItem187Click(Sender: TObject);
 Var sVal : String;
begin
 If lbClipboard.Items.Count = 0 Then
  Exit;

 If lbClipboard.ItemIndex > -1 Then
  Begin
   //sVal := lbClipboard.GetSelectedText;
   sVal := GetSelectedFromClipboardPanel;

   Clipboard.AsText := sVal;;
  end;
end;

procedure TMain.MenuItem189Click(Sender: TObject);
begin
 If lbClipboard.Items.Count = 0 Then
  Exit;

 If lbClipboard.ItemIndex > -1 Then
  Begin
   CplBItems.Delete(lbClipboard.ItemIndex);

   PopulateClipBoardPanel;
  end;
end;

procedure TMain.MenuItem190Click(Sender: TObject);
begin
 CplBItems.Clear;
 lbClipboard.Clear;
end;

procedure TMain.MenuItem192Click(Sender: TObject);
begin
 OpenUrl('https://www.paypal.com/donate?hosted_button_id=7NJJK4ZASYY78&source=url');
end;

procedure TMain.MenuItem197Click(Sender: TObject);
begin
 fManageTabs := TfManageTabs.Create(Self);
 fManageTabs.PageDock := PageDock;
 fManageTabs.ShowModal;
 fManageTabs.Free;

 PageDockChange(Sender);
end;

procedure TMain.MenuItem199Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.LineText = '' Then
     Exit;

    (Tmp As TEditor).sEdit.BeginUpdate(True);

    (Tmp As TEditor).sEdit.CommandProcessor(TSynEditorCommand(ecDeleteBOL), ' ', Nil);

    (Tmp As TEditor).sEdit.EndUpdate;
   end;
end;

procedure TMain.MenuItem200Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.LineText = '' Then
     Exit;

    (Tmp As TEditor).sEdit.BeginUpdate(True);

    (Tmp As TEditor).sEdit.CommandProcessor(TSynEditorCommand(ecDeleteEOL), ' ', Nil);

    (Tmp As TEditor).sEdit.EndUpdate;
   end;
end;

procedure TMain.MenuItem201Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.Highlighter <> Nil Then
     HTMLExp.Highlighter := (Tmp As TEditor).sEdit.Highlighter;

    HTMLExp.Color := (Tmp As TEditor).sEdit.Color;
    HTMLExp.ExportAsText := True;
    HTMLExp.Options := [heoFragmentOnly];
    HTMLExp.UseBackground := True;
    HTMLExp.ExportRange((Tmp As TEditor).sEdit.Lines, (Tmp As TEditor).sEdit.BlockBegin,(Tmp As TEditor).sEdit.BlockEnd);

    HTMLExp.CopyToClipboard;
   end;
end;

procedure TMain.MenuItem203Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.CommandProcessor(TSynEditorCommand(ecSelEditorTop), ' ', Nil);
   end;
end;

procedure TMain.MenuItem204Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.CommandProcessor(TSynEditorCommand(ecSelEditorBottom), ' ', Nil);
   end;
end;

procedure TMain.MenuItem205Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.CommandProcessor(TSynEditorCommand(ecSelWordLeft), ' ', Nil);
   end;
end;

procedure TMain.MenuItem206Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.CommandProcessor(TSynEditorCommand(ecSelWordRight), ' ', Nil);
   end;
end;

procedure TMain.MenuItem207Click(Sender: TObject);
 Var Tmp : TForm;
     pSelBegin, pSelEnd : TPoint;
     pEditorBottom, pEditorTop : TPoint;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.BeginUpdate(True);

    pSelBegin := (Tmp As TEditor).sEdit.BlockBegin;
    pSelEnd := (Tmp As TEditor).sEdit.BlockEnd;

    (Tmp As TEditor).sEdit.CommandProcessor(TSynEditorCommand(ecEditorBottom), ' ', Nil);
    pEditorBottom := (Tmp As TEditor).sEdit.CaretXY;

    (Tmp As TEditor).sEdit.CommandProcessor(TSynEditorCommand(ecEditorTop), ' ', Nil);
    pEditorTop := (Tmp As TEditor).sEdit.CaretXY;

    If (pSelEnd <> pEditorBottom) Then
     (Tmp As TEditor).sEdit.TextBetweenPoints[pSelEnd, pEditorBottom] := '';

    If (pEditorTop <> pSelBegin) Then
     (Tmp As TEditor).sEdit.TextBetweenPoints[pEditorTop, pSelBegin] := '';

    (Tmp As TEditor).sEdit.CommandProcessor(TSynEditorCommand(ecEditorBottom), ' ', Nil);

    (Tmp As TEditor).sEdit.EndUpdate;
   end;
end;

procedure TMain.MenuItem208Click(Sender: TObject);
 Var OldActivePage : TTabSheet;
     TmpO, Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    OldActivePage := PageDock.ActivePage;

    NewEditorTab('');

    BuildDocumentTabsMenu;

    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;
    TmpO := (OldActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.Text := (TmpO As TEditor).sEdit.Text;
    (Tmp As TEditor).sEdit.Highlighter := (TmpO As TEditor).sEdit.Highlighter;
    (Tmp As TEditor).SyntaxSchemeID := (TmpO As TEditor).SyntaxSchemeID;

    (Tmp As TEditor).sEdit.Modified := True;
    (Tmp As TEditor).sEditChange(Sender);
    (Tmp As TEditor).UpdateEditor;
   end;
end;

procedure TMain.MenuItem209Click(Sender: TObject);

 Function GetFileSize(fName : String) : LongInt;
  Var F : File Of Byte;
 Begin
  AssignFile(F, fName);
  ReSet(F);

  Result := FileSize(F);

  CloseFile(F);
 end;

 Var Tmp : TForm;
     OutText, sTmp : String;
     fDate : TDateTime;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    fSummary := TfSummary.Create(Self);

    If (Tmp As TEditor).FileInEditing <> '' Then
     OutText := (Tmp As TEditor).FileInEditing + #10#13
    Else
     OutText := 'Document not saved (' + PageDock.ActivePage.Caption + ')';

    fSummary.mfPath.Text := OutText;

    If (Tmp As TEditor).FileInEditing <> '' Then
     OutText := FormatFloat('#,##', GetFileSize((Tmp As TEditor).FileInEditing)) + ' bytes'
    Else
     OutText := 'Document not saved (' + PageDock.ActivePage.Caption + ')';

    fSummary.sFileSize.Caption := OutText;

    If (Tmp As TEditor).FileInEditing <> '' Then
     Begin
      SysUtils.FileAge((Tmp As TEditor).FileInEditing, fDate);

      OutText := DateTimeToStr(fDate);
     end
    Else
     OutText := 'Document not saved (' + PageDock.ActivePage.Caption + ')';

    fSummary.sFileDate.Caption := OutText;

    OutText := FormatFloat('#,##', Length((Tmp As TEditor).sEdit.Text)) + ' with line breaks';

    fSummary.sTextLen1.Caption := OutText;

    Case (Tmp As TEditor).GetLineBreak((Tmp As TEditor).sEdit.Text) Of
     lbWindows   : sTmp := CRLF;
     lbUnix      : sTmp := LF;
     lbMac       : sTmp := CR;
    end;

    OutText := StringReplace((Tmp As TEditor).sEdit.Text, sTmp, '', [rfReplaceAll]);

    OutText := FormatFloat('#,##', Length(OutText));

    If OutText = '' Then
     OutText := '0';

    fSummary.sTextLen2.Caption := OutText + ' without line breaks';

    OutText := FormatFloat('#,##', (Tmp As TEditor).sEdit.Lines.Count);

    If OutText = '' Then
     OutText := '0';

    fSummary.sTextLines.Caption := OutText;

    OutText := FormatFloat('#,##', CountWords((Tmp As TEditor).sEdit.Text));

    If OutText = '' Then
     OutText := '0';

    fSummary.sTotalWords.Caption := OutText;

    fSummary.ShowModal;

    fSummary.Free;
   end;
end;

procedure TMain.MenuItem211Click(Sender: TObject);
begin
 fSHA256Sign.ActiveEditor := Nil;

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   fSHA256Sign.ActiveEditor := TEditor((PageDock.ActivePage As TTabForm).ParentForm);

 fSHA256Sign.ShowModal;
end;

procedure TMain.MenuItem212Click(Sender: TObject);
begin
 fSHA256SignFile.ActiveEditor := Nil;

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   fSHA256SignFile.ActiveEditor := TEditor((PageDock.ActivePage As TTabForm).ParentForm);

 fSHA256SignFile.ShowModal;
end;

procedure TMain.MenuItem213Click(Sender: TObject);
 Var sClip : String;
     Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.SelText <> '' Then
     Begin
      sClip := SHA256String((Tmp As TEditor).sEdit.SelText);

      Clipboard.AsText := sClip;

      If gbClipboardPanel.Visible Then
       InsertIntoClipboardPanel(sClip);
     end;
   end;
end;

procedure TMain.MenuItem214Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).InsertComment(' ', False);
   end;
end;

procedure TMain.MenuItem215Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).InsertComment(' ', True);

    (Tmp As TEditor).sEdit.CaretY := (Tmp As TEditor).sEdit.CaretY - 2;
   end;
end;

procedure TMain.MenuItem216Click(Sender: TObject);
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    fCreateBanner := TfCreateBanner.Create(Self);

    fCreateBanner.ActiveEditor := TEditor((PageDock.ActivePage As TTabForm).ParentForm);

    fCreateBanner.ShowModal;

    fCreateBanner.Free;
   end;
end;

procedure TMain.MenuItem217Click(Sender: TObject);
 Var Tmp : TForm;
     cTxt : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    cTxt := (Tmp As TEditor).FileInEditing;

    Clipboard.Clear;
    Clipboard.AsText := cTxt;

    //lbClipboard.Items.Append(cTxt);
    InsertIntoClipboardPanel(cTxt);
   end;
end;

procedure TMain.MenuItem218Click(Sender: TObject);
 Var Tmp : TForm;
     tTxt : String;
     Ind : Integer;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    tTxt := (Tmp As TEditor).FileInEditing;

    If FileExists(tTxt) Then
     Begin
      tTxt := ExtractFilePath(tTxt);

      OpenFile.Title := 'Open a file to edit...';
      OpenFile.FileName := '';
      OpenFile.Files.Clear;
      OpenFile.InitialDir := tTxt;

      If OpenFile.Execute Then
       Begin
        For Ind := 0 To OpenFile.Files.Count - 1 Do
         NewEditorTab(OpenFile.Files[Ind]);

        BuildDocumentTabsMenu;
       end;
     end;
   end;
end;


procedure TMain.MenuItem219Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    fMultiPaste := TfMultiPaste.Create(Self);
    fMultiPaste.TextLines.Text := Clipboard.AsText;
    fMultiPaste.ActiveEditor := TEditor(Tmp);

    fMultiPaste.ShowModal;

    fMultiPaste.Free;
   end;
end;

procedure TMain.MenuItem220Click(Sender: TObject);
 Const lText = '<description>' + LineEnding +
               '' + LineEnding +
               'Copyright (c) <year> <copyright holders>' + LineEnding +
               '' + LineEnding +
               'Licensed under the Apache License, Version 2.0 (the "License");' + LineEnding +
               'you may not use this file except in compliance with the License.' + LineEnding +
               'You may obtain a copy of the License at' + LineEnding +
               '' + LineEnding +
               '        http://www.apache.org/licenses/LICENSE-2.0' + LineEnding +
               '' + LineEnding +
               'Unless required by applicable law or agreed to in writing, software' + LineEnding +
               'distributed under the License is distributed on an "AS IS" BASIS,' + LineEnding +
               'WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.' + LineEnding +
               'See the License for the specific language governing permissions and' + LineEnding +
               'limitations under the License.' + LineEnding +
               '';

 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).InsertComment(lText, True);
   end;
end;

procedure TMain.MenuItem221Click(Sender: TObject);
 Const lText = '<description>' + LineEnding +
               '' + LineEnding +
               'Copyright (c) <year> <copyright holders>' + LineEnding +
               '' + LineEnding +
               'This Source Code Form is subject to the terms of the Mozilla Public License,' + LineEnding +
               'v. 2.0. If a copy of the MPL was not distributed with this file, You can' + LineEnding +
               'obtain one at http://mozilla.org/MPL/2.0/.' + LineEnding +
               '';

 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).InsertComment(lText, True);
   end;
end;

procedure TMain.miDocSelColumnClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    miDocSelNormal.Checked := False;
    miDocSelLine.Checked := False;
    miDocSelColumn.Checked := True;

    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.SelectionMode := smColumn;
   end;
end;

procedure TMain.miDocSelLineClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    miDocSelNormal.Checked := False;
    miDocSelLine.Checked := True;
    miDocSelColumn.Checked := False;

    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.SelectionMode := smLine;
   end;
end;

procedure TMain.miDocSelNormalClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    miDocSelNormal.Checked := True;
    miDocSelLine.Checked := False;
    miDocSelColumn.Checked := False;

    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.SelectionMode := smNormal;
   end;
end;

procedure TMain.miMicroModeClick(Sender: TObject);
 Var Ind : Integer;
     Tmp : TForm;
begin
 miMicroMode.Checked := Not miMicroMode.Checked;

 If miMicroMode.Checked Then
  Begin
   OldmiStatusBar := miStatusBar.Checked;
   OldmiToolBar := miToolBar.Checked;
   OldmiMenuBar := miMenuBar.Checked;
   OldmiViewClipboardPanel := miViewClipboardPanel.Checked;

   StatusBar.Visible := False;
   ToolBar.Visible := False;
   Self.Menu := Nil;

   SetClipboardPanelState(False);

   PageDock.ShowTabs := False;
   Self.WindowState := wsNormal;

   CopyMenu(MainMenu1, pmMicro);

   For Ind := PageDock.PageCount - 1 DownTo 0 Do
    If (PageDock.Pages[Ind] Is TTabForm) Then
     If (PageDock.Pages[Ind] As TTabForm).ParentForm Is TEditor Then
      Begin
       Tmp := (PageDock.Pages[Ind] As TTabForm).ParentForm;

       (Tmp As TEditor).sEdit.PopupMenu := pmMicro;
      end;
  end
 Else
  Begin
   miStatusBar.Checked := OldmiStatusBar;
   miToolBar.Checked := OldmiToolBar;
   miMenuBar.Checked := OldmiMenuBar;
   miViewClipboardPanel.Checked := OldmiViewClipboardPanel;

   StatusBar.Visible := miStatusBar.Checked;
   ToolBar.Visible := miToolBar.Checked;

   If Not miMenuBar.Checked Then
    Self.Menu := Nil
   Else
    Self.Menu := MainMenu1;

   SetClipboardPanelState(miViewClipboardPanel.Checked);

   PageDock.ShowTabs := True;

   For Ind := PageDock.PageCount - 1 DownTo 0 Do
    If (PageDock.Pages[Ind] Is TTabForm) Then
     If (PageDock.Pages[Ind] As TTabForm).ParentForm Is TEditor Then
      Begin
       Tmp := (PageDock.Pages[Ind] As TTabForm).ParentForm;

       (Tmp As TEditor).sEdit.PopupMenu := (Tmp As TEditor).PopupMenu1;
      end;

   pmMicro.Items.Clear;
  end;
end;

procedure TMain.miOpenWithClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).FileInEditing <> '' Then
     {$IfDef Windows}
     OpenWithDefaultBrowser((Tmp As TEditor).FileInEditing)
     {$else}
     OpenURL('file://' + (Tmp As TEditor).FileInEditing)
     {$endif}
    Else
     ShowMessage('You must to save the file first!');
   end;
end;

procedure TMain.MenuItem163Click(Sender: TObject);
 Var Tmp : TForm;
     StrToSearch : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.SelText <> '' Then
     StrToSearch := (Tmp As TEditor).sEdit.SelText
    Else
     StrToSearch := (Tmp As TEditor).sEdit.LineText;

    OpenURL('https://www.google.com/search?q=' + StrToSearch);
   end;
end;

procedure TMain.MenuItem164Click(Sender: TObject);
 Var Tmp : TForm;
     StrToSearch : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.SelText <> '' Then
     StrToSearch := (Tmp As TEditor).sEdit.SelText
    Else
     StrToSearch := (Tmp As TEditor).sEdit.LineText;

    OpenURL('https://en.wikipedia.org/wiki/Special:Search?search=' + StrToSearch + '&ns0=1');
   end;
end;

procedure TMain.miReadOnlyClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.ReadOnly := Not (Tmp As TEditor).sEdit.ReadOnly;

    miReadOnly.Checked := (Tmp As TEditor).sEdit.ReadOnly;

    (Tmp As TEditor).seMiReadOnly.Checked := miReadOnly.Checked;

    (Tmp As TEditor).ShowInfoOnStatusBar;
   end;
end;

procedure TMain.MenuItem15Click(Sender: TObject);
 Var Tmp : TForm;
     OldFileName : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If ((Tmp As TEditor).FileInEditing <> '') And (FileExists((Tmp As TEditor).FileInEditing)) Then
     Begin
      QueryReload := TQueryReload.Create(Self);

      QueryReload.ShowModal;

      Case QueryReload.ResultType Of
           1             : Begin
                             If SaveFile.Execute Then
                              Begin
                               OldFileName := (Tmp As TEditor).FileInEditing;

                               (Tmp As TEditor).FileInEditing := SaveFile.FileName;

                               (Tmp As TEditor).SaveText;

                               FileHistory.UpdateList(SaveFile.FileName);

                               (Tmp As TEditor).FileInEditing := OldFileName;

                               (Tmp As TEditor).sEdit.Lines.LoadFromFile(OldFileName);

                               (Tmp As TEditor).sEdit.Modified := False;
                              end;
                           end;

           2             : Begin
                            (Tmp As TEditor).sEdit.Lines.LoadFromFile((Tmp As TEditor).FileInEditing);

                            (Tmp As TEditor).sEdit.Modified := False;
                           end;
      end;

      QueryReload.Free;
     end;
   end;
end;

procedure TMain.MenuItem17Click(Sender: TObject);
begin
 Close;
end;

procedure TMain.MenuItem18Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.Undo;
   end;
end;

procedure TMain.MenuItem19Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.Redo;
   end;
end;

procedure TMain.MenuItem21Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.CutToClipboard;
   end;
end;

procedure TMain.MenuItem22Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.CopyToClipboard;
   end;
end;

procedure TMain.MenuItem23Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.PasteFromClipboard;
   end;
end;

procedure TMain.MenuItem26Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.LineText = '' Then
     Exit;

    (Tmp As TEditor).sEdit.BeginUpdate(True);

    (Tmp As TEditor).sEdit.CommandProcessor(TSynEditorCommand(ecDeleteLastWord), ' ', Nil);
    (Tmp As TEditor).sEdit.CommandProcessor(TSynEditorCommand(ecDeleteWord), ' ', Nil);

    (Tmp As TEditor).sEdit.EndUpdate;
   end;
end;

procedure TMain.MenuItem27Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor).sEdit Do
     Begin
      If Lines.Count < 0 Then
       Exit;

      TextBetweenPoints[Classes.Point(1, CaretY), Classes.Point(1, CaretY + 1)] := '';
     end;
   end;
end;

procedure TMain.MenuItem28Click(Sender: TObject);
 Var Tmp : TForm;
     Ind, lCount : Integer;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.BeginUpdate(True);

    With (Tmp As TEditor).sEdit Do
     Begin
      If Lines.Count = 0 Then
       Exit;

      lCount := Lines.Count - 1;

      For Ind := lCount DownTo 0 Do
       If Trim(Lines.Strings[Ind]) = '' Then
        TextBetweenPoints[Classes.Point(1, Ind + 1), Classes.Point(1, Ind + 2)] := '';
     end;

    (Tmp As TEditor).sEdit.EndUpdate;
   end;
end;

procedure TMain.MenuItem30Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.SelectAll;
   end;
end;

procedure TMain.MenuItem33Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.InsertTextAtCaret(DateToStr(Now) + ' ');
   end;
end;

procedure TMain.MenuItem34Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.InsertTextAtCaret(TimeToStr(Now) + ' ');
   end;
end;

procedure TMain.MenuItem35Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.InsertTextAtCaret((Tmp As TEditor).FileInEditing + ' ');
   end;
end;

procedure TMain.MenuItem36Click(Sender: TObject);
 Var Tmp : TForm;
     T : TextFile;
     MyLine : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    OpenFile.Title := 'Open file to insert into document';

    If OpenFile.Execute Then
     Begin
      AssignFile(T, OpenFile.FileName);

      Try
        Reset(T);

        While Not Eof(T) Do
         Begin
          Readln(T, MyLine);

          MyLine := ConvertEncoding(MyLine, 'Ansi', 'UTF-8');

          (Tmp As TEditor).sEdit.InsertTextAtCaret(MyLine + Chr(13));
         end;
      Except
        on E : Exception do
         ShowMessage(E.ClassName+' error raised, with message : '+E.Message);
      end;

      CloseFile(T);
     end;
   end;
end;

procedure TMain.MenuItem38Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor).sEdit Do
     Begin
      SymbForm := TSymbForm.Create(Self);
      SymbForm.FontList.Text := Font.Name;

      SymbForm.ShowModal;

      If SymbForm.Ret Then
       InsertTextAtCaret(SymbForm.SelSym.Text);

      SymbForm.Release;
     end;
   end;
end;

procedure TMain.MenuItem39Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.SelText <> '' Then
     FindDialog.Options := FindDialog.Options - [frEntireScope]
    Else
     FindDialog.Options := FindDialog.Options + [frEntireScope];

    FindDialog.Execute;
   end;
end;

procedure TMain.MenuItem40Click(Sender: TObject);
begin
 If FindDialog.FindText <> '' Then
  Begin
   FindDialog.Options := FindDialog.Options - [frEntireScope] + [frDown] + [frFindNext];

   FindDialogFind(Sender);
  End;
end;

procedure TMain.MenuItem41Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.SelText <> '' Then
     ReplaceDialog.Options := FindDialog.Options - [frEntireScope]
    Else
     ReplaceDialog.Options := FindDialog.Options + [frEntireScope];

    ReplaceDialog.Execute;
   end;
end;

procedure TMain.MenuItem43Click(Sender: TObject);
 Var LastLine : Integer;
     Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor).sEdit Do
     Begin
      LastLine := Lines.Count;

      If LastLine <= 0 Then
       LastLine := 1;

      GotoL := TGotoL.Create(Self);
      GotoL.LineNumber.EditLabel.Caption := 'Line Number (1 - ' + IntToStr(LastLine) + ')';

      GotoL.ShowModal;

      If GotoL.Ret Then
       Begin
        CaretY := StrToInt(GotoL.LineNumber.Caption);

        SelectLine(True);
       end;

      GotoL.Release;
     end;
   end;
end;

procedure TMain.MenuItem45Click(Sender: TObject);
 Var Tmp, TmpD : TForm;
     Ind : Integer;
     S, Sc : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor).sEdit Do
     Begin
      If Lines.Count > 0 Then
       Begin
        Pass := TPass.Create(Self);
        Pass.PassEdit.EditLabel.Caption := LabelPassEncrypt;

        Pass.ShowModal;

        ReadOnly := True;

        If Pass.ModalResult = mrOk Then
         Begin
          MenuItem7Click(Sender);

          TmpD := (PageDock.ActivePage As TTabForm).ParentForm;

          (TmpD As TEditor).sEdit.Clear;

          For Ind := 0 To Lines.Count - 1 Do
           Begin
            S := IntToStr(Ind) + '@' + Lines.Strings[Ind];

            Sc := CryptString(Pass.PassEdit.Text, S);

            (TmpD As TEditor).sEdit.Lines.Add(Sc);
           end;
         end;

        Pass.Free;
       end;
     end;
   end;
end;

procedure TMain.MenuItem46Click(Sender: TObject);
 Var Tmp, TmpD : TForm;
     Ind : Integer;
     S, Sc : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor).sEdit Do
     Begin
      If Lines.Count > 0 Then
       Begin
        Pass := TPass.Create(Self);
        Pass.PassEdit.EditLabel.Caption := LabelPassDecrypt;

        Pass.ShowModal;

        If Pass.ModalResult = mrOk Then
         Begin
          MenuItem7Click(Sender);

          TmpD := (PageDock.ActivePage As TTabForm).ParentForm;

          (TmpD As TEditor).sEdit.Clear;

          For Ind := 0 To Lines.Count - 1 Do
           Begin
            S := Lines.Strings[Ind];

            Sc := DeCryptString(Pass.PassEdit.Text, S);

            If Pos('@', Sc) > 0 Then
             Sc := Copy(Sc, Pos('@', Sc) + 1, Length(Sc));

            (TmpD As TEditor).sEdit.Lines.Add(Sc);
           end;
         end;

        Pass.Free;
       end;
     end;
   end;
end;

procedure TMain.MenuItem48Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor).sEdit Do
     Begin
      If SelText <> '' Then
       ShowMessage('Words in selected text: ' + IntToStr(CountWords(SelText)))
      Else
       ShowMessage('Words in text: ' + IntToStr(CountWords(Text)));
     end;
   end;
end;

procedure TMain.MenuItem70Click(Sender: TObject);
 Var Tmp : TForm;
     FN : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If SavePic.Execute Then
     Begin
      If ExtractFileExt(SavePic.FileName) = '' Then
       FN := SavePic.FileName + '.' + SavePic.GetFilterExt
      Else
       FN := SavePic.FileName;

      SaveScreenShot((Tmp As TEditor).sEdit , FN, (Tmp As TEditor).sEdit.Canvas);
     end;
   end;
end;

procedure TMain.MenuItem71Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If (Tmp As TEditor).sEdit.Modified Then
     If MessageDlg('Document has been modified. Save changes?', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
      MenuItem11Click(Sender);

    (PageDock.ActivePage As TTabForm).Free;

    BuildDocumentTabsMenu;
   end;
end;

procedure TMain.MenuItem72Click(Sender: TObject);
 Var Ind : Integer;
     UnSaved : TStringList;
     SaveBeforeClose : Boolean;
     QueryResult : Word;
begin
 UnSaved := ListOfModifiedDocuments;
 SaveBeforeClose := False;
 QueryResult := 0;

 If UnSaved.Count > 0 Then
  Begin
   fQueryEditedFiles := TfQueryEditedFiles.Create(Self);
   fQueryEditedFiles.lbEditedDoc.Items.Assign(UnSaved);

   fQueryEditedFiles.ShowModal;

   QueryResult := fQueryEditedFiles.ResultType;

   fQueryEditedFiles.Free;
  end;

 If QueryResult = 2 Then
  Begin
   UnSaved.Free;

   Exit;
  end;

 SaveBeforeClose := QueryResult = 1;

 For Ind := PageDock.PageCount - 1 DownTo 0 Do
  If (PageDock.Pages[Ind] Is TTabForm) Then
   If (PageDock.Pages[Ind] As TTabForm).ParentForm Is TEditor Then
    Begin
     If SaveBeforeClose Then
      Begin
       PageDock.ActivePageIndex := Ind;

       MenuItem11Click(Sender);
      end;

     (PageDock.Pages[Ind] As TTabForm).Free;
    end;

 UnSaved.Free;

 ClearDocumentTabsMenu;
end;

procedure TMain.MenuItem74Click(Sender: TObject);
begin
 fGeneralOpt := TfGeneralOpt.Create(Self);
 fGeneralOpt.ShowModal;
 fGeneralOpt.Free;
end;

procedure TMain.MenuItem76Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.InsertTextAtCaret(CurrEnCoding + ' ');
   end;
end;

procedure TMain.MenuItem77Click(Sender: TObject);
 Var Tmp : TForm;
     Txb, Tyb : Integer;
     Txe, Tye : Integer;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    fHXTag := TfHXTag.Create(Self);

    fHXTag.ShowModal;

    If fHXTag.Ret Then
     Begin
      Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

      If (Tmp As TEditor).sEdit.SelText = '' Then
       (Tmp As TEditor).sEdit.InsertTextAtCaret(fHXTag.leOpening.Text + fHXTag.leClosing.Text)
      Else
       Begin
        Txb := (Tmp As TEditor).sEdit.BlockBegin.x;
        Tyb := (Tmp As TEditor).sEdit.BlockBegin.y;
        Txe := (Tmp As TEditor).sEdit.BlockEnd.x;
        Tye := (Tmp As TEditor).sEdit.BlockEnd.y;

        (Tmp As TEditor).sEdit.CaretX := Txb;
        (Tmp As TEditor).sEdit.CaretY := Tyb;

        If fHXTag.leOpening.Text <> '' Then
         (Tmp As TEditor).sEdit.InsertTextAtCaret(fHXTag.leOpening.Text);

        If Tyb = Tye Then
         Txe := Txe + Length(fHXTag.leOpening.Text);

        (Tmp As TEditor).sEdit.CaretX := Txe;
        (Tmp As TEditor).sEdit.CaretY := Tye;

        If fHXTag.leClosing.Text <> '' Then
         (Tmp As TEditor).sEdit.InsertTextAtCaret(fHXTag.leClosing.Text);
       end;
     end;

    fHXTag.Free;
   end;
end;

procedure TMain.MenuItem78Click(Sender: TObject);
 Var Tmp : TForm;
     cTxt : String;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    cTxt := Clipboard.AsText;

    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    cTxt := cTxt + (Tmp As TEditor).sEdit.SelText;

    Clipboard.Clear;
    Clipboard.AsText := cTxt;

    //lbClipboard.Items.Append(cTxt);
    InsertIntoClipboardPanel(cTxt);
   end;
end;

procedure TMain.MenuItem79Click(Sender: TObject);
begin
 Clipboard.Clear;

 If gbClipboardPanel.Visible Then
  Begin
   lbClipboard.Clear;
   CplBItems.Clear;
  end;
end;

procedure TMain.MenuItem7Click(Sender: TObject);
begin
 NewEditorTab('');

 BuildDocumentTabsMenu;
end;

procedure TMain.MenuItem81Click(Sender: TObject);
 Var Tmp : TForm;
begin
 fSynSchOpt := TfSynSchOpt.Create(Self);

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    fSynSchOpt.UsedSyntaxSchemeID := (Tmp As TEditor).SyntaxSchemeID;
   end;

 fSynSchOpt.ShowModal;
 fSynSchOpt.Free;
end;

procedure TMain.MenuItem84Click(Sender: TObject);
begin
 PrinterSetupDialog.Execute;
end;

procedure TMain.MenuItem85Click(Sender: TObject);
begin
 PageSetupDialog.Execute;
end;

procedure TMain.MenuItem86Click(Sender: TObject);
 Var Tmp : TForm;
     Print : TMySEPrint;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If PrintDialog.Execute Then
     Begin
      Print := TMySEPrint.Create(Self);

      Print.SynEdit := (Tmp As TEditor).sEdit;
      Print.Highlighter := (Tmp As TEditor).sEdit.Highlighter;
      Print.Colors := True;
      Print.Title := ExtractFileName((Tmp As TEditor).FileInEditing);
      Print.Color := MainBackground;
      Print.Font := (Tmp As TEditor).sEdit.Font;

      Print.LineNumbers := miViewLineNumbers.Checked;

      If Assigned(Print.Highlighter) Then
       Print.Highlight := True;

      Print.Print;

      Print.Free;
     end;
   end;
end;

procedure TMain.MenuItem87Click(Sender: TObject);
 Var Print : TMySEPrint;
     Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    Print := TMySEPrint.Create(Self);

    Print.SynEdit := (Tmp As TEditor).sEdit;
    Print.Highlighter := (Tmp As TEditor).sEdit.Highlighter;
    Print.Colors := True;
    Print.Title := ExtractFileName((Tmp As TEditor).FileInEditing);
    Print.Color := MainBackground;
    Print.Font := (Tmp As TEditor).sEdit.Font;

    If Assigned(Print.Highlighter) Then
     Print.Highlight := True;

    fPrintPreview := TfPrintPreview.Create(Self);
    fPrintPreview.Preview.SynEditPrint := Print;
    fPrintPreview.Preview.SynEditPrint.Font := Print.Font;

    fPrintPreview.Preview.SynEditPrint.LineNumbers := miViewLineNumbers.Checked;

    fPrintPreview.ShowModal;

    fPrintPreview.Free;
    Print.Free;
   end;
end;

procedure TMain.MenuItem8Click(Sender: TObject);
 Var Ind : Integer;
begin
 OpenFile.Title := 'Open a file to edit...';

 If OpenFile.Execute Then
  Begin
   For Ind := 0 To OpenFile.Files.Count - 1 Do
    NewEditorTab(OpenFile.Files[Ind]);

   BuildDocumentTabsMenu;
  end;
end;

procedure TMain.MenuItem90Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.Font.Size := (Tmp As TEditor).sEdit.Font.Size + 1;

    (Tmp As TEditor).UpdateRuler;
   End;
end;

procedure TMain.MenuItem91Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.Font.Size := (Tmp As TEditor).sEdit.Font.Size - 1;

    (Tmp As TEditor).UpdateRuler;
   End;
end;

procedure TMain.MenuItem92Click(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).sEdit.Font.Size := PiNoteFontSize;

    (Tmp As TEditor).UpdateRuler;
   End;
end;

procedure TMain.MenuItem93Click(Sender: TObject);
 Var Ind : Integer;
begin
 OpenFile.Title := 'Open a file in exadecimal mode';

 If OpenFile.Execute Then
  Begin
   For Ind := 0 To OpenFile.Files.Count - 1 Do
    NewEditorTab(OpenFile.Files[Ind], True);

   BuildDocumentTabsMenu;
  end;
end;

procedure TMain.MenuItem95Click(Sender: TObject);
 Var Tmp : TForm;
     OldX, OldY : Integer;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    OldX := (Tmp As TEditor).sEdit.CaretX;
    OldY := (Tmp As TEditor).sEdit.CaretY;

    If (Tmp As TEditor).sEdit.SelText = '' Then
     (Tmp As TEditor).sEdit.SelectAll;

    (Tmp As TEditor).sEdit.SelText := LowerCase((Tmp As TEditor).sEdit.SelText);

    (Tmp As TEditor).sEdit.CaretX := OldX;
    (Tmp As TEditor).sEdit.CaretY := OldY;
   End;
end;

procedure TMain.MenuItem96Click(Sender: TObject);
 Var Tmp : TForm;
     OldX, OldY : Integer;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    OldX := (Tmp As TEditor).sEdit.CaretX;
    OldY := (Tmp As TEditor).sEdit.CaretY;

    If (Tmp As TEditor).sEdit.SelText = '' Then
     (Tmp As TEditor).sEdit.SelectAll;

    (Tmp As TEditor).sEdit.SelText := UpperCase((Tmp As TEditor).sEdit.SelText);

    (Tmp As TEditor).sEdit.CaretX := OldX;
    (Tmp As TEditor).sEdit.CaretY := OldY;
   End;
end;

procedure TMain.MenuItem97Click(Sender: TObject);

 function CapitalizeString(S: String): String;
  Var Count : Integer;
 begin
  For Count := 1 To Length(S) Do
   If ((S[Count - 1] = #32) And (S[Count + 1] <> #32)) Or (Count = 1) Or
      (S[Count - 1] = #13) Or (S[Count - 1] = #10) Then
    S[Count] := UpCase(S[Count]);

  Result := S;
 end;

 Var Tmp : TForm;
     OldX, OldY : Integer;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    OldX := (Tmp As TEditor).sEdit.CaretX;
    OldY := (Tmp As TEditor).sEdit.CaretY;

    If (Tmp As TEditor).sEdit.SelText = '' Then
     (Tmp As TEditor).sEdit.SelectAll;

    (Tmp As TEditor).sEdit.SelText := CapitalizeString((Tmp As TEditor).sEdit.SelText);

    (Tmp As TEditor).sEdit.CaretX := OldX;
    (Tmp As TEditor).sEdit.CaretY := OldY;
   End;
end;

procedure TMain.MenuItem98Click(Sender: TObject);

 Function RGB2HTMLColor(Value : TColor): String;
  Var Lo : LongInt;
      tmp, first, second, third : String;
 Begin
  Lo := ColorToRGB(Value);
  tmp := IntToHex(Lo, 6);

  first := Copy(tmp, 1, 2);
  second := Copy(tmp, 3, 2);
  third := Copy(tmp, 5, 2);

  Result := third + second + first;
 end;

 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If ColorDialog.Execute Then
     (Tmp As TEditor).sEdit.InsertTextAtCaret(RGB2HTMLColor(ColorDialog.Color));
   end;
end;

procedure TMain.miAutoCBracketsClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    miAutoCBrackets.Checked := Not miAutoCBrackets.Checked;

    (Tmp As TEditor).AutoCompleteBrackets := miAutoCBrackets.Checked;
   end;
end;

procedure TMain.miClearRMClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      MacroRecorder.Stop;
      MacroRecorder.Clear;

      miStartRM.Enabled := True;
      miStopRM.Enabled := False;
      miPlayRM.Enabled := False;
      miClearRM.Enabled := False;
      miPauseRM.Enabled := False;
      miResumeRM.Enabled := False;
      miSaveRM.Enabled := False;
     end;
   end;
end;

procedure TMain.miFullScreenClick(Sender: TObject);
begin
 miFullScreen.Checked := Not miFullScreen.Checked;

 If miFullScreen.Checked Then
  ShowWindow(Handle, SW_SHOWFULLSCREEN)
 Else
  ShowWindow(Handle, SW_SHOWNORMAL);
end;

procedure TMain.miLBMacClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    UserLineBreak := lbMac;
    (Tmp As TEditor).UserLineBreak := UserLineBreak;

    UpdateLineBreakMenu;
   end;
end;

procedure TMain.miLBUnixClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    UserLineBreak := lbUnix;
    (Tmp As TEditor).UserLineBreak := UserLineBreak;

    UpdateLineBreakMenu;
   end;
end;

procedure TMain.miLBWinClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    UserLineBreak := lbWindows;
    (Tmp As TEditor).UserLineBreak := UserLineBreak;

    UpdateLineBreakMenu;
   end;
end;

procedure TMain.miLoadRMClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      MacroRecorder.Stop;
      MacroRecorder.Clear;

      OpenFile.DefaultExt := '.mcr';
      OpenFile.Filter := 'Macro File|*.mcr|All Files|*.*';

      If OpenFile.Execute Then
       Begin
        MacroRecorder.LoadFromFile(OpenFile.FileName);

        miStartRM.Enabled := True;
        miStopRM.Enabled := False;
        miPlayRM.Enabled := True;
        miCLearRM.Enabled := True;
        miPauseRM.Enabled := False;
        miSaveRM.Enabled := True;
        miResumeRM.Enabled := False;
       end;
     end;
   end;
end;

procedure TMain.miMenuBarClick(Sender: TObject);
begin
 If miMenuBar.Checked Then
  Self.Menu := Nil
 Else
  Self.Menu := MainMenu1;

 miMenuBar.Checked := Not miMenuBar.Checked;
end;

procedure TMain.mInsSSClick(Sender: TObject);
 Var Tmp : TForm;
     SpecCharsOn : Boolean;
     EditOpt : TSynEditorOptions;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor).sEdit Do
     Begin
      SpecCharsOn := Not (eoShowSpecialChars In Options);
      EditOpt := Options;

      If SpecCharsOn Then
       Include(EditOpt, eoShowSpecialChars)
      Else
       Exclude(EditOpt, eoShowSpecialChars);

      Options := EditOpt;

      mInsSS.Checked := SpecCharsOn;
     end;
   end;
end;

procedure TMain.miPauseRMClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      MacroRecorder.Pause;

      miPauseRM.Enabled := False;
      miResumeRM.Enabled := True;
     end;
   end;
end;

procedure TMain.miPlayRMClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).MacroRecorder.PlaybackMacro((Tmp As TEditor).sEdit);
   end;
end;

procedure TMain.miResumeRMClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      MacroRecorder.Resume;

      miPauseRM.Enabled := True;
      miResumeRM.Enabled := False;
     end;
   end;
end;

procedure TMain.miSaveRMClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      If Not MacroRecorder.IsEmpty Then
       Begin
        SaveFile.DefaultExt := '.mcr';
        SaveFile.Filter := 'Macro File|*.mcr|All Files|*.*';

        If SaveFile.Execute Then
         MacroRecorder.SaveToFile(SaveFile.FileName);
       end
      Else
       ShowMessage('No macro recorded...');
     end;
   end;
end;

procedure TMain.miStartRMClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      MacroRecorder.RecordMacro(sEdit);

      miStartRM.Enabled := False;
      miStopRM.Enabled := True;
      miPlayRM.Enabled := False;
      miClearRM.Enabled := False;
      miPauseRM.Enabled := True;
      miResumeRM.Enabled := False;
      miSaveRM.Enabled := True;
     end;
   end;
end;

procedure TMain.miStatusBarClick(Sender: TObject);
begin
 StatusBar.Visible := Not StatusBar.Visible;
 miStatusBar.Checked := StatusBar.Visible;
end;

procedure TMain.miStayOnTopClick(Sender: TObject);
begin
 miStayOnTop.Checked := Not miStayOnTop.Checked;

 If miStayOnTop.Checked Then
  Self.FormStyle := fsStayOnTop
 Else
  Self.FormStyle := fsNormal;
end;

procedure TMain.miStopRMClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor) Do
     Begin
      MacroRecorder.Stop;

      miStartRM.Enabled := True;
      miStopRM.Enabled := False;
      miPlayRM.Enabled := True;
      miClearRM.Enabled := True;
      miPauseRM.Enabled := False;
      miResumeRM.Enabled := False;
      miSaveRM.Enabled := True;
     end;
   end;
end;

procedure TMain.miTansparentModeClick(Sender: TObject);
begin
 miTansparentMode.Checked := Not miTansparentMode.Checked;

 If miTansparentMode.Checked Then
  Begin
   Self.AlphaBlend := True;
   Self.AlphaBlendValue := 196;
  end
 Else
  Self.AlphaBlend := False;
end;

procedure TMain.miToolBarClick(Sender: TObject);
begin
 ToolBar.Visible := Not ToolBar.Visible;
 miToolBar.Checked := ToolBar.Visible;
end;

procedure TMain.miViewClipboardPanelClick(Sender: TObject);
begin
 SetClipboardPanelState(Not miViewClipboardPanel.Checked);
 miViewClipboardPanel.Checked := Not miViewClipboardPanel.Checked;
end;

procedure TMain.miViewLineHighlightClick(Sender: TObject);
 Var Tmp : TForm;
     Ind : Integer;
begin
 miViewLineHighlight.Checked := Not miViewLineHighlight.Checked;

 For Ind := 0 To PageDock.PageCount - 1 Do
  If (PageDock.Pages[Ind] Is TTabForm) Then
   If (PageDock.Pages[Ind] As TTabForm).ParentForm Is TEditor Then
    Begin
     Tmp := (PageDock.Pages[Ind] As TTabForm).ParentForm;

     (Tmp As TEditor).ShowLineHighlight := miViewLineHighlight.Checked;

     (Tmp As TEditor).UpdateEditor;
    end;
end;

procedure TMain.miViewLineNumbersClick(Sender: TObject);
 Var Tmp : TForm;
     Ind : Integer;
begin
 miViewLineNumbers.Checked := Not miViewLineNumbers.Checked;

 //For Ind := PageDock.PageCount - 1 DownTo 0 Do
 For Ind := 0 To PageDock.PageCount - 1 Do
  If (PageDock.Pages[Ind] Is TTabForm) Then
   If (PageDock.Pages[Ind] As TTabForm).ParentForm Is TEditor Then
    Begin
     Tmp := (PageDock.Pages[Ind] As TTabForm).ParentForm;

     (Tmp As TEditor).ShowLineNumber := miViewLineNumbers.Checked;

     (Tmp As TEditor).UpdateEditor;
     (Tmp As TEditor).UpdateRuler;
    end;
end;

procedure TMain.miViewMinimapPanelClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    miViewMinimapPanel.Checked := Not miViewMinimapPanel.Checked;

    (Tmp As TEditor).ShowMiniMap := miViewMinimapPanel.Checked;
   end;
end;

procedure TMain.miViewRightEdgeClick(Sender: TObject);
 Var Tmp : TForm;
     Ind : Integer;
begin
 miViewRightEdge.Checked := Not miViewRightEdge.Checked;

 For Ind := PageDock.PageCount - 1 DownTo 0 Do
  If (PageDock.Pages[Ind] Is TTabForm) Then
   If (PageDock.Pages[Ind] As TTabForm).ParentForm Is TEditor Then
    Begin
     Tmp := (PageDock.Pages[Ind] As TTabForm).ParentForm;

     (Tmp As TEditor).ShowRightEdge := miViewRightEdge.Checked;

     (Tmp As TEditor).UpdateEditor;
    end;
end;

procedure TMain.miViewRulerClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    miViewRuler.Checked := Not miViewRuler.Checked;

    (Tmp As TEditor).Ruler.Visible := miViewRuler.Checked;
   end;
end;

procedure TMain.PageDockChange(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).ShowInfoOnStatusBar;

    UpdateSyntaxSchemeMenu((Tmp As TEditor).SyntaxSchemeID, miSyntaxScheme);

    UserLineBreak := (Tmp As TEditor).UserLineBreak;

    miAutoCBrackets.Checked := (Tmp As TEditor).AutoCompleteBrackets;
    miReadOnly.Checked := (Tmp As TEditor).sEdit.ReadOnly;

    miViewMinimapPanel.Checked := (Tmp As TEditor).ShowMiniMap;
    miViewRuler.Checked := (Tmp As TEditor).Ruler.Visible;

    UpdateLineBreakMenu;

    Load_Bookmark_In_Menu((Tmp As TEditor).sEdit, PageDock.ActivePage);
   end;
end;

procedure TMain.PageDockCloseTabClicked(Sender: TObject);
 Var Tmp : TForm;
begin
 If Sender Is TTabForm Then
  Begin
   Tmp := (Sender As TTabForm).ParentForm;

    If Tmp Is TEditor Then
     Begin
      If (Tmp As TEditor).sEdit.Modified Then
       If MessageDlg('Document has been modified. Save changes?', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
        SavePiNoteFile(Tmp);

      (Sender As TTabForm).Free;

      BuildDocumentTabsMenu;
     end;
  end;
end;

procedure TMain.PageDockDragDrop(Sender, Source: TObject; X, Y: Integer);
 Var I : Integer;
begin
 I := PageDock.IndexOfTabAt(X, Y);

 If I > -1 Then
  PageDock.Pages[PageDock.Tag].PageIndex := I;
end;

procedure TMain.PageDockDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
 If Sender Is TPageControl Then
  Accept := True;
end;

procedure TMain.PageDockMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
 Var I : Integer;
begin
 I := PageDock.IndexOfTabAt(X, Y);

 If (I > -1) And (Button = mbLeft) Then
  Begin
   PageDock.Tag := I;

   PageDock.BeginDrag(False);
  end;
end;

procedure TMain.ReplaceDialogFind(Sender: TObject);
 Var SRec : TSynSearchOptions;
     Tmp : TForm;
begin
 SRec := [];

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor).sEdit Do
     Begin
      If frWholeWord In ReplaceDialog.Options Then
       SRec := SRec + [ssoWholeWord];

      If Not (frDown In ReplaceDialog.Options) Then
       SRec := SRec + [ssoBackwards];

      If frEntireScope In ReplaceDialog.Options Then
       SRec := SRec + [ssoEntireScope]
      Else
       SRec := [ssoPrompt];

      If frMatchCase In ReplaceDialog.Options Then
       SRec := SRec + [ssoMatchCase];

      SearchReplace(ReplaceDialog.FindText, '', SRec);
     end;
   end;
end;

procedure TMain.ReplaceDialogReplace(Sender: TObject);
 Var SRec : TSynSearchOptions;
     Tmp : TForm;
begin
 SRec := [];

 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    With (Tmp As TEditor).sEdit Do
     Begin
      If frWholeWord In ReplaceDialog.Options Then
       SRec := SRec + [ssoWholeWord];

      If Not (frDown In ReplaceDialog.Options) Then
       SRec := SRec + [ssoBackwards];

      If frEntireScope In ReplaceDialog.Options Then
       SRec := SRec + [ssoEntireScope]
      Else
       SRec := [ssoPrompt];

      If frMatchCase In ReplaceDialog.Options Then
       SRec := SRec + [ssoMatchCase];

      If frReplaceAll  In ReplaceDialog.Options Then
       SRec := SRec + [ssoReplaceAll]
      Else
       SRec := SRec  + [ssoReplace];

      SearchReplace(ReplaceDialog.FindText, ReplaceDialog.ReplaceText, SRec);
     end;
   end;
end;

procedure TMain.smConvertEncoding(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If CurrEnCoding <> TMenuItem(Sender).Caption Then
     Begin
      With (Tmp As TEditor).sEdit Do
       Begin
        SelectAll;

        SelText := ConvertEncoding(SelText, CurrEnCoding, TMenuItem(Sender).Caption);

        CurrEnCoding := TMenuItem(Sender).Caption;
        TMenuItem(Sender).Checked := True;

        If OldConvMI <> Nil Then
         OldConvMI.Checked := False;

        OldConvMI := TMenuItem(Sender);
       end;

      (Tmp As TEditor).EdCurrEnCoding := CurrEnCoding;
     end;
   end;
end;

procedure TMain.OnSubMenuSyntaxSchemeClick(Sender: TObject);
 Var Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    (Tmp As TEditor).SyntaxSchemeID := TMenuItem(Sender).Tag;

    (Tmp As TEditor).UpdateEditor;
   end;
end;

procedure TMain.smBookmClick(Sender: TObject);
 Var MenuIdx: String;
     mIdx : Word;
     Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If Pos('(', TMenuItem(Sender).Caption) > 0 Then
     Begin
      MenuIdx := TMenuItem(Sender).Name;
      mIdx := StrToInt(MenuIdx[7]);

      (Tmp As TEditor).sEdit.GotoBookMark(mIdx);

      (Tmp As TEditor).UpdateEditor;
     end;
   end;
end;

procedure TMain.smBookrmClick(Sender: TObject);
 Var MenuIdx: String;
     mIdx : Word;
     Tmp : TForm;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    Tmp := (PageDock.ActivePage As TTabForm).ParentForm;

    If Pos('(', TMenuItem(Sender).Caption) > 0 Then
     Begin
      MenuIdx := TMenuItem(Sender).Name;
      mIdx := StrToInt(MenuIdx[8]);

      (Tmp As TEditor).sEdit.ClearBookMark(mIdx);

      Load_Bookmark_In_Menu((Tmp As TEditor).sEdit, PageDock.ActivePage);
     end;
   end;
end;

procedure TMain.DocumentTabsMenuClick(Sender: TObject);
 Var DocIdx : Integer;
begin
 DocIdx := TMenuItem(Sender).Tag;

 PageDock.ActivePageIndex := DocIdx;

 PageDockChange(Sender);
end;

procedure TMain.NewEditorTab(const FileName: String; OpenAsHex : Boolean = False);
 Var te : TEditor;
begin
 If FileName <> '' Then
  If Not FileExists(FileName) Then
   Exit;

 If UsefulOpt[2] Then
  If IsFileInUse(FileName) Then
   Exit;

 te := TEditor.Create(PageDock);

 If FileName <> '' Then
  Begin
   te.FileInEditing := FileName;

   te.SyntaxSchemeID := GetSyntaxSchemeIDFromFileName(FileName);
  end
 Else
  Begin
   te.NoNameIdx := NewFileIdx;

   If PiNoteDefaultSyntaxScheme <> -1 Then
    te.SyntaxSchemeID := PiNoteDefaultSyntaxScheme;
  end;

 CurrEnCoding := 'UTF-8';
 OldConvMI := MenuItem51;

 te.EdCurrEnCoding := CurrEnCoding;

 te.UserFontName := PiNoteFontInUse;
 te.UserFontSize := PiNoteFontSize;
 te.UserFontStyle := PiNoteFontStyle;
 te.UserTabWidth := PiNoteEditorTabWidth;
 te.UserMaxUndo := PiNoteEditorMaxUndo;
 te.UserRightEdgePos := PiNoteRightEdgePos;
 te.UserFontQuality := PiNoteFontQuality;

 te.ShowLineNumber := miViewLineNumbers.Checked;
 te.ShowRightEdge := miViewRightEdge.Checked;
 te.ShowLineHighlight := miViewLineHighlight.Checked;
 te.OpenFileAsHexadecimal := OpenAsHex;

 If OpenAsHex Then
  te.SyntaxSchemeID := -1;

 UpdateSyntaxSchemeMenu(te.SyntaxSchemeID, miSyntaxScheme);

 te.ShowInfoOnStatusBar;

 te.AutoCompleteBrackets := PiNoteOptions.GetOption(SectionDocument, KeyAutoCB);

 MyEditorSpace.InsertForm(te);

 If FileName <> '' Then
  Begin
   If Not OpenAsHex Then
    FileHistory.UpdateList(FileName);
  end
 Else
  Inc(NewFileIdx);

 te.UpdateEditor;

 UserLineBreak := te.UserLineBreak;
 miReadOnly.Checked := te.sEdit.ReadOnly;

 UpdateLineBreakMenu;

 If miMicroMode.Checked Then
  te.sEdit.PopupMenu := pmMicro;

 //Enable minimap panel from startup options
 If Length(bOptions) > 10 Then
  If bOptions[10] Then
   miViewMinimapPanelClick(Nil);

 //Show ruler
 If Length(bOptions) > 12 Then
  If bOptions[12] Then
   Begin
    te.Ruler.Visible := True;
    miViewRuler.Checked := True;
   end;

 te.sEdit.SetFocus;
end;

function TMain.CryptString(const Key: String; Line: String): String;
 Var Enc : TBlowFishEncryptStream;
     S1 : TStringStream;
begin
 S1 := TStringStream.Create('');
 Enc := TBlowFishEncryptStream.Create(Key, S1);

 Enc.Write(Line[1], Length(Line));

 Enc.Free;

 Result := EncodeStringBase64(S1.DataString);

 S1.Free;
end;

function TMain.DeCryptString(const Key: String; Line: String): String;

 Function DecodeStr64(OrigStr : String) : String;
  Var EncStrm : TStringStream;
      Decoder : TBase64DecodingStream;
      tDc : String;
 Begin
  EncStrm := TStringStream.Create(OrigStr);
  Decoder := TBase64DecodingStream.Create(EncStrm);

  SetLength(tDc, Decoder.Size);

  Decoder.Read(tDc[1], Decoder.Size);

  Result := tDc;

  EncStrm.Free;
  Decoder.Free;
 end;

 Var Dec : TBlowFishDecryptStream;
     S1 : TStringStream;
     Temp, dLine : String;
begin
 dLine := DecodeStr64(Line);

 S1 := TStringStream.Create(dLine);
 Dec := TBlowFishDecryptStream.Create(Key, S1);

 SetLength(Temp, S1.Size);

 Dec.Read(Temp[1], S1.Size);

 Result := Temp;

 Dec.Free;
 S1.Free;
end;

procedure TMain.SaveScreenShot(SE: TSynEdit; FileName: String;
  OrigCanvas: TCanvas);
 Var B : TBitmap;
     J : TJPEGImage;
     Png : TPortableNetworkGraphic;
     srcRect, dstRect : TRect;
     wWidth, wHeigh, wLeft, wTop : Integer;
     TmpSB : TScrollStyle;
begin
 SE.BeginUpdate(False);

 TmpSB := SE.ScrollBars;
 SE.ScrollBars := ssNone;

 B := Graphics.TBitmap.Create;

 wWidth := SE.Width;
 wHeigh := SE.Height;
 wLeft := SE.Left;
 wTop := SE.Top;

 B.SetSize(wWidth, wHeigh);

 With dstRect Do
  Begin
   Left := 0;
   Top := 0;
   Right := wWidth + 1;
   Bottom := wHeigh + 1;
  End;

 With srcRect Do
  Begin
   Left := wLeft;
   Right := wLeft + wWidth;
   Top := wTop;
   Bottom := wTop + wHeigh;
  End;

 B.Canvas.CopyRect(dstRect, OrigCanvas, srcRect);

 If ExtractFileExt(FileName) = '.jpg' Then
  Begin
   J := TJPEGImage.Create;
   J.Transparent := False;

   J.Assign(B);

   J.SaveToFile(FileName);

   J.Free;
  end
 Else
  If ExtractFileExt(FileName) = '.png' Then
   Begin
    Png := TPortableNetworkGraphic.Create;
    Png.Transparent := False;

    Png.Assign(B);

    Png.SaveToFile(FileName);

    Png.Free;
   end
  Else
   B.SaveToFile(FileName);

 B.Free;

 SE.ScrollBars := TmpSB;
 SE.EndUpdate;
end;

procedure TMain.ClickOnHistoryItem(Sender: TObject; Item: TMenuItem;
  const FileName: String);
begin
 If FileExists(FileName) Then
  Begin
   NewEditorTab(FileName);

   BuildDocumentTabsMenu;
  end
 Else
  ShowMessage('Can''t find the selected file!');
end;

function TMain.GetSyntaxSchemeIDFromFileName(const FileName: String): Integer;
 Var I, P : Integer;
     fExt : String;
     tList : TStringList;

 Function ExtractExtFromFilter(Const sFilter : String) : String;
  Var B : Integer;
 Begin
  Result := '';

  If Pos('(', sFilter) > 0 Then
   Begin
    B := Pos('(', sFilter) + 1;

    While sFilter[B] <> ')' Do
     Begin
      Result := Result + sFilter[B];

      Inc(B);
     end;
   end;

  If Result <> '' Then
   Begin
    Result := StringReplace(Result, '*', '', [rfReplaceAll]);
    Result := StringReplace(Result, ';', ',', [rfReplaceAll]);
   End;
 end;

begin
 fExt := ExtractFileExt(FileName);
 Result := -1;

 tList := TStringList.Create;
 tList.StrictDelimiter := True;
 tList.Delimiter := ',';

 For I := 0 To SyntaxSchemeList.Count - 1 Do
  If SyntaxSchemeList[I].DefaultFilter <> '' Then
   Begin
    tList.DelimitedText := ExtractExtFromFilter(SyntaxSchemeList[I].DefaultFilter);

    If tList.Count > 0 Then
     For P := 0 To tList.Count - 1 Do
      If fExt = tList.Strings[P] Then
       Begin
        Result := I;

        tList.Free;

        Exit;
       end;
   end;

 If Result = -1 Then
  tList.Free;
end;

procedure TMain.ApplyStartUpOptions;
 Var oVal : Variant;
     I : Integer;
begin
 oVal := PiNoteOptions.GetOption(SectionStartUpPiNote, KeyAttrCount);

 If oVal > 0 Then
  Begin
   Setlength(bOptions, oVal);

   For I := 0 To oVal - 1 Do
    bOptions[I] := PiNoteOptions.GetOption(SectionStartUpPiNote, IntToStr(I) + KeyItem);

   //Show/Hide Status bar
   StatusBar.Visible := bOptions[0];
   miStatusBar.Checked := bOptions[0];

   //Show/Hide Tool bar
   ToolBar.Visible := bOptions[1];
   miToolBar.Checked := bOptions[1];

   //Show/Hide Menu bar
   miMenuBar.Checked := bOptions[2];

   If miMenuBar.Checked Then
    Self.Menu := MainMenu1
   Else
    Self.Menu := Nil;

   //Show/Hide line number into editor
   miViewLineNumbers.Checked := bOptions[3];
   //Show/Hide right edge into editor
   miViewRightEdge.Checked := bOptions[4];
   //Show/Hide current line highlight
   miViewLineHighlight.Checked := bOptions[5];

   //Active transparent Mode
   miTansparentMode.Checked := bOptions[6];

   If miTansparentMode.Checked Then
    Begin
     Self.AlphaBlend := True;
     Self.AlphaBlendValue := 128;
    end;

   //Active StayOnTop Mode
   miStayOnTop.Checked := bOptions[7];

   If miStayOnTop.Checked Then
    Self.FormStyle := fsStayOnTop;

   //Clear Clipboard
   If bOptions[8] Then
    Clipboard.Clear;
  end;

 oVal := PiNoteOptions.GetOption(SectionRecentFiles, KeyUseRecentFile);

 If oVal <> -1 Then
  FileHistory.Active := Boolean(oVal)
 Else
  FileHistory.Active := True;        //Default actived

 oVal := PiNoteOptions.GetOption(SectionRecentFiles, KeyCheckFile);

 If oVal <> -1 Then
  FileHistory.FileMustExist := Boolean(oVal);

 oVal := PiNoteOptions.GetOption(SectionRecentFiles, KeyEntries);

 If oVal <> -1 Then
  FileHistory.MaxItems := Integer(oVal);

 oVal := PiNoteOptions.GetOption(SectionUsefulThings, KeyAttrCount);

 If oVal > 0 Then
  Begin
   SetLength(UsefulOpt, oVal);

   For I := 0 To oVal - 1 Do
    UsefulOpt[I] := PiNoteOptions.GetOption(SectionUsefulThings, IntToStr(I) + KeyItem);
  end
 Else
  Begin
   SetLength(UsefulOpt, 6);

   For I := 0 To 5 Do
    UsefulOpt[I] := False;

   UsefulOpt[0] := True;
   UsefulOpt[5] := True;
  end;

 oVal := PiNoteOptions.GetOption(SectionDocument, KeyFontInUse);

 If varType(oVal) = varString Then
  If Screen.Fonts.IndexOf(oVal) > -1 Then
   PiNoteFontInUse := oVal;

 oVal := PiNoteOptions.GetOption(SectionDocument, KeyFontSize);

 If oVal <> -1 Then
  PiNoteFontSize := oVal;

 PiNoteFontStyle := [];

 oVal := PiNoteOptions.GetOption(SectionDocument, '0' + KeyFontStyle);

 If oVal <> -1 Then
  If Boolean(oVal) Then
   PiNoteFontStyle := PiNoteFontStyle + [fsBold];

 oVal := PiNoteOptions.GetOption(SectionDocument, '1' + KeyFontStyle);

 If oVal <> -1 Then
  If Boolean(oVal) Then
   PiNoteFontStyle := PiNoteFontStyle + [fsItalic];

 oVal := PiNoteOptions.GetOption(SectionDocument, '2' + KeyFontStyle);

 If oVal <> -1 Then
  If Boolean(oVal) Then
   PiNoteFontStyle := PiNoteFontStyle + [fsUnderLine];

 oVal := PiNoteOptions.GetOption(SectionDocument, KeyFontQuality);

 If oVal <> -1 Then
  PiNoteFontQuality := TFontQuality(oVal);

 oVal := PiNoteOptions.GetOption(SectionDocument, KeySyntaxSchemeTheme);

 If varType(oVal) = varString Then
  PiNoteDefaultSyntaxScheme := GetSyntaxSchemeIndex(oVal);

 oVal := PiNoteOptions.GetOption(SectionDocument, KeyTabWidth);

 Try
   If oVal <> -1 Then
    PiNoteEditorTabWidth := StrToInt(oVal);
 Except
   PiNoteEditorTabWidth := 4;
 end;

 oVal := PiNoteOptions.GetOption(SectionDocument, KeyMaxUndo);

 Try
   If oVal <> -1 Then
    PiNoteEditorMaxUndo := StrToInt(oVal);
 Except
   PiNoteEditorMaxUndo := 1024;
 end;

 oVal := PiNoteOptions.GetOption(SectionDocument, KeyRightEdge);

 Try
   If oVal <> -1 Then
    PiNoteRightEdgePos := StrToInt(oVal);
 Except
   PiNoteRightEdgePos := 80;
 end;

 miAutoCBrackets.Checked := PiNoteOptions.GetOptionBoolean(SectionDocument, KeyAutoCB);
end;

procedure TMain.SaveWindowPos;
begin
 PiNoteOptions.AddOption(SectionWindowPos, 'Left', Self.Left, -1);
 PiNoteOptions.AddOption(SectionWindowPos, 'Top', Self.Top, -1);
 PiNoteOptions.AddOption(SectionWindowPos, 'Width', Self.Width, -1);
 PiNoteOptions.AddOption(SectionWindowPos, 'Height', Self.Height, -1);
 PiNoteOptions.AddOption(SectionWindowPos, 'State', Integer(Self.WindowState), -1);

 PiNoteOptions.SaveToFile;
end;

procedure TMain.RestoreWindowPos;
 Var Tmp : Integer;
begin
 {$IfNDef Windows}
 If PiNoteOptions.GetOption(SectionWindowPos, 'Left') < 0 Then
  Exit;
 {$Endif}

 Tmp := PiNoteOptions.GetOption(SectionWindowPos, 'Left');

 If Tmp <> -1 Then
  Self.Left := Tmp;

 Tmp := PiNoteOptions.GetOption(SectionWindowPos, 'Top');

 If Tmp <> -1 Then
  Self.Top := Tmp;

 Tmp := PiNoteOptions.GetOption(SectionWindowPos, 'Width');

 If Tmp <> -1 Then
  Self.Width := Tmp;

 Tmp := PiNoteOptions.GetOption(SectionWindowPos, 'Height');

 If Tmp <> -1 Then
  Self.Height := Tmp;

 Tmp := PiNoteOptions.GetOption(SectionWindowPos, 'State');

 If Tmp <> -1 Then
  Self.WindowState := TWindowState(Tmp);
end;

function TMain.IsFileInUse(const TheFile: String): Boolean;
 Var I : Integer;
     Tmp : TForm;
begin
 Result := False;

 For I := PageDock.PageCount - 1 DownTo 0 Do
  If (PageDock.Pages[I] Is TTabForm) Then
   If (PageDock.Pages[I] As TTabForm).ParentForm Is TEditor Then
    Begin
     Tmp := (PageDock.Pages[I] As TTabForm).ParentForm;

     If (Tmp As TEditor).FileInEditing = TheFile Then
      Begin
       PageDock.ActivePageIndex := I;

       Result := True;

       Exit;
      end;
    end;
end;

function TMain.ListOfModifiedDocuments(FromIdx : Integer = -1;
 ToIdx : Integer = -1; IdxToJump : Integer = -1) : TStringList;
 Var I, fIdx, tIdx : Integer;
     Tmp : TForm;
begin
 Result := TStringList.Create;

 If FromIdx = -1 Then
  fIdx := 0
 Else
  fIdx := FromIdx;

 If ToIdx = -1 Then
  tIdx := PageDock.PageCount - 1
 Else
  tIdx:= ToIdx;

 For I := fIdx To tIdx Do
  Begin
   If IdxToJump = I Then
    Continue;

    If (PageDock.Pages[I] Is TTabForm) Then
     If (PageDock.Pages[I] As TTabForm).ParentForm Is TEditor Then
      Begin
       Tmp := (PageDock.Pages[I] As TTabForm).ParentForm;

       If (Tmp As TEditor).sEdit.Modified Then
        If (Tmp As TEditor).FileInEditing <> '' Then
         Result.Add((Tmp As TEditor).FileInEditing)
        Else
         Result.Add((Tmp As TEditor).EditorTabSheet.Caption);
      end;
  end;
end;

function TMain.IsSpaceChar(const C: AnsiChar): Boolean;
begin
 Result := False;

 If C In [#9, #32] Then
  Result := True;
end;

function TMain.SIndentOf(const S: Widestring): Widestring;
 Var I : Integer;
begin
 Result := '';

 For I := 1 To Length(S) Do
  If Not IsSpaceChar(S[I]) Then
   Begin
    Result := Copy(S, 1, I - 1);

    Break;
   end;
end;

function TMain.ReturnLineBreak(SystemLineBreak: TLineBreak): String;
begin
 Result := '';

 Case SystemLineBreak Of
      lbUnix          : Result := LF;
      lbWindows       : Result := CRLF;
      lbMac           : Result := CR;
 end;
end;

procedure TMain.UpdateLineBreakMenu;
begin
 miLBWin.Checked := False;
 miLBUnix.Checked := False;
 miLBMac.Checked := False;

 Case UserLineBreak Of
             lbWindows       : miLBWin.Checked := True;
             lbUnix          : miLBUnix.Checked := True;
             lbMac           : miLBMac.Checked := True;
 end;
end;

procedure TMain.OpenWithDefaultBrowser(const myUrl: String);
 Var v : THTMLBrowserHelpViewer;
     BrowserPath, BrowserParams, sTmp : String;
     p : LongInt;
     BrowserProcess : TProcessUTF8;
begin
 v := THTMLBrowserHelpViewer.Create(Nil);

 Try
   v.FindDefaultBrowser(BrowserPath, BrowserParams);

   sTmp := StringReplace(BrowserPath, '"', '', [rfReplaceAll]);

   If Not FileExists(sTmp) Then
    ShowMessage('Unable to find a web browser on the system!')
   Else
    Begin
     p := System.Pos('%s', BrowserParams);

     System.Delete(BrowserParams, p, 2);

     System.Insert(myUrl, BrowserParams, p);

     BrowserProcess := TProcessUTF8.Create(Nil);

     BrowserProcess.ShowWindow := swoShowNormal;

     Try
       BrowserProcess.Executable := BrowserPath;
       //BrowserProcess.Parameters.Text := BrowserParams;
       BrowserProcess.Parameters.Add(BrowserParams);

       BrowserProcess.Execute;
     finally
       BrowserProcess.Free;
     end;
    end;
 finally
   v.Free;
 end;
end;

procedure TMain.BuildFileDialogFilter;
 Var Ind, LangIdx : Integer;
begin
 OpenFile.Filter := 'All files|*.*;';

 For Ind := 0 To SyntaxSchemeNameList.Count - 1 Do
  Begin
   LangIdx := GetSyntaxSchemeIndex(SyntaxSchemeNameList[Ind]);

   If LangIdx > -1 Then
    OpenFile.Filter := OpenFile.Filter + '|' + SyntaxSchemeList[LangIdx].DefaultFilter;
  end;
end;

procedure TMain.Load_Bookmark_In_Menu(SE: TSynEdit; TB : TTabSheet);
 Var Ind : Word;
     Val : String;
     Cx, Cy : Integer;
begin
 For Ind := 0 To 9 Do
  Begin
   TMenuItem(Self.FindComponent('mBookm' + IntToStr(Ind))).Caption := 'Bookmark ' + IntToStr(Ind);
   TMenuItem(Self.FindComponent('mBookm' + IntToStr(Ind))).OnClick := Nil;

   TMenuItem(Self.FindComponent('mrBookm' + IntToStr(Ind))).Caption := 'Bookmark ' + IntToStr(Ind);
   TMenuItem(Self.FindComponent('mrBookm' + IntToStr(Ind))).OnClick := Nil;
  End;

 For Ind := 0 To 9 Do
  Begin
   If SE.IsBookmark(Ind) = True Then
    Begin
     Val := TB.Caption + ' (';

     SE.GetBookMark(Ind, Cx, Cy);

     Val := Val + IntToStr(Cx) + ', ' + IntToStr(Cy) + ')';

     TMenuItem(Self.FindComponent('mBookm' + IntToStr(Ind))).Caption := Val;
     TMenuItem(Self.FindComponent('mBookm' + IntToStr(Ind))).OnClick := @smBookmClick;

     TMenuItem(Self.FindComponent('mrBookm' + IntToStr(Ind))).Caption := Val;
     TMenuItem(Self.FindComponent('mrBookm' + IntToStr(Ind))).OnClick := @smBookrmClick;
    End;
  End;
end;

procedure TMain.SetClipboardPanelState(cpState: Boolean);
begin
 gbClipboardPanel.Visible := cpState;
 Splitter1.Visible := cpState;
end;

procedure TMain.CopyMenu(mSrc, mDst: TMenu);

 Function CloneMenuItem(Src : TMenuItem) : TMenuItem;
  Var Ind : Integer;
 Begin
  Result := Nil;

  If Src = Nil Then
   Exit;

  Result := TMenuItem.Create(Src.Owner);
  Result.Caption := Src.Caption;
  Result.OnClick := Src.OnClick;
  Result.Tag := Src.Tag;
  Result.Checked := Src.Checked;
  Result.RadioItem := Src.RadioItem;
  Result.ShortCut := Src.ShortCut;

  For Ind := 0 To Src.Count - 1 Do
   Result.Add(CloneMenuItem(Src[Ind]));
 end;

 Var I : Integer;
begin
 mDst.Items.Clear;

 For I := 0 To mSrc.Items.Count - 1 Do
  mDst.Items.Add(CloneMenuItem(mSrc.Items[I]));
end;

function TMain.CountWords(const S: String): LongInt;

 Const
   TAB        = #09;
   CR         = #13;
   LF         = #10;
   SEPARATORS = [' ', '.', ',', '!', '?',';',':', '''', '"', '(', ')',
                '[', ']', '{', '}', TAB, CR, LF ];

 Procedure ScrollThroughDelims(S : String; Var I : Integer);
 Begin
  While (S[I] In SEPARATORS) And (I <= Length(S)) Do
   Inc(I);
 end;

 Procedure ScrollThroughWord(S : String; Var W : String; Var I : Integer);
 Begin
  W := '';

  While (Not (S[I] In SEPARATORS)) And (I <= Length(S)) Do
   Begin
    W := W + S[I];

    Inc(I);
   End;
 end;

 Var I, WordNum : LongInt;
      W : String;
begin
 I := 1;
 WordNum := 0;
 W := '';

 While (I <= Length(S)) Do
  Begin
   ScrollThroughDelims(S, I);

   ScrollThroughWord(S, W, I);

   If (Length(W) > 0) Then
    Inc(WordNum);
  End;

 Result := WordNum;
end;

procedure TMain.PopulateClipBoardPanel;
 Var Ind : Integer;
     TlBW, LineW, MaxCharInLB : Integer;
     lNewLine,TmpLine : String;
     Truncated : Boolean;
begin
 lbClipboard.BeginUpdateBounds;
 lbClipboard.Clear;

 TlBW := lbClipboard.ClientWidth;

 For Ind := 0 To CplBItems.Count - 1 Do
  Begin
   Truncated := False;
   TmpLine := CplBItems.Strings[Ind];

   If Pos(CR, TmpLine) > 0 Then
    Begin
     TmpLine := Copy(TmpLine, 1, Pos(CR, TmpLine));

     Truncated := True;
    end;

   If Pos(LF, TmpLine) > 0 Then
    Begin
     TmpLine := Copy(TmpLine, 1, Pos(LF, TmpLine));

     Truncated := True;
    end;

   LineW := lbClipboard.Canvas.TextWidth(TmpLine);

   If LineW < TlBW Then
    Begin
     If Not Truncated Then
      lbClipboard.Items.Add(TmpLine)
     Else
      lbClipboard.Items.Add(TmpLine + '->');
    End
   Else
    Begin
     MaxCharInLB := lbClipboard.Canvas.TextFitInfo(TmpLine, TlBW);

     lNewLine := Copy(TmpLine, 1, MaxCharInLB - 3) + '...';

     lbClipboard.Items.Add(lNewLine);
    end;
  end;

 lbClipboard.EndUpdateBounds;
end;

procedure TMain.SavePiNoteFile(uEditor: TForm);
 Var dFilter, sTmp : String;
     Ind : Integer;
begin
 If Not (uEditor As TEditor).sEdit.Modified Then
  Exit;

 If (uEditor As TEditor).FileInEditing = '' Then
  Begin
   If (uEditor As TEditor).sEdit.Highlighter = Nil Then
    Begin
     SaveFile.DefaultExt := '.txt';
     SaveFile.Filter := 'Text File|*.txt|All Files|*.*';
    end
   Else
    Begin
     dFilter := (uEditor As TEditor).sEdit.Highlighter.DefaultFilter;
     sTmp := '';

     If Pos('(', dFilter) > 0 Then
      Begin
       Ind := Pos('(', dFilter) + 1;

       While Ind < Length(dFilter) Do
        Begin
         If dFilter[Ind] = ')' Then
          Break;

         If dFilter[Ind] = '*' Then
          Begin
           Inc(Ind);

           Continue;
          end;

         sTmp := sTmp + dFilter[Ind];

         Inc(Ind);
        end;

       If sTmp <> '' Then
        If Pos(sTmp, ',') > 0 Then
         sTmp := Copy(sTmp, 1, Pos(sTmp, ','));
      end;

     If sTmp <> '' Then
      SaveFile.DefaultExt := sTmp;

     SaveFile.Filter := dFilter + '|All Files|*.*;';
    end;

   If SaveFile.Execute Then
    Begin
     (uEditor As TEditor).FileInEditing := SaveFile.FileName;

     (uEditor As TEditor).SaveText;

     FileHistory.UpdateList(SaveFile.FileName);
    end;
  end
 Else
  Begin
   (uEditor As TEditor).SaveText;

   FileHistory.UpdateList((uEditor As TEditor).FileInEditing);
  end;
end;

procedure TMain.ClearDocumentTabsMenu;
 Var I : Integer;
begin
 For I := miTabs.Count - 1 DownTo 0 Do
  miTabs.Delete(I);
end;

procedure TMain.BuildDocumentTabsMenu;
 Var Ind : Integer;
     NewItem : TMenuItem;
begin
 ClearDocumentTabsMenu;

 miTabs.Enabled := False;

 If PageDock.PageCount > 0 Then
  Begin
   For Ind := 0 To PageDock.PageCount - 1 Do
    If (PageDock.Pages[Ind] Is TTabForm) Then
     If (PageDock.Pages[Ind] As TTabForm).ParentForm Is TEditor Then
      Begin
       NewItem := TMenuItem.Create(miTabs);

       NewItem.Caption := PageDock.Pages[Ind].Caption;
       NewItem.Tag := Ind;
       NewItem.OnClick := @DocumentTabsMenuClick;

       miTabs.Insert(Ind, NewItem);
      end;
  end;

 If miTabs.Count > 0 Then
  miTabs.Enabled := True;

 If miMicroMode.Checked Then
  CopyMenu(MainMenu1, pmMicro);
end;

procedure TMain.InsertIntoClipboardPanel(const Val: String);
begin
 CplBItems.Append(Val);

 PopulateClipBoardPanel;
end;

function TMain.GetSelectedFromClipboardPanel: String;
begin
 Result := '';

 If CplBItems.Count <= 0 Then
  Exit;

 Result := CplBItems.Strings[lbClipboard.ItemIndex];
end;

procedure TMain.ApplySyntaxOptions;
 Var oVal, LanName : Variant;
     I, SynIdx, A : Integer;
begin
 oVal := PiNoteOptions.GetOption(SectionSyntaxScheme, KeySyntaxSchemeTheme);

 If oVal <> -1 Then
  ThemeInUseIdx := Integer(oVal);

 SelectTheme(ThemeInUseIdx, SyntaxSchemeList);

 oVal := PiNoteOptions.GetOption(SectionSyntaxScheme, KeySyntaxMainFore);

 If oVal <> -1 Then
  MainForeground := Integer(oVal);

 oVal := PiNoteOptions.GetOption(SectionSyntaxScheme, KeySyntaxMainBack);

 If oVal <> -1 Then
  MainBackground := Integer(oVal);

 oVal := PiNoteOptions.GetOption(SectionSyntaxScheme, KeySyntaxLineFore);

 If oVal <> -1 Then
  LineForeground := Integer(oVal);

 oVal := PiNoteOptions.GetOption(SectionSyntaxScheme, KeySyntaxLineBack);

 If oVal <> -1 Then
  LineBackground := Integer(oVal);

 oVal := PiNoteOptions.GetOption(SectionSyntaxScheme, KeySyntaxEditedCount);

 If Integer(oVal) > 0 Then
  For I := 0 To Integer(oVal) - 1 Do
   Begin
    LanName := PiNoteOptions.GetOption(SectionSyntaxScheme, IntToStr(I) + KeySyntaxEditedName);

    SynIdx := GetSyntaxSchemeIndex(LanName);

    For A := 0 To SyntaxSchemeList[SynIdx].AttrCount - 1 Do
     Begin
      SyntaxSchemeList[SynIdx].Attribute[A].Foreground := PiNoteOptions.GetOption(LanName, IntToStr(A)  + 'Fore');
      SyntaxSchemeList[SynIdx].Attribute[A].Background := PiNoteOptions.GetOption(LanName, IntToStr(A)  + 'Back');

      SyntaxSchemeList[SynIdx].Attribute[A].Style := [];

      If Boolean(PiNoteOptions.GetOption(LanName, IntToStr(A)  + 'StyleU')) Then
       SyntaxSchemeList[SynIdx].Attribute[A].Style := SyntaxSchemeList[SynIdx].Attribute[A].Style + [fsUnderLine];

      If Boolean(PiNoteOptions.GetOption(LanName, IntToStr(A)  + 'StyleB')) Then
       SyntaxSchemeList[SynIdx].Attribute[A].Style := SyntaxSchemeList[SynIdx].Attribute[A].Style + [fsBold];

      If Boolean(PiNoteOptions.GetOption(LanName, IntToStr(A)  + 'StyleI')) Then
       SyntaxSchemeList[SynIdx].Attribute[A].Style := SyntaxSchemeList[SynIdx].Attribute[A].Style + [fsItalic];
     end;
   end;
end;

procedure TMain.ApplyDocumentOptions;
 Var I : Integer;
     Tmp : TForm;
begin
 For I := PageDock.PageCount - 1 DownTo 0 Do
  If (PageDock.Pages[I] Is TTabForm) Then
   If (PageDock.Pages[I] As TTabForm).ParentForm Is TEditor Then
    Begin
     Tmp := (PageDock.Pages[I] As TTabForm).ParentForm;

     (Tmp As TEditor).UserFontName := PiNoteFontInUse;
     (Tmp As TEditor).UserFontSize := PiNoteFontSize;
     (Tmp As TEditor).UserFontStyle := PiNoteFontStyle;
     (Tmp As TEditor).UserTabWidth := PiNoteEditorTabWidth;
     (Tmp As TEditor).UserMaxUndo := PiNoteEditorMaxUndo;
     (Tmp As TEditor).UserRightEdgePos := PiNoteRightEdgePos;
     (Tmp As TEditor).UserFontQuality := PiNoteFontQuality;

     (Tmp As TEditor).UpdateEditor;
     (Tmp As TEditor).ShowInfoOnStatusBar;
     (Tmp As TEditor).SetEditorFont(PiNoteFontInUse);
     (Tmp As TEditor).AutoCompleteBrackets := PiNoteOptions.GetOption(SectionDocument, KeyAutoCB);
    end;

 PageDockChange(Nil);
end;

procedure TMain.MovePage(bToRight: Boolean);
 Var PageIdx, OldPageIdx : Integer;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    PageIdx := PageDock.ActivePage.PageIndex;
    OldPageIdx := PageIdx;

    If bToRight Then
     Begin
      Inc(PageIdx);

      If PageIdx <= PageDock.PageCount - 1  Then
       PageDock.Pages[OldPageIdx].PageIndex := PageIdx;
     end
    Else
     Begin
      Dec(PageIdx);

      If PageIdx > -1 Then
       PageDock.Pages[OldPageIdx].PageIndex := PageIdx;
     end;
   end;
end;

procedure TMain.MovePageBeginOrEnd(ToBegin: Boolean);
 Var PageIdx : Integer;
begin
 If (PageDock.ActivePage Is TTabForm) Then
  If (PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
   Begin
    PageIdx := PageDock.ActivePage.PageIndex;

    If ToBegin Then
     PageDock.Pages[PageIdx].PageIndex := 0
    Else
     PageDock.Pages[PageIdx].PageIndex := PageDock.PageCount - 1;
   end;
end;

procedure TMain.UpdateSyntaxSchemeMenu(IDLanguage : Integer; ssMenu : TMenuItem);
 Var Ind, IndS : Integer;
begin
 For Ind := 0 To ssMenu.Count - 1 Do
  Begin
   ssMenu.Items[Ind].Checked := ssMenu.Items[Ind].Tag = IDLanguage;

   For IndS := 0 To ssMenu.Items[Ind].Count - 1 Do
    ssMenu.Items[Ind].Items[IndS].Checked := ssMenu.Items[Ind].Items[IndS].Tag = IDLanguage;
  end;
end;

end.

