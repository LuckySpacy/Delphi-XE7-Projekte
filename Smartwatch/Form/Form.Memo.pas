unit Form.Memo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, tbButton, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  Tfrm_Memo = class(TForm)
    Panel1: TPanel;
    btn_Ok: TTBButton;
    btn_Abbruch: TTBButton;
    mem_Memo: TMemo;
    procedure btn_OkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_AbbruchClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fCancel: Boolean;
    procedure setMemoText(const Value: string);
  public
    property Cancel: Boolean read fCancel;
  end;

var
  frm_Memo: Tfrm_Memo;

implementation

{$R *.dfm}

procedure Tfrm_Memo.FormCreate(Sender: TObject);
begin
  fCancel := true;
  mem_Memo.Lines.Clear;
end;

procedure Tfrm_Memo.FormDestroy(Sender: TObject);
begin //

end;




procedure Tfrm_Memo.setMemoText(const Value: string);
begin
end;

procedure Tfrm_Memo.btn_AbbruchClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_Memo.btn_OkClick(Sender: TObject);
begin
  fCancel := false;
  close;
end;


procedure Tfrm_Memo.Button1Click(Sender: TObject);
begin
  fCancel := false;
  close;
end;

end.
