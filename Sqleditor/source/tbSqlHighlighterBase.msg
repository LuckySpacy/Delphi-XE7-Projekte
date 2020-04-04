TtbSqlHighlighterBase {first Identifier is considered to be the Class Name }
tk              {second Identifier is considered to be the Identifier Prefix }
IdentStart '_', 'a'..'z', 'A'..'Z':: '_', '0'..'9', 'a'..'z', 'A'..'Z'::

TOKENTYPES
Identifier
Comment Style=[fsItalic]|Foreground=clNavy
Space
String Foreground=clRed
Number Foreground=clFuchsia

Key Style=[fsBold]|Foreground=clGreen
Symbol Foreground=clMaroon
Tablename Foreground=clRed
|><|

KEYS
absolute action active actor add after alias all allocate alter
and any are as asc ascending assertion async at attributes auto 
base_name before begin between bit bit_length boolean both breadth by
cache call cascade cascaded case cast catalog char_length
character_length check coalesce collate collation column commit
committed completion computed conditional connect connection constraint
constraints containing convert corresponding count create cross current
current_date current_path current_time current_timestamp current_user
cursor cycle data database date day deallocate debug declare default
deferrable deferred delete depth desc descending describe descriptor
destroy diagnostics dictionary disconnect distinct do domain
drop each element else elseif end end-exec entry_point equals escape
except exception execute exists exit external extract factor false
filter first for foreign from full function general generator get
global grant group having hold hour identity if ignore immediate in
inactive index initially inner input insensitive insert instead
intersect interval into is isolation join key last leading leave left
less level like limit list local loop lower match merge minute modify
month names national natural nchar new new_table next no none not null
nullif object octet_length of off old old_table on only operation
operator operators or order others outer output overlaps pad
parameter parameters partial password path pendant plan position
postfix prefix preorder prepare preserve primary prior private
privileges procedure protected read recursive ref referencing relative
replace resignal restrict retain return returns revoke right role
rollback routine row rows savepoint schema scroll search second select
sensitive sequence session session_user set shadow shared signal
similar size snapshot some space sqlexception sqlstate sqlwarning start
state structure substring suspend symbol system_user table temporary
term test then there time timestamp timezone_hour timezone_minute to
trailing transaction translate translation trigger trim true tuple type
uncommitted under union unique unknown update upper usage user using
value varchar variable varying view virtual visible wait when where
while with without work write year zone
|><|


CHARS

'A'..'Z', 'a'..'z', '_':: Ident
BeginProc
  fTokenID := IdentKind(fLine + Run);
  inc(Run, fStringLen);
  while IsIdentChar(fLine[Run]) do
    Inc(Run);
EndProc


'0'..'9':: Number
BeginProc
  fTokenID := tkNumber;
  inc(Run);
  while FLine[Run] in ['0'..'9'] do inc(Run);
EndProc

'=', '>', '<', '!', '*', ';', '|':: Symbol
BeginProc
  fTokenID := tkSymbol;
  inc(Run);
  while FLine[Run] in ['='] do inc(Run);
  while FLine[Run] in ['>'] do inc(Run);
  while FLine[Run] in ['<'] do inc(Run);
  while FLine[Run] in ['!'] do inc(Run);
  while FLine[Run] in ['*'] do inc(Run);
  while FLine[Run] in [';'] do inc(Run);
EndProc

|><|

ENCLOSEDBY

Comment,BraceComment,{,},MultiLine
Comment,CStyleComment,/*,*/,MultiLine
Comment,Comment1,--,''
String,String,","
String,String2,','

|><|



