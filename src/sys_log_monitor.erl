-module(sys_log_monitor).
-export([start/2, stop/0, read_log/1, read_log/2]).

start(Client, LogPath) ->
    spawn(?MODULE, read_log, [{start, Client, LogPath}]).

stop() ->
    ?MODULE ! stop.

read_log({start, Client, LogPath}) ->
    % REMEMBER CLOSE PORT !!!!!!!!!!!!!!!!!!!!!!!!!!
    Port = open_port({spawn, lists:concat(["tail -f ", LogPath])}, [binary,{line, 255}]),
    read_log(Port, Client).

read_log(Port, Client) ->
    receive
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% read all new data
        {Port,{data, {_, Data}}} ->
            Length = length(binary_to_list(Data)),
            if
                Length > 0 ->
                    Client ! {rails_log, binary_to_list(Data)};
                true ->
                    io:format("")
            end,
            read_log(Port, Client);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% encounter EOF
        {Port,eof} ->
            read_log(Client);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% wrong message
        _ ->
            io:format("Sys log monitor ~p is closing...~n", [Port]),
            port_close(Port),
            Client ! {'EXIT', "Sys log monitor is closing..."}
    end.
