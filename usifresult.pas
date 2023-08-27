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
unit uSIFResult;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ComCtrls, uMain;

type

  { TfSIFResult }

  TfSIFResult = class(TForm)
    pcResult: TPageControl;

    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure ListViewResize(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Procedure AddResult(ListRec : Array Of SearchRec; SrcTxt : String);
  end;

var
  fSIFResult: TfSIFResult;

implementation

Uses uTabForm, uEditor, uSearchIntoFile;

{$R *.lfm}

{ TfSIFResult }

procedure TfSIFResult.ListViewResize(Sender: TObject);
begin
 (Sender As TListView).Column[0].Width := Self.Width Div 2;
end;

procedure TfSIFResult.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 Self.Release;
end;

procedure TfSIFResult.ListViewDblClick(Sender: TObject);
 Var sRic : Integer;
     Tmp : TForm;
begin
 If (Sender As TListView).Items.Count > 0 Then
  With Sender As TListView Do
   Begin
    If Selected = Nil Then
     Exit;

    sRic := StrToInt(Selected.SubItems.Strings[3]);

    If sRic > -1 Then
     Begin
      Main.PageDock.ActivePage := Main.PageDock.Pages[sRic];

      If (Main.PageDock.ActivePage Is TTabForm) Then
       If (Main.PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
        Begin
         Tmp := (Main.PageDock.ActivePage As TTabForm).ParentForm;

         With (Tmp As TEditor) Do
          Begin
           sEdit.CaretY := StrToInt(Selected.SubItems.Strings[1]);
           sEdit.CaretX := StrToInt(Selected.SubItems.Strings[2]);

           sEdit.SelectWord;

           Main.SetFocus;
          end;
        end;
     end
    Else
     Begin
      If Not FileExists(Selected.SubItems.Strings[4]) Then
       Exit;

      Main.NewEditorTab(Selected.SubItems.Strings[4]);

      If (Main.PageDock.ActivePage Is TTabForm) Then
       If (Main.PageDock.ActivePage As TTabForm).ParentForm Is TEditor Then
        Begin
         Tmp := (Main.PageDock.ActivePage As TTabForm).ParentForm;

         With (Tmp As TEditor) Do
          Begin
           sEdit.CaretY := StrToInt(Selected.SubItems.Strings[1]);
           sEdit.CaretX := StrToInt(Selected.SubItems.Strings[2]);

           sEdit.SelectWord;

           Main.SetFocus;
          end;
        end;
     end;
   end;
end;

procedure TfSIFResult.AddResult(ListRec: array of SearchRec; SrcTxt: String);
 Var Tmp : TTabSheet;
     ListV : TListView;
     Ind : Integer;
begin
 Tmp := pcResult.AddTabSheet;

 ListV := TListView.Create(Tmp);
 ListV.Align := alClient;
 ListV.ReadOnly := True;
 ListV.ViewStyle := vsReport;
 ListV.AutoWidthLastColumn := True;
 ListV.GridLines := True;
 ListV.RowSelect := True;

 ListV.OnResize := @ListViewResize;
 ListV.OnDblClick := @ListViewDblClick;

 ListV.Columns.Add;
 ListV.Columns.Add;

 ListV.Columns.Add;
 ListV.Columns.Add;
 ListV.Columns.Add;
 ListV.Columns.Add;

 ListV.Column[0].Caption := 'File';
 ListV.Column[0].Width := Self.Width Div 2;

 ListV.Column[1].Caption := 'Line';

 ListV.Column[2].Visible := False;
 ListV.Column[3].Visible := False;
 ListV.Column[4].Visible := False;
 ListV.Column[5].Visible := False;

 If Length(ListRec) > 0 Then
  Begin
   For Ind := 0 To Length(ListRec) - 1 Do
    Begin
     ListV.Items.Add;

     ListV.Items.Item[Ind].Caption := ListRec[Ind].FileName + '(' +
                                      IntToStr(ListRec[Ind].Row) + ', ' +
                                      IntToStr(ListRec[Ind].Col) + ')';

     ListV.Items.Item[Ind].SubItems.Add(ListRec[Ind].LineFound);

     ListV.Items.Item[Ind].SubItems.Add(IntToStr(ListRec[Ind].Row));
     ListV.Items.Item[Ind].SubItems.Add(IntToStr(ListRec[Ind].Col));
     ListV.Items.Item[Ind].SubItems.Add(IntToStr(ListRec[Ind].EdFormIdx));
     ListV.Items.Item[Ind].SubItems.Add(ListRec[Ind].FileName);
    end;

   Tmp.Caption := SrcTxt + '(' + IntToStr(Length(ListRec)) + ')';
  end;

 Tmp.InsertControl(ListV);

 pcResult.ActivePage := Tmp;
end;

end.

