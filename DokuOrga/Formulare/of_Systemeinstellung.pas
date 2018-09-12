unit of_Systemeinstellung;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  of_Base, c_Types, o_sysObj, obBusinessClasses, obServerClient, fr_konf_base,
  contnrs, fr_konf_dokumente, fr_konf_masterpw, fr_konf_seite, fr_konf_ftp,
  fr_konf_datenbank, fr_konf_googledrive;



type
  RFrame = Record const
    Datenbank : Integer = 1;
    Dokumente : Integer = 2;
    MasterPW  : Integer = 3;
    Seite     : Integer = 4;
    FTP       : Integer = 5;
    GoogleDrive: Integer = 6;
  End;


type
  Tof_Systemeinstellung = class(Tof_Base, IObServerClient)
  private
    Flsb_Einstellung: TListBox;
    FFrameList: TObjectList;
    Fpnl_Konf: TPanel;
    FFraTypes: RFrame;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure lsb_EinstellungClick(Sender: TObject);
    procedure LadeFrame(aValue: Integer);
  protected
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;


implementation

{ Tof_Systemeinstellung }

constructor Tof_Systemeinstellung.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FFrameList := TObjectList.Create;
  Flsb_Einstellung := getListbox('lsb_Einstellung');
  Flsb_Einstellung.AddItem('Datenbank', TObject(FFraTypes.Datenbank));
  Flsb_Einstellung.AddItem('Dokumente', TObject(FFraTypes.Dokumente));
  Flsb_Einstellung.AddItem('Hauptpasswort', TObject(FFraTypes.MasterPW));
  Flsb_Einstellung.AddItem('Seite', TObject(FFraTypes.Seite));
  Flsb_Einstellung.AddItem('FTP', TObject(FFraTypes.FTP));
  Flsb_Einstellung.AddItem('Google-Drive', TObject(FFraTypes.GoogleDrive));
  Fpnl_Konf := getPanel('pnl_Client');
  Flsb_Einstellung.OnClick := lsb_EinstellungClick;
end;

destructor Tof_Systemeinstellung.Destroy;
begin
  FreeAndNil(FFrameList);
  inherited;
end;


procedure Tof_Systemeinstellung.lsb_EinstellungClick(Sender: TObject);
begin //
  if Flsb_Einstellung.ItemIndex > -1 then
    LadeFrame(Integer(Flsb_Einstellung.Items.Objects[Flsb_Einstellung.ItemIndex]));
end;


procedure Tof_Systemeinstellung.LadeFrame(aValue: Integer);
  function GetFrame(aValue: Integer): Tfra_Konf_Base;
  var
    i1: Integer;
  begin
    Result := nil;
    for i1 := 0 to FFrameList.Count -1 do
    begin
      if TFrame(FFrameList.Items[i1]).Tag = aValue then
      begin
        Result := Tfra_Konf_Base(FFrameList.Items[i1]);
        exit;
      end;
    end;
  end;
var
  Konf: Tfra_Konf_Base;
  i1: Integer;
begin
  for i1 := 0 to FFrameList.Count -1 do
    Tfra_Konf_Base(FFrameList.Items[i1]).Visible := false;

  Konf := GetFrame(aValue);
  if Konf = nil then
  begin
    if aValue = FFraTypes.Datenbank then
    begin
      Konf := Tfra_Konf_Datenbank.Create(Self);
      FFrameList.Add(Konf);
    end;
    if aValue = FFraTypes.Dokumente then
    begin
      Konf := Tfra_Konf_Dokumente.Create(Self);
      FFrameList.Add(Konf);
    end;
    if aValue = FFraTypes.MasterPW then
    begin
      Konf := Tfra_Konf_MasterPW.Create(Self);
      FFrameList.Add(Konf);
    end;
    if aValue = FFraTypes.Seite then
    begin
      Konf := Tfra_Konf_Seite.Create(Self);
      FFrameList.Add(Konf);
    end;
    if aValue = FFraTypes.FTP then
    begin
      Konf := Tfra_Konf_FTP.Create(Self);
      FFrameList.Add(Konf);
    end;
    if aValue = FFraTypes.GoogleDrive then
    begin
      Konf := Tfra_Konf_GoogleDrive.Create(Self);
      FFrameList.Add(Konf);
    end;
  end;
  if Konf <> nil then
  begin
    Konf.Tag := aValue;
    Konf.Parent := Fpnl_Konf;
    Konf.Align  := alClient;
    Konf.Visible := true;
  end;
end;


procedure Tof_Systemeinstellung.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin

end;

end.
