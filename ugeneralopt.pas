{ <PiNote - free source code editor>

Copyright (C) <2022> <Enzo Antonio Calogiuri> <ecalogiuri(at)gmail.com>

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
unit uGeneralOpt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls;

Const
     LoremIpsum      = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras congue tellus et tincidunt tincidunt. Suspendisse potenti. Nulla sed fermentum tellus, ut tincidunt purus. Maecenas et posuere arcu, non pharetra leo. Cras risus libero, egestas eu volutpat non, pellentesque at metus. Sed viverra diam id diam bibendum iaculis. Nulla consequat, sem et tincidunt posuere, magna libero varius metus, et consequat sapien est sit amet sem. Morbi et purus condimentum, pulvinar diam vel, mollis lorem. Sed vel auctor tellus. Nulla et est sed elit vulputate laoreet. Curabitur vel lorem nibh.';

type

  { TfGeneralOpt }

  TfGeneralOpt = class(TForm)
    Button1: TButton;
    Button2: TButton;
    cbUseRecentFile: TCheckBox;
    cbCheckFile: TCheckBox;
    cgStartUpPiNote: TCheckGroup;
    cgUsefulThings: TCheckGroup;
    cgFontStyle: TCheckGroup;
    cbFonts: TComboBox;
    cbFontSize: TComboBox;
    cbSyntaxScheme: TComboBox;
    cbTabWidth: TComboBox;
    cbMaxUndo: TComboBox;
    cbRightEdge: TComboBox;
    cbEntries: TComboBox;
    cbAutoCB: TCheckBox;
    cbFontQuality: TComboBox;
    cbFixPFont: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cbFixPFontChange(Sender: TObject);
    procedure cbFontQualityChange(Sender: TObject);
    procedure cbFontsSelect(Sender: TObject);
    procedure cbFontSizeSelect(Sender: TObject);
    procedure cgFontStyleItemClick(Sender: TObject; Index: integer);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    Procedure SaveValuesIntoOptions;
    Procedure LoadFontListFixedPitch;
  public
    { public declarations }
  end;

var
  fGeneralOpt: TfGeneralOpt;

implementation

Uses uSyntaxList, uMain, uPiNoteOptions, LCLType, LCLIntF;

{$R *.lfm}

Function EnumFontsFixedPitchNoDups(Var LogFont: TEnumLogFontEx;
                                   Var Metric: TNewTextMetricEx;
                                   FontType: Longint;
                                   Data: LParam) : LongInt; StdCall;
 Var L : TStringList;
     S : String;
Begin
 L := TStringList(ptrint(Data));
 S := LogFont.elfLogFont.lfFaceName;

 If ((logfont.elfLogFont.lfPitchAndFamily And FIXED_PITCH) = FIXED_PITCH) And
     (L.IndexOf(S) < 0) Then
  L.Add(S);

 Result := 1;
end;

{ TfGeneralOpt }

procedure TfGeneralOpt.FormShow(Sender: TObject);
 Var I : Integer;
     oVal : Variant;
begin
 PageControl1.ActivePageIndex := 0;

 cbFixPFont.Checked := Main.PiNoteOptions.GetOption(SectionDocument, KeyFixPichFonts);

 If Not cbFixPFont.Checked Then
  cbFonts.Items.Assign(Screen.Fonts)
 Else
  LoadFontListFixedPitch;

 cbSyntaxScheme.Items.Assign(SyntaxSchemeNameList);

 cbSyntaxScheme.Items.Insert(0, 'Default Text');
 cbSyntaxScheme.ItemIndex := 0;

 cbFonts.Text := Main.PiNoteFontInUse;

 cbFontsSelect(Sender);

 If Length(Main.bOptions) = 0 Then
  cgStartUpPiNote.Checked[2] := True;

 For I := 0 To Length(Main.bOptions) - 1 Do
  cgStartUpPiNote.Checked[I] := Main.bOptions[I];

 For I := 0 To Length(Main.UsefulOpt) - 1 Do
  cgUsefulThings.Checked[I] := Main.UsefulOpt[I];

 oVal := Main.PiNoteOptions.GetOption(SectionRecentFiles, KeyUseRecentFile);

 If oVal <> -1 Then
  cbUseRecentFile.Checked := Boolean(oVal);

 oVal := Main.PiNoteOptions.GetOption(SectionRecentFiles, KeyCheckFile);

 If oVal <> -1 Then
  cbCheckFile.Checked := Boolean(oVal);

 oVal := Main.PiNoteOptions.GetOption(SectionRecentFiles, KeyEntries);

 If oVal <> -1 Then
  cbEntries.Text := String(oVal);

 cbFonts.Text := Main.PiNoteFontInUse;
 cbFontSize.Text := IntToStr(Main.PiNoteFontSize);

 If fsBold In Main.PiNoteFontStyle Then
  Begin
   cgFontStyle.Checked[0] := True;

   cgFontStyleItemClick(Sender, 0);
  end;

 If fsItalic In Main.PiNoteFontStyle Then
  Begin
   cgFontStyle.Checked[1] := True;

   cgFontStyleItemClick(Sender, 1);
  end;

 If fsUnderLine In Main.PiNoteFontStyle Then
  Begin
   cgFontStyle.Checked[2] := True;

   cgFontStyleItemClick(Sender, 2);
  end;

 If Main.PiNoteDefaultSyntaxScheme <> -1 Then
  cbSyntaxScheme.Text := SyntaxSchemeList[Main.PiNoteDefaultSyntaxScheme].LanguageName;

 cbTabWidth.Text := IntToStr(Main.PiNoteEditorTabWidth);
 cbMaxUndo.Text := IntToStr(Main.PiNoteEditorMaxUndo);
 cbRightEdge.Text := IntToStr(Main.PiNoteRightEdgePos);

 cbAutoCB.Checked := Main.PiNoteOptions.GetOption(SectionDocument, KeyAutoCB);
 //oVal := Main.PiNoteOptions.GetOption(SectionDocument, KeyAutoCB);

 //If oVal <> -1 Then
  //cbAutoCB.Checked := Boolean(oVal);

 Case Main.PiNoteFontQuality Of
      fqDefault              : cbFontQuality.ItemIndex := 3;
      fqDraft                : cbFontQuality.ItemIndex := 4;
      fqProof                : cbFontQuality.ItemIndex := 6;
      fqNonAntialiased       : cbFontQuality.ItemIndex := 5;
      fqAntialiased          : cbFontQuality.ItemIndex := 0;
      fqCleartype            : cbFontQuality.ItemIndex := 1;
      fqCleartypeNatural     : cbFontQuality.ItemIndex := 2;
 end;
end;

procedure TfGeneralOpt.SaveValuesIntoOptions;
 Var I : Word;
     tFQ : TFontQuality;
begin
 Main.PiNoteOptions.ClearSection(SectionStartUpPiNote);
 Main.PiNoteOptions.ClearSection(SectionUsefulThings);
 Main.PiNoteOptions.ClearSection(SectionDocument);
 Main.PiNoteOptions.ClearSection(SectionRecentFiles);

 Main.PiNoteOptions.AddOption(SectionStartUpPiNote, KeyAttrCount, cgStartUpPiNote.Items.Count, 0);

 For I := 0 To cgStartUpPiNote.Items.Count - 1 Do
  Main.PiNoteOptions.AddOption(SectionStartUpPiNote, IntToStr(I) + KeyItem, cgStartUpPiNote.Checked[I], False);

 Main.PiNoteOptions.AddOption(SectionUsefulThings, KeyAttrCount, cgUsefulThings.Items.Count, 0);

 For I := 0 To cgUsefulThings.Items.Count - 1 Do
  Main.PiNoteOptions.AddOption(SectionUsefulThings, IntToStr(I) + KeyItem, cgUsefulThings.Checked[I], False);

 Main.PiNoteOptions.AddOption(SectionDocument, KeyFontInUse, cbFonts.Text, '');
 Main.PiNoteOptions.AddOption(SectionDocument, KeyFontSize, StrToInt(cbFontSize.Text), 10);
 Main.PiNoteOptions.AddOption(SectionDocument, '0' + KeyFontStyle, cgFontStyle.Checked[0], False);
 Main.PiNoteOptions.AddOption(SectionDocument, '1' + KeyFontStyle, cgFontStyle.Checked[1], False);
 Main.PiNoteOptions.AddOption(SectionDocument, '2' + KeyFontStyle, cgFontStyle.Checked[2], False);
 Main.PiNoteOptions.AddOption(SectionDocument, KeyFixPichFonts, cbFixPFont.Checked, True);

 tFQ := fqDefault;

 Case cbFontQuality.ItemIndex Of
      0           : tFQ := fqAntialiased;
      1           : tFQ := fqCleartype;
      2           : tFQ := fqCleartypeNatural;
      3           : tFQ := fqDefault;
      4           : tFQ := fqDraft;
      5           : tFQ := fqNonAntialiased;
      6           : tFQ := fqProof;
 end;

 Main.PiNoteOptions.AddOption(SectionDocument, KeyFontQuality, tFQ, 0);

 Main.PiNoteOptions.AddOption(SectionDocument, KeySyntaxSchemeTheme, cbSyntaxScheme.Text, '');
 Main.PiNoteOptions.AddOption(SectionDocument, KeyTabWidth, cbTabWidth.Text, '');
 Main.PiNoteOptions.AddOption(SectionDocument, KeyMaxUndo, cbMaxUndo.Text, '');
 Main.PiNoteOptions.AddOption(SectionDocument, KeyRightEdge, cbRightEdge.Text, '');
 Main.PiNoteOptions.AddOption(SectionDocument, KeyAutoCB, cbAutoCB.Checked, False);

 Main.PiNoteOptions.AddOption(SectionRecentFiles, KeyUseRecentFile, cbUseRecentFile.Checked, True);
 Main.PiNoteOptions.AddOption(SectionRecentFiles, KeyCheckFile, cbCheckFile.Checked, False);
 Main.PiNoteOptions.AddOption(SectionRecentFiles, KeyEntries, StrToInt(cbEntries.Text), 5);
end;

procedure TfGeneralOpt.LoadFontListFixedPitch;
 Var DC : HDC;
     lF : TLogFont;
     L : TStringList;
begin
 L := TStringList.Create;
 lF.lfCharSet := DEFAULT_CHARSET;
 lF.lfFaceName := '';
 lF.lfPitchAndFamily := 0;

 {$IfDef Unix}
         {$IFDEF LCLGTK2}
         lF.lfPitchAndFamily := FIXED_PITCH; // Needs to be FIXED_PITCH on Linux-GTK2
         {$Endif}
 {$Endif}

 DC := GetDC(0);

 Try
   EnumFontFamiliesEX(DC, @lF, @EnumFontsFixedPitchNoDups, ptrint(L), 0);

   L.Sort;

   cbFonts.Items.Assign(L);
 finally
   L.Free;

   ReleaseDC(0, DC);
 end;
end;

procedure TfGeneralOpt.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TfGeneralOpt.Button2Click(Sender: TObject);
 Var I : Integer;
begin
 Screen.Cursor := crHourGlass;

 SaveValuesIntoOptions;

 Main.PiNoteOptions.SaveToFile;

 SetLength(Main.bOptions, cgStartUpPiNote.Items.Count - 1);

 For I := 0 To cgStartUpPiNote.Items.Count - 1 Do
  Main.bOptions[I] := cgStartUpPiNote.Checked[I];

 Main.FileHistory.Active := cbUseRecentFile.Checked;
 Main.FileHistory.FileMustExist := cbCheckFile.Checked;
 Main.FileHistory.MaxItems := StrToInt(cbEntries.Text);

 Main.FileHistory.UpdateParentMenu;

 Main.PiNoteFontInUse := cbFonts.Text;
 Main.PiNoteFontSize := StrToInt(cbFontSize.Text);
 Main.PiNoteFontStyle := Memo1.Font.Style;
 Main.PiNoteDefaultSyntaxScheme := GetSyntaxSchemeIndex(cbSyntaxScheme.Text);
 Main.PiNoteEditorTabWidth := StrToInt(cbTabWidth.Text);
 Main.PiNoteEditorMaxUndo := StrToInt(cbMaxUndo.Text);
 Main.PiNoteRightEdgePos := StrToInt(cbRightEdge.Text);

 Case cbFontQuality.ItemIndex Of
      0           : Main.PiNoteFontQuality := fqAntialiased;
      1           : Main.PiNoteFontQuality := fqCleartype;
      2           : Main.PiNoteFontQuality := fqCleartypeNatural;
      3           : Main.PiNoteFontQuality := fqDefault;
      4           : Main.PiNoteFontQuality := fqDraft;
      5           : Main.PiNoteFontQuality := fqNonAntialiased;
      6           : Main.PiNoteFontQuality := fqProof;
 end;

 SetLength(Main.UsefulOpt, cgUsefulThings.Items.Count - 1);

 For I := 0 To cgUsefulThings.Items.Count - 1 Do
  Main.UsefulOpt[I] := cgUsefulThings.Checked[I];

 Main.ApplyDocumentOptions;

 Screen.Cursor := crDefault;

 Close;
end;

procedure TfGeneralOpt.cbFixPFontChange(Sender: TObject);
begin
 cbFonts.Clear;

 If Not cbFixPFont.Checked Then
  cbFonts.Items.Assign(Screen.Fonts)
 Else
  LoadFontListFixedPitch;

 cbFonts.Text := Main.PiNoteFontInUse;

 cbFontsSelect(Sender);
end;

procedure TfGeneralOpt.cbFontQualityChange(Sender: TObject);
begin
 Case cbFontQuality.ItemIndex Of
      0           : Memo1.Font.Quality := fqAntialiased;
      1           : Memo1.Font.Quality := fqCleartype;
      2           : Memo1.Font.Quality := fqCleartypeNatural;
      3           : Memo1.Font.Quality := fqDefault;
      4           : Memo1.Font.Quality := fqDraft;
      5           : Memo1.Font.Quality := fqNonAntialiased;
      6           : Memo1.Font.Quality := fqProof;
 end;
end;

procedure TfGeneralOpt.cbFontsSelect(Sender: TObject);
begin
 Memo1.Lines.Clear;
 Memo1.Font.Name := cbFonts.Text;
 Memo1.Text := LoremIpsum;
end;

procedure TfGeneralOpt.cbFontSizeSelect(Sender: TObject);
begin
 Memo1.Lines.Clear;
 Memo1.Font.Size := StrToInt(cbFontSize.Text);
 Memo1.Text := LoremIpsum;
end;

procedure TfGeneralOpt.cgFontStyleItemClick(Sender: TObject; Index: integer);
begin
 Memo1.Lines.Clear;

 Case Index Of
      0     : If cgFontStyle.Checked[Index] Then
               Memo1.Font.Style := Memo1.Font.Style + [fsBold]
              Else
               Memo1.Font.Style := Memo1.Font.Style - [fsBold];

      1     : If cgFontStyle.Checked[Index] Then
               Memo1.Font.Style := Memo1.Font.Style + [fsItalic]
              Else
               Memo1.Font.Style := Memo1.Font.Style - [fsItalic];

      2     : If cgFontStyle.Checked[Index] Then
               Memo1.Font.Style := Memo1.Font.Style + [fsUnderLine]
              Else
               Memo1.Font.Style := Memo1.Font.Style - [fsUnderLine];
 end;

 Memo1.Text := LoremIpsum;
end;

end.

