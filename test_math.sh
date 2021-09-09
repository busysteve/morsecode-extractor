echo -n "Message: "


./ffwav2raw.sh $1 | ./fftw3_stream 8000 80 1 $2 $3 $4 0.0 0 | ./sift-peak.awk | ./post-peaks.awk  | ./queue_for_nn_input.awk | ./normalize.awk | ./comp.awk | ./interpret.awk | ./morsecode.awk


echo "./ffwav2raw.sh $1 | ./fftw3_stream 8000 80 1 $2 $3 $4 0.0 0 | ./sift-peak.awk | ./post-peaks.awk  | ./queue_for_nn_input.awk | ./normalize.awk | ./comp.awk | ./interpret.awk | ./morsecode.awk"

#./ffwav2raw.sh $1 | ./fftw3_stream 8000 80 1 600 100 0.15 .0 0 | ./sift-peak.awk | ./post-peaks.awk  | ./queue_for_nn_input.awk | ./normalize.awk | ./comp.awk | ./morsecode-nn | ./morsecode.awk
