unit u_RTF;

interface

uses
  SysUtils, Classes, rvReport, RvStyle, RvGetText;


function GetPlaintext(aRTFString: string): string;

implementation


function GetPlaintext(aRTFString: string): string;
var
  List: TStringList;
  m   : TMemoryStream;
  rh  : TRvReportHelper;
  rv  : TReportRichView;
  Style: TRvStyle;
begin

  rh    := TRvReportHelper.Create(nil);
  List  := TStringList.Create;
  m     := TMemoryStream.Create;
  Style := TRvStyle.Create(nil);
  try
    rh.RichView.RTFReadProperties.TextStyleMode := rvrsAddIfNeeded;
    rh.RichView.RTFReadProperties.ParaStyleMode := rvrsAddIfNeeded;
    rh.RichView.RVFOptions := rh.RichView.RVFOptions + [rvfoSaveTextStyles];
    rh.RichView.RVFOptions := rh.RichView.RVFOptions + [rvfoSaveParaStyles];
    rv       := rh.RichView;
    rv.Style := Style;

    List.Text := aRTFString;
    m.Position := 0;
    List.SaveToStream(m);
    m.Position := 0;
    rv.LoadRTFFromStream(m);

    Result := String(GetAllText(rv));

  finally
    FreeAndNil(List);
    FreeAndNil(m);
    FreeAndNil(Style);
    FreeAndNil(rh);
  end;


end;

end.
