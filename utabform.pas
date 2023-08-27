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
unit uTabForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ComCtrls, Forms, Controls, Dialogs;

Type

  { TTabForm }

  TTabForm                     = Class(TTabSheet)
    Private
      ParentPageControl        : TPageControl;

      Procedure TSShow(Sender: TObject);

    Public
      ParentForm               : TForm;

      Constructor Create(AOwner : TComponent); Override;
      Destructor Destroy; Override;

      Procedure InsertForm(UserForm : TForm);
  end;

implementation

Uses uEditor;

{ TTabForm }

procedure TTabForm.TSShow(Sender: TObject);
begin
 (Sender As TTabForm).PageControl.Color := (Sender As TTabForm).Color;
end;

constructor TTabForm.Create(AOwner: TComponent);
begin
 ParentPageControl := TPageControl(AOwner);
 ParentForm := Nil;

 inherited Create(AOwner);
end;

destructor TTabForm.Destroy;
begin
 If Self.ParentForm <> Nil Then
  Begin
   Self.ParentForm.Release;
   Self.ParentForm := Nil;
  end;

 inherited Destroy;
end;

procedure TTabForm.InsertForm(UserForm: TForm);
 Var ts : TTabForm;
begin
 ts := TTabForm.Create(ParentPageControl);
 ts.ParentForm := UserForm;

 ts.PageControl := ParentPageControl;
 ts.ParentForm.Parent := ts;
 ts.ParentForm.Align := alClient;
 ts.ParentForm.BorderStyle := bsNone;
 ts.ParentForm.Visible := True;
 ts.ParentForm.Caption := UserForm.Caption;
 ts.Color := UserForm.Color;
 ts.PageControl.Color := UserForm.Color;

 ts.OnShow := @TSShow;

 ParentPageControl.ActivePage := ts;
 ParentPageControl.Visible := True;

 If (UserForm Is TEditor) Then
  Begin
   (UserForm As TEditor).EditorTabSheet := ts;

   (UserForm As TEditor).StartUpEditor;
  end;
end;

end.

