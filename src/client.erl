-module(client).
-export([start/0, stop/0, get_message/0]).

-define(SYS_LOG_PATH, "/var/log/system.log").
-define(RAILS_LOG_PATH, "/Users/michaelhe/projects/work/recorder/log/development.log").

start() ->
    Pid = spawn(?MODULE, get_message, []),
    gen_server:cast({log_monitor_server, 'log_monitor@michael-hes-MacBook-Pro'}, {rails_log, Pid, ?SYS_LOG_PATH}).

stop() ->
    gen_server:cast({log_monitor_server, 'log_monitor@michael-hes-MacBook-Pro'}, {stop}).

get_message() ->
    receive
        {rails_log, Data} ->
            io:format("~p~n", [Data]),
            get_message();
        {'EXIT', Msg} ->
            io:format("~p~n", [Msg])
    end.
