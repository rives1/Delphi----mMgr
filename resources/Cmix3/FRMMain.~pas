unit FRMMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, ComCtrls, StdCtrls, LMDBaseDialog, LMDAboutDlg,
  Menus, LMDCustomComponent, LMDContainerComponent, LMDCustomScrollBox, LMDListBox,
  kbmMemTable, DB, FR_Class, SQLite, ToolWin, ImgList;

type
  TMainFRM = class(TForm)
    Panel1: TPanel;
    StatBar: TStatusBar;
    LBIssue: TLMDListBox;
    DLGAbout: TLMDAboutDlg;
    tvList: TTreeView;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    mnuMain: TMainMenu;
    mnuFile: TMenuItem;
    mnuFileOpen: TMenuItem;
    mnuQuit: TMenuItem;
    mnuFileNew: TMenuItem;
    mnuIss: TMenuItem;
    mnuIssNew: TMenuItem;
    mnuIssEdit: TMenuItem;
    mnuIssDel: TMenuItem;
    Splitter1: TSplitter;
    mnuPrt: TMenuItem;
    kbmTB: TkbmMemTable;
    mnuSerDel: TMenuItem;
    mnuSer: TMenuItem;
    N1: TMenuItem;
    mnuSerOrdSer: TMenuItem;
    mnuSerOrdAut: TMenuItem;
    mnuSerOrdEdi: TMenuItem;
    pmnuLB: TPopupMenu;
    mnuLBToBuy: TMenuItem;
    rptEngine: TfrReport;
    kbmTBtbSer: TStringField;
    kbmTBtbIss: TStringField;
    kbmTBtbTitle: TStringField;
    N2: TMenuItem;
    mnuImpCSV: TMenuItem;
    mnuExpCSV: TMenuItem;
    ToolBar1: TToolBar;
    tbtnNew: TToolButton;
    tbtnOpen: TToolButton;
    ToolButton4: TToolButton;
    tbtnOrdSer: TToolButton;
    tbtnOrdAut: TToolButton;
    tbtnOrdEdi: TToolButton;
    ToolButton8: TToolButton;
    tbtnIssNew: TToolButton;
    tbtnIssEdt: TToolButton;
    tbtnIssDel: TToolButton;
    tbtnSerDel: TToolButton;
    ToolButton13: TToolButton;
    tbtnPrt: TToolButton;
    ToolButton15: TToolButton;
    tbtnExit: TToolButton;
    ilImages: TImageList;
    N3: TMenuItem;
    ToolButton1: TToolButton;
    mnuSerOrdDes: TMenuItem;
    procedure mnuFileOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuFileNewClick(Sender: TObject);
    procedure rgOrderTypeClick(Sender: TObject);
    procedure tvListChange(Sender: TObject; Node: TTreeNode);
    procedure mnuIssNewClick(Sender: TObject);
    procedure mnuIssEditClick(Sender: TObject);
    procedure mnuQuitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mnuIssDelClick(Sender: TObject);
    procedure mnuSerDelClick(Sender: TObject);
    procedure mnuSerOrdSerClick(Sender: TObject);
    procedure mnuLBToBuyClick(Sender: TObject);
    procedure mnuPrtClick(Sender: TObject);
    procedure mnuImpCSVClick(Sender: TObject);
    procedure mnuExpCSVClick(Sender: TObject);
    procedure mnuSerOrdDesClick(Sender: TObject);

  private
    { Private declarations }
    procedure FillListBox;
    procedure OpenIssueFRM(pvEditType:char);
    procedure DeleteRecord(pvKind:Char);
    procedure ToggleToBuy;

    function SeekNode(pvSkString:string): TTreeNode;

  public
    { Public declarations }
    procedure FillTree;

  end;

var
  MainFRM     : TMainFRM;

  //var personali e globali all'applicazione
  vDBName     : string; //nome file aperto
  vNode       : TTreeNode; //nodo standard del tree
  vLBOnOff    : Boolean; //se on la lb è attiva
  SQLString   : string; //query da lanciare
  vResult     : TStringList; //risultato della query
  vSQL        : tSQLite; //DB Engine


implementation

uses
  FRMIssue, FRMPrt, pasCommon, pasSqlDB, pasCSVImport;

{$R *.dfm}

//----------------------------------------------------------------------------//
{******** USER PROCEDURE **********}
procedure TMainFRM.FillTree;
  var
    vNode : TTreeNode; // nodo riferimento
    vNodeNamePos: string; //testo del vecchio nodo pre refueling del tree
    vTime : TTime;     //tempo elaborazione
    vNodeText, vNodeChildText   : string; //testo del nodo
    vNrSer: Integer;  //calcolo del numero di serie
    I     : Integer;

  begin
    //Riempio il tree view con i dati dal DB
    vTime := Time;
    vNode := nil;
    vNrSer:= 0;
    if tvList.Selected<>nil then
      vNodeNamePos := tvList.Selected.Text;

    //creazione stringlist
    vResult:=TStringlist.Create;

    //disabilito l'aggiornamento della LB
    vLBOnOff := False;

    if vDBName <> 'X' then
      begin
        tvList.Enabled:=False;
        //ripulisco il tree dai vecchi dati
        tvList.Items.Clear;

        //ciclo sulla tabella per rilevare tutti i dati
        if mnuSerOrdSer.Checked then
          vSQL.Query('select distinct CX_SERIE, CX_EDI from CMIX order by CX_SERIE, CX_EDI', vResult);
        if mnuSerOrdAut.Checked then
          vSQL.Query('select distinct CX_AUT, CX_SERIE from CMIX order by CX_AUT, CX_SERIE', vResult);
        if mnuSerOrdEdi.Checked then
          vSQL.Query('select distinct CX_EDI, CX_SERIE from CMIX order by CX_EDI, CX_SERIE', vResult);
        if mnuSerOrdDes.Checked then
          vSQL.Query('select distinct CX_DES, CX_SERIE from CMIX order by CX_DES, CX_SERIE', vResult);

        //recupero i dati dalla query
        for I := 1 to vResult.Count-1 do  //parto da indice 1 perchè lo 0 è la riga con i campi
          begin
            vNodeText      := locParseStr(vResult.Strings[I], 0); //serie
            vNodeChildText := locParseStr(vResult.Strings[I], 1); //autore

            //inserimento del nodo nel tree
            if seekNode(vNodeText) = nil then
              begin
                vNode:=tvList.Items.AddChild(nil, vNodeText);
                vNode:=tvList.Items.AddChild(vNode, vNodeChildText);
                vNrSer:=vNrSer+1;
              end
            else
//              if seeknode(vNodeChildText) = nil then
                vNode:=tvList.Items.AddChild(seekNode(vNodeText), vNodeChildText);

            //controllo se il record riguarda
            if mnuSerOrdSer.Checked then
              vNode.SelectedIndex := 1
            else
              vNode.SelectedIndex := 0; //chk valore

          end; //ciclo sul DB

        //Forzo il sorting
        tvList.AlphaSort(true);
        //tempo elaborazione
        StatBar.Panels[0].Text := 'Tot: ' + IntToStr(vNrSer);
        StatBar.Panels[2].Text := 'Elab.Time: ' + TimeToStr(Time - vTime);

        //riprendo il nodo selezionato precedentemente
        if SeekNode(vNodeNamePos) <> nil then
          SeekNode(vNodeNamePos).Selected:=True;

        tvList.Enabled:=True;
        //riabilito l'aggiornamento della LB
        vLBOnOff := True;
        vResult.Free;

      end; // vDBName <> 'X'
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.FillListBox;
  var
    vBuy   : char;
    vNrIss : integer;
    vLBPos : Integer;
    I      : Integer;
  begin
    //verfiico che ci sia qualcosa presente nell'elenco delle serie prima di procedere
    if tvList.Items.Count < 1 then Exit;
    vNrIss := 0;
    vLBPos := LBIssue.ItemIndex; //salvo la posizione
    if vLBOnOff then
      begin
        //Riempio la listbox con i dati relativi alla serie selezionata
        LBIssue.Items.Clear;
        vResult:=TStringList.Create;

        tvList.SetFocus;
        SQLString := 'Select * from CMIX where CX_SERIE = ''' +
                     locDblQuoteStr(tvList.Selected.Text) +
                     ''' ORDER BY CX_ISSUE; ';
        vSQL.Query(SQLString , vResult);

        for I := 1 to vResult.Count-1 do  //parto da indice 1 perchè lo 0 è la riga con i campi
          begin
            //valutazione se la issue è da acquistare
            if locParseStr(vResult.Strings[I], 7) = 'T' then
              vBuy := 'x'
            else
              vBuy := ' ';
            //inserimento dati nella listbox
            LBIssue.Items.Add(Copy('00000'+locParseStr(vResult.Strings[I], 2),
                                   Length(locParseStr(vResult.Strings[I], 2)) +1, 5) +';'+
                                   locParseStr(vResult.Strings[I], 3) +';'+
                                   vBuy +';'+
                                   locParseStr(vResult.Strings[I], 0) );
            vNrIss := vNrIss+1;
          end; //ciclo FOR

        StatBar.Panels[1].Text := 'Tot Issue: ' + IntToStr(vNrIss);
        vResult.Free;
      end; // if vLBOnOff = off


    //risetto la posizione
    if LBIssue.Items.Count > VLBPos then
      LBIssue.Selected[vLBPos]:=True ;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.OpenIssueFRM(pvEditType: char);
  //Apertura della mask
  var
    vFRM : TIssueFRM;
  begin
    vFRM := TIssueFRM.Create(nil);
    vFRM.Hide;
    vFRM.usrEditType := pvEditType;
    if pvEditType = 'E' then //devo impostare l'ID da cercare per riempire
                             //  i field della mask
      if LBIssue.ItemIndex <> -1 then
        vFRM.usrRecID:=locGetLBId(LBIssue.Items[LBIssue.ItemIndex]);

    vFRM.ShowModal;
    FreeAndNil(vFRM);
    FillTree;
//    tvList.SetFocus;
    FillListBox;
    LBIssue.SetFocus;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.DeleteRecord(pvKind:Char);
  var
    I : Integer;
    vSelNode : TTreeNode; //rif per selezione del nodo
  begin
    //disabilito l'update della lb
    vLBOnOff:=False;

    if pvKind = 'I' then     //elimino la issue correntemente selezionata
      if MessageDlg('Confirm Deletion!', mtWarning, [mbYes,mbNo], 0) = mrYes then
        if LBIssue.ItemIndex <> -1 then
          for I := LBIssue.Items.Count-1 downto 0 do
            if LBIssue.Selected[I] then
              begin
                vSelNode := tvList.Selected;
                locDBDeleteISS(locGetLBId(LBIssue.Items[LBIssue.ItemIndex]));
                tvList.SetFocus;
                vLBOnOff:=True;
                FillListBox;
                if Assigned(vSelNode) then
                  vSelNode.Selected:= True;
              end;

    if pvKind = 'S' then //elimino la serie
      if MessageDlg('Confirm Deletion of: ' + tvList.Selected.Text, mtWarning, [mbYes,mbNo], 0) = mrYes then
        begin
          locDBDeleteSER(locParseStr(locDblQuoteStr(tvList.Selected.Text),0));
          FillTree;
          tvList.SetFocus;
          FillListBox;
        end;
    //abilito l'update
    vLBOnOff:=True;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.ToggleToBuy;
  var
    I    : Integer;
  begin
    //Setto in automatico tutte le issue selezionate come tobuy o viceversa
//    if MessageDlg('Confirm Execution?', mtConfirmation, [mbYes,mbNo], 0) = mrNo then Exit;
    for I := 0 to LBIssue.Items.Count-1 do
      begin
        if LBIssue.Selected[I] then
          begin
            vResult:=TStringList.Create;
            SQLString := 'Select CX_BUY from CMIX where CX_ID = ' + locGetLBId(LBIssue.Items[I]);
            vSQL.Query(SQLString, vResult);
            if vResult.Strings[1] = 'F' then
                SQLString := 'Update CMIX set CX_BUY = ''T'' where CX_ID = ' + locGetLBId(LBIssue.Items[I])
              else
                SQLString := 'Update CMIX set CX_BUY = ''F'' where CX_ID = ' + locGetLBId(LBIssue.Items[I]);
            //update record
            vSQL.Query(SQLString, nil);

            vResult.Free;

          end; // if selected
      end;
    FillListBox;
    LBIssue.SetFocus;
  end;
//----------------------------------------------------------------------------//
{********* USER FUNCTION ***********}
function TMainFRM.SeekNode(pvSkString: string): TTreeNode;
  var
    I : Integer;
  begin
    //ricerco nell'albero il valore della stringa su tutti i nodi di primo livello
    Result := nil;
    for I := 0 to tvList.Items.Count -1 do
      begin
        //Controllo il valore
        if tvlist.Items[I].Text = pvSkString then
          begin
            Result:=tvlist.Items[I];
            Break;
          end;
      end;
  end;
//----------------------------------------------------------------------------//
{********* MASK EVENTS ********}
procedure TMainFRM.FormCreate(Sender: TObject);
  begin
    if locInitDB('A') then
      if vDBName <> 'X' then
         MainFRM.FillTree;
    
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  begin
    //libero la memoria
    if Assigned(vSQL) then
      begin
        vSQL.Free;
        vSQL:=nil;
      end;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    //Save INI settings
    if vDBName <> 'X' then
      begin
        locRWIni('W');
      end;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.rgOrderTypeClick(Sender: TObject);
  begin
    FillTree;
    tvList.SetFocus;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.tvListChange(Sender: TObject; Node: TTreeNode);
  begin
    FillListBox;
  end;
//----------------------------------------------------------------------------//
{******** MENU **********}
procedure TMainFRM.mnuFileOpenClick(Sender: TObject);
  begin
    if locInitDB('O') then
      FillTree;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.mnuFileNewClick(Sender: TObject);
  begin
    if locInitDB('N') then
      FillTree;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.mnuIssNewClick(Sender: TObject);
  begin
    if vDBName <> 'X' then
      OpenIssueFRM('N')
    else
      MessageDlg('DB Not opened!', mtError, [mbOK], 0);;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.mnuIssEditClick(Sender: TObject);
  begin
    if vDBName <> 'X' then
      OpenIssueFRM('E')
    else
      MessageDlg('DB Not opened!', mtError, [mbOK], 0);;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.mnuIssDelClick(Sender: TObject);
  begin
    if vDBName <> 'X' then
      DeleteRecord('I')
    else
      MessageDlg('DB Not opened!', mtError, [mbOK], 0);;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.mnuSerDelClick(Sender: TObject);
  begin
    if vDBName <> 'X' then
      DeleteRecord('S')
    else
      MessageDlg('DB Not opened!', mtError, [mbOK], 0);;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.mnuQuitClick(Sender: TObject);
  begin
    Application.Terminate;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.mnuSerOrdSerClick(Sender: TObject);
  begin
    if vDBName <> 'X' then
      FillTree
    else
      MessageDlg('DB Not opened!', mtError, [mbOK], 0);
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.mnuLBToBuyClick(Sender: TObject);
  begin
    if vDBName <> 'X' then
      ToggleToBuy
    else
      MessageDlg('DB Not opened!', mtError, [mbOK], 0);;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.mnuPrtClick(Sender: TObject);
  var
    vFRM: TPrtFRM;
  begin
    //Lancio la mask delle stampe
    if vDBName <> 'X' then
      begin
        vFRM := TPrtFRM.Create(nil);
        vFRM.Hide;
        vFRM.ShowModal;
        FreeAndNil(vFRM);
      end
    else
      MessageDlg('DB Not opened!', mtError, [mbOK], 0);;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.mnuImpCSVClick(Sender: TObject);
  begin
    //Importazione dal file CSV
    if vDBName <> 'X' then
      begin
        locImpCSV;
        Filltree;
        tvList.SetFocus;
      end
    else
      MessageDlg('DB Not opened!', mtError, [mbOK], 0);;

  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.mnuExpCSVClick(Sender: TObject);
  begin
    if vDBName <> 'X' then
      begin
        locExpCSV;
        Filltree;
        tvList.SetFocus;
      end
    else
      MessageDlg('DB Not opened!', mtError, [mbOK], 0);;
  end;
//----------------------------------------------------------------------------//
procedure TMainFRM.mnuSerOrdDesClick(Sender: TObject);
  begin
    if vDBName <> 'X' then
      FillTree
    else
      MessageDlg('DB Not opened!', mtError, [mbOK], 0);
  end;
//----------------------------------------------------------------------------//
end.
