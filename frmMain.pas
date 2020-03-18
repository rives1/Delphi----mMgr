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
  Vcl.ImageCollection, Vcl.VirtualImageList, FireDAC.Stan.Pool, VCLTee.Series;

type
  TMainFRM = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    chartBalance: TChart;
    BitBtn1: TBitBtn;
    treeMenu: TTreeView;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    sqlite_conn: TFDConnection;
    sqlQry: TFDQuery;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    Series1: TBarSeries;
    function _openDB(_pDBFname: string): boolean;
    procedure _closeDB;
    function _SeekNode(pvSkString: string): TTreeNode;
    procedure _treeMenuCreate();
    procedure _fillBalanceChart();
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFRM: TMainFRM;

implementation

{$R *.dfm}
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

procedure TMainFRM._closeDB;
begin
  // chisura del db
  sqlite_conn.Close;
end;

procedure TMainFRM._fillBalanceChart;
var
  _lTotal: Double; //totale x
  I: integer;      //counter x colonne grafioo
begin
  //riempimento chart con i totale x account
   if (sqlite_conn.Connected) then
  begin
    //area accounts
    sqlQry.Close;
    sqlQry.SQL.Clear;
    sqlQry.SQL.Add('SELECT DBACCOUNT.ACCNAME, Sum(TRANSACTIONS.TRNAMOUNT) AS Sum_TRNAMOUNT ' +
        ' FROM DBACCOUNT INNER JOIN TRANSACTIONS ON DBACCOUNT.ACCID = TRANSACTIONS.TRNACCOUNT ' +
        ' GROUP BY DBACCOUNT.ACCNAME ' +
        ' ORDER BY DBACCOUNT.ACCNAME ');
    try
      sqlQry.Open;
      I:= 0;
      if (MainFRM.sqlQry.RecordCount <> 0) then
      while not MainFRM.sqlQry.EOF do //ciclo recupero dati
        begin
          _lTotal:=sqlQry.FieldValues['Sum_TRNAMOUNT']/1000;
          chartBalance.SeriesList[0].Add(_lTotal, sqlQry.FieldValues['ACCNAME']);
          sqlQry.Next;
          I:=I+1;
        end;
    except

    end;

  end;
end;

function TMainFRM._openDB(_pDBFname: string): boolean;
begin
  // MessageDlg('aa',ExtractFilePath(Application.ExeName),mtconfirmation,[mbOK],0 );
  sqlite_conn.Params.Database := _pDBFname;
  try
    sqlite_conn.Connected := True;

  except
    MessageDlg('Impossible to open the database' + _pDBFname, mtError,
      [mbOK], 0);
    result := false;
  end;
  // sqlite_transaction.Active:=True;
  result := True
end;

function TMainFRM._SeekNode(pvSkString: string): TTreeNode;
var
  I: Integer;
begin
  // ricerco nell'albero il valore della stringa su tutti i nodi di primo livello
  result := nil;
  for I := 0 to treeMenu.Items.Count - 1 do
  begin
    // Controllo il valore
    if treeMenu.Items[I].Text = pvSkString then
    begin
      result := treeMenu.Items[I];
      Break;
    end;
  end;
end;

procedure TMainFRM._treeMenuCreate;
// creazione di tutto l'albero del men�
var
  vNode, vNodeGroup: TTreeNode; // nodo riferimento
  vNodeText: String; // testo da inserire nel nodo
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
      sqlQry.Active := True;
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
          end;
          if (sqlQry.FieldValues['ACCTYPE'] = 'Checking') then
          begin
            vNode.ImageIndex := 3;
            vNode.SelectedIndex := 9;
          end;
          if (sqlQry.FieldValues['ACCTYPE'] = 'CreditCard') then
          begin
            vNode.ImageIndex := 4;
            vNode.SelectedIndex := 9;
          end;
          // imposto nella della propriet� stateindex l'id del record dell account
          // vNode.StateIndex := sqlQry.FieldValues['ACCID'];

          sqlQry.Next;
        end;
    except
      MessageDlg('Error adding account to tree menu', mtError, [mbOK], 0);
    end; // try
  end; // if

  // area report
  vNodeGroup := treeMenu.Items.Add(nil, 'Report');
  vNodeGroup.ImageIndex := 5;

  // area Config
  vNodeGroup := treeMenu.Items.Add(nil, 'Config');
  vNodeGroup.ImageIndex := 6;

  treeMenu.FullExpand;
end;

end.
