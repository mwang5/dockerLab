#!/bin/bash

#function getrepo() {
#  git clone <repo>
#}

function clean_bench(){
  docker-compose down -v
}

function start() {
  docker-compose up --build -d 1>&2
}

function run_bench() {
  AGENT=$(docker-compose ps -q agent)
  echo waiting for agent container to exit $AGENT 1>&2
  docker wait $AGENT 1>&2
}

function copyevents() {
  TARGET1=$(docker-compose ps -q target_1)
  TARGET2=$(docker-compose ps -q target_2)
  docker cp $TARGET1:/usr/app/events.log ./events1.log
  docker cp $TARGET1:/usr/app/events.log ./events2.log
}

function run_test() {
  python test.py ./agent/inputs/large_1M_events.log events1.log
  python test.py ./agent/inputs/large_1M_events.log events2.log
}

start
beforetime=$(date +%s)
RUN_STATS=$(run_bench)
aftertime=$(date +%s)
echo "Load file took $(($aftertime-$beforetime)) seconds"
copyevents
run_test
#clean_bench