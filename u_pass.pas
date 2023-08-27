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
unit U_Pass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, StdCtrls;

type

  { TPass }

  TPass = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbShowPass: TCheckBox;
    PassEdit: TLabeledEdit;
    procedure cbShowPassChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Pass: TPass;

implementation

{ TPass }

procedure TPass.cbShowPassChange(Sender: TObject);
begin
 If cbShowPass.Checked Then
  PassEdit.PasswordChar := #0
 Else
  PassEdit.PasswordChar := '*';
end;

initialization
  {$I u_pass.lrs}

end.

