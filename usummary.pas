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
unit uSummary;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfSummary }

  TfSummary = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    mfPath: TMemo;
    sTextLen1: TStaticText;
    sTextLen2: TStaticText;
    sFileSize: TStaticText;
    sFileDate: TStaticText;
    sTextLines: TStaticText;
    sTotalWords: TStaticText;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  fSummary: TfSummary;

implementation

{$R *.lfm}

{ TfSummary }

procedure TfSummary.Button1Click(Sender: TObject);
begin
 Close;
end;

end.

