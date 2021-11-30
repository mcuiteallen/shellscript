#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

function tag {
   echo "Release Schema & tag"
   git config --global --unset user.name
   git config --global --unset user.email
   git config --global user.name "autodeploy"
   git config --global user.email "mis@insynerger.com"
   newtagver=$newtagver
   git remote rename origin old-origin
   git remote add origin https://git.insynerger.com/esp/Database.git
   git branch -D newbranch
   git branch newbranch
   git branch
   git checkout newbranch
   cd /root/.jenkins/workspace/Auto-SystemDeploy
   echo "before"
   cat /root/.jenkins/workspace/Auto-SystemDeploy/schema/diff/postgresql.sql
   sudo su -c 'sed -i "/\b\(rem\)\b/d" /root/.jenkins/workspace/Auto-SystemDeploy/schema/diff/postgresql.sql'
   echo "after"
   cat /root/.jenkins/workspace/Auto-SystemDeploy/schema/diff/postgresql.sql
   git add schema
   git commit -m "take off rem"
   git checkout master
   git merge newbranch
   sudo ./git-push.sh   
   git remote rename origin old-origin
   git remote add origin https://git.insynerger.com/esp/Database.git
   git branch -D newbranch
   git branch newbranch
   git branch
   git checkout newbranch   
   git tag -d "$newtagver"
   git tag -a "$newtagver" -m 'Release DB Schema'
   git checkout master
   git merge newbranch
   sudo ./git-push-tag.sh 	
   sudo ./auto-release.sh 	
}

/bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/git-push-tag.sh
/bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/auto-release.sh
/bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/git-push.sh
sudo chmod +x *.sh
echo newtagver = $newtagver
tagorno=$(cat schema/diff/postgresql.sql |  grep nothing  | awk '{print $1}')
oldtagver=$(git describe --tags | cut -d"-" -f 1 | cut -d"." -f 3)
if [ -z ${tagorno} ];
then
    tag
	sudo curl -X POST http://alert-line.insynerger.com:7788/api/deploy/sheet/environment/IOT/${updatetime},${version},${infactoryfrontend},${inems},${inpark},${cs},${gee},${ns},${chart},${edge},${infactorybackend},${ecbj},${ica},${statistic},${statisticcache},${authcenter},${simplerule},${newtagver}/
else
    echo "Nothing to tag!!!"	
	sudo curl -X POST http://alert-line.insynerger.com:7788/api/deploy/sheet/environment/IOT/${updatetime},${version},${infactoryfrontend},${inems},${inpark},${cs},${gee},${ns},${chart},${edge},${infactorybackend},${ecbj},${ica},${statistic},${statisticcache},${authcenter},${simplerule},1.1.${oldtagver}/
fi



