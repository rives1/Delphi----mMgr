unit frmChartAnalisys1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  VclTee.TeEngine, VclTee.TeeProcs, VclTee.Chart, RzPanel, VclTee.Series, FireDAC.Comp.Client, Data.DB, Vcl.Menus,
  JvExStdCtrls, JvCombobox;

type
  TAnalisysFrm1 = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    _fdtFrom: TDateTimePicker;
    _fdtTo: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    GridPanel1: TGridPanel;
    chartExpByCat: TChart;
    Series1: TPieSeries;
    chartInOutYY: TChart;
    Series3: TBarSeries;
    Series5: TBarSeries;
    chartInOutMM: TChart;
    BarSeries1: TBarSeries;
    BarSeries2: TBarSeries;
    _fAccount: TJvComboBox;
    Label7: TLabel;
    chartCategoryAvg: TChart;
    BarSeries3: TBarSeries;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure _fdtFromChange(Sender: TObject);
    procedure _fdtToChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure _fAccountSelect(Sender: TObject);

  private
    { Private declarations }
    _SQLString: string; // container x query string

    procedure _setDefaultDate;
    procedure _loadCmbAccount;
    procedure _fillChart;
    procedure _chartExpByCategories;
    procedure _chartInOutYY;
    procedure _chartInOutMM;
    procedure _chartMMCategoryAvg;

  public
    { Public declarations }
  end;

var
  AnalisysFrm1: TAnalisysFrm1;

implementation

{$R *.dfm}


uses
  frmMain, System.dateUtils;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    27: // ESC
      if (MessageDlg('Close Form?', mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
        Self.Close; // chiudo la form
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm1.FormShow(Sender: TObject);
begin
  _setDefaultDate;
  _loadCmbAccount;
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm1._chartMMCategoryAvg;
var
  _lTotal: Double;  // calcolo totale da imputare nella serie
  _i:      integer; // ciclo per asse x elementi da inserire
  _Cat:    string;  // categoria da valutare per inserimento
  _mmPeriod: integer; //nr di mesi del periodo selezionato x effettuare la media sui mesi
begin
  // chart torta per totale spese categoria
  chartCategoryAvg.Series[0].Clear(); // pulisco il grafico

  _SQLString := ' Select CATDES, '
    + ' Sum(TRNAMOUNT) As Sum_TRNAMOUNT, '
    + ' Count(TRNID) As Count_TRNID '
    + ' From '
    + ' TRANSACTIONS Inner Join '
    + ' DBACCOUNT On ACCID = TRNACCOUNT Inner Join '
    + ' DBSUBCATEGORY On SUBCID = TRNSUBCATEGORY Inner Join '
    + ' DBCATEGORY On CATID = SUBCATID '
  // + ' TRANSACTIONS Left Join '
  // + ' DBCATEGORY On CATID = TRNCATEGORY Inner Join '
  // + ' DBACCOUNT On ACCID = TRNACCOUNT '
    + ' Where '
    + ' CATDES <> ''_Transfer'' ';
  if (_fAccount.Text <> 'ALL') then
    _SQLString := _SQLString + ' and ACCNAME = ''' + Trim(_fAccount.Text) + ''' ';
  _SQLString   := _SQLString
    + ' And TRNDATE Between ''' + FormatDateTime('yyyy-mm-dd', _fdtFrom.Date)
    + ''' and ''' + FormatDateTime('yyyy-mm-dd', _fdtTo.Date)
    + ''' Group By CATDES ';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  chartCategoryAvg.Axes.Bottom.Items.Clear;

  // inizializzo var
  _i   := 0;
  _Cat := '';
  _mmPeriod:=MonthsBetween(_fdtTo.DateTime, _fdtFrom.DateTime)+1;
  // eseguo ciclo sui dati
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      if MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'] <> null then
      begin
        // impostazione descrizione asse X
        if (_Cat <> MainFRM.sqlQry.FieldValues['CATDES']) then
        begin
          chartCategoryAvg.Axes.Bottom.Items.Add(_i, MainFRM.sqlQry.FieldValues['CATDES']);
          _Cat := MainFRM.sqlQry.FieldValues['CATDES'];
          _i   := _i + 1;
        end;

        // inserimento dati nelle due serie in base alla tipologia della categoria
        _lTotal := Abs(StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']))/_mmPeriod;

        // in base al tipo di spesa imputo su quale serie aggiungere il dato
        // if (UpperCase(MainFRM.sqlQry.FieldValues['CATTYPE']) = 'EXPENSE') then
        chartCategoryAvg.SeriesList[0].Add(_lTotal)
        // else
        // chartInOutYY.SeriesList[1].Add(_lTotal, MainFRM.sqlQry.FieldValues['YY']);
        // chartCategoryAvg.SeriesList[1].Add(_lTotal);
      end;

      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm1._chartExpByCategories;
var
  _lTotal: Double;
begin
  _lTotal := 0; // totale dei singoli record da imputare nel grafico

  // chart torta per totale spese categoria
  chartExpByCat.Series[0].Clear(); // pulisco il grafico
  _SQLString := 'Select CATDES, Sum(TRANSACTIONS.TRNAMOUNT) As Sum_TRNAMOUNT '
    + ' From TRANSACTIONS Inner Join '
    + ' DBACCOUNT On ACCID = TRNACCOUNT Inner Join '
    + ' DBSUBCATEGORY On SUBCID = TRNSUBCATEGORY Inner Join '
    + ' DBCATEGORY On CATID = SUBCATID '
  // + ' From TRANSACTIONS Inner Join '
  // + ' DBCATEGORY On CATID = TRNCATEGORY Inner Join '
  // + ' DBACCOUNT On ACCID = TRNACCOUNT '
    + ' Where '
    + ' CATDES <> ''_Transfer'' And '
    + ' CATTYPE = ''Expense'' And';

  if (_fAccount.Text <> 'ALL') then
    _SQLString := _SQLString + ' ACCNAME = ''' + Trim(_fAccount.Text) + ''' and ';

  _SQLString := _SQLString
    + ' TRNDATE Between '''
    + FormatDateTime('yyyy-mm-dd', _fdtFrom.Date)
    + ''' and '''
    + FormatDateTime('yyyy-mm-dd', _fdtTo.Date)
    + ''' Group By CATDES';

    //non necessario effettuare raggruppamento il campo serve solo per filtrare
    //  if (_fAccount.Text <> 'ALL') then
//    _SQLString := _SQLString + ', ACCNAME ';

  _SQLString := _SQLString + ' Order By Sum_TRNAMOUNT Desc';

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

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm1._chartInOutMM;
var
  _lTotal:    Double;      // calcolo totale da imputare nella serie
  _i:         integer;     // ciclo for
  _tempTable: TFDMemTable; // tabella appogio per report
begin
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

  _SQLString := ' SELECT StrfTime(''%m'', TRNDATE) As MM, CATTYPE, '
    + ' Sum(TRNAMOUNT) As Sum_TRNAMOUNT '
    + ' From '
    + ' TRANSACTIONS Inner Join '
    + ' DBACCOUNT On ACCID = TRNACCOUNT Inner Join '
    + ' DBSUBCATEGORY On SUBCID = TRNSUBCATEGORY Inner Join '
    + ' DBCATEGORY On CATID = SUBCATID '
//    + ' TRANSACTIONS Left Join '
//    + ' DBCATEGORY On CATID = TRNCATEGORY Inner Join '
//    + ' DBACCOUNT On ACCID = TRNACCOUNT '
    + ' Where CATDES <> ''_Transfer'' ';
  if (_fAccount.Text <> 'ALL') then
    _SQLString := _SQLString + ' and ACCNAME = ''' + Trim(_fAccount.Text) + ''' ';

  _SQLString := _SQLString
    + ' and TRNDATE Between '''
    + FormatDateTime('yyyy-mm-dd', _fdtFrom.Date)
    + ''' and '''
    + FormatDateTime('yyyy-mm-dd', _fdtTo.Date)
    + ''' Group By '
    + ' StrfTime(''%m'', TRNDATE), CATTYPE '
    + ' Order By '
    + ' StrfTime(''%m'', TRNDATE), CATTYPE ';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  chartInOutMM.Axes.Bottom.Items.Clear;

  // eseguo ciclo sui dati inserendo i dati nella tabella
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

    _lTotal := 0; // totale dei singoli record da imputare nel grafico
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
      chartInOutMM.Axes.Bottom.Items.Add(_tempTable.FieldByName('fPeriod').AsInteger - 1,
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
procedure TAnalisysFrm1._chartInOutYY;
var
  _lTotal: Double;  // calcolo totale da imputare nella serie
  _i:      integer; // ciclo per asse x elementi da inserire
  _YY:     integer; // anno da valutare per inserimento
begin
  // chart torta per totale spese categoria
  chartInOutYY.Series[0].Clear(); // pulisco il grafico
  chartInOutYY.Series[1].Clear(); // pulisco il grafico

  _SQLString := ' SELECT StrfTime(''%Y'', TRNDATE) As YY, CATTYPE, '
    + ' Sum(TRNAMOUNT) As Sum_TRNAMOUNT '
    + ' From '
    + ' TRANSACTIONS Inner Join '
    + ' DBACCOUNT On ACCID = TRNACCOUNT Inner Join '
    + ' DBSUBCATEGORY On SUBCID = TRNSUBCATEGORY Inner Join '
    + ' DBCATEGORY On CATID = SUBCATID '
    //    + ' TRANSACTIONS Left Join '
//    + ' DBCATEGORY On CATID = TRNCATEGORY Inner Join '
//    + ' DBACCOUNT On ACCID = TRNACCOUNT '
    + ' Where CATDES <> ''_Transfer'' ';
  if (_fAccount.Text <> 'ALL') then
    _SQLString := _SQLString + ' and ACCNAME = ''' + Trim(_fAccount.Text) + ''' ';

  _SQLString := _SQLString
    + ' And TRNDATE Between '''
    + FormatDateTime('yyyy-mm-dd', _fdtFrom.Date)
    + ''' and '''
    + FormatDateTime('yyyy-mm-dd', _fdtTo.Date)
    + ''' Group By '
    + ' StrfTime(''%Y'', TRNDATE), CATTYPE '
    + ' Order By '
    + ' StrfTime(''%Y'', TRNDATE), CATTYPE ';
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
procedure TAnalisysFrm1._fAccountSelect(Sender: TObject);
begin
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm1._fdtFromChange(Sender: TObject);
begin
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm1._fdtToChange(Sender: TObject);
begin
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm1._fillChart;
begin
  _chartExpByCategories;
  _chartMMCategoryAvg;
  _chartInOutYY;
  _chartInOutMM;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm1._loadCmbAccount;
begin
  // carico i dati nella compo dei payee
  _fAccount.Items.Clear;
  _fAccount.Items.Add('ALL');
  _SQLString := 'SELECT ACCNAME FROM DBACCOUNT ORDER BY ACCNAME';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      // aggiungo solo gli account che non sono quelli del ledger aperto per evitare autotrasferimenti
      // if (MainFRM.sqlQry.FieldValues['ACCNAME'] <> _plLedgerName) then
      _fAccount.Items.Add(MainFRM.sqlQry.FieldValues['ACCNAME']);
      MainFRM.sqlQry.Next;
    end;
  finally
    // _fAccountTo.items.AddStrings(_fAccountFrom.Items); //aggiungo l'elenco in massa prendendolo dal campo riempito
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;
  _fAccount.Text := 'ALL';

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm1._setDefaultDate;
begin
  // imposto le date nella configurazionae YTD
  _fdtFrom.Date := EncodeDate(CurrentYear, 1, 1);
  _fdtTo.Date   := Now();
end;

// -------------------------------------------------------------------------------------------------------------//
end.
