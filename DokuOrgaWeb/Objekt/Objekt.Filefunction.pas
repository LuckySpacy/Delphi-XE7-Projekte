unit Objekt.Filefunction;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, shlobj, ActiveX, Objekt.Folderlocation,
  System.UITypes;

type
  TFilefunction = class
  private
    fFolderLocation : TFolderLocation;
    function DoNetworkConnection(aDrive: Char; aShowError: Boolean): Boolean;
    function GetNetworkPath(const aDriveChar: Char): string;
    function ConnectDrive(_drvLetter, _netPath: string; _showError, _reconnect: Boolean): DWORD;
 protected
  public
    constructor Create;
    destructor Destroy; override;
    function DirExist(aPath: string): Integer;
  end;

implementation

{ TFilefunction }

constructor TFilefunction.Create;
begin
  fFolderLocation := nil;
end;

destructor TFilefunction.Destroy;
begin
  if fFolderLocation <> nil then
    FreeAndNil(fFolderLocation);
  inherited;
end;


function TFilefunction.DirExist(aPath: string): Integer;
begin
  // Result = 0  / Pfad existiert.
  // Result = -1 / Pfad existiert nicht
  // Result = -2 / Netzwerkverbindung konnte nicht hergestellt werden.
  try
    Result := 0;
    if aPath = '\' then
    begin
      result := -1;
      exit;
    end;

    if not System.SysUtils.DirectoryExists(aPath) then
    begin
      if not DoNetworkConnection(aPath[1], false) then
        Result := -2;
      if not System.SysUtils.DirectoryExists(aPath) then
      begin
        if Result <> -2 then
          Result := -1;
      end;
    end;
  except
    Result := -3;
  end;
end;


//Verbinde einen bestehenden Laufwerksbuchstaben mit dem Netzwerk.
function TFilefunction.DoNetworkConnection(aDrive: Char; aShowError: Boolean): Boolean;
var
  NetworkPath: string;
  Error: Integer;
begin
  Result := false;
  try
    Networkpath := GetNetworkPath(aDrive);
    Error       := ConnectDrive(aDrive + ':', Networkpath, aShowError, true);
    Result      := Error = 0;
  except
    on E: Exception do
    begin
      if aShowError then
        MessageDlg(E.Message, mtError, [mbOk], 0);
    end;
  end;
end;

// Diese Funktion liefert anhand des Netzwerkbuchstabens den damit verbundenen
// Netzwerkpfad
function TFilefunction.GetNetworkPath(const aDriveChar: Char): string;
const
  MaxVolSize = 260;
var
  Path : array [0..3] of Char;
  NU, VolSize : DWord;
  Vol : PChar;
  Error: DWord;
begin
  Path[0] := aDriveChar;
  Path[1] := ':';
  Path[2] := #0;
  VolSize := MaxVolSize;
  GetMem(Vol, MaxVolSize);
  Vol[0] := #0;
  Result := '';
  try
    Error := WNetGetConnection(Path, Vol, VolSize);
    if (Error = WN_SUCCESS) or (Error = 1201) then
      Result := StrPas(Vol)
    else
    begin
      if GetVolumeInformation(PChar(aDriveChar + ':\'),
        Vol, MAX_PATH, nil, NU, NU, nil, 0) then
        Result := Vol;
      Result := Format('[%s]',[Result]);
    end;
  finally
    FreeMem(Vol, MaxVolSize);
  end;
end;


// Diese Funktion verbindet sich mit dem angegebenen Laufwerksbuchstabe an das Netzwerk.
// Vorsicht: Hier wird keine neue Verbindung hergestellt, sondern eine bereits bestehende
//           wieder neu verbunden.
function TFilefunction.ConnectDrive(_drvLetter, _netPath: string; _showError,
  _reconnect: Boolean): DWORD;
var
  nRes: TNetResource;
  errCode: DWORD;
  dwFlags: DWORD;
begin
  { NetRessource mit #0 füllen => Keine unitialisierte Werte }
  FillChar(NRes, SizeOf(NRes), #0);
  nRes.dwType := RESOURCETYPE_DISK;
  { Laufwerkbuchstabe und Netzwerkpfad setzen }
  nRes.lpLocalName  := PChar(_drvLetter);
  nRes.lpRemoteName := PChar(_netPath); { Beispiel: \\Test\C }
  { Überprüfung, ob gespeichert werden soll }
  if _reconnect then
    dwFlags := CONNECT_UPDATE_PROFILE and CONNECT_INTERACTIVE
  else
    dwFlags := CONNECT_INTERACTIVE;

  //errCode := WNetAddConnection3(Form1.Handle, nRes, nil, nil, dwFlags);
  errCode := WNetAddConnection3(0, nRes, nil, nil, dwFlags);
  { Fehlernachricht aneigen }
  if (errCode <> NO_ERROR) and (_showError) then
  begin
    Application.MessageBox(PChar('An error occured while connecting:' + #13#10 +
      SysErrorMessage(GetLastError)),
      'Error while connecting!',
      MB_OK);
  end;
  Result := errCode; { NO_ERROR }
end;

end.
