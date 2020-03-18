unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, Vcl.ExtCtrls, VclTee.TeeGDIPlus, Vcl.StdCtrls, Vcl.Buttons,
  VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, Data.SqlExpr, Data.DbxSqlite,
  Data.DB, Vcl.Menus;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    ImageList1: TImageList;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    Chart1: TChart;
    BitBtn1: TBitBtn;
    treeMenu: TTreeView;
    sqlite_conn: TSQLConnection;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    function _openDB(_pDBFname: string): boolean;
    procedure _closeDB;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

{ TForm1 }

procedure TForm1._closeDB;
begin
  //chisura del db
  sqlite_conn.Close;
end;

function TForm1._openDB(_pDBFname: string): boolean;
begin
//MessageDlg('aa',ExtractFilePath(Application.ExeName),mtconfirmation,[mbOK],0 );
  sqlite_conn.Params.Add('Database=' +_pDBFname);
  try
  sqlite_conn.Open;
  except
    MessageDlg('ERROR','Impossible to open the database'+_pDBFname,mtError,[mbOK],0 );
    result := false;
  end;
//  sqlite_transaction.Active:=True;
  result := true
end;

end.
