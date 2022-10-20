#!/bin/bash

export PATH=$HOME/bin:$PATH

plot()
{
    # file msut be xxx.dat form
    bench=$1
    start=$2
    finish=$3
    file="${bench}_${start}-${finish}"
    cat > ${file}.scr <<EOF
set terminal postscript eps enhanced color "Times-Roman" 22
set yrange [0:100000]
set xrange [$start:$finish]
plot '$bench.dat' ti "$bench" w l
EOF
    gnuplot ${file}.scr > ${file}.eps
    epspdf  ${file}.eps
}


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
	cat /sys/kernel/debug/tracing/trace > $b.trace
	parse_log $b.perf
	sync
    done
}


do_graph()
{
    echo "plotting graphs"
    for b in $benchb; do
	if [ -f "$b.trace" ]; then
	    cat $b.trace | grep "$corea\]" > $b.trace.core$corea
	    grep update_statistics $b.trace.core$corea | awk '{ print $7 }' | grep -v 184467440 > $b.dat
	    plot $b 5000 6000
	    plot $b 0 10000
#	    plot $b 0 100000
	else
	    echo "$b.trace doesn't exist"
	fi
    done
}

# print output

do_print()
{
    for b in $benchb; do
        f=$b.perf
        if [ -f "$f" ]; then
                cache=`grep $llc_miss_evt $f | awk '{ print $1 }'`
                instr=`grep instructions $f | awk '{ print $1 }'`
                elaps=`grep elapsed $f | awk '{ print $1 }'`
                echo ${f%.perf}, $cache, $instr
	else
	    echo "$b.perf doesn't exist"
        fi
    done
}

do_print_stat()
{
    for b in $benchb; do
	echo Stats for $b:
	./printstat.py $b.dat
	echo
    done
}

print_sysinfo()
{
    echo "Test CPU: $corea"
    echo "Benchmarks: $benchb"
}

benchb=$1
pid=125945

echo 2048 > /sys/kernel/debug/tracing/buffer_size_kb
rmmod memguard

insmod memguard.ko
#echo mb 1000 1000 1000 1000 1000 1000 1000 1000 > /sys/kernel/debug/memguard/limit
#echo mb 500 500 500 500 500 500 500 500 > /sys/kernel/debug/memguard/limit
#echo mb 1500 1500 1500 1500 1500 1500 1500 1500 > /sys/kernel/debug/memguard/limit
echo mb 2000 2000 2000 2000 2000 2000 2000 2000 > /sys/kernel/debug/memguard/limit
#echo mb 2200 2200 2200 2200 2200 2200 2200 2200 > /sys/kernel/debug/memguard/limit
#echo mb 2500 2500 2500 2500 2500 2500 2500 2500 > /sys/kernel/debug/memguard/limit

[ -z "$benchb" ] && error "Usage: $0 <benchmarks>"
corea=0
print_sysinfo
do_experiment "$benchb"
#do_graph
#do_print >> profile.txt
#do_print_stat >> bench.stat
