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
unit uBanner;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

Const
           A        = 1;
           B        = 2;
           C        = 4;
           D        = 8;
           E        = 16;
           F        = 32;
           G        = 64;
           H        = 128;

           chSet    : String = ' 0123456789abcdefghijklmnopqrstuvwxyz' +
                               'ABCDEFGHIJKLMNOPQRSTUVWXYZ.,:!/\|+-*=';

           chMap    : Array [0..73,0..7] Of Byte = (
                      (* *) (0, 0, 0, 0, 0, 0, 0, 0),
                      (*0*) (B Or C Or D Or E Or F, A Or F Or G, A Or E Or G, A Or D Or G, A Or C Or G, A Or B Or G, B Or C Or D Or E Or F, 0),
                      (*1*) (G, F Or G, G, G, G, G, G, 0),
                      (*2*) (B Or C Or D Or E Or F, A Or G, G, C Or D Or E Or F, B, A, A Or B Or C Or D Or E Or F Or G, 0),
                      (*3*) (B Or C Or D Or E Or F, A Or G, G, C Or D Or E Or F, G, A Or G, B Or C Or D Or E Or F, 0),
                      (*4*) (A Or F, A Or F, A Or F, B Or C Or D Or E Or F Or G, F, F, F, 0),
                      (*5*) (A Or B Or C Or D Or E Or F Or G, A, A, B Or C Or D Or E Or F, G, A Or G, B Or C Or D Or E Or F, 0),
                      (*6*) (B Or C Or D Or E Or F, A, A, A Or B Or C Or D Or E Or F, A Or G, A Or G, B Or C Or D Or E Or F, 0),
                      (*7*) (B Or C Or D Or E Or F Or G, G, F, E, D, C, B, 0),
                      (*8*) (B Or C Or D Or E Or F, A Or G, A Or G, B Or C Or D Or E Or F, A Or G, A Or G, B Or C Or D Or E Or F, 0),
                      (*9*) (B Or C Or D Or E Or F, A Or G, A Or G, B Or C Or D Or E Or F Or G, G, G, B Or C Or D Or E Or F, 0),
                      (*a*) (0, 0, B Or C Or D Or E, F, B Or C Or D Or E Or F, A Or F, B Or C Or D Or E Or G, 0),
                      (*b*) (B, B, B, B Or C Or D Or E Or F, B Or G, B Or G, A Or C Or D Or E Or F, 0),
                      (*c*) (0, 0, C Or D Or E, B Or F, B, B Or F,C Or D Or E,0),
                      (*d*) (F, F, F, B Or C Or D Or E Or F, A Or F, A Or F, B Or C Or D Or E Or G, 0),
                      (*e*) (0, 0, B Or C Or D Or E, A Or F, A Or B Or C Or D Or E Or F, A, B Or C Or D Or E, 0),
                      (*f*) (C Or D Or E, B, B, A Or B Or C Or D, B, B, B, 0),
                      (*g*) (0, 0, B Or C Or D Or E Or F, A Or F, A Or F, B Or C Or D Or E Or F, F, B Or C Or D Or E),
                      (*h*) (B, B, B, B Or C Or D Or E, B Or F, B Or F, A Or B Or F, 0),
                      (*i*) (0, C, 0, B Or C, C, C, A Or B Or C Or D Or E, 0),
                      (*j*) (0, D, 0, D, D, D, A Or D, B Or C),
                      (*k*) (0, B Or E, B Or D, B Or C, B Or D, B Or E,B Or F, 0),
                      (*l*) (B Or C, C, C, C, C, C, A Or B Or C Or D, 0),
                      (*m*) (0, 0, A Or C Or E Or F, A Or B Or D Or G, A Or D Or G, A Or D Or G, A Or D Or G, 0),
                      (*n*) (0, 0, B Or D Or E, B Or C Or F, B Or F, B Or F, B Or F, 0),
                      (*o*) (0, 0, B Or C Or D Or E, A Or F, A Or F, A Or F, B Or C Or D Or E, 0),
                      (*p*) (0, 0, A Or B Or C Or D Or E, B Or F, B Or F, B Or C Or D Or E, B, A Or B),
                      (*q*) (0, 0, B Or C Or D Or E Or G, A Or F, A Or F, B Or C Or D Or E, F, F Or G),
                      (*r*) (0, 0, A Or B Or D Or E, B Or C Or F, B, B, A Or B, 0),
                      (*s*) (0, 0, B Or C Or D Or E, A, B Or C Or D Or E, F, A Or B Or C Or D Or E, 0),
                      (*t*) (0, C, C, A Or B Or C Or D Or E, C, C, D Or E, 0),
                      (*u*) (0, 0, A Or F, A Or F, A Or F, A Or F, B Or C Or D Or E Or G, 0),
                      (*v*) (0, 0, A Or G, B Or F, B Or F, C Or E, D, 0),
                      (*w*) (0, 0, A Or G, A Or G, A Or D Or G, A Or D Or G, B Or C Or E Or F, 0),
                      (*x*) (0, 0, A Or F, B Or E, C Or D, B Or E, A Or F, 0),
                      (*y*) (0, 0, B Or F, B Or F, B Or F, C Or F, A Or D Or E, B Or C Or D),
                      (*z*) (0, 0, A Or B Or C Or D Or E Or F, E, D, C, B Or C Or D Or E Or F Or G, 0),
                      (*A*) (D, C Or E, B Or F, A Or G, A Or B Or C Or D Or E Or F Or G, A Or G, A Or G, 0),
                      (*B*) (A Or B Or C Or D Or E, A Or F, A Or F, A Or B Or C Or D Or E, A Or F, A Or F, A Or B Or C Or D Or E, 0),
                      (*C*) (C Or D Or E, B Or F, A, A, A, B Or F, C Or D Or E, 0),
                      (*D*) (A Or B Or C Or D, A Or E, A Or F, A Or F, A Or F, A Or E, A Or B Or C Or D, 0),
                      (*E*) (A Or B Or C Or D Or E Or F, A, A, A Or B Or C Or D Or E, A, A, A Or B Or C Or D Or E Or F, 0),
                      (*F*) (A Or B Or C Or D Or E Or F, A, A, A Or B Or C Or D Or E, A, A, A, 0),
                      (*G*) (C Or D Or E, B Or F, A, A, A Or E Or F Or G, B Or F Or G, C Or D Or E Or G, 0),
                      (*H*) (A Or G, A Or G, A Or G, A Or B Or C Or D Or E Or F Or G, A Or G, A Or G, A Or G, 0),
                      (*I*) (A Or B Or C Or D Or E, C, C, C, C, C, A Or B Or C Or D Or E, 0),
                      (*J*) (A Or B Or C Or D Or E, C, C, C, C, C, A Or C, B),
                      (*K*) (A Or F, A Or E, A Or D, A Or B Or C, A Or D, A Or E, A Or F, 0),
                      (*L*) (A, A, A, A, A, A, A Or B Or C Or D Or E Or F, 0),
                      (*M*) (A Or B Or F Or G, A Or C Or E Or G, A Or D Or G, A Or G, A Or G, A Or G, A Or G, 0),
                      (*N*) (A Or G, A Or B Or G, A Or C Or G, A Or D Or G, A Or E Or G, A Or F Or G, A Or G, 0),
                      (*O*) (C Or D Or E, B Or F, A Or G, A Or G, A Or G, B Or F, C Or D Or E, 0),
                      (*P*) (A Or B Or C Or D, A Or E, A Or E, A Or B Or C Or D, A, A, A, 0),
                      (*Q*) (C Or D Or E, B Or F, A Or G, A Or G, A Or C Or G, B Or D Or F, C Or D Or E, F Or G),
                      (*R*) (A Or B Or C Or D, A Or E, A Or E, A Or B Or C Or D, A Or E, A Or F, A Or F, 0),
                      (*S*) (C Or D Or E, B Or F, C, D, E, B Or F, C Or D Or E, 0),
                      (*T*) (A Or B Or C Or D Or E Or F Or G, D, D, D, D, D, D, 0),
                      (*U*) (A Or G, A Or G, A Or G, A Or G, A Or G, B Or F, C Or D Or E, 0),
                      (*V*) (A Or G, A Or G, B Or F, B Or F, C Or E, C Or E, D, 0),
                      (*W*) (A Or G, A Or G, A Or G, A Or G, A Or D Or G, A Or C Or E Or G, B Or F, 0),
                      (*X*) (A Or G, A Or G, B Or F, C Or D Or E, B Or F, A Or G, A Or G, 0),
                      (*Y*) (A Or G, A Or G, B Or F, C Or E, D, D, D, 0),
                      (*Z*) (A Or B Or C Or D Or E Or F Or G, F, E, D, C, B, A Or B Or C Or D Or E Or F Or G, 0),
                      (*.*) (0, 0, 0, 0, 0, 0, D, 0),
                      (*,*) (0, 0, 0, 0, 0, E, E, D),
                      (*:*) (0, 0, 0, D, 0, 0, D, 0),
                      (*!*) (D, D, D, D, D, 0, D, 0),
                      (*/*) (G, F, E, D, C, B, A, 0),
                      (*\*) (A, B, C, D, E, F, G, 0),
                      (*|*) (D, D, D, D, D, D, D, D),
                      (*+*) (0, D, D, B Or C Or D Or E Or F, D, D, 0, 0),
                      (*-*) (0, 0, 0, B Or C Or D Or E Or F, 0, 0, 0, 0),
                      (***) (0, B Or D Or F, C Or D Or E, D, C Or D Or E, B Or D Or F, 0, 0),
                      (*=*) (0, 0, B Or C Or D Or E Or F, 0, B Or C Or D Or E Or F, 0, 0, 0)
                      );

Type

                      { TBanner }

                      TBanner      = Class
                        Private
                          fOutChar           : String;
                          fSpaceChar         : String;
                          fStringToPrint     : String;

                        Public
                          Constructor Create;
                          Destructor Destroy; Override;

                          Function BannerText : String;

                          Property OutChar : String Read fOutChar Write fOutChar;
                          Property SpaceChar : String Read fSpaceChar Write fSpaceChar;
                          Property StringToPrint : String Read fStringToPrint Write fStringToPrint;
                      end;

implementation

{ TBanner }

constructor TBanner.Create;
begin
 fOutChar := '#';
 fStringToPrint := '';
 fSpaceChar := ' ';
end;

destructor TBanner.Destroy;
begin
  inherited Destroy;
end;

function TBanner.BannerText: String;
 Var sTmp : String;
     OutLines : TStringList;
     Row, Col, sInd, Val : Word;
begin
 Result := '';

 If fStringToPrint = '' Then
  Exit;

 OutLines := TStringList.Create;

 For Row := 0 To 7 Do
  Begin
   sTmp := '';

   For sInd := 1 To Length(fStringToPrint) Do
    If Pos(fStringToPrint[sInd], chSet) > 0 Then
     For Col := 0 To 7 Do
      Begin
       Val := chMap[Pos(fStringToPrint[sInd], chSet) - 1, Row];
       Val := Val And (1 Shl Col);

       If Val <> 0 Then
        sTmp := sTmp + fOutChar
       Else
        sTmp := sTmp + fSpaceChar;
      end;

   OutLines.Add(sTmp);
  end;

 Result := OutLines.Text;

 OutLines.Free;
end;

end.

