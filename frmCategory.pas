unit frmCategory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, JvExButtons, JvBitBtn, JvExStdCtrls, JvCombobox,
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TCategoryFrm = class(TForm)
    _fSearch: TJvComboBox;
    ListView1: TListView;
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
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure _fSearchSelect(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure JvBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    // variabili
    // _plEditType: string;  // properties to define if the new record
    // _plEditID:   integer; // defines which is the ID of the record in case of record editing
    _SQLString: string; // container x query string

    function _validateField: boolean;
    procedure _loadCmbSearch;
    procedure _loadRecord;
    procedure _recordSave;
    procedure _writeRecord;
    procedure _cleanFormNewRecord;

  public
    { Public declarations }

  published
    // property _pEditType: string read _plEditType write _plEditType;
    // property _pEditID:   integer read _plEditID write _plEditID;

  end;

var
  CategoryFrm: TCategoryFrm;

implementation

{$R *.dfm}


uses
  frmMain, pasCommon;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm.btnOKClick(Sender: TObject);
begin
  _recordSave;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm.FormActivate(Sender: TObject);
begin
  // if (_pEditType = 'edit') and (_pEditID <> 0) then
  // _loadRecord // carico i dati nella form
  // else
  // if (_pEditType = 'new') then // nuova transazione generica
  // begin
  _fName.SetFocus;
  // end;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
procedure TCategoryFrm.FormShow(Sender: TObject);
begin
  _loadCmbSearch;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm.JvBitBtn1Click(Sender: TObject);
begin
  _cleanFormNewRecord;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._cleanFormNewRecord;
begin
  _fID.Text   := '';
  _fName.Text := '';
  _fType.Text := '';
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._fSearchSelect(Sender: TObject);
begin
  _loadRecord;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._loadCmbSearch;
begin
  // carico i dati nella compo dei conti
  _fSearch.Items.Clear;
  _SQLString := 'SELECT ACCNAME FROM DBACCOUNT';
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
procedure TCategoryFrm._loadRecord;
begin
  // dopo la selezione della
  _SQLString := 'SELECT * FROM DBACCOUNT where ACCNAME = ''' + _fSearch.Text + ''' ';
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
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._recordSave;
begin
  if _validateField then
  begin
    _writeRecord;
    _loadCmbSearch;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
function TCategoryFrm._validateField: boolean;
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
procedure TCategoryFrm._writeRecord;
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
