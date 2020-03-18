unit pasCSVImport;
  {Importazione da file CSV}
interface

uses
  Classes, SysUtils, FRMMain, pasSqlDB, Controls, pasCommon;

  function locImpCSV: Boolean;
  function locExpCSV: Boolean;

implementation

uses
  Dialogs;

//----------------------------------------------------------------------------//
function locImpCSV: Boolean;
  var
    vFname: TextFile;
    vRow  : string;
    vI, vL, vIx: Integer;
    vRec  : array[0..6] of string;
    vTime : TTime;     //tempo elaborazione
    vRecno : Integer;

  begin
    //selezione del record da importare
    // NB l'importazione sovrascrive i dati già esistenti
    vTime := Time;
    vIx := 0;
    vL  := 1;
    vRecno:=0;
    Result := False;
    MainFRM.dlgSave.Filter:='*.csv|*.csv';
    MainFRM.dlgSave.DefaultExt:='*.csv';
    if MainFRM.dlgOpen.Execute then
      begin
        AssignFile(vFname, MainFRM.dlgOpen.FileName); { File selected in dialog }
        Reset(vFname);
        Readln(vFname, vRow); //leggo la rpima linea che contiene i campi
        while not EOF(vFname) do
          begin
            Readln(vFname, vRow);      { Read first line of file }
            for vI := 0 to Length(vRow) do  //ciclo sulla riga per estrarre i campi
              if vRow[vI] = ';' then
                begin
                  vRec[vIx] := Copy(vRow, vL, vI - vL);
                  vL  := vI+1;
                  vIx := vIx+1;
                end;
            vRec[6] := Copy(vRow, vL, Length(vRow));
            vIx := 0;
            vL := 1;
            //inserisco i campi
            locDBInsert(vRec[0], vRec[1], vRec[2], vRec[3], vRec[4], vRec[5], vRec[6]);
            vRecno:=vRecno+1;
          end;
        CloseFile(vFname);
        MessageDlg('Import Terminated in: '+ TimeToStr(Time - vTime) +#13+#10+
                   'Records imported: ' + IntToStr(vRecno),
                    mtInformation, [mbOK], 0);

      end
  end;
//----------------------------------------------------------------------------//
function locExpCSV: Boolean;
  var
    vFname   : TextFile;
    vResult  : TStringList; //risultato della query
    I        : Integer;
    vFnameStr: string;
    vRow     : string;
    vTime    : TTime;     //tempo elaborazione
    vRecno   : Integer;

  begin
    //esportazione dei dati su file CSV
    Result:=False;
    vTime := Time;
    vRecno := 0;
    
    vResult:=TStringList.Create;
    SQLString := 'Select * from CMIX order by CX_SERIE, CX_ISSUE ';
    vSQL.Query(SQLString , vResult);
    if vResult.Count >1 then
      begin
      MainFRM.dlgSave.Filter:='*.csv|*.csv';
      MainFRM.dlgSave.DefaultExt:='*.csv';
      if MainFRM.dlgSave.Execute then
        begin
          vFnameStr:=MainFRM.dlgSave.FileName;
          AssignFile(vFname, vFnameStr);
          Rewrite(vFname);

          for I := 0 to vResult.Count-1 do  //parto da indice 1 perchè lo 0 è la riga con i campi
            begin
              vRow := locUnDblQuoteStr(locParseStr(vResult.Strings[I],1))+';'+
                      locParseStr(vResult.Strings[I],2)+';'+
                      locUnDblQuoteStr(locParseStr(vResult.Strings[I],3))+';'+
                      locUnDblQuoteStr(locParseStr(vResult.Strings[I],4))+';'+
                      locUnDblQuoteStr(locParseStr(vResult.Strings[I],5))+';'+
                      locUnDblQuoteStr(locParseStr(vResult.Strings[I],6))+';'+
                      locUnDblQuoteStr(locParseStr(vResult.Strings[I],7));
              Writeln(vFname, vRow);
              vRecno:=vRecno+1;
            end;

          CloseFile(vFname);
          Result:=True;
        end;
      end;
    vResult.Free;

    MessageDlg('Export Terminated in: '+ TimeToStr(Time - vTime) +#13+#10+
               'Records exported: ' + IntToStr(vRecno),
                mtInformation, [mbOK], 0);
  end;
//----------------------------------------------------------------------------//
end.
