unit nf_RegIni;

interface

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}


uses
  IniFiles, SysUtils, Types, Registry, Variants, Windows;

type
  TevRootKey = (HKEY_CLASSES_ROOT_, HKEY_CURRENT_USER_, HKEY_LOCAL_MACHINE_,
                HKEY_USERS_, HKEY_PERFORMANCE_DATA_, HKEY_CURRENT_CONFIG_,
                HKEY_DYN_DATA_);


function  nf_ReadIni(const aFullFileName, aSection, aKey: WideString; aDefault: WideString): WideString;
function  nf_ReadIniToInt(const aFullFileName, aSection, aKey: WideString; aDefault: WideString): Integer;
function  nf_ReadIniToDir(const aFullFileName, aSection, aKey: WideString; aDefault: WideString): WideString;
procedure nf_WriteIni(const aFullFileName, aSection, aKey: WideString; aValue: WideString);
procedure nf_WriteRegistry(const aRootKey: TevRootKey; const aRegPfad, aSchluessel: String;
  const aValue: Variant; const aCanCreate: Boolean = true);
procedure nf_DeleteIniSection(const aFullFileName, aSectionName: string);
function nf_RootKeyToDWord(const aevRootKey: TevRootKey): DWord;
function nf_ReadRegistry(const aRootKey: TevRootKey; const aRegPfad, aSchluessel: String;
  aDefault: Variant; const aCanCreate: Boolean = false): Variant;


implementation


function nf_ReadIni(const aFullFileName, aSection, aKey: WideString; aDefault: WideString): WideString;
var
  INI: TIniFile;
begin
  INI := TIniFile.Create(aFullFileName);
  try
    Result := INI.ReadString(aSection, aKey, aDefault);
  finally
    FreeAndNil(INI);
  end;
end;

function nf_ReadIniToInt(const aFullFileName, aSection, aKey: WideString; aDefault: WideString): Integer;
var
  INI: TIniFile;
  s  : string;
begin
  INI := TIniFile.Create(aFullFileName);
  try
    s := INI.ReadString(aSection, aKey, aDefault);
    if not TryStrToInt(s, Result) then
      Result := StrToInt(aDefault);
  finally
    FreeAndNil(INI);
  end;
end;

function nf_ReadIniToDir(const aFullFileName, aSection, aKey: WideString; aDefault: WideString): WideString;
var
  INI: TIniFile;
begin
  INI := TIniFile.Create(aFullFileName);
  try
    Result := INI.ReadString(aSection, aKey, aDefault);
    if Result = '' then
      exit;
    Result := IncludeTrailingBackslash(Result);
  finally
    FreeAndNil(INI);
  end;
end;




procedure nf_WriteIni(const aFullFileName, aSection, aKey: WideString; aValue: WideString);
var
  INI: TIniFile;
begin
  INI := TIniFile.Create(aFullFileName);
  try
    INI.WriteString(aSection, aKey, aValue);
  finally
    FreeAndNil(INI);
  end;
end;

procedure nf_DeleteIniSection(const aFullFileName, aSectionName: string);
var
  INI: TIniFile;
begin
  INI := TIniFile.Create(aFullFileName);
  try
    INI.EraseSection(aSectionName);
  finally
    FreeAndNil(INI);
  end;
end;


procedure nf_WriteRegistry(const aRootKey: TevRootKey; const aRegPfad, aSchluessel: String;
  const aValue: Variant; const aCanCreate: Boolean = true);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Try
    Reg.RootKey := nf_RootKeyToDWord(aRootKey);
    if not Reg.OpenKey(aRegPfad, aCanCreate) then
      exit;
    Case VarType(aValue) of
      varOleStr,
      varString:   Reg.WriteString(aSchluessel, aValue);
      varInteger:  Reg.WriteInteger(aSchluessel, aValue);
      varDate:     Reg.WriteDate(aSchluessel, aValue);
      varBoolean:  Reg.WriteBool(aSchluessel, aValue);
      varCurrency,
      varDouble:   Reg.WriteFloat(aSchluessel, aValue);
    end;
    Reg.CloseKey;
  finally
    FreeAndNil(Reg);
  end;
end;


function nf_RootKeyToDWord(const aevRootKey: TevRootKey): DWord;
begin
  Result := 0;
  if aevRootKey = HKEY_CLASSES_ROOT_ then
    Result := Windows.HKEY_CLASSES_ROOT;

  if aevRootKey = HKEY_CURRENT_USER_ then
    Result := Windows.HKEY_CURRENT_USER;

  if aevRootKey = HKEY_LOCAL_MACHINE_ then
    Result := Windows.HKEY_LOCAL_MACHINE;

  if aevRootKey = HKEY_USERS_ then
    Result := Windows.HKEY_USERS;

  if aevRootKey = HKEY_PERFORMANCE_DATA_ then
    Result := Windows.HKEY_PERFORMANCE_DATA;

  if aevRootKey = HKEY_CURRENT_CONFIG_ then
    Result := Windows.HKEY_CURRENT_CONFIG;

  if aevRootKey = HKEY_DYN_DATA_ then
    Result := Windows.HKEY_DYN_DATA;

end;


function nf_ReadRegistry(const aRootKey: TevRootKey; const aRegPfad, aSchluessel: String;
  aDefault: Variant; const aCanCreate: Boolean = false): Variant;
var
  Reg: TRegistry;
  Result_OpenKey: Boolean;
begin
  Reg := TRegistry.Create(KEY_READ);
  Try
    Reg.RootKey := nf_RootKeyToDWord(aRootKey);

    if aCanCreate then
      Result_OpenKey := Reg.OpenKey(aRegPfad, aCanCreate)
    else
      Result_OpenKey := Reg.OpenKeyReadOnly(aRegPfad);

    if not Result_OpenKey then
    begin
      Result := aDefault;
      exit;
    end;

    Case VarType(aDefault) of
      varOleStr,
      varString:
      begin
        try
          Result := Reg.ReadString(aSchluessel);
        except
          Result := aDefault;
        end;
        if Result = '' then
          Result := aDefault;
      end;
      varInteger:
      begin
        try
          Result := Reg.ReadInteger(aSchluessel);
        except
          Result := aDefault;
        end;
      end;
      varDate:
      begin
        try
          Result := Reg.ReadDate(aSchluessel);
        except
          Result := aDefault;
        end;
      end;
      varBoolean:
      begin
        try
          Result := Reg.ReadBool(aSchluessel);
        except
          Result := aDefault;
        end;
      end;
      varCurrency,
      varDouble:
      begin
        try
          Result := Reg.ReadFloat(aSchluessel);
        except
          Result := aDefault;
        end;
      end;
    end;
    Reg.CloseKey;
  finally
    FreeAndNil(Reg);
  end;
end;


end.
