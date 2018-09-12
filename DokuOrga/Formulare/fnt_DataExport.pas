unit fnt_DataExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fnt_DialogBase, tbButton, ExtCtrls, of_DataExport, StdCtrls,
  tbEditFile, c_Types, Vcl.ComCtrls;

type
  Tfrm_DataExport = class(Tfrm_DialogBase)
    edt_ExportDir: TTBEditFile;
    Label1: TLabel;
    Label2: TLabel;
    edt_Datum: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FDataExport: Tof_DataExport;
  public
    property DataExport: Tof_DataExport read FDataExport write FDataExport;
  end;

var
  frm_DataExport: Tfrm_DataExport;

implementation

{$R *.dfm}


procedure Tfrm_DataExport.FormCreate(Sender: TObject);
begin
  inherited;
  FDataExport := Tof_DataExport.Create(Self, cNormal);
end;

procedure Tfrm_DataExport.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FDataExport);
  inherited;
end;


end.
