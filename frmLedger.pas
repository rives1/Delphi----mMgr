unit frmLedger;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, JvExComCtrls, JvComCtrls, RzTreeVw, JvLookOut, JvExControls,
  JvOutlookBar, Vcl.Grids, JvgStringGrid, VclTee.TeeGDIPlus, VclTee.Series, VclTee.TeEngine, RzPanel, VclTee.TeeProcs,
  VclTee.Chart, Vcl.ExtCtrls, RzSplit, JvExGrids, JvStringGrid, RzGrids, JvListView, Vcl.Menus, JvComponentBase,
  JvgExportComponents, Vcl.Imaging.pngimage;

type
  TLedgerFrm = class(TForm)
    RzSplitter1: TRzSplitter;
    chTotals: TChart;
    chHistory: TChart;
    RzStatusBar1: TRzStatusBar;
    Series1: TPieSeries;
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
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    { Private declarations }

    // variabili
    _pAccountName: string; // nominativo dell'account aperto presa dal treemenu all'atto dell'instanza della form
    _SQLString:    string; // var per tutti gli statement sql da comporre

    // local functions
    procedure _clearGrid;
    procedure _autoSizeCol(Grid: TStringGrid; Column: Integer);
    procedure _autoSizeGrid;
    procedure _ChartTotals;
    procedure _deleteRecord(_pRecID: string; _pRecRow: Integer; _precType: string);
    procedure _openRecordForm(_pEditKind: string);

  public
    { Public declarations }
    procedure _fillGrid;

  end;

var
  LedgerFrm: TLedgerFrm;

implementation

{$R *.dfm}


uses
  frmMain, frmInsEdit, System.DateUtils;

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
procedure TLedgerFrm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
      _deleteRecord(grdLedger.cells[0, grdLedger.Row], grdLedger.Row, grdLedger.cells[1, grdLedger.Row]);
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
  _dx:    Integer;
  _Text:  string;
  _Float: Double;
  _s: string; //val su cui eseguire check per immagine
  _aCanvas : TCanvas;
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
          Canvas.Brush.Color := $C4EDFF
          // else
          // Canvas.Brush.Color := $00FFEBDF;
      end;

      // Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, cells[ACol, ARow]);
      Canvas.TextRect(Rect, Rect.Left + 3, Rect.Top + 3, cells[ACol, ARow]);
      Canvas.TextRect(Rect, Rect.Left, Rect.Top, cells[ACol, ARow]);
      Canvas.FrameRect(Rect);

      // se la colonna 2 è = 1 allora metto l'immagine
      if ACol = 1 then
        begin
          _s := (Sender as TStringGrid).Cells[1, ARow];
          _aCanvas := (Sender as TStringGrid).Canvas;
          _aCanvas.FillRect(Rect);
          if (_s = 'x') then
           _aCanvas.StretchDraw(Rect, Image1.Picture.Bitmap);
        end;

     // rosso se il val è negativo
      if ACol = 9 then
      begin
        _Text := grdLedger.cells[9, ARow];
        TryStrToFloat(_Text.Replace('''', ''), _Float);
        if (_Float < 0) then
          Canvas.Font.Color := clRed
        else
          Canvas.Font.Color := clBlack;

        Canvas.TextRect(Rect, Rect.Left + 3, Rect.Top + 3, cells[8, ARow]);
        Canvas.FrameRect(Rect);
      end;
    end;
  end;

  // allineamento a dx del testo
  if (ACol in [0, 7 .. 9]) and (ARow <> 0) then // right-align text
    with grdLedger.Canvas do
    begin
      // bold per la prima linea delle caption
      FillRect(Rect);
      _Text := grdLedger.cells[ACol, ARow];
      _dx   := TextWidth(_Text) + 3;
      TextOut(Rect.Right - _dx, Rect.Top, _Text);
    end;

end;

// -------------------------------------------------------------------------------------------------------------//
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

  frmInsEdit._pEditType := _pEditKind; // imposto il tipo di editing nella proprietà della form editing
  if _pEditKind = 'edit' then          // passo la tipologia dell'azione da eseguire sulla form editing
    frmInsEdit._pEditID := strToInt(grdLedger.cells[0, i]) // imposto l'ID del record da editare
  else
    frmInsEdit._pEditID := 0; // mando un generico valore da caricare nella form utile x alcuni check

  frmInsEdit._pLedgerName := _pAccountName; // passo il nome del ledger di riferimento del record
  frmInsEdit.Show;
  frmInsEdit.SetFocus;
  // frmInsEdit.ShowModal;                     // nostro la form modale

  // aggiorno i datidella grid
  // _fillGrid();
  // _ChartTotals;

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

  chTotals.Series[0].Clear; // pulisco il grafico
  chHistory.Axes.Bottom.Items.Clear;
  // query totalizzazione depositi
  _SQLString := 'SELECT Sum(TRNAMOUNT) AS Sum_TRNAMOUNT ' +
    ' FROM LedgerView ' +
    ' WHERE ' +
    ' TRNAMOUNT > 0 ' +
    ' AND UCASE(TRNTYPE) <>  ''TRANSFER'' ' +
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
        _lTotal := Abs(StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']));
        // StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']);
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
    ' AND UCASE(TRNTYPE) <>  ''TRANSFER'' ' +
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

  // query totalizzazione spese
  _SQLString := 'SELECT Sum(TRNAMOUNT) AS Sum_TRNAMOUNT ' +
    ' FROM LedgerView ' +
    ' WHERE ' +
    ' TRNAMOUNT < 0 ' +
    ' AND UCASE(TRNTYPE) = ''TRANSFER'' ' +
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
        chTotals.SeriesList[0].Add(_lTotal, 'Trx Out');
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
    ' TRNAMOUNT > 0 ' +
    ' AND UCASE(TRNTYPE) = ''TRANSFER'' ' +
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
        chTotals.SeriesList[0].Add(_lTotal, 'Trx In');
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
  chHistory.Series[0].Clear; // pulisco il grafico
  chHistory.Axes.Bottom.Items.Clear;
  _lTotal := 0; // resetto il conteggio
  i       := 0; // azzero il counter delle colonne
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
  chHistory.Pages.Current := chHistory.Pages.Count;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._fillGrid;
// riempiemnto della grid
var
  _i:            Integer;
  _runSum:       Double;
  _trxIndicator: string;  // indica con i segni > o > se il trasferimento è in entrata o uscita
  _recPosition:  Integer; // posizione del record x riposizionare il marker
begin
  // salvo la riga corrente della grid
  _recPosition := grdLedger.Row;

  // pulizia della grid
  _clearGrid;
  grdLedger.RowCount := 1;

  // inserisco le caption
  grdLedger.cells[0, 0] := 'ID';
  grdLedger.cells[1, 0] := 'Chk';
  grdLedger.cells[2, 0] := 'Type';
  grdLedger.cells[3, 0] := 'Date';
  grdLedger.cells[4, 0] := 'wk';
  grdLedger.cells[5, 0] := 'Payee';
  grdLedger.cells[6, 0] := 'Category';
  grdLedger.cells[7, 0] := 'In';
  grdLedger.cells[8, 0] := 'Out';
  grdLedger.cells[9, 0] := 'Balance';
  grdLedger.cells[10, 0] := 'Description';

  // estrazione dati dal db e riempimento della grid
  _SQLString := 'SELECT *, StrfTime(''%W'', TRNDATE) AS WW FROM LedgerView where ACCNAME = ''' + _pAccountName +
    ''' ORDER BY TRNDATE, TRNID';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    _i      := 1;
    _runSum := 0;
    if (MainFRM.sqlQry.RecordCount <> 0) then
      while not MainFRM.sqlQry.EOF do // ciclo recupero dati
      begin
        // inserisco una nuova riga nella grid
        grdLedger.RowCount := grdLedger.RowCount + 1;
        // aggiungo i dati alla grid
        grdLedger.cells[0, _i] := MainFRM.sqlQry.FieldValues['TRNID']; // ID
        grdLedger.cells[1, _i] := MainFRM.sqlQry.FieldValues['TRNRECONCILE']; // operazione riconciliata
        grdLedger.cells[2, _i] := MainFRM.sqlQry.FieldValues['TRNTYPE']; // Tipo operazione
        // grdLedger.cells[2, _i] := MainFRM.sqlQry.FieldValues['TRNDATE']; // Data
        grdLedger.cells[3, _i] := FormatDateTime('dd.mmm.yy', MainFRM.sqlQry.FieldValues['TRNDATE']); // Data
        grdLedger.cells[4, _i] := MainFRM.sqlQry.FieldValues['WW']; // Week
        grdLedger.cells[5, _i] := MainFRM.sqlQry.FieldValues['PAYNAME'];
        grdLedger.cells[6, _i] := MainFRM.sqlQry.FieldValues['CATDES'] + ' : ' + MainFRM.sqlQry.FieldValues
          ['SUBCDES'];

        if (MainFRM.sqlQry.FieldValues['TRNAMOUNT'] > 0) then
        begin
          grdLedger.cells[7, _i] := FormatFloat('#,##0.00', MainFRM.sqlQry.FieldValues['TRNAMOUNT']);
          _trxIndicator          := '->';
        end
        else
        begin
          grdLedger.cells[8, _i] := FormatFloat('#,##0.00', MainFRM.sqlQry.FieldValues['TRNAMOUNT'] * -1);
          _trxIndicator          := '<-';
        end;

        _runSum                := _runSum + MainFRM.sqlQry.FieldValues['TRNAMOUNT'];
        grdLedger.cells[9, _i] := FormatFloat('#,##0.00', _runSum);
        grdLedger.cells[10, _i] := MainFRM.sqlQry.FieldValues['TRNDESCRIPTION'];

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
          grdLedger.cells[5, _i] := _trxIndicator; // imposto la scritta standard con indicato se trx in o out
          grdLedger.cells[6, _i] := '';            // la categoria anche se compilata la lascio vuota

        end;
        // incremento per record e colonne
        _i := _i + 1;
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

  // posiziorsi sull'ultimo record nel caso di inserimento e sul precedente in caso di editing
  if _recPosition > grdLedger.RowCount - 1 then
    grdLedger.Row := grdLedger.RowCount - 1
  else
    grdLedger.Row := _recPosition;

  MainFRM._fillBalanceChart;
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
  _fillGrid;
  _ChartTotals();
end;

// -------------------------------------------------------------------------------------------------------------//

end.
