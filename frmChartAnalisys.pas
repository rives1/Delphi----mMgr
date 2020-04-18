unit frmChartAnalisys;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  VclTee.TeEngine, VclTee.TeeProcs, VclTee.Chart, RzPanel, VclTee.Series, FireDAC.Comp.Client, Data.DB;

type
  TAnalisysFrm = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    _fdtFrom: TDateTimePicker;
    _fdtTo: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    GridPanel1: TGridPanel;
    chartExpByCat: TChart;
    Series1: TPieSeries;
    Chart2: TChart;
    Series2: TLineSeries;
    chartInOutYY: TChart;
    Series3: TBarSeries;
    Series5: TBarSeries;
    chartInOutMM: TChart;
    BarSeries1: TBarSeries;
    BarSeries2: TBarSeries;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure _fdtFromChange(Sender: TObject);
    procedure _fdtToChange(Sender: TObject);
  private
    { Private declarations }
    _SQLString: string; // container x query string

    procedure _setDefaultDate;
    procedure _fillChart;
    procedure _chartExpByCategories;
    procedure _chartInOutYY;
    procedure _chartInOutMM;

  public
    { Public declarations }
  end;

var
  AnalisysFrm: TAnalisysFrm;

implementation

{$R *.dfm}


uses
  frmMain;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm.FormShow(Sender: TObject);
begin
  _setDefaultDate;
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm._chartExpByCategories;
var
  _lTotal: Double;
begin
  _lTotal := 0; // totale dei singoli record da imputare nel grafico

  // chart torta per totale spese categoria
  chartExpByCat.Series[0].Clear(); // pulisco il grafico
  _SQLString := 'Select CATDES, Sum(TRANSACTIONS.TRNAMOUNT) As Sum_TRNAMOUNT '
    + ' From TRANSACTIONS Inner Join '
    + ' DBCATEGORY On CATID = TRNCATEGORY '
    + ' Where '
    + ' CATDES <> ''_Transfer'' And '
    + ' CATTYPE = ''Expense'' And'
    + ' TRNDATE Between '''
    + FormatDateTime('yyyy-mm-dd', _fdtFrom.Date)
    + ''' and '''
    + FormatDateTime('yyyy-mm-dd', _fdtTo.Date)
    + ''' Group By CATDES '
    + ' Order By Sum_TRNAMOUNT Desc';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      if MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'] <> null then
      begin
        _lTotal := Abs(StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']));
        chartExpByCat.SeriesList[0].Add(_lTotal, MainFRM.sqlQry.FieldValues['CATDES'] + ' - ' + FloatToStr(_lTotal));
      end;
      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;
end;

{
  procedure TAnalisysFrm._chartExpByCategories;
  var
  //  _lTotal: Double;
  _i:         integer;     // ciclo for
  _tempTable: TFDMemTable; // tabella appogio per report

  begin
  //  _lTotal := 0; // totale dei singoli record da imputare nel grafico
  // pulisco il grafico
  chartInOutMM.Series[0].Clear();
  chartInOutMM.Series[1].Clear();
  // inizializzo la struttura della tabella
  _tempTable := TFDMemTable.Create(nil);
  _tempTable.FieldDefs.Add('fPeriod', ftInteger);
  _tempTable.FieldDefs.Add('fType', ftString, 10);
  _tempTable.FieldDefs.Add('fValue', ftFloat);
  _tempTable.CreateDataSet;
  _tempTable.Open;
  // impostazione valori default della tabella
  for _i := 1 to 12 do
  begin
  _tempTable.Append;
  _tempTable.FieldByName('fPeriod').AsInteger := _i;
  _tempTable.FieldByName('fType').AsString    := 'EXPENSE';
  _tempTable.FieldByName('fValue').AsFloat    := 0;
  _tempTable.Post;
  _tempTable.Append;
  _tempTable.FieldByName('fPeriod').AsInteger := _i;
  _tempTable.FieldByName('fType').AsString    := 'INCOME';
  _tempTable.FieldByName('fValue').AsFloat    := 0;
  _tempTable.Post;
  end;

  _SQLString := ' SELECT StrfTime(''%m'', TRANSACTIONS.TRNDATE) As MM, CATTYPE, '
  + ' Sum(TRANSACTIONS.TRNAMOUNT) As Sum_TRNAMOUNT '
  + ' From '
  + ' TRANSACTIONS Left Join '
  + ' DBCATEGORY On DBCATEGORY.CATID = TRANSACTIONS.TRNCATEGORY '
  + ' Where CATDES <> ''_Transfer'' '
  + ' And TRNDATE Between '''
  + FormatDateTime('yyyy-mm-dd', _fdtFrom.Date)
  + ''' and '''
  + FormatDateTime('yyyy-mm-dd', _fdtTo.Date)
  + ''' Group By '
  + ' StrfTime(''%m'', TRANSACTIONS.TRNDATE), CATTYPE '
  + ' Order By '
  + ' StrfTime(''%m'', TRANSACTIONS.TRNDATE), CATTYPE ';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);

  // chart torta per totale spese categoria
  chartExpByCat.Series[0].Clear(); // pulisco il grafico
  _SQLString := 'Select CATDES, Sum(TRANSACTIONS.TRNAMOUNT) As Sum_TRNAMOUNT '
  + ' From TRANSACTIONS Inner Join '
  + ' DBCATEGORY On CATID = TRNCATEGORY '
  + ' Where '
  + ' CATDES <> ''_Transfer'' And '
  + ' CATTYPE = ''Expense'' And'
  + ' TRNDATE Between '''
  + FormatDateTime('yyyy-mm-dd', _fdtFrom.Date)
  + ''' and '''
  + FormatDateTime('yyyy-mm-dd', _fdtTo.Date)
  + ''' Group By CATDES '
  + ' Order By Sum_TRNAMOUNT Desc';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
  MainFRM.sqlQry.Open;
  while not MainFRM.sqlQry.EOF do // ciclo recupero dati
  begin
  if MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'] <> null then
  begin
  _lTotal := Abs(StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']));
  chartExpByCat.SeriesList[0].Add(_lTotal, MainFRM.sqlQry.FieldValues['CATDES'] + ' - ' + FloatToStr(_lTotal));
  end;
  MainFRM.sqlQry.Next;
  end;
  finally
  MainFRM.sqlQry.Close;
  MainFRM.sqlQry.SQL.Clear;
  end;
  end; }
// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm._chartInOutMM;
var
  _lTotal:    Double;      // calcolo totale da imputare nella serie
  _i:         integer;     // ciclo for
  _tempTable: TFDMemTable; // tabella appogio per report
begin
  _lTotal := 0; // totale dei singoli record da imputare nel grafico

  // pulisco il grafico
  chartInOutMM.Series[0].Clear();
  chartInOutMM.Series[1].Clear();
  // inizializzo la struttura della tabella
  _tempTable := TFDMemTable.Create(nil);
  _tempTable.FieldDefs.Add('fPeriod', ftInteger);
  _tempTable.FieldDefs.Add('fType', ftString, 10);
  _tempTable.FieldDefs.Add('fValue', ftFloat);
  _tempTable.CreateDataSet;
  _tempTable.Open;
  // impostazione valori default della tabella
  for _i := 1 to 12 do
  begin
    _tempTable.Append;
    _tempTable.FieldByName('fPeriod').AsInteger := _i;
    _tempTable.FieldByName('fType').AsString    := 'EXPENSE';
    _tempTable.FieldByName('fValue').AsFloat    := 0;
    _tempTable.Post;
    _tempTable.Append;
    _tempTable.FieldByName('fPeriod').AsInteger := _i;
    _tempTable.FieldByName('fType').AsString    := 'INCOME';
    _tempTable.FieldByName('fValue').AsFloat    := 0;
    _tempTable.Post;
  end;

  _SQLString := ' SELECT StrfTime(''%m'', TRANSACTIONS.TRNDATE) As MM, CATTYPE, '
    + ' Sum(TRANSACTIONS.TRNAMOUNT) As Sum_TRNAMOUNT '
    + ' From '
    + ' TRANSACTIONS Left Join '
    + ' DBCATEGORY On DBCATEGORY.CATID = TRANSACTIONS.TRNCATEGORY '
    + ' Where CATDES <> ''_Transfer'' '
    + ' And TRNDATE Between '''
    + FormatDateTime('yyyy-mm-dd', _fdtFrom.Date)
    + ''' and '''
    + FormatDateTime('yyyy-mm-dd', _fdtTo.Date)
    + ''' Group By '
    + ' StrfTime(''%m'', TRANSACTIONS.TRNDATE), CATTYPE '
    + ' Order By '
    + ' StrfTime(''%m'', TRANSACTIONS.TRNDATE), CATTYPE ';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  chartInOutMM.Axes.Bottom.Items.Clear;

  // _MM := 0;
  // eseguo ciclo sui dati
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      // cerco nella tabella il record del periodo e del tipo di movimento
      _tempTable.First;
      while not _tempTable.EOF do
      begin
        if (StrToInt(MainFRM.sqlQry.FieldValues['MM']) = _tempTable.FieldByName('fPeriod').AsInteger)
          and (UpperCase(MainFRM.sqlQry.FieldValues['CATTYPE']) = _tempTable.FieldByName('fType').AsString) then
        begin
          _tempTable.Edit;
          _tempTable.FieldByName('fValue').AsFloat := MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'];
          _tempTable.Post
        end;
        _tempTable.Next;
      end;
      MainFRM.sqlQry.Next;
    end;

    // ciclo di riempimento del chart
    _tempTable.First;
    while not _tempTable.EOF do
    begin
      _lTotal := Abs(_tempTable.FieldByName('fValue').AsFloat);
      if UpperCase(_tempTable.FieldByName('fType').AsString) = 'EXPENSE' then
        if _lTotal = 0 then
          chartInOutMM.SeriesList[0].AddNull(0)
        else
          chartInOutMM.SeriesList[0].Add(_lTotal)
      else
      begin
        if _lTotal = 0 then
          chartInOutMM.SeriesList[1].AddNull(0)
        else
          chartInOutMM.SeriesList[1].Add(_lTotal)
      end;
      // etichetta dell'asse x
      chartInOutMM.Axes.Bottom.Items.Add(_tempTable.FieldByName('fPeriod').AsInteger-1,
        _tempTable.FieldByName('fPeriod').AsString);

      _tempTable.Next; // next record
    end;

  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

  _tempTable.Close;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm._chartInOutYY;
var
  _lTotal: Double;  // calcolo totale da imputare nella serie
  _i:      integer; // ciclo per asse x elementi da inserire
  _YY:     integer; // anno da valutare per inserimento
begin
  // _lTotal := 0; // totale dei singoli record da imputare nel grafico

  // chart torta per totale spese categoria
  chartInOutYY.Series[0].Clear(); // pulisco il grafico
  chartInOutYY.Series[1].Clear(); // pulisco il grafico

  _SQLString := ' SELECT StrfTime(''%Y'', TRANSACTIONS.TRNDATE) As YY, CATTYPE, '
    + ' Sum(TRANSACTIONS.TRNAMOUNT) As Sum_TRNAMOUNT '
    + ' From '
    + ' TRANSACTIONS Left Join '
    + ' DBCATEGORY On DBCATEGORY.CATID = TRANSACTIONS.TRNCATEGORY '
    + ' Where CATDES <> ''_Transfer'' '
    + ' And TRNDATE Between '''
    + FormatDateTime('yyyy-mm-dd', _fdtFrom.Date)
    + ''' and '''
    + FormatDateTime('yyyy-mm-dd', _fdtTo.Date)
    + ''' Group By '
    + ' StrfTime(''%Y'', TRANSACTIONS.TRNDATE), CATTYPE '
    + ' Order By '
    + ' StrfTime(''%Y'', TRANSACTIONS.TRNDATE), CATTYPE ';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  chartInOutYY.Axes.Bottom.Items.Clear;
  // inizializzo var
  _i  := 0;
  _YY := 0;
  // eseguo ciclo sui dati
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      if MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'] <> null then
      begin
        // impostazione descrizione asse X
        if (_YY <> MainFRM.sqlQry.FieldValues['YY']) then
        begin
          chartInOutYY.Axes.Bottom.Items.Add(_i, MainFRM.sqlQry.FieldValues['YY']);
          _YY := MainFRM.sqlQry.FieldValues['YY'];
          _i  := _i + 1;
        end;

        // inserimento dati nelle due serie in base alla tipologia della categoria
        _lTotal := Abs(StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']));
        // in base al tipo di spesa imputo su quale serie aggiungere il dato
        if (UpperCase(MainFRM.sqlQry.FieldValues['CATTYPE']) = 'EXPENSE') then
          chartInOutYY.SeriesList[0].Add(_lTotal)
        else
          // chartInOutYY.SeriesList[1].Add(_lTotal, MainFRM.sqlQry.FieldValues['YY']);
          chartInOutYY.SeriesList[1].Add(_lTotal);

      end;

      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm._fdtFromChange(Sender: TObject);
begin
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm._fdtToChange(Sender: TObject);
begin
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm._fillChart;
begin
  _chartExpByCategories;
  _chartInOutYY;
  _chartInOutMM;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm._setDefaultDate;
begin
  // imposto le date nella configurazionae YTD
  _fdtFrom.Date := EncodeDate(CurrentYear, 1, 1);
  // _fdtFrom.Date := EncodeDate(2017, 1, 1);
  _fdtTo.Date := Now();
end;

// -------------------------------------------------------------------------------------------------------------//
end.
