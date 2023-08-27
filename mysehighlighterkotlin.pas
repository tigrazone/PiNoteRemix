{ <PiNote - free source code editor>

Copyright (C) <2023> <Enzo Antonio Calogiuri> <ecalogiuri(at)gmail.com>

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
unit MySEHighlighterKotlin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SynFacilHighlighter, SynEditHighlighter;

Type

    { TMySEHighlighterKotlin }

    TMySEHighlighterKotlin                = Class(TSynFacilSyn)
      Private
        fKeyWordList                      : TStringList;
        tnDataType                        : Integer;

      Protected
        function IsFilterStored: Boolean; override;
        function GetSampleSource: string; override;

      Public
        Constructor Create(AOwner: TComponent); Override;
        Destructor Destroy; Override;

        class function GetLanguageName: string; override;
    end;

implementation

Uses SynFacilBasic, SynEditStrConst;

Const
     SYNS_FilterKotlin              = 'Kotlin files (*.kt;*.kts)|*.kt;*.kts';
     SYNS_LangKotlin                = 'Kotlin';

     KotlinKeyWords                 = 'package,import,sealed,data,class,enum,' +
                                      'interface,companion,object,private,public,' +
                                      'protected,internal,open,final,get,set,fun,' +
                                      'var,val,constructor,inline,reified,crossinline,' +
                                      'tailrec,in,out,is,as,by,where,vararg,return,' +
                                      'throw,typealias,typeof,override,infix,operator,' +
                                      'if,else,when,for,while,do,try,catch,finally,' +
                                      'continue,break,yield,this,super,null,true,false';

     KotlinDataTypes                = 'unit,nothing,string,char,int,long,byte,' +
                                      'short,float,double,boolean';

{ TMySEHighlighterKotlin }

function TMySEHighlighterKotlin.IsFilterStored: Boolean;
begin
 Result := fDefaultFilter <> SYNS_FilterKotlin;
end;

function TMySEHighlighterKotlin.GetSampleSource: string;
begin
 Result := '//Sample Kotlin code' + #13#10 +
           '' + #13#10 +
           'fun main(args: Array<String>) {' + #13#10 +
           '' + #13#10 +
           '    val dividend = 25' + #13#10 +
           '    val divisor = 4' + #13#10 +
           '' + #13#10 +
           '    val quotient = dividend / divisor' + #13#10 +
           '    val remainder = dividend % divisor' + #13#10 +
           '' + #13#10 +
           '    println("Quotient = $quotient")' + #13#10 +
           '    println("Remainder = $remainder")' + #13#10 +
           '}';
end;

constructor TMySEHighlighterKotlin.Create(AOwner: TComponent);
 Var I : Word;
begin
 fKeyWordList := TStringList.Create;
 fKeyWordList.Delimiter := ',';
 fKeyWordList.StrictDelimiter := True;

 fKeyWordList.DelimitedText := KotlinKeyWords;

 Inherited Create(AOwner);

 ClearMethodTables;
 ClearSpecials;

 DefTokIdentif('[A-Za-z_]', '[A-Za-z0-9_]*');

 tnDataType := NewTokType(SYNS_AttrDataType);

 For I := 0 To fKeyWordList.Count - 1 Do
  AddKeyword(fKeyWordList[I]);

 fKeyWordList.Clear;
 fKeyWordList.DelimitedText := KotlinDataTypes;

 For I := 0 To fKeyWordList.Count - 1 Do
  AddIdentSpec(fKeyWordList[I], tnDataType);

 fKeyWordList.Free;

 DefTokDelim('"','"', tnString);
 DefTokDelim('//','', tnComment);
 DefTokDelim('/\*','\*/', tnComment, tdMulLin, True);

 DefTokContent('[0-9]', '[0-9]*[\.][0-9]+[eE][+-]?[0-9]+', tnNumber);
 DefTokContent('0x','[0-9a-fA-F]*', tnNumber);
 //DefTokContent('0X','[0-9A-F]*', tnNumber);
 DefTokContent('0b','[0-1]*', tnNumber);
 //DefTokContent('0B','[0-1]*', tnNumber);

 DefTokDelim('$','', NewTokType(SYNS_AttrUser));

 fDefaultFilter := SYNS_FilterKotlin;

 Rebuild;

 SetAttributesOnChange(@DefHighlightChange);
end;

destructor TMySEHighlighterKotlin.Destroy;
begin
 Inherited Destroy;
end;

class function TMySEHighlighterKotlin.GetLanguageName: string;
begin
 Result := SYNS_LangKotlin;
end;

end.

