unit frmChartAnalisys;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, VclTee.TeEngine,
  VclTee.TeeProcs, VclTee.Chart, RzPanel, VclTee.Series;

type
  TAnalisysFrm = class(TForm)
    RzGridPanel1: TRzGridPanel;
    StatusBar1: TStatusBar;
    Chart1: TChart;
    Panel1: TPanel;
    Chart2: TChart;
    Chart4: TChart;
    Chart5: TChart;
    _fdtFrom: TDateTimePicker;
    _fdtTo: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Series3: TBarSeries;
    Series2: TLineSeries;
    Series1: TPieSeries;
    Series4: TBarSeries;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    _SQLString: string; // container x query string

    procedure _setDefaultDate;
    procedure _fillChart;

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
procedure TAnalisysFrm._fillChart;
var
  _lTotal: Double;
begin
  _lTotal := 0; // totale dei singoli record da imputare nel grafico

  //chart torta per totale spese categoria
  Chart1.Series[0].Clear(); // pulisco il grafico
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
        Chart1.SeriesList[0].Add(_lTotal, MainFRM.sqlQry.FieldValues['CATDES'] + ' - ' + FloatToStr(_lTotal));
      end;
      MainFRM.sqlQry.Next;
    end;
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TAnalisysFrm._setDefaultDate;
begin
  // imposto le date nella configurazionae YTD
  _fdtFrom.Date := EncodeDate(CurrentYear, 1, 1);
  _fdtTo.Date   := Now();
end;

// -------------------------------------------------------------------------------------------------------------//
end.
