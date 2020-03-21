program mMgr;

uses
  Vcl.Forms,
  frmMain in 'frmMain.pas' {MainFRM},
  frmLedger in 'frmLedger.pas' {LedgerFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFRM, MainFRM);
  Application.Run;
end.
