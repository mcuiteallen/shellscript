#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done
echo ip = $ip

function postgresinstall {
if [ -d "/home/${user}/systembuild/postgres" ]; then
    echo "already unzip"
else
cd /home/"$user"
sudo unzip /home/"$user"/systembuild.zip    
fi
sudo yum -y install wget
if [ -d "/opt/prometheus" ]; then
    echo "already install prometheus"
else
    sudo cp /home/"$user"/systembuild/prometheus.zip /opt
    sudo unzip /opt/prometheus.zip
    sudo chmod +x /opt/prometheus/*.sh
    sudo chmod +x /opt/prometheus/node_exporter-0.15.2.linux-amd64/start-enable/*.sh
    sudo chmod +x /opt/prometheus/node_exporter-0.15.2.linux-amd64/node_exporter
    sudo /opt/prometheus/node_exporter-0.15.2.linux-amd64/start-enable/./install.sh 
	sudo chmod 644 /usr/lib/systemd/system/*node.service
	sleep 3
	sudo systemctl start start_node
fi
cd /home/"$user"
sudo rpm -ivh pgdg-centos11-11-2.noarch.rpm
sudo yum -y install postgresql11-server postgresql11 
sudo /usr/pgsql-11/bin/postgresql-11-setup initdb
sudo systemctl start postgresql-11
sudo systemctl enable postgresql-11
sudo mkdir /home/postgres
sudo su -c 'yes | cp -f /root/.bash_profile /home/postgres'
sudo su -c 'yes | cp -f /root/.bashrc /home/postgres'
sudo chown -R postgres:postgres /home/postgres 
cd /etc
sudo su -c 'sed -i "/\b\(postgres\)\b/d" ./passwd'
sudo su -c " echo -ne "postgres:x:26:26::/home/postgres:/bin/bash" >> ./passwd"
string1="yes | cp -f /home/${user}/systembuild/postgres/.bash_profile /home/postgres"
sudo su -c "$string1"
sudo chown -R postgres:postgres /home/postgres 
sudo su -c " chmod 644 /home/postgres/.bash_profile"
sudo su -c "source /home/postgres/.bash_profile"
string2="yes | cp -f /home/${user}/sql.zip /home/postgres"
sudo su -c "$string2"
sudo rm -rf /usr/pgsql-11/
string5="yes | cp -f /home/${user}/systembuild/postgres/pgsql.zip /usr"
sudo su -c "$string5"
cd /usr
sudo unzip /usr/pgsql.zip
cd /home/postgres
sudo unzip /home/postgres/sql.zip
string3="yes | cp -f /home/${user}/systembuild/postgres/postgresql.conf /var/lib/pgsql/11/data"
string4="yes | cp -f /home/${user}/systembuild/postgres/pg_hba.conf /var/lib/pgsql/11/data"
sudo su -c "$string3"
sudo su -c "$string4"
sudo su -c "chmod 700 /var/lib/pgsql/11/data/*.conf"
sudo su -c "chmod 700 /var/lib/pgsql/11/data/PG_VERSION"
sudo su -c "chmod 700 /var/lib/pgsql/11/data/postmaster.opts"
sudo systemctl stop postgresql-11
sudo systemctl start postgresql-11
sudo su -c "chown -R postgres:postgres /home/postgres"
sudo su -c "psql -f /home/postgres/sql/create.sql" postgres
sudo su -c "psql -U insnergydb -d insnergydb -f /home/postgres/sql/ddl.sql" postgres
sudo su -c "psql -U insnergydb -d insnergydb -f /home/postgres/sql/acl.sql" postgres
sudo su -c "psql -U insnergydb -d insnergydb -f /home/postgres/sql/dml.sql" postgres
sudo su -c "psql -U insnergydb -d insnergydb -f /home/postgres/sql/attrid.sql" postgres
sudo su -c "psql -U insnergydb -d insnergydb -f /home/postgres/sql/quartz.sql" postgres
sudo su -c "psql -U auth -d auth -f /home/postgres/sql/oauth.sql" postgres
sudo su -c "psql -U insnergydb -d insnergydb -f /home/postgres/sql/grant.sql" postgres
sudo su -c "psql -U insnergydb -d insnergydb -f /home/postgres/sql/partition.sql" postgres
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --zone=public --add-port=5432/tcp --permanent
sudo firewall-cmd --reload
sudo cp /home/"$user"/systembuild/dbadmin-3.0.zip /opt
sudo unzip /opt/dbadmin-3.0.zip
sudo chmod +x /opt/dbadmin-3.0/*.sh
LIST=`crontab -l`
SOURCE="/opt/dbadmin-3.0/dbadmin.sh"
SOURCE1="/opt/prometheus/cron.sh > /dev/null"
SOURCE2="(/usr/sbin/ntpdate pool.ntp.org;/usr/sbin/hwclock -w)"
if echo "$LIST" | grep -q "$SOURCE"; then
   echo "The back job had been added.";
else
   sudo crontab -l | { cat; echo "0 0 * * * $SOURCE"; } | crontab -
fi
if echo "$LIST" | grep -q "$SOURCE1"; then
   echo "The back job had been added.";
else
   sudo crontab -l | { cat; echo "*/59 * * * * $SOURCE1"; } | crontab -
fi
if echo "$LIST" | grep -q "$SOURCE2"; then
   echo "The back job had been added.";
else
   sudo crontab -l | { cat; echo "0 * * * * $SOURCE2"; } | crontab -
fi
sudo /opt/dbadmin-3.0/./dbadmin.sh
}


function remove {
	sudo systemctl stop postgresql-11
	sudo yum -y remove postgresql11-server postgresql11 
	sudo rm -rf /usr/pgsql-11/
	sudo rm -rf /usr/lib/systemd/system/postgresql-11
	sudo rm -rf /home/postgres
	cd /etc
	sudo su -c 'sed -i "/\b\(postgres\)\b/d" ./passwd'
	sudo rm -rf /var/lib/pgsql*
	sudo systemctl disable start_node.service
	sudo rm -rf /usr/lib/systemd/system/start_node.service
	sudo rm -rf /opt/prometheus*
	sudo rm -rf /opt/dbadmin-3.0*
}

remove
postgresinstall


