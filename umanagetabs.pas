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
unit uManageTabs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls;

type

  { TfManageTabs }

  TfManageTabs = class(TForm)
    bActive: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    lvTabs: TListView;
    Panel1: TPanel;
    Splitter1: TSplitter;
    procedure bActiveClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvTabsClick(Sender: TObject);
    procedure lvTabsDblClick(Sender: TObject);
  private
    FirstShow : Boolean;
    IdxSelected : TStringList;

    Procedure CalculateColumnSize;
    Procedure LoadTabsData;
    Procedure EnableButtonActive;

    Procedure BuildIdxSelected;

    Function ListOfModifiedDocuments : TStringList;
  public
    PageDock : TPageControl;
  end;

var
  fManageTabs: TfManageTabs;

implementation

Uses uEditor, uTabForm, uSyntaxList, uGenericAsm_Highlighter, uMain,
     uQueryEditedFiles;

{$R *.lfm}

{ TfManageTabs }

procedure TfManageTabs.Button3Click(Sender: TObject);
begin
 Close;
end;

procedure TfManageTabs.Button4Click(Sender: TObject);
 Var Ind, Idx : Integer;
begin
 BuildIdxSelected;

 If IdxSelected.Count > 0 Then
  Begin
   For Ind := 0 To IdxSelected.Count - 1 Do
    Begin
     Idx := StrToInt(IdxSelected[Ind]);

     If (PageDock.Pages[Idx] Is TTabForm) Then
      If (PageDock.Pages[Idx] As TTabForm).ParentForm Is TEditor Then
       Begin
        PageDock.ActivePageIndex := Idx;

        Main.MovePage(False);
       end;
    end;

   LoadTabsData;
  end;
end;

procedure TfManageTabs.Button5Click(Sender: TObject);
 Var Ind, Idx : Integer;
begin
 BuildIdxSelected;

 If IdxSelected.Count > 0 Then
  Begin
   For Ind := IdxSelected.Count - 1 DownTo 0 Do
    Begin
     Idx := StrToInt(IdxSelected[Ind]);

     If (PageDock.Pages[Idx] Is TTabForm) Then
      If (PageDock.Pages[Idx] As TTabForm).ParentForm Is TEditor Then
       Begin
        PageDock.ActivePageIndex := Idx;

        Main.MovePage(True);
       end;
    end;

   LoadTabsData;
  end;
end;

procedure TfManageTabs.Button6Click(Sender: TObject);
 Var Ind, Idx : Integer;
begin
 BuildIdxSelected;

 If IdxSelected.Count > 0 Then
  Begin
   For Ind := IdxSelected.Count - 1 DownTo 0 Do
    Begin
     Idx := StrToInt(IdxSelected[Ind]);

     If (PageDock.Pages[Idx] Is TTabForm) Then
      If (PageDock.Pages[Idx] As TTabForm).ParentForm Is TEditor Then
       Begin
        PageDock.ActivePageIndex := Idx;

        Main.MenuItem11Click(Sender);
       end;
    end;

   LoadTabsData;
  end;
end;

procedure TfManageTabs.bActiveClick(Sender: TObject);
 Var Idx : Integer;
begin
 Idx := lvTabs.ItemIndex;

 Close;

 PageDock.ActivePageIndex := Idx;

 Main.PageDockChange(Sender);
end;

procedure TfManageTabs.Button2Click(Sender: TObject);
 Var UnSaved : TStringList;
     SaveBeforeClose : Boolean;
     QueryResult : Word;
     Ind, Idx : Integer;
begin
 BuildIdxSelected;

 If IdxSelected.Count > 0 Then
  Begin
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

   For Ind := IdxSelected.Count - 1 DownTo 0 Do
    Begin
     Idx := StrToInt(IdxSelected[Ind]);

     If (PageDock.Pages[Idx] Is TTabForm) Then
      If (PageDock.Pages[Idx] As TTabForm).ParentForm Is TEditor Then
       Begin
        If SaveBeforeClose Then
         Begin
          PageDock.ActivePageIndex := Idx;

          Main.MenuItem11Click(Sender);
         end;

        (PageDock.Pages[Idx] As TTabForm).Free;
       end;
    end;

   UnSaved.Free;

   Main.BuildDocumentTabsMenu;

   LoadTabsData;
  end;
end;

procedure TfManageTabs.FormCreate(Sender: TObject);
begin
 FirstShow := True;
 IdxSelected := TStringList.Create;
end;

procedure TfManageTabs.FormDestroy(Sender: TObject);
begin
 IdxSelected.Free;
end;

procedure TfManageTabs.FormResize(Sender: TObject);
begin
 CalculateColumnSize;
end;

procedure TfManageTabs.FormShow(Sender: TObject);
begin
 If FirstShow Then
  Begin
   FirstShow := False;

   CalculateColumnSize;

   LoadTabsData;
  end;
end;

procedure TfManageTabs.lvTabsClick(Sender: TObject);
begin
 EnableButtonActive;
end;

procedure TfManageTabs.lvTabsDblClick(Sender: TObject);
begin
 bActiveClick(Sender);
end;

procedure TfManageTabs.CalculateColumnSize;
 Var tSize : Integer;
     Ind : Word;
begin
 tSize := lvTabs.Width Div 4;

 For Ind := 0 To lvTabs.Columns.Count - 1 Do
  lvTabs.Column[Ind].Width := tSize;
end;

procedure TfManageTabs.LoadTabsData;
 Var Ind, PosTab, ActiveIdx : Integer;
     Tmp : TForm;
     sTmp : String;
begin
 PosTab := 0;
 ActiveIdx := -1;

 lvTabs.Items.Clear;

 If Assigned(PageDock.ActivePage) Then
  ActiveIdx := PageDock.ActivePageIndex;

 For Ind := 0 To PageDock.PageCount - 1 Do
  If (PageDock.Pages[Ind] Is TTabForm) Then
   If (PageDock.Pages[Ind] As TTabForm).ParentForm Is TEditor Then
    Begin
     Tmp := (PageDock.Pages[Ind] As TTabForm).ParentForm;

     lvTabs.Items.Add;

     lvTabs.Items[PosTab].Caption := PageDock.Pages[Ind].Caption;
     lvTabs.Items[PosTab].SubItems.Add(ExtractFilePath((Tmp As TEditor).FileInEditing));

     If (Tmp As TEditor).SyntaxSchemeID > -1 Then
      Begin
       sTmp := SyntaxSchemeList[(Tmp As TEditor).SyntaxSchemeID].LanguageName;

       If sTmp = '-1' Then
        sTmp := TGenericAsmSyn(SyntaxSchemeList[(Tmp As TEditor).SyntaxSchemeID]).AsmLanguageName;

       lvTabs.Items[PosTab].SubItems.Add(sTmp);
      end
     Else
      lvTabs.Items[PosTab].SubItems.Add('Default Text');

     lvTabs.Items[PosTab].SubItems.Add(IntToStr(Length((Tmp As TEditor).sEdit.Text)));

     Inc(PosTab);
    end;

 If (lvTabs.Items.Count > 0) And (ActiveIdx > -1) Then
  If Assigned(lvTabs.Items[ActiveIdx]) Then
   lvTabs.ItemIndex := ActiveIdx;

 EnableButtonActive;
end;

procedure TfManageTabs.EnableButtonActive;
 Var Ind, NumSel : Integer;
begin
 bActive.Enabled := False;

 If lvTabs.Items.Count > 0 Then
  Begin
   NumSel := 0;

   For Ind := 0 To lvTabs.Items.Count - 1 Do
    If lvTabs.Items[Ind].Selected Then
     Inc(NumSel);

   If (NumSel > 0) And (NumSel < 2) Then
    bActive.Enabled := True;;
  end;
end;

procedure TfManageTabs.BuildIdxSelected;
 Var Ind : Integer;
begin
 IdxSelected.Clear;

 For Ind := 0 To lvTabs.Items.Count - 1 Do
  If lvTabs.Items[Ind].Selected Then
   IdxSelected.Add(IntToStr(Ind));
end;

function TfManageTabs.ListOfModifiedDocuments: TStringList;
 Var I, Idx : Integer;
     Tmp : TForm;
begin
 Result := TStringList.Create;

 For I := 0 To IdxSelected.Count - 1 Do
  Begin
   Idx := StrToInt(IdxSelected[I]);

   If (PageDock.Pages[Idx] Is TTabForm) Then
    If (PageDock.Pages[Idx] As TTabForm).ParentForm Is TEditor Then
     Begin
      Tmp := (PageDock.Pages[Idx] As TTabForm).ParentForm;

      If (Tmp As TEditor).sEdit.Modified Then
       If (Tmp As TEditor).FileInEditing <> '' Then
        Result.Add((Tmp As TEditor).FileInEditing)
       Else
        Result.Add((Tmp As TEditor).EditorTabSheet.Caption);
     end;
  end;
end;

end.

