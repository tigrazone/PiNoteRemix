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

unit uCreateBanner;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  uEditor, uBanner;

type

  { TfCreateBanner }

  TfCreateBanner = class(TForm)
    bInsert: TButton;
    Button1: TButton;
    Button2: TButton;
    cbInsComment: TCheckBox;
    cbBlkComments: TCheckBox;
    Label1: TLabel;
    lePrintDot: TLabeledEdit;
    lePrintSpace: TLabeledEdit;
    leBanner: TLabeledEdit;
    mOutput: TMemo;
    procedure bInsertClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure leBannerChange(Sender: TObject);
    procedure lePrintDotChange(Sender: TObject);
    procedure lePrintSpaceChange(Sender: TObject);
  private
    pBanner : TBanner;
  public
    ActiveEditor : TEditor;
  end;

var
  fCreateBanner: TfCreateBanner;

implementation

Uses ClipBrd;

{$R *.lfm}

{ TfCreateBanner }

procedure TfCreateBanner.FormCreate(Sender: TObject);
begin
 pBanner := TBanner.Create;

 lePrintDot.Text := pBanner.OutChar;
 lePrintSpace.Text := pBanner.SpaceChar;
end;

procedure TfCreateBanner.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TfCreateBanner.bInsertClick(Sender: TObject);
begin
 If mOutput.Text <> '' Then
  Begin
   ActiveEditor.sEdit.BeginUpdate(True);

   If cbInsComment.Checked Then
    ActiveEditor.InsertComment(mOutput.Text, cbBlkComments.Checked)
   Else
    ActiveEditor.sEdit.InsertTextAtCaret(mOutput.Text);

   ActiveEditor.sEdit.EndUpdate;

   Close;
  end;
end;

procedure TfCreateBanner.Button2Click(Sender: TObject);
begin
 If mOutput.Text <> '' Then
  Begin
   Clipboard.Clear;

   Clipboard.AsText := mOutput.Text;
  end;
end;

procedure TfCreateBanner.FormDestroy(Sender: TObject);
begin
 pBanner.Free;
end;

procedure TfCreateBanner.FormShow(Sender: TObject);
begin
 mOutput.Font := ActiveEditor.sEdit.Font;
 mOutput.Color := ActiveEditor.sEdit.Color;

 leBanner.SetFocus;
end;

procedure TfCreateBanner.leBannerChange(Sender: TObject);
begin
 mOutput.Clear;

 pBanner.StringToPrint := leBanner.Text;

 mOutput.Text := pBanner.BannerText;
end;

procedure TfCreateBanner.lePrintDotChange(Sender: TObject);
begin
 pBanner.OutChar := lePrintDot.Text;

 If lePrintSpace.Text <> '' Then
  lePrintSpace.Text := StringOfChar(lePrintSpace.Text[1], Length(lePrintDot.Text))
 Else
  lePrintSpace.Text := ' ';

 leBannerChange(Sender);
end;

procedure TfCreateBanner.lePrintSpaceChange(Sender: TObject);
begin
 pBanner.SpaceChar := lePrintSpace.Text;

 leBannerChange(Sender);
end;

end.

