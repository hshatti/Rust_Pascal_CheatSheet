{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
unit S11PrivU;

interface

type
  TBox = class
  private
    FVal: Integer;
  public
    function Get: Integer;
  end;

implementation

function TBox.Get: Integer;
begin
  Result := FVal;
end;

end.
