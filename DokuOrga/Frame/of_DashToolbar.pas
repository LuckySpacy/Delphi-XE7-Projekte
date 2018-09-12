unit of_DashToolbar;

interface

uses
  SysUtils, Classes, Forms, StdCtrls, Buttons, of_Base, c_Types,
  ExtCtrls, Dialogs, o_sysObj, Controls, obBusinessClasses, obServerClient,
  tbButton;


type
  RButton = Record
    Neu : TTBButton;
    Speichern: TTBButton;
    Return: TTBButton;
    DataExport: TTBButton;
    DataImport: TTBButton;
    Systemeinstellung: TTBButton;
  End;

type
  Tof_DashToolbar = class(Tof_Base, IObServerClient)
  private
    FButton: RButton;
    procedure btn_NeuClick(Sender: TObject);
    procedure btn_SpeichernClick(Sender: TObject);
    procedure btn_ReturnClick(Sender: TObject);
    procedure btn_ExportClick(Sender: TObject);
    procedure btn_ImportClick(Sender: TObject);
    procedure btn_SystemeinstellungClick(Sender: TObject);
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure RegisterNotify;
    procedure UnregisterNotify;
  protected
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

implementation

{ Tof_DashToolbar }

constructor Tof_DashToolbar.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FButton.Neu        := gettbButton('btn_Neu');
  FButton.Speichern  := gettbButton('btn_Save');
  FButton.Return     := gettbButton('btn_Return');
  FButton.DataExport := gettbButton('btn_Export');
  FButton.DataImport := gettbButton('btn_Import');
  FButton.Systemeinstellung := gettbButton('btn_Eigenschaften');
  RegisterNotify;

  FButton.Neu.OnClick := btn_NeuClick;
  FButton.Speichern.OnClick := btn_SpeichernClick;
  FButton.Return.OnClick := btn_ReturnClick;
  FButton.DataExport.OnClick := btn_ExportClick;
  FButton.DataImport.OnClick := btn_ImportClick;
  FButton.Systemeinstellung.OnClick := btn_SystemeinstellungClick;
end;

destructor Tof_DashToolbar.Destroy;
begin
  UnregisterNotify;
  inherited;
end;

procedure Tof_DashToolbar.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
//var
//  NotifyStatus: PNotifyStatus;
begin
  if AType = ntobStatus then
  begin
    //NotifyStatus := Pointer(Data);
  end;
end;


procedure Tof_DashToolbar.RegisterNotify;
begin
  SysObj.ObServer.RegisterNotifications(Self, [ntobStatus]);
end;

procedure Tof_DashToolbar.UnregisterNotify;
begin
  SysObj.ObServer.UnregisterNotifications(Self);
end;

procedure Tof_DashToolbar.btn_ExportClick(Sender: TObject);
begin
  sysobj.ObServer.Notify(ntobBearb, NTA_DASH_DATAEXPORT);
end;

procedure Tof_DashToolbar.btn_ImportClick(Sender: TObject);
begin
  sysobj.ObServer.Notify(ntobBearb, NTA_DASH_DATAIMPORT);
end;

procedure Tof_DashToolbar.btn_NeuClick(Sender: TObject);
begin
  sysobj.ObServer.Notify(ntobBearb, NTA_DASH_NEU);
end;

procedure Tof_DashToolbar.btn_ReturnClick(Sender: TObject);
begin
  sysobj.ObServer.Notify(ntobBearb, NTA_DASH_FOLDERRETURN);
end;

procedure Tof_DashToolbar.btn_SpeichernClick(Sender: TObject);
begin
  sysobj.ObServer.Notify(ntobBearb, NTA_DASH_SPEICHERN);
end;

procedure Tof_DashToolbar.btn_SystemeinstellungClick(Sender: TObject);
begin
  sysobj.ObServer.Notify(ntobBearb, NTA_DASH_SYSTEMEINSTELLUNG);
end;

end.
