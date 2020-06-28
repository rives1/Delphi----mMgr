unit frmImport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, JvExStdCtrls, JvCombobox, Vcl.ExtCtrls, Vcl.Buttons,
  JvExButtons, JvBitBtn;

type
  TImportFrm = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Label7: TLabel;
    _fAccountTo: TJvComboBox;
    btnBrowse: TJvBitBtn;
    _fImportFileName: TEdit;
    Label1: TLabel;
    _btnImport: TJvBitBtn;
  private
    { Private declarations }
    // variabili
    _SQLString: string; // container x query string

    // local procedures
    procedure _loadCmbAccounts;

  public
    { Public declarations }
  end;

var
  ImportFrm: TImportFrm;

implementation

{$R *.dfm}


uses
  frmMain;

// -------------------------------------------------------------------------------------------------------------//
procedure TImportFrm._loadCmbAccounts;
begin
  // carico i dati nella compo dei payee
  _fAccountTo.Items.Clear;
  _SQLString := 'SELECT ACCNAME FROM DBACCOUNT WHERE UCASE(ACCSTATUS) = ''OPEN'' ORDER BY ACCNAME';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _fAccountTo.Items.Add(MainFRM.sqlQry.FieldValues['ACCNAME']);
      MainFRM.sqlQry.Next;
    end;
  finally
    // _fAccountTo.items.AddStrings(_fAccountFrom.Items); //aggiungo l'elenco in massa prendendolo dal campo riempito
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;
end;
// -------------------------------------------------------------------------------------------------------------//

end.
