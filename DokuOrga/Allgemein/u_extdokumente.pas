unit u_extdokumente;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, DB, IBCustomDataSet, IBQuery, IBDatabase, Grids,
  BaseGrid, AdvGrid, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
  LMDCustomSpeedButton, LMDSpeedButton, StdCtrls, ExtCtrls, LMDCustomControl,
  LMDCustomPanel, LMDCustomBevelPanel, LMDSimplePanel, o_extDokument, o_Artikel,
  LMDCustomComponent, LMDApplicationCtrl,
  DBAdvGrid, Ueberschriftenpanel_norm, OleServer, Word2000,
  o_extdok_anhang, LMDBaseGraphicControl, LMDCustomButton,
  LMDButton, AdvObj, o_empfaenger, o_fileicons, o_fileIcon, Vcl.ImgList,
  DragDrop, DropSource, DragDropFile, DropTarget, Vcl.ComCtrls, DragDropGraphics,
  DropHandler, DragDropText, o_ObjOutlookdrop, DragDropFormats, DragDropInternet, NFSComboBox;

type
  RBezug = Record
    Id: Integer;
    Typ: Integer;
  end;

type
  TFrmExtDokumente = class(TForm)
    Pnl_Main: TLMDSimplePanel;
    Panel4: TPanel;
    IBQ_ExtDokumente: TIBQuery;
    IBQ_ExtDokumenteDummy: TStringField;
    Src_extDokumente: TDataSource;
    IBT_Edit: TIBTransaction;
    MainMenu1: TMainMenu;
    Funktionen1: TMenuItem;
    NeueLieferadresseanlegen1: TMenuItem;
    Lieferadresseleschen1: TMenuItem;
    Standard1: TMenuItem;
    Grd_Dokumente: TDBAdvGrid;
    IBQ_ExtDokumenteTyp: TStringField;
    Button2: TLMDButton;
    Button1: TLMDButton;
    Button4: TLMDButton;
    Schlieen1: TMenuItem;
    cmd_SendMail: TLMDButton;
    Memo1: TMemo;
    Panel1: TPanel;
    Btn_Neu: TLMDSpeedButton;
    Btn_Loeschen: TLMDSpeedButton;
    Btn_Import: TLMDSpeedButton;
    Btn_Zurueck: TLMDSpeedButton;
    Ueberschriftenpanel2: TUeberschriftenpanel;
    DropSource1: TDropFileSource;
    DropFileTarget1: TDropFileTarget;
    DataFormatAdapterBitmap: TDataFormatAdapter;
    DataFormatAdapterText: TDataFormatAdapter;
    DataFormatAdapterOutlook: TDataFormatAdapter;
    Pop: TPopupMenu;
    mnu_Loeschen: TMenuItem;
    DataFormatAdapterTarget: TDataFormatAdapter;
    btn_Speichern: TLMDSpeedButton;
    SaveDialog: TSaveDialog;
    Btn_Kategorien: TLMDButton;
    LMDSimplePanel2: TLMDSimplePanel;
    Lbl_Kategorie: TLabel;
    CoB_Kategorie: TNFSComboBox;
    IBQ_ExtDokumenteOUT_ED_DATUM: TDateTimeField;
    IBQ_ExtDokumenteOUT_ED_DELETE: TIBStringField;
    IBQ_ExtDokumenteOUT_ED_UPDATE: TIBStringField;
    IBQ_ExtDokumenteOUT_ED_BEZUGSID: TIntegerField;
    IBQ_ExtDokumenteOUT_ED_BEZUGSTYP: TIntegerField;
    IBQ_ExtDokumenteOUT_ED_ART: TIntegerField;
    IBQ_ExtDokumenteOUT_ED_TITEL: TIBStringField;
    IBQ_ExtDokumenteOUT_ED_DOKUMENT: TIBStringField;
    IBQ_ExtDokumenteOUT_ED_MA_ID: TIntegerField;
    IBQ_ExtDokumenteOUT_ED_MAILEMPFAENGER: TIBStringField;
    IBQ_ExtDokumenteOUT_ED_IMPORTDATEI: TIBStringField;
    IBQ_ExtDokumenteOUT_ED_SM_ID: TIntegerField;
    IBQ_ExtDokumenteOUT_ED_MAILABSENDER: TIBStringField;
    IBQ_ExtDokumenteOUT_ED_VERZEICHNISINDEX: TIntegerField;
    IBQ_ExtDokumenteOUT_ED_BEZUGSSUBID: TIntegerField;
    IBQ_ExtDokumenteOUT_ED_BEZUGSSUBTYP: TIntegerField;
    IBQ_ExtDokumenteOUT_ED_ID: TIntegerField;
    IBQ_ExtDokumenteOUT_EGON: TIntegerField;
    IBQ_ExtDokumenteOUT_FARBE: TIntegerField;
    IBQ_ExtDokumenteOUT_MATCH: TIBStringField;
    IBQ_ExtDokumenteOUT_KAT: TIntegerField;
    IBT_Dokumenten: TIBTransaction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Btn_NeuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Btn_LoeschenClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Btn_ImportClick(Sender: TObject);
    procedure Grd_DokumenteGetCellColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure Button2Click(Sender: TObject);
    procedure IBQ_ExtDokumenteED_MA_IDGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure IBQ_ExtDokumenteTypGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure Src_extDokumenteDataChange(Sender: TObject; Field: TField);
    procedure Schlieen1Click(Sender: TObject);
    procedure cmd_SendMailClick(Sender: TObject);
    procedure Btn_ZurueckClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Grd_DokumenteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DropFileTarget1Drop(Sender: TObject; ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
    procedure mnu_LoeschenClick(Sender: TObject);
    procedure Grd_DokumenteDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure Button1Click(Sender: TObject);
    procedure btn_SpeichernClick(Sender: TObject);
    procedure Btn_KategorienClick(Sender: TObject);
    procedure CoB_KategorieSelect(Sender: TObject);
    private
      { Private-Deklarationen }
      _BezugsID: Integer;
      _BezugsTyp: Integer;
      _BeziehungID: Integer;
      //aktExtDokument: TExtDokument;
      jump_id: Integer;
      Adr_Adresse: String;
      Adr_Briefanrede: String;
      _DruckAdresse: string;
      _AdressFormat: string;
      _Bezug: RBezug;
      _BezugsSubID: Integer;
      _BezugsSubTyp: Integer;
      _FileIconList: TnfFileIcons;
      _SelectedFiles: TStringList;

      TempBezugTyp: Integer;
      TempBezugsID: Integer;

      // Aendung        : string;
      TempZielName: string; // Für AnhangName
      KommunikationsprofilID: Integer;
      _OutlookDrop: TObjOutlookDrop;

      procedure OpenQuery;
      function EMailwaehlen: string;
      function Adressewaehlen: Boolean;

      function ParseSubject(aText: string): string;
      function ParseMail(MailString: string): string;
      function GetFieldValue(Feld: string): string;
      function MAsuchen(aid: Integer): string;
      function GetEmpfaenger(aBezugsTyp, aBezugsId: Integer): TEmpfaenger;
      procedure Iconssetzen;
      function NeueMail(aMailVorlageId: Integer; aBetreff: string): Boolean;
      procedure MailOeffnen(aEd_Id: Integer);
      procedure setBezugsSubID(awert: Integer);
      procedure setBezugsSubTyp(awert: Integer);
      procedure SelectedFileList(aFileList: TStrings);
      procedure Dokumentanzeigen;
      // procedure SaveVirtualFileStreamToDokumente;
    public
      { Public-Deklarationen }
      procedure setBezugsID(aBezugsId: Integer);
      procedure setBezugsTyp(aBezugsTyp: Integer);
      procedure setBeziehungID(aBeziehungID: Integer);
      procedure setTitel(aTitel: string);
      class procedure DataFormatAdapterBitmap_Save(aBitmapDataFormat: TBitmapDataFormat; aBezugsId, aBezugsTyp, aBezugsSubId, aBezugsSubTyp: Integer; aTrans: TIBTransaction);
      class function DataFormatAdapterOutlook_Save(aFormName: string; aBezugsId, aBezugsTyp, aBezugsSubId, aBezugsSubTyp: Integer; aOutlookDrop: TObjOutlookDrop;
        aTrans: TIBTransaction): Integer;
      class function SaveVirtualFileStreamToDokumente(aOwner: TComponent; aVirtualFileStreamDataFormat: TVirtualFileStreamDataFormat;
        aBezugsId, aBezugsTyp, aBezugsSubId, aBezugsSubTyp: Integer; aTrans: TIBTransaction): Integer;
      class function DataFormatAdapterText_Save(aOwner: TComponent; aTextDataFormat: TTextDataFormat; aBezugsId, aBezugsTyp, aBezugsSubId, aBezugsSubTyp: Integer;
        aTrans: TIBTransaction): Integer;
      class function DropFileTarget_Save(aOwner: TComponent; aDropFileTarget: TDropFileTarget; aBezugsId, aBezugsTyp, aBezugsSubId, aBezugsSubTyp: Integer;
        aTrans: TIBTransaction): Integer;

      property BezugsSubID: Integer read _BezugsSubID write setBezugsSubID;
      property BezugsSubTyp: Integer read _BezugsSubTyp write setBezugsSubTyp;
  end;

var
  FrmExtDokumente: TFrmExtDokumente;

const
  cWartezeit = 600;

implementation

uses u_main, u_ExtDokument_Details, u_ExtDokument_Neu,
  u_mailwahl, o_mails, o_vorgang, SendMail, o_kundenaktivitaet, IniFiles,
  f_optima, ShlObj,
  ShellAPI, o_warengruppe, o_auftragssteuerung, o_geraete, o_wiedervorlage,
  o_OptimaUtil, c_module,
  o_AdressParser, u_MailEdit2, o_sepamandat, o_projekte, c_types, o_DokVerz,
  o_nf, system.Contnrs, u_Bemerkung, o_projektkosten, o_maKommunikation,
  ActiveX, u_dokkategorien_zuordnung, o_richvieweditobj, o_MailItem;

{$R *.dfm}

procedure TFrmExtDokumente.FormCreate(Sender: TObject);
begin
  //aktExtDokument := nil;
  jump_id := -1;
  _BezugsID := 0;
  _BezugsTyp := 0;
  _BeziehungID := 0;
  _DruckAdresse := '';
  _AdressFormat := '';
  _BezugsSubID := 0;
  _BezugsSubTyp := 0;
  _FileIconList := TnfFileIcons.Create(Self);
  _SelectedFiles := TStringList.Create;
  _OutlookDrop := TObjOutlookDrop.Create;
  if _OutlookDrop.canUse then
    _OutlookDrop.DataFormatAdapterOutlook := DataFormatAdapterOutlook;
  DataFormatAdapterOutlook.Enabled := _OutlookDrop.canUse;
end;

procedure TFrmExtDokumente.FormDestroy(Sender: TObject);
begin
  FreeAndNil(_SelectedFiles);
  FreeAndNil(_FileIconList);
  FreeAndNil(_OutlookDrop);
end;

procedure TFrmExtDokumente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Die Spaltenbreite speichern
  TOptimaUtil.writeIni('Externdokumente', 'SETTINGS', Grd_Dokumente.ColumnStatesToString);
  TOptimaUtil.writeIni('Externdokumente', 'SETTINGS_FORM_WIDTH', IntToStr(Width));
  TOptimaUtil.writeIni('Externdokumente', 'SETTINGS_FORM_HEIGHT', IntToStr(Height));
  IBQ_ExtDokumente.Close;
end;

procedure TFrmExtDokumente.FormShow(Sender: TObject);
var
  Artikel: TArtikel;
  Vorgang: TVorgang;
  KuAktivitet: TKundenaktivitaet;
  Serviceauftrag: TAuftragssteuerung;
  Geraet: TGeraete;
  Wiedervorlage: TWiedervorlage;
  Mandat: TSepaMandat;
  Projekt: TProjekte;
  Projektkosten: TProjektkosten;
  s: string;
begin
  _Bezug.Id := _BezugsID;
  _Bezug.Typ := _BezugsTyp;
  s := TOptimaUtil.ReadIni('Externdokumente', 'SETTINGS', '');

  if s <> '' then
    if Grd_Dokumente.ColCount = StrToInt(Copy(s, 1, pos('#', s) - 1)) then
    begin
      Grd_Dokumente.StringToColumnStates(s);
      Grd_Dokumente.UnHideColumnsAll;
      Grd_Dokumente.SetColumnOrder;
    end;

  cmd_SendMail.Enabled := (Stammdaten.LockProviderClient.isActiveModule(moEmail));

  CoB_Kategorie.Transaction := IBT_Edit;
  if CoB_Kategorie.Items.Count = 0 then
  begin
    CoB_Kategorie.Add('-- keine --', '0');
    CoB_Kategorie.addFromSQL(1, 0);
    CoB_Kategorie.setItemIndex(0);
  end;

  case _BezugsTyp of
    extBezugKunde:
      begin
        TempBezugTyp := extBezugKunde;
        TempBezugsID := _BezugsID;
      end;
    extBezugLieferant:
      begin
        TempBezugTyp := extBezugLieferant;
        TempBezugsID := _BezugsID;
      end;
    extBezugVorgang:
      begin
        Vorgang := TVorgang.Create(Self, _BezugsID, Stammdaten, IBT_Edit);
        if Vorgang.Empfaenger.isOfType(1) then
          TempBezugTyp := extBezugKunde
        else
          TempBezugTyp := extBezugLieferant;
        TempBezugsID := Vorgang.Empfaenger.getID;
      end;
    extBezugKundeaktiv:
      begin
        KuAktivitet := TKundenaktivitaet.Create(Self, _BezugsID, Stammdaten, IBT_Edit);
        Caption := 'Dokumente für Kundenaktivität ';
        Ueberschriftenpanel2.NF_Text := 'Dokumente für Kundenaktivität  ' + '(' + DateToStr(KuAktivitet.getDatum) + ')  "' + KuAktivitet.getKurzbeschreibung + '"';
        TempBezugTyp := extBezugKunde;
        TempBezugsID := KuAktivitet.getKunde;
        KuAktivitet.Free;
      end;
    extBezugArtikel:
      begin
        Artikel := TArtikel.Create(Self, _BezugsID, Stammdaten, IBT_Edit);
        Caption := 'Dokumente für Artikel "' + Artikel.getMatch + '"';
        Ueberschriftenpanel2.NF_Text := 'Dokumente für Artikel "' + Artikel.getMatch + '" (' + Artikel.getArtikelNr + ')';
        Artikel.Free;
      end;

    extBezugService:
      begin
        Serviceauftrag := TAuftragssteuerung.Create(Self, _BezugsID, Stammdaten, IBT_Edit);
        TempBezugTyp := extBezugKunde;
        TempBezugsID := Serviceauftrag.getKunde.getID;
        Serviceauftrag.Free;
      end;
    extBezugGeraete:
      begin
        Geraet := TGeraete.Create(Self, _BezugsID, Stammdaten, IBT_Edit);
        if Geraet.getKundenID > 0 then
        begin
          TempBezugTyp := extBezugKunde;
          TempBezugsID := Geraet.getKundenID;
        end;
        Geraet.Free;
      end;
    extBezugWiedervorlage:
      begin
        TempBezugsID := _BezugsID;
        TempBezugTyp := extBezugWiedervorlage;
        Wiedervorlage := TWiedervorlage.Create(Self, _BezugsID, Stammdaten, IBT_Edit);
        if Wiedervorlage.getKundenID > 0 then
        begin
          TempBezugTyp := extBezugKunde;
          TempBezugsID := Wiedervorlage.getKundenID;
        end
        else
        begin
          if Wiedervorlage.getLieferantID > 0 then
          begin
            TempBezugTyp := extBezugLieferant;
            TempBezugsID := Wiedervorlage.getLieferantID;
          end;
        end;
        Wiedervorlage.Free;
      end;
    extBezugMandat:
      begin
        Mandat := TSepaMandat.Create(Self, _BezugsID, Stammdaten, IBT_Edit);
        if Mandat.getKundenID > 0 then
        begin
          TempBezugTyp := extBezugKunde;
          TempBezugsID := Mandat.getKundenID;
        end;
        Mandat.Free;
      end;
    extBezugProjekt:
      begin
        Projekt := TProjekte.Create(Self, _BezugsID, Stammdaten, IBT_Edit);
        if Projekt.getKundenID > 0 then
        begin
          TempBezugTyp := extBezugKunde;
          TempBezugsID := Projekt.getKundenID;
        end;
        Projekt.Free;
      end;
    extBezugProjektkosten:
      begin
        Projektkosten := TProjektkosten.Create(Self, _BezugsID, Stammdaten, IBT_Edit);
        try
          if Projektkosten.EingangsbelegID > 0 then
          begin
            TempBezugTyp := extBezugEingangsbeleg;
            TempBezugsID := Projektkosten.EingangsbelegID;
          end;
        finally
          Projektkosten.Free;
        end;

      end;
  end;

  OpenQuery;
  Grd_Dokumente.HideColumn(8);
  Grd_Dokumente.HideColumn(9);
  Grd_Dokumente.HideColumn(10);

end;

procedure TFrmExtDokumente.OpenQuery;
var
  KatID: Integer;
begin
  if IBT_Edit.Active then
    IBT_Edit.Commit;
  IBQ_ExtDokumente.Close;

  if IBT_Dokumenten.Active then
    IBT_Dokumenten.Commit;
  IBT_Dokumenten.StartTransaction;

  KatID := CoB_Kategorie.getIdxValueInt;

  IBQ_ExtDokumente.SQL.Clear;
  IBQ_ExtDokumente.SQL.Add('select * from Externe_Dokumenten(' + IntToStr(KatID) + ', ' + IntToStr(_BezugsID) + ', ' + IntToStr(_BezugsTyp) + ', ' + IntToStr(_BeziehungID) + ', ' +
    IntToStr(TempBezugsID) + ')');
  IBQ_ExtDokumente.SQL.Add(' order by out_kat desc, out_ed_datum desc ');
  IBQ_ExtDokumente.Open;
  IBQ_ExtDokumente.FetchAll;

  // Auf richtigen Datensatz locaten
  if (jump_id <> -1) then
    IBQ_ExtDokumente.Locate('out_ED_ID', jump_id, [loCaseInsensitive]);

end;

procedure TFrmExtDokumente.setBezugsID(aBezugsId: Integer);
begin
  _BezugsID := aBezugsId;
end;

procedure TFrmExtDokumente.setBezugsSubID(awert: Integer);
begin
  _BezugsSubID := awert;
end;

procedure TFrmExtDokumente.setBezugsSubTyp(awert: Integer);
begin
  _BezugsSubTyp := awert;
end;

procedure TFrmExtDokumente.setBezugsTyp(aBezugsTyp: Integer);
begin
  _BezugsTyp := aBezugsTyp;
end;

function TFrmExtDokumente.NeueMail(aMailVorlageId: Integer; aBetreff: string): Boolean;
var
  MailVorlage: TMails;
  Subject: string;
  BodyText: string;
  HTMLText: string;
  Form: TfrmMailEdit;
  Empfaenger: TEmpfaenger;
  Signatur: string;
begin
  result := true;
  Empfaenger := nil;

  case TempBezugTyp of
    extBezugKunde:
      Empfaenger := TKunden.Create(Self, TempBezugsID, Stammdaten, IBT_Edit);
    extBezugLieferant:
      Empfaenger := TLieferant.Create(Self, TempBezugsID, Stammdaten, IBT_Edit);
  end;

  Subject := aBetreff;
  MailVorlage := TMails.Create(Self, aMailVorlageId, Stammdaten, IBT_Edit);
  try
    if MailVorlage.getSubject > '' then
      Subject := ParseSubject(MailVorlage.getSubject);
    BodyText := ParseMail(MailVorlage.getMText);
    HTMLText := MailVorlage.getMHtml;
  finally
    FreeAndNil(MailVorlage);
  end;

  Form := TfrmMailEdit.Create(Self);
  try
    Form.Empfaenger := Empfaenger;
    if Assigned(Empfaenger) then
      Form.AddEmailAn(Empfaenger.getMail);

    Form.BezugsTyp := _Bezug.Typ;
    Form.BezugsID := _Bezug.Id;

    Form.Edt_Betreff.Text := Subject;

    Signatur := '';
    if Mitarbeiter <> nil then
      Signatur := TMakommunikation.GetMitarbeiterSignaturtext(Mitarbeiter.getID, IBT_Edit);

    HtmlText := TRichViewEditObj.MergeRTF(HtmlText, Signatur, Self.Canvas);
    Form.setBodyText(HTMLText);

    if Form.ShowModal = mrOk then
    begin
      jump_id := Form.Ed_Id;
      OpenQuery;
    end
    else
      result := false;

  finally
    FreeAndNil(Form);
    if Assigned(Empfaenger) then
      FreeAndNil(Empfaenger);
  end;

end;

// @tb 09.11.2012
procedure TFrmExtDokumente.Btn_NeuClick(Sender: TObject);
type
  RTextFormat = Record
    VorBetreff: string;
    Betreff: string;
    NachBetreff: string;
  end;
var
  Ziel: string;
  ZielDateiname: string;
  WordApplication: TWordApplication;
  type_: variant;
  Vorlage: OLEvariant;
  Dateiname: OLEvariant;
  FileFOrmat: OLEvariant;
  BooleanFalse: OLEvariant;
  eMailEmpfaenger: string;
  MailVorlage: TMails;
  MailVorlageID: Integer;
  BodyText: string;
  Subject: string;
  HTMLText: string;
  TextFormat: RTextFormat;
  iPos: Integer;
  Dokument: TExtDokument;
begin

  if IBT_Edit.Active then
    IBT_Edit.Commit;
  IBT_Edit.StartTransaction;

  Application.CreateForm(TFrmExtDokumentNeu, FrmExtDokumentNeu);
  try
    if FrmExtDokumentNeu.ShowModal = mrCancel then
    begin
      if IBT_Edit.Active then
        IBT_Edit.Rollback;
      exit;
    end;

    if FrmExtDokumentNeu.getArt = extArtEMail then
    begin
      if NeueMail(FrmExtDokumentNeu.getMVorlageID, FrmExtDokumentNeu.getBetreff) then
      begin
        if IBT_Edit.Active then
          IBT_Edit.Commit;
      end
      else
      begin
        if IBT_Edit.Active then
          IBT_Edit.Rollback;
      end;
      exit;
    end;
  finally
    FrmExtDokumentNeu.Release;
  end;

  _AdressFormat := FrmExtDokumentNeu.getAdressFormat;

  Dokument := TExtDokument.Create(Self, _BezugsID, _BezugsTyp, Stammdaten, IBT_Edit);
  try
    Dokument.setDatum(now);
    Dokument.setMitarbeiter(Mitarbeiter);
    Dokument.setArt(FrmExtDokumentNeu.getArt);
    Dokument.setBezugsSubID(BezugsSubID);
    Dokument.setBezugsSubTyp(BezugsSubTyp);

    Vorlage := FrmExtDokumentNeu.getVorlage;
    if Dokument.getArt = extArtWord then
    begin
      if Tnf.GetInstance.system.FileExist(Vorlage) < 0 then
      begin
        ShowMsg(Self, 'Die Vorlage [' + Vorlage + '] wurde nicht gefunden.');
        if IBT_Edit.Active then
          IBT_Edit.Rollback;
        OpenQuery;
        exit;
      end;
    end;

    MailVorlageID := FrmExtDokumentNeu.getMVorlageID;
    Dokument.setTitel(FrmExtDokumentNeu.getBetreff);

    FrmExtDokumentNeu.Release;

    // Komplette Zieldatei festlegen
    ZielDateiname := IntToStr(Dokument.getBezugsTyp) + '-' + IntToStr(Dokument.getArt) + '-' + IntToStr(Dokument.getBezugsID) + '-' +
      IntToStr(Dokument.getID);

    TempZielName := ZielDateiname;

    case Dokument.getArt of

      extArtWord:
        begin
          ZielDateiname := ZielDateiname + '.DOC';
          if TempBezugTyp in [extBezugKunde, extBezugLieferant] then
          begin
            if not Adressewaehlen then
            begin
              if Tnf.GetInstance.system.FileExist(Stammdaten.getDokuDir + '\' + ZielDateiname) = 0 then
                DeleteFile(Stammdaten.getDokuDir + '\' + ZielDateiname);
              if IBT_Edit.Active then
                IBT_Edit.Rollback;
              OpenQuery;
              exit;
            end;
          end;
        end;

      extArtEMail:
        begin
          ZielDateiname := ZielDateiname + '.MAIL';
          KommunikationsprofilID := 0;
          // eMailEmpfaenger wählen
          eMailEmpfaenger := EMailwaehlen;
          if eMailEmpfaenger = '' then
          begin
            if Tnf.GetInstance.system.FileExist(Stammdaten.getDokuDir + '\' + ZielDateiname) = 0 then
              DeleteFile(Stammdaten.getDokuDir + '\' + ZielDateiname);
            if IBT_Edit.Active then
              IBT_Edit.Rollback;
            OpenQuery;
            exit;
          end;

          MailVorlage := TMails.Create(Self, MailVorlageID, Stammdaten, IBT_Edit);
          Subject := ParseSubject(MailVorlage.getSubject);
          BodyText := ParseMail(MailVorlage.getMText);
          HTMLText := MailVorlage.getMHtml;
          FreeAndNil(MailVorlage);

        end;

    end;

    // Komplette Zieldatei festlegen
    // Ziel := Stammdaten.getDokuDir + '\' + ZielDateiname;

    Dokument.setDokument(ZielDateiname);
    Dokument.saveToDB;
    Ziel := TDokVerz.GetNewFullFileName(Dokument);

    Application.CreateForm(TFrmExtDokumentDetails, FrmExtDokumentDetails);
    try
      FrmExtDokumentDetails.setExtDokument(Dokument);
      if FrmExtDokumentDetails.ShowModal = mrCancel then
      begin
        if IBT_Edit.Active then
          IBT_Edit.Rollback;
        exit;
      end;
    finally
      FrmExtDokumentDetails.Release;
    end;

    if Dokument.getArt = extArtWord then
    begin
      try
        WordApplication := TWordApplication.Create(Self);
        try
          Screen.Cursor := crHourglass;
          WordApplication.Connect;
          WordApplication.Visible := true;

          WordApplication.Documents.Add(Vorlage, EmptyParam, EmptyParam, EmptyParam);

          Dateiname := Ziel;
          BooleanFalse := false;
          FileFOrmat := 16;
          WordApplication.ActiveDocument.SaveAs(Dateiname, FileFOrmat, BooleanFalse, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam);

          WordApplication.ActiveDocument.Close(BooleanFalse, EmptyParam, EmptyParam);
          WordApplication.Documents.Open(Dateiname, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
            EmptyParam);

          if WordApplication.ActiveWindow.View.SplitSpecial <> wdPaneNone then
            WordApplication.ActiveWindow.ActivePane.Close;

          type_ := WordApplication.ActiveWindow.ActivePane.View.type_;
          if Integer(type_) in [1, 2] then
          begin
            WordApplication.ActiveWindow.ActivePane.View.type_ := 3;
          end;

          TextFormat.VorBetreff := _DruckAdresse;
          TextFormat.Betreff := '';
          TextFormat.NachBetreff := '';
          iPos := pos('@@betreff@@', SqlCaseSensitiv(_DruckAdresse));
          if iPos > 0 then
          begin
            TextFormat.VorBetreff := Copy(_DruckAdresse, 1, iPos - 1);
            TextFormat.Betreff := Dokument.getTitel;
            TextFormat.NachBetreff := Copy(_DruckAdresse, iPos + 11, Length(_DruckAdresse));
          end;

          WordApplication.Selection.TypeText(TextFormat.VorBetreff);
          WordApplication.Selection.TypeParagraph;
          WordApplication.Selection.TypeParagraph;
          WordApplication.Selection.TypeParagraph;
          WordApplication.Selection.TypeParagraph;
          WordApplication.Selection.TypeParagraph;
          WordApplication.Selection.TypeParagraph;
          WordApplication.Selection.Font.Bold := 1;
          if TextFormat.Betreff > '' then
            WordApplication.Selection.TypeText(TextFormat.Betreff);
          WordApplication.Selection.Font.Bold := 0;
          if TextFormat.NachBetreff > '' then
            WordApplication.Selection.TypeText(TextFormat.NachBetreff);

          WordApplication.ActiveDocument.Save();
          WordApplication.Disconnect;
        finally
          WordApplication.Free;
          Screen.Cursor := crDefault;
        end;
      except
        on E: Exception do
        begin
          ShowMsg(Self, 'Fehler beim Verbindung mit Word: ' + E.Message);
          if IBT_Edit.Active then
            IBT_Edit.Rollback;
          exit;
        end;
      end;
    end; // Dokument

    Dokument.saveToDB;
    jump_id := Dokument.getID;
    OpenQuery;
  finally
    FreeAndNil(Dokument);
  end;

end;

function TFrmExtDokumente.Adressewaehlen: Boolean;
var
  AdressParser: TAdressParser;
begin
  result := true;
  Application.CreateForm(TFrmMailWahl, FrmMailWahl);

  FrmMailWahl.setEmpfaengerID(TempBezugsID);
  FrmMailWahl.setBezugsTyp(TempBezugTyp);

  FrmMailWahl.setArt(extArtWord);

  if FrmMailWahl.ShowModal = mrCancel then
  begin
    result := false;
    FrmMailWahl.Release;
    exit;
  end;

  Adr_Adresse := FrmMailWahl.getAdresse;
  Adr_Briefanrede := FrmMailWahl.getBAnrede;
  _DruckAdresse := '';
  if not FrmMailWahl.Adress.Empty then
  begin
    AdressParser := TAdressParser.Create;
    try
      AdressParser.LoadFromAdressFields(FrmMailWahl.Adress);
      AdressParser.ParseText.Text := _AdressFormat;
      _DruckAdresse := AdressParser.getAdresse;
    finally
      FreeAndNil(AdressParser);
    end;
  end;

  FrmMailWahl.Release;
end;

function TFrmExtDokumente.EMailwaehlen: string;
begin
  result := '';

  Application.CreateForm(TFrmMailWahl, FrmMailWahl);

  FrmMailWahl.setEmpfaengerID(TempBezugsID);
  FrmMailWahl.setBezugsTyp(TempBezugTyp);
  FrmMailWahl.setArt(extArtEMail);

  if FrmMailWahl.ShowModal = mrOk then
  begin
    result := FrmMailWahl.getEmail;
    Adr_Briefanrede := FrmMailWahl.getBAnrede;
    KommunikationsprofilID := FrmMailWahl.getKommunikationID;
  end;

  FrmMailWahl.Release;

end;

procedure TFrmExtDokumente.Btn_LoeschenClick(Sender: TObject);
var
  MsgText: string;
  i1: Integer;
  Id: Integer;
  DeleteList: TObjectList;
  TempExtDokument: TExtDokument;
begin

  if IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger = 0 then
    exit;

  MsgText := 'Soll dieses Dokument wirklich gelöscht werden?';

  if Grd_Dokumente.SelectedRowCount > 1 then
    MsgText := 'Möchten Sie wirklich alle markierten Dokumente löschen?';

  if ShowMsg(Self, MsgText, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;

  DeleteList := TObjectList.Create;
  try
    for i1 := 0 to Grd_Dokumente.SelectedRowCount - 1 do
    begin
      Id := StrToInt(Grd_Dokumente.Cells[10, Grd_Dokumente.SelectedRow[i1]]);
      TempExtDokument := TExtDokument.Create(Self, Id, Stammdaten, IBT_Edit);
      if not TempExtDokument.Found then
        continue;
      DeleteList.Add(TempExtDokument);
    end;
    for i1 := 0 to DeleteList.Count - 1 do
      TExtDokument(DeleteList.Items[i1]).delete;
  finally
    FreeAndNil(DeleteList);
  end;

  OpenQuery;

end;

procedure TFrmExtDokumente.Button1Click(Sender: TObject);
begin
  Dokumentanzeigen;
end;

procedure TFrmExtDokumente.Button2Click(Sender: TObject);
var
  eMailEmpfaenger: string;
  Dokument: TextDokument;
begin
  if IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger = 0 then
    exit;

  Dokument := TExtDokument.Create(Self, IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger, Stammdaten, IBT_Edit);
  try
    if TDokVerz.FileExist(Dokument) then
    begin
      KommunikationsprofilID := 0;
      eMailEmpfaenger := EMailwaehlen;
      if eMailEmpfaenger <> '' then
      begin
        //
      end;
    end;
  finally
    FreeAndNil(Dokument);
  end;
end;

function TFrmExtDokumente.GetEmpfaenger(aBezugsTyp, aBezugsId: Integer): TEmpfaenger;
  function getKunde(aid: Integer): TKunden;
  begin
    result := TKunden.Create(Self, aid, Stammdaten, IBT_Edit);
    if not Assigned(result) then
    begin
      ShowMsg(Self, 'Kunde wurde nicht gefunden!', mtError, [mbOk]);
      exit;
    end;
    if result.getID <> aid then
    begin
      ShowMsg(Self, 'Kunde wurde nicht gefunden!', mtError, [mbOk]);
      FreeAndNil(result);
      exit;
    end;
  end;
  function GetLieferant(aid: Integer): TLieferant;
  var
    Lieferant: TLieferant;
  begin
    result := nil;
    Lieferant := TLieferant.Create(Self, aid, Stammdaten, IBT_Edit);
    if not Assigned(Lieferant) then
    begin
      ShowMsg(Self, 'Lieferant wurde nicht gefunden!', mtError, [mbOk]);
      exit;
    end;
    result := Lieferant;
  end;

var
  Vorgang: TVorgang;
begin
  result := nil;
  if aBezugsTyp = extBezugKunde then
  begin
    result := getKunde(aBezugsId);
    exit;
  end;

  if aBezugsTyp = extBezugLieferant then
  begin
    result := GetLieferant(aBezugsId);;
    exit;
  end;

  if aBezugsTyp = extBezugVorgang then
  begin
    Vorgang := TVorgang.Create(Self, aBezugsId, Stammdaten, IBT_Edit);
    if not Assigned(Vorgang) then
    begin
      ShowMsg(Self, 'Vorgang wurde nicht gefunden!', mtError, [mbOk]);
      exit;
    end;
    try
      if Vorgang.getID <> aBezugsId then
      begin
        ShowMsg(Self, 'Vorgang wurde nicht gefunden!', mtError, [mbOk]);
        exit;
      end;
      if Vorgang.Empfaenger is TKunden then
        result := getKunde(Vorgang.Empfaenger.getID);
      if Vorgang.Empfaenger is TLieferant then
        result := GetLieferant(Vorgang.Empfaenger.getID);
    finally
      FreeAndNil(Vorgang);
    end;
  end;
end;

procedure TFrmExtDokumente.cmd_SendMailClick(Sender: TObject);
var
  ExtDokumente: TExtDokument;
  Form: TfrmMailEdit;
  Empfaenger: TEmpfaenger;
  iPos: Integer;
  Source: string;
  Dest: string;
  FullDokuName: string;
begin
  Empfaenger := nil;
  if IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger = 0 then
    exit;

  ExtDokumente := TExtDokument.Create(Self, IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger, Stammdaten, IBT_Edit);
  try
    if not TDokVerz.FileExist(ExtDokumente) then
    begin
      ShowMsg(Self, 'Externes Dokument wurde nicht gefunden!', mtWarning, [mbOk], 0);
      exit;
    end;

    case TempBezugTyp of
      extBezugKunde:
        Empfaenger := TKunden.Create(Self, TempBezugsID, Stammdaten, IBT_Edit);
      extBezugLieferant:
        Empfaenger := TLieferant.Create(Self, TempBezugsID, Stammdaten, IBT_Edit);
    end;

    iPos := pos('.MAIL', ExtDokumente.getDokument);
    if iPos > 0 then
    begin
      MailOeffnen(IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger);
      exit;
    end;

    Form := TfrmMailEdit.Create(Self);
    try

      Form.BezugsTyp := _Bezug.Typ;
      Form.BezugsID := _Bezug.Id;

      Form.Empfaenger := Empfaenger;
      FullDokuName := TDokVerz.GetFullFileName(ExtDokumente);

      if ExtDokumente.getImportdatei > '' then
      begin
        // Die archivierte Datei in den Original-Dateiname umwandeln.
        // Damit die EMail beim Versand den Original-Dateiname bekommt.
        // Source := Stammdaten.getDokuDir + '\' + ExtDokumente.getDokument;
        Source := TDokVerz.GetFullFileName(ExtDokumente);
        Dest := IncludeLastBackslash(Stammdaten.getDokuDirMailSend) + ExtDokumente.getImportdatei;
        CopyFile(PChar(Source), PChar(Dest), false);
        Form.AddAnhang(ExtractFileName(Dest), Dest);
      end
      else
        Form.AddAnhang(FullDokuName, FullDokuName);

      if Assigned(Empfaenger) then
      begin
        if Assigned(Empfaenger) then
          Form.AddEmailAn(Empfaenger.getMail);
      end;
      Form.Edt_Betreff.Text := ExtDokumente.getTitel;
      Form.DoLoadTemplate := true;
      if Form.ShowModal = mrOk then
      begin
        jump_id := Form.Ed_Id;
        OpenQuery;
      end;
    finally
      FreeAndNil(Form);
      if Assigned(Empfaenger) then
        FreeAndNil(Empfaenger);
    end;

  finally
    FreeAndNil(ExtDokumente);
  end;
end;

procedure TFrmExtDokumente.CoB_KategorieSelect(Sender: TObject);
begin
  jump_id := IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger;
  OpenQuery;
end;

procedure TFrmExtDokumente.DropFileTarget1Drop(Sender: TObject; ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
begin
  if Tnf.GetInstance.system.DirExist(Stammdaten.getDokuDir) < 0 then
  begin
    ShowMsg(Self, 'Zielverzeichnis "' + Stammdaten.getDokuDir + '" existiert nicht.');
    exit;
  end;

  if (TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames.Count > 0) then
  begin
    SaveVirtualFileStreamToDokumente(Self, TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat), _BezugsID, _BezugsTyp, _BezugsSubID, _BezugsSubTyp, IBT_Edit);
    OpenQuery;
    exit;
  end;

  if (DataFormatAdapterBitmap.DataFormat <> nil) then
  begin
    if (DataFormatAdapterBitmap.DataFormat as TBitmapDataFormat).HasData then
    begin
      DataFormatAdapterBitmap_Save((DataFormatAdapterBitmap.DataFormat as TBitmapDataFormat), _BezugsID, _BezugsTyp, _BezugsSubID, _BezugsSubTyp, IBT_Edit);
      OpenQuery;
      exit;
    end;
  end;

  if (DataFormatAdapterOutlook.DataFormat <> nil) then
  begin
    _OutlookDrop.Dropped;
    if _OutlookDrop.OutlookDropMessages.Count > 0 then
    begin
      jump_id := DataFormatAdapterOutlook_Save(Self.Name, _BezugsID, _BezugsTyp, _BezugsSubID, _BezugsSubTyp, _OutlookDrop, IBT_Edit);
      OpenQuery;
      exit;
    end;
  end;

  if (DataFormatAdapterText.DataFormat <> nil) then
  begin
    if (DataFormatAdapterText.DataFormat as TTextDataFormat).HasData then
    begin
      jump_id := DataFormatAdapterText_Save(Self, (DataFormatAdapterText.DataFormat as TTextDataFormat), _BezugsID, _BezugsTyp, _BezugsSubID, _BezugsSubTyp, IBT_Edit);
      OpenQuery;
      exit;
    end;
  end;

  jump_id := DropFileTarget_Save(Self, DropFileTarget1, _BezugsID, _BezugsTyp, _BezugsSubID, _BezugsSubTyp, IBT_Edit);
  if DropFileTarget1.Files.Count > 0 then
  begin
    OpenQuery;
  end;
end;

class function TFrmExtDokumente.DropFileTarget_Save(aOwner: TComponent; aDropFileTarget: TDropFileTarget; aBezugsId, aBezugsTyp, aBezugsSubId, aBezugsSubTyp: Integer;
  aTrans: TIBTransaction): Integer;
var
  i: Integer;
  FileName: string;
  Dateiname: string;
  Extention: string;
  aktExtDokument: TExtDokument;
  Titel: string;
begin
  result := -1;
  for i := 0 to aDropFileTarget.Files.Count - 1 do
  begin
    FileName := aDropFileTarget.Files[i];

    if (aDropFileTarget.MappedNames.Count > i) then
      FileName := aDropFileTarget.MappedNames[i];

    Extention := ExtractFileExt(FileName);

    aktExtDokument := TExtDokument.Create(nil, aBezugsId, aBezugsTyp, Stammdaten, aTrans);
    try
      Titel := Copy(ExtractFileName(FileName), 1, Length(ExtractFileName(FileName)) - Length(Extention));
      aktExtDokument.setDatum(now);
      aktExtDokument.setMitarbeiter(Mitarbeiter);
      aktExtDokument.setBezugsSubID(aBezugsSubId);
      aktExtDokument.setBezugsSubTyp(aBezugsSubTyp);
      aktExtDokument.setTitel(Titel);

      Extention := ExtractFileExt(FileName);

      Dateiname := IntToStr(aktExtDokument.getBezugsTyp) + '-' + IntToStr(aktExtDokument.getBezugsID) + '-' + IntToStr(aktExtDokument.getID) + Extention;

      aktExtDokument.setDokument(Dateiname);
      Dateiname := TDokVerz.GetNewFullFileName(aktExtDokument);

      if not CopyFile(PChar(FileName), PChar(Dateiname), false) then
      begin
        ShowMsg(aOwner, 'Fehler beim Kopieren der Datei "' + FileName + '"', mtInformation, [mbOk], 0);
        aktExtDokument.setDokument('');
      end;

      aktExtDokument.setImportdatei(aktExtDokument.DatNameausPfadLesen(FileName));
      aktExtDokument.setArt(Artsetzen(Extention));
      aktExtDokument.saveToDB;

      result := aktExtDokument.getID;
    finally
      FreeAndNil(aktExtDokument);
    end;
  end;
end;

class function TFrmExtDokumente.DataFormatAdapterText_Save(aOwner: TComponent; aTextDataFormat: TTextDataFormat; aBezugsId, aBezugsTyp, aBezugsSubId, aBezugsSubTyp: Integer;
  aTrans: TIBTransaction): Integer;
var
  Dateiname: string;
  Extention: string;
  aktExtDokument: TExtDokument;
  Titel: string;
  TextList: TStringList;
begin
  TextList := TStringList.Create;
  aktExtDokument := TExtDokument.Create(Nil, aBezugsId, aBezugsTyp, Stammdaten, aTrans);
  try
    TextList.Text := aTextDataFormat.Text;
    Titel := Copy(Trim(TextList.Strings[0]), 1, 125) + IntToStr(aktExtDokument.getBezugsTyp) + '-' + IntToStr(aktExtDokument.getBezugsID) + '-' + IntToStr(aktExtDokument.getID);

    aktExtDokument.setDatum(now);
    aktExtDokument.setMitarbeiter(Mitarbeiter);
    aktExtDokument.setBezugsSubID(aBezugsSubId);
    aktExtDokument.setBezugsSubTyp(aBezugsSubTyp);
    aktExtDokument.setTitel(Titel);

    Extention := '.txt';

    Dateiname := IntToStr(aktExtDokument.getBezugsTyp) + '-' + IntToStr(aktExtDokument.getBezugsID) + '-' + IntToStr(aktExtDokument.getID) + Extention;

    aktExtDokument.setDokument(Dateiname);
    Dateiname := TDokVerz.GetNewFullFileName(aktExtDokument);

    TextList.SaveToFile(Dateiname);

    aktExtDokument.setArt(Artsetzen(Extention));
    aktExtDokument.saveToDB;
    result := aktExtDokument.getID;
  finally
    FreeAndNil(aktExtDokument);
    FreeAndNil(TextList);
  end;
end;

procedure TFrmExtDokumente.Dokumentanzeigen;
var
  Err: Integer;
  DateiEndung: string;
  Dokument: TExtDokument;
begin

  // DateiEndung := DateiaendungLesen(IBQ_ExtDokumente.FieldByName('out_ed_dokument').AsString);
  DateiEndung := ExtractFileExt(IBQ_ExtDokumente.FieldByName('out_ed_dokument').AsString);

  if IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger = 0 then
    exit;

  if (IBQ_ExtDokumente.FieldByName('out_ed_art').asInteger = extArtEMail) and (CompareText(DateiEndung, 'MAIL') = 0) then
  begin
    MailOeffnen(IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger);
    exit;
  end;

  Dokument := TExtDokument.Create(Self, IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger, Stammdaten, IBT_Edit);
  try
    if TDokVerz.FileExist(Dokument, true) then
    begin
      case Dokument.getArt of
        extArtEMail:
          begin
            if CompareText(DateiEndung, 'MSG') = 0 then
            begin
              Err := TDokVerz.Open(Dokument);
              if Err <= 32 then
                ShowMsg(Self, ShellExecuteErrorStr(Err), mtError, [mbOk]);
            end;
          end;
      else
        begin
          Err := TDokVerz.Open(Dokument);
          if Err <= 32 then
            ShowMsg(Self, ShellExecuteErrorStr(Err), mtError, [mbOk]);
        end;
      end; { of case }

      jump_id := Dokument.getID;
      OpenQuery;

    end;
  finally
    FreeAndNil(Dokument);
  end;
end;

class function TFrmExtDokumente.DataFormatAdapterOutlook_Save(aFormName: string; aBezugsId, aBezugsTyp, aBezugsSubId, aBezugsSubTyp: Integer; aOutlookDrop: TObjOutlookDrop;
  aTrans: TIBTransaction): Integer;
var
  i: Integer;
  TextList: TStringList;
  aktExtDokument: TExtDokument;
  Titel: string;
  Extention: string;
  Dateiname: string;
  RTFText: string;
  sText: string;
begin
  result := -1;
  aOutlookDrop.Dropped;
  if aOutlookDrop.OutlookDropMessages.Count > 0 then
  begin
    TextList := TStringList.Create;
    aktExtDokument := TExtDokument.Create(nil, aBezugsId, aBezugsTyp, Stammdaten, aTrans);
    try
      for i := 0 to aOutlookDrop.OutlookDropMessages.Count - 1 do
      begin
        TextList.Add('Von : ' + aOutlookDrop.OutlookDropMessages.Item[i].Von + ' <' + aOutlookDrop.OutlookDropMessages.Item[i].Von_eMail + '>');
        TextList.Add('An : ' + aOutlookDrop.OutlookDropMessages.Item[i].An);
        TextList.Add('Betreff : ' + aOutlookDrop.OutlookDropMessages.Item[i].Betreff);
        TextList.Add('');
        TextList.Add('');
        TextList.Add(aOutlookDrop.OutlookDropMessages.Item[i].BodyText);
      end;
      Titel := Copy(Trim(aOutlookDrop.OutlookDropMessages.Item[0].Betreff), 1, 125);

      aktExtDokument.setDatum(now);
      aktExtDokument.setMitarbeiter(Mitarbeiter);
      aktExtDokument.setBezugsSubID(aBezugsSubId);
      aktExtDokument.setBezugsSubTyp(aBezugsSubTyp);
      aktExtDokument.setTitel(Titel);

      Extention := '.mail';

      Dateiname := IntToStr(aktExtDokument.getBezugsTyp) + '-' + IntToStr(aktExtDokument.getBezugsID) + '-' + IntToStr(aktExtDokument.getID) + Extention;

      aktExtDokument.setDokument(Dateiname);
      Dateiname := TDokVerz.GetNewFullFileName(aktExtDokument);

      TextList.SaveToFile(Dateiname);
      Tfrm_Bemerkung.ShowBemerkung(aFormName + '_extDokumente', 32, 'Mail', TextList.Text, sText, RTFText);
      TextList.Clear;
      TextList.Text := RTFText;
      TextList.SaveToFile(Dateiname);

      aktExtDokument.setArt(Artsetzen(Extention));
      aktExtDokument.saveToDB;
      result := aktExtDokument.getID;
    finally
      FreeAndNil(aktExtDokument);
      FreeAndNil(TextList);
    end;
  end;
end;

class procedure TFrmExtDokumente.DataFormatAdapterBitmap_Save(aBitmapDataFormat: TBitmapDataFormat; aBezugsId, aBezugsTyp, aBezugsSubId, aBezugsSubTyp: Integer;
  aTrans: TIBTransaction);
var
  Dateiname: string;
  Extention: string;
  aktExtDokument: TExtDokument;
  Titel: string;
begin
  aktExtDokument := TExtDokument.Create(nil, aBezugsId, aBezugsTyp, Stammdaten, aTrans);
  try
    Titel := 'Bitmap ' + IntToStr(aktExtDokument.getBezugsTyp) + '-' + IntToStr(aktExtDokument.getBezugsID) + '-' + IntToStr(aktExtDokument.getID);

    aktExtDokument.setDatum(now);
    aktExtDokument.setMitarbeiter(Mitarbeiter);
    aktExtDokument.setBezugsSubID(aBezugsSubId);
    aktExtDokument.setBezugsSubTyp(aBezugsSubTyp);
    aktExtDokument.setTitel(Titel);

    Extention := '.bmp';

    Dateiname := IntToStr(aktExtDokument.getBezugsTyp) + '-' + IntToStr(aktExtDokument.getBezugsID) + '-' + IntToStr(aktExtDokument.getID) + Extention;

    aktExtDokument.setDokument(Dateiname);
    Dateiname := TDokVerz.GetNewFullFileName(aktExtDokument);

    aBitmapDataFormat.Bitmap.SaveToFile(Dateiname);

    aktExtDokument.setArt(Artsetzen(Extention));
    aktExtDokument.saveToDB;
  finally
    FreeAndNil(aktExtDokument);
  end;
end;

// Für Virtuelle Filestreams zum Beispiel Anhänge aus Outlook
class function TFrmExtDokumente.SaveVirtualFileStreamToDokumente(aOwner: TComponent; aVirtualFileStreamDataFormat: TVirtualFileStreamDataFormat;
  aBezugsId, aBezugsTyp, aBezugsSubId, aBezugsSubTyp: Integer; aTrans: TIBTransaction): Integer;
type
  PLargeint = ^Largeint;
var
  Buffer: AnsiString;
  p: PAnsiChar;
  i: Integer;
  Stream: IStream;
  StatStg: TStatStg;
  Total, BufferSize, Chunk, Size: longInt;
  MyFile: TFileStream;
  FileName: string;
  Extention: string;
  aktExtDokument: TExtDokument;
  Titel: string;
  Dateiname: string;
  MailItem: TMailItem;
const
  MaxBufferSize = 32 * 1024; // 32Kb
begin
  result := -1;
  for i := 0 to aVirtualFileStreamDataFormat.FileNames.Count - 1 do
  begin
    FileName := aVirtualFileStreamDataFormat.FileNames[i];
    Extention := ExtractFileExt(FileName);
    Titel := Copy(ExtractFileName(FileName), 1, Length(ExtractFileName(FileName)) - Length(Extention));
    Stream := aVirtualFileStreamDataFormat.FileContentsClipboardFormat.GetStream(i);
    if Stream = nil then
    begin
      ShowMsg(aOwner, 'Der Dateiinhalt von "' + FileName + '" konnte nicht gelesen werden.', mtError, [mbOk]);
      continue;
    end;
    aktExtDokument := TExtDokument.Create(nil, aBezugsId, aBezugsTyp, Stammdaten, aTrans);
    try

      Titel := Copy(ExtractFileName(FileName), 1, Length(ExtractFileName(FileName)) - Length(Extention));
      aktExtDokument.setDatum(now);
      aktExtDokument.setMitarbeiter(Mitarbeiter);
      aktExtDokument.setBezugsSubID(aBezugsSubId);
      aktExtDokument.setBezugsSubTyp(aBezugsSubTyp);
      aktExtDokument.setTitel(Titel);

      Extention := ExtractFileExt(FileName);

      Dateiname := IntToStr(aktExtDokument.getBezugsTyp) + '-' + IntToStr(aktExtDokument.getBezugsID) + '-' + IntToStr(aktExtDokument.getID) + Extention;

      aktExtDokument.setDokument(Dateiname);
      Dateiname := TDokVerz.GetNewFullFileName(aktExtDokument);

      MyFile := TFileStream.Create(Dateiname, fmCreate);
      try
        Stream.Stat(StatStg, STATFLAG_NONAME);
        Total := StatStg.cbSize;
        Stream.Seek(0, STREAM_SEEK_SET, PLargeint(nil)^);
        BufferSize := Total;
        if (BufferSize > MaxBufferSize) then
          BufferSize := MaxBufferSize;

        SetLength(Buffer, BufferSize);
        p := PAnsiChar(Buffer);
        Chunk := BufferSize;
        while (Total > 0) do
        begin
          Stream.Read(p, Chunk, @Size);
          if (Size = 0) then
            break;

          inc(p, Size);
          dec(Total, Size);
          dec(Chunk, Size);

          if (Chunk = 0) or (Total = 0) then
          begin
            p := PAnsiChar(Buffer);
            MyFile.WriteBuffer(p^, BufferSize - Chunk);
            Chunk := BufferSize;
          end;
        end;

        aktExtDokument.setImportdatei(aktExtDokument.DatNameausPfadLesen(FileName));
        aktExtDokument.setArt(Artsetzen(Extention));
        aktExtDokument.saveToDB;
        result := aktExtDokument.getID;

      finally
        FreeAndNil(MyFile);
      end;

      if aktExtDokument.getArtForExtension(Extention) = extArtEMail then
      begin
        try
          MailItem := TMailItem.Create;
          try
            MailItem.Load(Dateiname);
            aktExtDokument.setMailAbsender(MailItem.Sendername + ' <' + MailItem.SenderEmailAddress + '>');
            aktExtDokument.saveToDB;
          finally
            FreeAndNil(MailItem);
          end;
        except
        end;
      end;

    finally
      FreeAndNil(aktExtDokument);
    end;
  end;
end;

procedure TFrmExtDokumente.Button4Click(Sender: TObject);
var
  Dokument: TextDokument;
begin
  if IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger = 0 then
    exit;


  Dokument := TExtDokument.Create(Self, IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger, Stammdaten, IBT_Edit);

  if Dokument = nil then
    exit;
  try
    Application.CreateForm(TFrmExtDokumentDetails, FrmExtDokumentDetails);
    FrmExtDokumentDetails.setExtDokument(Dokument);
    FrmExtDokumentDetails.ShowModal;
    FrmExtDokumentDetails.Release;

    jump_id := Dokument.getID;
    OpenQuery;
  finally
    FreeAndNil(Dokument);
  end;

end;

procedure TFrmExtDokumente.MailOeffnen(aEd_Id: Integer);
var
  Form: TfrmMailEdit;
  ExtDokument: TExtDokument;
  ExtAnhangListe: TExtDok_AnhangListe;
  ExtAnhang: TExtDok_Anhang;
  i1: Integer;
  MailName: string;
begin
  ExtDokument := TExtDokument.Create(Self, aEd_Id, Stammdaten, IBT_Edit);
  try
    MailName := TDokVerz.GetFullFileName(ExtDokument);

    if (Tnf.GetInstance.system.FileExist(MailName) < 0) and (ExtDokument.getSM_Id <= 0) then
    begin
      ShowMsg(Self, 'E-Mail Datei: "' + MailName + '" ' + #13 + 'wurde nicht gefunden.', mtError, [mbOk], 0);
      exit;
    end;
    ExtAnhangListe := TExtDok_AnhangListe.Create(Self, aEd_Id, Stammdaten, IBT_Edit);
    Form := TfrmMailEdit.Create(Self);
    try
      for i1 := 0 to ExtAnhangListe.Count - 1 do
      begin
        ExtAnhang := TExtDok_Anhang(ExtAnhangListe.Items[i1]);
        Form.AddAnhang(ExtAnhang.getAlteDokument, ExtAnhang.getNeueDokument);
      end;
      Form.Empfaenger := nil;
      if (ExtDokument.getBezugsTyp = extBezugKunde) or (ExtDokument.getBezugsTyp = extBezugLieferant) or (ExtDokument.getBezugsTyp = extBezugVorgang) then
      begin
        Form.Empfaenger := GetEmpfaenger(ExtDokument.getBezugsTyp, ExtDokument.getBezugsID);
        if not Assigned(Form.Empfaenger) then
        begin
          ShowMsg(Self, 'Empfänger wurde nicht gefunden.', mtError, [mbOk]);
          exit;
        end;
        if Form.Empfaenger.getID = 0 then
        begin
          ShowMsg(Self, 'Empfänger wurde nicht gefunden.', mtError, [mbOk]);
          exit;
        end;
      end;
      if (ExtDokument.getBezugsTyp = extBezugArtikel) or (ExtDokument.getBezugsTyp = extBezugWiedervorlage) then
      begin
        Form.BezugsTyp := ExtDokument.getBezugsTyp;
        Form.BezugsID := ExtDokument.getBezugsTyp;
      end;
      if Tnf.GetInstance.system.FileExist(MailName) = 0 then
        Form.LoadFromFile(MailName)
      else if ExtDokument.getSM_Id > 0 then
        Form.LoadEMailFromSentMails(ExtDokument.getSM_Id);
      Form.Edt_Betreff.Text := ExtDokument.getTitel;
      Form.Edt_An.Text := ExtDokument.getMailempfaenger;
      Form.ExtDokument := ExtDokument;

      if Form.ShowModal = mrOk then
      begin
        jump_id := Form.Ed_Id;
        OpenQuery;
      end;
    finally
      FreeAndNil(Form);
      FreeAndNil(ExtAnhangListe);
    end;
  finally
    FreeAndNil(ExtDokument);
  end;
end;

procedure TFrmExtDokumente.Grd_DokumenteDblClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  if ARow = 0 then
    exit;

  Dokumentanzeigen;
end;

procedure TFrmExtDokumente.Btn_ImportClick(Sender: TObject);
var
  Kunde: TKunden;
  Lieferant: TLieferant;
  Dokument: TextDokument;
begin

  if IBT_Edit.Active then
    IBT_Edit.Commit;
  IBT_Edit.StartTransaction;

  Dokument := TExtDokument.Create(Self, _BezugsID, _BezugsTyp, Stammdaten, IBT_Edit);
  try
    Dokument.setDatum(now);
    Dokument.setMitarbeiter(Mitarbeiter);
    Dokument.setBezugsSubID(BezugsSubID);
    Dokument.setBezugsSubTyp(BezugsSubTyp);

    Application.CreateForm(TFrmExtDokumentDetails, FrmExtDokumentDetails);
    try
      FrmExtDokumentDetails.setExtDokument(Dokument);
      if FrmExtDokumentDetails.ShowModal <> mrOk then
      begin
        if IBT_Edit.Active then
          IBT_Edit.Rollback;
        exit;
      end;
    finally
      FrmExtDokumentDetails.Release;
      FreeAndNil(FrmExtDokumentDetails);
    end;

    case _BezugsTyp of
      extBezugKunde:
        begin
          Kunde := TKunden.Create(Self, _BezugsID, Stammdaten, IBT_Edit);
          Dokument.setMailempfaenger(Kunde.getMail);
          FreeAndNil(Kunde);
        end;
      extBezugLieferant:
        begin
          Lieferant := TLieferant.Create(Self, _BezugsID, Stammdaten, IBT_Edit);
          Dokument.setMailempfaenger(Lieferant.getMail);
          FreeAndNil(Lieferant);
        end;
    end;

    jump_id := Dokument.getID;
    OpenQuery;
  finally
    FreeAndNil(Dokument);
  end;

end;

procedure TFrmExtDokumente.Btn_KategorienClick(Sender: TObject);
begin
  if IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger = 0 then
    exit;

  Application.CreateForm(TFrmKatZuordnung, FrmKatZuordnung);
  FrmKatZuordnung.DokumentID := IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger;
  FrmKatZuordnung.ShowModal;
  FrmKatZuordnung.Release;
end;

procedure TFrmExtDokumente.setTitel(aTitel: string);
begin

  Ueberschriftenpanel2.NF_Text := 'Dokumente für ' + aTitel;
  Caption := 'Externe Dokumente für ' + aTitel;

end;

procedure TFrmExtDokumente.Src_extDokumenteDataChange(Sender: TObject; Field: TField);
begin
  if Field = nil then
    Iconssetzen;
end;

/// ///////////////////////////////////////////////////////
function TFrmExtDokumente.GetFieldValue(Feld: string): string;
var
  Spaltenbreite: Integer;
  Spaltenseite: string;
  Temp, Temp2: string;
  i: Integer;
  IBQ_Kunde: TIBQuery;
  IBQ_Lieferanten: TIBQuery;
begin
  IBQ_Kunde := nil;
  IBQ_Lieferanten := nil;

  case _BezugsTyp of
    extBezugKunde:
      begin
        IBQ_Kunde := TIBQuery.Create(Self);
        IBQ_Kunde.Transaction := IBT_Edit;
        IBQ_Kunde.SQL.Add('select * from KUNDEN where KU_ID = :Kunde');
        IBQ_Kunde.ParamByName('Kunde').asInteger := _BezugsID;
        IBQ_Kunde.Open;
      end;
    extBezugLieferant:
      begin
        IBQ_Lieferanten := TIBQuery.Create(Self);
        IBQ_Lieferanten.Transaction := IBT_Edit;
        IBQ_Lieferanten.SQL.Add('select * from LIEFERANTEN where LT_ID = :Lieferanten');
        IBQ_Lieferanten.ParamByName('Lieferanten').asInteger := _BezugsID;
        IBQ_Lieferanten.Open;
      end;
  end;

  // Gibt es eine Spaltenbegrenzung?
  Spaltenbreite := 0;
  Spaltenseite := '';
  if pos('<', Feld) > 0 then
  begin
    Spaltenbreite := StrToInt(Copy(Feld, pos('<', Feld) + 1, 5));
    Spaltenseite := 'links';
    delete(Feld, pos('<', Feld), 5);
  end

  else if pos('>', Feld) > 0 then
  begin
    Spaltenbreite := StrToInt(Copy(Feld, pos('>', Feld) + 1, 5));
    Spaltenseite := 'rechts';
    delete(Feld, pos('>', Feld), 5);
  end;

  // Info aus DB lesen...
  if pos('BRIEFANREDE_ALLE', UpperCase(Feld)) > 0 then
  begin
    if (Adr_Briefanrede <> '') then
      Temp := Adr_Briefanrede
    else
      Temp := Stammdaten.getStdBriefanrede;
  end
  else if pos('KU_', Feld) > 0 then
  begin
    if (UpperCase(Feld) = 'KU_BRIEFANREDE') and (Adr_Briefanrede <> '') then
      Temp := Adr_Briefanrede
    else
    begin
      if IBQ_Kunde <> nil then
        Temp := IBQ_Kunde.FieldByName(Feld).AsString
      else
        Temp := Stammdaten.getStdBriefanrede;
    end;
  end
  else if pos('LT_', Feld) > 0 then
  begin
    if (UpperCase(Feld) = 'LT_BRIEFANREDE') and (Adr_Briefanrede <> '') then
      Temp := Adr_Briefanrede
    else
    begin
      if IBQ_Lieferanten <> nil then
        Temp := IBQ_Lieferanten.FieldByName(Feld).AsString
      else
        Temp := Stammdaten.getStdBriefanrede;
    end;
  end;

  // Spalten berechnen...
  // allgemein
  if (Spaltenbreite > 0) and (Length(Temp) > Spaltenbreite) then
  begin
    GetFieldValue := Copy(Temp, 0, Spaltenbreite);
  end

  // links auffüllen
  else if (Spaltenseite = 'links') and (Spaltenbreite > 0) then
  begin
    for i := Length(Temp) to Spaltenbreite do
      Temp := Temp + ' ';
    GetFieldValue := Temp;
  end

  // rechts auffüllen
  else if (Spaltenseite = 'rechts') and (Spaltenbreite > 0) then
  begin
    Temp2 := '';
    for i := Length(Temp) to Spaltenbreite do
      Temp2 := Temp2 + ' ';
    Temp := Temp2 + Temp;
    GetFieldValue := Temp;
  end

  // ansonsten
  else
  begin
    GetFieldValue := Temp;
  end;

  case _BezugsTyp of
    extBezugKunde:
      begin
        IBQ_Kunde.Close;
        IBQ_Kunde.Free;
      end;
    extBezugLieferant:
      begin
        IBQ_Lieferanten.Close;
        IBQ_Lieferanten.Free;
      end;
  end;

end;

function TFrmExtDokumente.ParseSubject(aText: string): string;
begin
  result := aText;
end;

procedure TFrmExtDokumente.Schlieen1Click(Sender: TObject);
begin
  Close;
end;

function TFrmExtDokumente.ParseMail(MailString: string): string;
var
  Mail: TStringList;
  i: Integer;
  Start, Ende: Integer;
  Feldname: string;
  Temp: string;
begin

  Mail := TStringList.Create;
  try
    Mail.Text := MailString;

    i := 0;
    while i < Mail.Count do
    begin
      Temp := Mail[i];

      while true do
      begin
        // Suche nach Start-String
        if pos('@@', Temp) > 0 then
        begin
          Start := pos('@@', Temp);
          // Start-String löschen
          delete(Temp, Start, 2);
          // Suche nach EndString
          Ende := pos('@@', Temp);
          // Feldname lesen
          Feldname := Copy(Temp, Start, Ende - Start);
          // Feldname und Endstring löschen
          // Wenn "Signatur dann nicht löschen

          case TempBezugTyp of
            extBezugKunde:
              begin
                if (pos('KU_', Feldname) = 0) and (pos('BRIEFANREDE_ALLE', UpperCase(Feldname)) = 0) then
                begin
                  Insert('@@', Temp, Start);
                  break;
                end;
              end;
            extBezugLieferant:
              begin
                if (pos('LT_', Feldname) = 0) and (pos('BRIEFANREDE_ALLE', UpperCase(Feldname)) = 0) then
                begin
                  Insert('@@', Temp, Start);
                  break;
                end;
              end;

          end;

          if UpperCase(Feldname) = UpperCase('Signatur') then
          begin
            Insert('@@', Temp, Start);
            break;
          end
          else
            delete(Temp, Start, Ende - Start + 2);

          // Daten einfügen
          Insert(GetFieldValue(Feldname), Temp, Start);
        end
        else
          break;

      end;

      Mail[i] := Temp;
      inc(i);
    end;

    result := Mail.Text;
  finally
    FreeAndNil(Mail);
  end;

end;

procedure TFrmExtDokumente.setBeziehungID(aBeziehungID: Integer);
begin
  _BeziehungID := aBeziehungID;
end;

procedure TFrmExtDokumente.Grd_DokumenteGetCellColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if (ARow > 0) and (Grd_Dokumente.AllCells[8, ARow] = '1') then
  begin
    ABrush.Color := $00EDE8E7;
  end;
end;

procedure TFrmExtDokumente.IBQ_ExtDokumenteED_MA_IDGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if IBQ_ExtDokumente.FieldByName('out_ed_ma_id').asInteger > 0 then
    Text := MAsuchen(IBQ_ExtDokumente.FieldByName('out_ed_ma_id').asInteger)
  else
    Text := '';
end;

procedure TFrmExtDokumente.IBQ_ExtDokumenteTypGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if IBQ_ExtDokumente.FieldByName('out_ed_dokument').AsString <> '' then
    Text := UpperCase(DateiaendungLesen(IBQ_ExtDokumente.FieldByName('out_ed_dokument').AsString))
  else
    Text := '';
end;

procedure TFrmExtDokumente.Iconssetzen;
var
  i: Integer;
  Ext: string;
  FileIcon: TnfFileIcon;
begin
  Grd_Dokumente.ClearNormalCols(0, 1);

  for i := 1 to Grd_Dokumente.RowCount - 1 do
  begin
    Ext := '.' + Trim(Grd_Dokumente.Cells[9, i]);
    if Ext = '.' then
      continue;
    FileIcon := _FileIconList.FileIcon(Ext);
    if FileIcon <> nil then
      Grd_Dokumente.AddIcon(0, i, FileIcon.Icon, haCenter, vaCenter);
  end;

end;

procedure TFrmExtDokumente.Btn_ZurueckClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TFrmExtDokumente.MAsuchen(aid: Integer): string;
var
  Query: TIBQuery;
begin
  result := '';

  Query := TIBQuery.Create(Self);

  with Query do
  begin
    Transaction := IBT_Edit;
    SQL.Clear;
    SQL.Add('select * from mitarbeiter where ma_DELETE != "T" and ma_id = :id ');
    ParamByName('id').asInteger := aid;
    Open;
    last;
    first;

    if RecordCount > 0 then
      result := FieldByName('MA_NAME').AsString;
    Close;
    Free;

  end;

end;

procedure TFrmExtDokumente.mnu_LoeschenClick(Sender: TObject);
begin
  Btn_LoeschenClick(Sender);
end;

// Drag & Drop
procedure TFrmExtDokumente.Grd_DokumenteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i1: Integer;
begin
  if Grd_Dokumente.RowCount = 0 then
    exit;

  if Grd_Dokumente.SelectedRowCount = 0 then
    exit;

  if not(DragDetectPlus(TWinControl(Sender))) then
    SelectedFileList(_SelectedFiles);

  if (DragDetectPlus(TWinControl(Sender))) then
  begin
    if _SelectedFiles.Count = 0 then
      exit;
    DropSource1.Files.Clear;

    for i1 := 0 to _SelectedFiles.Count - 1 do
    begin
      DropSource1.Files.Add(_SelectedFiles.ValueFromIndex[i1]);
    end;

    DropFileTarget1.Dragtypes := [];
    try

      // OK, now we are all set to go. Let's start the drag...
      // Grd_Dokumente.BeginUpdate;
      SendMessage(Grd_Dokumente.Handle, WM_LBUTTONUP, 0, 0);
      DropSource1.Execute;

    finally
      DropFileTarget1.Dragtypes := [dtCopy, dtMove, dtLink];
    end;

  end;
end;
procedure TFrmExtDokumente.SelectedFileList(aFileList: TStrings);
var
  i1: Integer;
  FullFileName: String;
  Id: Integer;
  Dokument : TExtDokument;
begin
  aFileList.Clear;
  if Grd_Dokumente.SelectedRowCount = 0 then
    exit;
  for i1 := 0 to Grd_Dokumente.SelectedRowCount - 1 do
  begin
    Id := StrToInt(Grd_Dokumente.Cells[10, Grd_Dokumente.SelectedRow[i1]]);
    Dokument := TExtDokument.Create(Self, Id, Stammdaten, IBT_Edit);
    try
      if Dokument.Found then
      begin
        FullFileName := TDokVerz.GetFullFileName(Dokument);
        aFileList.Add(IntToStr(Grd_Dokumente.SelectedRow[i1]) + '=' + FullFileName);
      end;
    finally
      FreeAndNil(Dokument);
    end;
  end;
end;

procedure TFrmExtDokumente.btn_SpeichernClick(Sender: TObject);
var
  FullFileName: String;
  Id: Integer;
  Dokument: TextDokument;
begin
  Id := IBQ_ExtDokumente.FieldByName('out_ED_ID').asInteger;
  Dokument := TExtDokument.Create(Self, Id, Stammdaten, IBT_Edit);
  try
    FullFileName := TDokVerz.GetFullFileName(Dokument);
    SaveDialog.FileName := Dokument.getTitel + LowerCase(ExtractFileExt(FullFileName));
    if SaveDialog.Execute then
    begin
      CopyFile(PWideChar(FullFileName), PWideChar(SaveDialog.FileName), false);
    end;
  finally
    FreeAndNil(Dokument);
  end;
end;

end.
