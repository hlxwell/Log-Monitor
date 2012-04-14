-module(log_monitor).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
    application:start(log_monitor).

start(_StartType, _StartArgs) ->
    error_logger:info_msg("Starting log_monitor application...~n"),
    log_monitor_sup:start_link().

stop(_State) ->
    ok.
