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
unit uInsNumbering;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, SynEdit;

type

  { TfInsNumbering }

  TfInsNumbering = class(TForm)
    Button1: TButton;
    Button2: TButton;
    cbCapital: TCheckBox;
    cbRestart: TCheckBox;
    cbSkip: TCheckBox;
    FirstLine: TLabeledEdit;
    Increment: TLabeledEdit;
    NumLines: TLabeledEdit;
    rgType: TRadioGroup;
    txAfter: TLabeledEdit;
    txBefore: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rgTypeSelectionChanged(Sender: TObject);
  private
    { private declarations }

    Function CheckInt(Val : String) : Boolean;
    Function OctToInt(Val : String) : Longint;
    Function BinToInt(Val : String) : Longint;

    Function IntToOct(Val : Longint; Digits : Word) : String;
    Function IntToBin(Val : Longint; Digits : Word) : String;
  public
    { public declarations }
    Editor: TSynEdit;
    StartLine : Integer;
    EndLine : Integer;
  end;

var
  fInsNumbering: TfInsNumbering;

implementation

{$R *.lfm}

{ TfInsNumbering }

procedure TfInsNumbering.FormCreate(Sender: TObject);
begin
 Editor := Nil;
end;

procedure TfInsNumbering.FormShow(Sender: TObject);
begin
 If Editor <> Nil Then
  Begin
   FirstLine.Text := '1';
   Increment.Text := '1';

   NumLines.Text := IntToStr((EndLine - StartLine) + 1);

   rgType.ItemIndex := 1;
  end;
end;

procedure TfInsNumbering.rgTypeSelectionChanged(Sender: TObject);
begin
 cbCapital.Enabled := rgType.ItemIndex = 4;
end;

function TfInsNumbering.CheckInt(Val: String): Boolean;
begin
 Try
   StrToInt(Val);
   Result := True;
 Except
   Result := False;
 end;
end;

function TfInsNumbering.OctToInt(Val: String): Longint;
 Var Ind : Word;
begin
 Result := 0;

 If Val = '' Then
  Exit;

 For Ind := 1 To Length(Val) Do
  Result := Result * 8 + StrToInt(Copy(Val, Ind, 1));
end;

function TfInsNumbering.BinToInt(Val: String): Longint;
 Var Ind, Len : Word;
begin
 Result := 0;

 If Val = '' Then
  Exit;

 Len := Length(Val);

 For Ind := Len DownTo 1 Do
  If Val[Ind] = '1' Then
   Result := Result + (1 Shl (Len - Ind));
end;

function TfInsNumbering.IntToOct(Val: Longint; Digits: Word): String;
 Var R : Longint;
     Ind : Word;
begin
 Result := '';

 While (Val <> 0) Do
  Begin
   R := Val Mod 8;
   Val := Val Div 8;

   Result := IntToStr(R) + Result;
  end;

 For Ind := Length(Result) + 1 To Digits Do
  Result := '0' + Result;
end;

function TfInsNumbering.IntToBin(Val: Longint; Digits: Word): String;
 Var Ind : Word;
begin
 Result := '';

 For Ind := Digits DownTo 0 Do
  If Val And (1 Shl Ind) <> 0 Then
   Result := Result + '1'
  Else
   Result := Result + '0';
end;

procedure TfInsNumbering.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TfInsNumbering.Button2Click(Sender: TObject);
 Var PosFix, Linea : String;
     Value, OldVal : Longint;
     Ind : Integer;
begin
 If Editor <> Nil Then
  If StartLine <= EndLine Then
   Begin
    If Not CheckInt(Increment.Text) Then
     Begin
      ShowMessage('Value not valid for increment!');
      Increment.SetFocus;

      Exit;
     end;

    Case rgType.ItemIndex Of
         0                :  If Not CheckInt('$' + FirstLine.Text) Then
                             Begin
                              ShowMessage('Value not valid for first line!');
                              FirstLine.SetFocus;

                              Exit;
                             end;

         1,2,3            : If Not CheckInt(FirstLine.Text) Then
                             Begin
                              ShowMessage('Value not valid for first line!');
                              FirstLine.SetFocus;

                              Exit;
                             end;

         4                 : If FirstLine.Text = '' Then
                              Begin
                               ShowMessage('Value not valid for first line!');
                               FirstLine.SetFocus;

                               Exit;
                              end;
    end;

    PosFix := txBefore.Text;

    Case rgType.ItemIndex Of
           0                : Value := StrToInt('$' + FirstLine.Text);

           1                : Value := StrToInt(FirstLine.Text);

           2                : Value := OctToInt(FirstLine.Text);

           3                : Value := BinToInt(FirstLine.Text);

           4                : Value := Ord(FirstLine.Text[1]);
    end;

    OldVal := Value;

    For Ind := StartLine To EndLine Do
     Begin
      Case rgType.ItemIndex Of
           0                : Linea := IntToHex(Value, 1);

           1                : Linea := IntToStr(Value);

           2                : Linea := IntToOct(Value, 1);

           3                : Linea := IntToBin(Value, Length(IntToStr(Value)));

           4                : Linea := Chr(Value);
      end;

      If cbCapital.Checked Then
       Linea := UpperCase(Linea);

      Linea := PosFix + Linea;

      Editor.CaretY := Ind;

      If cbSkip.Checked Then
       If Editor.LineText = '' Then
        Begin
         If cbRestart.Checked Then
          Value := OldVal;

         Continue;
        end;

      Editor.CaretX := 0;

      Editor.InsertTextAtCaret(Linea + txAfter.Text);

      Inc(Value, StrToInt(Increment.Text));
     end;

    Close;
   end;
end;

end.

