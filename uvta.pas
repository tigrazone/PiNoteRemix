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
unit uVTA;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls;

type

  { TfVTA }

  TfVTA = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ListView: TListView;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    RetMode : Boolean;
  end;

var
  fVTA: TfVTA;

implementation

{$R *.lfm}

{ TfVTA }

procedure TfVTA.FormCreate(Sender: TObject);
begin
 RetMode := False;

 ListView.Items.Add;
 ListView.Items.Item[0].Caption := '$[FileDir]';
 ListView.Items.Item[0].SubItems.Add('Directory of file in editing.');

 ListView.Items.Add;
 ListView.Items.Item[1].Caption := '$[FileName]';
 ListView.Items.Item[1].SubItems.Add('Current file name with ext.');

 ListView.Items.Add;
 ListView.Items.Item[2].Caption := '$[ShortFileName]';
 ListView.Items.Item[2].SubItems.Add('Current file name without ext.');

 ListView.Items.Add;
 ListView.Items.Item[3].Caption := '$[FileExt]';
 ListView.Items.Item[3].SubItems.Add('Current file extension.');

 //ListView.Items.Add;
 //ListView.Items.Item[4].Caption := '$[ProjectDir]';
 //ListView.Items.Item[4].SubItems.Add('Directory of current project.');
end;

procedure TfVTA.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TfVTA.Button2Click(Sender: TObject);
begin
 RetMode := True;

 Close;
end;

end.

