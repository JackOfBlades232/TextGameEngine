program Engine; { engine.pas }
{
    The main program for running the text game
    Also contains constants for engine settings
}
uses crt, CheckRes;
const
    MinTerminalWidth = 80;
    MinTerminalHeight = 24;

procedure SaveStates(var SaveTextAttr: integer);
begin
    SaveTextAttr := TextAttr
end;

procedure RestoreStates(SaveTextAttr: integer);
begin
    TextAttr := SaveTextAttr
end;

procedure RaiseTerminalSizeError;
begin
    writeln(ErrOutput, 
        'Please resize terminal, must be at least ', MinTerminalWidth, 
        ' chars in width and ', MinTerminalHeight, ' chars in height!'
    )
end;

label
    Deinitialization;
var
    TerminalResOk: boolean;
    SaveTextAttr: integer;
begin
    SaveStates(SaveTextAttr);
    clrscr;

    TerminalResOk := 
        CheckTerminalResolution(MinTerminalHeight, MinTerminalHeight);
    if not TerminalResOk then
    begin
        RaiseTerminalSizeError;
        goto Deinitialization
    end;

    clrscr;

Deinitialization:
    RestoreStates(SaveTextAttr)
end.
