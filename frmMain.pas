unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  VclTee.TeeGDIPlus, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.Client, frxClass, frxDBSet, Vcl.BaseImageCollection, Vcl.ImageCollection, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Data.DB, FireDAC.Comp.DataSet, Vcl.Menus, Vcl.ComCtrls, VclTee.TeEngine, VclTee.Series,
  VclTee.TeeProcs, VclTee.Chart, Vcl.ExtCtrls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Data.SqlExpr,
  Data.DbxSqlite, Data.FMTBcd, frxExportBaseDialog, frxExportPDF, frxPreview, JvToolEdit, JvExMask, JvMaskEdit,
  JvCheckedMaskEdit, JvDatePickerEdit, JvExComCtrls, JvDateTimePicker, RzDTP, Vcl.Mask, RzEdit, Vcl.WinXPickers;

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
    rptStandard: TfrxReport;
    rptDset: TfrxDBDataset;
    fdMemBalYTD: TFDMemTable;
    sqlQry2: TFDQuery;
    New1: TMenuItem;
    N1: TMenuItem;
    Quit1: TMenuItem;
    dlgSave: TSaveDialog;
    dlgOpen: TOpenDialog;
    Open1: TMenuItem;
    Help1: TMenuItem;
    Documentation1: TMenuItem;
    N2: TMenuItem;
    Version1: TMenuItem;
    Splitter1: TSplitter;
    imgReconcile: TImage;
    imgHighligth: TImage;
    Series1: THorizBarSeries;
    procedure FormCreate(Sender: TObject);
    procedure treeMenuDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Quit1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Version1Click(Sender: TObject);
    procedure Documentation1Click(Sender: TObject);

  private
    { Private declarations }
    // var
    _SQLString: string;
    _DbName:    string;
    _iniFName:  string;
    //
    // local function
    //
    function _openDB(_pDBFname: string): boolean;
    function _chkOpenForm(_frmCaption: string): boolean;
    function _backupDB(_fName: string): boolean;
    // function _SeekNode(pvSkString: string): TTreeNode;

    //
    // local procedures
    //
    procedure _closeDB;
    procedure _treeSelectOpen;
    procedure _createNewDB;
    // procedure _reportBalanceYTD;

  public
    { Public declarations }
    _sysDecSeparator: string;
    procedure _treeMenuCreate;
    procedure _fillBalanceChart;

  end;

var
  MainFRM: TMainFRM;

implementation

{$R *.dfm}


uses
  frmLedger, frmAccount, frmChartAnalisys1, frmChartAnalisys2, frmChartAnalisys3, frmChartAnalisys4, frmPayee,
  frmCategory, frmTblBalYTD, frmTblPayeeYTD, frmTblSubcatYTD, pasCommon, CommCtrl, ShellApi, System.IOUtils,
  System.UITypes;

{ TForm1 }

// -------------------------------------------------------------------------------------------------------------//

procedure TMainFRM.Documentation1Click(Sender: TObject);
begin
  // rimando alla pagina del sito con la documentazione
  ShellExecute(self.WindowHandle, 'open', 'www.mmgr.altervista.org/documentation.html', nil, nil, SW_SHOWNORMAL);
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _closeDB;
  // salvataggio delle impostazioni -- salvo il nome dell'ultimo db utilizzato
  _iniRW(_iniFName, 'W', 'LASTDB', 'DBNAME', _DbName);
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM.FormCreate(Sender: TObject);
begin
  // impostro il separatore decimale
  //_sysDecSeparator := ;
  // leggeimpostazioni da file INI
  _iniFName := ExtractFilePath(Application.ExeName) + 'mMgr.ini';
  _DbName   := _iniRW(_iniFName, 'R', 'LASTDB', 'DBNAME', 'x');
  // apro il db -- se non apro il db non ha senso aprire il menu
  if (Uppercase(_DbName) <> 'NEGATIVE') then
  begin
    if (_openDB(_DbName)) then
    begin
      _treeMenuCreate;   // riempio il menu
      _fillBalanceChart; // riempimento chart saldi
    end;
  end
  else
  begin
    MessageDlg('Please Create or open a database to continue', mtInformation, [mbOK], 0)
  end;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM.New1Click(Sender: TObject);
begin
  /// Creazione del nuovo db
  /// apro il db in base al nome selezionato nella dialog
  _createNewDB;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM.Open1Click(Sender: TObject);
begin
  // aprol adialog per la selezione del DB da aprire
  dlgOpen.InitialDir := ExtractFilePath(Application.ExeName);
  if ((dlgOpen.Execute) and (dlgOpen.FileName <> '')) then
    _openDB(dlgOpen.FileName);
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM.Quit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM.treeMenuDblClick(Sender: TObject);
begin
  if Uppercase(_DbName) = 'NEGATIVE' then
    MessageDlg('No database open', mtInformation, [mbOK], 0)
  else
  begin
    _treeSelectOpen;   // apro le form in base alla selezione del nodo
    _treeMenuCreate;   // ripopolo il menu
    _fillBalanceChart; // aggiorno il chart
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM.Version1Click(Sender: TObject);
begin
  MessageDlg('mMgr 0.68', mtInformation, [mbOK], 0);
end;

// -------------------------------------------------------------------------------------------------------------//
function TMainFRM._backupDB(_fName: string): boolean;
var
  _bakName:      string;
  _datePartName: string;
begin
  Result := True;
  // copio il file che viene selezionato come da aprire
  if FileExists(_fName) then
  begin
    // imposto il nuovo nome del file
    DateTimeToString(_datePartName, 'yyyymmddhhnnss', now());
    _bakName := ExtractFilePath(_fName) + TPath.GetFileNameWithoutExtension(_fName) + '-' + _datePartName +
      ExtractFileExt(_fName);
    try
      CopyFile(PChar(_fName), PChar(_bakName), True)
    Except
      On E: Exception Do
      begin
        ShowMessage(E.ClassName + 'Error in creating backup file: ' + E.Message);
        Result := False;
      end;
    end;

  end;

end;

// -------------------------------------------------------------------------------------------------------------//
function TMainFRM._chkOpenForm(_frmCaption: string): boolean;
var
  i: integer;
begin
  // verifico che non ci sia gi� una forma aperta
  Result := False;
  for i  := 0 to MDIChildCount - 1 do
  begin
    if (MDIChildren[i].caption = _frmCaption) then
    begin
      MDIChildren[i].Show;
      MDIChildren[i].SetFocus;
      MDIChildren[i].WindowState := wsMaximized;
      Result                     := True;
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
procedure TMainFRM._createNewDB;
begin
  // esecuzione delle query per la cerazione del nuovo db
  dlgSave.InitialDir := ExtractFilePath(Application.ExeName);
  if ((dlgSave.Execute) and (dlgSave.FileName <> '')) then
  begin
    MainFRM.dlgSave.DefaultExt := '.sqlite';
    MainFRM.dlgSave.Filter     := 'sqlite|*.sqlite';

    _DbName := dlgSave.FileName;
    try
      sqlite_conn.Params.Database := _DbName;
      sqlite_conn.Connected       := True;
      sqlite_conn.StartTransaction;

      //transactions
      _SQLString := ' CREATE TABLE IF NOT EXISTS ''TRANSACTIONS'' ( '
        + ' ''TRNID''	INTEGER PRIMARY KEY AUTOINCREMENT, '
        + ' ''TRNTYPE''	STRING(10) NOT NULL, '
        + ' ''TRNDATE''	DATE(10) NOT NULL, '
        + ' ''TRNPAYEE''	INTEGER NOT NULL, '
        + ' ''TRNSUBCATEGORY''	INTEGER, '
        + ' ''TRNAMOUNT''	DOUBLE NOT NULL, '
        + ' ''TRNACCOUNT''	INTEGER NOT NULL, '
        + ' ''TRNDESCRIPTION''	STRING(100), '
        + ' ''TRNTRANSFERID''	INTEGER, '
        + ' ''TRNRECONCILE''	STRING(1), '
        + ' FOREIGN KEY(''TRNPAYEE'') REFERENCES ''DBPAYEE''(''PAYID''), '
        + ' FOREIGN KEY(''TRNSUBCATEGORY'') REFERENCES ''DBSUBCATEGORY''(''SUBCID''), '
        + ' FOREIGN KEY(''TRNACCOUNT'') REFERENCES ''DBACCOUNT''(''ACCID''));';
      sqlQry.ExecSQL(_SQLString);

      //payee
      _SQLString := ' CREATE TABLE IF NOT EXISTS ''DBPAYEE'' ( '
        + '''PAYID''	INTEGER PRIMARY KEY AUTOINCREMENT, '
        + '''PAYNAME''	STRING(50) NOT NULL UNIQUE);';
      sqlQry.ExecSQL(_SQLString);

      //category
      _SQLString := ' CREATE TABLE IF NOT EXISTS ''DBCATEGORY'' ( '
        + '''CATID''	INTEGER PRIMARY KEY AUTOINCREMENT, '
        + '''CATDES''	STRING(50) NOT NULL UNIQUE, '
        + '''CATTYPE''	STRING NOT NULL ); ';
      sqlQry.ExecSQL(_SQLString);

      //subcategory
      _SQLString := 'CREATE TABLE IF NOT EXISTS ''DBSUBCATEGORY'' ( '
        + '''SUBCID''	INTEGER PRIMARY KEY AUTOINCREMENT, '
        + '''SUBCATID''	INTEGER NOT NULL, '
        + '''SUBCDES''	STRING(50) NOT NULL UNIQUE, '
        + 'FOREIGN KEY(''SUBCATID'') REFERENCES ''DBCATEGORY''(''CATID'') ON DELETE CASCADE);';
      sqlQry.ExecSQL(_SQLString);


      //account
      _SQLString := ' CREATE TABLE IF NOT EXISTS ''DBACCOUNT'' ( '
        + '''ACCID''	INTEGER PRIMARY KEY AUTOINCREMENT, '
        + '''ACCNAME''	STRING(50) NOT NULL UNIQUE, '
        + '''ACCTYPE''	STRING(15 , 0) NOT NULL, '
        + '''ACCSTATUS''	STRING(10) NOT NULL ); ';

      sqlQry.ExecSQL(_SQLString);

      //indexes
      _SQLString := ' CREATE UNIQUE INDEX IF NOT EXISTS ''DBSUBCATEGORY_Index01'' ON ''DBSUBCATEGORY'' (''SUBCDES''); ';
      sqlQry.ExecSQL(_SQLString);

      _SQLString := ' CREATE UNIQUE INDEX IF NOT EXISTS ''DBPAYEE_Index01'' ON ''DBPAYEE'' (''PAYNAME''); ';
      sqlQry.ExecSQL(_SQLString);

      _SQLString := ' CREATE UNIQUE INDEX IF NOT EXISTS ''DBCATEGORY_Index01'' ON ''DBCATEGORY'' (''CATDES'');';
      sqlQry.ExecSQL(_SQLString);

      _SQLString := ' CREATE UNIQUE INDEX IF NOT EXISTS ''DBACCOUNT_Index01'' ON ''DBACCOUNT'' (''ACCNAME'');';
      sqlQry.ExecSQL(_SQLString);

      _SQLString := ' CREATE VIEW LedgerView AS Select '
        + ' TRANSACTIONS.TRNID, '
        + ' TRANSACTIONS.TRNTYPE, '
        + ' TRANSACTIONS.TRNDATE, '
        + ' TRANSACTIONS.TRNAMOUNT, '
        + ' TRANSACTIONS.TRNDESCRIPTION, '
        + ' TRANSACTIONS.TRNTRANSFERID, '
        + ' TRANSACTIONS.TRNRECONCILE, '
        + ' DBACCOUNT.ACCNAME, '
        + ' DBACCOUNT.ACCSTATUS, '
        + ' DBPAYEE.PAYNAME, '
        + ' DBCATEGORY.CATDES, '
        + ' DBSUBCATEGORY.SUBCDES, '
        + ' DBCATEGORY.CATTYPE '
        + ' From '
        + ' TRANSACTIONS Left Join '
        + ' DBACCOUNT On ACCID = TRNACCOUNT Left Join '
        + ' DBPAYEE On PAYID = TRNPAYEE Left Join '
        + ' DBSUBCATEGORY On SUBCID = TRNSUBCATEGORY Left Join '
        + ' DBCATEGORY On CATID = SUBCATID;';

      // + ' DBACCOUNT On DBACCOUNT.ACCID = TRANSACTIONS.TRNACCOUNT Left Join '
      // + ' DBCATEGORY On DBCATEGORY.CATID = TRANSACTIONS.TRNCATEGORY Left Join '
      // + ' DBPAYEE On DBPAYEE.PAYID = TRANSACTIONS.TRNPAYEE Left Join '
      // + ' DBSUBCATEGORY On DBSUBCATEGORY.SUBCID = TRANSACTIONS.TRNSUBCATEGORY '
      // + ' And DBCATEGORY.CATID = DBSUBCATEGORY.SUBCATID;';
      sqlQry.ExecSQL(_SQLString);

      sqlite_conn.Commit;


      //inserimento valori default
      //categoria _transfer
      _SQLString := ' INSERT INTO DBCATEGORY (CATTYPE, CATDES) VALUES (''Transfer'', ''_Transfer'')';
      sqlQry.ExecSQL(_SQLString);

      //sottocategoria _transfer
      _SQLString := ' INSERT INTO DBSUBCATEGORY (SUBCDES, SUBCATID) '
        + ' VALUES ( ''_Transfer'', ''' + _getDBField('DBCATEGORY', 'CATID', 'CATDES', '_Transfer') + ''') ';
      sqlQry.ExecSQL(_SQLString);

      //payee
      _SQLString := ' INSERT INTO DBPAYEE (PAYNAME) '
      + ' VALUES ( ''_Transfer'') ';

      sqlQry.ExecSQL(_SQLString);



      //msg conferma creazione
      MessageDlg('DB Created!!', mtInformation, [mbOK], 0);

      MainFRM.caption := 'mMgr -> ' + ExtractFileName(_DbName);
    except
      MessageDlg('Impossible to create the database' + _DbName, mtError, [mbOK], 0);
    end;
  end
  else
    MessageDlg('Operation aborted', mtInformation, [mbOK], 0);

  _treeMenuCreate;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM._fillBalanceChart;
var
  _lTotal: Double;  // totale x serie nel grafico
  i:       integer; // counter x colonne grafioo
begin
  // riempimento chart con i totale x account
  if (sqlite_conn.Connected) then
  begin
    // area accounts
    sqlQry.Close;
    sqlQry.SQL.Clear;
    _SQLString := 'SELECT ACCNAME, Sum(TRNAMOUNT) AS Sum_TRNAMOUNT ' +
      ' FROM DBACCOUNT INNER JOIN TRANSACTIONS ON ACCID = TRNACCOUNT ' +
      ' WHERE UCASE(ACCSTATUS) = ''OPEN'' ' +
      ' GROUP BY ACCNAME ' +
      ' ORDER BY ACCNAME ';
    sqlQry.SQL.Add(_SQLString);
    try
      sqlQry.Open;
      i := 0;
      chartBalance.SeriesList[0].Clear;
      chartBalance.Axes.Left.Items.Clear;

      if (MainFRM.sqlQry.RecordCount <> 0) then
        while (not MainFRM.sqlQry.EOF) do // ciclo recupero dati
        begin
          if sqlQry.FieldValues['Sum_TRNAMOUNT'] <> NULL then
          begin
            _lTotal := Round(strtofloat(sqlQry.FieldValues['Sum_TRNAMOUNT']));
            chartBalance.SeriesList[0].Add(_lTotal);
            chartBalance.Axes.Left.Items.Add(i, sqlQry.FieldValues['ACCNAME']);
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
  Result := True;
  // apro la connesione al db oppure ne creo uno nuovo se il nome passato non � un file esistente
  if FileExists(_pDBFname) then // verifica esistenza file
  begin
    if _backupDB(_pDBFname) then // creazione backup file db
    begin
      // creo una copia del db prima di aprirlo come backup pre-sessione
      sqlite_conn.Params.Database := _pDBFname;
      try
        sqlite_conn.Connected := True;
        MainFRM.caption       := 'mMgr -> ' + _pDBFname;
        _DbName               := _pDBFname;
        _treeMenuCreate;
      except
        MessageDlg('Impossible to open the database -> ' + _pDBFname, mtError, [mbOK], 0);
        Result := False;
      end;
    end
    else
      if (MessageDlg('Database -> ' + _pDBFname + ' not found. Create a new one?', mtConfirmation, [mbYes, mbNo], 0)
      = mrYes) then
      _createNewDB;
  end
  else
    Result := False;
end;

// -------------------------------------------------------------------------------------------------------------//
{ procedure TMainFRM._reportBalanceYTD;
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
  + ' StrfTime(''%Y'', TRNDATE) As YY, '
  + ' StrfTime(''%m'', TRNDATE) As MM, '
  + ' Sum(TRNAMOUNT) As Sum_TRNAMOUNT '
  + ' From '
  + ' TRANSACTIONS Inner Join '
  + ' DBSUBCATEGORY On SUBCID = TRNSUBCATEGORY Inner Join '
  + ' DBCATEGORY On CATID = SUBCATID '
  // per la rimozione della categoria dalle transazioni
  // + ' TRANSACTIONS Left Join '
  // + ' DBCATEGORY On DBCATEGORY.CATID = TRNCATEGORY Left Join '
  // + ' DBSUBCATEGORY On DBSUBCATEGORY.SUBCID = TRNSUBCATEGORY '
  + ' Where CATDES <> ''_Transfer'' '
  + ' and StrfTime(''%Y'', TRNDATE) = '''
  + InputBox('ReferenceYear', 'Insert Year for Report', FormatDateTime('yyyy', now)) + ''' '
  + ' Group By '
  + ' CATTYPE, '
  + ' CATDES, '
  + ' SUBCDES, '
  + ' StrfTime(''%Y'', TRNDATE), '
  + ' StrfTime(''%m'', TRNDATE) '
  + ' Order By '
  + ' CATTYPE, '
  + ' CATDES ';

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
  rptStandard.LoadFromFile(ExtractFilePath(Application.ExeName) + '\report\Balance-YTD.fr3');
  rptStandard.ShowReport();
  end;
}
// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM._treeMenuCreate;
// creazione di tutto l'albero del men�
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
    _SetNodeState(vNodeGroup, TVIS_BOLD);
    sqlQry.Close;
    sqlQry.SQL.Clear;
    _SQLString := 'SELECT * FROM DBACCOUNT WHERE UCASE(ACCSTATUS) = ''OPEN'' ORDER BY ACCNAME';
    sqlQry.SQL.Add(_SQLString);
    try
      sqlQry.Active := True;
      if (sqlQry.RecordCount <> 0) then
        while not sqlQry.EOF do // ciclo recupero dati
        begin
          vNodeText := sqlQry.FieldValues['ACCNAME'];
          vNode     := treeMenu.Items.AddChild(vNodeGroup, vNodeText); // aggiungo il nodo
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

  // area chart
  vNodeGroup            := treeMenu.Items.Add(nil, 'Chart');
  vNodeGroup.ImageIndex := 3;
  _SetNodeState(vNodeGroup, TVIS_BOLD);

  vNode            := treeMenu.Items.AddChild(vNodeGroup, 'Analisys Amt');
  vNode.ImageIndex := 10;
  vNode            := treeMenu.Items.AddChild(vNodeGroup, 'Analisys Avg');
  vNode.ImageIndex := 12;
  vNode            := treeMenu.Items.AddChild(vNodeGroup, 'Subcategory Analisys');
  vNode.ImageIndex := 13;
  vNode            := treeMenu.Items.AddChild(vNodeGroup, 'Payee Analisys');
  vNode.ImageIndex := 18;

  // area report
  vNodeGroup            := treeMenu.Items.Add(nil, 'Report');
  vNodeGroup.ImageIndex := 2;
  _SetNodeState(vNodeGroup, TVIS_BOLD);
  vNode            := treeMenu.Items.AddChild(vNodeGroup, 'YTD-Monthly');
  vNode.ImageIndex := 9;
  vNode            := treeMenu.Items.AddChild(vNodeGroup, 'Payee-YTD');
  vNode.ImageIndex := 19;
  vNode            := treeMenu.Items.AddChild(vNodeGroup, 'Subcategory-YTD');
  vNode.ImageIndex := 18;

  // area Config
  vNodeGroup            := treeMenu.Items.Add(nil, 'Config');
  vNodeGroup.ImageIndex := 4;
  _SetNodeState(vNodeGroup, TVIS_BOLD);
  vNode            := treeMenu.Items.AddChild(vNodeGroup, 'Account');
  vNode.ImageIndex := 14;
  vNode            := treeMenu.Items.AddChild(vNodeGroup, 'Payee');
  vNode.ImageIndex := 15;
  vNode            := treeMenu.Items.AddChild(vNodeGroup, 'Category');
  vNode.ImageIndex := 17;

  treeMenu.FullExpand;
  treeMenu.Items[0].Selected := True;
end;

// -------------------------------------------------------------------------------------------------------------//
procedure TMainFRM._treeSelectOpen;
var
  _LedgerChildFRM:  TLedgerFrm;
  _AccountChildFRM: TAccountFrm;
  _Analisys1FRM:    TAnalisysFrm1;
  _Analisys2FRM:    TAnalisysFrm2;
  _Analisys3FRM:    TAnalisysFrm3;
  _Analisys4FRM:    TAnalisysFrm4;
  _PayeeFRM:        TPayeeFRM;
  _CategoryFRM:     TCategoryFrm;
  _TblBalanceYTD:   TtblBalanceFrm;
  _TblPayeeYTD:     TtblPayeeFrm;
  _TblSubcatYTD:    TtblSubcatFrm;

begin
  // apro la child form del ledger. se il nodo superiore � account si tratta sicuramente di un ledger da aprire
  if ((treeMenu.Selected.Level <> 0) and (Uppercase(treeMenu.Selected.Parent.Text) = 'ACCOUNT'))
    and not _chkOpenForm(treeMenu.Selected.Text) then
  begin
    _LedgerChildFRM             := TLedgerFrm.Create(nil);
    _LedgerChildFRM.WindowState := wsMaximized;
  end;

  // apro la form per tabella report balance ytd
  if ((treeMenu.Selected.Level <> 0) and (Uppercase(treeMenu.Selected.Parent.Text) = 'REPORT'))
    and not _chkOpenForm(treeMenu.Selected.Text) and (treeMenu.Selected.Text = 'YTD-Monthly') then
  begin
    _TblBalanceYTD             := TtblBalanceFrm.Create(nil);
    _TblBalanceYTD.WindowState := wsMaximized;
  end;

  // apro la form per tabella report payee ytd
  if ((treeMenu.Selected.Level <> 0) and (Uppercase(treeMenu.Selected.Parent.Text) = 'REPORT'))
    and not _chkOpenForm(treeMenu.Selected.Text) and (treeMenu.Selected.Text = 'Payee-YTD') then
  begin
    _TblPayeeYTD := TtblPayeeFrm.Create(nil);
    // _TblPayeeYTD.WindowState := wsMaximized;
  end;

  // apro la form per tabella report subcategory ytd
  if ((treeMenu.Selected.Level <> 0) and (Uppercase(treeMenu.Selected.Parent.Text) = 'REPORT'))
    and not _chkOpenForm(treeMenu.Selected.Text) and (treeMenu.Selected.Text = 'Subcategory-YTD') then
  begin
    _TblSubcatYTD := TtblSubcatFrm.Create(nil);
    // _TblSubcatYTD.WindowState := wsMaximized;
  end;

  // apro chart1
  if ((treeMenu.Selected.Level <> 0) and (Uppercase(treeMenu.Selected.Parent.Text) = 'CHART'))
    and not _chkOpenForm(treeMenu.Selected.Text) and (treeMenu.Selected.Text = 'Analisys Amt') then
  begin
    _Analisys1FRM             := TAnalisysFrm1.Create(nil);
    _Analisys1FRM.WindowState := wsMaximized;
  end;
  // apro chart2
  if ((treeMenu.Selected.Level <> 0) and (Uppercase(treeMenu.Selected.Parent.Text) = 'CHART'))
    and not _chkOpenForm(treeMenu.Selected.Text) and (treeMenu.Selected.Text = 'Analisys Avg') then
  begin
    _Analisys2FRM             := TAnalisysFrm2.Create(nil);
    _Analisys2FRM.WindowState := wsMaximized;
  end;

  // apro chart3
  if ((treeMenu.Selected.Level <> 0) and (Uppercase(treeMenu.Selected.Parent.Text) = 'CHART'))
    and not _chkOpenForm(treeMenu.Selected.Text) and (treeMenu.Selected.Text = 'Subcategory Analisys') then
  begin
    _Analisys3FRM             := TAnalisysFrm3.Create(nil);
    _Analisys3FRM.WindowState := wsMaximized;
  end;

  // apro chart4
  if ((treeMenu.Selected.Level <> 0) and (Uppercase(treeMenu.Selected.Parent.Text) = 'CHART'))
    and not _chkOpenForm(treeMenu.Selected.Text) and (treeMenu.Selected.Text = 'Payee Analisys') then
  begin
    _Analisys4FRM             := TAnalisysFrm4.Create(nil);
    _Analisys4FRM.WindowState := wsMaximized;
  end;

  // Config
  if ((treeMenu.Selected.Level <> 0) and (Uppercase(treeMenu.Selected.Parent.Text) = 'CONFIG')) then
  begin
    if (treeMenu.Selected.Text = 'Account') and not _chkOpenForm(treeMenu.Selected.Text) then
    begin
      _AccountChildFRM := TAccountFrm.Create(nil);
      _AccountChildFRM.Hide;
      _AccountChildFRM.ShowModal;
      _treeMenuCreate;
      // _AccountChildFRM.WindowState := wsMaximized;
    end;
    if (treeMenu.Selected.Text = 'Payee') and not _chkOpenForm(treeMenu.Selected.Text) then
    begin
      _PayeeFRM := TPayeeFRM.Create(nil);
      _PayeeFRM.Hide;
      _PayeeFRM.ShowModal;
      // _PayeeFRM.WindowState := wsMaximized;
    end;
    if (treeMenu.Selected.Text = 'Category') and not _chkOpenForm(treeMenu.Selected.Text) then
    begin
      _CategoryFRM := TCategoryFrm.Create(nil);
      _CategoryFRM.Hide;
      _CategoryFRM.ShowModal;
      // _CategoryFRM.WindowState := wsMaximized;
    end;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
end.
