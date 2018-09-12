unit o_DokumentGridIcon;

interface

uses
  SysUtils, Classes, Graphics, Contnrs, o_sysObj;


type
  TDokumentGridIcon = class
  private
    fIcon: TIcon;
    fFP: Boolean;
    fCloud: Boolean;
    fFTP: Boolean;
    fLink: Boolean;
  protected
  public
    destructor Destroy; override;
    constructor Create;
    property Icon: TIcon read fIcon write fIcon;
    property FP: Boolean read fFP write fFP;
    property Cloud: Boolean read fCloud write fCloud;
    property FTP: Boolean read fFTP write fFTP;
    property Link: Boolean read fLink write fLink;
  end;


implementation

{ TDokumentGridIcon }

constructor TDokumentGridIcon.Create;
begin
  fIcon := TIcon.Create;
end;

destructor TDokumentGridIcon.Destroy;
begin
  if fIcon <> nil then
    FreeAndNil(fIcon);
  inherited;
end;

end.
