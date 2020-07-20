unit c.Historie;

interface

type

{$REGION 'Historietabelle'}
THistorieTabelleID = Record const
  Benutzer: Integer = 1;
End;
{$ENDREGION}

{$REGION 'HistorieEvent'}
THistorieEvent = Record const
  Angelegt: Integer = 1;
  Geloescht: Integer = 2;
End;
{$ENDREGION}

implementation

end.
