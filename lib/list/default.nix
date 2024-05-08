{ lib, ... }:
with lib;
{
  range =
    begin: end:
    assert builtins.isInt begin;
    assert builtins.isInt end;

    if begin >= end then [ ] else [ begin ] ++ range (begin + 1) end;
}
