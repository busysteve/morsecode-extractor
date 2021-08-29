./readwav 20000217_082424.wav - | ./Biquad -F s16 -r 8000 -f 1500 -t bandpass | ffmpeg -f s16le -ar 8k -ac 1 -i pipe:0 sound.wav
