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
unit uSymbForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons;

type

  { TSymbForm }

  TSymbForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BtnPanel: TPanel;
    FontList: TComboBox;
    Label1: TLabel;
    SelSym: TLabeledEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton100: TSpeedButton;
    SpeedButton101: TSpeedButton;
    SpeedButton102: TSpeedButton;
    SpeedButton103: TSpeedButton;
    SpeedButton104: TSpeedButton;
    SpeedButton105: TSpeedButton;
    SpeedButton106: TSpeedButton;
    SpeedButton107: TSpeedButton;
    SpeedButton108: TSpeedButton;
    SpeedButton109: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton110: TSpeedButton;
    SpeedButton111: TSpeedButton;
    SpeedButton112: TSpeedButton;
    SpeedButton113: TSpeedButton;
    SpeedButton114: TSpeedButton;
    SpeedButton115: TSpeedButton;
    SpeedButton116: TSpeedButton;
    SpeedButton117: TSpeedButton;
    SpeedButton118: TSpeedButton;
    SpeedButton119: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton120: TSpeedButton;
    SpeedButton121: TSpeedButton;
    SpeedButton122: TSpeedButton;
    SpeedButton123: TSpeedButton;
    SpeedButton124: TSpeedButton;
    SpeedButton125: TSpeedButton;
    SpeedButton126: TSpeedButton;
    SpeedButton127: TSpeedButton;
    SpeedButton128: TSpeedButton;
    SpeedButton129: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton130: TSpeedButton;
    SpeedButton131: TSpeedButton;
    SpeedButton132: TSpeedButton;
    SpeedButton133: TSpeedButton;
    SpeedButton134: TSpeedButton;
    SpeedButton135: TSpeedButton;
    SpeedButton136: TSpeedButton;
    SpeedButton137: TSpeedButton;
    SpeedButton138: TSpeedButton;
    SpeedButton139: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton140: TSpeedButton;
    SpeedButton141: TSpeedButton;
    SpeedButton142: TSpeedButton;
    SpeedButton143: TSpeedButton;
    SpeedButton144: TSpeedButton;
    SpeedButton145: TSpeedButton;
    SpeedButton146: TSpeedButton;
    SpeedButton147: TSpeedButton;
    SpeedButton148: TSpeedButton;
    SpeedButton149: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton150: TSpeedButton;
    SpeedButton151: TSpeedButton;
    SpeedButton152: TSpeedButton;
    SpeedButton153: TSpeedButton;
    SpeedButton154: TSpeedButton;
    SpeedButton155: TSpeedButton;
    SpeedButton156: TSpeedButton;
    SpeedButton157: TSpeedButton;
    SpeedButton158: TSpeedButton;
    SpeedButton159: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton160: TSpeedButton;
    SpeedButton161: TSpeedButton;
    SpeedButton162: TSpeedButton;
    SpeedButton163: TSpeedButton;
    SpeedButton164: TSpeedButton;
    SpeedButton165: TSpeedButton;
    SpeedButton166: TSpeedButton;
    SpeedButton167: TSpeedButton;
    SpeedButton168: TSpeedButton;
    SpeedButton169: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton170: TSpeedButton;
    SpeedButton171: TSpeedButton;
    SpeedButton172: TSpeedButton;
    SpeedButton173: TSpeedButton;
    SpeedButton174: TSpeedButton;
    SpeedButton175: TSpeedButton;
    SpeedButton176: TSpeedButton;
    SpeedButton177: TSpeedButton;
    SpeedButton178: TSpeedButton;
    SpeedButton179: TSpeedButton;
    SpeedButton18: TSpeedButton;
    SpeedButton180: TSpeedButton;
    SpeedButton181: TSpeedButton;
    SpeedButton182: TSpeedButton;
    SpeedButton183: TSpeedButton;
    SpeedButton184: TSpeedButton;
    SpeedButton185: TSpeedButton;
    SpeedButton186: TSpeedButton;
    SpeedButton187: TSpeedButton;
    SpeedButton188: TSpeedButton;
    SpeedButton189: TSpeedButton;
    SpeedButton19: TSpeedButton;
    SpeedButton190: TSpeedButton;
    SpeedButton191: TSpeedButton;
    SpeedButton192: TSpeedButton;
    SpeedButton193: TSpeedButton;
    SpeedButton194: TSpeedButton;
    SpeedButton195: TSpeedButton;
    SpeedButton196: TSpeedButton;
    SpeedButton197: TSpeedButton;
    SpeedButton198: TSpeedButton;
    SpeedButton199: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton200: TSpeedButton;
    SpeedButton201: TSpeedButton;
    SpeedButton202: TSpeedButton;
    SpeedButton203: TSpeedButton;
    SpeedButton204: TSpeedButton;
    SpeedButton205: TSpeedButton;
    SpeedButton206: TSpeedButton;
    SpeedButton207: TSpeedButton;
    SpeedButton208: TSpeedButton;
    SpeedButton209: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton210: TSpeedButton;
    SpeedButton211: TSpeedButton;
    SpeedButton212: TSpeedButton;
    SpeedButton213: TSpeedButton;
    SpeedButton214: TSpeedButton;
    SpeedButton215: TSpeedButton;
    SpeedButton216: TSpeedButton;
    SpeedButton217: TSpeedButton;
    SpeedButton218: TSpeedButton;
    SpeedButton219: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton220: TSpeedButton;
    SpeedButton221: TSpeedButton;
    SpeedButton222: TSpeedButton;
    SpeedButton223: TSpeedButton;
    SpeedButton224: TSpeedButton;
    SpeedButton225: TSpeedButton;
    SpeedButton226: TSpeedButton;
    SpeedButton227: TSpeedButton;
    SpeedButton228: TSpeedButton;
    SpeedButton229: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton230: TSpeedButton;
    SpeedButton231: TSpeedButton;
    SpeedButton232: TSpeedButton;
    SpeedButton233: TSpeedButton;
    SpeedButton234: TSpeedButton;
    SpeedButton235: TSpeedButton;
    SpeedButton236: TSpeedButton;
    SpeedButton237: TSpeedButton;
    SpeedButton238: TSpeedButton;
    SpeedButton239: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton240: TSpeedButton;
    SpeedButton241: TSpeedButton;
    SpeedButton242: TSpeedButton;
    SpeedButton243: TSpeedButton;
    SpeedButton244: TSpeedButton;
    SpeedButton245: TSpeedButton;
    SpeedButton246: TSpeedButton;
    SpeedButton247: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    SpeedButton27: TSpeedButton;
    SpeedButton28: TSpeedButton;
    SpeedButton29: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton30: TSpeedButton;
    SpeedButton31: TSpeedButton;
    SpeedButton32: TSpeedButton;
    SpeedButton33: TSpeedButton;
    SpeedButton34: TSpeedButton;
    SpeedButton35: TSpeedButton;
    SpeedButton36: TSpeedButton;
    SpeedButton37: TSpeedButton;
    SpeedButton38: TSpeedButton;
    SpeedButton39: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton40: TSpeedButton;
    SpeedButton41: TSpeedButton;
    SpeedButton42: TSpeedButton;
    SpeedButton43: TSpeedButton;
    SpeedButton44: TSpeedButton;
    SpeedButton45: TSpeedButton;
    SpeedButton46: TSpeedButton;
    SpeedButton47: TSpeedButton;
    SpeedButton48: TSpeedButton;
    SpeedButton49: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton50: TSpeedButton;
    SpeedButton51: TSpeedButton;
    SpeedButton52: TSpeedButton;
    SpeedButton53: TSpeedButton;
    SpeedButton54: TSpeedButton;
    SpeedButton55: TSpeedButton;
    SpeedButton56: TSpeedButton;
    SpeedButton57: TSpeedButton;
    SpeedButton58: TSpeedButton;
    SpeedButton59: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton60: TSpeedButton;
    SpeedButton61: TSpeedButton;
    SpeedButton62: TSpeedButton;
    SpeedButton63: TSpeedButton;
    SpeedButton64: TSpeedButton;
    SpeedButton65: TSpeedButton;
    SpeedButton66: TSpeedButton;
    SpeedButton67: TSpeedButton;
    SpeedButton68: TSpeedButton;
    SpeedButton69: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton70: TSpeedButton;
    SpeedButton71: TSpeedButton;
    SpeedButton72: TSpeedButton;
    SpeedButton73: TSpeedButton;
    SpeedButton74: TSpeedButton;
    SpeedButton75: TSpeedButton;
    SpeedButton76: TSpeedButton;
    SpeedButton77: TSpeedButton;
    SpeedButton78: TSpeedButton;
    SpeedButton79: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton80: TSpeedButton;
    SpeedButton81: TSpeedButton;
    SpeedButton82: TSpeedButton;
    SpeedButton83: TSpeedButton;
    SpeedButton84: TSpeedButton;
    SpeedButton85: TSpeedButton;
    SpeedButton86: TSpeedButton;
    SpeedButton87: TSpeedButton;
    SpeedButton88: TSpeedButton;
    SpeedButton89: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton90: TSpeedButton;
    SpeedButton91: TSpeedButton;
    SpeedButton92: TSpeedButton;
    SpeedButton93: TSpeedButton;
    SpeedButton94: TSpeedButton;
    SpeedButton95: TSpeedButton;
    SpeedButton96: TSpeedButton;
    SpeedButton97: TSpeedButton;
    SpeedButton98: TSpeedButton;
    SpeedButton99: TSpeedButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FontListChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    Procedure SymbolClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Ret : Boolean;
  end;

var
  SymbForm: TSymbForm;

implementation

{$R *.lfm}

{ TSymbForm }

procedure TSymbForm.FormCreate(Sender: TObject);
begin
 FontList.Items := Screen.Fonts;

 Ret := False;
end;

procedure TSymbForm.FormShow(Sender: TObject);
begin
 BtnPanel.Font.Name := FontList.Text;
end;

procedure TSymbForm.SymbolClick(Sender: TObject);
begin
 SelSym.Text := SelSym.Text + TSpeedButton(Sender).Caption;
end;

procedure TSymbForm.FontListChange(Sender: TObject);
begin
 BtnPanel.Font.Name := FontList.Text;
end;

procedure TSymbForm.BitBtn1Click(Sender: TObject);
begin
 Close;
end;

procedure TSymbForm.BitBtn2Click(Sender: TObject);
begin
 Ret := True;

 Close;
end;

end.

