#!/bin/bash
cd /root/.jenkins/workspace/Release-DB-Schema
sudo rm -rf /home/postgres/schema
sudo rm -rf *.out
sudo su -c "sudo cp -R -f schema /home/postgres/" postgres
psql -U postgres  -f /home/postgres/autotest/create.sql
nohup psql -U autotestdb -d autotestdb -f /home/postgres/schema/ems_ddl_postgresql.sql > ddl.out 2>&1
nohup psql -U autotestdb -d autotestdb -f /home/postgres/schema/ACL/ACL_for_postgres.sql > acl.out 2>&1
nohup psql -U autotestdb -d autotestdb -f /home/postgres/schema/quartz/table_postgresql.sql > quartz.out 2>&1
nohup psql -U autotestdb -d autotestdb -f /home/postgres/schema/oauth/postgresql_oauth_table_schema.sql > oauth.out 2>&1
nohup psql -U autotestdb -d autotestdb -f /home/postgres/schema/ems_dml_postgresql.sql > dml.out 2>&1
nohup psql -U autotestdb -d autotestdb -f /home/postgres/schema/ems_dml_ATTRID_MAPPING.sql > attrid.out 2>&1
ddlerror=$(grep 'ERROR' ddl.out)
aclerror=$(grep 'ERROR' acl.out)
quartzerror=$(grep 'ERROR' quartz.out)
oautherror=$(grep 'ERROR' oauth.out)
dmlerror=$(grep 'ERROR' dml.out)
attriderror=$(grep 'ERROR' attrid.out)
#sqlList=( $ddlerror $aclerror $quartzerror $oautherror $dmlerror $attriderror )
#echo $dmlerror
#for i in "${sqlList[@]}"
#do
#    errorcheck $i
#done

if [ -z "$ddlerror" ]; then
    echo "OK"
else
    echo "error(DDL)" >> result.out 2>&1
fi

if [ -z "$aclerror" ]; then
    echo "OK"
else
    echo "error(ACL_DDL)" >> result.out 2>&1
fi

if [ -z "$quartzerror" ]; then
    echo "OK"
else
    echo "error(QUARTZ_DDL)" >> result.out 2>&1
fi

if [ -z "$oautherror" ]; then
    echo "OK"
else
    echo "error(OAUTH_DDL)" >> result.out 2>&1
fi

if [ -z "$dmlerror" ]; then
    echo "OK"
else
    echo "error(DML)" >> result.out 2>&1
fi

if [ -z "$attriderror" ]; then
    echo "OK"
else
    echo "error(ATTRID)" >> result.out 2>&1
fi
sudo touch result.out
resulterror=$(grep 'error' result.out)

if [ -z "$resulterror" ]; then
    echo "Release Schema & tag"
    git config --global --unset user.name
    git config --global --unset user.email
    git config --global user.name "autodeploy"
    git config --global user.email "mis@insynerger.com"
    oldtagver=$(git describe --tags | cut -d"-" -f 1 | cut -d"." -f 3)
    newtagver=$((oldtagver + 1))
    echo "newtagver: 1.1."$newtagver
    git remote rename origin old-origin
    git remote add origin https://git.insynerger.com/esp/Database.git
    git branch -D newbranch
    git branch newbranch
    git branch
    git checkout newbranch
    git tag -d "1.1.$newtagver"
    git tag -a "1.1.$newtagver" -m 'Release DB Schema'
    git checkout master
    git merge newbranch
    git diff
    sudo ./git-push-tag.sh 
else
    echo "It was nothing to do because schema had error"
	exit 1
fi

