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
unit uMyCRC;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Crc;

Function CrcString(Const OrigString : String) : LongWord;
Function CrcFile(Const FileName : String) : LongWord;

implementation

function CrcString(const OrigString: String): LongWord;
 Var CrcValue : LongWord;
begin
 CrcValue := Crc32(0, Nil, 0);

 Result := Crc32(CrcValue, @OrigString[1], Length(OrigString));
end;

function CrcFile(const FileName: String): LongWord;
 Var CrcValue : LongWord;
     fIn : File;
     NumRead : Word;
     Buf : Array[1..2048] Of Byte;
begin
 CrcValue := Crc32(0, Nil, 0);

 Try
   AssignFile(fIn, FileName);

   Reset(fIn, 1);

   Repeat
     BlockRead(fIn, Buf, SizeOf(Buf), NumRead);

     CrcValue := Crc32(CrcValue, @Buf[1], NumRead);
   until NumRead = 0;

   CloseFile(fIn);
 finally
   Result := CrcValue;
 end;
end;

end.

