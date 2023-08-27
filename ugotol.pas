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
unit uGotoL;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls;

type

  { TGotoL }

  TGotoL = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    LineNumber: TLabeledEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LineNumberKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LineNumberKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
    Ret : Boolean;
  end;

var
  GotoL: TGotoL;

implementation

{$R *.lfm}

{ TGotoL }

procedure TGotoL.FormCreate(Sender: TObject);
begin
 Ret := False;
end;

procedure TGotoL.FormShow(Sender: TObject);
begin
 LineNumber.SetFocus;
end;

procedure TGotoL.LineNumberKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If Key = 13 Then
  BitBtn2Click(Sender);
end;

procedure TGotoL.BitBtn2Click(Sender: TObject);
begin
 If Trim(LineNumber.Text) <> '' Then
  Begin
   Ret := True;

   Close;
  End;
end;

procedure TGotoL.BitBtn1Click(Sender: TObject);
begin
 Close;
end;

procedure TGotoL.LineNumberKeyPress(Sender: TObject; var Key: char);
begin
 If Not (Key In [#8, #13, #48..#57]) Then
  Key := #0;
end;

end.

