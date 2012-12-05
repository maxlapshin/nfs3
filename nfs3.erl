#!/usr/bin/env escript

-mode(compile).




% unok({ok, Files, _}) -> Files.

main(["scan", URL]) ->
  code:add_pathz("ebin"),
  {ok, Remote} = nfs3:init(URL),
  T1 = erlang:now(),

  {ok, S1, _Remote1} = nfs3:scan(Remote),

  T2 = erlang:now(),

  io:format("~B entries in ~B ms~n", [length(S1), timer:now_diff(T2,T1) div 1000]),

  F = fun
    (_, _, 0) -> ok;
    (_, [], _) -> ok;
    (G, [Path|Paths], Count) -> io:format("~s~n", [Path]), G(G, Paths, Count - 1)
  end,
  F(F, S1, 20),

  % S2 = [filename:join([Y,Mon,D,H,Min,Sec]) ||
  %   Y <- unok(list_dir(Remote, "")),
  %   Mon <- unok(list_dir(Remote, Y)),
  %   D <- unok(list_dir(Remote, filename:join([Y,Mon]))),
  %   H <- unok(list_dir(Remote, filename:join([Y,Mon,D]))),
  %   Min <- unok(list_dir(Remote, filename:join([Y,Mon,D,H]))),
  %   Sec <- unok(list_dir(Remote, filename:join([Y,Mon,D,H,Min])))
  % ],

  % T3 = erlang:now(),
  % io:format("~B entries in ~B ms~n", [length(S2), timer:now_diff(T3,T2) div 1000]),
  ok;


main(["read", URL, Path]) ->
  code:add_pathz("ebin"),
  {ok, Remote} = nfs3:init(URL),
  T1 = erlang:now(),
  {ok, Bin, _Remote1} = nfs3:read_file(Remote, Path),
  T2 = erlang:now(),
  io:format("Read file ~B bytes in ~B ms~n", [size(Bin), timer:now_diff(T2,T1) div 1000]),
  ok;


main(["write", URL, Path, Content]) ->
  code:add_pathz("ebin"),
  {ok, Remote} = nfs3:init(URL),
  {ok, Obj, _Remote1} = nfs3:create(Remote, Path),
  ok = nfs3:write(Remote, Obj, 0, iolist_to_binary([Content, "\n"])),
  ok;


main(["delete", URL, Path]) ->
  code:add_pathz("ebin"),
  {ok, Remote} = nfs3:init(URL),
  nfs3:delete_r(Remote, Path),
  ok;


main([]) ->
  io:format("scan nfs://uid:gid@host/mount//root\n"),
  io:format("read nfs://uid:gid@host/mount//root path/to/file\n"),
  io:format("write nfs://uid:gid@host/mount//root path/to/file text\n"),
  io:format("delete nfs://uid:gid@host/mount//root path/to/file\n"),
  ok.
