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
unit uEditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, Forms, Controls, Graphics, Dialogs,
  ComCtrls, Menus, ExtCtrls, StdCtrls, SynGutterBase, SynEditMarks,
  SynMacroRecorder, uSyntaxList, uMain, SynEditTypes, uPiRuler;

type

  { TEditor }

  TEditor = class(TForm)
    BKImages: TImageList;
    gbMiniMap: TGroupBox;
    MacroRecorder: TSynMacroRecorder;
    pEditor: TPanel;
    pmMenuBar: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
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
    N4: TMenuItem;
    miSyntaxScheme: TMenuItem;
    sEdit: TSynEdit;
    seMIViewLineNumber: TMenuItem;
    seMiReadOnly: TMenuItem;
    N3: TMenuItem;
    N2: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    N1: TMenuItem;
    PopupMenu1: TPopupMenu;
    seMinimap: TSynEdit;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure pmMenuBarClick(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure sEditChange(Sender: TObject);
    procedure sEditClick(Sender: TObject);
    procedure sEditCutCopy(Sender: TObject; var AText: String;
      var AMode: TSynSelectionMode; ALogStartPos: TPoint;
      var AnAction: TSynCopyPasteAction);
    procedure sEditGutterClick(Sender: TObject; X, Y, Line: integer;
      mark: TSynEditMark);
    procedure sEditKeyPress(Sender: TObject; var Key: char);
    procedure sEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sEditPaint(Sender: TObject; ACanvas: TCanvas);
    procedure seMinimapClick(Sender: TObject);
    procedure seMiReadOnlyClick(Sender: TObject);
    procedure seMIViewLineNumberClick(Sender: TObject);
  private
    { private declarations }
    LineBreak : TLineBreak;
    OldCaretPos : TPoint;
    fShowMiniMap : Boolean;

    Procedure ShowBinary(Var Data; Count: Cardinal);
    Procedure OpenAsHexadecimal(Const TheFile : String);

    Procedure ConvertLineBreak(var lText: String; const OldStyle, NewStyle: TLineBreak);

    Procedure SetMinimapStatus(Value : Boolean);

    Procedure SetupMiniMap;
  public
    { public declarations }
    FileInEditing : String;
    UserFontName : String;
    ShowLineNumber : Boolean;
    ShowRightEdge : Boolean;
    NoNameIdx : Integer;
    EditorTabSheet : TTabSheet;
    EdCurrEnCoding : String;
    SyntaxSchemeID : Integer;
    UserFontSize : Integer;
    UserFontStyle : TFontStyles;
    UserTabWidth : Integer;
    UserMaxUndo : Integer;
    UserRightEdgePos : Integer;
    OpenFileAsHexadecimal : Boolean;
    UserLineBreak : TLineBreak;
    UserFontQuality : TFontQuality;
    AutoCompleteBrackets : Boolean;
    ShowLineHighlight : Boolean;
    Ruler : TPiRuler;

    Function SetEditorFont(FontName : String) : Boolean;

    Procedure StartUpEditor;

    Procedure SaveText;

    Procedure UpdateEditor;
    Procedure UpdateRuler;

    Procedure ShowInfoOnStatusBar;

    Function StrPosToCaretPos(Pos : Integer) : TPoint;
    Procedure EditorGetSelLines(Var Ln1,Ln2 : Integer);
    Procedure EditorReplaceLine(NLine : Integer; Const S : String; AUndo : Boolean);
    Procedure SetSelection(Start, Len : Integer);
    Function GetLineBreak(StrLine : String) : TLineBreak;

    Procedure InsertComment(Const CommentStr : String; UseMultiLine : Boolean);

    Property ShowMiniMap : Boolean Read fShowMiniMap Write SetMinimapStatus;
  end;

implementation

Uses uSyntaxDefault, uGenericAsm_Highlighter, Clipbrd, LCLIntF, SynEditKeyCmds,
     InterfaceBase, LCLPlatformDef;

Const
     BracketSet         = ['{', '[', '(', '}', ']', ')', '<', '>'];
     OpenChars          : Array [0..3] Of Char = ('{', '[', '(', '<');
     CloseChars         : Array [0..3] Of Char = ('}', ']', ')', '>');


{$R *.lfm}

Function GetOppositeBracket(C : Char) : Char;
 Var I : Byte;
Begin
 Result := #0;

 For I := 0 To High(OpenChars) Do
  If C = OpenChars[I] Then
   Begin
    Result := CloseChars[I];

    Exit;
   end;

 For I := 0 To High(CloseChars) Do
  If C = CloseChars[I] Then
   Begin
    Result := OpenChars[I];

    Exit;
   end;
end;

{ TEditor }

procedure TEditor.FormCreate(Sender: TObject);
begin
 FileInEditing := '';
 UserFontName := '';
 ShowLineNumber := False;
 ShowRightEdge := False;
 NoNameIdx := 0;
 SyntaxSchemeID := -1;
 OpenFileAsHexadecimal := False;
 ShowLineHighlight := False;
 ShowMiniMap := False;

 LineBreak := lbNoChange;

 {$IfDef Windows}
 LineBreak := lbWindows;
 {$Endif}

 {$IfDef Unix}
 LineBreak := lbUnix;
 {$Endif}

 {$IfDef Darwin}
 LineBreak := lbMac;
 {$Endif}

 UserLineBreak := LineBreak;
 AutoCompleteBrackets := False;

 sEdit.Canvas.Font.Size := sEdit.Font.Size;
 sEdit.Canvas.Font.Name := sEdit.Font.Name;

 Ruler := TPiRuler.Create(Self);
 Ruler.Align := alTop;
 Ruler.Color := clDefault;

 Ruler.Font.Size := 4;

 If (WidgetSet.LCLPlatform = lpQt5) Or (WidgetSet.LCLPlatform = lpQt) Or
    (WidgetSet.LCLPlatform = lpWin32) Then
  Ruler.Font.Size := 8;

 Ruler.TickSizeBig := 35;
 Ruler.TickSizeMiddle := 25;
 Ruler.TickSizeSmall := 15;
 Ruler.Height := 17;
 Ruler.UnitPrice := 10;
 Ruler.StartValue := 0;
 Ruler.UnitDisplacement := 0;   //Per lo scroll

 Ruler.Font.Name := sEdit.Font.Name;
 Ruler.UnitSize := sEdit.Canvas.GetTextWidth(' ');

 If sEdit.Gutter.Visible Then
  Ruler.LeftBorder := sEdit.Gutter.Width + 1
 Else
  Ruler.LeftBorder := 1;

 Ruler.Visible := False;

 pEditor.InsertControl(Ruler);

 CreateSyntaxSubMenu(miSyntaxScheme);
end;

procedure TEditor.FormDestroy(Sender: TObject);
begin
 Ruler.Free;
end;

procedure TEditor.MenuItem10Click(Sender: TObject);
 Var cTxt : String;
begin
 cTxt := Clipboard.AsText + sEdit.SelText;

 Clipboard.Clear;
 Clipboard.AsText := cTxt;
end;

procedure TEditor.MenuItem11Click(Sender: TObject);
begin
 sEdit.PasteFromClipboard;
end;

procedure TEditor.MenuItem12Click(Sender: TObject);
begin
 sEdit.SelectAll;
end;

procedure TEditor.MenuItem14Click(Sender: TObject);
begin
 Main.MenuItem81Click(Self);
end;

procedure TEditor.MenuItem16Click(Sender: TObject);
begin
 Main.MenuItem173Click(Sender);
end;

procedure TEditor.MenuItem17Click(Sender: TObject);
begin
 Main.MenuItem174Click(Sender);
end;

procedure TEditor.MenuItem18Click(Sender: TObject);
begin
 Main.MenuItem175Click(Sender);
end;

procedure TEditor.MenuItem19Click(Sender: TObject);
begin
 Main.MenuItem176Click(Sender);
end;

procedure TEditor.pmMenuBarClick(Sender: TObject);
begin
 Main.Menu := Main.MainMenu1;
 Main.miMenuBar.Checked := True;
end;

procedure TEditor.MenuItem21Click(Sender: TObject);
begin
 Main.MovePage(False);
end;

procedure TEditor.MenuItem22Click(Sender: TObject);
begin
 Main.MovePage(True);
end;

procedure TEditor.MenuItem23Click(Sender: TObject);
begin
 Main.MovePageBeginOrEnd(True);
end;

procedure TEditor.MenuItem24Click(Sender: TObject);
begin
 Main.MovePageBeginOrEnd(False);
end;

procedure TEditor.MenuItem2Click(Sender: TObject);
begin
 Main.MenuItem71Click(Sender);
end;

procedure TEditor.MenuItem4Click(Sender: TObject);
begin
 Main.MenuItem39Click(Sender);
end;

procedure TEditor.MenuItem5Click(Sender: TObject);
begin
 Main.MenuItem40Click(Sender);
end;

procedure TEditor.MenuItem6Click(Sender: TObject);
begin
 Main.MenuItem133Click(Sender);
end;

procedure TEditor.MenuItem7Click(Sender: TObject);
begin
 Main.MenuItem134Click(Sender);
end;

procedure TEditor.MenuItem8Click(Sender: TObject);
begin
 sEdit.CutToClipboard;
end;

procedure TEditor.MenuItem9Click(Sender: TObject);
begin
 sEdit.CopyToClipboard;
end;

procedure TEditor.PopupMenu1Popup(Sender: TObject);
begin
 pmMenuBar.Checked := Main.miMenuBar.Checked;
end;

procedure TEditor.sEditChange(Sender: TObject);
 Var Tmp : String;
begin
 ShowInfoOnStatusBar;

 Tmp := EditorTabSheet.Caption;

 If sEdit.Modified Then
  Begin
   If Tmp[1] <> '*' Then
    Tmp := '*' + Tmp;
  end
 Else
  If Tmp[1] = '*' Then
   Delete(Tmp, 1, 1);

  EditorTabSheet.Caption := Tmp;

  If ShowMiniMap Then
   Begin
    seMiniMap.Text := sEdit.Text;
    seMiniMap.CaretY := sEdit.CaretY;
   end;
end;

procedure TEditor.sEditClick(Sender: TObject);
begin
 ShowInfoOnStatusBar;
end;

procedure TEditor.sEditCutCopy(Sender: TObject; var AText: String;
  var AMode: TSynSelectionMode; ALogStartPos: TPoint;
  var AnAction: TSynCopyPasteAction);
begin
 //Main.lbClipboard.Items.Append(AText);
 Main.InsertIntoClipboardPanel(AText);
end;

procedure TEditor.sEditGutterClick(Sender: TObject; X, Y, Line: integer;
  mark: TSynEditMark);
begin
 If ShowLineNumber Then
  Begin
   sEdit.CaretY := Line;
   sEdit.SelectLine();
  end;
end;

procedure TEditor.sEditKeyPress(Sender: TObject; var Key: char);
begin
 If AutoCompleteBrackets Then
  If Key In BracketSet Then
   Begin
    sEdit.SelText := GetOppositeBracket(Key);
    sEdit.CaretX := sEdit.CaretX - 1;
   end;
end;

procedure TEditor.sEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
 {$IfDef Unix}
 If (Shift = [ssCtrl]) And (Key = 78) Then
  Begin
   Shift := [];
   Key := 0;

   Main.NewEditorTab('');

   sEdit.Undo;
  end
 Else
 {$Endif}
  ShowInfoOnStatusBar;
end;

procedure TEditor.sEditPaint(Sender: TObject; ACanvas: TCanvas);
begin
 If Not Ruler.Visible Then
  Exit;

 Ruler.UnitDisplacement := sEdit.LeftChar - 1;
end;

procedure TEditor.seMinimapClick(Sender: TObject);
 Var MainLinesInWindow, Ind, NewCPos : Integer;
     OrigCX, OrigCY : Integer;
begin
 sEdit.CommandProcessor(TSynEditorCommand(ecEditorTop), ' ', Nil);

 MainLinesInWindow := sEdit.LinesInWindow;

 OrigCX := seMiniMap.CaretX;
 OrigCY := seMiniMap.CaretY;

 //Place the selected line in middle of screen
 If seMinimap.CaretY > (MainLinesInWindow Div 2) Then
  For Ind := 0 To MainLinesInWindow Div 2 Do
   seMiniMap.CommandProcessor(TSynEditorCommand(ecDown), ' ', Nil);

 NewCPos := seMinimap.CaretY;

 sEdit.CaretY := NewCPos;
 sEdit.CommandProcessor(TSynEditorCommand(ecPageBottom), ' ', Nil);
 sEdit.CommandProcessor(TSynEditorCommand(ecLineEnd), ' ', Nil);
 sEdit.CommandProcessor(TSynEditorCommand(ecSelPageTop), ' ', Nil);

 seMiniMap.SelStart := sEdit.SelStart;
 seMiniMap.SelEnd := sEdit.SelEnd;

 sEdit.CaretY := OrigCY;
 sEdit.CaretX := OrigCX;
 sEdit.SetFocus;
end;

procedure TEditor.seMiReadOnlyClick(Sender: TObject);
begin
 seMiReadOnly.Checked := Not seMiReadOnly.Checked;

 Main.miReadOnly.Checked := seMiReadOnly.Checked;

 sEdit.ReadOnly := seMiReadOnly.Checked;

 ShowInfoOnStatusBar;
end;

procedure TEditor.seMIViewLineNumberClick(Sender: TObject);
begin
 ShowLineNumber := Not ShowLineNumber;

 seMIViewLineNumber.Checked := ShowLineNumber;
 Main.miViewLineNumbers.Checked := ShowLineNumber;

 UpdateEditor;
end;

procedure TEditor.ShowBinary(var Data; Count: Cardinal);
 Const PosStart           = 1;
       BinStart           = 7;
       AscStart           = 57;
       HexChars           : PChar = '0123456789ABCDEF';

 Var Line : String[80];
     I : Cardinal;
     P : PChar;
     nStr : String[4];
begin
 P := @Data;
 Line := '';

 For I := 0 To Count - 1 Do
  Begin
   If (I Mod 16) = 0 Then
    Begin
     If Length(Line) > 0 Then
      sEdit.Lines.Add(Line);

     FillChar(Line, SizeOf(Line), ' ');

     Line[0] := Chr(72);

     nStr := Format('%4.4X', [I]);

     Move(nStr[1], Line[PosStart], Length(nStr));

     Line[PosStart + 4] := ':';
    end;

   If P[I] >= ' ' Then
    Line[I Mod 16 + AscStart] := P[I]
   Else
    Line[I Mod 16 + AscStart] := '.';

   Line[BinStart + 3 * (I Mod 16)] := HexChars[(Ord(P[I]) Shr 4) And $F];
   Line[BinStart + 3 * (I Mod 16) + 1] := HexChars[Ord(P[I]) And $F];
  end;

 sEdit.Lines.Add(Line);
end;

procedure TEditor.OpenAsHexadecimal(const TheFile: String);
 Var MS : TMemoryStream;
begin
 If FileExists(TheFile) Then
  Begin
   MS := TMemoryStream.Create;

   MS.LoadFromFile(TheFile);

   Try
     ShowBinary(MS.Memory^, MS.Size);
   finally
     MS.Free;
   end;

   sEdit.ReadOnly := True;
  end;
end;

procedure TEditor.ConvertLineBreak(var lText: String; const OldStyle,
  NewStyle: TLineBreak);
begin
 Case NewStyle Of
      lbUnix               : lText := StringReplace(lText, CRLF, LF, [rfReplaceAll]);

      lbWindows            : If OldStyle = lbUnix Then
                              lText := StringReplace(lText, LF, CRLF, [rfReplaceAll])
                             Else
                              If OldStyle = lbMac Then
                               lText := StringReplace(lText, CR, CRLF, [rfReplaceAll]);

      lbMac                : lText := StringReplace(lText, CRLF, CR, [rfReplaceAll]);
 end;
end;

procedure TEditor.SetMinimapStatus(Value: Boolean);
begin
 fShowMiniMap := Value;

 gbMiniMap.Visible := fShowMiniMap;
 Splitter1.Visible := fShowMiniMap;

 SetupMiniMap;
end;

procedure TEditor.SetupMiniMap;
begin
 If ShowMiniMap Then
  Begin
   seMiniMap.Color := sEdit.Color;
   seMiniMap.Font.Color := sEdit.Font.Color;
   seMiniMap.Font.Name := sEdit.Font.Name;
   seMiniMap.Font.Size := 3;
   seMiniMap.Highlighter := sEdit.Highlighter;

   seMiniMap.SelectedColor.Background := sEdit.SelectedColor.Background;
   seMiniMap.SelectedColor.Foreground := sEdit.SelectedColor.Foreground;

   seMiniMap.Text := sEdit.Text;
   seMiniMap.CaretY := sEdit.CaretY;
  end;
end;

function TEditor.SetEditorFont(FontName: String): Boolean;
begin
 If Screen.Fonts.IndexOf(FontName) <> -1 Then
  Begin
   sEdit.Font.Name := FontName;

   sEdit.Canvas.Font.Size := sEdit.Font.Size;
   sEdit.Canvas.Font.Name := sEdit.Font.Name;

   Ruler.Font.Name := sEdit.Font.Name;
   Ruler.UnitSize := sEdit.Canvas.GetTextWidth(' ');

   If sEdit.Gutter.Visible Then
    Ruler.LeftBorder := sEdit.Gutter.Width + 1
   Else
    Ruler.LeftBorder := 1;

   Ruler.Invalidate;

   Result := True;
  end
 Else
  Result := False;
end;

procedure TEditor.StartUpEditor;
begin
 If (FileInEditing = '') Or Not FileExists(FileInEditing) Then
  Begin
   EditorTabSheet.Caption := 'Noname';

   If NoNameIdx > 0 Then
    EditorTabSheet.Caption := EditorTabSheet.Caption + '(' + IntToStr(NoNameIdx) + ')';

   Application.ProcessMessages;
  end
 Else
  Begin
   EditorTabSheet.Caption := ExtractFileName(FileInEditing);

   If FileExists(FileInEditing) Then
    Begin
     If Not OpenFileAsHexadecimal Then
      Begin
       sEdit.Lines.LoadFromFile(FileInEditing);

       LineBreak := GetLineBreak(sEdit.Text);
       UserLineBreak := LineBreak;
      end
     Else
      OpenAsHexadecimal(FileInEditing);
    end;
  end;

 sEdit.Gutter.Visible := ShowLineNumber;

 If Not ShowRightEdge Then
  sEdit.RightEdge := -1;

 If UserFontName = '' Then
  SetEditorFont('Lucida Console')
 Else
  SetEditorFont(UserFontName);
end;

procedure TEditor.SaveText;
 Var Tmp : String;
begin
 If UserLineBreak <> LineBreak Then
  Begin
   Tmp := sEdit.Text;

   ConvertLineBreak(Tmp, LineBreak, UserLineBreak);

   sEdit.Text := Tmp;
  end;

 sEdit.Lines.SaveToFile(FileInEditing);

 EditorTabSheet.Caption := ExtractFileName(FileInEditing);

 sEdit.Modified := False;
 sEdit.MarkTextAsSaved;
end;

procedure TEditor.UpdateEditor;
 Var TmpC : TPoint;
begin
 sEdit.Font.Style := UserFontStyle;
 sEdit.Gutter.Visible := ShowLineNumber;
 sEdit.TabWidth := UserTabWidth;
 sEdit.MaxUndo := UserMaxUndo;

 sEdit.Font.Quality := UserFontQuality;

 sEdit.Gutter.Color := MainBackground;

 sEdit.Gutter.Parts[2].MarkupInfo.Background := MainBackground;
 sEdit.Gutter.Parts[2].MarkupInfo.Foreground := MainForeground;

 sEdit.Font.Color := MainForeground;
 sEdit.Color := MainBackground;

 Main.lbClipboard.Color := MainBackground;
 Main.lbClipboard.Font.Color := MainForeground;
 Main.lbClipboard.Font.Quality := UserFontQuality;

 If ShowLineHighlight Then
  Begin
   TmpC := sEdit.CaretXY;

   sEdit.LineHighlightColor.Background := LineBackground;
   sEdit.LineHighlightColor.Foreground := LineForeground;

   sEdit.CaretXY := OldCaretPos;
   Sleep(10);
   sEdit.CaretXY := TmpC;
  end
 Else
  Begin
   OldCaretPos := sEdit.CaretXY;

   sEdit.LineHighlightColor.Background := clNone;
   sEdit.LineHighlightColor.Foreground := clNone;
  end;

 sEdit.SelectedColor.Background := InvertColor((*LineBackground*)MainBackground);
 sEdit.SelectedColor.Foreground := InvertColor(sEdit.SelectedColor.Background(*LineForeground*));

 If Not ShowRightEdge Then
  sEdit.RightEdge := -1
 Else
  sEdit.RightEdge := UserRightEdgePos;

 If SyntaxSchemeID = -1 Then
  sEdit.Highlighter := Nil
 Else
  Begin
   sEdit.Highlighter := SyntaxSchemeList[SyntaxSchemeID];

   sEdit.Highlighter.Enabled := True;
  end;

 If sEdit.Gutter.Visible Then
  Ruler.LeftBorder := sEdit.Gutter.Width + 1
 Else
  Ruler.LeftBorder := 1;

 Main.UpdateSyntaxSchemeMenu(SyntaxSchemeID, Main.miSyntaxScheme);
 Main.UpdateSyntaxSchemeMenu(SyntaxSchemeID, miSyntaxScheme);

 seMiReadOnly.Checked := sEdit.ReadOnly;
 seMIViewLineNumber.Checked := ShowLineNumber;

 Main.miViewMinimapPanel.Checked := ShowMiniMap;

 SetupMiniMap;

 ShowInfoOnStatusBar;

 Self.Invalidate;
end;

procedure TEditor.UpdateRuler;
begin
 If Ruler.Visible Then
  Begin
   sEdit.Canvas.Font.Name := sEdit.Font.Name;
   sEdit.Canvas.Font.Size := sEdit.Font.Size;

   Ruler.UnitSize := sEdit.Canvas.GetTextWidth(' ');

   If sEdit.Gutter.Visible Then
    Ruler.LeftBorder := sEdit.Gutter.Width + 1
   Else
    Ruler.LeftBorder := 1;

   Ruler.Invalidate;
  end;
end;

procedure TEditor.ShowInfoOnStatusBar;
 Var Tmp : String;
begin
 Main.StatusBar.Panels[0].Text := 'Ln ' + IntToStr(sEdit.CaretY) +
                                  ' : ' + IntToStr(sEdit.Lines.Count) +
                                  '  Col ' + IntToStr(sEdit.CaretX) +
                                  '  Sel ' + IntToStr(Length(sEdit.SelText));

 Main.StatusBar.Panels[1].Text := EdCurrEnCoding;

 If sEdit.InsertMode Then
  Main.StatusBar.Panels[2].Text := 'INS'
 Else
  Main.StatusBar.Panels[2].Text := 'OVR';

 If SyntaxSchemeID > -1 Then
  Begin
   Tmp := SyntaxSchemeList[SyntaxSchemeID].LanguageName;

   If Tmp = '-1' Then
    Tmp := TGenericAsmSyn(SyntaxSchemeList[SyntaxSchemeID]).AsmLanguageName;

   Main.StatusBar.Panels[3].Text := Tmp;

  end
 Else
  Main.StatusBar.Panels[3].Text := 'Default Text';

 If sEdit.ReadOnly Then
  Main.StatusBar.Panels[4].Text := 'RD only'
 Else
  Main.StatusBar.Panels[4].Text := 'RD/WR';
end;

function TEditor.StrPosToCaretPos(Pos: Integer): TPoint;
 Var X, Y, Chars : Integer;
     E : String;
     LineEndLen : Word;
begin
 X := 0;
 Y := 0;
 E := LineEnding;
 LineEndLen := Length(E);
 Chars := 0;

 While Y < sEdit.Lines.Count Do
  Begin
   X := Length(sEdit.Lines[Y]);

   If Chars + X + LineEndLen > Pos Then
    Begin
     X := Pos - Chars;

     Break;
    end;

   Inc(Chars, X + LineEndLen);

   X := 0;

   Inc(Y);
  end;

 Result := Point(X + 1, Y + 1);

 If Result.Y > sEdit.Lines.Count Then
  Result.y := sEdit.Lines.Count;
end;

procedure TEditor.EditorGetSelLines(var Ln1, Ln2: Integer);
 Var P : TPoint;
     Tmp : Integer;
begin
 If sEdit.SelText <> '' Then
  Begin
   Ln1 := StrPosToCaretPos(sEdit.SelStart).Y;
   Tmp := sEdit.SelEnd;

   If Tmp > Length(sEdit.Text) Then
    Tmp := Length(sEdit.Text);

   P := StrPosToCaretPos(Tmp);
   Ln2 := P.Y;

   If P.X = 1 Then
    Dec(Ln2);
  end
 Else
  Begin
   Ln1 := sEdit.CaretY;
   Ln2 := Ln1;
  end;
end;

procedure TEditor.EditorReplaceLine(NLine: Integer; const S: String;
  AUndo: Boolean);
  Var P : TPoint;
      OldSLen : Integer;
begin
 If AUndo Then
  Begin
   sEdit.BeginUpdate(False);

   Try
     P := sEdit.CaretXY;
     sEdit.CaretXY := Point(0, NLine);

     OldSLen := Length(sEdit.Lines.Strings[NLine - 1]) + 1;

     sEdit.TextBetweenPoints[Point(0, NLine), Point(OldSLen, NLine)] := '';
     sEdit.InsertTextAtCaret(S);

     sEdit.CaretXY := P;
   finally
     sEdit.EndUpdate;
   end;
  end
 Else
  Begin
   OldSLen := Length(sEdit.Lines.Strings[NLine - 1]) + 1;

   sEdit.TextBetweenPoints[Point(0, NLine), Point(OldSLen, NLine)] := S;
   sEdit.Modified := True;
  end;
end;

procedure TEditor.SetSelection(Start, Len: Integer);
begin
 sEdit.SelStart := Start;
 sEdit.SelEnd := Start + Len;
end;

function TEditor.GetLineBreak(StrLine: String): TLineBreak;
 Var P : Integer;
begin
 P := Pos(LF, StrLine);

 If P > 0 Then
  Begin
   If (P > 1) And (StrLine[P - 1] = CR) Then
    Result := lbWindows
   Else
    Result := lbUnix;
  end
 Else
  Begin
    P := Pos(CR, StrLine);

    If P > 0 Then
     Result := lbMac
    Else
     Result := lbNoChange;
  end;
end;

procedure TEditor.InsertComment(const CommentStr: String; UseMultiLine: Boolean);
 Var Val : TCommentData;
     Ind : Word;
     SynHID : Integer;
     TxtBlock : TStringList;
begin
 SynHID := -1;

 For Ind := 0 To Length(CommentDataList) - 1 Do
  If CommentDataList[Ind].LanguageID = SyntaxSchemeID Then
   Begin
    SynHID := Ind;

    Break;
   end;

 TxtBlock := TStringList.Create;
 TxtBlock.Text := CommentStr;

 If SynHID <> -1 Then
  Begin
   Val := CommentDataList[SynHID];

   If Val.CommentType = CommentTypeSingleLine Then
    Begin
     For Ind := 0 To TxtBlock.Count - 1 Do
      sEdit.InsertTextAtCaret(Val.SingleLineID + TxtBlock[Ind] + TxtBlock.LineBreak);
    end
   Else
    Begin
     If UseMultiLine Then
      Begin
       TxtBlock.Insert(0, Val.MultiLineIDStart);
       TxtBlock.Append(Val.MultiLineIDEnd);

       sEdit.InsertTextAtCaret(TxtBlock.Text + TxtBlock.LineBreak);
      end
     Else
      For Ind := 0 To TxtBlock.Count - 1 Do
       sEdit.InsertTextAtCaret(Val.SingleLineID + TxtBlock[Ind] + TxtBlock.LineBreak);
    end;
  end
 Else
  For Ind := 0 To TxtBlock.Count - 1 Do
   sEdit.InsertTextAtCaret(TxtBlock[Ind] + TxtBlock.LineBreak);

 TxtBlock.Free;
end;

end.

