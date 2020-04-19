unit Datenmodul.DM;

interface

uses
  System.SysUtils, System.Classes, IBX.IBDatabase, Data.DB, IBX.IBCustomDataSet,
  IBX.IBQuery, Objekt.TabellenfeldList, Objekt.Tabellenfeld;

type
  TDM = class(TDataModule)
    IBD_OptimaChangeLog: TIBDatabase;
    IBT_OptimaChangeLog: TIBTransaction;
    qry_OptimaChangeLog: TIBQuery;
    qry_Tabellenfeld: TIBQuery;
    IBT_Tabellenfeld: TIBTransaction;
    IBD_DokuOrga: TIBDatabase;
    IBT_DokuOrga: TIBTransaction;
    qry_DokuOrga: TIBQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    fOptimaChangeLog_TabellenfeldList: TTabellenfeldList;
    fDokuOrga_TabellenfeldList: TTabellenfeldList;
    function ReadAndGetFeldInfo(aFeldName: string; aTabellenfeldList: TTabellenfeldList; aIBT: TIBTransaction): TTabellenfeld;
  public
    function OptimaChangeLogTabelleInfo(aFeldName: string): TTabellenfeld;
    function DokuOrgaTabelleInfo(aFeldName: string): TTabellenfeld;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  fOptimaChangeLog_TabellenfeldList := TTabellenfeldList.Create(nil);
  qry_Tabellenfeld.Sql.Text := ' select t1.RDB$RELATION_NAME Tabelle, t2.rdb$field_name Feldname, t3.rdb$field_type Feldtyp, t3.rdb$field_length Laenge' +
                               ' from RDB$RELATIONS t1, rdb$relation_fields t2, rdb$fields t3 ' +
                               ' where t1.RDB$SYSTEM_FLAG=0' +
                               ' and   t1.RDB$RELATION_NAME =  t2.RDB$RELATION_NAME' +
                               ' and   t2.RDB$FIELD_SOURCE = t3.RDB$FIELD_NAME' +
                               ' and   t2.rdb$field_name = :SuchFeldName';
  fDokuOrga_TabellenfeldList := TTabellenfeldList.Create(nil);
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(fOptimaChangeLog_TabellenfeldList);
  FreeAndNil(fDokuOrga_TabellenfeldList);
end;

function TDM.DokuOrgaTabelleInfo(aFeldName: string): TTabellenfeld;
begin
  Result := fDokuOrga_TabellenfeldList.getItemByFeldname(Uppercase(aFeldName));
  if Result <> nil then
    exit;
  Result := ReadAndGetFeldInfo(aFeldName, fDokuOrga_TabellenfeldList, IBT_OptimaChangeLog);
end;

function TDM.OptimaChangeLogTabelleInfo(aFeldName: string): TTabellenfeld;
begin
  Result := fOptimaChangeLog_TabellenfeldList.getItemByFeldname(Uppercase(aFeldName));
  if Result <> nil then
    exit;
  Result := ReadAndGetFeldInfo(aFeldName, fOptimaChangeLog_TabellenfeldList, IBT_OptimaChangeLog);
end;

function TDM.ReadAndGetFeldInfo(aFeldName: string; aTabellenfeldList: TTabellenfeldList; aIBT: TIBTransaction): TTabellenfeld;
begin
  if IBT_Tabellenfeld.InTransaction then
    IBT_Tabellenfeld.Rollback;
  IBT_Tabellenfeld.StartTransaction;
  qry_Tabellenfeld.Close;
  qry_Tabellenfeld.Transaction := aIBT;
  qry_Tabellenfeld.ParamByName('SuchFeldName').AsString := Uppercase(aFeldName);
  qry_Tabellenfeld.Open;
  Result := aTabellenfeldList.Add;
  Result.Tabelle  := Trim(qry_Tabellenfeld.FieldByName('Tabelle').AsString);
  Result.Feldsize := qry_Tabellenfeld.FieldByName('Laenge').AsString;
  Result.Feldtyp  := qry_Tabellenfeld.FieldByName('Feldtyp').AsString;
  Result.Feldname := Trim(qry_Tabellenfeld.FieldByName('FeldName').AsString);
  aTabellenfeldList.Sort;
  IBT_Tabellenfeld.Rollback;
end;

end.
