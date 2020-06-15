unit pasCommon;

interface

uses
  System.AnsiStrings, Classes, INIFiles, Forms, frmMain, SysUtils, CommCtrl, Vcl.ComCtrls;

// functions
function _UpCase(_pString: string): string;
function _getDBField(_pTBL: string; _pIDfld: string; _pDESfld: string; _pParam: string): string;
function _iniRW(_pFName: string; _pOperation: char; _pSection: string; _Pkey: string; _pValue: string): string;
function _isNumeric(aValue: string): boolean;
function _accountGroup(_pName: string): Integer;

//procedures
procedure _SetNodeState(node: TTreeNode; Flags: Integer);

implementation

var
  _SQLString: string;
  _iniFName:  TiniFile;

  /// -------------------------------------------------------------------------------------------------------------//
  /// ritorno la stringa passata come prima lettera maiuscola e poi tutto minuscolo
function _UpCase(_pString: string): string;
begin
  Result := Uppercase(Copy(_pString, 1, 1)) + Lowercase(Copy(_pString, 2, Length(_pString)));
end;

/// -------------------------------------------------------------------------------------------------------------//
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

/// -------------------------------------------------------------------------------------------------------------//
/// lettura/scrittura del file ini
function _iniRW(_pFName: string; _pOperation: char; _pSection: string; _Pkey: string; _pValue: string): string;
begin
  Result := 'Negative';
  // check if file exists
  _iniFName := TiniFile.Create(_pFName);

  if _pOperation = 'R' then
    if FileExists(_pFName) then
      // Read INI
      Result := _iniFName.ReadString(_pSection, _Pkey, '');

  // Write INI
  if _pOperation = 'W' then
    _iniFName.WriteString(_pSection, _Pkey, _pValue);

  _iniFName.Free;
end;

/// -------------------------------------------------------------------------------------------------------------//
procedure _SetNodeState(node: TTreeNode; Flags: Integer);
var
  tvi: TTVItem;
begin
  FillChar(tvi, SizeOf(tvi), 0);
  tvi.hItem     := node.ItemID;
  tvi.Mask      := TVIF_STATE;
  tvi.StateMask := TVIS_BOLD or TVIS_CUT;
  tvi.State     := Flags;
  TreeView_SetItem(node.Handle, tvi);
end;

/// -------------------------------------------------------------------------------------------------------------//
function _isNumeric(aValue: string): boolean;
var
  i: Integer;
begin
  Result := false;
  if Length(aValue) > 0 then
  begin
    for i := 1 to Length(aValue) do
      if (NOT(aValue[i] in ['0' .. '9', '.', '-', '+', 'E', 'e'])) then
        exit;
    try
      StrToFloat(aValue);
      Result := true;
    except
    end;
  end;
end;
/// -------------------------------------------------------------------------------------------------------------//
function _accountGroup(_pName: string): Integer;
begin
  // ritorno il valore numerico del tipo di conto
  Result := 0;
  if Uppercase(_pName) = 'CHECKING' then
    Result := 0;
  if Uppercase(_pName) = 'CASH' then
    Result := 1;
  if Uppercase(_pName) = 'CREDITCARD' then
    Result := 2;
  if Uppercase(_pName) = 'ONLINE' then
    Result := 3;

end;
/// -------------------------------------------------------------------------------------------------------------//
end.
