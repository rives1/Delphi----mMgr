unit FRMPrt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, LMDCustomComboBox, LMDComboBox, DB, kbmMemTable,
  ExtCtrls, SQLite;

type
  TPrtFRM = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    btnOK: TBitBtn;
    cmbFromSer: TComboBox;
    cmbToSer: TComboBox;
    rgSelReport: TRadioGroup;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);

  private
    { Private declarations }
    procedure RunReport;
  public
    { Public declarations }

  end;

var
  PrtFRM: TPrtFRM;

  //var personali
  vResult     : TStringList; //risultato della query

implementation

uses
  FRMMain, pasCommon;

  {$R *.DFM}

//-------------------------------------------------------------------------------------------//
procedure TPrtFRM.FormShow(Sender: TObject);
  var
    I: Integer;
  begin
    // ricreo la lista di tutte le serie disponibili e la carico nelle combo
    cmbFromSer.Items.Clear;
    cmbToSer.Items.Clear;

    vResult := TStringList.Create;
    SQLString := 'select CX_SERIE, CX_AUT, CX_DES, CX_EDI from CMIX;';

    vSQL.Query(SQLString, vResult);
    for I := 1 to vResult.Count-1 do
      begin
        //Serie
        if not locExistsString(locParseStr(vResult.Strings[I],0), cmbFromSer.Items) then
          cmbFromSer.Items.Add(locParseStr(vResult.Strings[I],0));
        if not locExistsString(locParseStr(vResult.Strings[I],0), cmbToSer.Items) then
          cmbToSer.Items.Add(locParseStr(vResult.Strings[I],0));
      end;

    //freemem
    vResult.Free;

  {  MainFRM.MLBMain.GoFirst;
    while not MainFRM.MLBMain.EndOfFile do
      begin
        //Da Serie
        if not locExistsString(MainFRM.MLBMain.GetData('CX_SERIE'), cmbFromSer.Items) then
          cmbFromSer.Items.Add(MainFRM.MLBMain.GetData('CX_SERIE'));

        //A Serie
        if not locExistsString(MainFRM.MLBMain.GetData('CX_SERIE'), cmbToSer.Items) then
          cmbToSer.Items.Add(MainFRM.MLBMain.GetData('CX_SERIE'));

        MainFRM.MLBMain.GoNext;
      end;
   }
    //impostazione del primo e dell'ultimo
    cmbFromSer.ItemIndex:=0;
    cmbToSer.ItemIndex:=cmbFromSer.Items.Count-1;
  end;
//-------------------------------------------------------------------------------------------//
procedure TPrtFRM.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  begin
    if Key = 27 then   // ESC Chiude la form
      if MessageDlg('Confirm Exit?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
        Self.Close;
    //if (Key = 13) and (Shift = [ssCtrl]) then  //INVIO
    if Key = 123 then //pressione di F12
      RunReport;
  end;
//-------------------------------------------------------------------------------------------//
procedure TPrtFRM.RunReport;
  var
    I: Integer;
  begin
    //imposto i campi da stampare nella tabella;
    MainFRM.kbmTB.EmptyTable;
    MainFRM.kbmTB.FieldDefs.Clear;
    MainFRM.kbmTB.IndexDefs.Clear;
    MainFRM.kbmTB.FieldDefs.Add('tbSer', ftString, 35);
    MainFRM.kbmTB.FieldDefs.Add('tbIss', ftString, 5);
    MainFRM.kbmTB.FieldDefs.Add('tbTitle', ftString, 35);
    MainFRM.kbmTB.IndexDefs.Add('Index1','tbSer, tbIss',[]);
    MainFRM.kbmTB.Active := True;


    //report in base alla selezione del radio group
    if rgSelReport.ItemIndex=0 then //report to buy
      begin
        SQLString := 'Select CX_SERIE, CX_ISSUE, CX_TITLE from CMIX ' +
                     ' where CX_BUY = ''T'' and CX_SERIE between ''"' +
                     cmbFromSer.Text + '"'' and ''"' + 
                     cmbToSer.Text   + '"''' +
                     ' order by CX_SERIE, CX_ISSUE';
                     
        vResult := TStringList.Create;
        vSQL.Query(SQLString, vResult);
        for I := 1 to vResult.Count-1 do // inseirmento dati nella memtable
          begin
            MainFRM.kbmTB.Append;
            MainFRM.kbmTB.FieldByName('tbSer').AsString := locParseStr(vResult.Strings[I],0);
            MainFRM.kbmTB.FieldByName('tbIss').AsString  := locParseStr(vResult.Strings[I],1);
            MainFRM.kbmTB.FieldByName('tbTitle').AsString := locParseStr(vResult.Strings[I],2);
            MainFRM.kbmTB.Post;
          end; // inseirmento dati nella memtable

          //lancio il report
          if MainFRM.kbmTB.RecordCount > 0 then
            begin
              MainFRM.rptEngine.LoadFromFile(ExtractFilePath(Application.ExeName)+'rptToBuy.frf');
              MainFRM.rptEngine.ModalPreview:=True;
              MainFRM.rptEngine.ShowReport;
            end
          else
            MessageDlg('No records Returned', mtWarning, [mbOK], 0);
          
//      MainFRM.MLBMain.GoFirst;
//    while not MainFRM.MLBMain.EndOfFile do
//      begin
//        //verfica parametro serie
//        if (MainFRM.MLBMain.GetData('CX_SERIE') >= cmbFromSer.Text) and
//           (MainFRM.MLBMain.GetData('CX_SERIE') <= cmbToSer.Text) then
//          if rgSelReport.ItemIndex = 0 then
//            if MainFRM.MLBMain.GetData('CX_BUY') = 'T' then
//              begin
//                MainFRM.kbmTB.Append;
//                MainFRM.kbmTB.FieldByName('tbSer').AsString := MainFRM.MLBMain.GetData('CX_SERIE');
//                MainFRM.kbmTB.FieldByName('tbIss').AsString  := MainFRM.MLBMain.GetData('CX_ISSUE');
//                MainFRM.kbmTB.FieldByName('tbTitle').AsString := MainFRM.MLBMain.GetData('CX_TITLE');
//                MainFRM.kbmTB.Post;
//              end; // cx_buy = 't'
//
//          if rgSelReport.ItemIndex = 1 then
//            begin
//              MainFRM.kbmTB.Append;
//              MainFRM.kbmTB.FieldByName('tbSer').AsString := MainFRM.MLBMain.GetData('CX_SERIE');
//              MainFRM.kbmTB.FieldByName('tbIss').AsString  := MainFRM.MLBMain.GetData('CX_ISSUE');
//              MainFRM.kbmTB.FieldByName('tbTitle').AsString := MainFRM.MLBMain.GetData('CX_TITLE');
//              MainFRM.kbmTB.Post;
//            end;
//
//        MainFRM.MLBMain.GoNext;
//      end; // ciclo mlbmain

//    if MainFRM.kbmTB.RecordCount > 0 then
//      begin
//        //apro il report di stampa
////        if rgSelReport.ItemIndex = 0 then
//        if rgSelReport.ItemIndex = 1 then
//          MainFRM.rptEngine.LoadFromFile(ExtractFilePath(Application.ExeName)+'rptInventory.frf');
//
//        MainFRM.rptEngine.ModalPreview:=True;
//        MainFRM.rptEngine.ShowReport;
//      end
//    else
//      MessageDlg('No records Returned', mtWarning, [mbOK], 0);

      end; //report to Buy


    if rgSelReport.ItemIndex=1 then //report INVENTORY
      begin
        SQLString := 'Select CX_SERIE, CX_ISSUE, CX_TITLE from CMIX ' +
                     ' where CX_BUY <> ''T'' and CX_SERIE between ''"' + 
                     cmbFromSer.Text + '"'' and ''"' + 
                     cmbToSer.Text   + '"''' +
                     ' order by CX_SERIE, CX_ISSUE';

                     
        vResult := TStringList.Create;
        vSQL.Query(SQLString, vResult);
        for I := 1 to vResult.Count-1 do // inseirmento dati nella memtable
          begin
            MainFRM.kbmTB.Append;
            MainFRM.kbmTB.FieldByName('tbSer').AsString := locParseStr(vResult.Strings[I],0);
            MainFRM.kbmTB.FieldByName('tbIss').AsString  := locParseStr(vResult.Strings[I],1);
            MainFRM.kbmTB.FieldByName('tbTitle').AsString := locParseStr(vResult.Strings[I],2);
            MainFRM.kbmTB.Post;
          end; // inseirmento dati nella memtable

          //lancio il report
          if MainFRM.kbmTB.RecordCount > 0 then
            begin
              MainFRM.rptEngine.LoadFromFile(ExtractFilePath(Application.ExeName)+'rptToBuy.frf');
              MainFRM.rptEngine.ModalPreview:=True;
              MainFRM.rptEngine.ShowReport;
            end
          else
            MessageDlg('No records Returned', mtWarning, [mbOK], 0);
      end; //report inventory





    Self.Close;
  end;
//-------------------------------------------------------------------------------------------//
procedure TPrtFRM.btnOKClick(Sender: TObject);
  begin
    RunReport;
  end;
//-------------------------------------------------------------------------------------------//
end.
