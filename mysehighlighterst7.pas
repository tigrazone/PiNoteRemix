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
unit MySEHighlighterST7;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, SynEditTypes, SynEditHighlighter,
  SynHighlighterHashEntries;

type
  TtkTokenKind = (tkComment, tkIdentifier, tkKey, tkNull, tkNumber, tkSpace,
    tkString, tkSymbol, tkUnknown, tkSystemValue);

  TProcTableProc = procedure of object;

type

  TMySynST7Syn = class(TSynCustomHighlighter)
  private
    fLine: PChar;
    fLineNumber: Integer;
    fProcTable: array[#0..#255] of TProcTableProc;
    Run: LongInt;
    fStringLen: Integer;
    fToIdent: PChar;
    fTokenPos: Integer;
    fTokenID: TtkTokenKind;
    fCommentAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fStringAttri: TSynHighlighterAttributes;
    fSymbolAttri: TSynHighlighterAttributes;
    fKeywords: TSynHashEntryList;
    fSystemValueAttri : TSynHighlighterAttributes;
    function KeyHash(ToHash: PChar): Integer;
    function KeyComp(const aKey: String): Boolean;
    procedure CommentProc;
    procedure CRProc;
    procedure GreaterProc;
    procedure IdentProc;
    procedure LFProc;
    procedure LowerProc;
    procedure NullProc;
    procedure NumberProc;
    procedure SlashProc;
    procedure SpaceProc;
    procedure StringProc;
    procedure SingleQuoteStringProc;
    procedure SymbolProc;
    procedure UnknownProc;
    procedure DoAddKeyword(AKeyword: string; AKind: integer);
    function IdentKind(MayBe: PChar): TtkTokenKind;
    procedure MakeMethodTables;
  protected
    function GetIdentChars: TSynIdentChars; override;
    function GetSampleSource: string; override;
    function IsFilterStored: Boolean; override;
  public
    class function GetLanguageName: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes;
      override;
    function GetEol: Boolean; override;
    function GetTokenID: TtkTokenKind;
    procedure SetLine(Const NewValue: String; LineNumber:Integer); Override;
    function GetToken: String; override;
    procedure GetTokenEx(out TokenStart: PChar; out TokenLength: integer); override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: integer; override;
    function GetTokenPos: Integer; override;
    procedure Next; override;
  published
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri
      write fCommentAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri
      write fIdentifierAttri;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri
      write fNumberAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri
      write fSpaceAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri
      write fStringAttri;
    property SymbolAttri: TSynHighlighterAttributes read fSymbolAttri
      write fSymbolAttri;
    property SystemValueAttri : TSynHighlighterAttributes Read fSystemValueAttri
      write fSystemValueAttri;
  end;

implementation

uses
{$IFDEF SYN_CLX}
  QSynEditStrConst;
{$ELSE}
  SynEditStrConst;
{$ENDIF}

var
  Identifiers: array[#0..#255] of ByteBool;
  mHashTable: array[#0..#255] of Integer;

const
  OpCodes : String = 'adc,add,and,bcp,bres,bset,btjf,btjt,call,callr,clr,cp,cpl,' +
                     'dec,halt,iret,inc,jp,jra,jrt,jrf,jrih,jril,jrh,jrnh,jrm,' +
                     'jrnm,jrmi,jrpl,jreq,jrne,jrc,jrnc,jrult,jruge,jrugt,jrule,' +
                     'ld,mul,neg,nop,or,pop,push,rcf,ret,rim,rlc,rrc,rsp,sbc,' +
                     'scf,sim,sla,sll,srl,sra,sub,swap,tnz,trap,wfi,xor';

  SystemValues : String = 'A,X,Y,PC,SP,CC,H,I,N,Z,C';

  SYNS_FilterST7Assembly        =  'ST7 Assembly Files (*.st7,*.asm)|*.st7;*.asm';
  SYNS_LangST7Asm               =  'Assembly ST7 Microcontroller';

procedure MakeIdentTable;
var
  c: char;
begin
  FillChar(Identifiers, SizeOf(Identifiers), 0);
  for c := 'a' to 'z' do
    Identifiers[c] := TRUE;
  for c := 'A' to 'Z' do
    Identifiers[c] := TRUE;
  for c := '0' to '9' do
    Identifiers[c] := TRUE;
  Identifiers['_'] := TRUE;

  FillChar(mHashTable, SizeOf(mHashTable), 0);
  for c := 'a' to 'z' do
    mHashTable[c] := 1 + Ord(c) - Ord('a');
  for c := 'A' to 'Z' do
    mHashTable[c] := 1 + Ord(c) - Ord('A');
  for c := '0' to '9' do
    mHashTable[c] := 27 + Ord(c) - Ord('0');
end;

function TMySynST7Syn.KeyHash(ToHash: PChar): Integer;
begin
  Result := 0;
  while Identifiers[ToHash^] do begin
{$IFOPT Q-}
    Result := 7 * Result + mHashTable[ToHash^];
{$ELSE}
    Result := (7 * Result + mHashTable[ToHash^]) and $FFFFFF;
{$ENDIF}
    inc(ToHash);
  end;
  Result := Result and $3FF;
  fStringLen := ToHash - fToIdent;
end;

function TMySynST7Syn.KeyComp(const aKey: String): Boolean;
var
  i: integer;
  pKey1, pKey2: PChar;
begin
  pKey1 := fToIdent;
  // Note: fStringLen is always > 0 !
  pKey2 := pointer(aKey);
  for i := 1 to fStringLen do
  begin
    if mHashTable[pKey1^] <> mHashTable[pKey2^] then
    begin
      Result := FALSE;
      exit;
    end;
    Inc(pKey1);
    Inc(pKey2);
  end;
  Result := TRUE;
end;

procedure TMySynST7Syn.DoAddKeyword(AKeyword: string; AKind: integer);
var
  HashValue: integer;
begin
  HashValue := KeyHash(PChar(AKeyword));
  fKeywords[HashValue] := TSynHashEntry.Create(AKeyword, AKind);
end;

function TMySynST7Syn.IdentKind(MayBe: PChar): TtkTokenKind;
var
  Entry: TSynHashEntry;
begin
  fToIdent := MayBe;
  Entry := fKeywords[KeyHash(MayBe)];
  while Assigned(Entry) do begin
    if Entry.KeywordLen > fStringLen then
      break
    else if Entry.KeywordLen = fStringLen then
      if KeyComp(Entry.Keyword) then begin
        Result := TtkTokenKind(Entry.Kind);
        exit;
      end;
    Entry := Entry.Next;
  end;
  Result := tkIdentifier;
end;

procedure TMySynST7Syn.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
       #0 : fProcTable[I] := @NullProc;
      #10 : fProcTable[I] := @LFProc;
      #13 : fProcTable[I] := @CRProc;
      #34 : fProcTable[I] := @StringProc;
      #39 : fProcTable[I] := @SingleQuoteStringProc;
      '>' : fProcTable[I] := @GreaterProc;
      '<' : fProcTable[I] := @LowerProc;
      '/' : fProcTable[I] := @SlashProc;

      'A'..'Z', 'a'..'z', '_':
        fProcTable[I] := @IdentProc;
      '0'..'9':
        fProcTable[I] := @NumberProc;
      #1..#9, #11, #12, #14..#32:
        fProcTable[I] := @SpaceProc;
      '#', ';':
        fProcTable[I] := @CommentProc;
      '.', ':', '&', '{', '}', '=', '^', '-', '+', '(', ')', '*':
        fProcTable[I] := @SymbolProc;
      else
        fProcTable[I] := @UnknownProc;
    end;
end;

constructor TMySynST7Syn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fKeywords := TSynHashEntryList.Create;

  fCommentAttri       := TSynHighlighterAttributes.Create(SYNS_AttrComment);
  fCommentAttri.Style := [fsItalic];
  AddAttribute(fCommentAttri);
  fIdentifierAttri    := TSynHighlighterAttributes.Create(SYNS_AttrIdentifier);
  AddAttribute(fIdentifierAttri);
  fKeyAttri           := TSynHighlighterAttributes.Create(SYNS_AttrReservedWord);
  fKeyAttri.Style     := [fsBold];
  AddAttribute(fKeyAttri);
  fNumberAttri        := TSynHighlighterAttributes.Create(SYNS_AttrNumber);
  AddAttribute(fNumberAttri);
  fSpaceAttri         := TSynHighlighterAttributes.Create(SYNS_AttrSpace);
  AddAttribute(fSpaceAttri);
  fStringAttri        := TSynHighlighterAttributes.Create(SYNS_AttrString);
  AddAttribute(fStringAttri);
  fSymbolAttri        := TSynHighlighterAttributes.Create(SYNS_AttrSymbol);
  AddAttribute(fSymbolAttri);
  fSystemValueAttri := TSynHighlighterAttributes.Create(SYNS_AttrSystemValue);
  AddAttribute(fSystemValueAttri);

  MakeMethodTables;
  EnumerateKeywords(Ord(tkKey), OpCodes, IdentChars, @DoAddKeyword);
  EnumerateKeywords(Ord(tkSystemValue), SystemValues, IdentChars, @DoAddKeyword);
  SetAttributesOnChange(@DefHighlightChange);
  fDefaultFilter      := SYNS_FilterST7Assembly;
end;

destructor TMySynST7Syn.Destroy;
begin
  fKeywords.Free;
  inherited Destroy;
end;

procedure TMySynST7Syn.SetLine(const NewValue: String; LineNumber: Integer);
begin
  Inherited;
  fLine := PChar(NewValue);
  Run := 0;
  fLineNumber := LineNumber;
  Next;
end;

procedure TMySynST7Syn.CommentProc;
begin
  fTokenID := tkComment;
  repeat
    Inc(Run);
  until fLine[Run] in [#0, #10, #13];
end;

procedure TMySynST7Syn.CRProc;
begin
  fTokenID := tkSpace;
  Inc(Run);
  if fLine[Run] = #10 then Inc(Run);
end;

procedure TMySynST7Syn.GreaterProc;
begin
  Inc(Run);
  fTokenID := tkSymbol;
  if fLine[Run] = '=' then Inc(Run);
end;

procedure TMySynST7Syn.IdentProc;
begin
  fTokenID := IdentKind((fLine + Run));
  inc(Run, fStringLen);
  while Identifiers[fLine[Run]] do inc(Run);
end;

procedure TMySynST7Syn.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end;

procedure TMySynST7Syn.LowerProc;
begin
  Inc(Run);
  fTokenID := tkSymbol;
  if fLine[Run] in ['=', '>'] then Inc(Run);
end;

procedure TMySynST7Syn.NullProc;
begin
  fTokenID := tkNull;
end;

procedure TMySynST7Syn.NumberProc;
begin
  inc(Run);
  fTokenID := tkNumber;
  while FLine[Run] in ['0'..'9', '.', 'a'..'f', 'h', 'A'..'F', 'H'] do
    Inc(Run);
end;

procedure TMySynST7Syn.SlashProc;
begin
  Inc(Run);
  if fLine[Run] = '/' then begin
    fTokenID := tkComment;
    repeat
      Inc(Run);
    until fLine[Run] in [#0, #10, #13];
  end else
    fTokenID := tkSymbol;
end;

procedure TMySynST7Syn.SpaceProc;
begin
  fTokenID := tkSpace;
  repeat
    Inc(Run);
  until (fLine[Run] > #32) or (fLine[Run] in [#0, #10, #13]);
end;

procedure TMySynST7Syn.StringProc;
begin
  fTokenID := tkString;
  if (FLine[Run + 1] = #34) and (FLine[Run + 2] = #34) then
    inc(Run, 2);
  repeat
    case FLine[Run] of
      #0, #10, #13: break;
    end;
    inc(Run);
  until FLine[Run] = #34;
  if FLine[Run] <> #0 then inc(Run);
end;

procedure TMySynST7Syn.SingleQuoteStringProc;
begin
  fTokenID := tkString;
  if (FLine[Run + 1] = #39) and (FLine[Run + 2] = #39) then
    inc(Run, 2);
  repeat
    case FLine[Run] of
      #0, #10, #13: break;
    end;
    inc(Run);
  until FLine[Run] = #39;
  if FLine[Run] <> #0 then inc(Run);
end;

procedure TMySynST7Syn.SymbolProc;
begin
  inc(Run);
  fTokenID := tkSymbol;
end;

procedure TMySynST7Syn.UnknownProc;
begin
{$IFDEF SYN_MBCSSUPPORT}
  if FLine[Run] in LeadBytes then
    Inc(Run, 2)
  else
{$ENDIF}
  inc(Run);
  fTokenID := tkIdentifier;
end;

procedure TMySynST7Syn.Next;
begin
  fTokenPos := Run;
  fProcTable[fLine[Run]];
end;

function TMySynST7Syn.GetDefaultAttribute(Index: integer): TSynHighlighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT: Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER: Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD: Result := fKeyAttri;
    SYN_ATTR_STRING: Result := fStringAttri;
    SYN_ATTR_WHITESPACE: Result := fSpaceAttri;
    SYN_ATTR_SYMBOL: Result := fSymbolAttri;
  else
    Result := nil;
  end;
end;

function TMySynST7Syn.GetEol: Boolean;
begin
  Result := fTokenId = tkNull;
end;

function TMySynST7Syn.GetToken: String;
var
  Len: LongInt;
begin
  Len := Run - fTokenPos;
  SetString(Result, (FLine + fTokenPos), Len);
end;

procedure TMySynST7Syn.GetTokenEx(out TokenStart: PChar; out TokenLength: integer
  );
begin
 TokenLength:=Run-fTokenPos;
 TokenStart:=FLine + fTokenPos;
end;

function TMySynST7Syn.GetTokenAttribute: TSynHighlighterAttributes;
begin
  case fTokenID of
    tkComment: Result := fCommentAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkNumber: Result := fNumberAttri;
    tkSpace: Result := fSpaceAttri;
    tkString: Result := fStringAttri;
    tkSymbol: Result := fSymbolAttri;
    tkUnknown: Result := fIdentifierAttri;
    tkSystemValue : Result := fSystemValueAttri;
    else Result := nil;
  end;
end;

function TMySynST7Syn.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

function TMySynST7Syn.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TMySynST7Syn.GetTokenPos: Integer;
begin
  Result := fTokenPos;
end;

function TMySynST7Syn.GetIdentChars: TSynIdentChars;
begin
  Result := TSynValidStringChars;
end;

class function TMySynST7Syn.GetLanguageName: string;
begin
  Result := SYNS_LangST7Asm;
end;

function TMySynST7Syn.IsFilterStored: Boolean;
begin
  Result := fDefaultFilter <> SYNS_FilterST7Assembly;
end;

function TMySynST7Syn.GetSampleSource: string;
begin
  Result := '//This is simple not working ST7 code' + Chr(13) +
           '' + Chr(13) +
           'PUSH        CC' + Chr(13) +
           'PUSH        A' + Chr(13) +
           'AND         A,7'+ Chr(13) +
           'LD          Y,A' + Chr(13) +
           'OR          A,(X)' + Chr(13) +
           'LD          (X),A' + Chr(13) +
           'POP         A' + Chr(13) +
           'POP         CC' + Chr(13) +
           'RET';
end;

initialization
  MakeIdentTable;
end.

