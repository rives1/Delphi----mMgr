program Cmix3;

uses
  Forms,
  FRMMain in 'FRMMain.pas' {MainFRM},
  FRMIssue in 'FRMIssue.pas' {IssueFRM},
  pasCommon in 'pasCommon.pas',
  FRMPrt in 'FRMPrt.pas' {PrtFRM},
  SQLite in 'SQLite.pas',
  pasSqlDB in 'pasSqlDB.pas',
  pasCSVImport in 'pasCSVImport.pas',
  FRMBulkInsert in 'FRMBulkInsert.pas' {BulkInsertFRM};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'C.Mix 3';
  Application.CreateForm(TMainFRM, MainFRM);
  Application.Run;
end.
