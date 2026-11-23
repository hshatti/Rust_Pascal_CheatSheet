{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s11_p;

uses SysUtils;

type
  TShape = class
  private
    FKind: string;
  public
    constructor Create(AKind: string);
    function GetKind: string;
    procedure SetKind(const AKind: string);
    property Kind: string read GetKind write SetKind;
    destructor Destroy; override;                     // finalizer ↔ Rust Drop
    class function AreaOf(ARadius: Double): Double;   // static method — no instance needed
    procedure Draw; virtual; abstract;                // abstract — TShape cannot be instantiated
  end;

constructor TShape.Create(AKind: string);
begin
  FKind := AKind;
end;

destructor TShape.Destroy;
begin
  WriteLn('destroying ', FKind);
  inherited Destroy;
end;

function TShape.GetKind: string;
begin
  Result := FKind;
end;

procedure TShape.SetKind(const AKind: string);
begin
  FKind := AKind;
end;

class function TShape.AreaOf(ARadius: Double): Double;
begin
  Result := Pi * ARadius * ARadius;
end;

type
  TCircle = class(TShape)
  public
    constructor Create;
    procedure Draw; override;
  end;

constructor TCircle.Create;
begin
  inherited Create('circle');
end;

procedure TCircle.Draw;
begin
  WriteLn('draw: ', Self.GetKind);
end;

type
  TItems = class
  private
    FList: array of string;
  public
    constructor Create(ACount: Integer);
    function GetItem(AIndex: Integer): string;
    procedure SetItem(AIndex: Integer; const AValue: string);
    property Item[AIndex: Integer]: string read GetItem write SetItem;   // indexed property
  end;

constructor TItems.Create(ACount: Integer);
begin
  SetLength(FList, ACount);
end;

function TItems.GetItem(AIndex: Integer): string;
begin
  Result := FList[AIndex];
end;

procedure TItems.SetItem(AIndex: Integer; const AValue: string);
begin
  FList[AIndex] := AValue;
end;

var
  b: TShape;
  items: TItems;
begin
  b := TCircle.Create;                          // base-type pointer to a descendant instance
  WriteLn('kind = ', b.Kind);                   // kind = circle
  b.Kind := 'square';
  WriteLn('kind2 = ', b.Kind);                  // kind2 = square
  b.Kind := 'circle';

  b.Draw;                                       // draw: circle — virtual dispatch at runtime
  WriteLn('static area = ', Format('%.2f', [TShape.AreaOf(2.0)]));   // static area = 12.57

  items := TItems.Create(3);
  items.Item[0] := 'a'; items.Item[1] := 'b'; items.Item[2] := 'c';
  WriteLn('item[1] = ', items.Item[1]);         // item[1] = b
  items.Item[2] := 'z';                          // indexed property write (setter)
  WriteLn('item[2] = ', items.Item[2]);          // item[2] = z

  b.Free;                                        // → destroying circle
  items.Free;
end.
