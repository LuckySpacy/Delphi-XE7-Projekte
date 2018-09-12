unit o_fileicons;

interface


uses
  SysUtils, Classes, Graphics, Contnrs, o_fileicon, Winapi.Windows, Vcl.ImgList, vcl.comCtrls,
  vcl.Controls;

type
  TtbFileIcons = class(TComponent)
  private
    _IconList: TObjectList;
    _Mail: Graphics.TIcon;
    _ImgList: TImageList;
    function GetFileIcon(aExtended: string): TtbFileIcon;
    //procedure LoadIconFromRes(aResType, aResName: string; aIcon: Graphics.TIcon);
  protected
  public
    destructor Destroy; override;
    constructor Create(aOwner: TComponent); override;
    function FileIcon(aExtended: string): TtbFileIcon;
    function CreateFileIcon(const aFileName: string; const aSmallImage: Boolean = true; const aFileMustExist: Boolean = false): TtbFileIcon;
    property ImgList: TImageList read _ImgList write _ImgList;
  end;


implementation

{ TFileIcons }

uses
  ShellAPI;

constructor TtbFileIcons.Create(aOwner: TComponent);
begin
  inherited;
  _IconList := TObjectList.Create;
  _Mail := Graphics.TIcon.Create;
  _ImgList := TImageList.Create(nil);
  //LoadIconFromRes('RT_RCDATA', 'Mail', _Mail);
end;

destructor TtbFileIcons.Destroy;
begin
  FreeAndNil(_IconList);
  FreeAndNil(_Mail);
  FreeAndNil(_ImgList);
  inherited;
end;

function TtbFileIcons.GetFileIcon(aExtended: string): TtbFileIcon;
var
  i1: Integer;
  FileIcon: TtbFileIcon;
begin
  Result := nil;
  for i1 := 0 to _IconList.Count -1 do
  begin
    FileIcon := TtbFileIcon(_IconList.Items[i1]);
    if SameText(aExtended, FileIcon.Extended) then
    begin
      Result := FileIcon;
    end;
  end;
end;

{
procedure TtbFileIcons.LoadIconFromRes(aResType, aResName: string;
  aIcon: Graphics.TIcon);
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, aResname, PChar(aResType));
  try
    aIcon.LoadFromStream(Res);
  finally
    FreeAndNil(Res);
  end;
end;
}

function TtbFileIcons.FileIcon(aExtended: string): TtbFileIcon;
begin
  Result := GetFileIcon(aExtended);
  if Result <> nil then
    exit;

  //[@tb 30.07.2014] das Mail-Icon wurde fest einprogrammiert, da nicht jeder Outlook auf seinem PC installiert hat.
  // Siehe Ticket T-09128 A-11526
  if SameText(aExtended, '.mail') then
  begin
    Result := TtbFileIcon.Create;
    Result.Extended := aExtended;
    Result.Icon.ReleaseHandle;
    Result.Icon.Handle := _Mail.Handle;
   _IconList.Add(Result);
    Result.Tag := _IconList.Count -1;
    exit;
  end;

  Result := CreateFileIcon(aExtended);
  if Result = nil then
    exit;
  Result.Extended := aExtended;
  _IconList.Add(Result);
  Result.Tag := _IconList.Count -1;
  ImgList.AddIcon(Result.Icon);
end;


function TtbFileIcons.CreateFileIcon(const aFileName: string; const aSmallImage: Boolean = true; const aFileMustExist: Boolean = false): TtbFileIcon;
var
  FI: TSHFileInfo;
  Attributes: DWORD;
  Flags: Word;
begin
  Result := nil;
  if aFileMustExist then
  begin
    Attributes := 0;
    if aSmallImage then
      Flags := SHGFI_ICON or SHGFI_SMALLICON
    else
      Flags := SHGFI_ICON or SHGFI_LARGEICON;
  end
  else
  begin
    Attributes := FILE_ATTRIBUTE_NORMAL;
    if aSmallImage then
      Flags := SHGFI_USEFILEATTRIBUTES or SHGFI_ICON or SHGFI_SMALLICON
    else
      Flags := SHGFI_USEFILEATTRIBUTES or SHGFI_ICON or SHGFI_LARGEICON;
  end;

  if SHGetFileInfo(PChar(aFileName), Attributes, FI, SizeOf(FI), Flags) <> 0 then
  begin
    Result := TtbFileIcon.Create;
    Result.Icon.ReleaseHandle;
    Result.Icon.Handle := FI.hIcon;
  end;

end;


end.
