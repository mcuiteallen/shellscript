#!/usr/bin/expect -f
set timeout -1
spawn git push origin --tags
expect "Username for 'https://git.insynerger.com': "
send -- "autodeploy\r"
expect "Password for 'https://autodeploy@git.insynerger.com':"
send -- "Hk4g4hk4g4123\r"
expect eof
exit
