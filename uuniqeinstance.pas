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
unit uUniqeInstance;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

Function InstanceRunning(Const Identifier : String; SendParamters : Boolean = False;
                         DoInitServer : Boolean = True) : Boolean;
Function InstanceRunning : Boolean;

implementation

Uses SimpleIPC, uUniqueInstanceBase;

function InstanceRunning(const Identifier: String; SendParamters: Boolean;
  DoInitServer: Boolean): Boolean;
 Var Client : TSimpleIPCClient;
begin
 Client := TSimpleIPCClient.Create(Nil);

 With Client Do
  Try
    ServerID := GetServerID(Identifier);

    Result := Client.ServerRunning;

    If Not Result Then
     Begin
      If DoInitServer Then
       InitializeUniqueServer(ServerID);
     end
    Else
     If SendParamters Then
      Begin
       Active := True;

       SendStringMessage(ParamCount, GetFormattedParams);
      end;
  finally
    Free;
  end;
end;

function InstanceRunning: Boolean;
begin
 Result := InstanceRunning('');
end;

end.

