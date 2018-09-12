unit of_konf_ftp;

interface

uses

 Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  of_Base, c_Types, o_sysObj, obBusinessClasses, obServerClient, of_konf_base,
  contnrs, tbbutton, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, IdFTPList, System.UITypes;


type
  Tof_Konf_FTP = class(Tof_konf_Base, IObServerClient)
  private
    Fedt_Host: TEdit;
    Fedt_Username: TEdit;
    Fedt_PW: TEdit;
    Fedt_PW2: TEdit;
    Fedt_Pfad: TEdit;
    FBtn_Speichern: TTBButton;
    FBtn_Testen: TTBButton;
    Fcbx_FTPVerwenden: TCheckbox;
    Fftp: TIdFTP;
    FMemo: TMemo;
    FTimer: TTimer;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure SpeichernClick(Sender: TObject);
    procedure TestenClick(Sender: TObject);
    procedure Connected(Sender: TObject);
    procedure Disconnected(Sender: TObject);
    procedure Status(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    //procedure LoadList;
    procedure Timer(Sender: TObject);
  protected
    procedure Save; override;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

implementation

{ Tof_Konf_FTP }


constructor Tof_Konf_FTP.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FEdt_Host      := getEdit('edt_Host');
  FEdt_Username  := getEdit('edt_Username');
  FEdt_PW        := getEdit('edt_Passwort');
  FEdt_PW2       := getEdit('edt_PW2');
  FEdt_Pfad      := getEdit('edt_Pfad');
  FBtn_Speichern := gettbButton('btn_Speichern');
  FBtn_Testen    := gettbButton('btn_Testen');
  FMemo          := getMemo('Memo1');
  Fcbx_FTPVerwenden := getCheckbox('cbx_FTPVerwenden');
  FBtn_Speichern.OnClick := SpeichernClick;
  FBtn_Testen.OnClick := TestenClick;

  FEdt_Host.Text := SysObj.Einstellung.FTP.Host.AsString;
  Fedt_Username.Text := SysObj.Einstellung.FTP.Username.AsString;
  Fedt_PW.Text       := SysObj.Einstellung.FTP.Passwort.AsString;
  Fedt_PW2.Text      := SysObj.Einstellung.FTP.Passwort.AsString;
  Fedt_Pfad.Text     := SysObj.Einstellung.FTP.Pfad.AsString;
  Fcbx_FTPVerwenden.Checked := SysObj.Einstellung.FTP.DokumenteUebertragen.AsBoolean;

  Fedt_PW.PasswordChar := '*';
  Fedt_PW2.PasswordChar := '*';

  Fftp := TIdFTP.Create(nil);
  Fftp.OnConnected := Connected;
  Fftp.OnDisconnected := Disconnected;
  Fftp.OnStatus := Status;
  FTimer := TTimer.Create(nil);
  FTimer.Enabled := false;
  FTimer.OnTimer := Timer;

  FMemo.Clear;


end;

destructor Tof_Konf_FTP.Destroy;
begin
  FreeAndNil(FTimer);
  FreeAndNil(Fftp);
  inherited;
end;


procedure Tof_Konf_FTP.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin

end;

procedure Tof_Konf_FTP.Save;
begin
  inherited;
  {$WARN SYMBOL_DEPRECATED OFF}
  if Fftp.Connected then
    Fftp.Quit;
  {$WARN SYMBOL_DEPRECATED ON}
end;

procedure Tof_Konf_FTP.SpeichernClick(Sender: TObject);
var
  Pfad: string;
begin
  if Fedt_PW.Text <> Fedt_PW2.Text then
  begin
    MessageDlg('Passwort stimmt nicht überein', mtInformation, [mbOk], 0);
    Fedt_PW.SetFocus;
    exit;
  end;
  Pfad := Fedt_Pfad.Text;
  Pfad := StringReplace(Pfad, '\', '/', [rfReplaceAll]);
  if Pfad[1] = '/' then
    Pfad := copy(Pfad, 2, Length(Pfad));

  if Pfad[Length(Pfad)] <> '/' then
    Pfad := Pfad + '/';
  Fedt_Pfad.Text := Pfad;

  Sysobj.Einstellung.FTP.Host.AsString     := Fedt_Host.Text;
  SysObj.Einstellung.FTP.Username.AsString := Fedt_Username.Text;
  SysObj.Einstellung.FTP.Passwort.AsString := Fedt_PW.Text;
  SysObj.Einstellung.FTP.Pfad.AsString     := Fedt_Pfad.Text;
  SysObj.Einstellung.FTP.DokumenteUebertragen.AsBoolean := Fcbx_FTPVerwenden.Checked;
  MessageDlg('Eingabe wurde gespeichert', mtInformation, [mbOk], 0);

end;

procedure Tof_Konf_FTP.Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  FMemo.Lines.Add(AStatusText);
end;

procedure Tof_Konf_FTP.TestenClick(Sender: TObject);
begin
  FFtp.Host := Fedt_Host.Text;
  FFtp.Username := Fedt_Username.Text;
  FFtp.Password := Fedt_PW.Text;
  {$WARN SYMBOL_DEPRECATED OFF}
  if Fftp.Connected then
    Fftp.Quit;
  {$WARN SYMBOL_DEPRECATED ON}
  FFtp.Connect;

end;

procedure Tof_Konf_FTP.Timer(Sender: TObject);
begin
  if not Fftp.Connected then
    exit;
  FTimer.Enabled := false;
  Fftp.ChangeDir(Fedt_Pfad.Text);
end;

{
procedure Tof_Konf_FTP.LoadList;
var
  x: TIdFTPListItems;
  i1: Integer;
begin
  Fftp.ChangeDir(Fedt_Pfad.Text);
  x := fftp.DirectoryListing;
  //FMemo.Clear;
  Fftp.List(FMemo.Lines);
end;
}

procedure Tof_Konf_FTP.Connected(Sender: TObject);
begin
  MessageDlg('Verbindung war erfolgreich', mtInformation, [mbOk], 0);
  FTimer.Enabled := true;
end;

procedure Tof_Konf_FTP.Disconnected(Sender: TObject);
begin
  //MessageDlg('Disconnected', mtInformation, [mbOk], 0);
end;



end.
