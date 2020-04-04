{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

Code template generated with SynGen.
The original code is: D:\Delphi\XE2\Test\SqlEditor2\source\tbSqlHighlighterBase.pas, released 2015-08-06.
Description: Syntax Parser/Highlighter
The initial author of this file is tbachmann.
Copyright (c) 2015, all rights reserved.

Contributors to the SynEdit and mwEdit projects are listed in the
Contributors.txt file.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

$Id: $

You may retrieve the latest version of this file at the SynEdit home page,
located at http://SynEdit.SourceForge.net

-------------------------------------------------------------------------------}

{$IFNDEF QTBSQLHIGHLIGHTERBASE}
unit tbSqlHighlighterBase;
{$ENDIF}

{$I SynEdit.inc}

interface

uses
{$IFDEF SYN_CLX}
  QGraphics,
  QSynEditTypes,
  QSynEditHighlighter,
  QSynUnicode,
{$ELSE}
  Graphics,
  SynEditTypes,
  SynEditHighlighter,
  SynUnicode,
{$ENDIF}
  SysUtils,
  Classes;

type
  TtkTokenKind = (
    tkComment,
    tkIdentifier,
    tkKey,
    tkNull,
    tkNumber,
    tkSpace,
    tkString,
    tkSymbol,
    tkTablename,
    tkUnknown);

  TRangeState = (rsUnKnown, rsBraceComment, rsCStyleComment, rsComment1, rsString, rsString2);

  TProcTableProc = procedure of object;

  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  TIdentFuncTableFunc = function (Index: Integer): TtkTokenKind of object;

type
  TtbSqlHighlighterBase = class(TSynCustomHighlighter)
  private
    fRange: TRangeState;
    fTokenID: TtkTokenKind;
    fIdentFuncTable: array[0..2856] of TIdentFuncTableFunc;
    fCommentAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fStringAttri: TSynHighlighterAttributes;
    fSymbolAttri: TSynHighlighterAttributes;
    fTablenameAttri: TSynHighlighterAttributes;
    function FuncAbsolute(Index: Integer): TtkTokenKind;
    function FuncAction(Index: Integer): TtkTokenKind;
    function FuncActive(Index: Integer): TtkTokenKind;
    function FuncActor(Index: Integer): TtkTokenKind;
    function FuncAdd(Index: Integer): TtkTokenKind;
    function FuncAfter(Index: Integer): TtkTokenKind;
    function FuncAlias(Index: Integer): TtkTokenKind;
    function FuncAll(Index: Integer): TtkTokenKind;
    function FuncAllocate(Index: Integer): TtkTokenKind;
    function FuncAlter(Index: Integer): TtkTokenKind;
    function FuncAnd(Index: Integer): TtkTokenKind;
    function FuncAny(Index: Integer): TtkTokenKind;
    function FuncAre(Index: Integer): TtkTokenKind;
    function FuncAs(Index: Integer): TtkTokenKind;
    function FuncAsc(Index: Integer): TtkTokenKind;
    function FuncAscending(Index: Integer): TtkTokenKind;
    function FuncAssertion(Index: Integer): TtkTokenKind;
    function FuncAsync(Index: Integer): TtkTokenKind;
    function FuncAt(Index: Integer): TtkTokenKind;
    function FuncAttributes(Index: Integer): TtkTokenKind;
    function FuncAuto(Index: Integer): TtkTokenKind;
    function FuncBase95name(Index: Integer): TtkTokenKind;
    function FuncBefore(Index: Integer): TtkTokenKind;
    function FuncBegin(Index: Integer): TtkTokenKind;
    function FuncBetween(Index: Integer): TtkTokenKind;
    function FuncBit(Index: Integer): TtkTokenKind;
    function FuncBit95length(Index: Integer): TtkTokenKind;
    function FuncBoolean(Index: Integer): TtkTokenKind;
    function FuncBoth(Index: Integer): TtkTokenKind;
    function FuncBreadth(Index: Integer): TtkTokenKind;
    function FuncBy(Index: Integer): TtkTokenKind;
    function FuncCache(Index: Integer): TtkTokenKind;
    function FuncCall(Index: Integer): TtkTokenKind;
    function FuncCascade(Index: Integer): TtkTokenKind;
    function FuncCascaded(Index: Integer): TtkTokenKind;
    function FuncCase(Index: Integer): TtkTokenKind;
    function FuncCast(Index: Integer): TtkTokenKind;
    function FuncCatalog(Index: Integer): TtkTokenKind;
    function FuncChar95length(Index: Integer): TtkTokenKind;
    function FuncCharacter95length(Index: Integer): TtkTokenKind;
    function FuncCheck(Index: Integer): TtkTokenKind;
    function FuncCoalesce(Index: Integer): TtkTokenKind;
    function FuncCollate(Index: Integer): TtkTokenKind;
    function FuncCollation(Index: Integer): TtkTokenKind;
    function FuncColumn(Index: Integer): TtkTokenKind;
    function FuncCommit(Index: Integer): TtkTokenKind;
    function FuncCommitted(Index: Integer): TtkTokenKind;
    function FuncCompletion(Index: Integer): TtkTokenKind;
    function FuncComputed(Index: Integer): TtkTokenKind;
    function FuncConditional(Index: Integer): TtkTokenKind;
    function FuncConnect(Index: Integer): TtkTokenKind;
    function FuncConnection(Index: Integer): TtkTokenKind;
    function FuncConstraint(Index: Integer): TtkTokenKind;
    function FuncConstraints(Index: Integer): TtkTokenKind;
    function FuncContaining(Index: Integer): TtkTokenKind;
    function FuncConvert(Index: Integer): TtkTokenKind;
    function FuncCorresponding(Index: Integer): TtkTokenKind;
    function FuncCount(Index: Integer): TtkTokenKind;
    function FuncCreate(Index: Integer): TtkTokenKind;
    function FuncCross(Index: Integer): TtkTokenKind;
    function FuncCurrent(Index: Integer): TtkTokenKind;
    function FuncCurrent95date(Index: Integer): TtkTokenKind;
    function FuncCurrent95path(Index: Integer): TtkTokenKind;
    function FuncCurrent95time(Index: Integer): TtkTokenKind;
    function FuncCurrent95timestamp(Index: Integer): TtkTokenKind;
    function FuncCurrent95user(Index: Integer): TtkTokenKind;
    function FuncCursor(Index: Integer): TtkTokenKind;
    function FuncCycle(Index: Integer): TtkTokenKind;
    function FuncData(Index: Integer): TtkTokenKind;
    function FuncDatabase(Index: Integer): TtkTokenKind;
    function FuncDate(Index: Integer): TtkTokenKind;
    function FuncDay(Index: Integer): TtkTokenKind;
    function FuncDeallocate(Index: Integer): TtkTokenKind;
    function FuncDebug(Index: Integer): TtkTokenKind;
    function FuncDeclare(Index: Integer): TtkTokenKind;
    function FuncDefault(Index: Integer): TtkTokenKind;
    function FuncDeferrable(Index: Integer): TtkTokenKind;
    function FuncDeferred(Index: Integer): TtkTokenKind;
    function FuncDelete(Index: Integer): TtkTokenKind;
    function FuncDepth(Index: Integer): TtkTokenKind;
    function FuncDesc(Index: Integer): TtkTokenKind;
    function FuncDescending(Index: Integer): TtkTokenKind;
    function FuncDescribe(Index: Integer): TtkTokenKind;
    function FuncDescriptor(Index: Integer): TtkTokenKind;
    function FuncDestroy(Index: Integer): TtkTokenKind;
    function FuncDiagnostics(Index: Integer): TtkTokenKind;
    function FuncDictionary(Index: Integer): TtkTokenKind;
    function FuncDisconnect(Index: Integer): TtkTokenKind;
    function FuncDistinct(Index: Integer): TtkTokenKind;
    function FuncDo(Index: Integer): TtkTokenKind;
    function FuncDomain(Index: Integer): TtkTokenKind;
    function FuncDrop(Index: Integer): TtkTokenKind;
    function FuncEach(Index: Integer): TtkTokenKind;
    function FuncElement(Index: Integer): TtkTokenKind;
    function FuncElse(Index: Integer): TtkTokenKind;
    function FuncElseif(Index: Integer): TtkTokenKind;
    function FuncEnd(Index: Integer): TtkTokenKind;
    function FuncEnd45exec(Index: Integer): TtkTokenKind;
    function FuncEntry95point(Index: Integer): TtkTokenKind;
    function FuncEquals(Index: Integer): TtkTokenKind;
    function FuncEscape(Index: Integer): TtkTokenKind;
    function FuncExcept(Index: Integer): TtkTokenKind;
    function FuncException(Index: Integer): TtkTokenKind;
    function FuncExecute(Index: Integer): TtkTokenKind;
    function FuncExists(Index: Integer): TtkTokenKind;
    function FuncExit(Index: Integer): TtkTokenKind;
    function FuncExternal(Index: Integer): TtkTokenKind;
    function FuncExtract(Index: Integer): TtkTokenKind;
    function FuncFactor(Index: Integer): TtkTokenKind;
    function FuncFalse(Index: Integer): TtkTokenKind;
    function FuncFilter(Index: Integer): TtkTokenKind;
    function FuncFirst(Index: Integer): TtkTokenKind;
    function FuncFor(Index: Integer): TtkTokenKind;
    function FuncForeign(Index: Integer): TtkTokenKind;
    function FuncFrom(Index: Integer): TtkTokenKind;
    function FuncFull(Index: Integer): TtkTokenKind;
    function FuncFunction(Index: Integer): TtkTokenKind;
    function FuncGeneral(Index: Integer): TtkTokenKind;
    function FuncGenerator(Index: Integer): TtkTokenKind;
    function FuncGet(Index: Integer): TtkTokenKind;
    function FuncGlobal(Index: Integer): TtkTokenKind;
    function FuncGrant(Index: Integer): TtkTokenKind;
    function FuncGroup(Index: Integer): TtkTokenKind;
    function FuncHaving(Index: Integer): TtkTokenKind;
    function FuncHold(Index: Integer): TtkTokenKind;
    function FuncHour(Index: Integer): TtkTokenKind;
    function FuncIdentity(Index: Integer): TtkTokenKind;
    function FuncIf(Index: Integer): TtkTokenKind;
    function FuncIgnore(Index: Integer): TtkTokenKind;
    function FuncImmediate(Index: Integer): TtkTokenKind;
    function FuncIn(Index: Integer): TtkTokenKind;
    function FuncInactive(Index: Integer): TtkTokenKind;
    function FuncIndex(Index: Integer): TtkTokenKind;
    function FuncInitially(Index: Integer): TtkTokenKind;
    function FuncInner(Index: Integer): TtkTokenKind;
    function FuncInput(Index: Integer): TtkTokenKind;
    function FuncInsensitive(Index: Integer): TtkTokenKind;
    function FuncInsert(Index: Integer): TtkTokenKind;
    function FuncInstead(Index: Integer): TtkTokenKind;
    function FuncIntersect(Index: Integer): TtkTokenKind;
    function FuncInterval(Index: Integer): TtkTokenKind;
    function FuncInto(Index: Integer): TtkTokenKind;
    function FuncIs(Index: Integer): TtkTokenKind;
    function FuncIsolation(Index: Integer): TtkTokenKind;
    function FuncJoin(Index: Integer): TtkTokenKind;
    function FuncKey(Index: Integer): TtkTokenKind;
    function FuncLast(Index: Integer): TtkTokenKind;
    function FuncLeading(Index: Integer): TtkTokenKind;
    function FuncLeave(Index: Integer): TtkTokenKind;
    function FuncLeft(Index: Integer): TtkTokenKind;
    function FuncLess(Index: Integer): TtkTokenKind;
    function FuncLevel(Index: Integer): TtkTokenKind;
    function FuncLike(Index: Integer): TtkTokenKind;
    function FuncLimit(Index: Integer): TtkTokenKind;
    function FuncList(Index: Integer): TtkTokenKind;
    function FuncLocal(Index: Integer): TtkTokenKind;
    function FuncLoop(Index: Integer): TtkTokenKind;
    function FuncLower(Index: Integer): TtkTokenKind;
    function FuncMatch(Index: Integer): TtkTokenKind;
    function FuncMerge(Index: Integer): TtkTokenKind;
    function FuncMinute(Index: Integer): TtkTokenKind;
    function FuncModify(Index: Integer): TtkTokenKind;
    function FuncMonth(Index: Integer): TtkTokenKind;
    function FuncNames(Index: Integer): TtkTokenKind;
    function FuncNational(Index: Integer): TtkTokenKind;
    function FuncNatural(Index: Integer): TtkTokenKind;
    function FuncNchar(Index: Integer): TtkTokenKind;
    function FuncNew(Index: Integer): TtkTokenKind;
    function FuncNew95table(Index: Integer): TtkTokenKind;
    function FuncNext(Index: Integer): TtkTokenKind;
    function FuncNo(Index: Integer): TtkTokenKind;
    function FuncNone(Index: Integer): TtkTokenKind;
    function FuncNot(Index: Integer): TtkTokenKind;
    function FuncNull(Index: Integer): TtkTokenKind;
    function FuncNullif(Index: Integer): TtkTokenKind;
    function FuncObject(Index: Integer): TtkTokenKind;
    function FuncOctet95length(Index: Integer): TtkTokenKind;
    function FuncOf(Index: Integer): TtkTokenKind;
    function FuncOff(Index: Integer): TtkTokenKind;
    function FuncOld(Index: Integer): TtkTokenKind;
    function FuncOld95table(Index: Integer): TtkTokenKind;
    function FuncOn(Index: Integer): TtkTokenKind;
    function FuncOnly(Index: Integer): TtkTokenKind;
    function FuncOperation(Index: Integer): TtkTokenKind;
    function FuncOperator(Index: Integer): TtkTokenKind;
    function FuncOperators(Index: Integer): TtkTokenKind;
    function FuncOr(Index: Integer): TtkTokenKind;
    function FuncOrder(Index: Integer): TtkTokenKind;
    function FuncOthers(Index: Integer): TtkTokenKind;
    function FuncOuter(Index: Integer): TtkTokenKind;
    function FuncOutput(Index: Integer): TtkTokenKind;
    function FuncOverlaps(Index: Integer): TtkTokenKind;
    function FuncPad(Index: Integer): TtkTokenKind;
    function FuncParameter(Index: Integer): TtkTokenKind;
    function FuncParameters(Index: Integer): TtkTokenKind;
    function FuncPartial(Index: Integer): TtkTokenKind;
    function FuncPassword(Index: Integer): TtkTokenKind;
    function FuncPath(Index: Integer): TtkTokenKind;
    function FuncPendant(Index: Integer): TtkTokenKind;
    function FuncPlan(Index: Integer): TtkTokenKind;
    function FuncPosition(Index: Integer): TtkTokenKind;
    function FuncPostfix(Index: Integer): TtkTokenKind;
    function FuncPrefix(Index: Integer): TtkTokenKind;
    function FuncPreorder(Index: Integer): TtkTokenKind;
    function FuncPrepare(Index: Integer): TtkTokenKind;
    function FuncPreserve(Index: Integer): TtkTokenKind;
    function FuncPrimary(Index: Integer): TtkTokenKind;
    function FuncPrior(Index: Integer): TtkTokenKind;
    function FuncPrivate(Index: Integer): TtkTokenKind;
    function FuncPrivileges(Index: Integer): TtkTokenKind;
    function FuncProcedure(Index: Integer): TtkTokenKind;
    function FuncProtected(Index: Integer): TtkTokenKind;
    function FuncRead(Index: Integer): TtkTokenKind;
    function FuncRecursive(Index: Integer): TtkTokenKind;
    function FuncRef(Index: Integer): TtkTokenKind;
    function FuncReferencing(Index: Integer): TtkTokenKind;
    function FuncRelative(Index: Integer): TtkTokenKind;
    function FuncReplace(Index: Integer): TtkTokenKind;
    function FuncResignal(Index: Integer): TtkTokenKind;
    function FuncRestrict(Index: Integer): TtkTokenKind;
    function FuncRetain(Index: Integer): TtkTokenKind;
    function FuncReturn(Index: Integer): TtkTokenKind;
    function FuncReturns(Index: Integer): TtkTokenKind;
    function FuncRevoke(Index: Integer): TtkTokenKind;
    function FuncRight(Index: Integer): TtkTokenKind;
    function FuncRole(Index: Integer): TtkTokenKind;
    function FuncRollback(Index: Integer): TtkTokenKind;
    function FuncRoutine(Index: Integer): TtkTokenKind;
    function FuncRow(Index: Integer): TtkTokenKind;
    function FuncRows(Index: Integer): TtkTokenKind;
    function FuncSavepoint(Index: Integer): TtkTokenKind;
    function FuncSchema(Index: Integer): TtkTokenKind;
    function FuncScroll(Index: Integer): TtkTokenKind;
    function FuncSearch(Index: Integer): TtkTokenKind;
    function FuncSecond(Index: Integer): TtkTokenKind;
    function FuncSelect(Index: Integer): TtkTokenKind;
    function FuncSensitive(Index: Integer): TtkTokenKind;
    function FuncSequence(Index: Integer): TtkTokenKind;
    function FuncSession(Index: Integer): TtkTokenKind;
    function FuncSession95user(Index: Integer): TtkTokenKind;
    function FuncSet(Index: Integer): TtkTokenKind;
    function FuncShadow(Index: Integer): TtkTokenKind;
    function FuncShared(Index: Integer): TtkTokenKind;
    function FuncSignal(Index: Integer): TtkTokenKind;
    function FuncSimilar(Index: Integer): TtkTokenKind;
    function FuncSize(Index: Integer): TtkTokenKind;
    function FuncSnapshot(Index: Integer): TtkTokenKind;
    function FuncSome(Index: Integer): TtkTokenKind;
    function FuncSpace(Index: Integer): TtkTokenKind;
    function FuncSqlexception(Index: Integer): TtkTokenKind;
    function FuncSqlstate(Index: Integer): TtkTokenKind;
    function FuncSqlwarning(Index: Integer): TtkTokenKind;
    function FuncStart(Index: Integer): TtkTokenKind;
    function FuncState(Index: Integer): TtkTokenKind;
    function FuncStructure(Index: Integer): TtkTokenKind;
    function FuncSubstring(Index: Integer): TtkTokenKind;
    function FuncSuspend(Index: Integer): TtkTokenKind;
    function FuncSymbol(Index: Integer): TtkTokenKind;
    function FuncSystem95user(Index: Integer): TtkTokenKind;
    function FuncTable(Index: Integer): TtkTokenKind;
    function FuncTemporary(Index: Integer): TtkTokenKind;
    function FuncTerm(Index: Integer): TtkTokenKind;
    function FuncTest(Index: Integer): TtkTokenKind;
    function FuncThen(Index: Integer): TtkTokenKind;
    function FuncThere(Index: Integer): TtkTokenKind;
    function FuncTime(Index: Integer): TtkTokenKind;
    function FuncTimestamp(Index: Integer): TtkTokenKind;
    function FuncTimezone95hour(Index: Integer): TtkTokenKind;
    function FuncTimezone95minute(Index: Integer): TtkTokenKind;
    function FuncTo(Index: Integer): TtkTokenKind;
    function FuncTrailing(Index: Integer): TtkTokenKind;
    function FuncTransaction(Index: Integer): TtkTokenKind;
    function FuncTranslate(Index: Integer): TtkTokenKind;
    function FuncTranslation(Index: Integer): TtkTokenKind;
    function FuncTrigger(Index: Integer): TtkTokenKind;
    function FuncTrim(Index: Integer): TtkTokenKind;
    function FuncTrue(Index: Integer): TtkTokenKind;
    function FuncTuple(Index: Integer): TtkTokenKind;
    function FuncType(Index: Integer): TtkTokenKind;
    function FuncUncommitted(Index: Integer): TtkTokenKind;
    function FuncUnder(Index: Integer): TtkTokenKind;
    function FuncUnion(Index: Integer): TtkTokenKind;
    function FuncUnique(Index: Integer): TtkTokenKind;
    function FuncUnknown(Index: Integer): TtkTokenKind;
    function FuncUpdate(Index: Integer): TtkTokenKind;
    function FuncUpper(Index: Integer): TtkTokenKind;
    function FuncUsage(Index: Integer): TtkTokenKind;
    function FuncUser(Index: Integer): TtkTokenKind;
    function FuncUsing(Index: Integer): TtkTokenKind;
    function FuncValue(Index: Integer): TtkTokenKind;
    function FuncVarchar(Index: Integer): TtkTokenKind;
    function FuncVariable(Index: Integer): TtkTokenKind;
    function FuncVarying(Index: Integer): TtkTokenKind;
    function FuncView(Index: Integer): TtkTokenKind;
    function FuncVirtual(Index: Integer): TtkTokenKind;
    function FuncVisible(Index: Integer): TtkTokenKind;
    function FuncWait(Index: Integer): TtkTokenKind;
    function FuncWhen(Index: Integer): TtkTokenKind;
    function FuncWhere(Index: Integer): TtkTokenKind;
    function FuncWhile(Index: Integer): TtkTokenKind;
    function FuncWith(Index: Integer): TtkTokenKind;
    function FuncWithout(Index: Integer): TtkTokenKind;
    function FuncWork(Index: Integer): TtkTokenKind;
    function FuncWrite(Index: Integer): TtkTokenKind;
    function FuncYear(Index: Integer): TtkTokenKind;
    function FuncZone(Index: Integer): TtkTokenKind;
    procedure IdentProc;
    procedure NumberProc;
    procedure SymbolProc;
    procedure UnknownProc;
    function AltFunc(Index: Integer): TtkTokenKind;
    procedure InitIdent;
    procedure NullProc;
    procedure SpaceProc;
    procedure CRProc;
    procedure LFProc;
    procedure BraceCommentOpenProc;
    procedure BraceCommentProc;
    procedure CStyleCommentOpenProc;
    procedure CStyleCommentProc;
    procedure Comment1OpenProc;
    procedure Comment1Proc;
    procedure StringOpenProc;
    procedure StringProc;
    procedure String2OpenProc;
    procedure String2Proc;
  protected
    function GetSampleSource: UnicodeString; override;
    function IsFilterStored: Boolean; override;
    function IdentKind(MayBe: PWideChar): TtkTokenKind; virtual;
    function HashKey(Str: PWideChar): Cardinal; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetFriendlyLanguageName: UnicodeString; override;
    class function GetLanguageName: string; override;
    function GetRange: Pointer; override;
    procedure ResetRange; override;
    procedure SetRange(Value: Pointer); override;
    function GetDefaultAttribute(Index: Integer): TSynHighlighterAttributes; override;
    function GetEol: Boolean; override;
    function GetKeyWords(TokenKind: Integer): UnicodeString; override;
    function GetTokenID: TtkTokenKind;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: Integer; override;
    function IsIdentChar(AChar: WideChar): Boolean; override;
    procedure Next; override;
  published
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri write fCommentAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri write fIdentifierAttri;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri write fNumberAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri write fSpaceAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri write fStringAttri;
    property SymbolAttri: TSynHighlighterAttributes read fSymbolAttri write fSymbolAttri;
    property TablenameAttri: TSynHighlighterAttributes read fTablenameAttri write fTablenameAttri;
  end;

implementation

uses
{$IFDEF SYN_CLX}
  QSynEditStrConst;
{$ELSE}
  SynEditStrConst;
{$ENDIF}

resourcestring
  SYNS_Filter = 'All files (*.*)|*.*';
  SYNS_Lang = '';
  SYNS_FriendlyLang = '';
  SYNS_AttrTablename = 'Tablename';
  SYNS_FriendlyAttrTablename = 'Tablename';

const
  // as this language is case-insensitive keywords *must* be in lowercase
  KeyWords: array[0..305] of UnicodeString = (
    'absolute', 'action', 'active', 'actor', 'add', 'after', 'alias', 'all', 
    'allocate', 'alter', 'and', 'any', 'are', 'as', 'asc', 'ascending', 
    'assertion', 'async', 'at', 'attributes', 'auto', 'base_name', 'before', 
    'begin', 'between', 'bit', 'bit_length', 'boolean', 'both', 'breadth', 'by', 
    'cache', 'call', 'cascade', 'cascaded', 'case', 'cast', 'catalog', 
    'char_length', 'character_length', 'check', 'coalesce', 'collate', 
    'collation', 'column', 'commit', 'committed', 'completion', 'computed', 
    'conditional', 'connect', 'connection', 'constraint', 'constraints', 
    'containing', 'convert', 'corresponding', 'count', 'create', 'cross', 
    'current', 'current_date', 'current_path', 'current_time', 
    'current_timestamp', 'current_user', 'cursor', 'cycle', 'data', 'database', 
    'date', 'day', 'deallocate', 'debug', 'declare', 'default', 'deferrable', 
    'deferred', 'delete', 'depth', 'desc', 'descending', 'describe', 
    'descriptor', 'destroy', 'diagnostics', 'dictionary', 'disconnect', 
    'distinct', 'do', 'domain', 'drop', 'each', 'element', 'else', 'elseif', 
    'end', 'end-exec', 'entry_point', 'equals', 'escape', 'except', 'exception', 
    'execute', 'exists', 'exit', 'external', 'extract', 'factor', 'false', 
    'filter', 'first', 'for', 'foreign', 'from', 'full', 'function', 'general', 
    'generator', 'get', 'global', 'grant', 'group', 'having', 'hold', 'hour', 
    'identity', 'if', 'ignore', 'immediate', 'in', 'inactive', 'index', 
    'initially', 'inner', 'input', 'insensitive', 'insert', 'instead', 
    'intersect', 'interval', 'into', 'is', 'isolation', 'join', 'key', 'last', 
    'leading', 'leave', 'left', 'less', 'level', 'like', 'limit', 'list', 
    'local', 'loop', 'lower', 'match', 'merge', 'minute', 'modify', 'month', 
    'names', 'national', 'natural', 'nchar', 'new', 'new_table', 'next', 'no', 
    'none', 'not', 'null', 'nullif', 'object', 'octet_length', 'of', 'off', 
    'old', 'old_table', 'on', 'only', 'operation', 'operator', 'operators', 
    'or', 'order', 'others', 'outer', 'output', 'overlaps', 'pad', 'parameter', 
    'parameters', 'partial', 'password', 'path', 'pendant', 'plan', 'position', 
    'postfix', 'prefix', 'preorder', 'prepare', 'preserve', 'primary', 'prior', 
    'private', 'privileges', 'procedure', 'protected', 'read', 'recursive', 
    'ref', 'referencing', 'relative', 'replace', 'resignal', 'restrict', 
    'retain', 'return', 'returns', 'revoke', 'right', 'role', 'rollback', 
    'routine', 'row', 'rows', 'savepoint', 'schema', 'scroll', 'search', 
    'second', 'select', 'sensitive', 'sequence', 'session', 'session_user', 
    'set', 'shadow', 'shared', 'signal', 'similar', 'size', 'snapshot', 'some', 
    'space', 'sqlexception', 'sqlstate', 'sqlwarning', 'start', 'state', 
    'structure', 'substring', 'suspend', 'symbol', 'system_user', 'table', 
    'temporary', 'term', 'test', 'then', 'there', 'time', 'timestamp', 
    'timezone_hour', 'timezone_minute', 'to', 'trailing', 'transaction', 
    'translate', 'translation', 'trigger', 'trim', 'true', 'tuple', 'type', 
    'uncommitted', 'under', 'union', 'unique', 'unknown', 'update', 'upper', 
    'usage', 'user', 'using', 'value', 'varchar', 'variable', 'varying', 'view', 
    'virtual', 'visible', 'wait', 'when', 'where', 'while', 'with', 'without', 
    'work', 'write', 'year', 'zone' 
  );

  KeyIndices: array[0..2856] of Integer = (
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 305, -1, -1, -1, -1, -1, 68, 
    287, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, 0, -1, -1, -1, -1, -1, -1, 208, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, 197, -1, -1, -1, -1, -1, -1, -1, 296, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, 186, -1, 196, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, 292, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 277, -1, 37, -1, -1, 244, 100, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, 149, -1, 249, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 54, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, 240, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 281, -1, 64, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 125, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 188, -1, -1, -1, -1, -1, -1, -1, 
    -1, 130, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 18, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, 178, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    92, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 221, -1, -1, 
    -1, -1, -1, -1, 191, -1, 51, 50, -1, -1, -1, -1, -1, -1, -1, -1, -1, 75, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 270, -1, 
    -1, -1, -1, -1, -1, -1, -1, 83, -1, -1, -1, 2, 262, 175, -1, 180, -1, -1, 
    -1, -1, -1, 28, -1, -1, -1, -1, -1, 109, -1, -1, 40, -1, -1, 258, -1, -1, 
    -1, -1, -1, -1, -1, -1, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, 117, -1, -1, -1, -1, -1, -1, 47, -1, -1, -1, -1, -1, 32, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, 222, -1, 238, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, 274, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 250, 65, -1, -1, -1, -1, -1, -1, -1, -1, 114, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 216, -1, 6, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 179, -1, 
    -1, -1, -1, -1, 26, -1, -1, -1, -1, 133, 62, -1, 275, -1, -1, -1, -1, -1, 
    -1, -1, 78, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, 129, -1, -1, -1, -1, -1, -1, 24, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 22, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, 230, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 269, -1, -1, -1, -1, -1, -1, 
    -1, -1, 154, -1, -1, -1, -1, -1, 52, -1, -1, -1, 80, -1, -1, -1, -1, -1, -1, 
    -1, -1, 169, -1, -1, -1, 260, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 173, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 35, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, 141, 120, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1, -1, -1, -1, -1, -1, 
    -1, -1, 147, -1, -1, -1, -1, -1, -1, -1, 254, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 48, -1, -1, -1, -1, 87, -1, -1, 152, 
    -1, 271, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 245, -1, -1, -1, -1, 207, -1, -1, -1, 106, -1, 145, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 66, -1, -1, 203, -1, -1, -1, 105, -1, -1, -1, 
    84, -1, -1, 184, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 288, -1, -1, -1, 
    -1, -1, -1, -1, -1, 190, -1, -1, -1, -1, -1, -1, -1, 177, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 94, 58, 
    -1, -1, -1, -1, -1, -1, 192, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 14, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 86, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 279, -1, -1, -1, -1, 
    -1, 139, -1, -1, -1, -1, 265, -1, -1, 17, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, 103, -1, -1, -1, 182, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 79, 252, -1, 115, -1, -1, -1, -1, 36, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, 150, -1, -1, -1, 215, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    213, -1, -1, -1, -1, -1, -1, -1, -1, -1, 85, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, 239, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 219, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 155, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    195, -1, -1, -1, -1, -1, -1, 210, 261, -1, -1, -1, -1, -1, -1, 39, -1, 293, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 280, 72, -1, -1, -1, -1, -1, -1, -1, 
    148, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 200, -1, 73, 278, -1, -1, 159, -1, -1, -1, -1, 
    -1, 82, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 110, -1, 172, -1, -1, 
    104, -1, -1, -1, 34, -1, -1, -1, -1, 95, -1, -1, -1, -1, -1, 176, -1, -1, 
    -1, -1, 181, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    211, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 282, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 44, -1, -1, 224, -1, 
    -1, 97, -1, 286, -1, -1, -1, -1, -1, -1, -1, -1, -1, 160, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 81, -1, -1, -1, -1, -1, -1, -1, -1, -1, 23, -1, 
    163, -1, -1, -1, -1, -1, -1, -1, 7, -1, -1, -1, -1, -1, -1, -1, 45, -1, -1, 
    -1, -1, -1, 297, -1, -1, 91, 88, -1, -1, -1, -1, -1, 209, 242, -1, -1, -1, 
    -1, -1, -1, -1, -1, 31, 30, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 146, -1, -1, -1, -1, -1, -1, 121, 298, -1, -1, 98, 
    -1, -1, -1, -1, -1, -1, 123, -1, -1, -1, 16, -1, 124, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 218, -1, -1, -1, -1, -1, -1, -1, 
    4, -1, 70, 236, -1, -1, -1, -1, -1, 56, -1, -1, -1, 138, -1, -1, -1, -1, -1, 
    -1, 63, -1, -1, -1, -1, -1, -1, 246, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, 272, -1, -1, -1, -1, -1, -1, -1, 128, -1, -1, -1, -1, -1, -1, -1, 193, 
    -1, -1, 198, 8, -1, -1, -1, 264, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 89, -1, -1, -1, -1, -1, -1, 49, -1, 167, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, 259, -1, -1, 168, -1, -1, -1, -1, -1, -1, -1, -1, 291, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 162, -1, -1, -1, 74, -1, -1, 
    228, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, 122, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 164, 
    267, -1, 136, -1, -1, 108, -1, -1, 263, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 21, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 101, 25, -1, -1, -1, -1, -1, -1, -1, -1, 201, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, 229, -1, -1, -1, -1, -1, -1, 225, -1, -1, -1, -1, 294, -1, -1, 93, 
    -1, -1, -1, -1, -1, 295, 116, -1, -1, -1, -1, -1, -1, -1, -1, 41, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, 134, 233, 171, -1, -1, -1, -1, 153, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 20, 57, 212, -1, -1, -1, -1, -1, -1, 266, -1, 
    131, -1, 137, -1, -1, -1, 29, -1, -1, -1, -1, -1, 285, -1, -1, 284, -1, -1, 
    -1, -1, 303, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 132, -1, 304, -1, -1, 69, -1, -1, 243, -1, -1, -1, -1, -1, -1, 
    257, -1, -1, -1, -1, -1, 205, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 59, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 53, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 112, 
    -1, -1, -1, -1, -1, -1, -1, 189, -1, -1, -1, -1, -1, -1, -1, -1, 61, -1, 
    253, -1, -1, -1, -1, -1, -1, 223, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, 174, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 289, -1, -1, -1, -1, -1, -1, -1, -1, -1, 43, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, 126, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, 90, -1, -1, 232, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    27, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, 235, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    142, -1, 157, -1, -1, -1, -1, -1, -1, 273, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 300, -1, 11, 15, 
    -1, -1, 151, -1, -1, -1, -1, 19, -1, -1, -1, -1, -1, -1, -1, 194, -1, -1, 
    -1, -1, 67, -1, -1, -1, -1, -1, -1, 217, -1, -1, -1, -1, -1, 185, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, 256, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    226, -1, -1, -1, -1, -1, -1, -1, 3, -1, -1, -1, 42, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 276, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 183, -1, 144, -1, -1, -1, -1, -1, 77, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 237, 268, -1, 283, -1, 10, 302, 
    -1, -1, -1, -1, -1, -1, -1, 96, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, 60, -1, -1, -1, -1, 71, -1, -1, -1, -1, -1, -1, -1, 156, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 251, 76, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 140, 46, -1, -1, 99, -1, -1, -1, -1, -1, -1, -1, 158, -1, -1, 
    -1, -1, -1, -1, -1, 170, -1, -1, -1, -1, -1, -1, -1, 299, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 301, 204, -1, -1, -1, -1, -1, 
    -1, -1, 102, -1, -1, -1, -1, -1, -1, 248, -1, -1, -1, 38, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, 119, -1, -1, -1, -1, -1, 161, -1, -1, -1, -1, -1, -1, 
    231, -1, -1, -1, -1, -1, 118, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, 12, -1, -1, -1, 166, -1, 290, -1, -1, -1, -1, -1, -1, 214, 
    -1, -1, -1, -1, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, 113, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 227, -1, -1, -1, -1, 
    -1, -1, -1, -1, 33, -1, -1, -1, -1, -1, -1, -1, -1, 206, -1, -1, 111, 220, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 187, -1, -1, 165, -1, 
    -1, -1, -1, 234, -1, -1, -1, -1, 107, -1, -1, -1, -1, 9, -1, -1, -1, 55, -1, 
    255, 13, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, 143, -1, -1, -1, 127, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, 241, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    202, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 199, -1, -1, 135 
  );

procedure TtbSqlHighlighterBase.InitIdent;
var
  i: Integer;
begin
  for i := Low(fIdentFuncTable) to High(fIdentFuncTable) do
    if KeyIndices[i] = -1 then
      fIdentFuncTable[i] := AltFunc;

  fIdentFuncTable[59] := FuncAbsolute;
  fIdentFuncTable[895] := FuncAction;
  fIdentFuncTable[444] := FuncActive;
  fIdentFuncTable[2411] := FuncActor;
  fIdentFuncTable[1624] := FuncAdd;
  fIdentFuncTable[475] := FuncAfter;
  fIdentFuncTable[580] := FuncAlias;
  fIdentFuncTable[1521] := FuncAll;
  fIdentFuncTable[1683] := FuncAllocate;
  fIdentFuncTable[2766] := FuncAlter;
  fIdentFuncTable[2475] := FuncAnd;
  fIdentFuncTable[2346] := FuncAny;
  fIdentFuncTable[2646] := FuncAre;
  fIdentFuncTable[2773] := FuncAs;
  fIdentFuncTable[1070] := FuncAsc;
  fIdentFuncTable[2347] := FuncAscending;
  fIdentFuncTable[1597] := FuncAssertion;
  fIdentFuncTable[1114] := FuncAsync;
  fIdentFuncTable[318] := FuncAt;
  fIdentFuncTable[2355] := FuncAttributes;
  fIdentFuncTable[1964] := FuncAuto;
  fIdentFuncTable[1834] := FuncBase95name;
  fIdentFuncTable[705] := FuncBefore;
  fIdentFuncTable[1511] := FuncBegin;
  fIdentFuncTable[683] := FuncBetween;
  fIdentFuncTable[1855] := FuncBit;
  fIdentFuncTable[623] := FuncBit95length;
  fIdentFuncTable[2274] := FuncBoolean;
  fIdentFuncTable[454] := FuncBoth;
  fIdentFuncTable[1981] := FuncBreadth;
  fIdentFuncTable[1556] := FuncBy;
  fIdentFuncTable[1555] := FuncCache;
  fIdentFuncTable[502] := FuncCall;
  fIdentFuncTable[2721] := FuncCascade;
  fIdentFuncTable[1367] := FuncCascaded;
  fIdentFuncTable[855] := FuncCase;
  fIdentFuncTable[1171] := FuncCast;
  fIdentFuncTable[178] := FuncCatalog;
  fIdentFuncTable[2601] := FuncChar95length;
  fIdentFuncTable[1267] := FuncCharacter95length;
  fIdentFuncTable[463] := FuncCheck;
  fIdentFuncTable[1917] := FuncCoalesce;
  fIdentFuncTable[2415] := FuncCollate;
  fIdentFuncTable[2214] := FuncCollation;
  fIdentFuncTable[1471] := FuncColumn;
  fIdentFuncTable[1529] := FuncCommit;
  fIdentFuncTable[2538] := FuncCommitted;
  fIdentFuncTable[496] := FuncCompletion;
  fIdentFuncTable[929] := FuncComputed;
  fIdentFuncTable[1713] := FuncConditional;
  fIdentFuncTable[402] := FuncConnect;
  fIdentFuncTable[401] := FuncConnection;
  fIdentFuncTable[797] := FuncConstraint;
  fIdentFuncTable[2121] := FuncConstraints;
  fIdentFuncTable[220] := FuncContaining;
  fIdentFuncTable[2770] := FuncConvert;
  fIdentFuncTable[1633] := FuncCorresponding;
  fIdentFuncTable[1965] := FuncCount;
  fIdentFuncTable[1047] := FuncCreate;
  fIdentFuncTable[2093] := FuncCross;
  fIdentFuncTable[2497] := FuncCurrent;
  fIdentFuncTable[2159] := FuncCurrent95date;
  fIdentFuncTable[629] := FuncCurrent95path;
  fIdentFuncTable[1644] := FuncCurrent95time;
  fIdentFuncTable[248] := FuncCurrent95timestamp;
  fIdentFuncTable[552] := FuncCurrent95user;
  fIdentFuncTable[982] := FuncCursor;
  fIdentFuncTable[2368] := FuncCycle;
  fIdentFuncTable[18] := FuncData;
  fIdentFuncTable[2058] := FuncDatabase;
  fIdentFuncTable[1626] := FuncDate;
  fIdentFuncTable[2502] := FuncDay;
  fIdentFuncTable[1281] := FuncDeallocate;
  fIdentFuncTable[1336] := FuncDebug;
  fIdentFuncTable[1770] := FuncDeclare;
  fIdentFuncTable[412] := FuncDefault;
  fIdentFuncTable[2523] := FuncDeferrable;
  fIdentFuncTable[2456] := FuncDeferred;
  fIdentFuncTable[639] := FuncDelete;
  fIdentFuncTable[1163] := FuncDepth;
  fIdentFuncTable[801] := FuncDesc;
  fIdentFuncTable[1501] := FuncDescending;
  fIdentFuncTable[1346] := FuncDescribe;
  fIdentFuncTable[440] := FuncDescriptor;
  fIdentFuncTable[993] := FuncDestroy;
  fIdentFuncTable[1206] := FuncDiagnostics;
  fIdentFuncTable[1082] := FuncDictionary;
  fIdentFuncTable[934] := FuncDisconnect;
  fIdentFuncTable[1539] := FuncDistinct;
  fIdentFuncTable[1706] := FuncDo;
  fIdentFuncTable[2241] := FuncDomain;
  fIdentFuncTable[1538] := FuncDrop;
  fIdentFuncTable[357] := FuncEach;
  fIdentFuncTable[1901] := FuncElement;
  fIdentFuncTable[1046] := FuncElse;
  fIdentFuncTable[1372] := FuncElseif;
  fIdentFuncTable[2484] := FuncEnd;
  fIdentFuncTable[1477] := FuncEnd45exec;
  fIdentFuncTable[1586] := FuncEntry95point;
  fIdentFuncTable[2541] := FuncEquals;
  fIdentFuncTable[182] := FuncEscape;
  fIdentFuncTable[1854] := FuncExcept;
  fIdentFuncTable[2590] := FuncException;
  fIdentFuncTable[1125] := FuncExecute;
  fIdentFuncTable[1363] := FuncExists;
  fIdentFuncTable[989] := FuncExit;
  fIdentFuncTable[969] := FuncExternal;
  fIdentFuncTable[2761] := FuncExtract;
  fIdentFuncTable[1815] := FuncFactor;
  fIdentFuncTable[460] := FuncFalse;
  fIdentFuncTable[1358] := FuncFilter;
  fIdentFuncTable[2733] := FuncFirst;
  fIdentFuncTable[2142] := FuncFor;
  fIdentFuncTable[2683] := FuncForeign;
  fIdentFuncTable[561] := FuncFrom;
  fIdentFuncTable[1166] := FuncFull;
  fIdentFuncTable[1908] := FuncFunction;
  fIdentFuncTable[489] := FuncGeneral;
  fIdentFuncTable[2630] := FuncGenerator;
  fIdentFuncTable[2611] := FuncGet;
  fIdentFuncTable[873] := FuncGlobal;
  fIdentFuncTable[1582] := FuncGrant;
  fIdentFuncTable[1794] := FuncGroup;
  fIdentFuncTable[1593] := FuncHaving;
  fIdentFuncTable[1599] := FuncHold;
  fIdentFuncTable[279] := FuncHour;
  fIdentFuncTable[2225] := FuncIdentity;
  fIdentFuncTable[2799] := FuncIf;
  fIdentFuncTable[1671] := FuncIgnore;
  fIdentFuncTable[676] := FuncImmediate;
  fIdentFuncTable[301] := FuncIn;
  fIdentFuncTable[1975] := FuncInactive;
  fIdentFuncTable[2053] := FuncIndex;
  fIdentFuncTable[628] := FuncInitially;
  fIdentFuncTable[1944] := FuncInner;
  fIdentFuncTable[2856] := FuncInput;
  fIdentFuncTable[1812] := FuncInsensitive;
  fIdentFuncTable[1977] := FuncInsert;
  fIdentFuncTable[1637] := FuncInstead;
  fIdentFuncTable[1106] := FuncIntersect;
  fIdentFuncTable[2537] := FuncInterval;
  fIdentFuncTable[872] := FuncInto;
  fIdentFuncTable[2311] := FuncIs;
  fIdentFuncTable[2795] := FuncIsolation;
  fIdentFuncTable[2450] := FuncJoin;
  fIdentFuncTable[971] := FuncKey;
  fIdentFuncTable[1575] := FuncLast;
  fIdentFuncTable[903] := FuncLeading;
  fIdentFuncTable[1289] := FuncLeave;
  fIdentFuncTable[192] := FuncLeft;
  fIdentFuncTable[1182] := FuncLess;
  fIdentFuncTable[2350] := FuncLevel;
  fIdentFuncTable[937] := FuncLike;
  fIdentFuncTable[1951] := FuncLimit;
  fIdentFuncTable[791] := FuncList;
  fIdentFuncTable[1240] := FuncLocal;
  fIdentFuncTable[2510] := FuncLoop;
  fIdentFuncTable[2313] := FuncLower;
  fIdentFuncTable[2549] := FuncMatch;
  fIdentFuncTable[1340] := FuncMerge;
  fIdentFuncTable[1489] := FuncMinute;
  fIdentFuncTable[2617] := FuncModify;
  fIdentFuncTable[1766] := FuncMonth;
  fIdentFuncTable[1513] := FuncNames;
  fIdentFuncTable[1809] := FuncNational;
  fIdentFuncTable[2751] := FuncNatural;
  fIdentFuncTable[2650] := FuncNchar;
  fIdentFuncTable[1715] := FuncNew;
  fIdentFuncTable[1742] := FuncNew95table;
  fIdentFuncTable[810] := FuncNext;
  fIdentFuncTable[2557] := FuncNo;
  fIdentFuncTable[1946] := FuncNone;
  fIdentFuncTable[1360] := FuncNot;
  fIdentFuncTable[829] := FuncNull;
  fIdentFuncTable[2180] := FuncNullif;
  fIdentFuncTable[446] := FuncObject;
  fIdentFuncTable[1378] := FuncOctet95length;
  fIdentFuncTable[1024] := FuncOf;
  fIdentFuncTable[339] := FuncOff;
  fIdentFuncTable[617] := FuncOld;
  fIdentFuncTable[448] := FuncOld95table;
  fIdentFuncTable[1383] := FuncOn;
  fIdentFuncTable[1129] := FuncOnly;
  fIdentFuncTable[2448] := FuncOperation;
  fIdentFuncTable[996] := FuncOperator;
  fIdentFuncTable[2381] := FuncOperators;
  fIdentFuncTable[134] := FuncOr;
  fIdentFuncTable[2748] := FuncOrder;
  fIdentFuncTable[292] := FuncOthers;
  fIdentFuncTable[2150] := FuncOuter;
  fIdentFuncTable[1016] := FuncOutput;
  fIdentFuncTable[399] := FuncOverlaps;
  fIdentFuncTable[1054] := FuncPad;
  fIdentFuncTable[1679] := FuncParameter;
  fIdentFuncTable[2363] := FuncParameters;
  fIdentFuncTable[1252] := FuncPartial;
  fIdentFuncTable[136] := FuncPassword;
  fIdentFuncTable[96] := FuncPath;
  fIdentFuncTable[1682] := FuncPendant;
  fIdentFuncTable[2853] := FuncPlan;
  fIdentFuncTable[1334] := FuncPosition;
  fIdentFuncTable[1864] := FuncPostfix;
  fIdentFuncTable[2827] := FuncPrefix;
  fIdentFuncTable[985] := FuncPreorder;
  fIdentFuncTable[2582] := FuncPrepare;
  fIdentFuncTable[2074] := FuncPreserve;
  fIdentFuncTable[2730] := FuncPrimary;
  fIdentFuncTable[965] := FuncPrior;
  fIdentFuncTable[66] := FuncPrivate;
  fIdentFuncTable[1545] := FuncPrivileges;
  fIdentFuncTable[1259] := FuncProcedure;
  fIdentFuncTable[1400] := FuncProtected;
  fIdentFuncTable[1966] := FuncRead;
  fIdentFuncTable[1196] := FuncRecursive;
  fIdentFuncTable[2659] := FuncRef;
  fIdentFuncTable[1186] := FuncReferencing;
  fIdentFuncTable[578] := FuncRelative;
  fIdentFuncTable[2375] := FuncReplace;
  fIdentFuncTable[1616] := FuncResignal;
  fIdentFuncTable[1227] := FuncRestrict;
  fIdentFuncTable[2734] := FuncRetain;
  fIdentFuncTable[392] := FuncReturn;
  fIdentFuncTable[512] := FuncReturns;
  fIdentFuncTable[2168] := FuncRevoke;
  fIdentFuncTable[1474] := FuncRight;
  fIdentFuncTable[1893] := FuncRole;
  fIdentFuncTable[2403] := FuncRollback;
  fIdentFuncTable[2712] := FuncRoutine;
  fIdentFuncTable[1773] := FuncRow;
  fIdentFuncTable[1886] := FuncRows;
  fIdentFuncTable[721] := FuncSavepoint;
  fIdentFuncTable[2624] := FuncSchema;
  fIdentFuncTable[2244] := FuncScroll;
  fIdentFuncTable[1945] := FuncSearch;
  fIdentFuncTable[2756] := FuncSecond;
  fIdentFuncTable[2298] := FuncSelect;
  fIdentFuncTable[1627] := FuncSensitive;
  fIdentFuncTable[2470] := FuncSequence;
  fIdentFuncTable[514] := FuncSession;
  fIdentFuncTable[1216] := FuncSession95user;
  fIdentFuncTable[232] := FuncSet;
  fIdentFuncTable[2811] := FuncShadow;
  fIdentFuncTable[1546] := FuncShared;
  fIdentFuncTable[2061] := FuncSignal;
  fIdentFuncTable[181] := FuncSimilar;
  fIdentFuncTable[960] := FuncSize;
  fIdentFuncTable[1651] := FuncSnapshot;
  fIdentFuncTable[2664] := FuncSome;
  fIdentFuncTable[2597] := FuncSpace;
  fIdentFuncTable[194] := FuncSqlexception;
  fIdentFuncTable[551] := FuncSqlstate;
  fIdentFuncTable[2522] := FuncSqlwarning;
  fIdentFuncTable[1164] := FuncStart;
  fIdentFuncTable[2161] := FuncState;
  fIdentFuncTable[911] := FuncStructure;
  fIdentFuncTable[2772] := FuncSubstring;
  fIdentFuncTable[2393] := FuncSuspend;
  fIdentFuncTable[2068] := FuncSymbol;
  fIdentFuncTable[466] := FuncSystem95user;
  fIdentFuncTable[1739] := FuncTable;
  fIdentFuncTable[814] := FuncTemporary;
  fIdentFuncTable[1260] := FuncTerm;
  fIdentFuncTable[445] := FuncTest;
  fIdentFuncTable[1818] := FuncThen;
  fIdentFuncTable[1687] := FuncThere;
  fIdentFuncTable[1111] := FuncTime;
  fIdentFuncTable[1973] := FuncTimestamp;
  fIdentFuncTable[1810] := FuncTimezone95hour;
  fIdentFuncTable[2471] := FuncTimezone95minute;
  fIdentFuncTable[782] := FuncTo;
  fIdentFuncTable[431] := FuncTrailing;
  fIdentFuncTable[939] := FuncTransaction;
  fIdentFuncTable[1663] := FuncTranslate;
  fIdentFuncTable[2320] := FuncTranslation;
  fIdentFuncTable[530] := FuncTrigger;
  fIdentFuncTable[631] := FuncTrim;
  fIdentFuncTable[2436] := FuncTrue;
  fIdentFuncTable[176] := FuncTuple;
  fIdentFuncTable[1337] := FuncType;
  fIdentFuncTable[1100] := FuncUncommitted;
  fIdentFuncTable[1280] := FuncUnder;
  fIdentFuncTable[246] := FuncUnion;
  fIdentFuncTable[1453] := FuncUnique;
  fIdentFuncTable[2473] := FuncUnknown;
  fIdentFuncTable[1990] := FuncUpdate;
  fIdentFuncTable[1987] := FuncUpper;
  fIdentFuncTable[1479] := FuncUsage;
  fIdentFuncTable[19] := FuncUser;
  fIdentFuncTable[1007] := FuncUsing;
  fIdentFuncTable[2204] := FuncValue;
  fIdentFuncTable[2652] := FuncVarchar;
  fIdentFuncTable[1751] := FuncVariable;
  fIdentFuncTable[151] := FuncVarying;
  fIdentFuncTable[1269] := FuncView;
  fIdentFuncTable[1898] := FuncVirtual;
  fIdentFuncTable[1907] := FuncVisible;
  fIdentFuncTable[104] := FuncWait;
  fIdentFuncTable[1535] := FuncWhen;
  fIdentFuncTable[1583] := FuncWhere;
  fIdentFuncTable[2565] := FuncWhile;
  fIdentFuncTable[2344] := FuncWith;
  fIdentFuncTable[2581] := FuncWithout;
  fIdentFuncTable[2476] := FuncWork;
  fIdentFuncTable[1995] := FuncWrite;
  fIdentFuncTable[2055] := FuncYear;
  fIdentFuncTable[12] := FuncZone;
end;

{$Q-}
function TtbSqlHighlighterBase.HashKey(Str: PWideChar): Cardinal;
begin
  Result := 0;
  while IsIdentChar(Str^) do
  begin
    Result := Result * 325 + Ord(Str^) * 402;
    inc(Str);
  end;
  Result := Result mod 2857;
  fStringLen := Str - fToIdent;
end;
{$Q+}

function TtbSqlHighlighterBase.FuncAbsolute(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAction(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncActive(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncActor(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAdd(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAfter(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAlias(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAll(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAllocate(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAlter(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAnd(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAny(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAre(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAs(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAsc(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAscending(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAssertion(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAsync(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAt(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAttributes(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncAuto(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncBase95name(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncBefore(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncBegin(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncBetween(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncBit(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncBit95length(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncBoolean(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncBoth(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncBreadth(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncBy(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCache(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCall(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCascade(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCascaded(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCase(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCast(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCatalog(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncChar95length(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCharacter95length(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCheck(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCoalesce(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCollate(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCollation(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncColumn(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCommit(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCommitted(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCompletion(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncComputed(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncConditional(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncConnect(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncConnection(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncConstraint(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncConstraints(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncContaining(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncConvert(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCorresponding(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCount(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCreate(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCross(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCurrent(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCurrent95date(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCurrent95path(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCurrent95time(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCurrent95timestamp(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCurrent95user(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCursor(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncCycle(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncData(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDatabase(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDate(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDay(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDeallocate(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDebug(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDeclare(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDefault(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDeferrable(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDeferred(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDelete(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDepth(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDesc(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDescending(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDescribe(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDescriptor(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDestroy(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDiagnostics(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDictionary(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDisconnect(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDistinct(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDo(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDomain(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncDrop(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncEach(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncElement(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncElse(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncElseif(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncEnd(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncEnd45exec(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncEntry95point(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncEquals(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncEscape(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncExcept(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncException(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncExecute(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncExists(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncExit(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncExternal(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncExtract(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncFactor(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncFalse(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncFilter(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncFirst(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncFor(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncForeign(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncFrom(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncFull(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncFunction(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncGeneral(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncGenerator(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncGet(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncGlobal(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncGrant(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncGroup(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncHaving(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncHold(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncHour(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncIdentity(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncIf(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncIgnore(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncImmediate(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncIn(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncInactive(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncIndex(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncInitially(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncInner(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncInput(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncInsensitive(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncInsert(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncInstead(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncIntersect(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncInterval(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncInto(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncIs(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncIsolation(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncJoin(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncKey(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncLast(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncLeading(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncLeave(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncLeft(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncLess(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncLevel(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncLike(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncLimit(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncList(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncLocal(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncLoop(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncLower(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncMatch(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncMerge(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncMinute(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncModify(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncMonth(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncNames(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncNational(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncNatural(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncNchar(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncNew(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncNew95table(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncNext(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncNo(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncNone(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncNot(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncNull(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncNullif(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncObject(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOctet95length(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOf(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOff(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOld(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOld95table(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOn(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOnly(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOperation(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOperator(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOperators(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOr(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOrder(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOthers(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOuter(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOutput(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncOverlaps(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPad(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncParameter(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncParameters(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPartial(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPassword(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPath(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPendant(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPlan(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPosition(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPostfix(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPrefix(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPreorder(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPrepare(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPreserve(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPrimary(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPrior(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPrivate(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncPrivileges(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncProcedure(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncProtected(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncRead(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncRecursive(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncRef(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncReferencing(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncRelative(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncReplace(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncResignal(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncRestrict(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncRetain(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncReturn(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncReturns(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncRevoke(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncRight(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncRole(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncRollback(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncRoutine(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncRow(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncRows(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSavepoint(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSchema(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncScroll(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSearch(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSecond(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSelect(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSensitive(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSequence(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSession(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSession95user(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSet(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncShadow(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncShared(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSignal(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSimilar(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSize(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSnapshot(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSome(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSpace(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSqlexception(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSqlstate(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSqlwarning(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncStart(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncState(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncStructure(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSubstring(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSuspend(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSymbol(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncSystem95user(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTable(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTemporary(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTerm(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTest(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncThen(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncThere(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTime(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTimestamp(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTimezone95hour(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTimezone95minute(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTo(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTrailing(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTransaction(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTranslate(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTranslation(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTrigger(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTrim(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTrue(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncTuple(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncType(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncUncommitted(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncUnder(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncUnion(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncUnique(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncUnknown(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncUpdate(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncUpper(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncUsage(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncUser(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncUsing(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncValue(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncVarchar(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncVariable(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncVarying(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncView(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncVirtual(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncVisible(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncWait(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncWhen(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncWhere(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncWhile(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncWith(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncWithout(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncWork(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncWrite(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncYear(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.FuncZone(Index: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Index]) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.AltFunc(Index: Integer): TtkTokenKind;
begin
  Result := tkIdentifier;
end;

function TtbSqlHighlighterBase.IdentKind(MayBe: PWideChar): TtkTokenKind;
var
  Key: Cardinal;
begin
  fToIdent := MayBe;
  Key := HashKey(MayBe);
  if Key <= High(fIdentFuncTable) then
    Result := fIdentFuncTable[Key](KeyIndices[Key])
  else
    Result := tkIdentifier;
end;

procedure TtbSqlHighlighterBase.SpaceProc;
begin
  inc(Run);
  fTokenID := tkSpace;
  while (FLine[Run] <= #32) and not IsLineEnd(Run) do inc(Run);
end;

procedure TtbSqlHighlighterBase.NullProc;
begin
  fTokenID := tkNull;
  inc(Run);
end;

procedure TtbSqlHighlighterBase.CRProc;
begin
  fTokenID := tkSpace;
  inc(Run);
  if fLine[Run] = #10 then
    inc(Run);
end;

procedure TtbSqlHighlighterBase.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end;

procedure TtbSqlHighlighterBase.BraceCommentOpenProc;
begin
  Inc(Run);
  fRange := rsBraceComment;
  fTokenID := tkComment;
end;

procedure TtbSqlHighlighterBase.BraceCommentProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    begin
      fTokenID := tkComment;
      repeat
        if (fLine[Run] = '}') then
        begin
          Inc(Run, 1);
          fRange := rsUnKnown;
          Break;
        end;
        if not IsLineEnd(Run) then
          Inc(Run);
      until IsLineEnd(Run);
    end;
  end;
end;

procedure TtbSqlHighlighterBase.CStyleCommentOpenProc;
begin
  Inc(Run);
  if (fLine[Run] = '*') then
  begin
    Inc(Run, 1);
    fRange := rsCStyleComment;
    fTokenID := tkComment;
  end
  else
    fTokenID := tkSymbol;
end;

procedure TtbSqlHighlighterBase.CStyleCommentProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    begin
      fTokenID := tkComment;
      repeat
        if (fLine[Run] = '*') and
           (fLine[Run + 1] = '/') then
        begin
          Inc(Run, 2);
          fRange := rsUnKnown;
          Break;
        end;
        if not IsLineEnd(Run) then
          Inc(Run);
      until IsLineEnd(Run);
    end;
  end;
end;

procedure TtbSqlHighlighterBase.Comment1OpenProc;
begin
  Inc(Run);
  if (fLine[Run] = '-') then
  begin
    Inc(Run, 1);
    fRange := rsComment1;
    Comment1Proc;
    fTokenID := tkComment;
  end
  else
    fTokenID := tkSymbol;
end;

procedure TtbSqlHighlighterBase.Comment1Proc;
begin
  fTokenID := tkComment;
  repeat
    if (fLine[Run] = '''') and
       (fLine[Run + 1] = '''') then
    begin
      Inc(Run, 2);
      fRange := rsUnKnown;
      Break;
    end;
    if not IsLineEnd(Run) then
      Inc(Run);
  until IsLineEnd(Run);
end;

procedure TtbSqlHighlighterBase.StringOpenProc;
begin
  Inc(Run);
  fRange := rsString;
  StringProc;
  fTokenID := tkString;
end;

procedure TtbSqlHighlighterBase.StringProc;
begin
  fTokenID := tkString;
  repeat
    if (fLine[Run] = '"') then
    begin
      Inc(Run, 1);
      fRange := rsUnKnown;
      Break;
    end;
    if not IsLineEnd(Run) then
      Inc(Run);
  until IsLineEnd(Run);
end;

procedure TtbSqlHighlighterBase.String2OpenProc;
begin
  Inc(Run);
  fRange := rsString2;
  String2Proc;
  fTokenID := tkString;
end;

procedure TtbSqlHighlighterBase.String2Proc;
begin
  fTokenID := tkString;
  repeat
    if (fLine[Run] = '''') then
    begin
      Inc(Run, 1);
      fRange := rsUnKnown;
      Break;
    end;
    if not IsLineEnd(Run) then
      Inc(Run);
  until IsLineEnd(Run);
end;

constructor TtbSqlHighlighterBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCaseSensitive := False;

  fCommentAttri := TSynHighLighterAttributes.Create(SYNS_AttrComment, SYNS_FriendlyAttrComment);
  fCommentAttri.Style := [fsItalic];
  fCommentAttri.Foreground := clNavy;
  AddAttribute(fCommentAttri);

  fIdentifierAttri := TSynHighLighterAttributes.Create(SYNS_AttrIdentifier, SYNS_FriendlyAttrIdentifier);
  AddAttribute(fIdentifierAttri);

  fKeyAttri := TSynHighLighterAttributes.Create(SYNS_AttrReservedWord, SYNS_FriendlyAttrReservedWord);
  fKeyAttri.Style := [fsBold];
  fKeyAttri.Foreground := clGreen;
  AddAttribute(fKeyAttri);

  fNumberAttri := TSynHighLighterAttributes.Create(SYNS_AttrNumber, SYNS_FriendlyAttrNumber);
  fNumberAttri.Foreground := clFuchsia;
  AddAttribute(fNumberAttri);

  fSpaceAttri := TSynHighLighterAttributes.Create(SYNS_AttrSpace, SYNS_FriendlyAttrSpace);
  AddAttribute(fSpaceAttri);

  fStringAttri := TSynHighLighterAttributes.Create(SYNS_AttrString, SYNS_FriendlyAttrString);
  fStringAttri.Foreground := clRed;
  AddAttribute(fStringAttri);

  fSymbolAttri := TSynHighLighterAttributes.Create(SYNS_AttrSymbol, SYNS_FriendlyAttrSymbol);
  fSymbolAttri.Foreground := clMaroon;
  AddAttribute(fSymbolAttri);

  fTablenameAttri := TSynHighLighterAttributes.Create(SYNS_AttrTablename, SYNS_FriendlyAttrTablename);
  fTablenameAttri.Foreground := clRed;
  AddAttribute(fTablenameAttri);

  SetAttributesOnChange(DefHighlightChange);
  InitIdent;
  fDefaultFilter := SYNS_Filter;
  fRange := rsUnknown;
end;

procedure TtbSqlHighlighterBase.IdentProc;
begin
  fTokenID := IdentKind(fLine + Run);
  inc(Run, fStringLen);
  while IsIdentChar(fLine[Run]) do
    Inc(Run);
end;

procedure TtbSqlHighlighterBase.NumberProc;
begin
  fTokenID := tkNumber;
  inc(Run);
  while FLine[Run] in ['0'..'9'] do inc(Run);
end;

procedure TtbSqlHighlighterBase.SymbolProc;
begin
  fTokenID := tkSymbol;
  inc(Run);
  while FLine[Run] in ['='] do inc(Run);
  while FLine[Run] in ['>'] do inc(Run);
  while FLine[Run] in ['<'] do inc(Run);
  while FLine[Run] in ['!'] do inc(Run);
  while FLine[Run] in ['*'] do inc(Run);
  while FLine[Run] in [';'] do inc(Run);
end;

procedure TtbSqlHighlighterBase.UnknownProc;
begin
  inc(Run);
  fTokenID := tkUnknown;
end;

procedure TtbSqlHighlighterBase.Next;
begin
  fTokenPos := Run;
  case fRange of
    rsBraceComment: BraceCommentProc;
    rsCStyleComment: CStyleCommentProc;
  else
    case fLine[Run] of
      #0: NullProc;
      #10: LFProc;
      #13: CRProc;
      '{': BraceCommentOpenProc;
      '/': CStyleCommentOpenProc;
      '-': Comment1OpenProc;
      '"': StringOpenProc;
      '''': String2OpenProc;
      #1..#9, #11, #12, #14..#32: SpaceProc;
      'A'..'Z', 'a'..'z', '_': IdentProc;
      '0'..'9': NumberProc;
      '=', '>', '<', '!', '*', ';', '|': SymbolProc;
    else
      UnknownProc;
    end;
  end;
  inherited;
end;

function TtbSqlHighlighterBase.GetDefaultAttribute(Index: Integer): TSynHighLighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT: Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER: Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD: Result := fKeyAttri;
    SYN_ATTR_STRING: Result := fStringAttri;
    SYN_ATTR_WHITESPACE: Result := fSpaceAttri;
    SYN_ATTR_SYMBOL: Result := fSymbolAttri;
  else
    Result := nil;
  end;
end;

function TtbSqlHighlighterBase.GetEol: Boolean;
begin
  Result := Run = fLineLen + 1;
end;

function TtbSqlHighlighterBase.GetKeyWords(TokenKind: Integer): UnicodeString;
begin
  Result := 
    'absolute,action,active,actor,add,after,alias,all,allocate,alter,and,a' +
    'ny,are,as,asc,ascending,assertion,async,at,attributes,auto,base_name,b' +
    'efore,begin,between,bit,bit_length,boolean,both,breadth,by,cache,call,' +
    'cascade,cascaded,case,cast,catalog,char_length,character_length,check,' +
    'coalesce,collate,collation,column,commit,committed,completion,computed' +
    ',conditional,connect,connection,constraint,constraints,containing,conv' +
    'ert,corresponding,count,create,cross,current,current_date,current_path' +
    ',current_time,current_timestamp,current_user,cursor,cycle,data,databas' +
    'e,date,day,deallocate,debug,declare,default,deferrable,deferred,delete' +
    ',depth,desc,descending,describe,descriptor,destroy,diagnostics,diction' +
    'ary,disconnect,distinct,do,domain,drop,each,element,else,elseif,end,en' +
    'd-exec,entry_point,equals,escape,except,exception,execute,exists,exit,' +
    'external,extract,factor,false,filter,first,for,foreign,from,full,funct' +
    'ion,general,generator,get,global,grant,group,having,hold,hour,identity' +
    ',if,ignore,immediate,in,inactive,index,initially,inner,input,insensiti' +
    've,insert,instead,intersect,interval,into,is,isolation,join,key,last,l' +
    'eading,leave,left,less,level,like,limit,list,local,loop,lower,match,me' +
    'rge,minute,modify,month,names,national,natural,nchar,new,new_table,nex' +
    't,no,none,not,null,nullif,object,octet_length,of,off,old,old_table,on,' +
    'only,operation,operator,operators,or,order,others,outer,output,overlap' +
    's,pad,parameter,parameters,partial,password,path,pendant,plan,position' +
    ',postfix,prefix,preorder,prepare,preserve,primary,prior,private,privil' +
    'eges,procedure,protected,read,recursive,ref,referencing,relative,repla' +
    'ce,resignal,restrict,retain,return,returns,revoke,right,role,rollback,' +
    'routine,row,rows,savepoint,schema,scroll,search,second,select,sensitiv' +
    'e,sequence,session,session_user,set,shadow,shared,signal,similar,size,' +
    'snapshot,some,space,sqlexception,sqlstate,sqlwarning,start,state,struc' +
    'ture,substring,suspend,symbol,system_user,table,temporary,term,test,th' +
    'en,there,time,timestamp,timezone_hour,timezone_minute,to,trailing,tran' +
    'saction,translate,translation,trigger,trim,true,tuple,type,uncommitted' +
    ',under,union,unique,unknown,update,upper,usage,user,using,value,varcha' +
    'r,variable,varying,view,virtual,visible,wait,when,where,while,with,wit' +
    'hout,work,write,year,zone';
end;

function TtbSqlHighlighterBase.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TtbSqlHighlighterBase.GetTokenAttribute: TSynHighLighterAttributes;
begin
  case GetTokenID of
    tkComment: Result := fCommentAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkNumber: Result := fNumberAttri;
    tkSpace: Result := fSpaceAttri;
    tkString: Result := fStringAttri;
    tkSymbol: Result := fSymbolAttri;
    tkTablename: Result := fTablenameAttri;
    tkUnknown: Result := fIdentifierAttri;
  else
    Result := nil;
  end;
end;

function TtbSqlHighlighterBase.GetTokenKind: Integer;
begin
  Result := Ord(fTokenId);
end;

function TtbSqlHighlighterBase.IsIdentChar(AChar: WideChar): Boolean;
begin
  case AChar of
    '_', '0'..'9', 'a'..'z', 'A'..'Z':
      Result := True;
    else
      Result := False;
  end;
end;

function TtbSqlHighlighterBase.GetSampleSource: UnicodeString;
begin
  Result := 
    'Sample source for: '#13#10 +
    'Syntax Parser/Highlighter';
end;

function TtbSqlHighlighterBase.IsFilterStored: Boolean;
begin
  Result := fDefaultFilter <> SYNS_Filter;
end;

class function TtbSqlHighlighterBase.GetFriendlyLanguageName: UnicodeString;
begin
  Result := SYNS_FriendlyLang;
end;

class function TtbSqlHighlighterBase.GetLanguageName: string;
begin
  Result := SYNS_Lang;
end;

procedure TtbSqlHighlighterBase.ResetRange;
begin
  fRange := rsUnknown;
end;

procedure TtbSqlHighlighterBase.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

function TtbSqlHighlighterBase.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

initialization
{$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TtbSqlHighlighterBase);
{$ENDIF}
end.
