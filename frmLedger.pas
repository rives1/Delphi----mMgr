unit frmLedger;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, JvExComCtrls, JvComCtrls,
  RzTreeVw, JvLookOut, JvExControls, JvOutlookBar, Vcl.Grids, JvgStringGrid,
  VclTee.TeeGDIPlus, VclTee.Series, VclTee.TeEngine, RzPanel, VclTee.TeeProcs,
  VclTee.Chart, Vcl.ExtCtrls, RzSplit, JvExGrids, JvStringGrid, RzGrids,
  JvListView, ovcbase, ovctcmmn, ovctable, Vcl.Menus, JvComponentBase, JvgExportComponents;

type
  TLedgerFrm = class(TForm)
    RzSplitter1: TRzSplitter;
    chTotals: TChart;
    chHistory: TChart;
    RzStatusBar1: TRzStatusBar;
    Series1: TPieSeries;
    grdLedger: TJvgStringGrid;
    Series2: TAreaSeries;
    PopupMenu1: TPopupMenu;
    Edit1: TMenuItem;
    Edit2: TMenuItem;
    N1: TMenuItem;
    Delete1: TMenuItem;
    InsertExpensecontinuous1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdLedgerDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure grdLedgerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure grdLedgerDblClick(Sender: TObject);

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
    procedure _deleteRecord;
    procedure _openInsEditForm(_pEditKind: string);

  public
    { Public declarations }
    // gestione proprietà
    // property _AccountNameID : String  read _pAccountName write _pAccountName;

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
  _deleteRecord
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.Edit1Click(Sender: TObject);
begin
  _openInsEditForm('ins');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.Edit2Click(Sender: TObject);
begin
  _openInsEditForm('edit');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { TODO : valutare se vale la pena di chiedere per la chiusura della form del ledger }
  { if (MessageDlg('Close Ledger?', mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
    begin
    Action := caFree;
    Release;
    end
    else
    Action := caNone;
    // Self := nil;
  }
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
  _fillGrid;
  _ChartTotals;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.grdLedgerDblClick(Sender: TObject);
begin
  _openInsEditForm('edit');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.grdLedgerDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
// impostazione del colore alternato nella grid
{ TODO : verificare se qs funziona fa qualcosa alla grid o se vale la pena di eliminarla }
begin
  {
    with (Sender as TStringGrid) do
    begin
    // Don't change color for first Column, first row
    if (ACol = 0) or (ARow = 0) then
    Canvas.Brush.Color := clBtnFace
    else
    begin
    case ACol of
    1:
    Canvas.Font.Color := clBlack;
    2:
    Canvas.Font.Color := clBlue;
    end;
    // Draw the Band
    if ARow mod 2 = 0 then
    Canvas.Brush.Color := clMoneyGreen
    else
    Canvas.Brush.Color := $00FFEBDF;
    Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, cells[ACol, ARow]);
    Canvas.FrameRect(Rect);
    end;
    end;
  }
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.grdLedgerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  /// gestione pressione tasti
  /// INS   - aggiunge nuovo record
  /// +     - aggiungo un nuovo record di spesa e continua con l'inserimento in serie
  /// ENTER - edita il record corrente
  /// ESC   - chiudo la form
  case Key of
    13:                         // ENTER
      _openInsEditForm('edit'); // apro la form di editing del record
    45:                         // INS
      _openInsEditForm('new');  // apro la form in inserimento
    46:                         // DEL
      _deleteRecord;            // elimino record direttamente dalla form del registro
    27:                         // ESC
      Self.Close;
    107:                          // +
      _openInsEditForm('newExp'); // apro la form in inserimento
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._autoSizeCol(Grid: TStringGrid; Column: Integer);
var
  i, W, WMax: Integer;
begin
  WMax := 0;
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
  for i := 0 to grdLedger.ColCount - 1 do
    for J := 1 to grdLedger.RowCount - 1 do
      grdLedger.cells[i, J] := '';
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._ChartTotals;
var
  _lTotal: Double;
  i: Integer;
begin
  //
  // Chart totali IN/OUT
  //

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
      _lTotal := StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']);
      chTotals.SeriesList[0].Add(_lTotal, 'Deposit');
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
      _lTotal := Abs(StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']));
      // FormatFloat('#,##0 K', StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']/1000));
      chTotals.SeriesList[0].Add(_lTotal, 'Expense');
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
  i := 0;                      // azzero il counter delle colonne
  // query totalizzazione spese
  _SQLString := 'SELECT StrfTime(''%Y'', TRNDATE) || ''-'' || StrfTime(''%W'', TRNDATE) AS Period, ' +
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
        _lTotal := _lTotal + (MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']);
        // FormatFloat('#,##0 K', StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']/1000));
        chHistory.Series[0].Add(_lTotal);
        chHistory.Axes.Bottom.Items.Add(i, MainFRM.sqlQry.FieldValues['Period']);
        MainFRM.sqlQry.Next;
        i := i + 1;
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
  i: Integer;
  runSum: Double;
begin
  // pulizia della grid
  _clearGrid;
  grdLedger.RowCount := 1;

  // estrazione dati dal db e riempimento della grid
  _SQLString := 'SELECT * FROM LedgerView where ACCNAME = ''' + _pAccountName + ''' ORDER BY TRNDATE, TRNID';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    i := 1;
    runSum := 0;
    if (MainFRM.sqlQry.RecordCount <> 0) then
      while not MainFRM.sqlQry.EOF do // ciclo recupero dati
      begin
        // inserisco una nuova riga nella grid
        grdLedger.RowCount := grdLedger.RowCount + 1;
        // aggiungo i dati alla grid
        grdLedger.cells[0, i] := MainFRM.sqlQry.FieldValues['TRNID'];
        grdLedger.cells[1, i] := MainFRM.sqlQry.FieldValues['TRNTYPE'];
        grdLedger.cells[2, i] := MainFRM.sqlQry.FieldValues['TRNDATE'];
        grdLedger.cells[3, i] := MainFRM.sqlQry.FieldValues['PAYNAME'];
        if (MainFRM.sqlQry.FieldValues['SUBCDES'] = null) then
          grdLedger.cells[4, i] := MainFRM.sqlQry.FieldValues['CATDES'] + ' : '
        else
          grdLedger.cells[4, i] := MainFRM.sqlQry.FieldValues['CATDES'] + ' : ' + MainFRM.sqlQry.FieldValues['SUBCDES'];

        if (MainFRM.sqlQry.FieldValues['TRNAMOUNT'] > 0) then
          grdLedger.cells[5, i] := FormatFloat('#,##0.00', MainFRM.sqlQry.FieldValues['TRNAMOUNT'])
        else
          grdLedger.cells[6, i] := FormatFloat('#,##0.00', MainFRM.sqlQry.FieldValues['TRNAMOUNT'] * -1);

        runSum := runSum + MainFRM.sqlQry.FieldValues['TRNAMOUNT'];
        grdLedger.cells[7, i] := FormatFloat('#,##0.00', runSum);
        grdLedger.cells[8, i] := MainFRM.sqlQry.FieldValues['TRNDESCRIPTION'];
        // incremento per record e colonne
        i := i + 1;
        MainFRM.sqlQry.Next;

      end;
    _autoSizeGrid;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

  grdLedger.FixedRows := 1;
  // autosize columns
  // _autoSizeGrid;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._openInsEditForm(_pEditKind: string);
var
  frmInsEdit: TInsEditFrm;
  i: Integer; // var x storage del record attuale per poi recuperarlo
begin
  i := grdLedger.Row; // imposto la riga della grid attuale

  // creo la form e la nascondo per poter impostare le proprietà
  frmInsEdit := TInsEditFrm.Create(Self);
  frmInsEdit.Hide;

  // imposto il tipo di editing nella proprietà della form editing
  frmInsEdit._pEditType := _pEditKind;

  // passo la tipologia dell'azione da eseguire sulla form editing
  if _pEditKind = 'edit' then
    frmInsEdit._pEditID := strToInt(grdLedger.cells[0, i]); // imposto l'ID del record da editare

  if (_pEditKind = 'new') or (_pEditKind = 'newExp') then
    frmInsEdit._pEditID := 0; // mando un generico valore da cariccare nella form utile x alcuni check

  // passo il nome del ledger di riferimento del record
  frmInsEdit._pLedgerID := _pAccountName;

  // nostro la form modale
  frmInsEdit.ShowModal;

  // aggiorno i datidella grid
  _fillGrid;
  _ChartTotals;

  grdLedger.Row := i; // reimposto il record della grid su quello precedente
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._deleteRecord;
var
  _vIDRecord: string;
  i: Integer; // posizione della grid
begin
  i := grdLedger.Row;
  _vIDRecord := grdLedger.cells[0, i];
  if (_vIDRecord <> '') and (MessageDlg('Confirm Deletion?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    try
      MainFRM.sqlQry.ExecSQL('DELETE FROM TRANSACTIONS WHERE TRNID = ' + _vIDRecord);
      // ShowMessage('DELETE FROM TRANSACTIONS WHERE TRNID = ' + _vIDRecord);
    finally
      grdLedger.Row := i;
    end;
  end;

  // refresh della grid
  _fillGrid();
  _ChartTotals();
end;

// -------------------------------------------------------------------------------------------------------------//

end.
