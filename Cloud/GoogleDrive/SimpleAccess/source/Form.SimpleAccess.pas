unit Form.SimpleAccess;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  CloudBase, CloudBaseWin, CloudCustomGDrive, CloudGDrive, CloudTreeViewAdapter,
  Vcl.ImgList;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btn_Connect: TButton;
    TreeView1: TTreeView;
    AdvGDrive: TAdvGDrive;
    CloudTreeViewAdapter: TCloudTreeViewAdapter;
    ImageList1: TImageList;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    FileName: TLabel;
    Created: TLabel;
    Size: TLabel;
    CreateFolderBtn: TButton;
    DeleteBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_ConnectClick(Sender: TObject);
    procedure AdvGDriveConnected(Sender: TObject);
    procedure AdvGDriveAuthFormClose(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure CreateFolderBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
  private
    FClientId: string;
    FClientKey: string;
    FAuthenticated: Boolean;
    procedure DoConnect;
    procedure DoDisconnect;
    procedure ShowItem;
    function GetFullFolders(aci: TCloudItem): string;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  CloudCustomBoxNet;


procedure TForm1.FormCreate(Sender: TObject);
begin   //
  FClientId  := '596384486949-qkmr6f3ig8kh360dmuvvsf41f8vvm9j7.apps.googleusercontent.com';
  FClientKey := '8XkVA6W9n3NVEhvHyypwFhaB';
  CloudTreeViewAdapter.TreeView := TreeView1;
  Treeview1.Images := ImageList1;
  //AdvGDrive.PersistTokens.Key := '.\GTOKENS.INI';
  AdvGDrive.PersistTokens.Key := 'c:\Users\Thomas\AppData\Local\Temp\GTokens.ini';
  AdvGDrive.PersistTokens.Section := 'TOKENS';
end;


procedure TForm1.AdvGDriveAuthFormClose(Sender: TObject);
begin
  if not FAuthenticated then
    DoDisconnect;
end;

procedure TForm1.AdvGDriveConnected(Sender: TObject);
var
  cs: TCloudStorage;
begin
  FAuthenticated := true;

  if (Sender is TCloudStorage) then
  begin
    cs := Sender as TCloudStorage;
    cs.SaveTokens;
  end;

  CloudTreeViewAdapter.CloudStorage := AdvGDrive;
  DoConnect;
end;

procedure TForm1.btn_ConnectClick(Sender: TObject);
begin
  AdvGDrive.App.Key := FClientId;
  AdvGDrive.App.Secret := FClientKey;
  AdvGDrive.Connect;
end;


procedure TForm1.DeleteBtnClick(Sender: TObject);
var
  ci: TCloudItem;
begin
  if Assigned(treeview1.Selected) then
  begin
    ci := TCloudItem(Treeview1.Selected.Data);

    if MessageDlg('Are you sure to delete item: ' + ci.FileName,mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      AdvGDrive.Delete(ci);
      ci.Free;
      TreeView1.Selected.Delete;
    end;
  end;
end;

procedure TForm1.DoConnect;
begin
  CreateFolderBtn.Enabled := true;
  DeleteBtn.Enabled := true;
  {
  ConnectBtn.Enabled := false;
  DisconnectBtn.Enabled := true;
  UploadBtn.Enabled := true;
  RadioGroup1.Enabled := false;
  }
end;


procedure TForm1.DoDisconnect;
begin
  AdvGDrive.Disconnect;
  CreateFolderBtn.Enabled := false;
  DeleteBtn.Enabled := false;
{
  if clrAccess.Checked then
    Storage.ClearTokens;

  Storage.Disconnect;

  Authenticated := false;
  ConnectBtn.Enabled := true;
  DisconnectBtn.Enabled := false;
  UploadBtn.Enabled := false;
  DownloadBtn.Enabled := false;
  RadioGroup1.Enabled := true;
  Size.Caption := '';
  Created.Caption := '';
  FileName.Caption := '';
  }
end;

procedure TForm1.ShowItem;
var
  ci: TCloudItem;
begin

  if Assigned(TreeView1.Selected) then
  begin
    ci := TCloudItem(TreeView1.Selected.Data);
    if (ci is TBoxNetItem) then
      (ci as TBoxNetItem).LoadFileInfo;

    //FileName.Caption := ci.FileName;
    FileName.Caption := GetFullFolders(ci);

    if ci.CreationDate <> 0 then
      Created.Caption := FormatDateTime(FormatSettings.ShortDateFormat + ' ' + FormatSettings.ShortTimeFormat,ci.CreationDate)
    else
      Created.Caption := FormatDateTime(FormatSettings.ShortDateFormat + ' ' + FormatSettings.ShortTimeFormat,ci.ModifiedDate);

    Size.Caption := IntToStr(ci.Size);

    //DownloadBtn.Enabled := ci.ItemType = ciFile;
  end;

end;



function TForm1.GetFullFolders(aci: TCloudItem): string;
var
  ci: TCloudItem;
begin
  ci     := aci;
  while ci <> nil do
  begin
    Result := ci.FileName + '\' + Result;
    ci := ci.ParentFolder;
  end;
end;




procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  Screen.Cursor := crHourGlass;
  ShowItem;
  Screen.Cursor := crDefault;
end;


procedure TForm1.CreateFolderBtnClick(Sender: TObject);
var
  ci, cif: TCloudItem;
  FolderName: string;

begin
  FolderName := '';

  if InputQuery('Name','Name for new folder',FolderName) and (FolderName <> '') then
  begin
    ci := nil;

    if Assigned(TreeView1.Selected) then
    begin
      ci := TCloudItem(TreeView1.Selected.Data);
      if ci.ItemType <> ciFolder then
        ci := nil;
    end;

    AdvGDrive.CreateFolder(ci,FolderName);
    CloudTreeViewAdapter.InitTreeView;
  end;
end;

{
procedure TForm1.CreateFolderTest;
var
  cis: TCloudItems;
  i1: Integer;
  s: string;
begin
  s := '';
  cis := AdvGDrive.GetFolderList(nil);
  for i1 := 0 to cis.Count -1 do
  begin
    cis.Folder.Folder
  end;
end;
}


end.
