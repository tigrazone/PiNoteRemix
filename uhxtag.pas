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
unit uHXTag;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TfHXTag }

  TfHXTag = class(TForm)
    Button1: TButton;
    Button2: TButton;
    leOpening: TLabeledEdit;
    leClosing: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure leOpeningChange(Sender: TObject);
  private
    { private declarations }

    Procedure CreateClosingTag;
  public
    { public declarations }
    Ret : Boolean;
  end;

var
  fHXTag: TfHXTag;

implementation

{$R *.lfm}

{ TfHXTag }

procedure TfHXTag.FormCreate(Sender: TObject);
begin
 Ret := False;
end;

procedure TfHXTag.FormShow(Sender: TObject);
begin
 leOpening.SetFocus;
end;

procedure TfHXTag.leOpeningChange(Sender: TObject);
begin
 CreateClosingTag;
end;

procedure TfHXTag.CreateClosingTag;
 Var Tmp : String;
begin
 If Trim(leOpening.Text) <> '' Then
  If Pos('<', leOpening.Text) <> 0 Then
   If Pos('>', leOpening.Text) <> 0 Then
    Begin
     Tmp := leOpening.Text;
     Tmp := StringRePlace(Tmp, '<', '', [rfReplaceAll]);
     Tmp := StringRePlace(Tmp, '>', '', [rfReplaceAll]);

     leClosing.Text := '</' + Tmp + '>';
    end;
end;

procedure TfHXTag.Button2Click(Sender: TObject);
begin
 Close;
end;

procedure TfHXTag.Button1Click(Sender: TObject);
begin
 Ret := True;

 Close;
end;

end.

