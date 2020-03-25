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
    function _getDBID(_pTBL: string; _pIDfld: string; _pDESfld: string; _pParam: string): integer;
    procedure _loadCmbPayee;
    procedure _loadCmbCategory;
    procedure _loadCmbSubcategory;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure _fCategoryChange(Sender: TObject);
    procedure _fPayeeChange(Sender: TObject);

  private
    { Private declarations }
    _pEditID: integer;    // defines whic is the ID of the record in case of record editing
    _pIDLedger: string;   // properties for account ID
    _pInsertType: string; // properties to define if the new record is expense->"NewExpense" or a deposit->"NewDeposit"
    SQLString: string;    // var per gli statement sql
  public
    { Public declarations }
  end;

var
  InsEditFrm: TInsEditFrm;

implementation

{$R *.dfm}


uses
  frmMain;

{ TInsEditFrm }

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
  Self := nil;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm.FormCreate(Sender: TObject);
begin
  _loadCmbPayee();
  _loadCmbCategory();
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._fCategoryChange(Sender: TObject);
begin
  _loadCmbSubcategory; // aggiorno i dati della combo subcategory in base alla selezione della categoria
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._fPayeeChange(Sender: TObject);
begin
  // verfico che il valore sia selezionato fra quelli presenti e recupero le info dei dati + recenti
  if (_fPayee.Items.IndexOfName(_fPayee.Text) > -1) then
    // _getRecentData();
end;

// -------------------------------------------------------------------------------------------------------------//
function TInsEditFrm._getDBID(_pTBL, _pIDfld, _pDESfld, _pParam: string): integer;
begin
  // decodifico l'ID da una chiave
  SQLString := 'SELECT ' + _pIDfld + ' FROM ' + _pTBL + ' where ' + _pDESfld + ' = ''' + _pParam + ''' ';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
      Result := MainFRM.sqlQry.FieldValues[_pIDfld];
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TInsEditFrm._loadCmbPayee;
begin
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
  _fSubCategory.Items.Clear;
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
end.
