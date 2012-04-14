Server:
  Run: application
  When: received xxx log, 
        it will spawn a xxx_log_monitor,
        then send message back to client.

Client:
  Run: application
  When: connect to Server, and send xxx_log_monitor, then it will get all log.