unit frmTblBalYTD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, JvExStdCtrls, JvCombobox, Vcl.ExtCtrls, Vcl.Mask,
  JvExMask, JvToolEdit, Vcl.WinXPickers, Vcl.WinXCalendars, VclTee.TeeGDIPlus, VclTee.TeEngine, VclTee.Series,
  VclTee.TeeProcs, VclTee.Chart;

type
  TtblBalanceFrm = class(TForm)
    StatusBar1: TStatusBar;
    _fLvBalanceYTD: TListView;
    Panel1: TPanel;
    Label1: TLabel;
    Label7: TLabel;
    _fAccount: TJvComboBox;
    _btnPrint: TButton;
    _fYear: TDatePicker;
    Panel2: TPanel;
    chartInOutMM: TChart;
    Splitter1: TSplitter;
    BarSeries1: TBarSeries;
    BarSeries2: TBarSeries;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure _btnPrintClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure _fAccountSelect(Sender: TObject);
    procedure _fYearChange(Sender: TObject);
    procedure _fLvBalanceYTDCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer;
      State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    // variable
    _SQLString: string;
    // procedures
    procedure _loadCmbAccount;
    procedure _GenBalanceYTD(_pAction: string);
    procedure _chartInOutMM;

  public
    { Public declarations }

  end;

var
  tblBalanceFrm: TtblBalanceFrm;

implementation

{$R *.dfm}


uses frmMain, pasCommon;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblBalanceFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblBalanceFrm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    27: // ESC
      if (MessageDlg('Close Form?', mtConfirmation, [mbOk, mbCancel], 0) = mrOk) then
        Self.Close; // chiudo la form
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblBalanceFrm.FormShow(Sender: TObject);
begin
  _loadCmbAccount;
  _GenBalanceYTD('table');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblBalanceFrm._btnPrintClick(Sender: TObject);
begin
  _GenBalanceYTD('print');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblBalanceFrm._chartInOutMM;
const
  _nomeMese: array [0 .. 12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'Mag', 'Jun', 'Jul',
    'Aug', 'Sep', 'Oct', 'Nov', 'Dic', 'Total'); // nome dei mesi
var
  _totSubcat:   Double;                    // totale calcolo subcat anno
  _i:           Integer;                   // x ciclo for
  _totChartIN:  array [0 .. 16] of Double; // totali entrate x mese
  _totChartOUT: array [0 .. 16] of Double; // totali uscite x mese

begin
  ///
  /// grafico
  ///

  chartInOutMM.Series[0].Clear(); // pulisco il grafico
  chartInOutMM.Series[1].Clear();
  chartInOutMM.Axes.Bottom.Items.Clear;

  // ciclo sulla tabella per il calcolo dei totali
  MainFRM.fdMemBalYTD.First;
  while not MainFRM.fdMemBalYTD.EOF do
  begin
    for _i := 4 to 16 do // ciclo sui campi dei mesi della memtable che ha 16 campi
    begin
      if (MainFRM.fdMemBalYTD.Fields[_i].Value <> null) then
      begin

        // nella memtable i vaolri sono già correttamente pos o neg quindi devolo solo sommarli
        _totSubcat := _totSubcat + MainFRM.fdMemBalYTD.Fields[_i].Value;

        // nella memtable il primo campo con i mesi è il quatro dell'elenco campi
        // a seconda del tipo di cat se spesa o deposito aggiungo il totale all'array per la serie in/out
        // che si inserirà nel grafico
        if (UpperCase(MainFRM.fdMemBalYTD.FieldByName('rptInOut').Value) = 'EXPENSE') then
          _totChartOUT[_i] := _totChartOUT[_i] + MainFRM.fdMemBalYTD.Fields[_i].Value
        else
          _totChartIN[_i] := _totChartIN[_i] + MainFRM.fdMemBalYTD.Fields[_i].Value;

      end;
    end;
    // totale finale
    // if (UpperCase(MainFRM.fdMemBalYTD.FieldByName('rptInOut').Value) = 'EXPENSE') then
    // _totChartOUT[16] := _totChartOUT[16] + _totSubcat
    // else
    // _totChartIN[16] := _totChartIN[16] + _totSubcat;

    MainFRM.fdMemBalYTD.Next;

  end; // ciclo su memtable

  // ciclo sull'array per inserire i valori nel chart
  for _i := 4 to 16 do
  begin

    chartInOutMM.Axes.Bottom.Items.Add(_i - 4, _nomeMese[_i - 4]); // aggiungo il numero del mese sull'asse del chart

    // serie entrate
    if (_totChartIN[_i] = 0) then
      chartInOutMM.SeriesList[0].AddNull(0)
    else
      chartInOutMM.SeriesList[0].Add(_totChartIN[_i]);

    // serie uscite
    if (_totChartOUT[_i] = 0) then
      chartInOutMM.SeriesList[1].AddNull(0)
    else
      chartInOutMM.SeriesList[1].Add(_totChartOUT[_i] * -1);
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblBalanceFrm._fAccountSelect(Sender: TObject);
begin
  _GenBalanceYTD('table');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblBalanceFrm._fLvBalanceYTDCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  //red color for negative values
  if _isNumeric(Item.SubItems.Strings[SubItem - 1]) then
    if (Item.SubItems.Strings[SubItem - 1].ToSingle < 0) then
      Sender.Canvas.Font.Color := clRed;

  if odd(Item.Index) then //alternate row color
  begin
    Sender.Canvas.Brush.Color := clBtnFace;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblBalanceFrm._fYearChange(Sender: TObject);
begin
  _GenBalanceYTD('table');
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TtblBalanceFrm._loadCmbAccount;
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
procedure TtblBalanceFrm._GenBalanceYTD(_pAction: string);
var
  _totCat:      Double;  // totale da calcolare per i 12 mesi della cat-subcat
  _mmField:     string;  // campo per l'assegnazione del valore
  _subcatCiclo: string;  // condizione per ciclo
  _i:           Integer; // x ciclo for

  _lvItem:    TListItem;                 // item per inserire i dati nelle colonne secondarie
  _totSubcat: Double;                    // totale calcolo subcat anno
  _totMonth:  array [0 .. 13] of Double; // totali per mese + totale globale
begin

  // pulire la memory table prima di procedere
  for _i := 0 to MainFRM.fdMemBalYTD.RecordCount do
  begin
    MainFRM.fdMemBalYTD.Edit;
    MainFRM.fdMemBalYTD.Delete;
  end;

  _SQLString := 'Select CATTYPE, CATDES, SUBCDES, '
    + ' StrfTime(''%Y'', TRNDATE) As YY, '
    + ' StrfTime(''%m'', TRNDATE) As MM, '
    + ' Sum(TRNAMOUNT) As Sum_TRNAMOUNT '
    + ' From '
    + ' TRANSACTIONS Inner Join '
    + ' DBSUBCATEGORY On SUBCID = TRNSUBCATEGORY Inner Join '
    + ' DBCATEGORY On CATID = SUBCATID Inner Join '
    + ' DBACCOUNT On ACCID = TRNACCOUNT '
    + ' Where CATDES <> ''_Transfer'' '
    + ' and StrfTime(''%Y'', TRNDATE) = '''
    + FormatDateTime('yyyy', _fYear.Date) + ''' ';

  // + InputBox('ReferenceYear', 'Insert Year for Report', FormatDateTime('yyyy', now)) + ''' '

  if (_fAccount.Text <> 'ALL') then
    _SQLString := _SQLString + ' and ACCNAME = ''' + Trim(_fAccount.Text) + ''' ';

  _SQLString := _SQLString + ' Group By '
    + ' CATTYPE, '
    + ' CATDES, '
    + ' SUBCDES, '
    + ' StrfTime(''%Y'', TRNDATE), '
    + ' StrfTime(''%m'', TRNDATE) '
    + ' Order By '
    + ' CATTYPE, '
    + ' CATDES, '
    + ' SUBCDES ';

  MainFRM.sqlQry.Close;
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      // travaso i dati dalla qry al recordset costruito per il report
      with MainFRM.fdMemBalYTD do
      begin
        // condizione verifica su quando inserire un record
        if (MainFRM.sqlQry.FieldValues['CATDES'] + MainFRM.sqlQry.FieldValues['SUBCDES'] <> _subcatCiclo) then
        begin
          Insert;
          _totCat := 0;
        end;

        // inserisco i dati nella memtable
        FieldByName('rptInOut').Value  := MainFRM.sqlQry.FieldValues['CATTYPE'];
        FieldByName('rptYY').Value     := MainFRM.sqlQry.FieldValues['YY'];
        FieldByName('rptCat').Value    := MainFRM.sqlQry.FieldValues['CATDES'];
        FieldByName('rptSubCat').Value := MainFRM.sqlQry.FieldValues['SUBCDES'];

        case StrToInt(MainFRM.sqlQry.FieldValues['MM']) of // in base al mese imposto i dati nel campo colonna-mese
          1:
            _mmField := 'rptJan';
          2:
            _mmField := 'rptFeb';
          3:
            _mmField := 'rptMar';
          4:
            _mmField := 'rptApr';
          5:
            _mmField := 'rptMay';
          6:
            _mmField := 'rptJun';
          7:
            _mmField := 'rptJul';
          8:
            _mmField := 'rptAug';
          9:
            _mmField := 'rptSep';
          10:
            _mmField := 'rptOct';
          11:
            _mmField := 'rptNov';
          12:
            _mmField := 'rptDec';
        end;

        // assegno il valore al campo
        FieldByName(_mmField).Value     := MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'];
        _totCat                         := _totCat + MainFRM.sqlQry.FieldValues['Sum_TRNAMOUNT'];
        FieldByName('rptTotLine').Value := _totCat;

        Update;
      end;
      _subcatCiclo := MainFRM.sqlQry.FieldValues['CATDES'] + MainFRM.sqlQry.FieldValues['SUBCDES'];
      MainFRM.sqlQry.Next;
    end; // ciclo lettura record

  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

  if (UpperCase(_pAction) = 'PRINT') then
  begin
    // apertura report
    MainFRM.rptStandard.LoadFromFile(ExtractFilePath(Application.ExeName) + '\report\Balance-YTD.fr3');
    MainFRM.rptStandard.ShowReport();
  end;

  ///
  ///
  /// ciclo su mem tab per recuperare i dati e metterli nell listview
  ///
  ///

  // pulire la tabella
  if (UpperCase(_pAction) = 'TABLE') then
  begin
    _fLvBalanceYTD.Items.Clear; // pulisco la listview
    _fLvBalanceYTD.AllocBy := 5000;
    _fLvBalanceYTD.Items.BeginUpdate;

    MainFRM.fdMemBalYTD.First;
    while not MainFRM.fdMemBalYTD.EOF do
    begin
      _lvItem         := _fLvBalanceYTD.Items.Add; // inserisco i dati nella listview
      _lvItem.Caption := MainFRM.fdMemBalYTD.FieldByName('rptCat').Value;
      _lvItem.SubItems.Add(MainFRM.fdMemBalYTD.FieldByName('rptSubCat').Value);
      if (UpperCase(MainFRM.fdMemBalYTD.FieldByName('rptInOut').Value) = 'EXPENSE') then
        _lvItem.GroupID := 1 // spesa
      else
        _lvItem.GroupID := 0; // deposito

      // ciclo per compilare le colonne dei mesi
      _totSubcat := 0;
      for _i     := 4 to 15 do // ciclo sui campi dei mesi
      begin
        if (MainFRM.fdMemBalYTD.Fields[_i].Value = null) then
          _lvItem.SubItems.Add('')
        else
        begin
          // tabella
          _lvItem.SubItems.Add(FormatFloat('#,##0.00', MainFRM.fdMemBalYTD.Fields[_i].Value));
          _totSubcat        := _totSubcat + MainFRM.fdMemBalYTD.Fields[_i].Value;
          _totMonth[_i - 4] := _totMonth[_i - 4] + MainFRM.fdMemBalYTD.Fields[_i].Value;
        end;
      end;

      _lvItem.SubItems.Add(FormatFloat('#,##0.00', _totSubcat)); // inserisco il totale della riga
      _totMonth[12] := _totMonth[12] + _totSubcat; // totale su colonna finale

      MainFRM.fdMemBalYTD.Next;
    end; // ciclo while tabella

    //
    // ultima riga del report con i bilanci
    //
    _lvItem         := _fLvBalanceYTD.Items.Add; // inserisco i dati nella listview
    _lvItem.Caption := 'Total Amount';
    _lvItem.GroupID := 2;     // bilancio
    _lvItem.SubItems.Add(''); // campo subcat vuoto

    for _i := 0 to 12 do // ciclo sui 13 valori dell'array per inserirlo nell'ultima riga
    begin
      // tabella
      if _totMonth[_i] <> 0 then
        _lvItem.SubItems.Add(FormatFloat('#,##0.00', _totMonth[_i]))
      else
        _lvItem.SubItems.Add('');
    end;

    _fLvBalanceYTD.Items.EndUpdate;
    _chartInOutMM;

  end; // se azione = tabella
end;
// -------------------------------------------------------------------------------------------------------------//

end.
