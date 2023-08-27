{ <PiNote - free source code editor>

Copyright (C) <2022> <Enzo Antonio Calogiuri> <ecalogiuri(at)gmail.com>

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
unit uPiRuler;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics;

Type
    TValRange                   = Class(TPersistent)
      Private
        FMinValid,
        FMaxValid               : Boolean;
        FMin,
        FMax                    : Double;

      Published
        Property MinValid: Boolean Read FMinValid Write FMinValid;
        Property Min: Double Read FMin Write FMin;
        Property MaxValid: Boolean read FMaxValid Write FMaxValid;
        Property Max: Double Read FMax Write FMax;
    end;

    { TPiRuler }

    TPiRuler                    = Class(TCustomControl)
      Private
        FColor                  : TColor;
        FEnableRepaint          : Boolean;
        FFont                   : TFont;
        FRollLimits             : TValRange;
        FStartValue             : Double;
        FSzBig                  : Integer;
        FSzMiddle               : Integer;
        FSzSmall                : Integer;
        FTickColor              : TColor;
        FUnitSize               : Double;
        FUnitPrice              : Double;
        FUnitPrecision          : Integer;
        fLeftBorder             : Integer;
        fUnitDisplacement       : Integer;
        FNumberIndent           : Integer;

      Protected
        Procedure Paint; override;
        Procedure SetColor(AColor: TColor); Override;
        Procedure SetFont(AFont: TFont);
        Procedure SetStartValue(AStartVal: Double);
        Procedure SetSzBig(ASize: Integer);
        Procedure SetSzMiddle(ASize: Integer);
        Procedure SetSzSmall(ASize: Integer);
        Procedure SetUnitSize(AUnitSize: Double);
        Procedure SetUnitPrice(AUnitPrice: Double);
        Procedure SetUnitPrecision(APrecision: Integer);
        Procedure SetNumberIndent(AnIndent: Integer);
        Procedure SetUnitDisplacement(AUnitDisp: Integer);

      Public
        Constructor Create(AOwner: TComponent); Override;

      Published
        Property Align;
        Property Color: TColor Read FColor Write SetColor;
        Property Enabled;
        Property EnableRepaint: Boolean Read FEnableRepaint Write FEnableRepaint;
        Property Font: TFont Read FFont Write SetFont;
        Property Hint;
        Property ParentShowHint;
        Property StartValue: Double Read FStartValue Write SetStartValue;
        Property TickColor: TColor Read FTickColor Write FTickColor;
        Property TickSizeBig: Integer Read FSzBig Write SetSzBig;
        Property TickSizeMiddle: Integer Read FSzMiddle Write SetSzMiddle;
        Property TickSizeSmall: Integer Read FSzSmall Write SetSzSmall;
        Property UnitSize: Double Read FUnitSize Write SetUnitSize;
        Property UnitPrice: Double Read FUnitPrice Write SetUnitPrice;
        Property UnitPrecision: Integer Read FUnitPrecision Write SetUnitPrecision;
        Property LeftBorder : Integer Read fLeftBorder Write fLeftBorder;
        Property UnitDisplacement : Integer Read fUnitDisplacement Write SetUnitDisplacement;
        Property NumberIndent: Integer Read FNumberIndent Write SetNumberIndent;
        Property OnMouseMove;
        Property OnMouseDown;
        Property OnMouseUp;
        Property OnClick;
    end;

implementation

Uses LCLType, LCLIntf, Math;

{ TPiRuler }

procedure TPiRuler.Paint;
 Var TickCount, szBig, szMiddle, szSmall : Integer;
     Pos, Tenth, D : Double;
     Val, P0, P1, P2, P3, Sw : Integer;
     lF : TLogFont;
     tF : TFont;
     S : String;
begin
 D := Ceil(FStartValue * 10) / 10;
 Pos := (D - FStartValue - 1) * FUnitSize;
 TickCount := 0;
 Tenth := FUnitSize;
 Val := Round(FStartValue);

 szBig := FSzBig * Height Div 100;
 szMiddle := FSzMiddle * Height Div 100;
 szSmall := FSzSmall * Height Div 100;

 Inherited Paint;

 With Canvas Do
  Begin
   Pen.Color := FTickColor;
   Pen.Style := psSolid;
   Pen.Width := 1;

   tF := TFont.Create;
   tF.Assign(FFont);

   GetObject(tF.Handle, SizeOf(lF), @lF);

   lF.lfEscapement := 0;

   tF.Handle := CreateFontIndirect(lF);
   Font.Assign(tF);

   Brush.Color := FColor;
   Brush.Style := bsSolid;
   FillRect(Rect(0 + fLeftBorder, 0, Width, Height));
   Pos := fLeftBorder;

   P0 := Self.Height - 1;
   P1 := Self.Height - 1 - szBig;
   P2 := Self.Height - 1 - szMiddle;
   P3 := Self.Height - 1 - szSmall;

   While Pos < Width - 1 Do
    Begin
     If TickCount > 9 Then
      TickCount := 0;

     If TickCount = 0 Then
      Begin
       S := Format('%.*f',[FUnitPrecision, (Val * FUnitPrice) + fUnitDisplacement]);
       Sw := TextWidth(S);

       TextOut(Round(Pos) - Sw Div 2, FNumberIndent-1, S);

       MoveTo(Round(Pos), P0);
       LineTo(Round(Pos), P1);

       Inc(Val);
      end
     Else
      If TickCount = 5 Then
       Begin
        MoveTo(Round(Pos), P0);
        LineTo(Round(Pos), P2);
       end
      Else
       Begin
        MoveTo(Round(Pos), P0);
        LineTo(Round(Pos), P3);
       end;

     Inc(TickCount);
     Pos := Pos + Tenth;
    end;

   tF.Free;
  end;
end;

procedure TPiRuler.SetColor(AColor: TColor);
begin
 If FColor = AColor Then
  Exit;

 FColor := AColor;

 If FEnableRepaint Then
  Invalidate;
end;

procedure TPiRuler.SetFont(AFont: TFont);
begin
 FFont.Assign(AFont);

 If FEnableRepaint Then
  Invalidate;
end;

procedure TPiRuler.SetStartValue(AStartVal: Double);
begin
 If FStartValue = AStartVal Then
  Exit;

 FStartValue := AStartVal;

 If FEnableRepaint Then
  Invalidate;
end;

procedure TPiRuler.SetSzBig(ASize: Integer);
begin
 If FSzBig = ASize Then
  Exit;

 FSzBig := ASize;

 If FEnableRepaint Then
  Invalidate;
end;

procedure TPiRuler.SetSzMiddle(ASize: Integer);
begin
 If FSzMiddle = ASize Then
  Exit;

 FSzMiddle := ASize;

 If FEnableRepaint Then
  Invalidate;
end;

procedure TPiRuler.SetSzSmall(ASize: Integer);
begin
 If FSzSmall = ASize Then
  Exit;

 FSzSmall := ASize;

 If FEnableRepaint Then
  Invalidate;
end;

procedure TPiRuler.SetUnitSize(AUnitSize: Double);
begin
 If FUnitSize = AUnitSize Then
  Exit;

 FUnitSize := AUnitSize;

 If FEnableRepaint Then
  Invalidate;
end;

procedure TPiRuler.SetUnitPrice(AUnitPrice: Double);
begin
 If FUnitPrice = AUnitPrice Then
  Exit;

 FUnitPrice := AUnitPrice;

 If FEnableRepaint Then
  Invalidate;
end;

procedure TPiRuler.SetUnitPrecision(APrecision: Integer);
begin
 If FUnitPrecision = APrecision Then
  Exit;

 If APrecision < 0 Then
  APrecision := 0;

 FUnitPrecision := APrecision;

 If FEnableRepaint Then
  Invalidate;
end;

procedure TPiRuler.SetNumberIndent(AnIndent: Integer);
begin
 If FNumberIndent = AnIndent Then
  Exit;

 FNumberIndent := AnIndent;

 If FEnableRepaint Then
  Invalidate;
end;

procedure TPiRuler.SetUnitDisplacement(AUnitDisp: Integer);
begin
 If fUnitDisplacement = AUnitDisp Then
  Exit;

 fUnitDisplacement := AUnitDisp;

 If FEnableRepaint Then
  Invalidate;
end;

constructor TPiRuler.Create(AOwner: TComponent);
begin
 Inherited Create(AOwner);

 ControlStyle := [csCaptureMouse, csOpaque, csClickEvents, csDoubleClicks];
 FColor := clYellow;
 FFont := TFont.Create;
 FFont.Name := 'default';
 FFont.Height := -9;
 Width := 200;
 Height := 24;
 FUnitSize := 50;
 FUnitPrice := 1;
 FUnitPrecision := 0;
 FSzBig := 45;
 FSzMiddle := 35;
 FSzSmall := 15;
 FTickColor := clBlack;
 FNumberIndent := 0;
 FRollLimits := TValRange.Create;
 FRollLimits.Max := 100;
 FEnableRepaint := True;
 fLeftBorder := 0;
 fUnitDisplacement := 0;
end;

end.

