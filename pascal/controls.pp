unit controls; { controls.pp }
interface

type
    ControlsAction = 
        (Idle, PressUp, PressDown, PressEnter, PressExit);

procedure ControlsGet(var action: ControlsAction);

implementation
uses crt;
procedure GetKey(var code: integer); forward;

procedure ControlsGet(var action: ControlsAction);
var
    code: integer;
begin
    if not KeyPressed then
        action := Idle
    else
    begin
        GetKey(code);
        case code of
            119: { w }
                action := PressUp;
            115: { s }
                action := PressDown;
            13: { enter }
                action := PressEnter;
            27: { escape }
                action := PressExit
        end
    end
end;

procedure GetKey(var code: integer);
var
    c: char;
begin
    c := ReadKey;
    if c = #0 then
    begin
        c := ReadKey;
        code := -ord(c)
    end
    else
    begin
        code := ord(c)
    end
end;

end.
