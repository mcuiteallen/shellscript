#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

allconnection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity;'" postgres)
insnergydb_connection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity where usename='\''insnergydb'\'';'" postgres)
cserver_connection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity where usename='\''cserver'\'';'" postgres)
gee_connection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity where usename='\''gee'\'';'" postgres)
nserver_connection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity where usename='\''nserver'\'';'" postgres)
statistic_connection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity where usename='\''statistic'\'';'" postgres)
simplerule_connection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity where usename='\''simplerule'\'';'" postgres)
inpark_connection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity where usename='\''inpark'\'';'" postgres)
ectuarybj_connection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity where usename='\''ectuarybj'\'';'" postgres)
inems_connection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity where usename='\''inems'\'';'" postgres)
infactory_connection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity where usename='\''infactory'\'';'" postgres)
isas_connection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity where usename='\''isas'\'';'" postgres)
oauth_connection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity where usename='\''oauth'\'';'" postgres)
ica_connection=$(su -c "psql -U insnergydb -d insnergydb -t -c 'select count(*) from  pg_stat_activity where usename='\''ica'\'';'" postgres)
echo "all_connection  $allconnection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM
echo "insnergydb_connection  $insnergydb_connection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM
echo "cserver_connection  $cserver_connection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM
echo "gee_connection  $gee_connection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM
echo "nserver_connection  $nserver_connection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM
echo "statistic_connection  $statistic_connection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM
echo "simplerule_connection  $simplerule_connection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM
echo "inpark_connection  $inpark_connection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM
echo "ectuarybj_connection  $ectuarybj_connection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM
echo "inems_connection  $inems_connection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM
echo "infactory_connection  $infactory_connection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM
echo "isas_connection  $isas_connection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM
echo "oauth_connection  $oauth_connection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM
echo "ica_connection  $ica_connection" | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/PLATFORM/instance/PLATFORM


