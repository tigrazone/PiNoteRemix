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
unit uUniqueInstanceBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SimpleIPC;

Const
     ParamsSeparator            = #13;

Var
     fIPCServer                 : TSimpleIPCServer;

Procedure InitializeUniqueServer(Const ServerID : String);
Function GetFormattedParams : String;
Function GetServerID(Const Identifier : String) : String;

implementation

Uses LazUTF8;

Const
     BaseServerID                      = 'tuniqueinstance_';

procedure InitializeUniqueServer(const ServerID: String);
begin
 If fIPCServer = Nil Then
  Begin
   fIPCServer := TSimpleIPCServer.Create(Nil);
   fIPCServer.ServerID := ServerID;
   fIPCServer.Global := True;

   fIPCServer.StartServer;
  end;
end;

function GetFormattedParams: String;
 Var I : Integer;
begin
 Result := '';

 For I := 1 To ParamCount Do
  Result := Result + ParamStrUTF8(I) + ParamsSeparator;
end;

function GetServerID(const Identifier: String): String;
begin
 If Identifier <> '' Then
  Result := BaseServerID + Identifier
 Else
  Result := BaseServerID + ExtractFileName(ParamStrUTF8(0));
end;

Finalization
 fIPCServer.Free;

end.

