unit fnt_EntfernungLaufzeit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, tbButton, ExtCtrls, c_Geschwindigkeit, o_Base;

type
  Tfrm_Entfernung_Lauftzeit = class(TForm)
    edt_Scout: TMaskEdit;
    Label1: TLabel;
    Label2: TLabel;
    edt_Ranger: TMaskEdit;
    Label3: TLabel;
    edt_Gunner: TMaskEdit;
    Label4: TLabel;
    edt_Knocker: TMaskEdit;
    Label5: TLabel;
    edt_Mortar: TMaskEdit;
    Label6: TLabel;
    edt_Molotov: TMaskEdit;
    Label7: TLabel;
    edt_Biker: TMaskEdit;
    Label8: TLabel;
    edt_Trike: TMaskEdit;
    Label9: TLabel;
    edt_Pickup: TMaskEdit;
    Label10: TLabel;
    edt_Carrack: TMaskEdit;
    Label11: TLabel;
    edt_Felder: TEdit;
    pnl_Bottom: TPanel;
    btn_Ok: TTBButton;
    btn_Cancel: TTBButton;
    btn_Berechnen: TTBButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure btn_BerechnenClick(Sender: TObject);
  private
    FFelder: Integer;
    FBase: TBase;
    FCancel: Boolean;
    procedure Berechnen;
  public
    property Felder: Integer read FFelder;
    property Base: TBase read FBase write FBase;
    property Cancel: Boolean read FCancel;
  end;

var
  frm_Entfernung_Lauftzeit: Tfrm_Entfernung_Lauftzeit;

implementation

{$R *.dfm}

procedure Tfrm_Entfernung_Lauftzeit.btn_OkClick(Sender: TObject);
begin
  FCancel := false;
  close;
end;

procedure Tfrm_Entfernung_Lauftzeit.FormCreate(Sender: TObject);
begin
  FFelder := -1;
  FCancel := true;
end;

procedure Tfrm_Entfernung_Lauftzeit.btn_BerechnenClick(Sender: TObject);
begin
  Berechnen;
end;

procedure Tfrm_Entfernung_Lauftzeit.btn_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_Entfernung_Lauftzeit.Berechnen;
  procedure EditToTime(aValue: string; var aHour, aMin, aSec: Integer);
  var
    s: string;
  begin
    aValue := StringReplace(aValue, ' ', '0', [rfReplaceAll]);
    s := copy(aValue, 1, 2);
    if not TryStrToInt(s, aHour) then
      aHour := 0;
    s := copy(aValue, 4, 2);
    if not TryStrToInt(s, aMin) then
      aMin := 0;
    s := copy(aValue, 7, 2);
    if not TryStrToInt(s, aSec) then
      aSec := 0;
  end;
  function GetMilli(aHour, aMin, aSec: Integer): Integer;
  begin
    aMin := aMin + aHour * 60;
    aSec := aSec + aMin * 60;
    Result := aSec * 1000;
  end;

var
  Hour, Min, Sec: Integer;
  Milli: Integer;
  Geschw: Integer;
  Test: string;
begin

  Test := StringReplace(edt_Scout.Text, ' ', '0', [rfReplaceAll]);
  if Test <> '00:00:00' then
  begin
    EditToTime(edt_Scout.Text, Hour, Min, Sec);
    Milli := GetMilli(Hour, Min, Sec);
    if Milli = 0 then
      exit;
    FFelder := Trunc(Milli / Base.Scout.LaufFaktor);
    edt_Felder.Text := intToStr(FFelder);
  end;

  Test := StringReplace(edt_Ranger.Text, ' ', '0', [rfReplaceAll]);
  if Test <> '00:00:00' then
  begin
    EditToTime(edt_Ranger.Text, Hour, Min, Sec);
    Milli := GetMilli(Hour, Min, Sec);
    if Milli = 0 then
      exit;
    FFelder := Trunc(Milli / Base.Ranger.LaufFaktor);
    edt_Felder.Text := intToStr(FFelder);
  end;

  Test := StringReplace(edt_Gunner.Text, ' ', '0', [rfReplaceAll]);
  if Test <> '00:00:00' then
  begin
    EditToTime(edt_Gunner.Text, Hour, Min, Sec);
    Milli := GetMilli(Hour, Min, Sec);
    if Milli = 0 then
      exit;
    FFelder := Trunc(Milli / Base.Gunner.LaufFaktor);
    edt_Felder.Text := intToStr(FFelder);
  end;

  Test := StringReplace(edt_Knocker.Text, ' ', '0', [rfReplaceAll]);
  if Test <> '00:00:00' then
  begin
    EditToTime(edt_Knocker.Text, Hour, Min, Sec);
    Milli := GetMilli(Hour, Min, Sec);
    if Milli = 0 then
      exit;
    FFelder := Trunc(Milli / Base.Knocker.LaufFaktor);
    edt_Felder.Text := intToStr(FFelder);
  end;

  Test := StringReplace(edt_Mortar.Text, ' ', '0', [rfReplaceAll]);
  if Test <> '00:00:00' then
  begin
    EditToTime(edt_Mortar.Text, Hour, Min, Sec);
    Milli := GetMilli(Hour, Min, Sec);
    if Milli = 0 then
      exit;
    FFelder := Trunc(Milli / Base.Mortar.LaufFaktor);
    edt_Felder.Text := intToStr(FFelder);
  end;

  Test := StringReplace(edt_Molotov.Text, ' ', '0', [rfReplaceAll]);
  if Test <> '00:00:00' then
  begin
    EditToTime(edt_Molotov.Text, Hour, Min, Sec);
    Milli := GetMilli(Hour, Min, Sec);
    if Milli = 0 then
      exit;
    FFelder := Trunc(Milli / Base.Molotov.LaufFaktor);
    edt_Felder.Text := intToStr(FFelder);
  end;

  Test := StringReplace(edt_Biker.Text, ' ', '0', [rfReplaceAll]);
  if Test <> '00:00:00' then
  begin
    EditToTime(edt_Biker.Text, Hour, Min, Sec);
    Milli := GetMilli(Hour, Min, Sec);
    if Milli = 0 then
      exit;
    FFelder := Trunc(Milli / Base.Biker.LaufFaktor);
    edt_Felder.Text := intToStr(FFelder);
  end;

  Test := StringReplace(edt_Trike.Text, ' ', '0', [rfReplaceAll]);
  if Test <> '00:00:00' then
  begin
    EditToTime(edt_Trike.Text, Hour, Min, Sec);
    Milli := GetMilli(Hour, Min, Sec);
    if Milli = 0 then
      exit;
    FFelder := Trunc(Milli / Base.Trike.LaufFaktor);
    edt_Felder.Text := intToStr(FFelder);
  end;

  Test := StringReplace(edt_Pickup.Text, ' ', '0', [rfReplaceAll]);
  if Test <> '00:00:00' then
  begin
    EditToTime(edt_Pickup.Text, Hour, Min, Sec);
    Milli := GetMilli(Hour, Min, Sec);
    if Milli = 0 then
      exit;
    FFelder := Trunc(Milli / Base.Pickup.LaufFaktor);
    edt_Felder.Text := intToStr(FFelder);
  end;

  Test := StringReplace(edt_Carrack.Text, ' ', '0', [rfReplaceAll]);
  if Test <> '00:00:00' then
  begin
    EditToTime(edt_Carrack.Text, Hour, Min, Sec);
    Milli := GetMilli(Hour, Min, Sec);
    if Milli = 0 then
      exit;
    FFelder := Trunc(Milli / Base.Carrack.LaufFaktor);
    edt_Felder.Text := intToStr(FFelder);
  end;

end;

end.
