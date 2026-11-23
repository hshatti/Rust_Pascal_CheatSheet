{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s11abs_p;

type
  TShape = class
  public
    procedure Draw; virtual; abstract;
  end;

var
  b: TShape;
begin
  b := TShape.Create;   // EXPECTED COMPILE ERROR — abstract class cannot be instantiated
end.
