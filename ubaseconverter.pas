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
unit uBaseConverter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls, StdCtrls, SynEdit;

type

  { TfBaseConverter }

  TfBaseConverter = class(TForm)
    Button1: TButton;
    InsBin: TSpeedButton;
    InsDec: TSpeedButton;
    InsHex: TSpeedButton;
    InsOct: TSpeedButton;
    leBin: TLabeledEdit;
    leDec: TLabeledEdit;
    leHex: TLabeledEdit;
    leOct: TLabeledEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InsBinClick(Sender: TObject);
    procedure InsDecClick(Sender: TObject);
    procedure InsHexClick(Sender: TObject);
    procedure InsOctClick(Sender: TObject);
    procedure leBinKeyPress(Sender: TObject; var Key: char);
    procedure leDecKeyPress(Sender: TObject; var Key: char);
    procedure leHexKeyPress(Sender: TObject; var Key: char);
    procedure leOctKeyPress(Sender: TObject; var Key: char);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { private declarations }
    Function DecToHex(aValue : LongInt) : String;
    Function HexToDec(aValue : String) : LongInt;

    Function DecToBin(aValue : LongInt) : String;
    Function BinToDec(aValue : String) : LongInt;

    Function DecToOct(aValue : LongInt) : String;
    Function OctToDec(aValue : String) : LongInt;
  public
    { public declarations }
    WorkSyn : TSynEdit;
  end;

var
  fBaseConverter: TfBaseConverter;

implementation

{$R *.lfm}

{ TfBaseConverter }

procedure TfBaseConverter.FormCreate(Sender: TObject);
begin
 WorkSyn := Nil;
end;

procedure TfBaseConverter.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TfBaseConverter.FormShow(Sender: TObject);
begin
 InsDec.Enabled := Not (WorkSyn = Nil);
 InsBin.Enabled := Not (WorkSyn = Nil);
 InsHex.Enabled := Not (WorkSyn = Nil);
end;

procedure TfBaseConverter.InsBinClick(Sender: TObject);
begin
 WorkSyn.InsertTextAtCaret(leBin.Text);
end;

procedure TfBaseConverter.InsDecClick(Sender: TObject);
begin
 WorkSyn.InsertTextAtCaret(leDec.Text);
end;

procedure TfBaseConverter.InsHexClick(Sender: TObject);
begin
 WorkSyn.InsertTextAtCaret(leHex.Text);
end;

procedure TfBaseConverter.InsOctClick(Sender: TObject);
begin
 WorkSyn.InsertTextAtCaret(leOct.Text);
end;

procedure TfBaseConverter.leBinKeyPress(Sender: TObject; var Key: char);
begin
 If Not (Key In [#8, #48..#49]) Then
  Key := #0;
end;

procedure TfBaseConverter.leDecKeyPress(Sender: TObject; var Key: char);
begin
 If Not (Key In [#8, #48..#57]) Then
  Key := #0;
end;

procedure TfBaseConverter.leHexKeyPress(Sender: TObject; var Key: char);
begin
 If Not (Key In [#8, #48..#57, #65..#70, #97..#102]) Then
  Key := #0;
end;

procedure TfBaseConverter.leOctKeyPress(Sender: TObject; var Key: char);
begin
 If Not (Key In [#8, #48..#55]) Then
  Key := #0;
end;

procedure TfBaseConverter.SpeedButton1Click(Sender: TObject);
begin
 leBin.Text := DecToBin(StrToInt(leDec.Text));
 leHex.Text := DecToHex(StrToInt(leDec.Text));
 leOct.Text := DecToOct(StrToInt(leDec.Text));
end;

procedure TfBaseConverter.SpeedButton2Click(Sender: TObject);
 Var Test : LongInt;
begin
 Test := BinToDec(leBin.Text);

 leHex.Text := DecToHex(Test);
 leDec.Text := IntToStr(Test);
 leOct.Text := DecToOct(Test);
end;

procedure TfBaseConverter.SpeedButton3Click(Sender: TObject);
begin
 leDec.Text := IntToStr(HexToDec(leHex.Text));
 leBin.Text := DecToBin(StrToInt(leDec.Text));
 leOct.Text := DecToOct(StrToInt(leDec.Text));
end;

procedure TfBaseConverter.SpeedButton4Click(Sender: TObject);
begin
 leDec.Text := IntToStr(OctToDec(leOct.Text));
 leBin.Text := DecToBin(StrToInt(leDec.Text));
 leHex.Text := DecToHex(StrToInt(leDec.Text));
end;

function TfBaseConverter.DecToHex(aValue: LongInt): String;
 Var W : Array [1..2] Of Word Absolute aValue;
     St : String;

 Function HexByte(B : Byte): String;
  Const Hex : Array [$0..$F] Of Char = '0123456789ABCDEF';
 Begin
  Result := Hex[B Shr 4] + Hex[B And $F];
 End;

 Function HexWord(W: Word): String;
 Begin
  Result := HexByte(Hi(W)) + HexByte(Lo(W));
 End;

begin
 St := HexWord(W[2]) + HexWord(W[1]);

 While (St[1] = '0') And (Length(St) > 1) Do
  Delete(St, 1, 1);

 Result := St;
end;

function TfBaseConverter.HexToDec(aValue: String): LongInt;
 Var L : LongInt;
     B : Byte;
begin
 Result := 0;

 If Length(aValue) <> 0 Then
  Begin
   L := 1;
   B := Length(aValue) + 1;

   Repeat
    Dec(B);

    If aValue[B] <= '9' Then
     Result := Result + (Byte(aValue[B]) - 48) * L
    Else
     Result := Result + (Byte(aValue[B]) - 55) * L;

    L := L * 16;
   Until B = 1;
  End;
end;

function TfBaseConverter.DecToBin(aValue: LongInt): String;
 Var W : Array [1..2] Of Word Absolute aValue;
     St : String;

 Function BinByte(B: Byte) : String;
  Const Bin : Array [False..True] Of Char = '01';
 Begin
  Result := Bin[B And 128 = 128] + Bin[B And 64 = 64] + Bin[B And 32 = 32] +
            Bin[B And 16 = 16] + Bin[B And 8 = 8] + Bin[B And 4 = 4] +
            Bin[B And 2 = 2] + Bin[B And 1 = 1];
 End;

 Function BinWord(W: Word) : String;
 Begin
  Result := BinByte(Hi(W)) + BinByte(Lo(W));
 End;

begin
 St := BinWord(W[2]) + BinWord(W[1]);

 While (St[1] = '0') And (Length(St) > 1) Do
  Delete(St, 1, 1);

 Result := St;
end;

function TfBaseConverter.BinToDec(aValue: String): LongInt;
 Var L : LongInt;
     B : Byte;
begin
 Result := 0;

 If Length(aValue) = 0 Then
  Exit;

 L := 1;
 B := Length(aValue) + 1;

 Repeat
  Dec(B);

  If aValue[B] = '1' Then
   Result := Result + L;

  L := L Shl 1;
 Until B = 1;
end;

function TfBaseConverter.DecToOct(aValue: LongInt): String;
 Var Rest : Longint;
begin
 Result := '';

 While aValue <> 0 Do
  Begin
   Rest := aValue Mod 8;
   aValue := aValue Div 8;

   Result := IntToStr(Rest) + Result;
  end;
end;

function TfBaseConverter.OctToDec(aValue: String): LongInt;

 Function IntPower(Const N, K : Integer) : Integer;
  Var I : Integer;
 Begin
  Result := 1;

  For I := 1 To K Do
   Result := Result * N;
 end;

 Var Ind : Integer;
begin
 Result := 0;

 For Ind := 1 To Length(aValue) Do
  Inc(Result, StrToInt(aValue[Ind]) * IntPower(8, Length(aValue) - Ind));
end;

end.

