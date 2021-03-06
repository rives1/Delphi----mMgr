unit pasCommon;
  {Funzioni interne}

interface

uses
  Classes, SQLite, SysUtils, INIFiles, Forms, FRMMain;

  function locExistsString(pvSkString:String; pvStrings: TStrings): Boolean;
  function locCapitalize(pvStr: string): string;
  function locParseStr(pvStr:string; pvFldNrReq: integer):string;
  function locDblQuoteStr(pvStr: string; pvQuoteChar: Char = #34): string;
  function locUnDblQuoteStr(const pvStr: string; pvQuoteChar: Char = #34): string;
  function locFileCopy(pvSource, pvDest: String): Boolean;
  function locgetLBId(pvStr: string): string;
  function locRWIni(pvOperation: char):Boolean;
//  function locChkDbOpen: Boolean;

implementation

var
  vIniF       : TiniFile; //file INI per i settaggi

//----------------------------------------------------------------------------//
function locExistsString(pvSkString: string; pvStrings: TStrings): Boolean;
  var
    I: Integer;
  begin
    //Cerca una stringa in una Tstring
    Result := False;
    for I := 0 to pvStrings.Count-1 do
      if pvStrings[I] = pvSkString then
        begin
          Result:=True;
          Break;
        end;
  end;
//----------------------------------------------------------------------------//
function locCapitalize(pvStr: string): string;
  var
    I : Integer;
  begin
    //Rendo tutte le iniziali maiuscole
    for I := 1 to Length(pvStr) do
      begin
        if (I=1) or (pvStr[I-1]=' ') then
          pvStr[I]:=UpCase(pvStr[I]);
      end;
      Result:=pvStr;
  end;
//----------------------------------------------------------------------------//
function locParseStr(pvStr: string; pvFldNrReq: integer): string;
  var
   vParser    : TStringList;
  begin
    //Estraggo la parte della string che viene indicata dalla 2� par
    Result := '';

    vParser:=TStringList.Create;
    //verifico quale sia il separatore
    if Pos(';',pvStr) > 0 then
      vParser.Delimiter:=';'
    else
      vParser.Delimiter:=',';
    //giro la stringa in una lista
    vParser.CommaText:=pvStr;
    Result:=locUnDblQuoteStr(vParser.Strings[pvFldNrReq]); //elimino i doppi apici
    vParser.Free;
  end;
//----------------------------------------------------------------------------//
function locDblQuoteStr(pvStr: string; pvQuoteChar: Char = #34): string;
  //metto nella stringa la doppia quotatura
  var
    I: Integer;
  begin
    //cerco se c'� un apostrofo nella stringa
    for I:=(Length(pvStr)-1) downto 0 do
      if pvStr[I] = '''' then
        begin
        Insert('''',pvStr,I+1);
        end;

    Result := Concat(pvQuoteChar, pvStr, pvQuoteChar);
  end;
//----------------------------------------------------------------------------//
function locUnDblQuoteStr(const pvStr: string; pvQuoteChar: Char = #34): string;
  //Tolgo dalla stringa la doppia quotatura
  begin
    Result := pvStr;
    if length(Result) > 1 then
    begin
      if Result[1] = pvQuoteChar then
        Delete(Result, 1, 1);
      if Result[Length(Result)] = pvQuoteChar then
        Delete(Result, Length(Result), 1);
    end;
  end;
//----------------------------------------------------------------------------//
function locFileCopy(pvSource, pvDest: String): Boolean;
  //eseguo la copia di un file 
  var
    fSrc,fDst,len: Integer;
    size: Longint;
    buffer: packed array [0..2047] of Byte;
  begin
    Result := False; { Assume that it WONT work }
    if pvSource <> pvDest then begin
      fSrc := FileOpen(pvSource,fmOpenRead);
      if fSrc >= 0 then begin
        size := FileSeek(fSrc,0,2);
        FileSeek(fSrc,0,0);
        fDst := FileCreate(pvDest);
        if fDst >= 0 then begin
          while size > 0 do begin
            len := FileRead(fSrc,buffer,sizeof(buffer));
            FileWrite(fDst,buffer,len);
            size := size - len;
          end;
          FileSetDate(fDst,FileGetDate(fSrc));
          FileClose(fDst);
          //FileSetAttr(pvDest,FileGetAttr(pvSource));
          Result := True;
        end;
        FileClose(fSrc);
      end;
    end;
  end;
//----------------------------------------------------------------------------//
function locGetLBId(pvStr: string): String;
  var
   I: Integer;
  begin
    //Estraggo la parte finale (codice ID) dalla stringa passata
    Result:='';
    for I := Length(pvStr)-1 downto 0 do
      if pvStr[I]=';' then
        begin
          Result := Copy(pvStr,I+1,Length(pvStr));
          Break;
        end;    
  end;
//----------------------------------------------------------------------------//
function locRWIni(pvOperation: char):Boolean;
  begin
    Result := False;
        //Load INI settings
    if pvOperation = 'R' then
      begin
        vIniF := tINIFile.Create(ExtractFilePath(Application.ExeName)+'CMIX.ini');
        vDBName := vIniF.ReadString('FILE','LastFile','X');
        vIniF.Free;
        Result:=True;
      end;
    //write ini file
    if pvOperation = 'W' then
      begin
        vIniF := tINIFile.Create(ExtractFilePath(Application.ExeName)+'CMIX.ini');
        vIniF.WriteString('FILE','LastFile',vDBName);
        vIniF.Free;
        Result:=True;
     end;
  end;
//----------------------------------------------------------------------------//
end.
