unit frmCategory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, JvExButtons, JvBitBtn, JvExStdCtrls, JvCombobox,
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TCategoryFrm = class(TForm)
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
    _treeCategory: TTreeView;
    _fSubCat: TEdit;
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
    _SQLString: string; // container x query string

    function _validateField: boolean;
    procedure _recordLoad;
    procedure _recordSave;
    procedure _recordWrite;
    procedure _cleanFormNewRecord;
    procedure _treeCategoryFill;

  public
    { Public declarations }

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
  _treeCategory.SetFocus;
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
  _treeCategoryFill;
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
  _recordLoad;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._recordLoad;
begin
  // dopo la selezione della
  // _SQLString := 'SELECT * FROM DBACCOUNT where ACCNAME = ''' +  + ''' ';
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
    _recordWrite;
    _treeCategoryFill;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._treeCategoryFill;
// creazione di tutto l'albero del menù
var
  _vNodeSub, _vNodeCat: TTreeNode; // nodo riferimento
  _vNodeText:           string;    // testo da inserire nel nodo
  _chkCatNode:          string;    // controllo per inserimento ramo categoria
begin
  // inizializzazione var
  _vNodeSub := nil;
  _vNodeCat := nil;

  _treeCategory.Items.Clear();
  if (MainFRM.sqlite_conn.Connected) then
  begin
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
    MainFRM.sqlQry.SQL.Add('Select * From DBCATEGORY Left Join '
      + ' DBSUBCATEGORY On DBCATEGORY.CATID = DBSUBCATEGORY.SUBCATID '
      + ' where UCASE(CATDES) <> ''_TRANSFER'' '
      + ' order By DBCATEGORY.CATDES, DBSUBCATEGORY.SUBCDES');
    try
      MainFRM.sqlQry.Active := true;
      if (MainFRM.sqlQry.RecordCount <> 0) then
        while not MainFRM.sqlQry.EOF do // ciclo recupero dati
        begin
          // aggiungo il nodo
          if (_chkCatNode <> MainFRM.sqlQry.FieldValues['CATDES']) then
          begin
            _vNodeCat               := _treeCategory.Items.AddChild(nil, MainFRM.sqlQry.FieldValues['CATDES']);
            _vNodeCat.SelectedIndex := 1; // imposto 1 nel caso si tratti di una categoria necessario
                                          // per gestire il salavataggio del record.
          end;
          // aggiungo nodo sub se esiste
          if (MainFRM.sqlQry.FieldValues['SUBCDES'] <> null) then
            _vNodeSub := _treeCategory.Items.AddChild(_vNodeCat, MainFRM.sqlQry.FieldValues['SUBCDES']);

          _chkCatNode := MainFRM.sqlQry.FieldValues['CATDES'];
          MainFRM.sqlQry.Next;
        end;
    except
      MessageDlg('Error adding data to tree menu', mtError, [mbOk], 0);
    end; // try
  end;   // if

  _treeCategory.FullExpand;
end;

// -------------------------------------------------------------------------------------------------------------//
function TCategoryFrm._validateField: boolean;
begin
  // verifica che i campi della mask siano compilati
  Result := true;
  if (_fType.Text = '') or (_fName.Text = '') then
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
procedure TCategoryFrm._recordWrite;
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
