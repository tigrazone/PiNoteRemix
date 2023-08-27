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
unit uSetExtTools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls, Buttons, ExtCtrls, IniFiles;

type

  { TfSetExtTools }

  TfSetExtTools = class(TForm)
    Arguments: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    cbCapture: TCheckBox;
    Command: TLabeledEdit;
    ExtSC: TComboBox;
    GB: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListView: TListView;
    OpenCommand: TOpenDialog;
    SelDir: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    WorkDir: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListViewClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    { private declarations }
    ExtToolFile : TIniFile;

    Procedure Load_ExtTools();
  public
    { public declarations }
  end;

var
  fSetExtTools: TfSetExtTools;

implementation

Uses uExtTools, uVTA, uMain, LazFileUtils;

{$R *.lfm}

{ TfSetExtTools }

procedure TfSetExtTools.FormCreate(Sender: TObject);
 Var Ind : Integer;
begin
 //ChDir(ExtractFilePath(Application.ExeName));

 //ExtToolFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + ExtToolsFile);

 Load_ExtTools;

 For Ind := 1 To 12 Do
  ExtSC.Items.Add('Shift + Alt + F' + IntToStr(Ind));

 For Ind := 1 To 12 Do
  ExtSC.Items.Add('Shift + Ctrl + F' + IntToStr(Ind));

 GB.Enabled := False;
end;

procedure TfSetExtTools.Button1Click(Sender: TObject);
 Var V : ExtToolsRecord;
begin
 If Get_ExtToolsValue(ExtSC.ItemIndex).Command = '' Then
  Begin
   V.Command := Command.Text;
   V.Arguments := Arguments.Text;
   V.WorkDir := WorkDir.Text;
   V.Capture := cbCapture.Checked;

   Set_ExtToolsValue(ExtSC.ItemIndex, V);

   GB.Enabled := False;

   Load_ExtTools();
  end
 Else
  ShowMessage('Shortcut alredy used...');
end;

procedure TfSetExtTools.Button2Click(Sender: TObject);
begin
 Close;
end;

procedure TfSetExtTools.ListViewClick(Sender: TObject);
 Var V : ExtToolsRecord;
begin
 If Assigned(ListView.Selected) Then
  Begin
   V := Get_ExtToolsValue(StrToInt(ListView.Selected.SubItems.Strings[0]));

   Command.Text := V.Command;
   Arguments.Text := V.Arguments;
   ExtSC.ItemIndex := StrToInt(ListView.Selected.SubItems.Strings[0]);
   WorkDir.Text := V.WorkDir;
   cbCapture.Checked := V.Capture;
  end;
end;

procedure TfSetExtTools.SpeedButton1Click(Sender: TObject);
begin
 GB.Enabled := True;

 Command.Clear;
 Arguments.Clear;
 WorkDir.Text := '';

 ExtSC.ItemIndex := 0;

 Command.SetFocus;
end;

procedure TfSetExtTools.SpeedButton2Click(Sender: TObject);
 Var iK : Integer;
begin
 If Assigned(ListView.Selected) Then
  If MessageDlg('Delete the selected command?', mtWarning, [mbYes, mbCancel], 0) = mrYes Then
   Begin
    iK := StrToInt(ListView.Selected.SubItems.Strings[0]);

    ExtToolFile := TIniFile.Create(AppendPathDelim(Main.PiNoteOptionsPath) + ExtToolsFile);

    ExtToolFile.EraseSection(SectionExternalToolParam + IntToStr(iK));

    ExtToolFile.Free;

    Load_ExtTools();
    Load_ExtToolsArray;
   end;
end;

procedure TfSetExtTools.SpeedButton3Click(Sender: TObject);
begin
 If OpenCommand.Execute Then
  Command.Text := OpenCommand.FileName;
end;

procedure TfSetExtTools.SpeedButton4Click(Sender: TObject);
begin
 fVTA := TfVTA.Create(Self);

 fVTA.ShowModal;

 If fVTA.RetMode Then
  If Assigned(fVTA.ListView.Selected) Then
   Arguments.Text := Arguments.Text + fVTA.ListView.Selected.Caption;

 fVTA.Release;
end;

procedure TfSetExtTools.SpeedButton5Click(Sender: TObject);
begin
 If SelDir.Execute Then
  WorkDir.Text := SelDir.FileName;
end;

procedure TfSetExtTools.Load_ExtTools;
 Var Ind, lPos : Integer;
begin
 ExtToolFile := TIniFile.Create(AppendPathDelim(Main.PiNoteOptionsPath) + ExtToolsFile);

 ListView.Clear;
 lPos := 0;

 For Ind := 0 To 23 Do
  If ExtToolFile.ReadString(SectionExternalToolParam + IntToStr(Ind), KeyExternalToolCmd, '') <> '' Then
   Begin
    ListView.Items.Add;

    ListView.Items.Item[lPos].Caption := ExtToolFile.ReadString(SectionExternalToolParam + IntToStr(Ind), KeyExternalToolCmd, '');
    ListView.Items.Item[lPos].SubItems.Add(IntToStr(Ind));

    Inc(lPos);
   end;

 ExtToolFile.Free;
end;

end.

