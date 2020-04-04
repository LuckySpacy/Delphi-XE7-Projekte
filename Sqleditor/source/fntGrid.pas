unit fntGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, RVScroll,
  RichView, RVEdit, Vcl.AppEvnts, RVStyle, o_RichviewEditObj, DB, Vcl.ExtCtrls;

type
  TGridDblClickCell=procedure(Sender: TObject; aFieldname, aValue: string) of object;

type
  TfrmGrid = class(TForm)
    RVStyle1: TRVStyle;
    ApplicationEvents: TApplicationEvents;
    rv: TRichViewEdit;
    dbGrid: TDBGrid;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure dbGridCellClick(Column: TColumn);
    procedure dbGridKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbGridTitleClick(Column: TColumn);
    procedure dbGridDblClick(Sender: TObject);
  private
    _edField: TRichViewEditObj;
    FOnHeaderClick: TDBGridClickEvent;
    FOnDblClickCell: TGridDblClickCell;
    procedure SetGridColumnWidths( AGrid : TDBGrid );
  public
    NewData: Boolean;
    property OnHeaderClick: TDBGridClickEvent read FOnHeaderClick write FOnHeaderClick;
    property OnDblClickCell: TGridDblClickCell read FOnDblClickCell write FOnDblClickCell;
  end;

var
  frmGrid: TfrmGrid;

implementation

{$R *.dfm}

uses
  DateUtils;



procedure TfrmGrid.FormCreate(Sender: TObject);
begin
  NewData  := false;
  _edField := TRichViewEditObj.Create(rv);
  _edField.AddTextStyle('NormalerText', 'Arial', 8); // Textstyle anlegen
  _edField.AddParaStyle('NormalerText', rvaLeft); // ParaStyle anlegen
  _edField.StandardTextStyleNo := _edField.GetTextStyleId('NormalerText'); // Textstyle als Standard definieren
  _edField.StandardParaStyleNo := _edField.GetParaStyleId('NormalerText'); // Parastyle als Standard definieren
  _edField.SetStandardTextStyle;
  _edField.Edit.Clear;
end;

procedure TfrmGrid.FormDestroy(Sender: TObject);
begin
  FreeAndNil(_edField);
end;

procedure TfrmGrid.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  if NewData then
  begin
    NewData := false;
    SetGridColumnWidths(dbGrid);
  end;
end;

procedure TfrmGrid.SetGridColumnWidths( AGrid : TDBGrid );
  const
    DEFBORDER = 10;
  var
    temp, idx, bcidx : integer;
    lmax : array of integer;
    bm : TBookmark;
    StartTime: TTime;
    EndTime  : TTime;
    Cur: TCursor;
  begin
    Cur := Screen.Cursor;
    try
      Screen.Cursor := crHourGlass;
      StartTime := now;
      with AGrid do
        begin
          SetLength( lmax, Columns.Count );

          if dgTitles in AGrid.Options then
            begin

              // Measure Title

              Canvas.Font := AGrid.TitleFont;
              for idx := 0 to Columns.Count - 1 do
                if Columns[ idx ].Visible then
                  lmax[ idx ] := Canvas.TextWidth( Columns[ idx ].Title.Caption )
                    + DEFBORDER;

            end;

          // Measure Data

          Canvas.Font := AGrid.Font;

          // Anzeige abschalten
          DataSource.DataSet.DisableControls;
          try
            // Aktuellen Datensatz merken
            bm := DataSource.DataSet.GetBookmark;
            // Zum ersten Datensatz springen
            DataSource.DataSet.First;
            // Alle Datensätze durchwandern
            while not DataSource.DataSet.EOF and ( DataSource.DataSet.RecNo <= DataSource.DataSet.RecordCount ) do
              begin
                // Alle Spalten durchwandern
                for idx := 0 to Columns.Count - 1 do

                  // Ist die Spalte sichtbar?
                  if Columns[ idx ].Visible then
                    begin

                      // Breite des Inhalts ermitteln
                      temp := Canvas.TextWidth
                        ( trim( Columns[ idx ].Field.DisplayText ) ) + DEFBORDER;

                      // nur die maximale Breite merken
                      if temp > lmax[ idx ] then
                        lmax[ idx ] := temp;

                    end;

                EndTime := now - StartTime;

                if SecondOf(EndTime) > 10 then
                  break;

                // Nächster Datensatz
                DataSource.DataSet.Next;
              end;

            // Zum Datensatz zurückspringen, der eingangs gewählt war

            if DataSource.DataSet.BookmarkValid( bm ) then
              DataSource.DataSet.GotoBookmark( bm )
            else
              DataSource.DataSet.First;
            {
          finally
            // Anzeige einschalten
            DataSource.DataSet.EnableControls;
          end;
             }
          // Spaltenbreiten ändern

          for idx := 0 to Columns.Count - 1 do
          begin
            Application.ProcessMessages;
            if Columns[ idx ].Visible then
              if lmax[ idx ] > 0 then
                Columns[ idx ].Width := lmax[ idx ];
          end;
          finally
            // Anzeige einschalten
            DataSource.DataSet.EnableControls;
          end;
        end;
    finally
      Screen.Cursor := Cur;
    end;
  end; { SetGridColumnWidths }


procedure TfrmGrid.dbGridCellClick(Column: TColumn);
begin
  _edField.Clear;
  _edField.Edit.Format;
  if dbGrid.SelectedField.IsBlob then
  begin
    _edField.SetRTF(dbGrid.DataSource.DataSet.FieldByName(dbGrid.SelectedField.FieldName).AsString);
  end;
end;



procedure TfrmGrid.dbGridDblClick(Sender: TObject);
begin
  if Assigned(FOnDblClickCell) then
    FOnDblClickCell(Self, dbGrid.SelectedField.FieldName, dbGrid.DataSource.DataSet.FieldByName(dbGrid.SelectedField.FieldName).AsString);
end;

procedure TfrmGrid.dbGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _edField.Clear;
  _edField.Edit.Format;
  if dbGrid.SelectedField.IsBlob then
  begin
    _edField.SetRTF(dbGrid.DataSource.DataSet.FieldByName(dbGrid.SelectedField.FieldName).AsString);
  end;
end;

procedure TfrmGrid.dbGridTitleClick(Column: TColumn);
begin
  if Assigned(FOnHeaderClick) then
    FOnHeaderClick(Column);
//  ShowMessage(Column.Field.FieldName);
end;

end.
