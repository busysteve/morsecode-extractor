./readwav 20000217_082424.wav - | ./Biquad -F s16 -r 8000 -f 1500 -t bandpass -l 20 | ./fftw3_stream 8000 100
