unit fntSplitt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, ComCtrls;

type
  Tfrm_Splitt = class(TForm)
    pnl_Button: TPanel;
    cmd_Ok: TButton;
    cmd_Cancel: TButton;
    Label4: TLabel;
    edt_Aktie: TEdit;
    Label1: TLabel;
    edt_Datum: TDateTimePicker;
    Label2: TLabel;
    edt_Stueck: TSpinEdit;
    Label7: TLabel;
    edt_Wert: TEdit;
    Label3: TLabel;
    edt_Kurs: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure cmd_CancelClick(Sender: TObject);
    procedure cmd_OkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt_StueckChange(Sender: TObject);
    procedure edt_StueckKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FCancel: Boolean;
    FWert  : Currency;
    function GetKurswert: String;
  public
    property Cancel: Boolean read FCancel;
  end;

var
  frm_Splitt: Tfrm_Splitt;

implementation

{$R *.dfm}



procedure Tfrm_Splitt.FormCreate(Sender: TObject);
begin
  FCancel     := true;
  edt_Datum.DateTime := trunc(now);
end;

procedure Tfrm_Splitt.FormShow(Sender: TObject);
begin //
  FWert := StrToCurr(edt_Wert.Text);
  edt_Kurs.Text := CurrToStr(FWert / edt_Stueck.Value);
end;


procedure Tfrm_Splitt.cmd_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_Splitt.cmd_OkClick(Sender: TObject);
begin
  FCancel := false;
  close;
end;



procedure Tfrm_Splitt.edt_StueckChange(Sender: TObject);
begin
  edt_Kurs.Text := GetKurswert;
end;

procedure Tfrm_Splitt.edt_StueckKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edt_Kurs.Text := GetKurswert;
end;


function Tfrm_Splitt.GetKurswert: String;
var
  Stueck: Integer;
begin
  if not TryStrToInt(edt_Stueck.Text, Stueck) then
  begin
    Result := '0';
    exit;
  end;
  Result := CurrToStr(FWert / Stueck);
end;

end.
