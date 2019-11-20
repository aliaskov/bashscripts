#!/bin/bash
GITHUBREPO=https://github.com/aliaskov/testrepo.git
REPONAME=testrepo


if [ ! -d $REPONAME ]; then
echo "# testrepo" >> README.md
git init
git add .
git commit -m "initial commit"
git remote add origin $GITHUBREPO
git push -u origin master
## git push https://username:password@myrepository.biz/file.git --all 
fi




for run in {1..10}
do
  sleep 1
###let's make a dummy commit+push
  date >> README.md
  git add .
  git commit -m "test commit $run"
  git status
  git push
done
