unit Form.Ordner;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VW.OrdnerList, Contnrs;

type
  Tfrm_Ordner = class(TForm)
    ScrollBox: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fOrdnerList: TVWOrdnerList;
    fButtonList: TObjectList;
    procedure ButtonClick(Sender: TObject);
  public
    procedure LadeEbene(aEbene: Integer);
  end;

var
  frm_Ordner: Tfrm_Ordner;

implementation

{$R *.dfm}

uses
  Objekt.BtnOrdner, VW.Ordner;


procedure Tfrm_Ordner.FormCreate(Sender: TObject);
begin
  fOrdnerList := TVWOrdnerList.Create(nil);
  fButtonList := TObjectList.Create;
end;

procedure Tfrm_Ordner.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fOrdnerList);
  FreeAndNil(fButtonList);
end;

procedure Tfrm_Ordner.LadeEbene(aEbene: Integer);
var
  i1: Integer;
  x : TbtnOrdner;
  iTop: Integer;
begin
  fButtonList.Clear;
  iTop := 15;
  fOrdnerList.Read(aEbene);
  for i1 := 0 to fOrdnerList.Count -1 do
  begin
    x := TbtnOrdner.Create(Scrollbox);
    x.Parent := Scrollbox;
    x.Left := 11;
    x.Top := iTop;
    x.BtnLabel.Caption := fOrdnerList.Item[i1].BP_Text;
    x.Tag := fOrdnerList.Item[i1].BP_Id;
    x.BtnImage.Margin := 8;

    if fOrdnerList.Item[i1].Icon.AsIcon <> nil then
      x.setIcon(fOrdnerList.Item[i1].Icon.AsIcon);

    x.OnClick := ButtonClick;

    x.Width := x.Parent.Width -20;
    x.Anchors := [akLeft, akTop, akRight];
    fButtonList.Add(x);
    iTop := iTop + x.Height + 5;
  end;
end;


procedure Tfrm_Ordner.ButtonClick(Sender: TObject);
var
  VWOrdner: TVWOrdner;
begin
  VWOrdner := fOrdnerList.getOrdnerByBP_ID(TbtnOrdner(Sender).Tag);
  if VWOrdner = nil then
    exit;
  if VWOrdner.BP_IT_Id = 1 then
    LadeEbene(VWOrdner.BP_Id);
  if VWOrdner.BP_IT_Id = 2 then
    Zweig anzeigen
end;

end.
