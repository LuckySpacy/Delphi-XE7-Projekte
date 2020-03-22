unit Objekt.TSIWerteLaden;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DBObj.AktieList, DBOBj.Aktie,
  DBObj.TSI, DBObj.TSIList, Vcl.ExtCtrls, DBObj.KursList, DBObj.TSILast,
  Vcl.ComCtrls, IBX.IBDatabase;


type
  TTSIWerteLaden = class(TComponent)
  private
    fAktieList: TAktieList;
    fTSI: TTSI;
    fKursList: TKursList;
    fStartDatum: TDateTime;
    fWochen: Integer;
    fTSILast: TTSILast;
    fProgressBar: TProgressBar;
    fProgressLabel: TLabel;
    fTrans: TIBTransaction;
    procedure Start(aWochen: Integer; aDatum: TDateTime);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Exec: Boolean;
    property ProgressLabel: TLabel read fProgressLabel write fProgressLabel;
    property ProgressBar: TProgressBar read fProgressBar write fProgressBar;
    property Trans: TIBTransaction read fTrans write fTrans;
    property StartDatum: TDateTime read fStartDatum write fStartDatum;
  end;

implementation

{ TTSIWerteLaden }

constructor TTSIWerteLaden.Create(AOwner: TComponent);
begin
  inherited;
  fTSI := TTSI.Create(nil);
  fKursList := TKursList.Create(nil);
  fTSILast  := TTSILast.Create(nil);
  fAktieList := TAktieList.Create(nil);
end;

destructor TTSIWerteLaden.Destroy;
begin
  FreeAndNil(fKursList);
  FreeAndNil(fTSI);
  FreeAndNil(fTSILAST);
  FreeAndNil(fAktieList);
  inherited;
end;

function TTSIWerteLaden.Exec: Boolean;
begin
  Result := true;
  fAktieList.Trans := fTrans;
  fAktieList.ReadAllAktien;
  Start(27, fStartDatum);
  Start(12, fStartDatum);
end;


procedure TTSIWerteLaden.Start(aWochen: Integer; aDatum: TDateTime);
var
  i1, i2: Integer;
  Datum: TDateTime;
  sDatum: TDateTime;
  Wert: real;
  Cur: TCursor;
begin
  //lbl_Wochen.Caption := IntToStr(aWochen);
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    fKursList.Trans := fAktieList.Trans;
    fTSILast.Trans  := fAktieList.Trans;
    fTSI.Trans := fAktieList.Trans;
    fProgressBar.Position := 0;
    fProgressBar.Max := fAktieList.count;
    for i1 := 0 to fAktieList.count -1 do
    begin
      sDatum := aDatum;
      fTSI.ReadLastValue(fAktieList.Item[i1].ID, aWochen);
      if fTSI.Gefunden then
        sDatum := fTSI.Datum;
      //lbl_Aktie.Caption := fAktieList.Item[i1].Aktie;
      fKursList.ReadAll(fAktieList.Item[i1].Id, sDatum, now);
      for i2 := 0 to fKursList.Count -1 do
      begin
        Datum := fKursList.Item[i2].Datum;
        //lbl_Datum.Caption := FormatDateTime('dd.mm.yyyy', Datum);
        Application.ProcessMessages;
        fTSI.ReadWert(fAktieList.Item[i1].Id, aWochen, Datum);
        fProgressLabel.Caption := 'Wochen ' + IntToStr(aWochen) + ' ' + fAktieList.Item[i1].Aktie + ' ' + FormatDateTime('dd.mm.yyyy', Datum);
        fProgressBar.Position := i1 + 1;
        fProgressLabel.Invalidate;
        fProgressLabel.Refresh;
        if not fTSI.Gefunden then
        begin
          Wert := fAktieList.Item[i1].TSI(Datum, aWochen, Datum);
          fTSi.Init;
          fTSI.AK_ID   := fAktieList.Item[i1].Id;
          fTSI.Wochen  := aWochen;
          fTSI.Datum   := Datum;
          fTSI.TSIWert := Wert;
          fTSI.SaveToDB;
        end;
      end;
    end;

    for i1 := 0 to fAktieList.count -1 do
    begin
      fTSI.ReadLastValue(fAktieList.Item[i1].ID, aWochen);
      if fTSI.Gefunden then
      begin
        fTSILast.ReadWert(fAktieList.Item[i1].ID, aWochen);
        fTSILast.AK_ID := fAktieList.Item[i1].ID;
        fTSILast.Wochen := aWochen;
        fTSILast.Datum  := fTSI.Datum;
        ftSILast.TSIWert := fTSI.TSIWert;
        fTSILast.SaveToDB;
      end;
    end;
  finally
    Screen.Cursor := Cur;
  end;

end;

end.
