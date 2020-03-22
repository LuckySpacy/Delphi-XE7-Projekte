unit MySql.Boersenindex;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, MySql.Base;

type
  TMySqlBoersenindex = class
  private
    fBI_ID: Integer;
    fBoersenname: string;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property BI_ID: Integer read fBI_ID write fBI_ID;
    property Boersenname: string read fBoersenname write fBoersenname;
    procedure Init;
  end;

implementation

{ TMySqlBoersenindex }

constructor TMySqlBoersenindex.Create;
begin
  Init;
end;

destructor TMySqlBoersenindex.Destroy;
begin

  inherited;
end;


procedure TMySqlBoersenindex.Init;
begin
  fBI_ID := 0;
  fBoersenname := '';
end;

end.
