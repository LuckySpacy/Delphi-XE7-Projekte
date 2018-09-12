{
Copyright:      2002 Hagen Reddmann
Author:         Hagen Reddmann, HaReddmann bei T-Online punkt de
Remarks:        All rights reserved
Version:        open source, developed on D5
Description:    derivate of RC5 stream cipher with internal cipher feedback and stronger keysetup
                includes secure one way pseudo random number generator
}

unit RCx; 
{$A+,B-,C-,D-,E-,F-,G+,H+,I-,J+,K-,L-,M-,N+,O+,P+,Q-,R-,S-,T-,U+,V+,W-,X+,Y-,Z1} 

interface 

type 
  TRCxContext = record 
    D: array[Byte] of Byte; 
    I,J,F: Byte; 
  end; 

procedure RCxInit(var RCx: TRCxContext; const Key; KeySize: Integer); overload; 
procedure RCxInit(var RCx: TRCxContext; const Key: String); overload; 
procedure RCxEncode(var RCx: TRCxContext; const Source; var Dest; Count: Integer); overload; 
function  RCxEncode(var RCx: TRCxContext; const Value: String): String; overload; 
procedure RCxDecode(var RCx: TRCxContext; const Source; var Dest; Count: Integer); overload; 
function  RCxDecode(var RCx: TRCxContext; const Value: String): String; overload; 
procedure RCxDone(var RCx: TRCxContext); overload; 

// all in one encode/decode 
function  RCxEncode(const Value, Password: String): String; overload; 
function  RCxDecode(const Value, Password: String): String; overload; 

// random number generator based on RCx
procedure RCxSeed(const Seed; SeedSize: Integer); overload; 
procedure RCxSeed(const Seed: String); overload; 
procedure RCxRandomize; overload;
function  RCxRandom(Range: Cardinal = 0): Cardinal; overload;
function  RCxRandomString(Length: Integer): String; overload;

implementation

uses Windows;

type
  PByteArray = ^TByteArray;
  TByteArray = array[0..MaxInt -1] of Byte;

procedure RCxInit(var RCx: TRCxContext; const Key; KeySize: Integer);
var
  R,S,T,K: Byte;
  L: Integer;
  M: array[Byte] of Byte;
begin
  with RCx do
  try
    L := 0;
    for S := 0 to 255 do
    begin
      D[S] := S; 
      M[S] := TByteArray(Key)[S mod KeySize] xor L; 
      L := (L + M[S] * 257) mod MaxInt +1; 
    end; 
    I := 0; 
    J := 0; 
    R := L; 
    F := L shr 8; 
    for S := 0 to 255 do 
    begin 
      Inc(R, D[S] + M[S]); 
      T    := D[S]; 
      D[S] := D[R];
      D[R] := T; 
    end; 
  finally 
    R := 0; 
    S := 0; 
    T := 0; 
    L := 0; 
    FillChar(M, SizeOf(M), 0); 
  end; 
end; 

procedure RCxInit(var RCx: TRCxContext; const Key: String); 
begin 
  RCxInit(RCx, Pointer(Key)^, Length(Key)); 
end;

procedure RCxDone(var RCx: TRCxContext); 
begin 
  FillChar(RCx, SizeOf(RCx), 0); 
end; 

procedure RCxEncode(var RCx: TRCxContext; const Source; var Dest; Count: Integer); 
var 
  S: TByteArray absolute Source; 
  O: TByteArray absolute Dest; 
  C: Integer; 
  T,K: Byte; 
begin 
  with RCx do 
    for C := 0 to Count -1 do 
    begin 
      Inc(I);
      T := D[I]; 
      Inc(J, T); 
      D[I] := D[J] xor F; 
      D[J] := T - F; 
      Inc(T, D[I]); 

      K := S[C]; 
      O[C] := K xor D[T]; 
      F := F xor K; 
    end; 
end;

procedure RCxDecode(var RCx: TRCxContext; const Source; var Dest; Count: Integer); 
var 
  S: TByteArray absolute Source; 
  O: TByteArray absolute Dest; 
  C: Integer; 
  T,K: Byte; 
begin 
  with RCx do 
    for C := 0 to Count -1 do 
    begin 
      Inc(I); 
      T := D[I]; 
      Inc(J, T); 
      D[I] := D[J] xor F; 
      D[J] := T - F; 
      Inc(T, D[I]); 

      K := S[C] xor D[T]; 
      O[C] := K; 
      F := F xor K;
    end; 
end; 

function RCxEncode(var RCx: TRCxContext; const Value: String): String; 
var 
  Count: Integer; 
begin
  Count := Length(Value); 
  SetLength(Result, Count); 
  RCxEncode(RCx, Value[1], Result[1], Count); 
end; 

function RCxDecode(var RCx: TRCxContext; const Value: String): String; 
var 
  Count: Integer; 
begin 
  Count := Length(Value); 
  SetLength(Result, Count); 
  RCxDecode(RCx, Value[1], Result[1], Count); 
end; 

function RCxEncode(const Value, Password: String): String; 
var 
  RCx: TRCxContext; 
begin 
  RCxInit(RCx, Password); 
  try 
    Result := RCxEncode(RCx, Value); 
  finally 
    RCxDone(RCx); 
  end; 
end;

function RCxDecode(const Value, Password: String): String; 
var
  RCx: TRCxContext; 
begin 
  RCxInit(RCx, Password); 
  try 
    Result := RCxDecode(RCx, Value); 
  finally 
    RCxDone(RCx); 
  end; 
end; 

var 
  FRCxRegister: TRCxContext; 

procedure RCxSeed(const Seed; SeedSize: Integer); 
begin 
  RCxInit(FRCxRegister, Seed, SeedSize); 
end; 

procedure RCxSeed(const Seed: String); 
begin 
  RCxSeed(Pointer(Seed)^, Length(Seed)); 
end; 

procedure RCxRandomize; 
var 
  Tick: Cardinal; 
begin 
  Tick := GetTickCount;
  FRCxRegister.F := Tick;
  FRCxRegister.I := Tick shr 8; 
  FRCxRegister.J := Tick shr 16; 
  RCxEncode(FRCxRegister, FRCxRegister.D, FRCxRegister.D, SizeOf(FRCxRegister.D)); 
end; 

function RCxRandom(Range: Cardinal): Cardinal; 
type 
  PCardinal = ^Cardinal; 
begin 
  RCxEncode(FRCxRegister, FRCxRegister.D, FRCxRegister.D, SizeOf(FRCxRegister.D)); 
  Result := PCardinal(@FRCxRegister.D)^; 
  if Range > 1 then Result := Result mod Range; 
end; 

function RCxRandomString(Length: Integer): String; 
var 
  I: Integer; 
begin 
  SetLength(Result, Length); 
  for I := 1 to Length do 
  begin 
    RCxEncode(FRCxRegister, FRCxRegister.D, FRCxRegister.D, SizeOf(FRCxRegister.D)); 
    Result[I] := Char(FRCxRegister.D[0]); 
  end; 
end; 

const 
  FRCxSeed: TGUID = '{F4D35205-2B59-42B0-8B8F-239855B6DD2B}'; 
initialization 
  RCxSeed(FRCxSeed, SizeOf(FRCxSeed)); 
finalization 
end.
