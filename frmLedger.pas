unit frmLedger;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, JvExComCtrls, JvComCtrls,
  RzTreeVw, JvLookOut, JvExControls, JvOutlookBar, Vcl.Grids, JvgStringGrid,
  VclTee.TeeGDIPlus, VclTee.Series, VclTee.TeEngine, RzPanel, VclTee.TeeProcs,
  VclTee.Chart, Vcl.ExtCtrls, RzSplit, JvExGrids, JvStringGrid, RzGrids,
  JvListView;

type
  TLedgerFrm = class(TForm)
    RzSplitter1: TRzSplitter;
    chTotals: TChart;
    chHistory: TChart;
    RzStatusBar1: TRzStatusBar;
    Series1: TPieSeries;
    grdLedger: TJvgStringGrid;
    Series2: TAreaSeries;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdLedgerDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure _fillGrid;
    procedure _clearGrid;
    procedure _autoSizeCol(Grid: TStringGrid; Column: Integer);
    procedure _autoSizeGrid;
    procedure grdLedgerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure _ChartTotals;
    procedure _insRecord;
    procedure _editRecord;
    procedure _deleteRecord;

  private
    { Private declarations }
    _pAccountName: string;
    // reminder per quale account aprire -- presa dal treemenu all'atto dell'instanza della form
    _SQLString: string; // var per tutti gli statement sql da comporre

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

procedure TLedgerFrm.FormActivate(Sender: TObject);
begin
  // riempio la grid
  _fillGrid;
  _ChartTotals;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
  Self := nil;
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
procedure TLedgerFrm.grdLedgerDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
// impostazione del colore alternato nella grid
{ TODO : verificare se qs funziona fa qualcosa alla grid o se vale la pena di eliminarla }
begin
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
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm.grdLedgerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // gestione pressione tasti
  // INS - aggiunge nuovo record
  // ENTER - edita il record corrente
  case Key of
    13:
      _editRecord; // apro la form di editing del record
    45:
      _insRecord; // apro la form in inserimento
    46:
      _deleteRecord; // elimino record direttamente dalla form del registro
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
      WMax := W + 10; // aggiungo 10 per avere una migliore visibilità
  end;
  Grid.ColWidths[Column] := WMax + 5;
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
    if (MainFRM.sqlQry.RecordCount <> 0) then
      while not MainFRM.sqlQry.EOF do // ciclo recupero dati
      begin
        _lTotal := StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'] / 1000);
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
    if (MainFRM.sqlQry.RecordCount <> 0) then
      while not MainFRM.sqlQry.EOF do // ciclo recupero dati
      begin
        _lTotal := StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'] / 1000);
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
procedure TLedgerFrm._fillGrid();
// riempiemnto della grid
var
  i: Integer;
  runSum: Double;
begin
  // pulizia della grid
  _clearGrid;
  grdLedger.RowCount := 2;

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
        else
          grdLedger.cells[4, i] := MainFRM.sqlQry.FieldValues['CATDES'] + ' ' + MainFRM.sqlQry.FieldValues['SUBCDES'];

        if (MainFRM.sqlQry.FieldValues['TRNAMOUNT'] > 0) then
          grdLedger.cells[5, i] := FormatFloat('#,##0.00', MainFRM.sqlQry.FieldValues['TRNAMOUNT'])
        else
          grdLedger.cells[6, i] := FormatFloat('#,##0.00', MainFRM.sqlQry.FieldValues['TRNAMOUNT']);

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
  // autosize columns
  _autoSizeGrid;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._insRecord;
var
  frmInsEdit: TInsEditFrm;
begin
  // inserire record

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._deleteRecord;
var
  _vIDRecord: string;
begin
  _vIDRecord := grdLedger.cells[0, grdLedger.Row];

  if (_vIDRecord <> '') and (MessageDlg('Confirm Deletion?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    try
      // MainFRM.sqlQry.ExecSQL('DELETE FROM TRANSACTIONS WHERE TRNID = ' + grdLedger.Cells[0,grdLedger.Row] + ''' ');
      ShowMessage('DELETE FROM TRANSACTIONS WHERE TRNID = ' + _vIDRecord);
    finally
      MainFRM.sqlQry.Close;
      MainFRM.sqlQry.SQL.Clear;
    end;
  end;

  // refresh della grid
  _fillGrid();
  _ChartTotals();
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TLedgerFrm._editRecord;
begin

end;

// -------------------------------------------------------------------------------------------------------------//

end.
