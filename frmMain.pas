unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, Vcl.ExtCtrls, VclTee.TeeGDIPlus, Vcl.StdCtrls, Vcl.Buttons,
  VclTee.TeEngine, VclTee.TeeProcs, VclTee.Chart, Data.SqlExpr, Data.DbxSqlite,
  Data.DB, Vcl.Menus, Data.FMTBcd, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Async, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Vcl.VirtualImageList, FireDAC.Stan.Pool, VclTee.Series;

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
    procedure FormCreate(Sender: TObject);
    procedure treeMenuDblClick(Sender: TObject);
  private
    { Private declarations }

    //local function
    function _openDB(_pDBFname: string): boolean;
    function _SeekNode(pvSkString: string): TTreeNode;
    function _chkOpenForm(_frmCaption: string): boolean;
    procedure _closeDB;
    procedure _treeMenuCreate();
    procedure _fillBalanceChart();

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

procedure TMainFRM.FormCreate(Sender: TObject);
begin
  // apro il db
  _openDB(ExtractFilePath(Application.ExeName) + 'dbone.db');
  // riempio il menu
  _treeMenuCreate;
  // riempimento chart saldi
  _fillBalanceChart;
end;
//-------------------------------------------------------------------------------------------------------------//
procedure TMainFRM.treeMenuDblClick(Sender: TObject);
var
  childFRM: TLedgerFrm;
begin
  // apro la child form del ledger. se il nodo superiore � account si tratta sicuramente di un ledger da aprire
  if ((treeMenu.Selected.Level <> 0) and (UpperCase(treeMenu.Selected.Parent.Text) = 'ACCOUNT')) then
    if not _chkOpenForm(treeMenu.Selected.Text) then
      childFRM := TLedgerFrm.Create(nil);
end;
//-------------------------------------------------------------------------------------------------------------//
function TMainFRM._chkOpenForm(_frmCaption: string): boolean;
var
  i: integer;
begin
  // verifico che non ci sia gi� una forma aperta
  Result := false;
  for i := 0 to MDIChildCount - 1 do
  begin
    if (MDIChildren[i].caption = _frmCaption) then
      begin
      MDIChildren[i].Show;
      Result := true;
      end;
  end;
end;
//-------------------------------------------------------------------------------------------------------------//
procedure TMainFRM._closeDB;
begin
  // chisura del db
  sqlite_conn.Close;
end;
//-------------------------------------------------------------------------------------------------------------//
procedure TMainFRM._fillBalanceChart;
var
  _lTotal: Double; // totale x
  i: integer;      // counter x colonne grafioo
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
        while not MainFRM.sqlQry.EOF do // ciclo recupero dati
        begin
          _lTotal := Round(strtofloat(sqlQry.FieldValues['Sum_TRNAMOUNT']));
          chartBalance.SeriesList[0].Add(_lTotal);
          chartBalance.Axes.Bottom.Items.Add(i, sqlQry.FieldValues['ACCNAME']);
          sqlQry.Next;
          i := i + 1;
        end;
    finally
      sqlQry.Close;
      sqlQry.SQL.Clear;
    end;
  end;
end;
//-------------------------------------------------------------------------------------------------------------//
function TMainFRM._openDB(_pDBFname: string): boolean;
begin
  Result := true;
  //apro la connesione al db
  sqlite_conn.Params.Database := _pDBFname;
  try
    sqlite_conn.Connected := true;
  except
    MessageDlg('Impossible to open the database' + _pDBFname, mtError,[mbOK], 0);
    Result := false;
  end;
end;
//-------------------------------------------------------------------------------------------------------------//
function TMainFRM._SeekNode(pvSkString: string): TTreeNode;
var
  i: integer;
begin
  // ricerco nell'albero il valore della stringa su tutti i nodi di primo livello
  Result := nil;
  for i := 0 to treeMenu.Items.Count - 1 do
  begin
    // Controllo il valore
    if treeMenu.Items[i].Text = pvSkString then
    begin
      Result := treeMenu.Items[i];
      Break;
    end;
  end;
end;
//-------------------------------------------------------------------------------------------------------------//
procedure TMainFRM._treeMenuCreate;
// creazione di tutto l'albero del men�
var
  vNode, vNodeGroup: TTreeNode; // nodo riferimento
  vNodeText: String;            // testo da inserire nel nodo
begin
  // inizializzazione var
  vNode := nil;
  vNodeGroup := nil;

  treeMenu.Items.Clear();
  if (sqlite_conn.Connected) then
  begin
    // area accounts
    vNodeGroup := treeMenu.Items.Add(nil, 'Account');
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
            vNode.ImageIndex := 2;
            vNode.SelectedIndex := 9;
            vNode.ExpandedImageIndex := sqlQry.FieldValues['ACCID'];
          end;
          if (sqlQry.FieldValues['ACCTYPE'] = 'Checking') then
          begin
            vNode.ImageIndex := 3;
            vNode.SelectedIndex := 9;
            vNode.ExpandedImageIndex := sqlQry.FieldValues['ACCID'];
          end;
          if (sqlQry.FieldValues['ACCTYPE'] = 'CreditCard') then
          begin
            vNode.ImageIndex := 4;
            vNode.SelectedIndex := 9;
            vNode.ExpandedImageIndex := sqlQry.FieldValues['ACCID'];
          end;
          // imposto nella della propriet� stateindex l'id del record dell account
          // vNode.StateIndex := sqlQry.FieldValues['ACCID'];

          sqlQry.Next;
        end;
    except
      MessageDlg('Error adding account to tree menu', mtError, [mbOK], 0);
    end; // try
  end;   // if

  // area report
  vNodeGroup := treeMenu.Items.Add(nil, 'Report');
  vNodeGroup.ImageIndex := 5;

  // area Config
  vNodeGroup := treeMenu.Items.Add(nil, 'Config');
  vNodeGroup.ImageIndex := 6;

  treeMenu.FullExpand;
end;
//-------------------------------------------------------------------------------------------------------------//
end.
