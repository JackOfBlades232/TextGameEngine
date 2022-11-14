program Engine; { engine.pas }
{
    The main program for running the text game
    Also contains constants for engine settings
}
uses crt, CheckRes, UI, controls;
const
    FrameDuration = 10; { 0.01s }

procedure SaveStates(var SaveTextAttr: integer);
begin
    SaveTextAttr := TextAttr
end;

procedure RestoreStates(SaveTextAttr: integer);
begin
    TextAttr := SaveTextAttr
end;

procedure InitializeGame(var SaveTextAttr: integer; var ok: boolean);
begin
    SaveStates(SaveTextAttr);

    ok := CheckTerminalResolution;
    if not ok then
    begin
        RaiseTerminalSizeError;
        exit
    end;

    InitConstraints(ok);
    if not ok then
    begin
        RaiseConstraintsError;
        exit
    end;
end;
    
{$IFDEF TEST}
{$ENDIF}

label
    Start, Quit, Deinitialization;
var
    InitializationOk, StringWrittenOk: boolean;
    SaveTextAttr: integer;
    PlayerAction: ControlsAction;
{$IFDEF TEST}
    HelloMsg: string = 'Hello, world!';
    labels: array [1..3] of string;
    answers: array [1..3] of string;
    AnsIndex: integer;
{$ENDIF}
begin
    InitializeGame(SaveTextAttr, InitializationOk);

    if not InitializationOk then
        goto Deinitialization;

Start:
    clrscr;

{$IFDEF TEST}
    StringWrittenOk := AnswersFitOnScreen(length(answers));
    if not StringWrittenOk then
        goto Quit;

    for AnsIndex := 1 to length(labels) do
        labels[AnsIndex] := chr(AnsIndex + ord('a') - 1) + ': ';

    answers[1] := 'Hola back.';
    answers[2] := 'What?';
    answers[3] := 'Bugger off!';

    WriteTextPage(HelloMsg, StringWrittenOk);
    delay(1000);

    for AnsIndex := 1 to length(answers) do
    begin
        delay(100);
        WriteAnswerVariant(labels[AnsIndex], answers[AnsIndex],
            AnsIndex, StringWrittenOk)
    end;

    delay(1000);

    AnsIndex := 1;
    SelectAnswer(AnsIndex);
    delay(100);

    while true do
    begin
        ControlsGet(PlayerAction);
        case PlayerAction of
            PressExit:
                goto Quit;
            PressEnter:
                goto Start;
            PressUp:
                SwitchAnswer(AnsIndex, -1, length(answers));
            PressDown:
                SwitchAnswer(AnsIndex, 1, length(answers))
        end;

        delay(FrameDuration)
    end;
{$ENDIF}

Quit:
    clrscr;

Deinitialization:
    RestoreStates(SaveTextAttr)
end.
