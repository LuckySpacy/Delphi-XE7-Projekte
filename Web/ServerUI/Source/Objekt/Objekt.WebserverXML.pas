unit Objekt.WebserverXML;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Xml.xmldom,  Xml.XMLIntf, Xml.XMLDoc, Objekt.Verschluesseln;

type
  TModulAttribute = class
  public
    Port: string;
    Passwort: string;
    Username: string;
    Datenbankname: string;
    Pfad: string;
    Art: string;
    WebserverUsername: string;
    WebserverPasswort: string;
    procedure Init;
  end;

type
  TWebserverXML = class
  private
    fXMLDocument: TXMLDocument;
    fDocument: IXMLDocument;
    fXMLFilename: string;
    fModulAttribute: TModulAttribute;
    fVerschluesseln: TVerschluesseln;
    function getWebserverPort: string;
    procedure setWebserverPort(const Value: string);
  public
    constructor Create(AOwner: TComponent; aXMLFilename: string);
    destructor Destroy; override;
    procedure LadeModule(aItems: TStrings);
    function ModulAttribute(aModul: string): TModulAttribute;
    procedure SaveModulAttribute(aModul: string);
    procedure NeuesModul(aModul: string);
    procedure LoescheModul(aModul: string);
    property WebserverPort: string read getWebserverPort write setWebserverPort;
    function WebserverUsername: string;
    function WebserverPasswort: string;
  end;

implementation

{ TWebserverXML }

constructor TWebserverXML.Create(AOwner: TComponent; aXMLFilename: string);
var
  WebserverNode: IXMLNode;
begin
  fXMLDocument := TXMLDocument.Create(AOwner);
  fXMLFilename := aXMLFilename;

  if FileExists(fXMLFilename) then
  begin
    //fDocument := fXMLDocument.Create(aXMLFilename);
    fDocument := fXMLDocument.Create(AOwner);
    fDocument.Active := true;
    fDocument.LoadFromFile(aXMLFilename);
  end
  else
  begin
    fDocument := fXMLDocument.Create(nil);
    fDocument.Active := true;
    WebserverNode := fDocument.AddChild('Webserver');
    WebserverNode.Attributes['Port'] := '80';
  end;

  fModulAttribute := TModulAttribute.Create;
  fVerschluesseln := nil;
end;

destructor TWebserverXML.Destroy;
begin
  //FreeAndNil(fXMLDocument);
  //FreeAndNil(fDocument);
  FreeAndNil(fModulAttribute);
  if fVerschluesseln <> nil then
    FreeAndNil(fVerschluesseln);
  inherited;
end;

function TWebserverXML.getWebserverPort: string;
var
  WebserverNode: IXMLNode;
begin
  WebserverNode := fDocument.DocumentElement;
  Result := WebserverNode.Attributes['Port'];
end;

procedure TWebserverXML.LadeModule(aItems: TStrings);
var
  i1: Integer;
  WebserverNode: IXMLNode;
  Node: IXMLNode;
begin
  aItems.Clear;
  WebserverNode := fDocument.DocumentElement;
  for i1 := 0 to WebserverNode.ChildNodes.Count -1 do
  begin
    Node := WebserverNode.ChildNodes[i1];
    aItems.Add(Node.NodeName);
  end;
end;

procedure TWebserverXML.LoescheModul(aModul: string);
var
  i1: Integer;
  WebserverNode: IXMLNode;
  Node: IXMLNode;
begin
  WebserverNode := fDocument.DocumentElement;
  for i1 := 0 to WebserverNode.ChildNodes.Count -1 do
  begin
    Node := WebserverNode.ChildNodes[i1];
    if SameText(Node.NodeName, aModul) then
    begin
      WebserverNode.ChildNodes.Delete(i1);
      fDocument.SaveToFile(fXMLFilename);
      break;
    end;
  end;
end;

function TWebserverXML.ModulAttribute(aModul: string): TModulAttribute;
var
  i1: Integer;
  WebserverNode: IXMLNode;
  Node: IXMLNode;
  DatenbankNode: IXMLNode;
begin
  fModulAttribute.Init;
  WebserverNode := fDocument.DocumentElement;
  fModulAttribute.WebserverUsername := '';
  fModulAttribute.WebserverPasswort := '';
  if WebserverNode.Attributes['Username'] <> null then
    fModulAttribute.WebserverUsername := WebserverNode.Attributes['Username'];
  if WebserverNode.Attributes['Passwort'] <> null then
    fModulAttribute.WebserverPasswort := WebserverNode.Attributes['Passwort'];
  for i1 := 0 to WebserverNode.ChildNodes.Count -1 do
  begin
    Node := WebserverNode.ChildNodes[i1];
    if SameText(Node.NodeName, aModul) then
    begin
      DatenbankNode := Node.ChildNodes[0];
      fModulAttribute.Port     := DatenbankNode.Attributes['Port'];
      fModulAttribute.Passwort := DatenbankNode.Attributes['Passwort'];
      fModulAttribute.Username := DatenbankNode.Attributes['Username'];
      fModulAttribute.Datenbankname := DatenbankNode.Attributes['Datenbankname'];
      fModulAttribute.Pfad := DatenbankNode.Attributes['Pfad'];
      fModulAttribute.Art := DatenbankNode.Attributes['Art'];
      break;
    end;
  end;
  Result := fModulAttribute;
end;




procedure TWebserverXML.SaveModulAttribute(aModul: string);
var
  i1: Integer;
  WebserverNode: IXMLNode;
  Node: IXMLNode;
  DatenbankNode: IXMLNode;
begin
  WebserverNode := fDocument.DocumentElement;
  WebServerNode.Attributes['Username'] := fModulAttribute.WebserverUsername;
  WebServerNode.Attributes['Passwort'] := fModulAttribute.WebserverPasswort;
  for i1 := 0 to WebserverNode.ChildNodes.Count -1 do
  begin
    Node := WebserverNode.ChildNodes[i1];
    if SameText(Node.NodeName, aModul) then
    begin
      DatenbankNode := Node.ChildNodes[0];
      DatenbankNode.Attributes['Port'] := fModulAttribute.Port;
      DatenbankNode.Attributes['Passwort'] := fModulAttribute.Passwort;
      DatenbankNode.Attributes['Username'] := fModulAttribute.Username;
      DatenbankNode.Attributes['Datenbankname'] := fModulAttribute.Datenbankname;
      DatenbankNode.Attributes['Pfad'] := fModulAttribute.Pfad;
      DatenbankNode.Attributes['Art'] := fModulAttribute.Art;
      fDocument.SaveToFile(fXMLFilename);
      break;
    end;
  end;
end;

procedure TWebserverXML.setWebserverPort(const Value: string);
var
  WebserverNode: IXMLNode;
begin
  WebserverNode := fDocument.DocumentElement;
  WebserverNode.Attributes['Port'] := Value;
  fDocument.SaveToFile(fXMLFilename);
end;

function TWebserverXML.WebserverPasswort: string;
var
  WebserverNode: IXMLNode;
begin
  Result := '';
  WebserverNode := fDocument.DocumentElement;
  if WebserverNode.Attributes['Passwort'] = null then
    exit;
  Result := WebserverNode.Attributes['Passwort'];
  if Result > '' then
  begin
    if fVerschluesseln = nil then
      fVerschluesseln := TVerschluesseln.Create;
    Result := fVerschluesseln.Entschluesseln(Result);
  end;
end;

function TWebserverXML.WebserverUsername: string;
var
  WebserverNode: IXMLNode;
begin
  Result := '';
  WebserverNode := fDocument.DocumentElement;
  if WebserverNode.Attributes['Username'] = null then
    exit;
  Result := WebserverNode.Attributes['Username'];
  if Result > '' then
  begin
    if fVerschluesseln = nil then
      fVerschluesseln := TVerschluesseln.Create;
    Result := fVerschluesseln.Entschluesseln(Result);
  end;
end;

procedure TWebserverXML.NeuesModul(aModul: string);
var
  i1: Integer;
  WebserverNode: IXMLNode;
  Modul: IXMLNode;
  Datenbank: IXMLNode;
  Modulname: string;
begin
  if fVerschluesseln = nil then
    fVerschluesseln := TVerschluesseln.Create;
  WebserverNode := fDocument.DocumentElement;
  Modulname := '';
  for i1 := 1 to Length(aModul) do
  begin
    if aModul[i1] = ' ' then
      continue;
    Modulname := Modulname + aModul[i1];
  end;
  Modul := WebserverNode.AddChild(Modulname);
  Datenbank  := Modul.AddChild('Datenbank');
  Datenbank.Attributes['Art']  := 'Firebird';
  Datenbank.Attributes['Pfad'] := '';
  Datenbank.Attributes['Datenbankname'] := '';
  Datenbank.Attributes['Username'] := 'sysdba';
  Datenbank.Attributes['Passwort'] := fVerschluesseln.Verschluesseln('masterkey');
  Datenbank.Attributes['Port'] := '3050';
  fDocument.SaveToFile(fXMLFilename);
end;


{ TModulAttribute }

procedure TModulAttribute.Init;
begin
  Port     := '0';
  Passwort := '';
  Username := '';
  Datenbankname := '';
  Pfad := '';
  Art  := '';
end;

end.
