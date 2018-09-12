unit of_konf_googledrive;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  of_Base, c_Types, o_sysObj, obBusinessClasses, obServerClient, of_konf_base,
  contnrs, tbbutton, System.UITypes;

type
  Tof_Konf_GoogleDrive = class(Tof_konf_Base, IObServerClient)
  private
    Fedt_ClientId: TEdit;
    Fedt_ClientKey: TEdit;
    Fedt_Pfad: TButtonedEdit;
    FBtn_Speichern: TTBButton;
    FBtn_Testen: TTBButton;
    Fcbx_GDriveVerwenden: TCheckbox;
    FImageList: TImageList;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure SpeichernClick(Sender: TObject);
    procedure TestenClick(Sender: TObject);
    procedure Connected(Sender: TObject);
    procedure Disconnected(Sender: TObject);
    procedure edt_DirClickBtn(Sender: TObject);
    procedure ShowGDriveBaum;
    //procedure LoadList;
  protected
    procedure Save; override;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;



implementation

{ Tof_Konf_GoogleDrive }

{$R EditFile.res}

uses
  fnt_GDriveBaum, u_AllgFunc;

constructor Tof_Konf_GoogleDrive.Create(AOwner: TComponent; AMode: TModus);
var
  Icon: TIcon;
begin
  inherited;
  FEdt_ClientId  := getEdit('edt_ClientId');
  FEdt_ClientKey := getEdit('edt_ClientKey');
  FEdt_Pfad      := getButtonedEdit ('edt_Pfad');
  FBtn_Speichern := gettbButton('btn_Speichern');
  FBtn_Testen    := gettbButton('btn_Testen');
  Fcbx_GDriveVerwenden := getCheckbox('cbx_GDriveVerwenden');
  FImageList  := getImageList('ImageList1');
  FBtn_Speichern.OnClick := SpeichernClick;
  FBtn_Testen.OnClick := TestenClick;

  FEdt_ClientId.Text  := SysObj.Einstellung.GoogleDrive.ClientId.AsString;
  Fedt_ClientKey.Text := SysObj.Einstellung.GoogleDrive.ClientKey.AsString;
  Fedt_Pfad.Text     := SysObj.Einstellung.GoogleDrive.Pfad.AsString;
  Fcbx_GDriveVerwenden.Checked := SysObj.Einstellung.GoogleDrive.GDriveVerwenden.AsBoolean;

  Fedt_Pfad.Images := FImageList;
  FEdt_Pfad.OnRightButtonClick:= edt_DirClickBtn;
  FEdt_Pfad.ReadOnly := true;

  Icon := TIcon.Create;
  tbLoadIconFromRes('RT_RCDATA', 'Oeffnen', Icon);
  FImageList.AddIcon(Icon);
  FreeAndNil(Icon);

  FEdt_Pfad.RightButton.DisabledImageIndex := 0;
  FEdt_Pfad.RightButton.HotImageIndex := 0;
  FEdt_Pfad.RightButton.ImageIndex := 0;
  FEdt_Pfad.RightButton.PressedImageIndex := 0;




end;

destructor Tof_Konf_GoogleDrive.Destroy;
begin

  inherited;
end;


procedure Tof_Konf_GoogleDrive.Connected(Sender: TObject);
begin

end;



procedure Tof_Konf_GoogleDrive.Disconnected(Sender: TObject);
begin

end;


procedure Tof_Konf_GoogleDrive.ObServerNotification(AType: TNotificationType;
  Action, Data: Integer);
begin

end;

procedure Tof_Konf_GoogleDrive.Save;
begin
  inherited;
  SysObj.Einstellung.GoogleDrive.ClientId.AsString := FEdt_ClientId.Text;
  SysObj.Einstellung.GoogleDrive.ClientKey.AsString := Fedt_ClientKey.Text;
  SysObj.Einstellung.GoogleDrive.Pfad.AsString := Fedt_Pfad.Text;
  SysObj.Einstellung.GoogleDrive.GDriveVerwenden.AsBoolean := Fcbx_GDriveVerwenden.Checked;
end;


procedure Tof_Konf_GoogleDrive.SpeichernClick(Sender: TObject);
begin
  save;
end;

procedure Tof_Konf_GoogleDrive.TestenClick(Sender: TObject);
var
  TokenExists: Boolean;
begin
  SysObj.GDrive.ClientId := Fedt_ClientId.Text;
  SysObj.GDrive.ClientKey := Fedt_ClientKey.Text;
  TokenExists := FileExists(SysObj.GDrive.TokenIni);

  if SysObj.GDrive.Connect then
  begin
    MessageDlg('Die Verbindung konnte hergestellt werden.', mtInformation, [mbOK], 0);
    exit;
  end;

  if not TokenExists then
  begin
    MessageDlg('Bitte überprüfen Sie nochmals die Verbindung zu Google', mtInformation, [mbOK], 0);
    exit;
  end;

  MessageDlg('Die Verbindung konnte nicht hergestellt werden.', mtError, [mbOK], 0)

end;

procedure Tof_Konf_GoogleDrive.edt_DirClickBtn(Sender: TObject);
begin //
  ShowGDriveBaum;
end;


procedure Tof_Konf_GoogleDrive.ShowGDriveBaum;
var
  Form: Tfrm_GDriveBaum;
begin
  Form := Tfrm_GDriveBaum.Create(nil);
  try
    Form.ShowModal;
    if not Form.Cancel then
      Fedt_Pfad.Text := Form.AktFolder;
  finally
    FreeAndNil(Form);
  end;

end;

end.
