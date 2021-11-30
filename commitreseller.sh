#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

function resellerupdate {
  sudo unzip reseller.zip
  sudo rm -rf src/main/resources/static/reseller*
  mv reseller/* src/main/resources/static/
  git config --global --unset user.name
  git config --global --unset user.email
  git config --global user.name "autodeploy"
  git config --global user.email "mis@insynerger.com"  
  git remote rename origin old-origin
  git remote add origin https://git.insynerger.com/esp/MaintenanceCenter/MaintenanceWeb.git
  git branch -D newbranch
  git branch newbranch
  git branch
  git checkout newbranch   
  git config --list
  sudo git add --all src
  git commit -m "new commit"
  git checkout master
  git merge newbranch
  sudo rm -rf git-push.sh
  /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/git-push.sh
  sudo chmod +x *.sh
  sudo ./git-push.sh 
  echo "SUCCESS"
}
resellerupdate



