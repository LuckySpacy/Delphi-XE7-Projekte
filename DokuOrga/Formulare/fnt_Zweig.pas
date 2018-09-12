unit fnt_Zweig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, of_Zweig, obBusinessClasses, obServerClient, StdCtrls;

type
  Tfrm_Zweig = class(TForm)
    vt: TVirtualStringTree;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Fof_Zweig: Tof_Zweig;
  public
    property Zweig: Tof_Zweig read Fof_Zweig write Fof_Zweig;
  end;
var
  frm_Zweig: Tfrm_Zweig;

implementation

{$R *.dfm}

uses
  o_SysObj;


procedure Tfrm_Zweig.FormCreate(Sender: TObject);
begin
  //Fof_Zweig := Tof_Zweig.Create(Self);
end;

procedure Tfrm_Zweig.FormDestroy(Sender: TObject);
begin
 // FreeAndNil(Fof_Zweig);
end;

end.
