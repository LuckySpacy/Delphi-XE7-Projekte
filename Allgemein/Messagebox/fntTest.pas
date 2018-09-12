unit fntTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, fntMessageDialog, RVStyle, RVScroll, RichView, RVEdit,
  tbRichviewEdit, tbToolbar;

type
  Tfrm_Test = class(TForm)
    Button1: TButton;
    RichViewEdit1: TRichViewEdit;
    RVStyle1: TRVStyle;
    Button2: TButton;
    TbToolbar1: TTbToolbar;
    tbRichviewEdit1: TtbRichviewEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure ShowMessageDialog;
    function RTFAsString: string;
  public
  end;

var
  frm_Test: Tfrm_Test;

implementation

{$R *.dfm}

{ Tfrm_Test }

procedure Tfrm_Test.Button1Click(Sender: TObject);
begin
  ShowMessageDialog;
end;

procedure Tfrm_Test.ShowMessageDialog;
var
  Form: Tfrm_MessageDialog;
begin
  Form := Tfrm_MessageDialog.Create(Self);
  try
    //Form.AsString := RTFAsString;
    Form.AsString := tbRichviewEdit1.AsRTFString;;
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;



procedure Tfrm_Test.Button2Click(Sender: TObject);
begin
  MessageDlg('Das ist ein Test', mtInformation, [mbOk], 0);
  Tfrm_MessageDialog.Msg(Self, tbRichviewEdit1.AsRTFString, mtInformation, [mbOK] );
  Tfrm_MessageDialog.Msg(Self, tbRichviewEdit1.AsRTFString, mtConfirmation, [mbYes, mbNo] );
  Tfrm_MessageDialog.Msg(Self, tbRichviewEdit1.AsRTFString, mtWarning, [mbYes, mbNo] );
  Tfrm_MessageDialog.Msg(Self, tbRichviewEdit1.AsRTFString, mtError, [mbYes, mbNo] );
//  RichViewEdit1.Format;
//  ShowMessage(IntToStr(RichViewEdit1.RVData.TextWidth) + ' / ' + IntToStr(RichViewEdit1.MaxTextWidth));
end;

procedure Tfrm_Test.FormCreate(Sender: TObject);
begin
  RichviewEdit1.Clear;
  RichviewEdit1.Add('Heute ist ein schöner Tag. Ich bin ein bisschen Müde Gruß Thomas', 0);
  RichviewEdit1.Format;
  tbRichviewEdit1.Clear;
  tbRichviewEdit1.Add('Heute ist ein schöner Tag. Ich bin ein bisschen Müde Gruß Thomas', 0);
  tbRichviewEdit1.Format;

end;

function Tfrm_Test.RTFAsString: string;
var
  Stream: TMemoryStream;
  List: TStringList;
begin
  List := TStringList.Create;
  Stream := TMemoryStream.Create;
  try
    RichViewEdit1.SaveRTFToStream(Stream, false);
    Stream.Position := 0;
    List.LoadFromStream(Stream);
    Result := List.Text;
  finally
    FreeAndNil(Stream);
    FreeAndNil(List);
  end;
end;




end.
