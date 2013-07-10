#!/bin/bash
. functions

outputfile=hrt.txt

init_system
rmmod memguard
set_cpus "1 1 0 0"
enable_prefetcher

log_echo "llc:$llc_miss_evt arch:${archbit}bit"
log_echo "RMIN: $RMIN"

parse_bw_log()
{
    cat $1 | awk '{ print $2 }'
}

do_hrt_test()
{
    local master_schedopt="$2"
    local corun_schedopt="$3"
    local TMPFILE=$4
    killall -2 thr hrt bandwidth latency
    killall -9 cpuhog
    if [ "$1" = "cpuhog" ]; then
	log_echo "cpuhog"
	./cpuhog -c 1 $corun_schedopt &
    elif [ "$1" = "thr" ]; then
	log_echo "co-run w/ 'thr'"
	./thr -c 1 $corun_schedopt -t 1000000 -f bwlog.c1 &
    elif [ "$1" = "xorg" ]; then
	log_echo "shoud print to screen"
    fi
    # echo "[start]" > /sys/kernel/debug/tracing/trace_marker
    # echo "[finish]" > /sys/kernel/debug/tracing/trace_marker

    trace-cmd record -e sched:sched_switch \
	./hrt -c 0 -i 1000 -C 12 -I 10 $master_schedopt > $TMPFILE \
	|| error "exec failed"
    killall -2 thr hrt bandwidth latency cpuhog matrix
    killall -9 cpuhog
    print_settings
    sleep 1
    ./printstat.py --deadline=14 $TMPFILE >> $outputfile

    if [ "$1" = "thr" ]; then
	bwsum=0
	bwsum=`expr $bwsum + $(parse_bw_log bwlog.c1)`
	log_echo "Aggr.B/W: $bwsum"
	rm bwlog.*
    fi
    log_echo "------------"
}

test_isolation()
{
    rmmod memguard

    log_echo ">> no memguard"
    do_hrt_test xorg "-o fifo" "-o normal" /run/out-org-solo.txt >& /dev/null
    do_hrt_test xorg "-o fifo" "-o normal" /run/out-org.txt

    log_echo ">> memguard(excl0)"
    do_init_mb "900 200" 0 0  >& /dev/null
    do_hrt_test xorg "-o fifo" "-o normal" /run/out-excl0-solo.txt >& /dev/null
    do_hrt_test xorg "-o fifo" "-o normal" /run/out-excl0.txt

    log_echo ">> memguard(excl5)"
    do_init_mb "900 200" 1 5  >& /dev/null
    do_hrt_test xorg "-o fifo" "-o normal" /run/out-excl5-solo.txt >& /dev/null
    do_hrt_test xorg "-o fifo" "-o normal" /run/out-excl5.txt

    rmmod memguard
}

test_isolation
finish
