program Engine; { engine.pas }
{
    The main program for running the text game
    Also contains constants for engine settings
}
uses crt, CheckRes, UI, controls;
const
    { TODO : introduce checking for params}
    FrameDuration = 10; { 0.01s }

procedure SaveStates(var SaveTextAttr: integer);
begin
    SaveTextAttr := TextAttr
end;

procedure RestoreStates(SaveTextAttr: integer);
begin
    TextAttr := SaveTextAttr
end;

label
    Start, Quit, Deinitialization;
var
    TerminalResOk, StringWrittenOk: boolean;
    SaveTextAttr: integer;
    PlayerAction: ControlsAction;
    { testing }
    HelloMsg: string = 'Hello, world!';
    Lbl1: string = 'a: ';
    Ans1: string = 'Hola back!';
    Lbl2: string = 'b: ';
    Ans2: string = 'What?';
    Lbl3: string = 'c: ';
    Ans3: string = 'Bugger off!';
    AnsIndex, NumAnswers: integer;
begin
    SaveStates(SaveTextAttr);

    TerminalResOk := CheckTerminalResolution;
    if not TerminalResOk then
    begin
        RaiseTerminalSizeError;
        goto Deinitialization
    end;

    InitConstraints;

Start:
    clrscr;

    { testing } 
    WriteTextPage(HelloMsg, StringWrittenOk);
    delay(1000);

    AnsIndex := 1;
    WriteAnswerVariant(Lbl1, Ans1, AnsIndex, StringWrittenOk);
    delay(100);
    AnsIndex := AnsIndex + 1;
    WriteAnswerVariant(Lbl2, Ans2, AnsIndex, StringWrittenOk);
    delay(100);
    AnsIndex := AnsIndex + 1;
    WriteAnswerVariant(Lbl3, Ans3, AnsIndex, StringWrittenOk);
    delay(1000);

    NumAnswers := AnsIndex;

    AnsIndex := 1;
    SelectAnswer(AnsIndex);
    delay(100);

    ControlsGet(PlayerAction); { clear buffer }

    while true do
    begin
        ControlsGet(PlayerAction);
        case PlayerAction of
            PressExit:
                goto Quit;
            PressEnter:
                goto Start;
            PressUp:
                SwitchAnswer(AnsIndex, -1, NumAnswers);
            PressDown:
                SwitchAnswer(AnsIndex, 1, NumAnswers)
        end;

        delay(FrameDuration)
    end;

Quit:
    clrscr;

Deinitialization:
    RestoreStates(SaveTextAttr)
end.
