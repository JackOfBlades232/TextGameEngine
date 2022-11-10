unit TextWriter; { textwriter.pp }
{
    Contains functionality for writing strings to screen char by char
    with delays, to create a typewriter effect
}
interface

procedure WriteTextToScreen(
    var TextStr: string; 
    x, y, MinX, MaxX, MinY, MaxY: integer; 
    var ok: boolean
);

implementation
uses crt;
const
    TextWritingDelay = 65; { 0.065s }

function ConstraintsAreValid(MinX, MaxX, MinY, MaxY: integer) : boolean;
begin
    ConstraintsAreValid := 
        (MinX >= 1) and (MaxX >= MinX) and (MaxX <= ScreenWidth) and
        (MinY >= 1) and (MaxY >= MinY) and (MaxY <= ScreenHeight)
end;

function CoordinatesAreValid(x, y, MinX, MaxX, MinY, MaxY: integer) : boolean;
begin
    CoordinatesAreValid := 
        (x >= MinX) and (x <= MaxX) and (y >= MinY) and (y <= MaxY)
end;

procedure WriteTextToScreen(
    var TextStr: string; 
    x, y, MinX, MaxX, MinY, MaxY: integer; 
    var ok: boolean
);
var
    i: integer;
begin
    ok := false;
    if not ConstraintsAreValid(MinX, MaxX, MinY, MaxY) then
        exit;
    if not CoordinatesAreValid(x, y, MinX, MaxX, MinY, MaxY) then
        exit;

    ok := true;

    GotoXY(x, y);
    for i := 1 to length(TextStr) do
    begin
        delay(TextWritingDelay);
        write(TextStr[i]);
        x := x + 1;
        
        if (i < length(TextStr)) and (x > MaxX) then
        begin
            x := MinX;
            y := y + 1;
            if y > MaxY then
                exit
            else
                GotoXY(x, y)
        end
    end;

    ok := true
end;

end.
