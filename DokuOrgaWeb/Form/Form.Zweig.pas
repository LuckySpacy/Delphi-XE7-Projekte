unit Form.Zweig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ImgList, VirtualTrees;

type
  Tfrm_Zweig = class(TForm)
    vt: TVirtualStringTree;
    ImageList1: TImageList;
    pop: TPopupMenu;
    pop_EinfuegenUEbene: TMenuItem;
    pop_EinfuegenEbene: TMenuItem;
    N1: TMenuItem;
    pop_Bearb: TMenuItem;
    N2: TMenuItem;
    pop_DeleteItem: TMenuItem;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frm_Zweig: Tfrm_Zweig;

implementation

{$R *.dfm}

end.
