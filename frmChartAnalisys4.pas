unit frmChartAnalisys4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  VclTee.TeEngine, VclTee.TeeProcs, VclTee.Chart, RzPanel, VclTee.Series, FireDAC.Comp.Client, Data.DB, Vcl.Menus,
  JvExStdCtrls, JvCombobox;

type
  TAnalisysFrm4 = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    _fdtFrom: TDateTimePicker;
    _fdtTo: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    GridPanel1: TGridPanel;
    _fAccount: TJvComboBox;
    Label7: TLabel;
    chartPayeeSpent: TChart;
    Series1: THorizBarSeries;
    chartPayeeMost: TChart;
    Series2: TPieSeries;
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
    procedure _chartPayee;

  public
    { Public declarations }
  end;

var
  AnalisysFrm: TAnalisysFrm4;

implementation

{$R *.dfm}


uses
  frmMain, System.dateUtils;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm4.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    27: // ESC
      if (MessageDlg('Close Form?', mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
        Self.Close; // chiudo la form
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm4.FormShow(Sender: TObject);
begin
  _setDefaultDate;
  _loadCmbAccount;
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm4._chartPayee;
var
  _i:              integer; // ciclo per asse x elementi da inserire
  _PayeeCondition: string;  // categoria da valutare per inserimento

begin
  chartPayeeSpent.Series[0].Clear(); // pulisco il grafico
  chartPayeeMost.Series[0].Clear();  // pulisco il grafico

  _SQLString := ' Select PAYNAME, '
    + ' Abs(Sum(LedgerView.TRNAMOUNT)) As Sum_TRNAMOUNT, '
    + ' Count(Distinct LedgerView.TRNAMOUNT) As Count_TRNAMOUNT '
    + ' From LedgerView '
    + ' Where '
    + ' CATDES <> ''_Transfer'' '
    + ' And UCASE(CATTYPE) = ''EXPENSE'' ';

  if (_fAccount.Text <> 'ALL') then
    _SQLString := _SQLString + ' and ACCNAME = ''' + Trim(_fAccount.Text) + ''' ';

  _SQLString   := _SQLString
    + ' And TRNDATE Between ''' + FormatDateTime('yyyy-mm-dd', _fdtFrom.Date)
    + ''' and ''' + FormatDateTime('yyyy-mm-dd', _fdtTo.Date)
    + ''' Group By PAYNAME '
    + 'Order By Sum_TRNAMOUNT';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);

  chartPayeeSpent.Axes.Left.Items.Clear;
  chartPayeeMost.Axes.Left.Items.Clear;

  // inizializzo var
  _i              := 0;
  _PayeeCondition := '';

  // eseguo ciclo sui dati
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      if MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'] <> null then
      begin
        // impostazione descrizione asse X
        if (_PayeeCondition <> MainFRM.sqlQry.FieldValues['PAYNAME']) then
        begin
          chartPayeeSpent.Axes.Left.Items.Add(_i, MainFRM.sqlQry.FieldValues['PAYNAME']);
//          chartPayeeMost.Axes.Left.Items.Add(_i, MainFRM.sqlQry.FieldValues['PAYNAME']);
          _PayeeCondition := MainFRM.sqlQry.FieldValues['PAYNAME'];
          _i              := _i + 1;
        end;

        // inserimento dati nelle due serie in base alla tipologia della categoria
        chartPayeeSpent.SeriesList[0].Add(StrToFloat(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']));
        chartPayeeMost.SeriesList[0].Add(StrToFloat(MainFRM.sqlQry.FieldValues['Count_TRNAMOUNT']), MainFRM.sqlQry.FieldValues['PAYNAME']);
      end;

      MainFRM.sqlQry.Next;
    end; //ciclo qry
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end; //try

end;
// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm4._fAccountSelect(Sender: TObject);
begin
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm4._fdtFromChange(Sender: TObject);
begin
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm4._fdtToChange(Sender: TObject);
begin
  _fillChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm4._fillChart;
begin
  _chartPayee;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm4._loadCmbAccount;
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
procedure TAnalisysFrm4._setDefaultDate;
begin
  // imposto le date nella configurazionae YTD
  _fdtFrom.Date := EncodeDate(CurrentYear, 1, 1);
  _fdtTo.Date   := Now();
end;

// -------------------------------------------------------------------------------------------------------------//
end.
