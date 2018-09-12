unit o_btnOrdner;

interface

uses
  SysUtils, Classes, tbbutton, tbPropLabel, u_dm, Windows, o_sysObj,
  obBusinessClasses, obServerClient;


type
  TbtnOrdner = class(TTBButton)
  private
    procedure RClick(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

{ TbtnOrdner }

constructor TbtnOrdner.Create(AOwner: TComponent);
begin
  inherited;
  BtnImage.AlignRight := true;
  BtnImage.Height := 32;
  BtnImage.Width  := 32;
  BtnImage.Margin := 5;
  BtnLabel.Font.Name := 'Verdana';
  BtnLabel.HTextAlign := tbHTextLeft;
  BtnLabel.HMargin := 10;
  Height := 49;
  Width  := 140;
  OnRClick := RClick;
end;

destructor TbtnOrdner.Destroy;
begin

  inherited;
end;

procedure TbtnOrdner.RClick(Sender: TObject);
var
  P: TPoint;
begin
  GetCursorPos(P);
  dm.Pop_Btn.Popup(p.X, p.Y);
  sysobj.ObServer.Notify(ntObChangeItems, NTA_CHANGEBUTTONID, Tag);
end;


end.
