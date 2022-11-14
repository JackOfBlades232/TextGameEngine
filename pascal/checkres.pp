unit CheckRes; { checkres.pp }
{ 
    Contains function to check, whether terminal window
        is big enough for provided requirements
}
interface
const
    MinTerminalWidth = 80;
    MinTerminalHeight = 24;

function CheckTerminalResolution : boolean;
procedure RaiseTerminalSizeError;

implementation
uses crt;

function CheckTerminalResolution : boolean;
begin
    CheckTerminalResolution := (ScreenWidth >= MinTerminalWidth) and 
                               (ScreenHeight >= MinTerminalHeight)
end;

procedure RaiseTerminalSizeError;
begin
    clrscr;
    writeln(ErrOutput, 
        'Please resize terminal, must be at least ', MinTerminalWidth, 
        ' chars in width and ', MinTerminalHeight, ' chars in height!'
    )
end;

end.
