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
unit uCRC32Sign;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, uEditor;

type

  { TfCRC32Sign }

  TfCRC32Sign = class(TForm)
    bInsert: TButton;
    Button1: TButton;
    Button2: TButton;
    cbSeparatedLines: TCheckBox;
    DestMemo: TMemo;
    GroupBox1: TGroupBox;
    OrigMemo: TMemo;
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
  fCRC32Sign: TfCRC32Sign;

implementation

Uses uMyCRC, ClipBrd, uMain;

{$R *.lfm}

{ TfCRC32Sign }

procedure TfCRC32Sign.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TfCRC32Sign.bInsertClick(Sender: TObject);
begin
 If DestMemo.Text <> '' Then
  ActiveEditor.sEdit.InsertTextAtCaret(Trim(DestMemo.Text));
end;

procedure TfCRC32Sign.Button2Click(Sender: TObject);
begin
 If DestMemo.Text <> '' Then
  Begin
   Clipboard.Clear;

   Clipboard.AsText := DestMemo.Text;

   If Main.gbClipboardPanel.Visible Then
    Main.InsertIntoClipboardPanel(DestMemo.Text);
  end;
end;

procedure TfCRC32Sign.cbSeparatedLinesChange(Sender: TObject);
begin
 OrigMemoChange(Sender);
end;

procedure TfCRC32Sign.FormCreate(Sender: TObject);
begin
 ActiveEditor := Nil;
end;

procedure TfCRC32Sign.FormShow(Sender: TObject);
begin
 bInsert.Enabled := ActiveEditor <> Nil;
end;

procedure TfCRC32Sign.OrigMemoChange(Sender: TObject);
 Var OneString : String;
     Ind : Integer;
begin
 If Not cbSeparatedLines.Checked Then
  Begin
   DestMemo.Clear;

   If OrigMemo.Text <> '' Then
    Begin
     OneString := OrigMemo.Text;

     DestMemo.Text := IntToHex(CrcString(OneString), 8);
    end;
  end
 Else
  Begin
   DestMemo.Clear;

   If OrigMemo.Text <> '' Then
    For Ind := 0 To OrigMemo.Lines.Count - 1 Do
     Begin
      OneString := OrigMemo.Lines[Ind];

      DestMemo.Lines.Add(IntToHex(CrcString(OneString), 8));
     end;
  end;
end;

end.

