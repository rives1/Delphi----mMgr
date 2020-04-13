unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, VclTee.TeeGDIPlus, Vcl.StdCtrls,
  Vcl.Buttons, VclTee.TeEngine, VclTee.TeeProcs, VclTee.Chart, Data.SqlExpr, Data.DbxSqlite, Data.DB, Vcl.Menus,
  Data.FMTBcd, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.VirtualImageList, FireDAC.Stan.Pool,
  VclTee.Series, frxClass, frxDBSet, frxExportBaseDialog, frxExportPDF, frxPreview;

type
  TMainFRM = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    chartBalance: TChart;
    treeMenu: TTreeView;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    sqlite_conn: TFDConnection;
    sqlQry: TFDQuery;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    Series1: TBarSeries;
    rptStandard: TfrxReport;
    rptDset: TfrxDBDataset;
    fdMemBalYTD: TFDMemTable;
    sqlQry2: TFDQuery;
    procedure FormCreate(Sender: TObject);
    procedure treeMenuDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    // var
    _SQLString: string;

    // local function
    function _openDB(_pDBFname: string): boolean;
    function _SeekNode(pvSkString: string): TTreeNode;
    function _chkOpenForm(_frmCaption: string): boolean;
    procedure _closeDB;
    procedure _treeMenuCreate;
    procedure _fillBalanceChart;
    procedure _reportBalanceYTD;

  public
    { Public declarations }
  end;

var
  MainFRM: TMainFRM;

implementation

{$R *.dfm}


uses
  frmLedger;

{ TForm1 }

procedure TMainFRM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _closeDB;
end;

procedure TMainFRM.FormCreate(Sender: TObject);
begin
  // apro il db
  _openDB(ExtractFilePath(Application.ExeName) + 'dbone.db');
  // riempio il menu
  _treeMenuCreate;
  // riempimento chart saldi
  _fillBalanceChart;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM.treeMenuDblClick(Sender: TObject);
var
  childFRM: TLedgerFrm;
begin
  // apro la child form del ledger. se il nodo superiore è account si tratta sicuramente di un ledger da aprire
  if ((treeMenu.Selected.Level <> 0)
    and (UpperCase(treeMenu.Selected.Parent.Text) = 'ACCOUNT'))
    and not _chkOpenForm(treeMenu.Selected.Text) then
    childFRM := TLedgerFrm.Create(nil);
  // apro i report
  if ((treeMenu.Selected.Level <> 0)
    and (UpperCase(treeMenu.Selected.Parent.Text) = 'REPORT')) then
    if treeMenu.Selected.Text = 'Balance YTD-Monthly' then
      _reportBalanceYTD;

  // apro i chart
  if ((treeMenu.Selected.Level <> 0)
    and (UpperCase(treeMenu.Selected.Parent.Text) = 'CHART')) then
  begin
    showmessage('Noniiiiiiiiii...');
    showmessage('Ti ho scritto che non sono ancora pronti...');
  end;
  // and (treeMenu.Selected.Text = '') then

  // Config
  if ((treeMenu.Selected.Level <> 0)
    and (UpperCase(treeMenu.Selected.Parent.Text) = 'CHART')) then

end;

// -------------------------------------------------------------------------------------------------------------//
function TMainFRM._chkOpenForm(_frmCaption: string): boolean;
var
  i: integer;
begin
  // verifico che non ci sia già una forma aperta
  Result := false;
  for i  := 0 to MDIChildCount - 1 do
  begin
    if (MDIChildren[i].caption = _frmCaption) then
    begin
      MDIChildren[i].Show;
      MDIChildren[i].SetFocus;
      Result := true;
    end;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM._closeDB;
begin
  // chisura del db
  sqlite_conn.Close;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM._fillBalanceChart;
var
  _lTotal: Double;  // totale x
  i:       integer; // counter x colonne grafioo
begin
  // riempimento chart con i totale x account
  if (sqlite_conn.Connected) then
  begin
    // area accounts
    sqlQry.Close;
    sqlQry.SQL.Clear;
    sqlQry.SQL.Add('SELECT DBACCOUNT.ACCNAME, Sum(TRANSACTIONS.TRNAMOUNT) AS Sum_TRNAMOUNT ' +
      ' FROM DBACCOUNT INNER JOIN TRANSACTIONS ON DBACCOUNT.ACCID = TRANSACTIONS.TRNACCOUNT ' +
      ' GROUP BY DBACCOUNT.ACCNAME ' +
      ' ORDER BY DBACCOUNT.ACCNAME ');
    try
      sqlQry.Open;
      i := 0;
      chartBalance.SeriesList[0].Clear;
      if (MainFRM.sqlQry.RecordCount <> 0) then
        while (not MainFRM.sqlQry.EOF) do // ciclo recupero dati
        begin
          if sqlQry.FieldValues['Sum_TRNAMOUNT'] <> NULL then
          begin
            _lTotal := Round(strtofloat(sqlQry.FieldValues['Sum_TRNAMOUNT']));
            chartBalance.SeriesList[0].Add(_lTotal);
            chartBalance.Axes.Bottom.Items.Add(i, sqlQry.FieldValues['ACCNAME']);
            i := i + 1;
          end;
          sqlQry.Next;
        end;

    finally
      sqlQry.Close;
      sqlQry.SQL.Clear;
    end;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
function TMainFRM._openDB(_pDBFname: string): boolean;
begin
  Result := true;
  // apro la connesione al db
  sqlite_conn.Params.Database := _pDBFname;
  try
    sqlite_conn.Connected := true;
  except
    MessageDlg('Impossible to open the database' + _pDBFname, mtError, [mbOK], 0);
    Result := false;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM._reportBalanceYTD;
var
  _totCat:      Double;  // totale da calcolare per i 12 mesi della cat-subcat
  _mmField:     string;  // campo per l'assegnazione del valore
  _subcatCiclo: string;  // condizione per ciclo
  i:            integer; // x ciclo for
begin
  // pulire la tabella prima di procedere
  for i := 0 to fdMemBalYTD.RecordCount do
  begin
    fdMemBalYTD.Edit;
    fdMemBalYTD.Delete;
  end;

  _SQLString := 'Select CATTYPE, CATDES, SUBCDES, '
    + ' StrfTime(''%Y'', TRANSACTIONS.TRNDATE) As YY, '
    + ' StrfTime(''%m'', TRANSACTIONS.TRNDATE) As MM, '
    + ' Sum(TRANSACTIONS.TRNAMOUNT) As Sum_TRNAMOUNT '
    + ' From '
    + ' TRANSACTIONS Left Join '
    + ' DBCATEGORY On DBCATEGORY.CATID = TRANSACTIONS.TRNCATEGORY Left Join '
    + ' DBSUBCATEGORY On DBSUBCATEGORY.SUBCID = TRANSACTIONS.TRNSUBCATEGORY '
    + ' Where CATDES <> ''_Transfer'' '
    + ' and StrfTime(''%Y'', TRNDATE) = '''
    + InputBox('ReferenceYear', 'Insert Year for Report', FormatDateTime('yyyy', now)) + ''' '
    + ' Group By '
    + ' DBCATEGORY.CATTYPE, '
    + ' DBCATEGORY.CATDES, '
    + ' DBSUBCATEGORY.SUBCDES, '
    + ' StrfTime(''%Y'', TRANSACTIONS.TRNDATE), '
    + ' StrfTime(''%m'', TRANSACTIONS.TRNDATE) '
    + ' Order By '
    + ' DBCATEGORY.CATTYPE, '
    + ' DBCATEGORY.CATDES ';

  sqlQry.Close;
  sqlQry.SQL.Clear;
  sqlQry.SQL.Add(_SQLString);
  try
    sqlQry.Open;
    while not MainFRM.sqlQry.EOF do // ciclo recupero dati
    begin
      // travaso i dati dalla qry al recordset costruito per il report
      with fdMemBalYTD do
      begin
        // condizione verifica su quando inserire un record
        if (sqlQry.FieldValues['CATDES'] + sqlQry.FieldValues['SUBCDES'] <> _subcatCiclo) then
        begin
          Insert;
          _totCat := 0;
        end;

        FieldByName('rptInOut').Value  := sqlQry.FieldValues['CATTYPE'];
        FieldByName('rptYY').Value     := sqlQry.FieldValues['YY'];
        FieldByName('rptCat').Value    := sqlQry.FieldValues['CATDES'];
        FieldByName('rptSubCat').Value := sqlQry.FieldValues['SUBCDES'];

        case StrToInt(sqlQry.FieldValues['MM']) of // in base al mese imposto i dati nel campo colonna-mese
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
        FieldByName(_mmField).Value     := sqlQry.FieldValues['Sum_TRNAMOUNT'];
        _totCat                         := _totCat + sqlQry.FieldValues['Sum_TRNAMOUNT'];
        FieldByName('rptTotLine').Value := _totCat;

        Update;
      end;
      _subcatCiclo := sqlQry.FieldValues['CATDES'] + sqlQry.FieldValues['SUBCDES'];
      sqlQry.Next;
    end; // ciclo lettura record

  finally
    sqlQry.Close;
    sqlQry.SQL.Clear;
  end;

  // apertura report
  rptStandard.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Balance-YTD.fr3');
  rptStandard.ShowReport();
end;

// -------------------------------------------------------------------------------------------------------------//
function TMainFRM._SeekNode(pvSkString: string): TTreeNode;
var
  i: integer;
begin
  // ricerco nell'albero il valore della stringa su tutti i nodi di primo livello
  Result := nil;
  for i  := 0 to treeMenu.Items.Count - 1 do
  begin
    // Controllo il valore
    if treeMenu.Items[i].Text = pvSkString then
    begin
      Result := treeMenu.Items[i];
      Break;
    end;
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM._treeMenuCreate;
// creazione di tutto l'albero del menù
var
  vNode, vNodeGroup: TTreeNode; // nodo riferimento
  vNodeText:         String;    // testo da inserire nel nodo
begin
  // inizializzazione var
  vNode      := nil;
  vNodeGroup := nil;

  treeMenu.Items.Clear();
  if (sqlite_conn.Connected) then
  begin
    // area accounts
    vNodeGroup            := treeMenu.Items.Add(nil, 'Account');
    vNodeGroup.ImageIndex := 1;
    sqlQry.Close;
    sqlQry.SQL.Clear;
    sqlQry.SQL.Add('SELECT * FROM DBACCOUNT ORDER BY ACCNAME');
    try
      sqlQry.Active := true;
      if (sqlQry.RecordCount <> 0) then
        while not sqlQry.EOF do // ciclo recupero dati
        begin
          vNodeText := sqlQry.FieldValues['ACCNAME'];
          // aggiungo il nodo
          vNode := treeMenu.Items.AddChild(vNodeGroup, vNodeText);
          // selezione quale immagine impostare sul nodo
          if (sqlQry.FieldValues['ACCTYPE'] = 'Cash') then
          begin
            vNode.ImageIndex         := 6;
            vNode.SelectedIndex      := 0;
            vNode.ExpandedImageIndex := sqlQry.FieldValues['ACCID'];
          end;
          if (sqlQry.FieldValues['ACCTYPE'] = 'Checking') then
          begin
            vNode.ImageIndex         := 5;
            vNode.SelectedIndex      := 0;
            vNode.ExpandedImageIndex := sqlQry.FieldValues['ACCID'];
          end;
          if (sqlQry.FieldValues['ACCTYPE'] = 'CreditCard') then
          begin
            vNode.ImageIndex         := 7;
            vNode.SelectedIndex      := 0;
            vNode.ExpandedImageIndex := sqlQry.FieldValues['ACCID'];
          end;
          if (sqlQry.FieldValues['ACCTYPE'] = 'Online') then
          begin
            vNode.ImageIndex         := 8;
            vNode.SelectedIndex      := 0;
            vNode.ExpandedImageIndex := sqlQry.FieldValues['ACCID'];
          end;

          sqlQry.Next;
        end;
    except
      MessageDlg('Error adding account to tree menu', mtError, [mbOK], 0);
    end; // try
  end;   // if

  // area report
  vNodeGroup            := treeMenu.Items.Add(nil, 'Report');
  vNodeGroup.ImageIndex := 2;
  vNode                 := treeMenu.Items.AddChild(vNodeGroup, 'Balance YTD-Monthly');
  vNode.ImageIndex      := 9;

  // area chart
  vNodeGroup            := treeMenu.Items.Add(nil, 'Chart');
  vNodeGroup.ImageIndex := 3;
  vNode                 := treeMenu.Items.AddChild(vNodeGroup, 'Analisys');
  vNode.ImageIndex      := 13;

  // area Config
  vNodeGroup            := treeMenu.Items.Add(nil, 'Config');
  vNodeGroup.ImageIndex := 4;
  vNode                 := treeMenu.Items.AddChild(vNodeGroup, 'Accounts');
  vNode.ImageIndex      := 14;

  treeMenu.FullExpand;
end;

// -------------------------------------------------------------------------------------------------------------//
end.
