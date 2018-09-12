unit fnt_DokuOrga;



interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, o_sysobj, fnt_Splash, fr_DashToolbar, ActnList, Menus,
  obBusinessClasses, obServerClient, tbButton, ComCtrls, u_DM, ExtCtrls,
  fr_Ordner, c_Types, ImgList, fr_Zweig, StdCtrls, fnt_Zweig, RVScroll,
  RichView, RVEdit, fr_Seite, tbToolbar, System.Actions;

type
  Tfrm_DokuOrga = class(TForm, IObServerClient)
    MainMenu: TMainMenu;
    Datei1: TMenuItem;
    act: TActionList;
    act_Save: TAction;
    Speichern1: TMenuItem;
    act_New: TAction;
    Neu1: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ImageList1: TImageList;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure act_SaveExecute(Sender: TObject);
    procedure act_NewExecute(Sender: TObject);
    procedure TBButton1Click(Sender: TObject);
    procedure TBButton1RClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RegisterNotify;
    procedure UnregisterNotify;
  private
    FDashToolbar: Tfra_DashToolbar;
    FOrdner: Tfra_Ordner;
    FZweig : Tfra_Zweig;
    FSeite : Tfra_Seite;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure ShowOrdnerProp(aBearbArt: TBearbart; aObjId: Integer);
    procedure ShowZweigProp(aBearbArt: TBearbart; aObjId: Integer);
    procedure ShowBilder;
    procedure ShowLink(aBaumButtonEbene, aBaumZweigId: Integer);
    procedure ShowLinkEntf;
    procedure CreateZweig;
    procedure ShowDataExport(aImportExport: TImportExport);
    procedure ShowSystemeinstellung;
    procedure ShowHighlighterConfig;
  public
  end;

var
  frm_DokuOrga: Tfrm_DokuOrga;

implementation

{$R *.dfm}


uses
  fnt_OrdnerProp, fnt_Bilder, fnt_ZweigProp, fnt_DataExport, fnt_Systemeinstellung,
  fnt_Link, fnt_link_entf, fnt_login, fnt_SyntaxHighlighterConfig, u_system,
  c_AllgTypes;


procedure Tfrm_DokuOrga.FormCreate(Sender: TObject);
var
  Form: Tfrm_Splash;
  Form_Login: Tfrm_Login;
begin
  SysObj := TSysObj.Create(Self);
  SysObj.Akt.Modus := cNormal;
  Form := Tfrm_Splash.Create(nil);
  try
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;

  Form_Login := Tfrm_Login.Create(Self);
  try
    Form_Login.ShowModal;
    if not Form_Login.PW_OK  then
    begin
      ShowMessage('Da das eingegebene Passwort nicht korrekt ist, wird das Programm jetzt beendet');
      Application.Terminate;
    end;
  finally
    FreeAndNil(Form_Login);
  end;

  FDashToolbar := Tfra_DashToolbar.Create(Self);
  FDashToolbar.Parent := Self;
  FDashToolbar.Align  := alTop;

  FOrdner := Tfra_Ordner.Create(Self);
  FOrdner.Parent := TabSheet1;
  FOrdner.Align  := alClient;
  FOrdner.Visible := true;
  SysObj.Akt.BaumButtonEbene := 0;
  sysobj.ObServer.Notify(ntobFrames, NTA_AKTUAL);

  FSeite := Tfra_Seite.Create(Self);
  FSeite.Parent := Self;
  FSeite.Align  := alClient;

  RegisterNotify;


  CreateZweig;
  SysObj.DeleteTempPath;
  SysObj.CreateTempPath;

end;

procedure Tfrm_DokuOrga.FormDestroy(Sender: TObject);
begin
  SysObj.DeleteTempPath;
  if FZweig <> nil then
    FreeAndNil(FZweig);
  FreeAndNil(FOrdner);
  FreeAndNil(FDashToolbar);
  FreeAndNil(FSeite);
  UnregisterNotify;
  FreeAndNil(SysObj);
end;

procedure Tfrm_DokuOrga.RegisterNotify;
begin
  SysObj.ObServer.RegisterNotifications(Self, [ntobBearb, ntobFrames, ntobForms]);
end;

procedure Tfrm_DokuOrga.UnregisterNotify;
begin
  SysObj.ObServer.UnregisterNotifications(Self);
end;


procedure Tfrm_DokuOrga.FormShow(Sender: TObject);
begin
  SysObj.Akt.BaumButtonEbene := 0;
  SysObj.ObServer.Notify(ntobBearb, NTA_BAUMEBENE_CHANGED, 1);
  SysObj.SaveSyntaxHighlighterToFile;
end;

procedure Tfrm_DokuOrga.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
var
  AktBaumebene: Integer;
  AktZweigEbene: Integer;
  AktZweigId: Integer;
begin
  if SysObj.Akt.Modus <> cNormal then
    exit;
  if AType = ntobBearb then
  begin
    if (Action = NTA_LINK_ENTF) then
      ShowLinkEntf;
    if (Action = NTA_DASH_NEU) and (FOrdner.Visible) then
      ShowOrdnerProp(cNeu, -1);
    if (Action = NTA_DASH_NEU) and (FZweig.Visible) then
      ShowZweigProp(cNeu, Data);
    if Action = NTA_DASH_DATAEXPORT then
      ShowDataExport(cExport);
    if Action = NTA_DASH_DATAIMPORT then
      ShowDataExport(cImport);
    if Action = NTA_DASH_SYSTEMEINSTELLUNG then
      ShowSystemeinstellung;
    if Action = NTA_LINK_START then
    begin
      AktBaumEbene  := SysObj.Akt.BaumButtonEbene;
      AktZweigEbene := SysObj.Akt.BaumZweigEbene;
      AktZweigId    := SysObj.Akt.BaumZweigId;
      //FOrdner.Ordner.UnregisterNotify;
      //UnregisterNotify;
      SysObj.Akt.Modus := cLink;
      SysObj.Akt.BaumButtonEbene := 0;
      SysObj.Akt.BaumZweigEbene  := 0;
      SysObj.Akt.BaumZweigId     := 0;
      ShowLink(AktBaumEbene, AktZweigId);
      SysObj.Akt.BaumButtonEbene := AktBaumebene;
      SysObj.Akt.BaumZweigEbene  := AktZweigEbene;
      SysObj.Akt.BaumZweigId     := AktZweigId;
      //FOrdner.Ordner.RegisterNotify;
      //RegisterNotify;
      SysObj.Akt.Modus := cNormal;
      sysobj.ObServer.Notify(ntobBearb, NTA_DOKUMENTREFRESH);
    end;
      //SysObj.Msg.Msg(Self, '{08F47461-789F-4353-A38E-EFD95CD8ACB2}', mtInformation, [mbOk]);
    if Action = NTA_DASH_SPEICHERN then
      ShowMessage('Speichern');
    if Action = NTA_BAUM_VISIBLE then
    begin
      if Data = 0 then
      begin
        FOrdner.Visible := true;
        FZweig.Visible  := false;
      end;
      if Data = 1 then
      begin
        FOrdner.Visible := false;
        FZweig.Visible  := true;
        SysObj.Akt.BaumZweigEbene := SysObj.Akt.BaumButtonEbene;
        FZweig.Zweig.Aktual(0);
        FZweig.vt.SetFocus;
      end;
    end;
  end;
  if AType = ntobForms then
  begin
    if Action = NTA_SHOW_BILDER then
    begin
      ShowBilder;
    end;
    if Action = NTA_SHOW_ZWEIGPROP_NEU then
    begin
      ShowZweigProp(cNeu, Data);
    end;
    if Action = NTA_SHOW_ZWEIGPROP_BEARB then
    begin
      ShowZweigProp(cBearb, Data);
    end;
    if Action = NTA_SHOW_HIGHLIGHTERCONFIG then
    begin
      ShowHighlighterConfig;
    end;
  end;
  if AType = ntObFrames then
  begin
    if Action = NTA_EIGENSCHAFTENCLICK then
      ShowOrdnerProp(cBearb, Data);
  end;
end;



procedure Tfrm_DokuOrga.CreateZweig;
begin
  if FZweig <> nil then
    FreeAndNil(FZweig);
  FZweig := Tfra_Zweig.Create(Self);
  FZweig.Parent := TabSheet1;
  FZweig.Align  := alClient;
  FZweig.Name := 'fr_Zweig';
  FZweig.Visible := false;
end;


procedure Tfrm_DokuOrga.ShowOrdnerProp(aBearbArt: TBearbart; aObjId: Integer);
var
  Form: Tfrm_OrdnerProp;
begin
  Form := Tfrm_OrdnerProp.Create(Self);
  try
    Form.BearbArt := aBearbArt;
    Form.ObjectId := aObjId;
    Form.OrdnerProp.ObjectId := aObjId;
    Form.OrdnerProp.Load;
    Form.ShowModal;
    if Form.Cancel then
      exit;
    Form.OrdnerProp.Save;
    sysobj.ObServer.Notify(ntobFrames, NTA_AKTUAL);
  finally
    FreeAndNil(Form);
  end;
end;

procedure Tfrm_DokuOrga.ShowZweigProp(aBearbArt: TBearbart; aObjId: Integer);
var
  Form: Tfrm_ZweigProp;
begin
  Form := Tfrm_ZweigProp.Create(Self);
  try
    Form.ObjectId := aObjId;
    Form.ZweigProp.ObjectId := aObjId;
    Form.ZweigProp.BearbArt := aBearbArt;
    Form.ZweigProp.Load;
    Form.ShowModal;
    if Form.Cancel then
      exit;
    Form.ZweigProp.Save;
    if aBearbArt = cNeu then
      sysobj.ObServer.Notify(ntobFrames, NTA_AKTUAL, aObjId);
  finally
    FreeAndNil(Form);
  end;
end;

procedure Tfrm_DokuOrga.TBButton1Click(Sender: TObject);
begin
  ShowMessage('Click');
end;

procedure Tfrm_DokuOrga.TBButton1RClick(Sender: TObject);
var
  P: TPoint;
begin
  GetCursorPos(P);
  dm.Pop_Btn.Popup(p.X, p.Y);
end;


procedure Tfrm_DokuOrga.act_NewExecute(Sender: TObject);
begin
  sysobj.ObServer.Notify(ntobBearb, NTA_DASH_NEU);
end;

procedure Tfrm_DokuOrga.act_SaveExecute(Sender: TObject);
begin
  sysobj.ObServer.Notify(ntobBearb, NTA_DASH_SPEICHERN);
end;



procedure Tfrm_DokuOrga.Button1Click(Sender: TObject);
begin
 // if TbToolbar1.Visible then
 //   ShowMessage(IntToStr(TbToolbar1.Fontbox.FontBox.Items.Count));
end;

procedure Tfrm_DokuOrga.ShowBilder;
var
  Form: Tfrm_Bilder;
  //Bild: TBilder;
begin
  // Bild := TBilder.Create(Self);
  Form := Tfrm_Bilder.Create(Self);
  try
    Form.ShowModal;
   // if Form.Bilder.BildId = -1 then
   //   exit;
   // Bild.Read(Form.Bilder.BildId);
   // btn_Bild.setIcon(Bild.Feld(BI_BILD).Ico.AsIcon);
  finally
    FreeAndNil(Form);
    //FreeAndNil(Bild);
  end;
end;

procedure Tfrm_DokuOrga.ShowDataExport(aImportExport: TImportExport);
var
  Form: Tfrm_DataExport;
begin
  Form := Tfrm_DataExport.Create(Self);
  try
    Form.DataExport.ImportExport := aImportExport;
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;


procedure Tfrm_DokuOrga.ShowHighlighterConfig;
var
  Form: Tfrm_SyntaxHighlighterConfig;
begin
  if SysObj.Einstellung.HighlighterXML.AsBlob > '' then
    SysObj.SaveSyntaxHighlighterToFile;
  Form := Tfrm_SyntaxHighlighterConfig.Create(nil);
  try
    //caption := SysObj.Einstellung.HighlighterXML.AsBlob;
    Form.ShowModal;
    if not Form.Cancel then
    begin
      SysObj.Einstellung.HighlighterXML.AsBlob := Form.XMLStream;
      sysobj.ObServer.Notify(ntobCoreData, NTA_SYNTAXHIGHLIGHTERCHANGE);
    end;
  finally
    FreeAndNil(Form);
  end;
end;

procedure Tfrm_DokuOrga.ShowLink(aBaumButtonEbene, aBaumZweigId: Integer);
var
  Form: Tfrm_Link;
begin
  Form := Tfrm_Link.Create(Self);
  try
    Form.Link.QuellBaumButtonEbene := aBaumButtonEbene;
    Form.Link.QuellBaumZweigId     := aBaumZweigId;
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;

procedure Tfrm_DokuOrga.ShowLinkEntf;
var
  Form: Tfrm_Link_Entf;
begin
  Form := Tfrm_Link_Entf.Create(Self);
  try
    Form.QuellBaumButtonEbene := SysObj.Akt.BaumButtonEbene;
    Form.QuellBaumZweigId     := SysObj.Akt.BaumZweigId;
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;

procedure Tfrm_DokuOrga.ShowSystemeinstellung;
var
  Form: Tfrm_Systemeinstellung;
begin
  Form := Tfrm_Systemeinstellung.Create(Self);
  try
    Form.ShowModal;

  finally
    FreeAndNil(Form);
  end;
end;





end.
