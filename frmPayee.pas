unit frmPayee;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, Vcl.StdCtrls, JvListBox, JvExStdCtrls,
  JvComboListBox, Vcl.Buttons, JvExButtons, JvBitBtn, Vcl.Menus;

type
  TPayeeFRM = class(TForm)
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    _flvPayee: TListView;
    Splitter1: TSplitter;
    _fID: TEdit;
    _fName: TEdit;
    Name: TLabel;
    btnOK: TJvBitBtn;
    PopupMenu1: TPopupMenu;
    NewPayee1: TMenuItem;
    EditPayee1: TMenuItem;
    N1: TMenuItem;
    Delete1: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure _flvPayeeDblClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure NewPayee1Click(Sender: TObject);
    procedure EditPayee1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
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

procedure TPayeeFRM.Delete1Click(Sender: TObject);
begin
  _deletePayee;
  _cleanFormNewRecord;
end;
// -------------------------------------------------------------------------------------------------------------//

procedure TPayeeFRM.EditPayee1Click(Sender: TObject);
begin
  _loadRecord;
  _fName.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
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
procedure TPayeeFRM.NewPayee1Click(Sender: TObject);
begin
  _cleanFormNewRecord;
  _fName.SetFocus;
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
  _SQLString := 'SELECT * FROM LedgerView WHERE PAYNAME = ''' + _flvPayee.Selected.Caption + ''' ';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlite_conn.StartTransaction;
    MainFRM.sqlQry.Open;
    if MainFRM.sqlQry.RecordCount > 0 then
      MessageDlg('Data alreay used in application. Impossible to delete.', mtInformation, [mbOk], 0)
    else
      if MessageDlg('Confirm Deletion?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      _SQLString := 'DELETE FROM DBPAYEE WHERE PAYNAME = ''' + _flvPayee.Selected.Caption + ''' ';
      // esecuzione della query di cancellazione
      MainFRM.sqlQry.ExecSQL(_SQLString);
      MainFRM.sqlite_conn.Commit;
    end;
    MainFRM.sqlQry.Close;
  except
    begin
      raise Exception.Create('Error in deleting -> ' + _flvPayee.Selected.Caption + '. Operation Aborted');
      MainFRM.sqlite_conn.Rollback;
    end;
  end;

  _loadLvPayee;
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
        + ' VALUES ( ''' + _UpCase(_fName.Text) + ''') '
    else
      _SQLString := 'UPDATE DBPAYEE SET '
        + ' PAYNAME = ''' + _UpCase(_fName.Text) + ''' '
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
