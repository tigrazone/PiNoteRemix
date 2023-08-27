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
unit MySEHighlighterErlang;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SynFacilHighlighter, SynEditHighlighter;

Type

    { TMySEHighlighterErlang }

    TMySEHighlighterErlang                = Class(TSynFacilSyn)
      Private
        fKeyWordList                      : TStringList;
        tnFunctions                       : Integer;
        tnPragma                          : Integer;

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
     SYNS_FilterErlang        = 'Erlang files (*.erl;*.hrl)|*.erl;*.hrl';
     SYNS_LangErlang          = 'Erlang';

     ErlangKeyWords           = 'after,begin,case,catch,cond,end,fun,if,let,of,' +
                                'query,receive,all_true,some_true,div,rem,or,xor,' +
                                'bor,bxor,bsl,bsr,and,band,not,bnot';

     ErlangFunctions          = 'abs,accept,alarm,apply,atom_to_list,binary_to_list,' +
                                'binary_to_term,check_process_code,concat_binary,' +
                                'date,delete_module,disconnect_node,element,erase,' +
                                'exit,float,float_to_list,garbage_collect,get,' +
                                'get_keys,group_leader,halt,hd,integer_to_list,' +
                                'is_alive,is_atom,is_binary,is_boolean,is_float' +
                                'is_function,is_integer,is_list,is_number,is_pid,' +
                                'is_port,is_process_alive,is_record,is_reference,' +
                                'is_tuple,length,link,list_to_atom,list_to_binary,' +
                                'list_to_float,list_to_integer,list_to_pid,list_to_tuple,' +
                                'load_module,loaded,localtime,make_ref,module_loaded,' +
                                'node,nodes,now,open_port,pid_to_list,port_close,' +
                                'port_command,port_connect,port_control,ports,' +
                                'pre_loaded,process_flag,process_info,processes,' +
                                'purge_module,put,register,registered,round,self,' +
                                'setelement,size,spawn,spawn_link,spawn_opt,' +
                                'split_binary,statistics,term_to_binary,throw,' +
                                'time,tl,trunc,tuple_to_list,unlink,unregister,whereis';


{ TMySEHighlighterErlang }

function TMySEHighlighterErlang.IsFilterStored: Boolean;
begin
 Result := fDefaultFilter <> SYNS_FilterErlang;
end;

function TMySEHighlighterErlang.GetSampleSource: string;
begin
 Result := '% Simple not working code' + #13#10 +
           '-module (patterns).' + #13#10 +
           '-compile([export_all]).' + #13#10 +
           '' + #13#10 +
           'module_as_actor(E) when is_record(E, event) ->' + #13#10 +
           '    case lists:keysearch(mfa, 1, E#event.contents) of' + #13#10 +
           '         {value, {mfa, {M, F, _A}}} ->' + #13#10 +
           '         case lists:keysearch(pam_result, 1, E#event.contents) of' + #13#10 +
           '              {value, {pam_result, {M2, _F2, _A2}}} ->' + #13#10 +
           '                      {true, E#event{label = F, from = M2, to = M}};' + #13#10 +
           '         _ ->' + #13#10 +
           '             {true, E#event{label = F, from = M, to = M}}' + #13#10 +
           ' end;' + #13#10 +
           '_  ->' + #13#10 +
           ' false' + #13#10 +
           'end.';
end;

constructor TMySEHighlighterErlang.Create(AOwner: TComponent);
 Var I : Word;
begin
 fKeyWordList := TStringList.Create;
 fKeyWordList.Delimiter := ',';
 fKeyWordList.StrictDelimiter := True;

 fKeyWordList.DelimitedText := ErlangKeyWords;

 Inherited Create(AOwner);

 ClearMethodTables;
 ClearSpecials;

 DefTokIdentif('[A-Za-z_]', '[A-Za-z0-9_]*');

 For I := 0 To fKeyWordList.Count - 1 Do
  AddKeyword(fKeyWordList[I]);

 fKeyWordList.Clear;
 fKeyWordList.DelimitedText := ErlangFunctions;

 tnFunctions := NewTokType(SYNS_AttrFunction);
 tnPragma := NewTokType(SYNS_AttrPragma);

 For I := 0 To fKeyWordList.Count - 1 Do
  AddIdentSpec(fKeyWordList[I], tnFunctions);

 fKeyWordList.Free;

 DefTokDelim('"','"', tnString, tdMulLin);
 DefTokDelim('%','', tnComment);

 //DefTokContent('[0123456789]','[0-9]', tnNumber);
 DefTokContent('[0-9]', '[0-9]*[\.][0-9]+[eE][+-]?[0-9]+', tnNumber);
 DefTokContent('$','[0-9A-Fa-f]*', tnNumber);
 DefTokDelim('-','', tnPragma);

 fDefaultFilter := SYNS_FilterErlang;

 Rebuild;

 SetAttributesOnChange(@DefHighlightChange);
end;

destructor TMySEHighlighterErlang.Destroy;
begin
  inherited Destroy;
end;

class function TMySEHighlighterErlang.GetLanguageName: string;
begin
 Result := SYNS_LangErlang;
end;

end.

