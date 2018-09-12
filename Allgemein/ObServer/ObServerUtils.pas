unit ObServerUtils;

interface

uses
  SysUtils, Windows, Classes;

type
{ Exception }

  EObServerError = class(Exception);

{ TClientInfo }

  TClientInfo = record
    UserName: string[32];
    ComputerName: string[32];
    Messages: DWord;
    AType: Integer;
    Action: Integer;
  end;
  PClientInfo = ^TClientInfo;

function BuildChecksum(AString: string): LongInt;
function ChecksumToStr(CRC: LongInt): string;
function ComputerName: string;
function UserName: string;
function FileInUse(FileName: string; TestReadOnly: Boolean = False): Boolean;
function CheckActiveLock(LockFile: string; out ClientInfo: TClientInfo): Boolean;
function CheckActiveLocks(Path: string): TList; overload;
function CheckActiveLocks: TList; overload;
function CheckNetworkInstance(out AUserName, AComputerName: string): Boolean;
function FreeClientList(ClientList: TList): Boolean;

implementation

uses
  Forms, Controls, Math;

{-----------------------------------------------------------------------------
  Procedure: BuildChecksum
  Author:    MH
  Date:      08-Dez-2008
  Arguments: AString: string
  Result:    LongInt
-----------------------------------------------------------------------------}

function BuildChecksum(AString: string): LongInt;
var
  CRCTable: array[0..512] of Longint;

  { BuildCRCTable }

  procedure BuildCRCTable;
  var
    i, j: Word;
    r: Cardinal;
  begin
    FillChar(CRCTable, SizeOf(CRCTable), #0);
    for i := 0 to 255 do
    begin
      r := i shl 1;
      for j := 8 downto 0 do
        if (r and 1) <> 0 then
          r := (r shr 1) xor $EDB88320
        else
          r := r shr 1;
      CRCTable[i] := r;
    end;
  end;

  { RecountCRC }

  function RecountCRC(b: Byte; CrcOld: Longint): Longint;
  begin
    RecountCRC :=
      CRCTable[Byte(CrcOld xor Longint(b))] xor ((CrcOld shr 8) and $00FFFFFF)
  end;
var
  i: Integer;
begin
  BuildCRCTable;
  Result := $FFFFFFF;
  for i := 1 to Length(AString) do
    Result := RecountCRC(Ord(AString[i]), Result);
  Result := not(Result);
end;

{-----------------------------------------------------------------------------
  Procedure: ChecksumToStr
  Author:    MH
  Date:      08-Dez-2008
  Arguments: CRC: LongInt
  Result:    string
-----------------------------------------------------------------------------}

function ChecksumToStr(CRC: LongInt): string;
type

{ TCRCLong }

  TCRCLong = record
    LoWord: Word;
    HiWord: Word;
  end;

{ HextW }

  function HextW(w: Word): string;
  const
    Hex: array[0..15] of Char = '0123456789ABCDEF';
  begin
    Result := Hex[Hi(w) shr 4] + Hex[Hi(w) and $F] + Hex[Lo(w) shr 4] + Hex[Lo(w) and $F];
  end;

{ HextL }

  function HextL(l: Longint): string;
  begin
    with TCRCLong(l) do
      HextL := HextW(HiWord) + HextW(LoWord);
  end;
begin
  Result := HextL(CRC);
end;

{-----------------------------------------------------------------------------
  Procedure: ComputerName
  Author:    MH
  Date:      09-Dez-2008
  Arguments: None
  Result:    string
-----------------------------------------------------------------------------}

function ComputerName: string;
var
  Count: DWord;
begin
  Count := MAX_COMPUTERNAME_LENGTH + 1;
  SetLength(Result, Count);
  if GetComputerName(PChar(Result), Count) then
    SetLength(Result, StrLen(PChar(Result)))
  else
    Result := '';
end;

{-----------------------------------------------------------------------------
  Procedure: UserName
  Author:    MH
  Date:      09-Dez-2008
  Arguments: None
  Result:    string
-----------------------------------------------------------------------------}

function UserName: string;
var
  Count: DWord;
begin
  Count := 256 + 1;
  SetLength(Result, Count);
  if GetUserName(PChar(Result), Count) then
    SetLength(Result, StrLen(PChar(Result)))
  else
    Result := '';
end;

{-----------------------------------------------------------------------------
  Procedure: FileInUse
  Author:    MH
  Date:      08-Dez-2008
  Arguments: FileName: string; TestReadOnly: Boolean = False
  Result:    Boolean
-----------------------------------------------------------------------------}

function FileInUse(FileName: string; TestReadOnly: Boolean = False): Boolean;
var
  FileHandle: THandle;
  DesiredAccess, ShareMode: Cardinal;
begin
  { set default result }
  Result := False;

  { file exists? }
  if not(FileExists(FileName)) then
    Exit;

  { set flags }
  DesiredAccess := GENERIC_READ;
  if not(TestReadOnly) then
    DesiredAccess := DesiredAccess or GENERIC_WRITE;
  ShareMode := IfThen(not(TestReadOnly), 0, FILE_SHARE_READ);

  { try to create file }
  FileHandle := CreateFile(PChar(FileName), DesiredAccess, ShareMode, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

  { test result }
  Result := FileHandle = INVALID_HANDLE_VALUE;

  { close handle? }
  if not(Result) then
    CloseHandle(FileHandle);
end;

{-----------------------------------------------------------------------------
  Procedure: CheckActiveLock
  Author:    MH
  Date:      09-Dez-2008
  Arguments: LockFile: string; out ClientInfo: TClientInfo
  Result:    Boolean
-----------------------------------------------------------------------------}

function CheckActiveLock(LockFile: string; out ClientInfo: TClientInfo): Boolean;
var
  BytesIO: Cardinal;
  FileHandle: THandle;
begin
  { set default result }
  Result := False;

  { initialize client info }
  FillChar(ClientInfo, SizeOf(ClientInfo), #0);

  { append lock extension? }
  if ExtractFileExt(LockFile) = '' then
    LockFile := ChangeFileExt(LockFile, '.lck');

  { test for exlusive flag }
  if not(FileInUse(LockFile)) then
  begin
    DeleteFile(PChar(LockFile));
    Exit;
  end;

  { wait for shared access }
  while FileInUse(LockFile, True) do
    SleepEx(10, False);

  { ignore own lock? }


  { read client info }
  FileHandle := CreateFile(PChar(LockFile), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if FileHandle = INVALID_HANDLE_VALUE then
    Exit;
  try
    if not(ReadFile(FileHandle, ClientInfo, SizeOf(ClientInfo), BytesIO, nil)) then
      raise EObServerError.Create(SysErrorMessage(GetLastError));
    Result := True;
  finally // wrap up
    CloseHandle(FileHandle);
  end;    // try/finally
end;

{-----------------------------------------------------------------------------
  Procedure: CheckActiveLocks
  Author:    MH
  Date:      04-Feb-2009
  Arguments: Path: string
  Result:    TList
-----------------------------------------------------------------------------}

function CheckActiveLocks(Path: string): TList;
var
  FileName: string;
  ListItem: PClientInfo;
  SearchRec: TSearchRec;
  ClientInfo: TClientInfo;
begin
  Result := TList.Create;
  try
    if FindFirst(Path + '\*.lck', 255, SearchRec) <> 0 then
      Abort;
    repeat
      FileName := SearchRec.Name;
      if not(CheckActiveLock(Path + '\' + FileName, ClientInfo)) then
        Continue;
      New(ListItem);
      ListItem^ := ClientInfo;
      Result.Add(ListItem);
    until FindNext(SearchRec) <> 0;
    SysUtils.FindClose(SearchRec);
  except
    FreeClientList(Result);
  end;    // try/except
end;

{-----------------------------------------------------------------------------
  Procedure: CheckActiveLocks
  Author:    MH
  Date:      09-Dez-2008
  Arguments: None
  Result:    TList
-----------------------------------------------------------------------------}

function CheckActiveLocks: TList;
begin
  Result := CheckActiveLocks(
    ExcludeTrailingPathDelimiter(ExtractFilePath(GetModuleName(hInstance))) + '\Locks\' +
    ChangeFileExt(ExtractFileName(GetModuleName(hInstance)), '')
  );
end;

{-----------------------------------------------------------------------------
  Procedure: CheckNetworkInstance
  Author:    MH
  Date:      04-Feb-2009
  Arguments: out AUserName, AComputerName: string
  Result:    Boolean
-----------------------------------------------------------------------------}

function CheckNetworkInstance(out AUserName, AComputerName: string): Boolean;
var
  i: Integer;
  ClientList: TList;
  ClientInfo: PClientInfo;
begin
  { set default result }
  Result := False;
  AUserName := '';
  AComputerName := '';

  { get active locks }
  Screen.Cursor := crHourglass;
  try
    ClientList := CheckActiveLocks;
    if Assigned(ClientList) then
    try
      { iterate through all clients }
      for i := 0 to ClientList.Count - 1 do
      begin
        { get client info }
        ClientInfo := PClientInfo(ClientList[i]);

        { same instance? }
        if SameText(ComputerName, string(ClientInfo^.ComputerName)) then
          Continue;

        { return info }
        AUserName := string(ClientInfo^.UserName);
        AComputerName := string(ClientInfo^.ComputerName);

        { set result }
        Result := True;
        Break;
      end;
    finally // wrap up
      FreeClientList(ClientList);
    end;    // try/finally
  finally // wrap up
    Screen.Cursor := crDefault;
  end;    // try/finally
end;

{-----------------------------------------------------------------------------
  Procedure: FreeClientList
  Author:    MH
  Date:      08-Dez-2008
  Arguments: ClientList: TList
  Result:    Boolean
-----------------------------------------------------------------------------}

function FreeClientList(ClientList: TList): Boolean;
var
  i: Integer;
begin
  Result := Assigned(ClientList);
  if not(Result) then
    Exit;
  try
    for i := 0 to ClientList.Count - 1 do
      Dispose(PClientInfo(ClientList[i]));
    FreeAndNil(ClientList);
    Result := True;
  except
    { catch all errors }
  end;    // try/except
end;

end.
