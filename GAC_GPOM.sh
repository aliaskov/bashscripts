#!/bin/bash
GITHUBREPO=https://github.com/aliaskov/testrepo.git
REPONAME=/tmp/testrepo
GITHUB_USER=username
GITHUB_PASSWORD=12234

#in case if there is no directory
if [ ! -d $REPONAME ]; then
mkdir $REPONAME 
fi

cd $REPONAME

#if git is not initialized
if [ ! -d .git ]; then
git init
git remote add origin $GITHUBREPO
fi

echo "# testrepo" >> README.md
git add .
git commit -m "initial commit"
git push -u origin master
## git push https://$GITHUB_USER:$GITHUB_PASSWORD@myrepository.biz/file.git --all 


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
