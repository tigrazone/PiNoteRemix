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
unit uQueryEditedFiles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TfQueryEditedFiles }

  TfQueryEditedFiles = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Label1: TLabel;
    lbEditedDoc: TListBox;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    ResultType : Byte;
  end;

var
  fQueryEditedFiles: TfQueryEditedFiles;

implementation

{$R *.lfm}

{ TfQueryEditedFiles }

procedure TfQueryEditedFiles.FormCreate(Sender: TObject);
begin
 ResultType := 0;
end;

procedure TfQueryEditedFiles.BitBtn1Click(Sender: TObject);
begin
 Close;
end;

procedure TfQueryEditedFiles.BitBtn3Click(Sender: TObject);
begin
 ResultType := 1;

 Close;
end;

procedure TfQueryEditedFiles.BitBtn4Click(Sender: TObject);
begin
 ResultType := 2;

 Close;
end;

end.

