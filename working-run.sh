paplay --channels=1 --rate=8000 -r --raw --latency-msec=100 | ./fftw3_stream 8000 50 1 1440 20 | ./cw-read-lines.awk | ./morsecode.awk
