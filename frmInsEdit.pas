unit frmInsEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.Mask, JvExMask, JvToolEdit, JvMaskEdit, JvExStdCtrls, JvEdit, JvValidateEdit,
  Vcl.ComCtrls, JvExComCtrls, JvDateTimePicker, Vcl.StdCtrls, Vcl.Buttons, JvExButtons, JvBitBtn, JvCombobox,
  RzEdit,
  RzDTP;

type
  TInsEditFrm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    _fType: TJvComboBox;
    _fID: TEdit;
    _fDescription: TEdit;
    _fPayee: TJvComboBox;
    _fCategory: TJvComboBox;
    _fSubCategory: TJvComboBox;
    _fAmount: TJvValidateEdit;
    _fAccountTo: TJvComboBox;
    _fAccountFrom: TJvComboBox;
    btnOK: TJvBitBtn;
    StatusBar1: TStatusBar;
    _fDate: TRzDateTimeEdit;
    _fLastTransaction: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure _fSubCategoryExit(Sender: TObject);
    procedure _fCategoryExit(Sender: TObject);
    procedure _fTypeExit(Sender: TObject);
    procedure _fPayeeExit(Sender: TObject);
    procedure _fSubCategoryEnter(Sender: TObject);
    procedure _fCategorySelect(Sender: TObject);
    procedure _fDateEnter(Sender: TObject);

  private
    { Private declarations }

    // variabili
    _plEditType:   string;  // properties to define if the new record
    _plLedgerName: string;  // properties for account ID
    _plEditID:     integer; // defines which is the ID of the record in case of record editing
    _SQLString:    string;  // container x query string

    // costanti
  const
    _TrxText: string = '_Transfer';

    // local functions
    function _validateField(_pConfirmation: boolean): boolean;
    function _newCategory: boolean;
    function _newSubCategory: boolean;
    function _newPayee: boolean;
    // local procedures
    procedure _loadCmbAccounts;
    procedure _loadCmbPayee;
    procedure _loadCmbCategory;
    procedure _loadCmbSubcategory;
    procedure _recordLoad;
    procedure _writeRecord;
    procedure _recordSave(_pConfirmation: boolean);
    procedure _getRecentData;
    procedure _cleanFormNewRecord;
    procedure _changeType; // impostazioni da inserire sulla mask al cambio del tipo di movimento
    procedure _lastTransactionInfo;
    // compilo il memo a piede della form con i dati dell'ultima transazione eseguita

  public
    { Public declarations }

  published
    property _pEditType:   string read _plEditType write _plEditType;
    property _pEditID:     integer read _plEditID write _plEditID;
    property _pLedgerName: string read _plLedgerName write _plLedgerName;
    // property _pAccountName: string read _plAccountName write _plAccountName;

  end;

var
  InsEditFrm: TInsEditFrm;

implementation

{$R *.dfm}


uses
  frmMain, frmLedger, pasCommon;

{ TInsEditFrm }

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm.btnOKClick(Sender: TObject);
begin
  _recordSave(True);
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // gestione pressione tasti
  // ESC - chiudo la form
  // F12 - salvo il record
  case Key of
    vkEscape: // ESC
      begin
        if (MessageDlg('Close Form?', mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
          self.Close;
      end;
    vkF12: // F12
      _recordSave(False);
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm.FormShow(Sender: TObject);
begin
  _loadCmbPayee;
  _loadCmbCategory;
  _loadCmbAccounts;
  _fAccountFrom.Text := _pLedgerName;

  if (_pEditType = 'edit') and (_pEditID <> 0) then
    _recordLoad // carico i dati nella form
  else
  begin
    _fAccountFrom.Text := _pLedgerName; // impostazione conto su cui inserire le transazioni

    if (_pEditType = 'newExp') or (_pEditType = 'new') then // nuova spesa o transaz generica
      _fType.Text := 'Pay';

    if (_pEditType = 'newDep') then // nuovo deposito
      _fType.Text := 'Deposit';

    if (_pEditType = 'newTrx') then // nuovo trasferimento
      _fType.Text := 'Transfer';

  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._changeType;
begin
  if (UpperCase(_fType.Text) = 'TRANSFER') then
  begin
    _fAccountTo.Enabled   := True;
    _fPayee.Enabled       := False;
    _fCategory.Enabled    := False;
    _fSubCategory.Enabled := False;
    _fPayee.Text          := _TrxText;
    _fCategory.Text       := _TrxText;
    _fSubCategory.Text    := _TrxText;
  end
  else
  begin
    _fAccountTo.Enabled   := False;
    _fPayee.Enabled       := True;
    _fCategory.Enabled    := True;
    _fSubCategory.Enabled := True;
    if _pEditType <> 'edit' then // azzero i campi se non sto modificando il record
    begin
      _fAccountTo.Text   := '';
      _fPayee.Text       := '';
      _fCategory.Text    := '';
      _fSubCategory.Text := '';
    end;

  end;

  // focus su data
  // _fType.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._cleanFormNewRecord;
begin
  /// ripulisco la form per inserire il prox recod
  _loadCmbCategory;
  _fAccountFrom.Text := _pLedgerName;
  _fPayee.Text       := '';
  _fSubCategory.Text := '';
  _fDescription.Text := '';
  _fAmount.Value     := 0;
  _fType.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._fCategoryExit(Sender: TObject);
begin
  if not _newCategory then
    _fCategory.SetFocus
  else
    if (_fSubCategory.Text = '') and (_fSubCategory.Items.Count > 0) then
    _fSubCategory.Text := _fSubCategory.Items[0];
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._fCategorySelect(Sender: TObject);
begin
  _fSubCategory.Text := '';
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._fDateEnter(Sender: TObject);
begin
  if (_fDate.Date = EncodeDate(1899, 12, 30)) then
    _fDate.Date := Now;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._fPayeeExit(Sender: TObject);
begin
  // verfico che il valore sia selezionato fra quelli presenti e recupero le info dei dati + recenti
  if (_fPayee.Items.IndexOf(UpperCase(_fPayee.Text)) <> -1)
    and (_fPayee.Text <> '') then
    _getRecentData
  else
    // inserisce il nuovo payee
    if not _newPayee then
      _fPayee.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._fSubCategoryEnter(Sender: TObject);
begin
  // _fSubCategory.DroppedDown:=True;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._fSubCategoryExit(Sender: TObject);
begin
  if not _newSubCategory then
    _fSubCategory.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._fTypeExit(Sender: TObject);
begin
  if (_fType.Items.IndexOf(_fType.Text) = -1) or (_fType.Text = '') then
    _fType.SetFocus
  else
    _changeType;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._getRecentData;
begin
  { *if exiting the field(and it's a new record) there is a value in the combo i look for the latest data coming
    * with that payee and propose the following fields
    * category
    * subcategory
    * description
    * amount
  }
  if (_pEditID = 0) and (_fPayee.Text <> '') then
  // if it's not editing a previous record
  begin
    _SQLString :=
      'SELECT LedgerView.CATDES, LedgerView.SUBCDES, LedgerView.TRNDESCRIPTION, LedgerView.TRNAMOUNT '
      + ' FROM LedgerView ' + ' WHERE LedgerView.PAYNAME = ''' + _fPayee.Text + ''' '
      + ' ORDER BY LedgerView.TRNDATE DESC ';
    MainFRM.sqlQry.SQL.Clear;
    MainFRM.sqlQry.SQL.Add(_SQLString);
    try
      MainFRM.sqlQry.Open;
      // if i find a record the DESC order shows the most recent payee data
      if MainFRM.sqlQry.RecordCount > 0 then // recupero il primo record
      begin
        _fCategory.Text    := MainFRM.sqlQry.FieldValues['CATDES'];
        _fSubCategory.Text := MainFRM.sqlQry.FieldValues['SUBCDES'];
        _fDescription.Text := MainFRM.sqlQry.FieldValues['TRNDESCRIPTION'];
        _fAmount.Text      :=
          FloatToStr(Abs(MainFRM.sqlQry.FieldValues['TRNAMOUNT']));
      end
      else // se il payee è nuovo i campi devono essere vuoti/svuotati nel caso di cambio di payees selezionato in precedenza
      begin
        _fCategory.Text    := '';
        _fSubCategory.Text := '';
        _fDescription.Text := '';
        _fAmount.Value     := 0;
      end;

    finally
      MainFRM.sqlQry.Close;
      MainFRM.sqlQry.SQL.Clear;
    end;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._loadCmbPayee;
begin
  // carico i dati nella compo dei payee
  _fPayee.Items.Clear;
  _SQLString := 'SELECT * FROM DBPAYEE WHERE PAYNAME <> ''_TRANSFER'' ';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _fPayee.Items.Add(MainFRM.sqlQry.FieldValues['PAYNAME']);
      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._lastTransactionInfo;
begin
  _fLastTransaction.Text := 'Last Transaction: ' + _fType.Text
    + ' - ' + DateToStr(_fDate.Date)
    + ' - ' + 'Amt: ' + _fAmount.Text
    + ' - ' + 'Payee: ' + _fPayee.Text;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._loadCmbAccounts;
begin
  // carico i dati nella compo dei payee
  _fAccountFrom.Items.Clear;
  _fAccountTo.Items.Clear;
  _SQLString := 'SELECT ACCNAME FROM DBACCOUNT WHERE UCASE(ACCSTATUS) = ''OPEN'' ORDER BY ACCNAME';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      // aggiungo solo gli account che non sono quelli del ledger aperto per evitare autotrasferimenti
      if (MainFRM.sqlQry.FieldValues['ACCNAME'] <> _plLedgerName) then
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
procedure TInsEditFrm._loadCmbCategory;
begin
  // carico i dati nella combo categorie
  _fCategory.Items.Clear;
  _fCategory.Text := '';
  _SQLString      := 'SELECT * FROM DBCATEGORY WHERE UCASE(CATDES) <> ''_TRANSFER'' ';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _fCategory.Items.Add(MainFRM.sqlQry.FieldValues['CATDES']);
      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._loadCmbSubcategory;
begin
  // carico i dati nella subcategory in base alla selezione della categoria
  _fSubCategory.Items.Clear;
  // _fSubCategory.Text := '';
  _SQLString := 'SELECT * FROM DBCATEGORY INNER JOIN DBSUBCATEGORY ON DBCATEGORY.CATID = '
    + ' DBSUBCATEGORY.SUBCATID WHERE UCASE(SUBCDES) <> ''_TRANSFER''  and DBCATEGORY.CATDES = '''
    + _fCategory.Text + ''' ;';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _fSubCategory.Items.Add(MainFRM.sqlQry.FieldValues['SUBCDES']);
      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._recordLoad;
var
  _trxID: string; // rif recupero mov correalto trasferimento
begin
  // carico i dati nella mask se si tratta di editing di record
  _SQLString := 'SELECT * FROM LedgerView where TRNID = ' + IntToStr(_plEditID);
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _fID.Text          := IntToStr(_plEditID);
      _fType.Text        := MainFRM.sqlQry.FieldValues['TRNTYPE'];
      _fDate.Date        := VarToDateTime(MainFRM.sqlQry.FieldValues['TRNDATE']);
      _fPayee.Text       := VarToStr(MainFRM.sqlQry.FieldValues['PAYNAME']);
      _fCategory.Text    := VarToStr(MainFRM.sqlQry.FieldValues['CATDES']);
      _fSubCategory.Text := VarToStr(MainFRM.sqlQry.FieldValues['SUBCDES']);
      _fDescription.Text := VarToStr(MainFRM.sqlQry.FieldValues['TRNDESCRIPTION']);
      _fAmount.Value     := Abs(MainFRM.sqlQry.FieldValues['TRNAMOUNT']);
      _fAccountFrom.Text := _plLedgerName;
      _fAccountTo.Text   := '';
      if (MainFRM.sqlQry.FieldValues['TRNTRANSFERID'] <> null) then
        _trxID := MainFRM.sqlQry.FieldValues['TRNTRANSFERID'];
      MainFRM.sqlQry.Next;
    end;
    MainFRM.sqlQry.Close;

    /// se il mov è di trasferimento devo recuperare le informazioni del conto di destinazione che è
    /// sul mov correlato
    if (_trxID <> '') then
    begin
      _SQLString := 'Select DBACCOUNT.ACCNAME From  TRANSACTIONS '
        + ' Inner Join DBACCOUNT On DBACCOUNT.ACCID = TRANSACTIONS.TRNACCOUNT '
        + ' Where TRANSACTIONS.TRNID = ' + _trxID;
      MainFRM.sqlQry.SQL.Clear;
      MainFRM.sqlQry.SQL.Add(_SQLString);
      MainFRM.sqlQry.Open;
      if MainFRM.sqlQry.RecordCount > 0 then // ciclo recupero dati
        _fAccountTo.Text := MainFRM.sqlQry.FieldValues['ACCNAME'];
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;
  // aggiorno i dati della combo subcategory
  _loadCmbSubcategory;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._recordSave(_pConfirmation: boolean);
begin
  if _validateField(_pConfirmation) then
  begin
    // _newPayee; //il nuovo payee viene inserito all'atto dell'uscita dal campo del payee stesso
    _writeRecord;
    // aggiorno il campo con il rif all'ultima transazione
    _lastTransactionInfo;
    // nel caso di editing di un record chiudo la form adesso
    if _pEditType = 'edit' then
      self.Close
    else
    begin
      _cleanFormNewRecord;
      // _changeType;
    end;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._writeRecord;
var
  _lAmount: string; // ammontare da inserire nel db. pos o neg in base al tipo di spesa
  _lAmountTransfer: string;// ammontare negativo da inserie nel DB . solo in caso di trasferimento
  // _lCategoryType: string;  // tipo categoria
  // _lrecID:        integer; // id del record per inserire i riferimenti sui mov trasferimento
begin

  // il valore deve essere ngativo se la il tipo di transazione è pay
  if UpperCase(_fType.Text) = 'DEPOSIT' then
    begin
    _lAmount := StringReplace(VarToStr((_fAmount.Value)), ',', '.', [rfReplaceAll]);
    _lAmountTransfer := StringReplace(VarToStr((_fAmount.Value) * -1), ',', '.', [rfReplaceAll]);
    end
  else
    begin
    _lAmount := StringReplace(VarToStr((_fAmount.Value) * -1), ',', '.', [rfReplaceAll]);
    _lAmountTransfer := StringReplace(VarToStr((_fAmount.Value)), ',', '.', [rfReplaceAll]);
    end;


  //   messagedlg(FloatToStr(StrToFloat(_lAmount) * -1), mtInformation, [mbOk], 0);

  // salvataggio del record in base alla tipologia di editing
  try
    MainFRM.sqlite_conn.StartTransaction;
    if (_pEditID = 0) then
      _SQLString := ' INSERT INTO TRANSACTIONS (TRNTYPE, TRNDATE, TRNPAYEE, TRNSUBCATEGORY, '
        + ' TRNAMOUNT, TRNACCOUNT, TRNDESCRIPTION) ' +
      // _SQLString := ' INSERT INTO TRANSACTIONS (TRNTYPE, TRNDATE, TRNPAYEE, TRNCATEGORY, TRNSUBCATEGORY, '
      // + ' TRNAMOUNT, TRNACCOUNT, TRNDESCRIPTION) ' +
      // ' VALUES (:pType, :pDate, :pPayee, :pCategory, :pSubcat, :pAmount, :pAccount, :pDes)'
        ' VALUES ( ''' + _fType.Text + ''' '
        + ', ''' + FormatDateTime('yyyy-mm-dd', _fDate.Date) + ''' '
        + ', ''' + _getDBField('DBPAYEE', 'PAYID', 'PAYNAME', _fPayee.Text) + ''' '
      // + ', ''' + _getDBField('DBCATEGORY', 'CATID', 'CATDES', _fCategory.Text) + ''' '
        + ', ''' + _getDBField('DBSUBCATEGORY', 'SUBCID', 'SUBCDES', _fSubCategory.Text) + ''' '
        + ', ''' + _lAmount + ''' '
        + ', ''' + _getDBField('DBACCOUNT', 'ACCID', 'ACCNAME', _plLedgerName) + ''' '
        + ', ''' + _fDescription.Text + ''') '
    else
      _SQLString := 'UPDATE TRANSACTIONS SET ' + '  TRNTYPE = ''' + _fType.Text + ''' '
        + ', TRNDATE = datetime(''' + FormatDateTime('yyyy-mm-dd', _fDate.Date) + ''') '
        + ', TRNPAYEE = ''' + _getDBField('DBPAYEE', 'PAYID', 'PAYNAME', _fPayee.Text) + ''' '
      // + ', TRNCATEGORY =  ''' + _getDBField('DBCATEGORY', 'CATID', 'CATDES', _fCategory.Text) + ''' '
        + ', TRNSUBCATEGORY = ''' + _getDBField('DBSUBCATEGORY', 'SUBCID', 'SUBCDES', _fSubCategory.Text) + ''' '
        + ', TRNAMOUNT = ''' + _lAmount + ''' '
        + ', TRNACCOUNT = ''' + _getDBField('DBACCOUNT', 'ACCID', 'ACCNAME', _plLedgerName) + ''' '
        + ', TRNDESCRIPTION = ''' + _fDescription.Text + ''' '
        + ' WHERE TRNID = ''' + IntToStr(_pEditID) + ''' ';
    MainFRM.sqlQry.ExecSQL(_SQLString);

    /// gestione trasferimenti
    /// il trx inserisce un mov di scarico e quindi uno di carico
    /// dopo il carico eseguo query di recupero dell'ultimo id e lo inserisco nel campo trasferID
    /// della tabella transazioni
    if (UpperCase(_fType.Text) = 'TRANSFER') then
      if (_pEditID = 0) then // nuovo trasferimento
      // try
      begin
        // inserisco il movimento con valore inverso su conto definito in mask
        // _SQLString := ' INSERT INTO TRANSACTIONS (TRNTYPE, TRNDATE, TRNPAYEE, TRNCATEGORY, TRNSUBCATEGORY, TRNAMOUNT, '
        // + ' TRNACCOUNT, TRNDESCRIPTION) '
        _SQLString := ' INSERT INTO TRANSACTIONS (TRNTYPE, TRNDATE, TRNPAYEE, TRNSUBCATEGORY, TRNAMOUNT, '
          + ' TRNACCOUNT, TRNDESCRIPTION) '
          + ' VALUES ( ''' + _fType.Text + ''' '
          + ', ''' + FormatDateTime('yyyy-mm-dd', _fDate.Date) + ''' '
          + ', ''' + _getDBField('DBPAYEE', 'PAYID', 'PAYNAME', _fPayee.Text) + ''' '
        // + ', ''' + _getDBField('DBCATEGORY', 'CATID', 'CATDES', _fCategory.Text) + ''' '
          + ', ''' + _getDBField('DBSUBCATEGORY', 'SUBCID', 'SUBCDES', _fSubCategory.Text) + ''' '
//          + ', ''' + FloatToStr(StrToFloat(_lAmount) * -1) + ''' ' // inverto il segno del movimento
          + ', ''' + _lAmountTransfer + ''' '
          + ', ''' + _getDBField('DBACCOUNT', 'ACCID', 'ACCNAME', _fAccountTo.Text) + ''' '
        // conto di destinazione
          + ', ''' + _fDescription.Text + ''') ';
        MainFRM.sqlQry.ExecSQL(_SQLString);

        // aggiorno l'ultimo record con l'ID del penultimo
        _SQLString := 'update TRANSACTIONS set TRNTRANSFERID = (SELECT max(TRNID) FROM Transactions) - 1'
          + ' where TRNID = (SELECT max(TRNID) FROM Transactions)';
        MainFRM.sqlQry.ExecSQL(_SQLString);
        // aggiorno il penultimo record con l'ID dell'ultimo
        _SQLString := 'update TRANSACTIONS set TRNTRANSFERID = (SELECT max(TRNID) FROM Transactions)'
          + ' where TRNID = (SELECT max(TRNID) FROM Transactions) - 1';
        // eseguo l'aggiornamento
        MainFRM.sqlQry.ExecSQL(_SQLString);
      end
      else
      begin
        // aggiorno trasferimento -- aggiorno il movimento correlato
        _SQLString := 'UPDATE TRANSACTIONS SET ' + '  TRNTYPE = ''' + _fType.Text + ''' '
          + ', TRNDATE = datetime(''' + FormatDateTime('yyyy-mm-dd', _fDate.Date) + ''') '
          + ', TRNPAYEE = ''' + _getDBField('DBPAYEE', 'PAYID', 'PAYNAME', _fPayee.Text) + ''' '
        // + ', TRNCATEGORY =  ''' + _getDBField('DBCATEGORY', 'CATID', 'CATDES', _fCategory.Text) + ''' '
          + ', TRNSUBCATEGORY = ''' + _getDBField('DBSUBCATEGORY', 'SUBCID', 'SUBCDES', _fSubCategory.Text) + ''' '
//          + ', TRNAMOUNT = ''' + FloatToStr(StrToFloat(_lAmount) * -1) + ''' '  // inverto il segno del movimento
          + ', TRNAMOUNT = ''' + _lAmountTransfer + ''' '  // inverto il segno del movimento
          + ', TRNACCOUNT = ''' + _getDBField('DBACCOUNT', 'ACCID', 'ACCNAME', _fAccountTo.Text) + ''' '
          + ', TRNDESCRIPTION = ''' + _fDescription.Text + ''' '
          + ' WHERE TRNID = ''' + _getDBField('TRANSACTIONS', 'TRNTRANSFERID', 'TRNID',
          IntToStr(_pEditID)) + ''' ';
        MainFRM.sqlQry.ExecSQL(_SQLString);
      end;

    MainFRM.sqlite_conn.Commit;
  except
    raise Exception.Create('Error in Transfer. Operation Aborted');
    MainFRM.sqlite_conn.Rollback;
  end;

  {
    // recupero l'id dell'ultimo moviemnto
    _SQLString := 'SELECT max(TRNID) FROM Transactions';

    MainFRM.sqlQry.SQL.Clear;
    MainFRM.sqlQry.SQL.Add(_SQLString);
    try
    MainFRM.sqlQry.Open;
    if (MainFRM.sqlQry.RecordCount > 0) then
    begin
    // _lrecID := MainFRM.sqlQry.FieldValues['TRNTYPE'];
    // _SQLString := 'update TRANSACTIONS set TRNTRANSFERID = (SELECT max(TRNID) FROM Transactions) - 1' +
    // ' where TRNID = ' + _lrecID;

    end
    else
    begin
    raise Exception.Create('Error in Transfer. Operation Aborted');
    // dovrei inserire il rollback

    end;

    finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;

    end;
  }

end;

// -------------------------------------------------------------------------------------------------------------//
function TInsEditFrm._validateField(_pConfirmation: boolean): boolean;
begin
  Result := True;
  // verifica che i campi della mask siano compilati
  if (_fType.Text = '')
    or (_fAmount.Text = '')
    or (_fPayee.Text = '')
    or (_fCategory.Text = '')
    or (_fSubCategory.Text = '')
    or (_fAccountFrom.Text = '')
    or (_fAmount.Value = 0) then
  begin
    MessageDlg('Data field incomplete!!', mtInformation, [mbOk], 0);
    Result := False;
  end
  else
  begin
    if (_pConfirmation) then
      if MessageDlg('Save Record?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Result := False;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
function TInsEditFrm._newCategory: boolean;
var
  _lCategoryType: string;
begin
  /// se la categoria digitata non esiste richiesdo se la si voglia creare
  /// dopodichè ricarico la combo della subcategory
  Result := True;

  if (_fCategory.Items.IndexOf(UpperCase(_fCategory.Text)) = -1)
    and (_fCategory.Text <> '') then
    if (MessageDlg('Add New Category?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      if _fType.Text = 'Pay' then
        _lCategoryType := 'Expense'
      else
        _lCategoryType := 'Income';

      _SQLString := 'INSERT INTO DBCATEGORY (CATDES, CATTYPE) VALUES(''' + _UpCase(Trim(_fCategory.Text)) + ''', ' +
        ' ''' +
        _lCategoryType + ''' )';
      MainFRM.sqlQry.ExecSQL(_SQLString);

      _fSubCategory.Text := '';
    end
    else
      Result := False;

  _loadCmbSubcategory;
end;

// -------------------------------------------------------------------------------------------------------------//
function TInsEditFrm._newSubCategory: boolean;
begin
  // se la sottocategoria digitata non esiste, e la categoria è compilata richiedo se la si voglia creare
  Result := True;
  if (_fSubCategory.Items.IndexOf(_fSubCategory.Text) = -1)
    and (_fCategory.Text <> '')
    and (_fSubCategory.Text <> '')
    and (_fSubCategory.Text <> '_Transfer') then
    if (MessageDlg('Add New Subcategory?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      // cerco se esiste già una sottocategoria con lo stesso nome
      _SQLString := 'SELECT SUBCID FROM DBSUBCATEGORY where UCASE(SUBCDES) = ''' +
        UpperCase(_fSubCategory.Text) + ''' ';
      MainFRM.sqlQry.SQL.Clear;
      MainFRM.sqlQry.SQL.Add(_SQLString);
      MainFRM.sqlQry.Open;
      if MainFRM.sqlQry.RecordCount > 0 then
      begin
        MessageDlg('Name already used!', mtInformation, [mbOk], 0);
        MainFRM.sqlQry.Close;
        MainFRM.sqlQry.SQL.Clear;
        Result := False;
      end
      else
      begin
        _SQLString := 'INSERT INTO DBSUBCATEGORY (SUBCDES, SUBCATID) VALUES(''' +
          _UpCase(Trim(_fSubCategory.Text)) + ''', ' + _getDBField('DBCATEGORY', 'CATID', 'CATDES',
          _fCategory.Text) + '); ';
        MainFRM.sqlQry.ExecSQL(_SQLString);
      end;
    end;
end;

// -------------------------------------------------------------------------------------------------------------//
function TInsEditFrm._newPayee: boolean;
begin
  // se nuovo payee nella combo, aggiungo il record nella tabella
  Result := True;
  if (_fPayee.Items.IndexOf(UpperCase(_fPayee.Text)) = -1) and (_fPayee.Text <> '') then
    if (MessageDlg('Add New Payee?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      _SQLString := 'INSERT INTO DBPAYEE (PAYNAME) VALUES(''' + _UpCase(Trim(_fPayee.Text)) + ''' )';
      MainFRM.sqlQry.ExecSQL(_SQLString);
      _loadCmbPayee;
    end
    else
      Result := False;
end;

// -------------------------------------------------------------------------------------------------------------//

end.
