unit o_optima;

interface

uses Classes, IBDatabase, IBQuery, Dialogs, ContNrs, BaseGrid, AdvGrid,
   SysUtils, Graphics, StdCtrls, Math, i_grid;

{** Event der gefeuert wird, wenn sich an den Daten des Objekts etwas ändern *}
type
   TUpdateEvent = procedure(Sender: TComponent) of object;

   {** Basisklasse für alle OPTIMA Exceptions *}
type
   EOptima = class(Exception);

   {**
    * Basisklasse für alle Datenklassen in OPTIMA. Behinhalt das Laden und Speichern von
    * Datensätzen
    *}
type
   TOptima = class(TComponent)

   protected
      Stammdaten: pointer;
      Transaction: TIBTransaction;
      WasOpen: boolean;

      ID: longint;

      Update: boolean;
      Neu: boolean;
      Del: boolean;
      wasDeleted: boolean;
      _Found: Boolean;

      DelQueries: TStringList;          // Liste von Del-Check Queries
      DelMessages: TStringList;         // Liste von Del-Check Meldungen

      FOnUpdate: TUpdateEvent;

      procedure OpenTransaction;
      procedure RollbackTransaction;
      procedure CommitTransaction;
      function getGeneratorValue(aGenerator: string): longint; virtual;

      procedure LogFehler(aFehlerstr: string);

      // für Tabellennamen und parameter
      function getGeneratorName: string; virtual; abstract;
      function getTableName: string; virtual; abstract;
      function getTablePrefix: string; virtual; abstract;

      procedure loadFromQuery(aQuery: TIBQuery); virtual; abstract; // laden des Datensatzes aus der DB
      procedure saveToDB; virtual; abstract; // speichern des Datensatzes
      procedure Aktual; virtual;        // merken, das sich ein Wert geändert hat
      function UpdateNeeded: boolean;   // gibt zurück, ob sich bereits Werte geändert haben


      // neuen Wert im Objekt speichern
      // überladen, da für jeden Typ eine methode existiert
      function UpdateV(var Stamm: boolean; Neu: boolean): boolean; overload; virtual;
      function UpdateV(var Stamm: integer; Neu: integer): boolean; overload; virtual;
      function UpdateV(var Stamm: string; Neu: string): boolean; overload; virtual;
      function UpdateV(var Stamm: char; Neu: char): boolean; overload; virtual;
      function UpdateV(var Stamm: double; Neu: double): boolean; overload; virtual;
      function UpdateV(var Stamm: TDateTime; Neu: TDateTime): boolean; overload; virtual;
      function UpdateV(var Stamm: TOptima; Neu: TOptima): boolean; overload; virtual;
      function UpdateV(var Stamm: byte; Neu: byte): boolean; overload; virtual;
      function UpdateV(var Stamm: real; Neu: real): boolean; overload; virtual;
      function UpdateV(var Stamm: extended; Neu: extended): boolean; overload; virtual;

      function BoolToStr(aBool: boolean): string;
      function ObjectAsID(aObject: TOptima): integer;

      // Falls überschrieben, überprüft, ob Datensatz gelöscht werden darf,
      // oder ob weitere Abhängigkeiten bestehen

      function AllowDelete: boolean;

   public

      constructor Create(aOwner: TComponent; aStammdaten: pointer; aTransaction: TIBTransaction); reintroduce; overload; virtual;
      constructor Create(aOwner: TComponent; aID: longint; aStammdaten: pointer; aTransaction: TIBTransaction); reintroduce; overload; virtual;
      constructor Create(aOwner: TComponent; aQuery: TIBQuery; aStammdaten: pointer; aTransaction: TIBTransaction); reintroduce; overload; virtual;

      destructor Destroy; override;
      procedure InitObj; virtual;
      procedure InitNew; virtual;

      function delete: boolean; virtual;

      procedure ClearUpdateFlag; virtual;

      function getUpdate: boolean;
      function getNeu: boolean;
      function getID: integer;
      function getTransaction: TIBTransaction;
      function getUpdateNeeded: boolean;
      function geloescht: boolean;

      procedure setUpdate;
      procedure setNeu;
      function getStammdaten: pointer;
      procedure setStammdaten(aStammdaten: pointer); virtual;

      function getGridProvider : pointer; virtual;
      function getFieldSize(aFieldName: string): Integer;
      property Found: Boolean read _Found;
      function gibtsFormular(aTyp : integer) : boolean;

   published

      property OnUpdate: TUpdateEvent read FOnUpdate write FOnUpdate;

   end;

type
   TOptimaList = class(TComponent, IGrid)
   protected

      Stammdaten: pointer;
      Objects: TObjectList;
      // Transaction-Handling
      Transaction: TIBTransaction;
      WasOpen: boolean;

      // GetText : abstrakte Methode, die Anzuzeigenden Text zurückgibt, wenn z.B. ein Grid gefüllt wird
      function GetText(aObjekt: TOptima; aTextColumn: integer; var aStatus: integer): string; virtual;

      function GetItem(ItemIndex: integer): TOptima;
      procedure SetItem(ItemIndex: Integer; aObjekt: TOptima);

      procedure OpenTransaction;
      procedure RollbackTransaction;
      procedure CommitTransaction;

   public

      constructor Create(aOwner: TComponent; aStammdaten: pointer; aTransaction: TIBTransaction); reintroduce; overload; virtual;
      constructor Create(aOwner: TComponent; aOwns: boolean; aStammdaten: pointer; aTransaction: TIBTransaction); reintroduce; overload;
      destructor Destroy; override;

      property Items[ItemIndex: integer]: TOptima read GetItem write SetItem; default;

      function Add(aItem: TOptima): integer; virtual;

      function Count: integer;
      procedure Pack;

      procedure Delete(ItemIndex: Integer); overload; virtual;
      procedure Delete(aObjekt: TOptima); overload; virtual;
      procedure DeleteAll;

      function Extract(aItem: pointer): pointer;

      // Sortiert die Items wie in der Funktion CompareItems angegeben
      procedure Sortieren; virtual;

      // speichert ggf. die Objekte in der Liste
      procedure saveToDB; virtual;

      // StringListe zum füllen z.B. einer Combo-Box
      procedure GetEnvList(aStrings: TStrings);

      // gibt den Index eines Objektes innerhalb der Liste zurück
      function getIndex(aObjekt: TOptima): integer; overload;
      function getIndex(aID: integer): integer; overload;
      // ShowInGrid : anzeigen des Listen-Inhaltes in einem Grid
      procedure ShowInGrid(aGrid: TAdvStringGrid); virtual;

      // Alle Einträge löschen
      procedure Clear;

      procedure EintraegeLaden(aSQL: string);
      function EintragErzeugen(aQuery: TIBQuery): TOptima; virtual;

      // Funktionen des Interfaces IGrid
      function Grd_getHeader(aCol: integer): string; virtual;
      function Grd_getValue(aCol, aRow: integer): string; virtual;
      procedure Grd_getColor(aCol, aRow: integer; var aBrush: TBrush); virtual;
      procedure Grd_getFont(aCol, aRow: integer; var aFont: TFont); virtual;
      procedure Grd_getAlignment(aCol, aRow: integer; var aHAlignment: TAlignment); virtual;
      function Grd_getRowCount: integer; virtual;
      function Grd_getColCount: integer; virtual;
      procedure Grd_setValue(aCol, aRow: integer; aWert: string); virtual;
      function Grd_canEdit(aCol, aRow: integer): boolean; virtual;
      function Grd_getImage(aCol, aRow: integer): integer; virtual;
      function getObject(aIdx: integer): TObject;

   end;


   //Konstanten für ShowInGrid (Farben?!)
const
   ccDefault = $00;
   ccWarning = $01;
   ccInverse = $10;

implementation
uses o_logging, Controls, Forms, f_Optima;

{ TOptima }

{**
 * Diese Methode commited die Transaction, sofern Sie innerhalb des Objekts gestartet wurde
 * und nicht bereits offen war.
 *}
procedure TOptima.CommitTransaction;
begin
   if not WasOpen then
     Transaction.Commit;
end;

constructor TOptima.Create(aOwner: TComponent; aStammdaten: pointer;
   aTransaction: TIBTransaction);
begin
   inherited Create(aOwner);

   Stammdaten := aStammdaten;
   Transaction := aTransaction;

   ID := getGeneratorValue(getGeneratorName);
   Update := false;
   Neu := true;
   Del := false;
   _Found := true;

   InitNew;
   InitObj;

end;

constructor TOptima.Create(aOwner: TComponent; aID: Integer; aStammdaten: pointer;
   aTransaction: TIBTransaction);
var
   ReadQuery: TIBQuery;
   cursor: TCursor;
begin

   cursor := Screen.Cursor;
   Screen.Cursor := crHourglass;

   inherited Create(aOwner);

   Stammdaten := aStammdaten;
   Transaction := aTransaction;

   ReadQuery := TIBQuery.Create(self);

   with ReadQuery do
   begin

      Transaction := self.Transaction;
      OpenTransaction;

      SQL.Add('select * from ' + getTableName + ' where ' + getTablePrefix + '_ID = :ID');
      ParamByName('ID').asInteger := aID;
      Open;
      _Found := not ReadQuery.Eof;

      loadFromQuery(ReadQuery);

      Close;
      CommitTransaction;
      Free;

   end;

   Update := false;
   Neu := false;
   Del := false;

   InitObj;

   Screen.Cursor := cursor;

end;

constructor TOptima.Create(aOwner: TComponent; aQuery: TIBQuery; aStammdaten: pointer;
   aTransaction: TIBTransaction);
begin

   inherited Create(aOwner);

   Stammdaten := aStammdaten;

   if aTransaction <> nil then
      Transaction := aTransaction
   else
      Transaction := aQuery.Transaction;

   _Found := not aQuery.Eof;
   loadFromQuery(aQuery);

   Update := false;
   Neu := false;
   Del := false;

   InitObj;

end;

function TOptima.getFieldSize(aFieldName: string): Integer;
var
  TableName: string;
  Query    : TIBQuery;
  bTransaction: Boolean;
begin
  Result := -1;
  bTransaction := false;
  TableName := Uppercase(getTableName);
  Query     := TIBQuery.Create(self);
  try
    Query.Transaction := Transaction;
    if not Transaction.InTransaction then
    begin
      Transaction.StartTransaction;
      bTransaction := true;
    end;
    Query.SQL.Text := ' select t2.*' +
                      ' from rdb$relation_fields t1, rdb$fields t2' +
                      ' where t1.rdb$relation_name = "' + TableName + '"' +
                      ' and t1.rdb$field_name = "' + UpperCase(aFieldName) + '"' +
                      ' and t1.rdb$field_source = t2.rdb$field_name';
    try
      Query.Open;
      if Query.Eof then
        exit;
    except
      exit;
    end;
    Result := Query.FieldByName('rdb$field_length').AsInteger;
    if bTransaction then
      Transaction.Rollback;
  finally
    FreeAndNil(Query);
  end;
end;


function TOptima.getGeneratorValue(aGenerator: string): longint;
var
   GenQuery: TIBQuery;
begin

   GenQuery := TIBQuery.Create(self);


   with GenQuery do
   begin

      Transaction := self.Transaction;
      OpenTransaction;
      SQL.Add('select GEN_ID(' + aGenerator + ',1) from STAMMDATEN');
      try
         Open;
         result := Fields[0].asInteger;
         Close;
      except
         LogFehler('Fehler beim Lesen des Generators --> ' + aGenerator);
         result := -1;
      end;
      CommitTransaction;
      Free;

   end;

end;

function TOptima.getGridProvider: pointer;
begin
   result := nil;
end;

function TOptima.getID: integer;
begin
   result := ID;
end;

function TOptima.getNeu: boolean;
begin
   Result := Neu;
end;

function TOptima.getStammdaten: pointer;
begin
  result := Stammdaten;
end;

procedure TOptima.OpenTransaction;
begin
   WasOpen := Transaction.InTransaction;
   if not WasOpen then
     Transaction.StartTransaction;
end;

procedure TOptima.RollbackTransaction;
begin
   if not WasOpen then
     Transaction.Rollback;
end;

procedure TOptima.Aktual;
begin
   Update := true;
   if Assigned(OnUpdate) then OnUpdate(self);
end;

function TOptima.UpdateNeeded: boolean;
begin
   result := (not (Del and Neu)) and ((Del) or (Update) or (Neu));

   if result and (not Neu) and (ID <= 0) then
   begin
      ShowMsg('Datensatz soll aktualisiert werden, hat aber keine ID!');
   end;
end;

function TOptima.delete: boolean;
begin

   Result := true;
   Del := true;
   SaveToDB;

end;

function TOptima.getTransaction: TIBTransaction;
begin
   result := self.Transaction;
end;

// UpdateV : überladene funktion zum Neusetzten der Werte.
function TOptima.UpdateV(var Stamm: integer; Neu: integer): boolean;
begin
   Result := (Neu <> Stamm);
   if Neu <> Stamm then
   begin
      Stamm := Neu;
      Aktual;
   end;
end;

function TOptima.UpdateV(var Stamm: boolean; Neu: boolean): boolean;
begin
   Result := (Neu <> Stamm);
   if Neu <> Stamm then
   begin
      Stamm := Neu;
      Aktual;
   end;
end;

function TOptima.UpdateV(var Stamm: string; Neu: string): boolean;
begin
   Result := (Neu <> Stamm);
   if Neu <> Stamm then
   begin
      Stamm := Neu;
      Aktual;
   end;
end;

function TOptima.UpdateV(var Stamm: TOptima; Neu: TOptima): boolean;
var
   aID, bID: integer;
begin

   if Stamm = nil then
      aID := 0
   else
      aID := Stamm.getID;

   if Neu = nil then
      bID := 0
   else
      bID := Neu.getID;

   Result := (aID <> bID);
   if aID <> bID then
   begin
      Stamm := Neu;
      Aktual;
   end;
end;

function TOptima.UpdateV(var Stamm: double; Neu: double): boolean;
begin
   Result := not SameValue(Stamm, Neu, 0.0001);
   if not SameValue(Stamm, Neu, 0.0001) then
   begin
      Stamm := Neu;
      Aktual;
   end;
end;

function TOptima.UpdateV(var Stamm: char; Neu: char): boolean;
begin
   Result := (Neu <> Stamm);
   if Neu <> Stamm then
   begin
      Stamm := Neu;
      Aktual;
   end;
end;

function TOptima.UpdateV(var Stamm: TDateTime; Neu: TDateTime): boolean;
begin
   Result := (Neu <> Stamm);
   if Neu <> Stamm then
   begin
      Stamm := Neu;
      Aktual;
   end;
end;

function TOptima.UpdateV(var Stamm: byte; Neu: byte): boolean;
begin
   Result := (Neu <> Stamm);
   if Stamm <> Neu then
   begin
      Stamm := Neu;
      Aktual;
   end;
end;

function TOptima.getUpdate: boolean;
begin
   result := Update;
end;

function TOptima.getUpdateNeeded: boolean;
begin

   // Gibt den Status von UpdateNeeded nach außen

   result := UpdateNeeded;

end;

function TOptima.gibtsFormular(aTyp: integer): boolean;
var
  Query    : TIBQuery;
begin
  Result := false;
  Query     := TIBQuery.Create(self);
  try
    Query.Transaction := Transaction;
    OpenTransaction;
    Query.SQL.Text := ' select count(fo_id) ' +
                      ' from formulare' +
                      ' where fo_delete != "T"' +
                      ' and fo_formtype = ' + IntToStr(aTyp);
    try
      Query.Open;
      if Query.Eof then
        exit;
    except
      exit;
    end;
    Result := Query.Fields[0].AsInteger > 0;
    RollbackTransaction;
  finally
    FreeAndNil(Query);
  end;

end;

procedure TOptima.LogFehler(aFehlerstr: string);
begin
   // DUMMY
end;

{ TOptimaList }

function TOptimaList.Add(aItem: TOptima): integer;
begin

   if Objects = nil then Objects := TObjectList.Create;

   Objects.Add(aItem);
   Objects.Pack;
   Objects.Capacity := Objects.Count;

   Sortieren;

   result := Objects.Count - 1;

end;

procedure TOptimaList.Clear;
begin

   if Objects = nil then Exit;

   while Objects.Count > 0 do
      Delete(0);

   Objects.Capacity := 0;

end;

procedure TOptimaList.CommitTransaction;
begin

   if not WasOpen then Transaction.Commit;

end;

function TOptimaList.Count: integer;
begin
  Result := 0;
  if not Assigned(Objects) then
    exit;
  Result := Objects.Count;
end;

constructor TOptimaList.Create(aOwner: TComponent; aStammdaten: pointer;
   aTransaction: TIBTransaction);
begin

   inherited Create(aOwner);

   Transaction := aTransaction;
   Stammdaten := aStammdaten;

   Objects := TObjectList.Create(true);

end;

constructor TOptimaList.Create(aOwner: TComponent; aOwns: boolean;
   aStammdaten: pointer; aTransaction: TIBTransaction);
begin

   inherited Create(aOwner);

   Transaction := aTransaction;
   Stammdaten := aStammdaten;

   Objects := TObjectList.Create(aOwns);

end;

procedure TOptimaList.Delete(ItemIndex: Integer);
begin

   if ItemIndex = -1 then Exit;

   Objects.Delete(ItemIndex);
   Objects.Pack;
   Objects.Capacity := Objects.Count;

   Sortieren;

end;


procedure TOptimaList.Delete(aObjekt: TOptima);
begin
   Delete(getIndex(aObjekt));
end;

procedure TOptimaList.DeleteAll;
var
   i: integer;

begin

   for i := Objects.Count - 1 downto 0 do
   begin
      if TOptima(Objects[i]).delete then
         Objects.Delete(i);
   end;

   Objects.Capacity := Objects.Count;

end;

destructor TOptimaList.Destroy;
begin

   try
      if (Objects <> nil) then FreeAndNil(Objects);
   except
   end;

   inherited;

end;

{*----------------------------------------------------------
  Öffnet die übergebene Query und legt mit Hilfe der Funktion EintragErzeugen die Einträge an

  @Param aSQL Query, die ausgeführt werden soll
  ---------------------------------------------------------}
procedure TOptimaList.EintraegeLaden(aSQL: string);
var
   Query: TIBQuery;
   Temp: TOptima;
begin
   Query := TIBQuery.Create(self);
   with Query do
   begin
      Transaction := Self.Transaction;
      OpenTransaction;
      SQL.Add(aSQL);
      Open;
      while not Eof do
      begin
         Temp := EintragErzeugen(Query);
         if Temp <> nil then Add(Temp);
         Next;
      end;
      Close;
      CommitTransaction;
   end;
   FreeAndNil(Query);
end;

function TOptimaList.EintragErzeugen(aQuery: TIBQuery): TOptima;
begin
   result := nil;
end;

function TOptimaList.Extract(aItem: pointer): pointer;
begin

   Result := Objects.Extract(aItem);
   Objects.Pack;
   Objects.Capacity := Objects.Count;

end;

procedure TOptimaList.GetEnvList(aStrings: TStrings);
var
   x: integer;
   Status: integer;
begin
   aStrings.Clear;

   for x := 0 to Objects.Count - 1 do
      aStrings.Add(GetText(TOptima(Objects[x]), -1, Status));
end;

function TOptimaList.getIndex(aObjekt: TOptima): integer;
var
   i: integer;
begin

   Result := -1;

   if (Objects = nil) or (Objects.Count = 0) or (aObjekt = nil) then Exit;

   for i := 0 to Objects.Count - 1 do
      if aObjekt.getID = TOptima(Objects[i]).getID then
      begin

         Result := i;
         exit;

      end;

end;

function TOptimaList.getIndex(aID: integer): integer;
var
   i: integer;
begin

   Result := -1;

   if (Objects = nil) or (Objects.Count = 0) or (aID = 0) then Exit;

   for i := 0 to Objects.Count - 1 do
      if aID = TOptima(Objects[i]).getID then
      begin

         Result := i;
         exit;

      end;

end;

function TOptimaList.GetItem(ItemIndex: integer): TOptima;
begin

   if ItemIndex = -1 then
      result := nil
   else
      Result := TOptima(Objects[ItemIndex]);

end;

function TOptimaList.getObject(aIdx: integer): TObject;
begin
  result := self[aIdx];
end;

function TOptimaList.GetText(aObjekt: TOptima;
   aTextColumn: integer; var aStatus: integer): string;
begin

   Result := 'COLUMN' + IntToStr(aTextColumn);

end;

function TOptimaList.Grd_canEdit(aCol, aRow: integer): boolean;
begin
   result := false;
end;

procedure TOptimaList.Grd_getAlignment(aCol, aRow: integer;
   var aHAlignment: TAlignment);
begin
end;

function TOptimaList.Grd_getColCount: integer;
begin
   result := 1;
end;

procedure TOptimaList.Grd_getColor(aCol, aRow: integer;
   var aBrush: TBrush);
begin
end;

procedure TOptimaList.Grd_getFont(aCol, aRow: integer; var aFont: TFont);
begin
end;

function TOptimaList.Grd_getHeader(aCol: integer): string;
begin
   result := 'Überschrift';
end;

function TOptimaList.Grd_getImage(aCol, aRow: integer): integer;
begin
   result := -1;
end;

function TOptimaList.Grd_getRowCount: integer;
begin
   result := count;
end;

function TOptimaList.Grd_getValue(aCol, aRow: integer): string;
begin
   result := 'Wert';
end;

procedure TOptimaList.Grd_setValue(aCol, aRow: integer; aWert: string);
begin
end;

procedure TOptimaList.OpenTransaction;
begin

   WasOpen := Transaction.InTransaction;
   if not WasOpen then Transaction.StartTransaction;

end;

procedure TOptimaList.Pack;
begin
   if (Objects = nil) then Exit;
   Objects.Pack;
   Objects.Capacity := Objects.Count;
end;

procedure TOptimaList.RollbackTransaction;
begin

   if not WasOpen then Transaction.Rollback;

end;

procedure TOptimaList.saveToDB;
var
   i: integer;
begin

   if (Objects = nil) then Exit;

   for i := 0 to Objects.Count - 1 do
      TOptima(Objects[i]).saveToDB;

end;

procedure TOptimaList.SetItem(ItemIndex: Integer; aObjekt: TOptima);
begin

   Objects[ItemIndex] := aObjekt;

end;

procedure TOptimaList.ShowInGrid(aGrid: TAdvStringGrid);
var
   x: integer;
   y: integer;
   Status: integer;
   CellText: string;
begin

   for x := 1 to aGrid.RowCount - 1 do
      aGrid.Rows[x].clear;

   if Objects.Count = 0 then
   begin
      aGrid.RowCount := 2;
      aGrid.Rows[1].Clear;
      exit;
   end;

   Status := ccDefault;

   aGrid.RowCount := Objects.Count + 1;

   for x := 0 to Objects.Count - 1 do
   begin

      for y := 0 to aGrid.ColCount - 1 do
      begin

         Status := ccDefault;
         CellText := GetText(TOptima(Objects[x]), y, Status);

         aGrid.Cells[y, x + 1] := CellText;

      end;
   end;
end;

procedure TOptimaList.Sortieren;
begin
   // MUSS VON DEN GEERBTEN KLASSEN ÜBERSCHRIEBEN WERDEN!
end;

function TOptima.UpdateV(var Stamm: real; Neu: real): boolean;
begin
   Result := not SameValue(Stamm, Neu, 0.001);
   if Result then
   begin
      Stamm := Neu;
      Aktual;
   end;
end;

function TOptima.BoolToStr(aBool: boolean): string;
begin
   if aBool then
      result := 'T'
   else
      result := 'F';
end;

procedure TOptima.ClearUpdateFlag;
var
   WriteQuery: TIBQuery;
begin

   WriteQuery := TIBQuery.Create(self);

   WriteQuery.Transaction := Transaction;

   with WriteQuery do
   begin

      SQL.Add('UPDATE ' + GetTableName + ' SET ' + getTablePrefix + '_UPDATE = "F" ' +
         ' WHERE ' + getTablePrefix + '_ID = :Id');

      ParamByName('ID').AsInteger := ID;

      try
         OpenTransaction;
         ExecSQL;
         CommitTransaction;
      except
         // Silencer
         // Wenn das Zurücksetzen des Update-Flags nicht klappt ist das nicht
         // kritisch. Einziger Effekt ist, dass der Datenastz im nächsten
         // Zyklus wieder übertragen wird.
      end;

      Free;

   end;

end;

function TOptima.geloescht: boolean;
begin
   Result := wasDeleted;
end;

{**
 * Der Aufruf dieser Methode bewirkt, dass der Datensatz eine neue ID bekommt
 * und inserted wird. --> kopieren in neue ID
 *}
procedure TOptima.setNeu;
begin
   Neu := true;
   Update := true;
   ID := getGeneratorValue(getGeneratorName);
end;

procedure TOptima.setStammdaten(aStammdaten: pointer);
begin
   Stammdaten := aStammdaten;
end;

function TOptima.ObjectAsID(aObject: TOptima): integer;
begin

   if aObject <> nil then
      Result := aObject.getID
   else
      Result := 0;

end;

destructor TOptima.Destroy;
begin
   inherited;
end;

procedure TOptima.InitObj;
begin

   // Initialisierung
   Update := false;

end;

procedure TOptima.InitNew;
begin
end;

{**
 * Setzt das Update-Flag auf true
 *}
procedure TOptima.setUpdate;
begin
   Update := true;
end;

{**
 * Diese Methode überprüft anhand der festgelegten Kriterien ob ein konkreter Datensatz
 * gelöscht werden darf
 *}
function TOptima.AllowDelete: boolean;
var
   i: integer;
   IBQ: TIBQuery;
   Verwendet: boolean;

begin


   result := false;

   if (DelQueries = nil) or (DelQueries.Count = 0) then exit;

   i := 0;
   Verwendet := false;
   IBQ := TIBQuery.Create(self);
   IBQ.Transaction := Transaction;

   OpenTransaction;

   while (i < DelQueries.Count) and (not Verwendet) do
   begin

      IBQ.SQL.Clear;
      IBQ.SQL.Add(DelQueries[i]);
      IBQ.ParamByName('Param').asInteger := ID;

      IBQ.Open;

      if IBQ.Fields[0].asInteger > 0 then
         Verwendet := true
      else
         inc(i);

   end;

   CommitTransaction;

   if Verwendet then
   begin
      ShowMsg('Der Datensatz kann nicht gelöscht werden, da dieser in ' +
         DelMessages[i] + ' Verwendung findet.', mtWarning, [mbOk], 0);
      Result := false;
   end
   else
      Result := true;

end;

function TOptima.UpdateV(var Stamm: extended; Neu: extended): boolean;
begin
   Result := (Neu <> Stamm);
   if Neu <> Stamm then
   begin
      Stamm := Neu;
      Aktual;
   end;
end;

end.

