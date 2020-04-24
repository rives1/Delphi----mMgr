unit frmCategory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, JvExButtons, JvBitBtn, JvExStdCtrls, JvCombobox,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus, Vcl.ActnPopup;

type
  TCategoryFrm = class(TForm)
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    _fName: TEdit;
    _fID: TEdit;
    _fType: TJvComboBox;
    _lblName: TLabel;
    _lblType: TLabel;
    btnOK: TJvBitBtn;
    _treeCategory: TTreeView;
    Splitter1: TSplitter;
    PopupMenu1: TPopupMenu;
    NewCategory1: TMenuItem;
    NewSubcategory1: TMenuItem;
    N1: TMenuItem;
    Delete1: TMenuItem;
    N2: TMenuItem;
    Edit1: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure _treeCategoryDblClick(Sender: TObject);
    procedure _treeCategoryDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure _treeCategoryDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure NewCategory1Click(Sender: TObject);
    procedure NewSubcategory1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
  private
    { Private declarations }
    // variabili
    _SQLString: string; // container x query string

    function _validateField: Boolean;
    procedure _recordDelete;
    procedure _recordLoad;
    procedure _recordSave;
    procedure _recordWrite;
    procedure _cleanFormNewRecord(_pAction : string);
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
procedure TCategoryFrm.Delete1Click(Sender: TObject);
begin
  _recordDelete;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm.Edit1Click(Sender: TObject);
begin
  _recordLoad;
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
procedure TCategoryFrm.NewCategory1Click(Sender: TObject);
begin
  _cleanFormNewRecord('edit');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm.NewSubcategory1Click(Sender: TObject);
begin
  if (_treeCategory.Selected.SelectedIndex = 1) then
    _cleanFormNewRecord('newSubcat')
  else
    MessageDlg('Category Node not selected!', mtInformation, [mbOk], 0);
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._cleanFormNewRecord(_pAction : string);
begin
  //se arrivo da un editing
  _fID.Text   := '';
  _fName.Text := '';
  _fType.Text := '';

  if (UpperCase(_pAction) = 'NEWCAT') then
  begin
      _fType.Visible   := True;
      _lblType.Caption := 'Type';
      _lblName.Caption := 'Category Description';
  end;


  if (UpperCase(_pAction) = 'NEWSUBCAT') then
  begin
      _fType.Visible   := False;
      _lblType.Caption := 'Category -> ' + _treeCategory.Selected.Text;
      _lblName.Caption := 'Subcategory Description';

  end;

  if (UpperCase(_pAction) = 'EDIT') then
    if (_treeCategory.Selected.SelectedIndex = 1) then // se categoria visualizzo il campo tipo
    begin
      _fType.Visible   := True;
      _lblType.Caption := 'Type';
      _lblName.Caption := 'Category Description';
    end
    else
    begin
      _fType.Visible   := False;
      _lblType.Caption := 'Category -> ' + _treeCategory.Selected.Parent.Text;
      _lblName.Caption := 'Subcategory Description';
    end;




  _fName.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._recordDelete;
begin
  if (_treeCategory.Selected.SelectedIndex = 1) then // procedura cancellazione categoria
  begin
    _SQLString := 'Select * From DBCATEGORY Inner Join DBSUBCATEGORY On DBSUBCATEGORY.SUBCATID = DBCATEGORY.CATID '
      + ' Where DBCATEGORY.CATDES = ''' + _treeCategory.Selected.Text +''' ';
    MainFRM.sqlQry.SQL.Clear;
    MainFRM.sqlQry.SQL.Add(_SQLString);
    try
      MainFRM.sqlite_conn.StartTransaction;
      MainFRM.sqlQry.Open;
      if MainFRM.sqlQry.RecordCount > 0 then
        MessageDlg('Account data alreay used in application. Impossible to delete.', mtInformation, [mbOk], 0)
      else
        if MessageDlg('Confirm Deletion?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        _SQLString := 'DELETE FROM DBCATEGORY WHERE CATDES  = ''' + _treeCategory.Selected.Text + ''' ';;
        // esecuzione della query di cancellazione
        MainFRM.sqlQry.ExecSQL(_SQLString);
        MainFRM.sqlite_conn.Commit;
      end;
      MainFRM.sqlQry.Close;
    MessageDlg(_treeCategory.Selected.Text  + ' Deleted!!',mtInformation, [mbOk], 0);
    except
      begin
        raise Exception.Create('Error in deleting -> ' + _treeCategory.Selected.Text + '. Operation Aborted');
        MainFRM.sqlite_conn.Rollback;
      end;
    end;

  end
  else // cancellazione sottocategoria
  begin
    _SQLString := 'SELECT * FROM LedgerView WHERE SUBCDES = ''' + _treeCategory.Selected.Text + ''' ';

    MainFRM.sqlQry.SQL.Clear;
    MainFRM.sqlQry.SQL.Add(_SQLString);
    try
      MainFRM.sqlite_conn.StartTransaction;
      MainFRM.sqlQry.Open;
      if MainFRM.sqlQry.RecordCount > 0 then
        MessageDlg('Account data alreay used in application. Impossible to delete.', mtInformation, [mbOk], 0)
      else
        if MessageDlg('Confirm Deletion?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        _SQLString := 'DELETE FROM DBSUBCATEGORY WHERE SUBCDES = ''' + _treeCategory.Selected.Text +''' ';
        // esecuzione della query di cancellazione
        MainFRM.sqlQry.ExecSQL(_SQLString);
        MainFRM.sqlite_conn.Commit;
      end;
      MainFRM.sqlQry.Close;
    MessageDlg(_treeCategory.Selected.Text  + ' Deleted!!',mtInformation, [mbOk], 0);
    except
      begin
        raise Exception.Create('Error in deleting -> '+ _treeCategory.Selected.Text +'. Operation Aborted');
        MainFRM.sqlite_conn.Rollback;
      end;
    end;
  end;

    _treeCategoryFill;
    _cleanFormNewRecord('newCat');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._recordLoad;
begin
  // Carico i dati nei campi della form
  _cleanFormNewRecord('edit');

  if (_treeCategory.Selected.SelectedIndex = 1) then // se categoria
  begin
    _SQLString := 'SELECT * FROM DBCATEGORY where CATDES = ''' + _treeCategory.Selected.Text + ''' ';
    MainFRM.sqlQry.SQL.Clear;
    MainFRM.sqlQry.SQL.Add(_SQLString);
    try
      MainFRM.sqlQry.Open;
      while not MainFRM.sqlQry.EOF do // ciclo recupero dati
      begin
        _fID.Text   := MainFRM.sqlQry.FieldValues['CATID'];
        _fType.Text := MainFRM.sqlQry.FieldValues['CATTYPE'];
        _fName.Text := MainFRM.sqlQry.FieldValues['CATDES'];
        MainFRM.sqlQry.Next;
      end;

    finally
      MainFRM.sqlQry.Close;
      MainFRM.sqlQry.SQL.Clear;
    end;
  end
  else
  begin // sottocategoria
    _SQLString := 'SELECT * FROM DBSUBCATEGORY where SUBCDES = ''' + _treeCategory.Selected.Text + ''' ';
    MainFRM.sqlQry.SQL.Clear;
    MainFRM.sqlQry.SQL.Add(_SQLString);
    try
      MainFRM.sqlQry.Open;
      while not MainFRM.sqlQry.EOF do // ciclo recupero dati
      begin
        _fID.Text   := MainFRM.sqlQry.FieldValues['SUBCID'];
        _fName.Text := MainFRM.sqlQry.FieldValues['SUBCDES'];
        MainFRM.sqlQry.Next;
      end;

    finally
      MainFRM.sqlQry.Close;
      MainFRM.sqlQry.SQL.Clear;
    end;

  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._recordSave;
begin
  if _validateField then
  begin
    _recordWrite;
    _treeCategoryFill;
    _cleanFormNewRecord('newCat');
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._treeCategoryDblClick(Sender: TObject);
begin
  _recordLoad;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._treeCategoryDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  _Src, _Dst: TTreeNode;
begin
  _Src := _treeCategory.Selected;
  _Dst := _treeCategory.GetNodeAt(X, Y);
  if (_Src.SelectedIndex = 1) then // se si tenta di muovere un ramo di categoria messaggio
    MessageDlg('Categories moving not allowed!!', mtInformation, [mbOk], 0)
  else
    if (_Dst.SelectedIndex = 0) then // si può attaccare il ramo solo ad un'altra categoria e non una sottocategoria
    MessageDlg('Only 2 level of categories allowed!!', mtInformation, [mbOk], 0)
  else
  begin
    _Src.MoveTo(_Dst, naAddChild);
    // qry update per il cambio nodo
    try
      MainFRM.sqlite_conn.StartTransaction;
      _SQLString := 'UPDATE DBSUBCATEGORY SET ' // aggiorno solo la descrizione
        + ' SUBCATID = ''' + _getDBField('DBCATEGORY', 'CATID', 'CATDES', _Dst.Text) + ''' '
        + ' WHERE SUBCID = ''' + _getDBField('DBSUBCATEGORY', 'SUBCID', 'SUBCDES', _Src.Text) + ''' ';

      MainFRM.sqlQry.ExecSQL(_SQLString); // eseguo query
      MainFRM.sqlite_conn.Commit;
    except
      raise Exception.Create('Error in Saving. Operation Aborted');
      MainFRM.sqlite_conn.Rollback;
    end;
  end;

  _treeCategoryFill;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._treeCategoryDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
  Src, Dst: TTreeNode;
begin
  Src    := _treeCategory.Selected;
  Dst    := _treeCategory.GetNodeAt(X, Y);
  Accept := Assigned(Dst) and (Src <> Dst);
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
      + ' DBSUBCATEGORY On CATID = SUBCATID '
      + ' where UCASE(CATDES) <> ''_TRANSFER'' '
      + ' order By CATDES, SUBCDES');
    try
      MainFRM.sqlQry.Active := True;
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
  _treeCategory.Items[0].Selected := True;

end;

// -------------------------------------------------------------------------------------------------------------//
function TCategoryFrm._validateField: Boolean;
begin
  // verifica che i campi della mask siano compilati
  Result := True;
  if (_treeCategory.Selected.SelectedIndex = 1) then // se categoria
  begin
    if (_fName.Text = '') or (_fType.Text = '') then
    begin
      MessageDlg('Data field incomplete!!', mtInformation, [mbOk], 0);
      Result := False;
    end
    else
    begin
      if MessageDlg('Save Record?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Result := False;
    end;
  end
  else // se sottocategoria
  begin
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
  end
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TCategoryFrm._recordWrite;
begin
  // salvo il record
  try
    MainFRM.sqlite_conn.StartTransaction;
    if (_treeCategory.Selected.SelectedIndex = 1) then // se categoria
    begin
      if (_fID.Text = '') then
        _SQLString := ' INSERT INTO DBCATEGORY (CATTYPE, CATDES) '
          + ' VALUES ( ''' + _fType.Text + ''' '
          + ', ''' + _fName.Text + ''') '
      else
        _SQLString := 'UPDATE DBCATEGORY SET '
          + '  CATTYPE = ''' + _fType.Text + ''' '
          + ', CATDES  = ''' + _fName.Text + ''' '
          + ' WHERE CATID = ''' + _fID.Text + ''' ';
    end
    else // se sottocategoria
    begin
      if (_fID.Text = '') then
        _SQLString := ' INSERT INTO DBSUBCATEGORY (SUBCDES, SUBCATID) '
          + ' VALUES ( ''' + _fType.Text + ''' '
          + ', ''' + _getDBField('DBCATEGORY', 'CATID', 'CATDES', _treeCategory.Selected.Text)
          + ''') '
      else
        _SQLString := 'UPDATE DBSUBCATEGORY SET ' // aggiorno solo la descrizione
          + ' SUBCDES = ''' + _fName.Text + ''' '
          + ' WHERE SUBCID = ''' + _fID.Text + ''' ';
    end;

    MainFRM.sqlQry.ExecSQL(_SQLString);
    MainFRM.sqlite_conn.Commit;

  except
    raise Exception.Create('Error in Saving. Operation Aborted');
    MainFRM.sqlite_conn.Rollback;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//

end.
