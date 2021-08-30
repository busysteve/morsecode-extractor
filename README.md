# morsecode-extractor
Tools to pull Morse code out of a sound file or stream

Usage example:

From a file... :

ffmpeg -hide_banner -loglevel error -i 50Mhz-cw.wav -f s16le -acodec pcm_s16le - |\
./fftw3_stream 8000 50 3 200 1800 |\
awk -f cw-read-lines.awk |\
awk -f morsecode.awk



From a Pulse Audio microphone input... :

paplay --channels=1 --rate=8000 -r --raw --latency-msec=100 |\
./fftw3_stream 8000 50 1 1350 1450 |\
./cw-read-lines.awk |\
./morsecode.awk



The fftw3_stream parameters are as follows:

fftw3_stream [input sample rate] [slice segments] [levels to dig for tones] [tone center freq] [tone freq width]




Building fftw3_stream :

go to fftw.org and build and install their lib.  Then compile fftw3_stream.cpp as follows... 

g++ -std=c++11 -o fftw3_stream fftw3_stream.cpp -lfftw3 -lm


