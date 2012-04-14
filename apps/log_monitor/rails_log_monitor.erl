-module(rails_log_monitor).
-compile(export_all).

% get_message() ->
%     ?MODULE:start(self()),
%     receive
%         {rails_log, Data} ->
%             io:format("~p~n", [Data])
%     end.

start(Client) ->
    Port = open_port({spawn,"tail -f /Users/michaelhe/projects/work/recorder/log/development.log"},[binary,{line, 255}]),
    register(?MODULE, spawn(?MODULE, read_log, [Port, Client])).

stop() ->
    ?MODULE ! stop.

read_log(Port, Client) ->
    receive
        % read all new data
        {Port,{data, {_, Data}}} ->
            Length = length(binary_to_list(Data)),
            if
                Length > 0 ->
                    Client ! {rails_log, binary_to_list(Data)},
                    io:format("~p~n",[binary_to_list(Data)]);
                true ->
                    io:format("~n")
            end;
        % encounter EOF
        {Port,eof} ->
            read_log(Port, Client);
        % wrong message
        Any ->
            io:format("No match pipe:do_read/1, ~p~n",[Any])
    end,
    read_log(Port, Client).