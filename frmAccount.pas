unit frmAccount;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, JvExButtons, JvBitBtn, JvExStdCtrls, JvCombobox,
  Vcl.ExtCtrls;

type
  TAccountFrm = class(TForm)
    _fSearch: TJvComboBox;
    _fType: TJvComboBox;
    Label2: TLabel;
    Label1: TLabel;
    Name: TLabel;
    _fName: TEdit;
    _fID: TEdit;
    btnOK: TJvBitBtn;
    Shape1: TShape;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    // variabili
    _plEditType: string;  // properties to define if the new record
    _plEditID:   integer; // defines which is the ID of the record in case of record editing
    _SQLString:  string;  // container x query string

    function _validateField: boolean;
    procedure _loadCmbSearch;
    procedure _loadRecord;
    procedure _recordSave;
    procedure _writeRecord;
    procedure _cleanFormNewRecord;

  public
    { Public declarations }

  published
    property _pEditType: string read _plEditType write _plEditType;
    property _pEditID:   integer read _plEditID write _plEditID;

  end;

var
  AccountFrm: TAccountFrm;

implementation

{$R *.dfm}


uses
  frmMain, pasCommon;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm.FormActivate(Sender: TObject);
begin
  if (_pEditType = 'edit') and (_pEditID <> 0) then
    _loadRecord // carico i dati nella form
  else
    if (_pEditType = 'new') then // nuova transazione generica
  begin
    _fType.SetFocus;
  end;

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
      begin
        if (MessageDlg('Close Form?', mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
          self.Close;
      end;
    127: // F12
      _recordSave;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm._cleanFormNewRecord;
begin
  _fName.Text := '';
  _fType.Text := 'Cash';
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm._loadCmbSearch;
begin
  // carico i dati nella compo dei payee
  _fSearch.Items.Clear;
  _SQLString := 'SELECT * FROM DBACCOUNT';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _fSearch.Items.Add(MainFRM.sqlQry.FieldValues['ACCNAME']);
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
  _SQLString := 'SELECT * FROM DBACCOUNT where ACCID = ' + IntToStr(_plEditID);
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _fID.Text   := IntToStr(_plEditID);
      _fType.Text := MainFRM.sqlQry.FieldValues['ACCTYPE'];
      _fName.Text := VarToStr(MainFRM.sqlQry.FieldValues['ACCNAME']);
      MainFRM.sqlQry.Next;
    end;

  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm._recordSave;
begin
  if _validateField then
  begin
    _writeRecord;
    // nel caso di editing di un record chiudo la form adesso
    if _pEditType = 'edit' then
      self.Close
    else
      _cleanFormNewRecord;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
function TAccountFrm._validateField: boolean;
begin
  Result := True;
  // verifica che i campi della mask siano compilati
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
  try
    MainFRM.sqlite_conn.StartTransaction;
    if (_pEditID = 0) then
      _SQLString := ' INSERT INTO DBACCOUNT (ACCTYPE, ACCNAME) '
        + ' VALUES ( ''' + _fType.Text + ''' '
        + ', ''' + _fName.Text + ''') '
    else
      _SQLString := 'UPDATE DBACCOUNT SET '
        + '  TRNTYPE = ''' + _fType.Text + ''' '
        + ', TRNDESCRIPTION = ''' + _fName.Text + ''' '
        + ' WHERE ACCID = ''' + IntToStr(_pEditID) + ''' ';

    MainFRM.sqlQry.ExecSQL(_SQLString);
    MainFRM.sqlite_conn.Commit;

  except
    raise Exception.Create('Error in Saving. Operation Aborted');
    MainFRM.sqlite_conn.Rollback;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//

end.
