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
unit uRun;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

Const
     RunListFile                  = 'pinrunlist.txt';
     MAX_CB_ITEMS                 = 20;

type

  { TfRun }

  TfRun = class(TForm)
    Button1: TButton;
    Button2: TButton;
    cbRunList: TComboBox;
    GroupBox1: TGroupBox;
    OpenFile: TOpenDialog;
    SpeedButton1: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cbRunListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    Procedure cbInsertNewItem(Val : String);
  public

  end;

var
  fRun: TfRun;

implementation

Uses Process;

{$R *.lfm}

{ TfRun }

procedure TfRun.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 ChDir(ExtractFilePath(Application.ExeName));

 cbRunList.Items.SaveToFile(RunListFile);
end;

procedure TfRun.cbRunListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If Key = 13 Then
  cbInsertNewItem(cbRunList.Text);
end;

procedure TfRun.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TfRun.Button2Click(Sender: TObject);
 Var P : TProcess;
begin
 If cbRunList.Text <> '' Then
  If FileExists(cbRunList.Text) Then
   Begin
    P := TProcess.Create(Nil);

    P.Executable := cbRunList.Text;
    P.CurrentDirectory := ExtractFilePath(cbRunList.Text);

    P.ShowWindow := swoShowNormal;

    P.Execute;

    Close;
   end
  Else
   ShowMessage('Program to run not found!');
end;

procedure TfRun.FormCreate(Sender: TObject);
begin
 ChDir(ExtractFilePath(Application.ExeName));

 If FileExists(RunListFile) Then
  cbRunList.Items.LoadFromFile(RunListFile);
end;

procedure TfRun.SpeedButton1Click(Sender: TObject);
begin
 If OpenFile.Execute Then
  Begin
   cbRunList.Text := OpenFile.FileName;

   cbInsertNewItem(OpenFile.FileName);
  end;
end;

procedure TfRun.cbInsertNewItem(Val: String);
begin
 If cbRunList.Text = '' Then
  Exit;

 If cbRunList.Items.IndexOf(cbRunList.Text) > -1 Then
  Exit;

 If cbRunList.Items.Count < MAX_CB_ITEMS Then
  cbRunList.Items.Add(Val)
 Else
  Begin
   cbRunList.Items.Delete(0);

   cbRunList.Items.Add(Val);
  end;
end;

end.

