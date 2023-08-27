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
unit Crypt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, TwoFish, SHA1;


Function _EncryptString(Key : String; S : String) : String;
Function _DecryptString(Key : String; S : String) : String;

Function B64Encode(Const S : String) : String;
Function B64Decode(Const S : String) : String;

implementation

Const
     B64Table = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

procedure _HashString(S: String; var Digest: TSHA1Digest);
 Var Context : TSHA1Context;
begin
 SHA1Init(Context);

 SHA1Update(Context, @S[1], Length(S));

 SHA1Final(Context,Digest);
end;

Function _EncryptString(Key : String; S : String) : String;
 Var KeyData : TTwofishData;
     Digest : TSHA1Digest;
     IV : Array [0..15] Of Byte;
begin
 _HashString(Key, Digest);

 TwofishInit(KeyData, @Digest, Sizeof(Digest), Nil);

 FillChar(IV, Sizeof(IV), 0);

 TwofishEncryptCBC(KeyData, @IV, @IV);

 Move(IV, KeyData.InitBlock, Sizeof(KeyData.InitBlock));

 TwofishReset(KeyData);

 SetLength(Result, Length(S));

 TwofishEncryptCFB(KeyData, @S[1], @Result[1], Length(S));

 TwofishBurn(KeyData);
end;

Function _DecryptString(Key : String; S : String) : String;
 Var KeyData : TTwofishData;
     Digest : TSHA1Digest;
     IV : Array [0..15] Of Byte;
begin
 _HashString(key, Digest);

 TwofishInit(KeyData, @Digest, Sizeof(Digest), Nil);

 FillChar(IV, Sizeof(IV), 0);

 TwofishEncryptCBC(KeyData, @IV, @IV);

 Move(IV, KeyData.InitBlock, Sizeof(KeyData.InitBlock));

 TwofishReset(KeyData);

 SetLength(Result, Length(S));

 TwofishDecryptCFB(KeyData, @S[1], @Result[1], Length(S));

 TwofishBurn(KeyData);
end;

function B64Encode(const S: String): String;
 Var I : Integer;
     InBuf : Array [0..2] Of Byte;
     OutBuf : Array [0..3] Of Char;
begin
 SetLength(Result, ((Length(S) + 2) Div 3) * 4);

 For I := 1 To ((Length(S) + 2) Div 3) Do
  Begin
   If Length(S) < (I * 3) Then
    Move(S[(I - 1) * 3 + 1], InBuf, Length(S) - (I - 1) * 3)
   Else
    Move(S[(I - 1) * 3 + 1], InBuf, 3);

   OutBuf[0] := B64Table[((InBuf[0] And $FC) Shr 2) + 1];
   OutBuf[1] := B64Table[(((InBuf[0] And $03) Shl 4) Or ((InBuf[1] And $F0) Shr 4)) + 1];
   OutBuf[2] := B64Table[(((InBuf[1] And $0F) Shl 2) Or ((InBuf[2] And $C0) Shr 6)) + 1];
   OutBuf[3] := B64Table[(InBuf[2] And $3F) + 1];

   Move(OutBuf, Result[(I - 1) * 4 + 1], 4);
  End;

 If (Length(S) Mod 3)= 1 Then
  Begin
   Result[Length(Result) - 1] := '=';
   Result[Length(Result)] := '=';
  End
 Else
  If (Length(S) Mod 3)= 2 Then
   Result[Length(Result)] := '=';
end;

function B64Decode(const S: String): String;
 Var I : Integer;
     InBuf : Array [0..3] Of Byte;
     OutBuf : Array [0..2] Of Char;
begin
 If (Length(S) Mod 4) <> 0 Then
  Raise Exception.Create('Base64: Incorrect string format');

 SetLength(Result, ((Length(S) Div 4) - 1) * 3);

 For I := 1 To ((Length(S) Div 4) - 1) Do
  Begin
   Move(S[(I - 1) * 4 + 1], InBuf, 4);

   If (InBuf[0] > 64) And (InBuf[0] < 91) Then
    Dec(InBuf[0], 65)
   Else
    If (InBuf[0] > 96) And (InBuf[0] < 123) Then
     Dec(InBuf[0], 71)
    Else
     If (InBuf[0] > 47) And (InBuf[0] < 58) Then
      Inc(InBuf[0] ,4)
     Else
      If InBuf[0] = 43 Then
       InBuf[0] := 62
      Else
       InBuf[0] := 63;

   If (InBuf[1] > 64) And (InBuf[1] < 91) Then
    Dec(InBuf[1], 65)
   Else
    If (InBuf[1] > 96) And (InBuf[1] < 123) Then
     Dec(InBuf[1], 71)
    Else
     If (InBuf[1] > 47) And (InBuf[1] < 58) Then
      Inc(InBuf[1] ,4)
     Else
      If InBuf[1] = 43 Then
       InBuf[1] := 62
      Else
       InBuf[1] := 63;

   If (InBuf[2] > 64) And (InBuf[2] < 91) Then
    Dec(InBuf[2], 65)
   Else
    If (InBuf[2] > 96) And (InBuf[2] < 123) Then
     Dec(InBuf[2], 71)
    Else
     If (InBuf[2] > 47) And (InBuf[2] < 58) Then
      Inc(InBuf[2] ,4)
     Else
      If InBuf[2] = 43 Then
       InBuf[2] := 62
      Else
       InBuf[2] := 63;

   If (InBuf[3] > 64) And (InBuf[3] < 91) Then
    Dec(InBuf[3], 65)
   Else
    If (InBuf[3] > 96) And (InBuf[3] < 123) Then
     Dec(InBuf[3], 71)
    Else
     If (InBuf[3] > 47) And (InBuf[3] < 58) Then
      Inc(InBuf[3] ,4)
     Else
      If InBuf[3] = 43 Then
       InBuf[3] := 62
      Else
       InBuf[3] := 63;

   OutBuf[0] := Char((InBuf[0] Shl 2) Or ((InBuf[1] Shr 4) And $03));
   OutBuf[1] := Char((InBuf[1] Shl 4) Or ((InBuf[2] Shr 2) And $0F));
   OutBuf[2] := Char((InBuf[2] Shl 6) Or (InBuf[3] And $3F));

   Move(OutBuf, Result[(I - 1) * 3 + 1], 3);
  End;

 If Length(S) <> 0 Then
  Begin
   Move(S[Length(S) - 3], InBuf, 4);

   If InBuf[2] = 61 Then
    Begin
     If (InBuf[0] > 64) And (InBuf[0] < 91) Then
      Dec(InBuf[0], 65)
     Else
      If (InBuf[0] > 96) And (InBuf[0] < 123) Then
       Dec(InBuf[0], 71)
      Else
       If (InBuf[0] > 47) And (InBuf[0] < 58) Then
        Inc(InBuf[0] ,4)
       Else
        If InBuf[0] = 43 Then
         InBuf[0] := 62
        Else
         InBuf[0] := 63;

     If (InBuf[1] > 64) And (InBuf[1] < 91) Then
      Dec(InBuf[1], 65)
     Else
      If (InBuf[1] > 96) And (InBuf[1] < 123) Then
       Dec(InBuf[1], 71)
      Else
       If (InBuf[1] > 47) And (InBuf[1] < 58) Then
        Inc(InBuf[1] ,4)
       Else
        If InBuf[1] = 43 Then
         InBuf[1] := 62
        Else
         InBuf[1] := 63;

     OutBuf[0] := Char((InBuf[0] Shl 2) Or ((InBuf[1] Shr 4) And $03));

     Result := Result + Char(OutBuf[0]);
    End
   Else
    If InBuf[3] = 61 Then
     Begin
      If (InBuf[0] > 64) And (InBuf[0] < 91) Then
       Dec(InBuf[0], 65)
      Else
       If (InBuf[0] > 96) And (InBuf[0] < 123) Then
        Dec(InBuf[0], 71)
       Else
        If (InBuf[0] > 47) And (InBuf[0] < 58) Then
         Inc(InBuf[0] ,4)
        Else
         If InBuf[0] = 43 Then
          InBuf[0] := 62
         Else
          InBuf[0] := 63;

      If (InBuf[1] > 64) And (InBuf[1] < 91) Then
       Dec(InBuf[1], 65)
      Else
       If (InBuf[1] > 96) And (InBuf[1] < 123) Then
        Dec(InBuf[1], 71)
       Else
        If (InBuf[1] > 47) And (InBuf[1] < 58) Then
         Inc(InBuf[1] ,4)
        Else
         If InBuf[1] = 43 Then
          InBuf[1] := 62
         Else
          InBuf[1] := 63;

      If (InBuf[2] > 64) And (InBuf[2] < 91) Then
       Dec(InBuf[2], 65)
      Else
       If (InBuf[2] > 96) And (InBuf[2] < 123) Then
        Dec(InBuf[2], 71)
       Else
        If (InBuf[2] > 47) And (InBuf[2] < 58) Then
         Inc(InBuf[2] ,4)
        Else
         If InBuf[2] = 43 Then
          InBuf[2] := 62
         Else
          InBuf[2] := 63;

      OutBuf[0] := Char((InBuf[0] Shl 2) Or ((InBuf[1] Shr 4) And $03));
      OutBuf[1] := Char((InBuf[1] Shl 4) Or ((InBuf[2] Shr 2) And $0F));

      Result := Result + Char(OutBuf[0]) + Char(OutBuf[1]);
     End
    Else
     Begin
      If (InBuf[0] > 64) And (InBuf[0] < 91) Then
       Dec(InBuf[0], 65)
      Else
       If (InBuf[0] > 96) And (InBuf[0] < 123) Then
        Dec(InBuf[0], 71)
       Else
        If (InBuf[0] > 47) And (InBuf[0] < 58) Then
         Inc(InBuf[0] ,4)
        Else
         If InBuf[0] = 43 Then
          InBuf[0] := 62
         Else
          InBuf[0] := 63;

      If (InBuf[1] > 64) And (InBuf[1] < 91) Then
       Dec(InBuf[1], 65)
      Else
       If (InBuf[1] > 96) And (InBuf[1] < 123) Then
        Dec(InBuf[1], 71)
       Else
        If (InBuf[1] > 47) And (InBuf[1] < 58) Then
         Inc(InBuf[1] ,4)
        Else
         If InBuf[1] = 43 Then
          InBuf[1] := 62
         Else
          InBuf[1] := 63;

      If (InBuf[2] > 64) And (InBuf[2] < 91) Then
       Dec(InBuf[2], 65)
      Else
       If (InBuf[2] > 96) And (InBuf[2] < 123) Then
        Dec(InBuf[2], 71)
       Else
        If (InBuf[2] > 47) And (InBuf[2] < 58) Then
         Inc(InBuf[2] ,4)
        Else
         If InBuf[2] = 43 Then
          InBuf[2] := 62
         Else
          InBuf[2] := 63;

      If (InBuf[3] > 64) And (InBuf[3] < 91) Then
       Dec(InBuf[3], 65)
      Else
       If (InBuf[3] > 96) And (InBuf[3] < 123) Then
        Dec(InBuf[3], 71)
       Else
        If (InBuf[3] > 47) And (InBuf[3] < 58) Then
         Inc(InBuf[3] ,4)
        Else
         If InBuf[3] = 43 Then
          InBuf[3] := 62
         Else
          InBuf[3] := 63;

      OutBuf[0] := Char((InBuf[0] Shl 2) Or ((InBuf[1] Shr 4) And $03));
      OutBuf[1] := Char((InBuf[1] Shl 4) Or ((InBuf[2] Shr 2) And $0F));
      OutBuf[2] := Char((InBuf[2] Shl 6) Or (InBuf[3] And $3F));

      Result := Result + Char(OutBuf[0]) + Char(OutBuf[1]) + Char(OutBuf[2]);
     End;
  End;
end;

end.

