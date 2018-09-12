unit Form.Syntaxhighlighter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, IBX.IBDatabase,
  IBX.IBCustomDataSet, IBX.IBQuery, Objekt.System, Vcl.StdCtrls, Vcl.ExtCtrls,
  Frame.Stylename, Frame.Kommentar;

type
  Tfrm_Syntaxhighlighter = class(TForm)
    Panel1: TPanel;
    pnl_Stylename: TPanel;
    IBT: TIBTransaction;
    pnl_Kommentar: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fStyleName: Tfra_StyleName;
    fKommentar: Tfra_Kommentar;
  public
  end;

var
  frm_Syntaxhighlighter: Tfrm_Syntaxhighlighter;

implementation

{$R *.dfm}

procedure Tfrm_Syntaxhighlighter.FormCreate(Sender: TObject);
begin
  SysObj := TSysObj.Create(Self);
  fStyleName := Tfra_StyleName.Create(Self);
  fStyleName.Parent := pnl_Stylename;
  fStyleName.Align := alClient;

  fKommentar := Tfra_Kommentar.Create(Self);
  fKommentar.Parent := pnl_Kommentar;
  fKommentar.Align := alClient;

end;

procedure Tfrm_Syntaxhighlighter.FormDestroy(Sender: TObject);
begin
  FreeAndNil(SysObj);
  FreeAndNil(fStyleName);
  FreeAndNil(fKommentar);
end;

procedure Tfrm_Syntaxhighlighter.FormShow(Sender: TObject);
begin
  SysObj.Connect;
  IBT.DefaultDatabase := SysObj.Database;
  fStyleName.Trans := IBT;
  fStyleName.LadeStyleNames;
  fKommentar.setTrans(IBT);
  fKommentar.LadeKommentare;
end;



end.
