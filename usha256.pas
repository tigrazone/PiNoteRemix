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
unit uSHA256;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

Type
           PSHA256Digest          = ^TSHA256Digest;
           TSHA256Digest          = Array[0..31] Of Byte;

           PSHA256Context         = ^TSHA256Context;
           TSHA256Context         = Record
             Data                 : Array[0..63] Of Byte;
             State                : Array[0..7] Of LongWord;
             Count                : QWord;
           end;

           PSHA256_W              = ^TSHA256_W;
           TSHA256_W              = Array[0..63] Of LongWord;

           PSHA256ByteBuffer      = ^TSHA256ByteBuffer;
           TSHA256ByteBuffer      = Array[0..63] Of Byte;

Function SHA256String(Const OrigStr : String) : String;
Function SHA256File(Const FileName : String) : String;

implementation

Const
     SHA256_K:array[0..63] of LongWord = (
      $428a2f98, $71374491, $b5c0fbcf, $e9b5dba5, $3956c25b, $59f111f1, $923f82a4, $ab1c5ed5,
      $d807aa98, $12835b01, $243185be, $550c7dc3, $72be5d74, $80deb1fe, $9bdc06a7, $c19bf174,
      $e49b69c1, $efbe4786, $0fc19dc6, $240ca1cc, $2de92c6f, $4a7484aa, $5cb0a9dc, $76f988da,
      $983e5152, $a831c66d, $b00327c8, $bf597fc7, $c6e00bf3, $d5a79147, $06ca6351, $14292967,
      $27b70a85, $2e1b2138, $4d2c6dfc, $53380d13, $650a7354, $766a0abb, $81c2c92e, $92722c85,
      $a2bfe8a1, $a81a664b, $c24b8b70, $c76c51a3, $d192e819, $d6990624, $f40e3585, $106aa070,
      $19a4c116, $1e376c08, $2748774c, $34b0bcb5, $391c0cb3, $4ed8aa4a, $5b9cca4f, $682e6ff3,
      $748f82ee, $78a5636f, $84c87814, $8cc70208, $90befffa, $a4506ceb, $bef9a3f7, $c67178f2);

Procedure BytesToBE32(Buffer : PByte; Count : LongWord);
{$IFDEF FPC_BIG_ENDIAN}
Begin
End;
{$ELSE FPC_BIG_ENDIAN}
 Var Value : LongWord;
Begin
 While Count > 0 Do
  Begin
   Value := (RolDWord(PLongWord(Buffer)^, 24) And $FF00FF00) Or (RolDWord(PLongWord(Buffer)^, 8) And $00FF00FF);

   PLongWord(Buffer)^ := Value;

   Inc(Buffer, SizeOf(LongWord));

   Dec(Count);
  end;
end;
{$ENDIF FPC_BIG_ENDIAN}

Function Int64NtoBE(const Value : Int64) : Int64;
Begin
 Result := NtoBE(Value);
end;

procedure SHA256Init(var Context: TSHA256Context);
begin
 Context.State[0] := $6A09E667;
 Context.State[1] := $BB67AE85;
 Context.State[2] := $3C6EF372;
 Context.State[3] := $A54FF53A;
 Context.State[4] := $510E527F;
 Context.State[5] := $9B05688C;
 Context.State[6] := $1F83D9AB;
 Context.State[7] := $5BE0CD19;

 Context.Count := 0;
end;

procedure SHA256Compress(var Context: TSHA256Context; Buffer: Pointer);

 Function SHA256RORc(X,Y : LongWord) : LongWord; Inline;
 Begin
  Result := (((X And $FFFFFFFF) Shr (Y And 31)) Or (X Shl (32 - (Y And 31)))) And $FFFFFFFF;
 end;

 Function SHA256Ch(X,Y,Z : LongWord) : LongWord; Inline;
 Begin
  Result := Z Xor (X And (Y Xor Z));
 end;

 Function SHA256Maj(X,Y,Z : LongWord) : LongWord; Inline;
 Begin
  Result := ((X Or Y) And Z) Or (X And Y);
 end;

 Function SHA256S(X,N : LongWord) : LongWord; Inline;
 Begin
  Result := RorDWord(X, N);
 end;

 Function SHA256R(X,N : LongWord) : LongWord; Inline;
 Begin
  Result := (X And $FFFFFFFF) Shr N;
 end;

 Function SHA256Sigma0(X : LongWord) : LongWord; Inline;
 Begin
  Result := SHA256S(X, 2) Xor SHA256S(X, 13) Xor SHA256S(X, 22);
 end;

 Function SHA256Sigma1(X : LongWord) : LongWord; Inline;
 Begin
  Result := SHA256S(X, 6) Xor SHA256S(X, 11) Xor SHA256S(X, 25);
 end;

 Function SHA256Gamma0(X : LongWord) : LongWord; Inline;
 Begin
  Result := SHA256S(X, 7) Xor SHA256S(X, 18) Xor SHA256R(X, 3);
 end;

 Function SHA256Gamma1(X : LongWord) : LongWord; Inline;
 Begin
  Result := SHA256S(X, 17) Xor SHA256S(X, 19) Xor SHA256R(X, 10);
 end;

 Procedure SHA256Round(A,B,C : LongWord; Var D : LongWord;
                       E,F,G : LongWord; Var H : LongWord; Data : PSHA256_W;
                       Index : LongWord); inline;
  Var Temp0, Temp1 : LongWord;
 Begin
  Temp0 := H + SHA256Sigma1(E) + SHA256Ch(E, F, G) + SHA256_K[Index] + Data^[Index];
  Temp1 := SHA256Sigma0(A) + SHA256Maj(A, B, C);
  D := D + Temp0;
  H := Temp0 + Temp1;
 end;

 Var Temp, Count : LongWord;
     Offset : PtrUInt;
     Data : TSHA256_W;
     State : Array[0..7] Of LongWord;
begin
 If Buffer = Nil Then
  Exit;

 For Count := 0 To 7 Do
  State[Count] := Context.State[Count];

 Offset := 0;

 For Count := 0 To 15 Do
  Begin
   Data[Count] := PLongWord(PtrUInt(Buffer) + Offset)^;

   Inc(Offset, 4);
  end;

 For Count := 16 To 63 Do
  Data[Count] := SHA256Gamma1(Data[Count - 2]) + Data[Count - 7] +
                 SHA256Gamma0(Data[Count - 15]) + Data[Count - 16];

 For Count := 0 To 63 Do
  Begin
   SHA256Round(State[0], State[1], State[2], State[3], State[4], State[5],
               State[6], State[7], @Data, Count);

   Temp := State[7];
   State[7] := State[6];
   State[6] := State[5];
   State[5] := State[4];
   State[4] := State[3];
   State[3] := State[2];
   State[2] := State[1];
   State[1] := State[0];
   State[0] := Temp;
  end;

 For Count := 0 To 7 Do
  Inc(Context.State[Count], State[Count]);
end;

procedure SHA256Process(var Context: TSHA256Context; Data: Pointer;
  Size: LongWord);
 Var Count, Offset : PtrUInt;
begin
 If Data = Nil Then
  Exit;

 If Size = 0 Then
  Exit;

 Count := (Context.Count Shr 3) And $3F;

 Inc(Context.Count, (Size Shl 3));

 If (Count + Size) > 63 Then
  Begin
   Offset := 64 - Count;

   System.Move(Data^, Context.Data[Count], Offset);

   BytesToBE32(@Context.Data[0], 16);

   SHA256Compress(Context, @Context.Data[0]);

   Count := 0;

   While (Offset + 63) < Size Do
    Begin
     System.Move(Pointer(PtrUInt(Data) + Offset)^, Context.Data[0], 64);

     BytesToBE32(@Context.Data[0], 16);

     SHA256Compress(Context, @Context.Data[0]);

     Inc(Offset, 64);
    end;
  end
 Else
  Offset := 0;

 System.Move(Pointer(PtrUInt(Data) + Offset)^, Context.Data[Count], Size - Offset);
end;

Function SHA256DigestToString(Digest : PSHA256Digest) : String;
 Var Count : Word;
Begin
 Result := '';

 If Digest = Nil Then
  Exit;

 For Count := 0 To 31 Do
  Result := Result + HexStr(Digest^[Count], 2);

 Result := Lowercase(Result);
end;

procedure SHA256Complete(var Context: TSHA256Context; var Digest: TSHA256Digest);
 Var Total : QWord;
     Count : PtrUInt;
     Padding : TSHA256ByteBuffer;
begin
 Total := Int64NtoBE(Context.Count);
 Count := (Context.Count Shr 3) And $3F;

 FillChar(Padding[0], SizeOf(TSHA256ByteBuffer), 0);

 Padding[0] := $80;

 If Count >= 56 Then
  Count := 120 - Count
 Else
  Count := 56 - Count;

 SHA256Process(Context, @Padding[0], Count);

 SHA256Process(Context, @Total, 8);

 BytesToBE32(@Context.State[0], 8);

 System.Move(Context.State[0], Digest, 32);

 FillChar(Context, SizeOf(TSHA256Context), 0);
end;

function SHA256DigestString(const Value: String; Digest: PSHA256Digest): Boolean;
 Var Context : TSHA256Context;
Begin
 Result := False;

 If Digest = Nil Then
  Exit;

 SHA256Init(Context);

 SHA256Process(Context, PChar(Value), Length(Value));

 SHA256Complete(Context, Digest^);

 Result := True;
end;

function SHA256String(const OrigStr: String): String;
 Var Buf : TSHA256Digest;
begin
 SHA256DigestString(OrigStr, @Buf);

 Result := SHA256DigestToString(@Buf);
end;

function SHA256File(const FileName: String): String;
 Var iFile : TFileStream;
     iFileSize : Int64;
     StrBuf : String;
begin
 Result := '';

 If FileExists(FileName) Then
  Begin
   iFile := TFileStream.Create(FileName, fmOpenRead);

   Try
     iFileSize := iFile.Size;

     If iFileSize > 0 Then
      Begin
       SetLength(StrBuf, iFileSize);

       iFile.Read(StrBuf[1], iFileSize);

       Result := SHA256String(StrBuf);
      end;
   finally
     iFile.Free;
   end;
  end;
end;

end.

