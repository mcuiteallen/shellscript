#!/usr/bin/expect -f
cd /home
set timeout -1
spawn bash InsynergerRun.sh
expect "Please input Administrator user without root :  "
send -- "vmadmin\r"
expect "Please input Env name for this project :  "
send -- "WAITER\r"
expect "Which product do you choose?"
send -- "inpark\r"
expect "Is this Project install for StandAlone?"
send -- "n\r"
expect "Please input the DataBase IPadress:"
send -- "127.0.0.1\r"
expect "Is this VM install for DataBase?"
send -- "y\r"
expect eof
exit
