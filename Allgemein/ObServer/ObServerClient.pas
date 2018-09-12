unit ObServerClient;

interface

uses
  ObBusinessClasses, ObServerUtils, Classes, SysUtils, Forms, Windows;

resourcestring
  RS_OBSERVERCLIENT_NOT_SUPPORTED =
    'Interface "IObServerClient" not supported in class "%s"!';

  RS_OBSERVERFRAME_NOT_SUPPORTED =
    'Interface "IObServerFrame" not supported in class "%s"!';

  RS_OBSERVERFRAME_UPDATE_ERROR =
    '"UpdateActions" failed in frame "%s"!';

type
{ IObServerFrame }

  IObServerFrame = interface
  ['{01AEE302-8FB2-4D8D-AAB3-5342245DE752}']
    procedure UpdateActions;
  end;

{ IObServerClient }

  IObServerClient = interface
  ['{189AE203-BADD-41AD-95F9-58F62F6C6DAB}']
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
  end;

{ TObServerClient }

  TObServerClient = packed record
    AClass: TObject;
    Types: TNotificationTypes;
    IncludeActions: TList;
    ExcludeActions: TList;
  end;
  PObServerClient = ^TObServerClient;

{ TObServerAction }

  TObServerAction = packed record
    AType: TNotificationType;
    Action: Integer;
  end;
  PObServerAction = ^TObServerAction;

{ TObServer }

  TObServer = class
  private
    FClients: TList;
    FFrames: TList;
    FLocks: TList;
    function FindClientClass(AClass: TObject): PObServerClient;
    function FindClientAction(AList: TList; AType: TNotificationType; Action: Integer; TrueIfEmpty: Boolean): Boolean;
    function FindClientLock(AType: TNotificationType; Action: Integer): Boolean;
    function FindClientFrame(AFrame: TScrollingWinControl): TScrollingWinControl;
    procedure ClearActionList(AList: TList; AType: Integer =  -1);
    procedure ClearLocks(AType: Integer = -1);
  public
    constructor Create;
    destructor Destroy; override;
    function RegisterNotifications(AClass: TObject; Types: TNotificationTypes): Boolean;
    function UnregisterNotifications(AClass: TObject): Boolean;
    function LockNotification(AType: TNotificationType; Actions: array of Integer; ClearBefore: Boolean = True): Boolean;
    function UnlockNotification(AType: TNotificationType; Actions: array of Integer): Boolean;
    function UnlockAllNotifications: Boolean;
    function FilterActions(AClass: TObject; AType: TNotificationType; Actions: array of Integer): Boolean;
    function IgnoreActions(AClass: TObject; AType: TNotificationType; Actions: array of Integer): Boolean;
    function Notify(AType: TNotificationType; Action: Integer = NTA_UNASSIGNED; Data: Integer = NTD_UNASSIGNED): Integer;
    function RegisterFrame(AFrame: TScrollingWinControl): Boolean;
    function UnregisterFrame(AFrame: TScrollingWinControl): Boolean;
    function UpdateFrames: Integer;
  end;

{ TObServer_Network }

  TObServer_Network = class(TObServer)
  protected
    FAction: Integer;
    FClient: TClientInfo;
    FClients: TList;
    FSender: string;
    FType: TNotificationType;
  public
    constructor Create;
    destructor Destroy; override;
    function Logon(UserName: string = ''; AType: TNotificationType = High(TNotificationType); Action: Integer = NTA_UNASSIGNED): Boolean; virtual;
    function Logoff: Boolean; virtual;
    function UsersCount: Integer;
    function Users(Index: Integer): PClientInfo;
    function IPCNotify(AType: TNotificationType; Action: Integer = NTA_UNASSIGNED; Data: TComponent = nil): Integer; virtual; abstract;
    property Sender: string read FSender;
  end;

implementation

uses
  TypInfo, Controls;

{ TObServer }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    MH
  Date:      09-Okt-2006
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

constructor TObServer.Create;
begin
  { create lists }
  FClients := TList.Create;
  FFrames := TList.Create;
  FLocks := TList.Create;
end;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    mh
  Date:      02-Sep-2004
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

destructor TObServer.Destroy;
var
  i: Integer;
  ObServerClient: PObServerClient;
begin
  { any clients assigned? }
  if Assigned(FClients) then
  begin
    { iterate through all clients }
    for i := 0 to FClients.Count - 1 do
    begin
      { get client }
      ObServerClient := PObServerClient(FClients[i]);

      { clear include-actions }
      ClearActionList(ObServerClient.IncludeActions);
      ObServerClient.IncludeActions.Free;

      { clear exclude-actions }
      ClearActionList(ObServerClient.ExcludeActions);
      ObServerClient.ExcludeActions.Free;

      { dispose from list }
      Dispose(ObServerClient);
      //ObServerClient := nil;
    end;

    { clear registered locks }
    ClearLocks;

    { clear lists }
    FClients.Free;
    FFrames.Free;
    FLocks.Free;
  end;

  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: ClearActionList
  Author:    mh
  Date:      23-Dez-2004
  Arguments: AList: TList; AType: Integer = -1
  Result:    None
-----------------------------------------------------------------------------}

procedure TObServer.ClearActionList(AList: TList; AType: Integer = -1);
var
  i: Integer;
  ObServerAction: PObServerAction;
begin
  { iterate through all actions }
  for i := AList.Count - 1 downto 0 do
  begin
    { get action }
    ObServerAction := PObServerAction(AList[i]);

    { type matches? }
    if not((AType = -1) or (ObServerAction.AType = TNotificationType(AType))) then
      Continue;

    { disose from list }
    Dispose(ObServerAction);
    AList.Delete(i);
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: ClearLocks
  Author:    mh
  Date:      07-Dez-2004
  Arguments: AType: Integer = -1
  Result:    None
-----------------------------------------------------------------------------}

procedure TObServer.ClearLocks(AType: Integer = -1);
var
  i: Integer;
  ObServerAction: PObServerAction;
begin
  { iterate through all locks }
  for i := FLocks.Count - 1 downto 0 do
  begin
    { get action }
    ObServerAction := PObServerAction(FLocks[i]);

    { type matches? }
    if not((AType = -1) or (ObServerAction.AType = TNotificationType(AType))) then
      Continue;

    { dispose from list }
    Dispose(ObServerAction);
    FLocks.Delete(i);
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: FindClientClass
  Author:    mh
  Date:      25-Nov-2004
  Arguments: AClass: TObject
  Result:    PObServerClient
-----------------------------------------------------------------------------}

function TObServer.FindClientClass(AClass: TObject): PObServerClient;
var
  i: Integer;
begin
  { set default result }
  Result := nil;

  { iterate through all clients }
  for i := 0 to FClients.Count - 1 do
  begin
    { class matches? }
    if PObServerClient(FClients[i]).AClass = AClass then
    begin
      { return client }
      Result := PObServerClient(FClients[i]);
      Break;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: FindClientAction
  Author:    mh
  Date:      07-Dez-2004
  Arguments: AList: TList; AType: TNotificationType; Action: Integer;
    TrueIfEmpty: Boolean
  Result:    Boolean
-----------------------------------------------------------------------------}

function TObServer.FindClientAction(AList: TList; AType: TNotificationType;
  Action: Integer; TrueIfEmpty: Boolean): Boolean;
var
  i, x: Integer;
  ObServerAction: PObServerAction;
begin
  { set default result }
  Result := False;
  x := 0;

  { iterate through all actions }
  for i := 0 to AList.Count - 1 do
  begin
    { get action }
    ObServerAction := PObServerAction(AList[i]);

    { type matches? }
    if ObServerAction.AType = AType then
    begin
      { return new result }
      Result := Result or (ObServerAction.Action = Action);
      Inc(x);
    end;
  end;

  { any result returned? }
  if not(Result) and (TrueIfEmpty) and (x = 0) then
    Result := True;
end;

{-----------------------------------------------------------------------------
  Procedure: FindClientLock
  Author:    mh
  Date:      07-Dez-2004
  Arguments: AType: TNotificationType; Action: Integer
  Result:    Boolean
-----------------------------------------------------------------------------}

function TObServer.FindClientLock(AType: TNotificationType;
  Action: Integer): Boolean;
var
  i: Integer;
  ObServerAction: PObServerAction;
begin
  { set default result }
  Result := False;

  { iterate through all locks }
  for i := 0 to FLocks.Count - 1 do
  begin
    { get action }
    ObServerAction := PObServerAction(FLocks[i]);

    { type matches? }
    if (ObServerAction.AType = AType) and ((ObServerAction.Action = -1) or
       (ObServerAction.Action = Action)) then
    begin
      { set result }
      Result := True;
      Break;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: RegisterNotifications
  Author:    mh
  Date:      02-Sep-2004
  Arguments: AClass: TObject; Types: TNotificationTypes
  Result:    Boolean
-----------------------------------------------------------------------------}

function TObServer.RegisterNotifications(AClass: TObject; Types: TNotificationTypes): Boolean;
var
  ObServerClient: PObServerClient;
begin
  { set default result }
  Result := False;
  try
    { passed class supports needed interface? }
    if not(Supports(AClass, IObServerClient)) then
      raise EObServerError.CreateFmt(RS_OBSERVERCLIENT_NOT_SUPPORTED, [AClass.ClassName]);

    { find client class }
    ObServerClient := FindClientClass(AClass);
    if ObServerClient = nil then
    begin
      { create new client.. }
      New(ObServerClient);
      ObServerClient.AClass := AClass;
      ObServerClient.IncludeActions := TList.Create;
      ObServerClient.ExcludeActions := TList.Create;

      { ...and add to list }
      FClients.Add(ObServerClient);
    end;

    { keep passed types }
    ObServerClient.Types := Types;

    { set result }
    Result := True;
  except
    { catch all errors }
    on e: Exception do
      MessageBox(0, PChar(e.Message), 'RegisterNotifications', MB_ICONERROR);
  end;    // try/except
end;

{-----------------------------------------------------------------------------
  Procedure: UnregisterNotifications
  Author:    MH
  Date:      10-Okt-2006
  Arguments: AClass: TObject
  Result:    Boolean
-----------------------------------------------------------------------------}

function TObServer.UnregisterNotifications(AClass: TObject): Boolean;
var
  ObServerClient: PObServerClient;
begin
  { set default result }
  Result := False;
  try
    { passed class supports needed interface? }
    if not(Supports(AClass, IObServerClient)) then
      raise EObServerError.CreateFmt(RS_OBSERVERCLIENT_NOT_SUPPORTED, [AClass.ClassName]);

    { try to find clientclass }
    ObServerClient := FindClientClass(AClass);
    if ObServerClient = nil then
      raise Exception.CreateFmt('Class "%s" not registered!', [AClass.ClassName]);

    { delete from client list }
    FClients.Delete(FClients.IndexOf(ObServerClient));
    ClearActionList(ObServerClient.IncludeActions);
    ObServerClient.IncludeActions.Free;
    ClearActionList(ObServerClient.ExcludeActions);
    ObServerClient.ExcludeActions.Free;
    Dispose(ObServerClient);
    //ObServerClient := nil;

    { set result }
    Result := True;
  except
    { catch all errors }
    on e: Exception do
      MessageBox(0, PChar(e.Message), 'UnregisterNotifications', MB_ICONERROR);
  end;    // try/except
end;

{-----------------------------------------------------------------------------
  Procedure: LockNotification
  Author:    mh
  Date:      07-Dez-2004
  Arguments: AType: TNotificationType; Actions: array of Integer;
    ClearBefore: Boolean = True
  Result:    Boolean
-----------------------------------------------------------------------------}

function TObServer.LockNotification(AType: TNotificationType;
  Actions: array of Integer; ClearBefore: Boolean = True): Boolean;
var
  i: Integer;
  ObServerAction: PObServerAction;
begin
  { set default result }
  Result := True;

  { clear locks before? }
  if (ClearBefore) or (High(Actions) = -1) then
    ClearLocks(Integer(AType));

  { is highest action? }
  if High(Actions) = -1 then
  begin
    New(ObServerAction);
    ObServerAction.AType := AType;
    ObServerAction.Action := -1;
    FLocks.Add(ObServerAction);
    Exit;
  end;

  { iterate through all passed actions }
  for i := Low(Actions) to High(Actions) do
  begin
    { try to find clientlock }
    if FindClientLock(AType, Actions[i]) then
    begin
      Result := False;
      Continue;
    end;

    { o/w, create new action... }
    New(ObServerAction);
    ObServerAction.AType := AType;
    ObServerAction.Action := Actions[i];

    { ...and add to list }
    FLocks.Add(ObServerAction);
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: UnlockNotification
  Author:    mh
  Date:      07-Dez-2004
  Arguments: AType: TNotificationType; Actions: array of Integer
  Result:    Boolean
-----------------------------------------------------------------------------}

function TObServer.UnlockNotification(AType: TNotificationType;
  Actions: array of Integer): Boolean;
var
  i, j: Integer;
  ObServerAction: PObServerAction;
  CanDelete: Boolean;
begin
  { set default result }
  Result := True;

  { iterate through all locks }
  for i := FLocks.Count - 1 downto 0 do
  begin
    { get action }
    ObServerAction := PObServerAction(FLocks[i]);

    { type matches? }
    if not(ObServerAction.AType = AType) then
      Continue;

    { can delete? }
    CanDelete := False;
    if High(Actions) = -1 then
      CanDelete := True
    else
    for j := Low(Actions) to High(Actions) do
      if ObServerAction.Action = Actions[j] then
      begin
        CanDelete := True;
        Break;
      end;
    if not(CanDelete) then
      Continue;
    Dispose(ObServerAction);
    FLocks.Delete(i);
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: UnlockAllNotifications
  Author:    mh
  Date:      07-Dez-2004
  Arguments: None
  Result:    Boolean
-----------------------------------------------------------------------------}

function TObServer.UnlockAllNotifications: Boolean;
begin
  { clear all locks }
  ClearLocks;

  { set result }
  Result := True;
end;

{-----------------------------------------------------------------------------
  Procedure: FilterActions
  Author:    mh
  Date:      07-Dez-2004
  Arguments: AClass: TObject; AType: TNotificationType;
    Actions: array of Integer
  Result:    Boolean
-----------------------------------------------------------------------------}

function TObServer.FilterActions(AClass: TObject;
  AType: TNotificationType; Actions: array of Integer): Boolean;
var
  i: Integer;
  ObServerClient: PObServerClient;
  ObServerAction: PObServerAction;
begin
  { set default result }
  Result := False;
  try
    { try to fiend clientclass }
    ObServerClient := FindClientClass(AClass);
    if ObServerClient = nil then
      Exit;

    { clear action list }
    ClearActionList(ObServerClient.IncludeActions, Integer(AType));

    { iterate through all passed actions }
    for i := Low(Actions) to High(Actions) do
    begin
      { create new action }
      New(ObServerAction);
      ObServerAction.AType := AType;
      ObServerAction.Action := Actions[i];
      ObServerClient.IncludeActions.Add(ObServerAction);
    end;

    { set result }
    Result := True;
  except
    { catch all errors }
    on e: Exception do
      MessageBox(0, PChar(e.Message), 'FilterActions', MB_ICONERROR);
  end;    // try/except
end;

{-----------------------------------------------------------------------------
  Procedure: IgnoreActions
  Author:    mh
  Date:      07-Dez-2004
  Arguments: AClass: TObject; AType: TNotificationType;
    Actions: array of Integer
  Result:    Boolean
-----------------------------------------------------------------------------}

function TObServer.IgnoreActions(AClass: TObject;
  AType: TNotificationType; Actions: array of Integer): Boolean;
var
  i: Integer;
  ObServerClient: PObServerClient;
  ObServerAction: PObServerAction;
begin
  { set default result }
  Result := False;
  try
    { try to find clientclass }
    ObServerClient := FindClientClass(AClass);
    if ObServerClient = nil then
      Exit;

    { clear action list }
    ClearActionList(ObServerClient.ExcludeActions, Integer(AType));

    { iterate through all passed actions }
    for i := Low(Actions) to High(Actions) do
    begin
      { create new action }
      New(ObServerAction);
      ObServerAction.AType := AType;
      ObServerAction.Action := Actions[i];
      ObServerClient.ExcludeActions.Add(ObServerAction);
    end;

    { set result }
    Result := True;
  except
    { catch all exceptions }
    on e: Exception do
      MessageBox(0, PChar(e.Message), 'IgnoreActions', MB_ICONERROR);
  end;    // try/except
end;

{-----------------------------------------------------------------------------
  Procedure: Notify
  Author:    mh
  Date:      24-Apr-2006
  Arguments: AType: TNotificationType; Action: Integer = NTA_UNASSIGNED;
    Data: Integer = NTD_UNASSIGNED
  Result:    Integer
-----------------------------------------------------------------------------}

function TObServer.Notify(AType: TNotificationType; Action: Integer = NTA_UNASSIGNED;
  Data: Integer = NTD_UNASSIGNED): Integer;
var
  i: Integer;
  ClientIntf: IObServerClient;
  ObServerClient: PObServerClient;
begin
  { set default result }
  Result := 0;

  { protect block }
  try
    { protect block }
    try
      { iterate through all clients }
      for i := 0 to FClients.Count - 1 do
      begin
        { get client }
        ObServerClient := PObServerClient(FClients[i]);

        { type matches? action matches? lock matches? }
        if (AType in ObServerClient.Types) and not(FindClientLock(AType, Action)) and
           (FindClientAction(ObServerClient.IncludeActions, AType, Action, True)) and not
           (FindClientAction(ObServerClient.ExcludeActions, AType, Action, False)) then
        begin
          try
            { get class interface }
            ObServerClient.AClass.GetInterface(IObServerClient, ClientIntf);

            { call observer-method }
            if ClientIntf <> nil then
              ClientIntf.ObServerNotification(AType, Action, Data);
          except
          end;

          { increase result }
          Inc(Result);
        end;
      end;
    except
      { catch all errors }
      on e: Exception do
      begin
        Result := -1;
        //raise;
      end;
    end;    // try/except
  finally // wrap up
    //
  end;    // try/finally
end;

{-----------------------------------------------------------------------------
  Procedure: FindClientFrame
  Author:    mh
  Date:      25-Nov-2004
  Arguments: AFrame: TScrollingWinControl
  Result:    TScrollingWinControl
-----------------------------------------------------------------------------}

function TObServer.FindClientFrame(AFrame: TScrollingWinControl): TScrollingWinControl;
var
  i: Integer;
begin
  { set default result }
  Result := nil;

  { iterate through all frames }
  for i := 0 to FFrames.Count - 1 do
  begin
    { frame matches? }
    if FFrames[i] <> AFrame then
      Continue;

    { return frame }
    Result := FFrames[i];
    Break;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: RegisterFrame
  Author:    mh
  Date:      25-Nov-2004
  Arguments: AFrame: TScrollingWinControl
  Result:    Boolean
-----------------------------------------------------------------------------}

function TObServer.RegisterFrame(AFrame: TScrollingWinControl): Boolean;
begin
  { set result }
  Result := False;
  try
    { passed frame supports needed interface? }
    if not(Supports(AFrame, IObServerFrame)) then
      raise EObServerError.CreateFmt(RS_OBSERVERFRAME_NOT_SUPPORTED, [AFrame.Name]);

    { try to find clientframe }
    if FindClientFrame(AFrame) <> nil then
      Exit;

    { add to list }
    FFrames.Add(AFrame);

    { set result }
    Result := True;
  except
    { catch all errors }
    on e: Exception do
      MessageBox(0, PChar(e.Message), 'RegisterFrame', MB_ICONERROR);
  end;    // try/except
end;

{-----------------------------------------------------------------------------
  Procedure: UnregisterFrame
  Author:    MH
  Date:      23-Feb-2007
  Arguments: AFrame: TScrollingWinControl
  Result:    Boolean
-----------------------------------------------------------------------------}

function TObServer.UnregisterFrame(AFrame: TScrollingWinControl): Boolean;
begin
  { set default result }
  Result := False;
  try
    { passed class supports needed interface? }
    if not(Supports(AFrame, IObServerFrame)) then
      raise EObServerError.CreateFmt(RS_OBSERVERFRAME_NOT_SUPPORTED, [AFrame.Name]);

    { try to find clientframe }
    if FindClientFrame(AFrame) = nil then
      Exit;

    { delete from list }
    FFrames.Delete(FFrames.IndexOf(AFrame));

    { set result }
    Result := True;
  except
    { catch all errors }
    on e: Exception do
      MessageBox(0, PChar(e.Message), 'UnregisterFrame', MB_ICONERROR);
  end;    // try/except
end;

{-----------------------------------------------------------------------------
  Procedure: UpdateFrames
  Author:    mh
  Date:      25-Nov-2004
  Arguments: None
  Result:    Integer
-----------------------------------------------------------------------------}

function TObServer.UpdateFrames: Integer;
var
  i: Integer;
  ObServerFrame: IObServerFrame;
begin
  { set default result }
  Result := 0;

  { iterate though all frames }
  for i := 0 to FFrames.Count - 1 do
  try
    { passed class supports needed interface? }
    if not(TScrollingWinControl(FFrames[i]).GetInterface(IObServerFrame, ObServerFrame)) then
      Continue;

    { update frame actions }
    ObServerFrame.UpdateActions;

    { increase result }
    Inc(Result);
  except
    { catch all errors }
    MessageBox(0, PChar(Format(RS_OBSERVERFRAME_UPDATE_ERROR, [TScrollingWinControl(FFrames[i]).Name])), 'UpdateFrame', MB_ICONERROR);
  end;    // try/except
end;

{ TObServer_Network }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    MH
  Date:      01-Dez-2008
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

constructor TObServer_Network.Create;
begin
  inherited Create;

  { initialize variables }
  FillChar(FClient, SizeOf(FClient), 0);
  FClient.ComputerName := AnsiString(ComputerName);
  FClient.UserName := AnsiString(UserName);
  FClient.Messages := 0;

  FAction := NTA_UNASSIGNED;
  FType := High(TNotificationType);
  FSender := '';

  { create client list }
  FClients := TList.Create;
end;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    MH
  Date:      01-Dez-2008
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

destructor TObServer_Network.Destroy;
var
  i: Integer;
begin
  { free client list }
  for i := 0 to FClients.Count - 1 do
    Dispose(PClientInfo(FClients[i]));
  FClients.Free;

  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: Logon
  Author:    MH
  Date:      01-Dez-2008
  Arguments: UserName: string; AType: TNotificationType; Action: Integer
  Result:    Boolean
-----------------------------------------------------------------------------}

function TObServer_Network.Logon(UserName: string; AType: TNotificationType; Action: Integer): Boolean;
begin
  { set default result }
  Result := False;
  try
    { username passed? }
    if UserName <> '' then
      FClient.UserName := AnsiString(UserName);

    { keep passed action & type }
    FAction := Action;
    FType := AType;

    { set result }
    Result := True;
  except
    { catch all errors }
  end;    // try/except
end;

{-----------------------------------------------------------------------------
  Procedure: Logoff
  Author:    MH
  Date:      01-Dez-2008
  Arguments: None
  Result:    Boolean
-----------------------------------------------------------------------------}

function TObServer_Network.Logoff: Boolean;
begin
  Result := True;
end;

{-----------------------------------------------------------------------------
  Procedure: UsersCount
  Author:    MH
  Date:      01-Dez-2008
  Arguments: None
  Result:    Integer
-----------------------------------------------------------------------------}

function TObServer_Network.UsersCount: Integer;
begin
  Result := FClients.Count;
end;

{-----------------------------------------------------------------------------
  Procedure: Users
  Author:    MH
  Date:      01-Dez-2008
  Arguments: Index: Integer
  Result:    PClientInfo
-----------------------------------------------------------------------------}

function TObServer_Network.Users(Index: Integer): PClientInfo;
begin
  Result := nil;
  if Index > Pred(UsersCount) then
    Exit;
  Result := PClientInfo(FClients[Index]);
end;

end.

