unit fnt_Progress;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, tbButton;

type
  Tfrm_Progress = class(TForm)
    pb: TProgressBar;
    Label1: TLabel;
    btn_Cancel: TTBButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
  private
    FCancel: Boolean;
  public
    procedure CopyFileWithProgressBar(Source, Destination: string);
    property Cancel: Boolean read FCancel;
  end;

var
  frm_Progress: Tfrm_Progress;

implementation

{$R *.dfm}


procedure Tfrm_Progress.FormCreate(Sender: TObject);
begin
  FCancel := false;
end;



procedure Tfrm_Progress.btn_CancelClick(Sender: TObject);
begin
  FCancel := true;
end;

procedure Tfrm_Progress.CopyFileWithProgressBar(Source, Destination: string);
var
  FromF, ToF: file of byte;
  Buffer: array[0..4096] of char;
  NumRead: integer;
  FileLength: longint;
begin
  if SameText(Source, Destination) then
    exit;
  AssignFile(FromF, Source);
  reset(FromF);
  AssignFile(ToF, Destination);
  rewrite(ToF);
  FileLength := FileSize(FromF);
  with pb do
  begin
    Min := 0;
    Max := FileLength;
    while FileLength > 0 do
    begin
      BlockRead(FromF, Buffer[0], SizeOf(Buffer), NumRead);
      FileLength := FileLength - NumRead;
      BlockWrite(ToF, Buffer[0], NumRead);
      Position := Position + NumRead;
      Application.ProcessMessages;
      if FCancel then
        break;
    end;
    CloseFile(FromF);
    CloseFile(ToF);
  end;
end;


end.
