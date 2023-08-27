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
unit uInfo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfInfo }

  TfInfo = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Label1: TLabel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    stRunOn: TStaticText;
    stName: TStaticText;
    stWgOn: TStaticText;
    stVersion: TStaticText;
    stBits: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  fInfo: TfInfo;

implementation

Uses uMain, InterfaceBase, LCLPlatformDef;

{$R *.lfm}

{ TfInfo }

procedure TfInfo.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TfInfo.FormCreate(Sender: TObject);
 Var SizeOfPointer : Word;
begin
 Caption := Caption + ' - build time: ' + {$I %DATE%} + ' ' + {$I %TIME%};

 SizeOfPointer := SizeOf(Pointer);

 stBits.Caption := IntToStr(SizeOfPointer * 8) + ' bit version';

 stVersion.Caption := 'Release version: ' + PiNoteVersionNumber;
 stName.Caption :=    'Release name   : ' + PiNoteVersionName;
 stWgOn.Caption := 'Widget : ' + LCLPlatformDisplayNames[WidgetSet.LCLPlatform];

 {$IFDEF WINDOWS}
 stRunOn.Caption := 'MS Windows';
 {$ENDIF}

 {$IFDEF LINUX}
 stRunOn.Caption := 'Linux';
 {$ENDIF}

 {$IFDEF DARWIN}
 stRunOn.Caption := 'Mac OS';
 {$ENDIF}

 {$IFDEF FREEBSD}
 stRunOn.Caption := 'FreeBSD';
 {$ENDIF}

 {$IFDEF NETBSD}
 stRunOn.Caption := 'NetBSD';
 {$ENDIF}

 {$IFDEF HAIKU}
 stRunOn.Caption := 'Haiku';
 {$ENDIF}
end;

end.

