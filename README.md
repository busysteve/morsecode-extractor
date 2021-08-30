# morsecode-extractor
Tools to pull Morse code out of a sound file or stream

Usage example:

ffmpeg -hide_banner -loglevel error -i 50Mhz-cw.wav -f s16le -acodec pcm_s16le - |\
./fftw3_stream 8000 50 3 200 1800 |\
awk -f cw-read-lines.awk |\
awk -f morsecode.awk


The fftw3_stream parameters are as follows:

fftw3_stream [input sample rate] [slice segments] [levels to dig for tones] [tone min freq] [tone max freq]


