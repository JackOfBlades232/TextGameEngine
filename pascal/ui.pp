unit UI; { ui.pp }
interface

procedure InitConstraints;

procedure WriteTextPage(var content: string; var ok: boolean);
procedure WriteAnswerVariant(var lbl, content: string; 
    index: integer; var ok: boolean);

procedure SelectAnswer(index: integer);
procedure SwitchAnswer(var index: integer; DeltaIndex, MaxIndex: integer);

implementation
uses crt, TextWriter;
const
    { TODO : introduce checking for params}
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

{ constraints preparation }
procedure CalcTextBoxConstraints(CenterX, CenterY: integer); forward;
procedure CalcAnswerHorizConstraints(CenterX: integer); forward;

procedure InitConstraints;
var
    CenterX, CenterY: integer;
begin
    CenterX := ScreenWidth div 2;
    CenterY := ScreenHeight div 2;
    CalcTextBoxConstraints(CenterX, CenterY);
    CalcAnswerHorizConstraints(CenterX)
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

    MinY := TextMaxY + 1 + TextToAnswerOffset + 
            (AnswerBoxHeight + AnswerVerticalPadding) * (index - 1);
    MaxY := MinY + AnswerBoxHeight - 1;
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
procedure TruncateIndex(var index: integer; MinVal, MaxVal: integer); forward;

procedure SwitchAnswer(var index: integer; DeltaIndex, MaxIndex: integer);
begin
    DeselectAnswer(index);
    index := index + DeltaIndex;
    TruncateIndex(index, 1, MaxIndex);
    SelectAnswer(index)
end;

procedure SelectAnswer(index: integer);
var
    x, y: integer;
begin
    x := AnswerMinX - 2;
    y := TextMaxY + 1 + TextToAnswerOffset + 
         (AnswerBoxHeight + AnswerVerticalPadding) * (index - 1);
    GotoXY(x, y);
    write('>');
    GotoXY(1, 1)
end;

procedure DeselectAnswer(index: integer);
var
    x, y: integer;
begin
    x := AnswerMinX - 2;
    y := TextMaxY + 1 + TextToAnswerOffset + 
         (AnswerBoxHeight + AnswerVerticalPadding) * (index - 1);
    GotoXY(x, y);
    write(' ');
    GotoXY(1, 1)
end;

procedure TruncateIndex(var index: integer; MinVal, MaxVal: integer);
begin
    if index < MinVal then
        index := MinVal
    else if index > MaxVal then
        index := MaxVal
end;

end.
