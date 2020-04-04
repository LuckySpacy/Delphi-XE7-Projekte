unit fntDataChange;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin, Data.DB,
  IBX.IBCustomDataSet, IBX.IBQuery, IBX.IBDatabase, Vcl.ExtCtrls, AdvEdit, Vcl.ComCtrls;

type
  Tfrm_DataChange = class(TForm)
    qry: TIBQuery;
    IBT: TIBTransaction;
    Panel1: TPanel;
    btn_Ok: TButton;
    btn_Cancel: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Panel4: TPanel;
    edt_Integer: TSpinEdit;
    edt_String: TEdit;
    edt_Float: TAdvEdit;
    edt_Date: TDateTimePicker;
    edt_Time: TDateTimePicker;
    procedure FormShow(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
  private
    FTablename: string;
    FFieldname: string;
    FKeyFieldName: string;
    FValue: string;
    FFieldLength: Integer;
    FDataType: Integer;
    FKeyValue: Integer;
    FCancel: Boolean;
    procedure setDataType(const Value: Integer);
    function SetTimeToDate(aDate, aTime: TDateTime): TDateTime;
  public
    property Tablename: string read FTablename write FTablename;
    property Fieldname: string read FFieldname write FFieldname;
    property KeyFieldname: string read FKeyFieldname write FKeyFieldname;
    property FieldLength: Integer read FFieldLength write FFieldLength;
    property DataType: Integer read FDataType write setDataType;
    property Value: string read FValue write FValue;
    property KeyValue: Integer read FKeyValue write FKeyValue;
    property Cancel: Boolean read FCancel;
  end;

var
  frm_DataChange: Tfrm_DataChange;

implementation

{$R *.dfm}

uses
  DataModul, DateUtils;



procedure Tfrm_DataChange.FormShow(Sender: TObject);
var
  Datum: TDateTime;
  Zeit: TDateTime;
begin
  FCancel := True;
  if (FDataType = 8) or (FDataType = 16) or (FDataType = 7) then
  begin
    edt_Integer.Visible := true;
    edt_Integer.Value := StrToInt(FValue);
  end;
  if (FDataType = 37) or (FDataType = 14) then
  begin
    edt_String.Visible := true;
    edt_String.Top     := edt_Integer.Top;
    edt_String.Text    := FValue;
    edt_String.MaxLength := FFieldLength;
  end;
  if (FDataType = 10) or (FDataType = 11)  or (FDataType = 27) then
  begin
    edt_Float.Visible := true;
    edt_Float.Top     := edt_Integer.Top;
    edt_Float.FloatValue := StrToFloat(FValue);
  end;

  if (FDataType = 12) or (FDataType = 13)  or (FDataType = 35) then
  begin
    edt_Date.Visible := true;
    edt_Time.Visible := true;
    edt_Date.Top := edt_Integer.Top;
    edt_Time.Top := edt_Date.Top;
    if TryStrToDateTime(FValue, Datum) then
      edt_Date.DateTime := trunc(Datum);
    if TryStrToDateTime(FValue, Zeit) then
      edt_Time.DateTime := Zeit;
  end;
end;

procedure Tfrm_DataChange.setDataType(const Value: Integer);
begin
  FDataType := Value;
end;


procedure Tfrm_DataChange.btn_CancelClick(Sender: TObject);
begin
  close;
end;


procedure Tfrm_DataChange.btn_OkClick(Sender: TObject);
var
  s: string;
  Datum: TDateTime;
begin
  s := ' update ' + FTablename + ' set ' + FFieldname + ' = :NewValue' +
       ' where ' + FKeyFieldName + ' = ' + IntToStr(FKeyValue);

  qry.SQL.Text := s;
  if (FDataType = 8) or (FDataType = 16) or (FDataType = 7) then
    qry.ParamByName('NewValue').AsInteger := edt_Integer.Value;
  if (FDataType = 37) or (FDataType = 14) then
    qry.ParamByName('NewValue').AsString := edt_String.Text;
  if (FDataType = 10) or (FDataType = 11)  or (FDataType = 27) then
    qry.ParamByName('NewValue').AsFloat := edt_Float.FloatValue;

  if (FDataType = 12) or (FDataType = 13)  or (FDataType = 35) then
  begin
    Datum := trunc(edt_Date.DateTime);
    Datum := SetTimeToDate(Datum, edt_Time.DateTime);
    qry.ParamByName('NewValue').AsDateTime := Datum;
  end;


  //ShowMessage(qry.SQL.Text);
  if IBT.InTransaction then
    IBT.Commit;
  IBT.StartTransaction;
  qry.ExecSQL;
  IBT.Commit;

  FCancel := false;
  close;

end;


function Tfrm_DataChange.SetTimeToDate(aDate, aTime: TDateTime): TDateTime;
var
  Tag: Word;
  Monat: Word;
  Jahr: Word;
  Stunde: Word;
  Minute: Word;
  Sekunde: Word;
  Milli: Word;
begin
  DecodeDate(aDate, Jahr, Monat, Tag);
  DecodeTime(aTime, Stunde, Minute, Sekunde, Milli);
  Result := EncodeDateTime(Jahr, Monat, Tag, Stunde, Minute, Sekunde, Milli);
end;



end.
