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
unit uGenericAsm_Highlighter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, SynEditHighlighter, SynHighlighterHashEntries,
  SynEditTypes, SynEditStrConst;

Type
    TtkTokenKind = (tkComment, tkIdentifier, tkKey, tkNull, tkNumber, tkSpace,
                    tkString, tkSymbol, tkUnknown, tkSystemValue);

    TProcTableProc            = Procedure Of Object;

    { TGenericAsmSyn }

    TGenericAsmSyn            = Class(TSynCustomHighlighter)
     Private
      fLine                   : PChar;
      fLineNumber             : Integer;
      fProcTable              : Array[#0..#255] Of TProcTableProc;
      Identifiers             : Array[#0..#255] Of ByteBool;
      mHashTable              : Array[#0..#255] Of Integer;
      Run                     : LongInt;
      fStringLen              : Integer;
      fToIdent                : PChar;
      fTokenPos               : Integer;
      fTokenID                : TtkTokenKind;
      fCommentAttri           : TSynHighlighterAttributes;
      fIdentifierAttri        : TSynHighlighterAttributes;
      fKeyAttri               : TSynHighlighterAttributes;
      fNumberAttri            : TSynHighlighterAttributes;
      fSpaceAttri             : TSynHighlighterAttributes;
      fStringAttri            : TSynHighlighterAttributes;
      fSymbolAttri            : TSynHighlighterAttributes;
      fSystemValueAttri       : TSynHighlighterAttributes;
      fKeywords               : TSynHashEntryList;
      fOpcodes                : String;
      fSampleSource           : String;
      fFilterStored           : String;
      fLanguageName           : String;
      fSystemValue            : String;
      fAddNumberIdentifier    : Char;

      Procedure MakeIdentTable;
      Function KeyHash(ToHash: PChar): Integer;
      Function KeyComp(const aKey: String): Boolean;
      Procedure CommentProc;
      Procedure CRProc;
      Procedure GreaterProc;
      Procedure IdentProc;
      Procedure LFProc;
      Procedure LowerProc;
      Procedure NullProc;
      Procedure NumberProc;
      Procedure SlashProc;
      Procedure SpaceProc;
      Procedure StringProc;
      Procedure SingleQuoteStringProc;
      Procedure SymbolProc;
      Procedure UnknownProc;
      Procedure DoAddKeyword(AKeyword: string; AKind: integer);
      Function IdentKind(MayBe: PChar): TtkTokenKind;
      Procedure MakeMethodTables;

     Protected
      Function GetIdentChars: TSynIdentChars; override;
      Function GetSampleSource: string; override;
      Function IsFilterStored: Boolean; override;

     Public
      class function GetLanguageName: string; override;

      Constructor Create(AOwner: TComponent); override;
      Procedure SetupHighlighter;
      Destructor Destroy; override;
      Function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes; Override;
      Function GetEol: Boolean; override;
      Function GetTokenID: TtkTokenKind;
      Procedure SetLine(Const NewValue: AnsiString; LineNumber:LongInt); override;
      Function GetToken: String; override;
      Function GetTokenAttribute: TSynHighlighterAttributes; override;
      Function GetTokenKind: integer; override;
      Function GetTokenPos: Integer; override;
      Procedure GetTokenEx(out TokenStart: PChar; out TokenLength: integer); override;
      Procedure Next; override;

     Published
      Property CommentAttri: TSynHighlighterAttributes read fCommentAttri Write fCommentAttri;
      Property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri write fIdentifierAttri;
      Property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
      Property NumberAttri: TSynHighlighterAttributes read fNumberAttri write fNumberAttri;
      Property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri write fSpaceAttri;
      Property StringAttri: TSynHighlighterAttributes read fStringAttri Write fStringAttri;
      Property SymbolAttri: TSynHighlighterAttributes read fSymbolAttri write fSymbolAttri;
      Property OpCodes : String Read fOpCodes Write fOpCodes;
      Property SampleSource : String Read fSampleSource Write fSampleSource;
      Property FilterStored : String Read fFilterStored Write fFilterStored;
      Property LanguageName: String Read GetLanguageName;
      Property AsmLanguageName : String Read fLanguageName Write fLanguageName;
      Property SystemValue : String Read fSystemValue Write fSystemValue;
      Property AddNumberIdentifier : Char Read fAddNumberIdentifier Write fAddNumberIdentifier;
    end;

implementation

{ TGenericAsmSyn }

procedure TGenericAsmSyn.MakeIdentTable;
 Var C : Char;
begin
 FillChar(Identifiers, SizeOf(Identifiers), 0);

 For C := 'a' To 'z' Do
  Identifiers[C] := True;

 For C := 'A' To 'Z' Do
  Identifiers[C] := True;

 For C := '0' To '9' Do
  Identifiers[C] := True;

 Identifiers['_'] := True;

 FillChar(mHashTable, SizeOf(mHashTable), 0);

 For C := 'a' To 'z' Do
  mHashTable[C] := 1 + Ord(C) - Ord('a');

 For C := 'A' To 'Z' Do
  mHashTable[C] := 1 + Ord(C) - Ord('A');

 For C := '0' To '9' Do
  mHashTable[C] := 27 + Ord(C) - Ord('0');
end;

function TGenericAsmSyn.KeyHash(ToHash: PChar): Integer;
begin
 Result := 0;

 While Identifiers[ToHash^] Do
  Begin
{$IFOPT Q-}
   Result := 7 * Result + mHashTable[ToHash^];
{$ELSE}
   Result := (7 * Result + mHashTable[ToHash^]) And $FFFFFF;
{$ENDIF}
   Inc(ToHash);
  End;

 Result := Result And $3FF;
 fStringLen := ToHash - fToIdent;
end;

function TGenericAsmSyn.KeyComp(const aKey: String): Boolean;
 Var I : Integer;
     pKey1, pKey2 : PChar;
begin
 pKey1 := fToIdent;
 pKey2 := Pointer(aKey);

 For I := 1 To fStringLen Do
  Begin
   If mHashTable[pKey1^] <> mHashTable[pKey2^] Then
    Begin
     Result := False;

     Exit;
    End;

   Inc(pKey1);
   Inc(pKey2);
  End;

 Result := True;
end;

procedure TGenericAsmSyn.CommentProc;
begin
 fTokenID := tkComment;

 Repeat
  Inc(Run);
 Until fLine[Run] In [#0, #10, #13];
end;

procedure TGenericAsmSyn.CRProc;
begin
 fTokenID := tkSpace;

 Inc(Run);

 If fLine[Run] = #10 Then
  Inc(Run);
end;

procedure TGenericAsmSyn.GreaterProc;
begin
 Inc(Run);

 fTokenID := tkSymbol;

 If fLine[Run] = '=' Then
  Inc(Run);
end;

procedure TGenericAsmSyn.IdentProc;
begin
 fTokenID := IdentKind((fLine + Run));

 Inc(Run, fStringLen);

 While Identifiers[fLine[Run]] Do
  Inc(Run);
end;

procedure TGenericAsmSyn.LFProc;
begin
 fTokenID := tkSpace;

 Inc(Run);
end;

procedure TGenericAsmSyn.LowerProc;
begin
 Inc(Run);

 fTokenID := tkSymbol;

 If fLine[Run] In ['=', '>'] Then
  Inc(Run);
end;

procedure TGenericAsmSyn.NullProc;
begin
 fTokenID := tkNull;
end;

procedure TGenericAsmSyn.NumberProc;
begin
 Inc(Run);

 fTokenID := tkNumber;

 If fAddNumberIdentifier = #0 Then
  Begin
   While FLine[Run] In ['0'..'9', '.', 'a'..'f', 'h', 'A'..'F', 'H', '$', 'x', 'X'] Do
    Inc(Run);
  end
 Else
  While FLine[Run] In ['0'..'9', '.', 'a'..'f', 'h', 'A'..'F', 'H', '$', 'x', 'X', fAddNumberIdentifier] Do
   Inc(Run);
end;

procedure TGenericAsmSyn.SlashProc;
begin
 Inc(Run);

 If fLine[Run] = '/' Then
  Begin
   fTokenID := tkComment;

   Repeat
    Inc(Run);
   Until fLine[Run] In [#0, #10, #13];
  End
 Else
  fTokenID := tkSymbol;
end;

procedure TGenericAsmSyn.SpaceProc;
begin
 fTokenID := tkSpace;

 Repeat
  Inc(Run);
 Until (fLine[Run] > #32) Or (fLine[Run] In [#0, #10, #13]);
end;

procedure TGenericAsmSyn.StringProc;
begin
 fTokenID := tkString;

 If (FLine[Run + 1] = #34) And (FLine[Run + 2] = #34) Then
  Inc(Run, 2);

 Repeat
  Case FLine[Run] Of
      #0, #10, #13         : Break;
  End;

  Inc(Run);
 Until FLine[Run] = #34;

 If FLine[Run] <> #0 Then
  Inc(Run);
end;

procedure TGenericAsmSyn.SingleQuoteStringProc;
begin
 fTokenID := tkString;

 If (FLine[Run + 1] = #39) And (FLine[Run + 2] = #39) Then
  Inc(Run, 2);

 Repeat
  Case FLine[Run] Of
      #0, #10, #13         : Break;
  End;

  Inc(Run);
 Until FLine[Run] = #39;


 If FLine[Run] <> #0 Then
  Inc(Run);
end;

procedure TGenericAsmSyn.SymbolProc;
begin
 Inc(Run);

 fTokenID := tkSymbol;
end;

procedure TGenericAsmSyn.UnknownProc;
begin
 Inc(Run);

 fTokenID := tkIdentifier;
end;

procedure TGenericAsmSyn.DoAddKeyword(AKeyword: string; AKind: integer);
 Var HashValue : Integer;
begin
 HashValue := KeyHash(PChar(AKeyword));

 fKeywords[HashValue] := TSynHashEntry.Create(AKeyword, AKind);
end;

function TGenericAsmSyn.IdentKind(MayBe: PChar): TtkTokenKind;
 Var Entry : TSynHashEntry;
begin
 fToIdent := MayBe;
 Entry := fKeywords[KeyHash(MayBe)];

 While Assigned(Entry) Do
  Begin
   If Entry.KeywordLen > fStringLen Then
    Break
   Else
    If Entry.KeywordLen = fStringLen Then
     If KeyComp(Entry.Keyword) Then
      Begin
       Result := TtkTokenKind(Entry.Kind);
       exit;
      End;

   Entry := Entry.Next;
  End;

 Result := tkIdentifier;
end;

procedure TGenericAsmSyn.MakeMethodTables;
 Var I : Char;
begin
 For I := #0 To #255 Do
  Case I Of
       #0       : fProcTable[I] := @NullProc;
       #10      : fProcTable[I] := @LFProc;
       #13      : fProcTable[I] := @CRProc;
       #34      : fProcTable[I] := @StringProc;
       #39      : fProcTable[I] := @SingleQuoteStringProc;
       '>'      : fProcTable[I] := @GreaterProc;
       '<'      : fProcTable[I] := @LowerProc;
       '/'      : fProcTable[I] := @SlashProc;
       'A'..'Z',
       'a'..'z',
       '_'      : fProcTable[I] := @IdentProc;
       '0'..'9' : fProcTable[I] := @NumberProc;
       #1..#9,
       #11,
       #12,
       #14..#32 : fProcTable[I] := @SpaceProc;
       '@',
       ';'      : fProcTable[I] := @CommentProc;
       '.',
       ':',
       '&',
       '{',
       '}',
       '=',
       '^',
       '-',
       '+',
       '(',
       ')',
       '*'      : fProcTable[I] := @SymbolProc;
       Else       fProcTable[I] := @UnknownProc;
  End;
end;

function TGenericAsmSyn.GetIdentChars: TSynIdentChars;
begin
 Result := TSynValidStringChars;
end;

function TGenericAsmSyn.GetSampleSource: string;
begin
 Result := fSampleSource;
end;

function TGenericAsmSyn.IsFilterStored: Boolean;
begin
 Result := fDefaultFilter <> fFilterStored;
end;

class function TGenericAsmSyn.GetLanguageName: string;
begin
 Result := '-1';
end;

constructor TGenericAsmSyn.Create(AOwner: TComponent);
begin
 Inherited Create(AOwner);

 MakeIdentTable;

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

 fSystemValue := '';
 fAddNumberIdentifier := #0;

 Tag := 101;
end;

procedure TGenericAsmSyn.SetupHighlighter;
begin
 MakeMethodTables;

 EnumerateKeywords(Ord(tkKey), fOpCodes, IdentChars, @DoAddKeyword);

 If fSystemValue <> '' Then
  Begin
   fSystemValueAttri := TSynHighlighterAttributes.Create(SYNS_AttrSystemValue);
   AddAttribute(fSystemValueAttri);

   EnumerateKeywords(Ord(tkSystemValue), fSystemValue, IdentChars, @DoAddKeyword);
  end;

 SetAttributesOnChange(@DefHighlightChange);

 fDefaultFilter := fFilterStored;
end;

destructor TGenericAsmSyn.Destroy;
begin
 fKeywords.Free;

 Inherited Destroy;
end;

function TGenericAsmSyn.GetDefaultAttribute(Index: integer): TSynHighlighterAttributes;
begin
 Case Index Of
    SYN_ATTR_COMMENT                             : Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER                          : Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD                             : Result := fKeyAttri;
    SYN_ATTR_STRING                              : Result := fStringAttri;
    SYN_ATTR_WHITESPACE                          : Result := fSpaceAttri;
    SYN_ATTR_SYMBOL                              : Result := fSymbolAttri;
    Else                                           Result := Nil;
 End;
end;

function TGenericAsmSyn.GetEol: Boolean;
begin
 Result := fTokenId = tkNull;
end;

function TGenericAsmSyn.GetTokenID: TtkTokenKind;
begin
 Result := fTokenId;
end;

procedure TGenericAsmSyn.SetLine(const NewValue: AnsiString; LineNumber: LongInt);
begin
 fLine := PChar(NewValue);
 Run := 0;
 fLineNumber := LineNumber;

 Next;
end;

function TGenericAsmSyn.GetToken: String;
 Var Len : Longint;
begin
 Len := Run - fTokenPos;

 SetString(Result, (FLine + fTokenPos), Len);
end;

function TGenericAsmSyn.GetTokenAttribute: TSynHighlighterAttributes;
begin
 Case fTokenID Of
    tkComment                            : Result := fCommentAttri;
    tkIdentifier                         : Result := fIdentifierAttri;
    tkKey: Result                        := fKeyAttri;
    tkNumber: Result                     := fNumberAttri;
    tkSpace: Result                      := fSpaceAttri;
    tkString: Result                     := fStringAttri;
    tkSymbol: Result                     := fSymbolAttri;
    tkUnknown: Result                    := fIdentifierAttri;
    tkSystemValue : Result               := fSystemValueAttri;
    Else                                    Result := Nil;
 End;
end;

function TGenericAsmSyn.GetTokenKind: integer;
begin
 Result := Ord(fTokenId);
end;

function TGenericAsmSyn.GetTokenPos: Integer;
begin
 Result := fTokenPos;
end;

procedure TGenericAsmSyn.GetTokenEx(out TokenStart: PChar; out
  TokenLength: integer);
begin
 TokenLength:=Run-fTokenPos;
 TokenStart:=FLine + fTokenPos;
end;

procedure TGenericAsmSyn.Next;
begin
 fTokenPos := Run;
 fProcTable[fLine[Run]];
end;

end.

