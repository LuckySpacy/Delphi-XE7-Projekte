unit Form.ServerUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, AdvEdit, AdvEdBtn, AdvDirectoryEdit, Xml.xmldom,
  Xml.XMLIntf, Xml.XMLDoc, Objekt.WebserverXML, Objekt.Verschluesseln;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    Panel4: TPanel;
    btn_Delete: TSpeedButton;
    btn_Neu: TSpeedButton;
    lsb: TListBox;
    btn_Schliessen: TButton;
    Panel5: TPanel;
    Panel6: TPanel;
    GroupBox1: TGroupBox;
    Panel7: TPanel;
    Label4: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    pnl_EditDatenbank: TPanel;
    cbx_Datenbankart: TComboBox;
    edt_Datenbankpfad: TAdvDirectoryEdit;
    edt_Datenbankname: TEdit;
    Label5: TLabel;
    edt_DatenbankPort: TAdvEdit;
    Label6: TLabel;
    Label7: TLabel;
    edt_Passwort: TEdit;
    edt_Username: TEdit;
    Webserver: TGroupBox;
    Panel9: TPanel;
    Label1: TLabel;
    Panel10: TPanel;
    edt_Port: TAdvEdit;
    Label8: TLabel;
    edt_WebUsername: TEdit;
    Label9: TLabel;
    edt_WebPasswort: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_SchliessenClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lsbClick(Sender: TObject);
    procedure lsbEnter(Sender: TObject);
    procedure btn_NeuClick(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
    procedure edt_PortExit(Sender: TObject);
  private
    fPfad: string;
    fWebserverXML: TWebserverXML;
    fModulAttribute: TModulAttribute;
    fModulName: string;
    fVerschluesseln: TVerschluesseln;
    procedure FuelleAttributFelder;
    procedure ClearAttributFelder;
    procedure SaveXML;
    function ShowModulname: string;
    procedure SelectModul(aModulname: string);
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  System.UITypes, Form.Modulname;



procedure TForm1.FormCreate(Sender: TObject);
begin
  fPfad := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  fWebserverXML := TWebserverXML.Create(Self, fPfad + 'Webserver.xml');
  fModulAttribute := TModulAttribute.Create;
  fModulname := '';
  fVerschluesseln := TVerschluesseln.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fWebserverXML);
  FreeAndNil(fModulAttribute);
  FreeAndNil(fVerschluesseln);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  fWebserverXML.LadeModule(lsb.Items);
  ClearAttributFelder;
  edt_Port.IntValue := StrToInt(fWebserverXML.WebserverPort);
  if lsb.Items.Count > 0 then
  begin
    lsb.ItemIndex := 0;
    FuelleAttributFelder;
  end;
end;


procedure TForm1.lsbClick(Sender: TObject);
begin
  SaveXML;
  FuelleAttributFelder;
end;

procedure TForm1.lsbEnter(Sender: TObject);
begin
  if lsb.ItemIndex < 0 then
  begin
    fModulName := '';
    exit;
  end;
  fModulName := lsb.Items[lsb.ItemIndex];
end;


procedure TForm1.SaveXML;
var
  ModulAttribute: TModulAttribute;
begin
  if fModulName = '' then
    exit;
  ModulAttribute := fWebserverXML.ModulAttribute(fModulName);
  ModulAttribute.Port := edt_DatenbankPort.Text;
  if edt_Passwort.Text > '' then
    ModulAttribute.Passwort := fVerschluesseln.Verschluesseln(edt_Passwort.Text)
  else
    ModulAttribute.Passwort := '';
  ModulAttribute.Username := edt_Username.Text;
  ModulAttribute.Datenbankname := edt_Datenbankname.Text;
  ModulAttribute.Pfad          := edt_Datenbankpfad.Text;
  ModulAttribute.Art           := cbx_Datenbankart.Text;

  ModulAttribute.WebserverUsername := '';
  ModulAttribute.WebserverPasswort := '';

  if edt_WebUsername.Text > '' then
    ModulAttribute.WebserverUsername := fVerschluesseln.Verschluesseln(edt_WebUsername.Text);
  if edt_WebPasswort.Text > '' then
    ModulAttribute.WebserverPasswort := fVerschluesseln.Verschluesseln(edt_WebPasswort.Text);


  fWebserverXML.SaveModulAttribute(fModulName);
end;


procedure TForm1.SelectModul(aModulname: string);
var
  i1: Integer;
begin
  for i1 := 0 to lsb.Items.Count -1 do
  begin
    if SameText(lsb.Items[i1], aModulname) then
    begin
      lsb.ItemIndex := i1;
      exit;
    end;
  end;
end;

procedure TForm1.btn_DeleteClick(Sender: TObject);
var
  Modulname: string;
begin
  if lsb.ItemIndex < 0 then
    exit;

  Modulname := lsb.Items[lsb.ItemIndex];
  if MessageDlg('Modul "' + Modulname + '" wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  fWebserverXML.LoescheModul(Modulname);
  fWebserverXML.LadeModule(lsb.Items);
  if lsb.Items.Count > 0 then
    SelectModul(lsb.Items[0]);
  FuelleAttributFelder;
end;

procedure TForm1.btn_NeuClick(Sender: TObject);
var
  Modulname: string;
begin
  SaveXML;
  Modulname := ShowModulname;
  if Modulname = '' then
    exit;
  fWebserverXML.NeuesModul(Modulname);
  fWebserverXML.LadeModule(lsb.Items);
  SelectModul(Modulname);
  FuelleAttributFelder;
end;

procedure TForm1.btn_SchliessenClick(Sender: TObject);
begin //
  SaveXML;
  close;
end;

procedure TForm1.ClearAttributFelder;
begin
  edt_Datenbankpfad.Text := '';
  edt_Datenbankname.Text := '';
  edt_DatenbankPort.IntValue := 0;
  edt_Passwort.Text := '';
  edt_Username.Text := '';
  edt_Port.Text := '80';
  edt_WebUsername.Text := '';
  edt_WebPasswort.Text := '';
end;

procedure TForm1.edt_PortExit(Sender: TObject);
begin
  fWebserverXML.WebserverPort := IntToStr(edt_Port.IntValue);
end;

procedure TForm1.FuelleAttributFelder;
var
  ModulAttribute: TModulAttribute;
  i1: Integer;
begin
  ClearAttributFelder;
  if lsb.ItemIndex < 0 then
    exit;
  fModulName := lsb.Items[lsb.ItemIndex];
  ModulAttribute := fWebserverXML.ModulAttribute(lsb.Items[lsb.ItemIndex]);
  edt_Datenbankpfad.Text := ModulAttribute.Pfad;
  edt_Datenbankname.Text := ModulAttribute.Datenbankname;
  edt_DatenbankPort.Text := ModulAttribute.Port;
  if ModulAttribute.Passwort > '' then
    edt_Passwort.Text      := fVerschluesseln.Entschluesseln(ModulAttribute.Passwort);
  //edt_Passwort.Text      := ModulAttribute.Passwort;
  edt_Username.Text      := ModulAttribute.Username;
  for i1 := 0 to cbx_Datenbankart.Items.Count -1 do
  begin
    if SameText(cbx_Datenbankart.Items[i1], ModulAttribute.Art) then
      cbx_Datenbankart.ItemIndex := i1;
  end;
  if ModulAttribute.WebserverUsername > '' then
    edt_WebUsername.Text := fVerschluesseln.Entschluesseln(ModulAttribute.WebserverUsername);
  if ModulAttribute.WebserverPasswort > '' then
    edt_WebPasswort.Text := fVerschluesseln.Entschluesseln(ModulAttribute.WebserverPasswort);
end;




function TForm1.ShowModulname: string;
var
  Form: Tfrm_Modulname;
begin
  Result := '';
  Form := Tfrm_Modulname.Create(nil);
  try
    Form.ShowModal;
    if not Form.Cancel then
      Result := Form.edt_Modulname.Text;
  finally
    FreeAndNil(Form);
  end;
end;


end.
