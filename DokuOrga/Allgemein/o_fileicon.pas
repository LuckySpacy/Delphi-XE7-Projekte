unit o_fileicon;

interface

uses
  SysUtils, Classes, Graphics, Contnrs;

type
  TtbFileIcon = class
  private
    _Icon: TIcon;
    _Extended: string;
    _Tag: Integer;
  protected
  public
    destructor Destroy; override;
    constructor Create;
    property Extended: string read _Extended write _Extended;
    property Icon: TIcon read _Icon write _Icon;
    property Tag: Integer read _Tag write _Tag;
  end;


implementation

{ TnfFileIcon }

constructor TtbFileIcon.Create;
begin
  _Icon := TIcon.Create;
end;

destructor TtbFileIcon.Destroy;
begin
  FreeAndNil(_Icon);
  inherited;
end;

end.
