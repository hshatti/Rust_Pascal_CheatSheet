{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s10var_p;

uses SysUtils;   // Format

type
  TShape = record
    case Kind: Byte of
      0: (X, Y: Integer);   // point variant
      1: (R: Double);       // circle variant
  end;

var
  S: TShape;
begin
  S.Kind := 0; S.X := 3; S.Y := 4;
  WriteLn('point = ', S.X, ',', S.Y);        // point = 3,4
  S.Kind := 1; S.R := 2.5;
  WriteLn('circle r = ', Format('%.1f', [S.R]));   // circle r = 2.5 (default double print is scientific: 2.500...E+000)
end.
