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
unit Tools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, FileUtil, SynEdit;

type
    TDisplayProc        = Procedure(Const S: String) Of Object;

Function LRot32(X: DWord; C: Integer): DWord;
Function RRot32(X: DWord; C: Integer): DWord;
Procedure XorBlock(I1, I2, O1: PByteArray; Len : Integer);
Procedure IncBlock(P : PByteArray; Len : Integer);

Function CountWords(Const S : String ) : Integer;

Procedure ShowBinary(Var Data; Count: Cardinal; DispProc: TDisplayProc);

Function RGB2HTMLColor(Value : TColor): String;
Function CapitalizeString(S : String) : String;

Procedure MyDeleteFile(PathF : String);

Procedure SaveScreenShot(SE : TSynEdit; FileName : String; OrigCanvas : TCanvas);

implementation

Const
     TAB        = #09;
     CR         = #13;
     LF         = #10;
     SEPARATORS = [' ', '.', ',', '!', '?',';',':', '''', '"', '(', ')',
                   '[', ']', '{', '}', TAB, CR, LF ];

function LRot32(X: DWord; C: Integer): DWord;
Begin
 Result := (X Shl C) Or (X Shr (32 - C));
End;

function RRot32(X: DWord; C: Integer): DWord;
Begin
 Result := (X Shr C) Or (X Shl (32 - C));
End;

Procedure XorBlock(I1, I2, O1: PByteArray; Len : Integer);
 Var I : Integer;
Begin
 For I := 0 To Len - 1 Do
  O1^[I] := I1^[I] Xor I2^[I];
End;

Procedure IncBlock(P : PByteArray; Len : Integer);
Begin
 Inc(P^[Len - 1]);

 If (P^[Len - 1] = 0) And (Len > 1) Then
  IncBlock(P, Len - 1);
End;

Procedure ScrollThroughDelims(S : String; Var I : Integer);
Begin
 While (S[I] In SEPARATORS) And (I <= Length(S)) Do
  Inc(I);
End;

Procedure ScrollThroughWord(S : String; Var W : String; Var I : Integer);
Begin
 W := '';

 While (Not (S[I] In SEPARATORS)) And (I <= Length(S)) Do
  Begin
   W := W + S[I];

   Inc(I);
  End;
End;

function CountWords(const S: String): Integer;
 Var I, WordNum : Integer;
     W : String;
begin
 I := 1;
 WordNum := 0;
 W := '';

 While (I <= Length(S)) Do
  Begin
   ScrollThroughDelims(S, I);

   ScrollThroughWord(S, W, I);

   If (Length(W) > 0) Then
    Inc(WordNum);
  End;

 Result := WordNum;
end;

procedure ShowBinary(var Data; Count: Cardinal; DispProc: TDisplayProc);
Const PosStart           = 1;
      BinStart           = 7;
      AscStart           = 57;
      HexChars           : PChar = '0123456789ABCDEF';

 Var Line : String[80];
     I : Cardinal;
     P : PChar;
     nStr : String[4];
begin
 P := @Data;
 Line := '';

 For I := 0 To Count - 1 Do
  Begin
   If (I Mod 16) = 0 Then
    Begin
     If Length(Line) > 0 Then
      DispProc(Line);

     FillChar(Line, SizeOf(Line), ' ');

     Line[0] := Chr(72);

     nStr := Format('%4.4X', [I]);

     Move(nStr[1], Line[PosStart], Length(nStr));

     Line[PosStart + 4] := ':';
    End;

   If P[I] >= ' ' Then
    Line[I Mod 16 + AscStart] := P[I]
   Else
    Line[I Mod 16 + AscStart] := '.';

   Line[BinStart + 3 * (I Mod 16)] := HexChars[(Ord(P[I]) Shr 4) And $F];
   Line[BinStart + 3 * (I Mod 16) + 1] := HexChars[Ord(P[I]) And $F];
  End;

 DispProc(Line);
end;

function RGB2HTMLColor(Value: TColor): String;
 Var Lo : LongInt;
     tmp, first, second, third : String;
begin
 Lo := ColorToRGB(Value);
 tmp := IntToHex(Lo, 6);

 first := Copy(tmp, 1, 2);
 second := Copy(tmp, 3, 2);
 third := Copy(tmp, 5, 2);

 Result := third + second + first;
end;

function CapitalizeString(S: String): String;
 Var Count : Integer;
begin
 For Count := 1 To Length(S) Do
  If ((S[Count - 1] = #32) And (S[Count + 1] <> #32)) Or (Count = 1) Or
     (S[Count - 1] = #13) Or (S[Count - 1] = #10) Then
   S[Count] := UpCase(S[Count]);

 Result := S;
end;

procedure MyDeleteFile(PathF: String);
begin
 DeleteFile(PathF);
end;

procedure SaveScreenShot(SE: TSynEdit; FileName: String; OrigCanvas: TCanvas);
 Var B : TBitmap;
     J : TJPEGImage;
     Png : TPortableNetworkGraphic;
     srcRect, dstRect : TRect;
begin
 B := Graphics.TBitmap.Create;
 B.PixelFormat := pf32bit;

 B.SetSize(SE.Width, SE.Height);

 With dstRect Do
  Begin
   Left := 0;
   Top := 0;
   Right := SE.Width + 1;
   Bottom := SE.Height + 1;
  End;

  With srcRect Do
   Begin
    Left := SE.Left;
    Right := SE.Left + SE.Width;
    Top := SE.Top;
    Bottom := SE.Top + SE.Height;
   End;

 B.Canvas.CopyRect(dstRect, OrigCanvas, srcRect);

 If ExtractFileExt(FileName) = '.jpg' Then
  Begin
   J := TJPEGImage.Create;
   J.Transparent := False;

   J.Assign(B);

   J.SaveToFile(FileName);

   J.Free;
  End
 Else
  If ExtractFileExt(FileName) = '.png' Then
   Begin
    Png := TPortableNetworkGraphic.Create;
    Png.Transparent := False;

    Png.Assign(B);

    Png.SaveToFile(FileName);

    Png.Free;
   End
  Else
   B.SaveToFile(FileName);

 B.Free;
end;

end.

