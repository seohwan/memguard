#!/bin/bash

taskset -c 0 sh memory_bandwidth_workload.sh 1 10 2 1 &
pid=$(ps -ef | grep './memory' | grep -v 'grep' | awk '{ printf $2 }')
sleep 5
echo $pid
rmmod memguard

# yes alone 2200 test
insmod memguard.ko
echo mb 2200 2200 2200 2200 2200 2200 2200 2200 > /sys/kernel/debug/memguard/limit
sleep 10
sh perf.sh yes_alone_2200_1 $pid
sleep 1
sh perf.sh yes_alone_2200_2 $pid
sleep 1
sh perf.sh yes_alone_2200_3 $pid
sleep 1
sh perf.sh yes_alone_2200_4 $pid
sleep 1
sh perf.sh yes_alone_2200_5 $pid
sleep 1
rmmod memguard


taskset -c 4 sh memory_bandwidth_workload.sh 1 3 2 1 &
taskset -c 5 sh memory_bandwidth_workload.sh 1 3 2 1 &
taskset -c 6 sh memory_bandwidth_workload.sh 1 3 2 1 &
taskset -c 7 sh memory_bandwidth_workload.sh 1 3 2 1 &

# yes with 2200 test
insmod memguard.ko
echo mb 2200 2200 2200 2200 2200 2200 2200 2200 > /sys/kernel/debug/memguard/limit
sleep 10
sh perf.sh yes_with_2200_1 $pid
sleep 1
sh perf.sh yes_with_2200_2 $pid
sleep 1
sh perf.sh yes_with_2200_3 $pid
sleep 1
sh perf.sh yes_with_2200_4 $pid
sleep 1
sh perf.sh yes_with_2200_5 $pid
sleep 1
rmmod memguard


