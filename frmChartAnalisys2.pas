unit frmChartAnalisys2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  VclTee.TeEngine, VclTee.TeeProcs, VclTee.Chart, RzPanel, VclTee.Series, FireDAC.Comp.Client, Data.DB, Vcl.Menus,
  JvExStdCtrls, JvCombobox;

type
  TAnalisysFrm2 = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    _fdtFrom: TDateTimePicker;
    _fdtTo: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    GridPanel1: TGridPanel;
    _fAccount: TJvComboBox;
    Label7: TLabel;
    chartCategoryAvg: TChart;
    BarSeries3: TBarSeries;
    _lvAvgCategory: TListView;
    chartCategoryAvgMM: TChart;
    BarSeries1: TBarSeries;
    _lvAverageMM: TListView;
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
    procedure _chartCategoryAvg;
    procedure _chartMMCategoryAvg;

  public
    { Public declarations }
  end;

var
  AnalisysFrm: TAnalisysFrm2;

implementation

{$R *.dfm}


uses
  frmMain, System.dateUtils;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm2.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    27: // ESC
      if (MessageDlg('Close Form?', mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
        Self.Close; // chiudo la form
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm2.FormShow(Sender: TObject);
begin
  _setDefaultDate;
  _loadCmbAccount;
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm2._chartMMCategoryAvg;
var
  _lTotal:   Double;    // calcolo totale da imputare nella serie
  _i:        integer;   // ciclo per asse x elementi da inserire
  _Cat:      string;    // categoria da valutare per inserimento
  _mmPeriod: integer;   // nr di mesi del periodo selezionato x effettuare la media sui mesi
  _lvItem:   TListItem; // item per inserire i dati nelle colonne secondarie

begin
  // chart torta per totale spese categoria
  chartCategoryAvgMM.Series[0].Clear(); // pulisco il grafico

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
  chartCategoryAvgMM.Axes.Bottom.Items.Clear;

  // inizializzo var
  _i        := 0;
  _Cat      := '';
  _mmPeriod := MonthsBetween(_fdtTo.DateTime, _fdtFrom.DateTime) + 1;
  _lvAverageMM.Items.Clear;

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
          chartCategoryAvgMM.Axes.Bottom.Items.Add(_i, MainFRM.sqlQry.FieldValues['CATDES']);
          _Cat := MainFRM.sqlQry.FieldValues['CATDES'];
          _i   := _i + 1;
        end;

        // inserimento dati nelle due serie in base alla tipologia della categoria
        _lTotal := Abs(StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'])) / _mmPeriod;

        // in base al tipo di spesa imputo su quale serie aggiungere il dato
        // if (UpperCase(MainFRM.sqlQry.FieldValues['CATTYPE']) = 'EXPENSE') then
        chartCategoryAvgMM.SeriesList[0].Add(_lTotal);
        // else
        // chartInOutYY.SeriesList[1].Add(_lTotal, MainFRM.sqlQry.FieldValues['YY']);
        // chartCategoryAvg.SeriesList[1].Add(_lTotal);

        // 25.04.20 - fill della listview con i dati della tabella x mostrare il dettaglio della
        // tabella soprastante
        _lvItem         := _lvAverageMM.Items.Add;
        _lvItem.Caption := VarToStr(MainFRM.sqlQry.FieldValues['CATDES']);
        _lvItem.SubItems.Add(FormatFloat('#,##0.00', MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'] * -1));
        _lvItem.SubItems.Add(FormatFloat('#,##0.##', _mmPeriod));
        // MainFRM.sqlQry.FieldValues['Count_TRNID']));
      end;

      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm2._chartCategoryAvg;
var
  _lTotal: Double;    // calcolo totale da imputare nella serie
  _i:      integer;   // ciclo per asse x elementi da inserire
  _Cat:    string;    // categoria da valutare per inserimento
  _lvItem: TListItem; // item per inserire i dati nelle colonne secondarie
begin
  // chart torta per totale spese categoria
  chartCategoryAvg.Series[0].Clear(); // pulisco il grafico

  _SQLString := ' Select CATDES, '
    + ' Avg(TRNAMOUNT) As Avg_TRNAMOUNT, '
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
  _lvAvgCategory.Items.Clear;
  // eseguo ciclo sui dati
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      if MainFRM.sqlQry.FieldValues['Avg_TRNAMOUNT'] <> null then
      begin
        // impostazione descrizione asse X
        if (_Cat <> MainFRM.sqlQry.FieldValues['CATDES']) then
        begin
          chartCategoryAvg.Axes.Bottom.Items.Add(_i, MainFRM.sqlQry.FieldValues['CATDES']);
          _Cat := MainFRM.sqlQry.FieldValues['CATDES'];
          _i   := _i + 1;
        end;

        // inserimento dati nelle due serie in base alla tipologia della categoria
        _lTotal := Abs(StrToFloat(MainFRM.sqlQry.FieldValues['Avg_TRNAMOUNT']));
        // in base al tipo di spesa imputo su quale serie aggiungere il dato
        // if (UpperCase(MainFRM.sqlQry.FieldValues['CATTYPE']) = 'EXPENSE') then
        chartCategoryAvg.SeriesList[0].Add(_lTotal);
        // else
        // chartInOutYY.SeriesList[1].Add(_lTotal, MainFRM.sqlQry.FieldValues['YY']);
        // chartCategoryAvg.SeriesList[1].Add(_lTotal);

        // 25.04.20 - fill della listview con i dati della tabella x mostrare il dettaglio della
        // tabella soprastante
        _lvItem         := _lvAvgCategory.Items.Add;
        _lvItem.Caption := VarToStr(MainFRM.sqlQry.FieldValues['CATDES']);
        _lvItem.SubItems.Add(
          FormatFloat('#,##0.00', MainFRM.sqlQry.FieldValues['Avg_TRNAMOUNT'] * -1)
          );
        _lvItem.SubItems.Add(FormatFloat('#,##0.00', MainFRM.sqlQry.FieldValues['Count_TRNID']));

      end;

      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm2._fAccountSelect(Sender: TObject);
begin
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm2._fdtFromChange(Sender: TObject);
begin
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm2._fdtToChange(Sender: TObject);
begin
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm2._fillChart;
begin
  _chartCategoryAvg;
  _chartMMCategoryAvg;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm2._loadCmbAccount;
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
procedure TAnalisysFrm2._setDefaultDate;
begin
  // imposto le date nella configurazionae YTD
  _fdtFrom.Date := EncodeDate(CurrentYear, 1, 1);
  _fdtTo.Date   := Now();
end;

// -------------------------------------------------------------------------------------------------------------//
end.
