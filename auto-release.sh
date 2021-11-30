#!/bin/bash
git config --global --unset user.name
git config --global --unset user.email
git config --global user.name "autodeploy"
git config --global user.email "mis@insynerger.com"
git remote rename origin old-origin
git remote add origin https://git.insynerger.com/esp/Database.git
git branch -D newbranch
git branch newbranch
git branch
git checkout newbranch
cd /root/.jenkins/workspace/Auto-SystemDeploy
rm -rf schema/diff/postgresql.sql
cp -f schema/diff/grantsample.sql schema/diff/postgresql.sql
git add schema
git commit -m "clean up diff"
git checkout master
git merge newbranch
sudo ./git-push.sh
