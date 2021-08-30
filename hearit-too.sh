#!/bin/bash

sample_freq=$1
tone_freq=$2
tone_freq_width=$3





function trap_handle_ctrl_c ()
{
	echo ""
	echo ""
	echo "Caught Ctrl-c"	
	echo "killing sub-processes"
	
	kill $pid
	rm -rf $tmp_dir
	
	echo "Done."
	
	exit 0
}

trap "trap_handle_ctrl_c" 2

tmp_dir=$(mktemp -d)

mkfifo "$tmp_dir/stream"


paplay --channels=1 --rate=$sample_freq -r --raw --latency-msec=10 | tee $tmp_dir/stream | ./fftw3_stream $sample_freq 50 1 $tone_freq $tone_freq_width | ./cw-read-lines.awk | ./morsecode.awk  & pid=$!

cat $tmp_dir/stream | paplay --channels=1 --rate=$sample_freq -p --raw --latency-msec=10 > /dev/null 

rm -rf $tmp_dir


