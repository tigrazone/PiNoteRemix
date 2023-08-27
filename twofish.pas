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
unit TwoFish;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Tools;

Const
           BLU                  : Array[0..3] Of DWord= (0, 8, 16, 24);
           TWOFISH_BLOCKSIZE    = 16;
           INPUTWHITEN          = 0;
           OUTPUTWHITEN         = (TWOFISH_BLOCKSIZE Div 4);
           NUMROUNDS            = 16;
           ROUNDSUBKEYS         = (OUTPUTWHITEN + TWOFISH_BLOCKSIZE Div 4);
           TOTALSUBKEYS         = (ROUNDSUBKEYS + NUMROUNDS * 2);
           RS_GF_FDBK           = $14d;
           SK_STEP              = $02020202;
           SK_BUMP              = $01010101;
           SK_ROTL              = 9;
           P_00                 = 1;
           P_01                 = 0;
           P_02                 = 0;
           P_03                 = (P_01 Xor 1);
           P_04                 = 1;
           P_10                 = 0;
           P_11                 = 0;
           P_12                 = 1;
           P_13                 = (P_11 Xor 1);
           P_14                 = 0;
           P_20                 = 1;
           P_21                 = 1;
           P_22                 = 0;
           P_23                 = (P_21 Xor 1);
           P_24                 = 0;
           P_30                 = 0;
           P_31                 = 1;
           P_32                 = 1;
           P_33                 = (P_31 Xor 1);
           P_34                 = 1;
           MDS_GF_FDBK          = $169;

Type
           TTwofishData         = Record
             KeyLen             : DWord;
             SubKeys            : Array[0..TOTALSUBKEYS - 1] Of DWord;
             sboxKeys           : Array[0..3] Of DWord;
             sbox               : Array[0..3, 0..255] of DWord;
             InitBlock          : Array[0..15] Of byte;    { initial IV }
             LastBlock          : Array[0..15] Of byte;    { current IV }
           End;

Function TwofishSelfTest() : Boolean;
Procedure TwofishInit(Var Data : TTwofishData; Key : Pointer; Len : Integer; IV : Pointer);
Procedure TwofishBurn(Var Data : TTwofishData);

Procedure TwofishEncryptECB(Var Data : TTwofishData; InData, OutData : Pointer);
Procedure TwofishEncryptCBC(Var Data : TTwofishData; InData, OutData : Pointer);
Procedure TwofishEncryptCFB(Var Data : TTwofishData; InData, OutData : Pointer; Len : Integer);
Procedure TwofishEncryptOFB(Var Data : TTwofishData; InData, OutData : Pointer);
Procedure TwofishEncryptOFBC(Var Data : TTwofishData; InData, OutData : Pointer; Len : Integer);

Procedure TwofishDecryptECB(Var Data : TTwofishData; InData, OutData : Pointer);
Procedure TwofishDecryptCBC(Var Data : TTwofishData; InData, OutData : Pointer);
Procedure TwofishDecryptCFB(Var Data : TTwofishData; InData, OutData : Pointer; Len : Integer);
Procedure TwofishDecryptOFB(Var Data : TTwofishData; InData, OutData : Pointer);
Procedure TwofishDecryptOFBC(Var Data : TTwofishData; InData, OutData : Pointer; Len : Integer);

Procedure TwofishReset(Var Data : TTwofishData);

implementation

Const
    p8x8: Array[0..1,0..255] Of Byte= ((
    $a9, $67, $b3, $e8, $04, $fd, $a3, $76,
    $9a, $92, $80, $78, $e4, $dd, $d1, $38,
    $0d, $c6, $35, $98, $18, $f7, $ec, $6c,
    $43, $75, $37, $26, $fa, $13, $94, $48,
    $f2, $d0, $8b, $30, $84, $54, $df, $23,
    $19, $5b, $3d, $59, $f3, $ae, $a2, $82,
    $63, $01, $83, $2e, $d9, $51, $9b, $7c,
    $a6, $eb, $a5, $be, $16, $0c, $e3, $61,
    $c0, $8c, $3a, $f5, $73, $2c, $25, $0b,
    $bb, $4e, $89, $6b, $53, $6a, $b4, $f1,
    $e1, $e6, $bd, $45, $e2, $f4, $b6, $66,
    $cc, $95, $03, $56, $d4, $1c, $1e, $d7,
    $fb, $c3, $8e, $b5, $e9, $cf, $bf, $ba,
    $ea, $77, $39, $af, $33, $c9, $62, $71,
    $81, $79, $09, $ad, $24, $cd, $f9, $d8,
    $e5, $c5, $b9, $4d, $44, $08, $86, $e7,
    $a1, $1d, $aa, $ed, $06, $70, $b2, $d2,
    $41, $7b, $a0, $11, $31, $c2, $27, $90,
    $20, $f6, $60, $ff, $96, $5c, $b1, $ab,
    $9e, $9c, $52, $1b, $5f, $93, $0a, $ef,
    $91, $85, $49, $ee, $2d, $4f, $8f, $3b,
    $47, $87, $6d, $46, $d6, $3e, $69, $64,
    $2a, $ce, $cb, $2f, $fc, $97, $05, $7a,
    $ac, $7f, $d5, $1a, $4b, $0e, $a7, $5a,
    $28, $14, $3f, $29, $88, $3c, $4c, $02,
    $b8, $da, $b0, $17, $55, $1f, $8a, $7d,
    $57, $c7, $8d, $74, $b7, $c4, $9f, $72,
    $7e, $15, $22, $12, $58, $07, $99, $34,
    $6e, $50, $de, $68, $65, $bc, $db, $f8,
    $c8, $a8, $2b, $40, $dc, $fe, $32, $a4,
    $ca, $10, $21, $f0, $d3, $5d, $0f, $00,
    $6f, $9d, $36, $42, $4a, $5e, $c1, $e0),(
    $75, $f3, $c6, $f4, $db, $7b, $fb, $c8,
    $4a, $d3, $e6, $6b, $45, $7d, $e8, $4b,
    $d6, $32, $d8, $fd, $37, $71, $f1, $e1,
    $30, $0f, $f8, $1b, $87, $fa, $06, $3f,
    $5e, $ba, $ae, $5b, $8a, $00, $bc, $9d,
    $6d, $c1, $b1, $0e, $80, $5d, $d2, $d5,
    $a0, $84, $07, $14, $b5, $90, $2c, $a3,
    $b2, $73, $4c, $54, $92, $74, $36, $51,
    $38, $b0, $bd, $5a, $fc, $60, $62, $96,
    $6c, $42, $f7, $10, $7c, $28, $27, $8c,
    $13, $95, $9c, $c7, $24, $46, $3b, $70,
    $ca, $e3, $85, $cb, $11, $d0, $93, $b8,
    $a6, $83, $20, $ff, $9f, $77, $c3, $cc,
    $03, $6f, $08, $bf, $40, $e7, $2b, $e2,
    $79, $0c, $aa, $82, $41, $3a, $ea, $b9,
    $e4, $9a, $a4, $97, $7e, $da, $7a, $17,
    $66, $94, $a1, $1d, $3d, $f0, $de, $b3,
    $0b, $72, $a7, $1c, $ef, $d1, $53, $3e,
    $8f, $33, $26, $5f, $ec, $76, $2a, $49,
    $81, $88, $ee, $21, $c4, $1a, $eb, $d9,
    $c5, $39, $99, $cd, $ad, $31, $8b, $01,
    $18, $23, $dd, $1f, $4e, $2d, $f9, $48,
    $4f, $f2, $65, $8e, $78, $5c, $58, $19,
    $8d, $e5, $98, $57, $67, $7f, $05, $64,
    $af, $63, $b6, $fe, $f5, $b7, $3c, $a5,
    $ce, $e9, $68, $44, $e0, $4d, $43, $69,
    $29, $2e, $ac, $15, $59, $a8, $0a, $9e,
    $6e, $47, $df, $34, $35, $6a, $cf, $dc,
    $22, $c9, $c0, $9b, $89, $d4, $ed, $ab,
    $12, $a2, $0d, $52, $bb, $02, $2f, $a9,
    $d7, $61, $1e, $b4, $50, $04, $f6, $c2,
    $16, $25, $86, $56, $55, $09, $be, $91));


Type
         PDWord         = ^DWord;
         PDWordArray    = ^TDWordArray;
         TDWordArray    = Array [0..1023] Of DWord;

Var
         MDS            : Array [0..3,0..255] Of DWord;


Function LFSR1(x: DWord): DWord;
Begin
 If (x And 1) <> 0 Then
  Result := (x Shr 1) Xor (MDS_GF_FDBK Div 2)
 Else
  Result := (x Shr 1);
End;

Function LFSR2(x: DWord): DWord;
Begin
 If (x And 2) <> 0 Then
  If (x And 1) <> 0 Then
   Result := (x Shr 2) Xor (MDS_GF_FDBK Div 2) Xor (MDS_GF_FDBK Div 4)
  Else
   Result := (x Shr 2) Xor (MDS_GF_FDBK Div 2)
 Else
  If (x And 1) <> 0 Then
   Result := (x Shr 2) Xor (MDS_GF_FDBK Div 4)
  Else
   Result := (x Shr 2);
End;

Function Mx_1(x: DWord): DWord;
Begin
 Result := x;
End;

Function Mx_X(x: DWord): DWord;
Begin
 Result := x Xor LFSR2(x);
End;

Function Mx_Y(x: DWord): DWord;
Begin
 Result := x Xor LFSR1(x) Xor LFSR2(x);
End;

Procedure PreCompMDS();
 Var nI : Integer;
     m1, mx, my : Array[0..1] Of byte;
Begin
 For nI:= 0 To 255 Do
  Begin
   m1[0] := p8x8[0, nI];
   mx[0] := Mx_X(m1[0]);
   my[0] := Mx_Y(m1[0]);

   m1[1] := p8x8[1, nI];
   mx[1] := Mx_X(m1[1]);
   my[1] := Mx_Y(m1[1]);

   MDS[0, nI] := (m1[P_00] Shl 0) Or
                 (mx[P_00] Shl 8) Or
                 (my[P_00] Shl 16) Or
                 (my[P_00] Shl 24);

   MDS[1, nI] := (my[P_10] Shl 0) Or
                 (my[P_10] Shl 8) Or
                 (mx[P_10] Shl 16) Or
                 (m1[P_10] Shl 24);

   MDS[2, nI] := (my[P_20] Shl 0) Or
                 (my[P_20] Shl 8) Or
                 (mx[P_20] Shl 16) Or
                 (m1[P_20] Shl 24);

   MDS[3, nI] := (my[P_30] Shl 0) Or
                 (my[P_30] Shl 8) Or
                 (mx[P_30] Shl 16) Or
                 (m1[P_30] Shl 24);
  End;
End;

Function RS_MDS_Encode(lK0, lK1: DWord) : DWord;
 Var lR, lG2, lG3 : DWord;
     bB, nI, nJ : Byte;
Begin
 lR := 0;

 For nI := 0 To 1 Do
  Begin
   If nI <> 0  Then
    lR := lR Xor lK0
   Else
    lR := lR Xor lK1;

   For nJ:= 0 To 3 Do
    Begin
     bB := lR Shr 24;

     If (bB And $80) <> 0 Then
      lG2 := ((bB Shl 1) Xor RS_GF_FDBK) And $FF
     Else
      lG2 := (bB Shl 1) And $FF;

     If (bB And 1) <> 0 Then
      lG3 := ((bB Shr 1) And $7f) Xor (RS_GF_FDBK Shr 1) Xor lG2
     Else
      lG3 := ((bB Shr 1) And $7f) Xor lG2;

     lR := (lR Shl 8) Xor (lG3 Shl 24) Xor (lG2 Shl 16) Xor (lG3 Shl 8) Xor bB;
    End;
  End;

 Result := lR;
End;

Function f32(x: DWord; K32: PDWordArray; Len: DWord) : DWord;
 Var t0, t1, t2, t3 : DWord;
Begin
 t0 := X And $FF;
 t1 := (X Shr 8) And $FF;
 t2 := (x Shr 16) And $FF;
 t3 := x Shr 24;

 If Len = 256 Then
  Begin
   t0 := p8x8[P_04, t0] Xor (K32^[3] And $FF);
   t1 := p8x8[P_14, t1] Xor ((K32^[3] Shr 8) And $FF);
   t2 := p8x8[P_24, t2] Xor ((K32^[3] Shr 16) And $FF);
   t3 := p8x8[P_34, t3] Xor ((K32^[3] Shr 24));
  End;

 If Len >= 192 Then
  Begin
   t0 := p8x8[P_03, t0] Xor (K32^[2] And $FF);
   t1 := p8x8[P_13, t1] Xor ((K32^[2] Shr 8) And $FF);
   t2 := p8x8[P_23, t2] Xor ((K32^[2] Shr 16) And $FF);
   t3 := p8x8[P_33, t3] Xor ((K32^[2] Shr 24));
  End;

 Result := MDS[0, p8x8[P_01, p8x8[P_02, t0] Xor (K32^[1] And $FF)] Xor ((K32^[0]) And $FF)] Xor
           MDS[1, p8x8[P_11, p8x8[P_12, t1] Xor ((K32^[1] Shr  8) And $FF)] Xor ((K32^[0] Shr 8) And $FF)] Xor
           MDS[2, p8x8[P_21, p8x8[P_22, t2] Xor ((K32^[1] Shr 16) And $FF)] Xor ((K32^[0] Shr 16) And $FF)] Xor
           MDS[3, p8x8[P_31, p8x8[P_32, t3] Xor ((K32^[1] Shr 24))] Xor ((K32^[0] Shr 24))];
End;

function TwofishSelfTest(): Boolean;
 Const Key : Array [0..31] Of Byte = ($01,$23,$45,$67,$89,$AB,$CD,$EF,$FE,$DC,$BA,$98,$76,$54,$32,$10,$00,$11,$22,$33,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF);
       InBlock : Array [0..15] Of Byte = ($0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0);
       OutBlock : Array [0..15] Of Byte = ($37,$52,$7B,$E0,$05,$23,$34,$B8,$9F,$0C,$FC,$CA,$E8,$7C,$FA,$20);

 Var Block : Array [0..15] Of Byte;
     Data : TTwofishData;
begin
 TwofishInit(Data, @Key, Sizeof(Key), Nil);

 TwofishEncryptECB(Data, @InBlock, @Block);

 Result := CompareMem(@Block, @OutBlock, Sizeof(Block));

 TwofishDecryptECB(Data, @Block, @Block);

 Result := Result And CompareMem(@Block, @InBlock, Sizeof(Block));

 TwofishBurn(Data);
end;

procedure TwofishInit(var Data: TTwofishData; Key: Pointer; Len: Integer;
  IV: Pointer);

 Procedure Xor256(Dst, Src : PDWordArray; v : Byte);
  Var I : DWord;
 Begin
  For i := 0 To 63 Do
   Dst^[i] := Src^[i] Xor (v * $01010101);
 End;

 Var key32 : Array [0..7] Of DWord;
     k32e, k32o : Array [0..3] Of DWord;
     k64Cnt, i, j, A, B, q, subkeyCnt : DWord;
     L0, L1 : Array [0..255] Of Byte;
begin
 If (Len <= 0) Or (Len > 32) Then
  Raise Exception.Create('Key (password) has to be between 1 and 32 bytes.'+#13+
                         'If you want to use a longer password please check'+#13+
                         '"Use Hash of password" in the password dialog.');

 With Data Do
  Begin
   If IV = Nil Then
    Begin
     FillChar(InitBlock, 16, 0);
     FillChar(LastBlock, 16, 0);
    End
   Else
    Begin
     Move(IV^, InitBlock, 16);
     Move(IV^, LastBlock, 16);
    End;

   FillChar(Key32, Sizeof(Key32), 0);

   Move(Key^, Key32, Len);

   If Len <= 16 Then
    Len := 128
   Else
    If Len <= 24 Then
     Len := 192
    Else
     Len := 256;

   subkeyCnt := ROUNDSUBKEYS + 2 * NUMROUNDS;
   KeyLen := Len;
   k64Cnt := Len Div 64;
   j := k64Cnt - 1;

   For i := 0 To j Do
    Begin
     k32e[i] := key32[2 * i];
     k32o[i] := key32[2 * i + 1];

     sboxKeys[j] := RS_MDS_Encode(k32e[i], k32o[i]);

     Dec(j);
    End;

   q := 0;

   For i := 0 To ((subkeyCnt Div 2) - 1) Do
    Begin
     A := f32(q, @k32e, Len);
     B := f32(q + SK_BUMP, @k32o, Len);

     B := LRot32(B, 8);

     SubKeys[2 * i] := A + B;
     B := A + 2 * B;

     SubKeys[2 * i + 1] := LRot32(B, SK_ROTL);

     Inc(q, SK_STEP);
    End;

   Case Len Of
        128             : Begin
                           Xor256(@L0, @p8x8[P_02], (sboxKeys[1] And $FF));

                           A := (sboxKeys[0] And $FF);
                           i := 0;

                           While i < 256 Do
                            Begin
                             sBox[0 And 2, 2 * i + (0 And 1)] := MDS[0, p8x8[P_01, L0[i]] Xor A];
                             sBox[0 And 2, 2 * i + (0 And 1) + 2] := MDS[0, p8x8[P_01, L0[i + 1]] Xor A];

                             Inc(i,2);
                            End;

                           Xor256(@L0, @p8x8[P_12], (sboxKeys[1] Shr 8) And $FF);

                           A := (sboxKeys[0] Shr 8) And $FF;
                           i := 0;

                           While i < 256 Do
                            Begin
                             sBox[1 And 2, 2 * i + (1 And 1)] := MDS[1, p8x8[P_11, L0[i]] Xor A];
                             sBox[1 And 2, 2 * i + (1 And 1) + 2] := MDS[1, p8x8[P_11, L0[i + 1]] Xor A];

                             Inc(i,2);
                            End;

                           Xor256(@L0, @p8x8[P_22], (sboxKeys[1] Shr 16) And $FF);

                           A := (sboxKeys[0] Shr 16) And $FF;
                           i := 0;

                           While i < 256 Do
                            Begin
                             sBox[2 And 2, 2 * i + (2 And 1)] := MDS[2, p8x8[P_21, L0[i]] Xor A];
                             sBox[2 And 2, 2 * i + (2 And 1) + 2] := MDS[2, p8x8[P_21, L0[i + 1]] Xor A];

                             Inc(i,2);
                            End;

                           Xor256(@L0, @p8x8[P_32], (sboxKeys[1] Shr 24));

                           A := (sboxKeys[0] Shr 24);
                           i := 0;

                           While i < 256 Do
                            Begin
                             sBox[3 And 2, 2 * i + (3 And 1)] := MDS[3, p8x8[P_31, L0[i]] Xor A];
                             sBox[3 And 2, 2 * i + (3 And 1) + 2] := MDS[3, p8x8[P_31, L0[i + 1]] Xor A];

                             Inc(i,2);
                            End;
                          End;

        192             : Begin
                           Xor256(@L0, @p8x8[P_03], sboxKeys[2] And $FF);

                           A := sboxKeys[0] And $FF;
                           B := sboxKeys[1] And $FF;
                           i := 0;

                           While i < 256 Do
                            Begin
                             sBox[0 And 2, 2 * i + (0 And 1)] := MDS[0, p8x8[P_01, p8x8[P_02, L0[i]] Xor B] Xor A];
                             sBox[0 And 2, 2 * i + (0 And 1) + 2] := MDS[0, p8x8[P_01, p8x8[P_02, L0[i + 1]] Xor B] Xor A];

                             Inc(i,2);
                            End;

                           Xor256(@L0, @p8x8[P_13], (sboxKeys[2] Shr 8) And $FF);

                           A := (sboxKeys[0] Shr 8) And $FF;
                           B := (sboxKeys[1] Shr 8) And $FF;
                           i := 0;

                           While i < 256 Do
                            Begin
                             sBox[1 And 2, 2 * i + (1 And 1)] := MDS[1, p8x8[P_11, p8x8[P_12, L0[i]] Xor B] Xor A];
                             sBox[1 And 2, 2 * i + (1 And 1) + 2] := MDS[1, p8x8[P_11, p8x8[P_12, L0[i + 1]] Xor B] Xor A];

                             Inc(i,2);
                            End;

                           Xor256(@L0, @p8x8[P_23], (sboxKeys[2] Shr 16) And $FF);

                           A := (sboxKeys[0] Shr 16) And $FF;
                           B := (sboxKeys[1] Shr 16) And $FF;
                           i := 0;

                           While i < 256 Do
                            Begin
                             sBox[2 And 2, 2 * i + (2 And 1)] := MDS[2, p8x8[P_21, p8x8[P_22, L0[i]] Xor B] Xor A];
                             sBox[2 And 2, 2 * i + (2 And 1) + 2] := MDS[2, p8x8[P_21, p8x8[P_22, L0[i + 1]] Xor B] Xor A];

                             Inc(i,2);
                            End;

                           Xor256(@L0, @p8x8[P_33], (sboxKeys[2] Shr 24));

                           A := (sboxKeys[0] Shr 24);
                           B := (sboxKeys[1] Shr 24);
                           i := 0;

                           While i < 256 Do
                            Begin
                             sBox[3 And 2, 2 * i + (3 And 1)] := MDS[3, p8x8[P_31, p8x8[P_32, L0[i]] Xor B] Xor A];
                             sBox[3 And 2, 2 * i + (3 And 1) + 2] := MDS[3, p8x8[P_31, p8x8[P_32, L0[i + 1]] Xor B] Xor A];

                             Inc(i,2);
                            End;
                          End;

        256             : Begin
                           Xor256(@L1, @p8x8[P_04], (sboxKeys[3]) And $FF);

                           i := 0;

                           While i < 256 Do
                            Begin
                             L0[i] := p8x8[P_03, L1[i]];
                             L0[i + 1] := p8x8[P_03, L1[i + 1]];

                             Inc(i,2);
                            End;

                           Xor256(@L0, @L0, (sboxKeys[2]) And $FF);

                           A := (sboxKeys[0]) And $FF;
                           B := (sboxKeys[1]) And $FF;
                           i := 0;

                           While i < 256 Do
                            Begin
                             sBox[0 And 2,2 * i + (0 And 1)] := MDS[0, p8x8[P_01, p8x8[P_02, L0[i]] Xor B] Xor A];
                             sBox[0 And 2,2 * i + (0 And 1) + 2] := MDS[0, p8x8[P_01, p8x8[P_02, L0[i + 1]] Xor B] Xor A];

                             Inc(i,2);
                            End;

                           Xor256(@L1, @p8x8[P_14], (sboxKeys[3] Shr 8) And $FF);

                           i := 0;

                           While i < 256 Do
                            Begin
                             L0[i] := p8x8[P_13, L1[i]];
                             L0[i + 1] := p8x8[P_13, L1[i + 1]];

                             Inc(i,2);
                            End;

                           Xor256(@L0, @L0, (sboxKeys[2] Shr 8) And $FF);

                           A := (sboxKeys[0] Shr 8) And $FF;
                           B := (sboxKeys[1] Shr 8) And $FF;
                           i := 0;

                           While i < 256 Do
                            Begin
                             sBox[1 And 2,2 * i + (1 And 1)] := MDS[1, p8x8[P_11, p8x8[P_12, L0[i]] Xor B] Xor A];
                             sBox[1 And 2,2 * i + (1 And 1) + 2] := MDS[1, p8x8[P_11, p8x8[P_12, L0[i + 1]] Xor B] Xor A];

                             Inc(i,2);
                            End;

                           Xor256(@L1, @p8x8[P_24], (sboxKeys[3] Shr 16) And $FF);

                           i := 0;

                           While i < 256 Do
                            Begin
                             L0[i] := p8x8[P_23, L1[i]];
                             L0[i + 1] := p8x8[P_23, L1[i + 1]];

                             Inc(i,2);
                            End;

                           Xor256(@L0, @L0, (sboxKeys[2] Shr 16) And $FF);

                           A := (sboxKeys[0] Shr 16) And $FF;
                           B := (sboxKeys[1] Shr 16) And $FF;
                           i := 0;

                           While i < 256 Do
                            Begin
                             sBox[2 And 2,2 * i + (2 And 1)] := MDS[2, p8x8[P_21, p8x8[P_22, L0[i]] Xor B] Xor A];
                             sBox[2 And 2,2 * i + (2 And 1) + 2] := MDS[2, p8x8[P_21, p8x8[P_22, L0[i + 1]] Xor B] Xor A];

                             Inc(i,2);
                            End;

                           Xor256(@L1, @p8x8[P_34], (sboxKeys[3] Shr 24));

                           i := 0;

                           While i < 256 Do
                            Begin
                             L0[i] := p8x8[P_33, L1[i]];
                             L0[i + 1] := p8x8[P_33, L1[i + 1]];

                             Inc(i,2);
                            End;

                           Xor256(@L0, @L0, (sboxKeys[2] Shr 24));

                           A := (sboxKeys[0] Shr 24);
                           B := (sboxKeys[1] Shr 24);
                           i := 0;

                           While i < 256 Do
                            Begin
                             sBox[3 And 2,2 * i + (3 And 1)] := MDS[3, p8x8[P_31, p8x8[P_32, L0[i]] Xor B] Xor A];
                             sBox[3 And 2,2 * i + (3 And 1) + 2] := MDS[3, p8x8[P_31, p8x8[P_32, L0[i + 1]] Xor B] Xor A];

                             Inc(i,2);
                            End;
                          End;
   End;
  End;
end;

procedure TwofishBurn(var Data: TTwofishData);
begin
 FillChar(Data, Sizeof(Data), 0);
end;

procedure TwofishEncryptECB(var Data: TTwofishData; InData, OutData: Pointer);
 Var i : Integer;
     t0, t1 : DWord;
     X : Array[0..3] Of DWord;
begin
 X[0] := PDWord(InData)^ Xor Data.SubKeys[INPUTWHITEN];
 X[1] := PDWord(Integer(InData) + 4)^ Xor Data.SubKeys[INPUTWHITEN + 1];
 X[2] := PDWord(Integer(InData) + 8)^ Xor Data.SubKeys[INPUTWHITEN + 2];
 X[3] := PDWord(Integer(InData) + 12)^ Xor Data.SubKeys[INPUTWHITEN + 3];

 With Data Do
  Begin
   i := 0;

   While i <= NUMROUNDS - 2 Do
    Begin
     t0 := Data.sBox[0, 2 * (((x[0]) Shr (BLU[(0) And 3])) And $ff)] Xor
           Data.sBox[0, 2 * (((x[0]) Shr (BLU[(1) And 3])) And $ff) + 1] Xor
           Data.sBox[2, 2 * (((x[0]) Shr (BLU[(2) And 3])) And $ff)] Xor
           Data.sBox[2, 2 * (((x[0]) Shr (BLU[(3) And 3])) And $ff) + 1];

     t1 := Data.sBox[0, 2 * (((x[1]) Shr (BLU[(3) And 3])) And $ff)] Xor
           Data.sBox[0, 2 * (((x[1]) Shr (BLU[(4) And 3])) And $ff) + 1] Xor
           Data.sBox[2, 2 * (((x[1]) Shr (BLU[(5) And 3])) And $ff)] Xor
           Data.sBox[2, 2 * (((x[1]) Shr (BLU[(6) And 3])) And $ff) + 1];

     x[3] := LRot32(x[3], 1);

     x[2] := x[2] Xor (t0 + t1 + Data.Subkeys[ROUNDSUBKEYS + 2 * i]);
     x[3] := x[3] Xor (t0 + 2 * t1 + Data.Subkeys[ROUNDSUBKEYS + 2 * i + 1]);

     x[2] := RRot32(x[2], 1);

     t0 := Data.sBox[0, 2 * (((x[2]) Shr (BLU[(0) And 3])) And $ff)] Xor
           Data.sBox[0, 2 * (((x[2]) Shr (BLU[(1) And 3])) And $ff) + 1] Xor
           Data.sBox[2, 2 * (((x[2]) Shr (BLU[(2) And 3])) And $ff)] Xor
           Data.sBox[2, 2 * (((x[2]) Shr (BLU[(3) And 3])) And $ff) + 1];

     t1 := Data.sBox[0, 2 * (((x[3]) Shr (BLU[(3) And 3])) And $ff)] Xor
           Data.sBox[0, 2 * (((x[3]) Shr (BLU[(4) And 3])) And $ff) + 1] Xor
           Data.sBox[2, 2 * (((x[3]) Shr (BLU[(5) And 3])) And $ff)] Xor
           Data.sBox[2, 2 * (((x[3]) Shr (BLU[(6) And 3])) And $ff) + 1];

     x[1] := LRot32(x[1], 1);

     x[0] := x[0] Xor (t0 + t1 + Data.Subkeys[ROUNDSUBKEYS + 2 * (i + 1)]);
     x[1] := x[1] Xor (t0 + 2 * t1 + Data.Subkeys[ROUNDSUBKEYS + 2 * (i + 1) + 1]);

     x[0] := RRot32(x[0], 1);

     Inc(i,2);
    End;
  End;

 PDWord(Integer(OutData) + 0)^ := X[2] Xor Data.SubKeys[OUTPUTWHITEN];
 PDWord(Integer(OutData) + 4)^ := X[3] Xor Data.SubKeys[OUTPUTWHITEN + 1];
 PDWord(Integer(OutData) + 8)^ := X[0] Xor Data.SubKeys[OUTPUTWHITEN + 2];
 PDWord(integer(OutData) + 12)^ := X[1] Xor Data.SubKeys[OUTPUTWHITEN + 3];
end;

procedure TwofishEncryptCBC(var Data: TTwofishData; InData, OutData: Pointer);
begin
 XorBlock(InData, @Data.LastBlock, OutData, 16);

 TwofishEncryptECB(Data, OutData, OutData);

 Move(OutData^, Data.LastBlock, 16);
end;

procedure TwofishEncryptCFB(var Data: TTwofishData; InData, OutData: Pointer;
  Len: Integer);
 Var I : Integer;
     TempBlock : Array[0..15] Of Byte;
begin
 For I := 0 To Len - 1 Do
  Begin
   TwofishEncryptECB(Data, @Data.LastBlock, @TempBlock);

   PByteArray(OutData)^[I] := PByteArray(InData)^[I] Xor TempBlock[0];

   Move(Data.LastBlock[1], Data.LastBlock[0], 15);

   Data.LastBlock[15] := PByteArray(OutData)^[I];
  End;
end;

procedure TwofishEncryptOFB(var Data: TTwofishData; InData, OutData: Pointer);
begin
 TwofishEncryptECB(Data, @Data.LastBlock, @Data.LastBlock);

 XorBlock(@Data.LastBlock, InData,OutData, 16);
end;

procedure TwofishEncryptOFBC(var Data: TTwofishData; InData, OutData: Pointer;
  Len: Integer);
 Var I : Integer;
     TempBlock : Array[0..15] Of Byte;
begin
 For I := 0 To Len - 1 Do
  Begin
   TwofishEncryptECB(Data, @Data.LastBlock, @TempBlock);

   PByteArray(OutData)^[I] := PByteArray(InData)^[I] Xor TempBlock[0];

   IncBlock(@Data.LastBlock, 16);
  End;
end;

procedure TwofishDecryptECB(var Data: TTwofishData; InData, OutData: Pointer);
 Var i : Integer;
     t0, t1 : DWord;
     X : Array[0..3] Of DWord;
begin
 X[2] := PDWord(InData)^ Xor Data.SubKeys[OUTPUTWHITEN];
 X[3] := PDWord(Integer(InData) + 4)^ Xor Data.SubKeys[OUTPUTWHITEN + 1];
 X[0] := PDWord(Integer(InData) + 8)^ Xor Data.SubKeys[OUTPUTWHITEN + 2];
 X[1] := PDWord(Integer(InData) + 12)^ Xor Data.SubKeys[OUTPUTWHITEN + 3];

 With Data Do
  Begin
   i := NUMROUNDS - 2;

   While i >= 0 Do
    Begin
      t0 := Data.sBox[0, 2 * (((x[2]) Shr (BLU[(0) And 3])) And $ff)] Xor
            Data.sBox[0, 2 * (((x[2]) Shr (BLU[(1) And 3])) And $ff) + 1] Xor
            Data.sBox[2, 2 * (((x[2]) Shr (BLU[(2) And 3])) And $ff)] Xor
            Data.sBox[2, 2 * (((x[2]) Shr (BLU[(3) And 3])) And $ff) + 1];

      t1 := Data.sBox[0, 2 * (((x[3]) Shr (BLU[(3) And 3])) And $ff)] Xor
            Data.sBox[0, 2 * (((x[3]) Shr (BLU[(4) And 3])) And $ff) + 1] Xor
            Data.sBox[2, 2 * (((x[3]) Shr (BLU[(5) And 3])) And $ff)] Xor
            Data.sBox[2, 2 * (((x[3]) Shr (BLU[(6) And 3])) And $ff) + 1];

      x[0] := LRot32(x[0], 1);

      x[0] := x[0] Xor (t0 + t1 + Data.Subkeys[ROUNDSUBKEYS + 2 * (i + 1)]);
      x[1] := x[1] Xor (t0 + 2 * t1 + Data.Subkeys[ROUNDSUBKEYS + 2 * (i + 1) + 1]);

      x[1] := RRot32(x[1], 1);

      t0 := Data.sBox[0, 2 * (((x[0]) Shr (BLU[(0) And 3])) And $ff)] Xor
            Data.sBox[0, 2 * (((x[0]) Shr (BLU[(1) And 3])) And $ff) + 1] Xor
            Data.sBox[2, 2 * (((x[0]) Shr (BLU[(2) And 3])) And $ff)] Xor
            Data.sBox[2, 2 * (((x[0]) Shr (BLU[(3) And 3])) And $ff) + 1];

      t1 := Data.sBox[0, 2 * (((x[1]) Shr (BLU[(3) And 3])) And $ff)] Xor
            Data.sBox[0, 2 * (((x[1]) Shr (BLU[(4) And 3])) And $ff) + 1] Xor
            Data.sBox[2, 2 * (((x[1]) Shr (BLU[(5) And 3])) And $ff)] Xor
            Data.sBox[2, 2 * (((x[1]) Shr (BLU[(6) And 3])) And $ff) + 1];

      x[2] := LRot32(x[2], 1);

      x[2] := x[2] Xor (t0 + t1 + Data.Subkeys[ROUNDSUBKEYS + 2 * i]);
      x[3] := x[3] Xor (t0 + 2 * t1 + Data.Subkeys[ROUNDSUBKEYS + 2 * i + 1]);

      x[3] := RRot32(x[3], 1);

      Dec(i,2);
    End;
  End;

  PDWord(Integer(OutData) + 0)^ := X[0] Xor Data.SubKeys[INPUTWHITEN];
  PDWord(Integer(OutData) + 4)^ := X[1] Xor Data.SubKeys[INPUTWHITEN + 1];
  PDWord(Integer(OutData) + 8)^ := X[2] Xor Data.SubKeys[INPUTWHITEN + 2];
  PDWord(Integer(OutData) + 12)^ := X[3] Xor Data.SubKeys[INPUTWHITEN + 3];
end;

procedure TwofishDecryptCBC(var Data: TTwofishData; InData, OutData: Pointer);
 Var TempBlock : Array[0..15] Of byte;
begin
 Move(InData^, TempBlock, 16);

 TwofishDecryptECB(Data, InData, OutData);

 XorBlock(OutData, @Data.LastBlock, OutData, 16);

 Move(TempBlock, Data.LastBlock, 16);
end;

procedure TwofishDecryptCFB(var Data: TTwofishData; InData, OutData: Pointer;
  Len: Integer);
 Var I : Integer;
     TempBlock : Array[0..15] Of Byte;
     b : Byte;
begin
 For I := 0 To Len - 1 Do
  Begin
   b := PByteArray(InData)^[I];

   TwofishEncryptECB(Data, @Data.LastBlock, @TempBlock);

   PByteArray(OutData)^[I] := PByteArray(InData)^[I] Xor TempBlock[0];

   Move(Data.LastBlock[1], Data.LastBlock[0], 15);

   Data.LastBlock[15] := b;
  End;
end;

procedure TwofishDecryptOFB(var Data: TTwofishData; InData, OutData: Pointer);
begin
 TwofishEncryptECB(Data, @Data.LastBlock, @Data.LastBlock);

 XorBlock(@Data.LastBlock, InData,OutData, 16);
end;

procedure TwofishDecryptOFBC(var Data: TTwofishData; InData, OutData: Pointer;
  Len: Integer);
 Var I : Integer;
     TempBlock : Array[0..15] Of Byte;
begin
 For I := 0 To Len - 1 Do
  Begin
   TwofishEncryptECB(Data, @Data.LastBlock, @TempBlock);

   PByteArray(OutData)^[I] := PByteArray(InData)^[I] Xor TempBlock[0];

   IncBlock(@Data.LastBlock, 16);
  End;
end;

procedure TwofishReset(var Data: TTwofishData);
begin
 Move(Data.InitBlock, Data.LastBlock, 16);
end;

Initialization
 PreCompMDS();
end.

