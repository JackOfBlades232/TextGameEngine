unit graph; { graph.pp }
{
    Contains tools for constructing and interacting with the graph of the   
    text game.
    0 hash means no content.
}
interface
const
    MaxChildren = 8;
type
    GraphNodePtr = ^GraphNode;
    Answer = record
        hash: integer;
        node: GraphNodePtr;
    end;
    GraphNode = record
        hash: integer;
        answers: array [1..MaxChildren] of Answer;
    end;

function NumAnswers(node: GraphNode): integer;

implementation

procedure ReadGraphFromFile(var f: file; 
    var root: GraphNodePtr, var ok: boolean);
begin
    ok := false;
    if root <> nil then
        exit;
    

function NumAnswers(node: GraphNode): integer;
var
    i: integer;
begin
    NumAnswers := 0;
    for i := 1 to MaxChildren do
        if node.answers[i].hash <> 0 then
            NumAnswers := NumAnswers + 1
end;

end.
