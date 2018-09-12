unit fr_Zweig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fr_Base, VirtualTrees, of_Zweig, Menus, obBusinessClasses, obServerClient,
  StdCtrls, ImgList, c_types;

type
  Tfra_Zweig = class(Tfrm_Base, IObServerClient)
    pop: TPopupMenu;
    pop_EinfuegenUEbene: TMenuItem;
    Button1: TButton;
    vt: TVirtualStringTree;
    pop_EinfuegenEbene: TMenuItem;
    pop_DeleteItem: TMenuItem;
    pop_Bearb: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    ImageList1: TImageList;
    procedure pop_EinfuegenUEbeneClick(Sender: TObject);
    procedure FrameEnter(Sender: TObject);
    procedure pop_EinfuegenEbeneClick(Sender: TObject);
    procedure pop_DeleteItemClick(Sender: TObject);
    procedure pop_BearbClick(Sender: TObject);
  private
    Fof_Zweig: Tof_Zweig;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    property Zweig: Tof_Zweig read Fof_Zweig write Fof_Zweig;
  end;

var
  fra_Zweig: Tfra_Zweig;

implementation

{$R *.dfm}

{ Tfra_Zweig }

uses
  o_SysObj;

constructor Tfra_Zweig.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fof_Zweig := Tof_Zweig.Create(Self, AMode);
end;

destructor Tfra_Zweig.Destroy;
begin
  FreeAndNil(Fof_Zweig);
  inherited;
end;

procedure Tfra_Zweig.FrameEnter(Sender: TObject);
begin
  inherited;
  vt.SetFocus;
end;

procedure Tfra_Zweig.pop_BearbClick(Sender: TObject);
begin
  //Fof_Zweig.EditItem;
end;

procedure Tfra_Zweig.pop_DeleteItemClick(Sender: TObject);
begin
  //inherited;
  //Fof_Zweig.DeleteItem;
end;

procedure Tfra_Zweig.pop_EinfuegenEbeneClick(Sender: TObject);
begin
  //inherited;
  //Fof_Zweig.AddNewItem;
end;

procedure Tfra_Zweig.pop_EinfuegenUEbeneClick(Sender: TObject);
begin  //
 // Fof_Zweig.AddNewUItem;
end;

end.
