unit of_DokumenteToolbar;

interface

uses
  SysUtils, Classes, Forms, StdCtrls, Buttons, of_Base, c_Types,
  ExtCtrls, Dialogs, o_sysObj, Controls, obBusinessClasses, obServerClient,
  tbButton, Contnrs, IBDatabase, fr_Base, Menus;


type
  Tof_DokumenteToolbar = class(Tof_Base, IObServerClient)
  private
    Fbtn_FileAdd: TTBButton;
    Fbtn_FileDel: TTBButton;
    Fbtn_FileRefresh: TTBButton;
    Fbtn_Link: TTBButton;
    FBtn_LinkEntf: TTBButton;
    FBtn_LinkAdd: TTBButton;
    FBtn_DokuLinkAdd: TTBButton;
    FBtn_DokuLinkDel: TTBButton;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure OnFileAddClick(Sender: TObject);
    procedure OnFileDelClick(Sender: TObject);
    procedure OnFileRefreshClick(Sender: TObject);
    procedure OnLinkClick(Sender: TObject);
    procedure OnLinkEntf(Sender: TObject);
    procedure OnLinkAdd(Sender: TObject);
    procedure OnDokuLinkAdd(Sender: TObject);
    procedure OnDokuLinkDel(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;


implementation

{ Tof_DokumenteToolbar }

uses
  o_Dokument;

constructor Tof_DokumenteToolbar.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fbtn_FileAdd := gettbButton('btn_FileAdd');
  Fbtn_FileDel := gettbButton('btn_FileDel');
  Fbtn_FileRefresh := gettbButton('btn_DokumentRefresh');
  Fbtn_Link := gettbButton('btn_Link');
  Fbtn_FileAdd.OnClick := OnFileAddClick;
  Fbtn_FileDel.OnClick := OnFileDelClick;
  Fbtn_FileRefresh.OnClick := OnFileRefreshClick;
  Fbtn_Link.OnClick := OnLinkClick;
  Fbtn_LinkEntf := gettbButton('btn_LinkEntfernen');
  Fbtn_LinkAdd  := gettbButton('btn_Link_Add');
  FBtn_DokuLinkAdd := gettbButton('btn_DokuLink_Add');
  Fbtn_DokuLinkAdd.Visible := false;
  FBtn_DokuLinkDel := gettbButton('btn_DokuLink_Del');
  Fbtn_DokuLinkDel.Visible := false;

  FBtn_LinkEntf.OnClick := OnLinkEntf;
  Fbtn_LinkAdd.OnClick := OnLinkAdd;
  FBtn_DokuLinkAdd.OnClick := OnDokuLinkAdd;
  FBtn_DokuLinkDel.OnClick := OnDokuLinkDel;

  if sysobj.Akt.Modus = cLink then
  begin
    Fbtn_FileAdd.Visible := false;
    Fbtn_FileDel.Visible := false;
    Fbtn_FileRefresh.Visible := false;
    Fbtn_Link.Visible := false;
    Fbtn_LinkEntf.Visible := false;
    Fbtn_LinkAdd.Visible  := true;
    FBtn_LinkAdd.Hint := 'Seite verbinden';
    FBtn_LinkAdd.ShowHint := true;
    Fbtn_DokuLinkAdd.Visible := true;
    Fbtn_DokuLinkAdd.Hint := 'Dokument verbinden';
    Fbtn_DokuLinkAdd.ShowHint := true;
    Fbtn_DokuLinkDel.Hint := 'Dokument-Verbindung entfernen';
    Fbtn_DokuLinkDel.ShowHint := true;
  end
  else
  begin
    Fbtn_LinkAdd.Visible  := false;
  end;


end;

destructor Tof_DokumenteToolbar.Destroy;
begin

  inherited;
end;

procedure Tof_DokumenteToolbar.ObServerNotification(AType: TNotificationType;
  Action, Data: Integer);
var
  Dokument: TDokument;
begin
  if AType = ntobCoreData then
  begin
    if (Action = NTA_DOKU_ROW_CHANGED) then
    begin
      Dokument := TDokument(Data);
    end;
  end;
end;

procedure Tof_DokumenteToolbar.OnDokuLinkAdd(Sender: TObject);
begin
  SysObj.ObServer.Notify(ntobBearb, NTA_LINK_ADD_DOK_DO);
end;

procedure Tof_DokumenteToolbar.OnDokuLinkDel(Sender: TObject);
begin
  SysObj.ObServer.Notify(ntobBearb, NTA_LINK_DEL_DOK_DO);
end;

procedure Tof_DokumenteToolbar.OnFileAddClick(Sender: TObject);
begin
  if SysObj.Einstellung.DokumentPfad.AsString = '' then
  begin
    ShowMessage('Es wurde noch kein Hauptdokumentenverzeichnis festgelegt.' + sLineBreak +
                'Bitte legen Sie ein Verzeichnis in den Einstellungen fest.');
    exit;
  end;
  SysObj.ObServer.Notify(ntobBearb, NTA_FILEOPENDIALOG);
end;

procedure Tof_DokumenteToolbar.OnFileDelClick(Sender: TObject);
begin
  SysObj.ObServer.Notify(ntobBearb, NTA_DELETEPOS);
end;

procedure Tof_DokumenteToolbar.OnFileRefreshClick(Sender: TObject);
begin
  SysObj.ObServer.Notify(ntobBearb, NTA_DOKUMENTREFRESH);
end;

procedure Tof_DokumenteToolbar.OnLinkAdd(Sender: TObject);
begin
  SysObj.ObServer.Notify(ntobBearb, NTA_LINK_ADD);
end;

procedure Tof_DokumenteToolbar.OnLinkClick(Sender: TObject);
begin
  SysObj.ObServer.Notify(ntobBearb, NTA_LINK_START);
end;

procedure Tof_DokumenteToolbar.OnLinkEntf(Sender: TObject);
begin
  SysObj.ObServer.Notify(ntobBearb, NTA_LINK_ENTF);
end;

end.
