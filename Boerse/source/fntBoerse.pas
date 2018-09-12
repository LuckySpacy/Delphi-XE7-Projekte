unit fntBoerse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fntLogin, ExtCtrls, StdCtrls, ActnList, frame_bestand, frame_TransferList,
  frame_guvdetail, frame_bilanz, System.Actions;

type
  Tfrm_Boerse = class(TForm)
    pnl_Button: TPanel;
    cmd_NewAktie: TButton;
    ActionList: TActionList;
    act_NeuAktie: TAction;
    act_Transfer: TAction;
    Button1: TButton;
    Button2: TButton;
    act_Bestand: TAction;
    pnl_Client: TPanel;
    act_Transferlist: TAction;
    Button3: TButton;
    act_GUVDetail: TAction;
    Button4: TButton;
    act_Bilanz: TAction;
    Button5: TButton;
    procedure FormCreate(Sender: TObject);
    procedure act_NeuAktieExecute(Sender: TObject);
    procedure act_TransferExecute(Sender: TObject);
    procedure act_BestandExecute(Sender: TObject);
    procedure act_TransferlistExecute(Sender: TObject);
    procedure act_GUVDetailExecute(Sender: TObject);
    procedure act_BilanzExecute(Sender: TObject);
  private
    FraBestand: Tfra_Bestand;
    FraTransferlist: Tfra_Transferlist;
    FraGUVDetail: Tfra_GUVDetail;
    FraBilanz: Tfra_Bilanz;
    procedure ShowAktie;
    procedure ShowTransfer;
    procedure ShowBestand;
    procedure ShowTransferlist;
    procedure ShowGUVDetail;
    procedure ShowBilanz;
    procedure SetAllFramesInVisible;
  public
  end;

var
  frm_Boerse: Tfrm_Boerse;

implementation

{$R *.dfm}

uses
  fntNeuAktie, fntTransfer;




procedure Tfrm_Boerse.FormCreate(Sender: TObject);
var
  Form: Tfrm_Login;
begin
  FraBestand      := nil;
  FraTransferlist := nil;
  FraGUVDetail    := nil;
  FraBilanz       := nil;
  //exit;
  Form := Tfrm_Login.Create(Self);
  try
    //Benutzerabfrage

    Form.ShowModal;
    if Form.Cancel then
      Application.Terminate;

  finally
    FreeAndNil(Form);
  end;
end;



procedure Tfrm_Boerse.act_BestandExecute(Sender: TObject);
begin
  ShowBestand;
end;

procedure Tfrm_Boerse.act_BilanzExecute(Sender: TObject);
begin
  ShowBilanz;
end;

procedure Tfrm_Boerse.act_GUVDetailExecute(Sender: TObject);
begin
  ShowGUVDetail;
end;

procedure Tfrm_Boerse.act_NeuAktieExecute(Sender: TObject);
begin
  ShowAktie;
end;

procedure Tfrm_Boerse.act_TransferExecute(Sender: TObject);
begin
  ShowTransfer;
end;



procedure Tfrm_Boerse.act_TransferlistExecute(Sender: TObject);
begin
  ShowTransferlist;
end;

procedure Tfrm_Boerse.SetAllFramesInVisible;
begin
  if Assigned(FraBestand) then
    FraBestand.Visible := false;

  if Assigned(FraTransferlist) then
    FraTransferlist.Visible := false;

  if Assigned(FraGUVDetail) then
    FraGUVDetail.Visible := false;

  if Assigned(FraBilanz) then
    FraBilanz.Visible := false;


end;

procedure Tfrm_Boerse.ShowAktie;
var
  Form: Tfrm_NeuAktie;
begin
  Form := Tfrm_NeuAktie.Create(Self);
  try
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;

end;

procedure Tfrm_Boerse.ShowBestand;
begin
  Screen.Cursor := crHourGlass;
  try
    SetAllFramesInVisible;
    if not Assigned(FraBestand) then
    begin
      FraBestand := TFra_Bestand.Create(Self);
      FraBestand.Parent := pnl_Client;
      FraBestand.Align  := alClient;
    end;
    FraBestand.LadeListe;
    FraBestand.Visible := true;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure Tfrm_Boerse.ShowBilanz;
begin
  Screen.Cursor := crHourGlass;
  try
    SetAllFramesInVisible;
    if not Assigned(FraBilanz) then
    begin
      FraBilanz := Tfra_Bilanz.Create(Self);
      FraBilanz.Parent := pnl_Client;
      FraBilanz.Align  := alClient;
    end;
    FraBilanz.Visible := true;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure Tfrm_Boerse.ShowGUVDetail;
begin
  Screen.Cursor := crHourGlass;
  try
    SetAllFramesInVisible;
    if not Assigned(FraGUVDetail) then
    begin
      FraGUVDetail := Tfra_GUVDetail.Create(Self);
      FraGUVDetail.Parent := pnl_Client;
      FraGUVDetail.Align  := alClient;
    end;
    FraGUVDetail.LadeListBox;
    FraGUVDetail.Visible := true;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure Tfrm_Boerse.ShowTransfer;
var
  Form: Tfrm_Transfer;
begin
    Form := Tfrm_Transfer.Create(Self);
    try
      Form.ShowModal;
    finally
      FreeAndNil(Form);
    end;

end;

procedure Tfrm_Boerse.ShowTransferlist;
begin
  Screen.Cursor := crHourGlass;
  try
    SetAllFramesInVisible;
    if not Assigned(FraTransferlist) then
    begin
      FraTransferlist := TFra_TransferList.Create(Self);
      FraTransferlist.Parent := pnl_Client;
      FraTransferlist.Align  := alClient;
    end;
    FraTransferlist.LadeListBox;
    FraTransferlist.Visible := true;
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.
