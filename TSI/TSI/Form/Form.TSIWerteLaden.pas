unit Form.TSIWerteLaden;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DBObj.AktieList, DBOBj.Aktie,
  DBObj.TSI, DBObj.TSIList, Vcl.ExtCtrls, DBObj.KursList, DBObj.TSILast;

type
  Tfrm_TSIWerteLaden = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    lbl_Aktie: TLabel;
    lbl_Datum: TLabel;
    Timer1: TTimer;
    Label3: TLabel;
    lbl_Wochen: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    fAktieList: TAktieList;
    fTSI: TTSI;
    fKursList: TKursList;
    fStartDatum: TDateTime;
    fWochen: Integer;
    fTSILast: TTSILast;
  public
    property AktieList: TAktieList read fAktieList write fAktieList;
    property Wochen: Integer read fWochen write fWochen;
    property StartDatum: TDateTime read fStartDatum write fStartDatum;
    procedure Start(aWochen: Integer; aDatum: TDateTime);
  end;

var
  frm_TSIWerteLaden: Tfrm_TSIWerteLaden;

implementation

{$R *.dfm}

uses
  DateUtils;

procedure Tfrm_TSIWerteLaden.FormCreate(Sender: TObject);
begin //
  fTSI := TTSI.Create(nil);
  fKursList := TKursList.Create(nil);
  fTSILast  := TTSILast.Create(nil);
end;

procedure Tfrm_TSIWerteLaden.FormDestroy(Sender: TObject);
begin  //
  FreeAndNil(fKursList);
  FreeAndNil(fTSI);
  FreeAndNil(fTSILAST);
end;

procedure Tfrm_TSIWerteLaden.Start(aWochen: Integer; aDatum: TDateTime);
var
  i1, i2: Integer;
  Datum: TDateTime;
  sDatum: TDateTime;
  Wert: real;
  Cur: TCursor;
begin
  lbl_Wochen.Caption := IntToStr(aWochen);
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    fKursList.Trans := fAktieList.Trans;
    fTSILast.Trans  := fAktieList.Trans;
    fTSI.Trans := fAktieList.Trans;
    for i1 := 0 to fAktieList.count -1 do
    begin
      sDatum := aDatum;
      fTSI.ReadLastValue(fAktieList.Item[i1].ID, aWochen);
      if fTSI.Gefunden then
        sDatum := fTSI.Datum;
      lbl_Aktie.Caption := fAktieList.Item[i1].Aktie;
      fKursList.ReadAll(fAktieList.Item[i1].Id, sDatum, now);
      for i2 := 0 to fKursList.Count -1 do
      begin
        Datum := fKursList.Item[i2].Datum;
        lbl_Datum.Caption := FormatDateTime('dd.mm.yyyy', Datum);
        Application.ProcessMessages;
        fTSI.ReadWert(fAktieList.Item[i1].Id, aWochen, Datum);
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

procedure Tfrm_TSIWerteLaden.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  //Start(fWochen, fStartDatum);
  Start(27, fStartDatum);
  Start(12, fStartDatum);
  close;
  //ShowMessage('Fertig');
end;

end.
