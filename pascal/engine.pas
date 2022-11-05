program Engine; { engine.pas }
{
    The main program for running the text game
    Also contains constants for engine settings
}
uses crt, CheckRes, TextWriter;
const
    MinTerminalWidth = 80;
    MinTerminalHeight = 24;
    TextWritingDelay = 65; { 0.065s }

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
    clrscr;
    writeln(ErrOutput, 
        'Please resize terminal, must be at least ', MinTerminalWidth, 
        ' chars in width and ', MinTerminalHeight, ' chars in height!'
    )
end;

label
    Deinitialization;
var
    TerminalResOk, StringWrittenOk: boolean;
    SaveTextAttr: integer;
    { testing }
    HelloMsg: string = 'Hello, world!';
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

    { testing } 
    WriteTextToScreen(
        HelloMsg,
        (ScreenWidth - length(HelloMsg)) div 2, (ScreenHeight - 1) div 2, 
        1, ScreenWidth, 1, ScreenHeight,
        TextWritingDelay,
        StringWrittenOk
    );
    delay(1000);

    clrscr;

Deinitialization:
    RestoreStates(SaveTextAttr)
end.
