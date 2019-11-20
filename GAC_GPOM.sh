#!/bin/bash
GITHUBREPO=https://github.com/aliaskov/testrepo.git
REPONAME=testrepo


if [ ! -d $REPONAME ]; then
mkdir $REPONAME 
fi
cd $REPONAME
if [ ! -d .ssh ]; then
git init
git remote add origin $GITHUBREPO
fi
echo "# testrepo" >> README.md
git add .
git commit -m "initial commit"
git push -u origin master
## git push https://username:password@myrepository.biz/file.git --all 



for run in {1..10}
do
  sleep 1
###let's make a dummy commit
  date >> README.md
  git add .
  git commit -m "test commit $run"
  git status
done
git push
