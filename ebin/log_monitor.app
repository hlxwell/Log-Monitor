{application,log_monitor,
             [{description,"Monitoring all system log."},
              {vsn,"0.0.1"},
              {registered,[]},
              {applications,[kernel,stdlib]},
              {mod,{log_monitor,[]}},
              {env,[]},
              {modules,[client,log_monitor,log_monitor_server,log_monitor_sup,
                        sys_log_monitor]}]}.
