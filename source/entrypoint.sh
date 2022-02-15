#!/bin/bash

PORT=9997 

echo "waiting for test-system to launch and open up port: $PORT"
while ! nc -z splitter $PORT; do
  sleep 1 # wait for 1 second before check again
done

echo "test-system launched, port $PORT is now accessible ..."

cat /data/large_1M_events.log | nc -q0 splitter $PORT
cat /data/large_1M_events.log | nc -q0 splitter $PORT
cat /data/large_1M_events.log | nc -q0 splitter $PORT
cat /data/large_1M_events.log | nc -q0 splitter $PORT
