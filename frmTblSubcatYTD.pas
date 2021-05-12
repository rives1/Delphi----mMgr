unit frmTblSubcatYTD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, JvExStdCtrls, JvCombobox, Vcl.ExtCtrls, Vcl.Mask,
  JvExMask, JvToolEdit, Vcl.WinXPickers, Vcl.WinXCalendars, VclTee.TeeGDIPlus, VclTee.TeEngine, VclTee.Series,
  VclTee.TeeProcs, VclTee.Chart;

type
  TtblSubcatFrm = class(TForm)
    StatusBar1: TStatusBar;
    _fLvSubcategoryYTD: TListView;
    Panel1: TPanel;
    Label1: TLabel;
    Label7: TLabel;
    _fAccount: TJvComboBox;
    _fYear: TDatePicker;
    Panel2: TPanel;
    chartSubcatMM: TChart;
    Splitter1: TSplitter;
    BarSeries2: TBarSeries;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure _fAccountSelect(Sender: TObject);
    procedure _fYearChange(Sender: TObject);
    procedure _fLvSubcategoryYTDClick(Sender: TObject);
  private
    // variable
    _SQLString: string;
    // procedures
    procedure _loadCmbAccount;
    procedure _genSubcatYTD;
    procedure _genChartMM;

  public
    { Public declarations }

  end;

var
  tblSubctaFrm: TtblSubcatFrm;

implementation

{$R *.dfm}


uses frmMain;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblSubcatFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblSubcatFrm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    27: // ESC
      if (MessageDlg('Close Form?', mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
        Self.Close; // chiudo la form
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblSubcatFrm.FormShow(Sender: TObject);
begin
  _loadCmbAccount;
  _genSubcatYTD;
  _fYear.Date := Now();
  chartSubcatMM.Series[0].Clear;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblSubcatFrm._genChartMM;
const
  _nomeMese: array [0 .. 11] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'Mag', 'Jun', 'Jul',
    'Aug', 'Sep', 'Oct', 'Nov', 'Dic'); // nome dei mesi
var
  _i:         integer;    // x ciclo for
  _barSeries: TBarSeries; // riferimento alla serie

begin
  chartSubcatMM.SeriesList.Clear(); // pulisco il grafico

  _SQLString := 'Select '
    + ' CATDES, SUBCDES, '
    + ' StrfTime(''%m'', TRNDATE) as MM, '
    + ' abs(Sum(TRNAMOUNT)) As Sum_TRNAMOUNT '
    + ' From LedgerView '
    + ' Where CATDES <> ''_Transfer'' '
    + ' and CATDES = ''' + _fLvSubcategoryYTD.Selected.Caption + ''' '
    + ' and SUBCDES = ''' + _fLvSubcategoryYTD.Selected.SubItems[0] + ''' '
    + ' and StrfTime(''%Y'', TRNDATE) = '''
    + FormatDateTime('yyyy', _fYear.Date) + ''' ';

  if (_fAccount.Text <> 'ALL') then
    _SQLString := _SQLString + ' and ACCNAME = ''' + Trim(_fAccount.Text) + ''' ';

  _SQLString := _SQLString
    + ' Group By CATDES, SUBCDES, MM '
    + ' Order By MM ';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _barSeries                := TBarSeries.Create(Self); // instance of the bar series
      _barSeries.Title          := MainFRM.sqlQry.FieldValues['CATDES'];
//      _barSeries.MultiBar       := mbSelfStack;
      _barSeries.ColorEachPoint := True;
      _barSeries.ParentChart    := chartSubcatMM; // aggiungo la serie al chart
      chartSubcatMM.View3D      := False;

      // inserimento dati
      for _i := 0 to 11 do // ciclo sui campi dei mesi della memtable che ha 16 campi
      begin
        // inserisco il valore di default di 00
        if (_i + 1 = MainFRM.sqlQry.FieldValues['MM']) then
        begin
          _barSeries.Add(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']);
          MainFRM.sqlQry.Next;
        end
        else
          _barSeries.AddNull(0);

      end; // for

      MainFRM.sqlQry.Next;
    end; // EOF query
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;

    // aggiungo i nomi dei mesi
    chartSubcatMM.Axes.Bottom.Items.Clear;
    for _i := 0 to 11 do
      chartSubcatMM.Axes.Bottom.Items.Add(_i, _nomeMese[_i]); // descr asse

  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblSubcatFrm._fAccountSelect(Sender: TObject);
begin
  _genSubcatYTD;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblSubcatFrm._fLvSubcategoryYTDClick(Sender: TObject);
begin
  _genChartMM;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblSubcatFrm._fYearChange(Sender: TObject);
begin
  _genSubcatYTD;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblSubcatFrm._loadCmbAccount;
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
procedure TtblSubcatFrm._genSubcatYTD;
var
  _lvItem: TListItem; // item per inserire i dati nelle colonne secondarie

begin
  _fLvSubcategoryYTD.Items.Clear; // pulisco la listview
  _SQLString := 'Select CATDES, SUBCDES, '
    + ' Sum(Abs(TRNAMOUNT)) As Sum_TRNAMOUNT, '
    + ' Sum(Abs(LedgerView.TRNAMOUNT)) / '
    + '       (select Sum(Abs(TRNAMOUNT)) from LedgerView '
    + '        where CATDES <> ''_Transfer'' '
    + '        and StrfTime(''%Y'', TRNDATE) = '''
    + FormatDateTime('yyyy', _fYear.Date) + ''' '
    + ') as Percentage, '
    + ' Count(*) as Frequency '
    + ' From LedgerView'
    + ' where CATDES <> ''_Transfer'' '
    + ' and StrfTime(''%Y'', TRNDATE) = '''
    + FormatDateTime('yyyy', _fYear.Date) + ''' ';

  if (_fAccount.Text <> 'ALL') then
    _SQLString := _SQLString + ' and ACCNAME = ''' + Trim(_fAccount.Text) + ''' ';

  _SQLString := _SQLString
    + ' Group By CATDES, SUBCDES '
    + ' Order By CATDES';

  MainFRM.sqlQry.Close;
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _lvItem         := _fLvSubcategoryYTD.Items.Add; // inserisco i dati nella listview
      _lvItem.Caption := MainFRM.sqlQry.FieldValues['CATDES'];
      _lvItem.SubItems.Add(MainFRM.sqlQry.FieldValues['SUBCDES']);
      _lvItem.SubItems.Add(FormatFloat('#,##0.00', MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']));
      _lvItem.SubItems.Add(FormatFloat('0.00%', Abs(MainFRM.sqlQry.FieldValues['Percentage']) * 100));
      _lvItem.SubItems.Add(FormatFloat('0.00', MainFRM.sqlQry.FieldValues['Frequency']));
      MainFRM.sqlQry.Next;
    end; // ciclo lettura record

  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

end;
// -------------------------------------------------------------------------------------------------------------//

end.
