program Engine; { engine.pas }
{
    The main program for running the text game
    Also contains constants for engine settings
}
uses crt, CheckRes, TextWriter;
const
    { TODO : introduce checking for params}
    MinTerminalWidth = 80;
    MinTerminalHeight = 24;
    TextWritingDelay = 65; { 0.065s }
    TextWindowMinXFromCenter = -38;
    TextWindowMaxXFromCenter = 38;
    TextWindowMinYFromCenter = -11;
    TextWindowMaxYFromCenter = 2;
    TextToAnswerOffset = 2;
    AnswerMinXFromCenter = -36;
    AnswerMaxXFromCenter = 36;
    AnswerBoxHeight = 1;
    AnswerVerticalPadding = 1;
    AnswerScreenBottomMinPadding = 2;
var
    TextMinX, TextMaxX, TextMinY, TextMaxY: integer;
    AnswerMinX, AnswerMaxX: integer;

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

procedure CalcTextBoxConstraints(CenterX, CenterY: integer;
    var TextMinX, TextMaxX, TextMinY, TextMaxY: integer);
begin
    TextMinX := CenterX + TextWindowMinXFromCenter; 
    TextMaxX := CenterX + TextWindowMaxXFromCenter; 
    TextMinY := CenterY + TextWindowMinYFromCenter; 
    TextMaxY := CenterY + TextWindowMaxYFromCenter
end;

procedure CalcAnswerHorizConstraints(CenterX, CenterY: integer;
    var AnswerMinX, AnswerMaxX : integer);
begin
    AnswerMinX := CenterX + AnswerMinXFromCenter; 
    AnswerMaxX := CenterX + AnswerMaxXFromCenter 
end;

procedure CalcConstraints(var TextMinX, TextMaxX, 
    TextMinY, TextMaxY, AnswerMinX, AnswerMaxX: integer);
var
    CenterX, CenterY: integer;
begin
    CenterX := ScreenWidth div 2;
    CenterY := ScreenHeight div 2;
    CalcTextBoxConstraints(
        CenterX, CenterY, TextMinX, TextMaxX, TextMinY, TextMaxY);
    CalcAnswerHorizConstraints(CenterX, CenterY, AnswerMinX, AnswerMaxX)
end;

procedure WriteTextPage(var content: string; var ok: boolean);
begin
    WriteTextToScreen(
        content,
        TextMinX, TextMinY,
        TextMinX, TextMaxX, TextMinY, TextMaxY,
        TextWritingDelay,
        ok
    )
end;    

procedure WriteAnswerVariant(var lbl, content: string; 
    index: integer; var ok: boolean);
var
    MinY, MaxY: integer;
begin
    MinY := TextMaxY + 1 + TextToAnswerOffset + 
            (AnswerBoxHeight + AnswerVerticalPadding) * (index - 1);
    MaxY := MinY + AnswerBoxHeight - 1;
    WriteTextToScreen(
        content,
        AnswerMinX, MinY,
        AnswerMinX, MinY, AnswerMaxX, MaxY,
        TextWritingDelay,
        ok
    )
end;

label
    Deinitialization;
var
    TerminalResOk, StringWrittenOk: boolean;
    SaveTextAttr: integer;
    { testing }
    HelloMsg: string = 'Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!Hello, world!';
    Lbl1: string = 'a: ';
    Ans1: string = 'Hola back!';
    Lbl2: string = 'b: ';
    Ans2: string = 'What?';
    Lbl3: string = 'c: ';
    Ans3: string = 'Bugger off!';
    AnsIndex: integer;
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

    CalcConstraints(TextMinX, TextMaxX, TextMinY, TextMaxY,
        AnswerMinX, AnswerMaxX);

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

    clrscr;

Deinitialization:
    RestoreStates(SaveTextAttr)
end.
