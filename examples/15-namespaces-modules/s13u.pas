{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
unit S13U;

interface

type
  TPoint = record
    X, Y: Integer;
  end;

function MakePoint(AX, AY: Integer): TPoint;
procedure Show(P: TPoint);

implementation

// implementation-only — NOT in the interface section, invisible to consumers (≈ non-pub Rust item)
function HiddenHelper(A: Integer): Integer;
begin
  Result := A * 2;
end;

function MakePoint(AX, AY: Integer): TPoint;
begin
  Result.X := AX;
  Result.Y := AY;
end;

procedure Show(P: TPoint);
begin
  WriteLn('point (', P.X, ',', P.Y, ')');
end;

end.
