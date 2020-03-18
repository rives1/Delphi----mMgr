unit FRMBulkInsert;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
  TBulkInsertFRM = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EDT_daNr: TEdit;
    EDT_aNr: TEdit;
    sbtnOK: TSpeedButton;
    PrgBAR: TProgressBar;
    cmbIssue: TComboBox;
    procedure sbtnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
//    procedure locBulkGen;

  public
    { Public declarations }

  end;

var
  BulkInsertFRM: TBulkInsertFRM;

  //var personali
  vResult     : TStringList; //risultato della query

implementation

uses
  pasSqlDB, FRMMain, pasCommon;

{$R *.DFM}

//-------------------------------------------------------------------------------------------//
procedure TBulkInsertFRM.FormShow(Sender: TObject);
  var
    I      : Integer;
  begin
    //Ripulisco i campi dai loro valori
    cmbIssue.Items.Clear;

    //riempio la combo con i valori
    vResult := TStringList.Create;
    SQLString := 'select CX_ISSUE CMIX ' +
                 ' where CX_SERIE = ''' + mainFRM.tvList.Selected.Text +
                 ''' order by CX_ISSUE'  ;

    vSQL.Query(SQLString, vResult);
    if vResult.Count>0 then
      for I := 1 to vResult.Count-1 do
        begin
          //Issue
          if not locExistsString(locParseStr(vResult.Strings[I],0), cmbIssue.Items) then
            cmbIssue.Items.Add(locParseStr(vResult.Strings[I],0));
        end
    else
      begin
        MessageDlg('No ISSUE present. Insert one first.', mtError, [mbOK], 0);
        vResult.Free;
        Self.Close;
      end;

    vResult.Free;

  end;
//-------------------------------------------------------------------------------------------//
procedure locBulkGen;
  var
    I     : Integer;
//    NrSeq : Integer;
  begin
//    vChkExit := False;
//    if cmbIssue.Items.Count = 0 then
      begin
        MessageDlg('Error in setting the SERIE data for bulk insert', mtError, [mbOK], 0);
        Exit;
      end;

    //recupero i dati da usare come matrice
    vResult := TStringList.Create;
    SQLString := ' select * from CMIX where CX_SERIE = ''' +
                  mainFRM.tvList.Selected.Text + ''' order by CX_ISSUE';

    vSQL.Query(SQLString, vResult);
    if vResult.Count > 0 then
      for I := 1 to vResult.Count-1 do
        //Issue
//        if not locExistsString(locParseStr(vResult.Strings[I],0), cmbIssue.Items) then
//          cmbIssue.Items.Add(locParseStr(vResult.Strings[I],0));

    //impostazione della progress bar
//    PrgBAR.Max := StrToInt(EDT_aNr.Text);
    //Riempimento della combo in base alla serie selezionata sulla main mask
//    for NrSeq := StrToInt(EDT_daNr.Text) to StrToInt(EDT_aNR.Text) do
      begin
        //inserimento record

//        locDBInsert()
//        vDBSET.IssDuplicate(IntToStr(NrSeq),
//        , Length(IntToStr(NrSeq)) + 1,4),
//                            StrToInt(cmb_issue.ComboItems.Items[cmb_issue.ItemIndex].Strings[0]));
//
//        PrgBAR.Position := NrSeq;
      end;
//    vResult.Close;
  end;
//-------------------------------------------------------------------------------------------//
procedure TBulkInsertFRM.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  begin
    if Key = 27 then   // ESC Chiude la form
      if MessageDlg('Confirm Exit?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
        Self.Close;
    if Key = 123 then //pressione di F12
//      SaveData;
  end;
//-------------------------------------------------------------------------------------------//
procedure TBulkInsertFRM.sbtnOKClick(Sender: TObject);
  begin
    //lancio la generazione
    locBulkGen;
    MessageDlg('Bulk insert complete!', mtInformation, [mbOK], 0);
  end;
//-------------------------------------------------------------------------------------------//

end.
