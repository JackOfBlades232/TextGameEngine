unit UI; { ui.pp }
{
    Contains functionality for the ui part of the game
}
interface

procedure InitConstraints(var ok: boolean);
procedure RaiseConstraintsError;

procedure WriteTextPage(var content: string; var ok: boolean);
procedure WriteAnswerVariant(var lbl, content: string; 
    index: integer; var ok: boolean);

function AnswersFitOnScreen(NumAnswers: integer): boolean;

procedure SelectAnswer(index: integer);
procedure SwitchAnswer(var index: integer; DeltaIndex, MaxIndex: integer);

implementation
uses crt, TextWriter, CheckRes;
const
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
    PaddingForSelectSymbol = 2;
var
    TextMinX, TextMaxX, TextMinY, TextMaxY: integer;
    AnswerMinX, AnswerMaxX: integer;

procedure RaiseConstraintsError;
begin
    clrscr;
    writeln(ErrOutput, 'Please change ui parameters or terminal size,',
        ' they are not matching');
end;

{ generally used functions declarations }
function AnswerMinY(index: integer): integer; forward;
function AnswerMaxY(index: integer): integer; forward;

{ constraints preparation }
procedure CalcTextBoxConstraints(CenterX, CenterY: integer); forward;
procedure CalcAnswerHorizConstraints(CenterX: integer); forward;
function ConstraintsFitScreen: boolean; forward;
function MinMaxValuesAreValid(min, max, TrueMin, TrueMax: integer): boolean;
    forward;
function ValueIsPositive(value: integer): boolean; forward;

procedure InitConstraints(var ok: boolean);
var
    CenterX, CenterY: integer;
begin
    CenterX := ScreenWidth div 2;
    CenterY := ScreenHeight div 2;
    CalcTextBoxConstraints(CenterX, CenterY);
    CalcAnswerHorizConstraints(CenterX);

    ok := ConstraintsFitScreen
end;

procedure CalcTextBoxConstraints(CenterX, CenterY: integer);
begin
    TextMinX := CenterX + TextWindowMinXFromCenter; 
    TextMaxX := CenterX + TextWindowMaxXFromCenter; 
    TextMinY := CenterY + TextWindowMinYFromCenter; 
    TextMaxY := CenterY + TextWindowMaxYFromCenter
end;

procedure CalcAnswerHorizConstraints(CenterX: integer);
begin
    AnswerMinX := CenterX + AnswerMinXFromCenter; 
    AnswerMaxX := CenterX + AnswerMaxXFromCenter 
end;

function ConstraintsFitScreen: boolean;
begin
    ConstraintsFitScreen := 
        MinMaxValuesAreValid(TextMinX, TextMaxX, 1, ScreenWidth) and
        MinMaxValuesAreValid(TextMinY, TextMaxY, 1, ScreenHeight) and
        MinMaxValuesAreValid(AnswerMinX, AnswerMaxX, 
            1 + PaddingForSelectSymbol, ScreenWidth) and
        ValueIsPositive(TextToAnswerOffset) and
        ValueIsPositive(AnswerBoxHeight) and
        ValueIsPositive(AnswerScreenBottomMinPadding) and
        AnswersFitOnScreen(1)
end;

function MinMaxValuesAreValid(min, max, TrueMin, TrueMax: integer): boolean;
begin
    MinMaxValuesAreValid := 
        (min <= max) and (min >= TrueMin) and (max <= TrueMax)
end;

function ValueIsPositive(value: integer): boolean;
begin
    ValueIsPositive := value > 0
end;
    
{ validity checking }
function AnswersFitOnScreen(NumAnswers: integer): boolean;
var
    MaxY: integer;
begin
    MaxY := AnswerMaxY(NumAnswers) + AnswerScreenBottomMinPadding;
    AnswersFitOnScreen := MaxY <= ScreenHeight
end;
    

{ text writing }
procedure WriteTextPage(var content: string; var ok: boolean);
begin
    WriteTextToScreen(
        content,
        TextMinX, TextMinY,
        TextMinX, TextMaxX, TextMinY, TextMaxY,
        ok
    )
end;    

procedure WriteAnswerVariant(var lbl, content: string; 
    index: integer; var ok: boolean);
var
    x, MinY, MaxY: integer;
begin
    if (AnswerMaxX - AnswerMinX + 1) < length(lbl) then
    begin
        ok := false;
        exit
    end;

    MinY := AnswerMinY(index);
    MaxY := AnswerMaxY(index);
    x := AnswerMinX;

    WriteTextToScreen(
        lbl,
        x, MinY,
        AnswerMinX, AnswerMaxX, MinY, MaxY,
        ok
    );

    if not ok then
        exit;

    x := x + length(lbl);

    WriteTextToScreen(
        content,
        x, MinY,
        AnswerMinX, AnswerMaxX, MinY, MaxY,
        ok
    )
end;

{ answer selection }
procedure DeselectAnswer(index: integer); forward;
procedure DrawSymbolNextToAnswer(symbol: char; index: integer); forward;
procedure TruncateIndex(var index: integer; MinVal, MaxVal: integer); forward;

procedure SwitchAnswer(var index: integer; DeltaIndex, MaxIndex: integer);
begin
    DeselectAnswer(index);
    index := index + DeltaIndex;
    TruncateIndex(index, 1, MaxIndex);
    SelectAnswer(index)
end;

procedure SelectAnswer(index: integer);
begin
    DrawSymbolNextToAnswer('>', index)
end;

procedure DeselectAnswer(index: integer);
begin
    DrawSymbolNextToAnswer(' ', index)
end;

procedure DrawSymbolNextToAnswer(symbol: char; index: integer);
var
    x, y: integer;
begin
    x := AnswerMinX - PaddingForSelectSymbol;
    y := AnswerMinY(index);
    GotoXY(x, y);
    write(symbol);
    GotoXY(1, 1)
end;

procedure TruncateIndex(var index: integer; MinVal, MaxVal: integer);
begin
    if index < MinVal then
        index := MinVal
    else if index > MaxVal then
        index := MaxVal
end;

{ general helper functions }
function AnswerMinY(index: integer): integer;
begin
    AnswerMinY := TextMaxY + TextToAnswerOffset + 1 +
        (AnswerBoxHeight + AnswerVerticalPadding) * (index - 1)
end;

function AnswerMaxY(index: integer): integer;
begin
    AnswerMaxY := AnswerMinY(index) + AnswerBoxHeight - 1
end;

end.
