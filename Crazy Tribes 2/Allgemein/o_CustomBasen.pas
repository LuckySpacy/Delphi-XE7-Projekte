unit o_CustomBasen;

interface

uses
  SysUtils, Classes, o_BaseList;

type
  TCustomBasen = class(TObject)
  private
  protected
    FBaseList: TBaseList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;


implementation

{ TCustomBasen }

constructor TCustomBasen.Create;
begin
  inherited;
  FBaseList := TBaseList.Create;
end;

destructor TCustomBasen.Destroy;
begin
  FreeAndNil(FBaseList);
  inherited;
end;

end.
