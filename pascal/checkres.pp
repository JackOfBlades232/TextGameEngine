unit CheckRes; { checkres.pp }
{ 
    Contains function to check, whether terminal window
        is big enough for provided requirements
}
interface

function CheckTerminalResolution(MinWidth, MinHeight: integer) : boolean;

implementation
uses crt;

function CheckTerminalResolution(MinWidth, MinHeight: integer) : boolean;
begin
    CheckTerminalResolution :=
        (ScreenWidth >= MinWidth) and (ScreenHeight >= MinHeight)
end;

end.
