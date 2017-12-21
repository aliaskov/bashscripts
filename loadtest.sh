#!/bin/bash
for run in {1..1000}
do
start=$(date +%s.%N)
git clone -q git@gitlab-production-gitlab.goodgamestudios.com:infrastructure/kibana.git

dur=$(echo "$(date +%s.%N) - $start" | bc)
printf "Git Clone time %.6f seconds  \n " $dur
sleep 2
#let's make a dummy commit+push
start=$(date +%s.%N)
echo "   " >> kibana/README.md
cd kibana
git add README.md
git commit -m "test commit" --quiet
git push origin master --quiet
dur=$(echo "$(date +%s.%N) - $start" | bc)
printf "Git Push time: %.6f seconds  \n " $dur
cd ..
sleep 2
#cleanup
rm -rf kibana && echo "... repo Deleted"
done
