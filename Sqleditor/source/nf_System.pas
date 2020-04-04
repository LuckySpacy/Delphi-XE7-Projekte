unit nf_System;

interface

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}



uses
  Windows, SysUtils, Classes, FileCtrl, Dialogs, ShellApi, Forms, ClipBrd, shlobj,
  ActiveX, TLHelp32;

type
  Tnf_VersionNr = Record
    Hauptversion: Word;
    Nebenversion: Word;
    Ausgabe     : Word;
    Compilierung: Word;
    VersionText : String;
  end;

function nf_GetFileVersion(const AFilename:String; var aVersionsNr: Tnf_VersionNr):Boolean;
function nf_GetBuildDate(const AFileName: String): String;
procedure nf_GetSubDirectory(aPath: String; aStrings: TStrings;const All: Boolean = true);
procedure nf_GetAllFiles(aPath: String; aStrings: TStrings;
  const WithPathName: Boolean; const All: Boolean = true; const Mask: String = '*.*');
procedure nf_DeleteAllFiles(const aDir, aFiles: String);
function  nf_Directory(aPath: String; const aSearchRec: TSearchRec): Boolean;
function  nf_GetFileDate(const aFullFileName: String): TDateTime;
function  nf_GetFileInfo(const aFullFileName: String) : TSearchRec;
function  nf_ExtractResToFile(ResType, ResName, ResNewName: string): Boolean;
procedure nf_ShellExecute_And_Wait(aApplication: TApplication; aFileName: string);
function  nf_GetTempDir: String;
procedure nf_StrToClipboard(StrValue: string);
function  nf_GetStrFromClipboard: string;
function  nf_GetComputerName: string;
procedure nf_ShellExec(aPrgname : string; const aParam: string = '';
  const aDirectory: string = ''; const aWindowCommand: Word = SW_SHOWNORMAL);
function nf_ChangeFileExt(aFile, aNewExt: string): string;
function nf_GetShellFolder(CSIDL: integer): string;
function nf_ProgramInTask(aValue: string): Boolean;
function nf_IsWow64: Boolean;



implementation


function nf_GetFileVersion(const AFilename:String; var aVersionsNr: Tnf_VersionNr):Boolean;
var
   VerInfoSize  : DWord;
   VerValueSize : DWord;
   Dummy        : DWord;
   VerInfo      : Pointer;
   VerValue     : PVSFixedFileInfo;
begin
  VerInfoSize:=GetFileVersionInfoSize(PChar(AFilename),Dummy);
  Result:=False;
  if VerInfoSize<>0 then
  begin
    GetMem(VerInfo,VerInfoSize);
    try
      if GetFileVersionInfo(PChar(AFilename),0,VerInfoSize,VerInfo) then
      begin
        if VerQueryValue(VerInfo,'\',Pointer(VerValue),VerValueSize) then
        with VerValue^ do
        begin
          aVersionsNr.Hauptversion  := dwFileVersionMS shr 16;
          aVersionsNr.Nebenversion  := dwFileVersionMS and $FFFF;
          aVersionsNr.Ausgabe       := dwFileVersionLS shr 16;
          aVersionsNr.Compilierung  := dwFileVersionLS and $FFFF;
          aVersionsNr.VersionText   := IntToStr(aVersionsNr.Hauptversion) + '.' +
                                       IntToStr(aVersionsNr.Nebenversion) + '.' +
                                       IntToStr(aVersionsNr.Ausgabe)      + '.' +
                                       IntToStr(aVersionsNr.Compilierung);
        end;
        Result:=True;
      end;
    finally
      FreeMem(VerInfo,VerInfoSize);
    end;
  end;
end;


function nf_GetBuildDate(const AFileName: String): String;
const
  SNotAvailable = 'Value Not Available';
var
  LanguageID: string;
  CodePage: string;
  TranslationLength: Cardinal;
  TranslationTable: Pointer;
  InfoSize, Temp, Len: DWord;
  InfoBuf: Pointer;
  Value: PChar;
  LookupString: string;
  FileName    : String;
  VersionInfoAvailable: Boolean;
  PathStz: array[ 0..MAX_PATH ] of Char;
begin
  // Get File Version Information
  FileName := AFileName;
  if FileName = '' then
  begin
    GetModuleFileName( HInstance, PathStz, SizeOf( PathStz ) );
    FileName := StrPas( PathStz );
  end;
  InfoSize := GetFileVersionInfoSize( PChar( FileName ), Temp );
  VersionInfoAvailable := InfoSize > 0;
  if VersionInfoAvailable then
  begin
    InfoBuf := AllocMem( InfoSize );
    try
      GetFileVersionInfo( PChar( FileName ), 0, InfoSize, InfoBuf );


      if VerQueryValue( InfoBuf, '\VarFileInfo\Translation', TranslationTable, TranslationLength ) then
      begin
        CodePage := Format( '%.4x', [ HiWord( PLongInt( TranslationTable )^ ) ] );
        LanguageID := Format( '%.4x', [ LoWord( PLongInt( TranslationTable )^ ) ] );
      end;

      LookupString := 'StringFileInfo\' + LanguageID + CodePage + '\';

      if VerQueryValue( InfoBuf, PChar( LookupString + 'BuildDate' ), Pointer( Value ), Len ) then
        Result := Value
      else
        Result := SNotAvailable;
    finally
      FreeMem( InfoBuf, InfoSize );
    end;
  end
  else
    Result := SNotAvailable;
end; 


procedure nf_GetAllFiles(aPath: String; aStrings: TStrings;
  const WithPathName: Boolean; const All: Boolean = true; const Mask: String = '*.*');
var
  Search: TSearchRec;
  i1    : Integer;
  sList : TStringList;
begin
  sList := TStringList.Create;
  try
    aStrings.Clear;
    try
      if All then
        nf_GetSubDirectory(aPath, sList);
      aPath := Trim(aPath);
      aPath := IncludeTrailingBackslash(aPath);
      FindFirst(aPath + Mask, faAnyFile, Search);
      repeat
        Application.ProcessMessages;
        if not nf_Directory(aPath, Search) then
        begin
          if  (Search.Name <> '.') and (Search.Name <> '..')
          and (Search.Name > '') then
          begin
            if WithPathName then
              aStrings.Add(Lowercase(aPath + Search.Name))
            else
              aStrings.Add(Lowercase(Search.Name));
          end;
        end;
        if Trim(Search.Name) = '' then
          break; // Dieser Break ist wichtig, da unter WINNT beim nächsten FindNext ein Fehler auftritt (tb 05.03.2008)
      until FindNext(Search) <> 0;
      FindClose(Search);
      if not All then
      begin
        sList.Assign(aStrings);
        sList.Sort;
        aStrings.Assign(sList);
        exit;
      end;
      for i1 := 0 to sList.Count -1 do
      begin
        Application.ProcessMessages;
        aPath := Trim(sList.Strings[i1]);
        aPath := IncludeTrailingBackslash(aPath);
        FindFirst(aPath + Mask, faAnyFile, Search);
        repeat
          if not nf_Directory(aPath, Search) then
          begin
            if  (Search.Name <> '.') and (Search.Name <> '..')
            and (Search.Name > '') then
            begin
              if WithPathName then
                aStrings.Add(Lowercase(aPath + Search.Name))
              else
                aStrings.Add(Lowercase(Search.Name));
            end;
          end;
          if Trim(Search.Name) = '' then
            break; // Dieser Break ist wichtig, da unter WINNT beim nächsten FindNext ein Fehler auftritt (tb 05.03.2008)
        until FindNext(Search) <> 0;
        FindClose(Search);
      end;
      sList.Assign(aStrings);
      sList.Sort;
      aStrings.Assign(sList);
    except
      on E: Exception do
      begin
        MessageDlg('Error in (sySystem.pas) procedure syGetAllFiles(aPath: String; aStrings: TStrings;',
          mtError, [mbOk], 0);
        ShowMessage(E.Message);
        raise;
      end;
    end;
  finally
    FreeAndNil(sList);
    FindClose(Search);
  end;
end;


procedure nf_GetSubDirectory(aPath: String; aStrings: TStrings;const All: Boolean = true);
var
  Search: TSearchRec;
  sList1: TStringList;
  sList2: TStringList;
  i1    : Integer;
begin
  aStrings.Clear;
  aPath := Trim(aPath);
  aPath := IncludeTrailingBackslash(aPath);

  FindFirst(aPath + '*.*', faAnyFile, Search);
  repeat
    if nf_Directory(aPath, Search) then
      aStrings.Add(Lowercase(aPath + Search.Name));
  until FindNext(Search) <> 0;

  if not All then
    exit;

  sList1 := TStringList.Create;
  sList2 := TStringList.Create;
  try
    sList1.Clear;
    sList1.Assign(aStrings);
    while sList1.Count > 0 do
    begin
      sList2.Clear;
      for i1 := 0 to sList1.Count -1 do
      begin
        aPath := IncludeTrailingBackslash(sList1.Strings[i1]);
        FindFirst(aPath + '*.*', faAnyFile, Search);
        repeat
          if nf_Directory(aPath, Search) then
            sList2.Add(Lowercase(aPath + Search.Name));
        until FindNext(Search) <> 0;
      end;
      sList1.Assign(sList2);
      for i1 := 0 to sList2.Count -1 do
        aStrings.Add(sList2.Strings[i1]);
    end;
    sList1.Assign(aStrings);
    sList1.Sort;
    aStrings.Assign(sList1);
    FindClose(Search);
  finally
    FreeAndNil(sList1);
    FreeAndNil(sList2);
  end;

end;


// Diese Prozedur löscht alle Dateien im angegebenem Pfad
// aFiles kann wie folgt aussehen: *.doc oder test.* oder t*.*
procedure nf_DeleteAllFiles(const aDir, aFiles: String);
var
  Dir      : String;
  SearchRec: TSearchRec;
begin
  Dir := IncludeTrailingBackslash(aDir);
  if FindFirst(Dir + aFiles, faAnyFile, SearchRec) = 0 then
  begin
    DeleteFile(Dir + SearchRec.Name);
    while FindNext(SearchRec) = 0 do
      DeleteFile(Dir + SearchRec.Name);
  end;
  FindClose(SearchRec);
end;


function nf_Directory(aPath: String; const aSearchRec: TSearchRec): Boolean;
begin
  Result := false;
  if (aSearchRec.Attr = faArchive)
  or (aSearchRec.Attr < 16) then
    exit;

  if (aSearchRec.Name = '.')
  or (aSearchRec.Name = '..') then
    exit;
  aPath := IncludeTrailingBackslash(aPath) + aSearchRec.Name;
  Result := DirectoryExists(aPath);
end;


function nf_GetFileDate(const aFullFileName: String): TDateTime;
var
  SearchRec: TSearchRec;
begin
  SearchRec := nf_GetFileInfo(aFullFileName);
  if SearchRec.Time = -1 then
    Result := 0
  else
    Result := FileDateToDateTime(SearchRec.Time);
end;

function nf_GetFileInfo(const aFullFileName: String) : TSearchRec;
begin
  FindFirst(aFullFileName, faAnyFile, Result);
  if Result.Name = '' then
  begin
    Result.Size := -1;
    Result.Time := -1;
    Result.Attr := -1;
    Result.ExcludeAttr := -1;
  end;
  FindClose(Result);
end;

function nf_ExtractResToFile(ResType, ResName, ResNewName: string): Boolean;
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, Resname, PChar(ResType));
  try
    Res.SavetoFile(ResNewName);
    Result := True;
  finally
    Res.Free;
  end;
end;

procedure nf_ShellExecute_And_Wait(aApplication: TApplication; aFileName: string);
var
  exInfo: TShellExecuteInfo;
  Ph: DWORD;
begin
  FillChar(exInfo, SizeOf(exInfo), 0);
  with exInfo do
  begin
    cbSize := SizeOf(exInfo);
    fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
    Wnd := GetActiveWindow();
    ExInfo.lpVerb := 'open';
    lpFile := PChar(aFileName);
    nShow := SW_SHOWNORMAL;
  end;
  if ShellExecuteEx(@exInfo) then
  begin
    Ph := exInfo.HProcess;
  end
  else
  begin
    ShowMessage(SysErrorMessage(GetLastError));
    Exit;
   end;
  while WaitForSingleObject(ExInfo.hProcess, 50) <> WAIT_OBJECT_0 do
    aApplication.ProcessMessages;
  CloseHandle(Ph);
end;

function nf_GetTempDir: String;
var
  Buffer: Array[0..MAX_PATH] of Char;
begin
  GetTempPath(SizeOf(Buffer) - 1, Buffer);
  Result := StrPas(Buffer);
end;



procedure nf_StrToClipboard(StrValue: string);
var
  hMem: THandle;
  pMem: PChar;
begin
  hMem := GlobalAlloc(GHND or GMEM_SHARE, Length(StrValue) + 1);
  if hMem <> 0 then
  begin
    pMem := GlobalLock(hMem);
    if pMem <> nil then
    begin
      StrPCopy(pMem, StrValue);
      GlobalUnlock(hMem);
      if OpenClipboard(0) then
      begin
        EmptyClipboard;
        SetClipboardData(CF_TEXT, hMem);
        CloseClipboard;
      end
      else
        GlobalFree(hMem);
    end
    else
      GlobalFree(hMem);
  end;
end;

function nf_GetStrFromClipboard: string;
begin
  if Clipboard.HasFormat(CF_TEXT) then
    Result := Clipboard.AsText
  else
    Result := '';
end;


function nf_GetComputerName: string;
var
  p: PChar;
  Size: DWord;
begin
  Size := MAX_COMPUTERNAME_LENGTH + 1;
  p := StrAlloc(Size);
  getComputerName(p, Size);
  Result := p;
  StrDispose(p);
end;


procedure nf_ShellExec(aPrgname : string; const aParam: string = '';
  const aDirectory: string = ''; const aWindowCommand: Word = SW_SHOWNORMAL);
begin
  ShellExecute(0, 'open', PChar(aPrgname), PChar(aParam), PChar(aDirectory), aWindowCommand);
end;



function nf_ChangeFileExt(aFile, aNewExt: string): string;
var
  OldExt: string;
begin
  OldExt := ExtractFileExt(aFile);
  Result := StringReplace(aFile, OldExt, aNewExt, []);
end;


function nf_GetShellFolder(CSIDL: integer): string;
// 46 = c:\users\public\documents (COMMON_DOCUMENTS)
// 26 = c:\users\benutzername\AppData\Roaming (APPDATA)
var
  pidl                   : PItemIdList;
  FolderPath             : string;
  SystemFolder           : Integer;
  Malloc                 : IMalloc;
begin
  Malloc := nil;
  FolderPath := '';
  SHGetMalloc(Malloc);
  if Malloc = nil then
  begin
    Result := FolderPath;
    Exit;
  end;
  try
    SystemFolder := CSIDL;
    if SUCCEEDED(SHGetSpecialFolderLocation(0, SystemFolder, pidl)) then
    begin
      SetLength(FolderPath, max_path);
      if SHGetPathFromIDList(pidl, PChar(FolderPath)) then
      begin
        SetLength(FolderPath, length(PChar(FolderPath)));
      end;
    end;
    Result := FolderPath;
  finally
    Malloc.Free(pidl);
  end;
end;


function nf_ProgramInTask(aValue: string): Boolean;
var
  p: TProcessEntry32;
  h: THandle;
begin
  Result := false;
  p.dwSize := SizeOf(p);
  h := CreateToolHelp32Snapshot(TH32CS_SnapProcess, 0);
  try
    if Process32First(h, p) then
      repeat
        if AnsiLowerCase(p.szExeFile) = AnsiLowerCase(aValue) then
          Result := true;
      until (not Process32Next(h, p)) or Result;
  finally
    CloseHandle(h);
  end;
end;

function nf_IsWow64: Boolean;
type
  TIsWow64Process = function( // Type of IsWow64Process API fn
    Handle: Windows.THandle; var Res: Windows.BOOL
  ): Windows.BOOL; stdcall;
var
  IsWow64Result: Windows.BOOL;      // Result from IsWow64Process
  IsWow64Process: TIsWow64Process;  // IsWow64Process fn reference
begin
  // Try to load required function from kernel32
  IsWow64Process := Windows.GetProcAddress(
    Windows.GetModuleHandle('kernel32'), 'IsWow64Process'
  );
  if Assigned(IsWow64Process) then
  begin
    // Function is implemented: call it
    if not IsWow64Process(
      Windows.GetCurrentProcess, IsWow64Result
    ) then
      raise SysUtils.Exception.Create('IsWow64: bad process handle');
    // Return result of function
    Result := IsWow64Result;
  end
  else
    // Function not implemented: can't be running on Wow64
    Result := False;
end;




end.
