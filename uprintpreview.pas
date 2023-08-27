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
unit uPrintPreview;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, MySEPrintPreview2, Printers, MySEPrintPreview;

type

  { TfPrintPreview }

  TfPrintPreview = class(TForm)
    ImageList1: TImageList;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    pmZoom: TPopupMenu;
    StatusBar: TStatusBar;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    Procedure MyPrintPreviewPreviewPage(Sender: TObject; PageNumber: Integer);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    Procedure FitToClick(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
  private
    { private declarations }
    OldFontSize : Integer;
  public
    { public declarations }
    {$Ifdef Windows}
    Preview : TMySEPrintPreview;
    {$else}
    Preview : TSynEditPrintPreview2;
    {$endif}
  end;

var
  fPrintPreview: TfPrintPreview;

implementation

{$R *.lfm}

{ TfPrintPreview }

procedure TfPrintPreview.FormCreate(Sender: TObject);
begin
 {$Ifdef Windows}
 Preview := TMySEPrintPreview.Create(Self);
 {$else}
 Preview := TSynEditPrintPreview2.Create(Self);
 {$endif}

 Self.InsertControl(Preview);

 Preview.Align := alClient;

 {$Ifdef Windows}
 Preview.ScaleMode := pscWholePage;
 {$else}
 Preview.ScaleMode := MySePrintPreview2.pscWholePage;
 {$endif}

 //Preview.ScaleMode := MySePrintPreview2.pscWholePage;
 Preview.OnPreviewPage := @MyPrintPreviewPreviewPage;

 OldFontSize := -1;

 If Printer.Printers.Count > 0 Then
  StatusBar.Panels[1].Text := 'Print on: ' + Printer.Printers[Printer.PrinterIndex];
end;

procedure TfPrintPreview.FormResize(Sender: TObject);
begin
 Preview.Repaint;
end;

procedure TfPrintPreview.FormShow(Sender: TObject);
begin
 If OldFontSize = -1 Then
  Begin
   OldFontSize := Preview.SynEditPrint.Font.Size;

   {$IFDEF WINDOWS}
   //Preview.SynEditPrint.Font.Size := Preview.SynEditPrint.Font.Size * 6;
   {$ENDIF}
  End;

 Preview.UpdatePreview;
 Preview.FirstPage;
end;

procedure TfPrintPreview.MyPrintPreviewPreviewPage(Sender: TObject;
  PageNumber: Integer);
begin
 StatusBar.Panels[0].Text := ' Page ' + IntToStr(Preview.PageNumber) + '/' +
                             IntToStr(Preview.PageCount);
end;

procedure TfPrintPreview.ToolButton1Click(Sender: TObject);
begin
 Preview.FirstPage;
end;

procedure TfPrintPreview.ToolButton2Click(Sender: TObject);
begin
 Preview.PreviousPage;
end;

procedure TfPrintPreview.ToolButton3Click(Sender: TObject);
begin
 Preview.NextPage;
end;

procedure TfPrintPreview.ToolButton4Click(Sender: TObject);
begin
 Preview.LastPage;
end;

procedure TfPrintPreview.FitToClick(Sender: TObject);
begin
 {$Ifdef Windows}
 Preview.ScaleMode := pscWholePage;

 Case (Sender As TMenuItem).Tag Of
      -1         : Preview.ScaleMode := pscWholePage;
      -2         : Preview.ScaleMode := pscPageWidth;
      Else         Preview.ScalePercent := (Sender As TMenuItem).Tag;
 End;
 {$else}
 Preview.ScaleMode := MySePrintPreview2.pscWholePage;
 Case (Sender As TMenuItem).Tag Of
      -1         : Preview.ScaleMode := MySePrintPreview2.pscWholePage;
      -2         : Preview.ScaleMode := MySePrintPreview2.pscPageWidth;
      Else         Preview.ScalePercent := (Sender As TMenuItem).Tag;
 End;
 {$endif}

 Preview.Repaint;
end;

procedure TfPrintPreview.ToolButton8Click(Sender: TObject);
 Var Tmp : Integer;
begin
 Tmp := Preview.SynEditPrint.Font.Size;

 Preview.SynEditPrint.Font.Size := OldFontSize;

 Preview.Print;

 Preview.SynEditPrint.Font.Size := Tmp;
end;

end.

