#!/bin/bash

taskset -c 0 sh memory_bandwidth_workload.sh 1 10 2 1 &
pid=$(ps -ef | grep './memory' | grep -v 'grep' | awk '{ printf $2 }')
sleep 5
echo $pid


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

# yes alone 2500 test
insmod memguard.ko
echo mb 2500 2500 2500 2500 2500 2500 2500 2500 > /sys/kernel/debug/memguard/limit
sleep 10
sh perf.sh yes_alone_2500_1 $pid
sleep 1
sh perf.sh yes_alone_2500_2 $pid
sleep 1
sh perf.sh yes_alone_2500_3 $pid
sleep 1
sh perf.sh yes_alone_2500_4 $pid
sleep 1
sh perf.sh yes_alone_2500_5 $pid
sleep 1
rmmod memguard

# yes alone 2000 test
insmod memguard.ko
echo mb 2000 2000 2000 2000 2000 2000 2000 2000 > /sys/kernel/debug/memguard/limit
sleep 10
sh perf.sh yes_alone_2000_1 $pid
sleep 1
sh perf.sh yes_alone_2000_2 $pid
sleep 1
sh perf.sh yes_alone_2000_3 $pid
sleep 1
sh perf.sh yes_alone_2000_4 $pid
sleep 1
sh perf.sh yes_alone_2000_5 $pid
sleep 1
rmmod memguard

# yes alone 1500 test
insmod memguard.ko
echo mb 1500 1500 1500 1500 1500 1500 1500 1500 > /sys/kernel/debug/memguard/limit
sleep 10
sh perf.sh yes_alone_1500_1 $pid
sleep 1
sh perf.sh yes_alone_1500_2 $pid
sleep 1
sh perf.sh yes_alone_1500_3 $pid
sleep 1
sh perf.sh yes_alone_1500_4 $pid
sleep 1
sh perf.sh yes_alone_1500_5 $pid
sleep 1
rmmod memguard

# yes alone 1000 test
insmod memguard.ko
echo mb 1000 1000 1000 1000 1000 1000 1000 1000 > /sys/kernel/debug/memguard/limit
sleep 10
sh perf.sh yes_alone_1000_1 $pid
sleep 1
sh perf.sh yes_alone_1000_2 $pid
sleep 1
sh perf.sh yes_alone_1000_3 $pid
sleep 1
sh perf.sh yes_alone_1000_4 $pid
sleep 1
sh perf.sh yes_alone_1000_5 $pid
sleep 1
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

# yes with 2500 test
insmod memguard.ko
echo mb 2500 2500 2500 2500 2500 2500 2500 2500 > /sys/kernel/debug/memguard/limit
sleep 10
sh perf.sh yes_with_2500_1 $pid
sleep 1
sh perf.sh yes_with_2500_2 $pid
sleep 1
sh perf.sh yes_with_2500_3 $pid
sleep 1
sh perf.sh yes_with_2500_4 $pid
sleep 1
sh perf.sh yes_with_2500_5 $pid
sleep 1
rmmod memguard

# yes with 2000 test
insmod memguard.ko
echo mb 2000 2000 2000 2000 2000 2000 2000 2000 > /sys/kernel/debug/memguard/limit
sleep 10
sh perf.sh yes_with_2000_1 $pid
sleep 1
sh perf.sh yes_with_2000_2 $pid
sleep 1
sh perf.sh yes_with_2000_3 $pid
sleep 1
sh perf.sh yes_with_2000_4 $pid
sleep 1
sh perf.sh yes_with_2000_5 $pid
sleep 1
rmmod memguard

# yes with 1500 test
insmod memguard.ko
echo mb 1500 1500 1500 1500 1500 1500 1500 1500 > /sys/kernel/debug/memguard/limit
sleep 10
sh perf.sh yes_with_1500_1 $pid
sleep 1
sh perf.sh yes_with_1500_2 $pid
sleep 1
sh perf.sh yes_with_1500_3 $pid
sleep 1
sh perf.sh yes_with_1500_4 $pid
sleep 1
sh perf.sh yes_with_1500_5 $pid
sleep 1
rmmod memguard

# yes with 1000 test
insmod memguard.ko
echo mb 1000 1000 1000 1000 1000 1000 1000 1000 > /sys/kernel/debug/memguard/limit
sleep 10
sh perf.sh yes_with_1000_1 $pid
sleep 1
sh perf.sh yes_with_1000_2 $pid
sleep 1
sh perf.sh yes_with_1000_3 $pid
sleep 1
sh perf.sh yes_with_1000_4 $pid
sleep 1
sh perf.sh yes_with_1000_5 $pid
sleep 1
rmmod memguard

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

