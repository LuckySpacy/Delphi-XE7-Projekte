unit of_konf_seite;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  of_Base, c_Types, o_sysObj, obBusinessClasses, obServerClient, of_konf_base,
  contnrs, tbButton, IBDatabase, fr_Base, Menus, tbToolbar, tbrichviewEdit,
  o_Seite, o_Seiteverbinden;


type
  Tof_Konf_Seite = class(Tof_konf_Base, IObServerClient)
  private
    FTrans: TIBTransaction;
    FToolbar: TtbToolbar;
    Fbtn_Edit: TtbButton;
    Fbtn_Delete: TtbButton;
    Fbtn_Cancel: TtbButton;
    Fcbx_KopfzeileAusblenden: TCheckBox;
    FPnl_Top: TPanel;
    FSplitter: TSplitter;
    FEditor: TtbRichViewEdit;
    FEditor_Header: TtbRichViewEdit;
    FOwner: TForm;
    //FPW: String;
    //FBaumButtonEbene: Integer;
    FPWChanged: Boolean;
    FKonfList: TStringList;
    procedure Seite_Edit(Sender: TObject);
    procedure Seite_Delete(Sender: TObject);
    procedure Seite_Cancel(Sender: TObject);
    procedure Editor_Enter(Sender: TObject);
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure LadeSeite;
    procedure SpeichereSeite;
    //procedure Sperre_Seite;
    procedure KopfAusblendenClick(Sender: TObject);
    procedure RegisterNotify;
    procedure UnregisterNotify;
  protected
    procedure Save; override;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

implementation

{ Tof_Konf_Seite }

uses
  c_DBTypes, RvStyle, u_AllgFunc;

constructor Tof_Konf_Seite.Create(AOwner: TComponent; AMode: TModus);
//var
  //fi: TFontInfo;
  //pi: TParaInfo;
begin
  inherited Create(AOwner, AMode);
  FKonfList := TStringList.Create;
  FKonfList.Delimiter := ';';

  FOwner := TForm(AOwner);
  FTrans := TIBTransaction.Create(Self);
  FTrans.DefaultDatabase := SysObj.Database;
  FTrans.Name := 'of_SeiteInhalt';

  FToolbar := gettbToolbar('Toolbar');
  FToolbar.Visible := false;

  FEditor := gettbRichViewEdit('Editor');
  FEditor.ReadOnly := true;
  FEditor.OnEnter := Editor_Enter;

  FEditor_Header := gettbRichViewEdit('Editor_Header');
  FEditor_Header.ReadOnly := true;
  FEditor_Header.OnEnter := Editor_Enter;

  FEditor_Header.Style.TextStyles.Clear;
  FEditor_Header.Style.ParaStyles.Clear;

  {
  fi := FEditor_Header.Style.TextStyles.Add;
  fi.FontName := 'Comic Sans MS';
  fi.Size     := 20;
  fi.Style    := [fsBold];
  fi.Color    := clBlue;
  pi := FEditor_Header.Style.ParaStyles.Add;
  pi.SpaceBefore := 10;
  pi.Alignment := rvaCenter;
  }

  Fbtn_Edit := gettbButton('btn_Edit');
  Fbtn_Delete := gettbButton('btn_Delete');
  Fbtn_Cancel := gettbButton('btn_Cancel');

  Fcbx_KopfzeileAusblenden := getCheckbox('cbx_KopfzeileAusblenden');
  Fcbx_KopfzeileAusblenden.OnClick := KopfAusblendenClick;
  FPnl_Top := getPanel('pnl_Top');

  FSplitter := getSplitter('Splitter1');

  Fbtn_Edit.OnClick := Seite_Edit;
  Fbtn_Delete.OnClick := Seite_Delete;
  Fbtn_Cancel.OnClick := Seite_Cancel;
  Fbtn_Delete.Visible := false;
  FBtn_Cancel.Visible := false;

  Fbtn_Edit.BtnLabel.Caption := 'Bearbeiten';
  Fbtn_Delete.BtnLabel.Caption := 'Löschen';
  Fbtn_Cancel.BtnLabel.Caption := 'Abbrechen';

  Fbtn_Delete.Visible := false;

  RegisterNotify;

  FPWChanged := false;

  LadeSeite;

end;

procedure Tof_Konf_Seite.RegisterNotify;
begin
  SysObj.ObServer.RegisterNotifications(Self, [ntobBearb, ntobCoreData]);
end;



destructor Tof_Konf_Seite.Destroy;
begin
  FreeAndNil(FKonfList);
  FreeAndNil(FTrans);
  UnregisterNotify;
  inherited;
end;

procedure Tof_Konf_Seite.UnregisterNotify;
begin
  if SysObj <> nil then
    SysObj.ObServer.UnregisterNotifications(Self);
end;


procedure Tof_Konf_Seite.Editor_Enter(Sender: TObject);
begin
  FToolbar.RichviewEdit := TtbRichviewEdit(Sender);
end;

procedure Tof_Konf_Seite.KopfAusblendenClick(Sender: TObject);
begin
  if Fcbx_KopfzeileAusblenden.Checked then
  begin
    FEditor_Header.Visible := false;
  end
  else
  begin
    FEditor_Header.Visible := true;
  end;
  FToolbar.Top := FPnl_Top.Top + FPnl_Top.Height;
  FSplitter.Visible := not Fcbx_KopfzeileAusblenden.Checked;
  FSplitter.Top := FEditor_Header.Top + FEditor_Header.Height;
end;

procedure Tof_Konf_Seite.LadeSeite;
var
  fi: TFontInfo;
  pi: TParaInfo;
  Ro: Boolean;
begin
  FEditor_Header.Style.TextStyles.Clear;
  FEditor_Header.Style.ParaStyles.Clear;
  FEditor.Style.TextStyles.Clear;
  FEditor.Style.ParaStyles.Clear;
  fi := FEditor_Header.Style.TextStyles.Add;

  if SysObj.Einstellung.KonfSeite.AsBlob = '' then
  begin
    fi.FontName := 'VERDANA';
    fi.Size     := 20;
    fi.Style    := [fsBold];
    fi.Color    := clBlack;
    pi := FEditor_Header.Style.ParaStyles.Add;
    pi.Alignment := rvaCenter;
    exit;
  end;
  FKonfList.DelimitedText := SysObj.Einstellung.KonfSeite.AsBlob;
  FEditor_Header.AsRTFString := FKonfList.Values['HEADERTEXT'];
  fi.FontName := FKonfList.Values['HEADERFONTNAME'];
  fi.Size     := tbStrToInt(FKonfList.Values['HEADERSIZE'], 20);
  fi.Style := tbStrToFontStyles(FKonfList.Values['HEADERFONTSTYLES']);
  fi.Color := StringToColor(FKonfList.Values['HEADERFONTCOLOR']);

  pi := FEditor_Header.Style.ParaStyles.Add;
  //pi.SpaceBefore := 10;
  pi.Alignment := tbStrToRvAlignment(FKonfList.Values['HEADERFONTALIGNMENT']);

  FEditor_Header.ClearAndFormated;
  Ro := FEditor_Header.ReadOnly;
  FEditor_Header.ReadOnly := false;
  FEditor_Header.Add(FKonfList.Values['HEADERTEXT'], 0);
  FEditor_Header.Format;
  FEditor_Header.ReadOnly := Ro;

  fi := FEditor.Style.TextStyles.Add;
  fi.FontName := FKonfList.Values['BODYFONTNAME'];
  fi.Size     := tbStrToInt(FKonfList.Values['BODYSIZE'], 20);
  fi.Style := tbStrToFontStyles(FKonfList.Values['BODYFONTSTYLES']);
  fi.Color := StringToColor(FKonfList.Values['BODYFONTCOLOR']);

  pi := FEditor.Style.ParaStyles.Add;
  //pi.SpaceBefore := 10;
  pi.Alignment := tbStrToRvAlignment(FKonfList.Values['BODYFONTALIGNMENT']);


  FEditor.ClearAndFormated;
  Ro := FEditor.ReadOnly;
  FEditor.ReadOnly := false;
  FEditor.Add(FKonfList.Values['BODYTEXT'], 0);
  FEditor.Format;
  FEditor.ReadOnly := Ro;

  FEditor_Header.Height := tbStrToInt(FKonfList.Values['HEADERHEIGHT'], 40);

  Fcbx_KopfzeileAusblenden.Checked := FKonfList.Values['KOPFAUSBLENDEN'] = 'T';
  FSplitter.Visible := not Fcbx_KopfzeileAusblenden.Checked;
  FToolbar.Top := FPnl_Top.Top + FPnl_Top.Height;
  FSplitter.Top := FEditor_Header.Top + FEditor_Header.Height;
  Fcbx_KopfzeileAusblenden.Visible := false;


end;

procedure Tof_Konf_Seite.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin

end;



procedure Tof_Konf_Seite.Save;
var
  s: string;
  fi: TFontInfo;
  pi: TParaInfo;
  sFontStyle: string;
begin
  inherited;
  FToolbar.RichviewEdit := FEditor_Header;
  FEditor_Header.SelectAll;
  fi := FEditor_Header.Style.TextStyles[FEditor_Header.CurItemStyle];
  pi := FEditor_Header.Style.ParaStyles[FEditor_Header.CurParaStyleNo];

  sFontStyle := tbsetFontStylesToStr(fi.Style);

  s := 'HEADERFONTNAME=' + FToolbar.Fontname + ';';
  s := s + 'HEADERSIZE=' + IntToStr(FToolbar.Fontsize)+ ';';
  s := s + 'HEADERFONTSTYLES=' + sFontStyle+ ';';
  s := s + 'HEADERFONTCOLOR=' + ColorToString(fi.Color)+ ';';
  s := s + 'HEADERHEIGHT=' + IntToStr(FEditor_Header.Height)+ ';';
  s := s + 'HEADERTEXT=' + StringReplace(FEditor_Header.AsString, ';', '', [rfReplaceAll]) + ';';

  s := s + 'HEADERFONTALIGNMENT=' + tbRvAlignmentToStr(pi.Alignment) + ';';

  FToolbar.RichviewEdit := FEditor;
  FEditor.SelectAll;
  fi := FEditor.Style.TextStyles[FEditor.CurItemStyle];
  pi := FEditor.Style.ParaStyles[FEditor.CurParaStyleNo];

  sFontStyle := tbsetFontStylesToStr(fi.Style);

  s := s + 'BODYFONTNAME=' + FToolbar.Fontname + ';';
  s := s + 'BODYSIZE=' + IntToStr(FToolbar.Fontsize)+ ';';
  s := s + 'BODYFONTSTYLES=' + sFontStyle+ ';';
  s := s + 'BODYFONTCOLOR=' + ColorToString(fi.Color)+ ';';
  s := s + 'BODYTEXT=' + StringReplace(FEditor.AsString, ';', '', [rfReplaceAll]) + ';';
  s := s + 'BODYFONTALIGNMENT=' + tbRvAlignmentToStr(pi.Alignment) + ';';
  s := s + 'KOPFAUSBLENDEN=' + tbBoolToStr(Fcbx_KopfzeileAusblenden.Checked) + ';';
  SysObj.Einstellung.KonfSeite.AsBlob := s;
  SysObj.Einstellung.KonfSeite.AsBlob2 := FEditor_Header.AsRTFString;
  SysObj.Einstellung.KonfSeite.AsBlob3 := FEditor.AsRTFString;

end;


procedure Tof_Konf_Seite.Seite_Cancel(Sender: TObject);
begin
  FToolbar.Visible := false;
  Fbtn_Edit.Tag := 0;
  Fbtn_Edit.BtnLabel.Caption := 'Bearbeiten';
  Fbtn_Delete.Visible := false;
  FBtn_Cancel.Visible := false;
  FEditor.ReadOnly := true;
  FEditor_Header.ReadOnly := true;
end;

procedure Tof_Konf_Seite.Seite_Delete(Sender: TObject);
begin

end;

procedure Tof_Konf_Seite.Seite_Edit(Sender: TObject);
begin
  if Fbtn_Edit.Tag = 0 then
  begin
    Fbtn_Edit.Tag := 1;
    Fbtn_Edit.BtnLabel.Caption := 'Speichern';
    Fbtn_Delete.Visible := false;
    Fbtn_Cancel.Visible := true;
    FToolbar.Visible := true;
    FEditor.ReadOnly := false;
    FEditor_Header.ReadOnly := false;
    Fcbx_KopfzeileAusblenden.Visible := true;
  end
  else
  begin
    FToolbar.Visible := false;
    Fbtn_Edit.Tag := 0;
    Fbtn_Edit.BtnLabel.Caption := 'Bearbeiten';
    Fbtn_Cancel.Visible := false;
    FEditor.ReadOnly := true;
    FEditor_Header.ReadOnly := true;
    Fcbx_KopfzeileAusblenden.Visible := false;
    SpeichereSeite;
  end;
end;

procedure Tof_Konf_Seite.SpeichereSeite;
begin
  Save;
end;

{
procedure Tof_Konf_Seite.Sperre_Seite;
begin

end;
}

end.
