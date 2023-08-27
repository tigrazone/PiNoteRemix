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
unit uExtTools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Process, IniFiles, Forms;

Const
     ExtToolsFile               = 'PiNoteExtTools.ini';

     SectionExternalTools       = 'ExternalTools';
     SectionExternalToolParam   = 'ExternalTool';

     KeyExternalToolID          = 'KeyExternalToolID';
     KeyExternalToolCmd         = 'ExternalToolCmd';
     KeyExternalToolArgs        = 'ExternalToolArgs';
     KeyExternalToolWrD         = 'ExternalToolWrD';
     KeyExternalToolCapture     = 'ExternalToolCapture';


Type
    ExtToolsRecord            = Record
     Command                  : String;
     Arguments                : String;
     WorkDir                  : String;
     Capture                  : Boolean;
    End;

Var
   ExtToolsArray        : Array [0..23] Of Integer;

Procedure Init_ExtToolsArray;
Procedure Load_ExtToolsArray;

Function Get_ExtToolsValue(IDKEY : Integer) : ExtToolsRecord;
Procedure Set_ExtToolsValue(IDKEY : Integer; Values : ExtToolsRecord);
Procedure Execute_External_Tool(IDKEY : Integer; FileName, PrjFolder : String);

implementation

Uses uExtTOut, uMain, LazFileUtils;

procedure Init_ExtToolsArray;
 Var Ind : Word;
begin
 For Ind := 0 To 23 Do
  ExtToolsArray[Ind] := -1;
end;

procedure Load_ExtToolsArray;
 Var eF : TIniFile;
     Ind, Tmp : Integer;
begin
 Init_ExtToolsArray;

 //eF := TIniFile.Create(ExtractFilePath(Application.ExeName) + ExtToolsFile);
 eF := TIniFile.Create(AppendPathDelim(Main.PiNoteOptionsPath) + ExtToolsFile);

 For Ind := 0 To 23 Do
  Begin
   Tmp := eF.ReadInteger(SectionExternalToolParam + IntToStr(Ind), KeyExternalToolID, -1);

   If Tmp > -1 Then
    ExtToolsArray[Tmp] := Tmp;
  end;

 eF.Free;
end;

function Get_ExtToolsValue(IDKEY: Integer): ExtToolsRecord;
 Var eF : TIniFile;
begin
 //eF := TIniFile.Create(ExtractFilePath(Application.ExeName) + ExtToolsFile);
 eF := TIniFile.Create(AppendPathDelim(Main.PiNoteOptionsPath) + ExtToolsFile);

 Result.Arguments := eF.ReadString(SectionExternalToolParam + IntToStr(IDKEY), KeyExternalToolArgs, '');
 Result.Command := eF.ReadString(SectionExternalToolParam + IntToStr(IDKEY), KeyExternalToolCmd, '');
 Result.WorkDir := eF.ReadString(SectionExternalToolParam + IntToStr(IDKEY), KeyExternalToolWrD, '');
 Result.Capture := eF.ReadBool(SectionExternalToolParam + IntToStr(IDKEY), KeyExternalToolCapture, False);

 eF.Free;
end;

Function Build_Command(Const ValC : String; FName, PFolder : String) : String;
 Var Ind, App : Word;
     SubStr, Tmp : String;
Begin
 Ind := 1;
 Result := '';

 While Ind <= Length(ValC) Do
  Begin
   If (ValC[Ind] = '$') And (ValC[Ind + 1] = '[') Then
    Begin
     SubStr := '';

     While (ValC[Ind] <> ']') And (Ind <= Length(ValC)) Do
      Begin
       SubStr := SubStr + ValC[Ind];

       Inc(Ind);
      End;

     SubStr := SubStr + ValC[Ind];

     If SubStr = '$[FileDir]' Then
      Result := Result + ExtractFilePath(FName)
     Else
      If SubStr = '$[FileName]' Then
       Result := Result + ExtractFileName(FName)
      Else
       If SubStr = '$[ShortFileName]' Then
        Begin
         Tmp := ExtractFileName(FName);

         For App := 1 To Pos('.', Tmp) - 1 Do
          Result := Result + Tmp[App];
        End
       Else
        If SubStr = '$[FileExt]' Then
         Result := Result + ExtractFileExt(FName)
        Else
         If SubStr = '$[ProjectDir]' Then
          Result := Result + PFolder;
    End
   Else
    Result := Result + ValC[Ind];

   Inc(Ind);
  End;
End;

Procedure Run_External_Tool_No_Capture(Cmd, Args, WrkD : String);
 Var P : TProcess;
Begin
 P := TProcess.Create(Nil);

 P.Executable := Cmd;
 P.Parameters.Delimiter := ' ';
 P.Parameters.StrictDelimiter := True;
 P.Parameters.DelimitedText := Args;

 If WrkD <> '' Then
  If DirectoryExists(WrkD) Then
   P.CurrentDirectory := WrkD;

 P.ShowWindow := swoShowNormal;

 P.Execute;
End;

Procedure Run_External_Tool_Capture(Cmd, Args, WrkD : String);

 Const
      READ_BYTES = 2048;

 Var P : TProcess;
     M : TMemoryStream;
     S : TStringList;
     OutWin : TfExtTOut;
     BytesRead, N : LongInt;
Begin
 P := TProcess.Create(Nil);

 P.Executable := Cmd;
 P.Parameters.Delimiter := ' ';
 P.Parameters.StrictDelimiter := True;
 P.Parameters.DelimitedText := Args;

 If WrkD <> '' Then
  If DirectoryExists(WrkD) Then
   P.CurrentDirectory := WrkD;

 P.ShowWindow := swoShowNormal;
 P.Options := [poUsePipes, poStderrToOutPut];

 OutWin := TfExtTOut.Create(Main);
 OutWin.Command.Caption := ' ' + Cmd;
 OutWin.Show;

 M := TMemoryStream.Create;
 BytesRead := 0;

 P.Execute;

 While P.Running Do
  Begin
   M.SetSize(BytesRead + READ_BYTES);

   N := P.Output.Read((M.Memory + BytesRead)^, READ_BYTES);

   If N > 0 Then
    Inc(BytesRead, N)
   Else
    Sleep(100);
  End;

 Repeat
  M.SetSize(BytesRead + READ_BYTES);

  N := P.Output.Read((M.Memory + BytesRead)^, READ_BYTES);

  If N > 0 Then
   Inc(BytesRead, N);
 Until N <= 0;

 M.SetSize(BytesRead);

 S := TStringList.Create;
 S.LoadFromStream(M);

 For N := 0 To S.Count - 1 Do
  OutWin.ETOut.Lines.Add(S[n]);

 S.Free;
 M.Free;

 OutWin.SetFocus;

 P.Free;
End;

procedure Set_ExtToolsValue(IDKEY: Integer; Values: ExtToolsRecord);
 Var eF : TIniFile;
begin
 //eF := TIniFile.Create(ExtractFilePath(Application.ExeName) + ExtToolsFile);
 eF := TIniFile.Create(AppendPathDelim(Main.PiNoteOptionsPath) + ExtToolsFile);

 ExtToolsArray[IDKEY] := IDKEY;

 eF.WriteInteger(SectionExternalToolParam + IntToStr(IDKEY), KeyExternalToolID, IDKEY);
 eF.WriteString(SectionExternalToolParam + IntToStr(IDKEY), KeyExternalToolArgs, Values.Arguments);
 eF.WriteString(SectionExternalToolParam + IntToStr(IDKEY), KeyExternalToolCmd, Values.Command);
 eF.WriteString(SectionExternalToolParam + IntToStr(IDKEY), KeyExternalToolWrD, Values.WorkDir);
 eF.WriteBool(SectionExternalToolParam + IntToStr(IDKEY), KeyExternalToolCapture, Values.Capture);

 eF.UpdateFile;

 eF.Free;
end;

procedure Execute_External_Tool(IDKEY: Integer; FileName, PrjFolder: String);
 Var ET : ExtToolsRecord;
     lArguments, lWorkingDir : String;
begin
 ET := Get_ExtToolsValue(IDKEY);

 lArguments := Build_Command(ET.Arguments, FileName, PrjFolder);
 lWorkingDir := Build_Command(ET.WorkDir, FileName, PrjFolder);

 If Not ET.Capture Then
  Run_External_Tool_No_Capture(ET.Command, lArguments, lWorkingDir)
 Else
  Run_External_Tool_Capture(ET.Command, lArguments, lWorkingDir);
end;

end.

