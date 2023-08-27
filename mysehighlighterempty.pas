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
unit MySEHighlighterEmpty;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SynFacilHighlighter, SynEditHighlighter;

Type

    { TMySEHighlighterEmpty }

    TMySEHighlighterEmpty               = Class(TSynFacilSyn)
     Private
      fKeyWordList                       : TStringList;
      tnFunctions                        : Integer;

     Protected
      function IsFilterStored: Boolean; override;
      function GetSampleSource: string; override;

     Public
      Constructor Create(AOwner: TComponent); Override;
      Destructor Destroy; Override;

      class function GetLanguageName: string; override;
    end;

implementation

{ TMySEHighlighterEmpty }

function TMySEHighlighterEmpty.IsFilterStored: Boolean;
begin
 Result:=inherited IsFilterStored;
end;

function TMySEHighlighterEmpty.GetSampleSource: string;
begin
 Result := '';
end;

constructor TMySEHighlighterEmpty.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);

 ClearMethodTables;
 ClearSpecials;

 DefTokIdentif('[A-Za-z_]', '[A-Za-z0-9_]*');
end;

destructor TMySEHighlighterEmpty.Destroy;
begin
 inherited Destroy;
end;

class function TMySEHighlighterEmpty.GetLanguageName: string;
begin
 Result := '';
end;

end.

