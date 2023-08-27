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

unit MySEHighlighterSwift;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SynFacilHighlighter, SynEditHighlighter;

Type

    { TMySEHighlighterSwift }

    TMySEHighlighterSwift                 = Class(TSynFacilSyn)
      Private
        fKeyWordList                       : TStringList;
        tnDataType                         : Integer;

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
     SYNS_FilterSwift              = 'Swift files (*.swift)|*.swift';
     SYNS_LangSwift                = 'Swift';

     SwiftKeyWords                 = '__COLUMN__,__FILE__,__FUNCTION__,' +
                                     '__LINE__,as,associativity,break,' +
                                     'case,class,continue,default,deinit,' +
                                     'didSet,do,dynamicType,else,enum,extension,' +
                                     'fallthrough,for,func,get,if,import,in,' +
                                     'infix,init,inout,is,left,let,mutating,' +
                                     'new,none,nonmutating,operator,override,' +
                                     'postfix,precedence,prefix,protocol,return,' +
                                     'right,self,set,static,struct,subscript,' +
                                     'super,switch,Type,typealias,unowned,var,' +
                                     'weak,where,while,willSet';

     SwiftDataTypes                = 'Int,Void,String,Double,Float,Bool,' +
                                     'Optional,Character,Int8,Int16,Int32,' +
                                     'Int64,UInt';

{ TMySEHighlighterSwift }

function TMySEHighlighterSwift.IsFilterStored: Boolean;
begin
 Result := fDefaultFilter <> SYNS_FilterSwift;
end;

function TMySEHighlighterSwift.GetSampleSource: string;
begin
 Result := '//Test test' + #13#10 +
           '' + #13#10 +
           'import UIKit' + #13#10 +
           '' + #13#10 +
           '@UIApplicationMain' + #13#10 +
           '' + #13#10 +
           'protocol AppearanceProviderProtocol: class {' + #13#10 +
           '  func tileColor(value: Int) -> UIColor' + #13#10 +
           '  func numberColor(value: Int) -> UIColor' + #13#10 +
           '  func fontForNumbers() -> UIFont' + #13#10 +
           '}' + #13#10 +
           '' + #13#10 +
           'class AppDelegate: UIResponder, UIApplicationDelegate {' + #13#10 +
           '                            ' + #13#10 +
           '  var window: UIWindow?' + #13#10 +
           '' + #13#10 +
           '  func application(application: UIApplication, didFinishLaunchin' + #13#10 +
           '  gWithOptions launchOptions: NSDictionary?) -> Bool {' + #13#10 +
           '    // Override point for customization after application launch' + #13#10 +
           '.' + #13#10 +
           '    return true' + #13#10 +
           '  }' + #13#10 +
           '  ' + #13#10 +
           '  func fontForNumbers() -> UIFont {' + #13#10 +
           '    if let font = UIFont(name: "HelveticaNeue-Bold", size: 20) {' + #13#10 +
           '      return font' + #13#10 +
           '    }' + #13#10 +
           '    return UIFont.systemFontOfSize(20)' + #13#10 +
           '  }' + #13#10 +
           '}';
end;

constructor TMySEHighlighterSwift.Create(AOwner: TComponent);
 Var I : Integer;
begin
 fKeyWordList := TStringList.Create;
 fKeyWordList.Delimiter := ',';
 fKeyWordList.StrictDelimiter := True;

 fKeyWordList.DelimitedText := SwiftKeyWords;

 Inherited Create(AOwner);

 ClearMethodTables;
 ClearSpecials;

 DefTokIdentif('[A-Za-z_]', '[A-Za-z0-9_]*');

 tnDataType := NewTokType(SYNS_AttrDataType);

 For I := 0 To fKeyWordList.Count - 1 Do
  AddKeyword(fKeyWordList[I]);

 fKeyWordList.Clear;
 fKeyWordList.DelimitedText := SwiftDataTypes;

 For I := 0 To fKeyWordList.Count - 1 Do
  AddIdentSpec(fKeyWordList[I], tnDataType);

 fKeyWordList.Free;

 DefTokDelim('"','"', tnString);
 //DefTokDelim('''','''', tnString, tdMulLin);
 DefTokDelim('//','', tnComment);
 DefTokDelim('/\*','\*/', tnComment, tdMulLin, True);

 DefTokContent('[0123456789]','[0-9]', tnNumber);
 DefTokContent('0x','[0-9a-f]*', tnNumber);
 DefTokContent('@','[A-Za-z0-9_]*', tnSymbol);

 fDefaultFilter := SYNS_FilterSwift;

 Rebuild;

 SetAttributesOnChange(@DefHighlightChange);
end;

destructor TMySEHighlighterSwift.Destroy;
begin
  inherited Destroy;
end;

class function TMySEHighlighterSwift.GetLanguageName: string;
begin
 Result := SYNS_LangSwift;
end;

end.

