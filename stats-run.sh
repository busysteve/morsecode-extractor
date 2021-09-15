#!/bin/bash

CW_DEEP=$1; 

echo ""

cmd="./ffwav2raw.sh 50.wav | ./fftw3_stream 8000 80 1 600 80 $2 0.0 0 | ./sift-peak.awk | ./post-peaks.awk | ./queue_for_nn_input.awk | ./normalize.awk | ./comp.awk | ./interpret.awk | ./morsecode.awk"

echo $cmd

echo -n $1 "  :  " $2   "   :  "

eval " $cmd"

echo ""

