unit SQLite;
{
simple class interface for SQLite. Hacked in by Ben Hochstrasser (bhoc@surfeu.ch)
Thanks to Roger Reghin (RReghin@scelectric.ca) for his idea to ValueList. 

use it like this:

procedure TForm1.OnSQLBusy(Sender: TObject; ObjectName: String; BusyCount: integer; var Cancel: Boolean);
procedure TForm1.OnSQLData(Sender: TObject; Columns: Integer; ColumnNames, ColumnValues: String);
procedure TForm1.OnSQLComplete(Sender: TObject);

procedure TForm1.Button1Click(Sender: TObject);
var
  MySQL: TSQLite;
  SQL: String;
begin
  MySQL := TSQLite.Create('test.db');
  MySQL.OnData := OnSQLData;
  MySQL.BusyTimeout := 1000;
  MySQL.OnBusy := OnSQLBusy;
  MySQL.OnQueryComplete := OnSQLComplete;
  SQL := 'CREATE TABLE Test(Name varchar(32), Vorname varchar(32));';
  MySQL.Query(sql, nil);
  SQL := 'INSERT INTO Test VALUES(''Hochstrasser'', ''Benedikt'');';
  if MySQL.IsComplete(sql) then
    MySQL.Query(sql, nil);
  SQL := 'SELECT * FROM Test;';
  MySQL.Query(sql, ListBox1.Items);
  MySQL.DatabaseDetails(Memo1.Lines);
  SQL := 'DROP TABLE Test;';
  MySQL.Query(sql, nil);
  MySQL.Free;
end;

You may also add this to your form if you would like to see the results in a ListView

Procedure TStringsToListView(LstIn: TStrings; LstOut: TListView);
var
  n: integer;
  lTmp: TStringList;
begin
  lTmp := TStringList.Create;
  lTmp.CommaText := LstIn.Strings[0];
  LstOut.Items.Clear;
  LstOut.Columns.Clear;
  for n := 0 to lTmp.Count - 1 do
    with LstOut.Columns.Add do
    begin
      Caption := lTmp.Strings[n];
      AutoSize := True;
      Width := -1;
    end;
  for n := 1 to LstIn.Count - 1 do
  begin
    lTmp.CommaText := LstIn.Strings[n];
    with LstOut.Items.Add do
    begin
      Caption := lTmp.Strings[0];
      lTmp.Delete(0);
      SubItems.Text := lTmp.Text;
    end;
  end;
  lTmp.Free;
end;

There is a similar function for a StringGrid:

Procedure TStringsToStringGrid(LstIn: TStrings; LstOut: TStringGrid);
var
  n: integer;
  i: integer;
  lTmp: TStringList;
begin
  if (LstIn <> nil) and (LstOut <> nil) then
  begin
    lTmp := TStringList.Create;
    lTmp.CommaText := LstIn.Strings[0];
    lstOut.ColCount := Ltmp.Count;
    lstout.RowCount := 1;
    lstout.FixedCols := 1;
    lstout.Rows[0] := ltmp;
    i := 1;
    for n := 1 to LstIn.Count - 1 do
    begin
      inc(i);
      lTmp.CommaText := LstIn.Strings[n];
      lstOut.RowCount := i;
      lstOut.Rows[i-1] := ltmp;
    end;
    lstOut.FixedRows := 1;
    lTmp.Free;
  end;
end;

Three utility functions have been added: Pas2SQLStr, SQL2PasStr, ValueList.

  Pas2SQLStr will convert a Pascal-Style String to an SQL-Style String
    Pas2SQLStr('my mother'''s car') -> "my mother''s car"
  SQL2PasStr will convert an SQL-Style string to a Pascal-Style String
    SQL2PasStr('"my mother''s car") -> 'my mother's car'
  ValueList will Convert ColumnNames, ColumnValues Strings to a Name-Value Pair StringList
    ValueList('ID,Name','1001,FooBar') > ID=1001,Name=Foobar

}

interface

uses Windows, Classes;

type
  TSQLiteExecCallback = function(Sender: TObject; Columns: Integer; ColumnValues: Pointer; ColumnNames: Pointer): integer of object; cdecl;
  TSQLiteBusyCallback = function(Sender: TObject; ObjectName: PChar; BusyCount: integer): integer of object; cdecl;
  TOnData = Procedure(Sender: TObject; Columns: Integer; ColumnNames, ColumnValues: String) of object;
  TOnBusy = Procedure(Sender: TObject; ObjectName: String; BusyCount: integer; var Cancel: Boolean) of object;
  TOnQueryComplete = Procedure(Sender: TObject) of object;
  TSQLite = class(TObject)
  private
    fSQLite: Pointer;
    fMsg: String;
    fIsOpen: Boolean;
    fBusy: Boolean;
    fError: Integer;
    fVersion: String;
    fEncoding: String;
    fTable: TStrings;
    fLstName: TStringList;
    fLstVal: TStringList;
    fOnData: TOnData;
    fOnBusy: TOnBusy;
    fOnQueryComplete: TOnQueryComplete;
    fBusyTimeout: integer;
    fPMsg: PChar;
    fChangeCount: integer;
    procedure SetBusyTimeout(Timeout: integer);
  public
    constructor Create(DBFileName: String);
    destructor Destroy; override;
    function Query(Sql: String; Table: TStrings = nil): boolean;
    function ErrorMessage(ErrNo: Integer): string;
    function IsComplete(Sql: String): boolean;
    function LastInsertRow: integer;
    function Cancel: boolean;
    function DatabaseDetails(Table: TStrings): boolean;
    property LastErrorMessage: string read fMsg;
    property LastError: Integer read fError;
    property Version: String read fVersion;
    property Encoding: String read fEncoding;
    property OnData: TOnData read fOnData write fOnData;
    property OnBusy: TOnBusy read fOnBusy write fOnBusy;
    property OnQueryComplete: TOnQueryComplete read fOnQueryComplete write fOnQueryComplete;
    property BusyTimeout: Integer read fBusyTimeout write SetBusyTimeout;
    property ChangeCount: Integer read fChangeCount;
  end;
  function Pas2SQLStr(const PasString: string): string;
  function SQL2PasStr(const SQLString: string): string;
  function QuoteStr(const s: string; QuoteChar: Char = #39): string;
  function UnQuoteStr(const s: string; QuoteChar: Char = #39): string;
  procedure ValueList(const ColumnNames, ColumnValues: String; NameValuePairs: TStrings);

implementation

const
  SQLITE_OK         =  0;   // Successful result
  SQLITE_ERROR      =  1;   // SQL error or missing database
  SQLITE_INTERNAL   =  2;   // An internal logic error in SQLite
  SQLITE_PERM       =  3;   // Access permission denied
  SQLITE_ABORT      =  4;   // Callback routine requested an abort
  SQLITE_BUSY       =  5;   // The database file is locked
  SQLITE_LOCKED     =  6;   // A table in the database is locked
  SQLITE_NOMEM      =  7;   // A malloc() failed
  SQLITE_READONLY   =  8;   // Attempt to write a readonly database
  SQLITE_INTERRUPT  =  9;   // Operation terminated by sqlite_interrupt()
  SQLITE_IOERR      = 10;   // Some kind of disk I/O error occurred
  SQLITE_CORRUPT    = 11;   // The database disk image is malformed
  SQLITE_NOTFOUND   = 12;   // (Internal Only) Table or record not found
  SQLITE_FULL       = 13;   // Insertion failed because database is full
  SQLITE_CANTOPEN   = 14;   // Unable to open the database file
  SQLITE_PROTOCOL   = 15;   // Database lock protocol error
  SQLITE_EMPTY      = 16;   // (Internal Only) Database table is empty
  SQLITE_SCHEMA     = 17;   // The database schema changed
  SQLITE_TOOBIG     = 18;   // Too much data for one row of a table
  SQLITE_CONSTRAINT = 19;   // Abort due to contraint violation
  SQLITE_MISMATCH   = 20;   // Data type mismatch
  SQLITEDLL: PChar  = 'sqlite.dll';
  DblQuote: Char    = '"';
  SngQuote: Char    = #39;
  Crlf: String      = #13#10;
  Tab: Char         = #9;

var
  SQLite_Open: function(dbname: PChar; mode: Integer; var ErrMsg: PChar): Pointer; cdecl;
  SQLite_Close: procedure(db: Pointer); cdecl;
  SQLite_Exec: function(db: Pointer; SQLStatement: PChar; CallbackPtr: Pointer; Sender: TObject; var ErrMsg: PChar): integer; cdecl;
  SQLite_Version: function(): PChar; cdecl;
  SQLite_Encoding: function(): PChar; cdecl;
  SQLite_ErrorString: function(ErrNo: Integer): PChar; cdecl;
  SQLite_GetTable: function(db: Pointer; SQLStatement: PChar; var ResultPtr: Pointer; var RowCount: Cardinal; var ColCount: Cardinal; var ErrMsg: PChar): integer; cdecl;
  SQLite_FreeTable: procedure(Table: PChar); cdecl;
  SQLite_FreeMem: procedure(P: PChar); cdecl;
  SQLite_Complete: function(P: PChar): boolean; cdecl;
  SQLite_LastInsertRow: function(db: Pointer): integer; cdecl;
  SQLite_Cancel: procedure(db: Pointer); cdecl;
  SQLite_BusyHandler: procedure(db: Pointer; CallbackPtr: Pointer; Sender: TObject); cdecl;
  SQLite_BusyTimeout: procedure(db: Pointer; TimeOut: integer); cdecl;
  SQLite_Changes: function(db: Pointer): integer; cdecl;
  LibsLoaded: Boolean;
  DLLHandle: THandle;
  MsgNoError: String;

function QuoteStr(const s: string; QuoteChar: Char = #39): string;
begin
  Result := Concat(QuoteChar, s, QuoteChar);
end;

function UnQuoteStr(const s: string; QuoteChar: Char = #39): string;
begin
  Result := s;
  if length(Result) > 1 then
  begin
    if Result[1] = QuoteChar then
      Delete(Result, 1, 1);
    if Result[Length(Result)] = QuoteChar then
      Delete(Result, Length(Result), 1);
  end;
end;

function Pas2SQLStr(const PasString: string): string;
var
  n: integer;
begin
  Result := SQL2PasStr(PasString);
  n := Length(Result);
  while n > 0 do
  begin
    if Result[n] = SngQuote then
      Insert(SngQuote, Result, n);
    dec(n);
  end;
  Result := QuoteStr(Result);
end;

function SQL2PasStr(const SQLString: string): string;
const
  DblSngQuote: String = #39#39;
var
  p: integer;
begin
  Result := SQLString;
  p := pos(DblSngQuote, Result);
  while p > 0 do
  begin
    Delete(Result, p, 1);
    p := pos(DblSngQuote, Result);
  end;
  Result := UnQuoteStr(Result);
end;

procedure ValueList(const ColumnNames, ColumnValues: String; NameValuePairs: TStrings);
var
  n: integer;
  lstName, lstValue: TStringList;
begin
  if NameValuePairs <> nil then
  begin
    lstName := TStringList.Create;
    lstValue := TStringList.Create;
    lstName.CommaText := ColumnNames;
    lstValue.CommaText := ColumnValues;
    NameValuePairs.Clear;
    if lstName.Count = LstValue.Count then
      if lstName.Count > 0 then
        for n := 0 to lstName.Count - 1 do
          NameValuePairs.Append(Concat(lstName.Strings[n], '=', lstValue.Strings[n]));
    lstValue.Free;
    lstName.Free;
  end;
end;

function LoadLibs: Boolean;
begin
  Result := False;
  DLLHandle := LoadLibrary(SQLITEDLL);
  if DLLHandle <> 0 then
  begin
    @SQLite_Open := GetProcAddress(DLLHandle, 'sqlite_open');
    if not Assigned(@SQLite_Open) then exit;
    @SQLite_Close := GetProcAddress(DLLHandle, 'sqlite_close');
    if not Assigned(@SQLite_Close) then exit;
    @SQLite_Exec := GetProcAddress(DLLHandle, 'sqlite_exec');
    if not Assigned(@SQLite_Exec) then exit;
    @SQLite_Version := GetProcAddress(DLLHandle, 'sqlite_libversion');
    if not Assigned(@SQLite_Version) then exit;
    @SQLite_Encoding := GetProcAddress(DLLHandle, 'sqlite_libencoding');
    if not Assigned(@SQLite_Encoding) then exit;
    @SQLite_ErrorString := GetProcAddress(DLLHandle, 'sqlite_error_string');
    if not Assigned(@SQLite_ErrorString) then exit;
    @SQLite_GetTable := GetProcAddress(DLLHandle, 'sqlite_get_table');
    if not Assigned(@SQLite_GetTable) then exit;
    @SQLite_FreeTable := GetProcAddress(DLLHandle, 'sqlite_free_table');
    if not Assigned(@SQLite_FreeTable) then exit;
    @SQLite_FreeMem := GetProcAddress(DLLHandle, 'sqlite_freemem');
    if not Assigned(@SQLite_FreeMem) then exit;
    @SQLite_Complete := GetProcAddress(DLLHandle, 'sqlite_complete');
    if not Assigned(@SQLite_Complete) then exit;
    @SQLite_LastInsertRow := GetProcAddress(DLLHandle, 'sqlite_last_insert_rowid');
    if not Assigned(@SQLite_LastInsertRow) then exit;
    @SQLite_Cancel := GetProcAddress(DLLHandle, 'sqlite_interrupt');
    if not Assigned(@SQLite_Cancel) then exit;
    @SQLite_BusyTimeout := GetProcAddress(DLLHandle, 'sqlite_busy_timeout');
    if not Assigned(@SQLite_BusyTimeout) then exit;
    @SQLite_BusyHandler := GetProcAddress(DLLHandle, 'sqlite_busy_handler');
    if not Assigned(@SQLite_BusyHandler) then exit;
    @SQLite_Changes := GetProcAddress(DLLHandle, 'sqlite_changes');
    if not Assigned(@SQLite_Changes) then exit;
    Result := True;
  end;
end;

function SystemErrorMsg(ErrNo: Integer = -1): String;
var
  buf: PChar;
  size: Integer;
  MsgLen: Integer;
begin
  size := 256;
  GetMem(buf, size);
  If ErrNo = - 1 then
    ErrNo := GetLastError;
  MsgLen := FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, ErrNo, 0, buf, size, nil);
  if MsgLen = 0 then
    Result := 'ERROR'
  else
    Result := buf;
end;

function BusyCallback(Sender: TObject; ObjectName: PChar; BusyCount: integer): integer; cdecl;
var
  sObjName: String;
  bCancel: Boolean;
begin
  Result := -1;
  with Sender as TSQLite do
  begin
    if Assigned(fOnBusy) then
    begin
      bCancel := False;
      sObjName := ObjectName;
      fOnBusy(Sender, sObjName, BusyCount, bCancel);
      if bCancel then
        Result := 0;
    end;
  end;
end;

function ExecCallback(Sender: TObject; Columns: Integer; ColumnValues: Pointer; ColumnNames: Pointer): integer; cdecl;
var
  PVal, PName: ^PChar;
  n: integer;
  sVal, sName: String;
begin
  Result := 0;
  with Sender as TSQLite do
  begin
    if (Assigned(fOnData) or Assigned(fTable)) then
    begin
      fLstName.Clear;
      fLstVal.Clear;
      if Columns > 0 then
      begin
        PName := ColumnNames;
        PVal := ColumnValues;
        for n := 0 to Columns - 1 do
        begin
          fLstName.Append(PName^);
          fLstVal.Append(PVal^);
          inc(PName);
          inc(PVal);
        end;
      end;
      sVal := fLstVal.CommaText;
      sName := fLstName.CommaText;
      if Assigned(fOnData) then
        fOnData(Sender, Columns, sName, sVal);
      if Assigned(fTable) then
      begin
        if fTable.Count = 0 then
          fTable.Append(sName);
        fTable.Append(sVal);
      end;
    end;
  end;
end;

constructor TSQLite.Create(DBFileName: String);
var
  fPMsg: PChar;
begin
  inherited Create;
  fError := SQLITE_ERROR;
  fIsOpen := False;
  fLstName := TStringList.Create;
  fLstVal := TStringList.Create;
  fOnData := nil;
  fOnBusy := nil;
  fOnQueryComplete := nil;
  fChangeCount := 0;
  if LibsLoaded then
  begin
    fSQLite := SQLite_Open(PChar(DBFileName), 1, fPMsg);
    SQLite_FreeMem(fPMsg);
    if fSQLite <> nil then
    begin
      fVersion := SQLite_Version;
      fEncoding := SQLite_Encoding;
      fIsOpen := True;
      fError := SQLITE_OK;
    end;
  end;
  fMsg := ErrorMessage(fError);
end;

destructor TSQLite.Destroy;
begin
  if fIsOpen then
    SQLite_Close(fSQLite);
  fIsOpen := False;
  fLstName.Free;
  fLstVal.Free;
  fSQLite := nil;
  fOnData := nil;
  fOnBusy := nil;
  fOnQueryComplete := nil;
  fLstName := nil;
  fLstVal := nil;
  inherited Destroy;
end;

function TSQLite.Query(Sql: String; Table: TStrings = nil): boolean;
//var
//  fPMsg: PChar;
begin
  fError := SQLITE_ERROR;
  if fIsOpen then
  begin
    fPMsg := nil;
    fBusy := True;
    fTable := Table;
    if fTable <> nil then
      fTable.Clear;
    fError := SQLite_Exec(fSQLite, PChar(Sql), @ExecCallback, Self, fPMsg);
    SQLite_FreeMem(fPMsg);
    fChangeCount := SQLite_Changes(fSQLite);
    fTable := nil;
    fBusy := False;
    if Assigned(fOnQueryComplete) then
      fOnQueryComplete(Self);
  end;
  fMsg := ErrorMessage(fError);
  Result := (fError <> SQLITE_OK);
end;

function TSQLite.Cancel: boolean;
begin
  Result := False;
  if fBusy and fIsOpen then
  begin
    SQLite_Cancel(fSQLite);
    fBusy := false;
    Result := True;
  end;
end;

procedure TSQLite.SetBusyTimeout(Timeout: Integer);
begin
  fBusyTimeout := Timeout;
  if fIsOpen then
  begin
    SQLite_BusyTimeout(fSQLite, fBusyTimeout);
    if fBusyTimeout > 0 then
      SQLite_BusyHandler(fSQLite, @BusyCallback, Self)
    else
      SQLite_BusyHandler(fSQLite, nil, nil);
  end;
end;

function TSQLite.LastInsertRow: integer;
begin
  if fIsOpen then
    Result := SQLite_LastInsertRow(fSQLite)
  else
    Result := -1;
end;

function TSQLite.ErrorMessage(ErrNo: Integer): string;
begin
  if LibsLoaded then
  begin
    if ErrNo = 0 then
      Result := MsgNoError
    else
      Result := SQLite_ErrorString(ErrNo);
  end else
    MessageBox(GetActiveWindow(), 'Library "sqlite.dll" not found.', 'Error loading DLL', MB_OK or MB_ICONHAND or MB_SETFOREGROUND);
end;

function TSQLite.IsComplete(Sql: String): boolean;
begin
  Result := SQLite_Complete(PChar(Sql));
end;

function TSQLite.DatabaseDetails(Table: TStrings): boolean;
begin
  Result := Query('SELECT * FROM SQLITE_MASTER;', Table);
end;

initialization
  LibsLoaded := LoadLibs;
  MsgNoError := SystemErrorMsg(0);

finalization
  if DLLHandle <> 0 then
    FreeLibrary(DLLHandle);

end.
