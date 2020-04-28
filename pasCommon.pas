unit pasCommon;

interface

uses
  System.AnsiStrings, Classes, INIFiles, Forms, frmMain, SysUtils, CommCtrl, Vcl.ComCtrls;

// functions
function _UpCase(_pString: string): string;
function _getDBField(_pTBL: string; _pIDfld: string; _pDESfld: string; _pParam: string): string;
function _iniRW(_pFName: string; _pOperation: char; _pSection: string; _Pkey: string; _pValue: string): string;

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
  if FileExists(_pFName) then
  begin
    // Read INI
    _iniFName := TiniFile.Create(_pFName);
    if _pOperation = 'R' then
      Result := _iniFName.ReadString(_pSection, _Pkey, '');

    // write ini file
    if _pOperation = 'W' then
      _iniFName.WriteString(_pSection, _Pkey, _pValue);

    _iniFName.Free;
  end; // file exists
end;

/// -------------------------------------------------------------------------------------------------------------//
procedure _SetNodeState(Node: TTreeNode; Flags: integer);
var
  tvi: TTVItem;
begin
  FillChar(tvi, SizeOf(tvi), 0);
  tvi.hItem     := Node.ItemID;
  tvi.Mask      := TVIF_STATE;
  tvi.StateMask := TVIS_BOLD or TVIS_CUT;
  tvi.State     := Flags;
  TreeView_SetItem(Node.Handle, tvi);
end;

/// -------------------------------------------------------------------------------------------------------------//
end.
