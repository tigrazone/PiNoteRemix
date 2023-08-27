unit uMultiPaste;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  uEditor;

type

  { TfMultiPaste }

  TfMultiPaste = class(TForm)
    bInsert: TButton;
    Button1: TButton;
    Button2: TButton;
    cbTrim: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    leTxtBefore: TLabeledEdit;
    leTxtAfter: TLabeledEdit;
    mPreview: TMemo;
    procedure bInsertClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure leTxtBeforeChange(Sender: TObject);
  private

  public
    TextLines : TStringList;
    ActiveEditor : TEditor;
  end;

var
  fMultiPaste: TfMultiPaste;

implementation

Uses ClipBrd;

{$R *.lfm}

{ TfMultiPaste }

procedure TfMultiPaste.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TfMultiPaste.bInsertClick(Sender: TObject);
begin
 If mPreview.Text <> '' Then
  Begin
   ActiveEditor.sEdit.BeginUpdate(True);

   ActiveEditor.sEdit.InsertTextAtCaret(mPreview.Text);

   ActiveEditor.sEdit.EndUpdate;

   Close;
  end;
end;

procedure TfMultiPaste.Button2Click(Sender: TObject);
begin
 If mPreview.Text <> '' Then
  Begin
   Clipboard.Clear;

   Clipboard.AsText := mPreview.Text;

   Close;
  end;
end;

procedure TfMultiPaste.FormCreate(Sender: TObject);
begin
 TextLines := TStringList.Create;
end;

procedure TfMultiPaste.FormDestroy(Sender: TObject);
begin
 TextLines.Free;
end;

procedure TfMultiPaste.FormShow(Sender: TObject);
begin
 leTxtBeforeChange(Sender);
end;

procedure TfMultiPaste.leTxtBeforeChange(Sender: TObject);
 Var Ind : Integer;
   sTmp : String;
begin
 mPreview.BeginUpdateBounds;
 mPreview.Lines.Clear;

 For Ind := 0 To TextLines.Count - 1 Do
  Begin
   sTmp := TextLines[Ind];

   If cbTrim.Checked Then
    sTmp := Trim(sTmp);

   mPreview.Lines.Add(leTxtBefore.Text + sTmp + leTxtAfter.Text);
  end;

 mPreview.EndUpdateBounds;
end;

end.

