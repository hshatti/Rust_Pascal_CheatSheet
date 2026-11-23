{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s11misc_p;

type
  TWidget = class
    private
      FName: string;
    public
      constructor Create(AName: string);
      function Calc(A: Integer): Integer; overload;
      function Calc(A, B: Integer): Integer; overload;
    published
      property Name: string read FName write FName;
  end;

constructor TWidget.Create(AName: string);
begin
  FName := AName;
end;

function TWidget.Calc(A: Integer): Integer;
begin
  Result := A * 2;
end;

function TWidget.Calc(A, B: Integer): Integer;
begin
  Result := A + B;
end;

var
  w: TWidget;
begin
  w := TWidget.Create('btn');
  WriteLn('name = ', w.Name);            // name = btn — published property (RTTI in Delphi)
  WriteLn('calc1 = ', w.Calc(21));       // calc1 = 42
  WriteLn('calc2 = ', w.Calc(20, 22));   // calc2 = 42
  w.Free;
end.
