#!/bin/bash

taskset -c 0 sh memory_bandwidth_workload.sh 1 10 2 1 &
pid=$(ps -ef | grep './memory' | grep -v 'grep' | awk '{ printf $2 }')
sleep 5
echo $pid
rmmod memguard

# no alone test
sleep 1
sh perf.sh no_alone_1 $pid
sleep 1
sh perf.sh no_alone_2 $pid
sleep 1
sh perf.sh no_alone_3 $pid
sleep 1
sh perf.sh no_alone_4 $pid
sleep 1
sh perf.sh no_alone_5 $pid
sleep 1

taskset -c 4 sh memory_bandwidth_workload.sh 1 3 2 1 &
taskset -c 5 sh memory_bandwidth_workload.sh 1 3 2 1 &
taskset -c 6 sh memory_bandwidth_workload.sh 1 3 2 1 &
taskset -c 7 sh memory_bandwidth_workload.sh 1 3 2 1 &

# no with test
sleep 10
sh perf.sh no_with_1 $pid
sleep 1
sh perf.sh no_with_2 $pid
sleep 1
sh perf.sh no_with_3 $pid
sleep 1
sh perf.sh no_with_4 $pid
sleep 1
sh perf.sh no_with_5 $pid
sleep 1
