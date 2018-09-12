unit o_BaumButton_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_BaumButton;


type
  TBaumButtonBaseStrukList = class(TDBObjList)
  private
    function GetBaumButton(Index: Integer): TBaumButton;
  protected
    FCount: Integer;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    function getGeneratorName: string; override;
    function getNotifyIndex: Integer; override;
    function Add(aQuery: TIBQuery): TDBObj; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    property Item[Index: Integer]: TBaumButton read GetBaumButton;
  end;


implementation

{ TBaumButtonBaseStrukList }


constructor TBaumButtonBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TBaumButtonBaseStrukList.Destroy;
begin

  inherited;
end;

function TBaumButtonBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  BaumButton: TBaumButton;
begin
  BaumButton := TBaumButton.Create(nil);
  BaumButton.LoadByQuery(aQuery);
  Result := TDBObj(BaumButton);
end;


function TBaumButtonBaseStrukList.GetBaumButton(Index: Integer): TBaumButton;
begin
  Result := TBaumButton(getItem(Index));
end;

function TBaumButtonBaseStrukList.getGeneratorName: string;
begin
  Result := 'BB_ID';
end;

function TBaumButtonBaseStrukList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TBaumButtonBaseStrukList.getTableName: string;
begin
  Result := 'BaumButton';
end;

function TBaumButtonBaseStrukList.getTablePrefix: string;
begin
  Result := 'BB';
end;

procedure TBaumButtonBaseStrukList.Init;
begin
  inherited;

end;

end.
