unit frmAccount;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, JvExButtons, JvBitBtn, JvExStdCtrls, JvCombobox,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus;

type
  TAccountFrm = class(TForm)
    _fLvAccount: TListView;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    _fName: TEdit;
    _fID: TEdit;
    _fType: TJvComboBox;
    Name: TLabel;
    btnOK: TJvBitBtn;
    Splitter1: TSplitter;
    PopupMenu1: TPopupMenu;
    NewAccount1: TMenuItem;
    EditAccount1: TMenuItem;
    N1: TMenuItem;
    DeleteAccount1: TMenuItem;
    _fStatus: TJvComboBox;
    Label2: TLabel;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure JvBitBtn1Click(Sender: TObject);
    procedure _fLvAccountDblClick(Sender: TObject);
    procedure NewAccount1Click(Sender: TObject);
    procedure EditAccount1Click(Sender: TObject);
    procedure DeleteAccount1Click(Sender: TObject);
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
procedure TAccountFrm.DeleteAccount1Click(Sender: TObject);
begin
  _deleteAccount;
  _cleanFormNewRecord;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm.EditAccount1Click(Sender: TObject);
begin
  _loadRecord;
  _fName.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm.FormActivate(Sender: TObject);
begin
  _fLvAccount.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // MainFRM._treeMenuCreate;
  // disabilitato per la trasformazione della form in modale
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

procedure TAccountFrm.NewAccount1Click(Sender: TObject);
begin
  _cleanFormNewRecord;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm._cleanFormNewRecord;
begin
  _fID.Text     := '';
  _fName.Text   := '';
  _fType.Text   := '';
  _fStatus.Text := '';
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAccountFrm._deleteAccount;
begin
  _SQLString := 'SELECT * FROM LedgerView WHERE ACCNAME = ''' + _fLvAccount.Selected.Caption + ''' ';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlite_conn.StartTransaction;
    MainFRM.sqlQry.Open;
    if MainFRM.sqlQry.RecordCount > 0 then
      MessageDlg('Data alreay used in application. Impossible to delete.', mtInformation, [mbOk], 0)

    else
      if MessageDlg('Confirm Deletion of ' + _fLvAccount.Selected.Caption + '?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      _SQLString := 'DELETE FROM DBACCOUNT WHERE ACCNAME = ''' + _fLvAccount.Selected.Caption + ''' ';
      // esecuzione della query di cancellazione
      MainFRM.sqlQry.ExecSQL(_SQLString);
      MainFRM.sqlite_conn.Commit;
      MessageDlg(_fLvAccount.Selected.Caption + ' Deleted!!', mtInformation, [mbOk], 0);
    end;
    MainFRM.sqlQry.Close;

  except
    begin
      raise Exception.Create('Error in deleting ->' + _fLvAccount.Selected.Caption + '. Operation Aborted');
      MainFRM.sqlite_conn.Rollback;
    end;
  end;
  _loadLvAccount;
  _cleanFormNewRecord;
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
  _SQLString := ' Select '
    + ' DBACCOUNT.ACCNAME, '
    + ' DBACCOUNT.ACCTYPE, '
    + ' DBACCOUNT.ACCSTATUS, '
    + ' Sum(Abs(TRANSACTIONS.TRNAMOUNT)) As Sum_TRNAMOUNT '
    + ' From DBACCOUNT '
    + ' Left Join TRANSACTIONS On DBACCOUNT.ACCID = TRANSACTIONS.TRNACCOUNT '
    + ' Group By DBACCOUNT.ACCNAME, '
    + ' DBACCOUNT.ACCTYPE, '
    + ' DBACCOUNT.ACCSTATUS ';


  // 'SELECT * FROM DBACCOUNT';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _lvItem         := _fLvAccount.Items.Add;
      _lvItem.Caption := VarToStr(MainFRM.sqlQry.FieldValues['ACCNAME']);
      if (MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'] = null) then
        _lvItem.SubItems.Add(FormatFloat('#,##0.00', 0))
      else
        _lvItem.SubItems.Add(FormatFloat('#,##0.00', MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']));

      // imposto il gruppo nella listview
      if (MainFRM.sqlQry.FieldValues['ACCTYPE'] = 'Checking') then
        _lvItem.GroupID := 0;
      if (MainFRM.sqlQry.FieldValues['ACCTYPE'] = 'Cash') then
        _lvItem.GroupID := 1;
      if (MainFRM.sqlQry.FieldValues['ACCTYPE'] = 'CreditCard') then
        _lvItem.GroupID := 2;
      if (MainFRM.sqlQry.FieldValues['ACCTYPE'] = 'Online') then
        _lvItem.GroupID := 3;

      // visualizzazione logica - evidenzio e raggruppo iconti chiusi senza modificare i dati del db
      if (Uppercase(MainFRM.sqlQry.FieldValues['ACCSTATUS']) = 'CLOSED') then
        _lvItem.GroupID := 4;

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
      _fID.Text     := MainFRM.sqlQry.FieldValues['ACCID'];
      _fType.Text   := MainFRM.sqlQry.FieldValues['ACCTYPE'];
      _fName.Text   := VarToStr(MainFRM.sqlQry.FieldValues['ACCNAME']);
      _fStatus.Text := VarToStr(MainFRM.sqlQry.FieldValues['ACCSTATUS']);

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
    _cleanFormNewRecord;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
function TAccountFrm._validateField: Boolean;
begin
  // verifica che i campi della mask siano compilati
  Result := True;
  if (_fType.Text = '') or (_fName.Text = '') or (_fStatus.Text = '') then
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
      _SQLString := ' INSERT INTO DBACCOUNT (ACCTYPE, ACCNAME, ACCSTATUS) '
        + ' VALUES ( ''' + _fType.Text + ''' '
        + ', ''' + _fName.Text + ''' '
        + ', ''' + _fStatus.Text + ''' ) '
    else
      _SQLString := 'UPDATE DBACCOUNT SET '
        + '  ACCTYPE = ''' + _fType.Text + ''' '
        + ', ACCNAME = ''' + _fName.Text + ''' '
        + ', ACCSTATUS = ''' + _fStatus.Text + ''' '
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
