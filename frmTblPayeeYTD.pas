unit frmTblPayeeYTD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, JvExStdCtrls, JvCombobox, Vcl.ExtCtrls, Vcl.Mask,
  JvExMask, JvToolEdit, Vcl.WinXPickers, Vcl.WinXCalendars, VclTee.TeeGDIPlus, VclTee.TeEngine, VclTee.Series,
  VclTee.TeeProcs, VclTee.Chart;

type
  TtblPayeeFrm = class(TForm)
    StatusBar1: TStatusBar;
    _fLvPayeeYTD: TListView;
    Panel1: TPanel;
    Label1: TLabel;
    Label7: TLabel;
    _fAccount: TJvComboBox;
    _fYear: TDatePicker;
    Panel2: TPanel;
    chartPayeeMM: TChart;
    Splitter1: TSplitter;
    BarSeries2: TBarSeries;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure _fAccountSelect(Sender: TObject);
    procedure _fYearChange(Sender: TObject);
    procedure _fLvPayeeYTDClick(Sender: TObject);
  private
    // variable
    _SQLString: string;
    // procedures
    procedure _loadCmbAccount;
    procedure _genPayeeYTD;
    procedure _genChartMM;

  public
    { Public declarations }

  end;

var
  tblBalanceFrm: TtblPayeeFrm;

implementation

{$R *.dfm}


uses frmMain;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblPayeeFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblPayeeFrm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    27: // ESC
      if (MessageDlg('Close Form?', mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
        Self.Close; // chiudo la form
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblPayeeFrm.FormShow(Sender: TObject);
begin
  _loadCmbAccount;
  _genPayeeYTD;
  chartPayeeMM.Series[0].Clear;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblPayeeFrm._genChartMM;
const
  _nomeMese: array [0 .. 11] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'Mag', 'Jun', 'Jul',
    'Aug', 'Sep', 'Oct', 'Nov', 'Dic'); // nome dei mesi
var
  _i: integer; // x ciclo for
begin
  chartPayeeMM.Series[0].Clear(); // pulisco il grafico

  _SQLString := 'Select '
    + ' PAYNAME, '
    + ' StrfTime(''%m'', TRNDATE) as MM, '
    + ' abs(Sum(TRNAMOUNT)) As Sum_TRNAMOUNT '
    + ' From LedgerView '
    + ' Where CATDES <> ''_Transfer'' '
    + ' and PAYNAME = ''' + _fLvPayeeYTD.Selected.Caption + ''' '
    + ' and StrfTime(''%Y'', TRNDATE) = '''
    + FormatDateTime('yyyy', _fYear.Date) + ''' ';

  if (_fAccount.Text <> 'ALL') then
    _SQLString := _SQLString + ' and ACCNAME = ''' + Trim(_fAccount.Text) + ''' ';

  _SQLString := _SQLString
    + ' Group By PAYNAME, MM '
    + ' Order By MM ';

  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      for _i := 0 to 11 do // ciclo sui campi dei mesi della memtable che ha 16 campi
      begin
        // inserisco il valore di default di 00
        if (_i + 1 = MainFRM.sqlQry.FieldValues['MM']) then
        begin
          chartPayeeMM.Series[0].Add(MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT']);
          MainFRM.sqlQry.Next;
        end
        else
          chartPayeeMM.Series[0].AddNull(0);

      end; // for

      MainFRM.sqlQry.Next;
    end; // EOF query
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;

    // aggiungo i nomi dei mesi
    chartPayeeMM.Axes.Bottom.Items.Clear;
    for _i := 0 to 11 do
      chartPayeeMM.Axes.Bottom.Items.Add(_i, _nomeMese[_i]); // descr asse

  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblPayeeFrm._fAccountSelect(Sender: TObject);
begin
  _genPayeeYTD;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblPayeeFrm._fLvPayeeYTDClick(Sender: TObject);
begin
  _genChartMM;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblPayeeFrm._fYearChange(Sender: TObject);
begin
  _genPayeeYTD;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblPayeeFrm._loadCmbAccount;
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
procedure TtblPayeeFrm._genPayeeYTD;
var
  _lvItem: TListItem; // item per inserire i dati nelle colonne secondarie

begin
  _fLvPayeeYTD.Items.Clear; // pulisco la listview
  _SQLString := 'Select PAYNAME, '
    + ' Abs(Sum(TRNAMOUNT)) As Sum_TRNAMOUNT, '
    + ' Sum(LedgerView.TRNAMOUNT) / '
    + '       (select sum(TRNAMOUNT) from LedgerView '
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
    + ' Group By PAYNAME '
    + ' Order By Sum_TRNAMOUNT Desc';

  MainFRM.sqlQry.Close;
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      _lvItem         := _fLvPayeeYTD.Items.Add; // inserisco i dati nella listview
      _lvItem.Caption := MainFRM.sqlQry.FieldValues['PAYNAME'];
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
