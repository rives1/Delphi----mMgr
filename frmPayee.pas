unit frmPayee;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, Vcl.StdCtrls, JvListBox, JvExStdCtrls,
  JvComboListBox, Vcl.Buttons, JvExButtons, JvBitBtn;

type
  TPayeeFRM = class(TForm)
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    _flvPayee: TListView;
    Splitter1: TSplitter;
    _fID: TEdit;
    _fName: TEdit;
    Name: TLabel;
    JvBitBtn1: TJvBitBtn;
    JvBitBtn2: TJvBitBtn;
    btnOK: TJvBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure _flvPayeeDblClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    // variabili
    _SQLString: string; // container x query string

    function _validateField: Boolean;
    procedure _loadLvPayee;
    procedure _loadRecord;
    procedure _recordSave;
    procedure _writeRecord;
    procedure _cleanFormNewRecord;
    procedure _deletePayee;

  public
    { Public declarations }
  end;

var
  PayeeFRM: TPayeeFRM;

implementation

{$R *.dfm}


uses
  frmMain, pasCommon;

{ TPayeeFRM }

// -------------------------------------------------------------------------------------------------------------//
procedure TPayeeFRM.btnOKClick(Sender: TObject);
begin
  _recordSave;
  _flvPayee.SetFocus;
end;

procedure TPayeeFRM.FormActivate(Sender: TObject);
begin
  _flvPayee.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TPayeeFRM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TPayeeFRM.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
procedure TPayeeFRM.FormShow(Sender: TObject);
begin
  _loadLvPayee;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TPayeeFRM._cleanFormNewRecord;
begin
  _fID.Text   := '';
  _fName.Text := '';

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TPayeeFRM._deletePayee;
begin
  { TODO :
    definire procedura cancellazione record
    NB: effettuare check se ci sono record correlati nelle transazioni }
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TPayeeFRM._flvPayeeDblClick(Sender: TObject);
begin
  _loadRecord;
  _fName.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TPayeeFRM._loadLvPayee;
var
  _lvItem: TListItem;
begin
  // carico i dati nella compo dei conti
  _flvPayee.Items.Clear;
  _SQLString := 'SELECT * FROM DBPAYEE WHERE UCASE(PAYNAME) <> ''_TRANSFER'' ';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _lvItem         := _flvPayee.Items.Add;
      _lvItem.Caption := VarToStr(MainFRM.sqlQry.FieldValues['PAYNAME']);

      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TPayeeFRM._loadRecord;
begin
  // dopo la selezione della
  _SQLString := 'SELECT * FROM DBPAYEE where PAYNAME = ''' + _flvPayee.Selected.Caption + ''' ';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _fID.Text   := MainFRM.sqlQry.FieldValues['PAYID'];
      _fName.Text := VarToStr(MainFRM.sqlQry.FieldValues['PAYNAME']);
      MainFRM.sqlQry.Next;
    end;

  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TPayeeFRM._recordSave;
begin
  if _validateField then
  begin
    _writeRecord;
    _loadLvPayee;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
function TPayeeFRM._validateField: Boolean;
begin
  // verifica che i campi della mask siano compilati
  Result := True;
  if (_fName.Text = '') then
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
procedure TPayeeFRM._writeRecord;
begin
  // salvo il record
  try
    MainFRM.sqlite_conn.StartTransaction;
    if (_fID.Text = '') then
      _SQLString := ' INSERT INTO DBPAYEE (PAYNAME) '
        + ' VALUES ( ''' + _fName.Text + ''') '
    else
      _SQLString := 'UPDATE DBPAYEE SET '
        + ' PAYNAME = ''' + _fName.Text + ''' '
        + ' WHERE PAYID = ''' + _fID.Text + ''' ';

    MainFRM.sqlQry.ExecSQL(_SQLString);
    MainFRM.sqlite_conn.Commit;

  except
    raise Exception.Create('Error in Saving. Operation Aborted');
    MainFRM.sqlite_conn.Rollback;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
end.
