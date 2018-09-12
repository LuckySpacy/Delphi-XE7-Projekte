unit of_konf_base;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, fr_Base,
  of_Base, c_Types, o_sysObj, obBusinessClasses, obServerClient, contnrs;

type
  Tof_Konf_Base = class(Tof_Base, IObServerClient)
  private
    FBaseFrame: Tfrm_Base;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
  protected
    procedure DoVisibleChanged(Sender: TObject);
    procedure Save; virtual; abstract;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

implementation

{ Tof_Konf_Base }

constructor Tof_Konf_Base.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FBaseFrame := nil;
  if AOwner is Tfrm_Base then
  begin
    Tfrm_Base(AOwner).OnVisibleChanged := DoVisibleChanged;
    FBaseFrame := Tfrm_Base(AOwner);
  end;
end;

destructor Tof_Konf_Base.Destroy;
begin
  inherited;
end;

procedure Tof_Konf_Base.DoVisibleChanged(Sender: TObject);
begin
  if not FBaseFrame.Visible then
    Save;
end;

procedure Tof_Konf_Base.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin

end;

end.
