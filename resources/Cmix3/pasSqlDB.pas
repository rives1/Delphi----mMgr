unit pasSqlDB;
  {Funzioni I/O DB SQLLite}
interface

uses
  Classes, SysUtils, SQLite, FRMMain, pasCommon, Dialogs, controls;

  function locInitDB(pvKind:Char):boolean;
  function locDBCreate(pvDbName: string)  : Boolean;
  function locDBInsert(pvSerie, pvIssue, pvTitle, pvDes, pvAut, pvEdi, pvBuy: string) : Boolean;
  function locDBUpdate(pvSerie, pvIssue, pvTitle, pvDes, pvAut, pvEdi, pvBuy, pvID: string) : Boolean;
  function locDBDeleteISS(pvID: string)   : Boolean;
  function locDBDeleteSER(pvSerie: string): Boolean;
  function locDBChkDup(pvSerie, pvIssue: string): Boolean;

implementation

var
  //var personali
  vResult     : TStringList; //risultato della query


//----------------------------------------------------------------------------//
function locInitDB(pvKind:Char):boolean;
  begin
    Result:=True;

    if pvKind = 'N' then // creazione di un nuovo db
      begin
        MainFRM.dlgSave.Filter:='*.db|*.db';
        MainFRM.dlgSave.DefaultExt:='*.db';
        if MainFRM.dlgSave.Execute then
          begin
            vDBName := MainFRM.dlgSave.FileName;
            //creo il nuovo DB
            locDBCreate(vDBName);
            MainFRM.StatBar.Panels[3].Text:=vDBName;

            //Exit;
          end
        else
          begin
            MessageDlg('Operation Aborted!!', mtWarning, [mbOK], 0);
            Result:=False;
            vDBName := 'X';
            MainFRM.StatBar.Panels[3].Text:='';
          end;
      end;

    if pvKind = 'O' then // apertura di un db
      begin
        MainFRM.dlgSave.Filter:='*.db|*.db';
        MainFRM.dlgSave.DefaultExt:='*.db';
        if MainFRM.dlgOpen.Execute then
          begin
            vDBName := MainFRM.dlgOpen.FileName;
            //creo una copia di sicurezza del DB prima di aprirlo
            locFileCopy(vDBName,vDBName+'bk');
            MainFRM.StatBar.Panels[3].Text:=vDBName;
          end
        else
          begin
            MessageDlg('Operation Aborted!!', mtWarning, [mbOK], 0);
            Result:=False;
            vDBName := 'X';
            MainFRM.StatBar.Panels[3].Text:='';
          end;
      end;

    if pvKind = 'A' then  //Autoopen del file all'apertura del programma
      begin
        //creo una copia di sicurezza del DB prima di aprirlo
        locRWIni('R');
        if vDBName <> 'X' then
          locFileCopy(vDBName,vDBName+'bk');
        MainFRM.StatBar.Panels[3].Text:=vDBName;
      end;


    //creazione istanza principale per l'acceso al DB
    if vDBName <> 'X' then
      begin
        if Assigned(vSQL) then
          begin
            vSQL.Free;
            vSQL:=nil
          end;
        vSQL := TSQLite.Create(vDBName)
      end
    else
      begin
        if MessageDlg('Error in opening DB. Continue ', mtError, [mbYes, mbNo], 0) = mrYes then
          locinitDB('O');
      end;
      
  end;
//----------------------------------------------------------------------------//
function locDBCreate(pvDbName: string): Boolean;
  begin
    //creazione di un nuovo DB
    Result := False;
    //chiudo il Db aperto al momento se ce ne sono
    if Assigned(vSQL) then
      begin
        vSQL.Free;
        vSQL:=nil;
      end;
    //chk esistenzafile
    if FileExists(vDBName) then
      if MessageDlg('DB already Exists.'+#13+#10+'Delete and recreate from scratch?', 
                     mtConfirmation, [mbYes,mbNo], 0) = mrYes then 
        if not DeleteFile(vDBName) then
          begin
            MessageDlg('Cannot create new file.'+#13+#10+'Procedure interrupted!',
                        mtError, [mbOK], 0);
            Exit;
          end;
    //creo il nuovo
    vSQL := TSQLite.Create(vDBName);
    
    SQLString := 'Create TABLE CMIX( ' +
    ' CX_ID Integer primary key, ' +
    ' CX_SERIE varchar(30), ' +
    ' CX_ISSUE varchar(5),  ' +
    ' CX_TITLE varchar(40), ' +
    ' CX_DES varchar(35),   ' +
    ' CX_AUT varchar(35),   ' +
    ' CX_EDI varchar(35),   ' +
    ' CX_BUY varchar(1) );';

    //esecuzione creazione db
    if not vSQL.Query(SQLString, nil) then
      Result := True;
    vSQL.Free;
    vSQL:=nil;
  end;
//----------------------------------------------------------------------------//
function locDBInsert(pvSerie, pvIssue, pvTitle, pvDes, pvAut, pvEdi, pvBuy: string) : Boolean;
  begin
    //inserimento record
    Result:=False;
    if not locDBChkDup(pvSerie, pvIssue) then
      begin
        SQLString := ' Insert into CMIX VALUES ( ' +
          ' NULL, ' +
          ' '''+ locDblQuoteStr(locCapitalize(pvSerie)) + ''',' +
          ' '''+ Copy('00000'+pvIssue, Length(pvIssue) +1, 5) + ''',' +
          ' '''+ locDblQuoteStr(locCapitalize(pvTitle)) + ''',' +
          ' '''+ locDblQuoteStr(locCapitalize(pvDes))   + ''',' +
          ' '''+ locDblQuoteStr(locCapitalize(pvAut))   + ''',' +
          ' '''+ locDblQuoteStr(locCapitalize(pvEdi))   + ''',' +
          ' '''+ pvBuy + ''')';

        //esecuzione insert
        if not vSQL.Query(SQLString, nil) then
          Result := True;
      end;

  end;
//----------------------------------------------------------------------------//
function locDBUpdate(pvSerie, pvIssue, pvTitle, pvDes, pvAut, pvEdi, pvBuy, pvID: string) : Boolean;
  begin
    Result := False;
    //verfica duplicati
    SQLString := 'UPDATE CMIX SET ' +
    ' CX_SERIE = '''+ locDblQuoteStr(locCapitalize(pvSerie)) + ''',' +
    ' CX_ISSUE = '''+ Copy('00000'+pvIssue, Length(pvIssue) +1, 5) + ''',' +
    ' CX_TITLE = '''+ locDblQuoteStr(locCapitalize(pvTitle)) + ''',' +
    ' CX_AUT = '''+ locDblQuoteStr(locCapitalize(pvAut))     + ''',' +
    ' CX_DES = '''+ locDblQuoteStr(locCapitalize(pvDes))     + ''',' +
    ' CX_EDI = '''+ locDblQuoteStr(locCapitalize(pvEdi))     + ''',' +
    ' CX_BUY = '''+ pvBuy + ''' ' +
    ' WHERE CX_ID = ' + pvID + ';';

    //esecuzione update
    if not vSQL.Query(SQLString, nil) then
      Result := True;
      
  end;
//----------------------------------------------------------------------------//
function locDBDeleteISS(pvID: string):Boolean;
  begin
    //Eliminazione record
    Result:= False;
    SQLString := 'Delete from CMIX where CX_ID = ' + pvID;
    if not vSQL.Query(SQLString, nil) then
      Result := True;
  end;
//----------------------------------------------------------------------------//
function locDBDeleteSER(pvSerie: string):Boolean;
  begin
    //Eliminazione record
    Result:= False;
    SQLString := 'Delete from CMIX where CX_SERIE = ''' +
                  locDblQuoteStr(locCapitalize(pvSerie)) + '''; ';
    if not vSQL.Query(SQLString, nil) then
      Result := True;
  end;
//----------------------------------------------------------------------------//
function locDBChkDup(pvSerie, pvIssue: string): Boolean;
  begin  
    //Verifico che il record da processare non esista gi� come sere e/o issue
    Result:=False;
    vResult:=TStringList.Create;
    SQLString := 'select count(*) from CMIX where CX_SERIE = ''' +
                  locDblQuoteStr(locCapitalize(pvSerie)) + ''' and CX_ISSUE = ''' +
                  Copy('00000'+pvIssue, Length(pvIssue) +1, 5) + ''' ';

    vSQL.Query(SQLString, vResult);
    if (vResult.Count > 0) and (StrToInt(locParseStr(vResult.Strings[1], 0)) > 0) then
      Result := True;
    vResult.Free;
    
  end;
//----------------------------------------------------------------------------//

end.
 