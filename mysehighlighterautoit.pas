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
unit MySEHighlighterAutoIt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SynFacilHighlighter, SynEditHighlighter;

Type

    { TMySEHighlighterAutoIt }

    TMySEHighlighterAutoIt                = Class(TSynFacilSyn)
      Private
        fKeyWordList                      : TStringList;
        tnPreProcessor                    : Integer;
        tnMacro                           : Integer;
        tnFunctions                       : Integer;

      Protected
        function IsFilterStored: Boolean; override;
        function GetSampleSource: string; override;

      Public
        Constructor Create(AOwner: TComponent); Override;
        Destructor Destroy; Override;

        class function GetLanguageName: string; override;
    end;

implementation

Uses SynFacilBasic, SynEditStrConst;

Const
     SYNS_FilterAutoIt        = 'AutoIt files (*.au3;*.ahk)|*.au3;*.ahk';
     SYNS_LangAutoIt          = 'AutoIt';

     AutoItKeyWords           = 'False,True,ContinueCase,ContinueLoop,Default,Dim,' +
                                'Global,Local,Const,Do,Until,Enum,Exit,ExitLoop,' +
                                'For,To,Step,Next,In,Func,Return,EndFunc,If,Then,' +
                                'Elseif,Else,Endif,Null,ReDim,Select,Case,EndSelect,' +
                                'Static,Switch,EndSwitch,Volatile,While,WEnd,' +
                                'With,EndWith,And,Or,Not';

     AutoItFunctions          = 'Abs,ACos,AdlibRegister,AdlibUnRegister,Asc,AscW,' +
                                'ASin,Assign,ATan,AutoItSetOption,AutoItWinGetTitle,' +
                                'AutoItWinSetTitle,Beep,Binary,BinaryLen,BinaryMid,' +
                                'BinaryToString,BitAND,BitNOT,BitOR,BitRotate,' +
                                'BitShift,BitXOR,BlockInput,Break,Call,CDTray,Ceiling,' +
                                'Chr,ChrW,ClipGet,ClipPut,ConsoleRead,ConsoleWrite,' +
                                'ConsoleWriteError,ControlClick,ControlCommand,' +
                                'ControlDisable,ControlEnable,ControlFocus,ControlGetFocus,' +
                                'ControlGetHandle,ControlGetPos,ControlGetText,' +
                                'ControlHide,ControlListView,ControlMove,ControlSend,' +
                                'ControlSetText,ControlShow,ControlTreeView,Cos,Dec,' +
                                'DirCopy,DirCreate,DirGetSize,DirMove,DirRemove,DllCall,' +
                                'DllCallAddress,DllCallbackFree,DllCallbackGetPtr,' +
                                'DllCallbackRegister,DllClose,DllOpen,DllStructCreate,' +
                                'DllStructGetData,DllStructGetPtr,DllStructGetSize,' +
                                'DllStructSetData,DriveGetDrive,DriveGetFileSystem,' +
                                'DriveGetLabel,DriveGetSerial,DriveGetType,DriveMapAdd,' +
                                'DriveMapDel,DriveMapGet,DriveSetLabel,DriveSpaceFree,' +
                                'DriveSpaceTotal,DriveStatus,EnvGet,EnvSet,EnvUpdate,' +
                                'Eval,Execute,Exp,FileChangeDir,FileClose,FileCopy,' +
                                'FileCreateNTFSLink,FileCreateShortcut,FileDelete,' +
                                'FileExists,FileFindFirstFile,FileFindNextFile,FileFlush,' +
                                'FileGetAttrib,FileGetEncoding,FileGetLongName,FileGetPos,' +
                                'FileGetShortcut,FileGetShortName,FileGetSize,FileGetTime,' +
                                'FileGetVersion,FileInstall,FileMove,FileOpen,FileOpenDialog,' +
                                'FileRead,FileReadLine,FileReadToArray,FileRecycle,' +
                                'FileRecycleEmpty,FileSaveDialog,FileSelectFolder,' +
                                'FileSetAttrib,FileSetEnd,FileSetPos,FileSetTime,FileWrite,' +
                                'FileWriteLine,Floor,FtpSetProxy,FuncName,GUICreate,' +
                                'GUICtrlCreateAvi,GUICtrlCreateButton,GUICtrlCreateCheckbox,' +
                                'GUICtrlCreateCombo,GUICtrlCreateContextMenu,GUICtrlCreateDate,' +
                                'GUICtrlCreateDummy,GUICtrlCreateEdit,GUICtrlCreateGraphic,' +
                                'GUICtrlCreateGroup,GUICtrlCreateIcon,GUICtrlCreateInput,' +
                                'GUICtrlCreateLabel,GUICtrlCreateList,GUICtrlCreateListView,' +
                                'GUICtrlCreateListViewItem,GUICtrlCreateMenu,GUICtrlCreateMenuItem,' +
                                'GUICtrlCreateMonthCal,GUICtrlCreateObj,GUICtrlCreatePic,' +
                                'GUICtrlCreateProgress,GUICtrlCreateRadio,GUICtrlCreateSlider,' +
                                'GUICtrlCreateTab,GUICtrlCreateTabItem,GUICtrlCreateTreeView,' +
                                'GUICtrlCreateTreeViewItem,GUICtrlCreateUpdown,GUICtrlDelete,' +
                                'GUICtrlGetHandle,GUICtrlGetState,GUICtrlRead,GUICtrlRecvMsg,' +
                                'GUICtrlRegisterListViewSort,GUICtrlSendMsg,GUICtrlSendToDummy,' +
                                'GUICtrlSetBkColor,GUICtrlSetColor,GUICtrlSetCursor,' +
                                'GUICtrlSetData,GUICtrlSetDefBkColor,GUICtrlSetDefColor,' +
                                'GUICtrlSetFont,GUICtrlSetGraphic,GUICtrlSetImage,' +
                                'GUICtrlSetLimit,GUICtrlSetOnEvent,GUICtrlSetPos,' +
                                'GUICtrlSetResizing,GUICtrlSetState,GUICtrlSetStyle,' +
                                'GUICtrlSetTip,GUIDelete,GUIGetCursorInfo,GUIGetMsg,' +
                                'GUIGetStyle,GUIRegisterMsg,GUISetAccelerators,' +
                                'GUISetBkColor,GUISetCoord,GUISetCursor,GUISetFont,' +
                                'GUISetHelp,GUISetIcon,GUISetOnEvent,GUISetState,GUISetStyle,' +
                                'GUIStartGroup,GUISwitch,Hex,HotKeySet,HttpSetProxy,' +
                                'HttpSetUserAgent,HWnd,InetClose,InetGet,InetGetInfo,' +
                                'InetGetSize,InetRead,IniDelete,IniRead,IniReadSection,' +
                                'IniReadSectionNames,IniRenameSection,IniWrite,IniWriteSection,' +
                                'InputBox,Int,IsAdmin,IsArray,IsBinary,IsBool,IsDeclared,' +
                                'IsDllStruct,IsFloat,IsFunc,IsHWnd,IsInt,IsKeyword,IsMap,' +
                                'IsNumber,IsObj,IsPtr,IsString,Log,MapAppend,MapExists,' +
                                'MapKeys,MapRemove,MemGetStats,Mod,MouseClick,' +
                                'MouseClickDrag,MouseDown,MouseGetCursor,MouseGetPos,' +
                                'MouseMove,MouseUp,MouseWheel,MsgBox,Number,ObjCreate,' +
                                'ObjCreateInterface,ObjEvent,ObjGet,ObjName,OnAutoItExitRegister,' +
                                'OnAutoItExitUnRegister,Ping,PixelChecksum,PixelGetColor,' +
                                'PixelSearch,ProcessClose,ProcessExists,ProcessGetStats,' +
                                'ProcessList,ProcessSetPriority,ProcessWait,ProcessWaitClose,' +
                                'ProgressOff,ProgressOn,ProgressSet,Ptr,Random,RegDelete,' +
                                'RegEnumKey,RegEnumVal,RegRead,RegWrite,Round,Run,' +
                                'RunAs,RunAsWait,RunWait,Send,SendKeepActive,SetError,' +
                                'SetExtended,ShellExecute,ShellExecuteWait,Shutdown,' +
                                'Sin,Sleep,SoundPlay,SoundSetWaveVolume,SplashImageOn,' +
                                'SplashOff,SplashTextOn,Sqrt,SRandom,StatusbarGetText,' +
                                'StderrRead,StdinWrite,StdioClose,StdoutRead,String,' +
                                'StringAddCR,StringCompare,StringFormat,StringFromASCIIArray,' +
                                'StringInStr,StringIsAlNum,StringIsAlpha,StringIsASCII,' +
                                'StringIsDigit,StringIsFloat,StringIsInt,StringIsLower,' +
                                'StringIsSpace,StringIsUpper,StringIsXDigit,StringLeft,' +
                                'StringLen,StringLower,StringMid,StringRegExp,StringRegExpReplace,' +
                                'StringReplace,StringReverse,StringRight,StringSplit,' +
                                'StringStripCR,StringStripWS,StringToASCIIArray,' +
                                'StringToBinary,StringTrimLeft,StringTrimRight,StringUpper,' +
                                'Tan,TCPAccept,TCPCloseSocket,TCPConnect,TCPListen,' +
                                'TCPNameToIP,TCPRecv,TCPSend,TCPShutdown,UDPShutdown,' +
                                'TCPStartup,UDPStartup,TimerDiff,TimerInit,ToolTip,' +
                                'TrayCreateItem,TrayCreateMenu,TrayGetMsg,TrayItemDelete,' +
                                'TrayItemGetHandle,TrayItemGetState,TrayItemGetText,' +
                                'TrayItemSetOnEvent,TrayItemSetState,TrayItemSetText,' +
                                'TraySetClick,TraySetIcon,TraySetOnEvent,TraySetPauseIcon,' +
                                'TraySetState,TraySetToolTip,TrayTip,UBound,UDPBind,' +
                                'UDPCloseSocket,UDPOpen,UDPRecv,UDPSend,VarGetType,' +
                                'WinActivate,WinActive,WinClose,WinExists,WinFlash,' +
                                'WinGetCaretPos,WinGetClassList,WinGetClientSize,' +
                                'WinGetHandle,WinGetPos,WinGetProcess,WinGetState,' +
                                'WinGetText,WinGetTitle,WinKill,WinList,WinMenuSelectItem,' +
                                'WinMinimizeAll,WinMinimizeAllUndo,WinMove,WinSetOnTop,' +
                                'WinSetState,WinSetTitle,WinSetTrans,WinWait,WinWaitActive,' +
                                'WinWaitClose,WinWaitNotActive';

{ TMySEHighlighterAutoIt }

function TMySEHighlighterAutoIt.IsFilterStored: Boolean;
begin
 Result := fDefaultFilter <> SYNS_FilterAutoIt;
end;

function TMySEHighlighterAutoIt.GetSampleSource: string;
begin
 Result := '#include <Misc.au3>' + #13#10 +
           '' + #13#10 +
           '$file = FileOpen($filename,0)' + #13#10 +
           'if $file =-1 then _ThrowError("File " & $file & " not found!",1) ; Exit when msgbox closed' + #13#10 +
           '' + #13#10 +
           '$clip = ClipGet()' + #13#10 +
           'if $clip = "" then _ThrowError("Clipboard is empty. Continuing...", 0, 0, 0, 3) ; No exit, no error, auto-close in 3 seconds' + #13#10 +
           '' + #13#10 +
           'Func parse_html_title($source_string)' + #13#10 +
           '     Local $title = StringRegExp($source_string,"<title>([^>]*)</title>",1)' + #13#10 +
           '     If Not IsArray($title) then Return _ThrowError("Failed to extract title", 0, "-no title found-", 1, 0, 3) ; No exit, error=1, auto-close in 3 seconds' + #13#10 +
           '     Return $title[0]' + #13#10 +
           'EndFunc';
end;

constructor TMySEHighlighterAutoIt.Create(AOwner: TComponent);
 Var I : Integer;
begin
 fKeyWordList := TStringList.Create;
 fKeyWordList.Delimiter := ',';
 fKeyWordList.StrictDelimiter := True;

 fKeyWordList.DelimitedText := AutoItKeyWords;

 inherited Create(AOwner);

 ClearMethodTables;
 ClearSpecials;

 DefTokIdentif('[A-Za-z_]', '[A-Za-z0-9_]*');

 For I := 0 To fKeyWordList.Count - 1 Do
  AddKeyword(fKeyWordList[I]);

 fKeyWordList.Clear;
 fKeyWordList.DelimitedText := AutoItFunctions;

 tnFunctions := NewTokType(SYNS_AttrFunction);
 tnMacro := NewTokType(SYNS_AttrMacro);
 tnPreProcessor := NewTokType(SYNS_AttrPreprocessor);

 For I := 0 To fKeyWordList.Count - 1 Do
  AddIdentSpec(fKeyWordList[I], tnFunctions);

 fKeyWordList.Free;

 DefTokDelim('"','"', tnString, tdMulLin);
 DefTokDelim(';','', tnComment);
 DefTokDelim('#comments-start','#comments-end', tnComment, tdMulLin, False);
 DefTokDelim('#cs','#ce', tnComment, tdMulLin, False);
 DefTokDelim('#','', tnPreProcessor);
 DefTokDelim('@','', tnMacro);

 DefTokContent('[0123456789]','[0-9]', tnNumber);
 DefTokContent('0x','[0-9A-Fa-f]*', tnNumber);

 fDefaultFilter := SYNS_FilterAutoIt;

 Rebuild;

 SetAttributesOnChange(@DefHighlightChange);
end;

destructor TMySEHighlighterAutoIt.Destroy;
begin
  inherited Destroy;
end;

class function TMySEHighlighterAutoIt.GetLanguageName: string;
begin
 Result := SYNS_LangAutoIt;
end;

end.

