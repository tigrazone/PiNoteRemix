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
unit uExtTOut;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfExtTOut }

  TfExtTOut = class(TForm)
    Button1: TButton;
    CloseBtn: TButton;
    Command: TStaticText;
    ETOut: TMemo;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fExtTOut: TfExtTOut;

implementation

{$R *.lfm}

{ TfExtTOut }

procedure TfExtTOut.CloseBtnClick(Sender: TObject);
begin
 Self.Free;
end;

procedure TfExtTOut.Button1Click(Sender: TObject);
begin
 If ETOut.Lines.Count > 0 Then
  If SaveDialog1.Execute Then
   ETOut.Lines.SaveToFile(SaveDialog1.FileName);
end;

end.

