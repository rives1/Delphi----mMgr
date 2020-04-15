unit frmAccount;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, JvExButtons, JvBitBtn, JvExStdCtrls, JvCombobox,
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TAccountFrm = class(TForm)
    _fLvAccount: TListView;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    _fName: TEdit;
    _fID: TEdit;
    _fType: TJvComboBox;
    Name: TLabel;
    Label2: TLabel;
    btnOK: TJvBitBtn;
    JvBitBtn1: TJvBitBtn;
    JvBitBtn2: TJvBitBtn;
    Splitter1: TSplitter;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure JvBitBtn1Click(Sender: TObject);
    procedure _fLvAccountDblClick(Sender: TObject);
  private
    { Private declarations }
    // variabili
    _SQLString: string; // container x query string

    function _validateField: Boolean;
    procedure _loadLvAccount;
    procedure _loadRecord;
    procedure _recordSave;
    procedure _writeRecord;
    procedure _cleanFormNewRecord;
    procedure _deleteAccount;

  public
    { Public declarations }

  published

  end;

var
  AccountFrm: TAccountFrm;

implementation

{$R *.dfm}


uses
  frmMain, pasCommon;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm.btnOKClick(Sender: TObject);
begin
  _recordSave;
  _fLvAccount.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm.FormActivate(Sender: TObject);
begin
  _fLvAccount.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // gestione pressione tasti
  // ESC - chiudo la form
  // F12 - salvo il record
  case Key of
    27: // ESC
      if (MessageDlg('Close Form?', mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
        self.Close;
    127: // F12
      _recordSave;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm.FormShow(Sender: TObject);
begin
  _loadLvAccount;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm.JvBitBtn1Click(Sender: TObject);
begin
  _deleteAccount;
  _cleanFormNewRecord;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm._cleanFormNewRecord;
begin
  _fID.Text   := '';
  _fName.Text := '';
  _fType.Text := '';
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm._deleteAccount;
begin
  { TODO :
    definire procedura cancellazione record
    NB: effettuare check se ci sono record correlati nelle transazioni }
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm._fLvAccountDblClick(Sender: TObject);
begin
  _loadRecord;
  _fName.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm._loadLvAccount;
var
  _lvItem: TListItem;
begin
  // carico i dati nella compo dei conti
  _fLvAccount.Items.Clear;
  _SQLString := 'SELECT * FROM DBACCOUNT';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _lvItem         := _fLvAccount.Items.Add;
      _lvItem.Caption := VarToStr(MainFRM.sqlQry.FieldValues['ACCNAME']);
      if (MainFRM.sqlQry.FieldValues['ACCTYPE'] = 'Checking') then
        _lvItem.GroupID := 0;
      if (MainFRM.sqlQry.FieldValues['ACCTYPE'] = 'Cash') then
        _lvItem.GroupID := 1;
      if (MainFRM.sqlQry.FieldValues['ACCTYPE'] = 'CreditCard') then
        _lvItem.GroupID := 2;
      if (MainFRM.sqlQry.FieldValues['ACCTYPE'] = 'Online') then
        _lvItem.GroupID := 3;

      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm._loadRecord;
begin
  // dopo la selezione della
  _SQLString := 'SELECT * FROM DBACCOUNT where ACCNAME = ''' + _fLvAccount.Selected.Caption + ''' ';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _fID.Text   := MainFRM.sqlQry.FieldValues['ACCID'];
      _fType.Text := MainFRM.sqlQry.FieldValues['ACCTYPE'];
      _fName.Text := VarToStr(MainFRM.sqlQry.FieldValues['ACCNAME']);
      MainFRM.sqlQry.Next;
    end;

  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
    _SQLString := '';
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm._recordSave;
begin
  if _validateField then
  begin
    _writeRecord;
    _loadLvAccount;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
function TAccountFrm._validateField: Boolean;
begin
  // verifica che i campi della mask siano compilati
  Result := True;
  if (_fType.Text = '')
    or (_fName.Text = '') then
  begin
    MessageDlg('Data field incomplete!!', mtInformation, [mbOk], 0);
    Result := False;
  end
  else
  begin
    if MessageDlg('Save Record?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Result := False;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm._writeRecord;
begin
  // salvo il record
  try
    MainFRM.sqlite_conn.StartTransaction;
    if (_fID.Text = '') then
      _SQLString := ' INSERT INTO DBACCOUNT (ACCTYPE, ACCNAME) '
        + ' VALUES ( ''' + _fType.Text + ''' '
        + ', ''' + _fName.Text + ''') '
    else
      _SQLString := 'UPDATE DBACCOUNT SET '
        + '  ACCTYPE = ''' + _fType.Text + ''' '
        + ', ACCNAME = ''' + _fName.Text + ''' '
        + ' WHERE ACCID = ''' + _fID.Text + ''' ';

    MainFRM.sqlQry.ExecSQL(_SQLString);
    MainFRM.sqlite_conn.Commit;

  except
    raise Exception.Create('Error in Saving. Operation Aborted');
    MainFRM.sqlite_conn.Rollback;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//

end.
