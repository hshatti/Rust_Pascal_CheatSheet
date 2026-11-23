{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s10priv2;

type
  TBox = record
    private
      FVal: Integer;
    public
      function Get: Integer;
  end;

function TBox.Get: Integer;
begin
  Result := FVal;
end;

type
  TOther = record
    procedure Show(b: TBox);
  end;

procedure TOther.Show(b: TBox);
begin
  WriteLn('cross-type: ', b.FVal);   // access from ANOTHER type — enforced?
end;

var
  b: TBox;
  o: TOther;
begin
  o.Show(b);
end.
