unit o_GoogleDrive;

interface

uses
  SysUtils, Classes, CloudGDrive, CloudTreeViewAdapter, CloudBase, Contnrs,
  Vcl.ComCtrls;

type
  TGoogleDrive = class(TComponent)
  private
    FGDrive: TAdvGDrive;
    FClient: string;
    FClientKey: string;
    FTokenIni: string;
    FAuthenticated: Boolean;
    FCloudTreeViewAdapter: TCloudTreeViewAdapter;
    FProgressbar: TProgressbar;
    FConnected: Boolean;
    procedure setClientId(const Value: string);
    procedure setClientKey(const Value: string);
    procedure setTokenIni(const Value: string);
    procedure AdvGDriveConnected(Sender: TObject);
    procedure AdvGDriveAuthFormClose(Sender: TObject);
    procedure DoDisconnect;
    procedure UploadProgress(Sender: TObject; FileName: string; Position, Total: Int64);
    procedure DownloadProgress(Sender: TObject; FileName: string; Position, Total: Int64);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ClientId: string read FClient write setClientId;
    property ClientKey: string read FClientKey write setClientKey;
    property TokenIni: string read FTokenIni write setTokenIni;
    property GDrive: TAdvGDrive read FGDrive write FGDrive;
    function Connect: Boolean;
    function GetFolder(aValue: string): TCloudItem;
    function FolderExist(aValue: string): Boolean;
    //function FileExists(aFullFilename: string): TCloudItem;
    procedure GetCloudItemsFromFolder(aFolder: string; aCloudItemList: TObjectList);
    function UploadFile(aCloudItem: TCloudItem; aFilename: string): Boolean; overload;
    function UploadFile(SourceFullFilename, aDestFolder: string): Boolean; overload;
    function DownloadFile(aSourceFullFilename, aDestFullFilename: string): Boolean;
    function DeleteFile(aFullFilename: string): Boolean;
    function GetFileItem(aFullFilename: string): TCloudItem;
    procedure ForceDirectories(aValue: string);
    property Progressbar: TProgressbar read FProgressbar write FProgressbar;
    property Connected: Boolean read FConnected;
  end;


implementation

{ TGoogleDrive }



constructor TGoogleDrive.Create(AOwner: TComponent);
begin
  inherited;
  FGDrive := TAdvGDrive.Create(AOwner);
  FCloudTreeViewAdapter := nil;
  FGDrive.OnConnected := AdvGDriveConnected;
  FGDrive.OnAuthFormClose  := AdvGDriveAuthFormClose;
  FGDrive.OnUploadProgress := UploadProgress;
  FGDrive.OnDownloadProgress := DownloadProgress;
  FProgressbar := nil;
end;

destructor TGoogleDrive.Destroy;
begin
  FreeAndNil(FGDrive);
  inherited;
end;

procedure TGoogleDrive.setClientId(const Value: string);
begin
  FClient := Value;
  FGDrive.App.Key := Value;
end;

procedure TGoogleDrive.setClientKey(const Value: string);
begin
  FClientKey := Value;
  FGDrive.App.Secret := Value;
end;

procedure TGoogleDrive.setTokenIni(const Value: string);
begin
  FTokenIni := Value;
  FGDrive.PersistTokens.Key := Value;
  FGDrive.PersistTokens.Section := 'TOKENS';
end;


procedure TGoogleDrive.AdvGDriveConnected(Sender: TObject);
var
  cs: TCloudStorage;
begin
  FAuthenticated := true;

  if (Sender is TCloudStorage) then
  begin
    cs := Sender as TCloudStorage;
    cs.SaveTokens;
  end;

  if FCloudTreeViewAdapter <> nil then
    FCloudTreeViewAdapter.CloudStorage := FGDrive;
end;

procedure TGoogleDrive.AdvGDriveAuthFormClose(Sender: TObject);
begin
  if not FAuthenticated then
    DoDisconnect;
end;

procedure TGoogleDrive.DoDisconnect;
begin
  FGDrive.Disconnect;
  FConnected := False;
end;



function TGoogleDrive.Connect: Boolean;
begin
  Result := FGDrive.Connect;
  if (not Result) and (FAuthenticated)  then
  begin
    Result := true;
    FConnected := true;
  end;
end;



function TGoogleDrive.GetFolder(aValue: string): TCloudItem;
var
  sList: TStringList;
  FolderItems: TCloudItems;
  FolderItem: TCloudItem;
  i1,i2: Integer;
  Gefunden: Boolean;
begin
  Result := nil;
  if not FConnected then
    connect;

  if aValue = '' then
    exit;
  if aValue[Length(aValue)] = '\' then
    aValue := copy(aValue, 1, Length(aValue)-1);
  if aValue = '' then
    exit;
  FolderItems := FGDrive.GetFolderList(nil);
  if FolderItems = nil then
    exit;
  sList := TStringList.Create;
  try
    sList.StrictDelimiter := true;
    sList.Delimiter := '\';
    sList.DelimitedText := aValue;
    for i1 := 0 to sList.Count -1 do
    begin
      Gefunden := false;
      if FolderItems = nil then
        exit;
      for i2 := 0 to FolderItems.Count -1 do
      begin
        if FolderItems.Items[i2].ItemType <> ciFolder then
          continue;
        if SameText(sList.Strings[i1], FolderItems.Items[i2].FileName) then
        begin
          FolderItem  := FolderItems.Items[i2];
          if FolderItem.ID < 0 then
            exit;
          //if FolderItems <> nil then
          //  FreeAndNil(FolderItems);
          FolderItems := FGDrive.GetFolderListHierarchical(FolderItem);
          Gefunden := true;
          break;
        end;
      end;
      if not Gefunden then
        exit;
    end;
    Result := FolderItem;
  finally
    FreeAndNil(sList);
  end;
end;
                                {
function TGoogleDrive.FileExists(aFullFilename: string): TCloudItem;
var
  Pfad: string;
  FileName: string;
  iPos: Integer;
  ct: TCloudItem;
  FolderItems: TCloudItems;
  i1: Integer;
begin
  Result := nil;
  iPos := LastDelimiter('\', aFullFilename);
  if iPos <= 0 then
    exit;
  Pfad := copy(aFullFilename, 1, iPos);
  FileName := copy(aFullFilename, iPos+1, Length(aFullFilename));
  ct := GetFolder(Pfad);
  if ct = nil then
    exit;
  FolderItems := FGDrive.GetFolderListHierarchical(ct);
  for i1 := 0 to FolderItems.Count -1 do
  begin
    if SameText(FolderItems.Items[i1].FileName, FileName) then
    begin
      Result := FolderItems.Items[i1];
      exit;
    end;
  end;
end;                             }

function TGoogleDrive.FolderExist(aValue: string): Boolean;
begin
  Result := GetFolder(aValue) <> nil;
end;


procedure TGoogleDrive.GetCloudItemsFromFolder(aFolder: string;
  aCloudItemList: TObjectList);
var
  i1, i2: Integer;
  sList: TStringList;
  FolderItems: TCloudItems;
  Gefunden: Boolean;
  FolderItem: TCloudItem;
begin
  if aFolder = '' then
    exit;
  if aFolder[Length(aFolder)] = '\' then
    aFolder := copy(aFolder, 1, Length(aFolder)-1);
  if aFolder = '' then
    exit;
  FolderItems := FGDrive.GetFolderList(nil);
  if FolderItems = nil then
    exit;
  aCloudItemList.Clear;
  sList := TStringList.Create;
  try
    sList.StrictDelimiter := true;
    sList.Delimiter := '\';
    sList.DelimitedText := aFolder;
    for i1 := 0 to sList.Count -1 do
    begin
      Gefunden := false;
      if FolderItems = nil then
        exit;
      for i2 := 0 to FolderItems.Count -1 do
      begin
        if FolderItems.Items[i2].ItemType <> ciFolder then
          continue;
        if SameText(sList.Strings[i1], FolderItems.Items[i2].FileName) then
        begin
          FolderItem  := FolderItems.Items[i2];
          if FolderItem.ID < 0 then
            exit;
          aCloudItemList.Add(FolderItem);
          FolderItems := FGDrive.GetFolderListHierarchical(FolderItem);
          Gefunden := true;
          break;
        end;
      end;
      if not Gefunden then
        exit;
    end;
  finally
    FreeAndNil(sList);
  end;
end;

procedure TGoogleDrive.ForceDirectories(aValue: string);
var
  sList: TStringList;
  i1: Integer;
  FolderItem: TCloudItem;
  FolderParentItem: TCloudItem;
  CloudItemList: TObjectList;
  Path: string;
begin //
  if aValue = '' then
    exit;
  if aValue[Length(aValue)] = '\' then
    aValue := copy(aValue, 1, Length(aValue)-1);
  if aValue = '' then
    exit;
  CloudItemList := TObjectList.Create;
  sList := TStringList.Create;
  try
    GetCloudItemsFromFolder(aValue, CloudItemList);
    FolderParentItem := nil;
    sList.StrictDelimiter := true;
    sList.Delimiter := '\';
    sList.DelimitedText := aValue;
    for i1 := 0 to sList.Count -1 do
    begin
      if i1 > CloudItemList.Count -1 then
      begin
        FolderItem := nil;
        if CloudItemList.Count > 0 then
          FolderItem := TCloudItem(CloudItemList[i1-1]);
        FolderItem := FGDrive.CreateFolder(FolderItem, sList.Strings[i1]);
        CloudItemList.Add(FolderItem);
      end;
    end;
  finally
    FreeAndNil(sList);
    FreeAndNil(CloudItemList);
  end;
end;


function TGoogleDrive.UploadFile(aCloudItem: TCloudItem;
  aFilename: string): Boolean;
begin
  Result := false;
  if not FileExists(aFilename) then
    exit;
  if aCloudItem = nil then
    exit;
  FGDrive.Upload(aCloudItem, aFilename);
  Result := true;
end;


function TGoogleDrive.UploadFile(SourceFullFilename, aDestFolder: string): Boolean;
var
  FolderItem: TCloudItem;
begin
  if FProgressbar <> nil then
    ProgressBar.Position := 0;
  Result := false;
  if not FileExists(SourceFullFilename) then
    exit;
  FolderItem := GetFolder(aDestFolder);
  if FolderItem = nil then
  begin
    ForceDirectories(aDestFolder);
    FolderItem := GetFolder(aDestFolder);
  end;
  if Folderitem = nil then
    exit;
  UploadFile(FolderItem, SourceFullFilename);
end;


function TGoogleDrive.GetFileItem(aFullFilename: string): TCloudItem;
var
  Path: string;
  Filename: string;
  Folder: TCloudItem;
  FolderItems : TCloudItems;
  i1: Integer;
begin
  Result := nil;
  if not FConnected then
    connect;
  Path := ExtractFilePath(aFullFilename);
  Filename := ExtractFileName(aFullFilename);
  if (Path = '') or (Filename = '') then
    exit;
  Folder := GetFolder(Path);
  if Folder = nil then
    exit;
  FolderItems := FGDrive.GetFolderListHierarchical(Folder);
  if FolderItems = nil then
    exit;
  for i1 := 0 to FolderItems.Count -1 do
  begin
    if SameText(FolderItems.Items[i1].FileName, Filename) then
    begin
      Result := FolderItems.Items[i1];
      exit;
    end;
  end;
end;


function TGoogleDrive.DeleteFile(aFullFilename: string): Boolean;
var
  FolderItem: TCloudItem;
begin
  Result := false;
  FolderItem := GetFileItem(aFullFilename);
  if FolderItem = nil then
    exit;
  FGDrive.Delete(FolderItem);
  Result := true;
end;

procedure TGoogleDrive.UploadProgress(Sender: TObject; FileName: string;
  Position, Total: Int64);
begin
  if FProgressbar = nil then
    exit;
  Progressbar.Position := Position;
  ProgressBar.Max := Total;
end;

function TGoogleDrive.DownloadFile(aSourceFullFilename, aDestFullFilename: string): Boolean;
var
  DestPath: string;
  FolderItem: TCloudItem;
begin
  Result := false;
  if (aSourceFullFilename = '') or (aDestFullFilename = '') then
    exit;
  DestPath := ExtractFilePath(aDestFullFilename);
  if not DirectoryExists(DestPath) then
    exit;

  if not FConnected then
    connect;

  FolderItem := GetFileItem(aSourceFullFilename);
  if FolderItem = nil then
    exit;

  if FileExists(aDestFullFilename) then
    DeleteFile(aDestFullFilename);

  try
    FGDrive.Download(FolderItem, aDestFullFilename);
  except
  end;
  Result := true;
end;

procedure TGoogleDrive.DownloadProgress(Sender: TObject; FileName: string;
  Position, Total: Int64);
begin //
  if FProgressbar = nil then
    exit;
  Progressbar.Position := Position;
  ProgressBar.Max := Total;
end;


end.
