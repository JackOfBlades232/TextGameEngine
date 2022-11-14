unit OpenFile; { openfile.pp }
{
    contains functionality for read-opening text files
}
interface

procedure TryOpenFile(var f: file; name: string, var ok: boolean);
procedure RaiseOpenFileError;

implementation
uses crt;

procedure TryOpenFile(var f: file; name: string, var ok: boolean);
begin
    {$I-}
    assign(f, name);
    reset(f, 1);
    ok := IOResult = 0
end;

procedure RaiseOpenFileError;
begin
    clrscr;
    writeln(ErrOutput, 'Couldn''t open ', name)
end;

end.
