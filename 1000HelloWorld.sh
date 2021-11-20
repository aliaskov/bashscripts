#!/bin/bash
for run in {1..1000}
do
  echo "Good morning!"
  echo $run
  sleep 2
  date +"%H:%M:%S"
done
