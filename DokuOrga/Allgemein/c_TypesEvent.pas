unit c_TypesEvent;

interface

uses
  c_Types;

type
  TChangeBearbArtEvent = procedure (Sender: TObject; aBearbArt: TBearbArt) of object;
  TChangeObjectIdEvent = procedure (Sender: TObject; aId: Integer) of object;


implementation

end.
