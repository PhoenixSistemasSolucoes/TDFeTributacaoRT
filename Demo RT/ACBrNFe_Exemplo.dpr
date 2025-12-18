program ACBrNFe_Exemplo;

uses
  Forms,
  Frm_ACBrNFe in 'Frm_ACBrNFe.pas' {frmACBrNFe},
  Frm_SelecionarCertificado in 'Frm_SelecionarCertificado.pas' {frmSelecionarCertificado},
  Frm_ConfiguraSerial in 'Frm_ConfiguraSerial.pas' {frmConfiguraSerial},
  Frm_Status in 'Frm_Status.pas' {frmStatus},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Tablet Dark');
  Application.CreateForm(TfrmACBrNFe, frmACBrNFe);
  Application.CreateForm(TfrmSelecionarCertificado, frmSelecionarCertificado);
  Application.CreateForm(TfrmConfiguraSerial, frmConfiguraSerial);
  Application.CreateForm(TfrmStatus, frmStatus);
  Application.Run;
end.
