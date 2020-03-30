unit frmInsEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Mask, JvExMask, JvToolEdit,
  JvMaskEdit, JvExStdCtrls, JvEdit, JvValidateEdit, Vcl.ComCtrls, JvExComCtrls,
  JvDateTimePicker, Vcl.StdCtrls, Vcl.Buttons, JvExButtons, JvBitBtn,
  JvCombobox;

type
  TInsEditFrm = class(TForm)
    _fType: TJvComboBox;
    btnOK: TJvBitBtn;
    _fID: TEdit;
    _fDescription: TEdit;
    _fPayee: TJvComboBox;
    _fCategory: TJvComboBox;
    _fSubCategory: TJvComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    _fDate: TJvDateTimePicker;
    _fAmount: TJvValidateEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure _fPayeeCloseUp(Sender: TObject);
    procedure _fSubCategoryExit(Sender: TObject);
    procedure _fCategoryExit(Sender: TObject);

  private
    { Private declarations }

    // variabili
    _plEditType: string; // properties to define if the new record is expense->"NewExpense" or a deposit->"NewDeposit"
    _plEditID: integer;  // defines which is the ID of the record in case of record editing
    _plLedgerID: string; // properties for account ID

    SQLString: string; // container x query string

    // local functions
    function _validateField: boolean;
    procedure _loadCmbPayee;
    procedure _loadCmbCategory;
    procedure _loadCmbSubcategory;
    procedure _loadRecord;
    procedure _writeRecord;
    procedure _recordSave;
    procedure _newPayee;
    procedure _getRecentData;
    procedure _cleanFormNewRecord;
    procedure _newCategory;
    procedure _newSubCategory; // var per gli statement sql

  public
    { Public declarations }

  published

    property _pEditType: string read _plEditType write _plEditType;
    property _pEditID: integer read _plEditID write _plEditID;
    property _pLedgerID: string read _plLedgerID write _plLedgerID;
  end;

var
  InsEditFrm: TInsEditFrm;

implementation

{$R *.dfm}


uses
  frmMain, pasCommon;

{ TInsEditFrm }

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm.btnOKClick(Sender: TObject);
begin
  _recordSave;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm.FormActivate(Sender: TObject);
begin
  if (_pEditType = 'edit') and (_pEditID <> 0) then
    _loadRecord; // carico i dati nella form

  if (_pEditType = 'newExp') then
  begin
    _fType.Text := 'Pay';
    _fPayee.SetFocus;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (MessageDlg('Close Form?', mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
  begin
    Action := caFree;
    Release;
  end
  else
    Action := caNone;
  // Self := nil;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // gestione pressione tasti
  // ESC - chiudo la form
  // F12 - salvo il record
  case Key of
    127: // F12
      _recordSave;
    27: // ESC
      self.Close;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm.FormShow(Sender: TObject);
begin
  _loadCmbPayee();
  _loadCmbCategory();
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._cleanFormNewRecord;
begin
  /// ripulisco la form per inserire il prox recod
  ///
  _loadCmbCategory; // ricarico la categoria se nel record precedente ne è stato inserito uno
  _fPayee.Text := '';
  _fCategory.Text := '';
  _fSubCategory.Text := '';
  _fCategory.Text := '';
  _fAmount.Value := 0;

  _fPayee.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._fCategoryExit(Sender: TObject);
begin
  _newCategory;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._fPayeeCloseUp(Sender: TObject);
begin
  // verfico che il valore sia selezionato fra quelli presenti e recupero le info dei dati + recenti
  if (_fPayee.Items.IndexOf(UpperCase(_fPayee.Text)) <> -1) and (_fPayee.Text <> '') then
    _getRecentData;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._fSubCategoryExit(Sender: TObject);
begin
  _newSubCategory;
end;

// -------------------------------------------------------------------------------------------------------------//
(*
  function TInsEditFrm._getDBField(_pTBL, _pIDfld, _pDESfld, _pParam: string): string;
  begin
  /// decodifico un campo (solitamente l'ID) di una tabella dato un campo
  /// attn la richiesta non è molto sicura dipende molto dal fatto che non passino nella richiesta
  /// dei campi che potrebbero contenere campi duplicati
  Result := '0';
  SQLString := 'SELECT ' + _pIDfld + ' FROM ' + _pTBL + ' where UCASE(' + _pDESfld + ') = UCASE(''' + _pParam + ''') ';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(SQLString);
  try
  MainFRM.sqlQry.Open;
  if MainFRM.sqlQry.RecordCount > 0 then
  Result := MainFRM.sqlQry.FieldValues[_pIDfld];
  finally
  MainFRM.sqlQry.Close;
  MainFRM.sqlQry.SQL.Clear;
  end;

  end;
*)

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
  if (_pEditID = 0) and (_fPayee.Text <> '') then // if it's not editing a previous record
  begin
    SQLString := 'SELECT LedgerView.CATDES, LedgerView.SUBCDES, LedgerView.TRNDESCRIPTION, LedgerView.TRNAMOUNT ' +
      ' FROM LedgerView ' +
      ' WHERE LedgerView.PAYNAME = ''' + _fPayee.Text + ''' ' +
      ' ORDER BY LedgerView.TRNDATE DESC ';
    MainFRM.sqlQry.SQL.Clear;
    MainFRM.sqlQry.SQL.Add(SQLString);
    try
      MainFRM.sqlQry.Open;                   // if i find a record the DESC order shows the most recent payee data
      if MainFRM.sqlQry.RecordCount > 0 then // recupero il primo record
      begin
        _fCategory.Text := MainFRM.sqlQry.FieldValues['CATDES'];
        _fSubCategory.Text := MainFRM.sqlQry.FieldValues['SUBCDES'];
        _fDescription.Text := MainFRM.sqlQry.FieldValues['TRNDESCRIPTION'];
        _fAmount.Text := FloatToStr(Abs(MainFRM.sqlQry.FieldValues['TRNAMOUNT']));
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
  _fPayee.Text := '';
  SQLString := 'SELECT * FROM DBPAYEE';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(SQLString);
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
procedure TInsEditFrm._loadCmbCategory;
begin
  // carico i dati nella combo categorie
  _fCategory.Items.Clear;
  _fCategory.Text := '';
  SQLString := 'SELECT * FROM DBCATEGORY';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(SQLString);
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
  // carico i dati nella cubcategory in base alla selezione della categoria
  _fSubCategory.Items.Clear;
  // _fSubCategory.Text := '';
  SQLString := 'SELECT DBSUBCATEGORY.* FROM DBCATEGORY INNER JOIN DBSUBCATEGORY ON DBCATEGORY.CATID = ' +
    ' DBSUBCATEGORY.SUBCATID WHERE DBCATEGORY.CATDES = ''' + _fCategory.Text + ''' ;';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(SQLString);
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
procedure TInsEditFrm._loadRecord;
begin
  // carico i dati nella mask se si tratta di editing di record
  SQLString := 'SELECT * FROM LedgerView where TRNID = ' + IntToStr(_plEditID);
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _fID.Text := IntToStr(_plEditID);
      _fType.Text := MainFRM.sqlQry.FieldValues['TRNTYPE'];
      _fDate.Date := VarToDateTime(MainFRM.sqlQry.FieldValues['TRNDATE']);
      _fPayee.Text := VarToStr(MainFRM.sqlQry.FieldValues['PAYNAME']);
      _fCategory.Text := VarToStr(MainFRM.sqlQry.FieldValues['CATDES']);
      _fSubCategory.Text := VarToStr(MainFRM.sqlQry.FieldValues['SUBCDES']);
      _fDescription.Text := VarToStr(MainFRM.sqlQry.FieldValues['TRNDESCRIPTION']);
      _fAmount.Value := Abs(MainFRM.sqlQry.FieldValues['TRNAMOUNT']);

      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;
  // agiorno i dati della combo subcategory
  _loadCmbSubcategory;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._newPayee;
begin
  // se nuovo payee nella combo, aggiungo il record nella tabella
  if (_fPayee.Items.IndexOf(UpperCase(_fPayee.Text)) = -1) then
  begin
    SQLString := 'INSERT INTO DBPAYEE (PAYNAME) VALUES(UCASE(''' + _fPayee.Text + ''' ))';
    MainFRM.sqlQry.ExecSQL(SQLString);
    _loadCmbPayee;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._recordSave;
begin
  if _validateField then
  begin
    _newPayee;
    _writeRecord;
    // nel caso di editing di un record chiudo la form adesso
    if _pEditType = 'edit' then
      self.Close;
    // in caso di inserimento bulk
    if (_pEditType = 'newExp') or (_pEditType = 'new') then
      _cleanFormNewRecord;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._writeRecord;
var
  _lAmount: string; // ammontare da inserire nel db. pos o neg in base al tipo di spesa
  _CategoryType: string;
begin
  // il valore deve essere ngativo se la il tipo di transazione è pay
  { TODO : blocco da eliminare se non uso la categoria per definire il segno del movimento }
  { _CategoryType := _getDBField('DBCATEGORY', 'CATTYPE', 'CATDES', _fCategory.Text);

    if UpperCase(_CategoryType) = 'EXPENSE' then
    _lAmount := VarToStr((_fAmount.Value) * -1)
    else
    _lAmount := VarToStr((_fAmount.Value));
  }

  if UpperCase(_fType.Text) = 'PAY' then
    _lAmount := VarToStr((_fAmount.Value) * -1)
  else
    _lAmount := VarToStr((_fAmount.Value));

  // salvataggio del record in base alla tipologia di editing
  if _pEditID = 0 then
    SQLString := ' INSERT INTO TRANSACTIONS (TRNTYPE, TRNDATE, TRNPAYEE, TRNCATEGORY, TRNSUBCATEGORY, TRNAMOUNT, ' +
      ' TRNACCOUNT, TRNDESCRIPTION) ' +
    // ' VALUES (:pType, :pDate, :pPayee, :pCategory, :pSubcat, :pAmount, :pAccount, :pDes)'
      ' VALUES ( ''' + _fType.Text + ''' '
      + ', ''' + FormatDateTime('yyyy-mm-dd', _fDate.Date) + ''' '
      + ', ''' + _getDBField('DBPAYEE', 'PAYID', 'PAYNAME', _fPayee.Text) + ''' '
      + ', ''' + _getDBField('DBCATEGORY', 'CATID', 'CATDES', _fCategory.Text) + ''' '
      + ', ''' + _getDBField('DBSUBCATEGORY', 'SUBCID', 'SUBCDES', _fSubCategory.Text) + ''' '
      + ', ''' + _lAmount + ''' '
      + ', ''' + _getDBField('DBACCOUNT', 'ACCID', 'ACCNAME', _plLedgerID) + ''' '
      + ', ''' + _fDescription.Text + ''') '
  else
    SQLString := 'UPDATE TRANSACTIONS SET '
      + '  TRNTYPE = ''' + _fType.Text + ''' '
      + ', TRNDATE = datetime(''' + FormatDateTime('yyyy-mm-dd', _fDate.Date) + ''') '
      + ', TRNPAYEE = ''' + _getDBField('DBPAYEE', 'PAYID', 'PAYNAME', _fPayee.Text) + ''' '
      + ', TRNCATEGORY =  ''' + _getDBField('DBCATEGORY', 'CATID', 'CATDES', _fCategory.Text) + ''' '
      + ', TRNSUBCATEGORY = ''' + _getDBField('DBSUBCATEGORY', 'SUBCID', 'SUBCDES', _fSubCategory.Text) + ''' '
      + ', TRNAMOUNT = ''' + _lAmount + ''' '
      + ', TRNACCOUNT = ''' + _getDBField('DBACCOUNT', 'ACCID', 'ACCNAME', _plLedgerID) + ''' '
      + ', TRNDESCRIPTION = ''' + _fDescription.Text + ''' '
      + ' WHERE TRNID = ''' + IntToStr(_pEditID) + ''' ';
  // ShowMessage(_getDBID('DBPAYEE', 'PAYID', 'PAYNAME', UpperCase(_fPayee.Text)));
  try
    MainFRM.sqlQry.ExecSQL(SQLString);
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
function TInsEditFrm._validateField: boolean;
begin
  Result := True;
  // verifica che i campi della mask siano compilati
  if (_fType.Text = '') or (_fAmount.Text = '') or (_fPayee.Text = '') or
    (_fCategory.Text = '') or (_fSubCategory.Text = '') then
  begin
    MessageDlg('Data field incomplete!!', mtInformation, [mbOk], 0);
    Result := false;
  end
  else
  begin
    if MessageDlg('Save Record?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Result := false;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._newCategory;
var
  _lCategoryType: string;
begin
  /// se la categoria digitata non esiste richiesdo se la si voglia creare
  /// dopodichè ricarico la combo della subcategory
  if (_fCategory.Items.IndexOf(UpperCase(_fCategory.Text)) = -1) and (_fCategory.Text <> '') then
    if (MessageDlg('Add New Category?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      if _fType.Text = 'Pay' then
        _lCategoryType := 'Expense'
      else
        _lCategoryType := 'Income';

      SQLString := 'INSERT INTO DBCATEGORY (CATDES, CATTYPE) VALUES(UCASE(''' + _fCategory.Text + '''), ' +
        ' ''' + _lCategoryType + ''' )';

      MainFRM.sqlQry.ExecSQL(SQLString);

      _fSubCategory.Text := ''; // se inserisco nuova cat devo resettare la sub per poterne inserire poi una ex-novo
    end;
  _loadCmbSubcategory;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._newSubCategory;
begin
  /// se la sottocategoria digitata non esiste, e la categoria è compilata richiedo se la si voglia creare
  if (_fSubCategory.Items.IndexOf(UpperCase(_fSubCategory.Text)) = -1) and (_fCategory.Text <> '') and
    (_fSubCategory.Text <> '') then
    if (MessageDlg('Add New Subcategory?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      SQLString := 'INSERT INTO DBSUBCATEGORY (SUBCDES, SUBCATID) VALUES(UCASE(''' + _fCategory.Text + '''), ' +
        _getDBField('DBCATEGORY', 'CATID', 'CATDES', UpperCase(_fCategory.Text)) + ') ';
      MainFRM.sqlQry.ExecSQL(SQLString);
    end;
end;

// -------------------------------------------------------------------------------------------------------------//

end.
