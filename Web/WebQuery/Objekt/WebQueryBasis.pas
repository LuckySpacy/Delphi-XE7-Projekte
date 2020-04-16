unit WebQueryBasis;

interface

uses
  SysUtils, Classes, vcl.Dialogs;

type
  TDBBasis = class(TComponent)
  private
    fOnAfterExecSql: TNotifyEvent;
    fOnNewTransaction: TNotifyEvent;
    procedure FuelleHistorieDBFelder;
    procedure setTrans(const Value: TIBTransaction);
  protected
    fTrans: TIBTransaction;
    fQuery: TNFSQuery;
    fId: Integer;
    fUpdate: string;
    fDelete: string;
    fDoUpdate: Boolean;
    fFeldList: TDBFeldList;
    fFeldListHis: TDBFeldList;
    fGefunden: Boolean;
    fWasOpen: Boolean;
    //fTransCounter: Integer;
    fNeu: Boolean;
    fGeloescht: Boolean;
    function getGeneratorName: string; virtual; abstract;
    function getTableName: string; virtual; abstract;
    function getTablePrefix: string; virtual; abstract;
    procedure UpdateV(var aOldValue: string; aNewValue: string); overload;
    procedure UpdateV(var aOldValue: Integer; aNewValue: Integer); overload;
    procedure UpdateV(var aOldValue: Boolean; aNewValue: Boolean); overload;
    procedure UpdateV(var aOldValue: TDateTime; aNewValue: TDateTime); overload;
    procedure UpdateV(var aOldValue: extended; aNewValue: extended); overload;
    procedure LegeHistorieFelderAn;
    procedure FuelleDBFelder; virtual;
    property OnAfterExecSql: TNotifyEvent read fOnAfterExecSql write fOnAfterExecSql;
    property OnNewTransaction: TNotifyEvent read fOnNewTransaction write fOnNewTransaction;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; virtual;
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
    procedure LoadByQuery(aQuery: TNFSQuery); virtual;
    property Id: Integer read fId;
    property Trans: TIBTransaction read fTrans write setTrans;
    property FeldList: TDBFeldList read fFeldList write fFeldList;
    property Gefunden: Boolean read fGefunden;
    procedure Read(aId: Integer); virtual;
    function Delete: Boolean; virtual;
    procedure SaveToDB; virtual;
    function GenerateId: Integer;
  end;

end.
