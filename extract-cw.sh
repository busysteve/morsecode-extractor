./readwav multi-cw.wav - | ./fftw3_stream 8000 50 3 200 1800 | awk -f cw-read-lines.awk
