#!/bin/bash
for run in {1..1000}
do
  echo "Hello world!"
  echo $run
  echo "Good Morning!"
  sleep 2
  date +"%H:%M:%S"
done
