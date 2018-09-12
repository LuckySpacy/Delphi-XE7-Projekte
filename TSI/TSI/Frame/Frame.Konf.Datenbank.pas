unit Frame.Konf.Datenbank;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvEdit,
  AdvEdBtn, AdvFileNameEdit;

type
  Tfra_Konf_Datenbank = class(TFrame)
    Label1: TLabel;
    Label2: TLabel;
    edt_Server: TEdit;
    edt_Datenbank: TAdvFileNameEdit;
    procedure edt_ServerExit(Sender: TObject);
    procedure edt_DatenbankExit(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ Tfra_Konf_Datenbank }

uses
  System.UITypes, Objekt.Global;


constructor Tfra_Konf_Datenbank.Create(AOwner: TComponent);
begin
  inherited;
  edt_Server.Text    := Global.DatenbankServer;
  edt_Datenbank.Text := Global.DatenbankFilename;
end;

destructor Tfra_Konf_Datenbank.Destroy;
begin

  inherited;
end;

procedure Tfra_Konf_Datenbank.edt_DatenbankExit(Sender: TObject);
begin
  if FileExists(edt_Datenbank.Text) then
    Global.DatenbankFilename := edt_Datenbank.Text;
end;

procedure Tfra_Konf_Datenbank.edt_ServerExit(Sender: TObject);
begin
  Global.DatenbankServer := edt_Server.Text;
end;

end.
