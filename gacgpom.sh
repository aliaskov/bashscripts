#!/bin/bash
#REPONAME="Cloudformation"

for run in {1..1000}
do
  if [ ! -d "Cloudformation" ]; then
    git clone  https://github.com/aliaskov/Cloudformation.git
    cd Cloudformation
  fi
  sleep 2
###let's make a dummy commit+push

  echo "   created by autocommit"$run  >> README.md
  git add *
  git commit -m "test commit $run"
  git status
  git config credential.helper store
  git push origin master
  cd ..
  sleep 2
###cleanup
  rm -rf Cloudformation && echo "... repo Deleted"
done
~        
