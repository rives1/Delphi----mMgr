program mMgr;

uses
  Vcl.Forms,
  frmMain in 'frmMain.pas' {MainFRM},
  frmLedger in 'frmLedger.pas' {LedgerFrm},
  frmInsEdit in 'frmInsEdit.pas' {InsEditFrm},
  pasCommon in 'pasCommon.pas',
  frmAccount in 'frmAccount.pas' {AccountFrm},
  frmChartAnalisys1 in 'frmChartAnalisys1.pas' {AnalisysFrm1},
  frmPayee in 'frmPayee.pas' {PayeeFRM},
  frmCategory in 'frmCategory.pas' {CategoryFrm},
  frmChartAnalisys2 in 'frmChartAnalisys2.pas' {AnalisysFrm2},
  frmTblBalYTD in 'frmTblBalYTD.pas' {tblBalanceFrm},
  Vcl.Themes,
  Vcl.Styles,
  frmChartAnalisys3 in 'frmChartAnalisys3.pas' {AnalisysFrm3},
  frmChartAnalisys4 in 'frmChartAnalisys4.pas' {AnalisysFrm4},
  frmTblPayeeYTD in 'frmTblPayeeYTD.pas' {tblPayeeFrm},
  frmTblSubcatYTD in 'frmTblSubcatYTD.pas' {tblSubcatFrm},
  frmImport in 'frmImport.pas' {ImportFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFRM, MainFRM);
  Application.CreateForm(TImportFrm, ImportFrm);
  Application.Run;
end.
