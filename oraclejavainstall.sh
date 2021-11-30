function javainstall {
	sudo yum -y install vim 
	sudo yum -y install unzip 
	sudo yum -y install zip 
	sudo yum -y install telnet
	cd /home/"$user"
	if [ -d "/home/${user}/systembuild" ]; then
		echo "already unzip"
	else
	cd /home/"$user"
	sudo unzip /home/"$user"/systembuild.zip
	fi
	sudo mv /home/"$user"/systembuild/jdk-8u121-linux-x64.tar.gz /opt
	cd /opt
	sudo tar xzf /opt/jdk-8u121-linux-x64.tar.gz
	sudo alternatives --install /usr/bin/java java /opt/jdk1.8.0_121/bin/java 2
	psax=$(echo -ne '\n' | sudo alternatives --config java | grep open)
	if [ -z "$psax" ]; then
		sudo alternatives --config java 1
		echo "no openjdk"
	else
		sudo alternatives --config java 2
		echo "have openjdk"
	fi
	sudo alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_121/bin/jar 2
	sudo alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_121/bin/javac 2
	sudo alternatives --set jar /opt/jdk1.8.0_121/bin/jar
	sudo alternatives --set javac /opt/jdk1.8.0_121/bin/javac
	sudo yes | cp -f /home/"$user"/systembuild/profile/.bash_profile /root/
	sudo su -c " chmod 644 /root/.bash_profile"
	sudo su -c "source /root/.bash_profile"
	sudo java -version
}