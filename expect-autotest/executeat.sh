#!/usr/bin/expect -f
cd /home
set timeout -1
spawn bash InsynergerRun.sh
expect "Please input Administrator user without root :  "
send -- "vmadmin\r"
expect "Please input Env name for this project :  "
send -- "WAITER\r"
expect "Which product do you choose?"
send -- "at\r"
expect "Is this Project install for StandAlone?"
send -- "y\r"
expect eof
exit
