unit frmLedger;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, JvExComCtrls, JvComCtrls,
  RzTreeVw, JvLookOut, JvExControls, JvOutlookBar, Vcl.Grids, JvgStringGrid,
  VclTee.TeeGDIPlus, VclTee.Series, VclTee.TeEngine, RzPanel, VclTee.TeeProcs,
  VclTee.Chart, Vcl.ExtCtrls, RzSplit, JvExGrids, JvStringGrid, RzGrids, JvListView;

type
  TLedgerFrm = class(TForm)
    RzSplitter1: TRzSplitter;
    Chart1: TChart;
    Chart2: TChart;
    RzStatusBar1: TRzStatusBar;
    Series1: TPieSeries;
    Series2: TLineSeries;
    grdLedger: TJvgStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdLedgerDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure _fillGrid(_AccountName: string);
    procedure _clearGrid;
    procedure _autoSizeCol(Grid: TStringGrid; Column: Integer);
    procedure _autoSizeGrid();
    procedure grdLedgerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
    //reminder per quale account aprire -- presa dal treemenu all'atto dell'instanza della form
    _pAccountName : string;

  public
    { Public declarations }
    //gestione proprietÓ
    //property _AccountNameID : String  read _pAccountName write _pAccountName;

  end;

var
  LedgerFrm: TLedgerFrm;

implementation

{$R *.dfm}

uses
  frmMain;

procedure TLedgerFrm.FormActivate(Sender: TObject);
begin
  //riempio la grid
  _fillGrid(_pAccountName);


end;

procedure TLedgerFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
  LedgerFrm := nil;
end;

procedure TLedgerFrm.FormCreate(Sender: TObject);
begin
  // imposto la var privata con il nome dell'account da cui reperire i dati
  _pAccountName := MainFRM.treeMenu.Selected.Text;
  //impostazione del nome dell'account nella barra del titolo della finestra
  self.Caption:=_pAccountName;
end;

procedure TLedgerFrm.grdLedgerDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
// impostazione del colore alternato nella grid
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

procedure TLedgerFrm.grdLedgerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //
end;

procedure TLedgerFrm._autoSizeCol(Grid: TStringGrid; Column: Integer);
var
  i, W, WMax: Integer;
begin
  WMax := 0;
  for i := 0 to (Grid.RowCount - 1) do
  begin
    W := Grid.Canvas.TextWidth(Grid.cells[Column, i]);
    if W > WMax then
      WMax := W+3;  //aggiungo 3 per avere una migliore visibilitÓ
  end;
  Grid.ColWidths[Column] := WMax + 5;
end;

procedure TLedgerFrm._autoSizeGrid;
var
  i: Integer;
begin
  for i := 0 to grdLedger.ColCount - 1 do
    _autoSizeCol(grdLedger, i);
end;

procedure TLedgerFrm._clearGrid;
var
  i: Integer;
  J: Integer;
begin
  for i := 0 to grdLedger.ColCount - 1 do
    for J := 1 to grdLedger.RowCount - 1 do
      grdLedger.cells[i, J] := '';
end;

procedure TLedgerFrm._fillGrid(_AccountName: string);
// riempiemnto della grid
var
  SQLString: string;
var
  i: Integer;
var
  runSum: double;
begin
  // pulizia della grid
  _clearGrid;
  grdLedger.RowCount := 2;

  // estrazione dati dal db e riempimento della grid
  SQLString := 'SELECT * FROM LedgerView where ACCNAME = ''' + _AccountName + ''' ORDER BY TRNDATE, TRNID';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(SQLString);
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

        // FloatToStrFIntl(RunSum, ffGeneral, 15, 0, fvCurrency,FormatSettings);
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

  //autosize columns
  _autoSizeGrid;
end;

end.
