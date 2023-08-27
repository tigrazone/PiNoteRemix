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
unit MySEHighlighterDart;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SynFacilHighlighter, SynEditHighlighter;

Type

    { TMySEHighlighterDart }

    TMySEHighlighterDart                   = Class(TSynFacilSyn)
      Private
        fKeyWordList                       : TStringList;
        tnDataType                         : Integer;
        tnPreProcessor                     : Integer;
        tnAnnotation                       : Integer;

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
     SYNS_FilterDart        = 'Dart files (*.dart)|*.dart';
     SYNS_LangDart          = 'Dart';

     DartKeyWords           = 'abstract,as,assert,async,await,break,case,' +
                              'catch,class,const,continue,default,deferred,' +
                              'do,else,enum,export,extends,external,' +
                              'factory,final,finally,for,get,hide,if,' +
                              'implements,import,in,interface,is,library,' +
                              'native,new,null,of,on,operator,part,rethrow,' +
                              'return,set,show,static,super,switch,this,' +
                              'throw,try,typedef,while,with,yield';

     DartDataTypes          = 'bool,double,dynamic,false,int,List,Map,num,' +
                              'String,true,var,void';

{ TMySEHighlighterDart }

function TMySEHighlighterDart.IsFilterStored: Boolean;
begin
 Result := fDefaultFilter <> SYNS_FilterDart;
end;

function TMySEHighlighterDart.GetSampleSource: string;
begin
 Result := 'import '#39'dart:html'#39';' + #13#10 +
           'main() {}' + #13#10 +
           '' + #13#10 +
           '#!Preproc' + #13#10 +
           '@Test' + #13#10 +
           'TestName func($var) {}' + #13#10 +
           '' + #13#10 +
           '  //not tree item' + #13#10 +
           '  if (query.contains('#39'?'#39')) {' + #13#10 +
           '    module.type(ServerController);' + #13#10 +
           '  }' + #13#10 +
           '' + #13#10 +
           '  void restoreEntry(String id, ' + #13#10 +
           '    void callback(FileEntry fileEntry)) {' + #13#10 +
           '    void __proxy_callback(fileEntry) {' + #13#10 +
           '      if (callback != null) {' + #13#10 +
           '        callback(fileEntry);' + #13#10 +
           '      }' + #13#10 +
           '    }' + #13#10 +
           '  }' + #13#10 +
           '' + #13#10 +
           '  void set accepts(List<FilesystemAcceptOption> accepts) {' + #13#10 +
           '  }' + #13#10 +
           '' + #13#10 +
           '  void addRules(String eventName, List<Rule> rules,' + #13#10 +
           '                [void callback(List<Rule> rules)]) {' + #13#10 +
           '                }' + #13#10 +
           '' + #13#10 +
           '  void getRules(String eventName, [List<String> ruleIdentifiers,' + #13#10 +
                        '                                   void callback(List<Rule> rule' + #13#10 +
             's)]) {' + #13#10 +
           '                                   }';
end;

constructor TMySEHighlighterDart.Create(AOwner: TComponent);
 Var I : Word;
begin
 fKeyWordList := TStringList.Create;
 fKeyWordList.Delimiter := ',';
 fKeyWordList.StrictDelimiter := True;

 fKeyWordList.DelimitedText := DartKeyWords;

 Inherited Create(AOwner);

 ClearMethodTables;
 ClearSpecials;

 DefTokIdentif('[A-Za-z_]', '[A-Za-z0-9_]*');

 tnDataType := NewTokType(SYNS_AttrDataType);
 tnPreProcessor := NewTokType(SYNS_AttrPreprocessor);
 tnAnnotation := NewTokType(SYNS_AttrAnnotation);

 For I := 0 To fKeyWordList.Count - 1 Do
  AddKeyword(fKeyWordList[I]);

 fKeyWordList.Clear;
 fKeyWordList.DelimitedText := DartDataTypes;

 For I := 0 To fKeyWordList.Count - 1 Do
  AddIdentSpec(fKeyWordList[I], tnDataType);

 fKeyWordList.Free;

 DefTokDelim('''','''', tnString, tdMulLin);
 DefTokDelim('//','', tnComment);
 DefTokDelim('///','', tnComment);
 DefTokDelim('/\*','\*/', tnComment, tdMulLin, False);
 DefTokDelim('#','', tnPreProcessor);
 DefTokDelim('@','', tnAnnotation);

 DefTokContent('[0123456789]','[0-9]', tnNumber);
 DefTokContent('0x','[0-9A-Fa-f]*', tnNumber);

 fDefaultFilter := SYNS_FilterDart;

 Rebuild;

 SetAttributesOnChange(@DefHighlightChange);
end;

destructor TMySEHighlighterDart.Destroy;
begin
 Inherited Destroy;
end;

class function TMySEHighlighterDart.GetLanguageName: string;
begin
 Result := SYNS_LangDart;
end;

end.

