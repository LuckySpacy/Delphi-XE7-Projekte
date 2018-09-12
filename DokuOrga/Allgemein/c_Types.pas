unit c_Types;

interface

type
  TBearbArt = (cNeu, cSpeichern, cLoeschen, cAbbrechen, cUndefiniert, cBearb);
  TModus = (cUnbekannt, cNormal, cLink);
  TImportExport = (cImport, cExport);
  TSeiteLinkTyp = (csl_Seite, csl_Dokument);


type
  TNotifyStatus = Record
    Art: TBearbArt;
    Enabled: Boolean;
    Visible: Boolean;
  End;
  PNotifyStatus = ^TNotifyStatus;





implementation

end.
