if EXIST lib\bin\tee.exe (
ruby script\server -p 80 | lib\bin\tee -a log\server.log 2>> log\server_err.log
) else (
ruby script\server -p 80
)
