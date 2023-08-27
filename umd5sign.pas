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
unit uMD5Sign;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, MD5, uEditor;

type

  { TfMD5Sign }

  TfMD5Sign = class(TForm)
    Button1: TButton;
    Button2: TButton;
    bInsert: TButton;
    cbSeparatedLines: TCheckBox;
    GroupBox1: TGroupBox;
    OrigMemo: TMemo;
    DestMemo: TMemo;
    procedure bInsertClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cbSeparatedLinesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OrigMemoChange(Sender: TObject);
  private

  public
    ActiveEditor : TEditor;
  end;

var
  fMD5Sign: TfMD5Sign;

implementation

Uses ClipBrd, uMain;

{$R *.lfm}

{ TfMD5Sign }

procedure TfMD5Sign.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TfMD5Sign.bInsertClick(Sender: TObject);
begin
 If DestMemo.Text <> '' Then
  ActiveEditor.sEdit.InsertTextAtCaret(Trim(DestMemo.Text));
end;

procedure TfMD5Sign.Button2Click(Sender: TObject);
begin
 If DestMemo.Text <> '' Then
  Begin
   Clipboard.Clear;

   Clipboard.AsText := DestMemo.Text;

   If Main.gbClipboardPanel.Visible Then
    Main.InsertIntoClipboardPanel(DestMemo.Text);
  end;
end;

procedure TfMD5Sign.cbSeparatedLinesChange(Sender: TObject);
begin
 OrigMemoChange(Sender);
end;

procedure TfMD5Sign.FormCreate(Sender: TObject);
begin
 ActiveEditor := Nil;
end;

procedure TfMD5Sign.FormShow(Sender: TObject);
begin
 bInsert.Enabled := ActiveEditor <> Nil;
end;

procedure TfMD5Sign.OrigMemoChange(Sender: TObject);
 Var OneString : String;
     Ind : Integer;
begin
 If Not cbSeparatedLines.Checked Then
  Begin
   DestMemo.Clear;

   If OrigMemo.Text <> '' Then
    Begin
     OneString := OrigMemo.Text;

     DestMemo.Text := MD5Print(MD5String(OneString));
    end;
  end
 Else
  Begin
   DestMemo.Clear;

   If OrigMemo.Text <> '' Then
    For Ind := 0 To OrigMemo.Lines.Count - 1 Do
     Begin
      OneString := OrigMemo.Lines[Ind];

      DestMemo.Lines.Add(MD5Print(MD5String(OneString)));
     end;
  end;
end;

end.

