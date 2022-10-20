#!/bin/bash

taskset -c 0 sh memory_bandwidth_workload.sh 1 10 2 1 &
pid=$(ps -ef | grep './memory' | grep -v 'grep' | awk '{ printf $2 }')
sleep 5
echo $pid
rmmod memguard


# yes alone 500 test
insmod memguard.ko
echo mb 500 500 500 500 500 500 500 500 > /sys/kernel/debug/memguard/limit
sleep 10
sh perf.sh yes_alone_500_1 $pid
sleep 1
sh perf.sh yes_alone_500_2 $pid
sleep 1
sh perf.sh yes_alone_500_3 $pid
sleep 1
sh perf.sh yes_alone_500_4 $pid
sleep 1
sh perf.sh yes_alone_500_5 $pid
sleep 1
rmmod memguard

taskset -c 4 sh memory_bandwidth_workload.sh 1 3 2 1 &
taskset -c 5 sh memory_bandwidth_workload.sh 1 3 2 1 &
taskset -c 6 sh memory_bandwidth_workload.sh 1 3 2 1 &
taskset -c 7 sh memory_bandwidth_workload.sh 1 3 2 1 &


# yes with 500 test
insmod memguard.ko
echo mb 500 500 500 500 500 500 500 500 > /sys/kernel/debug/memguard/limit
sleep 10
sh perf.sh yes_with_500_1 $pid
sleep 1
sh perf.sh yes_with_500_2 $pid
sleep 1
sh perf.sh yes_with_500_3 $pid
sleep 1
sh perf.sh yes_with_500_4 $pid
sleep 1
sh perf.sh yes_with_500_5 $pid
sleep 1
rmmod memguard
