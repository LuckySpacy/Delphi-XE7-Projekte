unit of_SeiteInhalt;

interface

uses
  SysUtils, Classes, Forms, StdCtrls, Buttons, of_Base, c_Types,
  ExtCtrls, Dialogs, o_sysObj, Controls, obBusinessClasses, obServerClient,
  tbButton, Contnrs, IBDatabase, fr_Base, Menus, tbToolbar, tbrichviewEdit,
  o_Seite, o_Seiteverbinden, tbRvePopUp, o_xmlHighlighter;

type
  Tof_SeiteInhalt = class(Tof_Base, IObServerClient)
  private
    FTrans: TIBTransaction;
    FToolbar: TtbToolbar;
    Fbtn_Edit: TtbButton;
    Fbtn_Delete: TtbButton;
    Fbtn_Cancel: TtbButton;
    FEditor: TtbRichViewEdit;
    FEditor_Header: TtbRichViewEdit;
    fEditor_HeaderPanel: TPanel;
    Fcbx_KopfzeileAusblenden: TCheckBox;
    FPnl_Top: TPanel;
    FSplitter: TSplitter;
    FSeite: TSeite;
    FSeiteverbinden: TSeiteverbinden;
    FOwner: TForm;
    FPW: String;
    FBaumButtonEbene: Integer;
    FPWChanged: Boolean;
    FBodyText: string;
    FHeaderText: string;
    fPopUp: TtbRvePopUp;
    fHighlighter_Testen: TMenuItem ;
    fxmlHighlighter: TXMLHighlighter;
   procedure Seite_Edit(Sender: TObject);
    procedure Seite_Delete(Sender: TObject);
    procedure Seite_Cancel(Sender: TObject);
    procedure Editor_Enter(Sender: TObject);
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure LadeSeite;
    procedure SpeichereSeite;
    procedure Sperre_Seite;
    procedure KopfAusblendenClick(Sender: TObject);
    procedure FontFavoritenChanged(Sender: TObject; aFontFavList: TStrings);
    procedure RegisterNotify;
    procedure UnregisterNotify;
    procedure Highlighter_TestenClick(Sender: TObject);
    procedure Highlighter_SyntaxClick(Sender: TObject);
    procedure LadeSyntaxHighlighterMenuItems;
  protected
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    procedure VisibleChanged(aValue: Boolean); override;
  end;


implementation

{ Tof_SeiteInhalt }

uses
  c_DBTypes, RvStyle, Graphics, fnt_passwort, RVScroll, RichView, RVEdit, RVReport, RvGetText;


constructor Tof_SeiteInhalt.Create(AOwner: TComponent; AMode: TModus);
var
  fi: TFontInfo;
  pi: TParaInfo;
begin
  inherited Create(AOwner, AMode);
  FOwner := TForm(AOwner);
  FTrans := TIBTransaction.Create(Self);
  FTrans.DefaultDatabase := SysObj.Database;
  FTrans.Name := 'of_SeiteInhalt';

  FSeite := TSeite.Create(Self);
  FSeite.Trans := FTrans;

  FSeiteverbinden := TSeiteverbinden.Create(Self);
  FSeiteverbinden.Trans := FTrans;


  FToolbar := gettbToolbar('Toolbar');
  FToolbar.Visible := false;
  FToolbar.OnFontFavoritenChanged := FontFavoritenChanged;

  FEditor := gettbRichViewEdit('Editor');
  FEditor.ReadOnly := true;
  FEditor.OnEnter := Editor_Enter;

  FEditor_Header := gettbRichViewEdit('Editor_Header');
  FEditor_Header.ReadOnly := true;
  FEditor_Header.OnEnter := Editor_Enter;

  FEditor_Header.Style.TextStyles.Clear;
  FEditor_Header.Style.ParaStyles.Clear;

  fi := FEditor_Header.Style.TextStyles.Add;
  fi.FontName := 'Comic Sans MS';
  fi.Size     := 20;
  fi.Style    := [fsBold];
  fi.Color    := clBlue;

  pi := FEditor_Header.Style.ParaStyles.Add;
  pi.SpaceBefore := 10;
  pi.Alignment := rvaCenter;

  //fEditor_HeaderPanel := getPanel('pnl_EditorHeader');

  {
  FEditor_Header.ReadOnly := false;
  FEditor.AddNL('Header', 0, 0);
  FEditor_Header.InsertBreak(1, rvbsLine, clGreen);
  FEditor_Header.Format;
  FEditor_Header.ReadOnly := true;
  }


  Fbtn_Edit := gettbButton('btn_Edit');
  Fbtn_Delete := gettbButton('btn_Delete');
  Fbtn_Cancel := gettbButton('btn_Cancel');

  Fcbx_KopfzeileAusblenden := getCheckbox('cbx_KopfzeileAusblenden');
  Fcbx_KopfzeileAusblenden.OnClick := KopfAusblendenClick;
  FPnl_Top := getPanel('pnl_Top');

  FSplitter := getSplitter('Splitter1');

  fPopUp := gettbRvePopUp('tbRvePopUp1');
  fHighlighter_Testen := fPopUp.Items[5];
  fHighlighter_Testen := fHighlighter_Testen.Items[0];
  fHighlighter_Testen.OnClick := Highlighter_TestenClick;

  fxmlHighlighter := nil;
  LadeSyntaxHighlighterMenuItems;

  Fbtn_Edit.OnClick := Seite_Edit;
  Fbtn_Delete.OnClick := Seite_Delete;
  Fbtn_Cancel.OnClick := Seite_Cancel;
  Fbtn_Delete.Visible := false;
  FBtn_Cancel.Visible := false;

  Fbtn_Edit.BtnLabel.Caption := 'Bearbeiten';
  Fbtn_Delete.BtnLabel.Caption := 'Löschen';
  Fbtn_Cancel.BtnLabel.Caption := 'Abbrechen';

  if SysObj.Akt.Modus = cLink then
    Fbtn_Edit.Visible := false;

  RegisterNotify;


  FPWChanged := false;

end;

destructor Tof_SeiteInhalt.Destroy;
begin
  FreeAndNil(FTrans);
  FreeAndNil(FSeite);
  FreeAndNil(FSeiteverbinden);
  FreeAndNil(fxmlHighlighter);
  UnregisterNotify;
  inherited;
end;


procedure Tof_SeiteInhalt.RegisterNotify;
begin
  SysObj.ObServer.RegisterNotifications(Self, [ntobBearb, ntobCoreData]);
end;

procedure Tof_SeiteInhalt.UnregisterNotify;
begin
  if SysObj <> nil then
    sysObj.ObServer.UnregisterNotifications(Self);
end;


procedure Tof_SeiteInhalt.Editor_Enter(Sender: TObject);
begin
  FToolbar.RichviewEdit := TtbRichviewEdit(Sender);
end;


procedure Tof_SeiteInhalt.FontFavoritenChanged(Sender: TObject;
  aFontFavList: TStrings);
begin
  ShowMessage('Hurra Fontfavoriten wurden geändert');
end;

procedure Tof_SeiteInhalt.Highlighter_SyntaxClick(Sender: TObject);
var
  FontStyleName: string;
begin
  if FEditor.ReadOnly then
  begin
    ShowMessage('Editor ist nicht Bearbeitungsmodus');
    exit;
  end;

  if Sender is TMenuItem then
  begin
    FontStyleName := TMenuItem(Sender).Caption;
    FontStyleName := StringReplace(FontStyleName, '&', '', [rfReplaceAll]);
    fxmlHighlighter.StyleIt(FEditor, FontStyleName);
  end;
end;

procedure Tof_SeiteInhalt.LadeSyntaxHighlighterMenuItems;
var
  i1: Integer;
  List: TStringList;
  mi: TMenuItem;
begin
  try
    if fxmlHighlighter <> nil then
      FreeAndNil(fxmlHighlighter);
    fxmlHighlighter := TXMLHighlighter.Create(SysObj.SyntaxHighlighterFilename);
    List := TStringList.Create;
    try

      for i1 := fPopUp.Items[5].Count -1 downto 2 do
      begin
        mi := fPopUp.Items[5].Items[i1];
        FreeAndNil(mi);
      end;

      fxmlHighlighter.FontStyleNames(List);
      for i1 := 0 to List.Count -1 do
      begin
        mi := TMenuItem.Create(Self);
        mi.Caption := List.Strings[i1];
        mi.OnClick := Highlighter_SyntaxClick;
        fPopUp.Items[5].Add(mi);
      end;

    finally
      FreeAndNil(List);
    end;
  except
  end;

end;

procedure Tof_SeiteInhalt.Highlighter_TestenClick(Sender: TObject);
begin
  sysobj.ObServer.Notify(ntobForms, NTA_SHOW_HIGHLIGHTERCONFIG);
end;

procedure Tof_SeiteInhalt.KopfAusblendenClick(Sender: TObject);
begin
  if Fcbx_KopfzeileAusblenden.Checked then
  begin
    //fEditor_HeaderPanel.Visible := false;
    FEditor_Header.Visible := false;
  end
  else
  begin
    FEditor_Header.Visible := true;
    //fEditor_HeaderPanel.Visible := true;
  end;
  FToolbar.Top := FPnl_Top.Top + FPnl_Top.Height;
  FSplitter.Visible := not Fcbx_KopfzeileAusblenden.Checked;
  FSplitter.Top := FEditor_Header.Top + FEditor_Header.Height + 10;
end;

procedure Tof_SeiteInhalt.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
var
  Seite: TSeite;
begin
  if FMode <> sysobj.Akt.Modus then
    exit;
  if AType = ntobBearb then
  begin
    if (Action = NTA_BAUMEBENE_CHANGED) or (Action = NTA_BAUMZWEIG_CHANGED) then
    begin
      LadeSeite;
    end;
    if (Action = NTA_SEITE_SPERREN) then
    begin
      Sperre_Seite;
    end;
    if (Action = NTA_SEITE_SPEICHERN) then
    begin
      Seite := TSeite(Data);
      FPW := Seite.PW;
      FSeiteverbinden.Read(SysObj.Akt.BaumButtonEbene, SysObj.Akt.BaumZweigId);
      FPWChanged := true;
      SpeichereSeite;
      FPWChanged := false;
    end;
  end;
  if AType = ntobCoreData then
  begin
    if (Action = NTA_TABELLE_SEITE) and (FSeiteverbinden.Seite.Id = Data) then
    begin
      FSeiteverbinden.Read(SysObj.Akt.BaumButtonEbene, SysObj.Akt.BaumZweigId);
    end;
    if (Action = NTA_SYNTAXHIGHLIGHTERCHANGE) then
      LadeSyntaxHighlighterMenuItems;
  end;

end;



procedure Tof_SeiteInhalt.Seite_Delete(Sender: TObject);
begin
  FEditor.Clear;
  FEditor.Format;
  FEditor.SetFocus;
end;

procedure Tof_SeiteInhalt.Seite_Edit(Sender: TObject);
begin
  if Fbtn_Edit.Tag = 0 then
  begin
    Fbtn_Edit.Tag := 1;
    Fbtn_Edit.BtnLabel.Caption := 'Speichern';
    Fbtn_Delete.Visible := true;
    Fbtn_Cancel.Visible := true;
    FToolbar.Visible := true;
    FEditor.ReadOnly := false;
    FEditor_Header.ReadOnly := false;
    Fcbx_KopfzeileAusblenden.Visible := true;
    FHeaderText := FEditor_Header.AsRTFString;
    FBodyText   := FEditor.AsRTFString;
  end
  else
  begin
    FToolbar.Visible := false;
    Fbtn_Edit.Tag := 0;
    Fbtn_Edit.BtnLabel.Caption := 'Bearbeiten';
    Fbtn_Delete.Visible := false;
    Fbtn_Cancel.Visible := false;
    FEditor.ReadOnly := true;
    FEditor_Header.ReadOnly := true;
    Fcbx_KopfzeileAusblenden.Visible := false;
    SpeichereSeite;
  end;
end;


procedure Tof_SeiteInhalt.Seite_Cancel(Sender: TObject);
begin
  FToolbar.Visible := false;
  Fbtn_Edit.Tag := 0;
  Fbtn_Edit.BtnLabel.Caption := 'Bearbeiten';
  Fbtn_Delete.Visible := false;
  FBtn_Cancel.Visible := false;
  FEditor.AsRTFString := FBodyText;
  FEditor_Header.AsRTFString := FHeaderText;
  FEditor.ReadOnly := true;
  FEditor_Header.ReadOnly := true;
end;


procedure Tof_SeiteInhalt.VisibleChanged(aValue: Boolean);
begin
  inherited;

end;

procedure Tof_SeiteInhalt.Sperre_Seite;
begin
  FEditor_Header.ClearAndFormated;
  FEditor.ClearAndFormated;
end;


procedure Tof_SeiteInhalt.LadeSeite;
var
  Form: Tfrm_Passwort;
begin

  FEditor_Header.AsRTFString := '';
  FEditor.AsRTFString := '';

  if FBaumButtonEbene <> SysObj.Akt.BaumButtonEbene then
  begin
    FPW := '';
    FBaumButtonEbene := SysObj.Akt.BaumButtonEbene;
  end;

  FSeiteverbinden.Read(SysObj.Akt.BaumButtonEbene, SysObj.Akt.BaumZweigId);
  if (FSeiteverbinden.Id > 0) and (FSeiteverbinden.Seite.Id > 0)  then
  begin
    if FSeiteverbinden.Seite.Feld(SE_PW).AsString > '' then
    begin
      Form := Tfrm_Passwort.Create(Self);
      try
        Form.Passwort.CheckPasswort := FSeiteverbinden.Seite.Feld(SE_PW).AsString;
        if (FPW = '') or (FPW <> sysobj.Entschluesseln(Form.Passwort.CheckPasswort, FPW)) then
        begin
          Form.ShowModal;
          if not Form.Passwort.PasswortOk then
          begin
            sysobj.ObServer.Notify(ntobBearb, NTA_SEITE_SPERREN);
            exit;
          end;
          FPW := Form.edt_PW.Text;
        end;
      finally
        FreeAndNil(Form);
      end;
    end;

    FEditor_Header.ClearAndFormated;
    FEditor.ClearAndFormated;

    FEditor_Header.Height := FSeiteverbinden.Seite.Feld(SE_HEADERHEIGHT).AsInteger;

    if (FPW > '') and (FSeiteverbinden.Seite.Feld(SE_PW).AsString > '') then
    begin
      FEditor_Header.AsRTFString := SysObj.Entschluesseln(FSeiteverbinden.Seite.Feld(SE_HEADER).AsString, FPW);
      FEditor.AsRTFString := SysObj.Entschluesseln(FSeiteverbinden.Seite.Feld(SE_BODY).AsString, FPW);
    end
    else
    begin
      FEditor_Header.AsRTFString := FSeiteverbinden.Seite.Feld(SE_HEADER).AsString;
      FEditor.AsRTFString := FSeiteverbinden.Seite.Feld(SE_BODY).AsString;
    end;

  end;

  FEditor_Header.Visible := FSeiteverbinden.Seite.Feld(SE_HEADER_ANZEIGEN).AsBoolean;
  //fEditor_HeaderPanel.Visible := FSeiteverbinden.Seite.Feld(SE_HEADER_ANZEIGEN).AsBoolean;
  Fcbx_KopfzeileAusblenden.Checked := not FSeiteverbinden.Seite.Feld(SE_HEADER_ANZEIGEN).AsBoolean;
  FSplitter.Visible := not Fcbx_KopfzeileAusblenden.Checked;
  FToolbar.Top := FPnl_Top.Top + FPnl_Top.Height;
  FSplitter.Top := FEditor_Header.Top + FEditor_Header.Height + 10;
  //FSplitter.Align := alBottom;
  Fcbx_KopfzeileAusblenden.Visible := false;

  if FSeiteverbinden.Seite.Feld(SE_HEADER).AsString = '' then
    FEditor_Header.AsRTFString := SysObj.Einstellung.KonfSeite.AsBlob2;
  if FSeiteverbinden.Seite.Feld(SE_BODY).AsString = '' then
    FEditor.AsRTFString := SysObj.Einstellung.KonfSeite.AsBlob3;



end;

procedure Tof_SeiteInhalt.SpeichereSeite;
var
  Seite: TSeite;
begin
  Seite := TSeite.Create(nil);
  try
    Seite.Trans := FTrans;
    if FSeiteverbinden.Seite.Id > 0 then
      Seite.Read(FSeiteverbinden.Seite.Id)
    else
    begin
      Seite.Feld(SE_FTPUEBERTRAGEN).AsBoolean := SysObj.Einstellung.FTP.DokumenteUebertragen.AsBoolean;
      Seite.Feld(SE_GDRIVEUEBERTRAGEN).AsBoolean := SysObj.Einstellung.GoogleDrive.GDriveVerwenden.AsBoolean;
    end;

    if (not FPWChanged) and (FSeiteverbinden.Seite.Feld(SE_PW).AsString = '') then
    begin
      Seite.Feld(SE_HEADER).AsString := FEditor_Header.AsRTFString;
      Seite.Feld(SE_BODY).AsString   := FEditor.AsRTFString;
      Seite.Feld(SE_HEADERHEIGHT).asInteger := FEditor_Header.Height;
    end;

    if (FPW > '') and (FSeiteverbinden.Seite.Feld(SE_PW).AsString > '') then
    begin
      if FPWChanged then
      begin
        Seite.Feld(SE_HEADER).AsString := sysobj.Verschluesseln(FSeiteverbinden.Seite.Feld(SE_HEADER).AsString, FPW);
        Seite.Feld(SE_BODY).AsString   := sysobj.Verschluesseln(FSeiteverbinden.Seite.Feld(SE_BODY).AsString, FPW);
      end
      else
      begin
        Seite.Feld(SE_HEADER).AsString := sysobj.Verschluesseln(FEditor_Header.AsRTFString, FPW);
        Seite.Feld(SE_BODY).AsString   := sysobj.Verschluesseln(FEditor.AsRTFString, FPW);
      end;
    end;

    if (FPW > '') and (FPWChanged) and (FSeiteverbinden.Seite.Feld(SE_PW).AsString = '') then
    begin
      Seite.Feld(SE_HEADER).AsString := sysobj.Entschluesseln(FSeiteverbinden.Seite.Feld(SE_HEADER).AsString, FPW);
      Seite.Feld(SE_BODY).AsString   := sysobj.Entschluesseln(FSeiteverbinden.Seite.Feld(SE_BODY).AsString, FPW);
    end;
    Seite.Feld(SE_HEADER_ANZEIGEN).AsBoolean := not Fcbx_KopfzeileAusblenden.Checked;


    FTrans.StartTransaction;
    try
      Seite.Feld(SE_BODY_SEARCH).AsString := copy(TtbRichviewEdit.PlainText(Seite.Feld(SE_BODY).AsString), 1, 5000);
      Seite.Feld(SE_HEADER_SEARCH).AsString := copy(TtbRichviewEdit.PlainText(Seite.Feld(SE_HEADER).AsString), 1, 2000);
      Seite.Save;
      FSeiteverbinden.Feld(VS_EBENE).AsInteger := SysObj.Akt.BaumButtonEbene;
      FSeiteverbinden.Feld(VS_BS_ID).AsInteger := SysObj.Akt.BaumZweigId;
      FSeiteverbinden.Feld(VS_SE_ID).AsInteger := Seite.Id;
      FSeiteverbinden.Save;
    finally
      if FTrans.InTransaction then
        FTrans.Commit;
    end;
  finally
    FreeAndNil(Seite);
  end;
end;





end.
