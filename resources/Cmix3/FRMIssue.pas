unit FRMIssue;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, LMDControl, LMDBaseControl,
  LMDBaseGraphicControl, LMDBaseShape, LMDShapeControl;

type
  TIssueFRM = class(TForm)
    edtID: TEdit;
    edtIssue: TEdit;
    edtTitle: TEdit;
    cmbAut: TComboBox;
    cmbDes: TComboBox;
    cmbEdi: TComboBox;
    cmbSerie: TComboBox;
    Serie: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnOK: TBitBtn;
    cbToBuy: TCheckBox;
    shStatus: TLMDShapeControl;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cmbSerieExit(Sender: TObject);
    procedure cmbAutExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    //proprietÓ
    fUsrEditType: string;
    fUsrRecID   : string;

    //procedure utente
    procedure FillMask;
    procedure SaveData;

  public
    { Public declarations }
    property usrEditType : string  read fUsrEditType write fUsrEditType;
    property usrRecID    : String  read fUsrRecID    write fUsrRecID;

  end;

var
  IssueFRM: TIssueFRM;

  //var personali
  vResult     : TStringList; //risultato della query

implementation

uses
  FRMMain, pasCommon, PasSqlDB, SQLite;

{$R *.dfm}

//----------------------------------------------------------------------------//
{******** EVENTI DELLA MASK *********}
procedure TIssueFRM.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  var
    ScanTABCode: Integer; //per trovare il valore di TAB
  begin
    if Key = vk_Escape then   // ESC Chiude la form
      if MessageDlg('Confirm Exit?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
        Self.Close;
    if Key = vk_F11 then //pressione di F11
      begin
        SaveData;
        cmbSerie.SetFocus;
      end;
    if Key = vk_F12 then //pressione di F12
      begin
        SaveData;
        cmbSerieExit(nil);
        edtTitle.SetFocus;
      end;
    if Key = vk_return then
      begin
        ScanTABCode:=Lo(MapVirtualKey(vk_tab,0));
        keybd_event(vk_tab, ScanTABCode, 0,0);
      end;
  end;
//----------------------------------------------------------------------------//
procedure TIssueFRM.FormKeyPress(Sender: TObject; var Key: Char);
  begin
    //cambio INVIO con TAB
    if Key = #13 then
      Key := #0;
  end;
//----------------------------------------------------------------------------//
procedure TIssueFRM.FormShow(Sender: TObject);
  begin
    FillMask;
  end;
//----------------------------------------------------------------------------//
procedure TIssueFRM.btnOKClick(Sender: TObject);
  begin
    SaveData;
  end;
//----------------------------------------------------------------------------//
procedure TIssueFRM.cmbAutExit(Sender: TObject);
  begin
    //Replica dell'autore come disegnatore
    if cmbDes.Text = '' then
      cmbDes.Text:=cmbAut.Text;
  end;
//----------------------------------------------------------------------------//
procedure TIssueFRM.cmbSerieExit(Sender: TObject);
  var
   vInt: Integer;  //Valutazione del numero della Issue
  begin
    //sistemo la caption finale
    shStatus.Brush.Color := clBtnFace;
    shStatus.Caption.Caption := '';

    vResult:=TStringList.Create;
    vInt:=0;
    //se sono in inserimento devo recuperare il numero successivo della issue
    if Self.usrEditType = 'N' then
      begin
        SQLString := 'select MAX(CX_ISSUE) as ISS, CX_AUT, CX_DES, CX_EDI, CX_SERIE from CMIX ' +
                     ' group by CX_SERIE, CX_AUT, CX_DES, CX_EDI having CX_SERIE = ''' +
                      locDblQuoteStr(locCapitalize(cmbSerie.Text)) + ''' order by ISS; ';
        vSQL.Query(SQLString, vResult);
        if vResult.Count>1 then
          begin
            try //Test per autoincremento campo ISSUE
              vInt := StrToInt(locParseStr(vResult.Strings[vResult.Count-1], 0));
            except
              on EConvertError do ; //non faccio nulla
            end;

            if vInt <> 0 then
              edtIssue.Text:=IntToStr(StrToInt(locParseStr(vResult.Strings[vResult.Count-1], 0))+1); //issue
            //imputo gli altri campi
            cmbAut.Text:=locParseStr(vResult.Strings[vResult.Count-1], 1); //autor
            cmbDes.Text:=locParseStr(vResult.Strings[vResult.Count-1], 2); //designer
            cmbEdi.Text:=locParseStr(vResult.Strings[vResult.Count-1], 3); //Editor
          end
        else
          //se non trovo niente imputo 1 fisso
          edtIssue.Text:='1';
      end;

    vResult.Free;

  end;
//----------------------------------------------------------------------------//
{******** PROCEDURE INTERNE *******}
procedure TIssueFRM.FillMask;
  var
    I: Integer;
  begin
    //Ripulisco i campi dai loro valori
    cmbEdi.Text:='';
    cmbAut.Text:='';
    cmbDes.Text:='';
    edtIssue.Text:='';
    edtTitle.Text:='';
    edtID.Text:='';

    //Carico nelle combo i valori per le ricerche
    cmbEdi.Items.Clear;
    cmbSerie.Items.Clear;
    cmbAut.Items.Clear;
    cmbDes.Items.Clear;

    vResult := TStringList.Create;
    SQLString := 'select distinct CX_SERIE, CX_DES, CX_AUT, CX_EDI from CMIX;';

    vSQL.Query(SQLString, vResult);
    for I := 1 to vResult.Count-1 do
      begin
        //Serie
        if not locExistsString(locParseStr(vResult.Strings[I],0), cmbSerie.Items) then
          cmbSerie.Items.Add(locParseStr(vResult.Strings[I],0));

        //Designer
        if not locExistsString(locParseStr(vResult.Strings[I],1), cmbDes.Items) then
          cmbDes.Items.Add(locParseStr(vResult.Strings[I],1));

        //Author
        if not locExistsString(locParseStr(vResult.Strings[I],2), cmbAut.Items) then
          cmbAut.Items.Add(locParseStr(vResult.Strings[I],2));

        //Editor
        if not locExistsString(locParseStr(vResult.Strings[I],3), cmbEdi.Items) then
          cmbEdi.Items.Add(locParseStr(vResult.Strings[I],3));
      end;

      //In caso di editing di un record devo riempire i campi
      if Self.usrEditType = 'E' then
        begin
          //ricerco il record passato come ID e riempio i campi
          SQLString := 'Select CX_SERIE, CX_ISSUE, CX_TITLE, CX_AUT, CX_DES, CX_EDI, CX_BUY from CMIX where CX_ID = ' + usrRecID;
          vSQL.Query(SQLString, vResult);
          I:=1;
          if vResult.Count>0 then
            begin
              //compilo i campi con i valori inseriti
              cmbSerie.Text := locParseStr(vResult.Strings[I],0);
              edtIssue.Text := locParseStr(vResult.Strings[I],1);
              edtID.Text    := usrRecID;
              edtTitle.Text := locParseStr(vResult.Strings[I],2);
              cmbAut.Text   := locParseStr(vResult.Strings[I],3);
              cmbDes.Text   := locParseStr(vResult.Strings[I],4);
              cmbEdi.Text   := locParseStr(vResult.Strings[I],5);
              if locParseStr(vResult.Strings[I],6) = 'T' then
                cbToBuy.Checked := True
              else
                cbToBuy.Checked := False;
            end;
        end;   // Edit
    vResult.Free;

  end;
//----------------------------------------------------------------------------//
procedure TIssueFRM.SaveData;
  var
    vToBuy : string;
  begin
    //nuovo record
    if Self.usrEditType = 'N' then
      begin
        //verifico l'esistenza di un duplicato
        if locDBChkDup(cmbSerie.Text, edtIssue.Text) then
          begin
            shStatus.Brush.Color := clRed;
            shStatus.Caption.Caption := 'Error!';
            MessageDlg('A similar record already exists: ' , mtWarning, [mbOK], 0);
            Exit;
          end;

        //valuto la chkbox
        if cbToBuy.Checked then
          vToBuy := 'T'
        else
          vToBuy := 'F';
        //esecuzione dell'update
        if locDBInsert(cmbSerie.Text, edtIssue.Text, edtTitle.Text, cmbDes.Text,
                       cmbAut.Text, cmbEdi.Text, vToBuy) then
          begin
            shStatus.Brush.Color := clskyBlue;
            shStatus.Caption.Caption := 'Record Saved!';
          end;

        //Ripreparo la mask per un nuovo inserimento
        FillMask;
      end;

    //Edit record
    if Self.usrEditType = 'E' then
      begin
        //valutoa la chkbox
        if cbToBuy.Checked then
          vToBuy := 'T'
        else
          vToBuy := 'F';

        //esecuzione dell'update
        if locDBUpdate(cmbSerie.Text, edtIssue.Text, edtTitle.Text, cmbDes.Text,
                       cmbAut.Text, cmbEdi.Text, vToBuy, usrRecID) then
          MessageDlg('Record Updated!', mtInformation, [mbOK], 0)
        else
          MessageDlg('Record not updated!!!', mtWarning, [mbOK], 0);
        //chiudo la mask
        Self.Close;

      end;

  end;
//----------------------------------------------------------------------------//
end.
