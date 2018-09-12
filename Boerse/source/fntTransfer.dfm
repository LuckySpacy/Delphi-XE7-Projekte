inherited frm_Transfer: Tfrm_Transfer
  Caption = 'Transfer'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnl_Button: TPanel
    inherited cmd_Ok: TButton
      OnClick = cmd_OkClick
    end
  end
end
