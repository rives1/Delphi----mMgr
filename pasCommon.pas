unit pasCommon;

interface

uses
  System.AnsiStrings, Classes, INIFiles, Forms, frmMain;

function _UpCase(_pString: string): string;
function _getDBField(_pTBL: string; _pIDfld: string; _pDESfld: string; _pParam: string): string;
function _iniRW(_pFName:string; _pOperation: char):Boolean;

implementation

var
  _SQLString: string;
  _iniFName : TiniFile;

// -------------------------------------------------------------------------------------------------------------//
/// ritorno la stringa passata come prima lettera maiuscola e poi tutto minuscolo
function _UpCase(_pString: string): string;
begin
  Result := Uppercase(Copy(_pString, 1, 1)) + Lowercase(Copy(_pString, 2, Length(_pString)));
end;

// -------------------------------------------------------------------------------------------------------------//
/// decodifico un campo (solitamente l'ID) di una tabella dato un campo
/// attn la richiesta non è molto sicura dipende molto dal fatto che non passino nella richiesta
/// dei campi che potrebbero contenere campi duplicati
function _getDBField(_pTBL, _pIDfld, _pDESfld, _pParam: string): string;
begin
  Result := '0';
  _SQLString := 'SELECT ' + _pIDfld + ' FROM ' + _pTBL + ' where UCASE(' + _pDESfld + ') = UCASE(''' + _pParam + ''') ';
  MainFRM.sqlQry.SQL.Clear;
  MainFRM.sqlQry.SQL.Add(_SQLString);
  try
    MainFRM.sqlQry.Open;
    if MainFRM.sqlQry.RecordCount > 0 then
      Result := Uppercase(MainFRM.sqlQry.FieldValues[_pIDfld]);
  finally
    MainFRM.sqlQry.Close;
    MainFRM.sqlQry.SQL.Clear;
  end;

end;

// -------------------------------------------------------------------------------------------------------------//
/// lettura/scrittura del file ini
{ TODO : sistemare la parametrizzazione della funzione per gestire megli la scrittura/recupero dei parametri }
function _IniRW(_pFName:string; _pOperation: char):Boolean;
  begin
    Result := False;
    //Load INI settings
    if _pOperation = 'R' then
      begin
        _iniFName := tINIFile.Create(ExtractFilePath(Application.ExeName)+_pFName);
//        vDBName := _iniFName.ReadString('FILE','LastFile','X');
        _iniFName.Free;
        Result:=True;
      end;
    //write ini file
    if _pOperation = 'W' then
      begin
        _iniFName := tINIFile.Create(ExtractFilePath(Application.ExeName)+_pFName);
//        _iniFName.WriteString('FILE','LastFile',vDBName);
        _iniFName.Free;
        Result:=True;
     end;
  end;end.
