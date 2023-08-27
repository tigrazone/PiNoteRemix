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
unit uCRC32SignFile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, uEditor;

type

  { TfCRC32SignFile }

  TfCRC32SignFile = class(TForm)
    bInsert: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DestMemo: TMemo;
    GroupBox1: TGroupBox;
    OpenFile: TOpenDialog;
    OrigMemo: TMemo;
    procedure bInsertClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    ActiveEditor : TEditor;
  end;

var
  fCRC32SignFile: TfCRC32SignFile;

implementation

Uses uMyCRC, ClipBrd, uMain;

{$R *.lfm}

{ TfCRC32SignFile }

procedure TfCRC32SignFile.Button3Click(Sender: TObject);
begin
 Close;
end;

procedure TfCRC32SignFile.FormCreate(Sender: TObject);
begin
 ActiveEditor := Nil;
end;

procedure TfCRC32SignFile.FormShow(Sender: TObject);
begin
 bInsert.Enabled := ActiveEditor <> Nil;
end;

procedure TfCRC32SignFile.Button1Click(Sender: TObject);
 Var Ind : Integer;
     dLine : String;
begin
 If OpenFile.Execute Then
  Begin
   OrigMemo.Clear;
   DestMemo.Clear;

   For Ind := 0 To OpenFile.Files.Count - 1 Do
    Begin
     OrigMemo.Lines.Add(OpenFile.Files[Ind]);

     dLine := IntToHex(CrcFile(OpenFile.Files[Ind]), 8);

     dLine := dLine  + '  ' + ExtractFileName(OpenFile.Files[Ind]);

     DestMemo.Lines.Add(dLine);
    end;
  end;
end;

procedure TfCRC32SignFile.bInsertClick(Sender: TObject);
begin
 If DestMemo.Text <> '' Then
  ActiveEditor.sEdit.InsertTextAtCaret(Trim(DestMemo.Text));
end;

procedure TfCRC32SignFile.Button2Click(Sender: TObject);
begin
 If DestMemo.Text <> '' Then
  Begin
   Clipboard.Clear;

   Clipboard.AsText := DestMemo.Text;

   If Main.gbClipboardPanel.Visible Then
    Main.InsertIntoClipboardPanel(DestMemo.Text);
  end;
end;

end.

