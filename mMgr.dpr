program mMgr;

uses
  Vcl.Forms,
  frmMain in 'frmMain.pas' {MainFRM},
  frmLedger in 'frmLedger.pas' {LedgerFrm},
  frmInsEdit in 'frmInsEdit.pas' {InsEditFrm},
  pasCommon in 'pasCommon.pas',
  frmAccount in 'frmAccount.pas' {AccountFrm},
  frmChartAnalisys in 'frmChartAnalisys.pas' {AnalisysFrm},
  frmPayee in 'frmPayee.pas' {PayeeFRM},
  frmCategory in 'frmCategory.pas' {CategoryFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFRM, MainFRM);
  Application.Run;
end.
