unit frmLedger;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, JvExComCtrls, JvComCtrls,
  RzTreeVw, JvLookOut, JvExControls, JvOutlookBar, Vcl.Grids, JvgStringGrid,
  VclTee.TeeGDIPlus, VclTee.Series, VclTee.TeEngine, RzPanel, VclTee.TeeProcs,
  VclTee.Chart, Vcl.ExtCtrls, RzSplit, JvExGrids, JvStringGrid, RzGrids,
  JvListView, Vcl.Menus, JvComponentBase, JvgExportComponents;

type
  TLedgerFrm = class(TForm)
    RzSplitter1: TRzSplitter;
    chTotals: TChart;
    chHistory: TChart;
    RzStatusBar1: TRzStatusBar;
    Series1: TPieSeries;
    _e_grdLedger: TJvgStringGrid;
    Series2: TAreaSeries;
    PopupMenu1: TPopupMenu;
    Edit1: TMenuItem;
    Edit2: TMenuItem;
    N1: TMenuItem;
    Delete1: TMenuItem;
    InsertDeposit: TMenuItem;
    grdLedger: TStringGrid;
    Transfer1: TMenuItem;
    InsertExpense1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdLedgerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure grdLedgerDblClick(Sender: TObject);
    procedure grdLedgerDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
    procedure InsertDepositClick(Sender: TObject);
    procedure Transfer1Click(Sender: TObject);
    procedure InsertExpense1Click(Sender: TObject);

  private
    { Private declarations }

    // variabili
    _pAccountName: string;
    // reminder per quale account aprire -- presa dal treemenu all'atto dell'instanza della form
    _SQLString: string; // var per tutti gli statement sql da comporre

    // local functions
    procedure _fillGrid;
    procedure _clearGrid;
    procedure _autoSizeCol(Grid: TStringGrid; Column: Integer);
    procedure _autoSizeGrid;
    procedure _ChartTotals;
    procedure _deleteRecord(_pRecID: string; _pRecRow: Integer; _precType: string);
    procedure _openRecordForm(_pEditKind: string);

  public
    { Public declarations }
    // gestione proprietà

    { TODO : da eliminare }
    // published
    // property _pAccountName: string read _plAccountName write _plAccountName;

  end;

var
  LedgerFrm: TLedgerFrm;

implementation

{$R *.dfm}


uses
  frmMain, frmInsEdit;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.Delete1Click(Sender: TObject);
begin
  _deleteRecord(grdLedger.cells[0, grdLedger.Row], grdLedger.Row, grdLedger.cells[1, grdLedger.Row]);
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.Edit1Click(Sender: TObject);
begin
  _openRecordForm('ins');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.Edit2Click(Sender: TObject);
begin
  _openRecordForm('edit');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.FormActivate(Sender: TObject);
begin
  _fillGrid;
  _ChartTotals;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.FormCreate(Sender: TObject);
begin
  // imposto la var privata con il nome dell'account da cui reperire i dati
  _pAccountName := MainFRM.treeMenu.Selected.Text;

  // impostazione del nome dell'account nella barra del titolo della finestra
  Self.Caption := _pAccountName;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.FormShow(Sender: TObject);
begin
  // riempio la grid
  // _fillGrid;
  // _ChartTotals;
  grdLedger.SetFocus;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.grdLedgerDblClick(Sender: TObject);
begin
  _openRecordForm('edit');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.grdLedgerDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  dx:   Integer;
  Text: string;
begin

  with (Sender as TStringGrid) do
  begin
    // Don't change color for first Column, first row
    if (ARow = 0) then
    begin
      Canvas.Brush.Color := clBtnFace;
      Canvas.Font.Style  := [fsBold];
    end
    else
    begin
      // Draw the Band except on current highlighted row
      if (ARow <> Row) then
      begin
        if (ARow mod 2 = 0) then
          Canvas.Brush.Color := $DFECDF // colore alternativo $eff5ef
          // else
          // Canvas.Brush.Color := $00FFEBDF;
      end;

      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, cells[ACol, ARow]);
      Canvas.FrameRect(Rect);
    end;
  end;

  // allineamento a dx del testo
  if (ACol in [0, 5 .. 7]) and (ARow <> 0) then // right-align text
    with grdLedger.Canvas do
    begin
      // bold per la prima linea delle caption
      FillRect(Rect);
      Text := grdLedger.cells[ACol, ARow];
      dx   := TextWidth(Text) + 2;
      TextOut(Rect.Right - dx, Rect.Top, Text);
    end;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.grdLedgerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  _action: string; // tipologia dell'intervento da eseguire
begin
  /// gestione pressione tasti
  /// INS   - aggiunge nuovo record
  /// +     - aggiungo un nuovo record di spesa e continua con l'inserimento in serie
  /// ENTER - edita il record corrente
  /// ESC   - chiudo la form
  /// *    - Trasferimento

  _action := '';

  case Key of
    13:                  // ENTER
      _action := 'edit'; // editing del record
    27:                  // ESC
      Self.Close;        // chiudo la form
    45:                  // INS
      _action := 'new';  // apro la form in inserimento
    46:                  // DEL - elimino record direttamente dalla form del registro
      _deleteRecord(grdLedger.cells[0, grdLedger.Row],
        grdLedger.Row,
        grdLedger.cells[1, grdLedger.Row]);
    106:                   // *
      _action := 'newTrx'; // trasferimento fra conti
    107:                   // +
      _action := 'newDep'; // apro la form in inserimento
    109:                   // -
      _action := 'newExp'; // apro la form in inserimento

  end;
  if _action <> '' then
    _openRecordForm(_action);

end;

procedure TLedgerFrm.InsertDepositClick(Sender: TObject);
begin
  _openRecordForm('newDep');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.InsertExpense1Click(Sender: TObject);
begin
  _openRecordForm('newExp');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.Transfer1Click(Sender: TObject);
begin
  _openRecordForm('newTrx');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._openRecordForm(_pEditKind: string);
var
  frmInsEdit: TInsEditFrm;
  i:          Integer; // var x storage del record attuale per poi recuperarlo
begin
  i := grdLedger.Row; // imposto la riga della grid attuale
  // creo la form e la nascondo per poter impostare le proprietà
  frmInsEdit := TInsEditFrm.Create(Self);
  frmInsEdit.Hide;

  // imposto il tipo di editing nella proprietà della form editing
  frmInsEdit._pEditType := _pEditKind;

  // passo la tipologia dell'azione da eseguire sulla form editing
  if _pEditKind = 'edit' then
    frmInsEdit._pEditID := strToInt(grdLedger.cells[0, i]) // imposto l'ID del record da editare
  else
    frmInsEdit._pEditID := 0; // mando un generico valore da cariccare nella form utile x alcuni check

  // passo il nome del ledger di riferimento del record
  frmInsEdit._pLedgerName := _pAccountName;

  // nostro la form modale
  frmInsEdit.ShowModal;

  // aggiorno i datidella grid
  _fillGrid;
  _ChartTotals;

  grdLedger.Row := i; // reimposto il record della grid su quello precedente
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._autoSizeCol(Grid: TStringGrid; Column: Integer);
var
  i, W, WMax: Integer;
begin
  WMax  := 0;
  for i := 0 to (Grid.RowCount - 1) do
  begin
    W := Grid.Canvas.TextWidth(Grid.cells[Column, i]);
    if W > WMax then
      WMax := W;
  end;
  Grid.ColWidths[Column] := WMax + 10; // aggiungo X per avere una migliore visibilità
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._autoSizeGrid;
var
  i: Integer;
begin
  for i := 0 to grdLedger.ColCount - 1 do
    _autoSizeCol(grdLedger, i);
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._clearGrid;
var
  i: Integer;
  J: Integer;
begin
  for i                     := 0 to grdLedger.ColCount - 1 do
    for J                   := 1 to grdLedger.RowCount - 1 do
      grdLedger.cells[i, J] := '';
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._ChartTotals;
var
  _lTotal: Double;
  _YY:     string; // riferimento anno per migliroare visualizzazione graph storico
  i:       Integer;
begin
  // Chart totali IN/OUT

  _lTotal := 0; // totale dei singoli record da imputare nel grafico

  chTotals.Series[0].Clear(); // pulisco il grafico
  // query totalizzazione depositi
  _SQLString := 'SELECT Sum(TRNAMOUNT) AS Sum_TRNAMOUNT ' +
    ' FROM LedgerView ' +
    ' WHERE ' +
    ' TRNAMOUNT > 0 ' +
    ' AND ACCNAME = ''' + _pAccountName + ''' ' +
    ' ORDER BY ACCNAME';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      if MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'] <> null then
      begin
        _lTotal := StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']);
        chTotals.SeriesList[0].Add(_lTotal, 'Deposit');
      end;
      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

  // query totalizzazione spese
  _SQLString := 'SELECT Sum(TRNAMOUNT) AS Sum_TRNAMOUNT ' +
    ' FROM LedgerView ' +
    ' WHERE ' +
    ' TRNAMOUNT < 0 ' +
    ' AND ACCNAME = ''' + _pAccountName + ''' ';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      if MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'] <> null then
      begin
        _lTotal := Abs(StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']));
        // FormatFloat('#,##0 K', StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']/1000));
        chTotals.SeriesList[0].Add(_lTotal, 'Expense');
      end;
      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

  //
  // Chart Storico
  //
  chHistory.Series[0].Clear(); // pulisco il grafico
  _lTotal := 0;                // resetto il conteggio
  i       := 0;                // azzero il counter delle colonne
  // query totalizzazione spese
  _SQLString := 'SELECT StrfTime(''%Y'', TRNDATE) || ''-'' || StrfTime(''%W'', TRNDATE) AS Period, ' +
    ' StrfTime(''%Y'', TRNDATE) AS YY,' +
    ' StrfTime(''%W'', TRNDATE) AS WW, ' +
    ' Sum(TRNAMOUNT) AS Sum_TRNAMOUNT ' +
    ' FROM LedgerView ' +
    ' WHERE ACCNAME = ''' + _pAccountName + ''' ' +
    ' GROUP BY Period ' +
    ' ORDER BY Period ';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);

  try
    MainFRM.sqlQry.Open;
    if (MainFRM.sqlQry.RecordCount <> 0) then
      while not MainFRM.sqlQry.EOF do // ciclo recupero dati
      begin
        if MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'] <> null then
        begin
          _lTotal := _lTotal + (MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']);
          // FormatFloat('#,##0 K', StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']/1000));
          chHistory.Series[0].Add(_lTotal);
          // inserisco l'anno solo nella settimana iniziale
          if (_YY = MainFRM.sqlQry.FieldValues['YY']) then
            chHistory.Axes.Bottom.Items.Add(i, MainFRM.sqlQry.FieldValues['WW'])
          else
            chHistory.Axes.Bottom.Items.Add(i, MainFRM.sqlQry.FieldValues['YY']);

          _YY := MainFRM.sqlQry.FieldValues['YY'];
          i   := i + 1;
        end;
        MainFRM.sqlQry.Next;
      end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._fillGrid();
// riempiemnto della grid
var
  i:             Integer;
  runSum:        Double;
  _trxIndicator: string; // indica con i segni > o > se il trasferimento è in entrata o uscita
  // oppure lascio vuoto se non si tratta di un trasferimento
begin
  // pulizia della grid
  _clearGrid;
  grdLedger.RowCount := 1;

  // inserisco le caption
  grdLedger.cells[0, 0] := 'ID';
  grdLedger.cells[1, 0] := 'Type';
  grdLedger.cells[2, 0] := 'Date';
  grdLedger.cells[3, 0] := 'Payee';
  grdLedger.cells[4, 0] := 'Category';
  grdLedger.cells[5, 0] := 'In';
  grdLedger.cells[6, 0] := 'Out';
  grdLedger.cells[7, 0] := 'Balance';
  grdLedger.cells[8, 0] := 'Description';

  // estrazione dati dal db e riempimento della grid
  _SQLString := 'SELECT * FROM LedgerView where ACCNAME = ''' + _pAccountName + ''' ORDER BY TRNDATE, TRNID';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    i      := 1;
    runSum := 0;
    if (MainFRM.sqlQry.RecordCount <> 0) then
      while not MainFRM.sqlQry.EOF do // ciclo recupero dati
      begin
        // inserisco una nuova riga nella grid
        grdLedger.RowCount := grdLedger.RowCount + 1;
        // aggiungo i dati alla grid
        grdLedger.cells[0, i] := MainFRM.sqlQry.FieldValues['TRNID']; // ID
        grdLedger.cells[1, i] := MainFRM.sqlQry.FieldValues['TRNTYPE']; // Tipo operazione
        grdLedger.cells[2, i] := MainFRM.sqlQry.FieldValues['TRNDATE']; // Data
        grdLedger.cells[3, i] := MainFRM.sqlQry.FieldValues['PAYNAME'];
        grdLedger.cells[4, i] := MainFRM.sqlQry.FieldValues['CATDES'] + ' : ' + MainFRM.sqlQry.FieldValues
          ['SUBCDES'];

        if (MainFRM.sqlQry.FieldValues['TRNAMOUNT'] > 0) then
        begin
          grdLedger.cells[5, i] := FormatFloat('#,##0.00', MainFRM.sqlQry.FieldValues['TRNAMOUNT']);
          // _trxIndicator         := '>Transfer';
          _trxIndicator := '->';
        end
        else
        begin
          grdLedger.cells[6, i] := FormatFloat('#,##0.00', MainFRM.sqlQry.FieldValues['TRNAMOUNT'] * -1);
          // _trxIndicator         := '<Transfer';
          _trxIndicator := '<-';
        end;

        runSum := runSum + MainFRM.sqlQry.FieldValues['TRNAMOUNT'];

        grdLedger.cells[7, i] := FormatFloat('#,##0.00', runSum);
        grdLedger.cells[8, i] := MainFRM.sqlQry.FieldValues['TRNDESCRIPTION'];

        if (MainFRM.sqlQry.FieldValues['TRNTYPE'] = 'Transfer') then // se si tratta si trasferimento
        begin
          // cerco il mov correlato e recupero il conto
          _SQLString := 'select ACCNAME'
            + ' from DBACCOUNT, TRANSACTIONS '
            + ' where TRNACCOUNT = ACCID '
            + ' and TRNID = ' + VarToStr(MainFRM.sqlQry.FieldValues['TRNTRANSFERID']);

          MainFRM.sqlQry2.SQL.Clear;
          MainFRM.sqlQry2.SQL.Add(_SQLString);
          MainFRM.sqlQry2.Open;
          if MainFRM.sqlQry2.RecordCount > 0 then
            _trxIndicator := _trxIndicator + ' ' + MainFRM.sqlQry2.FieldValues['ACCNAME'];

          MainFRM.sqlQry2.Close;
          grdLedger.cells[3, i] := _trxIndicator; // imposto la scritta standard con indicato se trx in o out
          grdLedger.cells[4, i] := '';            // la categoria anche se compilata la lascio vuota

        end;
        // incremento per record e colonne
        i := i + 1;
        MainFRM.sqlQry.Next;

      end
    else
      // aggiungo una riga vuota per evitare errori in visualizzazione
      grdLedger.RowCount := grdLedger.RowCount + 1;

    _autoSizeGrid;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

  grdLedger.FixedRows := 1;

  // autosize columns
  _autoSizeGrid;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._deleteRecord(_pRecID: string; _pRecRow: Integer; _precType: string);
begin
  // richiesta conferma cancellazione
  if (_pRecID <> '') and (MessageDlg('Confirm Deletion?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    try
      MainFRM.sqlite_conn.StartTransaction;
      // se trasferimento elimino prima il correlato
      if (UpperCase(_precType) = 'TRANSFER') then
      begin
        _SQLString := 'DELETE FROM TRANSACTIONS WHERE TRNID = (SELECT TRNTRANSFERID FROM TRANSACTIONS WHERE TRNID = '
          + _pRecID + ')';
        MainFRM.sqlQry.ExecSQL(_SQLString);
      end;

      // eliminazione del record selezionato in griglia
      MainFRM.sqlQry.ExecSQL('DELETE FROM TRANSACTIONS WHERE TRNID = ' + _pRecID);
      MainFRM.sqlite_conn.Commit;

      // finally
    except
      raise Exception.Create('Error in Deletion. Operation Aborted');
      MainFRM.sqlite_conn.Rollback;
    end;
  grdLedger.Row := _pRecRow;

  // refresh della grid
  _fillGrid();
  _ChartTotals();
end;

// -------------------------------------------------------------------------------------------------------------//

end.
