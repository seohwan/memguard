#!/bin/bash

export PATH=$HOME/bin:$PATH

# do experiment
do_experiment()
{
    if [ `whoami` != "root" ]; then
	error "root perm. is needed"
    fi

    # chrt -f -p 1 $$

    for b in $benchb; do
	echo $b
	echo "" > /sys/kernel/debug/tracing/trace
	perf stat -C $corea -p $pid -e instructions -e cycles -e l1d_cache_refill -e l2d_cache_refill -e l3d_cache_refill -o $b.perf &
	sleep 10
	kill -INT `ps x | grep perf | awk '{ print $1 }'`
	parse_log $b.perf
	sync
    done
}

print_sysinfo()
{
    echo "Test CPU: $corea"
    echo "Benchmarks: $benchb"
}

benchb=$1
pid=$2

echo 2048 > /sys/kernel/debug/tracing/buffer_size_kb
#rmmod memguard

#insmod memguard.ko
#echo mb 1000 1000 1000 1000 1000 1000 1000 1000 > /sys/kernel/debug/memguard/limit
#echo mb 500 500 500 500 500 500 500 500 > /sys/kernel/debug/memguard/limit
#echo mb 2000 2000 2000 2000 2000 2000 2000 2000 > /sys/kernel/debug/memguard/limit
#echo mb 2500 2500 2500 2500 2500 2500 2500 2500 > /sys/kernel/debug/memguard/limit

[ -z "$benchb" ] && error "Usage: $0 <benchmarks>"
corea=0
print_sysinfo
do_experiment "$benchb"
