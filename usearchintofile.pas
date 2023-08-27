{ <PiNote - free source code editor>

Copyright (C) <2021> <Enzo Antonio Calogiuri> <ecalogiuri(at)gmail.com>

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
unit uSearchIntoFile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, uMain;

Const
     CXE_SEARCH_INTO_FILE_LOG1    = 'pinsifl1.txt';
     CXE_SEARCH_INTO_FILE_LOG2    = 'pinsifl2.txt';
     MAX_CB_ITEMS                 = 20;
     WordBreakChars               = [#0..#31,'.', ',', ';', ':', '"', '''', '!', '?', '[', ']',
                                     '(', ')', '{', '}', '^', '-', '=', '+', '*', '/', '\', '|', ' '];

type
  { TfSearchIntoFile }

  TfSearchIntoFile = class(TForm)
    Button1: TButton;
    Button2: TButton;
    cbPath: TComboBox;
    cbSearchTxt: TComboBox;
    cgOptions: TCheckGroup;
    gbFolder: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    rgWhere: TRadioGroup;
    SelPath: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cbPathKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbSearchTxtKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure rgWhereSelectionChanged(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
    ListRec : Array Of SearchRec;

    Function cbSearchForItem(Val : String; Combo : TComboBox) : Boolean;
    Procedure cbInsertNewItem(Val : String; Combo : TComboBox);

    Function FindTextIntoLine(TxtToFind, TxtFile : String) : SearchRec;

    Procedure AddSearcRecToList(sRec : SearchRec);

    Procedure FindIntoAllOpenedFiles;

    Procedure FindIntoFilesInFolder(Folder : String);
  public
    { public declarations }
  end;

var
  fSearchIntoFile: TfSearchIntoFile;

implementation

Uses uTabForm, uEditor, uSIFResult;

{$R *.lfm}

{ TfSearchIntoFile }

procedure TfSearchIntoFile.FormShow(Sender: TObject);
begin
 rgWhere.ItemIndex := 0;

 ChDir(ExtractFilePath(Application.ExeName));

 If FileExists(CXE_SEARCH_INTO_FILE_LOG1) Then
  cbSearchTxt.Items.LoadFromFile(CXE_SEARCH_INTO_FILE_LOG1);

 If FileExists(CXE_SEARCH_INTO_FILE_LOG2) Then
  cbPath.Items.LoadFromFile(CXE_SEARCH_INTO_FILE_LOG2);
end;

procedure TfSearchIntoFile.rgWhereSelectionChanged(Sender: TObject);
begin
 gbFolder.Enabled := rgWhere.ItemIndex = 1;
end;

procedure TfSearchIntoFile.SpeedButton1Click(Sender: TObject);
begin
 If SelPath.Execute Then
  Begin
   cbPath.Text := SelPath.FileName;

   If Not cbSearchForItem(SelPath.FileName, cbPath) Then
    cbInsertNewItem(SelPath.FileName, cbPath);
  end;
end;

function TfSearchIntoFile.cbSearchForItem(Val: String; Combo: TComboBox): Boolean;
 Var Ind : Byte;
begin
 Result := False;

 If Combo.Items.Count = 0 Then
  Exit;

 For Ind := 0 To Combo.Items.Count - 1 Do
  If Val = Combo.Items.Strings[Ind] Then
   Begin
    Result := True;

    Break;
   end;
end;

procedure TfSearchIntoFile.cbInsertNewItem(Val: String; Combo: TComboBox);
begin
 If Combo.Items.Count < MAX_CB_ITEMS Then
  Combo.Items.Add(Val)
 Else
  Begin
   Combo.Items.Delete(0);

   Combo.Items.Add(Val);

   Combo.Text := Val;
  end;
end;

function TfSearchIntoFile.FindTextIntoLine(TxtToFind, TxtFile: String): SearchRec;
 Var fPos, EndfPos : Integer;
     ExFindBegin, ExFindEnd : Boolean;
begin
 Result.Found := False;

 If Not cgOptions.Checked[0] Then
  Begin
   TxtToFind := LowerCase(TxtToFind);
   TxtFile := LowerCase(TxtFile);
  end;

 fPos := Pos(TxtToFind, TxtFile);
 EndfPos := 0;

 If fPos > 0 Then
  Begin
   EndfPos := fPos + Length(TxtToFind) + 1;

   If Not cgOptions.Checked[1] Then
    Begin
     Result.Found := True;
     Result.Col := fPos;
     Result.LineFound := TxtFile;
     Result.EdFormIdx := -1;
    end
   Else
    Begin
     ExFindBegin := False;
     ExFindEnd := False;

     If fPos > 1 Then
      Begin
       If TxtFile[fPos - 1] In WordBreakChars Then
        ExFindBegin := True;
      end
     Else
      ExFindBegin := True;

     If Length(TxtFile) >= EndfPos Then
      Begin
       If TxtFile[EndfPos] In WordBreakChars Then
        ExFindEnd := True;
      end
     Else
      ExFindEnd := True;

     If (ExFindBegin) And (ExFindEnd) Then
      Begin
       Result.Found := True;
       Result.Col := fPos;
       Result.LineFound := TxtFile;
       Result.EdFormIdx := -1;
      end;
    end;
  end;
end;

procedure TfSearchIntoFile.AddSearcRecToList(sRec: SearchRec);
 Var OrigPos : Integer;
begin
 OrigPos := Length(ListRec);

 SetLength(ListRec, OrigPos + 1);

 ListRec[OrigPos] := sRec;
end;

procedure TfSearchIntoFile.FindIntoAllOpenedFiles;
 Var IndPage : Integer;
     IndLine : Integer;
     Rec : SearchRec;
     Tmp : TForm;
begin
 With Main Do
  Begin
   If PageDock.PageCount > 0 Then
    Begin
     For IndPage := 0 To PageDock.PageCount - 1 Do
      If (PageDock.Pages[IndPage] Is TTabForm) Then
       If (PageDock.Pages[IndPage] As TTabForm).ParentForm Is TEditor Then
        Begin
         Tmp := (PageDock.Pages[IndPage] As TTabForm).ParentForm;

         With (Tmp As TEditor) Do
          Begin
           If sEdit.Lines.Count > 0 Then
            For IndLine := 0 To sEdit.Lines.Count - 1 Do
             Begin
              Rec := FindTextIntoLine(cbSearchTxt.Text, sEdit.Lines.Strings[IndLine]);

              If Rec.Found Then
               Begin
                Rec.EdFormIdx := IndPage;
                Rec.Row := IndLine + 1;

                If FileInEditing <> '' Then
                 Rec.FileName := FileInEditing
                Else
                 Rec.FileName := 'NoName';

                AddSearcRecToList(Rec);
               end;
             end;
          end;
        end;
    end;
  end;
end;

procedure TfSearchIntoFile.FindIntoFilesInFolder(Folder: String);
 Var FullPath : String;
     FindResult: Integer;
     DirInfo: TSearchRec;
     IsDirectory, sHidden : Boolean;
     fLines : TStringList;
     Ind : Integer;
     Rec : SearchRec;
begin
 If DirectoryExists(Folder) Then
  Begin
   FullPath := IncludeTrailingPathDelimiter(Folder) + AllFilesMask;
   FindResult := FindFirst(FullPath, faAnyFile, DirInfo);

   fLines := TStringList.Create;

   While FindResult = 0 Do
    Begin
     IsDirectory := (DirInfo.Attr And FaDirectory = FaDirectory);
     sHidden := (DirInfo.Attr And faHidden = faHidden);

     If (Not IsDirectory) And (Not sHidden)  Then
      Begin
       fLines.Clear;

       fLines.LoadFromFile(IncludeTrailingPathDelimiter(Folder) + DirInfo.Name);

       If fLines.Count > 0 Then
        For Ind := 0 To fLines.Count - 1 Do
         Begin
          Rec := FindTextIntoLine(cbSearchTxt.Text, fLines.Strings[Ind]);

          If Rec.Found Then
           Begin
            Rec.Row := Ind + 1;
            Rec.FileName := IncludeTrailingPathDelimiter(Folder) + DirInfo.Name;

            AddSearcRecToList(Rec);
           end;
         end;
      end;

     FindResult := FindNext(DirInfo);
    end;

   SysUtils.FindClose(DirInfo);

   fLines.Free;
  end;
end;

procedure TfSearchIntoFile.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
 ChDir(ExtractFilePath(Application.ExeName));

 cbSearchTxt.Items.SaveToFile(CXE_SEARCH_INTO_FILE_LOG1);

 cbPath.Items.SaveToFile(CXE_SEARCH_INTO_FILE_LOG2);
end;

procedure TfSearchIntoFile.cbSearchTxtKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If Key = 13 Then
  If cbSearchTxt.Text <> '' Then
   If Not cbSearchForItem(cbSearchTxt.Text, cbSearchTxt) Then
    cbInsertNewItem(cbSearchTxt.Text, cbSearchTxt);
end;

procedure TfSearchIntoFile.cbPathKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If Key = 13 Then
  If cbPath.Text <> '' Then
   If DirectoryExists(cbPath.Text) Then
    If Not cbSearchForItem(cbPath.Text, cbPath) Then
     cbInsertNewItem(cbPath.Text, cbPath);
end;

procedure TfSearchIntoFile.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TfSearchIntoFile.Button2Click(Sender: TObject);
begin
 If cbSearchTxt.Text <> '' Then
  Begin
   If Not cbSearchForItem(cbSearchTxt.Text, cbSearchTxt) Then
    cbInsertNewItem(cbSearchTxt.Text, cbSearchTxt);

   If cbPath.Text <> '' Then
    If DirectoryExists(cbPath.Text) Then
     If Not cbSearchForItem(cbPath.Text, cbPath) Then
      cbInsertNewItem(cbPath.Text, cbPath);

   SetLength(ListRec, 0);

   Screen.Cursor := crHourGlass;
   Application.ProcessMessages;

   Case rgWhere.ItemIndex Of
        0                 : FindIntoAllOpenedFiles;

        1                 : FindIntoFilesInFolder(cbPath.Text);
   end;

   fSIFResult := TfSIFResult.Create(Application);
   fSIFResult.AddResult(ListRec, cbSearchTxt.Text);
   fSIFResult.Show;
   fSIFResult.SetFocus;

   Screen.Cursor := crDefault;

   Close;
  end;
end;

end.

