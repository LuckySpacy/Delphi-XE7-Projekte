unit of_Bilder;

interface

uses
  SysUtils, Classes, Forms, StdCtrls, Buttons, of_Base, c_Types,
  ExtCtrls, Dialogs, o_sysObj, Controls, obBusinessClasses, obServerClient,
  tbButton, IBDatabase, tbStringGrid, o_Bilder, o_BilderList, ExtDlgs,
  Graphics, pngimage;

type
  Tof_Bilder = class(Tof_Base, IObServerClient)
  private
    FGrid: TtbStringGrid;
    Fbtn_Add: TTBButton;
    FBtn_Del: TTBButton;
    FOpenDialog: TOpenPictureDialog;
    FImage: TImage;
    FBilder: TBilder;
    FBilderList : TBilderList;
    FOwner: TForm;
    FBildId: Integer;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure AddClick(Sender: TObject);
    procedure DelClick(Sender: TObject);
    procedure OkClick(Sender: TObject);
    procedure OnGetBitmap(Sender: TObject; aCol, ARow: Integer; var aBitmap: Graphics.TBitmap);
    procedure OnGetIcon(Sender: TObject; aCol, ARow: Integer; var aIcon: Graphics.TIcon);
    procedure OnGetPng(Sender: TObject; aCol, aRow: Integer; var aPng: TPngImage);
    procedure GridCellDblClick(Sender: TObject; ACol, ARow: Integer);
  protected
    procedure Load(aObjectId: Integer);
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    property BildId: Integer read FBildId write FBildId;
  end;


implementation

{ Tof_OrdnerProp }

uses
  c_DBTypes, types;


constructor Tof_Bilder.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FOwner   := TForm(AOwner);
  FGrid    := gettbStringGrid('Grid');
  Fbtn_Add := gettbbutton('btn_Add');
  Fbtn_Del := gettbbutton('btn_Del');
  FImage   := getImage('Image');
  Fbtn_Add.OnClick := AddClick;
  Fbtn_Del.OnClick := DelClick;
  Fbtn_Ok.OnClick  := OkClick;
  FBilder := TBilder.Create(Self);
  FBilderList := TBilderList.Create(Self);
  FGrid.ColCount := 8;
  FGrid.OnGetBitmap := OnGetBitmap;
  FGrid.onGetIcon   := OnGetIcon;
  FGrid.OnGetPng    := OnGetPng;
  FGrid.OnCellDblClick := GridCellDblClick;
  FBildId := -1;
  //FGrid.Constraints.MaxWidth := FGrid.Width;
  //FGrid.Constraints.MinWidth := FGrid.Width;
      //SysObj.Msg.Msg(Self, '{08F47461-789F-4353-A38E-EFD95CD8ACB2}', mtInformation, [mbOk]);

   //C:\Program Files (x86)\Common Files\CodeGear Shared\Images\GlyFX\Icons\XP\BMP\32x32


  Load(-1);
  //FImage.Picture.Bitmap.Assign(FBilderList.Item[0].Feld(BI_BILD).AsBitmap);

end;


destructor Tof_Bilder.Destroy;
begin
  FreeAndNil(FBilderList);
  FreeAndNil(FBilder);
  inherited;
end;


procedure Tof_Bilder.Load(aObjectId: Integer);
var
  i1: Integer;
  iRow: Integer;
  iCol: Integer;
  mRow: Integer;
  mCol: Integer;
begin
  FGrid.ClearAll;
  FBilderList.ReadAll;
  FGrid.RowCount := FBilderList.Count;
  FGrid.DefaultColWidth  := 64;
  FGrid.DefaultRowHeight := 64;

  mCol := -1;
  mRow := -1;
  iRow := 0;
  iCol := 0;
  for i1 := 0 to FBilderList.Count - 1 do
  begin
    if iCol >= FGrid.ColCount then
    begin
      iCol := 0;
      inc(iRow);
    end;
    FGrid.Objects[iCol,iRow] := FBilderList.Item[i1];
    if aObjectId > -1 then
    begin
      if FBilderList.Item[i1].Id = aObjectId then
      begin
        mRow := iRow;
        mCol := iCol;
      end;
    end;
    //FGrid.Objects[iCol,iRow] := FBilderList.Item[i1].Feld(BI_BILD).AsBitmap;
    inc(iCol);
  end;
  FGrid.RowCount := iRow + 1;
  if mCol > -1 then
  begin
    FGrid.Col := mCol;
    FGrid.Row := mRow;
  end;

end;

procedure Tof_Bilder.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin

end;


procedure Tof_Bilder.OnGetBitmap(Sender: TObject; aCol, ARow: Integer;
  var aBitmap: Graphics.TBitmap);
begin
  aBitmap := nil;
  if FGrid.Objects[aCol, aRow] is TBilder then
  begin
    if SameText(TBilder(FGrid.Objects[aCol, aRow]).Feld(BI_ERWEITERUNG).AsString, 'bmp') then
      aBitmap := TBilder(FGrid.Objects[aCol, aRow]).Feld(BI_BILD).Bmp.AsBitmap;
  end;
end;

procedure Tof_Bilder.OnGetIcon(Sender: TObject; aCol, ARow: Integer;
  var aIcon: Graphics.TIcon);
begin
  aIcon := nil;
  if FGrid.Objects[aCol, aRow] is TBilder then
  begin
    if SameText(TBilder(FGrid.Objects[aCol, aRow]).Feld(BI_ERWEITERUNG).AsString, 'ico') then
      aIcon := TBilder(FGrid.Objects[aCol, aRow]).Feld(BI_BILD).Ico.AsIcon;
  end;
end;

procedure Tof_Bilder.OnGetPng(Sender: TObject; aCol, aRow: Integer;
  var aPng: TPngImage);
begin
  aPng := nil;
  if FGrid.Objects[aCol, aRow] is TBilder then
  begin
    if SameText(TBilder(FGrid.Objects[aCol, aRow]).Feld(BI_ERWEITERUNG).AsString, 'png') then
      aPng := TBilder(FGrid.Objects[aCol, aRow]).Feld(BI_BILD).Png.AsPng;
  end;
end;

procedure Tof_Bilder.AddClick(Sender: TObject);
var
  Ext: string;
  //m: TMemoryStream;
 // Png: TPngImage;
 // r: TRect;
begin
  FOpenDialog := TOpenPictureDialog.Create(Self);
  try
    if FOpenDialog.Execute then
    begin
      FBilder.Init;
      Ext := ExtractFileExt(FOpenDialog.FileName);
      FBilder.Feld(BI_TYP).AsInteger := 1;
      FBilder.Feld(BI_ERWEITERUNG).AsString := 'ico';
      FBilder.Feld(BI_BILD).LoadImageFromFile(FOpenDialog.FileName);
      FBilder.Feld(BI_BILD).ConvertToIcon;
      FBilder.Save;
      Load(-1);
    end;
  finally
    FreeAndNil(FOpenDialog);
  end;

end;


procedure Tof_Bilder.DelClick(Sender: TObject);
  function GetNextId: Integer;
  var
    Row: Integer;
    Col: Integer;
  begin
    Result := -1;
    Col := FGrid.Col;
    Row := FGrid.Row;
    while (Col <= FGrid.ColCount -1) and (Row <= FGrid.RowCount -1) do
    begin
      inc(Col);
      if Col > FGrid.ColCount -1 then
      begin
        Col := 0;
        inc(Row);
      end;
      if Row > FGrid.RowCount -1 then
        break;
      if FGrid.Objects[Col, Row] is TBilder then
      begin
        Result := TBilder(FGrid.Objects[Col, Row]).Id;
        exit;
      end;
    end;
    Col := FGrid.Col;
    Row := FGrid.Row;
    while (Col >= 0) and (Row >= 0) do
    begin
      dec(Col);
      if Col < 0 then
      begin
        Col := FGrid.ColCount -1;
        dec(Row);
      end;
      if Row < 0 then
        break;
      if FGrid.Objects[Col, Row] is TBilder then
      begin
        Result := TBilder(FGrid.Objects[Col, Row]).Id;
        exit;
      end;
    end;
  end;
var
  Bilder: TBilder;
  Id: Integer;
begin
  if FGrid.Objects[FGrid.Col, FGrid.Row] is TBilder then
  begin
    if SysObj.Msg.Msg(Self, '{EF3F72B3-EEC3-49A8-A483-E0E51D0D1452}', mtConfirmation, [mbYes, mbNo], mbNO) = mrNo then
      exit;
    Bilder := TBilder(FGrid.Objects[FGrid.Col, FGrid.Row]);
    Bilder.Delete;
    Id := GetNextId;
    Load(Id);
  end;
end;


procedure Tof_Bilder.GridCellDblClick(Sender: TObject; ACol, ARow: Integer);
begin
  FBildId := -1;
  if FGrid.Objects[FGrid.Col, FGrid.Row] is TBilder then
    FBildId := TBilder(FGrid.Objects[FGrid.Col, FGrid.Row]).Id;
  FOwner.Close;
  SysObj.ObServer.Notify(ntObChangeItems, NTA_CLICK_BILD, FBildId);
end;


procedure Tof_Bilder.OkClick(Sender: TObject);
begin
  FBildId := -1;
  if FGrid.Objects[FGrid.Col, FGrid.Row] is TBilder then
    FBildId := TBilder(FGrid.Objects[FGrid.Col, FGrid.Row]).Id;
  FOwner.Close;
  SysObj.ObServer.Notify(ntObChangeItems, NTA_CLICK_BILD, FBildId);
end;



end.
