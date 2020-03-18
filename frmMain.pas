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
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Vcl.VirtualImageList;

type
  TMainFRM = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    Chart1: TChart;
    BitBtn1: TBitBtn;
    treeMenu: TTreeView;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    sqlite_conn: TFDConnection;
    sqlQry: TFDQuery;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    function _openDB(_pDBFname: string): boolean;
    procedure _closeDB;
    function _SeekNode(pvSkString: string): TTreeNode;
    procedure _treeMenuCreate();
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
  //apro il db
  _openDB(ExtractFilePath(Application.ExeName)+'dbone.db');
  //riempio il menu
  _treeMenuCreate;
  //riempimento chart saldi

end;

procedure TMainFRM._closeDB;
begin
  // chisura del db
  sqlite_conn.Close;
end;

function TMainFRM._openDB(_pDBFname: string): boolean;
begin
  // MessageDlg('aa',ExtractFilePath(Application.ExeName),mtconfirmation,[mbOK],0 );
  sqlite_conn.Params.Database:= _pDBFname;
  try
    sqlite_conn.Connected := True;

  except
    MessageDlg('Impossible to open the database' + _pDBFname, mtError,
      [mbOK], 0);
    result := false;
  end;
  // sqlite_transaction.Active:=True;
  result := true
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
    vNodeGroup.ImageIndex := 3;
    sqlQry.Close;
    sqlQry.SQL.Clear;
    sqlQry.SQL.Add('SELECT * FROM DBACCOUNT ORDER BY ACCNAME');
    try
      sqlQry.Active:=True;
      if (sqlQry.RecordCount <> 0) then
        while not sqlQry.EOF do // ciclo recupero dati
        begin
          vNodeText := sqlQry.FieldValues['ACCNAME'];
          // if _seekNode(vNodeText) = nil then
          vNode := treeMenu.Items.AddChild(vNodeGroup, vNodeText);
          // aggiungo il nodo
          // selezione quale immagine impostare sul nodo
          if (sqlQry.FieldValues['ACCTYPE'] = 'Cash') then
            vNode.ImageIndex := 0;
          if (sqlQry.FieldValues['ACCTYPE'] = 'Checking') then
            vNode.ImageIndex := 1;
          if (sqlQry.FieldValues['ACCTYPE'] = 'CreditCard') then
            vNode.ImageIndex := 2;
          // imposto nella della propriet� stateindex l'id del record dell account
          //vNode.StateIndex := sqlQry.FieldValues['ACCID'];

          sqlQry.Next;
        end;
    except
      MessageDlg('Error adding account to tree menu', mtError, [mbOK], 0);
    end; // try
  end; // if

  // area Config
  vNodeGroup := treeMenu.Items.Add(nil, 'Config');
  vNodeGroup.ImageIndex := 12;

  // area report
  vNodeGroup := treeMenu.Items.Add(nil, 'Report');
  vNodeGroup.ImageIndex := 11;

  treeMenu.FullExpand;
end;

end.
